# El sistema de módulos y espacios de nombres: comparación introductoria entre Elixir, Haskell y OCaml (.mli)

## Introducción
Los sistemas de módulos son una herramienta importante para organizar programas de software, especialmente cuando un proyecto crece y necesita dividirse en diferentes partes. Un módulo permite agrupar funciones, tipos de datos y otros elementos relacionados bajo una estructura que facilita la organización, reutilización y mantenimiento del código. En los lenguajes de programación funcional existen diferentes formas de implementar estos mecanismos como lo son: Elixir, Haskell y OCaml que estos utilizan módulos, pero cada lenguaje tiene características particulares para organizar y ocultar información. Elixir utiliza módulos como espacios donde se agrupan funciones y otros elementos del lenguaje, Haskell cuenta con un sistema de módulos que permite importar y exportar entidades, mientras que OCaml posee un sistema de módulos más amplio y utiliza archivos .mli para definir la interfaz pública de una implementación. El objetivo de esta investigación es explicar de manera introductoria cómo funcionan los módulos y los espacios de nombres en Elixir y Haskell, así como el uso de las interfaces .mli en OCaml.

## Desarrollo técnico
1.Módulos y espacios de nombres

Los módulos permiten organizar un programa en diferentes partes relacionadas. Un módulo puede contener funciones, tipos de datos y otros elementos. Además de facilitar la organización, los módulos ayudan a evitar conflictos entre nombres y permiten controlar qué elementos pueden utilizarse desde otras partes del programa.


2.Módulos en Elixir

En Elixir, los módulos se utilizan principalmente para agrupar funciones y crear espacios de nombres. Se definen mediante defmodule. Por ejemplo:

defmodule Saludos do
  def hola(nombre) do
    "Hola, #{nombre}"
  end
end

La función puede utilizarse desde otro lugar mediante el nombre del módulo:

Saludos.hola("Carlos")

El resultado sería "Hola, Carlos".

Elixir también permite diferenciar funciones públicas y privadas. Las funciones declaradas con def pueden utilizarse desde fuera del módulo, mientras que las declaradas con defp solamente pueden utilizarse dentro del mismo módulo. Esto permite ocultar funciones auxiliares que no necesitan estar disponibles para el resto del programa.


3.Módulos en Haskell

Haskell utiliza módulos para organizar funciones, tipos y otras entidades. También permite controlar cuáles elementos se pueden utilizar desde otros módulos mediante exportaciones.

Un ejemplo sencillo es:

module Saludos (hola) where

hola :: String -> String
hola nombre = "Hola, " ++ nombre

En este caso, hola se encuentra en la lista de exportación, por lo que puede ser utilizada desde otro módulo. Para utilizarla se puede realizar una importación:

import Saludos

Haskell también permite utilizar importaciones cualificadas. En ese caso, una función puede llamarse utilizando el nombre del módulo:

import qualified Saludos

main = putStrLn (Saludos.hola "Carlos")

Los módulos de Haskell permiten así organizar el código y controlar qué partes de una implementación están disponibles para otros módulos.


4.Módulos e interfaces .mli en OCaml

OCaml cuenta con un sistema de módulos que permite separar la interfaz de la implementación. Para esto pueden utilizarse dos archivos: .mli y .ml.

El archivo .mli describe la interfaz pública del módulo, mientras que .ml contiene la implementación. Por ejemplo, una interfaz llamada Calculadora.mli podría contener:

val suma : int -> int -> int

Mientras que Calculadora.ml tendría la implementación:

let suma a b = a + b

La declaración val suma : int -> int -> int indica que el módulo proporciona una función llamada suma que recibe dos enteros y devuelve un entero.

Esta separación permite ocultar detalles internos de la implementación, otros componentes solamente necesitan conocer la interfaz para utilizar las funciones disponibles. Por lo tanto el archivo .mli funciona como un contrato que define qué elementos del módulo pueden utilizarse desde el exterior.

En los tres casos el objetivo es similar, mantener el código organizado, facilitar su reutilización y controlar la forma en que diferentes partes de un programa se comunican entre sí.
## Conclusiones
Los módulos y espacios de nombres son mecanismos importantes para mantener organizado un programa y facilitar su mantenimiento. Aunque Elixir, Haskell y OCaml pertenecen al ámbito de la programación funcional, cada uno presenta una forma diferente de trabajar con estos conceptos. Elixir utiliza módulos para agrupar funciones y crear espacios de nombres, además de proporcionar mecanismos para diferenciar funciones públicas y privadas. Haskell utiliza módulos junto con importaciones y exportaciones para controlar las entidades disponibles entre diferentes partes de un programa. OCaml presenta una separación más explícita entre la interfaz y la implementación mediante los archivos .mli y .ml.
Comprender estas diferencias permite identificar que un sistema de módulos no solamente sirve para dividir un programa en archivos, sino también para establecer una forma clara de comunicación entre diferentes componentes y controlar qué partes de una implementación pueden ser utilizadas desde el exterior.

## Bibliografía
[1] Elixir, “Modules and functions,” *Elixir Documentation*. [En línea]. Disponible en: https://hexdocs.pm/elixir/modules-and-functions.html. [Accedido: 18-sep-2026].

[2] Haskell, “Modules,” *Haskell 2010 Language Report*, Cap. 5. [En línea]. Disponible en: https://www.haskell.org/onlinereport/haskell2010/haskellch5.html. [Accedido: 18-sep-2026].

[3] OCaml, “Modules,” *OCaml Documentation*. [En línea]. Disponible en: https://ocaml.org/docs/modules. [Accedido: 18-sep-2026].

[4] OCaml, “The OCaml Manual,” *OCaml Documentation*. [En línea]. Disponible en: https://ocaml.org/manual/5.5/index.html. [Accedido: 18-sep-2026].

[5] Glasgow Haskell Compiler, “Import and export,” *GHC User's Guide*. [En línea]. Disponible en: https://downloads.haskell.org/ghc/latest/docs/users_guide/exts/import_export.html. [Accedido: 18-sep-2026].
