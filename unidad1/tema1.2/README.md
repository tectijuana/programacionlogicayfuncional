# Tema 1.2 — Historia y Evolución de los Paradigmas
## Assignment: Sistemas de Producción en el Mundo Real

### Objetivo

Entender que los paradigmas funcional y lógico no son inventos académicos:
son la base de algunos de los sistemas más críticos y escalables del mundo.
Incluyendo herramientas que probablemente estás usando ahora mismo.

---

### Parte A — La línea de tiempo que nadie te contó (lectura, 30 min)

Lee [linea_tiempo.md](linea_tiempo.md) en este mismo directorio.

Presta especial atención a la conexión:
**OCaml (1996) → Meta/Flow (2013) → Claude Code (2025)**

### Demo en clase — OCaml en 20 minutos (no evaluado)

Antes de entrar a los lenguajes del curso, veremos en vivo el lenguaje
que Meta eligió para construir Flow, Hack e Infer:

```bash
# Instalar OCaml (solo para el demo)
brew install ocaml          # macOS
sudo apt install ocaml      # Linux

# Ejecutar
ocaml ocaml_demo.ml
```

Ver código comentado: [`ocaml_demo.ml`](ocaml_demo.ml)

El demo cubre en 20 minutos:
1. **Inferencia de tipos** — el compilador deduce `int -> int -> int` sin que lo declares
2. **`Option`** — el null seguro que Flow usa para eliminar `NullPointerException`
3. **Tipos algebraicos + pattern matching exhaustivo** — cómo se modela un AST
4. **Módulos** — el sistema que Hack usa para separar análisis de tipos de análisis de flujo
5. **Mapa OCaml → curso** — cada concepto del demo reaparece en Haskell, Erlang o Prolog

> OCaml **no** es lenguaje evaluado en este curso. El demo existe para
> responder "¿por qué estudiar paradigmas funcionales?" con código real
> de producción que conoces: la herramienta que posiblemente estás usando
> para programar.

---

### Parte B — Análisis de 5 sistemas de producción

Estudia la siguiente tabla. Para cada sistema, investiga y responde
las preguntas guía al final.

| Sistema | Empresa | Lenguaje principal | Paradigma | Razón de elección | Escala actual |
|---------|---------|-------------------|-----------|-------------------|---------------|
| **WhatsApp** | Meta | Erlang | Funcional + Actor model | Millones de conexiones simultáneas con un equipo pequeño. Tolerancia a fallos nativa. | 2,000 millones de usuarios. ~2M conexiones por servidor. |
| **Discord** | Discord Inc. | Elixir (BEAM) | Funcional + Actor model | Migró de Go a Elixir en 2017. Los procesos livianos de BEAM manejan WebSockets a escala. | 150 millones de usuarios activos mensuales. |
| **Nubank** | Nubank | Clojure | Funcional (JVM) | Datos inmutables = transacciones financieras sin estado corrupto. STM para consistencia. | Banco digital más grande de América Latina. ~90 millones de clientes. |
| **Flow / Hack** | Meta | OCaml | Funcional con tipos fuertes | OCaml permite escribir compiladores e inferidores de tipos con garantías que otros lenguajes no dan. | Analiza 100+ millones de líneas de código de Meta cada día. |
| **SAT — CFDI** | SAT México | Java (predominante) | OOP imperativo | Integración con ecosistema Java empresarial existente. Curva de aprendizaje amplia en el mercado. | Procesa ~1,200 millones de facturas electrónicas por año. |

**Preguntas guía para tu análisis (responde en `investigacion.md`):**

1. WhatsApp tenía 50 ingenieros cuando fue adquirido por Facebook por $19,000 millones USD.
   ¿Qué papel jugó Erlang en que un equipo tan pequeño pudiera escalar tanto?
   (Busca: "WhatsApp engineering blog", "Erlang at WhatsApp")

2. Discord eligió Elixir sobre Go para manejar su infraestructura de presencia (quién está online).
   ¿Qué característica concreta de BEAM/Elixir hizo la diferencia?
   (Busca: "Discord Elixir 2017 blog post")

3. El fundador de Clojure, Rich Hickey, dice que los bugs de concurrencia en Java vienen de
   *identidad mutable* — confundir "el objeto" con "el valor actual del objeto".
   ¿Cómo resuelve Clojure este problema? (Busca: "Rich Hickey Are We There Yet")

4. Flow y Hack de Meta están escritos en OCaml, no en Python o JavaScript.
   ¿Por qué un lenguaje funcional tipado es mejor para escribir herramientas de análisis
   de código que un lenguaje dinámico? Argumenta con al menos un punto técnico concreto.

5. El SAT procesa facturas CFDI en Java. Si tuvieras que rediseñar el sistema de validación
   de facturas usando programación lógica (Prolog), ¿qué ventaja concreta ofrecería?
   ¿Cuál sería el mayor riesgo?

---

### Parte C — Investigación propia: un sistema de producción mexicano

Elige **uno** de los siguientes sistemas y documenta su stack tecnológico:

- **IMSS** — sistema de derechohabientes y citas médicas
- **Banxico SPEI** — transferencias interbancarias en tiempo real
- **INE** — padrón electoral y CURP
- **PEMEX** — control de operaciones en refinería
- **Telmex / Telcel** — sistema de facturación

Para el sistema elegido, documenta en `investigacion.md`:

1. ¿Qué lenguajes/tecnologías usa? (Busca comunicados oficiales, licitaciones, job postings)
2. ¿Cuántos registros/transacciones procesa por día?
3. ¿Qué paradigma(s) de programación dominan su arquitectura?
4. ¿Qué problema de escala o confiabilidad ha tenido públicamente?
5. Hipótesis: ¿qué beneficio concreto aportaría introducir un componente funcional o lógico?

---

### Tu entrega

```
A00123456/
├── investigacion.md    ← respuestas a preguntas guía + sistema mexicano
└── fuentes.md          ← al menos 5 fuentes con URL y fecha de consulta
```

### Criterios de evaluación

| Criterio | Puntos |
|----------|--------|
| Respuestas a las 5 preguntas guía con argumentos técnicos | 50 |
| Investigación del sistema mexicano con datos reales | 35 |
| Fuentes correctamente citadas (URL + fecha) | 15 |
| **Total** | **100** |
