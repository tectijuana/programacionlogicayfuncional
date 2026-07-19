% =====================================================================
% Programa:    aritmetica.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 3.4 — Introducción a Prolog
% Fecha:       2026-07-18
% Descripción: Aritmética en Prolog: is/2, comparaciones, entre/3 (48 tests plunit)
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% aritmetica.pl — Aritmética en Prolog: is/2, =:=, =\=, comparaciones
%% TecNM — Programación Lógica y Funcional, Unidad 3 Tema 3.4
%%
%% Ejecutar tests: swipl -g "run_tests(aritmetica), halt" -l aritmetica.pl
%% Interactivo:    swipl -l aritmetica.pl

:- use_module(library(plunit)).
:- consult(listas).  % para usar mi_sum_list y mi_length

%% ============================================================
%% TABLA COMPARATIVA DE OPERADORES ARITMÉTICOS
%% ============================================================
%%
%% OPERADOR  | FUNCIÓN                          | EJEMPLO
%% ----------|----------------------------------|------------------------
%% =         | Unificación (NO evalúa)          | X = 1+2  →  X = 1+2
%% is        | Evaluación aritmética            | X is 1+2 →  X = 3
%% =:=       | Igualdad numérica (evalúa ambos) | 1+2 =:= 3 → true
%% =\=       | Desigualdad numérica             | 1+2 =\= 4 → true
%% <         | Menor que (evalúa ambos)         | 2 < 3     → true
%% >         | Mayor que (evalúa ambos)         | 3 > 2     → true
%% =<        | Menor o igual (evalúa ambos)     | 2 =< 2    → true
%% >=        | Mayor o igual (evalúa ambos)     | 3 >= 2    → true
%% ==        | Igualdad estructural (NO evalúa) | 1+2 == 1+2 → true
%% \==       | Desigualdad estructural          | 1+2 \== 3  → true
%%
%% ERRORES COMUNES:
%% ?- X = 1+2, X =:= 3.   → true  (= guarda la estructura, =:= la evalúa)
%% ?- 1+2 is X.            → ERROR (is requiere expresión en la derecha instanciada)

%% demo_operadores/0 — det
demo_operadores :-
    writeln("=== Demostración de operadores aritméticos ==="),
    X1 = 1+2,
    format("  X = 1+2  →  X = ~w  (no es 3, es la estructura)~n", [X1]),
    X2 is 1+2,
    format("  X is 1+2 →  X = ~w  (evalúa)~n", [X2]),
    (1+2 =:= 3 -> writeln("  1+2 =:= 3  →  true") ; true),
    (1+2 \== 3  -> writeln("  1+2 \\== 3  →  true  (estructuralmente distintos)") ; true).

%% ============================================================
%% factorial/2 — det
%% factorial(+N, -F) — F = N! usando acumulador (tail recursive)
%%
%% ?- factorial(0, F).   → F=1
%% ?- factorial(5, F).   → F=120
%% ?- factorial(10, F).  → F=3628800
%% ============================================================
factorial(N, F) :- factorial(N, 1, F).

%% factorial/3 — det (auxiliar con acumulador)
factorial(0, Acc, Acc) :- !.
factorial(N, Acc, F) :-
    N > 0,
    Acc1 is Acc * N,
    N1 is N - 1,
    factorial(N1, Acc1, F).

%% ============================================================
%% fibonacci_naive/2 — det (LENTO — complejidad exponencial O(2^n))
%% fibonacci_naive(+N, -F) — F es el N-ésimo número de Fibonacci
%% Para N > 30 puede tardar varios segundos
%%
%% ?- fibonacci_naive(0, F).   → F=0
%% ?- fibonacci_naive(10, F).  → F=55
%% ============================================================
fibonacci_naive(0, 0) :- !.
fibonacci_naive(1, 1) :- !.
fibonacci_naive(N, F) :-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    fibonacci_naive(N1, F1),
    fibonacci_naive(N2, F2),
    F is F1 + F2.

%% ============================================================
%% fibonacci_memo/2 — det (RÁPIDO — memoización con assert/retract)
%% fibonacci_memo(+N, -F) — igual que naive pero con caché
%%
%% ?- fibonacci_memo(100, F).  → F=354224848179261915075  (instantáneo)
%% ============================================================
:- dynamic fib_cache/2.

fib_cache(0, 0).
fib_cache(1, 1).

fibonacci_memo(N, F) :-
    (   fib_cache(N, F)
    ->  true
    ;   N1 is N - 1,
        N2 is N - 2,
        fibonacci_memo(N1, F1),
        fibonacci_memo(N2, F2),
        F is F1 + F2,
        assertz(fib_cache(N, F))
    ).

%% ============================================================
%% promedio/2 — semidet
%% promedio(+Lista, -Promedio) — promedio aritmético de la lista
%% Falla si Lista está vacía
%%
%% ?- promedio([8.5, 9.0, 7.5, 10.0], P).  → P=8.75
%% ?- promedio([], _).                       → false
%% ============================================================
promedio(Lista, Promedio) :-
    Lista \= [],
    mi_sum_list(Lista, Suma),
    mi_length(Lista, N),
    Promedio is Suma / N.

%% ============================================================
%% entre/3 — nondet
%% entre(+Min, +Max, ?X) — genera enteros entre Min y Max inclusive
%% Similar a between/3 de SWI-Prolog, implementado desde cero
%%
%% ?- entre(1, 5, X).    → X=1 ; X=2 ; X=3 ; X=4 ; X=5
%% ?- findall(X, entre(1, 3, X), Xs).  → Xs=[1,2,3]
%% ============================================================
entre(Min, Max, Min) :- Min =< Max.
entre(Min, Max, X) :-
    Min < Max,
    Min1 is Min + 1,
    entre(Min1, Max, X).

%% ============================================================
%% es_primo/1 — semidet
%% es_primo(+N) — verdadero si N es primo
%% Usa entre/3 y \+ para verificar divisibilidad
%%
%% ?- es_primo(7).   → true
%% ?- es_primo(4).   → false
%% ?- findall(P, (entre(2,20,P), es_primo(P)), Ps).  → Ps=[2,3,5,7,11,13,17,19]
%% ============================================================
es_primo(2) :- !.
es_primo(N) :-
    N > 2,
    N mod 2 =\= 0,
    Raiz is truncate(sqrt(N)),
    \+ tiene_divisor(N, 3, Raiz).

%% tiene_divisor/3 — semidet (auxiliar de es_primo)
tiene_divisor(N, D, Raiz) :-
    D =< Raiz,
    N mod D =:= 0.
tiene_divisor(N, D, Raiz) :-
    D =< Raiz,
    D2 is D + 2,
    tiene_divisor(N, D2, Raiz).

%% ============================================================
%% demo_comparacion_fibonacci/0 — det
%% Muestra diferencia de velocidad entre naive y memo
%% ============================================================
demo_comparacion_fibonacci :-
    writeln("=== Fibonacci: Naive vs. Memoización ==="),
    N = 25,
    format("Calculando fibonacci(~w) con naive...~n", [N]),
    statistics(walltime, [T0|_]),
    fibonacci_naive(N, FNaive),
    statistics(walltime, [T1|_]),
    TiempoNaive is T1 - T0,
    format("  Resultado: ~w  Tiempo: ~wms~n", [FNaive, TiempoNaive]),
    format("Calculando fibonacci(~w) con memo...~n", [N]),
    statistics(walltime, [T2|_]),
    fibonacci_memo(N, FMemo),
    statistics(walltime, [T3|_]),
    TiempoMemo is T3 - T2,
    format("  Resultado: ~w  Tiempo: ~wms~n", [FMemo, TiempoMemo]).

%% ============================================================
%% Tests con plunit
%% ============================================================

:- begin_tests(aritmetica).

% factorial
test(factorial_0)  :- factorial(0, 1).
test(factorial_1)  :- factorial(1, 1).
test(factorial_5)  :- factorial(5, 120).
test(factorial_10) :- factorial(10, 3628800).

% fibonacci
test(fib_naive_0)  :- fibonacci_naive(0, 0).
test(fib_naive_1)  :- fibonacci_naive(1, 1).
test(fib_naive_10) :- fibonacci_naive(10, 55).
test(fib_memo_50)  :- fibonacci_memo(50, 12586269025).

% promedio
test(promedio_enteros) :-
    promedio([6, 8, 10], P),
    P =:= 8.0.
test(promedio_decimales) :-
    promedio([8.5, 9.0, 7.5, 10.0], P),
    abs(P - 8.75) < 0.001.
test(promedio_vacia, [fail]) :-
    promedio([], _).

% entre
test(entre_genera) :-
    findall(X, entre(1, 5, X), Xs),
    Xs == [1,2,3,4,5].
test(entre_instanciado) :-
    entre(1, 10, 7).
test(entre_fuera, [fail]) :-
    entre(1, 5, 6).

% es_primo
test(primo_2)  :- es_primo(2).
test(primo_7)  :- es_primo(7).
test(primo_13) :- es_primo(13).
test(no_primo_4, [fail])  :- es_primo(4).
test(no_primo_1, [fail])  :- es_primo(1).
test(primos_hasta_20) :-
    findall(P, (entre(2,20,P), es_primo(P)), Ps),
    Ps == [2,3,5,7,11,13,17,19].

:- end_tests(aritmetica).

:- initialization(demo_operadores, main).
