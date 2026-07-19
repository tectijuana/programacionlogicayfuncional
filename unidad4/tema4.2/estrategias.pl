% =====================================================================
% Programa:    estrategias.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 4.2 — Estrategias de búsqueda
% Fecha:       2026-07-18
% Descripción: Cut verde vs. rojo; findall/bagof/setof
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% estrategias.pl — Cut verde/rojo, findall/bagof/setof
%% TecNM — Programación Lógica y Funcional, Unidad 4 Tema 4.2
%%
%% Ejecutar: swipl -l estrategias.pl
%% ?- demo_cut_verde.
%% ?- demo_cut_rojo.
%% ?- demo_findall.
%% ?- demo_bagof.
%% ?- demo_setof.

%% ============================================================
%% BASE DE DATOS DE EJEMPLO: Alumnos y materias TecNM
%% ============================================================

%% alumno/3 — det
%% alumno(+Matricula, +Nombre, +Promedio)
alumno('C21020001', 'García López',   8.5).
alumno('C21020002', 'Pérez Ruiz',     7.2).
alumno('C21020003', 'Ramos Torres',   9.1).
alumno('C21020004', 'López Mendez',   6.8).
alumno('C21020005', 'Sánchez Vega',   5.9).

%% cursa/2 — nondet
%% cursa(+Matricula, +Materia)
cursa('C21020001', programacion_logica).
cursa('C21020001', bases_datos).
cursa('C21020001', redes).
cursa('C21020002', programacion_logica).
cursa('C21020002', sistemas_operativos).
cursa('C21020003', programacion_logica).
cursa('C21020003', bases_datos).
cursa('C21020003', compiladores).
cursa('C21020004', programacion_logica).
cursa('C21020005', bases_datos).

%% ============================================================
%% CUT VERDE — no cambia semántica, solo eficiencia
%% ============================================================

%% maximo/3 — det (con cut verde)
%% maximo(+X, +Y, -Max) — Max es el mayor de X e Y
%% El cut es VERDE: si X>=Y, no necesitamos probar la segunda cláusula
%% (que tampoco se cumpliría), pero sin cut Prolog lo intentaría igual.
maximo(X, Y, X) :- X >= Y, !.   % cut verde
maximo(_, Y, Y).

%% Sin cut (equivalente en resultados, menos eficiente):
%% maximo_sin_cut(X, Y, X) :- X >= Y.
%% maximo_sin_cut(X, Y, Y) :- X < Y.

demo_cut_verde :-
    nl, writeln("=== Cut Verde: maximo/3 ==="),
    maximo(5, 3, M1), format("  maximo(5, 3) = ~w~n", [M1]),
    maximo(2, 7, M2), format("  maximo(2, 7) = ~w~n", [M2]),
    maximo(4, 4, M3), format("  maximo(4, 4) = ~w~n", [M3]),
    writeln("  ✓ Cut verde: mismos resultados que sin cut, pero más eficiente.").

%% ============================================================
%% CUT ROJO — CAMBIA la semántica del programa
%% ============================================================

%% clasificar_promedio/2 — det (con cut rojo)
%% Sin cut, daría múltiples respuestas para promedio en zona de traslape
clasificar_promedio(P, excelente) :- P >= 9.0, !.
clasificar_promedio(P, bien)      :- P >= 7.0, !.
clasificar_promedio(P, regular)   :- P >= 6.0, !.
clasificar_promedio(_, reprobado).

%% ¡ADVERTENCIA! Si quitamos los cuts:
%% ?- clasificar_promedio(9.5, C).
%% C = excelente ;    ← correcto
%% C = bien ;         ← INCORRECTO — también satisface P >= 7.0
%% C = regular ;      ← INCORRECTO
%% C = reprobado.     ← INCORRECTO

demo_cut_rojo :-
    nl, writeln("=== Cut Rojo: clasificar_promedio/2 ==="),
    writeln("  (Sin cuts daría múltiples clasificaciones incorrectas)"),
    clasificar_promedio(9.5, C1), format("  9.5 → ~w~n", [C1]),
    clasificar_promedio(7.8, C2), format("  7.8 → ~w~n", [C2]),
    clasificar_promedio(6.3, C3), format("  6.3 → ~w~n", [C3]),
    clasificar_promedio(5.5, C4), format("  5.5 → ~w~n", [C4]),
    writeln("  ✓ Cut rojo necesario aquí — sin él, clasificaciones se solapan.").

%% ============================================================
%% findall/3 — NUNCA FALLA, retorna [] si no hay soluciones
%% findall(+Template, +Goal, -Lista)
%% ============================================================

demo_findall :-
    nl, writeln("=== findall/3 ==="),

    % Caso normal: hay soluciones
    findall(N, alumno(_, N, _), Nombres),
    format("  Todos los alumnos: ~w~n", [Nombres]),

    % Filtrar: alumnos con promedio >= 8.0
    findall(N-P, (alumno(_, N, P), P >= 8.0), Destacados),
    format("  Promedio >= 8.0: ~w~n", [Destacados]),

    % Caso clave: NO hay soluciones → retorna [] (no falla)
    findall(X, (alumno(X,_,_), X = 'INEXISTENTE'), Vacios),
    format("  Sin resultados: ~w (lista vacía, no falla)~n", [Vacios]),

    writeln("  ✓ findall siempre tiene éxito — retorna [] si no hay soluciones.").

%% ============================================================
%% bagof/3 — FALLA si no hay soluciones
%% bagof(+Template, +Goal, -Lista)
%% ============================================================

demo_bagof :-
    nl, writeln("=== bagof/3 ==="),

    % Caso normal: agrupar materias por alumno
    % El ^ suprime la agrupación por variable no mencionada
    bagof(M, Mat^cursa(Mat, M), Materias),
    sort(Materias, MatUniq),
    format("  Materias (bagof): ~w~n", [MatUniq]),

    % bagof agrupa por la variable libre si no se suprime con ^
    writeln("  Materias por alumno (bagof agrupa):"),
    forall(
        bagof(M, cursa(Alum, M), Ms),
        format("    ~w: ~w~n", [Alum, Ms])
    ),

    % Demostrar que bagof FALLA cuando no hay soluciones
    (   bagof(X, (alumno(X,_,_), X = 'INEXISTENTE'), _)
    ->  writeln("  bagof: tuvo éxito (inesperado)")
    ;   writeln("  bagof: FALLÓ cuando no hay soluciones (comportamiento correcto)")
    ).

%% ============================================================
%% setof/3 — Como bagof pero elimina duplicados y ordena
%% ============================================================

demo_setof :-
    nl, writeln("=== setof/3 ==="),

    % Materias únicas y ordenadas
    setof(M, Alum^cursa(Alum, M), Materias),
    format("  Materias únicas ordenadas: ~w~n", [Materias]),

    % Alumnos con promedio >= 7.0, ordenados
    setof(N, Mat^P^(alumno(Mat, N, P), P >= 7.0), Aprobados),
    format("  Aprobados (>=7.0) ordenados: ~w~n", [Aprobados]),

    writeln("  ✓ setof = bagof + sort(sin duplicados, ordenado).").

%% ============================================================
%% demo_comparativa/0 — resumen de las tres diferencias
%% ============================================================
demo_comparativa :-
    nl, writeln("=== Comparativa findall vs bagof vs setof ==="),
    writeln("┌──────────┬──────────────────┬────────────┬──────────┐"),
    writeln("│ Operador │ Sin soluciones    │ Duplicados │ Orden    │"),
    writeln("├──────────┼──────────────────┼────────────┼──────────┤"),
    writeln("│ findall  │ [] (no falla)    │ Mantiene   │ inserción│"),
    writeln("│ bagof    │ FALLA            │ Mantiene   │ inserción│"),
    writeln("│ setof    │ FALLA            │ Elimina    │ ordenado │"),
    writeln("└──────────┴──────────────────┴────────────┴──────────┘").

:- initialization(main_estrategias, main).

main_estrategias :-
    demo_cut_verde,
    demo_cut_rojo,
    demo_findall,
    demo_bagof,
    demo_setof,
    demo_comparativa.
