# Investigación y actualización del curso

Este directorio recopila las investigaciones académicas que mantienen el curso
actualizado frente al estado del arte. Cada anexo es un documento autocontenido
con resumen, marco teórico, hallazgos y referencias, pensado para lectura
complementaria de los estudiantes y como evidencia de renovación de la propuesta.

## Anexos

| # | Documento | Tema | Conexión con el curso |
|---|-----------|------|----------------------|
| 1 | [Prolog y modelos de lenguaje grandes: aproximación neuro-simbólica](Prolog%20large%20language%20models%20neuro-symbolic/readme.md) | ¿Existe un "Prolog con LLM"? Integración de motores lógicos con LLMs: el LLM como interfaz de lenguaje natural, Prolog como motor de razonamiento verificable | Unidad 3 (tema 3.5, aplicaciones de PL) y Unidad 4 (tema 4.4, casos de estudio) |
| 2 | [Erlang/OTP y LLMs: arquitectura tolerante a fallos](Gateway%20LLM%20tolerante%20a%20fallos%20con%20Erlang/README.md) | ¿Existe un "Erlang con LLM"? Gateway OTP para orquestar servicios LLM: supervisión, timeouts, reintentos, aislamiento de fallos | Unidad 2 (tema 2.5, aplicaciones FP y OTP) |

## Idea común de ambos anexos

Ninguno de los dos existe como "lenguaje nuevo"; lo que existe — y es la lección
para el estudiante — es la **complementariedad**: los LLM aportan fluidez
conversacional y generativa, mientras los paradigmas declarativos del curso
aportan lo que los LLM no garantizan por sí mismos: razonamiento verificable
(Prolog) e infraestructura confiable en producción (Erlang/OTP).
