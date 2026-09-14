# Factorial, Fibonacci y Sumatoria: los ejemplos clásicos paso a paso

![](https://madooei.github.io/recursion/assets/img/2017-06-18_11h20_02.png)

**Alumno**: Maldonado Avendaño Valeria  
**No. Control**: 23212006  
**Carrera**: Ingeniería en Sistemas Computacionales  
**Docente**: Rene Solis Reyes  

---

## Introducción

La programación funcional se basa en conceptos matemáticos y en el uso de funciones para resolver problemas de forma estructurada, se busca evitar cambios constantes en los datos y se prefiere expresar las soluciones de una forma más cercana al razonamiento matemático

Dentro de todo esto, la recursión es de lo más importante para repetir tareas o recorrer datos, ya que permite sustituir el uso de bucles tradicionales como for o while y evita depender de variables que cambian constantemente de valor, con el uso de la recursión, una función puede llamarse a sí misma hasta alcanzar una condición que detenga el proceso

El factorial, la sucesión de Fibonacci y la sumatoria son ejemplos clásicos en programación funcional, debido a que representan de forma sencilla la manera de pensar de este paradigma y muestran cómo los problemas se pueden resolver mediante funciones y operaciones matemáticas. Estos tres ejemplos permiten entender de una manera práctica el funcionamiento de la recursión y su importancia dentro de la programación funcional

---

## Desarrollo Técnico

### ¿Qué es la recursión?

Proceso en el cual una función o fragmento de código se llama a sí mismo de forma repetida para resolver un problema grande dividiéndolo en partes más pequeñas

#### Partes clave de la recursividad

**Caso base**: Es la condición que detiene las llamadas repetidas. Sin él, la función se llamaría para siempre y rompería el programa por falta de memoria  

**Paso recursivo**: Es el momento en que la función se llama a sí misma, pero pasándole un problema de menor tamaño o más simple

#### Ejemplo Común

Calcular el factorial de un número

**4! = 4 × 3 × 2 × 1**

En lugar de multiplicar todo con un ciclo repetitivo tradicional, la regla dice que el factorial de un número n es igual a n multiplicado por el factorial de n - 1. Esto se repite hasta llegar al caso base, que es cuando n vale 1

---

### Factorial paso a paso

El factorial (denotado o representado como n!) de un número positivo o entero (que se denota por n) es el producto de todos los números positivos que preceden o son equivalentes a n (el entero positivo). La función factorial se encuentra en diversas áreas de las matemáticas, como el álgebra, el análisis matemático y la combinatoria.

A partir del siglo Xlll, los factoriales se utilizaron para contar permutaciones. La notación para el factorial (n!) fue introducida a principios del siglo XIX por Christian Kramp, un matemático francés.

La función factorial se define matemáticamente como:

**n! = n × (n - 1) × ... × 1**

con el caso base: **0! = 1**

Por el lado de la programación funcional, **Haskell** es un lenguaje de programación estandarizado, de propósito general y puramente funcional.

#### Características principales

**Funcional puro:** Los programas se forman solo con funciones matemáticas.  
No existen los efectos secundarios ni variables que cambian de valor con el tiempo

**Tipos estáticos fuertes:** El sistema de tipos detecta muchos errores antes de ejecutar el código gracias a su análisis estricto en tiempo de compilación

El factorial recursivo en Haskell se implementa de forma muy natural utilizando ajuste de patrones (pattern matching)

#### Implementación en Haskell

```haskell
factorial :: Integer -> Integer
factorial 0 = 1
factorial n = n * factorial (n - 1)
```

#### Cómo funciona

**Línea 1:** Define la firma de la función. Recibe un entero (Integer) y devuelve un entero.

**Línea 2 (Caso base):** Si el argumento es 0, el resultado es 1. Detiene la recursión.

**Línea 3 (Caso recursivo):** Si el argumento es cualquier otro número n, multiplica n por el factorial de n - 1

#### Trazado paso a paso

```text
factorial(4)
  = 4 * factorial(3)
        = 4 * (3 * factorial(2))
              = 4 * (3 * (2 * factorial(1)))
                    = 4 * (3 * (2 * (1 * factorial(0))))
                          = 4 * (3 * (2 * (1 * 1)))

factorial(0) = 1
factorial(1) = 1 * 1 = 1
factorial(2) = 2 * 1 = 2
factorial(3) = 3 * 2 = 6
factorial(4) = 4 * 6 = 24
```

#### Alternativa con guardas (guards)

También se puede escribir usando condiciones si se prefiere evitar el ajuste de patrones directo:

```haskell
factorial :: Integer -> Integer
factorial n
  | n == 0    = 1
  | otherwise = n * factorial (n - 1)
```

---

### Fibonacci paso a paso

![](https://www.esferatic.com/wp-content/uploads/2012/11/fibonacci_n.jpg)

Define la sucesión de Fibonacci, una secuencia matemática donde cada número es la suma de los dos anteriores

#### ¿Cómo funciona?

La sucesión de Fibonacci se define de forma matemática con un casi base y un caso recursivo:

**Caso base:** si n es 0, el resultado es 0. Si n es 1, el resultado es 1.

**Caso recursivo:** Para cualquier número mayor a 1, la función regresa la suma de fibonacci(n - 1) + fibonacci(n - 2)

#### Implementación en Haskell

```haskell
fibonacci :: Integer -> Integer
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n - 1) + fibonacci (n - 2)
```

Existen dos casos base en lugar de uno, debido a que el caso recursivo necesita los dos valores anteriores (n - 1 y n - 2) para poder sumar y llegar al resultado. Si solo tuviera un caso base, la recursión no tendría de dónde sacar el segundo valor cuando llegara al fondo

#### Trazado paso a paso (fibonacci(4))

```text
fibonacci(4)
  = fibonacci(3) + fibonacci(2)
  = (fibonacci(2) + fibonacci(1)) + (fibonacci(1) + fibonacci(0))
  = ((fibonacci(1) + fibonacci(0)) + 1) + (1 + 0)
  = ((1 + 0) + 1) + (1 + 0)
  = (1 + 1) + 1
  = 2 + 1
  = 3
```

---

### Sumatoria paso a paso

Operación matemática que representa la suma de muchos o infinitos sumandos de manera abreviada utilizando la letra griega sigma mayúscula. También se le conoce como notación sigma

![](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3t2A7J9Z_73LpOjhF4SUDO774Xhg-6rKFSFNGYRPkpcHfhKUQoMEWue8&s=10)

#### Fórmula matemática

S(n) = n + (n-1) + (n-2) + ... + 1

Caso base: S(0) = 0

La sumatoria de 1 a n consiste en sumar todos los números enteros desde 1 hasta n. Se puede expresar recursivamente como: sumar n al resultado de la sumatoria de (n-1).

#### Implementación en Haskell

```haskell
sumatoria :: Integer -> Integer
sumatoria 0 = 0
sumatoria n = n + sumatoria (n - 1)
```

Un solo caso base (sumatoria 0 = 0) y un caso recursivo que combina el valor actual con el resultado de la llamada más pequeña (se suman)

#### Trazado paso a paso (sumatoria(4))

```text
sumatoria(4)
  = 4 + sumatoria(3)
        = 4 + (3 + sumatoria(2))
              = 4 + (3 + (2 + sumatoria(1)))
                    = 4 + (3 + (2 + (1 + sumatoria(0))))
                          = 4 + (3 + (2 + (1 + 0)))

sumatoria(0) = 0
sumatoria(1) = 1 + 0 = 1
sumatoria(2) = 2 + 1 = 3
sumatoria(3) = 3 + 3 = 6
sumatoria(4) = 4 + 6 = 10
```

---

## Comparación y análisis

Factorial, Fibonacci y sumatoria usan recursión, pero no tienen la misma estructura ni el mismo comportamiento

### Número de llamadas recursivas por nivel

Factorial y sumatoria hacen una sola llamada recursiva en cada paso, la función se llama a sí misma una vez y espera ese resultado para combinarlo con el valor actual (multiplicando o sumando). En cambio, Fibonacci, hace dos llamadas recursivas por cada paso (fibonacci(n-1) y fibonacci(n-2)), lo que genera un árbol de llamadas que se ramifica en vez de una simple cadena lineal.

### Repetición de trabajo

Esa ramificación es la que hace que Fibonacci sea ineficiente en su versión recursiva ingenua: valores como fibonacci(2) se terminan calculando varias veces por separado dentro del mismo árbol de llamadas. Factorial y sumatoria no tienen este problema — cada valor intermedio se calcula exactamente una vez, porque solo hay una rama.

### Costo relativo

En términos de complejidad: factorial y sumatoria crecen linealmente respecto a n (se hacen n llamadas). Fibonacci recursivo crece exponencialmente, porque el número de llamadas casi se duplica en cada nivel del árbol.

---

## Conclusiones

La recursión ofrece una forma distinta de resolver problemas comparada con los bucles tradicionales: en lugar de repetir instrucciones paso a paso, se define el problema en términos de una versión más pequeña de sí mismo, hasta llegar a un caso base que detiene el proceso. Los tres ejemplos factorial, sumatoria y Fibonacci muestran que no toda recursión es igual: mientras factorial y sumatoria son estructuralmente simples y eficientes (una sola llamada por nivel, sin trabajo repetido), Fibonacci: llamadas repetidas cuando no se controla el número de ramas, esto quiere decir que por el simple hecho de ser recursión no significa que sea "perfecta" se tiene que entender cuantas llamadas genera, si repite trabajo etc. Se tiene que realizar un análisis antes de decidir que implementación usar en un caso real.

---

## Bibliografía

[1] Corporate Finance Institute, “Factorial,” *Corporate Finance Institute*. [En línea]. Disponible en: https://corporatefinanceinstitute.com/resources/data-science/factorial/

[2] Wikilibros, “Matemáticas/Combinatoria/Factorial,” *Wikilibros*. [En línea]. Disponible en: https://es.wikibooks.org/wiki/Matem%C3%A1ticas/Combinatoria/Factorial

[3] AlgoMonster, “509. Fibonacci Number,” *AlgoMonster*. [En línea]. Disponible en: https://algo.monster/liteproblems/509

[4] IONOS, “Haskell: el lenguaje de programación funcional,” *IONOS Digital Guide*, 9 de octubre de 2020. [En línea]. Disponible en: https://www.ionos.mx/digitalguide/paginas-web/desarrollo-web/que-es-haskell/

[5] Universidad de Almería, “Sucesión de Fibonacci,” *Jardín de los Matemáticos*. [En línea]. Disponible en: https://www2.ual.es/jardinmatema/sucesion-de-fibonacci/
