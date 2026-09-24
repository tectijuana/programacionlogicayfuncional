# Investigación: Listas por Comprensión (List Comprehensions)

Las **listas por comprensión** son una construcción sintáctica declarativa inspirada en la notación matemática de conjuntos. Permiten generar nuevas listas transformando y filtrando elementos de colecciones existentes sin recurrir a bucles imperativos explícitos.

A nivel fundamental, cualquier lista por comprensión básica:

`[ expresión | elemento <- colección, condición ]`

se traduce conceptualmente en dos operaciones funcionales de orden superior:

* **filter**: Evalúa una condición lógica (predicado) sobre cada elemento para descartar los que no la cumplan.
* **map**: Aplica una función de transformación a los elementos que pasaron el filtro.

---

## 1. Python

En Python, las comprensiones de listas son el estándar idiomático (definido formalmente en el PEP 202).

### Sintaxis de Comprensión

```python
numeros = [1, 2, 3, 4, 5, 6]

# Obtener el cuadrado de los números pares
cuadrados_pares = [x**2 for x in numeros if x % 2 == 0]

print(cuadrados_pares)
# Salida: [4, 16, 36]
```

### Traducción a map y filter

```python
numeros = [1, 2, 3, 4, 5, 6]

# En Python 3, map y filter retornan iteradores; se envuelven en list()
cuadrados_pares_func = list(
    map(
        lambda x: x**2,
        filter(lambda x: x % 2 == 0, numeros)
    )
)

print(cuadrados_pares_func)
# Salida: [4, 16, 36]
```

### Consideraciones clave en Python

* **Rendimiento:** La comprensión suele ejecutarse más rápido que `map` y `filter` combinados con funciones `lambda`. El intérprete CPython la compila en instrucciones optimizadas de bajo nivel (`LIST_APPEND`), ahorrándose la sobrecarga de crear marcos de ejecución en la pila por cada llamada anónima.
* **Múltiples generadores:** Comprensiones del estilo `[(x, y) for x in A for y in B]` representan un producto cartesiano (bucles anidados) y equivalen a operaciones de tipo `flat_map` o `itertools.chain.from_iterable`.

---

## 2. Haskell

Haskell introdujo esta sintaxis desde el paradigma funcional puro, directamente fundamentada en la teoría de tipos y mónadas.

### Sintaxis de Comprensión

```haskell
numeros :: [Int]
numeros = [1, 2, 3, 4, 5, 6]

-- Obtener el cuadrado de los números pares
cuadradosPares :: [Int]
cuadradosPares = [x^2 | x <- numeros, even x]

-- Salida: [4, 16, 36]
```

### Traducción a map y filter

```haskell
-- Aplicación directa de funciones
cuadradosParesFunc :: [Int]
cuadradosParesFunc = map (\x -> x^2) (filter even numeros)

-- Estilo point-free (composición con '.')
cuadradosParesPF :: [Int]
cuadradosParesPF = (map (^2) . filter even) numeros
```

### Consideraciones clave en Haskell

* **Desazucarado Monádico (Desugaring):** El compilador traduce internamente las comprensiones a llamadas a la mónada de listas (`>>=`) o a `concatMap`:
  ```haskell
  numeros >>= \x -> if even x then return (x^2) else []
  ```
* **Evaluación Perezosa (Lazy Evaluation):** Gracias a que Haskell no evalúa valores hasta que se consumen y a las optimizaciones de fusión de flujo (*stream fusion*) del compilador GHC, ambas formas se compilan en un solo bucle sin generar listas intermedias en memoria.

---

## 3. Elixir

Elixir implementa esta funcionalidad mediante la macro `for`, diseñada específicamente para el entorno concurrente y funcional de la máquina virtual Erlang (BEAM).

### Sintaxis de Comprensión

```elixir
numeros = [1, 2, 3, 4, 5, 6]

# Comprensión nativa con generador y cláusula de filtro
cuadrados_pares = for x <- numeros, rem(x, 2) == 0, do: x * x

# Salida: [4, 16, 36]
```

### Traducción a map y filter

```elixir
numeros = [1, 2, 3, 4, 5, 6]

# Encadenamiento con el operador de tubería (|>) usando el módulo Enum
cuadrados_pares_func =
  numeros
  |> Enum.filter(fn x -> rem(x, 2) == 0 end)
  |> Enum.map(fn x -> x * x end)

# Salida: [4, 16, 36]
```

### Consideraciones clave en Elixir

* **Uso de Memoria:** Encadenar `Enum.filter |> Enum.map` genera dos listas intermedias en memoria heap. La macro `for`, en cambio, procesa filtro y transformación en una sola pasada usando recursión por la cola (*tail recursion*).
* **Versatilidad con :into:** La macro `for` no se restringe a listas; permite iterar sobre binarios (`<<b <- bits>>`) y canalizar el resultado directamente a mapas o conjuntos mediante el modificador `into: %{}`.
* **Procesamiento Perezoso:** Cuando se procesan secuencias muy grandes o infinitas, se sustituye `Enum` por `Stream` (`Stream.filter |> Stream.map |> Enum.to_list`).

---

## Cuadro Comparativo

| Característica | Haskell | Elixir | Python |
| :--- | :--- | :--- | :--- |
| **Sintaxis de Comprensión** | `[expr \| x <- xs, cond]` | `for x <- xs, cond, do: expr` | `[expr for x in xs if cond]` |
| **Función de Filtro** | `filter cond xs` | `Enum.filter(xs, fun)` | `filter(fun, xs)` |
| **Función de Mapeo** | `map expr xs` | `Enum.map(xs, fun)` | `map(fun, xs)` |
| **Mecanismo Subyacente** | Mónada de listas / `concatMap` | Macro recursiva de acumulación | Bytecode C (`LIST_APPEND`) |
| **Evaluación por Defecto** | Perezosa (*Lazy*) | Ansiosa (*Eager*) | Ansiosa (*Eager*) |
| **Tipos Soportados** | Listas (extensible con mónadas) | Listas, mapas, binarios (`:into`) | Listas, diccionarios, sets |
