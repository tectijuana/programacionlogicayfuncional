# Inmutabilidad: datos que no cambian y sus implicaciones para el programador

## Introducción

La inmutabilidad es uno de los conceptos fundamentales de la programación funcional. Consiste en tratar los datos como valores que, una vez creados, no pueden ser modificados. Cuando se necesita representar un cambio, el programa produce un nuevo valor que refleja el estado actualizado, mientras que el valor original permanece intacto. Este principio contrasta con la programación imperativa tradicional, donde una variable o una estructura de datos puede cambiar su contenido durante la ejecución.

A primera vista, la inmutabilidad puede parecer poco práctica porque podría suponerse que cada actualización obliga a copiar todos los datos. Sin embargo, los lenguajes funcionales modernos utilizan diferentes estrategias para hacer eficiente este modelo, entre ellas el uso de estructuras de datos persistentes y el *structural sharing*, mediante el cual varias versiones de una estructura comparten las partes que no han cambiado.

La importancia de la inmutabilidad no se limita a una característica sintáctica. Cambia la forma en que el programador razona sobre el estado, diseña funciones y analiza la concurrencia. Al reducir la posibilidad de que un dato cambie de manera inesperada, se facilita la comprensión del código y se disminuye una fuente importante de errores. Sin embargo, también existen costos y situaciones en las que se necesita manejar el estado de manera explícita. Por ello, comprender la inmutabilidad requiere analizar tanto sus ventajas como sus limitaciones.

## Desarrollo técnico

Desde el punto de vista conceptual, un dato inmutable es aquel cuyo valor no cambia después de haber sido creado. Es importante distinguir este concepto de la variable. En algunos lenguajes, una variable puede estar asociada con un valor diferente posteriormente; en otros, como Haskell o Erlang, los nombres se utilizan para representar valores sin modificar el valor original.

Un ejemplo sencillo aparece en Haskell:

```haskell
incrementar :: Int -> Int
incrementar x = x + 1

main :: IO ()
main = do
    let numeroOriginal = 10
    let numeroActualizado = incrementar numeroOriginal
    print numeroOriginal
    print numeroActualizado
```

Al ejecutarse, el programa muestra `10` y posteriormente `11`. El valor original no se modifica. En lugar de cambiar `numeroOriginal`, la función recibe un valor y produce otro. Esta forma de trabajar favorece el uso de funciones puras, es decir, funciones cuyo resultado depende únicamente de sus argumentos y que no producen efectos secundarios observables. Una consecuencia importante es que dichas funciones son más fáciles de probar y razonar, ya que una misma entrada siempre produce el mismo resultado.

La inmutabilidad también cambia la forma de actualizar colecciones. En lugar de modificar una lista existente, se genera una nueva lista. El siguiente programa de Haskell suma uno a cada elemento:

```haskell
incrementarTodos :: [Int] -> [Int]
incrementarTodos = map (+1)

main :: IO ()
main = print (incrementarTodos [1, 2, 3, 4])
```

El resultado es `[2,3,4,5]`. La lista original sigue existiendo conceptualmente y la operación se expresa como una transformación de valores. Además, el código evita funciones parciales sobre listas arbitrarias, por lo que la operación es segura incluso para listas vacías.

En Erlang, la inmutabilidad está relacionada con la asignación única. Una variable, una vez enlazada mediante *pattern matching*, no puede recibir otro valor durante la misma cláusula. Por ejemplo:

```erlang
-module(inmutabilidad).
-export([main/0]).

main() ->
    Original = [1, 2, 3],
    Actualizada = [0 | Original],
    io:format("Original: ~p~n", [Original]),
    io:format("Actualizada: ~p~n", [Actualizada]).
```

La expresión `[0 | Original]` construye una nueva lista utilizando la lista anterior como cola. El valor asociado con `Original` no se altera. Este comportamiento es especialmente útil en sistemas concurrentes porque diferentes procesos pueden trabajar con datos sin preocuparse por modificaciones inesperadas realizadas por otro proceso. La documentación de Erlang establece explícitamente que las variables utilizan asignación única [2].

Sin embargo, afirmar que la inmutabilidad elimina por completo la necesidad de manejar el estado sería incorrecto. Los programas reales necesitan conservar información que cambia: sesiones, contadores, configuraciones o el contenido de una base de datos. La diferencia es que la programación funcional suele separar el concepto de estado del mecanismo utilizado para transformarlo. En Erlang, por ejemplo, cuando se necesita mantener un estado de un proceso, se recomienda encapsularlo mediante comportamientos OTP, como `gen_server`, en lugar de utilizar procesos no supervisados. Un `gen_server` recibe mensajes y devuelve un nuevo estado para la siguiente interacción.

El siguiente ejemplo implementa un contador utilizando el comportamiento OTP `gen_server`:

```erlang
-module(contador).
-behaviour(gen_server).

-export([start_link/0, incrementar/1, obtener/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, 0, []).

incrementar(Pid) ->
    gen_server:call(Pid, incrementar).

obtener(Pid) ->
    gen_server:call(Pid, obtener).

init(EstadoInicial) ->
    {ok, EstadoInicial}.

handle_call(incrementar, _From, Estado) ->
    NuevoEstado = Estado + 1,
    {reply, NuevoEstado, NuevoEstado};

handle_call(obtener, _From, Estado) ->
    {reply, Estado, Estado};

handle_call(_, _From, Estado) ->
    {reply, {error, solicitud_no_soportada}, Estado}.

handle_cast(_, Estado) ->
    {noreply, Estado}.

handle_info(_, Estado) ->
    {noreply, Estado}.

terminate(_, _) ->
    ok.

code_change(_, Estado, _) ->
    {ok, Estado}.
```

Aunque el contador evoluciona de un estado a otro, cada llamada a `handle_call` recibe un estado y devuelve explícitamente el nuevo. El programador no modifica directamente una variable compartida; la evolución del estado se controla mediante mensajes y el comportamiento OTP.

Otro concepto relacionado es el de las estructuras de datos persistentes. Una estructura persistente conserva versiones anteriores después de una actualización. Esto no significa necesariamente que el programa copie todos los datos. En Clojure, las colecciones son inmutables y persistentes, y las actualizaciones pueden aprovechar el *structural sharing* para reutilizar partes de una estructura anterior [3]. Por ejemplo:

```clojure
(def original [1 2 3])
(def actualizado (conj original 4))

(println original)
(println actualizado)
```

La primera línea de salida corresponde a `[1 2 3]` y la segunda a `[1 2 3 4]`. El programador puede seguir utilizando ambas versiones. Esta característica resulta especialmente útil cuando es necesario conservar una secuencia de transformaciones o evitar efectos secundarios en programas concurrentes.

La principal ventaja de la inmutabilidad es la reducción de errores relacionados con el estado compartido. Si dos partes del programa reciben el mismo valor inmutable, ninguna puede modificarlo accidentalmente y afectar a la otra. Esto simplifica el razonamiento sobre la concurrencia. En Clojure, por ejemplo, sus colecciones inmutables y persistentes se presentan como eficientes e inherentemente seguras para el uso concurrente [3].

También mejora la depuración. Si un dato no cambia, el programador puede analizar una transformación como una relación entre una entrada y una salida. Esto permite seguir el flujo de información mediante composiciones de funciones. Sin embargo, la inmutabilidad no significa que todos los programas sean automáticamente simples o rápidos. La creación constante de nuevas versiones puede aumentar el número de objetos y generar presión sobre la memoria. Además, algunas operaciones requieren una estrategia de actualización más especializada para mantener un rendimiento adecuado.

Por esta razón, considero que la mayor implicación para el programador no es simplemente “no modificar variables”, sino aprender a modelar los cambios como transformaciones explícitas. En un paradigma imperativo, una pregunta común es “¿qué variable debo cambiar?”. En un enfoque funcional, la pregunta se convierte en “¿qué nuevo valor representa el resultado de esta operación?”. Este cambio de perspectiva puede requerir mayor planeación al inicio, pero hace más visibles las dependencias entre datos y reduce el acoplamiento producido por modificaciones ocultas.

La inmutabilidad también puede encontrarse en aplicaciones industriales. Un ejemplo verificable es el uso de Clojure en sistemas donde sus estructuras de datos inmutables forman parte de su modelo de programación. De manera similar, Jane Street afirma que utiliza OCaml como su principal plataforma de desarrollo y relaciona su uso con la programación funcional [4]. Estos casos no demuestran que la inmutabilidad sea una solución universal, pero sí muestran que los principios funcionales pueden aplicarse en sistemas reales y de alto rendimiento.

## Conclusiones

La inmutabilidad es un principio central de la programación funcional porque permite representar los cambios mediante nuevos valores en lugar de modificar directamente los existentes. Su principal beneficio es que reduce los efectos secundarios y facilita el razonamiento sobre el comportamiento de un programa.

Para un programador, es como trabajar con datos inmutables que implican adoptar una forma diferente de pensar, un ejemplo es: las operaciones se diseñan como transformaciones, el estado se hace explícito y las estructuras pueden conservar versiones anteriores. Este enfoque resulta útil en la concurrencia, ya que disminuye los problemas derivados del estado compartido y de las modificaciones inesperadas.

Aunque, la inmutabilidad también puede presentar desafíos relacionados con el consumo de memoria y el rendimiento. Pero por esta razón, no se debe considerar una regla absoluta, sino mas como una herramienta de diseño que se debe utilizar de acuerdo con las características del problema. Los lenguajes funcionales modernos demuestran que es posible combinar datos inmutables con mecanismos eficientes de persistencia, compartición estructural y un manejo controlado del estado.

Para mi, la aportación más importante que tiene la inmutabilidad es que obliga a expresar los cambios de manera más clara, en lugar de depender de modificaciones implícitas en distintas partes del programa, cada transformación puede analizarse como una relación entre valores. Esto no solo puede favorecer la corrección del software, sino que facilita su mantenimiento y su comprensión.

## Bibliografía

[1] G. Hutton, *Programming in Haskell*, 2nd ed. Cambridge, U.K.: Cambridge University Press, 2016.

[2] Erlang/OTP, “Expressions,” *Erlang System Documentation*. [Online]. Available: https://www.erlang.org/docs/27/system/expressions.html. [Accessed: Sep. 3, 2026].

[3] Clojure, “Data Structures,” *Clojure Documentation*. [Online]. Available: https://clojure.org/reference/data_structures. [Accessed: Sep. 3, 2026].

[4] Jane Street, “Technology,” *Jane Street*. [Online]. Available: https://www.janestreet.com/technology/. [Accessed: Sep. 3, 2026].

[5] R. Hickey, “Persistent Data Structures and Managed References,” *Clojure Documentation*. [Online]. Available: https://clojure.org/reference/data_structures. [Accessed: Sep. 3, 2026].
