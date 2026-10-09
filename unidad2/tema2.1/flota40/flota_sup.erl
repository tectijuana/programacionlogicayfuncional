%% Arbol de supervision: central + dashboard + N semis. one_for_one: si muere un semi,
%% solo ese se reinicia (aislamiento de fallas, "let it crash").
%% Modo: todo (demo en una BEAM) | central (servidor) | semis (PC de alumno)
-module(flota_sup).
-behaviour(supervisor).
-export([start_link/1, start_link/2, start_link/3, init/1]).

start_link(N) -> start_link(N, []).
start_link(N, Seriales) -> start_link(N, Seriales, todo).

%% Seriales = [{Id, Fuente}] : micro:bits fisicos (ver semi_serial)
start_link(N, Seriales, Modo) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, {N, Seriales, Modo}).

init({N, Seriales, Modo}) ->
    Flags = #{strategy => one_for_one, intensity => 50, period => 10},
    Servidor = case Modo of
        semis -> [];
        _ -> [#{id => central, start => {central, start_link, []}},
              #{id => dashboard, start => {dashboard, start_link, []}}]
    end,
    Semis = case Modo of
        central -> [];
        _ -> [#{id => {semi, I}, start => {semi, start_link, [I]}} || I <- lists:seq(1, N)]
             ++ [#{id => {serial, I}, start => {semi_serial, start_link, [I, F]}}
                 || {I, F} <- Seriales]
    end,
    {ok, {Flags, Servidor ++ Semis}}.
