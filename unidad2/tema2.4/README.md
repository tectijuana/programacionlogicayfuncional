# Tema 2.4 — Evaluación Perezosa (Lazy Evaluation)

**Lenguajes:** Haskell (`lazy.hs`) + Elixir (`stream.exs`)

---

## ¿Qué es la evaluación perezosa?

En un lenguaje **eager** (ansioso) como Python o Java, cada expresión se evalúa en el momento en que aparece en el código. En Haskell, la evaluación es **lazy** (perezosa) por defecto: una expresión solo se evalúa cuando su resultado es **necesario**.

### Analogía: la cinta de supermercado

Imagina que tienes una cinta transportadora infinita de productos. En un sistema eager, tendrías que poner todos los productos en la cinta antes de empezar a cobrar. En un sistema lazy, el cajero pide el siguiente producto solo cuando está listo para cobrarlo — la cinta puede ser infinita sin problema.

```
Eager:  [1, 2, 3, 4, 5, ...infinito...]  ← hay que generarlo TODO primero
Lazy:   pide el siguiente → recibe 1 → pide el siguiente → recibe 2 → ...
```

---

## Archivos del tema

| Archivo | Descripción |
|---------|-------------|
| `lazy.hs` | Listas infinitas en Haskell: Fibonacci, primos, comparación de memoria |
| `stream.exs` | Streams lazy en Elixir: pipeline sobre millones de registros IMSS |

---

## Compilar y ejecutar

```bash
# Haskell
ghc -o lazy lazy.hs && ./lazy

# Elixir
elixir stream.exs
```

---

## Conceptos clave

| Concepto | Haskell | Elixir |
|----------|---------|--------|
| Lista infinita | `[1..]`, `iterate f x` | `Stream.iterate(1, &(&1+1))` |
| Tomar N elementos | `take n lista` | `Stream.take(n)` |
| Filtrar lazy | `filter pred lista` | `Stream.filter(pred)` |
| Forzar evaluación | `seq`, `deepseq` | `Enum.to_list` |

---

## Preguntas de reflexión

1. ¿Por qué `take 10 fibs` es casi instantáneo aunque `fibs` sea "infinita"?
2. ¿Qué pasaría si intentaras `length fibs` en Haskell? Intenta explicarlo sin ejecutarlo.
3. ¿En qué situación del mundo real (procesamiento de logs, sensores IoT, streams de datos) la evaluación lazy tiene ventaja concreta sobre cargar todo en memoria?
4. Elixir corre en la BEAM VM de Erlang. ¿Por qué `Stream` es especialmente valioso cuando tienes miles de procesos concurrentes?
