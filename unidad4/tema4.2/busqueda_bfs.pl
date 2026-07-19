% =====================================================================
% Programa:    busqueda_bfs.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 4.2 — Estrategias de búsqueda
% Fecha:       2026-07-18
% Descripción: Búsqueda en anchura (BFS) sobre el grafo del metro CDMX
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% busqueda_bfs.pl — Búsqueda en Amplitud (BFS) — garantiza camino mínimo
%% TecNM — Programación Lógica y Funcional, Unidad 4 Tema 4.2
%%
%% BFS usa una COLA de caminos parciales.
%% Siempre expande el nodo más cercano al origen → camino mínimo garantizado.
%%
%% Ejecutar: swipl -l busqueda_bfs.pl
%% ?- camino_minimo(balderas, pino_suarez, C).
%% ?- comparar_dfs_bfs(observatorio, zocalo).

%% Reutilizar el grafo del metro CDMX
:- consult(busqueda_dfs).

%% ============================================================
%% bfs/3 — det
%% bfs(+Inicio, +Meta, -Camino)
%%
%% Implementación con cola representada como lista de caminos parciales:
%% Cola = [[NodoActual|CaminoPrevio], [NodoActual2|...], ...]
%%
%% Por qué BFS garantiza el mínimo:
%% - Procesa nodos por "capas" — primero los a distancia 1, luego 2, etc.
%% - El PRIMER camino que llega a la Meta tiene la menor cantidad de pasos
%% - DFS puede encontrar un camino largo antes de uno corto
%% ============================================================
bfs(Inicio, Meta, Camino) :-
    bfs_cola([[Inicio]], Meta, CaminoInv),
    reverse(CaminoInv, Camino).

%% bfs_cola/3 — det (procesamiento de la cola)
%% bfs_cola(+Cola, +Meta, -CaminoInvertido)
bfs_cola([[Meta|Resto]|_], Meta, [Meta|Resto]) :- !.
bfs_cola([[Actual|Visitados]|ColaTail], Meta, Camino) :-
    findall(
        [Vecino, Actual|Visitados],
        (arista(Actual, Vecino, _), \+ member(Vecino, [Actual|Visitados])),
        NuevosCaminos
    ),
    append(ColaTail, NuevosCaminos, NuevaCola),
    NuevaCola \= [],
    bfs_cola(NuevaCola, Meta, Camino).

%% ============================================================
%% camino_minimo/3 — semidet
%% camino_minimo(+Inicio, +Meta, -Camino)
%% Interfaz amigable — retorna el camino con menos paradas
%% ============================================================
camino_minimo(Inicio, Meta, Camino) :-
    bfs(Inicio, Meta, Camino).

%% ============================================================
%% comparar_dfs_bfs/2 — det
%% comparar_dfs_bfs(+Inicio, +Meta)
%% Muestra la diferencia entre DFS y BFS para la misma búsqueda
%% ============================================================
comparar_dfs_bfs(Inicio, Meta) :-
    format("~n=== Comparación DFS vs BFS: ~w → ~w ===~n", [Inicio, Meta]),
    (   camino_dfs(Inicio, Meta, CDFS)
    ->  longitud_camino(CDFS, NDFS),
        format("DFS: ~w paradas → ~w~n", [NDFS, CDFS])
    ;   format("DFS: no encontrado~n")
    ),
    (   camino_minimo(Inicio, Meta, CBFS)
    ->  longitud_camino(CBFS, NBFS),
        format("BFS: ~w paradas → ~w~n", [NBFS, CBFS])
    ;   format("BFS: no encontrado~n")
    ).

%% ============================================================
%% demo/0
%% ============================================================
:- initialization(demo_bfs, main).

demo_bfs :-
    writeln("=== BFS: Camino Mínimo en Metro CDMX ==="),
    nl,
    camino_minimo(observatorio, zocalo, C1),
    longitud_camino(C1, N1),
    format("observatorio → zocalo: ~w paradas~n", [N1]),
    format("Ruta: ~w~n~n", [C1]),
    comparar_dfs_bfs(balderas, pino_suarez),
    nl,
    writeln("BFS garantiza el camino con MENOS paradas."),
    writeln("DFS puede encontrar un camino más largo primero.").
