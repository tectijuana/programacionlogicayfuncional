% =====================================================================
% Programa:    horarios_tec.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 4.3 — Optimización / CLP(FD)
% Fecha:       2026-07-18
% Descripción: Asignación de horarios TecNM como problema CSP con CLP(FD)
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% horarios_tec.pl — Asignación de horarios TecNM como CSP con CLP(FD)
%% TecNM — Programación Lógica y Funcional, Unidad 4 Tema 4.3
%%
%% Variables de decisión:
%%   - Hora: slot de hora (7=7am, 8=8am, ..., 20=8pm)
%%   - Salon: número de salón (1..5, salones 4-5 son laboratorios)
%%
%% Ejecutar:
%%   swipl -g "generar_horario(H), imprimir_horario(H), halt" -l horarios_tec.pl

:- use_module(library(clpfd)).

%% ============================================================
%% Materias del plan ISC — semestre 6
%% materia/3 — det
%% materia(+ID, +Nombre, +Tipo)   Tipo: aula | laboratorio
%% ============================================================
materia(1, 'Prog. Lógica y Funcional', aula).
materia(2, 'Bases de Datos',           aula).
materia(3, 'Redes de Computadoras',    laboratorio).
materia(4, 'Sistemas Operativos',      laboratorio).
materia(5, 'Compiladores',             aula).
materia(6, 'Inteligencia Artificial',  aula).

%% ============================================================
%% generar_horario/1 — det
%% generar_horario(-Asignaciones)
%% Asignaciones: lista de asignacion(ID, Nombre, Hora, Salon)
%% ============================================================
generar_horario(Asignaciones) :-
    findall(materia(ID, Nombre, Tipo), materia(ID, Nombre, Tipo), Materias),

    % Crear variables de decisión para cada materia
    maplist(crear_vars, Materias, Vars),

    % Aplicar restricciones
    aplicar_restricciones(Materias, Vars),

    % Etiquetar (buscar valores concretos)
    % extraer_vars produce pares [H,S]; label/1 necesita la lista plana
    maplist(extraer_vars, Vars, VarsPares),
    append(VarsPares, VarsPlanas),
    label(VarsPlanas),

    % Construir resultado
    maplist(construir_asignacion, Materias, Vars, Asignaciones).

%% crear_vars/2 — det
%% Para cada materia crea variables Hora y Salon con dominios
crear_vars(materia(_, _, Tipo), hora_salon(H, S)) :-
    H in 7..20,
    (   Tipo == laboratorio
    ->  S in 4..5      % laboratorios solo en salones 4 y 5
    ;   S in 1..5      % aulas en cualquier salón
    ).

%% extraer_vars/2 — det
extraer_vars(hora_salon(H, S), [H, S]).

%% construir_asignacion/3 — det
construir_asignacion(materia(ID, Nombre, _), hora_salon(H, S),
                     asignacion(ID, Nombre, H, S)).

%% ============================================================
%% aplicar_restricciones/2 — det
%% Aplica todas las restricciones del CSP
%% ============================================================
aplicar_restricciones(_Materias, Vars) :-
    % Restricción 1: no dos materias en el mismo salón a la misma hora
    pares(Vars, Pares),
    maplist(no_conflicto, Pares),

    % Restricción 2: descanso de 13 a 14 horas (no asignar a la 13)
    maplist(no_hora_comida, Vars),

    % Restricción 3: no clases antes de las 7 ni después de las 20
    % (ya cubierto por el dominio H in 7..20)

    % Restricción 4: máximo 4 materias consecutivas por salón
    % (simplificación: horas separadas al menos 1 por salón)
    true.

%% no_conflicto/1 — det
%% Dos materias no pueden estar en el mismo salón a la misma hora
no_conflicto(hora_salon(H1,S1) - hora_salon(H2,S2)) :-
    (H1 #= H2) #==> (S1 #\= S2).

%% no_hora_comida/1 — det
no_hora_comida(hora_salon(H, _)) :-
    H #\= 13.

%% pares/2 — det
%% Genera todos los pares distintos de elementos
pares([], []).
pares([X|Xs], Pares) :-
    maplist(par(X), Xs, ParesX),
    pares(Xs, RestosPares),
    append(ParesX, RestosPares, Pares).

par(X, Y, X-Y).

%% ============================================================
%% imprimir_horario/1 — det
%% Imprime el horario en formato de tabla
%% ============================================================
imprimir_horario(Asignaciones) :-
    nl,
    writeln("╔══════════════════════════════════════════════════╗"),
    writeln("║         HORARIO — TecNM ISC Semestre 6           ║"),
    writeln("╠══════════╦══════════════════════════╦════════════╣"),
    writeln("║  Hora    ║  Materia                 ║  Salón     ║"),
    writeln("╠══════════╬══════════════════════════╬════════════╣"),
    msort(Asignaciones, Ordenadas),
    maplist(imprimir_fila_horario, Ordenadas),
    writeln("╚══════════╩══════════════════════════╩════════════╝").

imprimir_fila_horario(asignacion(_, Nombre, Hora, Salon)) :-
    Hora2 is Hora + 1,
    format("║  ~w:00-~w:00 ║  ~w~*|  ║  Salón ~w    ║~n",
           [Hora, Hora2, Nombre, 26, Salon]).

%% ============================================================
%% demo/0
%% ============================================================
:- initialization(demo_horarios, main).

demo_horarios :-
    writeln("Generando horario TecNM con CLP(FD)..."),
    writeln("(Puede haber múltiples soluciones válidas)"),
    nl,
    generar_horario(Horario),
    imprimir_horario(Horario).
