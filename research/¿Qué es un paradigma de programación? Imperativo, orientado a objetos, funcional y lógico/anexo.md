# Anexo: Bitácora de uso de asistentes de IA

## 1. Datos del estudiante

| Campo | Información |
|---|---|
| **Nombre completo** | Cota Hernandez Christian Armando |
| **Número de control** | 23211941 |
| **Carrera** | Ingeniería en Sistemas Computacionales |
| **Grupo** | SC7C |
| **Materia** | Programación Lógica y Funcional |
| **Profesor** | Rene Solis Reyes |
| **Tema** | ¿Qué es un paradigma de programación? Imperativo, orientado a objetos, funcional y lógico |

## 2. Propósito del uso de IA

Se utilizó un asistente de inteligencia artificial como herramienta de apoyo para estructurar la investigación documental, sintetizar conceptos teóricos fundamentales sobre paradigmas de programación, proponer fragmentos de código mínimos representativos para cada enfoque y validar el formato técnico en Markdown. La herramienta se empleó bajo un marco de asistencia metodológica y edición, garantizando que el análisis crítico, la validación sintáctica y la asimilación conceptual permanecieran bajo la total responsabilidad del estudiante.

## 3. Prompts utilizados

> **Prompt 1 (Estructura y fundamentación conceptual):**  
> *"Actúa como docente e investigador en ciencias de la computación. Proporciona una estructura formal para un informe técnico introductorio en Markdown sobre el tema: '¿Qué es un paradigma de programación? Imperativo, orientado a objetos, funcional y lógico'. Incluye la fundamentación histórica del concepto basándote en la conferencia del Premio Turing de Robert W. Floyd (1978) y Thomas Kuhn, diferenciando claramente la familia imperativa de la declarativa."*

> **Prompt 2 (Desarrollo temático y ejemplos de código mínimos):**  
> *"Para cada uno de los cuatro paradigmas (imperativo estructurado, orientado a objetos, funcional y lógico), genera una explicación concisa de su modelo conceptual, unidad de cómputo y manejo de estado. Acompaña cada paradigma con un ejemplo canónico y mínimo de código representativo (C para imperativo, Java para POO, Haskell para funcional y Prolog para lógico) que resuelva un problema clásico sin dependencias externas."*

> **Prompt 3 (Síntesis comparativa y aplicaciones en la industria):**  
> *"Elabora una tabla comparativa exhaustiva que contraste los cuatro paradigmas según su pregunta central, manejo del estado, unidad de trabajo y lenguajes representativos. Asimismo, añade una sección sobre lenguajes multiparadigma ilustrada con Python y desglosa las aplicaciones prácticas de cada enfoque en la industria del software actual (sistemas embebidos, backends empresariales, concurrencia y motores de reglas)."*

> **Prompt 4 (Estilo técnico, formato y bibliografía formal):**  
> *"Adapta el documento completo a un formato estándar de repositorio en GitHub: incorpora badges informativos en la cabecera, tabla de contenidos navegable mediante anclas, un diagrama de flujo conceptual en sintaxis Mermaid y el listado de referencias bibliográficas bajo la norma IEEE, citando autores fundamentales como Floyd, Abelson & Sussman, y Van Roy & Haridi."*

## 4. Resultados obtenidos

El asistente generó una propuesta integral en Markdown que incluyó:
- Una introducción teórica fundamentada con referencias a la literatura clásica de computación.
- Un desglose modular de los paradigmas imperativo, orientado a objetos, funcional y lógico, con tablas de pilares y conceptos clave (como funciones puras, inmutabilidad, unificación y backtracking).
- Fragmentos de código funcionales en C, Java, Haskell, Prolog y Python que ilustran de forma directa la diferencia entre el *cómo* (estado y control explícito) y el *qué* (evaluación matemática y deducción lógica).
- Un diagrama conceptual estructurado en sintaxis Mermaid y tablas comparativas de alta legibilidad.
- Un listado de fuentes bibliográficas formateadas conforme al estándar IEEE.

## 5. Revisión y aportación del estudiante

Como estudiante, se realizaron las siguientes revisiones y adecuaciones técnicas sobre el material sugerido:
1. **Verificación de sintaxis y ejecución:** Se revisó la validez del código en Haskell comprobando la correspondencia de tipos (`sumar :: [Int] -> Int`) y el uso de pattern matching. En Prolog, se verificó el uso adecuado del operador de desigualdad (`\=`) para evitar que un individuo se infiriera como hermano de sí mismo.
2. **Corrección de estilo y consistencia terminológica:** Se ajustó la redacción para mantener una terminología precisa en español formal técnico, asegurando coherencia conceptual entre "estado mutable", "efectos colaterales", "unificación" y "árboles de búsqueda".
3. **Validación de fuentes:** Se verificó la existencia y relevancia de los textos de referencia citados (especialmente la publicación de Robert W. Floyd en *CACM* y el texto de Van Roy & Haridi), corroborando que las citas respaldaran las afirmaciones del documento.

## 6. Reflexión crítica

- **Utilidad del asistente:** La herramienta optimizó significativamente los tiempos de maquetación y la organización inicial de los contenidos, permitiendo contrastar de forma ágil cómo cada paradigma aborda un mismo problema algorítmico desde perspectivas matemáticas y computacionales distintas.
- **Detección de sesgos o imprecisiones:** Las primeras respuestas tendían a generalizaciones simplistas (como catalogar un lenguaje como estrictamente "puro" o "exclusivo de un paradigma"), por lo que fue necesario refinar las consultas para destacar la predominancia del enfoque multiparadigma en la industria actual.
- **Contrastación independiente:** Se contrastaron las definiciones de funciones de primera clase, pureza y mecanismos de inferencia lógica con la bibliografía de la asignatura y la documentación de diseño de los respectivos lenguajes.
- **Mejoras para futuras entregas:** Para próximas investigaciones, se formularán prompts aún más granulares enfocados en el rendimiento en tiempo de ejecución y el impacto en memoria de la recursión frente a la iteración.

## 7. Declaración

Declaro que la inteligencia artificial se utilizó estrictamente como herramienta de apoyo metodológico, redacción y estructuración técnica. He revisado, ejecutado, comprendido y validado cada uno de los conceptos y fragmentos de código presentados en el documento principal antes de su integración final y entrega.
