#Grande Ortega Maximiliano Alberto No.23211974
# Funciones Anónimas y Expresiones Lambda

## Introducción

Las funciones anónimas y las expresiones lambda son mecanismos de los lenguajes de programación que permiten representar comportamiento como un valor que puede almacenarse, pasarse como argumento, devolverse desde otra función o utilizarse directamente dentro de una expresión. Su importancia está estrechamente relacionada con la programación funcional, las funciones de orden superior, los cierres léxicos (*closures*) y la composición de operaciones sobre colecciones.

El concepto tiene una base teórica en el cálculo lambda, formalismo desarrollado por Alonzo Church en la década de 1930. El cálculo lambda proporciona una notación para definir funciones mediante abstracción y para aplicar funciones a argumentos; en los lenguajes modernos estas ideas aparecen, con diferentes reglas de tipos y ejecución, en características como las lambdas, funciones anónimas, funciones de primera clase y cierres [1], [2].

En la práctica, el concepto no es idéntico en todos los lenguajes. Python utiliza la forma `lambda parámetros: expresión` y la restringe a una sola expresión [3]. Java utiliza expresiones lambda asociadas a interfaces funcionales [4]. C# permite lambdas de expresión y de instrucciones, con conversión a delegados o árboles de expresión [5]. C++ construye un tipo de cierre sin nombre y dispone de un mecanismo explícito de captura de variables [6]. JavaScript ofrece expresiones `function` anónimas y funciones flecha, las cuales presentan diferencias semánticas importantes con respecto a las funciones tradicionales [7], [8]. Kotlin distingue entre *lambda literals* y declaraciones de funciones anónimas, aunque ambas representan funciones definidas en línea [9].

El objetivo de esta investigación es estudiar de manera integral las funciones anónimas y las expresiones lambda: su origen conceptual, sintaxis, semántica, alcance, captura de variables, funciones de orden superior, tipos, evaluación, usos prácticos, ventajas, limitaciones y diferencias entre varios lenguajes de programación modernos.

---

# Desarrollo Técnico

## 1. Fundamentos conceptuales

Una función anónima es una función que se define sin asignarle un nombre propio en su declaración. Su utilidad aparece cuando el comportamiento es pequeño, local y solamente necesita utilizarse en un contexto concreto.

Por ejemplo, una función tradicional puede definirse así:

```python
def cuadrado(x):
    return x * x
```

Mientras que una función anónima puede representarse como:

```python
lambda x: x * x
```

La segunda forma no significa necesariamente que la función carezca de identidad en el entorno de ejecución. Significa que su definición no introduce un nombre de función explícito. Dependiendo del lenguaje, la función puede almacenarse posteriormente en una variable, pasarse como argumento o formar parte de un objeto de cierre.

Una expresión lambda es una construcción sintáctica que permite expresar esa función de manera compacta. Su estructura conceptual puede representarse como:

```text
(parámetros) -> cuerpo
```

La sintaxis exacta depende del lenguaje. Por ejemplo:

| Lenguaje   | Ejemplo                       |
| ---------- | ----------------------------- |
| Python     | `lambda x: x * x`             |
| Java       | `(x) -> x * x`                |
| C#         | `x => x * x`                  |
| C++        | `[](int x) { return x * x; }` |
| JavaScript | `(x) => x * x`                |
| Kotlin     | `{ x -> x * x }`              |

Aunque estas construcciones son similares desde el punto de vista conceptual, no deben considerarse semánticamente idénticas. Cada lenguaje define sus propias reglas de tipos, captura de variables, retorno, contexto y representación interna [3]–[9].

---

## 2. Relación con el cálculo lambda

El cálculo lambda constituye una de las bases formales de la teoría de lenguajes funcionales y de la noción de función como entidad manipulable. En su forma elemental aparecen tres operaciones fundamentales:

* **Variable:** una referencia como `x`.
* **Abstracción:** una construcción equivalente a `λx.x + 1`.
* **Aplicación:** la utilización de una función sobre un argumento.

Por ejemplo:

```text
(λx. x + 1) 5
```

representa la aplicación de una función anónima que suma uno a su argumento. El resultado es:

```text
6
```

La abstracción lambda no prescribe directamente una sintaxis concreta para lenguajes como Java, C++ o Python. Más bien proporciona una base conceptual para entender funciones como expresiones que pueden construirse y aplicarse [1], [2].

En los lenguajes actuales, esta idea se combina con sistemas de tipos, gestión de memoria, objetos, inferencia de tipos, excepciones, concurrencia y otras características que no forman parte del cálculo lambda puro.

---

## 3. Funciones de primera clase

Las lambdas adquieren especial utilidad cuando las funciones son tratadas como valores de primera clase. Esto significa, en términos generales, que una función puede:

1. Almacenarse en una variable.
2. Pasarse como argumento.
3. Devolverse desde otra función.

Un ejemplo conceptual es:

```python
def aplicar(funcion, valor):
    return funcion(valor)


doble = lambda x: x * 2

resultado = aplicar(doble, 10)

print(resultado)
```

Resultado:

```text
20
```

La ventaja principal consiste en separar:

* **qué operación se realiza**, de
* **sobre qué datos se aplica**.

La función `aplicar()` no necesita conocer qué cálculo concreto representa `funcion`.

Esta propiedad es fundamental para las llamadas **funciones de orden superior**, es decir, funciones que reciben otras funciones como argumentos, las devuelven como resultado o ambas cosas [1], [2].

---

## 4. Funciones de orden superior

Las funciones de orden superior permiten construir operaciones genéricas sobre comportamiento.

Un patrón frecuente es el filtrado de colecciones:

```python
numeros = [1, 2, 3, 4, 5, 6]

pares = list(filter(lambda x: x % 2 == 0, numeros))

print(pares)
```

Resultado:

```text
[2, 4, 6]
```

La expresión lambda representa la condición de filtrado. Esto permite reutilizar `filter()` con diferentes criterios sin crear una función con nombre para cada caso.

Otro ejemplo es la transformación:

```python
numeros = [1, 2, 3, 4]

cuadrados = list(map(lambda x: x * x, numeros))

print(cuadrados)
```

Resultado:

```text
[1, 4, 9, 16]
```

También pueden utilizarse para ordenar objetos según una propiedad:

```python
personas = [
    ("Ana", 25),
    ("Luis", 19),
    ("Pedro", 31)
]

personas.sort(key=lambda persona: persona[1])
```

La función lambda actúa como una política local de ordenamiento. Python documenta precisamente este tipo de uso al aceptar funciones pequeñas como argumentos de operaciones sobre colecciones [3].

---

## 5. Closures o cierres léxicos

Una de las características más importantes asociadas a las funciones anónimas es la posibilidad de capturar variables del contexto en el que fueron creadas.

Ejemplo:

```python
def crear_incrementador(n):
    return lambda x: x + n


sumar_10 = crear_incrementador(10)

print(sumar_10(5))
```

Resultado:

```text
15
```

La lambda utiliza `n`, aunque `n` pertenece al entorno de `crear_incrementador()`.

La combinación entre una función y el entorno léxico que conserva las variables necesarias recibe el nombre de **closure** o **cierre**. La documentación de Python muestra este comportamiento mediante funciones lambda que recuerdan valores del ámbito que las contiene [3]. En C# se denomina igualmente *closure* a la combinación de una lambda con las variables que captura [5].

El concepto puede representarse así:

```text
                 Entorno léxico
              +------------------+
              | n = 10           |
              +--------+---------+
                       |
                       | captura
                       v
              +------------------+
              | lambda x: x + n  |
              +--------+---------+
                       |
                       v
                    suma(5)
                       |
                       v
                      15
```

Los cierres permiten implementar:

* Fábricas de funciones.
* Callbacks.
* Encapsulación de estado.
* Configuración de comportamiento.
* Diversas formas de programación funcional.

---

## 6. Captura de variables

La captura es una de las áreas donde más se diferencian los lenguajes.

### C++

En C++, la lambda incluye explícitamente una cláusula de captura:

```cpp
int incremento = 10;

auto sumar = [incremento](int x) {
    return x + incremento;
};
```

La variable puede capturarse por copia:

```cpp
[incremento]
```

o por referencia:

```cpp
[&incremento]
```

También existen capturas por defecto:

```cpp
[=]  // captura por copia
[&]  // captura por referencia
```

El estándar del lenguaje trata la lambda como una expresión que genera un tipo de cierre único y sin nombre; la cláusula de captura determina qué variables externas estarán disponibles dentro de su cuerpo [6].

### C#

En C#, una lambda puede capturar variables del ámbito circundante. La documentación de Microsoft señala que una lambda que necesita variables externas forma un cierre.

También existe la posibilidad de utilizar lambdas `static`, que impiden la captura accidental de variables externas [5].

### Java

En Java, las lambdas pueden acceder a variables locales del contexto cuando estas son `final` o **efectivamente finales**. Esto evita que el comportamiento dependa de cambios arbitrarios en variables locales después de crear la lambda [4].

---

## 7. Ámbito y duración de las variables capturadas

La captura de variables introduce preguntas importantes sobre alcance (*scope*) y vida útil (*lifetime*).

Por ejemplo:

```python
def crear_contador():
    contador = 0

    def incrementar():
        nonlocal contador
        contador += 1
        return contador

    return incrementar
```

El objeto retornado mantiene acceso al estado necesario para seguir funcionando.

En lenguajes con gestión automática de memoria, como Java, C#, JavaScript, Kotlin y Python, la representación interna del cierre puede permitir que los objetos capturados permanezcan vivos mientras exista una referencia al cierre.

En C++, en cambio, la elección entre captura por copia y referencia obliga al programador a considerar cuidadosamente la duración del objeto referenciado.

Por esta razón, una lambda pequeña no siempre implica una operación trivial a nivel de memoria.

---

## 8. Tipado de expresiones lambda

El tratamiento de los tipos depende del lenguaje.

### Java

Java utiliza **interfaces funcionales**, es decir, interfaces con un único método abstracto.

Por ejemplo:

```java
interface Operacion {
    int calcular(int a, int b);
}

Operacion suma = (a, b) -> a + b;
```

El tipo de la lambda se obtiene mediante el contexto esperado. Oracle describe este mecanismo como *target typing*: el compilador determina el tipo compatible de la lambda a partir del contexto en el que aparece [4].

También pueden utilizarse interfaces estándar:

```java
Function<Integer, Integer> doble = x -> x * 2;

Predicate<Integer> par = x -> x % 2 == 0;
```

### C#

C# permite asociar lambdas con tipos delegado:

```csharp
Func<int, int> doble = x => x * 2;
```

También puede convertir determinadas lambdas en **árboles de expresión**, lo que permite representar su estructura como datos en lugar de ejecutarla directamente.

Esta característica es especialmente relevante para proveedores de consultas que traducen expresiones a otros lenguajes o formatos [5].

### C++

C++ utiliza un tipo de cierre generado por el compilador. La lambda puede almacenarse con `auto`:

```cpp
auto doble = [](int x) {
    return x * 2;
};
```

Las lambdas sin captura también pueden convertirse a punteros a función compatibles en los casos permitidos por el lenguaje [6].

### Python

Python es dinámico. Una lambda produce un objeto función:

```python
doble = lambda x: x * 2
```

No requiere declarar un tipo de función independiente. Su restricción sintáctica principal es que el cuerpo debe ser una única expresión [3].

---

## 9. Sintaxis y diferencias entre lenguajes

| Lenguaje       | Sintaxis representativa        | Captura                                           | Característica destacada                                |
| -------------- | ------------------------------ | ------------------------------------------------- | ------------------------------------------------------- |
| **Python**     | `lambda x: x * 2`              | Ámbito léxico                                     | Una sola expresión                                      |
| **Java**       | `x -> x * 2`                   | Variables locales finales o efectivamente finales | Interfaces funcionales                                  |
| **C#**         | `x => x * 2`                   | Cierres                                           | Delegados y árboles de expresión                        |
| **C++**        | `[&](int x) { return x * 2; }` | Copia o referencia                                | Tipo de cierre y captura explícita                      |
| **JavaScript** | `x => x * 2`                   | Ámbito léxico                                     | `this` distinto al de funciones tradicionales           |
| **Kotlin**     | `{ x -> x * 2 }`               | Contexto léxico                                   | Lambdas y funciones anónimas como literales funcionales |

Las funciones flecha de JavaScript tienen una característica especialmente importante: no crean sus propias vinculaciones para `this`, `arguments` o `super`, por lo que no deben considerarse simplemente una abreviatura sintáctica perfecta de una función tradicional [7].

MDN también distingue las funciones anónimas tradicionales de las funciones flecha y documenta sus diferencias de comportamiento [8].

Kotlin, por su parte, distingue formalmente entre *lambda literals* y declaraciones de funciones anónimas. Ambas permiten definir una función en línea, pero presentan diferencias de sintaxis y semántica [9].

---

## 10. Lambdas de expresión y lambdas de instrucciones

Algunos lenguajes permiten que el cuerpo sea una expresión simple o un bloque de instrucciones.

En C#:

```csharp
Func<int, int> cuadrado = x => x * x;
```

es una **lambda de expresión**.

Mientras que:

```csharp
Action<string> imprimir = nombre =>
{
    string mensaje = "Hola " + nombre;
    Console.WriteLine(mensaje);
};
```

es una **lambda de instrucciones** [5].

Java también permite cuerpos expresados como una sola expresión o bloques con `return`, dependiendo del tipo de lambda [4].

Esta diferencia afecta la claridad del código. Una lambda corta suele mejorar la legibilidad; una lambda demasiado extensa puede convertirse en una función anónima difícil de mantener.

---

## 11. Diferencia entre función anónima, lambda y closure

Estos términos se relacionan, pero no son completamente sinónimos:

| Concepto             | Definición                                                                                            |
| -------------------- | ----------------------------------------------------------------------------------------------------- |
| **Función anónima**  | Función que no tiene un nombre explícito en su definición.                                            |
| **Expresión lambda** | Construcción sintáctica para expresar una función de forma compacta.                                  |
| **Closure**          | Función junto con el entorno léxico que conserva las variables externas necesarias para su ejecución. |

Una representación conceptual sería:

```text
Función anónima
       |
       +-- puede expresarse mediante una lambda
                    |
                    v
              Expresión lambda
                    |
                    +-- si captura variables externas
                    v
                  Closure
```

No todas las lambdas necesitan capturar variables, por lo que una lambda puede existir sin ser un *closure* en el sentido práctico de conservar estado externo.

---

## 12. Callbacks y programación orientada a eventos

Las funciones anónimas son especialmente útiles como **callbacks**.

JavaScript ofrece un ejemplo clásico:

```javascript
button.addEventListener("click", () => {
    console.log("Botón presionado");
});
```

La función no necesita un nombre porque solamente se utiliza como comportamiento asociado al evento.

El mismo patrón aparece en:

* Interfaces gráficas.
* Temporizadores.
* Operaciones asíncronas.
* Procesamiento de colecciones.
* Tareas concurrentes.
* Validaciones.
* Operaciones de ordenamiento.
* Consultas de datos.
* APIs que aceptan funciones de configuración o transformación.

Este patrón permite colocar el comportamiento cerca del lugar donde se utiliza.

---

## 13. Asincronía y lambdas

Las lambdas también se combinan con operaciones asíncronas.

Por ejemplo, C# permite lambdas asíncronas:

```csharp
Func<Task> tarea = async () =>
{
    await ProcesarAsync();
};
```

Esto es útil cuando una API acepta una función que debe ejecutar operaciones `await`.

JavaScript utiliza funciones flecha con `async`:

```javascript
const obtenerDatos = async () => {
    const respuesta = await fetch("/api/datos");
    return respuesta.json();
};
```

En estos casos la función anónima no solo encapsula comportamiento, sino también una unidad de flujo asíncrono.

---

## 14. Ventajas

Las funciones anónimas y lambdas ofrecen varias ventajas:

### Reducción de código

Permiten representar operaciones pequeñas sin declarar funciones separadas.

### Localidad del comportamiento

El código puede colocarse junto al punto donde se utiliza.

### Composición

Facilitan construir operaciones de orden superior.

### Reutilización de algoritmos

Una misma función puede recibir diferentes estrategias de procesamiento.

### Callbacks

Son adecuadas para eventos, tareas y operaciones asincrónicas.

### Programación funcional

Favorecen el uso de `map`, `filter`, `reduce`, composición y transformaciones.

### Expresividad

En operaciones simples pueden hacer más evidente la intención del programa.

Java, por ejemplo, documenta que las lambdas permiten tratar el comportamiento como un argumento, mientras C# las utiliza extensamente junto con delegados y LINQ [4], [5].

---

## 15. Desventajas y riesgos

El uso excesivo también puede introducir problemas:

* **Legibilidad:** una lambda demasiado larga puede ser más difícil de entender que una función con nombre.
* **Depuración:** algunas herramientas muestran nombres generados internamente, lo cual puede dificultar la lectura de una traza.
* **Capturas accidentales:** una lambda puede mantener vivos objetos que ya no eran necesarios.
* **Costos de memoria:** determinados cierres requieren objetos o estructuras auxiliares.
* **Complejidad de tipos:** en lenguajes fuertemente tipados, las lambdas pueden involucrar inferencia, conversiones y sobrecarga complejas.
* **Errores de ciclo de vida:** las capturas por referencia en C++ requieren especial cuidado.
* **Abstracción excesiva:** transformar todo algoritmo en una cadena de lambdas puede disminuir la mantenibilidad.

Por estas razones, una lambda debe utilizarse cuando aporta claridad y no únicamente por ser una sintaxis moderna.

---

## 16. Rendimiento e implementación

No existe una regla universal que indique que una lambda es siempre más rápida o más lenta que una función tradicional.

La implementación depende del:

* Lenguaje.
* Compilador.
* Entorno de ejecución.
* Contexto.
* Optimizaciones disponibles.

En lenguajes compilados, una lambda puede transformarse en:

* Una función especializada.
* Un objeto de cierre.
* Una función estática.
* Un objeto temporal.
* Código potencialmente *inlineado*.

C++ define explícitamente un tipo de cierre sin nombre para cada lambda [6]. En otros lenguajes administrados pueden existir representaciones internas diferentes.

Por ello, comparar rendimiento únicamente a partir de la sintaxis *función nombrada frente a lambda* es incorrecto. El rendimiento real debe evaluarse mediante el modelo de ejecución específico y, cuando sea necesario, mediante mediciones.

---

## 17. Aplicaciones prácticas

Las funciones anónimas y expresiones lambda aparecen en numerosos escenarios:

```text
             FUNCIONES ANÓNIMAS Y LAMBDAS
                         |
       +-----------------+-----------------+
       |                 |                 |
       v                 v                 v
   Colecciones        Eventos          Asincronía
       |                 |                 |
   map/filter        callbacks         async/await
       |                 |                 |
       +-----------------+-----------------+
                         |
                         v
                 Funciones de orden
                      superior
                         |
                         v
                     Closures
```

Entre sus aplicaciones prácticas se encuentran:

* Filtrar estudiantes por promedio.
* Ordenar productos por precio.
* Validar formularios.
* Procesar respuestas HTTP.
* Ejecutar callbacks de eventos.
* Definir estrategias de búsqueda.
* Crear funciones parametrizadas.
* Construir pipelines de transformación.
* Implementar algoritmos genéricos.
* Encapsular estado temporal.

---

## 18. Comparación de estilos

Una función con nombre puede ser preferible cuando la operación es reutilizada:

```python
def es_par(numero):
    return numero % 2 == 0


pares = list(filter(es_par, numeros))
```

Una lambda es apropiada cuando la operación es local y sencilla:

```python
pares = list(filter(lambda numero: numero % 2 == 0, numeros))
```

La diferencia más importante no es solamente la cantidad de caracteres. Se relaciona con la intención y el alcance de reutilización.

Como regla práctica:

```text
Operación pequeña + uso local
            |
            v
         Lambda


Operación compleja + reutilización
            |
            v
     Función con nombre
```

---

## 19. Errores frecuentes

### Lambda demasiado grande

Por ejemplo:

```python
resultado = lambda x: (
    x * 2 + 10 if x > 5
    else x - 3
)
```

Aunque es posible, una función con nombre puede ser más clara si la lógica continúa creciendo.

### Captura de una variable equivocada

Las capturas deben entenderse antes de utilizar una lambda dentro de tareas diferidas o callbacks.

### Confundir lambda con closure

No toda lambda captura variables externas.

### Asumir que todas las lambdas se comportan igual

La sintaxis puede ser parecida, pero `this` de JavaScript, las interfaces funcionales de Java, la captura de C++ y los árboles de expresión de C# muestran diferencias importantes [4]–[9].

---

## 20. Buenas prácticas

Para aprovechar correctamente las expresiones lambda se recomienda:

1. Mantenerlas pequeñas cuando su lógica sea local.
2. Elegir nombres claros para las variables de los parámetros.
3. Evitar anidar lambdas innecesariamente.
4. Considerar una función con nombre cuando la lógica sea compleja.
5. Revisar qué variables se están capturando.
6. En C++, elegir conscientemente captura por copia o referencia.
7. En C#, considerar lambdas `static` cuando no deba existir captura.
8. No asumir que una lambda implica automáticamente mejor rendimiento.
9. Utilizar las APIs funcionales del lenguaje cuando mejoren la claridad.
10. Probar y perfilar el código cuando existan requisitos de rendimiento.

---

# Conclusiones

Las funciones anónimas y las expresiones lambda constituyen una herramienta fundamental de los lenguajes modernos, ya que permiten representar comportamiento como un valor y facilitar el uso de funciones de orden superior.

Su fundamento conceptual está relacionado con el cálculo lambda, que proporciona una base formal para la abstracción y aplicación de funciones. Los lenguajes actuales incorporan estas ideas dentro de sistemas mucho más amplios de tipos, objetos y administración de memoria [1], [2].

La principal ventaja práctica de las lambdas es la composición de comportamiento, especialmente en operaciones sobre colecciones, callbacks, eventos, procesamiento asíncrono y patrones funcionales.

Los closures amplían el concepto al permitir conservar variables del contexto léxico, pero también introducen consideraciones relacionadas con alcance, duración de objetos y uso de memoria.

La implementación varía considerablemente entre lenguajes. Java depende de interfaces funcionales y tipado contextual; C# utiliza delegados y árboles de expresión; C++ emplea tipos de cierre y captura explícita; Python limita el cuerpo lambda a una expresión; JavaScript distingue significativamente las funciones flecha de las funciones tradicionales; y Kotlin diferencia lambdas de funciones anónimas [3]–[9].

Una lambda no siempre es la mejor opción. Cuando la lógica es extensa, se reutiliza frecuentemente o necesita una explicación semántica propia, una función con nombre suele proporcionar mayor claridad y mantenibilidad.

En consecuencia, las funciones anónimas y las expresiones lambda deben entenderse no solo como una abreviatura sintáctica, sino como parte de un modelo de programación que permite tratar el comportamiento como dato, fomentar la abstracción y construir software más composicional.

---

# Bibliografía

[1] A. Church, "A set of postulates for the foundation of logic," *Annals of Mathematics*, 2nd ser., vol. 33, no. 2, pp. 346–366, 1932.

[2] H. Abelson, G. J. Sussman, and J. Sussman, *Structure and Interpretation of Computer Programs*, 2nd ed. Cambridge, MA, USA: MIT Press, 1996.

[3] Python Software Foundation, "6.14. Lambdas," *Python 3.14 Documentation*. [En línea]. Disponible en: https://docs.python.org/3/reference/expressions.html#lambda. [Accedido: 5-sep-2026].

[4] Oracle, "Lambda Expressions," *The Java Tutorials*. [En línea]. Disponible en: https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html. [Accedido: 5-sep-2026].

[5] Microsoft, "Expresiones lambda: expresiones lambda y funciones anónimas," *Microsoft Learn, C# reference*. [En línea]. Disponible en: https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/operators/lambda-expressions. [Accedido: 5-sep-2026].

[6] cppreference.com, "Lambda expressions (since C++11)," *C++ language reference*. [En línea]. Disponible en: https://en.cppreference.com/w/cpp/language/lambda. [Accedido: 5-sep-2026].

[7] Mozilla Developer Network, "Arrow function expressions," *MDN Web Docs*. [En línea]. Disponible en: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions. [Accedido: 5-sep-2026].

[8] Mozilla Developer Network, "Functions," *MDN Web Docs*. [En línea]. Disponible en: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions. [Accedido: 5-sep-2026].

[9] Kotlin Foundation, "Higher-order functions and lambdas," *Kotlin Documentation*. [En línea]. Disponible en: https://kotlinlang.org/docs/lambdas.html. [Accedido: 5-sep-2026].

[10] J. R. Hindley and J. P. Seldin, *Lambda-Calculus and Combinators: An Introduction*, 2nd ed. Cambridge, U.K.: Cambridge University Press, 2008.
