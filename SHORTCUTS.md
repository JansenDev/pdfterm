# Atajos y funcionalidades

Todas las teclas actúan al pulsarlas, sin Enter. Las únicas que piden escribir
algo son `g` (número de página) y `/` (texto a buscar).

## Desde la línea de comandos

| Orden | Efecto |
|---|---|
| `pdfterm libro.pdf` | Abre por la página y el renglón donde lo dejaste |
| `pdfterm libro.pdf 61` | Abre en la página 61 |
| `pdfterm --config` | Edita la configuración con tu `$EDITOR` |
| `pdfterm -c` | Igual que `--config` |

## Navegación

| Tecla | Efecto |
|---|---|
| `espacio`, `n`, `→` | Página siguiente |
| `p`, `←` | Página anterior |
| `g` | Ir a una página concreta (pide el número) |
| `/` | Buscar texto en todo el libro |
| `q` | Salir |

Al cambiar de página la vista vuelve siempre al principio.

La búsqueda no distingue mayúsculas, recorre el libro entero y lista hasta
20 páginas con coincidencias; después puedes saltar a una de ellas. La primera
búsqueda tarda un par de segundos porque extrae todo el texto, y queda cacheada.

## Guía de lectura

| Tecla | Efecto |
|---|---|
| `l` | Encender o apagar la guía |
| `j`, `↓` | Bajar un renglón (o desplazar la página si está apagada) |
| `k`, `↑` | Subir un renglón (o desplazar la página si está apagada) |
| clic izquierdo | Poner la guía en ese renglón |
| rueda | Mover la guía, o desplazar la página si está apagada |

Encendida, el renglón activo se marca con `▸` y la vista se desplaza sola para
que nunca quede fuera de pantalla. Apagada, la rueda desplaza tres líneas por
giro y no hay nada resaltado.

**Cada libro se abre con la guía apagada.** Lo que decidas dentro se mantiene
mientras pasas páginas, pero no se guarda al salir.

## Ratón

| Tecla | Efecto |
|---|---|
| `r` | Devolver el ratón al terminal, o volver a capturarlo |

Mientras el programa captura el ratón, el terminal no puede usarlo para
seleccionar texto. Para copiar, mantén **Shift mientras arrastras**, o pulsa `r`.
A diferencia de la guía, esta preferencia sí se guarda.

## Formato del texto

| Tecla | Efecto | Valores |
|---|---|---|
| `>` `<` | Ancho de la columna | 40 a 120, de 4 en 4 |
| `+` `-` | Interlineado | 0 a 3 líneas |
| `.` `,` | Separación entre párrafos | 0 a 6 líneas (total, no extra) |
| `#` o `0` | Numeración de renglones | sí / no |
| `t` | Tema de color | suave → sepia → normal → propio |
| `h` | Estilo de la cabecera | completa → compacta → mínima → oculta |

Todos se guardan al momento y valen para el próximo libro que abras.

Para que los párrafos se distingan de un simple salto de renglón, la separación
entre párrafos tiene que ser mayor que el interlineado.

## Ilustraciones

| Tecla | Efecto |
|---|---|
| `i` | Dibujar la página actual como imagen |

Las páginas con menos de 120 caracteres se consideran ilustraciones y se dibujan
solas, sin pulsar nada. Necesita `chafa`; sin él, el resto sigue funcionando.

## Qué se guarda y qué no

| | Dónde | Cuándo |
|---|---|---|
| Página y renglón | `~/.local/share/pdfterm/` | Uno por libro, al momento |
| Ancho, interlineado, párrafos, números, tema, cabecera, ratón | `~/.config/pdfterm/config` | Al pulsar la tecla |
| Guía de lectura encendida | En ninguna parte | Se olvida al salir, a propósito |
| Cabeceras y pies detectados | `~/.local/share/pdfterm/` | La primera vez que abres cada libro |
| Texto completo para buscar | `~/.local/share/pdfterm/` | La primera vez que buscas en ese libro |

Si las cabeceras y pies de un libro no se filtran bien, borra lo aprendido y se
vuelven a detectar:

    rm -f ~/.local/share/pdfterm/*.hdr
