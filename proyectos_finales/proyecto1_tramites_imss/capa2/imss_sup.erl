%% =====================================================================
%% Programa:    imss_sup.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Proyecto Final P1 — Trámites IMSS, capa 2
%% Fecha:       2026-07-18
%% Descripción: Supervisor one_for_one de los GenServers del IMSS
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
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
