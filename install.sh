#!/usr/bin/env bash
# Instalador de pdfterm. Funciona de dos maneras:
#
#   Desde el repositorio ya clonado:
#     ./install.sh              instala en ~/.local/bin
#     sudo ./install.sh -g      instala en /usr/local/bin
#
#   Directamente desde internet, sin clonar nada:
#     curl -fsSL https://raw.githubusercontent.com/JansenDev/pdfterm/main/install.sh | bash
#
# Instala las dependencias que falten sin preguntar. Con --ask pide
# confirmacion antes de tocar nada.
set -euo pipefail

REPO="JansenDev/pdfterm"
RAMA="main"
DESTINO="$HOME/.local/bin"
PREGUNTAR=0

for arg in "$@"; do
  case "$arg" in
    -g|--global) DESTINO="/usr/local/bin" ;;
    -i|--ask)    PREGUNTAR=1 ;;
    -y|--yes)    PREGUNTAR=0 ;;
    -h|--help)   sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  esac
done

# Al ejecutarse por una tubería, la entrada estándar es el propio script:
# las preguntas hay que hacerlas contra el terminal.
preguntar() {
  local r
  [ "$PREGUNTAR" -eq 0 ] && return 0
  if [ -e /dev/tty ] && [ -r /dev/tty ]; then
    printf '    %s [S/n] ' "$1" > /dev/tty
    read -r r < /dev/tty || r=""
  else
    return 0
  fi
  case "$r" in [nN]*) return 1 ;; *) return 0 ;; esac
}

echo "==> Comprobando dependencias"
FALTAN=()
for c in pdftotext pdfinfo pdftoppm; do
  command -v "$c" >/dev/null || { FALTAN+=("poppler-utils"); break; }
done
command -v gawk >/dev/null || FALTAN+=("gawk")
command -v chafa >/dev/null || FALTAN+=("chafa")

if [ "${#FALTAN[@]}" -gt 0 ]; then
  echo "    Faltan: ${FALTAN[*]}"

  # Siendo root no hace falta sudo, y en muchas imagenes ni siquiera existe
  SUDO=""
  if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null; then SUDO="sudo "
    else
      echo "    Hay que instalarlas como root, y no encuentro sudo." >&2
      echo "    Instálalas a mano: ${FALTAN[*]}" >&2
      exit 1
    fi
  fi

  if   command -v apt-get >/dev/null; then ORDEN="${SUDO}apt-get update -qq && ${SUDO}apt-get install -y ${FALTAN[*]}"
  elif command -v dnf     >/dev/null; then ORDEN="${SUDO}dnf install -y ${FALTAN[*]}"
  elif command -v pacman  >/dev/null; then ORDEN="${SUDO}pacman -Sy --needed --noconfirm ${FALTAN[*]}"
  elif command -v zypper  >/dev/null; then ORDEN="${SUDO}zypper install -y ${FALTAN[*]}"
  elif command -v apk     >/dev/null; then ORDEN="${SUDO}apk add --no-cache poppler-utils gawk chafa"
  elif command -v brew    >/dev/null; then ORDEN="brew install poppler gawk chafa"
  else echo "    No reconozco el gestor de paquetes. Instálalas a mano." >&2; exit 1
  fi
  echo "    Instalando: $ORDEN"
  preguntar "¿Continúo?" || { echo "    Cancelado."; exit 1; }
  if [ -n "$SUDO" ] && ! sudo -n true 2>/dev/null; then
    echo "    (sudo va a pedir tu contraseña)"
  fi
  eval "$ORDEN"
else
  echo "    Todo en orden"
fi

# El script puede estar al lado (repositorio clonado) o haber que bajarlo
ORIGEN="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd || echo .)"
TMP=""
if [ -f "$ORIGEN/pdfterm" ]; then
  FUENTE="$ORIGEN/pdfterm"
  echo "==> Usando el pdfterm de $ORIGEN"
else
  echo "==> Descargando pdfterm de $REPO"
  TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
  URL="https://raw.githubusercontent.com/$REPO/$RAMA/pdfterm"
  CABECERA=()
  [ -n "${GITHUB_TOKEN:-}" ] && CABECERA=(-H "Authorization: token $GITHUB_TOKEN")
  if ! curl -fsSL "${CABECERA[@]}" -o "$TMP/pdfterm" "$URL"; then
    echo "    No se pudo descargar." >&2
    echo "    Si el repositorio es privado, pasa un token:" >&2
    echo "        GITHUB_TOKEN=\$(gh auth token) bash -c \"\$(curl -fsSL ... )\"" >&2
    exit 1
  fi
  head -1 "$TMP/pdfterm" | grep -q '^#!' || { echo "    Lo descargado no es el script." >&2; exit 1; }
  FUENTE="$TMP/pdfterm"
fi

echo "==> Instalando en $DESTINO"
mkdir -p "$DESTINO"
install -m 755 "$FUENTE" "$DESTINO/pdfterm"

case ":$PATH:" in
  *":$DESTINO:"*) ;;
  *) echo
     echo "    AVISO: $DESTINO no está en tu PATH. Añade a tu ~/.bashrc o ~/.zshrc:"
     echo "        export PATH=\"$DESTINO:\$PATH\"" ;;
esac

echo
echo "Listo. pdfterm instalado en $DESTINO"
echo "Uso:           pdfterm libro.pdf"
echo "Configuración: pdfterm --config"
