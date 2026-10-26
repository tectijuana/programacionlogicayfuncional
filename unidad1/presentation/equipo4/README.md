# Equipo 4 — Elixir
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | ESPAÑA PEREZ, MIGUEL ANGEL | Contexto e historia |
| 2 | ESTRADA RODRIGUEZ, MELANI | Modelo de cómputo y sintaxis |
| 3 | FUENTES MONTAÑO, AXEL | Sistema de tipos / runtime |
| 4 | GARCIA CARO, CARLOS ALEJANDRO | Demo en vivo + caso real |

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
5. **Caso real + cierre (2 min)** — Discord con referencia IEEE; conexión con Erlang y Gleam.

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

- URL: https://asciinema.org/a/CCzCdCx1pSFJi8tY 

## Diapositivas

- [Ver presentación de Elixir (PDF)](./slides.pdf)

## Bibliografía (IEEE)

[1] S. Vishnevskiy, “How Discord Scaled Elixir to 5,000,000 Concurrent Users,” Discord Engineering Blog, Jul. 6, 2017. [Online]. Available: https://discord.com/blog/how-discord-scaled-elixir-to-5-000-000-concurrent-users

[2] Elixir Team, “The Elixir programming language,” Elixir. [Online]. Available: https://elixir-lang.org/. [Accessed: Sep. 22, 2026].

[3] Erlang/OTP Team, “Overview—OTP Design Principles,” Erlang Documentation. [Online]. Available: https://www.erlang.org/doc/system/design_principles.html. [Accessed: Sep. 22, 2026].

[4] Erlang/OTP Team, “gen_server—OTP Design Principles,” Erlang Documentation. [Online]. Available: https://www.erlang.org/doc/apps/stdlib/gen_server.html. [Accessed: Sep. 22, 2026].

[5] Erlang/OTP Team, “supervisor—OTP Design Principles,” Erlang Documentation. [Online]. Available: https://www.erlang.org/doc/apps/stdlib/supervisor.html. [Accessed: Sep. 22, 2026].

[6] Elixir Team, “Kernel.SpecialForms,” HexDocs. [Online]. Available: https://hexdocs.pm/elixir/Kernel.SpecialForms.html. [Accessed: Sep. 22, 2026].

[7] Elixir Team, “GenServer,” HexDocs. [Online]. Available: https://hexdocs.pm/elixir/GenServer.html. [Accessed: Sep. 22, 2026].

[8] Elixir Team, “Enumerable and Streams,” Elixir Documentation. [Online]. Available: https://elixir-lang.org/getting-started/enumerables-and-streams.html. [Accessed: Sep. 22, 2026].

---

Rúbrica, medio de presentación y reglas: [`../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md`](../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md)
