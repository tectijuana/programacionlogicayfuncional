# Flota40: telemetría y mando con Erlang/OTP

> 40 semis, 1 central, una BEAM.

Simulación de 40 tractocamiones (cada uno = **un proceso Erlang**) que reportan GPS ficticio
por UDP a una central. En la práctica real cada semi sería una PC + micro:bit
(ver `../erlangmbit.md`); aquí el micro:bit se simula.

Este proyecto no es una fantasía académica: modela un tipo de problema (telemetría de flotas,
muchos clientes concurrentes, fallas aisladas) que en la industria se resuelve con la
arquitectura de procesos de Erlang/OTP.

## Escenario: Clarvi

*Empresa ficticia con fines didácticos.* **Clarvi**, transportista de carga con base en Tijuana, quiere ver en una sola
pantalla 40 tractocamiones, detectar un SOS del operador en segundos y ordenar desde la central (detener, avisar a las
unidades cercanas) aunque algún dispositivo mande datos defectuosos o se desconecte. Cada equipo de la mesa opera
**4 unidades** de la flota; la central y el dashboard son el centro de control de Clarvi. Antecedente:
[`../patrones_mbit.md`](../patrones_mbit.md) (leer el dispositivo) y [`../erlangmbit.md`](../erlangmbit.md) (supervisión).

## Correr

```
erlc *.erl && erl
1> flota:iniciar().          %% 40 semis + central  (flota:iniciar(100000) para estresar la VM)
2> flota:estado().           %% tabla de posiciones (ETS)
3> flota:boton(3, b).        %% botón B = SOS  -> la central imprime la alerta
4> flota:boton(5, a).        %% botón A = parada/reanudar
5> flota:boton(7, logo).     %% logo táctil (V2) = dar la vuelta
6> flota:matar(7).           %% kill al proceso -> el supervisor lo reinicia
7> flota:vm().               %% procesos, schedulers, memoria
8> flota:semi_vm(3).         %% memoria/heap/reducciones de UN semi
9> observer:start().         %% GUI: árbol de supervisión, procesos, tráfico
```

## Qué observar (VM)

| Concepto | Dónde se ve |
|---|---|
| Proceso ligero (~25 KB cada semi, no hilo del SO) | `flota:semi_vm(3)`, `flota:iniciar(100000)` + `flota:vm()` |
| Schedulers (1 por core lógico) repartiendo procesos | `flota:vm()`, pestaña Load en `observer` |
| Aislamiento y "let it crash" | `flota:matar(7)`: los otros 39 no se enteran |
| Estado perdido al reiniciar (el semi 7 vuelve a su origen) | `flota:estado()` antes y después |
| Mensajes asíncronos y buzón | `semi:boton/2` es `cast`; `process_info(Pid, message_queue_len)` |
| ETS: lectura sin pasar por un proceso | `central:flota()` |

## Dashboard y red (servidor + PCs de alumnos)

```
PC alumno: micro:bit ─USB─► semi_serial ──UDP 5000──► SERVIDOR (central + dashboard :8080)
```

**Servidor** (EC2 con Elastic IP, o tu laptop). Abre UDP 5000 y TCP 8080 en el Security Group/firewall:

```erlang
1> flota:central().
```

Dashboard en `http://IP_SERVIDOR:8080` (mapa Leaflet + tabla; rojo = SOS, gris = sin señal 5 s).
`GET /flota.json` devuelve las posiciones (lee la ETS directo, sin pasar por el proceso `central`).

**PC de alumno** (solo su micro:bit, sin central local):

```erlang
1> flota:semis("10.0.0.5", [{41, "COM3"}]).     %% IP o nombre del servidor; Id único por alumno
```

También vale `FLOTA_HOST=10.0.0.5 erl` y `flota:iniciar(...)`. Sin configurar, el destino es `127.0.0.1`.
La demo en una sola BEAM (`flota:iniciar().`) también levanta el dashboard en `localhost:8080`.

Probar antes de clase: el WiFi del campus puede aislar clientes y bloquear UDP entre equipos.
La central ya descarta paquetes malformados (`parsear/1`), así que el paquete falso del ejercicio de
Scapy es *aceptado* si tiene formato válido y *ignorado* si no.

Simulación con **40 nodos Erlang** (un `erl -sname` por semi, micro:bit simulado) y su evaluación: [`EVALUACION.md`](EVALUACION.md) (`./nodos.sh 40` + `evaluacion:correr(40)`).

## Arquitectura de mando (para el laboratorio con VLAN)

**Decisión: mando centralizado, ejecución descentralizada.** `central` es la única fuente de verdad
(ETS + bitácora de eventos) y decide qué hacer ante cada comportamiento; cada semi es autónomo y
sigue su ruta si la central cae (se re-sincroniza con la siguiente telemetría, 1 s). Centralizar el mando
permite auditar y reaccionar con una sola política; descentralizar la ejecución evita un punto único de falla en la ruta.

| Mensaje | Dirección | Formato |
|---|---|---|
| Telemetría | semi → central | `ID\|seq\|lat\|lon\|kmh\|hdop10\|sats\|estado` (1/s) |
| Comando | central → semi (a su ip:puerto de origen) | `CMD\|Seq\|detener\|reanudar\|aviso\|texto` |
| Acuse | semi → central | `ACK\|ID\|Seq` (el micro:bit físico confirma con `ACK,Seq` por serial) |
| Prueba de red | cualquiera → central | `PING` → `PONG` |

- **Política ante SOS:** la central registra el evento, manda `SOS RECIBIDO` al semi y un aviso `SOS semi N` a los semis a ≤ 400 km (haversine). El LED del micro:bit lo muestra.
- **Confiabilidad sobre UDP:** cada comando se reenvía cada 1 s hasta 5 veces o hasta recibir ACK; si no, evento `cmd_fallido`.
- **Detección de fallas:** sin telemetría 5 s → evento `perdido`; al volver → `recuperado`.
- **Mando manual:** `flota:ordenar(7, detener, "")`, `flota:ordenar(7, reanudar, "")`, `flota:ordenar(7, aviso, "ALTO")`; bitácora con `flota:eventos()` o en el dashboard (`/eventos.json`).
- **Rastreo satelital simulado:** el GPS ficticio de cada micro:bit (interpolación entre ciudades). No hay receptor GNSS real.

## Rastreo satelital simulado: cómo debe comportarse el dato

Es telemetría de posición simulada con características GNSS: no hay constelación ni efemérides.
Para darla por generada (y creíble) cada fix debe cumplir:

| Aspecto | Regla |
|---|---|
| Continuidad | La posición avanza por la ruta (interpolación entre ciudades); nunca salta. |
| Coherencia física | `kmh` coincide con la distancia entre dos fixes / Δt (haversine). |
| Ruido | Jitter de 3 a 10 m sobre la ruta ideal (verdad terreno); lo que viaja es la medición. |
| Calidad | Cada fix lleva satélites (4–12), `hdop` y tipo de fix (sin fix / 2D / 3D); con pocos satélites sube el ruido. |
| Rumbo | `heading` del vector de movimiento; se conserva al detenerse. |
| Tiempo | Marca UTC del dispositivo y número de secuencia `seq`, para detectar pérdidas y desorden. |
| Fallas | Pérdida de fix (túnel), fix atípico raro y ráfagas de paquetes perdidos, para probar la validación. |

**La central debe:**
1. Validar rangos (lat ±90, lon ±180, `hdop` y satélites acotados); si no cumple, descartar y registrar.
2. Aceptar solo `seq`/`ts` mayor al último guardado (ignora duplicados y fixes viejos).
3. Marcar `atipico` y no mover el marcador si la velocidad implícita supera ~150 km/h.
4. Sin fix: conservar la última posición buena y mostrar su edad; no borrar ni inventar posición.

**Buenas prácticas funcionales:** el siguiente fix es una función pura `siguiente(Estado, Semilla) -> {Fix, Estado2}`;
con semilla fija la simulación es reproducible y se puede probar. La ruta ideal vive solo en la simulación.

**Criterio de aceptación de la demo:** 40 semis durante N minutos sin saltos físicamente imposibles,
`kmh` consistente con la distancia, y fixes perdidos detectados por huecos en `seq`.

**Implementado (caja negra):**
- `microbit/generar_traza.py` (offline, Python) calcula la traza: ruido proporcional al HDOP, `kmh` coherente con la distancia
  (tiempo comprimido: 1 s de demo = 240 s de ruta), túnel de 5 fixes sin satélites y un fix atípico (~120 km). Semilla fija = reproducible.
- `main.py` solo recorre la tabla (ida y vuelta, arranca en un índice al azar por tarjeta) y emite `seq`.
- `fix.erl` es el núcleo **puro** de validación (rango, `seq` viejo/duplicado/reinicio, sin fix, salto > 50 km por paso de `seq`);
  `central` lo aplica y registra `descartado`, `huecos`, `sin_fix`, `reinicio`. Pruebas: `fix_tests.erl`, `semi_modelo_tests.erl`.
- Verificado con el emulador: el túnel produce `sin_fix`, el atípico `descartado salto` + `huecos`, y el botón B un `sos` con ACK.

**Pendiente / límites:** los 40 semis *simulados* (`semi.erl`) usan `hdop=1.2`, `sats=9` fijos y sin ruido; solo la traza del micro:bit trae
calidad variable. La traza es una reproducción grabada, no rastreo generado en vivo. No se ha probado `main.py` en una tarjeta real (RAM/tamaño de script).

### Lista previa a la clase (VLAN aislada)
1. Servidor en la VLAN con IP fija. Firewall: UDP 5000 y TCP 8080 abiertos entre alumnos y servidor.
2. En el servidor: `flota:central().`
3. Desde **cada** PC, antes de conectar el micro:bit: `flota:prueba_red("IP_SERVIDOR").` → debe decir `OK`.
4. Cada alumno usa un Id único (1–40) y cargó `microbit/main.py`: `flota:semis("IP_SERVIDOR", [{Id, "COM3"}]).`
5. Abrir `http://IP_SERVIDOR:8080` en el proyector.
6. Plan B si falla un micro:bit: `flota:semis("IP_SERVIDOR", N, [])` simula N semis en esa PC.

Límites conocidos: si `central` se reinicia pierde la ETS (los semis la repueblan en ~1 s) y la bitácora; los comandos
no tienen autenticación (cualquier equipo de la VLAN puede mandar `PING`/telemetría falsa).

## Ver los paquetes (ciberseguridad)

Cada semi manda `ID|SEQ|LAT|LON|KMH|HDOP10|SATS|ESTADO` en UDP a `127.0.0.1:5000`.
Wireshark en la interfaz **Loopback (lo0)** con filtro `udp.port == 5000`.
Para el laboratorio real: cambia la IP en `semi.erl` por la del servidor y captura en su NIC.
Ejercicio: con Scapy inyecta un paquete falso `99|19.4|-99.1|0|sos` y observa que la central
lo acepta sin autenticar (¿cómo lo evitarías?).

## Botones (3 del micro:bit V2)

| Botón | Acción |
|---|---|
| A | detenido ⇄ rodando |
| B | SOS ⇄ rodando |
| logo táctil | retorno (invierte origen/destino) |

## Micro:bit físico por serial

1. Pega [`microbit/main.py`](microbit/main.py) en [python.microbit.org](https://python.microbit.org)
   y envíalo a la tarjeta. Es una **caja negra**: no calcula nada, recorre una traza estática (`TRAZA`) y cada segundo imprime `seq,lat,lon,kmh,hdop10,sats,estado` por USB serial. Requiere micro:bit V2.
   Verifica con *Show serial*.
   Otra ruta/semilla: `python3 microbit/generar_traza.py tijuana monterrey --semilla 7` (reescribe la tabla de `main.py`; `--sin-fallas` quita el túnel y el fix atípico).
   Sin hardware: `{41, {cmd, "python3 microbit/emulador.py"}}` ejecuta el mismo `main.py` sobre un micro:bit emulado (botones simulados: escribir `@A`, `@B`, `@L`; con `semi_serial:mostrar(41, "@B")`).
2. Busca el puerto: `ls /dev/cu.usbmodem*` (macOS) o `ls /dev/ttyACM*` (Linux).
3. Arranca la flota con 40 semis simulados + el micro:bit como semi **41**:

```erlang
1> flota:iniciar(40, [{41, "/dev/cu.usbmodem1102"}]).
2> flota:estado().                 %% el 41 aparece junto a los simulados
3> flota:mostrar(41, "ALTO").      %% texto desplazándose en la matriz LED
```

Botones en la tarjeta: **A** parada/reanudar, **B** SOS (la central imprime `!! SOS` y el
micro:bit recibe `SOS RECIBIDO`), **logo táctil** (V2) o **agitar** (V1) = dar la vuelta.

`semi_serial.erl` es el puente: abre el puerto con `open_port` (`stty` + `cat`, igual que
`../erlangmbit/microbit_srv.erl`), valida cada línea (descarta basura) y la reenvía por UDP con el
mismo formato `ID|seq|lat|lon|kmh|hdop10|sats|estado`, así que la central no distingue real de simulado.
Si desconectas el cable el proceso muere (*let it crash*), el supervisor lo reinicia y reintenta
abrir el puerto cada 2 s sin afectar a los demás semis. Varios micro:bits: añade más pares
`{Id, Dev}` a la lista (Id > N para no chocar con los simulados).

Prueba sin hardware: `{41, {cmd, "printf '19.4,-99.1,85,rodando\r\n'; sleep 3"}}` en lugar del dispositivo.

## Windows 11 (PowerShell)

Todo en PowerShell normal (no hace falta administrador, salvo para instalar).

```powershell
# 1. Instalar Erlang/OTP y Wireshark (una sola vez); cierra y reabre PowerShell después
winget install Erlang.ErlangOTP
winget install WiresharkFoundation.Wireshark      # marca Npcap con "loopback support" al instalar

# Si `erl` no se reconoce, añade Erlang al PATH de esta sesión (ajusta la versión):
$env:Path += ";$((Get-ChildItem 'C:\Program Files\Erlang*\bin' | Select-Object -First 1).FullName)"

# 2. Ver en qué COM quedó el micro:bit
[System.IO.Ports.SerialPort]::GetPortNames()
Get-CimInstance Win32_PnPEntity | Where-Object Name -match 'COM\d+' | Select-Object Name

# 3. Compilar y arrancar
cd .\unidad2\tema2.1\flota40
erlc *.erl
erl
```

```erlang
1> flota:iniciar(40, [{41, "COM3"}]).     %% el puerto es un string, p. ej. "COM3"
2> flota:estado().
3> flota:mostrar(41, "ALTO").
```

- Solo simulación (sin micro:bit): `flota:iniciar().`
- Probar el puente solo, sin Erlang (Ctrl+C para salir):
  `powershell -NoProfile -ExecutionPolicy Bypass -File .\puente_serial.ps1 COM3`
- Si la política de scripts bloquea algo: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`.
- Si `COM3` está ocupado, cierra la consola serial del editor web, Thonny o PuTTY: solo un programa puede abrir el puerto.
- Wireshark: elige **Npcap Loopback Adapter** y filtro `udp.port == 5000`.
- `{cmd, ...}` (prueba sin hardware) usa `/bin/sh`: en Windows solo funciona desde WSL.

## Rúbrica de evaluación (0–100)

Se evalúa por **equipo de 4** (una mesa del laboratorio = 4 PCs = 4 semis con Ids propios, p. ej. mesa 3 → Ids 9–12).
Cada criterio se califica con cuatro niveles: **100 %** funciona y se explica con sus palabras · **70 %** funciona pero no
lo explican · **40 %** funciona parcialmente · **0 %** no funciona. Las explicaciones las da un integrante elegido al azar por el docente.

| # | Criterio | Pts | Evidencia que se revisa |
|---|---|---|---|
| 1 | **Conectividad** | 15 | `flota:prueba_red(IP)` devuelve `OK` en las 4 PCs; los 4 semis aparecen en el dashboard con Id único. |
| 2 | **Micro:bit y estados** | 15 | `main.py` cargado en las 4 tarjetas; A, B y logo cambian el estado y se refleja en el dashboard. |
| 3 | **Mando de la central** | 20 | Un SOS genera `sos` en la bitácora, ACK y `SOS RECIBIDO` en el LED; `flota:ordenar(Id, detener, "")` detiene el micro:bit. |
| 4 | **Tolerancia a fallas** | 15 | Desconectan un cable: el proceso muere y se reinicia solo; la bitácora muestra `perdido` y luego `recuperado`; los demás semis no se afectan. |
| 5 | **Validación de datos** | 15 | Explican por qué `fix:evaluar/2` rechazó un fix (`salto`, `seq_viejo`, `fuera_de_rango`) y por qué `sin_fix` conserva la última posición buena. |
| 6 | **Principios funcionales** | 15 | Identifican el núcleo puro (`semi_modelo`, `fix`) y el shell con efectos; justifican por qué la ETS es una excepción a la inmutabilidad. |
| 7 | **Extensión propia** | 5 | Una regla nueva en `fix.erl` con su prueba eunit, o un comando nuevo con ACK. |

**Entregables por equipo:** captura del dashboard con sus 4 semis, texto de la bitácora de eventos y un párrafo por cada
criterio 5 y 6.

**Cierre en vivo (5 min):** el docente dispara un SOS, una desconexión de cable y un paquete falso (Scapy). El criterio 5 incluye
responder "¿cómo evitarías la inyección?" (autenticación del paquete, p. ej. HMAC).
