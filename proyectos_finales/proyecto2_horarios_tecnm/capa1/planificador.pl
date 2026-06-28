:- module(planificador, [asignar_horario/1, imprimir_horario/1, sin_conflictos/1]).
:- use_module(library(clpfd)).

%% ============================================================
%% DOMINIO
%% ============================================================

%% materia/3 — materia(+Clave, +HorasSemana, +RequiereLab)
materia(plf,    5, si).
materia(bd,     5, si).
materia(redes,  4, no).
materia(so,     4, no).
materia(ia,     5, si).
materia(etica,  2, no).
materia(ing_sw, 4, no).
materia(arq,    3, no).

%% salon/2 — salon(+Id, +TipoSalon)
salon(101, aula).
salon(102, aula).
salon(103, aula).
salon(104, aula).
salon(lab1, laboratorio).
salon(lab2, laboratorio).

%% bloques horarios: 0 = 7:00, 1 = 8:00, ..., 13 = 20:00
%% descanso en bloque 6 (13:00) — no se puede asignar

%% ============================================================
%% ASIGNACIÓN CON CLP(FD)
%% ============================================================

%% asignar_materia/4 — asignar_materia(+Materia, -Salon, -BloqueInicio, -BloquesFin)
%% Asigna un salón y bloque de inicio a una materia
asignar_materia(Materia, Salon, Inicio, Fin) :-
    materia(Materia, Horas, RequiereLab),
    elegir_salon(RequiereLab, Salon),
    Inicio in 0..13,
    Fin    #= Inicio + Horas - 1,
    Fin    #=< 13,
    %% no se asigna en bloque 6 (descanso 13:00)
    Inicio #\= 6,
    Fin    #\= 6,
    %% no cruzar el descanso
    (Inicio #< 6 #\/ Inicio #> 6).

elegir_salon(si, lab1).
elegir_salon(si, lab2).
elegir_salon(no, 101).
elegir_salon(no, 102).
elegir_salon(no, 103).
elegir_salon(no, 104).

%% asignar_horario/1 — asignar_horario(-Asignaciones) is det
%% Genera una asignación válida para las 8 materias
asignar_horario(Asignaciones) :-
    findall(M, materia(M, _, _), Materias),
    maplist(crear_asignacion, Materias, Asignaciones),
    sin_conflictos(Asignaciones),
    maplist(label_asignacion, Asignaciones).

crear_asignacion(Materia, asig(Materia, Salon, Inicio, Fin)) :-
    asignar_materia(Materia, Salon, Inicio, Fin).

label_asignacion(asig(_, _, Inicio, Fin)) :-
    label([Inicio, Fin]).

%% ============================================================
%% RESTRICCIÓN GLOBAL — sin traslapes en mismo salón
%% ============================================================

%% sin_conflictos/1 — sin_conflictos(+Asignaciones) is det
sin_conflictos([]).
sin_conflictos([A | Resto]) :-
    maplist(no_traslapa(A), Resto),
    sin_conflictos(Resto).

%% no_traslapa/2 — no_traslapa(+A1, +A2) is det
no_traslapa(asig(_, Salon, I1, F1), asig(_, Salon, I2, F2)) :-
    %% misma sala: los bloques no deben solaparse
    F1 #< I2 #\/ F2 #< I1.
no_traslapa(asig(_, S1, _, _), asig(_, S2, _, _)) :-
    S1 \= S2.

%% ============================================================
%% UTILIDAD — impresión legible
%% ============================================================

bloque_a_hora(B, Hora) :- Hora is 7 + B.

imprimir_horario([]).
imprimir_horario([asig(Mat, Salon, Inicio, Fin) | Resto]) :-
    bloque_a_hora(Inicio, HI),
    bloque_a_hora(Fin,    HF),
    FinReal is HF + 1,
    format("~w\t~w\t~w:00 – ~w:00~n", [Mat, Salon, HI, FinReal]),
    imprimir_horario(Resto).
