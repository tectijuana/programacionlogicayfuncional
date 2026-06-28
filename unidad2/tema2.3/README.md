# Tema 2.3 — Recursión y Estructuras de Datos Inmutables

**Lenguaje:** Haskell (GHC)  
**Archivo principal:** `recursion.hs`

---

## Objetivo

Comprender cómo Haskell garantiza en **tiempo de compilación** propiedades que otros lenguajes solo pueden verificar en tiempo de ejecución:

- Recursión de cola (tail recursion) con acumuladores
- Tipos algebraicos como especificación ejecutable del dominio
- `Maybe a` y `Either e a` para manejo de errores sin excepciones
- Pattern matching exhaustivo — GHC alerta si falta un caso

---

## Compilar y ejecutar

```bash
ghc -o recursion recursion.hs && ./recursion
```

Para explorar en el REPL interactivo:
```bash
ghci recursion.hs
```

---

## Qué garantiza GHC en tiempo de compilación

| Garantía | Cómo funciona |
|----------|--------------|
| **Pattern matching exhaustivo** | GHC advierte si una función no cubre todos los constructores del tipo |
| **Tipos correctos** | `buscarAlumno` retorna `Maybe Alumno`, no puede devolver `null` accidentalmente |
| **No hay `null`** | Haskell no tiene `null`; la ausencia de valor se modela con `Nothing :: Maybe a` |
| **Funciones puras** | El compilador sabe qué funciones tienen efectos (tipo `IO`) y cuáles no |
| **Desbordamiento de enteros** | `Integer` es precisión arbitraria — `factorial 1000` funciona sin overflow |

---

## Preguntas de reflexión

1. ¿Por qué `factorial` con acumulador es más eficiente en memoria que la versión naive? ¿Cuántos marcos de pila usa cada versión para `factorial 10`?

2. Si `buscarAlumno` retornara `Alumno` directamente en vez de `Maybe Alumno`, ¿qué tendría que hacer cuando el alumno no existe? ¿Qué problemas causa eso en Java/C#?

3. Agrega un tercer constructor al tipo `Alumno` (por ejemplo, `AlumnoGraduado`). ¿Qué mensajes de GHC aparecen en las funciones existentes? ¿Por qué esto es una ventaja?

4. ¿Cuál es la diferencia entre `Left "error"` y lanzar una excepción en Python? ¿Qué obliga al programador a hacer el compilador de Haskell con `Either`?

5. Intenta escribir `head []` en GHCi. ¿Cuándo falla? ¿Por qué `buscarAlumno` es más seguro que usar `head` seguido de `filter`?

---

## Extensión sugerida

Implementar `validarLote :: [String] -> Either String [Alumno]` que valide una lista de matrículas y retorne `Left` con el **primer error** encontrado, o `Right` con todos los alumnos válidos. Sin usar excepciones.
