# Primeros pasos en Haskell con GHCi

**Materia:** Programación Lógica y Funcional

**Tema:** Primeros pasos en Haskell con GHCi

**Nombre:** Andres Manuel Perez Flores

**Numero de control:** 23212039

## 1. Introducción

Haskell es un lenguaje de programación funcional de propósito general.
Su diseño favorece funciones, tipos estáticos y expresiones declarativas.
En lugar de indicar cada paso de un procedimiento, se describe qué se quiere calcular.
Esto permite escribir programas concisos y fáciles de razonar.
Haskell también incorpora evaluación no estricta y funciones de orden superior.
Para comenzar a trabajar con Haskell, una herramienta fundamental es GHCi.
GHCi permite probar expresiones sin crear un programa completo.
Por esta razón resulta especialmente útil durante el aprendizaje.

## 2. Haskell y GHC

Haskell es un lenguaje estandarizado que cuenta con distintas implementaciones.
La implementación más utilizada actualmente es GHC, Glasgow Haskell Compiler.
GHC permite compilar programas Haskell y comprobar sus tipos.
También incluye GHCi, un entorno interactivo para trabajar directamente con el lenguaje.
GHCi funciona mediante un modelo REPL.
REPL significa Read, Eval, Print, Loop.
El sistema lee una expresión, la evalúa, muestra el resultado y vuelve a esperar.

## 3. Instalación y comienzo

Una forma habitual de instalar el entorno Haskell es mediante GHCup.
GHCup permite instalar GHC y otras herramientas del ecosistema.
Una vez instalado GHC, se puede iniciar la consola escribiendo:

```text
ghci
```

Al iniciar, GHCi muestra información sobre la versión instalada.
Después aparece un indicador donde se pueden escribir expresiones.
Para salir del intérprete se puede utilizar:

```text
:q
```

También puede utilizarse el comando `:quit`.

## 4. Primeras expresiones

GHCi permite comenzar con operaciones aritméticas sencillas.

```haskell
2 + 3
```

El resultado es:

```text
5
```

También se pueden realizar operaciones con otros operadores.

```haskell
10 * 4
20 `div` 5
2 ^ 3
```

Las expresiones se evalúan inmediatamente.
Esto permite experimentar sin crear archivos.
También se pueden utilizar valores booleanos.

```haskell
True
False
True && False
True || False
not True
```

## 5. Tipos de datos

Haskell utiliza un sistema de tipos estático.
Cada expresión tiene un tipo que puede ser determinado por el compilador.
GHCi permite consultar el tipo de una expresión mediante `:t`.
Por ejemplo:

```haskell
:t 5
```

Para una expresión booleana se puede probar:

```haskell
:t True
```

El resultado indica que `True` pertenece al tipo `Bool`.
También se puede consultar el tipo de una operación:

```haskell
:t (&&)
```

Los tipos ayudan a detectar errores antes de ejecutar un programa.
Por eso aprender a leerlos es una parte importante de Haskell.

## 6. Variables y funciones

En GHCi se pueden crear valores utilizando `let`.

```haskell
let numero = 10
```

Después se puede evaluar:

```haskell
numero
```

También se pueden definir funciones.

```haskell
let doble x = x * 2
```

Ahora:

```haskell
doble 5
```

produce `10`.
El tipo de la función puede consultarse con:

```haskell
:t doble
```

Una posible respuesta es:

```text
doble :: Num a => a -> a
```

Esto indica que la función recibe un número y devuelve otro número.

## 7. Funciones como elemento central

En Haskell las funciones ocupan un lugar central.
Una función puede recibir otras funciones como argumentos.
Este comportamiento se conoce como uso de funciones de orden superior.
Un ejemplo sencillo es `map`.

```haskell
map doble [1,2,3,4]
```

El resultado es:

```text
[2,4,6,8]
```

`map` aplica una función a cada elemento de una lista.
Esta forma de trabajar evita escribir bucles tradicionales.

## 8. Listas

Las listas son estructuras muy utilizadas en Haskell.
Una lista de números puede escribirse así:

```haskell
[1,2,3,4]
```

También existen listas de caracteres:

```haskell
['H','a','s','k','e','l','l']
```

Las cadenas de texto pueden escribirse directamente:

```haskell
"Haskell"
```

Entre las operaciones básicas se encuentran `head`, `tail` y `length`.

```haskell
head [10,20,30]
tail [10,20,30]
length [10,20,30]
```

La concatenación de listas se realiza mediante `++`.

```haskell
[1,2] ++ [3,4]
```

El resultado es `[1,2,3,4]`.

## 9. Filtrado de listas

Otra función importante es `filter`.
Permite conservar los elementos que cumplen una condición.
Por ejemplo:

```haskell
filter even [1,2,3,4,5,6]
```

produce:

```text
[2,4,6]
```

También se pueden utilizar funciones anónimas.

```haskell
filter (\x -> x > 3) [1,2,3,4,5]
```

El resultado es:

```text
[4,5]
```

Las funciones anónimas son útiles cuando una operación solo se necesita una vez.

## 10. Cargar programas desde archivos

Aunque GHCi sirve para experimentar, los programas normalmente se guardan en archivos.
Los archivos Haskell utilizan la extensión `.hs`.
Un archivo sencillo puede contener:

```haskell
doble x = x * 2

triple x = x * 3
```

Después se puede iniciar GHCi y cargar el archivo.

```text
:l programa.hs
```

El comando `:load` también puede escribirse completo.
Una vez cargado, se pueden probar las funciones.

```haskell
doble 7
triple 7
```

Si se modifica el archivo, se puede actualizar GHCi con:

```text
:r
```

Esto equivale al comando `:reload`.

## 11. Comandos esenciales de GHCi

GHCi ofrece varios comandos internos que comienzan con `:`.
Los más útiles durante los primeros pasos son:

```text
:t expresión
```

Muestra el tipo de una expresión.

```text
:l archivo.hs
```

Carga un archivo Haskell.

```text
:r
```

Recarga el archivo actualmente cargado.

```text
:i nombre
```

Muestra información sobre un tipo, función o clase.

```text
:?
```

Muestra ayuda sobre los comandos disponibles.

```text
:q
```

Sale de GHCi.
Conocer estos comandos hace más rápida la exploración del lenguaje.

## 12. Ventajas de utilizar GHCi

GHCi permite probar una idea en pocos segundos.
También facilita comprobar el tipo de una expresión.
Esto resulta útil para entender mensajes y errores del compilador.
Otra ventaja es que permite experimentar con funciones pequeñas.
El estudiante puede cambiar una expresión y observar inmediatamente el resultado.
GHCi también ayuda a comprobar cómo funcionan listas y operadores.
Por ello, es una herramienta de aprendizaje y exploración.

## 13. Errores frecuentes

Un error común es confundir una función con una variable.
Otro error frecuente consiste en utilizar valores de tipos incompatibles.
Haskell detecta muchas de estas situaciones mediante su sistema de tipos.
Cuando aparece un error, conviene leer primero el mensaje de GHCi.
La consulta `:t` puede ayudar a descubrir el problema.
También es recomendable probar expresiones más pequeñas.
Así se puede localizar con mayor facilidad la parte que causa el error.

## 14. Ejemplo completo

Se puede practicar con una función que calcula el cuadrado:

```haskell
let cuadrado x = x * x
```

Después se consulta su tipo:

```haskell
:t cuadrado
```

Y se prueban diferentes valores:

```haskell
cuadrado 4
cuadrado 10
```

También puede utilizarse con `map`:

```haskell
map cuadrado [1,2,3,4,5]
```

El resultado será:

```text
[1,4,9,16,25]
```

Este ejemplo reúne funciones, tipos, listas y funciones de orden superior.

## 15. Conclusión

Los primeros pasos en Haskell pueden realizarse directamente desde GHCi.
La consola permite practicar expresiones sin construir un programa completo.
Los conceptos iniciales más importantes son expresiones, tipos, funciones y listas.
También es necesario conocer algunos comandos básicos del intérprete.
Entre ellos destacan `:t`, `:l`, `:r`, `:i`, `:?` y `:q`.
Una buena estrategia consiste en escribir ejemplos pequeños y modificarlos.
Después se pueden guardar las funciones en archivos `.hs`.
GHCi permite volver a cargarlos y comprobar rápidamente los cambios.

## 16. Fuentes

* Haskell.org, Haskell 2010 Language Report.
  [Haskell 2010 Language Report](https://www.haskell.org/onlinereport/haskell2010/?utm_source=chatgpt.com)
* GHC User's Guide.
  [GHC User's Guide](https://downloads.haskell.org/ghc/latest/docs/users_guide/?utm_source=chatgpt.com)
* Haskell.org, GHCup.
  [GHCup](https://www.haskell.org/ghcup/steps/?utm_source=chatgpt.com)
