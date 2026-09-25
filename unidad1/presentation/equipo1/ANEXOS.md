# Anexo — Bitácora de uso de LLM (Claude)

Este documento registra el uso de un modelo de lenguaje (**Claude, de Anthropic**) como herramienta de apoyo durante la elaboración de mi parte del trabajo (**Rol 2: Modelo de cómputo y sintaxis**) para la exposición de **Lisp/Scheme (Equipo 1, Unidad 1)**.

Se documentan los prompts utilizados, los resultados obtenidos y una reflexión crítica sobre su utilidad y sus limitaciones.

---

## 1. Herramienta utilizada

* **Modelo:** Claude (Anthropic), vía ChatLLM Teams.
* **Uso principal:** apoyo para investigar y comprender conceptos relacionados con el modelo de cómputo y la sintaxis de Scheme, estructurar el contenido de las diapositivas, analizar ejemplos y orientar la búsqueda de fuentes académicas.
* **Uso que NO se le dio:** no se utilizó para generar el código Scheme final del demo, ya que este fue verificado y grabado por el compañero correspondiente al Rol 4. Tampoco se utilizaron referencias bibliográficas sin comprobar previamente que fueran fuentes reales y confiables.

---

## 2. Registro de prompts y resultados

### Prompt 1 — Investigación sobre el modelo de cómputo de Scheme

#### Prompt utilizado

> Investiga cómo funciona el modelo de cómputo de Scheme y qué relación tiene con la idea de que el código puede representarse mediante las mismas estructuras de datos que utiliza el lenguaje. Contrasta la explicación con fuentes académicas sobre Scheme y señala los conceptos que serían más importantes para explicarlo en una exposición universitaria.

#### Resultado obtenido

La investigación permitió identificar la relación entre las expresiones de Scheme, las listas y el concepto de **código como datos**. También ayudó a seleccionar la **homoiconicidad** como una característica importante para explicar el funcionamiento del lenguaje y a distinguir qué conceptos necesitaban mayor explicación durante la exposición.

#### Reflexión

Fue útil como punto de partida para investigar el tema, ya que permitió identificar conceptos y términos específicos que posteriormente podían revisarse en las fuentes bibliográficas, en lugar de realizar una búsqueda demasiado general sobre Scheme.

---

### Prompt 2 — Análisis de operaciones fundamentales de Scheme

#### Prompt utilizado

> Analiza el papel de `car`, `cdr` y `cons` dentro de Scheme. No te limites a definir cada operación: explica por qué son importantes para la manipulación de listas, cómo se relacionan entre sí y plantea ejemplos diferentes que permitan comprobar su funcionamiento.

#### Resultado obtenido

El análisis permitió comprender que `car`, `cdr` y `cons` no son operaciones aisladas, sino herramientas relacionadas con la **construcción, acceso y descomposición de listas**.

Los ejemplos generados sirvieron para comparar su comportamiento y posteriormente seleccionar los más claros para utilizarlos como apoyo durante la explicación del tema.

#### Reflexión

Este prompt ayudó principalmente a comprender la lógica detrás de las operaciones. Esto permitió utilizar los ejemplos como apoyo para la exposición sin depender únicamente de definiciones memorizadas.

---

### Prompt 3 — Investigación y verificación de fuentes sobre Scheme

#### Prompt utilizado

> Localiza fuentes académicas o institucionales que permitan respaldar la información sobre el origen y las características de Scheme. Prioriza documentos de sus autores originales, publicaciones universitarias y material académico reconocido. Para cada fuente, indica qué información del trabajo podría respaldar y qué datos bibliográficos debo verificar antes de citarla.

#### Resultado obtenido

Se localizaron materiales relacionados con los trabajos originales de **Gerald Jay Sussman** y **Guy L. Steele Jr.**, así como recursos académicos vinculados con Scheme y *Structure and Interpretation of Computer Programs*.

Las fuentes propuestas se utilizaron como guía para realizar una verificación posterior antes de incorporarlas a la bibliografía del trabajo.

#### Reflexión

Este uso fue diferente a solicitar directamente una bibliografía. El modelo sirvió para **orientar la búsqueda de fuentes** y determinar cuáles podían ser útiles, pero fue necesario comprobar manualmente su existencia, autoría y relación con el contenido antes de citarlas.

---

## 3. Reflexión crítica general

### ¿La herramienta fue útil?

Sí. Claude funcionó principalmente como una herramienta de **apoyo para la investigación, análisis y comprensión** de los temas correspondientes a mi participación.

Permitió identificar conceptos relevantes sobre Scheme, analizar la relación entre diferentes operaciones del lenguaje y orientar la búsqueda de fuentes académicas. Las respuestas obtenidas sirvieron como punto de partida y posteriormente fueron revisadas y adaptadas para la exposición.

### ¿Hubo errores o limitaciones?

Una de las principales limitaciones fue que la información proporcionada por un modelo de lenguaje no debe asumirse automáticamente como correcta. Esto fue especialmente importante al trabajar con referencias bibliográficas, ya que existe la posibilidad de obtener datos incompletos o fuentes incorrectas.

Por esta razón, las referencias propuestas fueron verificadas antes de incorporarlas al trabajo. También fue necesario seleccionar y resumir parte de la información obtenida para conservar únicamente los conceptos relevantes para la exposición.

### Conclusión del uso de la herramienta

Claude se utilizó como una herramienta complementaria durante la preparación de mi participación sobre el **modelo de cómputo y sintaxis de Lisp/Scheme**.

Su función principal fue apoyar la investigación, facilitar la comprensión de conceptos y orientar la búsqueda de información. El contenido generado no sustituyó la revisión personal del tema, ya que las respuestas relevantes fueron analizadas, adaptadas y verificadas antes de incorporarlas a la entrega final.
