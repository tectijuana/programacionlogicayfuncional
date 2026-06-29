# Anexo 2. Erlang/OTP y modelos de lenguaje grandes: arquitectura tolerante a fallos para sistemas con LLM

## Resumen

Este anexo presenta una investigacion academica introductoria sobre la relacion entre Erlang/OTP, la maquina virtual BEAM, Elixir y los modelos de lenguaje grandes (LLM, por sus siglas en ingles). La pregunta central es si existe actualmente un "Erlang con LLM". La respuesta corta es que no existe un lenguaje nuevo o estandar denominado de esa forma. Sin embargo, Erlang/OTP y Elixir/BEAM son plataformas especialmente adecuadas para construir sistemas que consumen, orquestan, supervisan y escalan servicios basados en LLM.

La relevancia de Erlang en este contexto no esta en generar texto como lo hace un LLM, sino en resolver problemas de ingenieria alrededor del LLM: concurrencia, tolerancia a fallos, supervision de procesos, manejo de timeouts, reintentos, colas de trabajo, aislamiento de errores y disponibilidad continua. Esto permite presentar a los estudiantes una aplicacion contemporanea de la programacion funcional concurrente: los LLM aportan capacidades conversacionales y generativas; Erlang/OTP aporta la infraestructura para que esas capacidades funcionen de manera confiable en produccion.

**Palabras clave:** Erlang, OTP, BEAM, Elixir, LLM, concurrencia, tolerancia a fallos, gen_server, supervisor, sistemas distribuidos.

## 1. Introduccion

Erlang fue creado para construir sistemas de telecomunicaciones con alta disponibilidad, donde los errores no debian detener el sistema completo. Su modelo de ejecucion se basa en procesos ligeros, paso de mensajes, aislamiento de fallos y supervision jerarquica. Con OTP, Erlang incorpora patrones de diseno reutilizables para construir aplicaciones concurrentes y tolerantes a fallos.

Los modelos de lenguaje grandes han cambiado la forma en que se construyen aplicaciones de software. Hoy es comun encontrar sistemas que usan LLM para generar respuestas conversacionales, resumir documentos, clasificar texto, extraer informacion, escribir codigo, traducir instrucciones y coordinar herramientas externas.

Sin embargo, una aplicacion con LLM no es solamente una llamada a una API. En un sistema real se deben resolver preguntas como:

- Que pasa si el proveedor del modelo no responde?
- Como se controlan los timeouts?
- Como se reintentan solicitudes fallidas?
- Como se limita el numero de peticiones concurrentes?
- Como se evita que una conversacion bloqueada afecte a otros usuarios?
- Como se registran latencia, costo, errores y trazabilidad?
- Como se mantiene disponible el servicio aunque fallen workers individuales?

Estas preguntas pertenecen al dominio natural de Erlang/OTP.

## 2. Pregunta de investigacion

La pregunta que guia este anexo es:

> Existe actualmente un Erlang con LLM?

La respuesta requiere separar tres ideas:

1. **Un lenguaje nuevo llamado "Erlang con LLM"**: no existe como estandar dominante.
2. **Clientes o librerias para consumir APIs de LLM desde la BEAM**: si existen, especialmente en el ecosistema Elixir.
3. **Arquitecturas OTP para orquestar llamadas a modelos de lenguaje**: si son viables y tecnicamente naturales.

La forma academica correcta de explicarlo es:

> No existe un Erlang+LLM como lenguaje separado; existe el uso de Erlang/OTP y Elixir/BEAM como plataformas concurrentes, funcionales y tolerantes a fallos para construir sistemas que integran modelos de lenguaje grandes.

## 3. Marco teorico

### 3.1 Erlang y el modelo de actores

Erlang se basa en procesos ligeros que no comparten memoria y se comunican mediante mensajes. Este modelo reduce errores asociados con estado compartido mutable y permite aislar fallos. Si un proceso falla, otro proceso supervisor puede reiniciarlo sin detener el sistema completo.

Este enfoque se resume habitualmente con la filosofia "let it crash": en lugar de intentar capturar todos los errores dentro de cada modulo, se disena una jerarquia de supervision capaz de reiniciar componentes fallidos de manera controlada.

### 3.2 OTP como biblioteca de patrones de produccion

OTP no es solamente una libreria; es una coleccion de principios, comportamientos y estructuras para construir sistemas robustos. Algunos componentes centrales son:

| Componente OTP | Funcion |
|---------------|---------|
| `gen_server` | Proceso servidor con estado y callbacks definidos |
| `supervisor` | Proceso encargado de iniciar, detener y reiniciar hijos |
| `application` | Unidad ejecutable y configurable de un sistema OTP |
| supervision tree | Estructura jerarquica de supervision y recuperacion |

En una aplicacion con LLM, estos componentes permiten separar responsabilidades: procesos que reciben solicitudes, procesos que llaman al modelo, procesos que almacenan cache, procesos que controlan limites de concurrencia y supervisores que reinician workers cuando fallan.

### 3.3 LLM como servicio externo o componente local

Un LLM puede integrarse de dos formas principales:

1. **Servicio externo:** por ejemplo, una API comercial o institucional que recibe prompts y devuelve respuestas.
2. **Modelo local:** por ejemplo, un servidor propio que ejecuta un modelo en infraestructura local o universitaria.

En ambos casos, la aplicacion debe tratar al LLM como una dependencia potencialmente lenta, costosa y fallible. Desde la perspectiva de Erlang/OTP, una llamada a un LLM debe manejarse como cualquier interaccion con un servicio externo: con timeout, control de errores, reintentos, observabilidad y supervision.

## 4. Arquitectura propuesta: Erlang/OTP como gateway LLM

Una arquitectura basica puede describirse asi:

```text
Usuario o aplicacion cliente
        |
        v
API o proceso de entrada
        |
        v
gen_server coordinador
        |
        v
pool de workers LLM
        |
        v
Proveedor LLM externo o modelo local
        |
        v
respuesta, metricas y registro
```

La misma arquitectura puede representarse desde OTP:

```text
llm_app
  |
  +-- llm_sup
        |
        +-- request_router
        +-- prompt_cache
        +-- rate_limiter
        +-- llm_worker_1
        +-- llm_worker_2
        +-- llm_worker_n
```

Cada componente puede fallar de manera aislada. Si un worker queda bloqueado o termina por error, el supervisor puede reiniciarlo. Si el cache falla, no necesariamente debe caer todo el sistema. Si el proveedor externo responde lento, el sistema puede aplicar timeout y devolver una respuesta controlada.

## 5. Ejemplo conceptual en Erlang

El siguiente ejemplo es una simplificacion didactica. No implementa una llamada real a un proveedor LLM; modela la estructura OTP que se usaria para encapsular esa llamada.

```erlang
-module(llm_worker).
-behaviour(gen_server).

-export([start_link/0, ask/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

ask(Prompt) ->
    gen_server:call(?MODULE, {ask, Prompt}, 30000).

init([]) ->
    {ok, #{requests => 0}}.

handle_call({ask, Prompt}, _From, State) ->
    Requests = maps:get(requests, State),
    Response = call_llm(Prompt),
    NewState = State#{requests => Requests + 1},
    {reply, Response, NewState}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

call_llm(Prompt) ->
    %% En una aplicacion real aqui iria la llamada HTTP,
    %% el timeout, la autenticacion y el manejo de errores.
    {ok, <<"Respuesta simulada para: ", Prompt/binary>>}.
```

Este codigo permite discutir varios conceptos:

- El estado del worker se mantiene de forma explicita.
- La llamada al LLM queda encapsulada.
- El timeout se define en `gen_server:call/3`.
- El proceso puede ser supervisado por un `supervisor`.
- Si el worker falla, el arbol OTP puede reiniciarlo.

## 6. Papel de Elixir en el ecosistema BEAM

Aunque Erlang es la base historica de la BEAM, muchas integraciones modernas con LLM aparecen primero en Elixir. Elixir corre sobre la misma maquina virtual que Erlang y conserva propiedades centrales: procesos ligeros, paso de mensajes, supervision y tolerancia a fallos.

El ecosistema Elixir cuenta con librerias orientadas a aplicaciones de IA, integracion con APIs de modelos, agentes, tool calling, procesamiento de texto y pipelines concurrentes. Por ello, en un curso de Programacion Logica y Funcional puede ser util explicar la relacion de esta manera:

```text
Erlang = fundamentos de concurrencia, OTP y tolerancia a fallos
Elixir = sintaxis moderna y ecosistema productivo sobre BEAM
BEAM = plataforma comun de ejecucion
LLM = componente externo o local que genera lenguaje
```

La conclusion no es que Elixir sustituya a Erlang, sino que ambos forman parte de la misma familia tecnologica. Erlang permite comprender el modelo conceptual; Elixir permite explorar integraciones modernas con mayor ergonomia.

## 7. Casos de uso academicos

### 7.1 Gateway LLM tolerante a fallos

Sistema que recibe preguntas de usuarios, envia prompts a un proveedor LLM y devuelve respuestas. Debe manejar timeouts, errores de red, reintentos y limites de concurrencia.

### 7.2 Cola de evaluacion de tareas

Sistema donde los estudiantes suben explicaciones o codigo. Workers supervisados envian cada entrega a un LLM para generar retroalimentacion preliminar. El docente conserva la evaluacion final.

### 7.3 Monitor de costos y latencia

Sistema que registra cantidad de tokens, tiempo de respuesta, errores por proveedor y costo aproximado. Esto permite discutir que la IA generativa tambien tiene implicaciones economicas y operativas.

### 7.4 Orquestador multi-modelo

Sistema que decide si una solicitud debe enviarse a un modelo rapido, a un modelo mas costoso o a un modelo local. Erlang/OTP puede modelar cada proveedor como un worker supervisado.

### 7.5 Asistente para sensores IoT

En un contexto como CENAPRED simulado, Erlang puede recibir eventos de sensores y un LLM puede generar reportes en lenguaje natural. Erlang mantiene la ingesta concurrente y tolerante a fallos; el LLM redacta explicaciones para usuarios humanos.

## 8. Ventajas academicas de integrar Erlang/OTP y LLM

| Aspecto | LLM | Erlang/OTP |
|--------|-----|------------|
| Generacion de lenguaje | Alta | No es su funcion principal |
| Concurrencia masiva | Depende de infraestructura externa | Alta |
| Tolerancia a fallos | No garantizada por el modelo | Alta mediante supervision |
| Control de procesos | Limitado | Explicito |
| Manejo de timeouts | Debe implementarse alrededor del modelo | Natural en procesos y llamadas |
| Observabilidad operacional | Externa al modelo | Puede integrarse en la arquitectura |
| Valor didactico | Motiva por actualidad | Forma criterio de sistemas robustos |

La combinacion ayuda a los estudiantes a ver que una aplicacion de IA no se reduce al prompt. Tambien requiere arquitectura, control de errores, limites, metricas y diseno de sistemas.

## 9. Riesgos y limitaciones

La integracion Erlang/OTP + LLM tambien tiene limitaciones:

1. **Dependencia externa:** si el modelo vive en una API externa, el sistema depende de red, autenticacion, costo y disponibilidad del proveedor.
2. **Costo variable:** cada peticion puede consumir tokens y generar gasto.
3. **Latencia:** las respuestas de LLM pueden tardar segundos, lo que exige manejo asincrono o colas.
4. **Privacidad:** no todo dato academico, institucional o personal debe enviarse a un proveedor externo.
5. **Complejidad operacional:** supervision, colas, cache y metricas agregan complejidad que debe justificarse.
6. **Alucinaciones:** aunque Erlang mantenga vivo el sistema, no garantiza que el contenido generado por el LLM sea correcto.

Por ello, el diseno debe separar claramente:

- disponibilidad del sistema;
- correccion del contenido;
- trazabilidad de las llamadas;
- privacidad de los datos;
- costo operativo.

## 10. Propuesta de actividad para el curso

### Titulo

**Gateway LLM tolerante a fallos con Erlang/OTP**

### Objetivo

Construir un prototipo en Erlang/OTP que reciba solicitudes de texto, las envie a un componente LLM simulado o real, y maneje fallos mediante supervision, timeouts y reintentos controlados.

### Componentes minimos

1. Aplicacion OTP.
2. Supervisor principal.
3. Worker `gen_server` para llamadas LLM.
4. Timeout configurable.
5. Manejo de error cuando el LLM no responde.
6. Registro de numero de solicitudes, exitos y fallos.
7. Pruebas manuales o automatizadas.

### Extension opcional

- Pool de workers.
- Cache de prompts frecuentes.
- Rate limiter.
- Integracion con una API real.
- Comparacion con una version Elixir.
- Panel simple de metricas.

### Rubrica sugerida

| Criterio | Porcentaje |
|---------|------------|
| Uso correcto de OTP y supervision | 30% |
| Manejo de timeouts y errores | 20% |
| Separacion clara entre LLM y arquitectura Erlang | 20% |
| Pruebas y evidencia de ejecucion | 15% |
| Documentacion tecnica y reflexion critica | 15% |

## 11. Discusion

El interes academico de este tema esta en mostrar que los LLM no eliminan la necesidad de arquitectura de software. Un modelo de lenguaje puede producir texto de alta calidad, pero no resuelve por si solo la disponibilidad, la concurrencia, la recuperacion ante errores ni el control de recursos.

Erlang/OTP ofrece una respuesta madura a esos problemas. Su modelo de procesos aislados, supervision jerarquica y paso de mensajes permite construir sistemas donde los fallos se contienen y se recuperan. En aplicaciones con LLM, esto es especialmente importante porque las llamadas al modelo pueden fallar por razones externas al programa: red, cuota, latencia, cambios de proveedor, autenticacion o saturacion.

Desde el punto de vista pedagogico, esta integracion permite ensenar a los estudiantes que la programacion funcional no es solamente una forma elegante de escribir funciones. Tambien es una base para construir sistemas concurrentes y robustos. En ese sentido, Erlang/OTP conecta directamente los conceptos del curso con problemas modernos de inteligencia artificial aplicada.

## 12. Conclusion

No existe actualmente un "Erlang con LLM" como lenguaje separado. Lo que si existe es una oportunidad tecnica clara: usar Erlang/OTP y Elixir/BEAM como infraestructura para sistemas que integran modelos de lenguaje grandes.

La idea central puede resumirse asi:

> El LLM genera, interpreta o resume lenguaje; Erlang/OTP mantiene vivo el sistema cuando hay concurrencia, timeouts, errores y fallos externos.

Para un curso de Programacion Logica y Funcional, este tema permite actualizar el estudio de Erlang con un caso contemporaneo. Los estudiantes no solo aprenden `gen_server` y `supervisor` como conceptos aislados, sino como herramientas para construir aplicaciones modernas de IA que requieren robustez real.

## Referencias

- Armstrong, J. (2003). *Making reliable distributed systems in the presence of software errors*. Royal Institute of Technology.
- Armstrong, J. (2007). *Programming Erlang: Software for a Concurrent World*. Pragmatic Bookshelf.
- Cesarini, F., & Thompson, S. (2009). *Erlang Programming*. O'Reilly Media.
- Cesarini, F., & Vinoski, S. (2016). *Designing for Scalability with Erlang/OTP*. O'Reilly Media.
- Erlang/OTP Documentation. *Design Principles*. https://www.erlang.org/doc/system/design_principles.html
- Erlang/OTP Documentation. *gen_server Behaviour*. https://www.erlang.org/doc/apps/stdlib/gen_server.html
- Erlang/OTP Documentation. *supervisor Behaviour*. https://www.erlang.org/doc/apps/stdlib/supervisor.html
- LangChain Elixir. *LangChain for Elixir documentation*. https://hexdocs.pm/langchain/readme.html
- OpenAI. *API documentation*. https://platform.openai.com/docs
