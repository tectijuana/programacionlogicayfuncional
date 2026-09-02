%% =====================================================================
%% Programa:    suma.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tutorial consolidado de Erlang — Nivel 1 · Recursión de cola con acumulador
%% Fecha:       2026-09-01
%% Verificado:  OTP 25 (apt) y OTP 26.2.5 (kerl) en nodo AWS Academy t4g.large
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(suma).
-export([total/1]).
total(L) -> total(L, 0).
total([], Acc)     -> Acc;
total([H|T], Acc)  -> total(T, Acc + H).
