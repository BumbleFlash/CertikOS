/*
 * Filename: boot0.S
 * Description:
 *  - Sets up the machine registers (including the stack pointers) properly
 *    for execution in 16-bit mode.
 *  - Utilizes the BIOS interrupt mechanism to output messages to the screen.
 *  - Reads the second stage bootloader from the disk into appropriate location.
 *    (boot1 is put just after MBR and before the first partition, i.e. from
 *    sector 2 to sector 63.)
 *  - Correctly transfers execution to the loaded second stage bootloader.
 */



    /* assemble the file in 16-bit mode */
    .set boot0,  0x7c00 #boot0 start address
    .set boot1,  0x7e00 #boot1 start address
    .globl start
start:
    /* assemble the file in 16-bit mode */


    /**
      * Clear the interrupts flag, disabling the interrupts.
      * Clear the direction flag, to configure auto-increment mode.
      */
    cli
    cld


    .code16
/*******************************************************************************
*   YOUR 16-bit CODE
*******************************************************************************/




   #clear the registers
    /*segment registers aparently accepts value only from another register, so I used a general purpose to transfer values*/
     xorw %ax, %ax
     movw %ax, %ds
     movw %ax, %es
     movw %ax, %fs
     movw %ax, %gs
     movw %ax, %ss

    #set up stack pointer
     movw $(boot0 - 1), %sp    #one memory address before the boot0
    #set video mode.
     movw $0x03, %ax
     int $0x10

    #print message
     movw $STARTUP_MSG, %si    #loading to the source register for the lodsb to load from
     xorl %eax,%eax             #clearing the resister before use.
     movb $0xe, %ah
     call print_string


    # read disk

     pushl $0x0  #upper address of  LBA
     pushl $0x1  # lower address of LBA
     pushl $boot1 # boot1 address
     pushw $62     # number of sectors, 63-2+1 = 62
     pushw $0x010   #unused sector and size of DAP

     xorl %eax, %eax #clear the register
     movb $0x42, %ah
     movb $0x0, %al
     movw %sp , %si  # pushing the stack pointer to the si register as the interrupt takes in arguments DS:SI
     int $0x13
     jc fail
     jmp boot1

fail:
     movw $LOAD_FAIL_MSG, %si    #loading to the source register for the lodsb to load from
     xorl %eax,%eax             #clearing the resister before use.
     movb $0xe, %ah
     call print_string


/*******************************************************************************
*   DATA STRUCTURES
*******************************************************************************/




print_string:
     loop:
           lodsb
           cmp $0, %al    #checks if the character is 0
           je exitloop   # if 0, exits loop
           int $0x10       # prints the character
           jmp loop      # jumps to starting of the loop
     exitloop:
            ret           # empty return to come out of the function


STARTUP_MSG:
    .ascii    "Start boot0 ...\r\n\0"

 

LOAD_FAIL_MSG:
    .ascii    "Error during loading boot1.\r\n\0"
