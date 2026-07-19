% =====================================================================
% Programa:    reglas_negocio.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 4.4 — Proyecto integrador U4
% Fecha:       2026-07-18
% Descripción: Prioridades y restricciones CLP(FD) de los trámites TecNM
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% reglas_negocio.pl — Reglas de prioridad con CLP(FD)
%% TecNM — Programación Lógica y Funcional, Unidad 4 Tema 4.4

:- module(reglas_negocio,
    [ prioridad_tramite/3,
      ordenar_solicitudes/3,
      alumno_prioritario/2
    ]).

:- use_module('./validador').
:- use_module(library(clpfd)).

%% ============================================================
%% prioridad_tramite/3 — det
%% prioridad_tramite(+AlumnoID, +Tramite, -Puntaje)
%%
%% Calcula puntaje de prioridad 0..100:
%%   - Promedio: hasta 50 puntos (promedio*5, máximo 10.0*5=50)
%%   - Créditos: hasta 30 puntos (min(creditos/8, 30))
%%   - Sin adeudo: 20 puntos adicionales
%% ============================================================
prioridad_tramite(AlumnoID, Tramite, Puntaje) :-
    alumno(AlumnoID, Promedio, Creditos, Adeudo),
    puede_solicitar(AlumnoID, Tramite, ok),

    % Componente de promedio (0..50)
    PuntajePromedio is round(Promedio * 5),

    % Componente de créditos (0..30)
    PuntajeCreditos is min(Creditos // 8, 30),

    % Bono por no tener adeudo
    (Adeudo == false -> BonusAdeudo = 20 ; BonusAdeudo = 0),

    Puntaje is PuntajePromedio + PuntajeCreditos + BonusAdeudo.

%% ============================================================
%% ordenar_solicitudes/3 — det
%% ordenar_solicitudes(+Tramite, +Alumnos, -Ordenados)
%% Retorna alumnos elegibles ordenados por prioridad descendente
%% ============================================================
ordenar_solicitudes(Tramite, Alumnos, Ordenados) :-
    findall(
        Puntaje-ID,
        (member(ID, Alumnos),
         puede_solicitar(ID, Tramite, ok),
         prioridad_tramite(ID, Tramite, Puntaje)),
        PuntajesPares
    ),
    msort(PuntajesPares, Ascendente),
    reverse(Ascendente, Descendente),
    pairs_values(Descendente, Ordenados).

%% ============================================================
%% alumno_prioritario/2 — semidet
%% alumno_prioritario(+Tramite, -AlumnoID)
%% Retorna el alumno con mayor prioridad para el trámite dado
%% ============================================================
alumno_prioritario(Tramite, AlumnoID) :-
    findall(ID, alumno(ID, _, _, _), TodosIds),
    ordenar_solicitudes(Tramite, TodosIds, [AlumnoID|_]).
