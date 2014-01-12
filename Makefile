prefix = /usr/local
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin
builddir = target
artifactdir = $(builddir)/$(ARTIFACT)
sourcerepodir = $(DEV_SERVER):/var/www/source/$(PACKAGE_TARNAME)
archrepodir = $(DEV_SERVER):/var/www/repo/arch
debianrepodir = $(DEV_SERVER):/var/www/repo/debian/incoming

MD5_PROGRAM = md5sum
INSTALL = /usr/bin/install -c
INSTALL_DIRECTORY = $(INSTALL) -d
INSTALL_SCRIPT = ${INSTALL}
RSYNC = /usr/bin/rsync

DEV_SERVER = george@dev.darknugget.com
PACKAGE_NAME = Music-Utilities
PACKAGE_TARNAME = music-utilities
PACKAGE_VERSION = 1.1
ARTIFACT = $(PACKAGE_TARNAME)-$(PACKAGE_VERSION)
INSTALL_FILES = scripts/*
TAR_FILES = scripts configure Makefile.in README
TARBALL = $(builddir)/$(ARTIFACT).tar.gz
ARCH_TARBALL = $(builddir)/$(ARTIFACT)-arch.tar.gz
DEB_FILE = $(builddir)/$(PACKAGE_TARNAME)_$(PACKAGE_VERSION)-1_all.deb

default:

tarball: $(TARBALL)

deploy: $(TARBALL)
	$(RSYNC) $(TARBALL) $(sourcerepodir)

arch: $(ARCH_TARBALL)

arch-deploy: arch deploy
	$(RSYNC) $(ARCH_TARBALL) $(archrepodir)

debian: $(DEB_FILE)

debian-deploy: debian
	$(RSYNC) $(builddir)/*.deb $(debianrepodir)
	debarchiver -o --autoscanall

$(TARBALL):
	$(INSTALL_DIRECTORY) $(builddir)
	$(INSTALL_DIRECTORY) $(artifactdir)
	cp -r $(TAR_FILES) $(artifactdir)
	tar -zcf $@ -C $(builddir) $(ARTIFACT)
	rm -rf $(artifactdir)

$(ARCH_TARBALL): $(TARBALL)
	$(INSTALL_DIRECTORY) $(artifactdir)
	cp package/arch/PKGBUILD $(artifactdir)
	set MD5_SUM = $(shell $(MD5_PROGRAM) $< | awk '{print $$1}')
	sed -i "2a \
	    md5sums('$(shell $(MD5_PROGRAM) $< | \
	    awk '{print $$1}')')" $(artifactdir)/PKGBUILD
	sed -i "2a \
	    pkgver=$(PACKAGE_VERSION)" $(artifactdir)/PKGBUILD
	tar -zcf $@ -C $(builddir) $(ARTIFACT)
	rm -rf $(artifactdir)

$(DEB_FILE): $(TARBALL)
	tar -xf $(TARBALL) -C $(builddir)
	cp -r package/debian $(builddir)/$(ARTIFACT)
	cd $(builddir)/$(ARTIFACT) && dpkg-buildpackage

install:
	$(INSTALL_DIRECTORY) $(DESTDIR)$(bindir)
	$(INSTALL_SCRIPT) $(INSTALL_FILES) $(DESTDIR)$(bindir)

clean:
	rm -rf $(builddir)
