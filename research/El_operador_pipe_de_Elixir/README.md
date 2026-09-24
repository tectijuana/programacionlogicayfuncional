# Nombre: Lopez Molgado Jorge Luis #23212002

# El operador *pipe* de Elixir (`|>`) y la lectura de izquierda a derecha

## Introducción
En Elixir, un lenguaje funcional, es común combinar varias funciones para transformar un dato paso a paso. Cuando estas funciones se anidan unas dentro de otras, el código puede volverse difícil de leer, ya que hay que interpretarlo de adentro hacia afuera. Para resolver este problema, Elixir ofrece el operador pipe (|>), que permite encadenar funciones de forma lineal, en el mismo orden en que se ejecutan. Este trabajo explica qué es el operador pipe, cómo funciona su sintaxis y por qué favorece una lectura de izquierda a derecha del código.

## Desarrollo

### 1. ¿Qué es el operador Pipe?
El operador pipe es una herramienta que toma el resultado de una operación o comando y lo pasa de manera directa como entrada al siguiente paso
### 2. Sintaxis y funcionamiento
La sintaxis básica del operador pipe en Elixir es 
```text
expresión |> función(argumentos_adicionales).
```
en donde:
- __expresión__ es el valor o resultado que se desea enviar a la siguiente función.
- __|>__ es el operador Pipe, encargado de pasar el resultado de la expresión como primer argumento de la función siguiente.
- __función__ es la función que recibe el valor proveniente de la expresión.
- __argumentos_adicionales__ son otros parámetros que la función puede necesitar además del valor recibido mediante Pipe.
  
*El operador lleva el resultado de la izquierda, y lo pasa a la derecha.*
### 3. Uso del operador Pipe
### 3.1 Ejemplo sin utilizar Pipe

En Elixir es posible utilizar varias funciones de manera anidada, donde el resultado de una función se utiliza como argumento de otra.

Por ejemplo, supongamos que se desea tomar el texto `"hola mundo"`, convertirlo a mayúsculas y posteriormente dividirlo en palabras.

Sin utilizar el operador Pipe, se puede escribir de la siguiente manera:

```elixir
String.split(String.upcase("hola mundo"))
```

El código se ejecuta comenzando por la función más interna:

```text
"hola mundo"
      ↓
String.upcase("hola mundo")
      ↓
"HOLA MUNDO"
      ↓
String.split("HOLA MUNDO")
      ↓
["HOLA", "MUNDO"]
```

Aunque esta forma es válida, cuando se utilizan muchas funciones anidadas el código puede resultar más difícil de leer, ya que es necesario interpretar las operaciones desde el interior hacia el exterior.

### 3.2 Ejemplo utilizando Pipe

El operador Pipe (`|>`) permite escribir la misma operación siguiendo una secuencia de izquierda a derecha. El resultado de cada expresión se pasa como primer argumento de la siguiente función.

El ejemplo anterior puede escribirse utilizando Pipe de la siguiente manera:

```elixir
"hola mundo"
|> String.upcase()
|> String.split()
```

Su funcionamiento puede representarse como:

```text
"hola mundo"
      ↓
String.upcase()
      ↓
"HOLA MUNDO"
      ↓
String.split()
      ↓
["HOLA", "MUNDO"]
```

La primera expresión, `"hola mundo"`, se pasa como primer argumento de `String.upcase()`. Posteriormente, el resultado `"HOLA MUNDO"` se pasa como primer argumento de `String.split()`.

Por lo tanto:

```elixir
"hola mundo"
|> String.upcase()
|> String.split()
```

es equivalente a:

```elixir
String.split(String.upcase("hola mundo"))
```

El uso de Pipe permite observar las transformaciones en el mismo orden en que se realizan, lo que puede facilitar la lectura del código cuando se encadenan varias funciones.

### 4. Encadenamiento de funciones
```elixir
funcion_3(funcion_2(funcion_1(valor)))
```

En este caso, la ejecución comienza desde la función más interna:

```text
valor
  ↓
funcion_1()
  ↓
funcion_2()
  ↓
funcion_3()
  ↓
resultado
```

Mediante el operador Pipe (`|>`), la misma secuencia puede escribirse de una forma más lineal:

```elixir
valor
|> funcion_1()
|> funcion_2()
|> funcion_3()
```

Ambas expresiones representan conceptualmente el mismo encadenamiento:

```elixir
funcion_3(funcion_2(funcion_1(valor)))

# Equivalente utilizando Pipe

valor |> funcion_1() |> funcion_2() |> funcion_3()
```

El operador Pipe permite representar las operaciones en el mismo orden en el que se van aplicando, evitando la necesidad de anidar múltiples llamadas a funciones.

### 5. Lectura de izquierda a derecha

Una característica importante del operador Pipe es que permite expresar las transformaciones siguiendo el orden en que se aplican.

Cuando se utilizan funciones anidadas:

```elixir
funcion_3(funcion_2(funcion_1(valor)))
```

para comprender el flujo de los datos es necesario comenzar por la expresión más interna:

```text
valor → funcion_1() → funcion_2() → funcion_3()
```

Mediante Pipe, ese mismo flujo puede escribirse directamente en ese orden:

```elixir
valor |> funcion_1() |> funcion_2() |> funcion_3()
```

De esta manera, el código presenta primero el valor inicial y posteriormente las transformaciones que se aplican sobre él. Esto permite seguir el flujo de los datos de izquierda a derecha y puede facilitar la comprensión de una secuencia de operaciones.

## Conclusión
El operador pipe es una herramienta que simplifica la forma de encadenar funciones en Elixir, sustituyendo el anidamiento por una secuencia lineal de pasos. Su principal aporte es permitir que el código se lea de izquierda a derecha, en el mismo orden en que se procesan los datos, lo cual facilita tanto la escritura como la comprensión del programa. Aunque no siempre es la opción más adecuada (por ejemplo, cuando el valor no debe pasarse como primer argumento), su uso resulta especialmente útil en transformaciones de datos con varios pasos consecutivos.

## Referencias
[1] Elixir School, “Operador Pipe,” *Elixir School*. [En línea]. Disponible en: https://elixirschool.com/es/lessons/basics/pipe_operator. [Consultado: 16-sep-2026].

[2] Elixir, “Operators reference,” *HexDocs*. [En línea]. Disponible en: https://elixir.hexdocs.pm/operators.html. [Consultado: 16-sep-2026].
