#!/usr/bin/env bash
# Prueba el gen_server y el supervisor SIN micro:bit: un proceso de shell
# imprime lecturas como lo haría el micro:bit y luego "se desconecta".
set -e
cd "$(dirname "$0")"
erlc +warn_all microbit_srv.erl microbit_sup.erl
erl -noshell -eval '
  Sim = "printf \"10,-20,1020,24\\r\\n0,0,1030,24\\r\\nbasura\\r\\n1500,900,1600,25\\r\\n\"; sleep 2",
  {ok, _} = microbit_sup:start_link({cmd, Sim}),
  timer:sleep(500),
  io:format("stats: ~p~n", [microbit_srv:stats()]),
  P1 = whereis(microbit_srv),
  timer:sleep(2500),
  P2 = whereis(microbit_srv),
  io:format("reiniciado por el supervisor: ~p~n", [is_pid(P2) andalso P1 =/= P2]),
  halt().' 2>&1 | grep -E "ALERTA|stats|reiniciado"
