# pdfterm

**Lee libros en PDF desde la terminal, sin abrir un visor gráfico.**

`pdfterm` extrae el texto de cada página y lo compone para leerlo de verdad:
columna estrecha centrada, interlineado y separación entre párrafos a tu gusto,
y una guía que marca el renglón por el que vas. Es un único script de Bash sin
dependencias de lenguaje: el trabajo lo hacen `pdftotext`, `awk` y `fmt`.

```
Mushoku Tensei Jobless Reincarnation Volumen 15
página 61 de 242 · renglón 4/35 · ancho 92 · inter 0 · párr 1 · suave
________________________________________________________________________

   1 │ Capítulo IV – Hipótesis De Nanahoshi

   2 │ "Dudar del Hombre-Dios sin oponerse a él".

   3 │ Esas fueron las palabras que dijo mi yo del futuro.

   4 ▸ Sin duda, muchas de las cosas que dijo el Hombre-Dios me parecieron
   5 │ dudosas, especialmente la parte de que Orsted quería destruir el
   6 │ mundo, o que el mundo se desmoronaba si él moría.
```

## Por qué

Leer un PDF en la terminal suele ser `pdftotext archivo.pdf - | less`, y el
resultado es incómodo: los renglones vienen cortados como estaban maquetados,
cada página arrastra su cabecera y su pie repetidos, el texto ocupa el ancho
completo de la ventana, y si apartas la vista un momento pierdes el renglón.

`pdfterm` resuelve esas cuatro cosas.

## Qué hace

- **Recompone los párrafos.** Une los renglones cortados y los reparte al ancho
  que elijas, con el interlineado y la separación entre párrafos que quieras.
- **Quita cabeceras y pies solo.** No van codificados: la primera vez que abres
  un libro muestrea sus páginas y aprende qué líneas se repiten, así que
  funciona con cualquier documento, incluidos los pies que llevan el número de
  página incrustado.
- **Guía de lectura.** Un renglón resaltado que marca por dónde vas. Lo mueves
  con la rueda del ratón, con `j` y `k` o pinchando directamente en él, y la
  vista se desplaza sola para mantenerlo visible. Si te interrumpen, al volver
  sigue ahí.
- **Recuerda dónde lo dejaste**, por libro y hasta el renglón exacto.
- **Dibuja las ilustraciones** en la propia terminal, con `chafa`.
- **Busca en todo el libro** y lista las páginas donde aparece lo que buscas.
- **Se ajusta mientras lees.** Ancho, interlineado, párrafos, numeración, tema
  de color y estilo de cabecera se cambian con una tecla y se guardan solos.

## Instalación

En una línea, en cualquier Linux o macOS:

    curl -fsSL https://raw.githubusercontent.com/JansenDev/pdfterm/main/install.sh | bash

Comprueba las dependencias, instala las que falten con el gestor que encuentre
(`apt`, `dnf`, `pacman`, `zypper`, `apk` o `brew`) y deja el programa en
`~/.local/bin`, añadiéndolo a tu PATH si no estaba. No pregunta nada; si no
eres root, `sudo` pedirá tu contraseña para los paquetes.

En Debian, Ubuntu o WSL también puedes usar el paquete de la
[última release](https://github.com/JansenDev/pdfterm/releases/latest):

    sudo apt install ./pdfterm_1.2.0_all.deb

Los demás métodos y la resolución de problemas están en [INSTALL.md](INSTALL.md).

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

La lista completa está en [SHORTCUTS.md](SHORTCUTS.md).

## Guía de lectura

Cada libro se abre con la guía **apagada**: la rueda desplaza la página entera,
como en cualquier visor. Se enciende con `l`, y entonces aparece el renglón
marcado con `▸`; la vista lo acompaña para que nunca quede fuera de pantalla.
Se mantiene mientras pasas páginas y se olvida al cerrar.

Mientras el ratón está capturado, para seleccionar texto hay que mantener Shift
al arrastrar. La tecla `r` se lo devuelve al terminal.

## Requisitos

`poppler-utils` y `gawk` son obligatorios; `chafa` es opcional y solo hace falta
para ver las ilustraciones.

    sudo apt install -y poppler-utils gawk chafa

Tiene que ser `gawk`, no `mawk`: `mawk` no maneja UTF-8 y rompería los acentos.

## Configuración

Los ajustes viven en `~/.config/pdfterm/config`, un fichero comentado que puedes
editar a mano o cambiar con las teclas del propio lector. Cubre ancho de
columna, interlineado, separación entre párrafos, numeración de renglones,
estilo de la cabecera y colores, incluido un tema propio con la paleta que
prefieras.

## Archivos

    ~/.local/bin/pdfterm          el programa
    ~/.config/pdfterm/config      ajustes
    ~/.local/share/pdfterm/       posición de lectura y cabeceras, por libro

## Limitaciones

- Necesita que el PDF tenga capa de texto. Con un escaneo hay que pasarle OCR
  antes (`ocrmypdf -l spa entrada.pdf salida.pdf`).
- Las ilustraciones se ven mejor en terminales con soporte sixel: Windows
  Terminal 1.22 o superior, kitty, WezTerm, iTerm2.

## Licencia

MIT. Ver [LICENSE](LICENSE).
