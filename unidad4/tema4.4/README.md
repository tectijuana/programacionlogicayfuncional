# Tema 4.4 — Proyecto Final Multi-paradigma

## Sistema de Gestión de Trámites TecNM

### Descripción

Desarrollar un sistema que integra los tres paradigmas del curso para gestionar
solicitudes de trámites estudiantiles del TecNM:

- **Programación Lógica (Prolog):** validación declarativa de reglas de negocio
- **Programación Funcional (Erlang/OTP o Clojure):** procesamiento y supervisión
- **Tipos estáticos o streams (Haskell o Elixir):** generación de reportes con garantías de tipo

### Arquitectura

```
validador.pl          ← Reglas de elegibilidad (Prolog)
    └── reglas_negocio.pl  ← Prioridades y restricciones CLP(FD)
        └── tests.pl       ← Suite de pruebas con plunit

(Capa 2: opcional para crédito extra)
sensor_tramites.erl   ← GenServer que recibe solicitudes (Erlang/OTP)
    └── tramite_sup.erl   ← Supervisor de procesos de trámite
```

### Trámites implementados

| Trámite | Requisito promedio | Créditos mínimos | Sin adeudo |
|---------|-------------------|-----------------|------------|
| `beca` | ≥ 8.0 | ≥ 60 | Sí |
| `titulacion` | ≥ 7.0 | ≥ 240 | Sí |
| `cambio_carrera` | ≥ 6.0 | ≥ 30 | Sí |
| `baja_temporal` | Sin mínimo | Sin mínimo | Sin mínimo |

### Ejecutar

```bash
# Tests automáticos
swipl -g "run_tests(tramites), halt" -l proyecto_final/tests.pl

# Interactivo
swipl -l proyecto_final/validador.pl
?- puede_solicitar(garcia_lopez, beca, R).
?- puede_solicitar(perez_ruiz, titulacion, R).
?- falta_requisito(sanchez_vega, beca, Falta).
```

### Entregables

1. `validador.pl` y `reglas_negocio.pl` — con documentación de aridad/determinismo
2. `tests.pl` — todos los tests pasando (`run_tests.` = 0 fallos)
3. **Crédito extra:** capa Erlang/OTP con GenServer que recibe y valida trámites

### Rúbrica

| Criterio | Peso |
|----------|------|
| `run_tests.` pasa sin fallos | 30% |
| Documentación de aridad y determinismo | 20% |
| CLP(FD) usado para al menos una restricción numérica | 20% |
| Casos borde cubiertos en tests | 20% |
| Capa Erlang/OTP funcional (crédito extra) | +10% |

### Fecha de entrega

Última semana del semestre — demostración en vivo en clase.
El sistema debe correr sin modificaciones en el equipo del profesor.

---

## Lectura de actualización

La validación declarativa que construyes aquí es la mitad simbólica de las
arquitecturas neuro-simbólicas actuales: un LLM interpreta la solicitud en
lenguaje natural y un motor Prolog como el tuyo decide, con reglas trazables,
si el trámite procede. Ver el anexo de investigación del curso:
[Prolog y LLMs: aproximación neuro-simbólica](../../research/Prolog%20large%20language%20models%20neuro-symbolic/readme.md).
