# Equipo 1 (2pm) — Haskell
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | CASTRO REYES, LIZETH ROXANA | Contexto e historia |
| 2 | CRUZ RANGEL, RAUL ANTONIO | Modelo de cómputo y sintaxis |
| 3 | DANIELS CEBALLOS, AXEL | Sistema de tipos / runtime |
| 4 | DURAN PONCE, LUIS ADAO LEONEL | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 1990 (comité Haskell)
- **Creador(es):** _(completar)_
- **Modelo de evaluación:** perezoso (*lazy*) por defecto
- **Sistema de tipos:** estático, inferencia Hindley-Milner, clases de tipos, `Maybe`/`Either`
- **REPL / herramienta:** `ghci` (GHC)
- **Caso real verificado (obligatorio en pantalla):** Standard Chartered — motor de valuación de derivados en Haskell. _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — por qué un comité crea un lenguaje "puro y perezoso".
2. **Modelo de cómputo (3 min)** — expresiones, pureza, evaluación perezosa (listas infinitas).
3. **Tipos / runtime (3 min)** — qué atrapa el compilador antes de correr; `Maybe`/`Either` frente a `null` y excepciones.
4. **Demo en vivo (4 min)** — `ghci` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (`take 10 [1..]` o `foldr`).
5. **Caso real + cierre (2 min)** — Standard Chartered con referencia IEEE; conexión con los otros lenguajes del curso.

## Comandos exactos del demo

```bash
# Instalación
ghcup install ghc      # https://www.haskell.org/ghcup/

# Hola Paradigma (imprimir 1..10)
ghci
ghci> mapM_ print [1..10]

# Segundo ejemplo idiomático
ghci> take 10 [1..]              -- lista infinita, evaluación perezosa
```

Salida esperada:

```
1
2
3
4
5
6
7
8
9
10
[1,2,3,4,5,6,7,8,9,10]
```

## Grabación de respaldo (asciinema cloud)

- URL: _(pegar la URL de asciinema.org tras `asciinema upload`)_
- Cómo: `asciinema rec demo.cast` → `asciinema upload demo.cast`

## Diapositivas

- `slides.pdf` — 5–8 diapositivas, subir a esta carpeta **antes** de la sesión.

## Bibliografía (IEEE)

1. _(fuente 1)_
2. _(fuente 2)_
3. _(fuente 3)_

---

Rúbrica, medio de presentación y reglas: [`../TEMAS-INTRO-LENGUAJES-FUNCIONALES-16-2PM.md`](../TEMAS-INTRO-LENGUAJES-FUNCIONALES-16-2PM.md)
