# Temas de exposición — Introducción a lenguajes funcionales
## Unidad 1 · Grupo 2pm · 16 estudiantes · Programación Lógica y Funcional · TecNM ISC

Versión del grupo **2pm** de la exposición de equipo. Misma actividad, guion,
medio de presentación y rúbrica que la del grupo 4pm
([`TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md`](TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md)):
solo cambian el número de equipos y el reparto.

## Tamaño de equipo: **4** → 4 equipos

16 estudiantes / 4 = 4 equipos exactos. Un lenguaje por equipo: los **4
funcionales más populares hoy** (Haskell, Elixir, Scala, Clojure). Cabe en
**media sesión** (~25 min por equipo con preguntas).

## Los 4 temas

| Equipo | Lenguaje | Eje de la exposición | Caso real verificado (obligatorio en pantalla) |
|:-:|:--|:--|:--|
| 1 | **Haskell** | Pureza total, evaluación perezosa, `Maybe`/`Either`, clases de tipos, inferencia Hindley-Milner. | Standard Chartered: motor de valuación de derivados en Haskell. |
| 2 | **Scala 3** | Híbrido FP/OOP sobre la JVM, `val` inmutable, orden superior, `for`-comprehensions, `case class` + `match`. | Apache Spark: motor de datos distribuido escrito en Scala. |
| 3 | **Elixir** | BEAM VM, operador pipe `\|>`, `Stream` (flujos perezosos), *pattern matching*, GenServer. | Discord: infraestructura de presencia migrada de Go a Elixir (2017). |
| 4 | **Clojure** | Lisp sobre la JVM, estructuras persistentes, `atom` vs `ref`/`dosync` (STM), REPL-driven. | Nubank: banco digital más grande de América Latina, Clojure + Datomic. |

> Regla de honestidad (`casos_reales_mundo_real.md`): solo casos verificados con
> fuente IEEE en pantalla. Prohibido afirmar uso local/institucional (IMSS, SAT,
> Samsung Tijuana) de un stack sin fuente directa.

---

## Asignación de equipos (grupo 2pm, 16 estudiantes · corte 08/09/26)

Roster en orden de lista; bloques de 4. Roles internos: **(1)** contexto/historia ·
**(2)** modelo de cómputo y sintaxis · **(3)** tipos/runtime · **(4)** demo en vivo + caso real.

### Equipo 1 — Haskell
| Rol | Estudiante |
|:-:|:--|
| 1 | CASTRO REYES, LIZETH ROXANA |
| 2 | CRUZ RANGEL, RAUL ANTONIO |
| 3 | DANIELS CEBALLOS, AXEL |
| 4 | DURAN PONCE, LUIS ADAO LEONEL |

### Equipo 2 — Scala 3
| Rol | Estudiante |
|:-:|:--|
| 1 | GALLEGOS HERNANDEZ, LEONARDO |
| 2 | ORENDAIN CAMACHO, DIEGO ALEJANDRO |
| 3 | PECH GONZALEZ, LUIS ARIEL |
| 4 | PEREZ LOPEZ, CARLOS IVAN |

### Equipo 3 — Elixir
| Rol | Estudiante |
|:-:|:--|
| 1 | RODRIGUEZ MENDIVIL, FABIAN OSVALDO |
| 2 | RODRIGUEZ PERAZA, CARLOS ELIAB |
| 3 | RUIZ SANCHEZ, JOSE MANUEL |
| 4 | TORRES MORENO, DIEGO ANTONIO |

### Equipo 4 — Clojure
| Rol | Estudiante |
|:-:|:--|
| 1 | VALDEZ AMPARO, ANDRES CARLOS |
| 2 | VALDEZ AMPARO, RICARDO DAVID |
| 3 | VILLALOBOS LEON, CESAR ALEJANDRO |
| 4 | VILLANUEVA BARAJAS, JOSUE |

### Carpeta de cada equipo

| Equipo | Lenguaje | Carpeta (README de plantilla) |
|:-:|:--|:--|
| 1 | Haskell | https://github.com/tectijuana/programacionlogicayfuncional/tree/main/unidad1/presentation/equipo2pm-1 |
| 2 | Scala 3 | https://github.com/tectijuana/programacionlogicayfuncional/tree/main/unidad1/presentation/equipo2pm-2 |
| 3 | Elixir | https://github.com/tectijuana/programacionlogicayfuncional/tree/main/unidad1/presentation/equipo2pm-3 |
| 4 | Clojure | https://github.com/tectijuana/programacionlogicayfuncional/tree/main/unidad1/presentation/equipo2pm-4 |

---

## Guion, medio de presentación y rúbrica

Idénticos a la guía del grupo 4pm. Ver
[`TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md`](TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md),
secciones **"Qué debe mostrar cada exposición"**, **"Medio de presentación"** y
**"Rúbrica de la exposición (100 puntos)"**.

Resumen: 12–15 min · diapositivas PDF al PR antes de la sesión · demo en vivo en
la laptop del equipo (REPL + "Hola Paradigma" 1..10 + 2.º ejemplo idiomático) ·
grabación asciinema cloud obligatoria como respaldo · rúbrica /100
(demo 35 · dominio 25 · comparación y caso real 15 · claridad y tiempo 10 ·
participación individual 15).

---

*Referencias: [`../README.md`](../README.md), [`../../SYLLABUS.md`](../../SYLLABUS.md),
[`../../casos_reales_mundo_real.md`](../../casos_reales_mundo_real.md),
[`TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md`](TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md).*
