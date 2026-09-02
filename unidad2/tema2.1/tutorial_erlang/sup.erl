%% =====================================================================
%% Programa:    sup.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tutorial consolidado de Erlang — Nivel 3 · Supervisor one_for_one
%% Fecha:       2026-09-01
%% Verificado:  OTP 25 (apt) y OTP 26.2.5 (kerl) en nodo AWS Academy t4g.large
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).
start_link() -> supervisor:start_link({local, sup}, ?MODULE, []).
init([]) ->
  Flags = #{strategy => one_for_one, intensity => 5, period => 10},
  Child = #{id => w, start => {w, start_link, []},
            restart => permanent, shutdown => 5000,
            type => worker, modules => [w]},
  {ok, {Flags, [Child]}}.
