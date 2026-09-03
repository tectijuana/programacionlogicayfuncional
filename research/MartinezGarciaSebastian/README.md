# Anexo 27. Recorrer listas de forma recursiva en programación funcional

## Resumen

En la presente investigacion se estara documentando toda la informacion obtenida acerca de como se recorren las listas de manera recursiva en lenguajes funcionales tales como Haskell y Erlang. La idea central de la investigacion es que a falta de tener estructuras de control tales como el ciclo for o while, los lenguajes funcionales recorren listas descomponiéndolas en cabeza (head) y cola (tail), resolviendo el problema para el primer elemento y delegando el resto a una llamada recursiva sobre la cola, hasta llegar a un caso base: la lista vacía.

**Palabras clave:** recursión, listas enlazadas, programación funcional,
pattern matching, Haskell, Erlang, caso base, caso recursivo.

## 1. Introducción

En los lenguajes imperativos, recorrer una lista o arreglo se resuelve casi
siempre con un índice y un bucle: se inicializa un contador, se compara contra
el tamaño de la estructura y se incrementa en cada iteración. Esta forma de
pensar depende de una variable mutable (el índice) que cambia de estado en
cada paso.

Los lenguajes funcionales puros, como Haskell, y los lenguajes funcionales de
la familia BEAM, como Erlang y Elixir, evitan el estado mutable siempre que
es posible. La lista, en estos lenguajes, no es un arreglo indexado en
memoria contigua, sino una **lista enlazada inmutable**: una estructura
compuesta por un primer elemento (la cabeza) y el resto de la lista (la
cola), que a su vez es otra lista más pequeña, hasta terminar en la lista
vacía. Esta estructura recursiva de los datos hace que la forma natural de
procesarla también sea recursiva.

## 2. Marco teórico

### 2.1 La lista como estructura recursiva

Una lista funcional se define, conceptualmente, como una de estas dos cosas:

- la lista vacía, o
- un elemento (cabeza) seguido de otra lista (cola).

En notación matemática de tipos algebraicos, esto se escribe como:

```
Lista(a) = Vacía | Cons(a, Lista(a))
```

Esta definición es la razón por la que la recursión resulta el mecanismo
idóneo para recorrerla: cada función que procesa una lista solo necesita saber
resolver dos casos: qué hacer cuando la lista está vacía (**caso base**) y qué
hacer con la cabeza, asumiendo que el resto ya fue resuelto por una llamada
recursiva sobre la cola (**caso recursivo**).

### 2.2 Recorrido recursivo en Haskell

Haskell representa las listas de forma nativa con el operador `:` (llamado
*cons*), y usa **pattern matching** para separar cabeza y cola directamente en
la definición de la función:

```haskell
-- Suma todos los elementos de una lista de enteros
sumaLista :: [Int] -> Int
sumaLista []     = 0                 -- caso base: lista vacía
sumaLista (x:xs) = x + sumaLista xs  -- caso recursivo: cabeza + resto

-- Cuenta los elementos de una lista
longitud :: [a] -> Int
longitud []     = 0
longitud (_:xs) = 1 + longitud xs

-- Recorre e imprime cada elemento (efecto de E/S mediante mapM_)
imprimirTodos :: Show a => [a] -> IO ()
imprimirTodos []     = return ()
imprimirTodos (x:xs) = do
  print x
  imprimirTodos xs
```

El patrón `(x:xs)` es la clave: `x` captura la cabeza y `xs` captura la cola,
sin necesidad de índices ni de una función auxiliar para "avanzar" en la
lista. El propio compilador exige, además, que se cubran ambos casos
(vacía y no vacía); omitir el caso base produce una función parcial que
falla en tiempo de ejecución, uno de los errores más comunes al aprender este
patrón.

### 2.3 Recorrido recursivo en Erlang

Erlang recorre listas de forma casi idéntica, usando su propio operador de
construcción `[H|T]` (Head/Tail) dentro de una cláusula de función:

```erlang
-module(listas).
-export([suma/1, longitud/1]).

% Suma todos los elementos de una lista
suma([]) -> 0;
suma([H|T]) -> H + suma(T).

% Cuenta los elementos de una lista
longitud([]) -> 0;
longitud([_|T]) -> 1 + longitud(T).
```

La sintaxis `[H|T]` cumple el mismo papel que `(x:xs)` en Haskell: separa el
primer elemento del resto de la lista mediante *pattern matching* sobre la
cláusula de la función, en lugar de usar una instrucción explícita para
"tomar el primer elemento". Erlang, además, permite declarar varias
cláusulas para la misma función (`suma([]) -> ...` y `suma([H|T]) -> ...`),
y selecciona la que coincide con la forma del argumento recibido.

### 2.4 Elixir: la misma idea con azúcar sintáctica

Elixir, al correr sobre la misma máquina virtual que Erlang (BEAM), comparte
la representación de listas como pares cabeza/cola y ofrece una sintaxis muy
similar:

```elixir
defmodule Listas do
  def suma([]), do: 0
  def suma([h | t]), do: h + suma(t)
end
```

Esto confirma que el patrón "caso base + caso recursivo sobre cabeza/cola" no
es una particularidad de un solo lenguaje, sino una consecuencia directa de
cómo está construida la lista como tipo de dato en toda la familia de
lenguajes funcionales.

## 3. Comparación y discusión

| Aspecto | Haskell | Erlang/Elixir |
|---|---|---|
| Operador de descomposición | `(x:xs)` | `[H\|T]` |
| Caso base | Cláusula `[]` | Cláusula `[]` |
| Evaluación | Perezosa (*lazy*) por defecto | Estricta |
| Verificación de casos | El compilador puede advertir patrones incompletos | Falla en tiempo de ejecución si ninguna cláusula coincide |
| Uso típico | Transformaciones puras sobre listas | Recorridos dentro de procesos concurrentes (mensajes, estado de un `gen_server`) |

La diferencia más relevante para un estudiante no está en la sintaxis, que es
casi intercambiable, sino en la **evaluación**: en Haskell, una lista puede
ser infinita porque los elementos se calculan solo cuando se necesitan (tema
2.4 del curso, evaluación perezosa), mientras que un recorrido recursivo
ingenuo sobre una lista infinita en Erlang nunca terminaría, porque cada
elemento se evalúa de inmediato.

Otro punto importante, que conecta con el tema 28 (recursión de cola), es que
las funciones anteriores **no** son de cola: la operación `+` ocurre después
de que regresa la llamada recursiva (`x + sumaLista xs`), por lo que cada
llamada debe permanecer en la pila hasta que toda la recursión termine. Para
listas muy largas esto puede agotar la pila; ese problema y su solución
(acumuladores y recursión de cola) se abordan en el tema siguiente y no se
desarrollan aquí para no duplicar contenido.

## 4. Conclusiones

Al final entendí que en programación funcional no hay "for" ni "while" porque
ni falta que hacen: una lista ya trae la receta de cómo recorrerla. Si la
lista está vacía, ya acabaste (ese es el caso base). Si no está vacía, agarras
el primer elemento, haces lo que tengas que hacer con él, y le dejas el resto
de la lista a otra llamada de la misma función (ese es el caso recursivo).
Suena raro al principio porque uno está acostumbrado a pensar en índices y
contadores, pero una vez que le agarras la onda a separar "cabeza" y "cola"
ya no se te olvida, y tanto en Haskell como en Erlang es básicamente la misma
idea, nomás cambia un poco la sintaxis (`(x:xs)` contra `[H|T]`). Esto también
me sirvió para entender por qué en el siguiente tema hablan de recursión de
cola: como aquí la suma se hace hasta que regresa la llamada recursiva
(`x + sumaLista xs`), cada llamada se queda "esperando" en la pila, y eso es
justo lo que luego se resuelve con acumuladores.

## Referencias

[1] G. Hutton, *Programming in Haskell*, 2nd ed. Cambridge, U.K.: Cambridge University Press, 2016.

[2] F. Cesarini and S. Thompson, *Erlang Programming*. Sebastopol, CA, USA: O'Reilly Media, 2009.

[3] S. St. Laurent, *Introducing Erlang: Getting Started in Functional Programming*, 2nd ed. Sebastopol, CA, USA: O'Reilly Media, 2017.

[4] M. Sperber, "The Haskell Report: Lists," Haskell.org, [Online]. Available: https://www.haskell.org/onlinereport/haskell2010/haskellch3.html

[5] Erlang/OTP, "Lists," *Erlang Reference Manual*, Ericsson AB, [Online]. Available: https://www.erlang.org/doc/reference_manual/expressions.html
