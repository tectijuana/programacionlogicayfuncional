# Instalación de entornos — Ubuntu Linux ARM64

Guías de instalación **independientes** para replicar el entorno del curso.
Cada documento es autocontenido: entra directo al software que te interesa.

Plataforma objetivo: **Ubuntu 24.04 LTS (noble) para ARM64/aarch64**, ya sea en
una instancia EC2 Graviton (AWS Academy) o en hardware físico (Raspberry Pi).

## Índice

| # | Documento | Software | Versión objetivo del curso |
|---|-----------|----------|---------------------------|
| 0 | [00_aws_academy_cloudshell.md](00_aws_academy_cloudshell.md) | AWS Academy + CloudShell + EC2 ARM64 | Ubuntu 24.04 ARM64 (t4g) |
| 1 | [01_prolog.md](01_prolog.md) | SWI-Prolog | 9.x |
| 2 | [02_erlang.md](02_erlang.md) | Erlang/OTP | 26+ |
| 3 | [03_haskell.md](03_haskell.md) | GHC (Haskell) | 9.x |
| 4 | [04_clojure.md](04_clojure.md) | Clojure (+ JDK) | CLI oficial |
| 5 | [05_elixir.md](05_elixir.md) | Elixir | 1.14+ |
| 6 | [06_ocaml.md](06_ocaml.md) | OCaml (opam) | 5.x |
| 7 | [07_raspberry_pi_zero2w.md](07_raspberry_pi_zero2w.md) | Prolog + Erlang en Raspberry Pi Zero 2W | script automatizado |

## Scripts

| Script | Uso |
|--------|-----|
| [scripts/lanzar-nodo-arm64.sh](scripts/lanzar-nodo-arm64.sh) | Lanza la instancia EC2 ARM64 desde AWS CloudShell |
| [scripts/install_pi_zero2w.sh](scripts/install_pi_zero2w.sh) | Instala SWI-Prolog y Erlang en Raspberry Pi Zero 2W |

## ¿Qué software usa cada parte del curso?

- **Unidad 1** (conceptos fundamentales): Python (contraste imperativo), Erlang/OTP 26+, SWI-Prolog 9.x
- **Unidad 2** (modelo funcional): Erlang/OTP 26+, Clojure, GHC/Haskell 9.x, Elixir 1.14+
- **Unidades 3–4** (programación lógica): SWI-Prolog 9.x, incluyendo CLP(FD) y plunit
- **OCaml**: solo para el demo del tema 1.2 — no es lenguaje evaluable del curso
- **Proyectos finales**: combinan al menos 3 paradigmas — Prolog + (Erlang/OTP o Clojure) + (Haskell o Elixir)

## Verificación rápida (todo instalado)

```bash
swipl --version        # SWI-Prolog 9.x o superior
erl -eval 'io:format("~s~n",[erlang:system_info(otp_release)]),halt().' -noshell
ghc --version          # GHC 9.x o superior
clojure --version
elixir --version
ocaml --version
```
