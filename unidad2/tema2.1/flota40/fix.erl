%% fix: parseo y validacion PURA de un fix de posicion (sin procesos, sin ETS, sin reloj).
%% Formato en la red (UDP):  ID|seq|lat|lon|kmh|hdop10|sats|estado
%% El micro:bit es una caja negra: aqui se decide, con reglas, cuanto confiar en cada fix.
-module(fix).
-export([parsear/1, evaluar/2]).
-export_type([t/0, previo/0, veredicto/0]).

-define(SALTO_KM, 50).          %% maximo de km por paso de seq; mas es "teletransporte"
-define(MIN_SATS, 4).           %% menos satelites = sin fix (se conserva la ultima posicion buena)
-define(ESTADOS, [rodando, detenido, sos]).

-type t() :: #{id := integer(), seq := integer(), lat := float(), lon := float(),
               kmh := integer(), hdop10 := integer(), sats := integer(), estado := atom()}.
-type previo() :: undefined | #{seq := integer(), lat := float(), lon := float()}.
-type veredicto() :: {ok, Huecos :: non_neg_integer()} | {ok, reinicio} | {ok, sin_fix}
                   | {descartar, fuera_de_rango | seq_viejo | salto}.

-spec parsear(binary()) -> {ok, t()} | error.
parsear(Bin) ->
    try
        [Id, Seq, La, Lo, V, H, N, E] = binary:split(Bin, <<"|">>, [global]),
        Estado = binary_to_existing_atom(E),
        true = lists:member(Estado, ?ESTADOS),
        {ok, #{id => binary_to_integer(Id), seq => binary_to_integer(Seq),
               lat => binary_to_float(La), lon => binary_to_float(Lo),
               kmh => binary_to_integer(V), hdop10 => binary_to_integer(H),
               sats => binary_to_integer(N), estado => Estado}}
    catch _:_ -> error
    end.

%% Evalua un fix contra el ultimo aceptado del mismo semi. Orden de las reglas:
%% rango -> orden/duplicados (seq) -> sin fix -> salto imposible -> ok (con huecos detectados).
-spec evaluar(t(), previo()) -> veredicto().
evaluar(#{lat := La, lon := Lo, kmh := V, hdop10 := H, sats := N}, _)
  when La < -90; La > 90; Lo < -180; Lo > 180; V < 0; V > 250; H < 0; H > 999; N < 0; N > 40 ->
    {descartar, fuera_de_rango};
evaluar(_, undefined) -> {ok, 0};
evaluar(#{seq := S}, #{seq := P}) when S =< 2, S =< P -> {ok, reinicio};   %% tarjeta reiniciada
evaluar(#{seq := S}, #{seq := P}) when S =< P -> {descartar, seq_viejo};
evaluar(#{sats := N}, _) when N < ?MIN_SATS -> {ok, sin_fix};
evaluar(#{seq := S, lat := La, lon := Lo}, #{seq := P, lat := La0, lon := Lo0}) ->
    case km({La0, Lo0}, {La, Lo}) > ?SALTO_KM * (S - P) of
        true  -> {descartar, salto};
        false -> {ok, S - P - 1}
    end.

km({La1, Lo1}, {La2, Lo2}) ->
    R = math:pi() / 180,
    A = math:pow(math:sin((La2 - La1) * R / 2), 2) +
        math:cos(La1 * R) * math:cos(La2 * R) * math:pow(math:sin((Lo2 - Lo1) * R / 2), 2),
    12742 * math:asin(math:sqrt(A)).
