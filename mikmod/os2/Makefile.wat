# Makefile for OS/2 using Watcom compiler.
#
# wmake -f Makefile.wat

CC=wcc386
!ifndef __UNIX__
INCLUDES=-I..\os2 -I..\src
!else
INCLUDES=-I../os2 -I../src
!endif
CPPFLAGS=-DHAVE_FCNTL_H -DHAVE_LIMITS_H -DHAVE_SYS_IOCTL_H -DHAVE_SYS_TIME_H -DHAVE_STRERROR -DHAVE_SNPRINTF
# for an exe using mikmod.dll: link to mikmod.lib
# for a statically linked exe: link to mikmod_static.lib which, in turn, requires mmpm2.lib
LIBS=mikmod.lib
#LIBS=mikmod_static.lib mmpm2.lib
CFLAGS = -bt=os2 -bm -fp5 -fpi87 -mf -oeatxh -w4 -zp8 -ei -q
# -5s  :  Pentium stack calling conventions.
# -5r  :  Pentium register calling conventions.
CFLAGS+= -5s

.SUFFIXES:
.SUFFIXES: .obj .c

AOUT=mikmod.exe
COMPILE=$(CC) $(CFLAGS) $(CPPFLAGS) $(INCLUDES)

OBJ = display.obj marchive.obj mconfedit.obj mconfig.obj mdialog.obj mikmod.obj mlist.obj mlistedit.obj &
      mmenu.obj mplayer.obj mutilities.obj mwidget.obj mwindow.obj rcfile.obj
EXTRA_OBJ = mgetopt.obj mgetopt1.obj mfnmatch.obj

all: $(AOUT)

$(AOUT): $(OBJ) $(EXTRA_OBJ)
	wlink N $(AOUT) SYS OS2V2 LIBR {$(LIBS)} F {$(OBJ)} F {$(EXTRA_OBJ)}

.c.obj:
	$(COMPILE) -fo=$^@ $<

!ifndef __UNIX__
.c: ..\src
distclean: clean .symbolic
	@if exist $(AOUT) del $(AOUT)
clean: .symbolic
	@if exist *.obj del *.obj
!else
.c: ../src
distclean: clean .symbolic
	rm -f $(AOUT)
clean: .symbolic
	rm -f *.obj
!endif
