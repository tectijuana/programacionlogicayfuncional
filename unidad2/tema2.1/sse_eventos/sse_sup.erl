-module(sse_sup).
-behaviour(supervisor).
-export([start_link/1, init/1]).

start_link(Puerto) -> supervisor:start_link({local, ?MODULE}, ?MODULE, Puerto).

init(Puerto) ->
    {ok, {#{strategy => one_for_one, intensity => 5, period => 10},
          [#{id => pg,        start => {pg, start_link, []}},
           #{id => hub,       start => {sse_hub, start_link, []}},
           #{id => conn_sup,  start => {sse_conn_sup, start_link, []}, type => supervisor},
           #{id => acceptor,  start => {sse_acceptor, start_link, [Puerto]}},
           #{id => productor, start => {productor, start_link, []}}]}}.
