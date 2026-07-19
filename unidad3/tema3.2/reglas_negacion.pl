% =====================================================================
% Programa:    reglas_negacion.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 3.2 — Sistemas formales y lógica de predicados
% Fecha:       2026-07-18
% Descripción: Reglas y negación como falla (\+): elegibilidad para beca TecNM
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
% ============================================================
% Tema 3.2 — Reglas, Negación como Falla y Cut
% TecNM Tijuana — Programación Lógica y Funcional
% Contexto: Sistema de becas TecNM
% ============================================================
%
% Ejecutar:
%   swipl -l reglas_negacion.pl
%   ?- todos_elegibles(Lista).
%
% Tests:
%   swipl -g "run_tests, halt" -l reglas_negacion.pl

:- use_module(library(plunit)).

% ============================================================
% BASE DE HECHOS — Alumnos TecNM
% alumno/5 — det
% alumno(+Id, +Nombre, +Promedio, +Creditos, +AdeudoBiblioteca)
% AdeudoBiblioteca: si (tiene adeudo) | no (sin adeudo)
% ============================================================

alumno(c21010001, 'García Ramírez Ana',     9.6, 245, no).
alumno(c21010002, 'López Torres Luis',      7.8, 180, no).
alumno(c21010003, 'Martínez Soto Karla',   8.3, 210, si).
alumno(c21010004, 'Hernández Cruz Jorge',   6.1,  95, no).
alumno(c21010005, 'Rios Vega Paola',        9.8, 252, no).
alumno(c21010006, 'Fuentes Díaz Marco',     5.9,  40, si).
alumno(c21010007, 'Salazar Peña Diana',     8.9, 238, no).
alumno(c21010008, 'Mendoza Ruiz Óscar',    7.2,  18, no).
alumno(c21010009, 'Castillo Mora Fernanda', 9.1, 240, no).
alumno(c21010010, 'Vega Sánchez Roberto',  6.8, 120, si).

% ============================================================
% REGLAS DE NEGOCIO — Sistema de Becas
% ============================================================

% elegible_beca/1 — semidet
% elegible_beca(+Matricula)
% Verdadero si el alumno cumple todos los requisitos de beca:
%   promedio >= 8.0, créditos >= 30, sin adeudo en biblioteca.
elegible_beca(Matricula) :-
    alumno(Matricula, _, Promedio, Creditos, Adeudo),
    Promedio >= 8.0,
    Creditos >= 30,
    Adeudo = no.

% beca_excelencia/1 — semidet
% beca_excelencia(+Matricula)
% Requisito adicional: promedio >= 9.5.
beca_excelencia(Matricula) :-
    alumno(Matricula, _, Promedio, Creditos, Adeudo),
    Promedio >= 9.5,
    Creditos >= 30,
    Adeudo = no.

% en_riesgo/1 — semidet
% en_riesgo(+Matricula)
% Verdadero si el alumno tiene promedio < 6.5 O créditos < 20.
% Usa disyunción (;) para expresar la condición OR.
en_riesgo(Matricula) :-
    alumno(Matricula, _, Promedio, Creditos, _),
    (Promedio < 6.5 ; Creditos < 20).

% puede_titularse/1 — semidet
% puede_titularse(+Matricula)
% Requisitos: créditos >= 240, promedio >= 7.0, sin adeudo.
puede_titularse(Matricula) :-
    alumno(Matricula, _, Promedio, Creditos, Adeudo),
    Creditos >= 240,
    Promedio >= 7.0,
    Adeudo = no.

% no_elegible_razon/2 — nondet
% no_elegible_razon(+Matricula, -Razon)
% Explica por qué un alumno no es elegible para beca.
% Puede producir múltiples razones (una por cada condición incumplida).
no_elegible_razon(Matricula, promedio_insuficiente) :-
    alumno(Matricula, _, Promedio, _, _),
    Promedio < 8.0.
no_elegible_razon(Matricula, creditos_insuficientes) :-
    alumno(Matricula, _, _, Creditos, _),
    Creditos < 30.
no_elegible_razon(Matricula, adeudo_biblioteca) :-
    alumno(Matricula, _, _, _, si).

% ============================================================
% CUT — Demostración de cut verde vs. cut rojo
% ============================================================

% clasificar_promedio/2 — det (con cut)
% clasificar_promedio(+Promedio, -Categoria)
%
% CUT VERDE: el cut aquí no cambia el resultado lógico del predicado,
% solo evita búsqueda innecesaria. Si Promedio >= 9.0, sabemos que
% las cláusulas de abajo no aplican — el cut lo confirma eficientemente.
clasificar_promedio(Promedio, excelente) :-
    Promedio >= 9.0, !.
clasificar_promedio(Promedio, bueno) :-
    Promedio >= 8.0, !.
clasificar_promedio(Promedio, regular) :-
    Promedio >= 6.0, !.
clasificar_promedio(_, reprobado).

% primer_reprobado/2 — semidet
% primer_reprobado(+Lista, -Alumno)
%
% CUT ROJO: este cut CAMBIA la semántica. Sin él, el predicado
% encontraría todos los reprobados. Con él, solo encuentra el primero.
% Úsalo con cuidado — documenta siempre que sea un cut rojo.
primer_reprobado([H|_], H) :-
    alumno(H, _, Promedio, _, _),
    Promedio < 6.0,
    !.   % cut rojo: descarta el resto de la lista
primer_reprobado([_|T], Alumno) :-
    primer_reprobado(T, Alumno).

% ============================================================
% NEGACIÓN COMO FALLA (\+)
%
% IMPORTANTE: \+ Goal es verdadero cuando Goal NO tiene prueba.
% Esto es "negación como falla" (NAF), NO negación lógica clásica.
%
% Semántica del mundo cerrado: si no podemos probar que X es alumno,
% asumimos que NO es alumno. Esto es correcto solo si la base de
% conocimiento es completa para ese dominio.
% ============================================================

% sin_adeudo/1 — semidet
% sin_adeudo(+Matricula)
% Verdadero cuando NO existe prueba de adeudo para el alumno.
sin_adeudo(Matricula) :-
    alumno(Matricula, _, _, _, no).

% alumno_externo/1 — semidet (usa \+)
% alumno_externo(+Matricula)
% Alumno que existe pero no tiene registro de adeudo explícito.
% ATENCIÓN: \+ no significa "es definitivamente externo",
%           significa "no hay prueba de que tenga adeudo".
alumno_nuevo(Matricula) :-
    alumno(Matricula, _, _, Creditos, _),
    Creditos < 50.

% ============================================================
% AGREGACIÓN con findall/3
% ============================================================

% todos_elegibles/1 — det
% todos_elegibles(-Lista)
% Retorna lista de IDs de todos los alumnos elegibles para beca.
todos_elegibles(Lista) :-
    findall(M, elegible_beca(M), Lista).

% alumnos_en_riesgo/1 — det
% alumnos_en_riesgo(-Lista)
% Retorna lista de IDs de alumnos en riesgo académico.
alumnos_en_riesgo(Lista) :-
    findall(M, en_riesgo(M), Lista).

% becas_por_tipo/2 — det
% becas_por_tipo(-Excelencia, -General)
% Separa en dos listas: becas de excelencia y becas generales no-excelencia.
becas_por_tipo(Excelencia, General) :-
    findall(M, beca_excelencia(M), Excelencia),
    findall(M, (elegible_beca(M), \+ beca_excelencia(M)), General).

% reporte_alumno/1 — det
% reporte_alumno(+Matricula)
% Imprime un reporte completo del alumno en consola.
reporte_alumno(Matricula) :-
    alumno(Matricula, Nombre, Promedio, Creditos, Adeudo),
    clasificar_promedio(Promedio, Cat),
    format("=== Reporte: ~w ===~n", [Nombre]),
    format("Matrícula : ~w~n", [Matricula]),
    format("Promedio  : ~2f (~w)~n", [Promedio, Cat]),
    format("Créditos  : ~w~n", [Creditos]),
    format("Adeudo    : ~w~n", [Adeudo]),
    (elegible_beca(Matricula) ->
        (beca_excelencia(Matricula) ->
            format("Beca      : EXCELENCIA~n")
        ;   format("Beca      : GENERAL~n"))
    ;   format("Beca      : NO ELEGIBLE~n"),
        findall(R, no_elegible_razon(Matricula, R), Razones),
        format("Razones   : ~w~n", [Razones])),
    (puede_titularse(Matricula) ->
        format("Titulación: PUEDE TITULARSE~n")
    ;   format("Titulación: PENDIENTE~n")).

% ============================================================
% CONSULTAS DE EJEMPLO
% ============================================================
%
% ?- todos_elegibles(L).
% % L = [c21010001, c21010005, c21010007, c21010009]
%
% ?- alumnos_en_riesgo(L).
% % L = [c21010004, c21010006, c21010008]
%
% ?- becas_por_tipo(Exc, Gen).
% % Exc = [c21010001, c21010005]
% % Gen = [c21010007, c21010009]
%
% ?- no_elegible_razon(c21010003, R).
% % R = adeudo_biblioteca
%
% ?- no_elegible_razon(c21010004, R).
% % R = promedio_insuficiente ; R = creditos_insuficientes
%
% ?- clasificar_promedio(8.5, C).
% % C = bueno
%
% ?- reporte_alumno(c21010001).
% % (imprime reporte completo)
%
% ?- puede_titularse(M), alumno(M, Nombre, _, _, _).
% % M = c21010001, Nombre = 'García Ramírez Ana'
% % M = c21010005, Nombre = 'Rios Vega Paola'
% % M = c21010009, Nombre = 'Castillo Mora Fernanda'

% ============================================================
% TESTS
% ============================================================

:- begin_tests(becas).

test(garcia_excelencia) :-
    beca_excelencia(c21010001).

test(rios_excelencia) :-
    beca_excelencia(c21010005).

test(martinez_no_elegible_por_adeudo) :-
    \+ elegible_beca(c21010003),
    no_elegible_razon(c21010003, adeudo_biblioteca).

test(hernandez_en_riesgo) :-
    en_riesgo(c21010004).

test(mendoza_en_riesgo_por_creditos) :-
    en_riesgo(c21010008).

test(total_elegibles) :-
    todos_elegibles(L),
    length(L, N),
    N =:= 4.

test(castillo_puede_titularse) :-
    puede_titularse(c21010009).

test(hernandez_no_puede_titularse) :-
    \+ puede_titularse(c21010004).

test(clasificacion_excelente) :-
    clasificar_promedio(9.5, excelente).

test(clasificacion_reprobado) :-
    clasificar_promedio(5.0, reprobado).

:- end_tests(becas).
