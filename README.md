# pdfterm

Lector de PDF para la terminal. Muestra el libro página a página como texto
formateado, sin salir de la consola.

- Reajusta los párrafos a una columna centrada del ancho que elijas.
- Detecta y elimina solo las cabeceras y pies que se repiten en el documento.
- Numera los renglones en el margen izquierdo.
- Interlineado y separación entre párrafos configurables por separado.
- Recuerda por qué página ibas en cada libro.
- Dibuja en la terminal las páginas que son ilustraciones.
- Busca texto en todo el documento y lista las páginas donde aparece.

## Instalación

En Debian, Ubuntu o WSL:

    sudo apt install ./pdfterm_1.0.0_all.deb

En cualquier otro sistema:

    git clone https://github.com/JansenDev/pdfterm.git
    cd pdfterm && ./install.sh

Las dependencias, los demás métodos y la resolución de problemas están en
[INSTALL.md](INSTALL.md).

## Uso

    pdfterm libro.pdf         # abre por donde ibas
    pdfterm libro.pdf 61      # abre en la página 61
    pdfterm --config          # edita la configuración

Los comandos se escriben y se confirman con Enter:

| Tecla     | Acción                                       |
|-----------|----------------------------------------------|
| `Enter`   | Avanza una pantalla; al final de la página, pasa a la siguiente |
| `b`       | Retrocede una pantalla                       |
| `p`       | Página anterior                              |
| `g`       | Vuelve al principio de la página             |
| `61`      | Ir a esa página                              |
| `/texto`  | Buscar y listar las páginas con coincidencia |
| `i`       | Ver la página actual como imagen             |
| `+` `-`   | Interlineado                                 |
| `.` `,`   | Separación entre párrafos                    |
| `>` `<`   | Ancho de la columna                          |
| `#`       | Numeración de renglones                      |
| `t`       | Tema de color                                |
| `h`       | Estilo de la cabecera                        |
| `q`       | Salir                                        |

## Configuración

Los ajustes se guardan al momento en `~/.config/pdfterm/config`, un fichero
comentado que también se puede editar a mano. Cubre el ancho de columna, el
interlineado, la separación entre párrafos, la numeración, el estilo de la
cabecera y los colores, incluido un tema propio con la paleta que prefieras.

## Archivos

    ~/.local/bin/pdfterm          el programa
    ~/.config/pdfterm/config      ajustes
    ~/.local/share/pdfterm/       caché: posición de lectura y cabeceras por libro

## Versionado

Versionado semántico. La versión vive en el fichero `VERSION`, de donde la leen
el `Makefile` y el control del paquete. Los cambios de cada versión están en
[CHANGELOG.md](CHANGELOG.md).
