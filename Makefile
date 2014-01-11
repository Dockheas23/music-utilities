PACKAGE = music-utilities
VERSION = 1.1
ARTIFACT = $(PACKAGE)-$(VERSION)
TARBALL = $(ARTIFACT).tar.gz
PREFIX = /usr
BINDIR = $(DESTDIR)$(PREFIX)/bin/

default:

clean:
	rm -rf $(ARTIFACT) $(TARBALL)

install:
	install -d $(BINDIR)
	install -m 755 -t $(BINDIR) scripts/*

tarball:
	mkdir -p $(ARTIFACT)
	rsync -a scripts $(ARTIFACT)
	tar -zcf $(TARBALL) $(ARTIFACT)
	rm -r $(ARTIFACT)
