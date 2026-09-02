%% =====================================================================
%% Programa:    registro.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tutorial consolidado de Erlang — Nivel 1 · Records vs maps
%% Fecha:       2026-09-01
%% Verificado:  OTP 25 (apt) y OTP 26.2.5 (kerl) en nodo AWS Academy t4g.large
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(registro).
-export([alumno/0]).
-record(alumno, {nombre, control, semestre}).
alumno() ->
  A = #alumno{nombre="Ana", control="21210001", semestre=6},
  M = #{nombre => A#alumno.nombre, control => A#alumno.control},
  {A#alumno.semestre, maps:get(nombre, M)}.
