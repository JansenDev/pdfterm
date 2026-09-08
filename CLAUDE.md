# pdfterm

Lector de PDF para la terminal, escrito en Bash. Un único script sin
dependencias de lenguaje: todo el trabajo lo hacen `pdftotext`, `awk` y `fmt`.

## Estructura

    pdfterm            el programa entero (un solo script)
    install.sh         instalador multiplataforma (apt, dnf, pacman, zypper, brew)
    INSTALL.md         instalación detallada y resolución de problemas
    SHORTCUTS.md       todos los atajos y funcionalidades
    LICENSE            MIT
    uninstall.sh       desinstalador, con --purge para config y caché
    Makefile           install / uninstall / deb / clean
    debian/DEBIAN/     control del paquete .deb
    VERSION            versión actual, la leen el Makefile y el control

## Cómo funciona

El script encadena tres etapas por cada página:

1. `pdftotext -layout -f N -l N` extrae el texto de una página.
2. `filtrar()` elimina cabeceras y pies. No van codificados: la primera vez que
   se abre un libro se muestrean 12 páginas y se guardan en
   `~/.local/share/pdfterm/<md5>.hdr` las líneas que se repiten 6 veces o más.
   Para comparar se normaliza quitando dígitos y colapsando espacios, porque
   los pies suelen llevar el número de página incrustado.
3. `formatear()` une los renglones de cada párrafo, los reajusta con `fmt` al
   ancho configurado, los numera, los centra y aplica el interlineado.

Si una página tiene menos de 120 caracteres se considera una ilustración y se
renderiza con `pdftoppm` + `chafa` en vez de mostrarse como texto.

## Guía de lectura y ratón

`formatear()` escribe dos ficheros: la página ya compuesta y un **mapa** con el
número de renglón que corresponde a cada línea de salida (0 en las líneas en
blanco). El mapa es lo que permite traducir la fila donde se hace clic al
renglón que hay debajo, y encontrar en qué línea pintar la guía.

El ratón se activa con `\033[?1000h` más `\033[?1006h` (protocolo SGR, necesario
para ventanas de más de 223 columnas). `leer_tecla()` lee byte a byte y
distingue teclas normales, flechas y secuencias del ratón.

La vista es una ventana deslizante sobre la página: `VISTA` es la primera línea
mostrada y `seguir_marca()` la ajusta lo justo para que la guía siga visible.
Con la guía apagada (`GUIA=0`) manda `scroll_vista()` y no se resalta nada.

`GUIA` se guarda en dos sitios: como valor por defecto en el config, y por
libro en el tercer campo del fichero `.pos` (`página renglón guía`). El del
libro manda sobre el global; los `.pos` antiguos de dos campos siguen leyéndose
y toman el global. Pulsar `l` actualiza los dos.

`GUIA_ESTILO` decide si se resalta el renglón entero (`linea`) o solo el número
y la flecha (`marca`). El resaltado se aplica en `mostrar()`, sobre la página ya
compuesta, nunca en `formatear()`: rehacer la página al mover la guía costaba
86 ms.

Cuidado con la flecha cuando la numeración está apagada. No hay `│` que
sustituir, así que se coloca **al final del margen izquierdo, ocupando el sitio
de dos espacios**. Si se antepone, empuja el texto y el renglón marcado queda
desalineado; si se mete al principio del margen, en ventanas anchas acaba
pegada al borde y lejos del texto. Ver la función `flecha()`.

## Rendimiento: no rehacer lo que no cambia

Dos reglas que no son evidentes al leer el código y que costó descubrir:

- **`render()` solo se llama al cambiar de página o de formato**, nunca al mover
  la guía. Extraer la página con `pdftotext` cuesta unos 86 ms; hacerlo en cada
  pulsación volvía el lector inusable. Mover la guía solo repinta, y eso son 3 ms.
- **`mostrar()` no borra la pantalla.** Reposiciona el cursor con `\033[H` y
  sobrescribe, borrando cada línea con `\033[K` justo antes de reescribirla. Un
  `clear` deja la pantalla vacía mientras se prepara el contenido, y ese hueco
  se ve como parpadeo. El lector trabaja en la pantalla alternativa
  (`\033[?1049h`) para no ensuciar el historial del terminal.

## Dibujar ilustraciones: tres cosas que no son evidentes

`render_img()` no le pasa a `chafa` un area en celdas sin mas. Hay tres
detalles, todos medidos sobre la salida real y ninguno documentado:

1. **`--font-ratio=1/1`.** El valor por defecto es 1/2, y con el se emite un
   sixel de aspecto distinto al de la imagen: se ve estirada. Con 1/1 el
   raster sale con el aspecto correcto. Solo se aplica a los formatos
   graficos; en `symbols` la celda si es 1:2 y forzarlo deformaria.
2. **8 px por celda.** Con `--font-ratio=1/1`, `chafa` traduce cada celda del
   `--size` a 8x8 px del sixel. Por eso el area se calcula en pixeles y se
   divide por 8 al final.
3. **El area debe tener el aspecto de la imagen.** Si se le da una mas ancha,
   ajusta a lo alto y rellena el resto con el color de fondo: aparece una
   franja negra al lado de la ilustracion.

Y el tamaño de celda del terminal se pregunta con `CSI 16 t`
(`consultar_celda()`), porque ConPTY no lo informa por ioctl y `chafa` asume
8x8. Sin esa consulta, en una ventana de celdas 10x20 la imagen sale a menos
de la mitad: se pedian 22 filas y se generaba un sixel de 176 px de alto en
lugar de 840. Si el terminal no contesta se usa 8x8 y se degrada sin fallar.

`dims_png()` lee ancho y alto de la cabecera del PNG con `od`, para no añadir
dependencias solo por eso.

En las paginas de ilustracion, `alto_cabecera()` devuelve 1 y se usa `AYUDA_IMG`
en vez de `AYUDA`, para dejarle a la imagen todas las filas posibles.

## La barra de ayuda y el alto disponible

La barra de ayuda mide unos 160 caracteres y en la mayoría de ventanas ocupa
**dos filas**. `filas_ayuda()` calcula cuántas hace falta según el ancho, y
`calcular_alto()` las descuenta. Reservar solo una hacía que se escribiera una
fila de más, el terminal desplazaba y el repintado se veía como un rebote,
sobre todo al llegar a los extremos de la página, donde el texto ya no cambia.

Si se alarga la barra, no hay que tocar nada más: el cálculo se adapta solo.
Lo que **no** hay que hacer es acortarla para que quepa en una fila; se probó y
el usuario prefiere verla entera.

Las líneas de la cabecera sí pueden ocupar la fila completa del terminal en
ventanas estrechas y descuadrar el repintado. Hubo un arreglo que se revirtió
porque venía junto con el acortado de la barra. Si se retoma, recortar por
caracteres y no por bytes: `cut -c` parte los multibyte y ensucia la línea.

## Convenciones

- Comentarios y mensajes al usuario, en español.
- Bash puro. No introducir Python, Node ni ninguna otra dependencia de lenguaje.
- **`gawk`, no `mawk`.** `mawk` no maneja UTF-8 y rompe los acentos y el patrón
  que resalta `Capítulo`, `Prólogo` y `Epílogo`. Está declarado en `Depends`.
- Al añadir o cambiar una tecla, actualizar `SHORTCUTS.md` y la barra de ayuda
  del propio lector, no solo el README.
- Toda preferencia nueva debe: tener valor por defecto arriba del script,
  escribirse en `guardar_conf()` con su comentario explicativo, y ser
  ajustable con una tecla dentro del lector.
- No commitear ni publicar tras cada ajuste: se acumulan los cambios y se
  cierran cuando el usuario los ha probado y los da por buenos.
- `guardar_conf()` reescribe el fichero entero, comentarios incluidos, para que
  nunca quede ilegible. Al añadir una clave, actualizar la comprobación de
  migración (`grep -q '^CABECERA=' ...`) o los usuarios antiguos no la reciben.

## Probar un cambio

El lector es interactivo; para probarlo sin bloquear la terminal se le pasa el
comando por la entrada estándar y se limpian los códigos de color:

    printf 'q\n' | pdfterm libro.pdf 61 | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | head -20

Comprobar siempre la sintaxis antes de instalar:

    bash -n pdfterm

Al tocar `filtrar()`, borrar la caché para que vuelva a aprender:

    rm -f ~/.local/share/pdfterm/*.hdr

## Publicar una versión

1. Actualizar `VERSION` (versionado semántico).
2. Añadir la entrada correspondiente en `CHANGELOG.md`.
3. `make deb` para regenerar el paquete.
4. Commit, `git tag -a vX.Y.Z`, y subir el `.deb` como artefacto de la release.
