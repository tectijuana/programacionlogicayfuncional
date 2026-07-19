% =====================================================================
% Programa:    hechos_consultas.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 3.1 — Fundamentos de PL
% Fecha:       2026-07-18
% Descripción: Hechos y consultas: base de datos organizacional TecNM Tijuana
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
% ============================================================
% Tema 3.1 — Hechos, consultas y base de conocimiento
% TecNM Tijuana — Programación Lógica y Funcional
% ============================================================
%
% Ejecutar:
%   swipl -l hechos_consultas.pl
%   ?- imparte(Prof, programacion_logica, _).
%
% Para correr tests:
%   swipl -g "run_tests, halt" -l hechos_consultas.pl

:- use_module(library(plunit)).

% ============================================================
% HECHOS — Base de conocimiento TecNM Tijuana
% ============================================================

% departamento/1 — det
% departamento(+Nombre)
% Verdadero si Nombre es un departamento del TecNM Tijuana.
departamento(sistemas).
departamento(industrial).
departamento(electrica).
departamento(civil).

% profesor/3 — det
% profesor(+Id, +Nombre, +Departamento)
profesor(solis_rene,      'Rene Solis',      sistemas).
profesor(garcia_ana,      'Ana Garcia',      sistemas).
profesor(lopez_mario,     'Mario Lopez',     industrial).
profesor(torres_lucia,    'Lucia Torres',    industrial).
profesor(mendez_carlos,   'Carlos Mendez',   electrica).
profesor(rios_sofia,      'Sofia Rios',      electrica).
profesor(vargas_pedro,    'Pedro Vargas',    civil).
profesor(luna_elena,      'Elena Luna',      civil).

% materia/2 — det
% materia(+Id, +Nombre)
materia(prog_logica,  'Programación Lógica y Funcional').
materia(bases_datos,  'Bases de Datos').
materia(redes,        'Redes de Computadoras').
materia(sist_op,      'Sistemas Operativos').
materia(compiladores, 'Compiladores').
materia(inteligencia, 'Inteligencia Artificial').

% grupo/3 — det
% grupo(+Id, +Materia, +Semestre)
grupo(sc7a, prog_logica,  7).
grupo(sc7b, prog_logica,  7).
grupo(sc5a, bases_datos,  5).
grupo(sc5b, bases_datos,  5).
grupo(sc6a, redes,        6).
grupo(sc4a, sist_op,      4).
grupo(sc8a, compiladores, 8).
grupo(sc8b, inteligencia, 8).

% imparte/3 — nondet
% imparte(?Profesor, ?Materia, ?Grupo)
% Verdadero si el Profesor imparte la Materia en el Grupo dado.
imparte(solis_rene,    prog_logica,  sc7a).
imparte(solis_rene,    prog_logica,  sc7b).
imparte(solis_rene,    inteligencia, sc8b).
imparte(garcia_ana,    bases_datos,  sc5a).
imparte(garcia_ana,    bases_datos,  sc5b).
imparte(lopez_mario,   redes,        sc6a).
imparte(torres_lucia,  sist_op,      sc4a).
imparte(mendez_carlos, compiladores, sc8a).
imparte(rios_sofia,    inteligencia, sc8b).
imparte(vargas_pedro,  redes,        sc6a).

% ============================================================
% PREDICADOS DERIVADOS
% ============================================================

% mismo_departamento/2 — nondet
% mismo_departamento(?P1, ?P2)
% Verdadero si P1 y P2 pertenecen al mismo departamento.
% No incluye el caso P1 = P2 (un profesor no es colega de sí mismo).
mismo_departamento(P1, P2) :-
    profesor(P1, _, Dept),
    profesor(P2, _, Dept),
    P1 \= P2.

% colegas/2 — nondet
% colegas(?P1, ?P2)
% Verdadero si P1 y P2 imparten alguna materia en el mismo grupo.
% Orden canónico: evita duplicados (A,B) y (B,A).
colegas(P1, P2) :-
    imparte(P1, _, Grupo),
    imparte(P2, _, Grupo),
    P1 @< P2.

% carga_academica/2 — det cuando Profesor está instanciado
% carga_academica(+Profesor, -NumGrupos)
% Cuenta cuántos grupos tiene asignados un profesor.
carga_academica(Profesor, NumGrupos) :-
    profesor(Profesor, _, _),
    findall(G, imparte(Profesor, _, G), Grupos),
    length(Grupos, NumGrupos).

% materias_de_departamento/2 — nondet
% materias_de_departamento(+Dept, -Materia)
% Materias que imparte al menos un profesor del departamento Dept.
materias_de_departamento(Dept, Materia) :-
    profesor(Profesor, _, Dept),
    imparte(Profesor, Materia, _).

% ============================================================
% CONSULTAS DE EJEMPLO — ejecutar en el REPL
% ============================================================
%
% 1. ¿Quién imparte Programación Lógica?
%    ?- imparte(Prof, prog_logica, _).
%    % Prof = solis_rene (múltiples soluciones con ;)
%
% 2. ¿Qué materias imparte solis_rene?
%    ?- imparte(solis_rene, Materia, _).
%    % Materia = prog_logica ; Materia = inteligencia
%
% 3. ¿En qué departamento está garcia_ana?
%    ?- profesor(garcia_ana, _, Dept).
%    % Dept = sistemas
%
% 4. ¿Quiénes son colegas de departamento de solis_rene?
%    ?- mismo_departamento(solis_rene, Colega).
%    % Colega = garcia_ana
%
% 5. ¿Qué pares de profesores comparten un grupo?
%    ?- colegas(P1, P2).
%    % P1 = lopez_mario, P2 = vargas_pedro (redes sc6a)
%    % P1 = rios_sofia, P2 = solis_rene (inteligencia sc8b)
%
% 6. ¿Cuántos grupos tiene solis_rene?
%    ?- carga_academica(solis_rene, N).
%    % N = 3
%
% 7. ¿Qué materias imparte el departamento de sistemas?
%    ?- materias_de_departamento(sistemas, M).
%    % M = prog_logica ; M = inteligencia ; M = bases_datos
%
% 8. ¿Qué profesor tiene la mayor carga? (requiere findall externo)
%    ?- findall(N-P, carga_academica(P, N), Pares), max_member(Max-Quien, Pares).
%    % Max = 3, Quien = solis_rene
%
% 9. ¿Existe algún profesor que imparta más de una materia distinta?
%    ?- imparte(P, M1, _), imparte(P, M2, _), M1 \= M2.
%    % P = solis_rene, M1 = prog_logica, M2 = inteligencia
%
% 10. ¿Cuántos profesores hay en el departamento de sistemas?
%     ?- findall(P, profesor(P, _, sistemas), Ps), length(Ps, N).
%     % N = 2
%
% 11. ¿Cuáles son todos los grupos del semestre 7?
%     ?- grupo(G, _, 7).
%     % G = sc7a ; G = sc7b
%
% 12. ¿Qué materias se imparten en semestre 8?
%     ?- grupo(_, M, 8), materia(M, Nombre).
%     % M = compiladores, Nombre = 'Compiladores'
%     % M = inteligencia, Nombre = 'Inteligencia Artificial'
%
% 13. ¿Hay algún grupo sin profesor asignado?
%     ?- grupo(G, _, _), \+ imparte(_, _, G).
%     % false (todos los grupos tienen al menos un profesor)
%
% 14. ¿Qué profesores no tienen grupo asignado?
%     ?- profesor(P, _, _), \+ imparte(P, _, _).
%     % P = luna_elena ; P = torres_lucia ... (nota: torres_lucia sí tiene)
%
% 15. Lista de todos los profesores con su nombre completo:
%     ?- findall(Id-Nombre, profesor(Id, Nombre, _), Lista).

% ============================================================
% TESTS con plunit
% ============================================================

:- begin_tests(hechos_consultas).

test(departamento_existe) :-
    departamento(sistemas),
    departamento(civil).

test(profesor_en_departamento) :-
    profesor(solis_rene, _, sistemas).

test(imparte_pl) :-
    imparte(solis_rene, prog_logica, sc7a).

test(mismo_dept_bidireccional) :-
    mismo_departamento(solis_rene, garcia_ana),
    mismo_departamento(garcia_ana, solis_rene).

test(mismo_dept_no_reflexivo) :-
    \+ mismo_departamento(solis_rene, solis_rene).

test(carga_academica_solis) :-
    carga_academica(solis_rene, 3).

test(colegas_comparten_grupo) :-
    colegas(rios_sofia, solis_rene).

:- end_tests(hechos_consultas).
