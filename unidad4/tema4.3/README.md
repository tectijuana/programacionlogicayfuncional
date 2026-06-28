# Tema 4.3 — Optimización: CLP(FD) — Constraint Logic Programming

## Objetivo

Entender la diferencia entre **backtracking puro** y **propagación de restricciones**,
y usar CLP(FD) para resolver problemas combinatorios de forma eficiente.

## Ejecutar

```bash
# Ejemplos básicos
swipl -g "run_tests(clpfd), halt" -l clpfd_basico.pl

# Sudoku
swipl -g "sudoku_facil(P), resolver_sudoku(P), imprimir_sudoku(P), halt" -l sudoku.pl

# Horarios TecNM
swipl -g "generar_horario(H), imprimir_horario(H), halt" -l horarios_tec.pl
```

## Backtracking puro vs. CLP(FD)

### Backtracking puro — el problema

```prolog
% Sin CLP: genera y prueba — muy lento
entre(1, 9, X), entre(1, 9, Y), X + Y =:= 10, X \= Y.
% Genera TODAS las combinaciones (81) y prueba cada una
```

### CLP(FD) — propagación de restricciones

```prolog
:- use_module(library(clpfd)).
% Con CLP: el motor DEDUCE valores posibles antes de probar
X in 1..9, Y in 1..9, X + Y #= 10, X #\= Y, label([X,Y]).
% El motor sabe que si X=1, Y debe ser 9; si X=5, Y=5 viola X#\=Y, etc.
% Explora MUCHO menos espacio
```

## Operadores CLP(FD)

| Operador | Significado |
|----------|-------------|
| `X in 1..9` | X toma valores entre 1 y 9 |
| `X ins 1..9` | lista de variables toman valores en 1..9 |
| `X #= Y` | X igual a Y (aritmético) |
| `X #\= Y` | X diferente de Y |
| `X #< Y` | X menor que Y |
| `X #> Y` | X mayor que Y |
| `all_distinct(Lista)` | todos los elementos son distintos |
| `label([X,Y,...])` | fuerza la asignación de valores concretos |
| `sum(Lista, #=, Total)` | suma de la lista igual a Total |

## Preguntas de reflexión

1. ¿Por qué CLP(FD) es más eficiente que backtracking puro para Sudoku?
   Estima cuántas combinaciones exploraría cada uno.

2. En el problema de N reinas, ¿qué restricciones CLP(FD) son necesarias?
   ¿Cómo se expresan las diagonales?

3. ¿Qué pasa si llamas `label/1` antes de agregar todas las restricciones?
   ¿Y después? Experimenta y explica la diferencia.

4. El CSP de horarios TecNM tiene variables Hora y Salon por materia.
   ¿Qué restricción evita que dos materias coincidan en mismo lugar y hora?

5. ¿Cómo extenderías `horarios_tec.pl` para que los profesores tampoco
   tengan conflictos de horario? ¿Qué nuevas variables y restricciones necesitas?
