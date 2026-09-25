# De ISWIM a ML: la línea que llevó a los lenguajes funcionales tipados

> **Materia:** Programación Lógica y Funcional
> **Tema:** De ISWIM a ML: la línea que llevó a los lenguajes funcionales tipados
> **Lenguajes estudiados:** ISWIM y ML

---

## Índice

* [1. ISWIM](#1-iswim)
* [2. Características principales de ISWIM](#2-características-principales-de-iswim)
* [3. Ventajas y desventajas de ISWIM](#3-ventajas-y-desventajas-de-iswim)
* [4. El camino hacia ML](#4-el-camino-hacia-ml)
* [5. ML](#5-ml)
* [6. Características principales de ML](#6-características-principales-de-ml)
* [7. Inferencia de tipos](#7-inferencia-de-tipos)
* [8. Ventajas y desventajas de ML](#8-ventajas-y-desventajas-de-ml)
* [9. De ISWIM a los lenguajes funcionales tipados](#9-de-iswim-a-los-lenguajes-funcionales-tipados)
* [10. Comparación entre ISWIM y ML](#10-comparación-entre-iswim-y-ml)
* [11. Relación entre ISWIM y ML](#11-relación-entre-iswim-y-ml)
* [12. Conclusión](#12-conclusión)
* [13. Referencias bibliográficas](#13-referencias-bibliográficas)

---

# 1. ISWIM

**ISWIM** (*If You See What I Mean*) es un lenguaje de programación abstracto ideado por **Peter J. Landin** y presentado por primera vez en **1966**, dentro de un artículo publicado en la revista *Communications of the ACM*.

El nombre ISWIM significa **"If You See What I Mean"** ("Si ves lo que quiero decir").

Aunque nunca fue implementado como un lenguaje funcional de uso general, ISWIM tuvo una profunda influencia en el desarrollo posterior de lenguajes de **programación funcional**, entre ellos **SASL, ML, Haskell y Miranda**.

ISWIM es especialmente importante porque permitió establecer una base conceptual para el desarrollo de lenguajes funcionales posteriores.

---

# 2. Características principales de ISWIM

ISWIM introduce un núcleo funcional basado en el **cálculo lambda**, utilizando una sintaxis simple y clara.

Entre sus principales características se encuentran:

* **Ámbito léxico (*lexical scope*):** permite controlar con precisión el alcance de las variables.
* **Expresiones como valores:** cada expresión produce un valor, de manera similar a lo que ocurre en lenguajes como Haskell y ML.
* **Fundamentos del cálculo lambda:** proporciona una base matemática para la definición y aplicación de funciones.
* **Separación entre sintaxis y semántica:** permite diseñar y estudiar el lenguaje de manera más modular.
* **Notación matemática:** facilita la investigación y comprensión de los conceptos de programación funcional.

Por ejemplo, una función para calcular el cuadrado de un número podría escribirse mediante una notación cercana a la utilizada en álgebra:

```text
square x = x * x
```

La estructura de ISWIM permitió estudiar conceptos de programación funcional de una manera clara y formal, influyendo posteriormente en el diseño de otros lenguajes.

---

# 3. Ventajas y desventajas de ISWIM

## Ventajas

* Su **simplicidad y claridad sintáctica** sirvieron como modelo para lenguajes posteriores.
* Introdujo conceptos importantes como el **ámbito léxico** y la **evaluación perezosa**, que posteriormente fueron fundamentales en la programación funcional.
* Facilitó la **enseñanza y comprensión de los fundamentos de la programación funcional**.
* Su estructura permitió estudiar la relación entre la **sintaxis y la semántica** de un lenguaje.

## Desventajas

* No llegó a ser implementado como un lenguaje práctico de uso general.
* Carece de herramientas y documentación destinadas al desarrollo de aplicaciones reales.
* Su carácter abstracto puede dificultar su comprensión para quienes buscan ejemplos concretos de aplicación.

---

# 4. El camino hacia ML

Una de las principales líneas de evolución derivadas de las ideas de ISWIM condujo al desarrollo de **ML**.

**Robin Milner**, mientras trabajaba en el sistema de demostración automática **LCF**, desarrolló un lenguaje que permitía describir estrategias de demostración y procedimientos de desarrollo. Este lenguaje recibió inicialmente el nombre de **ML**.

ML heredó varias ideas fundamentales de ISWIM, entre ellas:

* Funciones de orden superior.
* Ámbito léxico.
* Uso de expresiones.
* Fundamentos de la programación funcional.

Sin embargo, ML incorporó una innovación especialmente importante: un **sistema de tipos estático con inferencia de tipos polimórfica**.

Esta característica marcó una diferencia importante respecto a los lenguajes funcionales anteriores, ya que permitió combinar la expresividad de la programación funcional con la seguridad proporcionada por el tipado estático.

---

# 5. ML

**ML** (*Meta Language*) es un lenguaje de programación funcional de propósito general desarrollado por **Robin Milner y su equipo** a principios de la década de 1970 en la **Universidad de Edimburgo**.

Su sintaxis está inspirada en ISWIM, lo que le proporciona una estructura clara y relativamente sencilla.

El nombre **Meta Language** se debe a que su objetivo inicial era servir como lenguaje para desarrollar tácticas de demostración dentro del sistema de teoremas **LCF**.

Con el paso del tiempo, ML se expandió y fue adaptado para diferentes ámbitos académicos e industriales.

---

# 6. Características principales de ML

| Característica                  | Descripción                                                                      |
| ------------------------------- | -------------------------------------------------------------------------------- |
| **Tipado estático**             | Los errores relacionados con los tipos pueden detectarse durante la compilación. |
| **Inferencia de tipos**         | El compilador puede deducir automáticamente el tipo de muchas expresiones.       |
| **Funciones de orden superior** | Las funciones pueden recibir y retornar otras funciones.                         |
| **Patrones de coincidencia**    | Facilitan el manejo de estructuras de datos de manera clara y legible.           |
| **Modularidad**                 | Permite construir programas mediante módulos reutilizables.                      |
| **Recursión**                   | Proporciona mecanismos para resolver problemas mediante funciones recursivas.    |

---

# 7. Inferencia de tipos

Una de las principales innovaciones de ML fue su sistema de **inferencia de tipos**.

Gracias a este mecanismo, el compilador puede deducir automáticamente el tipo de una expresión sin que el programador tenga que especificarlo explícitamente en todos los casos.

Esto permite combinar:

* La seguridad del **tipado estático**.
* La comodidad de no tener que declarar constantemente los tipos.
* La detección de errores durante la compilación.
* La posibilidad de utilizar **polimorfismo** en determinadas expresiones.

Por ejemplo, una función sencilla puede definirse sin indicar explícitamente el tipo de su parámetro:

```text
fun square x = x * x
```

A partir de la operación utilizada, el sistema de tipos puede determinar las restricciones necesarias para establecer el tipo de la función.

La inferencia de tipos se convirtió en una de las características más influyentes de la familia de lenguajes derivados de ML.

---

# 8. Ventajas y desventajas de ML

## Ventajas

* **Legibilidad y concisión:** la inferencia de tipos y su sintaxis permiten escribir código de manera clara.
* **Detección temprana de errores:** el tipado estático permite identificar determinados errores antes de ejecutar el programa.
* **Programación funcional:** facilita la implementación de funciones matemáticas y lógicas.
* **Modularidad:** permite desarrollar programas mediante componentes reutilizables.
* **Expresividad:** permite trabajar con funciones de orden superior y patrones de coincidencia.

## Desventajas

* **Curva de aprendizaje:** puede resultar desafiante para personas acostumbradas principalmente a lenguajes imperativos.
* **Menor popularidad:** cuenta con menos recursos y comunidades que lenguajes como Java o Python.
* **Orientación a objetos limitada:** las implementaciones tradicionales de ML ofrecen menos características orientadas a objetos que algunos lenguajes modernos.

---

# 9. De ISWIM a los lenguajes funcionales tipados

La importancia de la transición de **ISWIM a ML** se encuentra en la evolución de las ideas de programación funcional.

ISWIM proporcionó una base conceptual basada en el **cálculo lambda**, las expresiones, las funciones y el ámbito léxico. Estas ideas demostraron que era posible diseñar lenguajes con una estructura funcional clara y fundamentada matemáticamente.

Posteriormente, ML incorporó un **sistema de tipos estático con inferencia de tipos**, creando una combinación entre:

> **Programación funcional + Tipado estático + Inferencia de tipos**

Esta combinación fue especialmente importante para el desarrollo de lenguajes funcionales posteriores.

La familia de lenguajes derivados de ML continuó desarrollando estas ideas, influyendo en lenguajes como **Standard ML, OCaml y F#**, mientras que otros lenguajes funcionales también adoptaron sistemas de tipos avanzados e ideas provenientes de esta tradición.

Por lo tanto, la línea **ISWIM → ML** representa una parte importante de la evolución histórica de los **lenguajes funcionales tipados**.

---

# 10. Comparación entre ISWIM y ML

La siguiente tabla permite observar las principales diferencias y similitudes entre **ISWIM** y **ML**, destacando cómo ML tomó conceptos de ISWIM y los complementó con un sistema de tipos estático.

| Aspecto                         | ISWIM                                                                | ML                                                                                                |
| ------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| **Creador principal**           | Peter J. Landin                                                      | Robin Milner y su equipo                                                                          |
| **Año de aparición**            | 1966                                                                 | Década de 1970                                                                                    |
| **Propósito inicial**           | Servir como modelo abstracto para estudiar conceptos de programación | Desarrollar estrategias de demostración en el sistema LCF                                         |
| **Tipo de lenguaje**            | Lenguaje funcional abstracto                                         | Lenguaje funcional de propósito general                                                           |
| **Implementación**              | No fue implementado como lenguaje de uso general                     | Tuvo implementaciones y evolucionó en distintas variantes                                         |
| **Base teórica**                | Cálculo lambda                                                       | Principios de programación funcional e ideas heredadas de ISWIM                                   |
| **Ámbito léxico**               | Sí                                                                   | Sí                                                                                                |
| **Expresiones como valores**    | Sí                                                                   | Sí                                                                                                |
| **Funciones de orden superior** | Sí                                                                   | Sí                                                                                                |
| **Tipado estático**             | No constituye su característica central                              | Sí                                                                                                |
| **Inferencia de tipos**         | No                                                                   | Sí                                                                                                |
| **Polimorfismo de tipos**       | No como característica central                                       | Sí                                                                                                |
| **Evaluación perezosa**         | Asociada a su influencia conceptual                                  | No es una característica general de ML tradicional                                                |
| **Modularidad**                 | Principalmente conceptual                                            | Sí                                                                                                |
| **Uso principal**               | Investigación y diseño de lenguajes                                  | Investigación, enseñanza y desarrollo de software                                                 |
| **Influencia posterior**        | Influyó en diversos lenguajes funcionales                            | Influyó en Standard ML, OCaml, F# y otros                                                         |
| **Importancia histórica**       | Proporcionó una base conceptual para la programación funcional       | Contribuyó a establecer la combinación de programación funcional y tipado estático con inferencia |

### ¿Qué heredó ML de ISWIM?

De manera simplificada, la relación puede entenderse de la siguiente manera:

```text
              ISWIM
                │
                │ Herencia de conceptos
                ▼
        ┌─────────────────┐
        │       ML        │
        └────────┬────────┘
                 │
       ┌─────────┴─────────┐
       ▼                   ▼
Programación          Sistema de tipos
funcional             estático
       │                   │
       │              Inferencia de
       │                  tipos
       │                   │
       └─────────┬─────────┘
                 ▼
       Lenguajes funcionales
              tipados
```

La diferencia fundamental es que **ISWIM representa principalmente una propuesta conceptual y teórica**, mientras que **ML llevó varias de esas ideas hacia un lenguaje implementable y añadió un sistema de tipos estático con inferencia**.

---

# 11. Relación entre ISWIM y ML

La evolución puede representarse de forma simplificada:

```text
┌────────────────────────────┐
│           ISWIM            │
│           1966             │
└─────────────┬──────────────┘
              │
              │ Cálculo lambda
              │ Expresiones
              │ Ámbito léxico
              │ Funciones
              ▼
┌────────────────────────────┐
│             ML             │
│       Década de 1970       │
└─────────────┬──────────────┘
              │
       ┌──────┴──────┐
       │             │
       ▼             ▼
┌─────────────┐ ┌───────────────┐
│ Programación│ │ Sistema de    │
│ funcional   │ │ tipos estático│
└──────┬──────┘ └───────┬───────┘
       │                │
       └────────┬───────┘
                │
                ▼
       ┌──────────────────┐
       │ Inferencia de    │
       │ tipos y          │
       │ polimorfismo     │
       └────────┬─────────┘
                │
                ▼
     ┌───────────────────────┐
     │ Lenguajes funcionales │
     │       tipados         │
     └───────────┬───────────┘
                 │
       ┌─────────┼─────────┐
       ▼         ▼         ▼
    SML       OCaml       F#
```

Esta relación muestra cómo las ideas conceptuales de ISWIM fueron retomadas y ampliadas en ML, especialmente mediante la incorporación de un sistema de tipos estático y mecanismos de inferencia.

---

# 12. Conclusión

El estudio de **ISWIM y ML** permite comprender una parte fundamental de la evolución de la programación funcional.

ISWIM, aunque nunca fue implementado directamente como un lenguaje de uso general, estableció ideas importantes relacionadas con el **cálculo lambda, el ámbito léxico, las expresiones y la separación entre sintaxis y semántica**.

Posteriormente, ML retomó varias de estas ideas y las llevó hacia un lenguaje más práctico, incorporando un **sistema de tipos estático, inferencia de tipos y polimorfismo**.

La combinación de estos conceptos permitió establecer una línea de desarrollo que influyó en numerosos **lenguajes funcionales tipados**.

Por ello, la transición **ISWIM → ML** representa un punto importante en la historia de la programación funcional, al mostrar cómo conceptos inicialmente teóricos pudieron evolucionar hacia herramientas capaces de proporcionar tanto **expresividad funcional como seguridad de tipos**.

---

## Referencias bibliográficas

[1] L. Alegsa, "Definición de ISWIM (lenguaje de programación)," ALEGSA, Jul. 13, 2025. [En línea]. Disponible en: https://www.alegsa.com.ar/Dic/iswim.php. [Consultado: 14-sep-2026].

[2] L. Alegsa, "Definición de ML (lenguaje de programación)," ALEGSA, Jul. 13, 2025. [En línea]. Disponible en: https://www.alegsa.com.ar/Dic/ml_lenguaje_programacion.php. [Consultado: 14-sep-2026].

[3] Universidad Nacional Autónoma de México, "Título real del documento," Repositorio Institucional UNAM. [En línea]. Disponible en: https://ru.dgb.unam.mx/server/api/core/bitstreams/23a580a8-2b5a-436b-94cf-aa96b322dd56/content. [Consultado: 14-sep-2026].
