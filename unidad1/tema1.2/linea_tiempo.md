# Línea de Tiempo — Paradigmas Funcional y Lógico

## El hilo que conecta matemáticas del siglo XX con las herramientas que usas hoy

---

### 1930 — Lambda Calculus (Alonzo Church)

Church formaliza el cómputo como *reducción de expresiones*, no como modificación de estado.
Una función `f(x)` no tiene efectos secundarios. Para el mismo `x`, siempre retorna el mismo resultado.
Este es el fundamento matemático de toda la programación funcional.

*Dato:* Church y Turing (con sus máquinas de estado) propusieron modelos equivalentes de cómputo.
Los lenguajes funcionales son herederos de Church; los imperativos (C, Java, Python), de Turing.

---

### 1958 — LISP (John McCarthy, MIT)

El primer lenguaje que implementa lambda calculus de forma práctica.
Código como datos (`homoiconicidad`), recolector de basura, recursión como mecanismo central.
Clojure (2007) es un LISP moderno — la misma filosofía, 50 años después.

---

### 1972 — Prolog (Alain Colmerauer, Robert Kowalski)

Primer lenguaje de programación lógica. El programa *describe* relaciones;
el motor de inferencia *decide* cómo satisfacerlas.
Nació para procesar lenguaje natural. Terminó siendo la herramienta de la IA simbólica de los 80s.

*Dato:* IBM Watson, que ganó Jeopardy! en 2011, usó técnicas de programación lógica
(entre otras) para razonamiento sobre conocimiento.

---

### 1973 — ML (Robin Milner, Edinburgh)

Primer lenguaje con *inferencia de tipos*: el compilador deduce los tipos sin que el programador los escriba.
ML es el ancestro directo de OCaml, Haskell, F#, Scala y Rust.

---

### 1986 — Erlang (Joe Armstrong, Ericsson)

Ericsson necesitaba un lenguaje para switches de telecomunicaciones:
millones de llamadas simultáneas, sin tiempo de inactividad, actualizaciones en caliente.
Armstrong inventó Erlang. En 1999 demostró 99.9999999% de uptime en el AXD301.

*Filosofía:* "Let it crash" — no defiendas contra errores, diseña para recuperarte de ellos.

---

### 1990 — Haskell (Comité académico, Glasgow)

El estándar académico de la programación funcional pura.
*Pura*: ninguna función puede tener efectos secundarios sin declararlo en el tipo.
`IO a` es un tipo, no magia. El compilador te obliga a separar lógica pura de efectos.

---

### 1996 — OCaml (INRIA, Francia)

ML con un sistema de módulos único y un compilador que genera código nativo extremadamente eficiente.
Su característica distintiva: módulos que pueden ser parametrizados por otros módulos (functores).

**Por qué Meta eligió OCaml:**
Meta necesitaba analizar millones de líneas de código PHP/JavaScript buscando bugs de tipos.
Un analizador de tipos es básicamente un intérprete tipado — exactamente el dominio donde
OCaml brilla: el compilador de OCaml verifica la corrección del analizador en tiempo de compilación.

```
Meta/Facebook usa OCaml para:
├── Hack     — lenguaje tipado que reemplazó PHP en Facebook (2014)
├── Flow     — verificador de tipos para JavaScript (2014)
└── Infer    — analizador estático que encuentra bugs antes de que lleguen a producción (2015)
```

---

### 2007 — Clojure (Rich Hickey)

LISP moderno sobre la JVM. Hickey diseñó Clojure para resolver un problema específico:
construir sistemas concurrentes en Java es doloroso porque el estado mutable compartido
produce bugs que son casi imposibles de reproducir y debuggear.

Solución de Clojure: todas las estructuras de datos son *persistentes* (inmutables).
Para estado coordinado entre múltiples referencias: STM (Software Transactional Memory).

**Por qué Nubank eligió Clojure:**
Nubank procesa transacciones financieras. Una transferencia SPEI involucra:
debitar la cuenta origen Y acreditar la cuenta destino — ambas operaciones deben
ocurrir juntas o ninguna. Con `ref`/`dosync` de Clojure, esto es una transacción
ACID en memoria, sin base de datos.

---

### 2011 — Elixir (José Valim, Brasil)

Valim era core contributor de Ruby on Rails. Quería la productividad de Ruby
con la escalabilidad de Erlang. Creó Elixir: mismo runtime (BEAM), sintaxis moderna,
macros higiénicos, ecosistema `mix`/`hex`.

**Discord en 2017:** migró su sistema de presencia (quién está online) de Go a Elixir.
Go usaba procesos del SO (pesados). BEAM usa procesos virtuales livianos — puede tener
millones en un solo servidor.

---

### 2013 — Flow y Hack (Meta)

Boris Cherny se une al equipo de Meta. Trabaja en Flow y Hack — ambos escritos en OCaml.
Su experiencia: un lenguaje funcional con tipos fuertes te permite escribir herramientas
que razonan sobre código de forma confiable, porque el compilador garantiza que
*tu herramienta misma* no tiene bugs de tipos.

---

### 2023-2025 — Claude Code (Boris Cherny, Anthropic)

Cherny deja Meta y se une a Anthropic. Con su background en herramientas de desarrollo
y programación funcional, crea Claude Code — una herramienta de IA para ingeniería de software.

**El hilo completo:**
```
Lambda Calculus (1930)
    └─► ML con inferencia de tipos (1973)
            └─► OCaml (1996)
                    └─► Flow / Hack en Meta (2013-2023)
                                └─► Claude Code en Anthropic (2025)
```

*Boris Cherny, entrevistado por Pragmatic Engineer (2025):*
> "A longtime JavaScript programmer and functional programming evangelist."

La programación funcional no es historia académica. Es el fundamento de las
herramientas que están redefiniendo la ingeniería de software ahora mismo.

---

### 2024 — Gleam (Louis Pilfold)

Lenguaje funcional con tipos estáticos que compila a BEAM (y a JavaScript).
El objetivo: la seguridad de tipos de Haskell con el ecosistema y la tolerancia
a fallos de Erlang/Elixir.

Primera versión estable: marzo 2024. Ecosistema pequeño pero creciendo rápidamente.

---

## Resumen: ¿qué paradigma para qué problema?

| Problema | Paradigma recomendado | Lenguaje representativo |
|----------|----------------------|------------------------|
| Millones de conexiones simultáneas | Funcional + Actor model | Erlang, Elixir |
| Transacciones financieras coordinadas | Funcional + STM | Clojure |
| Análisis de código / compiladores | Funcional con tipos fuertes | OCaml, Haskell |
| Reglas de negocio complejas / IA | Lógico | Prolog, Datalog |
| Procesamiento de datos a gran escala | Funcional (lazy/streams) | Haskell, Elixir, Scala |
| CRUD empresarial estándar | OOP imperativo | Java, C#, Python |
