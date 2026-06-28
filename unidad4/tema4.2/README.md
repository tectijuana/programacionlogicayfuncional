# Tema 4.2 — Estrategias de Búsqueda en Prolog

## Objetivo

Dominar DFS y BFS implementados en Prolog, comprender cuándo usar cada uno,
y entender los tres operadores de recolección: `findall`, `bagof`, `setof`.

## Ejecutar

```bash
# DFS
swipl -l busqueda_dfs.pl
?- camino_dfs(balderas, consulado, Camino).
?- longitud_camino(Camino, N).

# BFS
swipl -l busqueda_bfs.pl
?- camino_minimo(balderas, consulado, Camino).

# Estrategias (cut, findall, bagof, setof)
swipl -l estrategias.pl
?- demo_cut_verde.
?- demo_findall.
```

## DFS vs BFS — comparativa

| Característica | DFS (profundidad) | BFS (amplitud) |
|---|---|---|
| Implementación en Prolog | Natural — es lo que Prolog hace | Requiere cola explícita |
| ¿Garantiza mínimo? | **No** — puede dar camino largo | **Sí** — siempre el más corto |
| Memoria | O(profundidad) — lineal | O(ancho) — exponencial en peor caso |
| Útil cuando | El grafo es profundo o el objetivo es lejano | Necesitas el camino más corto |
| Peligro | Puede no terminar con ciclos sin visited | Usa más memoria |

## Cut: verde vs. rojo

**Cut verde:** no cambia el conjunto de soluciones, solo mejora eficiencia.
```prolog
maximo(X, Y, X) :- X >= Y, !.   % cut verde — si X>=Y, ya no hay otra solución
maximo(_, Y, Y).
```

**Cut rojo:** cambia el conjunto de soluciones (¡peligroso!).
```prolog
% Sin cut: primero/2 da solo el primer elemento
primero([H|_], H) :- !.   % cut rojo — impide buscar otros
primero([_|T], X) :- primero(T, X).
% Si quitamos el cut, primero/2 daría todos los elementos
```

## findall vs bagof vs setof

| Operador | Si no hay soluciones | Duplicados | Orden |
|---|---|---|---|
| `findall(T,G,L)` | `L = []` (no falla) | Los mantiene | De izquierda a derecha |
| `bagof(T,G,L)` | **Falla** | Los mantiene | De izquierda a derecha |
| `setof(T,G,L)` | **Falla** | Los elimina | Ordenado |

## Preguntas de reflexión

1. ¿Por qué DFS puede no terminar en grafos con ciclos? ¿Cómo lo soluciona el argumento `Visitados`?
2. Si el grafo tiene pesos en las aristas, ¿qué algoritmo usarías en lugar de BFS? ¿Cómo lo implementarías en Prolog?
3. ¿Cuándo es `bagof` preferible a `findall`? Da un ejemplo donde la falla de `bagof` es útil.
4. Explica por qué quitar el cut de `maximo/3` no cambia los resultados pero sí el rendimiento.
5. ¿Cómo implementarías A* (búsqueda heurística) en Prolog usando las mismas ideas de BFS con cola?
