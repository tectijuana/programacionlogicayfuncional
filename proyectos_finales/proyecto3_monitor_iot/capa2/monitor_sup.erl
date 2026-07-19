%% =====================================================================
%% Programa:    monitor_sup.erl
%% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Proyecto Final P3 — Monitor IoT CENAPRED, capa 2
%% Fecha:       2026-07-18
%% Descripción: Supervisor con reinicio automático de sensores
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(monitor_sup).
-behaviour(supervisor).

-export([start_link/0, agregar_sensor/1, pid_sensor/1]).
-export([init/1]).

-define(SENSORES, [sismico, temperatura, humedad, co2, presion]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% agregar_sensor/1 — inicia dinámicamente un nuevo sensor
agregar_sensor(Tipo) ->
    Spec = #{
        id       => Tipo,
        start    => {sensor_server, start_link, [Tipo]},
        restart  => permanent,
        shutdown => 5000,
        type     => worker,
        modules  => [sensor_server]
    },
    supervisor:start_child(?MODULE, Spec).

%% pid_sensor/1 — retorna el Pid del sensor por tipo
pid_sensor(Tipo) ->
    Children = supervisor:which_children(?MODULE),
    case lists:keyfind(Tipo, 1, Children) of
        {Tipo, Pid, _, _} -> {ok, Pid};
        false              -> {error, no_encontrado}
    end.

init([]) ->
    Estrategia = #{
        strategy  => one_for_one,
        intensity => 10,
        period    => 60
    },
    %% Iniciar los 5 sensores como hijos del supervisor
    Hijos = [spec_sensor(T) || T <- ?SENSORES],
    {ok, {Estrategia, Hijos}}.

spec_sensor(Tipo) ->
    #{
        id       => Tipo,
        start    => {sensor_server, start_link, [Tipo]},
        restart  => permanent,
        shutdown => 5000,
        type     => worker,
        modules  => [sensor_server]
    }.
