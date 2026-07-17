# 5 · Clojure — Ubuntu 24.04 ARM64

Guía autocontenida. El curso usa **Clojure CLI** (unidad 2: estructuras
persistentes, `atom`, `ref`/`dosync`, transducers).

Clojure corre sobre la JVM: primero Java, luego el CLI oficial.

## Paso 1 — JDK (OpenJDK 21, ARM64 nativo)

```bash
sudo apt update
sudo apt install -y openjdk-21-jre-headless rlwrap
java -version
# openjdk version "21.x" ... (build para aarch64)
```

## Paso 2 — Clojure CLI (instalador oficial)

El script oficial de [clojure.org](https://clojure.org/guides/install_clojure)
funciona en cualquier Linux, incluida aarch64 (Clojure es bytecode JVM, no
depende de la arquitectura):

```bash
curl -sLO https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh
chmod +x linux-install.sh
sudo ./linux-install.sh
```

## Verificación

```bash
clojure --version
# Clojure CLI version 1.12.x
```

REPL con lo que se ve en la unidad 2:

```bash
clj
```

```clojure
;; estructura persistente: el vector original NO cambia
user=> (def v [1 2 3])
user=> (conj v 4)
[1 2 3 4]
user=> v
[1 2 3]

;; estado con atom (patrón Nubank para valores independientes)
user=> (def contador (atom 0))
user=> (swap! contador inc)
1

;; STM: refs coordinadas con dosync (transacciones estilo cuenta bancaria)
user=> (def cuenta-a (ref 100))
user=> (def cuenta-b (ref 0))
user=> (dosync (alter cuenta-a - 30) (alter cuenta-b + 30))
30
user=> [@cuenta-a @cuenta-b]
[70 30]
```

Sal con `Ctrl+D`.

## Notas para t4g.micro (1 GB RAM)

La JVM por defecto reserva bastante memoria. Si el REPL muere o va lento:

```bash
clj -J-Xmx512m
```

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `clj` sin flechas/historial | Falta `rlwrap` (`sudo apt install rlwrap`) o usa `clojure` |
| Primer arranque tarda ~10 s | Normal: descarga deps y arranca JVM; después es más rápido |
| `Error building classpath` | Sin internet o proxy — el CLI descarga de Maven Central |
