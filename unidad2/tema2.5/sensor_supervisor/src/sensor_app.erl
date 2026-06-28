%% Archivo: sensor_app.erl
%% Punto de entrada de la aplicación OTP.
%% OTP Application behaviour — gestiona el ciclo de vida del sistema.

-module(sensor_app).
-behaviour(application).

-export([start/2, stop/1]).

%% start/2 — det
%% Llamado por application:start(sensor_app).
%% Arranca el árbol de supervisión raíz.
start(_StartType, _StartArgs) ->
    io:format("[sensor_app] Iniciando sistema de monitoreo IoT...~n"),
    sensor_sup:start_link().

%% stop/1 — det
%% Llamado cuando la aplicación se detiene limpiamente.
stop(_State) ->
    io:format("[sensor_app] Sistema detenido.~n"),
    ok.
