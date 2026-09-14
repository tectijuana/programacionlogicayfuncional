# Historia de Erlang: cómo Ericsson resolvió la tolerancia a fallos en telefonía (1986)
 
> **Materia:** Programación Lógica y Funcional
> **Autor:** Diego Barboza
> **Repositorio:** `research/Historia de Erlang: cómo Ericsson resolvió la tolerancia a fallos en telefonía (1986)/`
 <img width="399" height="501" alt="infografia-erlang" src="https://github.com/user-attachments/assets/1ef855d7-8ac0-4373-8013-c9325ba20743" />

---
 
## Tabla de contenidos
 
1. [Introducción](#introducción)
2. [Desarrollo técnico](#desarrollo-técnico)
   - [2.1 El problema: telefonía que "nunca" puede caerse](#21-el-problema-telefonía-que-nunca-puede-caerse)
   - [2.2 El nacimiento de Erlang (1986)](#22-el-nacimiento-de-erlang-1986)
   - [2.3 Filosofía de diseño: "let it crash"](#23-filosofía-de-diseño-let-it-crash)
   - [2.4 Concurrencia mediante el modelo de actores](#24-concurrencia-mediante-el-modelo-de-actores)
   - [2.5 OTP: de lenguaje a plataforma industrial](#25-otp-de-lenguaje-a-plataforma-industrial)
   - [2.6 El caso AXD301: las "nueve nueves"](#26-el-caso-axd301-las-nueve-nueves)
   - [2.7 De la prohibición interna al código abierto](#27-de-la-prohibición-interna-al-código-abierto)
   - [2.8 Legado: de los conmutadores telefónicos a WhatsApp](#28-legado-de-los-conmutadores-telefónicos-a-whatsapp)
3. [Conclusiones](#conclusiones)
4. [Bibliografía (formato IEEE)](#bibliografía-formato-ieee)
5. [Anexos e imágenes](#anexos-e-imágenes)
---
 
## Introducción
 
En 1986, dentro del Laboratorio de Ciencias de la Computación de Ericsson en Estocolmo, un pequeño equipo liderado por Joe Armstrong, junto a Robert Virding y Mike Williams, se enfrentó a un problema que la informática de la época apenas sabía nombrar: ¿cómo se construye un sistema de software que **jamás** deje de funcionar, incluso cuando partes de él fallan? La respuesta no fue un parche ni una librería, sino un lenguaje de programación completo —Erlang— diseñado desde cero alrededor de la concurrencia masiva, el aislamiento de procesos y la recuperación automática de errores.
 
Este trabajo documenta el origen de Erlang como solución de ingeniería a un problema muy concreto de la industria de las telecomunicaciones: los conmutadores telefónicos de Ericsson debían atender cientos de miles de llamadas simultáneas con una disponibilidad cercana al 100%, algo que los lenguajes y paradigmas de programación imperativa de los años 80 no estaban preparados para garantizar. Se explica el contexto histórico, los principios técnicos que hacen de Erlang un caso paradigmático de tolerancia a fallos, el papel de la plataforma OTP, el caso de éxito del conmutador AXD301 (célebre por su fiabilidad de "nueve nueves") y el legado que el lenguaje dejó en sistemas distribuidos modernos como WhatsApp, RabbitMQ o Elixir.
 
---
 
## Desarrollo técnico
 
### 2.1 El problema: telefonía que "nunca" puede caerse
 
A comienzos de la década de 1980, Ericsson —el gigante sueco de las telecomunicaciones— enfrentaba un desafío estructural en el desarrollo de sus centrales telefónicas (PABX) y conmutadores de gran escala. Estos sistemas debían soportar decenas o cientos de miles de líneas simultáneas, operar de forma ininterrumpida durante años y permitir actualizaciones de software **sin cortar el servicio**, ya que una llamada de emergencia interrumpida podía tener consecuencias graves [1]. En una entrevista poco antes de su muerte, Armstrong recordó que el requisito central de esos conmutadores era que "nunca" debían caerse, es decir, que el sistema tenía que ser completamente tolerante a fallos, tanto de hardware como de software [2].
 
Los lenguajes disponibles en ese momento —C, Pascal, o incluso Prolog, con el que el equipo experimentaba inicialmente— no ofrecían primitivas nativas para aislar fallos entre componentes ni para gestionar miles de procesos concurrentes de forma ligera [3]. Ante esta carencia, el Laboratorio de Ciencias de la Computación de Ericsson, dirigido por Bjarne Däcker, fue creado específicamente para investigar nuevas formas de programar software de telecomunicaciones [1].
 
### 2.2 El nacimiento de Erlang (1986)
 
Armstrong había estado extendiendo Prolog con primitivas de concurrencia para programar servicios telefónicos básicos, un experimento que terminó derivando en un lenguaje completamente nuevo [2]. La primera versión funcional de Erlang apareció en 1986, desarrollada en el Computer Science Laboratory de Ericsson Telecom AB por Armstrong, Virding y Williams [4]. El nombre "Erlang" se interpreta habitualmente como un homenaje al matemático e ingeniero danés Agner Krarup Erlang, pionero de la teoría de colas aplicada a redes telefónicas, aunque también se lo entiende de forma jocosa como contracción de "Ericsson Language" [3].
 
Entre 1986 y 1990, Erlang existió como un dialecto interpretado sobre Prolog. Fue recién hacia 1990 cuando se independizó completamente como lenguaje propio, y en 1993 se lanzó su primera versión comercial, momento en el que Ericsson creó una subsidiaria para comercializarlo fuera de la empresa [2].
 <img width="1368" height="665" alt="linea-tiempo-erlang" src="https://github.com/user-attachments/assets/b57133a0-6b4b-41e3-a3d6-da104a464fb3" />

### 2.3 Filosofía de diseño: "let it crash"
 
El principio más distintivo de Erlang es su estrategia de manejo de errores conocida como *"let it crash"* ("déjalo fallar"). En lugar de intentar anticipar y capturar cada posible excepción dentro de cada proceso —como hacen la mayoría de los lenguajes con bloques `try/catch`—, la filosofía de Erlang propone que un proceso que encuentra un estado inesperado simplemente **termine**, y que sea un proceso especializado externo el que detecte esa terminación y decida cómo recuperarse (reiniciarlo, aislarlo, notificar al sistema, etc.) [4]. Esta idea, contraintuitiva para la época, simplifica enormemente el código de negocio: los desarrolladores no necesitan escribir manejo defensivo de errores en cada función, porque la resiliencia se delega a la arquitectura del sistema.
 
### 2.4 Concurrencia mediante el modelo de actores
 
Erlang implementa un modelo de **procesos ligeros** gestionados por su propia máquina virtual (la BEAM), no por el sistema operativo. Cada proceso:
 
- No comparte memoria con otros procesos.
- Se comunica exclusivamente mediante **paso de mensajes asíncronos** (envío con `!` y recepción con `receive`).
- Puede crearse y destruirse con un costo muy bajo, permitiendo sistemas con cientos de miles o millones de procesos concurrentes [5].
Este aislamiento estricto es lo que hace posible el principio "let it crash": como los procesos no comparten estado, el fallo de uno no corrompe la memoria de los demás, a diferencia de lo que ocurre con hilos (*threads*) que comparten memoria en lenguajes tradicionales [4].
 
### 2.5 OTP: de lenguaje a plataforma industrial
 
Erlang por sí solo es un lenguaje funcional relativamente pequeño. Lo que lo convirtió en una herramienta de nivel industrial fue **OTP** (*Open Telecom Platform*), un conjunto de librerías, principios de diseño y comportamientos genéricos (`gen_server`, `gen_fsm`/`gen_statem`, supervisores, etc.) construido sobre el lenguaje [3]. OTP se consolidó formalmente en 1995, durante un proyecto de conmutador de gran escala, con el objetivo de ofrecer un núcleo estable y reutilizable para todos los usuarios de Erlang dentro de Ericsson [2].
 
El componente más importante de OTP para la tolerancia a fallos es el **árbol de supervisión** (*supervision tree*): una jerarquía de procesos "supervisores" que vigilan a procesos "trabajadores", y que, ante un fallo, aplican una estrategia de reinicio (reiniciar solo el proceso caído, reiniciar a todos sus hermanos, escalar el error al supervisor superior, etc.). Esta estructura traduce la filosofía "let it crash" en una arquitectura concreta y reutilizable.
 
| Concepto de Erlang/OTP | Problema que resuelve | Analogía con lenguajes tradicionales |
|---|---|---|
| Proceso ligero (aislado) | Un fallo no debe afectar a otros componentes | Similar a un hilo, pero sin memoria compartida |
| Paso de mensajes | Comunicación segura entre componentes concurrentes | Sustituye a locks/mutex y memoria compartida |
| *Let it crash* | Evitar código defensivo excesivo | Alternativa a `try/catch` en cada función |
| Árbol de supervisión | Recuperación automática y ordenada de fallos | No tiene equivalente directo en C/Java clásico |
| Actualización en caliente (*hot code swap*) | Actualizar software sin detener el servicio | No existe en la mayoría de lenguajes compilados |
 
### 2.6 El caso AXD301: las "nueve nueves"
 
El ejemplo más citado del éxito de Erlang es el conmutador ATM **AXD301** de Ericsson, compuesto por más de dos millones de líneas de código Erlang [6]. Tras el colapso de un proyecto anterior de conmutador de nueva generación (AXE-N) en 1995, Ericsson decidió reiniciar el desarrollo usando Erlang, entregando el AXD301 en 1998 [3].
 
Según cifras difundidas por el propio Armstrong, un sistema AXD301 de un cliente importante llegó a registrar una disponibilidad del **99.9999999%** ("nueve nueves"), lo que equivale a apenas unos 31 milisegundos de inactividad al año [6], [7]. Es importante señalar —con honestidad académica— que el propio Armstrong reconoció en su tesis doctoral que esta cifra provenía de una presentación comercial y que no existía una recolección sistemática y verificable de esos datos a largo plazo [7]. Aun con esa salvedad, el caso se volvió el ejemplo de referencia en la industria para ilustrar lo que un diseño centrado en tolerancia a fallos puede lograr.
 
**Tabla comparativa de niveles de disponibilidad** (para contextualizar la cifra):
 
| Nivel | Disponibilidad | Downtime aproximado al año |
|---|---|---|
| 2 nueves | 99% | ~3.65 días |
| 3 nueves | 99.9% | ~8.76 horas |
| 5 nueves | 99.999% | ~5.26 minutos |
| 7 nueves | 99.99999% | ~3.15 segundos |
| **9 nueves (AXD301)** | **99.9999999%** | **~31 milisegundos** |
 
### 2.7 De la prohibición interna al código abierto
 
Pese a sus resultados técnicos, en febrero de 1998 la división Ericsson Radio Systems prohibió internamente el uso de Erlang en nuevos productos, argumentando preferencia por lenguajes no propietarios [3]. Esta decisión, lejos de terminar con Erlang, llevó a que Armstrong y parte del equipo original planearan dejar la empresa; ese mismo año, Ericsson liberó el código de Erlang bajo una licencia de código abierto, permitiendo que la comunidad externa continuara su desarrollo [2], [3]. Con el tiempo, Armstrong y otros ex-Ericsson fundaron empresas como Bluetail y, más adelante, Erlang Solutions, para dar soporte y difusión al lenguaje fuera del ámbito telefónico.
 
### 2.8 Legado: de los conmutadores telefónicos a WhatsApp
 
Las propiedades que hicieron de Erlang la herramienta ideal para conmutadores telefónicos —concurrencia masiva, tolerancia a fallos y distribución— resultaron igualmente valiosas para los sistemas de internet a gran escala que emergieron décadas después. Entre los casos más conocidos de adopción de Erlang y su ecosistema se encuentran:
 
- **WhatsApp**, que construyó su backend de mensajería sobre Erlang, sirviendo a cientos de millones de usuarios con equipos de servidores comparativamente pequeños [8].
- **RabbitMQ**, uno de los brokers de mensajería más usados en arquitecturas distribuidas.
- **Riak**, base de datos distribuida usada, entre otros, por servicios del sistema de salud del Reino Unido (NHS) [8].
- **Elixir**, lenguaje moderno que se ejecuta sobre la misma máquina virtual (BEAM) que Erlang, heredando su modelo de concurrencia y tolerancia a fallos con una sintaxis más cercana a Ruby.
Este recorrido —de un laboratorio interno de Ericsson en 1986 a la infraestructura de mensajería más usada del mundo— ilustra cómo una solución de ingeniería diseñada para un problema de dominio muy específico (telefonía que no puede fallar) terminó generalizándose a cualquier sistema que necesite alta concurrencia y disponibilidad.
 
---
 
## Conclusiones
 
- Erlang no nació como un ejercicio académico de diseño de lenguajes, sino como respuesta directa a una necesidad de ingeniería muy concreta: conmutadores telefónicos de Ericsson que debían operar de forma ininterrumpida durante años.
- Su aporte principal no es sintáctico, sino arquitectónico: el aislamiento de procesos, el paso de mensajes y la filosofía *"let it crash"*, combinados en los árboles de supervisión de OTP, ofrecieron un modelo replicable para construir sistemas resilientes sin necesidad de programación defensiva exhaustiva.
- El caso del AXD301 —con su célebre (aunque debatida) cifra de "nueve nueves"— consolidó a Erlang como referencia de la industria en fiabilidad, incluso si las cifras exactas no fueron verificadas de forma totalmente rigurosa.
- La decisión de liberar el código en 1998, tras una prohibición interna en Ericsson, fue paradójicamente el punto de partida para que Erlang trascendiera la telefonía y llegara a sistemas de internet masivos como WhatsApp.
- El legado más importante de Erlang es conceptual: sus ideas sobre concurrencia y tolerancia a fallos influyeron directamente en lenguajes y sistemas posteriores (Elixir, Akka/Scala, entre otros), demostrando que un problema de dominio específico —telefonía confiable— puede producir soluciones de valor general para toda la computación distribuida moderna.
---
 
## Bibliografía (formato IEEE)
 
[1] J. Armstrong, "A History of Erlang," in *Proc. 3rd ACM SIGPLAN Conf. on History of Programming Languages (HOPL III)*, San Diego, CA, USA, 2007. [Online]. Available: https://lfe.io/papers/[2007]%20Armstrong%20-%20HOPL%20III%20A%20History%20of%20Erlang.pdf
 
[2] "Why Erlang? Joe Armstrong's Legacy of Fault-Tolerant Computing," *The New Stack*, May 2022. [Online]. Available: https://thenewstack.io/why-erlang-joe-armstrongs-legacy-of-fault-tolerant-computing/
 
[3] "Erlang (programming language)," *Wikipedia*. [Online]. Available: https://en.wikipedia.org/wiki/Erlang_(programming_language)
 
[4] J. Armstrong, "Erlang," *Commun. ACM*, vol. 53, no. 9, pp. 68–75, Sep. 2010. [Online]. Available: https://cacm.acm.org/magazines/2010/9/98014-erlang/fulltext
 
[5] R. N. Göçmen, "Erlang: A Veteran's Take on Concurrency, Fault Tolerance, and Scalability," *Medium*, Apr. 2025. [Online]. Available: https://medium.com/@rng/erlang-a-veterans-take-on-concurrency-fault-tolerance-and-scalability-adff3f96565b
 
[6] A. Collins, "Erlang: No Process Was Harmed in the Making of this Post," *FullStackHacks (Medium)*, Apr. 2017. [Online]. Available: https://medium.com/fullstackhacks/erlang-no-process-was-harmed-in-the-making-of-this-post-247a80223f19
 
[7] "All For Reliability: Reflections on the Erlang Thesis," *DockYard Blog*, Jul. 2018. [Online]. Available: https://dockyard.com/blog/2018/07/18/all-for-reliability-reflections-on-the-erlang-thesis
 
[8] C. Meiklejohn *et al.*, "Partisan: Enabling Cloud-Scale Erlang Applications," arXiv:1802.02652, 2018. [Online]. Available: https://arxiv.org/pdf/1802.02652
 
[9] "Joe Armstrong (programmer)," *Wikipedia*. [Online]. Available: https://en.wikipedia.org/wiki/Joe_Armstrong_(programmer)
 
---
 
## Anexos e imágenes
 
> Coloca aquí las imágenes de apoyo (línea de tiempo, diagrama de árbol de supervisión, foto del AXD301, logo de Erlang, etc.). Sugerencia de nombres de archivo dentro de una subcarpeta `img/`:
 
```
research/Historia de Erlang.../
├── README.md
├── anexo.md
└── img/
    ├── linea-tiempo-erlang.png
    ├── arbol-supervision.png
    ├── axd301.jpg
    └── logo-erlang.png
```
 
**Ejemplo de inserción de imagen (reemplaza la ruta cuando subas tus archivos):**
 
![Línea de tiempo de Erlang](img/linea-tiempo-erlang.png)
*Figura 1. Línea de tiempo de los hitos principales de Erlang (1986–1998–actualidad).*
 
![Árbol de supervisión en OTP](img/arbol-supervision.png)
*Figura 2. Ejemplo simplificado de un árbol de supervisión en OTP.*
 
![Conmutador AXD301](img/axd301.jpg)
*Figura 3. Conmutador ATM AXD301 de Ericsson.*
