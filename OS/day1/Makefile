
# 默认动作

default :
	../tools/make.exe boot

# 镜像文件生成
boot.bin : day1.asm Makefile
	../tools/nasm/nasm.exe day1.asm -o boot.bin

# 其他指令
boot:
	../tools/make.exe -r boot.bin


