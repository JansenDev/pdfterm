# pdfterm

Lector de PDF para la terminal, escrito en Bash. Un único script sin
dependencias de lenguaje: todo el trabajo lo hacen `pdftotext`, `awk` y `fmt`.

## Estructura

    pdfterm            el programa entero (un solo script)
    install.sh         instalador multiplataforma (apt, dnf, pacman, zypper, brew)
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

## Convenciones

- Comentarios y mensajes al usuario, en español.
- Bash puro. No introducir Python, Node ni ninguna otra dependencia de lenguaje.
- **`gawk`, no `mawk`.** `mawk` no maneja UTF-8 y rompe los acentos y el patrón
  que resalta `Capítulo`, `Prólogo` y `Epílogo`. Está declarado en `Depends`.
- Toda preferencia nueva debe: tener valor por defecto arriba del script,
  escribirse en `guardar_conf()` con su comentario explicativo, y ser
  ajustable con una tecla dentro del lector.
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
