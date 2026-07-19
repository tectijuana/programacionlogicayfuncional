# Proyectos Finales — Integración Multi-Paradigma

**TecNM Tijuana — Ingeniería en Sistemas Computacionales**
**Programación Lógica y Funcional**

---

## Por qué estos dominios importan

Los cuatro proyectos son **modelos simplificados, inspirados en problemas reales**
que enfrentan instituciones y empresas mexicanas e internacionales. No afirmamos que
el IMSS, el SAT, CENAPRED o una maquiladora específica usen exactamente estos lenguajes
en producción: lo que afirmamos —y sí es verificable— es que **problemas de esta clase**
(reglas de negocio, asignación con restricciones, monitoreo tolerante a fallos, validación
fiscal tipada) se resuelven en la industria con las técnicas que practicas aquí.

> Para la distinción entre "lenguaje principal de un sistema" y "motor de razonamiento
> declarativo", y para la lista de casos **verificados**, consulta
> [`casos_reales_mundo_real.md`](../casos_reales_mundo_real.md).

---

### Proyecto 1 — Trámites IMSS
El IMSS atiende a decenas de millones de derechohabientes. Trámites como incapacidades,
pensiones y préstamos dependen de reglas de elegibilidad que cambian por decreto.
Este tipo de lógica —condiciones que se *declaran*, no se programan paso a paso— es el
caso de uso natural de los **motores de reglas de negocio declarativas** como el que
construyes en Prolog. Los motores de reglas y la lógica declarativa se usan en la
industria de seguros y salud para precisamente esta clase de problema.

> Las reglas de elegibilidad de un trámite no describen *cómo* calcular, sino *qué*
> condiciones deben cumplirse. Prolog es un lenguaje diseñado alrededor de esa idea.

---

### Proyecto 2 — Turnos en línea de ensamble (maquiladora)
Tijuana concentra cientos de plantas maquiladoras. En una línea de ensamble, cada turno
hay que asignar operadores a estaciones —soldadura, PCB, inspección de calidad— sin
traslapes y respetando las certificaciones que cada puesto exige. Ese es un **problema
de satisfacción de restricciones (CSP)**: la misma clase de problema que herramientas
industriales como Google OR-Tools, IBM CP Optimizer y SAP APO resuelven con los mismos
principios que `CLP(FD)` en Prolog.

> Este proyecto no afirma reproducir el sistema de ninguna planta en particular: modela
> un problema de asignación con restricciones —representativo de la manufactura— que en
> la industria se resuelve con solvers de restricciones y optimización. La herramienta
> exacta en producción varía; los principios son los mismos que ves en `planificador.pl`.

---

### Proyecto 3 — Monitor IoT CENAPRED
México opera redes de monitoreo en tiempo real —sísmico, volcánico, hidrometeorológico—
donde un sensor que falla no puede tumbar toda la red de alerta. Ese requisito de
**tolerancia a fallos por aislamiento** es justamente el problema que resuelve el modelo
de supervisión de Erlang/OTP. Es el mismo modelo —procesos ligeros aislados, "let it
crash" y reinicio automático— que WhatsApp (Erlang/OTP) y Discord (Elixir sobre BEAM)
usan para sostener millones de conexiones concurrentes con alta disponibilidad.

> Este proyecto modela un monitor inspirado en sistemas de alerta temprana; no reproduce
> la infraestructura de CENAPRED ni del SASMEX. Lo que sí es real es el principio: un
> sensor que falla no debe detener la red, y Erlang/OTP da ese aislamiento por diseño
> —no por código defensivo— como demuestras con `kill(pid)`.

---

### Proyecto 4 — Inventario SAT
En México se emiten miles de millones de CFDIs (facturas electrónicas) al año. Cada una
pasa por validación de RFC, cálculo de IVA y verificación de restricciones fiscales —la
misma clase de reglas que codificas en `reglas_fiscales.pl`. Hacer estas validaciones
con **tipos fuertes** —de modo que un dato mal formado ni siquiera se pueda construir— es
la estrategia que usan equipos como los de Meta (Flow, Hack, Infer en OCaml) y Jane Street
(OCaml en trading): el tipo correcto convierte un error de datos en un error de compilación.

> Un `RFC` modelado como tipo en Haskell que solo se puede construir vía `validarRFC` hace
> que un RFC mal formado sea imposible *en tiempo de compilación*, no algo que se detecta
> tarde en tiempo de ejecución. Esa es la ventaja de "hacer estados inválidos
> irrepresentables".

---

## Objetivo

Demostrar dominio integrado de los tres paradigmas del curso construyendo un sistema
real que use cada paradigma donde tiene ventaja natural:

| Capa | Paradigma | Por qué aquí |
|------|-----------|--------------|
| Validación de reglas de negocio | **Lógico** (SWI-Prolog) | Declarar *qué* es válido, backtracking gratis, CLP(FD) para restricciones numéricas |
| Estado, concurrencia y resiliencia | **Funcional** (Erlang/OTP o Clojure) | Inmutabilidad + supervisión automática + sin race conditions por diseño |
| Reportes y pipeline de datos | **Funcional con tipos o streams** (Haskell o Elixir, según el proyecto) | El tipo es la documentación; imposible generar un reporte mal formado |

---

## Proyectos disponibles — elige uno

| # | Proyecto | Dominio | Paradigmas requeridos |
|---|----------|---------|----------------------|
| [1](proyecto1_tramites_imss/) | Sistema de validación de trámites IMSS | Seguridad social | Prolog + Erlang/OTP + Haskell |
| [2](proyecto2_maquiladora/) | Asignación de turnos en línea de ensamble | Manufactura / maquiladora | Prolog CLP(FD) + Clojure |
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
2. **Capa 2 completa:** P1/P3/P4: al menos 2 GenServers + 1 Supervisor iniciando sin error; P2: estado del turno en Clojure (`atom`) con historial inmutable
3. **Capa 3 completa:** programa Haskell (P1, P4) o Elixir (P3) que compila y genera el reporte — no aplica en P2 (ver rúbrica)
4. **Integración:** al menos un punto de conexión entre capas documentado
5. **Demostración en vivo:** el sistema corre sin modificaciones en el equipo del profesor

> Código que no compila = 0 en esa capa. No existe el pseudocódigo.

---

## Rúbrica (igual para todos los proyectos)

| Criterio | Peso |
|----------|------|
| Capa 1: tests `plunit` pasando, CLP(FD) usado | 20% |
| Capa 2: OTP/Clojure arrancando, supervisión demostrada | 20% |
| Capa 3: Haskell o Elixir (según el proyecto) compilando con tipos correctos | 15% |
| **Integración entre capas documentada y funcional** | **25%** |
| Exposición técnica (10–15 min, demostración en vivo) | 10% |
| Evidencia de ejecución: asciinema (CLI) + LOOM (UI si aplica) | 10% |

> La integración es el criterio de mayor peso: tres programas que corren por separado
> pero no se hablan entre sí **no** son un sistema multi-paradigma.
>
> **Proyecto 2 (maquiladora):** tiene solo dos capas por diseño; el 15 % de la Capa 3 se
> suma a la Capa 2 (Clojure, que entonces vale 35 %) y esta debe incluir la impresión o
> exportación del reporte del turno.

---

## Entregables

Pull Request a este repositorio antes del cierre del semestre con la siguiente estructura:

```
proyectos_finales/proyectoN_<nombre>/
├── README.md          ← arquitectura, instrucciones de ejecución, decisiones de diseño
├── capa1/             ← código Prolog (*.pl)
├── capa2/             ← código Erlang (*.erl) o Clojure (*.clj)
└── capa3/             ← código Haskell (*.hs) u Elixir (*.exs)
```

**Evidencia requerida en la descripción del PR:**

| Capa | Herramienta | Qué grabar |
|------|-------------|------------|
| Capa 1 — Prolog | [asciinema](https://asciinema.org) | `run_tests.` pasando en SWI-Prolog |
| Capa 2 — Erlang/Clojure | [asciinema](https://asciinema.org) | Supervisor arrancando + demostración de reinicio tras `kill` |
| Capa 3 — Haskell/Elixir | [asciinema](https://asciinema.org) | Compilación y salida del reporte o dashboard |
| UI o dashboard gráfico (si el proyecto lo incluye) | [LOOM](https://www.loom.com) | Video de pantalla máx. 5 min |
| Mockups de interfaz | [Google Stitch](https://stitch.withgoogle.com) | Exportar imagen e incluir en `README.md` |

> Un PR sin los links de evidencia se considera incompleto — 0 en el criterio de demostración.
>
> Recuerda las dos reglas generales del curso (ver sílabo): **todo programa
> lleva el encabezado del programador** (con la URL del asciinema incluida) y
> **toda grabación abre con el `echo` de identificación** antes de cualquier
> otro comando.

---

## Calendario de hitos

El proyecto se elige en la **semana 9** y se desarrolla por hitos escalonados —
cada hito se entrega como avance en el mismo PR del proyecto:

| Semana | Hito | Qué se revisa |
|--------|------|---------------|
| 9 | Elección de proyecto (P1–P4) | Registro del proyecto en el PR de inicio |
| 12 | **Hito 1** — Capa 1 (Prolog) | `run_tests.` pasando; asciinema en el PR |
| 14 | **Hito 2** — Capa 2 (OTP/Clojure) | Supervisor/estado arrancando sin error |
| 16 | **Hito 3** — Capa 3 + integración | Sistema completo compilando e integrado |
| 17 | Presentación en vivo | Demostración final |

## Semana de entrega

**Semana 17 — 30 nov al 4 dic 2026**
Presentaciones en clase. El sistema debe correr sin modificaciones en el equipo del profesor.

---

## Mapa global: dónde viven estos paradigmas en producción

Más allá de los cuatro proyectos de este curso, la siguiente lista documenta dónde
la industria eligió programación funcional o lógica — y por qué el enfoque imperativo
no era suficiente. Organizada por sector, con justificación técnica.

> **Nota sobre el rigor de estas afirmaciones.** Las cifras (usuarios, transacciones,
> uptime) son aproximadas y provienen de blogs de ingeniería, charlas y publicaciones de
> las propias empresas; cita la fuente primaria antes de usarlas en un trabajo formal.
> Distingue dos cosas distintas: cuando un lenguaje es **la base de un sistema completo**
> (Erlang en WhatsApp, Clojure en Nubank) y cuando es **un motor de razonamiento o capa
> declarativa** dentro de un sistema mayor (Datalog en CodeQL, Prolog en un planificador).
> Para la lista corta de casos **verificados y mejor documentados**, usa
> [`casos_reales_mundo_real.md`](../casos_reales_mundo_real.md).

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
Switch de telecomunicaciones para el que se diseñó Erlang (Joe Armstrong y su equipo,
Ericsson, finales de los 80). Se le atribuye una disponibilidad de "nueve nueves"
(99.9999999 %, ~32 ms de downtime al año); conviene presentarlo con matiz: la cifra es
**frecuentemente citada pero anecdótica** —proviene del reporte de un cliente sobre un
sistema de 11 nodos— y la confiabilidad real combina Erlang con redundancia de hardware
y código en C. Aun con ese matiz, sigue siendo uno de los casos clásicos sobre el ROI de
elegir un paradigma orientado a tolerancia a fallos.

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

**NASA / STScI SPIKE — planificación basada en restricciones**
SPIKE es el sistema de planificación de observaciones del Telescopio Espacial Hubble
(desarrollado por el STScI, en operación desde 1990) y reutilizado después para otras
misiones de observación. Es un planificador basado en IA y restricciones: las reglas de
misión —recursos, tiempos, dependencias entre operaciones— se modelan como restricciones
y el sistema busca una asignación válida. Es el mismo tipo de problema (CSP) que resuelves
con CLP(FD) en Prolog, aunque SPIKE no está implementado en Prolog (usó técnicas de IA
sobre Lisp y enfoques de reglas y redes neuronales). El valor didáctico está en el
**modelo declarativo de restricciones**, no en el lenguaje exacto.

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
Prolog / lógica   →  IBM Watson (análisis de lenguaje), motores de reglas y sistemas expertos
CSP / restricc.   →  STScI SPIKE (Hubble), Google OR-Tools, planificación industrial
Datalog/Soufflé   →  Meta APK analysis, AWS IAM policy verification
OWL/SPARQL        →  Google Knowledge Graph, Wikidata, DBpedia
ASP/Clingo        →  diseño de fármacos, bioinformática, planificación robótica
Coq/Isabelle      →  Airbus software crítico, CompCert compilador certificado
```

> La mayoría de estos sistemas opera con datos reales en producción hoy. Antes de citar
> una cifra o un caso concreto en un trabajo formal, verifica la fuente primaria: el
> objetivo del curso es que aprendas a sostener afirmaciones, no solo a repetirlas.
