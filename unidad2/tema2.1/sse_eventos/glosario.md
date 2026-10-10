# Glosario de tecnologías de Erlang — del lenguaje a la web en tiempo real

> Acompaña a [`sse_eventos.md`](../sse_eventos.md) y sirve para todo el tema 2.1. Cada término dice **qué es**, **para qué
> sirve** y **dónde aparece** en las prácticas (`patrones_mbit`, `erlangmbit`, `flota40`, `sse_eventos`).
> Los escenarios usan **Clarvi**, una empresa ficticia de transporte de carga.
>
> **Cómo leerlo:** las capas van de abajo hacia arriba: *runtime* → *lenguaje y OTP* → *herramientas* → *datos* → *red y web*
> → *otros lenguajes de la BEAM*. Si empiezas de cero, lee primero "Erlang/OTP".

## Índice por tema

| Capa | Términos |
|---|---|
| [Erlang/OTP](#erlangotp) | BEAM, OTP, proceso, mensaje y buzón, `gen_server`, `supervisor`, `pg`, ETS, `Port`, let it crash |
| [Lenguaje y herramientas](#lenguaje-y-herramientas) | sintaxis clave, `rebar3`, Hex, `erl`/`escript`, `observer`, `eunit`, Common Test, PropEr, Dialyzer, releases, `logger` |
| [Datos y almacenamiento](#datos-y-almacenamiento) | ETS, DETS, Mnesia, `persistent_term`, mapas y binarios |
| [Funciones populares](#funciones-populares-de-la-biblioteca-estándar) | `lists`, `maps`, conversión, binarios, errores, procesos, ETS; funciones de OTP; `io:format`; trampas frecuentes |
| [Red y protocolos](#red-y-protocolos) | HTTP, TCP, UDP, socket, keep-alive, JSON, TLS, proxy |
| [Comunicación web en tiempo real](#comunicación-web-en-tiempo-real) | polling, long polling, SSE, `EventSource`, WebSocket, pub/sub, MQTT |
| [Servidores y frameworks](#servidores-y-frameworks) | Cowboy, Ranch, Phoenix, Elixir, Grafana |
| [Interoperabilidad y otros lenguajes de la BEAM](#interoperabilidad-y-otros-lenguajes-de-la-beam) | Ports, NIF, Elixir, Gleam, LFE |
| [Ideas de diseño](#ideas-de-diseño) | contrapresión, latencia, idempotencia, reposición, función pura |
| [Versiones mínimas de OTP](#versiones-mínimas-de-otp) · [¿Cuál uso?](#cuál-uso) · [Mapa de las prácticas](#mapa-de-las-prácticas) | |

---

## Erlang/OTP

**BEAM.** La máquina virtual de Erlang (y Elixir). Ejecuta millones de procesos ligeros con planificación preventiva. Un "nodo
Erlang" es una instancia de la BEAM. *Aquí:* `erl`, `erlang:system_info/1`.

**OTP (Open Telecom Platform).** Conjunto de librerías y **patrones** (behaviours) para construir sistemas robustos:
`gen_server`, `supervisor`, `application`, etc. No es solo para telecomunicaciones.

**Proceso.** Unidad de ejecución de Erlang: ligero (unos KB), aislado (no comparte memoria) y con su propio buzón. **No** es un
hilo del sistema operativo. *Aquí:* un proceso por navegador conectado (`sse_conn`).

**Mensaje y buzón (mailbox).** Los procesos solo se comunican enviándose mensajes (`Pid ! Mensaje`); cada proceso tiene una cola
de entrada que atiende con `receive`. Si recibe más rápido de lo que procesa, el buzón crece (ver *contrapresión*).

**Modelo de actores.** Cada actor (proceso) tiene estado privado y solo cambia al procesar un mensaje. Evita bloqueos
(*locks*) y condiciones de carrera porque no hay memoria compartida.

**Behaviour.** Contrato de OTP: tú escribes las funciones de *callback* y OTP pone el esqueleto (el bucle, la gestión de errores).
`gen_server`, `supervisor` y `gen_statem` son behaviours.

**`gen_server`.** Behaviour para un **proceso servidor con estado** al que se le piden cosas. Callbacks principales:
`init/1` (estado inicial), `handle_call/3` (petición **síncrona**, responde), `handle_cast/2` (mensaje **asíncrono**, sin respuesta),
`handle_info/2` (cualquier otro mensaje: `Pid ! x`, temporizadores, sockets). `gen_server:call` espera la respuesta (5 s por
defecto). *Aquí:* `sse_hub` (estado = contador y buffer) y `productor`. *En Clarvi:* la central de `flota40` es un `gen_server`.

**`supervisor`.** Proceso cuyo único trabajo es **arrancar y reiniciar** a sus hijos según una estrategia: `one_for_one`
(reinicia solo al que murió), `one_for_all`, `rest_for_one`, `simple_one_for_one` (muchos hijos dinámicos del mismo tipo).
Acepta un límite de reinicios (`intensity` en `period` segundos); si se supera, el supervisor mismo se rinde y escala el error.

**Tipos de reinicio (`restart`).** `permanent` (siempre se reinicia), `transient` (solo si termina con error), `temporary`
(nunca). *Aquí:* los `sse_conn` son `temporary`: un cliente que se fue no debe resucitar.

**"Let it crash".** Filosofía: no llenes el código de defensas para cada fallo; deja que el proceso falle y que su supervisor lo
reinicie en un estado limpio. Aplica a fallas *recuperables*; los errores de entrada de datos sí se validan (`fix.erl`).

**`pg` (process groups).** Módulo de OTP (desde OTP 23) para agrupar procesos bajo un nombre y obtener sus miembros:
`pg:join(Grupo, Pid)`, `pg:get_members(Grupo)`. Si un miembro muere, sale del grupo. *Aquí:* grupo `sse`. Sustituyó al antiguo `pg2`.

**ETS.** Tablas en memoria de lectura concurrente (ver [Datos y almacenamiento](#datos-y-almacenamiento)).

**`Port` y `open_port`.** Mecanismo para hablar con un programa externo (aquí el puerto serial vía `cat`/`stty`). Los datos llegan
al proceso como mensajes. *En `erlangmbit`/`flota40`.*

**`gen_tcp` / `gen_udp`.** Módulos de OTP para sockets TCP y UDP. Con `{active, once}` el socket entrega **un** mensaje y espera
a que lo reactives: es una forma de contrapresión sencilla.

**Nodo distribuido, `epmd` y cookie.** Dos nodos con nombre (`-sname`) pueden llamarse entre sí si comparten la *cookie*;
`epmd` (puerto 4369) los presenta. *En `patrones_mbit`.*

**`application`.** Unidad de despliegue de OTP: agrupa módulos y un árbol de supervisión que arranca y se detiene como un bloque.

**`-spec` y Dialyzer.** `-spec` documenta los tipos de una función; Dialyzer es una herramienta que busca inconsistencias de
tipos antes de ejecutar. Erlang es de tipado dinámico, así que sin ellos los errores de tipo aparecen en ejecución.

---

## Lenguaje y herramientas

**Sintaxis que verás en todo el curso.** Las variables empiezan con **mayúscula** y se asignan **una sola vez**; los **átomos**
(`ok`, `sos`, `rodando`) son constantes con nombre en minúscula; las **tuplas** `{temp, 24}` agrupan datos de tamaño fijo; las
**listas** `[1,2,3]` son de tamaño variable; las **cláusulas** de una función se separan con `;` y la última termina en `.`.
Se escribe `modulo:funcion(args)` para llamar a otro módulo. *Aquí:* todo `lector.erl`.

**Pattern matching.** El `=` y los argumentos de función **comparan formas** y ligan variables en el mismo paso. Es la herramienta
central de Erlang para decidir qué hacer con un dato. *En `patrones_mbit`:* una cláusula por formato de línea del micro:bit.

**Guarda (`when`).** Condición adicional en una cláusula: `clasificar({temp, T}) when T >= 40 -> alerta;`. Solo admite
expresiones sin efectos secundarios.

**Binarios y *bit syntax*.** `<<"T:", Resto/binary>>` descompone o construye secuencias de bytes por patrón. Se diseñó para decodificar
protocolos de red. *Aquí:* `lector:leer/1`.

**`erl` y la shell.** Intérprete interactivo de la BEAM: `erl`, `erl -sname nombre -setcookie c`, `halt().` para salir.
`erlc modulo.erl` compila a `modulo.beam`.

**`escript`.** Ejecuta un script Erlang sin compilarlo a mano; útil para herramientas de línea de comandos.

**`rebar3`.** Herramienta oficial de la comunidad para crear proyectos, bajar dependencias, compilar, probar y generar
*releases*: `rebar3 new app miapp`, `rebar3 compile`, `rebar3 eunit`, `rebar3 shell`. Es lo que se usaría para añadir Cowboy.

**Hex.** Repositorio de paquetes de Erlang y Elixir (como npm o PyPI). `rebar3` descarga de ahí.

**`observer`.** Herramienta gráfica (`observer:start().`) para ver procesos, árbol de supervisión, uso de memoria, tablas ETS y
carga de los *schedulers* de un nodo. Se puede conectar a un nodo remoto. *Aquí:* Paso 4 de `patrones_mbit`.

**`eunit`.** Pruebas unitarias incluidas en OTP: funciones `*_test()` o `*_test_()` y macros `?assertEqual`. *Aquí:*
`lector_tests.erl`, `semi_modelo_tests.erl`, `fix_tests.erl`.

**Common Test.** Marco de pruebas de OTP para pruebas de integración y de sistema (varios nodos, ciclos de vida). Es lo que
automatizaría `evaluacion:correr/1` de `flota40`, hoy manual.

**PropEr / QuickCheck.** Pruebas basadas en **propiedades**: describes una regla ("para toda secuencia de eventos, la posición
queda acotada") y la herramienta genera casos al azar y *reduce* (shrinking) el que falle. *Aquí:* `semi_modelo_tests` hace una
versión manual sin librería.

**`-spec` y Dialyzer.** `-spec` documenta los tipos de una función; Dialyzer busca inconsistencias de tipos antes de ejecutar.
Erlang es de tipado dinámico, así que sin ellos los errores de tipo aparecen en ejecución (`function_clause`, `badarg`).

**Release (`relx`, `rebar3 release`).** Paquete autocontenido con la BEAM, tus aplicaciones y un script de arranque, listo para
desplegar sin instalar Erlang aparte. Permite también **actualización de código en caliente**.

**Carga de código en caliente (*hot code upgrade*).** Cambiar el código de un módulo mientras el sistema corre; los procesos
adoptan la versión nueva en su siguiente llamada completa. Es una de las razones históricas de OTP en telecomunicaciones.

**`logger`.** Sistema de registro estándar de OTP (desde OTP 21): niveles (`info`, `warning`, `error`), formateadores y
manejadores. Reemplaza el uso de `io:format` para diagnóstico en producción.

---

## Datos y almacenamiento

**Mapas (`#{}`).** Diccionarios inmutables clave-valor (desde OTP 17). Actualizar crea un mapa nuevo: `S#{n := N + 1}`.
*Aquí:* el estado de `sse_hub` y de `lector_srv`.

**ETS (Erlang Term Storage).** Tablas en memoria, mutables y de lectura concurrente, fuera del heap de los procesos. Tipos:
`set`, `ordered_set`, `bag`, `duplicate_bag`. Mueren con el proceso dueño. *En `flota40`:* la central guarda ahí las posiciones
y el dashboard las lee sin pasar por ella.

**DETS.** Versión en disco de ETS; limitada de tamaño (2 GB) y sin ser transaccional. Para un prototipo, no como base de datos.

**Mnesia.** Base de datos distribuida integrada en OTP: tablas en RAM o disco, transacciones y replicación entre nodos. Es la
opción cuando ETS no basta porque necesitas persistencia o varios nodos. *No se usa en el curso* (queda como mejora: la bitácora
de `flota40` se pierde si la central reinicia).

**`persistent_term`.** Almacén global para datos que **casi nunca cambian** y se leen muchísimo (lectura sin copia). Actualizar es
caro; sirve para configuración.

---

## Funciones populares de la biblioteca estándar

> **Todas las llamadas de las tablas están verificadas**: [`glosario_verif/`](glosario_verif/) las ejecuta y compara cada
> resultado (66 casos, OTP 29). Pruébalas en `erl`; para varias líneas usa `begin … end` como en la tabla.

### Listas (`lists`)

| Llamada | Resultado | Qué hace |
|---|---|---|
| `lists:map(fun(X) -> X * 2 end, [1,2,3])` | `[2,4,6]` | Aplica una función a cada elemento |
| `lists:filter(fun(X) -> X rem 2 =:= 0 end, [1,2,3,4])` | `[2,4]` | Conserva los que cumplen la condición |
| `lists:foldl(fun(X, Acc) -> X + Acc end, 0, [1,2,3])` | `6` | Reduce la lista a un valor (recursión de cola) |
| `lists:seq(1, 5)` | `[1,2,3,4,5]` | Rango de enteros |
| `lists:sort([3,1,2])` | `[1,2,3]` | Ordena (el orden de términos de Erlang) |
| `lists:reverse([1,2,3])` | `[3,2,1]` | Invierte |
| `lists:member(2, [1,2,3])` | `true` | ¿Está el elemento? |
| `lists:nth(2, [a,b,c])` | `b` | Elemento en la posición N (empieza en 1; falla si no existe) |
| `lists:sum([1,2,3])` | `6` | Suma |
| `lists:zip([1,2], [a,b])` | `[{1,a},{2,b}]` | Empareja dos listas |
| `lists:keyfind(b, 1, [{a,1},{b,2}])` | `{b,2}` | Busca una tupla por su N-ésimo elemento (`false` si no hay) |
| `lists:flatten([[1],[2,[3]]])` | `[1,2,3]` | Aplana listas anidadas |
| `lists:sublist([1,2,3,4], 2)` | `[1,2]` | Los primeros N (no falla si hay menos) |
| `lists:partition(fun(X) -> X > 2 end, [1,2,3,4])` | `{[3,4],[1,2]}` | Separa en `{cumplen, no cumplen}` |
| `[X * X \|\| X <- [1,2,3], X > 1]` | `[4,9]` | Lista por comprensión: generador + filtro |

### Mapas (`maps`)

| Llamada | Resultado | Qué hace |
|---|---|---|
| `maps:get(a, #{a => 1})` | `1` | Valor de una clave (falla con `badkey` si no existe) |
| `maps:get(b, #{a => 1}, 0)` | `0` | Valor con un valor por omisión |
| `maps:find(a, #{a => 1})` | `{ok,1}` | `{ok, V}` o `error`: la forma segura |
| `maps:put(b, 2, #{a => 1})` | `#{a => 1, b => 2}` | Devuelve un mapa NUEVO (el original no cambia) |
| `maps:remove(a, #{a => 1, b => 2})` | `#{b => 2}` | Quita una clave |
| `lists:sort(maps:keys(#{a => 1, b => 2}))` | `[a,b]` | Claves del mapa; su orden NO está garantizado, por eso se ordenan |
| `maps:update_with(a, fun(V) -> V + 1 end, 1, #{a => 1})` | `#{a => 2}` | Actualiza con una función; si no existe, usa el valor inicial |
| `(#{a => 1})#{a := 5}` | `#{a => 5}` | Sintaxis de actualización (`:=` exige que la clave exista) |

### Tuplas y números (BIF)

| Llamada | Resultado | Qué hace |
|---|---|---|
| `element(2, {a,b,c})` | `b` | Elemento N de una tupla |
| `setelement(2, {a,b,c}, x)` | `{a,x,c}` | Tupla nueva con un elemento cambiado |
| `tuple_size({a,b,c})` | `3` | Tamaño de la tupla |
| `length([a,b,c])` | `3` | Longitud de la lista (recorre toda la lista: O(n)) |
| `round(2.5)` | `3` | Redondea al entero más cercano |
| `trunc(2.9)` | `2` | Parte entera |
| `7 rem 3` | `1` | Resto (`div` = división entera) |
| `max(1, 2)` | `2` | Mayor de dos términos |

### Conversión

| Llamada | Resultado | Qué hace |
|---|---|---|
| `integer_to_list(42)` | `"42"` | Entero → lista de caracteres |
| `list_to_integer("42")` | `42` | Cadena → entero (`badarg` si no es número) |
| `binary_to_integer(<<"42">>)` | `42` | Binario → entero |
| `atom_to_list(ok)` | `"ok"` | Átomo → cadena |
| `binary_to_term(term_to_binary({a,1}))` | `{a,1}` | Serializa y deserializa cualquier término |
| `[104,111,108,97] =:= "hola"` | `true` | Una cadena es una lista de enteros (códigos de carácter) |

### Binarios y cadenas

| Llamada | Resultado | Qué hace |
|---|---|---|
| `binary:split(<<"a,b,c">>, <<",">>, [global])` | `[<<"a">>,<<"b">>,<<"c">>]` | Parte un binario por un separador |
| `binary:replace(<<"a-b">>, <<"-">>, <<"+">>)` | `<<"a+b">>` | Reemplaza dentro de un binario (opera en bytes) |
| `byte_size(<<"hola">>)` | `4` | Tamaño en bytes |
| `iolist_to_binary(["a", <<"b">>, $c])` | `<<"abc">>` | Junta una lista de E/S en un binario |
| `string:uppercase("hola")` | `"HOLA"` | Mayúsculas |
| `string:trim("  x ")` | `"x"` | Quita espacios (¡revienta con bytes no UTF-8!) |
| `string:split("a b c", " ", all)` | `["a","b","c"]` | Parte una cadena |
| `lists:flatten(io_lib:format("~b-~s", [7, "x"]))` | `"7-x"` | Da formato a texto SIN imprimir |
| `lists:flatten(io_lib:format("~.2f", [3.14159]))` | `"3.14"` | `~.2f`: decimal con 2 cifras |

### Errores

| Llamada | Resultado | Qué hace |
|---|---|---|
| `try 1 / 0 catch error:badarith -> mal end` | `mal` | `try … catch Clase:Patrón`: atrapa un error concreto |
| `try throw(salida) catch throw:salida -> ok end` | `ok` | `throw` para saltos no locales (no para errores) |
| `case lists:keyfind(z, 1, [{a,1}]) of false -> no; {_, V} -> V end` | `no` | Maneja el “no encontrado” con pattern matching |

### Procesos y tiempo

| Llamada | Resultado | Qué hace |
|---|---|---|
| `begin P = spawn(fun() -> receive {De, X} -> De ! {ok, X * 2} end end), P ! {self(), 21}, receive {ok, R} -> R after 1000 -> timeout end end` | `42` | `spawn` crea el proceso, `!` envía, `receive … after` espera con tiempo límite |
| `is_pid(self())` | `true` | `self()`: el pid del proceso actual |
| `begin erlang:send_after(10, self(), hola), receive hola -> ok after 500 -> timeout end end` | `ok` | Envía un mensaje a un proceso dentro de N ms (temporizador sin dormir) |
| `begin register(demo, self()), whereis(demo) =:= self() end` | `true` | Nombre local para un proceso |
| `is_integer(erlang:system_time(millisecond))` | `true` | Hora de pared; usa `monotonic_time` para medir duraciones |
| `ok = timer:sleep(1)` | `ok` | Duerme el proceso actual N ms |

### ETS

| Llamada | Resultado | Qué hace |
|---|---|---|
| `begin T = ets:new(t, [set]), ets:insert(T, {a,1}), ets:lookup(T, a) end` | `[{a,1}]` | Tabla en memoria: `insert`/`lookup` |
| `begin T = ets:new(t, [set]), ets:insert(T, {c,0}), ets:update_counter(T, c, 5) end` | `5` | Incremento atómico de un contador |
| `begin T = ets:new(t, [set]), ets:insert(T, [{a,1},{b,2}]), lists:sort(ets:tab2list(T)) end` | `[{a,1},{b,2}]` | Vuelca la tabla a una lista |

### Otras muy usadas

| Llamada | Resultado | Qué hace |
|---|---|---|
| `rand:uniform(6) =< 6` | `true` | Entero al azar en 1..N (el azar es un efecto) |
| `byte_size(crypto:hash(sha256, <<"a">>))` | `32` | Resumen SHA-256 (32 bytes); base de un HMAC |
| `is_binary(crypto:mac(hmac, sha256, <<"clave">>, <<"mensaje">>))` | `true` | HMAC para firmar paquetes (idea para `flota40`) |
| `element(1, timer:tc(fun() -> ok end)) >= 0` | `true` | `timer:tc/1`: microsegundos que tarda una función |
| `proplists:get_value(a, [{a,1},{b,2}])` | `1` | Lista de propiedades (opciones de `open_port`, `gen_tcp`…) |
| `is_integer(erlang:unique_integer([monotonic]))` | `true` | Entero único (se usó para ordenar los eventos de `flota40`) |
| `1 == 1.0` | `true` | `==` compara valor numérico |
| `1 =:= 1.0` | `false` | `=:=` compara valor Y tipo (es la que casi siempre quieres) |

### Funciones de OTP que ya usaste (sin resultado fijo)

| Función | Para qué | Dónde |
|---|---|---|
| `gen_server:start_link({local, Nombre}, Mod, Arg, [])` | Arranca un servidor enlazado a su supervisor | `sse_hub`, `central` |
| `gen_server:call(Srv, Msg)` / `cast(Srv, Msg)` | Petición síncrona (espera respuesta, 5 s por omisión) / asíncrona | `lector_srv:ultimo/0` |
| `supervisor:start_child(Sup, Args)` | Agrega un hijo dinámico | `sse_acceptor` |
| `supervisor:count_children(Sup)` / `which_children/1` | Inspecciona el árbol | Paso 3 de `sse_eventos` |
| `sys:get_status(Pid)` / `sys:get_state(Pid)` | Mira el estado interno de un proceso OTP | `patrones_mbit` |
| `process_info(Pid, [message_queue_len, memory])` | Salud de un proceso (¿crece su buzón?) | `patrones_mbit` |
| `link(Pid)` / `erlang:monitor(process, Pid)` | Enterarse de que otro proceso murió (link: muere contigo; monitor: te avisa) | supervisores |
| `exit(Pid, kill)` | Mata un proceso (prueba de "let it crash") | `flota:matar/1` |
| `open_port({spawn_executable, Ruta}, Opciones)` | Habla con un programa externo | `lector_srv`, `semi_serial` |
| `gen_tcp:listen/accept/send/recv` · `gen_udp:open/send` | Sockets TCP / UDP | `sse_acceptor`, `semi`, `central` |
| `application:get_env(App, Clave)` / `set_env/3` | Configuración de una aplicación | `flota_cfg` |
| `os:getenv("FLOTA_HOST")` | Variable de entorno (devuelve `false` si no existe) | `flota_cfg` |
| `pg:join/2` · `pg:get_members/1` | Grupos de procesos | `sse_hub` |
| `net_adm:ping(Nodo)` · `rpc:call(Nodo, M, F, A)` | Conectar y llamar a otro nodo | `evaluacion.erl` |
| `erlang:system_info(schedulers_online)` · `erlang:memory(total)` | Mira la BEAM por dentro | `flota:vm/0` |

### Directivas de `io:format` / `io_lib:format`

| Directiva | Imprime | Ejemplo |
|---|---|---|
| `~p` | Término con formato legible (puede partir líneas) | `io:format("~p~n", [#{a => 1}])` |
| `~w` | Término crudo, una línea | `io:format("~w~n", [{ok, 1}])` |
| `~s` | Cadena o binario como texto | `io:format("~s~n", ["hola"])` |
| `~ts` | Texto Unicode (acentos) | `io:format("~ts~n", ["canción"])` |
| `~b` | Entero | `io:format("~b~n", [42])` |
| `~.2f` | Decimal con 2 cifras | `io:format("~.2f~n", [3.14159])` |
| `~n` | Salto de línea | |

### Trampas frecuentes (y cómo se evitan)

| Trampa | Por qué pasa | Qué hacer |
|---|---|---|
| `hd([])`, `tl([])`, `lists:nth(5, [a])` fallan | Funciones **parciales** | Pattern matching: `[H \| T]`, o `lists:sublist/2` |
| `list_to_atom(Entrada)` con datos externos | Los átomos **no se recolectan** y hay un límite (≈ 1 millón por omisión): una entrada hostil puede tumbar el nodo | `binary_to_existing_atom/1` (como `fix:parsear/1`) o validar contra una lista |
| `string:trim/1` con bytes no UTF-8 | `string` asume Unicode | Operar sobre binarios con `binary:replace/4` (como `lector.erl`) |
| El orden de `maps:keys/1` | Los mapas no garantizan orden | `lists:sort/1` si importa el orden |
| `1 == 1.0` es `true` | `==` solo compara valor | `=:=` para valor y tipo |
| `gen_server:call` se cae tras 5 s | Timeout por omisión | Pasar un timeout explícito o rediseñar con `cast` |
| `io_lib:format/2` “no imprime” | Devuelve una lista profunda | `lists:flatten/1` o `io:format/2` |
| `length/1` en un bucle | Recorre toda la lista cada vez: O(n) | Llevar el contador como acumulador (recursión de cola) |
| `L1 ++ L2` repetido | Copia `L1` completa cada vez | Construir al revés con `[X \| Acc]` y `lists:reverse/1` |

---

## Red y protocolos

**HTTP.** Protocolo de petición/respuesta de la web. Cada respuesta normal termina; SSE es especial porque **no termina** y el
servidor sigue escribiendo.

**TCP.** Transporte confiable y ordenado: entrega los bytes sin pérdida o avisa del error. HTTP, SSE y WebSocket van sobre TCP.
*Aquí:* `gen_tcp`.

**UDP.** Transporte sin conexión ni garantías (sin orden, sin reintentos). Es rápido y simple; la confiabilidad, si hace falta,
la pones tú. *En `flota40`:* la telemetría y las órdenes viajan por UDP, y la central agrega `seq`, ACK y reintentos.

**Socket.** Extremo de una comunicación de red (IP + puerto + protocolo). *Aquí:* `gen_tcp:listen/accept`, `gen_udp:open`.

**Keep-alive.** Mantener abierta la conexión TCP después de responder. SSE depende de ella (`Connection: keep-alive`).

**JSON.** Formato de texto para datos (`{"id":1,"tipo":"sos"}`). Es lo que va dentro del `data:` de cada evento. *Aquí:* el módulo
`json` de OTP 27+ (`json:encode/1`, `json:decode/1`).

**TLS / HTTPS.** Cifrado de la conexión. Esta lección **no lo usa**: cualquiera en la red ve los eventos. En producción se
pone detrás de un proxy con HTTPS.

**Proxy (inverso).** Servidor intermedio (p. ej. nginx) entre el navegador y tu aplicación. Para SSE hay que desactivar su
*buffering*, o los eventos llegan en bloques en lugar de uno por uno.

**Loopback.** La interfaz de red de tu propia máquina (`127.0.0.1` / `localhost`). Las mediciones de esta lección son en
loopback: muestran el orden de magnitud, no la latencia de una red real.

---

## Comunicación web en tiempo real

**Polling (sondeo).** El navegador pregunta al servidor cada cierto tiempo: *"¿hay algo nuevo?"*. Es simple, pero genera una
petición HTTP por intervalo aunque no pase nada, y el evento espera en promedio medio intervalo antes de verse.
*Aquí:* el panel derecho de `index.html` y la ruta `/polling`. *En Clarvi:* un SOS puede tardar hasta 1 s extra en pantalla.

**Long polling.** Variante del polling: el servidor **retiene** la petición hasta que haya un evento y entonces responde; el
navegador abre otra enseguida. Reduce peticiones vacías, pero cada evento cuesta una petición completa. Es el "plan B" cuando
no se puede usar SSE ni WebSocket. *No se usa en esta lección.*

**SSE (Server-Sent Events).** Estándar web (parte de HTML) para que el **servidor empuje** eventos al navegador por una sola
conexión HTTP que queda abierta (`Content-Type: text/event-stream`). Es **unidireccional** (servidor → navegador), solo texto
UTF-8, y trae **reconexión automática** y reposición con `Last-Event-ID`. Con **HTTP/1.1** el navegador limita las conexiones abiertas por dominio (típicamente 6), así que no abras muchas pestañas
con el mismo origen; con **HTTP/2** el límite es mucho mayor porque las conexiones se multiplexan. *Aquí:* ruta `/stream` y panel izquierdo.

**`EventSource`.** API de JavaScript que implementa el lado cliente de SSE:
`const es = new EventSource('/stream'); es.addEventListener('sos', e => …)`. Reconecta sola y envía `Last-Event-ID`. *Aquí:* `index.html`.

**Formato de un evento SSE.** Líneas de texto; un evento termina con una línea en blanco:

```text
id: 7             ← identificador (para Last-Event-ID)
event: sos        ← tipo; el cliente escucha por tipo
data: {...}       ← contenido (puede ser JSON)
                  ← línea en blanco = fin del evento
: ping            ← línea que empieza con ":" es un comentario (latido)
retry: 2000       ← ms que el navegador espera antes de reconectar
```

**`Last-Event-ID`.** Cabecera que el navegador manda al reconectar con el último `id:` que vio. El servidor puede reenviar lo
que se perdió. *Aquí:* `sse_hub:desde/1` y `sse_conn:responder/3`.

**Latido (heartbeat / `: ping`).** Mensaje periódico sin contenido que mantiene viva una conexión ociosa frente a firewalls y
proxies que cierran lo inactivo. *Aquí:* cada 15 s en `sse_conn:bucle/2`.

**WebSocket.** Protocolo (RFC 6455) para una conexión **bidireccional** y de baja latencia sobre una sola conexión TCP. Empieza
como una petición HTTP con `Upgrade: websocket` y luego deja de ser HTTP. Se usa en chats, juegos o paneles que también
**envían** órdenes. No reconecta solo: lo programas tú. Esquemas `ws://` y `wss://` (con TLS). *No se usa en esta lección*,
pero es la alternativa si el navegador debe mandar órdenes a la central.

**Pub/Sub (publicación/suscripción).** Patrón donde los productores **publican** mensajes sin saber quién los recibe y los
interesados se **suscriben**. *Aquí:* `sse_hub:publicar/2` publica y cada `sse_conn` se suscribe con `pg:join/2`.

**MQTT.** Protocolo ligero de pub/sub muy usado en IoT (sensores, microcontroladores). Un **broker** reparte los mensajes por
*temas*. Es la opción habitual cuando los dispositivos (no los navegadores) publican datos. *No se usa aquí.*

---

## Servidores y frameworks

**Cowboy.** Servidor HTTP para Erlang/OTP, pequeño y rápido, que soporta HTTP/1.1, HTTP/2 y **WebSocket**. Cada conexión es un
proceso Erlang. Se usa para construir APIs y servidores en tiempo real. *Esta lección usa `gen_tcp` a mano para ver el modelo;
en producción se usa Cowboy* (maneja el parser HTTP, límites, TLS, WebSocket y SSE con *streaming* de respuestas).

**Ranch.** Librería que gestiona un *pool de procesos aceptadores* de conexiones TCP/TLS. Cowboy se apoya en ella. Es el
equivalente robusto de nuestro `sse_acceptor`.

**Phoenix.** Framework web de **Elixir** (corre en la BEAM). Incluye *Channels* (mensajería sobre WebSocket) y **LiveView**
(interfaces interactivas renderizadas desde el servidor, sin escribir JavaScript a mano). Históricamente usó Cowboy; las
versiones recientes ofrecen Bandit como servidor por defecto en proyectos nuevos.

**Elixir.** Lenguaje funcional que compila a la BEAM y reutiliza OTP; la sintaxis es distinta, el modelo de procesos es el mismo.

**rebar3.** Herramienta de construcción y dependencias de Erlang. Con ella se añade Cowboy a un proyecto (`{deps, [cowboy]}`).

**Grafana.** Plataforma de paneles y gráficas históricas. Útil para métricas en el tiempo; menos cómoda para mapas y para
mandar órdenes. *Mencionada como alternativa de dashboard.*

---

## Interoperabilidad y otros lenguajes de la BEAM

**NIF (Native Implemented Function).** Función escrita en C/Rust que se carga como si fuera una función Erlang. Es muy rápida
pero **un fallo en la NIF tira todo el nodo**: rompe el aislamiento que da Erlang. Úsala solo si mides que lo necesitas.

**Port vs. NIF.** Un *Port* corre el programa externo en **otro proceso del sistema**: si falla, la BEAM sigue. Por eso
`erlangmbit` y `flota40` usan Ports para el serial.

**Elixir.** Lenguaje funcional que compila a la BEAM y reutiliza OTP; sintaxis distinta (pipes, macros), mismo modelo de procesos.
Un módulo Erlang se llama desde Elixir como `:lector.leer(...)`.

**Gleam.** Lenguaje funcional **con tipos estáticos** que compila a la BEAM (y a JavaScript). Atrapa en compilación los errores de
tipo que Erlang descubre en ejecución, a cambio de menos flexibilidad.

**LFE (Lisp Flavoured Erlang).** Un Lisp que compila a la BEAM: Erlang con sintaxis de paréntesis y macros.

---

## Ideas de diseño

**Contrapresión (backpressure).** Mecanismo para que un productor rápido no ahogue a un consumidor lento. Sin él, el buzón del
consumidor crece sin límite y consume memoria. *Aquí:* un navegador lento acumula mensajes en su `sse_conn` (ejercicio nivel 4).

**Latencia.** Tiempo entre que ocurre un evento y alguien lo ve. *Medición de la lección:* SSE ≈ 0.6 ms, polling ≈ 433 ms
(loopback, una corrida).

**Idempotencia / deduplicación.** Poder recibir el mismo mensaje dos veces sin efecto adicional. *Aquí:* tras reponer eventos,
el bucle ignora los `id` ya enviados (`Id > Ultimo`).

**Reposición (replay).** Reenviar a un cliente lo que se perdió mientras estuvo desconectado, usando un identificador de
secuencia. *Aquí:* buffer de 50 eventos + `Last-Event-ID`. Limitación: vive en memoria.

**Función pura / núcleo puro.** Función sin efectos secundarios ni azar: mismas entradas, mismo resultado; se prueba sin
infraestructura. *En `flota40`:* `semi_modelo` y `fix`.

---

## Versiones mínimas de OTP

| Característica | OTP | Dónde se usa |
|---|---|---|
| Mapas (`#{}`) | 17 | `sse_hub`, `lector_srv` |
| `gen_statem` | 19 | (mención) |
| `logger` | 21 | (mención) |
| `pg` (reemplaza a `pg2`, que se retiró en OTP 24) | 23 | `sse_hub` |
| JIT (BeamAsm) en x86-64 | 24 | rendimiento general |
| módulo `json` | 27 | `sse_hub`, `sse_conn`, `dashboard.erl` |

Esta lección se verificó con **OTP 29**. Con OTP 25 y 26 las prácticas `patrones_mbit` y `erlangmbit` funcionan, pero
`sse_eventos` y el dashboard de `flota40` necesitan `json` (OTP 27+).

---

## ¿Cuál uso?

| Necesito… | Tecnología | Por qué |
|---|---|---|
| Un panel que **recibe** eventos del servidor | **SSE** | Simple, reconecta solo, reposición incluida |
| Que el navegador **mande y reciba** en tiempo real | **WebSocket** | Bidireccional |
| Datos que casi no cambian | **Polling** | No justifica una conexión abierta |
| Sensores/dispositivos que publican | **MQTT** (o UDP + tu protocolo, como `flota40`) | Pensado para dispositivos |
| Muchos clientes concurrentes, fallas aisladas | **Procesos + supervisor (OTP)** | Un proceso por cliente |
| Servidor HTTP/WebSocket de producción en Erlang | **Cowboy** | No reescribas el parser HTTP |
| Interfaz interactiva sin escribir JS | **Phoenix LiveView** (Elixir) | Misma BEAM |

## Mapa de las prácticas

| Archivo | Términos del glosario que ilustra |
|---|---|
| `sse_hub.erl` | `gen_server`, pub/sub, `pg`, reposición, `Last-Event-ID` |
| `sse_conn.erl` | Proceso por cliente, SSE, latido, `{active, once}`, deduplicación |
| `sse_conn_sup.erl` | `supervisor`, `simple_one_for_one`, `temporary` |
| `sse_acceptor.erl` | `gen_tcp`, equivalente simplificado de Ranch |
| `productor.erl` | `gen_server`, mensajes y temporizadores |
| `index.html` | `EventSource`, polling, latencia |
| `patrones_mbit/lector.erl` | Pattern matching, guardas, binarios, `-spec`, `eunit` |
| `patrones_mbit/lector_srv.erl` | `gen_server`, `Port`, nodo registrado, `observer` |
| `erlangmbit/microbit_sup.erl` | `supervisor`, reinicios, "let it crash" |
| `flota40/central.erl` | `gen_server`, ETS, UDP, ACK y reintentos |
| `flota40/fix.erl`, `semi_modelo.erl` | Núcleo puro, `eunit` |
| `flota40/nodos.sh` + `evaluacion.erl` | Nodos distribuidos, `rpc`, cookie |
