# 7 · OCaml — Ubuntu 24.04 ARM64

Guía autocontenida. El curso usa OCaml en la unidad 3 (sistema de módulos,
firmas `.mli`, inferencia de tipos — el lenguaje detrás de Hack, Flow e Infer
en Meta).

## Instalación con opam (gestor oficial, soporta aarch64)

```bash
sudo apt update
sudo apt install -y opam build-essential unzip bubblewrap
opam init --auto-setup -y        # crea ~/.opam y el switch default
eval $(opam env)
```

En Ubuntu 24.04 el switch default trae OCaml 5.x. Para instalar el build
system y el REPL mejorado:

```bash
opam install -y dune utop
```

## Verificación

```bash
ocaml --version    # 5.x
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

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `opam init` falla con sandbox | Agrega `--disable-sandboxing` (común en contenedores) |
| `ocaml: command not found` | `eval $(opam env)` o reabre la sesión |
| Compilación lenta de opam en 1 GB RAM | Agrega swap (ver [03_erlang.md](03_erlang.md) §B.1) |
