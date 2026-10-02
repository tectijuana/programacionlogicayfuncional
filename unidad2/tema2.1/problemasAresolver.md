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

---

## Quiz — ¿Ya sabes reconocer un problema funcional?

Responde sin ver la guía. Las respuestas están al final, ocultas: ábrelas solo
cuando hayas terminado.

**1.** Describes tu solución así: *"encuentra todas las formas de acomodar a los
alumnos en los salones sin que choquen horarios"*. ¿Qué paradigma es el más natural?

- a) Funcional
- b) Lógico (Prolog / CLP(FD))
- c) Imperativo

**2.** ¿Qué señal funcional aparece en este pseudocódigo de BASIC?

```text
S = 0
FOR I = 1 TO N
    S = S + I * I
NEXT I
```

- a) Señal 2 — dato recursivo
- b) Señal 4 — acumulador disfrazado (*fold*)
- c) Ninguna: `S` cambia, así que es estado mutable

**3.** Cap. 9, P11: 10 vendedores, sueldo base de \$9,000 más 5% de comisión sobre
sus ventas; calcular lo que gana cada uno. ¿Qué señal domina?

- a) Señal 3 — pipeline de datos
- b) Señal 5 — un error cuesta caro, solo eso
- c) Es un foco rojo: hay que modificar la lista de vendedores

**4.** Verdadero o falso: *"Si un problema prende un foco rojo, está prohibido
resolverlo en Erlang"*.

**5.** ¿Cuál de estos problemas prende un **foco rojo** para el enfoque funcional?

- a) Cap. 7, P85 — la conjetura de Collatz
- b) Cap. 6, P81 — calcular la inversa de una matriz
- c) Cap. 7, P14 — primos palíndromos

**6.** Escribe la **frase** (Paso 1) que describe el Cap. 7, P14: encontrar los
números primos que siguen siendo primos al invertir sus dígitos.

**7.** En Erlang, `X = 5.` seguido de `X = 10.` produce un error. ¿Cuál de las
cinco señales se apoya directamente en esa garantía para que la prueba rápida
(Paso 4) funcione?

**8.** Un sistema recibe lecturas de 200 sensores sísmicos; si un sensor se cae, el
sistema debe seguir funcionando y reiniciarlo. ¿Por qué Erlang/OTP es buena opción
aquí y no solo "cualquier lenguaje funcional"?

**9.** Cap. 4, P2 pide un **menú** para convertir grados ↔ radianes. Si decides
resolverlo en Erlang, ¿cómo organizas el código para respetar el paradigma?

**10.** Completa el comentario de justificación para el **Cap. 7, P85** (Collatz):

```erlang
%% Problema: Cap. 7, P85 — conjetura de Collatz
%% Frase:     ...
%% Señales:   ...
%% Focos rojos: ...
```

<details>
<summary><strong>Respuestas</strong> (ábrelas al terminar)</summary>

1. **b)** "Encuentra los que cumplan…" es la frase típica del paradigma lógico.
   Es un problema de restricciones (compáralo con Cap. 13, P33).
2. **b)** `S` es un acumulador: equivale a
   `lists:foldl(fun(I, S) -> S + I * I end, 0, lists:seq(1, N))`.
   Que "cambie" no lo vuelve estado: cada vuelta produce un valor nuevo.
3. **a)** Lista de ventas → calcular comisión → sumar al sueldo base. Es un `map`
   sobre la lista; no se modifica nada, se produce una lista nueva.
4. **Falso.** Se vale; solo debes explicar cómo lo resolviste (por ejemplo,
   separando el núcleo puro de la entrada/salida).
5. **b)** La inversa de una matriz se calcula con muchas modificaciones en su
   lugar; en funcional implica copiar la matriz en cada paso. Collatz y los primos
   palíndromos dependen solo de la entrada.
6. Algo como: *"los primos de la lista cuyo número invertido también es primo"*.
   Es un `filter` con dos condiciones.
7. La garantía de **asignación única** es la que permite contestar "sí" a
   *"¿puedo nombrar cada valor intermedio sin reasignar?"*. Se relaciona sobre
   todo con la **señal 1**: si nada cambia, la salida solo depende de la entrada.
8. Porque además de inmutabilidad, OTP ofrece **procesos ligeros y supervisores**
   (*"let it crash"*): cada sensor es un proceso y un supervisor lo reinicia si
   falla. Esa tolerancia a fallos no la da cualquier lenguaje funcional.
9. Cálculos (`grados_a_radianes/1`, `radianes_a_grados/1`) como **funciones
   puras**; una función aparte, delgada, que lee la opción del teclado, llama a la
   función pura e imprime. Así el foco rojo queda aislado.
10. Ejemplo de respuesta:
    ```erlang
    %% Problema: Cap. 7, P85 — conjetura de Collatz
    %% Frase:     "la secuencia de N es N seguido de la secuencia del siguiente término, hasta llegar a 1"
    %% Señales:   1 (solo depende de N), 2 (definición recursiva)
    %% Focos rojos: ninguno
    ```

</details>
