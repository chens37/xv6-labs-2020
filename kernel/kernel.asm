
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	83010113          	addi	sp,sp,-2000 # 80009830 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	072000ef          	jal	ra,80000088 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000028:	0037969b          	slliw	a3,a5,0x3
    8000002c:	02004737          	lui	a4,0x2004
    80000030:	96ba                	add	a3,a3,a4
    80000032:	0200c737          	lui	a4,0x200c
    80000036:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003a:	000f4737          	lui	a4,0xf4
    8000003e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000042:	963a                	add	a2,a2,a4
    80000044:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000046:	0057979b          	slliw	a5,a5,0x5
    8000004a:	078e                	slli	a5,a5,0x3
    8000004c:	00009617          	auipc	a2,0x9
    80000050:	fe460613          	addi	a2,a2,-28 # 80009030 <mscratch0>
    80000054:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000056:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000058:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005a:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005e:	00006797          	auipc	a5,0x6
    80000062:	cb278793          	addi	a5,a5,-846 # 80005d10 <timervec>
    80000066:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000072:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000076:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007e:	30479073          	csrw	mie,a5
}
    80000082:	6422                	ld	s0,8(sp)
    80000084:	0141                	addi	sp,sp,16
    80000086:	8082                	ret

0000000080000088 <start>:
{
    80000088:	1141                	addi	sp,sp,-16
    8000008a:	e406                	sd	ra,8(sp)
    8000008c:	e022                	sd	s0,0(sp)
    8000008e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000090:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000094:	7779                	lui	a4,0xffffe
    80000096:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    8000009a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009c:	6705                	lui	a4,0x1
    8000009e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a8:	00001797          	auipc	a5,0x1
    800000ac:	e8a78793          	addi	a5,a5,-374 # 80000f32 <main>
    800000b0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b4:	4781                	li	a5,0
    800000b6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000ba:	67c1                	lui	a5,0x10
    800000bc:	17fd                	addi	a5,a5,-1
    800000be:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ca:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000ce:	10479073          	csrw	sie,a5
  timerinit();
    800000d2:	00000097          	auipc	ra,0x0
    800000d6:	f4a080e7          	jalr	-182(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000da:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000de:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e0:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e2:	30200073          	mret
}
    800000e6:	60a2                	ld	ra,8(sp)
    800000e8:	6402                	ld	s0,0(sp)
    800000ea:	0141                	addi	sp,sp,16
    800000ec:	8082                	ret

00000000800000ee <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000ee:	715d                	addi	sp,sp,-80
    800000f0:	e486                	sd	ra,72(sp)
    800000f2:	e0a2                	sd	s0,64(sp)
    800000f4:	fc26                	sd	s1,56(sp)
    800000f6:	f84a                	sd	s2,48(sp)
    800000f8:	f44e                	sd	s3,40(sp)
    800000fa:	f052                	sd	s4,32(sp)
    800000fc:	ec56                	sd	s5,24(sp)
    800000fe:	0880                	addi	s0,sp,80
    80000100:	8a2a                	mv	s4,a0
    80000102:	892e                	mv	s2,a1
    80000104:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    80000106:	00011517          	auipc	a0,0x11
    8000010a:	72a50513          	addi	a0,a0,1834 # 80011830 <cons>
    8000010e:	00001097          	auipc	ra,0x1
    80000112:	b54080e7          	jalr	-1196(ra) # 80000c62 <acquire>
  for(i = 0; i < n; i++){
    80000116:	05305b63          	blez	s3,8000016c <consolewrite+0x7e>
    8000011a:	4481                	li	s1,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011c:	5afd                	li	s5,-1
    8000011e:	4685                	li	a3,1
    80000120:	864a                	mv	a2,s2
    80000122:	85d2                	mv	a1,s4
    80000124:	fbf40513          	addi	a0,s0,-65
    80000128:	00002097          	auipc	ra,0x2
    8000012c:	416080e7          	jalr	1046(ra) # 8000253e <either_copyin>
    80000130:	01550c63          	beq	a0,s5,80000148 <consolewrite+0x5a>
      break;
    uartputc(c);
    80000134:	fbf44503          	lbu	a0,-65(s0)
    80000138:	00000097          	auipc	ra,0x0
    8000013c:	7ee080e7          	jalr	2030(ra) # 80000926 <uartputc>
  for(i = 0; i < n; i++){
    80000140:	2485                	addiw	s1,s1,1
    80000142:	0905                	addi	s2,s2,1
    80000144:	fc999de3          	bne	s3,s1,8000011e <consolewrite+0x30>
  }
  release(&cons.lock);
    80000148:	00011517          	auipc	a0,0x11
    8000014c:	6e850513          	addi	a0,a0,1768 # 80011830 <cons>
    80000150:	00001097          	auipc	ra,0x1
    80000154:	bc6080e7          	jalr	-1082(ra) # 80000d16 <release>

  return i;
}
    80000158:	8526                	mv	a0,s1
    8000015a:	60a6                	ld	ra,72(sp)
    8000015c:	6406                	ld	s0,64(sp)
    8000015e:	74e2                	ld	s1,56(sp)
    80000160:	7942                	ld	s2,48(sp)
    80000162:	79a2                	ld	s3,40(sp)
    80000164:	7a02                	ld	s4,32(sp)
    80000166:	6ae2                	ld	s5,24(sp)
    80000168:	6161                	addi	sp,sp,80
    8000016a:	8082                	ret
  for(i = 0; i < n; i++){
    8000016c:	4481                	li	s1,0
    8000016e:	bfe9                	j	80000148 <consolewrite+0x5a>

0000000080000170 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000170:	7119                	addi	sp,sp,-128
    80000172:	fc86                	sd	ra,120(sp)
    80000174:	f8a2                	sd	s0,112(sp)
    80000176:	f4a6                	sd	s1,104(sp)
    80000178:	f0ca                	sd	s2,96(sp)
    8000017a:	ecce                	sd	s3,88(sp)
    8000017c:	e8d2                	sd	s4,80(sp)
    8000017e:	e4d6                	sd	s5,72(sp)
    80000180:	e0da                	sd	s6,64(sp)
    80000182:	fc5e                	sd	s7,56(sp)
    80000184:	f862                	sd	s8,48(sp)
    80000186:	f466                	sd	s9,40(sp)
    80000188:	f06a                	sd	s10,32(sp)
    8000018a:	ec6e                	sd	s11,24(sp)
    8000018c:	0100                	addi	s0,sp,128
    8000018e:	8caa                	mv	s9,a0
    80000190:	8aae                	mv	s5,a1
    80000192:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000194:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000198:	00011517          	auipc	a0,0x11
    8000019c:	69850513          	addi	a0,a0,1688 # 80011830 <cons>
    800001a0:	00001097          	auipc	ra,0x1
    800001a4:	ac2080e7          	jalr	-1342(ra) # 80000c62 <acquire>
  while(n > 0){
    800001a8:	09405663          	blez	s4,80000234 <consoleread+0xc4>
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001ac:	00011497          	auipc	s1,0x11
    800001b0:	68448493          	addi	s1,s1,1668 # 80011830 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b4:	89a6                	mv	s3,s1
    800001b6:	00011917          	auipc	s2,0x11
    800001ba:	71290913          	addi	s2,s2,1810 # 800118c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001be:	4c11                	li	s8,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c0:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001c2:	4da9                	li	s11,10
    while(cons.r == cons.w){
    800001c4:	0984a783          	lw	a5,152(s1)
    800001c8:	09c4a703          	lw	a4,156(s1)
    800001cc:	02f71463          	bne	a4,a5,800001f4 <consoleread+0x84>
      if(myproc()->killed){
    800001d0:	00002097          	auipc	ra,0x2
    800001d4:	8a0080e7          	jalr	-1888(ra) # 80001a70 <myproc>
    800001d8:	591c                	lw	a5,48(a0)
    800001da:	eba5                	bnez	a5,8000024a <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800001dc:	85ce                	mv	a1,s3
    800001de:	854a                	mv	a0,s2
    800001e0:	00002097          	auipc	ra,0x2
    800001e4:	0a6080e7          	jalr	166(ra) # 80002286 <sleep>
    while(cons.r == cons.w){
    800001e8:	0984a783          	lw	a5,152(s1)
    800001ec:	09c4a703          	lw	a4,156(s1)
    800001f0:	fef700e3          	beq	a4,a5,800001d0 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001f4:	0017871b          	addiw	a4,a5,1
    800001f8:	08e4ac23          	sw	a4,152(s1)
    800001fc:	07f7f713          	andi	a4,a5,127
    80000200:	9726                	add	a4,a4,s1
    80000202:	01874703          	lbu	a4,24(a4)
    80000206:	00070b9b          	sext.w	s7,a4
    if(c == C('D')){  // end-of-file
    8000020a:	078b8863          	beq	s7,s8,8000027a <consoleread+0x10a>
    cbuf = c;
    8000020e:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000212:	4685                	li	a3,1
    80000214:	f8f40613          	addi	a2,s0,-113
    80000218:	85d6                	mv	a1,s5
    8000021a:	8566                	mv	a0,s9
    8000021c:	00002097          	auipc	ra,0x2
    80000220:	2cc080e7          	jalr	716(ra) # 800024e8 <either_copyout>
    80000224:	01a50863          	beq	a0,s10,80000234 <consoleread+0xc4>
    dst++;
    80000228:	0a85                	addi	s5,s5,1
    --n;
    8000022a:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000022c:	01bb8463          	beq	s7,s11,80000234 <consoleread+0xc4>
  while(n > 0){
    80000230:	f80a1ae3          	bnez	s4,800001c4 <consoleread+0x54>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000234:	00011517          	auipc	a0,0x11
    80000238:	5fc50513          	addi	a0,a0,1532 # 80011830 <cons>
    8000023c:	00001097          	auipc	ra,0x1
    80000240:	ada080e7          	jalr	-1318(ra) # 80000d16 <release>

  return target - n;
    80000244:	414b053b          	subw	a0,s6,s4
    80000248:	a811                	j	8000025c <consoleread+0xec>
        release(&cons.lock);
    8000024a:	00011517          	auipc	a0,0x11
    8000024e:	5e650513          	addi	a0,a0,1510 # 80011830 <cons>
    80000252:	00001097          	auipc	ra,0x1
    80000256:	ac4080e7          	jalr	-1340(ra) # 80000d16 <release>
        return -1;
    8000025a:	557d                	li	a0,-1
}
    8000025c:	70e6                	ld	ra,120(sp)
    8000025e:	7446                	ld	s0,112(sp)
    80000260:	74a6                	ld	s1,104(sp)
    80000262:	7906                	ld	s2,96(sp)
    80000264:	69e6                	ld	s3,88(sp)
    80000266:	6a46                	ld	s4,80(sp)
    80000268:	6aa6                	ld	s5,72(sp)
    8000026a:	6b06                	ld	s6,64(sp)
    8000026c:	7be2                	ld	s7,56(sp)
    8000026e:	7c42                	ld	s8,48(sp)
    80000270:	7ca2                	ld	s9,40(sp)
    80000272:	7d02                	ld	s10,32(sp)
    80000274:	6de2                	ld	s11,24(sp)
    80000276:	6109                	addi	sp,sp,128
    80000278:	8082                	ret
      if(n < target){
    8000027a:	000a071b          	sext.w	a4,s4
    8000027e:	fb677be3          	bleu	s6,a4,80000234 <consoleread+0xc4>
        cons.r--;
    80000282:	00011717          	auipc	a4,0x11
    80000286:	64f72323          	sw	a5,1606(a4) # 800118c8 <cons+0x98>
    8000028a:	b76d                	j	80000234 <consoleread+0xc4>

000000008000028c <consputc>:
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e406                	sd	ra,8(sp)
    80000290:	e022                	sd	s0,0(sp)
    80000292:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000294:	10000793          	li	a5,256
    80000298:	00f50a63          	beq	a0,a5,800002ac <consputc+0x20>
    uartputc_sync(c);
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	58a080e7          	jalr	1418(ra) # 80000826 <uartputc_sync>
}
    800002a4:	60a2                	ld	ra,8(sp)
    800002a6:	6402                	ld	s0,0(sp)
    800002a8:	0141                	addi	sp,sp,16
    800002aa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002ac:	4521                	li	a0,8
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	578080e7          	jalr	1400(ra) # 80000826 <uartputc_sync>
    800002b6:	02000513          	li	a0,32
    800002ba:	00000097          	auipc	ra,0x0
    800002be:	56c080e7          	jalr	1388(ra) # 80000826 <uartputc_sync>
    800002c2:	4521                	li	a0,8
    800002c4:	00000097          	auipc	ra,0x0
    800002c8:	562080e7          	jalr	1378(ra) # 80000826 <uartputc_sync>
    800002cc:	bfe1                	j	800002a4 <consputc+0x18>

00000000800002ce <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ce:	1101                	addi	sp,sp,-32
    800002d0:	ec06                	sd	ra,24(sp)
    800002d2:	e822                	sd	s0,16(sp)
    800002d4:	e426                	sd	s1,8(sp)
    800002d6:	e04a                	sd	s2,0(sp)
    800002d8:	1000                	addi	s0,sp,32
    800002da:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002dc:	00011517          	auipc	a0,0x11
    800002e0:	55450513          	addi	a0,a0,1364 # 80011830 <cons>
    800002e4:	00001097          	auipc	ra,0x1
    800002e8:	97e080e7          	jalr	-1666(ra) # 80000c62 <acquire>

  switch(c){
    800002ec:	47c1                	li	a5,16
    800002ee:	12f48463          	beq	s1,a5,80000416 <consoleintr+0x148>
    800002f2:	0297df63          	ble	s1,a5,80000330 <consoleintr+0x62>
    800002f6:	47d5                	li	a5,21
    800002f8:	0af48863          	beq	s1,a5,800003a8 <consoleintr+0xda>
    800002fc:	07f00793          	li	a5,127
    80000300:	02f49b63          	bne	s1,a5,80000336 <consoleintr+0x68>
      consputc(BACKSPACE);
    }
    break;
  case C('H'): // Backspace
  case '\x7f':
    if(cons.e != cons.w){
    80000304:	00011717          	auipc	a4,0x11
    80000308:	52c70713          	addi	a4,a4,1324 # 80011830 <cons>
    8000030c:	0a072783          	lw	a5,160(a4)
    80000310:	09c72703          	lw	a4,156(a4)
    80000314:	10f70563          	beq	a4,a5,8000041e <consoleintr+0x150>
      cons.e--;
    80000318:	37fd                	addiw	a5,a5,-1
    8000031a:	00011717          	auipc	a4,0x11
    8000031e:	5af72b23          	sw	a5,1462(a4) # 800118d0 <cons+0xa0>
      consputc(BACKSPACE);
    80000322:	10000513          	li	a0,256
    80000326:	00000097          	auipc	ra,0x0
    8000032a:	f66080e7          	jalr	-154(ra) # 8000028c <consputc>
    8000032e:	a8c5                	j	8000041e <consoleintr+0x150>
  switch(c){
    80000330:	47a1                	li	a5,8
    80000332:	fcf489e3          	beq	s1,a5,80000304 <consoleintr+0x36>
    }
    break;
  default:
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000336:	c4e5                	beqz	s1,8000041e <consoleintr+0x150>
    80000338:	00011717          	auipc	a4,0x11
    8000033c:	4f870713          	addi	a4,a4,1272 # 80011830 <cons>
    80000340:	0a072783          	lw	a5,160(a4)
    80000344:	09872703          	lw	a4,152(a4)
    80000348:	9f99                	subw	a5,a5,a4
    8000034a:	07f00713          	li	a4,127
    8000034e:	0cf76863          	bltu	a4,a5,8000041e <consoleintr+0x150>
      c = (c == '\r') ? '\n' : c;
    80000352:	47b5                	li	a5,13
    80000354:	0ef48363          	beq	s1,a5,8000043a <consoleintr+0x16c>

      // echo back to the user.
      consputc(c);
    80000358:	8526                	mv	a0,s1
    8000035a:	00000097          	auipc	ra,0x0
    8000035e:	f32080e7          	jalr	-206(ra) # 8000028c <consputc>

      // store for consumption by consoleread().
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000362:	00011797          	auipc	a5,0x11
    80000366:	4ce78793          	addi	a5,a5,1230 # 80011830 <cons>
    8000036a:	0a07a703          	lw	a4,160(a5)
    8000036e:	0017069b          	addiw	a3,a4,1
    80000372:	0006861b          	sext.w	a2,a3
    80000376:	0ad7a023          	sw	a3,160(a5)
    8000037a:	07f77713          	andi	a4,a4,127
    8000037e:	97ba                	add	a5,a5,a4
    80000380:	00978c23          	sb	s1,24(a5)

      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000384:	47a9                	li	a5,10
    80000386:	0ef48163          	beq	s1,a5,80000468 <consoleintr+0x19a>
    8000038a:	4791                	li	a5,4
    8000038c:	0cf48e63          	beq	s1,a5,80000468 <consoleintr+0x19a>
    80000390:	00011797          	auipc	a5,0x11
    80000394:	4a078793          	addi	a5,a5,1184 # 80011830 <cons>
    80000398:	0987a783          	lw	a5,152(a5)
    8000039c:	0807879b          	addiw	a5,a5,128
    800003a0:	06f61f63          	bne	a2,a5,8000041e <consoleintr+0x150>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800003a4:	863e                	mv	a2,a5
    800003a6:	a0c9                	j	80000468 <consoleintr+0x19a>
    while(cons.e != cons.w &&
    800003a8:	00011717          	auipc	a4,0x11
    800003ac:	48870713          	addi	a4,a4,1160 # 80011830 <cons>
    800003b0:	0a072783          	lw	a5,160(a4)
    800003b4:	09c72703          	lw	a4,156(a4)
    800003b8:	06f70363          	beq	a4,a5,8000041e <consoleintr+0x150>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003bc:	37fd                	addiw	a5,a5,-1
    800003be:	0007871b          	sext.w	a4,a5
    800003c2:	07f7f793          	andi	a5,a5,127
    800003c6:	00011697          	auipc	a3,0x11
    800003ca:	46a68693          	addi	a3,a3,1130 # 80011830 <cons>
    800003ce:	97b6                	add	a5,a5,a3
    while(cons.e != cons.w &&
    800003d0:	0187c683          	lbu	a3,24(a5)
    800003d4:	47a9                	li	a5,10
      cons.e--;
    800003d6:	00011497          	auipc	s1,0x11
    800003da:	45a48493          	addi	s1,s1,1114 # 80011830 <cons>
    while(cons.e != cons.w &&
    800003de:	4929                	li	s2,10
    800003e0:	02f68f63          	beq	a3,a5,8000041e <consoleintr+0x150>
      cons.e--;
    800003e4:	0ae4a023          	sw	a4,160(s1)
      consputc(BACKSPACE);
    800003e8:	10000513          	li	a0,256
    800003ec:	00000097          	auipc	ra,0x0
    800003f0:	ea0080e7          	jalr	-352(ra) # 8000028c <consputc>
    while(cons.e != cons.w &&
    800003f4:	0a04a783          	lw	a5,160(s1)
    800003f8:	09c4a703          	lw	a4,156(s1)
    800003fc:	02f70163          	beq	a4,a5,8000041e <consoleintr+0x150>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000400:	37fd                	addiw	a5,a5,-1
    80000402:	0007871b          	sext.w	a4,a5
    80000406:	07f7f793          	andi	a5,a5,127
    8000040a:	97a6                	add	a5,a5,s1
    while(cons.e != cons.w &&
    8000040c:	0187c783          	lbu	a5,24(a5)
    80000410:	fd279ae3          	bne	a5,s2,800003e4 <consoleintr+0x116>
    80000414:	a029                	j	8000041e <consoleintr+0x150>
    procdump();
    80000416:	00002097          	auipc	ra,0x2
    8000041a:	17e080e7          	jalr	382(ra) # 80002594 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000041e:	00011517          	auipc	a0,0x11
    80000422:	41250513          	addi	a0,a0,1042 # 80011830 <cons>
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	8f0080e7          	jalr	-1808(ra) # 80000d16 <release>
}
    8000042e:	60e2                	ld	ra,24(sp)
    80000430:	6442                	ld	s0,16(sp)
    80000432:	64a2                	ld	s1,8(sp)
    80000434:	6902                	ld	s2,0(sp)
    80000436:	6105                	addi	sp,sp,32
    80000438:	8082                	ret
      consputc(c);
    8000043a:	4529                	li	a0,10
    8000043c:	00000097          	auipc	ra,0x0
    80000440:	e50080e7          	jalr	-432(ra) # 8000028c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000444:	00011797          	auipc	a5,0x11
    80000448:	3ec78793          	addi	a5,a5,1004 # 80011830 <cons>
    8000044c:	0a07a703          	lw	a4,160(a5)
    80000450:	0017069b          	addiw	a3,a4,1
    80000454:	0006861b          	sext.w	a2,a3
    80000458:	0ad7a023          	sw	a3,160(a5)
    8000045c:	07f77713          	andi	a4,a4,127
    80000460:	97ba                	add	a5,a5,a4
    80000462:	4729                	li	a4,10
    80000464:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000468:	00011797          	auipc	a5,0x11
    8000046c:	46c7a223          	sw	a2,1124(a5) # 800118cc <cons+0x9c>
        wakeup(&cons.r);
    80000470:	00011517          	auipc	a0,0x11
    80000474:	45850513          	addi	a0,a0,1112 # 800118c8 <cons+0x98>
    80000478:	00002097          	auipc	ra,0x2
    8000047c:	f94080e7          	jalr	-108(ra) # 8000240c <wakeup>
    80000480:	bf79                	j	8000041e <consoleintr+0x150>

0000000080000482 <consoleinit>:

void
consoleinit(void)
{
    80000482:	1141                	addi	sp,sp,-16
    80000484:	e406                	sd	ra,8(sp)
    80000486:	e022                	sd	s0,0(sp)
    80000488:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000048a:	00008597          	auipc	a1,0x8
    8000048e:	b8658593          	addi	a1,a1,-1146 # 80008010 <etext+0x10>
    80000492:	00011517          	auipc	a0,0x11
    80000496:	39e50513          	addi	a0,a0,926 # 80011830 <cons>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	738080e7          	jalr	1848(ra) # 80000bd2 <initlock>

  uartinit();
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	334080e7          	jalr	820(ra) # 800007d6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800004aa:	00021797          	auipc	a5,0x21
    800004ae:	50678793          	addi	a5,a5,1286 # 800219b0 <devsw>
    800004b2:	00000717          	auipc	a4,0x0
    800004b6:	cbe70713          	addi	a4,a4,-834 # 80000170 <consoleread>
    800004ba:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004bc:	00000717          	auipc	a4,0x0
    800004c0:	c3270713          	addi	a4,a4,-974 # 800000ee <consolewrite>
    800004c4:	ef98                	sd	a4,24(a5)
}
    800004c6:	60a2                	ld	ra,8(sp)
    800004c8:	6402                	ld	s0,0(sp)
    800004ca:	0141                	addi	sp,sp,16
    800004cc:	8082                	ret

00000000800004ce <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004ce:	7179                	addi	sp,sp,-48
    800004d0:	f406                	sd	ra,40(sp)
    800004d2:	f022                	sd	s0,32(sp)
    800004d4:	ec26                	sd	s1,24(sp)
    800004d6:	e84a                	sd	s2,16(sp)
    800004d8:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004da:	c219                	beqz	a2,800004e0 <printint+0x12>
    800004dc:	00054d63          	bltz	a0,800004f6 <printint+0x28>
    x = -xx;
  else
    x = xx;
    800004e0:	2501                	sext.w	a0,a0
    800004e2:	4881                	li	a7,0
    800004e4:	fd040713          	addi	a4,s0,-48

  i = 0;
    800004e8:	4601                	li	a2,0
  do {
    buf[i++] = digits[x % base];
    800004ea:	2581                	sext.w	a1,a1
    800004ec:	00008817          	auipc	a6,0x8
    800004f0:	b2c80813          	addi	a6,a6,-1236 # 80008018 <digits>
    800004f4:	a801                	j	80000504 <printint+0x36>
    x = -xx;
    800004f6:	40a0053b          	negw	a0,a0
    800004fa:	2501                	sext.w	a0,a0
  if(sign && (sign = xx < 0))
    800004fc:	4885                	li	a7,1
    x = -xx;
    800004fe:	b7dd                	j	800004e4 <printint+0x16>
  } while((x /= base) != 0);
    80000500:	853e                	mv	a0,a5
    buf[i++] = digits[x % base];
    80000502:	8636                	mv	a2,a3
    80000504:	0016069b          	addiw	a3,a2,1
    80000508:	02b577bb          	remuw	a5,a0,a1
    8000050c:	1782                	slli	a5,a5,0x20
    8000050e:	9381                	srli	a5,a5,0x20
    80000510:	97c2                	add	a5,a5,a6
    80000512:	0007c783          	lbu	a5,0(a5)
    80000516:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    8000051a:	0705                	addi	a4,a4,1
    8000051c:	02b557bb          	divuw	a5,a0,a1
    80000520:	feb570e3          	bleu	a1,a0,80000500 <printint+0x32>

  if(sign)
    80000524:	00088b63          	beqz	a7,8000053a <printint+0x6c>
    buf[i++] = '-';
    80000528:	fe040793          	addi	a5,s0,-32
    8000052c:	96be                	add	a3,a3,a5
    8000052e:	02d00793          	li	a5,45
    80000532:	fef68823          	sb	a5,-16(a3)
    80000536:	0026069b          	addiw	a3,a2,2

  while(--i >= 0)
    8000053a:	02d05763          	blez	a3,80000568 <printint+0x9a>
    8000053e:	fd040793          	addi	a5,s0,-48
    80000542:	00d784b3          	add	s1,a5,a3
    80000546:	fff78913          	addi	s2,a5,-1
    8000054a:	9936                	add	s2,s2,a3
    8000054c:	36fd                	addiw	a3,a3,-1
    8000054e:	1682                	slli	a3,a3,0x20
    80000550:	9281                	srli	a3,a3,0x20
    80000552:	40d90933          	sub	s2,s2,a3
    consputc(buf[i]);
    80000556:	fff4c503          	lbu	a0,-1(s1)
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	d32080e7          	jalr	-718(ra) # 8000028c <consputc>
  while(--i >= 0)
    80000562:	14fd                	addi	s1,s1,-1
    80000564:	ff2499e3          	bne	s1,s2,80000556 <printint+0x88>
}
    80000568:	70a2                	ld	ra,40(sp)
    8000056a:	7402                	ld	s0,32(sp)
    8000056c:	64e2                	ld	s1,24(sp)
    8000056e:	6942                	ld	s2,16(sp)
    80000570:	6145                	addi	sp,sp,48
    80000572:	8082                	ret

0000000080000574 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000574:	1101                	addi	sp,sp,-32
    80000576:	ec06                	sd	ra,24(sp)
    80000578:	e822                	sd	s0,16(sp)
    8000057a:	e426                	sd	s1,8(sp)
    8000057c:	1000                	addi	s0,sp,32
    8000057e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000580:	00011797          	auipc	a5,0x11
    80000584:	3607a823          	sw	zero,880(a5) # 800118f0 <pr+0x18>
  printf("panic: ");
    80000588:	00008517          	auipc	a0,0x8
    8000058c:	aa850513          	addi	a0,a0,-1368 # 80008030 <digits+0x18>
    80000590:	00000097          	auipc	ra,0x0
    80000594:	02e080e7          	jalr	46(ra) # 800005be <printf>
  printf(s);
    80000598:	8526                	mv	a0,s1
    8000059a:	00000097          	auipc	ra,0x0
    8000059e:	024080e7          	jalr	36(ra) # 800005be <printf>
  printf("\n");
    800005a2:	00008517          	auipc	a0,0x8
    800005a6:	b2650513          	addi	a0,a0,-1242 # 800080c8 <digits+0xb0>
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	014080e7          	jalr	20(ra) # 800005be <printf>
  panicked = 1; // freeze uart output from other CPUs
    800005b2:	4785                	li	a5,1
    800005b4:	00009717          	auipc	a4,0x9
    800005b8:	a4f72623          	sw	a5,-1460(a4) # 80009000 <panicked>
  for(;;)
    800005bc:	a001                	j	800005bc <panic+0x48>

00000000800005be <printf>:
{
    800005be:	7131                	addi	sp,sp,-192
    800005c0:	fc86                	sd	ra,120(sp)
    800005c2:	f8a2                	sd	s0,112(sp)
    800005c4:	f4a6                	sd	s1,104(sp)
    800005c6:	f0ca                	sd	s2,96(sp)
    800005c8:	ecce                	sd	s3,88(sp)
    800005ca:	e8d2                	sd	s4,80(sp)
    800005cc:	e4d6                	sd	s5,72(sp)
    800005ce:	e0da                	sd	s6,64(sp)
    800005d0:	fc5e                	sd	s7,56(sp)
    800005d2:	f862                	sd	s8,48(sp)
    800005d4:	f466                	sd	s9,40(sp)
    800005d6:	f06a                	sd	s10,32(sp)
    800005d8:	ec6e                	sd	s11,24(sp)
    800005da:	0100                	addi	s0,sp,128
    800005dc:	8aaa                	mv	s5,a0
    800005de:	e40c                	sd	a1,8(s0)
    800005e0:	e810                	sd	a2,16(s0)
    800005e2:	ec14                	sd	a3,24(s0)
    800005e4:	f018                	sd	a4,32(s0)
    800005e6:	f41c                	sd	a5,40(s0)
    800005e8:	03043823          	sd	a6,48(s0)
    800005ec:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005f0:	00011797          	auipc	a5,0x11
    800005f4:	2e878793          	addi	a5,a5,744 # 800118d8 <pr>
    800005f8:	0187ad83          	lw	s11,24(a5)
  if(locking)
    800005fc:	020d9b63          	bnez	s11,80000632 <printf+0x74>
  if (fmt == 0)
    80000600:	020a8f63          	beqz	s5,8000063e <printf+0x80>
  va_start(ap, fmt);
    80000604:	00840793          	addi	a5,s0,8
    80000608:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000060c:	000ac503          	lbu	a0,0(s5)
    80000610:	16050063          	beqz	a0,80000770 <printf+0x1b2>
    80000614:	4481                	li	s1,0
    if(c != '%'){
    80000616:	02500a13          	li	s4,37
    switch(c){
    8000061a:	07000b13          	li	s6,112
  consputc('x');
    8000061e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000620:	00008b97          	auipc	s7,0x8
    80000624:	9f8b8b93          	addi	s7,s7,-1544 # 80008018 <digits>
    switch(c){
    80000628:	07300c93          	li	s9,115
    8000062c:	06400c13          	li	s8,100
    80000630:	a815                	j	80000664 <printf+0xa6>
    acquire(&pr.lock);
    80000632:	853e                	mv	a0,a5
    80000634:	00000097          	auipc	ra,0x0
    80000638:	62e080e7          	jalr	1582(ra) # 80000c62 <acquire>
    8000063c:	b7d1                	j	80000600 <printf+0x42>
    panic("null fmt");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	a0250513          	addi	a0,a0,-1534 # 80008040 <digits+0x28>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f2e080e7          	jalr	-210(ra) # 80000574 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c3e080e7          	jalr	-962(ra) # 8000028c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	2485                	addiw	s1,s1,1
    80000658:	009a87b3          	add	a5,s5,s1
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050863          	beqz	a0,80000770 <printf+0x1b2>
    if(c != '%'){
    80000664:	ff4515e3          	bne	a0,s4,8000064e <printf+0x90>
    c = fmt[++i] & 0xff;
    80000668:	2485                	addiw	s1,s1,1
    8000066a:	009a87b3          	add	a5,s5,s1
    8000066e:	0007c783          	lbu	a5,0(a5)
    80000672:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000676:	0e090d63          	beqz	s2,80000770 <printf+0x1b2>
    switch(c){
    8000067a:	05678a63          	beq	a5,s6,800006ce <printf+0x110>
    8000067e:	02fb7663          	bleu	a5,s6,800006aa <printf+0xec>
    80000682:	09978963          	beq	a5,s9,80000714 <printf+0x156>
    80000686:	07800713          	li	a4,120
    8000068a:	0ce79863          	bne	a5,a4,8000075a <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85ea                	mv	a1,s10
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e2e080e7          	jalr	-466(ra) # 800004ce <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0x98>
    switch(c){
    800006aa:	0b478263          	beq	a5,s4,8000074e <printf+0x190>
    800006ae:	0b879663          	bne	a5,s8,8000075a <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4605                	li	a2,1
    800006c0:	45a9                	li	a1,10
    800006c2:	4388                	lw	a0,0(a5)
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	e0a080e7          	jalr	-502(ra) # 800004ce <printint>
      break;
    800006cc:	b769                	j	80000656 <printf+0x98>
      printptr(va_arg(ap, uint64));
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006de:	03000513          	li	a0,48
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	baa080e7          	jalr	-1110(ra) # 8000028c <consputc>
  consputc('x');
    800006ea:	07800513          	li	a0,120
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	b9e080e7          	jalr	-1122(ra) # 8000028c <consputc>
    800006f6:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c9d793          	srli	a5,s3,0x3c
    800006fc:	97de                	add	a5,a5,s7
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b8a080e7          	jalr	-1142(ra) # 8000028c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0992                	slli	s3,s3,0x4
    8000070c:	397d                	addiw	s2,s2,-1
    8000070e:	fe0915e3          	bnez	s2,800006f8 <printf+0x13a>
    80000712:	b791                	j	80000656 <printf+0x98>
      if((s = va_arg(ap, char*)) == 0)
    80000714:	f8843783          	ld	a5,-120(s0)
    80000718:	00878713          	addi	a4,a5,8
    8000071c:	f8e43423          	sd	a4,-120(s0)
    80000720:	0007b903          	ld	s2,0(a5)
    80000724:	00090e63          	beqz	s2,80000740 <printf+0x182>
      for(; *s; s++)
    80000728:	00094503          	lbu	a0,0(s2)
    8000072c:	d50d                	beqz	a0,80000656 <printf+0x98>
        consputc(*s);
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	b5e080e7          	jalr	-1186(ra) # 8000028c <consputc>
      for(; *s; s++)
    80000736:	0905                	addi	s2,s2,1
    80000738:	00094503          	lbu	a0,0(s2)
    8000073c:	f96d                	bnez	a0,8000072e <printf+0x170>
    8000073e:	bf21                	j	80000656 <printf+0x98>
        s = "(null)";
    80000740:	00008917          	auipc	s2,0x8
    80000744:	8f890913          	addi	s2,s2,-1800 # 80008038 <digits+0x20>
      for(; *s; s++)
    80000748:	02800513          	li	a0,40
    8000074c:	b7cd                	j	8000072e <printf+0x170>
      consputc('%');
    8000074e:	8552                	mv	a0,s4
    80000750:	00000097          	auipc	ra,0x0
    80000754:	b3c080e7          	jalr	-1220(ra) # 8000028c <consputc>
      break;
    80000758:	bdfd                	j	80000656 <printf+0x98>
      consputc('%');
    8000075a:	8552                	mv	a0,s4
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	b30080e7          	jalr	-1232(ra) # 8000028c <consputc>
      consputc(c);
    80000764:	854a                	mv	a0,s2
    80000766:	00000097          	auipc	ra,0x0
    8000076a:	b26080e7          	jalr	-1242(ra) # 8000028c <consputc>
      break;
    8000076e:	b5e5                	j	80000656 <printf+0x98>
  if(locking)
    80000770:	020d9163          	bnez	s11,80000792 <printf+0x1d4>
}
    80000774:	70e6                	ld	ra,120(sp)
    80000776:	7446                	ld	s0,112(sp)
    80000778:	74a6                	ld	s1,104(sp)
    8000077a:	7906                	ld	s2,96(sp)
    8000077c:	69e6                	ld	s3,88(sp)
    8000077e:	6a46                	ld	s4,80(sp)
    80000780:	6aa6                	ld	s5,72(sp)
    80000782:	6b06                	ld	s6,64(sp)
    80000784:	7be2                	ld	s7,56(sp)
    80000786:	7c42                	ld	s8,48(sp)
    80000788:	7ca2                	ld	s9,40(sp)
    8000078a:	7d02                	ld	s10,32(sp)
    8000078c:	6de2                	ld	s11,24(sp)
    8000078e:	6129                	addi	sp,sp,192
    80000790:	8082                	ret
    release(&pr.lock);
    80000792:	00011517          	auipc	a0,0x11
    80000796:	14650513          	addi	a0,a0,326 # 800118d8 <pr>
    8000079a:	00000097          	auipc	ra,0x0
    8000079e:	57c080e7          	jalr	1404(ra) # 80000d16 <release>
}
    800007a2:	bfc9                	j	80000774 <printf+0x1b6>

00000000800007a4 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007a4:	1101                	addi	sp,sp,-32
    800007a6:	ec06                	sd	ra,24(sp)
    800007a8:	e822                	sd	s0,16(sp)
    800007aa:	e426                	sd	s1,8(sp)
    800007ac:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007ae:	00011497          	auipc	s1,0x11
    800007b2:	12a48493          	addi	s1,s1,298 # 800118d8 <pr>
    800007b6:	00008597          	auipc	a1,0x8
    800007ba:	89a58593          	addi	a1,a1,-1894 # 80008050 <digits+0x38>
    800007be:	8526                	mv	a0,s1
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	412080e7          	jalr	1042(ra) # 80000bd2 <initlock>
  pr.locking = 1;
    800007c8:	4785                	li	a5,1
    800007ca:	cc9c                	sw	a5,24(s1)
}
    800007cc:	60e2                	ld	ra,24(sp)
    800007ce:	6442                	ld	s0,16(sp)
    800007d0:	64a2                	ld	s1,8(sp)
    800007d2:	6105                	addi	sp,sp,32
    800007d4:	8082                	ret

00000000800007d6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007d6:	1141                	addi	sp,sp,-16
    800007d8:	e406                	sd	ra,8(sp)
    800007da:	e022                	sd	s0,0(sp)
    800007dc:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007de:	100007b7          	lui	a5,0x10000
    800007e2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007e6:	f8000713          	li	a4,-128
    800007ea:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007ee:	470d                	li	a4,3
    800007f0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007f4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007f8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007fc:	469d                	li	a3,7
    800007fe:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000802:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000806:	00008597          	auipc	a1,0x8
    8000080a:	85258593          	addi	a1,a1,-1966 # 80008058 <digits+0x40>
    8000080e:	00011517          	auipc	a0,0x11
    80000812:	0ea50513          	addi	a0,a0,234 # 800118f8 <uart_tx_lock>
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	3bc080e7          	jalr	956(ra) # 80000bd2 <initlock>
}
    8000081e:	60a2                	ld	ra,8(sp)
    80000820:	6402                	ld	s0,0(sp)
    80000822:	0141                	addi	sp,sp,16
    80000824:	8082                	ret

0000000080000826 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000826:	1101                	addi	sp,sp,-32
    80000828:	ec06                	sd	ra,24(sp)
    8000082a:	e822                	sd	s0,16(sp)
    8000082c:	e426                	sd	s1,8(sp)
    8000082e:	1000                	addi	s0,sp,32
    80000830:	84aa                	mv	s1,a0
  push_off();
    80000832:	00000097          	auipc	ra,0x0
    80000836:	3e4080e7          	jalr	996(ra) # 80000c16 <push_off>

  if(panicked){
    8000083a:	00008797          	auipc	a5,0x8
    8000083e:	7c678793          	addi	a5,a5,1990 # 80009000 <panicked>
    80000842:	439c                	lw	a5,0(a5)
    80000844:	2781                	sext.w	a5,a5
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000846:	10000737          	lui	a4,0x10000
  if(panicked){
    8000084a:	c391                	beqz	a5,8000084e <uartputc_sync+0x28>
    for(;;)
    8000084c:	a001                	j	8000084c <uartputc_sync+0x26>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000084e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000852:	0ff7f793          	andi	a5,a5,255
    80000856:	0207f793          	andi	a5,a5,32
    8000085a:	dbf5                	beqz	a5,8000084e <uartputc_sync+0x28>
    ;
  WriteReg(THR, c);
    8000085c:	0ff4f793          	andi	a5,s1,255
    80000860:	10000737          	lui	a4,0x10000
    80000864:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	44e080e7          	jalr	1102(ra) # 80000cb6 <pop_off>
}
    80000870:	60e2                	ld	ra,24(sp)
    80000872:	6442                	ld	s0,16(sp)
    80000874:	64a2                	ld	s1,8(sp)
    80000876:	6105                	addi	sp,sp,32
    80000878:	8082                	ret

000000008000087a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000087a:	00008797          	auipc	a5,0x8
    8000087e:	78a78793          	addi	a5,a5,1930 # 80009004 <uart_tx_r>
    80000882:	439c                	lw	a5,0(a5)
    80000884:	00008717          	auipc	a4,0x8
    80000888:	78470713          	addi	a4,a4,1924 # 80009008 <uart_tx_w>
    8000088c:	4318                	lw	a4,0(a4)
    8000088e:	08f70b63          	beq	a4,a5,80000924 <uartstart+0xaa>
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000892:	10000737          	lui	a4,0x10000
    80000896:	00574703          	lbu	a4,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000089a:	0ff77713          	andi	a4,a4,255
    8000089e:	02077713          	andi	a4,a4,32
    800008a2:	c349                	beqz	a4,80000924 <uartstart+0xaa>
{
    800008a4:	7139                	addi	sp,sp,-64
    800008a6:	fc06                	sd	ra,56(sp)
    800008a8:	f822                	sd	s0,48(sp)
    800008aa:	f426                	sd	s1,40(sp)
    800008ac:	f04a                	sd	s2,32(sp)
    800008ae:	ec4e                	sd	s3,24(sp)
    800008b0:	e852                	sd	s4,16(sp)
    800008b2:	e456                	sd	s5,8(sp)
    800008b4:	0080                	addi	s0,sp,64
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    800008b6:	00011a17          	auipc	s4,0x11
    800008ba:	042a0a13          	addi	s4,s4,66 # 800118f8 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    800008be:	00008497          	auipc	s1,0x8
    800008c2:	74648493          	addi	s1,s1,1862 # 80009004 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008c6:	10000937          	lui	s2,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ca:	00008997          	auipc	s3,0x8
    800008ce:	73e98993          	addi	s3,s3,1854 # 80009008 <uart_tx_w>
    int c = uart_tx_buf[uart_tx_r];
    800008d2:	00fa0733          	add	a4,s4,a5
    800008d6:	01874a83          	lbu	s5,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    800008da:	2785                	addiw	a5,a5,1
    800008dc:	41f7d71b          	sraiw	a4,a5,0x1f
    800008e0:	01b7571b          	srliw	a4,a4,0x1b
    800008e4:	9fb9                	addw	a5,a5,a4
    800008e6:	8bfd                	andi	a5,a5,31
    800008e8:	9f99                	subw	a5,a5,a4
    800008ea:	c09c                	sw	a5,0(s1)
    wakeup(&uart_tx_r);
    800008ec:	8526                	mv	a0,s1
    800008ee:	00002097          	auipc	ra,0x2
    800008f2:	b1e080e7          	jalr	-1250(ra) # 8000240c <wakeup>
    WriteReg(THR, c);
    800008f6:	01590023          	sb	s5,0(s2) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fa:	409c                	lw	a5,0(s1)
    800008fc:	0009a703          	lw	a4,0(s3)
    80000900:	00f70963          	beq	a4,a5,80000912 <uartstart+0x98>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000904:	00594703          	lbu	a4,5(s2)
    80000908:	0ff77713          	andi	a4,a4,255
    8000090c:	02077713          	andi	a4,a4,32
    80000910:	f369                	bnez	a4,800008d2 <uartstart+0x58>
  }
}
    80000912:	70e2                	ld	ra,56(sp)
    80000914:	7442                	ld	s0,48(sp)
    80000916:	74a2                	ld	s1,40(sp)
    80000918:	7902                	ld	s2,32(sp)
    8000091a:	69e2                	ld	s3,24(sp)
    8000091c:	6a42                	ld	s4,16(sp)
    8000091e:	6aa2                	ld	s5,8(sp)
    80000920:	6121                	addi	sp,sp,64
    80000922:	8082                	ret
    80000924:	8082                	ret

0000000080000926 <uartputc>:
{
    80000926:	7179                	addi	sp,sp,-48
    80000928:	f406                	sd	ra,40(sp)
    8000092a:	f022                	sd	s0,32(sp)
    8000092c:	ec26                	sd	s1,24(sp)
    8000092e:	e84a                	sd	s2,16(sp)
    80000930:	e44e                	sd	s3,8(sp)
    80000932:	e052                	sd	s4,0(sp)
    80000934:	1800                	addi	s0,sp,48
    80000936:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80000938:	00011517          	auipc	a0,0x11
    8000093c:	fc050513          	addi	a0,a0,-64 # 800118f8 <uart_tx_lock>
    80000940:	00000097          	auipc	ra,0x0
    80000944:	322080e7          	jalr	802(ra) # 80000c62 <acquire>
  if(panicked){
    80000948:	00008797          	auipc	a5,0x8
    8000094c:	6b878793          	addi	a5,a5,1720 # 80009000 <panicked>
    80000950:	439c                	lw	a5,0(a5)
    80000952:	2781                	sext.w	a5,a5
    80000954:	c391                	beqz	a5,80000958 <uartputc+0x32>
    for(;;)
    80000956:	a001                	j	80000956 <uartputc+0x30>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000958:	00008797          	auipc	a5,0x8
    8000095c:	6b078793          	addi	a5,a5,1712 # 80009008 <uart_tx_w>
    80000960:	4398                	lw	a4,0(a5)
    80000962:	0017079b          	addiw	a5,a4,1
    80000966:	41f7d69b          	sraiw	a3,a5,0x1f
    8000096a:	01b6d69b          	srliw	a3,a3,0x1b
    8000096e:	9fb5                	addw	a5,a5,a3
    80000970:	8bfd                	andi	a5,a5,31
    80000972:	9f95                	subw	a5,a5,a3
    80000974:	00008697          	auipc	a3,0x8
    80000978:	69068693          	addi	a3,a3,1680 # 80009004 <uart_tx_r>
    8000097c:	4294                	lw	a3,0(a3)
    8000097e:	04f69263          	bne	a3,a5,800009c2 <uartputc+0x9c>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000982:	00011a17          	auipc	s4,0x11
    80000986:	f76a0a13          	addi	s4,s4,-138 # 800118f8 <uart_tx_lock>
    8000098a:	00008497          	auipc	s1,0x8
    8000098e:	67a48493          	addi	s1,s1,1658 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000992:	00008917          	auipc	s2,0x8
    80000996:	67690913          	addi	s2,s2,1654 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000099a:	85d2                	mv	a1,s4
    8000099c:	8526                	mv	a0,s1
    8000099e:	00002097          	auipc	ra,0x2
    800009a2:	8e8080e7          	jalr	-1816(ra) # 80002286 <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    800009a6:	00092703          	lw	a4,0(s2)
    800009aa:	0017079b          	addiw	a5,a4,1
    800009ae:	41f7d69b          	sraiw	a3,a5,0x1f
    800009b2:	01b6d69b          	srliw	a3,a3,0x1b
    800009b6:	9fb5                	addw	a5,a5,a3
    800009b8:	8bfd                	andi	a5,a5,31
    800009ba:	9f95                	subw	a5,a5,a3
    800009bc:	4094                	lw	a3,0(s1)
    800009be:	fcf68ee3          	beq	a3,a5,8000099a <uartputc+0x74>
      uart_tx_buf[uart_tx_w] = c;
    800009c2:	00011497          	auipc	s1,0x11
    800009c6:	f3648493          	addi	s1,s1,-202 # 800118f8 <uart_tx_lock>
    800009ca:	9726                	add	a4,a4,s1
    800009cc:	01370c23          	sb	s3,24(a4)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    800009d0:	00008717          	auipc	a4,0x8
    800009d4:	62f72c23          	sw	a5,1592(a4) # 80009008 <uart_tx_w>
      uartstart();
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	ea2080e7          	jalr	-350(ra) # 8000087a <uartstart>
      release(&uart_tx_lock);
    800009e0:	8526                	mv	a0,s1
    800009e2:	00000097          	auipc	ra,0x0
    800009e6:	334080e7          	jalr	820(ra) # 80000d16 <release>
}
    800009ea:	70a2                	ld	ra,40(sp)
    800009ec:	7402                	ld	s0,32(sp)
    800009ee:	64e2                	ld	s1,24(sp)
    800009f0:	6942                	ld	s2,16(sp)
    800009f2:	69a2                	ld	s3,8(sp)
    800009f4:	6a02                	ld	s4,0(sp)
    800009f6:	6145                	addi	sp,sp,48
    800009f8:	8082                	ret

00000000800009fa <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009fa:	1141                	addi	sp,sp,-16
    800009fc:	e422                	sd	s0,8(sp)
    800009fe:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000a00:	100007b7          	lui	a5,0x10000
    80000a04:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a08:	8b85                	andi	a5,a5,1
    80000a0a:	cb91                	beqz	a5,80000a1e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000a0c:	100007b7          	lui	a5,0x10000
    80000a10:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000a14:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80000a18:	6422                	ld	s0,8(sp)
    80000a1a:	0141                	addi	sp,sp,16
    80000a1c:	8082                	ret
    return -1;
    80000a1e:	557d                	li	a0,-1
    80000a20:	bfe5                	j	80000a18 <uartgetc+0x1e>

0000000080000a22 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000a22:	1101                	addi	sp,sp,-32
    80000a24:	ec06                	sd	ra,24(sp)
    80000a26:	e822                	sd	s0,16(sp)
    80000a28:	e426                	sd	s1,8(sp)
    80000a2a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a2c:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	fcc080e7          	jalr	-52(ra) # 800009fa <uartgetc>
    if(c == -1)
    80000a36:	00950763          	beq	a0,s1,80000a44 <uartintr+0x22>
      break;
    consoleintr(c);
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	894080e7          	jalr	-1900(ra) # 800002ce <consoleintr>
  while(1){
    80000a42:	b7f5                	j	80000a2e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a44:	00011497          	auipc	s1,0x11
    80000a48:	eb448493          	addi	s1,s1,-332 # 800118f8 <uart_tx_lock>
    80000a4c:	8526                	mv	a0,s1
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	214080e7          	jalr	532(ra) # 80000c62 <acquire>
  uartstart();
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	e24080e7          	jalr	-476(ra) # 8000087a <uartstart>
  release(&uart_tx_lock);
    80000a5e:	8526                	mv	a0,s1
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	2b6080e7          	jalr	694(ra) # 80000d16 <release>
}
    80000a68:	60e2                	ld	ra,24(sp)
    80000a6a:	6442                	ld	s0,16(sp)
    80000a6c:	64a2                	ld	s1,8(sp)
    80000a6e:	6105                	addi	sp,sp,32
    80000a70:	8082                	ret

0000000080000a72 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a72:	1101                	addi	sp,sp,-32
    80000a74:	ec06                	sd	ra,24(sp)
    80000a76:	e822                	sd	s0,16(sp)
    80000a78:	e426                	sd	s1,8(sp)
    80000a7a:	e04a                	sd	s2,0(sp)
    80000a7c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a7e:	6785                	lui	a5,0x1
    80000a80:	17fd                	addi	a5,a5,-1
    80000a82:	8fe9                	and	a5,a5,a0
    80000a84:	ebb9                	bnez	a5,80000ada <kfree+0x68>
    80000a86:	84aa                	mv	s1,a0
    80000a88:	00025797          	auipc	a5,0x25
    80000a8c:	57878793          	addi	a5,a5,1400 # 80026000 <end>
    80000a90:	04f56563          	bltu	a0,a5,80000ada <kfree+0x68>
    80000a94:	47c5                	li	a5,17
    80000a96:	07ee                	slli	a5,a5,0x1b
    80000a98:	04f57163          	bleu	a5,a0,80000ada <kfree+0x68>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a9c:	6605                	lui	a2,0x1
    80000a9e:	4585                	li	a1,1
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	2be080e7          	jalr	702(ra) # 80000d5e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000aa8:	00011917          	auipc	s2,0x11
    80000aac:	e8890913          	addi	s2,s2,-376 # 80011930 <kmem>
    80000ab0:	854a                	mv	a0,s2
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	1b0080e7          	jalr	432(ra) # 80000c62 <acquire>
  r->next = kmem.freelist;
    80000aba:	01893783          	ld	a5,24(s2)
    80000abe:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000ac0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000ac4:	854a                	mv	a0,s2
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	250080e7          	jalr	592(ra) # 80000d16 <release>
}
    80000ace:	60e2                	ld	ra,24(sp)
    80000ad0:	6442                	ld	s0,16(sp)
    80000ad2:	64a2                	ld	s1,8(sp)
    80000ad4:	6902                	ld	s2,0(sp)
    80000ad6:	6105                	addi	sp,sp,32
    80000ad8:	8082                	ret
    panic("kfree");
    80000ada:	00007517          	auipc	a0,0x7
    80000ade:	58650513          	addi	a0,a0,1414 # 80008060 <digits+0x48>
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	a92080e7          	jalr	-1390(ra) # 80000574 <panic>

0000000080000aea <freerange>:
{
    80000aea:	7179                	addi	sp,sp,-48
    80000aec:	f406                	sd	ra,40(sp)
    80000aee:	f022                	sd	s0,32(sp)
    80000af0:	ec26                	sd	s1,24(sp)
    80000af2:	e84a                	sd	s2,16(sp)
    80000af4:	e44e                	sd	s3,8(sp)
    80000af6:	e052                	sd	s4,0(sp)
    80000af8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000afa:	6705                	lui	a4,0x1
    80000afc:	fff70793          	addi	a5,a4,-1 # fff <_entry-0x7ffff001>
    80000b00:	00f504b3          	add	s1,a0,a5
    80000b04:	77fd                	lui	a5,0xfffff
    80000b06:	8cfd                	and	s1,s1,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b08:	94ba                	add	s1,s1,a4
    80000b0a:	0095ee63          	bltu	a1,s1,80000b26 <freerange+0x3c>
    80000b0e:	892e                	mv	s2,a1
    kfree(p);
    80000b10:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b12:	6985                	lui	s3,0x1
    kfree(p);
    80000b14:	01448533          	add	a0,s1,s4
    80000b18:	00000097          	auipc	ra,0x0
    80000b1c:	f5a080e7          	jalr	-166(ra) # 80000a72 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b20:	94ce                	add	s1,s1,s3
    80000b22:	fe9979e3          	bleu	s1,s2,80000b14 <freerange+0x2a>
}
    80000b26:	70a2                	ld	ra,40(sp)
    80000b28:	7402                	ld	s0,32(sp)
    80000b2a:	64e2                	ld	s1,24(sp)
    80000b2c:	6942                	ld	s2,16(sp)
    80000b2e:	69a2                	ld	s3,8(sp)
    80000b30:	6a02                	ld	s4,0(sp)
    80000b32:	6145                	addi	sp,sp,48
    80000b34:	8082                	ret

0000000080000b36 <kinit>:
{
    80000b36:	1141                	addi	sp,sp,-16
    80000b38:	e406                	sd	ra,8(sp)
    80000b3a:	e022                	sd	s0,0(sp)
    80000b3c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b3e:	00007597          	auipc	a1,0x7
    80000b42:	52a58593          	addi	a1,a1,1322 # 80008068 <digits+0x50>
    80000b46:	00011517          	auipc	a0,0x11
    80000b4a:	dea50513          	addi	a0,a0,-534 # 80011930 <kmem>
    80000b4e:	00000097          	auipc	ra,0x0
    80000b52:	084080e7          	jalr	132(ra) # 80000bd2 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b56:	45c5                	li	a1,17
    80000b58:	05ee                	slli	a1,a1,0x1b
    80000b5a:	00025517          	auipc	a0,0x25
    80000b5e:	4a650513          	addi	a0,a0,1190 # 80026000 <end>
    80000b62:	00000097          	auipc	ra,0x0
    80000b66:	f88080e7          	jalr	-120(ra) # 80000aea <freerange>
}
    80000b6a:	60a2                	ld	ra,8(sp)
    80000b6c:	6402                	ld	s0,0(sp)
    80000b6e:	0141                	addi	sp,sp,16
    80000b70:	8082                	ret

0000000080000b72 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b72:	1101                	addi	sp,sp,-32
    80000b74:	ec06                	sd	ra,24(sp)
    80000b76:	e822                	sd	s0,16(sp)
    80000b78:	e426                	sd	s1,8(sp)
    80000b7a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b7c:	00011497          	auipc	s1,0x11
    80000b80:	db448493          	addi	s1,s1,-588 # 80011930 <kmem>
    80000b84:	8526                	mv	a0,s1
    80000b86:	00000097          	auipc	ra,0x0
    80000b8a:	0dc080e7          	jalr	220(ra) # 80000c62 <acquire>
  r = kmem.freelist;
    80000b8e:	6c84                	ld	s1,24(s1)
  if(r)
    80000b90:	c885                	beqz	s1,80000bc0 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b92:	609c                	ld	a5,0(s1)
    80000b94:	00011517          	auipc	a0,0x11
    80000b98:	d9c50513          	addi	a0,a0,-612 # 80011930 <kmem>
    80000b9c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	178080e7          	jalr	376(ra) # 80000d16 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000ba6:	6605                	lui	a2,0x1
    80000ba8:	4595                	li	a1,5
    80000baa:	8526                	mv	a0,s1
    80000bac:	00000097          	auipc	ra,0x0
    80000bb0:	1b2080e7          	jalr	434(ra) # 80000d5e <memset>
  return (void*)r;
}
    80000bb4:	8526                	mv	a0,s1
    80000bb6:	60e2                	ld	ra,24(sp)
    80000bb8:	6442                	ld	s0,16(sp)
    80000bba:	64a2                	ld	s1,8(sp)
    80000bbc:	6105                	addi	sp,sp,32
    80000bbe:	8082                	ret
  release(&kmem.lock);
    80000bc0:	00011517          	auipc	a0,0x11
    80000bc4:	d7050513          	addi	a0,a0,-656 # 80011930 <kmem>
    80000bc8:	00000097          	auipc	ra,0x0
    80000bcc:	14e080e7          	jalr	334(ra) # 80000d16 <release>
  if(r)
    80000bd0:	b7d5                	j	80000bb4 <kalloc+0x42>

0000000080000bd2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000bd2:	1141                	addi	sp,sp,-16
    80000bd4:	e422                	sd	s0,8(sp)
    80000bd6:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bd8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bda:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bde:	00053823          	sd	zero,16(a0)
}
    80000be2:	6422                	ld	s0,8(sp)
    80000be4:	0141                	addi	sp,sp,16
    80000be6:	8082                	ret

0000000080000be8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000be8:	411c                	lw	a5,0(a0)
    80000bea:	e399                	bnez	a5,80000bf0 <holding+0x8>
    80000bec:	4501                	li	a0,0
  return r;
}
    80000bee:	8082                	ret
{
    80000bf0:	1101                	addi	sp,sp,-32
    80000bf2:	ec06                	sd	ra,24(sp)
    80000bf4:	e822                	sd	s0,16(sp)
    80000bf6:	e426                	sd	s1,8(sp)
    80000bf8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bfa:	6904                	ld	s1,16(a0)
    80000bfc:	00001097          	auipc	ra,0x1
    80000c00:	e58080e7          	jalr	-424(ra) # 80001a54 <mycpu>
    80000c04:	40a48533          	sub	a0,s1,a0
    80000c08:	00153513          	seqz	a0,a0
}
    80000c0c:	60e2                	ld	ra,24(sp)
    80000c0e:	6442                	ld	s0,16(sp)
    80000c10:	64a2                	ld	s1,8(sp)
    80000c12:	6105                	addi	sp,sp,32
    80000c14:	8082                	ret

0000000080000c16 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c16:	1101                	addi	sp,sp,-32
    80000c18:	ec06                	sd	ra,24(sp)
    80000c1a:	e822                	sd	s0,16(sp)
    80000c1c:	e426                	sd	s1,8(sp)
    80000c1e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c20:	100024f3          	csrr	s1,sstatus
    80000c24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c28:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c2a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c2e:	00001097          	auipc	ra,0x1
    80000c32:	e26080e7          	jalr	-474(ra) # 80001a54 <mycpu>
    80000c36:	5d3c                	lw	a5,120(a0)
    80000c38:	cf89                	beqz	a5,80000c52 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c3a:	00001097          	auipc	ra,0x1
    80000c3e:	e1a080e7          	jalr	-486(ra) # 80001a54 <mycpu>
    80000c42:	5d3c                	lw	a5,120(a0)
    80000c44:	2785                	addiw	a5,a5,1
    80000c46:	dd3c                	sw	a5,120(a0)
}
    80000c48:	60e2                	ld	ra,24(sp)
    80000c4a:	6442                	ld	s0,16(sp)
    80000c4c:	64a2                	ld	s1,8(sp)
    80000c4e:	6105                	addi	sp,sp,32
    80000c50:	8082                	ret
    mycpu()->intena = old;
    80000c52:	00001097          	auipc	ra,0x1
    80000c56:	e02080e7          	jalr	-510(ra) # 80001a54 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c5a:	8085                	srli	s1,s1,0x1
    80000c5c:	8885                	andi	s1,s1,1
    80000c5e:	dd64                	sw	s1,124(a0)
    80000c60:	bfe9                	j	80000c3a <push_off+0x24>

0000000080000c62 <acquire>:
{
    80000c62:	1101                	addi	sp,sp,-32
    80000c64:	ec06                	sd	ra,24(sp)
    80000c66:	e822                	sd	s0,16(sp)
    80000c68:	e426                	sd	s1,8(sp)
    80000c6a:	1000                	addi	s0,sp,32
    80000c6c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	fa8080e7          	jalr	-88(ra) # 80000c16 <push_off>
  if(holding(lk))
    80000c76:	8526                	mv	a0,s1
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	f70080e7          	jalr	-144(ra) # 80000be8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c80:	4705                	li	a4,1
  if(holding(lk))
    80000c82:	e115                	bnez	a0,80000ca6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c84:	87ba                	mv	a5,a4
    80000c86:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c8a:	2781                	sext.w	a5,a5
    80000c8c:	ffe5                	bnez	a5,80000c84 <acquire+0x22>
  __sync_synchronize();
    80000c8e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c92:	00001097          	auipc	ra,0x1
    80000c96:	dc2080e7          	jalr	-574(ra) # 80001a54 <mycpu>
    80000c9a:	e888                	sd	a0,16(s1)
}
    80000c9c:	60e2                	ld	ra,24(sp)
    80000c9e:	6442                	ld	s0,16(sp)
    80000ca0:	64a2                	ld	s1,8(sp)
    80000ca2:	6105                	addi	sp,sp,32
    80000ca4:	8082                	ret
    panic("acquire");
    80000ca6:	00007517          	auipc	a0,0x7
    80000caa:	3ca50513          	addi	a0,a0,970 # 80008070 <digits+0x58>
    80000cae:	00000097          	auipc	ra,0x0
    80000cb2:	8c6080e7          	jalr	-1850(ra) # 80000574 <panic>

0000000080000cb6 <pop_off>:

void
pop_off(void)
{
    80000cb6:	1141                	addi	sp,sp,-16
    80000cb8:	e406                	sd	ra,8(sp)
    80000cba:	e022                	sd	s0,0(sp)
    80000cbc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000cbe:	00001097          	auipc	ra,0x1
    80000cc2:	d96080e7          	jalr	-618(ra) # 80001a54 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cc6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000cca:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000ccc:	e78d                	bnez	a5,80000cf6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000cce:	5d3c                	lw	a5,120(a0)
    80000cd0:	02f05b63          	blez	a5,80000d06 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000cd4:	37fd                	addiw	a5,a5,-1
    80000cd6:	0007871b          	sext.w	a4,a5
    80000cda:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cdc:	eb09                	bnez	a4,80000cee <pop_off+0x38>
    80000cde:	5d7c                	lw	a5,124(a0)
    80000ce0:	c799                	beqz	a5,80000cee <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ce2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000ce6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cea:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cee:	60a2                	ld	ra,8(sp)
    80000cf0:	6402                	ld	s0,0(sp)
    80000cf2:	0141                	addi	sp,sp,16
    80000cf4:	8082                	ret
    panic("pop_off - interruptible");
    80000cf6:	00007517          	auipc	a0,0x7
    80000cfa:	38250513          	addi	a0,a0,898 # 80008078 <digits+0x60>
    80000cfe:	00000097          	auipc	ra,0x0
    80000d02:	876080e7          	jalr	-1930(ra) # 80000574 <panic>
    panic("pop_off");
    80000d06:	00007517          	auipc	a0,0x7
    80000d0a:	38a50513          	addi	a0,a0,906 # 80008090 <digits+0x78>
    80000d0e:	00000097          	auipc	ra,0x0
    80000d12:	866080e7          	jalr	-1946(ra) # 80000574 <panic>

0000000080000d16 <release>:
{
    80000d16:	1101                	addi	sp,sp,-32
    80000d18:	ec06                	sd	ra,24(sp)
    80000d1a:	e822                	sd	s0,16(sp)
    80000d1c:	e426                	sd	s1,8(sp)
    80000d1e:	1000                	addi	s0,sp,32
    80000d20:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d22:	00000097          	auipc	ra,0x0
    80000d26:	ec6080e7          	jalr	-314(ra) # 80000be8 <holding>
    80000d2a:	c115                	beqz	a0,80000d4e <release+0x38>
  lk->cpu = 0;
    80000d2c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d30:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000d34:	0f50000f          	fence	iorw,ow
    80000d38:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000d3c:	00000097          	auipc	ra,0x0
    80000d40:	f7a080e7          	jalr	-134(ra) # 80000cb6 <pop_off>
}
    80000d44:	60e2                	ld	ra,24(sp)
    80000d46:	6442                	ld	s0,16(sp)
    80000d48:	64a2                	ld	s1,8(sp)
    80000d4a:	6105                	addi	sp,sp,32
    80000d4c:	8082                	ret
    panic("release");
    80000d4e:	00007517          	auipc	a0,0x7
    80000d52:	34a50513          	addi	a0,a0,842 # 80008098 <digits+0x80>
    80000d56:	00000097          	auipc	ra,0x0
    80000d5a:	81e080e7          	jalr	-2018(ra) # 80000574 <panic>

0000000080000d5e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d5e:	1141                	addi	sp,sp,-16
    80000d60:	e422                	sd	s0,8(sp)
    80000d62:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d64:	ce09                	beqz	a2,80000d7e <memset+0x20>
    80000d66:	87aa                	mv	a5,a0
    80000d68:	fff6071b          	addiw	a4,a2,-1
    80000d6c:	1702                	slli	a4,a4,0x20
    80000d6e:	9301                	srli	a4,a4,0x20
    80000d70:	0705                	addi	a4,a4,1
    80000d72:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000d74:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffd9000>
  for(i = 0; i < n; i++){
    80000d78:	0785                	addi	a5,a5,1
    80000d7a:	fee79de3          	bne	a5,a4,80000d74 <memset+0x16>
  }
  return dst;
}
    80000d7e:	6422                	ld	s0,8(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret

0000000080000d84 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d84:	1141                	addi	sp,sp,-16
    80000d86:	e422                	sd	s0,8(sp)
    80000d88:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d8a:	ce15                	beqz	a2,80000dc6 <memcmp+0x42>
    80000d8c:	fff6069b          	addiw	a3,a2,-1
    if(*s1 != *s2)
    80000d90:	00054783          	lbu	a5,0(a0)
    80000d94:	0005c703          	lbu	a4,0(a1)
    80000d98:	02e79063          	bne	a5,a4,80000db8 <memcmp+0x34>
    80000d9c:	1682                	slli	a3,a3,0x20
    80000d9e:	9281                	srli	a3,a3,0x20
    80000da0:	0685                	addi	a3,a3,1
    80000da2:	96aa                	add	a3,a3,a0
      return *s1 - *s2;
    s1++, s2++;
    80000da4:	0505                	addi	a0,a0,1
    80000da6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000da8:	00d50d63          	beq	a0,a3,80000dc2 <memcmp+0x3e>
    if(*s1 != *s2)
    80000dac:	00054783          	lbu	a5,0(a0)
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	fee788e3          	beq	a5,a4,80000da4 <memcmp+0x20>
      return *s1 - *s2;
    80000db8:	40e7853b          	subw	a0,a5,a4
  }

  return 0;
}
    80000dbc:	6422                	ld	s0,8(sp)
    80000dbe:	0141                	addi	sp,sp,16
    80000dc0:	8082                	ret
  return 0;
    80000dc2:	4501                	li	a0,0
    80000dc4:	bfe5                	j	80000dbc <memcmp+0x38>
    80000dc6:	4501                	li	a0,0
    80000dc8:	bfd5                	j	80000dbc <memcmp+0x38>

0000000080000dca <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000dd0:	00a5f963          	bleu	a0,a1,80000de2 <memmove+0x18>
    80000dd4:	02061713          	slli	a4,a2,0x20
    80000dd8:	9301                	srli	a4,a4,0x20
    80000dda:	00e587b3          	add	a5,a1,a4
    80000dde:	02f56563          	bltu	a0,a5,80000e08 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000de2:	fff6069b          	addiw	a3,a2,-1
    80000de6:	ce11                	beqz	a2,80000e02 <memmove+0x38>
    80000de8:	1682                	slli	a3,a3,0x20
    80000dea:	9281                	srli	a3,a3,0x20
    80000dec:	0685                	addi	a3,a3,1
    80000dee:	96ae                	add	a3,a3,a1
    80000df0:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000df2:	0585                	addi	a1,a1,1
    80000df4:	0785                	addi	a5,a5,1
    80000df6:	fff5c703          	lbu	a4,-1(a1)
    80000dfa:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000dfe:	fed59ae3          	bne	a1,a3,80000df2 <memmove+0x28>

  return dst;
}
    80000e02:	6422                	ld	s0,8(sp)
    80000e04:	0141                	addi	sp,sp,16
    80000e06:	8082                	ret
    d += n;
    80000e08:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000e0a:	fff6069b          	addiw	a3,a2,-1
    80000e0e:	da75                	beqz	a2,80000e02 <memmove+0x38>
    80000e10:	02069613          	slli	a2,a3,0x20
    80000e14:	9201                	srli	a2,a2,0x20
    80000e16:	fff64613          	not	a2,a2
    80000e1a:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000e1c:	17fd                	addi	a5,a5,-1
    80000e1e:	177d                	addi	a4,a4,-1
    80000e20:	0007c683          	lbu	a3,0(a5)
    80000e24:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000e28:	fef61ae3          	bne	a2,a5,80000e1c <memmove+0x52>
    80000e2c:	bfd9                	j	80000e02 <memmove+0x38>

0000000080000e2e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e2e:	1141                	addi	sp,sp,-16
    80000e30:	e406                	sd	ra,8(sp)
    80000e32:	e022                	sd	s0,0(sp)
    80000e34:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e36:	00000097          	auipc	ra,0x0
    80000e3a:	f94080e7          	jalr	-108(ra) # 80000dca <memmove>
}
    80000e3e:	60a2                	ld	ra,8(sp)
    80000e40:	6402                	ld	s0,0(sp)
    80000e42:	0141                	addi	sp,sp,16
    80000e44:	8082                	ret

0000000080000e46 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e46:	1141                	addi	sp,sp,-16
    80000e48:	e422                	sd	s0,8(sp)
    80000e4a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e4c:	c229                	beqz	a2,80000e8e <strncmp+0x48>
    80000e4e:	00054783          	lbu	a5,0(a0)
    80000e52:	c795                	beqz	a5,80000e7e <strncmp+0x38>
    80000e54:	0005c703          	lbu	a4,0(a1)
    80000e58:	02f71363          	bne	a4,a5,80000e7e <strncmp+0x38>
    80000e5c:	fff6071b          	addiw	a4,a2,-1
    80000e60:	1702                	slli	a4,a4,0x20
    80000e62:	9301                	srli	a4,a4,0x20
    80000e64:	0705                	addi	a4,a4,1
    80000e66:	972a                	add	a4,a4,a0
    n--, p++, q++;
    80000e68:	0505                	addi	a0,a0,1
    80000e6a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e6c:	02e50363          	beq	a0,a4,80000e92 <strncmp+0x4c>
    80000e70:	00054783          	lbu	a5,0(a0)
    80000e74:	c789                	beqz	a5,80000e7e <strncmp+0x38>
    80000e76:	0005c683          	lbu	a3,0(a1)
    80000e7a:	fef687e3          	beq	a3,a5,80000e68 <strncmp+0x22>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
    80000e7e:	00054503          	lbu	a0,0(a0)
    80000e82:	0005c783          	lbu	a5,0(a1)
    80000e86:	9d1d                	subw	a0,a0,a5
}
    80000e88:	6422                	ld	s0,8(sp)
    80000e8a:	0141                	addi	sp,sp,16
    80000e8c:	8082                	ret
    return 0;
    80000e8e:	4501                	li	a0,0
    80000e90:	bfe5                	j	80000e88 <strncmp+0x42>
    80000e92:	4501                	li	a0,0
    80000e94:	bfd5                	j	80000e88 <strncmp+0x42>

0000000080000e96 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e96:	1141                	addi	sp,sp,-16
    80000e98:	e422                	sd	s0,8(sp)
    80000e9a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e9c:	872a                	mv	a4,a0
    80000e9e:	a011                	j	80000ea2 <strncpy+0xc>
    80000ea0:	8636                	mv	a2,a3
    80000ea2:	fff6069b          	addiw	a3,a2,-1
    80000ea6:	00c05963          	blez	a2,80000eb8 <strncpy+0x22>
    80000eaa:	0705                	addi	a4,a4,1
    80000eac:	0005c783          	lbu	a5,0(a1)
    80000eb0:	fef70fa3          	sb	a5,-1(a4)
    80000eb4:	0585                	addi	a1,a1,1
    80000eb6:	f7ed                	bnez	a5,80000ea0 <strncpy+0xa>
    ;
  while(n-- > 0)
    80000eb8:	00d05c63          	blez	a3,80000ed0 <strncpy+0x3a>
    80000ebc:	86ba                	mv	a3,a4
    *s++ = 0;
    80000ebe:	0685                	addi	a3,a3,1
    80000ec0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000ec4:	fff6c793          	not	a5,a3
    80000ec8:	9fb9                	addw	a5,a5,a4
    80000eca:	9fb1                	addw	a5,a5,a2
    80000ecc:	fef049e3          	bgtz	a5,80000ebe <strncpy+0x28>
  return os;
}
    80000ed0:	6422                	ld	s0,8(sp)
    80000ed2:	0141                	addi	sp,sp,16
    80000ed4:	8082                	ret

0000000080000ed6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ed6:	1141                	addi	sp,sp,-16
    80000ed8:	e422                	sd	s0,8(sp)
    80000eda:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000edc:	02c05363          	blez	a2,80000f02 <safestrcpy+0x2c>
    80000ee0:	fff6069b          	addiw	a3,a2,-1
    80000ee4:	1682                	slli	a3,a3,0x20
    80000ee6:	9281                	srli	a3,a3,0x20
    80000ee8:	96ae                	add	a3,a3,a1
    80000eea:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000eec:	00d58963          	beq	a1,a3,80000efe <safestrcpy+0x28>
    80000ef0:	0585                	addi	a1,a1,1
    80000ef2:	0785                	addi	a5,a5,1
    80000ef4:	fff5c703          	lbu	a4,-1(a1)
    80000ef8:	fee78fa3          	sb	a4,-1(a5)
    80000efc:	fb65                	bnez	a4,80000eec <safestrcpy+0x16>
    ;
  *s = 0;
    80000efe:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f02:	6422                	ld	s0,8(sp)
    80000f04:	0141                	addi	sp,sp,16
    80000f06:	8082                	ret

0000000080000f08 <strlen>:

int
strlen(const char *s)
{
    80000f08:	1141                	addi	sp,sp,-16
    80000f0a:	e422                	sd	s0,8(sp)
    80000f0c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f0e:	00054783          	lbu	a5,0(a0)
    80000f12:	cf91                	beqz	a5,80000f2e <strlen+0x26>
    80000f14:	0505                	addi	a0,a0,1
    80000f16:	87aa                	mv	a5,a0
    80000f18:	4685                	li	a3,1
    80000f1a:	9e89                	subw	a3,a3,a0
    80000f1c:	00f6853b          	addw	a0,a3,a5
    80000f20:	0785                	addi	a5,a5,1
    80000f22:	fff7c703          	lbu	a4,-1(a5)
    80000f26:	fb7d                	bnez	a4,80000f1c <strlen+0x14>
    ;
  return n;
}
    80000f28:	6422                	ld	s0,8(sp)
    80000f2a:	0141                	addi	sp,sp,16
    80000f2c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f2e:	4501                	li	a0,0
    80000f30:	bfe5                	j	80000f28 <strlen+0x20>

0000000080000f32 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f32:	1141                	addi	sp,sp,-16
    80000f34:	e406                	sd	ra,8(sp)
    80000f36:	e022                	sd	s0,0(sp)
    80000f38:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f3a:	00001097          	auipc	ra,0x1
    80000f3e:	b0a080e7          	jalr	-1270(ra) # 80001a44 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f42:	00008717          	auipc	a4,0x8
    80000f46:	0ca70713          	addi	a4,a4,202 # 8000900c <started>
  if(cpuid() == 0){
    80000f4a:	c139                	beqz	a0,80000f90 <main+0x5e>
    while(started == 0)
    80000f4c:	431c                	lw	a5,0(a4)
    80000f4e:	2781                	sext.w	a5,a5
    80000f50:	dff5                	beqz	a5,80000f4c <main+0x1a>
      ;
    __sync_synchronize();
    80000f52:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f56:	00001097          	auipc	ra,0x1
    80000f5a:	aee080e7          	jalr	-1298(ra) # 80001a44 <cpuid>
    80000f5e:	85aa                	mv	a1,a0
    80000f60:	00007517          	auipc	a0,0x7
    80000f64:	15850513          	addi	a0,a0,344 # 800080b8 <digits+0xa0>
    80000f68:	fffff097          	auipc	ra,0xfffff
    80000f6c:	656080e7          	jalr	1622(ra) # 800005be <printf>
    kvminithart();    // turn on paging
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	0d8080e7          	jalr	216(ra) # 80001048 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	75e080e7          	jalr	1886(ra) # 800026d6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f80:	00005097          	auipc	ra,0x5
    80000f84:	dd0080e7          	jalr	-560(ra) # 80005d50 <plicinithart>
  }

  scheduler();        
    80000f88:	00001097          	auipc	ra,0x1
    80000f8c:	01e080e7          	jalr	30(ra) # 80001fa6 <scheduler>
    consoleinit();
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	4f2080e7          	jalr	1266(ra) # 80000482 <consoleinit>
    printfinit();
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	80c080e7          	jalr	-2036(ra) # 800007a4 <printfinit>
    printf("\n");
    80000fa0:	00007517          	auipc	a0,0x7
    80000fa4:	12850513          	addi	a0,a0,296 # 800080c8 <digits+0xb0>
    80000fa8:	fffff097          	auipc	ra,0xfffff
    80000fac:	616080e7          	jalr	1558(ra) # 800005be <printf>
    printf("xv6 kernel is booting\n");
    80000fb0:	00007517          	auipc	a0,0x7
    80000fb4:	0f050513          	addi	a0,a0,240 # 800080a0 <digits+0x88>
    80000fb8:	fffff097          	auipc	ra,0xfffff
    80000fbc:	606080e7          	jalr	1542(ra) # 800005be <printf>
    printf("\n");
    80000fc0:	00007517          	auipc	a0,0x7
    80000fc4:	10850513          	addi	a0,a0,264 # 800080c8 <digits+0xb0>
    80000fc8:	fffff097          	auipc	ra,0xfffff
    80000fcc:	5f6080e7          	jalr	1526(ra) # 800005be <printf>
    kinit();         // physical page allocator
    80000fd0:	00000097          	auipc	ra,0x0
    80000fd4:	b66080e7          	jalr	-1178(ra) # 80000b36 <kinit>
    kvminit();       // create kernel page table
    80000fd8:	00000097          	auipc	ra,0x0
    80000fdc:	2a6080e7          	jalr	678(ra) # 8000127e <kvminit>
    kvminithart();   // turn on paging
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	068080e7          	jalr	104(ra) # 80001048 <kvminithart>
    procinit();      // process table
    80000fe8:	00001097          	auipc	ra,0x1
    80000fec:	98c080e7          	jalr	-1652(ra) # 80001974 <procinit>
    trapinit();      // trap vectors
    80000ff0:	00001097          	auipc	ra,0x1
    80000ff4:	6be080e7          	jalr	1726(ra) # 800026ae <trapinit>
    trapinithart();  // install kernel trap vector
    80000ff8:	00001097          	auipc	ra,0x1
    80000ffc:	6de080e7          	jalr	1758(ra) # 800026d6 <trapinithart>
    plicinit();      // set up interrupt controller
    80001000:	00005097          	auipc	ra,0x5
    80001004:	d3a080e7          	jalr	-710(ra) # 80005d3a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001008:	00005097          	auipc	ra,0x5
    8000100c:	d48080e7          	jalr	-696(ra) # 80005d50 <plicinithart>
    binit();         // buffer cache
    80001010:	00002097          	auipc	ra,0x2
    80001014:	e16080e7          	jalr	-490(ra) # 80002e26 <binit>
    iinit();         // inode cache
    80001018:	00002097          	auipc	ra,0x2
    8000101c:	4e8080e7          	jalr	1256(ra) # 80003500 <iinit>
    fileinit();      // file table
    80001020:	00003097          	auipc	ra,0x3
    80001024:	4ae080e7          	jalr	1198(ra) # 800044ce <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001028:	00005097          	auipc	ra,0x5
    8000102c:	e32080e7          	jalr	-462(ra) # 80005e5a <virtio_disk_init>
    userinit();      // first user process
    80001030:	00001097          	auipc	ra,0x1
    80001034:	d0c080e7          	jalr	-756(ra) # 80001d3c <userinit>
    __sync_synchronize();
    80001038:	0ff0000f          	fence
    started = 1;
    8000103c:	4785                	li	a5,1
    8000103e:	00008717          	auipc	a4,0x8
    80001042:	fcf72723          	sw	a5,-50(a4) # 8000900c <started>
    80001046:	b789                	j	80000f88 <main+0x56>

0000000080001048 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001048:	1141                	addi	sp,sp,-16
    8000104a:	e422                	sd	s0,8(sp)
    8000104c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000104e:	00008797          	auipc	a5,0x8
    80001052:	fc278793          	addi	a5,a5,-62 # 80009010 <kernel_pagetable>
    80001056:	639c                	ld	a5,0(a5)
    80001058:	83b1                	srli	a5,a5,0xc
    8000105a:	577d                	li	a4,-1
    8000105c:	177e                	slli	a4,a4,0x3f
    8000105e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001060:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001064:	12000073          	sfence.vma
  sfence_vma();
}
    80001068:	6422                	ld	s0,8(sp)
    8000106a:	0141                	addi	sp,sp,16
    8000106c:	8082                	ret

000000008000106e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000106e:	7139                	addi	sp,sp,-64
    80001070:	fc06                	sd	ra,56(sp)
    80001072:	f822                	sd	s0,48(sp)
    80001074:	f426                	sd	s1,40(sp)
    80001076:	f04a                	sd	s2,32(sp)
    80001078:	ec4e                	sd	s3,24(sp)
    8000107a:	e852                	sd	s4,16(sp)
    8000107c:	e456                	sd	s5,8(sp)
    8000107e:	e05a                	sd	s6,0(sp)
    80001080:	0080                	addi	s0,sp,64
    80001082:	84aa                	mv	s1,a0
    80001084:	89ae                	mv	s3,a1
    80001086:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80001088:	57fd                	li	a5,-1
    8000108a:	83e9                	srli	a5,a5,0x1a
    8000108c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000108e:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80001090:	04b7f263          	bleu	a1,a5,800010d4 <walk+0x66>
    panic("walk");
    80001094:	00007517          	auipc	a0,0x7
    80001098:	03c50513          	addi	a0,a0,60 # 800080d0 <digits+0xb8>
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	4d8080e7          	jalr	1240(ra) # 80000574 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010a4:	060b0663          	beqz	s6,80001110 <walk+0xa2>
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	aca080e7          	jalr	-1334(ra) # 80000b72 <kalloc>
    800010b0:	84aa                	mv	s1,a0
    800010b2:	c529                	beqz	a0,800010fc <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800010b4:	6605                	lui	a2,0x1
    800010b6:	4581                	li	a1,0
    800010b8:	00000097          	auipc	ra,0x0
    800010bc:	ca6080e7          	jalr	-858(ra) # 80000d5e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010c0:	00c4d793          	srli	a5,s1,0xc
    800010c4:	07aa                	slli	a5,a5,0xa
    800010c6:	0017e793          	ori	a5,a5,1
    800010ca:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800010ce:	3a5d                	addiw	s4,s4,-9
    800010d0:	035a0063          	beq	s4,s5,800010f0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800010d4:	0149d933          	srl	s2,s3,s4
    800010d8:	1ff97913          	andi	s2,s2,511
    800010dc:	090e                	slli	s2,s2,0x3
    800010de:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010e0:	00093483          	ld	s1,0(s2)
    800010e4:	0014f793          	andi	a5,s1,1
    800010e8:	dfd5                	beqz	a5,800010a4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010ea:	80a9                	srli	s1,s1,0xa
    800010ec:	04b2                	slli	s1,s1,0xc
    800010ee:	b7c5                	j	800010ce <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010f0:	00c9d513          	srli	a0,s3,0xc
    800010f4:	1ff57513          	andi	a0,a0,511
    800010f8:	050e                	slli	a0,a0,0x3
    800010fa:	9526                	add	a0,a0,s1
}
    800010fc:	70e2                	ld	ra,56(sp)
    800010fe:	7442                	ld	s0,48(sp)
    80001100:	74a2                	ld	s1,40(sp)
    80001102:	7902                	ld	s2,32(sp)
    80001104:	69e2                	ld	s3,24(sp)
    80001106:	6a42                	ld	s4,16(sp)
    80001108:	6aa2                	ld	s5,8(sp)
    8000110a:	6b02                	ld	s6,0(sp)
    8000110c:	6121                	addi	sp,sp,64
    8000110e:	8082                	ret
        return 0;
    80001110:	4501                	li	a0,0
    80001112:	b7ed                	j	800010fc <walk+0x8e>

0000000080001114 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001114:	57fd                	li	a5,-1
    80001116:	83e9                	srli	a5,a5,0x1a
    80001118:	00b7f463          	bleu	a1,a5,80001120 <walkaddr+0xc>
    return 0;
    8000111c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000111e:	8082                	ret
{
    80001120:	1141                	addi	sp,sp,-16
    80001122:	e406                	sd	ra,8(sp)
    80001124:	e022                	sd	s0,0(sp)
    80001126:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001128:	4601                	li	a2,0
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f44080e7          	jalr	-188(ra) # 8000106e <walk>
  if(pte == 0)
    80001132:	c105                	beqz	a0,80001152 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001134:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001136:	0117f693          	andi	a3,a5,17
    8000113a:	4745                	li	a4,17
    return 0;
    8000113c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000113e:	00e68663          	beq	a3,a4,8000114a <walkaddr+0x36>
}
    80001142:	60a2                	ld	ra,8(sp)
    80001144:	6402                	ld	s0,0(sp)
    80001146:	0141                	addi	sp,sp,16
    80001148:	8082                	ret
  pa = PTE2PA(*pte);
    8000114a:	00a7d513          	srli	a0,a5,0xa
    8000114e:	0532                	slli	a0,a0,0xc
  return pa;
    80001150:	bfcd                	j	80001142 <walkaddr+0x2e>
    return 0;
    80001152:	4501                	li	a0,0
    80001154:	b7fd                	j	80001142 <walkaddr+0x2e>

0000000080001156 <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    80001156:	1101                	addi	sp,sp,-32
    80001158:	ec06                	sd	ra,24(sp)
    8000115a:	e822                	sd	s0,16(sp)
    8000115c:	e426                	sd	s1,8(sp)
    8000115e:	1000                	addi	s0,sp,32
    80001160:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80001162:	6785                	lui	a5,0x1
    80001164:	17fd                	addi	a5,a5,-1
    80001166:	00f574b3          	and	s1,a0,a5
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kernel_pagetable, va, 0);
    8000116a:	4601                	li	a2,0
    8000116c:	00008797          	auipc	a5,0x8
    80001170:	ea478793          	addi	a5,a5,-348 # 80009010 <kernel_pagetable>
    80001174:	6388                	ld	a0,0(a5)
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	ef8080e7          	jalr	-264(ra) # 8000106e <walk>
  if(pte == 0)
    8000117e:	cd09                	beqz	a0,80001198 <kvmpa+0x42>
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    80001180:	6108                	ld	a0,0(a0)
    80001182:	00157793          	andi	a5,a0,1
    80001186:	c38d                	beqz	a5,800011a8 <kvmpa+0x52>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    80001188:	8129                	srli	a0,a0,0xa
    8000118a:	0532                	slli	a0,a0,0xc
  return pa+off;
}
    8000118c:	9526                	add	a0,a0,s1
    8000118e:	60e2                	ld	ra,24(sp)
    80001190:	6442                	ld	s0,16(sp)
    80001192:	64a2                	ld	s1,8(sp)
    80001194:	6105                	addi	sp,sp,32
    80001196:	8082                	ret
    panic("kvmpa");
    80001198:	00007517          	auipc	a0,0x7
    8000119c:	f4050513          	addi	a0,a0,-192 # 800080d8 <digits+0xc0>
    800011a0:	fffff097          	auipc	ra,0xfffff
    800011a4:	3d4080e7          	jalr	980(ra) # 80000574 <panic>
    panic("kvmpa");
    800011a8:	00007517          	auipc	a0,0x7
    800011ac:	f3050513          	addi	a0,a0,-208 # 800080d8 <digits+0xc0>
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	3c4080e7          	jalr	964(ra) # 80000574 <panic>

00000000800011b8 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800011b8:	715d                	addi	sp,sp,-80
    800011ba:	e486                	sd	ra,72(sp)
    800011bc:	e0a2                	sd	s0,64(sp)
    800011be:	fc26                	sd	s1,56(sp)
    800011c0:	f84a                	sd	s2,48(sp)
    800011c2:	f44e                	sd	s3,40(sp)
    800011c4:	f052                	sd	s4,32(sp)
    800011c6:	ec56                	sd	s5,24(sp)
    800011c8:	e85a                	sd	s6,16(sp)
    800011ca:	e45e                	sd	s7,8(sp)
    800011cc:	0880                	addi	s0,sp,80
    800011ce:	8aaa                	mv	s5,a0
    800011d0:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800011d2:	79fd                	lui	s3,0xfffff
    800011d4:	0135fa33          	and	s4,a1,s3
  last = PGROUNDDOWN(va + size - 1);
    800011d8:	167d                	addi	a2,a2,-1
    800011da:	962e                	add	a2,a2,a1
    800011dc:	013679b3          	and	s3,a2,s3
  a = PGROUNDDOWN(va);
    800011e0:	8952                	mv	s2,s4
    800011e2:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800011e6:	6b85                	lui	s7,0x1
    800011e8:	a811                	j	800011fc <mappages+0x44>
      panic("remap");
    800011ea:	00007517          	auipc	a0,0x7
    800011ee:	ef650513          	addi	a0,a0,-266 # 800080e0 <digits+0xc8>
    800011f2:	fffff097          	auipc	ra,0xfffff
    800011f6:	382080e7          	jalr	898(ra) # 80000574 <panic>
    a += PGSIZE;
    800011fa:	995e                	add	s2,s2,s7
  for(;;){
    800011fc:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001200:	4605                	li	a2,1
    80001202:	85ca                	mv	a1,s2
    80001204:	8556                	mv	a0,s5
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	e68080e7          	jalr	-408(ra) # 8000106e <walk>
    8000120e:	cd19                	beqz	a0,8000122c <mappages+0x74>
    if(*pte & PTE_V)
    80001210:	611c                	ld	a5,0(a0)
    80001212:	8b85                	andi	a5,a5,1
    80001214:	fbf9                	bnez	a5,800011ea <mappages+0x32>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001216:	80b1                	srli	s1,s1,0xc
    80001218:	04aa                	slli	s1,s1,0xa
    8000121a:	0164e4b3          	or	s1,s1,s6
    8000121e:	0014e493          	ori	s1,s1,1
    80001222:	e104                	sd	s1,0(a0)
    if(a == last)
    80001224:	fd391be3          	bne	s2,s3,800011fa <mappages+0x42>
    pa += PGSIZE;
  }
  return 0;
    80001228:	4501                	li	a0,0
    8000122a:	a011                	j	8000122e <mappages+0x76>
      return -1;
    8000122c:	557d                	li	a0,-1
}
    8000122e:	60a6                	ld	ra,72(sp)
    80001230:	6406                	ld	s0,64(sp)
    80001232:	74e2                	ld	s1,56(sp)
    80001234:	7942                	ld	s2,48(sp)
    80001236:	79a2                	ld	s3,40(sp)
    80001238:	7a02                	ld	s4,32(sp)
    8000123a:	6ae2                	ld	s5,24(sp)
    8000123c:	6b42                	ld	s6,16(sp)
    8000123e:	6ba2                	ld	s7,8(sp)
    80001240:	6161                	addi	sp,sp,80
    80001242:	8082                	ret

0000000080001244 <kvmmap>:
{
    80001244:	1141                	addi	sp,sp,-16
    80001246:	e406                	sd	ra,8(sp)
    80001248:	e022                	sd	s0,0(sp)
    8000124a:	0800                	addi	s0,sp,16
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    8000124c:	8736                	mv	a4,a3
    8000124e:	86ae                	mv	a3,a1
    80001250:	85aa                	mv	a1,a0
    80001252:	00008797          	auipc	a5,0x8
    80001256:	dbe78793          	addi	a5,a5,-578 # 80009010 <kernel_pagetable>
    8000125a:	6388                	ld	a0,0(a5)
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	f5c080e7          	jalr	-164(ra) # 800011b8 <mappages>
    80001264:	e509                	bnez	a0,8000126e <kvmmap+0x2a>
}
    80001266:	60a2                	ld	ra,8(sp)
    80001268:	6402                	ld	s0,0(sp)
    8000126a:	0141                	addi	sp,sp,16
    8000126c:	8082                	ret
    panic("kvmmap");
    8000126e:	00007517          	auipc	a0,0x7
    80001272:	e7a50513          	addi	a0,a0,-390 # 800080e8 <digits+0xd0>
    80001276:	fffff097          	auipc	ra,0xfffff
    8000127a:	2fe080e7          	jalr	766(ra) # 80000574 <panic>

000000008000127e <kvminit>:
{
    8000127e:	1101                	addi	sp,sp,-32
    80001280:	ec06                	sd	ra,24(sp)
    80001282:	e822                	sd	s0,16(sp)
    80001284:	e426                	sd	s1,8(sp)
    80001286:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	8ea080e7          	jalr	-1814(ra) # 80000b72 <kalloc>
    80001290:	00008797          	auipc	a5,0x8
    80001294:	d8a7b023          	sd	a0,-640(a5) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001298:	6605                	lui	a2,0x1
    8000129a:	4581                	li	a1,0
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	ac2080e7          	jalr	-1342(ra) # 80000d5e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012a4:	4699                	li	a3,6
    800012a6:	6605                	lui	a2,0x1
    800012a8:	100005b7          	lui	a1,0x10000
    800012ac:	10000537          	lui	a0,0x10000
    800012b0:	00000097          	auipc	ra,0x0
    800012b4:	f94080e7          	jalr	-108(ra) # 80001244 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012b8:	4699                	li	a3,6
    800012ba:	6605                	lui	a2,0x1
    800012bc:	100015b7          	lui	a1,0x10001
    800012c0:	10001537          	lui	a0,0x10001
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	f80080e7          	jalr	-128(ra) # 80001244 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    800012cc:	4699                	li	a3,6
    800012ce:	6641                	lui	a2,0x10
    800012d0:	020005b7          	lui	a1,0x2000
    800012d4:	02000537          	lui	a0,0x2000
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	f6c080e7          	jalr	-148(ra) # 80001244 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800012e0:	4699                	li	a3,6
    800012e2:	00400637          	lui	a2,0x400
    800012e6:	0c0005b7          	lui	a1,0xc000
    800012ea:	0c000537          	lui	a0,0xc000
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	f56080e7          	jalr	-170(ra) # 80001244 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012f6:	00007497          	auipc	s1,0x7
    800012fa:	d0a48493          	addi	s1,s1,-758 # 80008000 <etext>
    800012fe:	46a9                	li	a3,10
    80001300:	80007617          	auipc	a2,0x80007
    80001304:	d0060613          	addi	a2,a2,-768 # 8000 <_entry-0x7fff8000>
    80001308:	4585                	li	a1,1
    8000130a:	05fe                	slli	a1,a1,0x1f
    8000130c:	852e                	mv	a0,a1
    8000130e:	00000097          	auipc	ra,0x0
    80001312:	f36080e7          	jalr	-202(ra) # 80001244 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001316:	4699                	li	a3,6
    80001318:	4645                	li	a2,17
    8000131a:	066e                	slli	a2,a2,0x1b
    8000131c:	8e05                	sub	a2,a2,s1
    8000131e:	85a6                	mv	a1,s1
    80001320:	8526                	mv	a0,s1
    80001322:	00000097          	auipc	ra,0x0
    80001326:	f22080e7          	jalr	-222(ra) # 80001244 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000132a:	46a9                	li	a3,10
    8000132c:	6605                	lui	a2,0x1
    8000132e:	00006597          	auipc	a1,0x6
    80001332:	cd258593          	addi	a1,a1,-814 # 80007000 <_trampoline>
    80001336:	04000537          	lui	a0,0x4000
    8000133a:	157d                	addi	a0,a0,-1
    8000133c:	0532                	slli	a0,a0,0xc
    8000133e:	00000097          	auipc	ra,0x0
    80001342:	f06080e7          	jalr	-250(ra) # 80001244 <kvmmap>
}
    80001346:	60e2                	ld	ra,24(sp)
    80001348:	6442                	ld	s0,16(sp)
    8000134a:	64a2                	ld	s1,8(sp)
    8000134c:	6105                	addi	sp,sp,32
    8000134e:	8082                	ret

0000000080001350 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001350:	715d                	addi	sp,sp,-80
    80001352:	e486                	sd	ra,72(sp)
    80001354:	e0a2                	sd	s0,64(sp)
    80001356:	fc26                	sd	s1,56(sp)
    80001358:	f84a                	sd	s2,48(sp)
    8000135a:	f44e                	sd	s3,40(sp)
    8000135c:	f052                	sd	s4,32(sp)
    8000135e:	ec56                	sd	s5,24(sp)
    80001360:	e85a                	sd	s6,16(sp)
    80001362:	e45e                	sd	s7,8(sp)
    80001364:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001366:	6785                	lui	a5,0x1
    80001368:	17fd                	addi	a5,a5,-1
    8000136a:	8fed                	and	a5,a5,a1
    8000136c:	e795                	bnez	a5,80001398 <uvmunmap+0x48>
    8000136e:	8a2a                	mv	s4,a0
    80001370:	84ae                	mv	s1,a1
    80001372:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001374:	0632                	slli	a2,a2,0xc
    80001376:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000137a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000137c:	6b05                	lui	s6,0x1
    8000137e:	0735e863          	bltu	a1,s3,800013ee <uvmunmap+0x9e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001382:	60a6                	ld	ra,72(sp)
    80001384:	6406                	ld	s0,64(sp)
    80001386:	74e2                	ld	s1,56(sp)
    80001388:	7942                	ld	s2,48(sp)
    8000138a:	79a2                	ld	s3,40(sp)
    8000138c:	7a02                	ld	s4,32(sp)
    8000138e:	6ae2                	ld	s5,24(sp)
    80001390:	6b42                	ld	s6,16(sp)
    80001392:	6ba2                	ld	s7,8(sp)
    80001394:	6161                	addi	sp,sp,80
    80001396:	8082                	ret
    panic("uvmunmap: not aligned");
    80001398:	00007517          	auipc	a0,0x7
    8000139c:	d5850513          	addi	a0,a0,-680 # 800080f0 <digits+0xd8>
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	1d4080e7          	jalr	468(ra) # 80000574 <panic>
      panic("uvmunmap: walk");
    800013a8:	00007517          	auipc	a0,0x7
    800013ac:	d6050513          	addi	a0,a0,-672 # 80008108 <digits+0xf0>
    800013b0:	fffff097          	auipc	ra,0xfffff
    800013b4:	1c4080e7          	jalr	452(ra) # 80000574 <panic>
      panic("uvmunmap: not mapped");
    800013b8:	00007517          	auipc	a0,0x7
    800013bc:	d6050513          	addi	a0,a0,-672 # 80008118 <digits+0x100>
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	1b4080e7          	jalr	436(ra) # 80000574 <panic>
      panic("uvmunmap: not a leaf");
    800013c8:	00007517          	auipc	a0,0x7
    800013cc:	d6850513          	addi	a0,a0,-664 # 80008130 <digits+0x118>
    800013d0:	fffff097          	auipc	ra,0xfffff
    800013d4:	1a4080e7          	jalr	420(ra) # 80000574 <panic>
      uint64 pa = PTE2PA(*pte);
    800013d8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800013da:	0532                	slli	a0,a0,0xc
    800013dc:	fffff097          	auipc	ra,0xfffff
    800013e0:	696080e7          	jalr	1686(ra) # 80000a72 <kfree>
    *pte = 0;
    800013e4:	00093023          	sd	zero,0(s2)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013e8:	94da                	add	s1,s1,s6
    800013ea:	f934fce3          	bleu	s3,s1,80001382 <uvmunmap+0x32>
    if((pte = walk(pagetable, a, 0)) == 0)
    800013ee:	4601                	li	a2,0
    800013f0:	85a6                	mv	a1,s1
    800013f2:	8552                	mv	a0,s4
    800013f4:	00000097          	auipc	ra,0x0
    800013f8:	c7a080e7          	jalr	-902(ra) # 8000106e <walk>
    800013fc:	892a                	mv	s2,a0
    800013fe:	d54d                	beqz	a0,800013a8 <uvmunmap+0x58>
    if((*pte & PTE_V) == 0)
    80001400:	6108                	ld	a0,0(a0)
    80001402:	00157793          	andi	a5,a0,1
    80001406:	dbcd                	beqz	a5,800013b8 <uvmunmap+0x68>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001408:	3ff57793          	andi	a5,a0,1023
    8000140c:	fb778ee3          	beq	a5,s7,800013c8 <uvmunmap+0x78>
    if(do_free){
    80001410:	fc0a8ae3          	beqz	s5,800013e4 <uvmunmap+0x94>
    80001414:	b7d1                	j	800013d8 <uvmunmap+0x88>

0000000080001416 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001416:	1101                	addi	sp,sp,-32
    80001418:	ec06                	sd	ra,24(sp)
    8000141a:	e822                	sd	s0,16(sp)
    8000141c:	e426                	sd	s1,8(sp)
    8000141e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001420:	fffff097          	auipc	ra,0xfffff
    80001424:	752080e7          	jalr	1874(ra) # 80000b72 <kalloc>
    80001428:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000142a:	c519                	beqz	a0,80001438 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000142c:	6605                	lui	a2,0x1
    8000142e:	4581                	li	a1,0
    80001430:	00000097          	auipc	ra,0x0
    80001434:	92e080e7          	jalr	-1746(ra) # 80000d5e <memset>
  return pagetable;
}
    80001438:	8526                	mv	a0,s1
    8000143a:	60e2                	ld	ra,24(sp)
    8000143c:	6442                	ld	s0,16(sp)
    8000143e:	64a2                	ld	s1,8(sp)
    80001440:	6105                	addi	sp,sp,32
    80001442:	8082                	ret

0000000080001444 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001444:	7179                	addi	sp,sp,-48
    80001446:	f406                	sd	ra,40(sp)
    80001448:	f022                	sd	s0,32(sp)
    8000144a:	ec26                	sd	s1,24(sp)
    8000144c:	e84a                	sd	s2,16(sp)
    8000144e:	e44e                	sd	s3,8(sp)
    80001450:	e052                	sd	s4,0(sp)
    80001452:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001454:	6785                	lui	a5,0x1
    80001456:	04f67863          	bleu	a5,a2,800014a6 <uvminit+0x62>
    8000145a:	8a2a                	mv	s4,a0
    8000145c:	89ae                	mv	s3,a1
    8000145e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001460:	fffff097          	auipc	ra,0xfffff
    80001464:	712080e7          	jalr	1810(ra) # 80000b72 <kalloc>
    80001468:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000146a:	6605                	lui	a2,0x1
    8000146c:	4581                	li	a1,0
    8000146e:	00000097          	auipc	ra,0x0
    80001472:	8f0080e7          	jalr	-1808(ra) # 80000d5e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001476:	4779                	li	a4,30
    80001478:	86ca                	mv	a3,s2
    8000147a:	6605                	lui	a2,0x1
    8000147c:	4581                	li	a1,0
    8000147e:	8552                	mv	a0,s4
    80001480:	00000097          	auipc	ra,0x0
    80001484:	d38080e7          	jalr	-712(ra) # 800011b8 <mappages>
  memmove(mem, src, sz);
    80001488:	8626                	mv	a2,s1
    8000148a:	85ce                	mv	a1,s3
    8000148c:	854a                	mv	a0,s2
    8000148e:	00000097          	auipc	ra,0x0
    80001492:	93c080e7          	jalr	-1732(ra) # 80000dca <memmove>
}
    80001496:	70a2                	ld	ra,40(sp)
    80001498:	7402                	ld	s0,32(sp)
    8000149a:	64e2                	ld	s1,24(sp)
    8000149c:	6942                	ld	s2,16(sp)
    8000149e:	69a2                	ld	s3,8(sp)
    800014a0:	6a02                	ld	s4,0(sp)
    800014a2:	6145                	addi	sp,sp,48
    800014a4:	8082                	ret
    panic("inituvm: more than a page");
    800014a6:	00007517          	auipc	a0,0x7
    800014aa:	ca250513          	addi	a0,a0,-862 # 80008148 <digits+0x130>
    800014ae:	fffff097          	auipc	ra,0xfffff
    800014b2:	0c6080e7          	jalr	198(ra) # 80000574 <panic>

00000000800014b6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800014b6:	1101                	addi	sp,sp,-32
    800014b8:	ec06                	sd	ra,24(sp)
    800014ba:	e822                	sd	s0,16(sp)
    800014bc:	e426                	sd	s1,8(sp)
    800014be:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800014c0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014c2:	00b67d63          	bleu	a1,a2,800014dc <uvmdealloc+0x26>
    800014c6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014c8:	6605                	lui	a2,0x1
    800014ca:	167d                	addi	a2,a2,-1
    800014cc:	00c487b3          	add	a5,s1,a2
    800014d0:	777d                	lui	a4,0xfffff
    800014d2:	8ff9                	and	a5,a5,a4
    800014d4:	962e                	add	a2,a2,a1
    800014d6:	8e79                	and	a2,a2,a4
    800014d8:	00c7e863          	bltu	a5,a2,800014e8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800014dc:	8526                	mv	a0,s1
    800014de:	60e2                	ld	ra,24(sp)
    800014e0:	6442                	ld	s0,16(sp)
    800014e2:	64a2                	ld	s1,8(sp)
    800014e4:	6105                	addi	sp,sp,32
    800014e6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800014e8:	8e1d                	sub	a2,a2,a5
    800014ea:	8231                	srli	a2,a2,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014ec:	4685                	li	a3,1
    800014ee:	2601                	sext.w	a2,a2
    800014f0:	85be                	mv	a1,a5
    800014f2:	00000097          	auipc	ra,0x0
    800014f6:	e5e080e7          	jalr	-418(ra) # 80001350 <uvmunmap>
    800014fa:	b7cd                	j	800014dc <uvmdealloc+0x26>

00000000800014fc <uvmalloc>:
  if(newsz < oldsz)
    800014fc:	0ab66163          	bltu	a2,a1,8000159e <uvmalloc+0xa2>
{
    80001500:	7139                	addi	sp,sp,-64
    80001502:	fc06                	sd	ra,56(sp)
    80001504:	f822                	sd	s0,48(sp)
    80001506:	f426                	sd	s1,40(sp)
    80001508:	f04a                	sd	s2,32(sp)
    8000150a:	ec4e                	sd	s3,24(sp)
    8000150c:	e852                	sd	s4,16(sp)
    8000150e:	e456                	sd	s5,8(sp)
    80001510:	0080                	addi	s0,sp,64
  oldsz = PGROUNDUP(oldsz);
    80001512:	6a05                	lui	s4,0x1
    80001514:	1a7d                	addi	s4,s4,-1
    80001516:	95d2                	add	a1,a1,s4
    80001518:	7a7d                	lui	s4,0xfffff
    8000151a:	0145fa33          	and	s4,a1,s4
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000151e:	08ca7263          	bleu	a2,s4,800015a2 <uvmalloc+0xa6>
    80001522:	89b2                	mv	s3,a2
    80001524:	8aaa                	mv	s5,a0
    80001526:	8952                	mv	s2,s4
    mem = kalloc();
    80001528:	fffff097          	auipc	ra,0xfffff
    8000152c:	64a080e7          	jalr	1610(ra) # 80000b72 <kalloc>
    80001530:	84aa                	mv	s1,a0
    if(mem == 0){
    80001532:	c51d                	beqz	a0,80001560 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001534:	6605                	lui	a2,0x1
    80001536:	4581                	li	a1,0
    80001538:	00000097          	auipc	ra,0x0
    8000153c:	826080e7          	jalr	-2010(ra) # 80000d5e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001540:	4779                	li	a4,30
    80001542:	86a6                	mv	a3,s1
    80001544:	6605                	lui	a2,0x1
    80001546:	85ca                	mv	a1,s2
    80001548:	8556                	mv	a0,s5
    8000154a:	00000097          	auipc	ra,0x0
    8000154e:	c6e080e7          	jalr	-914(ra) # 800011b8 <mappages>
    80001552:	e905                	bnez	a0,80001582 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001554:	6785                	lui	a5,0x1
    80001556:	993e                	add	s2,s2,a5
    80001558:	fd3968e3          	bltu	s2,s3,80001528 <uvmalloc+0x2c>
  return newsz;
    8000155c:	854e                	mv	a0,s3
    8000155e:	a809                	j	80001570 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001560:	8652                	mv	a2,s4
    80001562:	85ca                	mv	a1,s2
    80001564:	8556                	mv	a0,s5
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	f50080e7          	jalr	-176(ra) # 800014b6 <uvmdealloc>
      return 0;
    8000156e:	4501                	li	a0,0
}
    80001570:	70e2                	ld	ra,56(sp)
    80001572:	7442                	ld	s0,48(sp)
    80001574:	74a2                	ld	s1,40(sp)
    80001576:	7902                	ld	s2,32(sp)
    80001578:	69e2                	ld	s3,24(sp)
    8000157a:	6a42                	ld	s4,16(sp)
    8000157c:	6aa2                	ld	s5,8(sp)
    8000157e:	6121                	addi	sp,sp,64
    80001580:	8082                	ret
      kfree(mem);
    80001582:	8526                	mv	a0,s1
    80001584:	fffff097          	auipc	ra,0xfffff
    80001588:	4ee080e7          	jalr	1262(ra) # 80000a72 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000158c:	8652                	mv	a2,s4
    8000158e:	85ca                	mv	a1,s2
    80001590:	8556                	mv	a0,s5
    80001592:	00000097          	auipc	ra,0x0
    80001596:	f24080e7          	jalr	-220(ra) # 800014b6 <uvmdealloc>
      return 0;
    8000159a:	4501                	li	a0,0
    8000159c:	bfd1                	j	80001570 <uvmalloc+0x74>
    return oldsz;
    8000159e:	852e                	mv	a0,a1
}
    800015a0:	8082                	ret
  return newsz;
    800015a2:	8532                	mv	a0,a2
    800015a4:	b7f1                	j	80001570 <uvmalloc+0x74>

00000000800015a6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800015a6:	7179                	addi	sp,sp,-48
    800015a8:	f406                	sd	ra,40(sp)
    800015aa:	f022                	sd	s0,32(sp)
    800015ac:	ec26                	sd	s1,24(sp)
    800015ae:	e84a                	sd	s2,16(sp)
    800015b0:	e44e                	sd	s3,8(sp)
    800015b2:	e052                	sd	s4,0(sp)
    800015b4:	1800                	addi	s0,sp,48
    800015b6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800015b8:	84aa                	mv	s1,a0
    800015ba:	6905                	lui	s2,0x1
    800015bc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015be:	4985                	li	s3,1
    800015c0:	a821                	j	800015d8 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800015c2:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800015c4:	0532                	slli	a0,a0,0xc
    800015c6:	00000097          	auipc	ra,0x0
    800015ca:	fe0080e7          	jalr	-32(ra) # 800015a6 <freewalk>
      pagetable[i] = 0;
    800015ce:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800015d2:	04a1                	addi	s1,s1,8
    800015d4:	03248163          	beq	s1,s2,800015f6 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800015d8:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015da:	00f57793          	andi	a5,a0,15
    800015de:	ff3782e3          	beq	a5,s3,800015c2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800015e2:	8905                	andi	a0,a0,1
    800015e4:	d57d                	beqz	a0,800015d2 <freewalk+0x2c>
      panic("freewalk: leaf");
    800015e6:	00007517          	auipc	a0,0x7
    800015ea:	b8250513          	addi	a0,a0,-1150 # 80008168 <digits+0x150>
    800015ee:	fffff097          	auipc	ra,0xfffff
    800015f2:	f86080e7          	jalr	-122(ra) # 80000574 <panic>
    }
  }
  kfree((void*)pagetable);
    800015f6:	8552                	mv	a0,s4
    800015f8:	fffff097          	auipc	ra,0xfffff
    800015fc:	47a080e7          	jalr	1146(ra) # 80000a72 <kfree>
}
    80001600:	70a2                	ld	ra,40(sp)
    80001602:	7402                	ld	s0,32(sp)
    80001604:	64e2                	ld	s1,24(sp)
    80001606:	6942                	ld	s2,16(sp)
    80001608:	69a2                	ld	s3,8(sp)
    8000160a:	6a02                	ld	s4,0(sp)
    8000160c:	6145                	addi	sp,sp,48
    8000160e:	8082                	ret

0000000080001610 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001610:	1101                	addi	sp,sp,-32
    80001612:	ec06                	sd	ra,24(sp)
    80001614:	e822                	sd	s0,16(sp)
    80001616:	e426                	sd	s1,8(sp)
    80001618:	1000                	addi	s0,sp,32
    8000161a:	84aa                	mv	s1,a0
  if(sz > 0)
    8000161c:	e999                	bnez	a1,80001632 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000161e:	8526                	mv	a0,s1
    80001620:	00000097          	auipc	ra,0x0
    80001624:	f86080e7          	jalr	-122(ra) # 800015a6 <freewalk>
}
    80001628:	60e2                	ld	ra,24(sp)
    8000162a:	6442                	ld	s0,16(sp)
    8000162c:	64a2                	ld	s1,8(sp)
    8000162e:	6105                	addi	sp,sp,32
    80001630:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001632:	6605                	lui	a2,0x1
    80001634:	167d                	addi	a2,a2,-1
    80001636:	962e                	add	a2,a2,a1
    80001638:	4685                	li	a3,1
    8000163a:	8231                	srli	a2,a2,0xc
    8000163c:	4581                	li	a1,0
    8000163e:	00000097          	auipc	ra,0x0
    80001642:	d12080e7          	jalr	-750(ra) # 80001350 <uvmunmap>
    80001646:	bfe1                	j	8000161e <uvmfree+0xe>

0000000080001648 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001648:	c679                	beqz	a2,80001716 <uvmcopy+0xce>
{
    8000164a:	715d                	addi	sp,sp,-80
    8000164c:	e486                	sd	ra,72(sp)
    8000164e:	e0a2                	sd	s0,64(sp)
    80001650:	fc26                	sd	s1,56(sp)
    80001652:	f84a                	sd	s2,48(sp)
    80001654:	f44e                	sd	s3,40(sp)
    80001656:	f052                	sd	s4,32(sp)
    80001658:	ec56                	sd	s5,24(sp)
    8000165a:	e85a                	sd	s6,16(sp)
    8000165c:	e45e                	sd	s7,8(sp)
    8000165e:	0880                	addi	s0,sp,80
    80001660:	8ab2                	mv	s5,a2
    80001662:	8b2e                	mv	s6,a1
    80001664:	8baa                	mv	s7,a0
  for(i = 0; i < sz; i += PGSIZE){
    80001666:	4901                	li	s2,0
    if((pte = walk(old, i, 0)) == 0)
    80001668:	4601                	li	a2,0
    8000166a:	85ca                	mv	a1,s2
    8000166c:	855e                	mv	a0,s7
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	a00080e7          	jalr	-1536(ra) # 8000106e <walk>
    80001676:	c531                	beqz	a0,800016c2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001678:	6118                	ld	a4,0(a0)
    8000167a:	00177793          	andi	a5,a4,1
    8000167e:	cbb1                	beqz	a5,800016d2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001680:	00a75593          	srli	a1,a4,0xa
    80001684:	00c59993          	slli	s3,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001688:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000168c:	fffff097          	auipc	ra,0xfffff
    80001690:	4e6080e7          	jalr	1254(ra) # 80000b72 <kalloc>
    80001694:	8a2a                	mv	s4,a0
    80001696:	c939                	beqz	a0,800016ec <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001698:	6605                	lui	a2,0x1
    8000169a:	85ce                	mv	a1,s3
    8000169c:	fffff097          	auipc	ra,0xfffff
    800016a0:	72e080e7          	jalr	1838(ra) # 80000dca <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800016a4:	8726                	mv	a4,s1
    800016a6:	86d2                	mv	a3,s4
    800016a8:	6605                	lui	a2,0x1
    800016aa:	85ca                	mv	a1,s2
    800016ac:	855a                	mv	a0,s6
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	b0a080e7          	jalr	-1270(ra) # 800011b8 <mappages>
    800016b6:	e515                	bnez	a0,800016e2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800016b8:	6785                	lui	a5,0x1
    800016ba:	993e                	add	s2,s2,a5
    800016bc:	fb5966e3          	bltu	s2,s5,80001668 <uvmcopy+0x20>
    800016c0:	a081                	j	80001700 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800016c2:	00007517          	auipc	a0,0x7
    800016c6:	ab650513          	addi	a0,a0,-1354 # 80008178 <digits+0x160>
    800016ca:	fffff097          	auipc	ra,0xfffff
    800016ce:	eaa080e7          	jalr	-342(ra) # 80000574 <panic>
      panic("uvmcopy: page not present");
    800016d2:	00007517          	auipc	a0,0x7
    800016d6:	ac650513          	addi	a0,a0,-1338 # 80008198 <digits+0x180>
    800016da:	fffff097          	auipc	ra,0xfffff
    800016de:	e9a080e7          	jalr	-358(ra) # 80000574 <panic>
      kfree(mem);
    800016e2:	8552                	mv	a0,s4
    800016e4:	fffff097          	auipc	ra,0xfffff
    800016e8:	38e080e7          	jalr	910(ra) # 80000a72 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016ec:	4685                	li	a3,1
    800016ee:	00c95613          	srli	a2,s2,0xc
    800016f2:	4581                	li	a1,0
    800016f4:	855a                	mv	a0,s6
    800016f6:	00000097          	auipc	ra,0x0
    800016fa:	c5a080e7          	jalr	-934(ra) # 80001350 <uvmunmap>
  return -1;
    800016fe:	557d                	li	a0,-1
}
    80001700:	60a6                	ld	ra,72(sp)
    80001702:	6406                	ld	s0,64(sp)
    80001704:	74e2                	ld	s1,56(sp)
    80001706:	7942                	ld	s2,48(sp)
    80001708:	79a2                	ld	s3,40(sp)
    8000170a:	7a02                	ld	s4,32(sp)
    8000170c:	6ae2                	ld	s5,24(sp)
    8000170e:	6b42                	ld	s6,16(sp)
    80001710:	6ba2                	ld	s7,8(sp)
    80001712:	6161                	addi	sp,sp,80
    80001714:	8082                	ret
  return 0;
    80001716:	4501                	li	a0,0
}
    80001718:	8082                	ret

000000008000171a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000171a:	1141                	addi	sp,sp,-16
    8000171c:	e406                	sd	ra,8(sp)
    8000171e:	e022                	sd	s0,0(sp)
    80001720:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001722:	4601                	li	a2,0
    80001724:	00000097          	auipc	ra,0x0
    80001728:	94a080e7          	jalr	-1718(ra) # 8000106e <walk>
  if(pte == 0)
    8000172c:	c901                	beqz	a0,8000173c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000172e:	611c                	ld	a5,0(a0)
    80001730:	9bbd                	andi	a5,a5,-17
    80001732:	e11c                	sd	a5,0(a0)
}
    80001734:	60a2                	ld	ra,8(sp)
    80001736:	6402                	ld	s0,0(sp)
    80001738:	0141                	addi	sp,sp,16
    8000173a:	8082                	ret
    panic("uvmclear");
    8000173c:	00007517          	auipc	a0,0x7
    80001740:	a7c50513          	addi	a0,a0,-1412 # 800081b8 <digits+0x1a0>
    80001744:	fffff097          	auipc	ra,0xfffff
    80001748:	e30080e7          	jalr	-464(ra) # 80000574 <panic>

000000008000174c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000174c:	c6bd                	beqz	a3,800017ba <copyout+0x6e>
{
    8000174e:	715d                	addi	sp,sp,-80
    80001750:	e486                	sd	ra,72(sp)
    80001752:	e0a2                	sd	s0,64(sp)
    80001754:	fc26                	sd	s1,56(sp)
    80001756:	f84a                	sd	s2,48(sp)
    80001758:	f44e                	sd	s3,40(sp)
    8000175a:	f052                	sd	s4,32(sp)
    8000175c:	ec56                	sd	s5,24(sp)
    8000175e:	e85a                	sd	s6,16(sp)
    80001760:	e45e                	sd	s7,8(sp)
    80001762:	e062                	sd	s8,0(sp)
    80001764:	0880                	addi	s0,sp,80
    80001766:	8baa                	mv	s7,a0
    80001768:	8a2e                	mv	s4,a1
    8000176a:	8ab2                	mv	s5,a2
    8000176c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000176e:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001770:	6b05                	lui	s6,0x1
    80001772:	a015                	j	80001796 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001774:	9552                	add	a0,a0,s4
    80001776:	0004861b          	sext.w	a2,s1
    8000177a:	85d6                	mv	a1,s5
    8000177c:	41250533          	sub	a0,a0,s2
    80001780:	fffff097          	auipc	ra,0xfffff
    80001784:	64a080e7          	jalr	1610(ra) # 80000dca <memmove>

    len -= n;
    80001788:	409989b3          	sub	s3,s3,s1
    src += n;
    8000178c:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    8000178e:	01690a33          	add	s4,s2,s6
  while(len > 0){
    80001792:	02098263          	beqz	s3,800017b6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001796:	018a7933          	and	s2,s4,s8
    pa0 = walkaddr(pagetable, va0);
    8000179a:	85ca                	mv	a1,s2
    8000179c:	855e                	mv	a0,s7
    8000179e:	00000097          	auipc	ra,0x0
    800017a2:	976080e7          	jalr	-1674(ra) # 80001114 <walkaddr>
    if(pa0 == 0)
    800017a6:	cd01                	beqz	a0,800017be <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800017a8:	414904b3          	sub	s1,s2,s4
    800017ac:	94da                	add	s1,s1,s6
    if(n > len)
    800017ae:	fc99f3e3          	bleu	s1,s3,80001774 <copyout+0x28>
    800017b2:	84ce                	mv	s1,s3
    800017b4:	b7c1                	j	80001774 <copyout+0x28>
  }
  return 0;
    800017b6:	4501                	li	a0,0
    800017b8:	a021                	j	800017c0 <copyout+0x74>
    800017ba:	4501                	li	a0,0
}
    800017bc:	8082                	ret
      return -1;
    800017be:	557d                	li	a0,-1
}
    800017c0:	60a6                	ld	ra,72(sp)
    800017c2:	6406                	ld	s0,64(sp)
    800017c4:	74e2                	ld	s1,56(sp)
    800017c6:	7942                	ld	s2,48(sp)
    800017c8:	79a2                	ld	s3,40(sp)
    800017ca:	7a02                	ld	s4,32(sp)
    800017cc:	6ae2                	ld	s5,24(sp)
    800017ce:	6b42                	ld	s6,16(sp)
    800017d0:	6ba2                	ld	s7,8(sp)
    800017d2:	6c02                	ld	s8,0(sp)
    800017d4:	6161                	addi	sp,sp,80
    800017d6:	8082                	ret

00000000800017d8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017d8:	caa5                	beqz	a3,80001848 <copyin+0x70>
{
    800017da:	715d                	addi	sp,sp,-80
    800017dc:	e486                	sd	ra,72(sp)
    800017de:	e0a2                	sd	s0,64(sp)
    800017e0:	fc26                	sd	s1,56(sp)
    800017e2:	f84a                	sd	s2,48(sp)
    800017e4:	f44e                	sd	s3,40(sp)
    800017e6:	f052                	sd	s4,32(sp)
    800017e8:	ec56                	sd	s5,24(sp)
    800017ea:	e85a                	sd	s6,16(sp)
    800017ec:	e45e                	sd	s7,8(sp)
    800017ee:	e062                	sd	s8,0(sp)
    800017f0:	0880                	addi	s0,sp,80
    800017f2:	8baa                	mv	s7,a0
    800017f4:	8aae                	mv	s5,a1
    800017f6:	8a32                	mv	s4,a2
    800017f8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017fa:	7c7d                	lui	s8,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017fc:	6b05                	lui	s6,0x1
    800017fe:	a01d                	j	80001824 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001800:	014505b3          	add	a1,a0,s4
    80001804:	0004861b          	sext.w	a2,s1
    80001808:	412585b3          	sub	a1,a1,s2
    8000180c:	8556                	mv	a0,s5
    8000180e:	fffff097          	auipc	ra,0xfffff
    80001812:	5bc080e7          	jalr	1468(ra) # 80000dca <memmove>

    len -= n;
    80001816:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000181a:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    8000181c:	01690a33          	add	s4,s2,s6
  while(len > 0){
    80001820:	02098263          	beqz	s3,80001844 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001824:	018a7933          	and	s2,s4,s8
    pa0 = walkaddr(pagetable, va0);
    80001828:	85ca                	mv	a1,s2
    8000182a:	855e                	mv	a0,s7
    8000182c:	00000097          	auipc	ra,0x0
    80001830:	8e8080e7          	jalr	-1816(ra) # 80001114 <walkaddr>
    if(pa0 == 0)
    80001834:	cd01                	beqz	a0,8000184c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001836:	414904b3          	sub	s1,s2,s4
    8000183a:	94da                	add	s1,s1,s6
    if(n > len)
    8000183c:	fc99f2e3          	bleu	s1,s3,80001800 <copyin+0x28>
    80001840:	84ce                	mv	s1,s3
    80001842:	bf7d                	j	80001800 <copyin+0x28>
  }
  return 0;
    80001844:	4501                	li	a0,0
    80001846:	a021                	j	8000184e <copyin+0x76>
    80001848:	4501                	li	a0,0
}
    8000184a:	8082                	ret
      return -1;
    8000184c:	557d                	li	a0,-1
}
    8000184e:	60a6                	ld	ra,72(sp)
    80001850:	6406                	ld	s0,64(sp)
    80001852:	74e2                	ld	s1,56(sp)
    80001854:	7942                	ld	s2,48(sp)
    80001856:	79a2                	ld	s3,40(sp)
    80001858:	7a02                	ld	s4,32(sp)
    8000185a:	6ae2                	ld	s5,24(sp)
    8000185c:	6b42                	ld	s6,16(sp)
    8000185e:	6ba2                	ld	s7,8(sp)
    80001860:	6c02                	ld	s8,0(sp)
    80001862:	6161                	addi	sp,sp,80
    80001864:	8082                	ret

0000000080001866 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001866:	ced5                	beqz	a3,80001922 <copyinstr+0xbc>
{
    80001868:	715d                	addi	sp,sp,-80
    8000186a:	e486                	sd	ra,72(sp)
    8000186c:	e0a2                	sd	s0,64(sp)
    8000186e:	fc26                	sd	s1,56(sp)
    80001870:	f84a                	sd	s2,48(sp)
    80001872:	f44e                	sd	s3,40(sp)
    80001874:	f052                	sd	s4,32(sp)
    80001876:	ec56                	sd	s5,24(sp)
    80001878:	e85a                	sd	s6,16(sp)
    8000187a:	e45e                	sd	s7,8(sp)
    8000187c:	e062                	sd	s8,0(sp)
    8000187e:	0880                	addi	s0,sp,80
    80001880:	8aaa                	mv	s5,a0
    80001882:	84ae                	mv	s1,a1
    80001884:	8c32                	mv	s8,a2
    80001886:	8bb6                	mv	s7,a3
    va0 = PGROUNDDOWN(srcva);
    80001888:	7a7d                	lui	s4,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000188a:	6985                	lui	s3,0x1
    8000188c:	4b05                	li	s6,1
    8000188e:	a801                	j	8000189e <copyinstr+0x38>
    if(n > max)
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
    80001890:	87a6                	mv	a5,s1
    80001892:	a085                	j	800018f2 <copyinstr+0x8c>
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    80001894:	84b2                	mv	s1,a2
    }

    srcva = va0 + PGSIZE;
    80001896:	01390c33          	add	s8,s2,s3
  while(got_null == 0 && max > 0){
    8000189a:	080b8063          	beqz	s7,8000191a <copyinstr+0xb4>
    va0 = PGROUNDDOWN(srcva);
    8000189e:	014c7933          	and	s2,s8,s4
    pa0 = walkaddr(pagetable, va0);
    800018a2:	85ca                	mv	a1,s2
    800018a4:	8556                	mv	a0,s5
    800018a6:	00000097          	auipc	ra,0x0
    800018aa:	86e080e7          	jalr	-1938(ra) # 80001114 <walkaddr>
    if(pa0 == 0)
    800018ae:	c925                	beqz	a0,8000191e <copyinstr+0xb8>
    n = PGSIZE - (srcva - va0);
    800018b0:	41890633          	sub	a2,s2,s8
    800018b4:	964e                	add	a2,a2,s3
    if(n > max)
    800018b6:	00cbf363          	bleu	a2,s7,800018bc <copyinstr+0x56>
    800018ba:	865e                	mv	a2,s7
    char *p = (char *) (pa0 + (srcva - va0));
    800018bc:	9562                	add	a0,a0,s8
    800018be:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800018c2:	da71                	beqz	a2,80001896 <copyinstr+0x30>
      if(*p == '\0'){
    800018c4:	00054703          	lbu	a4,0(a0)
    800018c8:	d761                	beqz	a4,80001890 <copyinstr+0x2a>
    800018ca:	9626                	add	a2,a2,s1
    800018cc:	87a6                	mv	a5,s1
    800018ce:	1bfd                	addi	s7,s7,-1
    800018d0:	009b86b3          	add	a3,s7,s1
    800018d4:	409b04b3          	sub	s1,s6,s1
    800018d8:	94aa                	add	s1,s1,a0
        *dst = *p;
    800018da:	00e78023          	sb	a4,0(a5) # 1000 <_entry-0x7ffff000>
      --max;
    800018de:	40f68bb3          	sub	s7,a3,a5
      p++;
    800018e2:	00f48733          	add	a4,s1,a5
      dst++;
    800018e6:	0785                	addi	a5,a5,1
    while(n > 0){
    800018e8:	faf606e3          	beq	a2,a5,80001894 <copyinstr+0x2e>
      if(*p == '\0'){
    800018ec:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    800018f0:	f76d                	bnez	a4,800018da <copyinstr+0x74>
        *dst = '\0';
    800018f2:	00078023          	sb	zero,0(a5)
    800018f6:	4785                	li	a5,1
  }
  if(got_null){
    800018f8:	0017b513          	seqz	a0,a5
    800018fc:	40a0053b          	negw	a0,a0
    80001900:	2501                	sext.w	a0,a0
    return 0;
  } else {
    return -1;
  }
}
    80001902:	60a6                	ld	ra,72(sp)
    80001904:	6406                	ld	s0,64(sp)
    80001906:	74e2                	ld	s1,56(sp)
    80001908:	7942                	ld	s2,48(sp)
    8000190a:	79a2                	ld	s3,40(sp)
    8000190c:	7a02                	ld	s4,32(sp)
    8000190e:	6ae2                	ld	s5,24(sp)
    80001910:	6b42                	ld	s6,16(sp)
    80001912:	6ba2                	ld	s7,8(sp)
    80001914:	6c02                	ld	s8,0(sp)
    80001916:	6161                	addi	sp,sp,80
    80001918:	8082                	ret
    8000191a:	4781                	li	a5,0
    8000191c:	bff1                	j	800018f8 <copyinstr+0x92>
      return -1;
    8000191e:	557d                	li	a0,-1
    80001920:	b7cd                	j	80001902 <copyinstr+0x9c>
  int got_null = 0;
    80001922:	4781                	li	a5,0
  if(got_null){
    80001924:	0017b513          	seqz	a0,a5
    80001928:	40a0053b          	negw	a0,a0
    8000192c:	2501                	sext.w	a0,a0
}
    8000192e:	8082                	ret

0000000080001930 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001930:	1101                	addi	sp,sp,-32
    80001932:	ec06                	sd	ra,24(sp)
    80001934:	e822                	sd	s0,16(sp)
    80001936:	e426                	sd	s1,8(sp)
    80001938:	1000                	addi	s0,sp,32
    8000193a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000193c:	fffff097          	auipc	ra,0xfffff
    80001940:	2ac080e7          	jalr	684(ra) # 80000be8 <holding>
    80001944:	c909                	beqz	a0,80001956 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001946:	749c                	ld	a5,40(s1)
    80001948:	00978f63          	beq	a5,s1,80001966 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    8000194c:	60e2                	ld	ra,24(sp)
    8000194e:	6442                	ld	s0,16(sp)
    80001950:	64a2                	ld	s1,8(sp)
    80001952:	6105                	addi	sp,sp,32
    80001954:	8082                	ret
    panic("wakeup1");
    80001956:	00007517          	auipc	a0,0x7
    8000195a:	89a50513          	addi	a0,a0,-1894 # 800081f0 <states.1722+0x28>
    8000195e:	fffff097          	auipc	ra,0xfffff
    80001962:	c16080e7          	jalr	-1002(ra) # 80000574 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001966:	4c98                	lw	a4,24(s1)
    80001968:	4785                	li	a5,1
    8000196a:	fef711e3          	bne	a4,a5,8000194c <wakeup1+0x1c>
    p->state = RUNNABLE;
    8000196e:	4789                	li	a5,2
    80001970:	cc9c                	sw	a5,24(s1)
}
    80001972:	bfe9                	j	8000194c <wakeup1+0x1c>

0000000080001974 <procinit>:
{
    80001974:	715d                	addi	sp,sp,-80
    80001976:	e486                	sd	ra,72(sp)
    80001978:	e0a2                	sd	s0,64(sp)
    8000197a:	fc26                	sd	s1,56(sp)
    8000197c:	f84a                	sd	s2,48(sp)
    8000197e:	f44e                	sd	s3,40(sp)
    80001980:	f052                	sd	s4,32(sp)
    80001982:	ec56                	sd	s5,24(sp)
    80001984:	e85a                	sd	s6,16(sp)
    80001986:	e45e                	sd	s7,8(sp)
    80001988:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    8000198a:	00007597          	auipc	a1,0x7
    8000198e:	86e58593          	addi	a1,a1,-1938 # 800081f8 <states.1722+0x30>
    80001992:	00010517          	auipc	a0,0x10
    80001996:	fbe50513          	addi	a0,a0,-66 # 80011950 <pid_lock>
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	238080e7          	jalr	568(ra) # 80000bd2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019a2:	00010917          	auipc	s2,0x10
    800019a6:	3c690913          	addi	s2,s2,966 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    800019aa:	00007b97          	auipc	s7,0x7
    800019ae:	856b8b93          	addi	s7,s7,-1962 # 80008200 <states.1722+0x38>
      uint64 va = KSTACK((int) (p - proc));
    800019b2:	8b4a                	mv	s6,s2
    800019b4:	00006a97          	auipc	s5,0x6
    800019b8:	64ca8a93          	addi	s5,s5,1612 # 80008000 <etext>
    800019bc:	040009b7          	lui	s3,0x4000
    800019c0:	19fd                	addi	s3,s3,-1
    800019c2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019c4:	00016a17          	auipc	s4,0x16
    800019c8:	da4a0a13          	addi	s4,s4,-604 # 80017768 <tickslock>
      initlock(&p->lock, "proc");
    800019cc:	85de                	mv	a1,s7
    800019ce:	854a                	mv	a0,s2
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	202080e7          	jalr	514(ra) # 80000bd2 <initlock>
      char *pa = kalloc();
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	19a080e7          	jalr	410(ra) # 80000b72 <kalloc>
    800019e0:	85aa                	mv	a1,a0
      if(pa == 0)
    800019e2:	c929                	beqz	a0,80001a34 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800019e4:	416904b3          	sub	s1,s2,s6
    800019e8:	848d                	srai	s1,s1,0x3
    800019ea:	000ab783          	ld	a5,0(s5)
    800019ee:	02f484b3          	mul	s1,s1,a5
    800019f2:	2485                	addiw	s1,s1,1
    800019f4:	00d4949b          	slliw	s1,s1,0xd
    800019f8:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019fc:	4699                	li	a3,6
    800019fe:	6605                	lui	a2,0x1
    80001a00:	8526                	mv	a0,s1
    80001a02:	00000097          	auipc	ra,0x0
    80001a06:	842080e7          	jalr	-1982(ra) # 80001244 <kvmmap>
      p->kstack = va;
    80001a0a:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a0e:	16890913          	addi	s2,s2,360
    80001a12:	fb491de3          	bne	s2,s4,800019cc <procinit+0x58>
  kvminithart();
    80001a16:	fffff097          	auipc	ra,0xfffff
    80001a1a:	632080e7          	jalr	1586(ra) # 80001048 <kvminithart>
}
    80001a1e:	60a6                	ld	ra,72(sp)
    80001a20:	6406                	ld	s0,64(sp)
    80001a22:	74e2                	ld	s1,56(sp)
    80001a24:	7942                	ld	s2,48(sp)
    80001a26:	79a2                	ld	s3,40(sp)
    80001a28:	7a02                	ld	s4,32(sp)
    80001a2a:	6ae2                	ld	s5,24(sp)
    80001a2c:	6b42                	ld	s6,16(sp)
    80001a2e:	6ba2                	ld	s7,8(sp)
    80001a30:	6161                	addi	sp,sp,80
    80001a32:	8082                	ret
        panic("kalloc");
    80001a34:	00006517          	auipc	a0,0x6
    80001a38:	7d450513          	addi	a0,a0,2004 # 80008208 <states.1722+0x40>
    80001a3c:	fffff097          	auipc	ra,0xfffff
    80001a40:	b38080e7          	jalr	-1224(ra) # 80000574 <panic>

0000000080001a44 <cpuid>:
{
    80001a44:	1141                	addi	sp,sp,-16
    80001a46:	e422                	sd	s0,8(sp)
    80001a48:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a4a:	8512                	mv	a0,tp
}
    80001a4c:	2501                	sext.w	a0,a0
    80001a4e:	6422                	ld	s0,8(sp)
    80001a50:	0141                	addi	sp,sp,16
    80001a52:	8082                	ret

0000000080001a54 <mycpu>:
mycpu(void) {
    80001a54:	1141                	addi	sp,sp,-16
    80001a56:	e422                	sd	s0,8(sp)
    80001a58:	0800                	addi	s0,sp,16
    80001a5a:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001a5c:	2781                	sext.w	a5,a5
    80001a5e:	079e                	slli	a5,a5,0x7
}
    80001a60:	00010517          	auipc	a0,0x10
    80001a64:	f0850513          	addi	a0,a0,-248 # 80011968 <cpus>
    80001a68:	953e                	add	a0,a0,a5
    80001a6a:	6422                	ld	s0,8(sp)
    80001a6c:	0141                	addi	sp,sp,16
    80001a6e:	8082                	ret

0000000080001a70 <myproc>:
myproc(void) {
    80001a70:	1101                	addi	sp,sp,-32
    80001a72:	ec06                	sd	ra,24(sp)
    80001a74:	e822                	sd	s0,16(sp)
    80001a76:	e426                	sd	s1,8(sp)
    80001a78:	1000                	addi	s0,sp,32
  push_off();
    80001a7a:	fffff097          	auipc	ra,0xfffff
    80001a7e:	19c080e7          	jalr	412(ra) # 80000c16 <push_off>
    80001a82:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a84:	2781                	sext.w	a5,a5
    80001a86:	079e                	slli	a5,a5,0x7
    80001a88:	00010717          	auipc	a4,0x10
    80001a8c:	ec870713          	addi	a4,a4,-312 # 80011950 <pid_lock>
    80001a90:	97ba                	add	a5,a5,a4
    80001a92:	6f84                	ld	s1,24(a5)
  pop_off();
    80001a94:	fffff097          	auipc	ra,0xfffff
    80001a98:	222080e7          	jalr	546(ra) # 80000cb6 <pop_off>
}
    80001a9c:	8526                	mv	a0,s1
    80001a9e:	60e2                	ld	ra,24(sp)
    80001aa0:	6442                	ld	s0,16(sp)
    80001aa2:	64a2                	ld	s1,8(sp)
    80001aa4:	6105                	addi	sp,sp,32
    80001aa6:	8082                	ret

0000000080001aa8 <forkret>:
{
    80001aa8:	1141                	addi	sp,sp,-16
    80001aaa:	e406                	sd	ra,8(sp)
    80001aac:	e022                	sd	s0,0(sp)
    80001aae:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001ab0:	00000097          	auipc	ra,0x0
    80001ab4:	fc0080e7          	jalr	-64(ra) # 80001a70 <myproc>
    80001ab8:	fffff097          	auipc	ra,0xfffff
    80001abc:	25e080e7          	jalr	606(ra) # 80000d16 <release>
  if (first) {
    80001ac0:	00007797          	auipc	a5,0x7
    80001ac4:	d5078793          	addi	a5,a5,-688 # 80008810 <first.1682>
    80001ac8:	439c                	lw	a5,0(a5)
    80001aca:	eb89                	bnez	a5,80001adc <forkret+0x34>
  usertrapret();
    80001acc:	00001097          	auipc	ra,0x1
    80001ad0:	c22080e7          	jalr	-990(ra) # 800026ee <usertrapret>
}
    80001ad4:	60a2                	ld	ra,8(sp)
    80001ad6:	6402                	ld	s0,0(sp)
    80001ad8:	0141                	addi	sp,sp,16
    80001ada:	8082                	ret
    first = 0;
    80001adc:	00007797          	auipc	a5,0x7
    80001ae0:	d207aa23          	sw	zero,-716(a5) # 80008810 <first.1682>
    fsinit(ROOTDEV);
    80001ae4:	4505                	li	a0,1
    80001ae6:	00002097          	auipc	ra,0x2
    80001aea:	99c080e7          	jalr	-1636(ra) # 80003482 <fsinit>
    80001aee:	bff9                	j	80001acc <forkret+0x24>

0000000080001af0 <allocpid>:
allocpid() {
    80001af0:	1101                	addi	sp,sp,-32
    80001af2:	ec06                	sd	ra,24(sp)
    80001af4:	e822                	sd	s0,16(sp)
    80001af6:	e426                	sd	s1,8(sp)
    80001af8:	e04a                	sd	s2,0(sp)
    80001afa:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001afc:	00010917          	auipc	s2,0x10
    80001b00:	e5490913          	addi	s2,s2,-428 # 80011950 <pid_lock>
    80001b04:	854a                	mv	a0,s2
    80001b06:	fffff097          	auipc	ra,0xfffff
    80001b0a:	15c080e7          	jalr	348(ra) # 80000c62 <acquire>
  pid = nextpid;
    80001b0e:	00007797          	auipc	a5,0x7
    80001b12:	d0678793          	addi	a5,a5,-762 # 80008814 <nextpid>
    80001b16:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b18:	0014871b          	addiw	a4,s1,1
    80001b1c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b1e:	854a                	mv	a0,s2
    80001b20:	fffff097          	auipc	ra,0xfffff
    80001b24:	1f6080e7          	jalr	502(ra) # 80000d16 <release>
}
    80001b28:	8526                	mv	a0,s1
    80001b2a:	60e2                	ld	ra,24(sp)
    80001b2c:	6442                	ld	s0,16(sp)
    80001b2e:	64a2                	ld	s1,8(sp)
    80001b30:	6902                	ld	s2,0(sp)
    80001b32:	6105                	addi	sp,sp,32
    80001b34:	8082                	ret

0000000080001b36 <proc_pagetable>:
{
    80001b36:	1101                	addi	sp,sp,-32
    80001b38:	ec06                	sd	ra,24(sp)
    80001b3a:	e822                	sd	s0,16(sp)
    80001b3c:	e426                	sd	s1,8(sp)
    80001b3e:	e04a                	sd	s2,0(sp)
    80001b40:	1000                	addi	s0,sp,32
    80001b42:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b44:	00000097          	auipc	ra,0x0
    80001b48:	8d2080e7          	jalr	-1838(ra) # 80001416 <uvmcreate>
    80001b4c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b4e:	c121                	beqz	a0,80001b8e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b50:	4729                	li	a4,10
    80001b52:	00005697          	auipc	a3,0x5
    80001b56:	4ae68693          	addi	a3,a3,1198 # 80007000 <_trampoline>
    80001b5a:	6605                	lui	a2,0x1
    80001b5c:	040005b7          	lui	a1,0x4000
    80001b60:	15fd                	addi	a1,a1,-1
    80001b62:	05b2                	slli	a1,a1,0xc
    80001b64:	fffff097          	auipc	ra,0xfffff
    80001b68:	654080e7          	jalr	1620(ra) # 800011b8 <mappages>
    80001b6c:	02054863          	bltz	a0,80001b9c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b70:	4719                	li	a4,6
    80001b72:	05893683          	ld	a3,88(s2)
    80001b76:	6605                	lui	a2,0x1
    80001b78:	020005b7          	lui	a1,0x2000
    80001b7c:	15fd                	addi	a1,a1,-1
    80001b7e:	05b6                	slli	a1,a1,0xd
    80001b80:	8526                	mv	a0,s1
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	636080e7          	jalr	1590(ra) # 800011b8 <mappages>
    80001b8a:	02054163          	bltz	a0,80001bac <proc_pagetable+0x76>
}
    80001b8e:	8526                	mv	a0,s1
    80001b90:	60e2                	ld	ra,24(sp)
    80001b92:	6442                	ld	s0,16(sp)
    80001b94:	64a2                	ld	s1,8(sp)
    80001b96:	6902                	ld	s2,0(sp)
    80001b98:	6105                	addi	sp,sp,32
    80001b9a:	8082                	ret
    uvmfree(pagetable, 0);
    80001b9c:	4581                	li	a1,0
    80001b9e:	8526                	mv	a0,s1
    80001ba0:	00000097          	auipc	ra,0x0
    80001ba4:	a70080e7          	jalr	-1424(ra) # 80001610 <uvmfree>
    return 0;
    80001ba8:	4481                	li	s1,0
    80001baa:	b7d5                	j	80001b8e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bac:	4681                	li	a3,0
    80001bae:	4605                	li	a2,1
    80001bb0:	040005b7          	lui	a1,0x4000
    80001bb4:	15fd                	addi	a1,a1,-1
    80001bb6:	05b2                	slli	a1,a1,0xc
    80001bb8:	8526                	mv	a0,s1
    80001bba:	fffff097          	auipc	ra,0xfffff
    80001bbe:	796080e7          	jalr	1942(ra) # 80001350 <uvmunmap>
    uvmfree(pagetable, 0);
    80001bc2:	4581                	li	a1,0
    80001bc4:	8526                	mv	a0,s1
    80001bc6:	00000097          	auipc	ra,0x0
    80001bca:	a4a080e7          	jalr	-1462(ra) # 80001610 <uvmfree>
    return 0;
    80001bce:	4481                	li	s1,0
    80001bd0:	bf7d                	j	80001b8e <proc_pagetable+0x58>

0000000080001bd2 <proc_freepagetable>:
{
    80001bd2:	1101                	addi	sp,sp,-32
    80001bd4:	ec06                	sd	ra,24(sp)
    80001bd6:	e822                	sd	s0,16(sp)
    80001bd8:	e426                	sd	s1,8(sp)
    80001bda:	e04a                	sd	s2,0(sp)
    80001bdc:	1000                	addi	s0,sp,32
    80001bde:	84aa                	mv	s1,a0
    80001be0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001be2:	4681                	li	a3,0
    80001be4:	4605                	li	a2,1
    80001be6:	040005b7          	lui	a1,0x4000
    80001bea:	15fd                	addi	a1,a1,-1
    80001bec:	05b2                	slli	a1,a1,0xc
    80001bee:	fffff097          	auipc	ra,0xfffff
    80001bf2:	762080e7          	jalr	1890(ra) # 80001350 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001bf6:	4681                	li	a3,0
    80001bf8:	4605                	li	a2,1
    80001bfa:	020005b7          	lui	a1,0x2000
    80001bfe:	15fd                	addi	a1,a1,-1
    80001c00:	05b6                	slli	a1,a1,0xd
    80001c02:	8526                	mv	a0,s1
    80001c04:	fffff097          	auipc	ra,0xfffff
    80001c08:	74c080e7          	jalr	1868(ra) # 80001350 <uvmunmap>
  uvmfree(pagetable, sz);
    80001c0c:	85ca                	mv	a1,s2
    80001c0e:	8526                	mv	a0,s1
    80001c10:	00000097          	auipc	ra,0x0
    80001c14:	a00080e7          	jalr	-1536(ra) # 80001610 <uvmfree>
}
    80001c18:	60e2                	ld	ra,24(sp)
    80001c1a:	6442                	ld	s0,16(sp)
    80001c1c:	64a2                	ld	s1,8(sp)
    80001c1e:	6902                	ld	s2,0(sp)
    80001c20:	6105                	addi	sp,sp,32
    80001c22:	8082                	ret

0000000080001c24 <freeproc>:
{
    80001c24:	1101                	addi	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	e426                	sd	s1,8(sp)
    80001c2c:	1000                	addi	s0,sp,32
    80001c2e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001c30:	6d28                	ld	a0,88(a0)
    80001c32:	c509                	beqz	a0,80001c3c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001c34:	fffff097          	auipc	ra,0xfffff
    80001c38:	e3e080e7          	jalr	-450(ra) # 80000a72 <kfree>
  p->trapframe = 0;
    80001c3c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001c40:	68a8                	ld	a0,80(s1)
    80001c42:	c511                	beqz	a0,80001c4e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001c44:	64ac                	ld	a1,72(s1)
    80001c46:	00000097          	auipc	ra,0x0
    80001c4a:	f8c080e7          	jalr	-116(ra) # 80001bd2 <proc_freepagetable>
  p->pagetable = 0;
    80001c4e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c52:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c56:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001c5a:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001c5e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c62:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001c66:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001c6a:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001c6e:	0004ac23          	sw	zero,24(s1)
}
    80001c72:	60e2                	ld	ra,24(sp)
    80001c74:	6442                	ld	s0,16(sp)
    80001c76:	64a2                	ld	s1,8(sp)
    80001c78:	6105                	addi	sp,sp,32
    80001c7a:	8082                	ret

0000000080001c7c <allocproc>:
{
    80001c7c:	1101                	addi	sp,sp,-32
    80001c7e:	ec06                	sd	ra,24(sp)
    80001c80:	e822                	sd	s0,16(sp)
    80001c82:	e426                	sd	s1,8(sp)
    80001c84:	e04a                	sd	s2,0(sp)
    80001c86:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c88:	00010497          	auipc	s1,0x10
    80001c8c:	0e048493          	addi	s1,s1,224 # 80011d68 <proc>
    80001c90:	00016917          	auipc	s2,0x16
    80001c94:	ad890913          	addi	s2,s2,-1320 # 80017768 <tickslock>
    acquire(&p->lock);
    80001c98:	8526                	mv	a0,s1
    80001c9a:	fffff097          	auipc	ra,0xfffff
    80001c9e:	fc8080e7          	jalr	-56(ra) # 80000c62 <acquire>
    if(p->state == UNUSED) {
    80001ca2:	4c9c                	lw	a5,24(s1)
    80001ca4:	cf81                	beqz	a5,80001cbc <allocproc+0x40>
      release(&p->lock);
    80001ca6:	8526                	mv	a0,s1
    80001ca8:	fffff097          	auipc	ra,0xfffff
    80001cac:	06e080e7          	jalr	110(ra) # 80000d16 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cb0:	16848493          	addi	s1,s1,360
    80001cb4:	ff2492e3          	bne	s1,s2,80001c98 <allocproc+0x1c>
  return 0;
    80001cb8:	4481                	li	s1,0
    80001cba:	a0b9                	j	80001d08 <allocproc+0x8c>
  p->pid = allocpid();
    80001cbc:	00000097          	auipc	ra,0x0
    80001cc0:	e34080e7          	jalr	-460(ra) # 80001af0 <allocpid>
    80001cc4:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001cc6:	fffff097          	auipc	ra,0xfffff
    80001cca:	eac080e7          	jalr	-340(ra) # 80000b72 <kalloc>
    80001cce:	892a                	mv	s2,a0
    80001cd0:	eca8                	sd	a0,88(s1)
    80001cd2:	c131                	beqz	a0,80001d16 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	e60080e7          	jalr	-416(ra) # 80001b36 <proc_pagetable>
    80001cde:	892a                	mv	s2,a0
    80001ce0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001ce2:	c129                	beqz	a0,80001d24 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001ce4:	07000613          	li	a2,112
    80001ce8:	4581                	li	a1,0
    80001cea:	06048513          	addi	a0,s1,96
    80001cee:	fffff097          	auipc	ra,0xfffff
    80001cf2:	070080e7          	jalr	112(ra) # 80000d5e <memset>
  p->context.ra = (uint64)forkret;
    80001cf6:	00000797          	auipc	a5,0x0
    80001cfa:	db278793          	addi	a5,a5,-590 # 80001aa8 <forkret>
    80001cfe:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d00:	60bc                	ld	a5,64(s1)
    80001d02:	6705                	lui	a4,0x1
    80001d04:	97ba                	add	a5,a5,a4
    80001d06:	f4bc                	sd	a5,104(s1)
}
    80001d08:	8526                	mv	a0,s1
    80001d0a:	60e2                	ld	ra,24(sp)
    80001d0c:	6442                	ld	s0,16(sp)
    80001d0e:	64a2                	ld	s1,8(sp)
    80001d10:	6902                	ld	s2,0(sp)
    80001d12:	6105                	addi	sp,sp,32
    80001d14:	8082                	ret
    release(&p->lock);
    80001d16:	8526                	mv	a0,s1
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	ffe080e7          	jalr	-2(ra) # 80000d16 <release>
    return 0;
    80001d20:	84ca                	mv	s1,s2
    80001d22:	b7dd                	j	80001d08 <allocproc+0x8c>
    freeproc(p);
    80001d24:	8526                	mv	a0,s1
    80001d26:	00000097          	auipc	ra,0x0
    80001d2a:	efe080e7          	jalr	-258(ra) # 80001c24 <freeproc>
    release(&p->lock);
    80001d2e:	8526                	mv	a0,s1
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	fe6080e7          	jalr	-26(ra) # 80000d16 <release>
    return 0;
    80001d38:	84ca                	mv	s1,s2
    80001d3a:	b7f9                	j	80001d08 <allocproc+0x8c>

0000000080001d3c <userinit>:
{
    80001d3c:	1101                	addi	sp,sp,-32
    80001d3e:	ec06                	sd	ra,24(sp)
    80001d40:	e822                	sd	s0,16(sp)
    80001d42:	e426                	sd	s1,8(sp)
    80001d44:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	f36080e7          	jalr	-202(ra) # 80001c7c <allocproc>
    80001d4e:	84aa                	mv	s1,a0
  initproc = p;
    80001d50:	00007797          	auipc	a5,0x7
    80001d54:	2ca7b423          	sd	a0,712(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d58:	03400613          	li	a2,52
    80001d5c:	00007597          	auipc	a1,0x7
    80001d60:	ac458593          	addi	a1,a1,-1340 # 80008820 <initcode>
    80001d64:	6928                	ld	a0,80(a0)
    80001d66:	fffff097          	auipc	ra,0xfffff
    80001d6a:	6de080e7          	jalr	1758(ra) # 80001444 <uvminit>
  p->sz = PGSIZE;
    80001d6e:	6785                	lui	a5,0x1
    80001d70:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d72:	6cb8                	ld	a4,88(s1)
    80001d74:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d78:	6cb8                	ld	a4,88(s1)
    80001d7a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d7c:	4641                	li	a2,16
    80001d7e:	00006597          	auipc	a1,0x6
    80001d82:	49258593          	addi	a1,a1,1170 # 80008210 <states.1722+0x48>
    80001d86:	15848513          	addi	a0,s1,344
    80001d8a:	fffff097          	auipc	ra,0xfffff
    80001d8e:	14c080e7          	jalr	332(ra) # 80000ed6 <safestrcpy>
  p->cwd = namei("/");
    80001d92:	00006517          	auipc	a0,0x6
    80001d96:	48e50513          	addi	a0,a0,1166 # 80008220 <states.1722+0x58>
    80001d9a:	00002097          	auipc	ra,0x2
    80001d9e:	11c080e7          	jalr	284(ra) # 80003eb6 <namei>
    80001da2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001da6:	4789                	li	a5,2
    80001da8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001daa:	8526                	mv	a0,s1
    80001dac:	fffff097          	auipc	ra,0xfffff
    80001db0:	f6a080e7          	jalr	-150(ra) # 80000d16 <release>
}
    80001db4:	60e2                	ld	ra,24(sp)
    80001db6:	6442                	ld	s0,16(sp)
    80001db8:	64a2                	ld	s1,8(sp)
    80001dba:	6105                	addi	sp,sp,32
    80001dbc:	8082                	ret

0000000080001dbe <growproc>:
{
    80001dbe:	1101                	addi	sp,sp,-32
    80001dc0:	ec06                	sd	ra,24(sp)
    80001dc2:	e822                	sd	s0,16(sp)
    80001dc4:	e426                	sd	s1,8(sp)
    80001dc6:	e04a                	sd	s2,0(sp)
    80001dc8:	1000                	addi	s0,sp,32
    80001dca:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	ca4080e7          	jalr	-860(ra) # 80001a70 <myproc>
    80001dd4:	892a                	mv	s2,a0
  sz = p->sz;
    80001dd6:	652c                	ld	a1,72(a0)
    80001dd8:	0005851b          	sext.w	a0,a1
  if(n > 0){
    80001ddc:	00904f63          	bgtz	s1,80001dfa <growproc+0x3c>
  } else if(n < 0){
    80001de0:	0204cd63          	bltz	s1,80001e1a <growproc+0x5c>
  p->sz = sz;
    80001de4:	1502                	slli	a0,a0,0x20
    80001de6:	9101                	srli	a0,a0,0x20
    80001de8:	04a93423          	sd	a0,72(s2)
  return 0;
    80001dec:	4501                	li	a0,0
}
    80001dee:	60e2                	ld	ra,24(sp)
    80001df0:	6442                	ld	s0,16(sp)
    80001df2:	64a2                	ld	s1,8(sp)
    80001df4:	6902                	ld	s2,0(sp)
    80001df6:	6105                	addi	sp,sp,32
    80001df8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001dfa:	00a4863b          	addw	a2,s1,a0
    80001dfe:	1602                	slli	a2,a2,0x20
    80001e00:	9201                	srli	a2,a2,0x20
    80001e02:	1582                	slli	a1,a1,0x20
    80001e04:	9181                	srli	a1,a1,0x20
    80001e06:	05093503          	ld	a0,80(s2)
    80001e0a:	fffff097          	auipc	ra,0xfffff
    80001e0e:	6f2080e7          	jalr	1778(ra) # 800014fc <uvmalloc>
    80001e12:	2501                	sext.w	a0,a0
    80001e14:	f961                	bnez	a0,80001de4 <growproc+0x26>
      return -1;
    80001e16:	557d                	li	a0,-1
    80001e18:	bfd9                	j	80001dee <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e1a:	00a4863b          	addw	a2,s1,a0
    80001e1e:	1602                	slli	a2,a2,0x20
    80001e20:	9201                	srli	a2,a2,0x20
    80001e22:	1582                	slli	a1,a1,0x20
    80001e24:	9181                	srli	a1,a1,0x20
    80001e26:	05093503          	ld	a0,80(s2)
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	68c080e7          	jalr	1676(ra) # 800014b6 <uvmdealloc>
    80001e32:	2501                	sext.w	a0,a0
    80001e34:	bf45                	j	80001de4 <growproc+0x26>

0000000080001e36 <fork>:
{
    80001e36:	7179                	addi	sp,sp,-48
    80001e38:	f406                	sd	ra,40(sp)
    80001e3a:	f022                	sd	s0,32(sp)
    80001e3c:	ec26                	sd	s1,24(sp)
    80001e3e:	e84a                	sd	s2,16(sp)
    80001e40:	e44e                	sd	s3,8(sp)
    80001e42:	e052                	sd	s4,0(sp)
    80001e44:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	c2a080e7          	jalr	-982(ra) # 80001a70 <myproc>
    80001e4e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001e50:	00000097          	auipc	ra,0x0
    80001e54:	e2c080e7          	jalr	-468(ra) # 80001c7c <allocproc>
    80001e58:	c175                	beqz	a0,80001f3c <fork+0x106>
    80001e5a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e5c:	04893603          	ld	a2,72(s2)
    80001e60:	692c                	ld	a1,80(a0)
    80001e62:	05093503          	ld	a0,80(s2)
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	7e2080e7          	jalr	2018(ra) # 80001648 <uvmcopy>
    80001e6e:	04054863          	bltz	a0,80001ebe <fork+0x88>
  np->sz = p->sz;
    80001e72:	04893783          	ld	a5,72(s2)
    80001e76:	04f9b423          	sd	a5,72(s3) # 4000048 <_entry-0x7bffffb8>
  np->parent = p;
    80001e7a:	0329b023          	sd	s2,32(s3)
  *(np->trapframe) = *(p->trapframe);
    80001e7e:	05893683          	ld	a3,88(s2)
    80001e82:	87b6                	mv	a5,a3
    80001e84:	0589b703          	ld	a4,88(s3)
    80001e88:	12068693          	addi	a3,a3,288
    80001e8c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e90:	6788                	ld	a0,8(a5)
    80001e92:	6b8c                	ld	a1,16(a5)
    80001e94:	6f90                	ld	a2,24(a5)
    80001e96:	01073023          	sd	a6,0(a4)
    80001e9a:	e708                	sd	a0,8(a4)
    80001e9c:	eb0c                	sd	a1,16(a4)
    80001e9e:	ef10                	sd	a2,24(a4)
    80001ea0:	02078793          	addi	a5,a5,32
    80001ea4:	02070713          	addi	a4,a4,32
    80001ea8:	fed792e3          	bne	a5,a3,80001e8c <fork+0x56>
  np->trapframe->a0 = 0;
    80001eac:	0589b783          	ld	a5,88(s3)
    80001eb0:	0607b823          	sd	zero,112(a5)
    80001eb4:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001eb8:	15000a13          	li	s4,336
    80001ebc:	a03d                	j	80001eea <fork+0xb4>
    freeproc(np);
    80001ebe:	854e                	mv	a0,s3
    80001ec0:	00000097          	auipc	ra,0x0
    80001ec4:	d64080e7          	jalr	-668(ra) # 80001c24 <freeproc>
    release(&np->lock);
    80001ec8:	854e                	mv	a0,s3
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	e4c080e7          	jalr	-436(ra) # 80000d16 <release>
    return -1;
    80001ed2:	54fd                	li	s1,-1
    80001ed4:	a899                	j	80001f2a <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ed6:	00002097          	auipc	ra,0x2
    80001eda:	69e080e7          	jalr	1694(ra) # 80004574 <filedup>
    80001ede:	009987b3          	add	a5,s3,s1
    80001ee2:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001ee4:	04a1                	addi	s1,s1,8
    80001ee6:	01448763          	beq	s1,s4,80001ef4 <fork+0xbe>
    if(p->ofile[i])
    80001eea:	009907b3          	add	a5,s2,s1
    80001eee:	6388                	ld	a0,0(a5)
    80001ef0:	f17d                	bnez	a0,80001ed6 <fork+0xa0>
    80001ef2:	bfcd                	j	80001ee4 <fork+0xae>
  np->cwd = idup(p->cwd);
    80001ef4:	15093503          	ld	a0,336(s2)
    80001ef8:	00001097          	auipc	ra,0x1
    80001efc:	7c6080e7          	jalr	1990(ra) # 800036be <idup>
    80001f00:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f04:	4641                	li	a2,16
    80001f06:	15890593          	addi	a1,s2,344
    80001f0a:	15898513          	addi	a0,s3,344
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	fc8080e7          	jalr	-56(ra) # 80000ed6 <safestrcpy>
  pid = np->pid;
    80001f16:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001f1a:	4789                	li	a5,2
    80001f1c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f20:	854e                	mv	a0,s3
    80001f22:	fffff097          	auipc	ra,0xfffff
    80001f26:	df4080e7          	jalr	-524(ra) # 80000d16 <release>
}
    80001f2a:	8526                	mv	a0,s1
    80001f2c:	70a2                	ld	ra,40(sp)
    80001f2e:	7402                	ld	s0,32(sp)
    80001f30:	64e2                	ld	s1,24(sp)
    80001f32:	6942                	ld	s2,16(sp)
    80001f34:	69a2                	ld	s3,8(sp)
    80001f36:	6a02                	ld	s4,0(sp)
    80001f38:	6145                	addi	sp,sp,48
    80001f3a:	8082                	ret
    return -1;
    80001f3c:	54fd                	li	s1,-1
    80001f3e:	b7f5                	j	80001f2a <fork+0xf4>

0000000080001f40 <reparent>:
{
    80001f40:	7179                	addi	sp,sp,-48
    80001f42:	f406                	sd	ra,40(sp)
    80001f44:	f022                	sd	s0,32(sp)
    80001f46:	ec26                	sd	s1,24(sp)
    80001f48:	e84a                	sd	s2,16(sp)
    80001f4a:	e44e                	sd	s3,8(sp)
    80001f4c:	e052                	sd	s4,0(sp)
    80001f4e:	1800                	addi	s0,sp,48
    80001f50:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f52:	00010497          	auipc	s1,0x10
    80001f56:	e1648493          	addi	s1,s1,-490 # 80011d68 <proc>
      pp->parent = initproc;
    80001f5a:	00007a17          	auipc	s4,0x7
    80001f5e:	0bea0a13          	addi	s4,s4,190 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f62:	00016917          	auipc	s2,0x16
    80001f66:	80690913          	addi	s2,s2,-2042 # 80017768 <tickslock>
    80001f6a:	a029                	j	80001f74 <reparent+0x34>
    80001f6c:	16848493          	addi	s1,s1,360
    80001f70:	03248363          	beq	s1,s2,80001f96 <reparent+0x56>
    if(pp->parent == p){
    80001f74:	709c                	ld	a5,32(s1)
    80001f76:	ff379be3          	bne	a5,s3,80001f6c <reparent+0x2c>
      acquire(&pp->lock);
    80001f7a:	8526                	mv	a0,s1
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	ce6080e7          	jalr	-794(ra) # 80000c62 <acquire>
      pp->parent = initproc;
    80001f84:	000a3783          	ld	a5,0(s4)
    80001f88:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001f8a:	8526                	mv	a0,s1
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	d8a080e7          	jalr	-630(ra) # 80000d16 <release>
    80001f94:	bfe1                	j	80001f6c <reparent+0x2c>
}
    80001f96:	70a2                	ld	ra,40(sp)
    80001f98:	7402                	ld	s0,32(sp)
    80001f9a:	64e2                	ld	s1,24(sp)
    80001f9c:	6942                	ld	s2,16(sp)
    80001f9e:	69a2                	ld	s3,8(sp)
    80001fa0:	6a02                	ld	s4,0(sp)
    80001fa2:	6145                	addi	sp,sp,48
    80001fa4:	8082                	ret

0000000080001fa6 <scheduler>:
{
    80001fa6:	715d                	addi	sp,sp,-80
    80001fa8:	e486                	sd	ra,72(sp)
    80001faa:	e0a2                	sd	s0,64(sp)
    80001fac:	fc26                	sd	s1,56(sp)
    80001fae:	f84a                	sd	s2,48(sp)
    80001fb0:	f44e                	sd	s3,40(sp)
    80001fb2:	f052                	sd	s4,32(sp)
    80001fb4:	ec56                	sd	s5,24(sp)
    80001fb6:	e85a                	sd	s6,16(sp)
    80001fb8:	e45e                	sd	s7,8(sp)
    80001fba:	e062                	sd	s8,0(sp)
    80001fbc:	0880                	addi	s0,sp,80
    80001fbe:	8792                	mv	a5,tp
  int id = r_tp();
    80001fc0:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001fc2:	00779b13          	slli	s6,a5,0x7
    80001fc6:	00010717          	auipc	a4,0x10
    80001fca:	98a70713          	addi	a4,a4,-1654 # 80011950 <pid_lock>
    80001fce:	975a                	add	a4,a4,s6
    80001fd0:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001fd4:	00010717          	auipc	a4,0x10
    80001fd8:	99c70713          	addi	a4,a4,-1636 # 80011970 <cpus+0x8>
    80001fdc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001fde:	4c0d                	li	s8,3
        c->proc = p;
    80001fe0:	079e                	slli	a5,a5,0x7
    80001fe2:	00010a17          	auipc	s4,0x10
    80001fe6:	96ea0a13          	addi	s4,s4,-1682 # 80011950 <pid_lock>
    80001fea:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fec:	00015997          	auipc	s3,0x15
    80001ff0:	77c98993          	addi	s3,s3,1916 # 80017768 <tickslock>
        found = 1;
    80001ff4:	4b85                	li	s7,1
    80001ff6:	a899                	j	8000204c <scheduler+0xa6>
        p->state = RUNNING;
    80001ff8:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001ffc:	009a3c23          	sd	s1,24(s4)
        swtch(&c->context, &p->context);
    80002000:	06048593          	addi	a1,s1,96
    80002004:	855a                	mv	a0,s6
    80002006:	00000097          	auipc	ra,0x0
    8000200a:	63e080e7          	jalr	1598(ra) # 80002644 <swtch>
        c->proc = 0;
    8000200e:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80002012:	8ade                	mv	s5,s7
      release(&p->lock);
    80002014:	8526                	mv	a0,s1
    80002016:	fffff097          	auipc	ra,0xfffff
    8000201a:	d00080e7          	jalr	-768(ra) # 80000d16 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000201e:	16848493          	addi	s1,s1,360
    80002022:	01348b63          	beq	s1,s3,80002038 <scheduler+0x92>
      acquire(&p->lock);
    80002026:	8526                	mv	a0,s1
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	c3a080e7          	jalr	-966(ra) # 80000c62 <acquire>
      if(p->state == RUNNABLE) {
    80002030:	4c9c                	lw	a5,24(s1)
    80002032:	ff2791e3          	bne	a5,s2,80002014 <scheduler+0x6e>
    80002036:	b7c9                	j	80001ff8 <scheduler+0x52>
    if(found == 0) {
    80002038:	000a9a63          	bnez	s5,8000204c <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000203c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002044:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002048:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000204c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002050:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002054:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002058:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000205a:	00010497          	auipc	s1,0x10
    8000205e:	d0e48493          	addi	s1,s1,-754 # 80011d68 <proc>
      if(p->state == RUNNABLE) {
    80002062:	4909                	li	s2,2
    80002064:	b7c9                	j	80002026 <scheduler+0x80>

0000000080002066 <sched>:
{
    80002066:	7179                	addi	sp,sp,-48
    80002068:	f406                	sd	ra,40(sp)
    8000206a:	f022                	sd	s0,32(sp)
    8000206c:	ec26                	sd	s1,24(sp)
    8000206e:	e84a                	sd	s2,16(sp)
    80002070:	e44e                	sd	s3,8(sp)
    80002072:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002074:	00000097          	auipc	ra,0x0
    80002078:	9fc080e7          	jalr	-1540(ra) # 80001a70 <myproc>
    8000207c:	892a                	mv	s2,a0
  if(!holding(&p->lock))
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	b6a080e7          	jalr	-1174(ra) # 80000be8 <holding>
    80002086:	cd25                	beqz	a0,800020fe <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002088:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000208a:	2781                	sext.w	a5,a5
    8000208c:	079e                	slli	a5,a5,0x7
    8000208e:	00010717          	auipc	a4,0x10
    80002092:	8c270713          	addi	a4,a4,-1854 # 80011950 <pid_lock>
    80002096:	97ba                	add	a5,a5,a4
    80002098:	0907a703          	lw	a4,144(a5)
    8000209c:	4785                	li	a5,1
    8000209e:	06f71863          	bne	a4,a5,8000210e <sched+0xa8>
  if(p->state == RUNNING)
    800020a2:	01892703          	lw	a4,24(s2)
    800020a6:	478d                	li	a5,3
    800020a8:	06f70b63          	beq	a4,a5,8000211e <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020ac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020b0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800020b2:	efb5                	bnez	a5,8000212e <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020b4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800020b6:	00010497          	auipc	s1,0x10
    800020ba:	89a48493          	addi	s1,s1,-1894 # 80011950 <pid_lock>
    800020be:	2781                	sext.w	a5,a5
    800020c0:	079e                	slli	a5,a5,0x7
    800020c2:	97a6                	add	a5,a5,s1
    800020c4:	0947a983          	lw	s3,148(a5)
    800020c8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800020ca:	2781                	sext.w	a5,a5
    800020cc:	079e                	slli	a5,a5,0x7
    800020ce:	00010597          	auipc	a1,0x10
    800020d2:	8a258593          	addi	a1,a1,-1886 # 80011970 <cpus+0x8>
    800020d6:	95be                	add	a1,a1,a5
    800020d8:	06090513          	addi	a0,s2,96
    800020dc:	00000097          	auipc	ra,0x0
    800020e0:	568080e7          	jalr	1384(ra) # 80002644 <swtch>
    800020e4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020e6:	2781                	sext.w	a5,a5
    800020e8:	079e                	slli	a5,a5,0x7
    800020ea:	97a6                	add	a5,a5,s1
    800020ec:	0937aa23          	sw	s3,148(a5)
}
    800020f0:	70a2                	ld	ra,40(sp)
    800020f2:	7402                	ld	s0,32(sp)
    800020f4:	64e2                	ld	s1,24(sp)
    800020f6:	6942                	ld	s2,16(sp)
    800020f8:	69a2                	ld	s3,8(sp)
    800020fa:	6145                	addi	sp,sp,48
    800020fc:	8082                	ret
    panic("sched p->lock");
    800020fe:	00006517          	auipc	a0,0x6
    80002102:	12a50513          	addi	a0,a0,298 # 80008228 <states.1722+0x60>
    80002106:	ffffe097          	auipc	ra,0xffffe
    8000210a:	46e080e7          	jalr	1134(ra) # 80000574 <panic>
    panic("sched locks");
    8000210e:	00006517          	auipc	a0,0x6
    80002112:	12a50513          	addi	a0,a0,298 # 80008238 <states.1722+0x70>
    80002116:	ffffe097          	auipc	ra,0xffffe
    8000211a:	45e080e7          	jalr	1118(ra) # 80000574 <panic>
    panic("sched running");
    8000211e:	00006517          	auipc	a0,0x6
    80002122:	12a50513          	addi	a0,a0,298 # 80008248 <states.1722+0x80>
    80002126:	ffffe097          	auipc	ra,0xffffe
    8000212a:	44e080e7          	jalr	1102(ra) # 80000574 <panic>
    panic("sched interruptible");
    8000212e:	00006517          	auipc	a0,0x6
    80002132:	12a50513          	addi	a0,a0,298 # 80008258 <states.1722+0x90>
    80002136:	ffffe097          	auipc	ra,0xffffe
    8000213a:	43e080e7          	jalr	1086(ra) # 80000574 <panic>

000000008000213e <exit>:
{
    8000213e:	7179                	addi	sp,sp,-48
    80002140:	f406                	sd	ra,40(sp)
    80002142:	f022                	sd	s0,32(sp)
    80002144:	ec26                	sd	s1,24(sp)
    80002146:	e84a                	sd	s2,16(sp)
    80002148:	e44e                	sd	s3,8(sp)
    8000214a:	e052                	sd	s4,0(sp)
    8000214c:	1800                	addi	s0,sp,48
    8000214e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002150:	00000097          	auipc	ra,0x0
    80002154:	920080e7          	jalr	-1760(ra) # 80001a70 <myproc>
    80002158:	89aa                	mv	s3,a0
  if(p == initproc)
    8000215a:	00007797          	auipc	a5,0x7
    8000215e:	ebe78793          	addi	a5,a5,-322 # 80009018 <initproc>
    80002162:	639c                	ld	a5,0(a5)
    80002164:	0d050493          	addi	s1,a0,208
    80002168:	15050913          	addi	s2,a0,336
    8000216c:	02a79363          	bne	a5,a0,80002192 <exit+0x54>
    panic("init exiting");
    80002170:	00006517          	auipc	a0,0x6
    80002174:	10050513          	addi	a0,a0,256 # 80008270 <states.1722+0xa8>
    80002178:	ffffe097          	auipc	ra,0xffffe
    8000217c:	3fc080e7          	jalr	1020(ra) # 80000574 <panic>
      fileclose(f);
    80002180:	00002097          	auipc	ra,0x2
    80002184:	446080e7          	jalr	1094(ra) # 800045c6 <fileclose>
      p->ofile[fd] = 0;
    80002188:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000218c:	04a1                	addi	s1,s1,8
    8000218e:	01248563          	beq	s1,s2,80002198 <exit+0x5a>
    if(p->ofile[fd]){
    80002192:	6088                	ld	a0,0(s1)
    80002194:	f575                	bnez	a0,80002180 <exit+0x42>
    80002196:	bfdd                	j	8000218c <exit+0x4e>
  begin_op();
    80002198:	00002097          	auipc	ra,0x2
    8000219c:	f2c080e7          	jalr	-212(ra) # 800040c4 <begin_op>
  iput(p->cwd);
    800021a0:	1509b503          	ld	a0,336(s3)
    800021a4:	00001097          	auipc	ra,0x1
    800021a8:	714080e7          	jalr	1812(ra) # 800038b8 <iput>
  end_op();
    800021ac:	00002097          	auipc	ra,0x2
    800021b0:	f98080e7          	jalr	-104(ra) # 80004144 <end_op>
  p->cwd = 0;
    800021b4:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    800021b8:	00007497          	auipc	s1,0x7
    800021bc:	e6048493          	addi	s1,s1,-416 # 80009018 <initproc>
    800021c0:	6088                	ld	a0,0(s1)
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	aa0080e7          	jalr	-1376(ra) # 80000c62 <acquire>
  wakeup1(initproc);
    800021ca:	6088                	ld	a0,0(s1)
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	764080e7          	jalr	1892(ra) # 80001930 <wakeup1>
  release(&initproc->lock);
    800021d4:	6088                	ld	a0,0(s1)
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	b40080e7          	jalr	-1216(ra) # 80000d16 <release>
  acquire(&p->lock);
    800021de:	854e                	mv	a0,s3
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	a82080e7          	jalr	-1406(ra) # 80000c62 <acquire>
  struct proc *original_parent = p->parent;
    800021e8:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    800021ec:	854e                	mv	a0,s3
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	b28080e7          	jalr	-1240(ra) # 80000d16 <release>
  acquire(&original_parent->lock);
    800021f6:	8526                	mv	a0,s1
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	a6a080e7          	jalr	-1430(ra) # 80000c62 <acquire>
  acquire(&p->lock);
    80002200:	854e                	mv	a0,s3
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	a60080e7          	jalr	-1440(ra) # 80000c62 <acquire>
  reparent(p);
    8000220a:	854e                	mv	a0,s3
    8000220c:	00000097          	auipc	ra,0x0
    80002210:	d34080e7          	jalr	-716(ra) # 80001f40 <reparent>
  wakeup1(original_parent);
    80002214:	8526                	mv	a0,s1
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	71a080e7          	jalr	1818(ra) # 80001930 <wakeup1>
  p->xstate = status;
    8000221e:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002222:	4791                	li	a5,4
    80002224:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002228:	8526                	mv	a0,s1
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	aec080e7          	jalr	-1300(ra) # 80000d16 <release>
  sched();
    80002232:	00000097          	auipc	ra,0x0
    80002236:	e34080e7          	jalr	-460(ra) # 80002066 <sched>
  panic("zombie exit");
    8000223a:	00006517          	auipc	a0,0x6
    8000223e:	04650513          	addi	a0,a0,70 # 80008280 <states.1722+0xb8>
    80002242:	ffffe097          	auipc	ra,0xffffe
    80002246:	332080e7          	jalr	818(ra) # 80000574 <panic>

000000008000224a <yield>:
{
    8000224a:	1101                	addi	sp,sp,-32
    8000224c:	ec06                	sd	ra,24(sp)
    8000224e:	e822                	sd	s0,16(sp)
    80002250:	e426                	sd	s1,8(sp)
    80002252:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002254:	00000097          	auipc	ra,0x0
    80002258:	81c080e7          	jalr	-2020(ra) # 80001a70 <myproc>
    8000225c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	a04080e7          	jalr	-1532(ra) # 80000c62 <acquire>
  p->state = RUNNABLE;
    80002266:	4789                	li	a5,2
    80002268:	cc9c                	sw	a5,24(s1)
  sched();
    8000226a:	00000097          	auipc	ra,0x0
    8000226e:	dfc080e7          	jalr	-516(ra) # 80002066 <sched>
  release(&p->lock);
    80002272:	8526                	mv	a0,s1
    80002274:	fffff097          	auipc	ra,0xfffff
    80002278:	aa2080e7          	jalr	-1374(ra) # 80000d16 <release>
}
    8000227c:	60e2                	ld	ra,24(sp)
    8000227e:	6442                	ld	s0,16(sp)
    80002280:	64a2                	ld	s1,8(sp)
    80002282:	6105                	addi	sp,sp,32
    80002284:	8082                	ret

0000000080002286 <sleep>:
{
    80002286:	7179                	addi	sp,sp,-48
    80002288:	f406                	sd	ra,40(sp)
    8000228a:	f022                	sd	s0,32(sp)
    8000228c:	ec26                	sd	s1,24(sp)
    8000228e:	e84a                	sd	s2,16(sp)
    80002290:	e44e                	sd	s3,8(sp)
    80002292:	1800                	addi	s0,sp,48
    80002294:	89aa                	mv	s3,a0
    80002296:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	7d8080e7          	jalr	2008(ra) # 80001a70 <myproc>
    800022a0:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800022a2:	05250663          	beq	a0,s2,800022ee <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	9bc080e7          	jalr	-1604(ra) # 80000c62 <acquire>
    release(lk);
    800022ae:	854a                	mv	a0,s2
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	a66080e7          	jalr	-1434(ra) # 80000d16 <release>
  p->chan = chan;
    800022b8:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800022bc:	4785                	li	a5,1
    800022be:	cc9c                	sw	a5,24(s1)
  sched();
    800022c0:	00000097          	auipc	ra,0x0
    800022c4:	da6080e7          	jalr	-602(ra) # 80002066 <sched>
  p->chan = 0;
    800022c8:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    800022cc:	8526                	mv	a0,s1
    800022ce:	fffff097          	auipc	ra,0xfffff
    800022d2:	a48080e7          	jalr	-1464(ra) # 80000d16 <release>
    acquire(lk);
    800022d6:	854a                	mv	a0,s2
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	98a080e7          	jalr	-1654(ra) # 80000c62 <acquire>
}
    800022e0:	70a2                	ld	ra,40(sp)
    800022e2:	7402                	ld	s0,32(sp)
    800022e4:	64e2                	ld	s1,24(sp)
    800022e6:	6942                	ld	s2,16(sp)
    800022e8:	69a2                	ld	s3,8(sp)
    800022ea:	6145                	addi	sp,sp,48
    800022ec:	8082                	ret
  p->chan = chan;
    800022ee:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    800022f2:	4785                	li	a5,1
    800022f4:	cd1c                	sw	a5,24(a0)
  sched();
    800022f6:	00000097          	auipc	ra,0x0
    800022fa:	d70080e7          	jalr	-656(ra) # 80002066 <sched>
  p->chan = 0;
    800022fe:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002302:	bff9                	j	800022e0 <sleep+0x5a>

0000000080002304 <wait>:
{
    80002304:	715d                	addi	sp,sp,-80
    80002306:	e486                	sd	ra,72(sp)
    80002308:	e0a2                	sd	s0,64(sp)
    8000230a:	fc26                	sd	s1,56(sp)
    8000230c:	f84a                	sd	s2,48(sp)
    8000230e:	f44e                	sd	s3,40(sp)
    80002310:	f052                	sd	s4,32(sp)
    80002312:	ec56                	sd	s5,24(sp)
    80002314:	e85a                	sd	s6,16(sp)
    80002316:	e45e                	sd	s7,8(sp)
    80002318:	e062                	sd	s8,0(sp)
    8000231a:	0880                	addi	s0,sp,80
    8000231c:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	752080e7          	jalr	1874(ra) # 80001a70 <myproc>
    80002326:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002328:	8c2a                	mv	s8,a0
    8000232a:	fffff097          	auipc	ra,0xfffff
    8000232e:	938080e7          	jalr	-1736(ra) # 80000c62 <acquire>
    havekids = 0;
    80002332:	4b01                	li	s6,0
        if(np->state == ZOMBIE){
    80002334:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    80002336:	00015997          	auipc	s3,0x15
    8000233a:	43298993          	addi	s3,s3,1074 # 80017768 <tickslock>
        havekids = 1;
    8000233e:	4a85                	li	s5,1
    havekids = 0;
    80002340:	875a                	mv	a4,s6
    for(np = proc; np < &proc[NPROC]; np++){
    80002342:	00010497          	auipc	s1,0x10
    80002346:	a2648493          	addi	s1,s1,-1498 # 80011d68 <proc>
    8000234a:	a08d                	j	800023ac <wait+0xa8>
          pid = np->pid;
    8000234c:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002350:	000b8e63          	beqz	s7,8000236c <wait+0x68>
    80002354:	4691                	li	a3,4
    80002356:	03448613          	addi	a2,s1,52
    8000235a:	85de                	mv	a1,s7
    8000235c:	05093503          	ld	a0,80(s2)
    80002360:	fffff097          	auipc	ra,0xfffff
    80002364:	3ec080e7          	jalr	1004(ra) # 8000174c <copyout>
    80002368:	02054263          	bltz	a0,8000238c <wait+0x88>
          freeproc(np);
    8000236c:	8526                	mv	a0,s1
    8000236e:	00000097          	auipc	ra,0x0
    80002372:	8b6080e7          	jalr	-1866(ra) # 80001c24 <freeproc>
          release(&np->lock);
    80002376:	8526                	mv	a0,s1
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	99e080e7          	jalr	-1634(ra) # 80000d16 <release>
          release(&p->lock);
    80002380:	854a                	mv	a0,s2
    80002382:	fffff097          	auipc	ra,0xfffff
    80002386:	994080e7          	jalr	-1644(ra) # 80000d16 <release>
          return pid;
    8000238a:	a8a9                	j	800023e4 <wait+0xe0>
            release(&np->lock);
    8000238c:	8526                	mv	a0,s1
    8000238e:	fffff097          	auipc	ra,0xfffff
    80002392:	988080e7          	jalr	-1656(ra) # 80000d16 <release>
            release(&p->lock);
    80002396:	854a                	mv	a0,s2
    80002398:	fffff097          	auipc	ra,0xfffff
    8000239c:	97e080e7          	jalr	-1666(ra) # 80000d16 <release>
            return -1;
    800023a0:	59fd                	li	s3,-1
    800023a2:	a089                	j	800023e4 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    800023a4:	16848493          	addi	s1,s1,360
    800023a8:	03348463          	beq	s1,s3,800023d0 <wait+0xcc>
      if(np->parent == p){
    800023ac:	709c                	ld	a5,32(s1)
    800023ae:	ff279be3          	bne	a5,s2,800023a4 <wait+0xa0>
        acquire(&np->lock);
    800023b2:	8526                	mv	a0,s1
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	8ae080e7          	jalr	-1874(ra) # 80000c62 <acquire>
        if(np->state == ZOMBIE){
    800023bc:	4c9c                	lw	a5,24(s1)
    800023be:	f94787e3          	beq	a5,s4,8000234c <wait+0x48>
        release(&np->lock);
    800023c2:	8526                	mv	a0,s1
    800023c4:	fffff097          	auipc	ra,0xfffff
    800023c8:	952080e7          	jalr	-1710(ra) # 80000d16 <release>
        havekids = 1;
    800023cc:	8756                	mv	a4,s5
    800023ce:	bfd9                	j	800023a4 <wait+0xa0>
    if(!havekids || p->killed){
    800023d0:	c701                	beqz	a4,800023d8 <wait+0xd4>
    800023d2:	03092783          	lw	a5,48(s2)
    800023d6:	c785                	beqz	a5,800023fe <wait+0xfa>
      release(&p->lock);
    800023d8:	854a                	mv	a0,s2
    800023da:	fffff097          	auipc	ra,0xfffff
    800023de:	93c080e7          	jalr	-1732(ra) # 80000d16 <release>
      return -1;
    800023e2:	59fd                	li	s3,-1
}
    800023e4:	854e                	mv	a0,s3
    800023e6:	60a6                	ld	ra,72(sp)
    800023e8:	6406                	ld	s0,64(sp)
    800023ea:	74e2                	ld	s1,56(sp)
    800023ec:	7942                	ld	s2,48(sp)
    800023ee:	79a2                	ld	s3,40(sp)
    800023f0:	7a02                	ld	s4,32(sp)
    800023f2:	6ae2                	ld	s5,24(sp)
    800023f4:	6b42                	ld	s6,16(sp)
    800023f6:	6ba2                	ld	s7,8(sp)
    800023f8:	6c02                	ld	s8,0(sp)
    800023fa:	6161                	addi	sp,sp,80
    800023fc:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800023fe:	85e2                	mv	a1,s8
    80002400:	854a                	mv	a0,s2
    80002402:	00000097          	auipc	ra,0x0
    80002406:	e84080e7          	jalr	-380(ra) # 80002286 <sleep>
    havekids = 0;
    8000240a:	bf1d                	j	80002340 <wait+0x3c>

000000008000240c <wakeup>:
{
    8000240c:	7139                	addi	sp,sp,-64
    8000240e:	fc06                	sd	ra,56(sp)
    80002410:	f822                	sd	s0,48(sp)
    80002412:	f426                	sd	s1,40(sp)
    80002414:	f04a                	sd	s2,32(sp)
    80002416:	ec4e                	sd	s3,24(sp)
    80002418:	e852                	sd	s4,16(sp)
    8000241a:	e456                	sd	s5,8(sp)
    8000241c:	0080                	addi	s0,sp,64
    8000241e:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002420:	00010497          	auipc	s1,0x10
    80002424:	94848493          	addi	s1,s1,-1720 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002428:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000242a:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000242c:	00015917          	auipc	s2,0x15
    80002430:	33c90913          	addi	s2,s2,828 # 80017768 <tickslock>
    80002434:	a821                	j	8000244c <wakeup+0x40>
      p->state = RUNNABLE;
    80002436:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    8000243a:	8526                	mv	a0,s1
    8000243c:	fffff097          	auipc	ra,0xfffff
    80002440:	8da080e7          	jalr	-1830(ra) # 80000d16 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002444:	16848493          	addi	s1,s1,360
    80002448:	01248e63          	beq	s1,s2,80002464 <wakeup+0x58>
    acquire(&p->lock);
    8000244c:	8526                	mv	a0,s1
    8000244e:	fffff097          	auipc	ra,0xfffff
    80002452:	814080e7          	jalr	-2028(ra) # 80000c62 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002456:	4c9c                	lw	a5,24(s1)
    80002458:	ff3791e3          	bne	a5,s3,8000243a <wakeup+0x2e>
    8000245c:	749c                	ld	a5,40(s1)
    8000245e:	fd479ee3          	bne	a5,s4,8000243a <wakeup+0x2e>
    80002462:	bfd1                	j	80002436 <wakeup+0x2a>
}
    80002464:	70e2                	ld	ra,56(sp)
    80002466:	7442                	ld	s0,48(sp)
    80002468:	74a2                	ld	s1,40(sp)
    8000246a:	7902                	ld	s2,32(sp)
    8000246c:	69e2                	ld	s3,24(sp)
    8000246e:	6a42                	ld	s4,16(sp)
    80002470:	6aa2                	ld	s5,8(sp)
    80002472:	6121                	addi	sp,sp,64
    80002474:	8082                	ret

0000000080002476 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002476:	7179                	addi	sp,sp,-48
    80002478:	f406                	sd	ra,40(sp)
    8000247a:	f022                	sd	s0,32(sp)
    8000247c:	ec26                	sd	s1,24(sp)
    8000247e:	e84a                	sd	s2,16(sp)
    80002480:	e44e                	sd	s3,8(sp)
    80002482:	1800                	addi	s0,sp,48
    80002484:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002486:	00010497          	auipc	s1,0x10
    8000248a:	8e248493          	addi	s1,s1,-1822 # 80011d68 <proc>
    8000248e:	00015997          	auipc	s3,0x15
    80002492:	2da98993          	addi	s3,s3,730 # 80017768 <tickslock>
    acquire(&p->lock);
    80002496:	8526                	mv	a0,s1
    80002498:	ffffe097          	auipc	ra,0xffffe
    8000249c:	7ca080e7          	jalr	1994(ra) # 80000c62 <acquire>
    if(p->pid == pid){
    800024a0:	5c9c                	lw	a5,56(s1)
    800024a2:	01278d63          	beq	a5,s2,800024bc <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800024a6:	8526                	mv	a0,s1
    800024a8:	fffff097          	auipc	ra,0xfffff
    800024ac:	86e080e7          	jalr	-1938(ra) # 80000d16 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800024b0:	16848493          	addi	s1,s1,360
    800024b4:	ff3491e3          	bne	s1,s3,80002496 <kill+0x20>
  }
  return -1;
    800024b8:	557d                	li	a0,-1
    800024ba:	a829                	j	800024d4 <kill+0x5e>
      p->killed = 1;
    800024bc:	4785                	li	a5,1
    800024be:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800024c0:	4c98                	lw	a4,24(s1)
    800024c2:	4785                	li	a5,1
    800024c4:	00f70f63          	beq	a4,a5,800024e2 <kill+0x6c>
      release(&p->lock);
    800024c8:	8526                	mv	a0,s1
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	84c080e7          	jalr	-1972(ra) # 80000d16 <release>
      return 0;
    800024d2:	4501                	li	a0,0
}
    800024d4:	70a2                	ld	ra,40(sp)
    800024d6:	7402                	ld	s0,32(sp)
    800024d8:	64e2                	ld	s1,24(sp)
    800024da:	6942                	ld	s2,16(sp)
    800024dc:	69a2                	ld	s3,8(sp)
    800024de:	6145                	addi	sp,sp,48
    800024e0:	8082                	ret
        p->state = RUNNABLE;
    800024e2:	4789                	li	a5,2
    800024e4:	cc9c                	sw	a5,24(s1)
    800024e6:	b7cd                	j	800024c8 <kill+0x52>

00000000800024e8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024e8:	7179                	addi	sp,sp,-48
    800024ea:	f406                	sd	ra,40(sp)
    800024ec:	f022                	sd	s0,32(sp)
    800024ee:	ec26                	sd	s1,24(sp)
    800024f0:	e84a                	sd	s2,16(sp)
    800024f2:	e44e                	sd	s3,8(sp)
    800024f4:	e052                	sd	s4,0(sp)
    800024f6:	1800                	addi	s0,sp,48
    800024f8:	84aa                	mv	s1,a0
    800024fa:	892e                	mv	s2,a1
    800024fc:	89b2                	mv	s3,a2
    800024fe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002500:	fffff097          	auipc	ra,0xfffff
    80002504:	570080e7          	jalr	1392(ra) # 80001a70 <myproc>
  if(user_dst){
    80002508:	c08d                	beqz	s1,8000252a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000250a:	86d2                	mv	a3,s4
    8000250c:	864e                	mv	a2,s3
    8000250e:	85ca                	mv	a1,s2
    80002510:	6928                	ld	a0,80(a0)
    80002512:	fffff097          	auipc	ra,0xfffff
    80002516:	23a080e7          	jalr	570(ra) # 8000174c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000251a:	70a2                	ld	ra,40(sp)
    8000251c:	7402                	ld	s0,32(sp)
    8000251e:	64e2                	ld	s1,24(sp)
    80002520:	6942                	ld	s2,16(sp)
    80002522:	69a2                	ld	s3,8(sp)
    80002524:	6a02                	ld	s4,0(sp)
    80002526:	6145                	addi	sp,sp,48
    80002528:	8082                	ret
    memmove((char *)dst, src, len);
    8000252a:	000a061b          	sext.w	a2,s4
    8000252e:	85ce                	mv	a1,s3
    80002530:	854a                	mv	a0,s2
    80002532:	fffff097          	auipc	ra,0xfffff
    80002536:	898080e7          	jalr	-1896(ra) # 80000dca <memmove>
    return 0;
    8000253a:	8526                	mv	a0,s1
    8000253c:	bff9                	j	8000251a <either_copyout+0x32>

000000008000253e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000253e:	7179                	addi	sp,sp,-48
    80002540:	f406                	sd	ra,40(sp)
    80002542:	f022                	sd	s0,32(sp)
    80002544:	ec26                	sd	s1,24(sp)
    80002546:	e84a                	sd	s2,16(sp)
    80002548:	e44e                	sd	s3,8(sp)
    8000254a:	e052                	sd	s4,0(sp)
    8000254c:	1800                	addi	s0,sp,48
    8000254e:	892a                	mv	s2,a0
    80002550:	84ae                	mv	s1,a1
    80002552:	89b2                	mv	s3,a2
    80002554:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002556:	fffff097          	auipc	ra,0xfffff
    8000255a:	51a080e7          	jalr	1306(ra) # 80001a70 <myproc>
  if(user_src){
    8000255e:	c08d                	beqz	s1,80002580 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002560:	86d2                	mv	a3,s4
    80002562:	864e                	mv	a2,s3
    80002564:	85ca                	mv	a1,s2
    80002566:	6928                	ld	a0,80(a0)
    80002568:	fffff097          	auipc	ra,0xfffff
    8000256c:	270080e7          	jalr	624(ra) # 800017d8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002570:	70a2                	ld	ra,40(sp)
    80002572:	7402                	ld	s0,32(sp)
    80002574:	64e2                	ld	s1,24(sp)
    80002576:	6942                	ld	s2,16(sp)
    80002578:	69a2                	ld	s3,8(sp)
    8000257a:	6a02                	ld	s4,0(sp)
    8000257c:	6145                	addi	sp,sp,48
    8000257e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002580:	000a061b          	sext.w	a2,s4
    80002584:	85ce                	mv	a1,s3
    80002586:	854a                	mv	a0,s2
    80002588:	fffff097          	auipc	ra,0xfffff
    8000258c:	842080e7          	jalr	-1982(ra) # 80000dca <memmove>
    return 0;
    80002590:	8526                	mv	a0,s1
    80002592:	bff9                	j	80002570 <either_copyin+0x32>

0000000080002594 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002594:	715d                	addi	sp,sp,-80
    80002596:	e486                	sd	ra,72(sp)
    80002598:	e0a2                	sd	s0,64(sp)
    8000259a:	fc26                	sd	s1,56(sp)
    8000259c:	f84a                	sd	s2,48(sp)
    8000259e:	f44e                	sd	s3,40(sp)
    800025a0:	f052                	sd	s4,32(sp)
    800025a2:	ec56                	sd	s5,24(sp)
    800025a4:	e85a                	sd	s6,16(sp)
    800025a6:	e45e                	sd	s7,8(sp)
    800025a8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025aa:	00006517          	auipc	a0,0x6
    800025ae:	b1e50513          	addi	a0,a0,-1250 # 800080c8 <digits+0xb0>
    800025b2:	ffffe097          	auipc	ra,0xffffe
    800025b6:	00c080e7          	jalr	12(ra) # 800005be <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025ba:	00010497          	auipc	s1,0x10
    800025be:	90648493          	addi	s1,s1,-1786 # 80011ec0 <proc+0x158>
    800025c2:	00015917          	auipc	s2,0x15
    800025c6:	2fe90913          	addi	s2,s2,766 # 800178c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025ca:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    800025cc:	00006997          	auipc	s3,0x6
    800025d0:	cc498993          	addi	s3,s3,-828 # 80008290 <states.1722+0xc8>
    printf("%d %s %s", p->pid, state, p->name);
    800025d4:	00006a97          	auipc	s5,0x6
    800025d8:	cc4a8a93          	addi	s5,s5,-828 # 80008298 <states.1722+0xd0>
    printf("\n");
    800025dc:	00006a17          	auipc	s4,0x6
    800025e0:	aeca0a13          	addi	s4,s4,-1300 # 800080c8 <digits+0xb0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025e4:	00006b97          	auipc	s7,0x6
    800025e8:	be4b8b93          	addi	s7,s7,-1052 # 800081c8 <states.1722>
    800025ec:	a015                	j	80002610 <procdump+0x7c>
    printf("%d %s %s", p->pid, state, p->name);
    800025ee:	86ba                	mv	a3,a4
    800025f0:	ee072583          	lw	a1,-288(a4)
    800025f4:	8556                	mv	a0,s5
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	fc8080e7          	jalr	-56(ra) # 800005be <printf>
    printf("\n");
    800025fe:	8552                	mv	a0,s4
    80002600:	ffffe097          	auipc	ra,0xffffe
    80002604:	fbe080e7          	jalr	-66(ra) # 800005be <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002608:	16848493          	addi	s1,s1,360
    8000260c:	03248163          	beq	s1,s2,8000262e <procdump+0x9a>
    if(p->state == UNUSED)
    80002610:	8726                	mv	a4,s1
    80002612:	ec04a783          	lw	a5,-320(s1)
    80002616:	dbed                	beqz	a5,80002608 <procdump+0x74>
      state = "???";
    80002618:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000261a:	fcfb6ae3          	bltu	s6,a5,800025ee <procdump+0x5a>
    8000261e:	1782                	slli	a5,a5,0x20
    80002620:	9381                	srli	a5,a5,0x20
    80002622:	078e                	slli	a5,a5,0x3
    80002624:	97de                	add	a5,a5,s7
    80002626:	6390                	ld	a2,0(a5)
    80002628:	f279                	bnez	a2,800025ee <procdump+0x5a>
      state = "???";
    8000262a:	864e                	mv	a2,s3
    8000262c:	b7c9                	j	800025ee <procdump+0x5a>
  }
}
    8000262e:	60a6                	ld	ra,72(sp)
    80002630:	6406                	ld	s0,64(sp)
    80002632:	74e2                	ld	s1,56(sp)
    80002634:	7942                	ld	s2,48(sp)
    80002636:	79a2                	ld	s3,40(sp)
    80002638:	7a02                	ld	s4,32(sp)
    8000263a:	6ae2                	ld	s5,24(sp)
    8000263c:	6b42                	ld	s6,16(sp)
    8000263e:	6ba2                	ld	s7,8(sp)
    80002640:	6161                	addi	sp,sp,80
    80002642:	8082                	ret

0000000080002644 <swtch>:
    80002644:	00153023          	sd	ra,0(a0)
    80002648:	00253423          	sd	sp,8(a0)
    8000264c:	e900                	sd	s0,16(a0)
    8000264e:	ed04                	sd	s1,24(a0)
    80002650:	03253023          	sd	s2,32(a0)
    80002654:	03353423          	sd	s3,40(a0)
    80002658:	03453823          	sd	s4,48(a0)
    8000265c:	03553c23          	sd	s5,56(a0)
    80002660:	05653023          	sd	s6,64(a0)
    80002664:	05753423          	sd	s7,72(a0)
    80002668:	05853823          	sd	s8,80(a0)
    8000266c:	05953c23          	sd	s9,88(a0)
    80002670:	07a53023          	sd	s10,96(a0)
    80002674:	07b53423          	sd	s11,104(a0)
    80002678:	0005b083          	ld	ra,0(a1)
    8000267c:	0085b103          	ld	sp,8(a1)
    80002680:	6980                	ld	s0,16(a1)
    80002682:	6d84                	ld	s1,24(a1)
    80002684:	0205b903          	ld	s2,32(a1)
    80002688:	0285b983          	ld	s3,40(a1)
    8000268c:	0305ba03          	ld	s4,48(a1)
    80002690:	0385ba83          	ld	s5,56(a1)
    80002694:	0405bb03          	ld	s6,64(a1)
    80002698:	0485bb83          	ld	s7,72(a1)
    8000269c:	0505bc03          	ld	s8,80(a1)
    800026a0:	0585bc83          	ld	s9,88(a1)
    800026a4:	0605bd03          	ld	s10,96(a1)
    800026a8:	0685bd83          	ld	s11,104(a1)
    800026ac:	8082                	ret

00000000800026ae <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800026ae:	1141                	addi	sp,sp,-16
    800026b0:	e406                	sd	ra,8(sp)
    800026b2:	e022                	sd	s0,0(sp)
    800026b4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800026b6:	00006597          	auipc	a1,0x6
    800026ba:	c1a58593          	addi	a1,a1,-998 # 800082d0 <states.1722+0x108>
    800026be:	00015517          	auipc	a0,0x15
    800026c2:	0aa50513          	addi	a0,a0,170 # 80017768 <tickslock>
    800026c6:	ffffe097          	auipc	ra,0xffffe
    800026ca:	50c080e7          	jalr	1292(ra) # 80000bd2 <initlock>
}
    800026ce:	60a2                	ld	ra,8(sp)
    800026d0:	6402                	ld	s0,0(sp)
    800026d2:	0141                	addi	sp,sp,16
    800026d4:	8082                	ret

00000000800026d6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800026d6:	1141                	addi	sp,sp,-16
    800026d8:	e422                	sd	s0,8(sp)
    800026da:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026dc:	00003797          	auipc	a5,0x3
    800026e0:	5a478793          	addi	a5,a5,1444 # 80005c80 <kernelvec>
    800026e4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026e8:	6422                	ld	s0,8(sp)
    800026ea:	0141                	addi	sp,sp,16
    800026ec:	8082                	ret

00000000800026ee <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800026ee:	1141                	addi	sp,sp,-16
    800026f0:	e406                	sd	ra,8(sp)
    800026f2:	e022                	sd	s0,0(sp)
    800026f4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800026f6:	fffff097          	auipc	ra,0xfffff
    800026fa:	37a080e7          	jalr	890(ra) # 80001a70 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002702:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002704:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002708:	00005617          	auipc	a2,0x5
    8000270c:	8f860613          	addi	a2,a2,-1800 # 80007000 <_trampoline>
    80002710:	00005697          	auipc	a3,0x5
    80002714:	8f068693          	addi	a3,a3,-1808 # 80007000 <_trampoline>
    80002718:	8e91                	sub	a3,a3,a2
    8000271a:	040007b7          	lui	a5,0x4000
    8000271e:	17fd                	addi	a5,a5,-1
    80002720:	07b2                	slli	a5,a5,0xc
    80002722:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002724:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002728:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000272a:	180026f3          	csrr	a3,satp
    8000272e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002730:	6d38                	ld	a4,88(a0)
    80002732:	6134                	ld	a3,64(a0)
    80002734:	6585                	lui	a1,0x1
    80002736:	96ae                	add	a3,a3,a1
    80002738:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000273a:	6d38                	ld	a4,88(a0)
    8000273c:	00000697          	auipc	a3,0x0
    80002740:	13868693          	addi	a3,a3,312 # 80002874 <usertrap>
    80002744:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002746:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002748:	8692                	mv	a3,tp
    8000274a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000274c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002750:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002754:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002758:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000275c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000275e:	6f18                	ld	a4,24(a4)
    80002760:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002764:	692c                	ld	a1,80(a0)
    80002766:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002768:	00005717          	auipc	a4,0x5
    8000276c:	92870713          	addi	a4,a4,-1752 # 80007090 <userret>
    80002770:	8f11                	sub	a4,a4,a2
    80002772:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002774:	577d                	li	a4,-1
    80002776:	177e                	slli	a4,a4,0x3f
    80002778:	8dd9                	or	a1,a1,a4
    8000277a:	02000537          	lui	a0,0x2000
    8000277e:	157d                	addi	a0,a0,-1
    80002780:	0536                	slli	a0,a0,0xd
    80002782:	9782                	jalr	a5
}
    80002784:	60a2                	ld	ra,8(sp)
    80002786:	6402                	ld	s0,0(sp)
    80002788:	0141                	addi	sp,sp,16
    8000278a:	8082                	ret

000000008000278c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000278c:	1101                	addi	sp,sp,-32
    8000278e:	ec06                	sd	ra,24(sp)
    80002790:	e822                	sd	s0,16(sp)
    80002792:	e426                	sd	s1,8(sp)
    80002794:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002796:	00015497          	auipc	s1,0x15
    8000279a:	fd248493          	addi	s1,s1,-46 # 80017768 <tickslock>
    8000279e:	8526                	mv	a0,s1
    800027a0:	ffffe097          	auipc	ra,0xffffe
    800027a4:	4c2080e7          	jalr	1218(ra) # 80000c62 <acquire>
  ticks++;
    800027a8:	00007517          	auipc	a0,0x7
    800027ac:	87850513          	addi	a0,a0,-1928 # 80009020 <ticks>
    800027b0:	411c                	lw	a5,0(a0)
    800027b2:	2785                	addiw	a5,a5,1
    800027b4:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	c56080e7          	jalr	-938(ra) # 8000240c <wakeup>
  release(&tickslock);
    800027be:	8526                	mv	a0,s1
    800027c0:	ffffe097          	auipc	ra,0xffffe
    800027c4:	556080e7          	jalr	1366(ra) # 80000d16 <release>
}
    800027c8:	60e2                	ld	ra,24(sp)
    800027ca:	6442                	ld	s0,16(sp)
    800027cc:	64a2                	ld	s1,8(sp)
    800027ce:	6105                	addi	sp,sp,32
    800027d0:	8082                	ret

00000000800027d2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800027d2:	1101                	addi	sp,sp,-32
    800027d4:	ec06                	sd	ra,24(sp)
    800027d6:	e822                	sd	s0,16(sp)
    800027d8:	e426                	sd	s1,8(sp)
    800027da:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027dc:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800027e0:	00074d63          	bltz	a4,800027fa <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800027e4:	57fd                	li	a5,-1
    800027e6:	17fe                	slli	a5,a5,0x3f
    800027e8:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800027ea:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800027ec:	06f70363          	beq	a4,a5,80002852 <devintr+0x80>
  }
}
    800027f0:	60e2                	ld	ra,24(sp)
    800027f2:	6442                	ld	s0,16(sp)
    800027f4:	64a2                	ld	s1,8(sp)
    800027f6:	6105                	addi	sp,sp,32
    800027f8:	8082                	ret
     (scause & 0xff) == 9){
    800027fa:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800027fe:	46a5                	li	a3,9
    80002800:	fed792e3          	bne	a5,a3,800027e4 <devintr+0x12>
    int irq = plic_claim();
    80002804:	00003097          	auipc	ra,0x3
    80002808:	584080e7          	jalr	1412(ra) # 80005d88 <plic_claim>
    8000280c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000280e:	47a9                	li	a5,10
    80002810:	02f50763          	beq	a0,a5,8000283e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002814:	4785                	li	a5,1
    80002816:	02f50963          	beq	a0,a5,80002848 <devintr+0x76>
    return 1;
    8000281a:	4505                	li	a0,1
    } else if(irq){
    8000281c:	d8f1                	beqz	s1,800027f0 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000281e:	85a6                	mv	a1,s1
    80002820:	00006517          	auipc	a0,0x6
    80002824:	ab850513          	addi	a0,a0,-1352 # 800082d8 <states.1722+0x110>
    80002828:	ffffe097          	auipc	ra,0xffffe
    8000282c:	d96080e7          	jalr	-618(ra) # 800005be <printf>
      plic_complete(irq);
    80002830:	8526                	mv	a0,s1
    80002832:	00003097          	auipc	ra,0x3
    80002836:	57a080e7          	jalr	1402(ra) # 80005dac <plic_complete>
    return 1;
    8000283a:	4505                	li	a0,1
    8000283c:	bf55                	j	800027f0 <devintr+0x1e>
      uartintr();
    8000283e:	ffffe097          	auipc	ra,0xffffe
    80002842:	1e4080e7          	jalr	484(ra) # 80000a22 <uartintr>
    80002846:	b7ed                	j	80002830 <devintr+0x5e>
      virtio_disk_intr();
    80002848:	00004097          	auipc	ra,0x4
    8000284c:	a10080e7          	jalr	-1520(ra) # 80006258 <virtio_disk_intr>
    80002850:	b7c5                	j	80002830 <devintr+0x5e>
    if(cpuid() == 0){
    80002852:	fffff097          	auipc	ra,0xfffff
    80002856:	1f2080e7          	jalr	498(ra) # 80001a44 <cpuid>
    8000285a:	c901                	beqz	a0,8000286a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000285c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002860:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002862:	14479073          	csrw	sip,a5
    return 2;
    80002866:	4509                	li	a0,2
    80002868:	b761                	j	800027f0 <devintr+0x1e>
      clockintr();
    8000286a:	00000097          	auipc	ra,0x0
    8000286e:	f22080e7          	jalr	-222(ra) # 8000278c <clockintr>
    80002872:	b7ed                	j	8000285c <devintr+0x8a>

0000000080002874 <usertrap>:
{
    80002874:	1101                	addi	sp,sp,-32
    80002876:	ec06                	sd	ra,24(sp)
    80002878:	e822                	sd	s0,16(sp)
    8000287a:	e426                	sd	s1,8(sp)
    8000287c:	e04a                	sd	s2,0(sp)
    8000287e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002880:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002884:	1007f793          	andi	a5,a5,256
    80002888:	e3ad                	bnez	a5,800028ea <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000288a:	00003797          	auipc	a5,0x3
    8000288e:	3f678793          	addi	a5,a5,1014 # 80005c80 <kernelvec>
    80002892:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002896:	fffff097          	auipc	ra,0xfffff
    8000289a:	1da080e7          	jalr	474(ra) # 80001a70 <myproc>
    8000289e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028a0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028a2:	14102773          	csrr	a4,sepc
    800028a6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028a8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028ac:	47a1                	li	a5,8
    800028ae:	04f71c63          	bne	a4,a5,80002906 <usertrap+0x92>
    if(p->killed)
    800028b2:	591c                	lw	a5,48(a0)
    800028b4:	e3b9                	bnez	a5,800028fa <usertrap+0x86>
    p->trapframe->epc += 4;
    800028b6:	6cb8                	ld	a4,88(s1)
    800028b8:	6f1c                	ld	a5,24(a4)
    800028ba:	0791                	addi	a5,a5,4
    800028bc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028be:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028c2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028c6:	10079073          	csrw	sstatus,a5
    syscall();
    800028ca:	00000097          	auipc	ra,0x0
    800028ce:	2e6080e7          	jalr	742(ra) # 80002bb0 <syscall>
  if(p->killed)
    800028d2:	589c                	lw	a5,48(s1)
    800028d4:	ebc1                	bnez	a5,80002964 <usertrap+0xf0>
  usertrapret();
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	e18080e7          	jalr	-488(ra) # 800026ee <usertrapret>
}
    800028de:	60e2                	ld	ra,24(sp)
    800028e0:	6442                	ld	s0,16(sp)
    800028e2:	64a2                	ld	s1,8(sp)
    800028e4:	6902                	ld	s2,0(sp)
    800028e6:	6105                	addi	sp,sp,32
    800028e8:	8082                	ret
    panic("usertrap: not from user mode");
    800028ea:	00006517          	auipc	a0,0x6
    800028ee:	a0e50513          	addi	a0,a0,-1522 # 800082f8 <states.1722+0x130>
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	c82080e7          	jalr	-894(ra) # 80000574 <panic>
      exit(-1);
    800028fa:	557d                	li	a0,-1
    800028fc:	00000097          	auipc	ra,0x0
    80002900:	842080e7          	jalr	-1982(ra) # 8000213e <exit>
    80002904:	bf4d                	j	800028b6 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002906:	00000097          	auipc	ra,0x0
    8000290a:	ecc080e7          	jalr	-308(ra) # 800027d2 <devintr>
    8000290e:	892a                	mv	s2,a0
    80002910:	c501                	beqz	a0,80002918 <usertrap+0xa4>
  if(p->killed)
    80002912:	589c                	lw	a5,48(s1)
    80002914:	c3a1                	beqz	a5,80002954 <usertrap+0xe0>
    80002916:	a815                	j	8000294a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002918:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000291c:	5c90                	lw	a2,56(s1)
    8000291e:	00006517          	auipc	a0,0x6
    80002922:	9fa50513          	addi	a0,a0,-1542 # 80008318 <states.1722+0x150>
    80002926:	ffffe097          	auipc	ra,0xffffe
    8000292a:	c98080e7          	jalr	-872(ra) # 800005be <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000292e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002932:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002936:	00006517          	auipc	a0,0x6
    8000293a:	a1250513          	addi	a0,a0,-1518 # 80008348 <states.1722+0x180>
    8000293e:	ffffe097          	auipc	ra,0xffffe
    80002942:	c80080e7          	jalr	-896(ra) # 800005be <printf>
    p->killed = 1;
    80002946:	4785                	li	a5,1
    80002948:	d89c                	sw	a5,48(s1)
    exit(-1);
    8000294a:	557d                	li	a0,-1
    8000294c:	fffff097          	auipc	ra,0xfffff
    80002950:	7f2080e7          	jalr	2034(ra) # 8000213e <exit>
  if(which_dev == 2)
    80002954:	4789                	li	a5,2
    80002956:	f8f910e3          	bne	s2,a5,800028d6 <usertrap+0x62>
    yield();
    8000295a:	00000097          	auipc	ra,0x0
    8000295e:	8f0080e7          	jalr	-1808(ra) # 8000224a <yield>
    80002962:	bf95                	j	800028d6 <usertrap+0x62>
  int which_dev = 0;
    80002964:	4901                	li	s2,0
    80002966:	b7d5                	j	8000294a <usertrap+0xd6>

0000000080002968 <kerneltrap>:
{
    80002968:	7179                	addi	sp,sp,-48
    8000296a:	f406                	sd	ra,40(sp)
    8000296c:	f022                	sd	s0,32(sp)
    8000296e:	ec26                	sd	s1,24(sp)
    80002970:	e84a                	sd	s2,16(sp)
    80002972:	e44e                	sd	s3,8(sp)
    80002974:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002976:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000297a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000297e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002982:	1004f793          	andi	a5,s1,256
    80002986:	cb85                	beqz	a5,800029b6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002988:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000298c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000298e:	ef85                	bnez	a5,800029c6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002990:	00000097          	auipc	ra,0x0
    80002994:	e42080e7          	jalr	-446(ra) # 800027d2 <devintr>
    80002998:	cd1d                	beqz	a0,800029d6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000299a:	4789                	li	a5,2
    8000299c:	06f50a63          	beq	a0,a5,80002a10 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800029a0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029a4:	10049073          	csrw	sstatus,s1
}
    800029a8:	70a2                	ld	ra,40(sp)
    800029aa:	7402                	ld	s0,32(sp)
    800029ac:	64e2                	ld	s1,24(sp)
    800029ae:	6942                	ld	s2,16(sp)
    800029b0:	69a2                	ld	s3,8(sp)
    800029b2:	6145                	addi	sp,sp,48
    800029b4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800029b6:	00006517          	auipc	a0,0x6
    800029ba:	9b250513          	addi	a0,a0,-1614 # 80008368 <states.1722+0x1a0>
    800029be:	ffffe097          	auipc	ra,0xffffe
    800029c2:	bb6080e7          	jalr	-1098(ra) # 80000574 <panic>
    panic("kerneltrap: interrupts enabled");
    800029c6:	00006517          	auipc	a0,0x6
    800029ca:	9ca50513          	addi	a0,a0,-1590 # 80008390 <states.1722+0x1c8>
    800029ce:	ffffe097          	auipc	ra,0xffffe
    800029d2:	ba6080e7          	jalr	-1114(ra) # 80000574 <panic>
    printf("scause %p\n", scause);
    800029d6:	85ce                	mv	a1,s3
    800029d8:	00006517          	auipc	a0,0x6
    800029dc:	9d850513          	addi	a0,a0,-1576 # 800083b0 <states.1722+0x1e8>
    800029e0:	ffffe097          	auipc	ra,0xffffe
    800029e4:	bde080e7          	jalr	-1058(ra) # 800005be <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029e8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029ec:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029f0:	00006517          	auipc	a0,0x6
    800029f4:	9d050513          	addi	a0,a0,-1584 # 800083c0 <states.1722+0x1f8>
    800029f8:	ffffe097          	auipc	ra,0xffffe
    800029fc:	bc6080e7          	jalr	-1082(ra) # 800005be <printf>
    panic("kerneltrap");
    80002a00:	00006517          	auipc	a0,0x6
    80002a04:	9d850513          	addi	a0,a0,-1576 # 800083d8 <states.1722+0x210>
    80002a08:	ffffe097          	auipc	ra,0xffffe
    80002a0c:	b6c080e7          	jalr	-1172(ra) # 80000574 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a10:	fffff097          	auipc	ra,0xfffff
    80002a14:	060080e7          	jalr	96(ra) # 80001a70 <myproc>
    80002a18:	d541                	beqz	a0,800029a0 <kerneltrap+0x38>
    80002a1a:	fffff097          	auipc	ra,0xfffff
    80002a1e:	056080e7          	jalr	86(ra) # 80001a70 <myproc>
    80002a22:	4d18                	lw	a4,24(a0)
    80002a24:	478d                	li	a5,3
    80002a26:	f6f71de3          	bne	a4,a5,800029a0 <kerneltrap+0x38>
    yield();
    80002a2a:	00000097          	auipc	ra,0x0
    80002a2e:	820080e7          	jalr	-2016(ra) # 8000224a <yield>
    80002a32:	b7bd                	j	800029a0 <kerneltrap+0x38>

0000000080002a34 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a34:	1101                	addi	sp,sp,-32
    80002a36:	ec06                	sd	ra,24(sp)
    80002a38:	e822                	sd	s0,16(sp)
    80002a3a:	e426                	sd	s1,8(sp)
    80002a3c:	1000                	addi	s0,sp,32
    80002a3e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a40:	fffff097          	auipc	ra,0xfffff
    80002a44:	030080e7          	jalr	48(ra) # 80001a70 <myproc>
  switch (n) {
    80002a48:	4795                	li	a5,5
    80002a4a:	0497e363          	bltu	a5,s1,80002a90 <argraw+0x5c>
    80002a4e:	1482                	slli	s1,s1,0x20
    80002a50:	9081                	srli	s1,s1,0x20
    80002a52:	048a                	slli	s1,s1,0x2
    80002a54:	00006717          	auipc	a4,0x6
    80002a58:	99470713          	addi	a4,a4,-1644 # 800083e8 <states.1722+0x220>
    80002a5c:	94ba                	add	s1,s1,a4
    80002a5e:	409c                	lw	a5,0(s1)
    80002a60:	97ba                	add	a5,a5,a4
    80002a62:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a64:	6d3c                	ld	a5,88(a0)
    80002a66:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a68:	60e2                	ld	ra,24(sp)
    80002a6a:	6442                	ld	s0,16(sp)
    80002a6c:	64a2                	ld	s1,8(sp)
    80002a6e:	6105                	addi	sp,sp,32
    80002a70:	8082                	ret
    return p->trapframe->a1;
    80002a72:	6d3c                	ld	a5,88(a0)
    80002a74:	7fa8                	ld	a0,120(a5)
    80002a76:	bfcd                	j	80002a68 <argraw+0x34>
    return p->trapframe->a2;
    80002a78:	6d3c                	ld	a5,88(a0)
    80002a7a:	63c8                	ld	a0,128(a5)
    80002a7c:	b7f5                	j	80002a68 <argraw+0x34>
    return p->trapframe->a3;
    80002a7e:	6d3c                	ld	a5,88(a0)
    80002a80:	67c8                	ld	a0,136(a5)
    80002a82:	b7dd                	j	80002a68 <argraw+0x34>
    return p->trapframe->a4;
    80002a84:	6d3c                	ld	a5,88(a0)
    80002a86:	6bc8                	ld	a0,144(a5)
    80002a88:	b7c5                	j	80002a68 <argraw+0x34>
    return p->trapframe->a5;
    80002a8a:	6d3c                	ld	a5,88(a0)
    80002a8c:	6fc8                	ld	a0,152(a5)
    80002a8e:	bfe9                	j	80002a68 <argraw+0x34>
  panic("argraw");
    80002a90:	00006517          	auipc	a0,0x6
    80002a94:	a2050513          	addi	a0,a0,-1504 # 800084b0 <syscalls+0xb0>
    80002a98:	ffffe097          	auipc	ra,0xffffe
    80002a9c:	adc080e7          	jalr	-1316(ra) # 80000574 <panic>

0000000080002aa0 <fetchaddr>:
{
    80002aa0:	1101                	addi	sp,sp,-32
    80002aa2:	ec06                	sd	ra,24(sp)
    80002aa4:	e822                	sd	s0,16(sp)
    80002aa6:	e426                	sd	s1,8(sp)
    80002aa8:	e04a                	sd	s2,0(sp)
    80002aaa:	1000                	addi	s0,sp,32
    80002aac:	84aa                	mv	s1,a0
    80002aae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002ab0:	fffff097          	auipc	ra,0xfffff
    80002ab4:	fc0080e7          	jalr	-64(ra) # 80001a70 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002ab8:	653c                	ld	a5,72(a0)
    80002aba:	02f4f963          	bleu	a5,s1,80002aec <fetchaddr+0x4c>
    80002abe:	00848713          	addi	a4,s1,8
    80002ac2:	02e7e763          	bltu	a5,a4,80002af0 <fetchaddr+0x50>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ac6:	46a1                	li	a3,8
    80002ac8:	8626                	mv	a2,s1
    80002aca:	85ca                	mv	a1,s2
    80002acc:	6928                	ld	a0,80(a0)
    80002ace:	fffff097          	auipc	ra,0xfffff
    80002ad2:	d0a080e7          	jalr	-758(ra) # 800017d8 <copyin>
    80002ad6:	00a03533          	snez	a0,a0
    80002ada:	40a0053b          	negw	a0,a0
    80002ade:	2501                	sext.w	a0,a0
}
    80002ae0:	60e2                	ld	ra,24(sp)
    80002ae2:	6442                	ld	s0,16(sp)
    80002ae4:	64a2                	ld	s1,8(sp)
    80002ae6:	6902                	ld	s2,0(sp)
    80002ae8:	6105                	addi	sp,sp,32
    80002aea:	8082                	ret
    return -1;
    80002aec:	557d                	li	a0,-1
    80002aee:	bfcd                	j	80002ae0 <fetchaddr+0x40>
    80002af0:	557d                	li	a0,-1
    80002af2:	b7fd                	j	80002ae0 <fetchaddr+0x40>

0000000080002af4 <fetchstr>:
{
    80002af4:	7179                	addi	sp,sp,-48
    80002af6:	f406                	sd	ra,40(sp)
    80002af8:	f022                	sd	s0,32(sp)
    80002afa:	ec26                	sd	s1,24(sp)
    80002afc:	e84a                	sd	s2,16(sp)
    80002afe:	e44e                	sd	s3,8(sp)
    80002b00:	1800                	addi	s0,sp,48
    80002b02:	892a                	mv	s2,a0
    80002b04:	84ae                	mv	s1,a1
    80002b06:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b08:	fffff097          	auipc	ra,0xfffff
    80002b0c:	f68080e7          	jalr	-152(ra) # 80001a70 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002b10:	86ce                	mv	a3,s3
    80002b12:	864a                	mv	a2,s2
    80002b14:	85a6                	mv	a1,s1
    80002b16:	6928                	ld	a0,80(a0)
    80002b18:	fffff097          	auipc	ra,0xfffff
    80002b1c:	d4e080e7          	jalr	-690(ra) # 80001866 <copyinstr>
  if(err < 0)
    80002b20:	00054763          	bltz	a0,80002b2e <fetchstr+0x3a>
  return strlen(buf);
    80002b24:	8526                	mv	a0,s1
    80002b26:	ffffe097          	auipc	ra,0xffffe
    80002b2a:	3e2080e7          	jalr	994(ra) # 80000f08 <strlen>
}
    80002b2e:	70a2                	ld	ra,40(sp)
    80002b30:	7402                	ld	s0,32(sp)
    80002b32:	64e2                	ld	s1,24(sp)
    80002b34:	6942                	ld	s2,16(sp)
    80002b36:	69a2                	ld	s3,8(sp)
    80002b38:	6145                	addi	sp,sp,48
    80002b3a:	8082                	ret

0000000080002b3c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002b3c:	1101                	addi	sp,sp,-32
    80002b3e:	ec06                	sd	ra,24(sp)
    80002b40:	e822                	sd	s0,16(sp)
    80002b42:	e426                	sd	s1,8(sp)
    80002b44:	1000                	addi	s0,sp,32
    80002b46:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b48:	00000097          	auipc	ra,0x0
    80002b4c:	eec080e7          	jalr	-276(ra) # 80002a34 <argraw>
    80002b50:	c088                	sw	a0,0(s1)
  return 0;
}
    80002b52:	4501                	li	a0,0
    80002b54:	60e2                	ld	ra,24(sp)
    80002b56:	6442                	ld	s0,16(sp)
    80002b58:	64a2                	ld	s1,8(sp)
    80002b5a:	6105                	addi	sp,sp,32
    80002b5c:	8082                	ret

0000000080002b5e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002b5e:	1101                	addi	sp,sp,-32
    80002b60:	ec06                	sd	ra,24(sp)
    80002b62:	e822                	sd	s0,16(sp)
    80002b64:	e426                	sd	s1,8(sp)
    80002b66:	1000                	addi	s0,sp,32
    80002b68:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b6a:	00000097          	auipc	ra,0x0
    80002b6e:	eca080e7          	jalr	-310(ra) # 80002a34 <argraw>
    80002b72:	e088                	sd	a0,0(s1)
  return 0;
}
    80002b74:	4501                	li	a0,0
    80002b76:	60e2                	ld	ra,24(sp)
    80002b78:	6442                	ld	s0,16(sp)
    80002b7a:	64a2                	ld	s1,8(sp)
    80002b7c:	6105                	addi	sp,sp,32
    80002b7e:	8082                	ret

0000000080002b80 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b80:	1101                	addi	sp,sp,-32
    80002b82:	ec06                	sd	ra,24(sp)
    80002b84:	e822                	sd	s0,16(sp)
    80002b86:	e426                	sd	s1,8(sp)
    80002b88:	e04a                	sd	s2,0(sp)
    80002b8a:	1000                	addi	s0,sp,32
    80002b8c:	84ae                	mv	s1,a1
    80002b8e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002b90:	00000097          	auipc	ra,0x0
    80002b94:	ea4080e7          	jalr	-348(ra) # 80002a34 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002b98:	864a                	mv	a2,s2
    80002b9a:	85a6                	mv	a1,s1
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	f58080e7          	jalr	-168(ra) # 80002af4 <fetchstr>
}
    80002ba4:	60e2                	ld	ra,24(sp)
    80002ba6:	6442                	ld	s0,16(sp)
    80002ba8:	64a2                	ld	s1,8(sp)
    80002baa:	6902                	ld	s2,0(sp)
    80002bac:	6105                	addi	sp,sp,32
    80002bae:	8082                	ret

0000000080002bb0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002bb0:	1101                	addi	sp,sp,-32
    80002bb2:	ec06                	sd	ra,24(sp)
    80002bb4:	e822                	sd	s0,16(sp)
    80002bb6:	e426                	sd	s1,8(sp)
    80002bb8:	e04a                	sd	s2,0(sp)
    80002bba:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002bbc:	fffff097          	auipc	ra,0xfffff
    80002bc0:	eb4080e7          	jalr	-332(ra) # 80001a70 <myproc>
    80002bc4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002bc6:	05853903          	ld	s2,88(a0)
    80002bca:	0a893783          	ld	a5,168(s2)
    80002bce:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002bd2:	37fd                	addiw	a5,a5,-1
    80002bd4:	4751                	li	a4,20
    80002bd6:	00f76f63          	bltu	a4,a5,80002bf4 <syscall+0x44>
    80002bda:	00369713          	slli	a4,a3,0x3
    80002bde:	00006797          	auipc	a5,0x6
    80002be2:	82278793          	addi	a5,a5,-2014 # 80008400 <syscalls>
    80002be6:	97ba                	add	a5,a5,a4
    80002be8:	639c                	ld	a5,0(a5)
    80002bea:	c789                	beqz	a5,80002bf4 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002bec:	9782                	jalr	a5
    80002bee:	06a93823          	sd	a0,112(s2)
    80002bf2:	a839                	j	80002c10 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002bf4:	15848613          	addi	a2,s1,344
    80002bf8:	5c8c                	lw	a1,56(s1)
    80002bfa:	00006517          	auipc	a0,0x6
    80002bfe:	8be50513          	addi	a0,a0,-1858 # 800084b8 <syscalls+0xb8>
    80002c02:	ffffe097          	auipc	ra,0xffffe
    80002c06:	9bc080e7          	jalr	-1604(ra) # 800005be <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c0a:	6cbc                	ld	a5,88(s1)
    80002c0c:	577d                	li	a4,-1
    80002c0e:	fbb8                	sd	a4,112(a5)
  }
}
    80002c10:	60e2                	ld	ra,24(sp)
    80002c12:	6442                	ld	s0,16(sp)
    80002c14:	64a2                	ld	s1,8(sp)
    80002c16:	6902                	ld	s2,0(sp)
    80002c18:	6105                	addi	sp,sp,32
    80002c1a:	8082                	ret

0000000080002c1c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c1c:	1101                	addi	sp,sp,-32
    80002c1e:	ec06                	sd	ra,24(sp)
    80002c20:	e822                	sd	s0,16(sp)
    80002c22:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002c24:	fec40593          	addi	a1,s0,-20
    80002c28:	4501                	li	a0,0
    80002c2a:	00000097          	auipc	ra,0x0
    80002c2e:	f12080e7          	jalr	-238(ra) # 80002b3c <argint>
    return -1;
    80002c32:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c34:	00054963          	bltz	a0,80002c46 <sys_exit+0x2a>
  exit(n);
    80002c38:	fec42503          	lw	a0,-20(s0)
    80002c3c:	fffff097          	auipc	ra,0xfffff
    80002c40:	502080e7          	jalr	1282(ra) # 8000213e <exit>
  return 0;  // not reached
    80002c44:	4781                	li	a5,0
}
    80002c46:	853e                	mv	a0,a5
    80002c48:	60e2                	ld	ra,24(sp)
    80002c4a:	6442                	ld	s0,16(sp)
    80002c4c:	6105                	addi	sp,sp,32
    80002c4e:	8082                	ret

0000000080002c50 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c50:	1141                	addi	sp,sp,-16
    80002c52:	e406                	sd	ra,8(sp)
    80002c54:	e022                	sd	s0,0(sp)
    80002c56:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c58:	fffff097          	auipc	ra,0xfffff
    80002c5c:	e18080e7          	jalr	-488(ra) # 80001a70 <myproc>
}
    80002c60:	5d08                	lw	a0,56(a0)
    80002c62:	60a2                	ld	ra,8(sp)
    80002c64:	6402                	ld	s0,0(sp)
    80002c66:	0141                	addi	sp,sp,16
    80002c68:	8082                	ret

0000000080002c6a <sys_fork>:

uint64
sys_fork(void)
{
    80002c6a:	1141                	addi	sp,sp,-16
    80002c6c:	e406                	sd	ra,8(sp)
    80002c6e:	e022                	sd	s0,0(sp)
    80002c70:	0800                	addi	s0,sp,16
  return fork();
    80002c72:	fffff097          	auipc	ra,0xfffff
    80002c76:	1c4080e7          	jalr	452(ra) # 80001e36 <fork>
}
    80002c7a:	60a2                	ld	ra,8(sp)
    80002c7c:	6402                	ld	s0,0(sp)
    80002c7e:	0141                	addi	sp,sp,16
    80002c80:	8082                	ret

0000000080002c82 <sys_wait>:

uint64
sys_wait(void)
{
    80002c82:	1101                	addi	sp,sp,-32
    80002c84:	ec06                	sd	ra,24(sp)
    80002c86:	e822                	sd	s0,16(sp)
    80002c88:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002c8a:	fe840593          	addi	a1,s0,-24
    80002c8e:	4501                	li	a0,0
    80002c90:	00000097          	auipc	ra,0x0
    80002c94:	ece080e7          	jalr	-306(ra) # 80002b5e <argaddr>
    return -1;
    80002c98:	57fd                	li	a5,-1
  if(argaddr(0, &p) < 0)
    80002c9a:	00054963          	bltz	a0,80002cac <sys_wait+0x2a>
  return wait(p);
    80002c9e:	fe843503          	ld	a0,-24(s0)
    80002ca2:	fffff097          	auipc	ra,0xfffff
    80002ca6:	662080e7          	jalr	1634(ra) # 80002304 <wait>
    80002caa:	87aa                	mv	a5,a0
}
    80002cac:	853e                	mv	a0,a5
    80002cae:	60e2                	ld	ra,24(sp)
    80002cb0:	6442                	ld	s0,16(sp)
    80002cb2:	6105                	addi	sp,sp,32
    80002cb4:	8082                	ret

0000000080002cb6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002cb6:	7179                	addi	sp,sp,-48
    80002cb8:	f406                	sd	ra,40(sp)
    80002cba:	f022                	sd	s0,32(sp)
    80002cbc:	ec26                	sd	s1,24(sp)
    80002cbe:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002cc0:	fdc40593          	addi	a1,s0,-36
    80002cc4:	4501                	li	a0,0
    80002cc6:	00000097          	auipc	ra,0x0
    80002cca:	e76080e7          	jalr	-394(ra) # 80002b3c <argint>
    return -1;
    80002cce:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002cd0:	00054f63          	bltz	a0,80002cee <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	d9c080e7          	jalr	-612(ra) # 80001a70 <myproc>
    80002cdc:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002cde:	fdc42503          	lw	a0,-36(s0)
    80002ce2:	fffff097          	auipc	ra,0xfffff
    80002ce6:	0dc080e7          	jalr	220(ra) # 80001dbe <growproc>
    80002cea:	00054863          	bltz	a0,80002cfa <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002cee:	8526                	mv	a0,s1
    80002cf0:	70a2                	ld	ra,40(sp)
    80002cf2:	7402                	ld	s0,32(sp)
    80002cf4:	64e2                	ld	s1,24(sp)
    80002cf6:	6145                	addi	sp,sp,48
    80002cf8:	8082                	ret
    return -1;
    80002cfa:	54fd                	li	s1,-1
    80002cfc:	bfcd                	j	80002cee <sys_sbrk+0x38>

0000000080002cfe <sys_sleep>:

uint64
sys_sleep(void)
{
    80002cfe:	7139                	addi	sp,sp,-64
    80002d00:	fc06                	sd	ra,56(sp)
    80002d02:	f822                	sd	s0,48(sp)
    80002d04:	f426                	sd	s1,40(sp)
    80002d06:	f04a                	sd	s2,32(sp)
    80002d08:	ec4e                	sd	s3,24(sp)
    80002d0a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002d0c:	fcc40593          	addi	a1,s0,-52
    80002d10:	4501                	li	a0,0
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	e2a080e7          	jalr	-470(ra) # 80002b3c <argint>
    return -1;
    80002d1a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d1c:	06054763          	bltz	a0,80002d8a <sys_sleep+0x8c>
  acquire(&tickslock);
    80002d20:	00015517          	auipc	a0,0x15
    80002d24:	a4850513          	addi	a0,a0,-1464 # 80017768 <tickslock>
    80002d28:	ffffe097          	auipc	ra,0xffffe
    80002d2c:	f3a080e7          	jalr	-198(ra) # 80000c62 <acquire>
  ticks0 = ticks;
    80002d30:	00006797          	auipc	a5,0x6
    80002d34:	2f078793          	addi	a5,a5,752 # 80009020 <ticks>
    80002d38:	0007a903          	lw	s2,0(a5)
  while(ticks - ticks0 < n){
    80002d3c:	fcc42783          	lw	a5,-52(s0)
    80002d40:	cf85                	beqz	a5,80002d78 <sys_sleep+0x7a>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d42:	00015997          	auipc	s3,0x15
    80002d46:	a2698993          	addi	s3,s3,-1498 # 80017768 <tickslock>
    80002d4a:	00006497          	auipc	s1,0x6
    80002d4e:	2d648493          	addi	s1,s1,726 # 80009020 <ticks>
    if(myproc()->killed){
    80002d52:	fffff097          	auipc	ra,0xfffff
    80002d56:	d1e080e7          	jalr	-738(ra) # 80001a70 <myproc>
    80002d5a:	591c                	lw	a5,48(a0)
    80002d5c:	ef9d                	bnez	a5,80002d9a <sys_sleep+0x9c>
    sleep(&ticks, &tickslock);
    80002d5e:	85ce                	mv	a1,s3
    80002d60:	8526                	mv	a0,s1
    80002d62:	fffff097          	auipc	ra,0xfffff
    80002d66:	524080e7          	jalr	1316(ra) # 80002286 <sleep>
  while(ticks - ticks0 < n){
    80002d6a:	409c                	lw	a5,0(s1)
    80002d6c:	412787bb          	subw	a5,a5,s2
    80002d70:	fcc42703          	lw	a4,-52(s0)
    80002d74:	fce7efe3          	bltu	a5,a4,80002d52 <sys_sleep+0x54>
  }
  release(&tickslock);
    80002d78:	00015517          	auipc	a0,0x15
    80002d7c:	9f050513          	addi	a0,a0,-1552 # 80017768 <tickslock>
    80002d80:	ffffe097          	auipc	ra,0xffffe
    80002d84:	f96080e7          	jalr	-106(ra) # 80000d16 <release>
  return 0;
    80002d88:	4781                	li	a5,0
}
    80002d8a:	853e                	mv	a0,a5
    80002d8c:	70e2                	ld	ra,56(sp)
    80002d8e:	7442                	ld	s0,48(sp)
    80002d90:	74a2                	ld	s1,40(sp)
    80002d92:	7902                	ld	s2,32(sp)
    80002d94:	69e2                	ld	s3,24(sp)
    80002d96:	6121                	addi	sp,sp,64
    80002d98:	8082                	ret
      release(&tickslock);
    80002d9a:	00015517          	auipc	a0,0x15
    80002d9e:	9ce50513          	addi	a0,a0,-1586 # 80017768 <tickslock>
    80002da2:	ffffe097          	auipc	ra,0xffffe
    80002da6:	f74080e7          	jalr	-140(ra) # 80000d16 <release>
      return -1;
    80002daa:	57fd                	li	a5,-1
    80002dac:	bff9                	j	80002d8a <sys_sleep+0x8c>

0000000080002dae <sys_kill>:

uint64
sys_kill(void)
{
    80002dae:	1101                	addi	sp,sp,-32
    80002db0:	ec06                	sd	ra,24(sp)
    80002db2:	e822                	sd	s0,16(sp)
    80002db4:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002db6:	fec40593          	addi	a1,s0,-20
    80002dba:	4501                	li	a0,0
    80002dbc:	00000097          	auipc	ra,0x0
    80002dc0:	d80080e7          	jalr	-640(ra) # 80002b3c <argint>
    return -1;
    80002dc4:	57fd                	li	a5,-1
  if(argint(0, &pid) < 0)
    80002dc6:	00054963          	bltz	a0,80002dd8 <sys_kill+0x2a>
  return kill(pid);
    80002dca:	fec42503          	lw	a0,-20(s0)
    80002dce:	fffff097          	auipc	ra,0xfffff
    80002dd2:	6a8080e7          	jalr	1704(ra) # 80002476 <kill>
    80002dd6:	87aa                	mv	a5,a0
}
    80002dd8:	853e                	mv	a0,a5
    80002dda:	60e2                	ld	ra,24(sp)
    80002ddc:	6442                	ld	s0,16(sp)
    80002dde:	6105                	addi	sp,sp,32
    80002de0:	8082                	ret

0000000080002de2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002de2:	1101                	addi	sp,sp,-32
    80002de4:	ec06                	sd	ra,24(sp)
    80002de6:	e822                	sd	s0,16(sp)
    80002de8:	e426                	sd	s1,8(sp)
    80002dea:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002dec:	00015517          	auipc	a0,0x15
    80002df0:	97c50513          	addi	a0,a0,-1668 # 80017768 <tickslock>
    80002df4:	ffffe097          	auipc	ra,0xffffe
    80002df8:	e6e080e7          	jalr	-402(ra) # 80000c62 <acquire>
  xticks = ticks;
    80002dfc:	00006797          	auipc	a5,0x6
    80002e00:	22478793          	addi	a5,a5,548 # 80009020 <ticks>
    80002e04:	4384                	lw	s1,0(a5)
  release(&tickslock);
    80002e06:	00015517          	auipc	a0,0x15
    80002e0a:	96250513          	addi	a0,a0,-1694 # 80017768 <tickslock>
    80002e0e:	ffffe097          	auipc	ra,0xffffe
    80002e12:	f08080e7          	jalr	-248(ra) # 80000d16 <release>
  return xticks;
}
    80002e16:	02049513          	slli	a0,s1,0x20
    80002e1a:	9101                	srli	a0,a0,0x20
    80002e1c:	60e2                	ld	ra,24(sp)
    80002e1e:	6442                	ld	s0,16(sp)
    80002e20:	64a2                	ld	s1,8(sp)
    80002e22:	6105                	addi	sp,sp,32
    80002e24:	8082                	ret

0000000080002e26 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e26:	7179                	addi	sp,sp,-48
    80002e28:	f406                	sd	ra,40(sp)
    80002e2a:	f022                	sd	s0,32(sp)
    80002e2c:	ec26                	sd	s1,24(sp)
    80002e2e:	e84a                	sd	s2,16(sp)
    80002e30:	e44e                	sd	s3,8(sp)
    80002e32:	e052                	sd	s4,0(sp)
    80002e34:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e36:	00005597          	auipc	a1,0x5
    80002e3a:	6a258593          	addi	a1,a1,1698 # 800084d8 <syscalls+0xd8>
    80002e3e:	00015517          	auipc	a0,0x15
    80002e42:	94250513          	addi	a0,a0,-1726 # 80017780 <bcache>
    80002e46:	ffffe097          	auipc	ra,0xffffe
    80002e4a:	d8c080e7          	jalr	-628(ra) # 80000bd2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e4e:	0001d797          	auipc	a5,0x1d
    80002e52:	93278793          	addi	a5,a5,-1742 # 8001f780 <bcache+0x8000>
    80002e56:	0001d717          	auipc	a4,0x1d
    80002e5a:	b9270713          	addi	a4,a4,-1134 # 8001f9e8 <bcache+0x8268>
    80002e5e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002e62:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e66:	00015497          	auipc	s1,0x15
    80002e6a:	93248493          	addi	s1,s1,-1742 # 80017798 <bcache+0x18>
    b->next = bcache.head.next;
    80002e6e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e70:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e72:	00005a17          	auipc	s4,0x5
    80002e76:	66ea0a13          	addi	s4,s4,1646 # 800084e0 <syscalls+0xe0>
    b->next = bcache.head.next;
    80002e7a:	2b893783          	ld	a5,696(s2)
    80002e7e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002e80:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002e84:	85d2                	mv	a1,s4
    80002e86:	01048513          	addi	a0,s1,16
    80002e8a:	00001097          	auipc	ra,0x1
    80002e8e:	51a080e7          	jalr	1306(ra) # 800043a4 <initsleeplock>
    bcache.head.next->prev = b;
    80002e92:	2b893783          	ld	a5,696(s2)
    80002e96:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002e98:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e9c:	45848493          	addi	s1,s1,1112
    80002ea0:	fd349de3          	bne	s1,s3,80002e7a <binit+0x54>
  }
}
    80002ea4:	70a2                	ld	ra,40(sp)
    80002ea6:	7402                	ld	s0,32(sp)
    80002ea8:	64e2                	ld	s1,24(sp)
    80002eaa:	6942                	ld	s2,16(sp)
    80002eac:	69a2                	ld	s3,8(sp)
    80002eae:	6a02                	ld	s4,0(sp)
    80002eb0:	6145                	addi	sp,sp,48
    80002eb2:	8082                	ret

0000000080002eb4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002eb4:	7179                	addi	sp,sp,-48
    80002eb6:	f406                	sd	ra,40(sp)
    80002eb8:	f022                	sd	s0,32(sp)
    80002eba:	ec26                	sd	s1,24(sp)
    80002ebc:	e84a                	sd	s2,16(sp)
    80002ebe:	e44e                	sd	s3,8(sp)
    80002ec0:	1800                	addi	s0,sp,48
    80002ec2:	89aa                	mv	s3,a0
    80002ec4:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002ec6:	00015517          	auipc	a0,0x15
    80002eca:	8ba50513          	addi	a0,a0,-1862 # 80017780 <bcache>
    80002ece:	ffffe097          	auipc	ra,0xffffe
    80002ed2:	d94080e7          	jalr	-620(ra) # 80000c62 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002ed6:	0001d797          	auipc	a5,0x1d
    80002eda:	8aa78793          	addi	a5,a5,-1878 # 8001f780 <bcache+0x8000>
    80002ede:	2b87b483          	ld	s1,696(a5)
    80002ee2:	0001d797          	auipc	a5,0x1d
    80002ee6:	b0678793          	addi	a5,a5,-1274 # 8001f9e8 <bcache+0x8268>
    80002eea:	02f48f63          	beq	s1,a5,80002f28 <bread+0x74>
    80002eee:	873e                	mv	a4,a5
    80002ef0:	a021                	j	80002ef8 <bread+0x44>
    80002ef2:	68a4                	ld	s1,80(s1)
    80002ef4:	02e48a63          	beq	s1,a4,80002f28 <bread+0x74>
    if(b->dev == dev && b->blockno == blockno){
    80002ef8:	449c                	lw	a5,8(s1)
    80002efa:	ff379ce3          	bne	a5,s3,80002ef2 <bread+0x3e>
    80002efe:	44dc                	lw	a5,12(s1)
    80002f00:	ff2799e3          	bne	a5,s2,80002ef2 <bread+0x3e>
      b->refcnt++;
    80002f04:	40bc                	lw	a5,64(s1)
    80002f06:	2785                	addiw	a5,a5,1
    80002f08:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f0a:	00015517          	auipc	a0,0x15
    80002f0e:	87650513          	addi	a0,a0,-1930 # 80017780 <bcache>
    80002f12:	ffffe097          	auipc	ra,0xffffe
    80002f16:	e04080e7          	jalr	-508(ra) # 80000d16 <release>
      acquiresleep(&b->lock);
    80002f1a:	01048513          	addi	a0,s1,16
    80002f1e:	00001097          	auipc	ra,0x1
    80002f22:	4c0080e7          	jalr	1216(ra) # 800043de <acquiresleep>
      return b;
    80002f26:	a8b1                	j	80002f82 <bread+0xce>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f28:	0001d797          	auipc	a5,0x1d
    80002f2c:	85878793          	addi	a5,a5,-1960 # 8001f780 <bcache+0x8000>
    80002f30:	2b07b483          	ld	s1,688(a5)
    80002f34:	0001d797          	auipc	a5,0x1d
    80002f38:	ab478793          	addi	a5,a5,-1356 # 8001f9e8 <bcache+0x8268>
    80002f3c:	04f48d63          	beq	s1,a5,80002f96 <bread+0xe2>
    if(b->refcnt == 0) {
    80002f40:	40bc                	lw	a5,64(s1)
    80002f42:	cb91                	beqz	a5,80002f56 <bread+0xa2>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f44:	0001d717          	auipc	a4,0x1d
    80002f48:	aa470713          	addi	a4,a4,-1372 # 8001f9e8 <bcache+0x8268>
    80002f4c:	64a4                	ld	s1,72(s1)
    80002f4e:	04e48463          	beq	s1,a4,80002f96 <bread+0xe2>
    if(b->refcnt == 0) {
    80002f52:	40bc                	lw	a5,64(s1)
    80002f54:	ffe5                	bnez	a5,80002f4c <bread+0x98>
      b->dev = dev;
    80002f56:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002f5a:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002f5e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f62:	4785                	li	a5,1
    80002f64:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f66:	00015517          	auipc	a0,0x15
    80002f6a:	81a50513          	addi	a0,a0,-2022 # 80017780 <bcache>
    80002f6e:	ffffe097          	auipc	ra,0xffffe
    80002f72:	da8080e7          	jalr	-600(ra) # 80000d16 <release>
      acquiresleep(&b->lock);
    80002f76:	01048513          	addi	a0,s1,16
    80002f7a:	00001097          	auipc	ra,0x1
    80002f7e:	464080e7          	jalr	1124(ra) # 800043de <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002f82:	409c                	lw	a5,0(s1)
    80002f84:	c38d                	beqz	a5,80002fa6 <bread+0xf2>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f86:	8526                	mv	a0,s1
    80002f88:	70a2                	ld	ra,40(sp)
    80002f8a:	7402                	ld	s0,32(sp)
    80002f8c:	64e2                	ld	s1,24(sp)
    80002f8e:	6942                	ld	s2,16(sp)
    80002f90:	69a2                	ld	s3,8(sp)
    80002f92:	6145                	addi	sp,sp,48
    80002f94:	8082                	ret
  panic("bget: no buffers");
    80002f96:	00005517          	auipc	a0,0x5
    80002f9a:	55250513          	addi	a0,a0,1362 # 800084e8 <syscalls+0xe8>
    80002f9e:	ffffd097          	auipc	ra,0xffffd
    80002fa2:	5d6080e7          	jalr	1494(ra) # 80000574 <panic>
    virtio_disk_rw(b, 0);
    80002fa6:	4581                	li	a1,0
    80002fa8:	8526                	mv	a0,s1
    80002faa:	00003097          	auipc	ra,0x3
    80002fae:	ff4080e7          	jalr	-12(ra) # 80005f9e <virtio_disk_rw>
    b->valid = 1;
    80002fb2:	4785                	li	a5,1
    80002fb4:	c09c                	sw	a5,0(s1)
  return b;
    80002fb6:	bfc1                	j	80002f86 <bread+0xd2>

0000000080002fb8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002fb8:	1101                	addi	sp,sp,-32
    80002fba:	ec06                	sd	ra,24(sp)
    80002fbc:	e822                	sd	s0,16(sp)
    80002fbe:	e426                	sd	s1,8(sp)
    80002fc0:	1000                	addi	s0,sp,32
    80002fc2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002fc4:	0541                	addi	a0,a0,16
    80002fc6:	00001097          	auipc	ra,0x1
    80002fca:	4b2080e7          	jalr	1202(ra) # 80004478 <holdingsleep>
    80002fce:	cd01                	beqz	a0,80002fe6 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002fd0:	4585                	li	a1,1
    80002fd2:	8526                	mv	a0,s1
    80002fd4:	00003097          	auipc	ra,0x3
    80002fd8:	fca080e7          	jalr	-54(ra) # 80005f9e <virtio_disk_rw>
}
    80002fdc:	60e2                	ld	ra,24(sp)
    80002fde:	6442                	ld	s0,16(sp)
    80002fe0:	64a2                	ld	s1,8(sp)
    80002fe2:	6105                	addi	sp,sp,32
    80002fe4:	8082                	ret
    panic("bwrite");
    80002fe6:	00005517          	auipc	a0,0x5
    80002fea:	51a50513          	addi	a0,a0,1306 # 80008500 <syscalls+0x100>
    80002fee:	ffffd097          	auipc	ra,0xffffd
    80002ff2:	586080e7          	jalr	1414(ra) # 80000574 <panic>

0000000080002ff6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002ff6:	1101                	addi	sp,sp,-32
    80002ff8:	ec06                	sd	ra,24(sp)
    80002ffa:	e822                	sd	s0,16(sp)
    80002ffc:	e426                	sd	s1,8(sp)
    80002ffe:	e04a                	sd	s2,0(sp)
    80003000:	1000                	addi	s0,sp,32
    80003002:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003004:	01050913          	addi	s2,a0,16
    80003008:	854a                	mv	a0,s2
    8000300a:	00001097          	auipc	ra,0x1
    8000300e:	46e080e7          	jalr	1134(ra) # 80004478 <holdingsleep>
    80003012:	c92d                	beqz	a0,80003084 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003014:	854a                	mv	a0,s2
    80003016:	00001097          	auipc	ra,0x1
    8000301a:	41e080e7          	jalr	1054(ra) # 80004434 <releasesleep>

  acquire(&bcache.lock);
    8000301e:	00014517          	auipc	a0,0x14
    80003022:	76250513          	addi	a0,a0,1890 # 80017780 <bcache>
    80003026:	ffffe097          	auipc	ra,0xffffe
    8000302a:	c3c080e7          	jalr	-964(ra) # 80000c62 <acquire>
  b->refcnt--;
    8000302e:	40bc                	lw	a5,64(s1)
    80003030:	37fd                	addiw	a5,a5,-1
    80003032:	0007871b          	sext.w	a4,a5
    80003036:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003038:	eb05                	bnez	a4,80003068 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000303a:	68bc                	ld	a5,80(s1)
    8000303c:	64b8                	ld	a4,72(s1)
    8000303e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003040:	64bc                	ld	a5,72(s1)
    80003042:	68b8                	ld	a4,80(s1)
    80003044:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003046:	0001c797          	auipc	a5,0x1c
    8000304a:	73a78793          	addi	a5,a5,1850 # 8001f780 <bcache+0x8000>
    8000304e:	2b87b703          	ld	a4,696(a5)
    80003052:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003054:	0001d717          	auipc	a4,0x1d
    80003058:	99470713          	addi	a4,a4,-1644 # 8001f9e8 <bcache+0x8268>
    8000305c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000305e:	2b87b703          	ld	a4,696(a5)
    80003062:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003064:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003068:	00014517          	auipc	a0,0x14
    8000306c:	71850513          	addi	a0,a0,1816 # 80017780 <bcache>
    80003070:	ffffe097          	auipc	ra,0xffffe
    80003074:	ca6080e7          	jalr	-858(ra) # 80000d16 <release>
}
    80003078:	60e2                	ld	ra,24(sp)
    8000307a:	6442                	ld	s0,16(sp)
    8000307c:	64a2                	ld	s1,8(sp)
    8000307e:	6902                	ld	s2,0(sp)
    80003080:	6105                	addi	sp,sp,32
    80003082:	8082                	ret
    panic("brelse");
    80003084:	00005517          	auipc	a0,0x5
    80003088:	48450513          	addi	a0,a0,1156 # 80008508 <syscalls+0x108>
    8000308c:	ffffd097          	auipc	ra,0xffffd
    80003090:	4e8080e7          	jalr	1256(ra) # 80000574 <panic>

0000000080003094 <bpin>:

void
bpin(struct buf *b) {
    80003094:	1101                	addi	sp,sp,-32
    80003096:	ec06                	sd	ra,24(sp)
    80003098:	e822                	sd	s0,16(sp)
    8000309a:	e426                	sd	s1,8(sp)
    8000309c:	1000                	addi	s0,sp,32
    8000309e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030a0:	00014517          	auipc	a0,0x14
    800030a4:	6e050513          	addi	a0,a0,1760 # 80017780 <bcache>
    800030a8:	ffffe097          	auipc	ra,0xffffe
    800030ac:	bba080e7          	jalr	-1094(ra) # 80000c62 <acquire>
  b->refcnt++;
    800030b0:	40bc                	lw	a5,64(s1)
    800030b2:	2785                	addiw	a5,a5,1
    800030b4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030b6:	00014517          	auipc	a0,0x14
    800030ba:	6ca50513          	addi	a0,a0,1738 # 80017780 <bcache>
    800030be:	ffffe097          	auipc	ra,0xffffe
    800030c2:	c58080e7          	jalr	-936(ra) # 80000d16 <release>
}
    800030c6:	60e2                	ld	ra,24(sp)
    800030c8:	6442                	ld	s0,16(sp)
    800030ca:	64a2                	ld	s1,8(sp)
    800030cc:	6105                	addi	sp,sp,32
    800030ce:	8082                	ret

00000000800030d0 <bunpin>:

void
bunpin(struct buf *b) {
    800030d0:	1101                	addi	sp,sp,-32
    800030d2:	ec06                	sd	ra,24(sp)
    800030d4:	e822                	sd	s0,16(sp)
    800030d6:	e426                	sd	s1,8(sp)
    800030d8:	1000                	addi	s0,sp,32
    800030da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030dc:	00014517          	auipc	a0,0x14
    800030e0:	6a450513          	addi	a0,a0,1700 # 80017780 <bcache>
    800030e4:	ffffe097          	auipc	ra,0xffffe
    800030e8:	b7e080e7          	jalr	-1154(ra) # 80000c62 <acquire>
  b->refcnt--;
    800030ec:	40bc                	lw	a5,64(s1)
    800030ee:	37fd                	addiw	a5,a5,-1
    800030f0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030f2:	00014517          	auipc	a0,0x14
    800030f6:	68e50513          	addi	a0,a0,1678 # 80017780 <bcache>
    800030fa:	ffffe097          	auipc	ra,0xffffe
    800030fe:	c1c080e7          	jalr	-996(ra) # 80000d16 <release>
}
    80003102:	60e2                	ld	ra,24(sp)
    80003104:	6442                	ld	s0,16(sp)
    80003106:	64a2                	ld	s1,8(sp)
    80003108:	6105                	addi	sp,sp,32
    8000310a:	8082                	ret

000000008000310c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000310c:	1101                	addi	sp,sp,-32
    8000310e:	ec06                	sd	ra,24(sp)
    80003110:	e822                	sd	s0,16(sp)
    80003112:	e426                	sd	s1,8(sp)
    80003114:	e04a                	sd	s2,0(sp)
    80003116:	1000                	addi	s0,sp,32
    80003118:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000311a:	00d5d59b          	srliw	a1,a1,0xd
    8000311e:	0001d797          	auipc	a5,0x1d
    80003122:	d2278793          	addi	a5,a5,-734 # 8001fe40 <sb>
    80003126:	4fdc                	lw	a5,28(a5)
    80003128:	9dbd                	addw	a1,a1,a5
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	d8a080e7          	jalr	-630(ra) # 80002eb4 <bread>
  bi = b % BPB;
    80003132:	2481                	sext.w	s1,s1
  m = 1 << (bi % 8);
    80003134:	0074f793          	andi	a5,s1,7
    80003138:	4705                	li	a4,1
    8000313a:	00f7173b          	sllw	a4,a4,a5
  bi = b % BPB;
    8000313e:	6789                	lui	a5,0x2
    80003140:	17fd                	addi	a5,a5,-1
    80003142:	8cfd                	and	s1,s1,a5
  if((bp->data[bi/8] & m) == 0)
    80003144:	41f4d79b          	sraiw	a5,s1,0x1f
    80003148:	01d7d79b          	srliw	a5,a5,0x1d
    8000314c:	9fa5                	addw	a5,a5,s1
    8000314e:	4037d79b          	sraiw	a5,a5,0x3
    80003152:	00f506b3          	add	a3,a0,a5
    80003156:	0586c683          	lbu	a3,88(a3)
    8000315a:	00d77633          	and	a2,a4,a3
    8000315e:	c61d                	beqz	a2,8000318c <bfree+0x80>
    80003160:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003162:	97aa                	add	a5,a5,a0
    80003164:	fff74713          	not	a4,a4
    80003168:	8f75                	and	a4,a4,a3
    8000316a:	04e78c23          	sb	a4,88(a5) # 2058 <_entry-0x7fffdfa8>
  log_write(bp);
    8000316e:	00001097          	auipc	ra,0x1
    80003172:	132080e7          	jalr	306(ra) # 800042a0 <log_write>
  brelse(bp);
    80003176:	854a                	mv	a0,s2
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	e7e080e7          	jalr	-386(ra) # 80002ff6 <brelse>
}
    80003180:	60e2                	ld	ra,24(sp)
    80003182:	6442                	ld	s0,16(sp)
    80003184:	64a2                	ld	s1,8(sp)
    80003186:	6902                	ld	s2,0(sp)
    80003188:	6105                	addi	sp,sp,32
    8000318a:	8082                	ret
    panic("freeing free block");
    8000318c:	00005517          	auipc	a0,0x5
    80003190:	38450513          	addi	a0,a0,900 # 80008510 <syscalls+0x110>
    80003194:	ffffd097          	auipc	ra,0xffffd
    80003198:	3e0080e7          	jalr	992(ra) # 80000574 <panic>

000000008000319c <balloc>:
{
    8000319c:	711d                	addi	sp,sp,-96
    8000319e:	ec86                	sd	ra,88(sp)
    800031a0:	e8a2                	sd	s0,80(sp)
    800031a2:	e4a6                	sd	s1,72(sp)
    800031a4:	e0ca                	sd	s2,64(sp)
    800031a6:	fc4e                	sd	s3,56(sp)
    800031a8:	f852                	sd	s4,48(sp)
    800031aa:	f456                	sd	s5,40(sp)
    800031ac:	f05a                	sd	s6,32(sp)
    800031ae:	ec5e                	sd	s7,24(sp)
    800031b0:	e862                	sd	s8,16(sp)
    800031b2:	e466                	sd	s9,8(sp)
    800031b4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800031b6:	0001d797          	auipc	a5,0x1d
    800031ba:	c8a78793          	addi	a5,a5,-886 # 8001fe40 <sb>
    800031be:	43dc                	lw	a5,4(a5)
    800031c0:	10078e63          	beqz	a5,800032dc <balloc+0x140>
    800031c4:	8baa                	mv	s7,a0
    800031c6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800031c8:	0001db17          	auipc	s6,0x1d
    800031cc:	c78b0b13          	addi	s6,s6,-904 # 8001fe40 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031d0:	4c05                	li	s8,1
      m = 1 << (bi % 8);
    800031d2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031d4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800031d6:	6c89                	lui	s9,0x2
    800031d8:	a079                	j	80003266 <balloc+0xca>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031da:	8942                	mv	s2,a6
      m = 1 << (bi % 8);
    800031dc:	4705                	li	a4,1
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800031de:	4681                	li	a3,0
        bp->data[bi/8] |= m;  // Mark block in use.
    800031e0:	96a6                	add	a3,a3,s1
    800031e2:	8f51                	or	a4,a4,a2
    800031e4:	04e68c23          	sb	a4,88(a3)
        log_write(bp);
    800031e8:	8526                	mv	a0,s1
    800031ea:	00001097          	auipc	ra,0x1
    800031ee:	0b6080e7          	jalr	182(ra) # 800042a0 <log_write>
        brelse(bp);
    800031f2:	8526                	mv	a0,s1
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	e02080e7          	jalr	-510(ra) # 80002ff6 <brelse>
  bp = bread(dev, bno);
    800031fc:	85ca                	mv	a1,s2
    800031fe:	855e                	mv	a0,s7
    80003200:	00000097          	auipc	ra,0x0
    80003204:	cb4080e7          	jalr	-844(ra) # 80002eb4 <bread>
    80003208:	84aa                	mv	s1,a0
  memset(bp->data, 0, BSIZE);
    8000320a:	40000613          	li	a2,1024
    8000320e:	4581                	li	a1,0
    80003210:	05850513          	addi	a0,a0,88
    80003214:	ffffe097          	auipc	ra,0xffffe
    80003218:	b4a080e7          	jalr	-1206(ra) # 80000d5e <memset>
  log_write(bp);
    8000321c:	8526                	mv	a0,s1
    8000321e:	00001097          	auipc	ra,0x1
    80003222:	082080e7          	jalr	130(ra) # 800042a0 <log_write>
  brelse(bp);
    80003226:	8526                	mv	a0,s1
    80003228:	00000097          	auipc	ra,0x0
    8000322c:	dce080e7          	jalr	-562(ra) # 80002ff6 <brelse>
}
    80003230:	854a                	mv	a0,s2
    80003232:	60e6                	ld	ra,88(sp)
    80003234:	6446                	ld	s0,80(sp)
    80003236:	64a6                	ld	s1,72(sp)
    80003238:	6906                	ld	s2,64(sp)
    8000323a:	79e2                	ld	s3,56(sp)
    8000323c:	7a42                	ld	s4,48(sp)
    8000323e:	7aa2                	ld	s5,40(sp)
    80003240:	7b02                	ld	s6,32(sp)
    80003242:	6be2                	ld	s7,24(sp)
    80003244:	6c42                	ld	s8,16(sp)
    80003246:	6ca2                	ld	s9,8(sp)
    80003248:	6125                	addi	sp,sp,96
    8000324a:	8082                	ret
    brelse(bp);
    8000324c:	8526                	mv	a0,s1
    8000324e:	00000097          	auipc	ra,0x0
    80003252:	da8080e7          	jalr	-600(ra) # 80002ff6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003256:	015c87bb          	addw	a5,s9,s5
    8000325a:	00078a9b          	sext.w	s5,a5
    8000325e:	004b2703          	lw	a4,4(s6)
    80003262:	06eafd63          	bleu	a4,s5,800032dc <balloc+0x140>
    bp = bread(dev, BBLOCK(b, sb));
    80003266:	41fad79b          	sraiw	a5,s5,0x1f
    8000326a:	0137d79b          	srliw	a5,a5,0x13
    8000326e:	015787bb          	addw	a5,a5,s5
    80003272:	40d7d79b          	sraiw	a5,a5,0xd
    80003276:	01cb2583          	lw	a1,28(s6)
    8000327a:	9dbd                	addw	a1,a1,a5
    8000327c:	855e                	mv	a0,s7
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	c36080e7          	jalr	-970(ra) # 80002eb4 <bread>
    80003286:	84aa                	mv	s1,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003288:	000a881b          	sext.w	a6,s5
    8000328c:	004b2503          	lw	a0,4(s6)
    80003290:	faa87ee3          	bleu	a0,a6,8000324c <balloc+0xb0>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003294:	0584c603          	lbu	a2,88(s1)
    80003298:	00167793          	andi	a5,a2,1
    8000329c:	df9d                	beqz	a5,800031da <balloc+0x3e>
    8000329e:	4105053b          	subw	a0,a0,a6
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032a2:	87e2                	mv	a5,s8
    800032a4:	0107893b          	addw	s2,a5,a6
    800032a8:	faa782e3          	beq	a5,a0,8000324c <balloc+0xb0>
      m = 1 << (bi % 8);
    800032ac:	41f7d71b          	sraiw	a4,a5,0x1f
    800032b0:	01d7561b          	srliw	a2,a4,0x1d
    800032b4:	00f606bb          	addw	a3,a2,a5
    800032b8:	0076f713          	andi	a4,a3,7
    800032bc:	9f11                	subw	a4,a4,a2
    800032be:	00e9973b          	sllw	a4,s3,a4
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800032c2:	4036d69b          	sraiw	a3,a3,0x3
    800032c6:	00d48633          	add	a2,s1,a3
    800032ca:	05864603          	lbu	a2,88(a2)
    800032ce:	00c775b3          	and	a1,a4,a2
    800032d2:	d599                	beqz	a1,800031e0 <balloc+0x44>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032d4:	2785                	addiw	a5,a5,1
    800032d6:	fd4797e3          	bne	a5,s4,800032a4 <balloc+0x108>
    800032da:	bf8d                	j	8000324c <balloc+0xb0>
  panic("balloc: out of blocks");
    800032dc:	00005517          	auipc	a0,0x5
    800032e0:	24c50513          	addi	a0,a0,588 # 80008528 <syscalls+0x128>
    800032e4:	ffffd097          	auipc	ra,0xffffd
    800032e8:	290080e7          	jalr	656(ra) # 80000574 <panic>

00000000800032ec <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800032ec:	7179                	addi	sp,sp,-48
    800032ee:	f406                	sd	ra,40(sp)
    800032f0:	f022                	sd	s0,32(sp)
    800032f2:	ec26                	sd	s1,24(sp)
    800032f4:	e84a                	sd	s2,16(sp)
    800032f6:	e44e                	sd	s3,8(sp)
    800032f8:	e052                	sd	s4,0(sp)
    800032fa:	1800                	addi	s0,sp,48
    800032fc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800032fe:	47ad                	li	a5,11
    80003300:	04b7fe63          	bleu	a1,a5,8000335c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003304:	ff45849b          	addiw	s1,a1,-12
    80003308:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000330c:	0ff00793          	li	a5,255
    80003310:	0ae7e363          	bltu	a5,a4,800033b6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003314:	08052583          	lw	a1,128(a0)
    80003318:	c5ad                	beqz	a1,80003382 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000331a:	0009a503          	lw	a0,0(s3)
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	b96080e7          	jalr	-1130(ra) # 80002eb4 <bread>
    80003326:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003328:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000332c:	02049593          	slli	a1,s1,0x20
    80003330:	9181                	srli	a1,a1,0x20
    80003332:	058a                	slli	a1,a1,0x2
    80003334:	00b784b3          	add	s1,a5,a1
    80003338:	0004a903          	lw	s2,0(s1)
    8000333c:	04090d63          	beqz	s2,80003396 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003340:	8552                	mv	a0,s4
    80003342:	00000097          	auipc	ra,0x0
    80003346:	cb4080e7          	jalr	-844(ra) # 80002ff6 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000334a:	854a                	mv	a0,s2
    8000334c:	70a2                	ld	ra,40(sp)
    8000334e:	7402                	ld	s0,32(sp)
    80003350:	64e2                	ld	s1,24(sp)
    80003352:	6942                	ld	s2,16(sp)
    80003354:	69a2                	ld	s3,8(sp)
    80003356:	6a02                	ld	s4,0(sp)
    80003358:	6145                	addi	sp,sp,48
    8000335a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000335c:	02059493          	slli	s1,a1,0x20
    80003360:	9081                	srli	s1,s1,0x20
    80003362:	048a                	slli	s1,s1,0x2
    80003364:	94aa                	add	s1,s1,a0
    80003366:	0504a903          	lw	s2,80(s1)
    8000336a:	fe0910e3          	bnez	s2,8000334a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000336e:	4108                	lw	a0,0(a0)
    80003370:	00000097          	auipc	ra,0x0
    80003374:	e2c080e7          	jalr	-468(ra) # 8000319c <balloc>
    80003378:	0005091b          	sext.w	s2,a0
    8000337c:	0524a823          	sw	s2,80(s1)
    80003380:	b7e9                	j	8000334a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003382:	4108                	lw	a0,0(a0)
    80003384:	00000097          	auipc	ra,0x0
    80003388:	e18080e7          	jalr	-488(ra) # 8000319c <balloc>
    8000338c:	0005059b          	sext.w	a1,a0
    80003390:	08b9a023          	sw	a1,128(s3)
    80003394:	b759                	j	8000331a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003396:	0009a503          	lw	a0,0(s3)
    8000339a:	00000097          	auipc	ra,0x0
    8000339e:	e02080e7          	jalr	-510(ra) # 8000319c <balloc>
    800033a2:	0005091b          	sext.w	s2,a0
    800033a6:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    800033aa:	8552                	mv	a0,s4
    800033ac:	00001097          	auipc	ra,0x1
    800033b0:	ef4080e7          	jalr	-268(ra) # 800042a0 <log_write>
    800033b4:	b771                	j	80003340 <bmap+0x54>
  panic("bmap: out of range");
    800033b6:	00005517          	auipc	a0,0x5
    800033ba:	18a50513          	addi	a0,a0,394 # 80008540 <syscalls+0x140>
    800033be:	ffffd097          	auipc	ra,0xffffd
    800033c2:	1b6080e7          	jalr	438(ra) # 80000574 <panic>

00000000800033c6 <iget>:
{
    800033c6:	7179                	addi	sp,sp,-48
    800033c8:	f406                	sd	ra,40(sp)
    800033ca:	f022                	sd	s0,32(sp)
    800033cc:	ec26                	sd	s1,24(sp)
    800033ce:	e84a                	sd	s2,16(sp)
    800033d0:	e44e                	sd	s3,8(sp)
    800033d2:	e052                	sd	s4,0(sp)
    800033d4:	1800                	addi	s0,sp,48
    800033d6:	89aa                	mv	s3,a0
    800033d8:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800033da:	0001d517          	auipc	a0,0x1d
    800033de:	a8650513          	addi	a0,a0,-1402 # 8001fe60 <icache>
    800033e2:	ffffe097          	auipc	ra,0xffffe
    800033e6:	880080e7          	jalr	-1920(ra) # 80000c62 <acquire>
  empty = 0;
    800033ea:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800033ec:	0001d497          	auipc	s1,0x1d
    800033f0:	a8c48493          	addi	s1,s1,-1396 # 8001fe78 <icache+0x18>
    800033f4:	0001e697          	auipc	a3,0x1e
    800033f8:	51468693          	addi	a3,a3,1300 # 80021908 <log>
    800033fc:	a039                	j	8000340a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033fe:	02090b63          	beqz	s2,80003434 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003402:	08848493          	addi	s1,s1,136
    80003406:	02d48a63          	beq	s1,a3,8000343a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000340a:	449c                	lw	a5,8(s1)
    8000340c:	fef059e3          	blez	a5,800033fe <iget+0x38>
    80003410:	4098                	lw	a4,0(s1)
    80003412:	ff3716e3          	bne	a4,s3,800033fe <iget+0x38>
    80003416:	40d8                	lw	a4,4(s1)
    80003418:	ff4713e3          	bne	a4,s4,800033fe <iget+0x38>
      ip->ref++;
    8000341c:	2785                	addiw	a5,a5,1
    8000341e:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003420:	0001d517          	auipc	a0,0x1d
    80003424:	a4050513          	addi	a0,a0,-1472 # 8001fe60 <icache>
    80003428:	ffffe097          	auipc	ra,0xffffe
    8000342c:	8ee080e7          	jalr	-1810(ra) # 80000d16 <release>
      return ip;
    80003430:	8926                	mv	s2,s1
    80003432:	a03d                	j	80003460 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003434:	f7f9                	bnez	a5,80003402 <iget+0x3c>
    80003436:	8926                	mv	s2,s1
    80003438:	b7e9                	j	80003402 <iget+0x3c>
  if(empty == 0)
    8000343a:	02090c63          	beqz	s2,80003472 <iget+0xac>
  ip->dev = dev;
    8000343e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003442:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003446:	4785                	li	a5,1
    80003448:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000344c:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003450:	0001d517          	auipc	a0,0x1d
    80003454:	a1050513          	addi	a0,a0,-1520 # 8001fe60 <icache>
    80003458:	ffffe097          	auipc	ra,0xffffe
    8000345c:	8be080e7          	jalr	-1858(ra) # 80000d16 <release>
}
    80003460:	854a                	mv	a0,s2
    80003462:	70a2                	ld	ra,40(sp)
    80003464:	7402                	ld	s0,32(sp)
    80003466:	64e2                	ld	s1,24(sp)
    80003468:	6942                	ld	s2,16(sp)
    8000346a:	69a2                	ld	s3,8(sp)
    8000346c:	6a02                	ld	s4,0(sp)
    8000346e:	6145                	addi	sp,sp,48
    80003470:	8082                	ret
    panic("iget: no inodes");
    80003472:	00005517          	auipc	a0,0x5
    80003476:	0e650513          	addi	a0,a0,230 # 80008558 <syscalls+0x158>
    8000347a:	ffffd097          	auipc	ra,0xffffd
    8000347e:	0fa080e7          	jalr	250(ra) # 80000574 <panic>

0000000080003482 <fsinit>:
fsinit(int dev) {
    80003482:	7179                	addi	sp,sp,-48
    80003484:	f406                	sd	ra,40(sp)
    80003486:	f022                	sd	s0,32(sp)
    80003488:	ec26                	sd	s1,24(sp)
    8000348a:	e84a                	sd	s2,16(sp)
    8000348c:	e44e                	sd	s3,8(sp)
    8000348e:	1800                	addi	s0,sp,48
    80003490:	89aa                	mv	s3,a0
  bp = bread(dev, 1);
    80003492:	4585                	li	a1,1
    80003494:	00000097          	auipc	ra,0x0
    80003498:	a20080e7          	jalr	-1504(ra) # 80002eb4 <bread>
    8000349c:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000349e:	0001d497          	auipc	s1,0x1d
    800034a2:	9a248493          	addi	s1,s1,-1630 # 8001fe40 <sb>
    800034a6:	02000613          	li	a2,32
    800034aa:	05850593          	addi	a1,a0,88
    800034ae:	8526                	mv	a0,s1
    800034b0:	ffffe097          	auipc	ra,0xffffe
    800034b4:	91a080e7          	jalr	-1766(ra) # 80000dca <memmove>
  brelse(bp);
    800034b8:	854a                	mv	a0,s2
    800034ba:	00000097          	auipc	ra,0x0
    800034be:	b3c080e7          	jalr	-1220(ra) # 80002ff6 <brelse>
  if(sb.magic != FSMAGIC)
    800034c2:	4098                	lw	a4,0(s1)
    800034c4:	102037b7          	lui	a5,0x10203
    800034c8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800034cc:	02f71263          	bne	a4,a5,800034f0 <fsinit+0x6e>
  initlog(dev, &sb);
    800034d0:	0001d597          	auipc	a1,0x1d
    800034d4:	97058593          	addi	a1,a1,-1680 # 8001fe40 <sb>
    800034d8:	854e                	mv	a0,s3
    800034da:	00001097          	auipc	ra,0x1
    800034de:	b48080e7          	jalr	-1208(ra) # 80004022 <initlog>
}
    800034e2:	70a2                	ld	ra,40(sp)
    800034e4:	7402                	ld	s0,32(sp)
    800034e6:	64e2                	ld	s1,24(sp)
    800034e8:	6942                	ld	s2,16(sp)
    800034ea:	69a2                	ld	s3,8(sp)
    800034ec:	6145                	addi	sp,sp,48
    800034ee:	8082                	ret
    panic("invalid file system");
    800034f0:	00005517          	auipc	a0,0x5
    800034f4:	07850513          	addi	a0,a0,120 # 80008568 <syscalls+0x168>
    800034f8:	ffffd097          	auipc	ra,0xffffd
    800034fc:	07c080e7          	jalr	124(ra) # 80000574 <panic>

0000000080003500 <iinit>:
{
    80003500:	7179                	addi	sp,sp,-48
    80003502:	f406                	sd	ra,40(sp)
    80003504:	f022                	sd	s0,32(sp)
    80003506:	ec26                	sd	s1,24(sp)
    80003508:	e84a                	sd	s2,16(sp)
    8000350a:	e44e                	sd	s3,8(sp)
    8000350c:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    8000350e:	00005597          	auipc	a1,0x5
    80003512:	07258593          	addi	a1,a1,114 # 80008580 <syscalls+0x180>
    80003516:	0001d517          	auipc	a0,0x1d
    8000351a:	94a50513          	addi	a0,a0,-1718 # 8001fe60 <icache>
    8000351e:	ffffd097          	auipc	ra,0xffffd
    80003522:	6b4080e7          	jalr	1716(ra) # 80000bd2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003526:	0001d497          	auipc	s1,0x1d
    8000352a:	96248493          	addi	s1,s1,-1694 # 8001fe88 <icache+0x28>
    8000352e:	0001e997          	auipc	s3,0x1e
    80003532:	3ea98993          	addi	s3,s3,1002 # 80021918 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003536:	00005917          	auipc	s2,0x5
    8000353a:	05290913          	addi	s2,s2,82 # 80008588 <syscalls+0x188>
    8000353e:	85ca                	mv	a1,s2
    80003540:	8526                	mv	a0,s1
    80003542:	00001097          	auipc	ra,0x1
    80003546:	e62080e7          	jalr	-414(ra) # 800043a4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000354a:	08848493          	addi	s1,s1,136
    8000354e:	ff3498e3          	bne	s1,s3,8000353e <iinit+0x3e>
}
    80003552:	70a2                	ld	ra,40(sp)
    80003554:	7402                	ld	s0,32(sp)
    80003556:	64e2                	ld	s1,24(sp)
    80003558:	6942                	ld	s2,16(sp)
    8000355a:	69a2                	ld	s3,8(sp)
    8000355c:	6145                	addi	sp,sp,48
    8000355e:	8082                	ret

0000000080003560 <ialloc>:
{
    80003560:	715d                	addi	sp,sp,-80
    80003562:	e486                	sd	ra,72(sp)
    80003564:	e0a2                	sd	s0,64(sp)
    80003566:	fc26                	sd	s1,56(sp)
    80003568:	f84a                	sd	s2,48(sp)
    8000356a:	f44e                	sd	s3,40(sp)
    8000356c:	f052                	sd	s4,32(sp)
    8000356e:	ec56                	sd	s5,24(sp)
    80003570:	e85a                	sd	s6,16(sp)
    80003572:	e45e                	sd	s7,8(sp)
    80003574:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003576:	0001d797          	auipc	a5,0x1d
    8000357a:	8ca78793          	addi	a5,a5,-1846 # 8001fe40 <sb>
    8000357e:	47d8                	lw	a4,12(a5)
    80003580:	4785                	li	a5,1
    80003582:	04e7fa63          	bleu	a4,a5,800035d6 <ialloc+0x76>
    80003586:	8a2a                	mv	s4,a0
    80003588:	8b2e                	mv	s6,a1
    8000358a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000358c:	0001d997          	auipc	s3,0x1d
    80003590:	8b498993          	addi	s3,s3,-1868 # 8001fe40 <sb>
    80003594:	00048a9b          	sext.w	s5,s1
    80003598:	0044d593          	srli	a1,s1,0x4
    8000359c:	0189a783          	lw	a5,24(s3)
    800035a0:	9dbd                	addw	a1,a1,a5
    800035a2:	8552                	mv	a0,s4
    800035a4:	00000097          	auipc	ra,0x0
    800035a8:	910080e7          	jalr	-1776(ra) # 80002eb4 <bread>
    800035ac:	8baa                	mv	s7,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035ae:	05850913          	addi	s2,a0,88
    800035b2:	00f4f793          	andi	a5,s1,15
    800035b6:	079a                	slli	a5,a5,0x6
    800035b8:	993e                	add	s2,s2,a5
    if(dip->type == 0){  // a free inode
    800035ba:	00091783          	lh	a5,0(s2)
    800035be:	c785                	beqz	a5,800035e6 <ialloc+0x86>
    brelse(bp);
    800035c0:	00000097          	auipc	ra,0x0
    800035c4:	a36080e7          	jalr	-1482(ra) # 80002ff6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800035c8:	0485                	addi	s1,s1,1
    800035ca:	00c9a703          	lw	a4,12(s3)
    800035ce:	0004879b          	sext.w	a5,s1
    800035d2:	fce7e1e3          	bltu	a5,a4,80003594 <ialloc+0x34>
  panic("ialloc: no inodes");
    800035d6:	00005517          	auipc	a0,0x5
    800035da:	fba50513          	addi	a0,a0,-70 # 80008590 <syscalls+0x190>
    800035de:	ffffd097          	auipc	ra,0xffffd
    800035e2:	f96080e7          	jalr	-106(ra) # 80000574 <panic>
      memset(dip, 0, sizeof(*dip));
    800035e6:	04000613          	li	a2,64
    800035ea:	4581                	li	a1,0
    800035ec:	854a                	mv	a0,s2
    800035ee:	ffffd097          	auipc	ra,0xffffd
    800035f2:	770080e7          	jalr	1904(ra) # 80000d5e <memset>
      dip->type = type;
    800035f6:	01691023          	sh	s6,0(s2)
      log_write(bp);   // mark it allocated on the disk
    800035fa:	855e                	mv	a0,s7
    800035fc:	00001097          	auipc	ra,0x1
    80003600:	ca4080e7          	jalr	-860(ra) # 800042a0 <log_write>
      brelse(bp);
    80003604:	855e                	mv	a0,s7
    80003606:	00000097          	auipc	ra,0x0
    8000360a:	9f0080e7          	jalr	-1552(ra) # 80002ff6 <brelse>
      return iget(dev, inum);
    8000360e:	85d6                	mv	a1,s5
    80003610:	8552                	mv	a0,s4
    80003612:	00000097          	auipc	ra,0x0
    80003616:	db4080e7          	jalr	-588(ra) # 800033c6 <iget>
}
    8000361a:	60a6                	ld	ra,72(sp)
    8000361c:	6406                	ld	s0,64(sp)
    8000361e:	74e2                	ld	s1,56(sp)
    80003620:	7942                	ld	s2,48(sp)
    80003622:	79a2                	ld	s3,40(sp)
    80003624:	7a02                	ld	s4,32(sp)
    80003626:	6ae2                	ld	s5,24(sp)
    80003628:	6b42                	ld	s6,16(sp)
    8000362a:	6ba2                	ld	s7,8(sp)
    8000362c:	6161                	addi	sp,sp,80
    8000362e:	8082                	ret

0000000080003630 <iupdate>:
{
    80003630:	1101                	addi	sp,sp,-32
    80003632:	ec06                	sd	ra,24(sp)
    80003634:	e822                	sd	s0,16(sp)
    80003636:	e426                	sd	s1,8(sp)
    80003638:	e04a                	sd	s2,0(sp)
    8000363a:	1000                	addi	s0,sp,32
    8000363c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000363e:	415c                	lw	a5,4(a0)
    80003640:	0047d79b          	srliw	a5,a5,0x4
    80003644:	0001c717          	auipc	a4,0x1c
    80003648:	7fc70713          	addi	a4,a4,2044 # 8001fe40 <sb>
    8000364c:	4f0c                	lw	a1,24(a4)
    8000364e:	9dbd                	addw	a1,a1,a5
    80003650:	4108                	lw	a0,0(a0)
    80003652:	00000097          	auipc	ra,0x0
    80003656:	862080e7          	jalr	-1950(ra) # 80002eb4 <bread>
    8000365a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000365c:	05850513          	addi	a0,a0,88
    80003660:	40dc                	lw	a5,4(s1)
    80003662:	8bbd                	andi	a5,a5,15
    80003664:	079a                	slli	a5,a5,0x6
    80003666:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003668:	04449783          	lh	a5,68(s1)
    8000366c:	00f51023          	sh	a5,0(a0)
  dip->major = ip->major;
    80003670:	04649783          	lh	a5,70(s1)
    80003674:	00f51123          	sh	a5,2(a0)
  dip->minor = ip->minor;
    80003678:	04849783          	lh	a5,72(s1)
    8000367c:	00f51223          	sh	a5,4(a0)
  dip->nlink = ip->nlink;
    80003680:	04a49783          	lh	a5,74(s1)
    80003684:	00f51323          	sh	a5,6(a0)
  dip->size = ip->size;
    80003688:	44fc                	lw	a5,76(s1)
    8000368a:	c51c                	sw	a5,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000368c:	03400613          	li	a2,52
    80003690:	05048593          	addi	a1,s1,80
    80003694:	0531                	addi	a0,a0,12
    80003696:	ffffd097          	auipc	ra,0xffffd
    8000369a:	734080e7          	jalr	1844(ra) # 80000dca <memmove>
  log_write(bp);
    8000369e:	854a                	mv	a0,s2
    800036a0:	00001097          	auipc	ra,0x1
    800036a4:	c00080e7          	jalr	-1024(ra) # 800042a0 <log_write>
  brelse(bp);
    800036a8:	854a                	mv	a0,s2
    800036aa:	00000097          	auipc	ra,0x0
    800036ae:	94c080e7          	jalr	-1716(ra) # 80002ff6 <brelse>
}
    800036b2:	60e2                	ld	ra,24(sp)
    800036b4:	6442                	ld	s0,16(sp)
    800036b6:	64a2                	ld	s1,8(sp)
    800036b8:	6902                	ld	s2,0(sp)
    800036ba:	6105                	addi	sp,sp,32
    800036bc:	8082                	ret

00000000800036be <idup>:
{
    800036be:	1101                	addi	sp,sp,-32
    800036c0:	ec06                	sd	ra,24(sp)
    800036c2:	e822                	sd	s0,16(sp)
    800036c4:	e426                	sd	s1,8(sp)
    800036c6:	1000                	addi	s0,sp,32
    800036c8:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800036ca:	0001c517          	auipc	a0,0x1c
    800036ce:	79650513          	addi	a0,a0,1942 # 8001fe60 <icache>
    800036d2:	ffffd097          	auipc	ra,0xffffd
    800036d6:	590080e7          	jalr	1424(ra) # 80000c62 <acquire>
  ip->ref++;
    800036da:	449c                	lw	a5,8(s1)
    800036dc:	2785                	addiw	a5,a5,1
    800036de:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800036e0:	0001c517          	auipc	a0,0x1c
    800036e4:	78050513          	addi	a0,a0,1920 # 8001fe60 <icache>
    800036e8:	ffffd097          	auipc	ra,0xffffd
    800036ec:	62e080e7          	jalr	1582(ra) # 80000d16 <release>
}
    800036f0:	8526                	mv	a0,s1
    800036f2:	60e2                	ld	ra,24(sp)
    800036f4:	6442                	ld	s0,16(sp)
    800036f6:	64a2                	ld	s1,8(sp)
    800036f8:	6105                	addi	sp,sp,32
    800036fa:	8082                	ret

00000000800036fc <ilock>:
{
    800036fc:	1101                	addi	sp,sp,-32
    800036fe:	ec06                	sd	ra,24(sp)
    80003700:	e822                	sd	s0,16(sp)
    80003702:	e426                	sd	s1,8(sp)
    80003704:	e04a                	sd	s2,0(sp)
    80003706:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003708:	c115                	beqz	a0,8000372c <ilock+0x30>
    8000370a:	84aa                	mv	s1,a0
    8000370c:	451c                	lw	a5,8(a0)
    8000370e:	00f05f63          	blez	a5,8000372c <ilock+0x30>
  acquiresleep(&ip->lock);
    80003712:	0541                	addi	a0,a0,16
    80003714:	00001097          	auipc	ra,0x1
    80003718:	cca080e7          	jalr	-822(ra) # 800043de <acquiresleep>
  if(ip->valid == 0){
    8000371c:	40bc                	lw	a5,64(s1)
    8000371e:	cf99                	beqz	a5,8000373c <ilock+0x40>
}
    80003720:	60e2                	ld	ra,24(sp)
    80003722:	6442                	ld	s0,16(sp)
    80003724:	64a2                	ld	s1,8(sp)
    80003726:	6902                	ld	s2,0(sp)
    80003728:	6105                	addi	sp,sp,32
    8000372a:	8082                	ret
    panic("ilock");
    8000372c:	00005517          	auipc	a0,0x5
    80003730:	e7c50513          	addi	a0,a0,-388 # 800085a8 <syscalls+0x1a8>
    80003734:	ffffd097          	auipc	ra,0xffffd
    80003738:	e40080e7          	jalr	-448(ra) # 80000574 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000373c:	40dc                	lw	a5,4(s1)
    8000373e:	0047d79b          	srliw	a5,a5,0x4
    80003742:	0001c717          	auipc	a4,0x1c
    80003746:	6fe70713          	addi	a4,a4,1790 # 8001fe40 <sb>
    8000374a:	4f0c                	lw	a1,24(a4)
    8000374c:	9dbd                	addw	a1,a1,a5
    8000374e:	4088                	lw	a0,0(s1)
    80003750:	fffff097          	auipc	ra,0xfffff
    80003754:	764080e7          	jalr	1892(ra) # 80002eb4 <bread>
    80003758:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000375a:	05850593          	addi	a1,a0,88
    8000375e:	40dc                	lw	a5,4(s1)
    80003760:	8bbd                	andi	a5,a5,15
    80003762:	079a                	slli	a5,a5,0x6
    80003764:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003766:	00059783          	lh	a5,0(a1)
    8000376a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000376e:	00259783          	lh	a5,2(a1)
    80003772:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003776:	00459783          	lh	a5,4(a1)
    8000377a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000377e:	00659783          	lh	a5,6(a1)
    80003782:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003786:	459c                	lw	a5,8(a1)
    80003788:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000378a:	03400613          	li	a2,52
    8000378e:	05b1                	addi	a1,a1,12
    80003790:	05048513          	addi	a0,s1,80
    80003794:	ffffd097          	auipc	ra,0xffffd
    80003798:	636080e7          	jalr	1590(ra) # 80000dca <memmove>
    brelse(bp);
    8000379c:	854a                	mv	a0,s2
    8000379e:	00000097          	auipc	ra,0x0
    800037a2:	858080e7          	jalr	-1960(ra) # 80002ff6 <brelse>
    ip->valid = 1;
    800037a6:	4785                	li	a5,1
    800037a8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800037aa:	04449783          	lh	a5,68(s1)
    800037ae:	fbad                	bnez	a5,80003720 <ilock+0x24>
      panic("ilock: no type");
    800037b0:	00005517          	auipc	a0,0x5
    800037b4:	e0050513          	addi	a0,a0,-512 # 800085b0 <syscalls+0x1b0>
    800037b8:	ffffd097          	auipc	ra,0xffffd
    800037bc:	dbc080e7          	jalr	-580(ra) # 80000574 <panic>

00000000800037c0 <iunlock>:
{
    800037c0:	1101                	addi	sp,sp,-32
    800037c2:	ec06                	sd	ra,24(sp)
    800037c4:	e822                	sd	s0,16(sp)
    800037c6:	e426                	sd	s1,8(sp)
    800037c8:	e04a                	sd	s2,0(sp)
    800037ca:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800037cc:	c905                	beqz	a0,800037fc <iunlock+0x3c>
    800037ce:	84aa                	mv	s1,a0
    800037d0:	01050913          	addi	s2,a0,16
    800037d4:	854a                	mv	a0,s2
    800037d6:	00001097          	auipc	ra,0x1
    800037da:	ca2080e7          	jalr	-862(ra) # 80004478 <holdingsleep>
    800037de:	cd19                	beqz	a0,800037fc <iunlock+0x3c>
    800037e0:	449c                	lw	a5,8(s1)
    800037e2:	00f05d63          	blez	a5,800037fc <iunlock+0x3c>
  releasesleep(&ip->lock);
    800037e6:	854a                	mv	a0,s2
    800037e8:	00001097          	auipc	ra,0x1
    800037ec:	c4c080e7          	jalr	-948(ra) # 80004434 <releasesleep>
}
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	64a2                	ld	s1,8(sp)
    800037f6:	6902                	ld	s2,0(sp)
    800037f8:	6105                	addi	sp,sp,32
    800037fa:	8082                	ret
    panic("iunlock");
    800037fc:	00005517          	auipc	a0,0x5
    80003800:	dc450513          	addi	a0,a0,-572 # 800085c0 <syscalls+0x1c0>
    80003804:	ffffd097          	auipc	ra,0xffffd
    80003808:	d70080e7          	jalr	-656(ra) # 80000574 <panic>

000000008000380c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000380c:	7179                	addi	sp,sp,-48
    8000380e:	f406                	sd	ra,40(sp)
    80003810:	f022                	sd	s0,32(sp)
    80003812:	ec26                	sd	s1,24(sp)
    80003814:	e84a                	sd	s2,16(sp)
    80003816:	e44e                	sd	s3,8(sp)
    80003818:	e052                	sd	s4,0(sp)
    8000381a:	1800                	addi	s0,sp,48
    8000381c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000381e:	05050493          	addi	s1,a0,80
    80003822:	08050913          	addi	s2,a0,128
    80003826:	a821                	j	8000383e <itrunc+0x32>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80003828:	0009a503          	lw	a0,0(s3)
    8000382c:	00000097          	auipc	ra,0x0
    80003830:	8e0080e7          	jalr	-1824(ra) # 8000310c <bfree>
      ip->addrs[i] = 0;
    80003834:	0004a023          	sw	zero,0(s1)
  for(i = 0; i < NDIRECT; i++){
    80003838:	0491                	addi	s1,s1,4
    8000383a:	01248563          	beq	s1,s2,80003844 <itrunc+0x38>
    if(ip->addrs[i]){
    8000383e:	408c                	lw	a1,0(s1)
    80003840:	dde5                	beqz	a1,80003838 <itrunc+0x2c>
    80003842:	b7dd                	j	80003828 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003844:	0809a583          	lw	a1,128(s3)
    80003848:	e185                	bnez	a1,80003868 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000384a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000384e:	854e                	mv	a0,s3
    80003850:	00000097          	auipc	ra,0x0
    80003854:	de0080e7          	jalr	-544(ra) # 80003630 <iupdate>
}
    80003858:	70a2                	ld	ra,40(sp)
    8000385a:	7402                	ld	s0,32(sp)
    8000385c:	64e2                	ld	s1,24(sp)
    8000385e:	6942                	ld	s2,16(sp)
    80003860:	69a2                	ld	s3,8(sp)
    80003862:	6a02                	ld	s4,0(sp)
    80003864:	6145                	addi	sp,sp,48
    80003866:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003868:	0009a503          	lw	a0,0(s3)
    8000386c:	fffff097          	auipc	ra,0xfffff
    80003870:	648080e7          	jalr	1608(ra) # 80002eb4 <bread>
    80003874:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003876:	05850493          	addi	s1,a0,88
    8000387a:	45850913          	addi	s2,a0,1112
    8000387e:	a811                	j	80003892 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80003880:	0009a503          	lw	a0,0(s3)
    80003884:	00000097          	auipc	ra,0x0
    80003888:	888080e7          	jalr	-1912(ra) # 8000310c <bfree>
    for(j = 0; j < NINDIRECT; j++){
    8000388c:	0491                	addi	s1,s1,4
    8000388e:	01248563          	beq	s1,s2,80003898 <itrunc+0x8c>
      if(a[j])
    80003892:	408c                	lw	a1,0(s1)
    80003894:	dde5                	beqz	a1,8000388c <itrunc+0x80>
    80003896:	b7ed                	j	80003880 <itrunc+0x74>
    brelse(bp);
    80003898:	8552                	mv	a0,s4
    8000389a:	fffff097          	auipc	ra,0xfffff
    8000389e:	75c080e7          	jalr	1884(ra) # 80002ff6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800038a2:	0809a583          	lw	a1,128(s3)
    800038a6:	0009a503          	lw	a0,0(s3)
    800038aa:	00000097          	auipc	ra,0x0
    800038ae:	862080e7          	jalr	-1950(ra) # 8000310c <bfree>
    ip->addrs[NDIRECT] = 0;
    800038b2:	0809a023          	sw	zero,128(s3)
    800038b6:	bf51                	j	8000384a <itrunc+0x3e>

00000000800038b8 <iput>:
{
    800038b8:	1101                	addi	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	e426                	sd	s1,8(sp)
    800038c0:	e04a                	sd	s2,0(sp)
    800038c2:	1000                	addi	s0,sp,32
    800038c4:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800038c6:	0001c517          	auipc	a0,0x1c
    800038ca:	59a50513          	addi	a0,a0,1434 # 8001fe60 <icache>
    800038ce:	ffffd097          	auipc	ra,0xffffd
    800038d2:	394080e7          	jalr	916(ra) # 80000c62 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038d6:	4498                	lw	a4,8(s1)
    800038d8:	4785                	li	a5,1
    800038da:	02f70363          	beq	a4,a5,80003900 <iput+0x48>
  ip->ref--;
    800038de:	449c                	lw	a5,8(s1)
    800038e0:	37fd                	addiw	a5,a5,-1
    800038e2:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800038e4:	0001c517          	auipc	a0,0x1c
    800038e8:	57c50513          	addi	a0,a0,1404 # 8001fe60 <icache>
    800038ec:	ffffd097          	auipc	ra,0xffffd
    800038f0:	42a080e7          	jalr	1066(ra) # 80000d16 <release>
}
    800038f4:	60e2                	ld	ra,24(sp)
    800038f6:	6442                	ld	s0,16(sp)
    800038f8:	64a2                	ld	s1,8(sp)
    800038fa:	6902                	ld	s2,0(sp)
    800038fc:	6105                	addi	sp,sp,32
    800038fe:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003900:	40bc                	lw	a5,64(s1)
    80003902:	dff1                	beqz	a5,800038de <iput+0x26>
    80003904:	04a49783          	lh	a5,74(s1)
    80003908:	fbf9                	bnez	a5,800038de <iput+0x26>
    acquiresleep(&ip->lock);
    8000390a:	01048913          	addi	s2,s1,16
    8000390e:	854a                	mv	a0,s2
    80003910:	00001097          	auipc	ra,0x1
    80003914:	ace080e7          	jalr	-1330(ra) # 800043de <acquiresleep>
    release(&icache.lock);
    80003918:	0001c517          	auipc	a0,0x1c
    8000391c:	54850513          	addi	a0,a0,1352 # 8001fe60 <icache>
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	3f6080e7          	jalr	1014(ra) # 80000d16 <release>
    itrunc(ip);
    80003928:	8526                	mv	a0,s1
    8000392a:	00000097          	auipc	ra,0x0
    8000392e:	ee2080e7          	jalr	-286(ra) # 8000380c <itrunc>
    ip->type = 0;
    80003932:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003936:	8526                	mv	a0,s1
    80003938:	00000097          	auipc	ra,0x0
    8000393c:	cf8080e7          	jalr	-776(ra) # 80003630 <iupdate>
    ip->valid = 0;
    80003940:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003944:	854a                	mv	a0,s2
    80003946:	00001097          	auipc	ra,0x1
    8000394a:	aee080e7          	jalr	-1298(ra) # 80004434 <releasesleep>
    acquire(&icache.lock);
    8000394e:	0001c517          	auipc	a0,0x1c
    80003952:	51250513          	addi	a0,a0,1298 # 8001fe60 <icache>
    80003956:	ffffd097          	auipc	ra,0xffffd
    8000395a:	30c080e7          	jalr	780(ra) # 80000c62 <acquire>
    8000395e:	b741                	j	800038de <iput+0x26>

0000000080003960 <iunlockput>:
{
    80003960:	1101                	addi	sp,sp,-32
    80003962:	ec06                	sd	ra,24(sp)
    80003964:	e822                	sd	s0,16(sp)
    80003966:	e426                	sd	s1,8(sp)
    80003968:	1000                	addi	s0,sp,32
    8000396a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000396c:	00000097          	auipc	ra,0x0
    80003970:	e54080e7          	jalr	-428(ra) # 800037c0 <iunlock>
  iput(ip);
    80003974:	8526                	mv	a0,s1
    80003976:	00000097          	auipc	ra,0x0
    8000397a:	f42080e7          	jalr	-190(ra) # 800038b8 <iput>
}
    8000397e:	60e2                	ld	ra,24(sp)
    80003980:	6442                	ld	s0,16(sp)
    80003982:	64a2                	ld	s1,8(sp)
    80003984:	6105                	addi	sp,sp,32
    80003986:	8082                	ret

0000000080003988 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003988:	1141                	addi	sp,sp,-16
    8000398a:	e422                	sd	s0,8(sp)
    8000398c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000398e:	411c                	lw	a5,0(a0)
    80003990:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003992:	415c                	lw	a5,4(a0)
    80003994:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003996:	04451783          	lh	a5,68(a0)
    8000399a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000399e:	04a51783          	lh	a5,74(a0)
    800039a2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800039a6:	04c56783          	lwu	a5,76(a0)
    800039aa:	e99c                	sd	a5,16(a1)
}
    800039ac:	6422                	ld	s0,8(sp)
    800039ae:	0141                	addi	sp,sp,16
    800039b0:	8082                	ret

00000000800039b2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039b2:	457c                	lw	a5,76(a0)
    800039b4:	0ed7e863          	bltu	a5,a3,80003aa4 <readi+0xf2>
{
    800039b8:	7159                	addi	sp,sp,-112
    800039ba:	f486                	sd	ra,104(sp)
    800039bc:	f0a2                	sd	s0,96(sp)
    800039be:	eca6                	sd	s1,88(sp)
    800039c0:	e8ca                	sd	s2,80(sp)
    800039c2:	e4ce                	sd	s3,72(sp)
    800039c4:	e0d2                	sd	s4,64(sp)
    800039c6:	fc56                	sd	s5,56(sp)
    800039c8:	f85a                	sd	s6,48(sp)
    800039ca:	f45e                	sd	s7,40(sp)
    800039cc:	f062                	sd	s8,32(sp)
    800039ce:	ec66                	sd	s9,24(sp)
    800039d0:	e86a                	sd	s10,16(sp)
    800039d2:	e46e                	sd	s11,8(sp)
    800039d4:	1880                	addi	s0,sp,112
    800039d6:	8baa                	mv	s7,a0
    800039d8:	8c2e                	mv	s8,a1
    800039da:	8a32                	mv	s4,a2
    800039dc:	84b6                	mv	s1,a3
    800039de:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039e0:	9f35                	addw	a4,a4,a3
    return 0;
    800039e2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800039e4:	08d76f63          	bltu	a4,a3,80003a82 <readi+0xd0>
  if(off + n > ip->size)
    800039e8:	00e7f463          	bleu	a4,a5,800039f0 <readi+0x3e>
    n = ip->size - off;
    800039ec:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039f0:	0a0b0863          	beqz	s6,80003aa0 <readi+0xee>
    800039f4:	4901                	li	s2,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800039f6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800039fa:	5cfd                	li	s9,-1
    800039fc:	a82d                	j	80003a36 <readi+0x84>
    800039fe:	02099d93          	slli	s11,s3,0x20
    80003a02:	020ddd93          	srli	s11,s11,0x20
    80003a06:	058a8613          	addi	a2,s5,88
    80003a0a:	86ee                	mv	a3,s11
    80003a0c:	963a                	add	a2,a2,a4
    80003a0e:	85d2                	mv	a1,s4
    80003a10:	8562                	mv	a0,s8
    80003a12:	fffff097          	auipc	ra,0xfffff
    80003a16:	ad6080e7          	jalr	-1322(ra) # 800024e8 <either_copyout>
    80003a1a:	05950d63          	beq	a0,s9,80003a74 <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003a1e:	8556                	mv	a0,s5
    80003a20:	fffff097          	auipc	ra,0xfffff
    80003a24:	5d6080e7          	jalr	1494(ra) # 80002ff6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a28:	0129893b          	addw	s2,s3,s2
    80003a2c:	009984bb          	addw	s1,s3,s1
    80003a30:	9a6e                	add	s4,s4,s11
    80003a32:	05697663          	bleu	s6,s2,80003a7e <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a36:	000ba983          	lw	s3,0(s7)
    80003a3a:	00a4d59b          	srliw	a1,s1,0xa
    80003a3e:	855e                	mv	a0,s7
    80003a40:	00000097          	auipc	ra,0x0
    80003a44:	8ac080e7          	jalr	-1876(ra) # 800032ec <bmap>
    80003a48:	0005059b          	sext.w	a1,a0
    80003a4c:	854e                	mv	a0,s3
    80003a4e:	fffff097          	auipc	ra,0xfffff
    80003a52:	466080e7          	jalr	1126(ra) # 80002eb4 <bread>
    80003a56:	8aaa                	mv	s5,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a58:	3ff4f713          	andi	a4,s1,1023
    80003a5c:	40ed07bb          	subw	a5,s10,a4
    80003a60:	412b06bb          	subw	a3,s6,s2
    80003a64:	89be                	mv	s3,a5
    80003a66:	2781                	sext.w	a5,a5
    80003a68:	0006861b          	sext.w	a2,a3
    80003a6c:	f8f679e3          	bleu	a5,a2,800039fe <readi+0x4c>
    80003a70:	89b6                	mv	s3,a3
    80003a72:	b771                	j	800039fe <readi+0x4c>
      brelse(bp);
    80003a74:	8556                	mv	a0,s5
    80003a76:	fffff097          	auipc	ra,0xfffff
    80003a7a:	580080e7          	jalr	1408(ra) # 80002ff6 <brelse>
  }
  return tot;
    80003a7e:	0009051b          	sext.w	a0,s2
}
    80003a82:	70a6                	ld	ra,104(sp)
    80003a84:	7406                	ld	s0,96(sp)
    80003a86:	64e6                	ld	s1,88(sp)
    80003a88:	6946                	ld	s2,80(sp)
    80003a8a:	69a6                	ld	s3,72(sp)
    80003a8c:	6a06                	ld	s4,64(sp)
    80003a8e:	7ae2                	ld	s5,56(sp)
    80003a90:	7b42                	ld	s6,48(sp)
    80003a92:	7ba2                	ld	s7,40(sp)
    80003a94:	7c02                	ld	s8,32(sp)
    80003a96:	6ce2                	ld	s9,24(sp)
    80003a98:	6d42                	ld	s10,16(sp)
    80003a9a:	6da2                	ld	s11,8(sp)
    80003a9c:	6165                	addi	sp,sp,112
    80003a9e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003aa0:	895a                	mv	s2,s6
    80003aa2:	bff1                	j	80003a7e <readi+0xcc>
    return 0;
    80003aa4:	4501                	li	a0,0
}
    80003aa6:	8082                	ret

0000000080003aa8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003aa8:	457c                	lw	a5,76(a0)
    80003aaa:	10d7e663          	bltu	a5,a3,80003bb6 <writei+0x10e>
{
    80003aae:	7159                	addi	sp,sp,-112
    80003ab0:	f486                	sd	ra,104(sp)
    80003ab2:	f0a2                	sd	s0,96(sp)
    80003ab4:	eca6                	sd	s1,88(sp)
    80003ab6:	e8ca                	sd	s2,80(sp)
    80003ab8:	e4ce                	sd	s3,72(sp)
    80003aba:	e0d2                	sd	s4,64(sp)
    80003abc:	fc56                	sd	s5,56(sp)
    80003abe:	f85a                	sd	s6,48(sp)
    80003ac0:	f45e                	sd	s7,40(sp)
    80003ac2:	f062                	sd	s8,32(sp)
    80003ac4:	ec66                	sd	s9,24(sp)
    80003ac6:	e86a                	sd	s10,16(sp)
    80003ac8:	e46e                	sd	s11,8(sp)
    80003aca:	1880                	addi	s0,sp,112
    80003acc:	8baa                	mv	s7,a0
    80003ace:	8c2e                	mv	s8,a1
    80003ad0:	8ab2                	mv	s5,a2
    80003ad2:	84b6                	mv	s1,a3
    80003ad4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ad6:	00e687bb          	addw	a5,a3,a4
    80003ada:	0ed7e063          	bltu	a5,a3,80003bba <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003ade:	00043737          	lui	a4,0x43
    80003ae2:	0cf76e63          	bltu	a4,a5,80003bbe <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ae6:	0a0b0763          	beqz	s6,80003b94 <writei+0xec>
    80003aea:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003aec:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003af0:	5cfd                	li	s9,-1
    80003af2:	a091                	j	80003b36 <writei+0x8e>
    80003af4:	02091d93          	slli	s11,s2,0x20
    80003af8:	020ddd93          	srli	s11,s11,0x20
    80003afc:	05898513          	addi	a0,s3,88
    80003b00:	86ee                	mv	a3,s11
    80003b02:	8656                	mv	a2,s5
    80003b04:	85e2                	mv	a1,s8
    80003b06:	953a                	add	a0,a0,a4
    80003b08:	fffff097          	auipc	ra,0xfffff
    80003b0c:	a36080e7          	jalr	-1482(ra) # 8000253e <either_copyin>
    80003b10:	07950263          	beq	a0,s9,80003b74 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003b14:	854e                	mv	a0,s3
    80003b16:	00000097          	auipc	ra,0x0
    80003b1a:	78a080e7          	jalr	1930(ra) # 800042a0 <log_write>
    brelse(bp);
    80003b1e:	854e                	mv	a0,s3
    80003b20:	fffff097          	auipc	ra,0xfffff
    80003b24:	4d6080e7          	jalr	1238(ra) # 80002ff6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b28:	01490a3b          	addw	s4,s2,s4
    80003b2c:	009904bb          	addw	s1,s2,s1
    80003b30:	9aee                	add	s5,s5,s11
    80003b32:	056a7663          	bleu	s6,s4,80003b7e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b36:	000ba903          	lw	s2,0(s7)
    80003b3a:	00a4d59b          	srliw	a1,s1,0xa
    80003b3e:	855e                	mv	a0,s7
    80003b40:	fffff097          	auipc	ra,0xfffff
    80003b44:	7ac080e7          	jalr	1964(ra) # 800032ec <bmap>
    80003b48:	0005059b          	sext.w	a1,a0
    80003b4c:	854a                	mv	a0,s2
    80003b4e:	fffff097          	auipc	ra,0xfffff
    80003b52:	366080e7          	jalr	870(ra) # 80002eb4 <bread>
    80003b56:	89aa                	mv	s3,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b58:	3ff4f713          	andi	a4,s1,1023
    80003b5c:	40ed07bb          	subw	a5,s10,a4
    80003b60:	414b06bb          	subw	a3,s6,s4
    80003b64:	893e                	mv	s2,a5
    80003b66:	2781                	sext.w	a5,a5
    80003b68:	0006861b          	sext.w	a2,a3
    80003b6c:	f8f674e3          	bleu	a5,a2,80003af4 <writei+0x4c>
    80003b70:	8936                	mv	s2,a3
    80003b72:	b749                	j	80003af4 <writei+0x4c>
      brelse(bp);
    80003b74:	854e                	mv	a0,s3
    80003b76:	fffff097          	auipc	ra,0xfffff
    80003b7a:	480080e7          	jalr	1152(ra) # 80002ff6 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003b7e:	04cba783          	lw	a5,76(s7)
    80003b82:	0097f463          	bleu	s1,a5,80003b8a <writei+0xe2>
      ip->size = off;
    80003b86:	049ba623          	sw	s1,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003b8a:	855e                	mv	a0,s7
    80003b8c:	00000097          	auipc	ra,0x0
    80003b90:	aa4080e7          	jalr	-1372(ra) # 80003630 <iupdate>
  }

  return n;
    80003b94:	000b051b          	sext.w	a0,s6
}
    80003b98:	70a6                	ld	ra,104(sp)
    80003b9a:	7406                	ld	s0,96(sp)
    80003b9c:	64e6                	ld	s1,88(sp)
    80003b9e:	6946                	ld	s2,80(sp)
    80003ba0:	69a6                	ld	s3,72(sp)
    80003ba2:	6a06                	ld	s4,64(sp)
    80003ba4:	7ae2                	ld	s5,56(sp)
    80003ba6:	7b42                	ld	s6,48(sp)
    80003ba8:	7ba2                	ld	s7,40(sp)
    80003baa:	7c02                	ld	s8,32(sp)
    80003bac:	6ce2                	ld	s9,24(sp)
    80003bae:	6d42                	ld	s10,16(sp)
    80003bb0:	6da2                	ld	s11,8(sp)
    80003bb2:	6165                	addi	sp,sp,112
    80003bb4:	8082                	ret
    return -1;
    80003bb6:	557d                	li	a0,-1
}
    80003bb8:	8082                	ret
    return -1;
    80003bba:	557d                	li	a0,-1
    80003bbc:	bff1                	j	80003b98 <writei+0xf0>
    return -1;
    80003bbe:	557d                	li	a0,-1
    80003bc0:	bfe1                	j	80003b98 <writei+0xf0>

0000000080003bc2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003bc2:	1141                	addi	sp,sp,-16
    80003bc4:	e406                	sd	ra,8(sp)
    80003bc6:	e022                	sd	s0,0(sp)
    80003bc8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003bca:	4639                	li	a2,14
    80003bcc:	ffffd097          	auipc	ra,0xffffd
    80003bd0:	27a080e7          	jalr	634(ra) # 80000e46 <strncmp>
}
    80003bd4:	60a2                	ld	ra,8(sp)
    80003bd6:	6402                	ld	s0,0(sp)
    80003bd8:	0141                	addi	sp,sp,16
    80003bda:	8082                	ret

0000000080003bdc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003bdc:	7139                	addi	sp,sp,-64
    80003bde:	fc06                	sd	ra,56(sp)
    80003be0:	f822                	sd	s0,48(sp)
    80003be2:	f426                	sd	s1,40(sp)
    80003be4:	f04a                	sd	s2,32(sp)
    80003be6:	ec4e                	sd	s3,24(sp)
    80003be8:	e852                	sd	s4,16(sp)
    80003bea:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003bec:	04451703          	lh	a4,68(a0)
    80003bf0:	4785                	li	a5,1
    80003bf2:	00f71a63          	bne	a4,a5,80003c06 <dirlookup+0x2a>
    80003bf6:	892a                	mv	s2,a0
    80003bf8:	89ae                	mv	s3,a1
    80003bfa:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bfc:	457c                	lw	a5,76(a0)
    80003bfe:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c00:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c02:	e79d                	bnez	a5,80003c30 <dirlookup+0x54>
    80003c04:	a8a5                	j	80003c7c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c06:	00005517          	auipc	a0,0x5
    80003c0a:	9c250513          	addi	a0,a0,-1598 # 800085c8 <syscalls+0x1c8>
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	966080e7          	jalr	-1690(ra) # 80000574 <panic>
      panic("dirlookup read");
    80003c16:	00005517          	auipc	a0,0x5
    80003c1a:	9ca50513          	addi	a0,a0,-1590 # 800085e0 <syscalls+0x1e0>
    80003c1e:	ffffd097          	auipc	ra,0xffffd
    80003c22:	956080e7          	jalr	-1706(ra) # 80000574 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c26:	24c1                	addiw	s1,s1,16
    80003c28:	04c92783          	lw	a5,76(s2)
    80003c2c:	04f4f763          	bleu	a5,s1,80003c7a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c30:	4741                	li	a4,16
    80003c32:	86a6                	mv	a3,s1
    80003c34:	fc040613          	addi	a2,s0,-64
    80003c38:	4581                	li	a1,0
    80003c3a:	854a                	mv	a0,s2
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	d76080e7          	jalr	-650(ra) # 800039b2 <readi>
    80003c44:	47c1                	li	a5,16
    80003c46:	fcf518e3          	bne	a0,a5,80003c16 <dirlookup+0x3a>
    if(de.inum == 0)
    80003c4a:	fc045783          	lhu	a5,-64(s0)
    80003c4e:	dfe1                	beqz	a5,80003c26 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c50:	fc240593          	addi	a1,s0,-62
    80003c54:	854e                	mv	a0,s3
    80003c56:	00000097          	auipc	ra,0x0
    80003c5a:	f6c080e7          	jalr	-148(ra) # 80003bc2 <namecmp>
    80003c5e:	f561                	bnez	a0,80003c26 <dirlookup+0x4a>
      if(poff)
    80003c60:	000a0463          	beqz	s4,80003c68 <dirlookup+0x8c>
        *poff = off;
    80003c64:	009a2023          	sw	s1,0(s4) # 2000 <_entry-0x7fffe000>
      return iget(dp->dev, inum);
    80003c68:	fc045583          	lhu	a1,-64(s0)
    80003c6c:	00092503          	lw	a0,0(s2)
    80003c70:	fffff097          	auipc	ra,0xfffff
    80003c74:	756080e7          	jalr	1878(ra) # 800033c6 <iget>
    80003c78:	a011                	j	80003c7c <dirlookup+0xa0>
  return 0;
    80003c7a:	4501                	li	a0,0
}
    80003c7c:	70e2                	ld	ra,56(sp)
    80003c7e:	7442                	ld	s0,48(sp)
    80003c80:	74a2                	ld	s1,40(sp)
    80003c82:	7902                	ld	s2,32(sp)
    80003c84:	69e2                	ld	s3,24(sp)
    80003c86:	6a42                	ld	s4,16(sp)
    80003c88:	6121                	addi	sp,sp,64
    80003c8a:	8082                	ret

0000000080003c8c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003c8c:	711d                	addi	sp,sp,-96
    80003c8e:	ec86                	sd	ra,88(sp)
    80003c90:	e8a2                	sd	s0,80(sp)
    80003c92:	e4a6                	sd	s1,72(sp)
    80003c94:	e0ca                	sd	s2,64(sp)
    80003c96:	fc4e                	sd	s3,56(sp)
    80003c98:	f852                	sd	s4,48(sp)
    80003c9a:	f456                	sd	s5,40(sp)
    80003c9c:	f05a                	sd	s6,32(sp)
    80003c9e:	ec5e                	sd	s7,24(sp)
    80003ca0:	e862                	sd	s8,16(sp)
    80003ca2:	e466                	sd	s9,8(sp)
    80003ca4:	1080                	addi	s0,sp,96
    80003ca6:	84aa                	mv	s1,a0
    80003ca8:	8bae                	mv	s7,a1
    80003caa:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003cac:	00054703          	lbu	a4,0(a0)
    80003cb0:	02f00793          	li	a5,47
    80003cb4:	02f70363          	beq	a4,a5,80003cda <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003cb8:	ffffe097          	auipc	ra,0xffffe
    80003cbc:	db8080e7          	jalr	-584(ra) # 80001a70 <myproc>
    80003cc0:	15053503          	ld	a0,336(a0)
    80003cc4:	00000097          	auipc	ra,0x0
    80003cc8:	9fa080e7          	jalr	-1542(ra) # 800036be <idup>
    80003ccc:	89aa                	mv	s3,a0
  while(*path == '/')
    80003cce:	02f00913          	li	s2,47
  len = path - s;
    80003cd2:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003cd4:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003cd6:	4c05                	li	s8,1
    80003cd8:	a865                	j	80003d90 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003cda:	4585                	li	a1,1
    80003cdc:	4505                	li	a0,1
    80003cde:	fffff097          	auipc	ra,0xfffff
    80003ce2:	6e8080e7          	jalr	1768(ra) # 800033c6 <iget>
    80003ce6:	89aa                	mv	s3,a0
    80003ce8:	b7dd                	j	80003cce <namex+0x42>
      iunlockput(ip);
    80003cea:	854e                	mv	a0,s3
    80003cec:	00000097          	auipc	ra,0x0
    80003cf0:	c74080e7          	jalr	-908(ra) # 80003960 <iunlockput>
      return 0;
    80003cf4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003cf6:	854e                	mv	a0,s3
    80003cf8:	60e6                	ld	ra,88(sp)
    80003cfa:	6446                	ld	s0,80(sp)
    80003cfc:	64a6                	ld	s1,72(sp)
    80003cfe:	6906                	ld	s2,64(sp)
    80003d00:	79e2                	ld	s3,56(sp)
    80003d02:	7a42                	ld	s4,48(sp)
    80003d04:	7aa2                	ld	s5,40(sp)
    80003d06:	7b02                	ld	s6,32(sp)
    80003d08:	6be2                	ld	s7,24(sp)
    80003d0a:	6c42                	ld	s8,16(sp)
    80003d0c:	6ca2                	ld	s9,8(sp)
    80003d0e:	6125                	addi	sp,sp,96
    80003d10:	8082                	ret
      iunlock(ip);
    80003d12:	854e                	mv	a0,s3
    80003d14:	00000097          	auipc	ra,0x0
    80003d18:	aac080e7          	jalr	-1364(ra) # 800037c0 <iunlock>
      return ip;
    80003d1c:	bfe9                	j	80003cf6 <namex+0x6a>
      iunlockput(ip);
    80003d1e:	854e                	mv	a0,s3
    80003d20:	00000097          	auipc	ra,0x0
    80003d24:	c40080e7          	jalr	-960(ra) # 80003960 <iunlockput>
      return 0;
    80003d28:	89d2                	mv	s3,s4
    80003d2a:	b7f1                	j	80003cf6 <namex+0x6a>
  len = path - s;
    80003d2c:	40b48633          	sub	a2,s1,a1
    80003d30:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003d34:	094cd663          	ble	s4,s9,80003dc0 <namex+0x134>
    memmove(name, s, DIRSIZ);
    80003d38:	4639                	li	a2,14
    80003d3a:	8556                	mv	a0,s5
    80003d3c:	ffffd097          	auipc	ra,0xffffd
    80003d40:	08e080e7          	jalr	142(ra) # 80000dca <memmove>
  while(*path == '/')
    80003d44:	0004c783          	lbu	a5,0(s1)
    80003d48:	01279763          	bne	a5,s2,80003d56 <namex+0xca>
    path++;
    80003d4c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d4e:	0004c783          	lbu	a5,0(s1)
    80003d52:	ff278de3          	beq	a5,s2,80003d4c <namex+0xc0>
    ilock(ip);
    80003d56:	854e                	mv	a0,s3
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	9a4080e7          	jalr	-1628(ra) # 800036fc <ilock>
    if(ip->type != T_DIR){
    80003d60:	04499783          	lh	a5,68(s3)
    80003d64:	f98793e3          	bne	a5,s8,80003cea <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003d68:	000b8563          	beqz	s7,80003d72 <namex+0xe6>
    80003d6c:	0004c783          	lbu	a5,0(s1)
    80003d70:	d3cd                	beqz	a5,80003d12 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003d72:	865a                	mv	a2,s6
    80003d74:	85d6                	mv	a1,s5
    80003d76:	854e                	mv	a0,s3
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	e64080e7          	jalr	-412(ra) # 80003bdc <dirlookup>
    80003d80:	8a2a                	mv	s4,a0
    80003d82:	dd51                	beqz	a0,80003d1e <namex+0x92>
    iunlockput(ip);
    80003d84:	854e                	mv	a0,s3
    80003d86:	00000097          	auipc	ra,0x0
    80003d8a:	bda080e7          	jalr	-1062(ra) # 80003960 <iunlockput>
    ip = next;
    80003d8e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003d90:	0004c783          	lbu	a5,0(s1)
    80003d94:	05279d63          	bne	a5,s2,80003dee <namex+0x162>
    path++;
    80003d98:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d9a:	0004c783          	lbu	a5,0(s1)
    80003d9e:	ff278de3          	beq	a5,s2,80003d98 <namex+0x10c>
  if(*path == 0)
    80003da2:	cf8d                	beqz	a5,80003ddc <namex+0x150>
  while(*path != '/' && *path != 0)
    80003da4:	01278b63          	beq	a5,s2,80003dba <namex+0x12e>
    80003da8:	c795                	beqz	a5,80003dd4 <namex+0x148>
    path++;
    80003daa:	85a6                	mv	a1,s1
    path++;
    80003dac:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003dae:	0004c783          	lbu	a5,0(s1)
    80003db2:	f7278de3          	beq	a5,s2,80003d2c <namex+0xa0>
    80003db6:	fbfd                	bnez	a5,80003dac <namex+0x120>
    80003db8:	bf95                	j	80003d2c <namex+0xa0>
    80003dba:	85a6                	mv	a1,s1
  len = path - s;
    80003dbc:	8a5a                	mv	s4,s6
    80003dbe:	865a                	mv	a2,s6
    memmove(name, s, len);
    80003dc0:	2601                	sext.w	a2,a2
    80003dc2:	8556                	mv	a0,s5
    80003dc4:	ffffd097          	auipc	ra,0xffffd
    80003dc8:	006080e7          	jalr	6(ra) # 80000dca <memmove>
    name[len] = 0;
    80003dcc:	9a56                	add	s4,s4,s5
    80003dce:	000a0023          	sb	zero,0(s4)
    80003dd2:	bf8d                	j	80003d44 <namex+0xb8>
  while(*path != '/' && *path != 0)
    80003dd4:	85a6                	mv	a1,s1
  len = path - s;
    80003dd6:	8a5a                	mv	s4,s6
    80003dd8:	865a                	mv	a2,s6
    80003dda:	b7dd                	j	80003dc0 <namex+0x134>
  if(nameiparent){
    80003ddc:	f00b8de3          	beqz	s7,80003cf6 <namex+0x6a>
    iput(ip);
    80003de0:	854e                	mv	a0,s3
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	ad6080e7          	jalr	-1322(ra) # 800038b8 <iput>
    return 0;
    80003dea:	4981                	li	s3,0
    80003dec:	b729                	j	80003cf6 <namex+0x6a>
  if(*path == 0)
    80003dee:	d7fd                	beqz	a5,80003ddc <namex+0x150>
    80003df0:	85a6                	mv	a1,s1
    80003df2:	bf6d                	j	80003dac <namex+0x120>

0000000080003df4 <dirlink>:
{
    80003df4:	7139                	addi	sp,sp,-64
    80003df6:	fc06                	sd	ra,56(sp)
    80003df8:	f822                	sd	s0,48(sp)
    80003dfa:	f426                	sd	s1,40(sp)
    80003dfc:	f04a                	sd	s2,32(sp)
    80003dfe:	ec4e                	sd	s3,24(sp)
    80003e00:	e852                	sd	s4,16(sp)
    80003e02:	0080                	addi	s0,sp,64
    80003e04:	892a                	mv	s2,a0
    80003e06:	8a2e                	mv	s4,a1
    80003e08:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e0a:	4601                	li	a2,0
    80003e0c:	00000097          	auipc	ra,0x0
    80003e10:	dd0080e7          	jalr	-560(ra) # 80003bdc <dirlookup>
    80003e14:	e93d                	bnez	a0,80003e8a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e16:	04c92483          	lw	s1,76(s2)
    80003e1a:	c49d                	beqz	s1,80003e48 <dirlink+0x54>
    80003e1c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e1e:	4741                	li	a4,16
    80003e20:	86a6                	mv	a3,s1
    80003e22:	fc040613          	addi	a2,s0,-64
    80003e26:	4581                	li	a1,0
    80003e28:	854a                	mv	a0,s2
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	b88080e7          	jalr	-1144(ra) # 800039b2 <readi>
    80003e32:	47c1                	li	a5,16
    80003e34:	06f51163          	bne	a0,a5,80003e96 <dirlink+0xa2>
    if(de.inum == 0)
    80003e38:	fc045783          	lhu	a5,-64(s0)
    80003e3c:	c791                	beqz	a5,80003e48 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e3e:	24c1                	addiw	s1,s1,16
    80003e40:	04c92783          	lw	a5,76(s2)
    80003e44:	fcf4ede3          	bltu	s1,a5,80003e1e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e48:	4639                	li	a2,14
    80003e4a:	85d2                	mv	a1,s4
    80003e4c:	fc240513          	addi	a0,s0,-62
    80003e50:	ffffd097          	auipc	ra,0xffffd
    80003e54:	046080e7          	jalr	70(ra) # 80000e96 <strncpy>
  de.inum = inum;
    80003e58:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e5c:	4741                	li	a4,16
    80003e5e:	86a6                	mv	a3,s1
    80003e60:	fc040613          	addi	a2,s0,-64
    80003e64:	4581                	li	a1,0
    80003e66:	854a                	mv	a0,s2
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	c40080e7          	jalr	-960(ra) # 80003aa8 <writei>
    80003e70:	4741                	li	a4,16
  return 0;
    80003e72:	4781                	li	a5,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e74:	02e51963          	bne	a0,a4,80003ea6 <dirlink+0xb2>
}
    80003e78:	853e                	mv	a0,a5
    80003e7a:	70e2                	ld	ra,56(sp)
    80003e7c:	7442                	ld	s0,48(sp)
    80003e7e:	74a2                	ld	s1,40(sp)
    80003e80:	7902                	ld	s2,32(sp)
    80003e82:	69e2                	ld	s3,24(sp)
    80003e84:	6a42                	ld	s4,16(sp)
    80003e86:	6121                	addi	sp,sp,64
    80003e88:	8082                	ret
    iput(ip);
    80003e8a:	00000097          	auipc	ra,0x0
    80003e8e:	a2e080e7          	jalr	-1490(ra) # 800038b8 <iput>
    return -1;
    80003e92:	57fd                	li	a5,-1
    80003e94:	b7d5                	j	80003e78 <dirlink+0x84>
      panic("dirlink read");
    80003e96:	00004517          	auipc	a0,0x4
    80003e9a:	75a50513          	addi	a0,a0,1882 # 800085f0 <syscalls+0x1f0>
    80003e9e:	ffffc097          	auipc	ra,0xffffc
    80003ea2:	6d6080e7          	jalr	1750(ra) # 80000574 <panic>
    panic("dirlink");
    80003ea6:	00005517          	auipc	a0,0x5
    80003eaa:	86a50513          	addi	a0,a0,-1942 # 80008710 <syscalls+0x310>
    80003eae:	ffffc097          	auipc	ra,0xffffc
    80003eb2:	6c6080e7          	jalr	1734(ra) # 80000574 <panic>

0000000080003eb6 <namei>:

struct inode*
namei(char *path)
{
    80003eb6:	1101                	addi	sp,sp,-32
    80003eb8:	ec06                	sd	ra,24(sp)
    80003eba:	e822                	sd	s0,16(sp)
    80003ebc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003ebe:	fe040613          	addi	a2,s0,-32
    80003ec2:	4581                	li	a1,0
    80003ec4:	00000097          	auipc	ra,0x0
    80003ec8:	dc8080e7          	jalr	-568(ra) # 80003c8c <namex>
}
    80003ecc:	60e2                	ld	ra,24(sp)
    80003ece:	6442                	ld	s0,16(sp)
    80003ed0:	6105                	addi	sp,sp,32
    80003ed2:	8082                	ret

0000000080003ed4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003ed4:	1141                	addi	sp,sp,-16
    80003ed6:	e406                	sd	ra,8(sp)
    80003ed8:	e022                	sd	s0,0(sp)
    80003eda:	0800                	addi	s0,sp,16
  return namex(path, 1, name);
    80003edc:	862e                	mv	a2,a1
    80003ede:	4585                	li	a1,1
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	dac080e7          	jalr	-596(ra) # 80003c8c <namex>
}
    80003ee8:	60a2                	ld	ra,8(sp)
    80003eea:	6402                	ld	s0,0(sp)
    80003eec:	0141                	addi	sp,sp,16
    80003eee:	8082                	ret

0000000080003ef0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003ef0:	1101                	addi	sp,sp,-32
    80003ef2:	ec06                	sd	ra,24(sp)
    80003ef4:	e822                	sd	s0,16(sp)
    80003ef6:	e426                	sd	s1,8(sp)
    80003ef8:	e04a                	sd	s2,0(sp)
    80003efa:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003efc:	0001e917          	auipc	s2,0x1e
    80003f00:	a0c90913          	addi	s2,s2,-1524 # 80021908 <log>
    80003f04:	01892583          	lw	a1,24(s2)
    80003f08:	02892503          	lw	a0,40(s2)
    80003f0c:	fffff097          	auipc	ra,0xfffff
    80003f10:	fa8080e7          	jalr	-88(ra) # 80002eb4 <bread>
    80003f14:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f16:	02c92683          	lw	a3,44(s2)
    80003f1a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f1c:	02d05763          	blez	a3,80003f4a <write_head+0x5a>
    80003f20:	0001e797          	auipc	a5,0x1e
    80003f24:	a1878793          	addi	a5,a5,-1512 # 80021938 <log+0x30>
    80003f28:	05c50713          	addi	a4,a0,92
    80003f2c:	36fd                	addiw	a3,a3,-1
    80003f2e:	1682                	slli	a3,a3,0x20
    80003f30:	9281                	srli	a3,a3,0x20
    80003f32:	068a                	slli	a3,a3,0x2
    80003f34:	0001e617          	auipc	a2,0x1e
    80003f38:	a0860613          	addi	a2,a2,-1528 # 8002193c <log+0x34>
    80003f3c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003f3e:	4390                	lw	a2,0(a5)
    80003f40:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f42:	0791                	addi	a5,a5,4
    80003f44:	0711                	addi	a4,a4,4
    80003f46:	fed79ce3          	bne	a5,a3,80003f3e <write_head+0x4e>
  }
  bwrite(buf);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	fffff097          	auipc	ra,0xfffff
    80003f50:	06c080e7          	jalr	108(ra) # 80002fb8 <bwrite>
  brelse(buf);
    80003f54:	8526                	mv	a0,s1
    80003f56:	fffff097          	auipc	ra,0xfffff
    80003f5a:	0a0080e7          	jalr	160(ra) # 80002ff6 <brelse>
}
    80003f5e:	60e2                	ld	ra,24(sp)
    80003f60:	6442                	ld	s0,16(sp)
    80003f62:	64a2                	ld	s1,8(sp)
    80003f64:	6902                	ld	s2,0(sp)
    80003f66:	6105                	addi	sp,sp,32
    80003f68:	8082                	ret

0000000080003f6a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f6a:	0001e797          	auipc	a5,0x1e
    80003f6e:	99e78793          	addi	a5,a5,-1634 # 80021908 <log>
    80003f72:	57dc                	lw	a5,44(a5)
    80003f74:	0af05663          	blez	a5,80004020 <install_trans+0xb6>
{
    80003f78:	7139                	addi	sp,sp,-64
    80003f7a:	fc06                	sd	ra,56(sp)
    80003f7c:	f822                	sd	s0,48(sp)
    80003f7e:	f426                	sd	s1,40(sp)
    80003f80:	f04a                	sd	s2,32(sp)
    80003f82:	ec4e                	sd	s3,24(sp)
    80003f84:	e852                	sd	s4,16(sp)
    80003f86:	e456                	sd	s5,8(sp)
    80003f88:	0080                	addi	s0,sp,64
    80003f8a:	0001ea17          	auipc	s4,0x1e
    80003f8e:	9aea0a13          	addi	s4,s4,-1618 # 80021938 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f92:	4981                	li	s3,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003f94:	0001e917          	auipc	s2,0x1e
    80003f98:	97490913          	addi	s2,s2,-1676 # 80021908 <log>
    80003f9c:	01892583          	lw	a1,24(s2)
    80003fa0:	013585bb          	addw	a1,a1,s3
    80003fa4:	2585                	addiw	a1,a1,1
    80003fa6:	02892503          	lw	a0,40(s2)
    80003faa:	fffff097          	auipc	ra,0xfffff
    80003fae:	f0a080e7          	jalr	-246(ra) # 80002eb4 <bread>
    80003fb2:	8aaa                	mv	s5,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003fb4:	000a2583          	lw	a1,0(s4)
    80003fb8:	02892503          	lw	a0,40(s2)
    80003fbc:	fffff097          	auipc	ra,0xfffff
    80003fc0:	ef8080e7          	jalr	-264(ra) # 80002eb4 <bread>
    80003fc4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003fc6:	40000613          	li	a2,1024
    80003fca:	058a8593          	addi	a1,s5,88
    80003fce:	05850513          	addi	a0,a0,88
    80003fd2:	ffffd097          	auipc	ra,0xffffd
    80003fd6:	df8080e7          	jalr	-520(ra) # 80000dca <memmove>
    bwrite(dbuf);  // write dst to disk
    80003fda:	8526                	mv	a0,s1
    80003fdc:	fffff097          	auipc	ra,0xfffff
    80003fe0:	fdc080e7          	jalr	-36(ra) # 80002fb8 <bwrite>
    bunpin(dbuf);
    80003fe4:	8526                	mv	a0,s1
    80003fe6:	fffff097          	auipc	ra,0xfffff
    80003fea:	0ea080e7          	jalr	234(ra) # 800030d0 <bunpin>
    brelse(lbuf);
    80003fee:	8556                	mv	a0,s5
    80003ff0:	fffff097          	auipc	ra,0xfffff
    80003ff4:	006080e7          	jalr	6(ra) # 80002ff6 <brelse>
    brelse(dbuf);
    80003ff8:	8526                	mv	a0,s1
    80003ffa:	fffff097          	auipc	ra,0xfffff
    80003ffe:	ffc080e7          	jalr	-4(ra) # 80002ff6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004002:	2985                	addiw	s3,s3,1
    80004004:	0a11                	addi	s4,s4,4
    80004006:	02c92783          	lw	a5,44(s2)
    8000400a:	f8f9c9e3          	blt	s3,a5,80003f9c <install_trans+0x32>
}
    8000400e:	70e2                	ld	ra,56(sp)
    80004010:	7442                	ld	s0,48(sp)
    80004012:	74a2                	ld	s1,40(sp)
    80004014:	7902                	ld	s2,32(sp)
    80004016:	69e2                	ld	s3,24(sp)
    80004018:	6a42                	ld	s4,16(sp)
    8000401a:	6aa2                	ld	s5,8(sp)
    8000401c:	6121                	addi	sp,sp,64
    8000401e:	8082                	ret
    80004020:	8082                	ret

0000000080004022 <initlog>:
{
    80004022:	7179                	addi	sp,sp,-48
    80004024:	f406                	sd	ra,40(sp)
    80004026:	f022                	sd	s0,32(sp)
    80004028:	ec26                	sd	s1,24(sp)
    8000402a:	e84a                	sd	s2,16(sp)
    8000402c:	e44e                	sd	s3,8(sp)
    8000402e:	1800                	addi	s0,sp,48
    80004030:	892a                	mv	s2,a0
    80004032:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004034:	0001e497          	auipc	s1,0x1e
    80004038:	8d448493          	addi	s1,s1,-1836 # 80021908 <log>
    8000403c:	00004597          	auipc	a1,0x4
    80004040:	5c458593          	addi	a1,a1,1476 # 80008600 <syscalls+0x200>
    80004044:	8526                	mv	a0,s1
    80004046:	ffffd097          	auipc	ra,0xffffd
    8000404a:	b8c080e7          	jalr	-1140(ra) # 80000bd2 <initlock>
  log.start = sb->logstart;
    8000404e:	0149a583          	lw	a1,20(s3)
    80004052:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004054:	0109a783          	lw	a5,16(s3)
    80004058:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000405a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000405e:	854a                	mv	a0,s2
    80004060:	fffff097          	auipc	ra,0xfffff
    80004064:	e54080e7          	jalr	-428(ra) # 80002eb4 <bread>
  log.lh.n = lh->n;
    80004068:	4d3c                	lw	a5,88(a0)
    8000406a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000406c:	02f05563          	blez	a5,80004096 <initlog+0x74>
    80004070:	05c50713          	addi	a4,a0,92
    80004074:	0001e697          	auipc	a3,0x1e
    80004078:	8c468693          	addi	a3,a3,-1852 # 80021938 <log+0x30>
    8000407c:	37fd                	addiw	a5,a5,-1
    8000407e:	1782                	slli	a5,a5,0x20
    80004080:	9381                	srli	a5,a5,0x20
    80004082:	078a                	slli	a5,a5,0x2
    80004084:	06050613          	addi	a2,a0,96
    80004088:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000408a:	4310                	lw	a2,0(a4)
    8000408c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000408e:	0711                	addi	a4,a4,4
    80004090:	0691                	addi	a3,a3,4
    80004092:	fef71ce3          	bne	a4,a5,8000408a <initlog+0x68>
  brelse(buf);
    80004096:	fffff097          	auipc	ra,0xfffff
    8000409a:	f60080e7          	jalr	-160(ra) # 80002ff6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    8000409e:	00000097          	auipc	ra,0x0
    800040a2:	ecc080e7          	jalr	-308(ra) # 80003f6a <install_trans>
  log.lh.n = 0;
    800040a6:	0001e797          	auipc	a5,0x1e
    800040aa:	8807a723          	sw	zero,-1906(a5) # 80021934 <log+0x2c>
  write_head(); // clear the log
    800040ae:	00000097          	auipc	ra,0x0
    800040b2:	e42080e7          	jalr	-446(ra) # 80003ef0 <write_head>
}
    800040b6:	70a2                	ld	ra,40(sp)
    800040b8:	7402                	ld	s0,32(sp)
    800040ba:	64e2                	ld	s1,24(sp)
    800040bc:	6942                	ld	s2,16(sp)
    800040be:	69a2                	ld	s3,8(sp)
    800040c0:	6145                	addi	sp,sp,48
    800040c2:	8082                	ret

00000000800040c4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040c4:	1101                	addi	sp,sp,-32
    800040c6:	ec06                	sd	ra,24(sp)
    800040c8:	e822                	sd	s0,16(sp)
    800040ca:	e426                	sd	s1,8(sp)
    800040cc:	e04a                	sd	s2,0(sp)
    800040ce:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800040d0:	0001e517          	auipc	a0,0x1e
    800040d4:	83850513          	addi	a0,a0,-1992 # 80021908 <log>
    800040d8:	ffffd097          	auipc	ra,0xffffd
    800040dc:	b8a080e7          	jalr	-1142(ra) # 80000c62 <acquire>
  while(1){
    if(log.committing){
    800040e0:	0001e497          	auipc	s1,0x1e
    800040e4:	82848493          	addi	s1,s1,-2008 # 80021908 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040e8:	4979                	li	s2,30
    800040ea:	a039                	j	800040f8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800040ec:	85a6                	mv	a1,s1
    800040ee:	8526                	mv	a0,s1
    800040f0:	ffffe097          	auipc	ra,0xffffe
    800040f4:	196080e7          	jalr	406(ra) # 80002286 <sleep>
    if(log.committing){
    800040f8:	50dc                	lw	a5,36(s1)
    800040fa:	fbed                	bnez	a5,800040ec <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040fc:	509c                	lw	a5,32(s1)
    800040fe:	0017871b          	addiw	a4,a5,1
    80004102:	0007069b          	sext.w	a3,a4
    80004106:	0027179b          	slliw	a5,a4,0x2
    8000410a:	9fb9                	addw	a5,a5,a4
    8000410c:	0017979b          	slliw	a5,a5,0x1
    80004110:	54d8                	lw	a4,44(s1)
    80004112:	9fb9                	addw	a5,a5,a4
    80004114:	00f95963          	ble	a5,s2,80004126 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004118:	85a6                	mv	a1,s1
    8000411a:	8526                	mv	a0,s1
    8000411c:	ffffe097          	auipc	ra,0xffffe
    80004120:	16a080e7          	jalr	362(ra) # 80002286 <sleep>
    80004124:	bfd1                	j	800040f8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004126:	0001d517          	auipc	a0,0x1d
    8000412a:	7e250513          	addi	a0,a0,2018 # 80021908 <log>
    8000412e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004130:	ffffd097          	auipc	ra,0xffffd
    80004134:	be6080e7          	jalr	-1050(ra) # 80000d16 <release>
      break;
    }
  }
}
    80004138:	60e2                	ld	ra,24(sp)
    8000413a:	6442                	ld	s0,16(sp)
    8000413c:	64a2                	ld	s1,8(sp)
    8000413e:	6902                	ld	s2,0(sp)
    80004140:	6105                	addi	sp,sp,32
    80004142:	8082                	ret

0000000080004144 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004144:	7139                	addi	sp,sp,-64
    80004146:	fc06                	sd	ra,56(sp)
    80004148:	f822                	sd	s0,48(sp)
    8000414a:	f426                	sd	s1,40(sp)
    8000414c:	f04a                	sd	s2,32(sp)
    8000414e:	ec4e                	sd	s3,24(sp)
    80004150:	e852                	sd	s4,16(sp)
    80004152:	e456                	sd	s5,8(sp)
    80004154:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004156:	0001d917          	auipc	s2,0x1d
    8000415a:	7b290913          	addi	s2,s2,1970 # 80021908 <log>
    8000415e:	854a                	mv	a0,s2
    80004160:	ffffd097          	auipc	ra,0xffffd
    80004164:	b02080e7          	jalr	-1278(ra) # 80000c62 <acquire>
  log.outstanding -= 1;
    80004168:	02092783          	lw	a5,32(s2)
    8000416c:	37fd                	addiw	a5,a5,-1
    8000416e:	0007849b          	sext.w	s1,a5
    80004172:	02f92023          	sw	a5,32(s2)
  if(log.committing)
    80004176:	02492783          	lw	a5,36(s2)
    8000417a:	eba1                	bnez	a5,800041ca <end_op+0x86>
    panic("log.committing");
  if(log.outstanding == 0){
    8000417c:	ecb9                	bnez	s1,800041da <end_op+0x96>
    do_commit = 1;
    log.committing = 1;
    8000417e:	0001d917          	auipc	s2,0x1d
    80004182:	78a90913          	addi	s2,s2,1930 # 80021908 <log>
    80004186:	4785                	li	a5,1
    80004188:	02f92223          	sw	a5,36(s2)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000418c:	854a                	mv	a0,s2
    8000418e:	ffffd097          	auipc	ra,0xffffd
    80004192:	b88080e7          	jalr	-1144(ra) # 80000d16 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004196:	02c92783          	lw	a5,44(s2)
    8000419a:	06f04763          	bgtz	a5,80004208 <end_op+0xc4>
    acquire(&log.lock);
    8000419e:	0001d497          	auipc	s1,0x1d
    800041a2:	76a48493          	addi	s1,s1,1898 # 80021908 <log>
    800041a6:	8526                	mv	a0,s1
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	aba080e7          	jalr	-1350(ra) # 80000c62 <acquire>
    log.committing = 0;
    800041b0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800041b4:	8526                	mv	a0,s1
    800041b6:	ffffe097          	auipc	ra,0xffffe
    800041ba:	256080e7          	jalr	598(ra) # 8000240c <wakeup>
    release(&log.lock);
    800041be:	8526                	mv	a0,s1
    800041c0:	ffffd097          	auipc	ra,0xffffd
    800041c4:	b56080e7          	jalr	-1194(ra) # 80000d16 <release>
}
    800041c8:	a03d                	j	800041f6 <end_op+0xb2>
    panic("log.committing");
    800041ca:	00004517          	auipc	a0,0x4
    800041ce:	43e50513          	addi	a0,a0,1086 # 80008608 <syscalls+0x208>
    800041d2:	ffffc097          	auipc	ra,0xffffc
    800041d6:	3a2080e7          	jalr	930(ra) # 80000574 <panic>
    wakeup(&log);
    800041da:	0001d497          	auipc	s1,0x1d
    800041de:	72e48493          	addi	s1,s1,1838 # 80021908 <log>
    800041e2:	8526                	mv	a0,s1
    800041e4:	ffffe097          	auipc	ra,0xffffe
    800041e8:	228080e7          	jalr	552(ra) # 8000240c <wakeup>
  release(&log.lock);
    800041ec:	8526                	mv	a0,s1
    800041ee:	ffffd097          	auipc	ra,0xffffd
    800041f2:	b28080e7          	jalr	-1240(ra) # 80000d16 <release>
}
    800041f6:	70e2                	ld	ra,56(sp)
    800041f8:	7442                	ld	s0,48(sp)
    800041fa:	74a2                	ld	s1,40(sp)
    800041fc:	7902                	ld	s2,32(sp)
    800041fe:	69e2                	ld	s3,24(sp)
    80004200:	6a42                	ld	s4,16(sp)
    80004202:	6aa2                	ld	s5,8(sp)
    80004204:	6121                	addi	sp,sp,64
    80004206:	8082                	ret
    80004208:	0001da17          	auipc	s4,0x1d
    8000420c:	730a0a13          	addi	s4,s4,1840 # 80021938 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004210:	0001d917          	auipc	s2,0x1d
    80004214:	6f890913          	addi	s2,s2,1784 # 80021908 <log>
    80004218:	01892583          	lw	a1,24(s2)
    8000421c:	9da5                	addw	a1,a1,s1
    8000421e:	2585                	addiw	a1,a1,1
    80004220:	02892503          	lw	a0,40(s2)
    80004224:	fffff097          	auipc	ra,0xfffff
    80004228:	c90080e7          	jalr	-880(ra) # 80002eb4 <bread>
    8000422c:	89aa                	mv	s3,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000422e:	000a2583          	lw	a1,0(s4)
    80004232:	02892503          	lw	a0,40(s2)
    80004236:	fffff097          	auipc	ra,0xfffff
    8000423a:	c7e080e7          	jalr	-898(ra) # 80002eb4 <bread>
    8000423e:	8aaa                	mv	s5,a0
    memmove(to->data, from->data, BSIZE);
    80004240:	40000613          	li	a2,1024
    80004244:	05850593          	addi	a1,a0,88
    80004248:	05898513          	addi	a0,s3,88
    8000424c:	ffffd097          	auipc	ra,0xffffd
    80004250:	b7e080e7          	jalr	-1154(ra) # 80000dca <memmove>
    bwrite(to);  // write the log
    80004254:	854e                	mv	a0,s3
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	d62080e7          	jalr	-670(ra) # 80002fb8 <bwrite>
    brelse(from);
    8000425e:	8556                	mv	a0,s5
    80004260:	fffff097          	auipc	ra,0xfffff
    80004264:	d96080e7          	jalr	-618(ra) # 80002ff6 <brelse>
    brelse(to);
    80004268:	854e                	mv	a0,s3
    8000426a:	fffff097          	auipc	ra,0xfffff
    8000426e:	d8c080e7          	jalr	-628(ra) # 80002ff6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004272:	2485                	addiw	s1,s1,1
    80004274:	0a11                	addi	s4,s4,4
    80004276:	02c92783          	lw	a5,44(s2)
    8000427a:	f8f4cfe3          	blt	s1,a5,80004218 <end_op+0xd4>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000427e:	00000097          	auipc	ra,0x0
    80004282:	c72080e7          	jalr	-910(ra) # 80003ef0 <write_head>
    install_trans(); // Now install writes to home locations
    80004286:	00000097          	auipc	ra,0x0
    8000428a:	ce4080e7          	jalr	-796(ra) # 80003f6a <install_trans>
    log.lh.n = 0;
    8000428e:	0001d797          	auipc	a5,0x1d
    80004292:	6a07a323          	sw	zero,1702(a5) # 80021934 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004296:	00000097          	auipc	ra,0x0
    8000429a:	c5a080e7          	jalr	-934(ra) # 80003ef0 <write_head>
    8000429e:	b701                	j	8000419e <end_op+0x5a>

00000000800042a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800042a0:	1101                	addi	sp,sp,-32
    800042a2:	ec06                	sd	ra,24(sp)
    800042a4:	e822                	sd	s0,16(sp)
    800042a6:	e426                	sd	s1,8(sp)
    800042a8:	e04a                	sd	s2,0(sp)
    800042aa:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800042ac:	0001d797          	auipc	a5,0x1d
    800042b0:	65c78793          	addi	a5,a5,1628 # 80021908 <log>
    800042b4:	57d8                	lw	a4,44(a5)
    800042b6:	47f5                	li	a5,29
    800042b8:	08e7c563          	blt	a5,a4,80004342 <log_write+0xa2>
    800042bc:	892a                	mv	s2,a0
    800042be:	0001d797          	auipc	a5,0x1d
    800042c2:	64a78793          	addi	a5,a5,1610 # 80021908 <log>
    800042c6:	4fdc                	lw	a5,28(a5)
    800042c8:	37fd                	addiw	a5,a5,-1
    800042ca:	06f75c63          	ble	a5,a4,80004342 <log_write+0xa2>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800042ce:	0001d797          	auipc	a5,0x1d
    800042d2:	63a78793          	addi	a5,a5,1594 # 80021908 <log>
    800042d6:	539c                	lw	a5,32(a5)
    800042d8:	06f05d63          	blez	a5,80004352 <log_write+0xb2>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800042dc:	0001d497          	auipc	s1,0x1d
    800042e0:	62c48493          	addi	s1,s1,1580 # 80021908 <log>
    800042e4:	8526                	mv	a0,s1
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	97c080e7          	jalr	-1668(ra) # 80000c62 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800042ee:	54d0                	lw	a2,44(s1)
    800042f0:	0ac05063          	blez	a2,80004390 <log_write+0xf0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800042f4:	00c92583          	lw	a1,12(s2)
    800042f8:	589c                	lw	a5,48(s1)
    800042fa:	0ab78363          	beq	a5,a1,800043a0 <log_write+0x100>
    800042fe:	0001d717          	auipc	a4,0x1d
    80004302:	63e70713          	addi	a4,a4,1598 # 8002193c <log+0x34>
  for (i = 0; i < log.lh.n; i++) {
    80004306:	4781                	li	a5,0
    80004308:	2785                	addiw	a5,a5,1
    8000430a:	04c78c63          	beq	a5,a2,80004362 <log_write+0xc2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000430e:	4314                	lw	a3,0(a4)
    80004310:	0711                	addi	a4,a4,4
    80004312:	feb69be3          	bne	a3,a1,80004308 <log_write+0x68>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004316:	07a1                	addi	a5,a5,8
    80004318:	078a                	slli	a5,a5,0x2
    8000431a:	0001d717          	auipc	a4,0x1d
    8000431e:	5ee70713          	addi	a4,a4,1518 # 80021908 <log>
    80004322:	97ba                	add	a5,a5,a4
    80004324:	cb8c                	sw	a1,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    log.lh.n++;
  }
  release(&log.lock);
    80004326:	0001d517          	auipc	a0,0x1d
    8000432a:	5e250513          	addi	a0,a0,1506 # 80021908 <log>
    8000432e:	ffffd097          	auipc	ra,0xffffd
    80004332:	9e8080e7          	jalr	-1560(ra) # 80000d16 <release>
}
    80004336:	60e2                	ld	ra,24(sp)
    80004338:	6442                	ld	s0,16(sp)
    8000433a:	64a2                	ld	s1,8(sp)
    8000433c:	6902                	ld	s2,0(sp)
    8000433e:	6105                	addi	sp,sp,32
    80004340:	8082                	ret
    panic("too big a transaction");
    80004342:	00004517          	auipc	a0,0x4
    80004346:	2d650513          	addi	a0,a0,726 # 80008618 <syscalls+0x218>
    8000434a:	ffffc097          	auipc	ra,0xffffc
    8000434e:	22a080e7          	jalr	554(ra) # 80000574 <panic>
    panic("log_write outside of trans");
    80004352:	00004517          	auipc	a0,0x4
    80004356:	2de50513          	addi	a0,a0,734 # 80008630 <syscalls+0x230>
    8000435a:	ffffc097          	auipc	ra,0xffffc
    8000435e:	21a080e7          	jalr	538(ra) # 80000574 <panic>
  log.lh.block[i] = b->blockno;
    80004362:	0621                	addi	a2,a2,8
    80004364:	060a                	slli	a2,a2,0x2
    80004366:	0001d797          	auipc	a5,0x1d
    8000436a:	5a278793          	addi	a5,a5,1442 # 80021908 <log>
    8000436e:	963e                	add	a2,a2,a5
    80004370:	00c92783          	lw	a5,12(s2)
    80004374:	ca1c                	sw	a5,16(a2)
    bpin(b);
    80004376:	854a                	mv	a0,s2
    80004378:	fffff097          	auipc	ra,0xfffff
    8000437c:	d1c080e7          	jalr	-740(ra) # 80003094 <bpin>
    log.lh.n++;
    80004380:	0001d717          	auipc	a4,0x1d
    80004384:	58870713          	addi	a4,a4,1416 # 80021908 <log>
    80004388:	575c                	lw	a5,44(a4)
    8000438a:	2785                	addiw	a5,a5,1
    8000438c:	d75c                	sw	a5,44(a4)
    8000438e:	bf61                	j	80004326 <log_write+0x86>
  log.lh.block[i] = b->blockno;
    80004390:	00c92783          	lw	a5,12(s2)
    80004394:	0001d717          	auipc	a4,0x1d
    80004398:	5af72223          	sw	a5,1444(a4) # 80021938 <log+0x30>
  if (i == log.lh.n) {  // Add new block to log?
    8000439c:	f649                	bnez	a2,80004326 <log_write+0x86>
    8000439e:	bfe1                	j	80004376 <log_write+0xd6>
  for (i = 0; i < log.lh.n; i++) {
    800043a0:	4781                	li	a5,0
    800043a2:	bf95                	j	80004316 <log_write+0x76>

00000000800043a4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043a4:	1101                	addi	sp,sp,-32
    800043a6:	ec06                	sd	ra,24(sp)
    800043a8:	e822                	sd	s0,16(sp)
    800043aa:	e426                	sd	s1,8(sp)
    800043ac:	e04a                	sd	s2,0(sp)
    800043ae:	1000                	addi	s0,sp,32
    800043b0:	84aa                	mv	s1,a0
    800043b2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043b4:	00004597          	auipc	a1,0x4
    800043b8:	29c58593          	addi	a1,a1,668 # 80008650 <syscalls+0x250>
    800043bc:	0521                	addi	a0,a0,8
    800043be:	ffffd097          	auipc	ra,0xffffd
    800043c2:	814080e7          	jalr	-2028(ra) # 80000bd2 <initlock>
  lk->name = name;
    800043c6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800043ca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043ce:	0204a423          	sw	zero,40(s1)
}
    800043d2:	60e2                	ld	ra,24(sp)
    800043d4:	6442                	ld	s0,16(sp)
    800043d6:	64a2                	ld	s1,8(sp)
    800043d8:	6902                	ld	s2,0(sp)
    800043da:	6105                	addi	sp,sp,32
    800043dc:	8082                	ret

00000000800043de <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800043de:	1101                	addi	sp,sp,-32
    800043e0:	ec06                	sd	ra,24(sp)
    800043e2:	e822                	sd	s0,16(sp)
    800043e4:	e426                	sd	s1,8(sp)
    800043e6:	e04a                	sd	s2,0(sp)
    800043e8:	1000                	addi	s0,sp,32
    800043ea:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043ec:	00850913          	addi	s2,a0,8
    800043f0:	854a                	mv	a0,s2
    800043f2:	ffffd097          	auipc	ra,0xffffd
    800043f6:	870080e7          	jalr	-1936(ra) # 80000c62 <acquire>
  while (lk->locked) {
    800043fa:	409c                	lw	a5,0(s1)
    800043fc:	cb89                	beqz	a5,8000440e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800043fe:	85ca                	mv	a1,s2
    80004400:	8526                	mv	a0,s1
    80004402:	ffffe097          	auipc	ra,0xffffe
    80004406:	e84080e7          	jalr	-380(ra) # 80002286 <sleep>
  while (lk->locked) {
    8000440a:	409c                	lw	a5,0(s1)
    8000440c:	fbed                	bnez	a5,800043fe <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000440e:	4785                	li	a5,1
    80004410:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004412:	ffffd097          	auipc	ra,0xffffd
    80004416:	65e080e7          	jalr	1630(ra) # 80001a70 <myproc>
    8000441a:	5d1c                	lw	a5,56(a0)
    8000441c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000441e:	854a                	mv	a0,s2
    80004420:	ffffd097          	auipc	ra,0xffffd
    80004424:	8f6080e7          	jalr	-1802(ra) # 80000d16 <release>
}
    80004428:	60e2                	ld	ra,24(sp)
    8000442a:	6442                	ld	s0,16(sp)
    8000442c:	64a2                	ld	s1,8(sp)
    8000442e:	6902                	ld	s2,0(sp)
    80004430:	6105                	addi	sp,sp,32
    80004432:	8082                	ret

0000000080004434 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004434:	1101                	addi	sp,sp,-32
    80004436:	ec06                	sd	ra,24(sp)
    80004438:	e822                	sd	s0,16(sp)
    8000443a:	e426                	sd	s1,8(sp)
    8000443c:	e04a                	sd	s2,0(sp)
    8000443e:	1000                	addi	s0,sp,32
    80004440:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004442:	00850913          	addi	s2,a0,8
    80004446:	854a                	mv	a0,s2
    80004448:	ffffd097          	auipc	ra,0xffffd
    8000444c:	81a080e7          	jalr	-2022(ra) # 80000c62 <acquire>
  lk->locked = 0;
    80004450:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004454:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004458:	8526                	mv	a0,s1
    8000445a:	ffffe097          	auipc	ra,0xffffe
    8000445e:	fb2080e7          	jalr	-78(ra) # 8000240c <wakeup>
  release(&lk->lk);
    80004462:	854a                	mv	a0,s2
    80004464:	ffffd097          	auipc	ra,0xffffd
    80004468:	8b2080e7          	jalr	-1870(ra) # 80000d16 <release>
}
    8000446c:	60e2                	ld	ra,24(sp)
    8000446e:	6442                	ld	s0,16(sp)
    80004470:	64a2                	ld	s1,8(sp)
    80004472:	6902                	ld	s2,0(sp)
    80004474:	6105                	addi	sp,sp,32
    80004476:	8082                	ret

0000000080004478 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004478:	7179                	addi	sp,sp,-48
    8000447a:	f406                	sd	ra,40(sp)
    8000447c:	f022                	sd	s0,32(sp)
    8000447e:	ec26                	sd	s1,24(sp)
    80004480:	e84a                	sd	s2,16(sp)
    80004482:	e44e                	sd	s3,8(sp)
    80004484:	1800                	addi	s0,sp,48
    80004486:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004488:	00850913          	addi	s2,a0,8
    8000448c:	854a                	mv	a0,s2
    8000448e:	ffffc097          	auipc	ra,0xffffc
    80004492:	7d4080e7          	jalr	2004(ra) # 80000c62 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004496:	409c                	lw	a5,0(s1)
    80004498:	ef99                	bnez	a5,800044b6 <holdingsleep+0x3e>
    8000449a:	4481                	li	s1,0
  release(&lk->lk);
    8000449c:	854a                	mv	a0,s2
    8000449e:	ffffd097          	auipc	ra,0xffffd
    800044a2:	878080e7          	jalr	-1928(ra) # 80000d16 <release>
  return r;
}
    800044a6:	8526                	mv	a0,s1
    800044a8:	70a2                	ld	ra,40(sp)
    800044aa:	7402                	ld	s0,32(sp)
    800044ac:	64e2                	ld	s1,24(sp)
    800044ae:	6942                	ld	s2,16(sp)
    800044b0:	69a2                	ld	s3,8(sp)
    800044b2:	6145                	addi	sp,sp,48
    800044b4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800044b6:	0284a983          	lw	s3,40(s1)
    800044ba:	ffffd097          	auipc	ra,0xffffd
    800044be:	5b6080e7          	jalr	1462(ra) # 80001a70 <myproc>
    800044c2:	5d04                	lw	s1,56(a0)
    800044c4:	413484b3          	sub	s1,s1,s3
    800044c8:	0014b493          	seqz	s1,s1
    800044cc:	bfc1                	j	8000449c <holdingsleep+0x24>

00000000800044ce <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800044ce:	1141                	addi	sp,sp,-16
    800044d0:	e406                	sd	ra,8(sp)
    800044d2:	e022                	sd	s0,0(sp)
    800044d4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800044d6:	00004597          	auipc	a1,0x4
    800044da:	18a58593          	addi	a1,a1,394 # 80008660 <syscalls+0x260>
    800044de:	0001d517          	auipc	a0,0x1d
    800044e2:	57250513          	addi	a0,a0,1394 # 80021a50 <ftable>
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	6ec080e7          	jalr	1772(ra) # 80000bd2 <initlock>
}
    800044ee:	60a2                	ld	ra,8(sp)
    800044f0:	6402                	ld	s0,0(sp)
    800044f2:	0141                	addi	sp,sp,16
    800044f4:	8082                	ret

00000000800044f6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800044f6:	1101                	addi	sp,sp,-32
    800044f8:	ec06                	sd	ra,24(sp)
    800044fa:	e822                	sd	s0,16(sp)
    800044fc:	e426                	sd	s1,8(sp)
    800044fe:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004500:	0001d517          	auipc	a0,0x1d
    80004504:	55050513          	addi	a0,a0,1360 # 80021a50 <ftable>
    80004508:	ffffc097          	auipc	ra,0xffffc
    8000450c:	75a080e7          	jalr	1882(ra) # 80000c62 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
    80004510:	0001d797          	auipc	a5,0x1d
    80004514:	54078793          	addi	a5,a5,1344 # 80021a50 <ftable>
    80004518:	4fdc                	lw	a5,28(a5)
    8000451a:	cb8d                	beqz	a5,8000454c <filealloc+0x56>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000451c:	0001d497          	auipc	s1,0x1d
    80004520:	57448493          	addi	s1,s1,1396 # 80021a90 <ftable+0x40>
    80004524:	0001e717          	auipc	a4,0x1e
    80004528:	4e470713          	addi	a4,a4,1252 # 80022a08 <ftable+0xfb8>
    if(f->ref == 0){
    8000452c:	40dc                	lw	a5,4(s1)
    8000452e:	c39d                	beqz	a5,80004554 <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004530:	02848493          	addi	s1,s1,40
    80004534:	fee49ce3          	bne	s1,a4,8000452c <filealloc+0x36>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004538:	0001d517          	auipc	a0,0x1d
    8000453c:	51850513          	addi	a0,a0,1304 # 80021a50 <ftable>
    80004540:	ffffc097          	auipc	ra,0xffffc
    80004544:	7d6080e7          	jalr	2006(ra) # 80000d16 <release>
  return 0;
    80004548:	4481                	li	s1,0
    8000454a:	a839                	j	80004568 <filealloc+0x72>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000454c:	0001d497          	auipc	s1,0x1d
    80004550:	51c48493          	addi	s1,s1,1308 # 80021a68 <ftable+0x18>
      f->ref = 1;
    80004554:	4785                	li	a5,1
    80004556:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004558:	0001d517          	auipc	a0,0x1d
    8000455c:	4f850513          	addi	a0,a0,1272 # 80021a50 <ftable>
    80004560:	ffffc097          	auipc	ra,0xffffc
    80004564:	7b6080e7          	jalr	1974(ra) # 80000d16 <release>
}
    80004568:	8526                	mv	a0,s1
    8000456a:	60e2                	ld	ra,24(sp)
    8000456c:	6442                	ld	s0,16(sp)
    8000456e:	64a2                	ld	s1,8(sp)
    80004570:	6105                	addi	sp,sp,32
    80004572:	8082                	ret

0000000080004574 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004574:	1101                	addi	sp,sp,-32
    80004576:	ec06                	sd	ra,24(sp)
    80004578:	e822                	sd	s0,16(sp)
    8000457a:	e426                	sd	s1,8(sp)
    8000457c:	1000                	addi	s0,sp,32
    8000457e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004580:	0001d517          	auipc	a0,0x1d
    80004584:	4d050513          	addi	a0,a0,1232 # 80021a50 <ftable>
    80004588:	ffffc097          	auipc	ra,0xffffc
    8000458c:	6da080e7          	jalr	1754(ra) # 80000c62 <acquire>
  if(f->ref < 1)
    80004590:	40dc                	lw	a5,4(s1)
    80004592:	02f05263          	blez	a5,800045b6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004596:	2785                	addiw	a5,a5,1
    80004598:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000459a:	0001d517          	auipc	a0,0x1d
    8000459e:	4b650513          	addi	a0,a0,1206 # 80021a50 <ftable>
    800045a2:	ffffc097          	auipc	ra,0xffffc
    800045a6:	774080e7          	jalr	1908(ra) # 80000d16 <release>
  return f;
}
    800045aa:	8526                	mv	a0,s1
    800045ac:	60e2                	ld	ra,24(sp)
    800045ae:	6442                	ld	s0,16(sp)
    800045b0:	64a2                	ld	s1,8(sp)
    800045b2:	6105                	addi	sp,sp,32
    800045b4:	8082                	ret
    panic("filedup");
    800045b6:	00004517          	auipc	a0,0x4
    800045ba:	0b250513          	addi	a0,a0,178 # 80008668 <syscalls+0x268>
    800045be:	ffffc097          	auipc	ra,0xffffc
    800045c2:	fb6080e7          	jalr	-74(ra) # 80000574 <panic>

00000000800045c6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800045c6:	7139                	addi	sp,sp,-64
    800045c8:	fc06                	sd	ra,56(sp)
    800045ca:	f822                	sd	s0,48(sp)
    800045cc:	f426                	sd	s1,40(sp)
    800045ce:	f04a                	sd	s2,32(sp)
    800045d0:	ec4e                	sd	s3,24(sp)
    800045d2:	e852                	sd	s4,16(sp)
    800045d4:	e456                	sd	s5,8(sp)
    800045d6:	0080                	addi	s0,sp,64
    800045d8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800045da:	0001d517          	auipc	a0,0x1d
    800045de:	47650513          	addi	a0,a0,1142 # 80021a50 <ftable>
    800045e2:	ffffc097          	auipc	ra,0xffffc
    800045e6:	680080e7          	jalr	1664(ra) # 80000c62 <acquire>
  if(f->ref < 1)
    800045ea:	40dc                	lw	a5,4(s1)
    800045ec:	06f05163          	blez	a5,8000464e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800045f0:	37fd                	addiw	a5,a5,-1
    800045f2:	0007871b          	sext.w	a4,a5
    800045f6:	c0dc                	sw	a5,4(s1)
    800045f8:	06e04363          	bgtz	a4,8000465e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800045fc:	0004a903          	lw	s2,0(s1)
    80004600:	0094ca83          	lbu	s5,9(s1)
    80004604:	0104ba03          	ld	s4,16(s1)
    80004608:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000460c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004610:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004614:	0001d517          	auipc	a0,0x1d
    80004618:	43c50513          	addi	a0,a0,1084 # 80021a50 <ftable>
    8000461c:	ffffc097          	auipc	ra,0xffffc
    80004620:	6fa080e7          	jalr	1786(ra) # 80000d16 <release>

  if(ff.type == FD_PIPE){
    80004624:	4785                	li	a5,1
    80004626:	04f90d63          	beq	s2,a5,80004680 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000462a:	3979                	addiw	s2,s2,-2
    8000462c:	4785                	li	a5,1
    8000462e:	0527e063          	bltu	a5,s2,8000466e <fileclose+0xa8>
    begin_op();
    80004632:	00000097          	auipc	ra,0x0
    80004636:	a92080e7          	jalr	-1390(ra) # 800040c4 <begin_op>
    iput(ff.ip);
    8000463a:	854e                	mv	a0,s3
    8000463c:	fffff097          	auipc	ra,0xfffff
    80004640:	27c080e7          	jalr	636(ra) # 800038b8 <iput>
    end_op();
    80004644:	00000097          	auipc	ra,0x0
    80004648:	b00080e7          	jalr	-1280(ra) # 80004144 <end_op>
    8000464c:	a00d                	j	8000466e <fileclose+0xa8>
    panic("fileclose");
    8000464e:	00004517          	auipc	a0,0x4
    80004652:	02250513          	addi	a0,a0,34 # 80008670 <syscalls+0x270>
    80004656:	ffffc097          	auipc	ra,0xffffc
    8000465a:	f1e080e7          	jalr	-226(ra) # 80000574 <panic>
    release(&ftable.lock);
    8000465e:	0001d517          	auipc	a0,0x1d
    80004662:	3f250513          	addi	a0,a0,1010 # 80021a50 <ftable>
    80004666:	ffffc097          	auipc	ra,0xffffc
    8000466a:	6b0080e7          	jalr	1712(ra) # 80000d16 <release>
  }
}
    8000466e:	70e2                	ld	ra,56(sp)
    80004670:	7442                	ld	s0,48(sp)
    80004672:	74a2                	ld	s1,40(sp)
    80004674:	7902                	ld	s2,32(sp)
    80004676:	69e2                	ld	s3,24(sp)
    80004678:	6a42                	ld	s4,16(sp)
    8000467a:	6aa2                	ld	s5,8(sp)
    8000467c:	6121                	addi	sp,sp,64
    8000467e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004680:	85d6                	mv	a1,s5
    80004682:	8552                	mv	a0,s4
    80004684:	00000097          	auipc	ra,0x0
    80004688:	364080e7          	jalr	868(ra) # 800049e8 <pipeclose>
    8000468c:	b7cd                	j	8000466e <fileclose+0xa8>

000000008000468e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000468e:	715d                	addi	sp,sp,-80
    80004690:	e486                	sd	ra,72(sp)
    80004692:	e0a2                	sd	s0,64(sp)
    80004694:	fc26                	sd	s1,56(sp)
    80004696:	f84a                	sd	s2,48(sp)
    80004698:	f44e                	sd	s3,40(sp)
    8000469a:	0880                	addi	s0,sp,80
    8000469c:	84aa                	mv	s1,a0
    8000469e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800046a0:	ffffd097          	auipc	ra,0xffffd
    800046a4:	3d0080e7          	jalr	976(ra) # 80001a70 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046a8:	409c                	lw	a5,0(s1)
    800046aa:	37f9                	addiw	a5,a5,-2
    800046ac:	4705                	li	a4,1
    800046ae:	04f76763          	bltu	a4,a5,800046fc <filestat+0x6e>
    800046b2:	892a                	mv	s2,a0
    ilock(f->ip);
    800046b4:	6c88                	ld	a0,24(s1)
    800046b6:	fffff097          	auipc	ra,0xfffff
    800046ba:	046080e7          	jalr	70(ra) # 800036fc <ilock>
    stati(f->ip, &st);
    800046be:	fb840593          	addi	a1,s0,-72
    800046c2:	6c88                	ld	a0,24(s1)
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	2c4080e7          	jalr	708(ra) # 80003988 <stati>
    iunlock(f->ip);
    800046cc:	6c88                	ld	a0,24(s1)
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	0f2080e7          	jalr	242(ra) # 800037c0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800046d6:	46e1                	li	a3,24
    800046d8:	fb840613          	addi	a2,s0,-72
    800046dc:	85ce                	mv	a1,s3
    800046de:	05093503          	ld	a0,80(s2)
    800046e2:	ffffd097          	auipc	ra,0xffffd
    800046e6:	06a080e7          	jalr	106(ra) # 8000174c <copyout>
    800046ea:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800046ee:	60a6                	ld	ra,72(sp)
    800046f0:	6406                	ld	s0,64(sp)
    800046f2:	74e2                	ld	s1,56(sp)
    800046f4:	7942                	ld	s2,48(sp)
    800046f6:	79a2                	ld	s3,40(sp)
    800046f8:	6161                	addi	sp,sp,80
    800046fa:	8082                	ret
  return -1;
    800046fc:	557d                	li	a0,-1
    800046fe:	bfc5                	j	800046ee <filestat+0x60>

0000000080004700 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004700:	7179                	addi	sp,sp,-48
    80004702:	f406                	sd	ra,40(sp)
    80004704:	f022                	sd	s0,32(sp)
    80004706:	ec26                	sd	s1,24(sp)
    80004708:	e84a                	sd	s2,16(sp)
    8000470a:	e44e                	sd	s3,8(sp)
    8000470c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000470e:	00854783          	lbu	a5,8(a0)
    80004712:	c3d5                	beqz	a5,800047b6 <fileread+0xb6>
    80004714:	89b2                	mv	s3,a2
    80004716:	892e                	mv	s2,a1
    80004718:	84aa                	mv	s1,a0
    return -1;

  if(f->type == FD_PIPE){
    8000471a:	411c                	lw	a5,0(a0)
    8000471c:	4705                	li	a4,1
    8000471e:	04e78963          	beq	a5,a4,80004770 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004722:	470d                	li	a4,3
    80004724:	04e78d63          	beq	a5,a4,8000477e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004728:	4709                	li	a4,2
    8000472a:	06e79e63          	bne	a5,a4,800047a6 <fileread+0xa6>
    ilock(f->ip);
    8000472e:	6d08                	ld	a0,24(a0)
    80004730:	fffff097          	auipc	ra,0xfffff
    80004734:	fcc080e7          	jalr	-52(ra) # 800036fc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004738:	874e                	mv	a4,s3
    8000473a:	5094                	lw	a3,32(s1)
    8000473c:	864a                	mv	a2,s2
    8000473e:	4585                	li	a1,1
    80004740:	6c88                	ld	a0,24(s1)
    80004742:	fffff097          	auipc	ra,0xfffff
    80004746:	270080e7          	jalr	624(ra) # 800039b2 <readi>
    8000474a:	892a                	mv	s2,a0
    8000474c:	00a05563          	blez	a0,80004756 <fileread+0x56>
      f->off += r;
    80004750:	509c                	lw	a5,32(s1)
    80004752:	9fa9                	addw	a5,a5,a0
    80004754:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004756:	6c88                	ld	a0,24(s1)
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	068080e7          	jalr	104(ra) # 800037c0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004760:	854a                	mv	a0,s2
    80004762:	70a2                	ld	ra,40(sp)
    80004764:	7402                	ld	s0,32(sp)
    80004766:	64e2                	ld	s1,24(sp)
    80004768:	6942                	ld	s2,16(sp)
    8000476a:	69a2                	ld	s3,8(sp)
    8000476c:	6145                	addi	sp,sp,48
    8000476e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004770:	6908                	ld	a0,16(a0)
    80004772:	00000097          	auipc	ra,0x0
    80004776:	416080e7          	jalr	1046(ra) # 80004b88 <piperead>
    8000477a:	892a                	mv	s2,a0
    8000477c:	b7d5                	j	80004760 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000477e:	02451783          	lh	a5,36(a0)
    80004782:	03079693          	slli	a3,a5,0x30
    80004786:	92c1                	srli	a3,a3,0x30
    80004788:	4725                	li	a4,9
    8000478a:	02d76863          	bltu	a4,a3,800047ba <fileread+0xba>
    8000478e:	0792                	slli	a5,a5,0x4
    80004790:	0001d717          	auipc	a4,0x1d
    80004794:	22070713          	addi	a4,a4,544 # 800219b0 <devsw>
    80004798:	97ba                	add	a5,a5,a4
    8000479a:	639c                	ld	a5,0(a5)
    8000479c:	c38d                	beqz	a5,800047be <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000479e:	4505                	li	a0,1
    800047a0:	9782                	jalr	a5
    800047a2:	892a                	mv	s2,a0
    800047a4:	bf75                	j	80004760 <fileread+0x60>
    panic("fileread");
    800047a6:	00004517          	auipc	a0,0x4
    800047aa:	eda50513          	addi	a0,a0,-294 # 80008680 <syscalls+0x280>
    800047ae:	ffffc097          	auipc	ra,0xffffc
    800047b2:	dc6080e7          	jalr	-570(ra) # 80000574 <panic>
    return -1;
    800047b6:	597d                	li	s2,-1
    800047b8:	b765                	j	80004760 <fileread+0x60>
      return -1;
    800047ba:	597d                	li	s2,-1
    800047bc:	b755                	j	80004760 <fileread+0x60>
    800047be:	597d                	li	s2,-1
    800047c0:	b745                	j	80004760 <fileread+0x60>

00000000800047c2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800047c2:	00954783          	lbu	a5,9(a0)
    800047c6:	12078e63          	beqz	a5,80004902 <filewrite+0x140>
{
    800047ca:	715d                	addi	sp,sp,-80
    800047cc:	e486                	sd	ra,72(sp)
    800047ce:	e0a2                	sd	s0,64(sp)
    800047d0:	fc26                	sd	s1,56(sp)
    800047d2:	f84a                	sd	s2,48(sp)
    800047d4:	f44e                	sd	s3,40(sp)
    800047d6:	f052                	sd	s4,32(sp)
    800047d8:	ec56                	sd	s5,24(sp)
    800047da:	e85a                	sd	s6,16(sp)
    800047dc:	e45e                	sd	s7,8(sp)
    800047de:	e062                	sd	s8,0(sp)
    800047e0:	0880                	addi	s0,sp,80
    800047e2:	8ab2                	mv	s5,a2
    800047e4:	8b2e                	mv	s6,a1
    800047e6:	84aa                	mv	s1,a0
    return -1;

  if(f->type == FD_PIPE){
    800047e8:	411c                	lw	a5,0(a0)
    800047ea:	4705                	li	a4,1
    800047ec:	02e78263          	beq	a5,a4,80004810 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047f0:	470d                	li	a4,3
    800047f2:	02e78563          	beq	a5,a4,8000481c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800047f6:	4709                	li	a4,2
    800047f8:	0ee79d63          	bne	a5,a4,800048f2 <filewrite+0x130>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800047fc:	0ec05763          	blez	a2,800048ea <filewrite+0x128>
    int i = 0;
    80004800:	4901                	li	s2,0
    80004802:	6b85                	lui	s7,0x1
    80004804:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004808:	6c05                	lui	s8,0x1
    8000480a:	c00c0c1b          	addiw	s8,s8,-1024
    8000480e:	a061                	j	80004896 <filewrite+0xd4>
    ret = pipewrite(f->pipe, addr, n);
    80004810:	6908                	ld	a0,16(a0)
    80004812:	00000097          	auipc	ra,0x0
    80004816:	246080e7          	jalr	582(ra) # 80004a58 <pipewrite>
    8000481a:	a065                	j	800048c2 <filewrite+0x100>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000481c:	02451783          	lh	a5,36(a0)
    80004820:	03079693          	slli	a3,a5,0x30
    80004824:	92c1                	srli	a3,a3,0x30
    80004826:	4725                	li	a4,9
    80004828:	0cd76f63          	bltu	a4,a3,80004906 <filewrite+0x144>
    8000482c:	0792                	slli	a5,a5,0x4
    8000482e:	0001d717          	auipc	a4,0x1d
    80004832:	18270713          	addi	a4,a4,386 # 800219b0 <devsw>
    80004836:	97ba                	add	a5,a5,a4
    80004838:	679c                	ld	a5,8(a5)
    8000483a:	cbe1                	beqz	a5,8000490a <filewrite+0x148>
    ret = devsw[f->major].write(1, addr, n);
    8000483c:	4505                	li	a0,1
    8000483e:	9782                	jalr	a5
    80004840:	a049                	j	800048c2 <filewrite+0x100>
    80004842:	00098a1b          	sext.w	s4,s3
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004846:	00000097          	auipc	ra,0x0
    8000484a:	87e080e7          	jalr	-1922(ra) # 800040c4 <begin_op>
      ilock(f->ip);
    8000484e:	6c88                	ld	a0,24(s1)
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	eac080e7          	jalr	-340(ra) # 800036fc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004858:	8752                	mv	a4,s4
    8000485a:	5094                	lw	a3,32(s1)
    8000485c:	01690633          	add	a2,s2,s6
    80004860:	4585                	li	a1,1
    80004862:	6c88                	ld	a0,24(s1)
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	244080e7          	jalr	580(ra) # 80003aa8 <writei>
    8000486c:	89aa                	mv	s3,a0
    8000486e:	02a05c63          	blez	a0,800048a6 <filewrite+0xe4>
        f->off += r;
    80004872:	509c                	lw	a5,32(s1)
    80004874:	9fa9                	addw	a5,a5,a0
    80004876:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    80004878:	6c88                	ld	a0,24(s1)
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	f46080e7          	jalr	-186(ra) # 800037c0 <iunlock>
      end_op();
    80004882:	00000097          	auipc	ra,0x0
    80004886:	8c2080e7          	jalr	-1854(ra) # 80004144 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    8000488a:	05499863          	bne	s3,s4,800048da <filewrite+0x118>
        panic("short filewrite");
      i += r;
    8000488e:	012a093b          	addw	s2,s4,s2
    while(i < n){
    80004892:	03595563          	ble	s5,s2,800048bc <filewrite+0xfa>
      int n1 = n - i;
    80004896:	412a87bb          	subw	a5,s5,s2
      if(n1 > max)
    8000489a:	89be                	mv	s3,a5
    8000489c:	2781                	sext.w	a5,a5
    8000489e:	fafbd2e3          	ble	a5,s7,80004842 <filewrite+0x80>
    800048a2:	89e2                	mv	s3,s8
    800048a4:	bf79                	j	80004842 <filewrite+0x80>
      iunlock(f->ip);
    800048a6:	6c88                	ld	a0,24(s1)
    800048a8:	fffff097          	auipc	ra,0xfffff
    800048ac:	f18080e7          	jalr	-232(ra) # 800037c0 <iunlock>
      end_op();
    800048b0:	00000097          	auipc	ra,0x0
    800048b4:	894080e7          	jalr	-1900(ra) # 80004144 <end_op>
      if(r < 0)
    800048b8:	fc09d9e3          	bgez	s3,8000488a <filewrite+0xc8>
    }
    ret = (i == n ? n : -1);
    800048bc:	8556                	mv	a0,s5
    800048be:	032a9863          	bne	s5,s2,800048ee <filewrite+0x12c>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048c2:	60a6                	ld	ra,72(sp)
    800048c4:	6406                	ld	s0,64(sp)
    800048c6:	74e2                	ld	s1,56(sp)
    800048c8:	7942                	ld	s2,48(sp)
    800048ca:	79a2                	ld	s3,40(sp)
    800048cc:	7a02                	ld	s4,32(sp)
    800048ce:	6ae2                	ld	s5,24(sp)
    800048d0:	6b42                	ld	s6,16(sp)
    800048d2:	6ba2                	ld	s7,8(sp)
    800048d4:	6c02                	ld	s8,0(sp)
    800048d6:	6161                	addi	sp,sp,80
    800048d8:	8082                	ret
        panic("short filewrite");
    800048da:	00004517          	auipc	a0,0x4
    800048de:	db650513          	addi	a0,a0,-586 # 80008690 <syscalls+0x290>
    800048e2:	ffffc097          	auipc	ra,0xffffc
    800048e6:	c92080e7          	jalr	-878(ra) # 80000574 <panic>
    int i = 0;
    800048ea:	4901                	li	s2,0
    800048ec:	bfc1                	j	800048bc <filewrite+0xfa>
    ret = (i == n ? n : -1);
    800048ee:	557d                	li	a0,-1
    800048f0:	bfc9                	j	800048c2 <filewrite+0x100>
    panic("filewrite");
    800048f2:	00004517          	auipc	a0,0x4
    800048f6:	dae50513          	addi	a0,a0,-594 # 800086a0 <syscalls+0x2a0>
    800048fa:	ffffc097          	auipc	ra,0xffffc
    800048fe:	c7a080e7          	jalr	-902(ra) # 80000574 <panic>
    return -1;
    80004902:	557d                	li	a0,-1
}
    80004904:	8082                	ret
      return -1;
    80004906:	557d                	li	a0,-1
    80004908:	bf6d                	j	800048c2 <filewrite+0x100>
    8000490a:	557d                	li	a0,-1
    8000490c:	bf5d                	j	800048c2 <filewrite+0x100>

000000008000490e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000490e:	7179                	addi	sp,sp,-48
    80004910:	f406                	sd	ra,40(sp)
    80004912:	f022                	sd	s0,32(sp)
    80004914:	ec26                	sd	s1,24(sp)
    80004916:	e84a                	sd	s2,16(sp)
    80004918:	e44e                	sd	s3,8(sp)
    8000491a:	e052                	sd	s4,0(sp)
    8000491c:	1800                	addi	s0,sp,48
    8000491e:	84aa                	mv	s1,a0
    80004920:	892e                	mv	s2,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004922:	0005b023          	sd	zero,0(a1)
    80004926:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000492a:	00000097          	auipc	ra,0x0
    8000492e:	bcc080e7          	jalr	-1076(ra) # 800044f6 <filealloc>
    80004932:	e088                	sd	a0,0(s1)
    80004934:	c551                	beqz	a0,800049c0 <pipealloc+0xb2>
    80004936:	00000097          	auipc	ra,0x0
    8000493a:	bc0080e7          	jalr	-1088(ra) # 800044f6 <filealloc>
    8000493e:	00a93023          	sd	a0,0(s2)
    80004942:	c92d                	beqz	a0,800049b4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004944:	ffffc097          	auipc	ra,0xffffc
    80004948:	22e080e7          	jalr	558(ra) # 80000b72 <kalloc>
    8000494c:	89aa                	mv	s3,a0
    8000494e:	c125                	beqz	a0,800049ae <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004950:	4a05                	li	s4,1
    80004952:	23452023          	sw	s4,544(a0)
  pi->writeopen = 1;
    80004956:	23452223          	sw	s4,548(a0)
  pi->nwrite = 0;
    8000495a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000495e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004962:	00004597          	auipc	a1,0x4
    80004966:	d4e58593          	addi	a1,a1,-690 # 800086b0 <syscalls+0x2b0>
    8000496a:	ffffc097          	auipc	ra,0xffffc
    8000496e:	268080e7          	jalr	616(ra) # 80000bd2 <initlock>
  (*f0)->type = FD_PIPE;
    80004972:	609c                	ld	a5,0(s1)
    80004974:	0147a023          	sw	s4,0(a5)
  (*f0)->readable = 1;
    80004978:	609c                	ld	a5,0(s1)
    8000497a:	01478423          	sb	s4,8(a5)
  (*f0)->writable = 0;
    8000497e:	609c                	ld	a5,0(s1)
    80004980:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004984:	609c                	ld	a5,0(s1)
    80004986:	0137b823          	sd	s3,16(a5)
  (*f1)->type = FD_PIPE;
    8000498a:	00093783          	ld	a5,0(s2)
    8000498e:	0147a023          	sw	s4,0(a5)
  (*f1)->readable = 0;
    80004992:	00093783          	ld	a5,0(s2)
    80004996:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000499a:	00093783          	ld	a5,0(s2)
    8000499e:	014784a3          	sb	s4,9(a5)
  (*f1)->pipe = pi;
    800049a2:	00093783          	ld	a5,0(s2)
    800049a6:	0137b823          	sd	s3,16(a5)
  return 0;
    800049aa:	4501                	li	a0,0
    800049ac:	a025                	j	800049d4 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800049ae:	6088                	ld	a0,0(s1)
    800049b0:	e501                	bnez	a0,800049b8 <pipealloc+0xaa>
    800049b2:	a039                	j	800049c0 <pipealloc+0xb2>
    800049b4:	6088                	ld	a0,0(s1)
    800049b6:	c51d                	beqz	a0,800049e4 <pipealloc+0xd6>
    fileclose(*f0);
    800049b8:	00000097          	auipc	ra,0x0
    800049bc:	c0e080e7          	jalr	-1010(ra) # 800045c6 <fileclose>
  if(*f1)
    800049c0:	00093783          	ld	a5,0(s2)
    fileclose(*f1);
  return -1;
    800049c4:	557d                	li	a0,-1
  if(*f1)
    800049c6:	c799                	beqz	a5,800049d4 <pipealloc+0xc6>
    fileclose(*f1);
    800049c8:	853e                	mv	a0,a5
    800049ca:	00000097          	auipc	ra,0x0
    800049ce:	bfc080e7          	jalr	-1028(ra) # 800045c6 <fileclose>
  return -1;
    800049d2:	557d                	li	a0,-1
}
    800049d4:	70a2                	ld	ra,40(sp)
    800049d6:	7402                	ld	s0,32(sp)
    800049d8:	64e2                	ld	s1,24(sp)
    800049da:	6942                	ld	s2,16(sp)
    800049dc:	69a2                	ld	s3,8(sp)
    800049de:	6a02                	ld	s4,0(sp)
    800049e0:	6145                	addi	sp,sp,48
    800049e2:	8082                	ret
  return -1;
    800049e4:	557d                	li	a0,-1
    800049e6:	b7fd                	j	800049d4 <pipealloc+0xc6>

00000000800049e8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800049e8:	1101                	addi	sp,sp,-32
    800049ea:	ec06                	sd	ra,24(sp)
    800049ec:	e822                	sd	s0,16(sp)
    800049ee:	e426                	sd	s1,8(sp)
    800049f0:	e04a                	sd	s2,0(sp)
    800049f2:	1000                	addi	s0,sp,32
    800049f4:	84aa                	mv	s1,a0
    800049f6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800049f8:	ffffc097          	auipc	ra,0xffffc
    800049fc:	26a080e7          	jalr	618(ra) # 80000c62 <acquire>
  if(writable){
    80004a00:	02090d63          	beqz	s2,80004a3a <pipeclose+0x52>
    pi->writeopen = 0;
    80004a04:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a08:	21848513          	addi	a0,s1,536
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	a00080e7          	jalr	-1536(ra) # 8000240c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a14:	2204b783          	ld	a5,544(s1)
    80004a18:	eb95                	bnez	a5,80004a4c <pipeclose+0x64>
    release(&pi->lock);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffc097          	auipc	ra,0xffffc
    80004a20:	2fa080e7          	jalr	762(ra) # 80000d16 <release>
    kfree((char*)pi);
    80004a24:	8526                	mv	a0,s1
    80004a26:	ffffc097          	auipc	ra,0xffffc
    80004a2a:	04c080e7          	jalr	76(ra) # 80000a72 <kfree>
  } else
    release(&pi->lock);
}
    80004a2e:	60e2                	ld	ra,24(sp)
    80004a30:	6442                	ld	s0,16(sp)
    80004a32:	64a2                	ld	s1,8(sp)
    80004a34:	6902                	ld	s2,0(sp)
    80004a36:	6105                	addi	sp,sp,32
    80004a38:	8082                	ret
    pi->readopen = 0;
    80004a3a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a3e:	21c48513          	addi	a0,s1,540
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	9ca080e7          	jalr	-1590(ra) # 8000240c <wakeup>
    80004a4a:	b7e9                	j	80004a14 <pipeclose+0x2c>
    release(&pi->lock);
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	ffffc097          	auipc	ra,0xffffc
    80004a52:	2c8080e7          	jalr	712(ra) # 80000d16 <release>
}
    80004a56:	bfe1                	j	80004a2e <pipeclose+0x46>

0000000080004a58 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a58:	7119                	addi	sp,sp,-128
    80004a5a:	fc86                	sd	ra,120(sp)
    80004a5c:	f8a2                	sd	s0,112(sp)
    80004a5e:	f4a6                	sd	s1,104(sp)
    80004a60:	f0ca                	sd	s2,96(sp)
    80004a62:	ecce                	sd	s3,88(sp)
    80004a64:	e8d2                	sd	s4,80(sp)
    80004a66:	e4d6                	sd	s5,72(sp)
    80004a68:	e0da                	sd	s6,64(sp)
    80004a6a:	fc5e                	sd	s7,56(sp)
    80004a6c:	f862                	sd	s8,48(sp)
    80004a6e:	f466                	sd	s9,40(sp)
    80004a70:	f06a                	sd	s10,32(sp)
    80004a72:	ec6e                	sd	s11,24(sp)
    80004a74:	0100                	addi	s0,sp,128
    80004a76:	84aa                	mv	s1,a0
    80004a78:	8d2e                	mv	s10,a1
    80004a7a:	8b32                	mv	s6,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004a7c:	ffffd097          	auipc	ra,0xffffd
    80004a80:	ff4080e7          	jalr	-12(ra) # 80001a70 <myproc>
    80004a84:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004a86:	8526                	mv	a0,s1
    80004a88:	ffffc097          	auipc	ra,0xffffc
    80004a8c:	1da080e7          	jalr	474(ra) # 80000c62 <acquire>
  for(i = 0; i < n; i++){
    80004a90:	0d605f63          	blez	s6,80004b6e <pipewrite+0x116>
    80004a94:	89a6                	mv	s3,s1
    80004a96:	3b7d                	addiw	s6,s6,-1
    80004a98:	1b02                	slli	s6,s6,0x20
    80004a9a:	020b5b13          	srli	s6,s6,0x20
    80004a9e:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004aa0:	21848a93          	addi	s5,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004aa4:	21c48a13          	addi	s4,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004aa8:	5dfd                	li	s11,-1
    80004aaa:	000b8c9b          	sext.w	s9,s7
    80004aae:	8c66                	mv	s8,s9
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004ab0:	2184a783          	lw	a5,536(s1)
    80004ab4:	21c4a703          	lw	a4,540(s1)
    80004ab8:	2007879b          	addiw	a5,a5,512
    80004abc:	06f71763          	bne	a4,a5,80004b2a <pipewrite+0xd2>
      if(pi->readopen == 0 || pr->killed){
    80004ac0:	2204a783          	lw	a5,544(s1)
    80004ac4:	cf8d                	beqz	a5,80004afe <pipewrite+0xa6>
    80004ac6:	03092783          	lw	a5,48(s2)
    80004aca:	eb95                	bnez	a5,80004afe <pipewrite+0xa6>
      wakeup(&pi->nread);
    80004acc:	8556                	mv	a0,s5
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	93e080e7          	jalr	-1730(ra) # 8000240c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ad6:	85ce                	mv	a1,s3
    80004ad8:	8552                	mv	a0,s4
    80004ada:	ffffd097          	auipc	ra,0xffffd
    80004ade:	7ac080e7          	jalr	1964(ra) # 80002286 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004ae2:	2184a783          	lw	a5,536(s1)
    80004ae6:	21c4a703          	lw	a4,540(s1)
    80004aea:	2007879b          	addiw	a5,a5,512
    80004aee:	02f71e63          	bne	a4,a5,80004b2a <pipewrite+0xd2>
      if(pi->readopen == 0 || pr->killed){
    80004af2:	2204a783          	lw	a5,544(s1)
    80004af6:	c781                	beqz	a5,80004afe <pipewrite+0xa6>
    80004af8:	03092783          	lw	a5,48(s2)
    80004afc:	dbe1                	beqz	a5,80004acc <pipewrite+0x74>
        release(&pi->lock);
    80004afe:	8526                	mv	a0,s1
    80004b00:	ffffc097          	auipc	ra,0xffffc
    80004b04:	216080e7          	jalr	534(ra) # 80000d16 <release>
        return -1;
    80004b08:	5c7d                	li	s8,-1
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
  }
  wakeup(&pi->nread);
  release(&pi->lock);
  return i;
}
    80004b0a:	8562                	mv	a0,s8
    80004b0c:	70e6                	ld	ra,120(sp)
    80004b0e:	7446                	ld	s0,112(sp)
    80004b10:	74a6                	ld	s1,104(sp)
    80004b12:	7906                	ld	s2,96(sp)
    80004b14:	69e6                	ld	s3,88(sp)
    80004b16:	6a46                	ld	s4,80(sp)
    80004b18:	6aa6                	ld	s5,72(sp)
    80004b1a:	6b06                	ld	s6,64(sp)
    80004b1c:	7be2                	ld	s7,56(sp)
    80004b1e:	7c42                	ld	s8,48(sp)
    80004b20:	7ca2                	ld	s9,40(sp)
    80004b22:	7d02                	ld	s10,32(sp)
    80004b24:	6de2                	ld	s11,24(sp)
    80004b26:	6109                	addi	sp,sp,128
    80004b28:	8082                	ret
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b2a:	4685                	li	a3,1
    80004b2c:	01ab8633          	add	a2,s7,s10
    80004b30:	f8f40593          	addi	a1,s0,-113
    80004b34:	05093503          	ld	a0,80(s2)
    80004b38:	ffffd097          	auipc	ra,0xffffd
    80004b3c:	ca0080e7          	jalr	-864(ra) # 800017d8 <copyin>
    80004b40:	03b50863          	beq	a0,s11,80004b70 <pipewrite+0x118>
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b44:	21c4a783          	lw	a5,540(s1)
    80004b48:	0017871b          	addiw	a4,a5,1
    80004b4c:	20e4ae23          	sw	a4,540(s1)
    80004b50:	1ff7f793          	andi	a5,a5,511
    80004b54:	97a6                	add	a5,a5,s1
    80004b56:	f8f44703          	lbu	a4,-113(s0)
    80004b5a:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004b5e:	001c8c1b          	addiw	s8,s9,1
    80004b62:	001b8793          	addi	a5,s7,1
    80004b66:	016b8563          	beq	s7,s6,80004b70 <pipewrite+0x118>
    80004b6a:	8bbe                	mv	s7,a5
    80004b6c:	bf3d                	j	80004aaa <pipewrite+0x52>
    80004b6e:	4c01                	li	s8,0
  wakeup(&pi->nread);
    80004b70:	21848513          	addi	a0,s1,536
    80004b74:	ffffe097          	auipc	ra,0xffffe
    80004b78:	898080e7          	jalr	-1896(ra) # 8000240c <wakeup>
  release(&pi->lock);
    80004b7c:	8526                	mv	a0,s1
    80004b7e:	ffffc097          	auipc	ra,0xffffc
    80004b82:	198080e7          	jalr	408(ra) # 80000d16 <release>
  return i;
    80004b86:	b751                	j	80004b0a <pipewrite+0xb2>

0000000080004b88 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b88:	715d                	addi	sp,sp,-80
    80004b8a:	e486                	sd	ra,72(sp)
    80004b8c:	e0a2                	sd	s0,64(sp)
    80004b8e:	fc26                	sd	s1,56(sp)
    80004b90:	f84a                	sd	s2,48(sp)
    80004b92:	f44e                	sd	s3,40(sp)
    80004b94:	f052                	sd	s4,32(sp)
    80004b96:	ec56                	sd	s5,24(sp)
    80004b98:	e85a                	sd	s6,16(sp)
    80004b9a:	0880                	addi	s0,sp,80
    80004b9c:	84aa                	mv	s1,a0
    80004b9e:	89ae                	mv	s3,a1
    80004ba0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004ba2:	ffffd097          	auipc	ra,0xffffd
    80004ba6:	ece080e7          	jalr	-306(ra) # 80001a70 <myproc>
    80004baa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004bac:	8526                	mv	a0,s1
    80004bae:	ffffc097          	auipc	ra,0xffffc
    80004bb2:	0b4080e7          	jalr	180(ra) # 80000c62 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004bb6:	2184a703          	lw	a4,536(s1)
    80004bba:	21c4a783          	lw	a5,540(s1)
    80004bbe:	06f71b63          	bne	a4,a5,80004c34 <piperead+0xac>
    80004bc2:	8926                	mv	s2,s1
    80004bc4:	2244a783          	lw	a5,548(s1)
    80004bc8:	cf9d                	beqz	a5,80004c06 <piperead+0x7e>
    if(pr->killed){
    80004bca:	030a2783          	lw	a5,48(s4)
    80004bce:	e78d                	bnez	a5,80004bf8 <piperead+0x70>
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004bd0:	21848b13          	addi	s6,s1,536
    80004bd4:	85ca                	mv	a1,s2
    80004bd6:	855a                	mv	a0,s6
    80004bd8:	ffffd097          	auipc	ra,0xffffd
    80004bdc:	6ae080e7          	jalr	1710(ra) # 80002286 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004be0:	2184a703          	lw	a4,536(s1)
    80004be4:	21c4a783          	lw	a5,540(s1)
    80004be8:	04f71663          	bne	a4,a5,80004c34 <piperead+0xac>
    80004bec:	2244a783          	lw	a5,548(s1)
    80004bf0:	cb99                	beqz	a5,80004c06 <piperead+0x7e>
    if(pr->killed){
    80004bf2:	030a2783          	lw	a5,48(s4)
    80004bf6:	dff9                	beqz	a5,80004bd4 <piperead+0x4c>
      release(&pi->lock);
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	ffffc097          	auipc	ra,0xffffc
    80004bfe:	11c080e7          	jalr	284(ra) # 80000d16 <release>
      return -1;
    80004c02:	597d                	li	s2,-1
    80004c04:	a829                	j	80004c1e <piperead+0x96>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(pi->nread == pi->nwrite)
    80004c06:	4901                	li	s2,0
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004c08:	21c48513          	addi	a0,s1,540
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	800080e7          	jalr	-2048(ra) # 8000240c <wakeup>
  release(&pi->lock);
    80004c14:	8526                	mv	a0,s1
    80004c16:	ffffc097          	auipc	ra,0xffffc
    80004c1a:	100080e7          	jalr	256(ra) # 80000d16 <release>
  return i;
}
    80004c1e:	854a                	mv	a0,s2
    80004c20:	60a6                	ld	ra,72(sp)
    80004c22:	6406                	ld	s0,64(sp)
    80004c24:	74e2                	ld	s1,56(sp)
    80004c26:	7942                	ld	s2,48(sp)
    80004c28:	79a2                	ld	s3,40(sp)
    80004c2a:	7a02                	ld	s4,32(sp)
    80004c2c:	6ae2                	ld	s5,24(sp)
    80004c2e:	6b42                	ld	s6,16(sp)
    80004c30:	6161                	addi	sp,sp,80
    80004c32:	8082                	ret
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c34:	4901                	li	s2,0
    80004c36:	fd5059e3          	blez	s5,80004c08 <piperead+0x80>
    if(pi->nread == pi->nwrite)
    80004c3a:	2184a783          	lw	a5,536(s1)
    80004c3e:	4901                	li	s2,0
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c40:	5b7d                	li	s6,-1
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004c42:	0017871b          	addiw	a4,a5,1
    80004c46:	20e4ac23          	sw	a4,536(s1)
    80004c4a:	1ff7f793          	andi	a5,a5,511
    80004c4e:	97a6                	add	a5,a5,s1
    80004c50:	0187c783          	lbu	a5,24(a5)
    80004c54:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c58:	4685                	li	a3,1
    80004c5a:	fbf40613          	addi	a2,s0,-65
    80004c5e:	85ce                	mv	a1,s3
    80004c60:	050a3503          	ld	a0,80(s4)
    80004c64:	ffffd097          	auipc	ra,0xffffd
    80004c68:	ae8080e7          	jalr	-1304(ra) # 8000174c <copyout>
    80004c6c:	f9650ee3          	beq	a0,s6,80004c08 <piperead+0x80>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c70:	2905                	addiw	s2,s2,1
    80004c72:	f92a8be3          	beq	s5,s2,80004c08 <piperead+0x80>
    if(pi->nread == pi->nwrite)
    80004c76:	2184a783          	lw	a5,536(s1)
    80004c7a:	0985                	addi	s3,s3,1
    80004c7c:	21c4a703          	lw	a4,540(s1)
    80004c80:	fcf711e3          	bne	a4,a5,80004c42 <piperead+0xba>
    80004c84:	b751                	j	80004c08 <piperead+0x80>

0000000080004c86 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004c86:	de010113          	addi	sp,sp,-544
    80004c8a:	20113c23          	sd	ra,536(sp)
    80004c8e:	20813823          	sd	s0,528(sp)
    80004c92:	20913423          	sd	s1,520(sp)
    80004c96:	21213023          	sd	s2,512(sp)
    80004c9a:	ffce                	sd	s3,504(sp)
    80004c9c:	fbd2                	sd	s4,496(sp)
    80004c9e:	f7d6                	sd	s5,488(sp)
    80004ca0:	f3da                	sd	s6,480(sp)
    80004ca2:	efde                	sd	s7,472(sp)
    80004ca4:	ebe2                	sd	s8,464(sp)
    80004ca6:	e7e6                	sd	s9,456(sp)
    80004ca8:	e3ea                	sd	s10,448(sp)
    80004caa:	ff6e                	sd	s11,440(sp)
    80004cac:	1400                	addi	s0,sp,544
    80004cae:	892a                	mv	s2,a0
    80004cb0:	dea43823          	sd	a0,-528(s0)
    80004cb4:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004cb8:	ffffd097          	auipc	ra,0xffffd
    80004cbc:	db8080e7          	jalr	-584(ra) # 80001a70 <myproc>
    80004cc0:	84aa                	mv	s1,a0

  begin_op();
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	402080e7          	jalr	1026(ra) # 800040c4 <begin_op>

  if((ip = namei(path)) == 0){
    80004cca:	854a                	mv	a0,s2
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	1ea080e7          	jalr	490(ra) # 80003eb6 <namei>
    80004cd4:	c93d                	beqz	a0,80004d4a <exec+0xc4>
    80004cd6:	892a                	mv	s2,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004cd8:	fffff097          	auipc	ra,0xfffff
    80004cdc:	a24080e7          	jalr	-1500(ra) # 800036fc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004ce0:	04000713          	li	a4,64
    80004ce4:	4681                	li	a3,0
    80004ce6:	e4840613          	addi	a2,s0,-440
    80004cea:	4581                	li	a1,0
    80004cec:	854a                	mv	a0,s2
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	cc4080e7          	jalr	-828(ra) # 800039b2 <readi>
    80004cf6:	04000793          	li	a5,64
    80004cfa:	00f51a63          	bne	a0,a5,80004d0e <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004cfe:	e4842703          	lw	a4,-440(s0)
    80004d02:	464c47b7          	lui	a5,0x464c4
    80004d06:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d0a:	04f70663          	beq	a4,a5,80004d56 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004d0e:	854a                	mv	a0,s2
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	c50080e7          	jalr	-944(ra) # 80003960 <iunlockput>
    end_op();
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	42c080e7          	jalr	1068(ra) # 80004144 <end_op>
  }
  return -1;
    80004d20:	557d                	li	a0,-1
}
    80004d22:	21813083          	ld	ra,536(sp)
    80004d26:	21013403          	ld	s0,528(sp)
    80004d2a:	20813483          	ld	s1,520(sp)
    80004d2e:	20013903          	ld	s2,512(sp)
    80004d32:	79fe                	ld	s3,504(sp)
    80004d34:	7a5e                	ld	s4,496(sp)
    80004d36:	7abe                	ld	s5,488(sp)
    80004d38:	7b1e                	ld	s6,480(sp)
    80004d3a:	6bfe                	ld	s7,472(sp)
    80004d3c:	6c5e                	ld	s8,464(sp)
    80004d3e:	6cbe                	ld	s9,456(sp)
    80004d40:	6d1e                	ld	s10,448(sp)
    80004d42:	7dfa                	ld	s11,440(sp)
    80004d44:	22010113          	addi	sp,sp,544
    80004d48:	8082                	ret
    end_op();
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	3fa080e7          	jalr	1018(ra) # 80004144 <end_op>
    return -1;
    80004d52:	557d                	li	a0,-1
    80004d54:	b7f9                	j	80004d22 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004d56:	8526                	mv	a0,s1
    80004d58:	ffffd097          	auipc	ra,0xffffd
    80004d5c:	dde080e7          	jalr	-546(ra) # 80001b36 <proc_pagetable>
    80004d60:	e0a43423          	sd	a0,-504(s0)
    80004d64:	d54d                	beqz	a0,80004d0e <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d66:	e6842983          	lw	s3,-408(s0)
    80004d6a:	e8045783          	lhu	a5,-384(s0)
    80004d6e:	c7ad                	beqz	a5,80004dd8 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004d70:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d72:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004d74:	6c05                	lui	s8,0x1
    80004d76:	fffc0793          	addi	a5,s8,-1 # fff <_entry-0x7ffff001>
    80004d7a:	def43423          	sd	a5,-536(s0)
    80004d7e:	7cfd                	lui	s9,0xfffff
    80004d80:	ac1d                	j	80004fb6 <exec+0x330>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004d82:	00004517          	auipc	a0,0x4
    80004d86:	93650513          	addi	a0,a0,-1738 # 800086b8 <syscalls+0x2b8>
    80004d8a:	ffffb097          	auipc	ra,0xffffb
    80004d8e:	7ea080e7          	jalr	2026(ra) # 80000574 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d92:	8756                	mv	a4,s5
    80004d94:	009d86bb          	addw	a3,s11,s1
    80004d98:	4581                	li	a1,0
    80004d9a:	854a                	mv	a0,s2
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	c16080e7          	jalr	-1002(ra) # 800039b2 <readi>
    80004da4:	2501                	sext.w	a0,a0
    80004da6:	1aaa9e63          	bne	s5,a0,80004f62 <exec+0x2dc>
  for(i = 0; i < sz; i += PGSIZE){
    80004daa:	6785                	lui	a5,0x1
    80004dac:	9cbd                	addw	s1,s1,a5
    80004dae:	014c8a3b          	addw	s4,s9,s4
    80004db2:	1f74f963          	bleu	s7,s1,80004fa4 <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    80004db6:	02049593          	slli	a1,s1,0x20
    80004dba:	9181                	srli	a1,a1,0x20
    80004dbc:	95ea                	add	a1,a1,s10
    80004dbe:	e0843503          	ld	a0,-504(s0)
    80004dc2:	ffffc097          	auipc	ra,0xffffc
    80004dc6:	352080e7          	jalr	850(ra) # 80001114 <walkaddr>
    80004dca:	862a                	mv	a2,a0
    if(pa == 0)
    80004dcc:	d95d                	beqz	a0,80004d82 <exec+0xfc>
      n = PGSIZE;
    80004dce:	8ae2                	mv	s5,s8
    if(sz - i < PGSIZE)
    80004dd0:	fd8a71e3          	bleu	s8,s4,80004d92 <exec+0x10c>
      n = sz - i;
    80004dd4:	8ad2                	mv	s5,s4
    80004dd6:	bf75                	j	80004d92 <exec+0x10c>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004dd8:	4481                	li	s1,0
  iunlockput(ip);
    80004dda:	854a                	mv	a0,s2
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	b84080e7          	jalr	-1148(ra) # 80003960 <iunlockput>
  end_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	360080e7          	jalr	864(ra) # 80004144 <end_op>
  p = myproc();
    80004dec:	ffffd097          	auipc	ra,0xffffd
    80004df0:	c84080e7          	jalr	-892(ra) # 80001a70 <myproc>
    80004df4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004df6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004dfa:	6785                	lui	a5,0x1
    80004dfc:	17fd                	addi	a5,a5,-1
    80004dfe:	94be                	add	s1,s1,a5
    80004e00:	77fd                	lui	a5,0xfffff
    80004e02:	8fe5                	and	a5,a5,s1
    80004e04:	e0f43023          	sd	a5,-512(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004e08:	6609                	lui	a2,0x2
    80004e0a:	963e                	add	a2,a2,a5
    80004e0c:	85be                	mv	a1,a5
    80004e0e:	e0843483          	ld	s1,-504(s0)
    80004e12:	8526                	mv	a0,s1
    80004e14:	ffffc097          	auipc	ra,0xffffc
    80004e18:	6e8080e7          	jalr	1768(ra) # 800014fc <uvmalloc>
    80004e1c:	8b2a                	mv	s6,a0
  ip = 0;
    80004e1e:	4901                	li	s2,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004e20:	14050163          	beqz	a0,80004f62 <exec+0x2dc>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e24:	75f9                	lui	a1,0xffffe
    80004e26:	95aa                	add	a1,a1,a0
    80004e28:	8526                	mv	a0,s1
    80004e2a:	ffffd097          	auipc	ra,0xffffd
    80004e2e:	8f0080e7          	jalr	-1808(ra) # 8000171a <uvmclear>
  stackbase = sp - PGSIZE;
    80004e32:	7bfd                	lui	s7,0xfffff
    80004e34:	9bda                	add	s7,s7,s6
  for(argc = 0; argv[argc]; argc++) {
    80004e36:	df843783          	ld	a5,-520(s0)
    80004e3a:	6388                	ld	a0,0(a5)
    80004e3c:	c925                	beqz	a0,80004eac <exec+0x226>
    80004e3e:	e8840993          	addi	s3,s0,-376
    80004e42:	f8840c13          	addi	s8,s0,-120
  sp = sz;
    80004e46:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004e48:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e4a:	ffffc097          	auipc	ra,0xffffc
    80004e4e:	0be080e7          	jalr	190(ra) # 80000f08 <strlen>
    80004e52:	2505                	addiw	a0,a0,1
    80004e54:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e58:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004e5c:	13796863          	bltu	s2,s7,80004f8c <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e60:	df843c83          	ld	s9,-520(s0)
    80004e64:	000cba03          	ld	s4,0(s9) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80004e68:	8552                	mv	a0,s4
    80004e6a:	ffffc097          	auipc	ra,0xffffc
    80004e6e:	09e080e7          	jalr	158(ra) # 80000f08 <strlen>
    80004e72:	0015069b          	addiw	a3,a0,1
    80004e76:	8652                	mv	a2,s4
    80004e78:	85ca                	mv	a1,s2
    80004e7a:	e0843503          	ld	a0,-504(s0)
    80004e7e:	ffffd097          	auipc	ra,0xffffd
    80004e82:	8ce080e7          	jalr	-1842(ra) # 8000174c <copyout>
    80004e86:	10054763          	bltz	a0,80004f94 <exec+0x30e>
    ustack[argc] = sp;
    80004e8a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e8e:	0485                	addi	s1,s1,1
    80004e90:	008c8793          	addi	a5,s9,8
    80004e94:	def43c23          	sd	a5,-520(s0)
    80004e98:	008cb503          	ld	a0,8(s9)
    80004e9c:	c911                	beqz	a0,80004eb0 <exec+0x22a>
    if(argc >= MAXARG)
    80004e9e:	09a1                	addi	s3,s3,8
    80004ea0:	fb8995e3          	bne	s3,s8,80004e4a <exec+0x1c4>
  sz = sz1;
    80004ea4:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004ea8:	4901                	li	s2,0
    80004eaa:	a865                	j	80004f62 <exec+0x2dc>
  sp = sz;
    80004eac:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004eae:	4481                	li	s1,0
  ustack[argc] = 0;
    80004eb0:	00349793          	slli	a5,s1,0x3
    80004eb4:	f9040713          	addi	a4,s0,-112
    80004eb8:	97ba                	add	a5,a5,a4
    80004eba:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
  sp -= (argc+1) * sizeof(uint64);
    80004ebe:	00148693          	addi	a3,s1,1
    80004ec2:	068e                	slli	a3,a3,0x3
    80004ec4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004ec8:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004ecc:	01797663          	bleu	s7,s2,80004ed8 <exec+0x252>
  sz = sz1;
    80004ed0:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004ed4:	4901                	li	s2,0
    80004ed6:	a071                	j	80004f62 <exec+0x2dc>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004ed8:	e8840613          	addi	a2,s0,-376
    80004edc:	85ca                	mv	a1,s2
    80004ede:	e0843503          	ld	a0,-504(s0)
    80004ee2:	ffffd097          	auipc	ra,0xffffd
    80004ee6:	86a080e7          	jalr	-1942(ra) # 8000174c <copyout>
    80004eea:	0a054963          	bltz	a0,80004f9c <exec+0x316>
  p->trapframe->a1 = sp;
    80004eee:	058ab783          	ld	a5,88(s5)
    80004ef2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004ef6:	df043783          	ld	a5,-528(s0)
    80004efa:	0007c703          	lbu	a4,0(a5)
    80004efe:	cf11                	beqz	a4,80004f1a <exec+0x294>
    80004f00:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004f02:	02f00693          	li	a3,47
    80004f06:	a029                	j	80004f10 <exec+0x28a>
  for(last=s=path; *s; s++)
    80004f08:	0785                	addi	a5,a5,1
    80004f0a:	fff7c703          	lbu	a4,-1(a5)
    80004f0e:	c711                	beqz	a4,80004f1a <exec+0x294>
    if(*s == '/')
    80004f10:	fed71ce3          	bne	a4,a3,80004f08 <exec+0x282>
      last = s+1;
    80004f14:	def43823          	sd	a5,-528(s0)
    80004f18:	bfc5                	j	80004f08 <exec+0x282>
  safestrcpy(p->name, last, sizeof(p->name));
    80004f1a:	4641                	li	a2,16
    80004f1c:	df043583          	ld	a1,-528(s0)
    80004f20:	158a8513          	addi	a0,s5,344
    80004f24:	ffffc097          	auipc	ra,0xffffc
    80004f28:	fb2080e7          	jalr	-78(ra) # 80000ed6 <safestrcpy>
  oldpagetable = p->pagetable;
    80004f2c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004f30:	e0843783          	ld	a5,-504(s0)
    80004f34:	04fab823          	sd	a5,80(s5)
  p->sz = sz;
    80004f38:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f3c:	058ab783          	ld	a5,88(s5)
    80004f40:	e6043703          	ld	a4,-416(s0)
    80004f44:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f46:	058ab783          	ld	a5,88(s5)
    80004f4a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f4e:	85ea                	mv	a1,s10
    80004f50:	ffffd097          	auipc	ra,0xffffd
    80004f54:	c82080e7          	jalr	-894(ra) # 80001bd2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f58:	0004851b          	sext.w	a0,s1
    80004f5c:	b3d9                	j	80004d22 <exec+0x9c>
    80004f5e:	e0943023          	sd	s1,-512(s0)
    proc_freepagetable(pagetable, sz);
    80004f62:	e0043583          	ld	a1,-512(s0)
    80004f66:	e0843503          	ld	a0,-504(s0)
    80004f6a:	ffffd097          	auipc	ra,0xffffd
    80004f6e:	c68080e7          	jalr	-920(ra) # 80001bd2 <proc_freepagetable>
  if(ip){
    80004f72:	d8091ee3          	bnez	s2,80004d0e <exec+0x88>
  return -1;
    80004f76:	557d                	li	a0,-1
    80004f78:	b36d                	j	80004d22 <exec+0x9c>
    80004f7a:	e0943023          	sd	s1,-512(s0)
    80004f7e:	b7d5                	j	80004f62 <exec+0x2dc>
    80004f80:	e0943023          	sd	s1,-512(s0)
    80004f84:	bff9                	j	80004f62 <exec+0x2dc>
    80004f86:	e0943023          	sd	s1,-512(s0)
    80004f8a:	bfe1                	j	80004f62 <exec+0x2dc>
  sz = sz1;
    80004f8c:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004f90:	4901                	li	s2,0
    80004f92:	bfc1                	j	80004f62 <exec+0x2dc>
  sz = sz1;
    80004f94:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004f98:	4901                	li	s2,0
    80004f9a:	b7e1                	j	80004f62 <exec+0x2dc>
  sz = sz1;
    80004f9c:	e1643023          	sd	s6,-512(s0)
  ip = 0;
    80004fa0:	4901                	li	s2,0
    80004fa2:	b7c1                	j	80004f62 <exec+0x2dc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004fa4:	e0043483          	ld	s1,-512(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004fa8:	2b05                	addiw	s6,s6,1
    80004faa:	0389899b          	addiw	s3,s3,56
    80004fae:	e8045783          	lhu	a5,-384(s0)
    80004fb2:	e2fb54e3          	ble	a5,s6,80004dda <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004fb6:	2981                	sext.w	s3,s3
    80004fb8:	03800713          	li	a4,56
    80004fbc:	86ce                	mv	a3,s3
    80004fbe:	e1040613          	addi	a2,s0,-496
    80004fc2:	4581                	li	a1,0
    80004fc4:	854a                	mv	a0,s2
    80004fc6:	fffff097          	auipc	ra,0xfffff
    80004fca:	9ec080e7          	jalr	-1556(ra) # 800039b2 <readi>
    80004fce:	03800793          	li	a5,56
    80004fd2:	f8f516e3          	bne	a0,a5,80004f5e <exec+0x2d8>
    if(ph.type != ELF_PROG_LOAD)
    80004fd6:	e1042783          	lw	a5,-496(s0)
    80004fda:	4705                	li	a4,1
    80004fdc:	fce796e3          	bne	a5,a4,80004fa8 <exec+0x322>
    if(ph.memsz < ph.filesz)
    80004fe0:	e3843603          	ld	a2,-456(s0)
    80004fe4:	e3043783          	ld	a5,-464(s0)
    80004fe8:	f8f669e3          	bltu	a2,a5,80004f7a <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004fec:	e2043783          	ld	a5,-480(s0)
    80004ff0:	963e                	add	a2,a2,a5
    80004ff2:	f8f667e3          	bltu	a2,a5,80004f80 <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004ff6:	85a6                	mv	a1,s1
    80004ff8:	e0843503          	ld	a0,-504(s0)
    80004ffc:	ffffc097          	auipc	ra,0xffffc
    80005000:	500080e7          	jalr	1280(ra) # 800014fc <uvmalloc>
    80005004:	e0a43023          	sd	a0,-512(s0)
    80005008:	dd3d                	beqz	a0,80004f86 <exec+0x300>
    if(ph.vaddr % PGSIZE != 0)
    8000500a:	e2043d03          	ld	s10,-480(s0)
    8000500e:	de843783          	ld	a5,-536(s0)
    80005012:	00fd77b3          	and	a5,s10,a5
    80005016:	f7b1                	bnez	a5,80004f62 <exec+0x2dc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005018:	e1842d83          	lw	s11,-488(s0)
    8000501c:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005020:	f80b82e3          	beqz	s7,80004fa4 <exec+0x31e>
    80005024:	8a5e                	mv	s4,s7
    80005026:	4481                	li	s1,0
    80005028:	b379                	j	80004db6 <exec+0x130>

000000008000502a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000502a:	7179                	addi	sp,sp,-48
    8000502c:	f406                	sd	ra,40(sp)
    8000502e:	f022                	sd	s0,32(sp)
    80005030:	ec26                	sd	s1,24(sp)
    80005032:	e84a                	sd	s2,16(sp)
    80005034:	1800                	addi	s0,sp,48
    80005036:	892e                	mv	s2,a1
    80005038:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000503a:	fdc40593          	addi	a1,s0,-36
    8000503e:	ffffe097          	auipc	ra,0xffffe
    80005042:	afe080e7          	jalr	-1282(ra) # 80002b3c <argint>
    80005046:	04054063          	bltz	a0,80005086 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000504a:	fdc42703          	lw	a4,-36(s0)
    8000504e:	47bd                	li	a5,15
    80005050:	02e7ed63          	bltu	a5,a4,8000508a <argfd+0x60>
    80005054:	ffffd097          	auipc	ra,0xffffd
    80005058:	a1c080e7          	jalr	-1508(ra) # 80001a70 <myproc>
    8000505c:	fdc42703          	lw	a4,-36(s0)
    80005060:	01a70793          	addi	a5,a4,26
    80005064:	078e                	slli	a5,a5,0x3
    80005066:	953e                	add	a0,a0,a5
    80005068:	611c                	ld	a5,0(a0)
    8000506a:	c395                	beqz	a5,8000508e <argfd+0x64>
    return -1;
  if(pfd)
    8000506c:	00090463          	beqz	s2,80005074 <argfd+0x4a>
    *pfd = fd;
    80005070:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005074:	4501                	li	a0,0
  if(pf)
    80005076:	c091                	beqz	s1,8000507a <argfd+0x50>
    *pf = f;
    80005078:	e09c                	sd	a5,0(s1)
}
    8000507a:	70a2                	ld	ra,40(sp)
    8000507c:	7402                	ld	s0,32(sp)
    8000507e:	64e2                	ld	s1,24(sp)
    80005080:	6942                	ld	s2,16(sp)
    80005082:	6145                	addi	sp,sp,48
    80005084:	8082                	ret
    return -1;
    80005086:	557d                	li	a0,-1
    80005088:	bfcd                	j	8000507a <argfd+0x50>
    return -1;
    8000508a:	557d                	li	a0,-1
    8000508c:	b7fd                	j	8000507a <argfd+0x50>
    8000508e:	557d                	li	a0,-1
    80005090:	b7ed                	j	8000507a <argfd+0x50>

0000000080005092 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005092:	1101                	addi	sp,sp,-32
    80005094:	ec06                	sd	ra,24(sp)
    80005096:	e822                	sd	s0,16(sp)
    80005098:	e426                	sd	s1,8(sp)
    8000509a:	1000                	addi	s0,sp,32
    8000509c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000509e:	ffffd097          	auipc	ra,0xffffd
    800050a2:	9d2080e7          	jalr	-1582(ra) # 80001a70 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
    800050a6:	697c                	ld	a5,208(a0)
    800050a8:	c395                	beqz	a5,800050cc <fdalloc+0x3a>
    800050aa:	0d850713          	addi	a4,a0,216
  for(fd = 0; fd < NOFILE; fd++){
    800050ae:	4785                	li	a5,1
    800050b0:	4641                	li	a2,16
    if(p->ofile[fd] == 0){
    800050b2:	6314                	ld	a3,0(a4)
    800050b4:	ce89                	beqz	a3,800050ce <fdalloc+0x3c>
  for(fd = 0; fd < NOFILE; fd++){
    800050b6:	2785                	addiw	a5,a5,1
    800050b8:	0721                	addi	a4,a4,8
    800050ba:	fec79ce3          	bne	a5,a2,800050b2 <fdalloc+0x20>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800050be:	57fd                	li	a5,-1
}
    800050c0:	853e                	mv	a0,a5
    800050c2:	60e2                	ld	ra,24(sp)
    800050c4:	6442                	ld	s0,16(sp)
    800050c6:	64a2                	ld	s1,8(sp)
    800050c8:	6105                	addi	sp,sp,32
    800050ca:	8082                	ret
  for(fd = 0; fd < NOFILE; fd++){
    800050cc:	4781                	li	a5,0
      p->ofile[fd] = f;
    800050ce:	01a78713          	addi	a4,a5,26
    800050d2:	070e                	slli	a4,a4,0x3
    800050d4:	953a                	add	a0,a0,a4
    800050d6:	e104                	sd	s1,0(a0)
      return fd;
    800050d8:	b7e5                	j	800050c0 <fdalloc+0x2e>

00000000800050da <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800050da:	715d                	addi	sp,sp,-80
    800050dc:	e486                	sd	ra,72(sp)
    800050de:	e0a2                	sd	s0,64(sp)
    800050e0:	fc26                	sd	s1,56(sp)
    800050e2:	f84a                	sd	s2,48(sp)
    800050e4:	f44e                	sd	s3,40(sp)
    800050e6:	f052                	sd	s4,32(sp)
    800050e8:	ec56                	sd	s5,24(sp)
    800050ea:	0880                	addi	s0,sp,80
    800050ec:	89ae                	mv	s3,a1
    800050ee:	8ab2                	mv	s5,a2
    800050f0:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800050f2:	fb040593          	addi	a1,s0,-80
    800050f6:	fffff097          	auipc	ra,0xfffff
    800050fa:	dde080e7          	jalr	-546(ra) # 80003ed4 <nameiparent>
    800050fe:	892a                	mv	s2,a0
    80005100:	12050f63          	beqz	a0,8000523e <create+0x164>
    return 0;

  ilock(dp);
    80005104:	ffffe097          	auipc	ra,0xffffe
    80005108:	5f8080e7          	jalr	1528(ra) # 800036fc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000510c:	4601                	li	a2,0
    8000510e:	fb040593          	addi	a1,s0,-80
    80005112:	854a                	mv	a0,s2
    80005114:	fffff097          	auipc	ra,0xfffff
    80005118:	ac8080e7          	jalr	-1336(ra) # 80003bdc <dirlookup>
    8000511c:	84aa                	mv	s1,a0
    8000511e:	c921                	beqz	a0,8000516e <create+0x94>
    iunlockput(dp);
    80005120:	854a                	mv	a0,s2
    80005122:	fffff097          	auipc	ra,0xfffff
    80005126:	83e080e7          	jalr	-1986(ra) # 80003960 <iunlockput>
    ilock(ip);
    8000512a:	8526                	mv	a0,s1
    8000512c:	ffffe097          	auipc	ra,0xffffe
    80005130:	5d0080e7          	jalr	1488(ra) # 800036fc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005134:	2981                	sext.w	s3,s3
    80005136:	4789                	li	a5,2
    80005138:	02f99463          	bne	s3,a5,80005160 <create+0x86>
    8000513c:	0444d783          	lhu	a5,68(s1)
    80005140:	37f9                	addiw	a5,a5,-2
    80005142:	17c2                	slli	a5,a5,0x30
    80005144:	93c1                	srli	a5,a5,0x30
    80005146:	4705                	li	a4,1
    80005148:	00f76c63          	bltu	a4,a5,80005160 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000514c:	8526                	mv	a0,s1
    8000514e:	60a6                	ld	ra,72(sp)
    80005150:	6406                	ld	s0,64(sp)
    80005152:	74e2                	ld	s1,56(sp)
    80005154:	7942                	ld	s2,48(sp)
    80005156:	79a2                	ld	s3,40(sp)
    80005158:	7a02                	ld	s4,32(sp)
    8000515a:	6ae2                	ld	s5,24(sp)
    8000515c:	6161                	addi	sp,sp,80
    8000515e:	8082                	ret
    iunlockput(ip);
    80005160:	8526                	mv	a0,s1
    80005162:	ffffe097          	auipc	ra,0xffffe
    80005166:	7fe080e7          	jalr	2046(ra) # 80003960 <iunlockput>
    return 0;
    8000516a:	4481                	li	s1,0
    8000516c:	b7c5                	j	8000514c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000516e:	85ce                	mv	a1,s3
    80005170:	00092503          	lw	a0,0(s2)
    80005174:	ffffe097          	auipc	ra,0xffffe
    80005178:	3ec080e7          	jalr	1004(ra) # 80003560 <ialloc>
    8000517c:	84aa                	mv	s1,a0
    8000517e:	c529                	beqz	a0,800051c8 <create+0xee>
  ilock(ip);
    80005180:	ffffe097          	auipc	ra,0xffffe
    80005184:	57c080e7          	jalr	1404(ra) # 800036fc <ilock>
  ip->major = major;
    80005188:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000518c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005190:	4785                	li	a5,1
    80005192:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005196:	8526                	mv	a0,s1
    80005198:	ffffe097          	auipc	ra,0xffffe
    8000519c:	498080e7          	jalr	1176(ra) # 80003630 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800051a0:	2981                	sext.w	s3,s3
    800051a2:	4785                	li	a5,1
    800051a4:	02f98a63          	beq	s3,a5,800051d8 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800051a8:	40d0                	lw	a2,4(s1)
    800051aa:	fb040593          	addi	a1,s0,-80
    800051ae:	854a                	mv	a0,s2
    800051b0:	fffff097          	auipc	ra,0xfffff
    800051b4:	c44080e7          	jalr	-956(ra) # 80003df4 <dirlink>
    800051b8:	06054b63          	bltz	a0,8000522e <create+0x154>
  iunlockput(dp);
    800051bc:	854a                	mv	a0,s2
    800051be:	ffffe097          	auipc	ra,0xffffe
    800051c2:	7a2080e7          	jalr	1954(ra) # 80003960 <iunlockput>
  return ip;
    800051c6:	b759                	j	8000514c <create+0x72>
    panic("create: ialloc");
    800051c8:	00003517          	auipc	a0,0x3
    800051cc:	51050513          	addi	a0,a0,1296 # 800086d8 <syscalls+0x2d8>
    800051d0:	ffffb097          	auipc	ra,0xffffb
    800051d4:	3a4080e7          	jalr	932(ra) # 80000574 <panic>
    dp->nlink++;  // for ".."
    800051d8:	04a95783          	lhu	a5,74(s2)
    800051dc:	2785                	addiw	a5,a5,1
    800051de:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800051e2:	854a                	mv	a0,s2
    800051e4:	ffffe097          	auipc	ra,0xffffe
    800051e8:	44c080e7          	jalr	1100(ra) # 80003630 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800051ec:	40d0                	lw	a2,4(s1)
    800051ee:	00003597          	auipc	a1,0x3
    800051f2:	4fa58593          	addi	a1,a1,1274 # 800086e8 <syscalls+0x2e8>
    800051f6:	8526                	mv	a0,s1
    800051f8:	fffff097          	auipc	ra,0xfffff
    800051fc:	bfc080e7          	jalr	-1028(ra) # 80003df4 <dirlink>
    80005200:	00054f63          	bltz	a0,8000521e <create+0x144>
    80005204:	00492603          	lw	a2,4(s2)
    80005208:	00003597          	auipc	a1,0x3
    8000520c:	4e858593          	addi	a1,a1,1256 # 800086f0 <syscalls+0x2f0>
    80005210:	8526                	mv	a0,s1
    80005212:	fffff097          	auipc	ra,0xfffff
    80005216:	be2080e7          	jalr	-1054(ra) # 80003df4 <dirlink>
    8000521a:	f80557e3          	bgez	a0,800051a8 <create+0xce>
      panic("create dots");
    8000521e:	00003517          	auipc	a0,0x3
    80005222:	4da50513          	addi	a0,a0,1242 # 800086f8 <syscalls+0x2f8>
    80005226:	ffffb097          	auipc	ra,0xffffb
    8000522a:	34e080e7          	jalr	846(ra) # 80000574 <panic>
    panic("create: dirlink");
    8000522e:	00003517          	auipc	a0,0x3
    80005232:	4da50513          	addi	a0,a0,1242 # 80008708 <syscalls+0x308>
    80005236:	ffffb097          	auipc	ra,0xffffb
    8000523a:	33e080e7          	jalr	830(ra) # 80000574 <panic>
    return 0;
    8000523e:	84aa                	mv	s1,a0
    80005240:	b731                	j	8000514c <create+0x72>

0000000080005242 <sys_dup>:
{
    80005242:	7179                	addi	sp,sp,-48
    80005244:	f406                	sd	ra,40(sp)
    80005246:	f022                	sd	s0,32(sp)
    80005248:	ec26                	sd	s1,24(sp)
    8000524a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000524c:	fd840613          	addi	a2,s0,-40
    80005250:	4581                	li	a1,0
    80005252:	4501                	li	a0,0
    80005254:	00000097          	auipc	ra,0x0
    80005258:	dd6080e7          	jalr	-554(ra) # 8000502a <argfd>
    return -1;
    8000525c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000525e:	02054363          	bltz	a0,80005284 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005262:	fd843503          	ld	a0,-40(s0)
    80005266:	00000097          	auipc	ra,0x0
    8000526a:	e2c080e7          	jalr	-468(ra) # 80005092 <fdalloc>
    8000526e:	84aa                	mv	s1,a0
    return -1;
    80005270:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005272:	00054963          	bltz	a0,80005284 <sys_dup+0x42>
  filedup(f);
    80005276:	fd843503          	ld	a0,-40(s0)
    8000527a:	fffff097          	auipc	ra,0xfffff
    8000527e:	2fa080e7          	jalr	762(ra) # 80004574 <filedup>
  return fd;
    80005282:	87a6                	mv	a5,s1
}
    80005284:	853e                	mv	a0,a5
    80005286:	70a2                	ld	ra,40(sp)
    80005288:	7402                	ld	s0,32(sp)
    8000528a:	64e2                	ld	s1,24(sp)
    8000528c:	6145                	addi	sp,sp,48
    8000528e:	8082                	ret

0000000080005290 <sys_read>:
{
    80005290:	7179                	addi	sp,sp,-48
    80005292:	f406                	sd	ra,40(sp)
    80005294:	f022                	sd	s0,32(sp)
    80005296:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005298:	fe840613          	addi	a2,s0,-24
    8000529c:	4581                	li	a1,0
    8000529e:	4501                	li	a0,0
    800052a0:	00000097          	auipc	ra,0x0
    800052a4:	d8a080e7          	jalr	-630(ra) # 8000502a <argfd>
    return -1;
    800052a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052aa:	04054163          	bltz	a0,800052ec <sys_read+0x5c>
    800052ae:	fe440593          	addi	a1,s0,-28
    800052b2:	4509                	li	a0,2
    800052b4:	ffffe097          	auipc	ra,0xffffe
    800052b8:	888080e7          	jalr	-1912(ra) # 80002b3c <argint>
    return -1;
    800052bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052be:	02054763          	bltz	a0,800052ec <sys_read+0x5c>
    800052c2:	fd840593          	addi	a1,s0,-40
    800052c6:	4505                	li	a0,1
    800052c8:	ffffe097          	auipc	ra,0xffffe
    800052cc:	896080e7          	jalr	-1898(ra) # 80002b5e <argaddr>
    return -1;
    800052d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052d2:	00054d63          	bltz	a0,800052ec <sys_read+0x5c>
  return fileread(f, p, n);
    800052d6:	fe442603          	lw	a2,-28(s0)
    800052da:	fd843583          	ld	a1,-40(s0)
    800052de:	fe843503          	ld	a0,-24(s0)
    800052e2:	fffff097          	auipc	ra,0xfffff
    800052e6:	41e080e7          	jalr	1054(ra) # 80004700 <fileread>
    800052ea:	87aa                	mv	a5,a0
}
    800052ec:	853e                	mv	a0,a5
    800052ee:	70a2                	ld	ra,40(sp)
    800052f0:	7402                	ld	s0,32(sp)
    800052f2:	6145                	addi	sp,sp,48
    800052f4:	8082                	ret

00000000800052f6 <sys_write>:
{
    800052f6:	7179                	addi	sp,sp,-48
    800052f8:	f406                	sd	ra,40(sp)
    800052fa:	f022                	sd	s0,32(sp)
    800052fc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052fe:	fe840613          	addi	a2,s0,-24
    80005302:	4581                	li	a1,0
    80005304:	4501                	li	a0,0
    80005306:	00000097          	auipc	ra,0x0
    8000530a:	d24080e7          	jalr	-732(ra) # 8000502a <argfd>
    return -1;
    8000530e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005310:	04054163          	bltz	a0,80005352 <sys_write+0x5c>
    80005314:	fe440593          	addi	a1,s0,-28
    80005318:	4509                	li	a0,2
    8000531a:	ffffe097          	auipc	ra,0xffffe
    8000531e:	822080e7          	jalr	-2014(ra) # 80002b3c <argint>
    return -1;
    80005322:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005324:	02054763          	bltz	a0,80005352 <sys_write+0x5c>
    80005328:	fd840593          	addi	a1,s0,-40
    8000532c:	4505                	li	a0,1
    8000532e:	ffffe097          	auipc	ra,0xffffe
    80005332:	830080e7          	jalr	-2000(ra) # 80002b5e <argaddr>
    return -1;
    80005336:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005338:	00054d63          	bltz	a0,80005352 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000533c:	fe442603          	lw	a2,-28(s0)
    80005340:	fd843583          	ld	a1,-40(s0)
    80005344:	fe843503          	ld	a0,-24(s0)
    80005348:	fffff097          	auipc	ra,0xfffff
    8000534c:	47a080e7          	jalr	1146(ra) # 800047c2 <filewrite>
    80005350:	87aa                	mv	a5,a0
}
    80005352:	853e                	mv	a0,a5
    80005354:	70a2                	ld	ra,40(sp)
    80005356:	7402                	ld	s0,32(sp)
    80005358:	6145                	addi	sp,sp,48
    8000535a:	8082                	ret

000000008000535c <sys_close>:
{
    8000535c:	1101                	addi	sp,sp,-32
    8000535e:	ec06                	sd	ra,24(sp)
    80005360:	e822                	sd	s0,16(sp)
    80005362:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005364:	fe040613          	addi	a2,s0,-32
    80005368:	fec40593          	addi	a1,s0,-20
    8000536c:	4501                	li	a0,0
    8000536e:	00000097          	auipc	ra,0x0
    80005372:	cbc080e7          	jalr	-836(ra) # 8000502a <argfd>
    return -1;
    80005376:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005378:	02054463          	bltz	a0,800053a0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000537c:	ffffc097          	auipc	ra,0xffffc
    80005380:	6f4080e7          	jalr	1780(ra) # 80001a70 <myproc>
    80005384:	fec42783          	lw	a5,-20(s0)
    80005388:	07e9                	addi	a5,a5,26
    8000538a:	078e                	slli	a5,a5,0x3
    8000538c:	953e                	add	a0,a0,a5
    8000538e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005392:	fe043503          	ld	a0,-32(s0)
    80005396:	fffff097          	auipc	ra,0xfffff
    8000539a:	230080e7          	jalr	560(ra) # 800045c6 <fileclose>
  return 0;
    8000539e:	4781                	li	a5,0
}
    800053a0:	853e                	mv	a0,a5
    800053a2:	60e2                	ld	ra,24(sp)
    800053a4:	6442                	ld	s0,16(sp)
    800053a6:	6105                	addi	sp,sp,32
    800053a8:	8082                	ret

00000000800053aa <sys_fstat>:
{
    800053aa:	1101                	addi	sp,sp,-32
    800053ac:	ec06                	sd	ra,24(sp)
    800053ae:	e822                	sd	s0,16(sp)
    800053b0:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800053b2:	fe840613          	addi	a2,s0,-24
    800053b6:	4581                	li	a1,0
    800053b8:	4501                	li	a0,0
    800053ba:	00000097          	auipc	ra,0x0
    800053be:	c70080e7          	jalr	-912(ra) # 8000502a <argfd>
    return -1;
    800053c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800053c4:	02054563          	bltz	a0,800053ee <sys_fstat+0x44>
    800053c8:	fe040593          	addi	a1,s0,-32
    800053cc:	4505                	li	a0,1
    800053ce:	ffffd097          	auipc	ra,0xffffd
    800053d2:	790080e7          	jalr	1936(ra) # 80002b5e <argaddr>
    return -1;
    800053d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800053d8:	00054b63          	bltz	a0,800053ee <sys_fstat+0x44>
  return filestat(f, st);
    800053dc:	fe043583          	ld	a1,-32(s0)
    800053e0:	fe843503          	ld	a0,-24(s0)
    800053e4:	fffff097          	auipc	ra,0xfffff
    800053e8:	2aa080e7          	jalr	682(ra) # 8000468e <filestat>
    800053ec:	87aa                	mv	a5,a0
}
    800053ee:	853e                	mv	a0,a5
    800053f0:	60e2                	ld	ra,24(sp)
    800053f2:	6442                	ld	s0,16(sp)
    800053f4:	6105                	addi	sp,sp,32
    800053f6:	8082                	ret

00000000800053f8 <sys_link>:
{
    800053f8:	7169                	addi	sp,sp,-304
    800053fa:	f606                	sd	ra,296(sp)
    800053fc:	f222                	sd	s0,288(sp)
    800053fe:	ee26                	sd	s1,280(sp)
    80005400:	ea4a                	sd	s2,272(sp)
    80005402:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005404:	08000613          	li	a2,128
    80005408:	ed040593          	addi	a1,s0,-304
    8000540c:	4501                	li	a0,0
    8000540e:	ffffd097          	auipc	ra,0xffffd
    80005412:	772080e7          	jalr	1906(ra) # 80002b80 <argstr>
    return -1;
    80005416:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005418:	10054e63          	bltz	a0,80005534 <sys_link+0x13c>
    8000541c:	08000613          	li	a2,128
    80005420:	f5040593          	addi	a1,s0,-176
    80005424:	4505                	li	a0,1
    80005426:	ffffd097          	auipc	ra,0xffffd
    8000542a:	75a080e7          	jalr	1882(ra) # 80002b80 <argstr>
    return -1;
    8000542e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005430:	10054263          	bltz	a0,80005534 <sys_link+0x13c>
  begin_op();
    80005434:	fffff097          	auipc	ra,0xfffff
    80005438:	c90080e7          	jalr	-880(ra) # 800040c4 <begin_op>
  if((ip = namei(old)) == 0){
    8000543c:	ed040513          	addi	a0,s0,-304
    80005440:	fffff097          	auipc	ra,0xfffff
    80005444:	a76080e7          	jalr	-1418(ra) # 80003eb6 <namei>
    80005448:	84aa                	mv	s1,a0
    8000544a:	c551                	beqz	a0,800054d6 <sys_link+0xde>
  ilock(ip);
    8000544c:	ffffe097          	auipc	ra,0xffffe
    80005450:	2b0080e7          	jalr	688(ra) # 800036fc <ilock>
  if(ip->type == T_DIR){
    80005454:	04449703          	lh	a4,68(s1)
    80005458:	4785                	li	a5,1
    8000545a:	08f70463          	beq	a4,a5,800054e2 <sys_link+0xea>
  ip->nlink++;
    8000545e:	04a4d783          	lhu	a5,74(s1)
    80005462:	2785                	addiw	a5,a5,1
    80005464:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005468:	8526                	mv	a0,s1
    8000546a:	ffffe097          	auipc	ra,0xffffe
    8000546e:	1c6080e7          	jalr	454(ra) # 80003630 <iupdate>
  iunlock(ip);
    80005472:	8526                	mv	a0,s1
    80005474:	ffffe097          	auipc	ra,0xffffe
    80005478:	34c080e7          	jalr	844(ra) # 800037c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000547c:	fd040593          	addi	a1,s0,-48
    80005480:	f5040513          	addi	a0,s0,-176
    80005484:	fffff097          	auipc	ra,0xfffff
    80005488:	a50080e7          	jalr	-1456(ra) # 80003ed4 <nameiparent>
    8000548c:	892a                	mv	s2,a0
    8000548e:	c935                	beqz	a0,80005502 <sys_link+0x10a>
  ilock(dp);
    80005490:	ffffe097          	auipc	ra,0xffffe
    80005494:	26c080e7          	jalr	620(ra) # 800036fc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005498:	00092703          	lw	a4,0(s2)
    8000549c:	409c                	lw	a5,0(s1)
    8000549e:	04f71d63          	bne	a4,a5,800054f8 <sys_link+0x100>
    800054a2:	40d0                	lw	a2,4(s1)
    800054a4:	fd040593          	addi	a1,s0,-48
    800054a8:	854a                	mv	a0,s2
    800054aa:	fffff097          	auipc	ra,0xfffff
    800054ae:	94a080e7          	jalr	-1718(ra) # 80003df4 <dirlink>
    800054b2:	04054363          	bltz	a0,800054f8 <sys_link+0x100>
  iunlockput(dp);
    800054b6:	854a                	mv	a0,s2
    800054b8:	ffffe097          	auipc	ra,0xffffe
    800054bc:	4a8080e7          	jalr	1192(ra) # 80003960 <iunlockput>
  iput(ip);
    800054c0:	8526                	mv	a0,s1
    800054c2:	ffffe097          	auipc	ra,0xffffe
    800054c6:	3f6080e7          	jalr	1014(ra) # 800038b8 <iput>
  end_op();
    800054ca:	fffff097          	auipc	ra,0xfffff
    800054ce:	c7a080e7          	jalr	-902(ra) # 80004144 <end_op>
  return 0;
    800054d2:	4781                	li	a5,0
    800054d4:	a085                	j	80005534 <sys_link+0x13c>
    end_op();
    800054d6:	fffff097          	auipc	ra,0xfffff
    800054da:	c6e080e7          	jalr	-914(ra) # 80004144 <end_op>
    return -1;
    800054de:	57fd                	li	a5,-1
    800054e0:	a891                	j	80005534 <sys_link+0x13c>
    iunlockput(ip);
    800054e2:	8526                	mv	a0,s1
    800054e4:	ffffe097          	auipc	ra,0xffffe
    800054e8:	47c080e7          	jalr	1148(ra) # 80003960 <iunlockput>
    end_op();
    800054ec:	fffff097          	auipc	ra,0xfffff
    800054f0:	c58080e7          	jalr	-936(ra) # 80004144 <end_op>
    return -1;
    800054f4:	57fd                	li	a5,-1
    800054f6:	a83d                	j	80005534 <sys_link+0x13c>
    iunlockput(dp);
    800054f8:	854a                	mv	a0,s2
    800054fa:	ffffe097          	auipc	ra,0xffffe
    800054fe:	466080e7          	jalr	1126(ra) # 80003960 <iunlockput>
  ilock(ip);
    80005502:	8526                	mv	a0,s1
    80005504:	ffffe097          	auipc	ra,0xffffe
    80005508:	1f8080e7          	jalr	504(ra) # 800036fc <ilock>
  ip->nlink--;
    8000550c:	04a4d783          	lhu	a5,74(s1)
    80005510:	37fd                	addiw	a5,a5,-1
    80005512:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005516:	8526                	mv	a0,s1
    80005518:	ffffe097          	auipc	ra,0xffffe
    8000551c:	118080e7          	jalr	280(ra) # 80003630 <iupdate>
  iunlockput(ip);
    80005520:	8526                	mv	a0,s1
    80005522:	ffffe097          	auipc	ra,0xffffe
    80005526:	43e080e7          	jalr	1086(ra) # 80003960 <iunlockput>
  end_op();
    8000552a:	fffff097          	auipc	ra,0xfffff
    8000552e:	c1a080e7          	jalr	-998(ra) # 80004144 <end_op>
  return -1;
    80005532:	57fd                	li	a5,-1
}
    80005534:	853e                	mv	a0,a5
    80005536:	70b2                	ld	ra,296(sp)
    80005538:	7412                	ld	s0,288(sp)
    8000553a:	64f2                	ld	s1,280(sp)
    8000553c:	6952                	ld	s2,272(sp)
    8000553e:	6155                	addi	sp,sp,304
    80005540:	8082                	ret

0000000080005542 <sys_unlink>:
{
    80005542:	7151                	addi	sp,sp,-240
    80005544:	f586                	sd	ra,232(sp)
    80005546:	f1a2                	sd	s0,224(sp)
    80005548:	eda6                	sd	s1,216(sp)
    8000554a:	e9ca                	sd	s2,208(sp)
    8000554c:	e5ce                	sd	s3,200(sp)
    8000554e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005550:	08000613          	li	a2,128
    80005554:	f3040593          	addi	a1,s0,-208
    80005558:	4501                	li	a0,0
    8000555a:	ffffd097          	auipc	ra,0xffffd
    8000555e:	626080e7          	jalr	1574(ra) # 80002b80 <argstr>
    80005562:	16054f63          	bltz	a0,800056e0 <sys_unlink+0x19e>
  begin_op();
    80005566:	fffff097          	auipc	ra,0xfffff
    8000556a:	b5e080e7          	jalr	-1186(ra) # 800040c4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000556e:	fb040593          	addi	a1,s0,-80
    80005572:	f3040513          	addi	a0,s0,-208
    80005576:	fffff097          	auipc	ra,0xfffff
    8000557a:	95e080e7          	jalr	-1698(ra) # 80003ed4 <nameiparent>
    8000557e:	89aa                	mv	s3,a0
    80005580:	c979                	beqz	a0,80005656 <sys_unlink+0x114>
  ilock(dp);
    80005582:	ffffe097          	auipc	ra,0xffffe
    80005586:	17a080e7          	jalr	378(ra) # 800036fc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000558a:	00003597          	auipc	a1,0x3
    8000558e:	15e58593          	addi	a1,a1,350 # 800086e8 <syscalls+0x2e8>
    80005592:	fb040513          	addi	a0,s0,-80
    80005596:	ffffe097          	auipc	ra,0xffffe
    8000559a:	62c080e7          	jalr	1580(ra) # 80003bc2 <namecmp>
    8000559e:	14050863          	beqz	a0,800056ee <sys_unlink+0x1ac>
    800055a2:	00003597          	auipc	a1,0x3
    800055a6:	14e58593          	addi	a1,a1,334 # 800086f0 <syscalls+0x2f0>
    800055aa:	fb040513          	addi	a0,s0,-80
    800055ae:	ffffe097          	auipc	ra,0xffffe
    800055b2:	614080e7          	jalr	1556(ra) # 80003bc2 <namecmp>
    800055b6:	12050c63          	beqz	a0,800056ee <sys_unlink+0x1ac>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800055ba:	f2c40613          	addi	a2,s0,-212
    800055be:	fb040593          	addi	a1,s0,-80
    800055c2:	854e                	mv	a0,s3
    800055c4:	ffffe097          	auipc	ra,0xffffe
    800055c8:	618080e7          	jalr	1560(ra) # 80003bdc <dirlookup>
    800055cc:	84aa                	mv	s1,a0
    800055ce:	12050063          	beqz	a0,800056ee <sys_unlink+0x1ac>
  ilock(ip);
    800055d2:	ffffe097          	auipc	ra,0xffffe
    800055d6:	12a080e7          	jalr	298(ra) # 800036fc <ilock>
  if(ip->nlink < 1)
    800055da:	04a49783          	lh	a5,74(s1)
    800055de:	08f05263          	blez	a5,80005662 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800055e2:	04449703          	lh	a4,68(s1)
    800055e6:	4785                	li	a5,1
    800055e8:	08f70563          	beq	a4,a5,80005672 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800055ec:	4641                	li	a2,16
    800055ee:	4581                	li	a1,0
    800055f0:	fc040513          	addi	a0,s0,-64
    800055f4:	ffffb097          	auipc	ra,0xffffb
    800055f8:	76a080e7          	jalr	1898(ra) # 80000d5e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055fc:	4741                	li	a4,16
    800055fe:	f2c42683          	lw	a3,-212(s0)
    80005602:	fc040613          	addi	a2,s0,-64
    80005606:	4581                	li	a1,0
    80005608:	854e                	mv	a0,s3
    8000560a:	ffffe097          	auipc	ra,0xffffe
    8000560e:	49e080e7          	jalr	1182(ra) # 80003aa8 <writei>
    80005612:	47c1                	li	a5,16
    80005614:	0af51363          	bne	a0,a5,800056ba <sys_unlink+0x178>
  if(ip->type == T_DIR){
    80005618:	04449703          	lh	a4,68(s1)
    8000561c:	4785                	li	a5,1
    8000561e:	0af70663          	beq	a4,a5,800056ca <sys_unlink+0x188>
  iunlockput(dp);
    80005622:	854e                	mv	a0,s3
    80005624:	ffffe097          	auipc	ra,0xffffe
    80005628:	33c080e7          	jalr	828(ra) # 80003960 <iunlockput>
  ip->nlink--;
    8000562c:	04a4d783          	lhu	a5,74(s1)
    80005630:	37fd                	addiw	a5,a5,-1
    80005632:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005636:	8526                	mv	a0,s1
    80005638:	ffffe097          	auipc	ra,0xffffe
    8000563c:	ff8080e7          	jalr	-8(ra) # 80003630 <iupdate>
  iunlockput(ip);
    80005640:	8526                	mv	a0,s1
    80005642:	ffffe097          	auipc	ra,0xffffe
    80005646:	31e080e7          	jalr	798(ra) # 80003960 <iunlockput>
  end_op();
    8000564a:	fffff097          	auipc	ra,0xfffff
    8000564e:	afa080e7          	jalr	-1286(ra) # 80004144 <end_op>
  return 0;
    80005652:	4501                	li	a0,0
    80005654:	a07d                	j	80005702 <sys_unlink+0x1c0>
    end_op();
    80005656:	fffff097          	auipc	ra,0xfffff
    8000565a:	aee080e7          	jalr	-1298(ra) # 80004144 <end_op>
    return -1;
    8000565e:	557d                	li	a0,-1
    80005660:	a04d                	j	80005702 <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    80005662:	00003517          	auipc	a0,0x3
    80005666:	0b650513          	addi	a0,a0,182 # 80008718 <syscalls+0x318>
    8000566a:	ffffb097          	auipc	ra,0xffffb
    8000566e:	f0a080e7          	jalr	-246(ra) # 80000574 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005672:	44f8                	lw	a4,76(s1)
    80005674:	02000793          	li	a5,32
    80005678:	f6e7fae3          	bleu	a4,a5,800055ec <sys_unlink+0xaa>
    8000567c:	02000913          	li	s2,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005680:	4741                	li	a4,16
    80005682:	86ca                	mv	a3,s2
    80005684:	f1840613          	addi	a2,s0,-232
    80005688:	4581                	li	a1,0
    8000568a:	8526                	mv	a0,s1
    8000568c:	ffffe097          	auipc	ra,0xffffe
    80005690:	326080e7          	jalr	806(ra) # 800039b2 <readi>
    80005694:	47c1                	li	a5,16
    80005696:	00f51a63          	bne	a0,a5,800056aa <sys_unlink+0x168>
    if(de.inum != 0)
    8000569a:	f1845783          	lhu	a5,-232(s0)
    8000569e:	e3b9                	bnez	a5,800056e4 <sys_unlink+0x1a2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800056a0:	2941                	addiw	s2,s2,16
    800056a2:	44fc                	lw	a5,76(s1)
    800056a4:	fcf96ee3          	bltu	s2,a5,80005680 <sys_unlink+0x13e>
    800056a8:	b791                	j	800055ec <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800056aa:	00003517          	auipc	a0,0x3
    800056ae:	08650513          	addi	a0,a0,134 # 80008730 <syscalls+0x330>
    800056b2:	ffffb097          	auipc	ra,0xffffb
    800056b6:	ec2080e7          	jalr	-318(ra) # 80000574 <panic>
    panic("unlink: writei");
    800056ba:	00003517          	auipc	a0,0x3
    800056be:	08e50513          	addi	a0,a0,142 # 80008748 <syscalls+0x348>
    800056c2:	ffffb097          	auipc	ra,0xffffb
    800056c6:	eb2080e7          	jalr	-334(ra) # 80000574 <panic>
    dp->nlink--;
    800056ca:	04a9d783          	lhu	a5,74(s3)
    800056ce:	37fd                	addiw	a5,a5,-1
    800056d0:	04f99523          	sh	a5,74(s3)
    iupdate(dp);
    800056d4:	854e                	mv	a0,s3
    800056d6:	ffffe097          	auipc	ra,0xffffe
    800056da:	f5a080e7          	jalr	-166(ra) # 80003630 <iupdate>
    800056de:	b791                	j	80005622 <sys_unlink+0xe0>
    return -1;
    800056e0:	557d                	li	a0,-1
    800056e2:	a005                	j	80005702 <sys_unlink+0x1c0>
    iunlockput(ip);
    800056e4:	8526                	mv	a0,s1
    800056e6:	ffffe097          	auipc	ra,0xffffe
    800056ea:	27a080e7          	jalr	634(ra) # 80003960 <iunlockput>
  iunlockput(dp);
    800056ee:	854e                	mv	a0,s3
    800056f0:	ffffe097          	auipc	ra,0xffffe
    800056f4:	270080e7          	jalr	624(ra) # 80003960 <iunlockput>
  end_op();
    800056f8:	fffff097          	auipc	ra,0xfffff
    800056fc:	a4c080e7          	jalr	-1460(ra) # 80004144 <end_op>
  return -1;
    80005700:	557d                	li	a0,-1
}
    80005702:	70ae                	ld	ra,232(sp)
    80005704:	740e                	ld	s0,224(sp)
    80005706:	64ee                	ld	s1,216(sp)
    80005708:	694e                	ld	s2,208(sp)
    8000570a:	69ae                	ld	s3,200(sp)
    8000570c:	616d                	addi	sp,sp,240
    8000570e:	8082                	ret

0000000080005710 <sys_open>:

uint64
sys_open(void)
{
    80005710:	7131                	addi	sp,sp,-192
    80005712:	fd06                	sd	ra,184(sp)
    80005714:	f922                	sd	s0,176(sp)
    80005716:	f526                	sd	s1,168(sp)
    80005718:	f14a                	sd	s2,160(sp)
    8000571a:	ed4e                	sd	s3,152(sp)
    8000571c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000571e:	08000613          	li	a2,128
    80005722:	f5040593          	addi	a1,s0,-176
    80005726:	4501                	li	a0,0
    80005728:	ffffd097          	auipc	ra,0xffffd
    8000572c:	458080e7          	jalr	1112(ra) # 80002b80 <argstr>
    return -1;
    80005730:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005732:	0c054163          	bltz	a0,800057f4 <sys_open+0xe4>
    80005736:	f4c40593          	addi	a1,s0,-180
    8000573a:	4505                	li	a0,1
    8000573c:	ffffd097          	auipc	ra,0xffffd
    80005740:	400080e7          	jalr	1024(ra) # 80002b3c <argint>
    80005744:	0a054863          	bltz	a0,800057f4 <sys_open+0xe4>

  begin_op();
    80005748:	fffff097          	auipc	ra,0xfffff
    8000574c:	97c080e7          	jalr	-1668(ra) # 800040c4 <begin_op>

  if(omode & O_CREATE){
    80005750:	f4c42783          	lw	a5,-180(s0)
    80005754:	2007f793          	andi	a5,a5,512
    80005758:	cbdd                	beqz	a5,8000580e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    8000575a:	4681                	li	a3,0
    8000575c:	4601                	li	a2,0
    8000575e:	4589                	li	a1,2
    80005760:	f5040513          	addi	a0,s0,-176
    80005764:	00000097          	auipc	ra,0x0
    80005768:	976080e7          	jalr	-1674(ra) # 800050da <create>
    8000576c:	892a                	mv	s2,a0
    if(ip == 0){
    8000576e:	c959                	beqz	a0,80005804 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005770:	04491703          	lh	a4,68(s2)
    80005774:	478d                	li	a5,3
    80005776:	00f71763          	bne	a4,a5,80005784 <sys_open+0x74>
    8000577a:	04695703          	lhu	a4,70(s2)
    8000577e:	47a5                	li	a5,9
    80005780:	0ce7ec63          	bltu	a5,a4,80005858 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005784:	fffff097          	auipc	ra,0xfffff
    80005788:	d72080e7          	jalr	-654(ra) # 800044f6 <filealloc>
    8000578c:	89aa                	mv	s3,a0
    8000578e:	10050263          	beqz	a0,80005892 <sys_open+0x182>
    80005792:	00000097          	auipc	ra,0x0
    80005796:	900080e7          	jalr	-1792(ra) # 80005092 <fdalloc>
    8000579a:	84aa                	mv	s1,a0
    8000579c:	0e054663          	bltz	a0,80005888 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800057a0:	04491703          	lh	a4,68(s2)
    800057a4:	478d                	li	a5,3
    800057a6:	0cf70463          	beq	a4,a5,8000586e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800057aa:	4789                	li	a5,2
    800057ac:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800057b0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800057b4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800057b8:	f4c42783          	lw	a5,-180(s0)
    800057bc:	0017c713          	xori	a4,a5,1
    800057c0:	8b05                	andi	a4,a4,1
    800057c2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800057c6:	0037f713          	andi	a4,a5,3
    800057ca:	00e03733          	snez	a4,a4
    800057ce:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800057d2:	4007f793          	andi	a5,a5,1024
    800057d6:	c791                	beqz	a5,800057e2 <sys_open+0xd2>
    800057d8:	04491703          	lh	a4,68(s2)
    800057dc:	4789                	li	a5,2
    800057de:	08f70f63          	beq	a4,a5,8000587c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    800057e2:	854a                	mv	a0,s2
    800057e4:	ffffe097          	auipc	ra,0xffffe
    800057e8:	fdc080e7          	jalr	-36(ra) # 800037c0 <iunlock>
  end_op();
    800057ec:	fffff097          	auipc	ra,0xfffff
    800057f0:	958080e7          	jalr	-1704(ra) # 80004144 <end_op>

  return fd;
}
    800057f4:	8526                	mv	a0,s1
    800057f6:	70ea                	ld	ra,184(sp)
    800057f8:	744a                	ld	s0,176(sp)
    800057fa:	74aa                	ld	s1,168(sp)
    800057fc:	790a                	ld	s2,160(sp)
    800057fe:	69ea                	ld	s3,152(sp)
    80005800:	6129                	addi	sp,sp,192
    80005802:	8082                	ret
      end_op();
    80005804:	fffff097          	auipc	ra,0xfffff
    80005808:	940080e7          	jalr	-1728(ra) # 80004144 <end_op>
      return -1;
    8000580c:	b7e5                	j	800057f4 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    8000580e:	f5040513          	addi	a0,s0,-176
    80005812:	ffffe097          	auipc	ra,0xffffe
    80005816:	6a4080e7          	jalr	1700(ra) # 80003eb6 <namei>
    8000581a:	892a                	mv	s2,a0
    8000581c:	c905                	beqz	a0,8000584c <sys_open+0x13c>
    ilock(ip);
    8000581e:	ffffe097          	auipc	ra,0xffffe
    80005822:	ede080e7          	jalr	-290(ra) # 800036fc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005826:	04491703          	lh	a4,68(s2)
    8000582a:	4785                	li	a5,1
    8000582c:	f4f712e3          	bne	a4,a5,80005770 <sys_open+0x60>
    80005830:	f4c42783          	lw	a5,-180(s0)
    80005834:	dba1                	beqz	a5,80005784 <sys_open+0x74>
      iunlockput(ip);
    80005836:	854a                	mv	a0,s2
    80005838:	ffffe097          	auipc	ra,0xffffe
    8000583c:	128080e7          	jalr	296(ra) # 80003960 <iunlockput>
      end_op();
    80005840:	fffff097          	auipc	ra,0xfffff
    80005844:	904080e7          	jalr	-1788(ra) # 80004144 <end_op>
      return -1;
    80005848:	54fd                	li	s1,-1
    8000584a:	b76d                	j	800057f4 <sys_open+0xe4>
      end_op();
    8000584c:	fffff097          	auipc	ra,0xfffff
    80005850:	8f8080e7          	jalr	-1800(ra) # 80004144 <end_op>
      return -1;
    80005854:	54fd                	li	s1,-1
    80005856:	bf79                	j	800057f4 <sys_open+0xe4>
    iunlockput(ip);
    80005858:	854a                	mv	a0,s2
    8000585a:	ffffe097          	auipc	ra,0xffffe
    8000585e:	106080e7          	jalr	262(ra) # 80003960 <iunlockput>
    end_op();
    80005862:	fffff097          	auipc	ra,0xfffff
    80005866:	8e2080e7          	jalr	-1822(ra) # 80004144 <end_op>
    return -1;
    8000586a:	54fd                	li	s1,-1
    8000586c:	b761                	j	800057f4 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000586e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005872:	04691783          	lh	a5,70(s2)
    80005876:	02f99223          	sh	a5,36(s3)
    8000587a:	bf2d                	j	800057b4 <sys_open+0xa4>
    itrunc(ip);
    8000587c:	854a                	mv	a0,s2
    8000587e:	ffffe097          	auipc	ra,0xffffe
    80005882:	f8e080e7          	jalr	-114(ra) # 8000380c <itrunc>
    80005886:	bfb1                	j	800057e2 <sys_open+0xd2>
      fileclose(f);
    80005888:	854e                	mv	a0,s3
    8000588a:	fffff097          	auipc	ra,0xfffff
    8000588e:	d3c080e7          	jalr	-708(ra) # 800045c6 <fileclose>
    iunlockput(ip);
    80005892:	854a                	mv	a0,s2
    80005894:	ffffe097          	auipc	ra,0xffffe
    80005898:	0cc080e7          	jalr	204(ra) # 80003960 <iunlockput>
    end_op();
    8000589c:	fffff097          	auipc	ra,0xfffff
    800058a0:	8a8080e7          	jalr	-1880(ra) # 80004144 <end_op>
    return -1;
    800058a4:	54fd                	li	s1,-1
    800058a6:	b7b9                	j	800057f4 <sys_open+0xe4>

00000000800058a8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800058a8:	7175                	addi	sp,sp,-144
    800058aa:	e506                	sd	ra,136(sp)
    800058ac:	e122                	sd	s0,128(sp)
    800058ae:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800058b0:	fffff097          	auipc	ra,0xfffff
    800058b4:	814080e7          	jalr	-2028(ra) # 800040c4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800058b8:	08000613          	li	a2,128
    800058bc:	f7040593          	addi	a1,s0,-144
    800058c0:	4501                	li	a0,0
    800058c2:	ffffd097          	auipc	ra,0xffffd
    800058c6:	2be080e7          	jalr	702(ra) # 80002b80 <argstr>
    800058ca:	02054963          	bltz	a0,800058fc <sys_mkdir+0x54>
    800058ce:	4681                	li	a3,0
    800058d0:	4601                	li	a2,0
    800058d2:	4585                	li	a1,1
    800058d4:	f7040513          	addi	a0,s0,-144
    800058d8:	00000097          	auipc	ra,0x0
    800058dc:	802080e7          	jalr	-2046(ra) # 800050da <create>
    800058e0:	cd11                	beqz	a0,800058fc <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058e2:	ffffe097          	auipc	ra,0xffffe
    800058e6:	07e080e7          	jalr	126(ra) # 80003960 <iunlockput>
  end_op();
    800058ea:	fffff097          	auipc	ra,0xfffff
    800058ee:	85a080e7          	jalr	-1958(ra) # 80004144 <end_op>
  return 0;
    800058f2:	4501                	li	a0,0
}
    800058f4:	60aa                	ld	ra,136(sp)
    800058f6:	640a                	ld	s0,128(sp)
    800058f8:	6149                	addi	sp,sp,144
    800058fa:	8082                	ret
    end_op();
    800058fc:	fffff097          	auipc	ra,0xfffff
    80005900:	848080e7          	jalr	-1976(ra) # 80004144 <end_op>
    return -1;
    80005904:	557d                	li	a0,-1
    80005906:	b7fd                	j	800058f4 <sys_mkdir+0x4c>

0000000080005908 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005908:	7135                	addi	sp,sp,-160
    8000590a:	ed06                	sd	ra,152(sp)
    8000590c:	e922                	sd	s0,144(sp)
    8000590e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005910:	ffffe097          	auipc	ra,0xffffe
    80005914:	7b4080e7          	jalr	1972(ra) # 800040c4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005918:	08000613          	li	a2,128
    8000591c:	f7040593          	addi	a1,s0,-144
    80005920:	4501                	li	a0,0
    80005922:	ffffd097          	auipc	ra,0xffffd
    80005926:	25e080e7          	jalr	606(ra) # 80002b80 <argstr>
    8000592a:	04054a63          	bltz	a0,8000597e <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000592e:	f6c40593          	addi	a1,s0,-148
    80005932:	4505                	li	a0,1
    80005934:	ffffd097          	auipc	ra,0xffffd
    80005938:	208080e7          	jalr	520(ra) # 80002b3c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000593c:	04054163          	bltz	a0,8000597e <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005940:	f6840593          	addi	a1,s0,-152
    80005944:	4509                	li	a0,2
    80005946:	ffffd097          	auipc	ra,0xffffd
    8000594a:	1f6080e7          	jalr	502(ra) # 80002b3c <argint>
     argint(1, &major) < 0 ||
    8000594e:	02054863          	bltz	a0,8000597e <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005952:	f6841683          	lh	a3,-152(s0)
    80005956:	f6c41603          	lh	a2,-148(s0)
    8000595a:	458d                	li	a1,3
    8000595c:	f7040513          	addi	a0,s0,-144
    80005960:	fffff097          	auipc	ra,0xfffff
    80005964:	77a080e7          	jalr	1914(ra) # 800050da <create>
     argint(2, &minor) < 0 ||
    80005968:	c919                	beqz	a0,8000597e <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000596a:	ffffe097          	auipc	ra,0xffffe
    8000596e:	ff6080e7          	jalr	-10(ra) # 80003960 <iunlockput>
  end_op();
    80005972:	ffffe097          	auipc	ra,0xffffe
    80005976:	7d2080e7          	jalr	2002(ra) # 80004144 <end_op>
  return 0;
    8000597a:	4501                	li	a0,0
    8000597c:	a031                	j	80005988 <sys_mknod+0x80>
    end_op();
    8000597e:	ffffe097          	auipc	ra,0xffffe
    80005982:	7c6080e7          	jalr	1990(ra) # 80004144 <end_op>
    return -1;
    80005986:	557d                	li	a0,-1
}
    80005988:	60ea                	ld	ra,152(sp)
    8000598a:	644a                	ld	s0,144(sp)
    8000598c:	610d                	addi	sp,sp,160
    8000598e:	8082                	ret

0000000080005990 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005990:	7135                	addi	sp,sp,-160
    80005992:	ed06                	sd	ra,152(sp)
    80005994:	e922                	sd	s0,144(sp)
    80005996:	e526                	sd	s1,136(sp)
    80005998:	e14a                	sd	s2,128(sp)
    8000599a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000599c:	ffffc097          	auipc	ra,0xffffc
    800059a0:	0d4080e7          	jalr	212(ra) # 80001a70 <myproc>
    800059a4:	892a                	mv	s2,a0
  
  begin_op();
    800059a6:	ffffe097          	auipc	ra,0xffffe
    800059aa:	71e080e7          	jalr	1822(ra) # 800040c4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800059ae:	08000613          	li	a2,128
    800059b2:	f6040593          	addi	a1,s0,-160
    800059b6:	4501                	li	a0,0
    800059b8:	ffffd097          	auipc	ra,0xffffd
    800059bc:	1c8080e7          	jalr	456(ra) # 80002b80 <argstr>
    800059c0:	04054b63          	bltz	a0,80005a16 <sys_chdir+0x86>
    800059c4:	f6040513          	addi	a0,s0,-160
    800059c8:	ffffe097          	auipc	ra,0xffffe
    800059cc:	4ee080e7          	jalr	1262(ra) # 80003eb6 <namei>
    800059d0:	84aa                	mv	s1,a0
    800059d2:	c131                	beqz	a0,80005a16 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800059d4:	ffffe097          	auipc	ra,0xffffe
    800059d8:	d28080e7          	jalr	-728(ra) # 800036fc <ilock>
  if(ip->type != T_DIR){
    800059dc:	04449703          	lh	a4,68(s1)
    800059e0:	4785                	li	a5,1
    800059e2:	04f71063          	bne	a4,a5,80005a22 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800059e6:	8526                	mv	a0,s1
    800059e8:	ffffe097          	auipc	ra,0xffffe
    800059ec:	dd8080e7          	jalr	-552(ra) # 800037c0 <iunlock>
  iput(p->cwd);
    800059f0:	15093503          	ld	a0,336(s2)
    800059f4:	ffffe097          	auipc	ra,0xffffe
    800059f8:	ec4080e7          	jalr	-316(ra) # 800038b8 <iput>
  end_op();
    800059fc:	ffffe097          	auipc	ra,0xffffe
    80005a00:	748080e7          	jalr	1864(ra) # 80004144 <end_op>
  p->cwd = ip;
    80005a04:	14993823          	sd	s1,336(s2)
  return 0;
    80005a08:	4501                	li	a0,0
}
    80005a0a:	60ea                	ld	ra,152(sp)
    80005a0c:	644a                	ld	s0,144(sp)
    80005a0e:	64aa                	ld	s1,136(sp)
    80005a10:	690a                	ld	s2,128(sp)
    80005a12:	610d                	addi	sp,sp,160
    80005a14:	8082                	ret
    end_op();
    80005a16:	ffffe097          	auipc	ra,0xffffe
    80005a1a:	72e080e7          	jalr	1838(ra) # 80004144 <end_op>
    return -1;
    80005a1e:	557d                	li	a0,-1
    80005a20:	b7ed                	j	80005a0a <sys_chdir+0x7a>
    iunlockput(ip);
    80005a22:	8526                	mv	a0,s1
    80005a24:	ffffe097          	auipc	ra,0xffffe
    80005a28:	f3c080e7          	jalr	-196(ra) # 80003960 <iunlockput>
    end_op();
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	718080e7          	jalr	1816(ra) # 80004144 <end_op>
    return -1;
    80005a34:	557d                	li	a0,-1
    80005a36:	bfd1                	j	80005a0a <sys_chdir+0x7a>

0000000080005a38 <sys_exec>:

uint64
sys_exec(void)
{
    80005a38:	7145                	addi	sp,sp,-464
    80005a3a:	e786                	sd	ra,456(sp)
    80005a3c:	e3a2                	sd	s0,448(sp)
    80005a3e:	ff26                	sd	s1,440(sp)
    80005a40:	fb4a                	sd	s2,432(sp)
    80005a42:	f74e                	sd	s3,424(sp)
    80005a44:	f352                	sd	s4,416(sp)
    80005a46:	ef56                	sd	s5,408(sp)
    80005a48:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005a4a:	08000613          	li	a2,128
    80005a4e:	f4040593          	addi	a1,s0,-192
    80005a52:	4501                	li	a0,0
    80005a54:	ffffd097          	auipc	ra,0xffffd
    80005a58:	12c080e7          	jalr	300(ra) # 80002b80 <argstr>
    return -1;
    80005a5c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005a5e:	0e054c63          	bltz	a0,80005b56 <sys_exec+0x11e>
    80005a62:	e3840593          	addi	a1,s0,-456
    80005a66:	4505                	li	a0,1
    80005a68:	ffffd097          	auipc	ra,0xffffd
    80005a6c:	0f6080e7          	jalr	246(ra) # 80002b5e <argaddr>
    80005a70:	0e054363          	bltz	a0,80005b56 <sys_exec+0x11e>
  }
  memset(argv, 0, sizeof(argv));
    80005a74:	e4040913          	addi	s2,s0,-448
    80005a78:	10000613          	li	a2,256
    80005a7c:	4581                	li	a1,0
    80005a7e:	854a                	mv	a0,s2
    80005a80:	ffffb097          	auipc	ra,0xffffb
    80005a84:	2de080e7          	jalr	734(ra) # 80000d5e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a88:	89ca                	mv	s3,s2
  memset(argv, 0, sizeof(argv));
    80005a8a:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005a8c:	02000a93          	li	s5,32
    80005a90:	00048a1b          	sext.w	s4,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a94:	00349513          	slli	a0,s1,0x3
    80005a98:	e3040593          	addi	a1,s0,-464
    80005a9c:	e3843783          	ld	a5,-456(s0)
    80005aa0:	953e                	add	a0,a0,a5
    80005aa2:	ffffd097          	auipc	ra,0xffffd
    80005aa6:	ffe080e7          	jalr	-2(ra) # 80002aa0 <fetchaddr>
    80005aaa:	02054a63          	bltz	a0,80005ade <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005aae:	e3043783          	ld	a5,-464(s0)
    80005ab2:	cfa9                	beqz	a5,80005b0c <sys_exec+0xd4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005ab4:	ffffb097          	auipc	ra,0xffffb
    80005ab8:	0be080e7          	jalr	190(ra) # 80000b72 <kalloc>
    80005abc:	00a93023          	sd	a0,0(s2)
    if(argv[i] == 0)
    80005ac0:	cd19                	beqz	a0,80005ade <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005ac2:	6605                	lui	a2,0x1
    80005ac4:	85aa                	mv	a1,a0
    80005ac6:	e3043503          	ld	a0,-464(s0)
    80005aca:	ffffd097          	auipc	ra,0xffffd
    80005ace:	02a080e7          	jalr	42(ra) # 80002af4 <fetchstr>
    80005ad2:	00054663          	bltz	a0,80005ade <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005ad6:	0485                	addi	s1,s1,1
    80005ad8:	0921                	addi	s2,s2,8
    80005ada:	fb549be3          	bne	s1,s5,80005a90 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ade:	e4043503          	ld	a0,-448(s0)
    kfree(argv[i]);
  return -1;
    80005ae2:	597d                	li	s2,-1
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ae4:	c92d                	beqz	a0,80005b56 <sys_exec+0x11e>
    kfree(argv[i]);
    80005ae6:	ffffb097          	auipc	ra,0xffffb
    80005aea:	f8c080e7          	jalr	-116(ra) # 80000a72 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005aee:	e4840493          	addi	s1,s0,-440
    80005af2:	10098993          	addi	s3,s3,256
    80005af6:	6088                	ld	a0,0(s1)
    80005af8:	cd31                	beqz	a0,80005b54 <sys_exec+0x11c>
    kfree(argv[i]);
    80005afa:	ffffb097          	auipc	ra,0xffffb
    80005afe:	f78080e7          	jalr	-136(ra) # 80000a72 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b02:	04a1                	addi	s1,s1,8
    80005b04:	ff3499e3          	bne	s1,s3,80005af6 <sys_exec+0xbe>
  return -1;
    80005b08:	597d                	li	s2,-1
    80005b0a:	a0b1                	j	80005b56 <sys_exec+0x11e>
      argv[i] = 0;
    80005b0c:	0a0e                	slli	s4,s4,0x3
    80005b0e:	fc040793          	addi	a5,s0,-64
    80005b12:	9a3e                	add	s4,s4,a5
    80005b14:	e80a3023          	sd	zero,-384(s4)
  int ret = exec(path, argv);
    80005b18:	e4040593          	addi	a1,s0,-448
    80005b1c:	f4040513          	addi	a0,s0,-192
    80005b20:	fffff097          	auipc	ra,0xfffff
    80005b24:	166080e7          	jalr	358(ra) # 80004c86 <exec>
    80005b28:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b2a:	e4043503          	ld	a0,-448(s0)
    80005b2e:	c505                	beqz	a0,80005b56 <sys_exec+0x11e>
    kfree(argv[i]);
    80005b30:	ffffb097          	auipc	ra,0xffffb
    80005b34:	f42080e7          	jalr	-190(ra) # 80000a72 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b38:	e4840493          	addi	s1,s0,-440
    80005b3c:	10098993          	addi	s3,s3,256
    80005b40:	6088                	ld	a0,0(s1)
    80005b42:	c911                	beqz	a0,80005b56 <sys_exec+0x11e>
    kfree(argv[i]);
    80005b44:	ffffb097          	auipc	ra,0xffffb
    80005b48:	f2e080e7          	jalr	-210(ra) # 80000a72 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b4c:	04a1                	addi	s1,s1,8
    80005b4e:	ff3499e3          	bne	s1,s3,80005b40 <sys_exec+0x108>
    80005b52:	a011                	j	80005b56 <sys_exec+0x11e>
  return -1;
    80005b54:	597d                	li	s2,-1
}
    80005b56:	854a                	mv	a0,s2
    80005b58:	60be                	ld	ra,456(sp)
    80005b5a:	641e                	ld	s0,448(sp)
    80005b5c:	74fa                	ld	s1,440(sp)
    80005b5e:	795a                	ld	s2,432(sp)
    80005b60:	79ba                	ld	s3,424(sp)
    80005b62:	7a1a                	ld	s4,416(sp)
    80005b64:	6afa                	ld	s5,408(sp)
    80005b66:	6179                	addi	sp,sp,464
    80005b68:	8082                	ret

0000000080005b6a <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b6a:	7139                	addi	sp,sp,-64
    80005b6c:	fc06                	sd	ra,56(sp)
    80005b6e:	f822                	sd	s0,48(sp)
    80005b70:	f426                	sd	s1,40(sp)
    80005b72:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b74:	ffffc097          	auipc	ra,0xffffc
    80005b78:	efc080e7          	jalr	-260(ra) # 80001a70 <myproc>
    80005b7c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005b7e:	fd840593          	addi	a1,s0,-40
    80005b82:	4501                	li	a0,0
    80005b84:	ffffd097          	auipc	ra,0xffffd
    80005b88:	fda080e7          	jalr	-38(ra) # 80002b5e <argaddr>
    return -1;
    80005b8c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005b8e:	0c054f63          	bltz	a0,80005c6c <sys_pipe+0x102>
  if(pipealloc(&rf, &wf) < 0)
    80005b92:	fc840593          	addi	a1,s0,-56
    80005b96:	fd040513          	addi	a0,s0,-48
    80005b9a:	fffff097          	auipc	ra,0xfffff
    80005b9e:	d74080e7          	jalr	-652(ra) # 8000490e <pipealloc>
    return -1;
    80005ba2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005ba4:	0c054463          	bltz	a0,80005c6c <sys_pipe+0x102>
  fd0 = -1;
    80005ba8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005bac:	fd043503          	ld	a0,-48(s0)
    80005bb0:	fffff097          	auipc	ra,0xfffff
    80005bb4:	4e2080e7          	jalr	1250(ra) # 80005092 <fdalloc>
    80005bb8:	fca42223          	sw	a0,-60(s0)
    80005bbc:	08054b63          	bltz	a0,80005c52 <sys_pipe+0xe8>
    80005bc0:	fc843503          	ld	a0,-56(s0)
    80005bc4:	fffff097          	auipc	ra,0xfffff
    80005bc8:	4ce080e7          	jalr	1230(ra) # 80005092 <fdalloc>
    80005bcc:	fca42023          	sw	a0,-64(s0)
    80005bd0:	06054863          	bltz	a0,80005c40 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005bd4:	4691                	li	a3,4
    80005bd6:	fc440613          	addi	a2,s0,-60
    80005bda:	fd843583          	ld	a1,-40(s0)
    80005bde:	68a8                	ld	a0,80(s1)
    80005be0:	ffffc097          	auipc	ra,0xffffc
    80005be4:	b6c080e7          	jalr	-1172(ra) # 8000174c <copyout>
    80005be8:	02054063          	bltz	a0,80005c08 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005bec:	4691                	li	a3,4
    80005bee:	fc040613          	addi	a2,s0,-64
    80005bf2:	fd843583          	ld	a1,-40(s0)
    80005bf6:	0591                	addi	a1,a1,4
    80005bf8:	68a8                	ld	a0,80(s1)
    80005bfa:	ffffc097          	auipc	ra,0xffffc
    80005bfe:	b52080e7          	jalr	-1198(ra) # 8000174c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005c02:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c04:	06055463          	bgez	a0,80005c6c <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    80005c08:	fc442783          	lw	a5,-60(s0)
    80005c0c:	07e9                	addi	a5,a5,26
    80005c0e:	078e                	slli	a5,a5,0x3
    80005c10:	97a6                	add	a5,a5,s1
    80005c12:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005c16:	fc042783          	lw	a5,-64(s0)
    80005c1a:	07e9                	addi	a5,a5,26
    80005c1c:	078e                	slli	a5,a5,0x3
    80005c1e:	94be                	add	s1,s1,a5
    80005c20:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005c24:	fd043503          	ld	a0,-48(s0)
    80005c28:	fffff097          	auipc	ra,0xfffff
    80005c2c:	99e080e7          	jalr	-1634(ra) # 800045c6 <fileclose>
    fileclose(wf);
    80005c30:	fc843503          	ld	a0,-56(s0)
    80005c34:	fffff097          	auipc	ra,0xfffff
    80005c38:	992080e7          	jalr	-1646(ra) # 800045c6 <fileclose>
    return -1;
    80005c3c:	57fd                	li	a5,-1
    80005c3e:	a03d                	j	80005c6c <sys_pipe+0x102>
    if(fd0 >= 0)
    80005c40:	fc442783          	lw	a5,-60(s0)
    80005c44:	0007c763          	bltz	a5,80005c52 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    80005c48:	07e9                	addi	a5,a5,26
    80005c4a:	078e                	slli	a5,a5,0x3
    80005c4c:	94be                	add	s1,s1,a5
    80005c4e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005c52:	fd043503          	ld	a0,-48(s0)
    80005c56:	fffff097          	auipc	ra,0xfffff
    80005c5a:	970080e7          	jalr	-1680(ra) # 800045c6 <fileclose>
    fileclose(wf);
    80005c5e:	fc843503          	ld	a0,-56(s0)
    80005c62:	fffff097          	auipc	ra,0xfffff
    80005c66:	964080e7          	jalr	-1692(ra) # 800045c6 <fileclose>
    return -1;
    80005c6a:	57fd                	li	a5,-1
}
    80005c6c:	853e                	mv	a0,a5
    80005c6e:	70e2                	ld	ra,56(sp)
    80005c70:	7442                	ld	s0,48(sp)
    80005c72:	74a2                	ld	s1,40(sp)
    80005c74:	6121                	addi	sp,sp,64
    80005c76:	8082                	ret
	...

0000000080005c80 <kernelvec>:
    80005c80:	7111                	addi	sp,sp,-256
    80005c82:	e006                	sd	ra,0(sp)
    80005c84:	e40a                	sd	sp,8(sp)
    80005c86:	e80e                	sd	gp,16(sp)
    80005c88:	ec12                	sd	tp,24(sp)
    80005c8a:	f016                	sd	t0,32(sp)
    80005c8c:	f41a                	sd	t1,40(sp)
    80005c8e:	f81e                	sd	t2,48(sp)
    80005c90:	fc22                	sd	s0,56(sp)
    80005c92:	e0a6                	sd	s1,64(sp)
    80005c94:	e4aa                	sd	a0,72(sp)
    80005c96:	e8ae                	sd	a1,80(sp)
    80005c98:	ecb2                	sd	a2,88(sp)
    80005c9a:	f0b6                	sd	a3,96(sp)
    80005c9c:	f4ba                	sd	a4,104(sp)
    80005c9e:	f8be                	sd	a5,112(sp)
    80005ca0:	fcc2                	sd	a6,120(sp)
    80005ca2:	e146                	sd	a7,128(sp)
    80005ca4:	e54a                	sd	s2,136(sp)
    80005ca6:	e94e                	sd	s3,144(sp)
    80005ca8:	ed52                	sd	s4,152(sp)
    80005caa:	f156                	sd	s5,160(sp)
    80005cac:	f55a                	sd	s6,168(sp)
    80005cae:	f95e                	sd	s7,176(sp)
    80005cb0:	fd62                	sd	s8,184(sp)
    80005cb2:	e1e6                	sd	s9,192(sp)
    80005cb4:	e5ea                	sd	s10,200(sp)
    80005cb6:	e9ee                	sd	s11,208(sp)
    80005cb8:	edf2                	sd	t3,216(sp)
    80005cba:	f1f6                	sd	t4,224(sp)
    80005cbc:	f5fa                	sd	t5,232(sp)
    80005cbe:	f9fe                	sd	t6,240(sp)
    80005cc0:	ca9fc0ef          	jal	ra,80002968 <kerneltrap>
    80005cc4:	6082                	ld	ra,0(sp)
    80005cc6:	6122                	ld	sp,8(sp)
    80005cc8:	61c2                	ld	gp,16(sp)
    80005cca:	7282                	ld	t0,32(sp)
    80005ccc:	7322                	ld	t1,40(sp)
    80005cce:	73c2                	ld	t2,48(sp)
    80005cd0:	7462                	ld	s0,56(sp)
    80005cd2:	6486                	ld	s1,64(sp)
    80005cd4:	6526                	ld	a0,72(sp)
    80005cd6:	65c6                	ld	a1,80(sp)
    80005cd8:	6666                	ld	a2,88(sp)
    80005cda:	7686                	ld	a3,96(sp)
    80005cdc:	7726                	ld	a4,104(sp)
    80005cde:	77c6                	ld	a5,112(sp)
    80005ce0:	7866                	ld	a6,120(sp)
    80005ce2:	688a                	ld	a7,128(sp)
    80005ce4:	692a                	ld	s2,136(sp)
    80005ce6:	69ca                	ld	s3,144(sp)
    80005ce8:	6a6a                	ld	s4,152(sp)
    80005cea:	7a8a                	ld	s5,160(sp)
    80005cec:	7b2a                	ld	s6,168(sp)
    80005cee:	7bca                	ld	s7,176(sp)
    80005cf0:	7c6a                	ld	s8,184(sp)
    80005cf2:	6c8e                	ld	s9,192(sp)
    80005cf4:	6d2e                	ld	s10,200(sp)
    80005cf6:	6dce                	ld	s11,208(sp)
    80005cf8:	6e6e                	ld	t3,216(sp)
    80005cfa:	7e8e                	ld	t4,224(sp)
    80005cfc:	7f2e                	ld	t5,232(sp)
    80005cfe:	7fce                	ld	t6,240(sp)
    80005d00:	6111                	addi	sp,sp,256
    80005d02:	10200073          	sret
    80005d06:	00000013          	nop
    80005d0a:	00000013          	nop
    80005d0e:	0001                	nop

0000000080005d10 <timervec>:
    80005d10:	34051573          	csrrw	a0,mscratch,a0
    80005d14:	e10c                	sd	a1,0(a0)
    80005d16:	e510                	sd	a2,8(a0)
    80005d18:	e914                	sd	a3,16(a0)
    80005d1a:	710c                	ld	a1,32(a0)
    80005d1c:	7510                	ld	a2,40(a0)
    80005d1e:	6194                	ld	a3,0(a1)
    80005d20:	96b2                	add	a3,a3,a2
    80005d22:	e194                	sd	a3,0(a1)
    80005d24:	4589                	li	a1,2
    80005d26:	14459073          	csrw	sip,a1
    80005d2a:	6914                	ld	a3,16(a0)
    80005d2c:	6510                	ld	a2,8(a0)
    80005d2e:	610c                	ld	a1,0(a0)
    80005d30:	34051573          	csrrw	a0,mscratch,a0
    80005d34:	30200073          	mret
	...

0000000080005d3a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005d3a:	1141                	addi	sp,sp,-16
    80005d3c:	e422                	sd	s0,8(sp)
    80005d3e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005d40:	0c0007b7          	lui	a5,0xc000
    80005d44:	4705                	li	a4,1
    80005d46:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005d48:	c3d8                	sw	a4,4(a5)
}
    80005d4a:	6422                	ld	s0,8(sp)
    80005d4c:	0141                	addi	sp,sp,16
    80005d4e:	8082                	ret

0000000080005d50 <plicinithart>:

void
plicinithart(void)
{
    80005d50:	1141                	addi	sp,sp,-16
    80005d52:	e406                	sd	ra,8(sp)
    80005d54:	e022                	sd	s0,0(sp)
    80005d56:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d58:	ffffc097          	auipc	ra,0xffffc
    80005d5c:	cec080e7          	jalr	-788(ra) # 80001a44 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005d60:	0085171b          	slliw	a4,a0,0x8
    80005d64:	0c0027b7          	lui	a5,0xc002
    80005d68:	97ba                	add	a5,a5,a4
    80005d6a:	40200713          	li	a4,1026
    80005d6e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005d72:	00d5151b          	slliw	a0,a0,0xd
    80005d76:	0c2017b7          	lui	a5,0xc201
    80005d7a:	953e                	add	a0,a0,a5
    80005d7c:	00052023          	sw	zero,0(a0)
}
    80005d80:	60a2                	ld	ra,8(sp)
    80005d82:	6402                	ld	s0,0(sp)
    80005d84:	0141                	addi	sp,sp,16
    80005d86:	8082                	ret

0000000080005d88 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005d88:	1141                	addi	sp,sp,-16
    80005d8a:	e406                	sd	ra,8(sp)
    80005d8c:	e022                	sd	s0,0(sp)
    80005d8e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d90:	ffffc097          	auipc	ra,0xffffc
    80005d94:	cb4080e7          	jalr	-844(ra) # 80001a44 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005d98:	00d5151b          	slliw	a0,a0,0xd
    80005d9c:	0c2017b7          	lui	a5,0xc201
    80005da0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005da2:	43c8                	lw	a0,4(a5)
    80005da4:	60a2                	ld	ra,8(sp)
    80005da6:	6402                	ld	s0,0(sp)
    80005da8:	0141                	addi	sp,sp,16
    80005daa:	8082                	ret

0000000080005dac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005dac:	1101                	addi	sp,sp,-32
    80005dae:	ec06                	sd	ra,24(sp)
    80005db0:	e822                	sd	s0,16(sp)
    80005db2:	e426                	sd	s1,8(sp)
    80005db4:	1000                	addi	s0,sp,32
    80005db6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005db8:	ffffc097          	auipc	ra,0xffffc
    80005dbc:	c8c080e7          	jalr	-884(ra) # 80001a44 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005dc0:	00d5151b          	slliw	a0,a0,0xd
    80005dc4:	0c2017b7          	lui	a5,0xc201
    80005dc8:	97aa                	add	a5,a5,a0
    80005dca:	c3c4                	sw	s1,4(a5)
}
    80005dcc:	60e2                	ld	ra,24(sp)
    80005dce:	6442                	ld	s0,16(sp)
    80005dd0:	64a2                	ld	s1,8(sp)
    80005dd2:	6105                	addi	sp,sp,32
    80005dd4:	8082                	ret

0000000080005dd6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005dd6:	1141                	addi	sp,sp,-16
    80005dd8:	e406                	sd	ra,8(sp)
    80005dda:	e022                	sd	s0,0(sp)
    80005ddc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005dde:	479d                	li	a5,7
    80005de0:	04a7cd63          	blt	a5,a0,80005e3a <free_desc+0x64>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005de4:	0001d797          	auipc	a5,0x1d
    80005de8:	21c78793          	addi	a5,a5,540 # 80023000 <disk>
    80005dec:	00a78733          	add	a4,a5,a0
    80005df0:	6789                	lui	a5,0x2
    80005df2:	97ba                	add	a5,a5,a4
    80005df4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005df8:	eba9                	bnez	a5,80005e4a <free_desc+0x74>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005dfa:	0001f797          	auipc	a5,0x1f
    80005dfe:	20678793          	addi	a5,a5,518 # 80025000 <disk+0x2000>
    80005e02:	639c                	ld	a5,0(a5)
    80005e04:	00451713          	slli	a4,a0,0x4
    80005e08:	97ba                	add	a5,a5,a4
    80005e0a:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005e0e:	0001d797          	auipc	a5,0x1d
    80005e12:	1f278793          	addi	a5,a5,498 # 80023000 <disk>
    80005e16:	97aa                	add	a5,a5,a0
    80005e18:	6509                	lui	a0,0x2
    80005e1a:	953e                	add	a0,a0,a5
    80005e1c:	4785                	li	a5,1
    80005e1e:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005e22:	0001f517          	auipc	a0,0x1f
    80005e26:	1f650513          	addi	a0,a0,502 # 80025018 <disk+0x2018>
    80005e2a:	ffffc097          	auipc	ra,0xffffc
    80005e2e:	5e2080e7          	jalr	1506(ra) # 8000240c <wakeup>
}
    80005e32:	60a2                	ld	ra,8(sp)
    80005e34:	6402                	ld	s0,0(sp)
    80005e36:	0141                	addi	sp,sp,16
    80005e38:	8082                	ret
    panic("virtio_disk_intr 1");
    80005e3a:	00003517          	auipc	a0,0x3
    80005e3e:	91e50513          	addi	a0,a0,-1762 # 80008758 <syscalls+0x358>
    80005e42:	ffffa097          	auipc	ra,0xffffa
    80005e46:	732080e7          	jalr	1842(ra) # 80000574 <panic>
    panic("virtio_disk_intr 2");
    80005e4a:	00003517          	auipc	a0,0x3
    80005e4e:	92650513          	addi	a0,a0,-1754 # 80008770 <syscalls+0x370>
    80005e52:	ffffa097          	auipc	ra,0xffffa
    80005e56:	722080e7          	jalr	1826(ra) # 80000574 <panic>

0000000080005e5a <virtio_disk_init>:
{
    80005e5a:	1101                	addi	sp,sp,-32
    80005e5c:	ec06                	sd	ra,24(sp)
    80005e5e:	e822                	sd	s0,16(sp)
    80005e60:	e426                	sd	s1,8(sp)
    80005e62:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005e64:	00003597          	auipc	a1,0x3
    80005e68:	92458593          	addi	a1,a1,-1756 # 80008788 <syscalls+0x388>
    80005e6c:	0001f517          	auipc	a0,0x1f
    80005e70:	23c50513          	addi	a0,a0,572 # 800250a8 <disk+0x20a8>
    80005e74:	ffffb097          	auipc	ra,0xffffb
    80005e78:	d5e080e7          	jalr	-674(ra) # 80000bd2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e7c:	100017b7          	lui	a5,0x10001
    80005e80:	4398                	lw	a4,0(a5)
    80005e82:	2701                	sext.w	a4,a4
    80005e84:	747277b7          	lui	a5,0x74727
    80005e88:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005e8c:	0ef71163          	bne	a4,a5,80005f6e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005e90:	100017b7          	lui	a5,0x10001
    80005e94:	43dc                	lw	a5,4(a5)
    80005e96:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e98:	4705                	li	a4,1
    80005e9a:	0ce79a63          	bne	a5,a4,80005f6e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e9e:	100017b7          	lui	a5,0x10001
    80005ea2:	479c                	lw	a5,8(a5)
    80005ea4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005ea6:	4709                	li	a4,2
    80005ea8:	0ce79363          	bne	a5,a4,80005f6e <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005eac:	100017b7          	lui	a5,0x10001
    80005eb0:	47d8                	lw	a4,12(a5)
    80005eb2:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005eb4:	554d47b7          	lui	a5,0x554d4
    80005eb8:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005ebc:	0af71963          	bne	a4,a5,80005f6e <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ec0:	100017b7          	lui	a5,0x10001
    80005ec4:	4705                	li	a4,1
    80005ec6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ec8:	470d                	li	a4,3
    80005eca:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005ecc:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005ece:	c7ffe737          	lui	a4,0xc7ffe
    80005ed2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005ed6:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005ed8:	2701                	sext.w	a4,a4
    80005eda:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005edc:	472d                	li	a4,11
    80005ede:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ee0:	473d                	li	a4,15
    80005ee2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005ee4:	6705                	lui	a4,0x1
    80005ee6:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005ee8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005eec:	5bdc                	lw	a5,52(a5)
    80005eee:	2781                	sext.w	a5,a5
  if(max == 0)
    80005ef0:	c7d9                	beqz	a5,80005f7e <virtio_disk_init+0x124>
  if(max < NUM)
    80005ef2:	471d                	li	a4,7
    80005ef4:	08f77d63          	bleu	a5,a4,80005f8e <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005ef8:	100014b7          	lui	s1,0x10001
    80005efc:	47a1                	li	a5,8
    80005efe:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005f00:	6609                	lui	a2,0x2
    80005f02:	4581                	li	a1,0
    80005f04:	0001d517          	auipc	a0,0x1d
    80005f08:	0fc50513          	addi	a0,a0,252 # 80023000 <disk>
    80005f0c:	ffffb097          	auipc	ra,0xffffb
    80005f10:	e52080e7          	jalr	-430(ra) # 80000d5e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005f14:	0001d717          	auipc	a4,0x1d
    80005f18:	0ec70713          	addi	a4,a4,236 # 80023000 <disk>
    80005f1c:	00c75793          	srli	a5,a4,0xc
    80005f20:	2781                	sext.w	a5,a5
    80005f22:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005f24:	0001f797          	auipc	a5,0x1f
    80005f28:	0dc78793          	addi	a5,a5,220 # 80025000 <disk+0x2000>
    80005f2c:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005f2e:	0001d717          	auipc	a4,0x1d
    80005f32:	15270713          	addi	a4,a4,338 # 80023080 <disk+0x80>
    80005f36:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005f38:	0001e717          	auipc	a4,0x1e
    80005f3c:	0c870713          	addi	a4,a4,200 # 80024000 <disk+0x1000>
    80005f40:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005f42:	4705                	li	a4,1
    80005f44:	00e78c23          	sb	a4,24(a5)
    80005f48:	00e78ca3          	sb	a4,25(a5)
    80005f4c:	00e78d23          	sb	a4,26(a5)
    80005f50:	00e78da3          	sb	a4,27(a5)
    80005f54:	00e78e23          	sb	a4,28(a5)
    80005f58:	00e78ea3          	sb	a4,29(a5)
    80005f5c:	00e78f23          	sb	a4,30(a5)
    80005f60:	00e78fa3          	sb	a4,31(a5)
}
    80005f64:	60e2                	ld	ra,24(sp)
    80005f66:	6442                	ld	s0,16(sp)
    80005f68:	64a2                	ld	s1,8(sp)
    80005f6a:	6105                	addi	sp,sp,32
    80005f6c:	8082                	ret
    panic("could not find virtio disk");
    80005f6e:	00003517          	auipc	a0,0x3
    80005f72:	82a50513          	addi	a0,a0,-2006 # 80008798 <syscalls+0x398>
    80005f76:	ffffa097          	auipc	ra,0xffffa
    80005f7a:	5fe080e7          	jalr	1534(ra) # 80000574 <panic>
    panic("virtio disk has no queue 0");
    80005f7e:	00003517          	auipc	a0,0x3
    80005f82:	83a50513          	addi	a0,a0,-1990 # 800087b8 <syscalls+0x3b8>
    80005f86:	ffffa097          	auipc	ra,0xffffa
    80005f8a:	5ee080e7          	jalr	1518(ra) # 80000574 <panic>
    panic("virtio disk max queue too short");
    80005f8e:	00003517          	auipc	a0,0x3
    80005f92:	84a50513          	addi	a0,a0,-1974 # 800087d8 <syscalls+0x3d8>
    80005f96:	ffffa097          	auipc	ra,0xffffa
    80005f9a:	5de080e7          	jalr	1502(ra) # 80000574 <panic>

0000000080005f9e <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005f9e:	7159                	addi	sp,sp,-112
    80005fa0:	f486                	sd	ra,104(sp)
    80005fa2:	f0a2                	sd	s0,96(sp)
    80005fa4:	eca6                	sd	s1,88(sp)
    80005fa6:	e8ca                	sd	s2,80(sp)
    80005fa8:	e4ce                	sd	s3,72(sp)
    80005faa:	e0d2                	sd	s4,64(sp)
    80005fac:	fc56                	sd	s5,56(sp)
    80005fae:	f85a                	sd	s6,48(sp)
    80005fb0:	f45e                	sd	s7,40(sp)
    80005fb2:	f062                	sd	s8,32(sp)
    80005fb4:	1880                	addi	s0,sp,112
    80005fb6:	892a                	mv	s2,a0
    80005fb8:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005fba:	00c52b83          	lw	s7,12(a0)
    80005fbe:	001b9b9b          	slliw	s7,s7,0x1
    80005fc2:	1b82                	slli	s7,s7,0x20
    80005fc4:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005fc8:	0001f517          	auipc	a0,0x1f
    80005fcc:	0e050513          	addi	a0,a0,224 # 800250a8 <disk+0x20a8>
    80005fd0:	ffffb097          	auipc	ra,0xffffb
    80005fd4:	c92080e7          	jalr	-878(ra) # 80000c62 <acquire>
    if(disk.free[i]){
    80005fd8:	0001f997          	auipc	s3,0x1f
    80005fdc:	02898993          	addi	s3,s3,40 # 80025000 <disk+0x2000>
  for(int i = 0; i < NUM; i++){
    80005fe0:	4b21                	li	s6,8
      disk.free[i] = 0;
    80005fe2:	0001da97          	auipc	s5,0x1d
    80005fe6:	01ea8a93          	addi	s5,s5,30 # 80023000 <disk>
  for(int i = 0; i < 3; i++){
    80005fea:	4a0d                	li	s4,3
    80005fec:	a079                	j	8000607a <virtio_disk_rw+0xdc>
      disk.free[i] = 0;
    80005fee:	00fa86b3          	add	a3,s5,a5
    80005ff2:	96ae                	add	a3,a3,a1
    80005ff4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005ff8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005ffa:	0207ca63          	bltz	a5,8000602e <virtio_disk_rw+0x90>
  for(int i = 0; i < 3; i++){
    80005ffe:	2485                	addiw	s1,s1,1
    80006000:	0711                	addi	a4,a4,4
    80006002:	25448163          	beq	s1,s4,80006244 <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80006006:	863a                	mv	a2,a4
    if(disk.free[i]){
    80006008:	0189c783          	lbu	a5,24(s3)
    8000600c:	24079163          	bnez	a5,8000624e <virtio_disk_rw+0x2b0>
    80006010:	0001f697          	auipc	a3,0x1f
    80006014:	00968693          	addi	a3,a3,9 # 80025019 <disk+0x2019>
  for(int i = 0; i < NUM; i++){
    80006018:	87aa                	mv	a5,a0
    if(disk.free[i]){
    8000601a:	0006c803          	lbu	a6,0(a3)
    8000601e:	fc0818e3          	bnez	a6,80005fee <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80006022:	2785                	addiw	a5,a5,1
    80006024:	0685                	addi	a3,a3,1
    80006026:	ff679ae3          	bne	a5,s6,8000601a <virtio_disk_rw+0x7c>
    idx[i] = alloc_desc();
    8000602a:	57fd                	li	a5,-1
    8000602c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000602e:	02905a63          	blez	s1,80006062 <virtio_disk_rw+0xc4>
        free_desc(idx[j]);
    80006032:	fa042503          	lw	a0,-96(s0)
    80006036:	00000097          	auipc	ra,0x0
    8000603a:	da0080e7          	jalr	-608(ra) # 80005dd6 <free_desc>
      for(int j = 0; j < i; j++)
    8000603e:	4785                	li	a5,1
    80006040:	0297d163          	ble	s1,a5,80006062 <virtio_disk_rw+0xc4>
        free_desc(idx[j]);
    80006044:	fa442503          	lw	a0,-92(s0)
    80006048:	00000097          	auipc	ra,0x0
    8000604c:	d8e080e7          	jalr	-626(ra) # 80005dd6 <free_desc>
      for(int j = 0; j < i; j++)
    80006050:	4789                	li	a5,2
    80006052:	0097d863          	ble	s1,a5,80006062 <virtio_disk_rw+0xc4>
        free_desc(idx[j]);
    80006056:	fa842503          	lw	a0,-88(s0)
    8000605a:	00000097          	auipc	ra,0x0
    8000605e:	d7c080e7          	jalr	-644(ra) # 80005dd6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006062:	0001f597          	auipc	a1,0x1f
    80006066:	04658593          	addi	a1,a1,70 # 800250a8 <disk+0x20a8>
    8000606a:	0001f517          	auipc	a0,0x1f
    8000606e:	fae50513          	addi	a0,a0,-82 # 80025018 <disk+0x2018>
    80006072:	ffffc097          	auipc	ra,0xffffc
    80006076:	214080e7          	jalr	532(ra) # 80002286 <sleep>
  for(int i = 0; i < 3; i++){
    8000607a:	fa040713          	addi	a4,s0,-96
    8000607e:	4481                	li	s1,0
  for(int i = 0; i < NUM; i++){
    80006080:	4505                	li	a0,1
      disk.free[i] = 0;
    80006082:	6589                	lui	a1,0x2
    80006084:	b749                	j	80006006 <virtio_disk_rw+0x68>
    uint32 reserved;
    uint64 sector;
  } buf0;

  if(write)
    buf0.type = VIRTIO_BLK_T_OUT; // write the disk
    80006086:	4785                	li	a5,1
    80006088:	f8f42823          	sw	a5,-112(s0)
  else
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
  buf0.reserved = 0;
    8000608c:	f8042a23          	sw	zero,-108(s0)
  buf0.sector = sector;
    80006090:	f9743c23          	sd	s7,-104(s0)

  // buf0 is on a kernel stack, which is not direct mapped,
  // thus the call to kvmpa().
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006094:	fa042983          	lw	s3,-96(s0)
    80006098:	00499493          	slli	s1,s3,0x4
    8000609c:	0001fa17          	auipc	s4,0x1f
    800060a0:	f64a0a13          	addi	s4,s4,-156 # 80025000 <disk+0x2000>
    800060a4:	000a3a83          	ld	s5,0(s4)
    800060a8:	9aa6                	add	s5,s5,s1
    800060aa:	f9040513          	addi	a0,s0,-112
    800060ae:	ffffb097          	auipc	ra,0xffffb
    800060b2:	0a8080e7          	jalr	168(ra) # 80001156 <kvmpa>
    800060b6:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    800060ba:	000a3783          	ld	a5,0(s4)
    800060be:	97a6                	add	a5,a5,s1
    800060c0:	4741                	li	a4,16
    800060c2:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800060c4:	000a3783          	ld	a5,0(s4)
    800060c8:	97a6                	add	a5,a5,s1
    800060ca:	4705                	li	a4,1
    800060cc:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800060d0:	fa442703          	lw	a4,-92(s0)
    800060d4:	000a3783          	ld	a5,0(s4)
    800060d8:	97a6                	add	a5,a5,s1
    800060da:	00e79723          	sh	a4,14(a5)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800060de:	0712                	slli	a4,a4,0x4
    800060e0:	000a3783          	ld	a5,0(s4)
    800060e4:	97ba                	add	a5,a5,a4
    800060e6:	05890693          	addi	a3,s2,88
    800060ea:	e394                	sd	a3,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    800060ec:	000a3783          	ld	a5,0(s4)
    800060f0:	97ba                	add	a5,a5,a4
    800060f2:	40000693          	li	a3,1024
    800060f6:	c794                	sw	a3,8(a5)
  if(write)
    800060f8:	100c0863          	beqz	s8,80006208 <virtio_disk_rw+0x26a>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800060fc:	000a3783          	ld	a5,0(s4)
    80006100:	97ba                	add	a5,a5,a4
    80006102:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006106:	0001d517          	auipc	a0,0x1d
    8000610a:	efa50513          	addi	a0,a0,-262 # 80023000 <disk>
    8000610e:	0001f797          	auipc	a5,0x1f
    80006112:	ef278793          	addi	a5,a5,-270 # 80025000 <disk+0x2000>
    80006116:	6394                	ld	a3,0(a5)
    80006118:	96ba                	add	a3,a3,a4
    8000611a:	00c6d603          	lhu	a2,12(a3)
    8000611e:	00166613          	ori	a2,a2,1
    80006122:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006126:	fa842683          	lw	a3,-88(s0)
    8000612a:	6390                	ld	a2,0(a5)
    8000612c:	9732                	add	a4,a4,a2
    8000612e:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0;
    80006132:	20098613          	addi	a2,s3,512
    80006136:	0612                	slli	a2,a2,0x4
    80006138:	962a                	add	a2,a2,a0
    8000613a:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000613e:	00469713          	slli	a4,a3,0x4
    80006142:	6394                	ld	a3,0(a5)
    80006144:	96ba                	add	a3,a3,a4
    80006146:	6589                	lui	a1,0x2
    80006148:	03058593          	addi	a1,a1,48 # 2030 <_entry-0x7fffdfd0>
    8000614c:	94ae                	add	s1,s1,a1
    8000614e:	94aa                	add	s1,s1,a0
    80006150:	e284                	sd	s1,0(a3)
  disk.desc[idx[2]].len = 1;
    80006152:	6394                	ld	a3,0(a5)
    80006154:	96ba                	add	a3,a3,a4
    80006156:	4585                	li	a1,1
    80006158:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000615a:	6394                	ld	a3,0(a5)
    8000615c:	96ba                	add	a3,a3,a4
    8000615e:	4509                	li	a0,2
    80006160:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80006164:	6394                	ld	a3,0(a5)
    80006166:	9736                	add	a4,a4,a3
    80006168:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000616c:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80006170:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80006174:	6794                	ld	a3,8(a5)
    80006176:	0026d703          	lhu	a4,2(a3)
    8000617a:	8b1d                	andi	a4,a4,7
    8000617c:	2709                	addiw	a4,a4,2
    8000617e:	0706                	slli	a4,a4,0x1
    80006180:	9736                	add	a4,a4,a3
    80006182:	01371023          	sh	s3,0(a4)
  __sync_synchronize();
    80006186:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    8000618a:	6798                	ld	a4,8(a5)
    8000618c:	00275783          	lhu	a5,2(a4)
    80006190:	2785                	addiw	a5,a5,1
    80006192:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006196:	100017b7          	lui	a5,0x10001
    8000619a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000619e:	00492703          	lw	a4,4(s2)
    800061a2:	4785                	li	a5,1
    800061a4:	02f71163          	bne	a4,a5,800061c6 <virtio_disk_rw+0x228>
    sleep(b, &disk.vdisk_lock);
    800061a8:	0001f997          	auipc	s3,0x1f
    800061ac:	f0098993          	addi	s3,s3,-256 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    800061b0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800061b2:	85ce                	mv	a1,s3
    800061b4:	854a                	mv	a0,s2
    800061b6:	ffffc097          	auipc	ra,0xffffc
    800061ba:	0d0080e7          	jalr	208(ra) # 80002286 <sleep>
  while(b->disk == 1) {
    800061be:	00492783          	lw	a5,4(s2)
    800061c2:	fe9788e3          	beq	a5,s1,800061b2 <virtio_disk_rw+0x214>
  }

  disk.info[idx[0]].b = 0;
    800061c6:	fa042483          	lw	s1,-96(s0)
    800061ca:	20048793          	addi	a5,s1,512 # 10001200 <_entry-0x6fffee00>
    800061ce:	00479713          	slli	a4,a5,0x4
    800061d2:	0001d797          	auipc	a5,0x1d
    800061d6:	e2e78793          	addi	a5,a5,-466 # 80023000 <disk>
    800061da:	97ba                	add	a5,a5,a4
    800061dc:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800061e0:	0001f917          	auipc	s2,0x1f
    800061e4:	e2090913          	addi	s2,s2,-480 # 80025000 <disk+0x2000>
    free_desc(i);
    800061e8:	8526                	mv	a0,s1
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	bec080e7          	jalr	-1044(ra) # 80005dd6 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800061f2:	0492                	slli	s1,s1,0x4
    800061f4:	00093783          	ld	a5,0(s2)
    800061f8:	94be                	add	s1,s1,a5
    800061fa:	00c4d783          	lhu	a5,12(s1)
    800061fe:	8b85                	andi	a5,a5,1
    80006200:	cf91                	beqz	a5,8000621c <virtio_disk_rw+0x27e>
      i = disk.desc[i].next;
    80006202:	00e4d483          	lhu	s1,14(s1)
  while(1){
    80006206:	b7cd                	j	800061e8 <virtio_disk_rw+0x24a>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006208:	0001f797          	auipc	a5,0x1f
    8000620c:	df878793          	addi	a5,a5,-520 # 80025000 <disk+0x2000>
    80006210:	639c                	ld	a5,0(a5)
    80006212:	97ba                	add	a5,a5,a4
    80006214:	4689                	li	a3,2
    80006216:	00d79623          	sh	a3,12(a5)
    8000621a:	b5f5                	j	80006106 <virtio_disk_rw+0x168>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000621c:	0001f517          	auipc	a0,0x1f
    80006220:	e8c50513          	addi	a0,a0,-372 # 800250a8 <disk+0x20a8>
    80006224:	ffffb097          	auipc	ra,0xffffb
    80006228:	af2080e7          	jalr	-1294(ra) # 80000d16 <release>
}
    8000622c:	70a6                	ld	ra,104(sp)
    8000622e:	7406                	ld	s0,96(sp)
    80006230:	64e6                	ld	s1,88(sp)
    80006232:	6946                	ld	s2,80(sp)
    80006234:	69a6                	ld	s3,72(sp)
    80006236:	6a06                	ld	s4,64(sp)
    80006238:	7ae2                	ld	s5,56(sp)
    8000623a:	7b42                	ld	s6,48(sp)
    8000623c:	7ba2                	ld	s7,40(sp)
    8000623e:	7c02                	ld	s8,32(sp)
    80006240:	6165                	addi	sp,sp,112
    80006242:	8082                	ret
  if(write)
    80006244:	e40c11e3          	bnez	s8,80006086 <virtio_disk_rw+0xe8>
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
    80006248:	f8042823          	sw	zero,-112(s0)
    8000624c:	b581                	j	8000608c <virtio_disk_rw+0xee>
      disk.free[i] = 0;
    8000624e:	00098c23          	sb	zero,24(s3)
    idx[i] = alloc_desc();
    80006252:	00072023          	sw	zero,0(a4)
    if(idx[i] < 0){
    80006256:	b365                	j	80005ffe <virtio_disk_rw+0x60>

0000000080006258 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006258:	1101                	addi	sp,sp,-32
    8000625a:	ec06                	sd	ra,24(sp)
    8000625c:	e822                	sd	s0,16(sp)
    8000625e:	e426                	sd	s1,8(sp)
    80006260:	e04a                	sd	s2,0(sp)
    80006262:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006264:	0001f517          	auipc	a0,0x1f
    80006268:	e4450513          	addi	a0,a0,-444 # 800250a8 <disk+0x20a8>
    8000626c:	ffffb097          	auipc	ra,0xffffb
    80006270:	9f6080e7          	jalr	-1546(ra) # 80000c62 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006274:	0001f797          	auipc	a5,0x1f
    80006278:	d8c78793          	addi	a5,a5,-628 # 80025000 <disk+0x2000>
    8000627c:	0207d683          	lhu	a3,32(a5)
    80006280:	6b98                	ld	a4,16(a5)
    80006282:	00275783          	lhu	a5,2(a4)
    80006286:	8fb5                	xor	a5,a5,a3
    80006288:	8b9d                	andi	a5,a5,7
    8000628a:	c7c9                	beqz	a5,80006314 <virtio_disk_intr+0xbc>
    int id = disk.used->elems[disk.used_idx].id;
    8000628c:	068e                	slli	a3,a3,0x3
    8000628e:	9736                	add	a4,a4,a3
    80006290:	435c                	lw	a5,4(a4)

    if(disk.info[id].status != 0)
    80006292:	20078713          	addi	a4,a5,512
    80006296:	00471693          	slli	a3,a4,0x4
    8000629a:	0001d717          	auipc	a4,0x1d
    8000629e:	d6670713          	addi	a4,a4,-666 # 80023000 <disk>
    800062a2:	9736                	add	a4,a4,a3
    800062a4:	03074703          	lbu	a4,48(a4)
    800062a8:	ef31                	bnez	a4,80006304 <virtio_disk_intr+0xac>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    800062aa:	0001d917          	auipc	s2,0x1d
    800062ae:	d5690913          	addi	s2,s2,-682 # 80023000 <disk>
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    800062b2:	0001f497          	auipc	s1,0x1f
    800062b6:	d4e48493          	addi	s1,s1,-690 # 80025000 <disk+0x2000>
    disk.info[id].b->disk = 0;   // disk is done with buf
    800062ba:	20078793          	addi	a5,a5,512
    800062be:	0792                	slli	a5,a5,0x4
    800062c0:	97ca                	add	a5,a5,s2
    800062c2:	7798                	ld	a4,40(a5)
    800062c4:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    800062c8:	7788                	ld	a0,40(a5)
    800062ca:	ffffc097          	auipc	ra,0xffffc
    800062ce:	142080e7          	jalr	322(ra) # 8000240c <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    800062d2:	0204d783          	lhu	a5,32(s1)
    800062d6:	2785                	addiw	a5,a5,1
    800062d8:	8b9d                	andi	a5,a5,7
    800062da:	03079613          	slli	a2,a5,0x30
    800062de:	9241                	srli	a2,a2,0x30
    800062e0:	02c49023          	sh	a2,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800062e4:	6898                	ld	a4,16(s1)
    800062e6:	00275683          	lhu	a3,2(a4)
    800062ea:	8a9d                	andi	a3,a3,7
    800062ec:	02c68463          	beq	a3,a2,80006314 <virtio_disk_intr+0xbc>
    int id = disk.used->elems[disk.used_idx].id;
    800062f0:	078e                	slli	a5,a5,0x3
    800062f2:	97ba                	add	a5,a5,a4
    800062f4:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    800062f6:	20078713          	addi	a4,a5,512
    800062fa:	0712                	slli	a4,a4,0x4
    800062fc:	974a                	add	a4,a4,s2
    800062fe:	03074703          	lbu	a4,48(a4)
    80006302:	df45                	beqz	a4,800062ba <virtio_disk_intr+0x62>
      panic("virtio_disk_intr status");
    80006304:	00002517          	auipc	a0,0x2
    80006308:	4f450513          	addi	a0,a0,1268 # 800087f8 <syscalls+0x3f8>
    8000630c:	ffffa097          	auipc	ra,0xffffa
    80006310:	268080e7          	jalr	616(ra) # 80000574 <panic>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006314:	10001737          	lui	a4,0x10001
    80006318:	533c                	lw	a5,96(a4)
    8000631a:	8b8d                	andi	a5,a5,3
    8000631c:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    8000631e:	0001f517          	auipc	a0,0x1f
    80006322:	d8a50513          	addi	a0,a0,-630 # 800250a8 <disk+0x20a8>
    80006326:	ffffb097          	auipc	ra,0xffffb
    8000632a:	9f0080e7          	jalr	-1552(ra) # 80000d16 <release>
}
    8000632e:	60e2                	ld	ra,24(sp)
    80006330:	6442                	ld	s0,16(sp)
    80006332:	64a2                	ld	s1,8(sp)
    80006334:	6902                	ld	s2,0(sp)
    80006336:	6105                	addi	sp,sp,32
    80006338:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
