#!/bin/bash
# ==========================================
# Script: install_pi_zero2w.sh
# Curso: Programación Lógica y Funcional — TecNM
# Descripción: Instala SWI-Prolog y Erlang/OTP en una Raspberry Pi Zero 2W
#              con Raspberry Pi OS Lite 64-bit (Bookworm) o Ubuntu Server ARM64.
# Uso: bash install_pi_zero2w.sh
# ==========================================
set -euo pipefail

echo "======================================"
echo " PLF · Raspberry Pi Zero 2W installer"
echo "======================================"

# ----- 0. Sanidad: arquitectura y sistema -----
ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ]; then
  echo "❌ Arquitectura detectada: $ARCH (se esperaba aarch64)."
  echo "   Instala una imagen de 64 bits (Raspberry Pi OS Lite 64-bit)."
  exit 1
fi
echo "✅ Arquitectura: aarch64"
grep -m1 "Model" /proc/cpuinfo 2>/dev/null || true

# ----- 1. Swap: la Zero 2W solo tiene 512 MB de RAM -----
SWAP_MB=$(free -m | awk '/Swap:/ {print $2}')
if [ "$SWAP_MB" -lt 1024 ]; then
  echo "===== 1. Ampliando swap a 1024 MB (RAM actual: $(free -m | awk '/Mem:/ {print $2}') MB) ====="
  if [ -f /etc/dphys-swapfile ]; then
    # Raspberry Pi OS
    sudo sed -i 's/^CONF_SWAPSIZE=.*/CONF_SWAPSIZE=1024/' /etc/dphys-swapfile
    sudo systemctl restart dphys-swapfile
  else
    # Ubuntu Server u otra distro sin dphys-swapfile
    sudo fallocate -l 1G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    grep -q '/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
  fi
  free -h
else
  echo "✅ Swap suficiente: ${SWAP_MB} MB"
fi

# ----- 2. Actualizar índices -----
echo "===== 2. apt update ====="
sudo apt update

# ----- 3. SWI-Prolog -----
echo "===== 3. Instalando SWI-Prolog ====="
sudo apt install -y swi-prolog

# ----- 4. Erlang/OTP -----
# En Bookworm/noble apt trae OTP 25.x. Compilar OTP 26 en 512 MB de RAM toma
# varias horas; para la Pi el paquete del sistema es el equilibrio correcto.
echo "===== 4. Instalando Erlang/OTP ====="
sudo apt install -y erlang-base erlang-crypto erlang-ssl erlang-inets \
  erlang-syntax-tools erlang-tools erlang-dev

# ----- 5. Verificación -----
echo "===== 5. Verificación ====="
echo "--- SWI-Prolog ---"
swipl --version
swipl -g "use_module(library(clpfd)), X #= 2+2, format('CLP(FD) ok: 2+2=~w~n',[X])" -t halt

echo "--- Erlang ---"
erl -noshell -eval '
  io:format("Erlang/OTP ~s ok~n",[erlang:system_info(otp_release)]),
  Padre = self(),
  [spawn(fun() -> Padre ! N end) || N <- lists:seq(1,4)],
  [receive N -> io:format("  proceso ~p vivo~n",[N]) end || _ <- lists:seq(1,4)],
  halt().'

echo ""
echo "======================================"
echo " ✅ Instalación completa"
echo "   swipl  → REPL de Prolog"
echo "   erl    → shell de Erlang"
echo "======================================"
