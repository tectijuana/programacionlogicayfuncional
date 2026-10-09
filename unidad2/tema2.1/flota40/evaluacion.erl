%% evaluacion: mide la flota (corre en el nodo central, con los semiN@host ya lanzados).
%%   erl -sname central -setcookie flota -pa .   ->   flota:central(), evaluacion:correr(40).
-module(evaluacion).
-export([correr/1]).

correr(N) ->
    [_, Host] = string:split(atom_to_list(node()), "@"),
    Nodos = [list_to_atom("semi" ++ integer_to_list(I) ++ "@" ++ Host) || I <- lists:seq(1, N)],
    Vivos = [Nd || Nd <- Nodos, net_adm:ping(Nd) =:= pong],
    linea("nodos Erlang alcanzables", io_lib:format("~b / ~b", [length(Vivos), N])),
    timer:sleep(5000),                                   %% regimen estable

    %% 1. Rendimiento: telemetria recibida vs esperada (1 paquete/s por semi) en 10 s
    P0 = central:paquetes(), timer:sleep(10000), P1 = central:paquetes(),
    linea("telemetria 10 s", io_lib:format("~b paquetes (esperados ~b, entrega ~.1f%)",
                                           [P1 - P0, N * 10, 100 * (P1 - P0) / (N * 10)])),

    %% 2. Latencia de mando: boton B (SOS) en 5 nodos -> evento sos y ACK del aviso
    Lat = [latencia_sos(Id, Host) || Id <- lists:sublist(lists:seq(1, N), 5)],
    {Sos, Ack} = lists:unzip([L || L <- Lat, is_tuple(L)]),
    linea("SOS -> evento en central (ms)", io_lib:format("~p", [Sos])),
    linea("SOS -> ACK del micro:bit (ms)", io_lib:format("~p", [Ack])),

    %% 3. Tolerancia a fallas: matar un nodo completo
    Victima = lists:last(Vivos), Id = id_de(Victima),
    T0 = erlang:monotonic_time(millisecond),
    rpc:cast(Victima, erlang, halt, []),
    Det = esperar(fun() -> hay_evento(perdido, Id, T0) end, 15000),
    linea(io_lib:format("caida nodo ~b -> evento 'perdido' (ms)", [Id]), io_lib:format("~p", [Det])),
    linea("central sigue viva", io_lib:format("~p", [is_pid(whereis(central))])),

    %% 4. Recursos
    Mem = [M || {ok, M} <- [rpc_mem(Nd) || Nd <- Vivos -- [Victima]]],
    linea("memoria por nodo semi (MB)", io_lib:format("prom ~.1f  max ~.1f",
          [lists:sum(Mem) / max(1, length(Mem)) / 1048576, lists:max([0 | Mem]) / 1048576])),
    linea("memoria central (MB)", io_lib:format("~.1f", [erlang:memory(total) / 1048576])),
    linea("cola de mensajes central", io_lib:format("~p", [process_info(whereis(central), message_queue_len)])),
    ok.

latencia_sos(Id, Host) ->
    Nd = list_to_atom("semi" ++ integer_to_list(Id) ++ "@" ++ Host),
    T0 = erlang:monotonic_time(millisecond),
    rpc:call(Nd, semi_serial, boton, [Id, b]),
    S = esperar(fun() -> hay_evento(sos, Id, T0) end, 8000, T0),
    A = esperar(fun() -> hay_evento(ack, Id, T0) end, 8000, T0),
    rpc:call(Nd, semi_serial, boton, [Id, b]),            %% sale del SOS para la siguiente prueba
    timer:sleep(1500),
    {S, A}.

%% Eventos con timestamp (ms de reloj de pared) posterior a T0 (monotonico) -> comparar contra "ahora".
hay_evento(Tipo, Id, T0) ->
    Corte = erlang:system_time(millisecond) - (erlang:monotonic_time(millisecond) - T0),
    lists:any(fun({{T, _}, Ti, I, _}) -> Ti =:= Tipo andalso I =:= Id andalso T >= Corte end,
              central:eventos()).

esperar(Cond, Max) -> esperar(Cond, Max, erlang:monotonic_time(millisecond)).
esperar(Cond, Max, T0) ->
    case Cond() of
        true -> erlang:monotonic_time(millisecond) - T0;
        false ->
            case erlang:monotonic_time(millisecond) - T0 > Max of
                true -> timeout;
                false -> timer:sleep(50), esperar(Cond, Max, T0)
            end
    end.

rpc_mem(Nd) ->
    case rpc:call(Nd, erlang, memory, [total], 2000) of
        M when is_integer(M) -> {ok, M};
        _ -> error
    end.

id_de(Nd) ->
    [Pref | _] = string:split(atom_to_list(Nd), "@"),
    list_to_integer(lists:nthtail(4, Pref)).

linea(K, V) -> io:format("~-42s ~s~n", [lists:flatten(K), lists:flatten(V)]).
