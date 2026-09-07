# pdfterm

Lector de PDF para la terminal. Muestra el libro página a página como texto
formateado, sin salir de la consola.

- Reajusta los párrafos a una columna centrada del ancho que elijas.
- Detecta y elimina solo las cabeceras y pies que se repiten en el documento.
- Numera los renglones en el margen izquierdo.
- Interlineado y separación entre párrafos configurables.
- Recuerda por qué página ibas en cada libro.
- Dibuja en la terminal las páginas que son ilustraciones (necesita `chafa`).
- Busca texto en todo el documento y lista las páginas donde aparece.

## Instalación

### Desde el repositorio

    git clone https://github.com/JansenDev/pdfterm.git
    cd pdfterm && ./install.sh

Para actualizar más adelante:

    git pull && ./install.sh

### Con el paquete .deb (Debian, Ubuntu, WSL)

Resuelve las dependencias automáticamente:

    sudo apt install ./pdfterm_1.0.0_all.deb

### Con el instalador (cualquier Linux o macOS)

    ./install.sh          # en ~/.local/bin, sin root
    sudo ./install.sh -g  # en /usr/local/bin, para todo el sistema

Comprueba las dependencias y ofrece instalarlas con apt, dnf, pacman,
zypper o brew, según lo que encuentre.

### A mano

    make install                    # en ~/.local
    make install PREFIX=/usr/local  # en todo el sistema

## Uso

    pdfterm libro.pdf         # abre por donde ibas
    pdfterm libro.pdf 61      # abre en la página 61
    pdfterm --config          # edita la configuración

Los comandos se escriben y se confirman con Enter:

| Tecla     | Acción                                     |
|-----------|--------------------------------------------|
| `Enter`   | Página siguiente                           |
| `p`       | Página anterior                            |
| `61`      | Ir a esa página                            |
| `/texto`  | Buscar y listar las páginas con coincidencia |
| `i`       | Ver la página actual como imagen           |
| `+` `-`   | Interlineado                               |
| `.` `,`   | Separación entre párrafos                  |
| `>` `<`   | Ancho de la columna                        |
| `#`       | Numeración de renglones                    |
| `t`       | Tema de color                              |
| `h`       | Estilo de la cabecera                      |
| `q`       | Salir                                      |

Los ajustes se guardan al momento en `~/.config/pdfterm/config`, que está
comentado y se puede editar a mano.

## Dependencias

Obligatorias: `poppler-utils` (pdftotext, pdfinfo, pdftoppm), `gawk`,
`coreutils`, `sed`, `grep`, `ncurses-bin`.

Opcional: `chafa`, para ver las ilustraciones. Sin él el resto funciona igual.

Importante: hace falta `gawk`, no `mawk`. Ubuntu instala `mawk` por defecto y
no maneja UTF-8, así que romperían los acentos.

    sudo apt install -y poppler-utils gawk chafa

## Archivos

    ~/.local/bin/pdfterm          el programa
    ~/.config/pdfterm/config      ajustes
    ~/.local/share/pdfterm/       caché: posición de lectura y cabeceras por libro

## Versionado

El proyecto sigue versionado semántico. La versión vive en el fichero `VERSION`,
de donde la leen el `Makefile` y el control del paquete. Los cambios de cada
versión están en `CHANGELOG.md`.

## Desinstalar

    ./uninstall.sh            # borra el programa
    ./uninstall.sh --purge    # borra también configuración y caché
