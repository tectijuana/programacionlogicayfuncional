
![DALL·E 2024-08-25 12 00 07 - A friendly and intelligent small robot named Lambda Bot, designed as the mascot for a programming class focused on functional and logic programming  T](https://github.com/user-attachments/assets/f0fae45f-f121-43ab-98f5-8b91f037d774)


# Programación Lógica y Funcional — Agosto–Diciembre 2026

**TecNM Campus Tijuana · Ingeniería en Sistemas Computacionales**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Cite](https://img.shields.io/badge/Citar-CITATION.cff-green)](CITATION.cff)
![Languages](https://img.shields.io/badge/Lenguajes-Prolog%20%7C%20Erlang%20%7C%20Haskell%20%7C%20Clojure%20%7C%20Elixir-orange)

## ¿Por qué importa este curso? La conexión real con la industria

> *"A longtime JavaScript programmer and functional programming evangelist."*
> — Perfil público de Boris Cherny

**Boris Cherny** es el creador de **Claude Code** — la herramienta de IA que posiblemente estás usando ahora mismo para programar. Antes de Anthropic, pasó cinco años como Principal Engineer en **Meta/Facebook**, donde trabajó con **Flow** (el verificador de tipos de JavaScript) y **Hack** (el lenguaje tipado de Meta). Ambas herramientas están implementadas en **OCaml** — un lenguaje funcional que verás en este curso.

El hilo conductor es directo:

```
OCaml (lenguaje funcional, 1996)
  └─► Flow & Hack en Meta  (herramientas de producción, ~2013-2024)
        └─► Claude Code en Anthropic  (herramienta que cambió la industria, 2025)
```

**Lo que esto significa para ti como estudiante de ISC en TecNM:**
La programación funcional y lógica no es solo teoría académica: está detrás de herramientas que usan a diario equipos de ingeniería de primer nivel. Aprender a pensar de forma declarativa — con Prolog, Erlang y Haskell como ejes del curso — te da una herramienta mental que se transfiere a cualquier lenguaje, aunque tu trabajo futuro sea mayormente imperativo. (OCaml, el lenguaje de Flow y Hack, aparece aquí como referencia histórica, no como lenguaje a dominar.)

Otros ejemplos de producción que estudiarás en este curso:
- **WhatsApp** (≈2 mil millones de usuarios) — construido sobre **Erlang/OTP**
- **Discord** (cientos de millones de usuarios) — migró parte de su backend a **Elixir** en BEAM para escalar
- **Nubank** (uno de los bancos digitales más grandes de América Latina) — construido con **Clojure**
- **Meta/Infer** (analizador estático de código) — implementado en **OCaml**

> Las cifras de esta sección son aproximadas y provienen de publicaciones de las propias
> empresas. Aprende a distinguir cuándo un lenguaje es la base de un sistema completo y
> cuándo es solo un motor declarativo dentro de él — ver
> [`casos_reales_mundo_real.md`](casos_reales_mundo_real.md).

---

## Qué lenguajes vas a usar (y en cuáles concentrarte)

Este curso muestra **seis lenguajes**, pero no todos pesan igual. No necesitas volverte
experto en los seis: necesitas dominar tres y reconocer los demás. Concentra tu esfuerzo así:

| Rol | Lenguaje | Para qué lo usamos | Dónde aparece |
|-----|----------|--------------------|---------------|
| **Central** | **SWI-Prolog** | Toda la mitad lógica del curso: hechos, reglas, unificación, búsqueda, CLP(FD) | Unidades 3 y 4 completas + capa 1 de todos los proyectos |
| **Central** | **Erlang/OTP** | Inmutabilidad, pattern matching, concurrencia y supervisión ("let it crash") | Temas 2.1 y 2.5 + capa 2 de proyectos |
| **Central** | **Haskell** | Recursión, tipos algebraicos, `Maybe`/`Either`, evaluación perezosa | Temas 2.3 y 2.4 + capa 3 de proyectos |
| Complementario | **Clojure** | Funciones de orden superior en un Lisp (caso Nubank) | Tema 2.2 + capa 2 del Proyecto 2 |
| Complementario | **Elixir** | Streams perezosos sobre la misma VM que Erlang (BEAM) | Tema 2.4 + capa 3 del Proyecto 3 |
| Instrumental | **Python** | Solo como punto de contraste imperativo | Tema 1.3 (validador CURP) |

> **OCaml** se menciona como hilo histórico (Meta: Flow, Hack, Infer) y se muestra un demo
> en el Tema 1.2, pero **no es un lenguaje evaluable del curso**: aparece para entender de
> dónde vienen las herramientas, no para programar en él.

**Regla práctica:** si vas justo de tiempo, prioriza **Prolog, Erlang y Haskell**. Con esos
tres cubres los dos paradigmas del curso y puedes completar cualquiera de los proyectos finales.

---

## Objetivo General

Proveer a los estudiantes de las bases teóricas y prácticas necesarias para la programación en paradigmas lógicos y funcionales, desarrollando su capacidad para resolver problemas complejos de manera efectiva.

## Resultados de Aprendizaje (Taxonomía de Bloom)

Al concluir el curso, el estudiante será capaz de:

| Nivel | Verbo | Resultado medible |
|-------|-------|-------------------|
| **Recordar** | Identificar | Los paradigmas funcional y lógico, sus lenguajes representativos y casos de uso en la industria |
| **Comprender** | Explicar | La diferencia entre evaluación estricta y perezosa, unificación vs. asignación, y "let it crash" |
| **Aplicar** | Implementar | Soluciones recursivas con tail-call optimization en Erlang, Haskell y Prolog |
| **Analizar** | Comparar | El mismo problema en tres paradigmas (imperativo, funcional, lógico) midiendo líneas de código y garantías del compilador |
| **Evaluar** | Justificar | La elección de paradigma para un problema dado, con métricas concretas de complejidad y mantenibilidad |
| **Crear** | Diseñar | Un sistema multi-paradigma que integre lógica declarativa (Prolog), estado supervisado (Erlang/OTP) y tipos fuertes (Haskell) |

## Unidades y Temas

### Unidad 1: Conceptos Fundamentales

- **Tema 1.1:** Introducción a la Programación Lógica y Funcional
- **Tema 1.2:** Historia y evolución de los paradigmas
- **Tema 1.3:** Comparación con otros paradigmas de programación

### Unidad 2: Modelo de Programación Funcional

- **Tema 2.1:** Fundamentos de la programación funcional
- **Tema 2.2:** Funciones de primera clase y funciones de orden superior
- **Tema 2.3:** Recursión y estructuras de datos inmutables
- **Tema 2.4:** Evaluación perezosa (Lazy Evaluation)
- **Tema 2.5:** Aplicaciones de la programación funcional

![prolog copy-2](https://github.com/user-attachments/assets/90192e5b-89ae-47b0-91f9-6e5269f6b95e)





### Unidad 3: Programación Lógica

- **Tema 3.1:** Fundamentos de la programación lógica
- **Tema 3.2:** Sistemas formales y lógica de predicados
- **Tema 3.3:** Unificación y resolución
- **Tema 3.4:** Introducción a Prolog
- **Tema 3.5:** Aplicaciones de la programación lógica

### Unidad 4: Modelo de Programación Lógica

- **Tema 4.1:** Desarrollo de programas lógicos
- **Tema 4.2:** Estrategias de búsqueda
- **Tema 4.3:** Optimización de programas lógicos
- **Tema 4.4:** Proyectos prácticos y casos de estudio

---

## Contenido del Curso

### Unidad 1 — Conceptos Fundamentales

| Tema | Contenido | Lenguajes |
|------|-----------|-----------|
| [1.1 Introducción](unidad1/tema1.1/) | Taxonomía de paradigmas, primer contacto con los lenguajes del curso | Python · Erlang · Prolog |
| [1.2 Historia y evolución](unidad1/tema1.2/) | Línea de tiempo: Lambda Calculus 1930 → Gleam 2024, casos de industria | — |
| [1.3 Comparación de paradigmas](unidad1/tema1.3/) | Validador de **CURP mexicana** en 3 paradigmas: imperativo, funcional, lógico | Python · Erlang · Prolog |

### Unidad 2 — Modelo de Programación Funcional

| Tema | Contenido | Lenguajes |
|------|-----------|-----------|
| [2.1 Fundamentos FP](unidad2/tema2.1/) | Inmutabilidad, transparencia referencial, pattern matching con **RFC** | Erlang |
| [2.2 Funciones de orden superior](unidad2/tema2.2/) | `map`, `filter`, `reduce`, composición, closures — pipeline de alumnos TecNM | Clojure |
| [2.3 Recursión e inmutabilidad](unidad2/tema2.3/) | Recursión de cola, `Maybe`/`Either`, tipos algebraicos | Haskell |
| [2.4 Evaluación perezosa](unidad2/tema2.4/) | Listas infinitas (Fibonacci, primos), Stream sobre registros **IMSS** | Haskell · Elixir |
| [2.5 Aplicaciones FP](unidad2/tema2.5/) | **OTP completo**: `application` + `supervisor` + `gen_server`, "let it crash" con sensores IoT estilo **CENAPRED** | Erlang/OTP |

### Unidad 3 — Programación Lógica

| Tema | Contenido | Lenguajes |
|------|-----------|-----------|
| [3.1 Fundamentos](unidad3/tema3.1/) | Hechos, consultas, base de datos organizacional TecNM Tijuana | SWI-Prolog |
| [3.2 Sistemas formales y lógica de predicados](unidad3/tema3.2/) | Reglas, negación como falla (`\+`), elegibilidad para **beca TecNM** | SWI-Prolog |
| [3.3 Unificación y resolución](unidad3/tema3.3/) | Algoritmo de unificación, traza SLD, occurs check — 15 tests | SWI-Prolog |
| [3.4 Introducción a Prolog](unidad3/tema3.4/) | Listas desde cero (`mi_member`, `mi_append`, `mi_flatten`…), aritmética, `entre/3` — 76 tests | SWI-Prolog |
| [3.5 Aplicaciones](unidad3/tema3.5/) | **Sistema experto médico interactivo** (contexto IMSS): 8 condiciones, `assert`/`retract` | SWI-Prolog |

### Unidad 4 — Modelo de Programación Lógica

| Tema | Contenido | Lenguajes |
|------|-----------|-----------|
| [4.1 Desarrollo de programas lógicos](unidad4/tema4.1/) | Módulos Prolog, firmas explícitas, documentación de aridad y determinismo — validador **CURP** | SWI-Prolog |
| [4.2 Estrategias de búsqueda](unidad4/tema4.2/) | DFS y BFS sobre grafo **metro CDMX**, cut verde vs. rojo, `findall`/`bagof`/`setof` | SWI-Prolog |
| [4.3 Optimización / CLP(FD)](unidad4/tema4.3/) | Restricciones sobre enteros, **Sudoku 9×9**, asignación de **horarios TecNM** como CSP | SWI-Prolog + CLP(FD) |
| [4.4 Proyecto final](unidad4/tema4.4/) | Sistema de **trámites TecNM** multi-módulo con CLP, 33 tests automatizados | SWI-Prolog |

### Proyectos Finales — Integración Multi-Paradigma

Cada alumno elige **uno** de los cuatro proyectos y construye un sistema completo en tres capas.
El código base (starter code) ya está en el repositorio.

| Proyecto | Dominio | Capa 1 — Lógica | Capa 2 — Estado | Capa 3 — Tipos |
|----------|---------|-----------------|-----------------|----------------|
| [P1 — Trámites IMSS](proyectos_finales/proyecto1_tramites_imss/) | Seguridad social · 74M derechohabientes | Prolog + CLP(FD) | Erlang/OTP | Haskell |
| [P2 — Turnos maquiladora](proyectos_finales/proyecto2_maquiladora/) | Manufactura · 700+ plantas en Tijuana | Prolog CLP(FD) | Clojure | — |
| [P3 — Monitor IoT CENAPRED](proyectos_finales/proyecto3_monitor_iot/) | Sensores en tiempo real · "let it crash" | Prolog + CLP(FD) | Erlang/OTP | Elixir Stream |
| [P4 — Inventario SAT](proyectos_finales/proyecto4_inventario_sat/) | Fiscal · 9,600M CFDIs/año | Prolog + CLP(FD) | Erlang/OTP | Haskell |

> Ver [`proyectos_finales/README.md`](proyectos_finales/README.md) para la arquitectura obligatoria de 3 capas, rúbrica y casos de uso reales en producción.

---

## Cómo estudiar este curso

Una guía corta para aprovechar el material, pensada para ti como estudiante:

1. **Instala el entorno la primera semana.** No dejes la instalación para el día de la entrega.
   Sigue las guías paso a paso de [`instalacion/`](instalacion/) (AWS Academy + Ubuntu ARM64,
   una guía independiente por software, y script para Raspberry Pi Zero 2W); si tu equipo es
   Windows, usa WSL2 o GitHub Codespaces.
2. **Lee el `README.md` de cada unidad antes de la clase.** Cada uno trae el objetivo, los
   temas y la regla de entrega. Llegar con el entorno listo y el código clonado vale tiempo.
3. **Ejecuta todo el código tú mismo.** El curso es práctico: "código que no compila = 0".
   No basta con leerlo — cárgalo, rómpelo, modifícalo y observa qué cambia.
4. **Concentra el esfuerzo en los tres lenguajes centrales** (Prolog, Erlang, Haskell). Clojure
   y Elixir se entienden rápido una vez que dominas las ideas de fondo (inmutabilidad,
   recursión, orden superior, supervisión).
5. **Empieza el proyecto final temprano.** La capa 1 (Prolog) puedes comenzarla desde la
   Unidad 3; no esperes a la semana 16.
6. **Usa la IA como herramienta, citándola.** Está permitida (ver política de entregas en el
   sílabo): debes entender y poder defender cada línea que entregues.

> **Para el docente:** el plan de sesiones detallado (4 h × 4 por unidad, objetivos y
> actividades por tema) está en [`PLAN_RENOVACION.md`](PLAN_RENOVACION.md), separado de esta
> guía para no saturar la lectura del estudiante.

## Referencias

- Pereira, P. A. (2015). Elixir Cookbook: Unleash the full power of programming in Elixir with over 60 incredibly effective recipes. Packt Publishing. ISBN 9781784397517.
- Cesarini, F., & Thompson, S. (2009). Erlang Programming. O'Reilly Media. ISBN 9780596518189.
- Cesarini, F., & Vinoski, S. (2016). Designing for Scalability with Erlang/OTP: Implement Robust, Fault-Tolerant Systems. O’Reilly Media. ISBN 9781449320737.
- St. Laurent, S. (2017). Introducing Erlang: Getting Started in Functional Programming (2nd ed.). O’Reilly Media. ISBN 9781491973370.
- Pd. https://www.cs.us.es/~fsancho/Blog/posts/Introduccion_Prolog.md

## Utilerías

### Evidencia de entregas

| Herramienta | Uso | Cuándo usarla |
|-------------|-----|---------------|
| **[asciinema](https://asciinema.org)** | Grabación de sesión de terminal | Todas las prácticas CLI — Prolog, Erlang, Haskell, Clojure |
| **[LOOM](https://www.loom.com)** | Video de pantalla con audio (máx. 5 min) | Proyectos con interfaz gráfica o dashboard |
| **[Google Stitch](https://stitch.withgoogle.com)** | Generación de UI con IA | Base de mockups y prototipos UI en el Proyecto Final |
| **GitHub** | Pull Request como entregable formal | Todas las entregas — PR con link a asciinema/LOOM en la descripción |

### Cómputo en la nube

- **[AWS Academy](https://www.awsacademy.com/vforcesite/LMS_Login):** Crédito de $100 USD por semestre para desplegar aplicaciones Erlang/Elixir/Haskell en EC2.
- **[`instalacion/`](instalacion/):** Guías de instalación del entorno completo — nodo EC2 ARM64 desde CloudShell, SWI-Prolog, Erlang/OTP, GHC, Clojure, Elixir, OCaml y Raspberry Pi Zero 2W.

### Otros recursos

- **[GitHub Student Pack](https://education.github.com/pack):** Acceso gratuito a herramientas de desarrollo.
- **[GitHub Gist](http://gist.github.com):** Publicación de snippets de código.
- **[file.io](http://file.io):** Subidas anónimas auto-purgables (2 meses).
- **[ASCII Generator](https://ascii-generator.site):** Arte ASCII para reportes.
- **[Future Tools](http://futuretools.io):** Catálogo de herramientas de IA útiles para el curso.







