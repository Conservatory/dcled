# This file is part of dcled, written on Sun Jan  4 00:18:16 PST 2009
# Jeff Jahr <malakai@jeffrika.com> -jsj 

# What goes into the archive?
DISTFILES= dcled.c cpuload.c makefile README README-MACOS 40-dcled.rules

# INSTALLDIR is where the binaries get installed
INSTALLDIR=/usr/local/bin
FONTDIR="/usr/local/share/dcled"
DCLEDVERSION="2.2"
DIST=dcled-$(DCLEDVERSION)
LIBUSB_CFLAGS=-I/usr/include/libusb-1.0
LIBUSB_LIBS=-lusb-1.0

# If gcc isnt your compiler, change it here.
 
CC=gcc

CFLAGS= -g -O3 -Wunused-variable -DFONTDIR='$(FONTDIR)' -DDCLEDVERSION='$(DCLEDVERSION)' ${LIBUSB_CFLAGS}
LDFLAGS= -g -lm ${LIBUSB_LIBS}
 
# You probaby dont need to change anything below this line...
 
# List of the various files
CFILES= dcled.c cpuload.c
HFILES= 
OFILES= dcled.o cpuload.o

# build everything
all:	dcled cpuload

dcled: dcled.o
	$(CC) dcled.o -o dcled $(LDFLAGS)

cpuload: cpuload.o
	$(CC) cpuload.o -o cpuload $(LDFLAGS)

# rebuild the ctags
ctags: $(HFILES) $(CFILES)
	ctags -d -I -l c -t $(HFILES) $(CFILES)

# remove the object files
clean:	
	rm -i $(OFILES) dcled

# copy stuff into the install directory
install:
	mkdir -p $(FONTDIR)
	cp fonts/*.dlf $(FONTDIR)
	mkdir -p $(INSTALLDIR)
	cp dcled $(INSTALLDIR)
	#
	# Now run 'make udev' if you want to install the device permissions.
	#

udev:
	cp 40-dcled.rules /lib/udev/rules.d
	service udev restart
	# Done!

dist:
	mkdir ${DIST}
	cp ${DISTFILES} ${DIST}
	cp -r fonts ${DIST}
	tar -cvzf ${DIST}.tgz ${DIST}

# ...and now the dependencies. 
dcled.o : dcled.c
	$(CC) -c $(CFLAGS) dcled.c

cpuload.o : cpuload.c
	$(CC) -c $(CFLAGS) cpuload.c

# Still reading?  Then the problem probably isnt with this file. ;) -jsj
