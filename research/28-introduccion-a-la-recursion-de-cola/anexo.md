## Asistencia de Inteligencia Artificial

### Prompts utilizados

- 2026-09-01:  
  “ayudame a hacer una investigacion de lo siguiente, dime como lo hago y entrego en un repositorio de github, y la investigacion en si. Sigue las instrucciones y luego investiga el tema de Introduccion a la recursion de cola y porque importa.”

- 2026-09-01:  
  Petición adicional para ajustar la investigación según AI_GUIDANCE.md y profundizar en el soporte de recursión de cola en lenguajes funcionales.

### Herramientas utilizadas

- Asistente de lenguaje grande (LLM) accesible vía web.
- Buscador integrado para localizar documentación sobre tail recursion y tail-call optimization.

### Resultados obtenidos

La IA generó:

- Una guía paso a paso para:
  - Crear la carpeta `research/introduccion-a-la-recursion-de-cola/`.
  - Agregar `README.md` y `anexo.md`.
  - Usar el flujo Fork → Pull Request en GitHub sin modificar archivos ajenos.

- Un borrador completo de `README.md` con:
  - Introducción al tema de recursión de cola.
  - Desarrollo técnico mayor a 500 palabras.
  - Ejemplos de código en Haskell, Erlang y Elixir.
  - Discusión sobre tail-call optimization en distintos lenguajes.
  - Bibliografía en formato IEEE basada en fuentes públicas.

- Un borrador de este mismo `anexo.md`, alineado con AI_GUIDANCE.md, que incluía:
  - Descripción de prompts.
  - Reflexión sobre el uso de IA.
  - Énfasis en la necesidad de revisión crítica y verificación independiente.

### Cambios, revisión y validación personal

- Revisé la explicación de recursión de cola y verifiqué la coherencia con definiciones estándar (caso base, llamada de cola, acumuladores).
- Validé la sintaxis base de los ejemplos de código:
  - Verifiqué que la estructura de módulos y funciones en Erlang y Elixir respeta el estilo típico de cada lenguaje.
  - Revisé que las firmas de funciones en Haskell usan tipos consistentes.
- Ajusté partes del texto para:
  - Evitar depender totalmente de la explicación de la IA.
  - Integrar mejor el contexto del curso (bloque funcional, énfasis en paradigmas).
  - Hacer el estilo más propio y uniforme.
- Comprobé que las afirmaciones sobre optimización de recursión de cola se corresponden con documentación de:
  - Wikipedia (Tail call).
  - Artículos introductorios (Ada Beat, Peerdh).
  - Discusiones técnicas en foros especializados.

### Reflexión personal

El uso de la IA me ayudó principalmente a:

- Organizar la estructura del documento (`Introducción`, `Desarrollo técnico`, `Conclusiones`, `Bibliografía`) desde el inicio.
- Localizar rápidamente recursos sobre recursión de cola y tail-call optimization en lenguajes funcionales.
- Generar una primera versión de los ejemplos de código y del formato de las referencias IEEE.

Sin embargo:

- La IA mezcla información de distintos lenguajes y compiladores, por lo que fue necesario revisar qué afirmaciones eran generales y cuáles dependían de un compilador o máquina virtual específica.
- Algunas explicaciones sobre Haskell y pereza pueden ser más matizadas de lo que la respuesta sugería inicialmente, así que preferí mantener solo afirmaciones que pude verificar en fuentes confiables.
- El ejercicio confirmó lo que indica AI_GUIDANCE.md: la IA es una herramienta de apoyo, pero la responsabilidad de entender el contenido y de verificar su exactitud recae en mí. No copié el texto literalmente; hice adaptaciones, recortes y ajustes.

En conclusión, la IA resultó útil para acelerar la fase de borrador y para encontrar fuentes, pero el trabajo final es una síntesis propia revisada a partir de ese material.

- **Fecha de última edición del anexo**: 2026-09-01
- **Plataformas utilizadas**: Navegador web, editor de texto local y Git para control de versiones.
