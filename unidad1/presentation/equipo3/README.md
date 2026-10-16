# Equipo 3 — Erlang / OTP
## Exposición: Introducción a lenguajes funcionales · Unidad 1

## Integrantes y roles

| Rol | Estudiante | Responsabilidad |
|:-:|:--|:--|
| 1 | COTA HERNANDEZ, CHRISTIAN ARMANDO | Contexto e historia |
| 2 | CRUZ SANCHEZ, KEVIN ALFREDO | Modelo de cómputo y sintaxis |
| 3 | CUEVAS MARQUEZ, PABLO ANGEL | Sistema de tipos / runtime |
| 4 | DEL ANGEL DEL ANGEL, EMMANUEL | Demo en vivo + caso real |

## Datos del lenguaje

- **Año / origen:** 1986 (Ericsson), open source 1998
- **Creador(es):** Joe Armstrong, Robert Virding y Mike Williams.
- **Modelo de evaluación:** estricto
- **Sistema de tipos:** dinámico; `dialyzer` para análisis estático opcional
- **REPL / herramienta:** `erl` / `erlc`
- **Caso real verificado (obligatorio en pantalla):** WhatsApp — ~2M conexiones por servidor con un equipo pequeño. _(fuente IEEE abajo)_

## Guion (12–15 min)

1. **Contexto (2 min)** — tolerancia a fallos en telefonía; "let it crash".
2. **Modelo de cómputo (3 min)** — variables de asignación única, recursión de cola, paso de mensajes, *shared nothing*.
3. **Tipos / runtime (3 min)** — la BEAM, procesos livianos, supervisores (OTP).
4. **Demo en vivo (4 min)** — `erl` + "Hola Paradigma" (1..10) + 2.º ejemplo idiomático (spawn de un proceso y envío de mensaje).
5. **Caso real + cierre (2 min)** — WhatsApp con referencia IEEE; conexión con Elixir y Gleam (familia BEAM).

## Comandos exactos del demo

```bash
# Instalación
brew install erlang      # macOS
sudo apt install erlang  # Linux

# Hola Paradigma (imprimir 1..10) — archivo hola.erl
#   -module(hola). -export([main/0]).
#   main() -> lists:foreach(fun(N) -> io:format("~w~n",[N]) end, lists:seq(1,10)).
erlc hola.erl
erl -noshell -s hola main -s init stop

# Segundo ejemplo idiomático (en el shell erl)
erl
1> Pid = spawn(fun() -> receive M -> io:format("recibi: ~p~n",[M]) end end).
2> Pid ! hola.
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
```

## Grabación de respaldo (asciinema cloud)

- URL: https://asciinema.org/a/1Nv9ddpV9dtp3YE9
- Cómo: `asciinema rec demo.cast` → `asciinema upload demo.cast`

## Diapositivas

- `slides.pdf` — 5–8 diapositivas, subir a esta carpeta **antes** de la sesión.

## Bibliografía (IEEE)

1.J. Armstrong, "A history of Erlang," en Proceedings of the Third ACM SIGPLAN Conference on History of Programming Languages, San Diego, CA, USA, 2007, pp. 6-1–6-26.
2. F. Hébert, Learn You Some Erlang for Great Good! 1ra ed. San Francisco, CA: No Starch Press, 2013.
3. "The WhatsApp Architecture WhatsApp Uses To Deliver 10 Billion Messages A Day," High Scalability, 2014. [En línea]. Disponible en: http://highscalability.com.
4. E. Letuchy, "Erlang at Facebook and WhatsApp," IEEE Software, vol. 31, no. 1, pp. 71-75, 2014

---

Rúbrica, medio de presentación y reglas: [`../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md`](../TEMAS-INTRO-LENGUAJES-FUNCIONALES-40.md)
