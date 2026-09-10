# Manejo de errores funcional: Either / Result y el patrón "railway" frente a excepciones

**Autor:** Rodríguez Peraza, Carlos Eliab
**Curso:** Programación Lógica y Funcional 2026 "B" — Grupo 2pm
**Tema #10**

## Introducción

El trabajar con excepciones para el control de flujo introduce un nivel de ambigüedad
insostenible en proyectos grandes. La firma `int dividir(int a, int b)` carece de
transparencia: nada en su definición advierte sobre posibles fallas en el tiempo de
ejecución. Ante esto, el paradigma funcional propone tratar los errores como
ciudadanos de primera clase dentro del sistema de tipos, devolviendo estructuras
explícitas como `Result`, `Either` o `{:ok, valor}`. De esta manera, el programa no
se interrumpe de forma impredecible. Este documento analiza la viabilidad de este
enfoque mediante la arquitectura Railway-Oriented Programming frente al paradigma
imperativo.

## Desarrollo técnico

### 1. El problema de las excepciones

Las excepciones rompen la transparencia referencial: dos llamadas a la misma función
con los mismos argumentos pueden comportarse de forma distinta según el estado del
programa (por ejemplo, si un recurso externo falla). Además, el compilador no obliga
a manejar el caso de error: es responsabilidad humana acordarse de envolver la
llamada en un `try/catch`, y olvidarlo no genera ningún error de compilación.

### 2. `Either` en Haskell

Haskell no tiene excepciones para errores de lógica de negocio (sí existen para
errores irrecuperables del sistema, pero no se recomiendan para control de flujo).
En su lugar se usa el tipo `Either a b`, donde por convención `Left a` representa
el error y `Right b` el resultado exitoso:

```haskell
dividir :: Double -> Double -> Either String Double
dividir _ 0 = Left "Error: división entre cero"
dividir a b = Right (a / b)

-- Encadenar operaciones que pueden fallar
calcular :: Double -> Double -> Double -> Either String Double
calcular a b c = do
  r1 <- dividir a b
  r2 <- dividir r1 c
  return r2

main :: IO ()
main = do
  print (calcular 100 5 2)   -- Right 10.0
  print (calcular 100 0 2)   -- Left "Error: división entre cero"
```

Gracias a que `Either` es una mónada, el bloque `do` anterior **detiene la cadena
automáticamente** en el primer `Left` que aparece, sin necesidad de anidar
condicionales `if error then ... else ...`. Esto es exactamente lo que se conoce
como "railway-oriented programming".

### 3. El patrón "railway" (vías de ferrocarril)

El término fue popularizado por Scott Wlaschin para describir visualmente cómo
funciona la composición de funciones que devuelven `Either`/`Result`: imagina dos
vías de tren paralelas, una de "éxito" y otra de "error". Cada función es un tramo
de vía con un desvío: si recibe un valor en la vía de éxito, produce éxito o cambia
a la vía de error; una vez en la vía de error, **todos los tramos siguientes se
saltan** y el valor de error viaja directo hasta el final. Esto evita el anidamiento
de validaciones típico del código imperativo (el conocido "pyramid of doom" de
`if` anidados).

### 4. `{:ok, _}` / `{:error, _}` en Elixir

Elixir no tiene un tipo `Either` incorporado en el lenguaje, pero la convención de
la comunidad logra el mismo efecto con tuplas etiquetadas y el operador `with`:

```elixir
defmodule Calculadora do
  def dividir(_a, 0), do: {:error, "división entre cero"}
  def dividir(a, b), do: {:ok, a / b}

  def calcular(a, b, c) do
    with {:ok, r1} <- dividir(a, b),
         {:ok, r2} <- dividir(r1, c) do
      {:ok, r2}
    else
      {:error, razon} -> {:error, razon}
    end
  end
end

IO.inspect(Calculadora.calcular(100, 5, 2))  # {:ok, 10.0}
IO.inspect(Calculadora.calcular(100, 0, 2))  # {:error, "división entre cero"}
```

El operador `with` cumple el mismo rol que el `do` de Haskell: encadena pasos que
pueden fallar y corta la ejecución en el primer `{:error, _}`.

### 5. Comparación con excepciones

| Aspecto | Excepciones | Either / Result |
|---|---|---|
| Visibilidad del error | Oculto en la implementación | Explícito en el tipo de retorno |
| Verificación en compilación | No | Sí (en lenguajes con tipos estáticos) |
| Composición | `try/catch` anidados | Encadenamiento tipo "railway" |
| Rendimiento | Costoso al lanzar (stack unwinding) | Bajo costo, es un valor normal |
| Rutas de error olvidadas | Fáciles de olvidar | El compilador puede exigir manejarlas |

### 6. Uso en la industria

WhatsApp construyó su infraestructura de mensajería sobre Erlang/OTP, un lenguaje
funcional que popularizó el principio de "let it crash" combinado con supervisión
de procesos, un enfoque distinto pero complementario al de `Either`: en vez de
evitar el error, se aísla y se reinicia el proceso afectado. Discord, por su parte,
ha documentado públicamente el uso de Elixir en partes de su infraestructura de
tiempo real, donde el patrón `{:ok, _}`/`{:error, _}` es el estándar de facto para
el manejo de fallos en llamadas entre procesos.

## Conclusiones

Manejar errores devolviéndolos como un valor explícito en vez de lanzar excepciones
invisibles nos fuerza a pensar en qué puede salir mal desde el principio. Con la idea
del railway programming, podemos lograr un código limpio y fluido, libre de el
montón de código interminable de if/else o bloques de validación. Al final, ver esta
lógica ya implementada tanto en Haskell con `Either` como en Elixir con las tuplas
`{:ok, _}` / `{:error, _}` me hace pensar que la gestión explícita de errores es una
decisión de arquitectura que hace que cualquier software sea mucho más robusto.

## Bibliografía (formato IEEE)

[1] Haskell.org, "Data.Either," *Haskell Base Library Documentation*. [En línea]. Disponible: https://hackage.haskell.org/package/base/docs/Data-Either.html

[2] S. Wlaschin, "Railway Oriented Programming," *F# for Fun and Profit*. [En línea]. Disponible: https://fsharpforfunandprofit.com/rop/

[3] Elixir Lang, "with," *Elixir Documentation, Kernel.SpecialForms*. [En línea]. Disponible: https://hexdocs.pm/elixir/Kernel.SpecialForms.html#with/1

[4] J. Armstrong, *Programming Erlang: Software for a Concurrent World*, 2nd ed. Raleigh, NC, USA: Pragmatic Bookshelf, 2013.

[5] Discord Engineering Blog, "How Discord Scaled Elixir to 5,000,000 Concurrent Users," *Discord Blog*. [En línea]. Disponible: https://discord.com/blog/how-discord-scaled-elixir-to-5-000-000-concurrent-users
