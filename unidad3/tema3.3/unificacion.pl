%% unificacion.pl — Demostración de unificación y resolución SLD en SWI-Prolog
%% TecNM — Programación Lógica y Funcional, Unidad 3 Tema 3.3
%%
%% Ejecutar tests: swipl -g "run_tests(unificacion), halt" -l unificacion.pl
%% Interactivo:    swipl -l unificacion.pl

:- use_module(library(plunit)).

%% ============================================================
%% SECCIÓN 1: Ejemplos de unificación con resultados esperados
%% ============================================================
%%
%% Cada ejemplo muestra qué hace el operador = (unificación),
%% distinto de = := (igualdad numérica) y == (igualdad estructural).
%%
%% Ejecutar en swipl:
%%
%% Ejemplo 1: unificación de functor con dos argumentos
%% ?- f(X, b) = f(a, Y).
%% X = a, Y = b.
%%
%% Ejemplo 2: unificación de lista con cabeza y cola
%% ?- [H|T] = [1,2,3].
%% H = 1, T = [2, 3].
%%
%% Ejemplo 3: unificación de estructura con nombre
%% ?- punto(X,Y) = punto(3,4).
%% X = 3, Y = 4.
%%
%% Ejemplo 4: functores distintos — FALLA
%% ?- f(X) = g(X).
%% false.
%%
%% Ejemplo 5: X unifica con la expresión SIN evaluarla
%% ?- X = 1+2.
%% X = 1+2.       ← NO es 3, es la estructura 1+2
%%
%% Ejemplo 6: evaluación aritmética con =:=
%% ?- 1+2 =:= 3.
%% true.
%%
%% Ejemplo 7: unificación de listas anidadas
%% ?- [H|T] = [[1,2],3,4].
%% H = [1,2], T = [3,4].
%%
%% Ejemplo 8: unificación parcial — solo algunos argumentos se instancian
%% ?- f(X, Y, c) = f(a, b, Z).
%% X = a, Y = b, Z = c.
%%
%% Ejemplo 9: la misma variable en dos posiciones
%% ?- f(X, X) = f(1, 1).
%% X = 1.
%%
%% Ejemplo 10: la misma variable en dos posiciones — FALLA si son distintas
%% ?- f(X, X) = f(1, 2).
%% false.
%%
%% Ejemplo 11: igualdad estructural sin unificación
%% ?- foo(X) == foo(X).
%% true.
%% ?- foo(X) == foo(Y).
%% false.   ← X y Y son variables distintas aunque no instanciadas
%%
%% Ejemplo 12: unificación con lista vacía
%% ?- [H|T] = [].
%% false.   ← lista vacía no tiene cabeza ni cola

%% ============================================================
%% SECCIÓN 2: Base de hechos para demostrar resolución SLD
%% ============================================================

%% padre/2 — det
%% padre(+Padre, +Hijo) — relación de paternidad
padre(don_aurelio, carlos).
padre(don_aurelio, rosa).
padre(carlos, ana).
padre(carlos, luis).
padre(luis, pedro).

%% ancestro/2 — nondet
%% ancestro(+X, +Y) — X es ancestro de Y (padre, abuelo, bisabuelo...)
%% Traza SLD para ancestro(don_aurelio, pedro):
%%   1. Intentar cláusula 1: padre(don_aurelio, pedro)? NO → backtrack
%%   2. Intentar cláusula 2: padre(don_aurelio, Z), ancestro(Z, pedro)
%%      Z = carlos → ancestro(carlos, pedro)
%%        1. padre(carlos, pedro)? NO → backtrack
%%        2. padre(carlos, Z2), ancestro(Z2, pedro)
%%           Z2 = ana → ancestro(ana, pedro)
%%             1. padre(ana, pedro)? NO → backtrack
%%             2. padre(ana, Z3), ancestro(Z3,pedro)? NO → backtrack total de ana
%%           Z2 = luis → ancestro(luis, pedro)
%%             1. padre(luis, pedro)? SÍ → ÉXITO ✓
ancestro(X, Y) :- padre(X, Y).
ancestro(X, Y) :- padre(X, Z), ancestro(Z, Y).

%% ============================================================
%% SECCIÓN 3: unifica_y_muestra/2
%% ============================================================

%% unifica_y_muestra/2 — semidet
%% unifica_y_muestra(+T1, +T2) — intenta unificar T1 con T2 e imprime resultado
unifica_y_muestra(T1, T2) :-
    (   T1 = T2
    ->  format("✓ Unifica: ~w = ~w~n", [T1, T2])
    ;   format("✗ No unifica: ~w con ~w~n", [T1, T2])
    ).

%% demo_unificaciones/0 — det
%% Ejecuta todos los ejemplos en secuencia
demo_unificaciones :-
    writeln("=== Demostración de Unificación ==="),
    nl,
    writeln("-- Unificaciones que FUNCIONAN --"),
    unifica_y_muestra(f(X1, b), f(a, Y1)),
    format("   X=~w, Y=~w~n", [X1, Y1]),
    unifica_y_muestra(punto(A,B), punto(3,4)),
    format("   A=~w, B=~w~n", [A, B]),
    unifica_y_muestra([H|T], [1,2,3]),
    format("   H=~w, T=~w~n", [H, T]),
    nl,
    writeln("-- Unificaciones que FALLAN --"),
    unifica_y_muestra(f(1), g(1)),
    unifica_y_muestra(f(X2,X2), f(1,2)),
    _ = X2,  % suprimir advertencia de variable sin uso
    nl,
    writeln("-- Diferencia = vs =:= --"),
    X3 = 1+2,
    format("  X = 1+2 → X = ~w (no evalúa)~n", [X3]),
    (1+2 =:= 3 -> writeln("  1+2 =:= 3 → true (evalúa)") ; true).

%% ============================================================
%% SECCIÓN 4: mi_unify/2 — unificación con occurs check
%% ============================================================

%% mi_unify/2 — semidet
%% mi_unify(+T1, +T2) — unifica usando occurs check (más seguro, más lento)
%% El occurs check evita estructuras circulares como X = f(X)
%%
%% Prolog estándar NO hace occurs check por defecto (por eficiencia).
%% unify_with_occurs_check/2 lo hace explícitamente.
%%
%% Ejemplo:
%% ?- mi_unify(X, f(X)).     → false  (occurs check falla)
%% ?- X = f(X).              → X = f(f(f(...))) — estructura infinita (peligroso)
mi_unify(T1, T2) :-
    unify_with_occurs_check(T1, T2).

%% demo_occurs_check/0 — det
demo_occurs_check :-
    writeln("=== Occurs Check ==="),
    (   mi_unify(X, f(X))
    ->  writeln("  mi_unify(X, f(X)) → unifica (¡peligroso!)")
    ;   writeln("  mi_unify(X, f(X)) → false (occurs check correcto)")
    ),
    writeln("  Nota: ?- X = f(X). en swipl crea estructura circular").

%% ============================================================
%% SECCIÓN 5: Tests con plunit
%% ============================================================

:- begin_tests(unificacion).

test(unifica_functor_simple) :-
    f(X, b) = f(a, Y),
    X == a, Y == b.

test(unifica_lista_cabeza_cola) :-
    [H|T] = [1,2,3],
    H == 1, T == [2,3].

test(unifica_estructura) :-
    punto(A,B) = punto(3,4),
    A == 3, B == 4.

test(unifica_misma_variable) :-
    f(X,X) = f(1,1),
    X == 1.

test(no_unifica_functores_distintos, [fail]) :-
    f(1) = g(1).

test(no_unifica_misma_var_distintos_valores, [fail]) :-
    f(X2, X2) = f(1, 2),
    _ = X2.

test(unifica_sin_evaluar) :-
    X = 1+2,
    X == 1+2.    % no es 3, es la estructura 1+2

test(aritmetica_evalua) :-
    1+2 =:= 3.

test(unifica_lista_vacia, [fail]) :-
    [_|_] = [].

test(mi_unify_basico) :-
    mi_unify(f(a,b), f(X,Y)),
    X == a, Y == b.

test(mi_unify_occurs_check, [fail]) :-
    mi_unify(X, f(X)).

test(ancestro_directo, [nondet]) :-
    ancestro(don_aurelio, carlos).

test(ancestro_indirecto, [nondet]) :-
    ancestro(don_aurelio, pedro).

test(no_ancestro, [fail]) :-
    ancestro(pedro, don_aurelio).

test(todos_ancestros_de_pedro) :-
    findall(A, ancestro(A, pedro), As),
    msort(As, Sorted),
    msort([carlos, don_aurelio, luis], Expected),
    Sorted == Expected.

:- end_tests(unificacion).

%% ============================================================
%% SECCIÓN 6: Main — demo completa
%% ============================================================

:- initialization(main, main).

main :-
    demo_unificaciones,
    nl,
    demo_occurs_check,
    nl,
    writeln("=== Ancestros de Pedro ==="),
    findall(A, ancestro(A, pedro), Ancestros),
    format("Ancestros: ~w~n", [Ancestros]).
