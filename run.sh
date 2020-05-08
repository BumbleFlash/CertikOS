#!/bin/bash
cd boot/boot0
gcc -MD -fno-builtin -nostdinc -fno-stack-protector -Os -g -m32 -I. -c -o boot0.o boot0.S
ld -nostdlib -m elf_i386 -N -e start -Ttext 0x7c00 -o boot0.elf boot0.o
objcopy -S -O binary boot0.elf boot0
cd ..
cd boot1
gcc -MD -fno-builtin -nostdinc -fno-stack-protector -Os -g -m32 -I. -c -o boot1.o boot1.S
gcc -MD -fno-builtin -nostdinc -fno-stack-protector -Os -g -m32 -I. -c -o boot1main.o boot1main.c
gcc -MD -fno-builtin -nostdinc -fno-stack-protector -Os -g -m32 -I. -c -o boot1lib.o boot1lib.c
gcc -MD -fno-builtin -nostdinc -fno-stack-protector -Os -g -m32 -I. -c -o exec_kernel.o exec_kernel.S
ld -nostdlib -m elf_i386 -N -e start -Ttext 0x7e00 -o boot1.elf boot1.o boot1main.o boot1lib.o exec_kernel.o
objcopy -S -O binary boot1.elf boot1
cd ..
cd ..
cd kern/init
gcc -MD -fno-builtin -nostdinc -fno-stack-protector -D_KERN_ -Ikern -Ikern/kern -I. -m32 -O0 -c -o entry.o entry.S 
ld -o kernel -nostdlib -e start -m elf_i386 -Ttext=0x00100000 entry.o -b binary

cd ..
cd .. 
dd if=/dev/zero of=project0.img bs=512 count=256
parted -s project0.img "mktable msdos mkpart primary 63s -1s set 1 boot on"
dd if=boot/boot0/boot0 of=project0.img bs=446 count=1 conv=notrunc
dd if=boot/boot1/boot1 of=project0.img bs=512 count=62 seek=1 conv=notrunc
dd if=kern/init/kernel of=project0.img bs=512 seek=63 conv=notrunc

qemu-system-i386 -smp 1 -hda project0.img -serial mon:stdio -m 512 -k en-us
