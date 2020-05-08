
obj/user/pingpong/pong:     file format elf32-i386


Disassembly of section .text:

40000000 <_start>:
_start:
	/*
	 * If there are arguments on the stack, then the current stack will not
	 * be aligned to a nice big power-of-two boundary/
	 */
	testl	$0x0fffffff, %esp
40000000:	f7 c4 ff ff ff 0f    	test   $0xfffffff,%esp
	jnz	args_exist
40000006:	75 04                	jne    4000000c <args_exist>

40000008 <noargs>:

noargs:
	/* If no arguments are on the stack, push two dummy zero. */
	pushl	$0
40000008:	6a 00                	push   $0x0
	pushl	$0
4000000a:	6a 00                	push   $0x0

4000000c <args_exist>:

args_exist:
	/* Jump to the C part. */
	call	main
4000000c:	e8 c9 0a 00 00       	call   40000ada <main>

	/* When returning, push the return value on the stack. */
	pushl	%eax
40000011:	50                   	push   %eax

40000012 <spin>:
spin:
	/*
	 * TODO: replace yield with exit
	 */
	call	yield
40000012:	e8 20 07 00 00       	call   40000737 <yield>
	jmp	spin
40000017:	eb f9                	jmp    40000012 <spin>

40000019 <debug>:
#include <stdarg.h>
#include <stdio.h>

void
debug(const char *file, int line, const char *fmt, ...)
{
40000019:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[D] %s:%d: ", file, line);
4000001c:	ff 74 24 18          	pushl  0x18(%esp)
40000020:	ff 74 24 18          	pushl  0x18(%esp)
40000024:	68 e4 0d 00 40       	push   $0x40000de4
40000029:	e8 85 01 00 00       	call   400001b3 <printf>
	vcprintf(fmt, ap);
4000002e:	83 c4 08             	add    $0x8,%esp
40000031:	8d 44 24 24          	lea    0x24(%esp),%eax
40000035:	50                   	push   %eax
40000036:	ff 74 24 24          	pushl  0x24(%esp)
4000003a:	e8 20 01 00 00       	call   4000015f <vcprintf>
	va_end(ap);
}
4000003f:	83 c4 1c             	add    $0x1c,%esp
40000042:	c3                   	ret    

40000043 <warn>:

void
warn(const char *file, int line, const char *fmt, ...)
{
40000043:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[W] %s:%d: ", file, line);
40000046:	ff 74 24 18          	pushl  0x18(%esp)
4000004a:	ff 74 24 18          	pushl  0x18(%esp)
4000004e:	68 f0 0d 00 40       	push   $0x40000df0
40000053:	e8 5b 01 00 00       	call   400001b3 <printf>
	vcprintf(fmt, ap);
40000058:	83 c4 08             	add    $0x8,%esp
4000005b:	8d 44 24 24          	lea    0x24(%esp),%eax
4000005f:	50                   	push   %eax
40000060:	ff 74 24 24          	pushl  0x24(%esp)
40000064:	e8 f6 00 00 00       	call   4000015f <vcprintf>
	va_end(ap);
}
40000069:	83 c4 1c             	add    $0x1c,%esp
4000006c:	c3                   	ret    

4000006d <panic>:

void
panic(const char *file, int line, const char *fmt, ...)
{
4000006d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	va_start(ap, fmt);
	printf("[P] %s:%d: ", file, line);
40000070:	ff 74 24 18          	pushl  0x18(%esp)
40000074:	ff 74 24 18          	pushl  0x18(%esp)
40000078:	68 fc 0d 00 40       	push   $0x40000dfc
4000007d:	e8 31 01 00 00       	call   400001b3 <printf>
	vcprintf(fmt, ap);
40000082:	83 c4 08             	add    $0x8,%esp
40000085:	8d 44 24 24          	lea    0x24(%esp),%eax
40000089:	50                   	push   %eax
4000008a:	ff 74 24 24          	pushl  0x24(%esp)
4000008e:	e8 cc 00 00 00       	call   4000015f <vcprintf>
40000093:	83 c4 10             	add    $0x10,%esp
	va_end(ap);

	while (1)
		yield();
40000096:	e8 9c 06 00 00       	call   40000737 <yield>
4000009b:	eb f9                	jmp    40000096 <panic+0x29>

4000009d <atoi>:
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
4000009d:	55                   	push   %ebp
4000009e:	57                   	push   %edi
4000009f:	56                   	push   %esi
400000a0:	53                   	push   %ebx
400000a1:	83 ec 04             	sub    $0x4,%esp
400000a4:	8b 44 24 18          	mov    0x18(%esp),%eax
400000a8:	89 04 24             	mov    %eax,(%esp)
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
	if (buf[loc] == '+')
400000ab:	0f b6 00             	movzbl (%eax),%eax
400000ae:	3c 2b                	cmp    $0x2b,%al
400000b0:	74 10                	je     400000c2 <atoi+0x25>
		loc++;
	else if (buf[loc] == '-') {
400000b2:	3c 2d                	cmp    $0x2d,%al
400000b4:	74 18                	je     400000ce <atoi+0x31>
atoi(const char *buf, int *i)
{
	int loc = 0;
	int numstart = 0;
	int acc = 0;
	int negative = 0;
400000b6:	bf 00 00 00 00       	mov    $0x0,%edi
#include <stdlib.h>

int
atoi(const char *buf, int *i)
{
	int loc = 0;
400000bb:	be 00 00 00 00       	mov    $0x0,%esi
400000c0:	eb 16                	jmp    400000d8 <atoi+0x3b>
	int numstart = 0;
	int acc = 0;
	int negative = 0;
400000c2:	bf 00 00 00 00       	mov    $0x0,%edi
	if (buf[loc] == '+')
		loc++;
400000c7:	be 01 00 00 00       	mov    $0x1,%esi
400000cc:	eb 0a                	jmp    400000d8 <atoi+0x3b>
	else if (buf[loc] == '-') {
		negative = 1;
400000ce:	bf 01 00 00 00       	mov    $0x1,%edi
		loc++;
400000d3:	be 01 00 00 00       	mov    $0x1,%esi
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400000d8:	89 f0                	mov    %esi,%eax
int
atoi(const char *buf, int *i)
{
	int loc = 0;
	int numstart = 0;
	int acc = 0;
400000da:	b9 00 00 00 00       	mov    $0x0,%ecx
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400000df:	eb 11                	jmp    400000f2 <atoi+0x55>
		acc = acc*10 + (buf[loc]-'0');
400000e1:	8d 2c 89             	lea    (%ecx,%ecx,4),%ebp
400000e4:	8d 4c 2d 00          	lea    0x0(%ebp,%ebp,1),%ecx
400000e8:	0f be d2             	movsbl %dl,%edx
400000eb:	8d 4c 11 d0          	lea    -0x30(%ecx,%edx,1),%ecx
		loc++;
400000ef:	83 c0 01             	add    $0x1,%eax
		negative = 1;
		loc++;
	}
	numstart = loc;
	// no grab the numbers
	while ('0' <= buf[loc] && buf[loc] <= '9') {
400000f2:	8b 1c 24             	mov    (%esp),%ebx
400000f5:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
400000f9:	8d 6a d0             	lea    -0x30(%edx),%ebp
400000fc:	89 eb                	mov    %ebp,%ebx
400000fe:	80 fb 09             	cmp    $0x9,%bl
40000101:	76 de                	jbe    400000e1 <atoi+0x44>
		acc = acc*10 + (buf[loc]-'0');
		loc++;
	}
	if (numstart == loc) {
40000103:	39 c6                	cmp    %eax,%esi
40000105:	74 0e                	je     40000115 <atoi+0x78>
		// no numbers have actually been scanned
		return 0;
	}
	if (negative)
40000107:	85 ff                	test   %edi,%edi
40000109:	74 02                	je     4000010d <atoi+0x70>
		acc = - acc;
4000010b:	f7 d9                	neg    %ecx
	*i = acc;
4000010d:	8b 54 24 1c          	mov    0x1c(%esp),%edx
40000111:	89 0a                	mov    %ecx,(%edx)
	return loc;
40000113:	eb 05                	jmp    4000011a <atoi+0x7d>
		acc = acc*10 + (buf[loc]-'0');
		loc++;
	}
	if (numstart == loc) {
		// no numbers have actually been scanned
		return 0;
40000115:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	if (negative)
		acc = - acc;
	*i = acc;
	return loc;
}
4000011a:	83 c4 04             	add    $0x4,%esp
4000011d:	5b                   	pop    %ebx
4000011e:	5e                   	pop    %esi
4000011f:	5f                   	pop    %edi
40000120:	5d                   	pop    %ebp
40000121:	c3                   	ret    

40000122 <putch>:
	char buf[MAX_BUF];
};

static void
putch(int ch, struct printbuf *b)
{
40000122:	53                   	push   %ebx
40000123:	8b 54 24 0c          	mov    0xc(%esp),%edx
	b->buf[b->idx++] = ch;
40000127:	8b 02                	mov    (%edx),%eax
40000129:	8d 48 01             	lea    0x1(%eax),%ecx
4000012c:	89 0a                	mov    %ecx,(%edx)
4000012e:	0f b6 5c 24 08       	movzbl 0x8(%esp),%ebx
40000133:	88 5c 02 08          	mov    %bl,0x8(%edx,%eax,1)
	if (b->idx == MAX_BUF-1) {
40000137:	81 f9 ff 0f 00 00    	cmp    $0xfff,%ecx
4000013d:	75 15                	jne    40000154 <putch+0x32>
		b->buf[b->idx] = 0;
4000013f:	c6 44 02 09 00       	movb   $0x0,0x9(%edx,%eax,1)
		puts(b->buf, b->idx);
40000144:	8d 5a 08             	lea    0x8(%edx),%ebx
  */

static gcc_inline void
sys_puts(const char *s, size_t len)
{
	asm volatile("int %0" :
40000147:	b8 00 00 00 00       	mov    $0x0,%eax
4000014c:	cd 30                	int    $0x30
		b->idx = 0;
4000014e:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	}
	b->cnt++;
40000154:	8b 42 04             	mov    0x4(%edx),%eax
40000157:	83 c0 01             	add    $0x1,%eax
4000015a:	89 42 04             	mov    %eax,0x4(%edx)
}
4000015d:	5b                   	pop    %ebx
4000015e:	c3                   	ret    

4000015f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
4000015f:	53                   	push   %ebx
40000160:	81 ec 18 10 00 00    	sub    $0x1018,%esp
	struct printbuf b;

	b.idx = 0;
40000166:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
4000016d:	00 
	b.cnt = 0;
4000016e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000175:	00 
	vprintfmt((void*)putch, &b, fmt, ap);
40000176:	ff b4 24 24 10 00 00 	pushl  0x1024(%esp)
4000017d:	ff b4 24 24 10 00 00 	pushl  0x1024(%esp)
40000184:	8d 44 24 10          	lea    0x10(%esp),%eax
40000188:	50                   	push   %eax
40000189:	68 22 01 00 40       	push   $0x40000122
4000018e:	e8 6c 01 00 00       	call   400002ff <vprintfmt>

	b.buf[b.idx] = 0;
40000193:	8b 4c 24 18          	mov    0x18(%esp),%ecx
40000197:	c6 44 0c 20 00       	movb   $0x0,0x20(%esp,%ecx,1)
4000019c:	8d 5c 24 20          	lea    0x20(%esp),%ebx
400001a0:	b8 00 00 00 00       	mov    $0x0,%eax
400001a5:	cd 30                	int    $0x30
	puts(b.buf, b.idx);

	return b.cnt;
}
400001a7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400001ab:	81 c4 28 10 00 00    	add    $0x1028,%esp
400001b1:	5b                   	pop    %ebx
400001b2:	c3                   	ret    

400001b3 <printf>:

int
printf(const char *fmt, ...)
{
400001b3:	83 ec 14             	sub    $0x14,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
400001b6:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400001ba:	50                   	push   %eax
400001bb:	ff 74 24 1c          	pushl  0x1c(%esp)
400001bf:	e8 9b ff ff ff       	call   4000015f <vcprintf>
	va_end(ap);

	return cnt;
}
400001c4:	83 c4 1c             	add    $0x1c,%esp
400001c7:	c3                   	ret    

400001c8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
400001c8:	55                   	push   %ebp
400001c9:	57                   	push   %edi
400001ca:	56                   	push   %esi
400001cb:	53                   	push   %ebx
400001cc:	83 ec 1c             	sub    $0x1c,%esp
400001cf:	89 c6                	mov    %eax,%esi
400001d1:	89 d7                	mov    %edx,%edi
400001d3:	8b 44 24 30          	mov    0x30(%esp),%eax
400001d7:	8b 54 24 34          	mov    0x34(%esp),%edx
400001db:	89 44 24 08          	mov    %eax,0x8(%esp)
400001df:	89 54 24 0c          	mov    %edx,0xc(%esp)
400001e3:	8b 6c 24 40          	mov    0x40(%esp),%ebp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
400001e7:	8b 4c 24 38          	mov    0x38(%esp),%ecx
400001eb:	bb 00 00 00 00       	mov    $0x0,%ebx
400001f0:	89 0c 24             	mov    %ecx,(%esp)
400001f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
400001f7:	39 d3                	cmp    %edx,%ebx
400001f9:	72 06                	jb     40000201 <printnum+0x39>
400001fb:	39 44 24 38          	cmp    %eax,0x38(%esp)
400001ff:	77 47                	ja     40000248 <printnum+0x80>
		printnum(putch, putdat, num / base, base, width - 1, padc);
40000201:	83 ec 0c             	sub    $0xc,%esp
40000204:	55                   	push   %ebp
40000205:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000209:	8d 58 ff             	lea    -0x1(%eax),%ebx
4000020c:	53                   	push   %ebx
4000020d:	ff 74 24 4c          	pushl  0x4c(%esp)
40000211:	83 ec 08             	sub    $0x8,%esp
40000214:	ff 74 24 24          	pushl  0x24(%esp)
40000218:	ff 74 24 24          	pushl  0x24(%esp)
4000021c:	ff 74 24 34          	pushl  0x34(%esp)
40000220:	ff 74 24 34          	pushl  0x34(%esp)
40000224:	e8 37 09 00 00       	call   40000b60 <__udivdi3>
40000229:	83 c4 18             	add    $0x18,%esp
4000022c:	52                   	push   %edx
4000022d:	50                   	push   %eax
4000022e:	89 fa                	mov    %edi,%edx
40000230:	89 f0                	mov    %esi,%eax
40000232:	e8 91 ff ff ff       	call   400001c8 <printnum>
40000237:	83 c4 20             	add    $0x20,%esp
4000023a:	eb 17                	jmp    40000253 <printnum+0x8b>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
4000023c:	83 ec 08             	sub    $0x8,%esp
4000023f:	57                   	push   %edi
40000240:	55                   	push   %ebp
40000241:	ff d6                	call   *%esi
40000243:	83 c4 10             	add    $0x10,%esp
40000246:	eb 04                	jmp    4000024c <printnum+0x84>
40000248:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
4000024c:	83 eb 01             	sub    $0x1,%ebx
4000024f:	85 db                	test   %ebx,%ebx
40000251:	7f e9                	jg     4000023c <printnum+0x74>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
40000253:	ff 74 24 04          	pushl  0x4(%esp)
40000257:	ff 74 24 04          	pushl  0x4(%esp)
4000025b:	ff 74 24 14          	pushl  0x14(%esp)
4000025f:	ff 74 24 14          	pushl  0x14(%esp)
40000263:	e8 28 0a 00 00       	call   40000c90 <__umoddi3>
40000268:	83 c4 08             	add    $0x8,%esp
4000026b:	57                   	push   %edi
4000026c:	0f be 80 08 0e 00 40 	movsbl 0x40000e08(%eax),%eax
40000273:	50                   	push   %eax
40000274:	ff d6                	call   *%esi
}
40000276:	83 c4 2c             	add    $0x2c,%esp
40000279:	5b                   	pop    %ebx
4000027a:	5e                   	pop    %esi
4000027b:	5f                   	pop    %edi
4000027c:	5d                   	pop    %ebp
4000027d:	c3                   	ret    

4000027e <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
4000027e:	83 fa 01             	cmp    $0x1,%edx
40000281:	7e 0d                	jle    40000290 <getuint+0x12>
		return va_arg(*ap, unsigned long long);
40000283:	8b 08                	mov    (%eax),%ecx
40000285:	8d 51 08             	lea    0x8(%ecx),%edx
40000288:	89 10                	mov    %edx,(%eax)
4000028a:	8b 01                	mov    (%ecx),%eax
4000028c:	8b 51 04             	mov    0x4(%ecx),%edx
4000028f:	c3                   	ret    
	else if (lflag)
40000290:	85 d2                	test   %edx,%edx
40000292:	74 0f                	je     400002a3 <getuint+0x25>
		return va_arg(*ap, unsigned long);
40000294:	8b 08                	mov    (%eax),%ecx
40000296:	8d 51 04             	lea    0x4(%ecx),%edx
40000299:	89 10                	mov    %edx,(%eax)
4000029b:	8b 01                	mov    (%ecx),%eax
4000029d:	ba 00 00 00 00       	mov    $0x0,%edx
400002a2:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
400002a3:	8b 08                	mov    (%eax),%ecx
400002a5:	8d 51 04             	lea    0x4(%ecx),%edx
400002a8:	89 10                	mov    %edx,(%eax)
400002aa:	8b 01                	mov    (%ecx),%eax
400002ac:	ba 00 00 00 00       	mov    $0x0,%edx
}
400002b1:	c3                   	ret    

400002b2 <getint>:
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
400002b2:	83 fa 01             	cmp    $0x1,%edx
400002b5:	7e 0d                	jle    400002c4 <getint+0x12>
		return va_arg(*ap, long long);
400002b7:	8b 08                	mov    (%eax),%ecx
400002b9:	8d 51 08             	lea    0x8(%ecx),%edx
400002bc:	89 10                	mov    %edx,(%eax)
400002be:	8b 01                	mov    (%ecx),%eax
400002c0:	8b 51 04             	mov    0x4(%ecx),%edx
400002c3:	c3                   	ret    
	else if (lflag)
400002c4:	85 d2                	test   %edx,%edx
400002c6:	74 0b                	je     400002d3 <getint+0x21>
		return va_arg(*ap, long);
400002c8:	8b 08                	mov    (%eax),%ecx
400002ca:	8d 51 04             	lea    0x4(%ecx),%edx
400002cd:	89 10                	mov    %edx,(%eax)
400002cf:	8b 01                	mov    (%ecx),%eax
400002d1:	99                   	cltd   
400002d2:	c3                   	ret    
	else
		return va_arg(*ap, int);
400002d3:	8b 08                	mov    (%eax),%ecx
400002d5:	8d 51 04             	lea    0x4(%ecx),%edx
400002d8:	89 10                	mov    %edx,(%eax)
400002da:	8b 01                	mov    (%ecx),%eax
400002dc:	99                   	cltd   
}
400002dd:	c3                   	ret    

400002de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
400002de:	8b 44 24 08          	mov    0x8(%esp),%eax
	b->cnt++;
400002e2:	8b 48 08             	mov    0x8(%eax),%ecx
400002e5:	8d 51 01             	lea    0x1(%ecx),%edx
400002e8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
400002eb:	8b 10                	mov    (%eax),%edx
400002ed:	3b 50 04             	cmp    0x4(%eax),%edx
400002f0:	73 0b                	jae    400002fd <sprintputch+0x1f>
		*b->buf++ = ch;
400002f2:	8d 4a 01             	lea    0x1(%edx),%ecx
400002f5:	89 08                	mov    %ecx,(%eax)
400002f7:	8b 44 24 04          	mov    0x4(%esp),%eax
400002fb:	88 02                	mov    %al,(%edx)
400002fd:	f3 c3                	repz ret 

400002ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
400002ff:	55                   	push   %ebp
40000300:	57                   	push   %edi
40000301:	56                   	push   %esi
40000302:	53                   	push   %ebx
40000303:	83 ec 2c             	sub    $0x2c,%esp
40000306:	8b 5c 24 40          	mov    0x40(%esp),%ebx
4000030a:	8b 74 24 44          	mov    0x44(%esp),%esi
4000030e:	8b 6c 24 48          	mov    0x48(%esp),%ebp
40000312:	89 f7                	mov    %esi,%edi
40000314:	89 de                	mov    %ebx,%esi
40000316:	eb 14                	jmp    4000032c <vprintfmt+0x2d>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
40000318:	85 c0                	test   %eax,%eax
4000031a:	0f 84 17 03 00 00    	je     40000637 <vprintfmt+0x338>
				return;
			putch(ch, putdat);
40000320:	83 ec 08             	sub    $0x8,%esp
40000323:	57                   	push   %edi
40000324:	50                   	push   %eax
40000325:	ff d6                	call   *%esi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
40000327:	89 dd                	mov    %ebx,%ebp
40000329:	83 c4 10             	add    $0x10,%esp
4000032c:	8d 5d 01             	lea    0x1(%ebp),%ebx
4000032f:	0f b6 45 00          	movzbl 0x0(%ebp),%eax
40000333:	83 f8 25             	cmp    $0x25,%eax
40000336:	75 e0                	jne    40000318 <vprintfmt+0x19>
40000338:	c6 44 24 13 20       	movb   $0x20,0x13(%esp)
4000033d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
40000344:	00 
40000345:	c7 44 24 1c ff ff ff 	movl   $0xffffffff,0x1c(%esp)
4000034c:	ff 
4000034d:	c7 44 24 14 ff ff ff 	movl   $0xffffffff,0x14(%esp)
40000354:	ff 
40000355:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
4000035c:	00 
4000035d:	eb 2e                	jmp    4000038d <vprintfmt+0x8e>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
4000035f:	89 eb                	mov    %ebp,%ebx

			// flag to pad on the right
		case '-':
			padc = '-';
40000361:	c6 44 24 13 2d       	movb   $0x2d,0x13(%esp)
40000366:	eb 25                	jmp    4000038d <vprintfmt+0x8e>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
40000368:	89 eb                	mov    %ebp,%ebx
			padc = '-';
			goto reswitch;

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
4000036a:	c6 44 24 13 30       	movb   $0x30,0x13(%esp)
4000036f:	eb 1c                	jmp    4000038d <vprintfmt+0x8e>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
40000371:	89 eb                	mov    %ebp,%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
40000373:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
4000037a:	00 
4000037b:	eb 10                	jmp    4000038d <vprintfmt+0x8e>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
4000037d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000381:	89 44 24 14          	mov    %eax,0x14(%esp)
40000385:	c7 44 24 1c ff ff ff 	movl   $0xffffffff,0x1c(%esp)
4000038c:	ff 
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
4000038d:	8d 6b 01             	lea    0x1(%ebx),%ebp
40000390:	0f b6 13             	movzbl (%ebx),%edx
40000393:	0f b6 c2             	movzbl %dl,%eax
40000396:	83 ea 23             	sub    $0x23,%edx
40000399:	80 fa 55             	cmp    $0x55,%dl
4000039c:	0f 87 78 02 00 00    	ja     4000061a <vprintfmt+0x31b>
400003a2:	0f b6 d2             	movzbl %dl,%edx
400003a5:	ff 24 95 20 0e 00 40 	jmp    *0x40000e20(,%edx,4)
400003ac:	89 eb                	mov    %ebp,%ebx
400003ae:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
400003b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
400003b6:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
400003b9:	8d 4c 10 d0          	lea    -0x30(%eax,%edx,1),%ecx
				ch = *fmt;
400003bd:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
400003c0:	8d 50 d0             	lea    -0x30(%eax),%edx
400003c3:	83 fa 09             	cmp    $0x9,%edx
400003c6:	77 32                	ja     400003fa <vprintfmt+0xfb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
400003c8:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
400003cb:	eb e6                	jmp    400003b3 <vprintfmt+0xb4>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
400003cd:	8b 44 24 4c          	mov    0x4c(%esp),%eax
400003d1:	83 c0 04             	add    $0x4,%eax
400003d4:	89 44 24 4c          	mov    %eax,0x4c(%esp)
400003d8:	8b 40 fc             	mov    -0x4(%eax),%eax
400003db:	89 44 24 1c          	mov    %eax,0x1c(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
400003df:	89 eb                	mov    %ebp,%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
400003e1:	eb 1b                	jmp    400003fe <vprintfmt+0xff>

		case '.':
			if (width < 0)
400003e3:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
400003e8:	78 87                	js     40000371 <vprintfmt+0x72>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
400003ea:	89 eb                	mov    %ebp,%ebx
400003ec:	eb 9f                	jmp    4000038d <vprintfmt+0x8e>
400003ee:	89 eb                	mov    %ebp,%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
400003f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
400003f7:	00 
			goto reswitch;
400003f8:	eb 93                	jmp    4000038d <vprintfmt+0x8e>
400003fa:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)

		process_precision:
			if (width < 0)
400003fe:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
40000403:	79 88                	jns    4000038d <vprintfmt+0x8e>
40000405:	e9 73 ff ff ff       	jmp    4000037d <vprintfmt+0x7e>
				width = precision, precision = -1;
			goto reswitch;

			// long flag (doubled for long long)
		case 'l':
			lflag++;
4000040a:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
4000040f:	89 eb                	mov    %ebp,%ebx
			goto reswitch;

			// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
40000411:	e9 77 ff ff ff       	jmp    4000038d <vprintfmt+0x8e>

			// character
		case 'c':
			putch(va_arg(ap, int), putdat);
40000416:	8b 44 24 4c          	mov    0x4c(%esp),%eax
4000041a:	83 c0 04             	add    $0x4,%eax
4000041d:	89 44 24 4c          	mov    %eax,0x4c(%esp)
40000421:	83 ec 08             	sub    $0x8,%esp
40000424:	57                   	push   %edi
40000425:	ff 70 fc             	pushl  -0x4(%eax)
40000428:	ff d6                	call   *%esi
			break;
4000042a:	83 c4 10             	add    $0x10,%esp
4000042d:	e9 fa fe ff ff       	jmp    4000032c <vprintfmt+0x2d>

			// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
40000432:	8b 44 24 4c          	mov    0x4c(%esp),%eax
40000436:	83 c0 04             	add    $0x4,%eax
40000439:	89 44 24 4c          	mov    %eax,0x4c(%esp)
4000043d:	8b 58 fc             	mov    -0x4(%eax),%ebx
40000440:	85 db                	test   %ebx,%ebx
40000442:	75 05                	jne    40000449 <vprintfmt+0x14a>
				p = "(null)";
40000444:	bb 19 0e 00 40       	mov    $0x40000e19,%ebx
			if (width > 0 && padc != '-')
40000449:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
4000044e:	0f 9f c2             	setg   %dl
40000451:	80 7c 24 13 2d       	cmpb   $0x2d,0x13(%esp)
40000456:	0f 95 c0             	setne  %al
40000459:	84 c2                	test   %al,%dl
4000045b:	74 7e                	je     400004db <vprintfmt+0x1dc>
				for (width -= strnlen(p, precision); width > 0; width--)
4000045d:	83 ec 08             	sub    $0x8,%esp
40000460:	ff 74 24 24          	pushl  0x24(%esp)
40000464:	53                   	push   %ebx
40000465:	e8 ed 02 00 00       	call   40000757 <strnlen>
4000046a:	29 44 24 24          	sub    %eax,0x24(%esp)
4000046e:	8b 4c 24 24          	mov    0x24(%esp),%ecx
40000472:	83 c4 10             	add    $0x10,%esp
40000475:	89 6c 24 48          	mov    %ebp,0x48(%esp)
40000479:	89 dd                	mov    %ebx,%ebp
4000047b:	89 cb                	mov    %ecx,%ebx
4000047d:	eb 12                	jmp    40000491 <vprintfmt+0x192>
					putch(padc, putdat);
4000047f:	83 ec 08             	sub    $0x8,%esp
40000482:	57                   	push   %edi
40000483:	0f be 44 24 1f       	movsbl 0x1f(%esp),%eax
40000488:	50                   	push   %eax
40000489:	ff d6                	call   *%esi
			// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
4000048b:	83 eb 01             	sub    $0x1,%ebx
4000048e:	83 c4 10             	add    $0x10,%esp
40000491:	85 db                	test   %ebx,%ebx
40000493:	7f ea                	jg     4000047f <vprintfmt+0x180>
40000495:	89 d9                	mov    %ebx,%ecx
40000497:	89 eb                	mov    %ebp,%ebx
40000499:	89 d8                	mov    %ebx,%eax
4000049b:	89 74 24 40          	mov    %esi,0x40(%esp)
4000049f:	89 ce                	mov    %ecx,%esi
400004a1:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
400004a5:	eb 46                	jmp    400004ed <vprintfmt+0x1ee>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
400004a7:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
400004ac:	74 1a                	je     400004c8 <vprintfmt+0x1c9>
400004ae:	0f be c0             	movsbl %al,%eax
400004b1:	83 e8 20             	sub    $0x20,%eax
400004b4:	83 f8 5e             	cmp    $0x5e,%eax
400004b7:	76 0f                	jbe    400004c8 <vprintfmt+0x1c9>
					putch('?', putdat);
400004b9:	83 ec 08             	sub    $0x8,%esp
400004bc:	57                   	push   %edi
400004bd:	6a 3f                	push   $0x3f
400004bf:	ff 54 24 50          	call   *0x50(%esp)
400004c3:	83 c4 10             	add    $0x10,%esp
400004c6:	eb 0c                	jmp    400004d4 <vprintfmt+0x1d5>
				else
					putch(ch, putdat);
400004c8:	83 ec 08             	sub    $0x8,%esp
400004cb:	57                   	push   %edi
400004cc:	52                   	push   %edx
400004cd:	ff 54 24 50          	call   *0x50(%esp)
400004d1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
400004d4:	83 ee 01             	sub    $0x1,%esi
400004d7:	89 d8                	mov    %ebx,%eax
400004d9:	eb 12                	jmp    400004ed <vprintfmt+0x1ee>
400004db:	89 d8                	mov    %ebx,%eax
400004dd:	89 74 24 40          	mov    %esi,0x40(%esp)
400004e1:	8b 74 24 14          	mov    0x14(%esp),%esi
400004e5:	89 6c 24 48          	mov    %ebp,0x48(%esp)
400004e9:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
400004ed:	8d 58 01             	lea    0x1(%eax),%ebx
400004f0:	0f b6 00             	movzbl (%eax),%eax
400004f3:	0f be d0             	movsbl %al,%edx
400004f6:	85 d2                	test   %edx,%edx
400004f8:	74 25                	je     4000051f <vprintfmt+0x220>
400004fa:	85 ed                	test   %ebp,%ebp
400004fc:	78 a9                	js     400004a7 <vprintfmt+0x1a8>
400004fe:	83 ed 01             	sub    $0x1,%ebp
40000501:	79 a4                	jns    400004a7 <vprintfmt+0x1a8>
40000503:	89 f3                	mov    %esi,%ebx
40000505:	8b 74 24 40          	mov    0x40(%esp),%esi
40000509:	8b 6c 24 48          	mov    0x48(%esp),%ebp
4000050d:	eb 1a                	jmp    40000529 <vprintfmt+0x22a>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
4000050f:	83 ec 08             	sub    $0x8,%esp
40000512:	57                   	push   %edi
40000513:	6a 20                	push   $0x20
40000515:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
40000517:	83 eb 01             	sub    $0x1,%ebx
4000051a:	83 c4 10             	add    $0x10,%esp
4000051d:	eb 0a                	jmp    40000529 <vprintfmt+0x22a>
4000051f:	89 f3                	mov    %esi,%ebx
40000521:	8b 74 24 40          	mov    0x40(%esp),%esi
40000525:	8b 6c 24 48          	mov    0x48(%esp),%ebp
40000529:	85 db                	test   %ebx,%ebx
4000052b:	7f e2                	jg     4000050f <vprintfmt+0x210>
4000052d:	e9 fa fd ff ff       	jmp    4000032c <vprintfmt+0x2d>
				putch(' ', putdat);
			break;

			// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
40000532:	8b 54 24 18          	mov    0x18(%esp),%edx
40000536:	8d 44 24 4c          	lea    0x4c(%esp),%eax
4000053a:	e8 73 fd ff ff       	call   400002b2 <getint>
4000053f:	89 44 24 08          	mov    %eax,0x8(%esp)
40000543:	89 54 24 0c          	mov    %edx,0xc(%esp)
			if ((long long) num < 0) {
40000547:	85 d2                	test   %edx,%edx
40000549:	0f 89 96 00 00 00    	jns    400005e5 <vprintfmt+0x2e6>
				putch('-', putdat);
4000054f:	83 ec 08             	sub    $0x8,%esp
40000552:	57                   	push   %edi
40000553:	6a 2d                	push   $0x2d
40000555:	ff d6                	call   *%esi
				num = -(long long) num;
40000557:	8b 44 24 18          	mov    0x18(%esp),%eax
4000055b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
4000055f:	f7 d8                	neg    %eax
40000561:	83 d2 00             	adc    $0x0,%edx
40000564:	f7 da                	neg    %edx
40000566:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
40000569:	bb 0a 00 00 00       	mov    $0xa,%ebx
4000056e:	eb 7a                	jmp    400005ea <vprintfmt+0x2eb>
			goto number;

			// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
40000570:	8b 54 24 18          	mov    0x18(%esp),%edx
40000574:	8d 44 24 4c          	lea    0x4c(%esp),%eax
40000578:	e8 01 fd ff ff       	call   4000027e <getuint>
			base = 10;
4000057d:	bb 0a 00 00 00       	mov    $0xa,%ebx
			goto number;
40000582:	eb 66                	jmp    400005ea <vprintfmt+0x2eb>
			num = getuint(&ap, lflag);
			base = 8;
			goto number;
#else
			// Replace this with your code.
			putch('X', putdat);
40000584:	83 ec 08             	sub    $0x8,%esp
40000587:	57                   	push   %edi
40000588:	6a 58                	push   $0x58
4000058a:	ff d6                	call   *%esi
			putch('X', putdat);
4000058c:	83 c4 08             	add    $0x8,%esp
4000058f:	57                   	push   %edi
40000590:	6a 58                	push   $0x58
40000592:	ff d6                	call   *%esi
			putch('X', putdat);
40000594:	83 c4 08             	add    $0x8,%esp
40000597:	57                   	push   %edi
40000598:	6a 58                	push   $0x58
4000059a:	ff d6                	call   *%esi
			break;
4000059c:	83 c4 10             	add    $0x10,%esp
4000059f:	e9 88 fd ff ff       	jmp    4000032c <vprintfmt+0x2d>
#endif

			// pointer
		case 'p':
			putch('0', putdat);
400005a4:	83 ec 08             	sub    $0x8,%esp
400005a7:	57                   	push   %edi
400005a8:	6a 30                	push   $0x30
400005aa:	ff d6                	call   *%esi
			putch('x', putdat);
400005ac:	83 c4 08             	add    $0x8,%esp
400005af:	57                   	push   %edi
400005b0:	6a 78                	push   $0x78
400005b2:	ff d6                	call   *%esi
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
400005b4:	8b 44 24 5c          	mov    0x5c(%esp),%eax
400005b8:	83 c0 04             	add    $0x4,%eax
400005bb:	89 44 24 5c          	mov    %eax,0x5c(%esp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
400005bf:	8b 40 fc             	mov    -0x4(%eax),%eax
400005c2:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
400005c7:	83 c4 10             	add    $0x10,%esp
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
			base = 16;
400005ca:	bb 10 00 00 00       	mov    $0x10,%ebx
			goto number;
400005cf:	eb 19                	jmp    400005ea <vprintfmt+0x2eb>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
400005d1:	8b 54 24 18          	mov    0x18(%esp),%edx
400005d5:	8d 44 24 4c          	lea    0x4c(%esp),%eax
400005d9:	e8 a0 fc ff ff       	call   4000027e <getuint>
			base = 16;
400005de:	bb 10 00 00 00       	mov    $0x10,%ebx
400005e3:	eb 05                	jmp    400005ea <vprintfmt+0x2eb>
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
400005e5:	bb 0a 00 00 00       	mov    $0xa,%ebx
			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
400005ea:	83 ec 0c             	sub    $0xc,%esp
400005ed:	0f be 4c 24 1f       	movsbl 0x1f(%esp),%ecx
400005f2:	51                   	push   %ecx
400005f3:	ff 74 24 24          	pushl  0x24(%esp)
400005f7:	53                   	push   %ebx
400005f8:	52                   	push   %edx
400005f9:	50                   	push   %eax
400005fa:	89 fa                	mov    %edi,%edx
400005fc:	89 f0                	mov    %esi,%eax
400005fe:	e8 c5 fb ff ff       	call   400001c8 <printnum>
			break;
40000603:	83 c4 20             	add    $0x20,%esp
40000606:	e9 21 fd ff ff       	jmp    4000032c <vprintfmt+0x2d>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
4000060b:	83 ec 08             	sub    $0x8,%esp
4000060e:	57                   	push   %edi
4000060f:	50                   	push   %eax
40000610:	ff d6                	call   *%esi
			break;
40000612:	83 c4 10             	add    $0x10,%esp
40000615:	e9 12 fd ff ff       	jmp    4000032c <vprintfmt+0x2d>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
4000061a:	83 ec 08             	sub    $0x8,%esp
4000061d:	57                   	push   %edi
4000061e:	6a 25                	push   $0x25
40000620:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
40000622:	83 c4 10             	add    $0x10,%esp
40000625:	89 dd                	mov    %ebx,%ebp
40000627:	eb 03                	jmp    4000062c <vprintfmt+0x32d>
40000629:	83 ed 01             	sub    $0x1,%ebp
4000062c:	80 7d ff 25          	cmpb   $0x25,-0x1(%ebp)
40000630:	75 f7                	jne    40000629 <vprintfmt+0x32a>
40000632:	e9 f5 fc ff ff       	jmp    4000032c <vprintfmt+0x2d>
				/* do nothing */;
			break;
		}
	}
}
40000637:	83 c4 2c             	add    $0x2c,%esp
4000063a:	5b                   	pop    %ebx
4000063b:	5e                   	pop    %esi
4000063c:	5f                   	pop    %edi
4000063d:	5d                   	pop    %ebp
4000063e:	c3                   	ret    

4000063f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
4000063f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
40000642:	8d 44 24 1c          	lea    0x1c(%esp),%eax
40000646:	50                   	push   %eax
40000647:	ff 74 24 1c          	pushl  0x1c(%esp)
4000064b:	ff 74 24 1c          	pushl  0x1c(%esp)
4000064f:	ff 74 24 1c          	pushl  0x1c(%esp)
40000653:	e8 a7 fc ff ff       	call   400002ff <vprintfmt>
	va_end(ap);
}
40000658:	83 c4 1c             	add    $0x1c,%esp
4000065b:	c3                   	ret    

4000065c <vsprintf>:
		*b->buf++ = ch;
}

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
4000065c:	83 ec 1c             	sub    $0x1c,%esp
	//assert(buf != NULL);
	struct sprintbuf b = {buf, (char*)(intptr_t)~0, 0};
4000065f:	8b 44 24 20          	mov    0x20(%esp),%eax
40000663:	89 44 24 04          	mov    %eax,0x4(%esp)
40000667:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
4000066e:	ff 
4000066f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
40000676:	00 

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
40000677:	ff 74 24 28          	pushl  0x28(%esp)
4000067b:	ff 74 24 28          	pushl  0x28(%esp)
4000067f:	8d 44 24 0c          	lea    0xc(%esp),%eax
40000683:	50                   	push   %eax
40000684:	68 de 02 00 40       	push   $0x400002de
40000689:	e8 71 fc ff ff       	call   400002ff <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
4000068e:	8b 44 24 14          	mov    0x14(%esp),%eax
40000692:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
40000695:	8b 44 24 1c          	mov    0x1c(%esp),%eax
40000699:	83 c4 2c             	add    $0x2c,%esp
4000069c:	c3                   	ret    

4000069d <sprintf>:

int
sprintf(char *buf, const char *fmt, ...)
{
4000069d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsprintf(buf, fmt, ap);
400006a0:	8d 44 24 1c          	lea    0x1c(%esp),%eax
400006a4:	50                   	push   %eax
400006a5:	ff 74 24 1c          	pushl  0x1c(%esp)
400006a9:	ff 74 24 1c          	pushl  0x1c(%esp)
400006ad:	e8 aa ff ff ff       	call   4000065c <vsprintf>
	va_end(ap);

	return rc;
}
400006b2:	83 c4 1c             	add    $0x1c,%esp
400006b5:	c3                   	ret    

400006b6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
400006b6:	83 ec 1c             	sub    $0x1c,%esp
400006b9:	8b 44 24 20          	mov    0x20(%esp),%eax
	//assert(buf != NULL && n > 0);
	struct sprintbuf b = {buf, buf+n-1, 0};
400006bd:	89 44 24 04          	mov    %eax,0x4(%esp)
400006c1:	8b 54 24 24          	mov    0x24(%esp),%edx
400006c5:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
400006c9:	89 44 24 08          	mov    %eax,0x8(%esp)
400006cd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
400006d4:	00 

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
400006d5:	ff 74 24 2c          	pushl  0x2c(%esp)
400006d9:	ff 74 24 2c          	pushl  0x2c(%esp)
400006dd:	8d 44 24 0c          	lea    0xc(%esp),%eax
400006e1:	50                   	push   %eax
400006e2:	68 de 02 00 40       	push   $0x400002de
400006e7:	e8 13 fc ff ff       	call   400002ff <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
400006ec:	8b 44 24 14          	mov    0x14(%esp),%eax
400006f0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
}
400006f3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
400006f7:	83 c4 2c             	add    $0x2c,%esp
400006fa:	c3                   	ret    

400006fb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
400006fb:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
400006fe:	8d 44 24 1c          	lea    0x1c(%esp),%eax
40000702:	50                   	push   %eax
40000703:	ff 74 24 1c          	pushl  0x1c(%esp)
40000707:	ff 74 24 1c          	pushl  0x1c(%esp)
4000070b:	ff 74 24 1c          	pushl  0x1c(%esp)
4000070f:	e8 a2 ff ff ff       	call   400006b6 <vsnprintf>
	va_end(ap);

	return rc;
}
40000714:	83 c4 1c             	add    $0x1c,%esp
40000717:	c3                   	ret    

40000718 <spawn>:
#include <syscall.h>
#include <types.h>

pid_t
spawn(uintptr_t exec, unsigned int quota)
{
40000718:	53                   	push   %ebx
static gcc_inline pid_t
sys_spawn(uintptr_t exec, unsigned int quota)
{
	unsigned int err;
	pid_t pid;
    asm volatile("int %2"
40000719:	b8 01 00 00 00       	mov    $0x1,%eax
4000071e:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000722:	8b 5c 24 08          	mov    0x8(%esp),%ebx
40000726:	cd 30                	int    $0x30
				  "a" (SYS_spawn),
                  "b" (exec),
				  "c" (quota)
				: "cc", "memory");

    if(err == E_SUCC)
40000728:	85 c0                	test   %eax,%eax
4000072a:	74 07                	je     40000733 <spawn+0x1b>
         return pid;
    else
        return -1;
4000072c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
40000731:	eb 02                	jmp    40000735 <spawn+0x1d>
                  "b" (exec),
				  "c" (quota)
				: "cc", "memory");

    if(err == E_SUCC)
         return pid;
40000733:	89 d8                	mov    %ebx,%eax
	return sys_spawn(exec, quota);
}
40000735:	5b                   	pop    %ebx
40000736:	c3                   	ret    

40000737 <yield>:
  *   - This doesn't take any arguments and doesn't return anything.
  */
static gcc_inline void
sys_yield(void)
{
	asm volatile("int %0" :
40000737:	b8 02 00 00 00       	mov    $0x2,%eax
4000073c:	cd 30                	int    $0x30
4000073e:	c3                   	ret    

4000073f <strlen>:
#include <string.h>
#include <types.h>

int
strlen(const char *s)
{
4000073f:	8b 54 24 04          	mov    0x4(%esp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
40000743:	b8 00 00 00 00       	mov    $0x0,%eax
40000748:	eb 06                	jmp    40000750 <strlen+0x11>
		n++;
4000074a:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
4000074d:	83 c2 01             	add    $0x1,%edx
40000750:	80 3a 00             	cmpb   $0x0,(%edx)
40000753:	75 f5                	jne    4000074a <strlen+0xb>
		n++;
	return n;
}
40000755:	f3 c3                	repz ret 

40000757 <strnlen>:

int
strnlen(const char *s, size_t size)
{
40000757:	8b 4c 24 04          	mov    0x4(%esp),%ecx
4000075b:	8b 54 24 08          	mov    0x8(%esp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
4000075f:	b8 00 00 00 00       	mov    $0x0,%eax
40000764:	eb 09                	jmp    4000076f <strnlen+0x18>
		n++;
40000766:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
40000769:	83 c1 01             	add    $0x1,%ecx
4000076c:	83 ea 01             	sub    $0x1,%edx
4000076f:	85 d2                	test   %edx,%edx
40000771:	74 05                	je     40000778 <strnlen+0x21>
40000773:	80 39 00             	cmpb   $0x0,(%ecx)
40000776:	75 ee                	jne    40000766 <strnlen+0xf>
		n++;
	return n;
}
40000778:	f3 c3                	repz ret 

4000077a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
4000077a:	53                   	push   %ebx
4000077b:	8b 44 24 08          	mov    0x8(%esp),%eax
4000077f:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
40000783:	89 c2                	mov    %eax,%edx
40000785:	0f b6 19             	movzbl (%ecx),%ebx
40000788:	88 1a                	mov    %bl,(%edx)
4000078a:	8d 52 01             	lea    0x1(%edx),%edx
4000078d:	8d 49 01             	lea    0x1(%ecx),%ecx
40000790:	84 db                	test   %bl,%bl
40000792:	75 f1                	jne    40000785 <strcpy+0xb>
		/* do nothing */;
	return ret;
}
40000794:	5b                   	pop    %ebx
40000795:	c3                   	ret    

40000796 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size)
{
40000796:	55                   	push   %ebp
40000797:	57                   	push   %edi
40000798:	56                   	push   %esi
40000799:	53                   	push   %ebx
4000079a:	8b 6c 24 14          	mov    0x14(%esp),%ebp
4000079e:	8b 5c 24 18          	mov    0x18(%esp),%ebx
400007a2:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
400007a6:	89 e9                	mov    %ebp,%ecx
400007a8:	ba 00 00 00 00       	mov    $0x0,%edx
400007ad:	eb 15                	jmp    400007c4 <strncpy+0x2e>
		*dst++ = *src;
400007af:	8d 71 01             	lea    0x1(%ecx),%esi
400007b2:	0f b6 03             	movzbl (%ebx),%eax
400007b5:	88 01                	mov    %al,(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
400007b7:	80 3b 00             	cmpb   $0x0,(%ebx)
400007ba:	74 03                	je     400007bf <strncpy+0x29>
			src++;
400007bc:	83 c3 01             	add    $0x1,%ebx
{
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
400007bf:	83 c2 01             	add    $0x1,%edx
		*dst++ = *src;
400007c2:	89 f1                	mov    %esi,%ecx
{
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
400007c4:	39 fa                	cmp    %edi,%edx
400007c6:	72 e7                	jb     400007af <strncpy+0x19>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
400007c8:	89 e8                	mov    %ebp,%eax
400007ca:	5b                   	pop    %ebx
400007cb:	5e                   	pop    %esi
400007cc:	5f                   	pop    %edi
400007cd:	5d                   	pop    %ebp
400007ce:	c3                   	ret    

400007cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
400007cf:	56                   	push   %esi
400007d0:	53                   	push   %ebx
400007d1:	8b 74 24 0c          	mov    0xc(%esp),%esi
400007d5:	8b 4c 24 10          	mov    0x10(%esp),%ecx
400007d9:	8b 54 24 14          	mov    0x14(%esp),%edx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
400007dd:	85 d2                	test   %edx,%edx
400007df:	75 0e                	jne    400007ef <strlcpy+0x20>
400007e1:	89 f0                	mov    %esi,%eax
400007e3:	eb 1b                	jmp    40000800 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
400007e5:	83 c1 01             	add    $0x1,%ecx
400007e8:	88 18                	mov    %bl,(%eax)
400007ea:	8d 40 01             	lea    0x1(%eax),%eax
400007ed:	eb 02                	jmp    400007f1 <strlcpy+0x22>
400007ef:	89 f0                	mov    %esi,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
400007f1:	83 ea 01             	sub    $0x1,%edx
400007f4:	74 07                	je     400007fd <strlcpy+0x2e>
400007f6:	0f b6 19             	movzbl (%ecx),%ebx
400007f9:	84 db                	test   %bl,%bl
400007fb:	75 e8                	jne    400007e5 <strlcpy+0x16>
			*dst++ = *src++;
		*dst = '\0';
400007fd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
40000800:	29 f0                	sub    %esi,%eax
}
40000802:	5b                   	pop    %ebx
40000803:	5e                   	pop    %esi
40000804:	c3                   	ret    

40000805 <strcmp>:

int
strcmp(const char *p, const char *q)
{
40000805:	8b 4c 24 04          	mov    0x4(%esp),%ecx
40000809:	8b 54 24 08          	mov    0x8(%esp),%edx
	while (*p && *p == *q)
4000080d:	eb 06                	jmp    40000815 <strcmp+0x10>
		p++, q++;
4000080f:	83 c1 01             	add    $0x1,%ecx
40000812:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
40000815:	0f b6 01             	movzbl (%ecx),%eax
40000818:	84 c0                	test   %al,%al
4000081a:	74 04                	je     40000820 <strcmp+0x1b>
4000081c:	3a 02                	cmp    (%edx),%al
4000081e:	74 ef                	je     4000080f <strcmp+0xa>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
40000820:	0f b6 c0             	movzbl %al,%eax
40000823:	0f b6 12             	movzbl (%edx),%edx
40000826:	29 d0                	sub    %edx,%eax
}
40000828:	c3                   	ret    

40000829 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
40000829:	53                   	push   %ebx
4000082a:	8b 54 24 08          	mov    0x8(%esp),%edx
4000082e:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000832:	8b 44 24 10          	mov    0x10(%esp),%eax
	while (n > 0 && *p && *p == *q)
40000836:	eb 09                	jmp    40000841 <strncmp+0x18>
		n--, p++, q++;
40000838:	83 e8 01             	sub    $0x1,%eax
4000083b:	83 c2 01             	add    $0x1,%edx
4000083e:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
40000841:	85 c0                	test   %eax,%eax
40000843:	74 0b                	je     40000850 <strncmp+0x27>
40000845:	0f b6 1a             	movzbl (%edx),%ebx
40000848:	84 db                	test   %bl,%bl
4000084a:	74 04                	je     40000850 <strncmp+0x27>
4000084c:	3a 19                	cmp    (%ecx),%bl
4000084e:	74 e8                	je     40000838 <strncmp+0xf>
		n--, p++, q++;
	if (n == 0)
40000850:	85 c0                	test   %eax,%eax
40000852:	74 0a                	je     4000085e <strncmp+0x35>
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
40000854:	0f b6 02             	movzbl (%edx),%eax
40000857:	0f b6 11             	movzbl (%ecx),%edx
4000085a:	29 d0                	sub    %edx,%eax
4000085c:	eb 05                	jmp    40000863 <strncmp+0x3a>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
4000085e:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
40000863:	5b                   	pop    %ebx
40000864:	c3                   	ret    

40000865 <strchr>:

char *
strchr(const char *s, char c)
{
40000865:	8b 44 24 04          	mov    0x4(%esp),%eax
40000869:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
4000086e:	eb 07                	jmp    40000877 <strchr+0x12>
		if (*s == c)
40000870:	38 ca                	cmp    %cl,%dl
40000872:	74 0f                	je     40000883 <strchr+0x1e>
}

char *
strchr(const char *s, char c)
{
	for (; *s; s++)
40000874:	83 c0 01             	add    $0x1,%eax
40000877:	0f b6 10             	movzbl (%eax),%edx
4000087a:	84 d2                	test   %dl,%dl
4000087c:	75 f2                	jne    40000870 <strchr+0xb>
		if (*s == c)
			return (char *) s;
	return 0;
4000087e:	b8 00 00 00 00       	mov    $0x0,%eax
}
40000883:	f3 c3                	repz ret 

40000885 <strfind>:

char *
strfind(const char *s, char c)
{
40000885:	8b 44 24 04          	mov    0x4(%esp),%eax
40000889:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
4000088e:	eb 07                	jmp    40000897 <strfind+0x12>
		if (*s == c)
40000890:	38 ca                	cmp    %cl,%dl
40000892:	74 0a                	je     4000089e <strfind+0x19>
}

char *
strfind(const char *s, char c)
{
	for (; *s; s++)
40000894:	83 c0 01             	add    $0x1,%eax
40000897:	0f b6 10             	movzbl (%eax),%edx
4000089a:	84 d2                	test   %dl,%dl
4000089c:	75 f2                	jne    40000890 <strfind+0xb>
		if (*s == c)
			break;
	return (char *) s;
}
4000089e:	f3 c3                	repz ret 

400008a0 <strtol>:


long
strtol(const char *s, char **endptr, int base)
{
400008a0:	55                   	push   %ebp
400008a1:	57                   	push   %edi
400008a2:	56                   	push   %esi
400008a3:	53                   	push   %ebx
400008a4:	83 ec 04             	sub    $0x4,%esp
400008a7:	8b 4c 24 18          	mov    0x18(%esp),%ecx
400008ab:	8b 74 24 1c          	mov    0x1c(%esp),%esi
400008af:	8b 44 24 20          	mov    0x20(%esp),%eax
400008b3:	89 04 24             	mov    %eax,(%esp)
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
400008b6:	eb 03                	jmp    400008bb <strtol+0x1b>
		s++;
400008b8:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
400008bb:	0f b6 01             	movzbl (%ecx),%eax
400008be:	3c 20                	cmp    $0x20,%al
400008c0:	0f 94 c3             	sete   %bl
400008c3:	3c 09                	cmp    $0x9,%al
400008c5:	0f 94 c2             	sete   %dl
400008c8:	08 d3                	or     %dl,%bl
400008ca:	75 ec                	jne    400008b8 <strtol+0x18>
		s++;

	// plus/minus sign
	if (*s == '+')
400008cc:	3c 2b                	cmp    $0x2b,%al
400008ce:	75 0a                	jne    400008da <strtol+0x3a>
		s++;
400008d0:	83 c1 01             	add    $0x1,%ecx


long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
400008d3:	bf 00 00 00 00       	mov    $0x0,%edi
400008d8:	eb 13                	jmp    400008ed <strtol+0x4d>
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
400008da:	3c 2d                	cmp    $0x2d,%al
400008dc:	75 0a                	jne    400008e8 <strtol+0x48>
		s++, neg = 1;
400008de:	83 c1 01             	add    $0x1,%ecx
400008e1:	bf 01 00 00 00       	mov    $0x1,%edi
400008e6:	eb 05                	jmp    400008ed <strtol+0x4d>


long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
400008e8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
400008ed:	8b 04 24             	mov    (%esp),%eax
400008f0:	85 c0                	test   %eax,%eax
400008f2:	0f 94 c2             	sete   %dl
400008f5:	83 f8 10             	cmp    $0x10,%eax
400008f8:	0f 94 c0             	sete   %al
400008fb:	08 c2                	or     %al,%dl
400008fd:	74 17                	je     40000916 <strtol+0x76>
400008ff:	80 39 30             	cmpb   $0x30,(%ecx)
40000902:	75 12                	jne    40000916 <strtol+0x76>
40000904:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
40000908:	75 0c                	jne    40000916 <strtol+0x76>
		s += 2, base = 16;
4000090a:	83 c1 02             	add    $0x2,%ecx
4000090d:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
40000914:	eb 24                	jmp    4000093a <strtol+0x9a>
	else if (base == 0 && s[0] == '0')
40000916:	83 3c 24 00          	cmpl   $0x0,(%esp)
4000091a:	75 11                	jne    4000092d <strtol+0x8d>
4000091c:	80 39 30             	cmpb   $0x30,(%ecx)
4000091f:	75 0c                	jne    4000092d <strtol+0x8d>
		s++, base = 8;
40000921:	83 c1 01             	add    $0x1,%ecx
40000924:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
4000092b:	eb 0d                	jmp    4000093a <strtol+0x9a>
	else if (base == 0)
4000092d:	83 3c 24 00          	cmpl   $0x0,(%esp)
40000931:	75 07                	jne    4000093a <strtol+0x9a>
		base = 10;
40000933:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
4000093a:	b8 00 00 00 00       	mov    $0x0,%eax

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
4000093f:	0f b6 11             	movzbl (%ecx),%edx
40000942:	8d 6a d0             	lea    -0x30(%edx),%ebp
40000945:	89 eb                	mov    %ebp,%ebx
40000947:	80 fb 09             	cmp    $0x9,%bl
4000094a:	77 08                	ja     40000954 <strtol+0xb4>
			dig = *s - '0';
4000094c:	0f be d2             	movsbl %dl,%edx
4000094f:	83 ea 30             	sub    $0x30,%edx
40000952:	eb 22                	jmp    40000976 <strtol+0xd6>
		else if (*s >= 'a' && *s <= 'z')
40000954:	8d 6a 9f             	lea    -0x61(%edx),%ebp
40000957:	89 eb                	mov    %ebp,%ebx
40000959:	80 fb 19             	cmp    $0x19,%bl
4000095c:	77 08                	ja     40000966 <strtol+0xc6>
			dig = *s - 'a' + 10;
4000095e:	0f be d2             	movsbl %dl,%edx
40000961:	83 ea 57             	sub    $0x57,%edx
40000964:	eb 10                	jmp    40000976 <strtol+0xd6>
		else if (*s >= 'A' && *s <= 'Z')
40000966:	8d 6a bf             	lea    -0x41(%edx),%ebp
40000969:	89 eb                	mov    %ebp,%ebx
4000096b:	80 fb 19             	cmp    $0x19,%bl
4000096e:	77 17                	ja     40000987 <strtol+0xe7>
			dig = *s - 'A' + 10;
40000970:	0f be d2             	movsbl %dl,%edx
40000973:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
40000976:	8b 1c 24             	mov    (%esp),%ebx
40000979:	39 da                	cmp    %ebx,%edx
4000097b:	7d 0a                	jge    40000987 <strtol+0xe7>
			break;
		s++, val = (val * base) + dig;
4000097d:	83 c1 01             	add    $0x1,%ecx
40000980:	0f af c3             	imul   %ebx,%eax
40000983:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
40000985:	eb b8                	jmp    4000093f <strtol+0x9f>

	if (endptr)
40000987:	85 f6                	test   %esi,%esi
40000989:	74 02                	je     4000098d <strtol+0xed>
		*endptr = (char *) s;
4000098b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
4000098d:	85 ff                	test   %edi,%edi
4000098f:	74 02                	je     40000993 <strtol+0xf3>
40000991:	f7 d8                	neg    %eax
}
40000993:	83 c4 04             	add    $0x4,%esp
40000996:	5b                   	pop    %ebx
40000997:	5e                   	pop    %esi
40000998:	5f                   	pop    %edi
40000999:	5d                   	pop    %ebp
4000099a:	c3                   	ret    

4000099b <memset>:

void *
memset(void *v, int c, size_t n)
{
4000099b:	57                   	push   %edi
4000099c:	53                   	push   %ebx
4000099d:	8b 7c 24 0c          	mov    0xc(%esp),%edi
400009a1:	8b 4c 24 14          	mov    0x14(%esp),%ecx
	if (n == 0)
400009a5:	85 c9                	test   %ecx,%ecx
400009a7:	74 36                	je     400009df <memset+0x44>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
400009a9:	f7 c7 03 00 00 00    	test   $0x3,%edi
400009af:	75 27                	jne    400009d8 <memset+0x3d>
400009b1:	f6 c1 03             	test   $0x3,%cl
400009b4:	75 22                	jne    400009d8 <memset+0x3d>
		c &= 0xFF;
400009b6:	0f b6 54 24 10       	movzbl 0x10(%esp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
400009bb:	89 d3                	mov    %edx,%ebx
400009bd:	c1 e3 18             	shl    $0x18,%ebx
400009c0:	89 d0                	mov    %edx,%eax
400009c2:	c1 e0 10             	shl    $0x10,%eax
400009c5:	09 d8                	or     %ebx,%eax
400009c7:	89 d3                	mov    %edx,%ebx
400009c9:	c1 e3 08             	shl    $0x8,%ebx
400009cc:	09 d8                	or     %ebx,%eax
400009ce:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
400009d0:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
400009d3:	fc                   	cld    
400009d4:	f3 ab                	rep stos %eax,%es:(%edi)
400009d6:	eb 07                	jmp    400009df <memset+0x44>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
400009d8:	8b 44 24 10          	mov    0x10(%esp),%eax
400009dc:	fc                   	cld    
400009dd:	f3 aa                	rep stos %al,%es:(%edi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
}
400009df:	89 f8                	mov    %edi,%eax
400009e1:	5b                   	pop    %ebx
400009e2:	5f                   	pop    %edi
400009e3:	c3                   	ret    

400009e4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
400009e4:	57                   	push   %edi
400009e5:	56                   	push   %esi
400009e6:	8b 44 24 0c          	mov    0xc(%esp),%eax
400009ea:	8b 74 24 10          	mov    0x10(%esp),%esi
400009ee:	8b 4c 24 14          	mov    0x14(%esp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
400009f2:	39 c6                	cmp    %eax,%esi
400009f4:	73 36                	jae    40000a2c <memmove+0x48>
400009f6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
400009f9:	39 d0                	cmp    %edx,%eax
400009fb:	73 2f                	jae    40000a2c <memmove+0x48>
		s += n;
		d += n;
400009fd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000a00:	f6 c2 03             	test   $0x3,%dl
40000a03:	75 1b                	jne    40000a20 <memmove+0x3c>
40000a05:	f7 c7 03 00 00 00    	test   $0x3,%edi
40000a0b:	75 13                	jne    40000a20 <memmove+0x3c>
40000a0d:	f6 c1 03             	test   $0x3,%cl
40000a10:	75 0e                	jne    40000a20 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
40000a12:	83 ef 04             	sub    $0x4,%edi
40000a15:	8d 72 fc             	lea    -0x4(%edx),%esi
40000a18:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
40000a1b:	fd                   	std    
40000a1c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000a1e:	eb 09                	jmp    40000a29 <memmove+0x45>
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n)
40000a20:	83 ef 01             	sub    $0x1,%edi
40000a23:	8d 72 ff             	lea    -0x1(%edx),%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
40000a26:	fd                   	std    
40000a27:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d-1), "S" (s-1), "c" (n)
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
40000a29:	fc                   	cld    
40000a2a:	eb 20                	jmp    40000a4c <memmove+0x68>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
40000a2c:	f7 c6 03 00 00 00    	test   $0x3,%esi
40000a32:	75 13                	jne    40000a47 <memmove+0x63>
40000a34:	a8 03                	test   $0x3,%al
40000a36:	75 0f                	jne    40000a47 <memmove+0x63>
40000a38:	f6 c1 03             	test   $0x3,%cl
40000a3b:	75 0a                	jne    40000a47 <memmove+0x63>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4)
40000a3d:	c1 e9 02             	shr    $0x2,%ecx
				     : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
40000a40:	89 c7                	mov    %eax,%edi
40000a42:	fc                   	cld    
40000a43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
40000a45:	eb 05                	jmp    40000a4c <memmove+0x68>
				     :: "D" (d), "S" (s), "c" (n/4)
				     : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
40000a47:	89 c7                	mov    %eax,%edi
40000a49:	fc                   	cld    
40000a4a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				     :: "D" (d), "S" (s), "c" (n)
				     : "cc", "memory");
	}
	return dst;
}
40000a4c:	5e                   	pop    %esi
40000a4d:	5f                   	pop    %edi
40000a4e:	c3                   	ret    

40000a4f <memcpy>:

void *
memcpy(void *dst, const void *src, size_t n)
{
	return memmove(dst, src, n);
40000a4f:	ff 74 24 0c          	pushl  0xc(%esp)
40000a53:	ff 74 24 0c          	pushl  0xc(%esp)
40000a57:	ff 74 24 0c          	pushl  0xc(%esp)
40000a5b:	e8 84 ff ff ff       	call   400009e4 <memmove>
40000a60:	83 c4 0c             	add    $0xc,%esp
}
40000a63:	c3                   	ret    

40000a64 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
40000a64:	56                   	push   %esi
40000a65:	53                   	push   %ebx
40000a66:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
40000a6a:	8b 54 24 10          	mov    0x10(%esp),%edx
40000a6e:	8b 44 24 14          	mov    0x14(%esp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
40000a72:	eb 1c                	jmp    40000a90 <memcmp+0x2c>
		if (*s1 != *s2)
40000a74:	0f b6 01             	movzbl (%ecx),%eax
40000a77:	0f b6 1a             	movzbl (%edx),%ebx
40000a7a:	38 d8                	cmp    %bl,%al
40000a7c:	74 0a                	je     40000a88 <memcmp+0x24>
			return (int) *s1 - (int) *s2;
40000a7e:	0f b6 db             	movzbl %bl,%ebx
40000a81:	0f b6 c0             	movzbl %al,%eax
40000a84:	29 d8                	sub    %ebx,%eax
40000a86:	eb 0f                	jmp    40000a97 <memcmp+0x33>
		s1++, s2++;
40000a88:	83 c1 01             	add    $0x1,%ecx
40000a8b:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
40000a8e:	89 f0                	mov    %esi,%eax
40000a90:	8d 70 ff             	lea    -0x1(%eax),%esi
40000a93:	85 c0                	test   %eax,%eax
40000a95:	75 dd                	jne    40000a74 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
40000a97:	5b                   	pop    %ebx
40000a98:	5e                   	pop    %esi
40000a99:	c3                   	ret    

40000a9a <memchr>:

void *
memchr(const void *s, int c, size_t n)
{
40000a9a:	56                   	push   %esi
40000a9b:	53                   	push   %ebx
40000a9c:	8b 44 24 0c          	mov    0xc(%esp),%eax
40000aa0:	8b 74 24 10          	mov    0x10(%esp),%esi
	const void *ends = (const char *) s + n;
40000aa4:	89 c3                	mov    %eax,%ebx
40000aa6:	03 5c 24 14          	add    0x14(%esp),%ebx
	for (; s < ends; s++)
40000aaa:	eb 0f                	jmp    40000abb <memchr+0x21>
		if (*(const unsigned char *) s == (unsigned char) c)
40000aac:	0f b6 08             	movzbl (%eax),%ecx
40000aaf:	89 f2                	mov    %esi,%edx
40000ab1:	0f b6 d2             	movzbl %dl,%edx
40000ab4:	39 d1                	cmp    %edx,%ecx
40000ab6:	74 0c                	je     40000ac4 <memchr+0x2a>

void *
memchr(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
40000ab8:	83 c0 01             	add    $0x1,%eax
40000abb:	39 d8                	cmp    %ebx,%eax
40000abd:	72 ed                	jb     40000aac <memchr+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			return (void *) s;
	return NULL;
40000abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
40000ac4:	5b                   	pop    %ebx
40000ac5:	5e                   	pop    %esi
40000ac6:	c3                   	ret    

40000ac7 <memzero>:

void *
memzero(void *v, size_t n)
{
	return memset(v, 0, n);
40000ac7:	ff 74 24 08          	pushl  0x8(%esp)
40000acb:	6a 00                	push   $0x0
40000acd:	ff 74 24 0c          	pushl  0xc(%esp)
40000ad1:	e8 c5 fe ff ff       	call   4000099b <memset>
40000ad6:	83 c4 0c             	add    $0xc,%esp
}
40000ad9:	c3                   	ret    

40000ada <main>:
#include <stdio.h>
#include <syscall.h>
#include <x86.h>

int main (int argc, char **argv)
{
40000ada:	8d 4c 24 04          	lea    0x4(%esp),%ecx
40000ade:	83 e4 f0             	and    $0xfffffff0,%esp
40000ae1:	ff 71 fc             	pushl  -0x4(%ecx)
40000ae4:	55                   	push   %ebp
40000ae5:	89 e5                	mov    %esp,%ebp
40000ae7:	51                   	push   %ecx
40000ae8:	83 ec 10             	sub    $0x10,%esp
    printf("pong started.\n");
40000aeb:	68 78 0f 00 40       	push   $0x40000f78
40000af0:	e8 be f6 ff ff       	call   400001b3 <printf>
    unsigned int val = 200;
    unsigned int *addr = (unsigned int *)0xe0000000;
    printf("pong: the value at address %x: %d\n", addr, *addr);
40000af5:	83 c4 0c             	add    $0xc,%esp
40000af8:	ff 35 00 00 00 e0    	pushl  0xe0000000
40000afe:	68 00 00 00 e0       	push   $0xe0000000
40000b03:	68 88 0f 00 40       	push   $0x40000f88
40000b08:	e8 a6 f6 ff ff       	call   400001b3 <printf>
    printf("pong: writing the value %d to the address %x\n", val, addr);
40000b0d:	83 c4 0c             	add    $0xc,%esp
40000b10:	68 00 00 00 e0       	push   $0xe0000000
40000b15:	68 c8 00 00 00       	push   $0xc8
40000b1a:	68 ac 0f 00 40       	push   $0x40000fac
40000b1f:	e8 8f f6 ff ff       	call   400001b3 <printf>
    *addr = val;
40000b24:	c7 05 00 00 00 e0 c8 	movl   $0xc8,0xe0000000
40000b2b:	00 00 00 
    yield();
40000b2e:	e8 04 fc ff ff       	call   40000737 <yield>
    printf("pong: the new value at address %x: %d\n", addr, *addr);
40000b33:	83 c4 0c             	add    $0xc,%esp
40000b36:	ff 35 00 00 00 e0    	pushl  0xe0000000
40000b3c:	68 00 00 00 e0       	push   $0xe0000000
40000b41:	68 dc 0f 00 40       	push   $0x40000fdc
40000b46:	e8 68 f6 ff ff       	call   400001b3 <printf>
40000b4b:	83 c4 10             	add    $0x10,%esp

    return 0;
}
40000b4e:	b8 00 00 00 00       	mov    $0x0,%eax
40000b53:	8b 4d fc             	mov    -0x4(%ebp),%ecx
40000b56:	c9                   	leave  
40000b57:	8d 61 fc             	lea    -0x4(%ecx),%esp
40000b5a:	c3                   	ret    
40000b5b:	66 90                	xchg   %ax,%ax
40000b5d:	66 90                	xchg   %ax,%ax
40000b5f:	90                   	nop

40000b60 <__udivdi3>:
40000b60:	55                   	push   %ebp
40000b61:	57                   	push   %edi
40000b62:	56                   	push   %esi
40000b63:	53                   	push   %ebx
40000b64:	83 ec 1c             	sub    $0x1c,%esp
40000b67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
40000b6b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
40000b6f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
40000b73:	8b 7c 24 38          	mov    0x38(%esp),%edi
40000b77:	85 f6                	test   %esi,%esi
40000b79:	89 5c 24 08          	mov    %ebx,0x8(%esp)
40000b7d:	89 ca                	mov    %ecx,%edx
40000b7f:	89 f8                	mov    %edi,%eax
40000b81:	75 3d                	jne    40000bc0 <__udivdi3+0x60>
40000b83:	39 cf                	cmp    %ecx,%edi
40000b85:	0f 87 c5 00 00 00    	ja     40000c50 <__udivdi3+0xf0>
40000b8b:	85 ff                	test   %edi,%edi
40000b8d:	89 fd                	mov    %edi,%ebp
40000b8f:	75 0b                	jne    40000b9c <__udivdi3+0x3c>
40000b91:	b8 01 00 00 00       	mov    $0x1,%eax
40000b96:	31 d2                	xor    %edx,%edx
40000b98:	f7 f7                	div    %edi
40000b9a:	89 c5                	mov    %eax,%ebp
40000b9c:	89 c8                	mov    %ecx,%eax
40000b9e:	31 d2                	xor    %edx,%edx
40000ba0:	f7 f5                	div    %ebp
40000ba2:	89 c1                	mov    %eax,%ecx
40000ba4:	89 d8                	mov    %ebx,%eax
40000ba6:	89 cf                	mov    %ecx,%edi
40000ba8:	f7 f5                	div    %ebp
40000baa:	89 c3                	mov    %eax,%ebx
40000bac:	89 d8                	mov    %ebx,%eax
40000bae:	89 fa                	mov    %edi,%edx
40000bb0:	83 c4 1c             	add    $0x1c,%esp
40000bb3:	5b                   	pop    %ebx
40000bb4:	5e                   	pop    %esi
40000bb5:	5f                   	pop    %edi
40000bb6:	5d                   	pop    %ebp
40000bb7:	c3                   	ret    
40000bb8:	90                   	nop
40000bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000bc0:	39 ce                	cmp    %ecx,%esi
40000bc2:	77 74                	ja     40000c38 <__udivdi3+0xd8>
40000bc4:	0f bd fe             	bsr    %esi,%edi
40000bc7:	83 f7 1f             	xor    $0x1f,%edi
40000bca:	0f 84 98 00 00 00    	je     40000c68 <__udivdi3+0x108>
40000bd0:	bb 20 00 00 00       	mov    $0x20,%ebx
40000bd5:	89 f9                	mov    %edi,%ecx
40000bd7:	89 c5                	mov    %eax,%ebp
40000bd9:	29 fb                	sub    %edi,%ebx
40000bdb:	d3 e6                	shl    %cl,%esi
40000bdd:	89 d9                	mov    %ebx,%ecx
40000bdf:	d3 ed                	shr    %cl,%ebp
40000be1:	89 f9                	mov    %edi,%ecx
40000be3:	d3 e0                	shl    %cl,%eax
40000be5:	09 ee                	or     %ebp,%esi
40000be7:	89 d9                	mov    %ebx,%ecx
40000be9:	89 44 24 0c          	mov    %eax,0xc(%esp)
40000bed:	89 d5                	mov    %edx,%ebp
40000bef:	8b 44 24 08          	mov    0x8(%esp),%eax
40000bf3:	d3 ed                	shr    %cl,%ebp
40000bf5:	89 f9                	mov    %edi,%ecx
40000bf7:	d3 e2                	shl    %cl,%edx
40000bf9:	89 d9                	mov    %ebx,%ecx
40000bfb:	d3 e8                	shr    %cl,%eax
40000bfd:	09 c2                	or     %eax,%edx
40000bff:	89 d0                	mov    %edx,%eax
40000c01:	89 ea                	mov    %ebp,%edx
40000c03:	f7 f6                	div    %esi
40000c05:	89 d5                	mov    %edx,%ebp
40000c07:	89 c3                	mov    %eax,%ebx
40000c09:	f7 64 24 0c          	mull   0xc(%esp)
40000c0d:	39 d5                	cmp    %edx,%ebp
40000c0f:	72 10                	jb     40000c21 <__udivdi3+0xc1>
40000c11:	8b 74 24 08          	mov    0x8(%esp),%esi
40000c15:	89 f9                	mov    %edi,%ecx
40000c17:	d3 e6                	shl    %cl,%esi
40000c19:	39 c6                	cmp    %eax,%esi
40000c1b:	73 07                	jae    40000c24 <__udivdi3+0xc4>
40000c1d:	39 d5                	cmp    %edx,%ebp
40000c1f:	75 03                	jne    40000c24 <__udivdi3+0xc4>
40000c21:	83 eb 01             	sub    $0x1,%ebx
40000c24:	31 ff                	xor    %edi,%edi
40000c26:	89 d8                	mov    %ebx,%eax
40000c28:	89 fa                	mov    %edi,%edx
40000c2a:	83 c4 1c             	add    $0x1c,%esp
40000c2d:	5b                   	pop    %ebx
40000c2e:	5e                   	pop    %esi
40000c2f:	5f                   	pop    %edi
40000c30:	5d                   	pop    %ebp
40000c31:	c3                   	ret    
40000c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000c38:	31 ff                	xor    %edi,%edi
40000c3a:	31 db                	xor    %ebx,%ebx
40000c3c:	89 d8                	mov    %ebx,%eax
40000c3e:	89 fa                	mov    %edi,%edx
40000c40:	83 c4 1c             	add    $0x1c,%esp
40000c43:	5b                   	pop    %ebx
40000c44:	5e                   	pop    %esi
40000c45:	5f                   	pop    %edi
40000c46:	5d                   	pop    %ebp
40000c47:	c3                   	ret    
40000c48:	90                   	nop
40000c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000c50:	89 d8                	mov    %ebx,%eax
40000c52:	f7 f7                	div    %edi
40000c54:	31 ff                	xor    %edi,%edi
40000c56:	89 c3                	mov    %eax,%ebx
40000c58:	89 d8                	mov    %ebx,%eax
40000c5a:	89 fa                	mov    %edi,%edx
40000c5c:	83 c4 1c             	add    $0x1c,%esp
40000c5f:	5b                   	pop    %ebx
40000c60:	5e                   	pop    %esi
40000c61:	5f                   	pop    %edi
40000c62:	5d                   	pop    %ebp
40000c63:	c3                   	ret    
40000c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000c68:	39 ce                	cmp    %ecx,%esi
40000c6a:	72 0c                	jb     40000c78 <__udivdi3+0x118>
40000c6c:	31 db                	xor    %ebx,%ebx
40000c6e:	3b 44 24 08          	cmp    0x8(%esp),%eax
40000c72:	0f 87 34 ff ff ff    	ja     40000bac <__udivdi3+0x4c>
40000c78:	bb 01 00 00 00       	mov    $0x1,%ebx
40000c7d:	e9 2a ff ff ff       	jmp    40000bac <__udivdi3+0x4c>
40000c82:	66 90                	xchg   %ax,%ax
40000c84:	66 90                	xchg   %ax,%ax
40000c86:	66 90                	xchg   %ax,%ax
40000c88:	66 90                	xchg   %ax,%ax
40000c8a:	66 90                	xchg   %ax,%ax
40000c8c:	66 90                	xchg   %ax,%ax
40000c8e:	66 90                	xchg   %ax,%ax

40000c90 <__umoddi3>:
40000c90:	55                   	push   %ebp
40000c91:	57                   	push   %edi
40000c92:	56                   	push   %esi
40000c93:	53                   	push   %ebx
40000c94:	83 ec 1c             	sub    $0x1c,%esp
40000c97:	8b 54 24 3c          	mov    0x3c(%esp),%edx
40000c9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
40000c9f:	8b 74 24 34          	mov    0x34(%esp),%esi
40000ca3:	8b 7c 24 38          	mov    0x38(%esp),%edi
40000ca7:	85 d2                	test   %edx,%edx
40000ca9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
40000cad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40000cb1:	89 f3                	mov    %esi,%ebx
40000cb3:	89 3c 24             	mov    %edi,(%esp)
40000cb6:	89 74 24 04          	mov    %esi,0x4(%esp)
40000cba:	75 1c                	jne    40000cd8 <__umoddi3+0x48>
40000cbc:	39 f7                	cmp    %esi,%edi
40000cbe:	76 50                	jbe    40000d10 <__umoddi3+0x80>
40000cc0:	89 c8                	mov    %ecx,%eax
40000cc2:	89 f2                	mov    %esi,%edx
40000cc4:	f7 f7                	div    %edi
40000cc6:	89 d0                	mov    %edx,%eax
40000cc8:	31 d2                	xor    %edx,%edx
40000cca:	83 c4 1c             	add    $0x1c,%esp
40000ccd:	5b                   	pop    %ebx
40000cce:	5e                   	pop    %esi
40000ccf:	5f                   	pop    %edi
40000cd0:	5d                   	pop    %ebp
40000cd1:	c3                   	ret    
40000cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
40000cd8:	39 f2                	cmp    %esi,%edx
40000cda:	89 d0                	mov    %edx,%eax
40000cdc:	77 52                	ja     40000d30 <__umoddi3+0xa0>
40000cde:	0f bd ea             	bsr    %edx,%ebp
40000ce1:	83 f5 1f             	xor    $0x1f,%ebp
40000ce4:	75 5a                	jne    40000d40 <__umoddi3+0xb0>
40000ce6:	3b 54 24 04          	cmp    0x4(%esp),%edx
40000cea:	0f 82 e0 00 00 00    	jb     40000dd0 <__umoddi3+0x140>
40000cf0:	39 0c 24             	cmp    %ecx,(%esp)
40000cf3:	0f 86 d7 00 00 00    	jbe    40000dd0 <__umoddi3+0x140>
40000cf9:	8b 44 24 08          	mov    0x8(%esp),%eax
40000cfd:	8b 54 24 04          	mov    0x4(%esp),%edx
40000d01:	83 c4 1c             	add    $0x1c,%esp
40000d04:	5b                   	pop    %ebx
40000d05:	5e                   	pop    %esi
40000d06:	5f                   	pop    %edi
40000d07:	5d                   	pop    %ebp
40000d08:	c3                   	ret    
40000d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
40000d10:	85 ff                	test   %edi,%edi
40000d12:	89 fd                	mov    %edi,%ebp
40000d14:	75 0b                	jne    40000d21 <__umoddi3+0x91>
40000d16:	b8 01 00 00 00       	mov    $0x1,%eax
40000d1b:	31 d2                	xor    %edx,%edx
40000d1d:	f7 f7                	div    %edi
40000d1f:	89 c5                	mov    %eax,%ebp
40000d21:	89 f0                	mov    %esi,%eax
40000d23:	31 d2                	xor    %edx,%edx
40000d25:	f7 f5                	div    %ebp
40000d27:	89 c8                	mov    %ecx,%eax
40000d29:	f7 f5                	div    %ebp
40000d2b:	89 d0                	mov    %edx,%eax
40000d2d:	eb 99                	jmp    40000cc8 <__umoddi3+0x38>
40000d2f:	90                   	nop
40000d30:	89 c8                	mov    %ecx,%eax
40000d32:	89 f2                	mov    %esi,%edx
40000d34:	83 c4 1c             	add    $0x1c,%esp
40000d37:	5b                   	pop    %ebx
40000d38:	5e                   	pop    %esi
40000d39:	5f                   	pop    %edi
40000d3a:	5d                   	pop    %ebp
40000d3b:	c3                   	ret    
40000d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
40000d40:	8b 34 24             	mov    (%esp),%esi
40000d43:	bf 20 00 00 00       	mov    $0x20,%edi
40000d48:	89 e9                	mov    %ebp,%ecx
40000d4a:	29 ef                	sub    %ebp,%edi
40000d4c:	d3 e0                	shl    %cl,%eax
40000d4e:	89 f9                	mov    %edi,%ecx
40000d50:	89 f2                	mov    %esi,%edx
40000d52:	d3 ea                	shr    %cl,%edx
40000d54:	89 e9                	mov    %ebp,%ecx
40000d56:	09 c2                	or     %eax,%edx
40000d58:	89 d8                	mov    %ebx,%eax
40000d5a:	89 14 24             	mov    %edx,(%esp)
40000d5d:	89 f2                	mov    %esi,%edx
40000d5f:	d3 e2                	shl    %cl,%edx
40000d61:	89 f9                	mov    %edi,%ecx
40000d63:	89 54 24 04          	mov    %edx,0x4(%esp)
40000d67:	8b 54 24 0c          	mov    0xc(%esp),%edx
40000d6b:	d3 e8                	shr    %cl,%eax
40000d6d:	89 e9                	mov    %ebp,%ecx
40000d6f:	89 c6                	mov    %eax,%esi
40000d71:	d3 e3                	shl    %cl,%ebx
40000d73:	89 f9                	mov    %edi,%ecx
40000d75:	89 d0                	mov    %edx,%eax
40000d77:	d3 e8                	shr    %cl,%eax
40000d79:	89 e9                	mov    %ebp,%ecx
40000d7b:	09 d8                	or     %ebx,%eax
40000d7d:	89 d3                	mov    %edx,%ebx
40000d7f:	89 f2                	mov    %esi,%edx
40000d81:	f7 34 24             	divl   (%esp)
40000d84:	89 d6                	mov    %edx,%esi
40000d86:	d3 e3                	shl    %cl,%ebx
40000d88:	f7 64 24 04          	mull   0x4(%esp)
40000d8c:	39 d6                	cmp    %edx,%esi
40000d8e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
40000d92:	89 d1                	mov    %edx,%ecx
40000d94:	89 c3                	mov    %eax,%ebx
40000d96:	72 08                	jb     40000da0 <__umoddi3+0x110>
40000d98:	75 11                	jne    40000dab <__umoddi3+0x11b>
40000d9a:	39 44 24 08          	cmp    %eax,0x8(%esp)
40000d9e:	73 0b                	jae    40000dab <__umoddi3+0x11b>
40000da0:	2b 44 24 04          	sub    0x4(%esp),%eax
40000da4:	1b 14 24             	sbb    (%esp),%edx
40000da7:	89 d1                	mov    %edx,%ecx
40000da9:	89 c3                	mov    %eax,%ebx
40000dab:	8b 54 24 08          	mov    0x8(%esp),%edx
40000daf:	29 da                	sub    %ebx,%edx
40000db1:	19 ce                	sbb    %ecx,%esi
40000db3:	89 f9                	mov    %edi,%ecx
40000db5:	89 f0                	mov    %esi,%eax
40000db7:	d3 e0                	shl    %cl,%eax
40000db9:	89 e9                	mov    %ebp,%ecx
40000dbb:	d3 ea                	shr    %cl,%edx
40000dbd:	89 e9                	mov    %ebp,%ecx
40000dbf:	d3 ee                	shr    %cl,%esi
40000dc1:	09 d0                	or     %edx,%eax
40000dc3:	89 f2                	mov    %esi,%edx
40000dc5:	83 c4 1c             	add    $0x1c,%esp
40000dc8:	5b                   	pop    %ebx
40000dc9:	5e                   	pop    %esi
40000dca:	5f                   	pop    %edi
40000dcb:	5d                   	pop    %ebp
40000dcc:	c3                   	ret    
40000dcd:	8d 76 00             	lea    0x0(%esi),%esi
40000dd0:	29 f9                	sub    %edi,%ecx
40000dd2:	19 d6                	sbb    %edx,%esi
40000dd4:	89 74 24 04          	mov    %esi,0x4(%esp)
40000dd8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
40000ddc:	e9 18 ff ff ff       	jmp    40000cf9 <__umoddi3+0x69>
