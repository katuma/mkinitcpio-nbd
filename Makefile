VERSION	  = $(shell git describe)
DISTFILES = Makefile nbd_install nbd_hook omit_kill_nbd nbd-client nbd-driver
DESTDIR:=/

nbd-client/nbd-client:
	make -C nbd-client DESTDIR=${DESTDIR}

install: nbd-client/nbd-client
	install -m 755 -D nbd-client/nbd-client ${DESTDIR}/usr/lib/initcpio/nbd-client
	install -m 644 -D nbd_depmod ${DESTDIR}/etc/depmod.d/nbd.conf
	install -m 644 -D nbd_install ${DESTDIR}/usr/lib/initcpio/install/nbd
	install -m 644 -D nbd_hook ${DESTDIR}/usr/lib/initcpio/hooks/nbd
	install -m 644 -D omit_kill_nbd ${DESTDIR}/etc/rc.d/functions.d/omit_kill_nbd
	make -C nbd-driver install DESTDIR=${DESTDIR}
	depmod -A -C ${DESTDIR}/etc/depmod.d -b ${DESTDIR}

uninstall:
	rm -f ${DESTDIR}/etc/depmod.d/nbd.conf
	rm -f ${DESTDIR}/usr/lib/initcpio/nbd-client
	rm -f ${DESTDIR}/usr/lib/initcpio/install/nbd
	rm -f ${DESTDIR}/usr/lib/initcpio/hooks/nbd
	rm -f ${DESTDIR}/etc/rc.d/functions.d/omit_kill_nbd
	rm -f ${DESTDIR}/lib/modules/`uname -r`/extra/nbd.ko
	depmod -A -C ${DESTDIR}/etc/depmod.d -b ${DESTDIR}

dist:
	make -C nbd-client clean DESTDIR=$(DESTDIR)
	make -C nbd-driver clean DESTDIR=$(DESTDIR)
	mkdir mkinitcpio-nbd-${VERSION}
	cp -a ${DISTFILES} mkinitcpio-nbd-${VERSION}
	tar cvzf mkinitcpio-nbd-${VERSION}.tar.gz mkinitcpio-nbd-${VERSION}
	rm -rf mkinitcpio-nbd-${VERSION}
