# Registro de cambios

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y el proyecto usa [versionado semántico](https://semver.org/lang/es/).

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
