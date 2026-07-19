% =====================================================================
% Programa:    reglas_fiscales.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Proyecto Final P4 — Inventario SAT, capa 1
% Fecha:       2026-07-18
% Descripción: Validación de RFC y cálculo de IVA con CLP(FD)
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
:- module(reglas_fiscales, [
    rfc_valido/1,
    tasa_iva/3,
    calcular_iva/4,
    requiere_factura/1,
    zona_fronteriza/1
]).
:- use_module(library(clpfd)).

%% ============================================================
%% VALIDACIÓN DE RFC
%% rfc_valido/1 — rfc_valido(+RFC:atom) is semidet
%% RFC persona moral: 12 chars  (XAXX010101000)
%% RFC persona física: 13 chars (XAXX010101000A)
%% ============================================================

rfc_valido(RFC) :-
    atom_chars(RFC, Chars),
    length(Chars, Len),
    (Len =:= 12 ; Len =:= 13),
    rfc_estructura(Chars).

%% Los primeros 3 o 4 caracteres son letras (nombre), luego 6 dígitos (fecha),
%% luego 3 caracteres homoclave alfanuméricos
rfc_estructura(Chars) :-
    length(Chars, Len),
    (Len =:= 12 -> LetrasN = 3 ; LetrasN = 4),
    length(Letras, LetrasN),
    append(Letras, Resto, Chars),
    maplist(letra_mayuscula, Letras),
    length(Fecha, 6),
    append(Fecha, Homoclave, Resto),
    maplist(digito, Fecha),
    maplist(alfanumerico, Homoclave).

letra_mayuscula(C) :- char_type(C, upper).
digito(C)         :- char_type(C, digit).
alfanumerico(C)   :- char_type(C, alnum).

%% ============================================================
%% ZONAS FRONTERIZAS — IVA 8%
%% zona_fronteriza/1 — zona_fronteriza(+Estado:atom) is semidet
%% ============================================================

zona_fronteriza(baja_california).
zona_fronteriza(baja_california_sur).
zona_fronteriza(sonora).
zona_fronteriza(chihuahua).
zona_fronteriza(coahuila).
zona_fronteriza(nuevo_leon).
zona_fronteriza(tamaulipas).

%% ============================================================
%% TASAS DE IVA
%% tasa_iva/3 — tasa_iva(+Producto, +Estado, -Tasa) is det
%% Tasa en enteros (porcentaje): 0, 8 o 16
%% ============================================================

tasa_iva(Producto, _, 0) :-
    producto_exento(Producto), !.

tasa_iva(Producto, _, 0) :-
    producto_tasa_cero(Producto), !.

tasa_iva(_, Estado, 8) :-
    zona_fronteriza(Estado), !.

tasa_iva(_, _, 16).

%% ============================================================
%% CÁLCULO DE IVA CON CLP(FD) — montos en centavos (enteros)
%% calcular_iva/4 — calcular_iva(+SubtotalCentavos, +Tasa, -IVA, -Total)
%% ============================================================

calcular_iva(Subtotal, Tasa, IVA, Total) :-
    Subtotal in 0..100_000_000,
    Tasa     in 0..16,
    IVA      #= (Subtotal * Tasa) // 100,
    Total    #= Subtotal + IVA.

%% ============================================================
%% REGLA: FACTURA OBLIGATORIA
%% requiere_factura/1 — requiere_factura(+MontoMXN) is semidet
%% El SAT exige CFDI para ventas >= $2,000 MXN (200000 centavos)
%% ============================================================

requiere_factura(MontoMXN) :-
    MontoMXN >= 2000.
