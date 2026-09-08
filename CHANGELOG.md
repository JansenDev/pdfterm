# Registro de cambios

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y el proyecto usa [versionado semántico](https://semver.org/lang/es/).

## [1.4.0] - 2026-09-08

### Añadido

- Listado de las páginas que tienen ilustración, con la tecla `I`, y salto
  directo a cualquiera de ellas. Filtra por tamaño, así que no salen los logos
  ni las marcas de agua que muchos PDF repiten en todas las páginas.
- Formato de dibujo configurable (`IMG_FORMATO`) y tecla `F` para ir
  probándolos: auto, sixels, kitty, iterm, symbols.
- Resolución de extracción configurable (`IMG_DPI`), por defecto 200.
- La tecla `i` dibuja la página a pantalla completa.

### Corregido

- Las ilustraciones se dibujaban a menos de la mitad de su tamaño posible.
  `chafa` supone celdas de 8x8 px porque ConPTY no informa del tamaño real;
  ahora se le pregunta al terminal con `CSI 16 t` y el área se calcula en
  píxeles reales. En una ventana con celdas de 10x20 px, la imagen pasa de 176
  a 840 píxeles de alto.
- Franja negra al lado de las ilustraciones: el área que se le daba a `chafa`
  era más ancha que la imagen y rellenaba el resto con el color de fondo.
- Las ilustraciones apaisadas salían estiradas, por el `--font-ratio` que
  `chafa` usa por defecto.
- En las páginas de ilustración, la cabecera y la barra de ayuda ocupaban seis
  filas; ahora se reducen a dos y la imagen aprovecha el resto.

## [1.3.0] - 2026-09-08

### Añadido

- Instalación en una línea con `curl`, sin clonar el repositorio. Instala las
  dependencias que falten con el gestor del sistema y añade el destino al PATH,
  sin preguntar nada.
- La guía de lectura se recuerda por libro, en el fichero de posición, y como
  valor por defecto en la configuración.
- Estilo de la guía (tecla `L`): `linea` resalta el renglón entero, `marca`
  solo el número y la flecha.
- La numeración de renglones se alterna también con `0`, además de con `#`.
- Licencia MIT.

### Corregido

- Rebote al desplazarse: la barra de ayuda ocupa dos filas en la mayoría de
  ventanas y solo se reservaba una, así que el terminal desplazaba en cada
  repintado. Ahora se calcula cuántas filas ocupa realmente.
- Al apagar y encender la guía, saltaba al primer renglón visible aunque no te
  hubieras movido. Ahora conserva el renglón si sigue a la vista.
- Con la numeración apagada, la flecha de la guía empujaba el texto y
  desalineaba el renglón marcado.
- Con la numeración apagada, la guía perdía la flecha y solo se distinguía por
  el color.
- Las páginas que son ilustraciones mostraban `renglón 1/0` en la cabecera.
- El instalador fallaba en sistemas sin `sudo`, como los contenedores.
- `tput` protestaba cuando no había `TERM` definido.

## [1.2.0] - 2026-09-08

### Añadido

- Guía de lectura: un renglón resaltado que marca por dónde vas. Se mueve con
  la rueda, con `j` y `k` o pinchando en el renglón, y la vista se desplaza
  sola para mantenerlo visible. Se apaga y enciende con `l`; apagada, la rueda
  desplaza la página entera. Cada libro se abre con la guía apagada, y lo que
  se decida dentro se mantiene mientras se pasan páginas.
- Soporte de ratón por el protocolo SGR: clic para marcar y rueda para moverse.
- La posición guardada incluye el renglón además de la página, así que al
  reabrir un libro se vuelve al punto exacto.

### Corregido

- Con la numeración de renglones apagada, la guía de lectura perdía la flecha
  y solo se distinguía por el color.

### Cambiado

- Las teclas actúan al pulsarlas, sin necesidad de Enter.
- La numeración de renglones se alterna también con `0`, además de con `#`,
  que en teclado español obliga a usar AltGr.
- La página se compone una sola vez y mover la guía solo repinta: de 86 ms a
  3 ms por pulsación.
- El repintado ya no borra la pantalla, así que desaparece el parpadeo, y el
  lector trabaja en la pantalla alternativa del terminal.

## [1.1.1] - 2026-09-07

### Revertido

- La paginación interna que introdujo la 1.1.0. Partía cada página del PDF en
  varias pantallas por las que había que ir avanzando, y eso estorbaba más de
  lo que resolvía. `Enter` vuelve a pasar directamente a la página siguiente.

## [1.1.0] - 2026-09-07

### Corregido

- El texto empezaba por la mitad cuando la página no cabía entera en la
  pantalla: al imprimirla de una vez, el terminal desplazaba solo y dejaba
  el principio fuera de vista. Ahora el programa pagina por su cuenta y
  nunca imprime más líneas de las que caben.

### Añadido

- Desplazamiento dentro de la página: `Enter` avanza una pantalla y salta a
  la página siguiente al llegar al final, `b` retrocede una pantalla y `g`
  vuelve al principio de la página.
- Indicador de pantalla actual en la cabecera cuando la página ocupa más de
  una (`pantalla 2/3`).

### Cambiado

- Cambiar de página, saltar a una página concreta o modificar cualquier
  ajuste de formato devuelve la vista al principio de la página.

## [1.0.0] - 2026-09-07

Primera versión.

### Añadido

- Lectura de PDF página a página en la terminal.
- Detección automática de cabeceras y pies repetidos, aprendida por documento.
- Reflow de párrafos a una columna centrada de ancho configurable.
- Interlineado y separación entre párrafos independientes.
- Numeración de renglones en el margen izquierdo.
- Cuatro estilos de cabecera: completa, compacta, mínima y oculta.
- Temas de color: suave, sepia, normal y uno propio con colores a elegir.
- Renderizado de las páginas ilustradas con `chafa`.
- Búsqueda de texto en todo el documento, con lista de páginas coincidentes.
- Memoria de la última página leída, por libro.
- Configuración comentada en `~/.config/pdfterm/config`, editable a mano o con
  teclas dentro del lector, y accesible con `pdfterm --config`.
- Instalador para apt, dnf, pacman, zypper y brew.
- Paquete `.deb` con las dependencias declaradas.
