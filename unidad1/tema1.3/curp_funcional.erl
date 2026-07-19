%% =====================================================================
%% Programa:    curp_funcional.erl
%% Autor:       Dr. René Solís Reyes — Docente, TecNM Campus Tijuana
%% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
%% Actividad:   Tema 1.3 — Comparación de paradigmas
%% Fecha:       2026-07-18
%% Descripción: Validador de CURP en paradigma funcional con pattern matching
%% IA:          Generado con Claude Code, verificado y modificado por el docente
%% =====================================================================
%% curp_funcional.erl — Validador de CURP mexicana, paradigma funcional.
%%
%% Cómo compilar y correr:
%%   erlc curp_funcional.erl
%%   erl -noshell -s curp_funcional demo -s init stop
%%
%% Diferencias clave con la versión imperativa (Python):
%%   - Ninguna variable cambia de valor después de ser asignada.
%%   - No hay excepciones. Los errores son valores retornados: {error, Razon}.
%%   - Pattern matching reemplaza if/switch.
%%   - Las funciones son puras: mismo input, mismo output, siempre.

-module(curp_funcional).
-export([validar/1, extraer_fecha/1, extraer_sexo/1, extraer_estado/1, demo/0]).

%% -------------------------------------------------------------------
%% Estados de nacimiento válidos según RENAPO
%% -------------------------------------------------------------------
-define(ESTADOS, [
    "AS","BC","BS","CC","CL","CM","CS","DF","DG",
    "GR","GT","HG","JC","MC","MN","MS","NT","NL",
    "OC","PL","QO","QR","SP","SL","SR","TC","TS",
    "TL","VZ","YN","ZS"
]).

%% -------------------------------------------------------------------
%% validar/1 -- determinista
%% validar(+CURP::string()) -> {ok, map()} | {error, [string()]}
%%
%% Valida una CURP y retorna sus datos estructurados o lista de errores.
%% Nunca lanza excepciones. Los errores son valores.
%% -------------------------------------------------------------------
validar(CURP) ->
    Errores = lists:filtermap(
        fun(ValidadorFn) -> ValidadorFn(CURP) end,
        [fun valida_longitud/1, fun valida_sexo/1, fun valida_estado/1]
    ),
    case Errores of
        [] ->
            {ok, #{
                curp   => CURP,
                fecha  => extraer_fecha(CURP),
                sexo   => extraer_sexo(CURP),
                estado => extraer_estado(CURP)
            }};
        _ ->
            {error, Errores}
    end.

%% -------------------------------------------------------------------
%% Validadores individuales — cada uno retorna false (sin error) o
%% {true, MensajeError} para que filtermap lo recoja.
%% -------------------------------------------------------------------

valida_longitud(CURP) ->
    case length(CURP) of
        18 -> false;
        N  -> {true, io_lib:format("Longitud inválida: ~w caracteres (se esperan 18)", [N])}
    end.

valida_sexo(CURP) when length(CURP) >= 11 ->
    Sexo = lists:nth(11, CURP),
    case Sexo of
        $H -> false;
        $M -> false;
        C  -> {true, io_lib:format("Sexo inválido en posición 11: '~c' (H o M)", [C])}
    end;
valida_sexo(_) ->
    false.

valida_estado(CURP) when length(CURP) >= 13 ->
    Estado = lists:sublist(CURP, 12, 2),
    case lists:member(Estado, ?ESTADOS) of
        true  -> false;
        false -> {true, io_lib:format("Estado inválido en posiciones 12-13: '~s'", [Estado])}
    end;
valida_estado(_) ->
    false.

%% -------------------------------------------------------------------
%% Extractores — retornan {ok, Valor} | {error, Razon}
%% -------------------------------------------------------------------

%% extraer_fecha/1 -- determinista
%% extraer_fecha(+CURP::string()) -> {ok, #{anio, mes, dia}} | {error, atom()}
extraer_fecha(CURP) when length(CURP) >= 10 ->
    AnioStr = lists:sublist(CURP, 5, 2),
    MesStr  = lists:sublist(CURP, 7, 2),
    DiaStr  = lists:sublist(CURP, 9, 2),
    try
        Anio = list_to_integer(AnioStr),
        Mes  = list_to_integer(MesStr),
        Dia  = list_to_integer(DiaStr),
        {ok, #{anio => Anio, mes => Mes, dia => Dia}}
    catch
        _:_ -> {error, fecha_no_numerica}
    end;
extraer_fecha(_) ->
    {error, curp_demasiado_corta}.

%% extraer_sexo/1 -- determinista
%% extraer_sexo(+CURP::string()) -> {ok, string()} | {error, atom()}
extraer_sexo(CURP) when length(CURP) >= 11 ->
    case lists:nth(11, CURP) of
        $H -> {ok, "Hombre"};
        $M -> {ok, "Mujer"};
        C  -> {error, {sexo_invalido, C}}
    end;
extraer_sexo(_) ->
    {error, curp_demasiado_corta}.

%% extraer_estado/1 -- determinista
%% extraer_estado(+CURP::string()) -> {ok, string()} | {error, atom()}
extraer_estado(CURP) when length(CURP) >= 13 ->
    {ok, lists:sublist(CURP, 12, 2)};
extraer_estado(_) ->
    {error, curp_demasiado_corta}.

%% -------------------------------------------------------------------
%% demo/0 -- efecto secundario controlado (solo imprime)
%% -------------------------------------------------------------------
demo() ->
    Casos = [
        "SAOA800115HBCNND05",
        "GACF850320MMCNRR09",
        "CORTO",
        "SAOA800115XBCNND05",
        "SAOA800115HXXNND05"
    ],
    lists:foreach(fun imprimir_resultado/1, Casos).

imprimir_resultado(CURP) ->
    io:format("~nCURP: ~s~n", [CURP]),
    case validar(CURP) of
        {ok, Datos} ->
            {ok, #{anio := A, mes := M, dia := D}} = maps:get(fecha, Datos),
            {ok, Sexo}   = maps:get(sexo, Datos),
            {ok, Estado} = maps:get(estado, Datos),
            io:format("  Estado:  VÁLIDA~n"),
            io:format("  Fecha:   ~2..0w/~2..0w/~2..0w~n", [D, M, A]),
            io:format("  Sexo:    ~s~n", [Sexo]),
            io:format("  Estado:  ~s~n", [Estado]);
        {error, Errores} ->
            io:format("  Estado:  INVÁLIDA~n"),
            lists:foreach(
                fun(E) -> io:format("  x ~s~n", [E]) end,
                Errores
            )
    end.
