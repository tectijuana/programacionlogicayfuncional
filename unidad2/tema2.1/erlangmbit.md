# Práctica — Erlang en acción con micro:bit y sensores reales

> **Tema 2.1 · Programación Lógica y Funcional (ISC) · TecNM Campus Tijuana**
> Código de esta práctica: [`erlangmbit/`](erlangmbit/)

---

## ¿Por qué esta práctica?

Hasta ahora has usado Erlang con datos que tú mismo escribes: una lista, un RFC,
un número. Esos datos no cambian, no llegan tarde y no se desconectan.

El mundo real no es así. Un sensor manda lecturas cada 200 ms, a veces manda
basura, y a veces alguien jala el cable. Para ese tipo de problemas se diseñó
Erlang: en Ericsson, en los años 80, para centrales telefónicas que **no podían
apagarse** aunque una parte fallara.

En esta práctica conectas un **micro:bit** (con MicroPython) a tu computadora por
USB. El micro:bit hace de **sensor**; Erlang hace de **centro de monitoreo**:

```text
micro:bit (MicroPython)                  PC (Erlang/OTP)
acelerómetro + temperatura  ──USB──►  gen_server: interpreta, cuenta, alerta
matriz de LEDs              ◄──USB──  microbit_srv:mostrar("SISMO")
                                      supervisor: si se cae el cable, reinicia
```

Vas a ver con tus propios ojos tres ideas del curso:

| Idea | Dónde la verás |
|---|---|
| **Inmutabilidad** | El estado (`lecturas`, `alertas`) nunca se modifica: cada mensaje produce un mapa nuevo |
| **Pattern matching** | Una línea válida, una línea basura y un cable desconectado son tres cláusulas distintas |
| **"Let it crash"** | Desconectas el cable a propósito y el supervisor levanta el proceso solo |

> **Antes de empezar:** repasa los niveles 1 y 2 de
> [`TUTORIAL_ERLANG.md`](TUTORIAL_ERLANG.md) (pattern matching, `gen_server`)
> y la sección 3.1 (supervisor).

---

## Material

| Necesitas | Notas |
|---|---|
| micro:bit V2 (V1 también funciona) y cable USB **de datos** | Muchos cables solo cargan; si no aparece el puerto, cambia de cable |
| Erlang/OTP 25 o superior | [`instalacion/03_erlang.md`](../../instalacion/03_erlang.md) |
| Editor web de MicroPython | [python.microbit.org](https://python.microbit.org) |
| **¿No tienes micro:bit?** | Usa el simulador: `bash erlangmbit/simular.sh` |

---

## Paso 1 — Programa el micro:bit

Abre [python.microbit.org](https://python.microbit.org), pega
[`erlangmbit/main.py`](erlangmbit/main.py) y envíalo a la tarjeta.

```python
# micro:bit (MicroPython) — envía "x,y,z,temp" por USB serial cada 200 ms
# y muestra en los LEDs el texto que llegue desde la PC (una línea por mensaje).
from microbit import *

uart.init(baudrate=115200)
buf = b""

while True:
    x, y, z = accelerometer.get_values()
    print("{},{},{},{}".format(x, y, z, temperature()))

    if uart.any():
        buf += uart.read()
        if b"\n" in buf:
            linea, buf = buf.split(b"\n", 1)
            display.scroll(str(linea, "utf-8"), wait=False)

    sleep(200)
```

Cada línea que envía tiene la forma `x,y,z,temp`: aceleración en los tres ejes
(en *mili-g*) y temperatura en °C. En reposo, la magnitud
$\sqrt{x^2+y^2+z^2}$ es de unos **1024 mg** (la gravedad). Si agitas la tarjeta,
sube.

**Verifica** antes de seguir: en el editor web, abre la consola serial
(*Show serial*) y comprueba que salen líneas como `-12,40,1028,24`.

---

## Paso 2 — El centro de monitoreo en Erlang

Lee [`erlangmbit/microbit_srv.erl`](erlangmbit/microbit_srv.erl) con calma. Fíjate en
estas tres partes:

**a) Tres situaciones, tres cláusulas** (pattern matching, no `if`):

```erlang
handle_info({Port, {data, {eol, Linea}}}, S = #{port := Port}) ->
    {noreply, procesar(parsear(Linea), S)};          %% llegó una línea
handle_info({Port, {data, {noeol, _}}}, S = #{port := Port}) ->
    {noreply, S};                                     %% línea incompleta: se ignora
handle_info({Port, {exit_status, Codigo}}, S = #{port := Port}) ->
    {stop, {serial_cerrado, Codigo}, S}.              %% cable desconectado: let it crash
```

**b) La basura se descarta sin romper nada**: `parsear/1` regresa
`{ok, X, Y, Z, T}` o `descartar`, y `procesar/2` tiene una cláusula para cada caso.

**c) El estado es inmutable**: `S#{lecturas := N + 1}` no modifica `S`; crea un mapa
nuevo que el `gen_server` usa en el siguiente mensaje.

El supervisor ([`erlangmbit/microbit_sup.erl`](erlangmbit/microbit_sup.erl)) usa
`one_for_one` con un máximo de **5 reinicios en 30 segundos**.

---

## Paso 3 — Conéctalo y ponlo a prueba

```bash
ls /dev/cu.usbmodem*        # macOS     → /dev/cu.usbmodem1102 (por ejemplo)
ls /dev/ttyACM*             # Linux     → /dev/ttyACM0

cd erlangmbit
erlc microbit_srv.erl microbit_sup.erl
erl
```

```erlang
1> microbit_sup:start_link("/dev/cu.usbmodem1102").
2> microbit_srv:stats().
#{alertas => 0, lecturas => 57}
3> microbit_srv:mostrar("HOLA TECNM").    %% aparece en los LEDs
```

Ahora haz los **tres experimentos** y anota lo que pasa:

1. **Agita** el micro:bit. Debe aparecer `ALERTA sismo: ... mg` en la consola.
2. **Desconecta** el cable y vuelve a conectarlo antes de 30 s. ¿Qué dice el log?
   ¿Siguen contando las lecturas desde cero o desde donde iban? ¿Por qué?
3. **Desconéctalo** y déjalo así. Después de 5 intentos el supervisor se rinde.
   ¿Por qué es bueno que un supervisor tenga un límite?

> **Sin hardware:** `bash erlangmbit/simular.sh` reproduce lecturas, una línea
> basura, una alerta y una desconexión; al final debe imprimir
> `reiniciado por el supervisor: true`.

---

## Entregable

Pull Request con una carpeta `unidad2/tema2.1/erlangmbit/<tu_nombre>/` que incluya:

1. Tu `main.py` y tus módulos Erlang (si los modificaste).
2. Un **asciinema** de la sesión de `erl` con los tres experimentos (enlace en la
   descripción del PR) y, si puedes, un video corto del micro:bit.
3. Un `README.md` con las respuestas a las preguntas del Paso 3 y la justificación
   de una de las prácticas de la lista siguiente, con el mismo formato de
   [`problemasAresolver.md`](problemasAresolver.md): frase, señales y focos rojos.

---

## Prácticas a resolver — Erlang más allá de los datos estáticos

Elige una (o propón la tuya). Todas siguen la misma idea: **una tarjeta mide o
actúa, Erlang decide y sobrevive a las fallas**. Las tarjetas son intercambiables:
lo que dice "micro:bit" se puede hacer con Arduino, Raspberry Pi Pico W o ESP32 y
viceversa. Lo que cambia es cómo hablan con la PC:

| Tarjeta | Lenguaje en la tarjeta | Conexión con Erlang |
|---|---|---|
| micro:bit | MicroPython | USB serial (como en esta práctica) |
| Arduino UNO / Nano | C++ (Arduino IDE) | USB serial, `Serial.println(...)` |
| Raspberry Pi Pico W | MicroPython | USB serial o **Wi-Fi** → `gen_udp` / `gen_tcp` |
| ESP32 / ESP8266 | MicroPython o Arduino | **Wi-Fi** → `gen_udp` / `gen_tcp` |

### Nivel 1 — Un sensor, un proceso

**1. Termómetro del salón.** *(micro:bit o Arduino + LM35)*
Promedio móvil de las últimas 10 lecturas de temperatura, calculado con
`lists:foldl/3` sobre una lista inmutable. Si el promedio pasa de 30 °C, el
micro:bit muestra un ☀ y Erlang imprime "encender el aire".
*Concepto:* acumulador y estado inmutable dentro del `gen_server`.

**2. ¿Cuánto ruido hay en la biblioteca?** *(micro:bit V2, micrófono integrado)*
Clasifica el nivel de sonido con pattern matching y guards en `silencio`,
`platica`, `ruido` y `escandalo`. Muestra un emoji distinto en los LEDs según la
categoría. Cuenta cuántos minutos pasó la biblioteca en cada categoría.
*Concepto:* guards como reemplazo de `if` encadenados.

**3. Contador de aforo con barrera infrarroja.** *(Arduino + sensor IR o
ultrasónico HC-SR04)*
Cada vez que alguien cruza la puerta del laboratorio, la tarjeta manda `entra` o
`sale` (dos sensores, el orden indica la dirección). Erlang lleva el aforo y
avisa cuando se supera el cupo de protección civil.
*Concepto:* máquina de estados con pattern matching sobre la secuencia de eventos.

**4. Semáforo inteligente de maqueta.** *(Arduino + 3 LEDs + botón peatonal)*
Erlang manda las órdenes `rojo`, `amarillo` y `verde` con tiempos definidos; el
botón peatonal pide el cambio. Si la tarjeta deja de responder, Erlang lo detecta
y registra "semáforo fuera de servicio".
*Concepto:* `gen_statem` (máquina de estados de OTP) y comunicación en ambos sentidos.

**5. Monitor de humedad de la planta del salón.** *(Pico W + sensor capacitivo de
humedad de suelo)*
La Pico W manda la humedad por **Wi-Fi (UDP)** cada minuto. Si pasan 3 minutos sin
mensaje, Erlang decide que la tarjeta se quedó sin batería (`timeout` en el
`gen_server`).
*Concepto:* detectar la **ausencia** de mensajes, no solo su contenido.

### Nivel 2 — Varios sensores, varios procesos

**6. Red sísmica escolar (mini CENAPRED).** *(3 o más micro:bits, uno por equipo)*
Un proceso Erlang por micro:bit, todos bajo el mismo supervisor. Solo se declara
"sismo" si **al menos 2 de 3** sensores lo detectan en la misma ventana de 1 s
(evita falsas alarmas porque alguien golpeó la mesa). Desconecta uno a la mitad
de la demostración: los otros siguen.
*Concepto:* un proceso por dispositivo, `one_for_one`, coordinación por mensajes.

**7. Estación meteorológica del TecNM.** *(ESP32 + BME280: temperatura, humedad,
presión)*
Cada variable es un proceso distinto; un proceso "reportero" les pide datos cada
5 minutos y arma un resumen. Guarda las últimas 24 horas en **ETS** y permite
consultar desde el shell `estacion:maxima(temperatura)`.
*Concepto:* ETS como almacén compartido, `gen_server:call` entre procesos.

**8. Carrera de reflejos.** *(2 micro:bits, uno por jugador)*
Erlang manda "¡YA!" a las dos tarjetas al mismo tiempo; gana quien presione el
botón A primero. Erlang mide el tiempo de reacción con
`erlang:monotonic_time/1` y lleva el marcador de un torneo a 5 rondas.
*Concepto:* concurrencia real y orden de llegada de los mensajes.

**9. Alarma de puerta del site de cómputo.** *(Arduino + sensor magnético de
puerta + buzzer)*
Si la puerta se abre fuera de horario, Erlang activa el buzzer y registra el
evento. Con el botón de la tarjeta, el docente "desarma" la alarma con una
secuencia secreta (A, A, B, A).
*Concepto:* pattern matching sobre listas para reconocer secuencias.

**10. Tablero de estacionamiento.** *(ESP32 + 4 sensores ultrasónicos, uno por
cajón)*
Erlang mantiene un mapa `#{cajon_1 => libre, ...}` y lo muestra en la consola
como un tablero. Si un sensor manda lecturas imposibles (distancia negativa o
mayor a 4 m), ese proceso se reinicia sin afectar a los otros cajones.
*Concepto:* aislamiento de fallas: un sensor defectuoso no tumba el sistema.

### Nivel 3 — Sistemas que se recuperan solos

**11. Bitácora de la cadena de frío para vacunas.** *(Pico W + sensor DS18B20
sumergible)*
Un refrigerador de vacunas debe estar entre 2 y 8 °C. Erlang guarda cada lectura,
calcula cuántos minutos acumulados estuvo fuera de rango y genera un reporte. Si
se reinicia el nodo Erlang, la bitácora **no se pierde** (guárdala en disco con
`dets` o en un archivo).
*Concepto:* persistencia y recuperación del estado en `init/1`.

**12. Riego automático con prioridad.** *(ESP32 + 3 sensores de humedad + relevador
de bomba)*
Hay agua para regar solo **una maceta a la vez**. Erlang decide cuál regar según
la humedad más baja, con un proceso "bomba" que solo acepta una orden a la vez.
Si la bomba no confirma en 10 s, se marca como descompuesta.
*Concepto:* recurso compartido serializado por un proceso (sin locks).

**13. Dos computadoras, un sistema.** *(micro:bit conectado a la PC A)*
La PC A lee el micro:bit; la PC B, en otro nodo Erlang de la misma red, pregunta
el estado con `rpc:call/4` y muestra las alertas. Si se apaga la PC B, la PC A
sigue funcionando.
*Concepto:* Erlang distribuido (sección 3.3 del tutorial).

**14. Actualizar sin apagar.** *(cualquier tarjeta del Nivel 1)*
Con el sistema corriendo y recibiendo lecturas, cambia el umbral de alerta o la
fórmula en el código, recompila y carga la nueva versión con `c(modulo).` o
`l(modulo).` **sin detener** la lectura. Documenta qué pasa con el estado.
*Concepto:* recarga de código en caliente, la razón por la que las centrales de
Ericsson no se apagaban.

**15. Proyecto libre: protección civil del plantel.** *(combina 3 o más tarjetas)*
Integra en un solo árbol de supervisión al menos tres prácticas anteriores (por
ejemplo sismo + aforo + puerta). Diseña el árbol: qué procesos son hermanos, cuál
estrategia de reinicio usa cada supervisor (`one_for_one`, `one_for_all`,
`rest_for_one`) y por qué. Presenta un diagrama del árbol y una demostración
desconectando tarjetas en vivo.
*Concepto:* diseño de árboles de supervisión: la base de la capa Erlang del
[proyecto final 3](../../proyectos_finales/proyecto3_monitor_iot/).

---

## Reglas para todas las prácticas

- **Nada de `spawn` desnudo:** todo proceso con estado va en un `gen_server` (o
  `gen_statem`) **supervisado**.
- La tarjeta solo **mide y actúa**; las **decisiones** las toma Erlang.
- Debes provocar al menos **una falla a propósito** (desconectar, mandar basura,
  apagar la tarjeta) y mostrar cómo se recupera el sistema.
- Incluye siempre un **modo simulador** (`{cmd, ...}` como en `simular.sh`) para
  que cualquiera pueda revisar tu práctica sin tener tu hardware.

---

## Conexión con industria

Lo que haces aquí a escala de salón es el mismo patrón que usó Ericsson en el
switch **AXD301** y el que permitió a **WhatsApp** atender millones de conexiones
por servidor: muchos procesos pequeños, aislados, que fallan sin arrastrar a los
demás, y supervisores que los levantan. Un sensor que se desconecta y vuelve es,
en miniatura, un usuario que pierde la señal y se reconecta.
