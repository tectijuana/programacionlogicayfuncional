# Equipo 7 — Scala 3
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | LUIS JUAN CAMACHO, CESAR ADRIAN | Contexto e historia |
| 2 | MALDONADO AVENDAÑO, VALERIA | Modelo de cómputo y sintaxis |
| 3 | MARTINEZ GARCIA, SEBASTIAN | Sistema de tipos / runtime |
| 4 | MARTINEZ MARTA, JORGE EMILIANO | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 2004 (Martin Odersky) · Scala 3 en 2021
- **Creador(es):** _(completar)_
- **Modelo de evaluación:** estricto; `LazyList` para diferido
- **Sistema de tipos:** estático, muy expresivo; híbrido FP/OOP sobre la JVM
- **REPL / herramienta:** `scala` (scala-cli) / `sbt`
- **Caso real verificado (obligatorio en pantalla):** Apache Spark — motor de procesamiento de datos distribuido escrito en Scala. _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — unir objetos y funciones en la JVM; por qué Spark nace en Scala.
2. **Modelo de cómputo (3 min)** — `val` inmutable, funciones de orden superior, `for`-comprehensions, `case class` + `match`.
3. **Tipos / runtime (3 min)** — inferencia local, `Option`, qué atrapa el compilador; corre sobre la JVM.
4. **Demo en vivo (4 min)** — `scala` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (`case class` con *pattern matching* o pipeline con `map`/`filter`).
5. **Caso real + cierre (2 min)** — Apache Spark con referencia IEEE; conexión con F#, OCaml y Clojure (JVM).

## Comandos exactos del demo

```bash
# Instalación
brew install scala-cli    # macOS
# Linux: https://scala-cli.virtuslab.org/install

# Hola Paradigma (imprimir 1..10)
scala-cli repl
scala> (1 to 10).foreach(println)

# Segundo ejemplo idiomático
scala> (1 to 10).filter(_ % 2 == 0).map(n => n * n).toList
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
val res1: List[Int] = List(4, 16, 36, 64, 100)
```

## Grabación de respaldo (asciinema cloud)

- URL: _(pegar la URL de asciinema.org tras `asciinema upload`)_
- Cómo: `asciinema rec demo.cast` → `asciinema upload demo.cast`

## Diapositivas

- `slides.pdf` — 5–8 diapositivas, subir a esta carpeta **antes** de la sesión.

## Bibliografía (IEEE)

1. _(fuente 1)_
2. _(fuente 2)_
3. _(fuente 3)_

---

Rúbrica, medio de presentación y reglas: [`../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md`](../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md)
