# *Tuplas y registros: agrupar datos sin clases*
##### Alumno: Neyra Mendez Angel Cassiel
##### Materia: Programación Logica y Funcional 

![Qué es Programación Lógica y Funcional?](https://www.dongee.com/tutoriales/content/images/2024/04/image-47.png)
## Introducción

En programación es muy común trabajar con información que está formada por varios datos relacionados entre sí. Por ejemplo, los datos de un estudiante pueden estar compuestos por su nombre, edad y promedio; una coordenada puede estar formada por los valores `X` y `Y`; y el resultado de una operación puede necesitar devolver varios valores al mismo tiempo. Una forma tradicional de representar este tipo de información es mediante clases, pero no siempre es necesario crear una clase para agrupar unos cuantos datos.

Las **tuplas y los registros** ofrecen alternativas más sencillas para organizar información relacionada. Las tuplas permiten agrupar varios valores en una sola estructura de manera rápida y con poca sintaxis. En C#, una tupla puede contener diferentes tipos de datos y sus elementos pueden tener nombres para facilitar su comprensión. Microsoft define las tuplas como una estructura ligera que permite agrupar múltiples elementos de datos.

Por otro lado, los **registros (`record`)** están diseñados para representar datos que tienen una estructura definida y cuyo contenido es más importante que la identidad del objeto. Los registros proporcionan características como igualdad basada en valores, una representación de texto automática y una sintaxis sencilla para crear tipos centrados en datos.

El objetivo de este tema es comprender cómo utilizar tuplas y registros para agrupar información sin tener que recurrir inmediatamente a la creación de clases, así como identificar cuándo resulta conveniente utilizar cada alternativa.

----------

## Desarrollo técnico

### 1. ¿Qué son las tuplas?

Una **tupla** es una estructura de datos que permite almacenar varios valores relacionados dentro de una sola variable. Cada elemento de la tupla puede tener un tipo diferente.

Por ejemplo:

```
var estudiante = ("Neyra", 21, 9.2);
```

En este caso, la tupla contiene tres valores:

-   `"Neyra"` → `string`
-   `21` → `int`
-   `9.2` → `double`

La principal ventaja de las tuplas es que permiten agrupar información sin tener que declarar previamente una clase o estructura. En C#, las tuplas son tipos de valor y sus elementos pueden ser accedidos mediante nombres como `Item1`, `Item2`, etc., aunque también es posible asignar nombres más descriptivos.

Por ejemplo:

```
var estudiante = (
    Nombre: "Neyra",
    Edad: 21,
    Promedio: 9.2
);

Console.WriteLine(estudiante.Nombre);
Console.WriteLine(estudiante.Edad);
Console.WriteLine(estudiante.Promedio);
```

El uso de nombres hace que el código sea más fácil de leer que si se utilizaran únicamente `Item1`, `Item2` y `Item3`.
![🐍 Tuplas en Python 📝 🤔 Qué es una tupla? Como accedo a los elementos que  contiene? Puedo alterarla? 📋 Una tupla es un conjunto ordenado e inmutable  de elementos del mismo](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9jgSz_Dh-hGMslBnHQTS8He9zdWrHYvh3qN02oPE7s60TWnGgnHI0ZBr8&s=10)

----------

### 2. Tuplas para devolver varios valores

Una de las aplicaciones más útiles de las tuplas es devolver varios resultados desde un método.

Normalmente, una función devuelve un solo valor. Sin embargo, puede existir una situación en la que sea necesario regresar más de uno.

Por ejemplo, podemos crear un método que reciba dos números y devuelva tanto su suma como su resta:

```
static (int Suma, int Resta) Calcular(int a, int b)
{
    return (a + b, a - b);
}
```

Después podemos utilizar el método:

```
var resultado = Calcular(10, 5);

Console.WriteLine(resultado.Suma);
Console.WriteLine(resultado.Resta);
```

También podemos **descomponer** la tupla directamente en diferentes variables:

```
var (suma, resta) = Calcular(10, 5);

Console.WriteLine($"Suma: {suma}");
Console.WriteLine($"Resta: {resta}");
```

Esto resulta especialmente útil cuando un método necesita devolver una pequeña cantidad de resultados relacionados. Microsoft recomienda las tuplas particularmente para agrupaciones temporales o para devolver varios valores cuando no es necesario crear un tipo completo.
      ![Funciones — Fundamentos de Programación en Python](https://www2.eii.uva.es/fund_inf/python/_images/listas_2_35.jpg)

----------

### 3. Ventajas de utilizar tuplas

Entre las principales ventajas de las tuplas se encuentran:

-   Permiten agrupar varios valores rápidamente.
-   No requieren declarar una clase.
-   Su sintaxis es sencilla.
-   Pueden contener diferentes tipos de datos.
-   Permiten nombrar sus elementos.
-   Pueden utilizarse como valores de retorno de métodos.
-   Facilitan la descomposición de información en variables individuales.

Por ejemplo:

```
(string Nombre, int Edad) ObtenerDatos()
{
    return ("Carlos", 20);
}

var (nombre, edad) = ObtenerDatos();

Console.WriteLine(nombre);
Console.WriteLine(edad);
```

Sin embargo, las tuplas también tienen limitaciones. Si una determinada agrupación de datos comienza a utilizarse constantemente en diferentes partes de un programa, puede ser una señal de que debería convertirse en un tipo con nombre, como un `record` o una clase.

----------

### 4. ¿Qué son los registros?

Los **registros**, conocidos como `record` en C#, son tipos diseñados principalmente para almacenar y representar datos.

Un registro puede declararse de una manera muy compacta:

```
public record Estudiante(
    string Nombre,
    int Edad,
    double Promedio
);
```

Después podemos crear una instancia:

```
var estudiante = new Estudiante(
    "Neyra",
    21,
    9.2
);

Console.WriteLine(estudiante.Nombre);
Console.WriteLine(estudiante.Promedio);
```

A diferencia de una tupla, el registro tiene un **nombre propio**: `Estudiante`.

Esto permite expresar mejor qué representa la información. Una tupla como:

```
("Neyra", 21, 9.2)
```

puede ser suficiente para una operación temporal, pero un registro llamado `Estudiante` comunica claramente qué representa ese conjunto de datos.
![Tema 2: Programación funcional - LPP](https://domingogallardo.github.io/apuntes-lpp/teoria/tema02-programacion-funcional/imagenes/lista-lista.png)

----------

### 5. Igualdad basada en valores

Una característica importante de los registros es que utilizan **igualdad basada en valores**.

Por ejemplo:

```
var estudiante1 = new Estudiante("Ana", 20, 9.5);
var estudiante2 = new Estudiante("Ana", 20, 9.5);

Console.WriteLine(estudiante1 == estudiante2);
```

El resultado será:

```
True
```

Esto ocurre porque ambos registros contienen los mismos valores.

Esta característica diferencia a los registros de las clases tradicionales. En una clase, por defecto, dos objetos distintos pueden considerarse diferentes aunque tengan exactamente los mismos datos. Los registros están pensados precisamente para situaciones donde la información almacenada es más importante que la identidad de la instancia.

----------

### 6. Inmutabilidad y `with`

Los registros también permiten trabajar fácilmente con datos que no deberían modificarse directamente.

Por ejemplo:

```
public record Producto(
    string Nombre,
    decimal Precio
);
```

Podemos crear un producto:

```
var producto1 = new Producto("Laptop", 15000);
```

Y posteriormente crear una copia modificando solamente uno de sus valores:

```
var producto2 = producto1 with
{
    Precio = 14000
};
```

En este caso, `producto1` permanece sin cambios y `producto2` contiene una nueva versión del registro.

La documentación de C# señala que los registros proporcionan una forma de realizar modificaciones no destructivas mediante expresiones `with`, además de igualdad basada en valores y una representación automática de los datos.

----------


### 7. Diferencias entre tuplas, registros y clases

Aunque las tres alternativas permiten trabajar con varios datos, tienen diferentes propósitos.

| Característica | Tupla | Record | Clase |
| :--- | :--- | :--- | :--- |
| Agrupar datos | Sí | Sí | Sí |
| Necesita declaración previa | No | Sí | Sí |
| Tiene nombre propio | No | Sí | Sí |
| Sintaxis sencilla | Sí | Sí | No siempre |
| Igualdad por valores | Sí | Sí | Depende de la implementación |
| Puede contener métodos | No | Sí | Sí |
| Ideal para datos temporales | Sí | Puede ser | No necesariamente |
| Ideal para modelos de datos | Limitado | Sí | Sí |
| Permite comportamiento complejo | No | Sí | Sí |
| Herencia | No | Sí, con restricciones según el tipo | Sí |


La documentación oficial de C# propone utilizar una **tupla cuando se necesita realizar una agrupación temporal**, un **record cuando se necesita representar datos cuyo valor es importante**, y una **clase cuando se requiere estado mutable, comportamiento o identidad de objeto**.

----------

### 8. Ejemplo práctico

Supongamos que un programa necesita obtener un resumen de las ventas realizadas durante un día.

Con una tupla podemos hacerlo de la siguiente manera:

```
static (int Ventas, decimal Total) ObtenerResumen()
{
    int ventas = 25;
    decimal total = 4580.50m;

    return (ventas, total);
}
```

Posteriormente:

```
var resumen = ObtenerResumen();

Console.WriteLine($"Ventas realizadas: {resumen.Ventas}");
Console.WriteLine($"Total vendido: ${resumen.Total}");
```

Si esta información solamente se utiliza dentro de una operación específica, la tupla es una buena opción.

Sin embargo, si el resumen de ventas se convierte en una parte importante del sistema y se utiliza en reportes, estadísticas, interfaces y diferentes métodos, sería más conveniente crear un registro:

```
public record ResumenVentas(
    int Ventas,
    decimal Total
);
```

Después:

```
var resumen = new ResumenVentas(25, 4580.50m);

Console.WriteLine($"Ventas: {resumen.Ventas}");
Console.WriteLine($"Total: ${resumen.Total}");
```

De esta manera, el código tiene un tipo claramente identificado y reutilizable.

----------

### 9. ¿Cuándo utilizar cada uno?

Una forma sencilla de decidir entre estas opciones es preguntarse cuánto tiempo y qué importancia tendrá la agrupación de datos dentro del programa.

### ¿Cuándo utilizar cada uno?

| Tuplas | Registros | Clases |
| :--- | :--- | :--- |
| Se necesitan agrupar pocos datos. | Los datos representan un concepto específico. | El objeto tiene comportamiento complejo. |
| La información se utiliza temporalmente. | El conjunto de datos será reutilizado. | Necesita mantener estado mutable. |
| Se necesitan devolver varios valores desde un método. | Se desea un tipo con nombre. | Se requiere encapsulación. |
| No vale la pena crear un nuevo tipo. | La igualdad basada en valores es importante. | Se necesita herencia o polimorfismo. |
| La agrupación no representa un concepto importante del sistema. | Se trabaja principalmente con datos y no con comportamiento complejo. | La identidad del objeto es importante. |


Por lo tanto, utilizar tuplas y registros no significa que las clases hayan dejado de ser necesarias. Más bien, estas herramientas permiten seleccionar una estructura adecuada dependiendo de las necesidades del programa.

----------

## Conclusiones

Las **tuplas y los registros** permiten agrupar datos de forma sencilla sin crear una clase. Las tuplas son ideales para información temporal o para devolver varios valores, mientras que los registros son mejores para representar datos estructurados y reutilizables.

Las **clases** siguen siendo necesarias cuando se requiere mayor complejidad, como comportamiento, encapsulación o estado mutable. Conocer las diferencias entre estas opciones ayuda a elegir la estructura más adecuada y escribir código más claro y eficiente.

----------

## Bibliografía

[1] Microsoft, “Tuple types (C# reference),” _Microsoft Learn_, 2026. [En línea]. Disponible en: [Microsoft Learn – Tuple types](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/value-tuples?utm_source=chatgpt.com). [Accedido: 1-sep-2026]. 

[2] Microsoft, “Tutorial: Choose between tuples, records, structs, and classes - C#,” _Microsoft Learn_, 2026. [En línea]. Disponible en: [Microsoft Learn – Choosing types in C#](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/choosing-types?utm_source=chatgpt.com). [Accedido: 1-sep-2026]. 

[3] Microsoft, “Records - C# reference,” _Microsoft Learn_, 2026. [En línea]. Disponible en: [Microsoft Learn – Records](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/record?utm_source=chatgpt.com). [Accedido: 1-sep-2026]. 

[4] Microsoft, “Tutorial: Create types in C#,” _Microsoft Learn_, 2026. [En línea]. Disponible en: [Microsoft Learn – Tuples and types](https://learn.microsoft.com/en-us/dotnet/csharp/tour-of-csharp/tutorials/tuples-and-types?utm_source=chatgpt.com). [Accedido: 1-sep-2026]. 
