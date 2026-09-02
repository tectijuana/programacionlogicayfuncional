%% =====================================================================
%% Programa:    clasifica.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tutorial consolidado de Erlang — Nivel 1 · Guards y pattern matching por cláusula
%% Fecha:       2026-09-01
%% Verificado:  OTP 25 (apt) y OTP 26.2.5 (kerl) en nodo AWS Academy t4g.large
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(clasifica).
-export([temp/1]).
temp(T) when T < 0  -> congelacion;
temp(T) when T < 15 -> frio;
temp(T) when T < 30 -> templado;
temp(_)             -> calor.
