# Equipo 8 — F#

## Guion de exposición: Modelo de cómputo y sintaxis

- **Integrante responsable:** Emily Mijangos Garibay
- **Exposición:** Introducción a lenguajes funcionales · Unidad 1
- **Duración aproximada:** 3 minutos

Este archivo reúne el guion de exposición sobre el tema **Modelo de cómputo y sintaxis** en los lenguajes funcionales. Se explican sus principales características: inmutabilidad por defecto, operador `|>`, funciones de orden superior, pattern matching y la forma en que se escriben las expresiones funcionales, utilizando ejemplos de F#.

---

## Diapositiva 1 — Modelo de cómputo

### Guion oral

> "En los lenguajes funcionales, el modelo de cómputo se basa principalmente en el uso de funciones y en la transformación de datos. A diferencia de otros paradigmas, se busca reducir los cambios de estado y hacer que las operaciones sean más predecibles.
>
> Primero tenemos la inmutabilidad por defecto. Esto significa que, una vez creado un valor, normalmente no se modifica directamente. Por ejemplo, si tenemos una variable con el valor 10 y necesitamos trabajar con el valor 20, podemos crear un nuevo valor en lugar de modificar el anterior. Esto ayuda a evitar efectos inesperados y hace que sea más fácil seguir el comportamiento del programa."

### Ideas clave para la diapositiva

- **Modelo de cómputo:** se basa en funciones y transformación de datos.
- **Inmutabilidad:** los valores no se modifican directamente.
- **Ventaja:** evita cambios inesperados y permite un comportamiento más predecible.

### Ejemplo en F#

```fsharp
let x = 10
let y = 20
```

### Explicación breve del código

- `let`: permite declarar un valor.
- `x = 10`: crea un valor llamado `x` con el número 10.
- `y = 20`: crea otro valor independiente con el número 20.
- Los valores declarados con `let` no se reasignan directamente.

---

## Diapositiva 2 — Operador Pipe y funciones de orden superior

### Guion oral

> "Otro elemento importante es el operador pipe, representado como `|>`. Este operador permite pasar el resultado de una función directamente como entrada de otra. Por ejemplo, podemos tener 5, duplicarlo y después sumarle 10. Primero se duplica el 5, obteniendo 10, y después se suma 10, obteniendo 20. De esta manera, las operaciones se pueden leer como un flujo de izquierda a derecha.
>
> También están las de orden superior. Son funciones que pueden recibir otras funciones como parámetros o incluso devolver funciones. Esto permite reutilizar código y realizar operaciones de manera más flexible. Por ejemplo, podemos tener una función que reciba la función duplicar y un número, y después aplicar esa función al número."

### Ideas clave para la diapositiva

#### 1. Operador `|>` (Pipe)

- Conecta diferentes operaciones.
- Pasa el resultado de una función a la siguiente.
- Permite leer las operaciones de izquierda a derecha.

**Ejemplo en F#:**

```fsharp
let duplicar n = n * 2
let sumar10 n = n + 10

5 |> duplicar |> sumar10
```

**Resultado:**

```
20
```

#### 2. Funciones de orden superior

- Reciben otras funciones como parámetros.
- Pueden devolver funciones como resultado.
- Permiten reutilizar código.

**Ejemplo en F#:**

```fsharp
let duplicar n = n * 2

let aplicar funcion numero =
    funcion numero

aplicar duplicar 5
```

**Resultado:**

```
10
```

### Explicación breve del código

- `duplicar`: función que multiplica un número por 2.
- `sumar10`: función que suma 10.
- `|>`: conecta las operaciones.
- `aplicar`: recibe una función y un número como parámetros.
- `funcion numero`: ejecuta la función recibida utilizando el número proporcionado.

---

## Diapositiva 3 — Pattern Matching y sintaxis

### Guion oral

> "Finalmente tenemos el pattern matching, o coincidencia de patrones. Sirve para comparar un dato con diferentes patrones y ejecutar una acción dependiendo de cuál coincida. Por ejemplo, podemos revisar si un número es cero, uno o cualquier otro número. Es similar a utilizar un `switch`, pero en los lenguajes funcionales también puede utilizarse para analizar estructuras de datos.
>
> En cuanto a la sintaxis, los lenguajes funcionales suelen expresar las operaciones mediante funciones y expresiones. Por ejemplo, podemos escribir duplicar de x es igual a x por 2, donde tenemos una función llamada duplicar que recibe un parámetro y devuelve su resultado.
>
> El pattern matching también forma parte de esta forma de escribir programas, porque permite definir diferentes comportamientos dependiendo de los datos recibidos.
>
> En conclusión, el modelo de cómputo y la sintaxis de los lenguajes funcionales se caracterizan por trabajar con funciones, datos inmutables, composición de operaciones y patrones, buscando que el código sea más claro y predecible."

### Ideas clave para la diapositiva

#### 1. Pattern Matching (coincidencia de patrones)

- Compara un dato con diferentes patrones.
- Ejecuta una acción según el caso encontrado.
- Puede analizar estructuras de datos.

**Ejemplo en F#:**

```fsharp
let describir n =
    match n with
    | 0 -> "Cero"
    | 1 -> "Uno"
    | _ -> "Otro número"
```

**Resultados de ejemplo:**

```
describir 0 = "Cero"
describir 1 = "Uno"
describir 5 = "Otro número"
```

#### 2. Sintaxis funcional

- Las operaciones se expresan mediante funciones y expresiones.

**Ejemplo conceptual:**

```
duplicar(x) = x * 2
```

**En F# se escribe:**

```fsharp
let duplicar x = x * 2
```

### Explicación breve del código

- `match`: inicia la comparación de patrones.
- `with`: indica los casos que se van a evaluar.
- `|`: separa los diferentes patrones.
- `0` y `1`: son los valores que se comparan.
- `_`: representa cualquier otro valor.
- `let`: permite declarar una función o un valor.
- `duplicar x`: define una función que recibe el parámetro `x`.
- `x * 2`: representa la operación que realiza la función.

---

## Conclusión

El modelo de cómputo y la sintaxis de los lenguajes funcionales se caracterizan por trabajar con funciones, datos inmutables, composición de operaciones y patrones. Estos elementos permiten desarrollar programas mediante transformaciones de datos, buscando que el código sea más claro, organizado y predecible.

## Resumen de los conceptos principales

| Concepto | Función principal |
| --- | --- |
| Inmutabilidad | Evita modificar directamente los valores. |
| Operador `\|>` | Conecta operaciones y funciones. |
| Funciones de orden superior | Reciben o devuelven otras funciones. |
| Pattern matching | Compara patrones para determinar qué acción ejecutar. |
| Sintaxis funcional | Expresa operaciones mediante funciones y expresiones. |

> **Nota:** Los ejemplos de código están escritos en F# y pueden ejecutarse en F# Interactive (`dotnet fsi`). La expresión `duplicar(x) = x * 2` se presenta como notación conceptual; su equivalente en F# es `let duplicar x = x * 2`.

---

Referencias: ver [8]–[12] en la sección [Bibliografía (IEEE)](README.md#bibliograf%C3%ADa-ieee) del README del equipo.
