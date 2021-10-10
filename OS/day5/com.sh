# !/bin/bash
rm -rf temp;
mkdir temp;
chmod 777 temp;

nasm -f elf32 osKernel.asm -o ./temp/osKernel.o;
nasm -f elf32 liba.asm -o ./temp/liba.o;

gcc -c -m16 -march=i386 -masm=intel -nostdlib -ffreestanding -mpreferred-stack-boundary=2 -lgcc -shared libc.c -o ./temp/libc.o;

chmod 777 ./temp/osKernel.o;
chmod 777 ./temp/liba.o;
chmod 777 ./temp/libc.o;

ld -m elf_i386 -N -Ttext  0x8000 --oformat binary  ./temp/osKernel.o  ./temp/liba.o  ./temp/libc.o  -o  temp/osKernel.bin;

echo "have Dome!"

