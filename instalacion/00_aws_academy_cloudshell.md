# 0 · AWS Academy: nodo Ubuntu ARM64 desde CloudShell

Guía autocontenida para levantar la máquina de trabajo del curso: una instancia
EC2 **Graviton (ARM64)** con **Ubuntu 24.04 LTS**, creada desde **AWS CloudShell**
sin instalar nada en tu computadora.

## Requisitos

- Cuenta de **AWS Academy Learner Lab** (te la asigna tu profesor)
- Navegador web — no necesitas AWS CLI local, CloudShell ya lo trae

## Paso 1 — Iniciar el Learner Lab

1. Entra a [awsacademy.instructure.com](https://awsacademy.instructure.com) con tu cuenta.
2. Abre tu curso → **Modules** → **Launch AWS Academy Learner Lab**.
3. Pulsa **Start Lab** y espera a que el indicador `AWS` se ponga **verde** 🟢.
4. Haz clic en el indicador verde `AWS` para abrir la consola de AWS.

> ⏱️ El laboratorio se apaga solo después de ~4 horas. Las instancias EC2 se
> **detienen** (no se borran), pero la IP pública cambia en cada sesión.

## Paso 2 — Abrir CloudShell

En la consola de AWS, haz clic en el ícono de terminal **>_ CloudShell**
(barra superior) o busca "CloudShell". Espera el prompt:

```
[cloudshell-user@ip-... ~]$
```

## Paso 3 — Ejecutar el script de lanzamiento

El script [`scripts/lanzar-nodo-arm64.sh`](scripts/lanzar-nodo-arm64.sh)
(origen: [gist de @IoTeacher](https://gist.github.com/IoTeacher/c214a55f457d47ba715362f00434b97e))
automatiza todo: key pair, security group, puerto 22, AMI Ubuntu ARM64 e instancia `t4g.micro`.

En CloudShell:

```bash
curl -sLO https://raw.githubusercontent.com/tectijuana/programacionlogicayfuncional/main/instalacion/scripts/lanzar-nodo-arm64.sh
chmod +x lanzar-nodo-arm64.sh
./lanzar-nodo-arm64.sh
```

Al final imprime el comando de conexión:

```
===== SSH =====
ssh -i llavesita.pem ubuntu@<IP_PUBLICA>
```

## Paso 4 — Conectarse por SSH

```bash
ssh -i llavesita.pem ubuntu@<IP_PUBLICA>
```

Verifica que estás en ARM64:

```bash
uname -m        # → aarch64
lsb_release -ds # → Ubuntu 24.04.x LTS
```

## Paso 5 — Instalar el software del curso

Ya dentro de la instancia, sigue las guías independientes:

- [01_asciinema.md](01_asciinema.md) — asciinema (instalar, usar y grabar tus prácticas)
- [02_prolog.md](02_prolog.md) — SWI-Prolog 9.x
- [03_erlang.md](03_erlang.md) — Erlang/OTP 26+
- [04_haskell.md](04_haskell.md) — GHC 9.x
- [05_clojure.md](05_clojure.md) — Clojure
- [06_elixir.md](06_elixir.md) — Elixir
- [07_ocaml.md](07_ocaml.md) — OCaml

## Notas operativas

| Situación | Qué hacer |
|-----------|-----------|
| La IP cambió tras reiniciar el lab | `aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress"` en CloudShell |
| Perdiste `llavesita.pem` | Vuelve a correr el script: detecta la key huérfana y la recrea |
| `t4g.micro` (1 GB RAM) se queda corto al compilar | Agrega swap (ver [03_erlang.md](03_erlang.md)) o usa `t4g.small` editando `INSTANCE_TYPE` en el script |
| Terminaste la sesión | **End Lab** en Learner Lab; la instancia queda detenida, no borrada |

> 💰 Tu presupuesto es de **$50 USD**, asignados por el docente al inicio del
> semestre. `t4g.micro` cuesta ≈ $0.0084/hora — apaga el lab al terminar.
> ⚠️ Los créditos **vencen al concluir el semestre** y no se acumulan: respalda
> tu código en GitHub (usa `gh` y Gist) antes del cierre del curso.
