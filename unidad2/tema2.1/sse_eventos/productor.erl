%% productor: genera eventos de prueba cada 1-3 s. En la vida real seria la central de flota40.
-module(productor).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) -> siguiente(), {ok, []}.
handle_call(_, _, S) -> {reply, ok, S}.
handle_cast(_, S) -> {noreply, S}.

handle_info(emitir, S) ->
    {Tipo, Texto} = lists:nth(rand:uniform(4),
        [{ok, "lectura normal"}, {ok, "ruta en curso"}, {alerta, "temperatura alta"}, {sos, "boton B"}]),
    sse_hub:publicar(Tipo, [Texto, " (semi ", integer_to_list(rand:uniform(40)), ")"]),
    siguiente(),
    {noreply, S}.

siguiente() -> erlang:send_after(1000 + rand:uniform(2000), self(), emitir).
