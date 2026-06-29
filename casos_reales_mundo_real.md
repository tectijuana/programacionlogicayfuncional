# Casos reales e internacionales de programación funcional y lógica
## Material validado para explicar a estudiantes

Este documento complementa la validación anterior con **casos reales, verificables y mejor documentados** del uso de programación funcional y lógica en el mundo real.  
La idea no es vender una fantasía de que "todo se hace con Prolog o Haskell", sino mostrar **dónde sí aportan valor estos paradigmas** y cómo aparecen en producción.

---

## Idea clave para explicar a estudiantes

La mejor forma de presentarlo es esta:

- **Programación funcional** sí tiene presencia clara en producción, especialmente en sistemas concurrentes, fintech, trading, backend y plataformas distribuidas.
- **Programación lógica / declarativa** también se usa en el mundo real, pero muchas veces no como "una app entera en Prolog", sino como:
  - motores de reglas,
  - lenguajes de consulta,
  - análisis estático,
  - planificación y restricciones,
  - bases de conocimiento,
  - optimización.

En otras palabras:

> La programación funcional suele aparecer como lenguaje principal de sistemas completos.  
> La programación lógica suele aparecer como motor de razonamiento o capa declarativa para resolver problemas difíciles.

---

# 1) Casos reales de programación funcional

## 1. WhatsApp — Erlang
**País / alcance:** internacional  
**Dominio:** mensajería a gran escala  
**Paradigma:** funcional concurrente  

WhatsApp es uno de los ejemplos clásicos y más importantes. Su backend se hizo famoso por usar **Erlang**, un lenguaje funcional diseñado para concurrencia, tolerancia a fallos y sistemas distribuidos. La razón no fue académica: era una decisión directamente ligada a escalabilidad y resiliencia.

### Qué enseña este caso
- Los procesos ligeros y el paso de mensajes sirven para manejar millones de conexiones.
- El modelo de supervisión de Erlang no es teoría: se usa en sistemas que no pueden caerse fácilmente.
- "Let it crash" no significa mala ingeniería; significa aislar fallos y recuperarse rápido.

### Cómo presentarlo a estudiantes
Este caso sirve para mostrar que cuando un sistema tiene muchísimos usuarios conectados al mismo tiempo, el modelo funcional/concurrente puede ser más natural que uno tradicional basado en hilos pesados.

---

## 2. Discord — Elixir / BEAM
**País / alcance:** internacional  
**Dominio:** chat en tiempo real, voz, comunidades  
**Paradigma:** funcional concurrente  

Discord publicó que escaló **Elixir** a millones de usuarios concurrentes y millones de eventos por segundo. Elixir corre sobre la VM de Erlang (BEAM), así que comparte la filosofía de concurrencia masiva y tolerancia a fallos.

### Qué enseña este caso
- Los paradigmas funcionales no están "congelados en los 90"; siguen vigentes en sistemas modernos.
- Un lenguaje funcional puede operar en tiempo real con carga extrema.
- La elección del paradigma sí cambia la arquitectura.

### Cómo explicarlo
Si un estudiante pregunta "¿de verdad estas ideas sirven fuera de clase?", Discord es una respuesta directa: sí, sirven en plataformas modernas y de altísima escala.

---

## 3. Jane Street — OCaml
**País / alcance:** Estados Unidos, mercados globales  
**Dominio:** trading cuantitativo y sistemas financieros  
**Paradigma:** funcional tipado  

Jane Street usa **OCaml** como plataforma principal de desarrollo. Este es uno de los casos más conocidos de programación funcional en finanzas de alto rendimiento.

### Qué enseña este caso
- Los tipos fuertes y el estilo funcional ayudan a reducir errores en sistemas donde un bug cuesta dinero real.
- La programación funcional no es solo para investigación; también sirve donde importan corrección, mantenibilidad y velocidad de iteración.
- En dominios complejos, la expresividad del lenguaje puede ser ventaja competitiva.

### Valor didáctico
Este caso desmonta la idea de que la programación funcional es "bonita pero poco práctica".

---

## 4. Standard Chartered — Haskell
**País / alcance:** banco global  
**Dominio:** banca y modelado financiero  
**Paradigma:** funcional puro  

Standard Chartered ha sido citado como caso importante de **Haskell en producción**, especialmente en la construcción de herramientas internas para su negocio financiero.

### Qué enseña este caso
- Haskell sí ha sido usado en entornos corporativos grandes.
- La pureza funcional puede ser útil cuando se requiere razonamiento fuerte sobre el comportamiento del software.
- El costo de adopción existe, pero algunas organizaciones lo aceptan cuando la corrección compensa.

### Cómo decirlo sin exagerar
Conviene presentarlo como un caso serio de adopción corporativa, **no** como prueba de que toda la banca mundial usa Haskell.

---

## 5. Nubank — Clojure
**País / alcance:** Brasil, México, Colombia; operaciones internacionales  
**Dominio:** fintech  
**Paradigma:** funcional (Lisp)  

Nubank es un caso especialmente bueno para estudiantes latinoamericanos. Su propio contenido de ingeniería describe a **Clojure** como tecnología central de muchas de sus soluciones digitales y backend de producción.

### Qué enseña este caso
- La programación funcional no es solo una curiosidad europea o académica.
- En América Latina hay empresas grandes usando funcional de forma estratégica.
- Inmutabilidad, simplicidad e interoperabilidad con Java pueden ser ventajas reales.

### Valor pedagógico
Es probablemente uno de los ejemplos más cercanos y convincentes para un grupo de estudiantes en México o Latinoamérica.

---

## 6. Facebook Chat — Erlang
**País / alcance:** internacional  
**Dominio:** mensajería / chat  
**Paradigma:** funcional concurrente  

Meta publicó en su blog de ingeniería que **Facebook Chat** usó Erlang, destacando procesos ligeros, message passing y filosofía de recuperación ante fallos.

### Qué enseña este caso
- No solo startups: grandes plataformas también eligieron modelos funcionales cuando el problema lo justificaba.
- La concurrencia basada en actores/procesos no es una moda; responde a necesidades reales.

---

# 2) Casos reales de programación lógica o declarativa

## 7. GitHub CodeQL / Semmle — lógica declarativa tipo Datalog
**País / alcance:** internacional  
**Dominio:** seguridad, análisis estático de código  
**Paradigma:** lógica declarativa  

CodeQL es una herramienta de análisis semántico de código usada para detectar vulnerabilidades. La documentación oficial explica que la semántica de QL está basada en **Datalog**, un lenguaje declarativo de la familia de la programación lógica.

GitHub, al anunciar la adquisición de Semmle, dijo que la tecnología era usada por equipos de seguridad en empresas como Uber, NASA, Microsoft y Google para encontrar vulnerabilidades.

### Qué enseña este caso
- La programación lógica hoy aparece mucho en **ciberseguridad y análisis de programas**.
- Datalog no suele usarse para hacer interfaces web, pero sí para describir reglas complejas de análisis.
- Es un gran ejemplo de cómo el enfoque declarativo permite expresar "qué patrón inseguro quiero encontrar" en vez de programar paso a paso el algoritmo completo.

### Valor didáctico
Este es uno de los mejores ejemplos modernos para justificar por qué la lógica declarativa sigue siendo relevante.

---

## 8. Soufflé — Datalog para análisis estático
**País / alcance:** internacional  
**Dominio:** análisis de programas, compiladores, seguridad  
**Paradigma:** Datalog / lógica declarativa  

La documentación de **Soufflé** explica que es un lenguaje inspirado en Datalog y que fue diseñado inicialmente en **Oracle Labs** para análisis estático.

### Qué enseña este caso
- La programación lógica se usa donde hacen falta relaciones, inferencias y clausuras transitivas.
- Un lenguaje lógico puede compilarse a ejecución eficiente y paralela.
- En la industria, la lógica muchas veces se usa como "motor especializado" para tareas concretas.

### Cómo explicarlo
No es un "CRUD empresarial" hecho en Datalog; es un caso aún más auténtico: un uso donde el paradigma encaja naturalmente.

---

## 9. LogicBlox — plataforma comercial basada en lógica
**País / alcance:** internacional  
**Dominio:** enterprise, retail, telecom, banca, gobierno  
**Paradigma:** Datalog / lógica declarativa  

Los trabajos técnicos de LogicBlox describen un sistema comercial basado en ideas lógicas/declarativas y mencionan aplicaciones de misión crítica en cientos de grandes empresas de retail, telecomunicaciones, banca y gobierno.

### Qué enseña este caso
- La lógica declarativa sí ha llegado a productos comerciales serios.
- Muchas veces no se presenta al cliente final como "esto está hecho en lógica", pero el motor interno sí depende de esas ideas.
- Es un buen ejemplo de que el valor industrial puede estar en el núcleo del sistema, no en la capa visible.

---

## 10. Datomic — consultas Datalog en sistemas de datos
**País / alcance:** internacional  
**Dominio:** bases de datos y sistemas de negocio  
**Paradigma:** declarativo / Datalog  

La documentación oficial de **Datomic** muestra que su modelo de consulta usa **Datalog**. Nubank también ha explicado públicamente que usa Datomic para datos de negocio de alto valor.

### Qué enseña este caso
- La programación lógica también vive dentro de las bases de datos y motores de consulta.
- No siempre aparece como "escribimos el sistema en Prolog"; a veces aparece como el lenguaje con el que se expresan relaciones complejas entre datos.
- Este es un caso útil para enseñar que lo declarativo está muy presente aunque el alumno no siempre lo note.

---

# 3) Casos que sí conviene mencionar, pero con cuidado

## Scheduling, asignación y restricciones
Aquí sí hay que ser precisos.

Es totalmente válido decir que:
- la asignación de turnos,
- el timetabling,
- la planificación de recursos,
- la calendarización industrial

son problemas del mundo real que suelen resolverse con **solvers de restricciones** y optimización.

Herramientas como **Google OR-Tools** son prueba clara de eso.

### Pero conviene evitar esta exageración
No es correcto afirmar sin evidencia que:
- "Samsung Tijuana resuelve exactamente esto con Prolog",
- "tal institución usa CLP(FD) en producción",
- "este organismo gubernamental usa Prolog o Datalog",

a menos que exista una fuente directa y verificable.

### Forma correcta de decirlo
> Este proyecto académico modela un tipo de problema que en la industria sí se resuelve con técnicas declarativas, de restricciones y optimización, aunque la herramienta exacta en producción puede variar.

Esa frase es fuerte, honesta y didácticamente correcta.

---

# 4) Qué conclusión dar a los estudiantes

## Conclusión corta
La programación funcional y la lógica **sí tienen uso real** en el mundo profesional, pero no siempre en la forma que uno imagina al salir del curso.

## Conclusión larga
- La **funcional** aparece con fuerza en:
  - concurrencia,
  - sistemas distribuidos,
  - fintech,
  - trading,
  - backend de alta confiabilidad.

- La **lógica/declarativa** aparece con fuerza en:
  - motores de reglas,
  - consultas complejas,
  - optimización,
  - análisis estático,
  - verificación,
  - seguridad.

## Mensaje pedagógico útil
No todos los estudiantes van a terminar trabajando en Haskell, Prolog o Elixir.  
Pero sí van a encontrarse una y otra vez con ideas de estos paradigmas:

- inmutabilidad,
- funciones puras,
- composición,
- recursión,
- pattern matching,
- reglas declarativas,
- restricciones,
- inferencia sobre relaciones.

Aprender estos paradigmas no solo sirve para "usar esos lenguajes", sino para pensar mejor y diseñar mejor software.

---

# 5) Frase final recomendada para clase o entrega

> Estos proyectos no son una fantasía académica: representan versiones simplificadas de problemas reales que hoy se resuelven con ideas de programación funcional, lógica y declarativa en mensajería, fintech, trading, seguridad, análisis estático, optimización y gestión de datos a escala internacional.

---

# Fuentes principales consultadas

- WhatsApp / Erlang: High Scalability; Erlang Solutions.
- Discord / Elixir: Discord Engineering Blog.
- Jane Street / OCaml: Jane Street Technology.
- Standard Chartered / Haskell: Serokell case study sobre uso en producción.
- Nubank / Clojure y Datomic: Building Nubank.
- Facebook Chat / Erlang: Meta Engineering.
- CodeQL / Datalog: documentación oficial de GitHub CodeQL y anuncio de GitHub sobre Semmle.
- Soufflé / Datalog: documentación oficial del proyecto.
- LogicBlox: papers técnicos del sistema y sitio oficial.
- Google OR-Tools: documentación oficial.

---

# Recomendación final de redacción

Para la entrega a estudiantes, usa ejemplos **verificados** como:
- WhatsApp,
- Discord,
- Jane Street,
- Standard Chartered,
- Nubank,
- CodeQL,
- Soufflé,
- Datomic,
- LogicBlox.

Y usa casos locales o institucionales solo como:
- **analogía pedagógica**,
- **posible aplicación del paradigma**,
- **modelo simplificado de un problema real**,

pero no como afirmación literal del stack tecnológico si no tienes fuente directa.
