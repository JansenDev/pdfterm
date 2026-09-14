PREFIX ?= $(HOME)/.local
VERSION = $(shell cat VERSION)

.PHONY: install uninstall deb clean version

install:
	install -d $(PREFIX)/bin
	install -m 755 pdfterm $(PREFIX)/bin/pdfterm
	@echo "Instalado en $(PREFIX)/bin/pdfterm"

uninstall:
	rm -f $(PREFIX)/bin/pdfterm

version:
	sed -i "s/^VERSION_PDFTERM=.*/VERSION_PDFTERM=$(VERSION)/" pdfterm

deb: version
	install -m 755 pdfterm debian/usr/bin/pdfterm
	sed -i "s/^Version: .*/Version: $(VERSION)/" debian/DEBIAN/control
	dpkg-deb --root-owner-group --build debian pdfterm_$(VERSION)_all.deb
	@echo "Paquete generado: pdfterm_$(VERSION)_all.deb"

clean:
	rm -f pdfterm_*.deb debian/usr/bin/pdfterm
