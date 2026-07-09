# 2 · Erlang/OTP 26+ — Ubuntu 24.04 ARM64

Guía autocontenida. El curso requiere **Erlang/OTP 26 o superior** (unidad 4:
GenServer, supervisores; proyectos finales: capa de concurrencia).

> ⚠️ Estado de los paquetes ARM64 (verificado jul 2026):
> - `apt` de Ubuntu 24.04 trae **OTP 25.3** — suficiente para practicar, pero
>   por debajo del requisito 26+.
> - El PPA de RabbitMQ (`ppa:rabbitmq/rabbitmq-erlang`) **falla sus builds
>   arm64** — no lo uses en esta arquitectura.
> - Erlang Solutions no publica `.deb` para arm64.
>
> Conclusión: en ARM64 la ruta confiable para OTP 26+ es **compilar con kerl**
> (Opción B). Si solo quieres empezar rápido, usa la Opción A y anota la
> diferencia de versión.

## Opción A — apt (rápida, OTP 25.3)

```bash
sudo apt update
sudo apt install -y erlang
erl -eval 'io:format("OTP ~s~n",[erlang:system_info(otp_release)]),halt().' -noshell
# OTP 25
```

Sirve para las primeras sesiones de la unidad 4; para el proyecto final
compila OTP 26+ con la Opción B.

## Opción B — kerl, OTP 26.2 desde fuente (recomendada para el curso)

### B.1 Preparar swap (solo en t4g.micro / máquinas con 1 GB RAM)

La compilación de OTP necesita ~2 GB de memoria:

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
free -h   # debe mostrar 2.0Gi de swap
```

### B.2 Dependencias de compilación

```bash
sudo apt update
sudo apt install -y build-essential autoconf m4 libncurses-dev \
  libssl-dev unixodbc-dev curl git
```

(Omitimos wxWidgets/Java a propósito: no usamos `observer` gráfico ni jinterface
en la instancia remota.)

### B.3 Instalar kerl y compilar

```bash
curl -sLo ~/kerl https://raw.githubusercontent.com/kerl/kerl/master/kerl
chmod +x ~/kerl
sudo mv ~/kerl /usr/local/bin/

kerl update releases
kerl build 26.2.5 otp-26.2.5     # ⏱️ 40–90 min en t4g.micro, ~15 min en t4g.small
kerl install otp-26.2.5 ~/otp/26.2.5
echo '. ~/otp/26.2.5/activate' >> ~/.bashrc
. ~/otp/26.2.5/activate
```

## Verificación

```bash
erl -eval 'io:format("OTP ~s~n",[erlang:system_info(otp_release)]),halt().' -noshell
# OTP 26
```

Prueba de concurrencia mínima (lo que hace especial a la BEAM):

```bash
erl -noshell -eval '
  Padre = self(),
  [spawn(fun() -> Padre ! {yo, N} end) || N <- lists:seq(1,5)],
  [receive {yo, N} -> io:format("proceso ~p reporto~n",[N]) end || _ <- lists:seq(1,5)],
  halt().'
```

## rebar3 (herramienta de builds, para los proyectos OTP)

```bash
curl -sLo rebar3 https://s3.amazonaws.com/rebar3/rebar3
chmod +x rebar3
sudo mv rebar3 /usr/local/bin/
rebar3 --version
```

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| Compilación muere con `Killed` | Sin swap suficiente — repite B.1 |
| `crypto` no carga | Falta `libssl-dev` al compilar; reinstala dependencias y `kerl build` de nuevo |
| `odbc` warning al compilar | Ignorable; no lo usamos en el curso |
| Quiero varias versiones OTP | `kerl list installations` y activa la que necesites |
