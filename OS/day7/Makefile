# 默认动作
TOOL_PATH  = ../tools/
ASSEMBLE   = ../tools/nasm/


MAKE       = $(TOOL_PATH)make.exe -r
NASM       = $(ASSEMBLE)nasm.exe
DD         = $(TOOL_PATH)dd.exe
DEL        = del
COPY       = copy


default :
	$(MAKE) mbr
	$(MAKE) loader
	$(MAKE) pm

# 镜像文件生成

loader.bin: loader.asm Makefile
	$(NASM) loader.asm -o loader.bin

mbr.bin: day2.asm Makefile
	$(NASM) day2.asm -o mbr.bin

pm.bin:pm.asm Makefile
	$(NASM) pm.asm -o pm.bin

# 其他指令

loader:
	$(MAKE) loader.bin

pm:
	$(MAKE) pm.bin

mbr:
	$(MAKE) mbr.bin

clean:
	-$(DEL) loader.bin
	-$(DEL) mbr.bin
	-$(DEL) pm.bin
	

add:
	$(DD) if=mbr.bin of=dingst.vhd bs=512 count=1
	$(DD) if=loader.bin of=dingst.vhd bs=512 count=1 seek=2
	$(DD) if=osKernel.bin of=dingst.vhd bs=512 count=100 seek=9
	$(DD) if=pm.bin of=dingst.vhd bs=512 count=100 seek=20
	
backup:
	-$(DEL) dingst.vhd
	$(COPY) ..\Backup\dingst(empty).vhd  dingst.vhd

run:
	-$(DEL) ..\dingst.vhd
	$(COPY) dingst.vhd ..\dingst.vhd

all:
	$(MAKE) backup
	$(MAKE) clean
	$(MAKE) mbr
	$(MAKE) loader
	$(MAKE) pm
	$(MAKE) add
	$(MAKE) run