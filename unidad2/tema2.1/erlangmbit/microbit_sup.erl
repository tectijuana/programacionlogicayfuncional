-module(microbit_sup).
-behaviour(supervisor).
-export([start_link/1, init/1]).

start_link(Fuente) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Fuente).

init(Fuente) ->
    Flags = #{strategy => one_for_one, intensity => 5, period => 60},
    Hijo  = #{id => microbit_srv,
              start => {microbit_srv, start_link, [Fuente]},
              restart => permanent},
    {ok, {Flags, [Hijo]}}.
