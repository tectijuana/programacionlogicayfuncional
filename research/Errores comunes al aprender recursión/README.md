# Errores comunes al aprender recursión: falta de caso base y desbordamiento de pila

**Asignatura:** Programación lógica y funcional - 04:00 pm  
**Alumno:** Stephanie Ariana Medrano Vargas - 23212013

---
 
## Tabla de Contenidos
 
1. [Introducción](#introducción)
2. [Desarrollo técnico](#desarrollo-técnico)
   - 2.1 [Caso base, caso recursivo y medida de progreso](#1-caso-base-caso-recursivo-y-medida-de-progreso)
   - 2.2 [Desbordamiento de pila y trabajo pendiente](#2-desbordamiento-de-pila-y-trabajo-pendiente)
   - 2.3 [Ejemplo ejecutable y manejo explícito del error](#3-ejemplo-ejecutable-y-manejo-explícito-del-error)
   - 2.4 [Estrategia de revisión antes de ejecutar](#4-estrategia-de-revisión-antes-de-ejecutar)
3. [Conclusiones](#conclusiones)
4. [Bibliografía](#bibliografía)

**Archivos asociados:**
- [`errores_recursion.exs`](errores_recursion.exs) — Ejemplos ejecutables en Elixir
- [`anexo.md`](anexo.md) — Información adicional
---

## Introducción

La recursión resuelve un problema definiéndolo en términos de una versión más
pequeña del mismo problema. Es una herramienta natural en programación
funcional porque las listas inmutables se procesan separando su primer elemento
de la lista restante y porque una función puede expresarse mediante casos. Sin
embargo, una definición recursiva no es correcta solo por contener una llamada
a sí misma. Debe indicar cuándo detenerse, debe acercarse de forma demostrable a
esa detención y debe mantener un consumo de recursos aceptable. Los errores más
frecuentes al comenzar son omitir el caso base, no reducir el problema y asumir
que toda recursión usa memoria constante.

Este trabajo analiza esos errores con Elixir. La elección permite distinguir dos
ideas que a veces se confunden: **terminación** y **recursión de cola**. Una
función puede terminar y aun así acumular trabajo pendiente; otra puede estar
en posición de cola y no terminar nunca. Por ello, la primera propiedad que se
debe revisar es la corrección de los casos y la segunda es la forma de la llamada
recursiva. El objetivo no es evitar la recursión, sino diseñarla con una medida
de progreso y con contratos que hagan visibles los casos límite.

## Desarrollo técnico

### 1. Caso base, caso recursivo y medida de progreso

Un **caso base** produce una respuesta sin invocar de nuevo a la función. Un
**caso recursivo** procesa parte de la entrada y llama a la función con una
entrada estrictamente menor. Para `suma/1`, el caso base es la lista vacía y el
caso recursivo elimina una cabeza. La longitud de la lista es la medida de
progreso: comienza en `n` y disminuye en uno en cada llamada, por lo que solo
pueden ocurrir `n` llamadas recursivas antes de llegar a `[]`.

```elixir
def suma([]), do: 0
def suma([cabeza | cola]), do: cabeza + suma(cola)
```

Omitir la primera cláusula es un error de cobertura: `suma([])` ya no tiene una
respuesta definida. En Elixir, si una llamada no coincide con ninguna cláusula,
la ejecución termina con `FunctionClauseError`; no es una señal de que el
lenguaje haya encontrado automáticamente un caso base. En listas, también es
incorrecto tratar una cabeza como si fuera siempre una lista no vacía: antes de
usar el patrón `[cabeza | cola]` hay que decidir qué significa `[]` para el
problema.

No toda falta de terminación proviene de omitir una cláusula. Una función como
`cuenta(n) = 1 + cuenta(n)` tiene una cláusula para cualquier entero, pero no
reduce `n`. La llamada repite el mismo estado. Para datos numéricos, una medida
puede ser la distancia a cero; para listas, su longitud; para árboles, su
altura o cantidad de nodos. Escribir esa medida en un comentario o probarla con
casos pequeños es una forma práctica de convertir la intuición de “va avanzando”
en una revisión concreta.

### 2. Desbordamiento de pila y trabajo pendiente

En una versión no terminal de `suma/1`, cada llamada debe esperar el resultado
de `suma(cola)` para ejecutar la suma. Conceptualmente quedan pendientes las
operaciones `cabeza + ...`; una entrada muy profunda puede agotar el espacio de
ejecución disponible y provocar un fallo por profundidad o por memoria. Ese
problema es distinto de una recursión infinita: en el primer caso la entrada es
finita y la función tiene un caso base, pero el modo de evaluación conserva
demasiado contexto.

La alternativa es usar un **acumulador**. En `suma_cola/2`, el resultado parcial
se calcula antes de la siguiente llamada. La llamada recursiva es la última
operación de su cláusula; por ello está en posición de cola. BEAM, la máquina
virtual de Erlang que ejecuta Elixir, puede reutilizar el marco de ejecución de
una llamada de cola. Así, este recorrido no necesita conservar una cadena de
sumas pendientes. La optimización no corrige una función sin caso base: una
llamada de cola que no reduce su entrada sigue siendo un ciclo infinito.

### 3. Ejemplo ejecutable y manejo explícito del error

El archivo [`errores_recursion.exs`](errores_recursion.exs) contiene una versión
directa, una versión de cola y una división de cada elemento que devuelve
`{:error, :division_por_cero}` si el divisor es cero. El patrón evita iniciar el
recorrido cuando el contrato no puede cumplirse. También se incluye, sin
ejecutarla, una función defectuosa que ilustra la cláusula base ausente. Dejarla
sin invocarla permite que el programa sea ejecutable sin convertir el error
didáctico en un fallo de la demostración.

```bash
cd "research/Errores comunes al aprender recursión"
elixir errores_recursion.exs
```

La salida esperada verifica que ambas sumas dan `15`, que la lista invertida se
reconstruye correctamente y que la división por cero se representa como dato.
El ejemplo no usa `spawn`: el tema no requiere concurrencia y así respeta la
regla del curso de no crear procesos Erlang sin supervisión OTP.

### 4. Estrategia de revisión antes de ejecutar

Una lista breve previene la mayoría de los fallos iniciales:

1. Enumerar las formas de la entrada, incluido el vacío, cero, negativos y
   valores inválidos.
2. Asociar a cada forma un resultado o un error explícito; no dejar que una
   coincidencia incompleta decida accidentalmente el contrato.
3. Identificar una medida entera no negativa que disminuya en cada llamada.
4. Preguntar si queda trabajo después de la llamada recursiva. Si lo hay y la
   entrada puede ser grande, considerar un acumulador, una función de biblioteca
   apropiada o una estructura iterativa.
5. Probar primero los límites (`[]`, un elemento, cero) y después una entrada
   grande con límites de recursos razonables.

Esta estrategia también evita un error conceptual: usar recursión de cola solo
porque “es más rápida”. La versión directa puede ser más legible y suficiente
para una entrada pequeña; la elección depende de la profundidad esperada y de
si la operación puede expresarse con un acumulador sin ocultar el significado.

## Conclusiones

La recursión confiable requiere una definición completa, no únicamente una
llamada a la misma función. El caso base define el resultado de la entrada
mínima; la medida de progreso justifica que la ejecución llegará a él; y la
posición de cola ayuda a controlar el recurso usado durante recorridos profundos.
Son tres preguntas separadas: “¿qué ocurre al terminar?”, “¿por qué termina?” y
“¿cuánto contexto conserva mientras avanza?”. Separarlas permite diagnosticar
con precisión una coincidencia de patrones incompleta, una recursión infinita o
un desbordamiento de recursos. Mi conclusión es que el mejor hábito al aprender
recursión es escribir primero el caso límite y la medida de progreso, y solo
después la llamada recursiva.

## Bibliografía

[1] J. W. Backus, “Can Programming Be Liberated from the von Neumann Style? A Functional Style and Its Algebra of Programs,” *Communications of the ACM*, vol. 21, no. 8, pp. 613–641, Aug. 1978, doi: 10.1145/359576.359579.

[2] J. Armstrong, *Programming Erlang: Software for a Concurrent World*, 2nd ed. Raleigh, NC, USA: Pragmatic Bookshelf, 2013.

[3] The Elixir Team, “Recursion,” *Elixir School*, 2026. [Online]. Available: https://elixirschool.com/en/lessons/basics/recursion. [Accessed: Aug. 31, 2026].

[4] Erlang/OTP Documentation Team, “Efficiency Guide: Functions,” *Erlang/OTP System Documentation*, 2026. [Online]. Available: https://www.erlang.org/doc/system/eff_guide_functions.html. [Accessed: Aug. 31, 2026].

[5] J. Hughes, “Why Functional Programming Matters,” *The Computer Journal*, vol. 32, no. 2, pp. 98–107, 1989, doi: 10.1093/comjnl/32.2.98.
