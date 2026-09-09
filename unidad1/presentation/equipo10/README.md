# Equipo 10 — Elm
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | RAMIREZ BAUTISTA, IRENE | Contexto e historia |
| 2 | RODRIGUEZ GALLARDO, HOWARD | Modelo de cómputo y sintaxis |
| 3 | SALCIDO MAGAÑA, MONICA | Sistema de tipos / runtime |
| 4 | SANTOYO TORRES, SANTOS ABRAHAM | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 2012 (Evan Czaplicki)
- **Creador(es):** _(completar)_
- **Modelo de evaluación:** estricto
- **Sistema de tipos:** estático, inferencia; funcional **puro**; compila a JavaScript
- **REPL / herramienta:** `elm repl` / `elm reactor`
- **Caso real verificado (obligatorio en pantalla):** NoRedInk — interfaces educativas en producción con Elm, "cero errores de runtime". _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — llevar la pureza funcional al frontend; la promesa de "sin excepciones en runtime".
2. **Modelo de cómputo (3 min)** — funciones puras, inmutabilidad, `case` exhaustivo, arquitectura Model–Update–View (*The Elm Architecture*).
3. **Tipos / runtime (3 min)** — inferencia; `Maybe`/`Result` en vez de `null`/excepciones; mensajes de error del compilador como caso de estudio.
4. **Demo en vivo (4 min)** — `elm repl` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (`List.filter`/`List.map` o `case` sobre `Maybe`).
5. **Caso real + cierre (2 min)** — NoRedInk con referencia IEEE; conexión con Haskell y Gleam (funcionales puros/tipados que compilan a otro objetivo).

## Comandos exactos del demo

```bash
# Instalación
npm install -g elm        # requiere Node
# o: brew install elm

# Hola Paradigma (imprimir 1..10)
elm repl
> List.range 1 10
> List.range 1 10 |> List.map String.fromInt |> String.join "\n"

# Segundo ejemplo idiomático
> List.range 1 10 |> List.filter (\n -> modBy 2 n == 0) |> List.map (\n -> n * n)
```

Salida esperada:

```
[1,2,3,4,5,6,7,8,9,10] : List Int
"1\n2\n3\n4\n5\n6\n7\n8\n9\n10" : String
[4,16,36,64,100] : List Int
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
