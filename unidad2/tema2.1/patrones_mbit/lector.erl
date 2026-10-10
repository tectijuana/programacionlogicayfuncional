%% lector: NUCLEO PURO. Convierte una linea de texto del micro:bit en un termino Erlang
%% usando SOLO pattern matching sobre binarios (sin if/case de comparacion de cadenas).
%%   leer/1      linea cruda   -> evento()
%%   clasificar/1 evento()     -> alerta | normal | ignorar
-module(lector).
-export([leer/1, clasificar/1]).
-export_type([evento/0]).

-type evento() :: {temp, integer()}
                | {boton, a | b | ab}
                | {acc, integer(), integer(), integer()}
                | basura.

-define(UMBRAL_MG, 1800).      %% en reposo la magnitud es ~1024 mg (1 g)

-spec leer(binary()) -> evento().
leer(Linea) -> parsear(quitar_fin_de_linea(Linea)).

%% OJO: string:trim/1 revienta (badarg) con bytes que no son UTF-8 valido, y un micro:bit
%% recien conectado a veces manda ruido. Por eso se quitan \r\n a nivel de bytes.
quitar_fin_de_linea(Bin) -> binary:replace(Bin, [<<"\r">>, <<"\n">>], <<>>, [global]).

%% Cada clausula es UN formato. El orden importa: la primera que encaja gana.
parsear(<<"T:", N/binary>>) ->
    case entero(N) of {ok, T} -> {temp, T}; error -> basura end;
parsear(<<"B:A">>)  -> {boton, a};
parsear(<<"B:B">>)  -> {boton, b};
parsear(<<"B:AB">>) -> {boton, ab};
parsear(<<"A:", R/binary>>) ->
    case binary:split(R, <<",">>, [global]) of
        [X, Y, Z] ->
            case {entero(X), entero(Y), entero(Z)} of
                {{ok, Xi}, {ok, Yi}, {ok, Zi}} -> {acc, Xi, Yi, Zi};
                _ -> basura
            end;
        _ -> basura
    end;
parsear(_) -> basura.

entero(Bin) ->
    try {ok, binary_to_integer(Bin)}
    catch error:badarg -> error
    end.

%% Guardas: la condicion numerica vive en la clausula, no dentro de un if.
-spec clasificar(evento()) -> alerta | normal | ignorar.
clasificar({temp, T}) when T >= 40 -> alerta;
clasificar({temp, _})              -> normal;
clasificar({acc, X, Y, Z}) when X*X + Y*Y + Z*Z > ?UMBRAL_MG * ?UMBRAL_MG -> alerta;
clasificar({acc, _, _, _})         -> normal;
clasificar({boton, _})             -> normal;
clasificar(basura)                 -> ignorar.
