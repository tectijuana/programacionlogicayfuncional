:- use_module(planificador).
:- use_module(library(plunit)).

:- begin_tests(maquiladora).

test(encuentra_asignacion_valida, [nondet]) :-
    asignar_turno(A),
    A \= [].

test(sin_conflictos_en_solucion, [nondet]) :-
    asignar_turno(A),
    sin_conflictos(A).

test(todos_los_puestos_asignados, [nondet]) :-
    asignar_turno(A),
    findall(P, puesto(P, _, _), Puestos),
    length(Puestos, N),
    length(A, N).

test(bloques_dentro_de_turno, [nondet]) :-
    asignar_turno(A),
    forall(member(asig(_, _, Inicio, Fin), A),
           (Inicio >= 0, Fin =< 15)).

test(no_asigna_bloque_descanso, [nondet]) :-
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

%% --- Duración y descanso ---

test(duracion_correcta_por_puesto, [nondet]) :-
    asignar_turno(A),
    forall(member(asig(P, _, Inicio, Fin), A),
           (puesto(P, Horas, _), Fin - Inicio + 1 =:= Horas)).

test(ningun_puesto_cruza_el_descanso, [nondet]) :-
    %% No basta que Inicio y Fin eviten el bloque 7: el bloque completo
    %% debe quedar antes o después de la comida (13:00-14:00).
    asignar_turno(A),
    forall(member(asig(_, _, Inicio, Fin), A),
           (Fin < 7 ; Inicio > 7)).

test(estaciones_asignadas_existen, [nondet]) :-
    asignar_turno(A),
    forall(member(asig(_, Est, _, _), A), estacion(Est, _)).

%% --- sin_conflictos/1 como unidad (sin pasar por el solver) ---

test(sin_conflictos_detecta_traslape, fail) :-
    sin_conflictos([asig(a, est_01, 0, 4), asig(b, est_01, 3, 6)]).

test(sin_conflictos_acepta_secuencial, [nondet]) :-
    sin_conflictos([asig(a, est_01, 0, 3), asig(b, est_01, 4, 6)]).

test(sin_conflictos_estaciones_distintas) :-
    sin_conflictos([asig(a, est_01, 0, 5), asig(b, est_02, 0, 5)]).

%% --- Integridad del dominio ---

test(ocho_puestos_definidos) :-
    findall(P, puesto(P, _, _), Puestos),
    length(Puestos, 8).

test(dos_puestos_requieren_especializada,
     set(P == [ensamble_pcb, soldadura])) :-
    puesto(P, _, si).

:- end_tests(maquiladora).
