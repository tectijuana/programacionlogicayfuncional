# Tema 2.5 — Aplicaciones FP: Sistema IoT con Erlang/OTP

**Proyecto:** Monitor de sensores estilo CENAPRED  
**Lenguaje:** Erlang/OTP  
**Patrón:** GenServer + Supervisor ("let it crash")

---

## Objetivo

Construir un sistema de monitoreo de sensores que demuestre la filosofía **"let it crash"** de Erlang:

- Los procesos que fallan son **reiniciados automáticamente** por un Supervisor
- El sistema **nunca se detiene** aunque un sensor falle
- Todo proceso con estado usa `gen_server` — nunca `spawn` desnudo

---

## Estructura del proyecto

```
sensor_supervisor/
├── src/
│   ├── sensor_app.erl     ← Application behaviour (punto de entrada OTP)
│   ├── sensor_sup.erl     ← Supervisor con estrategia one_for_one
│   └── sensor_server.erl  ← GenServer: un proceso por sensor
└── Makefile
```

---

## Compilar y ejecutar

```bash
cd sensor_supervisor
make compile
make run
```

Para compilar manualmente:
```bash
cd sensor_supervisor/src
erlc sensor_app.erl sensor_sup.erl sensor_server.erl
erl -pa . -eval "application:start(sensor_app)"
```

---

## Demostrar "let it crash"

Una vez corriendo el sistema, abre una consola Erlang y prueba:

```erlang
%% 1. Ver los procesos activos del supervisor
supervisor:which_children(sensor_sup).

%% 2. Obtener el PID de un sensor
{ok, Pid} = sensor_server:leer(temperatura),
io:format("PID sensor temperatura: ~p~n", [Pid]).

%% 3. Matar el proceso abruptamente — simula un crash real
exit(whereis(temperatura), kill).

%% 4. Esperar 1 segundo y verificar que el supervisor lo reinició
timer:sleep(1000),
supervisor:which_children(sensor_sup).
%% El sensor temperatura aparece de nuevo — reiniciado automáticamente

%% 5. Leer del sensor reiniciado — funciona sin intervención humana
sensor_server:leer(temperatura).
```

---

## Comportamientos OTP usados

| Módulo | Behaviour | Propósito |
|--------|-----------|-----------|
| `sensor_app` | `application` | Punto de entrada de la aplicación OTP |
| `sensor_sup` | `supervisor` | Árbol de supervisión, estrategia `one_for_one` |
| `sensor_server` | `gen_server` | Estado del sensor, lecturas, historial |

### Estrategia `one_for_one`

Si **un** hijo cae, solo **ese hijo** se reinicia. Los demás sensores continúan funcionando. Esto es correcto para sensores independientes: si el sensor de temperatura falla, humedad y presión siguen operando.

---

## Preguntas de reflexión

1. ¿Qué pasaría si usáramos `one_for_all` en lugar de `one_for_one`? ¿Cuándo sería esa estrategia correcta?
2. El `sensor_server` tiene un `send_after` que genera lecturas automáticas. ¿Por qué esto es más seguro que usar un thread separado en Java?
3. Si el sensor falla 10 veces en 1 segundo, el supervisor lo deja caer permanentemente (parámetros `MaxRestarts` y `MaxTime`). ¿Por qué esto es mejor que reiniciar infinitamente?
4. ¿Cómo escalarías este sistema para manejar 10,000 sensores? ¿Qué cambiarías?
