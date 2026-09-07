#!/usr/bin/env bash
# Desinstala pdfterm. Con --purge borra también configuración y caché.
set -euo pipefail
for d in "$HOME/.local/bin/pdfterm" /usr/local/bin/pdfterm; do
  [ -f "$d" ] && { rm -f "$d" 2>/dev/null || sudo rm -f "$d"; echo "Borrado: $d"; }
done
if [ "${1:-}" = "--purge" ]; then
  rm -rf "$HOME/.config/pdfterm" "$HOME/.local/share/pdfterm"
  echo "Borradas también la configuración y la caché de posiciones"
fi
