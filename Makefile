# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

SRC = art.c x.c
OBJ = $(SRC:.c=.o)

all: options st

options:
	@echo st build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $<

art.o: config.h art.h win.h
x.o: arg.h config.h art.h win.h

$(OBJ): config.h config.mk

art: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f art $(OBJ) art-$(VERSION).tar.gz

dist: clean
	mkdir -p art-$(VERSION)
	cp -R FAQ LEGACY TODO LICENSE Makefile README config.mk\
		config.def.h art.info art.1 arg.h art.h win.h $(SRC)\
		art-$(VERSION)
	tar -cf - art-$(VERSION) | gzip > art-$(VERSION).tar.gz
	rm -rf art-$(VERSION)

install: art
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f art $(DESTDIR)$(PREFIX)/bin
	cp -f art-copyout $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/art
	chmod 755 $(DESTDIR)$(PREFIX)/bin/art-copyout
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < art.1 > $(DESTDIR)$(MANPREFIX)/man1/art.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/art.1
	tic -sx art.info
	@echo Please see the README file regarding the terminfo entry of art.

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/art
	rm -f $(DESTDIR)$(PREFIX)/bin/art-copyout
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st.1

.PHONY: all options clean dist install uninstall
