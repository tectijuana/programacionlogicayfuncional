%% tests.pl — Suite completa de pruebas del Proyecto Final
%% TecNM — Programación Lógica y Funcional, Unidad 4 Tema 4.4
%%
%% Ejecutar: swipl -g "run_tests, halt" -l tests.pl
%% Resultado esperado: 0 failures

:- use_module(library(plunit)).
:- consult(validador).
:- consult(reglas_negocio).

%% ============================================================
%% Tests de validador_tramites
%% ============================================================
:- begin_tests(tramites).

%% --- Casos que SÍ deben aprobarse ---

test(beca_aprobada_promedio_alto) :-
    puede_solicitar(ramos_torres, beca, ok).

test(beca_aprobada_promedio_exacto_80) :-
    % mendoza_ibarra tiene exactamente 8.0 — debe calificar
    puede_solicitar(mendoza_ibarra, beca, ok).

test(titulacion_aprobada) :-
    puede_solicitar(perez_ruiz, titulacion, ok).

test(cambio_carrera_aprobado) :-
    % garcia_lopez: promedio 8.7, creditos 185, sin adeudo → cambio ok
    puede_solicitar(garcia_lopez, cambio_carrera, ok).

test(baja_temporal_siempre_ok) :-
    puede_solicitar(sanchez_vega, baja_temporal, ok).

test(baja_temporal_con_adeudo_ok) :-
    % baja temporal no requiere sin adeudo
    puede_solicitar(lopez_mendez, baja_temporal, ok).

%% --- Casos que NO deben aprobarse ---

test(beca_rechazada_promedio_bajo) :-
    % perez_ruiz: promedio 7.1 < 8.0
    puede_solicitar(perez_ruiz, beca, error(no_elegible)).

test(beca_rechazada_creditos_insuficientes) :-
    % sanchez_vega: 28 créditos < 60
    puede_solicitar(sanchez_vega, beca, error(no_elegible)).

test(beca_rechazada_adeudo) :-
    % lopez_mendez: tiene adeudo en biblioteca
    puede_solicitar(lopez_mendez, beca, error(no_elegible)).

test(titulacion_rechazada_creditos) :-
    % garcia_lopez: 185 créditos < 240
    puede_solicitar(garcia_lopez, titulacion, error(no_elegible)).

test(titulacion_rechazada_adeudo) :-
    % cruz_jimenez: tiene adeudo
    puede_solicitar(cruz_jimenez, titulacion, error(no_elegible)).

%% --- Casos borde ---

test(tramite_desconocido) :-
    puede_solicitar(garcia_lopez, tramite_inexistente,
                    error(tramite_desconocido(tramite_inexistente))).

test(alumno_inexistente) :-
    puede_solicitar(nadie_registrado, beca,
                    error(alumno_desconocido(nadie_registrado))).

%% --- Tests de falta_requisito ---

test(falta_promedio_para_beca) :-
    falta_requisito(sanchez_vega, beca, promedio_insuficiente(_)).

test(falta_adeudo_para_beca) :-
    falta_requisito(lopez_mendez, beca, tiene_adeudo).

test(sin_faltas_alumno_elegible) :-
    findall(F, falta_requisito(ramos_torres, beca, F), Fs),
    Fs == [].

%% --- Tests de reglas_negocio ---

test(puntaje_mayor_cero) :-
    prioridad_tramite(ramos_torres, beca, P),
    P > 0.

test(mendoza_prioritaria_beca) :-
    % mendoza_ibarra: 240 créditos (30 pts, tope) + promedio 8.0 (40 pts)
    % + sin adeudo (20 pts) = 90, el puntaje más alto entre los elegibles
    alumno_prioritario(beca, mendoza_ibarra).

test(ordenar_candidatos_beca) :-
    ordenar_solicitudes(beca,
        [garcia_lopez, ramos_torres, mendoza_ibarra],
        Ordenados),
    % Los tres son elegibles — solo verificamos que la lista no está vacía
    Ordenados \= [].

:- end_tests(tramites).

%% ============================================================
%% Ejecutar y reportar
%% ============================================================
:- initialization(run_tests, main).
