# Tema 2.2 — Funciones de Primera Clase y Orden Superior
## Clojure: map, filter, reduce, comp, partial, transducers

---

## Objetivo

Dominar las funciones de orden superior (HOF) como herramienta principal de
composición en programación funcional. Al finalizar, el alumno será capaz de
construir pipelines de procesamiento de datos sin variables mutables.

---

## Ejecución

```bash
# Opción 1 — Clojure CLI (recomendado)
clj higher_order.clj

# Opción 2 — REPL interactivo (desarrollo real)
clj
=> (load-file "higher_order.clj")
=> (in-ns 'tectijuana.higher-order)
=> (alumnos-aprobados alumnos)
=> (promedio-grupo alumnos)
=> (con-beca alumnos)

# Opción 3 — si tienes Leiningen
lein exec higher_order.clj
```

---

## Conceptos clave

### Funciones como valores
En Clojure, las funciones son valores de primera clase — se pueden asignar
a variables, pasar como argumentos, retornar como resultado:

```clojure
;; Una función es un valor
(def mi-suma +)
(mi-suma 3 4)  ;; => 7

;; Pasar función como argumento
(map inc [1 2 3])  ;; => (2 3 4)

;; Función anónima
(filter #(> % 5) [3 7 2 9 1])  ;; => (7 9)
```

### map — transformar sin mutar
```clojure
;; map aplica una función a cada elemento, retorna nueva colección
(map :promedio alumnos)
;; => (8.5 5.8 9.1 7.3 ...)
```

### filter — seleccionar
```clojure
(filter #(>= (:promedio %) 8.0) alumnos)
;; retorna solo los alumnos con promedio >= 8.0
```

### reduce — colapsar
```clojure
(reduce + [8.5 5.8 9.1 7.3])  ;; => 30.7
```

### comp — composición de funciones
```clojure
;; (comp f g) retorna una función que aplica g primero, luego f
(def mayus-nombre (comp clojure.string/upper-case :nombre))
(mayus-nombre (first alumnos))  ;; => "GARCÍA RAMÍREZ, CARLOS"
```

### Transducers — pipeline sin colecciones intermedias
```clojure
;; Sin transducers: 3 colecciones temporales en memoria
(->> datos (filter f) (map g) (filter h))

;; Con transducers: cero colecciones intermedias
(into [] (comp (filter f) (map g) (filter h)) datos)
```

---

## Assignment

**Parte 1 — Agregar al archivo `higher_order.clj`:**

```clojure
;; 1. estadisticas-unidad/1
;; Dada una lista de alumnos de una unidad, retorna un mapa con:
;; {:unidad "..." :total N :aprobados N :reprobados N :promedio X.X :mejor-alumno "..."}
(defn estadisticas-unidad [alumnos] ...)

;; 2. ranking/1
;; Retorna la lista de alumnos ordenada de mayor a menor promedio.
;; Usar sort-by — función de orden superior que recibe una función llave.
(defn ranking [alumnos] ...)

;; 3. buscar-alumno/2
;; Buscar por matrícula. Retornar nil si no existe (nunca lanzar excepción).
(defn buscar-alumno [matricula alumnos] ...)

;; 4. actualizar-promedio/3
;; Retornar nueva colección con el promedio del alumno dado actualizado.
;; La colección original NO debe cambiar.
(defn actualizar-promedio [matricula nuevo-promedio alumnos] ...)
```

**Parte 2 — Demostrar en el `-main`:**
- Llamar `estadisticas-unidad` para cada unidad del `reporte-por-unidad`
- Mostrar `ranking` completo
- Buscar la matrícula "C2350007" y mostrar sus datos
- Actualizar el promedio de "C2250002" a 7.5 y mostrar que el original no cambió

**Parte 3 — Reflexión (comentar en el código):**
1. ¿Por qué `actualizar-promedio` debe retornar una nueva colección en vez de mutar la original?
2. ¿Cuál es la ventaja de los transducers sobre encadenar `filter`+`map`+`filter` directamente?
3. Nubank procesa millones de transacciones SPEI con este patrón. ¿Qué garantía da la inmutabilidad en ese contexto financiero?

---

## Criterios de evaluación

| Criterio | Peso |
|----------|------|
| Las 4 funciones compilan y producen resultado correcto | 40% |
| Uso exclusivo de HOF (sin loops, sin variables mutables) | 30% |
| Demostración ejecutable en `-main` | 20% |
| Respuestas de reflexión en comentarios | 10% |

---

## Conexión con Nubank

Nubank es el banco digital más grande de América Latina, fundado en Brasil en 2013.
Su stack técnico está construido sobre **Clojure**. Las mismas funciones
`map`, `filter`, `reduce` que usas aquí procesan millones de transacciones SPEI-equivalentes.

La inmutabilidad garantiza que dos transacciones concurrentes nunca se corrompan
mutuamente — sin locks, sin mutexes, sin deadlocks.

> "Clojure's immutable data structures made it easy to reason about concurrent
> financial transactions." — Engineering blog de Nubank, 2021
