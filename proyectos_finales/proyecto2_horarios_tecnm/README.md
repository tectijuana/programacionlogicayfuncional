# Proyecto 2 — Planificador de Horarios TecNM

## Descripción

Cada semestre, los coordinadores de carrera en el TecNM asignan materias, salones
y horarios. Es un problema de satisfacción de restricciones (CSP): muchas variables
(materia, docente, salón, hora) y muchas restricciones (no traslaparse, laboratorio
solo en aulas equipadas, respetar carga horaria del docente).

Este proyecto lo resuelve con CLP(FD) en Prolog para la búsqueda de soluciones y
Clojure para gestionar el estado del horario en producción.

---

## Dominio

| Entidad | Cantidad | Restricciones |
|---------|----------|---------------|
| Materias ISC (7° semestre) | 8 | Cada una tiene carga horaria fija |
| Docentes | 5 | Máximo 20 h/semana, sin traslape |
| Salones | 4 aulas + 2 laboratorios | Lab solo para materias prácticas |
| Bloques horarios | 7:00–21:00, bloques de 1 h | Descanso 13:00–14:00 obligatorio |

---

## Materias del semestre (plan ISC TecNM)

| Clave | Materia | Horas/sem | Requiere laboratorio |
|-------|---------|-----------|---------------------|
| `plf`    | Programación Lógica y Funcional | 5 | Sí |
| `bd`     | Bases de Datos Avanzadas        | 5 | Sí |
| `redes`  | Redes de Computadoras           | 4 | No |
| `so`     | Sistemas Operativos             | 4 | No |
| `ia`     | Inteligencia Artificial         | 5 | Sí |
| `etica`  | Ética Profesional               | 2 | No |
| `ing_sw` | Ingeniería de Software          | 4 | No |
| `arq`    | Arquitectura de Computadoras    | 3 | No |

---

## Arquitectura

```
capa1/planificador.pl      ← CLP(FD): asignación sala+hora sin conflictos
capa1/restricciones.pl     ← dominio de variables y restricciones globales
capa1/tests_horarios.pl    ← plunit: verificar ausencia de conflictos

capa2/horario_state.clj    ← atom: estado del horario actual
capa2/horario_server.clj   ← gestión de asignaciones, historial de cambios
```

---

## Ejecutar

```bash
# Capa 1 — encontrar una asignación válida
swipl -g "use_module(planificador), asignar_horario(H), imprimir_horario(H), halt"

# Capa 1 — tests
swipl -g "run_tests(horarios), halt" -l capa1/tests_horarios.pl

# Capa 2 — REPL Clojure
clj -M capa2/horario_server.clj
```

---

## Entregables

1. `capa1/planificador.pl` — encuentra al menos una asignación válida en < 5 segundos
2. `capa1/tests_horarios.pl` — tests verifican ausencia de conflictos sala/hora
3. `capa2/` — Clojure con estado del horario, carga desde CSV o mapa
4. README actualizado con la solución encontrada (impresa como tabla)
