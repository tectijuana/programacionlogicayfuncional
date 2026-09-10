# Anexo — Bitácora de uso de LLM (Claude)

Este documento registra el uso de un modelo de lenguaje (Claude, de Anthropic) como herramienta de apoyo durante la elaboración del trabajo sobre **Lisp (John McCarthy, 1958)**. Se documentan los prompts reales utilizados, los resultados obtenidos y una reflexión crítica sobre su utilidad, límites y posibles sesgos.

---

## 1. Herramienta utilizada

- **Modelo:** Claude (Anthropic)
- **Uso principal:** generación y estructuración del `README.md` del tema, creación de cuadros comparativos/sinópticos y diagramas de apoyo visual.
- **Uso que NO se le dio:** no se le pidió redactar las conclusiones finales como verdad absoluta ni se copiaron datos sin verificar contra fuentes académicas (ver bibliografía IEEE en el `README.md`).

---

## 2. Registro de prompts y resultados

### Prompt 1 — Estructura inicial del README

**Prompt real:**
> "Necesito estructurar el trabajo de investigación sobre Lisp (John McCarthy, 1958). Ya creé el repositorio y las carpetas correspondientes. Ayúdame a generar primero el archivo README.md en formato Markdown, con una estructura clara, tablas o cuadros informativos, y secciones donde pueda insertar imágenes más adelante."

**Resultado obtenido:** un `README.md` completo con índice, introducción, desarrollo técnico dividido en subsecciones (contexto histórico, cálculo lambda, características técnicas, S-expressions, `eval`/`apply`, legado), una tabla de características, espacios marcados para insertar imágenes, conclusiones y bibliografía en formato IEEE con 5 fuentes.

**Reflexión:** ayudó bastante a organizar la información y a no dejar fuera secciones que pide el trabajo (introducción, desarrollo ≥500 palabras, conclusiones, bibliografía IEEE). El riesgo es que un LLM puede "sonar seguro" aunque no siempre cite bien; por eso se revisó que las referencias de la bibliografía correspondan a fuentes reales y verificables (el paper original de McCarthy de 1960, el artículo de Steele y Gabriel sobre la evolución de Lisp, etc.).

---

### Prompt 2 — Cuadros sinópticos y comparativos

**Prompt real:**
> "Agrega al documento un cuadro sinóptico general del tema y cuadros comparativos que complementen la información técnica ya desarrollada."

**Resultado obtenido:** un cuadro sinóptico en texto (formato árbol) con las 5 categorías del tema (origen, fundamentos, características, impacto, dialectos) y tres tablas comparativas nuevas: Lisp vs. Fortran, paradigma funcional vs. imperativo, y los principales dialectos de Lisp con su año y enfoque.

**Reflexión:** el modelo organizó bien la comparación Lisp–Fortran porque son datos históricos bastante documentados y estables (no cambian con el tiempo), así que el riesgo de error factual es bajo. Aun así, se revisaron manualmente los años y nombres de los dialectos contra lo visto en clase antes de darlos por buenos.

---

### Prompt 3 — Conversión de las sugerencias en diagramas visuales

**Prompt real:**
> "Convierte en un elemento visual la línea de tiempo con los hitos de Lisp (1958, 1960, 1962, 1970s, 1984, 1990s) y también el cuadro sinóptico que se propuso en formato de texto, presentándolo como un diagrama gráfico."

**Resultado obtenido:** dos diagramas generados directamente (SVG interactivo): una línea de tiempo con los 6 hitos históricos de Lisp, y un cuadro sinóptico gráfico con cajas conectadas (nodo central "Lisp 1958" ramificado en 5 categorías).

**Reflexión:** esto ahorró tiempo porque en lugar de usar Canva o draw.io manualmente, el modelo generó el diagrama directo con la información ya organizada del README. La limitación es que estos diagramas se generan como widgets dentro del chat, así que si se quieren meter como imagen fija dentro del `README.md`, hay que exportarlos.

---

### Prompt 4 — Diagrama del intérprete eval/apply

**Prompt real:**
> "Genera también el diagrama de flujo sugerido en el README, que muestre cómo las funciones `eval` y `apply` se llaman mutuamente durante la evaluación de una expresión en Lisp."

**Resultado obtenido:** diagrama de flujo mostrando el ciclo: `Expresión S → eval → apply → Resultado`, con la flecha de retroalimentación que indica que `apply` llama de nuevo a `eval` para evaluar cada argumento.

**Reflexión:** el diagrama refleja correctamente la idea central del paper de McCarthy (que `eval` y `apply` se definen mutuamente), pero es una simplificación pedagógica — no muestra, por ejemplo, el caso de los literales que `eval` puede resolver sin pasar por `apply`. Se aclaró esto directamente en el texto para no dar una impresión incompleta del mecanismo real.

---

## 3. Reflexión crítica general

**¿Ayudó?**
Sí. El LLM fue útil principalmente como herramienta de **organización y estructuración** (formato, tablas, índice, diagramas) y como apoyo para explicar conceptos técnicos de forma clara. Aceleró bastante la parte de redacción y presentación visual del trabajo.

**¿Hubo sesgos o errores?**
No se detectaron errores factuales graves, ya que el tema (historia de Lisp) es información bien documentada y estable en el tiempo. El principal riesgo identificado fue de **simplificación excesiva** en los diagramas (por ejemplo, el diagrama de `eval`/`apply` no cubre todos los casos posibles) y el hecho de que un LLM puede generar contenido con tono muy seguro incluso en detalles menores, por lo que fue necesario contrastar las fechas, nombres de dialectos y referencias bibliográficas con fuentes verificables antes de incluirlas en el trabajo final.

**Conclusión del uso de la herramienta:**
El LLM se usó como asistente de estructuración, redacción y generación de material visual, no como fuente primaria de verdad. La verificación de datos históricos y técnicos se hizo contrastando contra el paper original de McCarthy (1960) y bibliografía académica citada en formato IEEE en el `README.md`.
