-module(derechohabiente).
-behaviour(gen_server).

-export([start_link/1, consultar/1, actualizar_semanas/2, estado/1]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-record(estado, {
    nss           :: binary(),
    nombre        :: atom(),
    semanas       :: non_neg_integer(),
    vigente       :: boolean(),
    tramites      :: [atom()]
}).

%% ── API pública ───────────────────────────────────────────────

start_link(NSS) ->
    gen_server:start_link(?MODULE, NSS, []).

consultar(Pid) ->
    gen_server:call(Pid, consultar).

actualizar_semanas(Pid, NuevasSemanas) ->
    gen_server:call(Pid, {actualizar_semanas, NuevasSemanas}).

estado(Pid) ->
    gen_server:call(Pid, estado).

%% ── Callbacks OTP ────────────────────────────────────────────

init(NSS) ->
    Estado = #estado{
        nss      = NSS,
        nombre   = desconocido,
        semanas  = 0,
        vigente  = false,
        tramites = []
    },
    {ok, Estado}.

handle_call(consultar, _From, S = #estado{nss = NSS, semanas = Sem, vigente = V}) ->
    Respuesta = #{nss => NSS, semanas => Sem, vigente => V},
    {reply, {ok, Respuesta}, S};

handle_call({actualizar_semanas, Nuevas}, _From, S) when Nuevas >= 0 ->
    {reply, ok, S#estado{semanas = Nuevas}};
handle_call({actualizar_semanas, _}, _From, S) ->
    {reply, {error, semanas_negativas}, S};

handle_call(estado, _From, S) ->
    {reply, S, S};

handle_call(_Req, _From, S) ->
    {reply, {error, desconocido}, S}.

handle_cast(_Msg, S) ->
    {noreply, S}.

terminate(_Razon, _S) ->
    ok.
