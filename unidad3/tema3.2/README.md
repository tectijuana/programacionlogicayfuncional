# Tema 3.2 — Reglas, Negación como Falla y Semántica del Mundo Cerrado

## Objetivo

Comprender cómo las reglas de Prolog representan implicación lógica, dominar la
negación como falla (`\+`) y entender sus diferencias con la negación clásica.

## Ejecutar los tests

```bash
swipl -g "run_tests(becas), halt" -l reglas_negacion.pl
```

## Ejecutar interactivamente

```bash
swipl -l reglas_negacion.pl
?- elegible_beca(garcia_lopez).
?- findall(N, elegible_beca(N), Lista), write(Lista).
?- no_elegible_razon(perez_ruiz, Razon).
```

---

## Conceptos clave

### Regla como implicación lógica

```prolog
cabeza :- cuerpo1, cuerpo2.
```

Significa: **si** `cuerpo1` Y `cuerpo2` son verdaderos, **entonces** `cabeza` es verdadero.
Es la implicación `cuerpo1 ∧ cuerpo2 → cabeza` escrita al revés.

### Negación como falla (`\+`) vs. negación lógica clásica

| | Negación clásica (lógica) | Negación como falla (`\+`) |
|---|---|---|
| Significado | "Es falso que X" | "No hay prueba de que X" |
| Mundo abierto | Sí — puede haber info desconocida | No — asume mundo cerrado |
| En Prolog | No disponible directamente | `\+ Goal` |

**Ejemplo crítico:**

```prolog
padre(carlos, ana).
% NO hay hecho padre(carlos, luis).

?- \+ padre(carlos, luis).   % true — no hay PRUEBA de que sea padre
% Pero esto NO significa que Carlos no sea padre de Luis en el mundo real.
% Significa: "en nuestra base de conocimiento, no existe esa relación."
```

**Regla del mundo cerrado:** Prolog asume que todo lo que no está en la base
de conocimiento es falso. Si el hecho no está, es que no existe.

### Cuándo `\+` puede dar resultados sorprendentes

```prolog
% Si X no está instanciada antes de \+, el resultado puede ser incorrecto:
?- \+ padre(X, ana).   % false, porque SÍ existe padre(carlos, ana)
% Pero si cambiamos la base y no hay NINGÚN padre de ana:
?- \+ padre(X, juan).  % true — pero ¿esto significa que nadie es padre de juan?
```

**Regla práctica:** siempre instanciar las variables antes de usar `\+`.

---

## Preguntas de reflexión

1. ¿Por qué `\+ padre(X, Y)` puede dar resultados incorrectos cuando X o Y no están instanciadas? Construye un ejemplo concreto.

2. ¿Cuál es la diferencia entre escribir `no_padre(X, Y) :- \+ padre(X, Y)` y simplemente usar `\+` directamente en una consulta? ¿Cambia la semántica?

3. En el sistema de becas, la regla `elegible_beca/1` usa corte (`!`). ¿Qué pasa si eliminas el corte? ¿Cuántas soluciones produce?

4. ¿Por qué es problemático usar `\+` para implementar la regla "el alumno no debe tener materias reprobadas" si la lista de materias está incompleta?

5. La negación como falla implementa el **principio del mundo cerrado**. ¿En qué sistemas del mundo real este principio es una ventaja? ¿En cuáles es un problema?
