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

`GUIA` es estado de sesión, no una preferencia: se fuerza a 0 después de cargar
la configuración, así que cada libro se abre con la guía apagada, y lo que se
decida dentro se mantiene al pasar páginas pero no se guarda al salir. No
añadirla a `guardar_conf()`.

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

## Problema conocido

Las líneas de la cabecera pueden ocupar la fila entera del terminal, y la barra
de ayuda inferior mide unos 150 caracteres. En ventanas estrechas ambas hacen
*wrap*, ocupan una fila de más y descuadran el repintado: se nota como que la
cabecera se redibuja mal al desplazarse. Hubo un intento de arreglarlo
recortando ambas al ancho disponible, pero se revirtió porque acortaba la barra
de ayuda y el usuario prefiere verla entera. Si se retoma, hay que recortar sin
perder teclas de la barra, y recortar por caracteres y no por bytes: `cut -c`
parte los multibyte y ensucia la línea.

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
