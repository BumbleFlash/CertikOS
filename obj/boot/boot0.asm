
obj/boot/boot0.elf:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:

    /**
      * Clear the interrupts flag, disabling the interrupts.
      * Clear the direction flag, to configure auto-increment mode.
      */
    cli
    7c00:	fa                   	cli    
    cld
    7c01:	fc                   	cld    



   #clear the registers
    /*segment registers aparently accepts value only from another register, so I used a general purpose to transfer values*/
     xorw %ax, %ax
    7c02:	31 c0                	xor    %ax,%ax
     movw %ax, %ds
    7c04:	8e d8                	mov    %ax,%ds
     movw %ax, %es
    7c06:	8e c0                	mov    %ax,%es
     movw %ax, %fs
    7c08:	8e e0                	mov    %ax,%fs
     movw %ax, %gs
    7c0a:	8e e8                	mov    %ax,%gs
     movw %ax, %ss
    7c0c:	8e d0                	mov    %ax,%ss

    #set up stack pointer
     movw $(boot0 - 1), %sp    #one memory address before the boot0
    7c0e:	bc ff 7b             	mov    $0x7bff,%sp
    #set video mode.
     movw $0x03, %ax
    7c11:	b8 03 00             	mov    $0x3,%ax
     int $0x10
    7c14:	cd 10                	int    $0x10

    #print message
     movw $STARTUP_MSG, %si    #loading to the source register for the lodsb to load from
    7c16:	be 56 7c             	mov    $0x7c56,%si
     xorl %eax,%eax             #clearing the resister before use.
    7c19:	66 31 c0             	xor    %eax,%eax
     movb $0xe, %ah
    7c1c:	b4 0e                	mov    $0xe,%ah
     call print_string
    7c1e:	e8 2b 00             	call   7c4c <loop>


    # read disk

     pushl $0x0  #upper address of  LBA
    7c21:	66 6a 00             	pushl  $0x0
     pushl $0x1  # lower address of LBA
    7c24:	66 6a 01             	pushl  $0x1
     pushl $boot1 # boot1 address
    7c27:	66 68 00 7e 00 00    	pushl  $0x7e00
     pushw $62     # number of sectors, 63-2+1 = 62
    7c2d:	6a 3e                	push   $0x3e
     pushw $0x010   #unused sector and size of DAP
    7c2f:	6a 10                	push   $0x10

     xorl %eax, %eax #clear the register
    7c31:	66 31 c0             	xor    %eax,%eax
     movb $0x42, %ah
    7c34:	b4 42                	mov    $0x42,%ah
     movb $0x0, %al
    7c36:	b0 00                	mov    $0x0,%al
     movw %sp , %si  # pushing the stack pointer to the si register as the interrupt takes in arguments DS:SI
    7c38:	89 e6                	mov    %sp,%si
     int $0x13
    7c3a:	cd 13                	int    $0x13
     jc fail
    7c3c:	72 03                	jb     7c41 <fail>
     jmp boot1
    7c3e:	e9 bf 01             	jmp    7e00 <boot1>

00007c41 <fail>:

fail:
     movw $LOAD_FAIL_MSG, %si    #loading to the source register for the lodsb to load from
    7c41:	be 68 7c             	mov    $0x7c68,%si
     xorl %eax,%eax             #clearing the resister before use.
    7c44:	66 31 c0             	xor    %eax,%eax
     movb $0xe, %ah
    7c47:	b4 0e                	mov    $0xe,%ah
     call print_string
    7c49:	e8 00 00             	call   7c4c <loop>

00007c4c <loop>:



print_string:
     loop:
           lodsb
    7c4c:	ac                   	lods   %ds:(%si),%al
           cmp $0, %al    #checks if the character is 0
    7c4d:	3c 00                	cmp    $0x0,%al
           je exitloop   # if 0, exits loop
    7c4f:	74 04                	je     7c55 <exitloop>
           int $0x10       # prints the character
    7c51:	cd 10                	int    $0x10
           jmp loop      # jumps to starting of the loop
    7c53:	eb f7                	jmp    7c4c <loop>

00007c55 <exitloop>:
     exitloop:
            ret           # empty return to come out of the function
    7c55:	c3                   	ret    

00007c56 <STARTUP_MSG>:
    7c56:	53                   	push   %bx
    7c57:	74 61                	je     7cba <_end+0x32>
    7c59:	72 74                	jb     7ccf <_end+0x47>
    7c5b:	20 62 6f             	and    %ah,0x6f(%bp,%si)
    7c5e:	6f                   	outsw  %ds:(%si),(%dx)
    7c5f:	74 30                	je     7c91 <_end+0x9>
    7c61:	20 2e 2e 2e          	and    %ch,0x2e2e
    7c65:	0d 0a 00             	or     $0xa,%ax

00007c68 <LOAD_FAIL_MSG>:
    7c68:	45                   	inc    %bp
    7c69:	72 72                	jb     7cdd <_end+0x55>
    7c6b:	6f                   	outsw  %ds:(%si),(%dx)
    7c6c:	72 20                	jb     7c8e <_end+0x6>
    7c6e:	64 75 72             	fs jne 7ce3 <_end+0x5b>
    7c71:	69 6e 67 20 6c       	imul   $0x6c20,0x67(%bp),%bp
    7c76:	6f                   	outsw  %ds:(%si),(%dx)
    7c77:	61                   	popa   
    7c78:	64 69 6e 67 20 62    	imul   $0x6220,%fs:0x67(%bp),%bp
    7c7e:	6f                   	outsw  %ds:(%si),(%dx)
    7c7f:	6f                   	outsw  %ds:(%si),(%dx)
    7c80:	74 31                	je     7cb3 <_end+0x2b>
    7c82:	2e 0d 0a 00          	cs or  $0xa,%ax
