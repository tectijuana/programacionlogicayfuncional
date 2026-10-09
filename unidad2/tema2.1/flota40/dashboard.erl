%% dashboard: servidor HTTP minimo (gen_tcp) que lee la tabla ETS de la central.
%%   GET /            -> dashboard.html (mapa Leaflet + tabla)
%%   GET /flota.json  -> posiciones actuales
%% Lee ETS directo: no molesta a la central (ver central:flota/0).
-module(dashboard).
-export([start_link/0, init/0]).

-define(PUERTO, 8080).
-define(DEAD_S, 5).             %% sin reporte en 5 s -> "sin senal"

start_link() -> {ok, proc_lib:spawn_link(?MODULE, init, [])}.

init() ->
    {ok, L} = gen_tcp:listen(?PUERTO, [binary, {reuseaddr, true}, {active, false},
                                       {packet, http_bin}]),
    io:format("dashboard: http://0.0.0.0:~b~n", [?PUERTO]),
    aceptar(L).

aceptar(L) ->
    case gen_tcp:accept(L) of
        {ok, S} ->
            Pid = spawn(fun() -> atender(S) end),
            gen_tcp:controlling_process(S, Pid),
            aceptar(L);
        {error, _} -> exit(listen_cerrado)
    end.

atender(S) ->
    receive after 10 -> ok end,
    case gen_tcp:recv(S, 0, 5000) of
        {ok, {http_request, 'GET', {abs_path, Ruta}, _}} -> responder(S, Ruta);
        _ -> ok
    end,
    gen_tcp:close(S).

responder(S, <<"/flota.json">>) -> enviar(S, "application/json", json());
responder(S, <<"/eventos.json">>) ->
    Ev = [#{hora => T, tipo => Tipo, id => Id, detalle => iolist_to_binary(Det)}
          || {{T, _}, Tipo, Id, Det} <- lists:sublist(central:eventos(), 40)],
    enviar(S, "application/json", iolist_to_binary(json:encode(Ev)));
responder(S, <<"/">>) ->
    Archivo = filename:join(filename:dirname(code:which(?MODULE)), "dashboard.html"),
    case file:read_file(Archivo) of
        {ok, Html} -> enviar(S, "text/html; charset=utf-8", Html);
        {error, _} -> enviar(S, "text/plain", <<"falta dashboard.html">>)
    end;
responder(S, _) -> enviar(S, "text/plain", <<"404">>, "404 Not Found").

enviar(S, Tipo, Cuerpo) -> enviar(S, Tipo, Cuerpo, "200 OK").
enviar(S, Tipo, Cuerpo, Estado) ->
    gen_tcp:send(S, ["HTTP/1.0 ", Estado, "\r\nContent-Type: ", Tipo,
                     "\r\nCache-Control: no-store\r\nContent-Length: ",
                     integer_to_list(iolist_size(Cuerpo)), "\r\n\r\n", Cuerpo]).

json() ->
    Ahora = erlang:system_time(second),
    Filas = [#{id => I, lat => La, lon => Lo, kmh => V, estado => estado(E, T, Ahora),
               edad => Ahora - T, hdop => hdop(I), sats => sats(I)}
             || {I, La, Lo, V, E, T} <- central:flota()],
    iolist_to_binary(json:encode(#{paquetes => central:paquetes(), semis => Filas})).

estado(_, T, Ahora) when Ahora - T > ?DEAD_S -> sin_senal;
estado(E, _, _) -> E.

hdop(I) -> case ets:lookup(calidad, I) of [{_, _, H, _}] -> H / 10; [] -> null end.
sats(I) -> case ets:lookup(calidad, I) of [{_, _, _, N}] -> N; [] -> null end.
