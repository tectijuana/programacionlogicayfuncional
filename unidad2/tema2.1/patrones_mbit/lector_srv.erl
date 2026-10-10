%% lector_srv: el "servidor". Un proceso registrado (gen_server) que lee el micro:bit,
%% usa lector:leer/1 (puro) y guarda el ultimo valor de cada tipo + contadores.
%% Se puede consultar desde la shell, desde el observer o desde OTRO nodo.
-module(lector_srv).
-behaviour(gen_server).
-export([start_link/1, ultimo/0, contadores/0, mostrar/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

%% Fuente = "/dev/cu.usbmodemXXXX" (macOS) | "/dev/ttyACM0" (Linux) | {cmd, Comando} (sin hardware)
start_link(Fuente) -> gen_server:start_link({local, ?MODULE}, ?MODULE, Fuente, []).

ultimo()      -> gen_server:call(?MODULE, ultimo).
contadores()  -> gen_server:call(?MODULE, contadores).
mostrar(Txt)  -> gen_server:cast(?MODULE, {mostrar, Txt}).

init({cmd, Cmd}) ->
    Port = open_port({spawn_executable, "/bin/sh"},
                     [{args, ["-c", Cmd]}, {line, 256}, binary, exit_status]),
    {ok, #{port => Port, ultimo => #{}, n => #{}}};
init(Dev) ->
    case file:read_file_info(Dev) of
        {ok, _} ->
            init({cmd, "stty " ++ flag_stty() ++ " " ++ Dev ++ " 115200 raw -echo"
                       " && exec 3<&0"
                       " && { cat <&3 > " ++ Dev ++ " & exec cat " ++ Dev ++ "; }"});
        {error, _} -> {stop, {sin_dispositivo, Dev}}
    end.

flag_stty() -> case os:type() of {unix, darwin} -> "-f"; _ -> "-F" end.

handle_call(ultimo, _, S = #{ultimo := U})     -> {reply, U, S};
handle_call(contadores, _, S = #{n := N})      -> {reply, N, S}.

handle_cast({mostrar, Txt}, S = #{port := Port}) ->
    port_command(Port, [Txt, $\n]),
    {noreply, S}.

handle_info({Port, {data, {eol, Linea}}}, S = #{port := Port}) ->
    {noreply, registrar(lector:leer(Linea), S)};
handle_info({Port, {data, {noeol, _}}}, S = #{port := Port}) ->
    {noreply, S};
handle_info({Port, {exit_status, Codigo}}, S = #{port := Port}) ->
    {stop, {serial_cerrado, Codigo}, S}.

registrar(Ev, S = #{ultimo := U, n := N}) ->
    Tipo = tipo(Ev),
    case lector:clasificar(Ev) of
        alerta -> io:format("ALERTA ~p~n", [Ev]);
        _ -> ok
    end,
    case Ev of
        {boton, B} -> io:format("boton ~p~n", [B]);
        _ -> ok
    end,
    S#{ultimo := U#{Tipo => Ev}, n := N#{Tipo => maps:get(Tipo, N, 0) + 1}}.

tipo(basura) -> basura;
tipo(Ev) -> element(1, Ev).
