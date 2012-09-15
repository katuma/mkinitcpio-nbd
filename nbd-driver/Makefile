V=1
KVER:=$(shell uname -r)
DESTDIR:=/
MDIR=$(DESTDIR)/lib/modules/$(KVER)
KDIR=$(DESTDIR)/$(shell readlink $(MDIR)/build)
obj-m := nbd.o
PWD=$(shell pwd)
nbd.c:
	cp -f $(KDIR)/drivers/block/nbd.c $(KDIR)/include/linux/nbd.h .
	patch < nbd.patch
	sed -i 's#<linux/nbd\.h>#"nbd.h"#g' nbd.c
install: modules
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules_install INSTALL_MOD_PATH=$(DESTDIR)
modules: nbd.c
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules || rm -f *.[ch]*
	rm -f *.[ch]*
clean:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) clean
	rm -f *.[ch]
