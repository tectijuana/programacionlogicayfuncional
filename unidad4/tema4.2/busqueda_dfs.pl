% =====================================================================
% Programa:    busqueda_dfs.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 4.2 — Estrategias de búsqueda
% Fecha:       2026-07-18
% Descripción: Búsqueda en profundidad (DFS) sobre el grafo del metro CDMX
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% busqueda_dfs.pl — Búsqueda en Profundidad (DFS) en Prolog
%% TecNM — Programación Lógica y Funcional, Unidad 4 Tema 4.2
%%
%% Grafo: Metro CDMX simplificado (15 estaciones, líneas 1, 2, 3)
%%
%% Ejecutar: swipl -l busqueda_dfs.pl
%% ?- camino_dfs(balderas, consulado, Camino).
%% ?- camino_dfs(observatorio, pantitlan, C), longitud_camino(C, N).

%% ============================================================
%% GRAFO: Metro CDMX (simplificado, bidireccional)
%% conecta/3 — nondet
%% conecta(+EstacionA, +EstacionB, +Linea)
%% ============================================================

% Línea 1 (rosa) — Observatorio a Pantitlán
conecta(observatorio,   tacubaya,       linea1).
conecta(tacubaya,       juanacatlan,    linea1).
conecta(juanacatlan,    chapultepec,    linea1).
conecta(chapultepec,    sevilla,        linea1).
conecta(sevilla,        insurgentes,    linea1).
conecta(insurgentes,    cuauhtemoc,     linea1).
conecta(cuauhtemoc,     balderas,       linea1).
conecta(balderas,       salto_agua,     linea1).
conecta(salto_agua,     isabel_la_cat,  linea1).
conecta(isabel_la_cat,  pino_suarez,    linea1).
conecta(pino_suarez,    merced,         linea1).
conecta(merced,         candelaria,     linea1).
conecta(candelaria,     san_lazaro,     linea1).
conecta(san_lazaro,     moctezuma,      linea1).
conecta(moctezuma,      balbuena,       linea1).
conecta(balbuena,       boulevard_pto,  linea1).
conecta(boulevard_pto,  pantitlan,      linea1).

% Línea 2 (azul) — Cuatro Caminos a Tasqueña (parcial)
conecta(cuatro_caminos,  panteones,     linea2).
conecta(panteones,       tacuba,        linea2).
conecta(tacuba,          cuitlahuac,    linea2).
conecta(cuitlahuac,      popotla,       linea2).
conecta(popotla,         col_agricola,  linea2).
conecta(col_agricola,    colegio_mil,   linea2).
conecta(colegio_mil,     normal,        linea2).
conecta(normal,          san_cosme,     linea2).
conecta(san_cosme,       revolucion,    linea2).
conecta(revolucion,      hidalgo,       linea2).
conecta(hidalgo,         bellas_artes,  linea2).
conecta(bellas_artes,    allende,       linea2).
conecta(allende,         zocalo,        linea2).
conecta(zocalo,          pino_suarez,   linea2).
conecta(pino_suarez,     san_antonio,   linea2).
conecta(san_antonio,     chabacano,     linea2).
conecta(chabacano,       viaducto,      linea2).
conecta(viaducto,        xola,          linea2).
conecta(xola,            villa_de_cort, linea2).
conecta(villa_de_cort,   nativitas,     linea2).
conecta(nativitas,       portales,      linea2).
conecta(portales,        ermita,        linea2).
conecta(ermita,          general_anaya, linea2).
conecta(general_anaya,   tasquena,      linea2).

% Línea 3 (verde olivo) — conexiones clave
conecta(indios_verdes,  deportivo18,    linea3).
conecta(deportivo18,    potrero,        linea3).
conecta(potrero,        la_raza,        linea3).
conecta(la_raza,        tlatelolco,     linea3).
conecta(tlatelolco,     guerrero,       linea3).
conecta(guerrero,       hidalgo,        linea3).
conecta(hidalgo,        juarez,         linea3).
conecta(juarez,         balderas,       linea3).
conecta(balderas,       ninos_heroes,   linea3).
conecta(ninos_heroes,   hospital_gral,  linea3).
conecta(hospital_gral,  centro_medico,  linea3).
conecta(centro_medico,  etiopia,        linea3).
conecta(etiopia,        eugenia,        linea3).
conecta(eugenia,        division_norte, linea3).
conecta(division_norte, zapata,         linea3).
conecta(zapata,         coyoacan,       linea3).
conecta(coyoacan,       viveros,        linea3).
conecta(viveros,        miguel_angel,   linea3).
conecta(miguel_angel,   copilco,        linea3).
conecta(copilco,        universidad,    linea3).

% Transferencias entre líneas (mismo nombre, diferente línea — ya implícito)
conecta(tacubaya,     observatorio,    linea1).  % Línea 9 también aquí
conecta(consulado,    candelaria,      linea4).  % conexión adicional

%% Grafo bidireccional — si A conecta con B, B conecta con A
arista(A, B, L) :- conecta(A, B, L).
arista(A, B, L) :- conecta(B, A, L).

%% ============================================================
%% dfs/4 — nondet
%% dfs(+Inicio, +Meta, +Visitados, -Camino)
%% Visitados: lista de nodos ya explorados (evita ciclos)
%% Camino: lista de nodos del camino encontrado
%% ============================================================
dfs(Meta, Meta, _, [Meta]).
dfs(Inicio, Meta, Visitados, [Inicio|Camino]) :-
    Inicio \= Meta,
    arista(Inicio, Siguiente, _),
    \+ member(Siguiente, Visitados),
    dfs(Siguiente, Meta, [Siguiente|Visitados], Camino).

%% ============================================================
%% camino_dfs/3 — semidet (primera solución)
%% camino_dfs(+Inicio, +Meta, -Camino)
%% Interfaz amigable — retorna el PRIMER camino encontrado
%% (no necesariamente el más corto)
%% ============================================================
camino_dfs(Inicio, Meta, Camino) :-
    dfs(Inicio, Meta, [Inicio], Camino), !.

%% ============================================================
%% longitud_camino/2 — det
%% longitud_camino(+Camino, -N) — N = número de paradas
%% ============================================================
longitud_camino(Camino, N) :-
    length(Camino, Total),
    N is Total - 1.  % paradas = nodos - 1

%% ============================================================
%% todos_caminos_dfs/3 — det
%% todos_caminos_dfs(+Inicio, +Meta, -Caminos)
%% Recolecta TODOS los caminos (puede ser lento en grafos grandes)
%% ============================================================
todos_caminos_dfs(Inicio, Meta, Caminos) :-
    findall(C, dfs(Inicio, Meta, [Inicio], C), Caminos).

%% ============================================================
%% demo/0 — det
%% ============================================================
:- initialization(demo, main).

demo :-
    writeln("=== Búsqueda DFS en Metro CDMX ==="),
    nl,
    (   camino_dfs(balderas, pino_suarez, C1)
    ->  longitud_camino(C1, N1),
        format("balderas → pino_suarez: ~w paradas~n", [N1]),
        format("Camino: ~w~n", [C1])
    ;   writeln("No se encontró camino")
    ),
    nl,
    (   camino_dfs(observatorio, zocalo, C2)
    ->  longitud_camino(C2, N2),
        format("observatorio → zocalo: ~w paradas~n", [N2]),
        format("Camino: ~w~n", [C2])
    ;   writeln("No se encontró camino")
    ),
    nl,
    writeln("Nota: DFS no garantiza el camino más corto."),
    writeln("Usar busqueda_bfs.pl para camino mínimo.").
