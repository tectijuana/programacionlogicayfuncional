:- module(reglas_alerta, [
    clasificar/3,
    generar_alerta/3,
    nivel_maximo/2
]).
:- use_module(umbrales).

%% ============================================================
%% CLASIFICACIÓN DE LECTURAS
%% clasificar/3 — clasificar(+Sensor, +Lectura, -Nivel) is det
%% Nivel = normal | alerta | critico
%% ============================================================

clasificar(Sensor, Lectura, critico) :-
    umbral_critico(Sensor, Min, Max),
    Lectura >= Min, Lectura =< Max, !.

clasificar(Sensor, Lectura, normal) :-
    umbral_alerta(Sensor, Min, Max),
    Lectura >= Min, Lectura =< Max, !.

clasificar(_, _, alerta).

%% ============================================================
%% GENERACIÓN DE ALERTAS
%% generar_alerta/3 — generar_alerta(+Sensor, +Lectura, -Mensaje) is semidet
%% Solo genera mensajes si el nivel no es normal
%% ============================================================

generar_alerta(Sensor, Lectura, Mensaje) :-
    clasificar(Sensor, Lectura, Nivel),
    Nivel \= normal,
    format(atom(Mensaje),
           "[~w] SENSOR ~w lectura ~w — nivel ~w",
           [alerta, Sensor, Lectura, Nivel]).

%% ============================================================
%% NIVEL MÁXIMO DE UN CONJUNTO DE LECTURAS
%% nivel_maximo/2 — nivel_maximo(+Lecturas, -NivelMax) is det
%% Lecturas = lista de pares sensor(Tipo, Valor)
%% ============================================================

nivel_maximo(Lecturas, NivelMax) :-
    maplist(clasificar_par, Lecturas, Niveles),
    reducir_nivel(Niveles, NivelMax).

clasificar_par(sensor(Tipo, Valor), Nivel) :-
    clasificar(Tipo, Valor, Nivel).

reducir_nivel(Niveles, critico) :- member(critico, Niveles), !.
reducir_nivel(Niveles, alerta)  :- member(alerta, Niveles), !.
reducir_nivel(_, normal).
