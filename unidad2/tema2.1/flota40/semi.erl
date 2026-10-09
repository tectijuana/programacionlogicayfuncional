%% semi: un tracto-camion (semi) = un proceso Erlang. SHELL imperativo delgado:
%% aporta reloj (send_after), azar (rand) y UDP; la logica vive en semi_modelo (nucleo puro).
%% En la practica real seria una PC + micro:bit; aqui el micro:bit se simula
%% (GPS ficticio + 3 botones: A, B y el logo tactil de la V2).
-module(semi).
-behaviour(gen_server).
-export([start_link/1, boton/2, nombre/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

-define(TICK, 1000).            %% ms entre reportes GPS
-define(PUERTO, 5000).          %% UDP hacia central (visible en Wireshark)

-record(s, {id, m, sock, seq = 0}).      %% m = semi_modelo:t() (nucleo puro)

%% Ciudades: {Nombre, Lat, Lon}
ciudades() ->
    [{cdmx, 19.43, -99.13}, {tijuana, 32.51, -117.04}, {monterrey, 25.67, -100.31},
     {guadalajara, 20.66, -103.35}, {merida, 20.97, -89.62}, {veracruz, 19.17, -96.13},
     {chihuahua, 28.63, -106.07}, {oaxaca, 17.07, -96.72}, {tapachula, 14.91, -92.26},
     {culiacan, 24.80, -107.39}].

start_link(Id) -> gen_server:start_link({local, nombre(Id)}, ?MODULE, Id, []).

nombre(Id) -> list_to_atom("semi_" ++ integer_to_list(Id)).

%% Boton: a = parada/reanudar, b = SOS, logo = dar la vuelta (retorno)
boton(Id, B) when B =:= a; B =:= b; B =:= logo ->
    gen_server:cast(nombre(Id), {boton, B}).

init(Id) ->
    Cs = ciudades(),
    N = length(Cs),
    {_, La1, Lo1} = lists:nth(Id rem N + 1, Cs),
    {_, La2, Lo2} = lists:nth((Id + 3) rem N + 1, Cs),
    {ok, Sock} = gen_udp:open(0, [binary, {active, true}]),
    erlang:send_after(rand:uniform(?TICK), self(), tick),
    M = semi_modelo:nuevo({La1, Lo1}, {La2, Lo2}, rand:uniform() * 0.5),
    {ok, #s{id = Id, m = M, sock = Sock}}.

handle_call(_, _, S) -> {reply, ok, S}.

handle_cast({boton, B}, S = #s{m = M}) -> {noreply, S#s{m = semi_modelo:boton(B, M)}};
handle_cast(_, S) -> {noreply, S}.

handle_info(tick, S = #s{id = Id, m = M0, seq = Seq}) ->
    M = semi_modelo:paso(0.004 + rand:uniform() * 0.002, M0),
    {La, Lo} = semi_modelo:posicion(M),
    Vel = semi_modelo:velocidad(M, rand:uniform(30) - 1),
    Msg = io_lib:format("~b|~b|~.5f|~.5f|~b|12|9|~s", [Id, Seq, La, Lo, Vel, semi_modelo:estado(M)]),
    gen_udp:send(S#s.sock, flota_cfg:host(), ?PUERTO, iolist_to_binary(Msg)),
    erlang:send_after(?TICK, self(), tick),
    {noreply, S#s{m = M, seq = Seq + 1}};
handle_info({udp, _, _, _, <<"CMD|", Resto/binary>>}, S = #s{id = Id, sock = Sock, m = M}) ->
    %% Orden de la central: aplicar y acusar recibo (ACK|Id|Seq).
    [Seq, Accion | _] = binary:split(Resto, <<"|">>, [global]),
    gen_udp:send(Sock, flota_cfg:host(), ?PUERTO, iolist_to_binary(io_lib:format("ACK|~b|~s", [Id, Seq]))),
    {noreply, S#s{m = semi_modelo:orden(Accion, M)}};
handle_info(_, S) -> {noreply, S}.
