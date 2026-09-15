# Anexo: Responsabilidad Académica


**IA Utilizada:** Gemini

## Prompts utilizados
1. *"Genera una investigación académica detallada sobre el cálculo lambda desarrollado por Alonzo Church en 1936, enfocándote en su papel como fundamento teórico de los lenguajes de programación funcional."*
2. *"Estructura la información de la investigación de manera jerárquica y didáctica, utilizando categorías y puntos clave que faciliten su análisis y comprensión teórica."*
3. *"Convierte el texto estructurado a formato Markdown estándar, asegurando el uso correcto de encabezados, listas y sintaxis de marcado para una presentación formal."*

## Cambios o mejoras realizadas tras usar pensamiento crítico
* **Verificación manual y matemática:** Aunque la IA proporcionó un ejemplo básico de reducción beta, para asegurar el rigor académico era necesario trazar las evaluaciones a mano y básicamente **hacerla desde 0** en papel. Esto garantiza que la sustitución de parámetros se entienda lógicamente y no haya colisiones de variables (lo que requeriría una conversión $ lpha$).
* **Aterrizaje a la práctica:** La IA presentó una visión muy teórica. El pensamiento crítico exigió conectar esa abstracción matemática de los años 30 con entornos de desarrollo funcionales reales, como el comportamiento de inmutabilidad y la ausencia de estado cuando se escribe y compila código en lenguajes como Erlang.

## Referencias oficiales o pruebas adicionales consultadas
* Church, A. (1936). *An Unsolvable Problem of Elementary Number Theory*. American Journal of Mathematics, 58(2), 345-363.
* Documentación oficial y principios de diseño de Erlang/OTP, para contrastar cómo el manejo de procesos y variables inmutables en la práctica desciende directamente de las reglas de Church.
* Material teórico sobre el diseño de compiladores (específicamente la construcción de árboles de expresiones y tablas de símbolos durante el análisis semántico) para entender cómo el hardware moderno interpreta funciones de primera clase.

## Reflexión

### ¿Qué sesgos, errores o vacíos encontré en la respuesta de la IA?
* **Vacío en la representación de datos:** La respuesta de la IA omitió cómo se representan los valores si el cálculo lambda carece de tipos primitivos (enteros, booleanos). Dejó un vacío importante sobre los "Numerales de Church", lo cual es esencial si se intenta entender el modelo computacional desde cero, ya que en el sistema de Church ¡hasta los números son funciones!
* **Sobresimplificación del proceso computacional:** La IA tendió a resumir la reducción beta como un simple "reemplazo", saltándose las complejidades matemáticas del ámbito (scope) y el orden de evaluación (estricto vs. perezoso) que enfrentan los compiladores reales al evaluar expresiones funcionales.

### ¿Qué aprendí del proceso de revisión?
* Aprendí que delegar el análisis de fundamentos matemáticos complejos a la IA sirve muy bien para obtener la estructura.
* Validar la información me ayudó a consolidar cómo conceptos abstractos como la conversión $\eta$, no son simples "reglas de sintaxis", sino las decisiones arquitectónicas fundamentales que permiten a los compiladores optimizar y ejecutar código puramente funcional sin efectos secundarios.
* La mejora de la redactacion sobre una investigación para hacerla más completa y asi brindar un mejor trabajo
