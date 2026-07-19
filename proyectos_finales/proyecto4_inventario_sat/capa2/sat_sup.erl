%% =====================================================================
%% Programa:    sat_sup.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Proyecto Final P4 — Inventario SAT, capa 2
%% Fecha:       2026-07-18
%% Descripción: Supervisor de los GenServers del inventario
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
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
