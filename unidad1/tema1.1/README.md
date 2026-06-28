# Tema 1.1 — Introducción a la Programación Lógica y Funcional
## Assignment: "Hola Paradigma"

### Objetivo

Experimentar de primera mano la diferencia entre el paradigma imperativo,
el funcional y el lógico resolviendo el mismo problema trivial en los tres.
El problema es simple a propósito: queremos que la atención vaya al *cómo piensa
cada paradigma*, no a la complejidad del problema.

---

### El problema

Imprimir los números del 1 al 10, uno por línea.

Eso es todo. Pero hazlo en tres lenguajes distintos, con tres formas de pensar distintas.

---

### Lenguaje 1 — Python (imperativo)

```python
# Cómo correrlo:
# python3 hola_paradigma.py

for i in range(1, 11):
    print(i)
```

**Qué está pasando:** hay una variable `i` que *muta* en cada iteración.
El programa es una secuencia de instrucciones que modifican estado.

---

### Lenguaje 2 — Erlang (funcional)

Archivo: `hola_paradigma.erl`

```erlang
-module(hola_paradigma).
-export([main/0]).

main() ->
    imprimir(1).

imprimir(11) ->
    ok;
imprimir(N) ->
    io:format("~w~n", [N]),
    imprimir(N + 1).
```

**Cómo compilar y correr:**
```bash
erlc hola_paradigma.erl
erl -noshell -s hola_paradigma main -s init stop
```

**Qué está pasando:** no existe ninguna variable que cambie de valor.
`N` recibe un valor al entrar a la función y nunca se modifica.
La "iteración" es recursión: cada llamada a `imprimir/1` crea un nuevo
contexto con un `N` diferente. Erlang optimiza esto con TCO (Tail Call Optimization)
— no apila frames.

**Pregunta de reflexión obligatoria en tu entrega:**
> ¿Qué mecanismo del lenguaje Erlang hace imposible que dos procesos
> corriendo `imprimir/1` simultáneamente interfieran entre sí?
> Responde en máximo 5 líneas. Pista: busca "Erlang message passing" y "shared nothing".

---

### Lenguaje 3 — Prolog (lógico)

Archivo: `hola_paradigma.pl`

```prolog
% hola_paradigma.pl
% imprimir_hasta/1 -- determinista
% imprimir_hasta(+N:integer) is det
% Imprime los enteros de 1 a N en orden ascendente.

imprimir_hasta(Max) :-
    imprimir_desde(1, Max).

imprimir_desde(Actual, Max) :-
    Actual > Max, !.
imprimir_desde(Actual, Max) :-
    write(Actual), nl,
    Siguiente is Actual + 1,
    imprimir_desde(Siguiente, Max).
```

**Cómo correr en SWI-Prolog:**
```bash
swipl -g "imprimir_hasta(10), halt." hola_paradigma.pl
```

**O en el REPL interactivo:**
```bash
swipl hola_paradigma.pl
?- imprimir_hasta(10).
```

**Qué está pasando:** no describimos cómo iterar. Describimos relaciones.
`imprimir_desde/2` dice: "si Actual > Max, termina; de lo contrario,
escribe Actual y prueba que imprimir_desde(Siguiente, Max) es verdad."
El motor de Prolog decide cómo satisfacer esa relación.

---

### Tu entrega

Crea una carpeta con tu número de control. Adentro:

```
A00123456/
├── hola_paradigma.erl      ← debe compilar con erlc
├── hola_paradigma.pl       ← debe correr con swipl
├── reflexion.md            ← respuesta a la pregunta sobre Erlang (5 líneas máx)
└── evidencia.txt           ← captura o salida de cada programa corriendo
```

Sube a GitHub Classroom antes del inicio de la siguiente sesión.

---

### Criterios de evaluación

| Criterio | Puntos |
|----------|--------|
| `hola_paradigma.erl` compila con `erlc` sin warnings | 30 |
| `hola_paradigma.pl` corre con `swipl` sin errores | 30 |
| Pregunta de reflexión respondida con precisión técnica | 30 |
| Evidencia de ejecución de los dos programas | 10 |
| **Total** | **100** |

Ver [comparativa.md](comparativa.md) para el análisis de fondo entre los tres paradigmas.
