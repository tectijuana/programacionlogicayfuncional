# Tema 2.1 — Fundamentos de la Programación Funcional
## Erlang: Inmutabilidad y Pattern Matching

---

## Objetivo

Comprender por qué la inmutabilidad elimina las condiciones de carrera (race conditions)
y dominar el pattern matching como alternativa funcional a los `if`/`switch` imperativos.

---

## Archivos

| Archivo | Contenido |
|---------|-----------|
| `inmutabilidad.erl` | Variables de asignación única, recursión de cola, procesos concurrentes sin locks |
| `patron_matching.erl` | Validador de RFC mexicano usando solo pattern matching y guards |

---

## Ejecución

```bash
# Compilar
erlc inmutabilidad.erl
erlc patron_matching.erl

# Ejecutar en shell interactivo de Erlang
erl

# Dentro del shell:
> inmutabilidad:demostrar_inmutabilidad().
> inmutabilidad:sin_race_condition().
> patron_matching:demo().

# Salir del shell
> q().
```

**Alternativa — compilar y ejecutar en una línea:**
```bash
erl -noshell -eval "c(inmutabilidad), inmutabilidad:demostrar_inmutabilidad(), halt()"
erl -noshell -eval "c(patron_matching), patron_matching:demo(), halt()"
```

---

## Conceptos clave

### Inmutabilidad
En Erlang, una variable solo puede ligarse una vez. Intentar reasignarla es
un error en tiempo de compilación (no en runtime):

```erlang
X = 5.
X = 10.  %% Error: X ya está ligada a 5
```

Esto no es una limitación — es una garantía: si `X = 5`, en cualquier punto
del programa, en cualquier proceso, `X` sigue siendo `5`.

### Recursión de cola (Tail Call Optimization)
Una función es tail-recursive cuando la llamada recursiva es la **última operación**
antes de retornar. Erlang optimiza esto para usar O(1) de pila.

```erlang
%% NO tail-recursive (crece la pila en cada llamada):
suma_mala([]) -> 0;
suma_mala([H|T]) -> H + suma_mala(T).  %% suma se hace DESPUÉS de retornar

%% Tail-recursive (pila constante):
suma_bien(Lista) -> suma_bien(Lista, 0).
suma_bien([], Acc) -> Acc;
suma_bien([H|T], Acc) -> suma_bien(T, Acc + H).  %% llamada recursiva es lo último
```

### Pattern matching
En lugar de `if (condicion1) { ... } else if (condicion2) { ... }`, en Erlang
defines múltiples cláusulas de función. El runtime selecciona la primera que unifica:

```erlang
describir(0)           -> "cero";
describir(N) when N>0  -> "positivo";
describir(_)           -> "negativo".
```

---

## Assignment

**Parte 1 — Exploratorio (ejecutar y entender):**
1. Ejecuta `inmutabilidad:demostrar_inmutabilidad()` y explica en tus palabras
   por qué el código de `sin_race_condition` no necesita locks.
2. Ejecuta `patron_matching:demo()` y verifica que los 7 casos producen el resultado esperado.

**Parte 2 — Implementar:**
Agrega al módulo `patron_matching.erl` las siguientes funciones usando **exclusivamente**
pattern matching y guards (sin `if`, sin `case` con condiciones complejas):

```erlang
%% limpiar_rfc/1 — normalizar RFC a mayúsculas antes de validar
%% limpiar_rfc(+RFC::string()) -> string()

%% comparar_rfcs/2 — retorna el RFC "mayor" alfabéticamente
%% comparar_rfcs(+RFC1::string(), +RFC2::string()) -> {primero | segundo, string()}

%% rfc_a_fecha/1 — extraer la fecha de un RFC válido como {Año, Mes, Día}
%% rfc_a_fecha(+RFC::string()) -> {ok, {integer(), integer(), integer()}} | {error, atom()}
```

**Parte 3 — Reflexión (responder en comentarios en el código):**
1. ¿Por qué Erlang no necesita mutex o semáforos para `sin_race_condition/0`?
2. ¿Cuál es la diferencia entre `=` en Erlang y `=` en Python/Java?
3. Si `suma_lista([1,2,3,4,5])` usa recursión de cola con acumulador,
   ¿cuántas entradas hay en la pila de llamadas en el peor caso?

---

## Criterios de evaluación

| Criterio | Peso |
|----------|------|
| Las 3 funciones compilan sin warnings | 30% |
| Comportamiento correcto con casos de prueba | 40% |
| Uso exclusivo de pattern matching/guards (sin if/case complejo) | 20% |
| Respuestas de reflexión documentadas en código | 10% |

---

## Conexión con industria

WhatsApp en 2009 eligió Erlang precisamente por inmutabilidad + procesos ligeros.
Con un equipo de 50 ingenieros atendían 900 millones de usuarios. Cada mensaje
es un proceso Erlang inmutable — sin locks, sin coordinación explícita.
