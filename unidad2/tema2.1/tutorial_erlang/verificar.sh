#!/bin/bash
# =====================================================================
# verificar.sh — comprueba los 13 ejemplos del TUTORIAL_ERLANG.md
# Uso:  bash verificar.sh
# Requiere: erl/erlc en el PATH (OTP 25 o 26). Para el nivel 3.3 (nodos)
#           necesita `epmd` disponible (viene con OTP).
# Verificado 2026-09-01 en OTP 25 (apt) y OTP 26.2.5 (kerl), nodo t4g.large.
# =====================================================================
cd "$(dirname "$0")" || exit 1

R() { erl -pa . -noshell -eval "$1" -eval 'halt().' 2>&1; }

erl -noshell -eval 'io:format("### OTP ~s / erts ~s~n",[erlang:system_info(otp_release),erlang:system_info(version)]),halt().'

pass=0; fail=0
check() { local d="$1" e="$2" out="$3"
  if echo "$out" | grep -qF "$e"; then echo "  OK   $d"; pass=$((pass+1))
  else echo "  FAIL $d (esperaba: $e)"; echo "$out" | sed 's/^/       | /'; fail=$((fail+1)); fi; }

echo "== compilar =="
erlc clasifica.erl suma.erl registro.erl pila_proc.erl contador.erl w.erl sup.erl \
  && echo "  .beam OK" || { echo "  ERLC FALLÓ"; exit 1; }

echo "== NIVEL 1: BÁSICO =="
check "1.1 binding y aritmética" "Y = 50" \
  "$(R 'X=42, Y=X+8, io:format("X = ~p~nY = ~p~n",[X,Y])')"
check "1.2 guards" "[congelacion,frio,templado,calor]" \
  "$(R 'io:format("~p~n",[[clasifica:temp(X)||X<-[-5,10,22,40]]])')"
check "1.3 recursión de cola (1..1e6)" "500000500000" \
  "$(R 'io:format("~p~n",[suma:total(lists:seq(1,1000000))])')"
check "1.4 map/filter/foldl" "220" \
  "$(R 'io:format("~p~n",[lists:foldl(fun(X,A)->A+X end,0,[Y||Y<-[X*X||X<-lists:seq(1,10)], Y rem 2=:=0])])')"
check "1.5 records + maps" "{6,\"Ana\"}" \
  "$(R 'io:format("~p~n",[registro:alumno()])')"

echo "== NIVEL 2: INTERMEDIO =="
check "2.1 spawn + send/receive (10 procs)" "[500500]" \
  "$(R 'P=self(), Ps=[spawn(fun()->P!{self(),lists:sum(lists:seq(1,1000))} end)||_<-lists:seq(1,10)], Rs=[receive {Pid,V}->V end||Pid<-Ps], io:format("~p~n",[lists:usort(Rs)])')"
check "2.2 proceso con estado" "{ok,2}" \
  "$(R 'P=pila_proc:start(), pila_proc:push(P,1), pila_proc:push(P,2), io:format("~p~n",[pila_proc:pop(P)])')"
check "2.3 monitor detecta DOWN" "murio:normal" \
  "$(R '{_,Ref}=spawn_monitor(fun()->ok end), receive {_,Ref,process,_,X}->io:format("murio:~p~n",[X]) end')"
check "2.4 gen_server contador" "16" \
  "$(R '{ok,_}=contador:start_link(10), contador:incrementar(1), contador:incrementar(5), io:format("~p~n",[contador:valor()])')"
check "2.5 try/catch (let it crash controlado)" "{error,badarith}" \
  "$(R 'io:format("~p~n",[try 1/0 catch error:E -> {error,E} end])')"

echo "== NIVEL 3: AVANZADO =="
check "3.1 supervisor reinicia worker tras crash" "pong tras reinicio" \
  "$(R '{ok,_}=sup:start_link(), {pong,0}=w:ping(), w:crash(), timer:sleep(300), {pong,_}=w:ping(), io:format("pong tras reinicio~n")')"
check "3.2 ETS insert/lookup" "{contador,42}" \
  "$(R 'T=ets:new(t,[named_table]), ets:insert(T,{contador,42}), io:format("~p~n",[hd(ets:lookup(T,contador))])')"

IP=$(hostname -I | awk '{print $1}')
setsid erl -name "n1@$IP" -setcookie tut \
  -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9105 \
  -noshell -eval 'timer:sleep(15000), halt().' &
sleep 2
check "3.3 distribución: ping + rpc entre nodos" "rpc_ok" \
  "$(erl -name "n2@$IP" -setcookie tut \
       -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9105 \
       -noshell \
       -eval "N=list_to_atom(\"n1@$IP\"), pong=net_adm:ping(N), L=rpc:call(N,erlang,length,[[a,b,c]]), io:format(\"rpc_ok:~p~n\",[L])" \
       -eval 'halt().' 2>&1)"

echo
echo "==== RESULTADO: $pass OK, $fail FAIL ===="
[ "$fail" -eq 0 ]
