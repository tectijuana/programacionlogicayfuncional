%% =====================================================================
%% Programa:    tramite_server.erl
%% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Proyecto Final P1 — Trámites IMSS, capa 2
%% Fecha:       2026-07-18
%% Descripción: GenServer: cola de trámites pendientes
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(tramite_server).
-behaviour(gen_server).

-export([start_link/0, solicitar/2, historial/0, pendientes/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-record(tramite, {
    id        :: pos_integer(),
    nss       :: binary(),
    tipo      :: atom(),
    timestamp :: integer(),
    resultado :: atom()
}).

-record(estado, {
    siguiente_id :: pos_integer(),
    historial    :: [#tramite{}]
}).

%% ── API pública ───────────────────────────────────────────────

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% solicitar/2 — solicitar(NSS, TipoTramite) -> {ok, Id} | {error, Razon}
solicitar(NSS, Tipo) ->
    gen_server:call(?MODULE, {solicitar, NSS, Tipo}).

historial() ->
    gen_server:call(?MODULE, historial).

pendientes() ->
    gen_server:call(?MODULE, pendientes).

%% ── Callbacks OTP ────────────────────────────────────────────

init([]) ->
    Estado = #estado{siguiente_id = 1, historial = []},
    {ok, Estado}.

handle_call({solicitar, NSS, Tipo}, _From,
            S = #estado{siguiente_id = Id, historial = H}) ->
    Resultado = validar_tramite(NSS, Tipo),
    Entrada   = #tramite{
        id        = Id,
        nss       = NSS,
        tipo      = Tipo,
        timestamp = erlang:system_time(second),
        resultado = Resultado
    },
    NuevoEstado = S#estado{
        siguiente_id = Id + 1,
        historial    = [Entrada | H]
    },
    {reply, {ok, Id, Resultado}, NuevoEstado};

handle_call(historial, _From, S = #estado{historial = H}) ->
    {reply, lists:reverse(H), S};

handle_call(pendientes, _From, S = #estado{historial = H}) ->
    Pendientes = [T || T = #tramite{resultado = pendiente} <- H],
    {reply, Pendientes, S};

handle_call(_Req, _From, S) ->
    {reply, {error, desconocido}, S}.

handle_cast(_Msg, S) ->
    {noreply, S}.

terminate(_Razon, _S) ->
    ok.

%% ── Lógica interna ───────────────────────────────────────────

%% validar_tramite/2 — stub para extensión con Prolog en crédito extra
%% En implementación completa llamaría a SWI-Prolog vía puerto
validar_tramite(_NSS, atencion_medica) -> aprobado;
validar_tramite(_NSS, _Tipo)           -> pendiente.
