# Anexo — Bitácora de uso de LLM

En este documento se registra el uso de un modelo de lenguaje (LLM) como una herramienta de apoyo correspondiente a la realización del trabajo de investigación del tema **Flujos perezosos con Stream en Elixir**.
Se hace documentación de los prompts utilizados, los resultados obtenidos y una reflexión crítica acerca de su uso y posibles sesgos encontrados al momento de su utilidad.

## 1. Herramienta de IA utilizada

**Modelo:** Gemini (Google)  
**Fecha de consulta:** 16 de septiembre de 2026  
**Uso principal:** Formulación, estructuración y generación del archivo `README.md`, creación de diagramas ilustrativos y cuadros informativos.

---

## 2. Registro de prompts y resultados obtenidos.

### Prompt 1 - Creación y estructura del README.md

> "Necesito desarrollar un trabajo de investigación acerca del tema: Flujos perezosos con Stream en Elixir. Requiero que me estructures los puntos que llevara la investigación, desarróllalos y ayúdame a crear el archivo .md, en formato Markdown. Asegúrate de que esté formado de manera clara. Incluye recursos extra como imágenes, cuadros comparativos y diagramas, asi como espacios libres para insertar imágenes posteriormente."

**Resultado obtenido:** un archivo README.md con las estructura de la investigación formada por un resumen ejecutivo, un índice de contenido, una introducción, desarrollo técnico dividido en varias secciones, espacios dedicados para diagramas de apoyo visual y cuadros informativos.

---

### Prompt 2 - Generación de diagrama "comparativa de asignación de memoria entre enum y stream"

> "Genera un diagrama donde se visualice una comparativa de asignación de memoria entre enum y stream"

**Resultado obtenido:** un gráfico que compara el consumo de RAM entre `Enum` y `Stream` en Elixir al procesar hasta 1,000,000 de elementos: muestra cómo **`Enum`** incrementa el uso de memoria de forma lineal $O(N)$ alcanzando hasta 180 MB debido a la creación de listas intermedias (*eager evaluation*), mientras que **`Stream`** mantiene un consumo constante de memoria $O(1)$ cercano a 0 MB al procesar los datos elemento por elemento (*lazy evaluation*).

---

### Prompt 3 - Generación de diagrama de secuencias de llamadas de retorno y control de flujo en la suspensión y reanudación de un stream

> "Realiza un diagrama de secuencia de llamadas de retorno (callbacks) y control de flujo en la suspensión y reanudación de un stream"

**Resultado obtenido:** un diagrama de secuencia que ilustra el flujo de ejecución entre el solicitante (**Caller / Materializer**), las transformaciones (**Stream Reducer**) y la fuente de datos (**Enumerable Source**): muestra cómo el proceso solicita y evalúa elementos de forma diferida uno a uno (`:cont`), hasta que al alcanzar un límite establecido, el flujo retorna una instrucción de suspensión (`{:suspend, final_acc}`) haciendo que la fuente detenga la iteración y conserve su estado.

---

## 3. Reflexión crítica general

### ¿Ayudó?
El uso del modelo de lenguaje representó una contribución altamente significativa durante la investigación, actuando como un asistente técnico y de diseño que aceleró drásticamente el flujo de trabajo al estructurar el documento en formato Markdown, redactar los apartados conceptuales de Elixir, sintetizar buenas prácticas, generar ejemplos de código sintácticamente válidos y construir visualizaciones complejas mediante diagramas de memoria y de secuencia.

### ¿Hubo sesgos o errores?
A lo largo de la interacción se identificaron sesgos e imprecisiones técnicas, tales como la tendencia del modelo a presentar valores de rendimiento en escenarios ideales sin profundizar en las variables reales de la máquina virtual BEAM (como la recolección de basura o el *chunking*), además de fallos de sintaxis en las primeras ejecuciones del intérprete de código (errores de indentación) que requirieron la supervisión, corrección e instrucción activa por parte del investigador para garantizar la exactitud del contenido.

### Conclusión del uso de la herramienta LLM
El modelo de lenguaje demostró ser un excelente catalizador de la productividad y una herramienta eficaz para la síntesis de información y la automatización de tareas de formato (como la estructuración en IEEE), concluyendo que los LLM deben emplearse como asistentes de prototipado donde la validación técnica, el análisis crítico y la responsabilidad del contenido final permanecen estrictamente bajo el criterio del investigador humano.



