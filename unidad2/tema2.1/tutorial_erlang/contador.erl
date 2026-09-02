%% =====================================================================
%% Programa:    contador.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tutorial consolidado de Erlang — Nivel 2 · gen_server mínimo (call/cast)
%% Fecha:       2026-09-01
%% Verificado:  OTP 25 (apt) y OTP 26.2.5 (kerl) en nodo AWS Academy t4g.large
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(contador).
-behaviour(gen_server).
-export([start_link/1, incrementar/1, valor/0]).
-export([init/1, handle_call/3, handle_cast/2]).
start_link(N)  -> gen_server:start_link({local, ?MODULE}, ?MODULE, N, []).
incrementar(N) -> gen_server:cast(?MODULE, {inc, N}).
valor()        -> gen_server:call(?MODULE, valor).
init(N)                       -> {ok, N}.
handle_cast({inc, N}, S)      -> {noreply, S + N}.
handle_call(valor, _From, S)  -> {reply, S, S}.
