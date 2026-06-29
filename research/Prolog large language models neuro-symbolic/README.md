# Anexo 1. Prolog y modelos de lenguaje grandes: una aproximacion neuro-simbolica para la programacion logica moderna

## Resumen

Este anexo presenta una investigacion academica introductoria sobre la relacion entre Prolog, los modelos de lenguaje grandes (LLM, por sus siglas en ingles) y la inteligencia artificial neuro-simbolica. La pregunta central es si existe actualmente un "Prolog con LLM". La respuesta corta es que no existe un estandar dominante que fusione ambos enfoques como un solo lenguaje de programacion; sin embargo, si existe una linea de investigacion y desarrollo muy activa donde los LLM se combinan con motores simbolicos, sistemas de reglas, solucionadores de restricciones y lenguajes logicos como Prolog.

En este enfoque, el LLM se utiliza para interpretar lenguaje natural, generar consultas, explicar resultados y asistir al estudiante o programador. Prolog, por su parte, mantiene el papel de motor formal: representa hechos, reglas, restricciones y consultas ejecutables. La combinacion es relevante para la ensenanza de Programacion Logica y Funcional porque permite mostrar a los estudiantes una aplicacion contemporanea de los paradigmas declarativos: los LLM pueden hablar con fluidez, pero Prolog puede verificar reglas de manera explicita y trazable.

**Palabras clave:** Prolog, LLM, inteligencia artificial neuro-simbolica, programacion logica, razonamiento simbolico, reglas, restricciones, educacion en computacion.

## 1. Introduccion

La programacion logica nacio en el contexto de la inteligencia artificial clasica, la demostracion automatica de teoremas, el procesamiento de lenguaje natural y la representacion formal del conocimiento. Prolog, creado en la decada de 1970, permite expresar un problema mediante hechos y reglas, y resolverlo por medio de consultas. A diferencia de los lenguajes imperativos, el programador no describe paso a paso como llegar al resultado, sino que declara relaciones logicas.

Los modelos de lenguaje grandes representan una corriente distinta de la inteligencia artificial. En lugar de partir de reglas explicitas, aprenden patrones estadisticos a partir de grandes volumenes de texto y codigo. Esto les permite generar explicaciones, sintetizar programas, traducir entre lenguajes y responder preguntas en lenguaje natural. Sin embargo, los LLM tambien presentan limitaciones importantes: pueden producir respuestas plausibles pero incorrectas, inventar referencias, cometer errores logicos y tener dificultades para garantizar consistencia formal.

La integracion entre Prolog y LLM resulta relevante porque ambos enfoques se complementan. Prolog es preciso, verificable y explicito, pero exige que el usuario formule reglas y consultas con sintaxis formal. Un LLM es flexible, conversacional y accesible, pero no garantiza por si mismo que sus conclusiones sean logicamente validas. Por ello, una arquitectura hibrida puede usar el LLM como interfaz de lenguaje natural y Prolog como motor de razonamiento.

## 2. Pregunta de investigacion

La pregunta que guia este anexo es:

> Existe actualmente un Prolog con LLM?

La respuesta requiere distinguir entre tres posibilidades:

1. **Un nuevo lenguaje llamado "Prolog con LLM"**: no existe como estandar ampliamente adoptado.
2. **Integraciones practicas entre Prolog y LLM**: si existen y pueden construirse con herramientas actuales.
3. **Investigacion neuro-simbolica que combina modelos neuronales con razonamiento simbolico**: si existe y es una linea activa de investigacion.

Por lo tanto, la forma mas correcta de explicar el tema a estudiantes es:

> No existe un unico "Prolog con LLM" como lenguaje oficial, pero si existen arquitecturas donde un LLM interpreta lenguaje natural y delega la verificacion logica a Prolog o a otros motores simbolicos.

## 3. Marco teorico

### 3.1 Prolog como lenguaje logico

Prolog se basa en la logica de predicados de primer orden. Un programa Prolog esta compuesto por hechos, reglas y consultas. Por ejemplo:

```prolog
requisito(titulacion, servicio_social).
requisito(titulacion, creditos_completos).

cumple(ana, servicio_social).
cumple(ana, creditos_completos).

puede_titularse(Alumno) :-
    cumple(Alumno, servicio_social),
    cumple(Alumno, creditos_completos).
```

La consulta:

```prolog
?- puede_titularse(ana).
```

no solicita al sistema una opinion, sino una demostracion basada en hechos y reglas disponibles. Esta propiedad hace que Prolog sea especialmente util para sistemas expertos, validacion de reglas, analisis de dependencias, planificacion, busqueda, diagnostico y programacion con restricciones.

### 3.2 Modelos de lenguaje grandes

Un LLM es un modelo neuronal entrenado para predecir, transformar y generar lenguaje. En programacion, los LLM pueden ayudar a escribir codigo, explicar errores, generar pruebas, documentar funciones y convertir instrucciones en lenguaje natural a fragmentos de codigo.

No obstante, un LLM no ejecuta necesariamente una prueba formal de sus respuestas. Aunque puede producir pasos de razonamiento, esos pasos pueden ser incompletos o incorrectos. En un contexto academico, esta limitacion debe explicarse con claridad: un LLM puede ser una herramienta de asistencia, pero no sustituye la verificacion formal cuando el problema requiere precision logica.

### 3.3 Inteligencia artificial neuro-simbolica

La inteligencia artificial neuro-simbolica busca combinar dos enfoques:

- **Neuronal:** modelos estadisticos capaces de aprender patrones, interpretar lenguaje natural y generalizar a partir de datos.
- **Simbolico:** sistemas basados en reglas, logica, restricciones, grafos de conocimiento, demostradores y solucionadores formales.

La arquitectura MRKL, propuesta por Karpas et al. (2022), es un ejemplo importante de este enfoque. En lugar de pedir que un solo modelo resuelva todo, se propone un sistema modular donde el modelo de lenguaje puede invocar fuentes de conocimiento externas y modulos de razonamiento discreto.

En terminos educativos, esto permite explicar a los estudiantes que un sistema inteligente moderno no tiene que depender exclusivamente de redes neuronales. Tambien puede incorporar reglas, bases de conocimiento, consultas logicas y validacion formal.

## 4. Arquitectura propuesta: LLM como interfaz, Prolog como motor

Una arquitectura sencilla para combinar LLM y Prolog puede expresarse asi:

```text
Usuario en lenguaje natural
        |
        v
LLM interpreta la intencion
        |
        v
Generacion de hechos, reglas o consulta Prolog
        |
        v
Motor Prolog ejecuta inferencia logica
        |
        v
Resultado formal: verdadero, falso, soluciones o contradicciones
        |
        v
LLM explica el resultado en lenguaje natural
```

La separacion de responsabilidades es fundamental:

| Componente | Funcion principal | Riesgo si se usa solo |
|-----------|-------------------|------------------------|
| LLM | Interpretar lenguaje natural, generar explicaciones, asistir al usuario | Puede alucinar o justificar una respuesta incorrecta |
| Prolog | Evaluar reglas, resolver consultas, verificar restricciones | Requiere conocimiento tecnico y sintaxis formal |
| Sistema hibrido | Combinar accesibilidad conversacional con razonamiento verificable | Requiere validacion de la traduccion entre lenguaje natural y logica |

## 5. Ejemplo academico: asistente de titulacion TecNM

Este ejemplo no afirma que TecNM use Prolog o LLM para procesos reales. Es un modelo didactico inspirado en reglas academicas, util para ensenar programacion logica.

### 5.1 Base de conocimiento en Prolog

```prolog
% requisito/2
% requisito(Proceso, Requisito).
requisito(titulacion, creditos_completos).
requisito(titulacion, servicio_social).
requisito(titulacion, residencia_profesional).
requisito(titulacion, ingles_acreditado).

% cumple/2
% cumple(Alumno, Requisito).
cumple(ana, creditos_completos).
cumple(ana, servicio_social).
cumple(ana, residencia_profesional).
cumple(ana, ingles_acreditado).

cumple(luis, creditos_completos).
cumple(luis, servicio_social).

% puede_titularse/1
% Deterministico si el alumno esta completamente especificado.
puede_titularse(Alumno) :-
    requisito(titulacion, Requisito),
    \+ cumple(Alumno, Requisito),
    !,
    fail.

puede_titularse(_Alumno).

% requisito_pendiente/2
% Puede generar todos los requisitos pendientes de un alumno.
requisito_pendiente(Alumno, Requisito) :-
    requisito(titulacion, Requisito),
    \+ cumple(Alumno, Requisito).
```

### 5.2 Interaccion esperada con LLM

Entrada del estudiante:

```text
Luis ya tiene creditos completos y servicio social. Puede titularse?
```

Tarea del LLM:

```prolog
?- puede_titularse(luis).
```

Resultado de Prolog:

```text
false.
```

Consulta complementaria:

```prolog
?- requisito_pendiente(luis, R).
```

Resultado:

```text
R = residencia_profesional ;
R = ingles_acreditado.
```

Respuesta en lenguaje natural:

```text
Luis todavia no puede titularse segun las reglas del modelo.
Le faltan residencia profesional e ingles acreditado.
```

Este ejemplo muestra por que la combinacion es poderosa: el LLM hace la experiencia conversacional, pero Prolog conserva la responsabilidad de la conclusion logica.

## 6. Aplicaciones posibles en el curso

### 6.1 Verificador de reglas academicas

Un proyecto puede modelar reglas de avance academico, prerequisitos de materias, servicio social, residencia profesional o titulacion. El LLM traduce preguntas del estudiante a consultas Prolog, y Prolog devuelve respuestas verificables.

### 6.2 Asistente para depuracion de Prolog

La investigacion reciente en ProDebug muestra el interes por combinar LLMs con tecnicas tradicionales de depuracion para apoyar tareas de Prolog en contextos educativos. Este tipo de herramienta puede analizar envios de estudiantes, detectar fallas y sugerir reparaciones. Para un curso universitario, esto abre la posibilidad de retroalimentacion automatizada, aunque siempre con supervision docente.

### 6.3 Generador de ejercicios

Un LLM puede ayudar a generar enunciados, casos de prueba y variaciones de ejercicios. Prolog puede servir como solucion de referencia para validar si las respuestas cumplen las reglas esperadas.

### 6.4 Sistemas expertos explicables

Los sistemas expertos clasicos son una aplicacion natural de Prolog. Al integrarlos con LLM, se puede construir una interfaz conversacional que explique reglas, pregunte datos faltantes y presente conclusiones en lenguaje claro.

Ejemplos didacticos:

- Diagnostico academico de prerequisitos.
- Elegibilidad para becas.
- Validacion de CURP o RFC mediante reglas.
- Planeacion de horarios con restricciones.
- Asignacion de turnos en una maquiladora.
- Revision de cumplimiento documental en tramites simulados.

## 7. Ventajas academicas de integrar LLM y Prolog

La integracion tiene valor pedagogico porque permite contrastar dos formas de inteligencia artificial:

| Aspecto | LLM | Prolog |
|--------|-----|--------|
| Entrada natural | Alta | Baja |
| Explicacion verbal | Alta | Media |
| Verificacion formal | Baja o variable | Alta |
| Trazabilidad de reglas | Baja | Alta |
| Manejo de ambiguedad | Alto | Bajo |
| Consistencia logica | No garantizada | Depende de reglas explicitas |
| Valor didactico | Motiva y asiste | Forma pensamiento declarativo |

El estudiante aprende que no toda inteligencia artificial debe entenderse como prediccion estadistica. Tambien existen sistemas donde el conocimiento se representa explicitamente y las respuestas se obtienen por inferencia.

## 8. Riesgos y limitaciones

La combinacion LLM + Prolog tambien presenta riesgos:

1. **Traduccion incorrecta:** el LLM puede convertir mal una instruccion en lenguaje natural a una regla Prolog.
2. **Reglas incompletas:** Prolog solo puede razonar con los hechos y reglas disponibles.
3. **Falsa confianza:** una explicacion generada por LLM puede sonar convincente aunque la consulta sea incorrecta.
4. **Ambiguedad normativa:** reglamentos academicos o administrativos pueden tener excepciones dificiles de modelar.
5. **Dependencia tecnologica:** usar APIs externas puede introducir costos, privacidad y problemas de disponibilidad.

Por estas razones, en un entorno educativo se recomienda que los estudiantes documenten:

- que reglas fueron modeladas;
- que supuestos se hicieron;
- que consultas fueron probadas;
- que casos limite se detectaron;
- que parte resolvio Prolog y que parte redacto el LLM.

## 9. Propuesta de actividad para el curso

### Titulo

**Asistente neuro-simbolico para reglas academicas**

### Objetivo

Construir un prototipo donde un LLM reciba preguntas en lenguaje natural y las traduzca a consultas Prolog, mientras Prolog evalua las reglas y devuelve resultados verificables.

### Componentes minimos

1. Base de conocimiento Prolog con al menos 15 hechos.
2. Al menos 6 reglas con predicados documentados.
3. Consultas de prueba para casos verdaderos, falsos y ambiguos.
4. Interfaz simple por consola o notebook.
5. Reporte donde se explique la separacion entre LLM y Prolog.

### Criterios de evaluacion sugeridos

| Criterio | Porcentaje |
|---------|------------|
| Correcta representacion de hechos y reglas | 25% |
| Consultas Prolog funcionales y probadas | 25% |
| Claridad de la arquitectura LLM + Prolog | 20% |
| Manejo de errores, ambiguedad y casos limite | 15% |
| Documentacion academica y reflexion critica | 15% |

## 10. Discusion

La combinacion entre LLM y Prolog es una forma concreta de presentar la relevancia actual de la programacion logica. En muchos cursos, Prolog se percibe como un lenguaje historico o academico. Sin embargo, cuando se conecta con LLMs, sistemas expertos, validacion de reglas y razonamiento neuro-simbolico, se vuelve evidente que los principios declarativos siguen siendo vigentes.

Desde el punto de vista de ingenieria, el valor principal de Prolog no es competir con los LLM en generacion de texto, sino actuar como componente verificable dentro de sistemas inteligentes. Un LLM puede ser excelente para interactuar con usuarios, pero un motor logico es mas adecuado para determinar si una conclusion se deriva de reglas explicitas.

Esta distincion es especialmente importante para estudiantes de Ingenieria en Sistemas Computacionales. La industria no necesita solamente programadores que sepan invocar modelos de IA; necesita ingenieros capaces de disenar sistemas confiables, auditablemente correctos y mantenibles. La programacion logica ofrece herramientas conceptuales para ese objetivo.

## 11. Conclusion

No existe actualmente un "Prolog con LLM" como lenguaje unico, estandarizado y dominante. Lo que existe es algo mas interesante desde el punto de vista academico: arquitecturas hibridas donde los LLM se integran con motores simbolicos, solucionadores de restricciones y lenguajes logicos como Prolog.

Para el curso de Programacion Logica y Funcional, este tema puede incorporarse como anexo, lectura complementaria o proyecto final. Su valor pedagogico esta en mostrar que la programacion logica no pertenece solamente a la historia de la inteligencia artificial, sino que puede formar parte de sistemas modernos donde se requiere combinar lenguaje natural, reglas explicitas, validacion formal y explicabilidad.

La idea central para los estudiantes puede resumirse asi:

> El LLM facilita la conversacion; Prolog verifica la logica. Juntos permiten construir sistemas mas utiles, explicables y confiables.

## Referencias

- Karpas, E., Abend, O., Belinkov, Y., et al. (2022). *MRKL Systems: A modular, neuro-symbolic architecture that combines large language models, external knowledge sources and discrete reasoning*. arXiv. https://arxiv.org/abs/2205.00445
- Brancas, R., Manquinho, V., & Martins, R. (2026). *ProDebug: An Automated Debugging System for Prolog*. arXiv. https://arxiv.org/abs/2605.27124
- Wielemaker, J., Schrijvers, T., Triska, M., & Lager, T. (2010). *SWI-Prolog*. arXiv. https://arxiv.org/abs/1011.5332
- Wielemaker, J., Lager, T., & Riguzzi, F. (2015). *SWISH: SWI-Prolog for Sharing*. arXiv. https://arxiv.org/abs/1511.00915
- Sullivan, R., & Elsayed, N. (2024). *Can Large Language Models Act as Symbolic Reasoners?* arXiv. https://arxiv.org/abs/2410.21490
- Fang, M., Deng, S., Zhang, Y., et al. (2024). *Large Language Models Are Neurosymbolic Reasoners*. arXiv. https://arxiv.org/abs/2401.09334
- Chen, X., Lin, M., Scharli, N., & Zhou, D. (2023). *Teaching Large Language Models to Self-Debug*. arXiv. https://arxiv.org/abs/2304.05128
- Riaza Valverde, J. A. (2023). *Tau Prolog: A Prolog interpreter for the Web*. arXiv. https://arxiv.org/abs/2308.11897
