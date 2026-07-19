% =====================================================================
% Programa:    reglas_alerta.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Proyecto Final P3 — Monitor IoT CENAPRED, capa 1
% Fecha:       2026-07-18
% Descripción: Reglas normal/alerta/crítico según la lectura del sensor
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
:- module(reglas_alerta, [
    clasificar/3,
    generar_alerta/3,
    nivel_maximo/2
]).
:- use_module(umbrales).

%% ============================================================
%% CLASIFICACIÓN DE LECTURAS
%% clasificar/3 — clasificar(+Sensor, +Lectura, -Nivel) is det
%% Nivel = normal | alerta | critico
%% ============================================================

clasificar(Sensor, Lectura, critico) :-
    umbral_critico(Sensor, Min, Max),
    Lectura >= Min, Lectura =< Max, !.

clasificar(Sensor, Lectura, normal) :-
    umbral_alerta(Sensor, Min, Max),
    Lectura >= Min, Lectura =< Max, !.

clasificar(_, _, alerta).

%% ============================================================
%% GENERACIÓN DE ALERTAS
%% generar_alerta/3 — generar_alerta(+Sensor, +Lectura, -Mensaje) is semidet
%% Solo genera mensajes si el nivel no es normal
%% ============================================================

generar_alerta(Sensor, Lectura, Mensaje) :-
    clasificar(Sensor, Lectura, Nivel),
    Nivel \= normal,
    format(atom(Mensaje),
           "[~w] SENSOR ~w lectura ~w — nivel ~w",
           [alerta, Sensor, Lectura, Nivel]).

%% ============================================================
%% NIVEL MÁXIMO DE UN CONJUNTO DE LECTURAS
%% nivel_maximo/2 — nivel_maximo(+Lecturas, -NivelMax) is det
%% Lecturas = lista de pares sensor(Tipo, Valor)
%% ============================================================

nivel_maximo(Lecturas, NivelMax) :-
    maplist(clasificar_par, Lecturas, Niveles),
    reducir_nivel(Niveles, NivelMax).

clasificar_par(sensor(Tipo, Valor), Nivel) :-
    clasificar(Tipo, Valor, Nivel).

reducir_nivel(Niveles, critico) :- member(critico, Niveles), !.
reducir_nivel(Niveles, alerta)  :- member(alerta, Niveles), !.
reducir_nivel(_, normal).
