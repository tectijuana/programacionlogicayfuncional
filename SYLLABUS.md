# Sílabo — Programación Lógica y Funcional

**Clave:** ISC-2006  
**Créditos:** 5  
**Horas teoría / práctica:** 3 / 2 (5 h/semana)  
**Período:** Agosto – Diciembre 2026  
**Modalidad:** Presencial con apoyo en GitHub  

**Docente:** Dr. René Solís Reyes  
**Departamento:** Sistemas y Computación  
**Institución:** TecNM Campus Tijuana  
**Correo:** rene.solis@tectijuana.edu.mx  
**Asesorías:** Previa cita por correo o Issues en este repositorio

---

## Descripción del Curso

Estudio de los paradigmas de programación lógica y funcional como alternativas al modelo imperativo. El estudiante aprende a declarar *qué* se quiere computar en lugar de *cómo* hacerlo, desarrollando una base sólida para diseñar sistemas concurrentes, tolerantes a fallas y con garantías en tiempo de compilación.

Los lenguajes del curso tienen presencia directa en producción a escala mundial:
- **Erlang/OTP** → WhatsApp (2 mil millones de usuarios), RabbitMQ
- **Elixir/Phoenix** → Discord (150 millones de usuarios)
- **Haskell/GHC** → Pandoc, xmonad, GitHub Semantic
- **Clojure** → Nubank (el banco digital más grande de América Latina)
- **SWI-Prolog** → IBM Watson Knowledge Graph, sistemas expertos médicos

---

## Competencias a Desarrollar

Al concluir el curso el estudiante será capaz de:

| Nivel (Bloom) | Competencia |
|---------------|-------------|
| **Recordar** | Identificar los paradigmas funcional y lógico, sus lenguajes y casos de uso en la industria |
| **Comprender** | Explicar evaluación perezosa vs. estricta, unificación vs. asignación, y la filosofía "let it crash" |
| **Aplicar** | Implementar soluciones recursivas con tail-call optimization en Erlang, Haskell y Prolog |
| **Analizar** | Comparar el mismo problema en tres paradigmas midiendo LOC y garantías del compilador |
| **Evaluar** | Justificar la elección de paradigma para un dominio dado con métricas concretas |
| **Crear** | Diseñar un sistema multi-paradigma que integre lógica declarativa, estado supervisado y tipos fuertes |

---

## Calendario Semanal

El semestre Agosto–Diciembre 2026 comprende **16 semanas** lectivas más una semana de presentaciones finales.

| Sem | Fecha aprox. | Unidad / Tema | Actividad | Entregable |
|-----|-------------|---------------|-----------|------------|
| 1 | 10–14 ago | **U1 · Tema 1.1** Introducción a PLF | Encuadre del curso, taxonomía de paradigmas, instalación de entornos (SWI-Prolog, Erlang, GHC, Clojure, Elixir) | — |
| 2 | 17–21 ago | **U1 · Tema 1.2** Historia y evolución | Línea de tiempo: λ-calculus 1930 → Gleam 2024; lectura de código OCaml real de Meta/Facebook | — |
| 3 | 24–28 ago | **U1 · Tema 1.3** Comparación de paradigmas | Validador CURP en 3 paradigmas: Python imperativo, Erlang funcional, Prolog lógico | **Práctica 1** |
| 4 | 31 ago–4 sep | **U2 · Tema 2.1** Fundamentos FP | Inmutabilidad, transparencia referencial, pattern matching; RFC mexicano en Erlang | — |
| 5 | 7–11 sep | **U2 · Tema 2.2** Funciones de orden superior | `map`/`filter`/`reduce`, composición, closures; pipeline de alumnos TecNM en Clojure | **Práctica 2** |
| 6 | 14–18 sep | **U2 · Tema 2.3** Recursión e inmutabilidad | Tail-call optimization, `Maybe`/`Either`, tipos algebraicos en Haskell | — |
| 7 | 21–25 sep | **U2 · Tema 2.4** Evaluación perezosa | Listas infinitas (Fibonacci, primos), `Stream` sobre registros IMSS en Haskell y Elixir | **Práctica 3** |
| 8 | 28 sep–2 oct | **U2 · Tema 2.5** Aplicaciones FP / OTP | `application` + `supervisor` + `gen_server`; sistema IoT tipo CENAPRED en Erlang/OTP | **Examen Parcial 1** (U1–U2) |
| 9 | 5–9 oct | **U3 · Tema 3.1** Fundamentos de PL | Hechos, consultas, base de datos organizacional TecNM en SWI-Prolog | — |
| 10 | 12–16 oct | **U3 · Tema 3.2** Sistemas formales y lógica de predicados | Reglas, negación como falla (`\+`), eligibilidad para beca TecNM | **Práctica 4** |
| 11 | 19–23 oct | **U3 · Tema 3.3** Unificación y resolución | Algoritmo MGU, traza SLD, occurs check; 15 tests automatizados | — |
| 12 | 26–30 oct | **U3 · Tema 3.4** Introducción a Prolog | Listas desde cero, aritmética, `entre/3`; 76 tests plunit | **Práctica 5** |
| 13 | 2–6 nov | **U3 · Tema 3.5** Aplicaciones de PL | Sistema experto médico interactivo (contexto IMSS); 8 condiciones, `assert`/`retract` | — |
| 14 | 9–13 nov | **U4 · Temas 4.1–4.2** Módulos y búsqueda | Módulos Prolog con firmas; DFS y BFS sobre grafo metro CDMX; cut verde vs. rojo | **Práctica 6** |
| 15 | 16–20 nov | **U4 · Tema 4.3** Optimización / CLP(FD) | Restricciones sobre enteros, Sudoku 9×9, asignación de horarios TecNM como CSP | **Examen Parcial 2** (U3–U4) |
| 16 | 23–27 nov | **U4 · Tema 4.4** Proyecto final | Sistema de trámites TecNM multi-módulo con CLP; última semana de desarrollo | — |
| 17 | 30 nov–4 dic | [**Proyectos Finales**](proyectos_finales/) — Presentaciones | Demostración en vivo del sistema multi-paradigma (3 capas); el sistema debe correr sin modificaciones en el equipo del profesor. Proyectos disponibles: [P1 IMSS](proyectos_finales/proyecto1_tramites_imss/) · [P2 Horarios](proyectos_finales/proyecto2_horarios_tecnm/) · [P3 IoT](proyectos_finales/proyecto3_monitor_iot/) · [P4 SAT](proyectos_finales/proyecto4_inventario_sat/) | **Proyecto Final** |

---

## Evaluación

### Desglose por Unidad

Cada unidad se evalúa independientemente:

| Rubro | Porcentaje |
|-------|-----------|
| Prácticas de laboratorio | 40 % |
| Proyecto integrador | 40 % |
| Exposición / defensa oral | 20 % |

### Prácticas de laboratorio

| # | Tema | Lenguaje principal | Entrega |
|---|------|--------------------|---------|
| P1 | Validador CURP — 3 paradigmas | Python · Erlang · Prolog | Sem 3 |
| P2 | Pipeline de alumnos TecNM | Clojure | Sem 5 |
| P3 | Streams infinitos IMSS | Haskell · Elixir | Sem 7 |
| P4 | Reglas de negocio TecNM | SWI-Prolog | Sem 10 |
| P5 | Listas y aritmética Prolog | SWI-Prolog (plunit) | Sem 12 |
| P6 | Búsqueda metro CDMX | SWI-Prolog | Sem 14 |

### Proyecto Final multi-paradigma

El Proyecto Final integra los tres paradigmas del curso en un sistema funcional de dominio real.
Se elige **uno** de los cuatro proyectos disponibles en [`proyectos_finales/`](proyectos_finales/):

| # | Proyecto | Dominio | Capa 1 | Capa 2 | Capa 3 |
|---|----------|---------|--------|--------|--------|
| [P1](proyectos_finales/proyecto1_tramites_imss/) | Validación de trámites IMSS | Seguridad social | Prolog | Erlang/OTP | Haskell |
| [P2](proyectos_finales/proyecto2_horarios_tecnm/) | Planificador de horarios TecNM | Educación / CSP | Prolog CLP(FD) | Clojure | — |
| [P3](proyectos_finales/proyecto3_monitor_iot/) | Monitor de alertas IoT CENAPRED | Ingeniería de sistemas | Prolog | Erlang/OTP | Elixir |
| [P4](proyectos_finales/proyecto4_inventario_sat/) | Inventario con reglas fiscales SAT | Contabilidad / CFDI | Prolog | Erlang/OTP | Haskell |

**Rúbrica del Proyecto Final:**

| Criterio | Peso |
|----------|------|
| Capa 1: tests `plunit` pasando, CLP(FD) aplicado | 30% |
| Capa 2: OTP/Clojure arrancando, supervisión demostrada con `kill` | 30% |
| Capa 3: Haskell/Elixir compilando con tipos o Stream correctos | 20% |
| Integración entre capas documentada y funcional | 10% |
| Exposición técnica (10–15 min, demostración en vivo, sem. 17) | 10% |

> Código que no compila = 0 en esa capa. La demostración debe correr sin modificaciones en el equipo del profesor.

---

### Criterio de acreditación

- Calificación mínima aprobatoria: **70 / 100**
- Asistencia mínima requerida: **80 %** de las sesiones presenciales
- Todo código entregado debe **compilar sin errores** — prácticas que no compilen reciben calificación 0

---

## Política de Entregas

- Las entregas se realizan mediante **Pull Request** a este repositorio antes de las 23:59 del día indicado
- **Entrega tardía:** se acepta hasta 72 horas después con penalización de 20 puntos por día
- **Plagio:** cualquier entrega con código idéntico o mínimamente modificado de otro equipo o fuente no citada resulta en calificación 0 para todos los involucrados y reporte al departamento
- El uso de IA (Claude, ChatGPT, etc.) está **permitido y fomentado** como herramienta; debe citarse en comentarios del código (`%% Generado con Claude Code, verificado y modificado por [matrícula]`)

### Evidencia requerida por tipo de entrega

| Tipo de entregable | Evidencia obligatoria | Cómo incluirla |
|--------------------|----------------------|----------------|
| Práctica CLI (Prolog, Erlang, Haskell, Clojure) | [asciinema](https://asciinema.org) — grabación de sesión de terminal | Link en la descripción del Pull Request |
| Proyecto con interfaz gráfica o dashboard | [LOOM](https://www.loom.com) — video de pantalla máx. 5 min | Link en la descripción del Pull Request |
| Proyecto Final (sem. 17) | asciinema para capas CLI + LOOM si hay UI | Ambos links en el PR y en el `README.md` del proyecto |
| Mockups / prototipos UI | [Google Stitch](https://stitch.withgoogle.com) — exportar imagen o link | Imagen en el `README.md` del tema |

> Un PR sin evidencia (asciinema o LOOM según corresponda) se considera incompleto y recibe 0 en el criterio de demostración.

---

## Instalación del Entorno de Desarrollo

### macOS
```bash
brew install swi-prolog erlang ghc cabal-install clojure elixir
```

### Ubuntu / Debian
```bash
sudo apt-get install swi-prolog erlang ghc cabal-install
# Clojure: https://clojure.org/guides/install_clojure
# Elixir: https://elixir-lang.org/install.html
```

### Windows
Usar WSL2 con Ubuntu y seguir las instrucciones de Linux, o usar **GitHub Codespaces** (no requiere instalación local).

### Verificación de instalación
```bash
swipl --version        # SWI-Prolog 9.x o superior
erl -eval 'erlang:display(ok), halt()'
ghc --version          # GHC 9.x o superior
clj --version
elixir --version
```

---

## Bibliografía

### Textos base (no mayor a 15 años)

- Cesarini, F., & Vinoski, S. (2016). *Designing for Scalability with Erlang/OTP*. O'Reilly Media.
- Thompson, S. (2016). *Haskell: The Craft of Functional Programming* (3a ed.). Pearson.
- Emerick, C., Carper, B., & Grand, C. (2012). *Clojure Programming*. O'Reilly Media.
- Pereira, P. A. (2015). *Elixir Cookbook*. Packt Publishing.

### Artículos y recursos en línea

- Armstrong, J. (2010). *Erlang*. Communications of the ACM, 53(9), 68–75.
- Bird, R. (2014). *Thinking Functionally with Haskell*. Cambridge University Press.
- SWI-Prolog manual: https://www.swi-prolog.org/pldoc/
- Learn You Some Erlang: https://learnyousomeerlang.com

### Revistas (no mayor a 5 años)

- *Journal of Functional Programming* — Cambridge University Press (2021–2026)
- *Theory and Practice of Logic Programming* — Cambridge University Press (2021–2026)
- *ACM SIGPLAN Notices* — ACM (2021–2026)

---

## Integridad Académica

Este curso sigue el *Código de Conducta* del repositorio y el Reglamento Escolar del TecNM. Se espera que todo trabajo entregado sea original o cite explícitamente sus fuentes. La colaboración entre compañeros es bienvenida; el plagio no lo es.

Ver: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)

---

## Herramientas del semestre

| Herramienta | Propósito |
|-------------|-----------|
| **GitHub Classroom** | Entrega de todas las prácticas y proyectos vía Pull Request |
| **[AWS Academy](https://www.awsacademy.com/vforcesite/LMS_Login)** | Cómputo en la nube — EC2 para ejecutar Erlang/OTP, Haskell, Prolog, Elixir ($100 USD/semestre) |
| **[asciinema](https://asciinema.org)** | Evidencia obligatoria de sesiones CLI — Prolog, Erlang, Haskell, Clojure |
| **[LOOM](https://www.loom.com)** | Evidencia de demos con interfaz gráfica o dashboard (máx. 5 min por video) |
| **[Google Stitch](https://stitch.withgoogle.com)** | Generación de UI con IA — base de mockups y prototipos para el Proyecto Final |
| **SWI-Prolog WASM** | Prolog en el navegador para demos rápidas sin instalación |
| **[Exercism.io](https://exercism.org)** | Práctica adicional guiada en cada lenguaje del curso |

## Recursos Institucionales

- **[GitHub Student Pack](https://education.github.com/pack)** — acceso gratuito a herramientas de desarrollo
- **[AWS Academy](https://www.awsacademy.com/vforcesite/LMS_Login)** — $100 USD de crédito por semestre para desplegar proyectos en la nube
