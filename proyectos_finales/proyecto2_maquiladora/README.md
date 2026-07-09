# Proyecto 2 — Asignación de Turnos en Línea de Ensamble (Maquiladora)

## Descripción

Tijuana concentra más de **700 plantas maquiladoras** — Samsung, Hyundai, Toyota,
Honeywell, Plantronics — que producen electrónicos, autopartes y dispositivos médicos.
Cada planta asigna operadores a estaciones de trabajo por turno: un problema de
satisfacción de restricciones (CSP) idéntico en estructura al que resuelve Google
OR-Tools en producción.

Este proyecto construye el motor de asignación con CLP(FD) en Prolog y el gestor
de estado del turno con Clojure.

---

## Dominio

| Entidad | Cantidad | Notas |
|---------|----------|-------|
| Puestos de trabajo | 8 | Algunos requieren estación especializada |
| Estaciones básicas | 4 | Ensamble general |
| Estaciones especializadas | 2 | PCB / soldadura — solo operadores certificados |
| Bloques de turno | 6:00–22:00, bloques de 1 h | Descanso obligatorio 13:00–14:00 |

## Puestos (turno matutino — plan de producción)

| Clave | Puesto | Horas | Requiere estación especializada |
|-------|--------|-------|--------------------------------|
| `ensamble_pcb` | Ensamble de tarjetas PCB | 5 | Sí |
| `soldadura` | Soldadura por ola | 5 | Sí |
| `inspeccion_calidad` | Inspección y control de calidad | 4 | No |
| `empaque` | Empaque y etiquetado | 4 | No |
| `logistica` | Surtido de materiales | 5 | No |
| `capacitacion` | Capacitación en planta | 2 | No |
| `mantenimiento` | Mantenimiento preventivo | 4 | No |
| `control_inventario` | Control de inventario | 3 | No |

---

## Arquitectura

```
capa1/planificador.pl     ← CLP(FD): asignación estación+bloque sin conflictos
capa1/tests_horarios.pl   ← plunit: verificar ausencia de conflictos

capa2/horario_server.clj  ← atom: estado del turno; historial de asignaciones
```

---

## Ejecutar

```bash
# Capa 1 — encontrar asignación válida e imprimirla
swipl -g "use_module(capa1/planificador), asignar_turno(A), imprimir_turno(A), halt"

# Capa 1 — tests
swipl -g "run_tests(maquiladora), halt" -l capa1/tests_horarios.pl

# Capa 2 — demo Clojure
clojure -M capa2/horario_server.clj
```

---

## Conexión con la industria

Las plantas maquiladoras en Baja California resuelven este problema cada turno:
- **Samsung Tijuana** — 3 turnos × ~2,000 operadores × 150+ estaciones
- **Honeywell Mexicali** — asignación de técnicos certificados a líneas de sensores
- **Herramientas industriales equivalentes:** Google OR-Tools, IBM CP Optimizer, SAP APO

Lo que construyes en `planificador.pl` es el núcleo de esos sistemas.

---

## Entregables

1. `capa1/planificador.pl` — encuentra asignación válida en < 5 segundos
2. `capa1/tests_horarios.pl` — todos los tests pasando
3. `capa2/horario_server.clj` — estado del turno con historial inmutable
4. README actualizado con la asignación encontrada (tabla impresa)
