#!/usr/bin/env bash
# =====================================================================
# Programa:    lanzar-nodo-arm64.sh
# Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
# Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
# Actividad:   Instalación — nodo AWS Academy
# Fecha:       2026-07-18
#   rev. 2026-09-01a: disco root 30 GB gp3 + swap 4 GB vía user-data;
#                     tag Name en instancia y volumen; comandos de gestión.
#   rev. 2026-09-01b: puertos de Erlang distribuido (EPMD 4369 + rango 9100-9105).
#   rev. 2026-09-01c: script endurecido — set -euo pipefail, validación de cada
#                     recurso, reglas de SG idempotentes, guarda contra
#                     instancias duplicadas, resumen final auditable.
# Descripción: Lanza una instancia EC2 ARM64 (key pair, security group, AMI
#              Ubuntu 24.04) desde AWS CloudShell del Learner Lab.
# IA:          Generado con Claude Code, verificado y modificado por el docente
#              (corridas auditadas con el AWS CLI contra la cuenta real).
# Ajustes:     Variables overrideables por entorno. Ejemplos:
#                INSTANCE_TYPE=t4g.small ROOT_GB=40 ./lanzar-nodo-arm64.sh
#                INSTANCE_NAME=Curso-PLF-nodo2 ./lanzar-nodo-arm64.sh
#                FORCE=1 ./lanzar-nodo-arm64.sh   # no preguntar si ya hay una VM
# Origen:      https://gist.github.com/IoTeacher/c214a55f457d47ba715362f00434b97e
# Uso:         ejecutar dentro de AWS CloudShell (AWS Academy Learner Lab)
# =====================================================================

set -euo pipefail

# ----- manejo de errores: decir en qué línea/comando falló -----
trap 'rc=$?; echo; echo "❌ ERROR (rc=$rc) en la línea $LINENO: $BASH_COMMAND" >&2; exit $rc' ERR

# ----- helpers -----
# abortar si un valor salió vacío o "None" (típico de --query --output text sin match)
need() {
  local nombre="$1" valor="$2"
  if [ -z "$valor" ] || [ "$valor" = "None" ]; then
    echo "❌ No se pudo resolver: $nombre (valor='$valor')" >&2
    exit 1
  fi
  echo "   $nombre = $valor"
}

# autorizar una regla de ingress solo si no existe ya (idempotente y auditable).
# NO usamos `aws ec2 describe-security-group-rules`: el AWS CLI de la CloudShell
# del Learner Lab es viejo y no conoce esa operación ("Invalid choice:
# 'describe-security-group-rules'"). En su lugar intentamos crear la regla e
# interpretamos el error InvalidPermission.Duplicate como "ya existía".
autorizar_ingress() {
  local sg="$1" proto="$2" desde="$3" hasta="$4" origen="$5" desc="$6"
  local origen_flag puerto
  if [[ "$origen" == sg-* ]]; then
    origen_flag=(--source-group "$origen")
  else
    origen_flag=(--cidr "$origen")
  fi
  puerto="$( [ "$desde" = "$hasta" ] && echo "$desde" || echo "$desde-$hasta" )"

  local out
  if out=$(aws ec2 authorize-security-group-ingress \
            --group-id "$sg" --protocol "$proto" --port "$puerto" \
            "${origen_flag[@]}" 2>&1); then
    echo "   ➕ agregada    $proto $desde-$hasta  <- $origen   ($desc)"
  elif echo "$out" | grep -q "InvalidPermission.Duplicate"; then
    echo "   ✅ ya existe  $proto $desde-$hasta  <- $origen"
  else
    echo "   ❌ error autorizando $proto $desde-$hasta <- $origen" >&2
    echo "$out" >&2
    return 1
  fi
}

clear

cat << "EOF"
  ░██████  ░██                              ░██   ░██████   ░██                   ░██ ░██
 ░██   ░██ ░██                              ░██  ░██   ░██  ░██                   ░██ ░██
░██        ░██  ░███████  ░██    ░██  ░████████ ░██         ░████████   ░███████  ░██ ░██
░██        ░██ ░██    ░██ ░██    ░██ ░██    ░██  ░████████  ░██    ░██ ░██    ░██ ░██ ░██
░██        ░██ ░██    ░██ ░██    ░██ ░██    ░██         ░██ ░██    ░██ ░█████████ ░██ ░██
 ░██   ░██ ░██ ░██    ░██ ░██   ░███ ░██   ░███  ░██   ░██  ░██    ░██ ░██        ░██ ░██
  ░██████  ░██  ░███████   ░█████░██  ░█████░██   ░██████   ░██    ░██  ░███████  ░██ ░██
EOF

echo "🧩 CloudShell AWS - Nodo ARM64"

echo
echo "===== 0. Preflight ====="
command -v aws >/dev/null || { echo "❌ El AWS CLI no está disponible en esta shell." >&2; exit 1; }
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
CALLER=$(aws sts get-caller-identity --query "Arn" --output text)
need "Región"   "$AWS_DEFAULT_REGION"
need "Identidad" "$CALLER"

echo
echo "===== CONFIG ====="
KEY_NAME="${KEY_NAME:-llavesita}"
SG_NAME="${SG_NAME:-arm64-ssh-group}"
DESC="Programacion Logica y Funcional - ARM64"

# Arquitectura: ARM64 (Graviton). Los 6 lenguajes del curso tienen soporte
# aarch64 completo en Ubuntu 24.04 y t4g cuesta ~20% menos que t3.
#   t4g.micro  = 1 GiB  -> Prolog/Erlang/Elixir/OCaml OK; OTP 26 solo compila con swap
#   t4g.medium = 4 GiB  -> compila OTP 26 / GHC sin swapping, ~15 min
#   t4g.large  = 8 GiB  -> holgado para ghcup+opam+BEAM y nodo compartido (default)
# El Learner Lab suele permitir hasta t4g.large; si run-instances devuelve
# VcpuLimitExceeded / UnauthorizedOperation, relanza con INSTANCE_TYPE=t4g.medium.
INSTANCE_TYPE="${INSTANCE_TYPE:-t4g.large}"

# Etiqueta (tag "Name") con la que se ve la VM en la consola EC2. SIN espacios:
# el valor no queda con comillas raras y es fácil de filtrar por CLI. EC2 no pone
# nombre por defecto -> sin este tag la instancia sale en blanco.
INSTANCE_NAME="${INSTANCE_NAME:-Curso-PLF}"

# Tags que se aplican TANTO a la instancia como a su disco (volumen EBS).
TAGS="{Key=Name,Value=$INSTANCE_NAME},{Key=Curso,Value=ISC-2006-PLF},{Key=Proyecto,Value=programacion-logica-y-funcional}"

# Disco root y swap (ghcup ~5GB + opam ~2GB + JVM/BEAM no caben en los 8 GB por defecto)
# Con t4g.large (8 GiB RAM) 2 GiB de swap bastan como colchón; súbelo a 4 en t4g.micro.
ROOT_GB="${ROOT_GB:-30}"
SWAP_GB="${SWAP_GB:-2}"

echo "   INSTANCE_TYPE = $INSTANCE_TYPE"
echo "   INSTANCE_NAME = $INSTANCE_NAME"
echo "   ROOT_GB / SWAP_GB = ${ROOT_GB} / ${SWAP_GB}"

echo
echo "===== 1. Guarda contra duplicados ====="
YA=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
            "Name=instance-state-name,Values=pending,running,stopping,stopped" \
  --query "Reservations[].Instances[].[InstanceId,State.Name,PublicIpAddress]" \
  --output text)
if [ -n "$YA" ]; then
  echo "⚠️  Ya existe una instancia con Name=$INSTANCE_NAME:"
  echo "$YA" | sed 's/^/     /'
  if [ "${FORCE:-0}" != "1" ]; then
    read -r -p "   ¿Lanzar OTRA de todas formas? (escribe 'si' para continuar) " ok
    [ "$ok" = "si" ] || { echo "   Abortado por el usuario."; exit 0; }
  fi
else
  echo "   OK, no hay instancias previas con ese nombre."
fi

echo
echo "===== 2. Key Pair ====="
if aws ec2 describe-key-pairs --key-names "$KEY_NAME" >/dev/null 2>&1; then
  if [ -f "${KEY_NAME}.pem" ]; then
    echo "   ✅ Key '$KEY_NAME' existe en AWS y el .pem local está presente."
  else
    echo "   ⚠️  Key '$KEY_NAME' existe en AWS pero falta ${KEY_NAME}.pem local."
    echo "      Recreando la key (las instancias que ya la usan conservan su acceso"
    echo "      actual; las NUEVAS usarán la key nueva)."
    aws ec2 delete-key-pair --key-name "$KEY_NAME" >/dev/null
    aws ec2 create-key-pair --key-name "$KEY_NAME" \
      --query 'KeyMaterial' --output text > "${KEY_NAME}.pem"
    chmod 400 "${KEY_NAME}.pem"
    echo "   🆕 Key recreada y guardada en ${KEY_NAME}.pem"
  fi
else
  echo "   🆕 Creando key '$KEY_NAME'..."
  aws ec2 create-key-pair --key-name "$KEY_NAME" \
    --query 'KeyMaterial' --output text > "${KEY_NAME}.pem"
  chmod 400 "${KEY_NAME}.pem"
  echo "   Guardada en ${KEY_NAME}.pem"
fi

echo
echo "===== 3. Red (VPC + subnet default) ====="
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" \
  --query "Vpcs[0].VpcId" --output text)
need "VPC default" "$VPC_ID"
SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" "Name=default-for-az,Values=true" \
  --query "Subnets[0].SubnetId" --output text)
need "Subnet default" "$SUBNET_ID"

echo
echo "===== 4. Security Group ====="
SG_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=$SG_NAME" "Name=vpc-id,Values=$VPC_ID" \
  --query 'SecurityGroups[0].GroupId' --output text)
if [ "$SG_ID" = "None" ] || [ -z "$SG_ID" ]; then
  SG_ID=$(aws ec2 create-security-group \
    --group-name "$SG_NAME" --description "$DESC" --vpc-id "$VPC_ID" \
    --query 'GroupId' --output text)
  echo "   🆕 Security group creado."
fi
need "Security group" "$SG_ID"

echo
echo "===== 5. Reglas de entrada (idempotentes) ====="
# SSH
autorizar_ingress "$SG_ID" tcp 22 22 "0.0.0.0/0" "SSH"
# Erlang distribuido (solo prácticas multi-nodo, unidad 4 / proyecto final).
# Origen = el propio SG -> NO expuesto a Internet: un nodo distribuido con la
# cookie conocida permite ejecución remota de código.
autorizar_ingress "$SG_ID" tcp 4369 4369 "$SG_ID" "EPMD (Erlang Port Mapper Daemon)"
# Rango fijo de la conexión entre nodos. Debe coincidir con los flags
#   -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9105
# al arrancar erl (ver instalacion/03_erlang.md).
autorizar_ingress "$SG_ID" tcp 9100 9105 "$SG_ID" "rango de nodos Erlang distribuido"

echo
echo "===== 6. AMI Ubuntu 24.04 ARM64 ====="
read -r AMI_ID ROOT_DEV < <(aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*" \
            "Name=state,Values=available" \
  --query "sort_by(Images, &CreationDate)[-1].[ImageId,RootDeviceName]" \
  --output text)
need "AMI"        "$AMI_ID"
need "RootDevice" "$ROOT_DEV"

echo
echo "===== 7. user-data (swap + tuning) ====="
UD=$(mktemp)
cat > "$UD" << EOF
#!/bin/bash
set -e
# --- swap de ${SWAP_GB} GiB: evita OOM al compilar GHC/opam o al correr la JVM ---
if [ ! -f /swapfile ]; then
  fallocate -l ${SWAP_GB}G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=\$((${SWAP_GB}*1024))
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi
# menos agresivo al swapear: usar RAM mientras haya
sysctl -w vm.swappiness=10
echo 'vm.swappiness=10' > /etc/sysctl.d/99-plf-swap.conf
apt-get update -y
EOF
echo "   user-data en $UD ($(wc -c < "$UD") bytes)"

echo
echo "===== 8. Lanzar instancia ====="
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --count 1 \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SG_ID" \
  --subnet-id "$SUBNET_ID" \
  --associate-public-ip-address \
  --block-device-mappings "[{\"DeviceName\":\"$ROOT_DEV\",\"Ebs\":{\"VolumeSize\":$ROOT_GB,\"VolumeType\":\"gp3\",\"DeleteOnTermination\":true}}]" \
  --user-data "file://$UD" \
  --tag-specifications \
      "ResourceType=instance,Tags=[$TAGS]" \
      "ResourceType=volume,Tags=[$TAGS]" \
  --query 'Instances[0].InstanceId' \
  --output text)
need "InstanceId" "$INSTANCE_ID"
echo "   $INSTANCE_ID  Name=$INSTANCE_NAME  ($INSTANCE_TYPE, root ${ROOT_GB}GB gp3, swap ${SWAP_GB}GB)"

echo
echo "===== 9. Esperando a instance-running ====="
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"
echo "   running ✔"

echo
echo "===== 10. Datos finales ====="
read -r PUBLIC_IP AZ STATE < <(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].[PublicIpAddress,Placement.AvailabilityZone,State.Name]" \
  --output text)
need "IP pública" "$PUBLIC_IP"

echo
echo "======================================================================"
echo " NODO LISTO"
echo "----------------------------------------------------------------------"
echo "   InstanceId : $INSTANCE_ID   ($STATE, $AZ)"
echo "   Tipo       : $INSTANCE_TYPE"
echo "   AMI        : $AMI_ID"
echo "   IP pública : $PUBLIC_IP"
echo "   Security G.: $SG_ID  ($SG_NAME)"
echo "   Key        : ${KEY_NAME}.pem"
echo "----------------------------------------------------------------------"
echo "   SSH:"
echo "     ssh -i ${KEY_NAME}.pem ubuntu@$PUBLIC_IP"
echo
echo "   El user-data crea el swap en el primer arranque (~1 min). Verifica:"
echo "     ssh -i ${KEY_NAME}.pem ubuntu@$PUBLIC_IP 'free -h && df -h /'"
echo
echo "   Gestión (por tag Name=$INSTANCE_NAME):"
echo "     Estado  : aws ec2 describe-instances --filters Name=tag:Name,Values=$INSTANCE_NAME --query 'Reservations[].Instances[].[InstanceId,State.Name,PublicIpAddress]' --output table"
echo "     Apagar  : aws ec2 stop-instances      --instance-ids $INSTANCE_ID"
echo "     Encender: aws ec2 start-instances     --instance-ids $INSTANCE_ID"
echo "     Borrar  : aws ec2 terminate-instances --instance-ids $INSTANCE_ID"
echo "======================================================================"
