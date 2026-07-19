% =====================================================================
% Programa:    tests_sat.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Proyecto Final P4 — Inventario SAT, capa 1
% Fecha:       2026-07-18
% Descripción: Suite plunit de reglas fiscales (17 tests)
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
:- use_module(reglas_fiscales).
:- use_module(productos).
:- use_module(library(plunit)).

:- begin_tests(sat).

% ── RFC ──────────────────────────────────────────────────────
test(rfc_moral_valido) :-
    rfc_valido('XAXX010101000').

test(rfc_fisico_valido) :-
    rfc_valido('GALO900101AB1').

test(rfc_corto_invalido, [fail]) :-
    rfc_valido('ABC123').

test(rfc_muy_largo_invalido, [fail]) :-
    rfc_valido('XAXX010101000AB').

% ── Tasas IVA ────────────────────────────────────────────────
test(iva_16_general) :-
    tasa_iva(laptop, jalisco, 16).

test(iva_8_frontera) :-
    tasa_iva(laptop, baja_california, 8).

test(iva_0_medicamento) :-
    tasa_iva(medicamento, cdmx, 0).

test(iva_0_alimento) :-
    tasa_iva(tortilla, nuevo_leon, 0).

test(iva_exento_libro) :-
    tasa_iva(libro, jalisco, 0).

% ── Cálculo IVA con CLP(FD) ─────────────────────────────────
test(iva_calculado_16) :-
    calcular_iva(100000, 16, IVA, Total),
    IVA   =:= 16000,
    Total =:= 116000.

test(iva_calculado_8) :-
    calcular_iva(100000, 8, IVA, Total),
    IVA   =:= 8000,
    Total =:= 108000.

test(iva_calculado_cero) :-
    calcular_iva(50000, 0, IVA, Total),
    IVA   =:= 0,
    Total =:= 50000.

% ── Obligatoriedad de factura ────────────────────────────────
test(factura_obligatoria_2000) :-
    requiere_factura(2000).

test(factura_obligatoria_grande) :-
    requiere_factura(50000).

test(factura_no_requerida, [fail]) :-
    requiere_factura(1999).

% ── Zonas fronterizas ────────────────────────────────────────
test(baja_california_frontera) :-
    zona_fronteriza(baja_california).

test(jalisco_no_frontera, [fail]) :-
    zona_fronteriza(jalisco).

:- end_tests(sat).
