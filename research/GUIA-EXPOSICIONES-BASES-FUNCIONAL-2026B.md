---
title: "Guía académica de exposiciones --- Bases de la Programación Funcional 2026 \"B\""
subtitle: "Cómo dividir y secuenciar los temas de investigación para exponerlos en clase (grupos 2pm y 4pm)"
author: "TecNM Campus Tijuana --- Ingeniería en Sistemas Computacionales (ISC-2006)"
date: "Septiembre 2026"
lang: es
geometry: "a4paper,margin=2.4cm"
fontsize: 11pt
---

# Propósito

Los temas de investigación de
[`TEMAS-INVESTIGACION-FUNCIONAL-2026B-4pm.md`](TEMAS-INVESTIGACION-FUNCIONAL-2026B-4pm.md)
(40 temas) y
[`TEMAS-INVESTIGACION-FUNCIONAL-2026B-2pm.md`](TEMAS-INVESTIGACION-FUNCIONAL-2026B-2pm.md)
(16 temas) no son piezas sueltas: forman **un solo recorrido** por las bases de
la programación funcional. Esta guía dice **en qué orden exponerlos**, **cómo
agruparlos en sesiones** y **qué se le exige a cada exposición** para que la
suma de presentaciones equivalga a un capítulo completo del curso.

Unidad de planeación (según `CLAUDE.md`): **1 capítulo = 4 h × 4 sesiones = 16 h**.
El capítulo aquí es *Bases de la Programación Funcional*.

# Principio de división: por concepto, no por lenguaje

Se divide por **idea** (qué se aprende), no por lenguaje ni por estudiante. Cada
bloque temático agrupa exposiciones que:

1. comparten vocabulario y prerrequisitos,
2. se entienden mejor escuchadas seguidas,
3. dejan al grupo listo para el siguiente bloque.

Un tema mal ubicado (p. ej. hablar de *closures* antes de "funciones como
valores") rompe la cadena para todo el grupo, no solo para quien expone.

\newpage

# Los 7 bloques temáticos

| Bloque | Nombre | Idea central | Temas 4pm | Temas 2pm |
|:-:|:--|:--|:--|:--|
| **A** | Historia y antecedentes | De dónde viene el paradigma y por qué | 1--8 | --- |
| **B** | Conceptos fundamentales | Pureza, inmutabilidad, transparencia referencial, estado | 9--17 | 1, 4 |
| **C** | Funciones como valores | Primera clase, orden superior, composición, *closures*, *pipe* | 18--24 | 2, 3 |
| **D** | Recursión | Sustituir el bucle; recursión de cola; errores típicos | 25--29 | 13 |
| **E** | Datos y coincidencia de patrones | Listas inmutables, tuplas, ADT, `Maybe`/`Option`, `pattern matching` | 30--34 | 15, 16 |
| **F** | Tipos, módulos y flujo (primer contacto) | *Type classes*, Hindley-Milner, funciones totales, módulos, `case`/guardas, `Either` | 35 | 5--10 |
| **G** | Herramientas, medición e industria | REPL, `Stream`, comparación de sintaxis, dónde se usa hoy | 36--40 | 11, 12, 14 |

> Los temas 2pm son de **nivel introductorio reforzado**: encajan en los mismos
> bloques, pero varios pertenecen al bloque F (tipos y flujo), que en la lista de
> las 4pm casi no aparece. Por eso los dos grupos se complementan.

## Dependencias (qué se expone antes que qué)

```
A ──▶ B ──▶ C ──▶ D
              │     │
              ▼     ▼
              E ◀───┘
              │
              ▼
              F ──▶ G
```

- **A** no depende de nada: abre el capítulo.
- **B** es prerrequisito duro de todo lo demás.
- **C** antes de **D** y **E** (la recursión y el *pattern matching* se explican
  con funciones de orden superior a la vista).
- **F** necesita **E** (los ADT y `Maybe` sostienen *type classes* y `Either`).
- **G** cierra: solo tiene sentido cuando ya se vio todo lo anterior.

\newpage

# Calendario sugerido --- 4 sesiones de 4 h

Pensado para el **grupo 4pm (40 exposiciones)**. Ritmo: **~10 exposiciones por
sesión**, 12 min de exposición + 5 min de preguntas + 3 min de transición
(20 min por turno; con dos descansos de 15 min cabe en 4 h).

| Sesión | Bloques | Temas 4pm | Cierre de la sesión |
|:-:|:--|:--|:--|
| **S1** | A completo + inicio de B | 1--10 | El grupo distingue paradigmas y sabe qué es una función pura |
| **S2** | Resto de B + inicio de C | 11--20 | Inmutabilidad y estado claros; primeras funciones de orden superior |
| **S3** | Resto de C + D + inicio de E | 21--30 | Recursión de cola entendida; primeras listas inmutables |
| **S4** | Resto de E + F + G | 31--40 | `pattern matching`, primer contacto con lenguajes, panorama de industria |

**Grupo 2pm (16 exposiciones):** cabe en **2 sesiones de 4 h** (8 exposiciones
por sesión, mismo ritmo con más tiempo de preguntas), o se intercala una
exposición 2pm por cada dos de 4pm si ambos grupos exponen juntos.

| Sesión | Temas 2pm | Bloques |
|:-:|:--|:--|
| **S1** | 1--4, 13, 15, 16, 12 | Modelo de cómputo, recursión medida, práctica |
| **S2** | 5--11, 14 | Tipos, inferencia, módulos, flujo y errores, REPL |

## Regla de oro del calendario

Ningún tema del bloque **C--G** se expone si su bloque prerrequisito no se
presentó **en una sesión anterior o en la primera mitad de la misma sesión**. Si
un estudiante falta, su tema se recorre al siguiente hueco del **mismo bloque**,
nunca a otro bloque.

\newpage

# Qué se exige a cada exposición

| Elemento | Requisito mínimo |
|:--|:--|
| **Duración** | 10--12 min. Se corta a los 13 min. |
| **Guion** | 1 diapositiva de contexto, 2--3 de concepto, 1 de ejemplo, 1 de cierre. |
| **Código en vivo** | Obligatorio en bloques **C, D, E, F, G**: abrir GHCi / IEx / `clj` y ejecutar el ejemplo del `README.md`. Nada de capturas de pantalla como sustituto. |
| **Conexión con el bloque** | La última diapositiva enlaza con el tema siguiente ("esto prepara..."). |
| **Fuente visible** | Al menos una referencia IEEE en pantalla, la misma del `README.md`. |
| **Preguntas** | 5 min. Quien expone responde; el docente modera. |

## Rúbrica de exposición (20 puntos, separada de la rúbrica de investigación)

| # | Criterio | Pts | Qué se evalúa |
|:-:|:--|:-:|:--|
| 1 | Dominio del tema | 8 | Responde preguntas sin leer; distingue lo esencial de lo accesorio. |
| 2 | Ejemplo que se ejecuta | 5 | El código corre en vivo y quien expone explica la salida. |
| 3 | Claridad y tiempo | 4 | Secuencia lógica; respeta 12 min; apoyo visual legible. |
| 4 | Integración con el curso | 3 | Ubica su tema en el bloque y lo conecta con el anterior/siguiente. |

Escala: 90--100 % excelente · 75--89 % satisfactorio · 60--74 % suficiente ·
0--59 % insuficiente (misma escala que la rúbrica de investigación).

# Cómo se relacionan las dos entregas

- El **`README.md`** de `research/<tema>/` es la fuente de verdad; la exposición
  es su versión de 12 minutos.
- Nota de investigación y nota de exposición son **independientes**: se puede
  tener buen documento y mala presentación, o viceversa.
- El **proyecto de fin de capítulo** (mínimo 3 paradigmas, según `CLAUDE.md`) se
  arma con equipos que combinen bloques distintos: p. ej. un integrante del
  bloque C (orden superior), uno del E (`pattern matching`) y uno del G
  (comparación de sintaxis / industria).

---

*Documento del curso Programación Lógica y Funcional (ISC-2006), semestre 2026 "B".
Referencias: [`SYLLABUS.md`](../SYLLABUS.md),
[`TEMAS-INVESTIGACION-FUNCIONAL-2026B-4pm.md`](TEMAS-INVESTIGACION-FUNCIONAL-2026B-4pm.md),
[`TEMAS-INVESTIGACION-FUNCIONAL-2026B-2pm.md`](TEMAS-INVESTIGACION-FUNCIONAL-2026B-2pm.md),
[`AI_GUIDANCE.md`](../AI_GUIDANCE.md).*
