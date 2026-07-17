# 4 · GHC 9.x (Haskell) — Ubuntu 24.04 ARM64

Guía autocontenida. El curso requiere **GHC 9.x** (unidad 3: tipos algebraicos,
`Maybe`/`Either`, evaluación perezosa).

## Opción A — GHCup (recomendada)

[GHCup](https://www.haskell.org/ghcup/) es el instalador oficial y tiene
soporte de primera clase para **aarch64-linux**:

```bash
sudo apt update
sudo apt install -y build-essential curl libffi-dev libgmp-dev \
  libncurses-dev pkg-config
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Responde al instalador:
- *Install GHC (recommended)* → **Y**
- *Install cabal* → **Y**
- *Install HLS* → **N** (pesado; solo útil con editor local)
- *Install stack* → **N** (usamos cabal en el curso)

Recarga el entorno:

```bash
source ~/.ghcup/env
# ghcup añade esto a ~/.bashrc automáticamente
```

## Opción B — apt (rápida)

Ubuntu 24.04 trae GHC 9.4.x en repos, build ARM64 nativo:

```bash
sudo apt update
sudo apt install -y ghc cabal-install
```

Menos flexible que GHCup (no puedes cambiar de versión), pero cumple "GHC 9.x".

## Verificación

```bash
ghc --version     # 9.x
cabal --version
```

Prueba con lo que se usa en la unidad 3:

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

## Notas para t4g.micro (1 GB RAM)

- GHCup descarga binarios precompilados — **no compila GHC**, así que 1 GB
  alcanza para instalarlo.
- Compilar programas grandes con muchas dependencias de cabal sí puede agotar
  la RAM; agrega swap (ver [03_erlang.md](03_erlang.md) §B.1) o usa
  `runghc`/`ghci` para los ejercicios del curso.

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `ghc: command not found` tras instalar con GHCup | `source ~/.ghcup/env` o reabre la sesión |
| `cabal update` muy lento | Normal la primera vez (descarga el índice de Hackage) |
| Linker `cannot find -lgmp` | `sudo apt install libgmp-dev` |
