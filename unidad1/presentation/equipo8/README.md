# Equipo 8 — F#
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | MEDRANO VARGAS, STEPHANIE ARIANA | Contexto e historia |
| 2 | MIJANGOS GARIBAY, EMILY | Modelo de cómputo y sintaxis |
| 3 | NEYRA MENDEZ, ANGEL CASSIEL | Sistema de tipos / runtime |
| 4 | NOLASCO AYALA, GAEL | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 2005 (Microsoft Research, Don Syme), linaje OCaml
- **Creador(es):** _(completar)_
- **Modelo de evaluación:** estricto; `seq`/`lazy` para diferido
- **Sistema de tipos:** estático, inferencia Hindley-Milner, `Option`, *records*, uniones discriminadas
- **REPL / herramienta:** `dotnet fsi`
- **Caso real verificado (obligatorio en pantalla):** Jet.com / Walmart y análisis financiero en .NET con F#. _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — llevar el modelo de OCaml al ecosistema .NET.
2. **Modelo de cómputo (3 min)** — inmutabilidad por defecto, `|>`, funciones de orden superior, *pattern matching*.
3. **Tipos / runtime (3 min)** — inferencia; `Option` frente a `null`; interoperabilidad con C#/.NET.
4. **Demo en vivo (4 min)** — `dotnet fsi` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (unión discriminada con `match` o pipeline con `|>`).
5. **Caso real + cierre (2 min)** — Jet.com/Walmart con referencia IEEE; conexión con OCaml, Haskell y Scala.

## Comandos exactos del demo

```bash
# Instalación
brew install dotnet        # macOS
# Linux: https://dotnet.microsoft.com/download

# Hola Paradigma (imprimir 1..10)
dotnet fsi
> [1..10] |> List.iter (printfn "%d");;

# Segundo ejemplo idiomático
> [1..10] |> List.filter (fun n -> n % 2 = 0) |> List.map (fun n -> n * n);;
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
val it: int list = [4; 16; 36; 64; 100]
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
