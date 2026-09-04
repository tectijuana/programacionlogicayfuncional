---
title: "Proyecto de Investigación --- Programación Lógica y Funcional 2026 \"B\""
subtitle: "Bloque 1: Programación Funcional (nivel introductorio) --- 40 temas de investigación y rúbrica de 5 categorías"
author: "TecNM Campus Tijuana --- Ingeniería en Sistemas Computacionales (ISC-2006)"
date: "Agosto 2026"
lang: es
geometry: "a4paper,margin=2.4cm"
fontsize: 11pt
---

# Efectos secundarios: qué son y por qué la programación funcional busca controlarlos

## Introducción

En programación, una función no siempre se limita a recibir datos y devolver un resultado. También puede modificar una variable global, escribir un archivo, consultar una base de datos o mostrar información en pantalla. Estas interacciones se denominan **efectos secundarios**.

Los efectos son necesarios para que un programa se comunique con el mundo exterior, pero pueden introducir dependencias difíciles de observar. Por ello, la programación funcional busca separarlos y mantenerlos en zonas controladas, mientras la lógica principal se construye con funciones puras. Haskell, por ejemplo, separa las acciones de entrada y salida de su núcleo funcional [1].

## 1. ¿Qué es un efecto secundario?

Un efecto secundario es un cambio observable que ocurre durante la ejecución de una función, además de producir su valor principal. La operación `2 + 3` únicamente devuelve `5`. En cambio, una función que calcula esa suma y también incrementa una variable global produce dos resultados: el valor calculado y una modificación en el estado del programa.

Algunos efectos secundarios comunes son:

- Modificar variables globales u objetos compartidos.
- Leer o escribir archivos.
- Imprimir en la consola o leer del teclado.
- Consultar o actualizar bases de datos.
- Enviar solicitudes por red.
- Consultar la fecha, la hora o números aleatorios.
- Lanzar excepciones.

Estos efectos no son necesariamente errores. Guardar una compra o mostrar una respuesta al usuario son acciones indispensables. El problema aparece cuando el efecto está mezclado con la lógica y no queda claro qué modifica, de qué recursos depende o en qué orden debe ejecutarse.

## 2. Funciones puras y transparencia referencial

Una **función pura** cumple dos condiciones: siempre produce el mismo resultado para las mismas entradas y no modifica información fuera de su alcance [3]. Por ejemplo, `doble(4)` puede sustituirse por `8` sin cambiar el comportamiento del programa. Esta propiedad se llama **transparencia referencial**.

```text
doble(4) + doble(4)  ≡  8 + 8
```

Una función que consulta la hora puede devolver resultados diferentes en cada llamada. Otra que incrementa un contador global modifica el programa incluso si devuelve siempre el mismo número. Ninguna de las dos es pura.

La pureza facilita el razonamiento: para comprender una función pura basta conocer sus parámetros y su resultado. En una función con efectos también se debe investigar el estado previo, el orden de ejecución y los recursos externos involucrados.

## 3. Ejemplo ejecutable en Python

Python no es un lenguaje funcional puro, pero permite aplicar este estilo. En la primera versión se mezclan el cálculo, el estado global y la salida:

```python
descuento = 0.10

def cobrar(precio):
    total = precio * (1 - descuento)
    print(f"Total: {total:.2f} pesos")
    return total

cobrar(100)
```

La función `cobrar` depende de una variable externa y escribe en la consola. Si otro fragmento modifica `descuento`, el resultado será diferente aunque el argumento continúe siendo `100`.

Una alternativa es separar el cálculo puro del efecto:

```python
def calcular_total(precio, descuento):
    return precio * (1 - descuento)

def mostrar_total(total):
    print(f"Total: {total:.2f} pesos")

total = calcular_total(100, 0.10)
mostrar_total(total)

assert calcular_total(100, 0.10) == 90.0
```

Ahora `calcular_total` recibe todas sus dependencias como argumentos y puede probarse directamente. `mostrar_total` conserva el efecto de salida, pero está identificado y separado. Esta refactorización coincide con la recomendación de extraer funciones puras para reducir dependencias externas [3].

## 4. ¿Por qué controlar los efectos secundarios?

### 4.1 Predictibilidad

Una función pura se comporta como una relación matemática: la misma entrada genera el mismo resultado. Esto evita resultados inesperados causados por variables globales, configuraciones ocultas o cambios en el orden de ejecución.

### 4.2 Pruebas y depuración

Las funciones puras pueden probarse sin preparar archivos, conexiones de red, relojes o bases de datos. Microsoft indica que pueden evaluarse de forma aislada utilizando casos normales y casos límite [4].

### 4.3 Reutilización y composición

Las funciones pequeñas pueden combinarse con mayor seguridad porque intercambian valores explícitos y no modifican información externa.

### 4.4 Concurrencia más segura

Dos operaciones puras no compiten por modificar una misma variable. Esto reduce las condiciones de carrera, aunque no significa que cualquier programa funcional sea automáticamente concurrente.

### 4.5 Optimización

La transparencia referencial puede permitir almacenar resultados, eliminar cálculos que no se utilizan o evaluar expresiones independientes en paralelo. Scala incluso muestra una advertencia cuando una expresión pura aparece en una posición donde su resultado es descartado [5].

## 5. Formas de controlar los efectos

### 5.1 Inmutabilidad

En lugar de modificar una estructura existente, se crea un nuevo valor que contiene los cambios. De esta manera, el flujo de datos es más visible y se conserva el estado anterior.

### 5.2 Dependencias explícitas

Elementos como el reloj, la configuración o el acceso a datos pueden recibirse como argumentos. Durante una prueba pueden sustituirse por valores conocidos y controlados.

### 5.3 Núcleo funcional y borde imperativo

La validación, el cálculo y la transformación de los datos se colocan en un núcleo puro. La consola, la interfaz, la red y la persistencia permanecen en los bordes del sistema. El borde obtiene los datos, llama al núcleo y ejecuta las acciones necesarias.

### 5.4 Tipos que representan efectos

Haskell utiliza el tipo `IO` para señalar acciones relacionadas con la entrada y salida [1], [6]:

```haskell
saludar :: String -> String
saludar nombre = "Hola, " ++ nombre

main :: IO ()
main = do
  nombre <- getLine
  putStrLn (saludar nombre)
```

La función `saludar` representa una transformación pura. Las operaciones `getLine` y `putStrLn` permanecen en `main`, donde el tipo `IO` hace visible la interacción con el exterior.

## 6. Comparación

| Aspecto | Función pura | Función con efectos |
|---|---|---|
| Dependencias | Parámetros explícitos | Puede depender de estado, red o archivos |
| Resultado | Misma entrada, misma salida | Puede variar con la misma entrada |
| Estado externo | No lo modifica | Puede leerlo o modificarlo |
| Pruebas | Aisladas y directas | Requieren preparación o integración |
| Uso común | Cálculo, validación y transformación | Entrada, salida y persistencia |

## 7. Análisis crítico

Controlar los efectos secundarios también tiene costos. Dividir demasiado el código puede dificultar la lectura y algunas abstracciones funcionales requieren aprendizaje adicional. Además, un programa no se vuelve correcto únicamente por utilizar funciones puras: todavía puede contener errores de lógica, seguridad o requisitos.

El objetivo tampoco es prohibir `print`, las bases de datos o la comunicación por red. Una aplicación útil necesita interactuar con el exterior. La pregunta adecuada es: **¿el efecto es necesario, está identificado y puede mantenerse separado de la lógica principal?**

Haskell obliga a distinguir los efectos mediante `IO`, mientras que lenguajes como Scala y Python permiten aplicar esta separación de manera gradual [2]. Esto demuestra que los principios funcionales también pueden utilizarse en lenguajes que no son completamente funcionales.

## Conclusiones

Los efectos secundarios son cambios o interacciones observables adicionales al valor devuelto por una función. Permiten guardar datos, comunicarse por red y presentar resultados, pero también crean dependencias relacionadas con el estado y el orden de ejecución.

La programación funcional busca controlarlos para conseguir mayor predictibilidad, facilidad de prueba y menor interferencia entre operaciones. Su objetivo no es eliminar toda interacción, sino mantener un núcleo de funciones puras y concentrar los efectos en límites claros. De esta forma resulta más sencillo comprender qué calcula el sistema y en qué partes modifica el mundo exterior.

## Bibliografía

[1] P. Hudak, J. Peterson y J. Fasel, “Input/Output,” en *A Gentle Introduction to Haskell, Version 98*. Haskell.org, 2000. [En línea]. Disponible en: https://www.haskell.org/tutorial/io.html. [Consultado: 1-sep-2026].

[2] Scala Documentation, “Pure Functions,” *Scala Book*. [En línea]. Disponible en: https://docs.scala-lang.org/overviews/scala-book/pure-functions.html. [Consultado: 1-sep-2026].

[3] Microsoft, “Refactor into pure functions,” *Microsoft Learn*, 15-sep-2021. [En línea]. Disponible en: https://learn.microsoft.com/en-us/dotnet/standard/linq/refactor-pure-functions. [Consultado: 1-sep-2026].

[4] Microsoft, “Functional programming vs. imperative programming,” *Microsoft Learn*, 15-sep-2021. [En línea]. Disponible en: https://learn.microsoft.com/en-us/dotnet/standard/linq/functional-vs-imperative-programming. [Consultado: 1-sep-2026].

[5] Scala Documentation, “E129: Pure Expression In Statement Position,” *Scala 3 Reference*. [En línea]. Disponible en: https://docs.scala-lang.org/scala3/reference/error-codes/E129.html. [Consultado: 1-sep-2026].

[6] P. Hudak, J. Peterson y J. Fasel, “About Monads,” en *A Gentle Introduction to Haskell, Version 98*. Haskell.org, 2000. [En línea]. Disponible en: https://www.haskell.org/tutorial/monads.html. [Consultado: 1-sep-2026].

---
