# F# (F Sharp): Inferencia de tipos, Option frente a null e interoperabilidad con C#/.NET

- **Integrante responsable:** Angel Cassiel Neyra Mendez
- **Exposición:** Introducción a lenguajes funcionales · Unidad 1
- **Duración aproximada:** 3 minutos

---

## Inferencia de tipos (Type Inference)

### ¿Qué es la inferencia de tipos?

La inferencia de tipos es una característica de F# que permite que el compilador determine automáticamente el tipo de dato de una variable, parámetro o resultado de una función, sin que el programador tenga que especificarlo explícitamente en todos los casos.

Esto significa que no siempre es necesario escribir si una variable es de tipo `int`, `string`, `float` o `bool`, ya que el compilador puede deducirlo mediante el valor asignado y las operaciones que se realizan.

Aunque F# puede determinar los tipos automáticamente, sigue siendo un lenguaje de tipado estático. Esto quiere decir que los tipos se comprueban durante la compilación y no cambian libremente durante la ejecución.

### ¿Cómo funciona?

El compilador analiza diferentes elementos del código para determinar el tipo correspondiente:

1. **Valores asignados:** identifica el tipo a partir del valor que se proporciona.
2. **Operaciones:** analiza qué operaciones se realizan con los datos.
3. **Parámetros:** deduce los tipos de los parámetros según cómo se utilizan.
4. **Resultados:** determina el tipo de retorno de una función mediante la expresión que devuelve.
5. **Contexto:** utiliza la información de otras partes del programa para establecer el tipo correcto.

### Ejemplo básico de inferencia de tipos

```fsharp
let edad = 21
let nombre = "Neyra"
let promedio = 9.5
let activo = true
```

En este ejemplo, no se especifican los tipos de datos, pero F# los identifica automáticamente.

El compilador determina lo siguiente:

| Variable | Valor | Tipo inferido |
|---|---|---|
| edad | 21 | int |
| nombre | "Neyra" | string |
| promedio | 9.5 | float |
| activo | true | bool |

Por lo tanto, aunque no se escriban los tipos, el compilador conoce exactamente qué tipo corresponde a cada variable.

### Inferencia de tipos en funciones

La inferencia también funciona con los parámetros y los valores de retorno de las funciones.

```fsharp
let sumar a b =
    a + b + 10
```

En este ejemplo, el compilador analiza la operación de suma y el valor entero `10`.

Por lo tanto, determina que los parámetros y el resultado son de tipo entero.

La firma inferida es:

```fsharp
val sumar: int -> int -> int
```

Esto significa que la función recibe dos números enteros y devuelve otro número entero.

Podemos utilizarla de la siguiente manera:

```fsharp
let resultado = sumar 5 8

printfn "Resultado: %d" resultado
```

Salida:

```text
Resultado: 23
```

### Inferencia de tipos en funciones genéricas

F# también puede determinar cuándo una función puede trabajar con diferentes tipos de datos.

Ejemplo:

```fsharp
let crearTupla a b =
    (a, b)
```

En este caso, no se realizan operaciones que obliguen a que los dos parámetros tengan el mismo tipo.

El compilador infiere la siguiente firma:

```fsharp
val crearTupla: 'a -> 'b -> 'a * 'b
```

Esto significa que puede recibir dos valores de tipos diferentes y devolverlos agrupados en una tupla.

Ejemplo de uso:

```fsharp
let persona = crearTupla "Carlos" 22

printfn "%A" persona
```

Salida:

```text
("Carlos", 22)
```

Aquí se combinó un dato de tipo `string` con otro de tipo `int`.

---

## Option frente a null

### ¿Qué es null?

En programación, `null` representa la ausencia de una referencia a un objeto.

Es decir, una variable puede estar declarada para almacenar un objeto, pero en determinado momento no contener ninguna referencia válida.

Este concepto se utiliza ampliamente en lenguajes como C# y otros lenguajes del entorno .NET.

Ejemplo en C#:

```csharp
string nombre = null;

if (nombre == null)
{
    Console.WriteLine("El nombre no tiene un valor.");
}
```

El problema de utilizar `null` es que, si un programa intenta acceder a una propiedad o método de una referencia nula, puede producirse una excepción llamada `NullReferenceException`.

Ejemplo:

```csharp
string nombre = null;

Console.WriteLine(nombre.Length);
```

Este código produce un error porque se intenta consultar la longitud de una cadena que no tiene una referencia válida.

### ¿Qué es Option en F#?

`Option` es un tipo de dato de F# que permite representar situaciones en las que un valor puede existir o no existir.

En lugar de utilizar directamente `null` para indicar que no hay un valor, F# utiliza dos posibilidades:

- `Some`: indica que existe un valor.
- `None`: indica que no existe un valor.

La estructura general es:

```fsharp
Some(valor)
```

Cuando existe un valor.

```fsharp
None
```

Cuando no existe un valor.

El tipo `Option` permite expresar explícitamente la posibilidad de que un dato esté ausente y obliga al programador a considerar los diferentes casos.

### Ejemplo básico de Option

```fsharp
let nombre = Some "Carlos"

let apellido = None
```

En este ejemplo:

- `nombre` contiene un valor de tipo `string option`.
- `apellido` representa la ausencia de un valor y su tipo puede inferirse como `'a option` hasta que se determine un tipo concreto.

Podemos especificar el tipo de manera explícita:

```fsharp
let nombre: string option = Some "Carlos"

let apellido: string option = None
```

### ¿Cómo se utiliza Option?

Una de las maneras más comunes de trabajar con `Option` es mediante `match`, que permite comprobar si existe un valor o no.

Ejemplo:

```fsharp
let mostrarNombre nombre =
    match nombre with
    | Some valor -> printfn "Nombre: %s" valor
    | None -> printfn "No se proporcionó un nombre."
```

Utilización:

```fsharp
mostrarNombre (Some "Carlos")
mostrarNombre None
```

Salida:

```text
Nombre: Carlos
No se proporcionó un nombre.
```

La expresión `match` comprueba los dos posibles casos:

- Si recibe `Some`, obtiene y utiliza el valor almacenado.
- Si recibe `None`, ejecuta la instrucción correspondiente a la ausencia de información.

### Ejemplo práctico: búsqueda de un usuario

Imaginemos que tenemos un sistema que busca usuarios por su identificador.

Si el usuario existe, queremos devolver sus datos. Si no existe, queremos indicar que no se encontró.

```fsharp
let buscarUsuario id =
    match id with
    | 1 -> Some "Carlos"
    | 2 -> Some "Mariana"
    | _ -> None
```

Ahora podemos comprobar el resultado:

```fsharp
let resultado = buscarUsuario 1

match resultado with
| Some usuario ->
    printfn "Usuario encontrado: %s" usuario
| None ->
    printfn "El usuario no existe."
```

Salida:

```text
Usuario encontrado: Carlos
```

Si buscamos un identificador que no existe:

```fsharp
let resultado = buscarUsuario 5

match resultado with
| Some usuario ->
    printfn "Usuario encontrado: %s" usuario
| None ->
    printfn "El usuario no existe."
```

Salida:

```text
El usuario no existe.
```

Este ejemplo demuestra cómo `Option` permite controlar los casos en los que una búsqueda puede devolver un resultado o no.

### Diferencias entre Option y null

| Característica | Option | null |
|---|---|---|
| Significado | Representa un valor que puede existir o no. | Representa una referencia sin objeto. |
| Uso principal | Expresar valores opcionales. | Indicar ausencia de una referencia. |
| Valores | `Some` y `None`. | `null`. |
| Seguridad | Permite comprobar explícitamente la ausencia de valor. | Puede provocar errores si no se comprueba. |
| Comprobación | Se utiliza `match`, `Option.isSome` y otras funciones. | Se utiliza una comparación con `null`. |
| Lenguaje | Es el enfoque habitual en F# y otros lenguajes funcionales. | Es común en C# y otros lenguajes. |

---

## Interoperabilidad con C#/.NET

### ¿Qué significa?

F# se compila al mismo código intermedio que C# y se ejecuta sobre el mismo entorno de ejecución de .NET (CLR). Por eso, F# y C# pueden convivir en una misma solución y compartir librerías sin necesidad de traducir datos entre lenguajes.

### Usar librerías de .NET desde F#

Todo lo que existe en .NET (la biblioteca base, paquetes de NuGet y proyectos escritos en C#) puede utilizarse directamente desde F#.

```fsharp
open System

let lenguajes = ResizeArray<string>()
lenguajes.Add("F#")
lenguajes.Add("C#")

printfn "Cantidad: %d" lenguajes.Count
printfn "Mayor: %d" (Math.Max(3, 7))
```

Salida:

```text
Cantidad: 2
Mayor: 7
```

`ResizeArray<string>` es el nombre que F# le da a `List<string>` de .NET, y `Math.Max` es un método de la biblioteca base.

### Usar código F# desde C#

Un módulo de F# se compila como una clase estática, y una función como `sumar a b` se expone en C# como un método con dos parámetros.

Código en F#:

```fsharp
namespace Calculadora

module Operaciones =
    let sumar a b = a + b
```

Uso desde C#:

```csharp
using Calculadora;

int resultado = Operaciones.sumar(2, 3);
Console.WriteLine(resultado);
```

Salida:

```text
5
```

### Option y null al trabajar con .NET

Los valores que llegan de librerías de .NET pueden ser `null`. En F# se pueden convertir a `Option` con `Option.ofObj`, para tratarlos con `match` como cualquier otro valor opcional.

```fsharp
let texto: string = System.Environment.GetEnvironmentVariable("VARIABLE_QUE_NO_EXISTE")

match Option.ofObj texto with
| Some valor -> printfn "Valor: %s" valor
| None -> printfn "Variable no definida"
```

Salida:

```text
Variable no definida
```

También existe `Option.toObj`, que hace el camino inverso: convierte `None` en `null` para entregar el valor a código que espera referencias nulas. Desde C#, un `Option` de F# se ve como el tipo `FSharpOption<T>`, definido en la librería `FSharp.Core`.

### Ventajas de la interoperabilidad

- **Reutilización:** se aprovechan las librerías de .NET y los paquetes de NuGet sin reescribirlos.
- **Adopción gradual:** un proyecto en C# puede incorporar partes en F# sin empezar desde cero.
- **Equipos mixtos:** cada parte de una solución puede usar el lenguaje que mejor le convenga.

---

Referencias: ver [13]–[15] en la sección [Bibliografía (IEEE)](README.md#bibliograf%C3%ADa-ieee) del README del equipo.
