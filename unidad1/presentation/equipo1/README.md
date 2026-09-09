# Equipo 1 — Lisp / Scheme
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | AGUILAR AGUILAR, LUIS DANIEL | Contexto e historia |
| 2 | AGUIRRE DAVILA, HUGO IRAM | Modelo de cómputo y sintaxis |
| 3 | BALLESTEROS CRUZ, ALDO JUVENTINO | Sistema de tipos / runtime |
| 4 | BARAJAS CARPIO, ENRIQUE | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 1958 (Lisp, John McCarthy) · Scheme 1975 (Sussman y Steele)
- **Creador(es):** _(completar)_
- **Modelo de evaluación:** _(estricto; `delay`/`force` para perezoso)_
- **Sistema de tipos:** _(dinámico; completar)_
- **REPL / herramienta:** `racket` o `mit-scheme` / `guile`
- **Caso real verificado (obligatorio en pantalla):** IA simbólica histórica; Scheme como lenguaje de *Structure and Interpretation of Computer Programs* (MIT). _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — de dónde sale la idea de "código como datos" y por qué sigue viva.
2. **Modelo de cómputo (3 min)** — listas, `car`/`cdr`, recursión, ausencia de bucles.
3. **Tipos / runtime (3 min)** — tipado dinámico; qué se descubre solo en ejecución; el REPL como entorno de desarrollo.
4. **Demo en vivo (4 min)** — REPL + "Hola Paradigma" (imprimir 1..10) + un 2.º ejemplo idiomático (recursión sobre listas o una macro simple).
5. **Caso real + cierre (2 min)** — el caso de arriba con referencia IEEE en pantalla; conexión con Clojure, Haskell y Elixir del curso.

## Comandos exactos del demo

```bash
# Instalación (elegir uno)
brew install minimal-racket      # macOS
sudo apt install racket          # Linux

# Hola Paradigma (imprimir 1..10)
racket -e '(for ([i (in-range 1 11)]) (displayln i))'

# Segundo ejemplo idiomático
# (completar: p. ej. suma recursiva de una lista)
```

Salida esperada:

```
1
2
3
4
5
6
7
8
9
10
```

## Grabación de respaldo (asciinema cloud)

- URL: _(pegar la URL de asciinema.org tras `asciinema upload`)_
- Cómo: `asciinema rec demo.cast` → `asciinema upload demo.cast` (o `asciinema auth` y `asciinema rec`)

## Diapositivas

- `slides.pdf` — 5–8 diapositivas, subir a esta carpeta **antes** de la sesión.

## Bibliografía (IEEE)

1. _(fuente 1)_
2. _(fuente 2)_
3. _(fuente 3)_

---

Rúbrica, medio de presentación y reglas: [`../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md`](../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md)
