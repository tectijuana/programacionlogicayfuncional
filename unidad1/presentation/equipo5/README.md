# Equipo 5 — OCaml
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | GARCIA RODRIGUEZ, MARCOS DANIEL | Contexto e historia |
| 2 | GOMEZ CUEVAS, CARLOS | Modelo de cómputo y sintaxis |
| 3 | GONZALEZ CRISTOBAL, OMAR | Sistema de tipos / runtime |
| 4 | GRANDE ORTEGA, MAXIMILIANO | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 1996 (INRIA), linaje ML/Caml
- **Creador(es):** _(completar)_
- **Modelo de evaluación:** estricto
- **Sistema de tipos:** estático, inferencia Hindley-Milner, `option`, tipos algebraicos, módulos y *functors*
- **REPL / herramienta:** `ocaml` / `utop` / `dune`
- **Caso real verificado (obligatorio en pantalla):** Meta — Flow, Hack e Infer analizan 100+ M de líneas al día. _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — por qué Meta escribe sus analizadores de código en OCaml.
2. **Modelo de cómputo (3 min)** — funciones, `match`, tipos algebraicos exhaustivos.
3. **Tipos / runtime (3 min)** — inferencia sin anotaciones; `option` frente a `null`; el sistema de módulos.
4. **Demo en vivo (4 min)** — `utop` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (`match` sobre una variante o `List.filter_map`).
5. **Caso real + cierre (2 min)** — Meta/Flow con referencia IEEE; conexión con Haskell, F# y el demo de la Tarea 1.2.

## Comandos exactos del demo

```bash
# Instalación
brew install ocaml opam && opam install utop   # macOS
sudo apt install ocaml opam && opam install utop

# Hola Paradigma (imprimir 1..10)
utop
utop# List.iter (Printf.printf "%d\n") (List.init 10 (fun i -> i + 1));;

# Segundo ejemplo idiomático
utop# type figura = Circulo of float | Cuadrado of float;;
utop# let area = function Circulo r -> 3.1416 *. r *. r | Cuadrado l -> l *. l;;
utop# area (Circulo 2.0);;
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
- : float = 12.5664
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
