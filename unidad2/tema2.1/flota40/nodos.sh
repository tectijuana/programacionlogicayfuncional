#!/bin/sh
# nodos.sh [N] [HOST]  -> lanza N nodos Erlang (semi1@..semiN@), cada uno con su micro:bit simulado.
# Servidor aparte:  erl -sname central -setcookie flota   y luego  flota:central().
N=${1:-40}; HOST=${2:-127.0.0.1};
 DIR=$(cd "$(dirname "$0")" && pwd)
cd "$DIR" && erlc *.erl || exit 1
i=1
while [ $i -le "$N" ]; do
  erl -noshell -sname "semi$i" -setcookie flota -pa "$DIR" \
      -eval "flota:nodo($i, \"$HOST\")." > /dev/null 2>&1 &
  i=$((i+1))
done
echo "$N nodos lanzados (pkill -f 'sname semi' para detenerlos)"
