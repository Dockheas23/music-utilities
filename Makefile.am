dist_bin_SCRIPTS = scripts/cddb_fetch.pl scripts/importcd \
		   scripts/listflactags scripts/quickInfo.py \
		   scripts/refreshflactags scripts/setflactags.py \
		   scripts/setoggtags.py scripts/stripflactags \
		   scripts/syncoggs scripts/tracknames.py
EXTRA_DIST = package

targetdir = target
artifactdir = $(targetdir)/$(distdir)
sourcerepodir = $(DEV_SERVER):/var/www/repo/source/
archrepodir = $(DEV_SERVER):/var/www/repo/arch
debianrepodir = $(DEV_SERVER):/var/www/repo/debian/incoming

DEV_SERVER = george@dev.darknugget.com
ARCH_TARBALL = $(distdir)-arch.tar.gz
DEB_FILE = $(targetdir)/$(PACKAGE_TARNAME)_$(PACKAGE_VERSION)-1_all.deb

deploy-source: dist
	$(RSYNC) $(DIST_ARCHIVES) $(sourcerepodir)

deploy-arch: dist-arch deploy
	$(RSYNC) $(ARCH_TARBALL) $(archrepodir)

deploy-debian: dist-debian
	$(RSYNC) $(builddir)/*.deb $(debianrepodir)
	debarchiver -o --autoscanall

dist-arch: $(ARCH_TARBALL)

dist-debian: $(DEB_FILE)

$(ARCH_TARBALL): dist
	$(INSTALL) -d $(artifactdir)
	cp package/arch/PKGBUILD $(artifactdir)
	sed -i "2a \
	    md5sums('$(shell $(MD5_PROGRAM) $(DIST_ARCHIVES) | \
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
