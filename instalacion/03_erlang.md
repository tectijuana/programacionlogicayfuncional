# 3 · Erlang/OTP 26 — Ubuntu 24.04 ARM64

Guía autocontenida. El curso requiere **Erlang/OTP 26 o superior** (unidad 4:
GenServer, supervisores; proyectos finales: capa de concurrencia).

> **Verificado el 2026-09-01** en el nodo del curso (`t4g.large`, Ubuntu 24.04.4
> aarch64) lanzado con `instalacion/scripts/lanzar-nodo-arm64.sh`.
>
> Estado de los paquetes ARM64:
> - `apt` de Ubuntu 24.04 trae **OTP 25.3** — sirve para las primeras sesiones,
>   pero está por debajo del requisito 26+ y `rebar3` reciente ya no corre en él
>   (ver la nota en la sección de rebar3).
> - El PPA de RabbitMQ (`ppa:rabbitmq/rabbitmq-erlang`) **falla sus builds
>   arm64** — no lo uses.
> - Erlang Solutions no publica `.deb` para arm64.
>
> Conclusión: la ruta del curso es **compilar OTP 26.2.5 con kerl** (Opción B).
> En el `t4g.large` tarda **~7 minutos**. La Opción A (apt) queda solo como
> arranque rápido para la primera sesión.

---

## Opción A — apt (arranque rápido, OTP 25.3)

Úsala **solo** si necesitas un `erl` en 30 segundos para la primera práctica.
Para todo lo demás, salta a la Opción B.

```bash
sudo apt update
sudo apt install -y erlang rebar3
erl -eval 'io:format("OTP ~s~n",[erlang:system_info(otp_release)]),halt().' -noshell
# OTP 25
rebar3 --version
# rebar 3.19.0 on Erlang/OTP 25 ...
```

`apt` instala `rebar3` 3.19.0, que **sí** funciona con OTP 25. No uses el
instalador `curl` de rebar3 en esta opción (ver la nota más abajo).

---

## Opción B — kerl, OTP 26.2.5 desde fuente (ruta del curso)

Fijamos la versión exacta **26.2.5** para que todos los estudiantes tengan
el mismo runtime, sin variaciones. (kerl también ofrece 26.2.5.21, 27.x, 28.x
y 29.x; cualquiera ≥ 26 cumple, pero para el curso usamos 26.2.5.)

### B.1 · Swap

El nodo lanzado con `lanzar-nodo-arm64.sh` **ya trae swap** (lo crea el
`user-data` en el primer arranque). Verifícalo:

```bash
swapon --show
#   NAME      TYPE SIZE USED PRIO
#   /swapfile file   2G   0B   -1
```

Si `swapon --show` no muestra nada (VM creada por otro medio, o máquina con
1 GB de RAM), créalo **solo entonces**:

```bash
if ! swapon --show | grep -q /swapfile; then
  sudo fallocate -l 2G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi
free -h
```

> ⚠️ No corras `fallocate -l ... /swapfile` si el `/swapfile` ya está activo:
> falla con `Text file busy`. El `if` de arriba lo evita.

### B.2 · Dependencias de compilación

```bash
sudo apt update
sudo apt install -y build-essential autoconf m4 libncurses-dev \
  libssl-dev unixodbc-dev curl git
```

(Omitimos wxWidgets/Java a propósito: no usamos `observer` gráfico ni
`jinterface` en la instancia remota. kerl imprimirá avisos de que
`wxWidgets`, `xmllint` y `fop` faltan — **son normales, no son errores**:
solo dicen que no se compilan el GUI ni la documentación HTML.)

### B.3 · Instalar kerl y compilar

```bash
curl -sLo /tmp/kerl https://raw.githubusercontent.com/kerl/kerl/master/kerl
chmod +x /tmp/kerl
sudo mv /tmp/kerl /usr/local/bin/kerl
kerl version            # 4.4.0 o superior

export KERL_BUILD_DOCS=no      # no intentar construir el manual HTML
kerl update releases

# La compilación tarda ~7 min en t4g.large / t4g.medium (medido 2026-09-01),
# 15-25 min en t4g.micro si los créditos de CPU están bajos. Córrela dentro
# de tmux para que un corte de SSH no la mate:
tmux new -s otp 'kerl build 26.2.5 otp-26.2.5 && kerl install otp-26.2.5 ~/otp/26.2.5'
#   (Ctrl-b d para salir del tmux; tmux attach -t otp para volver)
```

Sin tmux, con `nohup`:

```bash
nohup bash -c 'kerl build 26.2.5 otp-26.2.5 && kerl install otp-26.2.5 ~/otp/26.2.5' \
  > ~/kerl-build.log 2>&1 &
tail -f ~/kerl-build.log      # Ctrl-c para dejar de mirar; el build sigue
```

### B.4 · Activar

```bash
echo '. ~/otp/26.2.5/activate' >> ~/.bashrc
. ~/otp/26.2.5/activate       # para la shell actual
```

> El `.bashrc` de Ubuntu solo se aplica en shells **interactivas**. Para un
> one-liner no interactivo (`ssh host 'erl ...'`) antepón el activate:
> `ssh host 'source ~/otp/26.2.5/activate && erl ...'`.

---

## Verificación

```bash
erl -eval 'io:format("OTP ~s / erts ~s~n",[erlang:system_info(otp_release), erlang:system_info(version)]),halt().' -noshell
# OTP 26 / erts 14.2.5
```

Prueba de concurrencia mínima (lo que hace especial a la BEAM):

```bash
erl -noshell -eval '
  Padre = self(),
  [spawn(fun() -> Padre ! {yo, N} end) || N <- lists:seq(1,5)],
  [receive {yo, N} -> io:format("proceso ~p reporto~n",[N]) end || _ <- lists:seq(1,5)],
  halt().'
```

---

## rebar3 (herramienta de builds, para los proyectos OTP)

| Runtime | Cómo instalar rebar3 | Versión |
|---------|----------------------|---------|
| OTP 25 (Opción A) | `sudo apt install -y rebar3` | 3.19.0 |
| OTP 26 (Opción B) | `curl` del binario oficial (abajo) | 3.27.0 |

```bash
# SOLO con OTP 26 activo:
curl -sLo /tmp/rebar3 https://s3.amazonaws.com/rebar3/rebar3
chmod +x /tmp/rebar3
sudo mv /tmp/rebar3 /usr/local/bin/rebar3
rebar3 --version
```

> ⚠️ El binario de `https://s3.amazonaws.com/rebar3/rebar3` hoy viene compilado
> para **OTP 26+**. En OTP 25 falla con
> `This BEAM file was compiled for a later version of the runtime system`.
> Por eso en la Opción A se usa el `rebar3` de `apt`.

Prueba:

```bash
cd /tmp && rebar3 new app demo && cd demo && rebar3 compile && rebar3 eunit
```

---

## Erlang distribuido: puertos y flag de rango fijo

Para prácticas **básicas e intermedias en un solo nodo** (REPL, `spawn`, paso de
mensajes, `gen_server`, supervisores) basta con `tcp/22`: todo ocurre dentro de
la BEAM y no toca la red.

Cuando pases a **Erlang distribuido** (varios nodos, `erl -name`,
`net_adm:ping/1`) necesitas abrir:

| Puerto | Uso |
|--------|-----|
| `TCP/4369` | EPMD — Erlang Port Mapper Daemon (no usa UDP) |
| `TCP/9100-9105` | Rango fijo para la conexión entre nodos |

Por defecto el puerto de conexión entre nodos es **efímero/dinámico**, así que
no se puede abrir en el firewall. Se fija con flags de `kernel`:

```bash
erl -name nodo1@10.0.0.5 -setcookie curso \
    -kernel inet_dist_listen_min 9100 \
    -kernel inet_dist_listen_max 9105
```

En `sys.config` (proyectos rebar3 / releases):

```erlang
{kernel, [
  {inet_dist_listen_min, 9100},
  {inet_dist_listen_max, 9105}
]}
```

El rango debe coincidir con el que abre el security group en
`instalacion/scripts/lanzar-nodo-arm64.sh` (sección 5). Ese script restringe el
origen al propio security group: **nunca expongas EPMD a `0.0.0.0/0`** — un nodo
distribuido con la cookie conocida permite ejecución remota de código.

### Prueba rápida (2 nodos en la MISMA VM, sin abrir nada)

```bash
IP=$(hostname -I | awk '{print $1}')
# nodo a en segundo plano, vive 30 s
setsid erl -name "a@$IP" -setcookie curso \
  -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9105 \
  -noshell -eval 'timer:sleep(30000), halt().' &
sleep 2
# nodo b hace ping a a
erl -name "b@$IP" -setcookie curso \
  -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9105 \
  -noshell -eval "io:format(\"~p~n\",[net_adm:ping(list_to_atom(\"a@$IP\"))]), halt()."
# pong
```

### Prueba entre 2 VMs de la misma VPC

```bash
# VM A
erl -name a@<IP_PRIVADA_A> -setcookie curso -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9105
# VM B
erl -name b@<IP_PRIVADA_B> -setcookie curso -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9105
(b@...)1> net_adm:ping('a@<IP_PRIVADA_A>').
pong
```

Usa las **IPs privadas** (`172.31.x.x`): el tráfico entre nodos va por dentro de
la VPC, que es lo que permite la regla del security group.

---

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `kerl build` muere con `Killed` | Sin swap — revisa B.1 (`swapon --show`) |
| `fallocate: ... Text file busy` | El `/swapfile` ya está activo; no lo recrees (usa el `if` de B.1) |
| Avisos de `wxWidgets` / `xmllint` / `fop` al compilar | Normales: no compilamos GUI ni manual. No son errores |
| `crypto` no carga | Faltó `libssl-dev` al compilar; reinstala B.2 y `kerl build` de nuevo |
| `rebar3`: `This BEAM file was compiled for a later version` | Instalaste el `rebar3` de `curl` sobre OTP 25; usa `apt install rebar3` o activa OTP 26 |
| `erl` sigue mostrando OTP 25 tras instalar 26 | No se aplicó el `activate`; abre shell nueva o `source ~/otp/26.2.5/activate` |
| `ssh host 'erl ...'` usa OTP 25 aunque interactivo dé 26 | El `.bashrc` no corre en shells no interactivas; antepón `source ~/otp/26.2.5/activate &&` |
| Quiero varias versiones OTP | `kerl list installations` y `activate` la que necesites |
