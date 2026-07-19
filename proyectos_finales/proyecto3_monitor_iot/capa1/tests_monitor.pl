% =====================================================================
% Programa:    tests_monitor.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Proyecto Final P3 — Monitor IoT CENAPRED, capa 1
% Fecha:       2026-07-18
% Descripción: Suite plunit de clasificación de alertas (19 tests)
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
:- use_module(reglas_alerta).
:- use_module(umbrales).
:- use_module(library(plunit)).

:- begin_tests(monitor).

% ── clasificación ────────────────────────────────────────────
test(sismico_normal) :-
    clasificar(sismico, 20, normal).

test(sismico_alerta) :-
    clasificar(sismico, 45, alerta).

test(sismico_critico) :-
    clasificar(sismico, 65, critico).

test(temperatura_normal) :-
    clasificar(temperatura, 22, normal).

test(temperatura_alerta) :-
    clasificar(temperatura, 37, alerta).

test(temperatura_critico) :-
    clasificar(temperatura, 42, critico).

test(humedad_normal) :-
    clasificar(humedad, 50, normal).

test(humedad_alerta) :-
    clasificar(humedad, 15, alerta).

test(humedad_critico) :-
    clasificar(humedad, 8, critico).

test(co2_normal) :-
    clasificar(co2, 400, normal).

test(co2_critico) :-
    clasificar(co2, 2500, critico).

test(presion_normal) :-
    clasificar(presion, 1013, normal).

test(presion_critico) :-
    clasificar(presion, 910, critico).

% ── generación de alertas ────────────────────────────────────
test(alerta_generada_para_critico) :-
    generar_alerta(sismico, 70, Msg),
    sub_atom(Msg, _, _, _, critico).

test(no_alerta_para_normal, [fail]) :-
    generar_alerta(temperatura, 25, _).

% ── nivel máximo ─────────────────────────────────────────────
test(nivel_maximo_critico_domina) :-
    nivel_maximo(
        [sensor(sismico, 20), sensor(temperatura, 42), sensor(co2, 400)],
        critico).

test(nivel_maximo_todos_normales) :-
    nivel_maximo(
        [sensor(sismico, 10), sensor(temperatura, 22), sensor(humedad, 60)],
        normal).

% ── CLP(FD) ──────────────────────────────────────────────────
test(lectura_valida_sismico) :-
    lectura_valida(sismico, 50).

test(en_rango_normal_co2) :-
    en_rango_normal(co2, 500).

:- end_tests(monitor).
