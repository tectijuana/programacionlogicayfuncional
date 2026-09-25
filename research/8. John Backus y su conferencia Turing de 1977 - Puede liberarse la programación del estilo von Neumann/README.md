# John Backus y su conferencia Turing de 1977: "¿Puede liberarse la programación del estilo von Neumann?"

-Alumno: Camarillo Molina Cristian 23210553

-Maestro: Rene Solis Reyes 

-Materia: Programación lógica y funcional 

-Horario: 4 - 5pm

## Introduccion
John Backus es reconocido por haber liderado el desarrollo de FORTRAN y la notacion BNF, dos pilares del diseño de lenguajes de programacion. Sin embargo, en su discurso del premio Turing de 1977 planteo la critica contundente contra el paradigma que el mismo ayudo a consolidar. Su argumento central fue que la mayoria de los lenguajes de programacion (Como FORTRAN, ALGOL o Pascal) estan atados a la arquitectura fisica de von Neumann. Esta dependencia obliga a los programadores a pensar en términos de modificación de memoria palabra por palabra, impidiendo que el software tenga propiedades algebraicas claras.

## Desarrollo 
### El Cuello de Botella de von Neumann: Dimensión Física y Conceptual
La arquitectura Von Neumann se compone de una Unidad Central de Procesamiento (CPU), una Memoria Principal que
almacena tanto datos como programa, y un canal físico (bus) que las interconecta. La crítica de Backus no se limitó al aspecto físico (el hecho insoslayable de que el tráfico de datos a través del bus limita la velocidad de procesamiento), sino que se enfocó en el cuello de botella conceptual.

<img width="606" height="159" alt="image" src="https://github.com/user-attachments/assets/9e710cc7-86a2-43e0-84a2-8e312712e469" />

Los lenguajes imperativos tradicionales abstraen la computadora von Neumann mediante la sentencia de asignación (x := e). En esta instrucción, x representa una posición física de memoria y e una expresión calculada en la CPU. En consecuencia, el
programador debe pensar continuamente en términos de mover valores individuales a través del bus, gestionar índices de bucles y actualizar variables de estado globales.

### Crítica Comparativa de Paradigmas: Imperativo vs. LISP vs. FP
Backus comparó los lenguajes imperativos convencionales con los lenguajes de procesamiento de listas de la época, en
particular LISP (desarrollado por John McCarthy en 1960) . Aunque reconocía que LISP representaba un avance al tratar
programas como datos y permitir funciones recursivas, señaló tres deficiencias en el LISP de finales de los 70:

1. **Presencia de Efectos Secundarios:** LISP incluía funciones destructivas de modificación de listas (como `rplaca` y
`rplacd`) y asignaciones explícitas (`setq`), lo que destruía la pureza referencial.

2. **Dependencia del Entorno Lambda:** LISP dependía fuertemente de variables bound mediante abstracción lambda
(\lambda x. e), lo que requería mantener un entorno de asociación de nombres durante la evaluación.

3. **Falta de un Álgebra de Programas Pura:** Debido a la mezcla de variables libres, ligadas y operaciones con efectos
secundarios, resultaba sumamente complejo simplificar ecuaciones de programas en LISP mediante leyes algebraicas
estandarizadas.

### Estructura formal del sistema FP (Functional Programming)
El sistema FP propuesto por Backus es un modelo matemático estricto, libre de variables (estilo tácito o point-free). Se
compone de cuatro elementos bien definidos:

| Componente | Definición Técnica Formal | Reglas / Ejemplos |
| :--- | :--- | :--- |
| **1. Objetos ($O$)** | Conjunto formado por átomos (números, símbolos, $\text{T}$, $\text{F}$, $\phi$) y secuencias $\langle x_1, \dots, x_n \rangle$. Incluye el objeto de error/indefinición $\perp$ (*bottom*). Se cumple la estrictez: si $x_i = \perp$, la secuencia es $\perp$. | $\langle 10, \text{A}, \langle 2, 3 \rangle \rangle$<br>$\langle 1, \perp \rangle = \perp$ |
| **2. Funciones Primitivas ($F$)** | Funciones puras de $O \to O$. Son estrictas: $f(\perp) = \perp$. Incluyen selectoras ($1, 2, \dots$), aritméticas ($+, \times, -$), y reestructuradoras ($\text{trans}$, $\text{distl}$, $\text{distr}$, $\text{tl}$, $\text{rotleft}$). | $\text{distl} : \langle A, \langle B, C \rangle \rangle = \langle \langle A, B \rangle, \langle A, C \rangle \rangle$ |
| **3. Formas Combinatorias ($C$)** | Operadores de orden superior que toman funciones y producen nuevas funciones sin hacer referencia a variables de datos. | Composición ($\circ$), Construcción ($[f_1, \dots, f_n]$), Condicional ($p \to f; g$), Map ($\alpha f$), Reduce ($/f$). |
| **4. Definiciones ($D$)** | Mecanismo formal para asignar nombres a expresiones combinatorias: $\text{Def } \text{Nombre} \equiv \text{Expresión}$. No equivale a asignación mutable de memoria. | $\text{Def } \text{Cuadrado} \equiv \times \circ [\text{id}, \text{id}]$ |

### Evidencia: los programas de FP ejecutados en Haskell

> *Sección agregada durante la revisión docente. Traduce a Haskell (GHC 9.14, `runghc Backus.hs`) los programas que Backus usa en su artículo, para comprobar que el estilo "libre de variables" de FP es ejecutable hoy.*

Backus define el **producto interno** como `Def IP ≡ (/+) ∘ (α×) ∘ Trans`: transponer los dos vectores en pares, multiplicar cada par (`α×`, *map*) y reducir con suma (`/+`, *reduce*). En Haskell la misma idea se escribe como una composición de funciones, sin variables de estado ni índices:

```haskell
-- Programas del sistema FP de Backus (1978) traducidos a Haskell en estilo tácito (point-free)
import Data.List (transpose)

-- Def IP ≡ (/+) ∘ (α×) ∘ Trans        — producto interno
ip :: [Int] -> [Int] -> Int
ip xs ys = (foldr (+) 0 . map (uncurry (*))) (zip xs ys)

-- Versión tácita sobre un solo objeto ⟨xs, ys⟩, igual que en FP
ipFP :: ([Int], [Int]) -> Int
ipFP = foldr (+) 0 . map (uncurry (*)) . uncurry zip

-- Def Cuadrado ≡ × ∘ [id, id]          — construcción [f, g] = \x -> (f x, g x)
construccion :: (a -> b) -> (a -> c) -> a -> (b, c)
construccion f g x = (f x, g x)

cuadrado :: Int -> Int
cuadrado = uncurry (*) . construccion id id

-- Def MM ≡ (α α IP) ∘ (α distl) ∘ distr ∘ [1, Trans ∘ 2]   — multiplicación de matrices
mm :: [[Int]] -> [[Int]] -> [[Int]]
mm a b = [[ip fila col | col <- transpose b] | fila <- a]

-- Contraste: la versión "von Neumann" con estado mutable simulado palabra por palabra
ipImperativo :: [Int] -> [Int] -> Int
ipImperativo xs ys = go 0 0
  where
    n = min (length xs) (length ys)
    go i acc
      | i >= n    = acc
      | otherwise = go (i + 1) (acc + xs !! i * ys !! i)   -- c := c + a[i] * b[i]

main :: IO ()
main = do
  print (ip [1, 2, 3] [6, 5, 4])                 -- 28
  print (ipFP ([1, 2, 3], [6, 5, 4]))            -- 28
  print (ipImperativo [1, 2, 3] [6, 5, 4])       -- 28
  print (cuadrado 7)                             -- 49
  print (mm [[1, 2], [3, 4]] [[5, 6], [7, 8]])   -- [[19,22],[43,50]]
```

Salida:

```
28
28
28
49
[[19,22],[43,50]]
```

Las tres versiones del producto interno dan `28`, pero son muy distintas de leer:

| | `ipFP` (estilo FP) | `ipImperativo` (estilo von Neumann) |
| :--- | :--- | :--- |
| Unidad de trabajo | El vector completo | Un elemento a la vez (`xs !! i`) |
| Estado | Ninguno | Índice `i` y acumulador `acc` |
| Razonamiento | Leyes algebraicas: `map f . map g = map (f . g)` | Seguir cómo cambian `i` y `acc` en cada paso |
| Correspondencia con FP | `(/+) ∘ (α×) ∘ Trans` casi literal | `c := c + a[i] * b[i]` palabra por palabra |

Esta es exactamente la tesis de Backus: el programa imperativo empuja valores "palabra por palabra" por el cuello de botella, mientras que el programa FP opera sobre objetos completos y se puede transformar con álgebra. `map`/`foldr` son hoy los mismos bloques que usa MapReduce, lo que conecta con tu conclusión.

## Conclusion
La conferencia de John Backus en 1977 expuso una limitación estructural en la forma en que se diseña el software: la subordinacion del pensamiento del programador a la arquitectura fisica de la maquina. Aunque la propuesta de Backus no logro desplazar al hardware de von Neumann ni sustituir la hegemonia comercial de lenguajes imperativos como C o Fortran, su impacto teorico y conceptual fue profundo.

Hoy en día la influencia de Backus es evidente en herramientas de Big Data como MapReduce, en el procesamiento vectorial masivo mediante GPUs y en la adopción de primitivas funcionales (map, reduce, filter) en lenguajes modernos de uso general. En última instancia, la liberación del estilo von Neumann no se logró cambiando los chips de silicio, sino transformando la manera en que los desarrolladores abstraen y componen el código.  

## Bibliografia
J. Backus, "Can programming be liberated from the von Neumann style? A functional style and its algebra of programs," Communications of the ACM, vol. 21, no. 8, pp. 613–641, Aug. 1978.

J. Backus, "The history of FORTRAN I, II, and III," ACM SIGPLAN Notices, vol. 13, no. 8, pp. 165–180, Aug. 1978.

J. McCarthy, "Recursive functions of symbolic expressions and their computation by machine, Part I," Communications of the ACM, vol. 3, no. 4, pp. 184–195, Apr. 1960.

P. Hudak, "Conception, evolution, and application of functional programming languages," ACM Computing Surveys (CSUR), vol. 21, no. 3, pp. 359 – 411, Sep. 1989.

J. Hughes, "Why functional programming matters," The Computer Journal, vol. 32, no. 2, pp. 98–107, Apr. 1989.

J. Dean and S. Ghemawat, "MapReduce: Simplified data processing on large clusters," Communications of the ACM, vol. 51, no. 1, pp. 107–113, Jan. 2008.

E. W. Dijkstra, "A Discipline of Programming," Englewood Cliffs, NJ: Prentice-Hall, 1976.
