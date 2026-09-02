%% =====================================================================
%% Programa:    w.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tutorial consolidado de Erlang — Nivel 3 · Worker gen_server que puede caer
%% Fecha:       2026-09-01
%% Verificado:  OTP 25 (apt) y OTP 26.2.5 (kerl) en nodo AWS Academy t4g.large
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(w).
-behaviour(gen_server).
-export([start_link/0, crash/0, ping/0]).
-export([init/1, handle_call/3, handle_cast/2]).
start_link() -> gen_server:start_link({local, w}, ?MODULE, [], []).
crash()      -> gen_server:cast(w, crash).
ping()       -> gen_server:call(w, ping).
init([])                  -> {ok, 0}.
handle_cast(crash, _S)    -> erlang:error(boom).
handle_call(ping, _F, S)  -> {reply, {pong, S}, S}.
