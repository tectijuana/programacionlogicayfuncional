%% sse_hub: el "bus de eventos". Cualquier proceso llama publicar/2; el hub numera el evento,
%% lo guarda en un buffer circular (para reconexiones) y lo EMPUJA a todos los clientes
%% suscritos al grupo `pg` (un proceso sse_conn por navegador).
-module(sse_hub).
-behaviour(gen_server).
-export([start_link/0, publicar/2, desde/1, ultimos/1]).
-export([init/1, handle_call/3, handle_cast/2]).

-define(GRUPO, sse).
-define(MAX, 50).

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% Tipo = atom (ok | alerta | sos ...), Texto = iodata. Devuelve el Id asignado.
-spec publicar(atom(), iodata()) -> pos_integer().
publicar(Tipo, Texto) -> gen_server:call(?MODULE, {publicar, Tipo, Texto}).

%% Eventos con Id > LastId (para Last-Event-ID al reconectar), del mas viejo al mas nuevo.
desde(LastId) -> gen_server:call(?MODULE, {desde, LastId}).
ultimos(N)    -> gen_server:call(?MODULE, {ultimos, N}).

init([]) -> {ok, #{id => 0, buf => []}}.          %% buf: mas nuevo primero

handle_call({publicar, Tipo, Texto}, _, S = #{id := N, buf := Buf}) ->
    Id = N + 1,
    Json = iolist_to_binary(json:encode(#{id => Id, t => erlang:system_time(millisecond),
                                          tipo => Tipo, texto => iolist_to_binary(Texto)})),
    Ev = {Id, Tipo, Json},
    [Pid ! {sse, Ev} || Pid <- pg:get_members(?GRUPO)],      %% push: nadie pregunta
    {reply, Id, S#{id := Id, buf := lists:sublist([Ev | Buf], ?MAX)}};
handle_call({desde, Ultimo}, _, S = #{buf := Buf}) ->
    {reply, [E || E = {Id, _, _} <- lists:reverse(Buf), Id > Ultimo], S};
handle_call({ultimos, N}, _, S = #{buf := Buf}) ->
    {reply, lists:reverse(lists:sublist(Buf, N)), S}.

handle_cast(_, S) -> {noreply, S}.
