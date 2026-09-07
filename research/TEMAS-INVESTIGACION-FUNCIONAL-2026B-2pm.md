---
title: "Proyecto de Investigación --- Programación Lógica y Funcional 2026 \"B\""
subtitle: "Lista complementaria 2pm: Programación Funcional (nivel introductorio) --- 16 temas de investigación"
author: "TecNM Campus Tijuana --- Ingeniería en Sistemas Computacionales (ISC-2006)"
date: "Septiembre 2026"
lang: es
geometry: "a4paper,margin=2.4cm"
fontsize: 11pt
---

# Presentación

Esta es la **lista complementaria del grupo de las 2pm** para la primera
investigación del curso Programación Lógica y Funcional 2026 "B". Cubre
exclusivamente el **paradigma funcional** (Erlang/OTP, Elixir, Haskell, OCaml,
Clojure, Scala, Gleam) a **nivel introductorio**.

Los 16 temas de esta lista fueron **revisados para no duplicarse** con:

- los **40 temas** de `research/TEMAS-INVESTIGACION-FUNCIONAL-2026B-4pm.md`,
- las investigaciones ya integradas en `research/`
  (*Gateway LLM tolerante a fallos con Erlang* y
  *Prolog y modelos de lenguaje grandes: aproximación neuro-simbólica*).

No se admiten temas repetidos ni variantes menores de un tema ya trabajado ni de
un tema de la lista de las 4pm; el docente asigna o confirma el tema por Google
Classroom. Hay **16 temas para 16 estudiantes**: asignación uno a uno.

## Entrega esperada

Carpeta personal dentro de `research/<nombre-del-tema>/` con:

- **`README.md`** --- título, introducción, desarrollo técnico (mínimo 500
  palabras), conclusiones y bibliografía en formato **IEEE**.
- **`anexo.md`** --- bitácora de uso de LLM: prompts reales, resultados obtenidos
  y reflexión crítica (¿ayudó?, ¿hubo sesgos o errores?). Obligatorio si se usó IA.
- *(Opcional)* código que compile/ejecute, diagramas y PDF de papers de referencia.

## Reglas del flujo Fork --- Pull Request

- No cambiar la ruta indicada ni renombrar `README.md`.
- No modificar archivos ajenos ni el `README.md` de otras carpetas.
- Un Pull Request por estudiante, con commits claros y descriptivos.
- El PR que altere la estructura del repositorio se **rechaza** sin calificación.

## Reglas de contenido (según `CLAUDE.md` y `casos_reales_mundo_real.md`)

- Todo ejemplo de código debe compilar/ejecutar; el pseudocódigo se etiqueta como tal.
- Erlang: usar comportamientos OTP (`gen_server`, `supervisor`), nunca `spawn` sin supervisión.
- Haskell: `Maybe`/`Either` para errores, nunca funciones parciales sobre listas arbitrarias.
- OCaml: separar la firma `.mli` de la implementación `.ml`.
- Casos de industria: solo afirmaciones verificables con fuente (WhatsApp/Erlang,
  Discord/Elixir, Nubank/Clojure, Jane Street/OCaml, Standard Chartered/Haskell).
  No atribuir a organizaciones locales (IMSS, SAT, maquiladoras) un stack concreto sin fuente directa.

\newpage

# Los 16 temas --- Bloque Funcional introductorio, grupo 2pm (2026 "B")

## Evaluación y modelo de cómputo

1. Evaluación perezosa frente a evaluación estricta: qué se calcula y cuándo, con ejemplos en Haskell y Elixir
2. Fold a la izquierda y fold a la derecha (`foldl` / `foldr`): diferencias, asociatividad y cuándo usar cada uno
3. Listas por comprensión (*list comprehensions*): sintaxis y traducción a `map`/`filter` en Haskell, Elixir y Python
4. Estructuras de datos persistentes e inmutables: cómo se "modifica" compartiendo memoria (Clojure, panorama introductorio)

## Tipos e inferencia (primer contacto)

5. Introducción a las clases de tipos (*type classes*) de Haskell con `Eq`, `Ord` y `Show`
6. Inferencia de tipos Hindley-Milner: qué es, qué garantiza y qué lenguajes la usan (Haskell, OCaml)
7. Funciones totales frente a funciones parciales: por qué se evitan `head` y `tail` sobre listas arbitrarias
8. El sistema de módulos y espacios de nombres: comparación introductoria entre Elixir, Haskell y OCaml (`.mli`)

## Control de flujo y manejo de errores

9. Control de flujo sin `if` anidados: guardas y expresiones `case` / `cond` en lenguajes funcionales
10. Manejo de errores funcional: `Either` / `Result` y el patrón "railway" frente a excepciones
11. Flujos perezosos con `Stream` en Elixir: procesar colecciones grandes sin cargarlas en memoria

## Práctica, medición y comparación

12. Comparación de sintaxis: definir e invocar una misma función en Haskell, Elixir, OCaml, Clojure y Erlang
13. Recursión de cola frente a bucles imperativos: medición de tiempo y memoria con un caso concreto (suma o Fibonacci)
14. El REPL como herramienta de aprendizaje: flujo de trabajo en GHCi, IEx y `clj`/`lein repl`
15. Un intérprete mínimo de expresiones aritméticas: árbol de sintaxis y evaluación recursiva con *pattern matching*
16. Validación de datos mexicanos (CURP y RFC) con funciones puras y de orden superior: `map`, `filter` y composición

\newpage

# Rúbrica de evaluación --- 5 categorías (100 puntos)

Se aplica la **misma rúbrica** que la lista de las 4pm
(`research/TEMAS-INVESTIGACION-FUNCIONAL-2026B-4pm.md`).

| # | Categoría | Pts | Qué se evalúa |
|:-:|:----------|:---:|:--------------|
| 1 | **Rigor técnico y profundidad** | 30 | Comprensión correcta y profunda del tema; exactitud de los conceptos; fuentes actualizadas y pertinentes; desarrollo técnico de al menos 500 palabras con datos, comparativas o ejemplos que compilan/ejecutan. |
| 2 | **Estructura y claridad del `README.md`** | 20 | Uso correcto de Markdown; organización lógica (introducción, desarrollo, conclusiones); redacción profesional y ortografía sin faltas graves. |
| 3 | **Originalidad y análisis crítico** | 20 | Síntesis y redacción propias; el texto no es una copia de la salida de un LLM; hay interpretación, comparación entre lenguajes o paradigmas y postura argumentada del estudiante. |
| 4 | **Uso del repositorio y flujo Fork --- Pull Request** | 15 | Ruta y nombre de carpeta correctos; `README.md` sin renombrar; no se tocan archivos ajenos; commits claros; un solo PR bien descrito. |
| 5 | **Bitácora de IA (`anexo.md`) y bibliografía IEEE** | 15 | `anexo.md` con prompts reales, resultados y reflexión honesta sobre el uso de IA; bibliografía con fuentes confiables (IEEE, libros, papers, sitios oficiales) y formato IEEE correcto. |

## Escala de desempeño por categoría

| Nivel | Porcentaje de la categoría | Descripción |
|:------|:--------------------------:|:------------|
| Excelente | 90--100 % | Cumple todos los criterios con evidencia sólida y sin observaciones. |
| Satisfactorio | 75--89 % | Cumple lo esencial con observaciones menores. |
| Suficiente | 60--74 % | Cumple parcialmente; faltan elementos o hay imprecisiones. |
| Insuficiente | 0--59 % | No cumple el criterio mínimo o hay copia sin análisis. |

## Penalizaciones

- **Tema duplicado** (respecto de `research/`, de la lista de las 4pm o de otro
  compañero de las 2pm) o variante menor: se devuelve el PR sin calificar hasta reasignar tema.
- **Afirmación de industria sin fuente verificable**: categoría 1 con penalización según gravedad.
- **Código que no compila/ejecuta** presentado como funcional: penalización en categoría 1.
- **Alteración de la estructura del repositorio** o de archivos ajenos: PR rechazado (categoría 4 en 0).
- **Uso de IA no declarado** detectado: categorías 3 y 5 en 0 y reporte de
  integridad académica según [`AI_GUIDANCE.md`](../AI_GUIDANCE.md).
- **Entrega tardía**: según las políticas del curso.

---

*Documento del curso Programación Lógica y Funcional (ISC-2006), semestre 2026 "B".
Lista complementaria del grupo de las 2pm. Referencias del curso:
[`SYLLABUS.md`](../SYLLABUS.md), [`README.md`](../README.md),
[`AI_GUIDANCE.md`](../AI_GUIDANCE.md),
[`casos_reales_mundo_real.md`](../casos_reales_mundo_real.md).*
