%% =====================================================================
%% Programa:    sensor_server.erl
%% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tema 2.5 — Aplicaciones FP / OTP
%% Fecha:       2026-07-18
%% Descripción: GenServer: un proceso por sensor con umbral de alerta
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
%% Archivo: sensor_server.erl
%% GenServer que representa un sensor IoT.
%%
%% Estado del proceso:
%%   id       — átomo identificador (temperatura, humedad, presion)
%%   lecturas — lista de lecturas recientes (máximo 100)
%%   umbral   — valor que dispara alerta cuando se supera
%%
%% API pública:
%%   start_link/2  — arranca el proceso y lo registra por nombre
%%   leer/1        — solicita lectura actual
%%   get_historial/1 — retorna lista de lecturas almacenadas
%%   set_umbral/2  — actualiza el umbral de alerta

-module(sensor_server).
-behaviour(gen_server).

%% API pública
-export([start_link/2, leer/1, get_historial/1, set_umbral/2]).

%% Callbacks OTP obligatorios
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

-define(INTERVALO_MS, 5000).   % polling automático cada 5 segundos
-define(MAX_LECTURAS, 100).     % historial máximo

%% ============================================================
%% API PÚBLICA
%% ============================================================

%% start_link/2 — det
%% start_link(+Id:atom, +Umbral:float) is det
%% Arranca el GenServer y lo registra localmente con el átomo Id.
start_link(Id, Umbral) ->
    gen_server:start_link({local, Id}, ?MODULE, {Id, Umbral}, []).

%% leer/1 — det
%% leer(+Id:atom) -> {ok, Lectura::float()} | {error, term()}
%% Solicita una lectura al sensor identificado por Id.
leer(Id) ->
    gen_server:call(Id, leer).

%% get_historial/1 — det
%% get_historial(+Id:atom) -> [float()]
%% Retorna la lista de lecturas almacenadas (la más reciente primero).
get_historial(Id) ->
    gen_server:call(Id, get_historial).

%% set_umbral/2 — det
%% set_umbral(+Id:atom, +NuevoUmbral:float) -> ok
%% Actualiza el umbral de alerta del sensor.
set_umbral(Id, NuevoUmbral) ->
    gen_server:cast(Id, {set_umbral, NuevoUmbral}).

%% ============================================================
%% CALLBACKS GEN_SERVER
%% ============================================================

%% init/1 — det
%% Inicializa el estado del sensor y programa el primer polling.
init({Id, Umbral}) ->
    io:format("[~p] Sensor iniciado. Umbral: ~p~n", [Id, Umbral]),
    %% Programar el primer ciclo de polling
    erlang:send_after(?INTERVALO_MS, self(), polling),
    Estado = #{id => Id, lecturas => [], umbral => Umbral},
    {ok, Estado}.

%% handle_call/3 — det
%% Maneja solicitudes síncronas (requieren respuesta).
handle_call(leer, _From, Estado = #{id := Id, lecturas := Ls, umbral := Umbral}) ->
    Lectura = simular_lectura(Id),
    LecturasActualizadas = agregar_lectura(Lectura, Ls),
    verificar_umbral(Id, Lectura, Umbral),
    {reply, {ok, Lectura}, Estado#{lecturas => LecturasActualizadas}};

handle_call(get_historial, _From, Estado = #{lecturas := Ls}) ->
    {reply, Ls, Estado}.

%% handle_cast/2 — det
%% Maneja solicitudes asíncronas (sin respuesta al llamador).
handle_cast({set_umbral, NuevoUmbral}, Estado = #{id := Id}) ->
    io:format("[~p] Umbral actualizado a ~p~n", [Id, NuevoUmbral]),
    {noreply, Estado#{umbral => NuevoUmbral}};

handle_cast(reset_historial, Estado = #{id := Id}) ->
    io:format("[~p] Historial reiniciado~n", [Id]),
    {noreply, Estado#{lecturas => []}}.

%% handle_info/2 — det
%% Maneja mensajes no-OTP enviados al proceso (incluido el polling).
handle_info(polling, Estado = #{id := Id, lecturas := Ls, umbral := Umbral}) ->
    Lectura = simular_lectura(Id),
    LecturasActualizadas = agregar_lectura(Lectura, Ls),
    verificar_umbral(Id, Lectura, Umbral),
    %% Reprogramar el siguiente polling
    erlang:send_after(?INTERVALO_MS, self(), polling),
    {noreply, Estado#{lecturas => LecturasActualizadas}};

handle_info(Msg, Estado = #{id := Id}) ->
    io:format("[~p] Mensaje inesperado: ~p~n", [Id, Msg]),
    {noreply, Estado}.

%% terminate/2 — det
%% Llamado cuando el proceso va a terminar (limpieza de recursos).
terminate(Reason, #{id := Id}) ->
    io:format("[~p] Terminando: ~p~n", [Id, Reason]),
    ok.

%% ============================================================
%% FUNCIONES PRIVADAS
%% ============================================================

%% simular_lectura/1 — det
%% Simula una lectura de sensor según el tipo.
%% En producción, esto llamaría al hardware o API del sensor.
simular_lectura(temperatura) ->
    %% Temperatura: entre 15 y 45 °C con ruido
    15.0 + rand:uniform(30) + rand:uniform(10) / 10.0;
simular_lectura(humedad) ->
    %% Humedad relativa: 30% a 95%
    30.0 + rand:uniform(65) + rand:uniform(10) / 10.0;
simular_lectura(presion) ->
    %% Presión atmosférica: 990 a 1030 hPa
    990.0 + rand:uniform(40) + rand:uniform(10) / 10.0;
simular_lectura(_) ->
    0.0.

%% agregar_lectura/2 — det
%% Agrega una lectura al historial, manteniendo máximo MAX_LECTURAS.
agregar_lectura(Lectura, Ls) when length(Ls) >= ?MAX_LECTURAS ->
    [Lectura | lists:droplast(Ls)];
agregar_lectura(Lectura, Ls) ->
    [Lectura | Ls].

%% verificar_umbral/3 — det
%% Imprime alerta si la lectura supera el umbral.
verificar_umbral(Id, Lectura, Umbral) when Lectura > Umbral ->
    io:format("[ALERTA] ~p: ~.1f supera umbral ~.1f~n", [Id, Lectura, Umbral]);
verificar_umbral(_, _, _) ->
    ok.
