# Práctica 0 — Leer patrones con un micro:bit y conocer el servidor de Erlang

> **Tema 2.1 · Programación Lógica y Funcional (ISC) · TecNM Campus Tijuana**
> Código: [`patrones_mbit/`](patrones_mbit/) · Duración sugerida: 1 sesión de 4 h
> **Va antes de** [`erlangmbit.md`](erlangmbit.md) y de [`flota40/`](flota40/)

---

## ¿Por qué esta práctica?

En [`erlangmbit`](erlangmbit.md) y en `flota40` verás supervisores, ACK y 40 nodos. Antes necesitas dominar dos cosas pequeñas:

1. **Leer patrones:** el micro:bit manda líneas de texto (`T:24`, `B:AB`, `A:12,-40,1010`, y a veces basura). En Erlang cada formato es **una cláusula**, y el pattern matching reemplaza a la cascada de `if`/`switch` de otros lenguajes.
2. **Conocer el servidor de Erlang:** un nodo Erlang (la BEAM) *es* un servidor. Tiene procesos, nombres registrados, puertos y un nombre de red. Antes de pedirle trabajo, aprende a mirarlo por dentro.

```text
micro:bit ──USB──►  Port  ──►  lector_srv (gen_server)  ──usa──►  lector:leer/1   (PURO)
 "T:24\r\n"                     guarda último valor + contadores    "T:24" → {temp, 24}
```

| Idea | Dónde la verás |
|---|---|
| **Pattern matching sobre binarios** | `lector:leer/1`: una cláusula por formato (`<<"T:", N/binary>>`) |
| **Guardas** | `lector:clasificar/1`: `when T >= 40`, sin `if` |
| **Núcleo puro + servidor con efectos** | `lector` no tiene procesos; `lector_srv` solo guarda estado |
| **Qué atrapa el compilador y qué el runtime** | Una forma no cubierta → `function_clause` en tiempo de ejecución |
| **El nodo como servidor** | `registered()`, `process_info/2`, `observer`, dos nodos hablándose |

---

## Escenario: Clarvi, transporte de carga

> **Empresa ficticia con fines didácticos.** Clarvi no existe; el escenario sirve para darle propósito al código.

**Clarvi** es una empresa de transporte de carga con base en Tijuana. Opera tractocamiones (*semis*) en rutas de la frontera norte hacia el centro del país. Su área de operaciones sufre tres problemas cotidianos:

1. **No sabe qué pasa en la cabina.** Si el operador frena de golpe, sufre un incidente o la temperatura sube más de lo normal, la central se entera horas después, por llamada o por bitácora.
2. **El operador no tiene un botón de ayuda inmediato.** Pide apoyo por teléfono, cuando puede.
3. **Los datos del dispositivo no son confiables.** Los equipos de cabina mandan lecturas con ruido, líneas cortadas o formatos que cambian entre versiones.

El área de TI decidió prototipar una **unidad de cabina** barata. Un micro:bit hace de ella, y la central de monitoreo se escribe en Erlang. Tú eres el desarrollador junior a quien le encargan el primer eslabón:

| En el micro:bit | Qué representa en Clarvi |
|---|---|
| `A:x,y,z` (acelerómetro) | Frenado brusco, golpe o volcadura |
| `T:23` (temperatura) | Temperatura de cabina o de la carga |
| `B:A` · `B:B` · `B:AB` | Botones del operador (parada, ayuda, emergencia) |
| Líneas inválidas (`T:cuarenta`, bytes raros) | Ruido real de un cable o de un firmware viejo |

### Justificación de la práctica

- **Por qué empezar leyendo patrones:** antes de coordinar una flota, la central debe interpretar bien un solo dispositivo. Una línea mal leída puede significar una alerta falsa que mueve una patrulla, o una alerta real que nadie ve.
- **Por qué el lector es puro:** Clarvi cambia de proveedor de dispositivos cada cierto tiempo. Si interpretar una línea es una función pura (`lector:leer/1`), se prueba con 17 pruebas sin tener un camión ni un cable, y se ajusta cuando cambie el formato.
- **Por qué un servidor aparte:** la central guarda el último valor de cada tipo y cuenta cuántas lecturas fueron basura. Esos contadores son un indicador de salud del equipo: un aumento de basura en un camión sugiere un cable dañado.
- **Por qué conocer el nodo Erlang:** la central de Clarvi será un conjunto de nodos que se consultan entre sí. Aprender a mirar un nodo (procesos, nombres, cola de mensajes) es lo que permite diagnosticar la central cuando algo falla.
- **Qué sigue:** con un camión dominado, [`erlangmbit`](erlangmbit.md) agrega supervisión (el sistema se recupera solo si el cable se desconecta) y [`flota40/`](flota40/) escala a 40 unidades, con mando desde la central.

> Este proyecto no es una fantasía académica: modela un tipo de problema (telemetría de flotas, dispositivos poco confiables, muchos clientes concurrentes) que en la industria se resuelve con programación declarativa, funcional y procesos supervisados. No afirma que ninguna empresa concreta use esta arquitectura.

---

## Material

- 1 micro:bit (V1 o V2) con cable USB, o ninguno: el emisor simulado sirve igual.
- Erlang/OTP 25+ (`erl`). Código verificado con OTP 29.
- Archivos de [`patrones_mbit/`](patrones_mbit/): `main.py` (micro:bit), `emisor_sim.sh` (sin hardware), `lector.erl`, `lector_srv.erl`, `lector_tests.erl`, `verificar.sh`.

---

## Paso 1 — El protocolo del micro:bit

Pega [`main.py`](patrones_mbit/main.py) en [python.microbit.org](https://python.microbit.org) y envíalo a la tarjeta. Imprime una línea por evento:

| Línea | Significado | Frecuencia |
|---|---|---|
| `A:x,y,z` | acelerómetro (mg) | 5 por segundo |
| `T:23` | temperatura (°C) | 1 por segundo |
| `B:A` · `B:B` · `B:AB` | botón(es) pulsado(s) | al pulsar |

Con el botón *Show serial* del editor web verás las líneas. Pulsa A, B y A+B.
Sin micro:bit usa `./emisor_sim.sh`: imprime las mismas líneas **más basura a propósito** (`T:cuarenta`, bytes inválidos, `X:???`).

---

## Paso 2 — Leer a mano en la shell

Abre el puerto sin escribir ningún módulo (modo simulado; con hardware cambia el comando por el de `lector_srv:init/1`):

```erlang
$ cd patrones_mbit && erl
1> P = open_port({spawn_executable, "/bin/sh"},
                 [{args, ["-c", "./emisor_sim.sh 5"]}, {line, 256}, binary, exit_status]).
2> flush().
Shell got {#Port<0.5>,{data,{eol,<<"A:12,-40,1010\r">>}}}
Shell got {#Port<0.5>,{data,{eol,<<"T:24\r">>}}}
...
```

`flush()` te muestra los **mensajes** que el puerto le mandó a tu proceso (la shell). Cada línea llega como `{Puerto, {data, {eol, Linea}}}`. Ahora haz *tú* el matching:

```erlang
3> {_, {data, {eol, L}}} = {p, {data, {eol, <<"T:24\r">>}}}.   %% desarmar el mensaje
4> <<"T:", Resto/binary>> = L.                                 %% ¿empieza con "T:"?   Resto = <<"24\r">>
5> <<"B:A">> = <<"B:B">>.
** exception error: no match of right hand side value <<"B:B">>
6> <<"T:", Resto/binary>> = <<"B:A">>.
** exception error: no match of right hand side value <<"B:A">>
```

Un `=` con un patrón a la izquierda **es una pregunta**: "¿tiene esta forma?". Si sí, liga variables (`Resto`); si no, falla con `badmatch`. Eso es lo que `lector:leer/1` hace una vez por cada formato. En la línea 6, `Resto` ya estaba ligada a `<<"24\r">>` y el patrón falla antes por la forma, no por el valor (pruébalo con `f(Resto).` para olvidarla).

> **Pregunta 1.** ¿Qué devuelve `binary_to_integer(<<"24\r">>)`? ¿Y `binary_to_integer(<<"cuarenta">>)`? ¿Qué te dice eso de por qué `lector` limpia el `\r` primero?

---

## Paso 3 — Un formato, una cláusula (`lector.erl`)

```sh
cd patrones_mbit && erlc lector.erl lector_srv.erl
```

Lee [`lector.erl`](patrones_mbit/lector.erl) y pruébalo en la shell:

```erlang
1> lector:leer(<<"T:24\r\n">>).
{temp,24}
2> lector:leer(<<"B:AB">>).
{boton,ab}
3> lector:leer(<<"A:12,-40,1010\r">>).
{acc,12,-40,1010}
4> lector:leer(<<"T:cuarenta">>).
basura
5> lector:leer(<<255,254,"x">>).     %% ruido de arranque del cable
basura
6> lector:clasificar({temp, 41}).
alerta
7> lector:clasificar({acc, 1500, 900, 1600}).
alerta
8> lector:clasificar({temperatura, 20}).
** exception error: no function clause matching lector:clasificar({temperatura,20})
```

Observa:

- **El orden importa.** `parsear(<<"B:A">>)` va antes de `parsear(<<"B:AB">>)`: son exactos, así que no se pisan. Prueba qué pasaría con un patrón general `<<"B:", X/binary>>` puesto *primero*.
- **Las guardas sustituyen al `if`.** `clasificar({temp, T}) when T >= 40` lee casi como la regla de negocio.
- **Compilador vs. ejecución.** El compilador **no** sabe que `{temperatura, 20}` no está cubierto: lo descubres en ejecución (`function_clause`). `-spec` + Dialyzer sí lo advierte *antes*; el pattern matching de Erlang es dinámico, no un tipo suma como en Haskell u OCaml.
- **Un bug real que apareció al escribir esta práctica:** la primera versión usaba `string:trim/1` y **reventaba** con `<<255,254,"x">>` (`badarg`, no es UTF-8). Un micro:bit recién conectado sí manda ruido. Moraleja: en la frontera con hardware, valida bytes, no cadenas.

Corre las pruebas: `erlc -DTEST lector_tests.erl && erl -noshell -eval 'eunit:test(lector_tests), halt().'` → 17 pruebas.

---

## Paso 4 — Conoce el servidor (el nodo Erlang)

Levanta el servidor que usa el módulo puro:

```erlang
1> {ok, Pid} = lector_srv:start_link({cmd, "./emisor_sim.sh 120"}).
boton a
ALERTA {acc,1500,900,1600}
ALERTA {temp,41}
boton ab
2> lector_srv:ultimo().
#{acc => {acc,1500,900,1600}, boton => {boton,ab}, temp => {temp,41}}
3> lector_srv:contadores().
#{acc => 3, basura => 3, boton => 2, temp => 2}
```

Con hardware: `lector_srv:start_link("/dev/cu.usbmodem1102").` (macOS), `"/dev/ttyACM0"` (Linux). `lector_srv:mostrar("HOLA")` escribe en la matriz LED.

Ahora **mira el servidor por dentro**. Contesta cada punto con lo que ves en tu pantalla:

```erlang
4> node().                                   %% nombre de este nodo (sin -sname: nonode@nohost)
5> registered().                             %% procesos con nombre: ¿aparece lector_srv?
6> whereis(lector_srv) =:= Pid.              %% el nombre apunta a tu pid
7> process_info(Pid, [registered_name, status, message_queue_len, memory, links]).
8> sys:get_status(lector_srv).               %% estado interno del gen_server (¡sin tocarlo!)
9> erlang:system_info(schedulers_online).    %% hilos del SO que reparten procesos
10> length(erlang:ports()).                  %% puertos abiertos (el serial es uno)
11> observer:start().                        %% GUI: pestaña Applications, Processes, Load
```

> **Pregunta 2.** En `links` aparecen dos elementos: tu shell y un `#Port`. Si el cable se desconecta, ¿cuál de los dos "muere" primero y qué pasa con `lector_srv`? (Lo verás con supervisor en `erlangmbit`.)
>
> **Pregunta 3.** `message_queue_len` está en 0. ¿Qué significaría que creciera? ¿Qué proceso sería el culpable?

### Un servidor al que otros se conectan

Un nodo con nombre es alcanzable por la red. Usa **dos terminales** (misma máquina o dos PCs del laboratorio):

```sh
# Terminal A — el servidor (el que tiene el micro:bit)
erl -sname lab -setcookie mbit -pa patrones_mbit
1> lector_srv:start_link({cmd, "./emisor_sim.sh 300"}).

# Terminal B — otro nodo
erl -sname alumno -setcookie mbit
1> net_adm:ping('lab@NOMBRE_DE_TU_EQUIPO').      %% pong = se encontraron (epmd los presenta)
2> nodes().
3> gen_server:call({lector_srv, 'lab@NOMBRE_DE_TU_EQUIPO'}, ultimo).
4> rpc:call('lab@NOMBRE_DE_TU_EQUIPO', erlang, registered, []).
```

- `NOMBRE_DE_TU_EQUIPO` es lo que sale después de `@` en el prompt (`(lab@mi-pc)1>`) o `hostname -s`. **Entre comillas simples** si tiene guiones.
- Si dice `pang`: la *cookie* es distinta, o el firewall bloquea `epmd` (puerto 4369) y el rango de distribución. En Windows y en la VLAN del laboratorio revisa el firewall.
- `epmd -names` (en una terminal normal) lista los nodos registrados en tu máquina.

> **Pregunta 4.** El nodo B llamó a un proceso de A **sin saber en qué pid vive**: solo por nombre y nodo. ¿Qué tendrías que hacer en un lenguaje sin esto para exponer "el último valor del sensor" a otra computadora? Esa es la base de `flota40`: 40 nodos que hablan con una central.

---

## Entregable

Un `.md` con (máx. 2 páginas):

1. Captura de la shell del Paso 2 y tu respuesta a la Pregunta 1.
2. Salida del Paso 3 (los 8 comandos) y el experimento del patrón general puesto primero.
3. Salida de los comandos 4–10 del Paso 4 y respuestas a las Preguntas 2 y 3.
4. Captura de los dos nodos del último apartado (`pong` y la llamada remota) y la Pregunta 4.
5. Una línea con la versión de OTP y si usaste hardware o el emisor simulado.

## Ejercicios

**Nivel 1 (obligatorio).** Agrega el formato `L:n` (luz, 0–255) a `lector:leer/1` y `lector:clasificar/1` (alerta si `n < 20`). Añade sus pruebas a `lector_tests.erl`. Edita `main.py` para que imprima `L:` con `display.read_light_level()`.

**Nivel 2.** Agrega `{acc, ...}` → `caida_libre` si la magnitud es menor que 200 mg (guardas con `X*X + Y*Y + Z*Z`). ¿Por qué no hace falta calcular la raíz cuadrada?

**Nivel 3.** Haz que `lector_srv` envíe `ALERTA` al micro:bit (`mostrar/1`) cuando `clasificar/1` devuelva `alerta`. ¿Qué parte cambia: el módulo puro o el servidor? Justifícalo.

**Nivel 4 (reto).** Una línea puede llegar partida (`{noeol, _}`: más de 256 bytes sin `\n`). Hoy se descarta. Diseña cómo acumularías el fragmento en el estado del servidor. ¿Se vuelve más difícil de probar? ¿Por qué conviene dejar `lector` puro?

## Reglas

- No pegues código sin entenderlo: en la defensa te pedirán explicar una cláusula al azar.
- Toda función nueva lleva `-spec` y una prueba eunit.
- Usa OTP: el servidor es un `gen_server`; no uses `spawn` sin supervisión (la supervisión se agrega en `erlangmbit`).

## Conexión con industria

El pattern matching sobre binarios (*bit syntax*) se diseñó en Ericsson para decodificar protocolos de telecomunicaciones, y es la razón por la que Erlang se usa para analizar mensajes de red de forma compacta. Esta práctica modela, en pequeño, el problema de **leer datos de un dispositivo que no controlas** (ruido, formatos inválidos) sin que el servidor caiga. Este proyecto no es una fantasía académica: modela un tipo de problema que en la industria se resuelve con programación funcional y procesos supervisados.

## Siguiente

→ [`erlangmbit.md`](erlangmbit.md): el mismo micro:bit con supervisor, "let it crash" y 15 prácticas.
→ [`flota40/`](flota40/): 40 semis, una central de mando, dashboard y rúbrica por equipos.
