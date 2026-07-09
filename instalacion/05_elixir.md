# 5 · Elixir — Ubuntu 24.04 ARM64

Guía autocontenida. El curso usa Elixir en ejemplos de la unidad 2/4
(pipe operator, GenServer con sintaxis moderna).

Elixir corre sobre la BEAM: **requiere Erlang** instalado primero
(ver [02_erlang.md](02_erlang.md)).

## Opción A — apt (rápida: Erlang 25 + Elixir empaquetado)

```bash
sudo apt update
sudo apt install -y elixir
elixir --version
# Erlang/OTP 25 ... Elixir 1.14.x
```

Suficiente para los ejemplos del curso. Nota: instala el Erlang de apt (OTP 25)
como dependencia.

## Opción B — Precompilado oficial sobre tu OTP 26 de kerl

Si ya compilaste OTP 26 con kerl ([02_erlang.md](02_erlang.md) Opción B), usa
el paquete precompilado de Elixir que corresponde a tu OTP (los `.zip` de
elixir-lang son bytecode BEAM — independientes de la arquitectura):

```bash
. ~/otp/26.2.5/activate    # asegura OTP 26 en el PATH

ELIXIR_VER=1.16.3
curl -sLo elixir.zip \
  https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VER}/elixir-otp-26.zip
sudo mkdir -p /opt/elixir
sudo unzip -q elixir.zip -d /opt/elixir
echo 'export PATH=/opt/elixir/bin:$PATH' >> ~/.bashrc
export PATH=/opt/elixir/bin:$PATH
```

> El sufijo `-otp-26` del zip **debe coincidir** con tu versión de OTP activa.

## Verificación

```bash
elixir --version
```

Prueba con el pipe operator (unidad 2):

```bash
elixir -e '
1..10
|> Enum.map(&(&1 * &1))
|> Enum.filter(&(rem(&1, 2) == 0))
|> Enum.sum()
|> IO.puts()
'
# 220
```

REPL interactivo:

```bash
iex
iex(1)> "hola mundo" |> String.upcase() |> String.split()
["HOLA", "MUNDO"]
```

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `elixir: command not found` (Opción B) | `export PATH=/opt/elixir/bin:$PATH` o reabre sesión |
| Crash al arrancar iex | Mezcla de versiones: el zip `-otp-26` corriendo sobre OTP 25 — activa el OTP correcto |
| `mix` pide Hex | `mix local.hex --force` la primera vez |
