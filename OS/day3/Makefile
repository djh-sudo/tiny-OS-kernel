
# 默认动作
TOOL_PATH = ../tools/
ASSEMBLE  = ../tools/nasm/

MAKE      = $(TOOL_PATH)make.exe -r
NASM      = $(ASSEMBLE)nasm.exe
DD        = $(TOOL_PATH)dd.exe
DEL       = del
COPY      = copy

default :
	$(MAKE) mbr
	$(MAKE) kernel
	$(MAKE) loader

# 镜像文件生成
kernel.bin : day3.asm Makefile
	$(NASM) day3.asm -o kernel.bin

loader.bin: loader.asm Makefile
	$(NASM) loader.asm -o loader.bin

mbr.bin : day2.asm Makefile
	$(NASM) day2.asm -o mbr.bin


# 其他指令
kernel:
	$(MAKE) kernel.bin

loader:
	$(MAKE) loader.bin

mbr:
	$(MAKE) mbr.bin

clean:
	-$(DEL) *.bin

add:
	$(DD) if=mbr.bin of=dingst.vhd bs=512 count=1
	$(DD) if=loader.bin of=dingst.vhd bs=512 count=1 seek=2
	$(DD) if=kernel.bin of=dingst.vhd bs=512 count=1 seek=9

backup:
	-$(DEL) dingst.vhd
	$(COPY) ..\Backup\dingst(empty).vhd  dingst.vhd

run:
	-$(DEL) ..\dingst.vhd
	$(COPY) dingst.vhd ..\dingst.vhd
