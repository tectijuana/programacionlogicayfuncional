# Equipo 8 — F#

## Guion para la demo en vivo y el caso real

**Integrante responsable:** Gael Nolasco Ayala  
**Exposición:** Introducción a lenguajes funcionales · Unidad 1

Este archivo reúne el guion para las dos partes asignadas: la ejecución de ejemplos de F# y el caso real de Jet.com. Las referencias están en la sección Bibliografía (IEEE) del README del equipo.

## Diapositiva 1 — Ejecución en vivo de F#

### Guion oral

> “Voy a ejecutar dos expresiones en `dotnet fsi`, que es el entorno interactivo de F#. En la primera, `[1..10]` crea una lista con los números del 1 al 10. El operador `|>` pasa esa lista a `List.iter`, y `printfn "%d"` imprime cada número en una línea. `List.iter` realiza la acción de imprimir, pero no genera una lista como resultado; por eso F# muestra `val it: unit = ()`. `unit` indica que la expresión no devuelve un valor útil, y `()` es el valor de ese tipo.
>
> “En el segundo ejemplo, `List.filter` conserva solo los números pares. La expresión `fun n -> n % 2 = 0` es una función anónima: recibe `n` y devuelve verdadero cuando el residuo de dividirlo entre 2 es cero. Después, `List.map` aplica `fun n -> n * n` a cada número que quedó, es decir, calcula su cuadrado. El resultado es `[4; 16; 36; 64; 100]`, cuyo tipo es `int list`: una lista de enteros. FSI llama `it` al resultado porque no le asignamos un nombre con `let`.”

### Comandos exactos

Inicia F# Interactive desde la terminal:

```bash
dotnet fsi
```

En el indicador de FSI, ejecuta cada expresión:

```fsharp
[1..10] |> List.iter (printfn "%d");;
[1..10] |> List.filter (fun n -> n % 2 = 0) |> List.map (fun n -> n * n);;
```

### Salida esperada

```text
1
2
3
4
5
6
7
8
9
10
val it: unit = ()
val it: int list = [4; 16; 36; 64; 100]
```

### Explicación breve del código

- `[1..10]`: crea la lista de enteros del 1 al 10.
- `|>`: pasa el resultado de la izquierda como entrada a la función de la derecha; permite leer el flujo de operaciones de izquierda a derecha.
- `List.iter`: aplica una acción a cada elemento; aquí imprime cada entero y devuelve `unit`.
- `fun n -> ...`: define una función anónima que recibe `n`.
- `List.filter`: conserva los elementos para los que la condición devuelve `true`.
- `n % 2 = 0`: comprueba si `n` es par.
- `List.map`: transforma cada elemento de la lista; aquí lo eleva al cuadrado mediante `n * n`.
- `int list`: tipo de una lista cuyos elementos son enteros.
- `it`: nombre automático que FSI usa para mostrar el valor de una expresión sin nombre.

**Para salir de FSI:** escribe `#quit;;`.

### Grabación de respaldo

La grabación del demo en asciinema está disponible aquí: [Ver demostración en asciinema](https://asciinema.org/a/tImzCXKi1FgN3pfu).

## Diapositiva 2 — Caso real: Jet.com y F#

### Guion oral (aprox. 1 minuto)

> “Un caso real documentado de F# es Jet.com, una plataforma de comercio electrónico que Walmart adquirió en 2016. Jet tenía que decidir cómo surtir los productos de un carrito desde distintos comerciantes o almacenes. La mejor opción no dependía solo del precio de cada producto: también había que considerar los costos de envío y las comisiones para reducir el costo total del pedido.
>
> “En el artículo técnico de NVIDIA, el equipo de Jet describe un motor de selección de comerciantes implementado con F# y CUDA para aprovechar GPU en algunos cálculos. El espacio de búsqueda podía crecer muchísimo: para un carrito real de 11 productos, el artículo reporta más de 70 billones de combinaciones posibles. Revisarlas todas se estimó en 8.6 años de búsqueda en CPU o 11 días en GPU, demasiado para responder en tiempo real. Para los casos grandes, el equipo también describe un algoritmo genético que busca una solución aproximada; el sistema elegía entre métodos según la complejidad del carrito y la carga. Este caso muestra F# aplicado a optimización y servicios de comercio electrónico, no solo a ejercicios académicos.”

### Ideas clave para la diapositiva

- **Problema:** elegir comerciantes y almacenes para surtir un carrito al menor costo total, considerando envío y comisiones.
- **Uso de F#:** implementación de algoritmos de selección y optimización dentro del ecosistema .NET.
- **Aceleración:** F# con CUDA/AleaGPU para ejecutar ciertos cálculos en GPU.
- **Escala del problema:** el artículo de NVIDIA presenta un carrito de 11 productos con 70,442,237,952,000 combinaciones (aproximadamente 70.4 billones en escala larga inglesa / 70.4 trillion).
- **Respuesta al tamaño:** búsqueda exhaustiva cuando es viable y algoritmo genético para encontrar una solución aproximada en espacios demasiado grandes.
- **Contexto empresarial:** Walmart completó la adquisición de Jet.com en 2016.

---

Referencias: ver [16]–[18] en la sección [Bibliografía (IEEE)](README.md#bibliograf%C3%ADa-ieee) del README del equipo.
