# Primeros pasos en Elixir con IEx y Mix

## Resumen

Elixir es un lenguaje funcional y dinámico que se ejecuta sobre la máquina virtual BEAM de Erlang. La plataforma aporta procesos ligeros, paso de mensajes y herramientas para sistemas concurrentes. Para iniciar no hace falta construir una aplicación completa: **IEx** permite evaluar expresiones y explorar el lenguaje interactivamente, mientras que **Mix** crea y administra proyectos, dependencias, compilación y pruebas. Este anexo recorre un camino reproducible desde la consola hasta un proyecto pequeño probado con ExUnit.

**Palabras clave:** Elixir, IEx, Mix, REPL, BEAM, ExUnit, programación funcional.

## 1. Introducción

Aprender un lenguaje funcional implica observar cómo se evalúan expresiones, cómo se transforman datos inmutables y cómo se componen funciones. Un entorno interactivo resulta especialmente útil: en Elixir es **IEx** (*Interactive Elixir*), una REPL (*read-eval-print loop*) que lee una expresión, la evalúa, imprime el resultado y espera la siguiente entrada.

La consola no reemplaza la estructura de una aplicación. El código que debe conservarse, compilarse y probarse necesita módulos, archivos y configuración explícita. **Mix** forma parte de la distribución de Elixir y ofrece tareas para crear proyectos, compilar, ejecutar pruebas, dar formato y administrar dependencias. El flujo de trabajo recomendado es explorar una idea rápidamente en IEx y convertirla después en código mantenible dentro de un proyecto Mix.

## 2. Requisitos y verificación

Elixir necesita Erlang/OTP porque la BEAM ejecuta ambos lenguajes. Una vez instalado, deben verificarse las versiones reales en lugar de suponerlas:

```bash
elixir --version
iex --version
mix --version
```

La salida informa las versiones de Erlang/OTP y Elixir. Si un comando no existe, la instalación o la variable `PATH` no están listas. Mix puede instalar herramientas habituales para dependencias: `mix local.hex` instala Hex y `mix local.rebar` instala rebar3. Solo deben ejecutarse cuando se necesiten y tras revisar su procedencia, ya que descargan componentes adicionales.

## 3. IEx: experimentar con expresiones

La sesión se inicia con `iex`. El indicador `iex(1)>` numera las entradas; el valor bajo la expresión es el resultado de la evaluación, no necesariamente un mensaje impreso por el programa.

```elixir
iex> 2 + 3
5
iex> saludo = "Hola, Elixir"
"Hola, Elixir"
iex> String.upcase(saludo)
"HOLA, ELIXIR"
iex> Enum.map([1, 2, 3], fn numero -> numero * numero end)
[1, 4, 9]
```

El operador `=` realiza coincidencia de patrones. Cuando el lado izquierdo es un nombre no enlazado, queda asociado al valor de la derecha; no es una caja mutable como una variable imperativa tradicional. Un patrón puede descomponer una lista y también fallar de manera visible:

```elixir
iex> [primero | resto] = [10, 20, 30]
[10, 20, 30]
iex> {primero, resto}
{10, [20, 30]}
iex> 0 = primero
** (MatchError) no match of right hand side value: 10
```

Ese error es didáctico: el patrón `0` no coincide con `10`. Para consultar ayuda puede usarse `h Enum.map`; `v(-1)` recupera resultados recientes. La tecla `Ctrl+C` y luego `a` termina la sesión.

También puede cargarse un archivo sin crear un proyecto: `iex calculos.exs`. Por convención, `.ex` contiene código que se compila y `.exs` scripts evaluados directamente. Esta diferencia permite decidir cuándo un experimento merece incorporarse a una aplicación Mix.

## 4. Mix: del experimento al proyecto

El siguiente comando crea una aplicación llamada `saludo`. La opción `--module` define el módulo principal de la plantilla:

```bash
mix new saludo --module Saludo
cd saludo
```

La estructura inicial separa responsabilidades:

```text
saludo/
├── README.md            # instrucciones iniciales del proyecto
├── lib/saludo.ex        # código de producción
├── test/saludo_test.exs # pruebas con ExUnit
├── mix.exs              # aplicación y dependencias
└── .formatter.exs       # reglas del formateador
```

`mix.exs` es código Elixir que declara metadatos y dependencias. Los cambios propios deben hacerse en `lib/`, no modificando una dependencia descargada. Estas son tareas cotidianas:

| Comando | Propósito |
|---|---|
| `mix compile` | Compila el proyecto. |
| `mix run` | Compila si hace falta y ejecuta código. |
| `mix test` | Ejecuta pruebas de ExUnit. |
| `mix format` | Aplica el formato estándar. |
| `mix deps.get` | Descarga dependencias declaradas. |
| `iex -S mix` | Abre IEx con el proyecto cargado. |

La última orden une ambos entornos. `iex` solo conoce los módulos preinstalados y lo escrito en la consola; `iex -S mix` arranca IEx mediante Mix, compila y carga el proyecto. Así puede invocarse de inmediato el código de `lib/`.

## 5. Ejemplo mínimo verificable

Reemplazar `lib/saludo.ex` por este módulo permite practicar funciones, interpolación y una cláusula con guarda:

```elixir
defmodule Saludo do
  @moduledoc "Funciones pequeñas para practicar IEx y Mix."

  @spec para(String.t()) :: String.t()
  def para(nombre) when is_binary(nombre), do: "Hola, #{nombre}!"
end
```

Tras abrir `iex -S mix`, la evaluación esperada es:

```elixir
iex> Saludo.para("Ana")
"Hola, Ana!"
```

La comprobación manual no evita regresiones. Se agrega entonces una prueba a `test/saludo_test.exs`:

```elixir
defmodule SaludoTest do
  use ExUnit.Case, async: true

  test "construye un saludo con el nombre recibido" do
    assert Saludo.para("Ana") == "Hola, Ana!"
  end
end
```

El ciclo de desarrollo queda explícito:

```bash
mix format --check-formatted
mix test
mix run -e 'IO.puts(Saludo.para("Ana"))'
```

`mix format --check-formatted` verifica sin modificar archivos; `mix test` ejecuta ExUnit; `mix run -e` evalúa una expresión dentro del contexto de la aplicación. Para un archivo concreto se puede usar `mix test test/saludo_test.exs`.

## 6. Buenas prácticas y límites

IEx favorece el aprendizaje por su retroalimentación inmediata, pero una sesión se pierde al cerrarla. Una vez entendida una expresión, conviene moverla a una función con nombre y cubrirla con una prueba. Mix vuelve esa transición reproducible: otra persona puede clonar el proyecto, obtener las dependencias declaradas y ejecutar las mismas pruebas.

Al comenzar es preferible mantener ejemplos pequeños y no ocultar errores con funciones que acepten cualquier valor. La guarda `when is_binary(nombre)` documenta que el ejemplo espera texto. También es buena práctica ejecutar el formateador antes de compartir código y consultar `mix help` o `mix help <tarea>` para conocer las opciones de la versión instalada.

IEx y Mix no son alternativas. IEx responde «¿cómo evalúa Elixir esta expresión?»; Mix responde «¿cómo organizo, pruebo y ejecuto este programa?». Juntos permiten una entrada gradual al lenguaje sin abandonar prácticas de desarrollo profesional.

## 7. Conclusiones

Elixir combina la exploración inmediata de IEx con la disciplina de proyectos de Mix. En IEx se observan expresiones, colecciones, coincidencia de patrones y funciones de orden superior con resultados instantáneos. En Mix esas ideas se convierten en módulos de `lib/`, pruebas de `test/` y tareas repetibles como `mix test` y `mix format`.

El objetivo inicial no es memorizar todas las tareas, sino distinguir el papel de cada herramienta y sostener un ciclo sencillo: explorar, escribir una función, probarla y formatearla. Esa práctica prepara el terreno para temas posteriores de Elixir y BEAM, incluidos procesos, supervisión y aplicaciones concurrentes.

## Referencias

[1] Elixir, «Introduction», *Elixir Getting Started*. [En línea]. Disponible en: https://elixir-lang.org/getting-started/introduction.html. [Accedido: 7-sep-2026].

[2] Elixir, «IEx», *HexDocs*. [En línea]. Disponible en: https://hexdocs.pm/iex/IEx.html. [Accedido: 7-sep-2026].

[3] Elixir, «Mix», *HexDocs*. [En línea]. Disponible en: https://hexdocs.pm/mix/Mix.html. [Accedido: 7-sep-2026].

[4] Elixir, «Mix.Tasks.New», *HexDocs*. [En línea]. Disponible en: https://hexdocs.pm/mix/Mix.Tasks.New.html. [Accedido: 7-sep-2026].

[5] Elixir, «Mix.Tasks.Test», *HexDocs*. [En línea]. Disponible en: https://hexdocs.pm/mix/Mix.Tasks.Test.html. [Accedido: 7-sep-2026].
