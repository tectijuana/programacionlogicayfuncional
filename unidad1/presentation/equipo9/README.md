# Equipo 9 — Gleam
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | PADILLA, DYLAN ALEXIS | Contexto e historia |
| 2 | PARRA ESPINOZA, HERIB ARTURO | Modelo de cómputo y sintaxis |
| 3 | PEREZ FLORES, ANDRES MANUEL | Sistema de tipos / runtime |
| 4 | PINEDA GOMEZ, RICARDO ALEJANDRO | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 2019 · versión 1.0 en 2024 (Louis Pilfold)
- **Creador(es):** _(completar)_
- **Modelo de evaluación:** estricto
- **Sistema de tipos:** estático, con inferencia; compila a Erlang (BEAM) y a JavaScript
- **REPL / herramienta:** `gleam shell` / `gleam run`
- **Caso real verificado (obligatorio en pantalla):** ecosistema BEAM — Gleam como alternativa **tipada** a Elixir/Erlang; proyecto joven con adopción creciente (v1.0, 2024). _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — por qué añadir tipos estáticos a la BEAM; qué problema de Erlang/Elixir resuelve.
2. **Modelo de cómputo (3 min)** — inmutabilidad, `case` exhaustivo, `use`, funciones puras, sin `null`.
3. **Tipos / runtime (3 min)** — inferencia; qué atrapa el compilador; interoperabilidad con Erlang/Elixir; corre sobre BEAM.
4. **Demo en vivo (4 min)** — `gleam` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (`case` sobre un tipo personalizado o `list.map`).
5. **Caso real + cierre (2 min)** — ecosistema BEAM con referencia IEEE; conexión con Erlang y Elixir (mismos equipos 3 y 4).

## Comandos exactos del demo

```bash
# Instalación
brew install gleam        # macOS (requiere Erlang)
# Linux: https://gleam.run/getting-started/installing/

# Proyecto mínimo
gleam new demo && cd demo

# Hola Paradigma (imprimir 1..10) — en src/demo.gleam
#   import gleam/io
#   import gleam/list
#   pub fn main() {
#     list.range(1, 10) |> list.each(fn(n) { io.println(int.to_string(n)) })
#   }
gleam run

# Segundo ejemplo idiomático (REPL)
gleam shell
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
- Cómo: `asciinema rec demo.cast` → `asciinema upload demo.cast`

## Diapositivas

- `slides.pdf` — 5–8 diapositivas, subir a esta carpeta **antes** de la sesión.

## Bibliografía (IEEE)

1. _(fuente 1)_
2. _(fuente 2)_
3. _(fuente 3)_

---

Rúbrica, medio de presentación y reglas: [`../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md`](../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md)
