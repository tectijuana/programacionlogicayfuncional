%% =====================================================================
%% Programa:    inventario_server.erl
%% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Proyecto Final P4 — Inventario SAT, capa 2
%% Fecha:       2026-07-18
%% Descripción: GenServer: stock, movimientos y alertas de mínimo
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
-module(inventario_server).
-behaviour(gen_server).

-export([start_link/0, agregar/3, retirar/2, consultar/1, stock_total/0, movimientos/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

-define(MINIMO_ALERTA, 5).

-record(producto, {
    nombre    :: atom(),
    stock     :: non_neg_integer(),
    precio    :: pos_integer()   %% en MXN
}).

-record(movimiento, {
    tipo      :: entrada | salida,
    producto  :: atom(),
    cantidad  :: pos_integer(),
    timestamp :: integer()
}).

-record(estado, {
    productos   :: #{atom() => #producto{}},
    movimientos :: [#movimiento{}]
}).

%% ── API pública ───────────────────────────────────────────────

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

agregar(Nombre, Cantidad, Precio) when Cantidad > 0 ->
    gen_server:call(?MODULE, {agregar, Nombre, Cantidad, Precio}).

retirar(Nombre, Cantidad) when Cantidad > 0 ->
    gen_server:call(?MODULE, {retirar, Nombre, Cantidad}).

consultar(Nombre) ->
    gen_server:call(?MODULE, {consultar, Nombre}).

stock_total() ->
    gen_server:call(?MODULE, stock_total).

movimientos() ->
    gen_server:call(?MODULE, movimientos).

%% ── Callbacks OTP ────────────────────────────────────────────

init([]) ->
    {ok, #estado{productos = #{}, movimientos = []}}.

handle_call({agregar, Nombre, Cantidad, Precio}, _From,
            S = #estado{productos = P, movimientos = M}) ->
    Nuevo = maps:get(Nombre, P, #producto{nombre = Nombre, stock = 0, precio = Precio}),
    Actualizado = Nuevo#producto{stock = Nuevo#producto.stock + Cantidad},
    Mov = #movimiento{tipo = entrada, producto = Nombre,
                      cantidad = Cantidad, timestamp = erlang:system_time(second)},
    {reply, {ok, Actualizado#producto.stock},
     S#estado{productos = P#{Nombre => Actualizado}, movimientos = [Mov | M]}};

handle_call({retirar, Nombre, Cantidad}, _From,
            S = #estado{productos = P, movimientos = M}) ->
    case maps:find(Nombre, P) of
        error ->
            {reply, {error, producto_no_encontrado}, S};
        {ok, Prod} when Prod#producto.stock < Cantidad ->
            {reply, {error, {stock_insuficiente, Prod#producto.stock}}, S};
        {ok, Prod} ->
            NuevoStock = Prod#producto.stock - Cantidad,
            Actualizado = Prod#producto{stock = NuevoStock},
            Mov = #movimiento{tipo = salida, producto = Nombre,
                              cantidad = Cantidad, timestamp = erlang:system_time(second)},
            Alerta = (NuevoStock =< ?MINIMO_ALERTA),
            Reply = case Alerta of
                true  -> {ok, NuevoStock, {alerta_minimo, Nombre, NuevoStock}};
                false -> {ok, NuevoStock}
            end,
            {reply, Reply,
             S#estado{productos = P#{Nombre => Actualizado}, movimientos = [Mov | M]}}
    end;

handle_call({consultar, Nombre}, _From, S = #estado{productos = P}) ->
    {reply, maps:find(Nombre, P), S};

handle_call(stock_total, _From, S = #estado{productos = P}) ->
    Total = maps:fold(fun(_, #producto{stock = St}, Acc) -> Acc + St end, 0, P),
    {reply, Total, S};

handle_call(movimientos, _From, S = #estado{movimientos = M}) ->
    {reply, lists:reverse(M), S};

handle_call(_Req, _From, S) ->
    {reply, {error, desconocido}, S}.

handle_cast(_Msg, S) ->
    {noreply, S}.

terminate(_Razon, _S) ->
    ok.
