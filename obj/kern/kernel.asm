
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <video_init>:
#include "video.h"
//tmphack
//#include<dev/serial.h>
void
video_init(void)
{
  100000:	56                   	push   %esi
  100001:	53                   	push   %ebx
  100002:	83 ec 04             	sub    $0x4,%esp
	uint16_t was;
	unsigned pos;

	/* Get a pointer to the memory-mapped text display buffer. */
	cp = (uint16_t*) CGA_BUF;
	was = *cp;
  100005:	0f b7 15 00 80 0b 00 	movzwl 0xb8000,%edx
	*cp = (uint16_t) 0xA55A;
  10000c:	66 c7 05 00 80 0b 00 	movw   $0xa55a,0xb8000
  100013:	5a a5 
	if (*cp != 0xA55A) {
  100015:	0f b7 05 00 80 0b 00 	movzwl 0xb8000,%eax
  10001c:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100020:	74 26                	je     100048 <video_init+0x48>
		cp = (uint16_t*) MONO_BUF;
		addr_6845 = MONO_BASE;
  100022:	c7 05 8c 64 96 01 b4 	movl   $0x3b4,0x196648c
  100029:	03 00 00 
		dprintf("addr_6845:%x\n",addr_6845);
  10002c:	83 ec 08             	sub    $0x8,%esp
  10002f:	68 b4 03 00 00       	push   $0x3b4
  100034:	68 80 5a 10 00       	push   $0x105a80
  100039:	e8 cd 1d 00 00       	call   101e0b <dprintf>
  10003e:	83 c4 10             	add    $0x10,%esp
	/* Get a pointer to the memory-mapped text display buffer. */
	cp = (uint16_t*) CGA_BUF;
	was = *cp;
	*cp = (uint16_t) 0xA55A;
	if (*cp != 0xA55A) {
		cp = (uint16_t*) MONO_BUF;
  100041:	be 00 00 0b 00       	mov    $0xb0000,%esi
  100046:	eb 2b                	jmp    100073 <video_init+0x73>
		addr_6845 = MONO_BASE;
		dprintf("addr_6845:%x\n",addr_6845);
	} else {
		*cp = was;
  100048:	66 89 15 00 80 0b 00 	mov    %dx,0xb8000
		addr_6845 = CGA_BASE;
  10004f:	c7 05 8c 64 96 01 d4 	movl   $0x3d4,0x196648c
  100056:	03 00 00 
		dprintf("addr_6845:%x\n",addr_6845);
  100059:	83 ec 08             	sub    $0x8,%esp
  10005c:	68 d4 03 00 00       	push   $0x3d4
  100061:	68 80 5a 10 00       	push   $0x105a80
  100066:	e8 a0 1d 00 00       	call   101e0b <dprintf>
  10006b:	83 c4 10             	add    $0x10,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	/* Get a pointer to the memory-mapped text display buffer. */
	cp = (uint16_t*) CGA_BUF;
  10006e:	be 00 80 0b 00       	mov    $0xb8000,%esi
		addr_6845 = CGA_BASE;
		dprintf("addr_6845:%x\n",addr_6845);
	}
	
	/* Extract cursor location */
	outb(addr_6845, 14);
  100073:	83 ec 08             	sub    $0x8,%esp
  100076:	6a 0e                	push   $0xe
  100078:	ff 35 8c 64 96 01    	pushl  0x196648c
  10007e:	e8 cd 25 00 00       	call   102650 <outb>
	pos = inb(addr_6845 + 1) << 8;
  100083:	a1 8c 64 96 01       	mov    0x196648c,%eax
  100088:	83 c0 01             	add    $0x1,%eax
  10008b:	89 04 24             	mov    %eax,(%esp)
  10008e:	e8 a5 25 00 00       	call   102638 <inb>
  100093:	0f b6 d8             	movzbl %al,%ebx
  100096:	c1 e3 08             	shl    $0x8,%ebx
	outb(addr_6845, 15);
  100099:	83 c4 08             	add    $0x8,%esp
  10009c:	6a 0f                	push   $0xf
  10009e:	ff 35 8c 64 96 01    	pushl  0x196648c
  1000a4:	e8 a7 25 00 00       	call   102650 <outb>
	pos |= inb(addr_6845 + 1);
  1000a9:	a1 8c 64 96 01       	mov    0x196648c,%eax
  1000ae:	83 c0 01             	add    $0x1,%eax
  1000b1:	89 04 24             	mov    %eax,(%esp)
  1000b4:	e8 7f 25 00 00       	call   102638 <inb>
  1000b9:	0f b6 c0             	movzbl %al,%eax
  1000bc:	09 c3                	or     %eax,%ebx

	terminal.crt_buf = (uint16_t*) cp;
  1000be:	89 35 80 64 96 01    	mov    %esi,0x1966480
	terminal.crt_pos = pos;
  1000c4:	66 89 1d 84 64 96 01 	mov    %bx,0x1966484
	terminal.active_console = 0;
  1000cb:	c7 05 88 64 96 01 00 	movl   $0x0,0x1966488
  1000d2:	00 00 00 
//  video_clear_screen();
}
  1000d5:	83 c4 14             	add    $0x14,%esp
  1000d8:	5b                   	pop    %ebx
  1000d9:	5e                   	pop    %esi
  1000da:	c3                   	ret    

001000db <video_putc>:

void
video_putc(int c)
{
  1000db:	83 ec 0c             	sub    $0xc,%esp
  1000de:	8b 44 24 10          	mov    0x10(%esp),%eax

	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
  1000e2:	a9 00 ff ff ff       	test   $0xffffff00,%eax
  1000e7:	75 03                	jne    1000ec <video_putc+0x11>
		c |= 0x0700;
  1000e9:	80 cc 07             	or     $0x7,%ah

	switch (c & 0xff) {
  1000ec:	0f b6 d0             	movzbl %al,%edx
  1000ef:	83 fa 09             	cmp    $0x9,%edx
  1000f2:	0f 84 82 00 00 00    	je     10017a <video_putc+0x9f>
  1000f8:	83 fa 09             	cmp    $0x9,%edx
  1000fb:	7f 0a                	jg     100107 <video_putc+0x2c>
  1000fd:	83 fa 08             	cmp    $0x8,%edx
  100100:	74 14                	je     100116 <video_putc+0x3b>
  100102:	e9 b2 00 00 00       	jmp    1001b9 <video_putc+0xde>
  100107:	83 fa 0a             	cmp    $0xa,%edx
  10010a:	74 3c                	je     100148 <video_putc+0x6d>
  10010c:	83 fa 0d             	cmp    $0xd,%edx
  10010f:	74 47                	je     100158 <video_putc+0x7d>
  100111:	e9 a3 00 00 00       	jmp    1001b9 <video_putc+0xde>
	case '\b':
		if (terminal.crt_pos > 0) {
  100116:	0f b7 15 84 64 96 01 	movzwl 0x1966484,%edx
  10011d:	66 85 d2             	test   %dx,%dx
  100120:	0f 84 b1 00 00 00    	je     1001d7 <video_putc+0xfc>
			terminal.crt_pos--;
  100126:	83 ea 01             	sub    $0x1,%edx
  100129:	66 89 15 84 64 96 01 	mov    %dx,0x1966484
			terminal.crt_buf[terminal.crt_pos] = (c & ~0xff) | ' ';
  100130:	0f b7 d2             	movzwl %dx,%edx
  100133:	01 d2                	add    %edx,%edx
  100135:	03 15 80 64 96 01    	add    0x1966480,%edx
  10013b:	b0 00                	mov    $0x0,%al
  10013d:	83 c8 20             	or     $0x20,%eax
  100140:	66 89 02             	mov    %ax,(%edx)
  100143:	e9 8f 00 00 00       	jmp    1001d7 <video_putc+0xfc>
		}
		break;
	case '\n':
		terminal.crt_pos += CRT_COLS;
  100148:	0f b7 05 84 64 96 01 	movzwl 0x1966484,%eax
  10014f:	83 c0 50             	add    $0x50,%eax
  100152:	66 a3 84 64 96 01    	mov    %ax,0x1966484
		/* fallthru */
	case '\r':
		terminal.crt_pos -= (terminal.crt_pos % CRT_COLS);
  100158:	0f b7 05 84 64 96 01 	movzwl 0x1966484,%eax
  10015f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  100165:	c1 e8 10             	shr    $0x10,%eax
  100168:	66 c1 e8 06          	shr    $0x6,%ax
  10016c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  10016f:	c1 e0 04             	shl    $0x4,%eax
  100172:	66 a3 84 64 96 01    	mov    %ax,0x1966484
		break;
  100178:	eb 5d                	jmp    1001d7 <video_putc+0xfc>
	case '\t':
		video_putc(' ');
  10017a:	83 ec 0c             	sub    $0xc,%esp
  10017d:	6a 20                	push   $0x20
  10017f:	e8 57 ff ff ff       	call   1000db <video_putc>
		video_putc(' ');
  100184:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10018b:	e8 4b ff ff ff       	call   1000db <video_putc>
		video_putc(' ');
  100190:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100197:	e8 3f ff ff ff       	call   1000db <video_putc>
		video_putc(' ');
  10019c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1001a3:	e8 33 ff ff ff       	call   1000db <video_putc>
		video_putc(' ');
  1001a8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1001af:	e8 27 ff ff ff       	call   1000db <video_putc>
		break;
  1001b4:	83 c4 10             	add    $0x10,%esp
  1001b7:	eb 1e                	jmp    1001d7 <video_putc+0xfc>
	default:
		terminal.crt_buf[terminal.crt_pos++] = c;		/* write the character */
  1001b9:	0f b7 15 84 64 96 01 	movzwl 0x1966484,%edx
  1001c0:	8d 4a 01             	lea    0x1(%edx),%ecx
  1001c3:	66 89 0d 84 64 96 01 	mov    %cx,0x1966484
  1001ca:	0f b7 d2             	movzwl %dx,%edx
  1001cd:	8b 0d 80 64 96 01    	mov    0x1966480,%ecx
  1001d3:	66 89 04 51          	mov    %ax,(%ecx,%edx,2)
		break;
	}

	if (terminal.crt_pos >= CRT_SIZE) {
  1001d7:	66 81 3d 84 64 96 01 	cmpw   $0x7cf,0x1966484
  1001de:	cf 07 
  1001e0:	76 4c                	jbe    10022e <video_putc+0x153>
		int i;
		memmove(terminal.crt_buf, terminal.crt_buf + CRT_COLS,
  1001e2:	a1 80 64 96 01       	mov    0x1966480,%eax
  1001e7:	83 ec 04             	sub    $0x4,%esp
  1001ea:	68 00 0f 00 00       	push   $0xf00
  1001ef:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1001f5:	52                   	push   %edx
  1001f6:	50                   	push   %eax
  1001f7:	e8 0b 19 00 00       	call   101b07 <memmove>
			(CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  1001fc:	83 c4 10             	add    $0x10,%esp
  1001ff:	b8 80 07 00 00       	mov    $0x780,%eax
  100204:	eb 11                	jmp    100217 <video_putc+0x13c>
			terminal.crt_buf[i] = 0x0700 | ' ';
  100206:	8d 14 00             	lea    (%eax,%eax,1),%edx
  100209:	03 15 80 64 96 01    	add    0x1966480,%edx
  10020f:	66 c7 02 20 07       	movw   $0x720,(%edx)

	if (terminal.crt_pos >= CRT_SIZE) {
		int i;
		memmove(terminal.crt_buf, terminal.crt_buf + CRT_COLS,
			(CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
  100214:	83 c0 01             	add    $0x1,%eax
  100217:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  10021c:	7e e8                	jle    100206 <video_putc+0x12b>
			terminal.crt_buf[i] = 0x0700 | ' ';
		terminal.crt_pos -= CRT_COLS;
  10021e:	0f b7 05 84 64 96 01 	movzwl 0x1966484,%eax
  100225:	83 e8 50             	sub    $0x50,%eax
  100228:	66 a3 84 64 96 01    	mov    %ax,0x1966484
	}


	/* move that little blinky thing */
	outb(addr_6845, 14);
  10022e:	83 ec 08             	sub    $0x8,%esp
  100231:	6a 0e                	push   $0xe
  100233:	ff 35 8c 64 96 01    	pushl  0x196648c
  100239:	e8 12 24 00 00       	call   102650 <outb>
	outb(addr_6845 + 1, terminal.crt_pos >> 8);
  10023e:	a1 8c 64 96 01       	mov    0x196648c,%eax
  100243:	83 c0 01             	add    $0x1,%eax
  100246:	83 c4 08             	add    $0x8,%esp
  100249:	0f b6 15 85 64 96 01 	movzbl 0x1966485,%edx
  100250:	52                   	push   %edx
  100251:	50                   	push   %eax
  100252:	e8 f9 23 00 00       	call   102650 <outb>
	outb(addr_6845, 15);
  100257:	83 c4 08             	add    $0x8,%esp
  10025a:	6a 0f                	push   $0xf
  10025c:	ff 35 8c 64 96 01    	pushl  0x196648c
  100262:	e8 e9 23 00 00       	call   102650 <outb>
	outb(addr_6845 + 1, terminal.crt_pos);
  100267:	a1 8c 64 96 01       	mov    0x196648c,%eax
  10026c:	83 c0 01             	add    $0x1,%eax
  10026f:	83 c4 08             	add    $0x8,%esp
  100272:	0f b6 15 84 64 96 01 	movzbl 0x1966484,%edx
  100279:	52                   	push   %edx
  10027a:	50                   	push   %eax
  10027b:	e8 d0 23 00 00       	call   102650 <outb>
       	  }
       outb(COM1+COM_TX, c);
       tmpcount++;
	  }
	*/
}
  100280:	83 c4 1c             	add    $0x1c,%esp
  100283:	c3                   	ret    

00100284 <video_set_cursor>:

void
video_set_cursor (int x, int y)
{
  100284:	8b 44 24 04          	mov    0x4(%esp),%eax
    terminal.crt_pos = x * CRT_COLS + y;
  100288:	8d 04 80             	lea    (%eax,%eax,4),%eax
  10028b:	c1 e0 04             	shl    $0x4,%eax
  10028e:	89 c2                	mov    %eax,%edx
  100290:	66 03 54 24 08       	add    0x8(%esp),%dx
  100295:	66 89 15 84 64 96 01 	mov    %dx,0x1966484
  10029c:	c3                   	ret    

0010029d <video_clear_screen>:

void
video_clear_screen ()
{
    int i;
    for (i = 0; i < CRT_SIZE; i++)
  10029d:	b8 00 00 00 00       	mov    $0x0,%eax
  1002a2:	eb 11                	jmp    1002b5 <video_clear_screen+0x18>
    {
        terminal.crt_buf[i] = ' ';
  1002a4:	8d 14 00             	lea    (%eax,%eax,1),%edx
  1002a7:	03 15 80 64 96 01    	add    0x1966480,%edx
  1002ad:	66 c7 02 20 00       	movw   $0x20,(%edx)

void
video_clear_screen ()
{
    int i;
    for (i = 0; i < CRT_SIZE; i++)
  1002b2:	83 c0 01             	add    $0x1,%eax
  1002b5:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1002ba:	7e e8                	jle    1002a4 <video_clear_screen+0x7>
    {
        terminal.crt_buf[i] = ' ';
    }
}
  1002bc:	f3 c3                	repz ret 

001002be <cons_init>:
	uint32_t rpos, wpos;
} cons;

void
cons_init()
{
  1002be:	83 ec 10             	sub    $0x10,%esp
	memset(&cons, 0x0, sizeof(cons));
  1002c1:	68 08 02 00 00       	push   $0x208
  1002c6:	6a 00                	push   $0x0
  1002c8:	68 a0 64 96 01       	push   $0x19664a0
  1002cd:	e8 ec 17 00 00       	call   101abe <memset>
	serial_init();
  1002d2:	e8 bd 02 00 00       	call   100594 <serial_init>
	video_init();
  1002d7:	e8 24 fd ff ff       	call   100000 <video_init>
}
  1002dc:	83 c4 1c             	add    $0x1c,%esp
  1002df:	c3                   	ret    

001002e0 <cons_intr>:

void
cons_intr(int (*proc)(void))
{
  1002e0:	53                   	push   %ebx
  1002e1:	83 ec 08             	sub    $0x8,%esp
  1002e4:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	int c;

	while ((c = (*proc)()) != -1) {
  1002e8:	eb 2b                	jmp    100315 <cons_intr+0x35>
		if (c == 0)
  1002ea:	85 c0                	test   %eax,%eax
  1002ec:	74 27                	je     100315 <cons_intr+0x35>
			continue;
		cons.buf[cons.wpos++] = c;
  1002ee:	8b 0d a4 66 96 01    	mov    0x19666a4,%ecx
  1002f4:	8d 51 01             	lea    0x1(%ecx),%edx
  1002f7:	89 15 a4 66 96 01    	mov    %edx,0x19666a4
  1002fd:	88 81 a0 64 96 01    	mov    %al,0x19664a0(%ecx)
		if (cons.wpos == CONSOLE_BUFFER_SIZE)
  100303:	81 fa 00 02 00 00    	cmp    $0x200,%edx
  100309:	75 0a                	jne    100315 <cons_intr+0x35>
			cons.wpos = 0;
  10030b:	c7 05 a4 66 96 01 00 	movl   $0x0,0x19666a4
  100312:	00 00 00 
void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
  100315:	ff d3                	call   *%ebx
  100317:	83 f8 ff             	cmp    $0xffffffff,%eax
  10031a:	75 ce                	jne    1002ea <cons_intr+0xa>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSOLE_BUFFER_SIZE)
			cons.wpos = 0;
	}
}
  10031c:	83 c4 08             	add    $0x8,%esp
  10031f:	5b                   	pop    %ebx
  100320:	c3                   	ret    

00100321 <cons_getc>:

char
cons_getc(void)
{
  100321:	83 ec 0c             	sub    $0xc,%esp
  int c;

  // poll for any pending input characters,
  // so that this function works even when interrupts are disabled
  // (e.g., when called from the kernel monitor).
  serial_intr();
  100324:	e8 e4 01 00 00       	call   10050d <serial_intr>
  keyboard_intr();
  100329:	e8 41 04 00 00       	call   10076f <keyboard_intr>

  // grab the next character from the input buffer.
  if (cons.rpos != cons.wpos) {
  10032e:	a1 a0 66 96 01       	mov    0x19666a0,%eax
  100333:	3b 05 a4 66 96 01    	cmp    0x19666a4,%eax
  100339:	74 24                	je     10035f <cons_getc+0x3e>
    c = cons.buf[cons.rpos++];
  10033b:	8d 50 01             	lea    0x1(%eax),%edx
  10033e:	89 15 a0 66 96 01    	mov    %edx,0x19666a0
  100344:	0f b6 80 a0 64 96 01 	movzbl 0x19664a0(%eax),%eax
    if (cons.rpos == CONSOLE_BUFFER_SIZE)
  10034b:	81 fa 00 02 00 00    	cmp    $0x200,%edx
  100351:	75 11                	jne    100364 <cons_getc+0x43>
      cons.rpos = 0;
  100353:	c7 05 a0 66 96 01 00 	movl   $0x0,0x19666a0
  10035a:	00 00 00 
  10035d:	eb 05                	jmp    100364 <cons_getc+0x43>
    return c;
  }
  return 0;
  10035f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100364:	83 c4 0c             	add    $0xc,%esp
  100367:	c3                   	ret    

00100368 <cons_putc>:

void
cons_putc(char c)
{
  100368:	53                   	push   %ebx
  100369:	83 ec 14             	sub    $0x14,%esp
	serial_putc(c);
  10036c:	0f be 5c 24 1c       	movsbl 0x1c(%esp),%ebx
  100371:	53                   	push   %ebx
  100372:	e8 b1 01 00 00       	call   100528 <serial_putc>
  video_putc(c);
  100377:	89 1c 24             	mov    %ebx,(%esp)
  10037a:	e8 5c fd ff ff       	call   1000db <video_putc>
}
  10037f:	83 c4 18             	add    $0x18,%esp
  100382:	5b                   	pop    %ebx
  100383:	c3                   	ret    

00100384 <getchar>:

char
getchar(void)
{
  100384:	83 ec 0c             	sub    $0xc,%esp
  char c;

  while ((c = cons_getc()) == 0)
  100387:	e8 95 ff ff ff       	call   100321 <cons_getc>
  10038c:	84 c0                	test   %al,%al
  10038e:	74 f7                	je     100387 <getchar+0x3>
    /* do nothing */;
  return c;
}
  100390:	83 c4 0c             	add    $0xc,%esp
  100393:	c3                   	ret    

00100394 <putchar>:

void
putchar(char c)
{
  100394:	83 ec 18             	sub    $0x18,%esp
  cons_putc(c);
  100397:	0f be 44 24 1c       	movsbl 0x1c(%esp),%eax
  10039c:	50                   	push   %eax
  10039d:	e8 c6 ff ff ff       	call   100368 <cons_putc>
}
  1003a2:	83 c4 1c             	add    $0x1c,%esp
  1003a5:	c3                   	ret    

001003a6 <readline>:

char *
readline(const char *prompt)
{
  1003a6:	56                   	push   %esi
  1003a7:	53                   	push   %ebx
  1003a8:	83 ec 04             	sub    $0x4,%esp
  1003ab:	8b 44 24 10          	mov    0x10(%esp),%eax
  int i;
  char c;

  if (prompt != NULL)
  1003af:	85 c0                	test   %eax,%eax
  1003b1:	74 11                	je     1003c4 <readline+0x1e>
    dprintf("%s", prompt);
  1003b3:	83 ec 08             	sub    $0x8,%esp
  1003b6:	50                   	push   %eax
  1003b7:	68 8e 5a 10 00       	push   $0x105a8e
  1003bc:	e8 4a 1a 00 00       	call   101e0b <dprintf>
  1003c1:	83 c4 10             	add    $0x10,%esp
    } else if ((c == '\b' || c == '\x7f') && i > 0) {
      putchar('\b');
      i--;
    } else if (c >= ' ' && i < BUFLEN-1) {
      putchar(c);
      linebuf[i++] = c;
  1003c4:	be 00 00 00 00       	mov    $0x0,%esi
  if (prompt != NULL)
    dprintf("%s", prompt);

  i = 0;
  while (1) {
    c = getchar();
  1003c9:	e8 b6 ff ff ff       	call   100384 <getchar>
  1003ce:	89 c3                	mov    %eax,%ebx
    if (c < 0) {
  1003d0:	84 c0                	test   %al,%al
  1003d2:	79 1b                	jns    1003ef <readline+0x49>
      dprintf("read error: %e\n", c);
  1003d4:	83 ec 08             	sub    $0x8,%esp
  1003d7:	0f be d8             	movsbl %al,%ebx
  1003da:	53                   	push   %ebx
  1003db:	68 91 5a 10 00       	push   $0x105a91
  1003e0:	e8 26 1a 00 00       	call   101e0b <dprintf>
      return NULL;
  1003e5:	83 c4 10             	add    $0x10,%esp
  1003e8:	b8 00 00 00 00       	mov    $0x0,%eax
  1003ed:	eb 7e                	jmp    10046d <readline+0xc7>
    } else if ((c == '\b' || c == '\x7f') && i > 0) {
  1003ef:	3c 08                	cmp    $0x8,%al
  1003f1:	0f 94 c2             	sete   %dl
  1003f4:	3c 7f                	cmp    $0x7f,%al
  1003f6:	0f 94 c0             	sete   %al
  1003f9:	08 c2                	or     %al,%dl
  1003fb:	74 16                	je     100413 <readline+0x6d>
  1003fd:	85 f6                	test   %esi,%esi
  1003ff:	7e 12                	jle    100413 <readline+0x6d>
      putchar('\b');
  100401:	83 ec 0c             	sub    $0xc,%esp
  100404:	6a 08                	push   $0x8
  100406:	e8 89 ff ff ff       	call   100394 <putchar>
      i--;
  10040b:	83 ee 01             	sub    $0x1,%esi
  10040e:	83 c4 10             	add    $0x10,%esp
  100411:	eb b6                	jmp    1003c9 <readline+0x23>
    } else if (c >= ' ' && i < BUFLEN-1) {
  100413:	80 fb 1f             	cmp    $0x1f,%bl
  100416:	0f 9f c2             	setg   %dl
  100419:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  10041f:	0f 9e c0             	setle  %al
  100422:	84 c2                	test   %al,%dl
  100424:	74 1a                	je     100440 <readline+0x9a>
      putchar(c);
  100426:	83 ec 0c             	sub    $0xc,%esp
  100429:	0f be c3             	movsbl %bl,%eax
  10042c:	50                   	push   %eax
  10042d:	e8 62 ff ff ff       	call   100394 <putchar>
      linebuf[i++] = c;
  100432:	88 9e 00 50 12 00    	mov    %bl,0x125000(%esi)
  100438:	83 c4 10             	add    $0x10,%esp
  10043b:	8d 76 01             	lea    0x1(%esi),%esi
  10043e:	eb 89                	jmp    1003c9 <readline+0x23>
    } else if (c == '\n' || c == '\r') {
  100440:	80 fb 0a             	cmp    $0xa,%bl
  100443:	0f 94 c2             	sete   %dl
  100446:	80 fb 0d             	cmp    $0xd,%bl
  100449:	0f 94 c0             	sete   %al
  10044c:	08 c2                	or     %al,%dl
  10044e:	0f 84 75 ff ff ff    	je     1003c9 <readline+0x23>
      putchar('\n');
  100454:	83 ec 0c             	sub    $0xc,%esp
  100457:	6a 0a                	push   $0xa
  100459:	e8 36 ff ff ff       	call   100394 <putchar>
      linebuf[i] = 0;
  10045e:	c6 86 00 50 12 00 00 	movb   $0x0,0x125000(%esi)
      return linebuf;
  100465:	83 c4 10             	add    $0x10,%esp
  100468:	b8 00 50 12 00       	mov    $0x125000,%eax
    }
  }
}
  10046d:	83 c4 04             	add    $0x4,%esp
  100470:	5b                   	pop    %ebx
  100471:	5e                   	pop    %esi
  100472:	c3                   	ret    

00100473 <serial_proc_data>:
	inb(0x84);
}

static int
serial_proc_data(void)
{
  100473:	83 ec 18             	sub    $0x18,%esp
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
  100476:	68 fd 03 00 00       	push   $0x3fd
  10047b:	e8 b8 21 00 00       	call   102638 <inb>
  100480:	83 c4 10             	add    $0x10,%esp
  100483:	a8 01                	test   $0x1,%al
  100485:	74 15                	je     10049c <serial_proc_data+0x29>
		return -1;
	return inb(COM1+COM_RX);
  100487:	83 ec 0c             	sub    $0xc,%esp
  10048a:	68 f8 03 00 00       	push   $0x3f8
  10048f:	e8 a4 21 00 00       	call   102638 <inb>
  100494:	0f b6 c0             	movzbl %al,%eax
  100497:	83 c4 10             	add    $0x10,%esp
  10049a:	eb 05                	jmp    1004a1 <serial_proc_data+0x2e>

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
  10049c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return inb(COM1+COM_RX);
}
  1004a1:	83 c4 0c             	add    $0xc,%esp
  1004a4:	c3                   	ret    

001004a5 <delay>:
bool serial_exists;

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
  1004a5:	83 ec 18             	sub    $0x18,%esp
	inb(0x84);
  1004a8:	68 84 00 00 00       	push   $0x84
  1004ad:	e8 86 21 00 00       	call   102638 <inb>
	inb(0x84);
  1004b2:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  1004b9:	e8 7a 21 00 00       	call   102638 <inb>
	inb(0x84);
  1004be:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  1004c5:	e8 6e 21 00 00       	call   102638 <inb>
	inb(0x84);
  1004ca:	c7 04 24 84 00 00 00 	movl   $0x84,(%esp)
  1004d1:	e8 62 21 00 00       	call   102638 <inb>
}
  1004d6:	83 c4 1c             	add    $0x1c,%esp
  1004d9:	c3                   	ret    

001004da <serial_reformatnewline>:
	int nl = '\n';
	/* POSIX requires newline on the serial line to
	 * be a CR-LF pair. Without this, you get a malformed output
	 * with clients like minicom or screen
	 */
	if (c == nl) {
  1004da:	83 f8 0a             	cmp    $0xa,%eax
  1004dd:	75 23                	jne    100502 <serial_reformatnewline+0x28>
		cons_intr(serial_proc_data);
}

static int
serial_reformatnewline(int c, int p)
{
  1004df:	53                   	push   %ebx
  1004e0:	83 ec 10             	sub    $0x10,%esp
  1004e3:	89 d3                	mov    %edx,%ebx
	/* POSIX requires newline on the serial line to
	 * be a CR-LF pair. Without this, you get a malformed output
	 * with clients like minicom or screen
	 */
	if (c == nl) {
		outb(p, cr);
  1004e5:	6a 0d                	push   $0xd
  1004e7:	52                   	push   %edx
  1004e8:	e8 63 21 00 00       	call   102650 <outb>
		outb(p, nl);
  1004ed:	83 c4 08             	add    $0x8,%esp
  1004f0:	6a 0a                	push   $0xa
  1004f2:	53                   	push   %ebx
  1004f3:	e8 58 21 00 00       	call   102650 <outb>
		return 1;
  1004f8:	83 c4 10             	add    $0x10,%esp
  1004fb:	b8 01 00 00 00       	mov    $0x1,%eax
  100500:	eb 06                	jmp    100508 <serial_reformatnewline+0x2e>
	}
	else
		return 0;
  100502:	b8 00 00 00 00       	mov    $0x0,%eax
  100507:	c3                   	ret    
}
  100508:	83 c4 08             	add    $0x8,%esp
  10050b:	5b                   	pop    %ebx
  10050c:	c3                   	ret    

0010050d <serial_intr>:
}

void
serial_intr(void)
{
	if (serial_exists)
  10050d:	80 3d a8 66 96 01 00 	cmpb   $0x0,0x19666a8
  100514:	74 10                	je     100526 <serial_intr+0x19>
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
  100516:	83 ec 18             	sub    $0x18,%esp
	if (serial_exists)
		cons_intr(serial_proc_data);
  100519:	68 73 04 10 00       	push   $0x100473
  10051e:	e8 bd fd ff ff       	call   1002e0 <cons_intr>
}
  100523:	83 c4 1c             	add    $0x1c,%esp
  100526:	f3 c3                	repz ret 

00100528 <serial_putc>:
		return 0;
}

void
serial_putc(char c)
{
  100528:	56                   	push   %esi
  100529:	53                   	push   %ebx
  10052a:	83 ec 04             	sub    $0x4,%esp
  10052d:	8b 74 24 10          	mov    0x10(%esp),%esi
	if (!serial_exists)
  100531:	80 3d a8 66 96 01 00 	cmpb   $0x0,0x19666a8
  100538:	74 54                	je     10058e <serial_putc+0x66>
  10053a:	bb 00 00 00 00       	mov    $0x0,%ebx
  10053f:	eb 08                	jmp    100549 <serial_putc+0x21>

	int i;
	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
  100541:	e8 5f ff ff ff       	call   1004a5 <delay>
		return;

	int i;
	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
  100546:	83 c3 01             	add    $0x1,%ebx
	if (!serial_exists)
		return;

	int i;
	for (i = 0;
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  100549:	83 ec 0c             	sub    $0xc,%esp
  10054c:	68 fd 03 00 00       	push   $0x3fd
  100551:	e8 e2 20 00 00       	call   102638 <inb>
{
	if (!serial_exists)
		return;

	int i;
	for (i = 0;
  100556:	83 c4 10             	add    $0x10,%esp
  100559:	a8 20                	test   $0x20,%al
  10055b:	75 08                	jne    100565 <serial_putc+0x3d>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
  10055d:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
  100563:	7e dc                	jle    100541 <serial_putc+0x19>
	     i++)
		delay();

	if (!serial_reformatnewline(c, COM1 + COM_TX))
  100565:	89 f0                	mov    %esi,%eax
  100567:	0f be c0             	movsbl %al,%eax
  10056a:	ba f8 03 00 00       	mov    $0x3f8,%edx
  10056f:	e8 66 ff ff ff       	call   1004da <serial_reformatnewline>
  100574:	85 c0                	test   %eax,%eax
  100576:	75 16                	jne    10058e <serial_putc+0x66>
		outb(COM1 + COM_TX, c);
  100578:	83 ec 08             	sub    $0x8,%esp
  10057b:	89 f0                	mov    %esi,%eax
  10057d:	0f b6 f0             	movzbl %al,%esi
  100580:	56                   	push   %esi
  100581:	68 f8 03 00 00       	push   $0x3f8
  100586:	e8 c5 20 00 00       	call   102650 <outb>
  10058b:	83 c4 10             	add    $0x10,%esp
}
  10058e:	83 c4 04             	add    $0x4,%esp
  100591:	5b                   	pop    %ebx
  100592:	5e                   	pop    %esi
  100593:	c3                   	ret    

00100594 <serial_init>:

void
serial_init(void)
{
  100594:	83 ec 14             	sub    $0x14,%esp
	/* turn off interrupt */
	outb(COM1 + COM_IER, 0);
  100597:	6a 00                	push   $0x0
  100599:	68 f9 03 00 00       	push   $0x3f9
  10059e:	e8 ad 20 00 00       	call   102650 <outb>

	/* set DLAB */
	outb(COM1 + COM_LCR, COM_LCR_DLAB);
  1005a3:	83 c4 08             	add    $0x8,%esp
  1005a6:	68 80 00 00 00       	push   $0x80
  1005ab:	68 fb 03 00 00       	push   $0x3fb
  1005b0:	e8 9b 20 00 00       	call   102650 <outb>

	/* set baud rate */
	outb(COM1 + COM_DLL, 0x0001 & 0xff);
  1005b5:	83 c4 08             	add    $0x8,%esp
  1005b8:	6a 01                	push   $0x1
  1005ba:	68 f8 03 00 00       	push   $0x3f8
  1005bf:	e8 8c 20 00 00       	call   102650 <outb>
	outb(COM1 + COM_DLM, 0x0001 >> 8);
  1005c4:	83 c4 08             	add    $0x8,%esp
  1005c7:	6a 00                	push   $0x0
  1005c9:	68 f9 03 00 00       	push   $0x3f9
  1005ce:	e8 7d 20 00 00       	call   102650 <outb>

	/* Set the line status.  */
	outb(COM1 + COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);
  1005d3:	83 c4 08             	add    $0x8,%esp
  1005d6:	6a 03                	push   $0x3
  1005d8:	68 fb 03 00 00       	push   $0x3fb
  1005dd:	e8 6e 20 00 00       	call   102650 <outb>

	/* Enable the FIFO.  */
	outb(COM1 + COM_FCR, 0xc7);
  1005e2:	83 c4 08             	add    $0x8,%esp
  1005e5:	68 c7 00 00 00       	push   $0xc7
  1005ea:	68 fa 03 00 00       	push   $0x3fa
  1005ef:	e8 5c 20 00 00       	call   102650 <outb>

	/* Turn on DTR, RTS, and OUT2.  */
	outb(COM1 + COM_MCR, 0x0b);
  1005f4:	83 c4 08             	add    $0x8,%esp
  1005f7:	6a 0b                	push   $0xb
  1005f9:	68 fc 03 00 00       	push   $0x3fc
  1005fe:	e8 4d 20 00 00       	call   102650 <outb>

	// Clear any preexisting overrun indications and interrupts
	// Serial COM1 doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
  100603:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
  10060a:	e8 29 20 00 00       	call   102638 <inb>
  10060f:	3c ff                	cmp    $0xff,%al
  100611:	0f 95 05 a8 66 96 01 	setne  0x19666a8
	(void) inb(COM1+COM_IIR);
  100618:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
  10061f:	e8 14 20 00 00       	call   102638 <inb>
	(void) inb(COM1+COM_RX);
  100624:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
  10062b:	e8 08 20 00 00       	call   102638 <inb>
}
  100630:	83 c4 1c             	add    $0x1c,%esp
  100633:	c3                   	ret    

00100634 <serial_intenable>:

void
serial_intenable(void)
{
	if (serial_exists) {
  100634:	80 3d a8 66 96 01 00 	cmpb   $0x0,0x19666a8
  10063b:	74 17                	je     100654 <serial_intenable+0x20>
	(void) inb(COM1+COM_RX);
}

void
serial_intenable(void)
{
  10063d:	83 ec 14             	sub    $0x14,%esp
	if (serial_exists) {
		outb(COM1+COM_IER, 1);
  100640:	6a 01                	push   $0x1
  100642:	68 f9 03 00 00       	push   $0x3f9
  100647:	e8 04 20 00 00       	call   102650 <outb>
		//intr_enable(IRQ_SERIAL13);
		serial_intr();
  10064c:	e8 bc fe ff ff       	call   10050d <serial_intr>
	}
}
  100651:	83 c4 1c             	add    $0x1c,%esp
  100654:	f3 c3                	repz ret 

00100656 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
  100656:	53                   	push   %ebx
  100657:	83 ec 14             	sub    $0x14,%esp
  int c;
  uint8_t data;
  static uint32_t shift;

  if ((inb(KBSTATP) & KBS_DIB) == 0)
  10065a:	6a 64                	push   $0x64
  10065c:	e8 d7 1f 00 00       	call   102638 <inb>
  100661:	83 c4 10             	add    $0x10,%esp
  100664:	a8 01                	test   $0x1,%al
  100666:	0f 84 f1 00 00 00    	je     10075d <kbd_proc_data+0x107>
    return -1;

  data = inb(KBDATAP);
  10066c:	83 ec 0c             	sub    $0xc,%esp
  10066f:	6a 60                	push   $0x60
  100671:	e8 c2 1f 00 00       	call   102638 <inb>

  if (data == 0xE0) {
  100676:	83 c4 10             	add    $0x10,%esp
  100679:	3c e0                	cmp    $0xe0,%al
  10067b:	75 11                	jne    10068e <kbd_proc_data+0x38>
    // E0 escape character
    shift |= E0ESC;
  10067d:	83 0d 00 54 12 00 40 	orl    $0x40,0x125400
    return 0;
  100684:	b8 00 00 00 00       	mov    $0x0,%eax
  100689:	e9 dc 00 00 00       	jmp    10076a <kbd_proc_data+0x114>
  } else if (data & 0x80) {
  10068e:	84 c0                	test   %al,%al
  100690:	79 31                	jns    1006c3 <kbd_proc_data+0x6d>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  100692:	8b 0d 00 54 12 00    	mov    0x125400,%ecx
  100698:	f6 c1 40             	test   $0x40,%cl
  10069b:	75 03                	jne    1006a0 <kbd_proc_data+0x4a>
  10069d:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  1006a0:	0f b6 c0             	movzbl %al,%eax
  1006a3:	0f b6 80 e0 5b 10 00 	movzbl 0x105be0(%eax),%eax
  1006aa:	83 c8 40             	or     $0x40,%eax
  1006ad:	0f b6 c0             	movzbl %al,%eax
  1006b0:	f7 d0                	not    %eax
  1006b2:	21 c8                	and    %ecx,%eax
  1006b4:	a3 00 54 12 00       	mov    %eax,0x125400
    return 0;
  1006b9:	b8 00 00 00 00       	mov    $0x0,%eax
  1006be:	e9 a7 00 00 00       	jmp    10076a <kbd_proc_data+0x114>
  } else if (shift & E0ESC) {
  1006c3:	8b 15 00 54 12 00    	mov    0x125400,%edx
  1006c9:	f6 c2 40             	test   $0x40,%dl
  1006cc:	74 0c                	je     1006da <kbd_proc_data+0x84>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  1006ce:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
  1006d1:	83 e2 bf             	and    $0xffffffbf,%edx
  1006d4:	89 15 00 54 12 00    	mov    %edx,0x125400
  }

  shift |= shiftcode[data];
  1006da:	0f b6 c0             	movzbl %al,%eax
  1006dd:	0f b6 90 e0 5b 10 00 	movzbl 0x105be0(%eax),%edx
  1006e4:	0b 15 00 54 12 00    	or     0x125400,%edx
  shift ^= togglecode[data];
  1006ea:	0f b6 88 e0 5a 10 00 	movzbl 0x105ae0(%eax),%ecx
  1006f1:	31 ca                	xor    %ecx,%edx
  1006f3:	89 15 00 54 12 00    	mov    %edx,0x125400

  c = charcode[shift & (CTL | SHIFT)][data];
  1006f9:	89 d1                	mov    %edx,%ecx
  1006fb:	83 e1 03             	and    $0x3,%ecx
  1006fe:	8b 0c 8d c0 5a 10 00 	mov    0x105ac0(,%ecx,4),%ecx
  100705:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  100709:	0f b6 d8             	movzbl %al,%ebx
  if (shift & CAPSLOCK) {
  10070c:	f6 c2 08             	test   $0x8,%dl
  10070f:	74 1a                	je     10072b <kbd_proc_data+0xd5>
    if ('a' <= c && c <= 'z')
  100711:	89 d8                	mov    %ebx,%eax
  100713:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  100716:	83 f9 19             	cmp    $0x19,%ecx
  100719:	77 05                	ja     100720 <kbd_proc_data+0xca>
      c += 'A' - 'a';
  10071b:	83 eb 20             	sub    $0x20,%ebx
  10071e:	eb 0b                	jmp    10072b <kbd_proc_data+0xd5>
    else if ('A' <= c && c <= 'Z')
  100720:	83 e8 41             	sub    $0x41,%eax
  100723:	83 f8 19             	cmp    $0x19,%eax
  100726:	77 03                	ja     10072b <kbd_proc_data+0xd5>
      c += 'a' - 'A';
  100728:	83 c3 20             	add    $0x20,%ebx
  }

  // Process special keys
  // Ctrl-Alt-Del: reboot
  if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10072b:	f7 d2                	not    %edx
  10072d:	f6 c2 06             	test   $0x6,%dl
  100730:	75 32                	jne    100764 <kbd_proc_data+0x10e>
  100732:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
  100738:	75 2e                	jne    100768 <kbd_proc_data+0x112>
    dprintf("Rebooting!\n");
  10073a:	83 ec 0c             	sub    $0xc,%esp
  10073d:	68 a1 5a 10 00       	push   $0x105aa1
  100742:	e8 c4 16 00 00       	call   101e0b <dprintf>
    outb(0x92, 0x3); // courtesy of Chris Frost
  100747:	83 c4 08             	add    $0x8,%esp
  10074a:	6a 03                	push   $0x3
  10074c:	68 92 00 00 00       	push   $0x92
  100751:	e8 fa 1e 00 00       	call   102650 <outb>
  100756:	83 c4 10             	add    $0x10,%esp
  }

  return c;
  100759:	89 d8                	mov    %ebx,%eax
  10075b:	eb 0d                	jmp    10076a <kbd_proc_data+0x114>
  int c;
  uint8_t data;
  static uint32_t shift;

  if ((inb(KBSTATP) & KBS_DIB) == 0)
    return -1;
  10075d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100762:	eb 06                	jmp    10076a <kbd_proc_data+0x114>
  if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
    dprintf("Rebooting!\n");
    outb(0x92, 0x3); // courtesy of Chris Frost
  }

  return c;
  100764:	89 d8                	mov    %ebx,%eax
  100766:	eb 02                	jmp    10076a <kbd_proc_data+0x114>
  100768:	89 d8                	mov    %ebx,%eax
}
  10076a:	83 c4 08             	add    $0x8,%esp
  10076d:	5b                   	pop    %ebx
  10076e:	c3                   	ret    

0010076f <keyboard_intr>:

void
keyboard_intr(void)
{
  10076f:	83 ec 18             	sub    $0x18,%esp
  cons_intr(kbd_proc_data);
  100772:	68 56 06 10 00       	push   $0x100656
  100777:	e8 64 fb ff ff       	call   1002e0 <cons_intr>
}
  10077c:	83 c4 1c             	add    $0x1c,%esp
  10077f:	c3                   	ret    

00100780 <devinit>:

void intr_init(void);

void
devinit (void)
{
  100780:	83 ec 0c             	sub    $0xc,%esp
	seg_init ();
  100783:	e8 2b 1b 00 00       	call   1022b3 <seg_init>

	cons_init ();
  100788:	e8 31 fb ff ff       	call   1002be <cons_init>
	KERN_DEBUG("cons initialized.\n");
  10078d:	83 ec 04             	sub    $0x4,%esp
  100790:	68 e0 5c 10 00       	push   $0x105ce0
  100795:	6a 13                	push   $0x13
  100797:	68 f3 5c 10 00       	push   $0x105cf3
  10079c:	e8 ed 14 00 00       	call   101c8e <debug_normal>

  	tsc_init();
  1007a1:	e8 46 0d 00 00       	call   1014ec <tsc_init>

	intr_init();
  1007a6:	e8 04 09 00 00       	call   1010af <intr_init>

  	/* enable interrupts */
  	intr_enable (IRQ_TIMER);
  1007ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1007b2:	e8 1c 09 00 00       	call   1010d3 <intr_enable>
  	intr_enable (IRQ_KBD);
  1007b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1007be:	e8 10 09 00 00       	call   1010d3 <intr_enable>
  	intr_enable (IRQ_SERIAL13);
  1007c3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1007ca:	e8 04 09 00 00       	call   1010d3 <intr_enable>

}
  1007cf:	83 c4 1c             	add    $0x1c,%esp
  1007d2:	c3                   	ret    

001007d3 <intr_init_idt>:

	/* check that T_IRQ0 is a multiple of 8 */
	KERN_ASSERT((T_IRQ0 & 7) == 0);

	/* install a default handler */
	for (i = 0; i < sizeof(idt)/sizeof(idt[0]); i++)
  1007d3:	ba 00 00 00 00       	mov    $0x0,%edx
  1007d8:	eb 48                	jmp    100822 <intr_init_idt+0x4f>
		SETGATE(idt[i], 0, CPU_GDT_KCODE, &Xdefault, 0);
  1007da:	b9 ce 17 10 00       	mov    $0x1017ce,%ecx
  1007df:	66 89 0c d5 c0 66 96 	mov    %cx,0x19666c0(,%edx,8)
  1007e6:	01 
  1007e7:	66 c7 04 d5 c2 66 96 	movw   $0x8,0x19666c2(,%edx,8)
  1007ee:	01 08 00 
  1007f1:	c6 04 d5 c4 66 96 01 	movb   $0x0,0x19666c4(,%edx,8)
  1007f8:	00 
  1007f9:	0f b6 04 d5 c5 66 96 	movzbl 0x19666c5(,%edx,8),%eax
  100800:	01 
  100801:	83 e0 f0             	and    $0xfffffff0,%eax
  100804:	83 c8 0e             	or     $0xe,%eax
  100807:	83 e0 8f             	and    $0xffffff8f,%eax
  10080a:	83 c8 80             	or     $0xffffff80,%eax
  10080d:	88 04 d5 c5 66 96 01 	mov    %al,0x19666c5(,%edx,8)
  100814:	c1 e9 10             	shr    $0x10,%ecx
  100817:	66 89 0c d5 c6 66 96 	mov    %cx,0x19666c6(,%edx,8)
  10081e:	01 

	/* check that T_IRQ0 is a multiple of 8 */
	KERN_ASSERT((T_IRQ0 & 7) == 0);

	/* install a default handler */
	for (i = 0; i < sizeof(idt)/sizeof(idt[0]); i++)
  10081f:	83 c2 01             	add    $0x1,%edx
  100822:	81 fa ff 00 00 00    	cmp    $0xff,%edx
  100828:	76 b0                	jbe    1007da <intr_init_idt+0x7>
		SETGATE(idt[i], 0, CPU_GDT_KCODE, &Xdefault, 0);

	SETGATE(idt[T_DIVIDE],            0, CPU_GDT_KCODE, &Xdivide,       0);
  10082a:	ba c0 16 10 00       	mov    $0x1016c0,%edx
  10082f:	66 89 15 c0 66 96 01 	mov    %dx,0x19666c0
  100836:	66 c7 05 c2 66 96 01 	movw   $0x8,0x19666c2
  10083d:	08 00 
  10083f:	c6 05 c4 66 96 01 00 	movb   $0x0,0x19666c4
  100846:	0f b6 05 c5 66 96 01 	movzbl 0x19666c5,%eax
  10084d:	83 e0 f0             	and    $0xfffffff0,%eax
  100850:	83 c8 0e             	or     $0xe,%eax
  100853:	83 e0 8f             	and    $0xffffff8f,%eax
  100856:	83 c8 80             	or     $0xffffff80,%eax
  100859:	a2 c5 66 96 01       	mov    %al,0x19666c5
  10085e:	c1 ea 10             	shr    $0x10,%edx
  100861:	66 89 15 c6 66 96 01 	mov    %dx,0x19666c6
	SETGATE(idt[T_DEBUG],             0, CPU_GDT_KCODE, &Xdebug,        0);
  100868:	ba ca 16 10 00       	mov    $0x1016ca,%edx
  10086d:	66 89 15 c8 66 96 01 	mov    %dx,0x19666c8
  100874:	66 c7 05 ca 66 96 01 	movw   $0x8,0x19666ca
  10087b:	08 00 
  10087d:	c6 05 cc 66 96 01 00 	movb   $0x0,0x19666cc
  100884:	0f b6 05 cd 66 96 01 	movzbl 0x19666cd,%eax
  10088b:	83 e0 f0             	and    $0xfffffff0,%eax
  10088e:	83 c8 0e             	or     $0xe,%eax
  100891:	83 e0 8f             	and    $0xffffff8f,%eax
  100894:	83 c8 80             	or     $0xffffff80,%eax
  100897:	a2 cd 66 96 01       	mov    %al,0x19666cd
  10089c:	c1 ea 10             	shr    $0x10,%edx
  10089f:	66 89 15 ce 66 96 01 	mov    %dx,0x19666ce
	SETGATE(idt[T_NMI],               0, CPU_GDT_KCODE, &Xnmi,          0);
  1008a6:	ba d4 16 10 00       	mov    $0x1016d4,%edx
  1008ab:	66 89 15 d0 66 96 01 	mov    %dx,0x19666d0
  1008b2:	66 c7 05 d2 66 96 01 	movw   $0x8,0x19666d2
  1008b9:	08 00 
  1008bb:	c6 05 d4 66 96 01 00 	movb   $0x0,0x19666d4
  1008c2:	0f b6 05 d5 66 96 01 	movzbl 0x19666d5,%eax
  1008c9:	83 e0 f0             	and    $0xfffffff0,%eax
  1008cc:	83 c8 0e             	or     $0xe,%eax
  1008cf:	83 e0 8f             	and    $0xffffff8f,%eax
  1008d2:	83 c8 80             	or     $0xffffff80,%eax
  1008d5:	a2 d5 66 96 01       	mov    %al,0x19666d5
  1008da:	c1 ea 10             	shr    $0x10,%edx
  1008dd:	66 89 15 d6 66 96 01 	mov    %dx,0x19666d6
	SETGATE(idt[T_BRKPT],             0, CPU_GDT_KCODE, &Xbrkpt,        3);
  1008e4:	ba de 16 10 00       	mov    $0x1016de,%edx
  1008e9:	66 89 15 d8 66 96 01 	mov    %dx,0x19666d8
  1008f0:	66 c7 05 da 66 96 01 	movw   $0x8,0x19666da
  1008f7:	08 00 
  1008f9:	c6 05 dc 66 96 01 00 	movb   $0x0,0x19666dc
  100900:	0f b6 05 dd 66 96 01 	movzbl 0x19666dd,%eax
  100907:	83 e0 f0             	and    $0xfffffff0,%eax
  10090a:	83 c8 0e             	or     $0xe,%eax
  10090d:	83 e0 ef             	and    $0xffffffef,%eax
  100910:	83 c8 e0             	or     $0xffffffe0,%eax
  100913:	a2 dd 66 96 01       	mov    %al,0x19666dd
  100918:	c1 ea 10             	shr    $0x10,%edx
  10091b:	66 89 15 de 66 96 01 	mov    %dx,0x19666de
	SETGATE(idt[T_OFLOW],             0, CPU_GDT_KCODE, &Xoflow,        3);
  100922:	ba e8 16 10 00       	mov    $0x1016e8,%edx
  100927:	66 89 15 e0 66 96 01 	mov    %dx,0x19666e0
  10092e:	66 c7 05 e2 66 96 01 	movw   $0x8,0x19666e2
  100935:	08 00 
  100937:	c6 05 e4 66 96 01 00 	movb   $0x0,0x19666e4
  10093e:	0f b6 05 e5 66 96 01 	movzbl 0x19666e5,%eax
  100945:	83 e0 f0             	and    $0xfffffff0,%eax
  100948:	83 c8 0e             	or     $0xe,%eax
  10094b:	83 e0 ef             	and    $0xffffffef,%eax
  10094e:	83 c8 e0             	or     $0xffffffe0,%eax
  100951:	a2 e5 66 96 01       	mov    %al,0x19666e5
  100956:	c1 ea 10             	shr    $0x10,%edx
  100959:	66 89 15 e6 66 96 01 	mov    %dx,0x19666e6
	SETGATE(idt[T_BOUND],             0, CPU_GDT_KCODE, &Xbound,        0);
  100960:	ba f2 16 10 00       	mov    $0x1016f2,%edx
  100965:	66 89 15 e8 66 96 01 	mov    %dx,0x19666e8
  10096c:	66 c7 05 ea 66 96 01 	movw   $0x8,0x19666ea
  100973:	08 00 
  100975:	c6 05 ec 66 96 01 00 	movb   $0x0,0x19666ec
  10097c:	0f b6 05 ed 66 96 01 	movzbl 0x19666ed,%eax
  100983:	83 e0 f0             	and    $0xfffffff0,%eax
  100986:	83 c8 0e             	or     $0xe,%eax
  100989:	83 e0 8f             	and    $0xffffff8f,%eax
  10098c:	83 c8 80             	or     $0xffffff80,%eax
  10098f:	a2 ed 66 96 01       	mov    %al,0x19666ed
  100994:	c1 ea 10             	shr    $0x10,%edx
  100997:	66 89 15 ee 66 96 01 	mov    %dx,0x19666ee
	SETGATE(idt[T_ILLOP],             0, CPU_GDT_KCODE, &Xillop,        0);
  10099e:	ba fc 16 10 00       	mov    $0x1016fc,%edx
  1009a3:	66 89 15 f0 66 96 01 	mov    %dx,0x19666f0
  1009aa:	66 c7 05 f2 66 96 01 	movw   $0x8,0x19666f2
  1009b1:	08 00 
  1009b3:	c6 05 f4 66 96 01 00 	movb   $0x0,0x19666f4
  1009ba:	0f b6 05 f5 66 96 01 	movzbl 0x19666f5,%eax
  1009c1:	83 e0 f0             	and    $0xfffffff0,%eax
  1009c4:	83 c8 0e             	or     $0xe,%eax
  1009c7:	83 e0 8f             	and    $0xffffff8f,%eax
  1009ca:	83 c8 80             	or     $0xffffff80,%eax
  1009cd:	a2 f5 66 96 01       	mov    %al,0x19666f5
  1009d2:	c1 ea 10             	shr    $0x10,%edx
  1009d5:	66 89 15 f6 66 96 01 	mov    %dx,0x19666f6
	SETGATE(idt[T_DEVICE],            0, CPU_GDT_KCODE, &Xdevice,       0);
  1009dc:	ba 06 17 10 00       	mov    $0x101706,%edx
  1009e1:	66 89 15 f8 66 96 01 	mov    %dx,0x19666f8
  1009e8:	66 c7 05 fa 66 96 01 	movw   $0x8,0x19666fa
  1009ef:	08 00 
  1009f1:	c6 05 fc 66 96 01 00 	movb   $0x0,0x19666fc
  1009f8:	0f b6 05 fd 66 96 01 	movzbl 0x19666fd,%eax
  1009ff:	83 e0 f0             	and    $0xfffffff0,%eax
  100a02:	83 c8 0e             	or     $0xe,%eax
  100a05:	83 e0 8f             	and    $0xffffff8f,%eax
  100a08:	83 c8 80             	or     $0xffffff80,%eax
  100a0b:	a2 fd 66 96 01       	mov    %al,0x19666fd
  100a10:	c1 ea 10             	shr    $0x10,%edx
  100a13:	66 89 15 fe 66 96 01 	mov    %dx,0x19666fe
	SETGATE(idt[T_DBLFLT],            0, CPU_GDT_KCODE, &Xdblflt,       0);
  100a1a:	ba 10 17 10 00       	mov    $0x101710,%edx
  100a1f:	66 89 15 00 67 96 01 	mov    %dx,0x1966700
  100a26:	66 c7 05 02 67 96 01 	movw   $0x8,0x1966702
  100a2d:	08 00 
  100a2f:	c6 05 04 67 96 01 00 	movb   $0x0,0x1966704
  100a36:	0f b6 05 05 67 96 01 	movzbl 0x1966705,%eax
  100a3d:	83 e0 f0             	and    $0xfffffff0,%eax
  100a40:	83 c8 0e             	or     $0xe,%eax
  100a43:	83 e0 8f             	and    $0xffffff8f,%eax
  100a46:	83 c8 80             	or     $0xffffff80,%eax
  100a49:	a2 05 67 96 01       	mov    %al,0x1966705
  100a4e:	c1 ea 10             	shr    $0x10,%edx
  100a51:	66 89 15 06 67 96 01 	mov    %dx,0x1966706
	SETGATE(idt[T_TSS],               0, CPU_GDT_KCODE, &Xtss,          0);
  100a58:	ba 22 17 10 00       	mov    $0x101722,%edx
  100a5d:	66 89 15 10 67 96 01 	mov    %dx,0x1966710
  100a64:	66 c7 05 12 67 96 01 	movw   $0x8,0x1966712
  100a6b:	08 00 
  100a6d:	c6 05 14 67 96 01 00 	movb   $0x0,0x1966714
  100a74:	0f b6 05 15 67 96 01 	movzbl 0x1966715,%eax
  100a7b:	83 e0 f0             	and    $0xfffffff0,%eax
  100a7e:	83 c8 0e             	or     $0xe,%eax
  100a81:	83 e0 8f             	and    $0xffffff8f,%eax
  100a84:	83 c8 80             	or     $0xffffff80,%eax
  100a87:	a2 15 67 96 01       	mov    %al,0x1966715
  100a8c:	c1 ea 10             	shr    $0x10,%edx
  100a8f:	66 89 15 16 67 96 01 	mov    %dx,0x1966716
	SETGATE(idt[T_SEGNP],             0, CPU_GDT_KCODE, &Xsegnp,        0);
  100a96:	ba 2a 17 10 00       	mov    $0x10172a,%edx
  100a9b:	66 89 15 18 67 96 01 	mov    %dx,0x1966718
  100aa2:	66 c7 05 1a 67 96 01 	movw   $0x8,0x196671a
  100aa9:	08 00 
  100aab:	c6 05 1c 67 96 01 00 	movb   $0x0,0x196671c
  100ab2:	0f b6 05 1d 67 96 01 	movzbl 0x196671d,%eax
  100ab9:	83 e0 f0             	and    $0xfffffff0,%eax
  100abc:	83 c8 0e             	or     $0xe,%eax
  100abf:	83 e0 8f             	and    $0xffffff8f,%eax
  100ac2:	83 c8 80             	or     $0xffffff80,%eax
  100ac5:	a2 1d 67 96 01       	mov    %al,0x196671d
  100aca:	c1 ea 10             	shr    $0x10,%edx
  100acd:	66 89 15 1e 67 96 01 	mov    %dx,0x196671e
	SETGATE(idt[T_STACK],             0, CPU_GDT_KCODE, &Xstack,        0);
  100ad4:	ba 32 17 10 00       	mov    $0x101732,%edx
  100ad9:	66 89 15 20 67 96 01 	mov    %dx,0x1966720
  100ae0:	66 c7 05 22 67 96 01 	movw   $0x8,0x1966722
  100ae7:	08 00 
  100ae9:	c6 05 24 67 96 01 00 	movb   $0x0,0x1966724
  100af0:	0f b6 05 25 67 96 01 	movzbl 0x1966725,%eax
  100af7:	83 e0 f0             	and    $0xfffffff0,%eax
  100afa:	83 c8 0e             	or     $0xe,%eax
  100afd:	83 e0 8f             	and    $0xffffff8f,%eax
  100b00:	83 c8 80             	or     $0xffffff80,%eax
  100b03:	a2 25 67 96 01       	mov    %al,0x1966725
  100b08:	c1 ea 10             	shr    $0x10,%edx
  100b0b:	66 89 15 26 67 96 01 	mov    %dx,0x1966726
	SETGATE(idt[T_GPFLT],             0, CPU_GDT_KCODE, &Xgpflt,        0);
  100b12:	ba 3a 17 10 00       	mov    $0x10173a,%edx
  100b17:	66 89 15 28 67 96 01 	mov    %dx,0x1966728
  100b1e:	66 c7 05 2a 67 96 01 	movw   $0x8,0x196672a
  100b25:	08 00 
  100b27:	c6 05 2c 67 96 01 00 	movb   $0x0,0x196672c
  100b2e:	0f b6 05 2d 67 96 01 	movzbl 0x196672d,%eax
  100b35:	83 e0 f0             	and    $0xfffffff0,%eax
  100b38:	83 c8 0e             	or     $0xe,%eax
  100b3b:	83 e0 8f             	and    $0xffffff8f,%eax
  100b3e:	83 c8 80             	or     $0xffffff80,%eax
  100b41:	a2 2d 67 96 01       	mov    %al,0x196672d
  100b46:	c1 ea 10             	shr    $0x10,%edx
  100b49:	66 89 15 2e 67 96 01 	mov    %dx,0x196672e
	SETGATE(idt[T_PGFLT],             0, CPU_GDT_KCODE, &Xpgflt,        0);
  100b50:	ba 42 17 10 00       	mov    $0x101742,%edx
  100b55:	66 89 15 30 67 96 01 	mov    %dx,0x1966730
  100b5c:	66 c7 05 32 67 96 01 	movw   $0x8,0x1966732
  100b63:	08 00 
  100b65:	c6 05 34 67 96 01 00 	movb   $0x0,0x1966734
  100b6c:	0f b6 05 35 67 96 01 	movzbl 0x1966735,%eax
  100b73:	83 e0 f0             	and    $0xfffffff0,%eax
  100b76:	83 c8 0e             	or     $0xe,%eax
  100b79:	83 e0 8f             	and    $0xffffff8f,%eax
  100b7c:	83 c8 80             	or     $0xffffff80,%eax
  100b7f:	a2 35 67 96 01       	mov    %al,0x1966735
  100b84:	c1 ea 10             	shr    $0x10,%edx
  100b87:	66 89 15 36 67 96 01 	mov    %dx,0x1966736
	SETGATE(idt[T_FPERR],             0, CPU_GDT_KCODE, &Xfperr,        0);
  100b8e:	ba 54 17 10 00       	mov    $0x101754,%edx
  100b93:	66 89 15 40 67 96 01 	mov    %dx,0x1966740
  100b9a:	66 c7 05 42 67 96 01 	movw   $0x8,0x1966742
  100ba1:	08 00 
  100ba3:	c6 05 44 67 96 01 00 	movb   $0x0,0x1966744
  100baa:	0f b6 05 45 67 96 01 	movzbl 0x1966745,%eax
  100bb1:	83 e0 f0             	and    $0xfffffff0,%eax
  100bb4:	83 c8 0e             	or     $0xe,%eax
  100bb7:	83 e0 8f             	and    $0xffffff8f,%eax
  100bba:	83 c8 80             	or     $0xffffff80,%eax
  100bbd:	a2 45 67 96 01       	mov    %al,0x1966745
  100bc2:	c1 ea 10             	shr    $0x10,%edx
  100bc5:	66 89 15 46 67 96 01 	mov    %dx,0x1966746
	SETGATE(idt[T_ALIGN],             0, CPU_GDT_KCODE, &Xalign,        0);
  100bcc:	ba 5e 17 10 00       	mov    $0x10175e,%edx
  100bd1:	66 89 15 48 67 96 01 	mov    %dx,0x1966748
  100bd8:	66 c7 05 4a 67 96 01 	movw   $0x8,0x196674a
  100bdf:	08 00 
  100be1:	c6 05 4c 67 96 01 00 	movb   $0x0,0x196674c
  100be8:	0f b6 05 4d 67 96 01 	movzbl 0x196674d,%eax
  100bef:	83 e0 f0             	and    $0xfffffff0,%eax
  100bf2:	83 c8 0e             	or     $0xe,%eax
  100bf5:	83 e0 8f             	and    $0xffffff8f,%eax
  100bf8:	83 c8 80             	or     $0xffffff80,%eax
  100bfb:	a2 4d 67 96 01       	mov    %al,0x196674d
  100c00:	c1 ea 10             	shr    $0x10,%edx
  100c03:	66 89 15 4e 67 96 01 	mov    %dx,0x196674e
	SETGATE(idt[T_MCHK],              0, CPU_GDT_KCODE, &Xmchk,         0);
  100c0a:	ba 62 17 10 00       	mov    $0x101762,%edx
  100c0f:	66 89 15 50 67 96 01 	mov    %dx,0x1966750
  100c16:	66 c7 05 52 67 96 01 	movw   $0x8,0x1966752
  100c1d:	08 00 
  100c1f:	c6 05 54 67 96 01 00 	movb   $0x0,0x1966754
  100c26:	0f b6 05 55 67 96 01 	movzbl 0x1966755,%eax
  100c2d:	83 e0 f0             	and    $0xfffffff0,%eax
  100c30:	83 c8 0e             	or     $0xe,%eax
  100c33:	83 e0 8f             	and    $0xffffff8f,%eax
  100c36:	83 c8 80             	or     $0xffffff80,%eax
  100c39:	a2 55 67 96 01       	mov    %al,0x1966755
  100c3e:	c1 ea 10             	shr    $0x10,%edx
  100c41:	66 89 15 56 67 96 01 	mov    %dx,0x1966756

	SETGATE(idt[T_IRQ0+IRQ_TIMER],    0, CPU_GDT_KCODE, &Xirq_timer,    0);
  100c48:	ba 68 17 10 00       	mov    $0x101768,%edx
  100c4d:	66 89 15 c0 67 96 01 	mov    %dx,0x19667c0
  100c54:	66 c7 05 c2 67 96 01 	movw   $0x8,0x19667c2
  100c5b:	08 00 
  100c5d:	c6 05 c4 67 96 01 00 	movb   $0x0,0x19667c4
  100c64:	0f b6 05 c5 67 96 01 	movzbl 0x19667c5,%eax
  100c6b:	83 e0 f0             	and    $0xfffffff0,%eax
  100c6e:	83 c8 0e             	or     $0xe,%eax
  100c71:	83 e0 8f             	and    $0xffffff8f,%eax
  100c74:	83 c8 80             	or     $0xffffff80,%eax
  100c77:	a2 c5 67 96 01       	mov    %al,0x19667c5
  100c7c:	c1 ea 10             	shr    $0x10,%edx
  100c7f:	66 89 15 c6 67 96 01 	mov    %dx,0x19667c6
	SETGATE(idt[T_IRQ0+IRQ_KBD],      0, CPU_GDT_KCODE, &Xirq_kbd,      0);
  100c86:	ba 6e 17 10 00       	mov    $0x10176e,%edx
  100c8b:	66 89 15 c8 67 96 01 	mov    %dx,0x19667c8
  100c92:	66 c7 05 ca 67 96 01 	movw   $0x8,0x19667ca
  100c99:	08 00 
  100c9b:	c6 05 cc 67 96 01 00 	movb   $0x0,0x19667cc
  100ca2:	0f b6 05 cd 67 96 01 	movzbl 0x19667cd,%eax
  100ca9:	83 e0 f0             	and    $0xfffffff0,%eax
  100cac:	83 c8 0e             	or     $0xe,%eax
  100caf:	83 e0 8f             	and    $0xffffff8f,%eax
  100cb2:	83 c8 80             	or     $0xffffff80,%eax
  100cb5:	a2 cd 67 96 01       	mov    %al,0x19667cd
  100cba:	c1 ea 10             	shr    $0x10,%edx
  100cbd:	66 89 15 ce 67 96 01 	mov    %dx,0x19667ce
	SETGATE(idt[T_IRQ0+IRQ_SLAVE],    0, CPU_GDT_KCODE, &Xirq_slave,    0);
  100cc4:	ba 74 17 10 00       	mov    $0x101774,%edx
  100cc9:	66 89 15 d0 67 96 01 	mov    %dx,0x19667d0
  100cd0:	66 c7 05 d2 67 96 01 	movw   $0x8,0x19667d2
  100cd7:	08 00 
  100cd9:	c6 05 d4 67 96 01 00 	movb   $0x0,0x19667d4
  100ce0:	0f b6 05 d5 67 96 01 	movzbl 0x19667d5,%eax
  100ce7:	83 e0 f0             	and    $0xfffffff0,%eax
  100cea:	83 c8 0e             	or     $0xe,%eax
  100ced:	83 e0 8f             	and    $0xffffff8f,%eax
  100cf0:	83 c8 80             	or     $0xffffff80,%eax
  100cf3:	a2 d5 67 96 01       	mov    %al,0x19667d5
  100cf8:	c1 ea 10             	shr    $0x10,%edx
  100cfb:	66 89 15 d6 67 96 01 	mov    %dx,0x19667d6
	SETGATE(idt[T_IRQ0+IRQ_SERIAL24], 0, CPU_GDT_KCODE, &Xirq_serial2,  0);
  100d02:	ba 7a 17 10 00       	mov    $0x10177a,%edx
  100d07:	66 89 15 d8 67 96 01 	mov    %dx,0x19667d8
  100d0e:	66 c7 05 da 67 96 01 	movw   $0x8,0x19667da
  100d15:	08 00 
  100d17:	c6 05 dc 67 96 01 00 	movb   $0x0,0x19667dc
  100d1e:	0f b6 05 dd 67 96 01 	movzbl 0x19667dd,%eax
  100d25:	83 e0 f0             	and    $0xfffffff0,%eax
  100d28:	83 c8 0e             	or     $0xe,%eax
  100d2b:	83 e0 8f             	and    $0xffffff8f,%eax
  100d2e:	83 c8 80             	or     $0xffffff80,%eax
  100d31:	a2 dd 67 96 01       	mov    %al,0x19667dd
  100d36:	c1 ea 10             	shr    $0x10,%edx
  100d39:	66 89 15 de 67 96 01 	mov    %dx,0x19667de
	SETGATE(idt[T_IRQ0+IRQ_SERIAL13], 0, CPU_GDT_KCODE, &Xirq_serial1,  0);
  100d40:	ba 80 17 10 00       	mov    $0x101780,%edx
  100d45:	66 89 15 e0 67 96 01 	mov    %dx,0x19667e0
  100d4c:	66 c7 05 e2 67 96 01 	movw   $0x8,0x19667e2
  100d53:	08 00 
  100d55:	c6 05 e4 67 96 01 00 	movb   $0x0,0x19667e4
  100d5c:	0f b6 05 e5 67 96 01 	movzbl 0x19667e5,%eax
  100d63:	83 e0 f0             	and    $0xfffffff0,%eax
  100d66:	83 c8 0e             	or     $0xe,%eax
  100d69:	83 e0 8f             	and    $0xffffff8f,%eax
  100d6c:	83 c8 80             	or     $0xffffff80,%eax
  100d6f:	a2 e5 67 96 01       	mov    %al,0x19667e5
  100d74:	c1 ea 10             	shr    $0x10,%edx
  100d77:	66 89 15 e6 67 96 01 	mov    %dx,0x19667e6
	SETGATE(idt[T_IRQ0+IRQ_LPT2],     0, CPU_GDT_KCODE, &Xirq_lpt,      0);
  100d7e:	ba 86 17 10 00       	mov    $0x101786,%edx
  100d83:	66 89 15 e8 67 96 01 	mov    %dx,0x19667e8
  100d8a:	66 c7 05 ea 67 96 01 	movw   $0x8,0x19667ea
  100d91:	08 00 
  100d93:	c6 05 ec 67 96 01 00 	movb   $0x0,0x19667ec
  100d9a:	0f b6 05 ed 67 96 01 	movzbl 0x19667ed,%eax
  100da1:	83 e0 f0             	and    $0xfffffff0,%eax
  100da4:	83 c8 0e             	or     $0xe,%eax
  100da7:	83 e0 8f             	and    $0xffffff8f,%eax
  100daa:	83 c8 80             	or     $0xffffff80,%eax
  100dad:	a2 ed 67 96 01       	mov    %al,0x19667ed
  100db2:	c1 ea 10             	shr    $0x10,%edx
  100db5:	66 89 15 ee 67 96 01 	mov    %dx,0x19667ee
	SETGATE(idt[T_IRQ0+IRQ_FLOPPY],   0, CPU_GDT_KCODE, &Xirq_floppy,   0);
  100dbc:	ba 8c 17 10 00       	mov    $0x10178c,%edx
  100dc1:	66 89 15 f0 67 96 01 	mov    %dx,0x19667f0
  100dc8:	66 c7 05 f2 67 96 01 	movw   $0x8,0x19667f2
  100dcf:	08 00 
  100dd1:	c6 05 f4 67 96 01 00 	movb   $0x0,0x19667f4
  100dd8:	0f b6 05 f5 67 96 01 	movzbl 0x19667f5,%eax
  100ddf:	83 e0 f0             	and    $0xfffffff0,%eax
  100de2:	83 c8 0e             	or     $0xe,%eax
  100de5:	83 e0 8f             	and    $0xffffff8f,%eax
  100de8:	83 c8 80             	or     $0xffffff80,%eax
  100deb:	a2 f5 67 96 01       	mov    %al,0x19667f5
  100df0:	c1 ea 10             	shr    $0x10,%edx
  100df3:	66 89 15 f6 67 96 01 	mov    %dx,0x19667f6
	SETGATE(idt[T_IRQ0+IRQ_SPURIOUS], 0, CPU_GDT_KCODE, &Xirq_spurious, 0);
  100dfa:	ba 92 17 10 00       	mov    $0x101792,%edx
  100dff:	66 89 15 f8 67 96 01 	mov    %dx,0x19667f8
  100e06:	66 c7 05 fa 67 96 01 	movw   $0x8,0x19667fa
  100e0d:	08 00 
  100e0f:	c6 05 fc 67 96 01 00 	movb   $0x0,0x19667fc
  100e16:	0f b6 05 fd 67 96 01 	movzbl 0x19667fd,%eax
  100e1d:	83 e0 f0             	and    $0xfffffff0,%eax
  100e20:	83 c8 0e             	or     $0xe,%eax
  100e23:	83 e0 8f             	and    $0xffffff8f,%eax
  100e26:	83 c8 80             	or     $0xffffff80,%eax
  100e29:	a2 fd 67 96 01       	mov    %al,0x19667fd
  100e2e:	c1 ea 10             	shr    $0x10,%edx
  100e31:	66 89 15 fe 67 96 01 	mov    %dx,0x19667fe
	SETGATE(idt[T_IRQ0+IRQ_RTC],      0, CPU_GDT_KCODE, &Xirq_rtc,      0);
  100e38:	ba 98 17 10 00       	mov    $0x101798,%edx
  100e3d:	66 89 15 00 68 96 01 	mov    %dx,0x1966800
  100e44:	66 c7 05 02 68 96 01 	movw   $0x8,0x1966802
  100e4b:	08 00 
  100e4d:	c6 05 04 68 96 01 00 	movb   $0x0,0x1966804
  100e54:	0f b6 05 05 68 96 01 	movzbl 0x1966805,%eax
  100e5b:	83 e0 f0             	and    $0xfffffff0,%eax
  100e5e:	83 c8 0e             	or     $0xe,%eax
  100e61:	83 e0 8f             	and    $0xffffff8f,%eax
  100e64:	83 c8 80             	or     $0xffffff80,%eax
  100e67:	a2 05 68 96 01       	mov    %al,0x1966805
  100e6c:	c1 ea 10             	shr    $0x10,%edx
  100e6f:	66 89 15 06 68 96 01 	mov    %dx,0x1966806
	SETGATE(idt[T_IRQ0+9],            0, CPU_GDT_KCODE, &Xirq9,         0);
  100e76:	ba 9e 17 10 00       	mov    $0x10179e,%edx
  100e7b:	66 89 15 08 68 96 01 	mov    %dx,0x1966808
  100e82:	66 c7 05 0a 68 96 01 	movw   $0x8,0x196680a
  100e89:	08 00 
  100e8b:	c6 05 0c 68 96 01 00 	movb   $0x0,0x196680c
  100e92:	0f b6 05 0d 68 96 01 	movzbl 0x196680d,%eax
  100e99:	83 e0 f0             	and    $0xfffffff0,%eax
  100e9c:	83 c8 0e             	or     $0xe,%eax
  100e9f:	83 e0 8f             	and    $0xffffff8f,%eax
  100ea2:	83 c8 80             	or     $0xffffff80,%eax
  100ea5:	a2 0d 68 96 01       	mov    %al,0x196680d
  100eaa:	c1 ea 10             	shr    $0x10,%edx
  100ead:	66 89 15 0e 68 96 01 	mov    %dx,0x196680e
	SETGATE(idt[T_IRQ0+10],           0, CPU_GDT_KCODE, &Xirq10,        0);
  100eb4:	ba a4 17 10 00       	mov    $0x1017a4,%edx
  100eb9:	66 89 15 10 68 96 01 	mov    %dx,0x1966810
  100ec0:	66 c7 05 12 68 96 01 	movw   $0x8,0x1966812
  100ec7:	08 00 
  100ec9:	c6 05 14 68 96 01 00 	movb   $0x0,0x1966814
  100ed0:	0f b6 05 15 68 96 01 	movzbl 0x1966815,%eax
  100ed7:	83 e0 f0             	and    $0xfffffff0,%eax
  100eda:	83 c8 0e             	or     $0xe,%eax
  100edd:	83 e0 8f             	and    $0xffffff8f,%eax
  100ee0:	83 c8 80             	or     $0xffffff80,%eax
  100ee3:	a2 15 68 96 01       	mov    %al,0x1966815
  100ee8:	c1 ea 10             	shr    $0x10,%edx
  100eeb:	66 89 15 16 68 96 01 	mov    %dx,0x1966816
	SETGATE(idt[T_IRQ0+11],           0, CPU_GDT_KCODE, &Xirq11,        0);
  100ef2:	b8 aa 17 10 00       	mov    $0x1017aa,%eax
  100ef7:	66 a3 18 68 96 01    	mov    %ax,0x1966818
  100efd:	66 c7 05 1a 68 96 01 	movw   $0x8,0x196681a
  100f04:	08 00 
  100f06:	c6 05 1c 68 96 01 00 	movb   $0x0,0x196681c
  100f0d:	0f b6 05 1d 68 96 01 	movzbl 0x196681d,%eax
  100f14:	83 e0 f0             	and    $0xfffffff0,%eax
  100f17:	83 c8 0e             	or     $0xe,%eax
  100f1a:	83 e0 8e             	and    $0xffffff8e,%eax
  100f1d:	83 c8 80             	or     $0xffffff80,%eax
  100f20:	a2 1d 68 96 01       	mov    %al,0x196681d
  100f25:	b8 aa 17 10 00       	mov    $0x1017aa,%eax
  100f2a:	c1 e8 10             	shr    $0x10,%eax
  100f2d:	66 a3 1e 68 96 01    	mov    %ax,0x196681e
	SETGATE(idt[T_IRQ0+IRQ_MOUSE],    0, CPU_GDT_KCODE, &Xirq_mouse,    0);
  100f33:	ba b0 17 10 00       	mov    $0x1017b0,%edx
  100f38:	66 89 15 20 68 96 01 	mov    %dx,0x1966820
  100f3f:	66 c7 05 22 68 96 01 	movw   $0x8,0x1966822
  100f46:	08 00 
  100f48:	c6 05 24 68 96 01 00 	movb   $0x0,0x1966824
  100f4f:	0f b6 05 25 68 96 01 	movzbl 0x1966825,%eax
  100f56:	83 e0 f0             	and    $0xfffffff0,%eax
  100f59:	83 c8 0e             	or     $0xe,%eax
  100f5c:	83 e0 8f             	and    $0xffffff8f,%eax
  100f5f:	83 c8 80             	or     $0xffffff80,%eax
  100f62:	a2 25 68 96 01       	mov    %al,0x1966825
  100f67:	c1 ea 10             	shr    $0x10,%edx
  100f6a:	66 89 15 26 68 96 01 	mov    %dx,0x1966826
	SETGATE(idt[T_IRQ0+IRQ_COPROCESSOR], 0, CPU_GDT_KCODE, &Xirq_coproc, 0);
  100f71:	ba b6 17 10 00       	mov    $0x1017b6,%edx
  100f76:	66 89 15 28 68 96 01 	mov    %dx,0x1966828
  100f7d:	66 c7 05 2a 68 96 01 	movw   $0x8,0x196682a
  100f84:	08 00 
  100f86:	c6 05 2c 68 96 01 00 	movb   $0x0,0x196682c
  100f8d:	0f b6 05 2d 68 96 01 	movzbl 0x196682d,%eax
  100f94:	83 e0 f0             	and    $0xfffffff0,%eax
  100f97:	83 c8 0e             	or     $0xe,%eax
  100f9a:	83 e0 8f             	and    $0xffffff8f,%eax
  100f9d:	83 c8 80             	or     $0xffffff80,%eax
  100fa0:	a2 2d 68 96 01       	mov    %al,0x196682d
  100fa5:	c1 ea 10             	shr    $0x10,%edx
  100fa8:	66 89 15 2e 68 96 01 	mov    %dx,0x196682e
	SETGATE(idt[T_IRQ0+IRQ_IDE1],     0, CPU_GDT_KCODE, &Xirq_ide1,     0);
  100faf:	ba bc 17 10 00       	mov    $0x1017bc,%edx
  100fb4:	66 89 15 30 68 96 01 	mov    %dx,0x1966830
  100fbb:	66 c7 05 32 68 96 01 	movw   $0x8,0x1966832
  100fc2:	08 00 
  100fc4:	c6 05 34 68 96 01 00 	movb   $0x0,0x1966834
  100fcb:	0f b6 05 35 68 96 01 	movzbl 0x1966835,%eax
  100fd2:	83 e0 f0             	and    $0xfffffff0,%eax
  100fd5:	83 c8 0e             	or     $0xe,%eax
  100fd8:	83 e0 8f             	and    $0xffffff8f,%eax
  100fdb:	83 c8 80             	or     $0xffffff80,%eax
  100fde:	a2 35 68 96 01       	mov    %al,0x1966835
  100fe3:	c1 ea 10             	shr    $0x10,%edx
  100fe6:	66 89 15 36 68 96 01 	mov    %dx,0x1966836
	SETGATE(idt[T_IRQ0+IRQ_IDE2],     0, CPU_GDT_KCODE, &Xirq_ide2,     0);
  100fed:	ba c2 17 10 00       	mov    $0x1017c2,%edx
  100ff2:	66 89 15 38 68 96 01 	mov    %dx,0x1966838
  100ff9:	66 c7 05 3a 68 96 01 	movw   $0x8,0x196683a
  101000:	08 00 
  101002:	c6 05 3c 68 96 01 00 	movb   $0x0,0x196683c
  101009:	0f b6 05 3d 68 96 01 	movzbl 0x196683d,%eax
  101010:	83 e0 f0             	and    $0xfffffff0,%eax
  101013:	83 c8 0e             	or     $0xe,%eax
  101016:	83 e0 8f             	and    $0xffffff8f,%eax
  101019:	83 c8 80             	or     $0xffffff80,%eax
  10101c:	a2 3d 68 96 01       	mov    %al,0x196683d
  101021:	c1 ea 10             	shr    $0x10,%edx
  101024:	66 89 15 3e 68 96 01 	mov    %dx,0x196683e

	// Use DPL=3 here because system calls are explicitly invoked
	// by the user process (with "int $T_SYSCALL").
	SETGATE(idt[T_SYSCALL],           0, CPU_GDT_KCODE, &Xsyscall,      3);
  10102b:	ba c8 17 10 00       	mov    $0x1017c8,%edx
  101030:	66 89 15 40 68 96 01 	mov    %dx,0x1966840
  101037:	66 c7 05 42 68 96 01 	movw   $0x8,0x1966842
  10103e:	08 00 
  101040:	c6 05 44 68 96 01 00 	movb   $0x0,0x1966844
  101047:	0f b6 05 45 68 96 01 	movzbl 0x1966845,%eax
  10104e:	83 e0 f0             	and    $0xfffffff0,%eax
  101051:	83 c8 0e             	or     $0xe,%eax
  101054:	83 e0 ef             	and    $0xffffffef,%eax
  101057:	83 c8 e0             	or     $0xffffffe0,%eax
  10105a:	a2 45 68 96 01       	mov    %al,0x1966845
  10105f:	c1 ea 10             	shr    $0x10,%edx
  101062:	66 89 15 46 68 96 01 	mov    %dx,0x1966846

	/* default */
	SETGATE(idt[T_DEFAULT],           0, CPU_GDT_KCODE, &Xdefault,      0);
  101069:	ba ce 17 10 00       	mov    $0x1017ce,%edx
  10106e:	66 89 15 b0 6e 96 01 	mov    %dx,0x1966eb0
  101075:	66 c7 05 b2 6e 96 01 	movw   $0x8,0x1966eb2
  10107c:	08 00 
  10107e:	c6 05 b4 6e 96 01 00 	movb   $0x0,0x1966eb4
  101085:	0f b6 05 b5 6e 96 01 	movzbl 0x1966eb5,%eax
  10108c:	83 e0 f0             	and    $0xfffffff0,%eax
  10108f:	83 c8 0e             	or     $0xe,%eax
  101092:	83 e0 8f             	and    $0xffffff8f,%eax
  101095:	83 c8 80             	or     $0xffffff80,%eax
  101098:	a2 b5 6e 96 01       	mov    %al,0x1966eb5
  10109d:	c1 ea 10             	shr    $0x10,%edx
  1010a0:	66 89 15 b6 6e 96 01 	mov    %dx,0x1966eb6

	asm volatile("lidt %0" : : "m" (idt_pd));
  1010a7:	0f 01 1d 00 ac 10 00 	lidtl  0x10ac00
  1010ae:	c3                   	ret    

001010af <intr_init>:
}

void
intr_init(void)
{
	if (intr_inited == TRUE)
  1010af:	0f b6 05 04 54 12 00 	movzbl 0x125404,%eax
  1010b6:	3c 01                	cmp    $0x1,%al
  1010b8:	74 17                	je     1010d1 <intr_init+0x22>
	asm volatile("lidt %0" : : "m" (idt_pd));
}

void
intr_init(void)
{
  1010ba:	83 ec 0c             	sub    $0xc,%esp
	if (intr_inited == TRUE)
		return;

  pic_init();
  1010bd:	e8 53 00 00 00       	call   101115 <pic_init>
	intr_init_idt();
  1010c2:	e8 0c f7 ff ff       	call   1007d3 <intr_init_idt>
	intr_inited = TRUE;
  1010c7:	c6 05 04 54 12 00 01 	movb   $0x1,0x125404
}
  1010ce:	83 c4 0c             	add    $0xc,%esp
  1010d1:	f3 c3                	repz ret 

001010d3 <intr_enable>:

void
intr_enable(uint8_t irq)
{
  1010d3:	83 ec 0c             	sub    $0xc,%esp
  1010d6:	8b 44 24 10          	mov    0x10(%esp),%eax
	if (irq >= 16)
  1010da:	3c 0f                	cmp    $0xf,%al
  1010dc:	77 0f                	ja     1010ed <intr_enable+0x1a>
		return;
	pic_enable(irq);
  1010de:	83 ec 0c             	sub    $0xc,%esp
  1010e1:	0f b6 c0             	movzbl %al,%eax
  1010e4:	50                   	push   %eax
  1010e5:	e8 58 01 00 00       	call   101242 <pic_enable>
  1010ea:	83 c4 10             	add    $0x10,%esp
}
  1010ed:	83 c4 0c             	add    $0xc,%esp
  1010f0:	c3                   	ret    

001010f1 <intr_eoi>:

void
intr_eoi(void)
{
  1010f1:	83 ec 0c             	sub    $0xc,%esp
	pic_eoi();
  1010f4:	e8 6d 01 00 00       	call   101266 <pic_eoi>
}
  1010f9:	83 c4 0c             	add    $0xc,%esp
  1010fc:	c3                   	ret    

001010fd <intr_local_enable>:

void
intr_local_enable(void)
{
  1010fd:	83 ec 0c             	sub    $0xc,%esp
	sti();
  101100:	e8 86 14 00 00       	call   10258b <sti>
}
  101105:	83 c4 0c             	add    $0xc,%esp
  101108:	c3                   	ret    

00101109 <intr_local_disable>:

void
intr_local_disable(void)
{
  101109:	83 ec 0c             	sub    $0xc,%esp
	cli();
  10110c:	e8 78 14 00 00       	call   102589 <cli>
}
  101111:	83 c4 0c             	add    $0xc,%esp
  101114:	c3                   	ret    

00101115 <pic_init>:

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	if (pic_inited == TRUE)		// only do once on bootstrap CPU
  101115:	80 3d 05 54 12 00 01 	cmpb   $0x1,0x125405
  10111c:	0f 84 ee 00 00 00    	je     101210 <pic_init+0xfb>
static bool pic_inited = FALSE;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
  101122:	83 ec 14             	sub    $0x14,%esp
	if (pic_inited == TRUE)		// only do once on bootstrap CPU
		return;
	pic_inited = TRUE;
  101125:	c6 05 05 54 12 00 01 	movb   $0x1,0x125405

	/* mask all interrupts */
	outb(IO_PIC1+1, 0xff);
  10112c:	68 ff 00 00 00       	push   $0xff
  101131:	6a 21                	push   $0x21
  101133:	e8 18 15 00 00       	call   102650 <outb>
	outb(IO_PIC2+1, 0xff);
  101138:	83 c4 08             	add    $0x8,%esp
  10113b:	68 ff 00 00 00       	push   $0xff
  101140:	68 a1 00 00 00       	push   $0xa1
  101145:	e8 06 15 00 00       	call   102650 <outb>

	// ICW1:  0001g0hi
	//    g:  0 = edge triggering, 1 = level triggering
	//    h:  0 = cascaded PICs, 1 = master only
	//    i:  0 = no ICW4, 1 = ICW4 required
	outb(IO_PIC1, 0x11);
  10114a:	83 c4 08             	add    $0x8,%esp
  10114d:	6a 11                	push   $0x11
  10114f:	6a 20                	push   $0x20
  101151:	e8 fa 14 00 00       	call   102650 <outb>

	// ICW2:  Vector offset
	outb(IO_PIC1+1, T_IRQ0);
  101156:	83 c4 08             	add    $0x8,%esp
  101159:	6a 20                	push   $0x20
  10115b:	6a 21                	push   $0x21
  10115d:	e8 ee 14 00 00       	call   102650 <outb>

	// ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
	//        3-bit No of IR line at which slave connects to master(slave PIC).
	outb(IO_PIC1+1, 1<<IRQ_SLAVE);
  101162:	83 c4 08             	add    $0x8,%esp
  101165:	6a 04                	push   $0x4
  101167:	6a 21                	push   $0x21
  101169:	e8 e2 14 00 00       	call   102650 <outb>
	//    m:  0 = slave PIC, 1 = master PIC
	//	  (ignored when b is 0, as the master/slave role
	//	  can be hardwired).
	//    a:  1 = Automatic EOI mode
	//    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
	outb(IO_PIC1+1, 0x1);
  10116e:	83 c4 08             	add    $0x8,%esp
  101171:	6a 01                	push   $0x1
  101173:	6a 21                	push   $0x21
  101175:	e8 d6 14 00 00       	call   102650 <outb>

	// Set up slave (8259A-2)
	outb(IO_PIC2, 0x11);			// ICW1
  10117a:	83 c4 08             	add    $0x8,%esp
  10117d:	6a 11                	push   $0x11
  10117f:	68 a0 00 00 00       	push   $0xa0
  101184:	e8 c7 14 00 00       	call   102650 <outb>
	outb(IO_PIC2+1, T_IRQ0 + 8);		// ICW2
  101189:	83 c4 08             	add    $0x8,%esp
  10118c:	6a 28                	push   $0x28
  10118e:	68 a1 00 00 00       	push   $0xa1
  101193:	e8 b8 14 00 00       	call   102650 <outb>
	outb(IO_PIC2+1, IRQ_SLAVE);		// ICW3
  101198:	83 c4 08             	add    $0x8,%esp
  10119b:	6a 02                	push   $0x2
  10119d:	68 a1 00 00 00       	push   $0xa1
  1011a2:	e8 a9 14 00 00       	call   102650 <outb>
	// NB Automatic EOI mode doesn't tend to work on the slave.
	// Linux source code says it's "to be investigated".
	outb(IO_PIC2+1, 0x01);			// ICW4
  1011a7:	83 c4 08             	add    $0x8,%esp
  1011aa:	6a 01                	push   $0x1
  1011ac:	68 a1 00 00 00       	push   $0xa1
  1011b1:	e8 9a 14 00 00       	call   102650 <outb>

	// OCW3:  0ef01prs
	//   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
	//    p:  0 = no polling, 1 = polling mode
	//   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
	outb(IO_PIC1, 0x68);             /* clear specific mask */
  1011b6:	83 c4 08             	add    $0x8,%esp
  1011b9:	6a 68                	push   $0x68
  1011bb:	6a 20                	push   $0x20
  1011bd:	e8 8e 14 00 00       	call   102650 <outb>
	outb(IO_PIC1, 0x0a);             /* read IRR by default */
  1011c2:	83 c4 08             	add    $0x8,%esp
  1011c5:	6a 0a                	push   $0xa
  1011c7:	6a 20                	push   $0x20
  1011c9:	e8 82 14 00 00       	call   102650 <outb>

	outb(IO_PIC2, 0x68);               /* OCW3 */
  1011ce:	83 c4 08             	add    $0x8,%esp
  1011d1:	6a 68                	push   $0x68
  1011d3:	68 a0 00 00 00       	push   $0xa0
  1011d8:	e8 73 14 00 00       	call   102650 <outb>
	outb(IO_PIC2, 0x0a);               /* OCW3 */
  1011dd:	83 c4 08             	add    $0x8,%esp
  1011e0:	6a 0a                	push   $0xa
  1011e2:	68 a0 00 00 00       	push   $0xa0
  1011e7:	e8 64 14 00 00       	call   102650 <outb>

	// mask all interrupts
	outb(IO_PIC1+1, 0xFF);
  1011ec:	83 c4 08             	add    $0x8,%esp
  1011ef:	68 ff 00 00 00       	push   $0xff
  1011f4:	6a 21                	push   $0x21
  1011f6:	e8 55 14 00 00       	call   102650 <outb>
	outb(IO_PIC2+1, 0xFF);
  1011fb:	83 c4 08             	add    $0x8,%esp
  1011fe:	68 ff 00 00 00       	push   $0xff
  101203:	68 a1 00 00 00       	push   $0xa1
  101208:	e8 43 14 00 00       	call   102650 <outb>
}
  10120d:	83 c4 1c             	add    $0x1c,%esp
  101210:	f3 c3                	repz ret 

00101212 <pic_setmask>:

void
pic_setmask(uint16_t mask)
{
  101212:	53                   	push   %ebx
  101213:	83 ec 10             	sub    $0x10,%esp
  101216:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	irqmask = mask;
  10121a:	66 89 1d 06 ac 10 00 	mov    %bx,0x10ac06
	outb(IO_PIC1+1, (char)mask);
  101221:	0f b6 c3             	movzbl %bl,%eax
  101224:	50                   	push   %eax
  101225:	6a 21                	push   $0x21
  101227:	e8 24 14 00 00       	call   102650 <outb>
	outb(IO_PIC2+1, (char)(mask >> 8));
  10122c:	83 c4 08             	add    $0x8,%esp
  10122f:	0f b6 df             	movzbl %bh,%ebx
  101232:	53                   	push   %ebx
  101233:	68 a1 00 00 00       	push   $0xa1
  101238:	e8 13 14 00 00       	call   102650 <outb>
}
  10123d:	83 c4 18             	add    $0x18,%esp
  101240:	5b                   	pop    %ebx
  101241:	c3                   	ret    

00101242 <pic_enable>:

void
pic_enable(int irq)
{
  101242:	83 ec 18             	sub    $0x18,%esp
	pic_setmask(irqmask & ~(1 << irq));
  101245:	b8 01 00 00 00       	mov    $0x1,%eax
  10124a:	8b 4c 24 1c          	mov    0x1c(%esp),%ecx
  10124e:	d3 e0                	shl    %cl,%eax
  101250:	f7 d0                	not    %eax
  101252:	66 23 05 06 ac 10 00 	and    0x10ac06,%ax
  101259:	0f b7 c0             	movzwl %ax,%eax
  10125c:	50                   	push   %eax
  10125d:	e8 b0 ff ff ff       	call   101212 <pic_setmask>
}
  101262:	83 c4 1c             	add    $0x1c,%esp
  101265:	c3                   	ret    

00101266 <pic_eoi>:

void
pic_eoi(void)
{
  101266:	83 ec 14             	sub    $0x14,%esp
	// OCW2: rse00xxx
	//   r: rotate
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
  101269:	6a 20                	push   $0x20
  10126b:	6a 20                	push   $0x20
  10126d:	e8 de 13 00 00       	call   102650 <outb>
	outb(IO_PIC2, 0x20);
  101272:	83 c4 08             	add    $0x8,%esp
  101275:	6a 20                	push   $0x20
  101277:	68 a0 00 00 00       	push   $0xa0
  10127c:	e8 cf 13 00 00       	call   102650 <outb>
}
  101281:	83 c4 1c             	add    $0x1c,%esp
  101284:	c3                   	ret    

00101285 <pic_reset>:

void
pic_reset(void)
{
  101285:	83 ec 14             	sub    $0x14,%esp
	// mask all interrupts
	outb(IO_PIC1+1, 0x00);
  101288:	6a 00                	push   $0x0
  10128a:	6a 21                	push   $0x21
  10128c:	e8 bf 13 00 00       	call   102650 <outb>
	outb(IO_PIC2+1, 0x00);
  101291:	83 c4 08             	add    $0x8,%esp
  101294:	6a 00                	push   $0x0
  101296:	68 a1 00 00 00       	push   $0xa1
  10129b:	e8 b0 13 00 00       	call   102650 <outb>

	// ICW1:  0001g0hi
	//    g:  0 = edge triggering, 1 = level triggering
	//    h:  0 = cascaded PICs, 1 = master only
	//    i:  0 = no ICW4, 1 = ICW4 required
	outb(IO_PIC1, 0x11);
  1012a0:	83 c4 08             	add    $0x8,%esp
  1012a3:	6a 11                	push   $0x11
  1012a5:	6a 20                	push   $0x20
  1012a7:	e8 a4 13 00 00       	call   102650 <outb>

	// ICW2:  Vector offset
	outb(IO_PIC1+1, T_IRQ0);
  1012ac:	83 c4 08             	add    $0x8,%esp
  1012af:	6a 20                	push   $0x20
  1012b1:	6a 21                	push   $0x21
  1012b3:	e8 98 13 00 00       	call   102650 <outb>

	// ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
	//        3-bit No of IR line at which slave connects to master(slave PIC).
	outb(IO_PIC1+1, 1<<IRQ_SLAVE);
  1012b8:	83 c4 08             	add    $0x8,%esp
  1012bb:	6a 04                	push   $0x4
  1012bd:	6a 21                	push   $0x21
  1012bf:	e8 8c 13 00 00       	call   102650 <outb>
	//    m:  0 = slave PIC, 1 = master PIC
	//	  (ignored when b is 0, as the master/slave role
	//	  can be hardwired).
	//    a:  1 = Automatic EOI mode
	//    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
	outb(IO_PIC1+1, 0x3);
  1012c4:	83 c4 08             	add    $0x8,%esp
  1012c7:	6a 03                	push   $0x3
  1012c9:	6a 21                	push   $0x21
  1012cb:	e8 80 13 00 00       	call   102650 <outb>

	// Set up slave (8259A-2)
	outb(IO_PIC2, 0x11);			// ICW1
  1012d0:	83 c4 08             	add    $0x8,%esp
  1012d3:	6a 11                	push   $0x11
  1012d5:	68 a0 00 00 00       	push   $0xa0
  1012da:	e8 71 13 00 00       	call   102650 <outb>
	outb(IO_PIC2+1, T_IRQ0 + 8);		// ICW2
  1012df:	83 c4 08             	add    $0x8,%esp
  1012e2:	6a 28                	push   $0x28
  1012e4:	68 a1 00 00 00       	push   $0xa1
  1012e9:	e8 62 13 00 00       	call   102650 <outb>
	outb(IO_PIC2+1, IRQ_SLAVE);		// ICW3
  1012ee:	83 c4 08             	add    $0x8,%esp
  1012f1:	6a 02                	push   $0x2
  1012f3:	68 a1 00 00 00       	push   $0xa1
  1012f8:	e8 53 13 00 00       	call   102650 <outb>
	// NB Automatic EOI mode doesn't tend to work on the slave.
	// Linux source code says it's "to be investigated".
	outb(IO_PIC2+1, 0x01);			// ICW4
  1012fd:	83 c4 08             	add    $0x8,%esp
  101300:	6a 01                	push   $0x1
  101302:	68 a1 00 00 00       	push   $0xa1
  101307:	e8 44 13 00 00       	call   102650 <outb>

	// OCW3:  0ef01prs
	//   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
	//    p:  0 = no polling, 1 = polling mode
	//   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
	outb(IO_PIC1, 0x68);             /* clear specific mask */
  10130c:	83 c4 08             	add    $0x8,%esp
  10130f:	6a 68                	push   $0x68
  101311:	6a 20                	push   $0x20
  101313:	e8 38 13 00 00       	call   102650 <outb>
	outb(IO_PIC1, 0x0a);             /* read IRR by default */
  101318:	83 c4 08             	add    $0x8,%esp
  10131b:	6a 0a                	push   $0xa
  10131d:	6a 20                	push   $0x20
  10131f:	e8 2c 13 00 00       	call   102650 <outb>

	outb(IO_PIC2, 0x68);               /* OCW3 */
  101324:	83 c4 08             	add    $0x8,%esp
  101327:	6a 68                	push   $0x68
  101329:	68 a0 00 00 00       	push   $0xa0
  10132e:	e8 1d 13 00 00       	call   102650 <outb>
	outb(IO_PIC2, 0x0a);               /* OCW3 */
  101333:	83 c4 08             	add    $0x8,%esp
  101336:	6a 0a                	push   $0xa
  101338:	68 a0 00 00 00       	push   $0xa0
  10133d:	e8 0e 13 00 00       	call   102650 <outb>
}
  101342:	83 c4 1c             	add    $0x1c,%esp
  101345:	c3                   	ret    

00101346 <timer_hw_init>:

// Initialize the programmable interval timer.

void
timer_hw_init(void)
{
  101346:	83 ec 14             	sub    $0x14,%esp
	outb(PIT_CONTROL, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  101349:	6a 34                	push   $0x34
  10134b:	6a 43                	push   $0x43
  10134d:	e8 fe 12 00 00       	call   102650 <outb>
	outb(PIT_CHANNEL0, LOW8(LATCH));
  101352:	83 c4 08             	add    $0x8,%esp
  101355:	68 9c 00 00 00       	push   $0x9c
  10135a:	6a 40                	push   $0x40
  10135c:	e8 ef 12 00 00       	call   102650 <outb>
	outb(PIT_CHANNEL0, HIGH8(LATCH));
  101361:	83 c4 08             	add    $0x8,%esp
  101364:	6a 2e                	push   $0x2e
  101366:	6a 40                	push   $0x40
  101368:	e8 e3 12 00 00       	call   102650 <outb>
}
  10136d:	83 c4 1c             	add    $0x1c,%esp
  101370:	c3                   	ret    

00101371 <tsc_calibrate>:
/*
 * XXX: From Linux 3.2.6: arch/x86/kernel/tsc.c: pit_calibrate_tsc()
 */
static uint64_t
tsc_calibrate(uint32_t latch, uint32_t ms, int loopmin)
{
  101371:	55                   	push   %ebp
  101372:	57                   	push   %edi
  101373:	56                   	push   %esi
  101374:	53                   	push   %ebx
  101375:	83 ec 38             	sub    $0x38,%esp
  101378:	89 c3                	mov    %eax,%ebx
  10137a:	89 54 24 28          	mov    %edx,0x28(%esp)
  10137e:	89 cd                	mov    %ecx,%ebp
	uint64_t tsc, t1, t2, delta, tscmin, tscmax;;
	int pitcnt;

	/* Set the Gate high, disable speaker */
	outb(0x61, (inb(0x61) & ~0x02) | 0x01);
  101380:	6a 61                	push   $0x61
  101382:	e8 b1 12 00 00       	call   102638 <inb>
  101387:	83 c4 08             	add    $0x8,%esp
  10138a:	83 e0 fc             	and    $0xfffffffc,%eax
  10138d:	83 c8 01             	or     $0x1,%eax
  101390:	0f b6 c0             	movzbl %al,%eax
  101393:	50                   	push   %eax
  101394:	6a 61                	push   $0x61
  101396:	e8 b5 12 00 00       	call   102650 <outb>
	/*
	 * Setup CTC channel 2 for mode 0, (interrupt on terminal
	 * count mode), binary count. Set the latch register to 50ms
	 * (LSB then MSB) to begin countdown.
	 */
	outb(0x43, 0xb0);
  10139b:	83 c4 08             	add    $0x8,%esp
  10139e:	68 b0 00 00 00       	push   $0xb0
  1013a3:	6a 43                	push   $0x43
  1013a5:	e8 a6 12 00 00       	call   102650 <outb>
	outb(0x42, latch & 0xff);
  1013aa:	83 c4 08             	add    $0x8,%esp
  1013ad:	0f b6 c3             	movzbl %bl,%eax
  1013b0:	50                   	push   %eax
  1013b1:	6a 42                	push   $0x42
  1013b3:	e8 98 12 00 00       	call   102650 <outb>
	outb(0x42, latch >> 8);
  1013b8:	83 c4 08             	add    $0x8,%esp
  1013bb:	0f b6 df             	movzbl %bh,%ebx
  1013be:	53                   	push   %ebx
  1013bf:	6a 42                	push   $0x42
  1013c1:	e8 8a 12 00 00       	call   102650 <outb>

	tsc = t1 = t2 = rdtsc();
  1013c6:	e8 db 11 00 00       	call   1025a6 <rdtsc>
  1013cb:	89 44 24 20          	mov    %eax,0x20(%esp)
  1013cf:	89 54 24 24          	mov    %edx,0x24(%esp)

	pitcnt = 0;
	tscmax = 0;
	tscmin = ~(uint64_t) 0x0;
	while ((inb(0x61) & 0x20) == 0) {
  1013d3:	83 c4 10             	add    $0x10,%esp
	 */
	outb(0x43, 0xb0);
	outb(0x42, latch & 0xff);
	outb(0x42, latch >> 8);

	tsc = t1 = t2 = rdtsc();
  1013d6:	89 c6                	mov    %eax,%esi
  1013d8:	89 d7                	mov    %edx,%edi

	pitcnt = 0;
  1013da:	bb 00 00 00 00       	mov    $0x0,%ebx
	tscmax = 0;
  1013df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1013e6:	00 
  1013e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1013ee:	00 
	tscmin = ~(uint64_t) 0x0;
  1013ef:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  1013f6:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
  1013fd:	ff 
  1013fe:	89 5c 24 18          	mov    %ebx,0x18(%esp)
	while ((inb(0x61) & 0x20) == 0) {
  101402:	eb 4c                	jmp    101450 <tsc_calibrate+0xdf>
		t2 = rdtsc();
  101404:	e8 9d 11 00 00       	call   1025a6 <rdtsc>
		delta = t2 - tsc;
  101409:	89 c1                	mov    %eax,%ecx
  10140b:	89 d3                	mov    %edx,%ebx
  10140d:	29 f1                	sub    %esi,%ecx
  10140f:	19 fb                	sbb    %edi,%ebx
  101411:	89 ce                	mov    %ecx,%esi
  101413:	89 df                	mov    %ebx,%edi
		tsc = t2;
		if (delta < tscmin)
  101415:	8b 0c 24             	mov    (%esp),%ecx
  101418:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  10141c:	39 fb                	cmp    %edi,%ebx
  10141e:	77 06                	ja     101426 <tsc_calibrate+0xb5>
  101420:	72 0b                	jb     10142d <tsc_calibrate+0xbc>
  101422:	39 f1                	cmp    %esi,%ecx
  101424:	76 07                	jbe    10142d <tsc_calibrate+0xbc>
			tscmin = delta;
  101426:	89 34 24             	mov    %esi,(%esp)
  101429:	89 7c 24 04          	mov    %edi,0x4(%esp)
		if (delta > tscmax)
  10142d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  101431:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  101435:	39 fb                	cmp    %edi,%ebx
  101437:	72 06                	jb     10143f <tsc_calibrate+0xce>
  101439:	77 0c                	ja     101447 <tsc_calibrate+0xd6>
  10143b:	39 f1                	cmp    %esi,%ecx
  10143d:	73 08                	jae    101447 <tsc_calibrate+0xd6>
			tscmax = delta;
  10143f:	89 74 24 08          	mov    %esi,0x8(%esp)
  101443:	89 7c 24 0c          	mov    %edi,0xc(%esp)
		pitcnt++;
  101447:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
	tscmax = 0;
	tscmin = ~(uint64_t) 0x0;
	while ((inb(0x61) & 0x20) == 0) {
		t2 = rdtsc();
		delta = t2 - tsc;
		tsc = t2;
  10144c:	89 c6                	mov    %eax,%esi
  10144e:	89 d7                	mov    %edx,%edi
	tsc = t1 = t2 = rdtsc();

	pitcnt = 0;
	tscmax = 0;
	tscmin = ~(uint64_t) 0x0;
	while ((inb(0x61) & 0x20) == 0) {
  101450:	83 ec 0c             	sub    $0xc,%esp
  101453:	6a 61                	push   $0x61
  101455:	e8 de 11 00 00       	call   102638 <inb>
  10145a:	83 c4 10             	add    $0x10,%esp
  10145d:	a8 20                	test   $0x20,%al
  10145f:	74 a3                	je     101404 <tsc_calibrate+0x93>
  101461:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	 * times, then we have been hit by a massive SMI
	 *
	 * If the maximum is 10 times larger than the minimum,
	 * then we got hit by an SMI as well.
	 */
	KERN_DEBUG("pitcnt=%u, tscmin=%llu, tscmax=%llu\n",
  101465:	ff 74 24 0c          	pushl  0xc(%esp)
  101469:	ff 74 24 0c          	pushl  0xc(%esp)
  10146d:	ff 74 24 0c          	pushl  0xc(%esp)
  101471:	ff 74 24 0c          	pushl  0xc(%esp)
  101475:	53                   	push   %ebx
  101476:	68 08 5d 10 00       	push   $0x105d08
  10147b:	6a 3a                	push   $0x3a
  10147d:	68 2d 5d 10 00       	push   $0x105d2d
  101482:	e8 07 08 00 00       	call   101c8e <debug_normal>
		   pitcnt, tscmin, tscmax);
	if (pitcnt < loopmin || tscmax > 10 * tscmin)
  101487:	83 c4 20             	add    $0x20,%esp
  10148a:	39 eb                	cmp    %ebp,%ebx
  10148c:	7c 40                	jl     1014ce <tsc_calibrate+0x15d>
  10148e:	6b 4c 24 04 0a       	imul   $0xa,0x4(%esp),%ecx
  101493:	b8 0a 00 00 00       	mov    $0xa,%eax
  101498:	f7 24 24             	mull   (%esp)
  10149b:	01 ca                	add    %ecx,%edx
  10149d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  1014a1:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  1014a5:	39 d3                	cmp    %edx,%ebx
  1014a7:	77 31                	ja     1014da <tsc_calibrate+0x169>
  1014a9:	72 04                	jb     1014af <tsc_calibrate+0x13e>
  1014ab:	39 c1                	cmp    %eax,%ecx
  1014ad:	77 2b                	ja     1014da <tsc_calibrate+0x169>
		return ~(uint64_t) 0x0;

	/* Calculate the PIT value */
	delta = t2 - t1;
  1014af:	2b 74 24 10          	sub    0x10(%esp),%esi
  1014b3:	1b 7c 24 14          	sbb    0x14(%esp),%edi
	return delta / ms;
  1014b7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  1014bb:	ba 00 00 00 00       	mov    $0x0,%edx
  1014c0:	52                   	push   %edx
  1014c1:	50                   	push   %eax
  1014c2:	57                   	push   %edi
  1014c3:	56                   	push   %esi
  1014c4:	e8 17 43 00 00       	call   1057e0 <__udivdi3>
  1014c9:	83 c4 10             	add    $0x10,%esp
  1014cc:	eb 16                	jmp    1014e4 <tsc_calibrate+0x173>
	 * then we got hit by an SMI as well.
	 */
	KERN_DEBUG("pitcnt=%u, tscmin=%llu, tscmax=%llu\n",
		   pitcnt, tscmin, tscmax);
	if (pitcnt < loopmin || tscmax > 10 * tscmin)
		return ~(uint64_t) 0x0;
  1014ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014d3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1014d8:	eb 0a                	jmp    1014e4 <tsc_calibrate+0x173>
  1014da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014df:	ba ff ff ff ff       	mov    $0xffffffff,%edx

	/* Calculate the PIT value */
	delta = t2 - t1;
	return delta / ms;
}
  1014e4:	83 c4 2c             	add    $0x2c,%esp
  1014e7:	5b                   	pop    %ebx
  1014e8:	5e                   	pop    %esi
  1014e9:	5f                   	pop    %edi
  1014ea:	5d                   	pop    %ebp
  1014eb:	c3                   	ret    

001014ec <tsc_init>:

int
tsc_init(void)
{
  1014ec:	57                   	push   %edi
  1014ed:	56                   	push   %esi
  1014ee:	53                   	push   %ebx
	uint64_t ret;
	int i;

	timer_hw_init();
  1014ef:	e8 52 fe ff ff       	call   101346 <timer_hw_init>

	tsc_per_ms = 0;
  1014f4:	c7 05 c0 6e 96 01 00 	movl   $0x0,0x1966ec0
  1014fb:	00 00 00 
  1014fe:	c7 05 c4 6e 96 01 00 	movl   $0x0,0x1966ec4
  101505:	00 00 00 

	/*
	 * XXX: If TSC calibration fails frequently, try to increase the
	 *      upperbound of loop condition, e.g. alternating 3 to 10.
	 */
	for (i = 0; i < 10; i++) {
  101508:	bb 00 00 00 00       	mov    $0x0,%ebx
  10150d:	eb 3a                	jmp    101549 <tsc_init+0x5d>
		ret = tsc_calibrate(CAL_LATCH, CAL_MS, CAL_PIT_LOOPS);
  10150f:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  101514:	ba 0a 00 00 00       	mov    $0xa,%edx
  101519:	b8 9b 2e 00 00       	mov    $0x2e9b,%eax
  10151e:	e8 4e fe ff ff       	call   101371 <tsc_calibrate>
  101523:	89 c6                	mov    %eax,%esi
  101525:	89 d7                	mov    %edx,%edi
		if (ret != ~(uint64_t) 0x0)
  101527:	f7 d2                	not    %edx
  101529:	89 f0                	mov    %esi,%eax
  10152b:	f7 d0                	not    %eax
  10152d:	09 c2                	or     %eax,%edx
  10152f:	75 1d                	jne    10154e <tsc_init+0x62>
			break;
		KERN_DEBUG("[%d] Retry to calibrate TSC.\n", i+1);
  101531:	83 c3 01             	add    $0x1,%ebx
  101534:	53                   	push   %ebx
  101535:	68 3c 5d 10 00       	push   $0x105d3c
  10153a:	6a 55                	push   $0x55
  10153c:	68 2d 5d 10 00       	push   $0x105d2d
  101541:	e8 48 07 00 00       	call   101c8e <debug_normal>
  101546:	83 c4 10             	add    $0x10,%esp

	/*
	 * XXX: If TSC calibration fails frequently, try to increase the
	 *      upperbound of loop condition, e.g. alternating 3 to 10.
	 */
	for (i = 0; i < 10; i++) {
  101549:	83 fb 09             	cmp    $0x9,%ebx
  10154c:	7e c1                	jle    10150f <tsc_init+0x23>
		if (ret != ~(uint64_t) 0x0)
			break;
		KERN_DEBUG("[%d] Retry to calibrate TSC.\n", i+1);
	}

	if (ret == ~(uint64_t) 0x0) {
  10154e:	89 f2                	mov    %esi,%edx
  101550:	f7 d2                	not    %edx
  101552:	89 f8                	mov    %edi,%eax
  101554:	f7 d0                	not    %eax
  101556:	09 d0                	or     %edx,%eax
  101558:	75 4b                	jne    1015a5 <tsc_init+0xb9>
		KERN_DEBUG("TSC calibration failed.\n");
  10155a:	83 ec 04             	sub    $0x4,%esp
  10155d:	68 5a 5d 10 00       	push   $0x105d5a
  101562:	6a 59                	push   $0x59
  101564:	68 2d 5d 10 00       	push   $0x105d2d
  101569:	e8 20 07 00 00       	call   101c8e <debug_normal>
		KERN_DEBUG("Assume TSC freq = 1 GHz.\n");
  10156e:	83 c4 0c             	add    $0xc,%esp
  101571:	68 73 5d 10 00       	push   $0x105d73
  101576:	6a 5a                	push   $0x5a
  101578:	68 2d 5d 10 00       	push   $0x105d2d
  10157d:	e8 0c 07 00 00       	call   101c8e <debug_normal>
		tsc_per_ms = 1000000;
  101582:	c7 05 c0 6e 96 01 40 	movl   $0xf4240,0x1966ec0
  101589:	42 0f 00 
  10158c:	c7 05 c4 6e 96 01 00 	movl   $0x0,0x1966ec4
  101593:	00 00 00 

		timer_hw_init();
  101596:	e8 ab fd ff ff       	call   101346 <timer_hw_init>
		return 1;
  10159b:	83 c4 10             	add    $0x10,%esp
  10159e:	b8 01 00 00 00       	mov    $0x1,%eax
  1015a3:	eb 49                	jmp    1015ee <tsc_init+0x102>
	} else {
		tsc_per_ms = ret;
  1015a5:	89 35 c0 6e 96 01    	mov    %esi,0x1966ec0
  1015ab:	89 3d c4 6e 96 01    	mov    %edi,0x1966ec4
		KERN_DEBUG("TSC freq = %llu Hz.\n", tsc_per_ms*1000);
  1015b1:	a1 c0 6e 96 01       	mov    0x1966ec0,%eax
  1015b6:	8b 15 c4 6e 96 01    	mov    0x1966ec4,%edx
  1015bc:	83 ec 0c             	sub    $0xc,%esp
  1015bf:	69 ca e8 03 00 00    	imul   $0x3e8,%edx,%ecx
  1015c5:	ba e8 03 00 00       	mov    $0x3e8,%edx
  1015ca:	f7 e2                	mul    %edx
  1015cc:	01 ca                	add    %ecx,%edx
  1015ce:	52                   	push   %edx
  1015cf:	50                   	push   %eax
  1015d0:	68 8d 5d 10 00       	push   $0x105d8d
  1015d5:	6a 61                	push   $0x61
  1015d7:	68 2d 5d 10 00       	push   $0x105d2d
  1015dc:	e8 ad 06 00 00       	call   101c8e <debug_normal>

		timer_hw_init();
  1015e1:	83 c4 20             	add    $0x20,%esp
  1015e4:	e8 5d fd ff ff       	call   101346 <timer_hw_init>
		return 0;
  1015e9:	b8 00 00 00 00       	mov    $0x0,%eax
	}
}
  1015ee:	5b                   	pop    %ebx
  1015ef:	5e                   	pop    %esi
  1015f0:	5f                   	pop    %edi
  1015f1:	c3                   	ret    

001015f2 <delay>:
/*
 * Wait for ms millisecond.
 */
void
delay(uint32_t ms)
{
  1015f2:	57                   	push   %edi
  1015f3:	56                   	push   %esi
  1015f4:	53                   	push   %ebx
  1015f5:	83 ec 10             	sub    $0x10,%esp
  1015f8:	8b 44 24 20          	mov    0x20(%esp),%eax
	volatile uint64_t ticks = tsc_per_ms * ms;
  1015fc:	8b 0d c0 6e 96 01    	mov    0x1966ec0,%ecx
  101602:	8b 1d c4 6e 96 01    	mov    0x1966ec4,%ebx
  101608:	0f af d8             	imul   %eax,%ebx
  10160b:	f7 e1                	mul    %ecx
  10160d:	01 da                	add    %ebx,%edx
  10160f:	89 44 24 08          	mov    %eax,0x8(%esp)
  101613:	89 54 24 0c          	mov    %edx,0xc(%esp)
	volatile uint64_t start = rdtsc();
  101617:	e8 8a 0f 00 00       	call   1025a6 <rdtsc>
  10161c:	89 04 24             	mov    %eax,(%esp)
  10161f:	89 54 24 04          	mov    %edx,0x4(%esp)
	while (rdtsc() < start + ticks);
  101623:	e8 7e 0f 00 00       	call   1025a6 <rdtsc>
  101628:	8b 34 24             	mov    (%esp),%esi
  10162b:	8b 7c 24 04          	mov    0x4(%esp),%edi
  10162f:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  101633:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  101637:	01 f1                	add    %esi,%ecx
  101639:	11 fb                	adc    %edi,%ebx
  10163b:	39 da                	cmp    %ebx,%edx
  10163d:	72 e4                	jb     101623 <delay+0x31>
  10163f:	77 04                	ja     101645 <delay+0x53>
  101641:	39 c8                	cmp    %ecx,%eax
  101643:	72 de                	jb     101623 <delay+0x31>
}
  101645:	83 c4 10             	add    $0x10,%esp
  101648:	5b                   	pop    %ebx
  101649:	5e                   	pop    %esi
  10164a:	5f                   	pop    %edi
  10164b:	c3                   	ret    

0010164c <udelay>:
/*
 * Wait for us microsecond.
 */
void
udelay(uint32_t us)
{
  10164c:	57                   	push   %edi
  10164d:	56                   	push   %esi
  10164e:	53                   	push   %ebx
  10164f:	83 ec 10             	sub    $0x10,%esp
  101652:	8b 5c 24 20          	mov    0x20(%esp),%ebx
    volatile uint64_t ticks = tsc_per_ms / 1000 * us;
  101656:	a1 c0 6e 96 01       	mov    0x1966ec0,%eax
  10165b:	8b 15 c4 6e 96 01    	mov    0x1966ec4,%edx
  101661:	6a 00                	push   $0x0
  101663:	68 e8 03 00 00       	push   $0x3e8
  101668:	52                   	push   %edx
  101669:	50                   	push   %eax
  10166a:	e8 71 41 00 00       	call   1057e0 <__udivdi3>
  10166f:	83 c4 10             	add    $0x10,%esp
  101672:	89 d1                	mov    %edx,%ecx
  101674:	0f af cb             	imul   %ebx,%ecx
  101677:	f7 e3                	mul    %ebx
  101679:	01 ca                	add    %ecx,%edx
  10167b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10167f:	89 54 24 0c          	mov    %edx,0xc(%esp)
    volatile uint64_t start = rdtsc();
  101683:	e8 1e 0f 00 00       	call   1025a6 <rdtsc>
  101688:	89 04 24             	mov    %eax,(%esp)
  10168b:	89 54 24 04          	mov    %edx,0x4(%esp)
    while (rdtsc() < start + ticks);
  10168f:	e8 12 0f 00 00       	call   1025a6 <rdtsc>
  101694:	8b 34 24             	mov    (%esp),%esi
  101697:	8b 7c 24 04          	mov    0x4(%esp),%edi
  10169b:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  10169f:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  1016a3:	01 f1                	add    %esi,%ecx
  1016a5:	11 fb                	adc    %edi,%ebx
  1016a7:	39 da                	cmp    %ebx,%edx
  1016a9:	72 e4                	jb     10168f <udelay+0x43>
  1016ab:	77 04                	ja     1016b1 <udelay+0x65>
  1016ad:	39 c8                	cmp    %ecx,%eax
  1016af:	72 de                	jb     10168f <udelay+0x43>
}
  1016b1:	83 c4 10             	add    $0x10,%esp
  1016b4:	5b                   	pop    %ebx
  1016b5:	5e                   	pop    %esi
  1016b6:	5f                   	pop    %edi
  1016b7:	c3                   	ret    
  1016b8:	66 90                	xchg   %ax,%ax
  1016ba:	66 90                	xchg   %ax,%ax
  1016bc:	66 90                	xchg   %ax,%ax
  1016be:	66 90                	xchg   %ax,%ax

001016c0 <Xdivide>:
	jmp _alltraps

.text

/* exceptions  */
TRAPHANDLER_NOEC(Xdivide,	T_DIVIDE)
  1016c0:	6a 00                	push   $0x0
  1016c2:	6a 00                	push   $0x0
  1016c4:	e9 17 01 00 00       	jmp    1017e0 <_alltraps>
  1016c9:	90                   	nop

001016ca <Xdebug>:
TRAPHANDLER_NOEC(Xdebug,	T_DEBUG)
  1016ca:	6a 00                	push   $0x0
  1016cc:	6a 01                	push   $0x1
  1016ce:	e9 0d 01 00 00       	jmp    1017e0 <_alltraps>
  1016d3:	90                   	nop

001016d4 <Xnmi>:
TRAPHANDLER_NOEC(Xnmi,		T_NMI)
  1016d4:	6a 00                	push   $0x0
  1016d6:	6a 02                	push   $0x2
  1016d8:	e9 03 01 00 00       	jmp    1017e0 <_alltraps>
  1016dd:	90                   	nop

001016de <Xbrkpt>:
TRAPHANDLER_NOEC(Xbrkpt,	T_BRKPT)
  1016de:	6a 00                	push   $0x0
  1016e0:	6a 03                	push   $0x3
  1016e2:	e9 f9 00 00 00       	jmp    1017e0 <_alltraps>
  1016e7:	90                   	nop

001016e8 <Xoflow>:
TRAPHANDLER_NOEC(Xoflow,	T_OFLOW)
  1016e8:	6a 00                	push   $0x0
  1016ea:	6a 04                	push   $0x4
  1016ec:	e9 ef 00 00 00       	jmp    1017e0 <_alltraps>
  1016f1:	90                   	nop

001016f2 <Xbound>:
TRAPHANDLER_NOEC(Xbound,	T_BOUND)
  1016f2:	6a 00                	push   $0x0
  1016f4:	6a 05                	push   $0x5
  1016f6:	e9 e5 00 00 00       	jmp    1017e0 <_alltraps>
  1016fb:	90                   	nop

001016fc <Xillop>:
TRAPHANDLER_NOEC(Xillop,	T_ILLOP)
  1016fc:	6a 00                	push   $0x0
  1016fe:	6a 06                	push   $0x6
  101700:	e9 db 00 00 00       	jmp    1017e0 <_alltraps>
  101705:	90                   	nop

00101706 <Xdevice>:
TRAPHANDLER_NOEC(Xdevice,	T_DEVICE)
  101706:	6a 00                	push   $0x0
  101708:	6a 07                	push   $0x7
  10170a:	e9 d1 00 00 00       	jmp    1017e0 <_alltraps>
  10170f:	90                   	nop

00101710 <Xdblflt>:
TRAPHANDLER     (Xdblflt,	T_DBLFLT)
  101710:	6a 08                	push   $0x8
  101712:	e9 c9 00 00 00       	jmp    1017e0 <_alltraps>
  101717:	90                   	nop

00101718 <Xcoproc>:
TRAPHANDLER_NOEC(Xcoproc,	T_COPROC)
  101718:	6a 00                	push   $0x0
  10171a:	6a 09                	push   $0x9
  10171c:	e9 bf 00 00 00       	jmp    1017e0 <_alltraps>
  101721:	90                   	nop

00101722 <Xtss>:
TRAPHANDLER     (Xtss,		T_TSS)
  101722:	6a 0a                	push   $0xa
  101724:	e9 b7 00 00 00       	jmp    1017e0 <_alltraps>
  101729:	90                   	nop

0010172a <Xsegnp>:
TRAPHANDLER     (Xsegnp,	T_SEGNP)
  10172a:	6a 0b                	push   $0xb
  10172c:	e9 af 00 00 00       	jmp    1017e0 <_alltraps>
  101731:	90                   	nop

00101732 <Xstack>:
TRAPHANDLER     (Xstack,	T_STACK)
  101732:	6a 0c                	push   $0xc
  101734:	e9 a7 00 00 00       	jmp    1017e0 <_alltraps>
  101739:	90                   	nop

0010173a <Xgpflt>:
TRAPHANDLER     (Xgpflt,	T_GPFLT)
  10173a:	6a 0d                	push   $0xd
  10173c:	e9 9f 00 00 00       	jmp    1017e0 <_alltraps>
  101741:	90                   	nop

00101742 <Xpgflt>:
TRAPHANDLER     (Xpgflt,	T_PGFLT)
  101742:	6a 0e                	push   $0xe
  101744:	e9 97 00 00 00       	jmp    1017e0 <_alltraps>
  101749:	90                   	nop

0010174a <Xres>:
TRAPHANDLER_NOEC(Xres,		T_RES)
  10174a:	6a 00                	push   $0x0
  10174c:	6a 0f                	push   $0xf
  10174e:	e9 8d 00 00 00       	jmp    1017e0 <_alltraps>
  101753:	90                   	nop

00101754 <Xfperr>:
TRAPHANDLER_NOEC(Xfperr,	T_FPERR)
  101754:	6a 00                	push   $0x0
  101756:	6a 10                	push   $0x10
  101758:	e9 83 00 00 00       	jmp    1017e0 <_alltraps>
  10175d:	90                   	nop

0010175e <Xalign>:
TRAPHANDLER     (Xalign,	T_ALIGN)
  10175e:	6a 11                	push   $0x11
  101760:	eb 7e                	jmp    1017e0 <_alltraps>

00101762 <Xmchk>:
TRAPHANDLER_NOEC(Xmchk,		T_MCHK)
  101762:	6a 00                	push   $0x0
  101764:	6a 12                	push   $0x12
  101766:	eb 78                	jmp    1017e0 <_alltraps>

00101768 <Xirq_timer>:

/* ISA interrupts  */
TRAPHANDLER_NOEC(Xirq_timer,	T_IRQ0 + IRQ_TIMER)
  101768:	6a 00                	push   $0x0
  10176a:	6a 20                	push   $0x20
  10176c:	eb 72                	jmp    1017e0 <_alltraps>

0010176e <Xirq_kbd>:
TRAPHANDLER_NOEC(Xirq_kbd,	T_IRQ0 + IRQ_KBD)
  10176e:	6a 00                	push   $0x0
  101770:	6a 21                	push   $0x21
  101772:	eb 6c                	jmp    1017e0 <_alltraps>

00101774 <Xirq_slave>:
TRAPHANDLER_NOEC(Xirq_slave,	T_IRQ0 + IRQ_SLAVE)
  101774:	6a 00                	push   $0x0
  101776:	6a 22                	push   $0x22
  101778:	eb 66                	jmp    1017e0 <_alltraps>

0010177a <Xirq_serial2>:
TRAPHANDLER_NOEC(Xirq_serial2,	T_IRQ0 + IRQ_SERIAL24)
  10177a:	6a 00                	push   $0x0
  10177c:	6a 23                	push   $0x23
  10177e:	eb 60                	jmp    1017e0 <_alltraps>

00101780 <Xirq_serial1>:
TRAPHANDLER_NOEC(Xirq_serial1,	T_IRQ0 + IRQ_SERIAL13)
  101780:	6a 00                	push   $0x0
  101782:	6a 24                	push   $0x24
  101784:	eb 5a                	jmp    1017e0 <_alltraps>

00101786 <Xirq_lpt>:
TRAPHANDLER_NOEC(Xirq_lpt,	T_IRQ0 + IRQ_LPT2)
  101786:	6a 00                	push   $0x0
  101788:	6a 25                	push   $0x25
  10178a:	eb 54                	jmp    1017e0 <_alltraps>

0010178c <Xirq_floppy>:
TRAPHANDLER_NOEC(Xirq_floppy,	T_IRQ0 + IRQ_FLOPPY)
  10178c:	6a 00                	push   $0x0
  10178e:	6a 26                	push   $0x26
  101790:	eb 4e                	jmp    1017e0 <_alltraps>

00101792 <Xirq_spurious>:
TRAPHANDLER_NOEC(Xirq_spurious,	T_IRQ0 + IRQ_SPURIOUS)
  101792:	6a 00                	push   $0x0
  101794:	6a 27                	push   $0x27
  101796:	eb 48                	jmp    1017e0 <_alltraps>

00101798 <Xirq_rtc>:
TRAPHANDLER_NOEC(Xirq_rtc,	T_IRQ0 + IRQ_RTC)
  101798:	6a 00                	push   $0x0
  10179a:	6a 28                	push   $0x28
  10179c:	eb 42                	jmp    1017e0 <_alltraps>

0010179e <Xirq9>:
TRAPHANDLER_NOEC(Xirq9,		T_IRQ0 + 9)
  10179e:	6a 00                	push   $0x0
  1017a0:	6a 29                	push   $0x29
  1017a2:	eb 3c                	jmp    1017e0 <_alltraps>

001017a4 <Xirq10>:
TRAPHANDLER_NOEC(Xirq10,	T_IRQ0 + 10)
  1017a4:	6a 00                	push   $0x0
  1017a6:	6a 2a                	push   $0x2a
  1017a8:	eb 36                	jmp    1017e0 <_alltraps>

001017aa <Xirq11>:
TRAPHANDLER_NOEC(Xirq11,	T_IRQ0 + 11)
  1017aa:	6a 00                	push   $0x0
  1017ac:	6a 2b                	push   $0x2b
  1017ae:	eb 30                	jmp    1017e0 <_alltraps>

001017b0 <Xirq_mouse>:
TRAPHANDLER_NOEC(Xirq_mouse,	T_IRQ0 + IRQ_MOUSE)
  1017b0:	6a 00                	push   $0x0
  1017b2:	6a 2c                	push   $0x2c
  1017b4:	eb 2a                	jmp    1017e0 <_alltraps>

001017b6 <Xirq_coproc>:
TRAPHANDLER_NOEC(Xirq_coproc,	T_IRQ0 + IRQ_COPROCESSOR)
  1017b6:	6a 00                	push   $0x0
  1017b8:	6a 2d                	push   $0x2d
  1017ba:	eb 24                	jmp    1017e0 <_alltraps>

001017bc <Xirq_ide1>:
TRAPHANDLER_NOEC(Xirq_ide1,	T_IRQ0 + IRQ_IDE1)
  1017bc:	6a 00                	push   $0x0
  1017be:	6a 2e                	push   $0x2e
  1017c0:	eb 1e                	jmp    1017e0 <_alltraps>

001017c2 <Xirq_ide2>:
TRAPHANDLER_NOEC(Xirq_ide2,	T_IRQ0 + IRQ_IDE2)
  1017c2:	6a 00                	push   $0x0
  1017c4:	6a 2f                	push   $0x2f
  1017c6:	eb 18                	jmp    1017e0 <_alltraps>

001017c8 <Xsyscall>:

/* syscall */
TRAPHANDLER_NOEC(Xsyscall,	T_SYSCALL)
  1017c8:	6a 00                	push   $0x0
  1017ca:	6a 30                	push   $0x30
  1017cc:	eb 12                	jmp    1017e0 <_alltraps>

001017ce <Xdefault>:

/* default */
TRAPHANDLER     (Xdefault,	T_DEFAULT)
  1017ce:	68 fe 00 00 00       	push   $0xfe
  1017d3:	eb 0b                	jmp    1017e0 <_alltraps>
  1017d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1017d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001017e0 <_alltraps>:

.globl	_alltraps
.type	_alltraps,@function
.p2align 4, 0x90		/* 16-byte alignment, nop filled */
_alltraps:
	cli			# make sure there is no nested trap
  1017e0:	fa                   	cli    

	cld
  1017e1:	fc                   	cld    

	# -------------
	# build context
	# -------------
	
	pushl %ds		
  1017e2:	1e                   	push   %ds
	pushl %es
  1017e3:	06                   	push   %es
	pushal
  1017e4:	60                   	pusha  

	# -------------

	movl $CPU_GDT_KDATA,%eax # load kernel's data segment
  1017e5:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax,%ds
  1017ea:	8e d8                	mov    %eax,%ds
	movw %ax,%es
  1017ec:	8e c0                	mov    %eax,%es

	pushl %esp		# pass pointer to this trapframe
  1017ee:	54                   	push   %esp
	call trap		# and call trap (does not return)
  1017ef:	e8 5c 3f 00 00       	call   105750 <trap>

1:	hlt			# should never get here; just spin...
  1017f4:	f4                   	hlt    
  1017f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1017f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101800 <trap_return>:
/* Function definition: trap_return(tf_t * user_context); */
.globl	trap_return
.type	trap_return,@function
.p2align 4, 0x90		/* 16-byte alignment, nop filled */
trap_return:
    movl	4(%esp),%eax
  101800:	8b 44 24 04          	mov    0x4(%esp),%eax
    movl    %eax, %esp
  101804:	89 c4                	mov    %eax,%esp
    popal
  101806:	61                   	popa   
    addl	$16,%esp                # skips ds, es, trapno and errno
  101807:	83 c4 10             	add    $0x10,%esp
  10180a:	cf                   	iret   

0010180b <pmmap_merge>:
  }
}

static void
pmmap_merge(pmmap_list_type *pmmap_list_p)
{
  10180b:	56                   	push   %esi
  10180c:	53                   	push   %ebx
  10180d:	83 ec 14             	sub    $0x14,%esp
  101810:	89 c6                	mov    %eax,%esi
	struct pmmap *slot, *next_slot;
	struct pmmap *last_slot[4] = { NULL, NULL, NULL, NULL };
  101812:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  101819:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101820:	00 
  101821:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101828:	00 
  101829:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  101830:	00 
	int sublist_nr;

	/*
	 * Step 1: Merge overlaped entries in pmmap_list.
	 */
	SLIST_FOREACH(slot, pmmap_list_p, next) {
  101831:	8b 18                	mov    (%eax),%ebx
  101833:	eb 3a                	jmp    10186f <pmmap_merge+0x64>
		if ((next_slot = SLIST_NEXT(slot, next)) == NULL)
  101835:	8b 43 0c             	mov    0xc(%ebx),%eax
  101838:	85 c0                	test   %eax,%eax
  10183a:	74 37                	je     101873 <pmmap_merge+0x68>
			break;
		if (slot->start <= next_slot->start &&
  10183c:	8b 10                	mov    (%eax),%edx
  10183e:	39 13                	cmp    %edx,(%ebx)
  101840:	77 2a                	ja     10186c <pmmap_merge+0x61>
		    slot->end >= next_slot->start &&
  101842:	8b 4b 04             	mov    0x4(%ebx),%ecx
	 * Step 1: Merge overlaped entries in pmmap_list.
	 */
	SLIST_FOREACH(slot, pmmap_list_p, next) {
		if ((next_slot = SLIST_NEXT(slot, next)) == NULL)
			break;
		if (slot->start <= next_slot->start &&
  101845:	39 ca                	cmp    %ecx,%edx
  101847:	77 23                	ja     10186c <pmmap_merge+0x61>
		    slot->end >= next_slot->start &&
  101849:	8b 50 08             	mov    0x8(%eax),%edx
  10184c:	39 53 08             	cmp    %edx,0x8(%ebx)
  10184f:	75 1b                	jne    10186c <pmmap_merge+0x61>
		    slot->type == next_slot->type) {
			slot->end = max(slot->end, next_slot->end);
  101851:	83 ec 08             	sub    $0x8,%esp
  101854:	ff 70 04             	pushl  0x4(%eax)
  101857:	51                   	push   %ecx
  101858:	e8 dc 0c 00 00       	call   102539 <max>
  10185d:	89 43 04             	mov    %eax,0x4(%ebx)
			SLIST_REMOVE_AFTER(slot, next);
  101860:	8b 43 0c             	mov    0xc(%ebx),%eax
  101863:	8b 40 0c             	mov    0xc(%eax),%eax
  101866:	89 43 0c             	mov    %eax,0xc(%ebx)
  101869:	83 c4 10             	add    $0x10,%esp
	int sublist_nr;

	/*
	 * Step 1: Merge overlaped entries in pmmap_list.
	 */
	SLIST_FOREACH(slot, pmmap_list_p, next) {
  10186c:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  10186f:	85 db                	test   %ebx,%ebx
  101871:	75 c2                	jne    101835 <pmmap_merge+0x2a>

	/*
	 * Step 2: Create the specfic lists: pmmap_usable, pmmap_resv,
	 *         pmmap_acpi, pmmap_nvs.
	 */
	SLIST_FOREACH(slot, pmmap_list_p, next) {
  101873:	8b 1e                	mov    (%esi),%ebx
  101875:	eb 7f                	jmp    1018f6 <pmmap_merge+0xeb>
		sublist_nr = PMMAP_SUBLIST_NR(slot->type); //get memory type number
  101877:	8b 43 08             	mov    0x8(%ebx),%eax
  10187a:	83 f8 01             	cmp    $0x1,%eax
  10187d:	74 16                	je     101895 <pmmap_merge+0x8a>
  10187f:	83 f8 02             	cmp    $0x2,%eax
  101882:	74 18                	je     10189c <pmmap_merge+0x91>
  101884:	83 f8 03             	cmp    $0x3,%eax
  101887:	74 1a                	je     1018a3 <pmmap_merge+0x98>
  101889:	83 f8 04             	cmp    $0x4,%eax
  10188c:	75 1c                	jne    1018aa <pmmap_merge+0x9f>
  10188e:	be 03 00 00 00       	mov    $0x3,%esi
  101893:	eb 1a                	jmp    1018af <pmmap_merge+0xa4>
  101895:	be 00 00 00 00       	mov    $0x0,%esi
  10189a:	eb 13                	jmp    1018af <pmmap_merge+0xa4>
  10189c:	be 01 00 00 00       	mov    $0x1,%esi
  1018a1:	eb 0c                	jmp    1018af <pmmap_merge+0xa4>
  1018a3:	be 02 00 00 00       	mov    $0x2,%esi
  1018a8:	eb 05                	jmp    1018af <pmmap_merge+0xa4>
  1018aa:	be ff ff ff ff       	mov    $0xffffffff,%esi
    	KERN_ASSERT(sublist_nr != -1);
  1018af:	83 fe ff             	cmp    $0xffffffff,%esi
  1018b2:	75 19                	jne    1018cd <pmmap_merge+0xc2>
  1018b4:	68 a2 5d 10 00       	push   $0x105da2
  1018b9:	68 b3 5d 10 00       	push   $0x105db3
  1018be:	6a 63                	push   $0x63
  1018c0:	68 d0 5d 10 00       	push   $0x105dd0
  1018c5:	e8 ee 03 00 00       	call   101cb8 <debug_panic>
  1018ca:	83 c4 10             	add    $0x10,%esp
		if (last_slot[sublist_nr] != NULL)
  1018cd:	8b 04 b4             	mov    (%esp,%esi,4),%eax
  1018d0:	85 c0                	test   %eax,%eax
  1018d2:	74 0b                	je     1018df <pmmap_merge+0xd4>
			SLIST_INSERT_AFTER(last_slot[sublist_nr], slot,
  1018d4:	8b 50 10             	mov    0x10(%eax),%edx
  1018d7:	89 53 10             	mov    %edx,0x10(%ebx)
  1018da:	89 58 10             	mov    %ebx,0x10(%eax)
  1018dd:	eb 11                	jmp    1018f0 <pmmap_merge+0xe5>
					   type_next);
		else
			SLIST_INSERT_HEAD(&pmmap_sublist[sublist_nr], slot,
  1018df:	8b 04 b5 20 54 12 00 	mov    0x125420(,%esi,4),%eax
  1018e6:	89 43 10             	mov    %eax,0x10(%ebx)
  1018e9:	89 1c b5 20 54 12 00 	mov    %ebx,0x125420(,%esi,4)
					  type_next);
		last_slot[sublist_nr] = slot;
  1018f0:	89 1c b4             	mov    %ebx,(%esp,%esi,4)

	/*
	 * Step 2: Create the specfic lists: pmmap_usable, pmmap_resv,
	 *         pmmap_acpi, pmmap_nvs.
	 */
	SLIST_FOREACH(slot, pmmap_list_p, next) {
  1018f3:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  1018f6:	85 db                	test   %ebx,%ebx
  1018f8:	0f 85 79 ff ff ff    	jne    101877 <pmmap_merge+0x6c>
			SLIST_INSERT_HEAD(&pmmap_sublist[sublist_nr], slot,
					  type_next);
		last_slot[sublist_nr] = slot;
	}

}
  1018fe:	83 c4 14             	add    $0x14,%esp
  101901:	5b                   	pop    %ebx
  101902:	5e                   	pop    %esi
  101903:	c3                   	ret    

00101904 <pmmap_alloc_slot>:
	 ((type) == MEM_NVS) ? PMMAP_NVS : -1)

struct pmmap *
pmmap_alloc_slot(void)
{
	if (unlikely(pmmap_slots_next_free == 128))
  101904:	a1 40 5e 12 00       	mov    0x125e40,%eax
  101909:	3d 80 00 00 00       	cmp    $0x80,%eax
  10190e:	74 19                	je     101929 <pmmap_alloc_slot+0x25>
		return NULL;
	return &pmmap_slots[pmmap_slots_next_free++];
  101910:	8d 50 01             	lea    0x1(%eax),%edx
  101913:	89 15 40 5e 12 00    	mov    %edx,0x125e40
  101919:	8d 14 80             	lea    (%eax,%eax,4),%edx
  10191c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  101923:	05 40 54 12 00       	add    $0x125440,%eax
  101928:	c3                   	ret    

struct pmmap *
pmmap_alloc_slot(void)
{
	if (unlikely(pmmap_slots_next_free == 128))
		return NULL;
  101929:	b8 00 00 00 00       	mov    $0x0,%eax
	return &pmmap_slots[pmmap_slots_next_free++];
}
  10192e:	c3                   	ret    

0010192f <pmmap_insert>:
 * @param end
 * @param type
 */
static void
pmmap_insert(pmmap_list_type *pmmap_list_p, uintptr_t start, uintptr_t end, uint32_t type)
{
  10192f:	55                   	push   %ebp
  101930:	57                   	push   %edi
  101931:	56                   	push   %esi
  101932:	53                   	push   %ebx
  101933:	83 ec 0c             	sub    $0xc,%esp
  101936:	89 c7                	mov    %eax,%edi
  101938:	89 d3                	mov    %edx,%ebx
  10193a:	89 cd                	mov    %ecx,%ebp
	struct pmmap *free_slot, *slot, *last_slot;

	if ((free_slot = pmmap_alloc_slot()) == NULL)
  10193c:	e8 c3 ff ff ff       	call   101904 <pmmap_alloc_slot>
  101941:	89 c6                	mov    %eax,%esi
  101943:	85 c0                	test   %eax,%eax
  101945:	75 17                	jne    10195e <pmmap_insert+0x2f>
		KERN_PANIC("More than 128 E820 entries.\n");
  101947:	83 ec 04             	sub    $0x4,%esp
  10194a:	68 e1 5d 10 00       	push   $0x105de1
  10194f:	6a 30                	push   $0x30
  101951:	68 d0 5d 10 00       	push   $0x105dd0
  101956:	e8 5d 03 00 00       	call   101cb8 <debug_panic>
  10195b:	83 c4 10             	add    $0x10,%esp

	free_slot->start = start;
  10195e:	89 1e                	mov    %ebx,(%esi)
	free_slot->end = end;
  101960:	89 6e 04             	mov    %ebp,0x4(%esi)
	free_slot->type = type;
  101963:	8b 44 24 20          	mov    0x20(%esp),%eax
  101967:	89 46 08             	mov    %eax,0x8(%esi)

	last_slot = NULL;

	SLIST_FOREACH(slot, pmmap_list_p, next) {
  10196a:	8b 0f                	mov    (%edi),%ecx
  10196c:	89 c8                	mov    %ecx,%eax

	free_slot->start = start;
	free_slot->end = end;
	free_slot->type = type;

	last_slot = NULL;
  10196e:	ba 00 00 00 00       	mov    $0x0,%edx

	SLIST_FOREACH(slot, pmmap_list_p, next) {
  101973:	eb 09                	jmp    10197e <pmmap_insert+0x4f>
		if (start < slot->start)
  101975:	3b 18                	cmp    (%eax),%ebx
  101977:	72 09                	jb     101982 <pmmap_insert+0x53>
			break;
		last_slot = slot;
  101979:	89 c2                	mov    %eax,%edx
	free_slot->end = end;
	free_slot->type = type;

	last_slot = NULL;

	SLIST_FOREACH(slot, pmmap_list_p, next) {
  10197b:	8b 40 0c             	mov    0xc(%eax),%eax
  10197e:	85 c0                	test   %eax,%eax
  101980:	75 f3                	jne    101975 <pmmap_insert+0x46>
		if (start < slot->start)
			break;
		last_slot = slot;
	}

	if (last_slot == NULL)
  101982:	85 d2                	test   %edx,%edx
  101984:	75 07                	jne    10198d <pmmap_insert+0x5e>
  {
		SLIST_INSERT_HEAD(pmmap_list_p, free_slot, next);
  101986:	89 4e 0c             	mov    %ecx,0xc(%esi)
  101989:	89 37                	mov    %esi,(%edi)
  10198b:	eb 09                	jmp    101996 <pmmap_insert+0x67>
  }
	else
  {
		SLIST_INSERT_AFTER(last_slot, free_slot, next);
  10198d:	8b 42 0c             	mov    0xc(%edx),%eax
  101990:	89 46 0c             	mov    %eax,0xc(%esi)
  101993:	89 72 0c             	mov    %esi,0xc(%edx)
  }
}
  101996:	83 c4 0c             	add    $0xc,%esp
  101999:	5b                   	pop    %ebx
  10199a:	5e                   	pop    %esi
  10199b:	5f                   	pop    %edi
  10199c:	5d                   	pop    %ebp
  10199d:	c3                   	ret    

0010199e <pmmap_init>:
	}
}

void
pmmap_init(uintptr_t mbi_addr, pmmap_list_type *pmmap_list_p)
{
  10199e:	55                   	push   %ebp
  10199f:	57                   	push   %edi
  1019a0:	56                   	push   %esi
  1019a1:	53                   	push   %ebx
  1019a2:	83 ec 28             	sub    $0x28,%esp
  1019a5:	8b 74 24 3c          	mov    0x3c(%esp),%esi
	KERN_INFO("\n");
  1019a9:	68 ef 62 10 00       	push   $0x1062ef
  1019ae:	e8 c3 02 00 00       	call   101c76 <debug_info>
	KERN_DEBUG("pmmap_init mbi_adr: %d\n", mbi_addr);
  1019b3:	56                   	push   %esi
  1019b4:	68 fe 5d 10 00       	push   $0x105dfe
  1019b9:	68 84 00 00 00       	push   $0x84
  1019be:	68 d0 5d 10 00       	push   $0x105dd0
  1019c3:	e8 c6 02 00 00       	call   101c8e <debug_normal>

	mboot_info_t *mbi = (mboot_info_t *) mbi_addr;
  1019c8:	89 f3                	mov    %esi,%ebx
	mboot_mmap_t *p = (mboot_mmap_t *) mbi->mmap_addr;
  1019ca:	8b 46 30             	mov    0x30(%esi),%eax
	SLIST_INIT(pmmap_list_p);
  1019cd:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  1019d1:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	SLIST_INIT(&pmmap_sublist[PMMAP_USABLE]);
  1019d7:	c7 05 20 54 12 00 00 	movl   $0x0,0x125420
  1019de:	00 00 00 
	SLIST_INIT(&pmmap_sublist[PMMAP_RESV]);
  1019e1:	c7 05 24 54 12 00 00 	movl   $0x0,0x125424
  1019e8:	00 00 00 
	SLIST_INIT(&pmmap_sublist[PMMAP_ACPI]);
  1019eb:	c7 05 28 54 12 00 00 	movl   $0x0,0x125428
  1019f2:	00 00 00 
	SLIST_INIT(&pmmap_sublist[PMMAP_NVS]);
  1019f5:	c7 05 2c 54 12 00 00 	movl   $0x0,0x12542c
  1019fc:	00 00 00 

	/*
	 * Copy memory map information from multiboot information mbi to pmmap.
	 */
	while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  1019ff:	83 c4 20             	add    $0x20,%esp
  101a02:	eb 62                	jmp    101a66 <pmmap_init+0xc8>
		uintptr_t start,end;
		uint32_t type;

		if (p->base_addr_high != 0)	/* ignore address above 4G */
  101a04:	83 78 08 00          	cmpl   $0x0,0x8(%eax)
  101a08:	75 55                	jne    101a5f <pmmap_init+0xc1>
			goto next;
		else
			start = p->base_addr_low;
  101a0a:	8b 78 04             	mov    0x4(%eax),%edi

		if (p->length_high != 0 ||
  101a0d:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
  101a11:	75 0f                	jne    101a22 <pmmap_init+0x84>
		    p->length_low >= 0xffffffff - start)
  101a13:	8b 70 0c             	mov    0xc(%eax),%esi
  101a16:	89 fa                	mov    %edi,%edx
  101a18:	f7 d2                	not    %edx
		if (p->base_addr_high != 0)	/* ignore address above 4G */
			goto next;
		else
			start = p->base_addr_low;

		if (p->length_high != 0 ||
  101a1a:	39 d6                	cmp    %edx,%esi
  101a1c:	73 0b                	jae    101a29 <pmmap_init+0x8b>
		    p->length_low >= 0xffffffff - start)
			end = 0xffffffff;
		else
			end = start + p->length_low;
  101a1e:	01 fe                	add    %edi,%esi
  101a20:	eb 0c                	jmp    101a2e <pmmap_init+0x90>
		else
			start = p->base_addr_low;

		if (p->length_high != 0 ||
		    p->length_low >= 0xffffffff - start)
			end = 0xffffffff;
  101a22:	be ff ff ff ff       	mov    $0xffffffff,%esi
  101a27:	eb 05                	jmp    101a2e <pmmap_init+0x90>
  101a29:	be ff ff ff ff       	mov    $0xffffffff,%esi
		else
			end = start + p->length_low;

		type = p->type;
  101a2e:	8b 68 14             	mov    0x14(%eax),%ebp
        KERN_DEBUG("%d %lld %lld\n", type, start, end);
  101a31:	83 ec 08             	sub    $0x8,%esp
  101a34:	56                   	push   %esi
  101a35:	57                   	push   %edi
  101a36:	55                   	push   %ebp
  101a37:	68 16 5e 10 00       	push   $0x105e16
  101a3c:	68 a1 00 00 00       	push   $0xa1
  101a41:	68 d0 5d 10 00       	push   $0x105dd0
  101a46:	e8 43 02 00 00       	call   101c8e <debug_normal>
		pmmap_insert(pmmap_list_p, start, end, type);
  101a4b:	83 c4 14             	add    $0x14,%esp
  101a4e:	55                   	push   %ebp
  101a4f:	89 f1                	mov    %esi,%ecx
  101a51:	89 fa                	mov    %edi,%edx
  101a53:	8b 44 24 44          	mov    0x44(%esp),%eax
  101a57:	e8 d3 fe ff ff       	call   10192f <pmmap_insert>
  101a5c:	83 c4 10             	add    $0x10,%esp

		next:
			p = (mboot_mmap_t *) (((uint32_t) p) + sizeof(mboot_mmap_t)/* p->size */);
  101a5f:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101a63:	83 c0 18             	add    $0x18,%eax
	SLIST_INIT(&pmmap_sublist[PMMAP_NVS]);

	/*
	 * Copy memory map information from multiboot information mbi to pmmap.
	 */
	while ((uintptr_t) p - (uintptr_t) mbi->mmap_addr < mbi->mmap_length) {
  101a66:	89 44 24 0c          	mov    %eax,0xc(%esp)
  101a6a:	89 c2                	mov    %eax,%edx
  101a6c:	2b 53 30             	sub    0x30(%ebx),%edx
  101a6f:	3b 53 2c             	cmp    0x2c(%ebx),%edx
  101a72:	72 90                	jb     101a04 <pmmap_init+0x66>
		next:
			p = (mboot_mmap_t *) (((uint32_t) p) + sizeof(mboot_mmap_t)/* p->size */);
	}

	/* merge overlapped memory regions */
	pmmap_merge(pmmap_list_p);
  101a74:	8b 44 24 34          	mov    0x34(%esp),%eax
  101a78:	e8 8e fd ff ff       	call   10180b <pmmap_merge>
}
  101a7d:	83 c4 1c             	add    $0x1c,%esp
  101a80:	5b                   	pop    %ebx
  101a81:	5e                   	pop    %esi
  101a82:	5f                   	pop    %edi
  101a83:	5d                   	pop    %ebp
  101a84:	c3                   	ret    

00101a85 <set_cr3>:


void
set_cr3(char **pdir)
{
  101a85:	83 ec 18             	sub    $0x18,%esp
	lcr3((uint32_t) pdir);
  101a88:	ff 74 24 1c          	pushl  0x1c(%esp)
  101a8c:	e8 93 0b 00 00       	call   102624 <lcr3>
}
  101a91:	83 c4 1c             	add    $0x1c,%esp
  101a94:	c3                   	ret    

00101a95 <enable_paging>:
  *
  * Hint: bit masks are defined in x86.h file.
  */
void
enable_paging(void)
{
  101a95:	83 ec 0c             	sub    $0xc,%esp
    uint32_t cr4 = rcr4();
  101a98:	e8 97 0b 00 00       	call   102634 <rcr4>
    lcr4(cr4 | CR4_PGE);
  101a9d:	83 ec 0c             	sub    $0xc,%esp
  101aa0:	0c 80                	or     $0x80,%al
  101aa2:	50                   	push   %eax
  101aa3:	e8 84 0b 00 00       	call   10262c <lcr4>
    uint32_t cr0 = rcr0();
  101aa8:	e8 6f 0b 00 00       	call   10261c <rcr0>
    uint32_t CRO_ET = 16;
    lcr0(cr0 | CR0_PE | CR0_MP | CR0_NE | CR0_WP | CR0_AM | CR0_PG | CRO_ET);
  101aad:	0d 33 00 05 80       	or     $0x80050033,%eax
  101ab2:	89 04 24             	mov    %eax,(%esp)
  101ab5:	e8 5a 0b 00 00       	call   102614 <lcr0>

}
  101aba:	83 c4 1c             	add    $0x1c,%esp
  101abd:	c3                   	ret    

00101abe <memset>:
#include "string.h"
#include "types.h"

void *
memset(void *v, int c, size_t n)
{
  101abe:	57                   	push   %edi
  101abf:	53                   	push   %ebx
  101ac0:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  101ac4:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    if (n == 0)
  101ac8:	85 c9                	test   %ecx,%ecx
  101aca:	74 36                	je     101b02 <memset+0x44>
        return v;
    if ((int)v%4 == 0 && n%4 == 0) {
  101acc:	f7 c7 03 00 00 00    	test   $0x3,%edi
  101ad2:	75 27                	jne    101afb <memset+0x3d>
  101ad4:	f6 c1 03             	test   $0x3,%cl
  101ad7:	75 22                	jne    101afb <memset+0x3d>
        c &= 0xFF;
  101ad9:	0f b6 54 24 10       	movzbl 0x10(%esp),%edx
        c = (c<<24)|(c<<16)|(c<<8)|c;
  101ade:	89 d3                	mov    %edx,%ebx
  101ae0:	c1 e3 18             	shl    $0x18,%ebx
  101ae3:	89 d0                	mov    %edx,%eax
  101ae5:	c1 e0 10             	shl    $0x10,%eax
  101ae8:	09 d8                	or     %ebx,%eax
  101aea:	89 d3                	mov    %edx,%ebx
  101aec:	c1 e3 08             	shl    $0x8,%ebx
  101aef:	09 d8                	or     %ebx,%eax
  101af1:	09 d0                	or     %edx,%eax
        asm volatile("cld; rep stosl\n"
                 :: "D" (v), "a" (c), "c" (n/4)
  101af3:	c1 e9 02             	shr    $0x2,%ecx
    if (n == 0)
        return v;
    if ((int)v%4 == 0 && n%4 == 0) {
        c &= 0xFF;
        c = (c<<24)|(c<<16)|(c<<8)|c;
        asm volatile("cld; rep stosl\n"
  101af6:	fc                   	cld    
  101af7:	f3 ab                	rep stos %eax,%es:(%edi)
  101af9:	eb 07                	jmp    101b02 <memset+0x44>
                 :: "D" (v), "a" (c), "c" (n/4)
                 : "cc", "memory");
    } else
        asm volatile("cld; rep stosb\n"
  101afb:	8b 44 24 10          	mov    0x10(%esp),%eax
  101aff:	fc                   	cld    
  101b00:	f3 aa                	rep stos %al,%es:(%edi)
                 :: "D" (v), "a" (c), "c" (n)
                 : "cc", "memory");
    return v;
}
  101b02:	89 f8                	mov    %edi,%eax
  101b04:	5b                   	pop    %ebx
  101b05:	5f                   	pop    %edi
  101b06:	c3                   	ret    

00101b07 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  101b07:	57                   	push   %edi
  101b08:	56                   	push   %esi
  101b09:	8b 44 24 0c          	mov    0xc(%esp),%eax
  101b0d:	8b 74 24 10          	mov    0x10(%esp),%esi
  101b11:	8b 4c 24 14          	mov    0x14(%esp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
  101b15:	39 c6                	cmp    %eax,%esi
  101b17:	73 36                	jae    101b4f <memmove+0x48>
  101b19:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  101b1c:	39 d0                	cmp    %edx,%eax
  101b1e:	73 2f                	jae    101b4f <memmove+0x48>
        s += n;
        d += n;
  101b20:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
        if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  101b23:	f6 c2 03             	test   $0x3,%dl
  101b26:	75 1b                	jne    101b43 <memmove+0x3c>
  101b28:	f7 c7 03 00 00 00    	test   $0x3,%edi
  101b2e:	75 13                	jne    101b43 <memmove+0x3c>
  101b30:	f6 c1 03             	test   $0x3,%cl
  101b33:	75 0e                	jne    101b43 <memmove+0x3c>
            asm volatile("std; rep movsl\n"
                     :: "D" (d-4), "S" (s-4), "c" (n/4)
  101b35:	83 ef 04             	sub    $0x4,%edi
  101b38:	8d 72 fc             	lea    -0x4(%edx),%esi
  101b3b:	c1 e9 02             	shr    $0x2,%ecx
    d = dst;
    if (s < d && s + n > d) {
        s += n;
        d += n;
        if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
            asm volatile("std; rep movsl\n"
  101b3e:	fd                   	std    
  101b3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  101b41:	eb 09                	jmp    101b4c <memmove+0x45>
                     :: "D" (d-4), "S" (s-4), "c" (n/4)
                     : "cc", "memory");
        else
            asm volatile("std; rep movsb\n"
                     :: "D" (d-1), "S" (s-1), "c" (n)
  101b43:	83 ef 01             	sub    $0x1,%edi
  101b46:	8d 72 ff             	lea    -0x1(%edx),%esi
        if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
            asm volatile("std; rep movsl\n"
                     :: "D" (d-4), "S" (s-4), "c" (n/4)
                     : "cc", "memory");
        else
            asm volatile("std; rep movsb\n"
  101b49:	fd                   	std    
  101b4a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                     :: "D" (d-1), "S" (s-1), "c" (n)
                     : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile("cld" ::: "cc");
  101b4c:	fc                   	cld    
  101b4d:	eb 20                	jmp    101b6f <memmove+0x68>
    } else {
        if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  101b4f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  101b55:	75 13                	jne    101b6a <memmove+0x63>
  101b57:	a8 03                	test   $0x3,%al
  101b59:	75 0f                	jne    101b6a <memmove+0x63>
  101b5b:	f6 c1 03             	test   $0x3,%cl
  101b5e:	75 0a                	jne    101b6a <memmove+0x63>
            asm volatile("cld; rep movsl\n"
                     :: "D" (d), "S" (s), "c" (n/4)
  101b60:	c1 e9 02             	shr    $0x2,%ecx
                     : "cc", "memory");
        // Some versions of GCC rely on DF being clear
        asm volatile("cld" ::: "cc");
    } else {
        if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
            asm volatile("cld; rep movsl\n"
  101b63:	89 c7                	mov    %eax,%edi
  101b65:	fc                   	cld    
  101b66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  101b68:	eb 05                	jmp    101b6f <memmove+0x68>
                     :: "D" (d), "S" (s), "c" (n/4)
                     : "cc", "memory");
        else
            asm volatile("cld; rep movsb\n"
  101b6a:	89 c7                	mov    %eax,%edi
  101b6c:	fc                   	cld    
  101b6d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
                     :: "D" (d), "S" (s), "c" (n)
                     : "cc", "memory");
    }
    return dst;
}
  101b6f:	5e                   	pop    %esi
  101b70:	5f                   	pop    %edi
  101b71:	c3                   	ret    

00101b72 <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
  101b72:	ff 74 24 0c          	pushl  0xc(%esp)
  101b76:	ff 74 24 0c          	pushl  0xc(%esp)
  101b7a:	ff 74 24 0c          	pushl  0xc(%esp)
  101b7e:	e8 84 ff ff ff       	call   101b07 <memmove>
  101b83:	83 c4 0c             	add    $0xc,%esp
}
  101b86:	c3                   	ret    

00101b87 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  101b87:	53                   	push   %ebx
  101b88:	8b 54 24 08          	mov    0x8(%esp),%edx
  101b8c:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
  101b90:	8b 44 24 10          	mov    0x10(%esp),%eax
	while (n > 0 && *p && *p == *q)
  101b94:	eb 09                	jmp    101b9f <strncmp+0x18>
		n--, p++, q++;
  101b96:	83 e8 01             	sub    $0x1,%eax
  101b99:	83 c2 01             	add    $0x1,%edx
  101b9c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  101b9f:	85 c0                	test   %eax,%eax
  101ba1:	74 0b                	je     101bae <strncmp+0x27>
  101ba3:	0f b6 1a             	movzbl (%edx),%ebx
  101ba6:	84 db                	test   %bl,%bl
  101ba8:	74 04                	je     101bae <strncmp+0x27>
  101baa:	3a 19                	cmp    (%ecx),%bl
  101bac:	74 e8                	je     101b96 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
  101bae:	85 c0                	test   %eax,%eax
  101bb0:	74 0a                	je     101bbc <strncmp+0x35>
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  101bb2:	0f b6 02             	movzbl (%edx),%eax
  101bb5:	0f b6 11             	movzbl (%ecx),%edx
  101bb8:	29 d0                	sub    %edx,%eax
  101bba:	eb 05                	jmp    101bc1 <strncmp+0x3a>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  101bbc:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  101bc1:	5b                   	pop    %ebx
  101bc2:	c3                   	ret    

00101bc3 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  101bc3:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  101bc7:	8b 54 24 08          	mov    0x8(%esp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  101bcb:	b8 00 00 00 00       	mov    $0x0,%eax
  101bd0:	eb 09                	jmp    101bdb <strnlen+0x18>
		n++;
  101bd2:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  101bd5:	83 c1 01             	add    $0x1,%ecx
  101bd8:	83 ea 01             	sub    $0x1,%edx
  101bdb:	85 d2                	test   %edx,%edx
  101bdd:	74 05                	je     101be4 <strnlen+0x21>
  101bdf:	80 39 00             	cmpb   $0x0,(%ecx)
  101be2:	75 ee                	jne    101bd2 <strnlen+0xf>
		n++;
	return n;
}
  101be4:	f3 c3                	repz ret 

00101be6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  101be6:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  101bea:	8b 54 24 08          	mov    0x8(%esp),%edx
  while (*p && *p == *q)
  101bee:	eb 06                	jmp    101bf6 <strcmp+0x10>
    p++, q++;
  101bf0:	83 c1 01             	add    $0x1,%ecx
  101bf3:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while (*p && *p == *q)
  101bf6:	0f b6 01             	movzbl (%ecx),%eax
  101bf9:	84 c0                	test   %al,%al
  101bfb:	74 04                	je     101c01 <strcmp+0x1b>
  101bfd:	3a 02                	cmp    (%edx),%al
  101bff:	74 ef                	je     101bf0 <strcmp+0xa>
    p++, q++;
  return (int) ((unsigned char) *p - (unsigned char) *q);
  101c01:	0f b6 c0             	movzbl %al,%eax
  101c04:	0f b6 12             	movzbl (%edx),%edx
  101c07:	29 d0                	sub    %edx,%eax
}
  101c09:	c3                   	ret    

00101c0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  101c0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  101c0e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
  for (; *s; s++)
  101c13:	eb 07                	jmp    101c1c <strchr+0x12>
    if (*s == c)
  101c15:	38 ca                	cmp    %cl,%dl
  101c17:	74 0f                	je     101c28 <strchr+0x1e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  for (; *s; s++)
  101c19:	83 c0 01             	add    $0x1,%eax
  101c1c:	0f b6 10             	movzbl (%eax),%edx
  101c1f:	84 d2                	test   %dl,%dl
  101c21:	75 f2                	jne    101c15 <strchr+0xb>
    if (*s == c)
      return (char *) s;
  return 0;
  101c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101c28:	f3 c3                	repz ret 

00101c2a <memzero>:

void *
memzero(void *v, size_t n)
{
	return memset(v, 0, n);
  101c2a:	ff 74 24 08          	pushl  0x8(%esp)
  101c2e:	6a 00                	push   $0x0
  101c30:	ff 74 24 0c          	pushl  0xc(%esp)
  101c34:	e8 85 fe ff ff       	call   101abe <memset>
  101c39:	83 c4 0c             	add    $0xc,%esp
}
  101c3c:	c3                   	ret    

00101c3d <debug_trace>:

#define DEBUG_TRACEFRAMES	10

static void
debug_trace(uintptr_t ebp, uintptr_t *eips)
{
  101c3d:	56                   	push   %esi
  101c3e:	53                   	push   %ebx
  101c3f:	89 d6                	mov    %edx,%esi
	int i;
	uintptr_t *frame = (uintptr_t *) ebp;

	for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
  101c41:	b9 00 00 00 00       	mov    $0x0,%ecx
  101c46:	eb 0b                	jmp    101c53 <debug_trace+0x16>
		eips[i] = frame[1];		/* saved %eip */
  101c48:	8b 50 04             	mov    0x4(%eax),%edx
  101c4b:	89 14 8e             	mov    %edx,(%esi,%ecx,4)
		frame = (uintptr_t *) frame[0];	/* saved %ebp */
  101c4e:	8b 00                	mov    (%eax),%eax
debug_trace(uintptr_t ebp, uintptr_t *eips)
{
	int i;
	uintptr_t *frame = (uintptr_t *) ebp;

	for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
  101c50:	83 c1 01             	add    $0x1,%ecx
  101c53:	83 f9 09             	cmp    $0x9,%ecx
  101c56:	0f 9e c3             	setle  %bl
  101c59:	85 c0                	test   %eax,%eax
  101c5b:	0f 95 c2             	setne  %dl
  101c5e:	84 da                	test   %bl,%dl
  101c60:	75 e6                	jne    101c48 <debug_trace+0xb>
  101c62:	eb 0a                	jmp    101c6e <debug_trace+0x31>
		eips[i] = frame[1];		/* saved %eip */
		frame = (uintptr_t *) frame[0];	/* saved %ebp */
	}
	for (; i < DEBUG_TRACEFRAMES; i++)
		eips[i] = 0;
  101c64:	c7 04 8e 00 00 00 00 	movl   $0x0,(%esi,%ecx,4)

	for (i = 0; i < DEBUG_TRACEFRAMES && frame; i++) {
		eips[i] = frame[1];		/* saved %eip */
		frame = (uintptr_t *) frame[0];	/* saved %ebp */
	}
	for (; i < DEBUG_TRACEFRAMES; i++)
  101c6b:	83 c1 01             	add    $0x1,%ecx
  101c6e:	83 f9 09             	cmp    $0x9,%ecx
  101c71:	7e f1                	jle    101c64 <debug_trace+0x27>
		eips[i] = 0;
}
  101c73:	5b                   	pop    %ebx
  101c74:	5e                   	pop    %esi
  101c75:	c3                   	ret    

00101c76 <debug_info>:

#include <lib/types.h>

void
debug_info(const char *fmt, ...)
{
  101c76:	83 ec 0c             	sub    $0xc,%esp
#ifdef DEBUG_MSG
	va_list ap;
	va_start(ap, fmt);
  101c79:	8d 44 24 14          	lea    0x14(%esp),%eax
	vdprintf(fmt, ap);
  101c7d:	83 ec 08             	sub    $0x8,%esp
  101c80:	50                   	push   %eax
  101c81:	ff 74 24 1c          	pushl  0x1c(%esp)
  101c85:	e8 31 01 00 00       	call   101dbb <vdprintf>
	va_end(ap);
#endif
}
  101c8a:	83 c4 1c             	add    $0x1c,%esp
  101c8d:	c3                   	ret    

00101c8e <debug_normal>:

#ifdef DEBUG_MSG

void
debug_normal(const char *file, int line, const char *fmt, ...)
{
  101c8e:	83 ec 10             	sub    $0x10,%esp
	dprintf("[D] %s:%d: ", file, line);
  101c91:	ff 74 24 18          	pushl  0x18(%esp)
  101c95:	ff 74 24 18          	pushl  0x18(%esp)
  101c99:	68 24 5e 10 00       	push   $0x105e24
  101c9e:	e8 68 01 00 00       	call   101e0b <dprintf>

	va_list ap;
	va_start(ap, fmt);
  101ca3:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	vdprintf(fmt, ap);
  101ca7:	83 c4 08             	add    $0x8,%esp
  101caa:	50                   	push   %eax
  101cab:	ff 74 24 24          	pushl  0x24(%esp)
  101caf:	e8 07 01 00 00       	call   101dbb <vdprintf>
	va_end(ap);
}
  101cb4:	83 c4 1c             	add    $0x1c,%esp
  101cb7:	c3                   	ret    

00101cb8 <debug_panic>:
		eips[i] = 0;
}

gcc_noinline void
debug_panic(const char *file, int line, const char *fmt,...)
{
  101cb8:	53                   	push   %ebx
  101cb9:	83 ec 3c             	sub    $0x3c,%esp
	int i;
	uintptr_t eips[DEBUG_TRACEFRAMES];
	va_list ap;

	dprintf("[P] %s:%d: ", file, line);
  101cbc:	ff 74 24 48          	pushl  0x48(%esp)
  101cc0:	ff 74 24 48          	pushl  0x48(%esp)
  101cc4:	68 30 5e 10 00       	push   $0x105e30
  101cc9:	e8 3d 01 00 00       	call   101e0b <dprintf>

	va_start(ap, fmt);
  101cce:	8d 44 24 5c          	lea    0x5c(%esp),%eax
	vdprintf(fmt, ap);
  101cd2:	83 c4 08             	add    $0x8,%esp
  101cd5:	50                   	push   %eax
  101cd6:	ff 74 24 54          	pushl  0x54(%esp)
  101cda:	e8 dc 00 00 00       	call   101dbb <vdprintf>

static inline uint32_t __attribute__((always_inline))
read_ebp(void)
{
	uint32_t ebp;
	__asm __volatile("movl %%ebp,%0" : "=rm" (ebp));
  101cdf:	89 e8                	mov    %ebp,%eax
	va_end(ap);

	debug_trace(read_ebp(), eips);
  101ce1:	8d 54 24 18          	lea    0x18(%esp),%edx
  101ce5:	e8 53 ff ff ff       	call   101c3d <debug_trace>
	for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  101cea:	83 c4 10             	add    $0x10,%esp
  101ced:	bb 00 00 00 00       	mov    $0x0,%ebx
  101cf2:	eb 14                	jmp    101d08 <debug_panic+0x50>
		dprintf("\tfrom 0x%08x\n", eips[i]);
  101cf4:	83 ec 08             	sub    $0x8,%esp
  101cf7:	50                   	push   %eax
  101cf8:	68 3c 5e 10 00       	push   $0x105e3c
  101cfd:	e8 09 01 00 00       	call   101e0b <dprintf>
	va_start(ap, fmt);
	vdprintf(fmt, ap);
	va_end(ap);

	debug_trace(read_ebp(), eips);
	for (i = 0; i < DEBUG_TRACEFRAMES && eips[i] != 0; i++)
  101d02:	83 c3 01             	add    $0x1,%ebx
  101d05:	83 c4 10             	add    $0x10,%esp
  101d08:	83 fb 09             	cmp    $0x9,%ebx
  101d0b:	7f 08                	jg     101d15 <debug_panic+0x5d>
  101d0d:	8b 44 9c 08          	mov    0x8(%esp,%ebx,4),%eax
  101d11:	85 c0                	test   %eax,%eax
  101d13:	75 df                	jne    101cf4 <debug_panic+0x3c>
		dprintf("\tfrom 0x%08x\n", eips[i]);

	dprintf("Kernel Panic !!!\n");
  101d15:	83 ec 0c             	sub    $0xc,%esp
  101d18:	68 4a 5e 10 00       	push   $0x105e4a
  101d1d:	e8 e9 00 00 00       	call   101e0b <dprintf>

	//intr_local_disable();
	halt();
  101d22:	e8 7d 08 00 00       	call   1025a4 <halt>
}
  101d27:	83 c4 48             	add    $0x48,%esp
  101d2a:	5b                   	pop    %ebx
  101d2b:	c3                   	ret    

00101d2c <debug_warn>:

void
debug_warn(const char *file, int line, const char *fmt,...)
{
  101d2c:	83 ec 10             	sub    $0x10,%esp
	dprintf("[W] %s:%d: ", file, line);
  101d2f:	ff 74 24 18          	pushl  0x18(%esp)
  101d33:	ff 74 24 18          	pushl  0x18(%esp)
  101d37:	68 5c 5e 10 00       	push   $0x105e5c
  101d3c:	e8 ca 00 00 00       	call   101e0b <dprintf>

	va_list ap;
	va_start(ap, fmt);
  101d41:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	vdprintf(fmt, ap);
  101d45:	83 c4 08             	add    $0x8,%esp
  101d48:	50                   	push   %eax
  101d49:	ff 74 24 24          	pushl  0x24(%esp)
  101d4d:	e8 69 00 00 00       	call   101dbb <vdprintf>
	va_end(ap);
}
  101d52:	83 c4 1c             	add    $0x1c,%esp
  101d55:	c3                   	ret    

00101d56 <cputs>:
    char buf[CONSOLE_BUFFER_SIZE];
};

static void
cputs (const char *str)
{
  101d56:	53                   	push   %ebx
  101d57:	83 ec 08             	sub    $0x8,%esp
  101d5a:	89 c3                	mov    %eax,%ebx
    while (*str)
  101d5c:	eb 12                	jmp    101d70 <cputs+0x1a>
    {
        cons_putc (*str);
  101d5e:	83 ec 0c             	sub    $0xc,%esp
  101d61:	0f be c0             	movsbl %al,%eax
  101d64:	50                   	push   %eax
  101d65:	e8 fe e5 ff ff       	call   100368 <cons_putc>
        str += 1;
  101d6a:	83 c3 01             	add    $0x1,%ebx
  101d6d:	83 c4 10             	add    $0x10,%esp
};

static void
cputs (const char *str)
{
    while (*str)
  101d70:	0f b6 03             	movzbl (%ebx),%eax
  101d73:	84 c0                	test   %al,%al
  101d75:	75 e7                	jne    101d5e <cputs+0x8>
    {
        cons_putc (*str);
        str += 1;
    }
}
  101d77:	83 c4 08             	add    $0x8,%esp
  101d7a:	5b                   	pop    %ebx
  101d7b:	c3                   	ret    

00101d7c <putch>:

static void
putch (int ch, struct dprintbuf *b)
{
  101d7c:	53                   	push   %ebx
  101d7d:	83 ec 08             	sub    $0x8,%esp
  101d80:	8b 5c 24 14          	mov    0x14(%esp),%ebx
    b->buf[b->idx++] = ch;
  101d84:	8b 13                	mov    (%ebx),%edx
  101d86:	8d 42 01             	lea    0x1(%edx),%eax
  101d89:	89 03                	mov    %eax,(%ebx)
  101d8b:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  101d8f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
    if (b->idx == CONSOLE_BUFFER_SIZE - 1)
  101d93:	3d ff 01 00 00       	cmp    $0x1ff,%eax
  101d98:	75 13                	jne    101dad <putch+0x31>
    {
        b->buf[b->idx] = 0;
  101d9a:	c6 44 13 09 00       	movb   $0x0,0x9(%ebx,%edx,1)
        cputs (b->buf);
  101d9f:	8d 43 08             	lea    0x8(%ebx),%eax
  101da2:	e8 af ff ff ff       	call   101d56 <cputs>
        b->idx = 0;
  101da7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    }
    b->cnt++;
  101dad:	8b 43 04             	mov    0x4(%ebx),%eax
  101db0:	83 c0 01             	add    $0x1,%eax
  101db3:	89 43 04             	mov    %eax,0x4(%ebx)
}
  101db6:	83 c4 08             	add    $0x8,%esp
  101db9:	5b                   	pop    %ebx
  101dba:	c3                   	ret    

00101dbb <vdprintf>:

int
vdprintf (const char *fmt, va_list ap)
{
  101dbb:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
    struct dprintbuf b;

    b.idx = 0;
  101dc1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101dc8:	00 
    b.cnt = 0;
  101dc9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  101dd0:	00 
    vprintfmt ((void*) putch, &b, fmt, ap);
  101dd1:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
  101dd8:	ff b4 24 24 02 00 00 	pushl  0x224(%esp)
  101ddf:	8d 44 24 10          	lea    0x10(%esp),%eax
  101de3:	50                   	push   %eax
  101de4:	68 7c 1d 10 00       	push   $0x101d7c
  101de9:	e8 4b 01 00 00       	call   101f39 <vprintfmt>

    b.buf[b.idx] = 0;
  101dee:	8b 44 24 18          	mov    0x18(%esp),%eax
  101df2:	c6 44 04 20 00       	movb   $0x0,0x20(%esp,%eax,1)
    cputs (b.buf);
  101df7:	8d 44 24 20          	lea    0x20(%esp),%eax
  101dfb:	e8 56 ff ff ff       	call   101d56 <cputs>

    return b.cnt;
}
  101e00:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  101e04:	81 c4 2c 02 00 00    	add    $0x22c,%esp
  101e0a:	c3                   	ret    

00101e0b <dprintf>:

int
dprintf (const char *fmt, ...)
{
  101e0b:	83 ec 0c             	sub    $0xc,%esp
    va_list ap;
    int cnt;

    va_start(ap, fmt);
  101e0e:	8d 44 24 14          	lea    0x14(%esp),%eax
    cnt = vdprintf (fmt, ap);
  101e12:	83 ec 08             	sub    $0x8,%esp
  101e15:	50                   	push   %eax
  101e16:	ff 74 24 1c          	pushl  0x1c(%esp)
  101e1a:	e8 9c ff ff ff       	call   101dbb <vdprintf>
    va_end(ap);

    return cnt;
}
  101e1f:	83 c4 1c             	add    $0x1c,%esp
  101e22:	c3                   	ret    

00101e23 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(putch_t putch, void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  101e23:	55                   	push   %ebp
  101e24:	57                   	push   %edi
  101e25:	56                   	push   %esi
  101e26:	53                   	push   %ebx
  101e27:	83 ec 1c             	sub    $0x1c,%esp
  101e2a:	89 c6                	mov    %eax,%esi
  101e2c:	89 d7                	mov    %edx,%edi
  101e2e:	8b 44 24 30          	mov    0x30(%esp),%eax
  101e32:	8b 54 24 34          	mov    0x34(%esp),%edx
  101e36:	89 44 24 08          	mov    %eax,0x8(%esp)
  101e3a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  101e3e:	8b 6c 24 40          	mov    0x40(%esp),%ebp
	/* first recursively print all preceding (more significant) digits */
	if (num >= base) {
  101e42:	8b 4c 24 38          	mov    0x38(%esp),%ecx
  101e46:	bb 00 00 00 00       	mov    $0x0,%ebx
  101e4b:	89 0c 24             	mov    %ecx,(%esp)
  101e4e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101e52:	39 d3                	cmp    %edx,%ebx
  101e54:	72 06                	jb     101e5c <printnum+0x39>
  101e56:	39 44 24 38          	cmp    %eax,0x38(%esp)
  101e5a:	77 47                	ja     101ea3 <printnum+0x80>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  101e5c:	83 ec 0c             	sub    $0xc,%esp
  101e5f:	55                   	push   %ebp
  101e60:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  101e64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  101e67:	53                   	push   %ebx
  101e68:	ff 74 24 4c          	pushl  0x4c(%esp)
  101e6c:	83 ec 08             	sub    $0x8,%esp
  101e6f:	ff 74 24 24          	pushl  0x24(%esp)
  101e73:	ff 74 24 24          	pushl  0x24(%esp)
  101e77:	ff 74 24 34          	pushl  0x34(%esp)
  101e7b:	ff 74 24 34          	pushl  0x34(%esp)
  101e7f:	e8 5c 39 00 00       	call   1057e0 <__udivdi3>
  101e84:	83 c4 18             	add    $0x18,%esp
  101e87:	52                   	push   %edx
  101e88:	50                   	push   %eax
  101e89:	89 fa                	mov    %edi,%edx
  101e8b:	89 f0                	mov    %esi,%eax
  101e8d:	e8 91 ff ff ff       	call   101e23 <printnum>
  101e92:	83 c4 20             	add    $0x20,%esp
  101e95:	eb 17                	jmp    101eae <printnum+0x8b>
	} else {
		/* print any needed pad characters before first digit */
		while (--width > 0)
			putch(padc, putdat);
  101e97:	83 ec 08             	sub    $0x8,%esp
  101e9a:	57                   	push   %edi
  101e9b:	55                   	push   %ebp
  101e9c:	ff d6                	call   *%esi
  101e9e:	83 c4 10             	add    $0x10,%esp
  101ea1:	eb 04                	jmp    101ea7 <printnum+0x84>
  101ea3:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
	/* first recursively print all preceding (more significant) digits */
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		/* print any needed pad characters before first digit */
		while (--width > 0)
  101ea7:	83 eb 01             	sub    $0x1,%ebx
  101eaa:	85 db                	test   %ebx,%ebx
  101eac:	7f e9                	jg     101e97 <printnum+0x74>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  101eae:	ff 74 24 04          	pushl  0x4(%esp)
  101eb2:	ff 74 24 04          	pushl  0x4(%esp)
  101eb6:	ff 74 24 14          	pushl  0x14(%esp)
  101eba:	ff 74 24 14          	pushl  0x14(%esp)
  101ebe:	e8 4d 3a 00 00       	call   105910 <__umoddi3>
  101ec3:	83 c4 08             	add    $0x8,%esp
  101ec6:	57                   	push   %edi
  101ec7:	0f be 80 68 5e 10 00 	movsbl 0x105e68(%eax),%eax
  101ece:	50                   	push   %eax
  101ecf:	ff d6                	call   *%esi
}
  101ed1:	83 c4 2c             	add    $0x2c,%esp
  101ed4:	5b                   	pop    %ebx
  101ed5:	5e                   	pop    %esi
  101ed6:	5f                   	pop    %edi
  101ed7:	5d                   	pop    %ebp
  101ed8:	c3                   	ret    

00101ed9 <getuint>:
 * depending on the lflag parameter.
 */
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  101ed9:	83 fa 01             	cmp    $0x1,%edx
  101edc:	7e 0d                	jle    101eeb <getuint+0x12>
		return va_arg(*ap, unsigned long long);
  101ede:	8b 10                	mov    (%eax),%edx
  101ee0:	8d 4a 08             	lea    0x8(%edx),%ecx
  101ee3:	89 08                	mov    %ecx,(%eax)
  101ee5:	8b 02                	mov    (%edx),%eax
  101ee7:	8b 52 04             	mov    0x4(%edx),%edx
  101eea:	c3                   	ret    
	else if (lflag)
  101eeb:	85 d2                	test   %edx,%edx
  101eed:	74 0f                	je     101efe <getuint+0x25>
		return va_arg(*ap, unsigned long);
  101eef:	8b 10                	mov    (%eax),%edx
  101ef1:	8d 4a 04             	lea    0x4(%edx),%ecx
  101ef4:	89 08                	mov    %ecx,(%eax)
  101ef6:	8b 02                	mov    (%edx),%eax
  101ef8:	ba 00 00 00 00       	mov    $0x0,%edx
  101efd:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  101efe:	8b 10                	mov    (%eax),%edx
  101f00:	8d 4a 04             	lea    0x4(%edx),%ecx
  101f03:	89 08                	mov    %ecx,(%eax)
  101f05:	8b 02                	mov    (%edx),%eax
  101f07:	ba 00 00 00 00       	mov    $0x0,%edx
}
  101f0c:	c3                   	ret    

00101f0d <getint>:
 * because of sign extension
 */
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  101f0d:	83 fa 01             	cmp    $0x1,%edx
  101f10:	7e 0d                	jle    101f1f <getint+0x12>
		return va_arg(*ap, long long);
  101f12:	8b 10                	mov    (%eax),%edx
  101f14:	8d 4a 08             	lea    0x8(%edx),%ecx
  101f17:	89 08                	mov    %ecx,(%eax)
  101f19:	8b 02                	mov    (%edx),%eax
  101f1b:	8b 52 04             	mov    0x4(%edx),%edx
  101f1e:	c3                   	ret    
	else if (lflag)
  101f1f:	85 d2                	test   %edx,%edx
  101f21:	74 0b                	je     101f2e <getint+0x21>
		return va_arg(*ap, long);
  101f23:	8b 10                	mov    (%eax),%edx
  101f25:	8d 4a 04             	lea    0x4(%edx),%ecx
  101f28:	89 08                	mov    %ecx,(%eax)
  101f2a:	8b 02                	mov    (%edx),%eax
  101f2c:	99                   	cltd   
  101f2d:	c3                   	ret    
	else
		return va_arg(*ap, int);
  101f2e:	8b 10                	mov    (%eax),%edx
  101f30:	8d 4a 04             	lea    0x4(%edx),%ecx
  101f33:	89 08                	mov    %ecx,(%eax)
  101f35:	8b 02                	mov    (%edx),%eax
  101f37:	99                   	cltd   
}
  101f38:	c3                   	ret    

00101f39 <vprintfmt>:

void
vprintfmt(putch_t putch, void *putdat, const char *fmt, va_list ap)
{
  101f39:	55                   	push   %ebp
  101f3a:	57                   	push   %edi
  101f3b:	56                   	push   %esi
  101f3c:	53                   	push   %ebx
  101f3d:	83 ec 2c             	sub    $0x2c,%esp
  101f40:	8b 5c 24 40          	mov    0x40(%esp),%ebx
  101f44:	8b 74 24 44          	mov    0x44(%esp),%esi
  101f48:	8b 6c 24 48          	mov    0x48(%esp),%ebp
  101f4c:	89 f7                	mov    %esi,%edi
  101f4e:	89 de                	mov    %ebx,%esi
  101f50:	eb 14                	jmp    101f66 <vprintfmt+0x2d>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  101f52:	85 c0                	test   %eax,%eax
  101f54:	0f 84 ef 02 00 00    	je     102249 <vprintfmt+0x310>
				return;
			putch(ch, putdat);
  101f5a:	83 ec 08             	sub    $0x8,%esp
  101f5d:	57                   	push   %edi
  101f5e:	50                   	push   %eax
  101f5f:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  101f61:	89 dd                	mov    %ebx,%ebp
  101f63:	83 c4 10             	add    $0x10,%esp
  101f66:	8d 5d 01             	lea    0x1(%ebp),%ebx
  101f69:	0f b6 45 00          	movzbl 0x0(%ebp),%eax
  101f6d:	83 f8 25             	cmp    $0x25,%eax
  101f70:	75 e0                	jne    101f52 <vprintfmt+0x19>
  101f72:	c6 44 24 17 20       	movb   $0x20,0x17(%esp)
  101f77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101f7e:	00 
  101f7f:	c7 44 24 18 ff ff ff 	movl   $0xffffffff,0x18(%esp)
  101f86:	ff 
  101f87:	c7 44 24 10 ff ff ff 	movl   $0xffffffff,0x10(%esp)
  101f8e:	ff 
  101f8f:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  101f96:	00 
  101f97:	eb 2e                	jmp    101fc7 <vprintfmt+0x8e>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  101f99:	89 eb                	mov    %ebp,%ebx

			// flag to pad on the right
		case '-':
			padc = '-';
  101f9b:	c6 44 24 17 2d       	movb   $0x2d,0x17(%esp)
  101fa0:	eb 25                	jmp    101fc7 <vprintfmt+0x8e>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  101fa2:	89 eb                	mov    %ebp,%ebx
			padc = '-';
			goto reswitch;

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  101fa4:	c6 44 24 17 30       	movb   $0x30,0x17(%esp)
  101fa9:	eb 1c                	jmp    101fc7 <vprintfmt+0x8e>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  101fab:	89 eb                	mov    %ebp,%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  101fad:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  101fb4:	00 
  101fb5:	eb 10                	jmp    101fc7 <vprintfmt+0x8e>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  101fb7:	8b 44 24 18          	mov    0x18(%esp),%eax
  101fbb:	89 44 24 10          	mov    %eax,0x10(%esp)
  101fbf:	c7 44 24 18 ff ff ff 	movl   $0xffffffff,0x18(%esp)
  101fc6:	ff 
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  101fc7:	8d 6b 01             	lea    0x1(%ebx),%ebp
  101fca:	0f b6 13             	movzbl (%ebx),%edx
  101fcd:	0f b6 c2             	movzbl %dl,%eax
  101fd0:	83 ea 23             	sub    $0x23,%edx
  101fd3:	80 fa 55             	cmp    $0x55,%dl
  101fd6:	0f 87 50 02 00 00    	ja     10222c <vprintfmt+0x2f3>
  101fdc:	0f b6 d2             	movzbl %dl,%edx
  101fdf:	ff 24 95 80 5e 10 00 	jmp    *0x105e80(,%edx,4)
  101fe6:	89 eb                	mov    %ebp,%ebx
  101fe8:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  101fed:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  101ff0:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
  101ff3:	8d 4c 10 d0          	lea    -0x30(%eax,%edx,1),%ecx
				ch = *fmt;
  101ff7:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  101ffa:	8d 50 d0             	lea    -0x30(%eax),%edx
  101ffd:	83 fa 09             	cmp    $0x9,%edx
  102000:	77 31                	ja     102033 <vprintfmt+0xfa>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  102002:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  102005:	eb e6                	jmp    101fed <vprintfmt+0xb4>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  102007:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  10200b:	8d 50 04             	lea    0x4(%eax),%edx
  10200e:	89 54 24 4c          	mov    %edx,0x4c(%esp)
  102012:	8b 00                	mov    (%eax),%eax
  102014:	89 44 24 18          	mov    %eax,0x18(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  102018:	89 eb                	mov    %ebp,%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  10201a:	eb 1b                	jmp    102037 <vprintfmt+0xfe>

		case '.':
			if (width < 0)
  10201c:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  102021:	78 88                	js     101fab <vprintfmt+0x72>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  102023:	89 eb                	mov    %ebp,%ebx
  102025:	eb a0                	jmp    101fc7 <vprintfmt+0x8e>
  102027:	89 eb                	mov    %ebp,%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  102029:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102030:	00 
			goto reswitch;
  102031:	eb 94                	jmp    101fc7 <vprintfmt+0x8e>
  102033:	89 4c 24 18          	mov    %ecx,0x18(%esp)

		process_precision:
			if (width < 0)
  102037:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  10203c:	79 89                	jns    101fc7 <vprintfmt+0x8e>
  10203e:	e9 74 ff ff ff       	jmp    101fb7 <vprintfmt+0x7e>
				width = precision, precision = -1;
			goto reswitch;

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  102043:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  102048:	89 eb                	mov    %ebp,%ebx
			goto reswitch;

			// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  10204a:	e9 78 ff ff ff       	jmp    101fc7 <vprintfmt+0x8e>

			// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  10204f:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  102053:	8d 50 04             	lea    0x4(%eax),%edx
  102056:	89 54 24 4c          	mov    %edx,0x4c(%esp)
  10205a:	83 ec 08             	sub    $0x8,%esp
  10205d:	57                   	push   %edi
  10205e:	ff 30                	pushl  (%eax)
  102060:	ff d6                	call   *%esi
			break;
  102062:	83 c4 10             	add    $0x10,%esp
  102065:	e9 fc fe ff ff       	jmp    101f66 <vprintfmt+0x2d>

			// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  10206a:	8b 44 24 4c          	mov    0x4c(%esp),%eax
  10206e:	8d 50 04             	lea    0x4(%eax),%edx
  102071:	89 54 24 4c          	mov    %edx,0x4c(%esp)
  102075:	8b 18                	mov    (%eax),%ebx
  102077:	85 db                	test   %ebx,%ebx
  102079:	75 05                	jne    102080 <vprintfmt+0x147>
				p = "(null)";
  10207b:	bb 79 5e 10 00       	mov    $0x105e79,%ebx
			if (width > 0 && padc != '-')
  102080:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  102085:	0f 9f c2             	setg   %dl
  102088:	80 7c 24 17 2d       	cmpb   $0x2d,0x17(%esp)
  10208d:	0f 95 c0             	setne  %al
  102090:	84 c2                	test   %al,%dl
  102092:	74 7e                	je     102112 <vprintfmt+0x1d9>
				for (width -= strnlen(p, precision);
  102094:	83 ec 08             	sub    $0x8,%esp
  102097:	ff 74 24 20          	pushl  0x20(%esp)
  10209b:	53                   	push   %ebx
  10209c:	e8 22 fb ff ff       	call   101bc3 <strnlen>
  1020a1:	29 44 24 20          	sub    %eax,0x20(%esp)
  1020a5:	8b 4c 24 20          	mov    0x20(%esp),%ecx
  1020a9:	83 c4 10             	add    $0x10,%esp
  1020ac:	89 6c 24 48          	mov    %ebp,0x48(%esp)
  1020b0:	89 dd                	mov    %ebx,%ebp
  1020b2:	89 cb                	mov    %ecx,%ebx
  1020b4:	eb 12                	jmp    1020c8 <vprintfmt+0x18f>
				     width > 0;
				     width--)
					putch(padc, putdat);
  1020b6:	83 ec 08             	sub    $0x8,%esp
  1020b9:	57                   	push   %edi
  1020ba:	0f be 44 24 23       	movsbl 0x23(%esp),%eax
  1020bf:	50                   	push   %eax
  1020c0:	ff d6                	call   *%esi
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision);
				     width > 0;
				     width--)
  1020c2:	83 eb 01             	sub    $0x1,%ebx
  1020c5:	83 c4 10             	add    $0x10,%esp
			// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision);
  1020c8:	85 db                	test   %ebx,%ebx
  1020ca:	7f ea                	jg     1020b6 <vprintfmt+0x17d>
  1020cc:	89 d9                	mov    %ebx,%ecx
  1020ce:	89 eb                	mov    %ebp,%ebx
  1020d0:	89 d8                	mov    %ebx,%eax
  1020d2:	89 74 24 40          	mov    %esi,0x40(%esp)
  1020d6:	89 ce                	mov    %ecx,%esi
  1020d8:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  1020dc:	eb 46                	jmp    102124 <vprintfmt+0x1eb>
					putch(padc, putdat);
			for (;
			     (ch = *p++) != '\0' &&
				     (precision < 0 || --precision >= 0);
			     width--)
				if (altflag && (ch < ' ' || ch > '~'))
  1020de:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  1020e3:	74 1a                	je     1020ff <vprintfmt+0x1c6>
  1020e5:	0f be c0             	movsbl %al,%eax
  1020e8:	83 e8 20             	sub    $0x20,%eax
  1020eb:	83 f8 5e             	cmp    $0x5e,%eax
  1020ee:	76 0f                	jbe    1020ff <vprintfmt+0x1c6>
					putch('?', putdat);
  1020f0:	83 ec 08             	sub    $0x8,%esp
  1020f3:	57                   	push   %edi
  1020f4:	6a 3f                	push   $0x3f
  1020f6:	ff 54 24 50          	call   *0x50(%esp)
  1020fa:	83 c4 10             	add    $0x10,%esp
  1020fd:	eb 0c                	jmp    10210b <vprintfmt+0x1d2>
				else
					putch(ch, putdat);
  1020ff:	83 ec 08             	sub    $0x8,%esp
  102102:	57                   	push   %edi
  102103:	52                   	push   %edx
  102104:	ff 54 24 50          	call   *0x50(%esp)
  102108:	83 c4 10             	add    $0x10,%esp
				     width--)
					putch(padc, putdat);
			for (;
			     (ch = *p++) != '\0' &&
				     (precision < 0 || --precision >= 0);
			     width--)
  10210b:	83 ee 01             	sub    $0x1,%esi
				for (width -= strnlen(p, precision);
				     width > 0;
				     width--)
					putch(padc, putdat);
			for (;
			     (ch = *p++) != '\0' &&
  10210e:	89 d8                	mov    %ebx,%eax
  102110:	eb 12                	jmp    102124 <vprintfmt+0x1eb>
  102112:	89 d8                	mov    %ebx,%eax
  102114:	89 74 24 40          	mov    %esi,0x40(%esp)
  102118:	8b 74 24 10          	mov    0x10(%esp),%esi
  10211c:	89 6c 24 48          	mov    %ebp,0x48(%esp)
  102120:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  102124:	8d 58 01             	lea    0x1(%eax),%ebx
  102127:	0f b6 00             	movzbl (%eax),%eax
  10212a:	0f be d0             	movsbl %al,%edx
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision);
				     width > 0;
				     width--)
					putch(padc, putdat);
			for (;
  10212d:	85 d2                	test   %edx,%edx
  10212f:	74 25                	je     102156 <vprintfmt+0x21d>
			     (ch = *p++) != '\0' &&
  102131:	85 ed                	test   %ebp,%ebp
  102133:	78 a9                	js     1020de <vprintfmt+0x1a5>
				     (precision < 0 || --precision >= 0);
  102135:	83 ed 01             	sub    $0x1,%ebp
  102138:	79 a4                	jns    1020de <vprintfmt+0x1a5>
  10213a:	89 f3                	mov    %esi,%ebx
  10213c:	8b 74 24 40          	mov    0x40(%esp),%esi
  102140:	8b 6c 24 48          	mov    0x48(%esp),%ebp
  102144:	eb 1a                	jmp    102160 <vprintfmt+0x227>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  102146:	83 ec 08             	sub    $0x8,%esp
  102149:	57                   	push   %edi
  10214a:	6a 20                	push   $0x20
  10214c:	ff d6                	call   *%esi
			     width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  10214e:	83 eb 01             	sub    $0x1,%ebx
  102151:	83 c4 10             	add    $0x10,%esp
  102154:	eb 0a                	jmp    102160 <vprintfmt+0x227>
  102156:	89 f3                	mov    %esi,%ebx
  102158:	8b 74 24 40          	mov    0x40(%esp),%esi
  10215c:	8b 6c 24 48          	mov    0x48(%esp),%ebp
  102160:	85 db                	test   %ebx,%ebx
  102162:	7f e2                	jg     102146 <vprintfmt+0x20d>
  102164:	e9 fd fd ff ff       	jmp    101f66 <vprintfmt+0x2d>
				putch(' ', putdat);
			break;

			// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  102169:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  10216d:	8d 44 24 4c          	lea    0x4c(%esp),%eax
  102171:	e8 97 fd ff ff       	call   101f0d <getint>
  102176:	89 44 24 08          	mov    %eax,0x8(%esp)
  10217a:	89 54 24 0c          	mov    %edx,0xc(%esp)
			if ((long long) num < 0) {
  10217e:	85 d2                	test   %edx,%edx
  102180:	79 75                	jns    1021f7 <vprintfmt+0x2be>
				putch('-', putdat);
  102182:	83 ec 08             	sub    $0x8,%esp
  102185:	57                   	push   %edi
  102186:	6a 2d                	push   $0x2d
  102188:	ff d6                	call   *%esi
				num = -(long long) num;
  10218a:	8b 44 24 18          	mov    0x18(%esp),%eax
  10218e:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  102192:	f7 d8                	neg    %eax
  102194:	83 d2 00             	adc    $0x0,%edx
  102197:	f7 da                	neg    %edx
  102199:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  10219c:	bb 0a 00 00 00       	mov    $0xa,%ebx
  1021a1:	eb 59                	jmp    1021fc <vprintfmt+0x2c3>
			goto number;

			// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  1021a3:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  1021a7:	8d 44 24 4c          	lea    0x4c(%esp),%eax
  1021ab:	e8 29 fd ff ff       	call   101ed9 <getuint>
			base = 10;
  1021b0:	bb 0a 00 00 00       	mov    $0xa,%ebx
			goto number;
  1021b5:	eb 45                	jmp    1021fc <vprintfmt+0x2c3>
		case 'o':
      // TODO

			// pointer
		case 'p':
			putch('0', putdat);
  1021b7:	83 ec 08             	sub    $0x8,%esp
  1021ba:	57                   	push   %edi
  1021bb:	6a 30                	push   $0x30
  1021bd:	ff d6                	call   *%esi
			putch('x', putdat);
  1021bf:	83 c4 08             	add    $0x8,%esp
  1021c2:	57                   	push   %edi
  1021c3:	6a 78                	push   $0x78
  1021c5:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  1021c7:	8b 44 24 5c          	mov    0x5c(%esp),%eax
  1021cb:	8d 50 04             	lea    0x4(%eax),%edx
  1021ce:	89 54 24 5c          	mov    %edx,0x5c(%esp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  1021d2:	8b 00                	mov    (%eax),%eax
  1021d4:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  1021d9:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  1021dc:	bb 10 00 00 00       	mov    $0x10,%ebx
			goto number;
  1021e1:	eb 19                	jmp    1021fc <vprintfmt+0x2c3>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  1021e3:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  1021e7:	8d 44 24 4c          	lea    0x4c(%esp),%eax
  1021eb:	e8 e9 fc ff ff       	call   101ed9 <getuint>
			base = 16;
  1021f0:	bb 10 00 00 00       	mov    $0x10,%ebx
  1021f5:	eb 05                	jmp    1021fc <vprintfmt+0x2c3>
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  1021f7:	bb 0a 00 00 00       	mov    $0xa,%ebx
			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  1021fc:	83 ec 0c             	sub    $0xc,%esp
  1021ff:	0f be 4c 24 23       	movsbl 0x23(%esp),%ecx
  102204:	51                   	push   %ecx
  102205:	ff 74 24 20          	pushl  0x20(%esp)
  102209:	53                   	push   %ebx
  10220a:	52                   	push   %edx
  10220b:	50                   	push   %eax
  10220c:	89 fa                	mov    %edi,%edx
  10220e:	89 f0                	mov    %esi,%eax
  102210:	e8 0e fc ff ff       	call   101e23 <printnum>
			break;
  102215:	83 c4 20             	add    $0x20,%esp
  102218:	e9 49 fd ff ff       	jmp    101f66 <vprintfmt+0x2d>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  10221d:	83 ec 08             	sub    $0x8,%esp
  102220:	57                   	push   %edi
  102221:	50                   	push   %eax
  102222:	ff d6                	call   *%esi
			break;
  102224:	83 c4 10             	add    $0x10,%esp
  102227:	e9 3a fd ff ff       	jmp    101f66 <vprintfmt+0x2d>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  10222c:	83 ec 08             	sub    $0x8,%esp
  10222f:	57                   	push   %edi
  102230:	6a 25                	push   $0x25
  102232:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  102234:	83 c4 10             	add    $0x10,%esp
  102237:	89 dd                	mov    %ebx,%ebp
  102239:	eb 03                	jmp    10223e <vprintfmt+0x305>
  10223b:	83 ed 01             	sub    $0x1,%ebp
  10223e:	80 7d ff 25          	cmpb   $0x25,-0x1(%ebp)
  102242:	75 f7                	jne    10223b <vprintfmt+0x302>
  102244:	e9 1d fd ff ff       	jmp    101f66 <vprintfmt+0x2d>
				/* do nothing */;
			break;
		}
	}
}
  102249:	83 c4 2c             	add    $0x2c,%esp
  10224c:	5b                   	pop    %ebx
  10224d:	5e                   	pop    %esi
  10224e:	5f                   	pop    %edi
  10224f:	5d                   	pop    %ebp
  102250:	c3                   	ret    

00102251 <tss_switch>:

segdesc_t gdt_LOC[CPU_GDT_NDESC];
tss_t tss_LOC[64];

void tss_switch(uint32_t pid)
{
  102251:	83 ec 18             	sub    $0x18,%esp
	gdt_LOC[CPU_GDT_TSS >> 3] =
		SEGDESC16(STS_T32A,
  102254:	69 44 24 1c ec 00 00 	imul   $0xec,0x1c(%esp),%eax
  10225b:	00 
  10225c:	05 40 80 9a 01       	add    $0x19a8040,%eax
  102261:	89 c1                	mov    %eax,%ecx
  102263:	c1 e9 10             	shr    $0x10,%ecx
  102266:	89 c2                	mov    %eax,%edx
  102268:	c1 ea 18             	shr    $0x18,%edx
segdesc_t gdt_LOC[CPU_GDT_NDESC];
tss_t tss_LOC[64];

void tss_switch(uint32_t pid)
{
	gdt_LOC[CPU_GDT_TSS >> 3] =
  10226b:	66 c7 05 28 80 9a 01 	movw   $0xeb,0x19a8028
  102272:	eb 00 
  102274:	66 a3 2a 80 9a 01    	mov    %ax,0x19a802a
  10227a:	88 0d 2c 80 9a 01    	mov    %cl,0x19a802c
  102280:	0f b6 05 2d 80 9a 01 	movzbl 0x19a802d,%eax
  102287:	83 e0 f0             	and    $0xfffffff0,%eax
  10228a:	83 c8 19             	or     $0x19,%eax
  10228d:	83 e0 9f             	and    $0xffffff9f,%eax
  102290:	83 c8 80             	or     $0xffffff80,%eax
  102293:	c6 05 2e 80 9a 01 40 	movb   $0x40,0x19a802e
  10229a:	88 15 2f 80 9a 01    	mov    %dl,0x19a802f
		SEGDESC16(STS_T32A,
			  (uint32_t) (&tss_LOC[pid]), sizeof(tss_t) - 1, 0);
	gdt_LOC[CPU_GDT_TSS >> 3].sd_s = 0;
  1022a0:	83 e0 ef             	and    $0xffffffef,%eax
  1022a3:	a2 2d 80 9a 01       	mov    %al,0x19a802d
	ltr(CPU_GDT_TSS);
  1022a8:	6a 28                	push   $0x28
  1022aa:	e8 5d 03 00 00       	call   10260c <ltr>
}
  1022af:	83 c4 1c             	add    $0x1c,%esp
  1022b2:	c3                   	ret    

001022b3 <seg_init>:

void seg_init (void)
{
  1022b3:	56                   	push   %esi
  1022b4:	53                   	push   %ebx
  1022b5:	83 ec 1c             	sub    $0x1c,%esp
	/* clear BSS */
	extern uint8_t end[], edata[];
	memzero (edata, bsp_kstack - edata);
  1022b8:	b8 00 70 96 01       	mov    $0x1967000,%eax
  1022bd:	2d f0 47 12 00       	sub    $0x1247f0,%eax
  1022c2:	50                   	push   %eax
  1022c3:	68 f0 47 12 00       	push   $0x1247f0
  1022c8:	e8 5d f9 ff ff       	call   101c2a <memzero>
	memzero (bsp_kstack + 4096, end - bsp_kstack - 4096);
  1022cd:	b8 20 cc de 01       	mov    $0x1decc20,%eax
  1022d2:	2d 00 70 96 01       	sub    $0x1967000,%eax
  1022d7:	83 c4 08             	add    $0x8,%esp
  1022da:	50                   	push   %eax
  1022db:	68 00 80 96 01       	push   $0x1968000
  1022e0:	e8 45 f9 ff ff       	call   101c2a <memzero>

	/* setup GDT */
	gdt_LOC[0] = SEGDESC_NULL
  1022e5:	c7 05 00 80 9a 01 00 	movl   $0x0,0x19a8000
  1022ec:	00 00 00 
  1022ef:	c7 05 04 80 9a 01 00 	movl   $0x0,0x19a8004
  1022f6:	00 00 00 
	;
	/* 0x08: kernel code */
	gdt_LOC[CPU_GDT_KCODE >> 3] = SEGDESC32(STA_X | STA_R, 0x0, 0xffffffff, 0);
  1022f9:	66 c7 05 08 80 9a 01 	movw   $0xffff,0x19a8008
  102300:	ff ff 
  102302:	66 c7 05 0a 80 9a 01 	movw   $0x0,0x19a800a
  102309:	00 00 
  10230b:	c6 05 0c 80 9a 01 00 	movb   $0x0,0x19a800c
  102312:	0f b6 05 0d 80 9a 01 	movzbl 0x19a800d,%eax
  102319:	83 e0 f0             	and    $0xfffffff0,%eax
  10231c:	83 c8 1a             	or     $0x1a,%eax
  10231f:	83 e0 9f             	and    $0xffffff9f,%eax
  102322:	83 c8 80             	or     $0xffffff80,%eax
  102325:	a2 0d 80 9a 01       	mov    %al,0x19a800d
  10232a:	0f b6 05 0e 80 9a 01 	movzbl 0x19a800e,%eax
  102331:	83 c8 0f             	or     $0xf,%eax
  102334:	83 e0 cf             	and    $0xffffffcf,%eax
  102337:	83 c8 c0             	or     $0xffffffc0,%eax
  10233a:	a2 0e 80 9a 01       	mov    %al,0x19a800e
  10233f:	c6 05 0f 80 9a 01 00 	movb   $0x0,0x19a800f
	/* 0x10: kernel data */
	gdt_LOC[CPU_GDT_KDATA >> 3] = SEGDESC32(STA_W, 0x0, 0xffffffff, 0);
  102346:	66 c7 05 10 80 9a 01 	movw   $0xffff,0x19a8010
  10234d:	ff ff 
  10234f:	66 c7 05 12 80 9a 01 	movw   $0x0,0x19a8012
  102356:	00 00 
  102358:	c6 05 14 80 9a 01 00 	movb   $0x0,0x19a8014
  10235f:	0f b6 05 15 80 9a 01 	movzbl 0x19a8015,%eax
  102366:	83 e0 f0             	and    $0xfffffff0,%eax
  102369:	83 c8 12             	or     $0x12,%eax
  10236c:	83 e0 9f             	and    $0xffffff9f,%eax
  10236f:	83 c8 80             	or     $0xffffff80,%eax
  102372:	a2 15 80 9a 01       	mov    %al,0x19a8015
  102377:	0f b6 05 16 80 9a 01 	movzbl 0x19a8016,%eax
  10237e:	83 c8 0f             	or     $0xf,%eax
  102381:	83 e0 cf             	and    $0xffffffcf,%eax
  102384:	83 c8 c0             	or     $0xffffffc0,%eax
  102387:	a2 16 80 9a 01       	mov    %al,0x19a8016
  10238c:	c6 05 17 80 9a 01 00 	movb   $0x0,0x19a8017
	/* 0x18: user code */
	gdt_LOC[CPU_GDT_UCODE >> 3] = SEGDESC32(STA_X | STA_R, 0x00000000,
  102393:	66 c7 05 18 80 9a 01 	movw   $0xffff,0x19a8018
  10239a:	ff ff 
  10239c:	66 c7 05 1a 80 9a 01 	movw   $0x0,0x19a801a
  1023a3:	00 00 
  1023a5:	c6 05 1c 80 9a 01 00 	movb   $0x0,0x19a801c
  1023ac:	c6 05 1d 80 9a 01 fa 	movb   $0xfa,0x19a801d
  1023b3:	0f b6 05 1e 80 9a 01 	movzbl 0x19a801e,%eax
  1023ba:	83 c8 0f             	or     $0xf,%eax
  1023bd:	83 e0 cf             	and    $0xffffffcf,%eax
  1023c0:	83 c8 c0             	or     $0xffffffc0,%eax
  1023c3:	a2 1e 80 9a 01       	mov    %al,0x19a801e
  1023c8:	c6 05 1f 80 9a 01 00 	movb   $0x0,0x19a801f
		0xffffffff, 3);
	/* 0x20: user data */
	gdt_LOC[CPU_GDT_UDATA >> 3] = SEGDESC32(STA_W, 0x00000000, 0xffffffff, 3);
  1023cf:	66 c7 05 20 80 9a 01 	movw   $0xffff,0x19a8020
  1023d6:	ff ff 
  1023d8:	66 c7 05 22 80 9a 01 	movw   $0x0,0x19a8022
  1023df:	00 00 
  1023e1:	c6 05 24 80 9a 01 00 	movb   $0x0,0x19a8024
  1023e8:	c6 05 25 80 9a 01 f2 	movb   $0xf2,0x19a8025
  1023ef:	0f b6 05 26 80 9a 01 	movzbl 0x19a8026,%eax
  1023f6:	83 c8 0f             	or     $0xf,%eax
  1023f9:	83 e0 cf             	and    $0xffffffcf,%eax
  1023fc:	83 c8 c0             	or     $0xffffffc0,%eax
  1023ff:	a2 26 80 9a 01       	mov    %al,0x19a8026
  102404:	c6 05 27 80 9a 01 00 	movb   $0x0,0x19a8027

	/* setup TSS */
	tss0.ts_esp0 = (uint32_t) bsp_kstack + 4096;
  10240b:	ba 60 5e 12 00       	mov    $0x125e60,%edx
  102410:	c7 05 64 5e 12 00 00 	movl   $0x1968000,0x125e64
  102417:	80 96 01 
	tss0.ts_ss0 = CPU_GDT_KDATA;
  10241a:	66 c7 05 68 5e 12 00 	movw   $0x10,0x125e68
  102421:	10 00 
	gdt_LOC[CPU_GDT_TSS >> 3] = SEGDESC16(STS_T32A, (uint32_t) (&tss0),
  102423:	66 c7 05 28 80 9a 01 	movw   $0xeb,0x19a8028
  10242a:	eb 00 
  10242c:	66 89 15 2a 80 9a 01 	mov    %dx,0x19a802a
  102433:	89 d0                	mov    %edx,%eax
  102435:	c1 e8 10             	shr    $0x10,%eax
  102438:	a2 2c 80 9a 01       	mov    %al,0x19a802c
  10243d:	0f b6 05 2d 80 9a 01 	movzbl 0x19a802d,%eax
  102444:	83 e0 f0             	and    $0xfffffff0,%eax
  102447:	83 c8 19             	or     $0x19,%eax
  10244a:	83 e0 9f             	and    $0xffffff9f,%eax
  10244d:	83 c8 80             	or     $0xffffff80,%eax
  102450:	c6 05 2e 80 9a 01 40 	movb   $0x40,0x19a802e
  102457:	c1 ea 18             	shr    $0x18,%edx
  10245a:	88 15 2f 80 9a 01    	mov    %dl,0x19a802f
		sizeof(tss_t) - 1, 0);
	gdt_LOC[CPU_GDT_TSS >> 3].sd_s = 0;
  102460:	83 e0 ef             	and    $0xffffffef,%eax
  102463:	a2 2d 80 9a 01       	mov    %al,0x19a802d

	pseudodesc_t gdt_desc =
  102468:	66 c7 44 24 1a 2f 00 	movw   $0x2f,0x1a(%esp)
  10246f:	c7 44 24 1c 00 80 9a 	movl   $0x19a8000,0x1c(%esp)
  102476:	01 
		{ .pd_lim = sizeof(gdt_LOC) - 1, .pd_base = (uint32_t) gdt_LOC };
	asm volatile("lgdt %0" :: "m" (gdt_desc));
  102477:	0f 01 54 24 1a       	lgdtl  0x1a(%esp)
	asm volatile("movw %%ax,%%gs" :: "a" (CPU_GDT_KDATA));
  10247c:	b8 10 00 00 00       	mov    $0x10,%eax
  102481:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (CPU_GDT_KDATA));
  102483:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" :: "a" (CPU_GDT_KDATA));
  102485:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (CPU_GDT_KDATA));
  102487:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (CPU_GDT_KDATA));
  102489:	8e d0                	mov    %eax,%ss
	/* reload %cs */
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (CPU_GDT_KCODE));
  10248b:	ea 92 24 10 00 08 00 	ljmp   $0x8,$0x102492

	/*
	 * Load a null LDT.
	 */
	lldt (0);
  102492:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102499:	e8 e3 00 00 00       	call   102581 <lldt>

	/*
	 * Load the bootstrap TSS.
	 */
	ltr (CPU_GDT_TSS);
  10249e:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
  1024a5:	e8 62 01 00 00       	call   10260c <ltr>

	/*
	 * Load IDT.
	 */
	extern pseudodesc_t idt_pd;
	asm volatile("lidt %0" : : "m" (idt_pd));
  1024aa:	0f 01 1d 00 ac 10 00 	lidtl  0x10ac00

	/*
	 * Initialize all TSS structures for processes.
	 */
	unsigned int pid;
	memzero (tss_LOC, sizeof(tss_t) * 64);
  1024b1:	83 c4 08             	add    $0x8,%esp
  1024b4:	68 00 3b 00 00       	push   $0x3b00
  1024b9:	68 40 80 9a 01       	push   $0x19a8040
  1024be:	e8 67 f7 ff ff       	call   101c2a <memzero>
	memzero (STACK_LOC, sizeof(char) * 64 * 4096);
  1024c3:	83 c4 08             	add    $0x8,%esp
  1024c6:	68 00 00 04 00       	push   $0x40000
  1024cb:	68 00 80 96 01       	push   $0x1968000
  1024d0:	e8 55 f7 ff ff       	call   101c2a <memzero>
	for (pid = 0; pid < 64; pid++)
  1024d5:	83 c4 10             	add    $0x10,%esp
  1024d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  1024dd:	eb 4f                	jmp    10252e <seg_init+0x27b>
	{
		tss_LOC[pid].ts_esp0 = (uint32_t) STACK_LOC[pid] + 4096;
  1024df:	89 da                	mov    %ebx,%edx
  1024e1:	c1 e2 0c             	shl    $0xc,%edx
  1024e4:	81 c2 00 90 96 01    	add    $0x1969000,%edx
  1024ea:	69 c3 ec 00 00 00    	imul   $0xec,%ebx,%eax
  1024f0:	8d b0 40 80 9a 01    	lea    0x19a8040(%eax),%esi
  1024f6:	89 90 44 80 9a 01    	mov    %edx,0x19a8044(%eax)
		tss_LOC[pid].ts_ss0 = CPU_GDT_KDATA;
  1024fc:	66 c7 80 48 80 9a 01 	movw   $0x10,0x19a8048(%eax)
  102503:	10 00 
		tss_LOC[pid].ts_iomb = offsetof(tss_t, ts_iopm);
  102505:	66 c7 80 a6 80 9a 01 	movw   $0x68,0x19a80a6(%eax)
  10250c:	68 00 
		memzero (tss_LOC[pid].ts_iopm, sizeof(uint8_t) * 128);
  10250e:	05 a8 80 9a 01       	add    $0x19a80a8,%eax
  102513:	83 ec 08             	sub    $0x8,%esp
  102516:	68 80 00 00 00       	push   $0x80
  10251b:	50                   	push   %eax
  10251c:	e8 09 f7 ff ff       	call   101c2a <memzero>
		tss_LOC[pid].ts_iopm[128] = 0xff;
  102521:	c6 86 e8 00 00 00 ff 	movb   $0xff,0xe8(%esi)
	 * Initialize all TSS structures for processes.
	 */
	unsigned int pid;
	memzero (tss_LOC, sizeof(tss_t) * 64);
	memzero (STACK_LOC, sizeof(char) * 64 * 4096);
	for (pid = 0; pid < 64; pid++)
  102528:	83 c3 01             	add    $0x1,%ebx
  10252b:	83 c4 10             	add    $0x10,%esp
  10252e:	83 fb 3f             	cmp    $0x3f,%ebx
  102531:	76 ac                	jbe    1024df <seg_init+0x22c>
		tss_LOC[pid].ts_ss0 = CPU_GDT_KDATA;
		tss_LOC[pid].ts_iomb = offsetof(tss_t, ts_iopm);
		memzero (tss_LOC[pid].ts_iopm, sizeof(uint8_t) * 128);
		tss_LOC[pid].ts_iopm[128] = 0xff;
	}
}
  102533:	83 c4 14             	add    $0x14,%esp
  102536:	5b                   	pop    %ebx
  102537:	5e                   	pop    %esi
  102538:	c3                   	ret    

00102539 <max>:
#include "types.h"

uint32_t
max(uint32_t a, uint32_t b)
{
  102539:	8b 54 24 04          	mov    0x4(%esp),%edx
  10253d:	8b 44 24 08          	mov    0x8(%esp),%eax
	return (a > b) ? a : b;
  102541:	39 d0                	cmp    %edx,%eax
  102543:	0f 42 c2             	cmovb  %edx,%eax
}
  102546:	c3                   	ret    

00102547 <min>:

uint32_t
min(uint32_t a, uint32_t b)
{
  102547:	8b 54 24 04          	mov    0x4(%esp),%edx
  10254b:	8b 44 24 08          	mov    0x8(%esp),%eax
	return (a < b) ? a : b;
  10254f:	39 d0                	cmp    %edx,%eax
  102551:	0f 47 c2             	cmova  %edx,%eax
}
  102554:	c3                   	ret    

00102555 <rounddown>:

uint32_t
rounddown(uint32_t a, uint32_t n)
{
  102555:	8b 4c 24 04          	mov    0x4(%esp),%ecx
	return a - a % n;
  102559:	89 c8                	mov    %ecx,%eax
  10255b:	ba 00 00 00 00       	mov    $0x0,%edx
  102560:	f7 74 24 08          	divl   0x8(%esp)
  102564:	89 c8                	mov    %ecx,%eax
  102566:	29 d0                	sub    %edx,%eax
}
  102568:	c3                   	ret    

00102569 <roundup>:

uint32_t
roundup(uint32_t a, uint32_t n)
{
  102569:	8b 54 24 08          	mov    0x8(%esp),%edx
	return rounddown(a+n-1, n);
  10256d:	89 d0                	mov    %edx,%eax
  10256f:	03 44 24 04          	add    0x4(%esp),%eax
  102573:	52                   	push   %edx
  102574:	83 e8 01             	sub    $0x1,%eax
  102577:	50                   	push   %eax
  102578:	e8 d8 ff ff ff       	call   102555 <rounddown>
  10257d:	83 c4 08             	add    $0x8,%esp
}
  102580:	c3                   	ret    

00102581 <lldt>:
#include "x86.h"

gcc_inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
  102581:	8b 44 24 04          	mov    0x4(%esp),%eax
  102585:	0f 00 d0             	lldt   %ax
  102588:	c3                   	ret    

00102589 <cli>:
}

gcc_inline void
cli(void)
{
	__asm __volatile("cli":::"memory");
  102589:	fa                   	cli    
  10258a:	c3                   	ret    

0010258b <sti>:
}

gcc_inline void
sti(void)
{
	__asm __volatile("sti;nop");
  10258b:	fb                   	sti    
  10258c:	90                   	nop
  10258d:	c3                   	ret    

0010258e <rdmsr>:

gcc_inline uint64_t
rdmsr(uint32_t msr)
{
	uint64_t rv;
	__asm __volatile("rdmsr" : "=A" (rv) : "c" (msr));
  10258e:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  102592:	0f 32                	rdmsr  
	return rv;
}
  102594:	c3                   	ret    

00102595 <wrmsr>:

gcc_inline void
wrmsr(uint32_t msr, uint64_t newval)
{
        __asm __volatile("wrmsr" : : "A" (newval), "c" (msr));
  102595:	8b 44 24 08          	mov    0x8(%esp),%eax
  102599:	8b 54 24 0c          	mov    0xc(%esp),%edx
  10259d:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  1025a1:	0f 30                	wrmsr  
  1025a3:	c3                   	ret    

001025a4 <halt>:
}

gcc_inline void
halt(void)
{
	__asm __volatile("hlt");
  1025a4:	f4                   	hlt    
  1025a5:	c3                   	ret    

001025a6 <rdtsc>:
gcc_inline uint64_t
rdtsc(void)
{
	uint64_t rv;

	__asm __volatile("rdtsc" : "=A" (rv));
  1025a6:	0f 31                	rdtsc  
	return (rv);
}
  1025a8:	c3                   	ret    

001025a9 <enable_sse>:

gcc_inline uint32_t
rcr4(void)
{
	uint32_t cr4;
	__asm __volatile("movl %%cr4,%0" : "=r" (cr4));
  1025a9:	0f 20 e0             	mov    %cr4,%eax
gcc_inline void
enable_sse(void)
{
	uint32_t cr0, cr4;

	cr4 = rcr4() | CR4_OSFXSR | CR4_OSXMMEXCPT;
  1025ac:	80 cc 06             	or     $0x6,%ah
	FENCE();
  1025af:	0f ae f0             	mfence 
}

gcc_inline void
lcr4(uint32_t val)
{
	__asm __volatile("movl %0,%%cr4" : : "r" (val));
  1025b2:	0f 22 e0             	mov    %eax,%cr4

gcc_inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
  1025b5:	0f 20 c0             	mov    %cr0,%eax
	cr4 = rcr4() | CR4_OSFXSR | CR4_OSXMMEXCPT;
	FENCE();
	lcr4(cr4);

	cr0 = rcr0() | CR0_MP;
	FENCE();
  1025b8:	0f ae f0             	mfence 
  1025bb:	c3                   	ret    

001025bc <cpuid>:
}

gcc_inline void
cpuid(uint32_t info,
      uint32_t *eaxp, uint32_t *ebxp, uint32_t *ecxp, uint32_t *edxp)
{
  1025bc:	55                   	push   %ebp
  1025bd:	57                   	push   %edi
  1025be:	56                   	push   %esi
  1025bf:	53                   	push   %ebx
  1025c0:	8b 44 24 14          	mov    0x14(%esp),%eax
  1025c4:	8b 7c 24 18          	mov    0x18(%esp),%edi
  1025c8:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
  1025cc:	8b 74 24 24          	mov    0x24(%esp),%esi
	uint32_t eax, ebx, ecx, edx;
	__asm __volatile("cpuid"
  1025d0:	0f a2                	cpuid  
			 : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx)
			 : "a" (info));
	if (eaxp)
  1025d2:	85 ff                	test   %edi,%edi
  1025d4:	74 02                	je     1025d8 <cpuid+0x1c>
		*eaxp = eax;
  1025d6:	89 07                	mov    %eax,(%edi)
	if (ebxp)
  1025d8:	85 ed                	test   %ebp,%ebp
  1025da:	74 03                	je     1025df <cpuid+0x23>
		*ebxp = ebx;
  1025dc:	89 5d 00             	mov    %ebx,0x0(%ebp)
	if (ecxp)
  1025df:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
  1025e4:	74 06                	je     1025ec <cpuid+0x30>
		*ecxp = ecx;
  1025e6:	8b 44 24 20          	mov    0x20(%esp),%eax
  1025ea:	89 08                	mov    %ecx,(%eax)
	if (edxp)
  1025ec:	85 f6                	test   %esi,%esi
  1025ee:	74 02                	je     1025f2 <cpuid+0x36>
		*edxp = edx;
  1025f0:	89 16                	mov    %edx,(%esi)
}
  1025f2:	5b                   	pop    %ebx
  1025f3:	5e                   	pop    %esi
  1025f4:	5f                   	pop    %edi
  1025f5:	5d                   	pop    %ebp
  1025f6:	c3                   	ret    

001025f7 <rcr3>:

gcc_inline uint32_t
rcr3(void)
{
    uint32_t val;
    __asm __volatile("movl %%cr3,%0" : "=r" (val));
  1025f7:	0f 20 d8             	mov    %cr3,%eax
    return val;
}
  1025fa:	c3                   	ret    

001025fb <outl>:

gcc_inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
  1025fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  1025ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  102603:	ef                   	out    %eax,(%dx)
  102604:	c3                   	ret    

00102605 <inl>:

gcc_inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
  102605:	8b 54 24 04          	mov    0x4(%esp),%edx
  102609:	ed                   	in     (%dx),%eax
	return data;
}
  10260a:	c3                   	ret    

0010260b <smp_wmb>:

gcc_inline void
smp_wmb(void)
{
	__asm __volatile("":::"memory");
  10260b:	c3                   	ret    

0010260c <ltr>:


gcc_inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
  10260c:	8b 44 24 04          	mov    0x4(%esp),%eax
  102610:	0f 00 d8             	ltr    %ax
  102613:	c3                   	ret    

00102614 <lcr0>:
}

gcc_inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
  102614:	8b 44 24 04          	mov    0x4(%esp),%eax
  102618:	0f 22 c0             	mov    %eax,%cr0
  10261b:	c3                   	ret    

0010261c <rcr0>:

gcc_inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
  10261c:	0f 20 c0             	mov    %cr0,%eax
	return val;
}
  10261f:	c3                   	ret    

00102620 <rcr2>:

gcc_inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
  102620:	0f 20 d0             	mov    %cr2,%eax
	return val;
}
  102623:	c3                   	ret    

00102624 <lcr3>:

gcc_inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
  102624:	8b 44 24 04          	mov    0x4(%esp),%eax
  102628:	0f 22 d8             	mov    %eax,%cr3
  10262b:	c3                   	ret    

0010262c <lcr4>:
}

gcc_inline void
lcr4(uint32_t val)
{
	__asm __volatile("movl %0,%%cr4" : : "r" (val));
  10262c:	8b 44 24 04          	mov    0x4(%esp),%eax
  102630:	0f 22 e0             	mov    %eax,%cr4
  102633:	c3                   	ret    

00102634 <rcr4>:

gcc_inline uint32_t
rcr4(void)
{
	uint32_t cr4;
	__asm __volatile("movl %%cr4,%0" : "=r" (cr4));
  102634:	0f 20 e0             	mov    %cr4,%eax
	return cr4;
}
  102637:	c3                   	ret    

00102638 <inb>:

gcc_inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  102638:	8b 54 24 04          	mov    0x4(%esp),%edx
  10263c:	ec                   	in     (%dx),%al
	return data;
}
  10263d:	c3                   	ret    

0010263e <insl>:

gcc_inline void
insl(int port, void *addr, int cnt)
{
  10263e:	57                   	push   %edi
	__asm __volatile("cld\n\trepne\n\tinsl"                 :
  10263f:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  102643:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  102647:	8b 54 24 08          	mov    0x8(%esp),%edx
  10264b:	fc                   	cld    
  10264c:	f2 6d                	repnz insl (%dx),%es:(%edi)
			 "=D" (addr), "=c" (cnt)                :
			 "d" (port), "0" (addr), "1" (cnt)      :
			 "memory", "cc");
}
  10264e:	5f                   	pop    %edi
  10264f:	c3                   	ret    

00102650 <outb>:

gcc_inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  102650:	8b 44 24 08          	mov    0x8(%esp),%eax
  102654:	8b 54 24 04          	mov    0x4(%esp),%edx
  102658:	ee                   	out    %al,(%dx)
  102659:	c3                   	ret    

0010265a <outsw>:
}

gcc_inline void
outsw(int port, const void *addr, int cnt)
{
  10265a:	56                   	push   %esi
	__asm __volatile("cld\n\trepne\n\toutsw"                :
  10265b:	8b 74 24 0c          	mov    0xc(%esp),%esi
  10265f:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  102663:	8b 54 24 08          	mov    0x8(%esp),%edx
  102667:	fc                   	cld    
  102668:	f2 66 6f             	repnz outsw %ds:(%esi),(%dx)
			 "=S" (addr), "=c" (cnt)                :
			 "d" (port), "0" (addr), "1" (cnt)      :
			 "cc");
}
  10266b:	5e                   	pop    %esi
  10266c:	c3                   	ret    

0010266d <mon_start_user>:
extern void set_curid(unsigned int);
extern void kctx_switch(unsigned int, unsigned int);

int
mon_start_user (int argc, char **argv, struct Trapframe *tf)
{
  10266d:	53                   	push   %ebx
  10266e:	83 ec 10             	sub    $0x10,%esp
    unsigned int idle_pid;
    idle_pid = proc_create (_binary___obj_user_idle_idle_start, 10000);
  102671:	68 10 27 00 00       	push   $0x2710
  102676:	68 08 ac 10 00       	push   $0x10ac08
  10267b:	e8 d0 28 00 00       	call   104f50 <proc_create>
  102680:	89 c3                	mov    %eax,%ebx
    KERN_DEBUG("process idle %d is created.\n", idle_pid);
  102682:	50                   	push   %eax
  102683:	68 d8 5f 10 00       	push   $0x105fd8
  102688:	6a 2d                	push   $0x2d
  10268a:	68 f5 5f 10 00       	push   $0x105ff5
  10268f:	e8 fa f5 ff ff       	call   101c8e <debug_normal>

    KERN_INFO("Start user-space ... \n");
  102694:	83 c4 14             	add    $0x14,%esp
  102697:	68 08 60 10 00       	push   $0x106008
  10269c:	e8 d5 f5 ff ff       	call   101c76 <debug_info>

    tqueue_remove (NUM_IDS, idle_pid);
  1026a1:	83 c4 08             	add    $0x8,%esp
  1026a4:	53                   	push   %ebx
  1026a5:	6a 40                	push   $0x40
  1026a7:	e8 64 22 00 00       	call   104910 <tqueue_remove>
    tcb_set_state (idle_pid, TSTATE_RUN);
  1026ac:	83 c4 08             	add    $0x8,%esp
  1026af:	6a 01                	push   $0x1
  1026b1:	53                   	push   %ebx
  1026b2:	e8 49 1f 00 00       	call   104600 <tcb_set_state>
    set_curid (idle_pid);
  1026b7:	89 1c 24             	mov    %ebx,(%esp)
  1026ba:	e8 f1 26 00 00       	call   104db0 <set_curid>
    kctx_switch (0, idle_pid);
  1026bf:	83 c4 08             	add    $0x8,%esp
  1026c2:	53                   	push   %ebx
  1026c3:	6a 00                	push   $0x0
  1026c5:	e8 f6 1d 00 00       	call   1044c0 <kctx_switch>

    KERN_PANIC("mon_startuser() should never reach here.\n");
  1026ca:	83 c4 0c             	add    $0xc,%esp
  1026cd:	68 0c 61 10 00       	push   $0x10610c
  1026d2:	6a 36                	push   $0x36
  1026d4:	68 f5 5f 10 00       	push   $0x105ff5
  1026d9:	e8 da f5 ff ff       	call   101cb8 <debug_panic>
}
  1026de:	83 c4 18             	add    $0x18,%esp
  1026e1:	5b                   	pop    %ebx
  1026e2:	c3                   	ret    

001026e3 <mon_help>:

int
mon_help (int argc, char **argv, struct Trapframe *tf)
{
  1026e3:	53                   	push   %ebx
  1026e4:	83 ec 08             	sub    $0x8,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
  1026e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  1026ec:	eb 2b                	jmp    102719 <mon_help+0x36>
		dprintf("%s - %s\n", commands[i].name, commands[i].desc);
  1026ee:	83 ec 04             	sub    $0x4,%esp
  1026f1:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
  1026f4:	01 d8                	add    %ebx,%eax
  1026f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1026fd:	ff b2 24 62 10 00    	pushl  0x106224(%edx)
  102703:	ff b2 20 62 10 00    	pushl  0x106220(%edx)
  102709:	68 1f 60 10 00       	push   $0x10601f
  10270e:	e8 f8 f6 ff ff       	call   101e0b <dprintf>
int
mon_help (int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
  102713:	83 c3 01             	add    $0x1,%ebx
  102716:	83 c4 10             	add    $0x10,%esp
  102719:	83 fb 02             	cmp    $0x2,%ebx
  10271c:	76 d0                	jbe    1026ee <mon_help+0xb>
		dprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}
  10271e:	b8 00 00 00 00       	mov    $0x0,%eax
  102723:	83 c4 08             	add    $0x8,%esp
  102726:	5b                   	pop    %ebx
  102727:	c3                   	ret    

00102728 <mon_kerninfo>:

int
mon_kerninfo (int argc, char **argv, struct Trapframe *tf)
{
  102728:	83 ec 18             	sub    $0x18,%esp
	extern uint8_t start[], etext[], edata[], end[];

	dprintf("Special kernel symbols:\n");
  10272b:	68 28 60 10 00       	push   $0x106028
  102730:	e8 d6 f6 ff ff       	call   101e0b <dprintf>
	dprintf("  start  %08x\n", start);
  102735:	83 c4 08             	add    $0x8,%esp
  102738:	68 08 2e 10 00       	push   $0x102e08
  10273d:	68 41 60 10 00       	push   $0x106041
  102742:	e8 c4 f6 ff ff       	call   101e0b <dprintf>
	dprintf("  etext  %08x\n", etext);
  102747:	83 c4 08             	add    $0x8,%esp
  10274a:	68 61 5a 10 00       	push   $0x105a61
  10274f:	68 50 60 10 00       	push   $0x106050
  102754:	e8 b2 f6 ff ff       	call   101e0b <dprintf>
	dprintf("  edata  %08x\n", edata);
  102759:	83 c4 08             	add    $0x8,%esp
  10275c:	68 f0 47 12 00       	push   $0x1247f0
  102761:	68 5f 60 10 00       	push   $0x10605f
  102766:	e8 a0 f6 ff ff       	call   101e0b <dprintf>
	dprintf("  end    %08x\n", end);
  10276b:	83 c4 08             	add    $0x8,%esp
  10276e:	68 20 dc de 01       	push   $0x1dedc20
  102773:	68 6e 60 10 00       	push   $0x10606e
  102778:	e8 8e f6 ff ff       	call   101e0b <dprintf>
	dprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - start, 1024) / 1024);
  10277d:	b8 20 dc de 01       	mov    $0x1dedc20,%eax
  102782:	2d 09 2a 10 00       	sub    $0x102a09,%eax
  102787:	89 c1                	mov    %eax,%ecx
  102789:	c1 f9 1f             	sar    $0x1f,%ecx
  10278c:	c1 e9 16             	shr    $0x16,%ecx
  10278f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  102792:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  102798:	29 ca                	sub    %ecx,%edx
  10279a:	29 d0                	sub    %edx,%eax
	dprintf("Special kernel symbols:\n");
	dprintf("  start  %08x\n", start);
	dprintf("  etext  %08x\n", etext);
	dprintf("  edata  %08x\n", edata);
	dprintf("  end    %08x\n", end);
	dprintf("Kernel executable memory footprint: %dKB\n",
  10279c:	83 c4 08             	add    $0x8,%esp
  10279f:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1027a5:	85 c0                	test   %eax,%eax
  1027a7:	0f 49 d0             	cmovns %eax,%edx
  1027aa:	c1 fa 0a             	sar    $0xa,%edx
  1027ad:	52                   	push   %edx
  1027ae:	68 38 61 10 00       	push   $0x106138
  1027b3:	e8 53 f6 ff ff       	call   101e0b <dprintf>
		ROUNDUP(end - start, 1024) / 1024);
	return 0;
}
  1027b8:	b8 00 00 00 00       	mov    $0x0,%eax
  1027bd:	83 c4 1c             	add    $0x1c,%esp
  1027c0:	c3                   	ret    

001027c1 <runcmd>:
#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd (char *buf, struct Trapframe *tf)
{
  1027c1:	55                   	push   %ebp
  1027c2:	57                   	push   %edi
  1027c3:	56                   	push   %esi
  1027c4:	53                   	push   %ebx
  1027c5:	83 ec 4c             	sub    $0x4c,%esp
  1027c8:	89 c3                	mov    %eax,%ebx
  1027ca:	89 d7                	mov    %edx,%edi
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
  1027cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
  1027d3:	bd 00 00 00 00       	mov    $0x0,%ebp
  1027d8:	eb 0a                	jmp    1027e4 <runcmd+0x23>
	argv[argc] = 0;
	while (1)
	{
		// gobble whitespace
		while (*buf && strchr (WHITESPACE, *buf))
			*buf++ = 0;
  1027da:	c6 03 00             	movb   $0x0,(%ebx)
  1027dd:	89 ee                	mov    %ebp,%esi
  1027df:	8d 5b 01             	lea    0x1(%ebx),%ebx
  1027e2:	89 f5                	mov    %esi,%ebp
	argc = 0;
	argv[argc] = 0;
	while (1)
	{
		// gobble whitespace
		while (*buf && strchr (WHITESPACE, *buf))
  1027e4:	0f b6 03             	movzbl (%ebx),%eax
  1027e7:	84 c0                	test   %al,%al
  1027e9:	74 18                	je     102803 <runcmd+0x42>
  1027eb:	83 ec 08             	sub    $0x8,%esp
  1027ee:	0f be c0             	movsbl %al,%eax
  1027f1:	50                   	push   %eax
  1027f2:	68 7d 60 10 00       	push   $0x10607d
  1027f7:	e8 0e f4 ff ff       	call   101c0a <strchr>
  1027fc:	83 c4 10             	add    $0x10,%esp
  1027ff:	85 c0                	test   %eax,%eax
  102801:	75 d7                	jne    1027da <runcmd+0x19>
			*buf++ = 0;
		if (*buf == 0)
  102803:	80 3b 00             	cmpb   $0x0,(%ebx)
  102806:	74 4d                	je     102855 <runcmd+0x94>
			break;

		// save and scan past next arg
		if (argc == MAXARGS - 1)
  102808:	83 fd 0f             	cmp    $0xf,%ebp
  10280b:	75 1c                	jne    102829 <runcmd+0x68>
		{
			dprintf("Too many arguments (max %d)\n", MAXARGS);
  10280d:	83 ec 08             	sub    $0x8,%esp
  102810:	6a 10                	push   $0x10
  102812:	68 82 60 10 00       	push   $0x106082
  102817:	e8 ef f5 ff ff       	call   101e0b <dprintf>
			return 0;
  10281c:	83 c4 10             	add    $0x10,%esp
  10281f:	b8 00 00 00 00       	mov    $0x0,%eax
  102824:	e9 a8 00 00 00       	jmp    1028d1 <runcmd+0x110>
		}
		argv[argc++] = buf;
  102829:	8d 75 01             	lea    0x1(%ebp),%esi
  10282c:	89 1c ac             	mov    %ebx,(%esp,%ebp,4)
		while (*buf && !strchr (WHITESPACE, *buf))
  10282f:	eb 03                	jmp    102834 <runcmd+0x73>
			buf++;
  102831:	83 c3 01             	add    $0x1,%ebx
		{
			dprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr (WHITESPACE, *buf))
  102834:	0f b6 03             	movzbl (%ebx),%eax
  102837:	84 c0                	test   %al,%al
  102839:	74 a7                	je     1027e2 <runcmd+0x21>
  10283b:	83 ec 08             	sub    $0x8,%esp
  10283e:	0f be c0             	movsbl %al,%eax
  102841:	50                   	push   %eax
  102842:	68 7d 60 10 00       	push   $0x10607d
  102847:	e8 be f3 ff ff       	call   101c0a <strchr>
  10284c:	83 c4 10             	add    $0x10,%esp
  10284f:	85 c0                	test   %eax,%eax
  102851:	74 de                	je     102831 <runcmd+0x70>
  102853:	eb 8d                	jmp    1027e2 <runcmd+0x21>
			buf++;
	}
	argv[argc] = 0;
  102855:	c7 04 ac 00 00 00 00 	movl   $0x0,(%esp,%ebp,4)

	// Lookup and invoke the command
	if (argc == 0)
  10285c:	85 ed                	test   %ebp,%ebp
  10285e:	74 6c                	je     1028cc <runcmd+0x10b>
  102860:	bb 00 00 00 00       	mov    $0x0,%ebx
  102865:	eb 45                	jmp    1028ac <runcmd+0xeb>
		return 0;
	for (i = 0; i < NCOMMANDS; i++)
	{
		if (strcmp (argv[0], commands[i].name) == 0)
  102867:	83 ec 08             	sub    $0x8,%esp
  10286a:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
  10286d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  102874:	ff b0 20 62 10 00    	pushl  0x106220(%eax)
  10287a:	ff 74 24 0c          	pushl  0xc(%esp)
  10287e:	e8 63 f3 ff ff       	call   101be6 <strcmp>
  102883:	83 c4 10             	add    $0x10,%esp
  102886:	85 c0                	test   %eax,%eax
  102888:	75 1f                	jne    1028a9 <runcmd+0xe8>
			return commands[i].func (argc, argv, tf);
  10288a:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
  10288d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  102894:	83 ec 04             	sub    $0x4,%esp
  102897:	57                   	push   %edi
  102898:	8d 54 24 08          	lea    0x8(%esp),%edx
  10289c:	52                   	push   %edx
  10289d:	55                   	push   %ebp
  10289e:	ff 90 28 62 10 00    	call   *0x106228(%eax)
  1028a4:	83 c4 10             	add    $0x10,%esp
  1028a7:	eb 28                	jmp    1028d1 <runcmd+0x110>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++)
  1028a9:	83 c3 01             	add    $0x1,%ebx
  1028ac:	83 fb 02             	cmp    $0x2,%ebx
  1028af:	76 b6                	jbe    102867 <runcmd+0xa6>
	{
		if (strcmp (argv[0], commands[i].name) == 0)
			return commands[i].func (argc, argv, tf);
	}
	dprintf("Unknown command '%s'\n", argv[0]);
  1028b1:	83 ec 08             	sub    $0x8,%esp
  1028b4:	ff 74 24 08          	pushl  0x8(%esp)
  1028b8:	68 9f 60 10 00       	push   $0x10609f
  1028bd:	e8 49 f5 ff ff       	call   101e0b <dprintf>
	return 0;
  1028c2:	83 c4 10             	add    $0x10,%esp
  1028c5:	b8 00 00 00 00       	mov    $0x0,%eax
  1028ca:	eb 05                	jmp    1028d1 <runcmd+0x110>
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
  1028cc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (strcmp (argv[0], commands[i].name) == 0)
			return commands[i].func (argc, argv, tf);
	}
	dprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}
  1028d1:	83 c4 4c             	add    $0x4c,%esp
  1028d4:	5b                   	pop    %ebx
  1028d5:	5e                   	pop    %esi
  1028d6:	5f                   	pop    %edi
  1028d7:	5d                   	pop    %ebp
  1028d8:	c3                   	ret    

001028d9 <monitor>:

void
monitor (struct Trapframe *tf)
{
  1028d9:	53                   	push   %ebx
  1028da:	83 ec 14             	sub    $0x14,%esp
  1028dd:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
	char *buf;

	dprintf("\n****************************************\n\n");
  1028e1:	68 64 61 10 00       	push   $0x106164
  1028e6:	e8 20 f5 ff ff       	call   101e0b <dprintf>
	dprintf("Welcome to the mCertiKOS kernel monitor!\n");
  1028eb:	c7 04 24 90 61 10 00 	movl   $0x106190,(%esp)
  1028f2:	e8 14 f5 ff ff       	call   101e0b <dprintf>
	dprintf("\n****************************************\n\n");
  1028f7:	c7 04 24 64 61 10 00 	movl   $0x106164,(%esp)
  1028fe:	e8 08 f5 ff ff       	call   101e0b <dprintf>
	dprintf("Type 'help' for a list of commands.\n");
  102903:	c7 04 24 bc 61 10 00 	movl   $0x1061bc,(%esp)
  10290a:	e8 fc f4 ff ff       	call   101e0b <dprintf>
  10290f:	83 c4 10             	add    $0x10,%esp

	while (1)
	{
		buf = (char *) readline ("$> ");
  102912:	83 ec 0c             	sub    $0xc,%esp
  102915:	68 b5 60 10 00       	push   $0x1060b5
  10291a:	e8 87 da ff ff       	call   1003a6 <readline>
		if (buf != NULL)
  10291f:	83 c4 10             	add    $0x10,%esp
  102922:	85 c0                	test   %eax,%eax
  102924:	74 ec                	je     102912 <monitor+0x39>
			if (runcmd (buf, tf) < 0)
  102926:	89 da                	mov    %ebx,%edx
  102928:	e8 94 fe ff ff       	call   1027c1 <runcmd>
  10292d:	85 c0                	test   %eax,%eax
  10292f:	79 e1                	jns    102912 <monitor+0x39>
				break;
	}
}
  102931:	83 c4 08             	add    $0x8,%esp
  102934:	5b                   	pop    %ebx
  102935:	c3                   	ret    

00102936 <pt_copyin>:
extern void alloc_page(unsigned int pid, unsigned int vaddr, unsigned int perm);
extern unsigned int get_ptbl_entry_by_va(unsigned int pid, unsigned int vaddr);

size_t
pt_copyin(uint32_t pmap_id, uintptr_t uva, void *kva, size_t len)
{
  102936:	55                   	push   %ebp
  102937:	57                   	push   %edi
  102938:	56                   	push   %esi
  102939:	53                   	push   %ebx
  10293a:	83 ec 1c             	sub    $0x1c,%esp
  10293d:	8b 7c 24 34          	mov    0x34(%esp),%edi
  102941:	8b 6c 24 38          	mov    0x38(%esp),%ebp
  102945:	8b 74 24 3c          	mov    0x3c(%esp),%esi
	if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
  102949:	81 ff ff ff ff 3f    	cmp    $0x3fffffff,%edi
  10294f:	0f 86 9e 00 00 00    	jbe    1029f3 <pt_copyin+0xbd>
  102955:	8d 04 37             	lea    (%edi,%esi,1),%eax
  102958:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  10295d:	0f 87 97 00 00 00    	ja     1029fa <pt_copyin+0xc4>
		return 0;

	if ((uintptr_t) kva + len > VM_USERHI)
  102963:	8d 04 2e             	lea    (%esi,%ebp,1),%eax
  102966:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  10296b:	0f 87 90 00 00 00    	ja     102a01 <pt_copyin+0xcb>
  102971:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102978:	00 
  102979:	eb 6e                	jmp    1029e9 <pt_copyin+0xb3>
		return 0;

	size_t copied = 0;

	while (len) {
		uintptr_t uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  10297b:	83 ec 08             	sub    $0x8,%esp
  10297e:	57                   	push   %edi
  10297f:	ff 74 24 3c          	pushl  0x3c(%esp)
  102983:	e8 68 11 00 00       	call   103af0 <get_ptbl_entry_by_va>

		if ((uva_pa & PTE_P) == 0) {
  102988:	83 c4 10             	add    $0x10,%esp
  10298b:	a8 01                	test   $0x1,%al
  10298d:	75 1f                	jne    1029ae <pt_copyin+0x78>
			alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
  10298f:	83 ec 04             	sub    $0x4,%esp
  102992:	6a 07                	push   $0x7
  102994:	57                   	push   %edi
  102995:	ff 74 24 3c          	pushl  0x3c(%esp)
  102999:	e8 b2 19 00 00       	call   104350 <alloc_page>
			uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  10299e:	83 c4 08             	add    $0x8,%esp
  1029a1:	57                   	push   %edi
  1029a2:	ff 74 24 3c          	pushl  0x3c(%esp)
  1029a6:	e8 45 11 00 00       	call   103af0 <get_ptbl_entry_by_va>
  1029ab:	83 c4 10             	add    $0x10,%esp
		}

		uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  1029ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1029b3:	89 fa                	mov    %edi,%edx
  1029b5:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  1029bb:	01 d0                	add    %edx,%eax

		size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
			len : PAGESIZE - uva_pa % PAGESIZE;
  1029bd:	89 c2                	mov    %eax,%edx
  1029bf:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  1029c5:	bb 00 10 00 00       	mov    $0x1000,%ebx
  1029ca:	29 d3                	sub    %edx,%ebx
			uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
		}

		uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);

		size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  1029cc:	39 de                	cmp    %ebx,%esi
  1029ce:	0f 46 de             	cmovbe %esi,%ebx
			len : PAGESIZE - uva_pa % PAGESIZE;

		memcpy(kva, (void *) uva_pa, size);
  1029d1:	83 ec 04             	sub    $0x4,%esp
  1029d4:	53                   	push   %ebx
  1029d5:	50                   	push   %eax
  1029d6:	55                   	push   %ebp
  1029d7:	e8 96 f1 ff ff       	call   101b72 <memcpy>

		len -= size;
  1029dc:	29 de                	sub    %ebx,%esi
		uva += size;
  1029de:	01 df                	add    %ebx,%edi
		kva += size;
  1029e0:	01 dd                	add    %ebx,%ebp
		copied += size;
  1029e2:	01 5c 24 1c          	add    %ebx,0x1c(%esp)
  1029e6:	83 c4 10             	add    $0x10,%esp
	if ((uintptr_t) kva + len > VM_USERHI)
		return 0;

	size_t copied = 0;

	while (len) {
  1029e9:	85 f6                	test   %esi,%esi
  1029eb:	75 8e                	jne    10297b <pt_copyin+0x45>
		uva += size;
		kva += size;
		copied += size;
	}

	return copied;
  1029ed:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1029f1:	eb 13                	jmp    102a06 <pt_copyin+0xd0>

size_t
pt_copyin(uint32_t pmap_id, uintptr_t uva, void *kva, size_t len)
{
	if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
		return 0;
  1029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  1029f8:	eb 0c                	jmp    102a06 <pt_copyin+0xd0>
  1029fa:	b8 00 00 00 00       	mov    $0x0,%eax
  1029ff:	eb 05                	jmp    102a06 <pt_copyin+0xd0>

	if ((uintptr_t) kva + len > VM_USERHI)
		return 0;
  102a01:	b8 00 00 00 00       	mov    $0x0,%eax
		kva += size;
		copied += size;
	}

	return copied;
}
  102a06:	83 c4 1c             	add    $0x1c,%esp
  102a09:	5b                   	pop    %ebx
  102a0a:	5e                   	pop    %esi
  102a0b:	5f                   	pop    %edi
  102a0c:	5d                   	pop    %ebp
  102a0d:	c3                   	ret    

00102a0e <pt_copyout>:

size_t
pt_copyout(void *kva, uint32_t pmap_id, uintptr_t uva, size_t len)
{
  102a0e:	55                   	push   %ebp
  102a0f:	57                   	push   %edi
  102a10:	56                   	push   %esi
  102a11:	53                   	push   %ebx
  102a12:	83 ec 1c             	sub    $0x1c,%esp
  102a15:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  102a19:	8b 7c 24 38          	mov    0x38(%esp),%edi
  102a1d:	8b 74 24 3c          	mov    0x3c(%esp),%esi
	if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
  102a21:	81 ff ff ff ff 3f    	cmp    $0x3fffffff,%edi
  102a27:	0f 86 9e 00 00 00    	jbe    102acb <pt_copyout+0xbd>
  102a2d:	8d 04 37             	lea    (%edi,%esi,1),%eax
  102a30:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  102a35:	0f 87 97 00 00 00    	ja     102ad2 <pt_copyout+0xc4>
		return 0;

	if ((uintptr_t) kva + len > VM_USERHI)
  102a3b:	8d 04 2e             	lea    (%esi,%ebp,1),%eax
  102a3e:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  102a43:	0f 87 90 00 00 00    	ja     102ad9 <pt_copyout+0xcb>
  102a49:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  102a50:	00 
  102a51:	eb 6e                	jmp    102ac1 <pt_copyout+0xb3>
		return 0;

	size_t copied = 0;

	while (len) {
		uintptr_t uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  102a53:	83 ec 08             	sub    $0x8,%esp
  102a56:	57                   	push   %edi
  102a57:	ff 74 24 40          	pushl  0x40(%esp)
  102a5b:	e8 90 10 00 00       	call   103af0 <get_ptbl_entry_by_va>

		if ((uva_pa & PTE_P) == 0) {
  102a60:	83 c4 10             	add    $0x10,%esp
  102a63:	a8 01                	test   $0x1,%al
  102a65:	75 1f                	jne    102a86 <pt_copyout+0x78>
			alloc_page(pmap_id, uva, PTE_P | PTE_U | PTE_W);
  102a67:	83 ec 04             	sub    $0x4,%esp
  102a6a:	6a 07                	push   $0x7
  102a6c:	57                   	push   %edi
  102a6d:	ff 74 24 40          	pushl  0x40(%esp)
  102a71:	e8 da 18 00 00       	call   104350 <alloc_page>
			uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
  102a76:	83 c4 08             	add    $0x8,%esp
  102a79:	57                   	push   %edi
  102a7a:	ff 74 24 40          	pushl  0x40(%esp)
  102a7e:	e8 6d 10 00 00       	call   103af0 <get_ptbl_entry_by_va>
  102a83:	83 c4 10             	add    $0x10,%esp
		}

		uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);
  102a86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a8b:	89 fa                	mov    %edi,%edx
  102a8d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  102a93:	01 d0                	add    %edx,%eax

		size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
			len : PAGESIZE - uva_pa % PAGESIZE;
  102a95:	89 c2                	mov    %eax,%edx
  102a97:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  102a9d:	bb 00 10 00 00       	mov    $0x1000,%ebx
  102aa2:	29 d3                	sub    %edx,%ebx
			uva_pa = get_ptbl_entry_by_va(pmap_id, uva);
		}

		uva_pa = (uva_pa & 0xfffff000) + (uva % PAGESIZE);

		size_t size = (len < PAGESIZE - uva_pa % PAGESIZE) ?
  102aa4:	39 de                	cmp    %ebx,%esi
  102aa6:	0f 46 de             	cmovbe %esi,%ebx
			len : PAGESIZE - uva_pa % PAGESIZE;

		memcpy((void *) uva_pa, kva, size);
  102aa9:	83 ec 04             	sub    $0x4,%esp
  102aac:	53                   	push   %ebx
  102aad:	55                   	push   %ebp
  102aae:	50                   	push   %eax
  102aaf:	e8 be f0 ff ff       	call   101b72 <memcpy>

		len -= size;
  102ab4:	29 de                	sub    %ebx,%esi
		uva += size;
  102ab6:	01 df                	add    %ebx,%edi
		kva += size;
  102ab8:	01 dd                	add    %ebx,%ebp
		copied += size;
  102aba:	01 5c 24 1c          	add    %ebx,0x1c(%esp)
  102abe:	83 c4 10             	add    $0x10,%esp
	if ((uintptr_t) kva + len > VM_USERHI)
		return 0;

	size_t copied = 0;

	while (len) {
  102ac1:	85 f6                	test   %esi,%esi
  102ac3:	75 8e                	jne    102a53 <pt_copyout+0x45>
		uva += size;
		kva += size;
		copied += size;
	}

	return copied;
  102ac5:	8b 44 24 0c          	mov    0xc(%esp),%eax
  102ac9:	eb 13                	jmp    102ade <pt_copyout+0xd0>

size_t
pt_copyout(void *kva, uint32_t pmap_id, uintptr_t uva, size_t len)
{
	if (!(VM_USERLO <= uva && uva + len <= VM_USERHI))
		return 0;
  102acb:	b8 00 00 00 00       	mov    $0x0,%eax
  102ad0:	eb 0c                	jmp    102ade <pt_copyout+0xd0>
  102ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  102ad7:	eb 05                	jmp    102ade <pt_copyout+0xd0>

	if ((uintptr_t) kva + len > VM_USERHI)
		return 0;
  102ad9:	b8 00 00 00 00       	mov    $0x0,%eax
		kva += size;
		copied += size;
	}

	return copied;
}
  102ade:	83 c4 1c             	add    $0x1c,%esp
  102ae1:	5b                   	pop    %ebx
  102ae2:	5e                   	pop    %esi
  102ae3:	5f                   	pop    %edi
  102ae4:	5d                   	pop    %ebp
  102ae5:	c3                   	ret    

00102ae6 <pt_memset>:

size_t
pt_memset(uint32_t pmap_id, uintptr_t va, char c, size_t len)
{
  102ae6:	55                   	push   %ebp
  102ae7:	57                   	push   %edi
  102ae8:	56                   	push   %esi
  102ae9:	53                   	push   %ebx
  102aea:	83 ec 1c             	sub    $0x1c,%esp
  102aed:	8b 7c 24 34          	mov    0x34(%esp),%edi
  102af1:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  102af5:	0f b6 44 24 38       	movzbl 0x38(%esp),%eax
  102afa:	88 44 24 0f          	mov    %al,0xf(%esp)
        size_t set = 0;
  102afe:	bd 00 00 00 00       	mov    $0x0,%ebp

	while (len) {
  102b03:	eb 6f                	jmp    102b74 <pt_memset+0x8e>
		uintptr_t pa = get_ptbl_entry_by_va(pmap_id, va);
  102b05:	83 ec 08             	sub    $0x8,%esp
  102b08:	57                   	push   %edi
  102b09:	ff 74 24 3c          	pushl  0x3c(%esp)
  102b0d:	e8 de 0f 00 00       	call   103af0 <get_ptbl_entry_by_va>

		if ((pa & PTE_P) == 0) {
  102b12:	83 c4 10             	add    $0x10,%esp
  102b15:	a8 01                	test   $0x1,%al
  102b17:	75 1f                	jne    102b38 <pt_memset+0x52>
			alloc_page(pmap_id, va, PTE_P | PTE_U | PTE_W);
  102b19:	83 ec 04             	sub    $0x4,%esp
  102b1c:	6a 07                	push   $0x7
  102b1e:	57                   	push   %edi
  102b1f:	ff 74 24 3c          	pushl  0x3c(%esp)
  102b23:	e8 28 18 00 00       	call   104350 <alloc_page>
			pa = get_ptbl_entry_by_va(pmap_id, va);
  102b28:	83 c4 08             	add    $0x8,%esp
  102b2b:	57                   	push   %edi
  102b2c:	ff 74 24 3c          	pushl  0x3c(%esp)
  102b30:	e8 bb 0f 00 00       	call   103af0 <get_ptbl_entry_by_va>
  102b35:	83 c4 10             	add    $0x10,%esp
		}

		pa = (pa & 0xfffff000) + (va % PAGESIZE);
  102b38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102b3d:	89 fa                	mov    %edi,%edx
  102b3f:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  102b45:	01 d0                	add    %edx,%eax

		size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
			len : PAGESIZE - pa % PAGESIZE;
  102b47:	89 c2                	mov    %eax,%edx
  102b49:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  102b4f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  102b54:	29 d3                	sub    %edx,%ebx
			pa = get_ptbl_entry_by_va(pmap_id, va);
		}

		pa = (pa & 0xfffff000) + (va % PAGESIZE);

		size_t size = (len < PAGESIZE - pa % PAGESIZE) ?
  102b56:	39 de                	cmp    %ebx,%esi
  102b58:	0f 46 de             	cmovbe %esi,%ebx
			len : PAGESIZE - pa % PAGESIZE;

		memset((void *) pa, c, size);
  102b5b:	83 ec 04             	sub    $0x4,%esp
  102b5e:	53                   	push   %ebx
  102b5f:	0f be 54 24 17       	movsbl 0x17(%esp),%edx
  102b64:	52                   	push   %edx
  102b65:	50                   	push   %eax
  102b66:	e8 53 ef ff ff       	call   101abe <memset>

		len -= size;
  102b6b:	29 de                	sub    %ebx,%esi
		va += size;
  102b6d:	01 df                	add    %ebx,%edi
		set += size;
  102b6f:	01 dd                	add    %ebx,%ebp
  102b71:	83 c4 10             	add    $0x10,%esp
size_t
pt_memset(uint32_t pmap_id, uintptr_t va, char c, size_t len)
{
        size_t set = 0;

	while (len) {
  102b74:	85 f6                	test   %esi,%esi
  102b76:	75 8d                	jne    102b05 <pt_memset+0x1f>
		va += size;
		set += size;
	}

	return set;
}
  102b78:	89 e8                	mov    %ebp,%eax
  102b7a:	83 c4 1c             	add    $0x1c,%esp
  102b7d:	5b                   	pop    %ebx
  102b7e:	5e                   	pop    %esi
  102b7f:	5f                   	pop    %edi
  102b80:	5d                   	pop    %ebp
  102b81:	c3                   	ret    

00102b82 <elf_load>:
/*
 * Load elf execution file exe to the virtual address space pmap.
 */
void
elf_load (void *exe_ptr, int pid)
{
  102b82:	55                   	push   %ebp
  102b83:	57                   	push   %edi
  102b84:	56                   	push   %esi
  102b85:	53                   	push   %ebx
  102b86:	83 ec 2c             	sub    $0x2c,%esp
  102b89:	8b 5c 24 40          	mov    0x40(%esp),%ebx
  102b8d:	8b 7c 24 44          	mov    0x44(%esp),%edi
	elfhdr *eh;
	proghdr *ph, *eph;
	sechdr *sh, *esh;
	char *strtab;
	uintptr_t exe = (uintptr_t) exe_ptr;
  102b91:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)

	eh = (elfhdr *) exe;

	KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  102b95:	81 3b 7f 45 4c 46    	cmpl   $0x464c457f,(%ebx)
  102b9b:	74 19                	je     102bb6 <elf_load+0x34>
  102b9d:	68 44 62 10 00       	push   $0x106244
  102ba2:	68 b3 5d 10 00       	push   $0x105db3
  102ba7:	6a 20                	push   $0x20
  102ba9:	68 5d 62 10 00       	push   $0x10625d
  102bae:	e8 05 f1 ff ff       	call   101cb8 <debug_panic>
  102bb3:	83 c4 10             	add    $0x10,%esp
	KERN_ASSERT(eh->e_shstrndx != ELF_SHN_UNDEF);
  102bb6:	66 83 7b 32 00       	cmpw   $0x0,0x32(%ebx)
  102bbb:	75 19                	jne    102bd6 <elf_load+0x54>
  102bbd:	68 6c 62 10 00       	push   $0x10626c
  102bc2:	68 b3 5d 10 00       	push   $0x105db3
  102bc7:	6a 21                	push   $0x21
  102bc9:	68 5d 62 10 00       	push   $0x10625d
  102bce:	e8 e5 f0 ff ff       	call   101cb8 <debug_panic>
  102bd3:	83 c4 10             	add    $0x10,%esp

	sh = (sechdr *) ((uintptr_t) eh + eh->e_shoff);
  102bd6:	89 d9                	mov    %ebx,%ecx
  102bd8:	03 4b 20             	add    0x20(%ebx),%ecx
	esh = sh + eh->e_shnum;

	strtab = (char *) (exe + sh[eh->e_shstrndx].sh_offset);
  102bdb:	0f b7 43 32          	movzwl 0x32(%ebx),%eax
  102bdf:	8d 14 80             	lea    (%eax,%eax,4),%edx
  102be2:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
	KERN_ASSERT(sh[eh->e_shstrndx].sh_type == ELF_SHT_STRTAB);
  102be9:	83 7c 01 04 03       	cmpl   $0x3,0x4(%ecx,%eax,1)
  102bee:	74 19                	je     102c09 <elf_load+0x87>
  102bf0:	68 8c 62 10 00       	push   $0x10628c
  102bf5:	68 b3 5d 10 00       	push   $0x105db3
  102bfa:	6a 27                	push   $0x27
  102bfc:	68 5d 62 10 00       	push   $0x10625d
  102c01:	e8 b2 f0 ff ff       	call   101cb8 <debug_panic>
  102c06:	83 c4 10             	add    $0x10,%esp

	ph = (proghdr *) ((uintptr_t) eh + eh->e_phoff);
  102c09:	89 da                	mov    %ebx,%edx
  102c0b:	03 53 1c             	add    0x1c(%ebx),%edx
  102c0e:	89 d5                	mov    %edx,%ebp
	eph = ph + eh->e_phnum;
  102c10:	0f b7 43 2c          	movzwl 0x2c(%ebx),%eax
  102c14:	c1 e0 05             	shl    $0x5,%eax
  102c17:	01 d0                	add    %edx,%eax
  102c19:	89 44 24 10          	mov    %eax,0x10(%esp)

	for (; ph < eph; ph++)
  102c1d:	e9 18 01 00 00       	jmp    102d3a <elf_load+0x1b8>
	{
		uintptr_t fa;
		uint32_t va, zva, eva, perm;

		if (ph->p_type != ELF_PROG_LOAD)
  102c22:	83 7d 00 01          	cmpl   $0x1,0x0(%ebp)
  102c26:	0f 85 0b 01 00 00    	jne    102d37 <elf_load+0x1b5>
			continue;

		fa = (uintptr_t) eh + rounddown (ph->p_offset, PAGESIZE);
  102c2c:	83 ec 08             	sub    $0x8,%esp
  102c2f:	68 00 10 00 00       	push   $0x1000
  102c34:	ff 75 04             	pushl  0x4(%ebp)
  102c37:	e8 19 f9 ff ff       	call   102555 <rounddown>
  102c3c:	8b 54 24 2c          	mov    0x2c(%esp),%edx
  102c40:	8d 34 02             	lea    (%edx,%eax,1),%esi
		va = rounddown (ph->p_va, PAGESIZE);
  102c43:	83 c4 08             	add    $0x8,%esp
  102c46:	68 00 10 00 00       	push   $0x1000
  102c4b:	ff 75 08             	pushl  0x8(%ebp)
  102c4e:	e8 02 f9 ff ff       	call   102555 <rounddown>
  102c53:	89 c3                	mov    %eax,%ebx
		zva = ph->p_va + ph->p_filesz;
  102c55:	8b 45 08             	mov    0x8(%ebp),%eax
  102c58:	89 c1                	mov    %eax,%ecx
  102c5a:	03 4d 10             	add    0x10(%ebp),%ecx
  102c5d:	89 4c 24 28          	mov    %ecx,0x28(%esp)
		eva = roundup (ph->p_va + ph->p_memsz, PAGESIZE);
  102c61:	03 45 14             	add    0x14(%ebp),%eax
  102c64:	83 c4 08             	add    $0x8,%esp
  102c67:	68 00 10 00 00       	push   $0x1000
  102c6c:	50                   	push   %eax
  102c6d:	e8 f7 f8 ff ff       	call   102569 <roundup>
  102c72:	89 44 24 18          	mov    %eax,0x18(%esp)

		perm = PTE_U | PTE_P;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  102c76:	83 c4 10             	add    $0x10,%esp
  102c79:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
  102c7d:	75 15                	jne    102c94 <elf_load+0x112>
		fa = (uintptr_t) eh + rounddown (ph->p_offset, PAGESIZE);
		va = rounddown (ph->p_va, PAGESIZE);
		zva = ph->p_va + ph->p_filesz;
		eva = roundup (ph->p_va + ph->p_memsz, PAGESIZE);

		perm = PTE_U | PTE_P;
  102c7f:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  102c86:	00 
  102c87:	89 6c 24 14          	mov    %ebp,0x14(%esp)
  102c8b:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  102c8f:	e9 95 00 00 00       	jmp    102d29 <elf_load+0x1a7>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
  102c94:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  102c9b:	00 
  102c9c:	89 6c 24 14          	mov    %ebp,0x14(%esp)
  102ca0:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  102ca4:	e9 80 00 00 00       	jmp    102d29 <elf_load+0x1a7>

		for (; va < eva; va += PAGESIZE, fa += PAGESIZE)
		{
			alloc_page (pid, va, perm);
  102ca9:	83 ec 04             	sub    $0x4,%esp
  102cac:	ff 74 24 10          	pushl  0x10(%esp)
  102cb0:	53                   	push   %ebx
  102cb1:	57                   	push   %edi
  102cb2:	e8 99 16 00 00       	call   104350 <alloc_page>

			if (va < rounddown (zva, PAGESIZE))
  102cb7:	83 c4 08             	add    $0x8,%esp
  102cba:	68 00 10 00 00       	push   $0x1000
  102cbf:	55                   	push   %ebp
  102cc0:	e8 90 f8 ff ff       	call   102555 <rounddown>
  102cc5:	83 c4 10             	add    $0x10,%esp
  102cc8:	39 c3                	cmp    %eax,%ebx
  102cca:	73 12                	jae    102cde <elf_load+0x15c>
			{
				/* copy a complete page */
				pt_copyout ((void *) fa, pid, va, PAGESIZE);
  102ccc:	68 00 10 00 00       	push   $0x1000
  102cd1:	53                   	push   %ebx
  102cd2:	57                   	push   %edi
  102cd3:	56                   	push   %esi
  102cd4:	e8 35 fd ff ff       	call   102a0e <pt_copyout>
  102cd9:	83 c4 10             	add    $0x10,%esp
  102cdc:	eb 3f                	jmp    102d1d <elf_load+0x19b>
			}
			else if (va < zva && ph->p_filesz)
  102cde:	39 eb                	cmp    %ebp,%ebx
  102ce0:	73 2a                	jae    102d0c <elf_load+0x18a>
  102ce2:	8b 44 24 14          	mov    0x14(%esp),%eax
  102ce6:	83 78 10 00          	cmpl   $0x0,0x10(%eax)
  102cea:	74 20                	je     102d0c <elf_load+0x18a>
			{
				/* copy a partial page */
				pt_memset (pid, va, 0, PAGESIZE);
  102cec:	68 00 10 00 00       	push   $0x1000
  102cf1:	6a 00                	push   $0x0
  102cf3:	53                   	push   %ebx
  102cf4:	57                   	push   %edi
  102cf5:	e8 ec fd ff ff       	call   102ae6 <pt_memset>
				pt_copyout ((void *) fa, pid, va, zva - va);
  102cfa:	89 e8                	mov    %ebp,%eax
  102cfc:	29 d8                	sub    %ebx,%eax
  102cfe:	50                   	push   %eax
  102cff:	53                   	push   %ebx
  102d00:	57                   	push   %edi
  102d01:	56                   	push   %esi
  102d02:	e8 07 fd ff ff       	call   102a0e <pt_copyout>
  102d07:	83 c4 20             	add    $0x20,%esp
  102d0a:	eb 11                	jmp    102d1d <elf_load+0x19b>
			}
			else
			{
				/* zero a page */
				pt_memset (pid, va, 0, PAGESIZE);
  102d0c:	68 00 10 00 00       	push   $0x1000
  102d11:	6a 00                	push   $0x0
  102d13:	53                   	push   %ebx
  102d14:	57                   	push   %edi
  102d15:	e8 cc fd ff ff       	call   102ae6 <pt_memset>
  102d1a:	83 c4 10             	add    $0x10,%esp

		perm = PTE_U | PTE_P;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;

		for (; va < eva; va += PAGESIZE, fa += PAGESIZE)
  102d1d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  102d23:	81 c6 00 10 00 00    	add    $0x1000,%esi
  102d29:	3b 5c 24 08          	cmp    0x8(%esp),%ebx
  102d2d:	0f 82 76 ff ff ff    	jb     102ca9 <elf_load+0x127>
  102d33:	8b 6c 24 14          	mov    0x14(%esp),%ebp
	KERN_ASSERT(sh[eh->e_shstrndx].sh_type == ELF_SHT_STRTAB);

	ph = (proghdr *) ((uintptr_t) eh + eh->e_phoff);
	eph = ph + eh->e_phnum;

	for (; ph < eph; ph++)
  102d37:	83 c5 20             	add    $0x20,%ebp
  102d3a:	3b 6c 24 10          	cmp    0x10(%esp),%ebp
  102d3e:	0f 82 de fe ff ff    	jb     102c22 <elf_load+0xa0>
				pt_memset (pid, va, 0, PAGESIZE);
			}
		}
	}

}
  102d44:	83 c4 2c             	add    $0x2c,%esp
  102d47:	5b                   	pop    %ebx
  102d48:	5e                   	pop    %esi
  102d49:	5f                   	pop    %edi
  102d4a:	5d                   	pop    %ebp
  102d4b:	c3                   	ret    

00102d4c <elf_entry>:

uintptr_t
elf_entry (void *exe_ptr)
{
  102d4c:	53                   	push   %ebx
  102d4d:	83 ec 08             	sub    $0x8,%esp
  102d50:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	uintptr_t exe = (uintptr_t) exe_ptr;
	elfhdr *eh = (elfhdr *) exe;
	KERN_ASSERT(eh->e_magic == ELF_MAGIC);
  102d54:	81 3b 7f 45 4c 46    	cmpl   $0x464c457f,(%ebx)
  102d5a:	74 19                	je     102d75 <elf_entry+0x29>
  102d5c:	68 44 62 10 00       	push   $0x106244
  102d61:	68 b3 5d 10 00       	push   $0x105db3
  102d66:	6a 5b                	push   $0x5b
  102d68:	68 5d 62 10 00       	push   $0x10625d
  102d6d:	e8 46 ef ff ff       	call   101cb8 <debug_panic>
  102d72:	83 c4 10             	add    $0x10,%esp
	return (uintptr_t) eh->e_entry;
  102d75:	8b 43 18             	mov    0x18(%ebx),%eax
}
  102d78:	83 c4 08             	add    $0x8,%esp
  102d7b:	5b                   	pop    %ebx
  102d7c:	c3                   	ret    
  102d7d:	66 90                	xchg   %ax,%ax
  102d7f:	90                   	nop

00102d80 <kern_init>:
    #endif
}

void
kern_init (uintptr_t mbi_addr)
{
  102d80:	53                   	push   %ebx
  102d81:	83 ec 18             	sub    $0x18,%esp
    pmmap_list_type pmmap_list;

    devinit();
  102d84:	e8 f7 d9 ff ff       	call   100780 <devinit>

    pmmap_init (mbi_addr, &pmmap_list);
  102d89:	83 ec 08             	sub    $0x8,%esp
  102d8c:	8d 5c 24 14          	lea    0x14(%esp),%ebx
  102d90:	53                   	push   %ebx
  102d91:	ff 74 24 2c          	pushl  0x2c(%esp)
  102d95:	e8 04 ec ff ff       	call   10199e <pmmap_init>

    pmem_init(&pmmap_list);
  102d9a:	89 1c 24             	mov    %ebx,(%esp)
  102d9d:	e8 6e 02 00 00       	call   103010 <pmem_init>

    container_init();
  102da2:	e8 89 06 00 00       	call   103430 <container_init>

    pdir_init_kern();
  102da7:	e8 44 12 00 00       	call   103ff0 <pdir_init_kern>
    set_pdir_base(0);
  102dac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102db3:	e8 d8 09 00 00       	call   103790 <set_pdir_base>
    enable_paging();
  102db8:	e8 d8 ec ff ff       	call   101a95 <enable_paging>

    thread_init();
  102dbd:	e8 fe 1f 00 00       	call   104dc0 <thread_init>

    KERN_DEBUG("Kernel initialized.\n");
  102dc2:	83 c4 0c             	add    $0xc,%esp
  102dc5:	68 b9 62 10 00       	push   $0x1062b9
  102dca:	6a 4d                	push   $0x4d
  102dcc:	68 ce 62 10 00       	push   $0x1062ce
  102dd1:	e8 b8 ee ff ff       	call   101c8e <debug_normal>
#endif

static void
kern_main (void)
{
    KERN_DEBUG("In kernel main.\n\n");
  102dd6:	83 c4 0c             	add    $0xc,%esp
  102dd9:	68 df 62 10 00       	push   $0x1062df
  102dde:	6a 16                	push   $0x16
  102de0:	68 ce 62 10 00       	push   $0x1062ce
  102de5:	e8 a4 ee ff ff       	call   101c8e <debug_normal>
    else
      dprintf("Test failed.\n");
    dprintf("\n");
    dprintf("\nTest complete. Please Use Ctrl-a x to exit qemu.");
    #else
    monitor(NULL);
  102dea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102df1:	e8 e3 fa ff ff       	call   1028d9 <monitor>
    thread_init();

    KERN_DEBUG("Kernel initialized.\n");

    kern_main ();
}
  102df6:	83 c4 28             	add    $0x28,%esp
  102df9:	5b                   	pop    %ebx
  102dfa:	c3                   	ret    
  102dfb:	90                   	nop
  102dfc:	02 b0 ad 1b 03 00    	add    0x31bad(%eax),%dh
  102e02:	00 00                	add    %al,(%eax)
  102e04:	fb                   	sti    
  102e05:	4f                   	dec    %edi
  102e06:	52                   	push   %edx
  102e07:	e4                   	.byte 0xe4

00102e08 <start>:
	.long	CHECKSUM

	/* this is the entry of the kernel */
	.globl	start
start:
	cli
  102e08:	fa                   	cli    

	/* check whether the bootloader provide multiboot information */
	cmpl    $MULTIBOOT_BOOTLOADER_MAGIC, %eax
  102e09:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
	jne     spin
  102e0e:	75 27                	jne    102e37 <spin>
	movl	%ebx, multiboot_ptr
  102e10:	89 1d 38 2e 10 00    	mov    %ebx,0x102e38

	/* tell BIOS to warmboot next time */
	movw	$0x1234,0x472
  102e16:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
  102e1d:	34 12 

	/* clear EFLAGS */
	pushl	$0x2
  102e1f:	6a 02                	push   $0x2
	popfl
  102e21:	9d                   	popf   

	/* prepare the kernel stack  */
	movl	$0x0,%ebp
  102e22:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl	$(bsp_kstack+4096),%esp
  102e27:	bc 00 80 96 01       	mov    $0x1968000,%esp

	/* jump to the C code */
	push	multiboot_ptr
  102e2c:	ff 35 38 2e 10 00    	pushl  0x102e38
	call	kern_init
  102e32:	e8 49 ff ff ff       	call   102d80 <kern_init>

00102e37 <spin>:

	/* should not be here */
spin:
	hlt
  102e37:	f4                   	hlt    

00102e38 <multiboot_ptr>:
  102e38:	00 00                	add    %al,(%eax)
  102e3a:	00 00                	add    %al,(%eax)
  102e3c:	66 90                	xchg   %ax,%ax
  102e3e:	66 90                	xchg   %ax,%ax

00102e40 <get_permission>:
};
static struct MATPage MATPage_t[1048576]; //2^20


unsigned int
get_permission(int i) {
  102e40:	8b 44 24 04          	mov    0x4(%esp),%eax
    return MATPage_t[i].permission;
  102e44:	8d 04 40             	lea    (%eax,%eax,2),%eax
  102e47:	8b 04 c5 70 5f 12 00 	mov    0x125f70(,%eax,8),%eax
}
  102e4e:	c3                   	ret    
  102e4f:	90                   	nop

00102e50 <set_permission>:

void
set_permission(int i, int permission) {
  102e50:	8b 44 24 04          	mov    0x4(%esp),%eax
    MATPage_t[i].permission = permission;
  102e54:	8b 54 24 08          	mov    0x8(%esp),%edx
  102e58:	8d 04 40             	lea    (%eax,%eax,2),%eax
  102e5b:	89 14 c5 70 5f 12 00 	mov    %edx,0x125f70(,%eax,8)
  102e62:	c3                   	ret    
  102e63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102e70 <is_free>:
}

unsigned int
is_free(int i) {
  102e70:	8b 44 24 04          	mov    0x4(%esp),%eax
    return MATPage_t[i].isFree;
  102e74:	8d 04 40             	lea    (%eax,%eax,2),%eax
  102e77:	8b 04 c5 68 5f 12 00 	mov    0x125f68(,%eax,8),%eax
}
  102e7e:	c3                   	ret    
  102e7f:	90                   	nop

00102e80 <set_free>:

void
set_free(int i, int isFree) {
  102e80:	8b 44 24 04          	mov    0x4(%esp),%eax
    MATPage_t[i].isFree = isFree;
  102e84:	8b 54 24 08          	mov    0x8(%esp),%edx
  102e88:	8d 04 40             	lea    (%eax,%eax,2),%eax
  102e8b:	89 14 c5 68 5f 12 00 	mov    %edx,0x125f68(,%eax,8)
  102e92:	c3                   	ret    
  102e93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102ea0 <is_valid>:
}

unsigned int
is_valid(int i) {
  102ea0:	8b 44 24 04          	mov    0x4(%esp),%eax
    return MATPage_t[i].isValid;
  102ea4:	8d 04 40             	lea    (%eax,%eax,2),%eax
  102ea7:	8b 04 c5 6c 5f 12 00 	mov    0x125f6c(,%eax,8),%eax
}
  102eae:	c3                   	ret    
  102eaf:	90                   	nop

00102eb0 <set_valid>:

void
set_valid(int i, int isValid) {
  102eb0:	8b 44 24 04          	mov    0x4(%esp),%eax
    MATPage_t[i].isValid = isValid;
  102eb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  102eb8:	8d 04 40             	lea    (%eax,%eax,2),%eax
  102ebb:	89 14 c5 6c 5f 12 00 	mov    %edx,0x125f6c(,%eax,8)
  102ec2:	c3                   	ret    
  102ec3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102ed0 <get_nps>:
/** The getter function for NUM_PAGES. */
unsigned int
get_nps(void)
{
  return NUM_PAGES;
}
  102ed0:	a1 64 5f 92 01       	mov    0x1925f64,%eax
  102ed5:	c3                   	ret    
  102ed6:	8d 76 00             	lea    0x0(%esi),%esi
  102ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102ee0 <set_nps>:

/** The setter function for NUM_PAGES. */
void
set_nps(unsigned int nps)
{
  NUM_PAGES = nps;
  102ee0:	8b 44 24 04          	mov    0x4(%esp),%eax
  102ee4:	a3 64 5f 92 01       	mov    %eax,0x1925f64
  102ee9:	c3                   	ret    
  102eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102ef0 <set_latest_allocated_page>:
}

void
set_latest_allocated_page(unsigned int page) {
    LATEST_ALLOCATED_PAGE = page;
  102ef0:	8b 44 24 04          	mov    0x4(%esp),%eax
  102ef4:	a3 60 5f 92 01       	mov    %eax,0x1925f60
  102ef9:	c3                   	ret    
  102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102f00 <get_latest_allocated_page>:
}

unsigned int
get_latest_allocated_page(void) {
    return LATEST_ALLOCATED_PAGE;
  102f00:	a1 60 5f 92 01       	mov    0x1925f60,%eax
  102f05:	c3                   	ret    
  102f06:	66 90                	xchg   %ax,%ax
  102f08:	66 90                	xchg   %ax,%ax
  102f0a:	66 90                	xchg   %ax,%ax
  102f0c:	66 90                	xchg   %ax,%ax
  102f0e:	66 90                	xchg   %ax,%ax

00102f10 <MATIntro_test1>:
#include <lib/debug.h>
#include "export.h"

int MATIntro_test1()
{
  102f10:	55                   	push   %ebp
  102f11:	57                   	push   %edi
  102f12:	56                   	push   %esi
  102f13:	53                   	push   %ebx
  int rn10[] = {1,3,5,6,78,3576,32,8,0,100};
  int i;
  int nps = get_nps();
  102f14:	be 01 00 00 00       	mov    $0x1,%esi
#include <lib/debug.h>
#include "export.h"

int MATIntro_test1()
{
  102f19:	83 ec 3c             	sub    $0x3c,%esp
  int rn10[] = {1,3,5,6,78,3576,32,8,0,100};
  102f1c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102f23:	00 
  102f24:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  102f2b:	00 
  102f2c:	8d 5c 24 0c          	lea    0xc(%esp),%ebx
  102f30:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  102f37:	00 
  102f38:	c7 44 24 14 06 00 00 	movl   $0x6,0x14(%esp)
  102f3f:	00 
  102f40:	8d 7c 24 30          	lea    0x30(%esp),%edi
  102f44:	c7 44 24 18 4e 00 00 	movl   $0x4e,0x18(%esp)
  102f4b:	00 
  102f4c:	c7 44 24 1c f8 0d 00 	movl   $0xdf8,0x1c(%esp)
  102f53:	00 
  102f54:	c7 44 24 20 20 00 00 	movl   $0x20,0x20(%esp)
  102f5b:	00 
  102f5c:	c7 44 24 24 08 00 00 	movl   $0x8,0x24(%esp)
  102f63:	00 
  102f64:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  102f6b:	00 
  102f6c:	c7 44 24 2c 64 00 00 	movl   $0x64,0x2c(%esp)
  102f73:	00 
  int i;
  int nps = get_nps();
  102f74:	e8 57 ff ff ff       	call   102ed0 <get_nps>
  102f79:	89 c5                	mov    %eax,%ebp
  102f7b:	eb 08                	jmp    102f85 <MATIntro_test1+0x75>
  102f7d:	8d 76 00             	lea    0x0(%esi),%esi
  102f80:	8b 33                	mov    (%ebx),%esi
  102f82:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i< 10; i++) {
    set_nps(rn10[i]);
  102f85:	83 ec 0c             	sub    $0xc,%esp
  102f88:	56                   	push   %esi
  102f89:	e8 52 ff ff ff       	call   102ee0 <set_nps>
    if (get_nps() != rn10[i]) {
  102f8e:	e8 3d ff ff ff       	call   102ed0 <get_nps>
  102f93:	83 c4 10             	add    $0x10,%esp
  102f96:	39 c6                	cmp    %eax,%esi
  102f98:	75 26                	jne    102fc0 <MATIntro_test1+0xb0>
int MATIntro_test1()
{
  int rn10[] = {1,3,5,6,78,3576,32,8,0,100};
  int i;
  int nps = get_nps();
  for(i = 0; i< 10; i++) {
  102f9a:	39 fb                	cmp    %edi,%ebx
  102f9c:	75 e2                	jne    102f80 <MATIntro_test1+0x70>
      set_nps(nps);
      dprintf("test 1 failed.\n");
      return 1;
    }
  }
  set_nps(nps);
  102f9e:	83 ec 0c             	sub    $0xc,%esp
  102fa1:	55                   	push   %ebp
  102fa2:	e8 39 ff ff ff       	call   102ee0 <set_nps>
  dprintf("test 1 passed.\n");
  102fa7:	c7 04 24 01 63 10 00 	movl   $0x106301,(%esp)
  102fae:	e8 58 ee ff ff       	call   101e0b <dprintf>
  return 0;
  102fb3:	83 c4 10             	add    $0x10,%esp
  102fb6:	31 c0                	xor    %eax,%eax
}
  102fb8:	83 c4 3c             	add    $0x3c,%esp
  102fbb:	5b                   	pop    %ebx
  102fbc:	5e                   	pop    %esi
  102fbd:	5f                   	pop    %edi
  102fbe:	5d                   	pop    %ebp
  102fbf:	c3                   	ret    
  int i;
  int nps = get_nps();
  for(i = 0; i< 10; i++) {
    set_nps(rn10[i]);
    if (get_nps() != rn10[i]) {
      set_nps(nps);
  102fc0:	83 ec 0c             	sub    $0xc,%esp
  102fc3:	55                   	push   %ebp
  102fc4:	e8 17 ff ff ff       	call   102ee0 <set_nps>
      dprintf("test 1 failed.\n");
  102fc9:	c7 04 24 f1 62 10 00 	movl   $0x1062f1,(%esp)
  102fd0:	e8 36 ee ff ff       	call   101e0b <dprintf>
      return 1;
  102fd5:	83 c4 10             	add    $0x10,%esp
  102fd8:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  set_nps(nps);
  dprintf("test 1 passed.\n");
  return 0;
}
  102fdd:	83 c4 3c             	add    $0x3c,%esp
  102fe0:	5b                   	pop    %ebx
  102fe1:	5e                   	pop    %esi
  102fe2:	5f                   	pop    %edi
  102fe3:	5d                   	pop    %ebp
  102fe4:	c3                   	ret    
  102fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102ff0 <MATIntro_test_own>:
int MATIntro_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  102ff0:	31 c0                	xor    %eax,%eax
  102ff2:	c3                   	ret    
  102ff3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103000 <test_MATIntro>:

int test_MATIntro()
{
  return MATIntro_test1() + MATIntro_test_own();
  103000:	e9 0b ff ff ff       	jmp    102f10 <MATIntro_test1>
  103005:	66 90                	xchg   %ax,%ax
  103007:	66 90                	xchg   %ax,%ax
  103009:	66 90                	xchg   %ax,%ax
  10300b:	66 90                	xchg   %ax,%ax
  10300d:	66 90                	xchg   %ax,%ax
  10300f:	90                   	nop

00103010 <pmem_init>:
#define MEM_RAM            1
#define MEM_RESERVED        2

void
pmem_init(pmmap_list_type *pmmap_list_p)
{
  103010:	55                   	push   %ebp
  103011:	57                   	push   %edi
  103012:	56                   	push   %esi
  103013:	53                   	push   %ebx
  103014:	83 ec 0c             	sub    $0xc,%esp

    unsigned int nps;
    struct pmmap *pmmap_t, *pmmap_t1, *pmmap_t2;
    int itr = 0, length = 0;
    uint32_t startHighest = 0, endHighest = 0, highestPage;
    SLIST_FOREACH(pmmap_t, pmmap_list_p, next)
  103017:	8b 44 24 20          	mov    0x20(%esp),%eax
  10301b:	8b 00                	mov    (%eax),%eax
  10301d:	85 c0                	test   %eax,%eax
  10301f:	0f 84 48 02 00 00    	je     10326d <pmem_init+0x25d>
  103025:	31 db                	xor    %ebx,%ebx
  103027:	31 ed                	xor    %ebp,%ebp
  103029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    {
        if (startHighest < pmmap_t->start)
            startHighest = pmmap_t->start;
        if (endHighest < pmmap_t->end)
  103030:	8b 50 04             	mov    0x4(%eax),%edx

    unsigned int nps;
    struct pmmap *pmmap_t, *pmmap_t1, *pmmap_t2;
    int itr = 0, length = 0;
    uint32_t startHighest = 0, endHighest = 0, highestPage;
    SLIST_FOREACH(pmmap_t, pmmap_list_p, next)
  103033:	8b 40 0c             	mov    0xc(%eax),%eax
  103036:	39 d3                	cmp    %edx,%ebx
  103038:	0f 42 da             	cmovb  %edx,%ebx
    {
        if (startHighest < pmmap_t->start)
            startHighest = pmmap_t->start;
        if (endHighest < pmmap_t->end)
            endHighest = pmmap_t->end;
        length++;
  10303b:	83 c5 01             	add    $0x1,%ebp

    unsigned int nps;
    struct pmmap *pmmap_t, *pmmap_t1, *pmmap_t2;
    int itr = 0, length = 0;
    uint32_t startHighest = 0, endHighest = 0, highestPage;
    SLIST_FOREACH(pmmap_t, pmmap_list_p, next)
  10303e:	85 c0                	test   %eax,%eax
  103040:	75 ee                	jne    103030 <pmem_init+0x20>
            endHighest = pmmap_t->end;
        length++;
        itr++;
    }
    nps = endHighest / PAGESIZE;
    set_nps(nps);
  103042:	83 ec 0c             	sub    $0xc,%esp
        if (endHighest < pmmap_t->end)
            endHighest = pmmap_t->end;
        length++;
        itr++;
    }
    nps = endHighest / PAGESIZE;
  103045:	c1 eb 0c             	shr    $0xc,%ebx
    set_nps(nps);
  103048:	53                   	push   %ebx
  103049:	e8 92 fe ff ff       	call   102ee0 <set_nps>
    for (itr = 0; itr < nps; itr++) {
  10304e:	83 c4 10             	add    $0x10,%esp
  103051:	85 db                	test   %ebx,%ebx
  103053:	74 45                	je     10309a <pmem_init+0x8a>
  103055:	31 ff                	xor    %edi,%edi
  103057:	89 f6                	mov    %esi,%esi
  103059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (itr <= VM_USERLO_PI || itr >= VM_USERHI_PI) {
  103060:	8d 87 ff ff fb ff    	lea    -0x40001(%edi),%eax
  103066:	3d fe ff 0a 00       	cmp    $0xafffe,%eax
  10306b:	0f 86 10 02 00 00    	jbe    103281 <pmem_init+0x271>
            set_permission(itr, PMMAP_RESV);
  103071:	83 ec 08             	sub    $0x8,%esp
  103074:	6a 01                	push   $0x1
  103076:	57                   	push   %edi
  103077:	e8 d4 fd ff ff       	call   102e50 <set_permission>
            set_free(itr, 0);
  10307c:	58                   	pop    %eax
  10307d:	5a                   	pop    %edx
  10307e:	6a 00                	push   $0x0
            set_valid(itr, 1);
        } else {
            set_permission(itr, PMMAP_USABLE);
            set_free(itr, 1);
  103080:	57                   	push   %edi
  103081:	e8 fa fd ff ff       	call   102e80 <set_free>
            set_valid(itr, 1);
  103086:	58                   	pop    %eax
  103087:	5a                   	pop    %edx
  103088:	6a 01                	push   $0x1
  10308a:	57                   	push   %edi
        length++;
        itr++;
    }
    nps = endHighest / PAGESIZE;
    set_nps(nps);
    for (itr = 0; itr < nps; itr++) {
  10308b:	83 c7 01             	add    $0x1,%edi
            set_free(itr, 0);
            set_valid(itr, 1);
        } else {
            set_permission(itr, PMMAP_USABLE);
            set_free(itr, 1);
            set_valid(itr, 1);
  10308e:	e8 1d fe ff ff       	call   102eb0 <set_valid>
  103093:	83 c4 10             	add    $0x10,%esp
        length++;
        itr++;
    }
    nps = endHighest / PAGESIZE;
    set_nps(nps);
    for (itr = 0; itr < nps; itr++) {
  103096:	39 fb                	cmp    %edi,%ebx
  103098:	75 c6                	jne    103060 <pmem_init+0x50>
            set_free(itr, 1);
            set_valid(itr, 1);
        }
    }
    // making regions which are marked usuable in the pmmap but doesn't meet the conditions to be reserved
    SLIST_FOREACH(pmmap_t1, pmmap_list_p, next)
  10309a:	8b 44 24 20          	mov    0x20(%esp),%eax
  10309e:	8b 38                	mov    (%eax),%edi
  1030a0:	85 ff                	test   %edi,%edi
  1030a2:	0f 84 46 01 00 00    	je     1031ee <pmem_init+0x1de>
  1030a8:	90                   	nop
  1030a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    {
        KERN_DEBUG("BIOS-e820: 0x%08x - 0x%08x (%s)\n",
  1030b0:	8b 47 08             	mov    0x8(%edi),%eax
  1030b3:	ba 1a 63 10 00       	mov    $0x10631a,%edx
  1030b8:	83 f8 01             	cmp    $0x1,%eax
  1030bb:	74 24                	je     1030e1 <pmem_init+0xd1>
  1030bd:	83 f8 02             	cmp    $0x2,%eax
  1030c0:	ba 11 63 10 00       	mov    $0x106311,%edx
  1030c5:	74 1a                	je     1030e1 <pmem_init+0xd1>
  1030c7:	83 f8 03             	cmp    $0x3,%eax
  1030ca:	ba 21 63 10 00       	mov    $0x106321,%edx
  1030cf:	74 10                	je     1030e1 <pmem_init+0xd1>
  1030d1:	83 f8 04             	cmp    $0x4,%eax
  1030d4:	ba 2b 63 10 00       	mov    $0x10632b,%edx
  1030d9:	b8 33 63 10 00       	mov    $0x106333,%eax
  1030de:	0f 44 d0             	cmove  %eax,%edx
  1030e1:	8b 0f                	mov    (%edi),%ecx
  1030e3:	8b 47 04             	mov    0x4(%edi),%eax
  1030e6:	39 c1                	cmp    %eax,%ecx
  1030e8:	74 0a                	je     1030f4 <pmem_init+0xe4>
  1030ea:	31 db                	xor    %ebx,%ebx
  1030ec:	83 f8 ff             	cmp    $0xffffffff,%eax
  1030ef:	0f 95 c3             	setne  %bl
  1030f2:	29 d8                	sub    %ebx,%eax
  1030f4:	83 ec 08             	sub    $0x8,%esp
  1030f7:	52                   	push   %edx
  1030f8:	50                   	push   %eax
  1030f9:	51                   	push   %ecx
  1030fa:	68 58 63 10 00       	push   $0x106358
  1030ff:	6a 40                	push   $0x40
  103101:	68 3c 63 10 00       	push   $0x10633c
  103106:	e8 83 eb ff ff       	call   101c8e <debug_normal>
                   (pmmap_t1->type == MEM_RAM) ? "usable" :
                   (pmmap_t1->type == MEM_RESERVED) ? "reserved" :
                   (pmmap_t1->type == MEM_ACPI) ? "ACPI data" :
                   (pmmap_t1->type == MEM_NVS) ? "ACPI NVS" :
                   "unknown");
        if (pmmap_t1->type == MEM_RAM) {
  10310b:	83 c4 20             	add    $0x20,%esp
  10310e:	83 7f 08 01          	cmpl   $0x1,0x8(%edi)
  103112:	0f 84 e8 00 00 00    	je     103200 <pmem_init+0x1f0>
//                KERN_DEBUG("Start: %d\n", pmmap_t1->start/PAGESIZE);

            }
        } else {
            int i = 0;
            for (i = (pmmap_t1->start) / PAGESIZE; i <= (pmmap_t1->end) / PAGESIZE; i++) {
  103118:	8b 1f                	mov    (%edi),%ebx
  10311a:	8b 47 04             	mov    0x4(%edi),%eax
  10311d:	c1 eb 0c             	shr    $0xc,%ebx
  103120:	c1 e8 0c             	shr    $0xc,%eax
  103123:	39 c3                	cmp    %eax,%ebx
  103125:	77 38                	ja     10315f <pmem_init+0x14f>
  103127:	89 f6                	mov    %esi,%esi
  103129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                set_permission(i, PMMAP_RESV);
  103130:	83 ec 08             	sub    $0x8,%esp
  103133:	6a 01                	push   $0x1
  103135:	53                   	push   %ebx
  103136:	e8 15 fd ff ff       	call   102e50 <set_permission>
                set_free(i, 0);
  10313b:	58                   	pop    %eax
  10313c:	5a                   	pop    %edx
  10313d:	6a 00                	push   $0x0
  10313f:	53                   	push   %ebx
  103140:	e8 3b fd ff ff       	call   102e80 <set_free>
                set_valid(i, 1);
  103145:	59                   	pop    %ecx
  103146:	58                   	pop    %eax
  103147:	6a 01                	push   $0x1
  103149:	53                   	push   %ebx
//                KERN_DEBUG("Start: %d\n", pmmap_t1->start/PAGESIZE);

            }
        } else {
            int i = 0;
            for (i = (pmmap_t1->start) / PAGESIZE; i <= (pmmap_t1->end) / PAGESIZE; i++) {
  10314a:	83 c3 01             	add    $0x1,%ebx
                set_permission(i, PMMAP_RESV);
                set_free(i, 0);
                set_valid(i, 1);
  10314d:	e8 5e fd ff ff       	call   102eb0 <set_valid>
//                KERN_DEBUG("Start: %d\n", pmmap_t1->start/PAGESIZE);

            }
        } else {
            int i = 0;
            for (i = (pmmap_t1->start) / PAGESIZE; i <= (pmmap_t1->end) / PAGESIZE; i++) {
  103152:	8b 47 04             	mov    0x4(%edi),%eax
  103155:	83 c4 10             	add    $0x10,%esp
  103158:	c1 e8 0c             	shr    $0xc,%eax
  10315b:	39 d8                	cmp    %ebx,%eax
  10315d:	73 d1                	jae    103130 <pmem_init+0x120>
            set_free(itr, 1);
            set_valid(itr, 1);
        }
    }
    // making regions which are marked usuable in the pmmap but doesn't meet the conditions to be reserved
    SLIST_FOREACH(pmmap_t1, pmmap_list_p, next)
  10315f:	8b 7f 0c             	mov    0xc(%edi),%edi
  103162:	85 ff                	test   %edi,%edi
  103164:	0f 85 46 ff ff ff    	jne    1030b0 <pmem_init+0xa0>

    }
    //making gaps unusable
    int i = 0, prev, next;
    unsigned int j = 0;
    SLIST_FOREACH(pmmap_t2, pmmap_list_p, next)
  10316a:	8b 44 24 20          	mov    0x20(%esp),%eax
  10316e:	8b 38                	mov    (%eax),%edi
  103170:	85 ff                	test   %edi,%edi
  103172:	74 7a                	je     1031ee <pmem_init+0x1de>
  103174:	31 db                	xor    %ebx,%ebx
  103176:	8d 76 00             	lea    0x0(%esi),%esi
  103179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    {
        if (i == 0) {
  103180:	85 db                	test   %ebx,%ebx
  103182:	74 5a                	je     1031de <pmem_init+0x1ce>
            prev = pmmap_t2->end - 1;

        } else if (i == length) {
  103184:	39 dd                	cmp    %ebx,%ebp
  103186:	74 66                	je     1031ee <pmem_init+0x1de>
            break;
        } else {
            next = pmmap_t2->start;
  103188:	8b 07                	mov    (%edi),%eax

            if (next - prev > 1) {
  10318a:	89 c2                	mov    %eax,%edx
  10318c:	29 f2                	sub    %esi,%edx
  10318e:	83 fa 01             	cmp    $0x1,%edx
  103191:	7e 4b                	jle    1031de <pmem_init+0x1ce>

                for (j = ((prev) / PAGESIZE); j < (pmmap_t2->start / PAGESIZE); j++) {
  103193:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
  103199:	85 f6                	test   %esi,%esi
  10319b:	0f 48 f2             	cmovs  %edx,%esi
  10319e:	c1 e8 0c             	shr    $0xc,%eax
  1031a1:	c1 fe 0c             	sar    $0xc,%esi
  1031a4:	39 c6                	cmp    %eax,%esi
  1031a6:	73 36                	jae    1031de <pmem_init+0x1ce>
  1031a8:	90                   	nop
  1031a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

                    set_permission(j, PMMAP_RESV);
  1031b0:	83 ec 08             	sub    $0x8,%esp
  1031b3:	6a 01                	push   $0x1
  1031b5:	56                   	push   %esi
  1031b6:	e8 95 fc ff ff       	call   102e50 <set_permission>
                    set_free(j, 0);
  1031bb:	58                   	pop    %eax
  1031bc:	5a                   	pop    %edx
  1031bd:	6a 00                	push   $0x0
  1031bf:	56                   	push   %esi
  1031c0:	e8 bb fc ff ff       	call   102e80 <set_free>
                    set_valid(j, 1);
  1031c5:	59                   	pop    %ecx
  1031c6:	58                   	pop    %eax
  1031c7:	6a 01                	push   $0x1
  1031c9:	56                   	push   %esi
        } else {
            next = pmmap_t2->start;

            if (next - prev > 1) {

                for (j = ((prev) / PAGESIZE); j < (pmmap_t2->start / PAGESIZE); j++) {
  1031ca:	83 c6 01             	add    $0x1,%esi

                    set_permission(j, PMMAP_RESV);
                    set_free(j, 0);
                    set_valid(j, 1);
  1031cd:	e8 de fc ff ff       	call   102eb0 <set_valid>
        } else {
            next = pmmap_t2->start;

            if (next - prev > 1) {

                for (j = ((prev) / PAGESIZE); j < (pmmap_t2->start / PAGESIZE); j++) {
  1031d2:	8b 07                	mov    (%edi),%eax
  1031d4:	83 c4 10             	add    $0x10,%esp
  1031d7:	c1 e8 0c             	shr    $0xc,%eax
  1031da:	39 f0                	cmp    %esi,%eax
  1031dc:	77 d2                	ja     1031b0 <pmem_init+0x1a0>
                    set_permission(j, PMMAP_RESV);
                    set_free(j, 0);
                    set_valid(j, 1);
                }
            }
            prev = pmmap_t2->end - 1;
  1031de:	8b 47 04             	mov    0x4(%edi),%eax

    }
    //making gaps unusable
    int i = 0, prev, next;
    unsigned int j = 0;
    SLIST_FOREACH(pmmap_t2, pmmap_list_p, next)
  1031e1:	8b 7f 0c             	mov    0xc(%edi),%edi
            }
            prev = pmmap_t2->end - 1;

        }

        i++;
  1031e4:	83 c3 01             	add    $0x1,%ebx

    }
    //making gaps unusable
    int i = 0, prev, next;
    unsigned int j = 0;
    SLIST_FOREACH(pmmap_t2, pmmap_list_p, next)
  1031e7:	85 ff                	test   %edi,%edi
                    set_permission(j, PMMAP_RESV);
                    set_free(j, 0);
                    set_valid(j, 1);
                }
            }
            prev = pmmap_t2->end - 1;
  1031e9:	8d 70 ff             	lea    -0x1(%eax),%esi

    }
    //making gaps unusable
    int i = 0, prev, next;
    unsigned int j = 0;
    SLIST_FOREACH(pmmap_t2, pmmap_list_p, next)
  1031ec:	75 92                	jne    103180 <pmem_init+0x170>



    /* you need to make this call at some point */

}
  1031ee:	83 c4 0c             	add    $0xc,%esp
  1031f1:	5b                   	pop    %ebx
  1031f2:	5e                   	pop    %esi
  1031f3:	5f                   	pop    %edi
  1031f4:	5d                   	pop    %ebp
  1031f5:	c3                   	ret    
  1031f6:	8d 76 00             	lea    0x0(%esi),%esi
  1031f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                   (pmmap_t1->type == MEM_RESERVED) ? "reserved" :
                   (pmmap_t1->type == MEM_ACPI) ? "ACPI data" :
                   (pmmap_t1->type == MEM_NVS) ? "ACPI NVS" :
                   "unknown");
        if (pmmap_t1->type == MEM_RAM) {
            if (pmmap_t1->end >= VM_USERLO) {
  103200:	81 7f 04 ff ff ff 3f 	cmpl   $0x3fffffff,0x4(%edi)
  103207:	0f 86 52 ff ff ff    	jbe    10315f <pmem_init+0x14f>
//                KERN_DEBUG("ENDD: %d\n", VM_USERLO/PAGESIZE);
                unsigned int nps_reserved = VM_USERLO / PAGESIZE;
                int i = 0;
                for (i = (pmmap_t1->start) / PAGESIZE; i <= nps_reserved; i++) {
  10320d:	8b 1f                	mov    (%edi),%ebx
  10320f:	c1 eb 0c             	shr    $0xc,%ebx
  103212:	81 fb 00 00 04 00    	cmp    $0x40000,%ebx
  103218:	77 33                	ja     10324d <pmem_init+0x23d>
  10321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    set_permission(i, PMMAP_RESV);
  103220:	83 ec 08             	sub    $0x8,%esp
  103223:	6a 01                	push   $0x1
  103225:	53                   	push   %ebx
  103226:	e8 25 fc ff ff       	call   102e50 <set_permission>
                    set_free(i, 0);
  10322b:	58                   	pop    %eax
  10322c:	5a                   	pop    %edx
  10322d:	6a 00                	push   $0x0
  10322f:	53                   	push   %ebx
  103230:	e8 4b fc ff ff       	call   102e80 <set_free>
                    set_valid(i, 1);
  103235:	59                   	pop    %ecx
  103236:	58                   	pop    %eax
  103237:	6a 01                	push   $0x1
  103239:	53                   	push   %ebx
        if (pmmap_t1->type == MEM_RAM) {
            if (pmmap_t1->end >= VM_USERLO) {
//                KERN_DEBUG("ENDD: %d\n", VM_USERLO/PAGESIZE);
                unsigned int nps_reserved = VM_USERLO / PAGESIZE;
                int i = 0;
                for (i = (pmmap_t1->start) / PAGESIZE; i <= nps_reserved; i++) {
  10323a:	83 c3 01             	add    $0x1,%ebx
                    set_permission(i, PMMAP_RESV);
                    set_free(i, 0);
                    set_valid(i, 1);
  10323d:	e8 6e fc ff ff       	call   102eb0 <set_valid>
        if (pmmap_t1->type == MEM_RAM) {
            if (pmmap_t1->end >= VM_USERLO) {
//                KERN_DEBUG("ENDD: %d\n", VM_USERLO/PAGESIZE);
                unsigned int nps_reserved = VM_USERLO / PAGESIZE;
                int i = 0;
                for (i = (pmmap_t1->start) / PAGESIZE; i <= nps_reserved; i++) {
  103242:	83 c4 10             	add    $0x10,%esp
  103245:	81 fb 01 00 04 00    	cmp    $0x40001,%ebx
  10324b:	75 d3                	jne    103220 <pmem_init+0x210>
                    set_permission(i, PMMAP_RESV);
                    set_free(i, 0);
                    set_valid(i, 1);
                }
                set_latest_allocated_page(nps_reserved);
  10324d:	83 ec 0c             	sub    $0xc,%esp
  103250:	68 00 00 04 00       	push   $0x40000
  103255:	e8 96 fc ff ff       	call   102ef0 <set_latest_allocated_page>
            set_free(itr, 1);
            set_valid(itr, 1);
        }
    }
    // making regions which are marked usuable in the pmmap but doesn't meet the conditions to be reserved
    SLIST_FOREACH(pmmap_t1, pmmap_list_p, next)
  10325a:	8b 7f 0c             	mov    0xc(%edi),%edi
                for (i = (pmmap_t1->start) / PAGESIZE; i <= nps_reserved; i++) {
                    set_permission(i, PMMAP_RESV);
                    set_free(i, 0);
                    set_valid(i, 1);
                }
                set_latest_allocated_page(nps_reserved);
  10325d:	83 c4 10             	add    $0x10,%esp
            set_free(itr, 1);
            set_valid(itr, 1);
        }
    }
    // making regions which are marked usuable in the pmmap but doesn't meet the conditions to be reserved
    SLIST_FOREACH(pmmap_t1, pmmap_list_p, next)
  103260:	85 ff                	test   %edi,%edi
  103262:	0f 85 48 fe ff ff    	jne    1030b0 <pmem_init+0xa0>
  103268:	e9 fd fe ff ff       	jmp    10316a <pmem_init+0x15a>
            endHighest = pmmap_t->end;
        length++;
        itr++;
    }
    nps = endHighest / PAGESIZE;
    set_nps(nps);
  10326d:	83 ec 0c             	sub    $0xc,%esp
        PMMAP_USABLE, PMMAP_RESV, PMMAP_ACPI, PMMAP_NVS
    };

    unsigned int nps;
    struct pmmap *pmmap_t, *pmmap_t1, *pmmap_t2;
    int itr = 0, length = 0;
  103270:	31 ed                	xor    %ebp,%ebp
            endHighest = pmmap_t->end;
        length++;
        itr++;
    }
    nps = endHighest / PAGESIZE;
    set_nps(nps);
  103272:	6a 00                	push   $0x0
  103274:	e8 67 fc ff ff       	call   102ee0 <set_nps>
  103279:	83 c4 10             	add    $0x10,%esp
  10327c:	e9 19 fe ff ff       	jmp    10309a <pmem_init+0x8a>
        if (itr <= VM_USERLO_PI || itr >= VM_USERHI_PI) {
            set_permission(itr, PMMAP_RESV);
            set_free(itr, 0);
            set_valid(itr, 1);
        } else {
            set_permission(itr, PMMAP_USABLE);
  103281:	83 ec 08             	sub    $0x8,%esp
  103284:	6a 00                	push   $0x0
  103286:	57                   	push   %edi
  103287:	e8 c4 fb ff ff       	call   102e50 <set_permission>
            set_free(itr, 1);
  10328c:	59                   	pop    %ecx
  10328d:	58                   	pop    %eax
  10328e:	6a 01                	push   $0x1
  103290:	e9 eb fd ff ff       	jmp    103080 <pmem_init+0x70>
  103295:	66 90                	xchg   %ax,%ax
  103297:	66 90                	xchg   %ax,%ax
  103299:	66 90                	xchg   %ax,%ax
  10329b:	66 90                	xchg   %ax,%ax
  10329d:	66 90                	xchg   %ax,%ax
  10329f:	90                   	nop

001032a0 <MATInit_test1>:
#include <lib/debug.h>
#include <pmm/MATIntro/export.h>

int MATInit_test1()
{
  1032a0:	83 ec 0c             	sub    $0xc,%esp
  int i;
  int nps = get_nps();
  1032a3:	e8 28 fc ff ff       	call   102ed0 <get_nps>
  if (nps <= 1000) {
  1032a8:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  1032ad:	7e 19                	jle    1032c8 <MATInit_test1+0x28>
    dprintf("test 1 failed.\n");
    return 1;
  }

  dprintf("test 1 passed.\n");
  1032af:	83 ec 0c             	sub    $0xc,%esp
  1032b2:	68 01 63 10 00       	push   $0x106301
  1032b7:	e8 4f eb ff ff       	call   101e0b <dprintf>
  return 0;
  1032bc:	83 c4 10             	add    $0x10,%esp
  1032bf:	31 c0                	xor    %eax,%eax
}
  1032c1:	83 c4 0c             	add    $0xc,%esp
  1032c4:	c3                   	ret    
  1032c5:	8d 76 00             	lea    0x0(%esi),%esi
int MATInit_test1()
{
  int i;
  int nps = get_nps();
  if (nps <= 1000) {
    dprintf("test 1 failed.\n");
  1032c8:	83 ec 0c             	sub    $0xc,%esp
  1032cb:	68 f1 62 10 00       	push   $0x1062f1
  1032d0:	e8 36 eb ff ff       	call   101e0b <dprintf>
    return 1;
  1032d5:	83 c4 10             	add    $0x10,%esp
  1032d8:	b8 01 00 00 00       	mov    $0x1,%eax
  }

  dprintf("test 1 passed.\n");
  return 0;
}
  1032dd:	83 c4 0c             	add    $0xc,%esp
  1032e0:	c3                   	ret    
  1032e1:	eb 0d                	jmp    1032f0 <MATInit_test_own>
  1032e3:	90                   	nop
  1032e4:	90                   	nop
  1032e5:	90                   	nop
  1032e6:	90                   	nop
  1032e7:	90                   	nop
  1032e8:	90                   	nop
  1032e9:	90                   	nop
  1032ea:	90                   	nop
  1032eb:	90                   	nop
  1032ec:	90                   	nop
  1032ed:	90                   	nop
  1032ee:	90                   	nop
  1032ef:	90                   	nop

001032f0 <MATInit_test_own>:
int MATInit_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  1032f0:	31 c0                	xor    %eax,%eax
  1032f2:	c3                   	ret    
  1032f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1032f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103300 <test_MATInit>:

int test_MATInit()
{
  return MATInit_test1() + MATInit_test_own();
  103300:	eb 9e                	jmp    1032a0 <MATInit_test1>
  103302:	66 90                	xchg   %ax,%ax
  103304:	66 90                	xchg   %ax,%ax
  103306:	66 90                	xchg   %ax,%ax
  103308:	66 90                	xchg   %ax,%ax
  10330a:	66 90                	xchg   %ax,%ax
  10330c:	66 90                	xchg   %ax,%ax
  10330e:	66 90                	xchg   %ax,%ax

00103310 <palloc>:
  * 2. Optimize the code with the memorization techniques so that you do not
  *    have to scan the data-structure from scratch every time.
  */
unsigned int
palloc()
{
  103310:	56                   	push   %esi
  103311:	53                   	push   %ebx
  103312:	83 ec 04             	sub    $0x4,%esp
  // TODO
    unsigned int nps = get_nps();
  103315:	e8 b6 fb ff ff       	call   102ed0 <get_nps>
    int itr = 0;
    unsigned int latest_allocated_page = get_latest_allocated_page();
  10331a:	e8 e1 fb ff ff       	call   102f00 <get_latest_allocated_page>
    //KERN_DEBUG("0x%08x\n", latest_allocated_page*PAGESIZE);
    for (itr = latest_allocated_page; itr < VM_USERHI_PI; itr++) {
  10331f:	3d ff ff 0e 00       	cmp    $0xeffff,%eax
  103324:	89 c3                	mov    %eax,%ebx
  103326:	76 13                	jbe    10333b <palloc+0x2b>
  103328:	eb 56                	jmp    103380 <palloc+0x70>
  10332a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103330:	83 c3 01             	add    $0x1,%ebx
  103333:	81 fb 00 00 0f 00    	cmp    $0xf0000,%ebx
  103339:	74 45                	je     103380 <palloc+0x70>
        if (is_free(itr) == 1 && is_valid(itr) == 1) {
  10333b:	83 ec 0c             	sub    $0xc,%esp
  10333e:	89 de                	mov    %ebx,%esi
  103340:	53                   	push   %ebx
  103341:	e8 2a fb ff ff       	call   102e70 <is_free>
  103346:	83 c4 10             	add    $0x10,%esp
  103349:	83 f8 01             	cmp    $0x1,%eax
  10334c:	75 e2                	jne    103330 <palloc+0x20>
  10334e:	83 ec 0c             	sub    $0xc,%esp
  103351:	53                   	push   %ebx
  103352:	e8 49 fb ff ff       	call   102ea0 <is_valid>
  103357:	83 c4 10             	add    $0x10,%esp
  10335a:	83 f8 01             	cmp    $0x1,%eax
  10335d:	75 d1                	jne    103330 <palloc+0x20>
            set_free(itr, 0);
  10335f:	83 ec 08             	sub    $0x8,%esp
  103362:	6a 00                	push   $0x0
  103364:	53                   	push   %ebx
  103365:	e8 16 fb ff ff       	call   102e80 <set_free>
            set_latest_allocated_page(itr);
  10336a:	89 1c 24             	mov    %ebx,(%esp)
  10336d:	e8 7e fb ff ff       	call   102ef0 <set_latest_allocated_page>
            return itr;
  103372:	83 c4 10             	add    $0x10,%esp
  103375:	eb 0b                	jmp    103382 <palloc+0x72>
  103377:	89 f6                	mov    %esi,%esi
  103379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    return itr;
                }
            }
        }
    }
  return 0;
  103380:	31 f6                	xor    %esi,%esi
}
  103382:	83 c4 04             	add    $0x4,%esp
  103385:	89 f0                	mov    %esi,%eax
  103387:	5b                   	pop    %ebx
  103388:	5e                   	pop    %esi
  103389:	c3                   	ret    
  10338a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103390 <pfree>:
  * Hint: Simple. Check if a page is allocated and to set the allocation status
  *       of a page index.
  */
void
pfree(unsigned int pfree_index)
{
  103390:	53                   	push   %ebx
  103391:	83 ec 14             	sub    $0x14,%esp
  103394:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    if (is_free(pfree_index) == 0) {
  103398:	53                   	push   %ebx
  103399:	e8 d2 fa ff ff       	call   102e70 <is_free>
  10339e:	83 c4 10             	add    $0x10,%esp
  1033a1:	85 c0                	test   %eax,%eax
  1033a3:	75 0e                	jne    1033b3 <pfree+0x23>
        set_free(pfree_index, 1);
  1033a5:	83 ec 08             	sub    $0x8,%esp
  1033a8:	6a 01                	push   $0x1
  1033aa:	53                   	push   %ebx
  1033ab:	e8 d0 fa ff ff       	call   102e80 <set_free>
  1033b0:	83 c4 10             	add    $0x10,%esp
    }

}
  1033b3:	83 c4 08             	add    $0x8,%esp
  1033b6:	5b                   	pop    %ebx
  1033b7:	c3                   	ret    
  1033b8:	66 90                	xchg   %ax,%ax
  1033ba:	66 90                	xchg   %ax,%ax
  1033bc:	66 90                	xchg   %ax,%ax
  1033be:	66 90                	xchg   %ax,%ax

001033c0 <MATOp_test1>:
#include <lib/debug.h>
#include <pmm/MATIntro/export.h>
#include "export.h"

int MATOp_test1()
{
  1033c0:	83 ec 0c             	sub    $0xc,%esp
  int page_index = palloc();
  1033c3:	e8 48 ff ff ff       	call   103310 <palloc>
  if (page_index < 262144) {
  1033c8:	3d ff ff 03 00       	cmp    $0x3ffff,%eax
  1033cd:	7e 19                	jle    1033e8 <MATOp_test1+0x28>
    pfree(page_index);
    dprintf("test 1 failed.\n");
    return 1;
  }

  dprintf("test 1 passed.\n");
  1033cf:	83 ec 0c             	sub    $0xc,%esp
  1033d2:	68 01 63 10 00       	push   $0x106301
  1033d7:	e8 2f ea ff ff       	call   101e0b <dprintf>
  return 0;
  1033dc:	83 c4 10             	add    $0x10,%esp
  1033df:	31 c0                	xor    %eax,%eax
}
  1033e1:	83 c4 0c             	add    $0xc,%esp
  1033e4:	c3                   	ret    
  1033e5:	8d 76 00             	lea    0x0(%esi),%esi

int MATOp_test1()
{
  int page_index = palloc();
  if (page_index < 262144) {
    pfree(page_index);
  1033e8:	83 ec 0c             	sub    $0xc,%esp
  1033eb:	50                   	push   %eax
  1033ec:	e8 9f ff ff ff       	call   103390 <pfree>
    dprintf("test 1 failed.\n");
  1033f1:	c7 04 24 f1 62 10 00 	movl   $0x1062f1,(%esp)
  1033f8:	e8 0e ea ff ff       	call   101e0b <dprintf>
    return 1;
  1033fd:	83 c4 10             	add    $0x10,%esp
  103400:	b8 01 00 00 00       	mov    $0x1,%eax
  }

  dprintf("test 1 passed.\n");
  return 0;
}
  103405:	83 c4 0c             	add    $0xc,%esp
  103408:	c3                   	ret    
  103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103410 <MATOp_test_own>:
int MATOp_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  103410:	31 c0                	xor    %eax,%eax
  103412:	c3                   	ret    
  103413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103420 <test_MATOp>:

int test_MATOp()
{
  return MATOp_test1() + MATOp_test_own();
  103420:	eb 9e                	jmp    1033c0 <MATOp_test1>
  103422:	66 90                	xchg   %ax,%ax
  103424:	66 90                	xchg   %ax,%ax
  103426:	66 90                	xchg   %ax,%ax
  103428:	66 90                	xchg   %ax,%ax
  10342a:	66 90                	xchg   %ax,%ax
  10342c:	66 90                	xchg   %ax,%ax
  10342e:	66 90                	xchg   %ax,%ax

00103430 <container_init>:
/**
  * Initializes the container data for the root process (the one with index 0).
  * The root process is the one that gets spawned first by the kernel.
  */
void container_init(unsigned int mbi_addr)
{
  103430:	56                   	push   %esi
  103431:	53                   	push   %ebx
  103432:	31 f6                	xor    %esi,%esi
  103434:	bb 00 00 04 00       	mov    $0x40000,%ebx
  103439:	83 ec 04             	sub    $0x4,%esp
  10343c:	eb 0d                	jmp    10344b <container_init+0x1b>
  10343e:	66 90                	xchg   %ax,%ax
    *  - It should be the number of the unallocated pages with the normal permission
    *    in the physical memory data-structure you implemented.
    */
  //TODO
  int itr = 0;
  for (itr = VM_USERLO_PI; itr < VM_USERHI_PI; itr++) {
  103440:	83 c3 01             	add    $0x1,%ebx
  103443:	81 fb 00 00 0f 00    	cmp    $0xf0000,%ebx
  103449:	74 43                	je     10348e <container_init+0x5e>
    if (get_permission(itr) == PMMAP_USABLE && is_free(itr) == 1 && is_valid(itr) == 1) {
  10344b:	83 ec 0c             	sub    $0xc,%esp
  10344e:	53                   	push   %ebx
  10344f:	e8 ec f9 ff ff       	call   102e40 <get_permission>
  103454:	83 c4 10             	add    $0x10,%esp
  103457:	85 c0                	test   %eax,%eax
  103459:	75 e5                	jne    103440 <container_init+0x10>
  10345b:	83 ec 0c             	sub    $0xc,%esp
  10345e:	53                   	push   %ebx
  10345f:	e8 0c fa ff ff       	call   102e70 <is_free>
  103464:	83 c4 10             	add    $0x10,%esp
  103467:	83 f8 01             	cmp    $0x1,%eax
  10346a:	75 d4                	jne    103440 <container_init+0x10>
  10346c:	83 ec 0c             	sub    $0xc,%esp
  10346f:	53                   	push   %ebx
  103470:	e8 2b fa ff ff       	call   102ea0 <is_valid>
  103475:	83 c4 10             	add    $0x10,%esp
      real_quota++;
  103478:	83 f8 01             	cmp    $0x1,%eax
  10347b:	0f 94 c0             	sete   %al
    *  - It should be the number of the unallocated pages with the normal permission
    *    in the physical memory data-structure you implemented.
    */
  //TODO
  int itr = 0;
  for (itr = VM_USERLO_PI; itr < VM_USERHI_PI; itr++) {
  10347e:	83 c3 01             	add    $0x1,%ebx
    if (get_permission(itr) == PMMAP_USABLE && is_free(itr) == 1 && is_valid(itr) == 1) {
      real_quota++;
  103481:	0f b6 c0             	movzbl %al,%eax
  103484:	01 c6                	add    %eax,%esi
    *  - It should be the number of the unallocated pages with the normal permission
    *    in the physical memory data-structure you implemented.
    */
  //TODO
  int itr = 0;
  for (itr = VM_USERLO_PI; itr < VM_USERHI_PI; itr++) {
  103486:	81 fb 00 00 0f 00    	cmp    $0xf0000,%ebx
  10348c:	75 bd                	jne    10344b <container_init+0x1b>

    }
  }


  KERN_DEBUG("\nreal quota: %d\n\n", real_quota);
  10348e:	56                   	push   %esi
  10348f:	68 79 63 10 00       	push   $0x106379
  103494:	6a 43                	push   $0x43
  103496:	68 8c 63 10 00       	push   $0x10638c
  10349b:	e8 ee e7 ff ff       	call   101c8e <debug_normal>

  CONTAINER[0].quota = real_quota;
  1034a0:	89 35 80 5f 92 01    	mov    %esi,0x1925f80
  CONTAINER[0].usage = 0;
  1034a6:	c7 05 84 5f 92 01 00 	movl   $0x0,0x1925f84
  1034ad:	00 00 00 
  CONTAINER[0].parent = 0;
  1034b0:	c7 05 88 5f 92 01 00 	movl   $0x0,0x1925f88
  1034b7:	00 00 00 
  CONTAINER[0].nchildren = 0;
  1034ba:	c7 05 8c 5f 92 01 00 	movl   $0x0,0x1925f8c
  1034c1:	00 00 00 
  CONTAINER[0].used = 1;
  1034c4:	c7 05 90 5f 92 01 01 	movl   $0x1,0x1925f90
  1034cb:	00 00 00 
}
  1034ce:	83 c4 14             	add    $0x14,%esp
  1034d1:	5b                   	pop    %ebx
  1034d2:	5e                   	pop    %esi
  1034d3:	c3                   	ret    
  1034d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1034da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001034e0 <container_get_parent>:
/** TASK 2:
  * * Get the id of parent process of process # [id]
  * Hint: Simply return the parent field from CONTAINER for process id.
  */
unsigned int container_get_parent(unsigned int id)
{
  1034e0:	8b 44 24 04          	mov    0x4(%esp),%eax
  // TODO

  return CONTAINER[id].parent;
  1034e4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1034e7:	8b 04 85 88 5f 92 01 	mov    0x1925f88(,%eax,4),%eax
}
  1034ee:	c3                   	ret    
  1034ef:	90                   	nop

001034f0 <container_get_nchildren>:

/** TASK 3:
  * * Get the number of children of process # [id]
  */
unsigned int container_get_nchildren(unsigned int id)
{
  1034f0:	8b 44 24 04          	mov    0x4(%esp),%eax
  // TODO
  return CONTAINER[id].nchildren;
  1034f4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  1034f7:	8b 04 85 8c 5f 92 01 	mov    0x1925f8c(,%eax,4),%eax
}
  1034fe:	c3                   	ret    
  1034ff:	90                   	nop

00103500 <container_get_quota>:

/** TASK 4:
  * * Get the maximum memory quota of process # [id]
  */
unsigned int container_get_quota(unsigned int id)
{
  103500:	8b 44 24 04          	mov    0x4(%esp),%eax
  // TODO
  return CONTAINER[id].quota;
  103504:	8d 04 80             	lea    (%eax,%eax,4),%eax
  103507:	8b 04 85 80 5f 92 01 	mov    0x1925f80(,%eax,4),%eax
}
  10350e:	c3                   	ret    
  10350f:	90                   	nop

00103510 <container_get_usage>:

/** TASK 5:
  * * Get the current memory usage of process # [id]
  */
unsigned int container_get_usage(unsigned int id)
{
  103510:	8b 44 24 04          	mov    0x4(%esp),%eax
  // TODO
  return CONTAINER[id].usage;
  103514:	8d 04 80             	lea    (%eax,%eax,4),%eax
  103517:	8b 04 85 84 5f 92 01 	mov    0x1925f84(,%eax,4),%eax
}
  10351e:	c3                   	ret    
  10351f:	90                   	nop

00103520 <container_can_consume>:
  * * Determine whether the process # [id] can consume extra
  *   [n] pages of memory. If so, return 1, otherwise, return 0.
  * Hint 1: Check the definition of available fields in SContainer data-structure.
  */
unsigned int container_can_consume(unsigned int id, unsigned int n)
{
  103520:	8b 44 24 04          	mov    0x4(%esp),%eax
  // TODO
  int diff = CONTAINER[id].quota - CONTAINER[id].usage;
  103524:	8d 14 80             	lea    (%eax,%eax,4),%edx
  103527:	8b 04 95 80 5f 92 01 	mov    0x1925f80(,%edx,4),%eax
  10352e:	2b 04 95 84 5f 92 01 	sub    0x1925f84(,%edx,4),%eax
  103535:	3b 44 24 08          	cmp    0x8(%esp),%eax
  103539:	0f 97 c0             	seta   %al
  10353c:	0f b6 c0             	movzbl %al,%eax
  if (diff > n)
    return 1;
  else
    return 0;
}
  10353f:	c3                   	ret    

00103540 <container_split>:
/**
 * Dedicates [quota] pages of memory for a new child process.
 * returns the container index for the new child process.
 */
unsigned int container_split(unsigned int id, unsigned int quota)
{
  103540:	55                   	push   %ebp
  103541:	57                   	push   %edi
  103542:	56                   	push   %esi
  103543:	53                   	push   %ebx
  103544:	8b 54 24 14          	mov    0x14(%esp),%edx
  103548:	8b 6c 24 18          	mov    0x18(%esp),%ebp
  unsigned int child, nc;

  nc = CONTAINER[id].nchildren;
  10354c:	8d 04 92             	lea    (%edx,%edx,4),%eax
  10354f:	8d 1c 85 80 5f 92 01 	lea    0x1925f80(,%eax,4),%ebx
  child = id * MAX_CHILDREN + 1 + nc; //container index for the child process
  103556:	8d 04 52             	lea    (%edx,%edx,2),%eax
  103559:	8b 73 0c             	mov    0xc(%ebx),%esi
    *         (available at the top of this page and handout)
    */
  //TODO

  CONTAINER[child].quota = quota;
  CONTAINER[id].usage += quota;
  10355c:	01 6b 04             	add    %ebp,0x4(%ebx)
unsigned int container_split(unsigned int id, unsigned int quota)
{
  unsigned int child, nc;

  nc = CONTAINER[id].nchildren;
  child = id * MAX_CHILDREN + 1 + nc; //container index for the child process
  10355f:	83 c6 01             	add    $0x1,%esi
  103562:	01 f0                	add    %esi,%eax
    */
  //TODO

  CONTAINER[child].quota = quota;
  CONTAINER[id].usage += quota;
  CONTAINER[id].nchildren++;
  103564:	89 73 0c             	mov    %esi,0xc(%ebx)
    * Hint 1: Read about the parent/child relationship maintained in you kernel
    *         (available at the top of this page and handout)
    */
  //TODO

  CONTAINER[child].quota = quota;
  103567:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  CONTAINER[child].usage = 0;
  CONTAINER[child].parent = id;
  CONTAINER[child].nchildren = 0;
  CONTAINER[child].used = 1;
  return child;
}
  10356a:	5b                   	pop    %ebx
    * Hint 1: Read about the parent/child relationship maintained in you kernel
    *         (available at the top of this page and handout)
    */
  //TODO

  CONTAINER[child].quota = quota;
  10356b:	c1 e7 02             	shl    $0x2,%edi
  10356e:	89 af 80 5f 92 01    	mov    %ebp,0x1925f80(%edi)
  CONTAINER[id].usage += quota;
  CONTAINER[id].nchildren++;
  CONTAINER[child].usage = 0;
  103574:	c7 87 84 5f 92 01 00 	movl   $0x0,0x1925f84(%edi)
  10357b:	00 00 00 
  CONTAINER[child].parent = id;
  CONTAINER[child].nchildren = 0;
  CONTAINER[child].used = 1;
  return child;
}
  10357e:	5e                   	pop    %esi

  CONTAINER[child].quota = quota;
  CONTAINER[id].usage += quota;
  CONTAINER[id].nchildren++;
  CONTAINER[child].usage = 0;
  CONTAINER[child].parent = id;
  10357f:	89 97 88 5f 92 01    	mov    %edx,0x1925f88(%edi)
  CONTAINER[child].nchildren = 0;
  103585:	c7 87 8c 5f 92 01 00 	movl   $0x0,0x1925f8c(%edi)
  10358c:	00 00 00 
  CONTAINER[child].used = 1;
  10358f:	c7 87 90 5f 92 01 01 	movl   $0x1,0x1925f90(%edi)
  103596:	00 00 00 
  return child;
}
  103599:	5f                   	pop    %edi
  10359a:	5d                   	pop    %ebp
  10359b:	c3                   	ret    
  10359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001035a0 <container_alloc>:
  * * 1. Allocates one more page for process # [id], given that its usage would not exceed the quota.
  * * 2. Update the contained structure to reflect the container structure should be updated accordingly after the allocation.
  * returns the page index of the allocated page, or 0 in the case of failure.
  */
unsigned int container_alloc(unsigned int id)
{
  1035a0:	53                   	push   %ebx
  1035a1:	83 ec 08             	sub    $0x8,%esp
  1035a4:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  /*
   * TODO: implement the function here.
   */
  unsigned int page_index;
  page_index = palloc();
  1035a8:	e8 63 fd ff ff       	call   103310 <palloc>
  CONTAINER[id].usage++;
  1035ad:	8d 14 9b             	lea    (%ebx,%ebx,4),%edx
  1035b0:	83 04 95 84 5f 92 01 	addl   $0x1,0x1925f84(,%edx,4)
  1035b7:	01 
  return page_index;
}
  1035b8:	83 c4 08             	add    $0x8,%esp
  1035bb:	5b                   	pop    %ebx
  1035bc:	c3                   	ret    
  1035bd:	8d 76 00             	lea    0x0(%esi),%esi

001035c0 <container_free>:
  * Hint: You have already implemented functions:
  *  - to check if a page_index is allocated
  *  - to free a page_index in MATOp layer.
  */
void container_free(unsigned int id, unsigned int page_index)
{
  1035c0:	53                   	push   %ebx
  1035c1:	83 ec 14             	sub    $0x14,%esp
  1035c4:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
  // TODO
  pfree(page_index);
  1035c8:	ff 74 24 20          	pushl  0x20(%esp)
  1035cc:	e8 bf fd ff ff       	call   103390 <pfree>
  CONTAINER[id].usage--;
  1035d1:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
  1035d4:	83 2c 85 84 5f 92 01 	subl   $0x1,0x1925f84(,%eax,4)
  1035db:	01 
}
  1035dc:	83 c4 18             	add    $0x18,%esp
  1035df:	5b                   	pop    %ebx
  1035e0:	c3                   	ret    
  1035e1:	66 90                	xchg   %ax,%ax
  1035e3:	66 90                	xchg   %ax,%ax
  1035e5:	66 90                	xchg   %ax,%ax
  1035e7:	66 90                	xchg   %ax,%ax
  1035e9:	66 90                	xchg   %ax,%ax
  1035eb:	66 90                	xchg   %ax,%ax
  1035ed:	66 90                	xchg   %ax,%ax
  1035ef:	90                   	nop

001035f0 <MContainer_test1>:
#include <lib/debug.h>
#include "export.h"

int MContainer_test1()
{
  1035f0:	83 ec 18             	sub    $0x18,%esp
  if (container_get_quota(0) <= 10000) {
  1035f3:	6a 00                	push   $0x0
  1035f5:	e8 06 ff ff ff       	call   103500 <container_get_quota>
  1035fa:	83 c4 10             	add    $0x10,%esp
  1035fd:	3d 10 27 00 00       	cmp    $0x2710,%eax
  103602:	76 17                	jbe    10361b <MContainer_test1+0x2b>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (container_can_consume(0, 10000) != 1) {
  103604:	83 ec 08             	sub    $0x8,%esp
  103607:	68 10 27 00 00       	push   $0x2710
  10360c:	6a 00                	push   $0x0
  10360e:	e8 0d ff ff ff       	call   103520 <container_can_consume>
  103613:	83 c4 10             	add    $0x10,%esp
  103616:	83 f8 01             	cmp    $0x1,%eax
  103619:	74 1d                	je     103638 <MContainer_test1+0x48>
#include "export.h"

int MContainer_test1()
{
  if (container_get_quota(0) <= 10000) {
    dprintf("test 1 failed.\n");
  10361b:	83 ec 0c             	sub    $0xc,%esp
  10361e:	68 f1 62 10 00       	push   $0x1062f1
  103623:	e8 e3 e7 ff ff       	call   101e0b <dprintf>
    return 1;
  103628:	83 c4 10             	add    $0x10,%esp
  10362b:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  103630:	83 c4 0c             	add    $0xc,%esp
  103633:	c3                   	ret    
  103634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  if (container_can_consume(0, 10000) != 1) {
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (container_can_consume(0, 10000000) != 0) {
  103638:	83 ec 08             	sub    $0x8,%esp
  10363b:	68 80 96 98 00       	push   $0x989680
  103640:	6a 00                	push   $0x0
  103642:	e8 d9 fe ff ff       	call   103520 <container_can_consume>
  103647:	83 c4 10             	add    $0x10,%esp
  10364a:	85 c0                	test   %eax,%eax
  10364c:	75 cd                	jne    10361b <MContainer_test1+0x2b>
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  10364e:	83 ec 0c             	sub    $0xc,%esp
  103651:	68 01 63 10 00       	push   $0x106301
  103656:	e8 b0 e7 ff ff       	call   101e0b <dprintf>
  10365b:	83 c4 10             	add    $0x10,%esp
  return 0;
  10365e:	31 c0                	xor    %eax,%eax
}
  103660:	83 c4 0c             	add    $0xc,%esp
  103663:	c3                   	ret    
  103664:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10366a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103670 <MContainer_test2>:


int MContainer_test2()
{
  103670:	57                   	push   %edi
  103671:	56                   	push   %esi
  103672:	53                   	push   %ebx
  unsigned int old_usage = container_get_usage(0);
  103673:	83 ec 0c             	sub    $0xc,%esp
  103676:	6a 00                	push   $0x0
  103678:	e8 93 fe ff ff       	call   103510 <container_get_usage>
  unsigned int old_nchildren = container_get_nchildren(0);
  10367d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
}


int MContainer_test2()
{
  unsigned int old_usage = container_get_usage(0);
  103684:	89 c6                	mov    %eax,%esi
  unsigned int old_nchildren = container_get_nchildren(0);
  103686:	e8 65 fe ff ff       	call   1034f0 <container_get_nchildren>
  10368b:	89 c7                	mov    %eax,%edi
  unsigned int chid = container_split(0, 100);
  10368d:	58                   	pop    %eax
  10368e:	5a                   	pop    %edx
  10368f:	6a 64                	push   $0x64
  103691:	6a 00                	push   $0x0
  103693:	e8 a8 fe ff ff       	call   103540 <container_split>
  if (container_get_quota(chid) != 100 || container_get_parent(chid) != 0 ||
  103698:	89 04 24             	mov    %eax,(%esp)

int MContainer_test2()
{
  unsigned int old_usage = container_get_usage(0);
  unsigned int old_nchildren = container_get_nchildren(0);
  unsigned int chid = container_split(0, 100);
  10369b:	89 c3                	mov    %eax,%ebx
  if (container_get_quota(chid) != 100 || container_get_parent(chid) != 0 ||
  10369d:	e8 5e fe ff ff       	call   103500 <container_get_quota>
  1036a2:	83 c4 10             	add    $0x10,%esp
  1036a5:	83 f8 64             	cmp    $0x64,%eax
  1036a8:	74 1e                	je     1036c8 <MContainer_test2+0x58>
      container_get_usage(chid) != 0 || container_get_nchildren(chid) != 0 ||
      container_get_usage(0) != old_usage + 100 || container_get_nchildren(0) != old_nchildren + 1) {
    dprintf("test 2 failed.\n");
  1036aa:	83 ec 0c             	sub    $0xc,%esp
  1036ad:	68 ad 63 10 00       	push   $0x1063ad
  1036b2:	e8 54 e7 ff ff       	call   101e0b <dprintf>
    return 1;
  1036b7:	83 c4 10             	add    $0x10,%esp
  1036ba:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 2 failed.\n");
    return 1;
  }
  dprintf("test 2 passed.\n");
  return 0;
}
  1036bf:	5b                   	pop    %ebx
  1036c0:	5e                   	pop    %esi
  1036c1:	5f                   	pop    %edi
  1036c2:	c3                   	ret    
  1036c3:	90                   	nop
  1036c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int MContainer_test2()
{
  unsigned int old_usage = container_get_usage(0);
  unsigned int old_nchildren = container_get_nchildren(0);
  unsigned int chid = container_split(0, 100);
  if (container_get_quota(chid) != 100 || container_get_parent(chid) != 0 ||
  1036c8:	83 ec 0c             	sub    $0xc,%esp
  1036cb:	53                   	push   %ebx
  1036cc:	e8 0f fe ff ff       	call   1034e0 <container_get_parent>
  1036d1:	83 c4 10             	add    $0x10,%esp
  1036d4:	85 c0                	test   %eax,%eax
  1036d6:	75 d2                	jne    1036aa <MContainer_test2+0x3a>
      container_get_usage(chid) != 0 || container_get_nchildren(chid) != 0 ||
  1036d8:	83 ec 0c             	sub    $0xc,%esp
  1036db:	53                   	push   %ebx
  1036dc:	e8 2f fe ff ff       	call   103510 <container_get_usage>
int MContainer_test2()
{
  unsigned int old_usage = container_get_usage(0);
  unsigned int old_nchildren = container_get_nchildren(0);
  unsigned int chid = container_split(0, 100);
  if (container_get_quota(chid) != 100 || container_get_parent(chid) != 0 ||
  1036e1:	83 c4 10             	add    $0x10,%esp
  1036e4:	85 c0                	test   %eax,%eax
  1036e6:	75 c2                	jne    1036aa <MContainer_test2+0x3a>
      container_get_usage(chid) != 0 || container_get_nchildren(chid) != 0 ||
  1036e8:	83 ec 0c             	sub    $0xc,%esp
  1036eb:	53                   	push   %ebx
  1036ec:	e8 ff fd ff ff       	call   1034f0 <container_get_nchildren>
  1036f1:	83 c4 10             	add    $0x10,%esp
  1036f4:	85 c0                	test   %eax,%eax
  1036f6:	75 b2                	jne    1036aa <MContainer_test2+0x3a>
      container_get_usage(0) != old_usage + 100 || container_get_nchildren(0) != old_nchildren + 1) {
  1036f8:	83 ec 0c             	sub    $0xc,%esp
{
  unsigned int old_usage = container_get_usage(0);
  unsigned int old_nchildren = container_get_nchildren(0);
  unsigned int chid = container_split(0, 100);
  if (container_get_quota(chid) != 100 || container_get_parent(chid) != 0 ||
      container_get_usage(chid) != 0 || container_get_nchildren(chid) != 0 ||
  1036fb:	83 c6 64             	add    $0x64,%esi
      container_get_usage(0) != old_usage + 100 || container_get_nchildren(0) != old_nchildren + 1) {
  1036fe:	6a 00                	push   $0x0
  103700:	e8 0b fe ff ff       	call   103510 <container_get_usage>
{
  unsigned int old_usage = container_get_usage(0);
  unsigned int old_nchildren = container_get_nchildren(0);
  unsigned int chid = container_split(0, 100);
  if (container_get_quota(chid) != 100 || container_get_parent(chid) != 0 ||
      container_get_usage(chid) != 0 || container_get_nchildren(chid) != 0 ||
  103705:	83 c4 10             	add    $0x10,%esp
  103708:	39 f0                	cmp    %esi,%eax
  10370a:	75 9e                	jne    1036aa <MContainer_test2+0x3a>
      container_get_usage(0) != old_usage + 100 || container_get_nchildren(0) != old_nchildren + 1) {
  10370c:	83 ec 0c             	sub    $0xc,%esp
  10370f:	83 c7 01             	add    $0x1,%edi
  103712:	6a 00                	push   $0x0
  103714:	e8 d7 fd ff ff       	call   1034f0 <container_get_nchildren>
  103719:	83 c4 10             	add    $0x10,%esp
  10371c:	39 f8                	cmp    %edi,%eax
  10371e:	75 8a                	jne    1036aa <MContainer_test2+0x3a>
    dprintf("test 2 failed.\n");
    return 1;
  }
  container_alloc(chid);
  103720:	83 ec 0c             	sub    $0xc,%esp
  103723:	53                   	push   %ebx
  103724:	e8 77 fe ff ff       	call   1035a0 <container_alloc>
  if (container_get_usage(chid) != 1) {
  103729:	89 1c 24             	mov    %ebx,(%esp)
  10372c:	e8 df fd ff ff       	call   103510 <container_get_usage>
  103731:	83 c4 10             	add    $0x10,%esp
  103734:	83 e8 01             	sub    $0x1,%eax
  103737:	0f 85 6d ff ff ff    	jne    1036aa <MContainer_test2+0x3a>
    dprintf("test 2 failed.\n");
    return 1;
  }
  dprintf("test 2 passed.\n");
  10373d:	83 ec 0c             	sub    $0xc,%esp
  103740:	68 bd 63 10 00       	push   $0x1063bd
  103745:	e8 c1 e6 ff ff       	call   101e0b <dprintf>
  return 0;
  10374a:	83 c4 10             	add    $0x10,%esp
  10374d:	31 c0                	xor    %eax,%eax
  10374f:	e9 6b ff ff ff       	jmp    1036bf <MContainer_test2+0x4f>
  103754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10375a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103760 <MContainer_test_own>:
int MContainer_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  103760:	31 c0                	xor    %eax,%eax
  103762:	c3                   	ret    
  103763:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103770 <test_MContainer>:

int test_MContainer()
{
  103770:	53                   	push   %ebx
  103771:	83 ec 08             	sub    $0x8,%esp
  return MContainer_test1() + MContainer_test2() + MContainer_test_own();
  103774:	e8 77 fe ff ff       	call   1035f0 <MContainer_test1>
  103779:	89 c3                	mov    %eax,%ebx
  10377b:	e8 f0 fe ff ff       	call   103670 <MContainer_test2>
}
  103780:	83 c4 08             	add    $0x8,%esp
  return 0;
}

int test_MContainer()
{
  return MContainer_test1() + MContainer_test2() + MContainer_test_own();
  103783:	01 d8                	add    %ebx,%eax
}
  103785:	5b                   	pop    %ebx
  103786:	c3                   	ret    
  103787:	66 90                	xchg   %ax,%ax
  103789:	66 90                	xchg   %ax,%ax
  10378b:	66 90                	xchg   %ax,%ax
  10378d:	66 90                	xchg   %ax,%ax
  10378f:	90                   	nop

00103790 <set_pdir_base>:
  * * Set the CR3 register with the start address of the page structure for process # [index]
  */
void set_pdir_base(unsigned int index)
{
    // TODO
    set_cr3((char **) ((unsigned int) PDirPool[index]));
  103790:	8b 44 24 04          	mov    0x4(%esp),%eax
  103794:	c1 e0 0c             	shl    $0xc,%eax
  103797:	05 00 c0 da 01       	add    $0x1dac000,%eax
  10379c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037a0:	e9 e0 e2 ff ff       	jmp    101a85 <set_cr3>
  1037a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1037a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001037b0 <get_pdir_entry>:
  */
unsigned int get_pdir_entry(unsigned int proc_index, unsigned int pde_index)
{
    // TODO
    unsigned char *pdir_entry;
    pdir_entry = (char *) ((unsigned int) PDirPool[proc_index][pde_index]);
  1037b0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1037b4:	c1 e0 0a             	shl    $0xa,%eax
  1037b7:	03 44 24 08          	add    0x8(%esp),%eax
    return (unsigned int) pdir_entry;
  1037bb:	8b 04 85 00 c0 da 01 	mov    0x1dac000(,%eax,4),%eax
}
  1037c2:	c3                   	ret    
  1037c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001037d0 <set_pdir_entry>:
  */
void set_pdir_entry(unsigned int proc_index, unsigned int pde_index, unsigned int page_index)
{
    // TODO
    unsigned int start = page_index * 4096;
    PDirPool[proc_index][pde_index] = (char *) (start | PT_PERM_PTU);
  1037d0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1037d4:	8b 54 24 0c          	mov    0xc(%esp),%edx
  1037d8:	c1 e0 0a             	shl    $0xa,%eax
  1037db:	03 44 24 08          	add    0x8(%esp),%eax
  1037df:	c1 e2 0c             	shl    $0xc,%edx
  1037e2:	83 ca 07             	or     $0x7,%edx
  1037e5:	89 14 85 00 c0 da 01 	mov    %edx,0x1dac000(,%eax,4)
  1037ec:	c3                   	ret    
  1037ed:	8d 76 00             	lea    0x0(%esi),%esi

001037f0 <set_pdir_entry_identity>:
  * Hint 1: Cast the first entry of IDPTbl[pde_index] to char *.
  */
void set_pdir_entry_identity(unsigned int proc_index, unsigned int pde_index)
{
    // TODO
    PDirPool[proc_index][pde_index] = (char *) ((unsigned int) IDPTbl[pde_index] | PT_PERM_PTU);
  1037f0:	8b 54 24 04          	mov    0x4(%esp),%edx
  * - You should also set the permissions PTE_P, PTE_W, and PTE_U
  * - This will be used to map the page directory entry to identity page table.
  * Hint 1: Cast the first entry of IDPTbl[pde_index] to char *.
  */
void set_pdir_entry_identity(unsigned int proc_index, unsigned int pde_index)
{
  1037f4:	8b 44 24 08          	mov    0x8(%esp),%eax
    // TODO
    PDirPool[proc_index][pde_index] = (char *) ((unsigned int) IDPTbl[pde_index] | PT_PERM_PTU);
  1037f8:	c1 e2 0a             	shl    $0xa,%edx
  1037fb:	01 c2                	add    %eax,%edx
  1037fd:	c1 e0 0c             	shl    $0xc,%eax
  103800:	05 00 c0 9a 01       	add    $0x19ac000,%eax
  103805:	83 c8 07             	or     $0x7,%eax
  103808:	89 04 95 00 c0 da 01 	mov    %eax,0x1dac000(,%edx,4)
  10380f:	c3                   	ret    

00103810 <rmv_pdir_entry>:
  * Hint 2: Don't forget to cast the value to (char *).
  */
void rmv_pdir_entry(unsigned int proc_index, unsigned int pde_index)
{
    // TODO
    PDirPool[proc_index][pde_index] = (char *) PT_PERM_UP;
  103810:	8b 44 24 04          	mov    0x4(%esp),%eax
  103814:	c1 e0 0a             	shl    $0xa,%eax
  103817:	03 44 24 08          	add    0x8(%esp),%eax
  10381b:	c7 04 85 00 c0 da 01 	movl   $0x0,0x1dac000(,%eax,4)
  103822:	00 00 00 00 
  103826:	c3                   	ret    
  103827:	89 f6                	mov    %esi,%esi
  103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103830 <get_ptbl_entry>:
unsigned int get_ptbl_entry(unsigned int proc_index, unsigned int pde_index, unsigned int pte_index)
{
    // TODO
    unsigned int offset = pte_index * 4;
    unsigned int *p;
    p = (unsigned int *) ((((unsigned int) PDirPool[proc_index][pde_index] & PERM_MASK)) + offset);
  103830:	8b 44 24 04          	mov    0x4(%esp),%eax
    return *p;
  103834:	8b 54 24 0c          	mov    0xc(%esp),%edx
unsigned int get_ptbl_entry(unsigned int proc_index, unsigned int pde_index, unsigned int pte_index)
{
    // TODO
    unsigned int offset = pte_index * 4;
    unsigned int *p;
    p = (unsigned int *) ((((unsigned int) PDirPool[proc_index][pde_index] & PERM_MASK)) + offset);
  103838:	c1 e0 0a             	shl    $0xa,%eax
  10383b:	03 44 24 08          	add    0x8(%esp),%eax
    return *p;
  10383f:	8b 04 85 00 c0 da 01 	mov    0x1dac000(,%eax,4),%eax
  103846:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10384b:	8b 04 90             	mov    (%eax,%edx,4),%eax

}
  10384e:	c3                   	ret    
  10384f:	90                   	nop

00103850 <set_ptbl_entry>:
{
    // TODO
    unsigned int offset = pte_index * 4;
    unsigned int start = page_index * 4096;
    unsigned int *p;
    p = (unsigned int *) (((unsigned int) PDirPool[proc_index][pde_index] & PERM_MASK) + offset);
  103850:	8b 44 24 04          	mov    0x4(%esp),%eax

    *p = start | perm;
  103854:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
{
    // TODO
    unsigned int offset = pte_index * 4;
    unsigned int start = page_index * 4096;
    unsigned int *p;
    p = (unsigned int *) (((unsigned int) PDirPool[proc_index][pde_index] & PERM_MASK) + offset);
  103858:	c1 e0 0a             	shl    $0xa,%eax
  10385b:	03 44 24 08          	add    0x8(%esp),%eax

    *p = start | perm;
  10385f:	8b 14 85 00 c0 da 01 	mov    0x1dac000(,%eax,4),%edx
  103866:	8b 44 24 10          	mov    0x10(%esp),%eax
  10386a:	c1 e0 0c             	shl    $0xc,%eax
  10386d:	0b 44 24 14          	or     0x14(%esp),%eax
  103871:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  103877:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
  10387a:	c3                   	ret    
  10387b:	90                   	nop
  10387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103880 <set_ptbl_entry_identity>:
  * |---------|--------------|
  */
void set_ptbl_entry_identity(unsigned int pde_index, unsigned int pte_index, unsigned int perm)
{
    // TODO
    IDPTbl[pde_index][pte_index] = (pde_index * 1024 + pte_index) * 4096 | perm;
  103880:	8b 44 24 04          	mov    0x4(%esp),%eax
  103884:	c1 e0 0a             	shl    $0xa,%eax
  103887:	03 44 24 08          	add    0x8(%esp),%eax
  10388b:	89 c2                	mov    %eax,%edx
  10388d:	c1 e2 0c             	shl    $0xc,%edx
  103890:	0b 54 24 0c          	or     0xc(%esp),%edx
  103894:	89 14 85 00 c0 9a 01 	mov    %edx,0x19ac000(,%eax,4)
  10389b:	c3                   	ret    
  10389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001038a0 <rmv_ptbl_entry>:
void rmv_ptbl_entry(unsigned int proc_index, unsigned int pde_index, unsigned int pte_index)
{
    // TODO
    unsigned int *p;
    unsigned int offset = pte_index * 4;
    p = (unsigned int *) (((unsigned int) PDirPool[proc_index][pde_index] & PERM_MASK) + offset);
  1038a0:	8b 44 24 04          	mov    0x4(%esp),%eax
    *p = 0;
  1038a4:	8b 54 24 0c          	mov    0xc(%esp),%edx
void rmv_ptbl_entry(unsigned int proc_index, unsigned int pde_index, unsigned int pte_index)
{
    // TODO
    unsigned int *p;
    unsigned int offset = pte_index * 4;
    p = (unsigned int *) (((unsigned int) PDirPool[proc_index][pde_index] & PERM_MASK) + offset);
  1038a8:	c1 e0 0a             	shl    $0xa,%eax
  1038ab:	03 44 24 08          	add    0x8(%esp),%eax
    *p = 0;
  1038af:	8b 04 85 00 c0 da 01 	mov    0x1dac000(,%eax,4),%eax
  1038b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1038bb:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
  1038c2:	c3                   	ret    
  1038c3:	66 90                	xchg   %ax,%ax
  1038c5:	66 90                	xchg   %ax,%ax
  1038c7:	66 90                	xchg   %ax,%ax
  1038c9:	66 90                	xchg   %ax,%ax
  1038cb:	66 90                	xchg   %ax,%ax
  1038cd:	66 90                	xchg   %ax,%ax
  1038cf:	90                   	nop

001038d0 <MPTIntro_test1>:

extern char * PDirPool[NUM_IDS][1024];
extern unsigned int IDPTbl[1024][1024];

int MPTIntro_test1()
{
  1038d0:	83 ec 18             	sub    $0x18,%esp
  set_pdir_base(0);
  1038d3:	6a 00                	push   $0x0
  1038d5:	e8 b6 fe ff ff       	call   103790 <set_pdir_base>
  if ((unsigned int)PDirPool[0] != rcr3()) {
  1038da:	e8 18 ed ff ff       	call   1025f7 <rcr3>
  1038df:	83 c4 10             	add    $0x10,%esp
  1038e2:	3d 00 c0 da 01       	cmp    $0x1dac000,%eax
  1038e7:	74 1f                	je     103908 <MPTIntro_test1+0x38>
    dprintf("test 1 failed.\n");
  1038e9:	83 ec 0c             	sub    $0xc,%esp
  1038ec:	68 f1 62 10 00       	push   $0x1062f1
  1038f1:	e8 15 e5 ff ff       	call   101e0b <dprintf>
    return 1;
  1038f6:	83 c4 10             	add    $0x10,%esp
  1038f9:	b8 01 00 00 00       	mov    $0x1,%eax
      dprintf("test 1 failed3.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  1038fe:	83 c4 0c             	add    $0xc,%esp
  103901:	c3                   	ret    
  103902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  set_pdir_base(0);
  if ((unsigned int)PDirPool[0] != rcr3()) {
    dprintf("test 1 failed.\n");
    return 1;
  }
  set_pdir_entry_identity(1, 1);
  103908:	83 ec 08             	sub    $0x8,%esp
  10390b:	6a 01                	push   $0x1
  10390d:	6a 01                	push   $0x1
  10390f:	e8 dc fe ff ff       	call   1037f0 <set_pdir_entry_identity>
  set_pdir_entry(1, 2, 100);
  103914:	83 c4 0c             	add    $0xc,%esp
  103917:	6a 64                	push   $0x64
  103919:	6a 02                	push   $0x2
  10391b:	6a 01                	push   $0x1
  10391d:	e8 ae fe ff ff       	call   1037d0 <set_pdir_entry>
  if (get_pdir_entry(1, 1) != (unsigned int)IDPTbl[1] +   7) {
  103922:	58                   	pop    %eax
  103923:	5a                   	pop    %edx
  103924:	6a 01                	push   $0x1
  103926:	6a 01                	push   $0x1
  103928:	e8 83 fe ff ff       	call   1037b0 <get_pdir_entry>
  10392d:	83 c4 10             	add    $0x10,%esp
  103930:	3d 07 d0 9a 01       	cmp    $0x19ad007,%eax
  103935:	74 19                	je     103950 <MPTIntro_test1+0x80>
      dprintf("test 1 failed1.\n");
  103937:	83 ec 0c             	sub    $0xc,%esp
  10393a:	68 cd 63 10 00       	push   $0x1063cd
  10393f:	e8 c7 e4 ff ff       	call   101e0b <dprintf>
    return 1;
  103944:	83 c4 10             	add    $0x10,%esp
  103947:	b8 01 00 00 00       	mov    $0x1,%eax
      dprintf("test 1 failed3.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  10394c:	83 c4 0c             	add    $0xc,%esp
  10394f:	c3                   	ret    
  set_pdir_entry(1, 2, 100);
  if (get_pdir_entry(1, 1) != (unsigned int)IDPTbl[1] +   7) {
      dprintf("test 1 failed1.\n");
    return 1;
  }
  if (get_pdir_entry(1, 2) != 409607) {
  103950:	83 ec 08             	sub    $0x8,%esp
  103953:	6a 02                	push   $0x2
  103955:	6a 01                	push   $0x1
  103957:	e8 54 fe ff ff       	call   1037b0 <get_pdir_entry>
  10395c:	83 c4 10             	add    $0x10,%esp
  10395f:	3d 07 40 06 00       	cmp    $0x64007,%eax
  103964:	74 1a                	je     103980 <MPTIntro_test1+0xb0>
      dprintf("test 1 failed2.\n");
  103966:	83 ec 0c             	sub    $0xc,%esp
  103969:	68 de 63 10 00       	push   $0x1063de
  10396e:	e8 98 e4 ff ff       	call   101e0b <dprintf>
    return 1;
  103973:	83 c4 10             	add    $0x10,%esp
  103976:	b8 01 00 00 00       	mov    $0x1,%eax
  10397b:	eb 81                	jmp    1038fe <MPTIntro_test1+0x2e>
  10397d:	8d 76 00             	lea    0x0(%esi),%esi
  }
  rmv_pdir_entry(1, 1);
  103980:	83 ec 08             	sub    $0x8,%esp
  103983:	6a 01                	push   $0x1
  103985:	6a 01                	push   $0x1
  103987:	e8 84 fe ff ff       	call   103810 <rmv_pdir_entry>
  rmv_pdir_entry(1, 2);
  10398c:	58                   	pop    %eax
  10398d:	5a                   	pop    %edx
  10398e:	6a 02                	push   $0x2
  103990:	6a 01                	push   $0x1
  103992:	e8 79 fe ff ff       	call   103810 <rmv_pdir_entry>
  if (get_pdir_entry(1, 1) != 0 || get_pdir_entry(1, 2) != 0) {
  103997:	59                   	pop    %ecx
  103998:	58                   	pop    %eax
  103999:	6a 01                	push   $0x1
  10399b:	6a 01                	push   $0x1
  10399d:	e8 0e fe ff ff       	call   1037b0 <get_pdir_entry>
  1039a2:	83 c4 10             	add    $0x10,%esp
  1039a5:	85 c0                	test   %eax,%eax
  1039a7:	75 13                	jne    1039bc <MPTIntro_test1+0xec>
  1039a9:	83 ec 08             	sub    $0x8,%esp
  1039ac:	6a 02                	push   $0x2
  1039ae:	6a 01                	push   $0x1
  1039b0:	e8 fb fd ff ff       	call   1037b0 <get_pdir_entry>
  1039b5:	83 c4 10             	add    $0x10,%esp
  1039b8:	85 c0                	test   %eax,%eax
  1039ba:	74 24                	je     1039e0 <MPTIntro_test1+0x110>
      dprintf("test 1 failed3.\n");
  1039bc:	83 ec 0c             	sub    $0xc,%esp
  1039bf:	68 ef 63 10 00       	push   $0x1063ef
  1039c4:	e8 42 e4 ff ff       	call   101e0b <dprintf>
  1039c9:	83 c4 10             	add    $0x10,%esp
    return 1;
  1039cc:	b8 01 00 00 00       	mov    $0x1,%eax
  1039d1:	e9 28 ff ff ff       	jmp    1038fe <MPTIntro_test1+0x2e>
  1039d6:	8d 76 00             	lea    0x0(%esi),%esi
  1039d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
  dprintf("test 1 passed.\n");
  1039e0:	83 ec 0c             	sub    $0xc,%esp
  1039e3:	68 01 63 10 00       	push   $0x106301
  1039e8:	e8 1e e4 ff ff       	call   101e0b <dprintf>
  1039ed:	83 c4 10             	add    $0x10,%esp
  return 0;
  1039f0:	31 c0                	xor    %eax,%eax
  1039f2:	e9 07 ff ff ff       	jmp    1038fe <MPTIntro_test1+0x2e>
  1039f7:	89 f6                	mov    %esi,%esi
  1039f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103a00 <MPTIntro_test2>:
}

int MPTIntro_test2()
{
  103a00:	83 ec 10             	sub    $0x10,%esp
  set_pdir_entry(1, 1, 10000);
  103a03:	68 10 27 00 00       	push   $0x2710
  103a08:	6a 01                	push   $0x1
  103a0a:	6a 01                	push   $0x1
  103a0c:	e8 bf fd ff ff       	call   1037d0 <set_pdir_entry>
  set_ptbl_entry(1, 1, 1, 10000, 259);
  103a11:	c7 04 24 03 01 00 00 	movl   $0x103,(%esp)
  103a18:	68 10 27 00 00       	push   $0x2710
  103a1d:	6a 01                	push   $0x1
  103a1f:	6a 01                	push   $0x1
  103a21:	6a 01                	push   $0x1
  103a23:	e8 28 fe ff ff       	call   103850 <set_ptbl_entry>
  if (get_ptbl_entry(1, 1, 1) != 40960259) {
  103a28:	83 c4 1c             	add    $0x1c,%esp
  103a2b:	6a 01                	push   $0x1
  103a2d:	6a 01                	push   $0x1
  103a2f:	6a 01                	push   $0x1
  103a31:	e8 fa fd ff ff       	call   103830 <get_ptbl_entry>
  103a36:	83 c4 10             	add    $0x10,%esp
  103a39:	3d 03 01 71 02       	cmp    $0x2710103,%eax
  103a3e:	74 20                	je     103a60 <MPTIntro_test2+0x60>
    dprintf("test 2 failed.\n");
  103a40:	83 ec 0c             	sub    $0xc,%esp
  103a43:	68 ad 63 10 00       	push   $0x1063ad
  103a48:	e8 be e3 ff ff       	call   101e0b <dprintf>
    return 1;
  103a4d:	83 c4 10             	add    $0x10,%esp
  103a50:	b8 01 00 00 00       	mov    $0x1,%eax
    return 1;
  }
  rmv_pdir_entry(1, 1);
  dprintf("test 2 passed.\n");
  return 0;
}
  103a55:	83 c4 0c             	add    $0xc,%esp
  103a58:	c3                   	ret    
  103a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  set_ptbl_entry(1, 1, 1, 10000, 259);
  if (get_ptbl_entry(1, 1, 1) != 40960259) {
    dprintf("test 2 failed.\n");
    return 1;
  }
  rmv_ptbl_entry(1, 1, 1);
  103a60:	83 ec 04             	sub    $0x4,%esp
  103a63:	6a 01                	push   $0x1
  103a65:	6a 01                	push   $0x1
  103a67:	6a 01                	push   $0x1
  103a69:	e8 32 fe ff ff       	call   1038a0 <rmv_ptbl_entry>
  if (get_ptbl_entry(1, 1, 1) != 0) {
  103a6e:	83 c4 0c             	add    $0xc,%esp
  103a71:	6a 01                	push   $0x1
  103a73:	6a 01                	push   $0x1
  103a75:	6a 01                	push   $0x1
  103a77:	e8 b4 fd ff ff       	call   103830 <get_ptbl_entry>
  103a7c:	83 c4 10             	add    $0x10,%esp
  103a7f:	85 c0                	test   %eax,%eax
  103a81:	75 bd                	jne    103a40 <MPTIntro_test2+0x40>
    dprintf("test 2 failed.\n");
    return 1;
  }
  rmv_pdir_entry(1, 1);
  103a83:	83 ec 08             	sub    $0x8,%esp
  103a86:	6a 01                	push   $0x1
  103a88:	6a 01                	push   $0x1
  103a8a:	e8 81 fd ff ff       	call   103810 <rmv_pdir_entry>
  dprintf("test 2 passed.\n");
  103a8f:	c7 04 24 bd 63 10 00 	movl   $0x1063bd,(%esp)
  103a96:	e8 70 e3 ff ff       	call   101e0b <dprintf>
  103a9b:	83 c4 10             	add    $0x10,%esp
  103a9e:	31 c0                	xor    %eax,%eax
  return 0;
}
  103aa0:	83 c4 0c             	add    $0xc,%esp
  103aa3:	c3                   	ret    
  103aa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103aaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103ab0 <MPTIntro_test_own>:
int MPTIntro_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  103ab0:	31 c0                	xor    %eax,%eax
  103ab2:	c3                   	ret    
  103ab3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103ac0 <test_MPTIntro>:

int test_MPTIntro()
{
  103ac0:	53                   	push   %ebx
  103ac1:	83 ec 08             	sub    $0x8,%esp
  return MPTIntro_test1() + MPTIntro_test2() + MPTIntro_test_own();
  103ac4:	e8 07 fe ff ff       	call   1038d0 <MPTIntro_test1>
  103ac9:	89 c3                	mov    %eax,%ebx
  103acb:	e8 30 ff ff ff       	call   103a00 <MPTIntro_test2>
}
  103ad0:	83 c4 08             	add    $0x8,%esp
  return 0;
}

int test_MPTIntro()
{
  return MPTIntro_test1() + MPTIntro_test2() + MPTIntro_test_own();
  103ad3:	01 d8                	add    %ebx,%eax
}
  103ad5:	5b                   	pop    %ebx
  103ad6:	c3                   	ret    
  103ad7:	66 90                	xchg   %ax,%ax
  103ad9:	66 90                	xchg   %ax,%ax
  103adb:	66 90                	xchg   %ax,%ax
  103add:	66 90                	xchg   %ax,%ax
  103adf:	90                   	nop

00103ae0 <get_pdir_entry_by_va>:
unsigned int get_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
    // TODO
    unsigned int vaddr_dir = vaddr >> DIR_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    return (unsigned int) get_pdir_entry(proc_index, pdir);
  103ae0:	c1 6c 24 08 16       	shrl   $0x16,0x8(%esp)
  103ae5:	e9 c6 fc ff ff       	jmp    1037b0 <get_pdir_entry>
  103aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103af0 <get_ptbl_entry_by_va>:
  * - Return 0 if the mapping does not exist in page directory entry (i.e. pde = 0).
  *
  * Hint 1: Same as TASK 1.
  */
unsigned int get_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  103af0:	55                   	push   %ebp
  103af1:	57                   	push   %edi
  103af2:	56                   	push   %esi
  103af3:	53                   	push   %ebx
  103af4:	83 ec 14             	sub    $0x14,%esp
  103af7:	8b 44 24 2c          	mov    0x2c(%esp),%eax
  103afb:	8b 74 24 28          	mov    0x28(%esp),%esi
    // TODO
    unsigned int vaddr_dir = vaddr >> DIR_SHIFT;
  103aff:	89 c7                	mov    %eax,%edi
    unsigned int vaddr_table = vaddr >> PAGE_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int ptbl = vaddr_table & (PAGE_MASK >> PAGE_SHIFT);
  103b01:	c1 e8 0c             	shr    $0xc,%eax
  * Hint 1: Same as TASK 1.
  */
unsigned int get_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
    // TODO
    unsigned int vaddr_dir = vaddr >> DIR_SHIFT;
  103b04:	c1 ef 16             	shr    $0x16,%edi
    unsigned int vaddr_table = vaddr >> PAGE_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int ptbl = vaddr_table & (PAGE_MASK >> PAGE_SHIFT);
  103b07:	25 ff 03 00 00       	and    $0x3ff,%eax
    unsigned int pde = get_pdir_entry(proc_index, pdir);
  103b0c:	57                   	push   %edi
  103b0d:	56                   	push   %esi
{
    // TODO
    unsigned int vaddr_dir = vaddr >> DIR_SHIFT;
    unsigned int vaddr_table = vaddr >> PAGE_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int ptbl = vaddr_table & (PAGE_MASK >> PAGE_SHIFT);
  103b0e:	89 c3                	mov    %eax,%ebx
    unsigned int pde = get_pdir_entry(proc_index, pdir);
  103b10:	e8 9b fc ff ff       	call   1037b0 <get_pdir_entry>
    unsigned int pte = get_ptbl_entry(proc_index, pdir, ptbl);
  103b15:	83 c4 0c             	add    $0xc,%esp
    // TODO
    unsigned int vaddr_dir = vaddr >> DIR_SHIFT;
    unsigned int vaddr_table = vaddr >> PAGE_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int ptbl = vaddr_table & (PAGE_MASK >> PAGE_SHIFT);
    unsigned int pde = get_pdir_entry(proc_index, pdir);
  103b18:	89 c5                	mov    %eax,%ebp
    unsigned int pte = get_ptbl_entry(proc_index, pdir, ptbl);
  103b1a:	53                   	push   %ebx
  103b1b:	57                   	push   %edi
  103b1c:	56                   	push   %esi
  103b1d:	e8 0e fd ff ff       	call   103830 <get_ptbl_entry>

    if (pde != 0)
  103b22:	83 c4 10             	add    $0x10,%esp
  103b25:	31 c0                	xor    %eax,%eax
  103b27:	85 ed                	test   %ebp,%ebp
  103b29:	74 0e                	je     103b39 <get_ptbl_entry_by_va+0x49>
        return (unsigned int) get_ptbl_entry(proc_index, pdir, ptbl);
  103b2b:	83 ec 04             	sub    $0x4,%esp
  103b2e:	53                   	push   %ebx
  103b2f:	57                   	push   %edi
  103b30:	56                   	push   %esi
  103b31:	e8 fa fc ff ff       	call   103830 <get_ptbl_entry>
  103b36:	83 c4 10             	add    $0x10,%esp
    else
        return 0;
}
  103b39:	83 c4 0c             	add    $0xc,%esp
  103b3c:	5b                   	pop    %ebx
  103b3d:	5e                   	pop    %esi
  103b3e:	5f                   	pop    %edi
  103b3f:	5d                   	pop    %ebp
  103b40:	c3                   	ret    
  103b41:	eb 0d                	jmp    103b50 <rmv_pdir_entry_by_va>
  103b43:	90                   	nop
  103b44:	90                   	nop
  103b45:	90                   	nop
  103b46:	90                   	nop
  103b47:	90                   	nop
  103b48:	90                   	nop
  103b49:	90                   	nop
  103b4a:	90                   	nop
  103b4b:	90                   	nop
  103b4c:	90                   	nop
  103b4d:	90                   	nop
  103b4e:	90                   	nop
  103b4f:	90                   	nop

00103b50 <rmv_pdir_entry_by_va>:
void rmv_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
    // TODO
    unsigned int vaddr_dir = vaddr >> DIR_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    rmv_pdir_entry(proc_index, pdir);
  103b50:	c1 6c 24 08 16       	shrl   $0x16,0x8(%esp)
  103b55:	e9 b6 fc ff ff       	jmp    103810 <rmv_pdir_entry>
  103b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103b60 <rmv_ptbl_entry_by_va>:
/** TASK 4:
  * * Remove the page table entry for the given virtual address
  * Hint 1: Same as TASK 3. Use the correct function.
  */
void rmv_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr)
{
  103b60:	83 ec 10             	sub    $0x10,%esp
  103b63:	8b 44 24 18          	mov    0x18(%esp),%eax
    // TODO
    unsigned int vaddr_dir = vaddr >> DIR_SHIFT;
    unsigned int vaddr_table = vaddr >> PAGE_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int ptbl = vaddr_table & (PAGE_MASK >> PAGE_SHIFT);
    rmv_ptbl_entry(proc_index, pdir, ptbl);
  103b67:	89 c2                	mov    %eax,%edx
  103b69:	c1 e8 16             	shr    $0x16,%eax
  103b6c:	c1 ea 0c             	shr    $0xc,%edx
  103b6f:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  103b75:	52                   	push   %edx
  103b76:	50                   	push   %eax
  103b77:	ff 74 24 1c          	pushl  0x1c(%esp)
  103b7b:	e8 20 fd ff ff       	call   1038a0 <rmv_ptbl_entry>

}
  103b80:	83 c4 1c             	add    $0x1c,%esp
  103b83:	c3                   	ret    
  103b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103b90 <set_pdir_entry_by_va>:
void set_pdir_entry_by_va(unsigned int proc_index, unsigned int vaddr, unsigned int page_index)
{
    // TODO
    unsigned int vaddr_dir = vaddr >> DIR_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    set_pdir_entry(proc_index, pdir, page_index);
  103b90:	8b 44 24 08          	mov    0x8(%esp),%eax
  103b94:	c1 e8 16             	shr    $0x16,%eax
  103b97:	89 44 24 08          	mov    %eax,0x8(%esp)
  103b9b:	e9 30 fc ff ff       	jmp    1037d0 <set_pdir_entry>

00103ba0 <set_ptbl_entry_by_va>:
  * * Register the mapping from the virtual address [vaddr] to the physical page # [page_index] with permission [perm]
  * - You do not need to worry about the page directory entry. just map the page table entry.
  * Hint: Same as TASK 3. Use the correct function.
  */
void set_ptbl_entry_by_va(unsigned int proc_index, unsigned int vaddr, unsigned int page_index, unsigned int perm)
{
  103ba0:	83 ec 18             	sub    $0x18,%esp
  103ba3:	8b 44 24 20          	mov    0x20(%esp),%eax
    // TODO
    unsigned int vaddr_dir = vaddr >> DIR_SHIFT;
    unsigned int vaddr_table = vaddr >> PAGE_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int ptbl = vaddr_table & (PAGE_MASK >> PAGE_SHIFT);
    set_ptbl_entry(proc_index, pdir, ptbl, page_index, perm);
  103ba7:	ff 74 24 28          	pushl  0x28(%esp)
  103bab:	ff 74 24 28          	pushl  0x28(%esp)
  103baf:	89 c2                	mov    %eax,%edx
  103bb1:	c1 e8 16             	shr    $0x16,%eax
  103bb4:	c1 ea 0c             	shr    $0xc,%edx
  103bb7:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  103bbd:	52                   	push   %edx
  103bbe:	50                   	push   %eax
  103bbf:	ff 74 24 2c          	pushl  0x2c(%esp)
  103bc3:	e8 88 fc ff ff       	call   103850 <set_ptbl_entry>

}
  103bc8:	83 c4 2c             	add    $0x2c,%esp
  103bcb:	c3                   	ret    
  103bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103bd0 <idptbl_init>:
  * Hint 2: You have already created the functions that deal with IDPTbl.
  *         Calculate the appropriate permission values as mentioned above
  *         and call set_ptbl_entry_identity from MATIntro layer.
  */
void idptbl_init(void)
{
  103bd0:	57                   	push   %edi
  103bd1:	56                   	push   %esi
    unsigned int VM_USERLO_PI = VM_USERLO / PAGE_SIZE;
    unsigned int VM_USERHI_PI = VM_USERHI / PAGE_SIZE;
    unsigned int VM_USERLO_PDE = VM_USERLO_PI / 1024;
    unsigned int VM_USERHI_PDE = VM_USERHI_PI / 1024;
    int i = 0, j = 0;
    for (i = 0; i < 1024; i++) {
  103bd2:	31 f6                	xor    %esi,%esi
  * Hint 2: You have already created the functions that deal with IDPTbl.
  *         Calculate the appropriate permission values as mentioned above
  *         and call set_ptbl_entry_identity from MATIntro layer.
  */
void idptbl_init(void)
{
  103bd4:	53                   	push   %ebx
  103bd5:	8d 76 00             	lea    0x0(%esi),%esi
  103bd8:	31 db                	xor    %ebx,%ebx
  103bda:	8d be 00 ff ff ff    	lea    -0x100(%esi),%edi
  103be0:	eb 23                	jmp    103c05 <idptbl_init+0x35>
  103be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    unsigned int VM_USERHI_PDE = VM_USERHI_PI / 1024;
    int i = 0, j = 0;
    for (i = 0; i < 1024; i++) {
        for (j = 0; j < 1024; j++) {
            if (i < VM_USERLO_PDE || i >= VM_USERHI_PDE) {
                set_ptbl_entry_identity(i, j, P_KERNEL);
  103be8:	83 ec 04             	sub    $0x4,%esp
  103beb:	68 03 01 00 00       	push   $0x103
  103bf0:	53                   	push   %ebx
    unsigned int VM_USERHI_PI = VM_USERHI / PAGE_SIZE;
    unsigned int VM_USERLO_PDE = VM_USERLO_PI / 1024;
    unsigned int VM_USERHI_PDE = VM_USERHI_PI / 1024;
    int i = 0, j = 0;
    for (i = 0; i < 1024; i++) {
        for (j = 0; j < 1024; j++) {
  103bf1:	83 c3 01             	add    $0x1,%ebx
            if (i < VM_USERLO_PDE || i >= VM_USERHI_PDE) {
                set_ptbl_entry_identity(i, j, P_KERNEL);
  103bf4:	56                   	push   %esi
  103bf5:	e8 86 fc ff ff       	call   103880 <set_ptbl_entry_identity>
  103bfa:	83 c4 10             	add    $0x10,%esp
    unsigned int VM_USERHI_PI = VM_USERHI / PAGE_SIZE;
    unsigned int VM_USERLO_PDE = VM_USERLO_PI / 1024;
    unsigned int VM_USERHI_PDE = VM_USERHI_PI / 1024;
    int i = 0, j = 0;
    for (i = 0; i < 1024; i++) {
        for (j = 0; j < 1024; j++) {
  103bfd:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  103c03:	74 22                	je     103c27 <idptbl_init+0x57>
            if (i < VM_USERLO_PDE || i >= VM_USERHI_PDE) {
  103c05:	81 ff bf 02 00 00    	cmp    $0x2bf,%edi
  103c0b:	77 db                	ja     103be8 <idptbl_init+0x18>
                set_ptbl_entry_identity(i, j, P_KERNEL);
            } else {
                set_ptbl_entry_identity(i, j, P_USER);
  103c0d:	83 ec 04             	sub    $0x4,%esp
  103c10:	6a 03                	push   $0x3
  103c12:	53                   	push   %ebx
    unsigned int VM_USERHI_PI = VM_USERHI / PAGE_SIZE;
    unsigned int VM_USERLO_PDE = VM_USERLO_PI / 1024;
    unsigned int VM_USERHI_PDE = VM_USERHI_PI / 1024;
    int i = 0, j = 0;
    for (i = 0; i < 1024; i++) {
        for (j = 0; j < 1024; j++) {
  103c13:	83 c3 01             	add    $0x1,%ebx
            if (i < VM_USERLO_PDE || i >= VM_USERHI_PDE) {
                set_ptbl_entry_identity(i, j, P_KERNEL);
            } else {
                set_ptbl_entry_identity(i, j, P_USER);
  103c16:	56                   	push   %esi
  103c17:	e8 64 fc ff ff       	call   103880 <set_ptbl_entry_identity>
  103c1c:	83 c4 10             	add    $0x10,%esp
    unsigned int VM_USERHI_PI = VM_USERHI / PAGE_SIZE;
    unsigned int VM_USERLO_PDE = VM_USERLO_PI / 1024;
    unsigned int VM_USERHI_PDE = VM_USERHI_PI / 1024;
    int i = 0, j = 0;
    for (i = 0; i < 1024; i++) {
        for (j = 0; j < 1024; j++) {
  103c1f:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  103c25:	75 de                	jne    103c05 <idptbl_init+0x35>
    unsigned int VM_USERLO_PI = VM_USERLO / PAGE_SIZE;
    unsigned int VM_USERHI_PI = VM_USERHI / PAGE_SIZE;
    unsigned int VM_USERLO_PDE = VM_USERLO_PI / 1024;
    unsigned int VM_USERHI_PDE = VM_USERHI_PI / 1024;
    int i = 0, j = 0;
    for (i = 0; i < 1024; i++) {
  103c27:	83 c6 01             	add    $0x1,%esi
  103c2a:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  103c30:	75 a6                	jne    103bd8 <idptbl_init+0x8>
                set_ptbl_entry_identity(i, j, P_USER);
            }
        }
    }

}
  103c32:	5b                   	pop    %ebx
  103c33:	5e                   	pop    %esi
  103c34:	5f                   	pop    %edi
  103c35:	c3                   	ret    
  103c36:	66 90                	xchg   %ax,%ax
  103c38:	66 90                	xchg   %ax,%ax
  103c3a:	66 90                	xchg   %ax,%ax
  103c3c:	66 90                	xchg   %ax,%ax
  103c3e:	66 90                	xchg   %ax,%ax

00103c40 <MPTOp_test1>:
#include <lib/debug.h>
#include "export.h"

int MPTOp_test1()
{
  103c40:	83 ec 14             	sub    $0x14,%esp
  unsigned int vaddr = 4096*1024*300;
  if (get_ptbl_entry_by_va(10, vaddr) != 0) {
  103c43:	68 00 00 00 4b       	push   $0x4b000000
  103c48:	6a 0a                	push   $0xa
  103c4a:	e8 a1 fe ff ff       	call   103af0 <get_ptbl_entry_by_va>
  103c4f:	83 c4 10             	add    $0x10,%esp
  103c52:	85 c0                	test   %eax,%eax
  103c54:	0f 85 f6 00 00 00    	jne    103d50 <MPTOp_test1+0x110>
    dprintf("test 1 failed1.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(10, vaddr) != 0) {
  103c5a:	83 ec 08             	sub    $0x8,%esp
  103c5d:	68 00 00 00 4b       	push   $0x4b000000
  103c62:	6a 0a                	push   $0xa
  103c64:	e8 77 fe ff ff       	call   103ae0 <get_pdir_entry_by_va>
  103c69:	83 c4 10             	add    $0x10,%esp
  103c6c:	85 c0                	test   %eax,%eax
  103c6e:	0f 85 bc 00 00 00    	jne    103d30 <MPTOp_test1+0xf0>
    dprintf("test 1 failed2.\n");
    return 1;
  }
  set_pdir_entry_by_va(10, vaddr, 100);
  103c74:	83 ec 04             	sub    $0x4,%esp
  103c77:	6a 64                	push   $0x64
  103c79:	68 00 00 00 4b       	push   $0x4b000000
  103c7e:	6a 0a                	push   $0xa
  103c80:	e8 0b ff ff ff       	call   103b90 <set_pdir_entry_by_va>
  set_ptbl_entry_by_va(10, vaddr, 100, 259);
  103c85:	68 03 01 00 00       	push   $0x103
  103c8a:	6a 64                	push   $0x64
  103c8c:	68 00 00 00 4b       	push   $0x4b000000
  103c91:	6a 0a                	push   $0xa
  103c93:	e8 08 ff ff ff       	call   103ba0 <set_ptbl_entry_by_va>
  if (get_ptbl_entry_by_va(10, vaddr) == 0) {
  103c98:	83 c4 18             	add    $0x18,%esp
  103c9b:	68 00 00 00 4b       	push   $0x4b000000
  103ca0:	6a 0a                	push   $0xa
  103ca2:	e8 49 fe ff ff       	call   103af0 <get_ptbl_entry_by_va>
  103ca7:	83 c4 10             	add    $0x10,%esp
  103caa:	85 c0                	test   %eax,%eax
  103cac:	0f 84 de 00 00 00    	je     103d90 <MPTOp_test1+0x150>
    dprintf("test 1 failed3.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(10, vaddr) == 0) {
  103cb2:	83 ec 08             	sub    $0x8,%esp
  103cb5:	68 00 00 00 4b       	push   $0x4b000000
  103cba:	6a 0a                	push   $0xa
  103cbc:	e8 1f fe ff ff       	call   103ae0 <get_pdir_entry_by_va>
  103cc1:	83 c4 10             	add    $0x10,%esp
  103cc4:	85 c0                	test   %eax,%eax
  103cc6:	0f 84 a4 00 00 00    	je     103d70 <MPTOp_test1+0x130>
    dprintf("test 1 failed4.\n");
    return 1;
  }
  rmv_ptbl_entry_by_va(10, vaddr);
  103ccc:	83 ec 08             	sub    $0x8,%esp
  103ccf:	68 00 00 00 4b       	push   $0x4b000000
  103cd4:	6a 0a                	push   $0xa
  103cd6:	e8 85 fe ff ff       	call   103b60 <rmv_ptbl_entry_by_va>
  rmv_pdir_entry_by_va(10, vaddr);
  103cdb:	58                   	pop    %eax
  103cdc:	5a                   	pop    %edx
  103cdd:	68 00 00 00 4b       	push   $0x4b000000
  103ce2:	6a 0a                	push   $0xa
  103ce4:	e8 67 fe ff ff       	call   103b50 <rmv_pdir_entry_by_va>
  if (get_ptbl_entry_by_va(10, vaddr) != 0) {
  103ce9:	59                   	pop    %ecx
  103cea:	58                   	pop    %eax
  103ceb:	68 00 00 00 4b       	push   $0x4b000000
  103cf0:	6a 0a                	push   $0xa
  103cf2:	e8 f9 fd ff ff       	call   103af0 <get_ptbl_entry_by_va>
  103cf7:	83 c4 10             	add    $0x10,%esp
  103cfa:	85 c0                	test   %eax,%eax
  103cfc:	0f 85 ae 00 00 00    	jne    103db0 <MPTOp_test1+0x170>
    dprintf("test 1 failed5.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(10, vaddr) != 0) {
  103d02:	83 ec 08             	sub    $0x8,%esp
  103d05:	68 00 00 00 4b       	push   $0x4b000000
  103d0a:	6a 0a                	push   $0xa
  103d0c:	e8 cf fd ff ff       	call   103ae0 <get_pdir_entry_by_va>
  103d11:	83 c4 10             	add    $0x10,%esp
  103d14:	85 c0                	test   %eax,%eax
  103d16:	0f 85 b4 00 00 00    	jne    103dd0 <MPTOp_test1+0x190>
    dprintf("test 1 failed6.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  103d1c:	83 ec 0c             	sub    $0xc,%esp
  103d1f:	68 01 63 10 00       	push   $0x106301
  103d24:	e8 e2 e0 ff ff       	call   101e0b <dprintf>
  103d29:	83 c4 10             	add    $0x10,%esp
  return 0;
  103d2c:	31 c0                	xor    %eax,%eax
  103d2e:	eb 15                	jmp    103d45 <MPTOp_test1+0x105>
  if (get_ptbl_entry_by_va(10, vaddr) != 0) {
    dprintf("test 1 failed1.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(10, vaddr) != 0) {
    dprintf("test 1 failed2.\n");
  103d30:	83 ec 0c             	sub    $0xc,%esp
  103d33:	68 de 63 10 00       	push   $0x1063de
  103d38:	e8 ce e0 ff ff       	call   101e0b <dprintf>
    return 1;
  103d3d:	83 c4 10             	add    $0x10,%esp
  103d40:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed6.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  103d45:	83 c4 0c             	add    $0xc,%esp
  103d48:	c3                   	ret    
  103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int MPTOp_test1()
{
  unsigned int vaddr = 4096*1024*300;
  if (get_ptbl_entry_by_va(10, vaddr) != 0) {
    dprintf("test 1 failed1.\n");
  103d50:	83 ec 0c             	sub    $0xc,%esp
  103d53:	68 cd 63 10 00       	push   $0x1063cd
  103d58:	e8 ae e0 ff ff       	call   101e0b <dprintf>
    return 1;
  103d5d:	83 c4 10             	add    $0x10,%esp
  103d60:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed6.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  103d65:	83 c4 0c             	add    $0xc,%esp
  103d68:	c3                   	ret    
  103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (get_ptbl_entry_by_va(10, vaddr) == 0) {
    dprintf("test 1 failed3.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(10, vaddr) == 0) {
    dprintf("test 1 failed4.\n");
  103d70:	83 ec 0c             	sub    $0xc,%esp
  103d73:	68 00 64 10 00       	push   $0x106400
  103d78:	e8 8e e0 ff ff       	call   101e0b <dprintf>
  103d7d:	83 c4 10             	add    $0x10,%esp
    return 1;
  103d80:	b8 01 00 00 00       	mov    $0x1,%eax
  103d85:	eb be                	jmp    103d45 <MPTOp_test1+0x105>
  103d87:	89 f6                	mov    %esi,%esi
  103d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return 1;
  }
  set_pdir_entry_by_va(10, vaddr, 100);
  set_ptbl_entry_by_va(10, vaddr, 100, 259);
  if (get_ptbl_entry_by_va(10, vaddr) == 0) {
    dprintf("test 1 failed3.\n");
  103d90:	83 ec 0c             	sub    $0xc,%esp
  103d93:	68 ef 63 10 00       	push   $0x1063ef
  103d98:	e8 6e e0 ff ff       	call   101e0b <dprintf>
    return 1;
  103d9d:	83 c4 10             	add    $0x10,%esp
  103da0:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed6.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  103da5:	83 c4 0c             	add    $0xc,%esp
  103da8:	c3                   	ret    
  103da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 1;
  }
  rmv_ptbl_entry_by_va(10, vaddr);
  rmv_pdir_entry_by_va(10, vaddr);
  if (get_ptbl_entry_by_va(10, vaddr) != 0) {
    dprintf("test 1 failed5.\n");
  103db0:	83 ec 0c             	sub    $0xc,%esp
  103db3:	68 11 64 10 00       	push   $0x106411
  103db8:	e8 4e e0 ff ff       	call   101e0b <dprintf>
  103dbd:	83 c4 10             	add    $0x10,%esp
    return 1;
  103dc0:	b8 01 00 00 00       	mov    $0x1,%eax
  103dc5:	e9 7b ff ff ff       	jmp    103d45 <MPTOp_test1+0x105>
  103dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if (get_pdir_entry_by_va(10, vaddr) != 0) {
    dprintf("test 1 failed6.\n");
  103dd0:	83 ec 0c             	sub    $0xc,%esp
  103dd3:	68 22 64 10 00       	push   $0x106422
  103dd8:	e8 2e e0 ff ff       	call   101e0b <dprintf>
  103ddd:	83 c4 10             	add    $0x10,%esp
    return 1;
  103de0:	b8 01 00 00 00       	mov    $0x1,%eax
  103de5:	e9 5b ff ff ff       	jmp    103d45 <MPTOp_test1+0x105>
  103dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103df0 <MPTOp_test_own>:
int MPTOp_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  103df0:	31 c0                	xor    %eax,%eax
  103df2:	c3                   	ret    
  103df3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103e00 <test_MPTOp>:

int test_MPTOp()
{
  return MPTOp_test1() + MPTOp_test_own();
  103e00:	e9 3b fe ff ff       	jmp    103c40 <MPTOp_test1>
  103e05:	66 90                	xchg   %ax,%ax
  103e07:	66 90                	xchg   %ax,%ax
  103e09:	66 90                	xchg   %ax,%ax
  103e0b:	66 90                	xchg   %ax,%ax
  103e0d:	66 90                	xchg   %ax,%ax
  103e0f:	90                   	nop

00103e10 <alloc_ptbl>:
  * * 3. Clear (set to 0) all the page table entries for this newly mapped page table.
  * * 4. Return the page index of the newly allocated physical page.
  *    In the case when there's no physical page available, it returns 0.
  */
unsigned int alloc_ptbl(unsigned int proc_index, unsigned int vadr)
{
  103e10:	55                   	push   %ebp
  103e11:	57                   	push   %edi
  103e12:	56                   	push   %esi
  103e13:	53                   	push   %ebx
  103e14:	83 ec 18             	sub    $0x18,%esp
  103e17:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  // TODO
  unsigned int page_index = container_alloc(proc_index);
  103e1b:	56                   	push   %esi
  103e1c:	e8 7f f7 ff ff       	call   1035a0 <container_alloc>
  103e21:	89 c5                	mov    %eax,%ebp
  if (page_index != 0) {
  103e23:	83 c4 10             	add    $0x10,%esp
  103e26:	31 c0                	xor    %eax,%eax
  103e28:	85 ed                	test   %ebp,%ebp
  103e2a:	75 0c                	jne    103e38 <alloc_ptbl+0x28>
    return page_index;

  } else {
    return 0;
  }
}
  103e2c:	83 c4 0c             	add    $0xc,%esp
  103e2f:	5b                   	pop    %ebx
  103e30:	5e                   	pop    %esi
  103e31:	5f                   	pop    %edi
  103e32:	5d                   	pop    %ebp
  103e33:	c3                   	ret    
  103e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
unsigned int alloc_ptbl(unsigned int proc_index, unsigned int vadr)
{
  // TODO
  unsigned int page_index = container_alloc(proc_index);
  if (page_index != 0) {
    set_pdir_entry_by_va(proc_index, vadr, page_index);
  103e38:	83 ec 04             	sub    $0x4,%esp
    unsigned int vaddr_dir = vadr >> DIR_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    int i = 0;
    for (i = 0; i < 1024; i++) {
  103e3b:	31 db                	xor    %ebx,%ebx
unsigned int alloc_ptbl(unsigned int proc_index, unsigned int vadr)
{
  // TODO
  unsigned int page_index = container_alloc(proc_index);
  if (page_index != 0) {
    set_pdir_entry_by_va(proc_index, vadr, page_index);
  103e3d:	55                   	push   %ebp
  103e3e:	ff 74 24 2c          	pushl  0x2c(%esp)
  103e42:	56                   	push   %esi
  103e43:	e8 48 fd ff ff       	call   103b90 <set_pdir_entry_by_va>
    unsigned int vaddr_dir = vadr >> DIR_SHIFT;
  103e48:	8b 7c 24 34          	mov    0x34(%esp),%edi
  103e4c:	83 c4 10             	add    $0x10,%esp
  103e4f:	c1 ef 16             	shr    $0x16,%edi
  103e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    int i = 0;
    for (i = 0; i < 1024; i++) {
      rmv_ptbl_entry(proc_index, pdir, i);
  103e58:	83 ec 04             	sub    $0x4,%esp
  103e5b:	53                   	push   %ebx
  103e5c:	57                   	push   %edi
  if (page_index != 0) {
    set_pdir_entry_by_va(proc_index, vadr, page_index);
    unsigned int vaddr_dir = vadr >> DIR_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    int i = 0;
    for (i = 0; i < 1024; i++) {
  103e5d:	83 c3 01             	add    $0x1,%ebx
      rmv_ptbl_entry(proc_index, pdir, i);
  103e60:	56                   	push   %esi
  103e61:	e8 3a fa ff ff       	call   1038a0 <rmv_ptbl_entry>
  if (page_index != 0) {
    set_pdir_entry_by_va(proc_index, vadr, page_index);
    unsigned int vaddr_dir = vadr >> DIR_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    int i = 0;
    for (i = 0; i < 1024; i++) {
  103e66:	83 c4 10             	add    $0x10,%esp
  103e69:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  103e6f:	75 e7                	jne    103e58 <alloc_ptbl+0x48>
    return page_index;

  } else {
    return 0;
  }
}
  103e71:	83 c4 0c             	add    $0xc,%esp
  103e74:	89 e8                	mov    %ebp,%eax
  103e76:	5b                   	pop    %ebx
  103e77:	5e                   	pop    %esi
  103e78:	5f                   	pop    %edi
  103e79:	5d                   	pop    %ebp
  103e7a:	c3                   	ret    
  103e7b:	90                   	nop
  103e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103e80 <free_ptbl>:
  * Hint 1: Find the pde corresponding to vadr (MPTOp layer)
  * Hint 2: Remove the pde (MPTOp layer)
  * Hint 3: Use container free
  */
void free_ptbl(unsigned int proc_index, unsigned int vadr)
{
  103e80:	56                   	push   %esi
  103e81:	53                   	push   %ebx
  103e82:	83 ec 0c             	sub    $0xc,%esp
  103e85:	8b 74 24 18          	mov    0x18(%esp),%esi
  103e89:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
  // TODO
  unsigned int vaddr_dir = vadr >> DIR_SHIFT;
  unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
//  unsigned int pde = get_pdir_entry(proc_index, pdir);
  rmv_pdir_entry_by_va(proc_index, vadr);
  103e8d:	53                   	push   %ebx
  103e8e:	56                   	push   %esi
  container_free(proc_index, pdir);
  103e8f:	c1 eb 16             	shr    $0x16,%ebx
{
  // TODO
  unsigned int vaddr_dir = vadr >> DIR_SHIFT;
  unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
//  unsigned int pde = get_pdir_entry(proc_index, pdir);
  rmv_pdir_entry_by_va(proc_index, vadr);
  103e92:	e8 b9 fc ff ff       	call   103b50 <rmv_pdir_entry_by_va>
  container_free(proc_index, pdir);
  103e97:	89 5c 24 24          	mov    %ebx,0x24(%esp)
  103e9b:	89 74 24 20          	mov    %esi,0x20(%esp)

}
  103e9f:	83 c4 14             	add    $0x14,%esp
  103ea2:	5b                   	pop    %ebx
  103ea3:	5e                   	pop    %esi
  // TODO
  unsigned int vaddr_dir = vadr >> DIR_SHIFT;
  unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
//  unsigned int pde = get_pdir_entry(proc_index, pdir);
  rmv_pdir_entry_by_va(proc_index, vadr);
  container_free(proc_index, pdir);
  103ea4:	e9 17 f7 ff ff       	jmp    1035c0 <container_free>
  103ea9:	66 90                	xchg   %ax,%ax
  103eab:	66 90                	xchg   %ax,%ax
  103ead:	66 90                	xchg   %ax,%ax
  103eaf:	90                   	nop

00103eb0 <MPTComm_test1>:
#include <pmm/MContainer/export.h>
#include <vmm/MPTOp/export.h>
#include "export.h"

int MPTComm_test1()
{
  103eb0:	56                   	push   %esi
  103eb1:	53                   	push   %ebx
  103eb2:	be 03 01 00 00       	mov    $0x103,%esi
  103eb7:	bb 00 ff ff ff       	mov    $0xffffff00,%ebx
  103ebc:	83 ec 04             	sub    $0x4,%esp
  103ebf:	90                   	nop
  int i;
  for (i = 0; i < 1024; i ++) {     // kernel portion
    if (i < 256 || i >= 960) {      // proc[10], dir[kern], check if identity map
  103ec0:	81 fb bf 02 00 00    	cmp    $0x2bf,%ebx
  103ec6:	77 29                	ja     103ef1 <MPTComm_test1+0x41>
  103ec8:	83 c3 01             	add    $0x1,%ebx
  103ecb:	81 c6 00 00 40 00    	add    $0x400000,%esi
#include "export.h"

int MPTComm_test1()
{
  int i;
  for (i = 0; i < 1024; i ++) {     // kernel portion
  103ed1:	81 fb 00 03 00 00    	cmp    $0x300,%ebx
  103ed7:	75 e7                	jne    103ec0 <MPTComm_test1+0x10>
          dprintf("test 1 failed.\n");
        return 1;
      }
    }
  }
  dprintf("test 1 passed.\n");
  103ed9:	83 ec 0c             	sub    $0xc,%esp
  103edc:	68 01 63 10 00       	push   $0x106301
  103ee1:	e8 25 df ff ff       	call   101e0b <dprintf>
  return 0;
  103ee6:	83 c4 10             	add    $0x10,%esp
  103ee9:	31 c0                	xor    %eax,%eax
}
  103eeb:	83 c4 04             	add    $0x4,%esp
  103eee:	5b                   	pop    %ebx
  103eef:	5e                   	pop    %esi
  103ef0:	c3                   	ret    
int MPTComm_test1()
{
  int i;
  for (i = 0; i < 1024; i ++) {     // kernel portion
    if (i < 256 || i >= 960) {      // proc[10], dir[kern], check if identity map
      if (get_ptbl_entry_by_va(10, i * 4096 * 1024) != i * 4096 * 1024 + 259) {
  103ef1:	8d 86 fd fe ff ff    	lea    -0x103(%esi),%eax
  103ef7:	83 ec 08             	sub    $0x8,%esp
  103efa:	50                   	push   %eax
  103efb:	6a 0a                	push   $0xa
  103efd:	e8 ee fb ff ff       	call   103af0 <get_ptbl_entry_by_va>
  103f02:	83 c4 10             	add    $0x10,%esp
  103f05:	39 c6                	cmp    %eax,%esi
  103f07:	74 bf                	je     103ec8 <MPTComm_test1+0x18>

          dprintf("test 1 failed.\n");
  103f09:	83 ec 0c             	sub    $0xc,%esp
  103f0c:	68 f1 62 10 00       	push   $0x1062f1
  103f11:	e8 f5 de ff ff       	call   101e0b <dprintf>
        return 1;
  103f16:	83 c4 10             	add    $0x10,%esp
  103f19:	b8 01 00 00 00       	mov    $0x1,%eax
  103f1e:	eb cb                	jmp    103eeb <MPTComm_test1+0x3b>

00103f20 <MPTComm_test2>:
  dprintf("test 1 passed.\n");
  return 0;
}

int MPTComm_test2()
{
  103f20:	83 ec 14             	sub    $0x14,%esp
  unsigned int vaddr = 300 * 4096 * 1024;
  container_split(0, 100);
  103f23:	6a 64                	push   $0x64
  103f25:	6a 00                	push   $0x0
  103f27:	e8 14 f6 ff ff       	call   103540 <container_split>
  alloc_ptbl(1, vaddr);
  103f2c:	59                   	pop    %ecx
  103f2d:	58                   	pop    %eax
  103f2e:	68 00 00 00 4b       	push   $0x4b000000
  103f33:	6a 01                	push   $0x1
  103f35:	e8 d6 fe ff ff       	call   103e10 <alloc_ptbl>
  if (get_pdir_entry_by_va(1, vaddr) == 0) {
  103f3a:	58                   	pop    %eax
  103f3b:	5a                   	pop    %edx
  103f3c:	68 00 00 00 4b       	push   $0x4b000000
  103f41:	6a 01                	push   $0x1
  103f43:	e8 98 fb ff ff       	call   103ae0 <get_pdir_entry_by_va>
  103f48:	83 c4 10             	add    $0x10,%esp
  103f4b:	85 c0                	test   %eax,%eax
  103f4d:	74 51                	je     103fa0 <MPTComm_test2+0x80>
    dprintf("test 2 failed.\n");
    return 1;
  }
  if(get_ptbl_entry_by_va(1, vaddr) != 0) {
  103f4f:	83 ec 08             	sub    $0x8,%esp
  103f52:	68 00 00 00 4b       	push   $0x4b000000
  103f57:	6a 01                	push   $0x1
  103f59:	e8 92 fb ff ff       	call   103af0 <get_ptbl_entry_by_va>
  103f5e:	83 c4 10             	add    $0x10,%esp
  103f61:	85 c0                	test   %eax,%eax
  103f63:	75 3b                	jne    103fa0 <MPTComm_test2+0x80>
    dprintf("test 2 failed.\n");
    return 1;
  }
  free_ptbl(1, vaddr);
  103f65:	83 ec 08             	sub    $0x8,%esp
  103f68:	68 00 00 00 4b       	push   $0x4b000000
  103f6d:	6a 01                	push   $0x1
  103f6f:	e8 0c ff ff ff       	call   103e80 <free_ptbl>
  if (get_pdir_entry_by_va(1, vaddr) != 0) {
  103f74:	58                   	pop    %eax
  103f75:	5a                   	pop    %edx
  103f76:	68 00 00 00 4b       	push   $0x4b000000
  103f7b:	6a 01                	push   $0x1
  103f7d:	e8 5e fb ff ff       	call   103ae0 <get_pdir_entry_by_va>
  103f82:	83 c4 10             	add    $0x10,%esp
  103f85:	85 c0                	test   %eax,%eax
  103f87:	75 17                	jne    103fa0 <MPTComm_test2+0x80>
    dprintf("test 2 failed.\n");
    return 1;
  }
  dprintf("test 2 passed.\n");
  103f89:	83 ec 0c             	sub    $0xc,%esp
  103f8c:	68 bd 63 10 00       	push   $0x1063bd
  103f91:	e8 75 de ff ff       	call   101e0b <dprintf>
  103f96:	83 c4 10             	add    $0x10,%esp
  return 0;
  103f99:	31 c0                	xor    %eax,%eax
}
  103f9b:	83 c4 0c             	add    $0xc,%esp
  103f9e:	c3                   	ret    
  103f9f:	90                   	nop
{
  unsigned int vaddr = 300 * 4096 * 1024;
  container_split(0, 100);
  alloc_ptbl(1, vaddr);
  if (get_pdir_entry_by_va(1, vaddr) == 0) {
    dprintf("test 2 failed.\n");
  103fa0:	83 ec 0c             	sub    $0xc,%esp
  103fa3:	68 ad 63 10 00       	push   $0x1063ad
  103fa8:	e8 5e de ff ff       	call   101e0b <dprintf>
    return 1;
  103fad:	83 c4 10             	add    $0x10,%esp
  103fb0:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 2 failed.\n");
    return 1;
  }
  dprintf("test 2 passed.\n");
  return 0;
}
  103fb5:	83 c4 0c             	add    $0xc,%esp
  103fb8:	c3                   	ret    
  103fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103fc0 <MPTComm_test_own>:
int MPTComm_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  103fc0:	31 c0                	xor    %eax,%eax
  103fc2:	c3                   	ret    
  103fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103fd0 <test_MPTComm>:

int test_MPTComm()
{
  103fd0:	53                   	push   %ebx
  103fd1:	83 ec 08             	sub    $0x8,%esp
  return MPTComm_test1() + MPTComm_test2() + MPTComm_test_own();
  103fd4:	e8 d7 fe ff ff       	call   103eb0 <MPTComm_test1>
  103fd9:	89 c3                	mov    %eax,%ebx
  103fdb:	e8 40 ff ff ff       	call   103f20 <MPTComm_test2>
}
  103fe0:	83 c4 08             	add    $0x8,%esp
  return 0;
}

int test_MPTComm()
{
  return MPTComm_test1() + MPTComm_test2() + MPTComm_test_own();
  103fe3:	01 d8                	add    %ebx,%eax
}
  103fe5:	5b                   	pop    %ebx
  103fe6:	c3                   	ret    
  103fe7:	66 90                	xchg   %ax,%ax
  103fe9:	66 90                	xchg   %ax,%ax
  103feb:	66 90                	xchg   %ax,%ax
  103fed:	66 90                	xchg   %ax,%ax
  103fef:	90                   	nop

00103ff0 <pdir_init_kern>:
  * Hint 3: Recall which portions are reserved for the kernel and calculate the pde_index.
  * Hint 4: Recall which function in MPTIntro layer is used to set identity map. (See import.h)
  * Hint 5: Remove the page directory entry to unmap it.
  */
void pdir_init_kern(void)
{
  103ff0:	56                   	push   %esi
  103ff1:	53                   	push   %ebx
    idptbl_init();
    //TODO
    unsigned int process, pde;

    for (process = 0; process < 64; process++) {
  103ff2:	31 f6                	xor    %esi,%esi
  * Hint 3: Recall which portions are reserved for the kernel and calculate the pde_index.
  * Hint 4: Recall which function in MPTIntro layer is used to set identity map. (See import.h)
  * Hint 5: Remove the page directory entry to unmap it.
  */
void pdir_init_kern(void)
{
  103ff4:	83 ec 04             	sub    $0x4,%esp
    idptbl_init();
  103ff7:	e8 d4 fb ff ff       	call   103bd0 <idptbl_init>
  103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  * Hint 3: Recall which portions are reserved for the kernel and calculate the pde_index.
  * Hint 4: Recall which function in MPTIntro layer is used to set identity map. (See import.h)
  * Hint 5: Remove the page directory entry to unmap it.
  */
void pdir_init_kern(void)
{
  104000:	31 db                	xor    %ebx,%ebx
  104002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    //TODO
    unsigned int process, pde;

    for (process = 0; process < 64; process++) {
        for (pde = 0; pde < 1024; pde++) {
            if (process == 0) {
  104008:	85 f6                	test   %esi,%esi
  10400a:	74 33                	je     10403f <pdir_init_kern+0x4f>
                set_pdir_entry_identity(process, pde);

            } else if (pde < VM_USERLO_PDE || pde >= VM_USERHI_PDE) {
  10400c:	8d 83 00 ff ff ff    	lea    -0x100(%ebx),%eax
  104012:	3d bf 02 00 00       	cmp    $0x2bf,%eax
  104017:	77 36                	ja     10404f <pdir_init_kern+0x5f>
                set_pdir_entry_identity(process, pde);
            } else {
                rmv_pdir_entry(process, pde);
  104019:	83 ec 08             	sub    $0x8,%esp
  10401c:	53                   	push   %ebx
  10401d:	56                   	push   %esi
  10401e:	e8 ed f7 ff ff       	call   103810 <rmv_pdir_entry>
  104023:	83 c4 10             	add    $0x10,%esp
    idptbl_init();
    //TODO
    unsigned int process, pde;

    for (process = 0; process < 64; process++) {
        for (pde = 0; pde < 1024; pde++) {
  104026:	83 c3 01             	add    $0x1,%ebx
  104029:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  10402f:	75 d7                	jne    104008 <pdir_init_kern+0x18>
{
    idptbl_init();
    //TODO
    unsigned int process, pde;

    for (process = 0; process < 64; process++) {
  104031:	83 c6 01             	add    $0x1,%esi
  104034:	83 fe 40             	cmp    $0x40,%esi
  104037:	75 c7                	jne    104000 <pdir_init_kern+0x10>
                rmv_pdir_entry(process, pde);
            }

        }
    }
}
  104039:	83 c4 04             	add    $0x4,%esp
  10403c:	5b                   	pop    %ebx
  10403d:	5e                   	pop    %esi
  10403e:	c3                   	ret    
    unsigned int process, pde;

    for (process = 0; process < 64; process++) {
        for (pde = 0; pde < 1024; pde++) {
            if (process == 0) {
                set_pdir_entry_identity(process, pde);
  10403f:	83 ec 08             	sub    $0x8,%esp
  104042:	53                   	push   %ebx
  104043:	6a 00                	push   $0x0
  104045:	e8 a6 f7 ff ff       	call   1037f0 <set_pdir_entry_identity>
  10404a:	83 c4 10             	add    $0x10,%esp
  10404d:	eb d7                	jmp    104026 <pdir_init_kern+0x36>

            } else if (pde < VM_USERLO_PDE || pde >= VM_USERHI_PDE) {
                set_pdir_entry_identity(process, pde);
  10404f:	83 ec 08             	sub    $0x8,%esp
  104052:	53                   	push   %ebx
  104053:	56                   	push   %esi
  104054:	e8 97 f7 ff ff       	call   1037f0 <set_pdir_entry_identity>
  104059:	83 c4 10             	add    $0x10,%esp
  10405c:	eb c8                	jmp    104026 <pdir_init_kern+0x36>
  10405e:	66 90                	xchg   %ax,%ax

00104060 <map_page>:
  *         Otherwise, first allocate the page table (MPTComm layer)
  *         - If there is an error during allocation, return MagicNumber.
  * Hint 3: If you have a valid pde, set the page table entry to new physical page (page_index) and perm.
  * Hint 4: Return the pde index or MagicNumber.
  */
unsigned int map_page(unsigned int proc_index, unsigned int vadr, unsigned int page_index, unsigned int perm) {
  104060:	57                   	push   %edi
  104061:	56                   	push   %esi
  104062:	53                   	push   %ebx
  104063:	83 ec 18             	sub    $0x18,%esp
  104066:	8b 5c 24 28          	mov    0x28(%esp),%ebx
  10406a:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  // TODO
    unsigned int vaddr_dir = vadr >> DIR_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int pde = get_pdir_entry_by_va(proc_index, vadr);
  10406e:	56                   	push   %esi
  10406f:	53                   	push   %ebx
  104070:	e8 6b fa ff ff       	call   103ae0 <get_pdir_entry_by_va>
    unsigned int pde_index;
    if (pde != 0) {
  104075:	83 c4 10             	add    $0x10,%esp
  104078:	85 c0                	test   %eax,%eax
  10407a:	75 24                	jne    1040a0 <map_page+0x40>
        pde_index = pde / PAGESIZE;
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
        return pde_index;
    } else {
        int result = alloc_ptbl(proc_index, vadr);
  10407c:	83 ec 08             	sub    $0x8,%esp
  10407f:	56                   	push   %esi
  104080:	53                   	push   %ebx
  104081:	e8 8a fd ff ff       	call   103e10 <alloc_ptbl>
        if (result == 0)
  104086:	83 c4 10             	add    $0x10,%esp
  104089:	85 c0                	test   %eax,%eax
  10408b:	75 33                	jne    1040c0 <map_page+0x60>
            return MagicNumber;
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
        return result;
    }
}
  10408d:	83 c4 10             	add    $0x10,%esp
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
        return pde_index;
    } else {
        int result = alloc_ptbl(proc_index, vadr);
        if (result == 0)
            return MagicNumber;
  104090:	b8 01 00 10 00       	mov    $0x100001,%eax
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
        return result;
    }
}
  104095:	5b                   	pop    %ebx
  104096:	5e                   	pop    %esi
  104097:	5f                   	pop    %edi
  104098:	c3                   	ret    
  104099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int pde = get_pdir_entry_by_va(proc_index, vadr);
    unsigned int pde_index;
    if (pde != 0) {
        pde_index = pde / PAGESIZE;
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
  1040a0:	ff 74 24 2c          	pushl  0x2c(%esp)
  1040a4:	ff 74 24 2c          	pushl  0x2c(%esp)
    unsigned int vaddr_dir = vadr >> DIR_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int pde = get_pdir_entry_by_va(proc_index, vadr);
    unsigned int pde_index;
    if (pde != 0) {
        pde_index = pde / PAGESIZE;
  1040a8:	c1 e8 0c             	shr    $0xc,%eax
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
  1040ab:	56                   	push   %esi
  1040ac:	53                   	push   %ebx
    unsigned int vaddr_dir = vadr >> DIR_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int pde = get_pdir_entry_by_va(proc_index, vadr);
    unsigned int pde_index;
    if (pde != 0) {
        pde_index = pde / PAGESIZE;
  1040ad:	89 c7                	mov    %eax,%edi
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
  1040af:	e8 ec fa ff ff       	call   103ba0 <set_ptbl_entry_by_va>
        return pde_index;
  1040b4:	83 c4 10             	add    $0x10,%esp
  1040b7:	89 f8                	mov    %edi,%eax
        if (result == 0)
            return MagicNumber;
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
        return result;
    }
}
  1040b9:	83 c4 10             	add    $0x10,%esp
  1040bc:	5b                   	pop    %ebx
  1040bd:	5e                   	pop    %esi
  1040be:	5f                   	pop    %edi
  1040bf:	c3                   	ret    
  1040c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
        return pde_index;
    } else {
        int result = alloc_ptbl(proc_index, vadr);
        if (result == 0)
            return MagicNumber;
        set_ptbl_entry_by_va(proc_index, vadr, page_index, perm);
  1040c4:	ff 74 24 2c          	pushl  0x2c(%esp)
  1040c8:	ff 74 24 2c          	pushl  0x2c(%esp)
  1040cc:	56                   	push   %esi
  1040cd:	53                   	push   %ebx
  1040ce:	e8 cd fa ff ff       	call   103ba0 <set_ptbl_entry_by_va>
        return result;
  1040d3:	83 c4 10             	add    $0x10,%esp
  1040d6:	8b 44 24 0c          	mov    0xc(%esp),%eax
    }
}
  1040da:	83 c4 10             	add    $0x10,%esp
  1040dd:	5b                   	pop    %ebx
  1040de:	5e                   	pop    %esi
  1040df:	5f                   	pop    %edi
  1040e0:	c3                   	ret    
  1040e1:	eb 0d                	jmp    1040f0 <unmap_page>
  1040e3:	90                   	nop
  1040e4:	90                   	nop
  1040e5:	90                   	nop
  1040e6:	90                   	nop
  1040e7:	90                   	nop
  1040e8:	90                   	nop
  1040e9:	90                   	nop
  1040ea:	90                   	nop
  1040eb:	90                   	nop
  1040ec:	90                   	nop
  1040ed:	90                   	nop
  1040ee:	90                   	nop
  1040ef:	90                   	nop

001040f0 <unmap_page>:
  *         - Nothing should be done if the mapping no longer exists.
  * Hint 2: If pte is valid, remove page table entry for vadr.
  * Hint 3: Return the corresponding page table entry.
  */
unsigned int unmap_page(unsigned int proc_index, unsigned int vadr)
{
  1040f0:	56                   	push   %esi
  1040f1:	53                   	push   %ebx
  1040f2:	83 ec 1c             	sub    $0x1c,%esp
  1040f5:	8b 5c 24 28          	mov    0x28(%esp),%ebx
  1040f9:	8b 74 24 2c          	mov    0x2c(%esp),%esi

    unsigned int vaddr_dir = vadr >> DIR_SHIFT;
    unsigned int vaddr_table = vadr >> PAGE_SHIFT;
    unsigned int pdir = vaddr_dir & (DIR_MASK >> DIR_SHIFT);
    unsigned int ptbl = vaddr_table & (PAGE_MASK >> PAGE_SHIFT);
    unsigned int pte = get_ptbl_entry_by_va(proc_index, vadr);
  1040fd:	56                   	push   %esi
  1040fe:	53                   	push   %ebx
  1040ff:	e8 ec f9 ff ff       	call   103af0 <get_ptbl_entry_by_va>
    if (pte != 0) {
  104104:	83 c4 10             	add    $0x10,%esp
  104107:	85 c0                	test   %eax,%eax
  104109:	74 15                	je     104120 <unmap_page+0x30>
  10410b:	89 44 24 0c          	mov    %eax,0xc(%esp)
        rmv_ptbl_entry_by_va(proc_index, vadr);
  10410f:	83 ec 08             	sub    $0x8,%esp
  104112:	56                   	push   %esi
  104113:	53                   	push   %ebx
  104114:	e8 47 fa ff ff       	call   103b60 <rmv_ptbl_entry_by_va>
        return pte;
  104119:	83 c4 10             	add    $0x10,%esp
  10411c:	8b 44 24 0c          	mov    0xc(%esp),%eax
    } else {
        return 0;
    }

}
  104120:	83 c4 14             	add    $0x14,%esp
  104123:	5b                   	pop    %ebx
  104124:	5e                   	pop    %esi
  104125:	c3                   	ret    
  104126:	66 90                	xchg   %ax,%ax
  104128:	66 90                	xchg   %ax,%ax
  10412a:	66 90                	xchg   %ax,%ax
  10412c:	66 90                	xchg   %ax,%ax
  10412e:	66 90                	xchg   %ax,%ax

00104130 <MPTKern_test1>:
#include <pmm/MContainer/export.h>
#include <vmm/MPTOp/export.h>
#include "export.h"

int MPTKern_test1()
{
  104130:	83 ec 14             	sub    $0x14,%esp
  unsigned int vaddr = 4096*1024*300;
  container_split(0, 100);
  104133:	6a 64                	push   $0x64
  104135:	6a 00                	push   $0x0
  104137:	e8 04 f4 ff ff       	call   103540 <container_split>
  if (get_ptbl_entry_by_va(1, vaddr) != 0) {
  10413c:	58                   	pop    %eax
  10413d:	5a                   	pop    %edx
  10413e:	68 00 00 00 4b       	push   $0x4b000000
  104143:	6a 01                	push   $0x1
  104145:	e8 a6 f9 ff ff       	call   103af0 <get_ptbl_entry_by_va>
  10414a:	83 c4 10             	add    $0x10,%esp
  10414d:	85 c0                	test   %eax,%eax
  10414f:	0f 85 bb 00 00 00    	jne    104210 <MPTKern_test1+0xe0>
      dprintf("test 1 failed1.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(1, vaddr) != 0) {
  104155:	83 ec 08             	sub    $0x8,%esp
  104158:	68 00 00 00 4b       	push   $0x4b000000
  10415d:	6a 01                	push   $0x1
  10415f:	e8 7c f9 ff ff       	call   103ae0 <get_pdir_entry_by_va>
  104164:	83 c4 10             	add    $0x10,%esp
  104167:	85 c0                	test   %eax,%eax
  104169:	0f 85 81 00 00 00    	jne    1041f0 <MPTKern_test1+0xc0>
      dprintf("test 1 failed2.\n");
    return 1;
  }
  map_page(1, vaddr, 100, 7);
  10416f:	6a 07                	push   $0x7
  104171:	6a 64                	push   $0x64
  104173:	68 00 00 00 4b       	push   $0x4b000000
  104178:	6a 01                	push   $0x1
  10417a:	e8 e1 fe ff ff       	call   104060 <map_page>
  if (get_ptbl_entry_by_va(1, vaddr) == 0) {
  10417f:	59                   	pop    %ecx
  104180:	58                   	pop    %eax
  104181:	68 00 00 00 4b       	push   $0x4b000000
  104186:	6a 01                	push   $0x1
  104188:	e8 63 f9 ff ff       	call   103af0 <get_ptbl_entry_by_va>
  10418d:	83 c4 10             	add    $0x10,%esp
  104190:	85 c0                	test   %eax,%eax
  104192:	0f 84 b8 00 00 00    	je     104250 <MPTKern_test1+0x120>
      dprintf("test 1 failed3.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(1, vaddr) == 0) {
  104198:	83 ec 08             	sub    $0x8,%esp
  10419b:	68 00 00 00 4b       	push   $0x4b000000
  1041a0:	6a 01                	push   $0x1
  1041a2:	e8 39 f9 ff ff       	call   103ae0 <get_pdir_entry_by_va>
  1041a7:	83 c4 10             	add    $0x10,%esp
  1041aa:	85 c0                	test   %eax,%eax
  1041ac:	0f 84 7e 00 00 00    	je     104230 <MPTKern_test1+0x100>
      dprintf("test 1 failed4.\n");
    return 1;
  }
  unmap_page(1, vaddr);
  1041b2:	83 ec 08             	sub    $0x8,%esp
  1041b5:	68 00 00 00 4b       	push   $0x4b000000
  1041ba:	6a 01                	push   $0x1
  1041bc:	e8 2f ff ff ff       	call   1040f0 <unmap_page>
  if (get_ptbl_entry_by_va(1, vaddr) != 0) {
  1041c1:	58                   	pop    %eax
  1041c2:	5a                   	pop    %edx
  1041c3:	68 00 00 00 4b       	push   $0x4b000000
  1041c8:	6a 01                	push   $0x1
  1041ca:	e8 21 f9 ff ff       	call   103af0 <get_ptbl_entry_by_va>
  1041cf:	83 c4 10             	add    $0x10,%esp
  1041d2:	85 c0                	test   %eax,%eax
  1041d4:	0f 85 96 00 00 00    	jne    104270 <MPTKern_test1+0x140>
      dprintf("test 1 failed5.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  1041da:	83 ec 0c             	sub    $0xc,%esp
  1041dd:	68 01 63 10 00       	push   $0x106301
  1041e2:	e8 24 dc ff ff       	call   101e0b <dprintf>
  1041e7:	83 c4 10             	add    $0x10,%esp
  return 0;
  1041ea:	31 c0                	xor    %eax,%eax
  1041ec:	eb 17                	jmp    104205 <MPTKern_test1+0xd5>
  1041ee:	66 90                	xchg   %ax,%ax
  if (get_ptbl_entry_by_va(1, vaddr) != 0) {
      dprintf("test 1 failed1.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(1, vaddr) != 0) {
      dprintf("test 1 failed2.\n");
  1041f0:	83 ec 0c             	sub    $0xc,%esp
  1041f3:	68 de 63 10 00       	push   $0x1063de
  1041f8:	e8 0e dc ff ff       	call   101e0b <dprintf>
    return 1;
  1041fd:	83 c4 10             	add    $0x10,%esp
  104200:	b8 01 00 00 00       	mov    $0x1,%eax
      dprintf("test 1 failed5.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  104205:	83 c4 0c             	add    $0xc,%esp
  104208:	c3                   	ret    
  104209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
int MPTKern_test1()
{
  unsigned int vaddr = 4096*1024*300;
  container_split(0, 100);
  if (get_ptbl_entry_by_va(1, vaddr) != 0) {
      dprintf("test 1 failed1.\n");
  104210:	83 ec 0c             	sub    $0xc,%esp
  104213:	68 cd 63 10 00       	push   $0x1063cd
  104218:	e8 ee db ff ff       	call   101e0b <dprintf>
    return 1;
  10421d:	83 c4 10             	add    $0x10,%esp
  104220:	b8 01 00 00 00       	mov    $0x1,%eax
      dprintf("test 1 failed5.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  104225:	83 c4 0c             	add    $0xc,%esp
  104228:	c3                   	ret    
  104229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (get_ptbl_entry_by_va(1, vaddr) == 0) {
      dprintf("test 1 failed3.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(1, vaddr) == 0) {
      dprintf("test 1 failed4.\n");
  104230:	83 ec 0c             	sub    $0xc,%esp
  104233:	68 00 64 10 00       	push   $0x106400
  104238:	e8 ce db ff ff       	call   101e0b <dprintf>
  10423d:	83 c4 10             	add    $0x10,%esp
    return 1;
  104240:	b8 01 00 00 00       	mov    $0x1,%eax
  104245:	eb be                	jmp    104205 <MPTKern_test1+0xd5>
  104247:	89 f6                	mov    %esi,%esi
  104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dprintf("test 1 failed2.\n");
    return 1;
  }
  map_page(1, vaddr, 100, 7);
  if (get_ptbl_entry_by_va(1, vaddr) == 0) {
      dprintf("test 1 failed3.\n");
  104250:	83 ec 0c             	sub    $0xc,%esp
  104253:	68 ef 63 10 00       	push   $0x1063ef
  104258:	e8 ae db ff ff       	call   101e0b <dprintf>
    return 1;
  10425d:	83 c4 10             	add    $0x10,%esp
  104260:	b8 01 00 00 00       	mov    $0x1,%eax
      dprintf("test 1 failed5.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  104265:	83 c4 0c             	add    $0xc,%esp
  104268:	c3                   	ret    
  104269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      dprintf("test 1 failed4.\n");
    return 1;
  }
  unmap_page(1, vaddr);
  if (get_ptbl_entry_by_va(1, vaddr) != 0) {
      dprintf("test 1 failed5.\n");
  104270:	83 ec 0c             	sub    $0xc,%esp
  104273:	68 11 64 10 00       	push   $0x106411
  104278:	e8 8e db ff ff       	call   101e0b <dprintf>
  10427d:	83 c4 10             	add    $0x10,%esp
    return 1;
  104280:	b8 01 00 00 00       	mov    $0x1,%eax
  104285:	e9 7b ff ff ff       	jmp    104205 <MPTKern_test1+0xd5>
  10428a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104290 <MPTKern_test2>:
  dprintf("test 1 passed.\n");
  return 0;
}

int MPTKern_test2()
{
  104290:	56                   	push   %esi
  104291:	53                   	push   %ebx
  unsigned int i;
  for (i = 256; i < 960; i ++) {
  104292:	bb 00 01 00 00       	mov    $0x100,%ebx
  dprintf("test 1 passed.\n");
  return 0;
}

int MPTKern_test2()
{
  104297:	83 ec 04             	sub    $0x4,%esp
  10429a:	eb 0f                	jmp    1042ab <MPTKern_test2+0x1b>
  10429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  unsigned int i;
  for (i = 256; i < 960; i ++) {
  1042a0:	83 c3 01             	add    $0x1,%ebx
  1042a3:	81 fb c0 03 00 00    	cmp    $0x3c0,%ebx
  1042a9:	74 55                	je     104300 <MPTKern_test2+0x70>
    if (get_ptbl_entry_by_va(0, i * 4096 * 1024L) != i * 4096 * 1024L + 3) {
  1042ab:	89 de                	mov    %ebx,%esi
  1042ad:	83 ec 08             	sub    $0x8,%esp
  1042b0:	c1 e6 16             	shl    $0x16,%esi
  1042b3:	56                   	push   %esi
  1042b4:	6a 00                	push   $0x0
  1042b6:	e8 35 f8 ff ff       	call   103af0 <get_ptbl_entry_by_va>
  1042bb:	8d 56 03             	lea    0x3(%esi),%edx
  1042be:	83 c4 10             	add    $0x10,%esp
  1042c1:	39 c2                	cmp    %eax,%edx
  1042c3:	74 db                	je     1042a0 <MPTKern_test2+0x10>
        dprintf("test 2 ptbl entry %d = %d, should be= %d  failed.\n", i, get_ptbl_entry_by_va(0, i * 4096 * 1024L),
  1042c5:	83 ec 08             	sub    $0x8,%esp
  1042c8:	56                   	push   %esi
  1042c9:	6a 00                	push   $0x0
  1042cb:	e8 20 f8 ff ff       	call   103af0 <get_ptbl_entry_by_va>
  1042d0:	56                   	push   %esi
  1042d1:	50                   	push   %eax
  1042d2:	53                   	push   %ebx
  1042d3:	68 34 64 10 00       	push   $0x106434
  1042d8:	e8 2e db ff ff       	call   101e0b <dprintf>
                (i * 4096 * 1024L));
      dprintf("test 2 failed.\n");
  1042dd:	83 c4 14             	add    $0x14,%esp
  1042e0:	68 ad 63 10 00       	push   $0x1063ad
  1042e5:	e8 21 db ff ff       	call   101e0b <dprintf>
      return 1;
  1042ea:	83 c4 10             	add    $0x10,%esp
  1042ed:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  dprintf("test 2 passed.\n");
  return 0;
}
  1042f2:	83 c4 04             	add    $0x4,%esp
  1042f5:	5b                   	pop    %ebx
  1042f6:	5e                   	pop    %esi
  1042f7:	c3                   	ret    
  1042f8:	90                   	nop
  1042f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                (i * 4096 * 1024L));
      dprintf("test 2 failed.\n");
      return 1;
    }
  }
  dprintf("test 2 passed.\n");
  104300:	83 ec 0c             	sub    $0xc,%esp
  104303:	68 bd 63 10 00       	push   $0x1063bd
  104308:	e8 fe da ff ff       	call   101e0b <dprintf>
  return 0;
  10430d:	83 c4 10             	add    $0x10,%esp
  104310:	31 c0                	xor    %eax,%eax
}
  104312:	83 c4 04             	add    $0x4,%esp
  104315:	5b                   	pop    %ebx
  104316:	5e                   	pop    %esi
  104317:	c3                   	ret    
  104318:	90                   	nop
  104319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104320 <MPTKern_test_own>:
int MPTKern_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  104320:	31 c0                	xor    %eax,%eax
  104322:	c3                   	ret    
  104323:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104330 <test_MPTKern>:

int test_MPTKern()
{
  104330:	53                   	push   %ebx
  104331:	83 ec 08             	sub    $0x8,%esp
  return MPTKern_test1() + MPTKern_test2() + MPTKern_test_own();
  104334:	e8 f7 fd ff ff       	call   104130 <MPTKern_test1>
  104339:	89 c3                	mov    %eax,%ebx
  10433b:	e8 50 ff ff ff       	call   104290 <MPTKern_test2>
}
  104340:	83 c4 08             	add    $0x8,%esp
  return 0;
}

int test_MPTKern()
{
  return MPTKern_test1() + MPTKern_test2() + MPTKern_test_own();
  104343:	01 d8                	add    %ebx,%eax
}
  104345:	5b                   	pop    %ebx
  104346:	c3                   	ret    
  104347:	66 90                	xchg   %ax,%ax
  104349:	66 90                	xchg   %ax,%ax
  10434b:	66 90                	xchg   %ax,%ax
  10434d:	66 90                	xchg   %ax,%ax
  10434f:	90                   	nop

00104350 <alloc_page>:
  *   - It should return the physical page index registered in the page directory, i.e., the
  *     return value from map_page.
  *   - In the case of error, it should return the MagicNumber.
  */
unsigned int alloc_page (unsigned int proc_index, unsigned int vaddr, unsigned int perm)
{
  104350:	53                   	push   %ebx
  104351:	83 ec 14             	sub    $0x14,%esp
  104354:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
  // TODO
  unsigned int page_index = container_alloc(proc_index);
  104358:	53                   	push   %ebx
  104359:	e8 42 f2 ff ff       	call   1035a0 <container_alloc>
  if (page_index == 0)
  10435e:	83 c4 10             	add    $0x10,%esp
  104361:	85 c0                	test   %eax,%eax
  104363:	ba 01 00 10 00       	mov    $0x100001,%edx
  104368:	75 0e                	jne    104378 <alloc_page+0x28>
    return MagicNumber;
  unsigned physical_page = map_page(proc_index, vaddr, page_index, perm);
  return physical_page;
}
  10436a:	83 c4 08             	add    $0x8,%esp
  10436d:	89 d0                	mov    %edx,%eax
  10436f:	5b                   	pop    %ebx
  104370:	c3                   	ret    
  104371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  // TODO
  unsigned int page_index = container_alloc(proc_index);
  if (page_index == 0)
    return MagicNumber;
  unsigned physical_page = map_page(proc_index, vaddr, page_index, perm);
  104378:	ff 74 24 18          	pushl  0x18(%esp)
  10437c:	50                   	push   %eax
  10437d:	ff 74 24 1c          	pushl  0x1c(%esp)
  104381:	53                   	push   %ebx
  104382:	e8 d9 fc ff ff       	call   104060 <map_page>
  return physical_page;
  104387:	83 c4 10             	add    $0x10,%esp
  10438a:	89 c2                	mov    %eax,%edx
}
  10438c:	83 c4 08             	add    $0x8,%esp
  10438f:	89 d0                	mov    %edx,%eax
  104391:	5b                   	pop    %ebx
  104392:	c3                   	ret    
  104393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001043a0 <alloc_mem_quota>:
 * Designate some memory quota for the next child process.
 */
unsigned int alloc_mem_quota (unsigned int id, unsigned int quota)
{
  unsigned int child;
  child = container_split (id, quota);
  1043a0:	e9 9b f1 ff ff       	jmp    103540 <container_split>
  1043a5:	66 90                	xchg   %ax,%ax
  1043a7:	66 90                	xchg   %ax,%ax
  1043a9:	66 90                	xchg   %ax,%ax
  1043ab:	66 90                	xchg   %ax,%ax
  1043ad:	66 90                	xchg   %ax,%ax
  1043af:	90                   	nop

001043b0 <MPTNew_test1>:
#include <vmm/MPTOp/export.h>
#include "export.h"
#include "import.h"

int MPTNew_test1()
{
  1043b0:	83 ec 14             	sub    $0x14,%esp
  unsigned int vaddr = 4096*1024*400;
  container_split(0, 100);
  1043b3:	6a 64                	push   $0x64
  1043b5:	6a 00                	push   $0x0
  1043b7:	e8 84 f1 ff ff       	call   103540 <container_split>
  if (get_ptbl_entry_by_va(1, vaddr) != 0) {
  1043bc:	59                   	pop    %ecx
  1043bd:	58                   	pop    %eax
  1043be:	68 00 00 00 64       	push   $0x64000000
  1043c3:	6a 01                	push   $0x1
  1043c5:	e8 26 f7 ff ff       	call   103af0 <get_ptbl_entry_by_va>
  1043ca:	83 c4 10             	add    $0x10,%esp
  1043cd:	85 c0                	test   %eax,%eax
  1043cf:	75 6f                	jne    104440 <MPTNew_test1+0x90>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(1, vaddr) != 0) {
  1043d1:	83 ec 08             	sub    $0x8,%esp
  1043d4:	68 00 00 00 64       	push   $0x64000000
  1043d9:	6a 01                	push   $0x1
  1043db:	e8 00 f7 ff ff       	call   103ae0 <get_pdir_entry_by_va>
  1043e0:	83 c4 10             	add    $0x10,%esp
  1043e3:	85 c0                	test   %eax,%eax
  1043e5:	75 59                	jne    104440 <MPTNew_test1+0x90>
    dprintf("test 1 failed.\n");
    return 1;
  }
  alloc_page(1, vaddr, 7);
  1043e7:	83 ec 04             	sub    $0x4,%esp
  1043ea:	6a 07                	push   $0x7
  1043ec:	68 00 00 00 64       	push   $0x64000000
  1043f1:	6a 01                	push   $0x1
  1043f3:	e8 58 ff ff ff       	call   104350 <alloc_page>
  if (get_ptbl_entry_by_va(1, vaddr) == 0) {
  1043f8:	58                   	pop    %eax
  1043f9:	5a                   	pop    %edx
  1043fa:	68 00 00 00 64       	push   $0x64000000
  1043ff:	6a 01                	push   $0x1
  104401:	e8 ea f6 ff ff       	call   103af0 <get_ptbl_entry_by_va>
  104406:	83 c4 10             	add    $0x10,%esp
  104409:	85 c0                	test   %eax,%eax
  10440b:	74 33                	je     104440 <MPTNew_test1+0x90>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (get_pdir_entry_by_va(1, vaddr) == 0) {
  10440d:	83 ec 08             	sub    $0x8,%esp
  104410:	68 00 00 00 64       	push   $0x64000000
  104415:	6a 01                	push   $0x1
  104417:	e8 c4 f6 ff ff       	call   103ae0 <get_pdir_entry_by_va>
  10441c:	83 c4 10             	add    $0x10,%esp
  10441f:	85 c0                	test   %eax,%eax
  104421:	74 1d                	je     104440 <MPTNew_test1+0x90>
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  104423:	83 ec 0c             	sub    $0xc,%esp
  104426:	68 01 63 10 00       	push   $0x106301
  10442b:	e8 db d9 ff ff       	call   101e0b <dprintf>
  104430:	83 c4 10             	add    $0x10,%esp
  return 0;
  104433:	31 c0                	xor    %eax,%eax
}
  104435:	83 c4 0c             	add    $0xc,%esp
  104438:	c3                   	ret    
  104439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
int MPTNew_test1()
{
  unsigned int vaddr = 4096*1024*400;
  container_split(0, 100);
  if (get_ptbl_entry_by_va(1, vaddr) != 0) {
    dprintf("test 1 failed.\n");
  104440:	83 ec 0c             	sub    $0xc,%esp
  104443:	68 f1 62 10 00       	push   $0x1062f1
  104448:	e8 be d9 ff ff       	call   101e0b <dprintf>
    return 1;
  10444d:	83 c4 10             	add    $0x10,%esp
  104450:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  104455:	83 c4 0c             	add    $0xc,%esp
  104458:	c3                   	ret    
  104459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104460 <MPTNew_test_own>:
int MPTNew_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  104460:	31 c0                	xor    %eax,%eax
  104462:	c3                   	ret    
  104463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104470 <test_MPTNew>:

int test_MPTNew()
{
  return MPTNew_test1() + MPTNew_test_own();
  104470:	e9 3b ff ff ff       	jmp    1043b0 <MPTNew_test1>
  104475:	66 90                	xchg   %ax,%ax
  104477:	66 90                	xchg   %ax,%ax
  104479:	66 90                	xchg   %ax,%ax
  10447b:	66 90                	xchg   %ax,%ax
  10447d:	66 90                	xchg   %ax,%ax
  10447f:	90                   	nop

00104480 <kctx_set_esp>:

//places to save the [NUM_IDS] kernel thread states.
struct kctx kctx_pool[NUM_IDS];

void kctx_set_esp(unsigned int pid, void *esp)
{
  104480:	8b 44 24 04          	mov    0x4(%esp),%eax
	kctx_pool[pid].esp = esp;
  104484:	8b 54 24 08          	mov    0x8(%esp),%edx
  104488:	8d 04 40             	lea    (%eax,%eax,2),%eax
  10448b:	89 14 c5 00 c0 de 01 	mov    %edx,0x1dec000(,%eax,8)
  104492:	c3                   	ret    
  104493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001044a0 <kctx_set_eip>:
}

void kctx_set_eip(unsigned int pid, void *eip)
{
  1044a0:	8b 44 24 04          	mov    0x4(%esp),%eax
	kctx_pool[pid].eip = eip;
  1044a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  1044a8:	8d 04 40             	lea    (%eax,%eax,2),%eax
  1044ab:	89 14 c5 14 c0 de 01 	mov    %edx,0x1dec014(,%eax,8)
  1044b2:	c3                   	ret    
  1044b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1044b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001044c0 <kctx_switch>:
/**
 * Saves the states for thread # [from_pid] and restores the states
 * for thread # [to_pid].
 */
void kctx_switch(unsigned int from_pid, unsigned int to_pid)
{
  1044c0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1044c4:	8b 54 24 08          	mov    0x8(%esp),%edx
	cswitch(&kctx_pool[from_pid], &kctx_pool[to_pid]);
  1044c8:	8d 04 40             	lea    (%eax,%eax,2),%eax
  1044cb:	8d 14 52             	lea    (%edx,%edx,2),%edx
  1044ce:	8d 04 c5 00 c0 de 01 	lea    0x1dec000(,%eax,8),%eax
  1044d5:	8d 14 d5 00 c0 de 01 	lea    0x1dec000(,%edx,8),%edx
  1044dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044e0:	89 54 24 08          	mov    %edx,0x8(%esp)
  1044e4:	e9 00 00 00 00       	jmp    1044e9 <cswitch>

001044e9 <cswitch>:
cswitch:
	/**
	  * The pointer *from is saved to register %eax.
	  * This is the pointer to the kctx structure to be saved.
	  */
	movl	  4(%esp), %eax	
  1044e9:	8b 44 24 04          	mov    0x4(%esp),%eax

	/**
	  * The pointer *to is saved to register %edx.
	  * This is the pointer to the kctx structure to be loaded.
	  */
	movl	  8(%esp), %edx	
  1044ed:	8b 54 24 08          	mov    0x8(%esp),%edx
		- To save the old kernel context, you have to save the values of the corresponding registers
		  into these memory locations.

	  *  - The saved eip in this data-structure should point to the return address of this function.
	  */
	 movl      %esp, 0(%eax)
  1044f1:	89 20                	mov    %esp,(%eax)
	 movl      %edi, 4(%eax)
  1044f3:	89 78 04             	mov    %edi,0x4(%eax)
	 movl      %esi, 8(%eax)
  1044f6:	89 70 08             	mov    %esi,0x8(%eax)
	 movl      %ebx, 12(%eax)
  1044f9:	89 58 0c             	mov    %ebx,0xc(%eax)
	 movl      %ebp, 16(%eax)
  1044fc:	89 68 10             	mov    %ebp,0x10(%eax)
	 movl      0(%esp), %ecx
  1044ff:	8b 0c 24             	mov    (%esp),%ecx
	 movl      %ecx, 20(%eax)
  104502:	89 48 14             	mov    %ecx,0x14(%eax)


	/**
	  * The return value is stored in eax. Returns 0.
	  */
	movl    0(%edx), %esp
  104505:	8b 22                	mov    (%edx),%esp
	movl    4(%edx), %edi
  104507:	8b 7a 04             	mov    0x4(%edx),%edi
	movl    8(%edx), %esi
  10450a:	8b 72 08             	mov    0x8(%edx),%esi
	movl    12(%edx), %ebx
  10450d:	8b 5a 0c             	mov    0xc(%edx),%ebx
	movl    16(%edx), %ebp
  104510:	8b 6a 10             	mov    0x10(%edx),%ebp
	movl    20(%edx), %ecx
  104513:	8b 4a 14             	mov    0x14(%edx),%ecx
	movl    %ecx, 0(%esp)
  104516:	89 0c 24             	mov    %ecx,(%esp)
	xor     %eax, %eax
  104519:	31 c0                	xor    %eax,%eax
	ret
  10451b:	c3                   	ret    
  10451c:	66 90                	xchg   %ax,%ax
  10451e:	66 90                	xchg   %ax,%ax

00104520 <kctx_new>:
  *    i.e. Address of STACK_LOC[child][PAGESIZE - 1]. Remember that the stack is going down from high address to low.
  *  Hint 3:
  *  - Return the child pid.
  */
unsigned int kctx_new(void *entry, unsigned int id, unsigned int quota)
{
  104520:	53                   	push   %ebx
  104521:	83 ec 10             	sub    $0x10,%esp
  unsigned int child_pid = alloc_mem_quota(id, quota);
  104524:	ff 74 24 20          	pushl  0x20(%esp)
  104528:	ff 74 24 20          	pushl  0x20(%esp)
  10452c:	e8 6f fe ff ff       	call   1043a0 <alloc_mem_quota>
  104531:	89 c3                	mov    %eax,%ebx
  kctx_set_eip(child_pid, entry);
  104533:	58                   	pop    %eax
  104534:	5a                   	pop    %edx
  104535:	ff 74 24 18          	pushl  0x18(%esp)
  104539:	53                   	push   %ebx
  10453a:	e8 61 ff ff ff       	call   1044a0 <kctx_set_eip>
  kctx_set_esp(child_pid, &STACK_LOC[child_pid][PAGESIZE - 1]);
  10453f:	59                   	pop    %ecx
  104540:	58                   	pop    %eax
  104541:	89 d8                	mov    %ebx,%eax
  104543:	c1 e0 0c             	shl    $0xc,%eax
  104546:	05 ff 8f 96 01       	add    $0x1968fff,%eax
  10454b:	50                   	push   %eax
  10454c:	53                   	push   %ebx
  10454d:	e8 2e ff ff ff       	call   104480 <kctx_set_esp>
  return child_pid;
}
  104552:	83 c4 18             	add    $0x18,%esp
  104555:	89 d8                	mov    %ebx,%eax
  104557:	5b                   	pop    %ebx
  104558:	c3                   	ret    
  104559:	66 90                	xchg   %ax,%ax
  10455b:	66 90                	xchg   %ax,%ax
  10455d:	66 90                	xchg   %ax,%ax
  10455f:	90                   	nop

00104560 <PKCtxNew_test1>:
	void	*eip;
} kctx;
extern kctx kctx_pool[NUM_IDS];

int PKCtxNew_test1()
{
  104560:	53                   	push   %ebx
  104561:	83 ec 0c             	sub    $0xc,%esp
  void * dummy_addr = (void *) 0;
  unsigned int chid = kctx_new(dummy_addr, 0, 1000);
  104564:	68 e8 03 00 00       	push   $0x3e8
  104569:	6a 00                	push   $0x0
  10456b:	6a 00                	push   $0x0
  10456d:	e8 ae ff ff ff       	call   104520 <kctx_new>
  if (container_get_quota(chid) != 1000) {
  104572:	89 04 24             	mov    %eax,(%esp)
extern kctx kctx_pool[NUM_IDS];

int PKCtxNew_test1()
{
  void * dummy_addr = (void *) 0;
  unsigned int chid = kctx_new(dummy_addr, 0, 1000);
  104575:	89 c3                	mov    %eax,%ebx
  if (container_get_quota(chid) != 1000) {
  104577:	e8 84 ef ff ff       	call   103500 <container_get_quota>
  10457c:	83 c4 10             	add    $0x10,%esp
  10457f:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  104584:	75 0e                	jne    104594 <PKCtxNew_test1+0x34>
    dprintf("test 1 failed.\n");
    return 1;
  }

  if (kctx_pool[chid].eip != dummy_addr) {
  104586:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
  104589:	8b 04 c5 14 c0 de 01 	mov    0x1dec014(,%eax,8),%eax
  104590:	85 c0                	test   %eax,%eax
  104592:	74 1c                	je     1045b0 <PKCtxNew_test1+0x50>
int PKCtxNew_test1()
{
  void * dummy_addr = (void *) 0;
  unsigned int chid = kctx_new(dummy_addr, 0, 1000);
  if (container_get_quota(chid) != 1000) {
    dprintf("test 1 failed.\n");
  104594:	83 ec 0c             	sub    $0xc,%esp
  104597:	68 f1 62 10 00       	push   $0x1062f1
  10459c:	e8 6a d8 ff ff       	call   101e0b <dprintf>
    return 1;
  1045a1:	83 c4 10             	add    $0x10,%esp
  1045a4:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  1045a9:	83 c4 08             	add    $0x8,%esp
  1045ac:	5b                   	pop    %ebx
  1045ad:	c3                   	ret    
  1045ae:	66 90                	xchg   %ax,%ax

  if (kctx_pool[chid].eip != dummy_addr) {
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  1045b0:	83 ec 0c             	sub    $0xc,%esp
  1045b3:	68 01 63 10 00       	push   $0x106301
  1045b8:	e8 4e d8 ff ff       	call   101e0b <dprintf>
  return 0;
  1045bd:	83 c4 10             	add    $0x10,%esp
  1045c0:	31 c0                	xor    %eax,%eax
}
  1045c2:	83 c4 08             	add    $0x8,%esp
  1045c5:	5b                   	pop    %ebx
  1045c6:	c3                   	ret    
  1045c7:	89 f6                	mov    %esi,%esi
  1045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001045d0 <PKCtxNew_test_own>:
int PKCtxNew_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  1045d0:	31 c0                	xor    %eax,%eax
  1045d2:	c3                   	ret    
  1045d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001045e0 <test_PKCtxNew>:

int test_PKCtxNew()
{
  return PKCtxNew_test1() + PKCtxNew_test_own();
  1045e0:	e9 7b ff ff ff       	jmp    104560 <PKCtxNew_test1>
  1045e5:	66 90                	xchg   %ax,%ax
  1045e7:	66 90                	xchg   %ax,%ax
  1045e9:	66 90                	xchg   %ax,%ax
  1045eb:	66 90                	xchg   %ax,%ax
  1045ed:	66 90                	xchg   %ax,%ax
  1045ef:	90                   	nop

001045f0 <tcb_get_state>:

struct TCB TCBPool[NUM_IDS];


unsigned int tcb_get_state(unsigned int pid)
{
  1045f0:	8b 44 24 04          	mov    0x4(%esp),%eax
	return TCBPool[pid].state;
  1045f4:	8d 04 40             	lea    (%eax,%eax,2),%eax
  1045f7:	8b 04 85 00 c6 de 01 	mov    0x1dec600(,%eax,4),%eax
}
  1045fe:	c3                   	ret    
  1045ff:	90                   	nop

00104600 <tcb_set_state>:

void tcb_set_state(unsigned int pid, unsigned int state)
{
  104600:	8b 44 24 04          	mov    0x4(%esp),%eax
	TCBPool[pid].state = state;
  104604:	8b 54 24 08          	mov    0x8(%esp),%edx
  104608:	8d 04 40             	lea    (%eax,%eax,2),%eax
  10460b:	89 14 85 00 c6 de 01 	mov    %edx,0x1dec600(,%eax,4)
  104612:	c3                   	ret    
  104613:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104620 <tcb_get_prev>:
}

unsigned int tcb_get_prev(unsigned int pid)
{
  104620:	8b 44 24 04          	mov    0x4(%esp),%eax
	return TCBPool[pid].prev;
  104624:	8d 04 40             	lea    (%eax,%eax,2),%eax
  104627:	8b 04 85 04 c6 de 01 	mov    0x1dec604(,%eax,4),%eax
}
  10462e:	c3                   	ret    
  10462f:	90                   	nop

00104630 <tcb_set_prev>:

void tcb_set_prev(unsigned int pid, unsigned int prev_pid)
{
  104630:	8b 44 24 04          	mov    0x4(%esp),%eax
	TCBPool[pid].prev = prev_pid;
  104634:	8b 54 24 08          	mov    0x8(%esp),%edx
  104638:	8d 04 40             	lea    (%eax,%eax,2),%eax
  10463b:	89 14 85 04 c6 de 01 	mov    %edx,0x1dec604(,%eax,4)
  104642:	c3                   	ret    
  104643:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104650 <tcb_get_next>:
}

unsigned int tcb_get_next(unsigned int pid)
{
  104650:	8b 44 24 04          	mov    0x4(%esp),%eax
	return TCBPool[pid].next;
  104654:	8d 04 40             	lea    (%eax,%eax,2),%eax
  104657:	8b 04 85 08 c6 de 01 	mov    0x1dec608(,%eax,4),%eax
}
  10465e:	c3                   	ret    
  10465f:	90                   	nop

00104660 <tcb_set_next>:

void tcb_set_next(unsigned int pid, unsigned int next_pid)
{
  104660:	8b 44 24 04          	mov    0x4(%esp),%eax
	TCBPool[pid].next = next_pid;
  104664:	8b 54 24 08          	mov    0x8(%esp),%edx
  104668:	8d 04 40             	lea    (%eax,%eax,2),%eax
  10466b:	89 14 85 08 c6 de 01 	mov    %edx,0x1dec608(,%eax,4)
  104672:	c3                   	ret    
  104673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104680 <tcb_init_at_id>:
}

void tcb_init_at_id(unsigned int pid)
{
  104680:	8b 44 24 04          	mov    0x4(%esp),%eax
	TCBPool[pid].state = TSTATE_DEAD;
  104684:	8d 04 40             	lea    (%eax,%eax,2),%eax
  104687:	c1 e0 02             	shl    $0x2,%eax
  10468a:	c7 80 00 c6 de 01 03 	movl   $0x3,0x1dec600(%eax)
  104691:	00 00 00 
	TCBPool[pid].prev = NUM_IDS;
  104694:	c7 80 04 c6 de 01 40 	movl   $0x40,0x1dec604(%eax)
  10469b:	00 00 00 
	TCBPool[pid].next = NUM_IDS;
  10469e:	c7 80 08 c6 de 01 40 	movl   $0x40,0x1dec608(%eax)
  1046a5:	00 00 00 
  1046a8:	c3                   	ret    
  1046a9:	66 90                	xchg   %ax,%ax
  1046ab:	66 90                	xchg   %ax,%ax
  1046ad:	66 90                	xchg   %ax,%ax
  1046af:	90                   	nop

001046b0 <tcb_init>:
  * 
  *  Hint 1:
  *  - Use function tcb_init_at_id, defined in PTCBIntro.c
  */
void tcb_init(void)
{
  1046b0:	53                   	push   %ebx
    int pid = 0;
    for(pid = 0; pid < NUM_IDS; pid++){
  1046b1:	31 db                	xor    %ebx,%ebx
  * 
  *  Hint 1:
  *  - Use function tcb_init_at_id, defined in PTCBIntro.c
  */
void tcb_init(void)
{
  1046b3:	83 ec 08             	sub    $0x8,%esp
  1046b6:	8d 76 00             	lea    0x0(%esi),%esi
  1046b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    int pid = 0;
    for(pid = 0; pid < NUM_IDS; pid++){
        tcb_init_at_id(pid);
  1046c0:	83 ec 0c             	sub    $0xc,%esp
  1046c3:	53                   	push   %ebx
  *  - Use function tcb_init_at_id, defined in PTCBIntro.c
  */
void tcb_init(void)
{
    int pid = 0;
    for(pid = 0; pid < NUM_IDS; pid++){
  1046c4:	83 c3 01             	add    $0x1,%ebx
        tcb_init_at_id(pid);
  1046c7:	e8 b4 ff ff ff       	call   104680 <tcb_init_at_id>
  *  - Use function tcb_init_at_id, defined in PTCBIntro.c
  */
void tcb_init(void)
{
    int pid = 0;
    for(pid = 0; pid < NUM_IDS; pid++){
  1046cc:	83 c4 10             	add    $0x10,%esp
  1046cf:	83 fb 40             	cmp    $0x40,%ebx
  1046d2:	75 ec                	jne    1046c0 <tcb_init+0x10>
        tcb_init_at_id(pid);
    }
}
  1046d4:	83 c4 08             	add    $0x8,%esp
  1046d7:	5b                   	pop    %ebx
  1046d8:	c3                   	ret    
  1046d9:	66 90                	xchg   %ax,%ax
  1046db:	66 90                	xchg   %ax,%ax
  1046dd:	66 90                	xchg   %ax,%ax
  1046df:	90                   	nop

001046e0 <PTCBInit_test1>:
#include <lib/thread.h>
#include <thread/PTCBIntro/export.h>
#include "export.h"

int PTCBInit_test1()
{
  1046e0:	53                   	push   %ebx
  unsigned int i;
  for (i = 1; i < NUM_IDS; i ++) {
  1046e1:	bb 01 00 00 00       	mov    $0x1,%ebx
#include <lib/thread.h>
#include <thread/PTCBIntro/export.h>
#include "export.h"

int PTCBInit_test1()
{
  1046e6:	83 ec 08             	sub    $0x8,%esp
  1046e9:	eb 2f                	jmp    10471a <PTCBInit_test1+0x3a>
  1046eb:	90                   	nop
  1046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  unsigned int i;
  for (i = 1; i < NUM_IDS; i ++) {
    if (tcb_get_state(i) != TSTATE_DEAD || tcb_get_prev(i) != NUM_IDS || tcb_get_next(i) != NUM_IDS) {
  1046f0:	83 ec 0c             	sub    $0xc,%esp
  1046f3:	53                   	push   %ebx
  1046f4:	e8 27 ff ff ff       	call   104620 <tcb_get_prev>
  1046f9:	83 c4 10             	add    $0x10,%esp
  1046fc:	83 f8 40             	cmp    $0x40,%eax
  1046ff:	75 2a                	jne    10472b <PTCBInit_test1+0x4b>
  104701:	83 ec 0c             	sub    $0xc,%esp
  104704:	53                   	push   %ebx
  104705:	e8 46 ff ff ff       	call   104650 <tcb_get_next>
  10470a:	83 c4 10             	add    $0x10,%esp
  10470d:	83 f8 40             	cmp    $0x40,%eax
  104710:	75 19                	jne    10472b <PTCBInit_test1+0x4b>
#include "export.h"

int PTCBInit_test1()
{
  unsigned int i;
  for (i = 1; i < NUM_IDS; i ++) {
  104712:	83 c3 01             	add    $0x1,%ebx
  104715:	83 fb 40             	cmp    $0x40,%ebx
  104718:	74 2e                	je     104748 <PTCBInit_test1+0x68>
    if (tcb_get_state(i) != TSTATE_DEAD || tcb_get_prev(i) != NUM_IDS || tcb_get_next(i) != NUM_IDS) {
  10471a:	83 ec 0c             	sub    $0xc,%esp
  10471d:	53                   	push   %ebx
  10471e:	e8 cd fe ff ff       	call   1045f0 <tcb_get_state>
  104723:	83 c4 10             	add    $0x10,%esp
  104726:	83 f8 03             	cmp    $0x3,%eax
  104729:	74 c5                	je     1046f0 <PTCBInit_test1+0x10>
      dprintf("test 1 failed.\n");
  10472b:	83 ec 0c             	sub    $0xc,%esp
  10472e:	68 f1 62 10 00       	push   $0x1062f1
  104733:	e8 d3 d6 ff ff       	call   101e0b <dprintf>
      return 1;
  104738:	83 c4 10             	add    $0x10,%esp
  10473b:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  104740:	83 c4 08             	add    $0x8,%esp
  104743:	5b                   	pop    %ebx
  104744:	c3                   	ret    
  104745:	8d 76 00             	lea    0x0(%esi),%esi
    if (tcb_get_state(i) != TSTATE_DEAD || tcb_get_prev(i) != NUM_IDS || tcb_get_next(i) != NUM_IDS) {
      dprintf("test 1 failed.\n");
      return 1;
    }
  }
  dprintf("test 1 passed.\n");
  104748:	83 ec 0c             	sub    $0xc,%esp
  10474b:	68 01 63 10 00       	push   $0x106301
  104750:	e8 b6 d6 ff ff       	call   101e0b <dprintf>
  return 0;
  104755:	83 c4 10             	add    $0x10,%esp
  104758:	31 c0                	xor    %eax,%eax
}
  10475a:	83 c4 08             	add    $0x8,%esp
  10475d:	5b                   	pop    %ebx
  10475e:	c3                   	ret    
  10475f:	90                   	nop

00104760 <PTCBInit_test_own>:
int PTCBInit_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  104760:	31 c0                	xor    %eax,%eax
  104762:	c3                   	ret    
  104763:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104770 <test_PTCBInit>:

int test_PTCBInit()
{
  return PTCBInit_test1() + PTCBInit_test_own();
  104770:	e9 6b ff ff ff       	jmp    1046e0 <PTCBInit_test1>
  104775:	66 90                	xchg   %ax,%ax
  104777:	66 90                	xchg   %ax,%ax
  104779:	66 90                	xchg   %ax,%ax
  10477b:	66 90                	xchg   %ax,%ax
  10477d:	66 90                	xchg   %ax,%ax
  10477f:	90                   	nop

00104780 <tqueue_get_head>:
 */
struct TQueue TQueuePool[NUM_IDS + 1];

unsigned int tqueue_get_head(unsigned int chid)
{
	return TQueuePool[chid].head;
  104780:	8b 44 24 04          	mov    0x4(%esp),%eax
  104784:	8b 04 c5 00 c9 de 01 	mov    0x1dec900(,%eax,8),%eax
}
  10478b:	c3                   	ret    
  10478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104790 <tqueue_set_head>:

void tqueue_set_head(unsigned int chid, unsigned int head)
{
	TQueuePool[chid].head = head;
  104790:	8b 54 24 08          	mov    0x8(%esp),%edx
  104794:	8b 44 24 04          	mov    0x4(%esp),%eax
  104798:	89 14 c5 00 c9 de 01 	mov    %edx,0x1dec900(,%eax,8)
  10479f:	c3                   	ret    

001047a0 <tqueue_get_tail>:
}

unsigned int tqueue_get_tail(unsigned int chid)
{
	return TQueuePool[chid].tail;
  1047a0:	8b 44 24 04          	mov    0x4(%esp),%eax
  1047a4:	8b 04 c5 04 c9 de 01 	mov    0x1dec904(,%eax,8),%eax
}
  1047ab:	c3                   	ret    
  1047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001047b0 <tqueue_set_tail>:

void tqueue_set_tail(unsigned int chid, unsigned int tail)
{
	TQueuePool[chid].tail = tail;
  1047b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  1047b4:	8b 44 24 04          	mov    0x4(%esp),%eax
  1047b8:	89 14 c5 04 c9 de 01 	mov    %edx,0x1dec904(,%eax,8)
  1047bf:	c3                   	ret    

001047c0 <tqueue_init_at_id>:
}

void tqueue_init_at_id(unsigned int chid)
{
  1047c0:	8b 44 24 04          	mov    0x4(%esp),%eax
	TQueuePool[chid].head = NUM_IDS;
  1047c4:	c7 04 c5 00 c9 de 01 	movl   $0x40,0x1dec900(,%eax,8)
  1047cb:	40 00 00 00 
	TQueuePool[chid].tail = NUM_IDS;
  1047cf:	c7 04 c5 04 c9 de 01 	movl   $0x40,0x1dec904(,%eax,8)
  1047d6:	40 00 00 00 
  1047da:	c3                   	ret    
  1047db:	66 90                	xchg   %ax,%ax
  1047dd:	66 90                	xchg   %ax,%ax
  1047df:	90                   	nop

001047e0 <tqueue_init>:
  *  Hint 1:
  *  - Remember that there are NUM_IDS + 1 queues. The first NUM_IDS queues are the sleep queues and
  *    the last queue with id NUM_IDS is the ready queue.
  */
void tqueue_init(void)
{
  1047e0:	53                   	push   %ebx

    int pid = 0;
	tcb_init();
	for(pid = 0; pid < NUM_IDS + 1; pid++){
  1047e1:	31 db                	xor    %ebx,%ebx
  *  Hint 1:
  *  - Remember that there are NUM_IDS + 1 queues. The first NUM_IDS queues are the sleep queues and
  *    the last queue with id NUM_IDS is the ready queue.
  */
void tqueue_init(void)
{
  1047e3:	83 ec 08             	sub    $0x8,%esp

    int pid = 0;
	tcb_init();
  1047e6:	e8 c5 fe ff ff       	call   1046b0 <tcb_init>
  1047eb:	90                   	nop
  1047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for(pid = 0; pid < NUM_IDS + 1; pid++){
	    tqueue_init_at_id(pid);
  1047f0:	83 ec 0c             	sub    $0xc,%esp
  1047f3:	53                   	push   %ebx
void tqueue_init(void)
{

    int pid = 0;
	tcb_init();
	for(pid = 0; pid < NUM_IDS + 1; pid++){
  1047f4:	83 c3 01             	add    $0x1,%ebx
	    tqueue_init_at_id(pid);
  1047f7:	e8 c4 ff ff ff       	call   1047c0 <tqueue_init_at_id>
void tqueue_init(void)
{

    int pid = 0;
	tcb_init();
	for(pid = 0; pid < NUM_IDS + 1; pid++){
  1047fc:	83 c4 10             	add    $0x10,%esp
  1047ff:	83 fb 41             	cmp    $0x41,%ebx
  104802:	75 ec                	jne    1047f0 <tqueue_init+0x10>
	    tqueue_init_at_id(pid);
	}

}
  104804:	83 c4 08             	add    $0x8,%esp
  104807:	5b                   	pop    %ebx
  104808:	c3                   	ret    
  104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104810 <tqueue_enqueue>:
  *    1. update the next pointer in the old tail to point to #pid.
  *    2. then the prev pointer for #pid should point to the old tail.
  *    3. and the next pointer for #pid should point to NULL (i.e. NUM_IDS)
  */
void tqueue_enqueue(unsigned int chid, unsigned int pid)
{
  104810:	57                   	push   %edi
  104811:	56                   	push   %esi
  104812:	53                   	push   %ebx
  104813:	8b 7c 24 10          	mov    0x10(%esp),%edi
  104817:	8b 5c 24 14          	mov    0x14(%esp),%ebx
    int tail_index = tqueue_get_tail(chid);
  10481b:	83 ec 0c             	sub    $0xc,%esp
  10481e:	57                   	push   %edi
  10481f:	e8 7c ff ff ff       	call   1047a0 <tqueue_get_tail>

    if(tail_index == NUM_IDS){
  104824:	83 c4 10             	add    $0x10,%esp
  104827:	83 f8 40             	cmp    $0x40,%eax
  10482a:	74 3c                	je     104868 <tqueue_enqueue+0x58>
        tqueue_set_head(chid, pid);
        tqueue_set_tail(chid, pid);
    }
    else{
        tqueue_set_tail(chid, pid);
  10482c:	83 ec 08             	sub    $0x8,%esp
  10482f:	89 c6                	mov    %eax,%esi
  104831:	53                   	push   %ebx
  104832:	57                   	push   %edi
  104833:	e8 78 ff ff ff       	call   1047b0 <tqueue_set_tail>
        tcb_set_next(tail_index, pid);
  104838:	58                   	pop    %eax
  104839:	5a                   	pop    %edx
  10483a:	53                   	push   %ebx
  10483b:	56                   	push   %esi
  10483c:	e8 1f fe ff ff       	call   104660 <tcb_set_next>
        tcb_set_prev(pid, tail_index);
  104841:	59                   	pop    %ecx
  104842:	5f                   	pop    %edi
  104843:	56                   	push   %esi
  104844:	53                   	push   %ebx
  104845:	e8 e6 fd ff ff       	call   104630 <tcb_set_prev>
        tcb_set_next(pid, NUM_IDS);
  10484a:	83 c4 10             	add    $0x10,%esp
  10484d:	c7 44 24 14 40 00 00 	movl   $0x40,0x14(%esp)
  104854:	00 
  104855:	89 5c 24 10          	mov    %ebx,0x10(%esp)
    }
}
  104859:	5b                   	pop    %ebx
  10485a:	5e                   	pop    %esi
  10485b:	5f                   	pop    %edi
    }
    else{
        tqueue_set_tail(chid, pid);
        tcb_set_next(tail_index, pid);
        tcb_set_prev(pid, tail_index);
        tcb_set_next(pid, NUM_IDS);
  10485c:	e9 ff fd ff ff       	jmp    104660 <tcb_set_next>
  104861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void tqueue_enqueue(unsigned int chid, unsigned int pid)
{
    int tail_index = tqueue_get_tail(chid);

    if(tail_index == NUM_IDS){
        tqueue_set_head(chid, pid);
  104868:	83 ec 08             	sub    $0x8,%esp
  10486b:	53                   	push   %ebx
  10486c:	57                   	push   %edi
  10486d:	e8 1e ff ff ff       	call   104790 <tqueue_set_head>
        tqueue_set_tail(chid, pid);
  104872:	83 c4 10             	add    $0x10,%esp
  104875:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  104879:	89 7c 24 10          	mov    %edi,0x10(%esp)
        tqueue_set_tail(chid, pid);
        tcb_set_next(tail_index, pid);
        tcb_set_prev(pid, tail_index);
        tcb_set_next(pid, NUM_IDS);
    }
}
  10487d:	5b                   	pop    %ebx
  10487e:	5e                   	pop    %esi
  10487f:	5f                   	pop    %edi
{
    int tail_index = tqueue_get_tail(chid);

    if(tail_index == NUM_IDS){
        tqueue_set_head(chid, pid);
        tqueue_set_tail(chid, pid);
  104880:	e9 2b ff ff ff       	jmp    1047b0 <tqueue_set_tail>
  104885:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104890 <tqueue_dequeue>:
  *  - b) Else, set prev pointer of the new head to NUM_IDS.
  *  Hint 3: Detach the popped head from other threads.
  *  - Reset the poped head's prev and next pointers to NUM_IDS.
  */
unsigned int tqueue_dequeue(unsigned int chid)
{
  104890:	57                   	push   %edi
  104891:	56                   	push   %esi
  104892:	53                   	push   %ebx
  104893:	8b 74 24 10          	mov    0x10(%esp),%esi
  int head_index = tqueue_get_head(chid);
  104897:	83 ec 0c             	sub    $0xc,%esp
  10489a:	56                   	push   %esi
  10489b:	e8 e0 fe ff ff       	call   104780 <tqueue_get_head>
  if(head_index == NUM_IDS){
  1048a0:	83 c4 10             	add    $0x10,%esp
  1048a3:	83 f8 40             	cmp    $0x40,%eax
  *  Hint 3: Detach the popped head from other threads.
  *  - Reset the poped head's prev and next pointers to NUM_IDS.
  */
unsigned int tqueue_dequeue(unsigned int chid)
{
  int head_index = tqueue_get_head(chid);
  1048a6:	89 c3                	mov    %eax,%ebx
  if(head_index == NUM_IDS){
  1048a8:	74 3e                	je     1048e8 <tqueue_dequeue+0x58>
      tqueue_set_head(chid, NUM_IDS);
      tqueue_set_tail(chid, NUM_IDS);
  }
  else{
      int new_head_index = tcb_get_next(head_index);
  1048aa:	83 ec 0c             	sub    $0xc,%esp
  1048ad:	50                   	push   %eax
  1048ae:	e8 9d fd ff ff       	call   104650 <tcb_get_next>
  1048b3:	89 c7                	mov    %eax,%edi
      tqueue_set_head(chid, new_head_index);
  1048b5:	58                   	pop    %eax
  1048b6:	5a                   	pop    %edx
  1048b7:	57                   	push   %edi
  1048b8:	56                   	push   %esi
  1048b9:	e8 d2 fe ff ff       	call   104790 <tqueue_set_head>
      tcb_set_prev(new_head_index, NUM_IDS);
  1048be:	59                   	pop    %ecx
  1048bf:	5e                   	pop    %esi
  1048c0:	6a 40                	push   $0x40
  1048c2:	57                   	push   %edi
  1048c3:	e8 68 fd ff ff       	call   104630 <tcb_set_prev>
      //tcb_set_next(new_head_index, NUM_IDS);

      tcb_set_prev(head_index, NUM_IDS);
  1048c8:	5f                   	pop    %edi
  1048c9:	58                   	pop    %eax
  1048ca:	6a 40                	push   $0x40
  1048cc:	53                   	push   %ebx
  1048cd:	e8 5e fd ff ff       	call   104630 <tcb_set_prev>
      tcb_set_next(head_index, NUM_IDS);
  1048d2:	58                   	pop    %eax
  1048d3:	5a                   	pop    %edx
  1048d4:	6a 40                	push   $0x40
  1048d6:	53                   	push   %ebx
  1048d7:	e8 84 fd ff ff       	call   104660 <tcb_set_next>
  1048dc:	83 c4 10             	add    $0x10,%esp
  }
  return head_index;
}
  1048df:	89 d8                	mov    %ebx,%eax
  1048e1:	5b                   	pop    %ebx
  1048e2:	5e                   	pop    %esi
  1048e3:	5f                   	pop    %edi
  1048e4:	c3                   	ret    
  1048e5:	8d 76 00             	lea    0x0(%esi),%esi
  */
unsigned int tqueue_dequeue(unsigned int chid)
{
  int head_index = tqueue_get_head(chid);
  if(head_index == NUM_IDS){
      tqueue_set_head(chid, NUM_IDS);
  1048e8:	83 ec 08             	sub    $0x8,%esp
  1048eb:	6a 40                	push   $0x40
  1048ed:	56                   	push   %esi
  1048ee:	e8 9d fe ff ff       	call   104790 <tqueue_set_head>
      tqueue_set_tail(chid, NUM_IDS);
  1048f3:	59                   	pop    %ecx
  1048f4:	5f                   	pop    %edi
  1048f5:	6a 40                	push   $0x40
  1048f7:	56                   	push   %esi
  1048f8:	e8 b3 fe ff ff       	call   1047b0 <tqueue_set_tail>
  1048fd:	83 c4 10             	add    $0x10,%esp

      tcb_set_prev(head_index, NUM_IDS);
      tcb_set_next(head_index, NUM_IDS);
  }
  return head_index;
}
  104900:	89 d8                	mov    %ebx,%eax
  104902:	5b                   	pop    %ebx
  104903:	5e                   	pop    %esi
  104904:	5f                   	pop    %edi
  104905:	c3                   	ret    
  104906:	8d 76 00             	lea    0x0(%esi),%esi
  104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104910 <tqueue_remove>:
  *  - c) If #pid is the tail of the queue, set it's prev thread as the tail of the queue.
  *       Remember to update the new tail's TCB pointers. (Where does the tail's next pointer point to?)
  *  Hint 2: Detach the removed #pid's TCB from other threads. (Same as TASK 3)
  */
void tqueue_remove(unsigned int chid, unsigned int pid)
{
  104910:	55                   	push   %ebp
  104911:	57                   	push   %edi
  104912:	56                   	push   %esi
  104913:	53                   	push   %ebx
  104914:	83 ec 28             	sub    $0x28,%esp
  104917:	8b 5c 24 40          	mov    0x40(%esp),%ebx
  10491b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
    int next_index_pid = tcb_get_next(pid);
  10491f:	53                   	push   %ebx
  104920:	e8 2b fd ff ff       	call   104650 <tcb_get_next>
  104925:	89 c5                	mov    %eax,%ebp
    int prev_index_pid = tcb_get_prev(pid);
  104927:	89 1c 24             	mov    %ebx,(%esp)
  10492a:	e8 f1 fc ff ff       	call   104620 <tcb_get_prev>
    int head_index = tqueue_get_head(chid);
  10492f:	89 34 24             	mov    %esi,(%esp)
  *  Hint 2: Detach the removed #pid's TCB from other threads. (Same as TASK 3)
  */
void tqueue_remove(unsigned int chid, unsigned int pid)
{
    int next_index_pid = tcb_get_next(pid);
    int prev_index_pid = tcb_get_prev(pid);
  104932:	89 c7                	mov    %eax,%edi
    int head_index = tqueue_get_head(chid);
  104934:	e8 47 fe ff ff       	call   104780 <tqueue_get_head>
    int tail_index = tqueue_get_tail(chid);
  104939:	89 34 24             	mov    %esi,(%esp)
  */
void tqueue_remove(unsigned int chid, unsigned int pid)
{
    int next_index_pid = tcb_get_next(pid);
    int prev_index_pid = tcb_get_prev(pid);
    int head_index = tqueue_get_head(chid);
  10493c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    int tail_index = tqueue_get_tail(chid);
  104940:	e8 5b fe ff ff       	call   1047a0 <tqueue_get_tail>
    if(next_index_pid == NUM_IDS && prev_index_pid == NUM_IDS){
  104945:	83 c4 10             	add    $0x10,%esp
  104948:	83 fd 40             	cmp    $0x40,%ebp
  10494b:	75 05                	jne    104952 <tqueue_remove+0x42>
  10494d:	83 ff 40             	cmp    $0x40,%edi
  104950:	74 3e                	je     104990 <tqueue_remove+0x80>
        tqueue_set_head(chid, NUM_IDS);
        tqueue_set_tail(chid, NUM_IDS);
    }
    else if(next_index_pid != NUM_IDS && prev_index_pid != NUM_IDS){
  104952:	83 fd 40             	cmp    $0x40,%ebp
  104955:	74 05                	je     10495c <tqueue_remove+0x4c>
  104957:	83 ff 40             	cmp    $0x40,%edi
  10495a:	75 54                	jne    1049b0 <tqueue_remove+0xa0>
        tcb_set_next(prev_index_pid, next_index_pid);
        tcb_set_next(pid, next_index_pid);
        tcb_set_prev(next_index_pid, prev_index_pid);
        tcb_set_prev(pid, prev_index_pid);
    }
    else if(head_index == pid){
  10495c:	3b 5c 24 0c          	cmp    0xc(%esp),%ebx
  104960:	0f 84 aa 00 00 00    	je     104a10 <tqueue_remove+0x100>
        tqueue_set_head(chid, next_index_pid);
        tcb_set_next(next_index_pid, NUM_IDS);
        tcb_set_prev(prev_index_pid, NUM_IDS);
    }
    else if(tail_index == pid){
  104966:	39 c3                	cmp    %eax,%ebx
  104968:	74 76                	je     1049e0 <tqueue_remove+0xd0>
        tcb_set_prev(chid, NUM_IDS);

    }


    tcb_set_next(pid, NUM_IDS);
  10496a:	83 ec 08             	sub    $0x8,%esp
  10496d:	6a 40                	push   $0x40
  10496f:	53                   	push   %ebx
  104970:	e8 eb fc ff ff       	call   104660 <tcb_set_next>
    tcb_set_prev(pid, NUM_IDS);
  104975:	89 5c 24 40          	mov    %ebx,0x40(%esp)
  104979:	c7 44 24 44 40 00 00 	movl   $0x40,0x44(%esp)
  104980:	00 


}
  104981:	83 c4 2c             	add    $0x2c,%esp
  104984:	5b                   	pop    %ebx
  104985:	5e                   	pop    %esi
  104986:	5f                   	pop    %edi
  104987:	5d                   	pop    %ebp

    }


    tcb_set_next(pid, NUM_IDS);
    tcb_set_prev(pid, NUM_IDS);
  104988:	e9 a3 fc ff ff       	jmp    104630 <tcb_set_prev>
  10498d:	8d 76 00             	lea    0x0(%esi),%esi
    int next_index_pid = tcb_get_next(pid);
    int prev_index_pid = tcb_get_prev(pid);
    int head_index = tqueue_get_head(chid);
    int tail_index = tqueue_get_tail(chid);
    if(next_index_pid == NUM_IDS && prev_index_pid == NUM_IDS){
        tqueue_set_head(chid, NUM_IDS);
  104990:	83 ec 08             	sub    $0x8,%esp
  104993:	6a 40                	push   $0x40
  104995:	56                   	push   %esi
  104996:	e8 f5 fd ff ff       	call   104790 <tqueue_set_head>
        tqueue_set_tail(chid, NUM_IDS);
  10499b:	58                   	pop    %eax
  10499c:	5a                   	pop    %edx
  10499d:	6a 40                	push   $0x40
  10499f:	56                   	push   %esi
  1049a0:	e8 0b fe ff ff       	call   1047b0 <tqueue_set_tail>
  1049a5:	83 c4 10             	add    $0x10,%esp
  1049a8:	eb c0                	jmp    10496a <tqueue_remove+0x5a>
  1049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
    else if(next_index_pid != NUM_IDS && prev_index_pid != NUM_IDS){
        tcb_set_next(prev_index_pid, next_index_pid);
  1049b0:	83 ec 08             	sub    $0x8,%esp
  1049b3:	55                   	push   %ebp
  1049b4:	57                   	push   %edi
  1049b5:	e8 a6 fc ff ff       	call   104660 <tcb_set_next>
        tcb_set_next(pid, next_index_pid);
  1049ba:	58                   	pop    %eax
  1049bb:	5a                   	pop    %edx
  1049bc:	55                   	push   %ebp
  1049bd:	53                   	push   %ebx
  1049be:	e8 9d fc ff ff       	call   104660 <tcb_set_next>
        tcb_set_prev(next_index_pid, prev_index_pid);
  1049c3:	59                   	pop    %ecx
  1049c4:	5e                   	pop    %esi
  1049c5:	57                   	push   %edi
  1049c6:	55                   	push   %ebp
  1049c7:	e8 64 fc ff ff       	call   104630 <tcb_set_prev>
        tcb_set_prev(pid, prev_index_pid);
  1049cc:	5d                   	pop    %ebp
  1049cd:	58                   	pop    %eax
  1049ce:	57                   	push   %edi
  1049cf:	53                   	push   %ebx
  1049d0:	e8 5b fc ff ff       	call   104630 <tcb_set_prev>
  1049d5:	83 c4 10             	add    $0x10,%esp
  1049d8:	eb 90                	jmp    10496a <tqueue_remove+0x5a>
  1049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        tqueue_set_head(chid, next_index_pid);
        tcb_set_next(next_index_pid, NUM_IDS);
        tcb_set_prev(prev_index_pid, NUM_IDS);
    }
    else if(tail_index == pid){
        tqueue_set_tail(chid, prev_index_pid);
  1049e0:	83 ec 08             	sub    $0x8,%esp
  1049e3:	57                   	push   %edi
  1049e4:	56                   	push   %esi
  1049e5:	e8 c6 fd ff ff       	call   1047b0 <tqueue_set_tail>
        tcb_set_next(chid, NUM_IDS);
  1049ea:	58                   	pop    %eax
  1049eb:	5a                   	pop    %edx
  1049ec:	6a 40                	push   $0x40
  1049ee:	56                   	push   %esi
  1049ef:	e8 6c fc ff ff       	call   104660 <tcb_set_next>
        tcb_set_prev(chid, NUM_IDS);
  1049f4:	59                   	pop    %ecx
  1049f5:	5f                   	pop    %edi
  1049f6:	6a 40                	push   $0x40
  1049f8:	56                   	push   %esi
  1049f9:	e8 32 fc ff ff       	call   104630 <tcb_set_prev>
  1049fe:	83 c4 10             	add    $0x10,%esp
  104a01:	e9 64 ff ff ff       	jmp    10496a <tqueue_remove+0x5a>
  104a06:	8d 76 00             	lea    0x0(%esi),%esi
  104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        tcb_set_next(pid, next_index_pid);
        tcb_set_prev(next_index_pid, prev_index_pid);
        tcb_set_prev(pid, prev_index_pid);
    }
    else if(head_index == pid){
        tqueue_set_head(chid, next_index_pid);
  104a10:	83 ec 08             	sub    $0x8,%esp
  104a13:	55                   	push   %ebp
  104a14:	56                   	push   %esi
  104a15:	e8 76 fd ff ff       	call   104790 <tqueue_set_head>
        tcb_set_next(next_index_pid, NUM_IDS);
  104a1a:	58                   	pop    %eax
  104a1b:	5a                   	pop    %edx
  104a1c:	6a 40                	push   $0x40
  104a1e:	55                   	push   %ebp
  104a1f:	e8 3c fc ff ff       	call   104660 <tcb_set_next>
        tcb_set_prev(prev_index_pid, NUM_IDS);
  104a24:	59                   	pop    %ecx
  104a25:	5e                   	pop    %esi
  104a26:	6a 40                	push   $0x40
  104a28:	57                   	push   %edi
  104a29:	e8 02 fc ff ff       	call   104630 <tcb_set_prev>
  104a2e:	83 c4 10             	add    $0x10,%esp
  104a31:	e9 34 ff ff ff       	jmp    10496a <tqueue_remove+0x5a>
  104a36:	66 90                	xchg   %ax,%ax
  104a38:	66 90                	xchg   %ax,%ax
  104a3a:	66 90                	xchg   %ax,%ax
  104a3c:	66 90                	xchg   %ax,%ax
  104a3e:	66 90                	xchg   %ax,%ax

00104a40 <PTQueueInit_test1>:
#include <thread/PTCBIntro/export.h>
#include <thread/PTQueueIntro/export.h>
#include "export.h"

int PTQueueInit_test1()
{
  104a40:	53                   	push   %ebx
  unsigned int i;
  for (i = 0; i < NUM_IDS; i ++) {
  104a41:	31 db                	xor    %ebx,%ebx
#include <thread/PTCBIntro/export.h>
#include <thread/PTQueueIntro/export.h>
#include "export.h"

int PTQueueInit_test1()
{
  104a43:	83 ec 08             	sub    $0x8,%esp
  104a46:	eb 21                	jmp    104a69 <PTQueueInit_test1+0x29>
  104a48:	90                   	nop
  104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  unsigned int i;
  for (i = 0; i < NUM_IDS; i ++) {
    if (tqueue_get_head(i) != NUM_IDS || tqueue_get_tail(i) != NUM_IDS) {
  104a50:	83 ec 0c             	sub    $0xc,%esp
  104a53:	53                   	push   %ebx
  104a54:	e8 47 fd ff ff       	call   1047a0 <tqueue_get_tail>
  104a59:	83 c4 10             	add    $0x10,%esp
  104a5c:	83 f8 40             	cmp    $0x40,%eax
  104a5f:	75 19                	jne    104a7a <PTQueueInit_test1+0x3a>
#include "export.h"

int PTQueueInit_test1()
{
  unsigned int i;
  for (i = 0; i < NUM_IDS; i ++) {
  104a61:	83 c3 01             	add    $0x1,%ebx
  104a64:	83 fb 40             	cmp    $0x40,%ebx
  104a67:	74 2f                	je     104a98 <PTQueueInit_test1+0x58>
    if (tqueue_get_head(i) != NUM_IDS || tqueue_get_tail(i) != NUM_IDS) {
  104a69:	83 ec 0c             	sub    $0xc,%esp
  104a6c:	53                   	push   %ebx
  104a6d:	e8 0e fd ff ff       	call   104780 <tqueue_get_head>
  104a72:	83 c4 10             	add    $0x10,%esp
  104a75:	83 f8 40             	cmp    $0x40,%eax
  104a78:	74 d6                	je     104a50 <PTQueueInit_test1+0x10>
      dprintf("test 1 failed.\n");
  104a7a:	83 ec 0c             	sub    $0xc,%esp
  104a7d:	68 f1 62 10 00       	push   $0x1062f1
  104a82:	e8 84 d3 ff ff       	call   101e0b <dprintf>
      return 1;
  104a87:	83 c4 10             	add    $0x10,%esp
  104a8a:	b8 01 00 00 00       	mov    $0x1,%eax
    }
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  104a8f:	83 c4 08             	add    $0x8,%esp
  104a92:	5b                   	pop    %ebx
  104a93:	c3                   	ret    
  104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (tqueue_get_head(i) != NUM_IDS || tqueue_get_tail(i) != NUM_IDS) {
      dprintf("test 1 failed.\n");
      return 1;
    }
  }
  dprintf("test 1 passed.\n");
  104a98:	83 ec 0c             	sub    $0xc,%esp
  104a9b:	68 01 63 10 00       	push   $0x106301
  104aa0:	e8 66 d3 ff ff       	call   101e0b <dprintf>
  return 0;
  104aa5:	83 c4 10             	add    $0x10,%esp
  104aa8:	31 c0                	xor    %eax,%eax
}
  104aaa:	83 c4 08             	add    $0x8,%esp
  104aad:	5b                   	pop    %ebx
  104aae:	c3                   	ret    
  104aaf:	90                   	nop

00104ab0 <PTQueueInit_test2>:

int PTQueueInit_test2()
{
  104ab0:	53                   	push   %ebx
  104ab1:	83 ec 10             	sub    $0x10,%esp
  unsigned int pid;
  tqueue_enqueue(0, 2);
  104ab4:	6a 02                	push   $0x2
  104ab6:	6a 00                	push   $0x0
  104ab8:	e8 53 fd ff ff       	call   104810 <tqueue_enqueue>
  tqueue_enqueue(0, 3);
  104abd:	5b                   	pop    %ebx
  104abe:	58                   	pop    %eax
  104abf:	6a 03                	push   $0x3
  104ac1:	6a 00                	push   $0x0
  104ac3:	e8 48 fd ff ff       	call   104810 <tqueue_enqueue>
  tqueue_enqueue(0, 4);
  104ac8:	58                   	pop    %eax
  104ac9:	5a                   	pop    %edx
  104aca:	6a 04                	push   $0x4
  104acc:	6a 00                	push   $0x0
  104ace:	e8 3d fd ff ff       	call   104810 <tqueue_enqueue>
  if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 3) {
  104ad3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104ada:	e8 41 fb ff ff       	call   104620 <tcb_get_prev>
  104adf:	83 c4 10             	add    $0x10,%esp
  104ae2:	83 f8 40             	cmp    $0x40,%eax
  104ae5:	74 21                	je     104b08 <PTQueueInit_test2+0x58>
    dprintf("test 2-a failed.\n");
  104ae7:	83 ec 0c             	sub    $0xc,%esp
  104aea:	68 67 64 10 00       	push   $0x106467
  104aef:	e8 17 d3 ff ff       	call   101e0b <dprintf>
    return 1;
  104af4:	83 c4 10             	add    $0x10,%esp
  104af7:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("pid %d\n", tqueue_get_tail(0));
    return 1;
  }
  dprintf("test 2 passed.\n");
  return 0;
}
  104afc:	83 c4 08             	add    $0x8,%esp
  104aff:	5b                   	pop    %ebx
  104b00:	c3                   	ret    
  104b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  unsigned int pid;
  tqueue_enqueue(0, 2);
  tqueue_enqueue(0, 3);
  tqueue_enqueue(0, 4);
  if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 3) {
  104b08:	83 ec 0c             	sub    $0xc,%esp
  104b0b:	6a 02                	push   $0x2
  104b0d:	e8 3e fb ff ff       	call   104650 <tcb_get_next>
  104b12:	83 c4 10             	add    $0x10,%esp
  104b15:	83 f8 03             	cmp    $0x3,%eax
  104b18:	75 cd                	jne    104ae7 <PTQueueInit_test2+0x37>
    dprintf("test 2-a failed.\n");
    return 1;
  }
  if (tcb_get_prev(3) != 2 || tcb_get_next(3) != 4) {
  104b1a:	83 ec 0c             	sub    $0xc,%esp
  104b1d:	6a 03                	push   $0x3
  104b1f:	e8 fc fa ff ff       	call   104620 <tcb_get_prev>
  104b24:	83 c4 10             	add    $0x10,%esp
  104b27:	83 f8 02             	cmp    $0x2,%eax
  104b2a:	74 1c                	je     104b48 <PTQueueInit_test2+0x98>
    dprintf("test 2-b failed.\n");
  104b2c:	83 ec 0c             	sub    $0xc,%esp
  104b2f:	68 79 64 10 00       	push   $0x106479
  104b34:	e8 d2 d2 ff ff       	call   101e0b <dprintf>
    return 1;
  104b39:	83 c4 10             	add    $0x10,%esp
  104b3c:	b8 01 00 00 00       	mov    $0x1,%eax
  104b41:	eb b9                	jmp    104afc <PTQueueInit_test2+0x4c>
  104b43:	90                   	nop
  104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  tqueue_enqueue(0, 4);
  if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 3) {
    dprintf("test 2-a failed.\n");
    return 1;
  }
  if (tcb_get_prev(3) != 2 || tcb_get_next(3) != 4) {
  104b48:	83 ec 0c             	sub    $0xc,%esp
  104b4b:	6a 03                	push   $0x3
  104b4d:	e8 fe fa ff ff       	call   104650 <tcb_get_next>
  104b52:	83 c4 10             	add    $0x10,%esp
  104b55:	83 f8 04             	cmp    $0x4,%eax
  104b58:	75 d2                	jne    104b2c <PTQueueInit_test2+0x7c>
    dprintf("test 2-b failed.\n");
    return 1;
  }
  if (tcb_get_prev(4) != 3 || tcb_get_next(4) != NUM_IDS) {
  104b5a:	83 ec 0c             	sub    $0xc,%esp
  104b5d:	6a 04                	push   $0x4
  104b5f:	e8 bc fa ff ff       	call   104620 <tcb_get_prev>
  104b64:	83 c4 10             	add    $0x10,%esp
  104b67:	83 f8 03             	cmp    $0x3,%eax
  104b6a:	74 1a                	je     104b86 <PTQueueInit_test2+0xd6>
    dprintf("test 2-c failed.\n");
  104b6c:	83 ec 0c             	sub    $0xc,%esp
  104b6f:	68 8b 64 10 00       	push   $0x10648b
  104b74:	e8 92 d2 ff ff       	call   101e0b <dprintf>
  104b79:	83 c4 10             	add    $0x10,%esp
    return 1;
  104b7c:	b8 01 00 00 00       	mov    $0x1,%eax
  104b81:	e9 76 ff ff ff       	jmp    104afc <PTQueueInit_test2+0x4c>
  }
  if (tcb_get_prev(3) != 2 || tcb_get_next(3) != 4) {
    dprintf("test 2-b failed.\n");
    return 1;
  }
  if (tcb_get_prev(4) != 3 || tcb_get_next(4) != NUM_IDS) {
  104b86:	83 ec 0c             	sub    $0xc,%esp
  104b89:	6a 04                	push   $0x4
  104b8b:	e8 c0 fa ff ff       	call   104650 <tcb_get_next>
  104b90:	83 c4 10             	add    $0x10,%esp
  104b93:	83 f8 40             	cmp    $0x40,%eax
  104b96:	75 d4                	jne    104b6c <PTQueueInit_test2+0xbc>
    dprintf("test 2-c failed.\n");
    return 1;
  }
  tqueue_remove(0, 3);
  104b98:	51                   	push   %ecx
  104b99:	51                   	push   %ecx
  104b9a:	6a 03                	push   $0x3
  104b9c:	6a 00                	push   $0x0
  104b9e:	e8 6d fd ff ff       	call   104910 <tqueue_remove>
  if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 4) {
  104ba3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104baa:	e8 71 fa ff ff       	call   104620 <tcb_get_prev>
  104baf:	83 c4 10             	add    $0x10,%esp
  104bb2:	83 f8 40             	cmp    $0x40,%eax
  104bb5:	74 1a                	je     104bd1 <PTQueueInit_test2+0x121>
    dprintf("test 2-d failed.\n");
  104bb7:	83 ec 0c             	sub    $0xc,%esp
  104bba:	68 9d 64 10 00       	push   $0x10649d
  104bbf:	e8 47 d2 ff ff       	call   101e0b <dprintf>
  104bc4:	83 c4 10             	add    $0x10,%esp
    return 1;
  104bc7:	b8 01 00 00 00       	mov    $0x1,%eax
  104bcc:	e9 2b ff ff ff       	jmp    104afc <PTQueueInit_test2+0x4c>
  if (tcb_get_prev(4) != 3 || tcb_get_next(4) != NUM_IDS) {
    dprintf("test 2-c failed.\n");
    return 1;
  }
  tqueue_remove(0, 3);
  if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 4) {
  104bd1:	83 ec 0c             	sub    $0xc,%esp
  104bd4:	6a 02                	push   $0x2
  104bd6:	e8 75 fa ff ff       	call   104650 <tcb_get_next>
  104bdb:	83 c4 10             	add    $0x10,%esp
  104bde:	83 f8 04             	cmp    $0x4,%eax
  104be1:	75 d4                	jne    104bb7 <PTQueueInit_test2+0x107>
    dprintf("test 2-d failed.\n");
    return 1;
  }
  if (tcb_get_prev(3) != NUM_IDS || tcb_get_next(3) != NUM_IDS) {
  104be3:	83 ec 0c             	sub    $0xc,%esp
  104be6:	6a 03                	push   $0x3
  104be8:	e8 33 fa ff ff       	call   104620 <tcb_get_prev>
  104bed:	83 c4 10             	add    $0x10,%esp
  104bf0:	83 f8 40             	cmp    $0x40,%eax
  104bf3:	74 1a                	je     104c0f <PTQueueInit_test2+0x15f>
    dprintf("test 2-e failed.\n");
  104bf5:	83 ec 0c             	sub    $0xc,%esp
  104bf8:	68 af 64 10 00       	push   $0x1064af
  104bfd:	e8 09 d2 ff ff       	call   101e0b <dprintf>
  104c02:	83 c4 10             	add    $0x10,%esp
    return 1;
  104c05:	b8 01 00 00 00       	mov    $0x1,%eax
  104c0a:	e9 ed fe ff ff       	jmp    104afc <PTQueueInit_test2+0x4c>
  tqueue_remove(0, 3);
  if (tcb_get_prev(2) != NUM_IDS || tcb_get_next(2) != 4) {
    dprintf("test 2-d failed.\n");
    return 1;
  }
  if (tcb_get_prev(3) != NUM_IDS || tcb_get_next(3) != NUM_IDS) {
  104c0f:	83 ec 0c             	sub    $0xc,%esp
  104c12:	6a 03                	push   $0x3
  104c14:	e8 37 fa ff ff       	call   104650 <tcb_get_next>
  104c19:	83 c4 10             	add    $0x10,%esp
  104c1c:	83 f8 40             	cmp    $0x40,%eax
  104c1f:	75 d4                	jne    104bf5 <PTQueueInit_test2+0x145>
    dprintf("test 2-e failed.\n");
    return 1;
  }
  if (tcb_get_prev(4) != 2 || tcb_get_next(4) != NUM_IDS) {
  104c21:	83 ec 0c             	sub    $0xc,%esp
  104c24:	6a 04                	push   $0x4
  104c26:	e8 f5 f9 ff ff       	call   104620 <tcb_get_prev>
  104c2b:	83 c4 10             	add    $0x10,%esp
  104c2e:	83 f8 02             	cmp    $0x2,%eax
  104c31:	74 1a                	je     104c4d <PTQueueInit_test2+0x19d>
    dprintf("test 2-f failed.\n");
  104c33:	83 ec 0c             	sub    $0xc,%esp
  104c36:	68 c1 64 10 00       	push   $0x1064c1
  104c3b:	e8 cb d1 ff ff       	call   101e0b <dprintf>
  104c40:	83 c4 10             	add    $0x10,%esp
    return 1;
  104c43:	b8 01 00 00 00       	mov    $0x1,%eax
  104c48:	e9 af fe ff ff       	jmp    104afc <PTQueueInit_test2+0x4c>
  }
  if (tcb_get_prev(3) != NUM_IDS || tcb_get_next(3) != NUM_IDS) {
    dprintf("test 2-e failed.\n");
    return 1;
  }
  if (tcb_get_prev(4) != 2 || tcb_get_next(4) != NUM_IDS) {
  104c4d:	83 ec 0c             	sub    $0xc,%esp
  104c50:	6a 04                	push   $0x4
  104c52:	e8 f9 f9 ff ff       	call   104650 <tcb_get_next>
  104c57:	83 c4 10             	add    $0x10,%esp
  104c5a:	83 f8 40             	cmp    $0x40,%eax
  104c5d:	75 d4                	jne    104c33 <PTQueueInit_test2+0x183>
    dprintf("test 2-f failed.\n");
    return 1;
  }
  pid = tqueue_dequeue(0);
  104c5f:	83 ec 0c             	sub    $0xc,%esp
  104c62:	6a 00                	push   $0x0
  104c64:	e8 27 fc ff ff       	call   104890 <tqueue_dequeue>
  if (pid != 2 || tcb_get_prev(pid) != NUM_IDS || tcb_get_next(pid) != NUM_IDS
  104c69:	83 c4 10             	add    $0x10,%esp
  104c6c:	83 f8 02             	cmp    $0x2,%eax
  }
  if (tcb_get_prev(4) != 2 || tcb_get_next(4) != NUM_IDS) {
    dprintf("test 2-f failed.\n");
    return 1;
  }
  pid = tqueue_dequeue(0);
  104c6f:	89 c3                	mov    %eax,%ebx
  if (pid != 2 || tcb_get_prev(pid) != NUM_IDS || tcb_get_next(pid) != NUM_IDS
  104c71:	0f 84 83 00 00 00    	je     104cfa <PTQueueInit_test2+0x24a>
   || tqueue_get_head(0) != 4 || tqueue_get_tail(0) != 4) {
    dprintf("test 2-g failed.\n");
  104c77:	83 ec 0c             	sub    $0xc,%esp
  104c7a:	68 d3 64 10 00       	push   $0x1064d3
  104c7f:	e8 87 d1 ff ff       	call   101e0b <dprintf>
    dprintf("pid %d\n", pid);
  104c84:	58                   	pop    %eax
  104c85:	5a                   	pop    %edx
  104c86:	53                   	push   %ebx
  104c87:	68 e5 64 10 00       	push   $0x1064e5
  104c8c:	e8 7a d1 ff ff       	call   101e0b <dprintf>
    dprintf("pid %d\n", tcb_get_prev(pid));
  104c91:	89 1c 24             	mov    %ebx,(%esp)
  104c94:	e8 87 f9 ff ff       	call   104620 <tcb_get_prev>
  104c99:	59                   	pop    %ecx
  104c9a:	5a                   	pop    %edx
  104c9b:	50                   	push   %eax
  104c9c:	68 e5 64 10 00       	push   $0x1064e5
  104ca1:	e8 65 d1 ff ff       	call   101e0b <dprintf>
    dprintf("pid %d\n", tcb_get_next(pid));
  104ca6:	89 1c 24             	mov    %ebx,(%esp)
  104ca9:	e8 a2 f9 ff ff       	call   104650 <tcb_get_next>
  104cae:	59                   	pop    %ecx
  104caf:	5b                   	pop    %ebx
  104cb0:	50                   	push   %eax
  104cb1:	68 e5 64 10 00       	push   $0x1064e5
  104cb6:	e8 50 d1 ff ff       	call   101e0b <dprintf>
    dprintf("pid %d\n", tqueue_get_head(0));
  104cbb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104cc2:	e8 b9 fa ff ff       	call   104780 <tqueue_get_head>
  104cc7:	5a                   	pop    %edx
  104cc8:	59                   	pop    %ecx
  104cc9:	50                   	push   %eax
  104cca:	68 e5 64 10 00       	push   $0x1064e5
  104ccf:	e8 37 d1 ff ff       	call   101e0b <dprintf>
    dprintf("pid %d\n", tqueue_get_tail(0));
  104cd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104cdb:	e8 c0 fa ff ff       	call   1047a0 <tqueue_get_tail>
  104ce0:	5b                   	pop    %ebx
  104ce1:	5a                   	pop    %edx
  104ce2:	50                   	push   %eax
  104ce3:	68 e5 64 10 00       	push   $0x1064e5
  104ce8:	e8 1e d1 ff ff       	call   101e0b <dprintf>
  104ced:	83 c4 10             	add    $0x10,%esp
    return 1;
  104cf0:	b8 01 00 00 00       	mov    $0x1,%eax
  104cf5:	e9 02 fe ff ff       	jmp    104afc <PTQueueInit_test2+0x4c>
  if (tcb_get_prev(4) != 2 || tcb_get_next(4) != NUM_IDS) {
    dprintf("test 2-f failed.\n");
    return 1;
  }
  pid = tqueue_dequeue(0);
  if (pid != 2 || tcb_get_prev(pid) != NUM_IDS || tcb_get_next(pid) != NUM_IDS
  104cfa:	83 ec 0c             	sub    $0xc,%esp
  104cfd:	6a 02                	push   $0x2
  104cff:	e8 1c f9 ff ff       	call   104620 <tcb_get_prev>
  104d04:	83 c4 10             	add    $0x10,%esp
  104d07:	83 f8 40             	cmp    $0x40,%eax
  104d0a:	0f 85 67 ff ff ff    	jne    104c77 <PTQueueInit_test2+0x1c7>
  104d10:	83 ec 0c             	sub    $0xc,%esp
  104d13:	6a 02                	push   $0x2
  104d15:	e8 36 f9 ff ff       	call   104650 <tcb_get_next>
  104d1a:	83 c4 10             	add    $0x10,%esp
  104d1d:	83 f8 40             	cmp    $0x40,%eax
  104d20:	0f 85 51 ff ff ff    	jne    104c77 <PTQueueInit_test2+0x1c7>
   || tqueue_get_head(0) != 4 || tqueue_get_tail(0) != 4) {
  104d26:	83 ec 0c             	sub    $0xc,%esp
  104d29:	6a 00                	push   $0x0
  104d2b:	e8 50 fa ff ff       	call   104780 <tqueue_get_head>
  104d30:	83 c4 10             	add    $0x10,%esp
  104d33:	83 f8 04             	cmp    $0x4,%eax
  104d36:	0f 85 3b ff ff ff    	jne    104c77 <PTQueueInit_test2+0x1c7>
  104d3c:	83 ec 0c             	sub    $0xc,%esp
  104d3f:	6a 00                	push   $0x0
  104d41:	e8 5a fa ff ff       	call   1047a0 <tqueue_get_tail>
  104d46:	83 c4 10             	add    $0x10,%esp
  104d49:	83 f8 04             	cmp    $0x4,%eax
  104d4c:	0f 85 25 ff ff ff    	jne    104c77 <PTQueueInit_test2+0x1c7>
    dprintf("pid %d\n", tcb_get_next(pid));
    dprintf("pid %d\n", tqueue_get_head(0));
    dprintf("pid %d\n", tqueue_get_tail(0));
    return 1;
  }
  dprintf("test 2 passed.\n");
  104d52:	83 ec 0c             	sub    $0xc,%esp
  104d55:	68 bd 63 10 00       	push   $0x1063bd
  104d5a:	e8 ac d0 ff ff       	call   101e0b <dprintf>
  104d5f:	83 c4 10             	add    $0x10,%esp
  return 0;
  104d62:	31 c0                	xor    %eax,%eax
  104d64:	e9 93 fd ff ff       	jmp    104afc <PTQueueInit_test2+0x4c>
  104d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104d70 <PTQueueInit_test_own>:
int PTQueueInit_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  104d70:	31 c0                	xor    %eax,%eax
  104d72:	c3                   	ret    
  104d73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104d80 <test_PTQueueInit>:

int test_PTQueueInit()
{
  104d80:	53                   	push   %ebx
  104d81:	83 ec 08             	sub    $0x8,%esp
  return PTQueueInit_test1() + PTQueueInit_test2() + PTQueueInit_test_own();
  104d84:	e8 b7 fc ff ff       	call   104a40 <PTQueueInit_test1>
  104d89:	89 c3                	mov    %eax,%ebx
  104d8b:	e8 20 fd ff ff       	call   104ab0 <PTQueueInit_test2>
}
  104d90:	83 c4 08             	add    $0x8,%esp
  return 0;
}

int test_PTQueueInit()
{
  return PTQueueInit_test1() + PTQueueInit_test2() + PTQueueInit_test_own();
  104d93:	01 d8                	add    %ebx,%eax
}
  104d95:	5b                   	pop    %ebx
  104d96:	c3                   	ret    
  104d97:	66 90                	xchg   %ax,%ax
  104d99:	66 90                	xchg   %ax,%ax
  104d9b:	66 90                	xchg   %ax,%ax
  104d9d:	66 90                	xchg   %ax,%ax
  104d9f:	90                   	nop

00104da0 <get_curid>:
unsigned int CURID;

unsigned int get_curid(void)
{
	return CURID;
}
  104da0:	a1 08 cb de 01       	mov    0x1decb08,%eax
  104da5:	c3                   	ret    
  104da6:	8d 76 00             	lea    0x0(%esi),%esi
  104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104db0 <set_curid>:

void set_curid(unsigned int curid)
{
	CURID = curid;
  104db0:	8b 44 24 04          	mov    0x4(%esp),%eax
  104db4:	a3 08 cb de 01       	mov    %eax,0x1decb08
  104db9:	c3                   	ret    
  104dba:	66 90                	xchg   %ax,%ax
  104dbc:	66 90                	xchg   %ax,%ax
  104dbe:	66 90                	xchg   %ax,%ax

00104dc0 <thread_init>:
#include <lib/thread.h>

#include "import.h"

void thread_init(void)
{
  104dc0:	83 ec 0c             	sub    $0xc,%esp
	tqueue_init();
  104dc3:	e8 18 fa ff ff       	call   1047e0 <tqueue_init>
	set_curid(0);
  104dc8:	83 ec 0c             	sub    $0xc,%esp
  104dcb:	6a 00                	push   $0x0
  104dcd:	e8 de ff ff ff       	call   104db0 <set_curid>
	tcb_set_state(0, TSTATE_RUN);
  104dd2:	58                   	pop    %eax
  104dd3:	5a                   	pop    %edx
  104dd4:	6a 01                	push   $0x1
  104dd6:	6a 00                	push   $0x0
  104dd8:	e8 23 f8 ff ff       	call   104600 <tcb_set_state>
}
  104ddd:	83 c4 1c             	add    $0x1c,%esp
  104de0:	c3                   	ret    
  104de1:	eb 0d                	jmp    104df0 <thread_spawn>
  104de3:	90                   	nop
  104de4:	90                   	nop
  104de5:	90                   	nop
  104de6:	90                   	nop
  104de7:	90                   	nop
  104de8:	90                   	nop
  104de9:	90                   	nop
  104dea:	90                   	nop
  104deb:	90                   	nop
  104dec:	90                   	nop
  104ded:	90                   	nop
  104dee:	90                   	nop
  104def:	90                   	nop

00104df0 <thread_spawn>:
  *  - import.h has all the functions you will need.
  *  Hint 2:
  *  - The ready queue is the queue with index NUM_IDS.
  */
unsigned int thread_spawn(void *entry, unsigned int id, unsigned int quota)
{
  104df0:	53                   	push   %ebx
  104df1:	83 ec 0c             	sub    $0xc,%esp
  unsigned int new_thread_context = kctx_new(entry, id, quota);
  104df4:	ff 74 24 1c          	pushl  0x1c(%esp)
  104df8:	ff 74 24 1c          	pushl  0x1c(%esp)
  104dfc:	ff 74 24 1c          	pushl  0x1c(%esp)
  104e00:	e8 1b f7 ff ff       	call   104520 <kctx_new>
  104e05:	89 c3                	mov    %eax,%ebx
  tcb_set_state(new_thread_context, TSTATE_READY);
  104e07:	58                   	pop    %eax
  104e08:	5a                   	pop    %edx
  104e09:	6a 00                	push   $0x0
  104e0b:	53                   	push   %ebx
  104e0c:	e8 ef f7 ff ff       	call   104600 <tcb_set_state>
  tqueue_enqueue(NUM_IDS, new_thread_context);
  104e11:	59                   	pop    %ecx
  104e12:	58                   	pop    %eax
  104e13:	53                   	push   %ebx
  104e14:	6a 40                	push   $0x40
  104e16:	e8 f5 f9 ff ff       	call   104810 <tqueue_enqueue>
  return new_thread_context;
}
  104e1b:	83 c4 18             	add    $0x18,%esp
  104e1e:	89 d8                	mov    %ebx,%eax
  104e20:	5b                   	pop    %ebx
  104e21:	c3                   	ret    
  104e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104e30 <thread_yield>:
  *          i.e. The thread at the head of the ready queue is run next.
  *  Hint 2: If you are the only thread that is ready to run,
  *          do you need to switch to yourself?
  */
void thread_yield(void)
{
  104e30:	56                   	push   %esi
  104e31:	53                   	push   %ebx
  104e32:	83 ec 04             	sub    $0x4,%esp
  unsigned int curid, next;

  curid = get_curid();
  104e35:	e8 66 ff ff ff       	call   104da0 <get_curid>



  // Check to make sure there is another thread to yield to.
  if (next != NUM_IDS) {
      tcb_set_state(curid, TSTATE_READY);
  104e3a:	83 ec 08             	sub    $0x8,%esp
  */
void thread_yield(void)
{
  unsigned int curid, next;

  curid = get_curid();
  104e3d:	89 c3                	mov    %eax,%ebx



  // Check to make sure there is another thread to yield to.
  if (next != NUM_IDS) {
      tcb_set_state(curid, TSTATE_READY);
  104e3f:	6a 00                	push   $0x0
  104e41:	50                   	push   %eax
  104e42:	e8 b9 f7 ff ff       	call   104600 <tcb_set_state>
      tqueue_enqueue(NUM_IDS, curid);
  104e47:	58                   	pop    %eax
  104e48:	5a                   	pop    %edx
  104e49:	53                   	push   %ebx
  104e4a:	6a 40                	push   $0x40
  104e4c:	e8 bf f9 ff ff       	call   104810 <tqueue_enqueue>
      next = tqueue_dequeue(NUM_IDS);
  104e51:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  104e58:	e8 33 fa ff ff       	call   104890 <tqueue_dequeue>
      set_curid(next);
  104e5d:	89 04 24             	mov    %eax,(%esp)

  // Check to make sure there is another thread to yield to.
  if (next != NUM_IDS) {
      tcb_set_state(curid, TSTATE_READY);
      tqueue_enqueue(NUM_IDS, curid);
      next = tqueue_dequeue(NUM_IDS);
  104e60:	89 c6                	mov    %eax,%esi
      set_curid(next);
  104e62:	e8 49 ff ff ff       	call   104db0 <set_curid>
      tcb_set_state(next, TSTATE_RUN);
  104e67:	59                   	pop    %ecx
  104e68:	58                   	pop    %eax
  104e69:	6a 01                	push   $0x1
  104e6b:	56                   	push   %esi
  104e6c:	e8 8f f7 ff ff       	call   104600 <tcb_set_state>
    // This performs the switch.
    kctx_switch(curid, next);
  104e71:	58                   	pop    %eax
  104e72:	5a                   	pop    %edx
  104e73:	56                   	push   %esi
  104e74:	53                   	push   %ebx
  104e75:	e8 46 f6 ff ff       	call   1044c0 <kctx_switch>
  }
}
  104e7a:	83 c4 14             	add    $0x14,%esp
  104e7d:	5b                   	pop    %ebx
  104e7e:	5e                   	pop    %esi
  104e7f:	c3                   	ret    

00104e80 <PThread_test1>:
#include <thread/PTCBIntro/export.h>
#include <thread/PTQueueIntro/export.h>
#include "export.h"

int PThread_test1()
{
  104e80:	53                   	push   %ebx
  104e81:	83 ec 0c             	sub    $0xc,%esp
  void * dummy_addr = (void *) 0;
  unsigned int chid = thread_spawn(dummy_addr, 0, 1000);
  104e84:	68 e8 03 00 00       	push   $0x3e8
  104e89:	6a 00                	push   $0x0
  104e8b:	6a 00                	push   $0x0
  104e8d:	e8 5e ff ff ff       	call   104df0 <thread_spawn>
  if (tcb_get_state(chid) != TSTATE_READY) {
  104e92:	89 04 24             	mov    %eax,(%esp)
#include "export.h"

int PThread_test1()
{
  void * dummy_addr = (void *) 0;
  unsigned int chid = thread_spawn(dummy_addr, 0, 1000);
  104e95:	89 c3                	mov    %eax,%ebx
  if (tcb_get_state(chid) != TSTATE_READY) {
  104e97:	e8 54 f7 ff ff       	call   1045f0 <tcb_get_state>
  104e9c:	83 c4 10             	add    $0x10,%esp
  104e9f:	85 c0                	test   %eax,%eax
  104ea1:	75 11                	jne    104eb4 <PThread_test1+0x34>
    dprintf("test 1 failed.\n");
    return 1;
  }
  if (tqueue_get_tail(NUM_IDS) != chid) {
  104ea3:	83 ec 0c             	sub    $0xc,%esp
  104ea6:	6a 40                	push   $0x40
  104ea8:	e8 f3 f8 ff ff       	call   1047a0 <tqueue_get_tail>
  104ead:	83 c4 10             	add    $0x10,%esp
  104eb0:	39 c3                	cmp    %eax,%ebx
  104eb2:	74 1c                	je     104ed0 <PThread_test1+0x50>
int PThread_test1()
{
  void * dummy_addr = (void *) 0;
  unsigned int chid = thread_spawn(dummy_addr, 0, 1000);
  if (tcb_get_state(chid) != TSTATE_READY) {
    dprintf("test 1 failed.\n");
  104eb4:	83 ec 0c             	sub    $0xc,%esp
  104eb7:	68 f1 62 10 00       	push   $0x1062f1
  104ebc:	e8 4a cf ff ff       	call   101e0b <dprintf>
    return 1;
  104ec1:	83 c4 10             	add    $0x10,%esp
  104ec4:	b8 01 00 00 00       	mov    $0x1,%eax
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  return 0;
}
  104ec9:	83 c4 08             	add    $0x8,%esp
  104ecc:	5b                   	pop    %ebx
  104ecd:	c3                   	ret    
  104ece:	66 90                	xchg   %ax,%ax
  }
  if (tqueue_get_tail(NUM_IDS) != chid) {
    dprintf("test 1 failed.\n");
    return 1;
  }
  dprintf("test 1 passed.\n");
  104ed0:	83 ec 0c             	sub    $0xc,%esp
  104ed3:	68 01 63 10 00       	push   $0x106301
  104ed8:	e8 2e cf ff ff       	call   101e0b <dprintf>
  return 0;
  104edd:	83 c4 10             	add    $0x10,%esp
  104ee0:	31 c0                	xor    %eax,%eax
}
  104ee2:	83 c4 08             	add    $0x8,%esp
  104ee5:	5b                   	pop    %ebx
  104ee6:	c3                   	ret    
  104ee7:	89 f6                	mov    %esi,%esi
  104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104ef0 <PThread_test_own>:
int PThread_test_own()
{
  // TODO (optional)
  // dprintf("own test passed.\n");
  return 0;
}
  104ef0:	31 c0                	xor    %eax,%eax
  104ef2:	c3                   	ret    
  104ef3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104f00 <test_PThread>:

int test_PThread()
{
  return PThread_test1() + PThread_test_own();
  104f00:	e9 7b ff ff ff       	jmp    104e80 <PThread_test1>
  104f05:	66 90                	xchg   %ax,%ax
  104f07:	66 90                	xchg   %ax,%ax
  104f09:	66 90                	xchg   %ax,%ax
  104f0b:	66 90                	xchg   %ax,%ax
  104f0d:	66 90                	xchg   %ax,%ax
  104f0f:	90                   	nop

00104f10 <proc_start_user>:
  *   - Set the page structures to the current user process.
  *   - call trap_return() with the pointer to the current process' user context.
  *     - User context's are stored in uctx_pool.
  */
void proc_start_user(void)
{
  104f10:	53                   	push   %ebx
  104f11:	83 ec 08             	sub    $0x8,%esp
    unsigned int pid = get_curid();
  104f14:	e8 87 fe ff ff       	call   104da0 <get_curid>
    tss_switch(pid);
  104f19:	83 ec 0c             	sub    $0xc,%esp
  *   - call trap_return() with the pointer to the current process' user context.
  *     - User context's are stored in uctx_pool.
  */
void proc_start_user(void)
{
    unsigned int pid = get_curid();
  104f1c:	89 c3                	mov    %eax,%ebx
    tss_switch(pid);
  104f1e:	50                   	push   %eax
  104f1f:	e8 2d d3 ff ff       	call   102251 <tss_switch>
    set_pdir_base(pid);
  104f24:	89 1c 24             	mov    %ebx,(%esp)
  104f27:	e8 64 e8 ff ff       	call   103790 <set_pdir_base>
    trap_return(&uctx_pool[pid]);
  104f2c:	89 d8                	mov    %ebx,%eax
  104f2e:	c1 e0 06             	shl    $0x6,%eax
  104f31:	8d 84 98 20 cb de 01 	lea    0x1decb20(%eax,%ebx,4),%eax
  104f38:	89 04 24             	mov    %eax,(%esp)
  104f3b:	e8 c0 c8 ff ff       	call   101800 <trap_return>

}
  104f40:	83 c4 18             	add    $0x18,%esp
  104f43:	5b                   	pop    %ebx
  104f44:	c3                   	ret    
  104f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104f50 <proc_create>:
  *           - The entry point for the given elf [elf_addr] can be retrieved using
  *             elf_entry() function defined in elf.c
  *   4. Return: the pid of the new thread.
  */
unsigned int proc_create(void *elf_addr, unsigned int quota)
{
  104f50:	57                   	push   %edi
  104f51:	56                   	push   %esi
  104f52:	53                   	push   %ebx
  104f53:	8b 7c 24 10          	mov    0x10(%esp),%edi
	  unsigned int pid, id;

    id = get_curid();
  104f57:	e8 44 fe ff ff       	call   104da0 <get_curid>
    pid = thread_spawn((void *) proc_start_user, id, quota);
  104f5c:	83 ec 04             	sub    $0x4,%esp
  104f5f:	ff 74 24 18          	pushl  0x18(%esp)
  104f63:	50                   	push   %eax
  104f64:	68 10 4f 10 00       	push   $0x104f10
  104f69:	e8 82 fe ff ff       	call   104df0 <thread_spawn>
  104f6e:	89 c6                	mov    %eax,%esi

	  elf_load(elf_addr, pid);
  104f70:	58                   	pop    %eax
  104f71:	5a                   	pop    %edx
  104f72:	56                   	push   %esi
  104f73:	57                   	push   %edi
  104f74:	e8 09 dc ff ff       	call   102b82 <elf_load>

    uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  104f79:	89 f0                	mov    %esi,%eax
  104f7b:	b9 23 00 00 00       	mov    $0x23,%ecx
    uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
    uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
    uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
    uctx_pool[pid].esp = VM_USERHI;
    uctx_pool[pid].eflags = FL_IF;
    uctx_pool[pid].eip = elf_entry(elf_addr);
  104f80:	89 3c 24             	mov    %edi,(%esp)
    id = get_curid();
    pid = thread_spawn((void *) proc_start_user, id, quota);

	  elf_load(elf_addr, pid);

    uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  104f83:	c1 e0 06             	shl    $0x6,%eax
  104f86:	8d 9c b0 20 cb de 01 	lea    0x1decb20(%eax,%esi,4),%ebx
    uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
  104f8d:	b8 23 00 00 00       	mov    $0x23,%eax
  104f92:	66 89 43 24          	mov    %ax,0x24(%ebx)
    uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
  104f96:	b8 1b 00 00 00       	mov    $0x1b,%eax
    id = get_curid();
    pid = thread_spawn((void *) proc_start_user, id, quota);

	  elf_load(elf_addr, pid);

    uctx_pool[pid].es = CPU_GDT_UDATA | 3;
  104f9b:	66 89 4b 20          	mov    %cx,0x20(%ebx)
    uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
    uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
  104f9f:	66 89 43 34          	mov    %ax,0x34(%ebx)
    uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
  104fa3:	b8 23 00 00 00       	mov    $0x23,%eax
    uctx_pool[pid].esp = VM_USERHI;
  104fa8:	c7 43 3c 00 00 00 f0 	movl   $0xf0000000,0x3c(%ebx)
	  elf_load(elf_addr, pid);

    uctx_pool[pid].es = CPU_GDT_UDATA | 3;
    uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
    uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
    uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
  104faf:	66 89 43 40          	mov    %ax,0x40(%ebx)
    uctx_pool[pid].esp = VM_USERHI;
    uctx_pool[pid].eflags = FL_IF;
  104fb3:	c7 43 38 00 02 00 00 	movl   $0x200,0x38(%ebx)
    uctx_pool[pid].eip = elf_entry(elf_addr);
  104fba:	e8 8d dd ff ff       	call   102d4c <elf_entry>
//    KERN_DEBUG("0x%x08\n", uctx_pool[pid].eip);
	  return pid;
  104fbf:	83 c4 10             	add    $0x10,%esp
    uctx_pool[pid].ds = CPU_GDT_UDATA | 3;
    uctx_pool[pid].cs = CPU_GDT_UCODE | 3;
    uctx_pool[pid].ss = CPU_GDT_UDATA | 3;
    uctx_pool[pid].esp = VM_USERHI;
    uctx_pool[pid].eflags = FL_IF;
    uctx_pool[pid].eip = elf_entry(elf_addr);
  104fc2:	89 43 30             	mov    %eax,0x30(%ebx)
//    KERN_DEBUG("0x%x08\n", uctx_pool[pid].eip);
	  return pid;
}
  104fc5:	89 f0                	mov    %esi,%eax
  104fc7:	5b                   	pop    %ebx
  104fc8:	5e                   	pop    %esi
  104fc9:	5f                   	pop    %edi
  104fca:	c3                   	ret    
  104fcb:	66 90                	xchg   %ax,%ax
  104fcd:	66 90                	xchg   %ax,%ax
  104fcf:	90                   	nop

00104fd0 <syscall_get_arg1>:
  *  - In the following functions, you will have to get the fields from the corresponding user context in uctx_pool.
  *  - The get functions will retrieve a field (corresponding to the argument number) of the regs field in the uctx_pool array.
  */

unsigned int syscall_get_arg1(void)
{
  104fd0:	83 ec 0c             	sub    $0xc,%esp
  return uctx_pool[get_curid()].regs.eax;
  104fd3:	e8 c8 fd ff ff       	call   104da0 <get_curid>
  104fd8:	89 c2                	mov    %eax,%edx
  104fda:	c1 e2 06             	shl    $0x6,%edx
  104fdd:	8b 84 82 3c cb de 01 	mov    0x1decb3c(%edx,%eax,4),%eax
}
  104fe4:	83 c4 0c             	add    $0xc,%esp
  104fe7:	c3                   	ret    
  104fe8:	90                   	nop
  104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104ff0 <syscall_get_arg2>:

unsigned int syscall_get_arg2(void)
{
  104ff0:	83 ec 0c             	sub    $0xc,%esp
  return uctx_pool[get_curid()].regs.ebx;
  104ff3:	e8 a8 fd ff ff       	call   104da0 <get_curid>
  104ff8:	89 c2                	mov    %eax,%edx
  104ffa:	c1 e2 06             	shl    $0x6,%edx
  104ffd:	8b 84 82 30 cb de 01 	mov    0x1decb30(%edx,%eax,4),%eax
}
  105004:	83 c4 0c             	add    $0xc,%esp
  105007:	c3                   	ret    
  105008:	90                   	nop
  105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105010 <syscall_get_arg3>:

unsigned int syscall_get_arg3(void)
{
  105010:	83 ec 0c             	sub    $0xc,%esp
  return uctx_pool[get_curid()].regs.ecx;
  105013:	e8 88 fd ff ff       	call   104da0 <get_curid>
  105018:	89 c2                	mov    %eax,%edx
  10501a:	c1 e2 06             	shl    $0x6,%edx
  10501d:	8b 84 82 38 cb de 01 	mov    0x1decb38(%edx,%eax,4),%eax
}
  105024:	83 c4 0c             	add    $0xc,%esp
  105027:	c3                   	ret    
  105028:	90                   	nop
  105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105030 <syscall_get_arg4>:

unsigned int syscall_get_arg4(void)
{
  105030:	83 ec 0c             	sub    $0xc,%esp
  return uctx_pool[get_curid()].regs.edx;
  105033:	e8 68 fd ff ff       	call   104da0 <get_curid>
  105038:	89 c2                	mov    %eax,%edx
  10503a:	c1 e2 06             	shl    $0x6,%edx
  10503d:	8b 84 82 34 cb de 01 	mov    0x1decb34(%edx,%eax,4),%eax
}
  105044:	83 c4 0c             	add    $0xc,%esp
  105047:	c3                   	ret    
  105048:	90                   	nop
  105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105050 <syscall_get_arg5>:

unsigned int syscall_get_arg5(void)
{
  105050:	83 ec 0c             	sub    $0xc,%esp
  return uctx_pool[get_curid()].regs.esi;
  105053:	e8 48 fd ff ff       	call   104da0 <get_curid>
  105058:	89 c2                	mov    %eax,%edx
  10505a:	c1 e2 06             	shl    $0x6,%edx
  10505d:	8b 84 82 24 cb de 01 	mov    0x1decb24(%edx,%eax,4),%eax
}
  105064:	83 c4 0c             	add    $0xc,%esp
  105067:	c3                   	ret    
  105068:	90                   	nop
  105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105070 <syscall_get_arg6>:

unsigned int syscall_get_arg6(void)
{
  105070:	83 ec 0c             	sub    $0xc,%esp
  return uctx_pool[get_curid()].regs.edi;
  105073:	e8 28 fd ff ff       	call   104da0 <get_curid>
  105078:	89 c2                	mov    %eax,%edx
  10507a:	c1 e2 06             	shl    $0x6,%edx
  10507d:	8b 84 82 20 cb de 01 	mov    0x1decb20(%edx,%eax,4),%eax
}
  105084:	83 c4 0c             	add    $0xc,%esp
  105087:	c3                   	ret    
  105088:	90                   	nop
  105089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105090 <syscall_set_errno>:
  *
  *  Hint 1:
  *  - Set the err field of uctx_pool to errno.
  */
void syscall_set_errno(unsigned int errno)
{
  105090:	83 ec 0c             	sub    $0xc,%esp
  uctx_pool[get_curid()].regs.eax= errno;
  105093:	e8 08 fd ff ff       	call   104da0 <get_curid>
  105098:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  10509c:	89 c2                	mov    %eax,%edx
  10509e:	c1 e2 06             	shl    $0x6,%edx
  1050a1:	89 8c 82 3c cb de 01 	mov    %ecx,0x1decb3c(%edx,%eax,4)
}
  1050a8:	83 c4 0c             	add    $0xc,%esp
  1050ab:	c3                   	ret    
  1050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001050b0 <syscall_set_retval1>:
  *  Hint 2: Here you will be setting the fields of the corresponding user context in uctx_pool.
  *  - The set functions will set a field (corresponding to the argument number) of the regs field in the uctx_pool array.
  */

void syscall_set_retval1(unsigned int retval)
{
  1050b0:	83 ec 0c             	sub    $0xc,%esp
  uctx_pool[get_curid()].regs.ebx = retval;
  1050b3:	e8 e8 fc ff ff       	call   104da0 <get_curid>
  1050b8:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  1050bc:	89 c2                	mov    %eax,%edx
  1050be:	c1 e2 06             	shl    $0x6,%edx
  1050c1:	89 8c 82 30 cb de 01 	mov    %ecx,0x1decb30(%edx,%eax,4)
}
  1050c8:	83 c4 0c             	add    $0xc,%esp
  1050cb:	c3                   	ret    
  1050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001050d0 <syscall_set_retval2>:

void syscall_set_retval2(unsigned int retval)
{
  1050d0:	83 ec 0c             	sub    $0xc,%esp
  uctx_pool[get_curid()].regs.ecx = retval;
  1050d3:	e8 c8 fc ff ff       	call   104da0 <get_curid>
  1050d8:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  1050dc:	89 c2                	mov    %eax,%edx
  1050de:	c1 e2 06             	shl    $0x6,%edx
  1050e1:	89 8c 82 38 cb de 01 	mov    %ecx,0x1decb38(%edx,%eax,4)
}
  1050e8:	83 c4 0c             	add    $0xc,%esp
  1050eb:	c3                   	ret    
  1050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001050f0 <syscall_set_retval3>:

void syscall_set_retval3(unsigned int retval)
{
  1050f0:	83 ec 0c             	sub    $0xc,%esp
  uctx_pool[get_curid()].regs.edx = retval;
  1050f3:	e8 a8 fc ff ff       	call   104da0 <get_curid>
  1050f8:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  1050fc:	89 c2                	mov    %eax,%edx
  1050fe:	c1 e2 06             	shl    $0x6,%edx
  105101:	89 8c 82 34 cb de 01 	mov    %ecx,0x1decb34(%edx,%eax,4)
}
  105108:	83 c4 0c             	add    $0xc,%esp
  10510b:	c3                   	ret    
  10510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105110 <syscall_set_retval4>:

void syscall_set_retval4(unsigned int retval)
{
  105110:	83 ec 0c             	sub    $0xc,%esp
  uctx_pool[get_curid()].regs.esi = retval;
  105113:	e8 88 fc ff ff       	call   104da0 <get_curid>
  105118:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  10511c:	89 c2                	mov    %eax,%edx
  10511e:	c1 e2 06             	shl    $0x6,%edx
  105121:	89 8c 82 24 cb de 01 	mov    %ecx,0x1decb24(%edx,%eax,4)
}
  105128:	83 c4 0c             	add    $0xc,%esp
  10512b:	c3                   	ret    
  10512c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105130 <syscall_set_retval5>:

void syscall_set_retval5(unsigned int retval)
{
  105130:	83 ec 0c             	sub    $0xc,%esp
  uctx_pool[get_curid()].regs.edi = retval;
  105133:	e8 68 fc ff ff       	call   104da0 <get_curid>
  105138:	8b 4c 24 10          	mov    0x10(%esp),%ecx
  10513c:	89 c2                	mov    %eax,%edx
  10513e:	c1 e2 06             	shl    $0x6,%edx
  105141:	89 8c 82 20 cb de 01 	mov    %ecx,0x1decb20(%edx,%eax,4)

}
  105148:	83 c4 0c             	add    $0xc,%esp
  10514b:	c3                   	ret    
  10514c:	66 90                	xchg   %ax,%ax
  10514e:	66 90                	xchg   %ax,%ax

00105150 <sys_puts>:
/**
 * Copies a string from user into buffer and prints it to the screen.
 * This is called by the user level "printf" library as a system call.
 */
void sys_puts(void)
{
  105150:	55                   	push   %ebp
  105151:	57                   	push   %edi
  105152:	56                   	push   %esi
  105153:	53                   	push   %ebx
  105154:	83 ec 1c             	sub    $0x1c,%esp
	unsigned int cur_pid;
	unsigned int str_uva, str_len;
	unsigned int remain, cur_pos, nbytes;

	cur_pid = get_curid();
  105157:	e8 44 fc ff ff       	call   104da0 <get_curid>
  10515c:	89 c5                	mov    %eax,%ebp
	str_uva = syscall_get_arg2();
  10515e:	e8 8d fe ff ff       	call   104ff0 <syscall_get_arg2>
  105163:	89 c6                	mov    %eax,%esi
	str_len = syscall_get_arg3();
  105165:	e8 a6 fe ff ff       	call   105010 <syscall_get_arg3>

	if (!(VM_USERLO <= str_uva && str_uva + str_len <= VM_USERHI)) {
  10516a:	81 fe ff ff ff 3f    	cmp    $0x3fffffff,%esi
  105170:	0f 86 9a 00 00 00    	jbe    105210 <sys_puts+0xc0>
  105176:	89 c3                	mov    %eax,%ebx
  105178:	8d 04 06             	lea    (%esi,%eax,1),%eax
  10517b:	3d 00 00 00 f0       	cmp    $0xf0000000,%eax
  105180:	0f 87 8a 00 00 00    	ja     105210 <sys_puts+0xc0>
  105186:	89 ef                	mov    %ebp,%edi
  105188:	c1 e7 0c             	shl    $0xc,%edi
  10518b:	81 c7 80 64 92 01    	add    $0x1926480,%edi
	}

	remain = str_len;
	cur_pos = str_uva;

	while (remain) {
  105191:	85 db                	test   %ebx,%ebx
			      cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
			syscall_set_errno(E_MEM);
			return;
		}

		sys_buf[cur_pid][nbytes] = '\0';
  105193:	89 7c 24 0c          	mov    %edi,0xc(%esp)
	}

	remain = str_len;
	cur_pos = str_uva;

	while (remain) {
  105197:	75 48                	jne    1051e1 <sys_puts+0x91>
  105199:	e9 a6 00 00 00       	jmp    105244 <sys_puts+0xf4>
  10519e:	66 90                	xchg   %ax,%ax
		if (remain < PAGESIZE - 1)
			nbytes = remain;
		else
			nbytes = PAGESIZE - 1;

		if (pt_copyin(cur_pid,
  1051a0:	68 ff 0f 00 00       	push   $0xfff
  1051a5:	57                   	push   %edi
  1051a6:	56                   	push   %esi
  1051a7:	55                   	push   %ebp
  1051a8:	e8 89 d7 ff ff       	call   102936 <pt_copyin>
  1051ad:	83 c4 10             	add    $0x10,%esp
  1051b0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  1051b5:	75 42                	jne    1051f9 <sys_puts+0xa9>
			      cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
			syscall_set_errno(E_MEM);
			return;
		}

		sys_buf[cur_pid][nbytes] = '\0';
  1051b7:	8b 44 24 0c          	mov    0xc(%esp),%eax
		KERN_INFO("%s", sys_buf[cur_pid]);
  1051bb:	83 ec 08             	sub    $0x8,%esp

		remain -= nbytes;
		cur_pos += nbytes;
  1051be:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
			      cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
			syscall_set_errno(E_MEM);
			return;
		}

		sys_buf[cur_pid][nbytes] = '\0';
  1051c4:	c6 80 ff 0f 00 00 00 	movb   $0x0,0xfff(%eax)
		KERN_INFO("%s", sys_buf[cur_pid]);
  1051cb:	57                   	push   %edi
  1051cc:	68 8e 5a 10 00       	push   $0x105a8e
  1051d1:	e8 a0 ca ff ff       	call   101c76 <debug_info>
	}

	remain = str_len;
	cur_pos = str_uva;

	while (remain) {
  1051d6:	83 c4 10             	add    $0x10,%esp
  1051d9:	81 eb ff 0f 00 00    	sub    $0xfff,%ebx
  1051df:	74 63                	je     105244 <sys_puts+0xf4>
		if (remain < PAGESIZE - 1)
  1051e1:	81 fb fe 0f 00 00    	cmp    $0xffe,%ebx
  1051e7:	77 b7                	ja     1051a0 <sys_puts+0x50>
			nbytes = remain;
		else
			nbytes = PAGESIZE - 1;

		if (pt_copyin(cur_pid,
  1051e9:	53                   	push   %ebx
  1051ea:	57                   	push   %edi
  1051eb:	56                   	push   %esi
  1051ec:	55                   	push   %ebp
  1051ed:	e8 44 d7 ff ff       	call   102936 <pt_copyin>
  1051f2:	83 c4 10             	add    $0x10,%esp
  1051f5:	39 c3                	cmp    %eax,%ebx
  1051f7:	74 2f                	je     105228 <sys_puts+0xd8>
			      cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
			syscall_set_errno(E_MEM);
  1051f9:	83 ec 0c             	sub    $0xc,%esp
  1051fc:	6a 01                	push   $0x1
  1051fe:	e8 8d fe ff ff       	call   105090 <syscall_set_errno>
			return;
  105203:	83 c4 10             	add    $0x10,%esp
		remain -= nbytes;
		cur_pos += nbytes;
	}

	syscall_set_errno(E_SUCC);
}
  105206:	83 c4 1c             	add    $0x1c,%esp
  105209:	5b                   	pop    %ebx
  10520a:	5e                   	pop    %esi
  10520b:	5f                   	pop    %edi
  10520c:	5d                   	pop    %ebp
  10520d:	c3                   	ret    
  10520e:	66 90                	xchg   %ax,%ax
	cur_pid = get_curid();
	str_uva = syscall_get_arg2();
	str_len = syscall_get_arg3();

	if (!(VM_USERLO <= str_uva && str_uva + str_len <= VM_USERHI)) {
		syscall_set_errno(E_INVAL_ADDR);
  105210:	83 ec 0c             	sub    $0xc,%esp
  105213:	6a 04                	push   $0x4
  105215:	e8 76 fe ff ff       	call   105090 <syscall_set_errno>
		return;
  10521a:	83 c4 10             	add    $0x10,%esp
		remain -= nbytes;
		cur_pos += nbytes;
	}

	syscall_set_errno(E_SUCC);
}
  10521d:	83 c4 1c             	add    $0x1c,%esp
  105220:	5b                   	pop    %ebx
  105221:	5e                   	pop    %esi
  105222:	5f                   	pop    %edi
  105223:	5d                   	pop    %ebp
  105224:	c3                   	ret    
  105225:	8d 76 00             	lea    0x0(%esi),%esi
			syscall_set_errno(E_MEM);
			return;
		}

		sys_buf[cur_pid][nbytes] = '\0';
		KERN_INFO("%s", sys_buf[cur_pid]);
  105228:	83 ec 08             	sub    $0x8,%esp
			      cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
			syscall_set_errno(E_MEM);
			return;
		}

		sys_buf[cur_pid][nbytes] = '\0';
  10522b:	c1 e5 0c             	shl    $0xc,%ebp
		KERN_INFO("%s", sys_buf[cur_pid]);
  10522e:	57                   	push   %edi
  10522f:	68 8e 5a 10 00       	push   $0x105a8e
			      cur_pos, sys_buf[cur_pid], nbytes) != nbytes) {
			syscall_set_errno(E_MEM);
			return;
		}

		sys_buf[cur_pid][nbytes] = '\0';
  105234:	c6 84 2b 80 64 92 01 	movb   $0x0,0x1926480(%ebx,%ebp,1)
  10523b:	00 
		KERN_INFO("%s", sys_buf[cur_pid]);
  10523c:	e8 35 ca ff ff       	call   101c76 <debug_info>
  105241:	83 c4 10             	add    $0x10,%esp

		remain -= nbytes;
		cur_pos += nbytes;
	}

	syscall_set_errno(E_SUCC);
  105244:	83 ec 0c             	sub    $0xc,%esp
  105247:	6a 00                	push   $0x0
  105249:	e8 42 fe ff ff       	call   105090 <syscall_set_errno>
  10524e:	83 c4 10             	add    $0x10,%esp
  105251:	eb ca                	jmp    10521d <sys_puts+0xcd>
  105253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105260 <sys_spawn>:
  *  Hint 2: Set the return values.
  *  - If successful, errno = E_SUCC else E_INVAL_PID
  *  - If successful, retval1 = pid (return value of proc_create()) else NUM_IDS
  */
void sys_spawn(void)
{
  105260:	56                   	push   %esi
  105261:	53                   	push   %ebx
  105262:	83 ec 04             	sub    $0x4,%esp
    unsigned int exec = syscall_get_arg2();
  105265:	e8 86 fd ff ff       	call   104ff0 <syscall_get_arg2>
  10526a:	89 c3                	mov    %eax,%ebx
    unsigned int quota = syscall_get_arg3();
  10526c:	e8 9f fd ff ff       	call   105010 <syscall_get_arg3>
    unsigned int ret_val;
    switch (exec){
  105271:	83 fb 02             	cmp    $0x2,%ebx
  105274:	0f 84 7e 00 00 00    	je     1052f8 <sys_spawn+0x98>
  10527a:	83 fb 03             	cmp    $0x3,%ebx
  10527d:	74 61                	je     1052e0 <sys_spawn+0x80>
  10527f:	83 fb 01             	cmp    $0x1,%ebx
  105282:	74 24                	je     1052a8 <sys_spawn+0x48>
            ret_val = proc_create(_binary___obj_user_pingpong_pong_start, quota); break;
        case 3:
            ret_val = proc_create(_binary___obj_user_pingpong_ding_start, quota); break;

    }
    if(ret_val == NUM_IDS){
  105284:	83 fe 40             	cmp    $0x40,%esi
  105287:	74 37                	je     1052c0 <sys_spawn+0x60>
        syscall_set_errno(E_INVAL_PID);
        syscall_set_retval1(NUM_IDS);
    }
    else{
        syscall_set_errno(E_SUCC);
  105289:	83 ec 0c             	sub    $0xc,%esp
  10528c:	6a 00                	push   $0x0
  10528e:	e8 fd fd ff ff       	call   105090 <syscall_set_errno>
        syscall_set_retval1(ret_val);
  105293:	89 34 24             	mov    %esi,(%esp)
  105296:	e8 15 fe ff ff       	call   1050b0 <syscall_set_retval1>
  10529b:	83 c4 10             	add    $0x10,%esp
    }


}
  10529e:	83 c4 04             	add    $0x4,%esp
  1052a1:	5b                   	pop    %ebx
  1052a2:	5e                   	pop    %esi
  1052a3:	c3                   	ret    
  1052a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    unsigned int exec = syscall_get_arg2();
    unsigned int quota = syscall_get_arg3();
    unsigned int ret_val;
    switch (exec){
        case 1:
            ret_val = proc_create(_binary___obj_user_pingpong_ping_start, quota); break;
  1052a8:	83 ec 08             	sub    $0x8,%esp
  1052ab:	50                   	push   %eax
  1052ac:	68 e0 13 11 00       	push   $0x1113e0
  1052b1:	e8 9a fc ff ff       	call   104f50 <proc_create>
  1052b6:	89 c6                	mov    %eax,%esi
  1052b8:	83 c4 10             	add    $0x10,%esp
            ret_val = proc_create(_binary___obj_user_pingpong_pong_start, quota); break;
        case 3:
            ret_val = proc_create(_binary___obj_user_pingpong_ding_start, quota); break;

    }
    if(ret_val == NUM_IDS){
  1052bb:	83 fe 40             	cmp    $0x40,%esi
  1052be:	75 c9                	jne    105289 <sys_spawn+0x29>
        syscall_set_errno(E_INVAL_PID);
  1052c0:	83 ec 0c             	sub    $0xc,%esp
  1052c3:	6a 05                	push   $0x5
  1052c5:	e8 c6 fd ff ff       	call   105090 <syscall_set_errno>
        syscall_set_retval1(NUM_IDS);
  1052ca:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
  1052d1:	e8 da fd ff ff       	call   1050b0 <syscall_set_retval1>
  1052d6:	83 c4 10             	add    $0x10,%esp
        syscall_set_errno(E_SUCC);
        syscall_set_retval1(ret_val);
    }


}
  1052d9:	83 c4 04             	add    $0x4,%esp
  1052dc:	5b                   	pop    %ebx
  1052dd:	5e                   	pop    %esi
  1052de:	c3                   	ret    
  1052df:	90                   	nop
        case 1:
            ret_val = proc_create(_binary___obj_user_pingpong_ping_start, quota); break;
        case 2:
            ret_val = proc_create(_binary___obj_user_pingpong_pong_start, quota); break;
        case 3:
            ret_val = proc_create(_binary___obj_user_pingpong_ding_start, quota); break;
  1052e0:	83 ec 08             	sub    $0x8,%esp
  1052e3:	50                   	push   %eax
  1052e4:	68 40 e1 11 00       	push   $0x11e140
  1052e9:	e8 62 fc ff ff       	call   104f50 <proc_create>
  1052ee:	83 c4 10             	add    $0x10,%esp
  1052f1:	89 c6                	mov    %eax,%esi
  1052f3:	eb 8f                	jmp    105284 <sys_spawn+0x24>
  1052f5:	8d 76 00             	lea    0x0(%esi),%esi
    unsigned int ret_val;
    switch (exec){
        case 1:
            ret_val = proc_create(_binary___obj_user_pingpong_ping_start, quota); break;
        case 2:
            ret_val = proc_create(_binary___obj_user_pingpong_pong_start, quota); break;
  1052f8:	83 ec 08             	sub    $0x8,%esp
  1052fb:	50                   	push   %eax
  1052fc:	68 90 7a 11 00       	push   $0x117a90
  105301:	e8 4a fc ff ff       	call   104f50 <proc_create>
  105306:	83 c4 10             	add    $0x10,%esp
  105309:	89 c6                	mov    %eax,%esi
  10530b:	e9 74 ff ff ff       	jmp    105284 <sys_spawn+0x24>

00105310 <sys_yield>:
  *  - Simply yield.
  *  Hint 2:
  *  - Do not forget to set the error number as E_SUCC.
  */
void sys_yield(void)
{
  105310:	83 ec 0c             	sub    $0xc,%esp
    thread_yield();
  105313:	e8 18 fb ff ff       	call   104e30 <thread_yield>
    syscall_set_errno(E_SUCC);
  105318:	83 ec 0c             	sub    $0xc,%esp
  10531b:	6a 00                	push   $0x0
  10531d:	e8 6e fd ff ff       	call   105090 <syscall_set_errno>
  105322:	83 c4 1c             	add    $0x1c,%esp
  105325:	c3                   	ret    
  105326:	66 90                	xchg   %ax,%ax
  105328:	66 90                	xchg   %ax,%ax
  10532a:	66 90                	xchg   %ax,%ax
  10532c:	66 90                	xchg   %ax,%ax
  10532e:	66 90                	xchg   %ax,%ax

00105330 <syscall_dispatch>:
  *   In case an invalid syscall number is provided, set the errno to: E_INVAL_CALLNR
  *   (error numbers defined in lib/syscall.h)
  *   
  */
void syscall_dispatch(void)
{
  105330:	83 ec 0c             	sub    $0xc,%esp
	unsigned int sys_call_number = syscall_get_arg1();
  105333:	e8 98 fc ff ff       	call   104fd0 <syscall_get_arg1>
	switch(sys_call_number){
  105338:	83 f8 01             	cmp    $0x1,%eax
  10533b:	74 43                	je     105380 <syscall_dispatch+0x50>
  10533d:	72 31                	jb     105370 <syscall_dispatch+0x40>
  10533f:	83 f8 02             	cmp    $0x2,%eax
  105342:	74 1c                	je     105360 <syscall_dispatch+0x30>
  105344:	83 f8 03             	cmp    $0x3,%eax
  105347:	75 0d                	jne    105356 <syscall_dispatch+0x26>
	    case E_INVAL_CALLNR:
	        syscall_set_errno(E_INVAL_CALLNR);break;
  105349:	83 ec 0c             	sub    $0xc,%esp
  10534c:	6a 03                	push   $0x3
  10534e:	e8 3d fd ff ff       	call   105090 <syscall_set_errno>
  105353:	83 c4 10             	add    $0x10,%esp
	    case SYS_yield:
	        sys_yield();break;
	    case SYS_spawn:
	        sys_spawn(); break;
	}
}
  105356:	83 c4 0c             	add    $0xc,%esp
  105359:	c3                   	ret    
  10535a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105360:	83 c4 0c             	add    $0xc,%esp
	    case E_INVAL_CALLNR:
	        syscall_set_errno(E_INVAL_CALLNR);break;
	    case SYS_puts:
	        sys_puts();break;
	    case SYS_yield:
	        sys_yield();break;
  105363:	e9 a8 ff ff ff       	jmp    105310 <sys_yield>
  105368:	90                   	nop
  105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	    case SYS_spawn:
	        sys_spawn(); break;
	}
}
  105370:	83 c4 0c             	add    $0xc,%esp
	unsigned int sys_call_number = syscall_get_arg1();
	switch(sys_call_number){
	    case E_INVAL_CALLNR:
	        syscall_set_errno(E_INVAL_CALLNR);break;
	    case SYS_puts:
	        sys_puts();break;
  105373:	e9 d8 fd ff ff       	jmp    105150 <sys_puts>
  105378:	90                   	nop
  105379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	    case SYS_yield:
	        sys_yield();break;
	    case SYS_spawn:
	        sys_spawn(); break;
	}
}
  105380:	83 c4 0c             	add    $0xc,%esp
	    case SYS_puts:
	        sys_puts();break;
	    case SYS_yield:
	        sys_yield();break;
	    case SYS_spawn:
	        sys_spawn(); break;
  105383:	e9 d8 fe ff ff       	jmp    105260 <sys_spawn>
  105388:	66 90                	xchg   %ax,%ax
  10538a:	66 90                	xchg   %ax,%ax
  10538c:	66 90                	xchg   %ax,%ax
  10538e:	66 90                	xchg   %ax,%ax

00105390 <default_exception_handler>:
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->esp, tf->esp);
	KERN_DEBUG("\t%08x:\tss:    \t\t%08x\n", &tf->ss, tf->ss);
}

void default_exception_handler(void)
{
  105390:	57                   	push   %edi
  105391:	56                   	push   %esi
  105392:	53                   	push   %ebx
	unsigned int cur_pid;

	cur_pid = get_curid();
  105393:	e8 08 fa ff ff       	call   104da0 <get_curid>
	trap_dump(&uctx_pool[cur_pid]);
  105398:	89 c2                	mov    %eax,%edx
  10539a:	c1 e2 06             	shl    $0x6,%edx
  10539d:	8d 34 82             	lea    (%edx,%eax,4),%esi
  1053a0:	8d 9e 20 cb de 01    	lea    0x1decb20(%esi),%ebx
	KERN_DEBUG("trapframe at %x\n", base);
	KERN_DEBUG("\t%08x:\tedi:   \t\t%08x\n", &tf->regs.edi, tf->regs.edi);
	KERN_DEBUG("\t%08x:\tesi:   \t\t%08x\n", &tf->regs.esi, tf->regs.esi);
	KERN_DEBUG("\t%08x:\tebp:   \t\t%08x\n", &tf->regs.ebp, tf->regs.ebp);
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
	KERN_DEBUG("\t%08x:\tebx:   \t\t%08x\n", &tf->regs.ebx, tf->regs.ebx);
  1053a6:	8d be 30 cb de 01    	lea    0x1decb30(%esi),%edi
	if (tf == NULL)
		return;

	uintptr_t base = (uintptr_t) tf;

	KERN_DEBUG("trapframe at %x\n", base);
  1053ac:	53                   	push   %ebx
  1053ad:	68 ed 64 10 00       	push   $0x1064ed
  1053b2:	6a 15                	push   $0x15
  1053b4:	68 74 66 10 00       	push   $0x106674
  1053b9:	e8 d0 c8 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tedi:   \t\t%08x\n", &tf->regs.edi, tf->regs.edi);
  1053be:	58                   	pop    %eax
  1053bf:	ff b6 20 cb de 01    	pushl  0x1decb20(%esi)
  1053c5:	53                   	push   %ebx
  1053c6:	68 fe 64 10 00       	push   $0x1064fe
  1053cb:	6a 16                	push   $0x16
  1053cd:	68 74 66 10 00       	push   $0x106674
  1053d2:	e8 b7 c8 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tesi:   \t\t%08x\n", &tf->regs.esi, tf->regs.esi);
  1053d7:	8d 43 04             	lea    0x4(%ebx),%eax
  1053da:	83 c4 14             	add    $0x14,%esp
  1053dd:	ff 73 04             	pushl  0x4(%ebx)
  1053e0:	50                   	push   %eax
  1053e1:	68 14 65 10 00       	push   $0x106514
  1053e6:	6a 17                	push   $0x17
  1053e8:	68 74 66 10 00       	push   $0x106674
  1053ed:	e8 9c c8 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tebp:   \t\t%08x\n", &tf->regs.ebp, tf->regs.ebp);
  1053f2:	8d 43 08             	lea    0x8(%ebx),%eax
  1053f5:	83 c4 14             	add    $0x14,%esp
  1053f8:	ff 73 08             	pushl  0x8(%ebx)
  1053fb:	50                   	push   %eax
  1053fc:	68 2a 65 10 00       	push   $0x10652a
  105401:	6a 18                	push   $0x18
  105403:	68 74 66 10 00       	push   $0x106674
  105408:	e8 81 c8 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
  10540d:	8d 43 0c             	lea    0xc(%ebx),%eax
  105410:	83 c4 14             	add    $0x14,%esp
  105413:	ff 73 0c             	pushl  0xc(%ebx)
  105416:	50                   	push   %eax
  105417:	68 40 65 10 00       	push   $0x106540
  10541c:	6a 19                	push   $0x19
  10541e:	68 74 66 10 00       	push   $0x106674
  105423:	e8 66 c8 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tebx:   \t\t%08x\n", &tf->regs.ebx, tf->regs.ebx);
  105428:	83 c4 14             	add    $0x14,%esp
  10542b:	ff 73 10             	pushl  0x10(%ebx)
  10542e:	57                   	push   %edi
  10542f:	68 56 65 10 00       	push   $0x106556
	KERN_DEBUG("\t%08x:\tedx:   \t\t%08x\n", &tf->regs.edx, tf->regs.edx);
	KERN_DEBUG("\t%08x:\tecx:   \t\t%08x\n", &tf->regs.ecx, tf->regs.ecx);
	KERN_DEBUG("\t%08x:\teax:   \t\t%08x\n", &tf->regs.eax, tf->regs.eax);
  105434:	8d be 3c cb de 01    	lea    0x1decb3c(%esi),%edi
	KERN_DEBUG("trapframe at %x\n", base);
	KERN_DEBUG("\t%08x:\tedi:   \t\t%08x\n", &tf->regs.edi, tf->regs.edi);
	KERN_DEBUG("\t%08x:\tesi:   \t\t%08x\n", &tf->regs.esi, tf->regs.esi);
	KERN_DEBUG("\t%08x:\tebp:   \t\t%08x\n", &tf->regs.ebp, tf->regs.ebp);
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
	KERN_DEBUG("\t%08x:\tebx:   \t\t%08x\n", &tf->regs.ebx, tf->regs.ebx);
  10543a:	6a 1a                	push   $0x1a
  10543c:	68 74 66 10 00       	push   $0x106674
  105441:	e8 48 c8 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tedx:   \t\t%08x\n", &tf->regs.edx, tf->regs.edx);
  105446:	8d 86 34 cb de 01    	lea    0x1decb34(%esi),%eax
  10544c:	83 c4 14             	add    $0x14,%esp
  10544f:	ff 73 14             	pushl  0x14(%ebx)
  105452:	50                   	push   %eax
  105453:	68 6c 65 10 00       	push   $0x10656c
  105458:	6a 1b                	push   $0x1b
  10545a:	68 74 66 10 00       	push   $0x106674
  10545f:	e8 2a c8 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tecx:   \t\t%08x\n", &tf->regs.ecx, tf->regs.ecx);
  105464:	8d 86 38 cb de 01    	lea    0x1decb38(%esi),%eax
  10546a:	83 c4 14             	add    $0x14,%esp
  10546d:	ff 73 18             	pushl  0x18(%ebx)
  105470:	50                   	push   %eax
  105471:	68 82 65 10 00       	push   $0x106582
  105476:	6a 1c                	push   $0x1c
  105478:	68 74 66 10 00       	push   $0x106674
  10547d:	e8 0c c8 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\teax:   \t\t%08x\n", &tf->regs.eax, tf->regs.eax);
  105482:	83 c4 14             	add    $0x14,%esp
  105485:	ff 73 1c             	pushl  0x1c(%ebx)
  105488:	57                   	push   %edi
  105489:	68 98 65 10 00       	push   $0x106598
	KERN_DEBUG("\t%08x:\tes:    \t\t%08x\n", &tf->es, tf->es);
  10548e:	8d be 40 cb de 01    	lea    0x1decb40(%esi),%edi
	KERN_DEBUG("\t%08x:\tebp:   \t\t%08x\n", &tf->regs.ebp, tf->regs.ebp);
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
	KERN_DEBUG("\t%08x:\tebx:   \t\t%08x\n", &tf->regs.ebx, tf->regs.ebx);
	KERN_DEBUG("\t%08x:\tedx:   \t\t%08x\n", &tf->regs.edx, tf->regs.edx);
	KERN_DEBUG("\t%08x:\tecx:   \t\t%08x\n", &tf->regs.ecx, tf->regs.ecx);
	KERN_DEBUG("\t%08x:\teax:   \t\t%08x\n", &tf->regs.eax, tf->regs.eax);
  105494:	6a 1d                	push   $0x1d
  105496:	68 74 66 10 00       	push   $0x106674
  10549b:	e8 ee c7 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tes:    \t\t%08x\n", &tf->es, tf->es);
  1054a0:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
  1054a4:	83 c4 14             	add    $0x14,%esp
  1054a7:	50                   	push   %eax
  1054a8:	57                   	push   %edi
	KERN_DEBUG("\t%08x:\tds:    \t\t%08x\n", &tf->ds, tf->ds);
	KERN_DEBUG("\t%08x:\ttrapno:\t\t%08x\n", &tf->trapno, tf->trapno);
	KERN_DEBUG("\t%08x:\terr:   \t\t%08x\n", &tf->err, tf->err);
  1054a9:	8d be 4c cb de 01    	lea    0x1decb4c(%esi),%edi
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->regs.oesp, tf->regs.oesp);
	KERN_DEBUG("\t%08x:\tebx:   \t\t%08x\n", &tf->regs.ebx, tf->regs.ebx);
	KERN_DEBUG("\t%08x:\tedx:   \t\t%08x\n", &tf->regs.edx, tf->regs.edx);
	KERN_DEBUG("\t%08x:\tecx:   \t\t%08x\n", &tf->regs.ecx, tf->regs.ecx);
	KERN_DEBUG("\t%08x:\teax:   \t\t%08x\n", &tf->regs.eax, tf->regs.eax);
	KERN_DEBUG("\t%08x:\tes:    \t\t%08x\n", &tf->es, tf->es);
  1054af:	68 ae 65 10 00       	push   $0x1065ae
  1054b4:	6a 1e                	push   $0x1e
  1054b6:	68 74 66 10 00       	push   $0x106674
  1054bb:	e8 ce c7 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tds:    \t\t%08x\n", &tf->ds, tf->ds);
  1054c0:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
  1054c4:	83 c4 14             	add    $0x14,%esp
  1054c7:	50                   	push   %eax
  1054c8:	8d 86 44 cb de 01    	lea    0x1decb44(%esi),%eax
  1054ce:	50                   	push   %eax
  1054cf:	68 c4 65 10 00       	push   $0x1065c4
  1054d4:	6a 1f                	push   $0x1f
  1054d6:	68 74 66 10 00       	push   $0x106674
  1054db:	e8 ae c7 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\ttrapno:\t\t%08x\n", &tf->trapno, tf->trapno);
  1054e0:	8d 86 48 cb de 01    	lea    0x1decb48(%esi),%eax
  1054e6:	83 c4 14             	add    $0x14,%esp
  1054e9:	ff 73 28             	pushl  0x28(%ebx)
  1054ec:	50                   	push   %eax
  1054ed:	68 da 65 10 00       	push   $0x1065da
  1054f2:	6a 20                	push   $0x20
  1054f4:	68 74 66 10 00       	push   $0x106674
  1054f9:	e8 90 c7 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\terr:   \t\t%08x\n", &tf->err, tf->err);
  1054fe:	83 c4 14             	add    $0x14,%esp
  105501:	ff 73 2c             	pushl  0x2c(%ebx)
  105504:	57                   	push   %edi
  105505:	68 f0 65 10 00       	push   $0x1065f0
	KERN_DEBUG("\t%08x:\teip:   \t\t%08x\n", &tf->eip, tf->eip);
  10550a:	8d be 50 cb de 01    	lea    0x1decb50(%esi),%edi
	KERN_DEBUG("\t%08x:\tecx:   \t\t%08x\n", &tf->regs.ecx, tf->regs.ecx);
	KERN_DEBUG("\t%08x:\teax:   \t\t%08x\n", &tf->regs.eax, tf->regs.eax);
	KERN_DEBUG("\t%08x:\tes:    \t\t%08x\n", &tf->es, tf->es);
	KERN_DEBUG("\t%08x:\tds:    \t\t%08x\n", &tf->ds, tf->ds);
	KERN_DEBUG("\t%08x:\ttrapno:\t\t%08x\n", &tf->trapno, tf->trapno);
	KERN_DEBUG("\t%08x:\terr:   \t\t%08x\n", &tf->err, tf->err);
  105510:	6a 21                	push   $0x21
  105512:	68 74 66 10 00       	push   $0x106674
  105517:	e8 72 c7 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\teip:   \t\t%08x\n", &tf->eip, tf->eip);
  10551c:	83 c4 14             	add    $0x14,%esp
  10551f:	ff 73 30             	pushl  0x30(%ebx)
  105522:	57                   	push   %edi
  105523:	68 06 66 10 00       	push   $0x106606
	KERN_DEBUG("\t%08x:\tcs:    \t\t%08x\n", &tf->cs, tf->cs);
	KERN_DEBUG("\t%08x:\teflags:\t\t%08x\n", &tf->eflags, tf->eflags);
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->esp, tf->esp);
  105528:	8d be 5c cb de 01    	lea    0x1decb5c(%esi),%edi
	KERN_DEBUG("\t%08x:\teax:   \t\t%08x\n", &tf->regs.eax, tf->regs.eax);
	KERN_DEBUG("\t%08x:\tes:    \t\t%08x\n", &tf->es, tf->es);
	KERN_DEBUG("\t%08x:\tds:    \t\t%08x\n", &tf->ds, tf->ds);
	KERN_DEBUG("\t%08x:\ttrapno:\t\t%08x\n", &tf->trapno, tf->trapno);
	KERN_DEBUG("\t%08x:\terr:   \t\t%08x\n", &tf->err, tf->err);
	KERN_DEBUG("\t%08x:\teip:   \t\t%08x\n", &tf->eip, tf->eip);
  10552e:	6a 22                	push   $0x22
  105530:	68 74 66 10 00       	push   $0x106674
  105535:	e8 54 c7 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tcs:    \t\t%08x\n", &tf->cs, tf->cs);
  10553a:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  10553e:	83 c4 14             	add    $0x14,%esp
  105541:	50                   	push   %eax
  105542:	8d 86 54 cb de 01    	lea    0x1decb54(%esi),%eax
  105548:	50                   	push   %eax
  105549:	68 1c 66 10 00       	push   $0x10661c
  10554e:	6a 23                	push   $0x23
  105550:	68 74 66 10 00       	push   $0x106674
  105555:	e8 34 c7 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\teflags:\t\t%08x\n", &tf->eflags, tf->eflags);
  10555a:	8d 86 58 cb de 01    	lea    0x1decb58(%esi),%eax
  105560:	83 c4 14             	add    $0x14,%esp
  105563:	ff 73 38             	pushl  0x38(%ebx)
  105566:	50                   	push   %eax
  105567:	68 32 66 10 00       	push   $0x106632
  10556c:	6a 24                	push   $0x24
  10556e:	68 74 66 10 00       	push   $0x106674
  105573:	e8 16 c7 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->esp, tf->esp);
  105578:	83 c4 14             	add    $0x14,%esp
  10557b:	ff 73 3c             	pushl  0x3c(%ebx)
	KERN_DEBUG("\t%08x:\tss:    \t\t%08x\n", &tf->ss, tf->ss);
  10557e:	81 c6 60 cb de 01    	add    $0x1decb60,%esi
	KERN_DEBUG("\t%08x:\ttrapno:\t\t%08x\n", &tf->trapno, tf->trapno);
	KERN_DEBUG("\t%08x:\terr:   \t\t%08x\n", &tf->err, tf->err);
	KERN_DEBUG("\t%08x:\teip:   \t\t%08x\n", &tf->eip, tf->eip);
	KERN_DEBUG("\t%08x:\tcs:    \t\t%08x\n", &tf->cs, tf->cs);
	KERN_DEBUG("\t%08x:\teflags:\t\t%08x\n", &tf->eflags, tf->eflags);
	KERN_DEBUG("\t%08x:\tesp:   \t\t%08x\n", &tf->esp, tf->esp);
  105584:	57                   	push   %edi
  105585:	68 40 65 10 00       	push   $0x106540
  10558a:	6a 25                	push   $0x25
  10558c:	68 74 66 10 00       	push   $0x106674
  105591:	e8 f8 c6 ff ff       	call   101c8e <debug_normal>
	KERN_DEBUG("\t%08x:\tss:    \t\t%08x\n", &tf->ss, tf->ss);
  105596:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
  10559a:	83 c4 14             	add    $0x14,%esp
  10559d:	50                   	push   %eax
  10559e:	56                   	push   %esi
  10559f:	68 48 66 10 00       	push   $0x106648
  1055a4:	6a 26                	push   $0x26
  1055a6:	68 74 66 10 00       	push   $0x106674
  1055ab:	e8 de c6 ff ff       	call   101c8e <debug_normal>
	unsigned int cur_pid;

	cur_pid = get_curid();
	trap_dump(&uctx_pool[cur_pid]);

	KERN_PANIC("Trap %d @ 0x%08x.\n", uctx_pool[cur_pid].trapno, uctx_pool[cur_pid].eip);
  1055b0:	83 c4 14             	add    $0x14,%esp
  1055b3:	ff 73 30             	pushl  0x30(%ebx)
  1055b6:	ff 73 28             	pushl  0x28(%ebx)
  1055b9:	68 5e 66 10 00       	push   $0x10665e
  1055be:	6a 30                	push   $0x30
  1055c0:	68 74 66 10 00       	push   $0x106674
  1055c5:	e8 ee c6 ff ff       	call   101cb8 <debug_panic>
}
  1055ca:	83 c4 20             	add    $0x20,%esp
  1055cd:	5b                   	pop    %ebx
  1055ce:	5e                   	pop    %esi
  1055cf:	5f                   	pop    %edi
  1055d0:	c3                   	ret    
  1055d1:	eb 0d                	jmp    1055e0 <pgflt_handler>
  1055d3:	90                   	nop
  1055d4:	90                   	nop
  1055d5:	90                   	nop
  1055d6:	90                   	nop
  1055d7:	90                   	nop
  1055d8:	90                   	nop
  1055d9:	90                   	nop
  1055da:	90                   	nop
  1055db:	90                   	nop
  1055dc:	90                   	nop
  1055dd:	90                   	nop
  1055de:	90                   	nop
  1055df:	90                   	nop

001055e0 <pgflt_handler>:

void pgflt_handler(void)
{
  1055e0:	57                   	push   %edi
  1055e1:	56                   	push   %esi
  1055e2:	53                   	push   %ebx
	unsigned int cur_pid;
	unsigned int errno;
	unsigned int fault_va;
	unsigned int pte_entry;

	cur_pid = get_curid();
  1055e3:	e8 b8 f7 ff ff       	call   104da0 <get_curid>
  1055e8:	89 c3                	mov    %eax,%ebx
	errno = uctx_pool[cur_pid].err;
  1055ea:	c1 e0 06             	shl    $0x6,%eax
  1055ed:	8b b4 98 4c cb de 01 	mov    0x1decb4c(%eax,%ebx,4),%esi
	fault_va = rcr2();
  1055f4:	e8 27 d0 ff ff       	call   102620 <rcr2>
  1055f9:	89 c7                	mov    %eax,%edi
	 */

  //Uncomment this line if you need to see the information of the sequence of page faults occured.
	//KERN_DEBUG("Page fault: VA 0x%08x, errno 0x%08x, process %d, EIP 0x%08x.\n", fault_va, errno, cur_pid, uctx_pool[cur_pid].eip);

	if (errno & PFE_PR) {
  1055fb:	f7 c6 01 00 00 00    	test   $0x1,%esi
  105601:	75 1d                	jne    105620 <pgflt_handler+0x40>
		KERN_PANIC("Permission denied: va = 0x%08x, errno = 0x%08x.\n", fault_va, errno);
		return;
	}

	if (alloc_page(cur_pid, fault_va, PTE_W | PTE_U | PTE_P) == MagicNumber)
  105603:	83 ec 04             	sub    $0x4,%esp
  105606:	6a 07                	push   $0x7
  105608:	50                   	push   %eax
  105609:	53                   	push   %ebx
  10560a:	e8 41 ed ff ff       	call   104350 <alloc_page>
  10560f:	83 c4 10             	add    $0x10,%esp
  105612:	3d 01 00 10 00       	cmp    $0x100001,%eax
  105617:	74 27                	je     105640 <pgflt_handler+0x60>
    KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n", fault_va, errno);

}
  105619:	5b                   	pop    %ebx
  10561a:	5e                   	pop    %esi
  10561b:	5f                   	pop    %edi
  10561c:	c3                   	ret    
  10561d:	8d 76 00             	lea    0x0(%esi),%esi

  //Uncomment this line if you need to see the information of the sequence of page faults occured.
	//KERN_DEBUG("Page fault: VA 0x%08x, errno 0x%08x, process %d, EIP 0x%08x.\n", fault_va, errno, cur_pid, uctx_pool[cur_pid].eip);

	if (errno & PFE_PR) {
		KERN_PANIC("Permission denied: va = 0x%08x, errno = 0x%08x.\n", fault_va, errno);
  105620:	83 ec 0c             	sub    $0xc,%esp
  105623:	56                   	push   %esi
  105624:	50                   	push   %eax
  105625:	68 9c 66 10 00       	push   $0x10669c
  10562a:	6a 47                	push   $0x47
  10562c:	68 74 66 10 00       	push   $0x106674
  105631:	e8 82 c6 ff ff       	call   101cb8 <debug_panic>
		return;
  105636:	83 c4 20             	add    $0x20,%esp
	}

	if (alloc_page(cur_pid, fault_va, PTE_W | PTE_U | PTE_P) == MagicNumber)
    KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n", fault_va, errno);

}
  105639:	5b                   	pop    %ebx
  10563a:	5e                   	pop    %esi
  10563b:	5f                   	pop    %edi
  10563c:	c3                   	ret    
  10563d:	8d 76 00             	lea    0x0(%esi),%esi
		KERN_PANIC("Permission denied: va = 0x%08x, errno = 0x%08x.\n", fault_va, errno);
		return;
	}

	if (alloc_page(cur_pid, fault_va, PTE_W | PTE_U | PTE_P) == MagicNumber)
    KERN_PANIC("Page allocation failed: va = 0x%08x, errno = 0x%08x.\n", fault_va, errno);
  105640:	83 ec 0c             	sub    $0xc,%esp
  105643:	56                   	push   %esi
  105644:	57                   	push   %edi
  105645:	68 d0 66 10 00       	push   $0x1066d0
  10564a:	6a 4c                	push   $0x4c
  10564c:	68 74 66 10 00       	push   $0x106674
  105651:	e8 62 c6 ff ff       	call   101cb8 <debug_panic>
  105656:	83 c4 20             	add    $0x20,%esp

}
  105659:	5b                   	pop    %ebx
  10565a:	5e                   	pop    %esi
  10565b:	5f                   	pop    %edi
  10565c:	c3                   	ret    
  10565d:	8d 76 00             	lea    0x0(%esi),%esi

00105660 <exception_handler>:

void exception_handler(void)
{
  105660:	83 ec 0c             	sub    $0xc,%esp
    unsigned int curid, syscall_num; 
  
    curid = get_curid();
  105663:	e8 38 f7 ff ff       	call   104da0 <get_curid>
    syscall_num = uctx_pool[curid].trapno;
  105668:	89 c2                	mov    %eax,%edx
  10566a:	c1 e2 06             	shl    $0x6,%edx
  
    switch (syscall_num) {
  10566d:	83 bc 82 48 cb de 01 	cmpl   $0xe,0x1decb48(%edx,%eax,4)
  105674:	0e 
  105675:	74 09                	je     105680 <exception_handler+0x20>
        break;
  
      default: 
        default_exception_handler();
   }
}
  105677:	83 c4 0c             	add    $0xc,%esp
      case T_PGFLT:
        pgflt_handler();
        break;
  
      default: 
        default_exception_handler();
  10567a:	e9 11 fd ff ff       	jmp    105390 <default_exception_handler>
  10567f:	90                   	nop
   }
}
  105680:	83 c4 0c             	add    $0xc,%esp
    curid = get_curid();
    syscall_num = uctx_pool[curid].trapno;
  
    switch (syscall_num) {
      case T_PGFLT:
        pgflt_handler();
  105683:	e9 58 ff ff ff       	jmp    1055e0 <pgflt_handler>
  105688:	90                   	nop
  105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105690 <interrupt_handler>:
    intr_eoi ();
    return 0;
}

void interrupt_handler (void)
{
  105690:	83 ec 0c             	sub    $0xc,%esp
    unsigned int curid, intr;
  
    curid = get_curid();
  105693:	e8 08 f7 ff ff       	call   104da0 <get_curid>
    intr = uctx_pool[curid].trapno;
  105698:	89 c2                	mov    %eax,%edx
  10569a:	c1 e2 06             	shl    $0x6,%edx
  
    // dprintf("interrupt handler: intr = %d", intr);
  
    switch (intr) {
  10569d:	8b 84 82 48 cb de 01 	mov    0x1decb48(%edx,%eax,4),%eax
  1056a4:	83 f8 20             	cmp    $0x20,%eax
  1056a7:	74 0f                	je     1056b8 <interrupt_handler+0x28>
  1056a9:	83 f8 27             	cmp    $0x27,%eax
  1056ac:	75 0a                	jne    1056b8 <interrupt_handler+0x28>
        break;
  
      default:
        default_intr_handler();
  }
}
  1056ae:	83 c4 0c             	add    $0xc,%esp
  1056b1:	c3                   	ret    
  1056b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1056b8:	83 c4 0c             	add    $0xc,%esp
    return 0;
}

static int default_intr_handler (void)
{
    intr_eoi ();
  1056bb:	e9 31 ba ff ff       	jmp    1010f1 <intr_eoi>

001056c0 <save_trap_frame>:
    }
	  // Trap handled: call proc_start_user() to initiate return from trap.
    proc_start_user ();
}

void save_trap_frame(tf_t *tf, tf_t uctx[], unsigned int pid){
  1056c0:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1056c4:	8b 54 24 04          	mov    0x4(%esp),%edx
    uctx[pid].regs.eax = tf->regs.eax;
  1056c8:	89 c1                	mov    %eax,%ecx
  1056ca:	c1 e1 06             	shl    $0x6,%ecx
  1056cd:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  1056d0:	03 44 24 08          	add    0x8(%esp),%eax
  1056d4:	8b 4a 1c             	mov    0x1c(%edx),%ecx
  1056d7:	89 48 1c             	mov    %ecx,0x1c(%eax)
    uctx[pid].regs.ebx = tf->regs.ebx;
  1056da:	8b 4a 10             	mov    0x10(%edx),%ecx
  1056dd:	89 48 10             	mov    %ecx,0x10(%eax)
    uctx[pid].regs.ecx = tf->regs.ecx;
  1056e0:	8b 4a 18             	mov    0x18(%edx),%ecx
  1056e3:	89 48 18             	mov    %ecx,0x18(%eax)
    uctx[pid].regs.edx = tf->regs.edx;
  1056e6:	8b 4a 14             	mov    0x14(%edx),%ecx
  1056e9:	89 48 14             	mov    %ecx,0x14(%eax)
    uctx[pid].regs.esi = tf->regs.esi;
  1056ec:	8b 4a 04             	mov    0x4(%edx),%ecx
  1056ef:	89 48 04             	mov    %ecx,0x4(%eax)
    uctx[pid].regs.edi = tf->regs.edi;
  1056f2:	8b 0a                	mov    (%edx),%ecx
  1056f4:	89 08                	mov    %ecx,(%eax)
    uctx[pid].regs.ebp = tf->regs.ebp;
  1056f6:	8b 4a 08             	mov    0x8(%edx),%ecx
  1056f9:	89 48 08             	mov    %ecx,0x8(%eax)
    uctx[pid].regs.oesp = tf->regs.oesp;
  1056fc:	8b 4a 0c             	mov    0xc(%edx),%ecx
  1056ff:	89 48 0c             	mov    %ecx,0xc(%eax)
    uctx[pid].es = tf->es;
  105702:	0f b7 4a 20          	movzwl 0x20(%edx),%ecx
  105706:	66 89 48 20          	mov    %cx,0x20(%eax)
    uctx[pid].ds = tf->ds;
  10570a:	0f b7 4a 24          	movzwl 0x24(%edx),%ecx
  10570e:	66 89 48 24          	mov    %cx,0x24(%eax)
    uctx[pid].ss = tf->ss;
  105712:	0f b7 4a 40          	movzwl 0x40(%edx),%ecx
  105716:	66 89 48 40          	mov    %cx,0x40(%eax)
    uctx[pid].trapno = tf->trapno;
  10571a:	8b 4a 28             	mov    0x28(%edx),%ecx
  10571d:	89 48 28             	mov    %ecx,0x28(%eax)
    uctx[pid].err = tf->err;
  105720:	8b 4a 2c             	mov    0x2c(%edx),%ecx
  105723:	89 48 2c             	mov    %ecx,0x2c(%eax)
    uctx[pid].eip = tf->eip;
  105726:	8b 4a 30             	mov    0x30(%edx),%ecx
  105729:	89 48 30             	mov    %ecx,0x30(%eax)
    uctx[pid].cs = tf->cs;
  10572c:	0f b7 4a 34          	movzwl 0x34(%edx),%ecx
  105730:	66 89 48 34          	mov    %cx,0x34(%eax)
    uctx[pid].eflags = tf->eflags;
  105734:	8b 4a 38             	mov    0x38(%edx),%ecx
    uctx[pid].esp = tf->esp;
  105737:	8b 52 3c             	mov    0x3c(%edx),%edx
    uctx[pid].ss = tf->ss;
    uctx[pid].trapno = tf->trapno;
    uctx[pid].err = tf->err;
    uctx[pid].eip = tf->eip;
    uctx[pid].cs = tf->cs;
    uctx[pid].eflags = tf->eflags;
  10573a:	89 48 38             	mov    %ecx,0x38(%eax)
    uctx[pid].esp = tf->esp;
  10573d:	89 50 3c             	mov    %edx,0x3c(%eax)
  105740:	c3                   	ret    
  105741:	eb 0d                	jmp    105750 <trap>
  105743:	90                   	nop
  105744:	90                   	nop
  105745:	90                   	nop
  105746:	90                   	nop
  105747:	90                   	nop
  105748:	90                   	nop
  105749:	90                   	nop
  10574a:	90                   	nop
  10574b:	90                   	nop
  10574c:	90                   	nop
  10574d:	90                   	nop
  10574e:	90                   	nop
  10574f:	90                   	nop

00105750 <trap>:
  *
  *  Hint: 
  *  - Please look at _alltraps functions in idt.S
  */
void trap (tf_t *tf)
{
  105750:	56                   	push   %esi
  105751:	53                   	push   %ebx
  105752:	83 ec 04             	sub    $0x4,%esp
  105755:	8b 74 24 10          	mov    0x10(%esp),%esi
    unsigned int pid = get_curid();
  105759:	e8 42 f6 ff ff       	call   104da0 <get_curid>
	save_trap_frame(tf, uctx_pool, pid);
  10575e:	83 ec 04             	sub    $0x4,%esp
  *  Hint: 
  *  - Please look at _alltraps functions in idt.S
  */
void trap (tf_t *tf)
{
    unsigned int pid = get_curid();
  105761:	89 c3                	mov    %eax,%ebx
	save_trap_frame(tf, uctx_pool, pid);
  105763:	50                   	push   %eax
  105764:	68 20 cb de 01       	push   $0x1decb20
  105769:	56                   	push   %esi
  10576a:	e8 51 ff ff ff       	call   1056c0 <save_trap_frame>
    set_pdir_base(0);
  10576f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105776:	e8 15 e0 ff ff       	call   103790 <set_pdir_base>
    unsigned int trapno = uctx_pool[pid].trapno;
  10577b:	89 d8                	mov    %ebx,%eax
    if(trapno >= T_DIVIDE && trapno <= T_SECEV)
  10577d:	83 c4 10             	add    $0x10,%esp
void trap (tf_t *tf)
{
    unsigned int pid = get_curid();
	save_trap_frame(tf, uctx_pool, pid);
    set_pdir_base(0);
    unsigned int trapno = uctx_pool[pid].trapno;
  105780:	c1 e0 06             	shl    $0x6,%eax
  105783:	8b 84 98 48 cb de 01 	mov    0x1decb48(%eax,%ebx,4),%eax
    if(trapno >= T_DIVIDE && trapno <= T_SECEV)
  10578a:	83 f8 1e             	cmp    $0x1e,%eax
  10578d:	76 21                	jbe    1057b0 <trap+0x60>
        exception_handler();
    else if(trapno >=(T_IRQ0 + IRQ_TIMER) && trapno <= (T_IRQ0 + IRQ_IDE2)){
  10578f:	8d 50 e0             	lea    -0x20(%eax),%edx
  105792:	83 fa 0f             	cmp    $0xf,%edx
  105795:	76 29                	jbe    1057c0 <trap+0x70>
        interrupt_handler();
    }
    else if(trapno == T_SYSCALL){
  105797:	83 f8 30             	cmp    $0x30,%eax
  10579a:	74 34                	je     1057d0 <trap+0x80>
        syscall_dispatch();
    }
	  // Trap handled: call proc_start_user() to initiate return from trap.
    proc_start_user ();
}
  10579c:	83 c4 04             	add    $0x4,%esp
  10579f:	5b                   	pop    %ebx
  1057a0:	5e                   	pop    %esi
    }
    else if(trapno == T_SYSCALL){
        syscall_dispatch();
    }
	  // Trap handled: call proc_start_user() to initiate return from trap.
    proc_start_user ();
  1057a1:	e9 6a f7 ff ff       	jmp    104f10 <proc_start_user>
  1057a6:	8d 76 00             	lea    0x0(%esi),%esi
  1057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    unsigned int pid = get_curid();
	save_trap_frame(tf, uctx_pool, pid);
    set_pdir_base(0);
    unsigned int trapno = uctx_pool[pid].trapno;
    if(trapno >= T_DIVIDE && trapno <= T_SECEV)
        exception_handler();
  1057b0:	e8 ab fe ff ff       	call   105660 <exception_handler>
    else if(trapno == T_SYSCALL){
        syscall_dispatch();
    }
	  // Trap handled: call proc_start_user() to initiate return from trap.
    proc_start_user ();
}
  1057b5:	83 c4 04             	add    $0x4,%esp
  1057b8:	5b                   	pop    %ebx
  1057b9:	5e                   	pop    %esi
    }
    else if(trapno == T_SYSCALL){
        syscall_dispatch();
    }
	  // Trap handled: call proc_start_user() to initiate return from trap.
    proc_start_user ();
  1057ba:	e9 51 f7 ff ff       	jmp    104f10 <proc_start_user>
  1057bf:	90                   	nop
    set_pdir_base(0);
    unsigned int trapno = uctx_pool[pid].trapno;
    if(trapno >= T_DIVIDE && trapno <= T_SECEV)
        exception_handler();
    else if(trapno >=(T_IRQ0 + IRQ_TIMER) && trapno <= (T_IRQ0 + IRQ_IDE2)){
        interrupt_handler();
  1057c0:	e8 cb fe ff ff       	call   105690 <interrupt_handler>
    else if(trapno == T_SYSCALL){
        syscall_dispatch();
    }
	  // Trap handled: call proc_start_user() to initiate return from trap.
    proc_start_user ();
}
  1057c5:	83 c4 04             	add    $0x4,%esp
  1057c8:	5b                   	pop    %ebx
  1057c9:	5e                   	pop    %esi
    }
    else if(trapno == T_SYSCALL){
        syscall_dispatch();
    }
	  // Trap handled: call proc_start_user() to initiate return from trap.
    proc_start_user ();
  1057ca:	e9 41 f7 ff ff       	jmp    104f10 <proc_start_user>
  1057cf:	90                   	nop
        exception_handler();
    else if(trapno >=(T_IRQ0 + IRQ_TIMER) && trapno <= (T_IRQ0 + IRQ_IDE2)){
        interrupt_handler();
    }
    else if(trapno == T_SYSCALL){
        syscall_dispatch();
  1057d0:	e8 5b fb ff ff       	call   105330 <syscall_dispatch>
    }
	  // Trap handled: call proc_start_user() to initiate return from trap.
    proc_start_user ();
}
  1057d5:	83 c4 04             	add    $0x4,%esp
  1057d8:	5b                   	pop    %ebx
  1057d9:	5e                   	pop    %esi
    }
    else if(trapno == T_SYSCALL){
        syscall_dispatch();
    }
	  // Trap handled: call proc_start_user() to initiate return from trap.
    proc_start_user ();
  1057da:	e9 31 f7 ff ff       	jmp    104f10 <proc_start_user>
  1057df:	90                   	nop

001057e0 <__udivdi3>:
  1057e0:	55                   	push   %ebp
  1057e1:	57                   	push   %edi
  1057e2:	56                   	push   %esi
  1057e3:	53                   	push   %ebx
  1057e4:	83 ec 1c             	sub    $0x1c,%esp
  1057e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  1057eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  1057ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  1057f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  1057f7:	85 f6                	test   %esi,%esi
  1057f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1057fd:	89 ca                	mov    %ecx,%edx
  1057ff:	89 f8                	mov    %edi,%eax
  105801:	75 3d                	jne    105840 <__udivdi3+0x60>
  105803:	39 cf                	cmp    %ecx,%edi
  105805:	0f 87 c5 00 00 00    	ja     1058d0 <__udivdi3+0xf0>
  10580b:	85 ff                	test   %edi,%edi
  10580d:	89 fd                	mov    %edi,%ebp
  10580f:	75 0b                	jne    10581c <__udivdi3+0x3c>
  105811:	b8 01 00 00 00       	mov    $0x1,%eax
  105816:	31 d2                	xor    %edx,%edx
  105818:	f7 f7                	div    %edi
  10581a:	89 c5                	mov    %eax,%ebp
  10581c:	89 c8                	mov    %ecx,%eax
  10581e:	31 d2                	xor    %edx,%edx
  105820:	f7 f5                	div    %ebp
  105822:	89 c1                	mov    %eax,%ecx
  105824:	89 d8                	mov    %ebx,%eax
  105826:	89 cf                	mov    %ecx,%edi
  105828:	f7 f5                	div    %ebp
  10582a:	89 c3                	mov    %eax,%ebx
  10582c:	89 d8                	mov    %ebx,%eax
  10582e:	89 fa                	mov    %edi,%edx
  105830:	83 c4 1c             	add    $0x1c,%esp
  105833:	5b                   	pop    %ebx
  105834:	5e                   	pop    %esi
  105835:	5f                   	pop    %edi
  105836:	5d                   	pop    %ebp
  105837:	c3                   	ret    
  105838:	90                   	nop
  105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105840:	39 ce                	cmp    %ecx,%esi
  105842:	77 74                	ja     1058b8 <__udivdi3+0xd8>
  105844:	0f bd fe             	bsr    %esi,%edi
  105847:	83 f7 1f             	xor    $0x1f,%edi
  10584a:	0f 84 98 00 00 00    	je     1058e8 <__udivdi3+0x108>
  105850:	bb 20 00 00 00       	mov    $0x20,%ebx
  105855:	89 f9                	mov    %edi,%ecx
  105857:	89 c5                	mov    %eax,%ebp
  105859:	29 fb                	sub    %edi,%ebx
  10585b:	d3 e6                	shl    %cl,%esi
  10585d:	89 d9                	mov    %ebx,%ecx
  10585f:	d3 ed                	shr    %cl,%ebp
  105861:	89 f9                	mov    %edi,%ecx
  105863:	d3 e0                	shl    %cl,%eax
  105865:	09 ee                	or     %ebp,%esi
  105867:	89 d9                	mov    %ebx,%ecx
  105869:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10586d:	89 d5                	mov    %edx,%ebp
  10586f:	8b 44 24 08          	mov    0x8(%esp),%eax
  105873:	d3 ed                	shr    %cl,%ebp
  105875:	89 f9                	mov    %edi,%ecx
  105877:	d3 e2                	shl    %cl,%edx
  105879:	89 d9                	mov    %ebx,%ecx
  10587b:	d3 e8                	shr    %cl,%eax
  10587d:	09 c2                	or     %eax,%edx
  10587f:	89 d0                	mov    %edx,%eax
  105881:	89 ea                	mov    %ebp,%edx
  105883:	f7 f6                	div    %esi
  105885:	89 d5                	mov    %edx,%ebp
  105887:	89 c3                	mov    %eax,%ebx
  105889:	f7 64 24 0c          	mull   0xc(%esp)
  10588d:	39 d5                	cmp    %edx,%ebp
  10588f:	72 10                	jb     1058a1 <__udivdi3+0xc1>
  105891:	8b 74 24 08          	mov    0x8(%esp),%esi
  105895:	89 f9                	mov    %edi,%ecx
  105897:	d3 e6                	shl    %cl,%esi
  105899:	39 c6                	cmp    %eax,%esi
  10589b:	73 07                	jae    1058a4 <__udivdi3+0xc4>
  10589d:	39 d5                	cmp    %edx,%ebp
  10589f:	75 03                	jne    1058a4 <__udivdi3+0xc4>
  1058a1:	83 eb 01             	sub    $0x1,%ebx
  1058a4:	31 ff                	xor    %edi,%edi
  1058a6:	89 d8                	mov    %ebx,%eax
  1058a8:	89 fa                	mov    %edi,%edx
  1058aa:	83 c4 1c             	add    $0x1c,%esp
  1058ad:	5b                   	pop    %ebx
  1058ae:	5e                   	pop    %esi
  1058af:	5f                   	pop    %edi
  1058b0:	5d                   	pop    %ebp
  1058b1:	c3                   	ret    
  1058b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1058b8:	31 ff                	xor    %edi,%edi
  1058ba:	31 db                	xor    %ebx,%ebx
  1058bc:	89 d8                	mov    %ebx,%eax
  1058be:	89 fa                	mov    %edi,%edx
  1058c0:	83 c4 1c             	add    $0x1c,%esp
  1058c3:	5b                   	pop    %ebx
  1058c4:	5e                   	pop    %esi
  1058c5:	5f                   	pop    %edi
  1058c6:	5d                   	pop    %ebp
  1058c7:	c3                   	ret    
  1058c8:	90                   	nop
  1058c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1058d0:	89 d8                	mov    %ebx,%eax
  1058d2:	f7 f7                	div    %edi
  1058d4:	31 ff                	xor    %edi,%edi
  1058d6:	89 c3                	mov    %eax,%ebx
  1058d8:	89 d8                	mov    %ebx,%eax
  1058da:	89 fa                	mov    %edi,%edx
  1058dc:	83 c4 1c             	add    $0x1c,%esp
  1058df:	5b                   	pop    %ebx
  1058e0:	5e                   	pop    %esi
  1058e1:	5f                   	pop    %edi
  1058e2:	5d                   	pop    %ebp
  1058e3:	c3                   	ret    
  1058e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1058e8:	39 ce                	cmp    %ecx,%esi
  1058ea:	72 0c                	jb     1058f8 <__udivdi3+0x118>
  1058ec:	31 db                	xor    %ebx,%ebx
  1058ee:	3b 44 24 08          	cmp    0x8(%esp),%eax
  1058f2:	0f 87 34 ff ff ff    	ja     10582c <__udivdi3+0x4c>
  1058f8:	bb 01 00 00 00       	mov    $0x1,%ebx
  1058fd:	e9 2a ff ff ff       	jmp    10582c <__udivdi3+0x4c>
  105902:	66 90                	xchg   %ax,%ax
  105904:	66 90                	xchg   %ax,%ax
  105906:	66 90                	xchg   %ax,%ax
  105908:	66 90                	xchg   %ax,%ax
  10590a:	66 90                	xchg   %ax,%ax
  10590c:	66 90                	xchg   %ax,%ax
  10590e:	66 90                	xchg   %ax,%ax

00105910 <__umoddi3>:
  105910:	55                   	push   %ebp
  105911:	57                   	push   %edi
  105912:	56                   	push   %esi
  105913:	53                   	push   %ebx
  105914:	83 ec 1c             	sub    $0x1c,%esp
  105917:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  10591b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  10591f:	8b 74 24 34          	mov    0x34(%esp),%esi
  105923:	8b 7c 24 38          	mov    0x38(%esp),%edi
  105927:	85 d2                	test   %edx,%edx
  105929:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10592d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105931:	89 f3                	mov    %esi,%ebx
  105933:	89 3c 24             	mov    %edi,(%esp)
  105936:	89 74 24 04          	mov    %esi,0x4(%esp)
  10593a:	75 1c                	jne    105958 <__umoddi3+0x48>
  10593c:	39 f7                	cmp    %esi,%edi
  10593e:	76 50                	jbe    105990 <__umoddi3+0x80>
  105940:	89 c8                	mov    %ecx,%eax
  105942:	89 f2                	mov    %esi,%edx
  105944:	f7 f7                	div    %edi
  105946:	89 d0                	mov    %edx,%eax
  105948:	31 d2                	xor    %edx,%edx
  10594a:	83 c4 1c             	add    $0x1c,%esp
  10594d:	5b                   	pop    %ebx
  10594e:	5e                   	pop    %esi
  10594f:	5f                   	pop    %edi
  105950:	5d                   	pop    %ebp
  105951:	c3                   	ret    
  105952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105958:	39 f2                	cmp    %esi,%edx
  10595a:	89 d0                	mov    %edx,%eax
  10595c:	77 52                	ja     1059b0 <__umoddi3+0xa0>
  10595e:	0f bd ea             	bsr    %edx,%ebp
  105961:	83 f5 1f             	xor    $0x1f,%ebp
  105964:	75 5a                	jne    1059c0 <__umoddi3+0xb0>
  105966:	3b 54 24 04          	cmp    0x4(%esp),%edx
  10596a:	0f 82 e0 00 00 00    	jb     105a50 <__umoddi3+0x140>
  105970:	39 0c 24             	cmp    %ecx,(%esp)
  105973:	0f 86 d7 00 00 00    	jbe    105a50 <__umoddi3+0x140>
  105979:	8b 44 24 08          	mov    0x8(%esp),%eax
  10597d:	8b 54 24 04          	mov    0x4(%esp),%edx
  105981:	83 c4 1c             	add    $0x1c,%esp
  105984:	5b                   	pop    %ebx
  105985:	5e                   	pop    %esi
  105986:	5f                   	pop    %edi
  105987:	5d                   	pop    %ebp
  105988:	c3                   	ret    
  105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  105990:	85 ff                	test   %edi,%edi
  105992:	89 fd                	mov    %edi,%ebp
  105994:	75 0b                	jne    1059a1 <__umoddi3+0x91>
  105996:	b8 01 00 00 00       	mov    $0x1,%eax
  10599b:	31 d2                	xor    %edx,%edx
  10599d:	f7 f7                	div    %edi
  10599f:	89 c5                	mov    %eax,%ebp
  1059a1:	89 f0                	mov    %esi,%eax
  1059a3:	31 d2                	xor    %edx,%edx
  1059a5:	f7 f5                	div    %ebp
  1059a7:	89 c8                	mov    %ecx,%eax
  1059a9:	f7 f5                	div    %ebp
  1059ab:	89 d0                	mov    %edx,%eax
  1059ad:	eb 99                	jmp    105948 <__umoddi3+0x38>
  1059af:	90                   	nop
  1059b0:	89 c8                	mov    %ecx,%eax
  1059b2:	89 f2                	mov    %esi,%edx
  1059b4:	83 c4 1c             	add    $0x1c,%esp
  1059b7:	5b                   	pop    %ebx
  1059b8:	5e                   	pop    %esi
  1059b9:	5f                   	pop    %edi
  1059ba:	5d                   	pop    %ebp
  1059bb:	c3                   	ret    
  1059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1059c0:	8b 34 24             	mov    (%esp),%esi
  1059c3:	bf 20 00 00 00       	mov    $0x20,%edi
  1059c8:	89 e9                	mov    %ebp,%ecx
  1059ca:	29 ef                	sub    %ebp,%edi
  1059cc:	d3 e0                	shl    %cl,%eax
  1059ce:	89 f9                	mov    %edi,%ecx
  1059d0:	89 f2                	mov    %esi,%edx
  1059d2:	d3 ea                	shr    %cl,%edx
  1059d4:	89 e9                	mov    %ebp,%ecx
  1059d6:	09 c2                	or     %eax,%edx
  1059d8:	89 d8                	mov    %ebx,%eax
  1059da:	89 14 24             	mov    %edx,(%esp)
  1059dd:	89 f2                	mov    %esi,%edx
  1059df:	d3 e2                	shl    %cl,%edx
  1059e1:	89 f9                	mov    %edi,%ecx
  1059e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1059e7:	8b 54 24 0c          	mov    0xc(%esp),%edx
  1059eb:	d3 e8                	shr    %cl,%eax
  1059ed:	89 e9                	mov    %ebp,%ecx
  1059ef:	89 c6                	mov    %eax,%esi
  1059f1:	d3 e3                	shl    %cl,%ebx
  1059f3:	89 f9                	mov    %edi,%ecx
  1059f5:	89 d0                	mov    %edx,%eax
  1059f7:	d3 e8                	shr    %cl,%eax
  1059f9:	89 e9                	mov    %ebp,%ecx
  1059fb:	09 d8                	or     %ebx,%eax
  1059fd:	89 d3                	mov    %edx,%ebx
  1059ff:	89 f2                	mov    %esi,%edx
  105a01:	f7 34 24             	divl   (%esp)
  105a04:	89 d6                	mov    %edx,%esi
  105a06:	d3 e3                	shl    %cl,%ebx
  105a08:	f7 64 24 04          	mull   0x4(%esp)
  105a0c:	39 d6                	cmp    %edx,%esi
  105a0e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  105a12:	89 d1                	mov    %edx,%ecx
  105a14:	89 c3                	mov    %eax,%ebx
  105a16:	72 08                	jb     105a20 <__umoddi3+0x110>
  105a18:	75 11                	jne    105a2b <__umoddi3+0x11b>
  105a1a:	39 44 24 08          	cmp    %eax,0x8(%esp)
  105a1e:	73 0b                	jae    105a2b <__umoddi3+0x11b>
  105a20:	2b 44 24 04          	sub    0x4(%esp),%eax
  105a24:	1b 14 24             	sbb    (%esp),%edx
  105a27:	89 d1                	mov    %edx,%ecx
  105a29:	89 c3                	mov    %eax,%ebx
  105a2b:	8b 54 24 08          	mov    0x8(%esp),%edx
  105a2f:	29 da                	sub    %ebx,%edx
  105a31:	19 ce                	sbb    %ecx,%esi
  105a33:	89 f9                	mov    %edi,%ecx
  105a35:	89 f0                	mov    %esi,%eax
  105a37:	d3 e0                	shl    %cl,%eax
  105a39:	89 e9                	mov    %ebp,%ecx
  105a3b:	d3 ea                	shr    %cl,%edx
  105a3d:	89 e9                	mov    %ebp,%ecx
  105a3f:	d3 ee                	shr    %cl,%esi
  105a41:	09 d0                	or     %edx,%eax
  105a43:	89 f2                	mov    %esi,%edx
  105a45:	83 c4 1c             	add    $0x1c,%esp
  105a48:	5b                   	pop    %ebx
  105a49:	5e                   	pop    %esi
  105a4a:	5f                   	pop    %edi
  105a4b:	5d                   	pop    %ebp
  105a4c:	c3                   	ret    
  105a4d:	8d 76 00             	lea    0x0(%esi),%esi
  105a50:	29 f9                	sub    %edi,%ecx
  105a52:	19 d6                	sbb    %edx,%esi
  105a54:	89 74 24 04          	mov    %esi,0x4(%esp)
  105a58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105a5c:	e9 18 ff ff ff       	jmp    105979 <__umoddi3+0x69>
