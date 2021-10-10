
# 默认动作
TOOL_PATH = ../tools/
ASSEMBLE  = ../tools/nasm/

MAKE      = $(TOOL_PATH)make.exe -r
NASM      = $(ASSEMBLE)nasm.exe
DD        = $(TOOL_PATH)dd.exe
DEL       = del
COPY      = copy

default :
	$(MAKE) mdr
	$(MAKE) loader

# 镜像文件生成
mdr.bin : day2.asm Makefile
	$(NASM) day2.asm -o mdr.bin

loader.bin : loader.asm Makefile
	$(NASM) loader.asm -o loader.bin
# 其他指令
mdr:
	$(MAKE) mdr.bin

loader:
	$(MAKE) loader.bin

clean:
	-$(DEL) *.bin

add:
	$(DD) if=mdr.bin of=dingst.vhd bs=512 count=1
	$(DD) if=loader.bin of=dingst.vhd bs=512 count=1 seek=2

backup:
	-$(DEL) dingst.vhd
	$(COPY) ..\Backup\dingst(empty).vhd  dingst.vhd

run:
	-$(DEL) ..\dingst.vhd
	$(COPY) dingst.vhd ..\dingst.vhd