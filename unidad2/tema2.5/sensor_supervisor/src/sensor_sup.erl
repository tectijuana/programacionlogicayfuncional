%% =====================================================================
%% Programa:    sensor_sup.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tema 2.5 — Aplicaciones FP / OTP
%% Fecha:       2026-07-18
%% Descripción: Supervisor one_for_one del sistema de sensores ("let it crash")
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
%% Archivo: sensor_sup.erl
%% Supervisor raíz del sistema de sensores IoT.
%%
%% Estrategia one_for_one: si un sensor cae, solo ESE sensor
%% se reinicia. Los demás continúan sin interrupción.
%%
%% Parámetros de reinicio:
%%   MaxRestarts = 5  — máximo 5 reinicios
%%   MaxTime     = 10 — dentro de una ventana de 10 segundos
%% Si se excede, el supervisor cede y deja caer todo el sistema.

-module(sensor_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

%% start_link/0 — det
%% Arranca el supervisor y lo registra con nombre local.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% init/1 — det
%% Define la estrategia y la lista de hijos (sensores).
init([]) ->
    io:format("[sensor_sup] Iniciando supervisor con 3 sensores...~n"),

    SupFlags = #{
        strategy  => one_for_one,  % reiniciar solo el hijo que falla
        intensity => 5,             % máximo 5 reinicios
        period    => 10             % dentro de 10 segundos
    },

    %% Especificación de hijos — un GenServer por sensor
    %% El Id del hijo coincide con el nombre registrado del proceso
    Hijos = [
        hijo_spec(temperatura, 35.0),  % umbral: 35°C
        hijo_spec(humedad,     80.0),  % umbral: 80%
        hijo_spec(presion,    1020.0)  % umbral: 1020 hPa
    ],

    {ok, {SupFlags, Hijos}}.

%% hijo_spec/2 — det (función privada auxiliar)
%% Construye la especificación OTP para un hijo GenServer.
hijo_spec(Id, Umbral) ->
    #{
        id       => Id,
        start    => {sensor_server, start_link, [Id, Umbral]},
        restart  => permanent,   % siempre reiniciar si cae
        shutdown => 5000,        % dar 5 segundos para terminar limpiamente
        type     => worker,
        modules  => [sensor_server]
    }.
