dist_bin_SCRIPTS ::= \
    $(srcdir)/scripts/cddb_fetch.pl \
    $(srcdir)/scripts/importcd \
    $(srcdir)/scripts/listflactags \
    $(srcdir)/scripts/quickInfo.py \
    $(srcdir)/scripts/refreshflactags \
    $(srcdir)/scripts/setflactags.py \
    $(srcdir)/scripts/setoggtags.py \
    $(srcdir)/scripts/stripflactags \
    $(srcdir)/scripts/syncoggs \
    $(srcdir)/scripts/tracknames.py

EXTRA_DIST ::= $(srcdir)/package

DEV_SERVER ::= george@dev.darknugget.com

targetdir ::= target
artifactdir ::= $(targetdir)/$(distdir)
sourcerepodir ::= $(DEV_SERVER):/var/www/repo/source
archrepodir ::= $(DEV_SERVER):/var/www/repo/arch
debianrepodir ::= $(DEV_SERVER):/var/www/repo/debian/incoming

ARCH_TARBALL ::= $(distdir)-arch.tar.gz
DEB_FILE ::= $(targetdir)/$(PACKAGE_TARNAME)_$(PACKAGE_VERSION)-1_all.deb

deploy-source: dist
	$(RSYNC) $(DIST_ARCHIVES) $(sourcerepodir)

deploy-arch: dist-arch
	$(RSYNC) $(ARCH_TARBALL) $(archrepodir)

deploy-debian: dist-debian
	$(RSYNC) $(targetdir)/*.{deb,dsc,gz,changes} $(debianrepodir)
	debarchiver -o --autoscanall

dist-arch: $(ARCH_TARBALL)

dist-debian: $(DEB_FILE)

$(ARCH_TARBALL): dist
	$(INSTALL) -d $(artifactdir)
	cp package/arch/PKGBUILD $(artifactdir)
	sed -i "2a \
	    md5sums=('$(shell $(MD5_PROGRAM) $(DIST_ARCHIVES) | \
	    awk '{print $$1}')')" $(artifactdir)/PKGBUILD
	sed -i "2a \
	    pkgver=$(PACKAGE_VERSION)" $(artifactdir)/PKGBUILD
	tar -zcf $@ -C $(targetdir) $(distdir)
	rm -rf $(artifactdir)

$(DEB_FILE): dist
	$(INSTALL) -d $(targetdir)
	tar -xf $(DIST_ARCHIVES) -C $(targetdir)
	cp -r package/debian $(targetdir)/$(distdir)
	cd $(targetdir)/$(distdir) && dpkg-buildpackage

clean-local:
	rm -rf $(targetdir)
