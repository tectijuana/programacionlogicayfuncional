# Plan de Renovación: Programación Lógica y Funcional
## TecNM — Ingeniería en Sistemas Computacionales
## Temario oficial: 4 Unidades × 16 horas = 64 horas semestre

---

## Hilo conductor del curso

> "El código que escribe Meta para analizar 100 millones de líneas de JavaScript
> está escrito en OCaml. El backend de Nubank que procesa millones de transacciones
> SPEI usa Clojure. WhatsApp maneja 2 millones de conexiones por servidor con Erlang.
> Tú aprenderás los paradigmas que hacen eso posible."

---

## UNIDAD 1 — Conceptos Fundamentales (16 horas / 4 sesiones × 4 horas)

### Tema 1.1 — Introducción a la Programación Lógica y Funcional (sesión 1, 4 h)

**Problema motivador:** ¿Por qué C# y Python fallan a escala de WhatsApp?
- Demo: race condition en Python threading (estado mutable compartido)
- Demo: la misma lógica en Erlang — imposible el race condition por diseño
- Taxonomía de paradigmas: imperativo → OOP → funcional → lógico → declarativo
- Primer contacto con los 4 lenguajes del semestre: SWI-Prolog, Erlang, Haskell, Clojure
- Herramienta del día: AWS Academy (CloudShell + nodo EC2 remoto) — ambiente unificado sin instalación local, accesible desde PC o celular; se entregan los $50 USD de crédito del semestre

**Tarea 1.1:** "Hola Paradigma" — imprimir una lista de números en 4 lenguajes
(bucle imperativo en Python vs. recursión en Erlang vs. list comprehension en Haskell vs. `map` en Clojure)

---

### Tema 1.2 — Historia y evolución de los paradigmas (sesión 2, 4 h)

**Línea de tiempo interactiva:**
- 1930s: Lambda Calculus (Church) — fundamento matemático del paradigma funcional
- 1958: LISP — el primer lenguaje funcional práctico
- 1972: Prolog — lógica de predicados ejecutable (Colmerauer, Kowalski)
- 1986: Erlang — funcional + concurrencia para telecomunicaciones (Ericsson)
- 1990: Haskell — el estándar académico de la FP pura
- 2003: Scala — FP + OOP sobre JVM
- 2007: Clojure — LISP moderno sobre JVM (Rich Hickey)
- 2011: Elixir — ergonomía moderna sobre BEAM de Erlang
- 2024: Gleam — tipos estáticos sobre BEAM

**Casos de industria con fecha:**
- 1998-hoy: Ericsson AXD301 (Erlang) — 99.9999999% uptime en telecomunicaciones
- 2009: WhatsApp elige Erlang — un equipo de 50 ingenieros atiende 900M usuarios
- 2013: Meta lanza Flow y Hack — ambos escritos en OCaml
- 2013: Nubank funda su stack en Clojure — hoy procesa millones de transacciones SPEI-equivalentes
- 2025: Boris Cherny (Meta/Flow en OCaml) crea Claude Code en Anthropic

**Tarea 1.2:** Investigación documentada — elegir un sistema de producción,
identificar el paradigma que usa y por qué fue esa la elección de ingeniería.

---

### Tema 1.3 — Comparación con otros paradigmas (sesiones 3-4, 8 h)

**Sesión 3 — Eje: ¿qué garantiza cada paradigma?**

| Característica | Imperativo (C#) | Funcional (Haskell) | Lógico (Prolog) |
|---|---|---|---|
| Estado | Mutable | Inmutable | Sin estado explícito |
| Error handling | Excepciones | `Maybe`/`Either` | Backtracking |
| Concurrencia | Difícil (locks) | Natural (sin estado) | No es su dominio |
| Verificación | Runtime | Compilación | Inferencia lógica |
| Deuda técnica | Alta | Baja | Media |

**Ejercicio concreto:** validar una CURP mexicana (18 caracteres, estructura fija)
en los 3 paradigmas. Medir:
- Líneas de código
- Qué errores atrapa el compilador vs. cuáles llegan a runtime
- Legibilidad para mantenimiento

**Sesión 4 — Eje: accidental vs. esencial complexity**
- Concepto de Fred Brooks: ¿qué complejidad impone el problema? ¿cuál impone el lenguaje?
- Ejemplo: procesar 10 millones de registros de contribuyentes SAT
  - Python: complejo accidentalmente (GIL, gestión de memoria, mutabilidad)
  - Erlang: complejidad esencial únicamente (el problema en sí)
- Debate estructurado: ¿cuándo NO usar programación funcional?
- Cierre: mapa mental del semestre — qué cubre cada paradigma

**Proyecto integrador U1:** Comparativa formal — factorial en 4 lenguajes.
Documenta: líneas de código, recursión de cola (sí/no), garantías en compilación,
tiempo de ejecución para n=1,000,000. Presentación 10 minutos con demostración en vivo.

---

## UNIDAD 2 — Modelo de Programación Funcional (16 horas / 4 sesiones × 4 h)

### Tema 2.1 — Fundamentos de la programación funcional (sesión 1, 4 h)

**Erlang como lenguaje de entrada al paradigma funcional:**
- Inmutabilidad: una vez asignado, no se cambia — nunca
- Transparencia referencial: `f(x)` siempre retorna el mismo resultado para el mismo `x`
- Funciones puras vs. funciones con efectos laterales
- Pattern matching: la alternativa funcional al `switch`/`if-else` en cadena

```erlang
-module(curp).
-export([validar/1]).

%% Pattern matching sobre longitud y estructura — sin if anidados
validar(CURP) when length(CURP) =:= 18 ->
    {ok, analizar(CURP)};
validar(_) ->
    {error, longitud_invalida}.

analizar([A,B,C,D | Resto]) ->
    #{nombre => [A,B,C,D], sufijo => Resto}.
```

**Tarea 2.1:** Reescribir un validador de RFC mexicano que el alumno ya tenga en
Python/C#, en Erlang puro. Prohibido: variables mutables, excepciones, `if` sin pattern matching.

---

### Tema 2.2 — Funciones de primera clase y funciones de orden superior (sesión 2, 4 h)

**Clojure como lenguaje de demostración:**
- Funciones como valores: asignar, pasar, retornar funciones
- `map`, `filter`, `reduce` — no como métodos, como conceptos matemáticos
- Closures: funciones que capturan su entorno
- Composición de funciones: `comp` y el pipe `->>`

```clojure
;; Procesar registros de alumnos TecNM — pipeline funcional
(def alumnos
  [{:nombre "García" :promedio 8.5 :unidad "Tijuana"}
   {:nombre "López"  :promedio 6.9 :unidad "Mexicali"}
   {:nombre "Ramos"  :promedio 9.1 :unidad "Tijuana"}])

;; Composición: filtrar → transformar → agregar
(->> alumnos
     (filter #(>= (:promedio %) 7.0))
     (map #(assoc % :beca true))
     (group-by :unidad))
```

**Conexión Nubank:** este mismo patrón procesa millones de transacciones financieras
en producción — `filter` identifica transacciones sospechosas, `map` las enriquece,
`reduce` produce el balance.

**Tarea 2.2:** Pipeline de procesamiento de calificaciones TecNM: cargar CSV de alumnos,
filtrar reprobados, calcular promedio grupal, generar reporte — todo en Clojure
sin una sola variable mutable.

---

### Tema 2.3 — Recursión y estructuras de datos inmutables (sesión 3, 4 h)

**Haskell para tipos y recursión pura:**
- Recursión de cola (TCO): cuándo el compilador optimiza, cuándo no
- Acumuladores: patrón go/2 para convertir recursión en TCO
- Listas como estructura fundamental: `[]`, `(:)`, pattern matching
- `Maybe a` y `Either e a`: recursión que puede fallar elegantemente

```haskell
-- Factorial con acumulador — tail recursive
factorial :: Integer -> Integer
factorial n = go n 1
  where
    go 0 acc = acc
    go k acc = go (k - 1) (k * acc)

-- Búsqueda en lista de alumnos — retorna Maybe, nunca falla
buscarAlumno :: String -> [Alumno] -> Maybe Alumno
buscarAlumno _ []     = Nothing
buscarAlumno num (a:as)
  | matricula a == num = Just a
  | otherwise          = buscarAlumno num as
```

**Erlang para estructuras inmutables en producción:**
- Por qué Erlang puede tener miles de procesos con su propia copia del estado
- `lists:foldl/3` como `reduce` — el acumulador como patrón universal

**Tarea 2.3:** Implementar árbol binario de búsqueda completamente inmutable en
Haskell: `insertar`, `buscar`, `eliminar`. Cada operación retorna un árbol nuevo,
nunca modifica el original. Demostrar con QuickCheck que `buscar (insertar k v t) k == Just v`.

---

### Tema 2.4 — Evaluación perezosa / Lazy Evaluation (sesión 4, 4 h)

**Haskell: lazy by default**
- Evaluación normal vs. aplicativa: Haskell evalúa solo lo necesario
- Listas infinitas: `[1..]`, `iterate`, `cycle`, `repeat`
- Streams: procesar gigabytes sin cargarlos en memoria

```haskell
-- Lista infinita de números de Fibonacci — no se evalúa hasta que se necesita
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- Solo tomar los primeros 10 — el resto nunca se computa
take 10 fibs  -- [0,1,1,2,3,5,8,13,21,34]

-- Primos infinitos con criba de Eratóstenes
primes :: [Integer]
primes = criba [2..]
  where criba (p:xs) = p : criba [x | x <- xs, x `mod` p /= 0]
```

**Elixir `Stream` para datos de producción:**
- Procesar archivos de millones de líneas (registros IMSS) sin cargar en RAM
- `Stream.filter`, `Stream.map`, `Stream.chunk_every` — lazy chains

```elixir
# Procesar archivo de derechohabientes IMSS — nunca carga todo en memoria
File.stream!("derechohabientes.csv")
|> Stream.drop(1)                          # saltar encabezado
|> Stream.map(&String.split(&1, ","))
|> Stream.filter(fn [_, _, vigente | _] -> vigente == "true" end)
|> Stream.take(10_000)
|> Enum.to_list()
```

**Tarea 2.4:** Generar los primeros 1,000,000 de números primos en Haskell usando
evaluación lazy. Comparar memoria usada vs. una versión que genera la lista completa
antes de filtrar. Graficar la diferencia.

---

### Tema 2.5 — Aplicaciones de la programación funcional (sesión extra/proyecto)

**Erlang/OTP en producción — el modelo completo:**
- GenServer: proceso con estado gestionado — NUNCA `spawn` sin supervisión
- Supervisor: árbol de supervisión, estrategias `one_for_one`
- "Let it crash": filosofía de ingeniería, no descuido

```erlang
-module(sensor_temp).
-behaviour(gen_server).

start_link(Id) -> gen_server:start_link(?MODULE, Id, []).
leer(Pid)      -> gen_server:call(Pid, leer).

init(Id) -> {ok, #{id => Id, lecturas => []}}.

handle_call(leer, _From, State = #{lecturas := Ls}) ->
    Temp = simular_lectura(),
    {reply, Temp, State#{lecturas => [Temp | Ls]}}.
```

**Proyecto integrador U2:** Sistema de monitoreo de sensores IoT estilo CENAPRED.
- 5 GenServers simulando sensores (temperatura, humedad, presión, CO2, sismo)
- DynamicSupervisor: si un sensor cae, se reinicia automáticamente
- Proceso agregador en Elixir: pipeline `Stream` que calcula promedios cada 10 segundos
- Alerta en consola cuando se supera umbral — demostrar "let it crash" en vivo:
  `Process.exit(pid, :kill)` → el supervisor lo reinicia en < 1ms

---

## UNIDAD 3 — Programación Lógica (16 horas / 4 sesiones × 4 h)

### Tema 3.1 — Fundamentos de la programación lógica (sesión 1, 4 h)

- El cambio de mentalidad: describir QUÉ es verdad, no CÓMO calcularlo
- Lógica proposicional → lógica de predicados de primer orden
- Términos, átomos, variables, estructuras, listas en Prolog
- Hechos y consultas: la base de datos lógica más simple posible

```prolog
% Base de conocimiento — relaciones familiares con contexto mexicano
% padre/2 — determinista
padre(don_aurelio, carlos).
padre(don_aurelio, rosa).
padre(carlos, ana).
padre(carlos, luis).

% Consultas en SWI-Prolog:
% ?- padre(don_aurelio, X).   % X = carlos ; X = rosa
% ?- padre(X, ana).            % X = carlos
```

**Tarea 3.1:** Construir base de hechos de la estructura departamental de TecNM Tijuana:
departamentos, profesores, materias. Escribir 10 consultas que respondan preguntas reales.

---

### Tema 3.2 — Sistemas formales y lógica de predicados (sesión 2, 4 h)

- Cálculo de predicados: cuantificadores ∀ y ∃ → su equivalente en Prolog
- Reglas: `cabeza :- cuerpo` como implicación lógica
- Conjunción (`,`), disyunción (`;`), negación (`\+`)
- Negación como falla (NAF): semántica del mundo cerrado — supuestos y límites

```prolog
% ancestro/2 — regla recursiva
% ancestro(X, Y) ← "X es ancestro de Y"
ancestro(X, Y) :- padre(X, Y).
ancestro(X, Y) :- padre(X, Z), ancestro(Z, Y).

% Negación como falla — cuidado con sus límites semánticos
no_es_padre(X, Y) :- \+ padre(X, Y).
% ¡Atención! Esto significa "no hay prueba de que X sea padre de Y"
% NO significa "X no es padre de Y" en lógica clásica
```

**Tarea 3.2:** Formalizar en Prolog las reglas de elegibilidad para beca TecNM:
promedio mínimo, sin materias reprobadas, créditos mínimos, no exceder ingresos familiares.
Consultar sobre 20 alumnos ficticios con datos variados.

---

### Tema 3.3 — Unificación y resolución (sesión 3, 4 h)

- El algoritmo de unificación de Martelli-Montanari: pasos formales
- Árbol de resolución: SLD-resolución, cómo Prolog busca pruebas
- Unificación vs. asignación: diferencia fundamental con lenguajes imperativos
- Occurs check: por qué Prolog lo omite y cuándo importa

```prolog
% Demostración de unificación
% ?- f(X, b) = f(a, Y).    →  X = a, Y = b (unifica)
% ?- f(X) = g(X).          →  false (functores distintos)
% ?- X = f(X).             →  X = f(f(f(...))) — estructura circular (occurs check)

% Traza del árbol de resolución para ancestro(don_aurelio, ana):
% Goal: ancestro(don_aurelio, ana)
%   Cláusula 1: padre(don_aurelio, ana) → false
%   Cláusula 2: padre(don_aurelio, Z), ancestro(Z, ana)
%     Z = carlos → ancestro(carlos, ana)
%       Cláusula 1: padre(carlos, ana) → true ✓
```

**Tarea 3.3:** Trazar manualmente el árbol de resolución para 5 consultas
distintas sobre la base de datos de cine mexicano
([`unidad3/tema3.3/movies.pl`](unidad3/tema3.3/movies.pl) — incluye las 5
consultas sugeridas y 15 tests plunit).
Identificar: puntos de backtracking, cuts útiles, consultas que no terminan.

---

### Tema 3.4 — Introducción a Prolog (sesión 4, 4 h)

- Listas en Prolog: representación `[H|T]`, patrones de recursión
- Predicados fundamentales: `member/2`, `append/3`, `length/2`, `nth0/3`, `msort/2`
- Aritmética en Prolog: `is/2`, `=:=`, diferencia con unificación `=`
- Entrada/salida: `write/1`, `read/1`, `format/2`

```prolog
% Implementación propia de member/2 — entender la recursión en listas
% member/2 — no-determinista, genera todas las soluciones
mi_member(X, [X|_]).
mi_member(X, [_|T]) :- mi_member(X, T).

% Implementación de suma de lista
% suma_lista/3 — determinista con acumulador
suma_lista(Lista, Suma) :- suma_lista(Lista, 0, Suma).
suma_lista([], Acc, Acc).
suma_lista([H|T], Acc, Suma) :- Acc1 is Acc + H, suma_lista(T, Acc1, Suma).

% Aplicación: calcular promedio de calificaciones
promedio(Califs, Promedio) :-
    suma_lista(Califs, Suma),
    length(Califs, N),
    N > 0,
    Promedio is Suma / N.
```

**Tarea 3.4:** Implementar desde cero en Prolog: `mi_append/3`, `mi_reverse/2`,
`mi_flatten/2`, `mi_permutation/2`. Sin usar los predicados de biblioteca.
Verificar con `?- mi_append(X, Y, [1,2,3]).` que genera todas las particiones.

---

### Tema 3.5 — Aplicaciones de la programación lógica (sesión extra/proyecto)

- Bases de datos lógicas: Prolog como motor de consulta declarativo
- Sistemas expertos: hechos + reglas + interfaz de consulta
- Parsing con DCG (Definite Clause Grammars): gramáticas como reglas Prolog
- Integración con otros lenguajes: llamar Prolog desde Python y C#

**Proyecto integrador U3:** Sistema experto de diagnóstico (contexto IMSS).
- Base de hechos: 30+ síntomas, 15+ condiciones médicas comunes
- Reglas de inferencia: síntomas → diagnóstico probable
- `assert/retract`: el sistema aprende síntomas durante la consulta
- Interfaz interactiva: `read/1` para entrada del usuario
- Entregable: demostración con al menos 3 casos de diagnóstico distintos

---

## UNIDAD 4 — Modelo de Programación Lógica (16 horas / 4 sesiones × 4 h)

### Tema 4.1 — Desarrollo de programas lógicos (sesión 1, 4 h)

- Metodología de desarrollo en Prolog: de la especificación lógica al código
- Determinismo vs. no-determinismo: documentar explícitamente con `predicate/arity`
- Invariantes de predicados: qué debe ser verdad antes y después de cada cláusula
- Módulos en SWI-Prolog: `:- module(nombre, [export/arity])` — encapsulamiento

```prolog
:- module(validador_curp, [validar_curp/2, extraer_fecha/2]).

%% validar_curp/2 — determinista
%% validar_curp(+CURP:string, -Resultado:term) is det
%% Retorna ok(Datos) o error(Razon)
validar_curp(CURP, ok(Datos)) :-
    atom_chars(CURP, Chars),
    length(Chars, 18),
    !,
    extraer_componentes(Chars, Datos).
validar_curp(_, error(longitud_invalida)).

%% extraer_fecha/2 — determinista
%% extraer_fecha(+CURP:string, -Fecha:date) is det
extraer_fecha(CURP, date(Año, Mes, Día)) :-
    sub_atom(CURP, 4, 2, _, AñoAtom),
    sub_atom(CURP, 6, 2, _, MesAtom),
    sub_atom(CURP, 8, 2, _, DíaAtom),
    atom_number(AñoAtom, Año),
    atom_number(MesAtom, Mes),
    atom_number(DíaAtom, Día).
```

**Tarea 4.1:** Desarrollar módulo `validador_rfc` con especificación formal
(documentar aridad, determinismo, invariantes) y suite de pruebas con `plunit`.

---

### Tema 4.2 — Estrategias de búsqueda (sesión 2, 4 h)

- DFS en Prolog: la estrategia default — ventajas y peligros (bucles infinitos)
- Cut (`!`): comprometerse con la primera solución — semántica y uso responsable
- Cut verde vs. cut rojo: cuándo el cut cambia la semántica del programa
- `findall/3`, `bagof/3`, `setof/3`: recolectar todas las soluciones

```prolog
% Cut verde — no cambia semántica, solo eficiencia
maximo(X, Y, X) :- X >= Y, !.
maximo(_, Y, Y).

% findall/3 — recolectar sin falla si no hay soluciones
% findall(+Template, +Goal, -Lista) is det
todos_alumnos_aprobados(Aprobados) :-
    findall(Nombre, (alumno(Nombre, Promedio), Promedio >= 6.0), Aprobados).

% Búsqueda en grafo con ciclos — necesita visited para terminar
camino(Origen, Destino, Camino) :-
    camino(Origen, Destino, [Origen], Camino).

camino(X, X, Visitados, Visitados).
camino(Origen, Destino, Visitados, Camino) :-
    arista(Origen, Siguiente),
    \+ member(Siguiente, Visitados),
    camino(Siguiente, Destino, [Siguiente|Visitados], Camino).
```

**Tarea 4.2:** Implementar BFS en Prolog usando `findall` y una cola (lista de listas).
Encontrar el camino más corto en el grafo de conexiones de metro CDMX (simplificado).
Comparar BFS vs. DFS en número de nodos visitados.

---

### Tema 4.3 — Optimización de programas lógicos (sesión 3, 4 h)

- CLP(FD): Constraint Logic Programming over Finite Domains
- `#=`, `#\=`, `#<`, `#>`, `ins`, `all_distinct`, `label/1`
- Propagación de restricciones: el motor hace el trabajo, tú describes el problema
- Tabling / memoización en SWI-Prolog: `:-use_module(library(tabling))` para Datalog-style

```prolog
:- use_module(library(clpfd)).

%% Sudoku en Prolog — el poder de las restricciones
%% sudoku/1 — determinista con label
sudoku(Filas) :-
    length(Filas, 9),
    maplist(length_(9), Filas),
    append(Filas, Vars),
    Vars ins 1..9,
    maplist(all_distinct, Filas),
    transpose(Filas, Cols), maplist(all_distinct, Cols),
    bloques(Filas),
    maplist(label, Filas).

%% Asignación de horarios TecNM — Constraint Satisfaction Problem
horario(Materia, Salon, Hora) :-
    Hora ins 7..21,
    Salon ins 1..10,
    % restricciones: no dos materias en el mismo salón y hora
    all_distinct(HorasSalonCombinados).
```

**Tarea 4.3:** Resolver con CLP(FD): asignación de 8 materias del plan ISC a
4 salones, horarios de 7am a 9pm, sin traslapes. Al menos 3 restricciones adicionales
(laboratorio solo en ciertas aulas, descanso de mediodía, etc.).

---

### Tema 4.4 — Proyectos prácticos y casos de estudio (sesión 4 + proyecto final)

**Casos de estudio reales con Prolog:**
- IBM Watson usó Prolog (un dialecto interno de IBM, no SWI) para el análisis de
  preguntas en Jeopardy!, 2011 (fuente: Lally et al., *IBM Journal of R&D*, 2012)
- Ericsson: la primera implementación de Erlang (1986) fue escrita en Prolog —
  el paradigma lógico como herramienta de prototipado de lenguajes
- Reglas de negocio y análisis declarativo: el patrón "reglas como hechos" aparece
  en producción vía motores tipo Datalog (CodeQL, Soufflé, LogicBlox) —
  ver [`casos_reales_mundo_real.md`](casos_reales_mundo_real.md)

**Integración multi-paradigma — el cierre del semestre:**
- Llamar SWI-Prolog desde Elixir con `:erlport` o interfaz de puertos
- Validación declarativa (Prolog) + estado transaccional (Clojure/Erlang) juntos
- Cuándo usar cada paradigma: árbol de decisión práctico

---

## PROYECTO FINAL DEL CURSO (transversal a U3 y U4)

### Sistema Integrado: Validación + Estado + Resiliencia

El código base de cada proyecto está en [`proyectos_finales/`](proyectos_finales/).
El alumno elige un dominio y completa las tres capas a partir del starter code provisto.

**Capa 1 — Lógica (SWI-Prolog):**
- Reglas de negocio declarativas para validar operaciones
- CLP(FD) para restricciones numéricas (montos, límites)
- Suite `plunit` con al menos 15 tests pasando

**Capa 2 — Funcional con estado (Erlang/OTP o Clojure):**
- GenServer por cada entidad activa (usuario, sesión, operación)
- Supervisor que reinicia procesos caídos automáticamente
- Log inmutable de operaciones (append-only)

**Capa 3 — Integración:**
- Prolog valida antes de ejecutar
- OTP ejecuta y supervisa
- Reporte final en Haskell o Elixir con tipos que garantizan estructura correcta

**Proyectos implementados** — el alumno elige uno:

| # | Dominio | Directorio | Stack |
|---|---------|------------|-------|
| 1 | Validación de trámites IMSS | [`proyecto1_tramites_imss/`](proyectos_finales/proyecto1_tramites_imss/) | Prolog + Erlang/OTP + Haskell |
| 2 | Turnos en línea de ensamble (maquiladora) | [`proyecto2_maquiladora/`](proyectos_finales/proyecto2_maquiladora/) | Prolog CLP(FD) + Clojure |
| 3 | Monitor de alertas IoT CENAPRED | [`proyecto3_monitor_iot/`](proyectos_finales/proyecto3_monitor_iot/) | Prolog + Erlang/OTP + Elixir |
| 4 | Inventario con reglas fiscales SAT | [`proyecto4_inventario_sat/`](proyectos_finales/proyecto4_inventario_sat/) | Prolog + Erlang/OTP + Haskell |

---

## Rúbrica de evaluación

### Por unidad:
| Rubro | Peso |
|-------|------|
| Assignments semanales (código que compila y corre) | 40% |
| Proyecto integrador / examen de la unidad | 40% |
| Exposición técnica (10-15 min) | 20% |

Instrumento del rubro central por unidad (ver [SYLLABUS](SYLLABUS.md#evaluación)):
U1 → validador CURP (1.3) · U2 → sistema OTP (2.5) + Examen Parcial 1, promediados ·
U3 → sistema experto (3.5) · U4 → proyecto CLP (4.4) + Examen Parcial 2, promediados.

### Semestral:
| Rubro | Peso |
|-------|------|
| Promedio de 4 unidades | 70% |
| Proyecto final multi-paradigma | 25% |
| Participación en sesiones de REPL en vivo | 5% |

### Regla de oro:
> Código que no compila y corre = 0. Sin excepciones. No existe pseudocódigo.

---

## Herramientas del semestre

| Herramienta | Propósito |
|-------------|-----------|
| GitHub Classroom | Entrega de todos los assignments |
| AWS Academy (CloudShell + EC2) | Nodo remoto con todos los lenguajes — $50 USD de crédito por semestre, vencen al cierre |
| GitHub CLI (`gh`) + Gist | PRs, clonado y snippets desde la terminal del nodo |
| asciinema | Evidencia de sesiones de terminal |
| SWI-Prolog WASM | Prolog en navegador para demos rápidas |
| Exercism.io | Práctica adicional guiada en cada lenguaje |
| Try Haskell / Replit | REPL en línea para primeros contactos |

---

## Bibliografía (≤ 10 años para libros, ≤ 5 años para artículos)

### Libros
- Cesarini & Vinoski — *Designing for Scalability with Erlang/OTP* (O'Reilly, 2016)
- Thomas — *Programming Elixir 1.6* (Pragmatic, 2018)
- Minsky, Madhavapeddy & Hickey — *Real World OCaml* (2ª ed., 2022) — **libre en línea**
- Lipovača — *Learn You a Haskell* — **libre en línea**
- Fogus — *The Joy of Clojure* (Manning, 2014)

### Artículos y recursos de industria (≤ 5 años)
- "Why Nubank Chose Clojure" — Nubank Tech Blog, 2021
- "How Discord Scaled to 5M Concurrent Users with Elixir" — Discord Blog, 2020
- "OCaml at Meta: Flow, Hack, and Infer" — Meta Engineering Blog
- Building Claude Code — Boris Cherny, Pragmatic Engineer Newsletter, 2025
