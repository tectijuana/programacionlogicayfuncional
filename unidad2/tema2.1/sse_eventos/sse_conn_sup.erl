%% Un hijo temporal por navegador conectado: si uno falla, ningun otro cliente se entera.
-module(sse_conn_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {#{strategy => simple_one_for_one, intensity => 100, period => 1},
          [#{id => sse_conn, start => {sse_conn, start_link, []}, restart => temporary}]}}.
