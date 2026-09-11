# Anexo 1.1 Investigación via Pull Request
  Alumno: Cesar Adrian Luis Juan Camacho
---

## 1. Prompts utilizados

A continuación se enumeran, en orden cronológico y sin editar su contenido técnico, los prompts principales enviados a la herramienta de IA durante la elaboración de este trabajo:

1. **Prompt 1 (solicitud principal del documento):**
   > "Redacta un documento académico, estilo README.md, sobre el tema: Recursión como alternativa a los bucles: caso base y caso recursivo. Para el curso Programación Lógica y Funcional. Estructura obligatoria:1. Título e introducción [...] 2. Desarrollo técnico (mínimo 500 palabras): Define caso base y caso recursivo con ejemplos claros, compara recursión vs bucles imperativos, incluye ejemplos de código en Haskell, Elixir y Clojure que compilen/ejecuten, explica errores comunes (falta de caso base, desbordamiento de pila), menciona la recursión de cola como optimización. 3. Conclusiones [...] 4. Bibliografía en formato IEEE (mínimo 3 fuentes académicas o libros reconocidos). 5. Opcional: diagramas de llamadas recursivas o código adicional. Condiciones: lenguaje claro, técnico y académico; ejemplos de código probados y correctos; no usar funciones parciales ni pseudocódigo sin etiqueta; declarar el uso de IA en anexo.md con reflexión crítica."

No se enviaron prompts adicionales de "regeneración" o reintentos ocultos: el contenido técnico se produjo en una sola iteración por cada solicitud, y las correcciones posteriores (sección siguiente) fueron realizadas o dirigidas manualmente por el estudiante, no mediante nuevos prompts de generación de contenido.
 
---

## 2. Agentes o herramientas utilizadas

* **Claude (Sonnet 5), desarrollado por Anthropic** — utilizado como única herramienta de IA en este trabajo, a través de la interfaz de chat de Claude.ai. Se empleó para:
  * Redactar la introducción y el desarrollo técnico sobre caso base, caso recursivo y recursión de cola.
  * Generar los tres ejemplos de código (Haskell, Elixir, Clojure) y el ejemplo adicional de recorrido de árboles binarios.
  * Proponer la estructura comparativa (tabla recursión vs. bucles) y el diagrama textual de expansión/reducción de llamadas.
  * Proponer una lista inicial de referencias bibliográficas en formato IEEE, posteriormente verificadas manualmente (ver siguiente sección).

No se utilizaron otras herramientas de IA

---

## 3. Cambios realizados y evaluación crítica

* **Verificación de ejecución del código:** los tres fragmentos principales (`sumaN` en Haskell, `factorial/1` en Elixir, `longitud` en Clojure) fueron revisados línea por línea para confirmar que la sintaxis corresponde a construcciones válidas de cada lenguaje (aridad correcta de las funciones, uso correcto de *pattern matching*, ausencia de dependencias externas). No se aceptó ningún fragmento incompleto o marcado como "pseudocódigo".
* **Corrección de precisión conceptual sobre TCO:** la primera versión generada por la IA presentaba la recursión de cola de forma general; se revisó específicamente que el ejemplo de Elixir (`factorial_aux/2`) cumpliera la condición estricta de recursión de cola (la llamada recursiva como última expresión evaluada, sin operación pendiente), y se contrastó con el caso de Clojure, donde se aclaró que la JVM no optimiza TCO automáticamente y por ello se exige el uso explícito de `recur`. Esta distinción no era evidente en la redacción inicial y se solicitó y verificó de forma puntual.
* **Eliminación de contenido genérico:** se descartaron formulaciones demasiado generales sobre "ventajas de la programación funcional" que no aportaban rigor técnico al tema específico de la recursión, priorizando el contenido exigido por la rúbrica (caso base, caso recursivo, comparación con bucles, errores comunes, recursión de cola).
* **Verificación bibliográfica manual:** cada una de las fuentes propuestas por la IA fue confirmada de forma independiente (editorial, año de publicación y existencia real de la obra) antes de incluirla en la bibliografía final, y se añadió una fuente adicional de sitio oficial de lenguaje para reforzar la confiabilidad de las referencias (ver bibliografía en `README.md`).
* **Adecuación al formato del repositorio:** se ajustó el documento generado al flujo de trabajo Fork → Pull Request del curso, manteniendo el archivo como `README.md` en la raíz del aporte y separando esta bitácora en `anexo.md`, tal como exige la consigna.

---

## 4. Reflexión personal

El uso de la IA en este trabajo fue útil principalmente como acelerador de la redacción y como generador de una primera versión de ejemplos de código en tres lenguajes distintos, lo cual habría tomado considerablemente más tiempo de investigación individual. Sin embargo, la experiencia dejó claro que **la IA no sustituye la verificación técnica**: al revisar en detalle el ejemplo de recursión de cola, fue necesario detenerme a comparar cómo cada lenguaje (Haskell, Elixir, Clojure) maneja la optimización de llamadas de cola, ya que no es un comportamiento uniforme entre lenguajes funcionales; esto me obligó a repasar el concepto de *marco de pila* (*stack frame*) con más profundidad de la que tenía antes de iniciar el ejercicio.

También aprendí a distinguir entre una explicación que "suena correcta" y una explicación verificable: por ejemplo, confirmar que Clojure no aplica TCO automática y requiere `recur` es un detalle que fácilmente se pasa por alto si se acepta el primer texto generado sin cuestionarlo. Esto reforzó mi criterio para exigir evidencia (documentación oficial o bibliografía) antes de dar por válida una afirmación técnica generada por IA.

Para un próximo trabajo, haría dos cosas distintas: (1) ejecutar directamente cada fragmento de código en un intérprete real (GHCi, IEx, REPL de Clojure) en lugar de basarme solo en la revisión manual de sintaxis, y (2) solicitar a la IA explícitamente sus fuentes o justificación teórica antes de aceptar afirmaciones comparativas entre lenguajes, para reducir el riesgo de errores sutiles no detectados.

---

## 5. Datos finales

* **Fecha de la asistencia IA:** 11 de septiembre de 2026
* **Versión de entrega/práctica:** 1.1 Investigación via Pull Request
* **Herramientas:** Claude (Sonnet 5), Anthropic — interfaz de chat de Claude.ai
