# 5 · Clojure — Ubuntu 24.04 ARM64

Guía autocontenida. El curso usa **Clojure CLI** (unidad 2: estructuras
persistentes, `atom`, `ref`/`dosync`, transducers).

> **Verificado el 2026-09-01** en el nodo del curso (`t4g.large`, Ubuntu 24.04.4
> aarch64) lanzado con `instalacion/scripts/lanzar-nodo-arm64.sh`:
>
> | Componente | Versión |
> |------------|---------|
> | OpenJDK | 21.0.12 (aarch64) |
> | Clojure CLI | 1.12.5.1664 |
>
> Sin sorpresas de arquitectura: Clojure es bytecode JVM.

Clojure corre sobre la JVM: primero Java, luego el CLI oficial.

## Paso 1 — JDK (OpenJDK 21, ARM64 nativo)

```bash
sudo apt update
sudo apt install -y openjdk-21-jre-headless rlwrap
java -version
# openjdk version "21.0.x" ... (build ... aarch64 ... )
```

## Paso 2 — Clojure CLI (instalador oficial)

El script oficial de [clojure.org](https://clojure.org/guides/install_clojure)
funciona en cualquier Linux, incluida aarch64:

```bash
curl -sLO https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh
chmod +x linux-install.sh
sudo ./linux-install.sh
```

Instala `clojure` y `clj` en `/usr/local/bin` y las libs en
`/usr/local/lib/clojure`.

## Verificación

```bash
clojure --version
# Clojure CLI version 1.12.5.1664
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

;; transducer (unidad 2): una sola pasada, sin colecciones intermedias
user=> (transduce (comp (filter odd?) (map #(* % %))) + (range 10))
165
```

Sal con `Ctrl+D`.

> La **primera** invocación de `clj`/`clojure` descarga Clojure y sus deps
> (~20 MB) de Maven Central y tarda ~10-15 s. Después arranca en ~1-2 s.

## Proyecto con `deps.edn` (para los proyectos de unidad)

Los proyectos de fin de capítulo necesitan gestión de dependencias. Estructura
mínima verificada:

```bash
mkdir -p mi-proyecto/src && cd mi-proyecto
cat > deps.edn << 'EOF'
{:deps {org.clojure/data.json {:mvn/version "2.5.0"}}}
EOF
cat > src/main.clj << 'EOF'
(ns main
  (:require [clojure.data.json :as json]))

(defn -main [& _]
  (println (json/write-str {:curso "PLF" :unidad 2})))
EOF
clojure -M -m main
# {"curso":"PLF","unidad":2}
```

- `-M` activa el alias `:main-opts` / `clojure.main`; `-m main` ejecuta
  `(main/-main)`.
- Ejecutar un script suelto por stdin: `echo '(println (+ 1 2))' | clj -M -`
  (con `-M`; sin él, el CLI avisa que la forma implícita está *deprecated*).

## Notas de recursos

- El nodo `t4g.large` (8 GiB) corre la JVM con holgura.
- En `t4g.micro` (1 GiB) limita el heap si el REPL va lento o muere:

  ```bash
  clj -J-Xmx512m
  ```

## Solución de problemas

| Síntoma | Causa / solución |
|---------|------------------|
| `clj` sin flechas/historial | Falta `rlwrap` (`sudo apt install rlwrap`) o usa `clojure` |
| Primer arranque tarda ~10-15 s | Normal: descarga deps y arranca la JVM; después es rápido |
| `Error building classpath` | Sin internet o proxy — el CLI descarga de Maven Central |
| `WARNING: Implicit use of clojure.main ... is deprecated` | Antepón `-M` a `-e` / `-m` / `-` (p. ej. `clj -M -e '...'`) |
| `NullPointerException ... "f" is null` con `-m` | El namespace no tiene `(defn -main [& _] ...)` |
