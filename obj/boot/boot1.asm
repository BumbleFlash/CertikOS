
obj/boot/boot1.elf:     file format elf32-i386


Disassembly of section .text:

00007e00 <start>:
    .globl start
 start:
    /* assemble the following instructions in 16-bit mode */
    .code16

    cli
    7e00:	fa                   	cli    
    cld
    7e01:	fc                   	cld    
    *   YOUR 16-bit CODE
    ***************************************************************************/

    /* TODO: PRINT STARTUP MESSAGE HERE */

     movw $STARTUP_MSG, %si     //loading to the source register for the lodsb to load from
    7e02:	be ab 7e 66 31       	mov    $0x31667eab,%esi
     xorl %eax,%eax
    7e07:	c0                   	(bad)  
     movb $0xe, %ah
    7e08:	b4 0e                	mov    $0xe,%ah
     call print_string
    7e0a:	e8 94 00 e4 64       	call   64e47ea3 <SMAP_SIG+0x11973d53>

00007e0d <seta20.1>:
    /* enable A20
     * This is done because of a quirk in the x86 architecture.
     * See http://wiki.osdev.org/A20 for more information.
     */
seta20.1:
    inb    $0x64, %al
    7e0d:	e4 64                	in     $0x64,%al
    testb    $0x2, %al
    7e0f:	a8 02                	test   $0x2,%al
    jnz    seta20.1
    7e11:	75 fa                	jne    7e0d <seta20.1>
    movb    $0xd1, %al
    7e13:	b0 d1                	mov    $0xd1,%al
    outb    %al, $0x64
    7e15:	e6 64                	out    %al,$0x64

00007e17 <seta20.2>:
seta20.2:
    inb    $0x64, %al
    7e17:	e4 64                	in     $0x64,%al
    testb    $0x2, %al
    7e19:	a8 02                	test   $0x2,%al
    jnz    seta20.2
    7e1b:	75 fa                	jne    7e17 <seta20.2>
    movb    $0xdf, %al
    7e1d:	b0 df                	mov    $0xdf,%al
    outb    %al, $0x60
    7e1f:	e6 60                	out    %al,$0x60

00007e21 <e820>:
     * memory is usable, reserved, or possibly bad.
     *
     * For more information: http://wiki.osdev.org/Detecting_Memory_(x86)
     */
e820:
    xorl    %ebx, %ebx        # ebx must be 0 when first calling e820
    7e21:	66 31 db             	xor    %bx,%bx
    movl    $SMAP_SIG, %edx   # edx must be 'SMAP' when calling e820
    7e24:	66 ba 50 41          	mov    $0x4150,%dx
    7e28:	4d                   	dec    %ebp
    7e29:	53                   	push   %ebx
    movw    $(smap+4), %di    # set the address of the output buffer
    7e2a:	bf 1a 7f 66 b9       	mov    $0xb9667f1a,%edi

00007e2d <e820.1>:
e820.1:
    movl    $20, %ecx         # set the size of the output buffer
    7e2d:	66 b9 14 00          	mov    $0x14,%cx
    7e31:	00 00                	add    %al,(%eax)
    movl    $0xe820, %eax     # set the BIOS service code
    7e33:	66 b8 20 e8          	mov    $0xe820,%ax
    7e37:	00 00                	add    %al,(%eax)
    int    $0x15              # call BIOS service e820h
    7e39:	cd 15                	int    $0x15

00007e3b <e820.2>:
e820.2:
    jc    e820.fail           # error during e820h
    7e3b:	72 24                	jb     7e61 <e820.fail>
    cmpl    $SMAP_SIG, %eax   # check eax, which should be 'SMAP'
    7e3d:	66 3d 50 41          	cmp    $0x4150,%ax
    7e41:	4d                   	dec    %ebp
    7e42:	53                   	push   %ebx
    jne    e820.fail
    7e43:	75 1c                	jne    7e61 <e820.fail>

00007e45 <e820.3>:
e820.3:
    movl    $20, -4(%di)
    7e45:	66 c7 45 fc 14 00    	movw   $0x14,-0x4(%ebp)
    7e4b:	00 00                	add    %al,(%eax)
    addw    $24, %di
    7e4d:	83 c7 18             	add    $0x18,%edi
    cmpl    $0x0, %ebx        # whether it's the last descriptor
    7e50:	66 83 fb 00          	cmp    $0x0,%bx
    je    e820.4
    7e54:	74 02                	je     7e58 <e820.4>
    jmp    e820.1
    7e56:	eb d5                	jmp    7e2d <e820.1>

00007e58 <e820.4>:
e820.4:                       # zero the descriptor after the last one
    xorb    %al, %al
    7e58:	30 c0                	xor    %al,%al
    movw    $20, %cx
    7e5a:	b9 14 00 f3 aa       	mov    $0xaaf30014,%ecx
    rep    stosb
    jmp    switch_prot
    7e5f:	eb 0b                	jmp    7e6c <switch_prot>

00007e61 <e820.fail>:

     * TODO: PRINT FAILURE MESSAGE HERE
     **************************************************************************/

     /* TODO: PRINT FAILURE MESSAGE HERE */
     movw $E820_FAIL_MSG, %si     #loading to the source register for the lodsb to load from
    7e61:	be bd 7e b4 0e       	mov    $0xeb47ebd,%esi
     movb $0xe, %ah
     call print_string
    7e66:	e8 38 00 eb 00       	call   eb7ea3 <_end+0xeaebd7>

00007e6b <spin16>:


    jmp    spin16

spin16:
    hlt
    7e6b:	f4                   	hlt    

00007e6c <switch_prot>:
    /* assemble the following instructions in 32-bit mode */


    /*TODO: SETUP JUMP TO PROTECTED MODE * /
    /***************************************************************************/
     lgdt gdtdesc   #load gdt using the gdtdesc wrapper
    7e6c:	0f 01 16             	lgdtl  (%esi)
    7e6f:	10 7f 0f             	adc    %bh,0xf(%edi)
     movl %cr0, %eax  # moving value to the a general purpose register, as the control registers only support set/read from a GPR
    7e72:	20 c0                	and    %al,%al
     orl $1, %eax    #putting the value inside the GPR, the ax has 0, ah has 0 and al has 1, orl is used to retain the values in higher bits of cr0
    7e74:	66 83 c8 01          	or     $0x1,%ax
     movl %eax,%cr0      # putting the value back to cr0 and setting the PE to 1, since lower bit is 1, pe bit is 1 as well
    7e78:	0f 22 c0             	mov    %eax,%cr0

     ljmp $PROT_MODE_CSEG, $protected_mode_code
    7e7b:	ea 80 7e 08 00 66 31 	ljmp   $0x3166,$0x87e80

00007e80 <protected_mode_code>:


    .code32

     protected_mode_code:
        xorw %ax,%ax
    7e80:	66 31 c0             	xor    %ax,%ax
        movw $PROT_MODE_DSEG, %ax   # copying to ax because we cannot directly assign them ti segment registers
    7e83:	66 b8 10 00          	mov    $0x10,%ax
        movw %ax, %ds
    7e87:	8e d8                	mov    %eax,%ds
        movw %ax, %es
    7e89:	8e c0                	mov    %eax,%es
        movw %ax, %fs
    7e8b:	8e e0                	mov    %eax,%fs
        movw %ax, %gs
    7e8d:	8e e8                	mov    %eax,%gs
        movw %ax, %ss
    7e8f:	8e d0                	mov    %eax,%ss

        #transfering control to C code
        pushl $smap   #smap_sig
    7e91:	68 16 7f 00 00       	push   $0x7f16
        pushl $mbr          #mbr start address
    7e96:	68 00 7c 00 00       	push   $0x7c00
        call boot1main    #call bootmain
    7e9b:	e8 a9 0f 00 00       	call   8e49 <boot1main>

00007ea0 <spin>:


    /* It shall never reach here! */
spin:
    hlt
    7ea0:	f4                   	hlt    

00007ea1 <loop>:
/*******************************************************************************
*   DATA STRUCTURES*/

print_string:
     loop:
           lodsb
    7ea1:	ac                   	lods   %ds:(%esi),%al
           cmp $0, %al    #checks if the character is 0
    7ea2:	3c 00                	cmp    $0x0,%al
           je exitloop   # if 0, exits loop
    7ea4:	74 04                	je     7eaa <exitloop>
           int $0x10       # prints the character
    7ea6:	cd 10                	int    $0x10
           jmp loop      # jumps to starting of the loop
    7ea8:	eb f7                	jmp    7ea1 <loop>

00007eaa <exitloop>:
     exitloop:
            ret           # empty return to come out of the program
    7eaa:	c3                   	ret    

00007eab <STARTUP_MSG>:
    7eab:	53                   	push   %ebx
    7eac:	74 61                	je     7f0f <gdt+0x17>
    7eae:	72 74                	jb     7f24 <smap+0xe>
    7eb0:	20 62 6f             	and    %ah,0x6f(%edx)
    7eb3:	6f                   	outsl  %ds:(%esi),(%dx)
    7eb4:	74 31                	je     7ee7 <NO_BOOTABLE_MSG+0x8>
    7eb6:	20 2e                	and    %ch,(%esi)
    7eb8:	2e 2e 0d 0a 00 65 72 	cs cs or $0x7265000a,%eax

00007ebd <E820_FAIL_MSG>:
    7ebd:	65 72 72             	gs jb  7f32 <smap+0x1c>
    7ec0:	6f                   	outsl  %ds:(%esi),(%dx)
    7ec1:	72 20                	jb     7ee3 <NO_BOOTABLE_MSG+0x4>
    7ec3:	77 68                	ja     7f2d <smap+0x17>
    7ec5:	65 6e                	outsb  %gs:(%esi),(%dx)
    7ec7:	20 64 65 74          	and    %ah,0x74(%ebp,%eiz,2)
    7ecb:	65 63 74 69 6e       	arpl   %si,%gs:0x6e(%ecx,%ebp,2)
    7ed0:	67 20 6d 65          	and    %ch,0x65(%di)
    7ed4:	6d                   	insl   (%dx),%es:(%edi)
    7ed5:	6f                   	outsl  %ds:(%esi),(%dx)
    7ed6:	72 79                	jb     7f51 <smap+0x3b>
    7ed8:	20 6d 61             	and    %ch,0x61(%ebp)
    7edb:	70 0d                	jo     7eea <NO_BOOTABLE_MSG+0xb>
    7edd:	0a 00                	or     (%eax),%al

00007edf <NO_BOOTABLE_MSG>:
    7edf:	4e                   	dec    %esi
    7ee0:	6f                   	outsl  %ds:(%esi),(%dx)
    7ee1:	20 62 6f             	and    %ah,0x6f(%edx)
    7ee4:	6f                   	outsl  %ds:(%esi),(%dx)
    7ee5:	74 61                	je     7f48 <smap+0x32>
    7ee7:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
    7eeb:	70 61                	jo     7f4e <smap+0x38>
    7eed:	72 74                	jb     7f63 <smap+0x4d>
    7eef:	69 74 69 6f 6e 2e 0d 	imul   $0xa0d2e6e,0x6f(%ecx,%ebp,2),%esi
    7ef6:	0a 
    7ef7:	00 00                	add    %al,(%eax)

00007ef8 <gdt>:
    7ef8:	00 00                	add    %al,(%eax)
    7efa:	00 00                	add    %al,(%eax)
    7efc:	00 00                	add    %al,(%eax)
    7efe:	00 00                	add    %al,(%eax)
    7f00:	ff                   	(bad)  
    7f01:	ff 00                	incl   (%eax)
    7f03:	00 00                	add    %al,(%eax)
    7f05:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7f0c:	00 92 cf 00 27 00    	add    %dl,0x2700cf(%edx)

00007f10 <gdtdesc>:
    7f10:	27                   	daa    
    7f11:	00 f8                	add    %bh,%al
    7f13:	7e 00                	jle    7f15 <gdtdesc+0x5>
    7f15:	00 00                	add    %al,(%eax)

00007f16 <smap>:
    7f16:	00 00                	add    %al,(%eax)
    7f18:	00 00                	add    %al,(%eax)
    7f1a:	00 00                	add    %al,(%eax)
    7f1c:	00 00                	add    %al,(%eax)
    7f1e:	00 00                	add    %al,(%eax)
    7f20:	00 00                	add    %al,(%eax)
    7f22:	00 00                	add    %al,(%eax)
    7f24:	00 00                	add    %al,(%eax)
    7f26:	00 00                	add    %al,(%eax)
    7f28:	00 00                	add    %al,(%eax)
    7f2a:	00 00                	add    %al,(%eax)
    7f2c:	00 00                	add    %al,(%eax)
    7f2e:	00 00                	add    %al,(%eax)
    7f30:	00 00                	add    %al,(%eax)
    7f32:	00 00                	add    %al,(%eax)
    7f34:	00 00                	add    %al,(%eax)
    7f36:	00 00                	add    %al,(%eax)
    7f38:	00 00                	add    %al,(%eax)
    7f3a:	00 00                	add    %al,(%eax)
    7f3c:	00 00                	add    %al,(%eax)
    7f3e:	00 00                	add    %al,(%eax)
    7f40:	00 00                	add    %al,(%eax)
    7f42:	00 00                	add    %al,(%eax)
    7f44:	00 00                	add    %al,(%eax)
    7f46:	00 00                	add    %al,(%eax)
    7f48:	00 00                	add    %al,(%eax)
    7f4a:	00 00                	add    %al,(%eax)
    7f4c:	00 00                	add    %al,(%eax)
    7f4e:	00 00                	add    %al,(%eax)
    7f50:	00 00                	add    %al,(%eax)
    7f52:	00 00                	add    %al,(%eax)
    7f54:	00 00                	add    %al,(%eax)
    7f56:	00 00                	add    %al,(%eax)
    7f58:	00 00                	add    %al,(%eax)
    7f5a:	00 00                	add    %al,(%eax)
    7f5c:	00 00                	add    %al,(%eax)
    7f5e:	00 00                	add    %al,(%eax)
    7f60:	00 00                	add    %al,(%eax)
    7f62:	00 00                	add    %al,(%eax)
    7f64:	00 00                	add    %al,(%eax)
    7f66:	00 00                	add    %al,(%eax)
    7f68:	00 00                	add    %al,(%eax)
    7f6a:	00 00                	add    %al,(%eax)
    7f6c:	00 00                	add    %al,(%eax)
    7f6e:	00 00                	add    %al,(%eax)
    7f70:	00 00                	add    %al,(%eax)
    7f72:	00 00                	add    %al,(%eax)
    7f74:	00 00                	add    %al,(%eax)
    7f76:	00 00                	add    %al,(%eax)
    7f78:	00 00                	add    %al,(%eax)
    7f7a:	00 00                	add    %al,(%eax)
    7f7c:	00 00                	add    %al,(%eax)
    7f7e:	00 00                	add    %al,(%eax)
    7f80:	00 00                	add    %al,(%eax)
    7f82:	00 00                	add    %al,(%eax)
    7f84:	00 00                	add    %al,(%eax)
    7f86:	00 00                	add    %al,(%eax)
    7f88:	00 00                	add    %al,(%eax)
    7f8a:	00 00                	add    %al,(%eax)
    7f8c:	00 00                	add    %al,(%eax)
    7f8e:	00 00                	add    %al,(%eax)
    7f90:	00 00                	add    %al,(%eax)
    7f92:	00 00                	add    %al,(%eax)
    7f94:	00 00                	add    %al,(%eax)
    7f96:	00 00                	add    %al,(%eax)
    7f98:	00 00                	add    %al,(%eax)
    7f9a:	00 00                	add    %al,(%eax)
    7f9c:	00 00                	add    %al,(%eax)
    7f9e:	00 00                	add    %al,(%eax)
    7fa0:	00 00                	add    %al,(%eax)
    7fa2:	00 00                	add    %al,(%eax)
    7fa4:	00 00                	add    %al,(%eax)
    7fa6:	00 00                	add    %al,(%eax)
    7fa8:	00 00                	add    %al,(%eax)
    7faa:	00 00                	add    %al,(%eax)
    7fac:	00 00                	add    %al,(%eax)
    7fae:	00 00                	add    %al,(%eax)
    7fb0:	00 00                	add    %al,(%eax)
    7fb2:	00 00                	add    %al,(%eax)
    7fb4:	00 00                	add    %al,(%eax)
    7fb6:	00 00                	add    %al,(%eax)
    7fb8:	00 00                	add    %al,(%eax)
    7fba:	00 00                	add    %al,(%eax)
    7fbc:	00 00                	add    %al,(%eax)
    7fbe:	00 00                	add    %al,(%eax)
    7fc0:	00 00                	add    %al,(%eax)
    7fc2:	00 00                	add    %al,(%eax)
    7fc4:	00 00                	add    %al,(%eax)
    7fc6:	00 00                	add    %al,(%eax)
    7fc8:	00 00                	add    %al,(%eax)
    7fca:	00 00                	add    %al,(%eax)
    7fcc:	00 00                	add    %al,(%eax)
    7fce:	00 00                	add    %al,(%eax)
    7fd0:	00 00                	add    %al,(%eax)
    7fd2:	00 00                	add    %al,(%eax)
    7fd4:	00 00                	add    %al,(%eax)
    7fd6:	00 00                	add    %al,(%eax)
    7fd8:	00 00                	add    %al,(%eax)
    7fda:	00 00                	add    %al,(%eax)
    7fdc:	00 00                	add    %al,(%eax)
    7fde:	00 00                	add    %al,(%eax)
    7fe0:	00 00                	add    %al,(%eax)
    7fe2:	00 00                	add    %al,(%eax)
    7fe4:	00 00                	add    %al,(%eax)
    7fe6:	00 00                	add    %al,(%eax)
    7fe8:	00 00                	add    %al,(%eax)
    7fea:	00 00                	add    %al,(%eax)
    7fec:	00 00                	add    %al,(%eax)
    7fee:	00 00                	add    %al,(%eax)
    7ff0:	00 00                	add    %al,(%eax)
    7ff2:	00 00                	add    %al,(%eax)
    7ff4:	00 00                	add    %al,(%eax)
    7ff6:	00 00                	add    %al,(%eax)
    7ff8:	00 00                	add    %al,(%eax)
    7ffa:	00 00                	add    %al,(%eax)
    7ffc:	00 00                	add    %al,(%eax)
    7ffe:	00 00                	add    %al,(%eax)
    8000:	00 00                	add    %al,(%eax)
    8002:	00 00                	add    %al,(%eax)
    8004:	00 00                	add    %al,(%eax)
    8006:	00 00                	add    %al,(%eax)
    8008:	00 00                	add    %al,(%eax)
    800a:	00 00                	add    %al,(%eax)
    800c:	00 00                	add    %al,(%eax)
    800e:	00 00                	add    %al,(%eax)
    8010:	00 00                	add    %al,(%eax)
    8012:	00 00                	add    %al,(%eax)
    8014:	00 00                	add    %al,(%eax)
    8016:	00 00                	add    %al,(%eax)
    8018:	00 00                	add    %al,(%eax)
    801a:	00 00                	add    %al,(%eax)
    801c:	00 00                	add    %al,(%eax)
    801e:	00 00                	add    %al,(%eax)
    8020:	00 00                	add    %al,(%eax)
    8022:	00 00                	add    %al,(%eax)
    8024:	00 00                	add    %al,(%eax)
    8026:	00 00                	add    %al,(%eax)
    8028:	00 00                	add    %al,(%eax)
    802a:	00 00                	add    %al,(%eax)
    802c:	00 00                	add    %al,(%eax)
    802e:	00 00                	add    %al,(%eax)
    8030:	00 00                	add    %al,(%eax)
    8032:	00 00                	add    %al,(%eax)
    8034:	00 00                	add    %al,(%eax)
    8036:	00 00                	add    %al,(%eax)
    8038:	00 00                	add    %al,(%eax)
    803a:	00 00                	add    %al,(%eax)
    803c:	00 00                	add    %al,(%eax)
    803e:	00 00                	add    %al,(%eax)
    8040:	00 00                	add    %al,(%eax)
    8042:	00 00                	add    %al,(%eax)
    8044:	00 00                	add    %al,(%eax)
    8046:	00 00                	add    %al,(%eax)
    8048:	00 00                	add    %al,(%eax)
    804a:	00 00                	add    %al,(%eax)
    804c:	00 00                	add    %al,(%eax)
    804e:	00 00                	add    %al,(%eax)
    8050:	00 00                	add    %al,(%eax)
    8052:	00 00                	add    %al,(%eax)
    8054:	00 00                	add    %al,(%eax)
    8056:	00 00                	add    %al,(%eax)
    8058:	00 00                	add    %al,(%eax)
    805a:	00 00                	add    %al,(%eax)
    805c:	00 00                	add    %al,(%eax)
    805e:	00 00                	add    %al,(%eax)
    8060:	00 00                	add    %al,(%eax)
    8062:	00 00                	add    %al,(%eax)
    8064:	00 00                	add    %al,(%eax)
    8066:	00 00                	add    %al,(%eax)
    8068:	00 00                	add    %al,(%eax)
    806a:	00 00                	add    %al,(%eax)
    806c:	00 00                	add    %al,(%eax)
    806e:	00 00                	add    %al,(%eax)
    8070:	00 00                	add    %al,(%eax)
    8072:	00 00                	add    %al,(%eax)
    8074:	00 00                	add    %al,(%eax)
    8076:	00 00                	add    %al,(%eax)
    8078:	00 00                	add    %al,(%eax)
    807a:	00 00                	add    %al,(%eax)
    807c:	00 00                	add    %al,(%eax)
    807e:	00 00                	add    %al,(%eax)
    8080:	00 00                	add    %al,(%eax)
    8082:	00 00                	add    %al,(%eax)
    8084:	00 00                	add    %al,(%eax)
    8086:	00 00                	add    %al,(%eax)
    8088:	00 00                	add    %al,(%eax)
    808a:	00 00                	add    %al,(%eax)
    808c:	00 00                	add    %al,(%eax)
    808e:	00 00                	add    %al,(%eax)
    8090:	00 00                	add    %al,(%eax)
    8092:	00 00                	add    %al,(%eax)
    8094:	00 00                	add    %al,(%eax)
    8096:	00 00                	add    %al,(%eax)
    8098:	00 00                	add    %al,(%eax)
    809a:	00 00                	add    %al,(%eax)
    809c:	00 00                	add    %al,(%eax)
    809e:	00 00                	add    %al,(%eax)
    80a0:	00 00                	add    %al,(%eax)
    80a2:	00 00                	add    %al,(%eax)
    80a4:	00 00                	add    %al,(%eax)
    80a6:	00 00                	add    %al,(%eax)
    80a8:	00 00                	add    %al,(%eax)
    80aa:	00 00                	add    %al,(%eax)
    80ac:	00 00                	add    %al,(%eax)
    80ae:	00 00                	add    %al,(%eax)
    80b0:	00 00                	add    %al,(%eax)
    80b2:	00 00                	add    %al,(%eax)
    80b4:	00 00                	add    %al,(%eax)
    80b6:	00 00                	add    %al,(%eax)
    80b8:	00 00                	add    %al,(%eax)
    80ba:	00 00                	add    %al,(%eax)
    80bc:	00 00                	add    %al,(%eax)
    80be:	00 00                	add    %al,(%eax)
    80c0:	00 00                	add    %al,(%eax)
    80c2:	00 00                	add    %al,(%eax)
    80c4:	00 00                	add    %al,(%eax)
    80c6:	00 00                	add    %al,(%eax)
    80c8:	00 00                	add    %al,(%eax)
    80ca:	00 00                	add    %al,(%eax)
    80cc:	00 00                	add    %al,(%eax)
    80ce:	00 00                	add    %al,(%eax)
    80d0:	00 00                	add    %al,(%eax)
    80d2:	00 00                	add    %al,(%eax)
    80d4:	00 00                	add    %al,(%eax)
    80d6:	00 00                	add    %al,(%eax)
    80d8:	00 00                	add    %al,(%eax)
    80da:	00 00                	add    %al,(%eax)
    80dc:	00 00                	add    %al,(%eax)
    80de:	00 00                	add    %al,(%eax)
    80e0:	00 00                	add    %al,(%eax)
    80e2:	00 00                	add    %al,(%eax)
    80e4:	00 00                	add    %al,(%eax)
    80e6:	00 00                	add    %al,(%eax)
    80e8:	00 00                	add    %al,(%eax)
    80ea:	00 00                	add    %al,(%eax)
    80ec:	00 00                	add    %al,(%eax)
    80ee:	00 00                	add    %al,(%eax)
    80f0:	00 00                	add    %al,(%eax)
    80f2:	00 00                	add    %al,(%eax)
    80f4:	00 00                	add    %al,(%eax)
    80f6:	00 00                	add    %al,(%eax)
    80f8:	00 00                	add    %al,(%eax)
    80fa:	00 00                	add    %al,(%eax)
    80fc:	00 00                	add    %al,(%eax)
    80fe:	00 00                	add    %al,(%eax)
    8100:	00 00                	add    %al,(%eax)
    8102:	00 00                	add    %al,(%eax)
    8104:	00 00                	add    %al,(%eax)
    8106:	00 00                	add    %al,(%eax)
    8108:	00 00                	add    %al,(%eax)
    810a:	00 00                	add    %al,(%eax)
    810c:	00 00                	add    %al,(%eax)
    810e:	00 00                	add    %al,(%eax)
    8110:	00 00                	add    %al,(%eax)
    8112:	00 00                	add    %al,(%eax)
    8114:	00 00                	add    %al,(%eax)
    8116:	00 00                	add    %al,(%eax)
    8118:	00 00                	add    %al,(%eax)
    811a:	00 00                	add    %al,(%eax)
    811c:	00 00                	add    %al,(%eax)
    811e:	00 00                	add    %al,(%eax)
    8120:	00 00                	add    %al,(%eax)
    8122:	00 00                	add    %al,(%eax)
    8124:	00 00                	add    %al,(%eax)
    8126:	00 00                	add    %al,(%eax)
    8128:	00 00                	add    %al,(%eax)
    812a:	00 00                	add    %al,(%eax)
    812c:	00 00                	add    %al,(%eax)
    812e:	00 00                	add    %al,(%eax)
    8130:	00 00                	add    %al,(%eax)
    8132:	00 00                	add    %al,(%eax)
    8134:	00 00                	add    %al,(%eax)
    8136:	00 00                	add    %al,(%eax)
    8138:	00 00                	add    %al,(%eax)
    813a:	00 00                	add    %al,(%eax)
    813c:	00 00                	add    %al,(%eax)
    813e:	00 00                	add    %al,(%eax)
    8140:	00 00                	add    %al,(%eax)
    8142:	00 00                	add    %al,(%eax)
    8144:	00 00                	add    %al,(%eax)
    8146:	00 00                	add    %al,(%eax)
    8148:	00 00                	add    %al,(%eax)
    814a:	00 00                	add    %al,(%eax)
    814c:	00 00                	add    %al,(%eax)
    814e:	00 00                	add    %al,(%eax)
    8150:	00 00                	add    %al,(%eax)
    8152:	00 00                	add    %al,(%eax)
    8154:	00 00                	add    %al,(%eax)
    8156:	00 00                	add    %al,(%eax)
    8158:	00 00                	add    %al,(%eax)
    815a:	00 00                	add    %al,(%eax)
    815c:	00 00                	add    %al,(%eax)
    815e:	00 00                	add    %al,(%eax)
    8160:	00 00                	add    %al,(%eax)
    8162:	00 00                	add    %al,(%eax)
    8164:	00 00                	add    %al,(%eax)
    8166:	00 00                	add    %al,(%eax)
    8168:	00 00                	add    %al,(%eax)
    816a:	00 00                	add    %al,(%eax)
    816c:	00 00                	add    %al,(%eax)
    816e:	00 00                	add    %al,(%eax)
    8170:	00 00                	add    %al,(%eax)
    8172:	00 00                	add    %al,(%eax)
    8174:	00 00                	add    %al,(%eax)
    8176:	00 00                	add    %al,(%eax)
    8178:	00 00                	add    %al,(%eax)
    817a:	00 00                	add    %al,(%eax)
    817c:	00 00                	add    %al,(%eax)
    817e:	00 00                	add    %al,(%eax)
    8180:	00 00                	add    %al,(%eax)
    8182:	00 00                	add    %al,(%eax)
    8184:	00 00                	add    %al,(%eax)
    8186:	00 00                	add    %al,(%eax)
    8188:	00 00                	add    %al,(%eax)
    818a:	00 00                	add    %al,(%eax)
    818c:	00 00                	add    %al,(%eax)
    818e:	00 00                	add    %al,(%eax)
    8190:	00 00                	add    %al,(%eax)
    8192:	00 00                	add    %al,(%eax)
    8194:	00 00                	add    %al,(%eax)
    8196:	00 00                	add    %al,(%eax)
    8198:	00 00                	add    %al,(%eax)
    819a:	00 00                	add    %al,(%eax)
    819c:	00 00                	add    %al,(%eax)
    819e:	00 00                	add    %al,(%eax)
    81a0:	00 00                	add    %al,(%eax)
    81a2:	00 00                	add    %al,(%eax)
    81a4:	00 00                	add    %al,(%eax)
    81a6:	00 00                	add    %al,(%eax)
    81a8:	00 00                	add    %al,(%eax)
    81aa:	00 00                	add    %al,(%eax)
    81ac:	00 00                	add    %al,(%eax)
    81ae:	00 00                	add    %al,(%eax)
    81b0:	00 00                	add    %al,(%eax)
    81b2:	00 00                	add    %al,(%eax)
    81b4:	00 00                	add    %al,(%eax)
    81b6:	00 00                	add    %al,(%eax)
    81b8:	00 00                	add    %al,(%eax)
    81ba:	00 00                	add    %al,(%eax)
    81bc:	00 00                	add    %al,(%eax)
    81be:	00 00                	add    %al,(%eax)
    81c0:	00 00                	add    %al,(%eax)
    81c2:	00 00                	add    %al,(%eax)
    81c4:	00 00                	add    %al,(%eax)
    81c6:	00 00                	add    %al,(%eax)
    81c8:	00 00                	add    %al,(%eax)
    81ca:	00 00                	add    %al,(%eax)
    81cc:	00 00                	add    %al,(%eax)
    81ce:	00 00                	add    %al,(%eax)
    81d0:	00 00                	add    %al,(%eax)
    81d2:	00 00                	add    %al,(%eax)
    81d4:	00 00                	add    %al,(%eax)
    81d6:	00 00                	add    %al,(%eax)
    81d8:	00 00                	add    %al,(%eax)
    81da:	00 00                	add    %al,(%eax)
    81dc:	00 00                	add    %al,(%eax)
    81de:	00 00                	add    %al,(%eax)
    81e0:	00 00                	add    %al,(%eax)
    81e2:	00 00                	add    %al,(%eax)
    81e4:	00 00                	add    %al,(%eax)
    81e6:	00 00                	add    %al,(%eax)
    81e8:	00 00                	add    %al,(%eax)
    81ea:	00 00                	add    %al,(%eax)
    81ec:	00 00                	add    %al,(%eax)
    81ee:	00 00                	add    %al,(%eax)
    81f0:	00 00                	add    %al,(%eax)
    81f2:	00 00                	add    %al,(%eax)
    81f4:	00 00                	add    %al,(%eax)
    81f6:	00 00                	add    %al,(%eax)
    81f8:	00 00                	add    %al,(%eax)
    81fa:	00 00                	add    %al,(%eax)
    81fc:	00 00                	add    %al,(%eax)
    81fe:	00 00                	add    %al,(%eax)
    8200:	00 00                	add    %al,(%eax)
    8202:	00 00                	add    %al,(%eax)
    8204:	00 00                	add    %al,(%eax)
    8206:	00 00                	add    %al,(%eax)
    8208:	00 00                	add    %al,(%eax)
    820a:	00 00                	add    %al,(%eax)
    820c:	00 00                	add    %al,(%eax)
    820e:	00 00                	add    %al,(%eax)
    8210:	00 00                	add    %al,(%eax)
    8212:	00 00                	add    %al,(%eax)
    8214:	00 00                	add    %al,(%eax)
    8216:	00 00                	add    %al,(%eax)
    8218:	00 00                	add    %al,(%eax)
    821a:	00 00                	add    %al,(%eax)
    821c:	00 00                	add    %al,(%eax)
    821e:	00 00                	add    %al,(%eax)
    8220:	00 00                	add    %al,(%eax)
    8222:	00 00                	add    %al,(%eax)
    8224:	00 00                	add    %al,(%eax)
    8226:	00 00                	add    %al,(%eax)
    8228:	00 00                	add    %al,(%eax)
    822a:	00 00                	add    %al,(%eax)
    822c:	00 00                	add    %al,(%eax)
    822e:	00 00                	add    %al,(%eax)
    8230:	00 00                	add    %al,(%eax)
    8232:	00 00                	add    %al,(%eax)
    8234:	00 00                	add    %al,(%eax)
    8236:	00 00                	add    %al,(%eax)
    8238:	00 00                	add    %al,(%eax)
    823a:	00 00                	add    %al,(%eax)
    823c:	00 00                	add    %al,(%eax)
    823e:	00 00                	add    %al,(%eax)
    8240:	00 00                	add    %al,(%eax)
    8242:	00 00                	add    %al,(%eax)
    8244:	00 00                	add    %al,(%eax)
    8246:	00 00                	add    %al,(%eax)
    8248:	00 00                	add    %al,(%eax)
    824a:	00 00                	add    %al,(%eax)
    824c:	00 00                	add    %al,(%eax)
    824e:	00 00                	add    %al,(%eax)
    8250:	00 00                	add    %al,(%eax)
    8252:	00 00                	add    %al,(%eax)
    8254:	00 00                	add    %al,(%eax)
    8256:	00 00                	add    %al,(%eax)
    8258:	00 00                	add    %al,(%eax)
    825a:	00 00                	add    %al,(%eax)
    825c:	00 00                	add    %al,(%eax)
    825e:	00 00                	add    %al,(%eax)
    8260:	00 00                	add    %al,(%eax)
    8262:	00 00                	add    %al,(%eax)
    8264:	00 00                	add    %al,(%eax)
    8266:	00 00                	add    %al,(%eax)
    8268:	00 00                	add    %al,(%eax)
    826a:	00 00                	add    %al,(%eax)
    826c:	00 00                	add    %al,(%eax)
    826e:	00 00                	add    %al,(%eax)
    8270:	00 00                	add    %al,(%eax)
    8272:	00 00                	add    %al,(%eax)
    8274:	00 00                	add    %al,(%eax)
    8276:	00 00                	add    %al,(%eax)
    8278:	00 00                	add    %al,(%eax)
    827a:	00 00                	add    %al,(%eax)
    827c:	00 00                	add    %al,(%eax)
    827e:	00 00                	add    %al,(%eax)
    8280:	00 00                	add    %al,(%eax)
    8282:	00 00                	add    %al,(%eax)
    8284:	00 00                	add    %al,(%eax)
    8286:	00 00                	add    %al,(%eax)
    8288:	00 00                	add    %al,(%eax)
    828a:	00 00                	add    %al,(%eax)
    828c:	00 00                	add    %al,(%eax)
    828e:	00 00                	add    %al,(%eax)
    8290:	00 00                	add    %al,(%eax)
    8292:	00 00                	add    %al,(%eax)
    8294:	00 00                	add    %al,(%eax)
    8296:	00 00                	add    %al,(%eax)
    8298:	00 00                	add    %al,(%eax)
    829a:	00 00                	add    %al,(%eax)
    829c:	00 00                	add    %al,(%eax)
    829e:	00 00                	add    %al,(%eax)
    82a0:	00 00                	add    %al,(%eax)
    82a2:	00 00                	add    %al,(%eax)
    82a4:	00 00                	add    %al,(%eax)
    82a6:	00 00                	add    %al,(%eax)
    82a8:	00 00                	add    %al,(%eax)
    82aa:	00 00                	add    %al,(%eax)
    82ac:	00 00                	add    %al,(%eax)
    82ae:	00 00                	add    %al,(%eax)
    82b0:	00 00                	add    %al,(%eax)
    82b2:	00 00                	add    %al,(%eax)
    82b4:	00 00                	add    %al,(%eax)
    82b6:	00 00                	add    %al,(%eax)
    82b8:	00 00                	add    %al,(%eax)
    82ba:	00 00                	add    %al,(%eax)
    82bc:	00 00                	add    %al,(%eax)
    82be:	00 00                	add    %al,(%eax)
    82c0:	00 00                	add    %al,(%eax)
    82c2:	00 00                	add    %al,(%eax)
    82c4:	00 00                	add    %al,(%eax)
    82c6:	00 00                	add    %al,(%eax)
    82c8:	00 00                	add    %al,(%eax)
    82ca:	00 00                	add    %al,(%eax)
    82cc:	00 00                	add    %al,(%eax)
    82ce:	00 00                	add    %al,(%eax)
    82d0:	00 00                	add    %al,(%eax)
    82d2:	00 00                	add    %al,(%eax)
    82d4:	00 00                	add    %al,(%eax)
    82d6:	00 00                	add    %al,(%eax)
    82d8:	00 00                	add    %al,(%eax)
    82da:	00 00                	add    %al,(%eax)
    82dc:	00 00                	add    %al,(%eax)
    82de:	00 00                	add    %al,(%eax)
    82e0:	00 00                	add    %al,(%eax)
    82e2:	00 00                	add    %al,(%eax)
    82e4:	00 00                	add    %al,(%eax)
    82e6:	00 00                	add    %al,(%eax)
    82e8:	00 00                	add    %al,(%eax)
    82ea:	00 00                	add    %al,(%eax)
    82ec:	00 00                	add    %al,(%eax)
    82ee:	00 00                	add    %al,(%eax)
    82f0:	00 00                	add    %al,(%eax)
    82f2:	00 00                	add    %al,(%eax)
    82f4:	00 00                	add    %al,(%eax)
    82f6:	00 00                	add    %al,(%eax)
    82f8:	00 00                	add    %al,(%eax)
    82fa:	00 00                	add    %al,(%eax)
    82fc:	00 00                	add    %al,(%eax)
    82fe:	00 00                	add    %al,(%eax)
    8300:	00 00                	add    %al,(%eax)
    8302:	00 00                	add    %al,(%eax)
    8304:	00 00                	add    %al,(%eax)
    8306:	00 00                	add    %al,(%eax)
    8308:	00 00                	add    %al,(%eax)
    830a:	00 00                	add    %al,(%eax)
    830c:	00 00                	add    %al,(%eax)
    830e:	00 00                	add    %al,(%eax)
    8310:	00 00                	add    %al,(%eax)
    8312:	00 00                	add    %al,(%eax)
    8314:	00 00                	add    %al,(%eax)
    8316:	00 00                	add    %al,(%eax)
    8318:	00 00                	add    %al,(%eax)
    831a:	00 00                	add    %al,(%eax)
    831c:	00 00                	add    %al,(%eax)
    831e:	00 00                	add    %al,(%eax)
    8320:	00 00                	add    %al,(%eax)
    8322:	00 00                	add    %al,(%eax)
    8324:	00 00                	add    %al,(%eax)
    8326:	00 00                	add    %al,(%eax)
    8328:	00 00                	add    %al,(%eax)
    832a:	00 00                	add    %al,(%eax)
    832c:	00 00                	add    %al,(%eax)
    832e:	00 00                	add    %al,(%eax)
    8330:	00 00                	add    %al,(%eax)
    8332:	00 00                	add    %al,(%eax)
    8334:	00 00                	add    %al,(%eax)
    8336:	00 00                	add    %al,(%eax)
    8338:	00 00                	add    %al,(%eax)
    833a:	00 00                	add    %al,(%eax)
    833c:	00 00                	add    %al,(%eax)
    833e:	00 00                	add    %al,(%eax)
    8340:	00 00                	add    %al,(%eax)
    8342:	00 00                	add    %al,(%eax)
    8344:	00 00                	add    %al,(%eax)
    8346:	00 00                	add    %al,(%eax)
    8348:	00 00                	add    %al,(%eax)
    834a:	00 00                	add    %al,(%eax)
    834c:	00 00                	add    %al,(%eax)
    834e:	00 00                	add    %al,(%eax)
    8350:	00 00                	add    %al,(%eax)
    8352:	00 00                	add    %al,(%eax)
    8354:	00 00                	add    %al,(%eax)
    8356:	00 00                	add    %al,(%eax)
    8358:	00 00                	add    %al,(%eax)
    835a:	00 00                	add    %al,(%eax)
    835c:	00 00                	add    %al,(%eax)
    835e:	00 00                	add    %al,(%eax)
    8360:	00 00                	add    %al,(%eax)
    8362:	00 00                	add    %al,(%eax)
    8364:	00 00                	add    %al,(%eax)
    8366:	00 00                	add    %al,(%eax)
    8368:	00 00                	add    %al,(%eax)
    836a:	00 00                	add    %al,(%eax)
    836c:	00 00                	add    %al,(%eax)
    836e:	00 00                	add    %al,(%eax)
    8370:	00 00                	add    %al,(%eax)
    8372:	00 00                	add    %al,(%eax)
    8374:	00 00                	add    %al,(%eax)
    8376:	00 00                	add    %al,(%eax)
    8378:	00 00                	add    %al,(%eax)
    837a:	00 00                	add    %al,(%eax)
    837c:	00 00                	add    %al,(%eax)
    837e:	00 00                	add    %al,(%eax)
    8380:	00 00                	add    %al,(%eax)
    8382:	00 00                	add    %al,(%eax)
    8384:	00 00                	add    %al,(%eax)
    8386:	00 00                	add    %al,(%eax)
    8388:	00 00                	add    %al,(%eax)
    838a:	00 00                	add    %al,(%eax)
    838c:	00 00                	add    %al,(%eax)
    838e:	00 00                	add    %al,(%eax)
    8390:	00 00                	add    %al,(%eax)
    8392:	00 00                	add    %al,(%eax)
    8394:	00 00                	add    %al,(%eax)
    8396:	00 00                	add    %al,(%eax)
    8398:	00 00                	add    %al,(%eax)
    839a:	00 00                	add    %al,(%eax)
    839c:	00 00                	add    %al,(%eax)
    839e:	00 00                	add    %al,(%eax)
    83a0:	00 00                	add    %al,(%eax)
    83a2:	00 00                	add    %al,(%eax)
    83a4:	00 00                	add    %al,(%eax)
    83a6:	00 00                	add    %al,(%eax)
    83a8:	00 00                	add    %al,(%eax)
    83aa:	00 00                	add    %al,(%eax)
    83ac:	00 00                	add    %al,(%eax)
    83ae:	00 00                	add    %al,(%eax)
    83b0:	00 00                	add    %al,(%eax)
    83b2:	00 00                	add    %al,(%eax)
    83b4:	00 00                	add    %al,(%eax)
    83b6:	00 00                	add    %al,(%eax)
    83b8:	00 00                	add    %al,(%eax)
    83ba:	00 00                	add    %al,(%eax)
    83bc:	00 00                	add    %al,(%eax)
    83be:	00 00                	add    %al,(%eax)
    83c0:	00 00                	add    %al,(%eax)
    83c2:	00 00                	add    %al,(%eax)
    83c4:	00 00                	add    %al,(%eax)
    83c6:	00 00                	add    %al,(%eax)
    83c8:	00 00                	add    %al,(%eax)
    83ca:	00 00                	add    %al,(%eax)
    83cc:	00 00                	add    %al,(%eax)
    83ce:	00 00                	add    %al,(%eax)
    83d0:	00 00                	add    %al,(%eax)
    83d2:	00 00                	add    %al,(%eax)
    83d4:	00 00                	add    %al,(%eax)
    83d6:	00 00                	add    %al,(%eax)
    83d8:	00 00                	add    %al,(%eax)
    83da:	00 00                	add    %al,(%eax)
    83dc:	00 00                	add    %al,(%eax)
    83de:	00 00                	add    %al,(%eax)
    83e0:	00 00                	add    %al,(%eax)
    83e2:	00 00                	add    %al,(%eax)
    83e4:	00 00                	add    %al,(%eax)
    83e6:	00 00                	add    %al,(%eax)
    83e8:	00 00                	add    %al,(%eax)
    83ea:	00 00                	add    %al,(%eax)
    83ec:	00 00                	add    %al,(%eax)
    83ee:	00 00                	add    %al,(%eax)
    83f0:	00 00                	add    %al,(%eax)
    83f2:	00 00                	add    %al,(%eax)
    83f4:	00 00                	add    %al,(%eax)
    83f6:	00 00                	add    %al,(%eax)
    83f8:	00 00                	add    %al,(%eax)
    83fa:	00 00                	add    %al,(%eax)
    83fc:	00 00                	add    %al,(%eax)
    83fe:	00 00                	add    %al,(%eax)
    8400:	00 00                	add    %al,(%eax)
    8402:	00 00                	add    %al,(%eax)
    8404:	00 00                	add    %al,(%eax)
    8406:	00 00                	add    %al,(%eax)
    8408:	00 00                	add    %al,(%eax)
    840a:	00 00                	add    %al,(%eax)
    840c:	00 00                	add    %al,(%eax)
    840e:	00 00                	add    %al,(%eax)
    8410:	00 00                	add    %al,(%eax)
    8412:	00 00                	add    %al,(%eax)
    8414:	00 00                	add    %al,(%eax)
    8416:	00 00                	add    %al,(%eax)
    8418:	00 00                	add    %al,(%eax)
    841a:	00 00                	add    %al,(%eax)
    841c:	00 00                	add    %al,(%eax)
    841e:	00 00                	add    %al,(%eax)
    8420:	00 00                	add    %al,(%eax)
    8422:	00 00                	add    %al,(%eax)
    8424:	00 00                	add    %al,(%eax)
    8426:	00 00                	add    %al,(%eax)
    8428:	00 00                	add    %al,(%eax)
    842a:	00 00                	add    %al,(%eax)
    842c:	00 00                	add    %al,(%eax)
    842e:	00 00                	add    %al,(%eax)
    8430:	00 00                	add    %al,(%eax)
    8432:	00 00                	add    %al,(%eax)
    8434:	00 00                	add    %al,(%eax)
    8436:	00 00                	add    %al,(%eax)
    8438:	00 00                	add    %al,(%eax)
    843a:	00 00                	add    %al,(%eax)
    843c:	00 00                	add    %al,(%eax)
    843e:	00 00                	add    %al,(%eax)
    8440:	00 00                	add    %al,(%eax)
    8442:	00 00                	add    %al,(%eax)
    8444:	00 00                	add    %al,(%eax)
    8446:	00 00                	add    %al,(%eax)
    8448:	00 00                	add    %al,(%eax)
    844a:	00 00                	add    %al,(%eax)
    844c:	00 00                	add    %al,(%eax)
    844e:	00 00                	add    %al,(%eax)
    8450:	00 00                	add    %al,(%eax)
    8452:	00 00                	add    %al,(%eax)
    8454:	00 00                	add    %al,(%eax)
    8456:	00 00                	add    %al,(%eax)
    8458:	00 00                	add    %al,(%eax)
    845a:	00 00                	add    %al,(%eax)
    845c:	00 00                	add    %al,(%eax)
    845e:	00 00                	add    %al,(%eax)
    8460:	00 00                	add    %al,(%eax)
    8462:	00 00                	add    %al,(%eax)
    8464:	00 00                	add    %al,(%eax)
    8466:	00 00                	add    %al,(%eax)
    8468:	00 00                	add    %al,(%eax)
    846a:	00 00                	add    %al,(%eax)
    846c:	00 00                	add    %al,(%eax)
    846e:	00 00                	add    %al,(%eax)
    8470:	00 00                	add    %al,(%eax)
    8472:	00 00                	add    %al,(%eax)
    8474:	00 00                	add    %al,(%eax)
    8476:	00 00                	add    %al,(%eax)
    8478:	00 00                	add    %al,(%eax)
    847a:	00 00                	add    %al,(%eax)
    847c:	00 00                	add    %al,(%eax)
    847e:	00 00                	add    %al,(%eax)
    8480:	00 00                	add    %al,(%eax)
    8482:	00 00                	add    %al,(%eax)
    8484:	00 00                	add    %al,(%eax)
    8486:	00 00                	add    %al,(%eax)
    8488:	00 00                	add    %al,(%eax)
    848a:	00 00                	add    %al,(%eax)
    848c:	00 00                	add    %al,(%eax)
    848e:	00 00                	add    %al,(%eax)
    8490:	00 00                	add    %al,(%eax)
    8492:	00 00                	add    %al,(%eax)
    8494:	00 00                	add    %al,(%eax)
    8496:	00 00                	add    %al,(%eax)
    8498:	00 00                	add    %al,(%eax)
    849a:	00 00                	add    %al,(%eax)
    849c:	00 00                	add    %al,(%eax)
    849e:	00 00                	add    %al,(%eax)
    84a0:	00 00                	add    %al,(%eax)
    84a2:	00 00                	add    %al,(%eax)
    84a4:	00 00                	add    %al,(%eax)
    84a6:	00 00                	add    %al,(%eax)
    84a8:	00 00                	add    %al,(%eax)
    84aa:	00 00                	add    %al,(%eax)
    84ac:	00 00                	add    %al,(%eax)
    84ae:	00 00                	add    %al,(%eax)
    84b0:	00 00                	add    %al,(%eax)
    84b2:	00 00                	add    %al,(%eax)
    84b4:	00 00                	add    %al,(%eax)
    84b6:	00 00                	add    %al,(%eax)
    84b8:	00 00                	add    %al,(%eax)
    84ba:	00 00                	add    %al,(%eax)
    84bc:	00 00                	add    %al,(%eax)
    84be:	00 00                	add    %al,(%eax)
    84c0:	00 00                	add    %al,(%eax)
    84c2:	00 00                	add    %al,(%eax)
    84c4:	00 00                	add    %al,(%eax)
    84c6:	00 00                	add    %al,(%eax)
    84c8:	00 00                	add    %al,(%eax)
    84ca:	00 00                	add    %al,(%eax)
    84cc:	00 00                	add    %al,(%eax)
    84ce:	00 00                	add    %al,(%eax)
    84d0:	00 00                	add    %al,(%eax)
    84d2:	00 00                	add    %al,(%eax)
    84d4:	00 00                	add    %al,(%eax)
    84d6:	00 00                	add    %al,(%eax)
    84d8:	00 00                	add    %al,(%eax)
    84da:	00 00                	add    %al,(%eax)
    84dc:	00 00                	add    %al,(%eax)
    84de:	00 00                	add    %al,(%eax)
    84e0:	00 00                	add    %al,(%eax)
    84e2:	00 00                	add    %al,(%eax)
    84e4:	00 00                	add    %al,(%eax)
    84e6:	00 00                	add    %al,(%eax)
    84e8:	00 00                	add    %al,(%eax)
    84ea:	00 00                	add    %al,(%eax)
    84ec:	00 00                	add    %al,(%eax)
    84ee:	00 00                	add    %al,(%eax)
    84f0:	00 00                	add    %al,(%eax)
    84f2:	00 00                	add    %al,(%eax)
    84f4:	00 00                	add    %al,(%eax)
    84f6:	00 00                	add    %al,(%eax)
    84f8:	00 00                	add    %al,(%eax)
    84fa:	00 00                	add    %al,(%eax)
    84fc:	00 00                	add    %al,(%eax)
    84fe:	00 00                	add    %al,(%eax)
    8500:	00 00                	add    %al,(%eax)
    8502:	00 00                	add    %al,(%eax)
    8504:	00 00                	add    %al,(%eax)
    8506:	00 00                	add    %al,(%eax)
    8508:	00 00                	add    %al,(%eax)
    850a:	00 00                	add    %al,(%eax)
    850c:	00 00                	add    %al,(%eax)
    850e:	00 00                	add    %al,(%eax)
    8510:	00 00                	add    %al,(%eax)
    8512:	00 00                	add    %al,(%eax)
    8514:	00 00                	add    %al,(%eax)
    8516:	00 00                	add    %al,(%eax)
    8518:	00 00                	add    %al,(%eax)
    851a:	00 00                	add    %al,(%eax)
    851c:	00 00                	add    %al,(%eax)
    851e:	00 00                	add    %al,(%eax)
    8520:	00 00                	add    %al,(%eax)
    8522:	00 00                	add    %al,(%eax)
    8524:	00 00                	add    %al,(%eax)
    8526:	00 00                	add    %al,(%eax)
    8528:	00 00                	add    %al,(%eax)
    852a:	00 00                	add    %al,(%eax)
    852c:	00 00                	add    %al,(%eax)
    852e:	00 00                	add    %al,(%eax)
    8530:	00 00                	add    %al,(%eax)
    8532:	00 00                	add    %al,(%eax)
    8534:	00 00                	add    %al,(%eax)
    8536:	00 00                	add    %al,(%eax)
    8538:	00 00                	add    %al,(%eax)
    853a:	00 00                	add    %al,(%eax)
    853c:	00 00                	add    %al,(%eax)
    853e:	00 00                	add    %al,(%eax)
    8540:	00 00                	add    %al,(%eax)
    8542:	00 00                	add    %al,(%eax)
    8544:	00 00                	add    %al,(%eax)
    8546:	00 00                	add    %al,(%eax)
    8548:	00 00                	add    %al,(%eax)
    854a:	00 00                	add    %al,(%eax)
    854c:	00 00                	add    %al,(%eax)
    854e:	00 00                	add    %al,(%eax)
    8550:	00 00                	add    %al,(%eax)
    8552:	00 00                	add    %al,(%eax)
    8554:	00 00                	add    %al,(%eax)
    8556:	00 00                	add    %al,(%eax)
    8558:	00 00                	add    %al,(%eax)
    855a:	00 00                	add    %al,(%eax)
    855c:	00 00                	add    %al,(%eax)
    855e:	00 00                	add    %al,(%eax)
    8560:	00 00                	add    %al,(%eax)
    8562:	00 00                	add    %al,(%eax)
    8564:	00 00                	add    %al,(%eax)
    8566:	00 00                	add    %al,(%eax)
    8568:	00 00                	add    %al,(%eax)
    856a:	00 00                	add    %al,(%eax)
    856c:	00 00                	add    %al,(%eax)
    856e:	00 00                	add    %al,(%eax)
    8570:	00 00                	add    %al,(%eax)
    8572:	00 00                	add    %al,(%eax)
    8574:	00 00                	add    %al,(%eax)
    8576:	00 00                	add    %al,(%eax)
    8578:	00 00                	add    %al,(%eax)
    857a:	00 00                	add    %al,(%eax)
    857c:	00 00                	add    %al,(%eax)
    857e:	00 00                	add    %al,(%eax)
    8580:	00 00                	add    %al,(%eax)
    8582:	00 00                	add    %al,(%eax)
    8584:	00 00                	add    %al,(%eax)
    8586:	00 00                	add    %al,(%eax)
    8588:	00 00                	add    %al,(%eax)
    858a:	00 00                	add    %al,(%eax)
    858c:	00 00                	add    %al,(%eax)
    858e:	00 00                	add    %al,(%eax)
    8590:	00 00                	add    %al,(%eax)
    8592:	00 00                	add    %al,(%eax)
    8594:	00 00                	add    %al,(%eax)
    8596:	00 00                	add    %al,(%eax)
    8598:	00 00                	add    %al,(%eax)
    859a:	00 00                	add    %al,(%eax)
    859c:	00 00                	add    %al,(%eax)
    859e:	00 00                	add    %al,(%eax)
    85a0:	00 00                	add    %al,(%eax)
    85a2:	00 00                	add    %al,(%eax)
    85a4:	00 00                	add    %al,(%eax)
    85a6:	00 00                	add    %al,(%eax)
    85a8:	00 00                	add    %al,(%eax)
    85aa:	00 00                	add    %al,(%eax)
    85ac:	00 00                	add    %al,(%eax)
    85ae:	00 00                	add    %al,(%eax)
    85b0:	00 00                	add    %al,(%eax)
    85b2:	00 00                	add    %al,(%eax)
    85b4:	00 00                	add    %al,(%eax)
    85b6:	00 00                	add    %al,(%eax)
    85b8:	00 00                	add    %al,(%eax)
    85ba:	00 00                	add    %al,(%eax)
    85bc:	00 00                	add    %al,(%eax)
    85be:	00 00                	add    %al,(%eax)
    85c0:	00 00                	add    %al,(%eax)
    85c2:	00 00                	add    %al,(%eax)
    85c4:	00 00                	add    %al,(%eax)
    85c6:	00 00                	add    %al,(%eax)
    85c8:	00 00                	add    %al,(%eax)
    85ca:	00 00                	add    %al,(%eax)
    85cc:	00 00                	add    %al,(%eax)
    85ce:	00 00                	add    %al,(%eax)
    85d0:	00 00                	add    %al,(%eax)
    85d2:	00 00                	add    %al,(%eax)
    85d4:	00 00                	add    %al,(%eax)
    85d6:	00 00                	add    %al,(%eax)
    85d8:	00 00                	add    %al,(%eax)
    85da:	00 00                	add    %al,(%eax)
    85dc:	00 00                	add    %al,(%eax)
    85de:	00 00                	add    %al,(%eax)
    85e0:	00 00                	add    %al,(%eax)
    85e2:	00 00                	add    %al,(%eax)
    85e4:	00 00                	add    %al,(%eax)
    85e6:	00 00                	add    %al,(%eax)
    85e8:	00 00                	add    %al,(%eax)
    85ea:	00 00                	add    %al,(%eax)
    85ec:	00 00                	add    %al,(%eax)
    85ee:	00 00                	add    %al,(%eax)
    85f0:	00 00                	add    %al,(%eax)
    85f2:	00 00                	add    %al,(%eax)
    85f4:	00 00                	add    %al,(%eax)
    85f6:	00 00                	add    %al,(%eax)
    85f8:	00 00                	add    %al,(%eax)
    85fa:	00 00                	add    %al,(%eax)
    85fc:	00 00                	add    %al,(%eax)
    85fe:	00 00                	add    %al,(%eax)
    8600:	00 00                	add    %al,(%eax)
    8602:	00 00                	add    %al,(%eax)
    8604:	00 00                	add    %al,(%eax)
    8606:	00 00                	add    %al,(%eax)
    8608:	00 00                	add    %al,(%eax)
    860a:	00 00                	add    %al,(%eax)
    860c:	00 00                	add    %al,(%eax)
    860e:	00 00                	add    %al,(%eax)
    8610:	00 00                	add    %al,(%eax)
    8612:	00 00                	add    %al,(%eax)
    8614:	00 00                	add    %al,(%eax)
    8616:	00 00                	add    %al,(%eax)
    8618:	00 00                	add    %al,(%eax)
    861a:	00 00                	add    %al,(%eax)
    861c:	00 00                	add    %al,(%eax)
    861e:	00 00                	add    %al,(%eax)
    8620:	00 00                	add    %al,(%eax)
    8622:	00 00                	add    %al,(%eax)
    8624:	00 00                	add    %al,(%eax)
    8626:	00 00                	add    %al,(%eax)
    8628:	00 00                	add    %al,(%eax)
    862a:	00 00                	add    %al,(%eax)
    862c:	00 00                	add    %al,(%eax)
    862e:	00 00                	add    %al,(%eax)
    8630:	00 00                	add    %al,(%eax)
    8632:	00 00                	add    %al,(%eax)
    8634:	00 00                	add    %al,(%eax)
    8636:	00 00                	add    %al,(%eax)
    8638:	00 00                	add    %al,(%eax)
    863a:	00 00                	add    %al,(%eax)
    863c:	00 00                	add    %al,(%eax)
    863e:	00 00                	add    %al,(%eax)
    8640:	00 00                	add    %al,(%eax)
    8642:	00 00                	add    %al,(%eax)
    8644:	00 00                	add    %al,(%eax)
    8646:	00 00                	add    %al,(%eax)
    8648:	00 00                	add    %al,(%eax)
    864a:	00 00                	add    %al,(%eax)
    864c:	00 00                	add    %al,(%eax)
    864e:	00 00                	add    %al,(%eax)
    8650:	00 00                	add    %al,(%eax)
    8652:	00 00                	add    %al,(%eax)
    8654:	00 00                	add    %al,(%eax)
    8656:	00 00                	add    %al,(%eax)
    8658:	00 00                	add    %al,(%eax)
    865a:	00 00                	add    %al,(%eax)
    865c:	00 00                	add    %al,(%eax)
    865e:	00 00                	add    %al,(%eax)
    8660:	00 00                	add    %al,(%eax)
    8662:	00 00                	add    %al,(%eax)
    8664:	00 00                	add    %al,(%eax)
    8666:	00 00                	add    %al,(%eax)
    8668:	00 00                	add    %al,(%eax)
    866a:	00 00                	add    %al,(%eax)
    866c:	00 00                	add    %al,(%eax)
    866e:	00 00                	add    %al,(%eax)
    8670:	00 00                	add    %al,(%eax)
    8672:	00 00                	add    %al,(%eax)
    8674:	00 00                	add    %al,(%eax)
    8676:	00 00                	add    %al,(%eax)
    8678:	00 00                	add    %al,(%eax)
    867a:	00 00                	add    %al,(%eax)
    867c:	00 00                	add    %al,(%eax)
    867e:	00 00                	add    %al,(%eax)
    8680:	00 00                	add    %al,(%eax)
    8682:	00 00                	add    %al,(%eax)
    8684:	00 00                	add    %al,(%eax)
    8686:	00 00                	add    %al,(%eax)
    8688:	00 00                	add    %al,(%eax)
    868a:	00 00                	add    %al,(%eax)
    868c:	00 00                	add    %al,(%eax)
    868e:	00 00                	add    %al,(%eax)
    8690:	00 00                	add    %al,(%eax)
    8692:	00 00                	add    %al,(%eax)
    8694:	00 00                	add    %al,(%eax)
    8696:	00 00                	add    %al,(%eax)
    8698:	00 00                	add    %al,(%eax)
    869a:	00 00                	add    %al,(%eax)
    869c:	00 00                	add    %al,(%eax)
    869e:	00 00                	add    %al,(%eax)
    86a0:	00 00                	add    %al,(%eax)
    86a2:	00 00                	add    %al,(%eax)
    86a4:	00 00                	add    %al,(%eax)
    86a6:	00 00                	add    %al,(%eax)
    86a8:	00 00                	add    %al,(%eax)
    86aa:	00 00                	add    %al,(%eax)
    86ac:	00 00                	add    %al,(%eax)
    86ae:	00 00                	add    %al,(%eax)
    86b0:	00 00                	add    %al,(%eax)
    86b2:	00 00                	add    %al,(%eax)
    86b4:	00 00                	add    %al,(%eax)
    86b6:	00 00                	add    %al,(%eax)
    86b8:	00 00                	add    %al,(%eax)
    86ba:	00 00                	add    %al,(%eax)
    86bc:	00 00                	add    %al,(%eax)
    86be:	00 00                	add    %al,(%eax)
    86c0:	00 00                	add    %al,(%eax)
    86c2:	00 00                	add    %al,(%eax)
    86c4:	00 00                	add    %al,(%eax)
    86c6:	00 00                	add    %al,(%eax)
    86c8:	00 00                	add    %al,(%eax)
    86ca:	00 00                	add    %al,(%eax)
    86cc:	00 00                	add    %al,(%eax)
    86ce:	00 00                	add    %al,(%eax)
    86d0:	00 00                	add    %al,(%eax)
    86d2:	00 00                	add    %al,(%eax)
    86d4:	00 00                	add    %al,(%eax)
    86d6:	00 00                	add    %al,(%eax)
    86d8:	00 00                	add    %al,(%eax)
    86da:	00 00                	add    %al,(%eax)
    86dc:	00 00                	add    %al,(%eax)
    86de:	00 00                	add    %al,(%eax)
    86e0:	00 00                	add    %al,(%eax)
    86e2:	00 00                	add    %al,(%eax)
    86e4:	00 00                	add    %al,(%eax)
    86e6:	00 00                	add    %al,(%eax)
    86e8:	00 00                	add    %al,(%eax)
    86ea:	00 00                	add    %al,(%eax)
    86ec:	00 00                	add    %al,(%eax)
    86ee:	00 00                	add    %al,(%eax)
    86f0:	00 00                	add    %al,(%eax)
    86f2:	00 00                	add    %al,(%eax)
    86f4:	00 00                	add    %al,(%eax)
    86f6:	00 00                	add    %al,(%eax)
    86f8:	00 00                	add    %al,(%eax)
    86fa:	00 00                	add    %al,(%eax)
    86fc:	00 00                	add    %al,(%eax)
    86fe:	00 00                	add    %al,(%eax)
    8700:	00 00                	add    %al,(%eax)
    8702:	00 00                	add    %al,(%eax)
    8704:	00 00                	add    %al,(%eax)
    8706:	00 00                	add    %al,(%eax)
    8708:	00 00                	add    %al,(%eax)
    870a:	00 00                	add    %al,(%eax)
    870c:	00 00                	add    %al,(%eax)
    870e:	00 00                	add    %al,(%eax)
    8710:	00 00                	add    %al,(%eax)
    8712:	00 00                	add    %al,(%eax)
    8714:	00 00                	add    %al,(%eax)
    8716:	00 00                	add    %al,(%eax)
    8718:	00 00                	add    %al,(%eax)
    871a:	00 00                	add    %al,(%eax)
    871c:	00 00                	add    %al,(%eax)
    871e:	00 00                	add    %al,(%eax)
    8720:	00 00                	add    %al,(%eax)
    8722:	00 00                	add    %al,(%eax)
    8724:	00 00                	add    %al,(%eax)
    8726:	00 00                	add    %al,(%eax)
    8728:	00 00                	add    %al,(%eax)
    872a:	00 00                	add    %al,(%eax)
    872c:	00 00                	add    %al,(%eax)
    872e:	00 00                	add    %al,(%eax)
    8730:	00 00                	add    %al,(%eax)
    8732:	00 00                	add    %al,(%eax)
    8734:	00 00                	add    %al,(%eax)
    8736:	00 00                	add    %al,(%eax)
    8738:	00 00                	add    %al,(%eax)
    873a:	00 00                	add    %al,(%eax)
    873c:	00 00                	add    %al,(%eax)
    873e:	00 00                	add    %al,(%eax)
    8740:	00 00                	add    %al,(%eax)
    8742:	00 00                	add    %al,(%eax)
    8744:	00 00                	add    %al,(%eax)
    8746:	00 00                	add    %al,(%eax)
    8748:	00 00                	add    %al,(%eax)
    874a:	00 00                	add    %al,(%eax)
    874c:	00 00                	add    %al,(%eax)
    874e:	00 00                	add    %al,(%eax)
    8750:	00 00                	add    %al,(%eax)
    8752:	00 00                	add    %al,(%eax)
    8754:	00 00                	add    %al,(%eax)
    8756:	00 00                	add    %al,(%eax)
    8758:	00 00                	add    %al,(%eax)
    875a:	00 00                	add    %al,(%eax)
    875c:	00 00                	add    %al,(%eax)
    875e:	00 00                	add    %al,(%eax)
    8760:	00 00                	add    %al,(%eax)
    8762:	00 00                	add    %al,(%eax)
    8764:	00 00                	add    %al,(%eax)
    8766:	00 00                	add    %al,(%eax)
    8768:	00 00                	add    %al,(%eax)
    876a:	00 00                	add    %al,(%eax)
    876c:	00 00                	add    %al,(%eax)
    876e:	00 00                	add    %al,(%eax)
    8770:	00 00                	add    %al,(%eax)
    8772:	00 00                	add    %al,(%eax)
    8774:	00 00                	add    %al,(%eax)
    8776:	00 00                	add    %al,(%eax)
    8778:	00 00                	add    %al,(%eax)
    877a:	00 00                	add    %al,(%eax)
    877c:	00 00                	add    %al,(%eax)
    877e:	00 00                	add    %al,(%eax)
    8780:	00 00                	add    %al,(%eax)
    8782:	00 00                	add    %al,(%eax)
    8784:	00 00                	add    %al,(%eax)
    8786:	00 00                	add    %al,(%eax)
    8788:	00 00                	add    %al,(%eax)
    878a:	00 00                	add    %al,(%eax)
    878c:	00 00                	add    %al,(%eax)
    878e:	00 00                	add    %al,(%eax)
    8790:	00 00                	add    %al,(%eax)
    8792:	00 00                	add    %al,(%eax)
    8794:	00 00                	add    %al,(%eax)
    8796:	00 00                	add    %al,(%eax)
    8798:	00 00                	add    %al,(%eax)
    879a:	00 00                	add    %al,(%eax)
    879c:	00 00                	add    %al,(%eax)
    879e:	00 00                	add    %al,(%eax)
    87a0:	00 00                	add    %al,(%eax)
    87a2:	00 00                	add    %al,(%eax)
    87a4:	00 00                	add    %al,(%eax)
    87a6:	00 00                	add    %al,(%eax)
    87a8:	00 00                	add    %al,(%eax)
    87aa:	00 00                	add    %al,(%eax)
    87ac:	00 00                	add    %al,(%eax)
    87ae:	00 00                	add    %al,(%eax)
    87b0:	00 00                	add    %al,(%eax)
    87b2:	00 00                	add    %al,(%eax)
    87b4:	00 00                	add    %al,(%eax)
    87b6:	00 00                	add    %al,(%eax)
    87b8:	00 00                	add    %al,(%eax)
    87ba:	00 00                	add    %al,(%eax)
    87bc:	00 00                	add    %al,(%eax)
    87be:	00 00                	add    %al,(%eax)
    87c0:	00 00                	add    %al,(%eax)
    87c2:	00 00                	add    %al,(%eax)
    87c4:	00 00                	add    %al,(%eax)
    87c6:	00 00                	add    %al,(%eax)
    87c8:	00 00                	add    %al,(%eax)
    87ca:	00 00                	add    %al,(%eax)
    87cc:	00 00                	add    %al,(%eax)
    87ce:	00 00                	add    %al,(%eax)
    87d0:	00 00                	add    %al,(%eax)
    87d2:	00 00                	add    %al,(%eax)
    87d4:	00 00                	add    %al,(%eax)
    87d6:	00 00                	add    %al,(%eax)
    87d8:	00 00                	add    %al,(%eax)
    87da:	00 00                	add    %al,(%eax)
    87dc:	00 00                	add    %al,(%eax)
    87de:	00 00                	add    %al,(%eax)
    87e0:	00 00                	add    %al,(%eax)
    87e2:	00 00                	add    %al,(%eax)
    87e4:	00 00                	add    %al,(%eax)
    87e6:	00 00                	add    %al,(%eax)
    87e8:	00 00                	add    %al,(%eax)
    87ea:	00 00                	add    %al,(%eax)
    87ec:	00 00                	add    %al,(%eax)
    87ee:	00 00                	add    %al,(%eax)
    87f0:	00 00                	add    %al,(%eax)
    87f2:	00 00                	add    %al,(%eax)
    87f4:	00 00                	add    %al,(%eax)
    87f6:	00 00                	add    %al,(%eax)
    87f8:	00 00                	add    %al,(%eax)
    87fa:	00 00                	add    %al,(%eax)
    87fc:	00 00                	add    %al,(%eax)
    87fe:	00 00                	add    %al,(%eax)
    8800:	00 00                	add    %al,(%eax)
    8802:	00 00                	add    %al,(%eax)
    8804:	00 00                	add    %al,(%eax)
    8806:	00 00                	add    %al,(%eax)
    8808:	00 00                	add    %al,(%eax)
    880a:	00 00                	add    %al,(%eax)
    880c:	00 00                	add    %al,(%eax)
    880e:	00 00                	add    %al,(%eax)
    8810:	00 00                	add    %al,(%eax)
    8812:	00 00                	add    %al,(%eax)
    8814:	00 00                	add    %al,(%eax)
    8816:	00 00                	add    %al,(%eax)
    8818:	00 00                	add    %al,(%eax)
    881a:	00 00                	add    %al,(%eax)
    881c:	00 00                	add    %al,(%eax)
    881e:	00 00                	add    %al,(%eax)
    8820:	00 00                	add    %al,(%eax)
    8822:	00 00                	add    %al,(%eax)
    8824:	00 00                	add    %al,(%eax)
    8826:	00 00                	add    %al,(%eax)
    8828:	00 00                	add    %al,(%eax)
    882a:	00 00                	add    %al,(%eax)
    882c:	00 00                	add    %al,(%eax)
    882e:	00 00                	add    %al,(%eax)
    8830:	00 00                	add    %al,(%eax)
    8832:	00 00                	add    %al,(%eax)
    8834:	00 00                	add    %al,(%eax)
    8836:	00 00                	add    %al,(%eax)
    8838:	00 00                	add    %al,(%eax)
    883a:	00 00                	add    %al,(%eax)
    883c:	00 00                	add    %al,(%eax)
    883e:	00 00                	add    %al,(%eax)
    8840:	00 00                	add    %al,(%eax)
    8842:	00 00                	add    %al,(%eax)
    8844:	00 00                	add    %al,(%eax)
    8846:	00 00                	add    %al,(%eax)
    8848:	00 00                	add    %al,(%eax)
    884a:	00 00                	add    %al,(%eax)
    884c:	00 00                	add    %al,(%eax)
    884e:	00 00                	add    %al,(%eax)
    8850:	00 00                	add    %al,(%eax)
    8852:	00 00                	add    %al,(%eax)
    8854:	00 00                	add    %al,(%eax)
    8856:	00 00                	add    %al,(%eax)
    8858:	00 00                	add    %al,(%eax)
    885a:	00 00                	add    %al,(%eax)
    885c:	00 00                	add    %al,(%eax)
    885e:	00 00                	add    %al,(%eax)
    8860:	00 00                	add    %al,(%eax)
    8862:	00 00                	add    %al,(%eax)
    8864:	00 00                	add    %al,(%eax)
    8866:	00 00                	add    %al,(%eax)
    8868:	00 00                	add    %al,(%eax)
    886a:	00 00                	add    %al,(%eax)
    886c:	00 00                	add    %al,(%eax)
    886e:	00 00                	add    %al,(%eax)
    8870:	00 00                	add    %al,(%eax)
    8872:	00 00                	add    %al,(%eax)
    8874:	00 00                	add    %al,(%eax)
    8876:	00 00                	add    %al,(%eax)
    8878:	00 00                	add    %al,(%eax)
    887a:	00 00                	add    %al,(%eax)
    887c:	00 00                	add    %al,(%eax)
    887e:	00 00                	add    %al,(%eax)
    8880:	00 00                	add    %al,(%eax)
    8882:	00 00                	add    %al,(%eax)
    8884:	00 00                	add    %al,(%eax)
    8886:	00 00                	add    %al,(%eax)
    8888:	00 00                	add    %al,(%eax)
    888a:	00 00                	add    %al,(%eax)
    888c:	00 00                	add    %al,(%eax)
    888e:	00 00                	add    %al,(%eax)
    8890:	00 00                	add    %al,(%eax)
    8892:	00 00                	add    %al,(%eax)
    8894:	00 00                	add    %al,(%eax)
    8896:	00 00                	add    %al,(%eax)
    8898:	00 00                	add    %al,(%eax)
    889a:	00 00                	add    %al,(%eax)
    889c:	00 00                	add    %al,(%eax)
    889e:	00 00                	add    %al,(%eax)
    88a0:	00 00                	add    %al,(%eax)
    88a2:	00 00                	add    %al,(%eax)
    88a4:	00 00                	add    %al,(%eax)
    88a6:	00 00                	add    %al,(%eax)
    88a8:	00 00                	add    %al,(%eax)
    88aa:	00 00                	add    %al,(%eax)
    88ac:	00 00                	add    %al,(%eax)
    88ae:	00 00                	add    %al,(%eax)
    88b0:	00 00                	add    %al,(%eax)
    88b2:	00 00                	add    %al,(%eax)
    88b4:	00 00                	add    %al,(%eax)
    88b6:	00 00                	add    %al,(%eax)
    88b8:	00 00                	add    %al,(%eax)
    88ba:	00 00                	add    %al,(%eax)
    88bc:	00 00                	add    %al,(%eax)
    88be:	00 00                	add    %al,(%eax)
    88c0:	00 00                	add    %al,(%eax)
    88c2:	00 00                	add    %al,(%eax)
    88c4:	00 00                	add    %al,(%eax)
    88c6:	00 00                	add    %al,(%eax)
    88c8:	00 00                	add    %al,(%eax)
    88ca:	00 00                	add    %al,(%eax)
    88cc:	00 00                	add    %al,(%eax)
    88ce:	00 00                	add    %al,(%eax)
    88d0:	00 00                	add    %al,(%eax)
    88d2:	00 00                	add    %al,(%eax)
    88d4:	00 00                	add    %al,(%eax)
    88d6:	00 00                	add    %al,(%eax)
    88d8:	00 00                	add    %al,(%eax)
    88da:	00 00                	add    %al,(%eax)
    88dc:	00 00                	add    %al,(%eax)
    88de:	00 00                	add    %al,(%eax)
    88e0:	00 00                	add    %al,(%eax)
    88e2:	00 00                	add    %al,(%eax)
    88e4:	00 00                	add    %al,(%eax)
    88e6:	00 00                	add    %al,(%eax)
    88e8:	00 00                	add    %al,(%eax)
    88ea:	00 00                	add    %al,(%eax)
    88ec:	00 00                	add    %al,(%eax)
    88ee:	00 00                	add    %al,(%eax)
    88f0:	00 00                	add    %al,(%eax)
    88f2:	00 00                	add    %al,(%eax)
    88f4:	00 00                	add    %al,(%eax)
    88f6:	00 00                	add    %al,(%eax)
    88f8:	00 00                	add    %al,(%eax)
    88fa:	00 00                	add    %al,(%eax)
    88fc:	00 00                	add    %al,(%eax)
    88fe:	00 00                	add    %al,(%eax)
    8900:	00 00                	add    %al,(%eax)
    8902:	00 00                	add    %al,(%eax)
    8904:	00 00                	add    %al,(%eax)
    8906:	00 00                	add    %al,(%eax)
    8908:	00 00                	add    %al,(%eax)
    890a:	00 00                	add    %al,(%eax)
    890c:	00 00                	add    %al,(%eax)
    890e:	00 00                	add    %al,(%eax)
    8910:	00 00                	add    %al,(%eax)
    8912:	00 00                	add    %al,(%eax)
    8914:	00 00                	add    %al,(%eax)
    8916:	00 00                	add    %al,(%eax)
    8918:	00 00                	add    %al,(%eax)
    891a:	00 00                	add    %al,(%eax)
    891c:	00 00                	add    %al,(%eax)
    891e:	00 00                	add    %al,(%eax)
    8920:	00 00                	add    %al,(%eax)
    8922:	00 00                	add    %al,(%eax)
    8924:	00 00                	add    %al,(%eax)
    8926:	00 00                	add    %al,(%eax)
    8928:	00 00                	add    %al,(%eax)
    892a:	00 00                	add    %al,(%eax)
    892c:	00 00                	add    %al,(%eax)
    892e:	00 00                	add    %al,(%eax)
    8930:	00 00                	add    %al,(%eax)
    8932:	00 00                	add    %al,(%eax)
    8934:	00 00                	add    %al,(%eax)
    8936:	00 00                	add    %al,(%eax)
    8938:	00 00                	add    %al,(%eax)
    893a:	00 00                	add    %al,(%eax)
    893c:	00 00                	add    %al,(%eax)
    893e:	00 00                	add    %al,(%eax)
    8940:	00 00                	add    %al,(%eax)
    8942:	00 00                	add    %al,(%eax)
    8944:	00 00                	add    %al,(%eax)
    8946:	00 00                	add    %al,(%eax)
    8948:	00 00                	add    %al,(%eax)
    894a:	00 00                	add    %al,(%eax)
    894c:	00 00                	add    %al,(%eax)
    894e:	00 00                	add    %al,(%eax)
    8950:	00 00                	add    %al,(%eax)
    8952:	00 00                	add    %al,(%eax)
    8954:	00 00                	add    %al,(%eax)
    8956:	00 00                	add    %al,(%eax)
    8958:	00 00                	add    %al,(%eax)
    895a:	00 00                	add    %al,(%eax)
    895c:	00 00                	add    %al,(%eax)
    895e:	00 00                	add    %al,(%eax)
    8960:	00 00                	add    %al,(%eax)
    8962:	00 00                	add    %al,(%eax)
    8964:	00 00                	add    %al,(%eax)
    8966:	00 00                	add    %al,(%eax)
    8968:	00 00                	add    %al,(%eax)
    896a:	00 00                	add    %al,(%eax)
    896c:	00 00                	add    %al,(%eax)
    896e:	00 00                	add    %al,(%eax)
    8970:	00 00                	add    %al,(%eax)
    8972:	00 00                	add    %al,(%eax)
    8974:	00 00                	add    %al,(%eax)
    8976:	00 00                	add    %al,(%eax)
    8978:	00 00                	add    %al,(%eax)
    897a:	00 00                	add    %al,(%eax)
    897c:	00 00                	add    %al,(%eax)
    897e:	00 00                	add    %al,(%eax)
    8980:	00 00                	add    %al,(%eax)
    8982:	00 00                	add    %al,(%eax)
    8984:	00 00                	add    %al,(%eax)
    8986:	00 00                	add    %al,(%eax)
    8988:	00 00                	add    %al,(%eax)
    898a:	00 00                	add    %al,(%eax)
    898c:	00 00                	add    %al,(%eax)
    898e:	00 00                	add    %al,(%eax)
    8990:	00 00                	add    %al,(%eax)
    8992:	00 00                	add    %al,(%eax)
    8994:	00 00                	add    %al,(%eax)
    8996:	00 00                	add    %al,(%eax)
    8998:	00 00                	add    %al,(%eax)
    899a:	00 00                	add    %al,(%eax)
    899c:	00 00                	add    %al,(%eax)
    899e:	00 00                	add    %al,(%eax)
    89a0:	00 00                	add    %al,(%eax)
    89a2:	00 00                	add    %al,(%eax)
    89a4:	00 00                	add    %al,(%eax)
    89a6:	00 00                	add    %al,(%eax)
    89a8:	00 00                	add    %al,(%eax)
    89aa:	00 00                	add    %al,(%eax)
    89ac:	00 00                	add    %al,(%eax)
    89ae:	00 00                	add    %al,(%eax)
    89b0:	00 00                	add    %al,(%eax)
    89b2:	00 00                	add    %al,(%eax)
    89b4:	00 00                	add    %al,(%eax)
    89b6:	00 00                	add    %al,(%eax)
    89b8:	00 00                	add    %al,(%eax)
    89ba:	00 00                	add    %al,(%eax)
    89bc:	00 00                	add    %al,(%eax)
    89be:	00 00                	add    %al,(%eax)
    89c0:	00 00                	add    %al,(%eax)
    89c2:	00 00                	add    %al,(%eax)
    89c4:	00 00                	add    %al,(%eax)
    89c6:	00 00                	add    %al,(%eax)
    89c8:	00 00                	add    %al,(%eax)
    89ca:	00 00                	add    %al,(%eax)
    89cc:	00 00                	add    %al,(%eax)
    89ce:	00 00                	add    %al,(%eax)
    89d0:	00 00                	add    %al,(%eax)
    89d2:	00 00                	add    %al,(%eax)
    89d4:	00 00                	add    %al,(%eax)
    89d6:	00 00                	add    %al,(%eax)
    89d8:	00 00                	add    %al,(%eax)
    89da:	00 00                	add    %al,(%eax)
    89dc:	00 00                	add    %al,(%eax)
    89de:	00 00                	add    %al,(%eax)
    89e0:	00 00                	add    %al,(%eax)
    89e2:	00 00                	add    %al,(%eax)
    89e4:	00 00                	add    %al,(%eax)
    89e6:	00 00                	add    %al,(%eax)
    89e8:	00 00                	add    %al,(%eax)
    89ea:	00 00                	add    %al,(%eax)
    89ec:	00 00                	add    %al,(%eax)
    89ee:	00 00                	add    %al,(%eax)
    89f0:	00 00                	add    %al,(%eax)
    89f2:	00 00                	add    %al,(%eax)
    89f4:	00 00                	add    %al,(%eax)
    89f6:	00 00                	add    %al,(%eax)
    89f8:	00 00                	add    %al,(%eax)
    89fa:	00 00                	add    %al,(%eax)
    89fc:	00 00                	add    %al,(%eax)
    89fe:	00 00                	add    %al,(%eax)
    8a00:	00 00                	add    %al,(%eax)
    8a02:	00 00                	add    %al,(%eax)
    8a04:	00 00                	add    %al,(%eax)
    8a06:	00 00                	add    %al,(%eax)
    8a08:	00 00                	add    %al,(%eax)
    8a0a:	00 00                	add    %al,(%eax)
    8a0c:	00 00                	add    %al,(%eax)
    8a0e:	00 00                	add    %al,(%eax)
    8a10:	00 00                	add    %al,(%eax)
    8a12:	00 00                	add    %al,(%eax)
    8a14:	00 00                	add    %al,(%eax)
    8a16:	00 00                	add    %al,(%eax)
    8a18:	00 00                	add    %al,(%eax)
    8a1a:	00 00                	add    %al,(%eax)
    8a1c:	00 00                	add    %al,(%eax)
    8a1e:	00 00                	add    %al,(%eax)
    8a20:	00 00                	add    %al,(%eax)
    8a22:	00 00                	add    %al,(%eax)
    8a24:	00 00                	add    %al,(%eax)
    8a26:	00 00                	add    %al,(%eax)
    8a28:	00 00                	add    %al,(%eax)
    8a2a:	00 00                	add    %al,(%eax)
    8a2c:	00 00                	add    %al,(%eax)
    8a2e:	00 00                	add    %al,(%eax)
    8a30:	00 00                	add    %al,(%eax)
    8a32:	00 00                	add    %al,(%eax)
    8a34:	00 00                	add    %al,(%eax)
    8a36:	00 00                	add    %al,(%eax)
    8a38:	00 00                	add    %al,(%eax)
    8a3a:	00 00                	add    %al,(%eax)
    8a3c:	00 00                	add    %al,(%eax)
    8a3e:	00 00                	add    %al,(%eax)
    8a40:	00 00                	add    %al,(%eax)
    8a42:	00 00                	add    %al,(%eax)
    8a44:	00 00                	add    %al,(%eax)
    8a46:	00 00                	add    %al,(%eax)
    8a48:	00 00                	add    %al,(%eax)
    8a4a:	00 00                	add    %al,(%eax)
    8a4c:	00 00                	add    %al,(%eax)
    8a4e:	00 00                	add    %al,(%eax)
    8a50:	00 00                	add    %al,(%eax)
    8a52:	00 00                	add    %al,(%eax)
    8a54:	00 00                	add    %al,(%eax)
    8a56:	00 00                	add    %al,(%eax)
    8a58:	00 00                	add    %al,(%eax)
    8a5a:	00 00                	add    %al,(%eax)
    8a5c:	00 00                	add    %al,(%eax)
    8a5e:	00 00                	add    %al,(%eax)
    8a60:	00 00                	add    %al,(%eax)
    8a62:	00 00                	add    %al,(%eax)
    8a64:	00 00                	add    %al,(%eax)
    8a66:	00 00                	add    %al,(%eax)
    8a68:	00 00                	add    %al,(%eax)
    8a6a:	00 00                	add    %al,(%eax)
    8a6c:	00 00                	add    %al,(%eax)
    8a6e:	00 00                	add    %al,(%eax)
    8a70:	00 00                	add    %al,(%eax)
    8a72:	00 00                	add    %al,(%eax)
    8a74:	00 00                	add    %al,(%eax)
    8a76:	00 00                	add    %al,(%eax)
    8a78:	00 00                	add    %al,(%eax)
    8a7a:	00 00                	add    %al,(%eax)
    8a7c:	00 00                	add    %al,(%eax)
    8a7e:	00 00                	add    %al,(%eax)
    8a80:	00 00                	add    %al,(%eax)
    8a82:	00 00                	add    %al,(%eax)
    8a84:	00 00                	add    %al,(%eax)
    8a86:	00 00                	add    %al,(%eax)
    8a88:	00 00                	add    %al,(%eax)
    8a8a:	00 00                	add    %al,(%eax)
    8a8c:	00 00                	add    %al,(%eax)
    8a8e:	00 00                	add    %al,(%eax)
    8a90:	00 00                	add    %al,(%eax)
    8a92:	00 00                	add    %al,(%eax)
    8a94:	00 00                	add    %al,(%eax)
    8a96:	00 00                	add    %al,(%eax)
    8a98:	00 00                	add    %al,(%eax)
    8a9a:	00 00                	add    %al,(%eax)
    8a9c:	00 00                	add    %al,(%eax)
    8a9e:	00 00                	add    %al,(%eax)
    8aa0:	00 00                	add    %al,(%eax)
    8aa2:	00 00                	add    %al,(%eax)
    8aa4:	00 00                	add    %al,(%eax)
    8aa6:	00 00                	add    %al,(%eax)
    8aa8:	00 00                	add    %al,(%eax)
    8aaa:	00 00                	add    %al,(%eax)
    8aac:	00 00                	add    %al,(%eax)
    8aae:	00 00                	add    %al,(%eax)
    8ab0:	00 00                	add    %al,(%eax)
    8ab2:	00 00                	add    %al,(%eax)
    8ab4:	00 00                	add    %al,(%eax)
    8ab6:	00 00                	add    %al,(%eax)
    8ab8:	00 00                	add    %al,(%eax)
    8aba:	00 00                	add    %al,(%eax)
    8abc:	00 00                	add    %al,(%eax)
    8abe:	00 00                	add    %al,(%eax)
    8ac0:	00 00                	add    %al,(%eax)
    8ac2:	00 00                	add    %al,(%eax)
    8ac4:	00 00                	add    %al,(%eax)
    8ac6:	00 00                	add    %al,(%eax)
    8ac8:	00 00                	add    %al,(%eax)
    8aca:	00 00                	add    %al,(%eax)
    8acc:	00 00                	add    %al,(%eax)
    8ace:	00 00                	add    %al,(%eax)
    8ad0:	00 00                	add    %al,(%eax)
    8ad2:	00 00                	add    %al,(%eax)
    8ad4:	00 00                	add    %al,(%eax)
    8ad6:	00 00                	add    %al,(%eax)
    8ad8:	00 00                	add    %al,(%eax)
    8ada:	00 00                	add    %al,(%eax)
    8adc:	00 00                	add    %al,(%eax)
    8ade:	00 00                	add    %al,(%eax)
    8ae0:	00 00                	add    %al,(%eax)
    8ae2:	00 00                	add    %al,(%eax)
    8ae4:	00 00                	add    %al,(%eax)
    8ae6:	00 00                	add    %al,(%eax)
    8ae8:	00 00                	add    %al,(%eax)
    8aea:	00 00                	add    %al,(%eax)
    8aec:	00 00                	add    %al,(%eax)
    8aee:	00 00                	add    %al,(%eax)
    8af0:	00 00                	add    %al,(%eax)
    8af2:	00 00                	add    %al,(%eax)
    8af4:	00 00                	add    %al,(%eax)
    8af6:	00 00                	add    %al,(%eax)
    8af8:	00 00                	add    %al,(%eax)
    8afa:	00 00                	add    %al,(%eax)
    8afc:	00 00                	add    %al,(%eax)
    8afe:	00 00                	add    %al,(%eax)
    8b00:	00 00                	add    %al,(%eax)
    8b02:	00 00                	add    %al,(%eax)
    8b04:	00 00                	add    %al,(%eax)
    8b06:	00 00                	add    %al,(%eax)
    8b08:	00 00                	add    %al,(%eax)
    8b0a:	00 00                	add    %al,(%eax)
    8b0c:	00 00                	add    %al,(%eax)
    8b0e:	00 00                	add    %al,(%eax)
    8b10:	00 00                	add    %al,(%eax)
    8b12:	00 00                	add    %al,(%eax)
    8b14:	00 00                	add    %al,(%eax)

00008b16 <putc>:
 */
volatile char *video = (volatile char*) 0xB8000;

void
putc (int l, int color, char ch)
{
    8b16:	55                   	push   %ebp
    8b17:	89 e5                	mov    %esp,%ebp
    8b19:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile char * p = video + l * 2;
	* p = ch;
    8b1c:	8b 55 10             	mov    0x10(%ebp),%edx
volatile char *video = (volatile char*) 0xB8000;

void
putc (int l, int color, char ch)
{
	volatile char * p = video + l * 2;
    8b1f:	01 c0                	add    %eax,%eax
    8b21:	03 05 24 92 00 00    	add    0x9224,%eax
	* p = ch;
    8b27:	88 10                	mov    %dl,(%eax)
	* (p + 1) = color;
    8b29:	8b 55 0c             	mov    0xc(%ebp),%edx
    8b2c:	88 50 01             	mov    %dl,0x1(%eax)
}
    8b2f:	5d                   	pop    %ebp
    8b30:	c3                   	ret    

00008b31 <puts>:


int
puts (int r, int c, int color, const char *string)
{
    8b31:	55                   	push   %ebp
    8b32:	89 e5                	mov    %esp,%ebp
    8b34:	53                   	push   %ebx
	int l = r * 80 + c;
    8b35:	6b 45 08 50          	imul   $0x50,0x8(%ebp),%eax
	while (*string != 0)
    8b39:	8b 4d 14             	mov    0x14(%ebp),%ecx


int
puts (int r, int c, int color, const char *string)
{
	int l = r * 80 + c;
    8b3c:	03 45 0c             	add    0xc(%ebp),%eax
	while (*string != 0)
    8b3f:	29 c1                	sub    %eax,%ecx
    8b41:	0f be 14 01          	movsbl (%ecx,%eax,1),%edx
    8b45:	84 d2                	test   %dl,%dl
    8b47:	74 14                	je     8b5d <puts+0x2c>
	{
		putc (l++, color, *string++);
    8b49:	52                   	push   %edx
    8b4a:	8d 58 01             	lea    0x1(%eax),%ebx
    8b4d:	ff 75 10             	pushl  0x10(%ebp)
    8b50:	50                   	push   %eax
    8b51:	e8 c0 ff ff ff       	call   8b16 <putc>
    8b56:	83 c4 0c             	add    $0xc,%esp
    8b59:	89 d8                	mov    %ebx,%eax
    8b5b:	eb e4                	jmp    8b41 <puts+0x10>
	}
	return l;
}
    8b5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    8b60:	c9                   	leave  
    8b61:	c3                   	ret    

00008b62 <putline>:
"                                                                                ";

void
putline (char * s)
{
	puts (row = (row >= CRT_ROWS) ? 0 : row + 1, 0, VGA_CLR_BLACK, blank);
    8b62:	8b 15 c8 92 00 00    	mov    0x92c8,%edx
char * blank =
"                                                                                ";

void
putline (char * s)
{
    8b68:	55                   	push   %ebp
    8b69:	89 e5                	mov    %esp,%ebp
    8b6b:	53                   	push   %ebx
	puts (row = (row >= CRT_ROWS) ? 0 : row + 1, 0, VGA_CLR_BLACK, blank);
    8b6c:	bb 00 00 00 00       	mov    $0x0,%ebx
    8b71:	8d 42 01             	lea    0x1(%edx),%eax
    8b74:	83 fa 18             	cmp    $0x18,%edx
    8b77:	ff 35 20 92 00 00    	pushl  0x9220
    8b7d:	6a 00                	push   $0x0
    8b7f:	6a 00                	push   $0x0
    8b81:	0f 4e d8             	cmovle %eax,%ebx
    8b84:	53                   	push   %ebx
    8b85:	89 1d c8 92 00 00    	mov    %ebx,0x92c8
    8b8b:	e8 a1 ff ff ff       	call   8b31 <puts>
	puts (row, 0, VGA_CLR_WHITE, s);
    8b90:	ff 75 08             	pushl  0x8(%ebp)
    8b93:	6a 0f                	push   $0xf
    8b95:	6a 00                	push   $0x0
    8b97:	53                   	push   %ebx
    8b98:	e8 94 ff ff ff       	call   8b31 <puts>
}
    8b9d:	83 c4 20             	add    $0x20,%esp
    8ba0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    8ba3:	c9                   	leave  
    8ba4:	c3                   	ret    

00008ba5 <roll>:

void
roll (int r)
{
    8ba5:	55                   	push   %ebp
    8ba6:	89 e5                	mov    %esp,%ebp
	row = r;
    8ba8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    8bab:	5d                   	pop    %ebp
}

void
roll (int r)
{
	row = r;
    8bac:	a3 c8 92 00 00       	mov    %eax,0x92c8
}
    8bb1:	c3                   	ret    

00008bb2 <panic>:

void
panic (char * m)
{
    8bb2:	55                   	push   %ebp
    8bb3:	89 e5                	mov    %esp,%ebp
	puts (0, 0, VGA_CLR_RED, m);
    8bb5:	ff 75 08             	pushl  0x8(%ebp)
    8bb8:	6a 04                	push   $0x4
    8bba:	6a 00                	push   $0x0
    8bbc:	6a 00                	push   $0x0
    8bbe:	e8 6e ff ff ff       	call   8b31 <puts>
    8bc3:	83 c4 10             	add    $0x10,%esp
	while (1)
	{
		asm volatile("hlt");
    8bc6:	f4                   	hlt    
    8bc7:	eb fd                	jmp    8bc6 <panic+0x14>

00008bc9 <strlen>:
 * string
 */

int
strlen (const char *s)
{
    8bc9:	55                   	push   %ebp
	int n;

	for (n = 0; *s != '\0'; s++)
    8bca:	31 c0                	xor    %eax,%eax
 * string
 */

int
strlen (const char *s)
{
    8bcc:	89 e5                	mov    %esp,%ebp
    8bce:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
    8bd1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    8bd5:	74 03                	je     8bda <strlen+0x11>
		n++;
    8bd7:	40                   	inc    %eax
    8bd8:	eb f7                	jmp    8bd1 <strlen+0x8>
	return n;
}
    8bda:	5d                   	pop    %ebp
    8bdb:	c3                   	ret    

00008bdc <reverse>:

/* reverse:  reverse string s in place */
void
reverse (char s[])
{
    8bdc:	55                   	push   %ebp
    8bdd:	89 e5                	mov    %esp,%ebp
    8bdf:	56                   	push   %esi
    8be0:	53                   	push   %ebx
    8be1:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, j;
	char c;

	for (i = 0, j = strlen (s) - 1; i < j; i++, j--)
    8be4:	56                   	push   %esi
    8be5:	e8 df ff ff ff       	call   8bc9 <strlen>
    8bea:	5a                   	pop    %edx
    8beb:	48                   	dec    %eax
    8bec:	31 d2                	xor    %edx,%edx
    8bee:	39 c2                	cmp    %eax,%edx
    8bf0:	7d 10                	jge    8c02 <reverse+0x26>
	{
		c = s[i];
    8bf2:	8a 1c 16             	mov    (%esi,%edx,1),%bl
		s[i] = s[j];
    8bf5:	8a 0c 06             	mov    (%esi,%eax,1),%cl
    8bf8:	88 0c 16             	mov    %cl,(%esi,%edx,1)
		s[j] = c;
    8bfb:	88 1c 06             	mov    %bl,(%esi,%eax,1)
reverse (char s[])
{
	int i, j;
	char c;

	for (i = 0, j = strlen (s) - 1; i < j; i++, j--)
    8bfe:	42                   	inc    %edx
    8bff:	48                   	dec    %eax
    8c00:	eb ec                	jmp    8bee <reverse+0x12>
	{
		c = s[i];
		s[i] = s[j];
		s[j] = c;
	}
}
    8c02:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8c05:	5b                   	pop    %ebx
    8c06:	5e                   	pop    %esi
    8c07:	5d                   	pop    %ebp
    8c08:	c3                   	ret    

00008c09 <itox>:

/* itoa:  convert n to characters in s */
void
itox (int n, char s[], int root, char * table)
{
    8c09:	55                   	push   %ebp
    8c0a:	89 e5                	mov    %esp,%ebp
    8c0c:	57                   	push   %edi
    8c0d:	56                   	push   %esi
    8c0e:	53                   	push   %ebx
    8c0f:	31 f6                	xor    %esi,%esi
    8c11:	83 ec 08             	sub    $0x8,%esp
    8c14:	8b 45 08             	mov    0x8(%ebp),%eax
    8c17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    8c1a:	8b 7d 14             	mov    0x14(%ebp),%edi
    8c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    8c20:	8b 45 10             	mov    0x10(%ebp),%eax
    8c23:	8b 55 f0             	mov    -0x10(%ebp),%edx
    8c26:	89 45 ec             	mov    %eax,-0x14(%ebp)
    8c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
    8c2c:	c1 fa 1f             	sar    $0x1f,%edx
    8c2f:	31 d0                	xor    %edx,%eax
    8c31:	29 d0                	sub    %edx,%eax
	if ((sign = n) < 0) /* record sign */
		n = -n; /* make n positive */
	i = 0;
	do
	{ /* generate digits in reverse order */
		s[i++] = table[n % root]; /* get next digit */
    8c33:	99                   	cltd   
    8c34:	8d 4e 01             	lea    0x1(%esi),%ecx
    8c37:	f7 7d ec             	idivl  -0x14(%ebp)
    8c3a:	8a 14 17             	mov    (%edi,%edx,1),%dl
	} while ((n /= root) > 0); /* delete it */
    8c3d:	85 c0                	test   %eax,%eax
	if ((sign = n) < 0) /* record sign */
		n = -n; /* make n positive */
	i = 0;
	do
	{ /* generate digits in reverse order */
		s[i++] = table[n % root]; /* get next digit */
    8c3f:	88 54 0b ff          	mov    %dl,-0x1(%ebx,%ecx,1)
    8c43:	89 ca                	mov    %ecx,%edx
	} while ((n /= root) > 0); /* delete it */
    8c45:	7e 04                	jle    8c4b <itox+0x42>
	if ((sign = n) < 0) /* record sign */
		n = -n; /* make n positive */
	i = 0;
	do
	{ /* generate digits in reverse order */
		s[i++] = table[n % root]; /* get next digit */
    8c47:	89 ce                	mov    %ecx,%esi
    8c49:	eb e8                	jmp    8c33 <itox+0x2a>
	} while ((n /= root) > 0); /* delete it */
	if (sign < 0)
    8c4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    8c4f:	79 07                	jns    8c58 <itox+0x4f>
		s[i++] = '-';
    8c51:	8d 4e 02             	lea    0x2(%esi),%ecx
    8c54:	c6 04 13 2d          	movb   $0x2d,(%ebx,%edx,1)
	s[i] = '\0';
    8c58:	c6 04 0b 00          	movb   $0x0,(%ebx,%ecx,1)
	reverse (s);
    8c5c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
    8c5f:	58                   	pop    %eax
    8c60:	5a                   	pop    %edx
    8c61:	5b                   	pop    %ebx
    8c62:	5e                   	pop    %esi
    8c63:	5f                   	pop    %edi
    8c64:	5d                   	pop    %ebp
		s[i++] = table[n % root]; /* get next digit */
	} while ((n /= root) > 0); /* delete it */
	if (sign < 0)
		s[i++] = '-';
	s[i] = '\0';
	reverse (s);
    8c65:	e9 72 ff ff ff       	jmp    8bdc <reverse>

00008c6a <itoa>:
}

void
itoa (int n, char s[])
{
    8c6a:	55                   	push   %ebp
    8c6b:	89 e5                	mov    %esp,%ebp
	static char dec[] = "0123456789";
	itox(n, s, 10, dec);
    8c6d:	68 14 92 00 00       	push   $0x9214
    8c72:	6a 0a                	push   $0xa
    8c74:	ff 75 0c             	pushl  0xc(%ebp)
    8c77:	ff 75 08             	pushl  0x8(%ebp)
    8c7a:	e8 8a ff ff ff       	call   8c09 <itox>
}
    8c7f:	83 c4 10             	add    $0x10,%esp
    8c82:	c9                   	leave  
    8c83:	c3                   	ret    

00008c84 <itoh>:


void
itoh (int n, char* s)
{
    8c84:	55                   	push   %ebp
    8c85:	89 e5                	mov    %esp,%ebp
	static char hex[] = "0123456789abcdef";
	itox(n, s, 16, hex);
    8c87:	68 00 92 00 00       	push   $0x9200
    8c8c:	6a 10                	push   $0x10
    8c8e:	ff 75 0c             	pushl  0xc(%ebp)
    8c91:	ff 75 08             	pushl  0x8(%ebp)
    8c94:	e8 70 ff ff ff       	call   8c09 <itox>
}
    8c99:	83 c4 10             	add    $0x10,%esp
    8c9c:	c9                   	leave  
    8c9d:	c3                   	ret    

00008c9e <puti>:

static char puti_str[40];

void
puti (int32_t i)
{
    8c9e:	55                   	push   %ebp
    8c9f:	89 e5                	mov    %esp,%ebp
	itoh (i, puti_str);
    8ca1:	68 a0 92 00 00       	push   $0x92a0
    8ca6:	ff 75 08             	pushl  0x8(%ebp)
    8ca9:	e8 d6 ff ff ff       	call   8c84 <itoh>
	putline (puti_str);
    8cae:	58                   	pop    %eax
    8caf:	5a                   	pop    %edx
    8cb0:	c7 45 08 a0 92 00 00 	movl   $0x92a0,0x8(%ebp)
}
    8cb7:	c9                   	leave  

void
puti (int32_t i)
{
	itoh (i, puti_str);
	putline (puti_str);
    8cb8:	e9 a5 fe ff ff       	jmp    8b62 <putline>

00008cbd <readsector>:
		/* do nothing */;
}

void
readsector (void *dst, uint32_t offset)
{
    8cbd:	55                   	push   %ebp

static inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    8cbe:	ba f7 01 00 00       	mov    $0x1f7,%edx
    8cc3:	89 e5                	mov    %esp,%ebp
    8cc5:	57                   	push   %edi
    8cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    8cc9:	ec                   	in     (%dx),%al
 */
static void
waitdisk (void)
{
	// wait for disk reaady
	while ((inb (0x1F7) & 0xC0) != 0x40)
    8cca:	83 e0 c0             	and    $0xffffffc0,%eax
    8ccd:	3c 40                	cmp    $0x40,%al
    8ccf:	75 f8                	jne    8cc9 <readsector+0xc>
 * x86 instructions
 */
static inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
    8cd1:	ba f2 01 00 00       	mov    $0x1f2,%edx
    8cd6:	b0 01                	mov    $0x1,%al
    8cd8:	ee                   	out    %al,(%dx)
    8cd9:	ba f3 01 00 00       	mov    $0x1f3,%edx
    8cde:	88 c8                	mov    %cl,%al
    8ce0:	ee                   	out    %al,(%dx)
    8ce1:	89 c8                	mov    %ecx,%eax
    8ce3:	ba f4 01 00 00       	mov    $0x1f4,%edx
    8ce8:	c1 e8 08             	shr    $0x8,%eax
    8ceb:	ee                   	out    %al,(%dx)
    8cec:	89 c8                	mov    %ecx,%eax
    8cee:	ba f5 01 00 00       	mov    $0x1f5,%edx
    8cf3:	c1 e8 10             	shr    $0x10,%eax
    8cf6:	ee                   	out    %al,(%dx)
    8cf7:	89 c8                	mov    %ecx,%eax
    8cf9:	ba f6 01 00 00       	mov    $0x1f6,%edx
    8cfe:	c1 e8 18             	shr    $0x18,%eax
    8d01:	83 c8 e0             	or     $0xffffffe0,%eax
    8d04:	ee                   	out    %al,(%dx)
    8d05:	ba f7 01 00 00       	mov    $0x1f7,%edx
    8d0a:	b0 20                	mov    $0x20,%al
    8d0c:	ee                   	out    %al,(%dx)

static inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    8d0d:	ec                   	in     (%dx),%al
    8d0e:	83 e0 c0             	and    $0xffffffc0,%eax
    8d11:	3c 40                	cmp    $0x40,%al
    8d13:	75 f8                	jne    8d0d <readsector+0x50>
}

static inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
    8d15:	8b 7d 08             	mov    0x8(%ebp),%edi
    8d18:	b9 80 00 00 00       	mov    $0x80,%ecx
    8d1d:	ba f0 01 00 00       	mov    $0x1f0,%edx
    8d22:	fc                   	cld    
    8d23:	f2 6d                	repnz insl (%dx),%es:(%edi)
	// wait for disk to be ready
	waitdisk ();

	// read a sector
	insl (0x1F0, dst, SECTOR_SIZE / 4);
}
    8d25:	5f                   	pop    %edi
    8d26:	5d                   	pop    %ebp
    8d27:	c3                   	ret    

00008d28 <readsection>:

// Read 'count' bytes at 'offset' from kernel into virtual address 'va'.
// Might copy more than asked
void
readsection (uint32_t va, uint32_t count, uint32_t offset, uint32_t lba)
{
    8d28:	55                   	push   %ebp
    8d29:	89 e5                	mov    %esp,%ebp
    8d2b:	57                   	push   %edi
    8d2c:	56                   	push   %esi
    8d2d:	53                   	push   %ebx
    8d2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	end_va = va + count;
	// round down to sector boundary
	va &= ~(SECTOR_SIZE - 1);

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTOR_SIZE) + lba;
    8d31:	8b 7d 10             	mov    0x10(%ebp),%edi
readsection (uint32_t va, uint32_t count, uint32_t offset, uint32_t lba)
{
	uint32_t end_va;

	va &= 0xFFFFFF;
	end_va = va + count;
    8d34:	89 de                	mov    %ebx,%esi
	// round down to sector boundary
	va &= ~(SECTOR_SIZE - 1);
    8d36:	81 e3 00 fe ff 00    	and    $0xfffe00,%ebx
readsection (uint32_t va, uint32_t count, uint32_t offset, uint32_t lba)
{
	uint32_t end_va;

	va &= 0xFFFFFF;
	end_va = va + count;
    8d3c:	81 e6 ff ff ff 00    	and    $0xffffff,%esi
	// round down to sector boundary
	va &= ~(SECTOR_SIZE - 1);

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTOR_SIZE) + lba;
    8d42:	c1 ef 09             	shr    $0x9,%edi
readsection (uint32_t va, uint32_t count, uint32_t offset, uint32_t lba)
{
	uint32_t end_va;

	va &= 0xFFFFFF;
	end_va = va + count;
    8d45:	03 75 0c             	add    0xc(%ebp),%esi
	// round down to sector boundary
	va &= ~(SECTOR_SIZE - 1);

	// translate from bytes to sectors, and kernel starts at sector 1
	offset = (offset / SECTOR_SIZE) + lba;
    8d48:	03 7d 14             	add    0x14(%ebp),%edi

	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (va < end_va)
    8d4b:	39 f3                	cmp    %esi,%ebx
    8d4d:	73 12                	jae    8d61 <readsection+0x39>
	{
		readsector ((uint8_t*) va, offset);
    8d4f:	57                   	push   %edi
    8d50:	53                   	push   %ebx
		va += SECTOR_SIZE;
		offset++;
    8d51:	47                   	inc    %edi
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (va < end_va)
	{
		readsector ((uint8_t*) va, offset);
		va += SECTOR_SIZE;
    8d52:	81 c3 00 02 00 00    	add    $0x200,%ebx
	// If this is too slow, we could read lots of sectors at a time.
	// We'd write more to memory than asked, but it doesn't matter --
	// we load in increasing order.
	while (va < end_va)
	{
		readsector ((uint8_t*) va, offset);
    8d58:	e8 60 ff ff ff       	call   8cbd <readsector>
		va += SECTOR_SIZE;
		offset++;
    8d5d:	58                   	pop    %eax
    8d5e:	5a                   	pop    %edx
    8d5f:	eb ea                	jmp    8d4b <readsection+0x23>
	}
}
    8d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8d64:	5b                   	pop    %ebx
    8d65:	5e                   	pop    %esi
    8d66:	5f                   	pop    %edi
    8d67:	5d                   	pop    %ebp
    8d68:	c3                   	ret    

00008d69 <load_kernel>:

#define ELFHDR      ((elfhdr *) 0x20000)

uint32_t
load_kernel(uint32_t dkernel) // dkernel is the first_lba field of the partition table entry of the bootable partition
{
    8d69:	55                   	push   %ebp
    8d6a:	89 e5                	mov    %esp,%ebp
    8d6c:	57                   	push   %edi
    8d6d:	56                   	push   %esi
    8d6e:	53                   	push   %ebx
    8d6f:	83 ec 0c             	sub    $0xc,%esp
    8d72:	8b 7d 08             	mov    0x8(%ebp),%edi
    // load kernel from the beginning of the first bootable partition
    proghdr *ph, *eph;

    readsection((uint32_t) ELFHDR, SECTOR_SIZE * 8, 0, dkernel);
    8d75:	57                   	push   %edi
    8d76:	6a 00                	push   $0x0
    8d78:	68 00 10 00 00       	push   $0x1000
    8d7d:	68 00 00 02 00       	push   $0x20000
    8d82:	e8 a1 ff ff ff       	call   8d28 <readsection>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC)
    8d87:	83 c4 10             	add    $0x10,%esp
    8d8a:	81 3d 00 00 02 00 7f 	cmpl   $0x464c457f,0x20000
    8d91:	45 4c 46 
    8d94:	74 10                	je     8da6 <load_kernel+0x3d>
        panic ("Kernel is not a valid elf.");
    8d96:	83 ec 0c             	sub    $0xc,%esp
    8d99:	68 27 8f 00 00       	push   $0x8f27
    8d9e:	e8 0f fe ff ff       	call   8bb2 <panic>
    8da3:	83 c4 10             	add    $0x10,%esp

    // load each program segment (ignores ph flags)

    ph = (proghdr * )((uint8_t * )ELFHDR + ELFHDR->e_phoff);

    ph = (proghdr * )((uint8_t * )ELFHDR + ELFHDR->e_phoff);
    8da6:	a1 1c 00 02 00       	mov    0x2001c,%eax

    eph = ph + ELFHDR->e_phnum;
    8dab:	0f b7 35 2c 00 02 00 	movzwl 0x2002c,%esi

    // load each program segment (ignores ph flags)

    ph = (proghdr * )((uint8_t * )ELFHDR + ELFHDR->e_phoff);

    ph = (proghdr * )((uint8_t * )ELFHDR + ELFHDR->e_phoff);
    8db2:	8d 98 00 00 02 00    	lea    0x20000(%eax),%ebx

    eph = ph + ELFHDR->e_phnum;
    8db8:	c1 e6 05             	shl    $0x5,%esi
    8dbb:	01 de                	add    %ebx,%esi

    for (; ph < eph; ph++)
    8dbd:	39 f3                	cmp    %esi,%ebx
    8dbf:	73 17                	jae    8dd8 <load_kernel+0x6f>
    {
        readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    8dc1:	57                   	push   %edi
    8dc2:	ff 73 04             	pushl  0x4(%ebx)

    ph = (proghdr * )((uint8_t * )ELFHDR + ELFHDR->e_phoff);

    eph = ph + ELFHDR->e_phnum;

    for (; ph < eph; ph++)
    8dc5:	83 c3 20             	add    $0x20,%ebx
    {
        readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    8dc8:	ff 73 f4             	pushl  -0xc(%ebx)
    8dcb:	ff 73 e8             	pushl  -0x18(%ebx)
    8dce:	e8 55 ff ff ff       	call   8d28 <readsection>

    ph = (proghdr * )((uint8_t * )ELFHDR + ELFHDR->e_phoff);

    eph = ph + ELFHDR->e_phnum;

    for (; ph < eph; ph++)
    8dd3:	83 c4 10             	add    $0x10,%esp
    8dd6:	eb e5                	jmp    8dbd <load_kernel+0x54>
    {
        readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    }

    return (ELFHDR->e_entry & 0xFFFFFF);
    8dd8:	a1 18 00 02 00       	mov    0x20018,%eax
}
    8ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    8de0:	5b                   	pop    %ebx
    for (; ph < eph; ph++)
    {
        readsection(ph->p_va, ph->p_memsz, ph->p_offset, dkernel);
    }

    return (ELFHDR->e_entry & 0xFFFFFF);
    8de1:	25 ff ff ff 00       	and    $0xffffff,%eax
}
    8de6:	5e                   	pop    %esi
    8de7:	5f                   	pop    %edi
    8de8:	5d                   	pop    %ebp
    8de9:	c3                   	ret    

00008dea <parse_e820>:

mboot_info_t *
parse_e820 (bios_smap_t *smap)
{
    8dea:	55                   	push   %ebp
    8deb:	89 e5                	mov    %esp,%ebp
    8ded:	56                   	push   %esi
    8dee:	53                   	push   %ebx
    8def:	8b 75 08             	mov    0x8(%ebp),%esi
    bios_smap_t *p;
    uint32_t mmap_len;
    p = smap;
    mmap_len = 0;
    putline ("* E820 Memory Map *");
    8df2:	83 ec 0c             	sub    $0xc,%esp
    8df5:	68 42 8f 00 00       	push   $0x8f42
mboot_info_t *
parse_e820 (bios_smap_t *smap)
{
    bios_smap_t *p;
    uint32_t mmap_len;
    p = smap;
    8dfa:	89 f3                	mov    %esi,%ebx
    mmap_len = 0;
    putline ("* E820 Memory Map *");
    8dfc:	e8 61 fd ff ff       	call   8b62 <putline>
    while (p->base_addr != 0 || p->length != 0 || p->type != 0)
    8e01:	83 c4 10             	add    $0x10,%esp
    8e04:	8b 43 04             	mov    0x4(%ebx),%eax
    8e07:	89 da                	mov    %ebx,%edx
    8e09:	29 f2                	sub    %esi,%edx
    8e0b:	89 c1                	mov    %eax,%ecx
    8e0d:	0b 4b 08             	or     0x8(%ebx),%ecx
    8e10:	74 11                	je     8e23 <parse_e820+0x39>
    {
        puti (p->base_addr);
    8e12:	83 ec 0c             	sub    $0xc,%esp
        p ++;
    8e15:	83 c3 18             	add    $0x18,%ebx
    p = smap;
    mmap_len = 0;
    putline ("* E820 Memory Map *");
    while (p->base_addr != 0 || p->length != 0 || p->type != 0)
    {
        puti (p->base_addr);
    8e18:	50                   	push   %eax
    8e19:	e8 80 fe ff ff       	call   8c9e <puti>
        p ++;
    8e1e:	83 c4 10             	add    $0x10,%esp
    8e21:	eb e1                	jmp    8e04 <parse_e820+0x1a>
    bios_smap_t *p;
    uint32_t mmap_len;
    p = smap;
    mmap_len = 0;
    putline ("* E820 Memory Map *");
    while (p->base_addr != 0 || p->length != 0 || p->type != 0)
    8e23:	8b 4b 10             	mov    0x10(%ebx),%ecx
    8e26:	0b 4b 0c             	or     0xc(%ebx),%ecx
    8e29:	75 e7                	jne    8e12 <parse_e820+0x28>
    8e2b:	83 7b 14 00          	cmpl   $0x0,0x14(%ebx)
    8e2f:	75 e1                	jne    8e12 <parse_e820+0x28>
        puti (p->base_addr);
        p ++;
        mmap_len += sizeof(bios_smap_t);
    }
    mboot_info.mmap_length = mmap_len;
    mboot_info.mmap_addr = (uint32_t) smap;
    8e31:	89 35 70 92 00 00    	mov    %esi,0x9270
    {
        puti (p->base_addr);
        p ++;
        mmap_len += sizeof(bios_smap_t);
    }
    mboot_info.mmap_length = mmap_len;
    8e37:	89 15 6c 92 00 00    	mov    %edx,0x926c
    mboot_info.mmap_addr = (uint32_t) smap;
    return &mboot_info;
}
    8e3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8e40:	b8 40 92 00 00       	mov    $0x9240,%eax
    8e45:	5b                   	pop    %ebx
    8e46:	5e                   	pop    %esi
    8e47:	5d                   	pop    %ebp
    8e48:	c3                   	ret    

00008e49 <boot1main>:
 *  bios_smap_t *smap: the detected physical memory map
 *
 */
void
boot1main (mbr_t * mbr, bios_smap_t *smap)
{
    8e49:	55                   	push   %ebp
    8e4a:	89 e5                	mov    %esp,%ebp
    8e4c:	56                   	push   %esi
    8e4d:	53                   	push   %ebx
    8e4e:	8b 75 08             	mov    0x8(%ebp),%esi
    8e51:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    /* Roll sets the row we will print on for the VGA, this function is defined in the provided, boot1lib files. */
    roll(2);
    8e54:	83 ec 0c             	sub    $0xc,%esp
    8e57:	6a 02                	push   $0x2
    8e59:	e8 47 fd ff ff       	call   8ba5 <roll>
    /* Since we can't use the standard C library yet, we have to directly print to the VGA to get printed output.*/
    putline("Start boot1 main ...");
    8e5e:	c7 04 24 56 8f 00 00 	movl   $0x8f56,(%esp)
    8e65:	e8 f8 fc ff ff       	call   8b62 <putline>
    8e6a:	83 c4 10             	add    $0x10,%esp

    int i = 0;
    int length = sizeof(mbr->partition) / (sizeof(mbr->partition[0])); // size of the array
    int isbootable = 0;  // a boolean value to check if there is a bootable partition
    for (i = 0; i < length; i++) {
    8e6d:	31 c0                	xor    %eax,%eax
        if (mbr->partition[i].bootable == BOOTABLE_PARTITION) {
    8e6f:	89 c2                	mov    %eax,%edx
    8e71:	c1 e2 04             	shl    $0x4,%edx
    8e74:	80 bc 16 be 01 00 00 	cmpb   $0x80,0x1be(%esi,%edx,1)
    8e7b:	80 
    8e7c:	74 18                	je     8e96 <boot1main+0x4d>
    putline("Start boot1 main ...");

    int i = 0;
    int length = sizeof(mbr->partition) / (sizeof(mbr->partition[0])); // size of the array
    int isbootable = 0;  // a boolean value to check if there is a bootable partition
    for (i = 0; i < length; i++) {
    8e7e:	40                   	inc    %eax
    8e7f:	83 f8 04             	cmp    $0x4,%eax
    8e82:	75 eb                	jne    8e6f <boot1main+0x26>
    /* exec_kernel should never return */


    else

    panic ("Fail to load kernel.");
    8e84:	c7 45 08 6b 8f 00 00 	movl   $0x8f6b,0x8(%ebp)
}
    8e8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8e8e:	5b                   	pop    %ebx
    8e8f:	5e                   	pop    %esi
    8e90:	5d                   	pop    %ebp
    /* exec_kernel should never return */


    else

    panic ("Fail to load kernel.");
    8e91:	e9 1c fd ff ff       	jmp    8bb2 <panic>
     *  Utilize them to implement the functionality of boot1main described above.
     */


    if (isbootable == 1) {
        uint32_t loaded_kernel = load_kernel(mbr->partition[i].first_lba);   // get the loaded kernel
    8e96:	83 c0 1b             	add    $0x1b,%eax
    8e99:	83 ec 0c             	sub    $0xc,%esp
    8e9c:	c1 e0 04             	shl    $0x4,%eax
    8e9f:	ff 74 06 16          	pushl  0x16(%esi,%eax,1)
    8ea3:	e8 c1 fe ff ff       	call   8d69 <load_kernel>
    8ea8:	89 c6                	mov    %eax,%esi
        mboot_info_t *parsed_smap = parse_e820(smap);          // get physical map info
    8eaa:	89 1c 24             	mov    %ebx,(%esp)
    8ead:	e8 38 ff ff ff       	call   8dea <parse_e820>
        exec_kernel(loaded_kernel, parsed_smap);            // execute the kernel
    8eb2:	89 75 08             	mov    %esi,0x8(%ebp)
    8eb5:	89 45 0c             	mov    %eax,0xc(%ebp)
    8eb8:	83 c4 10             	add    $0x10,%esp


    else

    panic ("Fail to load kernel.");
}
    8ebb:	8d 65 f8             	lea    -0x8(%ebp),%esp
    8ebe:	5b                   	pop    %ebx
    8ebf:	5e                   	pop    %esi
    8ec0:	5d                   	pop    %ebp


    if (isbootable == 1) {
        uint32_t loaded_kernel = load_kernel(mbr->partition[i].first_lba);   // get the loaded kernel
        mboot_info_t *parsed_smap = parse_e820(smap);          // get physical map info
        exec_kernel(loaded_kernel, parsed_smap);            // execute the kernel
    8ec1:	e9 00 00 00 00       	jmp    8ec6 <exec_kernel>

00008ec6 <exec_kernel>:
	.set  MBOOT_INFO_MAGIC, 0x2badb002

	.globl	exec_kernel
	.code32
exec_kernel:
	cli
    8ec6:	fa                   	cli    
	movl	$MBOOT_INFO_MAGIC, %eax
    8ec7:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
	movl	8(%esp), %ebx
    8ecc:	8b 5c 24 08          	mov    0x8(%esp),%ebx
	movl	4(%esp), %edx
    8ed0:	8b 54 24 04          	mov    0x4(%esp),%edx
	jmp	*%edx
    8ed4:	ff e2                	jmp    *%edx

Disassembly of section .rodata:

00008ed6 <.rodata>:
    8ed6:	20 20                	and    %ah,(%eax)
    8ed8:	20 20                	and    %ah,(%eax)
    8eda:	20 20                	and    %ah,(%eax)
    8edc:	20 20                	and    %ah,(%eax)
    8ede:	20 20                	and    %ah,(%eax)
    8ee0:	20 20                	and    %ah,(%eax)
    8ee2:	20 20                	and    %ah,(%eax)
    8ee4:	20 20                	and    %ah,(%eax)
    8ee6:	20 20                	and    %ah,(%eax)
    8ee8:	20 20                	and    %ah,(%eax)
    8eea:	20 20                	and    %ah,(%eax)
    8eec:	20 20                	and    %ah,(%eax)
    8eee:	20 20                	and    %ah,(%eax)
    8ef0:	20 20                	and    %ah,(%eax)
    8ef2:	20 20                	and    %ah,(%eax)
    8ef4:	20 20                	and    %ah,(%eax)
    8ef6:	20 20                	and    %ah,(%eax)
    8ef8:	20 20                	and    %ah,(%eax)
    8efa:	20 20                	and    %ah,(%eax)
    8efc:	20 20                	and    %ah,(%eax)
    8efe:	20 20                	and    %ah,(%eax)
    8f00:	20 20                	and    %ah,(%eax)
    8f02:	20 20                	and    %ah,(%eax)
    8f04:	20 20                	and    %ah,(%eax)
    8f06:	20 20                	and    %ah,(%eax)
    8f08:	20 20                	and    %ah,(%eax)
    8f0a:	20 20                	and    %ah,(%eax)
    8f0c:	20 20                	and    %ah,(%eax)
    8f0e:	20 20                	and    %ah,(%eax)
    8f10:	20 20                	and    %ah,(%eax)
    8f12:	20 20                	and    %ah,(%eax)
    8f14:	20 20                	and    %ah,(%eax)
    8f16:	20 20                	and    %ah,(%eax)
    8f18:	20 20                	and    %ah,(%eax)
    8f1a:	20 20                	and    %ah,(%eax)
    8f1c:	20 20                	and    %ah,(%eax)
    8f1e:	20 20                	and    %ah,(%eax)
    8f20:	20 20                	and    %ah,(%eax)
    8f22:	20 20                	and    %ah,(%eax)
    8f24:	20 20                	and    %ah,(%eax)
    8f26:	00 4b 65             	add    %cl,0x65(%ebx)
    8f29:	72 6e                	jb     8f99 <exec_kernel+0xd3>
    8f2b:	65 6c                	gs insb (%dx),%es:(%edi)
    8f2d:	20 69 73             	and    %ch,0x73(%ecx)
    8f30:	20 6e 6f             	and    %ch,0x6f(%esi)
    8f33:	74 20                	je     8f55 <exec_kernel+0x8f>
    8f35:	61                   	popa   
    8f36:	20 76 61             	and    %dh,0x61(%esi)
    8f39:	6c                   	insb   (%dx),%es:(%edi)
    8f3a:	69 64 20 65 6c 66 2e 	imul   $0x2e666c,0x65(%eax,%eiz,1),%esp
    8f41:	00 
    8f42:	2a 20                	sub    (%eax),%ah
    8f44:	45                   	inc    %ebp
    8f45:	38 32                	cmp    %dh,(%edx)
    8f47:	30 20                	xor    %ah,(%eax)
    8f49:	4d                   	dec    %ebp
    8f4a:	65 6d                	gs insl (%dx),%es:(%edi)
    8f4c:	6f                   	outsl  %ds:(%esi),(%dx)
    8f4d:	72 79                	jb     8fc8 <exec_kernel+0x102>
    8f4f:	20 4d 61             	and    %cl,0x61(%ebp)
    8f52:	70 20                	jo     8f74 <exec_kernel+0xae>
    8f54:	2a 00                	sub    (%eax),%al
    8f56:	53                   	push   %ebx
    8f57:	74 61                	je     8fba <exec_kernel+0xf4>
    8f59:	72 74                	jb     8fcf <exec_kernel+0x109>
    8f5b:	20 62 6f             	and    %ah,0x6f(%edx)
    8f5e:	6f                   	outsl  %ds:(%esi),(%dx)
    8f5f:	74 31                	je     8f92 <exec_kernel+0xcc>
    8f61:	20 6d 61             	and    %ch,0x61(%ebp)
    8f64:	69 6e 20 2e 2e 2e 00 	imul   $0x2e2e2e,0x20(%esi),%ebp
    8f6b:	46                   	inc    %esi
    8f6c:	61                   	popa   
    8f6d:	69 6c 20 74 6f 20 6c 	imul   $0x6f6c206f,0x74(%eax,%eiz,1),%ebp
    8f74:	6f 
    8f75:	61                   	popa   
    8f76:	64 20 6b 65          	and    %ch,%fs:0x65(%ebx)
    8f7a:	72 6e                	jb     8fea <exec_kernel+0x124>
    8f7c:	65 6c                	gs insb (%dx),%es:(%edi)
    8f7e:	2e                   	cs
    8f7f:	00                   	.byte 0x0

Disassembly of section .eh_frame:

00008f80 <.eh_frame>:
    8f80:	14 00                	adc    $0x0,%al
    8f82:	00 00                	add    %al,(%eax)
    8f84:	00 00                	add    %al,(%eax)
    8f86:	00 00                	add    %al,(%eax)
    8f88:	01 7a 52             	add    %edi,0x52(%edx)
    8f8b:	00 01                	add    %al,(%ecx)
    8f8d:	7c 08                	jl     8f97 <exec_kernel+0xd1>
    8f8f:	01 1b                	add    %ebx,(%ebx)
    8f91:	0c 04                	or     $0x4,%al
    8f93:	04 88                	add    $0x88,%al
    8f95:	01 00                	add    %eax,(%eax)
    8f97:	00 1c 00             	add    %bl,(%eax,%eax,1)
    8f9a:	00 00                	add    %al,(%eax)
    8f9c:	1c 00                	sbb    $0x0,%al
    8f9e:	00 00                	add    %al,(%eax)
    8fa0:	76 fb                	jbe    8f9d <exec_kernel+0xd7>
    8fa2:	ff                   	(bad)  
    8fa3:	ff 1b                	lcall  *(%ebx)
    8fa5:	00 00                	add    %al,(%eax)
    8fa7:	00 00                	add    %al,(%eax)
    8fa9:	41                   	inc    %ecx
    8faa:	0e                   	push   %cs
    8fab:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    8fb1:	57                   	push   %edi
    8fb2:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    8fb5:	04 00                	add    $0x0,%al
    8fb7:	00 20                	add    %ah,(%eax)
    8fb9:	00 00                	add    %al,(%eax)
    8fbb:	00 3c 00             	add    %bh,(%eax,%eax,1)
    8fbe:	00 00                	add    %al,(%eax)
    8fc0:	71 fb                	jno    8fbd <exec_kernel+0xf7>
    8fc2:	ff                   	(bad)  
    8fc3:	ff 31                	pushl  (%ecx)
    8fc5:	00 00                	add    %al,(%eax)
    8fc7:	00 00                	add    %al,(%eax)
    8fc9:	41                   	inc    %ecx
    8fca:	0e                   	push   %cs
    8fcb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    8fd1:	41                   	inc    %ecx
    8fd2:	83 03 6c             	addl   $0x6c,(%ebx)
    8fd5:	c5 c3 0c             	(bad)  
    8fd8:	04 04                	add    $0x4,%al
    8fda:	00 00                	add    %al,(%eax)
    8fdc:	20 00                	and    %al,(%eax)
    8fde:	00 00                	add    %al,(%eax)
    8fe0:	60                   	pusha  
    8fe1:	00 00                	add    %al,(%eax)
    8fe3:	00 7e fb             	add    %bh,-0x5(%esi)
    8fe6:	ff                   	(bad)  
    8fe7:	ff 43 00             	incl   0x0(%ebx)
    8fea:	00 00                	add    %al,(%eax)
    8fec:	00 47 0e             	add    %al,0xe(%edi)
    8fef:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    8ff5:	41                   	inc    %ecx
    8ff6:	83 03 78             	addl   $0x78,(%ebx)
    8ff9:	c5 c3 0c             	(bad)  
    8ffc:	04 04                	add    $0x4,%al
    8ffe:	00 00                	add    %al,(%eax)
    9000:	1c 00                	sbb    $0x0,%al
    9002:	00 00                	add    %al,(%eax)
    9004:	84 00                	test   %al,(%eax)
    9006:	00 00                	add    %al,(%eax)
    9008:	9d                   	popf   
    9009:	fb                   	sti    
    900a:	ff                   	(bad)  
    900b:	ff 0d 00 00 00 00    	decl   0x0
    9011:	41                   	inc    %ecx
    9012:	0e                   	push   %cs
    9013:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9019:	44                   	inc    %esp
    901a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    901d:	04 00                	add    $0x0,%al
    901f:	00 18                	add    %bl,(%eax)
    9021:	00 00                	add    %al,(%eax)
    9023:	00 a4 00 00 00 8a fb 	add    %ah,-0x4760000(%eax,%eax,1)
    902a:	ff                   	(bad)  
    902b:	ff 17                	call   *(%edi)
    902d:	00 00                	add    %al,(%eax)
    902f:	00 00                	add    %al,(%eax)
    9031:	41                   	inc    %ecx
    9032:	0e                   	push   %cs
    9033:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9039:	00 00                	add    %al,(%eax)
    903b:	00 1c 00             	add    %bl,(%eax,%eax,1)
    903e:	00 00                	add    %al,(%eax)
    9040:	c0 00 00             	rolb   $0x0,(%eax)
    9043:	00 85 fb ff ff 13    	add    %al,0x13fffffb(%ebp)
    9049:	00 00                	add    %al,(%eax)
    904b:	00 00                	add    %al,(%eax)
    904d:	41                   	inc    %ecx
    904e:	0e                   	push   %cs
    904f:	08 85 02 44 0d 05    	or     %al,0x50d4402(%ebp)
    9055:	4d                   	dec    %ebp
    9056:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9059:	04 00                	add    $0x0,%al
    905b:	00 24 00             	add    %ah,(%eax,%eax,1)
    905e:	00 00                	add    %al,(%eax)
    9060:	e0 00                	loopne 9062 <exec_kernel+0x19c>
    9062:	00 00                	add    %al,(%eax)
    9064:	78 fb                	js     9061 <exec_kernel+0x19b>
    9066:	ff                   	(bad)  
    9067:	ff 2d 00 00 00 00    	ljmp   *0x0
    906d:	41                   	inc    %ecx
    906e:	0e                   	push   %cs
    906f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9075:	42                   	inc    %edx
    9076:	86 03                	xchg   %al,(%ebx)
    9078:	83 04 65 c3 41 c6 41 	addl   $0xffffffc5,0x41c641c3(,%eiz,2)
    907f:	c5 
    9080:	0c 04                	or     $0x4,%al
    9082:	04 00                	add    $0x0,%al
    9084:	28 00                	sub    %al,(%eax)
    9086:	00 00                	add    %al,(%eax)
    9088:	08 01                	or     %al,(%ecx)
    908a:	00 00                	add    %al,(%eax)
    908c:	7d fb                	jge    9089 <exec_kernel+0x1c3>
    908e:	ff                   	(bad)  
    908f:	ff 61 00             	jmp    *0x0(%ecx)
    9092:	00 00                	add    %al,(%eax)
    9094:	00 41 0e             	add    %al,0xe(%ecx)
    9097:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    909d:	43                   	inc    %ebx
    909e:	87 03                	xchg   %eax,(%ebx)
    90a0:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    90a3:	05 02 53 c3 41       	add    $0x41c35302,%eax
    90a8:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
    90ac:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    90af:	04 1c                	add    $0x1c,%al
    90b1:	00 00                	add    %al,(%eax)
    90b3:	00 34 01             	add    %dh,(%ecx,%eax,1)
    90b6:	00 00                	add    %al,(%eax)
    90b8:	b2 fb                	mov    $0xfb,%dl
    90ba:	ff                   	(bad)  
    90bb:	ff 1a                	lcall  *(%edx)
    90bd:	00 00                	add    %al,(%eax)
    90bf:	00 00                	add    %al,(%eax)
    90c1:	41                   	inc    %ecx
    90c2:	0e                   	push   %cs
    90c3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    90c9:	56                   	push   %esi
    90ca:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    90cd:	04 00                	add    $0x0,%al
    90cf:	00 1c 00             	add    %bl,(%eax,%eax,1)
    90d2:	00 00                	add    %al,(%eax)
    90d4:	54                   	push   %esp
    90d5:	01 00                	add    %eax,(%eax)
    90d7:	00 ac fb ff ff 1a 00 	add    %ch,0x1affff(%ebx,%edi,8)
    90de:	00 00                	add    %al,(%eax)
    90e0:	00 41 0e             	add    %al,0xe(%ecx)
    90e3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    90e9:	56                   	push   %esi
    90ea:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    90ed:	04 00                	add    $0x0,%al
    90ef:	00 1c 00             	add    %bl,(%eax,%eax,1)
    90f2:	00 00                	add    %al,(%eax)
    90f4:	74 01                	je     90f7 <exec_kernel+0x231>
    90f6:	00 00                	add    %al,(%eax)
    90f8:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
    90f9:	fb                   	sti    
    90fa:	ff                   	(bad)  
    90fb:	ff 1f                	lcall  *(%edi)
    90fd:	00 00                	add    %al,(%eax)
    90ff:	00 00                	add    %al,(%eax)
    9101:	41                   	inc    %ecx
    9102:	0e                   	push   %cs
    9103:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9109:	57                   	push   %edi
    910a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    910d:	04 00                	add    $0x0,%al
    910f:	00 20                	add    %ah,(%eax)
    9111:	00 00                	add    %al,(%eax)
    9113:	00 94 01 00 00 a5 fb 	add    %dl,-0x45b0000(%ecx,%eax,1)
    911a:	ff                   	(bad)  
    911b:	ff 6b 00             	ljmp   *0x0(%ebx)
    911e:	00 00                	add    %al,(%eax)
    9120:	00 41 0e             	add    %al,0xe(%ecx)
    9123:	08 85 02 47 0d 05    	or     %al,0x50d4702(%ebp)
    9129:	41                   	inc    %ecx
    912a:	87 03                	xchg   %eax,(%ebx)
    912c:	02 60 c7             	add    -0x39(%eax),%ah
    912f:	41                   	inc    %ecx
    9130:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    9133:	04 28                	add    $0x28,%al
    9135:	00 00                	add    %al,(%eax)
    9137:	00 b8 01 00 00 ec    	add    %bh,-0x13ffffff(%eax)
    913d:	fb                   	sti    
    913e:	ff                   	(bad)  
    913f:	ff 41 00             	incl   0x0(%ecx)
    9142:	00 00                	add    %al,(%eax)
    9144:	00 41 0e             	add    %al,0xe(%ecx)
    9147:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    914d:	43                   	inc    %ebx
    914e:	87 03                	xchg   %eax,(%ebx)
    9150:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    9153:	05 77 c3 41 c6       	add    $0xc641c377,%eax
    9158:	41                   	inc    %ecx
    9159:	c7 41 c5 0c 04 04 00 	movl   $0x4040c,-0x3b(%ecx)
    9160:	28 00                	sub    %al,(%eax)
    9162:	00 00                	add    %al,(%eax)
    9164:	e4 01                	in     $0x1,%al
    9166:	00 00                	add    %al,(%eax)
    9168:	01 fc                	add    %edi,%esp
    916a:	ff                   	(bad)  
    916b:	ff 81 00 00 00 00    	incl   0x0(%ecx)
    9171:	41                   	inc    %ecx
    9172:	0e                   	push   %cs
    9173:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    9179:	46                   	inc    %esi
    917a:	87 03                	xchg   %eax,(%ebx)
    917c:	86 04 83             	xchg   %al,(%ebx,%eax,4)
    917f:	05 02 6f c3 46       	add    $0x46c36f02,%eax
    9184:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
    9188:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
    918b:	04 24                	add    $0x24,%al
    918d:	00 00                	add    %al,(%eax)
    918f:	00 10                	add    %dl,(%eax)
    9191:	02 00                	add    (%eax),%al
    9193:	00 56 fc             	add    %dl,-0x4(%esi)
    9196:	ff                   	(bad)  
    9197:	ff 5f 00             	lcall  *0x0(%edi)
    919a:	00 00                	add    %al,(%eax)
    919c:	00 41 0e             	add    %al,0xe(%ecx)
    919f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    91a5:	42                   	inc    %edx
    91a6:	86 03                	xchg   %al,(%ebx)
    91a8:	83 04 02 57          	addl   $0x57,(%edx,%eax,1)
    91ac:	c3                   	ret    
    91ad:	41                   	inc    %ecx
    91ae:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
    91b2:	04 04                	add    $0x4,%al
    91b4:	30 00                	xor    %al,(%eax)
    91b6:	00 00                	add    %al,(%eax)
    91b8:	38 02                	cmp    %al,(%edx)
    91ba:	00 00                	add    %al,(%eax)
    91bc:	8d                   	(bad)  
    91bd:	fc                   	cld    
    91be:	ff                   	(bad)  
    91bf:	ff                   	(bad)  
    91c0:	7d 00                	jge    91c2 <exec_kernel+0x2fc>
    91c2:	00 00                	add    %al,(%eax)
    91c4:	00 41 0e             	add    %al,0xe(%ecx)
    91c7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
    91cd:	42                   	inc    %edx
    91ce:	86 03                	xchg   %al,(%ebx)
    91d0:	83 04 02 41          	addl   $0x41,(%edx,%eax,1)
    91d4:	0a c3                	or     %bl,%al
    91d6:	41                   	inc    %ecx
    91d7:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
    91db:	04 04                	add    $0x4,%al
    91dd:	45                   	inc    %ebp
    91de:	0b 69 c3             	or     -0x3d(%ecx),%ebp
    91e1:	41                   	inc    %ecx
    91e2:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
    91e6:	04 04                	add    $0x4,%al

Disassembly of section .data:

00009200 <hex.1211>:
    9200:	30 31                	xor    %dh,(%ecx)
    9202:	32 33                	xor    (%ebx),%dh
    9204:	34 35                	xor    $0x35,%al
    9206:	36 37                	ss aaa 
    9208:	38 39                	cmp    %bh,(%ecx)
    920a:	61                   	popa   
    920b:	62 63 64             	bound  %esp,0x64(%ebx)
    920e:	65 66 00 00          	data16 add %al,%gs:(%eax)
    9212:	00 00                	add    %al,(%eax)

00009214 <dec.1206>:
    9214:	30 31                	xor    %dh,(%ecx)
    9216:	32 33                	xor    (%ebx),%dh
    9218:	34 35                	xor    $0x35,%al
    921a:	36 37                	ss aaa 
    921c:	38 39                	cmp    %bh,(%ecx)
    921e:	00 00                	add    %al,(%eax)

00009220 <blank>:
    9220:	d6                   	(bad)  
    9221:	8e 00                	mov    (%eax),%es
    9223:	00 00                	add    %al,(%eax)

00009224 <video>:
    9224:	00 80 0b 00 00 00    	add    %al,0xb(%eax)
    922a:	00 00                	add    %al,(%eax)
    922c:	00 00                	add    %al,(%eax)
    922e:	00 00                	add    %al,(%eax)
    9230:	00 00                	add    %al,(%eax)
    9232:	00 00                	add    %al,(%eax)
    9234:	00 00                	add    %al,(%eax)
    9236:	00 00                	add    %al,(%eax)
    9238:	00 00                	add    %al,(%eax)
    923a:	00 00                	add    %al,(%eax)
    923c:	00 00                	add    %al,(%eax)
    923e:	00 00                	add    %al,(%eax)

00009240 <mboot_info>:
    9240:	40                   	inc    %eax
    9241:	00 00                	add    %al,(%eax)
    9243:	00 00                	add    %al,(%eax)
    9245:	00 00                	add    %al,(%eax)
    9247:	00 00                	add    %al,(%eax)
    9249:	00 00                	add    %al,(%eax)
    924b:	00 00                	add    %al,(%eax)
    924d:	00 00                	add    %al,(%eax)
    924f:	00 00                	add    %al,(%eax)
    9251:	00 00                	add    %al,(%eax)
    9253:	00 00                	add    %al,(%eax)
    9255:	00 00                	add    %al,(%eax)
    9257:	00 00                	add    %al,(%eax)
    9259:	00 00                	add    %al,(%eax)
    925b:	00 00                	add    %al,(%eax)
    925d:	00 00                	add    %al,(%eax)
    925f:	00 00                	add    %al,(%eax)
    9261:	00 00                	add    %al,(%eax)
    9263:	00 00                	add    %al,(%eax)
    9265:	00 00                	add    %al,(%eax)
    9267:	00 00                	add    %al,(%eax)
    9269:	00 00                	add    %al,(%eax)
    926b:	00 00                	add    %al,(%eax)
    926d:	00 00                	add    %al,(%eax)
    926f:	00 00                	add    %al,(%eax)
    9271:	00 00                	add    %al,(%eax)
    9273:	00 00                	add    %al,(%eax)
    9275:	00 00                	add    %al,(%eax)
    9277:	00 00                	add    %al,(%eax)
    9279:	00 00                	add    %al,(%eax)
    927b:	00 00                	add    %al,(%eax)
    927d:	00 00                	add    %al,(%eax)
    927f:	00 00                	add    %al,(%eax)
    9281:	00 00                	add    %al,(%eax)
    9283:	00 00                	add    %al,(%eax)
    9285:	00 00                	add    %al,(%eax)
    9287:	00 00                	add    %al,(%eax)
    9289:	00 00                	add    %al,(%eax)
    928b:	00 00                	add    %al,(%eax)
    928d:	00 00                	add    %al,(%eax)
    928f:	00 00                	add    %al,(%eax)
    9291:	00 00                	add    %al,(%eax)
    9293:	00 00                	add    %al,(%eax)
    9295:	00 00                	add    %al,(%eax)
    9297:	00 00                	add    %al,(%eax)
    9299:	00 00                	add    %al,(%eax)
    929b:	00 00                	add    %al,(%eax)
    929d:	00 00                	add    %al,(%eax)
    929f:	00                   	.byte 0x0

Disassembly of section .bss:

000092a0 <__bss_start>:
    92a0:	00 00                	add    %al,(%eax)
    92a2:	00 00                	add    %al,(%eax)
    92a4:	00 00                	add    %al,(%eax)
    92a6:	00 00                	add    %al,(%eax)
    92a8:	00 00                	add    %al,(%eax)
    92aa:	00 00                	add    %al,(%eax)
    92ac:	00 00                	add    %al,(%eax)
    92ae:	00 00                	add    %al,(%eax)
    92b0:	00 00                	add    %al,(%eax)
    92b2:	00 00                	add    %al,(%eax)
    92b4:	00 00                	add    %al,(%eax)
    92b6:	00 00                	add    %al,(%eax)
    92b8:	00 00                	add    %al,(%eax)
    92ba:	00 00                	add    %al,(%eax)
    92bc:	00 00                	add    %al,(%eax)
    92be:	00 00                	add    %al,(%eax)
    92c0:	00 00                	add    %al,(%eax)
    92c2:	00 00                	add    %al,(%eax)
    92c4:	00 00                	add    %al,(%eax)
    92c6:	00 00                	add    %al,(%eax)

000092c8 <row>:
    92c8:	00 00                	add    %al,(%eax)
    92ca:	00 00                	add    %al,(%eax)

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 55 62             	sub    %dl,0x62(%ebp)
   8:	75 6e                	jne    78 <PROT_MODE_DSEG+0x68>
   a:	74 75                	je     81 <PROT_MODE_DSEG+0x71>
   c:	20 35 2e 34 2e 30    	and    %dh,0x302e342e
  12:	2d 36 75 62 75       	sub    $0x75627536,%eax
  17:	6e                   	outsb  %ds:(%esi),(%dx)
  18:	74 75                	je     8f <PROT_MODE_DSEG+0x7f>
  1a:	31 7e 31             	xor    %edi,0x31(%esi)
  1d:	36 2e 30 34 2e       	ss xor %dh,%cs:(%esi,%ebp,1)
  22:	31 32                	xor    %esi,(%edx)
  24:	29 20                	sub    %esp,(%eax)
  26:	35 2e 34 2e 30       	xor    $0x302e342e,%eax
  2b:	20 32                	and    %dh,(%edx)
  2d:	30 31                	xor    %dh,(%ecx)
  2f:	36 30 36             	xor    %dh,%ss:(%esi)
  32:	30 39                	xor    %bh,(%ecx)
  34:	00                   	.byte 0x0

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	1c 00                	sbb    $0x0,%al
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	00 00                	add    %al,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	04 00                	add    $0x0,%al
   c:	00 00                	add    %al,(%eax)
   e:	00 00                	add    %al,(%eax)
  10:	00 7e 00             	add    %bh,0x0(%esi)
  13:	00 16                	add    %dl,(%esi)
  15:	0d 00 00 00 00       	or     $0x0,%eax
  1a:	00 00                	add    %al,(%eax)
  1c:	00 00                	add    %al,(%eax)
  1e:	00 00                	add    %al,(%eax)
  20:	1c 00                	sbb    $0x0,%al
  22:	00 00                	add    %al,(%eax)
  24:	02 00                	add    (%eax),%al
  26:	6c                   	insb   (%dx),%es:(%edi)
  27:	00 00                	add    %al,(%eax)
  29:	00 04 00             	add    %al,(%eax,%eax,1)
  2c:	00 00                	add    %al,(%eax)
  2e:	00 00                	add    %al,(%eax)
  30:	16                   	push   %ss
  31:	8b 00                	mov    (%eax),%eax
  33:	00 53 02             	add    %dl,0x2(%ebx)
  36:	00 00                	add    %al,(%eax)
  38:	00 00                	add    %al,(%eax)
  3a:	00 00                	add    %al,(%eax)
  3c:	00 00                	add    %al,(%eax)
  3e:	00 00                	add    %al,(%eax)
  40:	1c 00                	sbb    $0x0,%al
  42:	00 00                	add    %al,(%eax)
  44:	02 00                	add    (%eax),%al
  46:	0d 07 00 00 04       	or     $0x4000007,%eax
  4b:	00 00                	add    %al,(%eax)
  4d:	00 00                	add    %al,(%eax)
  4f:	00 69 8d             	add    %ch,-0x73(%ecx)
  52:	00 00                	add    %al,(%eax)
  54:	5d                   	pop    %ebp
  55:	01 00                	add    %eax,(%eax)
  57:	00 00                	add    %al,(%eax)
  59:	00 00                	add    %al,(%eax)
  5b:	00 00                	add    %al,(%eax)
  5d:	00 00                	add    %al,(%eax)
  5f:	00 1c 00             	add    %bl,(%eax,%eax,1)
  62:	00 00                	add    %al,(%eax)
  64:	02 00                	add    (%eax),%al
  66:	de 0d 00 00 04 00    	fimul  0x40000
  6c:	00 00                	add    %al,(%eax)
  6e:	00 00                	add    %al,(%eax)
  70:	c6                   	(bad)  
  71:	8e 00                	mov    (%eax),%es
  73:	00 10                	add    %dl,(%eax)
  75:	00 00                	add    %al,(%eax)
  77:	00 00                	add    %al,(%eax)
  79:	00 00                	add    %al,(%eax)
  7b:	00 00                	add    %al,(%eax)
  7d:	00 00                	add    %al,(%eax)
  7f:	00                   	.byte 0x0

Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	68 00 00 00 02       	push   $0x2000000
   5:	00 00                	add    %al,(%eax)
   7:	00 00                	add    %al,(%eax)
   9:	00 04 01             	add    %al,(%ecx,%eax,1)
   c:	00 00                	add    %al,(%eax)
   e:	00 00                	add    %al,(%eax)
  10:	00 7e 00             	add    %bh,0x0(%esi)
  13:	00 16                	add    %dl,(%esi)
  15:	8b 00                	mov    (%eax),%eax
  17:	00 62 6f             	add    %ah,0x6f(%edx)
  1a:	6f                   	outsl  %ds:(%esi),(%dx)
  1b:	74 2f                	je     4c <PROT_MODE_DSEG+0x3c>
  1d:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  20:	74 31                	je     53 <PROT_MODE_DSEG+0x43>
  22:	2f                   	das    
  23:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  26:	74 31                	je     59 <PROT_MODE_DSEG+0x49>
  28:	2e 53                	cs push %ebx
  2a:	00 2f                	add    %ch,(%edi)
  2c:	68 6f 6d 65 2f       	push   $0x2f656d6f
  31:	73 75                	jae    a8 <PROT_MODE_DSEG+0x98>
  33:	64 61                	fs popa 
  35:	72 73                	jb     aa <PROT_MODE_DSEG+0x9a>
  37:	68 61 6e 2f 43       	push   $0x432f6e61
  3c:	4c                   	dec    %esp
  3d:	69 6f 6e 50 72 6f 6a 	imul   $0x6a6f7250,0x6e(%edi),%ebp
  44:	65 63 74 73 2f       	arpl   %si,%gs:0x2f(%ebx,%esi,2)
  49:	6f                   	outsl  %ds:(%esi),(%dx)
  4a:	73 2d                	jae    79 <PROT_MODE_DSEG+0x69>
  4c:	73 32                	jae    80 <PROT_MODE_DSEG+0x70>
  4e:	30 2d 42 75 6d 62    	xor    %ch,0x626d7542
  54:	6c                   	insb   (%dx),%es:(%edi)
  55:	65 46                	gs inc %esi
  57:	6c                   	insb   (%dx),%es:(%edi)
  58:	61                   	popa   
  59:	73 68                	jae    c3 <PROT_MODE_DSEG+0xb3>
  5b:	00 47 4e             	add    %al,0x4e(%edi)
  5e:	55                   	push   %ebp
  5f:	20 41 53             	and    %al,0x53(%ecx)
  62:	20 32                	and    %dh,(%edx)
  64:	2e 32 36             	xor    %cs:(%esi),%dh
  67:	2e 31 00             	xor    %eax,%cs:(%eax)
  6a:	01 80 9d 06 00 00    	add    %eax,0x69d(%eax)
  70:	04 00                	add    $0x0,%al
  72:	14 00                	adc    $0x0,%al
  74:	00 00                	add    %al,(%eax)
  76:	04 01                	add    $0x1,%al
  78:	2e 00 00             	add    %al,%cs:(%eax)
  7b:	00 0c a2             	add    %cl,(%edx,%eiz,4)
  7e:	00 00                	add    %al,(%eax)
  80:	00 50 01             	add    %dl,0x1(%eax)
  83:	00 00                	add    %al,(%eax)
  85:	16                   	push   %ss
  86:	8b 00                	mov    (%eax),%eax
  88:	00 53 02             	add    %dl,0x2(%ebx)
  8b:	00 00                	add    %al,(%eax)
  8d:	83 00 00             	addl   $0x0,(%eax)
  90:	00 02                	add    %al,(%edx)
  92:	01 06                	add    %eax,(%esi)
  94:	ed                   	in     (%dx),%eax
  95:	00 00                	add    %al,(%eax)
  97:	00 03                	add    %al,(%ebx)
  99:	b8 00 00 00 02       	mov    $0x2000000,%eax
  9e:	0d 37 00 00 00       	or     $0x37,%eax
  a3:	02 01                	add    (%ecx),%al
  a5:	08 eb                	or     %ch,%bl
  a7:	00 00                	add    %al,(%eax)
  a9:	00 02                	add    %al,(%edx)
  ab:	02 05 10 00 00 00    	add    0x10,%al
  b1:	02 02                	add    (%edx),%al
  b3:	07                   	pop    %es
  b4:	3d 01 00 00 03       	cmp    $0x3000001,%eax
  b9:	20 01                	and    %al,(%ecx)
  bb:	00 00                	add    %al,(%eax)
  bd:	02 10                	add    (%eax),%dl
  bf:	57                   	push   %edi
  c0:	00 00                	add    %al,(%eax)
  c2:	00 04 04             	add    %al,(%esp,%eax,1)
  c5:	05 69 6e 74 00       	add    $0x746e69,%eax
  ca:	03 1f                	add    (%edi),%ebx
  cc:	01 00                	add    %eax,(%eax)
  ce:	00 02                	add    %al,(%edx)
  d0:	11 69 00             	adc    %ebp,0x0(%ecx)
  d3:	00 00                	add    %al,(%eax)
  d5:	02 04 07             	add    (%edi,%eax,1),%al
  d8:	0d 01 00 00 02       	or     $0x2000001,%eax
  dd:	08 05 ca 00 00 00    	or     %al,0xca
  e3:	02 08                	add    (%eax),%cl
  e5:	07                   	pop    %es
  e6:	03 01                	add    (%ecx),%eax
  e8:	00 00                	add    %al,(%eax)
  ea:	02 04 07             	add    (%edi,%eax,1),%al
  ed:	1a 00                	sbb    (%eax),%al
  ef:	00 00                	add    %al,(%eax)
  f1:	05 69 6e 62 00       	add    $0x626e69,%eax
  f6:	02 25 2c 00 00 00    	add    0x2c,%ah
  fc:	03 ac 00 00 00 06 8d 	add    -0x72fa0000(%eax,%eax,1),%ebp
 103:	01 00                	add    %eax,(%eax)
 105:	00 02                	add    %al,(%edx)
 107:	25 57 00 00 00       	and    $0x57,%eax
 10c:	07                   	pop    %es
 10d:	88 01                	mov    %al,(%ecx)
 10f:	00 00                	add    %al,(%eax)
 111:	02 27                	add    (%edi),%ah
 113:	2c 00                	sub    $0x0,%al
 115:	00 00                	add    %al,(%eax)
 117:	00 08                	add    %cl,(%eax)
 119:	c5 00                	lds    (%eax),%eax
 11b:	00 00                	add    %al,(%eax)
 11d:	02 2d 03 da 00 00    	add    0xda03,%ch
 123:	00 06                	add    %al,(%esi)
 125:	8d 01                	lea    (%ecx),%eax
 127:	00 00                	add    %al,(%eax)
 129:	02 2d 57 00 00 00    	add    0x57,%ch
 12f:	06                   	push   %es
 130:	e5 03                	in     $0x3,%eax
 132:	00 00                	add    %al,(%eax)
 134:	02 2d da 00 00 00    	add    0xda,%ch
 13a:	09 63 6e             	or     %esp,0x6e(%ebx)
 13d:	74 00                	je     13f <PROT_MODE_DSEG+0x12f>
 13f:	02 2d 57 00 00 00    	add    0x57,%ch
 145:	00 0a                	add    %cl,(%edx)
 147:	04 08                	add    $0x8,%al
 149:	c0 00 00             	rolb   $0x0,(%eax)
 14c:	00 02                	add    %al,(%edx)
 14e:	19 03                	sbb    %eax,(%ebx)
 150:	ff 00                	incl   (%eax)
 152:	00 00                	add    %al,(%eax)
 154:	06                   	push   %es
 155:	8d 01                	lea    (%ecx),%eax
 157:	00 00                	add    %al,(%eax)
 159:	02 19                	add    (%ecx),%bl
 15b:	57                   	push   %edi
 15c:	00 00                	add    %al,(%eax)
 15e:	00 06                	add    %al,(%esi)
 160:	88 01                	mov    %al,(%ecx)
 162:	00 00                	add    %al,(%eax)
 164:	02 19                	add    (%ecx),%bl
 166:	2c 00                	sub    $0x0,%al
 168:	00 00                	add    %al,(%eax)
 16a:	00 0b                	add    %cl,(%ebx)
 16c:	fe 00                	incb   (%eax)
 16e:	00 00                	add    %al,(%eax)
 170:	01 09                	add    %ecx,(%ecx)
 172:	16                   	push   %ss
 173:	8b 00                	mov    (%eax),%eax
 175:	00 1b                	add    %bl,(%ebx)
 177:	00 00                	add    %al,(%eax)
 179:	00 01                	add    %al,(%ecx)
 17b:	9c                   	pushf  
 17c:	47                   	inc    %edi
 17d:	01 00                	add    %eax,(%eax)
 17f:	00 0c 6c             	add    %cl,(%esp,%ebp,2)
 182:	00 01                	add    %al,(%ecx)
 184:	09 57 00             	or     %edx,0x0(%edi)
 187:	00 00                	add    %al,(%eax)
 189:	02 91 00 0d 28 01    	add    0x1280d00(%ecx),%dl
 18f:	00 00                	add    %al,(%eax)
 191:	01 09                	add    %ecx,(%ecx)
 193:	57                   	push   %edi
 194:	00 00                	add    %al,(%eax)
 196:	00 02                	add    %al,(%edx)
 198:	91                   	xchg   %eax,%ecx
 199:	04 0c                	add    $0xc,%al
 19b:	63 68 00             	arpl   %bp,0x0(%eax)
 19e:	01 09                	add    %ecx,(%ecx)
 1a0:	47                   	inc    %edi
 1a1:	01 00                	add    %eax,(%eax)
 1a3:	00 02                	add    %al,(%edx)
 1a5:	91                   	xchg   %eax,%ecx
 1a6:	08 0e                	or     %cl,(%esi)
 1a8:	70 00                	jo     1aa <PROT_MODE_DSEG+0x19a>
 1aa:	01 0b                	add    %ecx,(%ebx)
 1ac:	4e                   	dec    %esi
 1ad:	01 00                	add    %eax,(%eax)
 1af:	00 01                	add    %al,(%ecx)
 1b1:	50                   	push   %eax
 1b2:	00 02                	add    %al,(%edx)
 1b4:	01 06                	add    %eax,(%esi)
 1b6:	f4                   	hlt    
 1b7:	00 00                	add    %al,(%eax)
 1b9:	00 0f                	add    %cl,(%edi)
 1bb:	04 54                	add    $0x54,%al
 1bd:	01 00                	add    %eax,(%eax)
 1bf:	00 10                	add    %dl,(%eax)
 1c1:	47                   	inc    %edi
 1c2:	01 00                	add    %eax,(%eax)
 1c4:	00 11                	add    %dl,(%ecx)
 1c6:	33 01                	xor    (%ecx),%eax
 1c8:	00 00                	add    %al,(%eax)
 1ca:	01 12                	add    %edx,(%edx)
 1cc:	57                   	push   %edi
 1cd:	00 00                	add    %al,(%eax)
 1cf:	00 31                	add    %dh,(%ecx)
 1d1:	8b 00                	mov    (%eax),%eax
 1d3:	00 31                	add    %dh,(%ecx)
 1d5:	00 00                	add    %al,(%eax)
 1d7:	00 01                	add    %al,(%ecx)
 1d9:	9c                   	pushf  
 1da:	be 01 00 00 0c       	mov    $0xc000001,%esi
 1df:	72 00                	jb     1e1 <PROT_MODE_DSEG+0x1d1>
 1e1:	01 12                	add    %edx,(%edx)
 1e3:	57                   	push   %edi
 1e4:	00 00                	add    %al,(%eax)
 1e6:	00 02                	add    %al,(%edx)
 1e8:	91                   	xchg   %eax,%ecx
 1e9:	00 0c 63             	add    %cl,(%ebx,%eiz,2)
 1ec:	00 01                	add    %al,(%ecx)
 1ee:	12 57 00             	adc    0x0(%edi),%dl
 1f1:	00 00                	add    %al,(%eax)
 1f3:	02 91 04 0d 28 01    	add    0x1280d04(%ecx),%dl
 1f9:	00 00                	add    %al,(%eax)
 1fb:	01 12                	add    %edx,(%edx)
 1fd:	57                   	push   %edi
 1fe:	00 00                	add    %al,(%eax)
 200:	00 02                	add    %al,(%edx)
 202:	91                   	xchg   %eax,%ecx
 203:	08 12                	or     %dl,(%edx)
 205:	d8 00                	fadds  (%eax)
 207:	00 00                	add    %al,(%eax)
 209:	01 12                	add    %edx,(%edx)
 20b:	be 01 00 00 00       	mov    $0x1,%esi
 210:	00 00                	add    %al,(%eax)
 212:	00 13                	add    %dl,(%ebx)
 214:	6c                   	insb   (%dx),%es:(%edi)
 215:	00 01                	add    %al,(%ecx)
 217:	14 57                	adc    $0x57,%al
 219:	00 00                	add    %al,(%eax)
 21b:	00 86 00 00 00 14    	add    %al,0x14000000(%esi)
 221:	56                   	push   %esi
 222:	8b 00                	mov    (%eax),%eax
 224:	00 ff                	add    %bh,%bh
 226:	00 00                	add    %al,(%eax)
 228:	00 00                	add    %al,(%eax)
 22a:	0f 04                	(bad)  
 22c:	c4 01                	les    (%ecx),%eax
 22e:	00 00                	add    %al,(%eax)
 230:	15 47 01 00 00       	adc    $0x147,%eax
 235:	0b 92 01 00 00 01    	or     0x1000001(%edx),%edx
 23b:	22 62 8b             	and    -0x75(%edx),%ah
 23e:	00 00                	add    %al,(%eax)
 240:	43                   	inc    %ebx
 241:	00 00                	add    %al,(%eax)
 243:	00 01                	add    %al,(%ecx)
 245:	9c                   	pushf  
 246:	fd                   	std    
 247:	01 00                	add    %eax,(%eax)
 249:	00 0c 73             	add    %cl,(%ebx,%esi,2)
 24c:	00 01                	add    %al,(%ecx)
 24e:	22 fd                	and    %ch,%bh
 250:	01 00                	add    %eax,(%eax)
 252:	00 02                	add    %al,(%edx)
 254:	91                   	xchg   %eax,%ecx
 255:	00 14 90             	add    %dl,(%eax,%edx,4)
 258:	8b 00                	mov    (%eax),%eax
 25a:	00 59 01             	add    %bl,0x1(%ecx)
 25d:	00 00                	add    %al,(%eax)
 25f:	14 9d                	adc    $0x9d,%al
 261:	8b 00                	mov    (%eax),%eax
 263:	00 59 01             	add    %bl,0x1(%ecx)
 266:	00 00                	add    %al,(%eax)
 268:	00 0f                	add    %cl,(%edi)
 26a:	04 47                	add    $0x47,%al
 26c:	01 00                	add    %eax,(%eax)
 26e:	00 0b                	add    %cl,(%ebx)
 270:	23 00                	and    (%eax),%eax
 272:	00 00                	add    %al,(%eax)
 274:	01 29                	add    %ebp,(%ecx)
 276:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 277:	8b 00                	mov    (%eax),%eax
 279:	00 0d 00 00 00 01    	add    %cl,0x1000000
 27f:	9c                   	pushf  
 280:	25 02 00 00 0c       	and    $0xc000002,%eax
 285:	72 00                	jb     287 <PROT_MODE_DSEG+0x277>
 287:	01 29                	add    %ebp,(%ecx)
 289:	57                   	push   %edi
 28a:	00 00                	add    %al,(%eax)
 28c:	00 02                	add    %al,(%edx)
 28e:	91                   	xchg   %eax,%ecx
 28f:	00 00                	add    %al,(%eax)
 291:	16                   	push   %ss
 292:	28 00                	sub    %al,(%eax)
 294:	00 00                	add    %al,(%eax)
 296:	01 2f                	add    %ebp,(%edi)
 298:	b2 8b                	mov    $0x8b,%dl
 29a:	00 00                	add    %al,(%eax)
 29c:	17                   	pop    %ss
 29d:	00 00                	add    %al,(%eax)
 29f:	00 01                	add    %al,(%ecx)
 2a1:	9c                   	pushf  
 2a2:	50                   	push   %eax
 2a3:	02 00                	add    (%eax),%al
 2a5:	00 0c 6d 00 01 2f fd 	add    %cl,-0x2d0ff00(,%ebp,2)
 2ac:	01 00                	add    %eax,(%eax)
 2ae:	00 02                	add    %al,(%edx)
 2b0:	91                   	xchg   %eax,%ecx
 2b1:	00 14 c3             	add    %dl,(%ebx,%eax,8)
 2b4:	8b 00                	mov    (%eax),%eax
 2b6:	00 59 01             	add    %bl,0x1(%ecx)
 2b9:	00 00                	add    %al,(%eax)
 2bb:	00 11                	add    %dl,(%ecx)
 2bd:	81 01 00 00 01 47    	addl   $0x47010000,(%ecx)
 2c3:	57                   	push   %edi
 2c4:	00 00                	add    %al,(%eax)
 2c6:	00 c9                	add    %cl,%cl
 2c8:	8b 00                	mov    (%eax),%eax
 2ca:	00 13                	add    %dl,(%ebx)
 2cc:	00 00                	add    %al,(%eax)
 2ce:	00 01                	add    %al,(%ecx)
 2d0:	9c                   	pushf  
 2d1:	84 02                	test   %al,(%edx)
 2d3:	00 00                	add    %al,(%eax)
 2d5:	17                   	pop    %ss
 2d6:	73 00                	jae    2d8 <PROT_MODE_DSEG+0x2c8>
 2d8:	01 47 be             	add    %eax,-0x42(%edi)
 2db:	01 00                	add    %eax,(%eax)
 2dd:	00 c0                	add    %al,%al
 2df:	00 00                	add    %al,(%eax)
 2e1:	00 13                	add    %dl,(%ebx)
 2e3:	6e                   	outsb  %ds:(%esi),(%dx)
 2e4:	00 01                	add    %al,(%ecx)
 2e6:	49                   	dec    %ecx
 2e7:	57                   	push   %edi
 2e8:	00 00                	add    %al,(%eax)
 2ea:	00 e5                	add    %ah,%ch
 2ec:	00 00                	add    %al,(%eax)
 2ee:	00 00                	add    %al,(%eax)
 2f0:	0b 9a 01 00 00 01    	or     0x1000001(%edx),%ebx
 2f6:	52                   	push   %edx
 2f7:	dc 8b 00 00 2d 00    	fmull  0x2d0000(%ebx)
 2fd:	00 00                	add    %al,(%eax)
 2ff:	01 9c d4 02 00 00 0c 	add    %ebx,0xc000002(%esp,%edx,8)
 306:	73 00                	jae    308 <PROT_MODE_DSEG+0x2f8>
 308:	01 52 fd             	add    %edx,-0x3(%edx)
 30b:	01 00                	add    %eax,(%eax)
 30d:	00 02                	add    %al,(%edx)
 30f:	91                   	xchg   %eax,%ecx
 310:	00 13                	add    %dl,(%ebx)
 312:	69 00 01 54 57 00    	imul   $0x575401,(%eax),%eax
 318:	00 00                	add    %al,(%eax)
 31a:	04 01                	add    $0x1,%al
 31c:	00 00                	add    %al,(%eax)
 31e:	0e                   	push   %cs
 31f:	6a 00                	push   $0x0
 321:	01 54 57 00          	add    %edx,0x0(%edi,%edx,2)
 325:	00 00                	add    %al,(%eax)
 327:	01 50 13             	add    %edx,0x13(%eax)
 32a:	63 00                	arpl   %ax,(%eax)
 32c:	01 55 47             	add    %edx,0x47(%ebp)
 32f:	01 00                	add    %eax,(%eax)
 331:	00 23                	add    %ah,(%ebx)
 333:	01 00                	add    %eax,(%eax)
 335:	00 14 ea             	add    %dl,(%edx,%ebp,8)
 338:	8b 00                	mov    (%eax),%eax
 33a:	00 50 02             	add    %dl,0x2(%eax)
 33d:	00 00                	add    %al,(%eax)
 33f:	00 0b                	add    %cl,(%ebx)
 341:	2e 01 00             	add    %eax,%cs:(%eax)
 344:	00 01                	add    %al,(%ecx)
 346:	61                   	popa   
 347:	09 8c 00 00 61 00 00 	or     %ecx,0x6100(%eax,%eax,1)
 34e:	00 01                	add    %al,(%ecx)
 350:	9c                   	pushf  
 351:	44                   	inc    %esp
 352:	03 00                	add    (%eax),%eax
 354:	00 17                	add    %dl,(%edi)
 356:	6e                   	outsb  %ds:(%esi),(%dx)
 357:	00 01                	add    %al,(%ecx)
 359:	61                   	popa   
 35a:	57                   	push   %edi
 35b:	00 00                	add    %al,(%eax)
 35d:	00 36                	add    %dh,(%esi)
 35f:	01 00                	add    %eax,(%eax)
 361:	00 0c 73             	add    %cl,(%ebx,%esi,2)
 364:	00 01                	add    %al,(%ecx)
 366:	61                   	popa   
 367:	fd                   	std    
 368:	01 00                	add    %eax,(%eax)
 36a:	00 02                	add    %al,(%edx)
 36c:	91                   	xchg   %eax,%ecx
 36d:	04 0d                	add    $0xd,%al
 36f:	b1 01                	mov    $0x1,%cl
 371:	00 00                	add    %al,(%eax)
 373:	01 61 57             	add    %esp,0x57(%ecx)
 376:	00 00                	add    %al,(%eax)
 378:	00 02                	add    %al,(%edx)
 37a:	91                   	xchg   %eax,%ecx
 37b:	08 0d c9 03 00 00    	or     %cl,0x3c9
 381:	01 61 fd             	add    %esp,-0x3(%ecx)
 384:	01 00                	add    %eax,(%eax)
 386:	00 02                	add    %al,(%edx)
 388:	91                   	xchg   %eax,%ecx
 389:	0c 13                	or     $0x13,%al
 38b:	69 00 01 63 57 00    	imul   $0x576301,(%eax),%eax
 391:	00 00                	add    %al,(%eax)
 393:	55                   	push   %ebp
 394:	01 00                	add    %eax,(%eax)
 396:	00 18                	add    %bl,(%eax)
 398:	38 01                	cmp    %al,(%ecx)
 39a:	00 00                	add    %al,(%eax)
 39c:	01 63 57             	add    %esp,0x57(%ebx)
 39f:	00 00                	add    %al,(%eax)
 3a1:	00 89 01 00 00 19    	add    %cl,0x19000001(%ecx)
 3a7:	6a 8c                	push   $0xffffff8c
 3a9:	00 00                	add    %al,(%eax)
 3ab:	84 02                	test   %al,(%edx)
 3ad:	00 00                	add    %al,(%eax)
 3af:	00 0b                	add    %cl,(%ebx)
 3b1:	1a 01                	sbb    (%ecx),%al
 3b3:	00 00                	add    %al,(%eax)
 3b5:	01 73 6a             	add    %esi,0x6a(%ebx)
 3b8:	8c 00                	mov    %es,(%eax)
 3ba:	00 1a                	add    %bl,(%edx)
 3bc:	00 00                	add    %al,(%eax)
 3be:	00 01                	add    %al,(%ecx)
 3c0:	9c                   	pushf  
 3c1:	8c 03                	mov    %es,(%ebx)
 3c3:	00 00                	add    %al,(%eax)
 3c5:	0c 6e                	or     $0x6e,%al
 3c7:	00 01                	add    %al,(%ecx)
 3c9:	73 57                	jae    422 <PROT_MODE_DSEG+0x412>
 3cb:	00 00                	add    %al,(%eax)
 3cd:	00 02                	add    %al,(%edx)
 3cf:	91                   	xchg   %eax,%ecx
 3d0:	00 0c 73             	add    %cl,(%ebx,%esi,2)
 3d3:	00 01                	add    %al,(%ecx)
 3d5:	73 fd                	jae    3d4 <PROT_MODE_DSEG+0x3c4>
 3d7:	01 00                	add    %eax,(%eax)
 3d9:	00 02                	add    %al,(%edx)
 3db:	91                   	xchg   %eax,%ecx
 3dc:	04 0e                	add    $0xe,%al
 3de:	64 65 63 00          	fs arpl %ax,%gs:(%eax)
 3e2:	01 75 8c             	add    %esi,-0x74(%ebp)
 3e5:	03 00                	add    (%eax),%eax
 3e7:	00 05 03 14 92 00    	add    %al,0x921403
 3ed:	00 14 7f             	add    %dl,(%edi,%edi,2)
 3f0:	8c 00                	mov    %es,(%eax)
 3f2:	00 d4                	add    %dl,%ah
 3f4:	02 00                	add    (%eax),%al
 3f6:	00 00                	add    %al,(%eax)
 3f8:	1a 47 01             	sbb    0x1(%edi),%al
 3fb:	00 00                	add    %al,(%eax)
 3fd:	9c                   	pushf  
 3fe:	03 00                	add    (%eax),%eax
 400:	00 1b                	add    %bl,(%ebx)
 402:	7e 00                	jle    404 <PROT_MODE_DSEG+0x3f4>
 404:	00 00                	add    %al,(%eax)
 406:	0a 00                	or     (%eax),%al
 408:	0b f9                	or     %ecx,%edi
 40a:	00 00                	add    %al,(%eax)
 40c:	00 01                	add    %al,(%ecx)
 40e:	7b 84                	jnp    394 <PROT_MODE_DSEG+0x384>
 410:	8c 00                	mov    %es,(%eax)
 412:	00 1a                	add    %bl,(%edx)
 414:	00 00                	add    %al,(%eax)
 416:	00 01                	add    %al,(%ecx)
 418:	9c                   	pushf  
 419:	e4 03                	in     $0x3,%al
 41b:	00 00                	add    %al,(%eax)
 41d:	0c 6e                	or     $0x6e,%al
 41f:	00 01                	add    %al,(%ecx)
 421:	7b 57                	jnp    47a <PROT_MODE_DSEG+0x46a>
 423:	00 00                	add    %al,(%eax)
 425:	00 02                	add    %al,(%edx)
 427:	91                   	xchg   %eax,%ecx
 428:	00 0c 73             	add    %cl,(%ebx,%esi,2)
 42b:	00 01                	add    %al,(%ecx)
 42d:	7b fd                	jnp    42c <PROT_MODE_DSEG+0x41c>
 42f:	01 00                	add    %eax,(%eax)
 431:	00 02                	add    %al,(%edx)
 433:	91                   	xchg   %eax,%ecx
 434:	04 0e                	add    $0xe,%al
 436:	68 65 78 00 01       	push   $0x1007865
 43b:	7d e4                	jge    421 <PROT_MODE_DSEG+0x411>
 43d:	03 00                	add    (%eax),%eax
 43f:	00 05 03 00 92 00    	add    %al,0x920003
 445:	00 14 99             	add    %dl,(%ecx,%ebx,4)
 448:	8c 00                	mov    %es,(%eax)
 44a:	00 d4                	add    %dl,%ah
 44c:	02 00                	add    (%eax),%al
 44e:	00 00                	add    %al,(%eax)
 450:	1a 47 01             	sbb    0x1(%edi),%al
 453:	00 00                	add    %al,(%eax)
 455:	f4                   	hlt    
 456:	03 00                	add    (%eax),%eax
 458:	00 1b                	add    %bl,(%ebx)
 45a:	7e 00                	jle    45c <PROT_MODE_DSEG+0x44c>
 45c:	00 00                	add    %al,(%eax)
 45e:	10 00                	adc    %al,(%eax)
 460:	0b 92 00 00 00 01    	or     0x1000000(%edx),%edx
 466:	3b 9e 8c 00 00 1f    	cmp    0x1f00008c(%esi),%ebx
 46c:	00 00                	add    %al,(%eax)
 46e:	00 01                	add    %al,(%ecx)
 470:	9c                   	pushf  
 471:	28 04 00             	sub    %al,(%eax,%eax,1)
 474:	00 0c 69             	add    %cl,(%ecx,%ebp,2)
 477:	00 01                	add    %al,(%ecx)
 479:	3b 4c 00 00          	cmp    0x0(%eax,%eax,1),%ecx
 47d:	00 02                	add    %al,(%edx)
 47f:	91                   	xchg   %eax,%ecx
 480:	00 14 ae             	add    %dl,(%esi,%ebp,4)
 483:	8c 00                	mov    %es,(%eax)
 485:	00 9c 03 00 00 19 bd 	add    %bl,-0x42e70000(%ebx,%eax,1)
 48c:	8c 00                	mov    %es,(%eax)
 48e:	00 c9                	add    %cl,%cl
 490:	01 00                	add    %eax,(%eax)
 492:	00 00                	add    %al,(%eax)
 494:	1c 07                	sbb    $0x7,%al
 496:	00 00                	add    %al,(%eax)
 498:	00 01                	add    %al,(%ecx)
 49a:	86 01                	xchg   %al,(%ecx)
 49c:	0b 97 00 00 00 01    	or     0x1000000(%edi),%edx
 4a2:	8e bd 8c 00 00 6b    	mov    0x6b00008c(%ebp),%?
 4a8:	00 00                	add    %al,(%eax)
 4aa:	00 01                	add    %al,(%ecx)
 4ac:	9c                   	pushf  
 4ad:	e5 05                	in     $0x5,%eax
 4af:	00 00                	add    %al,(%eax)
 4b1:	0c 64                	or     $0x64,%al
 4b3:	73 74                	jae    529 <PROT_MODE_DSEG+0x519>
 4b5:	00 01                	add    %al,(%ecx)
 4b7:	8e da                	mov    %edx,%ds
 4b9:	00 00                	add    %al,(%eax)
 4bb:	00 02                	add    %al,(%edx)
 4bd:	91                   	xchg   %eax,%ecx
 4be:	00 0d 21 02 00 00    	add    %cl,0x221
 4c4:	01 8e 5e 00 00 00    	add    %ecx,0x5e(%esi)
 4ca:	02 91 04 1d 28 04    	add    0x4281d04(%ecx),%dl
 4d0:	00 00                	add    %al,(%eax)
 4d2:	be 8c 00 00 00       	mov    $0x8c,%esi
 4d7:	00 00                	add    %al,(%eax)
 4d9:	00 01                	add    %al,(%ecx)
 4db:	91                   	xchg   %eax,%ecx
 4dc:	99                   	cltd   
 4dd:	04 00                	add    $0x0,%al
 4df:	00 1e                	add    %bl,(%esi)
 4e1:	85 00                	test   %eax,(%eax)
 4e3:	00 00                	add    %al,(%eax)
 4e5:	be 8c 00 00 18       	mov    $0x1800008c,%esi
 4ea:	00 00                	add    %al,(%eax)
 4ec:	00 01                	add    %al,(%ecx)
 4ee:	89 1f                	mov    %ebx,(%edi)
 4f0:	95                   	xchg   %eax,%ebp
 4f1:	00 00                	add    %al,(%eax)
 4f3:	00 9d 01 00 00 20    	add    %bl,0x20000001(%ebp)
 4f9:	18 00                	sbb    %al,(%eax)
 4fb:	00 00                	add    %al,(%eax)
 4fd:	21 a0 00 00 00 00    	and    %esp,0x0(%eax)
 503:	00 00                	add    %al,(%eax)
 505:	22 dc                	and    %ah,%bl
 507:	00 00                	add    %al,(%eax)
 509:	00 d1                	add    %dl,%cl
 50b:	8c 00                	mov    %es,(%eax)
 50d:	00 08                	add    %cl,(%eax)
 50f:	00 00                	add    %al,(%eax)
 511:	00 01                	add    %al,(%ecx)
 513:	93                   	xchg   %eax,%ebx
 514:	bf 04 00 00 1f       	mov    $0x1f000004,%edi
 519:	f3 00 00             	repz add %al,(%eax)
 51c:	00 b3 01 00 00 1f    	add    %dh,0x1f000001(%ebx)
 522:	e8 00 00 00 c7       	call   c7000527 <SMAP_SIG+0x73b2c3d7>
 527:	01 00                	add    %eax,(%eax)
 529:	00 00                	add    %al,(%eax)
 52b:	22 dc                	and    %ah,%bl
 52d:	00 00                	add    %al,(%eax)
 52f:	00 d9                	add    %bl,%cl
 531:	8c 00                	mov    %es,(%eax)
 533:	00 08                	add    %cl,(%eax)
 535:	00 00                	add    %al,(%eax)
 537:	00 01                	add    %al,(%ecx)
 539:	94                   	xchg   %eax,%esp
 53a:	e5 04                	in     $0x4,%eax
 53c:	00 00                	add    %al,(%eax)
 53e:	1f                   	pop    %ds
 53f:	f3 00 00             	repz add %al,(%eax)
 542:	00 dd                	add    %bl,%ch
 544:	01 00                	add    %eax,(%eax)
 546:	00 1f                	add    %bl,(%edi)
 548:	e8 00 00 00 f0       	call   f000054d <SMAP_SIG+0x9cb2c3fd>
 54d:	01 00                	add    %eax,(%eax)
 54f:	00 00                	add    %al,(%eax)
 551:	22 dc                	and    %ah,%bl
 553:	00 00                	add    %al,(%eax)
 555:	00 e1                	add    %ah,%cl
 557:	8c 00                	mov    %es,(%eax)
 559:	00 0b                	add    %cl,(%ebx)
 55b:	00 00                	add    %al,(%eax)
 55d:	00 01                	add    %al,(%ecx)
 55f:	95                   	xchg   %eax,%ebp
 560:	0b 05 00 00 1f f3    	or     0xf31f0000,%eax
 566:	00 00                	add    %al,(%eax)
 568:	00 06                	add    %al,(%esi)
 56a:	02 00                	add    (%eax),%al
 56c:	00 1f                	add    %bl,(%edi)
 56e:	e8 00 00 00 1a       	call   1a000573 <_end+0x19ff72a7>
 573:	02 00                	add    (%eax),%al
 575:	00 00                	add    %al,(%eax)
 577:	22 dc                	and    %ah,%bl
 579:	00 00                	add    %al,(%eax)
 57b:	00 ec                	add    %ch,%ah
 57d:	8c 00                	mov    %es,(%eax)
 57f:	00 0b                	add    %cl,(%ebx)
 581:	00 00                	add    %al,(%eax)
 583:	00 01                	add    %al,(%ecx)
 585:	96                   	xchg   %eax,%esi
 586:	31 05 00 00 1f f3    	xor    %eax,0xf31f0000
 58c:	00 00                	add    %al,(%eax)
 58e:	00 30                	add    %dh,(%eax)
 590:	02 00                	add    (%eax),%al
 592:	00 1f                	add    %bl,(%edi)
 594:	e8 00 00 00 44       	call   44000599 <MBOOT_INFO_MAGIC+0x18525597>
 599:	02 00                	add    (%eax),%al
 59b:	00 00                	add    %al,(%eax)
 59d:	22 dc                	and    %ah,%bl
 59f:	00 00                	add    %al,(%eax)
 5a1:	00 f7                	add    %dh,%bh
 5a3:	8c 00                	mov    %es,(%eax)
 5a5:	00 0e                	add    %cl,(%esi)
 5a7:	00 00                	add    %al,(%eax)
 5a9:	00 01                	add    %al,(%ecx)
 5ab:	97                   	xchg   %eax,%edi
 5ac:	57                   	push   %edi
 5ad:	05 00 00 1f f3       	add    $0xf31f0000,%eax
 5b2:	00 00                	add    %al,(%eax)
 5b4:	00 5a 02             	add    %bl,0x2(%edx)
 5b7:	00 00                	add    %al,(%eax)
 5b9:	1f                   	pop    %ds
 5ba:	e8 00 00 00 74       	call   740005bf <SMAP_SIG+0x20b2c46f>
 5bf:	02 00                	add    (%eax),%al
 5c1:	00 00                	add    %al,(%eax)
 5c3:	22 dc                	and    %ah,%bl
 5c5:	00 00                	add    %al,(%eax)
 5c7:	00 05 8d 00 00 08    	add    %al,0x800008d
 5cd:	00 00                	add    %al,(%eax)
 5cf:	00 01                	add    %al,(%ecx)
 5d1:	98                   	cwtl   
 5d2:	7d 05                	jge    5d9 <PROT_MODE_DSEG+0x5c9>
 5d4:	00 00                	add    %al,(%eax)
 5d6:	1f                   	pop    %ds
 5d7:	f3 00 00             	repz add %al,(%eax)
 5da:	00 8a 02 00 00 1f    	add    %cl,0x1f000002(%edx)
 5e0:	e8 00 00 00 9f       	call   9f0005e5 <SMAP_SIG+0x4bb2c495>
 5e5:	02 00                	add    (%eax),%al
 5e7:	00 00                	add    %al,(%eax)
 5e9:	22 28                	and    (%eax),%ch
 5eb:	04 00                	add    $0x0,%al
 5ed:	00 0d 8d 00 00 08    	add    %cl,0x800008d
 5f3:	00 00                	add    %al,(%eax)
 5f5:	00 01                	add    %al,(%ecx)
 5f7:	9b                   	fwait
 5f8:	b9 05 00 00 23       	mov    $0x23000005,%ecx
 5fd:	85 00                	test   %eax,(%eax)
 5ff:	00 00                	add    %al,(%eax)
 601:	0d 8d 00 00 01       	or     $0x100008d,%eax
 606:	00 00                	add    %al,(%eax)
 608:	00 01                	add    %al,(%ecx)
 60a:	89 1f                	mov    %ebx,(%edi)
 60c:	95                   	xchg   %eax,%ebp
 60d:	00 00                	add    %al,(%eax)
 60f:	00 b5 02 00 00 24    	add    %dh,0x24000002(%ebp)
 615:	0d 8d 00 00 01       	or     $0x100008d,%eax
 61a:	00 00                	add    %al,(%eax)
 61c:	00 21                	add    %ah,(%ecx)
 61e:	a0 00 00 00 00       	mov    0x0,%al
 623:	00 00                	add    %al,(%eax)
 625:	23 ac 00 00 00 15 8d 	and    -0x72eb0000(%eax,%eax,1),%ebp
 62c:	00 00                	add    %al,(%eax)
 62e:	10 00                	adc    %al,(%eax)
 630:	00 00                	add    %al,(%eax)
 632:	01 9e 1f ce 00 00    	add    %ebx,0xce1f(%esi)
 638:	00 cb                	add    %cl,%bl
 63a:	02 00                	add    (%eax),%al
 63c:	00 1f                	add    %bl,(%edi)
 63e:	c3                   	ret    
 63f:	00 00                	add    %al,(%eax)
 641:	00 e0                	add    %ah,%al
 643:	02 00                	add    (%eax),%al
 645:	00 1f                	add    %bl,(%edi)
 647:	b8 00 00 00 f4       	mov    $0xf4000000,%eax
 64c:	02 00                	add    (%eax),%al
 64e:	00 00                	add    %al,(%eax)
 650:	00 0b                	add    %cl,(%ebx)
 652:	df 00                	fild   (%eax)
 654:	00 00                	add    %al,(%eax)
 656:	01 a4 28 8d 00 00 41 	add    %esp,0x4100008d(%eax,%ebp,1)
 65d:	00 00                	add    %al,(%eax)
 65f:	00 01                	add    %al,(%ecx)
 661:	9c                   	pushf  
 662:	4c                   	dec    %esp
 663:	06                   	push   %es
 664:	00 00                	add    %al,(%eax)
 666:	17                   	pop    %ss
 667:	76 61                	jbe    6ca <PROT_MODE_DSEG+0x6ba>
 669:	00 01                	add    %al,(%ecx)
 66b:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 66c:	5e                   	pop    %esi
 66d:	00 00                	add    %al,(%eax)
 66f:	00 0a                	add    %cl,(%edx)
 671:	03 00                	add    (%eax),%eax
 673:	00 0d 84 04 00 00    	add    %cl,0x484
 679:	01 a4 5e 00 00 00 02 	add    %esp,0x2000000(%esi,%ebx,2)
 680:	91                   	xchg   %eax,%ecx
 681:	04 12                	add    $0x12,%al
 683:	21 02                	and    %eax,(%edx)
 685:	00 00                	add    %al,(%eax)
 687:	01 a4 5e 00 00 00 6d 	add    %esp,0x6d000000(%esi,%ebx,2)
 68e:	03 00                	add    (%eax),%eax
 690:	00 0c 6c             	add    %cl,(%esp,%ebp,2)
 693:	62 61 00             	bound  %esp,0x0(%ecx)
 696:	01 a4 5e 00 00 00 02 	add    %esp,0x2000000(%esi,%ebx,2)
 69d:	91                   	xchg   %eax,%ecx
 69e:	0c 18                	or     $0x18,%al
 6a0:	00 00                	add    %al,(%eax)
 6a2:	00 00                	add    %al,(%eax)
 6a4:	01 a6 5e 00 00 00    	add    %esp,0x5e(%esi)
 6aa:	b0 03                	mov    $0x3,%al
 6ac:	00 00                	add    %al,(%eax)
 6ae:	14 5d                	adc    $0x5d,%al
 6b0:	8d 00                	lea    (%eax),%eax
 6b2:	00 30                	add    %dh,(%eax)
 6b4:	04 00                	add    $0x0,%al
 6b6:	00 00                	add    %al,(%eax)
 6b8:	0e                   	push   %cs
 6b9:	72 6f                	jb     72a <PROT_MODE_DSEG+0x71a>
 6bb:	77 00                	ja     6bd <PROT_MODE_DSEG+0x6ad>
 6bd:	01 1c 57             	add    %ebx,(%edi,%edx,2)
 6c0:	00 00                	add    %al,(%eax)
 6c2:	00 05 03 c8 92 00    	add    %al,0x92c803
 6c8:	00 1a                	add    %bl,(%edx)
 6ca:	47                   	inc    %edi
 6cb:	01 00                	add    %eax,(%eax)
 6cd:	00 6d 06             	add    %ch,0x6(%ebp)
 6d0:	00 00                	add    %al,(%eax)
 6d2:	1b 7e 00             	sbb    0x0(%esi),%edi
 6d5:	00 00                	add    %al,(%eax)
 6d7:	27                   	daa    
 6d8:	00 25 a2 01 00 00    	add    %ah,0x1a2
 6de:	01 38                	add    %edi,(%eax)
 6e0:	5d                   	pop    %ebp
 6e1:	06                   	push   %es
 6e2:	00 00                	add    %al,(%eax)
 6e4:	05 03 a0 92 00       	add    $0x92a003,%eax
 6e9:	00 26                	add    %ah,(%esi)
 6eb:	b6 01                	mov    $0x1,%dh
 6ed:	00 00                	add    %al,(%eax)
 6ef:	01 06                	add    %eax,(%esi)
 6f1:	4e                   	dec    %esi
 6f2:	01 00                	add    %eax,(%eax)
 6f4:	00 05 03 24 92 00    	add    %al,0x922403
 6fa:	00 26                	add    %ah,(%esi)
 6fc:	ab                   	stos   %eax,%es:(%edi)
 6fd:	01 00                	add    %eax,(%eax)
 6ff:	00 01                	add    %al,(%ecx)
 701:	1e                   	push   %ds
 702:	fd                   	std    
 703:	01 00                	add    %eax,(%eax)
 705:	00 05 03 20 92 00    	add    %al,0x922003
 70b:	00 00                	add    %al,(%eax)
 70d:	cd 06                	int    $0x6
 70f:	00 00                	add    %al,(%eax)
 711:	04 00                	add    $0x0,%al
 713:	2a 02                	sub    (%edx),%al
 715:	00 00                	add    %al,(%eax)
 717:	04 01                	add    $0x1,%al
 719:	2e 00 00             	add    %al,%cs:(%eax)
 71c:	00 0c 68             	add    %cl,(%eax,%ebp,2)
 71f:	04 00                	add    $0x0,%al
 721:	00 50 01             	add    %dl,0x1(%eax)
 724:	00 00                	add    %al,(%eax)
 726:	69 8d 00 00 5d 01 00 	imul   $0x1a50000,0x15d0000(%ebp),%ecx
 72d:	00 a5 01 
 730:	00 00                	add    %al,(%eax)
 732:	02 01                	add    (%ecx),%al
 734:	06                   	push   %es
 735:	ed                   	in     (%dx),%eax
 736:	00 00                	add    %al,(%eax)
 738:	00 03                	add    %al,(%ebx)
 73a:	b8 00 00 00 02       	mov    $0x2000000,%eax
 73f:	0d 37 00 00 00       	or     $0x37,%eax
 744:	02 01                	add    (%ecx),%al
 746:	08 eb                	or     %ch,%bl
 748:	00 00                	add    %al,(%eax)
 74a:	00 02                	add    %al,(%edx)
 74c:	02 05 10 00 00 00    	add    0x10,%al
 752:	03 5e 03             	add    0x3(%esi),%ebx
 755:	00 00                	add    %al,(%eax)
 757:	02 0f                	add    (%edi),%cl
 759:	50                   	push   %eax
 75a:	00 00                	add    %al,(%eax)
 75c:	00 02                	add    %al,(%edx)
 75e:	02 07                	add    (%edi),%al
 760:	3d 01 00 00 04       	cmp    $0x4000001,%eax
 765:	04 05                	add    $0x5,%al
 767:	69 6e 74 00 03 1f 01 	imul   $0x11f0300,0x74(%esi),%ebp
 76e:	00 00                	add    %al,(%eax)
 770:	02 11                	add    (%ecx),%dl
 772:	69 00 00 00 02 04    	imul   $0x4020000,(%eax),%eax
 778:	07                   	pop    %es
 779:	0d 01 00 00 02       	or     $0x2000001,%eax
 77e:	08 05 ca 00 00 00    	or     %al,0xca
 784:	03 02                	add    (%edx),%eax
 786:	02 00                	add    (%eax),%al
 788:	00 02                	add    %al,(%edx)
 78a:	13 82 00 00 00 02    	adc    0x2000000(%edx),%eax
 790:	08 07                	or     %al,(%edi)
 792:	03 01                	add    (%ecx),%eax
 794:	00 00                	add    %al,(%eax)
 796:	05 10 02 65 d9       	add    $0xd9650210,%eax
 79b:	00 00                	add    %al,(%eax)
 79d:	00 06                	add    %al,(%esi)
 79f:	65 02 00             	add    %gs:(%eax),%al
 7a2:	00 02                	add    %al,(%edx)
 7a4:	67 2c 00             	addr16 sub $0x0,%al
 7a7:	00 00                	add    %al,(%eax)
 7a9:	00 06                	add    %al,(%esi)
 7ab:	3b 03                	cmp    (%ebx),%eax
 7ad:	00 00                	add    %al,(%eax)
 7af:	02 6a d9             	add    -0x27(%edx),%ch
 7b2:	00 00                	add    %al,(%eax)
 7b4:	00 01                	add    %al,(%ecx)
 7b6:	07                   	pop    %es
 7b7:	69 64 00 02 6b 2c 00 	imul   $0x2c6b,0x2(%eax,%eax,1),%esp
 7be:	00 
 7bf:	00 04 06             	add    %al,(%esi,%eax,1)
 7c2:	d7                   	xlat   %ds:(%ebx)
 7c3:	03 00                	add    (%eax),%eax
 7c5:	00 02                	add    %al,(%edx)
 7c7:	6f                   	outsl  %ds:(%esi),(%dx)
 7c8:	d9 00                	flds   (%eax)
 7ca:	00 00                	add    %al,(%eax)
 7cc:	05 06 1b 04 00       	add    $0x41b06,%eax
 7d1:	00 02                	add    %al,(%edx)
 7d3:	70 5e                	jo     833 <PROT_MODE_DSEG+0x823>
 7d5:	00 00                	add    %al,(%eax)
 7d7:	00 08                	add    %cl,(%eax)
 7d9:	06                   	push   %es
 7da:	d7                   	xlat   %ds:(%ebx)
 7db:	04 00                	add    $0x0,%al
 7dd:	00 02                	add    %al,(%edx)
 7df:	71 5e                	jno    83f <PROT_MODE_DSEG+0x82f>
 7e1:	00 00                	add    %al,(%eax)
 7e3:	00 0c 00             	add    %cl,(%eax,%eax,1)
 7e6:	08 2c 00             	or     %ch,(%eax,%eax,1)
 7e9:	00 00                	add    %al,(%eax)
 7eb:	e9 00 00 00 09       	jmp    90007f0 <_end+0x8ff7524>
 7f0:	e9 00 00 00 02       	jmp    20007f5 <_end+0x1ff7529>
 7f5:	00 02                	add    %al,(%edx)
 7f7:	04 07                	add    $0x7,%al
 7f9:	1a 00                	sbb    (%eax),%al
 7fb:	00 00                	add    %al,(%eax)
 7fd:	0a 6d 62             	or     0x62(%ebp),%ch
 800:	72 00                	jb     802 <PROT_MODE_DSEG+0x7f2>
 802:	00 02                	add    %al,(%edx)
 804:	02 61 31             	add    0x31(%ecx),%ah
 807:	01 00                	add    %eax,(%eax)
 809:	00 06                	add    %al,(%esi)
 80b:	28 02                	sub    %al,(%edx)
 80d:	00 00                	add    %al,(%eax)
 80f:	02 63 31             	add    0x31(%ebx),%ah
 812:	01 00                	add    %eax,(%eax)
 814:	00 00                	add    %al,(%eax)
 816:	0b bc 01 00 00 02 64 	or     0x64020000(%ecx,%eax,1),%edi
 81d:	42                   	inc    %edx
 81e:	01 00                	add    %eax,(%eax)
 820:	00 b4 01 0b bf 02 00 	add    %dh,0x2bf0b(%ecx,%eax,1)
 827:	00 02                	add    %al,(%edx)
 829:	72 52                	jb     87d <PROT_MODE_DSEG+0x86d>
 82b:	01 00                	add    %eax,(%eax)
 82d:	00 be 01 0b 44 04    	add    %bh,0x4440b01(%esi)
 833:	00 00                	add    %al,(%eax)
 835:	02 73 62             	add    0x62(%ebx),%dh
 838:	01 00                	add    %eax,(%eax)
 83a:	00 fe                	add    %bh,%dh
 83c:	01 00                	add    %eax,(%eax)
 83e:	08 2c 00             	or     %ch,(%eax,%eax,1)
 841:	00 00                	add    %al,(%eax)
 843:	42                   	inc    %edx
 844:	01 00                	add    %eax,(%eax)
 846:	00 0c e9             	add    %cl,(%ecx,%ebp,8)
 849:	00 00                	add    %al,(%eax)
 84b:	00 b3 01 00 08 2c    	add    %dh,0x2c080001(%ebx)
 851:	00 00                	add    %al,(%eax)
 853:	00 52 01             	add    %dl,0x1(%edx)
 856:	00 00                	add    %al,(%eax)
 858:	09 e9                	or     %ebp,%ecx
 85a:	00 00                	add    %al,(%eax)
 85c:	00 09                	add    %cl,(%ecx)
 85e:	00 08                	add    %cl,(%eax)
 860:	89 00                	mov    %eax,(%eax)
 862:	00 00                	add    %al,(%eax)
 864:	62 01                	bound  %eax,(%ecx)
 866:	00 00                	add    %al,(%eax)
 868:	09 e9                	or     %ebp,%ecx
 86a:	00 00                	add    %al,(%eax)
 86c:	00 03                	add    %al,(%ebx)
 86e:	00 08                	add    %cl,(%eax)
 870:	2c 00                	sub    $0x0,%al
 872:	00 00                	add    %al,(%eax)
 874:	72 01                	jb     877 <PROT_MODE_DSEG+0x867>
 876:	00 00                	add    %al,(%eax)
 878:	09 e9                	or     %ebp,%ecx
 87a:	00 00                	add    %al,(%eax)
 87c:	00 01                	add    %al,(%ecx)
 87e:	00 03                	add    %al,(%ebx)
 880:	9d                   	popf   
 881:	02 00                	add    (%eax),%al
 883:	00 02                	add    %al,(%edx)
 885:	74 f0                	je     877 <PROT_MODE_DSEG+0x867>
 887:	00 00                	add    %al,(%eax)
 889:	00 0d 45 03 00 00    	add    %cl,0x345
 88f:	18 02                	sbb    %al,(%edx)
 891:	7e ba                	jle    84d <PROT_MODE_DSEG+0x83d>
 893:	01 00                	add    %eax,(%eax)
 895:	00 06                	add    %al,(%esi)
 897:	16                   	push   %ss
 898:	04 00                	add    $0x0,%al
 89a:	00 02                	add    %al,(%edx)
 89c:	7f 5e                	jg     8fc <PROT_MODE_DSEG+0x8ec>
 89e:	00 00                	add    %al,(%eax)
 8a0:	00 00                	add    %al,(%eax)
 8a2:	06                   	push   %es
 8a3:	e0 03                	loopne 8a8 <PROT_MODE_DSEG+0x898>
 8a5:	00 00                	add    %al,(%eax)
 8a7:	02 80 77 00 00 00    	add    0x77(%eax),%al
 8ad:	04 06                	add    $0x6,%al
 8af:	6c                   	insb   (%dx),%es:(%edi)
 8b0:	03 00                	add    (%eax),%eax
 8b2:	00 02                	add    %al,(%edx)
 8b4:	81 77 00 00 00 0c 06 	xorl   $0x60c0000,0x0(%edi)
 8bb:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 8bc:	02 00                	add    (%eax),%al
 8be:	00 02                	add    %al,(%edx)
 8c0:	82                   	(bad)  
 8c1:	5e                   	pop    %esi
 8c2:	00 00                	add    %al,(%eax)
 8c4:	00 14 00             	add    %dl,(%eax,%eax,1)
 8c7:	03 c9                	add    %ecx,%ecx
 8c9:	02 00                	add    (%eax),%al
 8cb:	00 02                	add    %al,(%edx)
 8cd:	83 7d 01 00          	cmpl   $0x0,0x1(%ebp)
 8d1:	00 0d c5 01 00 00    	add    %cl,0x1c5
 8d7:	34 02                	xor    $0x2,%al
 8d9:	8b 86 02 00 00 06    	mov    0x6000002(%esi),%eax
 8df:	cf                   	iret   
 8e0:	03 00                	add    (%eax),%eax
 8e2:	00 02                	add    %al,(%edx)
 8e4:	8c 5e 00             	mov    %ds,0x0(%esi)
 8e7:	00 00                	add    %al,(%eax)
 8e9:	00 06                	add    %al,(%esi)
 8eb:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
 8ec:	03 00                	add    (%eax),%eax
 8ee:	00 02                	add    %al,(%edx)
 8f0:	8d 86 02 00 00 04    	lea    0x4000002(%esi),%eax
 8f6:	06                   	push   %es
 8f7:	a3 02 00 00 02       	mov    %eax,0x2000002
 8fc:	8e 45 00             	mov    0x0(%ebp),%es
 8ff:	00 00                	add    %al,(%eax)
 901:	10 06                	adc    %al,(%esi)
 903:	43                   	inc    %ebx
 904:	02 00                	add    (%eax),%al
 906:	00 02                	add    %al,(%edx)
 908:	8f 45 00             	popl   0x0(%ebp)
 90b:	00 00                	add    %al,(%eax)
 90d:	12 06                	adc    (%esi),%al
 90f:	10 03                	adc    %al,(%ebx)
 911:	00 00                	add    %al,(%eax)
 913:	02 90 5e 00 00 00    	add    0x5e(%eax),%dl
 919:	14 06                	adc    $0x6,%al
 91b:	fa                   	cli    
 91c:	01 00                	add    %eax,(%eax)
 91e:	00 02                	add    %al,(%edx)
 920:	91                   	xchg   %eax,%ecx
 921:	5e                   	pop    %esi
 922:	00 00                	add    %al,(%eax)
 924:	00 18                	add    %bl,(%eax)
 926:	06                   	push   %es
 927:	ba 03 00 00 02       	mov    $0x2000003,%edx
 92c:	92                   	xchg   %eax,%edx
 92d:	5e                   	pop    %esi
 92e:	00 00                	add    %al,(%eax)
 930:	00 1c 06             	add    %bl,(%esi,%eax,1)
 933:	f3 03 00             	repz add (%eax),%eax
 936:	00 02                	add    %al,(%edx)
 938:	93                   	xchg   %eax,%ebx
 939:	5e                   	pop    %esi
 93a:	00 00                	add    %al,(%eax)
 93c:	00 20                	add    %ah,(%eax)
 93e:	06                   	push   %es
 93f:	33 02                	xor    (%edx),%eax
 941:	00 00                	add    %al,(%eax)
 943:	02 94 5e 00 00 00 24 	add    0x24000000(%esi,%ebx,2),%dl
 94a:	06                   	push   %es
 94b:	b6 02                	mov    $0x2,%dh
 94d:	00 00                	add    %al,(%eax)
 94f:	02 95 45 00 00 00    	add    0x45(%ebp),%dl
 955:	28 06                	sub    %al,(%esi)
 957:	f8                   	clc    
 958:	02 00                	add    (%eax),%al
 95a:	00 02                	add    %al,(%edx)
 95c:	96                   	xchg   %eax,%esi
 95d:	45                   	inc    %ebp
 95e:	00 00                	add    %al,(%eax)
 960:	00 2a                	add    %ch,(%edx)
 962:	06                   	push   %es
 963:	3c 04                	cmp    $0x4,%al
 965:	00 00                	add    %al,(%eax)
 967:	02 97 45 00 00 00    	add    0x45(%edi),%dl
 96d:	2c 06                	sub    $0x6,%al
 96f:	8b 02                	mov    (%edx),%eax
 971:	00 00                	add    %al,(%eax)
 973:	02 98 45 00 00 00    	add    0x45(%eax),%bl
 979:	2e 06                	cs push %es
 97b:	4e                   	dec    %esi
 97c:	04 00                	add    $0x0,%al
 97e:	00 02                	add    %al,(%edx)
 980:	99                   	cltd   
 981:	45                   	inc    %ebp
 982:	00 00                	add    %al,(%eax)
 984:	00 30                	add    %dh,(%eax)
 986:	06                   	push   %es
 987:	cc                   	int3   
 988:	01 00                	add    %eax,(%eax)
 98a:	00 02                	add    %al,(%edx)
 98c:	9a 45 00 00 00 32 00 	lcall  $0x32,$0x45
 993:	08 2c 00             	or     %ch,(%eax,%eax,1)
 996:	00 00                	add    %al,(%eax)
 998:	96                   	xchg   %eax,%esi
 999:	02 00                	add    (%eax),%al
 99b:	00 09                	add    %cl,(%ecx)
 99d:	e9 00 00 00 0b       	jmp    b0009a2 <_end+0xaff76d6>
 9a2:	00 03                	add    %al,(%ebx)
 9a4:	e1 01                	loope  9a7 <PROT_MODE_DSEG+0x997>
 9a6:	00 00                	add    %al,(%eax)
 9a8:	02 9b c5 01 00 00    	add    0x1c5(%ebx),%bl
 9ae:	0d 83 02 00 00       	or     $0x283,%eax
 9b3:	20 02                	and    %al,(%edx)
 9b5:	9e                   	sahf   
 9b6:	0e                   	push   %cs
 9b7:	03 00                	add    (%eax),%eax
 9b9:	00 06                	add    %al,(%esi)
 9bb:	7c 02                	jl     9bf <PROT_MODE_DSEG+0x9af>
 9bd:	00 00                	add    %al,(%eax)
 9bf:	02 9f 5e 00 00 00    	add    0x5e(%edi),%bl
 9c5:	00 06                	add    %al,(%esi)
 9c7:	1f                   	pop    %ds
 9c8:	02 00                	add    (%eax),%al
 9ca:	00 02                	add    %al,(%edx)
 9cc:	a0 5e 00 00 00       	mov    0x5e,%al
 9d1:	04 06                	add    $0x6,%al
 9d3:	7e 03                	jle    9d8 <PROT_MODE_DSEG+0x9c8>
 9d5:	00 00                	add    %al,(%eax)
 9d7:	02 a1 5e 00 00 00    	add    0x5e(%ecx),%ah
 9dd:	08 06                	or     %al,(%esi)
 9df:	d2 04 00             	rolb   %cl,(%eax,%eax,1)
 9e2:	00 02                	add    %al,(%edx)
 9e4:	a2 5e 00 00 00       	mov    %al,0x5e
 9e9:	0c 06                	or     $0x6,%al
 9eb:	33 04 00             	xor    (%eax,%eax,1),%eax
 9ee:	00 02                	add    %al,(%edx)
 9f0:	a3 5e 00 00 00       	mov    %eax,0x5e
 9f5:	10 06                	adc    %al,(%esi)
 9f7:	17                   	pop    %ss
 9f8:	02 00                	add    (%eax),%al
 9fa:	00 02                	add    %al,(%edx)
 9fc:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 9fd:	5e                   	pop    %esi
 9fe:	00 00                	add    %al,(%eax)
 a00:	00 14 06             	add    %dl,(%esi,%eax,1)
 a03:	94                   	xchg   %eax,%esp
 a04:	03 00                	add    (%eax),%eax
 a06:	00 02                	add    %al,(%edx)
 a08:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 a09:	5e                   	pop    %esi
 a0a:	00 00                	add    %al,(%eax)
 a0c:	00 18                	add    %bl,(%eax)
 a0e:	06                   	push   %es
 a0f:	c0 04 00 00          	rolb   $0x0,(%eax,%eax,1)
 a13:	02 a6 5e 00 00 00    	add    0x5e(%esi),%ah
 a19:	1c 00                	sbb    $0x0,%al
 a1b:	03 83 02 00 00 02    	add    0x2000002(%ebx),%eax
 a21:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
 a22:	a1 02 00 00 05       	mov    0x5000002,%eax
 a27:	04 02                	add    $0x2,%al
 a29:	b6 52                	mov    $0x52,%dh
 a2b:	03 00                	add    (%eax),%eax
 a2d:	00 06                	add    %al,(%esi)
 a2f:	26 03 00             	add    %es:(%eax),%eax
 a32:	00 02                	add    %al,(%edx)
 a34:	b7 2c                	mov    $0x2c,%bh
 a36:	00 00                	add    %al,(%eax)
 a38:	00 00                	add    %al,(%eax)
 a3a:	06                   	push   %es
 a3b:	1a 03                	sbb    (%ebx),%al
 a3d:	00 00                	add    %al,(%eax)
 a3f:	02 b8 2c 00 00 00    	add    0x2c(%eax),%bh
 a45:	01 06                	add    %eax,(%esi)
 a47:	20 03                	and    %al,(%ebx)
 a49:	00 00                	add    %al,(%eax)
 a4b:	02 b9 2c 00 00 00    	add    0x2c(%ecx),%bh
 a51:	02 06                	add    (%esi),%al
 a53:	76 02                	jbe    a57 <PROT_MODE_DSEG+0xa47>
 a55:	00 00                	add    %al,(%eax)
 a57:	02 ba 2c 00 00 00    	add    0x2c(%edx),%bh
 a5d:	03 00                	add    (%eax),%eax
 a5f:	05 10 02 c7 8b       	add    $0x8bc70210,%eax
 a64:	03 00                	add    (%eax),%eax
 a66:	00 06                	add    %al,(%esi)
 a68:	13 04 00             	adc    (%eax,%eax,1),%eax
 a6b:	00 02                	add    %al,(%edx)
 a6d:	c8 5e 00 00          	enter  $0x5e,$0x0
 a71:	00 00                	add    %al,(%eax)
 a73:	06                   	push   %es
 a74:	6e                   	outsb  %ds:(%esi),(%dx)
 a75:	02 00                	add    (%eax),%al
 a77:	00 02                	add    %al,(%edx)
 a79:	c9                   	leave  
 a7a:	5e                   	pop    %esi
 a7b:	00 00                	add    %al,(%eax)
 a7d:	00 04 06             	add    %al,(%esi,%eax,1)
 a80:	e5 03                	in     $0x3,%eax
 a82:	00 00                	add    %al,(%eax)
 a84:	02 ca                	add    %dl,%cl
 a86:	5e                   	pop    %esi
 a87:	00 00                	add    %al,(%eax)
 a89:	00 08                	add    %cl,(%eax)
 a8b:	06                   	push   %es
 a8c:	8a 04 00             	mov    (%eax,%eax,1),%al
 a8f:	00 02                	add    %al,(%edx)
 a91:	cb                   	lret   
 a92:	5e                   	pop    %esi
 a93:	00 00                	add    %al,(%eax)
 a95:	00 0c 00             	add    %cl,(%eax,%eax,1)
 a98:	05 10 02 cd c4       	add    $0xc4cd0210,%eax
 a9d:	03 00                	add    (%eax),%eax
 a9f:	00 07                	add    %al,(%edi)
 aa1:	6e                   	outsb  %ds:(%esi),(%dx)
 aa2:	75 6d                	jne    b11 <PROT_MODE_DSEG+0xb01>
 aa4:	00 02                	add    %al,(%edx)
 aa6:	ce                   	into   
 aa7:	5e                   	pop    %esi
 aa8:	00 00                	add    %al,(%eax)
 aaa:	00 00                	add    %al,(%eax)
 aac:	06                   	push   %es
 aad:	16                   	push   %ss
 aae:	04 00                	add    $0x0,%al
 ab0:	00 02                	add    %al,(%edx)
 ab2:	cf                   	iret   
 ab3:	5e                   	pop    %esi
 ab4:	00 00                	add    %al,(%eax)
 ab6:	00 04 06             	add    %al,(%esi,%eax,1)
 ab9:	e5 03                	in     $0x3,%eax
 abb:	00 00                	add    %al,(%eax)
 abd:	02 d0                	add    %al,%dl
 abf:	5e                   	pop    %esi
 ac0:	00 00                	add    %al,(%eax)
 ac2:	00 08                	add    %cl,(%eax)
 ac4:	06                   	push   %es
 ac5:	97                   	xchg   %eax,%edi
 ac6:	02 00                	add    (%eax),%al
 ac8:	00 02                	add    %al,(%edx)
 aca:	d1 5e 00             	rcrl   0x0(%esi)
 acd:	00 00                	add    %al,(%eax)
 acf:	0c 00                	or     $0x0,%al
 ad1:	0e                   	push   %cs
 ad2:	10 02                	adc    %al,(%edx)
 ad4:	c6                   	(bad)  
 ad5:	e3 03                	jecxz  ada <PROT_MODE_DSEG+0xaca>
 ad7:	00 00                	add    %al,(%eax)
 ad9:	0f ad 03             	shrd   %cl,%eax,(%ebx)
 adc:	00 00                	add    %al,(%eax)
 ade:	02 cc                	add    %ah,%cl
 ae0:	52                   	push   %edx
 ae1:	03 00                	add    (%eax),%eax
 ae3:	00 10                	add    %dl,(%eax)
 ae5:	65 6c                	gs insb (%dx),%es:(%edi)
 ae7:	66 00 02             	data16 add %al,(%edx)
 aea:	d2 8b 03 00 00 00    	rorb   %cl,0x3(%ebx)
 af0:	0d 73 03 00 00       	or     $0x373,%eax
 af5:	60                   	pusha  
 af6:	02 ae ec 04 00 00    	add    0x4ec(%esi),%ch
 afc:	06                   	push   %es
 afd:	35 02 00 00 02       	xor    $0x2000002,%eax
 b02:	af                   	scas   %es:(%edi),%eax
 b03:	5e                   	pop    %esi
 b04:	00 00                	add    %al,(%eax)
 b06:	00 00                	add    %al,(%eax)
 b08:	06                   	push   %es
 b09:	4f                   	dec    %edi
 b0a:	03 00                	add    (%eax),%eax
 b0c:	00 02                	add    %al,(%edx)
 b0e:	b2 5e                	mov    $0x5e,%dl
 b10:	00 00                	add    %al,(%eax)
 b12:	00 04 06             	add    %al,(%esi,%eax,1)
 b15:	fb                   	sti    
 b16:	03 00                	add    (%eax),%eax
 b18:	00 02                	add    %al,(%edx)
 b1a:	b3 5e                	mov    $0x5e,%bl
 b1c:	00 00                	add    %al,(%eax)
 b1e:	00 08                	add    %cl,(%eax)
 b20:	06                   	push   %es
 b21:	e2 02                	loop   b25 <PROT_MODE_DSEG+0xb15>
 b23:	00 00                	add    %al,(%eax)
 b25:	02 bb 19 03 00 00    	add    0x319(%ebx),%bh
 b2b:	0c 06                	or     $0x6,%al
 b2d:	3b 02                	cmp    (%edx),%eax
 b2f:	00 00                	add    %al,(%eax)
 b31:	02 be 5e 00 00 00    	add    0x5e(%esi),%bh
 b37:	10 06                	adc    %al,(%esi)
 b39:	7f 04                	jg     b3f <PROT_MODE_DSEG+0xb2f>
 b3b:	00 00                	add    %al,(%eax)
 b3d:	02 c2                	add    %dl,%al
 b3f:	5e                   	pop    %esi
 b40:	00 00                	add    %al,(%eax)
 b42:	00 14 06             	add    %dl,(%esi,%eax,1)
 b45:	59                   	pop    %ecx
 b46:	02 00                	add    (%eax),%al
 b48:	00 02                	add    %al,(%edx)
 b4a:	c3                   	ret    
 b4b:	5e                   	pop    %esi
 b4c:	00 00                	add    %al,(%eax)
 b4e:	00 18                	add    %bl,(%eax)
 b50:	06                   	push   %es
 b51:	59                   	pop    %ecx
 b52:	03 00                	add    (%eax),%eax
 b54:	00 02                	add    %al,(%edx)
 b56:	d3 c4                	rol    %cl,%esp
 b58:	03 00                	add    (%eax),%eax
 b5a:	00 1c 06             	add    %bl,(%esi,%eax,1)
 b5d:	67 03 00             	add    (%bx,%si),%eax
 b60:	00 02                	add    %al,(%edx)
 b62:	d6                   	(bad)  
 b63:	5e                   	pop    %esi
 b64:	00 00                	add    %al,(%eax)
 b66:	00 2c 06             	add    %ch,(%esi,%eax,1)
 b69:	d7                   	xlat   %ds:(%ebx)
 b6a:	01 00                	add    %eax,(%eax)
 b6c:	00 02                	add    %al,(%edx)
 b6e:	d8 5e 00             	fcomps 0x0(%esi)
 b71:	00 00                	add    %al,(%eax)
 b73:	30 06                	xor    %al,(%esi)
 b75:	25 04 00 00 02       	and    $0x2000004,%eax
 b7a:	dc 5e 00             	fcompl 0x0(%esi)
 b7d:	00 00                	add    %al,(%eax)
 b7f:	34 06                	xor    $0x6,%al
 b81:	aa                   	stos   %al,%es:(%edi)
 b82:	02 00                	add    (%eax),%al
 b84:	00 02                	add    %al,(%edx)
 b86:	dd 5e 00             	fstpl  0x0(%esi)
 b89:	00 00                	add    %al,(%eax)
 b8b:	38 06                	cmp    %al,(%esi)
 b8d:	c2 03 00             	ret    $0x3
 b90:	00 02                	add    %al,(%edx)
 b92:	e0 5e                	loopne bf2 <PROT_MODE_DSEG+0xbe2>
 b94:	00 00                	add    %al,(%eax)
 b96:	00 3c 06             	add    %bh,(%esi,%eax,1)
 b99:	94                   	xchg   %eax,%esp
 b9a:	04 00                	add    $0x0,%al
 b9c:	00 02                	add    %al,(%edx)
 b9e:	e3 5e                	jecxz  bfe <PROT_MODE_DSEG+0xbee>
 ba0:	00 00                	add    %al,(%eax)
 ba2:	00 40 06             	add    %al,0x6(%eax)
 ba5:	c8 04 00 00          	enter  $0x4,$0x0
 ba9:	02 e6                	add    %dh,%ah
 bab:	5e                   	pop    %esi
 bac:	00 00                	add    %al,(%eax)
 bae:	00 44 06 83          	add    %al,-0x7d(%esi,%eax,1)
 bb2:	03 00                	add    (%eax),%eax
 bb4:	00 02                	add    %al,(%edx)
 bb6:	e9 5e 00 00 00       	jmp    c19 <PROT_MODE_DSEG+0xc09>
 bbb:	48                   	dec    %eax
 bbc:	06                   	push   %es
 bbd:	05 04 00 00 02       	add    $0x2000004,%eax
 bc2:	ea 5e 00 00 00 4c 06 	ljmp   $0x64c,$0x5e
 bc9:	ea 03 00 00 02 eb 5e 	ljmp   $0x5eeb,$0x2000003
 bd0:	00 00                	add    %al,(%eax)
 bd2:	00 50 06             	add    %dl,0x6(%eax)
 bd5:	a5                   	movsl  %ds:(%esi),%es:(%edi)
 bd6:	04 00                	add    $0x0,%al
 bd8:	00 02                	add    %al,(%edx)
 bda:	ec                   	in     (%dx),%al
 bdb:	5e                   	pop    %esi
 bdc:	00 00                	add    %al,(%eax)
 bde:	00 54 06 e8          	add    %dl,-0x18(%esi,%eax,1)
 be2:	01 00                	add    %eax,(%eax)
 be4:	00 02                	add    %al,(%edx)
 be6:	ed                   	in     (%dx),%eax
 be7:	5e                   	pop    %esi
 be8:	00 00                	add    %al,(%eax)
 bea:	00 58 06             	add    %bl,0x6(%eax)
 bed:	56                   	push   %esi
 bee:	04 00                	add    $0x0,%al
 bf0:	00 02                	add    %al,(%edx)
 bf2:	ee                   	out    %al,(%dx)
 bf3:	5e                   	pop    %esi
 bf4:	00 00                	add    %al,(%eax)
 bf6:	00 5c 00 03          	add    %bl,0x3(%eax,%eax,1)
 bfa:	d5 02                	aad    $0x2
 bfc:	00 00                	add    %al,(%eax)
 bfe:	02 ef                	add    %bh,%ch
 c00:	e3 03                	jecxz  c05 <PROT_MODE_DSEG+0xbf5>
 c02:	00 00                	add    %al,(%eax)
 c04:	11 0b                	adc    %ecx,(%ebx)
 c06:	02 00                	add    (%eax),%al
 c08:	00 01                	add    %al,(%ecx)
 c0a:	4b                   	dec    %ebx
 c0b:	5e                   	pop    %esi
 c0c:	00 00                	add    %al,(%eax)
 c0e:	00 69 8d             	add    %ch,-0x73(%ecx)
 c11:	00 00                	add    %al,(%eax)
 c13:	81 00 00 00 01 9c    	addl   $0x9c010000,(%eax)
 c19:	57                   	push   %edi
 c1a:	05 00 00 12 b2       	add    $0xb2120000,%eax
 c1f:	03 00                	add    (%eax),%eax
 c21:	00 01                	add    %al,(%ecx)
 c23:	4b                   	dec    %ebx
 c24:	5e                   	pop    %esi
 c25:	00 00                	add    %al,(%eax)
 c27:	00 02                	add    %al,(%edx)
 c29:	91                   	xchg   %eax,%ecx
 c2a:	00 13                	add    %dl,(%ebx)
 c2c:	70 68                	jo     c96 <PROT_MODE_DSEG+0xc86>
 c2e:	00 01                	add    %al,(%ecx)
 c30:	4e                   	dec    %esi
 c31:	57                   	push   %edi
 c32:	05 00 00 db 03       	add    $0x3db0000,%eax
 c37:	00 00                	add    %al,(%eax)
 c39:	13 65 70             	adc    0x70(%ebp),%esp
 c3c:	68 00 01 4e 57       	push   $0x574e0100
 c41:	05 00 00 1b 04       	add    $0x41b0000,%eax
 c46:	00 00                	add    %al,(%eax)
 c48:	14 87                	adc    $0x87,%al
 c4a:	8d 00                	lea    (%eax),%eax
 c4c:	00 8e 06 00 00 14    	add    %cl,0x14000006(%esi)
 c52:	a3 8d 00 00 99       	mov    %eax,0x9900008d
 c57:	06                   	push   %es
 c58:	00 00                	add    %al,(%eax)
 c5a:	14 d3                	adc    $0xd3,%al
 c5c:	8d 00                	lea    (%eax),%eax
 c5e:	00 8e 06 00 00 00    	add    %cl,0x6(%esi)
 c64:	15 04 0e 03 00       	adc    $0x30e04,%eax
 c69:	00 11                	add    %dl,(%ecx)
 c6b:	9c                   	pushf  
 c6c:	03 00                	add    (%eax),%eax
 c6e:	00 01                	add    %al,(%ecx)
 c70:	67 b3 05             	addr16 mov $0x5,%bl
 c73:	00 00                	add    %al,(%eax)
 c75:	ea 8d 00 00 5f 00 00 	ljmp   $0x0,$0x5f00008d
 c7c:	00 01                	add    %al,(%ecx)
 c7e:	9c                   	pushf  
 c7f:	b3 05                	mov    $0x5,%bl
 c81:	00 00                	add    %al,(%eax)
 c83:	12 0b                	adc    (%ebx),%cl
 c85:	03 00                	add    (%eax),%eax
 c87:	00 01                	add    %al,(%ecx)
 c89:	67 b9 05 00 00 02    	addr16 mov $0x2000005,%ecx
 c8f:	91                   	xchg   %eax,%ecx
 c90:	00 13                	add    %dl,(%ebx)
 c92:	70 00                	jo     c94 <PROT_MODE_DSEG+0xc84>
 c94:	01 69 b9             	add    %ebp,-0x47(%ecx)
 c97:	05 00 00 2e 04       	add    $0x42e0000,%eax
 c9c:	00 00                	add    %al,(%eax)
 c9e:	16                   	push   %ss
 c9f:	b7 04                	mov    $0x4,%bh
 ca1:	00 00                	add    %al,(%eax)
 ca3:	01 6a 5e             	add    %ebp,0x5e(%edx)
 ca6:	00 00                	add    %al,(%eax)
 ca8:	00 65 04             	add    %ah,0x4(%ebp)
 cab:	00 00                	add    %al,(%eax)
 cad:	14 01                	adc    $0x1,%al
 caf:	8e 00                	mov    (%eax),%es
 cb1:	00 a4 06 00 00 14 1e 	add    %ah,0x1e140000(%esi,%eax,1)
 cb8:	8e 00                	mov    (%eax),%es
 cba:	00 af 06 00 00 00    	add    %ch,0x6(%edi)
 cc0:	15 04 ec 04 00       	adc    $0x4ec04,%eax
 cc5:	00 15 04 ba 01 00    	add    %dl,0x1ba04
 ccb:	00 17                	add    %dl,(%edi)
 ccd:	ee                   	out    %al,(%dx)
 cce:	02 00                	add    (%eax),%al
 cd0:	00 01                	add    %al,(%ecx)
 cd2:	1e                   	push   %ds
 cd3:	49                   	dec    %ecx
 cd4:	8e 00                	mov    (%eax),%es
 cd6:	00 7d 00             	add    %bh,0x0(%ebp)
 cd9:	00 00                	add    %al,(%eax)
 cdb:	01 9c 77 06 00 00 18 	add    %ebx,0x18000006(%edi,%esi,2)
 ce2:	6d                   	insl   (%dx),%es:(%edi)
 ce3:	62 72 00             	bound  %esi,0x0(%edx)
 ce6:	01 1e                	add    %ebx,(%esi)
 ce8:	77 06                	ja     cf0 <PROT_MODE_DSEG+0xce0>
 cea:	00 00                	add    %al,(%eax)
 cec:	02 91 00 12 0b 03    	add    0x30b1200(%ecx),%dl
 cf2:	00 00                	add    %al,(%eax)
 cf4:	01 1e                	add    %ebx,(%esi)
 cf6:	b9 05 00 00 02       	mov    $0x2000005,%ecx
 cfb:	91                   	xchg   %eax,%ecx
 cfc:	04 13                	add    $0x13,%al
 cfe:	69 00 01 25 57 00    	imul   $0x572501,(%eax),%eax
 d04:	00 00                	add    %al,(%eax)
 d06:	b1 04                	mov    $0x4,%cl
 d08:	00 00                	add    %al,(%eax)
 d0a:	19 6c 03 00          	sbb    %ebp,0x0(%ebx,%eax,1)
 d0e:	00 01                	add    %al,(%ecx)
 d10:	26 57                	es push %edi
 d12:	00 00                	add    %al,(%eax)
 d14:	00 04 16             	add    %al,(%esi,%edx,1)
 d17:	63 02                	arpl   %ax,(%edx)
 d19:	00 00                	add    %al,(%eax)
 d1b:	01 27                	add    %esp,(%edi)
 d1d:	57                   	push   %edi
 d1e:	00 00                	add    %al,(%eax)
 d20:	00 e8                	add    %ch,%al
 d22:	04 00                	add    $0x0,%al
 d24:	00 1a                	add    %bl,(%edx)
 d26:	30 00                	xor    %al,(%eax)
 d28:	00 00                	add    %al,(%eax)
 d2a:	5b                   	pop    %ebx
 d2b:	06                   	push   %es
 d2c:	00 00                	add    %al,(%eax)
 d2e:	16                   	push   %ss
 d2f:	2d 03 00 00 01       	sub    $0x1000003,%eax
 d34:	38 5e 00             	cmp    %bl,0x0(%esi)
 d37:	00 00                	add    %al,(%eax)
 d39:	08 05 00 00 16 04    	or     %al,0x4160000
 d3f:	03 00                	add    (%eax),%eax
 d41:	00 01                	add    %al,(%ecx)
 d43:	39 b3 05 00 00 32    	cmp    %esi,0x32000005(%ebx)
 d49:	05 00 00 14 a8       	add    $0xa8140000,%eax
 d4e:	8e 00                	mov    (%eax),%es
 d50:	00 f7                	add    %dh,%bh
 d52:	04 00                	add    $0x0,%al
 d54:	00 14 b2             	add    %dl,(%edx,%esi,4)
 d57:	8e 00                	mov    (%eax),%es
 d59:	00 5d 05             	add    %bl,0x5(%ebp)
 d5c:	00 00                	add    %al,(%eax)
 d5e:	1b c6                	sbb    %esi,%eax
 d60:	8e 00                	mov    (%eax),%es
 d62:	00 ba 06 00 00 00    	add    %bh,0x6(%edx)
 d68:	14 5e                	adc    $0x5e,%al
 d6a:	8e 00                	mov    (%eax),%es
 d6c:	00 c5                	add    %al,%ch
 d6e:	06                   	push   %es
 d6f:	00 00                	add    %al,(%eax)
 d71:	14 6a                	adc    $0x6a,%al
 d73:	8e 00                	mov    (%eax),%es
 d75:	00 a4 06 00 00 1b 96 	add    %ah,-0x69e50000(%esi,%eax,1)
 d7c:	8e 00                	mov    (%eax),%es
 d7e:	00 99 06 00 00 00    	add    %bl,0x6(%ecx)
 d84:	15 04 72 01 00       	adc    $0x17204,%eax
 d89:	00 1c 73             	add    %bl,(%ebx,%esi,2)
 d8c:	03 00                	add    (%eax),%eax
 d8e:	00 01                	add    %al,(%ecx)
 d90:	13 ec                	adc    %esp,%ebp
 d92:	04 00                	add    $0x0,%al
 d94:	00 05 03 40 92 00    	add    %al,0x924003
 d9a:	00 1d df 00 00 00    	add    %bl,0xdf
 da0:	df 00                	fild   (%eax)
 da2:	00 00                	add    %al,(%eax)
 da4:	02 78 1d             	add    0x1d(%eax),%bh
 da7:	28 00                	sub    %al,(%eax)
 da9:	00 00                	add    %al,(%eax)
 dab:	28 00                	sub    %al,(%eax)
 dad:	00 00                	add    %al,(%eax)
 daf:	02 52 1d             	add    0x1d(%edx),%dl
 db2:	92                   	xchg   %eax,%edx
 db3:	01 00                	add    %eax,(%eax)
 db5:	00 92 01 00 00 02    	add    %dl,0x2000001(%edx)
 dbb:	4f                   	dec    %edi
 dbc:	1d 92 00 00 00       	sbb    $0x92,%eax
 dc1:	92                   	xchg   %eax,%edx
 dc2:	00 00                	add    %al,(%eax)
 dc4:	00 02                	add    %al,(%edx)
 dc6:	50                   	push   %eax
 dc7:	1d 4d 02 00 00       	sbb    $0x24d,%eax
 dcc:	4d                   	dec    %ebp
 dcd:	02 00                	add    (%eax),%al
 dcf:	00 01                	add    %al,(%ecx)
 dd1:	11 1d 23 00 00 00    	adc    %ebx,0x23
 dd7:	23 00                	and    (%eax),%eax
 dd9:	00 00                	add    %al,(%eax)
 ddb:	02 51 00             	add    0x0(%ecx),%dl
 dde:	6e                   	outsb  %ds:(%esi),(%dx)
 ddf:	00 00                	add    %al,(%eax)
 de1:	00 02                	add    %al,(%edx)
 de3:	00 c9                	add    %cl,%cl
 de5:	03 00                	add    (%eax),%eax
 de7:	00 04 01             	add    %al,(%ecx,%eax,1)
 dea:	59                   	pop    %ecx
 deb:	02 00                	add    (%eax),%al
 ded:	00 c6                	add    %al,%dh
 def:	8e 00                	mov    (%eax),%es
 df1:	00 d6                	add    %dl,%dh
 df3:	8e 00                	mov    (%eax),%es
 df5:	00 62 6f             	add    %ah,0x6f(%edx)
 df8:	6f                   	outsl  %ds:(%esi),(%dx)
 df9:	74 2f                	je     e2a <PROT_MODE_DSEG+0xe1a>
 dfb:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 dfe:	74 31                	je     e31 <PROT_MODE_DSEG+0xe21>
 e00:	2f                   	das    
 e01:	65 78 65             	gs js  e69 <PROT_MODE_DSEG+0xe59>
 e04:	63 5f 6b             	arpl   %bx,0x6b(%edi)
 e07:	65 72 6e             	gs jb  e78 <PROT_MODE_DSEG+0xe68>
 e0a:	65 6c                	gs insb (%dx),%es:(%edi)
 e0c:	2e 53                	cs push %ebx
 e0e:	00 2f                	add    %ch,(%edi)
 e10:	68 6f 6d 65 2f       	push   $0x2f656d6f
 e15:	73 75                	jae    e8c <PROT_MODE_DSEG+0xe7c>
 e17:	64 61                	fs popa 
 e19:	72 73                	jb     e8e <PROT_MODE_DSEG+0xe7e>
 e1b:	68 61 6e 2f 43       	push   $0x432f6e61
 e20:	4c                   	dec    %esp
 e21:	69 6f 6e 50 72 6f 6a 	imul   $0x6a6f7250,0x6e(%edi),%ebp
 e28:	65 63 74 73 2f       	arpl   %si,%gs:0x2f(%ebx,%esi,2)
 e2d:	6f                   	outsl  %ds:(%esi),(%dx)
 e2e:	73 2d                	jae    e5d <PROT_MODE_DSEG+0xe4d>
 e30:	73 32                	jae    e64 <PROT_MODE_DSEG+0xe54>
 e32:	30 2d 42 75 6d 62    	xor    %ch,0x626d7542
 e38:	6c                   	insb   (%dx),%es:(%edi)
 e39:	65 46                	gs inc %esi
 e3b:	6c                   	insb   (%dx),%es:(%edi)
 e3c:	61                   	popa   
 e3d:	73 68                	jae    ea7 <PROT_MODE_DSEG+0xe97>
 e3f:	00 47 4e             	add    %al,0x4e(%edi)
 e42:	55                   	push   %ebp
 e43:	20 41 53             	and    %al,0x53(%ecx)
 e46:	20 32                	and    %dh,(%edx)
 e48:	2e 32 36             	xor    %cs:(%esi),%dh
 e4b:	2e 31 00             	xor    %eax,%cs:(%eax)
 e4e:	01                   	.byte 0x1
 e4f:	80                   	.byte 0x80

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	01 11                	add    %edx,(%ecx)
   2:	00 10                	add    %dl,(%eax)
   4:	06                   	push   %es
   5:	11 01                	adc    %eax,(%ecx)
   7:	12 01                	adc    (%ecx),%al
   9:	03 08                	add    (%eax),%ecx
   b:	1b 08                	sbb    (%eax),%ecx
   d:	25 08 13 05 00       	and    $0x51308,%eax
  12:	00 00                	add    %al,(%eax)
  14:	01 11                	add    %edx,(%ecx)
  16:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
  1c:	0e                   	push   %cs
  1d:	1b 0e                	sbb    (%esi),%ecx
  1f:	11 01                	adc    %eax,(%ecx)
  21:	12 06                	adc    (%esi),%al
  23:	10 17                	adc    %dl,(%edi)
  25:	00 00                	add    %al,(%eax)
  27:	02 24 00             	add    (%eax,%eax,1),%ah
  2a:	0b 0b                	or     (%ebx),%ecx
  2c:	3e 0b 03             	or     %ds:(%ebx),%eax
  2f:	0e                   	push   %cs
  30:	00 00                	add    %al,(%eax)
  32:	03 16                	add    (%esi),%edx
  34:	00 03                	add    %al,(%ebx)
  36:	0e                   	push   %cs
  37:	3a 0b                	cmp    (%ebx),%cl
  39:	3b 0b                	cmp    (%ebx),%ecx
  3b:	49                   	dec    %ecx
  3c:	13 00                	adc    (%eax),%eax
  3e:	00 04 24             	add    %al,(%esp)
  41:	00 0b                	add    %cl,(%ebx)
  43:	0b 3e                	or     (%esi),%edi
  45:	0b 03                	or     (%ebx),%eax
  47:	08 00                	or     %al,(%eax)
  49:	00 05 2e 01 03 08    	add    %al,0x803012e
  4f:	3a 0b                	cmp    (%ebx),%cl
  51:	3b 0b                	cmp    (%ebx),%ecx
  53:	27                   	daa    
  54:	19 49 13             	sbb    %ecx,0x13(%ecx)
  57:	20 0b                	and    %cl,(%ebx)
  59:	01 13                	add    %edx,(%ebx)
  5b:	00 00                	add    %al,(%eax)
  5d:	06                   	push   %es
  5e:	05 00 03 0e 3a       	add    $0x3a0e0300,%eax
  63:	0b 3b                	or     (%ebx),%edi
  65:	0b 49 13             	or     0x13(%ecx),%ecx
  68:	00 00                	add    %al,(%eax)
  6a:	07                   	pop    %es
  6b:	34 00                	xor    $0x0,%al
  6d:	03 0e                	add    (%esi),%ecx
  6f:	3a 0b                	cmp    (%ebx),%cl
  71:	3b 0b                	cmp    (%ebx),%ecx
  73:	49                   	dec    %ecx
  74:	13 00                	adc    (%eax),%eax
  76:	00 08                	add    %cl,(%eax)
  78:	2e 01 03             	add    %eax,%cs:(%ebx)
  7b:	0e                   	push   %cs
  7c:	3a 0b                	cmp    (%ebx),%cl
  7e:	3b 0b                	cmp    (%ebx),%ecx
  80:	27                   	daa    
  81:	19 20                	sbb    %esp,(%eax)
  83:	0b 01                	or     (%ecx),%eax
  85:	13 00                	adc    (%eax),%eax
  87:	00 09                	add    %cl,(%ecx)
  89:	05 00 03 08 3a       	add    $0x3a080300,%eax
  8e:	0b 3b                	or     (%ebx),%edi
  90:	0b 49 13             	or     0x13(%ecx),%ecx
  93:	00 00                	add    %al,(%eax)
  95:	0a 0f                	or     (%edi),%cl
  97:	00 0b                	add    %cl,(%ebx)
  99:	0b 00                	or     (%eax),%eax
  9b:	00 0b                	add    %cl,(%ebx)
  9d:	2e 01 3f             	add    %edi,%cs:(%edi)
  a0:	19 03                	sbb    %eax,(%ebx)
  a2:	0e                   	push   %cs
  a3:	3a 0b                	cmp    (%ebx),%cl
  a5:	3b 0b                	cmp    (%ebx),%ecx
  a7:	27                   	daa    
  a8:	19 11                	sbb    %edx,(%ecx)
  aa:	01 12                	add    %edx,(%edx)
  ac:	06                   	push   %es
  ad:	40                   	inc    %eax
  ae:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
  b4:	00 00                	add    %al,(%eax)
  b6:	0c 05                	or     $0x5,%al
  b8:	00 03                	add    %al,(%ebx)
  ba:	08 3a                	or     %bh,(%edx)
  bc:	0b 3b                	or     (%ebx),%edi
  be:	0b 49 13             	or     0x13(%ecx),%ecx
  c1:	02 18                	add    (%eax),%bl
  c3:	00 00                	add    %al,(%eax)
  c5:	0d 05 00 03 0e       	or     $0xe030005,%eax
  ca:	3a 0b                	cmp    (%ebx),%cl
  cc:	3b 0b                	cmp    (%ebx),%ecx
  ce:	49                   	dec    %ecx
  cf:	13 02                	adc    (%edx),%eax
  d1:	18 00                	sbb    %al,(%eax)
  d3:	00 0e                	add    %cl,(%esi)
  d5:	34 00                	xor    $0x0,%al
  d7:	03 08                	add    (%eax),%ecx
  d9:	3a 0b                	cmp    (%ebx),%cl
  db:	3b 0b                	cmp    (%ebx),%ecx
  dd:	49                   	dec    %ecx
  de:	13 02                	adc    (%edx),%eax
  e0:	18 00                	sbb    %al,(%eax)
  e2:	00 0f                	add    %cl,(%edi)
  e4:	0f 00 0b             	str    (%ebx)
  e7:	0b 49 13             	or     0x13(%ecx),%ecx
  ea:	00 00                	add    %al,(%eax)
  ec:	10 35 00 49 13 00    	adc    %dh,0x134900
  f2:	00 11                	add    %dl,(%ecx)
  f4:	2e 01 3f             	add    %edi,%cs:(%edi)
  f7:	19 03                	sbb    %eax,(%ebx)
  f9:	0e                   	push   %cs
  fa:	3a 0b                	cmp    (%ebx),%cl
  fc:	3b 0b                	cmp    (%ebx),%ecx
  fe:	27                   	daa    
  ff:	19 49 13             	sbb    %ecx,0x13(%ecx)
 102:	11 01                	adc    %eax,(%ecx)
 104:	12 06                	adc    (%esi),%al
 106:	40                   	inc    %eax
 107:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
 10d:	00 00                	add    %al,(%eax)
 10f:	12 05 00 03 0e 3a    	adc    0x3a0e0300,%al
 115:	0b 3b                	or     (%ebx),%edi
 117:	0b 49 13             	or     0x13(%ecx),%ecx
 11a:	02 17                	add    (%edi),%dl
 11c:	00 00                	add    %al,(%eax)
 11e:	13 34 00             	adc    (%eax,%eax,1),%esi
 121:	03 08                	add    (%eax),%ecx
 123:	3a 0b                	cmp    (%ebx),%cl
 125:	3b 0b                	cmp    (%ebx),%ecx
 127:	49                   	dec    %ecx
 128:	13 02                	adc    (%edx),%eax
 12a:	17                   	pop    %ss
 12b:	00 00                	add    %al,(%eax)
 12d:	14 89                	adc    $0x89,%al
 12f:	82                   	(bad)  
 130:	01 00                	add    %eax,(%eax)
 132:	11 01                	adc    %eax,(%ecx)
 134:	31 13                	xor    %edx,(%ebx)
 136:	00 00                	add    %al,(%eax)
 138:	15 26 00 49 13       	adc    $0x13490026,%eax
 13d:	00 00                	add    %al,(%eax)
 13f:	16                   	push   %ss
 140:	2e 01 3f             	add    %edi,%cs:(%edi)
 143:	19 03                	sbb    %eax,(%ebx)
 145:	0e                   	push   %cs
 146:	3a 0b                	cmp    (%ebx),%cl
 148:	3b 0b                	cmp    (%ebx),%ecx
 14a:	27                   	daa    
 14b:	19 87 01 19 11 01    	sbb    %eax,0x1111901(%edi)
 151:	12 06                	adc    (%esi),%al
 153:	40                   	inc    %eax
 154:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
 15a:	00 00                	add    %al,(%eax)
 15c:	17                   	pop    %ss
 15d:	05 00 03 08 3a       	add    $0x3a080300,%eax
 162:	0b 3b                	or     (%ebx),%edi
 164:	0b 49 13             	or     0x13(%ecx),%ecx
 167:	02 17                	add    (%edi),%dl
 169:	00 00                	add    %al,(%eax)
 16b:	18 34 00             	sbb    %dh,(%eax,%eax,1)
 16e:	03 0e                	add    (%esi),%ecx
 170:	3a 0b                	cmp    (%ebx),%cl
 172:	3b 0b                	cmp    (%ebx),%ecx
 174:	49                   	dec    %ecx
 175:	13 02                	adc    (%edx),%eax
 177:	17                   	pop    %ss
 178:	00 00                	add    %al,(%eax)
 17a:	19 89 82 01 00 11    	sbb    %ecx,0x11000182(%ecx)
 180:	01 95 42 19 31 13    	add    %edx,0x13311942(%ebp)
 186:	00 00                	add    %al,(%eax)
 188:	1a 01                	sbb    (%ecx),%al
 18a:	01 49 13             	add    %ecx,0x13(%ecx)
 18d:	01 13                	add    %edx,(%ebx)
 18f:	00 00                	add    %al,(%eax)
 191:	1b 21                	sbb    (%ecx),%esp
 193:	00 49 13             	add    %cl,0x13(%ecx)
 196:	2f                   	das    
 197:	0b 00                	or     (%eax),%eax
 199:	00 1c 2e             	add    %bl,(%esi,%ebp,1)
 19c:	00 03                	add    %al,(%ebx)
 19e:	0e                   	push   %cs
 19f:	3a 0b                	cmp    (%ebx),%cl
 1a1:	3b 0b                	cmp    (%ebx),%ecx
 1a3:	27                   	daa    
 1a4:	19 20                	sbb    %esp,(%eax)
 1a6:	0b 00                	or     (%eax),%eax
 1a8:	00 1d 1d 01 31 13    	add    %bl,0x1331011d
 1ae:	52                   	push   %edx
 1af:	01 55 17             	add    %edx,0x17(%ebp)
 1b2:	58                   	pop    %eax
 1b3:	0b 59 0b             	or     0xb(%ecx),%ebx
 1b6:	01 13                	add    %edx,(%ebx)
 1b8:	00 00                	add    %al,(%eax)
 1ba:	1e                   	push   %ds
 1bb:	1d 01 31 13 52       	sbb    $0x52133101,%eax
 1c0:	01 55 17             	add    %edx,0x17(%ebp)
 1c3:	58                   	pop    %eax
 1c4:	0b 59 0b             	or     0xb(%ecx),%ebx
 1c7:	00 00                	add    %al,(%eax)
 1c9:	1f                   	pop    %ds
 1ca:	05 00 31 13 02       	add    $0x2133100,%eax
 1cf:	17                   	pop    %ss
 1d0:	00 00                	add    %al,(%eax)
 1d2:	20 0b                	and    %cl,(%ebx)
 1d4:	01 55 17             	add    %edx,0x17(%ebp)
 1d7:	00 00                	add    %al,(%eax)
 1d9:	21 34 00             	and    %esi,(%eax,%eax,1)
 1dc:	31 13                	xor    %edx,(%ebx)
 1de:	00 00                	add    %al,(%eax)
 1e0:	22 1d 01 31 13 11    	and    0x11133101,%bl
 1e6:	01 12                	add    %edx,(%edx)
 1e8:	06                   	push   %es
 1e9:	58                   	pop    %eax
 1ea:	0b 59 0b             	or     0xb(%ecx),%ebx
 1ed:	01 13                	add    %edx,(%ebx)
 1ef:	00 00                	add    %al,(%eax)
 1f1:	23 1d 01 31 13 11    	and    0x11133101,%ebx
 1f7:	01 12                	add    %edx,(%edx)
 1f9:	06                   	push   %es
 1fa:	58                   	pop    %eax
 1fb:	0b 59 0b             	or     0xb(%ecx),%ebx
 1fe:	00 00                	add    %al,(%eax)
 200:	24 0b                	and    $0xb,%al
 202:	01 11                	add    %edx,(%ecx)
 204:	01 12                	add    %edx,(%edx)
 206:	06                   	push   %es
 207:	00 00                	add    %al,(%eax)
 209:	25 34 00 03 0e       	and    $0xe030034,%eax
 20e:	3a 0b                	cmp    (%ebx),%cl
 210:	3b 0b                	cmp    (%ebx),%ecx
 212:	49                   	dec    %ecx
 213:	13 02                	adc    (%edx),%eax
 215:	18 00                	sbb    %al,(%eax)
 217:	00 26                	add    %ah,(%esi)
 219:	34 00                	xor    $0x0,%al
 21b:	03 0e                	add    (%esi),%ecx
 21d:	3a 0b                	cmp    (%ebx),%cl
 21f:	3b 0b                	cmp    (%ebx),%ecx
 221:	49                   	dec    %ecx
 222:	13 3f                	adc    (%edi),%edi
 224:	19 02                	sbb    %eax,(%edx)
 226:	18 00                	sbb    %al,(%eax)
 228:	00 00                	add    %al,(%eax)
 22a:	01 11                	add    %edx,(%ecx)
 22c:	01 25 0e 13 0b 03    	add    %esp,0x30b130e
 232:	0e                   	push   %cs
 233:	1b 0e                	sbb    (%esi),%ecx
 235:	11 01                	adc    %eax,(%ecx)
 237:	12 06                	adc    (%esi),%al
 239:	10 17                	adc    %dl,(%edi)
 23b:	00 00                	add    %al,(%eax)
 23d:	02 24 00             	add    (%eax,%eax,1),%ah
 240:	0b 0b                	or     (%ebx),%ecx
 242:	3e 0b 03             	or     %ds:(%ebx),%eax
 245:	0e                   	push   %cs
 246:	00 00                	add    %al,(%eax)
 248:	03 16                	add    (%esi),%edx
 24a:	00 03                	add    %al,(%ebx)
 24c:	0e                   	push   %cs
 24d:	3a 0b                	cmp    (%ebx),%cl
 24f:	3b 0b                	cmp    (%ebx),%ecx
 251:	49                   	dec    %ecx
 252:	13 00                	adc    (%eax),%eax
 254:	00 04 24             	add    %al,(%esp)
 257:	00 0b                	add    %cl,(%ebx)
 259:	0b 3e                	or     (%esi),%edi
 25b:	0b 03                	or     (%ebx),%eax
 25d:	08 00                	or     %al,(%eax)
 25f:	00 05 13 01 0b 0b    	add    %al,0xb0b0113
 265:	3a 0b                	cmp    (%ebx),%cl
 267:	3b 0b                	cmp    (%ebx),%ecx
 269:	01 13                	add    %edx,(%ebx)
 26b:	00 00                	add    %al,(%eax)
 26d:	06                   	push   %es
 26e:	0d 00 03 0e 3a       	or     $0x3a0e0300,%eax
 273:	0b 3b                	or     (%ebx),%edi
 275:	0b 49 13             	or     0x13(%ecx),%ecx
 278:	38 0b                	cmp    %cl,(%ebx)
 27a:	00 00                	add    %al,(%eax)
 27c:	07                   	pop    %es
 27d:	0d 00 03 08 3a       	or     $0x3a080300,%eax
 282:	0b 3b                	or     (%ebx),%edi
 284:	0b 49 13             	or     0x13(%ecx),%ecx
 287:	38 0b                	cmp    %cl,(%ebx)
 289:	00 00                	add    %al,(%eax)
 28b:	08 01                	or     %al,(%ecx)
 28d:	01 49 13             	add    %ecx,0x13(%ecx)
 290:	01 13                	add    %edx,(%ebx)
 292:	00 00                	add    %al,(%eax)
 294:	09 21                	or     %esp,(%ecx)
 296:	00 49 13             	add    %cl,0x13(%ecx)
 299:	2f                   	das    
 29a:	0b 00                	or     (%eax),%eax
 29c:	00 0a                	add    %cl,(%edx)
 29e:	13 01                	adc    (%ecx),%eax
 2a0:	03 08                	add    (%eax),%ecx
 2a2:	0b 05 3a 0b 3b 0b    	or     0xb3b0b3a,%eax
 2a8:	01 13                	add    %edx,(%ebx)
 2aa:	00 00                	add    %al,(%eax)
 2ac:	0b 0d 00 03 0e 3a    	or     0x3a0e0300,%ecx
 2b2:	0b 3b                	or     (%ebx),%edi
 2b4:	0b 49 13             	or     0x13(%ecx),%ecx
 2b7:	38 05 00 00 0c 21    	cmp    %al,0x210c0000
 2bd:	00 49 13             	add    %cl,0x13(%ecx)
 2c0:	2f                   	das    
 2c1:	05 00 00 0d 13       	add    $0x130d0000,%eax
 2c6:	01 03                	add    %eax,(%ebx)
 2c8:	0e                   	push   %cs
 2c9:	0b 0b                	or     (%ebx),%ecx
 2cb:	3a 0b                	cmp    (%ebx),%cl
 2cd:	3b 0b                	cmp    (%ebx),%ecx
 2cf:	01 13                	add    %edx,(%ebx)
 2d1:	00 00                	add    %al,(%eax)
 2d3:	0e                   	push   %cs
 2d4:	17                   	pop    %ss
 2d5:	01 0b                	add    %ecx,(%ebx)
 2d7:	0b 3a                	or     (%edx),%edi
 2d9:	0b 3b                	or     (%ebx),%edi
 2db:	0b 01                	or     (%ecx),%eax
 2dd:	13 00                	adc    (%eax),%eax
 2df:	00 0f                	add    %cl,(%edi)
 2e1:	0d 00 03 0e 3a       	or     $0x3a0e0300,%eax
 2e6:	0b 3b                	or     (%ebx),%edi
 2e8:	0b 49 13             	or     0x13(%ecx),%ecx
 2eb:	00 00                	add    %al,(%eax)
 2ed:	10 0d 00 03 08 3a    	adc    %cl,0x3a080300
 2f3:	0b 3b                	or     (%ebx),%edi
 2f5:	0b 49 13             	or     0x13(%ecx),%ecx
 2f8:	00 00                	add    %al,(%eax)
 2fa:	11 2e                	adc    %ebp,(%esi)
 2fc:	01 3f                	add    %edi,(%edi)
 2fe:	19 03                	sbb    %eax,(%ebx)
 300:	0e                   	push   %cs
 301:	3a 0b                	cmp    (%ebx),%cl
 303:	3b 0b                	cmp    (%ebx),%ecx
 305:	27                   	daa    
 306:	19 49 13             	sbb    %ecx,0x13(%ecx)
 309:	11 01                	adc    %eax,(%ecx)
 30b:	12 06                	adc    (%esi),%al
 30d:	40                   	inc    %eax
 30e:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
 314:	00 00                	add    %al,(%eax)
 316:	12 05 00 03 0e 3a    	adc    0x3a0e0300,%al
 31c:	0b 3b                	or     (%ebx),%edi
 31e:	0b 49 13             	or     0x13(%ecx),%ecx
 321:	02 18                	add    (%eax),%bl
 323:	00 00                	add    %al,(%eax)
 325:	13 34 00             	adc    (%eax,%eax,1),%esi
 328:	03 08                	add    (%eax),%ecx
 32a:	3a 0b                	cmp    (%ebx),%cl
 32c:	3b 0b                	cmp    (%ebx),%ecx
 32e:	49                   	dec    %ecx
 32f:	13 02                	adc    (%edx),%eax
 331:	17                   	pop    %ss
 332:	00 00                	add    %al,(%eax)
 334:	14 89                	adc    $0x89,%al
 336:	82                   	(bad)  
 337:	01 00                	add    %eax,(%eax)
 339:	11 01                	adc    %eax,(%ecx)
 33b:	31 13                	xor    %edx,(%ebx)
 33d:	00 00                	add    %al,(%eax)
 33f:	15 0f 00 0b 0b       	adc    $0xb0b000f,%eax
 344:	49                   	dec    %ecx
 345:	13 00                	adc    (%eax),%eax
 347:	00 16                	add    %dl,(%esi)
 349:	34 00                	xor    $0x0,%al
 34b:	03 0e                	add    (%esi),%ecx
 34d:	3a 0b                	cmp    (%ebx),%cl
 34f:	3b 0b                	cmp    (%ebx),%ecx
 351:	49                   	dec    %ecx
 352:	13 02                	adc    (%edx),%eax
 354:	17                   	pop    %ss
 355:	00 00                	add    %al,(%eax)
 357:	17                   	pop    %ss
 358:	2e 01 3f             	add    %edi,%cs:(%edi)
 35b:	19 03                	sbb    %eax,(%ebx)
 35d:	0e                   	push   %cs
 35e:	3a 0b                	cmp    (%ebx),%cl
 360:	3b 0b                	cmp    (%ebx),%ecx
 362:	27                   	daa    
 363:	19 11                	sbb    %edx,(%ecx)
 365:	01 12                	add    %edx,(%edx)
 367:	06                   	push   %es
 368:	40                   	inc    %eax
 369:	18 97 42 19 01 13    	sbb    %dl,0x13011942(%edi)
 36f:	00 00                	add    %al,(%eax)
 371:	18 05 00 03 08 3a    	sbb    %al,0x3a080300
 377:	0b 3b                	or     (%ebx),%edi
 379:	0b 49 13             	or     0x13(%ecx),%ecx
 37c:	02 18                	add    (%eax),%bl
 37e:	00 00                	add    %al,(%eax)
 380:	19 34 00             	sbb    %esi,(%eax,%eax,1)
 383:	03 0e                	add    (%esi),%ecx
 385:	3a 0b                	cmp    (%ebx),%cl
 387:	3b 0b                	cmp    (%ebx),%ecx
 389:	49                   	dec    %ecx
 38a:	13 1c 0b             	adc    (%ebx,%ecx,1),%ebx
 38d:	00 00                	add    %al,(%eax)
 38f:	1a 0b                	sbb    (%ebx),%cl
 391:	01 55 17             	add    %edx,0x17(%ebp)
 394:	01 13                	add    %edx,(%ebx)
 396:	00 00                	add    %al,(%eax)
 398:	1b 89 82 01 00 11    	sbb    0x11000182(%ecx),%ecx
 39e:	01 95 42 19 31 13    	add    %edx,0x13311942(%ebp)
 3a4:	00 00                	add    %al,(%eax)
 3a6:	1c 34                	sbb    $0x34,%al
 3a8:	00 03                	add    %al,(%ebx)
 3aa:	0e                   	push   %cs
 3ab:	3a 0b                	cmp    (%ebx),%cl
 3ad:	3b 0b                	cmp    (%ebx),%ecx
 3af:	49                   	dec    %ecx
 3b0:	13 3f                	adc    (%edi),%edi
 3b2:	19 02                	sbb    %eax,(%edx)
 3b4:	18 00                	sbb    %al,(%eax)
 3b6:	00 1d 2e 00 3f 19    	add    %bl,0x193f002e
 3bc:	3c 19                	cmp    $0x19,%al
 3be:	6e                   	outsb  %ds:(%esi),(%dx)
 3bf:	0e                   	push   %cs
 3c0:	03 0e                	add    (%esi),%ecx
 3c2:	3a 0b                	cmp    (%ebx),%cl
 3c4:	3b 0b                	cmp    (%ebx),%ecx
 3c6:	00 00                	add    %al,(%eax)
 3c8:	00 01                	add    %al,(%ecx)
 3ca:	11 00                	adc    %eax,(%eax)
 3cc:	10 06                	adc    %al,(%esi)
 3ce:	11 01                	adc    %eax,(%ecx)
 3d0:	12 01                	adc    (%ecx),%al
 3d2:	03 08                	add    (%eax),%ecx
 3d4:	1b 08                	sbb    (%eax),%ecx
 3d6:	25 08 13 05 00       	and    $0x51308,%eax
 3db:	00 00                	add    %al,(%eax)

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	7f 00                	jg     2 <PROT_MODE_CSEG-0x6>
   2:	00 00                	add    %al,(%eax)
   4:	02 00                	add    (%eax),%al
   6:	29 00                	sub    %eax,(%eax)
   8:	00 00                	add    %al,(%eax)
   a:	01 01                	add    %eax,(%ecx)
   c:	fb                   	sti    
   d:	0e                   	push   %cs
   e:	0d 00 01 01 01       	or     $0x1010100,%eax
  13:	01 00                	add    %eax,(%eax)
  15:	00 00                	add    %al,(%eax)
  17:	01 00                	add    %eax,(%eax)
  19:	00 01                	add    %al,(%ecx)
  1b:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  1e:	74 2f                	je     4f <PROT_MODE_DSEG+0x3f>
  20:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  23:	74 31                	je     56 <PROT_MODE_DSEG+0x46>
  25:	00 00                	add    %al,(%eax)
  27:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  2a:	74 31                	je     5d <PROT_MODE_DSEG+0x4d>
  2c:	2e 53                	cs push %ebx
  2e:	00 01                	add    %al,(%ecx)
  30:	00 00                	add    %al,(%eax)
  32:	00 00                	add    %al,(%eax)
  34:	05 02 00 7e 00       	add    $0x7e0002,%eax
  39:	00 03                	add    %al,(%ebx)
  3b:	26 01 21             	add    %esp,%es:(%ecx)
  3e:	28 3d 3d 2f 44 2f    	sub    %bh,0x2f442f3d
  44:	2f                   	das    
  45:	2f                   	das    
  46:	2f                   	das    
  47:	30 2f                	xor    %ch,(%edi)
  49:	2f                   	das    
  4a:	2f                   	das    
  4b:	2f                   	das    
  4c:	03 0c 2e             	add    (%esi,%ebp,1),%ecx
  4f:	3d 67 3e 67 67       	cmp    $0x67673e67,%eax
  54:	30 2f                	xor    %ch,(%edi)
  56:	67 30 83 3d 4b       	xor    %al,0x4b3d(%bp,%di)
  5b:	2f                   	das    
  5c:	30 2f                	xor    %ch,(%edi)
  5e:	3d 2f 36 3d 2f       	cmp    $0x2f3d362f,%eax
  63:	3f                   	aas    
  64:	31 03                	xor    %eax,(%ebx)
  66:	0d 20 59 3d 4b       	or     $0x4b3d5920,%eax
  6b:	3e 5f                	ds pop %edi
  6d:	3d 4b 2f 2f 2f       	cmp    $0x2f2f2f4b,%eax
  72:	2f                   	das    
  73:	31 59 59             	xor    %ebx,0x59(%ecx)
  76:	5d                   	pop    %ebp
  77:	27                   	daa    
  78:	21 2f                	and    %ebp,(%edi)
  7a:	2f                   	das    
  7b:	2f                   	das    
  7c:	30 02                	xor    %al,(%edx)
  7e:	ec                   	in     (%dx),%al
  7f:	18 00                	sbb    %al,(%eax)
  81:	01 01                	add    %eax,(%ecx)
  83:	1e                   	push   %ds
  84:	01 00                	add    %eax,(%eax)
  86:	00 02                	add    %al,(%edx)
  88:	00 3a                	add    %bh,(%edx)
  8a:	00 00                	add    %al,(%eax)
  8c:	00 01                	add    %al,(%ecx)
  8e:	01 fb                	add    %edi,%ebx
  90:	0e                   	push   %cs
  91:	0d 00 01 01 01       	or     $0x1010100,%eax
  96:	01 00                	add    %eax,(%eax)
  98:	00 00                	add    %al,(%eax)
  9a:	01 00                	add    %eax,(%eax)
  9c:	00 01                	add    %al,(%ecx)
  9e:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  a1:	74 2f                	je     d2 <PROT_MODE_DSEG+0xc2>
  a3:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  a6:	74 31                	je     d9 <PROT_MODE_DSEG+0xc9>
  a8:	00 00                	add    %al,(%eax)
  aa:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  ad:	74 31                	je     e0 <PROT_MODE_DSEG+0xd0>
  af:	6c                   	insb   (%dx),%es:(%edi)
  b0:	69 62 2e 63 00 01 00 	imul   $0x10063,0x2e(%edx),%esp
  b7:	00 62 6f             	add    %ah,0x6f(%edx)
  ba:	6f                   	outsl  %ds:(%esi),(%dx)
  bb:	74 31                	je     ee <PROT_MODE_DSEG+0xde>
  bd:	6c                   	insb   (%dx),%es:(%edi)
  be:	69 62 2e 68 00 01 00 	imul   $0x10068,0x2e(%edx),%esp
  c5:	00 00                	add    %al,(%eax)
  c7:	00 05 02 16 8b 00    	add    %al,0x8b1602
  cd:	00 03                	add    %al,(%ebx)
  cf:	09 01                	or     %eax,(%ecx)
  d1:	3c 3e                	cmp    $0x3e,%al
  d3:	3b 83 2f 67 33 4b    	cmp    0x4b33672f(%ebx),%eax
  d9:	4b                   	dec    %ebx
  da:	3b 3d a0 08 3f 03    	cmp    0x33f08a0,%edi
  e0:	09 58 13             	or     %ebx,0x13(%eax)
  e3:	65 4b                	gs dec %ebx
  e5:	02 24 13             	add    (%ebx,%edx,1),%ah
  e8:	c9                   	leave  
  e9:	86 3d 3d 1f 59 24    	xchg   %bh,0x24591f3d
  ef:	3d 00 02 04 01       	cmp    $0x1040200,%eax
  f4:	08 15 03 14 3c 23    	or     %dl,0x233c1403
  fa:	2b 2e                	sub    (%esi),%ebp
  fc:	00 02                	add    %al,(%edx)
  fe:	04 01                	add    $0x1,%al
 100:	3f                   	aas    
 101:	00 02                	add    %al,(%edx)
 103:	04 03                	add    $0x3,%al
 105:	67 3e 33 58 40       	xor    %ds:0x40(%bx,%si),%ebx
 10a:	00 02                	add    %al,(%edx)
 10c:	04 01                	add    $0x1,%al
 10e:	06                   	push   %es
 10f:	9e                   	sahf   
 110:	00 02                	add    %al,(%edx)
 112:	04 03                	add    $0x3,%al
 114:	06                   	push   %es
 115:	4c                   	dec    %esp
 116:	00 02                	add    %al,(%edx)
 118:	04 03                	add    $0x3,%al
 11a:	3d 00 02 04 03       	cmp    $0x3040200,%eax
 11f:	67 00 02             	add    %al,(%bp,%si)
 122:	04 03                	add    $0x3,%al
 124:	38 50 79             	cmp    %dl,0x79(%eax)
 127:	ac                   	lods   %ds:(%esi),%al
 128:	00 02                	add    %al,(%edx)
 12a:	04 01                	add    $0x1,%al
 12c:	08 de                	or     %bl,%dh
 12e:	00 02                	add    %al,(%edx)
 130:	04 01                	add    $0x1,%al
 132:	9f                   	lahf   
 133:	00 02                	add    %al,(%edx)
 135:	04 01                	add    $0x1,%al
 137:	2d 00 02 04 01       	sub    $0x1040200,%eax
 13c:	67 2d 4c 67 75 4b    	addr16 sub $0x4b75674c,%eax
 142:	3d 65 5d 3e 08       	cmp    $0x83e5d65,%eax
 147:	21 5d 3e             	and    %ebx,0x3e(%ebp)
 14a:	08 21                	or     %ah,(%ecx)
 14c:	03 bd 7f 58 3d c9    	add    -0x36c2a781(%ebp),%edi
 152:	91                   	xchg   %eax,%ecx
 153:	1f                   	pop    %ds
 154:	03 d1                	add    %ecx,%edx
 156:	00 58 04             	add    %bl,0x4(%eax)
 159:	02 03                	add    (%ebx),%al
 15b:	99                   	cltd   
 15c:	7f 20                	jg     17e <PROT_MODE_DSEG+0x16e>
 15e:	04 01                	add    $0x1,%al
 160:	03 e7                	add    %edi,%esp
 162:	00 58 3c             	add    %bl,0x3c(%eax)
 165:	04 02                	add    $0x2,%al
 167:	03 99 7f 3c 04 01    	add    0x1043c7f(%ecx),%ebx
 16d:	03 e1                	add    %ecx,%esp
 16f:	00 20                	add    %ah,(%eax)
 171:	04 02                	add    $0x2,%al
 173:	03 92 7f 74 03 0d    	add    0xd03747f(%edx),%edx
 179:	02 3c 01             	add    (%ecx,%eax,1),%bh
 17c:	04 01                	add    $0x1,%al
 17e:	03 e1                	add    %ecx,%esp
 180:	00 20                	add    %ah,(%eax)
 182:	04 02                	add    $0x2,%al
 184:	03 a6 7f 74 04 01    	add    0x104747f(%esi),%esp
 18a:	03 f0                	add    %eax,%esi
 18c:	00 f2                	add    %dh,%dl
 18e:	42                   	inc    %edx
 18f:	66 03 09             	add    (%ecx),%cx
 192:	3c 37                	cmp    $0x37,%al
 194:	30 64 6b 37          	xor    %ah,0x37(%ebx,%ebp,2)
 198:	41                   	inc    %ecx
 199:	41                   	inc    %ecx
 19a:	4c                   	dec    %esp
 19b:	30 1f                	xor    %bl,(%edi)
 19d:	65 5a                	gs pop %edx
 19f:	4c                   	dec    %esp
 1a0:	02 08                	add    (%eax),%cl
 1a2:	00 01                	add    %al,(%ecx)
 1a4:	01 b0 00 00 00 02    	add    %esi,0x2000000(%eax)
 1aa:	00 3b                	add    %bh,(%ebx)
 1ac:	00 00                	add    %al,(%eax)
 1ae:	00 01                	add    %al,(%ecx)
 1b0:	01 fb                	add    %edi,%ebx
 1b2:	0e                   	push   %cs
 1b3:	0d 00 01 01 01       	or     $0x1010100,%eax
 1b8:	01 00                	add    %eax,(%eax)
 1ba:	00 00                	add    %al,(%eax)
 1bc:	01 00                	add    %eax,(%eax)
 1be:	00 01                	add    %al,(%ecx)
 1c0:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 1c3:	74 2f                	je     1f4 <PROT_MODE_DSEG+0x1e4>
 1c5:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 1c8:	74 31                	je     1fb <PROT_MODE_DSEG+0x1eb>
 1ca:	00 00                	add    %al,(%eax)
 1cc:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 1cf:	74 31                	je     202 <PROT_MODE_DSEG+0x1f2>
 1d1:	6d                   	insl   (%dx),%es:(%edi)
 1d2:	61                   	popa   
 1d3:	69 6e 2e 63 00 01 00 	imul   $0x10063,0x2e(%esi),%ebp
 1da:	00 62 6f             	add    %ah,0x6f(%edx)
 1dd:	6f                   	outsl  %ds:(%esi),(%dx)
 1de:	74 31                	je     211 <PROT_MODE_DSEG+0x201>
 1e0:	6c                   	insb   (%dx),%es:(%edi)
 1e1:	69 62 2e 68 00 01 00 	imul   $0x10068,0x2e(%edx),%esp
 1e8:	00 00                	add    %al,(%eax)
 1ea:	00 05 02 69 8d 00    	add    %al,0x8d6902
 1f0:	00 03                	add    %al,(%ebx)
 1f2:	cb                   	lret   
 1f3:	00 01                	add    %al,(%ecx)
 1f5:	90                   	nop
 1f6:	40                   	inc    %eax
 1f7:	08 23                	or     %ah,(%ebx)
 1f9:	e5 f8                	in     $0xf8,%eax
 1fb:	5a                   	pop    %edx
 1fc:	72 68                	jb     266 <PROT_MODE_DSEG+0x256>
 1fe:	00 02                	add    %al,(%edx)
 200:	04 01                	add    $0x1,%al
 202:	5a                   	pop    %edx
 203:	00 02                	add    %al,(%edx)
 205:	04 02                	add    $0x2,%al
 207:	4c                   	dec    %esp
 208:	00 02                	add    %al,(%edx)
 20a:	04 02                	add    $0x2,%al
 20c:	48                   	dec    %eax
 20d:	00 02                	add    %al,(%edx)
 20f:	04 02                	add    $0x2,%al
 211:	3e 00 02             	add    %al,%ds:(%edx)
 214:	04 02                	add    $0x2,%al
 216:	aa                   	stos   %al,%es:(%edi)
 217:	5d                   	pop    %ebp
 218:	59                   	pop    %ecx
 219:	49                   	dec    %ecx
 21a:	59                   	pop    %ecx
 21b:	4e                   	dec    %esi
 21c:	58                   	pop    %eax
 21d:	41                   	inc    %ecx
 21e:	80 30 59             	xorb   $0x59,(%eax)
 221:	08 14 3d 3b 67 00 02 	or     %dl,0x200673b(,%edi,1)
 228:	04 01                	add    $0x1,%al
 22a:	55                   	push   %ebp
 22b:	00 02                	add    %al,(%edx)
 22d:	04 02                	add    $0x2,%al
 22f:	06                   	push   %es
 230:	82                   	(bad)  
 231:	06                   	push   %es
 232:	6d                   	insl   (%dx),%es:(%edi)
 233:	65 69 03 a8 7f ba 58 	imul   $0x58ba7fa8,%gs:(%ebx),%eax
 23a:	68 a0 e9 2f 00       	push   $0x2fe9a0
 23f:	02 04 02             	add    (%edx,%eax,1),%al
 242:	e3 03                	jecxz  247 <PROT_MODE_DSEG+0x237>
 244:	1d 66 75 65 03       	sbb    $0x3657566,%eax
 249:	73 58                	jae    2a3 <PROT_MODE_DSEG+0x293>
 24b:	08 3d 83 03 0c 90    	or     %bh,0x900c0383
 251:	03 74 66 02          	add    0x2(%esi,%eiz,2),%esi
 255:	05 00 01 01 46       	add    $0x46010100,%eax
 25a:	00 00                	add    %al,(%eax)
 25c:	00 02                	add    %al,(%edx)
 25e:	00 2f                	add    %ch,(%edi)
 260:	00 00                	add    %al,(%eax)
 262:	00 01                	add    %al,(%ecx)
 264:	01 fb                	add    %edi,%ebx
 266:	0e                   	push   %cs
 267:	0d 00 01 01 01       	or     $0x1010100,%eax
 26c:	01 00                	add    %eax,(%eax)
 26e:	00 00                	add    %al,(%eax)
 270:	01 00                	add    %eax,(%eax)
 272:	00 01                	add    %al,(%ecx)
 274:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 277:	74 2f                	je     2a8 <PROT_MODE_DSEG+0x298>
 279:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 27c:	74 31                	je     2af <PROT_MODE_DSEG+0x29f>
 27e:	00 00                	add    %al,(%eax)
 280:	65 78 65             	gs js  2e8 <PROT_MODE_DSEG+0x2d8>
 283:	63 5f 6b             	arpl   %bx,0x6b(%edi)
 286:	65 72 6e             	gs jb  2f7 <PROT_MODE_DSEG+0x2e7>
 289:	65 6c                	gs insb (%dx),%es:(%edi)
 28b:	2e 53                	cs push %ebx
 28d:	00 01                	add    %al,(%ecx)
 28f:	00 00                	add    %al,(%eax)
 291:	00 00                	add    %al,(%eax)
 293:	05 02 c6 8e 00       	add    $0x8ec602,%eax
 298:	00 17                	add    %dl,(%edi)
 29a:	21 59 4b             	and    %ebx,0x4b(%ecx)
 29d:	4b                   	dec    %ebx
 29e:	02 02                	add    (%edx),%al
 2a0:	00 01                	add    %al,(%ecx)
 2a2:	01                   	.byte 0x1

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	65 6e                	outsb  %gs:(%esi),(%dx)
   2:	64 5f                	fs pop %edi
   4:	76 61                	jbe    67 <PROT_MODE_DSEG+0x57>
   6:	00 77 61             	add    %dh,0x61(%edi)
   9:	69 74 64 69 73 6b 00 	imul   $0x73006b73,0x69(%esp,%eiz,2),%esi
  10:	73 
  11:	68 6f 72 74 20       	push   $0x2074726f
  16:	69 6e 74 00 73 69 7a 	imul   $0x7a697300,0x74(%esi),%ebp
  1d:	65 74 79             	gs je  99 <PROT_MODE_DSEG+0x89>
  20:	70 65                	jo     87 <PROT_MODE_DSEG+0x77>
  22:	00 72 6f             	add    %dh,0x6f(%edx)
  25:	6c                   	insb   (%dx),%es:(%edi)
  26:	6c                   	insb   (%dx),%es:(%edi)
  27:	00 70 61             	add    %dh,0x61(%eax)
  2a:	6e                   	outsb  %ds:(%esi),(%dx)
  2b:	69 63 00 47 4e 55 20 	imul   $0x20554e47,0x0(%ebx),%esp
  32:	43                   	inc    %ebx
  33:	31 31                	xor    %esi,(%ecx)
  35:	20 35 2e 34 2e 30    	and    %dh,0x302e342e
  3b:	20 32                	and    %dh,(%edx)
  3d:	30 31                	xor    %dh,(%ecx)
  3f:	36 30 36             	xor    %dh,%ss:(%esi)
  42:	30 39                	xor    %bh,(%ecx)
  44:	20 2d 6d 33 32 20    	and    %ch,0x2032336d
  4a:	2d 6d 74 75 6e       	sub    $0x6e75746d,%eax
  4f:	65 3d 67 65 6e 65    	gs cmp $0x656e6567,%eax
  55:	72 69                	jb     c0 <PROT_MODE_DSEG+0xb0>
  57:	63 20                	arpl   %sp,(%eax)
  59:	2d 6d 61 72 63       	sub    $0x6372616d,%eax
  5e:	68 3d 69 36 38       	push   $0x3836693d
  63:	36 20 2d 67 20 2d 4f 	and    %ch,%ss:0x4f2d2067
  6a:	73 20                	jae    8c <PROT_MODE_DSEG+0x7c>
  6c:	2d 4f 73 20 2d       	sub    $0x2d20734f,%eax
  71:	66 6e                	data16 outsb %ds:(%esi),(%dx)
  73:	6f                   	outsl  %ds:(%esi),(%dx)
  74:	2d 62 75 69 6c       	sub    $0x6c697562,%eax
  79:	74 69                	je     e4 <PROT_MODE_DSEG+0xd4>
  7b:	6e                   	outsb  %ds:(%esi),(%dx)
  7c:	20 2d 66 6e 6f 2d    	and    %ch,0x2d6f6e66
  82:	73 74                	jae    f8 <PROT_MODE_DSEG+0xe8>
  84:	61                   	popa   
  85:	63 6b 2d             	arpl   %bp,0x2d(%ebx)
  88:	70 72                	jo     fc <PROT_MODE_DSEG+0xec>
  8a:	6f                   	outsl  %ds:(%esi),(%dx)
  8b:	74 65                	je     f2 <PROT_MODE_DSEG+0xe2>
  8d:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
  91:	00 70 75             	add    %dh,0x75(%eax)
  94:	74 69                	je     ff <PROT_MODE_DSEG+0xef>
  96:	00 72 65             	add    %dh,0x65(%edx)
  99:	61                   	popa   
  9a:	64 73 65             	fs jae 102 <PROT_MODE_DSEG+0xf2>
  9d:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
  a1:	00 62 6f             	add    %ah,0x6f(%edx)
  a4:	6f                   	outsl  %ds:(%esi),(%dx)
  a5:	74 2f                	je     d6 <PROT_MODE_DSEG+0xc6>
  a7:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  aa:	74 31                	je     dd <PROT_MODE_DSEG+0xcd>
  ac:	2f                   	das    
  ad:	62 6f 6f             	bound  %ebp,0x6f(%edi)
  b0:	74 31                	je     e3 <PROT_MODE_DSEG+0xd3>
  b2:	6c                   	insb   (%dx),%es:(%edi)
  b3:	69 62 2e 63 00 75 69 	imul   $0x69750063,0x2e(%edx),%esp
  ba:	6e                   	outsb  %ds:(%esi),(%dx)
  bb:	74 38                	je     f5 <PROT_MODE_DSEG+0xe5>
  bd:	5f                   	pop    %edi
  be:	74 00                	je     c0 <PROT_MODE_DSEG+0xb0>
  c0:	6f                   	outsl  %ds:(%esi),(%dx)
  c1:	75 74                	jne    137 <PROT_MODE_DSEG+0x127>
  c3:	62 00                	bound  %eax,(%eax)
  c5:	69 6e 73 6c 00 6c 6f 	imul   $0x6f6c006c,0x73(%esi),%ebp
  cc:	6e                   	outsb  %ds:(%esi),(%dx)
  cd:	67 20 6c 6f          	and    %ch,0x6f(%si)
  d1:	6e                   	outsb  %ds:(%esi),(%dx)
  d2:	67 20 69 6e          	and    %ch,0x6e(%bx,%di)
  d6:	74 00                	je     d8 <PROT_MODE_DSEG+0xc8>
  d8:	73 74                	jae    14e <PROT_MODE_DSEG+0x13e>
  da:	72 69                	jb     145 <PROT_MODE_DSEG+0x135>
  dc:	6e                   	outsb  %ds:(%esi),(%dx)
  dd:	67 00 72 65          	add    %dh,0x65(%bp,%si)
  e1:	61                   	popa   
  e2:	64 73 65             	fs jae 14a <PROT_MODE_DSEG+0x13a>
  e5:	63 74 69 6f          	arpl   %si,0x6f(%ecx,%ebp,2)
  e9:	6e                   	outsb  %ds:(%esi),(%dx)
  ea:	00 75 6e             	add    %dh,0x6e(%ebp)
  ed:	73 69                	jae    158 <PROT_MODE_DSEG+0x148>
  ef:	67 6e                	outsb  %ds:(%si),(%dx)
  f1:	65 64 20 63 68       	gs and %ah,%fs:0x68(%ebx)
  f6:	61                   	popa   
  f7:	72 00                	jb     f9 <PROT_MODE_DSEG+0xe9>
  f9:	69 74 6f 68 00 70 75 	imul   $0x74757000,0x68(%edi,%ebp,2),%esi
 100:	74 
 101:	63 00                	arpl   %ax,(%eax)
 103:	6c                   	insb   (%dx),%es:(%edi)
 104:	6f                   	outsl  %ds:(%esi),(%dx)
 105:	6e                   	outsb  %ds:(%esi),(%dx)
 106:	67 20 6c 6f          	and    %ch,0x6f(%si)
 10a:	6e                   	outsb  %ds:(%esi),(%dx)
 10b:	67 20 75 6e          	and    %dh,0x6e(%di)
 10f:	73 69                	jae    17a <PROT_MODE_DSEG+0x16a>
 111:	67 6e                	outsb  %ds:(%si),(%dx)
 113:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 118:	74 00                	je     11a <PROT_MODE_DSEG+0x10a>
 11a:	69 74 6f 61 00 75 69 	imul   $0x6e697500,0x61(%edi,%ebp,2),%esi
 121:	6e 
 122:	74 33                	je     157 <PROT_MODE_DSEG+0x147>
 124:	32 5f 74             	xor    0x74(%edi),%bl
 127:	00 63 6f             	add    %ah,0x6f(%ebx)
 12a:	6c                   	insb   (%dx),%es:(%edi)
 12b:	6f                   	outsl  %ds:(%esi),(%dx)
 12c:	72 00                	jb     12e <PROT_MODE_DSEG+0x11e>
 12e:	69 74 6f 78 00 70 75 	imul   $0x74757000,0x78(%edi,%ebp,2),%esi
 135:	74 
 136:	73 00                	jae    138 <PROT_MODE_DSEG+0x128>
 138:	73 69                	jae    1a3 <PROT_MODE_DSEG+0x193>
 13a:	67 6e                	outsb  %ds:(%si),(%dx)
 13c:	00 73 68             	add    %dh,0x68(%ebx)
 13f:	6f                   	outsl  %ds:(%esi),(%dx)
 140:	72 74                	jb     1b6 <PROT_MODE_DSEG+0x1a6>
 142:	20 75 6e             	and    %dh,0x6e(%ebp)
 145:	73 69                	jae    1b0 <PROT_MODE_DSEG+0x1a0>
 147:	67 6e                	outsb  %ds:(%si),(%dx)
 149:	65 64 20 69 6e       	gs and %ch,%fs:0x6e(%ecx)
 14e:	74 00                	je     150 <PROT_MODE_DSEG+0x140>
 150:	2f                   	das    
 151:	68 6f 6d 65 2f       	push   $0x2f656d6f
 156:	73 75                	jae    1cd <PROT_MODE_DSEG+0x1bd>
 158:	64 61                	fs popa 
 15a:	72 73                	jb     1cf <PROT_MODE_DSEG+0x1bf>
 15c:	68 61 6e 2f 43       	push   $0x432f6e61
 161:	4c                   	dec    %esp
 162:	69 6f 6e 50 72 6f 6a 	imul   $0x6a6f7250,0x6e(%edi),%ebp
 169:	65 63 74 73 2f       	arpl   %si,%gs:0x2f(%ebx,%esi,2)
 16e:	6f                   	outsl  %ds:(%esi),(%dx)
 16f:	73 2d                	jae    19e <PROT_MODE_DSEG+0x18e>
 171:	73 32                	jae    1a5 <PROT_MODE_DSEG+0x195>
 173:	30 2d 42 75 6d 62    	xor    %ch,0x626d7542
 179:	6c                   	insb   (%dx),%es:(%edi)
 17a:	65 46                	gs inc %esi
 17c:	6c                   	insb   (%dx),%es:(%edi)
 17d:	61                   	popa   
 17e:	73 68                	jae    1e8 <PROT_MODE_DSEG+0x1d8>
 180:	00 73 74             	add    %dh,0x74(%ebx)
 183:	72 6c                	jb     1f1 <PROT_MODE_DSEG+0x1e1>
 185:	65 6e                	outsb  %gs:(%esi),(%dx)
 187:	00 64 61 74          	add    %ah,0x74(%ecx,%eiz,2)
 18b:	61                   	popa   
 18c:	00 70 6f             	add    %dh,0x6f(%eax)
 18f:	72 74                	jb     205 <PROT_MODE_DSEG+0x1f5>
 191:	00 70 75             	add    %dh,0x75(%eax)
 194:	74 6c                	je     202 <PROT_MODE_DSEG+0x1f2>
 196:	69 6e 65 00 72 65 76 	imul   $0x76657200,0x65(%esi),%ebp
 19d:	65 72 73             	gs jb  213 <PROT_MODE_DSEG+0x203>
 1a0:	65 00 70 75          	add    %dh,%gs:0x75(%eax)
 1a4:	74 69                	je     20f <PROT_MODE_DSEG+0x1ff>
 1a6:	5f                   	pop    %edi
 1a7:	73 74                	jae    21d <PROT_MODE_DSEG+0x20d>
 1a9:	72 00                	jb     1ab <PROT_MODE_DSEG+0x19b>
 1ab:	62 6c 61 6e          	bound  %ebp,0x6e(%ecx,%eiz,2)
 1af:	6b 00 72             	imul   $0x72,(%eax),%eax
 1b2:	6f                   	outsl  %ds:(%esi),(%dx)
 1b3:	6f                   	outsl  %ds:(%esi),(%dx)
 1b4:	74 00                	je     1b6 <PROT_MODE_DSEG+0x1a6>
 1b6:	76 69                	jbe    221 <PROT_MODE_DSEG+0x211>
 1b8:	64 65 6f             	fs outsl %gs:(%esi),(%dx)
 1bb:	00 64 69 73          	add    %ah,0x73(%ecx,%ebp,2)
 1bf:	6b 5f 73 69          	imul   $0x69,0x73(%edi),%ebx
 1c3:	67 00 65 6c          	add    %ah,0x6c(%di)
 1c7:	66 68 64 66          	pushw  $0x6664
 1cb:	00 65 5f             	add    %ah,0x5f(%ebp)
 1ce:	73 68                	jae    238 <PROT_MODE_DSEG+0x228>
 1d0:	73 74                	jae    246 <PROT_MODE_DSEG+0x236>
 1d2:	72 6e                	jb     242 <PROT_MODE_DSEG+0x232>
 1d4:	64 78 00             	fs js  1d7 <PROT_MODE_DSEG+0x1c7>
 1d7:	6d                   	insl   (%dx),%es:(%edi)
 1d8:	6d                   	insl   (%dx),%es:(%edi)
 1d9:	61                   	popa   
 1da:	70 5f                	jo     23b <PROT_MODE_DSEG+0x22b>
 1dc:	61                   	popa   
 1dd:	64 64 72 00          	fs fs jb 1e1 <PROT_MODE_DSEG+0x1d1>
 1e1:	65 6c                	gs insb (%dx),%es:(%edi)
 1e3:	66 68 64 72          	pushw  $0x7264
 1e7:	00 76 62             	add    %dh,0x62(%esi)
 1ea:	65 5f                	gs pop %edi
 1ec:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 1f3:	63 65 5f             	arpl   %sp,0x5f(%ebp)
 1f6:	6f                   	outsl  %ds:(%esi),(%dx)
 1f7:	66 66 00 65 5f       	data16 data16 add %ah,0x5f(%ebp)
 1fc:	65 6e                	outsb  %gs:(%esi),(%dx)
 1fe:	74 72                	je     272 <PROT_MODE_DSEG+0x262>
 200:	79 00                	jns    202 <PROT_MODE_DSEG+0x1f2>
 202:	75 69                	jne    26d <PROT_MODE_DSEG+0x25d>
 204:	6e                   	outsb  %ds:(%esi),(%dx)
 205:	74 36                	je     23d <PROT_MODE_DSEG+0x22d>
 207:	34 5f                	xor    $0x5f,%al
 209:	74 00                	je     20b <PROT_MODE_DSEG+0x1fb>
 20b:	6c                   	insb   (%dx),%es:(%edi)
 20c:	6f                   	outsl  %ds:(%esi),(%dx)
 20d:	61                   	popa   
 20e:	64 5f                	fs pop %edi
 210:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
 214:	65 6c                	gs insb (%dx),%es:(%edi)
 216:	00 70 5f             	add    %dh,0x5f(%eax)
 219:	6d                   	insl   (%dx),%es:(%edi)
 21a:	65 6d                	gs insl (%dx),%es:(%edi)
 21c:	73 7a                	jae    298 <PROT_MODE_DSEG+0x288>
 21e:	00 70 5f             	add    %dh,0x5f(%eax)
 221:	6f                   	outsl  %ds:(%esi),(%dx)
 222:	66 66 73 65          	data16 data16 jae 28b <PROT_MODE_DSEG+0x27b>
 226:	74 00                	je     228 <PROT_MODE_DSEG+0x218>
 228:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 22b:	74 6c                	je     299 <PROT_MODE_DSEG+0x289>
 22d:	6f                   	outsl  %ds:(%esi),(%dx)
 22e:	61                   	popa   
 22f:	64 65 72 00          	fs gs jb 233 <PROT_MODE_DSEG+0x223>
 233:	65 5f                	gs pop %edi
 235:	66 6c                	data16 insb (%dx),%es:(%edi)
 237:	61                   	popa   
 238:	67 73 00             	addr16 jae 23b <PROT_MODE_DSEG+0x22b>
 23b:	63 6d 64             	arpl   %bp,0x64(%ebp)
 23e:	6c                   	insb   (%dx),%es:(%edi)
 23f:	69 6e 65 00 65 5f 6d 	imul   $0x6d5f6500,0x65(%esi),%ebp
 246:	61                   	popa   
 247:	63 68 69             	arpl   %bp,0x69(%eax)
 24a:	6e                   	outsb  %ds:(%esi),(%dx)
 24b:	65 00 65 78          	add    %ah,%gs:0x78(%ebp)
 24f:	65 63 5f 6b          	arpl   %bx,%gs:0x6b(%edi)
 253:	65 72 6e             	gs jb  2c4 <PROT_MODE_DSEG+0x2b4>
 256:	65 6c                	gs insb (%dx),%es:(%edi)
 258:	00 6d 6f             	add    %ch,0x6f(%ebp)
 25b:	64 73 5f             	fs jae 2bd <PROT_MODE_DSEG+0x2ad>
 25e:	61                   	popa   
 25f:	64 64 72 00          	fs fs jb 263 <PROT_MODE_DSEG+0x253>
 263:	69 73 62 6f 6f 74 61 	imul   $0x61746f6f,0x62(%ebx),%esi
 26a:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 26e:	73 74                	jae    2e4 <PROT_MODE_DSEG+0x2d4>
 270:	72 73                	jb     2e5 <PROT_MODE_DSEG+0x2d5>
 272:	69 7a 65 00 70 61 72 	imul   $0x72617000,0x65(%edx),%edi
 279:	74 33                	je     2ae <PROT_MODE_DSEG+0x29e>
 27b:	00 70 5f             	add    %dh,0x5f(%eax)
 27e:	74 79                	je     2f9 <PROT_MODE_DSEG+0x2e9>
 280:	70 65                	jo     2e7 <PROT_MODE_DSEG+0x2d7>
 282:	00 70 72             	add    %dh,0x72(%eax)
 285:	6f                   	outsl  %ds:(%esi),(%dx)
 286:	67 68 64 72 00 65    	addr16 push $0x65007264
 28c:	5f                   	pop    %edi
 28d:	73 68                	jae    2f7 <PROT_MODE_DSEG+0x2e7>
 28f:	65 6e                	outsb  %gs:(%esi),(%dx)
 291:	74 73                	je     306 <PROT_MODE_DSEG+0x2f6>
 293:	69 7a 65 00 73 68 6e 	imul   $0x6e687300,0x65(%edx),%edi
 29a:	64 78 00             	fs js  29d <PROT_MODE_DSEG+0x28d>
 29d:	6d                   	insl   (%dx),%es:(%edi)
 29e:	62 72 5f             	bound  %esi,0x5f(%edx)
 2a1:	74 00                	je     2a3 <PROT_MODE_DSEG+0x293>
 2a3:	65 5f                	gs pop %edi
 2a5:	74 79                	je     320 <PROT_MODE_DSEG+0x310>
 2a7:	70 65                	jo     30e <PROT_MODE_DSEG+0x2fe>
 2a9:	00 64 72 69          	add    %ah,0x69(%edx,%esi,2)
 2ad:	76 65                	jbe    314 <PROT_MODE_DSEG+0x304>
 2af:	73 5f                	jae    310 <PROT_MODE_DSEG+0x300>
 2b1:	61                   	popa   
 2b2:	64 64 72 00          	fs fs jb 2b6 <PROT_MODE_DSEG+0x2a6>
 2b6:	65 5f                	gs pop %edi
 2b8:	65 68 73 69 7a 65    	gs push $0x657a6973
 2be:	00 70 61             	add    %dh,0x61(%eax)
 2c1:	72 74                	jb     337 <PROT_MODE_DSEG+0x327>
 2c3:	69 74 69 6f 6e 00 62 	imul   $0x6962006e,0x6f(%ecx,%ebp,2),%esi
 2ca:	69 
 2cb:	6f                   	outsl  %ds:(%esi),(%dx)
 2cc:	73 5f                	jae    32d <PROT_MODE_DSEG+0x31d>
 2ce:	73 6d                	jae    33d <PROT_MODE_DSEG+0x32d>
 2d0:	61                   	popa   
 2d1:	70 5f                	jo     332 <PROT_MODE_DSEG+0x322>
 2d3:	74 00                	je     2d5 <PROT_MODE_DSEG+0x2c5>
 2d5:	6d                   	insl   (%dx),%es:(%edi)
 2d6:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2d9:	74 5f                	je     33a <PROT_MODE_DSEG+0x32a>
 2db:	69 6e 66 6f 5f 74 00 	imul   $0x745f6f,0x66(%esi),%ebp
 2e2:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2e5:	74 5f                	je     346 <PROT_MODE_DSEG+0x336>
 2e7:	64 65 76 69          	fs gs jbe 354 <PROT_MODE_DSEG+0x344>
 2eb:	63 65 00             	arpl   %sp,0x0(%ebp)
 2ee:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 2f1:	74 31                	je     324 <PROT_MODE_DSEG+0x314>
 2f3:	6d                   	insl   (%dx),%es:(%edi)
 2f4:	61                   	popa   
 2f5:	69 6e 00 65 5f 70 68 	imul   $0x68705f65,0x0(%esi),%ebp
 2fc:	65 6e                	outsb  %gs:(%esi),(%dx)
 2fe:	74 73                	je     373 <PROT_MODE_DSEG+0x363>
 300:	69 7a 65 00 70 61 72 	imul   $0x72617000,0x65(%edx),%edi
 307:	73 65                	jae    36e <PROT_MODE_DSEG+0x35e>
 309:	64 5f                	fs pop %edi
 30b:	73 6d                	jae    37a <PROT_MODE_DSEG+0x36a>
 30d:	61                   	popa   
 30e:	70 00                	jo     310 <PROT_MODE_DSEG+0x300>
 310:	65 5f                	gs pop %edi
 312:	76 65                	jbe    379 <PROT_MODE_DSEG+0x369>
 314:	72 73                	jb     389 <PROT_MODE_DSEG+0x379>
 316:	69 6f 6e 00 70 61 72 	imul   $0x72617000,0x6e(%edi),%ebp
 31d:	74 31                	je     350 <PROT_MODE_DSEG+0x340>
 31f:	00 70 61             	add    %dh,0x61(%eax)
 322:	72 74                	jb     398 <PROT_MODE_DSEG+0x388>
 324:	32 00                	xor    (%eax),%al
 326:	64 72 69             	fs jb  392 <PROT_MODE_DSEG+0x382>
 329:	76 65                	jbe    390 <PROT_MODE_DSEG+0x380>
 32b:	72 00                	jb     32d <PROT_MODE_DSEG+0x31d>
 32d:	6c                   	insb   (%dx),%es:(%edi)
 32e:	6f                   	outsl  %ds:(%esi),(%dx)
 32f:	61                   	popa   
 330:	64 65 64 5f          	fs gs fs pop %edi
 334:	6b 65 72 6e          	imul   $0x6e,0x72(%ebp),%esp
 338:	65 6c                	gs insb (%dx),%es:(%edi)
 33a:	00 66 69             	add    %ah,0x69(%esi)
 33d:	72 73                	jb     3b2 <PROT_MODE_DSEG+0x3a2>
 33f:	74 5f                	je     3a0 <PROT_MODE_DSEG+0x390>
 341:	63 68 73             	arpl   %bp,0x73(%eax)
 344:	00 62 69             	add    %ah,0x69(%edx)
 347:	6f                   	outsl  %ds:(%esi),(%dx)
 348:	73 5f                	jae    3a9 <PROT_MODE_DSEG+0x399>
 34a:	73 6d                	jae    3b9 <PROT_MODE_DSEG+0x3a9>
 34c:	61                   	popa   
 34d:	70 00                	jo     34f <PROT_MODE_DSEG+0x33f>
 34f:	6d                   	insl   (%dx),%es:(%edi)
 350:	65 6d                	gs insl (%dx),%es:(%edi)
 352:	5f                   	pop    %edi
 353:	6c                   	insb   (%dx),%es:(%edi)
 354:	6f                   	outsl  %ds:(%esi),(%dx)
 355:	77 65                	ja     3bc <PROT_MODE_DSEG+0x3ac>
 357:	72 00                	jb     359 <PROT_MODE_DSEG+0x349>
 359:	73 79                	jae    3d4 <PROT_MODE_DSEG+0x3c4>
 35b:	6d                   	insl   (%dx),%es:(%edi)
 35c:	73 00                	jae    35e <PROT_MODE_DSEG+0x34e>
 35e:	75 69                	jne    3c9 <PROT_MODE_DSEG+0x3b9>
 360:	6e                   	outsb  %ds:(%esi),(%dx)
 361:	74 31                	je     394 <PROT_MODE_DSEG+0x384>
 363:	36 5f                	ss pop %edi
 365:	74 00                	je     367 <PROT_MODE_DSEG+0x357>
 367:	6d                   	insl   (%dx),%es:(%edi)
 368:	6d                   	insl   (%dx),%es:(%edi)
 369:	61                   	popa   
 36a:	70 5f                	jo     3cb <PROT_MODE_DSEG+0x3bb>
 36c:	6c                   	insb   (%dx),%es:(%edi)
 36d:	65 6e                	outsb  %gs:(%esi),(%dx)
 36f:	67 74 68             	addr16 je 3da <PROT_MODE_DSEG+0x3ca>
 372:	00 6d 62             	add    %ch,0x62(%ebp)
 375:	6f                   	outsl  %ds:(%esi),(%dx)
 376:	6f                   	outsl  %ds:(%esi),(%dx)
 377:	74 5f                	je     3d8 <PROT_MODE_DSEG+0x3c8>
 379:	69 6e 66 6f 00 70 5f 	imul   $0x5f70006f,0x66(%esi),%ebp
 380:	76 61                	jbe    3e3 <PROT_MODE_DSEG+0x3d3>
 382:	00 76 62             	add    %dh,0x62(%esi)
 385:	65 5f                	gs pop %edi
 387:	63 6f 6e             	arpl   %bp,0x6e(%edi)
 38a:	74 72                	je     3fe <PROT_MODE_DSEG+0x3ee>
 38c:	6f                   	outsl  %ds:(%esi),(%dx)
 38d:	6c                   	insb   (%dx),%es:(%edi)
 38e:	5f                   	pop    %edi
 38f:	69 6e 66 6f 00 70 5f 	imul   $0x5f70006f,0x66(%esi),%ebp
 396:	66 6c                	data16 insb (%dx),%es:(%edi)
 398:	61                   	popa   
 399:	67 73 00             	addr16 jae 39c <PROT_MODE_DSEG+0x38c>
 39c:	70 61                	jo     3ff <PROT_MODE_DSEG+0x3ef>
 39e:	72 73                	jb     413 <PROT_MODE_DSEG+0x403>
 3a0:	65 5f                	gs pop %edi
 3a2:	65 38 32             	cmp    %dh,%gs:(%edx)
 3a5:	30 00                	xor    %al,(%eax)
 3a7:	65 5f                	gs pop %edi
 3a9:	65 6c                	gs insb (%dx),%es:(%edi)
 3ab:	66 00 61 6f          	data16 add %ah,0x6f(%ecx)
 3af:	75 74                	jne    425 <PROT_MODE_DSEG+0x415>
 3b1:	00 64 6b 65          	add    %ah,0x65(%ebx,%ebp,2)
 3b5:	72 6e                	jb     425 <PROT_MODE_DSEG+0x415>
 3b7:	65 6c                	gs insb (%dx),%es:(%edi)
 3b9:	00 65 5f             	add    %ah,0x5f(%ebp)
 3bc:	70 68                	jo     426 <PROT_MODE_DSEG+0x416>
 3be:	6f                   	outsl  %ds:(%esi),(%dx)
 3bf:	66 66 00 63 6f       	data16 data16 add %ah,0x6f(%ebx)
 3c4:	6e                   	outsb  %ds:(%esi),(%dx)
 3c5:	66 69 67 5f 74 61    	imul   $0x6174,0x5f(%edi),%sp
 3cb:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 3cf:	65 5f                	gs pop %edi
 3d1:	6d                   	insl   (%dx),%es:(%edi)
 3d2:	61                   	popa   
 3d3:	67 69 63 00 6c 61 73 	imul   $0x7473616c,0x0(%bp,%di),%esp
 3da:	74 
 3db:	5f                   	pop    %edi
 3dc:	63 68 73             	arpl   %bp,0x73(%eax)
 3df:	00 62 61             	add    %ah,0x61(%edx)
 3e2:	73 65                	jae    449 <PROT_MODE_DSEG+0x439>
 3e4:	5f                   	pop    %edi
 3e5:	61                   	popa   
 3e6:	64 64 72 00          	fs fs jb 3ea <PROT_MODE_DSEG+0x3da>
 3ea:	76 62                	jbe    44e <PROT_MODE_DSEG+0x43e>
 3ec:	65 5f                	gs pop %edi
 3ee:	6d                   	insl   (%dx),%es:(%edi)
 3ef:	6f                   	outsl  %ds:(%esi),(%dx)
 3f0:	64 65 00 65 5f       	fs add %ah,%gs:0x5f(%ebp)
 3f5:	73 68                	jae    45f <PROT_MODE_DSEG+0x44f>
 3f7:	6f                   	outsl  %ds:(%esi),(%dx)
 3f8:	66 66 00 6d 65       	data16 data16 add %ch,0x65(%ebp)
 3fd:	6d                   	insl   (%dx),%es:(%edi)
 3fe:	5f                   	pop    %edi
 3ff:	75 70                	jne    471 <PROT_MODE_DSEG+0x461>
 401:	70 65                	jo     468 <PROT_MODE_DSEG+0x458>
 403:	72 00                	jb     405 <PROT_MODE_DSEG+0x3f5>
 405:	76 62                	jbe    469 <PROT_MODE_DSEG+0x459>
 407:	65 5f                	gs pop %edi
 409:	6d                   	insl   (%dx),%es:(%edi)
 40a:	6f                   	outsl  %ds:(%esi),(%dx)
 40b:	64 65 5f             	fs gs pop %edi
 40e:	69 6e 66 6f 00 74 61 	imul   $0x6174006f,0x66(%esi),%ebp
 415:	62 73 69             	bound  %esi,0x69(%ebx)
 418:	7a 65                	jp     47f <PROT_MODE_DSEG+0x46f>
 41a:	00 66 69             	add    %ah,0x69(%esi)
 41d:	72 73                	jb     492 <PROT_MODE_DSEG+0x482>
 41f:	74 5f                	je     480 <PROT_MODE_DSEG+0x470>
 421:	6c                   	insb   (%dx),%es:(%edi)
 422:	62 61 00             	bound  %esp,0x0(%ecx)
 425:	64 72 69             	fs jb  491 <PROT_MODE_DSEG+0x481>
 428:	76 65                	jbe    48f <PROT_MODE_DSEG+0x47f>
 42a:	73 5f                	jae    48b <PROT_MODE_DSEG+0x47b>
 42c:	6c                   	insb   (%dx),%es:(%edi)
 42d:	65 6e                	outsb  %gs:(%esi),(%dx)
 42f:	67 74 68             	addr16 je 49a <PROT_MODE_DSEG+0x48a>
 432:	00 70 5f             	add    %dh,0x5f(%eax)
 435:	66 69 6c 65 73 7a 00 	imul   $0x7a,0x73(%ebp,%eiz,2),%bp
 43c:	65 5f                	gs pop %edi
 43e:	70 68                	jo     4a8 <PROT_MODE_DSEG+0x498>
 440:	6e                   	outsb  %ds:(%esi),(%dx)
 441:	75 6d                	jne    4b0 <PROT_MODE_DSEG+0x4a0>
 443:	00 73 69             	add    %dh,0x69(%ebx)
 446:	67 6e                	outsb  %ds:(%si),(%dx)
 448:	61                   	popa   
 449:	74 75                	je     4c0 <PROT_MODE_DSEG+0x4b0>
 44b:	72 65                	jb     4b2 <PROT_MODE_DSEG+0x4a2>
 44d:	00 65 5f             	add    %ah,0x5f(%ebp)
 450:	73 68                	jae    4ba <PROT_MODE_DSEG+0x4aa>
 452:	6e                   	outsb  %ds:(%esi),(%dx)
 453:	75 6d                	jne    4c2 <PROT_MODE_DSEG+0x4b2>
 455:	00 76 62             	add    %dh,0x62(%esi)
 458:	65 5f                	gs pop %edi
 45a:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 461:	63 65 5f             	arpl   %sp,0x5f(%ebp)
 464:	6c                   	insb   (%dx),%es:(%edi)
 465:	65 6e                	outsb  %gs:(%esi),(%dx)
 467:	00 62 6f             	add    %ah,0x6f(%edx)
 46a:	6f                   	outsl  %ds:(%esi),(%dx)
 46b:	74 2f                	je     49c <PROT_MODE_DSEG+0x48c>
 46d:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 470:	74 31                	je     4a3 <PROT_MODE_DSEG+0x493>
 472:	2f                   	das    
 473:	62 6f 6f             	bound  %ebp,0x6f(%edi)
 476:	74 31                	je     4a9 <PROT_MODE_DSEG+0x499>
 478:	6d                   	insl   (%dx),%es:(%edi)
 479:	61                   	popa   
 47a:	69 6e 2e 63 00 6d 6f 	imul   $0x6f6d0063,0x2e(%esi),%ebp
 481:	64 73 5f             	fs jae 4e3 <PROT_MODE_DSEG+0x4d3>
 484:	63 6f 75             	arpl   %bp,0x75(%edi)
 487:	6e                   	outsb  %ds:(%esi),(%dx)
 488:	74 00                	je     48a <PROT_MODE_DSEG+0x47a>
 48a:	5f                   	pop    %edi
 48b:	72 65                	jb     4f2 <PROT_MODE_DSEG+0x4e2>
 48d:	73 65                	jae    4f4 <PROT_MODE_DSEG+0x4e4>
 48f:	72 76                	jb     507 <PROT_MODE_DSEG+0x4f7>
 491:	65 64 00 62 6f       	gs add %ah,%fs:0x6f(%edx)
 496:	6f                   	outsl  %ds:(%esi),(%dx)
 497:	74 5f                	je     4f8 <PROT_MODE_DSEG+0x4e8>
 499:	6c                   	insb   (%dx),%es:(%edi)
 49a:	6f                   	outsl  %ds:(%esi),(%dx)
 49b:	61                   	popa   
 49c:	64 65 72 5f          	fs gs jb 4ff <PROT_MODE_DSEG+0x4ef>
 4a0:	6e                   	outsb  %ds:(%esi),(%dx)
 4a1:	61                   	popa   
 4a2:	6d                   	insl   (%dx),%es:(%edi)
 4a3:	65 00 76 62          	add    %dh,%gs:0x62(%esi)
 4a7:	65 5f                	gs pop %edi
 4a9:	69 6e 74 65 72 66 61 	imul   $0x61667265,0x74(%esi),%ebp
 4b0:	63 65 5f             	arpl   %sp,0x5f(%ebp)
 4b3:	73 65                	jae    51a <PROT_MODE_DSEG+0x50a>
 4b5:	67 00 6d 6d          	add    %ch,0x6d(%di)
 4b9:	61                   	popa   
 4ba:	70 5f                	jo     51b <PROT_MODE_DSEG+0x50b>
 4bc:	6c                   	insb   (%dx),%es:(%edi)
 4bd:	65 6e                	outsb  %gs:(%esi),(%dx)
 4bf:	00 70 5f             	add    %dh,0x5f(%eax)
 4c2:	61                   	popa   
 4c3:	6c                   	insb   (%dx),%es:(%edi)
 4c4:	69 67 6e 00 61 70 6d 	imul   $0x6d706100,0x6e(%edi),%esp
 4cb:	5f                   	pop    %edi
 4cc:	74 61                	je     52f <PROT_MODE_DSEG+0x51f>
 4ce:	62 6c 65 00          	bound  %ebp,0x0(%ebp,%eiz,2)
 4d2:	70 5f                	jo     533 <PROT_MODE_DSEG+0x523>
 4d4:	70 61                	jo     537 <PROT_MODE_DSEG+0x527>
 4d6:	00 73 65             	add    %dh,0x65(%ebx)
 4d9:	63 74 6f 72          	arpl   %si,0x72(%edi,%ebp,2)
 4dd:	73 5f                	jae    53e <PROT_MODE_DSEG+0x52e>
 4df:	63 6f 75             	arpl   %bp,0x75(%edi)
 4e2:	6e                   	outsb  %ds:(%esi),(%dx)
 4e3:	74 00                	je     4e5 <PROT_MODE_DSEG+0x4d5>

Disassembly of section .debug_loc:

00000000 <.debug_loc>:
   0:	1b 00                	sbb    (%eax),%eax
   2:	00 00                	add    %al,(%eax)
   4:	2b 00                	sub    (%eax),%eax
   6:	00 00                	add    %al,(%eax)
   8:	02 00                	add    (%eax),%al
   a:	91                   	xchg   %eax,%ecx
   b:	0c 2b                	or     $0x2b,%al
   d:	00 00                	add    %al,(%eax)
   f:	00 33                	add    %dh,(%ebx)
  11:	00 00                	add    %al,(%eax)
  13:	00 12                	add    %dl,(%edx)
  15:	00 91 0c 06 91 00    	add    %dl,0x91060c(%ecx)
  1b:	06                   	push   %es
  1c:	08 50 1e             	or     %dl,0x1e(%eax)
  1f:	1c 70                	sbb    $0x70,%al
  21:	00 22                	add    %ah,(%edx)
  23:	91                   	xchg   %eax,%ecx
  24:	04 06                	add    $0x6,%al
  26:	1c 9f                	sbb    $0x9f,%al
  28:	33 00                	xor    (%eax),%eax
  2a:	00 00                	add    %al,(%eax)
  2c:	3f                   	aas    
  2d:	00 00                	add    %al,(%eax)
  2f:	00 14 00             	add    %dl,(%eax,%eax,1)
  32:	91                   	xchg   %eax,%ecx
  33:	0c 06                	or     $0x6,%al
  35:	91                   	xchg   %eax,%ecx
  36:	00 06                	add    %al,(%esi)
  38:	08 50 1e             	or     %dl,0x1e(%eax)
  3b:	1c 91                	sbb    $0x91,%al
  3d:	04 06                	add    $0x6,%al
  3f:	1c 70                	sbb    $0x70,%al
  41:	00 22                	add    %ah,(%edx)
  43:	23 01                	and    (%ecx),%eax
  45:	9f                   	lahf   
  46:	3f                   	aas    
  47:	00 00                	add    %al,(%eax)
  49:	00 47 00             	add    %al,0x0(%edi)
  4c:	00 00                	add    %al,(%eax)
  4e:	12 00                	adc    (%eax),%al
  50:	91                   	xchg   %eax,%ecx
  51:	0c 06                	or     $0x6,%al
  53:	91                   	xchg   %eax,%ecx
  54:	00 06                	add    %al,(%esi)
  56:	08 50 1e             	or     %dl,0x1e(%eax)
  59:	1c 91                	sbb    $0x91,%al
  5b:	04 06                	add    $0x6,%al
  5d:	1c 73                	sbb    $0x73,%al
  5f:	00 22                	add    %ah,(%edx)
  61:	9f                   	lahf   
  62:	47                   	inc    %edi
  63:	00 00                	add    %al,(%eax)
  65:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
  69:	00 12                	add    %dl,(%edx)
  6b:	00 91 0c 06 91 00    	add    %dl,0x91060c(%ecx)
  71:	06                   	push   %es
  72:	08 50 1e             	or     %dl,0x1e(%eax)
  75:	1c 70                	sbb    $0x70,%al
  77:	00 22                	add    %ah,(%edx)
  79:	91                   	xchg   %eax,%ecx
  7a:	04 06                	add    $0x6,%al
  7c:	1c 9f                	sbb    $0x9f,%al
  7e:	00 00                	add    %al,(%eax)
  80:	00 00                	add    %al,(%eax)
  82:	00 00                	add    %al,(%eax)
  84:	00 00                	add    %al,(%eax)
  86:	23 00                	and    (%eax),%eax
  88:	00 00                	add    %al,(%eax)
  8a:	29 00                	sub    %eax,(%eax)
  8c:	00 00                	add    %al,(%eax)
  8e:	07                   	pop    %es
  8f:	00 70 00             	add    %dh,0x0(%eax)
  92:	91                   	xchg   %eax,%ecx
  93:	04 06                	add    $0x6,%al
  95:	22 9f 29 00 00 00    	and    0x29(%edi),%bl
  9b:	37                   	aaa    
  9c:	00 00                	add    %al,(%eax)
  9e:	00 01                	add    %al,(%ecx)
  a0:	00 50 37             	add    %dl,0x37(%eax)
  a3:	00 00                	add    %al,(%eax)
  a5:	00 47 00             	add    %al,0x0(%edi)
  a8:	00 00                	add    %al,(%eax)
  aa:	01 00                	add    %eax,(%eax)
  ac:	53                   	push   %ebx
  ad:	47                   	inc    %edi
  ae:	00 00                	add    %al,(%eax)
  b0:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
  b4:	00 01                	add    %al,(%ecx)
  b6:	00 50 00             	add    %dl,0x0(%eax)
  b9:	00 00                	add    %al,(%eax)
  bb:	00 00                	add    %al,(%eax)
  bd:	00 00                	add    %al,(%eax)
  bf:	00 b3 00 00 00 bb    	add    %dh,-0x45000000(%ebx)
  c5:	00 00                	add    %al,(%eax)
  c7:	00 02                	add    %al,(%edx)
  c9:	00 91 00 bb 00 00    	add    %dl,0xbb00(%ecx)
  cf:	00 c6                	add    %al,%dh
  d1:	00 00                	add    %al,(%eax)
  d3:	00 07                	add    %al,(%edi)
  d5:	00 91 00 06 70 00    	add    %dl,0x700600(%ecx)
  db:	22 9f 00 00 00 00    	and    0x0(%edi),%bl
  e1:	00 00                	add    %al,(%eax)
  e3:	00 00                	add    %al,(%eax)
  e5:	b3 00                	mov    $0x0,%bl
  e7:	00 00                	add    %al,(%eax)
  e9:	bb 00 00 00 02       	mov    $0x2000000,%ebx
  ee:	00 30                	add    %dh,(%eax)
  f0:	9f                   	lahf   
  f1:	bb 00 00 00 c6       	mov    $0xc6000000,%ebx
  f6:	00 00                	add    %al,(%eax)
  f8:	00 01                	add    %al,(%ecx)
  fa:	00 50 00             	add    %dl,0x0(%eax)
  fd:	00 00                	add    %al,(%eax)
  ff:	00 00                	add    %al,(%eax)
 101:	00 00                	add    %al,(%eax)
 103:	00 c6                	add    %al,%dh
 105:	00 00                	add    %al,(%eax)
 107:	00 d8                	add    %bl,%al
 109:	00 00                	add    %al,(%eax)
 10b:	00 02                	add    %al,(%edx)
 10d:	00 30                	add    %dh,(%eax)
 10f:	9f                   	lahf   
 110:	d8 00                	fadds  (%eax)
 112:	00 00                	add    %al,(%eax)
 114:	f3 00 00             	repz add %al,(%eax)
 117:	00 01                	add    %al,(%ecx)
 119:	00 52 00             	add    %dl,0x0(%edx)
 11c:	00 00                	add    %al,(%eax)
 11e:	00 00                	add    %al,(%eax)
 120:	00 00                	add    %al,(%eax)
 122:	00 df                	add    %bl,%bh
 124:	00 00                	add    %al,(%eax)
 126:	00 ec                	add    %ch,%ah
 128:	00 00                	add    %al,(%eax)
 12a:	00 01                	add    %al,(%ecx)
 12c:	00 53 00             	add    %dl,0x0(%ebx)
 12f:	00 00                	add    %al,(%eax)
 131:	00 00                	add    %al,(%eax)
 133:	00 00                	add    %al,(%eax)
 135:	00 f3                	add    %dh,%bl
 137:	00 00                	add    %al,(%eax)
 139:	00 1d 01 00 00 02    	add    %bl,0x2000001
 13f:	00 91 00 1d 01 00    	add    %dl,0x11d00(%ecx)
 145:	00 4a 01             	add    %cl,0x1(%edx)
 148:	00 00                	add    %al,(%eax)
 14a:	01 00                	add    %eax,(%eax)
 14c:	50                   	push   %eax
 14d:	00 00                	add    %al,(%eax)
 14f:	00 00                	add    %al,(%eax)
 151:	00 00                	add    %al,(%eax)
 153:	00 00                	add    %al,(%eax)
 155:	1d 01 00 00 21       	sbb    $0x21000001,%eax
 15a:	01 00                	add    %eax,(%eax)
 15c:	00 01                	add    %al,(%ecx)
 15e:	00 56 21             	add    %dl,0x21(%esi)
 161:	01 00                	add    %eax,(%eax)
 163:	00 35 01 00 00 01    	add    %dh,0x1000001
 169:	00 51 35             	add    %dl,0x35(%ecx)
 16c:	01 00                	add    %eax,(%eax)
 16e:	00 3e                	add    %bh,(%esi)
 170:	01 00                	add    %eax,(%eax)
 172:	00 01                	add    %al,(%ecx)
 174:	00 52 3e             	add    %dl,0x3e(%edx)
 177:	01 00                	add    %eax,(%eax)
 179:	00 53 01             	add    %dl,0x1(%ebx)
 17c:	00 00                	add    %al,(%eax)
 17e:	01 00                	add    %eax,(%eax)
 180:	51                   	push   %ecx
 181:	00 00                	add    %al,(%eax)
 183:	00 00                	add    %al,(%eax)
 185:	00 00                	add    %al,(%eax)
 187:	00 00                	add    %al,(%eax)
 189:	f6 00 00             	testb  $0x0,(%eax)
 18c:	00 0a                	add    %cl,(%edx)
 18e:	01 00                	add    %eax,(%eax)
 190:	00 02                	add    %al,(%edx)
 192:	00 91 68 00 00 00    	add    %dl,0x68(%ecx)
 198:	00 00                	add    %al,(%eax)
 19a:	00 00                	add    %al,(%eax)
 19c:	00 b3 01 00 00 b4    	add    %dh,-0x4bffffff(%ebx)
 1a2:	01 00                	add    %eax,(%eax)
 1a4:	00 04 00             	add    %al,(%eax,%eax,1)
 1a7:	0a f7                	or     %bh,%dh
 1a9:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 1af:	00 00                	add    %al,(%eax)
 1b1:	00 00                	add    %al,(%eax)
 1b3:	bb 01 00 00 c3       	mov    $0xc3000001,%ebx
 1b8:	01 00                	add    %eax,(%eax)
 1ba:	00 02                	add    %al,(%edx)
 1bc:	00 31                	add    %dh,(%ecx)
 1be:	9f                   	lahf   
 1bf:	00 00                	add    %al,(%eax)
 1c1:	00 00                	add    %al,(%eax)
 1c3:	00 00                	add    %al,(%eax)
 1c5:	00 00                	add    %al,(%eax)
 1c7:	bb 01 00 00 c3       	mov    $0xc3000001,%ebx
 1cc:	01 00                	add    %eax,(%eax)
 1ce:	00 04 00             	add    %al,(%eax,%eax,1)
 1d1:	0a f2                	or     %dl,%dh
 1d3:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 1d9:	00 00                	add    %al,(%eax)
 1db:	00 00                	add    %al,(%eax)
 1dd:	c3                   	ret    
 1de:	01 00                	add    %eax,(%eax)
 1e0:	00 cb                	add    %cl,%bl
 1e2:	01 00                	add    %eax,(%eax)
 1e4:	00 01                	add    %al,(%ecx)
 1e6:	00 51 00             	add    %dl,0x0(%ecx)
 1e9:	00 00                	add    %al,(%eax)
 1eb:	00 00                	add    %al,(%eax)
 1ed:	00 00                	add    %al,(%eax)
 1ef:	00 c3                	add    %al,%bl
 1f1:	01 00                	add    %eax,(%eax)
 1f3:	00 cb                	add    %cl,%bl
 1f5:	01 00                	add    %eax,(%eax)
 1f7:	00 04 00             	add    %al,(%eax,%eax,1)
 1fa:	0a f3                	or     %bl,%dh
 1fc:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 202:	00 00                	add    %al,(%eax)
 204:	00 00                	add    %al,(%eax)
 206:	cb                   	lret   
 207:	01 00                	add    %eax,(%eax)
 209:	00 d6                	add    %dl,%dh
 20b:	01 00                	add    %eax,(%eax)
 20d:	00 02                	add    %al,(%edx)
 20f:	00 91 05 00 00 00    	add    %dl,0x5(%ecx)
 215:	00 00                	add    %al,(%eax)
 217:	00 00                	add    %al,(%eax)
 219:	00 cb                	add    %cl,%bl
 21b:	01 00                	add    %eax,(%eax)
 21d:	00 d6                	add    %dl,%dh
 21f:	01 00                	add    %eax,(%eax)
 221:	00 04 00             	add    %al,(%eax,%eax,1)
 224:	0a f4                	or     %ah,%dh
 226:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 22c:	00 00                	add    %al,(%eax)
 22e:	00 00                	add    %al,(%eax)
 230:	d6                   	(bad)  
 231:	01 00                	add    %eax,(%eax)
 233:	00 e1                	add    %ah,%cl
 235:	01 00                	add    %eax,(%eax)
 237:	00 02                	add    %al,(%edx)
 239:	00 91 06 00 00 00    	add    %dl,0x6(%ecx)
 23f:	00 00                	add    %al,(%eax)
 241:	00 00                	add    %al,(%eax)
 243:	00 d6                	add    %dl,%dh
 245:	01 00                	add    %eax,(%eax)
 247:	00 e1                	add    %ah,%cl
 249:	01 00                	add    %eax,(%eax)
 24b:	00 04 00             	add    %al,(%eax,%eax,1)
 24e:	0a f5                	or     %ch,%dh
 250:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 256:	00 00                	add    %al,(%eax)
 258:	00 00                	add    %al,(%eax)
 25a:	e1 01                	loope  25d <PROT_MODE_DSEG+0x24d>
 25c:	00 00                	add    %al,(%eax)
 25e:	ef                   	out    %eax,(%dx)
 25f:	01 00                	add    %eax,(%eax)
 261:	00 08                	add    %cl,(%eax)
 263:	00 91 07 94 01 09    	add    %dl,0x9019407(%ecx)
 269:	e0 21                	loopne 28c <PROT_MODE_DSEG+0x27c>
 26b:	9f                   	lahf   
 26c:	00 00                	add    %al,(%eax)
 26e:	00 00                	add    %al,(%eax)
 270:	00 00                	add    %al,(%eax)
 272:	00 00                	add    %al,(%eax)
 274:	e1 01                	loope  277 <PROT_MODE_DSEG+0x267>
 276:	00 00                	add    %al,(%eax)
 278:	ef                   	out    %eax,(%dx)
 279:	01 00                	add    %eax,(%eax)
 27b:	00 04 00             	add    %al,(%eax,%eax,1)
 27e:	0a f6                	or     %dh,%dh
 280:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 286:	00 00                	add    %al,(%eax)
 288:	00 00                	add    %al,(%eax)
 28a:	ef                   	out    %eax,(%dx)
 28b:	01 00                	add    %eax,(%eax)
 28d:	00 f7                	add    %dh,%bh
 28f:	01 00                	add    %eax,(%eax)
 291:	00 03                	add    %al,(%ebx)
 293:	00 08                	add    %cl,(%eax)
 295:	20 9f 00 00 00 00    	and    %bl,0x0(%edi)
 29b:	00 00                	add    %al,(%eax)
 29d:	00 00                	add    %al,(%eax)
 29f:	ef                   	out    %eax,(%dx)
 2a0:	01 00                	add    %eax,(%eax)
 2a2:	00 f7                	add    %dh,%bh
 2a4:	01 00                	add    %eax,(%eax)
 2a6:	00 04 00             	add    %al,(%eax,%eax,1)
 2a9:	0a f7                	or     %bh,%dh
 2ab:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 2b1:	00 00                	add    %al,(%eax)
 2b3:	00 00                	add    %al,(%eax)
 2b5:	f7 01 00 00 f8 01    	testl  $0x1f80000,(%ecx)
 2bb:	00 00                	add    %al,(%eax)
 2bd:	04 00                	add    $0x0,%al
 2bf:	0a f7                	or     %bh,%dh
 2c1:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 2c7:	00 00                	add    %al,(%eax)
 2c9:	00 00                	add    %al,(%eax)
 2cb:	ff 01                	incl   (%ecx)
 2cd:	00 00                	add    %al,(%eax)
 2cf:	0f 02 00             	lar    (%eax),%eax
 2d2:	00 03                	add    %al,(%ebx)
 2d4:	00 08                	add    %cl,(%eax)
 2d6:	80 9f 00 00 00 00 00 	sbbb   $0x0,0x0(%edi)
 2dd:	00 00                	add    %al,(%eax)
 2df:	00 ff                	add    %bh,%bh
 2e1:	01 00                	add    %eax,(%eax)
 2e3:	00 0f                	add    %cl,(%edi)
 2e5:	02 00                	add    (%eax),%al
 2e7:	00 02                	add    %al,(%edx)
 2e9:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
 2ef:	00 00                	add    %al,(%eax)
 2f1:	00 00                	add    %al,(%eax)
 2f3:	00 ff                	add    %bh,%bh
 2f5:	01 00                	add    %eax,(%eax)
 2f7:	00 0f                	add    %cl,(%edi)
 2f9:	02 00                	add    (%eax),%al
 2fb:	00 04 00             	add    %al,(%eax,%eax,1)
 2fe:	0a f0                	or     %al,%dh
 300:	01 9f 00 00 00 00    	add    %ebx,0x0(%edi)
 306:	00 00                	add    %al,(%eax)
 308:	00 00                	add    %al,(%eax)
 30a:	12 02                	adc    (%edx),%al
 30c:	00 00                	add    %al,(%eax)
 30e:	1b 02                	sbb    (%edx),%eax
 310:	00 00                	add    %al,(%eax)
 312:	02 00                	add    (%eax),%al
 314:	91                   	xchg   %eax,%ecx
 315:	00 1b                	add    %bl,(%ebx)
 317:	02 00                	add    (%eax),%al
 319:	00 2c 02             	add    %ch,(%edx,%eax,1)
 31c:	00 00                	add    %al,(%eax)
 31e:	0a 00                	or     (%eax),%al
 320:	91                   	xchg   %eax,%ecx
 321:	00 06                	add    %al,(%esi)
 323:	0c ff                	or     $0xff,%al
 325:	ff                   	(bad)  
 326:	ff 00                	incl   (%eax)
 328:	1a 9f 2c 02 00 00    	sbb    0x22c(%edi),%bl
 32e:	32 02                	xor    (%edx),%al
 330:	00 00                	add    %al,(%eax)
 332:	01 00                	add    %eax,(%eax)
 334:	56                   	push   %esi
 335:	32 02                	xor    (%edx),%al
 337:	00 00                	add    %al,(%eax)
 339:	42                   	inc    %edx
 33a:	02 00                	add    (%eax),%al
 33c:	00 01                	add    %al,(%ecx)
 33e:	00 53 42             	add    %dl,0x42(%ebx)
 341:	02 00                	add    (%eax),%al
 343:	00 46 02             	add    %al,0x2(%esi)
 346:	00 00                	add    %al,(%eax)
 348:	02 00                	add    (%eax),%al
 34a:	74 00                	je     34c <PROT_MODE_DSEG+0x33c>
 34c:	46                   	inc    %esi
 34d:	02 00                	add    (%eax),%al
 34f:	00 47 02             	add    %al,0x2(%edi)
 352:	00 00                	add    %al,(%eax)
 354:	04 00                	add    $0x0,%al
 356:	73 80                	jae    2d8 <PROT_MODE_DSEG+0x2c8>
 358:	7c 9f                	jl     2f9 <PROT_MODE_DSEG+0x2e9>
 35a:	47                   	inc    %edi
 35b:	02 00                	add    (%eax),%al
 35d:	00 4f 02             	add    %cl,0x2(%edi)
 360:	00 00                	add    %al,(%eax)
 362:	01 00                	add    %eax,(%eax)
 364:	53                   	push   %ebx
 365:	00 00                	add    %al,(%eax)
 367:	00 00                	add    %al,(%eax)
 369:	00 00                	add    %al,(%eax)
 36b:	00 00                	add    %al,(%eax)
 36d:	12 02                	adc    (%edx),%al
 36f:	00 00                	add    %al,(%eax)
 371:	35 02 00 00 02       	xor    $0x2000002,%eax
 376:	00 91 08 35 02 00    	add    %dl,0x23508(%ecx)
 37c:	00 3c 02             	add    %bh,(%edx,%eax,1)
 37f:	00 00                	add    %al,(%eax)
 381:	01 00                	add    %eax,(%eax)
 383:	57                   	push   %edi
 384:	3c 02                	cmp    $0x2,%al
 386:	00 00                	add    %al,(%eax)
 388:	46                   	inc    %esi
 389:	02 00                	add    (%eax),%al
 38b:	00 02                	add    %al,(%edx)
 38d:	00 74 04 46          	add    %dh,0x46(%esp,%eax,1)
 391:	02 00                	add    (%eax),%al
 393:	00 47 02             	add    %al,0x2(%edi)
 396:	00 00                	add    %al,(%eax)
 398:	03 00                	add    (%eax),%eax
 39a:	77 7f                	ja     41b <PROT_MODE_DSEG+0x40b>
 39c:	9f                   	lahf   
 39d:	47                   	inc    %edi
 39e:	02 00                	add    (%eax),%al
 3a0:	00 51 02             	add    %dl,0x2(%ecx)
 3a3:	00 00                	add    %al,(%eax)
 3a5:	01 00                	add    %eax,(%eax)
 3a7:	57                   	push   %edi
 3a8:	00 00                	add    %al,(%eax)
 3aa:	00 00                	add    %al,(%eax)
 3ac:	00 00                	add    %al,(%eax)
 3ae:	00 00                	add    %al,(%eax)
 3b0:	32 02                	xor    (%edx),%al
 3b2:	00 00                	add    %al,(%eax)
 3b4:	50                   	push   %eax
 3b5:	02 00                	add    (%eax),%al
 3b7:	00 01                	add    %al,(%ecx)
 3b9:	00 56 50             	add    %dl,0x50(%esi)
 3bc:	02 00                	add    (%eax),%al
 3be:	00 53 02             	add    %dl,0x2(%ebx)
 3c1:	00 00                	add    %al,(%eax)
 3c3:	0e                   	push   %cs
 3c4:	00 91 00 06 0c ff    	add    %dl,-0xf3fa00(%ecx)
 3ca:	ff                   	(bad)  
 3cb:	ff 00                	incl   (%eax)
 3cd:	1a 91 04 06 22 9f    	sbb    -0x60ddf9fc(%ecx),%dl
 3d3:	00 00                	add    %al,(%eax)
 3d5:	00 00                	add    %al,(%eax)
 3d7:	00 00                	add    %al,(%eax)
 3d9:	00 00                	add    %al,(%eax)
 3db:	3d 00 00 00 4f       	cmp    $0x4f000000,%eax
 3e0:	00 00                	add    %al,(%eax)
 3e2:	00 0b                	add    %cl,(%ebx)
 3e4:	00 0c 1c             	add    %cl,(%esp,%ebx,1)
 3e7:	00 02                	add    %al,(%edx)
 3e9:	00 06                	add    %al,(%esi)
 3eb:	23 80 80 08 9f 4f    	and    0x4f9f0880(%eax),%eax
 3f1:	00 00                	add    %al,(%eax)
 3f3:	00 5f 00             	add    %bl,0x0(%edi)
 3f6:	00 00                	add    %al,(%eax)
 3f8:	01 00                	add    %eax,(%eax)
 3fa:	53                   	push   %ebx
 3fb:	5f                   	pop    %edi
 3fc:	00 00                	add    %al,(%eax)
 3fe:	00 6a 00             	add    %ch,0x0(%edx)
 401:	00 00                	add    %al,(%eax)
 403:	03 00                	add    (%eax),%eax
 405:	73 60                	jae    467 <PROT_MODE_DSEG+0x457>
 407:	9f                   	lahf   
 408:	6a 00                	push   $0x0
 40a:	00 00                	add    %al,(%eax)
 40c:	78 00                	js     40e <PROT_MODE_DSEG+0x3fe>
 40e:	00 00                	add    %al,(%eax)
 410:	01 00                	add    %eax,(%eax)
 412:	53                   	push   %ebx
 413:	00 00                	add    %al,(%eax)
 415:	00 00                	add    %al,(%eax)
 417:	00 00                	add    %al,(%eax)
 419:	00 00                	add    %al,(%eax)
 41b:	54                   	push   %esp
 41c:	00 00                	add    %al,(%eax)
 41e:	00 7e 00             	add    %bh,0x0(%esi)
 421:	00 00                	add    %al,(%eax)
 423:	01 00                	add    %eax,(%eax)
 425:	56                   	push   %esi
 426:	00 00                	add    %al,(%eax)
 428:	00 00                	add    %al,(%eax)
 42a:	00 00                	add    %al,(%eax)
 42c:	00 00                	add    %al,(%eax)
 42e:	89 00                	mov    %eax,(%eax)
 430:	00 00                	add    %al,(%eax)
 432:	9b                   	fwait
 433:	00 00                	add    %al,(%eax)
 435:	00 02                	add    %al,(%edx)
 437:	00 91 00 9b 00 00    	add    %dl,0x9b00(%ecx)
 43d:	00 af 00 00 00 01    	add    %ch,0x1000000(%edi)
 443:	00 53 af             	add    %dl,-0x51(%ebx)
 446:	00 00                	add    %al,(%eax)
 448:	00 b5 00 00 00 03    	add    %dh,0x3000000(%ebp)
 44e:	00 73 68             	add    %dh,0x68(%ebx)
 451:	9f                   	lahf   
 452:	b5 00                	mov    $0x0,%ch
 454:	00 00                	add    %al,(%eax)
 456:	dd 00                	fldl   (%eax)
 458:	00 00                	add    %al,(%eax)
 45a:	01 00                	add    %eax,(%eax)
 45c:	53                   	push   %ebx
 45d:	00 00                	add    %al,(%eax)
 45f:	00 00                	add    %al,(%eax)
 461:	00 00                	add    %al,(%eax)
 463:	00 00                	add    %al,(%eax)
 465:	89 00                	mov    %eax,(%eax)
 467:	00 00                	add    %al,(%eax)
 469:	9b                   	fwait
 46a:	00 00                	add    %al,(%eax)
 46c:	00 02                	add    %al,(%edx)
 46e:	00 30                	add    %dh,(%eax)
 470:	9f                   	lahf   
 471:	a2 00 00 00 b4       	mov    %al,0xb4000000
 476:	00 00                	add    %al,(%eax)
 478:	00 01                	add    %al,(%ecx)
 47a:	00 52 b4             	add    %dl,-0x4c(%edx)
 47d:	00 00                	add    %al,(%eax)
 47f:	00 b5 00 00 00 08    	add    %dh,0x8000000(%ebp)
 485:	00 73 00             	add    %dh,0x0(%ebx)
 488:	76 00                	jbe    48a <PROT_MODE_DSEG+0x47a>
 48a:	1c 48                	sbb    $0x48,%al
 48c:	1c 9f                	sbb    $0x9f,%al
 48e:	b5 00                	mov    $0x0,%ch
 490:	00 00                	add    %al,(%eax)
 492:	ba 00 00 00 06       	mov    $0x6000000,%edx
 497:	00 73 00             	add    %dh,0x0(%ebx)
 49a:	76 00                	jbe    49c <PROT_MODE_DSEG+0x48c>
 49c:	1c 9f                	sbb    $0x9f,%al
 49e:	ba 00 00 00 e0       	mov    $0xe0000000,%edx
 4a3:	00 00                	add    %al,(%eax)
 4a5:	00 01                	add    %al,(%ecx)
 4a7:	00 52 00             	add    %dl,0x0(%edx)
 4aa:	00 00                	add    %al,(%eax)
 4ac:	00 00                	add    %al,(%eax)
 4ae:	00 00                	add    %al,(%eax)
 4b0:	00 01                	add    %al,(%ecx)
 4b2:	01 00                	add    %eax,(%eax)
 4b4:	00 06                	add    %al,(%esi)
 4b6:	01 00                	add    %eax,(%eax)
 4b8:	00 02                	add    %al,(%edx)
 4ba:	00 30                	add    %dh,(%eax)
 4bc:	9f                   	lahf   
 4bd:	06                   	push   %es
 4be:	01 00                	add    %eax,(%eax)
 4c0:	00 2c 01             	add    %ch,(%ecx,%eax,1)
 4c3:	00 00                	add    %al,(%eax)
 4c5:	01 00                	add    %eax,(%eax)
 4c7:	50                   	push   %eax
 4c8:	2d 01 00 00 30       	sub    $0x30000001,%eax
 4cd:	01 00                	add    %eax,(%eax)
 4cf:	00 01                	add    %al,(%ecx)
 4d1:	00 50 30             	add    %dl,0x30(%eax)
 4d4:	01 00                	add    %eax,(%eax)
 4d6:	00 36                	add    %dh,(%esi)
 4d8:	01 00                	add    %eax,(%eax)
 4da:	00 03                	add    %al,(%ebx)
 4dc:	00 70 65             	add    %dh,0x65(%eax)
 4df:	9f                   	lahf   
 4e0:	00 00                	add    %al,(%eax)
 4e2:	00 00                	add    %al,(%eax)
 4e4:	00 00                	add    %al,(%eax)
 4e6:	00 00                	add    %al,(%eax)
 4e8:	01 01                	add    %eax,(%ecx)
 4ea:	00 00                	add    %al,(%eax)
 4ec:	2d 01 00 00 02       	sub    $0x2000001,%eax
 4f1:	00 30                	add    %dh,(%eax)
 4f3:	9f                   	lahf   
 4f4:	2d 01 00 00 5d       	sub    $0x5d000001,%eax
 4f9:	01 00                	add    %eax,(%eax)
 4fb:	00 02                	add    %al,(%edx)
 4fd:	00 31                	add    %dh,(%ecx)
 4ff:	9f                   	lahf   
 500:	00 00                	add    %al,(%eax)
 502:	00 00                	add    %al,(%eax)
 504:	00 00                	add    %al,(%eax)
 506:	00 00                	add    %al,(%eax)
 508:	41                   	inc    %ecx
 509:	01 00                	add    %eax,(%eax)
 50b:	00 48 01             	add    %cl,0x1(%eax)
 50e:	00 00                	add    %al,(%eax)
 510:	01 00                	add    %eax,(%eax)
 512:	50                   	push   %eax
 513:	48                   	dec    %eax
 514:	01 00                	add    %eax,(%eax)
 516:	00 57 01             	add    %dl,0x1(%edi)
 519:	00 00                	add    %al,(%eax)
 51b:	01 00                	add    %eax,(%eax)
 51d:	56                   	push   %esi
 51e:	57                   	push   %edi
 51f:	01 00                	add    %eax,(%eax)
 521:	00 5c 01 00          	add    %bl,0x0(%ecx,%eax,1)
 525:	00 02                	add    %al,(%edx)
 527:	00 91 00 00 00 00    	add    %dl,0x0(%ecx)
 52d:	00 00                	add    %al,(%eax)
 52f:	00 00                	add    %al,(%eax)
 531:	00 49 01             	add    %cl,0x1(%ecx)
 534:	00 00                	add    %al,(%eax)
 536:	5c                   	pop    %esp
 537:	01 00                	add    %eax,(%eax)
 539:	00 01                	add    %al,(%ecx)
 53b:	00 50 00             	add    %dl,0x0(%eax)
 53e:	00 00                	add    %al,(%eax)
 540:	00 00                	add    %al,(%eax)
 542:	00 00                	add    %al,(%eax)
 544:	00                   	.byte 0x0

Disassembly of section .debug_ranges:

00000000 <.debug_ranges>:
   0:	a8 01                	test   $0x1,%al
   2:	00 00                	add    %al,(%eax)
   4:	ad                   	lods   %ds:(%esi),%eax
   5:	01 00                	add    %eax,(%eax)
   7:	00 b3 01 00 00 bb    	add    %dh,-0x44ffffff(%ebx)
   d:	01 00                	add    %eax,(%eax)
   f:	00 00                	add    %al,(%eax)
  11:	00 00                	add    %al,(%eax)
  13:	00 00                	add    %al,(%eax)
  15:	00 00                	add    %al,(%eax)
  17:	00 a8 01 00 00 ad    	add    %ch,-0x52ffffff(%eax)
  1d:	01 00                	add    %eax,(%eax)
  1f:	00 b3 01 00 00 b4    	add    %dh,-0x4bffffff(%ebx)
  25:	01 00                	add    %eax,(%eax)
  27:	00 00                	add    %al,(%eax)
  29:	00 00                	add    %al,(%eax)
  2b:	00 00                	add    %al,(%eax)
  2d:	00 00                	add    %al,(%eax)
  2f:	00 2d 01 00 00 52    	add    %ch,0x52000001
  35:	01 00                	add    %eax,(%eax)
  37:	00 58 01             	add    %bl,0x1(%eax)
  3a:	00 00                	add    %al,(%eax)
  3c:	5d                   	pop    %ebp
  3d:	01 00                	add    %eax,(%eax)
  3f:	00 00                	add    %al,(%eax)
  41:	00 00                	add    %al,(%eax)
  43:	00 00                	add    %al,(%eax)
  45:	00 00                	add    %al,(%eax)
  47:	00                   	.byte 0x0
