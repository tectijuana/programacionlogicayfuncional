%% flota: API de demostracion (usar desde la shell de erl).
-module(flota).
-export([iniciar/0, iniciar/1, iniciar/2, central/0, nodo/2, ordenar/3, eventos/0, prueba_red/1, semis/2, semis/3, mostrar/2, estado/0, boton/2, matar/1, vm/0, semi_vm/1]).

iniciar() -> iniciar(40).
iniciar(N) -> flota_sup:start_link(N).

%% iniciar(40, [{41, "/dev/cu.usbmodem1102"}]) : 40 simulados + 1 micro:bit fisico
iniciar(N, Seriales) -> flota_sup:start_link(N, Seriales).

%% Servidor: solo central (UDP 5000) + dashboard web (http://IP:8080).
central() -> flota_sup:start_link(0, [], central).

%% PC de alumno: sin central; manda a Host (p. ej. "10.0.0.5" o "flota.ejemplo.mx").
%% semis("10.0.0.5", 41, [{41, "COM3"}])  -> solo el micro:bit fisico
semis(Host, Seriales) -> semis(Host, 0, Seriales).
semis(Host, N, Seriales) ->
    flota_cfg:poner_host(Host),
    flota_sup:start_link(N, Seriales, semis).

%% Texto en la matriz LED del micro:bit fisico Id
mostrar(Id, Texto) -> semi_serial:mostrar(Id, Texto).

estado() ->
    io:format("~-4s ~-9s ~-10s ~-5s ~s~n", ["ID", "LAT", "LON", "km/h", "ESTADO"]),
    [io:format("~-4b ~-9.4f ~-10.4f ~-5b ~s~n", [I, La, Lo, V, E])
     || {I, La, Lo, V, E, _} <- central:flota()],
    io:format("paquetes UDP recibidos: ~b~n", [central:paquetes()]).

boton(Id, B) -> semi:boton(Id, B).

%% Mata el proceso de un semi: el supervisor lo reinicia (pierde su estado).
matar(Id) ->
    Antes = whereis(semi:nombre(Id)),
    exit(Antes, kill),
    timer:sleep(50),
    io:format("semi ~b: pid ~p -> ~p~n", [Id, Antes, whereis(semi:nombre(Id))]).

%% Lo que ve la BEAM por dentro.
vm() ->
    io:format("procesos vivos : ~b (limite ~b)~n",
              [erlang:system_info(process_count), erlang:system_info(process_limit)]),
    io:format("schedulers     : ~b (cores logicos: ~b)~n",
              [erlang:system_info(schedulers_online), erlang:system_info(logical_processors)]),
    io:format("memoria total  : ~.1f MB~n", [erlang:memory(total) / 1048576]),
    io:format("reducciones    : ~b~n", [element(1, erlang:statistics(reductions))]).

semi_vm(Id) ->
    Pid = whereis(semi:nombre(Id)),
    process_info(Pid, [memory, message_queue_len, reductions, heap_size, status]).

%% Mando manual: flota:ordenar(7, detener, "") | reanudar | aviso, "ALTO"
ordenar(Id, Accion, Texto) -> central:ordenar(Id, Accion, Texto).

eventos() ->
    [io:format("~s ~-11s semi ~-3b ~s~n", [hora(T), Tipo, Id, Det])
     || {{T, _}, Tipo, Id, Det} <- lists:sublist(central:eventos(), 30)],
    ok.

hora(Ms) ->
    {_, {H, M, S}} = calendar:system_time_to_local_time(Ms, millisecond),
    io_lib:format("~2..0b:~2..0b:~2..0b", [H, M, S]).

%% Prueba de VLAN ANTES de la clase: ¿llega UDP 5000 al servidor y regresa?
prueba_red(Host) ->
    {ok, S} = gen_udp:open(0, [binary, {active, false}]),
    Dest = case inet:parse_address(Host) of {ok, Ip} -> Ip; _ -> Host end,
    gen_udp:send(S, Dest, 5000, <<"PING">>),
    R = case gen_udp:recv(S, 0, 2000) of
            {ok, {_, _, <<"PONG">>}} -> "OK: ida y vuelta UDP 5000 con " ++ Host;
            _ -> "FALLA: sin respuesta (firewall/VLAN/IP o central apagada)"
        end,
    gen_udp:close(S),
    io:format("~s~n", [R]).

%% Un NODO Erlang por semi (erl -sname semiN): proceso que no muere con quien lo lanza.
%% El "micro:bit" es microbit/emulador.py ejecutando el main.py REAL (traza GPS, botones,
%% ordenes con ACK) por el mismo puerto serial/protocolo que la tarjeta fisica.
nodo(Id, Host) ->
    Emu = filename:join([filename:dirname(code:which(?MODULE)), "microbit", "emulador.py"]),
    Cmd = lists:flatten(io_lib:format("python3 -u ~s", [Emu])),
    spawn(fun() -> {ok, _} = semis(Host, [{Id, {cmd, Cmd}}]), receive parar -> ok end end),
    ok.
