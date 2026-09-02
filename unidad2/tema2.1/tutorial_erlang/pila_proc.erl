%% =====================================================================
%% Programa:    pila_proc.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tutorial consolidado de Erlang — Nivel 2 · Estado dentro de un proceso (loop + receive)
%% Fecha:       2026-09-01
%% Verificado:  OTP 25 (apt) y OTP 26.2.5 (kerl) en nodo AWS Academy t4g.large
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(pila_proc).
-export([start/0, push/2, pop/1, loop/1]).
start() -> spawn(?MODULE, loop, [[]]).
push(P, X) -> P ! {push, X}, ok.
pop(P) -> P ! {pop, self()}, receive {pila, V} -> V end.
loop(Estado) ->
  receive
    {push, X}   -> loop([X | Estado]);
    {pop, From} ->
      case Estado of
        []      -> From ! {pila, vacia}, loop([]);
        [H | T] -> From ! {pila, {ok, H}}, loop(T)
      end
  end.
