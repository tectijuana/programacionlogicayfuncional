
# Anexo — Bitácora de uso de LLM

> **Tema:** Historia de Erlang: cómo Ericsson resolvió la tolerancia a fallos en telefonía (1986)
> **Herramienta usada:** Claude (Anthropic)
> **Autor:** Diego Barboza

---

## 1. Propósito de este anexo

Este documento registra de forma honesta y verificable el uso de un asistente de inteligencia artificial (LLM) durante el desarrollo de la investigación. Incluye los prompts reales utilizados, un resumen de lo que la IA entregó en cada interacción, y una reflexión crítica final sobre su aporte, limitaciones y posibles sesgos o errores detectados.

---

## 2. Bitácora de prompts

| # | Prompt (resumen fiel de lo pedido) | Resultado obtenido | Verificación / edición humana |
|---|---|---|---|
| 1 | Se pidió estructurar y redactar el `README.md` del tema "Historia de Erlang: cómo Ericsson resolvió la tolerancia a fallos en telefonía (1986)", con introducción, desarrollo técnico (mínimo 600 palabras), conclusiones, bibliografía en formato IEEE, y espacios para imágenes. | La IA realizó **búsquedas web** para verificar fechas, nombres (Joe Armstrong, Robert Virding, Mike Williams), el dato de "nueve nueves" de fiabilidad del AXD301 y la cronología de apertura del código (1998). Entregó un `README.md` completo con tablas comparativas, 8 subsecciones técnicas y bibliografía con enlaces reales. | Se revisaron las fuentes citadas (Wikipedia, artículo de *Communications of the ACM* de Joe Armstrong, paper HOPL III) y se confirmó que corresponden a fuentes verificables. Pendiente: consultar con el docente si se exige mayor proporción de fuentes académicas indexadas frente a blogs. |
| 2 | Se preguntó cómo agregar una imagen al trabajo y si existía "una forma especial" para que se vea bien. | La IA explicó la diferencia entre insertar una imagen con sintaxis Markdown simple (`![alt](ruta)`, sin control de tamaño) y usar HTML embebido (`<p align="center"><img src="..." width="600"></p>`) para centrarla y controlar el tamaño dentro de GitHub. Entregó los pasos en una tarjeta numerada. | Se siguieron los pasos manualmente en GitHub y se verificó con la pestaña **Preview** antes de hacer commit, tal como se indicó. |
| 3 | Se pidió directamente que la IA agregara las imágenes al repositorio. | La IA aclaró que **no tiene acceso directo** al repositorio de GitHub (no hay un conector configurado para ello) y que no puede subir archivos por sí misma. En su lugar, preparó los dos archivos de imagen con nombres ya normalizados (`linea-tiempo-erlang.png`, `infografia-erlang.png`) listos para descargar y subir manualmente. | Se descargaron y se subieron manualmente a la carpeta `img/` del repositorio, confirmando la limitación real de la herramienta. |
| 4 | Se preguntó cómo guardar el trabajo actual (sin las imágenes insertadas todavía) para no perderlo, y continuar después. | La IA explicó el flujo de `Commit changes...` en GitHub: escribir un mensaje de commit descriptivo, confirmar el commit directo a la rama `main`, y cómo retomar la edición más tarde sin perder el avance. | Se aplicó el commit intermedio como se indicó; el historial de commits del repositorio sirve como evidencia de este paso. |
| 5 | Se solicitó ayuda para redactar este mismo anexo (`anexo.md`), pidiendo una bitácora y la forma de estructurarla. | La IA generó este documento, basando la bitácora en los prompts reales de la conversación (no en ejemplos inventados) y agregando una plantilla de reflexión crítica. | Revisión y ajuste final por parte del estudiante antes de subirlo al repositorio. |

---

## 3. Reflexión crítica

### 3.1 ¿Ayudó el uso de la IA?

Sí, de forma significativa en dos frentes concretos:

- **Estructuración y redacción técnica:** el LLM ayudó a organizar la investigación en secciones claras (introducción, desarrollo técnico, conclusiones, bibliografía), lo que habría tomado bastante más tiempo hacer manualmente desde cero, especialmente el formateo en Markdown con tablas y anclas de navegación.
- **Soporte operativo con la herramienta (GitHub):** más allá del contenido, el LLM funcionó como guía paso a paso para tareas técnicas del flujo de trabajo (subir imágenes, insertarlas con buen tamaño, hacer commits intermedios sin perder el avance), lo cual redujo errores de manipulación del repositorio.

### 3.2 ¿Hubo sesgos o errores?

- **Limitación de acceso reconocida por la propia herramienta:** cuando se le pidió subir las imágenes directamente al repositorio, la IA fue explícita en que no podía hacerlo por no tener un conector de GitHub habilitado, en lugar de simular que sí lo había hecho. Esto se valora positivamente como transparencia, pero también evidencia que **el estudiante sigue siendo responsable de la ejecución final** de las acciones sobre el repositorio.
- **Cifra polémica del AXD301 ("nueve nueves"):** la propia investigación, apoyada en fuentes secundarias, señala que esta cifra de disponibilidad (99.9999999%) proviene de una presentación comercial y que el propio Joe Armstrong, en su tesis doctoral, reconoció que no hubo una recolección sistemática de esos datos. La IA incluyó esta salvedad de forma proactiva en el desarrollo técnico, evitando presentar como un hecho absoluto un dato que en la comunidad técnica es debatido.
- **Predominancia de fuentes divulgativas (blogs, Medium) sobre fuentes estrictamente académicas:** la bibliografía combina un paper académico (HOPL III) y un artículo de *Communications of the ACM* con varias entradas de blogs técnicos. Es una limitación real del ecosistema de información disponible sobre este tema específico, no exclusivamente de la IA, pero requiere criterio humano para decidir si se ajusta al rigor exigido por la materia.

### 3.3 Conclusión de la reflexión

El uso del LLM funcionó como un **asistente de investigación y de flujo de trabajo**, no como sustituto del criterio del estudiante: aceleró la redacción y la resolución de dudas técnicas sobre GitHub/Markdown, pero la verificación de fuentes, la decisión final sobre qué contenido conservar y la ejecución de las acciones sobre el repositorio (subir imágenes, hacer commits) quedaron siempre a cargo del estudiante.
