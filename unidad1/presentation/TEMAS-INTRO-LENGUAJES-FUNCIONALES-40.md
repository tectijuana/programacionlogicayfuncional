# Temas de exposición — Introducción a lenguajes funcionales
## Unidad 1 · 40 estudiantes · Programación Lógica y Funcional · TecNM ISC

## Tamaño de equipo: **4** (recomendado)

| Opción | Equipos | Sobra/falta | Veredicto |
|:-:|:-:|:--|:--|
| **Equipos de 4** | **10** | exacto (10×4 = 40) | **Recomendado.** 1 lenguaje por equipo, 10 exposiciones, cabe en una sesión de 4 h a ~20 min por equipo. |
| Equipos de 3 | 13 | 13×3 = 39, sobra 1 estudiante | 13 exposiciones no caben en 4 h con demo en vivo; hay que partir un lenguaje en dos o hacer un equipo de 4. |

Con equipos de 4: reparto interno sugerido — (1) historia y contexto, (2) modelo
de evaluación y sintaxis, (3) sistema de tipos / runtime, (4) demo en vivo + caso real.

---

## Los 10 temas (uno por equipo)

| # | Lenguaje | Año / origen | Eje de la exposición | Caso real verificado (obligatorio en pantalla) |
|:-:|:--|:--|:--|:--|
| 1 | **Lisp / Scheme** | 1958 / McCarthy | La raíz: código como datos, listas, recursión, REPL. De dónde viene todo lo demás. | Uso histórico en IA simbólica; Scheme en SICP (MIT). |
| 2 | **Haskell** | 1990 | Pureza total, evaluación perezosa, `Maybe`/`Either`, clases de tipos. | Standard Chartered: motor de valuación de derivados en Haskell. |
| 3 | **Erlang / OTP** | 1986 / Ericsson | Modelo de actores, *shared nothing*, "let it crash", supervisores. | WhatsApp: ~2M conexiones por servidor con ~50 ingenieros. |
| 4 | **Elixir** | 2011 | BEAM VM, operador pipe `\|>`, `Stream`, GenServer, metaprogramación con macros. | Discord: infraestructura de presencia migrada de Go a Elixir (2017). |
| 5 | **OCaml** | 1996 | Inferencia Hindley-Milner, `Option`, tipos algebraicos, sistema de módulos y functors. | Meta: Flow, Hack e Infer — analizan 100+ M de líneas al día. |
| 6 | **Clojure** | 2007 | Lisp sobre la JVM, estructuras persistentes, `atom` vs `ref`/`dosync` (STM), transducers. | Nubank: banco digital más grande de América Latina, Clojure + Datomic. |
| 7 | **Scala 3** | 2004 / 2021 | Híbrido FP/OOP en la JVM, tipos, `for`-comprehensions, ecosistema Spark. | Apache Spark: motor de datos distribuido escrito en Scala. |
| 8 | **F#** | 2005 / Microsoft | Funcional en .NET, inferencia de tipos, *type providers*, `Option`, records. | Jet.com / Walmart y análisis financiero en .NET con F#. |
| 9 | **Gleam** | 2019 / v1.0 2024 | Lenguaje tipado sobre BEAM, sintaxis mínima, interoperable con Erlang y Elixir. | Ecosistema BEAM: alternativa tipada a Elixir; proyecto joven, adopción creciente. |
| 10 | **Elm** | 2012 | Funcional puro para frontend, "sin excepciones en runtime", arquitectura Model-Update-View. | NoRedInk: interfaces educativas en producción con Elm, cero errores de runtime. |

> Regla de honestidad (`casos_reales_mundo_real.md`): solo casos verificados con
> fuente en pantalla. Prohibido afirmar uso local/institucional (IMSS, SAT,
> Samsung Tijuana) de un stack sin fuente directa.

---

## Asignación de equipos (grupo 4pm, 40 estudiantes · corte 08/09/26)

Roster en orden de lista; bloques de 4. Roles internos: **(1)** contexto/historia ·
**(2)** modelo de cómputo y sintaxis · **(3)** tipos/runtime · **(4)** demo en vivo + caso real.

### Equipo 1 — Lisp / Scheme
| Rol | Estudiante |
|:-:|:--|
| 1 | AGUILAR AGUILAR, LUIS DANIEL |
| 2 | AGUIRRE DAVILA, HUGO IRAM |
| 3 | BALLESTEROS CRUZ, ALDO JUVENTINO |
| 4 | BARAJAS CARPIO, ENRIQUE |

### Equipo 2 — Haskell
| Rol | Estudiante |
|:-:|:--|
| 1 | BARBOZA CARBALLO, DIEGO ANTONIO |
| 2 | BOJORQUEZ VALDEZ, VICTOR MANUEL |
| 3 | CAMACHO OTAÑEZ, JUAN PABLO |
| 4 | CAMARILLO MOLINA, CRISTIAN |

### Equipo 3 — Erlang / OTP
| Rol | Estudiante |
|:-:|:--|
| 1 | COTA HERNANDEZ, CHRISTIAN ARMANDO |
| 2 | CRUZ SANCHEZ, KEVIN ALFREDO |
| 3 | CUEVAS MARQUEZ, PABLO ANGEL |
| 4 | DEL ANGEL DEL ANGEL, EMMANUEL |

### Equipo 4 — Elixir
| Rol | Estudiante |
|:-:|:--|
| 1 | ESPAÑA PEREZ, MIGUEL ANGEL |
| 2 | ESTRADA RODRIGUEZ, MELANI |
| 3 | FUENTES MONTAÑO, AXEL |
| 4 | GARCIA CARO, CARLOS ALEJANDRO |

### Equipo 5 — OCaml
| Rol | Estudiante |
|:-:|:--|
| 1 | GARCIA RODRIGUEZ, MARCOS DANIEL |
| 2 | GOMEZ CUEVAS, CARLOS |
| 3 | GONZALEZ CRISTOBAL, OMAR |
| 4 | GRANDE ORTEGA, MAXIMILIANO |

### Equipo 6 — Clojure
| Rol | Estudiante |
|:-:|:--|
| 1 | HERNANDEZ CUADRAS, ANA CECILIA |
| 2 | LARES MENA, ANGEL FERNANDO |
| 3 | LEPE GARCIA, CESAR |
| 4 | LOPEZ MOLGADO, JORGE LUIS |

### Equipo 7 — Scala 3
| Rol | Estudiante |
|:-:|:--|
| 1 | LUIS JUAN CAMACHO, CESAR ADRIAN |
| 2 | MALDONADO AVENDAÑO, VALERIA |
| 3 | MARTINEZ GARCIA, SEBASTIAN |
| 4 | MARTINEZ MARTA, JORGE EMILIANO |

### Equipo 8 — F#
| Rol | Estudiante |
|:-:|:--|
| 1 | MEDRANO VARGAS, STEPHANIE ARIANA |
| 2 | MIJANGOS GARIBAY, EMILY |
| 3 | NEYRA MENDEZ, ANGEL CASSIEL |
| 4 | NOLASCO AYALA, GAEL |

### Equipo 9 — Gleam
| Rol | Estudiante |
|:-:|:--|
| 1 | PADILLA, DYLAN ALEXIS |
| 2 | PARRA ESPINOZA, HERIB ARTURO |
| 3 | PEREZ FLORES, ANDRES MANUEL |
| 4 | PINEDA GOMEZ, RICARDO ALEJANDRO |

### Equipo 10 — Elm
| Rol | Estudiante |
|:-:|:--|
| 1 | RAMIREZ BAUTISTA, IRENE |
| 2 | RODRIGUEZ GALLARDO, HOWARD |
| 3 | SALCIDO MAGAÑA, MONICA |
| 4 | SANTOYO TORRES, SANTOS ABRAHAM |

---

## Qué debe mostrar cada exposición (12–15 min)

1. **Contexto (2 min):** año, quién lo creó, qué problema resolvía.
2. **Modelo de cómputo (3 min):** cómo evalúa, qué NO tiene (mutación, `null`,
   `for`), cómo sustituye el bucle.
3. **Sistema de tipos / runtime (3 min):** qué atrapa antes de correr vs. en
   ejecución; concurrencia si aplica.
4. **Demo en vivo (4 min):** REPL abierto, ejecutar el "Hola Paradigma"
   (imprimir 1..10) **y** un segundo ejemplo idiomático del lenguaje. Nada de
   capturas como sustituto.
5. **Caso real + cierre (2 min):** el sistema de producción de la tabla, con
   referencia IEEE visible, y una frase de conexión con los otros lenguajes del curso.

---

## Calendario (1 sesión de 4 h)

| Turno | Equipos | Bloque |
|:-:|:--|:--|
| 1 | 1, 2 | Raíces y pureza (Lisp, Haskell) |
| — | descanso 15 min | |
| 2 | 3, 4, 9 | Familia BEAM (Erlang, Elixir, Gleam) |
| — | descanso 15 min | |
| 3 | 5, 6, 7, 8 | Tipados sobre VM (OCaml, Clojure, Scala, F#) |
| 4 | 10 | Funcional en el navegador (Elm) + síntesis del docente |

~20 min por equipo (15 exposición + 5 preguntas y transición).

---

## Medio de presentación

| Elemento | Requisito |
|:--|:--|
| **Diapositivas** | 5–8, en **PDF**, subidas al PR del equipo (`unidad1/presentation/equipoNN/slides.pdf`) **antes** de iniciar la sesión. Fuente legible a 3 m. |
| **Demo en vivo** | En la **laptop del equipo** conectada al proyector. REPL a la vista, fuente del terminal ≥ 18 pt, tema claro. Se ejecutan los comandos exactos del `README.md` del equipo. |
| **Respaldo obligatorio** | Grabación en **asciinema cloud** con el demo completo corriendo: `asciinema rec` → `asciinema upload` (o `asciinema auth`) → se obtiene una **URL compartida** de asciinema.org. Esa URL va en el `README.md` del equipo. |
| **Entregable en el repo** | Carpeta `equipoNN/` con `README.md` (guion + comandos exactos + **URL de la grabación asciinema cloud** + bibliografía IEEE) y `slides.pdf`. |

### Qué pasa si el entorno falla

1. **Primer plan:** demo en la laptop del equipo.
2. **Si falla el hardware/proyector del salón** (causa ajena al equipo): se
   reproduce el la grabación asciinema cloud y no hay penalización.
3. **Si falla el entorno o el código del equipo:** se clona el repo del PR y se
   corre en la **máquina del profesor**; debe funcionar **sin modificaciones**.
4. **Si tampoco corre ahí:** el criterio 1 se evalúa solo con el la grabación asciinema cloud, al 50 % de su valor.

---

## Rúbrica de la exposición (100 puntos = logro de esta exposición)

Esta rúbrica califica **solo la exposición** (no equivale al 20 % de la unidad ni
a un porcentaje del semestre; es la nota de logro de esta actividad).

| # | Criterio | Pts | Qué se evalúa |
|:-:|:--|:-:|:--|
| 1 | Demo en vivo funcionando | 35 | REPL + "Hola Paradigma" + 2.º ejemplo idiomático corriendo sin modificaciones; explican la salida. |
| 2 | Dominio del modelo de cómputo | 25 | Explican sin leer qué sustituye al bucle/mutación/`null`; responden preguntas del docente y del grupo. |
| 3 | Comparación y caso real | 15 | Métricas concretas (LOC, errores en compilación vs. runtime, concurrencia) + 1 caso verificado con referencia IEEE en pantalla. |
| 4 | Estructura, claridad visual y tiempo | 10 | Guion de 5 pasos; 12–15 min; diapositivas legibles y sin muros de texto. |
| 5 | Participación individual equilibrada | 15 | Los 4 roles exponen su parte y cada quien responde al menos una pregunta. |

**Ajuste individual:** el integrante que no expone su parte o no responde su
pregunta recibe el **50 %** de la nota del equipo.

**Código que no corre = 0 en el criterio 1** (salvo falla de hardware del salón, punto 2 de arriba).

Escala de logro: 90–100 excelente · 75–89 satisfactorio · 60–74 suficiente · 0–59 insuficiente.

---

*Referencias: [`../README.md`](../README.md), [`../../SYLLABUS.md`](../../SYLLABUS.md),
[`../../casos_reales_mundo_real.md`](../../casos_reales_mundo_real.md),
[`GUIA-UNIFICADA-PRESENTACIONES.md`](GUIA-UNIFICADA-PRESENTACIONES.md).*
