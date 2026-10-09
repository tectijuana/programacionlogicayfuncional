%% central: centro de monitoreo Y MANDO (arquitectura centralizada).
%%   Telemetria  semi -> central : "ID|lat|lon|kmh|estado"        (UDP, 1/s)
%%   Comando     central -> semi : "CMD|Seq|accion|texto"          (al ip:puerto de origen)
%%   Acuse       semi -> central : "ACK|ID|Seq"
%%   Prueba red  cualquiera      : "PING" -> "PONG"
%% Decision de diseno: el MANDO es centralizado (una sola fuente de verdad: esta ETS y la
%% bitacora de eventos); la EJECUCION es descentralizada (cada semi es autonomo: si la
%% central cae sigue su ruta, y al volver se re-sincroniza en 1 s con la siguiente telemetria).
%% Los comandos son confiables sobre UDP: retransmision cada 1 s hasta 5 veces o hasta ACK.
-module(central).
-behaviour(gen_server).
-export([start_link/0, flota/0, paquetes/0, eventos/0, ordenar/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

-define(PUERTO, 5000).
-define(RADIO_KM, 400).          %% semis a avisar cuando hay un SOS
-define(SIN_SENAL_S, 5).
-define(REINTENTO_MS, 1000).
-define(MAX_INTENTOS, 5).

-record(c, {sock, n = 0, seq = 0, dirs = #{}, pend = #{}, perdidos = sets:new()}).

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

flota()    -> lists:sort(ets:tab2list(flota)).
paquetes() -> gen_server:call(?MODULE, paquetes).

%% Ultimos eventos (mas reciente primero).
eventos() -> lists:reverse(ets:tab2list(eventos)).

%% Accion: detener | reanudar | aviso (Texto se muestra en el LED del micro:bit)
ordenar(Id, Accion, Texto) -> gen_server:cast(?MODULE, {ordenar, Id, Accion, Texto}).

init([]) ->
    ets:new(flota, [named_table, public, {keypos, 1}]),
    ets:new(calidad, [named_table, public]),          %% {Id, Seq, Hdop10, Sats}
    ets:new(eventos, [named_table, public, ordered_set]),
    {ok, Sock} = gen_udp:open(?PUERTO, [binary, {active, true}, {recbuf, 1048576}]),
    erlang:send_after(2000, self(), barrido),
    {ok, #c{sock = Sock}}.

handle_call(paquetes, _, S = #c{n = N}) -> {reply, N, S};
handle_call(_, _, S) -> {reply, ok, S}.

handle_cast({ordenar, Id, Accion, Texto}, S) -> {noreply, enviar_cmd(Id, Accion, Texto, S)};
handle_cast(_, S) -> {noreply, S}.

handle_info({udp, _, Ip, Puerto, <<"PING">>}, S = #c{sock = Sock}) ->
    gen_udp:send(Sock, Ip, Puerto, <<"PONG">>),
    {noreply, S};
handle_info({udp, _, _, _, <<"ACK|", Resto/binary>>}, S = #c{pend = P}) ->
    try [Id, Seq] = [binary_to_integer(X) || X <- binary:split(Resto, <<"|">>)],
        case maps:take({Id, Seq}, P) of
            {{_, _, Accion, _}, P2} ->
                evento(ack, Id, atom_to_list(Accion)),
                {noreply, S#c{pend = P2}};
            error -> {noreply, S}
        end
    catch _:_ -> {noreply, S}
    end;
handle_info({udp, _, Ip, Puerto, Bin}, S0 = #c{n = N, dirs = D}) ->
    %% Paquete malformado (o inyectado): se descarta, la central no se cae.
    case fix:parsear(Bin) of
        {ok, F = #{id := Id}} ->
            Previo = previo(Id),
            case fix:evaluar(F, Previo) of
                {descartar, Razon} ->
                    evento(descartado, Id, atom_to_list(Razon)),
                    {noreply, S0};
                {ok, Veredicto} ->
                    S1 = S0#c{n = N + 1, dirs = D#{Id => {Ip, Puerto}}},
                    {noreply, aceptar(F, Veredicto, Previo, S1)}
            end;
        error -> {noreply, S0}
    end;
handle_info({reintento, Id, Seq}, S = #c{pend = P}) ->
    case maps:find({Id, Seq}, P) of
        error -> {noreply, S};                                   %% ya hubo ACK
        {ok, {Intentos, _, Accion, _}} when Intentos >= ?MAX_INTENTOS ->
            evento(cmd_fallido, Id, atom_to_list(Accion)),
            {noreply, S#c{pend = maps:remove({Id, Seq}, P)}};
        {ok, {Intentos, Bin, Accion, Texto}} ->
            reenviar(Id, Bin, S),
            erlang:send_after(?REINTENTO_MS, self(), {reintento, Id, Seq}),
            {noreply, S#c{pend = P#{{Id, Seq} => {Intentos + 1, Bin, Accion, Texto}}}}
    end;
handle_info(barrido, S = #c{perdidos = Pd}) ->
    erlang:send_after(2000, self(), barrido),
    Ahora = erlang:system_time(second),
    Nuevos = [Id || {Id, _, _, _, _, T} <- ets:tab2list(flota),
                    Ahora - T > ?SIN_SENAL_S, not sets:is_element(Id, Pd)],
    [evento(perdido, Id, "") || Id <- Nuevos],
    {noreply, S#c{perdidos = sets:union(Pd, sets:from_list(Nuevos))}};
handle_info(_, S) -> {noreply, S}.

previo(Id) ->
    case {ets:lookup(flota, Id), ets:lookup(calidad, Id)} of
        {[{_, La, Lo, _, _, _}], [{_, Seq, _, _}]} -> #{seq => Seq, lat => La, lon => Lo};
        _ -> undefined
    end.

%% Guarda el fix aceptado. sin_fix conserva la ultima posicion buena (no se inventa una).
aceptar(#{id := Id, seq := Seq, lat := La0, lon := Lo0, kmh := V, hdop10 := H, sats := Sats,
          estado := Estado}, Veredicto, Previo, S = #c{perdidos = Pd}) ->
    {La, Lo} = case {Veredicto, Previo} of
                   {sin_fix, #{lat := PLa, lon := PLo}} -> {PLa, PLo};
                   _ -> {La0, Lo0}
               end,
    PrevEstado = case ets:lookup(flota, Id) of [{_, _, _, _, E, _}] -> E; [] -> nuevo end,
    ets:insert(flota, {Id, La, Lo, V, Estado, erlang:system_time(second)}),
    ets:insert(calidad, {Id, Seq, H, Sats}),
    case Veredicto of
        N when is_integer(N), N > 0 -> evento(huecos, Id, integer_to_list(N) ++ " fixes perdidos");
        reinicio -> evento(reinicio, Id, "seq reiniciado");
        sin_fix -> evento(sin_fix, Id, io_lib:format("~b satelites", [Sats]));
        _ -> ok
    end,
    S1 = case sets:is_element(Id, Pd) of
             true -> evento(recuperado, Id, ""), S#c{perdidos = sets:del_element(Id, Pd)};
             false -> S
         end,
    reaccion(PrevEstado, Estado, Id, La, Lo, S1).

%% --- Politica de mando: que hace la central cuando ocurre un comportamiento ---
reaccion(Previo, sos, Id, La, Lo, S0) when Previo =/= sos ->
    io:format("!! SOS semi ~b en ~.4f,~.4f~n", [Id, La, Lo]),
    evento(sos, Id, io_lib:format("~.4f,~.4f", [La, Lo])),
    S1 = enviar_cmd(Id, aviso, "SOS RECIBIDO", S0),
    Cercanos = [J || {J, La2, Lo2, _, _, _} <- ets:tab2list(flota), J =/= Id,
                     km({La, Lo}, {La2, Lo2}) =< ?RADIO_KM],
    lists:foldl(fun(J, Sx) -> enviar_cmd(J, aviso, "SOS semi " ++ integer_to_list(Id), Sx) end,
                S1, Cercanos);
reaccion(_, _, _, _, _, S) -> S.

enviar_cmd(Id, Accion, Texto, S = #c{dirs = D, pend = P, seq = Q}) ->
    case maps:find(Id, D) of
        error -> evento(cmd_fallido, Id, "semi desconocido"), S;
        {ok, _} ->
            Seq = Q + 1,
            Bin = iolist_to_binary(io_lib:format("CMD|~b|~s|~s", [Seq, Accion, Texto])),
            reenviar(Id, Bin, S),
            erlang:send_after(?REINTENTO_MS, self(), {reintento, Id, Seq}),
            S#c{seq = Seq, pend = P#{{Id, Seq} => {1, Bin, Accion, Texto}}}
    end.

reenviar(Id, Bin, #c{sock = Sock, dirs = D}) ->
    case maps:find(Id, D) of
        {ok, {Ip, Puerto}} -> gen_udp:send(Sock, Ip, Puerto, Bin);
        error -> ok
    end.

evento(Tipo, Id, Detalle) ->
    ets:insert(eventos, {{erlang:system_time(millisecond), erlang:unique_integer([monotonic])},
                         Tipo, Id, lists:flatten(Detalle)}),
    case ets:info(eventos, size) of
        N when N > 200 -> ets:delete(eventos, ets:first(eventos));
        _ -> ok
    end.

km({La1, Lo1}, {La2, Lo2}) ->
    R = math:pi() / 180,
    A = math:pow(math:sin((La2 - La1) * R / 2), 2) +
        math:cos(La1 * R) * math:cos(La2 * R) * math:pow(math:sin((Lo2 - Lo1) * R / 2), 2),
    12742 * math:asin(math:sqrt(A)).
