PREFIX ?= $(HOME)/.local
VERSION = 1.0.0

.PHONY: install uninstall deb clean

install:
	install -d $(PREFIX)/bin
	install -m 755 pdfterm $(PREFIX)/bin/pdfterm
	@echo "Instalado en $(PREFIX)/bin/pdfterm"

uninstall:
	rm -f $(PREFIX)/bin/pdfterm

deb:
	install -m 755 pdfterm debian/usr/bin/pdfterm
	dpkg-deb --root-owner-group --build debian pdfterm_$(VERSION)_all.deb
	@echo "Paquete generado: pdfterm_$(VERSION)_all.deb"

clean:
	rm -f pdfterm_*.deb debian/usr/bin/pdfterm
