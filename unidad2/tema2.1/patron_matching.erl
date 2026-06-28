-module(patron_matching).
-export([validar_rfc/1, demo/0]).

%% Validador de RFC mexicano usando EXCLUSIVAMENTE pattern matching y guards.
%% Sin if anidados. Sin case con múltiples condiciones mezcladas.
%%
%% Estructura del RFC (13 caracteres):
%%   AAAA   — 4 letras del nombre (posiciones 1-4)
%%   AAMMDD — 6 dígitos de fecha de nacimiento (posiciones 5-10)
%%   HHH    — 3 caracteres alfanuméricos homoclave (posiciones 11-13)

%% validar_rfc/1
%% validar_rfc(+RFC::string()) -> {ok, map()} | {error, atom()}
%% Determinista: siempre retorna exactamente un resultado.
validar_rfc(RFC) when is_list(RFC), length(RFC) =:= 13 ->
    validar_nombre(RFC);
validar_rfc(RFC) when is_list(RFC) ->
    {error, {longitud_invalida, length(RFC)}};
validar_rfc(_) ->
    {error, tipo_invalido}.

%% Validación interna — pipeline de pattern matching
validar_nombre([A, B, C, D | Resto])
    when A >= $A, A =< $Z,
         B >= $A, B =< $Z,
         C >= $A, C =< $Z,
         D >= $A, D =< $Z ->
    validar_fecha(Resto, [A, B, C, D]);
validar_nombre(_) ->
    {error, nombre_invalido}.

validar_fecha([Y1, Y2, M1, M2, D1, D2 | Homoclave], Nombre)
    when Y1 >= $0, Y1 =< $9,
         Y2 >= $0, Y2 =< $9,
         M1 >= $0, M1 =< $9,
         M2 >= $0, M2 =< $9,
         D1 >= $0, D1 =< $9,
         D2 >= $0, D2 =< $9 ->
    Año  = list_to_integer([Y1, Y2]),
    Mes  = list_to_integer([M1, M2]),
    Día  = list_to_integer([D1, D2]),
    validar_mes(Mes, Día, Año, Nombre, Homoclave);
validar_fecha(_, _) ->
    {error, fecha_invalida}.

validar_mes(Mes, _, _, _, _)
    when Mes < 1; Mes > 12 ->
    {error, {mes_fuera_de_rango, Mes}};
validar_mes(_, Día, _, _, _)
    when Día < 1; Día > 31 ->
    {error, {dia_fuera_de_rango, Día}};
validar_mes(Mes, Día, Año, Nombre, Homoclave) ->
    validar_homoclave(Homoclave, Nombre, Año, Mes, Día).

validar_homoclave([H1, H2, H3], Nombre, Año, Mes, Día)
    when (H1 >= $A andalso H1 =< $Z) orelse (H1 >= $0 andalso H1 =< $9),
         (H2 >= $A andalso H2 =< $Z) orelse (H2 >= $0 andalso H2 =< $9),
         (H3 >= $0 andalso H3 =< $9) ->
    {ok, #{
        nombre    => list_to_atom(Nombre),
        año       => Año,
        mes       => Mes,
        dia       => Día,
        homoclave => [H1, H2, H3]
    }};
validar_homoclave(_, _, _, _, _) ->
    {error, homoclave_invalida}.

%% demo/0 — casos de prueba
demo() ->
    Casos = [
        {"GARS850101A12", "RFC válido"},
        {"LOPM920615B34", "RFC válido"},
        {"RAMT001231C56", "RFC válido"},
        {"GARS85A101A12", "fecha inválida (letra en año)"},
        {"gars850101a12", "nombre en minúsculas"},
        {"GARS8501",      "demasiado corto"},
        {"GARS850113A12", "mes 13 inválido"}
    ],
    io:format("~n=== Validador de RFC mexicano ===~n~n"),
    lists:foreach(
        fun({RFC, Desc}) ->
            Resultado = validar_rfc(RFC),
            io:format("RFC: ~s (~s)~n  → ~p~n~n", [RFC, Desc, Resultado])
        end,
        Casos
    ).
