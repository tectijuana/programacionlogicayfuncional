:- use_module(planificador).
:- use_module(library(plunit)).

:- begin_tests(horarios).

test(encuentra_asignacion_valida) :-
    asignar_horario(H),
    H \= [].

test(sin_conflictos_en_solucion) :-
    asignar_horario(H),
    sin_conflictos(H).

test(todas_las_materias_asignadas) :-
    asignar_horario(H),
    findall(M, materia(M, _, _), Materias),
    length(Materias, N),
    length(H, N).

test(bloques_dentro_de_rango) :-
    asignar_horario(H),
    forall(member(asig(_, _, Inicio, Fin), H),
           (Inicio >= 0, Fin =< 13)).

test(no_asigna_bloque_descanso) :-
    asignar_horario(H),
    forall(member(asig(_, _, Inicio, Fin), H),
           (Inicio =\= 6, Fin =\= 6)).

test(lab_asignado_a_materias_practicas) :-
    asignar_horario(H),
    member(asig(plf, Salon, _, _), H),
    (Salon == lab1 ; Salon == lab2).

test(aula_para_materia_teorica) :-
    asignar_horario(H),
    member(asig(etica, Salon, _, _), H),
    \+ (Salon == lab1),
    \+ (Salon == lab2).

:- end_tests(horarios).
