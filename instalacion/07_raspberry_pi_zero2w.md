# 7 · Raspberry Pi Zero 2W — Prolog + Erlang con un script

Guía autocontenida para montar un nodo físico ARM64 del curso en una
**Raspberry Pi Zero 2W** (quad-core Cortex-A53, 512 MB RAM) — el mismo
ecosistema aarch64 que la instancia EC2 Graviton, pero en tu escritorio.

## Hardware y sistema

| Componente | Recomendación |
|------------|---------------|
| Placa | Raspberry Pi Zero 2W |
| microSD | 16 GB clase A1 o mejor |
| SO | **Raspberry Pi OS Lite 64-bit (Bookworm)** — imprescindible que sea 64-bit |
| Alimentación | 5 V / 2 A |

Graba la imagen con **Raspberry Pi Imager**, habilitando SSH y Wi-Fi en la
configuración previa (⚙️ antes de escribir la SD).

## Instalación con el script

Conéctate por SSH a la Pi y ejecuta:

```bash
curl -sLO https://raw.githubusercontent.com/tectijuana/programacionlogicayfuncional/main/instalacion/scripts/install_pi_zero2w.sh
bash install_pi_zero2w.sh
```

El script ([scripts/install_pi_zero2w.sh](scripts/install_pi_zero2w.sh)):

1. Verifica que el sistema sea **aarch64** (aborta si grabaste la imagen de 32 bits).
2. Amplía el **swap a 1 GB** — con 512 MB de RAM es obligatorio.
3. Instala **SWI-Prolog** desde apt (Bookworm trae 9.0.4 ✓).
4. Instala **Erlang/OTP** desde apt (Bookworm trae OTP 25.x — ver nota abajo).
5. Corre pruebas de humo: CLP(FD) en Prolog y spawn de procesos en Erlang.

Tiempo total: **5–10 minutos** con buena conexión.

## Nota sobre la versión de Erlang

El curso pide OTP 26+ para el proyecto final, pero **compilar OTP 26 en la
Zero 2W (512 MB RAM) toma varias horas** y no vale la pena: el OTP 25 de apt
ejecuta sin cambios todo el material de GenServer/supervisores del curso.

- Para el trabajo con OTP 26+ usa la instancia EC2 ([02_erlang.md](02_erlang.md)).
- La Pi es ideal como **nodo remoto de demostración**: p. ej., un nodo Erlang
  distribuido (`erl -name pi@<ip> -setcookie curso`) monitoreado desde EC2,
  o el sensor físico del proyecto 3 (monitor IoT).

## Verificación manual

```bash
swipl --version   # SWI-Prolog 9.0.4 for aarch64-linux
erl -eval 'io:format("OTP ~s~n",[erlang:system_info(otp_release)]),halt().' -noshell
```

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| Script aborta con "se esperaba aarch64" | Grabaste Raspberry Pi OS de 32 bits — regraba la versión **64-bit** |
| `apt install` muy lento | Normal en la Zero 2W (CPU modesta + Wi-Fi 2.4 GHz); espera |
| La Pi se congela compilando algo | Verifica el swap: `free -h`; evita compilar desde fuente en esta placa |
| SSH no conecta | Revisa que habilitaste SSH en Raspberry Pi Imager y que la Pi esté en tu misma red |
