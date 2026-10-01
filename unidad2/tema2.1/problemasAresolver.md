# Problemas a resolver — ¿Cuándo conviene un lenguaje funcional?

> Banco de problemas: [**Problemas para Resolver con Computadora**](https://github.com/tectijuana/problemasresolverporcomputadora)
> (Spencer 1985, capítulos 1–11 + extensión TecNM 2026, capítulos 12–22 — 1,153 problemas).

---

## Antes de programar: aprende a *mirar* el problema

Vas a elegir problemas de ese repositorio para resolverlos en Erlang. Casi ninguno
dice "resuélveme de forma funcional". Los capítulos 1–11 se escribieron en 1985 pensando en
BASIC y FORTRAN, así que el enunciado suele *sonar* imperativo: "introducir N",
"repetir hasta", "acumular el total".

Por eso, la habilidad que queremos que desarrolles no es traducir un `FOR` a Erlang,
sino **reconocer cuándo un problema ya es funcional por naturaleza** (aunque el
enunciado no lo parezca) y cuándo forzarlo sería un error. Esta guía te da un método
para hacer ese reconocimiento.

---

## Paso 1 — Describe la solución en una sola frase

Antes de escribir código, intenta decir en voz alta qué hace la solución. La forma
de esa frase te dice mucho:

| Si tu frase suena a… | Paradigma natural | Ejemplo del repositorio |
|---|---|---|
| "Es **esto aplicado a** aquello" / "de A obtengo B" | **Funcional** | Cap. 7, P25 — números perfectos |
| "**Encuentra los que cumplan** estas condiciones" | **Lógico** (Prolog, CLP(FD)) | Cap. 10, P14 — reinas que cubren el tablero |
| "**Primero** hago esto, **luego** modifico aquello" | Imperativo | Cap. 4, P2 — conversor de ángulos con menú |
| "Muchos **independientes** que se comunican y **pueden fallar**" | Funcional concurrente (Erlang/OTP) | Cap. 13, P10 — sensores sísmicos del CENAPRED |

Si tu frase cae en la primera o en la última fila, vas por buen camino con Erlang.

---

## Paso 2 — Busca las cinco señales funcionales

Revisa el enunciado y marca cuáles de estas señales aparecen. Mientras más señales
encuentres, más natural será la solución funcional.

### Señal 1 — La salida depende solo de la entrada
No hay un "estado del mundo" que cambie mientras el programa corre: das un dato y
obtienes un resultado, siempre el mismo.
*Dónde buscar:* casi todo el capítulo 7 (primos, números perfectos, Collatz,
palíndromos) y el capítulo 2 (álgebra).

### Señal 2 — El dato es recursivo por naturaleza
Listas, árboles, expresiones, los dígitos de un número. Si el problema se puede
describir como "el caso más pequeño" más "el resto", el *pattern matching* sustituye
a los `if` anidados.
*Dónde buscar:* Cap. 7, P92 ("sumar y voltear" hasta obtener un palíndromo);
Cap. 13, P8 (evaluador de expresiones).

### Señal 3 — Es un pipeline de datos
Leer → filtrar → transformar → agrupar → reducir. Cada etapa toma un dato y entrega
otro nuevo sin modificar el anterior.
*Dónde buscar:* capítulo 9 (nóminas, comisiones, IVA) y capítulo 5 (estadística).

### Señal 4 — Hay un acumulador disfrazado
Es la señal más importante para los problemas de Spencer. Cuando el enunciado (o tu
primera idea) tiene la forma:

```text
total = 0
PARA cada elemento HACER
    total = total + algo
FIN
```

eso **no es estado mutable: es un *fold***. La variable `total` se puede
reemplazar por un parámetro acumulador o por `lists:foldl/3`.

Ejemplo con el **Cap. 7, P25** (un número es perfecto si la suma de sus divisores
propios es igual a él mismo):

```erlang
%% Versión 1 — acumulador explícito (traducción directa del FOR), recursión de cola
suma_divisores(N) -> suma_divisores(N, 1, 0).
suma_divisores(N, D, Acc) when D > N div 2 -> Acc;
suma_divisores(N, D, Acc) when N rem D =:= 0 -> suma_divisores(N, D + 1, Acc + D);
suma_divisores(N, D, Acc) -> suma_divisores(N, D + 1, Acc).

%% Versión 2 — el mismo acumulador expresado como fold
suma_divisores_fold(N) ->
    lists:foldl(fun(D, Acc) -> Acc + D end, 0,
                [D || D <- lists:seq(1, N div 2), N rem D =:= 0]).

%% Versión 3 — ya pensando en funcional: "la suma de los divisores es N"
es_perfecto(N) ->
    lists:sum([D || D <- lists:seq(1, N div 2), N rem D =:= 0]) =:= N.

perfectos_hasta(M) -> [N || N <- lists:seq(2, M), es_perfecto(N)].
```

```text
1> criterio:perfectos_hasta(10000).
[6,28,496,8128]
2> criterio:es_perfecto(12).
false
```

Fíjate en el recorrido: la versión 1 todavía "piensa en BASIC", la 2 reconoce el
*fold* y la 3 dice exactamente lo que dice el enunciado. Las tres son correctas;
la tercera es la que muestra que **reconociste el patrón**.

### Señal 5 — Un error de cálculo cuesta caro
Si el resultado involucra dinero, calificaciones o identificadores oficiales
(CURP, RFC), conviene que el compilador o el sistema de tipos detecte errores
antes de ejecutar. Aquí destacan Haskell y OCaml, aunque Erlang ya aporta mucho con
inmutabilidad y *pattern matching* exhaustivo de casos.

---

## Paso 3 — Revisa los focos rojos (cuándo NO forzarlo)

Elegir bien también significa reconocer cuándo el paradigma funcional **no** es la
mejor herramienta. Si tu problema tiene alguna de estas características, piénsalo dos
veces o justifica por qué aun así lo resolviste en funcional:

- **Mutación masiva en su lugar.** Inversa de matrices (Cap. 6, P81) o el Juego de
  la Vida en cuadrículas grandes (Cap. 10, P45). Se pueden hacer en funcional, pero
  copiar la estructura en cada paso tiene un costo real de memoria y tiempo.
- **Interacción paso a paso con el usuario.** Menús y "introducir N" dentro de un
  ciclo. Se resuelve con un núcleo puro y una capa delgada de entrada/salida, pero
  el problema ya no es *naturalmente* funcional.
- **Búsqueda con restricciones.** Reinas, horarios, acertijos lógicos. Puedes
  resolverlos en funcional, pero es terreno de **Prolog / CLP(FD)**; saber
  distinguirlos es parte del criterio.
- **Hardware con memoria mínima** (capítulo 21). Ahí manda el control fino de
  la memoria.

---

## Paso 4 — La prueba rápida

Cuando tengas dudas, hazte esta pregunta:

> **¿Puedo darle nombre a cada valor intermedio sin reasignar ninguna variable?**
>
> - **Sí** → el problema es funcional.
> - **No, necesito "ir cambiando" algo** → pregúntate si ese algo es un acumulador
>   (entonces es un *fold* y sigue siendo funcional) o si de verdad es estado
>   (entonces revisa los focos rojos del Paso 3).

---

## Lo que se pide en cada programa entregado

Para cada uno de los problemas que resuelvas en Erlang, agrega al inicio del archivo
un comentario de justificación como este:

```erlang
%% Problema: Cap. 7, P25 — números perfectos
%% Frase:     "la suma de los divisores propios de N es igual a N"
%% Señales:   1 (salida solo depende de la entrada), 4 (acumulador → fold)
%% Focos rojos: ninguno (no hay menú ni mutación de matrices)
```

Que el programa funcione es apenas la mitad del trabajo. La otra mitad es que
**sepas explicar por qué Erlang fue una buena opción para ese problema**.

¿Escogiste un problema que prende algún foco rojo? Se vale, no hay penalización por
eso. Lo que sí te pedimos es que cuentes cómo lo sacaste adelante. Por ejemplo:
*"El problema pide un menú, así que dejé los cálculos en funciones puras y solo la
función `main` lee del teclado e imprime"*.

---

## Conexión con industria

Este criterio es el mismo que aplican los equipos que eligen BEAM en producción:
WhatsApp y Discord no usan Erlang/Elixir para todo, sino para la parte del sistema
donde las señales 3 (flujo de mensajes) y "muchos independientes que pueden fallar"
dominan. Elegir el paradigma por el problema, y no por moda, es la habilidad que se
espera de un ingeniero.
