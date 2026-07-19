%% =====================================================================
%% Programa:    inmutabilidad.erl
%% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tema 2.1 — Fundamentos FP
%% Fecha:       2026-07-18
%% Descripción: Inmutabilidad y transparencia referencial en Erlang
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(inmutabilidad).
-export([demostrar_inmutabilidad/0, suma_lista/1, suma_lista/2,
         sin_race_condition/0]).

%% En Erlang, las variables son de asignación única.
%% Una vez ligada, una variable NO puede cambiar de valor.
%% Esto elimina por diseño las condiciones de carrera (race conditions).

%% demostrar_inmutabilidad/0
%% Muestra en consola los principios de inmutabilidad.
demostrar_inmutabilidad() ->
    X = 42,
    io:format("X = ~p~n", [X]),

    %% La siguiente línea causaría error de compilación si se descomentara:
    %% X = 99,  %% ERROR: variable X ya está ligada a 42

    %% Pero sí podemos crear una nueva variable
    Y = X + 8,
    io:format("Y = X + 8 = ~p~n", [Y]),

    %% Las listas tampoco mutan — operaciones crean listas nuevas
    Lista1 = [1, 2, 3],
    Lista2 = [0 | Lista1],   %% nueva lista, Lista1 intacta
    io:format("Lista1 = ~p (sin cambios)~n", [Lista1]),
    io:format("Lista2 = ~p (nueva lista)~n", [Lista2]),

    io:format("~n--- ¿Por qué esto elimina race conditions? ---~n"),
    io:format("Si nadie puede cambiar X, dos procesos leyendo X~n"),
    io:format("simultáneamente siempre ven el mismo valor.~n"),
    io:format("No hay estado compartido mutable = no hay carreras.~n").

%% suma_lista/1 — interfaz pública
%% suma_lista(+Lista) -> integer()
%% Suma todos los elementos de una lista de enteros.
%% Usa recursión de cola para evitar desbordamiento de pila.
suma_lista(Lista) ->
    suma_lista(Lista, 0).

%% suma_lista/2 — implementación con acumulador (recursión de cola)
%% suma_lista(+Lista, +Acumulador) -> integer()
suma_lista([], Acc) ->
    Acc;
suma_lista([H | T], Acc) ->
    suma_lista(T, Acc + H).

%% sin_race_condition/0
%% Demuestra que múltiples procesos pueden leer datos sin coordinación.
%% En lenguajes imperativos esto requeriría locks o mutexes.
sin_race_condition() ->
    Datos = lists:seq(1, 1000),
    Padre = self(),

    %% Lanzar 10 procesos que suman la misma lista simultáneamente
    Pids = [spawn(fun() ->
                      Resultado = suma_lista(Datos),
                      Padre ! {self(), Resultado}
                  end) || _ <- lists:seq(1, 10)],

    %% Recolectar resultados
    Resultados = [receive {Pid, R} -> R end || Pid <- Pids],

    %% Todos deben ser idénticos — sin race conditions
    case lists:usort(Resultados) of
        [500500] ->
            io:format("✓ Los 10 procesos obtuvieron el mismo resultado: 500500~n"),
            io:format("✓ Cero locks, cero mutexes, cero race conditions.~n");
        Varios ->
            io:format("✗ Resultados distintos (no debería ocurrir): ~p~n", [Varios])
    end.
