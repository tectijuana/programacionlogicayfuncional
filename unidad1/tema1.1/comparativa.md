# Comparativa de Paradigmas — Imprimir [1..10]

## El mismo problema, tres formas de pensar

| Dimensión | Python (imperativo) | Erlang (funcional) | Prolog (lógico) |
|-----------|--------------------|--------------------|-----------------|
| **Abstracción central** | Secuencia de instrucciones | Aplicación de funciones | Satisfacción de relaciones |
| **Estado** | Variable `i` muta en cada paso | Sin variables mutables | Sin variables en el sentido OOP |
| **"Iteración"** | Bucle `for` explícito | Recursión de cola (TCO) | Unificación + backtracking |
| **¿Qué describe el código?** | *Cómo* hacerlo paso a paso | *Qué* transformar | *Qué* es verdad |
| **Líneas de código** | 2 | 8 | 8 |
| **Race condition posible** | Sí (con threading) | No (datos inmutables) | No aplica |
| **¿Puede haber múltiples respuestas?** | No | No | Sí (con `;`) |
| **Tail call optimization** | No (CPython) | Sí (siempre) | Sí (last call optimization) |

---

## ¿Por qué le importa esto a un ingeniero de sistemas?

### Caso 1 — El bug de concurrencia que no puede pasar en Erlang

En Python, este código tiene un bug cuando dos hilos lo ejecutan a la vez:

```python
# BUG: counter es estado compartido mutable
counter = 0

def incrementar():
    global counter
    for _ in range(100_000):
        counter += 1   # read-modify-write: NO es atómica

import threading
t1 = threading.Thread(target=incrementar)
t2 = threading.Thread(target=incrementar)
t1.start(); t2.start()
t1.join();  t2.join()
print(counter)  # Probablemente < 200_000 — race condition
```

En Erlang, este bug es structuralmente imposible:

```erlang
-module(contador).
-behaviour(gen_server).
-export([start_link/0, incrementar/0, valor/0]).
-export([init/1, handle_cast/2, handle_call/3]).

start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, 0, []).
incrementar() -> gen_server:cast(?MODULE, inc).
valor()       -> gen_server:call(?MODULE, valor).

init(0)                       -> {ok, 0}.
handle_cast(inc, N)           -> {noreply, N + 1}.
handle_call(valor, _From, N)  -> {reply, N, N}.
```

El estado vive dentro de un proceso. Solo ese proceso lo toca.
No hay memoria compartida. No puede haber race condition.
Este es el modelo que usa WhatsApp para 2 mil millones de usuarios.

### Caso 2 — Prolog resuelve hacia atrás

El poder de Prolog es que puedes hacer la misma pregunta en dos direcciones:

```prolog
% Con esta sola definición:
entre(Bajo, Alto, X) :-
    Bajo =< Alto,
    (X = Bajo ; Bajo1 is Bajo + 1, entre(Bajo1, Alto, X)).

% Puedes preguntar hacia adelante:
?- entre(1, 10, X).
X = 1 ; X = 2 ; ... X = 10.

% O hacia atrás:
?- entre(1, 10, 7).
true.

% O verificar:
?- entre(1, 10, 15).
false.
```

Ningún lenguaje imperativo hace esto con el mismo código.

---

## Taxonomía completa de paradigmas

```
Paradigmas de programación
├── Imperativo
│   ├── Procedural (C, Pascal)
│   └── Orientado a Objetos (Java, C#, Python)
├── Declarativo
│   ├── Funcional
│   │   ├── Puro (Haskell, Elm)
│   │   └── Impuro/Híbrido (Erlang, Elixir, OCaml, Clojure, F#, Scala)
│   ├── Lógico (Prolog, Datalog, ASP/Clingo)
│   └── Reactivo (RxJS, Elm Architecture)
└── Concurrente
    ├── Threads + locks (Java, C++)
    ├── Actor model (Erlang, Akka)
    └── CSP / canales (Go, Clojure core.async)
```

Los lenguajes del semestre:
- **SWI-Prolog** → Lógico puro
- **Erlang/OTP** → Funcional impuro + Actor model
- **Elixir** → Funcional moderno sobre BEAM (mismo runtime que Erlang)
- **Haskell** → Funcional puro (GHC)
- **Clojure** → Funcional impuro sobre JVM, con STM para estado coordinado
