:- module(planificador, [asignar_turno/1, imprimir_turno/1, sin_conflictos/1,
                         puesto/3, estacion/2]).
:- use_module(library(clpfd)).

%% ============================================================
%% DOMINIO — planta maquiladora turno matutino
%% ============================================================

%% puesto/3 — puesto(+Clave, +HorasBloque, +RequiereEspecializada)
puesto(ensamble_pcb,       5, si).
puesto(soldadura,          5, si).
puesto(inspeccion_calidad, 4, no).
puesto(empaque,            4, no).
puesto(logistica,          5, no).
puesto(capacitacion,       2, no).
puesto(mantenimiento,      4, no).
puesto(control_inventario, 3, no).

%% estacion/2 — estacion(+Id, +Tipo)
%% Estaciones especializadas: equipo de soldadura/PCB — solo personal certificado
estacion(est_pcb,      especializada).
estacion(est_soldadura, especializada).
estacion(est_01,       basica).
estacion(est_02,       basica).
estacion(est_03,       basica).
estacion(est_04,       basica).

%% Bloques de turno: 0 = 6:00, 1 = 7:00, ..., 15 = 21:00
%% Descanso obligatorio en bloque 7 (13:00–14:00)

%% ============================================================
%% ASIGNACIÓN CON CLP(FD)
%% ============================================================

%% asignar_puesto/4 — asignar_puesto(+Puesto, -Estacion, -BloqueInicio, -BloqueFin)
asignar_puesto(Puesto, Estacion, Inicio, Fin) :-
    puesto(Puesto, Horas, RequiereEsp),
    elegir_estacion(RequiereEsp, Estacion),
    Inicio in 0..15,
    Fin    #= Inicio + Horas - 1,
    Fin    #=< 15,
    %% Descanso obligatorio: el bloque de trabajo completo debe quedar
    %% antes o después del bloque 7 — no basta excluir los extremos.
    (Fin #< 7 #\/ Inicio #> 7).

elegir_estacion(si, est_pcb).
elegir_estacion(si, est_soldadura).
elegir_estacion(no, est_01).
elegir_estacion(no, est_02).
elegir_estacion(no, est_03).
elegir_estacion(no, est_04).

%% asignar_turno/1 — asignar_turno(-Asignaciones) is det
asignar_turno(Asignaciones) :-
    findall(P, puesto(P, _, _), Puestos),
    maplist(crear_asignacion, Puestos, Asignaciones),
    sin_conflictos(Asignaciones),
    maplist(label_asignacion, Asignaciones).

crear_asignacion(Puesto, asig(Puesto, Estacion, Inicio, Fin)) :-
    asignar_puesto(Puesto, Estacion, Inicio, Fin).

label_asignacion(asig(_, _, Inicio, Fin)) :-
    label([Inicio, Fin]).

%% ============================================================
%% RESTRICCIÓN GLOBAL — sin traslapes en misma estación
%% ============================================================

%% sin_conflictos/1 — sin_conflictos(+Asignaciones) is det
sin_conflictos([]).
sin_conflictos([A | Resto]) :-
    maplist(no_traslapa(A), Resto),
    sin_conflictos(Resto).

%% no_traslapa/2 — no_traslapa(+A1, +A2) is det
no_traslapa(asig(_, Est, I1, F1), asig(_, Est, I2, F2)) :-
    F1 #< I2 #\/ F2 #< I1.
no_traslapa(asig(_, E1, _, _), asig(_, E2, _, _)) :-
    E1 \= E2.

%% ============================================================
%% UTILIDAD — impresión legible
%% ============================================================

bloque_a_hora(B, Hora) :- Hora is 6 + B.

imprimir_turno([]).
imprimir_turno([asig(Puesto, Estacion, Inicio, Fin) | Resto]) :-
    bloque_a_hora(Inicio, HI),
    bloque_a_hora(Fin,    HF),
    FinReal is HF + 1,
    format("~w\t~w\t~w:00 – ~w:00~n", [Puesto, Estacion, HI, FinReal]),
    imprimir_turno(Resto).
