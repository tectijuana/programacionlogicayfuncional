%% sse_conn: UN proceso por conexion de navegador (el modelo de actores en accion).
%%   GET /          -> index.html
%%   GET /polling   -> JSON con los ultimos eventos (la forma "vieja", para comparar)
%%   GET /stream    -> text/event-stream: la conexion queda abierta y el servidor empuja eventos.
%% Si el navegador se reconecta manda `Last-Event-ID`; se reenvian los eventos que se perdio.
-module(sse_conn).
-export([start_link/1, init/1]).

-define(GRUPO, sse).
-define(PING_MS, 15000).

start_link(Sock) -> {ok, proc_lib:spawn_link(?MODULE, init, [Sock])}.

init(Sock) ->
    receive {listo, Sock} -> ok after 5000 -> exit(normal) end,    %% el socket ya es nuestro
    peticion(Sock).

peticion(Sock) ->
    case gen_tcp:recv(Sock, 0, 5000) of
        {ok, {http_request, 'GET', {abs_path, Ruta}, _}} ->
            [Path | _] = binary:split(Ruta, <<"?">>),
            cabeceras(Sock, Path, #{});
        _ -> gen_tcp:close(Sock)
    end.

cabeceras(Sock, Path, H) ->
    case gen_tcp:recv(Sock, 0, 5000) of
        {ok, {http_header, _, Nombre, _, Valor}} ->
            cabeceras(Sock, Path, H#{string:lowercase(a_bin(Nombre)) => Valor});
        {ok, http_eoh} -> responder(Sock, Path, H);
        _ -> gen_tcp:close(Sock)
    end.

responder(Sock, <<"/stream">>, H) ->
    Ultimo = last_id(maps:get(<<"last-event-id">>, H, <<"0">>)),
    ok = gen_tcp:send(Sock, ["HTTP/1.1 200 OK\r\nContent-Type: text/event-stream\r\n"
                             "Cache-Control: no-cache\r\nConnection: keep-alive\r\n\r\n"
                             "retry: 2000\n\n"]),
    ok = pg:join(?GRUPO, self()),                              %% primero suscribirse...
    Ultimo1 = lists:foldl(fun(Ev = {Id, _, _}, _) -> enviar(Sock, Ev), Id end,
                          Ultimo, sse_hub:desde(Ultimo)),      %% ...luego reponer lo perdido
    ok = inet:setopts(Sock, [{packet, raw}, {active, once}]),  %% para enterarnos si cierra
    bucle(Sock, Ultimo1);
responder(Sock, <<"/polling">>, _) ->
    Evs = [json:decode(J) || {_, _, J} <- sse_hub:ultimos(10)],
    corto(Sock, "application/json", json:encode(Evs));
responder(Sock, <<"/">>, _) ->
    Archivo = filename:join(filename:dirname(code:which(?MODULE)), "index.html"),
    case file:read_file(Archivo) of
        {ok, Html} -> corto(Sock, "text/html; charset=utf-8", Html);
        {error, _} -> corto(Sock, "text/plain", <<"falta index.html">>)
    end;
responder(Sock, _, _) -> corto(Sock, "text/plain", <<"404">>).

bucle(Sock, Ultimo) ->
    receive
        {sse, Ev = {Id, _, _}} when Id > Ultimo -> enviar(Sock, Ev), bucle(Sock, Id);
        {sse, _} -> bucle(Sock, Ultimo);                       %% duplicado de la reposicion
        {tcp_closed, Sock} -> ok;
        {tcp_error, Sock, _} -> ok
    after ?PING_MS ->
        ok = enviar_crudo(Sock, ": ping\n\n"),                 %% mantiene viva la conexion
        bucle(Sock, Ultimo)
    end.

enviar(Sock, {Id, Tipo, Json}) ->
    enviar_crudo(Sock, ["id: ", integer_to_list(Id), "\nevent: ", atom_to_list(Tipo),
                        "\ndata: ", Json, "\n\n"]).

%% Si el cliente ya se fue, el proceso termina en silencio (el supervisor no lo reinicia).
enviar_crudo(Sock, Datos) ->
    case gen_tcp:send(Sock, Datos) of
        ok -> ok;
        {error, _} -> exit(normal)
    end.

corto(Sock, Tipo, Cuerpo) ->
    Bin = iolist_to_binary(Cuerpo),
    gen_tcp:send(Sock, ["HTTP/1.1 200 OK\r\nContent-Type: ", Tipo, "\r\nCache-Control: no-store\r\n"
                        "Connection: close\r\nContent-Length: ", integer_to_list(byte_size(Bin)),
                        "\r\n\r\n", Bin]),
    gen_tcp:close(Sock).

a_bin(A) when is_atom(A) -> atom_to_binary(A);
a_bin(B) when is_binary(B) -> B.

last_id(Bin) ->
    try binary_to_integer(Bin) catch error:badarg -> 0 end.
