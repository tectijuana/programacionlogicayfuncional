#!/bin/sh
# Simula el micro:bit SIN hardware: imprime el mismo protocolo (incluida basura) y termina.
# Uso desde Erlang: lector_srv:start_link({cmd, "./emisor_sim.sh"})
printf 'A:12,-40,1010\r\n'
printf 'T:24\r\n'
printf 'B:A\r\n'
printf 'A:10,-35,1020\r\n'
printf '\xff\xfebasura\r\n'
printf 'T:cuarenta\r\n'
printf 'A:1500,900,1600\r\n'
printf 'T:41\r\n'
printf 'B:AB\r\n'
printf 'X:???\r\n'
sleep ${1:-30}
