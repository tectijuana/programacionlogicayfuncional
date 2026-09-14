# Ejemplos ejecutables de funciones anónimas y expresiones lambda

Este documento contiene ejemplos ejecutables de **funciones anónimas y expresiones lambda** en Python, Java, C++, C#, JavaScript y Kotlin.

Los ejemplos muestran operaciones comunes como filtrado, transformación de datos, funciones de orden superior y captura de variables.

---

## Python

### Código

```python
numeros = [1, 2, 3, 4, 5, 6]

pares = list(filter(lambda x: x % 2 == 0, numeros))
cuadrados = list(map(lambda x: x * x, numeros))

print("Pares:", pares)
print("Cuadrados:", cuadrados)


def crear_incrementador(n):
    return lambda x: x + n


sumar_10 = crear_incrementador(10)

print("5 + 10 =", sumar_10(5))
```

### Ejecución esperada

```text
Pares: [2, 4, 6]
Cuadrados: [1, 4, 9, 16, 25, 36]
5 + 10 = 15
```

### Conceptos demostrados

* Funciones lambda.
* `filter()`.
* `map()`.
* Funciones de orden superior.
* Captura de variables.
* Closures.

---

## Java

### Código

```java
import java.util.function.Function;
import java.util.function.Predicate;

public class LambdaDemo {
    public static void main(String[] args) {
        Function<Integer, Integer> doble = x -> x * 2;
        Predicate<Integer> par = x -> x % 2 == 0;

        System.out.println(doble.apply(10));
        System.out.println(par.test(10));
    }
}
```

### Compilación y ejecución

Guardar el archivo como:

```text
LambdaDemo.java
```

Compilar:

```bash
javac LambdaDemo.java
```

Ejecutar:

```bash
java LambdaDemo
```

### Salida esperada

```text
20
true
```

### Conceptos demostrados

* Expresiones lambda.
* Interfaces funcionales.
* `Function`.
* `Predicate`.
* Inferencia de tipos mediante el contexto.

---

## C++

### Código

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

int main() {
    std::vector<int> numeros = {1, 2, 3, 4, 5, 6};

    std::for_each(numeros.begin(), numeros.end(), [](int x) {
        if (x % 2 == 0) {
            std::cout << x << " ";
        }
    });

    std::cout << '\n';

    return 0;
}
```

### Compilación y ejecución

Guardar el archivo como:

```text
lambda.cpp
```

Compilar:

```bash
g++ -std=c++17 lambda.cpp -o lambda
```

Ejecutar:

```bash
./lambda
```

### Salida esperada

```text
2 4 6
```

### Conceptos demostrados

* Lambda sin captura.
* Función de orden superior.
* `std::for_each`.
* Tipo de cierre generado por el compilador.

---

## C#

### Código

```csharp
using System;

class LambdaDemo
{
    static void Main()
    {
        Func<int, int> doble = x => x * 2;
        Func<int, bool> esPar = x => x % 2 == 0;

        Console.WriteLine(doble(10));
        Console.WriteLine(esPar(10));
    }
}
```

### Ejecución

En un proyecto .NET, ejecutar:

```bash
dotnet run
```

### Salida esperada

```text
20
True
```

### Conceptos demostrados

* Expresiones lambda.
* Delegados genéricos.
* `Func<T, TResult>`.
* Inferencia de tipos.
* Funciones que devuelven valores.

---

## JavaScript

### Código

```javascript
const numeros = [1, 2, 3, 4, 5, 6];

const pares = numeros.filter(x => x % 2 === 0);
const cuadrados = numeros.map(x => x * x);

console.log("Pares:", pares);
console.log("Cuadrados:", cuadrados);
```

### Ejecución

Guardar el código como:

```text
lambda.js
```

Ejecutar con Node.js:

```bash
node lambda.js
```

### Salida esperada

```text
Pares: [ 2, 4, 6 ]
Cuadrados: [ 1, 4, 9, 16, 25, 36 ]
```

### Conceptos demostrados

* Funciones flecha.
* `filter()`.
* `map()`.
* Funciones de orden superior.
* Funciones anónimas.

---

## Kotlin

### Código

```kotlin
fun main() {
    val numeros = listOf(1, 2, 3, 4, 5, 6)

    val pares = numeros.filter { it % 2 == 0 }
    val cuadrados = numeros.map { it * it }

    println("Pares: $pares")
    println("Cuadrados: $cuadrados")
}
```

### Salida esperada

```text
Pares: [2, 4, 6]
Cuadrados: [1, 4, 9, 16, 25, 36]
```

### Conceptos demostrados

* Lambdas.
* `filter()`.
* `map()`.
* Parámetro implícito `it`.
* Funciones de orden superior.

---

# Comparación de los ejemplos

| Lenguaje       | Construcción utilizada | Funciones de orden superior | Captura / Closure |
| -------------- | ---------------------- | --------------------------- | ----------------- |
| **Python**     | `lambda x: ...`        | `map()`, `filter()`         | Sí                |
| **Java**       | `x -> ...`             | Interfaces funcionales      | Sí                |
| **C++**        | `[](int x) { ... }`    | `std::for_each`             | Sí                |
| **C#**         | `x => ...`             | Delegados                   | Sí                |
| **JavaScript** | `x => ...`             | `map()`, `filter()`         | Sí                |
| **Kotlin**     | `{ it -> ... }`        | `map()`, `filter()`         | Sí                |

Aunque todos los ejemplos implementan conceptos similares, cada lenguaje utiliza un modelo particular para representar las funciones y administrar su captura de variables.

---

# Diagrama conceptual

```text
                 FUNCIÓN ANÓNIMA / LAMBDA
                            |
             +--------------+--------------+
             |                             |
             v                             v
      Función de primera              Puede capturar
           clase                         variables
             |                             |
             v                             v
   Se pasa como argumento             CLOSURE
             |
             v
   Función de orden superior
             |
       +-----+-----+
       |     |     |
       v     v     v
      map  filter reduce
```

---

# Resumen de los conceptos demostrados

Los ejemplos anteriores permiten observar cómo las funciones anónimas y las expresiones lambda se utilizan en diferentes paradigmas y lenguajes de programación.

### Funciones de primera clase

Las funciones pueden ser almacenadas, utilizadas como argumentos o devueltas por otras funciones.

### Funciones de orden superior

Funciones como `map()`, `filter()` y `for_each` reciben comportamiento como argumento para realizar operaciones genéricas.

### Closures

Una función puede conservar acceso a variables pertenecientes al contexto donde fue creada.

### Sintaxis compacta

Las lambdas permiten expresar operaciones pequeñas sin necesidad de declarar funciones con nombre independientes.

### Diferencias entre lenguajes

La idea general es similar, pero la sintaxis, el sistema de tipos, las reglas de captura y la representación interna dependen del lenguaje utilizado.

---

# Conclusión

Los ejemplos muestran que las funciones anónimas y las expresiones lambda constituyen una herramienta ampliamente utilizada en los lenguajes de programación modernos.

Python, Java, C++, C#, JavaScript y Kotlin proporcionan mecanismos para representar comportamiento de manera compacta y utilizarlo como dato. Esto facilita especialmente el procesamiento de colecciones, los callbacks y las funciones de orden superior.

Sin embargo, las diferencias entre lenguajes son importantes. Por ello, aprender únicamente la sintaxis de una lambda no es suficiente; también es necesario comprender su sistema de tipos, las reglas de captura y el modelo de ejecución correspondiente.

