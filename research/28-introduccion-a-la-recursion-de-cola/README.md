# Introducción a la recursión de cola y por qué importa

## Presentación del tema

En programación funcional, la recursión es la forma natural de expresar iteración. En lugar de bucles `for` o `while`, se definen funciones que se llaman a sí mismas hasta llegar a un caso base. Sin embargo, no todas las funciones recursivas se comportan igual a nivel de rendimiento y uso de memoria. Una forma especial, llamada **recursión de cola** (*tail recursion*), permite que el compilador o la máquina virtual optimicen las llamadas y ejecuten la función en espacio constante de pila, como si fuera un bucle.

Esta investigación introduce el concepto de recursión de cola, lo compara con la recursión “normal”, explica la relación con la optimización de llamadas de cola (*tail call optimization*, TCO) y describe por qué es especialmente importante en lenguajes funcionales como Erlang, Elixir, Haskell, OCaml, Clojure o Scala. También se discuten brevemente las diferencias con lenguajes imperativos de uso común, donde la TCO es limitada o no está garantizada.

## Desarrollo técnico

### 1. Recursión y recursión de cola: recordatorio conceptual

Una función recursiva se define en términos de sí misma. Normalmente se distinguen:

- **Caso base**: condición donde la función deja de llamarse a sí misma y devuelve un resultado directo.
- **Caso recursivo**: reduce el problema y vuelve a llamar a la misma función.

Ejemplo típico de factorial en Haskell (recursión no de cola):

```haskell
factorial :: (Eq a, Num a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n - 1)
```

# Introducción a la recursión de cola y por qué importa

## Introducción

La recursión es una técnica central en la programación funcional. En lugar de escribir bucles `for` o `while`, una función se llama a sí misma hasta alcanzar un caso base. Aunque la idea general de recursión se ve temprano en muchos cursos (factorial, Fibonacci, suma de listas), existe una variante muy importante para el rendimiento: la **recursión de cola** (*tail recursion*).

La recursión de cola surge cuando la llamada recursiva es la **última operación** que realiza una función. Esta aparente sutileza permite a muchos compiladores e intérpretes optimizar el uso de memoria y ejecutar la función como si fuera un bucle iterativo, reutilizando el mismo marco de pila (*stack frame*). En lenguajes funcionales como Haskell, Erlang, Elixir, OCaml o Scala, esta optimización se vuelve clave para evitar desbordamientos de pila y para escribir código declarativo y eficiente.

En esta investigación se presenta el concepto de recursión de cola, se compara con la recursión estándar, se explican sus ventajas y se muestran ejemplos ejecutables en lenguajes funcionales de uso real. Finalmente, se discute por qué esta técnica importa en el contexto de la programación funcional y qué limitaciones prácticas tiene, especialmente en lenguajes que no garantizan la optimización de llamadas de cola.

## Desarrollo técnico

### 1. Recordatorio: recursión estándar

Una función recursiva se define en términos de sí misma. Típicamente se identifican dos partes:

- Un **caso base** que no hace más llamadas recursivas.
- Un **caso recursivo** que reduce el problema y llama de nuevo a la función.

Un ejemplo clásico es el factorial:

```haskell
-- factorial recursivo estándar (no de cola)
factorial :: (Eq a, Num a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n - 1)
```

Aquí, la llamada factorial (n - 1) no es la última operación: todavía falta multiplicar por n. El cómputo queda “pendiente” en la pila, acumulando marcos hasta llegar a 0. En muchos lenguajes, una profundidad grande (por ejemplo, factorial 100000) provoca un error de desbordamiento de pila (stack overflow).
### 2. Definición de recursión de cola

Una función es recursiva de cola si la última operación de la función es la llamada recursiva, sin trabajo pendiente después de esa llamada [1]. En otras palabras:

    La función llama a sí misma.
    El valor que devuelve esa llamada recursiva es directamente el valor de la función actual.
    No hay operaciones adicionales (sumas, multiplicaciones, concatenaciones) después de la llamada.

En pseudocódigo:

funcion f(x, acumulador):
    si condicion_base(x):
        retornar acumulador
    en otro caso:
        -- la última operación es la llamada recursiva
        retornar f(x_reducido, nuevo_acumulador)

El uso de un acumulador es típico: contiene el resultado parcial que antes quedaba pendiente en la pila. En la recursión de cola se pasa explícitamente como parámetro.
### 3. Ejemplo: factorial con recursión de cola

La versión de factorial con recursión de cola en Haskell puede escribirse:

-- factorial de cola
factorialTR :: (Eq a, Num a) => a -> a
factorialTR n = go n 1
  where
    go 0 acc = acc
    go k acc = go (k - 1) (k * acc)

La función auxiliar go recibe un acumulador acc que guarda el resultado parcial. La llamada recursiva go (k - 1) (k * acc) es la última instrucción de la función go, por lo que el compilador GHC puede aplicar optimización de cola: en vez de apilar un nuevo marco, puede reutilizar el actual. Sin embargo, debido a la evaluación perezosa de Haskell, el acumulador puede acumular thunks si no se fuerza su evaluación. Para evitarlo, se puede usar el operador de aplicación estricta $! [2]:

-- factorial de cola con evaluación estricta del acumulador
factorialStrict :: (Eq a, Num a) => a -> a
factorialStrict n = go n 1
  where
    go 0 acc = acc
    go k acc = go (k - 1) $! (k * acc)

Este patrón también aparece en otros lenguajes funcionales. Por ejemplo, en Erlang:

%% factorial de cola en Erlang
-module(math).
-export([factorial/1]).

factorial(N) ->
    factorial(N, 1).

factorial(0, Acc) ->
    Acc;
factorial(N, Acc) when N > 0 ->
    factorial(N - 1, Acc * N).

En Elixir (sobre BEAM, la máquina virtual de Erlang), el mismo patrón se ve así:

defmodule Math do
  def factorial(n), do: do_factorial(n, 1)

  # Caso base
  defp do_factorial(0, acc), do: acc

  # Caso recursivo de cola
  defp do_factorial(n, acc) when n > 0 do
    do_factorial(n - 1, n * acc)
  end
end

La BEAM optimiza recursión de cola de forma sistemática para este tipo de funciones, lo que permite ejecutarlas en espacio constante de pila [3].
### 4. Recorrer listas de forma recursiva de cola

Las listas son estructuras recursivas naturales: tienen una cabeza (primer elemento) y una cola (el resto de la lista). En lenguajes funcionales es muy frecuente recorrer listas recursivamente. Veamos un ejemplo en Erlang, sumando elementos:

sum(List) ->
    sum(List, 0).

sum([], Acc) ->
    Acc;
sum([H|T], Acc) ->
    sum(T, H + Acc).

Cada llamada reduce la lista (T) y actualiza el acumulador Acc. De nuevo, la llamada recursiva es la última expresión del cuerpo de la función. En Elixir se sigue el mismo patrón:

defmodule Math do
  def sum_list(list), do: do_sum_list(list, 0)

  defp do_sum_list([], acc), do: acc

  defp do_sum_list([head | tail], acc) do
    do_sum_list(tail, head + acc)
  end
end

En Haskell, las funciones estándar sobre listas suelen definirse mediante pliegues (foldl', foldr) o construcciones recursivas que el compilador puede optimizar:

-- suma de lista usando foldl' (pliegue estricto por la izquierda)
sumList :: Num a => [a] -> a
sumList xs = foldl' (+) 0 xs

Este estilo recursivo se usa no solo para acumular resultados sino también para transformar estructuras (por ejemplo, implementaciones manuales de map o filter) y para escribir bucles infinitos controlados por mensajes en sistemas concurrentes.
### 5. Relación entre recursión de cola y TCO en distintos lenguajes

La utilidad de la recursión de cola depende de si el lenguaje y su implementación realizan optimización de llamadas de cola (tail call optimization, TCO):

    Lenguajes funcionales con TCO fuerte o garantizada
        Scheme: el estándar exige que las llamadas de cola no crezcan la pila; la iteración se escribe típicamente como recursión de cola [1].
        Erlang / Elixir: BEAM optimiza tail calls de forma nativa, lo que hace que patrones recursivos sean tan eficientes en memoria como bucles [3].
        Haskell: GHC puede optimizar funciones tail-recursive, aunque la evaluación perezosa puede acumular thunks si no se fuerza la estrictud [2].

    Lenguajes con TCO parcial o condicional
        Scala, Kotlin, OCaml, F#: usan anotaciones como @tailrec o palabras clave (tailrec) para exigir o verificar que una función es de cola y así transformarla en un bucle [1].
        C/C++: compiladores como GCC o Clang pueden aplicar TCO con niveles de optimización altos, pero no está garantizado por el lenguaje.

    Lenguajes con soporte limitado o sin TCO
        Python, Java: no proporcionan TCO por diseño, por lo que la recursión profunda (aunque sea de cola) puede provocar desbordamiento de pila [1].
        JavaScript: el estándar ECMAScript incluye tail calls, pero el soporte real en los motores es desigual.

En lenguajes funcionales, donde la recursión sustituye a los bucles y la inmutabilidad evita contadores mutables, la TCO resulta crítica para escribir algoritmos iterativos sin comprometer la memoria.
###6. Diferencias entre recursión de cola y otros tipos de recursión

La recursión de cola se contrasta a menudo con la head recursion, donde la llamada recursiva ocurre antes del trabajo principal. En head recursion, cada llamada debe esperar a que termine la siguiente para completar su propio trabajo, lo que implica un uso lineal de la pila y dificulta la optimización [4].

Desde el punto de vista del diseño de algoritmos:

    La recursión de cola es ideal para problemas que conceptualmente son bucles: contadores, acumuladores, recorridos lineales.
    Las formas no de cola son necesarias cuando el trabajo debe hacerse al “regresar” de la llamada recursiva (por ejemplo, recorrer una estructura en orden inverso, postorden en árboles, etc.).

Aprender a transformar una definición recursiva en una versión de cola, introduciendo acumuladores explícitos, es una habilidad base en programación funcional.
### 7. Por qué la recursión de cola importa

a) Eficiencia de memoria y rendimiento

En una recursión normal, cada llamada anida otra en la pila: f(n) espera a f(n-1), que espera a f(n-2), etc. Esto crece linealmente en profundidad de llamada y puede agotar la pila. En cambio, en la recursión de cola, el compilador o intérprete puede transformar el código en una forma equivalente a un bucle iterativo, usando espacio constante en la pila [1], [5].

En lenguajes funcionales donde la recursión sustituye a los bucles, esta optimización es crucial para que programas reales (por ejemplo, servidores concurrentes en Erlang/Elixir) puedan funcionar indefinidamente sin desbordar la pila.

b) Estilo declarativo y legible

La recursión de cola permite mantener un estilo declarativo y expresivo, mientras ofrece eficiencia similar a la de los bucles imperativos. Para muchos desarrolladores, escribir:

do_sum_list([head | tail], acc) do
  do_sum_list(tail, head + acc)
end

es más directo que traducir mentalmente la lógica a índices, contadores y estructuras mutables.

c) Compatibilidad con inmutabilidad

En programación funcional, los datos suelen ser inmutables: no se modifican en su lugar. Eso hace que bucles imperativos clásicos que dependen de variables re-asignables sean menos naturales. El patrón “llamada recursiva con parámetros actualizados” encaja perfectamente: cada llamada ve un nuevo estado totalmente definido por sus argumentos, sin efectos secundarios.

d) Implementación de patrones avanzados

Muchos patrones típicos en lenguajes funcionales (parsers, máquinas de estados, evaluadores de lenguajes, servidores de mensajes) se implementan con recursión de cola. En Elixir, el comportamiento GenServer de OTP se apoya en bucles recursivos de cola para procesar mensajes indefinidamente [3], [6]. La optimización de llamadas de cola permite que estos patrones sean viables en programas reales.

e) Limitaciones y matices

No todas las funciones recursivas se pueden transformar fácilmente en recursión de cola, y en algunos casos una definición no de cola puede ser más directa o incluso más eficiente, dependiendo del compilador y del patrón de acceso a datos. En BEAM, por ejemplo, una función body-recursive que construye una lista puede ser tan eficiente como una tail-recursive que invierte la lista al final [7]. Además, la mera escritura en estilo de cola no garantiza TCO si el compilador o la VM no la implementan [1]. Por eso la relación entre estilo de código y soporte del lenguaje debe entenderse con cuidado.
### 8. Errores comunes al aprender recursión de cola

    Olvidar el caso base o escribirlo mal (se produce recursión infinita).
    Hacer trabajo después de la llamada recursiva, sin darse cuenta de que se rompe la condición de “cola”.
    No usar acumuladores y depender de operaciones costosas, como concatenar listas al final (reverse ingenuo), lo que impide la optimización y degrada el rendimiento.
    Asumir que todos los lenguajes optimizan recursión de cola igual; en realidad depende del compilador o intérprete.

Aprender a identificar si una función es de cola y reescribir funciones recursivas estándar en forma de recursión de cola es una habilidad base en programación funcional.
Conclusiones

La recursión de cola es una especialización de la recursión que coloca la llamada recursiva en la última posición de la función. Esta restricción estructural permite que muchos compiladores e intérpretes apliquen optimización de llamadas de cola, reutilizando el mismo marco de pila y ejecutando la función en espacio constante. En lenguajes funcionales, donde la recursión constituye el mecanismo principal de iteración y la inmutabilidad limita el uso de contadores mutables, esta optimización es especialmente valiosa.

Los ejemplos en Haskell, Erlang y Elixir muestran un patrón recurrente: introducir un acumulador explícito y delegar la lógica en una función auxiliar tail-recursive. Lenguajes funcionales modernos y algunos compiladores de lenguajes imperativos han incorporado soporte para TCO, aunque con diferentes garantías. Entender estos matices ayuda a escribir código idiomático, correcto y eficiente según cada plataforma.

Desde la perspectiva del curso de Programación Lógica y Funcional, dominar la recursión de cola implica algo más que conocer una técnica de optimización: obliga a pensar de forma explícita sobre qué estado es realmente necesario en cada paso del cálculo, cómo se transforma y cómo se puede representar sin depender de la pila implícita de llamadas. Esta manera de razonar se conecta directamente con otros temas del paradigma funcional, como la transparencia referencial, la inmutabilidad y el diseño de funciones puras.
Bibliografía (formato IEEE)

[1] “Tail call,” Wikipedia, 2024. [En línea]. Disponible en: https://en.wikipedia.org/wiki/Tail_call

[2] “Tail recursion,” HaskellWiki. [En línea]. Disponible en: https://wiki.haskell.org/Tail_recursion

[3] F. Hebert, “Recursion,” Learn You Some Erlang for Great Good! [En línea]. Disponible en: https://learnyousomeerlang.com/recursion

[4] “Tail Recursion vs Head Recursion in Programming – Key Differences and Use Cases,” Calledges, 2023. [En línea]. Disponible en: https://calledges.com/computer/tail-recursion-vs-head-recursion

[5] R. Patra, “Tail-Call Optimization Explained: Why Recursion Doesn't Have to Blow Your Stack,” 2024. [En línea]. Disponible en: https://www.rabinarayanpatra.com/blogs/tail-call-optimization-explained

[6] “Iteration, Recursion, and Tail-call Optimization in Elixir,” AppSignal Blog, 2019. [En línea]. Disponible en: https://blog.appsignal.com/2019/03/19/elixir-alchemy-recursion.html

[7] T. Pfeiffer, “Tail Call Optimization in Elixir & Erlang – not as efficient and important as you probably think,” PragTob’s blog, 2016. [En línea]. Disponible en: https://pragtob.wordpress.com/2016/06/16/tail-call-optimization-in-elixir-erlang-not-as-efficient-and-important-as-you-probably-think/



