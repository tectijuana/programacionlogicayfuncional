# Tema 1.3 — Comparación con Otros Paradigmas
## Assignment: Validador de CURP en Tres Paradigmas

### Objetivo

Implementar exactamente el mismo validador de CURP mexicana en tres paradigmas distintos.
Al terminar, tendrás código ejecutable que te permite comparar de forma concreta —
no abstracta — qué ofrece cada paradigma.

---

### Estructura de la CURP

La CURP (Clave Única de Registro de Población) tiene 18 caracteres con esta estructura:

```
SAOA800115HBCNND05
│││││││││││││││││└─ Dígito verificador (alfanumérico)
││││││││││││││││└── Dígito diferenciador (alfanumérico)
│││││││││││││└──── Primera consonante interna del segundo apellido
││││││││││││└───── Primera consonante interna del primer apellido
│││││││││││└────── Primera consonante interna del nombre
││││││││││└─────── Dos letras del estado de nacimiento
│││││││││└──────── Sexo (H=Hombre, M=Mujer)
││││││││└───────── Día de nacimiento (DD)
│││││││└────────── Mes de nacimiento (MM)
││││││└─────────── Año de nacimiento (AA)
│││││└──────────── Primera vocal interna del primer apellido
││││└───────────── Primera letra del nombre
│││└────────────── Primera letra del segundo apellido
││└─────────────── Primera letra del primer apellido
│└──────────────── Segunda letra del primer apellido
└───────────────── Primera letra del primer apellido (mayúscula)

Estados válidos: AS BC BS CC CL CM CS DF DG GR GT HG JC MC MN MS NT NL OC PL QO QR SP SL SR TC TS TL VZ YN ZS
```

---

### Los tres archivos que debes estudiar (y modificar)

| Archivo | Paradigma | Lenguaje |
|---------|-----------|----------|
| [`curp_imperativo.py`](curp_imperativo.py) | OOP imperativo | Python 3 |
| [`curp_funcional.erl`](curp_funcional.erl) | Funcional | Erlang/OTP |
| [`curp_logico.pl`](curp_logico.pl) | Lógico | SWI-Prolog |

Cada archivo ya contiene una implementación completa y ejecutable.
Tu tarea es leerlos, correrlos, extenderlos y analizarlos.

---

### Cómo correr cada versión

**Python:**
```bash
python3 curp_imperativo.py
```

**Erlang:**
```bash
erlc curp_funcional.erl
erl -noshell -s curp_funcional demo -s init stop
```

**Prolog:**
```bash
swipl -g "demo, halt." curp_logico.pl
# O en REPL:
swipl curp_logico.pl
?- demo.
?- valida_curp('SAOA800115HBCNND05', R).
```

---

### Tu tarea de extensión

Los archivos provistos validan longitud, sexo y estado. **Agrega** a cada versión:

1. Validación del rango de mes (01-12)
2. Validación del rango de día (01-31)
3. Una función/predicado que extraiga e imprima la fecha de nacimiento como `DD/MM/AAAA`

**Regla:** cada extensión debe hacerse respetando el estilo del paradigma:
- Python: método en la clase, puede usar `if`/`raise`
- Erlang: función nueva con pattern matching, retorna `{ok, Fecha}` o `{error, Razon}`
- Prolog: predicado `extrae_fecha/2`, documenta aridad y determinismo

---

### Análisis comparativo (entrega escrita)

En `analisis.md`, responde:

**Sección 1 — Métricas objetivas** (llena la tabla):

| Métrica | Python | Erlang | Prolog |
|---------|--------|--------|--------|
| Líneas de código (sin comentarios) | | | |
| ¿Qué errores atrapa el compilador/intérprete ANTES de correr? | | | |
| ¿Qué errores solo se descubren EN TIEMPO DE EJECUCIÓN? | | | |
| ¿Puede tener race conditions con hilos simultáneos? | | | |
| ¿Puede consultarse "al revés" (dado resultado, encontrar entrada)? | | | |

**Sección 2 — Análisis cualitativo** (3-5 oraciones por pregunta):

1. ¿En qué tipo de proyecto elegirías el validador en Erlang sobre el de Python? ¿Por qué?
2. El validador Prolog puede responder: `?- valida_curp(C, ok(_)), atom_length(C, 18).`
   para generar CURPs válidas. ¿Qué implicaciones tiene esto para pruebas de software?
3. ¿Qué tendría que cambiar en el diseño del sistema SAT-CFDI para beneficiarse del paradigma lógico?

---

### Estructura de entrega

```
A00123456/
├── curp_imperativo.py    ← versión extendida con validación de fecha
├── curp_funcional.erl    ← versión extendida con validación de fecha
├── curp_logico.pl        ← versión extendida con extrae_fecha/2
├── analisis.md           ← tabla de métricas + análisis cualitativo
└── evidencia.txt         ← salida de los tres programas corriendo
```

### Criterios de evaluación

| Criterio | Puntos |
|----------|--------|
| Las 3 extensiones implementadas y funcionando | 45 |
| Tabla de métricas correctamente llenada | 20 |
| Análisis cualitativo con argumentos técnicos | 25 |
| Evidencia de ejecución de los tres | 10 |
| **Total** | **100** |
