#!/usr/bin/env bash
# Compila, corre eunit y prueba el servidor con el emisor simulado (sin micro:bit).
set -e
cd "$(dirname "$0")"
erlc +warn_all lector.erl lector_srv.erl
erlc +warn_all -DTEST lector_tests.erl
erl -noshell -eval 'eunit:test(lector_tests), halt().' 2>&1 | tail -1
erl -noshell -eval '
  {ok, _} = lector_srv:start_link({cmd, "./emisor_sim.sh 3"}),
  timer:sleep(800),
  io:format("ultimo: ~p~ncontadores: ~p~n", [lector_srv:ultimo(), lector_srv:contadores()]),
  halt().' 2>&1 | grep -E "ALERTA|boton|ultimo|contadores"
