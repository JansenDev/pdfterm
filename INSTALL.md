# Instalación

## Requisitos

| Paquete | Aporta | Obligatorio |
|---|---|---|
| `poppler-utils` | `pdftotext`, `pdfinfo`, `pdftoppm` | Sí |
| `gawk` | procesado del texto | Sí |
| `bash`, `coreutils`, `sed`, `grep`, `ncurses-bin` | utilidades del sistema | Sí, ya vienen de serie |
| `chafa` | dibuja las ilustraciones en la terminal | No |

En Debian y derivados:

    sudo apt install -y poppler-utils gawk chafa

**Tiene que ser `gawk`, no `mawk`.** Ubuntu instala `mawk` por defecto y no
maneja UTF-8: los acentos saldrían rotos y no se resaltarían los títulos de
capítulo. El paquete `.deb` y `install.sh` ya se encargan de exigirlo.

## Métodos

### 1. Paquete .deb — Debian, Ubuntu, WSL

El más simple: `apt` resuelve las dependencias solo.

    wget https://github.com/JansenDev/pdfterm/releases/download/v1.0.0/pdfterm_1.0.0_all.deb
    sudo apt install ./pdfterm_1.0.0_all.deb

Instala en `/usr/bin/pdfterm`, disponible para todos los usuarios.

### 2. install.sh — cualquier Linux o macOS

    git clone https://github.com/JansenDev/pdfterm.git
    cd pdfterm
    ./install.sh

Comprueba qué falta y ofrece instalarlo con el gestor que encuentre (`apt`,
`dnf`, `pacman`, `zypper` o `brew`), pidiendo confirmación antes de tocar nada.
Instala en `~/.local/bin`, sin necesidad de root.

Para todo el sistema:

    sudo ./install.sh -g      # instala en /usr/local/bin

### 3. Makefile

Si prefieres controlar dónde va, sin que se instale ninguna dependencia:

    make install                    # en ~/.local/bin
    make install PREFIX=/usr/local  # en /usr/local/bin

### 4. A mano

Es un único script sin compilar:

    cp pdfterm ~/.local/bin/ && chmod +x ~/.local/bin/pdfterm

## Comprobar que funcionó

    pdfterm --config    # debe abrir el fichero de configuración
    pdfterm libro.pdf

## Actualizar

Desde el repositorio:

    cd pdfterm && git pull && ./install.sh

Desde el paquete, descargando el `.deb` de la nueva versión:

    sudo apt install ./pdfterm_X.Y.Z_all.deb

## Desinstalar

    ./uninstall.sh            # solo el programa
    ./uninstall.sh --purge    # también configuración y caché

O si lo instalaste con el paquete:

    sudo apt remove pdfterm

La configuración y la caché viven en `~/.config/pdfterm/` y
`~/.local/share/pdfterm/`, y no las borra `apt remove`.

## Problemas frecuentes

**`command not found: pdfterm`**

`~/.local/bin` no está en tu PATH. Añade a `~/.bashrc` o `~/.zshrc`:

    export PATH="$HOME/.local/bin:$PATH"

**Los acentos salen mal o los títulos no se resaltan**

Tienes `mawk` en lugar de `gawk`. Compruébalo y corrígelo:

    readlink -f "$(command -v awk)"    # debe terminar en gawk
    sudo apt install -y gawk

**Las ilustraciones no se ven**

Falta `chafa` (`sudo apt install chafa`). Si está instalado y aun así se ven
como bloques toscos, tu terminal no soporta gráficos sixel; funcionan bien
Windows Terminal 1.22 o superior, kitty, WezTerm e iTerm2.

**El PDF sale vacío o casi**

No tiene capa de texto: es un escaneo. Hay que pasarle OCR primero:

    sudo apt install -y ocrmypdf tesseract-ocr-spa
    ocrmypdf -l spa original.pdf con_texto.pdf

**No puedo seleccionar texto con el ratón**

Es el comportamiento esperado: con la guía de lectura el programa captura los
clics. Mantén Shift mientras arrastras, o pulsa `r` para devolverle el ratón al
terminal. Para dejarlo apagado siempre, pon `RATON=0` en la configuración.

**El clic no marca ningún renglón**

La guía de lectura está apagada, que es como arranca siempre. Enciéndela con
`l`. No se guarda entre sesiones a propósito: cada libro se abre sin ella.

**Las cabeceras y pies no se eliminan bien**

Se aprenden la primera vez que se abre cada libro y quedan cacheadas. Si el
resultado no convence, se borra la caché y se vuelven a detectar:

    rm -f ~/.local/share/pdfterm/*.hdr
