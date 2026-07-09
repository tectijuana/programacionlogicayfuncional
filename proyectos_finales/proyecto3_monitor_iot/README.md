# Proyecto 3 — Monitor de Alertas IoT estilo CENAPRED

## Descripción

El CENAPRED (Centro Nacional de Prevención de Desastres) opera redes de sensores
sísmicos, volcánicos y meteorológicos en tiempo real. Este proyecto simula un sistema
de monitoreo con 5 tipos de sensores, umbrales de alerta configurables via CLP(FD),
y un árbol de supervisión OTP que garantiza que ningún sensor quede sin monitoreo.

---

## Sensores simulados

| Sensor | Unidad | Umbral alerta | Umbral crítico |
|--------|--------|---------------|----------------|
| `sismico` | Richter | ≥ 4.0 | ≥ 6.0 |
| `temperatura` | °C | ≥ 35 | ≥ 40 |
| `humedad` | % | ≤ 20 | ≤ 10 |
| `co2` | ppm | ≥ 1000 | ≥ 2000 |
| `presion` | hPa | ≤ 950 | ≤ 920 |

---

## Arquitectura

```
capa1/umbrales.pl          ← CLP(FD): rangos y clasificación de alertas
capa1/reglas_alerta.pl     ← reglas: normal/alerta/critico según lectura
capa1/tests_monitor.pl     ← plunit: verificar clasificación correcta

capa2/sensor_server.erl    ← GenServer: un proceso por sensor
capa2/agregador.erl        ← GenServer: promedio y estado global (LA IMPLEMENTAS TÚ — 2º GenServer requerido)
capa2/monitor_sup.erl      ← DynamicSupervisor: reinicio automático

capa3/dashboard.exs        ← Elixir Stream: pipeline de lectura y reporte
```

---

## La filosofía "let it crash" en acción

```erlang
%% Si un sensor falla (lectura inválida, hardware, timeout):
Process.exit(pid_sensor_sismico, :kill)
%% El DynamicSupervisor lo reinicia en < 1ms
%% El sistema nunca se detiene por la falla de un sensor
```

---

## Ejecutar

```bash
# Capa 1
swipl -g "run_tests(monitor), halt" -l capa1/tests_monitor.pl

# Capa 2 — arrancar supervisor con 5 sensores
cd capa2 && erlc *.erl
erl -eval "monitor_sup:start_link(), timer:sleep(5000), halt()"

# Capa 3 — dashboard en tiempo real (Ctrl+C para detener)
elixir capa3/dashboard.exs
```

---

## Entregables

1. `capa1/` — clasificación de alertas con CLP(FD), tests pasando
2. `capa2/` — DynamicSupervisor con 5 sensores, demostrar reinicio tras kill
3. `capa3/` — dashboard Elixir con Stream mostrando lecturas en consola
4. README con captura de pantalla o `asciinema` de la demostración en vivo
