# Proyectos Finales — Integración Multi-Paradigma

**TecNM Tijuana — Ingeniería en Sistemas Computacionales**
**Programación Lógica y Funcional**

---

## Estos proyectos no son académicos — ya existen en producción

Los cuatro dominios de esta lista no son inventados para el curso.
Son versiones simplificadas de sistemas reales que corren hoy, en este momento,
usando exactamente los paradigmas que acabas de aprender.

---

### Proyecto 1 — Trámites IMSS
El IMSS atiende a **74 millones de derechohabientes**. Su plataforma IMSS Digital
procesa solicitudes de incapacidades, pensiones y préstamos con reglas de elegibilidad
que cambian por decreto. Los sistemas de reglas de negocio declarativas — como el
que construyes en Prolog — son el estándar industrial para este tipo de lógica:
IBM Watson usó lógica de predicados para su motor de reglas médicas; muchos sistemas
de seguros en Europa operan con motores Prolog o Datalog en producción.

> "Las reglas de negocio del IMSS no se programan, se *declaran*. Prolog es, literalmente,
> el lenguaje diseñado para eso."

---

### Proyecto 2 — Horarios TecNM
El problema de asignación de horarios universitarios es un **problema NP-completo**.
Las universidades más grandes del mundo (MIT, UNAM, Tecnológico de Monterrey) usan
solvers de restricciones para resolverlo — exactamente `CLP(FD)` como el tuyo, o
herramientas industriales basadas en los mismos principios (Google OR-Tools, IBM CP Optimizer).
El TecNM asigna horarios para **266 campus**; lo que construyes aquí es el núcleo
de ese tipo de sistema.

> "Cuando el sistema de inscripciones del TecNM asigna tu horario sin traslapes,
> un solver de restricciones resolvió el mismo problema que ves en `planificador.pl`."

---

### Proyecto 3 — Monitor IoT CENAPRED
El CENAPRED opera la **Red Sísmica Nacional**: 100+ sensores en tiempo real,
con alertas que activan el Sistema de Alerta Sísmica de México (SASMEX).
WhatsApp maneja 2 millones de conexiones simultáneas con un equipo de 50 ingenieros
gracias a Erlang/OTP — el mismo modelo de supervisión que implementas aquí.
Discord escala a 150 millones de usuarios con Elixir/Phoenix sobre la misma VM (BEAM).
La filosofía "let it crash" + supervisión automática que demuestras con `kill(pid)` es
exactamente cómo esos sistemas logran **99.9999% de uptime**.

> "Un sensor que falla no puede detener la red de alerta sísmica. Erlang/OTP garantiza
> eso por diseño — no por código defensivo."

---

### Proyecto 4 — Inventario SAT
El SAT emitió **9,600 millones de CFDIs** en 2023. Cada factura electrónica pasa por
validación de RFC, cálculo de IVA y verificación de restricciones fiscales — las mismas
reglas que codificas en `reglas_fiscales.pl`.
Nubank procesa millones de transacciones financieras diarias en Clojure, con
inmutabilidad total: cada transacción es un hecho, nunca una modificación de estado.
El módulo Haskell de facturas tipadas es la misma estrategia que usan los equipos de
Meta (Flow, Hack, Infer) y Jane Street: **el tipo correcto hace imposible el error fiscal**.

> "El SAT no acepta un CFDI con RFC mal formado. Un tipo `RFC` en Haskell que solo
> se puede construir via `validarRFC` hace que ese error sea imposible en tiempo de compilación."

---

## Objetivo

Demostrar dominio integrado de los tres paradigmas del curso construyendo un sistema
real que use cada paradigma donde tiene ventaja natural:

| Capa | Paradigma | Por qué aquí |
|------|-----------|--------------|
| Validación de reglas de negocio | **Lógico** (SWI-Prolog) | Declarar *qué* es válido, backtracking gratis, CLP(FD) para restricciones numéricas |
| Estado, concurrencia y resiliencia | **Funcional** (Erlang/OTP o Clojure) | Inmutabilidad + supervisión automática + sin race conditions por diseño |
| Reportes y pipeline de datos | **Funcional con tipos** (Haskell u OCaml) | El tipo es la documentación; imposible generar un reporte mal formado |

---

## Proyectos disponibles — elige uno

| # | Proyecto | Dominio | Paradigmas requeridos |
|---|----------|---------|----------------------|
| [1](proyecto1_tramites_imss/) | Sistema de validación de trámites IMSS | Seguridad social | Prolog + Erlang/OTP + Haskell |
| [2](proyecto2_horarios_tecnm/) | Planificador de horarios TecNM | Educación | Prolog CLP(FD) + Clojure |
| [3](proyecto3_monitor_iot/) | Monitor de alertas IoT estilo CENAPRED | Ingeniería de sistemas | Prolog + Erlang/OTP + Elixir |
| [4](proyecto4_inventario_sat/) | Gestor de inventario con reglas fiscales SAT | Contabilidad / RFC | Prolog + Erlang/OTP + Haskell |

Todos los proyectos tienen la **misma arquitectura de tres capas** y la **misma rúbrica**.
La diferencia está en el dominio del problema.

---

## Arquitectura obligatoria

```
┌─────────────────────────────────────────────┐
│  CAPA 1 — Lógica declarativa (SWI-Prolog)   │
│  • Hechos y reglas de negocio del dominio   │
│  • CLP(FD) para restricciones numéricas     │
│  • plunit para tests automatizados          │
└──────────────────┬──────────────────────────┘
                   │ consultas Prolog
┌──────────────────▼──────────────────────────┐
│  CAPA 2 — Estado y concurrencia (OTP/Clojure)│
│  • GenServer por entidad activa             │
│  • DynamicSupervisor o Supervisor tree      │
│  • Log inmutable de operaciones             │
└──────────────────┬──────────────────────────┘
                   │ datos procesados
┌──────────────────▼──────────────────────────┐
│  CAPA 3 — Reportes tipados (Haskell/OCaml)  │
│  • Tipos algebraicos para cada entidad      │
│  • Either para errores, never partial fns   │
│  • Salida estructurada (JSON / CSV / texto) │
└─────────────────────────────────────────────┘
```

---

## Requisitos mínimos para aprobar

1. **Capa 1 completa:** `run_tests.` pasa sin fallos en SWI-Prolog
2. **Capa 2 completa:** al menos 2 GenServers + 1 Supervisor iniciando sin error
3. **Capa 3 completa:** programa Haskell u OCaml que compila y genera reporte
4. **Integración:** al menos un punto de conexión entre capas documentado
5. **Demostración en vivo:** el sistema corre sin modificaciones en el equipo del profesor

> Código que no compila = 0 en esa capa. No existe el pseudocódigo.

---

## Rúbrica (igual para todos los proyectos)

| Criterio | Peso |
|----------|------|
| Capa 1: tests `plunit` pasando, CLP(FD) usado | 30% |
| Capa 2: OTP/Clojure arrancando, supervisión demostrada | 30% |
| Capa 3: Haskell/OCaml compilando con tipos correctos | 20% |
| Integración entre capas documentada y funcional | 10% |
| Exposición técnica (10–15 min, demostración en vivo) | 10% |

---

## Entregables

Todos los entregables vía **Pull Request** a este repositorio antes del cierre del semestre:

```
proyectos_finales/proyectoN_<nombre>/
├── README.md          ← arquitectura, instrucciones de ejecución, decisiones de diseño
├── capa1/             ← código Prolog (*.pl)
├── capa2/             ← código Erlang (*.erl) o Clojure (*.clj)
└── capa3/             ← código Haskell (*.hs) u OCaml (*.ml + *.mli)
```

---

## Semana de entrega

**Semana 17 — 30 nov al 4 dic 2026**
Presentaciones en clase. El sistema debe correr sin modificaciones en el equipo del profesor.

---

## Mapa global: dónde viven estos paradigmas en producción

Más allá de los cuatro proyectos de este curso, la siguiente lista documenta dónde
la industria eligió programación funcional o lógica — y por qué el enfoque imperativo
no era suficiente. Organizada por sector, con escala verificable y justificación técnica.

---

### Telecomunicaciones y mensajería masiva

**WhatsApp — Erlang/OTP**
2 000 millones de usuarios activos. Un solo servidor Erlang mantiene 2 millones de
conexiones simultáneas con ~500 MB de RAM. El modelo de actores de OTP hace que el
fallo de una conexión sea imposible de propagar a otra — aislamiento por definición del
lenguaje, no por código defensivo. Con C++ o Java el mismo equipo de 50 ingenieros
no podría haber mantenido ese uptime a esa escala.

**Discord — Elixir/Phoenix (migrado desde Go)**
150 millones de usuarios, 7.5 millones de servidores concurrentes. El equipo migró
"Read States" (el sistema que trackea qué mensajes leíste) de MongoDB+Go a Elixir porque
Elixir mantiene millones de procesos con ~2 KB cada uno. Go creaba pausas de GC
que degradaban la latencia p99 a escala. Blog post técnico: *"How Discord Scaled Elixir
to 5 Million Concurrent Users"* (2020).

**RabbitMQ — Erlang/OTP**
Más de 35 000 empresas en producción en 2024 incluyendo NASA, Reddit, Instagram.
El supervisor tree garantiza que una cola de millones de mensajes nunca pierde datos
aunque el proceso que la gestiona muera — "let it crash" hace que la recuperación sea
automática en < 1 ms.

**Ericsson AXD301 — Erlang**
Switch de telecomunicaciones con 99.9999999 % uptime (nueve nueves = menos de
32 ms de downtime por año). Erlang fue creado por Joe Armstrong en Ericsson en 1986
precisamente para este hardware. Sigue en producción 38 años después. Es el argumento
más sólido del ROI de un paradigma en la historia de la ingeniería de software.

**Klarna — Erlang**
150 millones de consumidores, 500 000 transacciones diarias. Fintech sueco líder en
"buy now pay later". Eligió Erlang para que el fallo en el proceso de pago de un usuario
nunca sea observable por otro usuario — el aislamiento de procesos de Erlang es la
garantía, no los try/catch.

---

### Finanzas, banca y trading de alta frecuencia

**Nubank — Clojure (JVM)**
100 millones de clientes en América Latina. El banco digital más grande del mundo fuera
de Asia. Los `ref` + `dosync` de Clojure implementan STM (Software Transactional Memory):
los débitos y créditos de una transferencia son atómicos por definición del lenguaje.
Sin locks manuales, sin deadlocks posibles, sin el patrón try-catch-rollback que hace
el código bancario Java tan frágil. Blog técnico de Nubank: *"Why Clojure?"* (2021).

**Jane Street Capital — OCaml**
Procesa cientos de miles de millones de dólares en trading algorítmico al año. Jane Street
es el mayor market maker del mundo en ETFs. Eligió OCaml porque su sistema de tipos
captura errores financieros en compilación — confundir dólares con euros, o una cantidad
con un precio, es un error de tipo detectado antes de llegar al mercado. En trading de
alta frecuencia, un error en producción puede costar millones en milisegundos.

**Standard Chartered Bank — Haskell (equipo Strats)**
El equipo "Strats" (Strategies) de SCB usa Haskell para modelar instrumentos financieros
complejos. Haskell permite expresar "un portafolio de bonos en USD" como un tipo distinto
de "un portafolio de bonos en MXN" — el compilador hace imposible mezclarlos. El tipo es
el contrato financiero.

**IOHK / Cardano — Haskell**
Blockchain top-10 por capitalización de mercado. Los contratos inteligentes de Cardano
se escriben en Plutus, un DSL embebido en Haskell, y se verifican formalmente.
El hack del DAO en Ethereum (2016) costó 60 millones de dólares por un error de
re-entrancia en Solidity (lenguaje imperativo). Cardano eligió Haskell para que ese
tipo de error sea un error de tipo, no un bug de runtime.

**Societe Generale — Scala + DSLs funcionales**
Uno de los 10 bancos más grandes de Europa. Usa Scala y DSLs funcionales internos para
modelar derivados financieros. Un `Option` europeo mal tipado se detecta antes de
llegar al mercado de opciones, no después de la liquidación.

---

### Análisis estático y herramientas de compilación

**Meta Flow — OCaml**
Analiza más de 100 millones de líneas de JavaScript en Meta, Facebook e Instagram
en cada commit. El núcleo de Flow es unificación de tipos — el mismo algoritmo que
usa el motor de Prolog — implementado en OCaml que compila a binario nativo.
Procesarlo en Python sería 50× más lento. Flow fue creado por Avik Chaudhuri y
Gabriel Levi en Meta en 2014 y liberado como open source.

**Meta Hack — OCaml (compilador y type checker)**
Hack es el lenguaje de tipado gradual que reemplazó PHP en Meta. El compilador de
Hack está escrito en OCaml por las mismas razones que Flow: inferencia de tipos de un
lenguaje dinámico a escala de cientos de millones de líneas es un problema de
unificación lógica, y OCaml es la herramienta natural.

**Meta Infer — OCaml**
Analizador estático de C/C++/Java/Kotlin que detecta null dereferences y memory leaks
*antes* del commit. Facebook, Spotify y Amazon lo usan en su CI. Infer implementa
Separation Logic — una extensión de la lógica de predicados — para razonar sobre el
estado del heap de forma composicional. Es lógica formal ejecutable en producción.

**GitHub Semantic — Haskell**
Parsea código de 20+ lenguajes para alimentar Code Navigation en GitHub.com (definición,
referencias, hover). Representa ASTs multi-lenguaje con tipos algebraicos: imposible
confundir un nodo de Python con uno de Ruby en tiempo de compilación. Liberado como
open source por GitHub en 2018.

**Pandoc — Haskell**
El convertidor de documentos más usado en el mundo académico. Soporta 64 formatos de
entrada y 64 de salida (Markdown, LaTeX, DOCX, HTML, EPUB, RST, etc.).
El tipo central `Pandoc` garantiza que ninguna conversión pierda estructura semántica.
Con 4 096 combinaciones posibles, un enfoque imperativo con ifs anidados sería
inmantenible. Es el ejemplo más citado de "Haskell en producción real".

**GHC — el compilador de Haskell, escrito en Haskell**
El compilador de Haskell se compila a sí mismo desde 1990 (bootstrapping). El sistema
de tipos de GHC es tan expresivo que se ha usado para demostrar teoremas de lógica
(isomorfismo de Curry-Howard: tipos = proposiciones, programas = demostraciones).

---

### Inteligencia artificial simbólica y sistemas expertos

**IBM Watson Jeopardy! — Prolog + lógica de predicados**
En 2011 Watson derrotó a los campeones humanos de Jeopardy! con 1 millón de documentos
en su base de hechos. El Knowledge Graph de Watson usa reglas de inferencia lógica:
`es_autor_de(X,Y) ∧ trata_sobre(Y,Z) → conoce_sobre(X,Z)`. El backtracking sobre
millones de hechos es el motor de búsqueda; en imperativo sería BFS/DFS manual.

**Soufflé Datalog — Meta y AWS**
Meta usa Soufflé para analizar millones de APKs de Android detectando vulnerabilidades.
AWS lo usa en re:Inforce para verificar políticas IAM. Datalog expresa
"una variable fluye desde una fuente externa hasta un sink SQL" como una regla recursiva;
el motor la evalúa en paralelo sin que el programador gestione la concurrencia.

**NASA SPIKE — Prolog (Mars Pathfinder, Spirit, Opportunity)**
El sistema de planificación de secuencias de comandos para los Mars Rovers usa Prolog.
Las restricciones de misión son relaciones lógicas (recursos, tiempos, dependencias
entre operaciones). Prolog hace backtracking automático sobre miles de restricciones;
el equivalente imperativo requeriría un solver dedicado de miles de líneas.

**Ericsson — configuración declarativa de red con Prolog**
Los requisitos de red son naturalmente relacionales: "el nodo A debe tener ruta al nodo B
con latencia < 5 ms sin pasar por el nodo C en mantenimiento". Prolog unifica esas
restricciones y encuentra la configuración válida, o demuestra que no existe — sin código
imperativo que itere sobre topologías.

**Google Knowledge Graph — OWL / SPARQL / lógica descriptiva**
El Knowledge Graph de Google cubre 500 000 millones de hechos y alimenta los
paneles de conocimiento de búsqueda. Los razonadores OWL infieren que "Barack Obama"
y "el 44.º presidente de EE. UU." son la misma entidad. Es unificación lógica a escala
de petabytes. Wikidata, DBpedia y Freebase usan el mismo modelo formal.

---

### Bases de datos declarativas e inmutables

**Datomic — Clojure + Datalog (Nubank)**
La base de datos transaccional core de Nubank. En Datomic no se borra ni se modifica:
cada transacción agrega un hecho nuevo. Es el modelo exacto de Prolog — la base solo
crece. Permite consultar el estado de cualquier instante pasado sin snapshots ni backups:
el historial es la base de datos.

**CouchDB — Erlang**
Miles de instalaciones hospitalarias, IoT, y aplicaciones offline-first. Erlang garantiza
que una escritura fallida nunca corrompe el documento existente. La inmutabilidad
funcional protege la integridad del registro médico aunque el nodo pierda energía a mitad
de la escritura — propiedad que ningún motor imperativo puede garantizar sin WAL
explícito.

---

### Big Data e infraestructura distribuida

**Apache Spark — Scala (API funcional)**
El framework de procesamiento distribuido más usado del mundo. Netflix, Alibaba, Airbnb
y Uber procesan petabytes diariamente con él. Su API es un pipeline funcional puro:
`Dataset.filter(…).map(…).groupBy(…)` — evaluación perezosa sobre datos distribuidos.
El DAG de ejecución se construye sin mover datos; se materializa solo al final.

**Apache Kafka — Scala (creado en LinkedIn)**
900 millones de perfiles en LinkedIn; el sistema de mensajería de mayor throughput
del mundo. El modelo producer/consumer es un pipeline de transformaciones de streams
inmutables — la misma idea que `Stream.map` y `Stream.filter` en Elixir, pero distribuido
en cientos de nodos. LinkedIn lo liberó como open source en 2011.

**Twitter / X — Scala (Finagle framework)**
500 millones de tweets por día. Finagle modela cada petición de red como un
`Future[Response]` — composición funcional de operaciones asíncronas sin callbacks,
sin locks, sin condiciones de carrera en el modelo de composición de futuros.

**Apache Flink — API funcional sobre JVM**
Procesamiento de streams en tiempo real. Alibaba usa Flink para el 11.11 (Singles' Day),
el mayor evento de e-commerce del mundo: billones de eventos procesados en horas.
La API de Flink: `DataStream.map().filter().keyBy()`. La inmutabilidad garantiza
que los operadores se ejecutan en paralelo sin coordinación explícita.

---

### Blockchain y verificación formal

**Cardano Marlowe — DSL funcional sobre Haskell**
Contratos financieros en blockchain con garantías formales de terminación y de que
ningún fondo puede quedar atrapado. La semántica de Marlowe es verificable
matemáticamente — propiedad imposible de garantizar con un lenguaje de propósito
general imperativo.

**Coq / Isabelle — lógica de tipo dependiente**
Usado por Airbus para verificar software de control de vuelo crítico. CompCert es un
compilador de C verificado formalmente en Coq: el código generado tiene una prueba
matemática de corrección. La lógica de tipo dependiente es la generalización directa
de la lógica de predicados de Prolog.

---

### Bioinformática y ciencias computacionales

**Clingo / ASP — plegamiento de proteínas**
Answer Set Programming se aplica activamente en el diseño de fármacos contra Alzheimer,
cáncer y SARS-CoV-2. El problema: "encuentra una conformación molecular que satisfaga
todas las restricciones de enlace químico y ángulos de torsión". Es un CSP —
exactamente lo que CLP(FD) de Prolog resuelve para dominios finitos.

**Pipelines de secuenciación genómica — Haskell**
El proyecto UK 100 000 Genomes y otros proyectos similares procesan archivos de
100+ GB por muestra. La evaluación perezosa de Haskell permite procesar el genoma
completo (3 000 millones de bases) con memoria constante — cargar todo en RAM sería
físicamente imposible en la mayoría de los servidores.

---

### Resumen por lenguaje

```
Erlang / Elixir   →  WhatsApp, Discord, RabbitMQ, Klarna, CouchDB
OCaml             →  Meta Flow, Meta Hack, Meta Infer, Jane Street Capital
Haskell           →  Cardano/Plutus, Pandoc, GHC, GitHub Semantic, Standard Chartered
Clojure           →  Nubank, Datomic
Scala             →  Apache Spark, Apache Kafka, Twitter/Finagle, Apache Flink
SWI-Prolog        →  IBM Watson, NASA SPIKE, Ericsson configuración de red
Datalog/Soufflé   →  Meta APK analysis, AWS IAM policy verification
OWL/SPARQL        →  Google Knowledge Graph, Wikidata, DBpedia
ASP/Clingo        →  diseño de fármacos, bioinformática, planificación robótica
Coq/Isabelle      →  Airbus software crítico, CompCert compilador certificado
```

> Ninguno de estos sistemas existe en un laboratorio.
> Todos están procesando datos reales mientras lees esto.
