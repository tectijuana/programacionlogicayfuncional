# 4 · GHC 9.x (Haskell) — Ubuntu 24.04 ARM64

Guía autocontenida. El curso requiere **GHC 9.x** (unidad 3: tipos algebraicos,
`Maybe`/`Either`, evaluación perezosa).

> **Verificado el 2026-09-01** en el nodo del curso (`t4g.large`, Ubuntu 24.04.4
> aarch64) lanzado con `instalacion/scripts/lanzar-nodo-arm64.sh`.
> Combinación que funciona de punta a punta:
>
> | Herramienta | Versión | Origen |
> |-------------|---------|--------|
> | GHC | **9.10.3** | GHCup (tag `recommended`) |
> | cabal-install | **3.16.1.0** | GHCup (tag `recommended`) |
>
> ⚠️ **No instales `cabal latest` (3.18.1.0)**: en aarch64 rompe al construir
> cualquier proyecto con `Could not load module 'Distribution.Simple'`. Usa
> siempre la versión `recommended` (ver troubleshooting).

---

## Opción A — GHCup (la del curso)

[GHCup](https://www.haskell.org/ghcup/) es el instalador oficial y tiene
soporte de primera clase para **aarch64-linux**. Descarga binarios
precompilados: **no compila GHC**, así que instala en minutos.

```bash
sudo apt update
sudo apt install -y build-essential curl libffi-dev libgmp-dev \
  libncurses-dev pkg-config
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

El instalador de hoy **ya instala GHC + cabal en sus versiones `recommended`
por defecto** (9.10.3 y 3.16.1.0). Solo te hace 3 preguntas:

| Pregunta | Responde | Por qué |
|----------|----------|---------|
| *Install haskell-language-server (HLS)?* | **N** | Pesado (~1 GB); solo sirve con editor local |
| *Enable better integration of stack with GHCup?* | **N** | Usamos cabal en el curso, no stack |
| *Add ghcup to your PATH in ~/.bashrc?* | **Y** | Sin esto, `ghc` y `cabal` no se encuentran |

Si respondiste **N** a lo del PATH, agrégalo tú y recarga:

```bash
echo '[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"' >> ~/.bashrc
source ~/.ghcup/env
```

Comprueba:

```bash
ghc --version     # 9.10.3
cabal --version   # 3.16.1.0
```

### Instalación no interactiva (para scripts / clonar la config)

```bash
export BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
       BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1 \
       BOOTSTRAP_HASKELL_ADJUST_BASHRC=1
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

---

## Opción B — apt (solo `runghc` / `ghci`, sin proyectos)

Ubuntu 24.04 trae GHC 9.4.7 (build ARM64 nativo):

```bash
sudo apt update
sudo apt install -y ghc            # GHC 9.4.7 — cumple "GHC 9.x"
runghc mi_programa.hs              # y ghci funcionan bien
```

> ⚠️ **No instales `cabal-install` desde `apt`** (versión 3.8.1.0): no puede
> actualizar el índice de Hackage —falla con
> `<repo>/root.json does not have enough signatures signed with the appropriate keys`
> por la rotación de llaves de Hackage—, así que **no sirve para proyectos con
> dependencias**. Para cualquier práctica con `cabal`, usa la Opción A.

Esta opción sirve para las primeras clases de la unidad 3 (ejercicios de una
sola pieza con `runghc`/`ghci`). Para el resto, GHCup.

---

## Verificación

```bash
ghc --version
cabal --version
```

### Prueba de lo que se usa en la unidad 3

```bash
cat > /tmp/prueba.hs << 'EOF'
data Resultado = Exito Int | Fallo String deriving Show

dividir :: Int -> Int -> Resultado
dividir _ 0 = Fallo "division entre cero"
dividir a b = Exito (a `div` b)

main :: IO ()
main = do
  print (dividir 10 2)
  print (dividir 10 0)
  print (take 5 [x*x | x <- [1..]])   -- evaluacion perezosa: lista infinita
EOF
runghc /tmp/prueba.hs
# Exito 5
# Fallo "division entre cero"
# [1,4,9,16,25]
```

### Prueba de un proyecto con cabal (necesita Opción A)

```bash
mkdir /tmp/proy && cd /tmp/proy
cabal init --non-interactive --exe .
cabal update
cabal run
# Hello, Haskell!
```

---

## Notas de recursos

- **Disco**: cada GHC ocupa ~2.6 GB en `~/.ghcup/ghc/<versión>`. El nodo del
  curso trae 30 GB de root, de sobra para una o dos versiones.
- **RAM**: GHCup no compila GHC, así que la instalación cabe en cualquier
  tamaño. Compilar proyectos grandes de cabal sí consume memoria; el nodo
  `t4g.large` (8 GiB) va holgado. En `t4g.micro` apóyate en el swap que crea
  el `user-data` (ver [03_erlang.md](03_erlang.md) §B.1) o usa `runghc`/`ghci`.

---

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `ghc: command not found` tras instalar con GHCup | `source ~/.ghcup/env`, o reabre la sesión (respondiste N al PATH) |
| `cabal build/run`: `Could not load module 'Distribution.Simple'` | Tienes `cabal` 3.18.1.0 (`latest`). Baja a la recomendada: `ghcup install cabal 3.16.1.0 --set` |
| `cabal update`: `root.json does not have enough signatures` | Es el `cabal` de `apt` (3.8.1.0). Instala GHCup (Opción A) y usa su `cabal` |
| `cabal update` tarda mucho | Normal la primera vez (descarga el índice completo de Hackage) |
| Linker: `cannot find -lgmp` | `sudo apt install libgmp-dev` |
| Quiero otra versión de GHC | `ghcup install ghc <ver>` y `ghcup set ghc <ver>` |
