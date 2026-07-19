% =====================================================================
% Programa:    movies.pl
% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Tema 3.3 — Unificación y resolución
% Fecha:       2026-07-18
% Descripción: Base de conocimiento de películas: unificación y consultas (15 tests plunit)
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
%% Archivo: movies.pl
%% Tema 3.3 — Unificación y resolución
%% Tarea 3.3: trazar manualmente el árbol de resolución SLD para 5 consultas
%% distintas sobre esta base de datos de cine mexicano.
%%
%% Cargar:      swipl movies.pl
%% Correr tests: ?- run_tests.
%%
%% La tarea pide identificar en tus trazas:
%%   a) puntos de backtracking      → colaboro_con/2, companeros/2
%%   b) cuts útiles (verde vs rojo) → epoca/2
%%   c) consultas que NO terminan   → conectado/2 (leer advertencia abajo)

%% ============================================================
%% HECHOS — cine mexicano
%% ============================================================

%% dirigio/2 — dirigio(?Director, ?Pelicula) is nondet
dirigio(emilio_fernandez,   maria_candelaria).
dirigio(ismael_rodriguez,   nosotros_los_pobres).
dirigio(alfonso_cuaron,     y_tu_mama_tambien).
dirigio(alfonso_cuaron,     roma).
dirigio(alejandro_inarritu, amores_perros).
dirigio(alejandro_inarritu, birdman).
dirigio(guillermo_del_toro, el_laberinto_del_fauno).
dirigio(guillermo_del_toro, la_forma_del_agua).

%% estreno/2 — estreno(?Pelicula, ?Anio) is nondet
estreno(maria_candelaria,       1944).
estreno(nosotros_los_pobres,    1948).
estreno(amores_perros,          2000).
estreno(y_tu_mama_tambien,      2001).
estreno(el_laberinto_del_fauno, 2006).
estreno(birdman,                2014).
estreno(la_forma_del_agua,      2017).
estreno(roma,                   2018).

%% actua/2 — actua(?Actor, ?Pelicula) is nondet
actua(dolores_del_rio,  maria_candelaria).
actua(pedro_armendariz, maria_candelaria).
actua(pedro_infante,    nosotros_los_pobres).
actua(gael_garcia,      amores_perros).
actua(vanessa_bauche,   amores_perros).
actua(gael_garcia,      y_tu_mama_tambien).
actua(diego_luna,       y_tu_mama_tambien).
actua(maribel_verdu,    y_tu_mama_tambien).
actua(ivana_baquero,    el_laberinto_del_fauno).
actua(doug_jones,       el_laberinto_del_fauno).
actua(michael_keaton,   birdman).
actua(doug_jones,       la_forma_del_agua).
actua(sally_hawkins,    la_forma_del_agua).
actua(yalitza_aparicio, roma).
actua(marina_de_tavira, roma).

%% genero/2 — genero(?Pelicula, ?Genero) is nondet
genero(maria_candelaria,       drama).
genero(nosotros_los_pobres,    drama).
genero(amores_perros,          drama).
genero(y_tu_mama_tambien,      drama).
genero(el_laberinto_del_fauno, fantasia).
genero(birdman,                comedia_negra).
genero(la_forma_del_agua,      fantasia).
genero(roma,                   drama).

%% ============================================================
%% REGLAS CON BACKTRACKING — trazar los puntos de elección
%% ============================================================

%% colaboro_con/2 — colaboro_con(?Actor, ?Director) is nondet
%% Un actor colaboró con un director si actuó en una película que él dirigió.
%% TRAZA SUGERIDA: ?- colaboro_con(gael_garcia, D).
%%   actua(gael_garcia, P) tiene DOS soluciones (amores_perros,
%%   y_tu_mama_tambien) → punto de backtracking.
colaboro_con(Actor, Director) :-
    actua(Actor, Pelicula),
    dirigio(Director, Pelicula).

%% companeros/2 — companeros(?A, ?B) is nondet
%% Dos actores distintos que compartieron película.
%% Relación SIMÉTRICA: si companeros(a,b) entonces companeros(b,a) —
%% esto crea los ciclos que hacen no terminar a conectado/2.
companeros(A, B) :-
    actua(A, Pelicula),
    actua(B, Pelicula),
    A \= B.

%% contemporaneas/2 — contemporaneas(?P1, ?P2) is nondet
%% Dos películas distintas estrenadas con 4 años o menos de diferencia.
contemporaneas(P1, P2) :-
    estreno(P1, A1),
    estreno(P2, A2),
    P1 \= P2,
    abs(A1 - A2) =< 4.

%% ============================================================
%% CUT — verde vs. rojo (tarea: clasificar cada uno en tu traza)
%% ============================================================

%% epoca/2 — epoca(+Pelicula, -Epoca) is det
%% Los dos primeros cuts son VERDES: las condiciones son mutuamente
%% excluyentes; el cut solo evita revisar cláusulas que fallarían.
%% Quita los cuts y traza ?- epoca(roma, E). — obtienes la misma
%% respuesta pero con puntos de elección de más.
epoca(Pelicula, epoca_de_oro) :-
    estreno(Pelicula, Anio),
    Anio =< 1960, !.
epoca(Pelicula, nuevo_cine_mexicano) :-
    estreno(Pelicula, Anio),
    Anio >= 2000, !.
epoca(Pelicula, transicion) :-
    estreno(Pelicula, _).

%% primer_exito/2 — primer_exito(+Director, -Pelicula) is semidet
%% CUIDADO: este cut es ROJO — descarta soluciones (solo devuelve la
%% película del director con estreno más antiguo). Sin el cut, el
%% predicado daría más respuestas y su significado cambia.
primer_exito(Director, Pelicula) :-
    dirigio(Director, Pelicula),
    estreno(Pelicula, Anio),
    \+ ( dirigio(Director, Otra),
         estreno(Otra, OtroAnio),
         OtroAnio < Anio ),
    !.

%% ============================================================
%% NO TERMINACIÓN — la consulta que debes trazar SIN ejecutar entera
%% ============================================================

%% conectado/2 — conectado(?A, ?B) is nondet — ¡PUEDE NO TERMINAR!
%% Cierre transitivo de companeros/2 SIN lista de visitados.
%% Como companeros/2 es simétrica (a-b y b-a), el grafo tiene ciclos:
%%   ?- conectado(gael_garcia, pedro_infante).
%% NO termina: recorre gael-diego-gael-diego... infinitamente buscando
%% una prueba que no existe. Traza las primeras ~6 resoluciones y
%% explica por qué DFS (la estrategia de Prolog) cae en el ciclo.
conectado(A, B) :- companeros(A, B).
conectado(A, B) :- companeros(A, C), conectado(C, B).

%% conectado_seguro/2 — conectado_seguro(+A, ?B) is nondet
%% La versión correcta: acumula visitados, como camino/3 del tema 4.2.
%% Compara tu traza de conectado/2 contra esta.
conectado_seguro(A, B) :-
    conectado_seguro(A, B, [A]).

conectado_seguro(A, B, _) :-
    companeros(A, B).
conectado_seguro(A, B, Visitados) :-
    companeros(A, C),
    \+ member(C, Visitados),
    C \= B,
    conectado_seguro(C, B, [C|Visitados]).

%% ============================================================
%% LAS 5 CONSULTAS SUGERIDAS PARA LA TAREA
%% (puedes proponer otras, pero deben cubrir los mismos fenómenos)
%% ============================================================
%% 1. ?- colaboro_con(gael_garcia, D).       % backtracking simple
%% 2. ?- companeros(doug_jones, X).          % backtracking con \=
%% 3. ?- epoca(nosotros_los_pobres, E).      % cut verde
%% 4. ?- primer_exito(guillermo_del_toro, P). % cut rojo + negación
%% 5. ?- conectado(gael_garcia, pedro_infante). % NO termina — explica por qué
%%    (verifica con: ?- conectado_seguro(gael_garcia, pedro_infante). → false)

%% ============================================================
%% TESTS
%% ============================================================

:- use_module(library(plunit)).

:- begin_tests(movies).

test(colaboracion_directa) :-
    colaboro_con(yalitza_aparicio, alfonso_cuaron).

test(colaboraciones_de_gael, set(D == [alejandro_inarritu, alfonso_cuaron])) :-
    colaboro_con(gael_garcia, D).

test(companeros_simetrica) :-
    companeros(gael_garcia, diego_luna),
    companeros(diego_luna, gael_garcia).

test(companeros_no_reflexiva, fail) :-
    companeros(gael_garcia, gael_garcia).

test(doug_jones_conecta_dos_peliculas,
     set(P == [el_laberinto_del_fauno, la_forma_del_agua])) :-
    actua(doug_jones, P).

test(contemporaneas_ida) :-
    contemporaneas(amores_perros, y_tu_mama_tambien).

test(no_contemporaneas, fail) :-
    contemporaneas(maria_candelaria, roma).

test(epoca_de_oro) :-
    epoca(nosotros_los_pobres, epoca_de_oro).

test(epoca_nuevo_cine) :-
    epoca(roma, nuevo_cine_mexicano).

test(epoca_es_determinista) :-
    findall(E, epoca(birdman, E), [_]).

test(primer_exito_del_toro) :-
    primer_exito(guillermo_del_toro, el_laberinto_del_fauno).

test(primer_exito_cuaron) :-
    primer_exito(alfonso_cuaron, y_tu_mama_tambien).

test(conectado_seguro_encuentra, nondet) :-
    conectado_seguro(gael_garcia, maribel_verdu).

test(conectado_seguro_termina_en_falso, fail) :-
    conectado_seguro(gael_garcia, pedro_infante).

test(conectado_seguro_transitivo) :-
    %% gael comparte con doug? No directamente — pero sí vía nadie:
    %% gael y doug NO están conectados (componentes distintas del grafo)
    \+ conectado_seguro(gael_garcia, doug_jones).

:- end_tests(movies).
