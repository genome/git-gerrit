DESTDIR ?= /usr/local
INSTALL ?= install

all: install

install:
	test -d $(DESTDIR)     || mkdir $(DESTDIR)
	test -d $(DESTDIR)/bin || mkdir $(DESTDIR)/bin
	$(INSTALL) git-gerrit            $(DESTDIR)/bin/git-gerrit
	$(INSTALL) git-gerrit-init       $(DESTDIR)/bin/git-gerrit-init
	$(INSTALL) git-gerrit-change-ids $(DESTDIR)/bin/git-gerrit-change-ids

uninstall:
	rm $(DESTDIR)/bin/git-gerrit
	rm $(DESTDIR)/bin/git-gerrit-init
	rm $(DESTDIR)/bin/git-gerrit-change-ids
	test -d $(DESTDIR)/bin && rmdir $(DESTDIR)/bin || true
	test -d $(DESTDIR) && rmdir $(DESTDIR) || true

test:
	prove -r -I t/lib
