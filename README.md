# pdfterm

Lector de PDF para la terminal. Muestra el libro página a página como texto
formateado, sin salir de la consola.

- Guía de lectura: resalta el renglón por el que vas, lo mueves con la rueda
  o con un clic, y sigue ahí cuando vuelves de una interrupción.
- Reajusta los párrafos a una columna centrada del ancho que elijas.
- Detecta y elimina solo las cabeceras y pies que se repiten en el documento.
- Numera los renglones en el margen izquierdo.
- Interlineado y separación entre párrafos configurables por separado.
- Recuerda por qué página y por qué renglón ibas en cada libro.
- Dibuja en la terminal las páginas que son ilustraciones.
- Busca texto en todo el documento y lista las páginas donde aparece.

## Instalación

En Debian, Ubuntu o WSL:

    sudo apt install ./pdfterm_1.1.1_all.deb

En cualquier otro sistema:

    git clone https://github.com/JansenDev/pdfterm.git
    cd pdfterm && ./install.sh

Las dependencias, los demás métodos y la resolución de problemas están en
[INSTALL.md](INSTALL.md).

## Uso

    pdfterm libro.pdf         # abre por donde ibas
    pdfterm libro.pdf 61      # abre en la página 61
    pdfterm --config          # edita la configuración

Las teclas actúan al pulsarlas, sin Enter:

| Tecla            | Acción                               |
|------------------|--------------------------------------|
| `espacio`, `→`   | Página siguiente                     |
| `p`, `←`         | Página anterior                      |
| `l`              | Encender o apagar la guía de lectura |
| rueda, `j` `k`   | Mover la guía, o desplazar la página |
| clic izquierdo   | Poner la guía en ese renglón         |
| `g`              | Ir a una página concreta             |
| `/`              | Buscar texto en el libro             |
| `q`              | Salir                                |

La lista completa, con los ajustes de formato y qué se guarda de una sesión a
otra, está en [SHORTCUTS.md](SHORTCUTS.md).

## Guía de lectura

Con la guía encendida hay siempre un renglón resaltado con `▸`, que marca por
dónde vas. Se mueve con la rueda, con `j` y `k` o pinchando directamente en el
renglón, y la vista se desplaza sola para que nunca se pierda de vista. Si te
interrumpen, al volver sigue ahí; y como se guarda junto con la página, al
reabrir el libro vuelves al renglón exacto, no solo a la hoja.

Cada libro se abre con la guía **apagada**: no hay renglón resaltado y la rueda
desplaza la página entera, como en cualquier visor. Se enciende con `l`, y una
vez encendida se mantiene mientras pasas páginas, hasta que cierras el lector.
Al encenderla se coloca en el primer renglón visible, no en el que dejaste hace
rato.

Mientras el ratón está capturado, para seleccionar texto hay que mantener
Shift al arrastrar. La tecla `r` se lo devuelve al terminal.

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
