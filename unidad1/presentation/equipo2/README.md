# Equipo 2 — Haskell
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | BARBOZA CARBALLO, DIEGO ANTONIO | Contexto e historia |
| 2 | BOJORQUEZ VALDEZ, VICTOR MANUEL | Modelo de cómputo y sintaxis |
| 3 | CAMACHO OTAÑEZ, JUAN PABLO | Sistema de tipos / runtime |
| 4 | CAMARILLO MOLINA, CRISTIAN | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 1990 (comité Haskell)
- **Creador(es):** _Simon Peyton Jones, Philip Wadler, Paul Hudak y John Hughes_
- **Modelo de evaluación:** perezoso (*lazy*) por defecto
- **Sistema de tipos:** estático, inferencia Hindley-Milner, clases de tipos, `Maybe`/`Either`
- **REPL / herramienta:** `ghci` (GHC)
- **Caso real verificado (obligatorio en pantalla):** Standard Chartered — motor de valuación de derivados en Haskell. _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — por qué un comité crea un lenguaje "puro y perezoso".
2. **Modelo de cómputo (3 min)** — expresiones, pureza, evaluación perezosa (listas infinitas).
3. **Tipos / runtime (3 min)** — qué atrapa el compilador antes de correr; `Maybe`/`Either` frente a `null` y excepciones.
4. **Demo en vivo (4 min)** — `ghci` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (`take 10 [1..]` o `foldr`).
5. **Caso real + cierre (2 min)** — Standard Chartered con referencia IEEE; conexión con OCaml, Elm y Gleam.

## Contexto
- A finales de los años 1980 existían muchos lenguajes funcionales puros y no estrictos, pero no había un estándar común.
- En 1987 se decidió crear un comité para unificar ideas y definir un lenguaje abierto.
- Haskell 1.0 se publicó en 1990 .
- El lenguaje recibió su nombre por el lógico Haskell Curry .
- Su propuesta principal: programación funcional pura, tipos estáticos y evaluación perezosa por defecto.

## Modelo de computo
### Expresiones 
Eecutar es reducir.
Un programa es una expresión reescrita paso a paso hasta su forma irreducible.

<img width="49" height="48" alt="image" src="https://github.com/user-attachments/assets/6957676e-9eff-4d93-9fea-29c66901b5f8" />


### Pureza
Transparencia referencial. 
Una expresion siempre da el mismo valor sin efectos secundarios.

<img width="63" height="36" alt="image" src="https://github.com/user-attachments/assets/bf7e1188-b9e7-42bb-b07c-c92ac69ab492" />

### Evaluacion perezosa
Listas infinitas. 
Se calcula solo lo necesario, permitiendo estructuras infinitas. 

<img width="81" height="41" alt="image" src="https://github.com/user-attachments/assets/b353b581-e16b-42ad-8b06-2f409fe4c439" />

## Sintaxis
### Patrones 
Distinguir por la forma del dato; varias ecuaciones para 
una función.

<img width="94" height="39" alt="image" src="https://github.com/user-attachments/assets/e6623eeb-e2a2-4970-a3ce-75a737115f41" />

### Guardas
Distinguir por condiciones booléanas aplicadas cuando la forma no es suficiente.

<img width="183" height="40" alt="image" src="https://github.com/user-attachments/assets/8809c5c7-0d80-42bc-9453-09615be6c49e" />

### Where
Nombrar expresiones repetidas para calcularlas una vez y usar el nombre.

<img width="201" height="29" alt="image" src="https://github.com/user-attachments/assets/d9afb37f-5938-4aeb-87b4-7e358028df06" />

## Sistema de tipos
Un sistema de tipos (type system) es un conjunto de reglas que definen cómo se clasifican y utilizan los valores y expresiones dentro de un lenguaje de programación.
Su propósito principal es restringir las operaciones válidas entre diferentes tipos de datos (como enteros, coma flotante, cadenas o estructuras más complejas) para prevenir errores durante la ejecución de un programa.
Haskell posee un sistema de tipos Estatico y fuertemente tipado lo que quiere decir que:
-  Estatico: Los tipos se conocen antes de la ejecucion del programa.
-  Tipado fuerte: No permite operaciones entre tipos diferentes de forma arbitraria .

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

- URL: _https://asciinema.org/a/fl0rxxHtJGfDaN7H_
- Cómo: `asciinema rec demo.cast` → `asciinema upload demo.cast`

## Diapositivas

[Presentación Haskell.pdf](https://github.com/user-attachments/files/32539392/Presentacion.Haskell.pdf)


## Bibliografía (IEEE)

1. _P. Hudak, J. Hughes, S. Peyton Jones, y P. Wadler, "A History of Haskell: Being Lazy with Class," en Proceedings of the Third ACM SIGPLAN Conference on History of Programming Languages ​​(HOPL III) , San Diego, CA, USA, 2007, pp. 12-1–12-55. doi: 10.1145/1238844.1238856._
2. _Equipo de GHCup, "GHCup: The Haskell Toolchain Installer", haskell.org, 2026. [En línea]. Disponible: https://www.haskell.org/ghcup/_
3. _G. Dreimanis, "Haskell in Production: Standard Chartered", Serokell, mayo de 2023. [En línea]. Disponible: https://serokell.io/blog/haskell-in-production-standard-chartered_
4. _Peña Marí, R. (1995). La programación funcional en Haskell (Informe No. DIA-95/2). Universidad Complutense de Madrid, Departamento de Informática y Automática._
5. _I. Isaac, “Qué es un type system o sistema de tipos,” Profesional Review, 27 jul. 2025. [En línea]. Disponible en: https://www.profesionalreview.com/2025/07/27/que-es-un-type-system-o-sistema-de-tipos_
6. _W. T. H. Yuen, "Functional Programming in Financial Services: Industrial Haskell at Scale,"  vol. 35, no. 6, pp. 62–68, Nov.-Dec. 2018._

---

Rúbrica, medio de presentación y reglas: [`../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md`](../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md)
