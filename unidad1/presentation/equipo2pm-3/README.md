# Equipo 3 (2pm) — Elixir
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | RODRIGUEZ MENDIVIL, FABIAN OSVALDO | Contexto e historia |
| 2 | RODRIGUEZ PERAZA, CARLOS ELIAB | Modelo de cómputo y sintaxis |
| 3 | RUIZ SANCHEZ, JOSE MANUEL | Sistema de tipos / runtime |
| 4 | TORRES MORENO, DIEGO ANTONIO | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 2011 (José Valim)
- **Creador(es):** _(completar)_
- **Modelo de evaluación:** estricto; `Stream` para evaluación diferida
- **Sistema de tipos:** dinámico; sobre la BEAM
- **REPL / herramienta:** `iex` / `mix`
- **Caso real verificado (obligatorio en pantalla):** Discord — infraestructura de presencia migrada de Go a Elixir (2017). _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — Elixir como capa ergonómica sobre Erlang/BEAM.
2. **Modelo de cómputo (3 min)** — inmutabilidad, operador `|>`, `Enum` vs `Stream`, *pattern matching*.
3. **Tipos / runtime (3 min)** — procesos, GenServer, supervisión; qué se descubre en runtime.
4. **Demo en vivo (4 min)** — `iex` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (pipeline con `|>`).
5. **Caso real + cierre (2 min)** — Discord con referencia IEEE; conexión con los otros lenguajes del curso.

## Comandos exactos del demo

```bash
# Instalación
brew install elixir      # macOS
sudo apt install elixir  # Linux

# Hola Paradigma (imprimir 1..10)
iex
iex> Enum.each(1..10, &IO.puts/1)

# Segundo ejemplo idiomático
iex> 1..10 |> Enum.filter(&(rem(&1, 2) == 0)) |> Enum.map(&(&1 * &1))
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
[4, 16, 36, 64, 100]
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
