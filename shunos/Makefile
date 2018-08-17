TOOLPATH	= ../z_tools/
INCPATH		= ../z_tools/haribote/

NASK		= $(TOOLPATH)nask
CC1			= $(TOOLPATH)gocc1 -I$(INCPATH) -Os -Wall -quiet
GAS2NASK	= $(TOOLPATH)gas2nask -a
OBJ2BIM		= $(TOOLPATH)obj2bim
BIM2HRB		= $(TOOLPATH)bim2hrb
RULEFILE	= $(INCPATH)haribote.rul
EDIMG		= $(TOOLPATH)edimg
IMGTOL		= $(TOOLPATH)imgtol.com
QEMU		= qemu-system-i386 -fda
CP			= cp -r
RM			= rm -r

ipl.bin: ipl.nas
	$(NASK) ipl.nas ipl.bin ipl.lst

shun.bin: shun.nas
	$(NASK) shun.nas shun.bin shun.lst

bootpack.gas: bootpack.c
	$(CC1) -o bootpack.gas bootpack.c

bootpack.nas: bootpack.gas
	$(GAS2NASK) bootpack.gas bootpack.nas

bootpack.obj: bootpack.nas
	$(NASK) bootpack.nas bootpack.obj bootpack.lst

naskfunc.obj: naskfunc.nas
	$(NASK) naskfunc.nas naskfunc.obj naskfunc.lst

bootpack.bim: bootpack.obj naskfunc.obj
	$(OBJ2BIM) @$(RULEFILE) out:bootpack.bim stack:3136k \
		map:bootpack.map bootpack.obj naskfunc.obj

bootpack.hrb: bootpack.bim
	$(BIM2HRB) bootpack.bim bootpack.hrb 0

shun.sys: shun.bin bootpack.hrb
	cat shun.bin bootpack.hrb > shun.sys

shunos.img: ipl.bin shun.sys
	$(EDIMG) imgin:$(TOOLPATH)/fdimg0at.tek \
		wbinimg src:ipl.bin len:512 from:0 to:0 \
		copy from:shun.sys to:@: \
		imgout:shunos.img

img: shunos.img

run: shunos.img
	$(QEMU) shunos.img

clean:
	-$(RM) bootpack.nas *.img *.sys *.bin *.lst *.hrb *.bim *.obj *.gas *.map

