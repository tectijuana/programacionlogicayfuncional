% =====================================================================
% Programa:    validador_imss.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Proyecto Final P1 — Trámites IMSS, capa 1
% Fecha:       2026-07-18
% Descripción: Reglas de elegibilidad de trámites IMSS en Prolog
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
:- module(validador_imss, [
    puede_tramitar/3,
    falta_requisito/3,
    semanas_cotizadas/2,
    vigencia_activa/1
]).

%% ============================================================
%% BASE DE HECHOS — derechohabientes ficticios
%% ============================================================

%% derechohabiente/4 — derechohabiente(+NSS, +Nombre, +SemanasCotizadas, +Vigente)
derechohabiente('12345678901', garcia_lopez,  260, true).
derechohabiente('23456789012', perez_ruiz,     38, true).
derechohabiente('34567890123', sanchez_vega,   10, false).
derechohabiente('45678901234', martinez_hdz,  180, true).
derechohabiente('56789012345', torres_reyes,    0, false).
derechohabiente('67890123456', flores_cruz,    55, true).
derechohabiente('78901234567', rodriguez_m,   152, true).

%% hijo_registrado/2 — hijo_registrado(+NSS_Padre, +NSS_Hijo)
hijo_registrado('12345678901', hijo_001).
hijo_registrado('45678901234', hijo_002).

%% adeudo_previo/1 — adeudo_previo(+NSS)
adeudo_previo('34567890123').

%% dictamen_medico/1 — dictamen_medico(+NSS)
dictamen_medico('78901234567').

%% ============================================================
%% CONSULTAS AUXILIARES
%% ============================================================

%% vigencia_activa/1 — vigencia_activa(+NSS) is semidet
vigencia_activa(NSS) :-
    derechohabiente(NSS, _, _, true).

%% semanas_cotizadas/2 — semanas_cotizadas(+NSS, -Semanas) is det
semanas_cotizadas(NSS, Semanas) :-
    derechohabiente(NSS, _, Semanas, _).

%% ============================================================
%% REGLAS DE ELEGIBILIDAD
%% ============================================================

%% puede_tramitar/3 — puede_tramitar(+NSS, +Tramite, -Resultado) is det
%% Resultado = ok | error(Razon)

puede_tramitar(NSS, atencion_medica, ok) :-
    vigencia_activa(NSS), !.
puede_tramitar(NSS, atencion_medica, error(vigencia_inactiva)) :-
    \+ vigencia_activa(NSS).

puede_tramitar(NSS, incapacidad_temporal, ok) :-
    vigencia_activa(NSS),
    semanas_cotizadas(NSS, S),
    S >= 4, !.
puede_tramitar(NSS, incapacidad_temporal, error(Razon)) :-
    falta_requisito(NSS, incapacidad_temporal, Razon).

puede_tramitar(NSS, pension_invalidez, ok) :-
    vigencia_activa(NSS),
    semanas_cotizadas(NSS, S),
    S >= 150,
    dictamen_medico(NSS), !.
puede_tramitar(NSS, pension_invalidez, error(Razon)) :-
    falta_requisito(NSS, pension_invalidez, Razon).

puede_tramitar(NSS, guarderias, ok) :-
    vigencia_activa(NSS),
    hijo_registrado(NSS, _), !.
puede_tramitar(NSS, guarderias, error(Razon)) :-
    falta_requisito(NSS, guarderias, Razon).

puede_tramitar(NSS, prestamo_imss, ok) :-
    vigencia_activa(NSS),
    semanas_cotizadas(NSS, S),
    S >= 52,
    \+ adeudo_previo(NSS), !.
puede_tramitar(NSS, prestamo_imss, error(Razon)) :-
    falta_requisito(NSS, prestamo_imss, Razon).

%% ============================================================
%% DIAGNÓSTICO DE REQUISITOS FALTANTES
%% ============================================================

%% falta_requisito/3 — falta_requisito(+NSS, +Tramite, -Razon) is nondet
%% No determinista: puede generar múltiples razones

falta_requisito(NSS, _, vigencia_inactiva) :-
    \+ vigencia_activa(NSS).

falta_requisito(NSS, incapacidad_temporal, semanas_insuficientes(S, minimo_4)) :-
    semanas_cotizadas(NSS, S), S < 4.

falta_requisito(NSS, pension_invalidez, semanas_insuficientes(S, minimo_150)) :-
    semanas_cotizadas(NSS, S), S < 150.

falta_requisito(NSS, pension_invalidez, sin_dictamen_medico) :-
    vigencia_activa(NSS),
    semanas_cotizadas(NSS, S), S >= 150,
    \+ dictamen_medico(NSS).

falta_requisito(NSS, guarderias, sin_hijo_registrado) :-
    vigencia_activa(NSS),
    \+ hijo_registrado(NSS, _).

falta_requisito(NSS, prestamo_imss, semanas_insuficientes(S, minimo_52)) :-
    semanas_cotizadas(NSS, S), S < 52.

falta_requisito(NSS, prestamo_imss, adeudo_pendiente) :-
    vigencia_activa(NSS),
    semanas_cotizadas(NSS, S), S >= 52,
    adeudo_previo(NSS).
