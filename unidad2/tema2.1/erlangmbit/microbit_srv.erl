-module(microbit_srv).
-behaviour(gen_server).
-export([start_link/1, mostrar/1, stats/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

-define(UMBRAL_MG, 1800).  %% en reposo la magnitud es ~1024 mg (1 g)

%% Dev = "/dev/cu.usbmodem1102" (macOS) | "/dev/ttyACM0" (Linux)
%% {cmd, Cmd} permite simular el micro:bit sin hardware.
start_link(Fuente) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Fuente, []).

mostrar(Texto) -> gen_server:cast(?MODULE, {mostrar, Texto}).
stats()        -> gen_server:call(?MODULE, stats).

init({cmd, Cmd}) ->
    Port = open_port({spawn_executable, "/bin/sh"},
                     [{args, ["-c", Cmd]}, {line, 256}, binary, exit_status]),
    {ok, #{port => Port, lecturas => 0, alertas => 0}};
init(Dev) ->
    %% stdin del port -> micro:bit (segundo plano); micro:bit -> stdout del port.
    %% Si se desconecta el cable, el `cat` de lectura termina y llega exit_status.
    init({cmd, "stty " ++ flag_stty() ++ " " ++ Dev ++ " 115200 raw -echo"
               " && exec 3<&0"
               " && { cat <&3 > " ++ Dev ++ " & exec cat " ++ Dev ++ "; }"}).

flag_stty() ->
    case os:type() of {unix, darwin} -> "-f"; _ -> "-F" end.

handle_call(stats, _From, S) ->
    {reply, maps:remove(port, S), S}.

%% Enviar texto al micro:bit: lo muestra en la matriz de LEDs.
handle_cast({mostrar, Texto}, S = #{port := Port}) ->
    port_command(Port, [Texto, $\n]),
    {noreply, S}.

handle_info({Port, {data, {eol, Linea}}}, S = #{port := Port}) ->
    {noreply, procesar(parsear(Linea), S)};
handle_info({Port, {data, {noeol, _}}}, S = #{port := Port}) ->
    {noreply, S};
handle_info({Port, {exit_status, Codigo}}, S = #{port := Port}) ->
    %% Cable desconectado o cat terminó: let it crash, el supervisor reintenta.
    {stop, {serial_cerrado, Codigo}, S}.

%% Línea esperada: <<"x,y,z,temp\r">> (print() de MicroPython termina en \r\n)
parsear(Linea) ->
    Campos = binary:split(string:trim(Linea), <<",">>, [global, trim_all]),
    try [binary_to_integer(C) || C <- Campos] of
        [X, Y, Z, T] -> {ok, X, Y, Z, T};
        _            -> descartar
    catch error:badarg -> descartar
    end.

procesar(descartar, S) -> S;
procesar({ok, X, Y, Z, T}, S = #{lecturas := N, alertas := A}) ->
    Mag = round(math:sqrt(X*X + Y*Y + Z*Z)),
    case Mag > ?UMBRAL_MG of
        true ->
            io:format("ALERTA sismo: ~p mg (~p C)~n", [Mag, T]),
            S#{lecturas := N + 1, alertas := A + 1};
        false ->
            S#{lecturas := N + 1}
    end.
