# Tutorial consolidado de Erlang — básico → intermedio → avanzado

**Programación Lógica y Funcional (ISC-2006) · TecNM Campus Tijuana**

Ruta única de aprendizaje de Erlang para el curso. Reúne en un solo lugar lo que
está repartido entre la unidad 1 (primer contacto), la unidad 2 (fundamentos FP
y OTP) y la unidad 4 / proyectos finales (árboles de supervisión).

> **Todos los ejemplos están verificados** el 2026-09-01 en el nodo del curso
> (`t4g.large`, Ubuntu 24.04 aarch64), en **OTP 25** (`apt`) y **OTP 26.2.5**
> (`kerl`). El código vive en [`tutorial_erlang/`](tutorial_erlang/); para
> re-comprobarlo:
>
> ```bash
> cd tutorial_erlang && bash verificar.sh
> # ==== RESULTADO: 13 OK, 0 FAIL ====
> ```

**Instalación**: [`../../instalacion/03_erlang.md`](../../instalacion/03_erlang.md).
**Acordeón de sintaxis**: [`../../instalacion/acordeones/erlang_cheatsheet/`](../../instalacion/acordeones/erlang_cheatsheet/).

---

## Cómo ejecutar Erlang

| Forma | Cuándo |
|-------|--------|
| `erl` (shell interactiva) | explorar, probar expresiones. Salir: `q().` o `Ctrl+G q` |
| `erlc modulo.erl` → `erl -pa .` | compilar a `.beam` y cargar |
| `erl -noshell -eval 'm:f(), halt().'` | ejecutar sin shell (scripts, CI) |
| `escript archivo` | script de una sola pieza, sin compilar |
| `rebar3` | proyectos con dependencias y releases (ver 03_erlang.md) |

> En `erl -eval` **no** existe `c/1` (es solo de la shell). Compila antes con
> `erlc` y usa `erl -pa .`, o `compile:file/1` dentro del `-eval`.

---

# NIVEL 1 · Básico

Fundamentos del lenguaje: datos inmutables, pattern matching, recursión.
Material relacionado del curso: `unidad1/tema1.3/curp_funcional.erl`,
`unidad2/tema2.1/inmutabilidad.erl`, `unidad2/tema2.1/patron_matching.erl`.

## 1.1 · Binding único (no hay "variables")

En Erlang una variable se **liga una vez**. `X = 42` no es asignación: es un
*match* que tiene éxito y liga `X`. Un segundo `X = 99` es un error.

```erlang
1> X = 42.
42
2> Y = X + 8.
50
3> X = 99.
** exception error: no match of right hand side value 99
```

Esto elimina las condiciones de carrera **por diseño**: si nadie puede
re-ligar `X`, dos procesos que la leen ven siempre lo mismo. Es la base de por
qué WhatsApp corría 2 millones de conexiones por servidor sin locks.

Verificación (`verificar.sh`, test 1.1):

```bash
erl -noshell -eval 'X=42, Y=X+8, io:format("X = ~p~nY = ~p~n",[X,Y]), halt().'
# X = 42
# Y = 50
```

## 1.2 · Pattern matching y guards en vez de `if`

Una función se define por **cláusulas**; Erlang prueba de arriba a abajo la
primera cuyo patrón y `when` (guard) encajan. [`clasifica.erl`](tutorial_erlang/clasifica.erl):

```erlang
-module(clasifica).
-export([temp/1]).

temp(T) when T < 0  -> congelacion;
temp(T) when T < 15 -> frio;
temp(T) when T < 30 -> templado;
temp(_)             -> calor.
```

```bash
erlc clasifica.erl
erl -pa . -noshell -eval 'io:format("~p~n",[[clasifica:temp(X)||X<-[-5,10,22,40]]]), halt().'
# [congelacion,frio,templado,calor]
```

El validador de RFC de `unidad2/tema2.1/patron_matching.erl` lleva esta idea al
extremo: **cero `if` anidados**, todo son cláusulas con guards.

## 1.3 · Recursión de cola (tail recursion)

Erlang no tiene bucles. La iteración es recursión. Si la llamada recursiva es
**lo último** que hace la cláusula, la BEAM la ejecuta en espacio constante de
pila (no crece). Patrón: acumulador. [`suma.erl`](tutorial_erlang/suma.erl):

```erlang
-module(suma).
-export([total/1]).

total(L)          -> total(L, 0).      % interfaz pública
total([], Acc)    -> Acc;              % caso base: devuelve el acumulador
total([H|T], Acc) -> total(T, Acc + H). % llamada en posición de cola
```

```bash
erl -pa . -noshell -eval 'io:format("~p~n",[suma:total(lists:seq(1,1000000))]), halt().'
# 500000500000        (un millón de elementos, sin desbordar la pila)
```

Sin acumulador (`total([H|T]) -> H + total(T)`) la suma queda *pendiente* en la
pila y con listas grandes revienta. **Siempre** que puedas, deja la llamada
recursiva al final.

## 1.4 · Funciones de orden superior

`lists:map/2`, `lists:filter/2`, `lists:foldl/3` cubren el 90 % de lo que en
otros lenguajes es un `for`:

```bash
erl -noshell -eval '
  R = lists:foldl(fun(X,A) -> A+X end, 0,
        lists:filter(fun(X) -> X rem 2 =:= 0 end,
          lists:map(fun(X) -> X*X end, lists:seq(1,10)))),
  io:format("~p~n",[R]), halt().'
# 220        (suma de los cuadrados pares de 1..10)
```

Equivalente con *list comprehension* (más idiomático):
`[X*X || X <- lists:seq(1,10), (X*X) rem 2 =:= 0]`.

## 1.5 · Datos compuestos: tuplas, records y maps

- **Tupla**: `{ok, 42}` — tamaño fijo, se accede por pattern matching.
- **Record**: azúcar sobre tuplas con campos nombrados (compile-time).
- **Map**: diccionario dinámico `#{clave => valor}` — preferido en código nuevo.

[`registro.erl`](tutorial_erlang/registro.erl):

```erlang
-module(registro).
-export([alumno/0]).
-record(alumno, {nombre, control, semestre}).

alumno() ->
  A = #alumno{nombre = "Ana", control = "21210001", semestre = 6},
  M = #{nombre => A#alumno.nombre, control => A#alumno.control},
  {A#alumno.semestre, maps:get(nombre, M)}.
```

```bash
erl -pa . -noshell -eval 'io:format("~p~n",[registro:alumno()]), halt().'
# {6,"Ana"}
```

---

# NIVEL 2 · Intermedio

El modelo de actores: procesos ligeros que solo se comunican por mensajes.
Material del curso: `unidad2/tema2.1/inmutabilidad.erl` (§ `sin_race_condition`),
`unidad2/tema2.5/`.

## 2.1 · Procesos: `spawn`, `!`, `receive`

Un proceso de la BEAM pesa ~300 bytes. Se crean por miles. No comparten memoria:
se mandan mensajes con `!` y los reciben con `receive`.

```bash
erl -noshell -eval '
  Padre = self(),
  Pids = [spawn(fun() -> Padre ! {self(), lists:sum(lists:seq(1,1000))} end)
          || _ <- lists:seq(1,10)],
  Rs = [receive {Pid, V} -> V end || Pid <- Pids],
  io:format("~p~n",[lists:usort(Rs)]), halt().'
# [500500]        (los 10 procesos calcularon lo mismo, sin un solo lock)
```

Este es exactamente el `sin_race_condition/0` de `inmutabilidad.erl`.

## 2.2 · Estado dentro de un proceso

Erlang no tiene variables mutables, pero un proceso **sí** puede "recordar":
mantiene su estado como argumento de una función que se llama a sí misma en
cola, y entre llamada y llamada hace `receive`. [`pila_proc.erl`](tutorial_erlang/pila_proc.erl):

```erlang
-module(pila_proc).
-export([start/0, push/2, pop/1, loop/1]).

start()     -> spawn(?MODULE, loop, [[]]).
push(P, X)  -> P ! {push, X}, ok.
pop(P)      -> P ! {pop, self()}, receive {pila, V} -> V end.

loop(Estado) ->
  receive
    {push, X}   -> loop([X | Estado]);
    {pop, From} ->
      case Estado of
        []      -> From ! {pila, vacia}, loop([]);
        [H | T] -> From ! {pila, {ok, H}}, loop(T)
      end
  end.
```

```bash
erl -pa . -noshell -eval '
  P = pila_proc:start(),
  pila_proc:push(P,1), pila_proc:push(P,2),
  io:format("~p~n",[pila_proc:pop(P)]), halt().'
# {ok,2}
```

Esto es un `gen_server` "a mano". El siguiente paso es dejar que OTP ponga el
`loop` y el `receive` por ti.

## 2.3 · Enlaces y monitores: enterarse de que algo murió

`spawn_monitor/1` crea el proceso y te avisa con un mensaje `{'DOWN', ...}`
cuando termina (normal o por error). Es la pieza con la que un supervisor sabe
que debe reiniciar.

```bash
erl -noshell -eval '
  {_, Ref} = spawn_monitor(fun() -> ok end),
  receive {_, Ref, process, _, Causa} -> io:format("murio:~p~n",[Causa]) end,
  halt().'
# murio:normal
```

## 2.4 · `gen_server`: el proceso con estado, versión OTP

OTP estandariza el patrón de 2.2 en el behaviour `gen_server`: tú escribes los
*callbacks* (`init`, `handle_call`, `handle_cast`), OTP pone el bucle, el manejo
de errores, el código de actualización en caliente, las métricas.
[`contador.erl`](tutorial_erlang/contador.erl):

```erlang
-module(contador).
-behaviour(gen_server).
-export([start_link/1, incrementar/1, valor/0]).
-export([init/1, handle_call/3, handle_cast/2]).

start_link(N)  -> gen_server:start_link({local, ?MODULE}, ?MODULE, N, []).
incrementar(N) -> gen_server:cast(?MODULE, {inc, N}).    % asíncrono
valor()        -> gen_server:call(?MODULE, valor).       % síncrono

init(N)                      -> {ok, N}.
handle_cast({inc, N}, S)     -> {noreply, S + N}.
handle_call(valor, _From, S) -> {reply, S, S}.
```

```bash
erl -pa . -noshell -eval '
  {ok,_} = contador:start_link(10),
  contador:incrementar(1), contador:incrementar(5),
  io:format("~p~n",[contador:valor()]), halt().'
# 16
```

`cast` = "dispara y olvida"; `call` = bloquea hasta el `{reply, ...}`. Es el
mismo contador que el ejemplo de Elixir en `06_elixir.md` — la BEAM es la misma.

## 2.5 · "Let it crash": try/catch solo cuando aporta

La filosofía de Erlang es **no** defenderse de cada error: dejar que el proceso
muera y que un supervisor lo reinicie limpio. `try/catch` se reserva para
cuando de verdad puedes recuperarte:

```bash
erl -noshell -eval '
  R = try 1/0 catch error:E -> {error, E} end,
  io:format("~p~n",[R]), halt().'
# {error,badarith}
```

Regla práctica del curso: si no sabes qué hacer con el error, **no lo atrapes**.

---

# NIVEL 3 · Avanzado

Árboles de supervisión, estado compartido y sistemas distribuidos. Material del
curso: `unidad2/tema2.5/sensor_supervisor/`, `unidad4/tema4.4/`,
`proyectos_finales/proyecto{1,3,4}_*/capa2/`.

## 3.1 · Supervisor: reiniciar lo que cae

Un `supervisor` arranca procesos hijos según una *child spec* y los reinicia con
una estrategia. `one_for_one`: si un hijo cae, solo ese se reinicia.
[`w.erl`](tutorial_erlang/w.erl) (worker que puede reventar) +
[`sup.erl`](tutorial_erlang/sup.erl):

```erlang
-module(sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() -> supervisor:start_link({local, sup}, ?MODULE, []).

init([]) ->
  Flags = #{strategy => one_for_one, intensity => 5, period => 10},
  Child = #{id => w, start => {w, start_link, []},
            restart => permanent, shutdown => 5000,
            type => worker, modules => [w]},
  {ok, {Flags, [Child]}}.
```

```bash
erl -pa . -noshell -eval '
  {ok,_} = sup:start_link(),
  {pong,0} = w:ping(),
  w:crash(),                 % el worker muere con error
  timer:sleep(300),
  {pong,_} = w:ping(),       % ...pero el supervisor ya lo reinició
  io:format("pong tras reinicio~n"), halt().'
# pong tras reinicio
```

`intensity => 5, period => 10`: si hay más de 5 reinicios en 10 s, el supervisor
se rinde y propaga la caída hacia arriba. El `sensor_sup.erl` del tema 2.5 usa
exactamente esta estructura con 3 sensores.

## 3.2 · ETS: estado compartido rápido cuando un proceso no basta

Un `gen_server` serializa todos los accesos por un solo proceso. Cuando eso es
cuello de botella, ETS da tablas en memoria con acceso concurrente:

```bash
erl -noshell -eval '
  T = ets:new(t, [named_table]),
  ets:insert(T, {contador, 42}),
  io:format("~p~n",[hd(ets:lookup(T, contador))]), halt().'
# {contador,42}
```

Nubank usa esta idea (tablas en memoria + persistencia en Datomic) para no
consultar la base en cada request.

## 3.3 · Erlang distribuido: varios nodos

Cada BEAM es un *nodo* con nombre y una *cookie* (secreto compartido). Con la
misma cookie, `net_adm:ping/1` conecta y `rpc:call/4` ejecuta funciones remotas.
Prueba con **dos nodos en la misma VM** (no necesita abrir puertos):

```bash
IP=$(hostname -I | awk '{print $1}')

# nodo n1, vive 15 s
setsid erl -name "n1@$IP" -setcookie tut \
  -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9105 \
  -noshell -eval 'timer:sleep(15000), halt().' &
sleep 2

# nodo n2 hace ping y una llamada remota
erl -name "n2@$IP" -setcookie tut \
  -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9105 \
  -noshell -eval "N = list_to_atom(\"n1@$IP\"),
    pong = net_adm:ping(N),
    L = rpc:call(N, erlang, length, [[a,b,c]]),
    io:format(\"rpc_ok:~p~n\",[L])" -eval 'halt().'
# rpc_ok:3
```

Para nodos en **VMs distintas** hay que abrir `TCP/4369` (EPMD) y el rango
`9100-9105` en el security group — ver
[`03_erlang.md`](../../instalacion/03_erlang.md#erlang-distribuido-puertos-y-flag-de-rango-fijo).
Los flags `inet_dist_listen_min/max` fijan el puerto del nodo (si no, es
aleatorio y no se puede abrir en el firewall).

---

## De aquí a los proyectos finales

Los tres niveles se combinan en `proyectos_finales/`:

| Proyecto | Qué reusa de este tutorial |
|----------|----------------------------|
| `proyecto1_tramites_imss` | `gen_server` (2.4) por trámite + `supervisor` (3.1) |
| `proyecto3_monitor_iot` | idéntico al `sensor_supervisor` del tema 2.5 |
| `proyecto4_inventario_sat` | `gen_server` + ETS (3.2) para el catálogo |

Todos exigen que la capa Erlang no use `spawn` desnudo: **todo proceso con
estado va bajo un `gen_server` supervisado** (estándar del curso, ver
`CLAUDE.md`).

## Casos reales (honestos)

- **WhatsApp** (Erlang): ~2 M conexiones TCP por servidor; el modelo de actores
  + "let it crash" hizo posible operar con un equipo de ~50 ingenieros.
- **Discord** (Elixir/BEAM): millones de usuarios concurrentes por servidor de
  voz usando los mismos `gen_server`/`Supervisor`.
- **Facebook Chat** (Erlang, 2009): primer gran despliegue de mensajería sobre
  la BEAM.

Ver `casos_reales_mundo_real.md` para el detalle y las fuentes.
