:- module(restricciones, [semanas_validas/1, edad_pension/1, monto_prestamo/2]).
:- use_module(library(clpfd)).

%% semanas_validas/1 — semanas_validas(?S) is nondet
%% S es un número de semanas cotizadas válido (0..2080 = 40 años × 52 semanas)
semanas_validas(S) :-
    S in 0..2080.

%% edad_pension/1 — edad_pension(?Edad) is nondet
%% Edad mínima para pensión por vejez según IMSS (60–65 años)
edad_pension(Edad) :-
    Edad in 60..65.

%% monto_prestamo/2 — monto_prestamo(+SemanasCotizadas, -MontoMaximo) is det
%% El monto máximo de préstamo IMSS escala con semanas cotizadas.
%% Restricción CLP(FD): MontoMaximo = SemanasCotizadas * 100 (simplificado)
monto_prestamo(Semanas, Monto) :-
    semanas_validas(Semanas),
    Monto #= Semanas * 100,
    Monto in 0..500000.

%% semanas_para_pension/2 — semanas_para_pension(+SemanasCotizadas, -Faltan) is det
%% Cuántas semanas faltan para alcanzar el mínimo de pensión por invalidez (150)
semanas_para_pension(Semanas, Faltan) :-
    semanas_validas(Semanas),
    Minimo = 150,
    Faltan #= max(0, Minimo - Semanas),
    label([Faltan]).
