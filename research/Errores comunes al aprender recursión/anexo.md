# Anexo — Bitácora de uso de LLM

## Herramienta utilizada

Se utilizó ChatGPT (modelo identificado por la plataforma como gpt-5.6-terra)
como apoyo para planear y revisar la investigación. La redacción final, la
selección de ejemplos y la comprobación local fueron responsabilidad del
estudiante.

## Prompts reales y resultados

### Prompt 1

> Me tocó el tema 29: “Errores comunes al aprender recursión: falta de caso
> base y desbordamiento de pila”. Ayúdame a identificar qué debe contener una
> investigación introductoria de más de 500 palabras y ejemplos seguros en
> Elixir.

**Resultado obtenido.** El asistente propuso separar el trabajo en definición
de recursión, casos base, progreso, recursión de cola, ejemplos y conclusiones.
También sugirió no ejecutar una función deliberadamente incompleta y preferir
un ejemplo que devolviera un error como dato.

### Prompt 2

> Revisa este diseño: una suma directa de lista, una suma con acumulador y una
> división que devuelve `{:error, :division_por_cero}`. ¿Qué casos límite debo
> probar y qué afirmaciones técnicas debo verificar antes de incluirlas?

**Resultado obtenido.** La respuesta recomendó probar `[]`, una lista de un
elemento, un divisor válido y cero. Señaló correctamente que el acumulador hace
que la llamada recursiva quede en posición de cola, pero su afirmación inicial
de que eso garantiza por sí solo memoria constante fue demasiado general.

## Verificación y reflexión crítica

La IA ayudó a convertir el tema en una lista de preguntas revisables y a
encontrar un ejemplo pequeño que muestra tres resultados: valor correcto,
transformación de una lista y error explícito. No se copiaron las respuestas
literalmente. Se revisó el código ejecutándolo con `elixir errores_recursion.exs`
y se contrastó la explicación de la recursión de cola con la documentación de
Erlang/OTP indicada en la bibliografía.

El principal riesgo detectado fue la simplificación excesiva. “Recursión de
cola” describe la posición de una llamada, no demuestra la terminación: una
función puede llamar en cola con el mismo argumento y no terminar. Asimismo, el
uso de memoria depende de la implementación y de las operaciones alrededor de
la llamada; por eso el README habla específicamente de BEAM y evita prometer la
misma característica para todos los lenguajes. La IA tampoco sustituye las
fuentes: los datos técnicos se respaldaron con documentación y bibliografía en
formato IEEE.  
