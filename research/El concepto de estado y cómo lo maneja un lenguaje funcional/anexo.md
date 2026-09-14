# Anexo: Bitácora de Uso de Inteligencia Artificial (LLM)

**Materia:** Programación Lógica y Funcional
**Tema de Investigación:** El concepto de estado y cómo lo maneja un lenguaje funcional

A continuación se detalla la bitácora de uso de modelos de lenguaje grande (LLM) utilizados como herramienta de asistencia para la investigación teórica, estructuración del documento y redacción técnica de este trabajo.

---

## Interacción 1: Exploración y comprensión del problema fundamental
**Prompt utilizado:**
> "Explícame de manera técnica, a nivel de ingeniería de software, cómo un lenguaje puramente funcional maneja el estado de un sistema si sus principios dictan que las variables son inmutables y no deben existir efectos secundarios. Menciona las estrategias arquitectónicas principales."

**Resultado obtenido:**
El LLM proporcionó una respuesta detallada dividiendo el problema en tres enfoques principales: el paso del estado como argumento (State Threading), el uso de recursividad en lugar de bucles imperativos, y una introducción básica a las Mónadas de Estado (State Monads).

**Reflexión crítica:**
*   **¿Ayudó?** Sí, fue fundamental para romper el esquema mental imperativo. Explicó muy bien la diferencia entre "mutar" una variable y "transformar" un estado devolviendo una nueva versión del mismo.
*   **Sesgos o errores:** Noté que la explicación inicial tendía a simplificar demasiado la carga en memoria que esto generaría. Tuve que formular un segundo prompt para entender cómo esto no provoca un colapso en la RAM (lo que me llevó a investigar las estructuras persistentes).

---

## Interacción 2: Profundización técnica y complejidad computacional
**Prompt utilizado:**
> "Si en la programación funcional el estado se pasa como argumento devolviendo un estado nuevo cada vez, ¿cómo evitan estos lenguajes el desbordamiento de memoria o la lentitud al procesar grandes volúmenes de datos? Explícame el concepto de compartición estructural (Structural Sharing) y su complejidad algorítmica (Big O)."

**Resultado obtenido:**
El modelo generó una explicación técnica sobre las estructuras de datos persistentes, cómo los nuevos nodos referencian a los nodos antiguos inalterados (creando grafos dirigidos acíclicos) y detalló que la complejidad para actualizar el estado pasa a ser de tiempo logarítmico $O(\log n)$ en lugar de lineal $O(n)$.

**Reflexión crítica:**
*   **¿Ayudó?** Bastante. Fue la pieza clave para sustentar la viabilidad del manejo de estado funcional en entornos de producción reales.
*   **Sesgos o errores:** En un principio, el LLM hizo parecer que la compartición estructural resolvía absolutamente todos los problemas de rendimiento, omitiendo que, aunque es $O(\log n)$, las constantes operacionales siguen siendo más lentas que una mutación directa en un arreglo de C o C#. Tuve que analizar la respuesta con escepticismo propio de la carrera de Ingeniería en Sistemas Computacionales para no plasmar el paradigma funcional como una "solución mágica", sino como un balance entre seguridad (inmutabilidad) y rendimiento.

---

## Interacción 3: Abstracción matemática (Mónadas)
**Prompt utilizado:**
> "Profundiza en la Mónada de Estado (State Monad) en lenguajes como Haskell. Explícame cómo actúa como contenedor para abstraer el paso de estado y cómo esto permite simular un código secuencial/imperativo manteniendo la pureza. Usa terminología formal."

**Resultado obtenido:**
El LLM describió cómo la mónada encapsula las funciones del tipo `s -> (a, s)`, ocultando la fontanería de pasar variables de estado manualmente. Explicó el operador `bind` (>>=) de manera conceptual.

**Reflexión crítica:**
*   **¿Ayudó?** Fue vital. El concepto de mónada es notoriamente difícil de entender solo leyendo documentación abstracta. El LLM sirvió como un tutor interactivo para aterrizar la teoría matemática a su aplicación práctica en el código.
*   **Sesgos o errores:** El modelo generó un pequeño error de sintaxis al intentar ejemplificar código en Haskell puro, confundiendo la notación `do` con una evaluación perezosa estándar. No usé el código en el trabajo final, pero tomé la abstracción teórica que sí era correcta.

---

## Interacción 4: Estructuración del documento final y referencias
**Prompt utilizado:**
> "Para mi materia de Programación Lógica y Funcional me pidieron investigar 'El concepto de estado y cómo lo maneja un lenguaje funcional', ocupo que tenga: Introducción, pregunta de investigación, marco teórico, El concepto de estado y cómo lo maneja un lenguaje funcional, y una conclusión técnica. Es una investigación técnica así que genera la estructura en Markdown y propón fuentes bibliográficas clásicas en formato IEEE."

**Resultado obtenido:**
El LLM generó el esqueleto del documento actual, redactó los párrafos de conexión e incluyó referencias bibliográficas reales de autores fundamentales como Philip Wadler y Simon Peyton Jones.

**Reflexión crítica:**
*   **¿Ayudó?** Agilizó enormemente el proceso de formateo y estructuración.
*   **Sesgos o errores:** Como es sabido, las IA pueden alucinar citas bibliográficas. Sin embargo, en este caso, al pedir "fuentes clásicas", el modelo recurrió a papers históricos y libros de texto ampliamente conocidos en el ámbito académico del Instituto Tecnológico de Tijuana, los cuales verifiqué manualmente (como *The essence of functional programming* de Wadler) confirmando que eran reales y pertinentes al tema.

---

## Conclusión General sobre el uso del LLM
El uso de la Inteligencia Artificial como herramienta de investigación resultó sumamente enriquecedor. Más que redactar el trabajo por mí, fungió como un catalizador para comprender conceptos abstractos (como *State Threading* y *Monads*). El principal sesgo detectado es la tendencia de la IA a ser excesivamente optimista sobre las ventajas de un paradigma, por lo que fue necesario aplicar criterio ingenieril para contrastar la teoría con las implicaciones reales de rendimiento y uso de memoria.
