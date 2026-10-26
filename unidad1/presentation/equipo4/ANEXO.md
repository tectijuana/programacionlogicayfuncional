# Anexo: Prompts y consultas realizadas a la IA para la presentación de Elixir

## Introducción

El presente anexo recopila los principales prompts y consultas realizados a una herramienta de inteligencia artificial durante la preparación de la presentación sobre el lenguaje de programación **Elixir**. Su propósito es documentar las preguntas utilizadas para profundizar en los conceptos abordados, así como las respuestas obtenidas para facilitar la comprensión de los temas y apoyar la elaboración del material de exposición.

Las consultas se enfocaron principalmente en comprender el entorno interactivo `iex`, el concepto de REPL y el funcionamiento de dos fragmentos de código utilizados en la demostración práctica. Para facilitar su revisión, cada apartado presenta el prompt correspondiente seguido de la respuesta proporcionada por la IA.

---

## 1. Explicación de `iex` y del concepto de REPL

### Prompt

Explica qué es `iex` en Elixir y desarrolla el significado del concepto REPL. Describe cómo funciona este entorno interactivo, para qué se utiliza y en qué se diferencia de ejecutar un programa desde un archivo. Utiliza una explicación técnica y otra sencilla, con ejemplos que faciliten la comprensión.

### Respuesta de la IA

## Introducción — `iex`

**Versión técnica:**

`iex` significa *Interactive Elixir*. Es el REPL de Elixir, término que proviene de *Read-Eval-Print Loop*, es decir, «Leer, Evaluar, Imprimir y Repetir». Es un entorno que funciona en un ciclo constante: lee lo que se escribe, evalúa o ejecuta la expresión, imprime el resultado en pantalla y vuelve a esperar la siguiente entrada. Todo esto permite probar código sin necesidad de guardarlo primero en un archivo ni compilarlo por separado.

**Versión sencilla:**

Es como tener una conversación con la computadora. Se escribe una línea, se presiona Enter y, al instante, se obtiene el resultado. No es necesario guardar un archivo ni ejecutar un programa por separado.

Por ejemplo, al escribir:

```elixir
2 + 2
```

El entorno muestra:

```elixir
4
```

Esto funciona de manera similar a una calculadora, pero permite ejecutar expresiones y probar instrucciones del lenguaje Elixir.

Por esa razón, `iex` se utiliza para practicar, experimentar con instrucciones, comprobar resultados y corregir errores de manera rápida, sin tener que reiniciar un programa completo cada vez.

Al abrirlo, puede aparecer un indicador como `iex(1)>`. El número entre paréntesis identifica la entrada dentro de la sesión interactiva.

---

## 2. Explicación de los códigos utilizados en la demostración

### Prompt

Explica detalladamente los siguientes dos fragmentos de código de Elixir. Desglosa cada instrucción y operador, explica su función mediante una descripción técnica y otra sencilla, e indica cómo se ejecuta cada expresión y cuál es su resultado. Mantén las explicaciones claras y utiliza ejemplos cuando sea necesario.

**Código 1:**

```elixir
Enum.each(1..10, &IO.puts/1)
```

**Código 2:**

```elixir
1..10 |> Enum.filter(&(rem(&1, 2) == 0)) |> Enum.map(&(&1 * &1))
```

### Respuesta de la IA

## Código 1: `Enum.each(1..10, &IO.puts/1)`

### Parte 1 — `1..10`

**Versión técnica:**

Es un `Range`, una estructura que representa un intervalo de números. En este caso, comprende los valores del 1 al 10.

**Versión sencilla:**

Es una forma corta de decir «todos los números del 1 al 10», sin tener que escribirlos individualmente como `[1,2,3,4,5,6,7,8,9,10]`.

### Parte 2 — `Enum.each`

**Versión técnica:**

Es una función de orden superior que recibe una colección y una función. Aplica esa función a cada elemento de la colección, uno por uno, sin crear una colección transformada como resultado. Se utiliza para ejecutar una acción por cada elemento.

**Versión sencilla:**

Es una instrucción que dice: «Toma esta colección de números y haz algo con cada uno de ellos». Es como tener diez papeles y leerlos uno por uno en voz alta.

### Parte 3 — `&IO.puts/1`

**Versión técnica:**

Es una referencia abreviada a la función `IO.puts`, que se encarga de imprimir información en pantalla. El operador `&` permite capturar una función y utilizarla como argumento de otra función. El `/1` indica que `IO.puts` recibe un argumento.

**Versión sencilla:**

Indica qué se debe hacer con cada número: imprimirlo en pantalla. El símbolo `&` permite utilizar la función sin tener que escribir una función anónima completa.

### Junta todo — la línea completa

**Versión técnica:**

`Enum.each` recorre el rango `1..10` e invoca `IO.puts` para cada número. La operación produce el efecto de imprimir los valores en pantalla y, al terminar, devuelve el átomo `:ok`.

**Versión sencilla:**

«Toma los números del 1 al 10 e imprime cada uno en pantalla».

El resultado visible es:

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
```

Cada número aparece en una línea diferente.

---

## Código 2: Filtrar números pares y elevarlos al cuadrado

```elixir
1..10 |> Enum.filter(&(rem(&1, 2) == 0)) |> Enum.map(&(&1 * &1))
```

### Parte 1 — `1..10`

**Versión técnica:**

Es un `Range` que representa el intervalo de números comprendido entre el 1 y el 10.

**Versión sencilla:**

Representa todos los números del 1 al 10.

### Parte 2 — `|>` (primer operador pipe)

**Versión técnica:**

Es el operador pipe de Elixir. Toma el resultado de la expresión situada a su izquierda y lo pasa como primer argumento a la función situada a su derecha.

**Versión sencilla:**

Es como una flecha que indica: «Ahora utiliza este resultado para realizar la siguiente operación».

### Parte 3 — `Enum.filter(&(rem(&1, 2) == 0))`

**Versión técnica:**

`Enum.filter` recorre una colección y conserva únicamente los elementos que cumplen una condición. En este caso, `rem(&1, 2)` calcula el residuo de dividir cada número entre 2. La comparación `== 0` comprueba si ese residuo es cero, condición que cumplen los números pares.

El símbolo `&1` representa el argumento recibido por la función anónima abreviada.

**Versión sencilla:**

Funciona como un colador: revisa todos los números y deja pasar únicamente los pares. Los impares se descartan.

El resultado del filtro es:

```elixir
[2, 4, 6, 8, 10]
```

### Parte 4 — `|>` (segundo operador pipe)

**Versión técnica:**

Pasa el resultado obtenido por `Enum.filter` como primer argumento de la siguiente función, `Enum.map`.

**Versión sencilla:**

Indica que se deben tomar los números que pasaron el filtro y continuar con la siguiente operación.

### Parte 5 — `Enum.map(&(&1 * &1))`

**Versión técnica:**

`Enum.map` aplica una función a cada elemento de una colección y devuelve una nueva colección con los resultados. En este caso, la expresión `&1 * &1` multiplica cada número por sí mismo, es decir, calcula su cuadrado.

**Versión sencilla:**

Toma cada número par y lo multiplica por sí mismo. Por ejemplo, el número 4 se convierte en 16, porque \(4 \times 4 = 16\).

### Junta todo — la línea completa

**Versión técnica:**

La expresión encadena tres operaciones mediante el operador pipe: representa el rango del 1 al 10, filtra los números para conservar únicamente los pares y aplica una transformación que eleva cada elemento al cuadrado. El resultado es la lista `[4, 16, 36, 64, 100]`.

**Versión sencilla:**

«Toma los números del 1 al 10, quédate solo con los pares y después eleva cada uno al cuadrado».

El proceso se puede resumir así:

```text
Números iniciales:
1, 2, 3, 4, 5, 6, 7, 8, 9, 10

Después de filtrar los pares:
2, 4, 6, 8, 10

Después de elevarlos al cuadrado:
4, 16, 36, 64, 100
```

El resultado final en Elixir es:

```elixir
[4, 16, 36, 64, 100]
```

---

## Conclusión del anexo

Las consultas realizadas a la inteligencia artificial permitieron profundizar en el funcionamiento del entorno interactivo `iex`, comprender el concepto de REPL y analizar las operaciones utilizadas en la demostración práctica de Elixir. Las respuestas se organizaron mediante explicaciones técnicas y sencillas para facilitar el estudio de los conceptos y apoyar la preparación de la exposición.
