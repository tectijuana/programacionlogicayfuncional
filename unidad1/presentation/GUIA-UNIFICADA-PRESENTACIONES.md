# Guía unificada de presentaciones — Unidad 1
## Conceptos Fundamentales · Programación Lógica y Funcional · TecNM ISC

Un solo documento para preparar y calificar las **demostraciones en clase** de
los tres temas de la Unidad 1. No cubre las exposiciones de los temas de
investigación funcional (esas van aparte, en `research/`); aquí solo se trata la
**defensa oral del 20 %** de la unidad: mostrar en vivo que tu código de las
Tareas 1.1, 1.2 y 1.3 corre y que entiendes por qué.

Fuente de verdad del contenido: el `README.md` de cada `tema1.x/`. Esta guía solo
dice **cómo se presenta**.

---

## 1. Qué se presenta y cuándo

| Sesión | Tema | Entregable que se demuestra | Duración por alumno |
|:-:|:--|:--|:-:|
| Cierre de 1.1 | 1.1 Introducción a la PLyF | "Hola Paradigma" en Erlang y Prolog corriendo + reflexión sobre *shared nothing* | 5–7 min |
| Cierre de 1.2 | 1.2 Historia y evolución | Hallazgos del análisis de 5 sistemas + sistema mexicano investigado | 5–7 min |
| Cierre de 1.3 | 1.3 Comparación de paradigmas | Validador de CURP extendido corriendo en los 3 lenguajes + tabla de métricas | 8–10 min |

- La demo se hace **con tu propia entrega ya subida a GitHub Classroom**, no con
  código escrito en el momento.
- El orden de pase lo define el docente. Ten el entorno abierto **antes** de tu turno.
- Preguntas: 2–3 min al final de cada demo. Responde tú; el docente modera.

---

## 2. Regla sin excepciones

**Código que no compila / no corre = 0 en la parte de ejecución de esa demo.**
No se aceptan capturas de pantalla como sustituto de la ejecución en vivo
(el `evidencia.txt` es respaldo, no reemplazo).

---

## 3. Guion por tema

### 3.1 — "Hola Paradigma" (Tema 1.1)

```
1. Contexto (30 s)
   "El problema es imprimir 1..10. Lo trivial es a propósito:
    lo que importa es cómo piensa cada paradigma."

2. Erlang en vivo (2 min)
   erlc hola_paradigma.erl
   erl -noshell -s hola_paradigma main -s init stop
   → Señalar: no hay variable que mute; la iteración es recursión de cola (TCO).

3. Prolog en vivo (2 min)
   swipl -g "imprimir_hasta(10), halt." hola_paradigma.pl
   → Señalar: no describimos cómo iterar, describimos relaciones;
     el motor decide cómo satisfacerlas.

4. Reflexión obligatoria (1 min)
   Explicar en voz alta: qué mecanismo de Erlang (paso de mensajes,
   shared nothing) hace imposible que dos procesos imprimir/1 interfieran.

5. Cierre (30 s)
   Una frase: imperativo = secuencia de mutaciones; funcional = evaluación
   de expresiones; lógico = búsqueda sobre relaciones.
```

### 3.2 — Sistemas de Producción (Tema 1.2)

```
1. Tesis (30 s)
   "El paradigma funcional/lógico no es académico: sostiene WhatsApp,
    Discord, Nubank y las herramientas de análisis de Meta."

2. Un caso a fondo (2 min)
   Elegir UNO de los 5 (WhatsApp/Erlang, Discord/Elixir, Nubank/Clojure,
   Flow-Hack/OCaml, SAT-CFDI/Java) y explicar la razón técnica concreta
   de la elección de lenguaje. Con fuente en pantalla.

3. Sistema mexicano (2 min)
   Presentar el sistema investigado (IMSS, SPEI, INE, PEMEX, Telmex):
   stack real, volumen de transacciones, y la hipótesis de mejora
   funcional/lógica.

4. Honestidad de fuentes (30 s)
   Mostrar fuentes.md: URL + fecha. Nada de afirmar uso institucional
   de un stack sin fuente verificable.
```

> Casos permitidos: solo los verificados en `casos_reales_mundo_real.md`.
> Prohibido afirmar que IMSS/SAT/Samsung Tijuana usan un stack FP/LP concreto
> sin fuente directa.

### 3.3 — Validador de CURP (Tema 1.3)

```
1. Contexto (30 s)
   "El mismo validador, tres paradigmas. Comparación concreta, no abstracta."

2. Las 3 versiones corriendo (4 min)
   python3 curp_imperativo.py
   erlc curp_funcional.erl && erl -noshell -s curp_funcional demo -s init stop
   swipl -g "demo, halt." curp_logico.pl
   → Mostrar la extensión propia: validación de mes (01-12), día (01-31)
     y extracción de fecha como DD/MM/AAAA, respetando el estilo de cada paradigma
     (método con raise / tupla {ok,_}|{error,_} / predicado extrae_fecha/2).

3. Demo del "al revés" en Prolog (1 min)
   ?- valida_curp(C, ok(_)), atom_length(C, 18).
   → Explicar la implicación para pruebas de software (generación de casos).

4. Tabla de métricas (2 min)
   Leer las filas clave: líneas de código, qué atrapa el compilador antes de
   correr, qué solo aparece en runtime, race conditions, consulta bidireccional.

5. Cierre (30 s)
   En qué proyecto elegirías Erlang sobre Python y por qué.
```

---

## 4. Checklist antes de tu turno

- [ ] Entrega subida a GitHub Classroom con tu número de control.
- [ ] `erlc`, `swipl` y `python3` probados en la máquina que usarás en clase.
- [ ] Los comandos exactos del `README.md`, copiados en un archivo de notas.
- [ ] Plan B: `evidencia.txt` abierto por si un entorno falla (no sustituye la demo).
- [ ] Terminal con fuente ≥ 18 pt y tema claro.
- [ ] Sabes responder **sin leer** la pregunta de reflexión de tu tema.

---

## 5. Rúbrica de la defensa oral (20 % de la unidad)

Se aplica una vez, promediando las tres demos (1.3 pesa doble).

| # | Criterio | Pts | Qué se evalúa |
|:-:|:--|:-:|:--|
| 1 | El código corre en vivo | 8 | Compila/ejecuta sin errores; la extensión propia funciona. |
| 2 | Dominio del paradigma | 6 | Explica mutación vs. recursión vs. relaciones sin leer; responde preguntas. |
| 3 | Comparación con datos | 4 | Usa métricas concretas (LOC, errores en compilación vs. runtime, casos reales con fuente). |
| 4 | Claridad y tiempo | 2 | Sigue el guion; respeta el tiempo; terminal legible. |

Escala: 90–100 % excelente · 75–89 % satisfactorio · 60–74 % suficiente ·
0–59 % insuficiente.

---

## 6. Relación con el resto de la evaluación

Según el [README de la unidad](../README.md) y el [sílabo](../../SYLLABUS.md):
prácticas 40 % · proyecto integrador (Tarea 1.3) 40 % · **esta defensa oral 20 %**.
El documento escrito y la demostración se califican por separado: se puede tener
buen `analisis.md` y mala demo, o al revés.

---

*Curso Programación Lógica y Funcional (ISC-2006). Referencias:
[`tema1.1/README.md`](../tema1.1/README.md),
[`tema1.2/README.md`](../tema1.2/README.md),
[`tema1.3/README.md`](../tema1.3/README.md),
[`casos_reales_mundo_real.md`](../../casos_reales_mundo_real.md).*
