# Lección — De "preguntar cada segundo" a "avisar cuando ocurre": SSE con Erlang

> **Tema 2.1 · Programación Lógica y Funcional (ISC) · TecNM Campus Tijuana**
> Código: [`sse_eventos/`](sse_eventos/) · Duración sugerida: 1 sesión de 2 h
> Términos (SSE, WebSocket, Cowboy, `gen_server`…): [`sse_eventos/glosario.md`](sse_eventos/glosario.md)
> **Lección aparte:** no depende de [`flota40/`](flota40/); al final se conecta a su central como ejercicio.

---

## ¿Por qué esta lección?

El dashboard de `flota40` pregunta al servidor cada segundo: *"¿hay algo nuevo?"* (**polling**). En **Clarvi** (empresa
ficticia de transporte, ver [`erlangmbit.md`](erlangmbit.md)) un SOS del operador tarda, en promedio, medio segundo más de
lo necesario en verse, y el navegador hace una petición por segundo aunque no pase nada.

La alternativa es que el **servidor empuje** el evento cuando ocurre. Con **SSE** (*Server-Sent Events*) el navegador abre
**una** conexión HTTP que queda abierta y el servidor escribe en ella cada vez que hay un evento.

| | Polling | SSE | WebSocket |
|---|---|---|---|
| Quién inicia cada mensaje | el navegador | el servidor | cualquiera |
| Dirección | navegador → servidor → navegador | solo servidor → navegador | bidireccional |
| Reconexión | la haces tú | **automática** (`EventSource`) y reenvía lo perdido (`Last-Event-ID`) | la haces tú |
| Protocolo | HTTP normal | HTTP normal (`text/event-stream`) | handshake y protocolo propio |
| Cuándo | datos que cambian poco | **un panel de eventos** | chat, juegos, mando bidireccional |

Para un panel que *recibe* eventos, SSE es suficiente y más simple que WebSocket. (El mando de la central hacia los semis
va por UDP, no por el navegador.)

---

## Cómo está construida (todo OTP, sin dependencias)

```text
productor ──publicar(Tipo, Texto)──► sse_hub ──{sse, Evento}──► sse_conn (navegador 1)
(en flota40: la central)            (numera, guarda      pg:    sse_conn (navegador 2)
                                     los últimos 50)    grupo   …
```

| Módulo | Qué hace | Idea de programación funcional / OTP |
|---|---|---|
| `sse_hub` | `gen_server`: numera cada evento, lo guarda en un buffer de 50 y lo envía a todos los suscritos | Estado inmutable: cada evento produce un mapa nuevo |
| `sse_conn` | **Un proceso por navegador**: responde `/`, `/polling` o `/stream` y escribe los eventos | Modelo de actores: 1000 clientes = 1000 procesos ligeros; si uno falla, los demás no se enteran |
| `sse_conn_sup` | Supervisor `simple_one_for_one`, hijos `temporary` | Un cliente que se va **no se reinicia**; así debe ser |
| `sse_acceptor` | Acepta TCP y entrega cada socket a un `sse_conn` | Frontera con efectos aislada |
| `pg` | Grupos de procesos de OTP: el hub hace `pg:get_members(sse)` y envía a todos | Difusión sin que el hub conozca sockets |
| `productor` | `gen_server` que inventa eventos (1–3 s) | Sustituible por la central real |

**Dos detalles que hacen a SSE confiable** (y que casi todos olvidan):

1. **Reposición con `Last-Event-ID`.** Cada evento lleva `id: N`. Si el navegador se cae y vuelve, manda el último `id` que
   vio y `sse_conn` le reenvía lo que se perdió. Por eso el orden es: *primero* `pg:join`, *luego* reponer; y el bucle ignora
   los ids repetidos.
2. **Latido (`: ping`) cada 15 s.** Mantiene viva la conexión frente a firewalls y proxies que cierran conexiones ociosas.

---

## Paso 1 — Arráncalo

Requiere **OTP 27+** (usa el módulo `json`; verificado con OTP 29).

```sh
cd sse_eventos
erlc *.erl
erl
1> sse_demo:iniciar().          %% http://localhost:8081
```

Abre `http://localhost:8081`: la página muestra **dos paneles con el mismo flujo de eventos**: a la izquierda SSE, a la
derecha polling cada 1 s, con su latencia media y su número de peticiones HTTP.

Desde otra terminal, mira el flujo crudo:

```sh
curl -N localhost:8081/stream
retry: 2000

id: 1
event: ok
data: {"id":1,"t":1791592890662,"texto":"ruta en curso (semi 1)","tipo":"ok"}

id: 2
event: sos
data: {...}
```

Eso es todo el protocolo: líneas de texto separadas por una línea en blanco.

## Paso 2 — Compara con números

Medición del autor (30 s, una sola máquina, loopback, un navegador por modo):

| | Eventos vistos | Latencia media | Latencia máxima | Peticiones HTTP |
|---|---:|---:|---:|---:|
| **SSE** | 17 | **0.6 ms** | 1 ms | **1** (una conexión) |
| **Polling 1 s** | 16 | 433 ms | 884 ms | 30 |

Es **una corrida en loopback**: sirve para ver la diferencia de orden de magnitud, no como medida de red real. Repítela
en tu equipo y anota tus números. Observa por qué el polling promedia ~500 ms: el evento espera, en promedio, medio ciclo.
(Y además se pierden eventos si llegan más de 10 entre dos consultas: el endpoint `/polling` solo devuelve los últimos 10.)

## Paso 3 — Rómpelo a propósito

```sh
curl -N -H 'Last-Event-ID: 0' localhost:8081/stream     # recibe de golpe lo ya publicado (reposición)
curl -N -H 'Last-Event-ID: 20' localhost:8081/stream    # solo lo posterior al 20
```

En la shell de Erlang:

```erlang
2> supervisor:count_children(sse_conn_sup).               %% un hijo por navegador abierto
3> pg:get_members(sse).                                   %% los suscritos
4> sse_hub:publicar(sos, "prueba manual").                %% lo ven los navegadores AL INSTANTE
5> exit(hd(pg:get_members(sse)), kill).                   %% mata un cliente: ¿se enteran los demás?
```

Cierra una pestaña y vuelve a ejecutar 2: el proceso desaparece solo (el siguiente envío falla y `sse_conn` termina; es
`temporary`, no se reinicia). Reinicia el servidor con el navegador abierto: `EventSource` reconecta solo.

Prueba automática (sin navegador): `./verificar.sh` (stream, reposición, polling, HTML y que un cliente que se va no deja procesos).

---

## Entregable

Un `.md` (máx. 2 páginas) con: tus números del Paso 2, la salida de los comandos del Paso 3 y respuestas a:

1. ¿Por qué `sse_conn` hace `pg:join` **antes** de pedir `sse_hub:desde/1`? ¿Qué se pierde o se duplica si lo inviertes?
2. ¿Por qué los hijos de `sse_conn_sup` son `temporary` y no `permanent`?
3. El hub envía a cada cliente con `Pid ! {sse, Ev}`. Si un navegador está muy lento, ¿qué crece y dónde? ¿Es un riesgo con 40 semis y 100 navegadores?

## Ejercicios

**Nivel 1.** Filtra por tipo: `/stream?tipo=sos` solo recibe eventos `sos`. (Pista: `sse_conn` ya separa la ruta de la consulta.)

**Nivel 2.** Añade un contador de clientes conectados al encabezado de la página, publicado como evento `clientes` cada vez que cambia.

**Nivel 3 (integración con `flota40`).** Haz que la central publique en el hub cada `evento/3` (`sos`, `perdido`, `cmd_fallido`…)
y que `flota40/dashboard.html` use `EventSource` para la lista de eventos en lugar de consultar `/eventos.json`.
¿Qué módulo pasa a depender de qué? ¿Cómo evitas que la central (que ya valida y manda órdenes) se bloquee si el hub se cae?

**Nivel 4 (reto).** Limita el buzón de cada cliente: si un `sse_conn` acumula más de 1000 mensajes sin atender, ciérralo.
Justifica por qué es mejor que dejar crecer la memoria.

---

## Límites de esta implementación (honestos)

- **Solo servidor → navegador.** Para mandar órdenes desde el navegador necesitarías un `POST` aparte o WebSocket.
- **Sin autenticación ni TLS:** cualquiera en la red ve los eventos. En producción va detrás de un proxy con HTTPS.
- **Sin contrapresión:** un cliente lento acumula mensajes en su buzón (Nivel 4).
- **El servidor HTTP es de juguete** (`gen_tcp` + `http_bin`). Para producción se usa `cowboy`; la lección es *el modelo*, no el parser HTTP.
- **El buffer de reposición es de 50 eventos** y está en memoria: si el hub reinicia, el contador de ids vuelve a 1.
- Medición en loopback, una corrida.

## Conexión con industria

Empujar eventos a cientos de miles de clientes con un proceso ligero por conexión es el caso de uso clásico de la BEAM
(WhatsApp y Discord, verificados en el curso, usan Erlang/Elixir para conexiones concurrentes de larga duración). Phoenix
LiveView y Phoenix Channels aplican este mismo patrón de proceso por cliente. Este proyecto no es una fantasía académica:
modela un tipo de problema que en la industria se resuelve con procesos supervisados y mensajería asíncrona.
