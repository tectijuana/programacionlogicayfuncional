%% validador.pl — Módulo de validación de trámites TecNM
%% TecNM — Programación Lógica y Funcional, Unidad 4 Tema 4.4
%%
%% Ejecutar interactivo: swipl -l validador.pl
%% Ejecutar tests:       swipl -g "run_tests(validador), halt" -l validador.pl

:- module(validador_tramites,
    [ tramite_valido/1,
      puede_solicitar/3,
      falta_requisito/3,
      alumno/4,
      requisito/2
    ]).

:- use_module(library(plunit)).
:- use_module(library(clpfd)).

%% ============================================================
%% BASE DE DATOS: Alumnos de TecNM Tijuana (datos ficticios)
%% alumno/4 — det
%% alumno(+ID, +Promedio, +Creditos, +TieneAdeudo)
%% ============================================================
alumno(garcia_lopez,    8.7, 185, false).   % bien encaminado
alumno(perez_ruiz,      7.1, 243, false).   % puede titularse
alumno(ramos_torres,    9.2,  72, false).   % beca segura
alumno(lopez_mendez,    6.5,  45, true).    % debe en biblioteca
alumno(sanchez_vega,    5.8,  28, false).   % en riesgo académico
alumno(mendoza_ibarra,  8.0, 240, false).   % promedio exacto de beca
alumno(cruz_jimenez,    7.0, 240, true).    % titulación bloqueada por adeudo

%% ============================================================
%% Tipos de trámites disponibles
%% tramite_valido/1 — det
%% tramite_valido(+Tramite)
%% ============================================================
tramite_valido(beca).
tramite_valido(titulacion).
tramite_valido(cambio_carrera).
tramite_valido(baja_temporal).

%% ============================================================
%% Requisitos por trámite
%% requisito/2 — nondet
%% requisito(+Tramite, +Descripcion) — documentación de requisitos
%% ============================================================
requisito(beca,           'Promedio mínimo 8.0').
requisito(beca,           'Mínimo 60 créditos cursados').
requisito(beca,           'Sin adeudo en biblioteca').
requisito(titulacion,     'Promedio mínimo 7.0').
requisito(titulacion,     'Mínimo 240 créditos (plan completo)').
requisito(titulacion,     'Sin adeudo en biblioteca').
requisito(cambio_carrera, 'Promedio mínimo 6.0').
requisito(cambio_carrera, 'Mínimo 30 créditos cursados').
requisito(cambio_carrera, 'Sin adeudo en biblioteca').
requisito(baja_temporal,  'Entrevista con orientador').

%% ============================================================
%% puede_solicitar/3 — det
%% puede_solicitar(+AlumnoID, +Tramite, -Resultado)
%% Resultado: ok | error(Razon)
%% ============================================================

%% Trámite no existe
puede_solicitar(_, Tramite, error(tramite_desconocido(Tramite))) :-
    \+ tramite_valido(Tramite), !.

%% Alumno no existe
puede_solicitar(ID, _, error(alumno_desconocido(ID))) :-
    \+ alumno(ID, _, _, _), !.

%% Beca
puede_solicitar(ID, beca, ok) :-
    alumno(ID, Promedio, Creditos, Adeudo),
    Promedio >= 8.0,
    Creditos >= 60,
    Adeudo == false, !.

puede_solicitar(ID, beca, error(no_elegible)) :-
    alumno(ID, _, _, _), !.

%% Titulación
puede_solicitar(ID, titulacion, ok) :-
    alumno(ID, Promedio, Creditos, Adeudo),
    Promedio >= 7.0,
    Creditos >= 240,
    Adeudo == false, !.

puede_solicitar(ID, titulacion, error(no_elegible)) :-
    alumno(ID, _, _, _), !.

%% Cambio de carrera
puede_solicitar(ID, cambio_carrera, ok) :-
    alumno(ID, Promedio, Creditos, Adeudo),
    Promedio >= 6.0,
    Creditos >= 30,
    Adeudo == false, !.

puede_solicitar(ID, cambio_carrera, error(no_elegible)) :-
    alumno(ID, _, _, _), !.

%% Baja temporal — solo requiere existir como alumno
puede_solicitar(ID, baja_temporal, ok) :-
    alumno(ID, _, _, _), !.

%% ============================================================
%% falta_requisito/3 — nondet
%% falta_requisito(+AlumnoID, +Tramite, -Falta)
%% Retorna todos los requisitos que le faltan al alumno
%% ============================================================
falta_requisito(ID, beca, promedio_insuficiente(Promedio)) :-
    alumno(ID, Promedio, _, _),
    Promedio < 8.0.

falta_requisito(ID, beca, creditos_insuficientes(Creditos)) :-
    alumno(ID, _, Creditos, _),
    Creditos < 60.

falta_requisito(ID, beca, tiene_adeudo) :-
    alumno(ID, _, _, true).

falta_requisito(ID, titulacion, promedio_insuficiente(Promedio)) :-
    alumno(ID, Promedio, _, _),
    Promedio < 7.0.

falta_requisito(ID, titulacion, creditos_insuficientes(Creditos)) :-
    alumno(ID, _, Creditos, _),
    Creditos < 240.

falta_requisito(ID, titulacion, tiene_adeudo) :-
    alumno(ID, _, _, true).

falta_requisito(ID, cambio_carrera, promedio_insuficiente(Promedio)) :-
    alumno(ID, Promedio, _, _),
    Promedio < 6.0.

falta_requisito(ID, cambio_carrera, creditos_insuficientes(Creditos)) :-
    alumno(ID, _, Creditos, _),
    Creditos < 30.

falta_requisito(ID, cambio_carrera, tiene_adeudo) :-
    alumno(ID, _, _, true).

%% ============================================================
%% Tests
%% ============================================================
:- begin_tests(validador).

test(beca_aprobada) :-
    puede_solicitar(ramos_torres, beca, ok).

test(beca_promedio_exacto) :-
    puede_solicitar(mendoza_ibarra, beca, ok).

test(beca_rechazada_promedio) :-
    puede_solicitar(perez_ruiz, beca, error(no_elegible)).

test(beca_rechazada_adeudo) :-
    puede_solicitar(lopez_mendez, beca, error(no_elegible)).

test(beca_rechazada_creditos) :-
    puede_solicitar(sanchez_vega, beca, error(no_elegible)).

test(titulacion_aprobada) :-
    puede_solicitar(perez_ruiz, titulacion, ok).

test(titulacion_rechazada_adeudo) :-
    puede_solicitar(cruz_jimenez, titulacion, error(no_elegible)).

test(titulacion_rechazada_creditos) :-
    puede_solicitar(garcia_lopez, titulacion, error(no_elegible)).

test(baja_siempre_ok) :-
    puede_solicitar(sanchez_vega, baja_temporal, ok).

test(tramite_inexistente) :-
    puede_solicitar(garcia_lopez, tramite_ficticio, error(tramite_desconocido(_))).

test(alumno_inexistente) :-
    puede_solicitar(nadie, beca, error(alumno_desconocido(_))).

test(falta_promedio) :-
    falta_requisito(sanchez_vega, beca, promedio_insuficiente(_)).

test(falta_adeudo) :-
    falta_requisito(lopez_mendez, beca, tiene_adeudo).

test(sin_faltas_beca) :-
    findall(F, falta_requisito(ramos_torres, beca, F), Fs),
    Fs == [].

:- end_tests(validador).
