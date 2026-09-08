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
| `L` | Estilo: renglón entero o solo el indicador |
| `j`, `↓` | Bajar un renglón (o desplazar la página si está apagada) |
| `k`, `↑` | Subir un renglón (o desplazar la página si está apagada) |
| clic izquierdo | Poner la guía en ese renglón |
| rueda | Mover la guía, o desplazar la página si está apagada |

Encendida, el renglón activo se marca con `▸` y la vista se desplaza sola para
que nunca quede fuera de pantalla. Apagada, la rueda desplaza tres líneas por
giro y no hay nada resaltado.

**Cada libro recuerda su guía.** Si la enciendes en un libro, ese libro la abre
encendida la próxima vez; los demás mantienen la suya. Un libro que abres por
primera vez hereda el valor por defecto del fichero de configuración, que
también se actualiza al pulsar `l`.

Con `L` se cambia cómo se resalta el renglón:

- **linea**: el renglón entero toma el color de la marca.
- **marca**: solo el número y la flecha; el texto conserva su color, más
  discreto para lecturas largas.

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
| `i` | Dibujar la página actual a pantalla completa |
| `I` | Listar las páginas que tienen ilustración y saltar a una |
| `F` | Cambiar el formato de dibujo: auto, sixels, kitty, iterm, symbols |

Las páginas con poco texto se consideran ilustraciones y se dibujan solas, sin
pulsar nada; ahí la cabecera y la barra se reducen a una línea cada una para
dejarle todo el sitio posible. Necesita `chafa`; sin él, el resto funciona igual.

El listado con `I` filtra por tamaño: solo cuenta las imágenes de al menos
500×500 px. Muchos PDF llevan logos o marcas de agua repetidos en todas las
páginas, y sin ese filtro saldrían todas.

Para que las ilustraciones se vean con calidad hace falta un terminal con
gráficos: Windows Terminal 1.22 o superior, kitty, WezTerm o iTerm2. Si se ven
como bloques de colores, `chafa` está en modo `symbols`: pulsa `F` hasta
`sixels`. En el fichero de configuración están `IMG_FORMATO` e `IMG_DPI`.

## Qué se guarda y qué no

| | Dónde | Cuándo |
|---|---|---|
| Página, renglón y guía | `~/.local/share/pdfterm/` | Uno por libro, al momento |
| Ancho, interlineado, párrafos, números, tema, cabecera, ratón, formato de imagen | `~/.config/pdfterm/config` | Al pulsar la tecla |
| Guía encendida y su estilo | Las dos: por libro en `~/.local/share/pdfterm/` y como valor por defecto en el config | Al pulsar `l` o `L` |
| Cabeceras y pies detectados | `~/.local/share/pdfterm/` | La primera vez que abres cada libro |
| Texto completo para buscar | `~/.local/share/pdfterm/` | La primera vez que buscas en ese libro |
| Páginas con ilustración | `~/.local/share/pdfterm/` | La primera vez que pulsas `I` en ese libro |

Si las cabeceras y pies de un libro no se filtran bien, borra lo aprendido y se
vuelven a detectar:

    rm -f ~/.local/share/pdfterm/*.hdr
