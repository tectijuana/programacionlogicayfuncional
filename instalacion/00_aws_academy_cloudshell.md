# 0 · AWS Academy: nodo Ubuntu ARM64 desde CloudShell

Guía autocontenida para levantar la máquina de trabajo del curso: una instancia
EC2 **Graviton (ARM64)** con **Ubuntu 24.04 LTS**, creada desde **AWS CloudShell**
sin instalar nada en tu computadora.

## Requisitos

- Cuenta de **AWS Academy Learner Lab** (te la asigna tu profesor)
- Navegador web — no necesitas AWS CLI local, CloudShell ya lo trae

## Paso 0 — Acepta la invitación de AWS Academy

Antes del inicio del semestre, el docente gestiona ante AWS Academy la beca de
créditos del grupo ($50 USD por estudiante). Cuando se aprueba:

1. **AWS Academy te envía una invitación por correo** (revisa tu correo
   institucional `@tectijuana.edu.mx`, incluida la carpeta de spam) con asunto
   tipo *"Course Invitation — AWS Academy Learner Lab"*.
2. Abre el enlace **Get Started** de ese correo y crea tu cuenta de Canvas
   usando **el mismo correo donde recibiste la invitación**.
3. Al entrar verás el curso *AWS Academy Learner Lab* en tu tablero — ahí viven
   tus créditos.

> Sin este paso no existe el Learner Lab: si no te llegó la invitación,
> repórtalo al docente **la primera semana**, no el día de la entrega.

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
automatiza todo: key pair, security group (SSH + puertos de Erlang distribuido),
AMI Ubuntu 24.04 ARM64 e instancia `t4g.large` (8 GiB; overrideable con
`INSTANCE_TYPE=t4g.medium`).

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

> 💻 ¿Prefieres conectarte desde VS Code o desde una app en el celular (Termius)
> en vez de escribir `ssh` en CloudShell? Ve el [Anexo A](#anexo-a--descargar-llavesitapem-y-conectarte-con-vs-code-o-termius).

Verifica que estás en ARM64:

```bash
uname -m        # → aarch64
lsb_release -ds # → Ubuntu 24.04.x LTS
```

## Paso 5 — Actualizar el nodo recién creado

Lo **primero** en toda instancia nueva, antes de instalar cualquier herramienta:

```bash
sudo apt update && sudo apt upgrade -y
```

(≈2–3 min la primera vez. Si el kernel se actualizó, un `sudo reboot` y
reconectas por SSH en ~30 segundos.)

## Paso 6 — Instalar el software del curso

Ya dentro de la instancia, sigue las guías independientes — para la primera
semana basta **asciinema + SWI-Prolog**; el resto se instala cuando su unidad
lo pida:

- [01_asciinema.md](01_asciinema.md) — asciinema (instalar, usar y grabar tus prácticas)
- [02_prolog.md](02_prolog.md) — SWI-Prolog 9.x
- [03_erlang.md](03_erlang.md) — Erlang/OTP 26+
- [04_haskell.md](04_haskell.md) — GHC 9.x
- [05_clojure.md](05_clojure.md) — Clojure
- [06_elixir.md](06_elixir.md) — Elixir
- [07_ocaml.md](07_ocaml.md) — OCaml

## Anexo A — Descargar `llavesita.pem` y conectarte con VS Code o Termius

El script deja `llavesita.pem` **dentro de CloudShell**. Para conectarte desde tu
propia PC o tu celular (en vez de escribir `ssh` en CloudShell) necesitas sacar
esa llave a tu equipo.

> 🔑 `llavesita.pem` es una **llave privada**: vale lo mismo que una contraseña.
> No la subas a GitHub, no la mandes por WhatsApp/Telegram/correo, no la pegues
> en un Gist público. Si se te pierde o se filtra, corre el script otra vez: crea
> una nueva e invalida la anterior.

### A.1 · Sacar la llave de CloudShell

**Opción 1 — Descargar archivo (PC).**
En CloudShell, menú **Actions** (arriba a la derecha) → **Download file** → escribe
la ruta:

```
llavesita.pem
```

Se guarda en la carpeta *Descargas* de tu navegador.

**Opción 2 — Copiar y pegar (sirve para celular).**
En CloudShell:

```bash
cat llavesita.pem
```

Selecciona **todo** el bloque, desde `-----BEGIN ... PRIVATE KEY-----` hasta
`-----END ... PRIVATE KEY-----` inclusive, y cópialo. Lo pegarás directo en la app
(A.4). Así evitas mandar el archivo por apps de mensajería.

### A.2 · Permisos de la llave (solo PC)

SSH rechaza una llave con permisos abiertos.

```bash
# macOS / Linux
mkdir -p ~/.ssh && mv ~/Downloads/llavesita.pem ~/.ssh/
chmod 400 ~/.ssh/llavesita.pem
```

```powershell
# Windows (PowerShell) — Windows 10/11 ya trae ssh, no necesitas PuTTY
mkdir $HOME\.ssh -Force
move $HOME\Downloads\llavesita.pem $HOME\.ssh\
icacls $HOME\.ssh\llavesita.pem /inheritance:r /grant:r "$($env:USERNAME):(R)"
```

### A.3 · VS Code — extensión Remote-SSH

1. Instala la extensión **Remote - SSH** (`ms-vscode-remote.remote-ssh`).
2. Deja la llave en `~/.ssh/llavesita.pem` con `chmod 400` (A.2).
3. Agrega este bloque a `~/.ssh/config` (créalo si no existe):

   ```
   Host plf-nodo
       HostName <IP_PUBLICA>
       User ubuntu
       IdentityFile ~/.ssh/llavesita.pem
       IdentitiesOnly yes
       StrictHostKeyChecking accept-new
   ```

4. `F1` → **Remote-SSH: Connect to Host…** → `plf-nodo`. Se abre una ventana de
   VS Code trabajando *dentro* del nodo: editor, terminal y explorador de archivos.
5. **Cada sesión del Learner Lab la IP pública cambia.** Solo actualiza la línea
   `HostName` con la IP nueva (la ves con el comando de la tabla de abajo).

### A.4 · Termius — iPhone / Android / escritorio

1. **Keychain** (llavero) → **New Key**:
   - *Private key*: pega el contenido de `llavesita.pem` (Opción 2 de A.1), o
     importa el archivo si lo pasaste al teléfono por AirDrop / Google Drive.
   - *Passphrase*: déjalo vacío.
   - Nómbrala `llavesita`.
2. **Hosts** → **New Host**:
   - *Address*: `<IP_PUBLICA>`
   - *Username*: `ubuntu`
   - *Key*: `llavesita`
3. Toca el host para conectar.
4. Igual que en VS Code: al reiniciar el lab, edita el campo *Address* con la IP
   nueva.

### A.6 · Cyberduck — transferencias con interfaz gráfica

[Cyberduck](https://cyberduck.io) (gratis, código abierto, macOS/Windows) es un
cliente **SFTP/S3** con ventana de arrastrar-y-soltar, útil para mover carpetas
grandes entre tu PC y el nodo sin escribir comandos `scp`.

> Descárgalo **solo** de `cyberduck.io`, la Microsoft Store o la Mac App Store
> (`brew install --cask cyberduck` en macOS). Otros dominios son espejos no
> oficiales.

- **Conectar al nodo:** *Open Connection* → protocolo **SFTP** → Server
  `<IP_PUBLICA>`, Username `ubuntu`, y en *More Options* → **SSH Private Key**
  elige `llavesita.pem`. Sin contraseña.
- **Google Drive / S3:** también los abre como marcadores (*Open Connection* →
  Google Drive / Amazon S3), práctico para respaldar tu código al cierre del
  curso.

**Límites que conviene conocer:**

- Cyberduck **lista y transfiere**; no monta el nodo como disco local. Para eso
  existe **Mountain Duck** (de pago, ~$39), que con directorios de miles de
  archivos se vuelve lento.
- Con Google Drive la API es lenta para operaciones masivas y los Google Docs se
  exportan (no son archivos reales). Para sincronización grande hacia Drive/S3 es
  mejor **[rclone](https://rclone.org)** (gratis, scriptable, con reintentos y
  paralelismo). Para montar el nodo como carpeta desde Linux/macOS: `sshfs`.

### A.7 · Al terminar el curso

Borra `llavesita.pem` de todos tus dispositivos y elimina la llave del llavero de
Termius / de `~/.ssh/`. La llave del lab deja de servir cuando vencen los créditos.

## Anexo B — Tú tienes el control de la VM

Tu instancia **no desaparece** cuando cierras el lab: solo se **detiene**. Puedes
listarla, apagarla, encenderla y borrarla cuando quieras, todo desde CloudShell.
El script la crea con la etiqueta `Name=Curso-PLF`, así que **no dependes del ID
aleatorio** (`i-0abc123…`) que asigna AWS ni de los nombres sin sentido de la
consola: siempre te refieres a ella por su etiqueta.

### B.1 · Listar tus VMs

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=Curso-PLF" \
  --query "Reservations[].Instances[].{ID:InstanceId,Nombre:Tags[?Key=='Name']|[0].Value,Estado:State.Name,Tipo:InstanceType,IP:PublicIpAddress}" \
  --output table
```

Salida típica:

```
------------------------------------------------------------------------
|                          DescribeInstances                           |
+----------------------+-----------+------------+------------+----------+
|         ID           |  Nombre   |  Estado    |    Tipo    |    IP    |
+----------------------+-----------+------------+------------+----------+
|  i-0a1b2c3d4e5f6a7b8 | Curso-PLF | running    | t4g.large  | 3.9.1.2  |
+----------------------+-----------+------------+------------+----------+
```

Para ver **todas** tus instancias (por si creaste varias), quita la línea
`--filters`.

Guarda el ID en una variable para los comandos siguientes:

```bash
ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=Curso-PLF" "Name=instance-state-name,Values=running,stopped" \
  --query "Reservations[0].Instances[0].InstanceId" --output text)
echo $ID
```

### B.2 · Apagar (para no gastar crédito)

Una instancia **detenida no cobra cómputo** (solo el disco, ~$2.40/mes por 30 GB).
Apágala cuando termines de trabajar:

```bash
aws ec2 stop-instances --instance-ids $ID
```

### B.3 · Encender de nuevo

```bash
aws ec2 start-instances --instance-ids $ID

# la IP pública cambió: pídela otra vez
aws ec2 describe-instances --instance-ids $ID \
  --query "Reservations[0].Instances[0].PublicIpAddress" --output text
```

> El disco, tu código y el software instalado **se conservan** entre apagar y
> encender. Lo único que cambia es la IP pública.

### B.4 · Borrar la VM (terminate)

Esto **destruye** la instancia y su disco (con `DeleteOnTermination:true`). Úsalo
si algo quedó mal y prefieres empezar de cero, o al final del curso:

```bash
aws ec2 terminate-instances --instance-ids $ID
```

Después puedes volver a correr `lanzar-nodo-arm64.sh` para crear una nueva desde
cero.

### B.5 · Desde la consola web (alternativa gráfica)

**EC2 → Instances**. Como tienen la columna *Name* = `Curso-PLF`, las localizas
de inmediato. Selecciona la instancia → botón **Instance state** →
*Stop / Start / Terminate*.

## Notas operativas

| Situación | Qué hacer |
|-----------|-----------|
| Listar / apagar / encender / borrar la VM | Ver el [Anexo B](#anexo-b--tú-tienes-el-control-de-la-vm) |
| La IP cambió tras reiniciar el lab | `aws ec2 describe-instances --filters Name=tag:Name,Values=Curso-PLF --query "Reservations[].Instances[].PublicIpAddress" --output text` |
| Perdiste `llavesita.pem` | Vuelve a correr el script: detecta la key huérfana y la recrea |
| `run-instances` da `VcpuLimitExceeded` / `UnauthorizedOperation` | El lab no permite `t4g.large`; relanza con `INSTANCE_TYPE=t4g.medium ./lanzar-nodo-arm64.sh` |
| Ya existe una VM `Curso-PLF` y el script pregunta | Es la guarda anti-duplicados; responde `si` para otra, o `FORCE=1` para saltarla |
| Terminaste la sesión | Apaga la VM (Anexo B.2) y **End Lab** en Learner Lab; la instancia queda detenida, no borrada |

> 💰 Tu presupuesto es de **$50 USD**, asignados por el docente al inicio del
> semestre. `t4g.large` cuesta ≈ $0.067/hora y `t4g.medium` ≈ $0.034/hora —
**apaga la VM** (Anexo B.2) al terminar cada sesión.
> ⚠️ Los créditos **vencen al concluir el semestre** y no se acumulan: respalda
> tu código en GitHub (usa `gh` y Gist) antes del cierre del curso.
