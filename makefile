# This file is part of dcled, written on Sun Jan  4 00:18:16 PST 2009
# Jeff Jahr <malakais@pacbell.net> -jsj 
 
# INSTALLDIR is where the binaries get installed
 
INSTALLDIR=/usr/local/bin
 
# If gcc isnt your compiler, change it here.
 
CC=gcc

CFLAGS= -g -O3 
LDFLAGS= -g -lm -lhid
 
# You probaby dont need to change anything below this line...
 
# List of the various files
CFILES= dcled.c
HFILES= 
OFILES= dcled.o

# build everything
all:	dcled

dcled: dcled.o

# rebuild the ctags
ctags: $(HFILES) $(CFILES)
	ctags -d -I -l c -t $(HFILES) $(CFILES)

# remove the object files
clean:	
	rm -i $(OFILES) dcled

# copy stuff into the install directory
install:
	mkdir -p $(INSTALLDIR)
	cp dcled $(INSTALLDIR)

dist:
	tar -cvzf dcled.tgz dcled.c makefile README

# ...and now the dependencies. 
dcled.o : dcled.c
	$(CC) -c $(CFLAGS) dcled.c

# Still reading?  Then the problem probably isnt with this file. ;) -jsj
