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
- **Creador(es):** _John McCarthy (Lisp, 1958) y Gerald J. Sussman y Guy L. Steele Jr. (Scheme, 1975)._
- **Modelo de evaluación:** _(estricto; `delay`/`force` para perezoso)_
- **Sistema de tipos:** _Dinámico y fuertemente tipado (los tipos se verifican en tiempo de ejecución, no en compilación)._
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
# (suma recursiva de una lista)
racket -e '(define (suma-lista lst) (if (null? lst) 0 (+ (car lst) (suma-lista (cdr lst))))) (displayln (suma-lista (list 1 2 3 4 5)))'
```

Salida esperada 1 :

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
Salida esperada 2 :
```
15
```

## Grabación de respaldo (asciinema cloud)

- URL: _(https://asciinema.org/a/Qr0dumJwIND4f6rN)_
- Cómo: `asciinema rec demo.cast` → `asciinema upload demo.cast` (o `asciinema auth` y `asciinema rec`)

## Diapositivas

- `slides.pdf` — 5–8 diapositivas, subir a esta carpeta **antes** de la sesión.

## Bibliografía (IEEE)
[1] J. McCarthy, "Recursive functions of symbolic expressions and their computation by machine, Part I," Communications of the ACM, vol. 3, no. 4, pp. 184–195, Apr. 1960.

[2] H. Abelson, G. J. Sussman, and J. Sussman, Structure and Interpretation of Computer Programs, 2nd ed. Cambridge, MA, USA: MIT Press, 1996.

[3] H. Abelson, G. J. Sussman, and J. Sussman, Structure and Interpretation of Computer Programs, JavaScript ed. Cambridge, MA, USA: MIT Press, 2022.

[4] G. J. Sussman and G. L. Steele Jr., "Scheme: An interpreter for extended lambda calculus," MIT AI Lab, Cambridge, MA, USA, AI Memo 349, Dec. 1975.

[5] G. J. Sussman and G. L. Steele Jr., "Scheme: An interpreter for extended lambda calculus," Higher-Order and Symbolic Computation, vol. 11, no. 4, pp. 405–439, Dec. 1998.

[6] W. Sack, "A matter of interpretation: A review of Structure and Interpretation of Computer Programs (JavaScript edition)," Computational Culture, no. 9, 2023.

---

Rúbrica, medio de presentación y reglas: [`../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md`](../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md)
