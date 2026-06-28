# Tema 3.3 — Unificación y Resolución SLD

## Objetivo

Entender el algoritmo de unificación de Martelli-Montanari y cómo Prolog
usa resolución SLD para responder consultas. Este mecanismo es el corazón
de todo Prolog.

## Ejecutar

```bash
# Tests automáticos
swipl -g "run_tests(unificacion), halt" -l unificacion.pl

# Interactivo
swipl -l unificacion.pl
?- unifica_y_muestra(f(X, b), f(a, Y)).
?- mi_unify(punto(3,4), punto(X,Y)).
```

## Algoritmo de Unificación (Martelli-Montanari) — 5 pasos

Dados dos términos T1 y T2, el algoritmo mantiene un conjunto de ecuaciones
por resolver `{T1 = T2, ...}` y aplica estas reglas hasta terminar o fallar:

1. **Delete:** Si la ecuación es `X = X`, eliminarla (trivialmente verdadera).
2. **Decompose:** Si `f(s1,...,sn) = f(t1,...,tn)`, reemplazar por `{s1=t1, ..., sn=tn}`.
3. **Orient:** Si `t = X` y t no es variable, reescribir como `X = t`.
4. **Eliminate:** Si `X = t` y X no aparece en t, sustituir X por t en todas las demás ecuaciones.
5. **Occurs check:** Si `X = f(...X...)`, **FALLA** — estructura circular (Prolog omite este paso por eficiencia).

## Resolución SLD

Prolog usa **SLD-resolución** (Selective Linear Definite):

1. Toma el primer objetivo de la consulta
2. Busca la primera cláusula cuya cabeza unifica con ese objetivo
3. Sustituye el objetivo con el cuerpo de esa cláusula
4. Repite hasta que no quedan objetivos (éxito) o no hay cláusula que unifique (backtrack)

## Árbol de búsqueda para `ancestro(abuelo, nieto)`

```
Base de hechos:
  padre(abuelo, padre).
  padre(padre, nieto).
  ancestro(X,Y) :- padre(X,Y).          % cláusula 1
  ancestro(X,Y) :- padre(X,Z), ancestro(Z,Y). % cláusula 2

Consulta: ?- ancestro(abuelo, nieto).
│
├─ Intento cláusula 1: ancestro(abuelo,nieto) = ancestro(X,Y), X=abuelo, Y=nieto
│   Nuevo objetivo: padre(abuelo, nieto)
│   ¿Existe padre(abuelo,nieto)? NO → BACKTRACK
│
└─ Intento cláusula 2: X=abuelo, Y=nieto
    Nuevo objetivo: padre(abuelo, Z), ancestro(Z, nieto)
    padre(abuelo, Z) unifica con padre(abuelo, padre) → Z=padre
    Nuevo objetivo: ancestro(padre, nieto)
    │
    ├─ Intento cláusula 1: padre(padre, nieto) → SÍ existe → ÉXITO ✓
    │   Respuesta: true
    │
    └─ [Backtrack daría segunda solución por cláusula 2, pero ya encontramos una]
```

## Preguntas de reflexión

1. ¿Por qué Prolog omite el occurs check por defecto? ¿Qué problema práctico resuelve esto y qué riesgo introduce?

2. Dado el árbol SLD de `ancestro/2`, ¿cuántos pasos de resolución se necesitan para encontrar que `ancestro(abuelo, nieto)` es verdadero?

3. ¿Qué diferencia hay entre `=` (unificación) y `==` (igualdad estructural sin unificación)? Da un ejemplo donde producen resultados distintos.

4. Si agregas la cláusula `padre(abuelo, tio).`, ¿cuántas soluciones produce `?- ancestro(abuelo, X).`? Traza el árbol.

5. ¿Por qué `?- X = f(X).` no termina en Prolog estándar? ¿Y con `unify_with_occurs_check/2`?
