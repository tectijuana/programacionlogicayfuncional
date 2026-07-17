# Tema 3.5 — Aplicaciones: Sistema Experto de Diagnóstico

## Objetivo

Construir un sistema experto educativo que demuestre: base de conocimiento
declarativa, reglas de inferencia, `assert/retract` para aprendizaje incremental,
e interfaz de texto interactiva.

## AVISO IMPORTANTE

> Este sistema es **exclusivamente educativo**. No sustituye ni reemplaza
> el diagnóstico médico profesional. Para cualquier problema de salud,
> consultar a un médico certificado.

## Ejecutar

```bash
# Iniciar la interfaz interactiva
swipl -g iniciar -l sistema_experto/interfaz.pl

# Solo cargar la base de conocimiento (modo consulta directa)
swipl -l sistema_experto/diagnostico.pl
?- diagnostico_posible(p1, Diagnosticos).
?- agregar_sintoma(nuevo_paciente, fiebre), agregar_sintoma(nuevo_paciente, tos).
?- diagnostico_posible(nuevo_paciente, D).
```

## Arquitectura del sistema

```
interfaz.pl          ← entrada/salida, flujo de conversación
    └── diagnostico.pl  ← base de conocimiento, reglas de inferencia
```

## Conceptos demostrados

| Concepto Prolog | Dónde se usa |
|----------------|--------------|
| `assert/retract` | `agregar_sintoma/2`, `limpiar_paciente/1` |
| `findall/3` | `diagnostico_posible/2` — todos los diagnósticos |
| Reglas con múltiples antecedentes | `diagnostico/2` — síntomas → condición |
| `read/1` y `write/1` | Interfaz de texto |
| `format/2` | Salida formateada |

## Extensiones propuestas

1. Agregar probabilidades: `diagnostico(P, Cond, Prob)` basado en cuántos síntomas coinciden
2. Preguntar síntomas en orden de relevancia (más discriminantes primero)
3. Exportar historial del paciente a archivo con `open/3`, `write/2`
4. Agregar más condiciones: COVID-19, dengue, chikungunya
5. Integrar con base de datos SQL usando el predicado ODBC de SWI-Prolog

---

## Lectura de actualización — sistemas expertos en la era de los LLM

Un LLM puede conversar con el paciente con más fluidez que `read/1`, pero no
garantiza que su diagnóstico siga reglas verificables — puede inventar. La línea
de investigación neuro-simbólica combina ambos: el LLM como interfaz de lenguaje
natural y Prolog como motor de razonamiento trazable, exactamente el rol de
`diagnostico.pl` en este tema. Ver el anexo de investigación del curso:
[Prolog y LLMs: aproximación neuro-simbólica](../../research/Prolog%20large%20language%20models%20neuro-symbolic/readme.md).
