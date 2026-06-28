-module(imss_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Estrategia = #{
        strategy  => one_for_one,
        intensity => 5,
        period    => 10
    },
    Hijos = [
        #{
            id       => tramite_server,
            start    => {tramite_server, start_link, []},
            restart  => permanent,
            shutdown => 5000,
            type     => worker,
            modules  => [tramite_server]
        }
    ],
    {ok, {Estrategia, Hijos}}.
