%% semi_serial: puente entre UN micro:bit fisico (USB serial) y la central.
%% Lee "lat,lon,kmh,estado" por el puerto serial y lo reenvia por UDP en el mismo
%% formato que los semis simulados ("ID|lat|lon|kmh|estado"): la central no distingue
%% un semi real de uno simulado.
%% Fuente = "/dev/cu.usbmodemXXXX" (macOS) | "/dev/ttyACM0" (Linux) | "COM3" (Windows) | {cmd, Cmd} (sin hardware)
-module(semi_serial).
-behaviour(gen_server).
-export([start_link/2, mostrar/2, boton/2, nombre/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

-define(PUERTO, 5000).
-define(REINTENTO_MS, 2000).
-define(ESTADOS, [<<"rodando">>, <<"detenido">>, <<"sos">>]).

-record(s, {id, fuente, port, sock, avisado = false}).

start_link(Id, Fuente) ->
    gen_server:start_link({local, nombre(Id)}, ?MODULE, {Id, Fuente}, []).

nombre(Id) -> list_to_atom("semi_serial_" ++ integer_to_list(Id)).

%% Texto que se desplaza en la matriz LED del micro:bit.
mostrar(Id, Texto) -> gen_server:cast(nombre(Id), {mostrar, Texto}).

%% Pulsacion "manual" simulada (solo para el simulador de micro:bit): a | b | logo
boton(Id, B) when B =:= a; B =:= b; B =:= logo ->
    gen_server:cast(nombre(Id), {mostrar, case B of a -> "@A"; b -> "@B"; logo -> "@L" end}).

init({Id, Fuente}) ->
    {ok, Sock} = gen_udp:open(0, [binary, {active, true}]),
    self() ! abrir,                      %% no bloquea el arranque del supervisor
    {ok, #s{id = Id, fuente = Fuente, sock = Sock}}.

handle_call(_, _, S) -> {reply, ok, S}.

handle_cast({mostrar, Texto}, S = #s{port = Port}) when Port =/= undefined ->
    port_command(Port, [Texto, $\n]),
    {noreply, S};
handle_cast(_, S) -> {noreply, S}.

handle_info(abrir, S = #s{fuente = F, avisado = Av}) ->
    case abrir(F) of
        {ok, Port} ->
            io:format("semi ~b: serial abierto (~p)~n", [S#s.id, F]),
            {noreply, S#s{port = Port, avisado = false}};
        error ->
            Av orelse io:format("semi ~b: sin dispositivo ~p, reintentando...~n", [S#s.id, F]),
            erlang:send_after(?REINTENTO_MS, self(), abrir),
            {noreply, S#s{avisado = true}}
    end;
handle_info({udp, _, _, _, <<"CMD|", Resto/binary>>}, S = #s{port = Port}) when Port =/= undefined ->
    %% Orden de la central -> linea para el micro:bit: "!D,Seq" | "!R,Seq" | "!M,Seq,Texto"
    [Seq, Accion | Txt] = binary:split(Resto, <<"|">>, [global]),
    Cod = case Accion of <<"detener">> -> "!D"; <<"reanudar">> -> "!R"; _ -> "!M" end,
    port_command(Port, [Cod, ",", Seq, ",", Txt, "\n"]),
    {noreply, S};
handle_info({Port, {data, {eol, <<"ACK,", Seq/binary>>}}}, S = #s{port = Port, id = Id, sock = Sock}) ->
    %% El micro:bit confirmo que aplico la orden -> acuse a la central.
    gen_udp:send(Sock, flota_cfg:host(), ?PUERTO,
                 iolist_to_binary(io_lib:format("ACK|~b|~s", [Id, quitar_fin_de_linea(Seq)]))),
    {noreply, S};
handle_info({Port, {data, {eol, Linea}}}, S = #s{port = Port}) ->
    {noreply, procesar(parsear(Linea), S)};
handle_info({Port, {data, {noeol, _}}}, S = #s{port = Port}) ->
    {noreply, S};
handle_info({Port, {exit_status, Codigo}}, S = #s{port = Port}) ->
    %% Cable desconectado: let it crash; el supervisor reinicia y reintenta abrir.
    {stop, {serial_cerrado, Codigo}, S};
handle_info(_, S) -> {noreply, S}.

abrir({cmd, Cmd}) -> {ok, abrir_cmd(Cmd)};
abrir(Dev) ->
    case os:type() of
        {win32, _} -> {ok, abrir_windows(Dev)};         %% Dev = "COM3"
        _          -> abrir_unix(Dev)
    end.

abrir_windows(Com) ->
    Script = filename:join(filename:dirname(code:which(?MODULE)), "puente_serial.ps1"),
    open_port({spawn_executable, os:find_executable("powershell.exe")},
              [{args, ["-NoProfile", "-ExecutionPolicy", "Bypass", "-File", Script, Com]},
               {line, 256}, binary, exit_status, hide]).

abrir_unix(Dev) ->
    case file:read_file_info(Dev) of
        {ok, _} ->
            {ok, abrir_cmd("stty " ++ flag_stty() ++ " " ++ Dev ++ " 115200 raw -echo"
                           " && exec 3<&0"
                           " && { cat <&3 > " ++ Dev ++ " & exec cat " ++ Dev ++ "; }")};
        {error, _} -> error
    end.

abrir_cmd(Cmd) ->
    open_port({spawn_executable, "/bin/sh"},
              [{args, ["-c", Cmd]}, {line, 256}, binary, exit_status]).

flag_stty() ->
    case os:type() of {unix, darwin} -> "-f"; _ -> "-F" end.

%% string:trim/1 revienta (badarg) con bytes que no son UTF-8 (ruido al conectar el cable).
quitar_fin_de_linea(Bin) -> binary:replace(Bin, [<<"\r">>, <<"\n">>], <<>>, [global]).

%% Linea del micro:bit: <<"12,19.43000,-99.13000,85,12,9,rodando\r">>
%%   seq,lat,lon,kmh,hdop10,sats,estado   -> se reenvia tal cual a la central (que valida).
%% Aqui solo se descarta lo que no tiene la FORMA correcta; la confianza en el dato es de fix.erl.
parsear(Linea) ->
    case binary:split(quitar_fin_de_linea(Linea), <<",">>, [global]) of
        [Seq, La, Lo, V, H, N, E] ->
            try {ok, binary_to_integer(Seq), binary_to_float(La), binary_to_float(Lo),
                 binary_to_integer(V), binary_to_integer(H), binary_to_integer(N), E}
            catch error:badarg -> descartar
            end;
        _ -> descartar
    end.

procesar({ok, Seq, La, Lo, V, H, N, E}, S = #s{id = Id, sock = Sock}) ->
    case lists:member(E, ?ESTADOS) of
        false -> S;
        true ->
            Msg = io_lib:format("~b|~b|~.5f|~.5f|~b|~b|~b|~s", [Id, Seq, La, Lo, V, H, N, E]),
            gen_udp:send(Sock, flota_cfg:host(), ?PUERTO, iolist_to_binary(Msg)),
            S
    end;
procesar(descartar, S) -> S.
