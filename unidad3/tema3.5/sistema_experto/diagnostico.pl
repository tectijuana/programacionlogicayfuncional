% =====================================================================
% Programa:    diagnostico.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 3.5 — Aplicaciones de PL
% Fecha:       2026-07-18
% Descripción: Sistema experto educativo (contexto IMSS): base de conocimiento y reglas de inferencia
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% diagnostico.pl — Base de conocimiento para sistema experto médico educativo
%% TecNM — Programación Lógica y Funcional, Unidad 3 Tema 3.5
%%
%% AVISO: Este sistema es EXCLUSIVAMENTE educativo.
%%        Para diagnóstico real, consultar a un médico certificado.
%%
%% Ejecutar: swipl -g iniciar -l interfaz.pl

:- dynamic sintoma/2.

%% ============================================================
%% HECHOS INICIALES — 5 pacientes ficticios de ejemplo
%% sintoma/2 — dynamic, nondet
%% sintoma(+PacienteID, +NombreSintoma)
%% ============================================================

% Paciente 1 — p1 — síntomas de gripe
sintoma(p1, fiebre).
sintoma(p1, tos).
sintoma(p1, dolor_cabeza).
sintoma(p1, fatiga).
sintoma(p1, dolor_muscular).

% Paciente 2 — p2 — síntomas de gastritis
sintoma(p2, dolor_abdominal).
sintoma(p2, nausea).
sintoma(p2, acidez).
sintoma(p2, vomito).

% Paciente 3 — p3 — síntomas de migraña + alergia
sintoma(p3, dolor_cabeza).
sintoma(p3, sensibilidad_luz).
sintoma(p3, nausea).
sintoma(p3, estornudos).
sintoma(p3, ojos_llorosos).

% Paciente 4 — p4 — síntomas de anemia
sintoma(p4, fatiga).
sintoma(p4, palidez).
sintoma(p4, mareo).
sintoma(p4, falta_aliento).

% Paciente 5 — p5 — síntomas de hipertensión
sintoma(p5, dolor_cabeza).
sintoma(p5, mareo).
sintoma(p5, vision_borrosa).
sintoma(p5, zumbido_oidos).

%% ============================================================
%% Síntomas posibles del sistema (para mostrar al usuario)
%% sintoma_posible/1 — det (lista de síntomas reconocidos)
%% ============================================================
sintoma_posible(fiebre).
sintoma_posible(tos).
sintoma_posible(dolor_cabeza).
sintoma_posible(fatiga).
sintoma_posible(dolor_muscular).
sintoma_posible(nausea).
sintoma_posible(vomito).
sintoma_posible(dolor_abdominal).
sintoma_posible(acidez).
sintoma_posible(diarrea).
sintoma_posible(estornudos).
sintoma_posible(congestion_nasal).
sintoma_posible(ojos_llorosos).
sintoma_posible(sensibilidad_luz).
sintoma_posible(mareo).
sintoma_posible(palidez).
sintoma_posible(falta_aliento).
sintoma_posible(vision_borrosa).
sintoma_posible(zumbido_oidos).
sintoma_posible(sed_excesiva).
sintoma_posible(miccion_frecuente).

%% ============================================================
%% REGLAS DE DIAGNÓSTICO
%% diagnostico/2 — nondet
%% diagnostico(+PacienteID, -Condicion)
%%
%% Importante: un paciente puede tener MÚLTIPLES diagnósticos
%% Usar diagnostico_posible/2 para obtener todos
%% ============================================================

%% Gripe — fiebre + tos + al menos un síntoma general
diagnostico(P, gripe) :-
    sintoma(P, fiebre),
    sintoma(P, tos),
    sintoma(P, dolor_cabeza).

diagnostico(P, gripe) :-
    sintoma(P, fiebre),
    sintoma(P, tos),
    sintoma(P, dolor_muscular).

%% Resfriado común — tos + congestión, sin fiebre alta
diagnostico(P, resfrio) :-
    sintoma(P, tos),
    sintoma(P, congestion_nasal),
    sintoma(P, estornudos),
    \+ sintoma(P, fiebre).

diagnostico(P, resfrio) :-
    sintoma(P, tos),
    sintoma(P, ojos_llorosos),
    sintoma(P, estornudos).

%% Gastritis — síntomas digestivos
diagnostico(P, gastritis) :-
    sintoma(P, dolor_abdominal),
    sintoma(P, nausea),
    sintoma(P, acidez).

diagnostico(P, gastritis) :-
    sintoma(P, dolor_abdominal),
    sintoma(P, vomito).

%% Migraña — dolor de cabeza con sensibilidad
diagnostico(P, migrana) :-
    sintoma(P, dolor_cabeza),
    sintoma(P, sensibilidad_luz),
    sintoma(P, nausea).

%% Anemia — fatiga + palidez
diagnostico(P, anemia) :-
    sintoma(P, fatiga),
    sintoma(P, palidez),
    sintoma(P, mareo).

diagnostico(P, anemia) :-
    sintoma(P, fatiga),
    sintoma(P, palidez),
    sintoma(P, falta_aliento).

%% Alergia — síntomas respiratorios sin fiebre
diagnostico(P, alergia) :-
    sintoma(P, estornudos),
    sintoma(P, ojos_llorosos),
    \+ sintoma(P, fiebre).

%% Hipertensión — síntomas cardiovasculares
diagnostico(P, hipertension) :-
    sintoma(P, dolor_cabeza),
    sintoma(P, mareo),
    sintoma(P, vision_borrosa).

diagnostico(P, hipertension) :-
    sintoma(P, zumbido_oidos),
    sintoma(P, dolor_cabeza).

%% Diabetes — síntomas metabólicos
diagnostico(P, diabetes) :-
    sintoma(P, sed_excesiva),
    sintoma(P, miccion_frecuente),
    sintoma(P, fatiga).

%% ============================================================
%% diagnostico_posible/2 — det
%% diagnostico_posible(+PacienteID, -ListaDiagnosticos)
%% Retorna TODOS los diagnósticos posibles (sin duplicados)
%% ============================================================
diagnostico_posible(Paciente, Diagnosticos) :-
    findall(D, diagnostico(Paciente, D), Ds),
    sort(Ds, Diagnosticos).  % elimina duplicados y ordena

%% ============================================================
%% agregar_sintoma/2 — det
%% agregar_sintoma(+PacienteID, +Sintoma) — agrega síntoma dinámicamente
%% ============================================================
agregar_sintoma(Paciente, Sintoma) :-
    (   sintoma(Paciente, Sintoma)
    ->  format("  (ya registrado: ~w para ~w)~n", [Sintoma, Paciente])
    ;   assertz(sintoma(Paciente, Sintoma)),
        format("  ✓ Síntoma '~w' registrado para ~w~n", [Sintoma, Paciente])
    ).

%% ============================================================
%% limpiar_paciente/1 — det
%% limpiar_paciente(+PacienteID) — elimina todos los síntomas del paciente
%% ============================================================
limpiar_paciente(Paciente) :-
    retractall(sintoma(Paciente, _)),
    format("  Síntomas de ~w eliminados.~n", [Paciente]).

%% ============================================================
%% listar_sintomas/1 — det
%% listar_sintomas(+PacienteID) — imprime los síntomas registrados
%% ============================================================
listar_sintomas(Paciente) :-
    findall(S, sintoma(Paciente, S), Ss),
    (   Ss = []
    ->  format("  ~w no tiene síntomas registrados.~n", [Paciente])
    ;   format("  Síntomas de ~w: ~w~n", [Paciente, Ss])
    ).
