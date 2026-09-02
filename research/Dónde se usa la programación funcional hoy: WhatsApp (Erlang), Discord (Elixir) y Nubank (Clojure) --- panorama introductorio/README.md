<div align="center">

# INSTITUTO TECNOLÓGICO DE TIJUANA

**Ingeniería en Sistemas Computacionales**

---

### Materia: Programación Lógica y Funcional

### Tema de investigación 40:
### Dónde se usa la programación funcional hoy: WhatsApp (Erlang), Discord (Elixir) y Nubank (Clojure) — panorama introductorio

---

**Maestro:** Rene Solis Reyes

**Alumno:** Santoyo Torres Santos Abraham

**Número de control:** 23212072

**Semestre:** Agosto – Diciembre 2026 ("B")

</div>

\newpage

## Introducción

La programación funcional dejó de ser, hace ya más de una década, un tema exclusivamente académico. Hoy sostiene la infraestructura de algunos de los sistemas de software más exigentes del mundo en cuanto a concurrencia, disponibilidad y tolerancia a fallos. Este documento presenta un panorama introductorio de tres casos de industria ampliamente documentados y verificables: **WhatsApp**, que construye su capa de mensajería sobre **Erlang/OTP**; **Discord**, que sostiene su infraestructura de tiempo real sobre **Elixir** (un lenguaje que corre sobre la misma máquina virtual que Erlang, la BEAM); y **Nubank**, el banco digital latinoamericano que construyó su plataforma central sobre **Clojure**. El objetivo no es agotar el detalle técnico de cada arquitectura —eso corresponde a temas posteriores del curso sobre concurrencia y OTP— sino mostrar, con datos y fuentes verificables, *por qué* estas empresas eligieron un lenguaje funcional y *qué* propiedades del paradigma (inmutabilidad, procesos aislados, paso de mensajes, tolerancia a fallos) resultaron decisivas para resolver problemas reales de escala.

## Desarrollo técnico

### 1. Por qué la industria voltea hacia lo funcional

Los tres casos comparten un patrón: sistemas con una concurrencia masiva (millones de conexiones o eventos simultáneos), donde el costo de un error de estado compartido o de una caída en cascada es alto. La programación funcional ataca ese problema desde su raíz conceptual: si los datos son inmutables y las funciones son puras, gran parte de las condiciones de carrera y errores de sincronización simplemente no pueden ocurrir. En el caso de Erlang y Elixir esto se combina además con el **modelo de actores**, donde cada unidad de concurrencia es un proceso ligero, aislado y sin memoria compartida, que se comunica exclusivamente mediante paso de mensajes.

### 2. WhatsApp y Erlang/OTP

WhatsApp es probablemente el caso más citado de programación funcional en producción. Ya en 2014, con alrededor de 500 millones de usuarios, la aplicación operaba con cerca de 550 servidores y más de 11 000 núcleos corriendo Erlang, cifras documentadas en análisis públicos de su arquitectura [1]. La razón técnica es el modelo de procesos de Erlang: cada conexión de usuario corresponde a un proceso Erlang ligero, lo que permite que un solo servidor maneje entre dos y tres millones de conexiones simultáneas [3]. Cuando un usuario envía un mensaje, el sistema no depende de hilos del sistema operativo ni de memoria compartida: el mensaje pasa directamente del proceso del remitente al proceso del destinatario mediante las primitivas de paso de mensajes de Erlang, sin candados ni coordinación adicional [2].

Esta arquitectura explica también la eficiencia operativa de la empresa: WhatsApp mantuvo su plantilla de ingeniería en alrededor de 50 personas incluso mientras escalaba a mil millones de usuarios [5], apoyándose en el modelo "un proceso por usuario" y en los principios de supervisión de OTP (*Open Telecom Platform*), que permiten que un proceso que falla no derribe al resto del sistema, mientras los supervisores lo reinician automáticamente [3]. Es importante subrayar, siguiendo la exigencia del curso de no usar `spawn` sin supervisión, que esta tolerancia a fallos no es un efecto accidental de Erlang sino el resultado de aplicar deliberadamente el patrón *supervisor/worker* de OTP.

### 3. Discord y Elixir

Discord adoptó Elixir desde su prototipo original, en 2015, precisamente por heredar las propiedades de la máquina virtual BEAM (la misma que usa Erlang) con una sintaxis más moderna. Según su propio equipo de ingeniería, el lenguaje se eligió porque la BEAM era la candidata perfecta para el sistema altamente concurrente y en tiempo real que buscaban construir, y ese prototipo terminó siendo la base de toda su infraestructura [6]. Para 2017, Discord ya operaba con cerca de cinco millones de usuarios concurrentes y millones de eventos por segundo [6]. Años más tarde, en una entrevista pública del equipo, un ingeniero de Discord fue explícito sobre por qué el modelo de actores de la BEAM era idóneo para comunicación en tiempo real, y la propia plataforma llegó a sostener un clúster de entre 400 y 500 máquinas Elixir para su infraestructura de mensajería de chat, atendido por un equipo de apenas cinco ingenieros responsables de más de veinte servicios [7].

Es relevante aclarar, para no caer en afirmaciones no verificables, que Discord ha migrado componentes específicos de su sistema —notablemente partes de su capa de voz— a Rust por razones de rendimiento en cómputo intensivo, un movimiento documentado en su propio blog de ingeniería bajo el título "Using Rust to Scale Elixir" [8]; esto no representa un abandono de Elixir, sino un patrón común en sistemas funcionales maduros: usar Elixir para la orquestación concurrente y un lenguaje de sistemas para los cuellos de botella de cómputo puro, mientras la BEAM sigue coordinando el conjunto.

### 4. Nubank y Clojure

Nubank, fundado en Brasil en 2013 y hoy el banco digital más grande fuera de Asia, construyó su plataforma sobre Clojure desde el inicio. Según su propio blog de ingeniería, la empresa opera alrededor de mil microservicios escritos en Clojure [10], y ha mantenido este lenguaje como parte de un conjunto reducido y deliberado de tecnologías centrales —Clojure para microservicios, Kafka para comunicación asíncrona y Datomic como base de datos para información de negocio de alto valor— con el objetivo explícito de reducir la variabilidad tecnológica y volver más eficiente a la organización de ingeniería [11].

La justificación de Nubank es distinta a la de WhatsApp o Discord: no se trata solo de concurrencia masiva, sino de **claridad y auditabilidad** en un dominio financiero crítico. La propia empresa señala que el código funcional es mucho más fácil de probar, lo que les da la confianza para desplegar en promedio más de cincuenta cambios al día en un dominio de misión crítica [9], apoyados en un pipeline de entrega continua que permite que cualquier cambio fusionado a la rama principal esté corriendo en producción en menos de treinta minutos [9]. La inmutabilidad de las estructuras de datos de Clojure, combinada con Datomic (una base de datos que preserva el historial completo de los hechos, similar a un control de versiones para los datos), encaja de forma natural con un requisito no negociable de la banca: poder reconstruir con certeza el estado exacto de una cuenta en cualquier punto del pasado.

### 5. Panorama comparativo

| Empresa | Lenguaje / VM | Problema que resolvió el paradigma funcional | Escala documentada |
|---|---|---|---|
| WhatsApp | Erlang/OTP (BEAM) | Millones de conexiones concurrentes con tolerancia a fallos y equipo de ingeniería mínimo | ~2 000 millones de usuarios; servidores que soportan de 2 a 3 millones de conexiones cada uno |
| Discord | Elixir (BEAM) | Eventos de chat y presencia en tiempo real a gran escala, con pocos ingenieros por servicio | Millones de usuarios concurrentes; clúster de cientos de máquinas atendido por 5 ingenieros |
| Nubank | Clojure (JVM) | Auditabilidad, inmutabilidad de datos financieros y despliegue continuo seguro | ~1 000 microservicios en producción; +50 despliegues diarios |

El hilo conductor de los tres casos no es que un lenguaje funcional sea intrínsecamente "más rápido", sino que el paradigma —procesos inmutables y aislados en el caso de la BEAM, o datos inmutables y funciones puras en el caso de Clojure sobre la JVM— reduce una clase entera de errores propios de la concurrencia y el estado compartido, permitiendo que equipos de ingeniería relativamente pequeños operen sistemas de escala extraordinaria con mayor confianza.

## Conclusiones

Los tres casos analizados muestran que la programación funcional en la industria no responde a una sola motivación, sino a distintas facetas del mismo problema de fondo: manejar estado y concurrencia de forma segura. WhatsApp y Discord comparten la máquina virtual BEAM y el modelo de actores para resolver comunicación en tiempo real a escala masiva con equipos pequeños; Nubank, en cambio, elige Clojure sobre la JVM principalmente por la claridad, inmutabilidad y auditabilidad que exige un sistema financiero crítico. En conjunto, estos ejemplos son evidencia de que conceptos que en las primeras semanas del curso pueden parecer abstractos —inmutabilidad, funciones puras, procesos que se comunican por mensajes— son, en realidad, decisiones de ingeniería con consecuencias medibles en disponibilidad, tamaño de equipo y velocidad de despliegue. Este panorama introductorio sienta las bases para temas posteriores del curso, donde se profundizará en los mecanismos concretos —supervisores OTP, `gen_server`, tipos algebraicos y concurrencia mediante la BEAM— que hacen posibles estos resultados.

## Referencias (formato IEEE)

[1] CometChat, "Understanding WhatsApp's Architecture & System Design," *CometChat Blog*, 2021. [En línea]. Disponible: https://www.cometchat.com/blog/whatsapps-architecture-and-system-design

[2] Better Engineers, "How WhatsApp Handled 1 Billion Users with 50 Engineers," *Better Engineers Substack*, 2026. [En línea]. Disponible: https://betterengineers.substack.com/p/how-whatsapp-handled-1-billion-users

[3] GetStream, "How WhatsApp Works — Architecture Deep Dive on 100 Billion Messages," *GetStream Blog*, 2025. [En línea]. Disponible: https://getstream.io/blog/whatsapp-works/

[4] T. Harter, "How WhatsApp Grew to Nearly 500 Million Users, 11,000 cores, and 70 Million Messages a Second," *High Scalability*, 2014. [En línea]. Disponible: https://highscalability.com/how-whatsapp-grew-to-nearly-500-million-users-11000-cores-an/

[5] Quastor, "How WhatsApp scaled to 1 billion users with only 50 engineers," *Quastor Blog*, 2025. [En línea]. Disponible: https://blog.quastor.org/p/whatsapp-scaled-1-billion-users-50-engineers

[6] S. Vishnevskiy, "How Discord Scaled Elixir to 5,000,000 Concurrent Users," *Discord Blog*, 6 jul. 2017. [En línea]. Disponible: https://discord.com/blog/how-discord-scaled-elixir-to-5-000-000-concurrent-users

[7] Elixir Lang, "Real time communication at scale with Elixir at Discord," *elixir-lang.org Blog*, 8 oct. 2020. [En línea]. Disponible: https://elixir-lang.org/blog/2020/10/08/real-time-communication-at-scale-with-elixir-at-discord/

[8] Discord, "Using Rust to Scale Elixir for 11 Million Concurrent Users," *Discord Blog — Engineering & Developers*. [En línea]. Disponible: https://discord.com/category/engineering

[9] L. Cavalcanti, "Working with Clojure at Nubank," *Building Nubank (Medium)*, 2020. [En línea]. Disponible: https://medium.com/building-nubank/working-with-clojure-at-nubank-ef165b77bf08

[10] Building Nubank, "Functional programming with Clojure: why and how does Nubank use it and scale so well?," *Building Nubank*, 2024. [En línea]. Disponible: https://building.nubank.com/functional-programming-with-clojure/

[11] Building Nubank, "The value of canonicity," *Building Nubank*, 2024. [En línea]. Disponible: https://building.nubank.com/the-value-of-canonicity/

[12] E. Wible y R. Ferreira, "Architecting a Modern Financial Institution," *InfoQ*, 2017. [En línea]. Disponible: https://www.infoq.com/presentations/nubank-architecture/
