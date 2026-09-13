# Recursión como alternativa a los bucles: caso base y caso recursivo


## 1. Introducción

La **recursión** es una técnica de resolución de problemas en la que una función se invoca a sí misma para resolver instancias más pequeñas del mismo problema, hasta alcanzar un caso trivial que puede resolverse directamente. Formalmente, una función recursiva `f` se define en términos de sí misma: `f(n) = g(f(n-1), n)` para `n > n₀`, y `f(n₀) = valor_conocido` para el caso trivial.

En los lenguajes de programación funcional (Haskell, Elixir, Clojure, Erlang, F#, entre otros), la recursión no es simplemente una alternativa estilística a los bucles imperativos (`for`, `while`): es, con frecuencia, el **único mecanismo de iteración disponible**. Esto se debe a un principio central del paradigma funcional: la **inmutabilidad**. Un bucle imperativo típico depende de variables mutables (contadores, acumuladores) que se actualizan en cada iteración; en un lenguaje funcional puro, donde las variables no pueden reasignarse, no existe una construcción equivalente a `for (i = 0; i < n; i++)`. La recursión resuelve este problema: en lugar de *mutar* un estado, cada llamada recursiva *crea* un nuevo estado y lo pasa como argumento a la siguiente invocación.

Además, la recursión se alinea naturalmente con la **transparencia referencial** y el razonamiento matemático por inducción: así como una proposición inductiva se demuestra probando un caso base y un paso inductivo, una función recursiva se define y se verifica probando un **caso base** y un **caso recursivo**. Este paralelismo no es casual: los lenguajes funcionales modernos heredan buena parte de su fundamento teórico del cálculo lambda y de la lógica de primer orden, disciplinas donde la recursión (o su equivalente, la recursión primitiva) es el mecanismo formal de definición de funciones sobre estructuras inductivas (números naturales, listas, árboles).

---

## 2. Desarrollo técnico

### 2.1 Caso base y caso recursivo

Toda función recursiva bien definida debe contemplar dos componentes:

- **Caso base:** condición terminal que se resuelve sin nuevas llamadas recursivas. Detiene la recursión y evita la ejecución infinita.
- **Caso recursivo:** define el problema en términos de una instancia más pequeña del mismo problema, acercando la ejecución hacia el caso base.

**Ejemplo clásico — factorial:**

```
factorial(0) = 1                      -- caso base
factorial(n) = n * factorial(n - 1)   -- caso recursivo, n > 0
```

Aquí, `factorial(0) = 1` es el caso base: no requiere más llamadas. `factorial(n) = n * factorial(n - 1)` es el caso recursivo: reduce el problema `n` al problema `n - 1`, garantizando que eventualmente se alcance `0`.

### 2.2 Recursión vs. bucles imperativos

| Aspecto | Recursión (funcional) | Bucle imperativo |
|---|---|---|
| Estado | Inmutable; se pasa como argumento | Mutable; se reasigna en cada iteración |
| Control de flujo | Definido por casos (pattern matching) | Definido por condiciones y contadores |
| Fundamento teórico | Inducción matemática, cálculo lambda | Máquina de estados de Turing/von Neumann |
| Composabilidad | Alta (funciones puras, fácil de probar) | Menor (depende de efectos secundarios) |
| Riesgo principal | Desbordamiento de pila (stack overflow) | Errores por estado mutuo, condiciones de carrera |
| Optimización | Recursión de cola (tail call optimization) | Ninguna transformación equivalente necesaria |

En un lenguaje imperativo como C o Python, calcular la suma de una lista se expresa típicamente así:

```python
total = 0
for x in lista:
    total = total + x   # mutación explícita del acumulador
```

En un lenguaje funcional, la misma operación se expresa sin mutación, mediante recursión:

```haskell
sumaLista :: [Integer] -> Integer
sumaLista []     = 0                 -- caso base: lista vacía
sumaLista (x:xs) = x + sumaLista xs  -- caso recursivo
```

La diferencia no es meramente sintáctica: en la versión funcional no existe una variable `total` que cambie de valor a lo largo del tiempo; en cambio, cada llamada a `sumaLista` devuelve un valor nuevo que depende únicamente de sus argumentos, lo cual facilita el razonamiento formal, las pruebas unitarias y la paralelización segura.

### 2.3 Ejemplos de código

**Haskell** — suma de los primeros `n` números naturales:

```haskell
-- Archivo: suma.hs
sumaN :: Integer -> Integer
sumaN 0 = 0                    -- caso base
sumaN n = n + sumaN (n - 1)    -- caso recursivo

main :: IO ()
main = print (sumaN 10)        -- imprime 55
```

Ejecución: `runghc suma.hs` produce `55`.

**Elixir** — cálculo del factorial usando *pattern matching* sobre los argumentos:

```elixir
# Archivo: factorial.exs
defmodule Matematica do
  def factorial(0), do: 1                       # caso base
  def factorial(n) when n > 0 do
    n * factorial(n - 1)                        # caso recursivo
  end
end

IO.puts(Matematica.factorial(5))                 # imprime 120
```

Ejecución: `elixir factorial.exs` produce `120`.

**Clojure** — longitud de una lista mediante recursión explícita:

```clojure
;; Archivo: longitud.clj
(defn longitud [coleccion]
  (if (empty? coleccion)
    0                                  ; caso base
    (+ 1 (longitud (rest coleccion))))) ; caso recursivo

(println (longitud [10 20 30 40]))     ; imprime 4
```

Ejecución: `clojure -M longitud.clj` produce `4`.

Los tres ejemplos comparten la misma estructura lógica: una condición que identifica el caso trivial (lista vacía, `n = 0`) y una regla que reduce el tamaño del problema en cada llamada.

### 2.4 Errores comunes

1. **Ausencia de caso base.** Si la función recursiva no contempla una condición de parada, la ejecución continúa indefinidamente hasta agotar los recursos del sistema. Por ejemplo, omitir `factorial(0) = 1` en la definición de la sección 2.1 provoca que `factorial` se invoque para valores negativos sin detenerse jamás.

2. **Caso base inalcanzable.** Ocurre cuando el caso recursivo no converge hacia el caso base, por ejemplo al incrementar en lugar de decrementar el parámetro de control, o al aplicar una transformación que nunca satisface la condición de parada.

3. **Desbordamiento de pila (*stack overflow*).** Cada llamada recursiva no optimizada reserva un nuevo marco (*stack frame*) en la pila de llamadas. Si la profundidad de recursión es muy grande (por ejemplo, sumar una lista de varios millones de elementos con la función `sumaLista` mostrada anteriormente), la pila puede agotar su capacidad y el programa termina abruptamente con un error de tipo `StackOverflowError` o equivalente.

### 2.5 Recursión de cola (*tail recursion*)

Una llamada recursiva se considera **de cola** cuando es la última operación ejecutada en la función, es decir, su resultado se devuelve directamente sin operaciones pendientes posteriores. Esta propiedad permite que muchos compiladores e intérpretes apliquen la optimización **TCO** (*Tail Call Optimization*), reutilizando el mismo marco de pila en lugar de crear uno nuevo por cada llamada, con lo que la recursión se ejecuta en espacio de pila constante, equivalente en eficiencia a un bucle imperativo.

**Ejemplo en Elixir**, reescribiendo `factorial` con un acumulador para hacerla recursiva de cola:

```elixir
defmodule MatematicaCola do
  def factorial(n), do: factorial_aux(n, 1)

  defp factorial_aux(0, acumulador), do: acumulador          # caso base
  defp factorial_aux(n, acumulador) when n > 0 do
    factorial_aux(n - 1, n * acumulador)                     # llamada de cola
  end
end

IO.puts(MatematicaCola.factorial(5))  # imprime 120
```

En este caso, `factorial_aux(n - 1, n * acumulador)` es la última expresión evaluada; no queda ninguna operación pendiente (como la multiplicación `n *` en la versión no optimizada de la sección 2.3), por lo que la máquina virtual de Erlang/Elixir (BEAM) puede reutilizar el marco de pila. Clojure, por su parte, no realiza TCO automática debido a restricciones de la JVM, y exige el uso explícito de la forma especial `recur` para lograr un efecto equivalente:

```clojure
(defn factorial [n]
  (loop [i n, acumulador 1]
    (if (zero? i)
      acumulador                       ; caso base
      (recur (dec i) (* acumulador i))))) ; recursión de cola explícita

(println (factorial 5))                ; imprime 120
```

Haskell, mediante evaluación perezosa (*lazy evaluation*) y optimizaciones del compilador GHC, también puede transformar ciertas recursiones de cola en bucles eficientes en tiempo de compilación.

---

## 3. Conclusiones

La recursión constituye el mecanismo fundamental de iteración en la programación funcional, sustituyendo a los bucles imperativos al eliminar la necesidad de estado mutable. Su definición mediante caso base y caso recursivo refleja directamente el principio de inducción matemática, lo cual dota a los programas funcionales de mayor claridad conceptual, facilidad de verificación formal y composabilidad. No obstante, su uso exige disciplina: la omisión o el diseño incorrecto del caso base conducen a recursión infinita o desbordamiento de pila. La recursión de cola surge como la técnica que reconcilia la elegancia declarativa de la recursión con la eficiencia en el uso de memoria propia de los bucles imperativos, siendo un concepto central en el diseño de lenguajes y compiladores funcionales modernos como Haskell, Elixir y Clojure.

---

## 4. Material complementario

### Diagrama de llamadas recursivas — `factorial(4)`

```
factorial(4)
 └─ 4 * factorial(3)
        └─ 3 * factorial(2)
               └─ 2 * factorial(1)
                      └─ 1 * factorial(0)
                             └─ 1                (caso base)
                      └─ 1 * 1  = 1
               └─ 2 * 1  = 2
        └─ 3 * 2  = 6
 └─ 4 * 6  = 24
```

El diagrama ilustra la fase de **expansión** (creación de marcos de pila hasta alcanzar el caso base) seguida de la fase de **reducción** (resolución de las multiplicaciones pendientes al retornar). Esta doble fase es precisamente la que la recursión de cola elimina, al resolver el cálculo durante la fase de expansión mediante el uso de un acumulador.

### Código adicional: recursión sobre árboles binarios (Clojure)

```clojure
;; Cuenta los nodos de un árbol binario representado como {:valor v :izq a :der b}
(defn contar-nodos [arbol]
  (if (nil? arbol)
    0                                                   ; caso base
    (+ 1
       (contar-nodos (:izq arbol))                      ; caso recursivo (izquierda)
       (contar-nodos (:der arbol)))))                   ; caso recursivo (derecha)

(def arbol-ejemplo
  {:valor 1
   :izq {:valor 2 :izq nil :der nil}
   :der {:valor 3 :izq {:valor 4 :izq nil :der nil} :der nil}})

(println (contar-nodos arbol-ejemplo))  ; imprime 4
```

Este ejemplo evidencia que la recursión no se limita a estructuras lineales (listas, números): es el mecanismo natural para recorrer cualquier estructura de datos definida inductivamente, como árboles y grafos acíclicos.
