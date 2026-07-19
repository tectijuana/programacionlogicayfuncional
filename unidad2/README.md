# Unidad 2 — Modelo de Programación Funcional

**TecNM Tijuana · Ingeniería en Sistemas Computacionales**
**Programación Lógica y Funcional**

---

## Objetivo de la unidad

Dominar los fundamentos del paradigma funcional a través de cuatro lenguajes de producción:
Erlang (inmutabilidad y pattern matching), Clojure (funciones de orden superior),
Haskell (tipos algebraicos y recursión) y Elixir (evaluación perezosa).

Al final de la unidad, el alumno habrá construido un sistema OTP completo con
supervisión automática de fallos.

---

## Estructura

| Tema | Contenido | Lenguaje principal |
|------|-----------|--------------------|
| [2.1](tema2.1/) | Fundamentos: inmutabilidad y pattern matching | Erlang |
| [2.2](tema2.2/) | Funciones de primera clase y orden superior | Clojure |
| [2.3](tema2.3/) | Recursión y estructuras de datos inmutables | Haskell |
| [2.4](tema2.4/) | Evaluación perezosa (Lazy Evaluation) | Haskell + Elixir |
| [2.5](tema2.5/) | Proyecto: sistema OTP con supervisión | Erlang/OTP |

---

## Requisitos del sistema

```bash
# Erlang/OTP
brew install erlang          # macOS
apt install erlang            # Ubuntu/Debian

# Clojure
brew install clojure          # macOS
# o descargar desde https://clojure.org/guides/install_clojure

# Haskell (GHC)
brew install ghc              # macOS
# o https://www.haskell.org/ghcup/

# Elixir
brew install elixir           # macOS
apt install elixir            # Ubuntu/Debian
```

---

## Evaluación

Esquema global del [sílabo](../SYLLABUS.md#evaluación): prácticas 40 % ·
proyecto integrador 40 % · exposición 20 %. En esta unidad el rubro central
se compone del **sistema OTP con supervisión (tema 2.5)** y el
**Examen Parcial 1** (U1–U2, sem. 9), promediados.

## Regla de entrega

> **Todo el código entregado debe compilar y ejecutarse.**
> Pseudocódigo = calificación 0. Sin excepciones.
