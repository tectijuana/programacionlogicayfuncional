#!/usr/bin/env bash
# Prueba la leccion sin navegador: stream SSE, reposicion con Last-Event-ID, polling y desconexion.
set -e
cd "$(dirname "$0")"
erlc +warn_all *.erl
erl -noshell -eval 'sse_demo:iniciar(8081), timer:sleep(20000), halt().' >/dev/null 2>&1 &
SRV=$!; trap 'kill $SRV 2>/dev/null' EXIT
sleep 1.5
echo "== /stream durante 7 s (eventos recibidos con id/event/data)"
curl -sN --max-time 7 localhost:8081/stream | tee /tmp/sse_out.txt | grep -c '^event:' || true
head -6 /tmp/sse_out.txt
echo "== reconexion con Last-Event-ID: 0 (debe reponer lo ya publicado)"
curl -sN --max-time 2 -H 'Last-Event-ID: 0' localhost:8081/stream | grep -c '^id:' || true
echo "== polling /polling (JSON)"
curl -s localhost:8081/polling | head -c 200; echo
echo "== / devuelve HTML"
curl -s localhost:8081/ | grep -o '<title>[^<]*'
echo "== cliente que se desconecta no deja procesos colgados"
erl -noshell -eval '
  Hijos = fun() -> proplists:get_value(active, supervisor:count_children(sse_conn_sup)) end,
  sse_demo:iniciar(8082),
  timer:sleep(500),
  {ok, S} = gen_tcp:connect("localhost", 8082, [binary, {active, false}]),
  gen_tcp:send(S, <<"GET /stream HTTP/1.1\r\nHost: x\r\n\r\n">>),
  timer:sleep(500), Con = Hijos(),
  gen_tcp:close(S),
  timer:sleep(4000), Sin = Hijos(),          %% el productor publica y el envio falla -> el proceso termina
  io:format("conectado: ~p hijos; tras cerrar: ~p hijos~n", [Con, Sin]),
  halt().' 2>&1 | grep conectado
