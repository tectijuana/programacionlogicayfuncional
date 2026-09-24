# El cálculo lambda de Alonzo Church (1936) como fundamento teórico de la programación funcional

## 1. Historia: ¿Qué es y de dónde salió?

* **El Creador:** Alonzo Church, un matemático estadounidense, lo publicó en 1936.
* **El Propósito Original:** Church intentaba resolver el *Entscheidungsproblem* (el problema de la decisión) propuesto por David Hilbert, para determinar si existe un algoritmo que pueda evaluar si cualquier afirmación matemática es verdadera o falsa.
* **La Equivalencia (Tesis de Church-Turing):** Al mismo tiempo, Alan Turing inventó su famosa "Máquina de Turing" (enfocada en hardware y estados). Church inventó el **Cálculo Lambda** (enfocado en la abstracción de software). Ambos demostraron que cualquier cosa computable por una Máquina de Turing, también puede ser calculada mediante el Cálculo Lambda.

---

## 2. Los 3 Bloques de Construcción

El cálculo lambda es extremadamente minimalista. Carece de tipos de datos primitivos (`int`, `string`), bucles (`while`, `for`) o asignaciones de memoria. Todo el sistema se construye con solo tres reglas de sintaxis:

1. **Variables:** Letras simples para representar parámetros de entrada (ej. $x, y, z$).
2. **Abstracción (Definir una función):** Se utiliza la letra griega lambda ($\lambda$) para declarar una función anónima. Consiste en el símbolo $\lambda$, el parámetro, un punto y el cuerpo de la función.
   * *Sintaxis:* $\lambda x . x$
   * *Significado:* "Una función que recibe $x$ y devuelve $x$" (conocida como la función identidad).
3. **Aplicación (Llamar a una función):** Es el acto de pasar un argumento a una función para evaluarla.
   * *Sintaxis:* $(\lambda x . x) y$
   * *Significado:* "A la función identidad, pásale el argumento $y$". El resultado de esta evaluación será $y$.

---

## 3. El Motor de Ejecución (Las Reglas de Reducción)

Dado que no hay ciclos ni variables de estado, la "ejecución" de un programa en cálculo lambda consiste en simplificar expresiones matemáticas paso a paso utilizando reglas de reducción:

* **Conversión Alfa:** Establece que el nombre de las variables ligadas no altera el significado lógico de la función, siempre y cuando se eviten colisiones.
  * *Ejemplo:* $\lambda x . x$ es lógicamente idéntica a $\lambda a . a$.
* **Reducción Beta:** Representa el cómputo o ejecución real. Consiste en sustituir todas las apariciones del parámetro en el cuerpo de la función por el argumento proporcionado.
  * *Ejemplo:* $(\lambda x . x + 2) 5 
ightarrow 5 + 2 
ightarrow 7$.
* **Conversión Eta ($\eta$):** Expresa el principio de extensionalidad, indicando que dos funciones son iguales si devuelven el mismo resultado para todos los argumentos posibles.

---

## 4. La Conexión con la Programación Funcional

El modelo matemático diseñado por Church en papel es la arquitectura fundamental sobre la que operan lenguajes modernos puramente funcionales (como Haskell) o concurrentes (como Erlang).

Las reglas del cálculo lambda establecieron los principios básicos de este paradigma de programación:

| Concepto en Cálculo Lambda (1936) | Concepto en Programación Funcional Moderna |
| :--- | :--- |
| **Abstracción pura** | **Funciones de Primera Clase y de Orden Superior:** Las funciones pueden almacenarse, pasarse como parámetros a otras funciones o ser retornadas como resultados. |
| **Evaluación sin memoria** | **Inmutabilidad y Ausencia de Estado:** Evaluar una expresión no modifica variables globales. Se eliminan los "efectos secundarios", haciendo que el código sea predecible y altamente concurrente. |
| **Un parámetro estricto** | **Currificación (Currying):** Funciones que teóricamente toman múltiples argumentos se modelan como una cadena de funciones anidadas de un solo parámetro. Ej: $\lambda x . (\lambda y . x + y)$. |

> **Conclusión:** El cálculo lambda demostró matemáticamente que no se requiere un lenguaje complejo con múltiples estructuras de control iterativas para programar sistemas completos; la computación universal puede lograrse puramente mediante la definición y aplicación de funciones.
