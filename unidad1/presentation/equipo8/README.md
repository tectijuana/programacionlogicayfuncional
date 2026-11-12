# Equipo 8 — F#

## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|---|---|---|
| 1 | MEDRANO VARGAS, STEPHANIE ARIANA | Contexto e historia |
| 2 | MIJANGOS GARIBAY, EMILY | Modelo de cómputo y sintaxis |
| 3 | NEYRA MENDEZ, ANGEL CASSIEL | Sistema de tipos / runtime |
| 4 | NOLASCO AYALA, GAEL | Demo en vivo + caso real |

## Archivos del equipo

| Rol | Archivo |
|---|---|
| 1 — Contexto e historia | [contexto-historia.md](contexto-historia.md) |
| 2 — Modelo de cómputo y sintaxis | [modelo-computo-sintaxis.md](modelo-computo-sintaxis.md) |
| 3 — Sistema de tipos / runtime | [tipos-runtime.md](tipos-runtime.md) |
| 4 — Demo en vivo + caso real | [demo-caso-real.md](demo-caso-real.md) |

## Datos del lenguaje

- **Año / origen:** 2005 (Microsoft Research, Don Syme), linaje OCaml
- **Creador(es):** Don Syme (Microsoft Research)
- **Modelo de evaluación:** estricto; `seq`/`lazy` para diferido
- **Sistema de tipos:** estático, inferencia Hindley-Milner, `Option`, records, uniones discriminadas
- **REPL / herramienta:** `dotnet fsi`
- **Caso real verificado (obligatorio en pantalla):** Jet.com / Walmart y análisis financiero en .NET con F# (fuente IEEE abajo y en [demo-caso-real.md](demo-caso-real.md))

## Guion (12–15 min)

1. **Contexto (2 min)** — llevar el modelo de OCaml al ecosistema .NET. → [contexto-historia.md](contexto-historia.md)
2. **Modelo de cómputo (3 min)** — inmutabilidad por defecto, `|>`, funciones de orden superior, pattern matching. → [modelo-computo-sintaxis.md](modelo-computo-sintaxis.md)
3. **Tipos / runtime (3 min)** — inferencia; `Option` frente a `null`; interoperabilidad con C#/.NET. → [tipos-runtime.md](tipos-runtime.md)
4. **Demo en vivo (4 min)** — `dotnet fsi` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (unión discriminada con `match` o pipeline con `|>`). → [demo-caso-real.md](demo-caso-real.md)
5. **Caso real + cierre (2 min)** — Jet.com/Walmart con referencia IEEE; conexión con OCaml, Haskell y Scala. → [demo-caso-real.md](demo-caso-real.md)

## Comandos exactos del demo

Instalación:

```bash
brew install dotnet        # macOS
# Linux: https://dotnet.microsoft.com/download
```

Iniciar F# Interactive:

```bash
dotnet fsi
```

Hola Paradigma (imprimir 1..10) y segundo ejemplo idiomático:

```fsharp
[1..10] |> List.iter (printfn "%d");;
[1..10] |> List.filter (fun n -> n % 2 = 0) |> List.map (fun n -> n * n);;
```

Salida esperada:

```text
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
val it: unit = ()
val it: int list = [4; 16; 36; 64; 100]
```

Para salir de FSI: `#quit;;`

## Grabación de respaldo (asciinema cloud)

- **URL:** [https://asciinema.org/a/tImzCXKi1FgN3pfu](https://asciinema.org/a/tImzCXKi1FgN3pfu)

## Diapositivas
<img width="1920" height="1080" alt="1" src="https://github.com/user-attachments/assets/10e01d33-eaf6-45c0-a9a3-c330dbd4068c" />
<img width="1920" height="1080" alt="2" src="https://github.com/user-attachments/assets/dd69c34c-1113-4d8b-b24f-e0e2b76a9589" />
<img width="1920" height="1080" alt="4" src="https://github.com/user-attachments/assets/cda8cffe-5b69-4d98-b0c0-58e475ce9ebe" />
<img width="1920" height="1080" alt="5" src="https://github.com/user-attachments/assets/9b417f1d-1a4c-47cc-ada5-2fc5f2f9a208" />
<img width="1920" height="1080" alt="6" src="https://github.com/user-attachments/assets/6402073c-4d3a-4bbb-8025-5c378faf3831" />
<img width="1920" height="1080" alt="7" src="https://github.com/user-attachments/assets/5a279fec-6dad-417b-8eae-d7bb80fbe20d" />
<img width="1920" height="1080" alt="8" src="https://github.com/user-attachments/assets/f43e4590-0e6b-4b26-8f90-518178e8d3b8" />
<img width="1920" height="1080" alt="9" src="https://github.com/user-attachments/assets/6374e4af-3074-4d95-a052-984e201af50f" />
<img width="1920" height="1080" alt="13" src="https://github.com/user-attachments/assets/2b6d6151-c12f-4848-b4a2-869577c298ca" />

## Bibliografía (IEEE)

**Rol 1 — Contexto e historia** ([contexto-historia.md](contexto-historia.md))

1. P. Hudak, "Conception, evolution, and application of functional programming languages," *ACM Computing Surveys*, vol. 21, no. 3, pp. 359–411, 1989, doi: 10.1145/72551.72554.
2. J. McCarthy, "History of LISP," *ACM SIGPLAN Notices*, vol. 13, no. 8, pp. 217–223, 1978, doi: 10.1145/960118.808387.
3. D. Syme, "The early history of F#," *Proc. ACM Program. Lang.*, vol. 4, no. HOPL, art. 75, 2020, doi: 10.1145/3386325.
4. Microsoft, "F# documentation," *Microsoft Learn*. [En línea]. Disponible en: <https://learn.microsoft.com/dotnet/fsharp/>
5. G. Tan, "A brief history of functional programming," Penn State University. [En línea]. Disponible en: <https://www.cse.psu.edu/~gxt29/historyOfFP/historyOfFP.html>
6. I. V. Barrios, "Programación funcional," Platzi. [En línea]. Disponible en: <https://platzi.com/blog/programacion-funcional> (divulgación)
7. Coco Solution, "Introducción a la programación funcional." [En línea]. Disponible en: <https://cocosolution.com/blog/programacion-funcional> (divulgación)

**Rol 2 — Modelo de cómputo y sintaxis** ([modelo-computo-sintaxis.md](modelo-computo-sintaxis.md))

8. Microsoft, "Values - F#," *Microsoft Learn*. [En línea]. Disponible en: <https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/values/>. [Consultado: 31-oct-2026].
9. Microsoft, "Functions - F#," *Microsoft Learn*. [En línea]. Disponible en: <https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/functions/>. [Consultado: 31-oct-2026].
10. Microsoft, "Pattern Matching - F#," *Microsoft Learn*. [En línea]. Disponible en: <https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/pattern-matching>. [Consultado: 31-oct-2026].
11. Microsoft, "F# Language Reference," *Microsoft Learn*. [En línea]. Disponible en: <https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/>. [Consultado: 31-oct-2026].
12. Microsoft, "F# coding conventions," *Microsoft Learn*. [En línea]. Disponible en: <https://learn.microsoft.com/dotnet/fsharp/style-guide/conventions>. [Consultado: 31-oct-2026].

**Rol 3 — Sistema de tipos / runtime** ([tipos-runtime.md](tipos-runtime.md))

13. Microsoft, "Type Inference - F#," *Microsoft Learn*. [En línea]. Disponible en: <https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/type-inference>. [Consultado: 12-nov-2026].
14. Microsoft, "Options - F#," *Microsoft Learn*. [En línea]. Disponible en: <https://learn.microsoft.com/dotnet/fsharp/language-reference/options>. [Consultado: 12-nov-2026].
15. Microsoft, "F# component design guidelines," *Microsoft Learn*. [En línea]. Disponible en: <https://learn.microsoft.com/dotnet/fsharp/style-guide/component-design-guidelines>. [Consultado: 12-nov-2026].

**Rol 4 — Demo en vivo + caso real** ([demo-caso-real.md](demo-caso-real.md))

16. A. Brewbaker, "How Jet Built a GPU-Powered Fulfillment Engine with F# and CUDA," *NVIDIA Technical Blog*, Nov. 30, 2017. [En línea]. Disponible en: <https://developer.nvidia.com/blog/jet-gpu-powered-fulfillment/>. [Consultado: 31-oct-2026].
17. R. Reese, "Case Study: Writing Microservices with F#," *CODE Magazine*, nov.-dic. 2016. [En línea]. Disponible en: <https://www.codemag.com/article/1611071/Case-Study-Writing-Microservices-with-F>. [Consultado: 31-oct-2026].
18. Reuters, "Wal-Mart completes acquisition of Jet.com," Sep. 19, 2016. [En línea]. Disponible en: <https://www.reuters.com/article/us-walmart-jet-com-idUSKCN11P27U/>. [Consultado: 31-oct-2026].

Rúbrica, medio de presentación y reglas: [../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md](../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md)
