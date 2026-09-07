#!/usr/bin/env bash
# Instalador de pdfterm. Uso:
#   ./install.sh            instala en ~/.local/bin (no necesita root)
#   sudo ./install.sh -g    instala en /usr/local/bin para todo el sistema
set -euo pipefail

DESTINO="$HOME/.local/bin"
[ "${1:-}" = "-g" ] && DESTINO="/usr/local/bin"
ORIGEN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Comprobando dependencias"
FALTAN=()
for c in pdftotext pdfinfo pdftoppm; do
  command -v "$c" >/dev/null || FALTAN+=("poppler-utils")
done
command -v gawk >/dev/null || FALTAN+=("gawk")
command -v chafa >/dev/null || echo "    chafa no está (opcional: sin él no se ven las ilustraciones)"

# Quita duplicados
FALTAN=($(printf '%s\n' "${FALTAN[@]:-}" | sort -u | grep -v '^$' || true))

if [ "${#FALTAN[@]}" -gt 0 ]; then
  echo "    Faltan: ${FALTAN[*]}"
  if   command -v apt-get >/dev/null; then INSTALAR="sudo apt-get install -y ${FALTAN[*]}"
  elif command -v dnf     >/dev/null; then INSTALAR="sudo dnf install -y ${FALTAN[*]}"
  elif command -v pacman  >/dev/null; then INSTALAR="sudo pacman -S --needed ${FALTAN[*]}"
  elif command -v zypper  >/dev/null; then INSTALAR="sudo zypper install -y ${FALTAN[*]}"
  elif command -v brew    >/dev/null; then INSTALAR="brew install poppler gawk"
  else echo "    No reconozco el gestor de paquetes. Instálalas a mano."; exit 1
  fi
  echo "    Voy a ejecutar: $INSTALAR"
  read -rp "    ¿Continuo? [S/n] " r
  case "$r" in [nN]*) echo "    Cancelado."; exit 1 ;; esac
  eval "$INSTALAR"
else
  echo "    Todo en orden"
fi

echo "==> Instalando en $DESTINO"
mkdir -p "$DESTINO"
install -m 755 "$ORIGEN/pdfterm" "$DESTINO/pdfterm"

case ":$PATH:" in
  *":$DESTINO:"*) ;;
  *) echo
     echo "    AVISO: $DESTINO no está en tu PATH. Añade esta línea a tu ~/.bashrc o ~/.zshrc:"
     echo "        export PATH=\"$DESTINO:\$PATH\"" ;;
esac

echo
echo "Listo. Prueba con:  pdfterm archivo.pdf"
echo "Configuración:      pdfterm --config"
