:- use_module(planificador).
:- use_module(library(plunit)).

:- begin_tests(maquiladora).

test(encuentra_asignacion_valida) :-
    asignar_turno(A),
    A \= [].

test(sin_conflictos_en_solucion) :-
    asignar_turno(A),
    sin_conflictos(A).

test(todos_los_puestos_asignados) :-
    asignar_turno(A),
    findall(P, puesto(P, _, _), Puestos),
    length(Puestos, N),
    length(A, N).

test(bloques_dentro_de_turno) :-
    asignar_turno(A),
    forall(member(asig(_, _, Inicio, Fin), A),
           (Inicio >= 0, Fin =< 15)).

test(no_asigna_bloque_descanso) :-
    asignar_turno(A),
    forall(member(asig(_, _, Inicio, Fin), A),
           (Inicio =\= 7, Fin =\= 7)).

test(pcb_en_estacion_especializada, [nondet]) :-
    asignar_turno(A),
    member(asig(ensamble_pcb, Est, _, _), A),
    (Est == est_pcb ; Est == est_soldadura).

test(soldadura_en_estacion_especializada, [nondet]) :-
    asignar_turno(A),
    member(asig(soldadura, Est, _, _), A),
    (Est == est_pcb ; Est == est_soldadura).

test(puesto_basico_no_en_especializada, [nondet]) :-
    asignar_turno(A),
    member(asig(empaque, Est, _, _), A),
    \+ (Est == est_pcb),
    \+ (Est == est_soldadura).

:- end_tests(maquiladora).
