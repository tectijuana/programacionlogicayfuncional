# Contexto e Historia de la Programación Funcional

## Orígenes Matemáticos: El Cálculo Lambda (Años 30s)

La programación funcional comienza en **1932–1933** cuando Alonzo Church desarrolla el **Cálculo Lambda**, un sistema matemático formal para expresar funciones. Church creó una notación elegante (λ) que captura el comportamiento de funciones matemáticas puras, demostrando que cualquier cálculo que pueda realizar una computadora puede expresarse mediante este formalismo.

## Primer Lenguaje Funcional: LISP (Finales 1950s)

A finales de los **años 1950**, John McCarthy define **LISP**, el primer lenguaje de programación que implementa directamente la notación lambda de Church. LISP fue revolucionario porque:

- Introdujo garbage collection automático
- Implementó closures para scoping estático
- Permitió funciones de orden superior
- Se convirtió en el lenguaje de investigación en IA durante décadas

**Dato curioso:** La serie de videojuegos *Jack and Daxter* fue desarrollada completamente en **GOAL**, un dialecto funcional de LISP.

## Consolidación: ML y la Era de la Tipificación Estática (1970s–1980s)

En los **años 1970**, en la Universidad de Edimburgo, investigadores crearon **ML** (Meta Language) como lenguaje para describir estrategias de prueba en sistemas de demostración automática. ML introdujo:

- Sistemas de tipos estáticos con inferencia Hindley-Milner
- Polimorfismo paramétrico
- Pattern matching

Estos avances hicieron la programación funcional **práctica y verificable**, no solo teórica.

**OCaml** (1996) emergió como versión mejorada de ML, con características como módulos y sistemas de tipos más ricos. OCaml se convirtió en un lenguaje funcional robusto usado en investigación y producción.

## Modernización: De OCaml al Ecosistema .NET con F# (2005)

**El problema:** En 2005, el ecosistema **.NET de Microsoft** tenía solo lenguajes imperativos (C#, VB.NET). No existía una opción funcional moderna en la plataforma.

**La solución:** Don Syme en Microsoft Research creó **F#** trayendo directamente los principios de OCaml/ML al CLR (.NET Runtime). F# implementa:

- El sistema de tipos de ML (inferencia Hindley-Milner)
- Immutabilidad por defecto
- Funciones de orden superior y pattern matching
- **Interoperabilidad completa con C# y librerías .NET**

Esto permitió a desarrolladores de C# acceder a programación funcional sin abandonar el ecosistema Microsoft.

## Relevancia Actual

La programación funcional hoy es relevante porque:

- **Paralelismo:** Funciones puras y datos inmutables son altamente paralelizables
- **Confiabilidad:** Ausencia de efectos secundarios reduce errores
- **Testabilidad:** Funciones puras son determinísticas y fáciles de probar
- **Análisis de datos:** Ideal para transformaciones complejas de datos
- **Sistemas distribuidos:** Erlang y Clojure dominan sistemas de tiempo real

F# representa la **madurez de este paradigma**, combinando rigor matemático con practicidad industrial en una plataforma ampliamente usada.

---
