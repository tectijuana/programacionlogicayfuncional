-module(sensor_server).
-behaviour(gen_server).

-export([start_link/1, leer/1, ultima_lectura/1, historial/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

-define(INTERVALO_MS, 2000).

-record(estado, {
    tipo       :: atom(),
    ultima     :: number() | undefined,
    historial  :: [number()]
}).

%% ── API pública ───────────────────────────────────────────────

start_link(TipoSensor) ->
    gen_server:start_link(?MODULE, TipoSensor, []).

leer(Pid) ->
    gen_server:call(Pid, leer).

ultima_lectura(Pid) ->
    gen_server:call(Pid, ultima_lectura).

historial(Pid) ->
    gen_server:call(Pid, historial).

%% ── Callbacks OTP ────────────────────────────────────────────

init(TipoSensor) ->
    erlang:send_after(?INTERVALO_MS, self(), tomar_lectura),
    {ok, #estado{tipo = TipoSensor, ultima = undefined, historial = []}}.

handle_call(leer, _From, S = #estado{tipo = Tipo}) ->
    Lectura = simular_lectura(Tipo),
    NuevoEstado = registrar(Lectura, S),
    {reply, {ok, Tipo, Lectura}, NuevoEstado};

handle_call(ultima_lectura, _From, S = #estado{ultima = U}) ->
    {reply, U, S};

handle_call(historial, _From, S = #estado{historial = H}) ->
    {reply, lists:reverse(H), S};

handle_call(_Req, _From, S) ->
    {reply, {error, desconocido}, S}.

handle_cast(_Msg, S) ->
    {noreply, S}.

handle_info(tomar_lectura, S = #estado{tipo = Tipo}) ->
    Lectura = simular_lectura(Tipo),
    NuevoEstado = registrar(Lectura, S),
    erlang:send_after(?INTERVALO_MS, self(), tomar_lectura),
    {noreply, NuevoEstado};

handle_info(_Msg, S) ->
    {noreply, S}.

terminate(_Razon, _S) ->
    ok.

%% ── Lógica interna ───────────────────────────────────────────

registrar(Lectura, S = #estado{historial = H}) ->
    S#estado{ultima = Lectura, historial = [Lectura | H]}.

%% simular_lectura/1 — genera valores aleatorios realistas por tipo de sensor
simular_lectura(sismico)     -> rand:uniform(80);
simular_lectura(temperatura) -> 20 + rand:uniform(25);
simular_lectura(humedad)     -> 5  + rand:uniform(80);
simular_lectura(co2)         -> 300 + rand:uniform(2000);
simular_lectura(presion)     -> 900 + rand:uniform(130).
