# 1 · SWI-Prolog 9.x — Ubuntu 24.04 ARM64

Guía autocontenida. El curso requiere **SWI-Prolog 9.x** (unidad 1, unidad 4 y
proyectos finales usan CLP(FD), que viene incluido).

## Opción A — apt (recomendada, ~1 minuto)

Ubuntu 24.04 (noble) trae SWI-Prolog **9.0.4** en sus repos oficiales, con
build ARM64 nativo:

```bash
sudo apt update
sudo apt install -y swi-prolog
swipl --version
# SWI-Prolog version 9.0.4 for aarch64-linux
```

> En Ubuntu 22.04 (jammy) `apt` instala 8.4.x — **no** cumple el requisito del
> curso. Usa Ubuntu 24.04 o la Opción B.

## Opción B — PPA oficial (última versión estable)

El equipo de SWI-Prolog mantiene el PPA `swi-prolog/stable`:

```bash
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:swi-prolog/stable
sudo apt update
sudo apt install -y swi-prolog
```

> ⚠️ Verifica que el PPA tenga build `arm64` para tu versión de Ubuntu; si
> `apt` reporta "Unable to locate package" en aarch64, regresa a la Opción A.

## Opción C — Compilar desde fuente (versión exacta)

Solo si necesitas una versión específica no empaquetada:

```bash
sudo apt update
sudo apt install -y build-essential cmake ninja-build pkg-config \
  libgmp-dev libssl-dev unixodbc-dev zlib1g-dev libreadline-dev \
  libedit-dev libarchive-dev libpcre2-dev
git clone --depth 1 --branch V9.2.9 https://github.com/SWI-Prolog/swipl-devel.git
cd swipl-devel
git submodule update --init --depth 1
cmake -DCMAKE_BUILD_TYPE=Release -G Ninja -B build
cmake --build build
sudo cmake --install build
```

Tiempo aproximado en `t4g.micro`: 25–40 min.

## Verificación

```bash
swipl --version
```

Prueba interactiva con CLP(FD) (lo usamos en la unidad 4):

```bash
swipl
```

```prolog
?- use_module(library(clpfd)).
true.

?- X #> 3, X #< 6, label([X]).
X = 4 ;
X = 5.

?- halt.
```

Prueba no interactiva (útil para scripts de CI):

```bash
swipl -g "use_module(library(clpfd)), X #= 2+2, format('2+2=~w~n',[X])" -t halt
# 2+2=4
```

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `swipl: command not found` | Cierra y reabre la sesión SSH, o `hash -r` |
| Versión 8.x instalada | Estás en Ubuntu 22.04 — usa Opción B o migra a 24.04 |
| `library(clpfd)` no existe | Instalaste un paquete mínimo; `sudo apt install swi-prolog` (no `swi-prolog-core`) |
