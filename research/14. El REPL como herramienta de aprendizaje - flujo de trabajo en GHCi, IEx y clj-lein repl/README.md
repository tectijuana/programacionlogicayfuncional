# El REPL como herramienta de aprendizaje: flujo de trabajo en GHCi, IEx y clj/lein repl

## Introducción
La programación funcional utiliza a menudo conceptos que resultan diferentes para estudiantes que están acostumbrados a lenguajes escolares. Entro ellos se encuentran conceptos que no se ven muy a menudo en nuestra carrera, cómo funciones de orden superior, inmutabilidad, pattern matching y evaluación perezosa.

El REPL permite al usuario ejecutar instrucciones sin construir un programa completo. El usuario escribe una instrucción, obtiene un resultado y tiene la opción de editarlo. 

## Desarrollo Técnico
REPL significa Read-Eval-Print Loop. Su funcionamiento se da por estas siglas que significan.
Leer ---> Evaluar ---> Escribir ---> Repetir

Esta dinámica de funcionamiento permite la realización de experimentos sumamente pequeños en comparación con grandes códigos para obtener una retroalimentación inmediata.

En programación funcional, el REPL puede llegar a utilizarse para estudiar conceptos de forma directa. Por ejemplo, en una función de orden superior puede comprobarse en Haskell mediante:
```
ghci> map (*2) [1,2,3]
[2,4,6]
```

La inmutabilidad también puede observarse al crear un nuevo valor sin modificar el original. En Clojure:

```
user=> (def x [1 2 3])
user=> (conj x 4)
[1 2 3 4]
user=> x
[1 2 3]
```

Haskell y Clojure también permiten estudiar evaluación perezosa mediante secuencias, por ejemplo:

```
ghci> take 5 [1..]
[1,2,3,4,5]
```

Por otro lado, Elixir permite estudiar especialmente el pattern matching:

```
iex> {a,b} = {:ok,42}
{:ok,42}
```

Así, el REPL convierte conceptos abstractos en pequeñas pruebas observables.


## Análisis comparativo

Se realizó un análisis comparativo basado principalmente en documentación oficial de cada entorno. Para los tres casos se utilizaron cuatro criterios:

-   Flujo de trabajo.
-   Manejo del estado.
-   Introspección y ayuda.
-   Manejo de errores.

El análisis se enfoca en las funciones que un estudiante puede utilizar durante una sesión normal de aprendizaje.

----------

### IV. GHCi: HASKELL

GHCi es el entorno interactivo del compilador GHC y permite evaluar expresiones, cargar módulos y consultar información sobre tipos y definiciones [1].

Un flujo básico consiste en iniciar el entorno:

```
$ ghci
ghci>
```

y posteriormente ejecutar expresiones:

```
ghci> 10 + 20
30
```

Para analizar el sistema de tipos se utiliza:

```
ghci> :type map
map :: (a -> b) -> [a] -> [b]
```

También pueden cargarse archivos mediante:

```
:load Main
:reload
```

Entre las herramientas más importantes se encuentran `:type`, `:info` y `:kind`. Esto permite utilizar el REPL no solamente para ejecutar código, sino también para investigar el sistema de tipos de Haskell [1].

Un error también proporciona retroalimentación inmediata:

```
ghci> head []
*** Exception: ...
```

Por ello, GHCi resulta especialmente útil para relacionar expresiones con tipos y comportamiento.

----------

### V. IEx: ELIXIR

IEx es el entorno interactivo de Elixir y proporciona evaluación, ayuda, introspección y herramientas de depuración [2].

Una sesión comienza con:

```
$ iex
iex>
```

El estudiante puede ejecutar funciones inmediatamente:

```
iex> Enum.map([1,2,3], fn x -> x * 2 end)
[2,4,6]
```

Una característica importante para el aprendizaje es el pattern matching:

```
iex> x = 10
10

iex> 5 = x
** (MatchError) ...
```

El entorno también dispone de herramientas como:

```
h(Enum.map)
i([1,2,3])
```

`h` permite consultar ayuda y `i` inspeccionar valores [2].

A diferencia de Haskell, Elixir no utiliza la evaluación perezosa como mecanismo general del lenguaje. Su modelo se centra en datos inmutables, pattern matching, funciones y procesos concurrentes.

----------

### VI. CLOJURE: `clj` Y `lein repl`

Clojure proporciona un REPL que puede iniciarse mediante `clj`, mientras que Leiningen permite iniciarlo mediante `lein repl` [3], [4].

Una sesión básica puede ser:

```
$ clj
user=>
```

y después:

```
user=> (+ 10 20)
30
```

Clojure permite consultar documentación y código desde el propio REPL:

```
user=> (doc map)
user=> (source map)
```

También conserva resultados anteriores mediante `*1`, `*2` y `*3`, y la última excepción mediante `*e` [3].

El manejo del estado se realiza mediante mecanismos específicos como Atoms. Por ejemplo:

```
user=> (def contador (atom 0))
user=> (swap! contador inc)
1
```

Esto permite estudiar la diferencia entre estructuras inmutables y estado controlado.

----------



#### TABLA I

| Criterio | GHCi | IEx | Clojure clj/lein repl |
|---|---|---|---|
| Flujo principal | Evaluar expresiones y consultar tipos | Evaluar expresiones e inspeccionar valores | Evaluar expresiones y trabajar con namespaces |
| Estado | Bindings del entorno y módulos cargados | Datos inmutables y estado mediante procesos | Datos inmutables y referencias como Atoms |
| Ayuda | `:type`, `:info`, `:kind` | `h`, `i`, `t` | `doc`, `source`, `dir` |
| Errores | Tipos y excepciones | Excepciones y `MatchError` | Excepciones y `*e` |
| Conceptos destacados | Tipos y evaluación perezosa | Pattern matching y concurrencia | Inmutabilidad, secuencias y namespaces |

### Comparación de los tres REPL

La comparación muestra que los tres entornos siguen el mismo principio general, pero cada uno refleja características propias de su lenguaje. GHCi facilita especialmente el análisis de tipos, IEx destaca por sus herramientas de introspección y Clojure integra el REPL con namespaces y mecanismos de estado controlado.

----------

## Conclusión
En conclusión el análisis que hicimos de los tres REPLs nos da a entender que realmente cada uno tiene mecanismos adecuados para la tarea que se esté realizando. Todos comparten que sean interactivos que es parte del paradigma de la programación funcional a final de cuentas.

## Referencias

 Glasgow Haskell Compiler Team, “Using GHCi,” _GHC User’s Guide_, 2026. [Online]. Available: [https://ghc.gitlab.haskell.org/ghc/doc/users_guide/ghci.html](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/ghci.html)

Elixir Team, “IEx.Helpers,” _IEx Documentation_, 2026. [Online]. Available: [https://hexdocs.pm/iex/](https://hexdocs.pm/iex/)

Clojure Team, “The REPL and main entry points,” _Clojure Reference_, 2026. [Online]. Available: [https://clojure.org/reference/repl_and_main](https://clojure.org/reference/repl_and_main)

 Leiningen Team, “Tutorial,” _Leiningen Documentation_, 2026. [Online]. Available: [https://leiningen.org/tutorial](https://leiningen.org/tutorial)

S. Marlow, Ed., “Haskell 2010 Language Report,” Haskell.org, 2010. [Online]. Available: [https://www.haskell.org/onlinereport/haskell2010/](https://www.haskell.org/onlinereport/haskell2010/)

 G. Hutton, _Programming in Haskell_, 2nd ed. Cambridge, U.K.: Cambridge University Press, 2016.

Clojure Team, “Atoms,” _Clojure Reference_, 2026. [Online]. Available: [https://clojure.org/reference/atoms](https://clojure.org/reference/atoms)

Clojure Team, “Sequences,” _Clojure Reference_, 2026. [Online]. Available: [https://clojure.org/reference/sequences](https://clojure.org/reference/sequences)

Elixir Team, “Pattern matching,” _Elixir Documentation_, 2026. [Online]. Available: [https://hexdocs.pm/elixir/patterns-and-guards.html](https://hexdocs.pm/elixir/patterns-and-guards.html)

 Oracle, “The jshell Command,” _Java Documentation_, 2026. [Online]. Available: [https://docs.oracle.com/en/java/javase/21/docs/specs/man/jshell.html](https://docs.oracle.com/en/java/javase/21/docs/specs/man/jshell.html)
