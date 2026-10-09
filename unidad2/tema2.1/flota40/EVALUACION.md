# Evaluación de Flota40 — 40 nodos Erlang + micro:bit emulado

## Cómo reproducirla

```sh
./nodos.sh 40                      # 40 nodos BEAM (semi1@host … semi40@host), cada uno con su micro:bit emulado
erl -sname central -setcookie flota -pa .
1> flota:central().                # central + dashboard http://localhost:8080
2> evaluacion:correr(40).          # ~40 s; imprime la tabla de abajo
```

Cada nodo corre `semi_serial` contra `microbit/emulador.py`, que ejecuta **el `main.py` real** (traza GPS grabada con
fallas a propósito, 3 botones, órdenes `!D/!R/!M` con `ACK`) por el mismo protocolo serial que la tarjeta.
Las pulsaciones "manuales" se simulan con `@A/@B/@L`: `rpc:call(semi7@host, semi_serial, boton, [7, b]).`

## Resultados medidos (corrida del 9-oct-2026, macOS, 40 BEAMs + 40 emuladores Python en una laptop)

| Métrica | Resultado |
|---|---|
| Nodos Erlang alcanzables | 40 / 40 |
| Fixes aceptados en 10 s | 377–381 de 400 emitidos (≈ 95 %) — ver nota |
| Botón B → evento `sos` en la central (5 nodos) | 51 – 919 ms |
| Botón B → ACK de la orden `SOS RECIBIDO` | 153 – 1021 ms (≈ 100 ms después del evento) |
| Caída de un nodo completo → evento `perdido` | ≈ 6 s (umbral de sin-señal 5 s + barrido cada 2 s) |
| Memoria por nodo semi / central | ≈ 53 MB / 53 MB; cola de mensajes de la central = 0 |

Notas honestas:
- **El 95 % no es pérdida de red.** `central:paquetes()` cuenta solo fixes *aceptados*. La traza trae fallas a propósito
  (salto atípico, túnel) y la validación descartó 9 y registró 15 `sin_fix` y 7 `huecos` en 30 s. Además el `sleep(100)` de
  `main.py` emulado deriva ~5 %. No separé estas causas en una medición independiente.
- La latencia del SOS está dominada por el micro:bit (1 línea/s): máximo teórico ≈ 1 s. El ACK ahora sí es independiente
  (el emulador responde `ACK,seq` tras aplicar la orden).
- Una sola corrida en loopback: **no valida la VLAN real, pérdida en red ni micro:bits físicos**, ni que la traza (6.3 KB) quepa en la RAM de la V2.
- 53 MB/nodo es la BEAM por defecto; 40 nodos ≈ 2 GB en una laptop. En el laboratorio cada PC corre un solo nodo.

## Evaluación contra buenas prácticas de programación funcional

| Práctica (mundo real) | Estado | Evidencia / pendiente |
|---|---|---|
| **Núcleo puro, shell con efectos** (functional core / imperative shell) | ✅ | `semi_modelo.erl`: sin procesos, sin azar, sin reloj; `semi.erl` solo aporta `rand`, `send_after` y UDP |
| **Funciones totales** (toda entrada tiene cláusula) | ✅ | `semi_modelo:orden/2` ignora órdenes desconocidas; `central:parsear/1` descarta lo malformado |
| **Pruebas del núcleo sin infraestructura** | ✅ | `semi_modelo_tests.erl` + `fix_tests.erl`: 17 pruebas eunit, incl. una propiedad con 200 semillas × 500 eventos (estado válido, posición acotada) |
| **Tipos / contratos explícitos** | ⚠️ parcial | `-spec` y `-opaque` en `semi_modelo`; **sin `-spec` en central/semi_serial y sin Dialyzer ejecutado** |
| **Estado inmutable, transiciones explícitas** | ✅ | Cada mensaje produce un `#c{}`/mapa nuevo; la mutabilidad se limita a la ETS (justificada: lectura concurrente) |
| **Supervisión / "let it crash"** | ✅ | `flota_sup` one_for_one; cable desconectado → el proceso muere y se reinicia solo |
| **Fronteras validadas** (nunca confiar en el exterior) | ✅ | La central valida cada paquete UDP; el puente valida cada línea serial |
| **Efectos aislados y observables** | ✅ | Bitácora de eventos en ETS + dashboard; red/serial solo en `central`, `semi`, `semi_serial` |
| **Mensajería confiable explícita** | ✅ | ACK + 5 reintentos sobre UDP, medido en la corrida |
| **Pruebas basadas en propiedades con librería** (PropEr/QuickCheck) | ⚠️ no | Se usó una propiedad "a mano" con `rand`; PropEr daría shrinking |
| **Pruebas de integración automáticas** | ❌ | `evaluacion:correr/1` es manual y de una corrida; no está en CI |
| **Seguridad** | ❌ | Sin autenticación ni cifrado: cualquiera en la VLAN puede inyectar telemetría (ejercicio didáctico) |
| **Persistencia** | ❌ | Si `central` reinicia, pierde ETS y bitácora (los semis repueblan la posición en ~1 s) |

## Qué sigue (en orden de valor)

1. Correr en el laboratorio: `flota:prueba_red/1` desde cada PC y `evaluacion:correr(40)` con las PC reales.
2. `-spec` en todos los módulos y correr `dialyzer`.
3. Mover la ETS a un proceso dueño bajo el supervisor para que sobreviva a un reinicio de `central`.
4. Firmar paquetes (HMAC con clave compartida) y cerrar el ejercicio de inyección.
