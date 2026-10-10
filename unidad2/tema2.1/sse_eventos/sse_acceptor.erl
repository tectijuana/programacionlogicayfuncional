%% sse_acceptor: acepta conexiones TCP y le entrega cada socket a un sse_conn supervisado.
-module(sse_acceptor).
-export([start_link/1, init/1]).

start_link(Puerto) -> {ok, proc_lib:spawn_link(?MODULE, init, [Puerto])}.

init(Puerto) ->
    {ok, L} = gen_tcp:listen(Puerto, [binary, {reuseaddr, true}, {active, false},
                                      {packet, http_bin}]),
    io:format("SSE: http://localhost:~b~n", [Puerto]),
    aceptar(L).

aceptar(L) ->
    {ok, Sock} = gen_tcp:accept(L),
    {ok, Pid} = supervisor:start_child(sse_conn_sup, [Sock]),
    ok = gen_tcp:controlling_process(Sock, Pid),
    Pid ! {listo, Sock},
    aceptar(L).
