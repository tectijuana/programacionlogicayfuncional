# Currificación y Aplicación Parcial

## Introducción

En la programación funcional, las funciones tienen un papel muy importante, ya que permiten dividir un problema en operaciones pequeñas que pueden reutilizarse y combinarse. A diferencia de la programación tradicional, en la programación funcional es común tratar las funciones como valores. Esto significa que una función puede ser almacenada, enviada como argumento a otra función o incluso regresar otra función como resultado.

Dentro de este paradigma existen dos conceptos relacionados que son especialmente importantes: la **Currificación** y la **Aplicación Parcial**. Ambos permiten trabajar con funciones de una manera más flexible y crear nuevas funciones a partir de funciones existentes.

**Currificación**

La **currificación**, conocida en inglés como *currying*, consiste en representar una función que recibe varios argumentos  como una serie de funciones que reciben un argumento a la vez. Por ejemplo, una función que conceptualmente recibe dos números para realizar una suma puede verse como una función que recibe el primer número y devuelve otra función que espera el segundo número.

**Aplicación parcial**

Por otro lado, la **aplicación parcial** consiste en proporcionar solamente algunos de los argumentos de una función y obtener como resultado una nueva función que conserva esos valores y espera los argumentos que todavía faltan.

Estos conceptos están muy relacionados porque la currificación facilita la aplicación parcial. Haskell es uno de los lenguajes donde estos conceptos pueden observarse claramente, ya que las funciones se manejan naturalmente de esta manera. También existen mecanismos similares en otros lenguajes, como Python, donde se puede utilizar `functools.partial()` para crear funciones con algunos argumentos previamente establecidos.

Comprender estos conceptos permite desarrollar programas más reutilizables y evitar repetir lógica que ya fue definida anteriormente.

---

# Desarrollo técnico

## Currificación

La currificación es una técnica mediante la cual una función de varios argumentos puede representarse como una secuencia de funciones de un solo argumento.

Por ejemplo, podemos tener una función para sumar dos números:

```haskell
suma :: Int -> Int -> Int
suma x y = x + y
```

A primera vista puede parecer que `suma` recibe dos números al mismo tiempo. Sin embargo, en Haskell realmente puede interpretarse como una función que recibe un número y devuelve otra función que espera recibir el segundo número.

La expresión:

```haskell
suma 5 3
```

puede entenderse como:

```text
(suma 5) 3
```

Primero se aplica `5`:

```text
suma 5
```

Esto produce una nueva función que todavía está esperando otro número.

Después se aplica `3`:

```text
(suma 5) 3
```

Finalmente se obtiene:

```text
8
```

Podemos representarlo de manera sencilla:

```text
suma
 ↓
recibe 5
 ↓
función que espera otro número
 ↓
recibe 3
 ↓
8
```

Esto es importante y se ocupa comprender ya que nos permite utilizar una función de varias entradas como una cadena de funciones.

---

## Aplicación parcial

La aplicación parcial ocurre cuando utilizamos solamente algunos de los argumentos de una función y dejamos los demás pendientes.

Tomemos nuevamente la función:

```haskell
suma :: Int -> Int -> Int
suma x y = x + y
```

Podemos fijar el primer argumento en `10`:

```haskell
sumarDiez :: Int -> Int
sumarDiez = suma 10
```

Ahora `sumarDiez` es una nueva función.

Si escribimos:

```haskell
sumarDiez 5
```

el resultado será:

```text
15
```

La función original necesitaba dos valores:

```text
suma x y
```

pero después de proporcionar `10` solamente necesita uno:

```text
sumarDiez y
```

Podemos visualizarlo así:

```text
suma 10 5
   ↓
(suma 10) 5
   ↓
15
```

La ventaja es que no necesitamos volver a escribir la lógica de la suma. Simplemente creamos una función especializada a partir de la función original.

---

## Diferencia entre currificación y aplicación parcial

Aunque están relacionadas, la currificación y la aplicación parcial no significan exactamente lo mismo como lo hemos estado viendo.

## Nuevamente ##

La **currificación** se refiere a la forma en que una función de varios argumentos puede representarse como una secuencia de funciones de un argumento.

La **aplicación parcial** consiste en proporcionar algunos de esos argumentos para obtener una nueva función.

Una forma sencilla de recordarlo es:

```text
CURRIFICACIÓN
¿Cómo está construida o representada la función?

f x y

↓

f x → función que espera y
```

Mientras que:

```text
APLICACIÓN PARCIAL
¿Qué pasa si le doy solamente algunos argumentos?

f 10

↓

nueva función que espera el siguiente argumento
```

Por lo tanto, podemos decir que la currificación hace posible que una función pueda recibir sus argumentos uno por uno, mientras que la aplicación parcial aprovecha esa característica para crear funciones especializadas.

---

## Ejemplo de aplicación parcial con multiplicación

Otro ejemplo sencillo puede hacerse con una función que multiplica dos números:

```haskell
multiplicar :: Int -> Int -> Int
multiplicar x y = x * y
```

Podemos crear una función que multiplique cualquier número por `10`:

```haskell
multiplicarPorDiez :: Int -> Int
multiplicarPorDiez = multiplicar 10
```

Ahora podemos utilizarla:

```haskell
multiplicarPorDiez 5
```

Resultado:

```text
50
```

También podemos utilizarla con diferentes valores:

```haskell
multiplicarPorDiez 2
multiplicarPorDiez 7
multiplicarPorDiez 20
```

Los resultados serían:

```text
20
70
200
```

La función `multiplicar` solamente fue escrita una vez, pero a partir de ella podemos crear nuevas funciones especializadas.

---

## Ejemplo práctico: descuentos

La aplicación parcial también puede utilizarse para representar situaciones más cercanas a un sistema real.

Supongamos que queremos calcular el precio de un producto después de aplicar un descuento.

Podemos crear la siguiente función:

```haskell
calcularDescuento :: Double -> Double -> Double
calcularDescuento descuento precio =
    precio - (precio * descuento / 100)
```

El primer argumento representa el porcentaje de descuento y el segundo representa el precio.

Por ejemplo:

```haskell
calcularDescuento 20 500
```

El resultado será:

```text
400
```

Ahora imaginemos que una tienda utiliza constantemente un descuento del 20 %. En lugar de escribir `20` cada vez, podemos crear una función especializada:

```haskell
descuento20 :: Double -> Double
descuento20 = calcularDescuento 20
```

Ahora podemos utilizar:

```haskell
descuento20 500
```

Resultado:

```text
400
```

También:

```haskell
descuento20 1000
```

Resultado:

```text
800
```

Aquí podemos observar claramente la aplicación parcial. La función original necesita dos argumentos:

```text
calcularDescuento descuento precio
```

Pero al proporcionar el primer argumento:

```text
calcularDescuento 20
```

obtenemos una nueva función que solamente necesita el precio.

---

## Ventajas y limitaciones

La currificación y la aplicación parcial tienen varias ventajas.

### Ventajas

**Reutilización:** permiten crear nuevas funciones a partir de funciones existentes.

**Menor repetición:** cuando un valor se utiliza constantemente, puede establecerse una sola vez.

**Modularidad:** las funciones pueden dividirse en operaciones pequeñas y especializadas.

**Composición:** las funciones especializadas pueden combinarse con otras funciones.

**Legibilidad:** en ciertos casos, una función como `multiplicarPorDiez` puede ser más clara que repetir `multiplicar 10` en diferentes partes del programa.

Sin embargo, también existen algunas limitaciones. 

### Limitaciones

Utilizar demasiadas funciones parcialmente aplicadas puede hacer que un programa sea más difícil de entender para alguien que no conoce el paradigma funcional. Además, cuando se utilizan muchas funciones encadenadas, puede resultar complicado identificar qué argumentos fueron establecidos previamente.

Por esta razón, estas técnicas deben utilizarse de manera equilibrada y buscando que el código sea más claro, no solamente más corto.

---

# Conclusiones

La currificación y la aplicación parcial son conceptos importantes de la programación funcional que permiten trabajar con las funciones de una manera diferente a la programación tradicional. La currificación permite representar una función que trabaja con varios argumentos como una secuencia de funciones que reciben un argumento a la vez. Esto permite que una función pueda ser aplicada progresivamente.

La aplicación parcial utiliza esta característica para proporcionar algunos argumentos y obtener una nueva función que espera los argumentos restantes. Gracias a esto es posible crear funciones especializadas sin tener que repetir la lógica original.

Un ejemplo sencillo es una función de multiplicación. A partir de `multiplicar x y` podemos crear `multiplicarPorDiez`, estableciendo previamente el valor `10`. La nueva función solamente necesita recibir el segundo número.

Haskell permite observar estos conceptos de manera especialmente clara debido a que sus funciones son naturalmente curried.

Después de analizar ambos conceptos, se puede concluir que la currificación y la aplicación parcial son herramientas útiles para aumentar la reutilización y modularidad del código. Sin embargo, deben utilizarse buscando mejorar la claridad del programa y no solamente reducir la cantidad de código.

---

# Bibliografía

[1] Python Software Foundation, “Functional Programming HOWTO,” *Python Documentation*. [En línea]. Disponible en: https://docs.python.org/3/howto/functional.html

[2] E. Fulmer, “Currying and Partial Application,” *School of Haskell*. [En línea]. Disponible en: https://www.schoolofhaskell.com/user/EFulmer/currying-and-partial-application

[3] B. O'Sullivan, D. Stewart and J. Goerzen, *Real World Haskell: Code You Can Believe*, O'Reilly Media. [En línea]. Disponible en: https://book.realworldhaskell.org/

[4] Python Software Foundation, “PEP 309 – Partial Function Application,” *Python Enhancement Proposals*. [En línea]. Disponible en: https://peps.python.org/pep-0309/

[5] S. P. Jones, “The Haskell 2010 Report,” *Haskell.org*. [En línea]. Disponible en: https://www.haskell.org/onlinereport/haskell2010/

