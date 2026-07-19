% =====================================================================
% Programa:    clpfd_basico.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 4.3 — Optimización / CLP(FD)
% Fecha:       2026-07-18
% Descripción: Introducción a CLP(FD): dominios, restricciones y labeling
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% clpfd_basico.pl — Introducción a Constraint Logic Programming sobre Enteros
%% TecNM — Programación Lógica y Funcional, Unidad 4 Tema 4.3
%%
%% Ejecutar tests: swipl -g "run_tests(clpfd), halt" -l clpfd_basico.pl
%% Interactivo:    swipl -l clpfd_basico.pl

:- use_module(library(clpfd)).
:- use_module(library(plunit)).

%% ============================================================
%% SECCIÓN 1: Ejemplos básicos progresivos
%% ============================================================

%% demo_basico/0 — det
demo_basico :-
    writeln("=== CLP(FD): Ejemplos básicos ==="),
    nl,

    % Dominio simple
    X1 in 1..10, X1 #> 7, label([X1]),
    format("  X in 1..10, X #> 7 → X = ~w~n", [X1]),

    % Ecuación lineal
    X2 in 1..20, Y2 in 1..20,
    X2 + Y2 #= 15, X2 #< Y2,
    findall(X2-Y2, label([X2,Y2]), Pares),
    format("  X+Y=15, X<Y, ambos en 1..20: ~w~n", [Pares]),

    nl.

%% ============================================================
%% suma_restringida/3 — det
%% suma_restringida(+DomMin, +DomMax, +Total)
%% Encuentra todos los pares (X,Y) con X+Y=Total en el dominio dado
%%
%% ?- suma_restringida(1, 9, 10, Pares).
%%    → Pares = [1-9, 2-8, 3-7, 4-6] (con X < Y)
%% ============================================================
suma_restringida(Min, Max, Total, Pares) :-
    findall(X-Y, (
        X in Min..Max, Y in Min..Max,
        X + Y #= Total,
        X #< Y,
        label([X, Y])
    ), Pares).

%% ============================================================
%% pythagoras/3 — nondet
%% pythagoras(+MaxVal, -A, -B, -C) — genera triples pitagóricos A²+B²=C²
%% A ≤ B < C, todos en 1..MaxVal
%%
%% ?- findall(A-B-C, pythagoras(20, A, B, C), Ts).
%%    → [(3,4,5), (5,12,13), (6,8,10), (8,15,17), ...]
%% ============================================================
pythagoras(MaxVal, A, B, C) :-
    A in 1..MaxVal, B in 1..MaxVal, C in 1..MaxVal,
    A #=< B, B #< C,
    A*A + B*B #= C*C,
    label([A, B, C]).

%% ============================================================
%% n_reinas/2 — det
%% n_reinas(+N, -Posiciones)
%% Posiciones: lista de N enteros, Posiciones[i] = columna de reina en fila i
%% Restricciones: ninguna reina ataca a otra (fila, columna, diagonal)
%%
%% ?- n_reinas(8, Pos).
%%    → Pos = [1,5,8,6,3,7,2,4] (una de las 92 soluciones)
%% ============================================================
n_reinas(N, Posiciones) :-
    length(Posiciones, N),
    Posiciones ins 1..N,
    all_distinct(Posiciones),
    no_ataca_diagonales(Posiciones),
    label(Posiciones).

%% no_ataca_diagonales/1 — det
%% Ningún par de reinas comparte diagonal
no_ataca_diagonales([]).
no_ataca_diagonales([Q|Qs]) :-
    no_ataca_una(Q, Qs, 1),
    no_ataca_diagonales(Qs).

%% no_ataca_una/3 — det
no_ataca_una(_, [], _).
no_ataca_una(Q, [Q1|Qs], D) :-
    Q1 - Q #\= D,
    Q - Q1 #\= D,
    D1 is D + 1,
    no_ataca_una(Q, Qs, D1).

%% ============================================================
%% Tests con plunit
%% ============================================================

:- begin_tests(clpfd).

test(suma_basica) :-
    X in 1..10, Y in 1..10,
    X + Y #= 12, X #< Y, X #> 3,
    label([X, Y]),
    X =:= 4, Y =:= 8.

test(pythagoras_3_4_5) :-
    pythagoras(20, 3, 4, 5).

test(pythagoras_5_12_13) :-
    pythagoras(20, 5, 12, 13).

test(n_reinas_4) :-
    n_reinas(4, Pos),
    length(Pos, 4),
    all_distinct(Pos).

test(n_reinas_8_tiene_soluciones) :-
    findall(P, n_reinas(8, P), Sols),
    length(Sols, N),
    N =:= 92.   % hay exactamente 92 soluciones para 8 reinas

test(dominio_basico) :-
    X in 1..5, X #> 3,
    findall(X, label([X]), Xs),
    Xs == [4, 5].

:- end_tests(clpfd).

:- initialization(demo_basico, main).
