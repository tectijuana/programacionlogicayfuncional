# Equipo 6 — Clojure
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | HERNANDEZ CUADRAS, ANA CECILIA | Contexto e historia |
| 2 | LARES MENA, ANGEL FERNANDO | Modelo de cómputo y sintaxis |
| 3 | LEPE GARCIA, CESAR | Sistema de tipos / runtime |
| 4 | LOPEZ MOLGADO, JORGE LUIS | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 2007 (Rich Hickey)
- **Creador(es):** _(completar)_
- **Modelo de evaluación:** estricto; secuencias perezosas (`lazy-seq`)
- **Sistema de tipos:** dinámico; sobre la JVM; estructuras persistentes e inmutables
- **REPL / herramienta:** `clj` / `clojure`
- **Caso real verificado (obligatorio en pantalla):** Nubank — banco digital más grande de América Latina, Clojure + Datomic. _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — "identidad mutable" como origen de los bugs de concurrencia (Rich Hickey, *Are We There Yet?*).
2. **Modelo de cómputo (3 min)** — Lisp sobre la JVM, datos inmutables, estructuras persistentes que comparten memoria.
3. **Tipos / runtime (3 min)** — `atom` para estado de un valor, `ref` + `dosync` (STM) para estado coordinado.
4. **Demo en vivo (4 min)** — `clj` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (`->>` con `map`/`filter`, o un `atom` con `swap!`).
5. **Caso real + cierre (2 min)** — Nubank con referencia IEEE; conexión con Lisp/Scheme y con la Tarea 1.3 (inmutabilidad).

## Comandos exactos del demo

```bash
# Instalación
brew install clojure/tools/clojure   # macOS
# Linux: https://clojure.org/guides/install_clojure

# Hola Paradigma (imprimir 1..10)
clj
user=> (doseq [i (range 1 11)] (println i))

# Segundo ejemplo idiomático
user=> (->> (range 1 11) (filter even?) (map #(* % %)))
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
(4 16 36 64 100)
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
