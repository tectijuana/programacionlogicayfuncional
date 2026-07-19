% =====================================================================
% Programa:    sudoku.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 4.3 — Optimización / CLP(FD)
% Fecha:       2026-07-18
% Descripción: Solver de Sudoku 9×9 con CLP(FD); demo automática al cargar
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% sudoku.pl — Solver de Sudoku 9×9 con CLP(FD)
%% TecNM — Programación Lógica y Funcional, Unidad 4 Tema 4.3
%%
%% Ejecutar:
%%   swipl -g "sudoku_facil(P), resolver_sudoku(P, S), imprimir_sudoku(S), halt" -l sudoku.pl
%%   swipl -g "sudoku_dificil(P), resolver_sudoku(P, S), imprimir_sudoku(S), halt" -l sudoku.pl

:- use_module(library(clpfd)).

%% ============================================================
%% resolver_sudoku/2 — det
%% resolver_sudoku(+Puzzle, -Filas)
%% Puzzle: lista de 9 listas de 9 elementos (0 = celda vacía a rellenar)
%% Filas:  la misma cuadrícula con cada 0 sustituido por su valor resuelto
%%
%% El poder de CLP(FD): describimos las restricciones del Sudoku
%% y el motor encuentra la solución sin que nosotros programemos la búsqueda.
%% Nota: los 0 se convierten en variables frescas ANTES de declarar los
%% dominios — un 0 literal no pertenece a 1..9 y haría fallar `ins`.
%% ============================================================
resolver_sudoku(Puzzle, Filas) :-
    % Estructura: 9 filas de 9 elementos
    length(Puzzle, 9),
    maplist(length_(9), Puzzle),

    % Cada 0 del puzzle se vuelve una variable a resolver
    maplist(maplist(celda_var), Puzzle, Filas),

    % Aplanar todas las celdas en una lista
    append(Filas, Celdas),

    % Dominio: cada celda entre 1 y 9
    Celdas ins 1..9,

    % Restricción 1: todas las filas tienen valores distintos
    maplist(all_distinct, Filas),

    % Restricción 2: todas las columnas tienen valores distintos
    transpose(Filas, Columnas),
    maplist(all_distinct, Columnas),

    % Restricción 3: cada bloque 3×3 tiene valores distintos
    bloques(Filas),

    % Asignar valores concretos (búsqueda real)
    maplist(label, Filas).

%% length_/2 — det (auxiliar para maplist)
length_(N, Lista) :- length(Lista, N).

%% celda_var/2 — det
%% celda_var(+Celda, -Var)
%% 0 (celda vacía) → variable fresca; cualquier otro valor se conserva.
celda_var(0, _) :- !.
celda_var(V, V).

%% bloques/1 — det
%% Extrae los 9 bloques 3×3 y aplica all_distinct a cada uno
bloques([]).
bloques([F1,F2,F3|Resto]) :-
    bloques_fila(F1, F2, F3),
    bloques(Resto).

bloques_fila([], [], []).
bloques_fila([A,B,C|F1], [D,E,F|F2], [G,H,I|F3]) :-
    all_distinct([A,B,C,D,E,F,G,H,I]),
    bloques_fila(F1, F2, F3).

%% ============================================================
%% imprimir_sudoku/1 — det
%% Imprime el tablero en formato legible con separadores de bloque
%% ============================================================
imprimir_sudoku(Filas) :-
    nl,
    writeln("┌───────┬───────┬───────┐"),
    imprimir_filas(Filas, 1).

imprimir_filas([], _).
imprimir_filas([Fila|Resto], N) :-
    write("│ "),
    imprimir_fila(Fila, 1),
    writeln(""),
    N1 is N + 1,
    (   N mod 3 =:= 0, Resto \= []
    ->  writeln("├───────┼───────┼───────┤")
    ;   true
    ),
    (   Resto = []
    ->  writeln("└───────┴───────┴───────┘")
    ;   true
    ),
    imprimir_filas(Resto, N1).

imprimir_fila([], _).
imprimir_fila([V|Resto], N) :-
    format("~w ", [V]),
    N1 is N + 1,
    (N mod 3 =:= 0, Resto \= [] -> write("│ ") ; true),
    imprimir_fila(Resto, N1).

%% ============================================================
%% Puzzles de ejemplo
%% 0 = celda vacía
%% ============================================================

%% sudoku_facil/1 — det
%% Puzzle nivel fácil (muchas celdas dadas)
sudoku_facil([
    [5,3,0, 0,7,0, 0,0,0],
    [6,0,0, 1,9,5, 0,0,0],
    [0,9,8, 0,0,0, 0,6,0],

    [8,0,0, 0,6,0, 0,0,3],
    [4,0,0, 8,0,3, 0,0,1],
    [7,0,0, 0,2,0, 0,0,6],

    [0,6,0, 0,0,0, 2,8,0],
    [0,0,0, 4,1,9, 0,0,5],
    [0,0,0, 0,8,0, 0,7,9]
]).

%% sudoku_dificil/1 — det
%% Puzzle nivel difícil (pocas celdas dadas — CLP(FD) demuestra su poder aquí)
sudoku_dificil([
    [8,0,0, 0,0,0, 0,0,0],
    [0,0,3, 6,0,0, 0,0,0],
    [0,7,0, 0,9,0, 2,0,0],

    [0,5,0, 0,0,7, 0,0,0],
    [0,0,0, 0,4,5, 7,0,0],
    [0,0,0, 1,0,0, 0,3,0],

    [0,0,1, 0,0,0, 0,6,8],
    [0,0,8, 5,0,0, 0,1,0],
    [0,9,0, 0,0,0, 4,0,0]
]).

%% ============================================================
%% demo/0
%% ============================================================
:- initialization(demo_sudoku, main).

demo_sudoku :-
    writeln("=== Sudoku Solver con CLP(FD) ==="),
    nl,
    writeln("Resolviendo puzzle fácil..."),
    sudoku_facil(P1),
    statistics(walltime, [T0|_]),
    resolver_sudoku(P1, S1),
    statistics(walltime, [T1|_]),
    Tiempo is T1 - T0,
    imprimir_sudoku(S1),
    format("Resuelto en ~wms~n", [Tiempo]),
    nl,
    writeln("Resolviendo puzzle difícil (el más difícil del mundo según The Telegraph)..."),
    sudoku_dificil(P2),
    statistics(walltime, [T2|_]),
    resolver_sudoku(P2, S2),
    statistics(walltime, [T3|_]),
    Tiempo2 is T3 - T2,
    imprimir_sudoku(S2),
    format("Resuelto en ~wms~n~n", [Tiempo2]),
    writeln("CLP(FD) usa propagación de restricciones, no backtracking ciego.").
