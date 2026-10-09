%% flota_cfg: a que IP/host mandan los semis sus paquetes UDP.
%% Prioridad: application env (flota:iniciar/3) > variable de entorno FLOTA_HOST > 127.0.0.1
-module(flota_cfg).
-export([host/0, poner_host/1]).

poner_host(Host) -> application:set_env(flota, host, Host).

%% Devuelve algo que gen_udp:send/4 acepta (tupla IP o nombre de host).
host() ->
    case application:get_env(flota, host) of
        {ok, H} -> resolver(H);
        undefined ->
            case os:getenv("FLOTA_HOST") of
                false -> {127,0,0,1};
                H -> resolver(H)
            end
    end.

resolver(H) when is_tuple(H) -> H;
resolver(H) ->
    case inet:parse_address(H) of
        {ok, Ip} -> Ip;
        {error, _} -> H                    %% nombre DNS: gen_udp lo resuelve
    end.
