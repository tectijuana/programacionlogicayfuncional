# Tema 3.4 — Listas y Aritmética en Prolog

## Objetivo

Implementar desde cero los predicados fundamentales de listas, entender
los modos de predicados (+/-/?) y dominar la aritmética Prolog (la diferencia
entre `=`, `is` y `=:=` es fundamental).

## Ejecutar

```bash
# Tests de listas
swipl -g "run_tests(listas), halt" -l listas.pl

# Tests de aritmética
swipl -g "run_tests(aritmetica), halt" -l aritmetica.pl

# Interactivo con ambos
swipl -l listas.pl -l aritmetica.pl
```

## Modos de predicados

La notación de modos describe cómo debe estar el argumento:

| Símbolo | Significado |
|---------|-------------|
| `+`     | Debe estar instanciado (entrada) |
| `-`     | Se instanciará (salida) |
| `?`     | Puede estar instanciado o no |

Ejemplo: `mi_append(+Lista1, +Lista2, -Resultado)` significa que Lista1 y
Lista2 deben estar completas, y Resultado se calculará.

Pero `mi_append(?L1, ?L2, +Total)` también funciona — Prolog puede calcular
todas las particiones de Total.

## Aritmética: la diferencia crítica

```prolog
% = es UNIFICACIÓN — no evalúa
X = 1 + 2.          % X = 1+2 (la estructura, no el número 3)

% is EVALÚA la expresión aritmética
X is 1 + 2.         % X = 3

% =:= compara valores numéricos (evalúa ambos lados)
1 + 2 =:= 3.        % true

% == es igualdad ESTRUCTURAL (sin unificación ni evaluación)
1+2 == 1+2.         % true
1+2 == 3.           % false
```

## Preguntas de reflexión

1. ¿Por qué `mi_member(X, [1,2,3])` genera múltiples soluciones con `;`?
   ¿Cuántas produce y en qué orden?

2. `mi_append/3` puede usarse en tres modos distintos. Describe qué hace en
   cada modo y da un ejemplo de consulta.

3. ¿Por qué `mi_length/2` usa un acumulador? ¿Qué pasaría sin él en listas muy largas?

4. Explica por qué `X is 1 + 2` funciona pero `1 + 2 is X` falla.

5. ¿Cuál es la diferencia entre `mi_max_list` que falla en lista vacía y una versión
   que retorna un valor especial como `none`? ¿Cuál es mejor diseño en Prolog?
