# Anexo: Bitácora de uso de IA (LLM)

## Herramienta utilizada
Claude (Anthropic)

## Prompt 1
**Prompt:** "Ayúdame a investigar sobre tuplas y registros, 
explicando qué son, para qué sirven y en qué se diferencian de las clases, 
con ejemplos de código."

**Resultado obtenido:** Una explicación general de tuplas como estructuras 
ligeras para agrupar valores, de records como tipos con igualdad basada en 
valores e inmutabilidad (uso de `with`), y una comparación con clases 
tradicionales, incluyendo ejemplos de sintaxis en C#.

**¿Lo usaste tal cual o lo modificaste?** Reescribí las explicaciones, verifiqué los ejemplos de código compilándolos, y 
agregué mi propio ejemplo del resumen de ventas para hacerlo más concreto.

## Prompt 2
**Prompt:** "Dame ejemplos de código donde un método regrese varios 
valores usando tuplas"

**Resultado obtenido:** Ejemplos del método `Calcular(a, b)` devolviendo 
suma y resta como tupla nombrada, y su descomposición con `var (suma, resta) = ...`

**¿Lo usaste tal cual o lo modificaste?** Probé el código en mi entorno 
para confirmar que compilaba correctamente antes de incluirlo.

## Prompt 3
**Prompt:** "Explícame la diferencia entre igualdad por referencia e 
igualdad por valores, y cómo se comportan los records en ese sentido."

**Resultado obtenido:** Explicación de que los records comparan contenido 
en vez de identidad de objeto, con el ejemplo de `estudiante1 == estudiante2`.

**¿Lo usaste tal cual o lo modificaste?** Verifiqué el comportamiento 
ejecutando el código yo misma para confirmar que el resultado era `True`.

## Reflexión crítica

- **¿Ayudó la IA en esta investigación?** Sí, principalmente para 
estructurar el tema y generar ejemplos de código de forma rápida, lo cual 
me permitió enfocarme en entender los conceptos en vez de solo buscar 
sintaxis.

- **¿Notaste algún sesgo?** La IA tiende a apoyarse fuertemente en la 
documentación oficial de Microsoft, lo cual es positivo para precisión, 
pero puede dar una visión limitada de cómo otros lenguajes (como F# o 
Python) manejan conceptos similares.

- **¿Qué verificaste manualmente?** Confirmé cada ejemplo de código 
compilándolo en mi propio entorno de C#, y contrasté las explicaciones 
con la documentación oficial de Microsoft Learn citada en la bibliografía.

## Conclusión

La IA fue útil como punto de partida para organizar la investigación y 
generar ejemplos de código, pero el contenido final requirió revisión, 
verificación de que el código compilara, y reescritura para asegurar que 
reflejara mi propio entendimiento del tema y no solo una copia de lo 
generado.
