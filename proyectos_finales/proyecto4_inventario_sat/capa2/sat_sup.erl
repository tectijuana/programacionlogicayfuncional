-module(sat_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Estrategia = #{
        strategy  => one_for_one,
        intensity => 5,
        period    => 30
    },
    Hijos = [
        #{
            id       => inventario_server,
            start    => {inventario_server, start_link, []},
            restart  => permanent,
            shutdown => 5000,
            type     => worker,
            modules  => [inventario_server]
        }
    ],
    {ok, {Estrategia, Hijos}}.
