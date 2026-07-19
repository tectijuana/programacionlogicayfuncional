% =====================================================================
% Programa:    umbrales.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Proyecto Final P3 — Monitor IoT CENAPRED, capa 1
% Fecha:       2026-07-18
% Descripción: Rangos CLP(FD) y clasificación de umbrales de alerta
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
:- module(umbrales, [
    umbral_alerta/3,
    umbral_critico/3,
    en_rango_normal/2,
    lectura_valida/2
]).
:- use_module(library(clpfd)).

%% ============================================================
%% UMBRALES DE ALERTA POR TIPO DE SENSOR
%% umbral_alerta/3 — umbral_alerta(+Sensor, ?Min, ?Max) is det
%% ============================================================

%% Lectura normal: MIN <= Lectura <= MAX
umbral_alerta(sismico,     0,    39).    %% Richter × 10 para CLP(FD): < 4.0
umbral_alerta(temperatura, 0,    34).    %% °C < 35
umbral_alerta(humedad,     21,  100).    %% % > 20
umbral_alerta(co2,         0,   999).    %% ppm < 1000
umbral_alerta(presion,     951, 1050).   %% hPa > 950

umbral_critico(sismico,     60, 100).    %% Richter × 10: ≥ 6.0
umbral_critico(temperatura, 40,  60).
umbral_critico(humedad,      0,  10).    %% % ≤ 10
umbral_critico(co2,       2000, 9999).
umbral_critico(presion,      0, 920).

%% ============================================================
%% VALIDACIÓN CON CLP(FD)
%% ============================================================

%% lectura_valida/2 — lectura_valida(+Sensor, ?Lectura) is nondet
%% Lectura es un entero en el rango físico posible del sensor
lectura_valida(sismico,     L) :- L in 0..100.
lectura_valida(temperatura, L) :- L in -40..60.
lectura_valida(humedad,     L) :- L in 0..100.
lectura_valida(co2,         L) :- L in 0..9999.
lectura_valida(presion,     L) :- L in 870..1084.

%% en_rango_normal/2 — en_rango_normal(+Sensor, +Lectura) is semidet
en_rango_normal(Sensor, Lectura) :-
    umbral_alerta(Sensor, Min, Max),
    Lectura in Min..Max,
    indomain(Lectura).
