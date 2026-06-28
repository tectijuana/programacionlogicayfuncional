%% interfaz.pl — Interfaz de texto para el sistema experto de diagnóstico
%% TecNM — Programación Lógica y Funcional, Unidad 3 Tema 3.5
%%
%% Ejecutar: swipl -g iniciar -l interfaz.pl
%% O desde el directorio padre: swipl -g iniciar -l sistema_experto/interfaz.pl

:- consult('diagnostico.pl').

%% ============================================================
%% iniciar/0 — det
%% Punto de entrada principal del sistema experto
%% ============================================================
iniciar :-
    limpiar_pantalla,
    writeln("╔════════════════════════════════════════════════╗"),
    writeln("║   Sistema Experto de Diagnóstico Educativo     ║"),
    writeln("║   TecNM — Programación Lógica y Funcional      ║"),
    writeln("╠════════════════════════════════════════════════╣"),
    writeln("║  AVISO: Solo con fines educativos.             ║"),
    writeln("║  Consulte a un médico para diagnóstico real.   ║"),
    writeln("╚════════════════════════════════════════════════╝"),
    nl,
    menu_principal.

%% ============================================================
%% menu_principal/0 — det (con loop)
%% ============================================================
menu_principal :-
    nl,
    writeln("¿Qué desea hacer?"),
    writeln("  1) Consultar paciente existente"),
    writeln("  2) Registrar nuevo paciente"),
    writeln("  3) Ver síntomas de un paciente"),
    writeln("  4) Salir"),
    write("Opción: "),
    read_term(Opcion, []),
    procesar_opcion(Opcion).

%% procesar_opcion/1 — det
procesar_opcion(1) :- !, consultar_paciente, menu_principal.
procesar_opcion(2) :- !, registrar_paciente, menu_principal.
procesar_opcion(3) :- !, ver_sintomas, menu_principal.
procesar_opcion(4) :- !,
    writeln("¡Hasta luego!"),
    halt.
procesar_opcion(_) :-
    writeln("Opción no válida. Intente de nuevo."),
    menu_principal.

%% ============================================================
%% consultar_paciente/0 — det
%% Consulta diagnósticos de un paciente existente o nuevo
%% ============================================================
consultar_paciente :-
    nl,
    writeln("=== Consulta de Diagnóstico ==="),
    pedir_id_paciente(ID),
    listar_sintomas(ID),
    nl,
    writeln("¿Desea agregar síntomas adicionales? (si/no)"),
    read_term(Resp, []),
    (   Resp == si
    ->  preguntar_sintomas(ID)
    ;   true
    ),
    nl,
    mostrar_diagnostico(ID).

%% ============================================================
%% registrar_paciente/0 — det
%% Registra un nuevo paciente con sus síntomas
%% ============================================================
registrar_paciente :-
    nl,
    writeln("=== Registro de Nuevo Paciente ==="),
    pedir_id_paciente(ID),
    limpiar_paciente(ID),
    preguntar_sintomas(ID),
    mostrar_diagnostico(ID).

%% ============================================================
%% ver_sintomas/0 — det
%% ============================================================
ver_sintomas :-
    nl,
    writeln("=== Síntomas del Paciente ==="),
    pedir_id_paciente(ID),
    listar_sintomas(ID).

%% ============================================================
%% pedir_id_paciente/1 — det
%% pedir_id_paciente(-ID) — pide identificador al usuario
%% ============================================================
pedir_id_paciente(ID) :-
    write("ID del paciente (átomo, ej: garcia_lopez): "),
    read_term(ID, []).

%% ============================================================
%% preguntar_sintomas/1 — det
%% preguntar_sintomas(+PacienteID) — interroga síntoma por síntoma
%% El usuario escribe 'listo.' cuando termina, o el síntoma como átomo
%% ============================================================
preguntar_sintomas(Paciente) :-
    nl,
    writeln("Síntomas disponibles:"),
    findall(S, sintoma_posible(S), Ss),
    format("  ~w~n", [Ss]),
    nl,
    writeln("Escriba un síntoma por línea (termine con 'listo.'):"),
    loop_sintomas(Paciente).

%% loop_sintomas/1 — det (loop de lectura de síntomas)
loop_sintomas(Paciente) :-
    write("> "),
    read_term(Input, []),
    (   Input == listo
    ->  true
    ;   Input == fin
    ->  true
    ;   (   sintoma_posible(Input)
        ->  agregar_sintoma(Paciente, Input)
        ;   format("  Síntoma '~w' no reconocido. Intente con uno de la lista.~n", [Input])
        ),
        loop_sintomas(Paciente)
    ).

%% ============================================================
%% mostrar_diagnostico/1 — det
%% mostrar_diagnostico(+PacienteID) — imprime diagnósticos posibles formateados
%% ============================================================
mostrar_diagnostico(Paciente) :-
    nl,
    writeln("┌─────────────────────────────────┐"),
    format( "│  Diagnóstico para: ~w~n", [Paciente]),
    writeln("└─────────────────────────────────┘"),
    diagnostico_posible(Paciente, Diagnosticos),
    (   Diagnosticos = []
    ->  writeln("  No se encontraron diagnósticos con los síntomas registrados."),
        writeln("  Agregue más síntomas o consulte a un médico.")
    ;   writeln("  Condiciones posibles:"),
        forall(member(D, Diagnosticos),
               format("    ✦ ~w~n", [D]))
    ),
    nl,
    writeln("  ⚠ RECORDATORIO: Este es un sistema educativo."),
    writeln("    Consulte a un médico para diagnóstico real.").

%% ============================================================
%% limpiar_pantalla/0 — det
%% ============================================================
limpiar_pantalla :-
    (current_prolog_flag(os, windows) -> true ; write('\033[2J\033[H')).
