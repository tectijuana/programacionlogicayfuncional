# Inducción Estructural — Semana 6

**Unidad 2 · Tema 2.3 — Recursión e Inmutabilidad**  
**Lenguaje:** Haskell  
**Nivel Bloom:** Evaluar → Crear

---

## ¿Por qué demostrar que el código es correcto?

En paradigma funcional existe una garantía que el imperativo no puede dar fácilmente:
si una función es **pura** (sin efectos secundarios), podemos razonar sobre ella
matemáticamente, igual que en álgebra.

Cuando optimizamos `reverse` con un acumulador para lograr O(n) en lugar de O(n²),
¿cómo sabemos que el resultado es *idéntico* a la versión original y no solo "parece funcionar"?

La respuesta es **inducción estructural** — la misma técnica que usa Haskell internamente
para garantizar sus abstracciones, y que CMU, MIT y Cambridge exigen en sus cursos de FP.

---

## Las dos implementaciones

```haskell
-- Versión ingenua: O(n²) — append es O(n), se llama n veces
reverseNaive :: [a] -> [a]
reverseNaive []     = []
reverseNaive (x:xs) = reverseNaive xs ++ [x]

-- Versión con acumulador: O(n) — tail-recursive
reverseAcc :: [a] -> [a] -> [a]
reverseAcc []     acc = acc
reverseAcc (x:xs) acc = reverseAcc xs (x:acc)

-- API pública — oculta el acumulador
myReverse :: [a] -> [a]
myReverse xs = reverseAcc xs []
```

**Pregunta:** ¿`myReverse xs == reverseNaive xs` para toda lista `xs`?

QuickCheck puede dar evidencia, pero no certeza. La inducción da certeza.

---

## Paso 0: Propiedades algebraicas que usaremos

Antes de la prueba principal, necesitamos tres lemas básicos de listas:

**L1 — Identidad del append:**
```
[] ++ ys  =  ys                    (definición de ++)
(x:xs) ++ ys  =  x : (xs ++ ys)   (definición de ++)
```

**L2 — Asociatividad del append:** (demostrada por inducción, la usamos sin redeprobar)
```
(xs ++ ys) ++ zs  =  xs ++ (ys ++ zs)
```

**L3 — Elemento singleton:**
```
x : ys  =  [x] ++ ys              (por L1 con xs := [x])
```

---

## Lema Principal

Para poder probar el teorema, necesitamos un lema más fuerte que generaliza el acumulador.

**Lema:** Para toda lista `xs` y toda lista `acc`:

```
reverseAcc xs acc  =  reverseNaive xs ++ acc
```

### Prueba por inducción estructural sobre `xs`

**Caso base:** `xs = []`

```
reverseAcc [] acc
= acc                              (def. de reverseAcc, cláusula 1)
= [] ++ acc                        (por L1: [] ++ acc = acc)
= reverseNaive [] ++ acc           (def. de reverseNaive: reverseNaive [] = [])
```
✓ El caso base se sostiene.

---

**Hipótesis inductiva (HI):** Supongamos que para alguna lista `zs` y *toda* lista `acc`:

```
reverseAcc zs acc  =  reverseNaive zs ++ acc
```

**Caso inductivo:** Debemos probar que para `xs = z : zs` y toda lista `acc`:

```
reverseAcc (z:zs) acc  =  reverseNaive (z:zs) ++ acc
```

Desarrollamos el lado izquierdo:

```
reverseAcc (z:zs) acc
= reverseAcc zs (z:acc)            (def. de reverseAcc, cláusula 2)
= reverseNaive zs ++ (z:acc)       (por HI, con acc := z:acc)
= reverseNaive zs ++ ([z] ++ acc)  (por L3: z:acc = [z] ++ acc)
= (reverseNaive zs ++ [z]) ++ acc  (por L2: asociatividad)
= reverseNaive (z:zs) ++ acc       (def. de reverseNaive, cláusula 2, invertida)
```

✓ El caso inductivo se sostiene.

**Por el principio de inducción estructural**, el lema es verdadero para toda lista `xs`. □

---

## Teorema Principal

**Teorema:** Para toda lista `xs`:

```
myReverse xs  =  reverseNaive xs
```

**Prueba:**

```
myReverse xs
= reverseAcc xs []                 (def. de myReverse)
= reverseNaive xs ++ []            (por el Lema, con acc := [])
= reverseNaive xs                  (por L1 aplicado a la derecha: xs ++ [] = xs)
```

✓ **QED** — `myReverse` es extensionalmente equivalente a `reverseNaive`. □

---

## Implicación práctica

Haskell no necesita ejecutar millones de casos de prueba para saber que `myReverse`
es correcto. La prueba anterior es una **garantía absoluta** válida para listas de
cualquier longitud y cualquier tipo — lo que ningún test puede dar.

Esta es la razón por la que lenguajes como Haskell, Coq, Lean y Agda se usan en
sistemas de alta confiabilidad: cohetes SpaceX, kernels seL4, compiladores de criptografía.

---

## Verificación computacional con QuickCheck

La prueba matemática dice que son equivalentes. QuickCheck lo confirma empíricamente:

```bash
ghc -package QuickCheck induccion_estructural.hs -o prueba && ./prueba
```

Ver código: [`induccion_estructural.hs`](induccion_estructural.hs)

---

## Práctica — Tu turno

**Entregable:** Completa las siguientes pruebas por inducción estructural.
Escribe cada paso con su justificación (como en el ejemplo anterior).

### Ejercicio 1 — `length` y `append`

Demuestra que para toda lista `xs` y `ys`:

```
length (xs ++ ys)  =  length xs + length ys
```

Definiciones relevantes:
```haskell
length []     = 0
length (_:xs) = 1 + length xs

[]     ++ ys = ys
(x:xs) ++ ys = x : (xs ++ ys)
```

*Pista: inducta sobre `xs`.*

---

### Ejercicio 2 — `map` y `append`

Demuestra que para toda función `f` y listas `xs`, `ys`:

```
map f (xs ++ ys)  =  map f xs ++ map f ys
```

Definiciones relevantes:
```haskell
map _ []     = []
map f (x:xs) = f x : map f xs
```

---

### Ejercicio 3 — `reverse` doble (reto)

Demuestra que para toda lista `xs`:

```
reverseNaive (reverseNaive xs)  =  xs
```

*Pista: necesitarás el Lema de esta sesión más un lema adicional sobre `reverse` y `append`.*

---

## Formato de entrega

Sube tu prueba como archivo `induccion_MATRICULA.md` en un Pull Request a
`unidad2/tema2.3/entregas/`. Cada paso debe tener su justificación en paréntesis,
igual que la prueba demostrativa de esta sesión.

**Criterio de evaluación:**

| Criterio | Puntos |
|----------|--------|
| Caso base correcto con justificación | 25 |
| Hipótesis inductiva enunciada correctamente | 25 |
| Caso inductivo con cada paso justificado | 40 |
| Conclusión formal (QED) | 10 |

---

## Referencias

- Bird, R. (2014). *Thinking Functionally with Haskell*. Cambridge University Press. Cap. 6.
- Harper, R. (2016). *Practical Foundations of Mathematics for Computer Science*. (libre en línea)
- CMU 15-150 Lecture Notes on Structural Induction: https://www.cs.cmu.edu/~15150/
