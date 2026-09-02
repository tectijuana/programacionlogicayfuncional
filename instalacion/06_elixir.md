# 6 · Elixir — Ubuntu 24.04 ARM64

Guía autocontenida. El curso usa Elixir en ejemplos de la unidad 2/4
(pipe operator, GenServer con sintaxis moderna).

Elixir corre sobre la BEAM: **requiere Erlang** instalado primero
(ver [03_erlang.md](03_erlang.md)).

> **Verificado el 2026-09-01** en el nodo del curso (`t4g.large`, Ubuntu 24.04.4
> aarch64):
>
> | Ruta | Erlang | Elixir |
> |------|--------|--------|
> | A · apt | OTP 25.3 | 1.14.0 |
> | B · precompilado sobre kerl | OTP 26.2.5 | **1.18.5** |
> | C · asdf | fijado en `.tool-versions` | fijado en `.tool-versions` |

---

## Opción A — apt (rápida: Erlang 25 + Elixir 1.14)

```bash
sudo apt update
sudo apt install -y elixir
elixir --version
# Erlang/OTP 25 ...
# Elixir 1.14.0 (compiled with Erlang/OTP 24)
```

Suficiente para los ejemplos del curso. Instala el Erlang de apt (OTP 25) como
dependencia.

---

## Opción B — Precompilado oficial sobre tu OTP 26 de kerl

Si ya compilaste OTP 26 con kerl ([03_erlang.md](03_erlang.md) Opción B), baja
el Elixir precompilado que corresponde a tu OTP. Los `.zip` de elixir-lang son
bytecode BEAM (independientes de la arquitectura).

```bash
. ~/otp/26.2.5/activate          # OTP 26 en el PATH
sudo apt install -y unzip

ELIXIR_VER=1.18.5                 # última serie con build para OTP 26
curl -sLo /tmp/elixir.zip \
  https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VER}/elixir-otp-26.zip
sudo rm -rf /opt/elixir && sudo mkdir -p /opt/elixir
sudo unzip -q /tmp/elixir.zip -d /opt/elixir

echo 'export PATH=/opt/elixir/bin:$PATH' >> ~/.bashrc
export PATH=/opt/elixir/bin:$PATH

elixir --version
# Elixir 1.18.5 (compiled with Erlang/OTP 26)
```

> ⚠️ El sufijo `-otp-NN` del zip **debe coincidir** con tu OTP activo.
> Elixir **1.19+ ya no publica `elixir-otp-26.zip`** (requiere OTP 27+); por eso
> fijamos **1.18.5**. Si subes a OTP 27 con kerl, usa `elixir-otp-27.zip` y
> puedes ir a 1.19/1.20.

---

## Opción C — asdf (versiones fijadas y reproducibles entre estudiantes)

`asdf` (≥ 0.16) es un **binario** (ya no el `git clone` + `asdf.sh` de las
guías viejas). El plugin de Elixir descarga el precompilado; el de Erlang
**compila** OTP (~7 min en `t4g.large`).

```bash
# 1) asdf binario
ASDF_VER=0.18.0
curl -sLo /tmp/asdf.tgz \
  https://github.com/asdf-vm/asdf/releases/download/v${ASDF_VER}/asdf-v${ASDF_VER}-linux-arm64.tar.gz
mkdir -p ~/.asdf/bin && tar -xzf /tmp/asdf.tgz -C ~/.asdf/bin

cat >> ~/.bashrc << 'EOF'
export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
export ASDF_DATA_DIR="$HOME/.asdf"
EOF
export PATH="$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH"
export ASDF_DATA_DIR="$HOME/.asdf"
asdf --version                   # asdf version v0.18.0 ...

# 2) dependencias para compilar Erlang (headless, sin wx)
sudo apt install -y build-essential autoconf m4 libncurses-dev \
  libssl-dev unixodbc-dev curl git
export KERL_CONFIGURE_OPTIONS="--without-wx --without-javac --without-observer"

# 3) plugins e instalación
asdf plugin add erlang
asdf plugin add elixir
asdf install erlang 26.2.5              # ~7 min
asdf install elixir 1.18.5-otp-26       # precompilado, segundos
```

Fija las versiones del proyecto (genera `.tool-versions` en la raíz del repo):

```bash
cd ~/programacionlogicayfuncional
asdf set erlang 26.2.5
asdf set elixir 1.18.5-otp-26
cat .tool-versions
# erlang 26.2.5
# elixir 1.18.5-otp-26
```

> En asdf ≥ 0.16 el comando es `asdf set` (antes era `asdf local`). Cualquiera
> que clone el repo y ejecute `asdf install` (sin argumentos) obtiene
> exactamente estas versiones.

---

## Herramientas de proyecto: mix, Hex y rebar3

`mix` viene con Elixir. La primera vez instala Hex (paquetes) y rebar3 (build de
deps Erlang):

```bash
mix local.hex --force
mix local.rebar --force
```

### Primer proyecto

```bash
mix new saludo --module Saludo
cd saludo
mix test          # 1 doctest, 1 test, 0 failures
iex -S mix        # REPL con el proyecto cargado
```

```elixir
iex(1)> Saludo.hello()
:world
```

Estructura que genera `mix new`:

```
saludo/
├── lib/saludo.ex        # código
├── test/saludo_test.exs # pruebas (ExUnit)
├── mix.exs              # proyecto y dependencias
└── .formatter.exs       # reglas de `mix format`
```

### Agregar una dependencia (ejemplo: `jason` para JSON)

En `mix.exs`:

```elixir
defp deps do
  [
    {:jason, "~> 1.4"}
  ]
end
```

```bash
mix deps.get      # resuelve jason 1.4.x de Hex
mix deps.compile
mix run -e 'IO.puts(Jason.encode!(%{curso: "PLF", unidad: 2}))'
# {"curso":"PLF","unidad":2}
```

> `mix run` ejecuta con `-e 'código'` o un archivo `.exs`; **no** lee de stdin
> con `-` (eso es de otros REPL).

---

## GenServer con sintaxis moderna (unidad 2)

Un contador como proceso con estado (`start_link/1`, `@impl true`,
`GenServer.call/cast`). Guárdalo en `lib/contador.ex` de un proyecto `mix new`:

```elixir
defmodule Contador do
  use GenServer

  # --- API pública (corre en el proceso llamador) ---

  def start_link(inicial \\ 0) do
    GenServer.start_link(__MODULE__, inicial, name: __MODULE__)
  end

  def incrementar(n \\ 1), do: GenServer.cast(__MODULE__, {:incrementar, n})
  def valor, do: GenServer.call(__MODULE__, :valor)

  # --- Callbacks (corren en el proceso del GenServer) ---

  @impl true
  def init(inicial), do: {:ok, inicial}

  @impl true
  def handle_cast({:incrementar, n}, estado), do: {:noreply, estado + n}

  @impl true
  def handle_call(:valor, _from, estado), do: {:reply, estado, estado}
end
```

Prueba (verificada en OTP 25 y OTP 26):

```bash
mix run -e 'Contador.start_link(10); Contador.incrementar(); Contador.incrementar(5); IO.puts(Contador.valor())'
# 16
```

O en `iex -S mix`:

```elixir
iex(1)> Contador.start_link(10)
{:ok, #PID<0.150.0>}
iex(2)> Contador.incrementar(5)
:ok
iex(3)> Contador.valor()
15
```

`cast` es asíncrono; `call` es síncrono (bloquea hasta el `{:reply, ...}`). El
estado vive dentro del proceso: si muere, se reinicia — de ahí que en producción
un `Supervisor` lo reinicie (patrón "let it crash"; ver
[03_erlang.md](03_erlang.md)).

---

## Editor / LSP

Para autocompletado, ir a definición y errores en vivo: **ElixirLS**.
En VS Code: extensión "ElixirLS". En Neovim: `elixir-ls` vía `mason.nvim`.
Requiere que `elixir` y `mix` estén en el `PATH` del editor (con asdf: abre el
editor desde una terminal donde `elixir --version` funcione, o `asdf reshim`).

`mix format` aplica el estilo estándar (sin configuración): córrelo antes de
entregar cualquier práctica.

```bash
mix format
mix format --check-formatted   # falla si algo no está formateado (útil en CI)
```

---

## Verificación

```bash
elixir --version
```

Pipe operator (unidad 2):

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

---

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `unzip: command not found` (Opción B) | `sudo apt install unzip` |
| `elixir: command not found` (Opción B) | `export PATH=/opt/elixir/bin:$PATH` o reabre sesión |
| Crash al arrancar `iex` | Zip `-otp-26` sobre OTP 25 (o al revés): activa el OTP que coincide |
| `404` al bajar `elixir-otp-26.zip` | Elixir ≥ 1.19 ya no lo publica; usa `ELIXIR_VER=1.18.5` o sube a OTP 27 |
| `asdf: command not found` tras instalar | Falta `~/.asdf/bin` en el PATH (paso 1 de la Opción C) |
| `asdf local` da error | En asdf ≥ 0.16 es `asdf set` |
| `asdf install erlang` falla al compilar wx | `export KERL_CONFIGURE_OPTIONS="--without-wx"` antes de instalar |
| `mix` pide Hex | `mix local.hex --force` la primera vez |
| `mix deps.get` no resuelve nada | Sin conexión o falta Hex: `mix local.hex --force` y reintenta |
| `iex` no autocompleta módulos del proyecto | Arráncalo con `iex -S mix`, no `iex` a secas |
