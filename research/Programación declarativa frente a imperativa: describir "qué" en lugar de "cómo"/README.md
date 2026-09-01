# Programación declarativa frente a imperativa: describir "qué" en lugar de "cómo"

## Introducción

La forma en que un programador comunica una solución a una computadora puede seguir, en términos generales, dos filosofías distintas: la **imperativa**, en la que el código especifica paso a paso *cómo* debe ejecutarse una tarea, y la **declarativa**, en la que el código especifica *qué* resultado se desea obtener, delegando en el lenguaje o en el motor de ejecución la responsabilidad de decidir los pasos concretos. Esta distinción no es meramente estilística: influye directamente en la legibilidad del código, en la facilidad de mantenimiento, en el rendimiento y en la manera en que se razona sobre los programas. El presente informe examina los fundamentos teóricos de ambos paradigmas, compara sus mecanismos de control de flujo, analiza ejemplos representativos en lenguajes reales y discute los contextos en los que cada enfoque resulta más adecuado.

## Desarrollo técnico

### 1. Definición de los paradigmas

La programación **imperativa** modela la computación como una secuencia de instrucciones que modifican el estado de la máquina mediante asignaciones de variables, bucles y estructuras de control explícitas (`if`, `for`, `while`). El programador debe describir el algoritmo completo: cómo se recorre una colección, cómo se acumula un resultado, cuándo se detiene la iteración. Lenguajes como C, Pascal y, en su núcleo básico, Python y Java, siguen este modelo.

La programación **declarativa**, en cambio, describe relaciones, propiedades o el resultado esperado sin especificar el algoritmo que lo produce. El motor subyacente (un intérprete, un optimizador de consultas, un motor de inferencia) decide la estrategia de ejecución. SQL, Prolog, HTML/CSS y buena parte de la programación funcional (Haskell, y en menor medida el estilo funcional de JavaScript o Python) son representativos de este paradigma.

### 2. Ejemplo comparativo

Supóngase el problema de obtener los números pares de una lista.

**Enfoque imperativo (Python, estilo de bucle):**

```python
pares = []
for n in numeros:
    if n % 2 == 0:
        pares.append(n)
```

Aquí se especifica explícitamente la inicialización de una lista vacía, la iteración elemento por elemento, la condición de filtrado y la operación de inserción: el "cómo".

**Enfoque declarativo (Python, comprensión de listas; equivalente conceptual a SQL):**

```python
pares = [n for n in numeros if n % 2 == 0]
```

```sql
SELECT n FROM numeros WHERE n % 2 = 0;
```

En ambos casos se describe *qué* conjunto de elementos se desea (aquellos que cumplen una condición), sin indicar el mecanismo de iteración interno. El intérprete de Python o el motor de bases de datos deciden cómo recorrer la estructura y qué optimizaciones aplicar (por ejemplo, el uso de índices en SQL).

### 3. Transparencia referencial y ausencia de estado mutable

Un rasgo central de muchos lenguajes declarativos —en particular los funcionales puros como Haskell— es la **transparencia referencial**: una expresión siempre produce el mismo resultado dado el mismo input, sin efectos secundarios sobre variables externas. Esto elimina una fuente común de errores en programación imperativa: el estado mutable compartido, que obliga a razonar sobre el orden exacto de ejecución y sobre qué partes del programa modifican qué variables en qué momento. En programación declarativa, el orden de evaluación suele ser irrelevante para el resultado final, lo que facilita el razonamiento matemático sobre la corrección del programa y habilita optimizaciones automáticas como la paralelización.

### 4. Control de flujo explícito frente a implícito

En el paradigma imperativo, el flujo de control (bucles, saltos condicionales, recursión explícita) es visible y manipulable directamente por el programador. Esto ofrece un control fino sobre el rendimiento —se puede optimizar manualmente un bucle crítico— pero incrementa la complejidad ciclomática y el riesgo de errores como condiciones de carrera, desbordamientos de índice o bucles infinitos.

En el paradigma declarativo, el control de flujo queda oculto tras la abstracción: un motor de bases de datos decide si usar un índice hash o un escaneo secuencial; un motor de Prolog realiza búsqueda con retroceso (*backtracking*) automáticamente para satisfacer una consulta lógica. Esto reduce la carga cognitiva del desarrollador, pero también reduce el control directo sobre el rendimiento, y los errores de rendimiento pueden ser más difíciles de diagnosticar porque el "cómo" real está oculto en la implementación del motor.

### 5. Casos de uso característicos

- **SQL** es el ejemplo canónico de lenguaje declarativo de propósito específico: el desarrollador especifica las tablas y condiciones deseadas, y el optimizador de consultas del sistema gestor de bases de datos determina el plan de ejecución óptimo.
- **HTML/CSS** describen la estructura y presentación deseada de un documento, no los pasos para dibujarlo píxel a píxel; es el motor de renderizado del navegador quien resuelve el "cómo".
- **Programación funcional** (Haskell, Elixir, y el estilo funcional en JavaScript con `map`/`filter`/`reduce`) favorece funciones puras y composición sobre bucles con estado mutable.
- **Prolog y sistemas basados en reglas** permiten expresar hechos y reglas lógicas; el motor de inferencia decide cómo buscar soluciones que satisfagan esas reglas.
- **Infraestructura como código declarativa** (Terraform, Kubernetes YAML) especifica el estado final deseado del sistema ("quiero tres réplicas de este servicio"), y el orquestador calcula los pasos necesarios para alcanzar ese estado, incluso reconciliando diferencias con el estado actual de forma continua.

### 6. Ventajas y desventajas comparadas

La programación imperativa ofrece control detallado, buen ajuste a la arquitectura de hardware subyacente (que ejecuta instrucciones secuenciales) y facilidad para razonar sobre el rendimiento paso a paso. Sus desventajas incluyen mayor verbosidad, mayor superficie para errores relacionados con el estado y menor nivel de abstracción.

La programación declarativa ofrece código más conciso, más cercano a la especificación del problema, más fácil de verificar formalmente y frecuentemente más seguro frente a errores de concurrencia. Sus desventajas incluyen una curva de aprendizaje distinta (pensar en términos de relaciones y no de pasos), menor control directo sobre el rendimiento y, en ocasiones, dependencia de que el motor subyacente genere una estrategia de ejecución eficiente.

En la práctica, la mayoría de los lenguajes modernos son híbridos: Python, JavaScript y Java permiten escribir tanto bucles imperativos como composiciones declarativas (comprensiones de listas, streams, `map`/`filter`), y la elección entre uno u otro estilo depende del problema concreto, del rendimiento requerido y de la legibilidad deseada por el equipo de desarrollo.

## Conclusiones

La distinción entre programación declarativa e imperativa refleja dos formas complementarias de resolver problemas computacionales: especificar el proceso o especificar el resultado. Ninguno de los dos paradigmas es universalmente superior; su idoneidad depende del dominio del problema. Los lenguajes declarativos destacan cuando el problema puede expresarse naturalmente como relaciones o restricciones (consultas de datos, interfaces de usuario, configuración de infraestructura), reduciendo errores relacionados con el estado y facilitando el mantenimiento. Los lenguajes imperativos siguen siendo indispensables cuando se requiere control detallado sobre el rendimiento y el uso de recursos, como en sistemas embebidos o en secciones críticas de rendimiento. El dominio de ambos paradigmas, y la capacidad de alternar entre ellos según el contexto, constituye una competencia central en la formación de cualquier desarrollador de software contemporáneo.

## Bibliografía

[1] Wikipedia, "Programación declarativa," *Wikipedia, la enciclopedia libre*. [En línea]. Disponible: https://es.wikipedia.org/wiki/Programación_declarativa. 

[2] GeeksforGeeks, "Diferencia entre programación imperativa y declarativa," GeeksforGeeks. [En línea]. Disponible: https://www.geeksforgeeks.org/theory-of-computation/difference-between-imperative-and-declarative-programming/. 

[3] A. Ferreira, "Imperative and declarative programming paradigms," Baeldung on Computer Science. [En línea]. Disponible: https://www.baeldung.com/cs/imperative-vs-declarative-programming. 

[4] Codefresh (Octopus Deploy), "Declarative vs. imperative programming: 4 key differences," Codefresh Learning Center. [En línea]. Disponible: https://codefresh.io/learn/infrastructure-as-code/declarative-vs-imperative-programming-4-key-differences/. 

[5] TechTarget, "A brief breakdown of declarative vs. imperative programming," TechTarget SearchAppArchitecture. [En línea]. Disponible: https://www.techtarget.com/searchapparchitecture/tip/A-brief-breakdown-of-declarative-vs-imperative-programming. 2026.

[6] B. Ruiz, "Declarative vs imperative," DEV Community. [En línea]. Disponible: https://dev.to/ruizb/declarative-vs-imperative-4a7l.

[7] HashiCorp, "Terraform: Infrastructure as code," HashiCorp Developer Documentation. [En línea]. Disponible: https://developer.hashicorp.com/terraform/intro. 

[8] E. F. Codd, "A relational model of data for large shared data banks," *Communications of the ACM*, vol. 13, no. 6, pp. 377–387, jun. 1970.
