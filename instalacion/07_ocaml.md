# 7 · OCaml — Ubuntu 24.04 ARM64

Guía autocontenida. El curso usa OCaml en la unidad 3 (sistema de módulos,
firmas `.mli`, inferencia de tipos — el lenguaje detrás de Hack, Flow e Infer
en Meta).

> **Verificado el 2026-09-01** en el nodo del curso (`t4g.large`, Ubuntu 24.04.4
> aarch64):
>
> | Componente | Versión |
> |------------|---------|
> | opam | 2.1.5 (apt) |
> | OCaml (switch default) | **4.14.1** (compilador del sistema, instantáneo) |
> | OCaml (switch opcional) | 5.2.1 (compilado, ~8 min) |
> | dune | 3.24.2 |
> | utop | 2.17.0 |

## Instalación con opam (gestor oficial, soporta aarch64)

```bash
sudo apt update
sudo apt install -y opam build-essential unzip bubblewrap
opam init --auto-setup -y        # crea ~/.opam y el switch default
eval $(opam env)                 # aplica el entorno a la shell actual
```

> `opam init` escribe la config en `~/.profile` (no en `~/.bashrc`). En shells
> **interactivas** de login funciona; para un one-liner no interactivo
> (`ssh host 'ocaml ...'`) antepón `eval $(opam env) &&`.

El switch default usa el **compilador del sistema, OCaml 4.14.1** — se crea al
instante y **basta para todo el curso** (módulos, `.mli`, functors, inferencia).
Instala el build system y el REPL mejorado:

```bash
opam install -y dune utop
eval $(opam env)
```

### (Opcional) Switch con OCaml 5.x

Solo si quieres el runtime nuevo (multicore, effect handlers). **Compila el
compilador**: ~8 min en `t4g.large`, más en `t4g.micro`.

```bash
opam switch create 5.2.1
eval $(opam env)
opam install -y dune utop

opam switch list          # → 5.2.1 y default coexisten
opam switch set default   # volver a 4.14.1
```

## Verificación

```bash
ocaml --version    # 4.14.1  (o 5.2.1 si activaste ese switch)
dune --version
```

Prueba con módulos y firmas (lo que exige el estándar del curso: `.mli`
separado de `.ml`):

```bash
mkdir -p /tmp/prueba_ocaml && cd /tmp/prueba_ocaml

cat > pila.mli << 'EOF'
type 'a t
val vacia : 'a t
val push : 'a -> 'a t -> 'a t
val pop : 'a t -> ('a * 'a t) option
EOF

cat > pila.ml << 'EOF'
type 'a t = 'a list
let vacia = []
let push x s = x :: s
let pop = function [] -> None | x :: r -> Some (x, r)
EOF

cat > main.ml << 'EOF'
let () =
  let s = Pila.(vacia |> push 1 |> push 2) in
  match Pila.pop s with
  | Some (x, _) -> Printf.printf "tope: %d\n" x
  | None -> print_endline "vacia"
EOF

cat > dune-project << 'EOF'
(lang dune 3.0)
EOF

cat > dune << 'EOF'
(executable (name main) (modules main pila))
EOF

dune exec ./main.exe
# tope: 2
```

La firma `pila.mli` **oculta** que `'a t` es una lista: `main.ml` solo puede
usar `vacia`/`push`/`pop`. Si intenta `s @ s` o pattern-match directo, el
compilador lo rechaza — abstracción garantizada en tiempo de compilación.

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `opam init` falla con sandbox | `opam init --disable-sandboxing -y` (común en contenedores) |
| `ocaml: command not found` | `eval $(opam env)` o reabre una sesión de login |
| `ocaml --version` dice 4.14 y esperabas 5.x | El switch default es 4.14.1; crea el switch 5.x (arriba) y `eval $(opam env)` |
| `opam switch create 5.2.1` muere con `Killed` | Sin RAM al compilar; usa el swap del nodo o quédate en 4.14.1 |
| Compilación lenta de opam en 1 GB RAM | Agrega swap (ver [03_erlang.md](03_erlang.md) §B.1) |
