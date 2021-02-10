
user/_mkdir：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	ble	a0,a5,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	346080e7          	jalr	838(ra) # 370 <mkdir>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: mkdir files...\n");
  3e:	00000597          	auipc	a1,0x0
  42:	7ea58593          	addi	a1,a1,2026 # 828 <malloc+0xe8>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	60a080e7          	jalr	1546(ra) # 652 <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	2b6080e7          	jalr	694(ra) # 308 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00000597          	auipc	a1,0x0
  60:	7e458593          	addi	a1,a1,2020 # 840 <malloc+0x100>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	5ec080e7          	jalr	1516(ra) # 652 <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	298080e7          	jalr	664(ra) # 308 <exit>

0000000000000078 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
    ;
  return os;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cf91                	beqz	a5,ba <strcmp+0x26>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71b63          	bne	a4,a5,ba <strcmp+0x26>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	c789                	beqz	a5,ba <strcmp+0x26>
  b2:	0005c703          	lbu	a4,0(a1)
  b6:	fef709e3          	beq	a4,a5,a8 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  ba:	0005c503          	lbu	a0,0(a1)
}
  be:	40a7853b          	subw	a0,a5,a0
  c2:	6422                	ld	s0,8(sp)
  c4:	0141                	addi	sp,sp,16
  c6:	8082                	ret

00000000000000c8 <strlen>:

uint
strlen(const char *s)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e422                	sd	s0,8(sp)
  cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf91                	beqz	a5,ee <strlen+0x26>
  d4:	0505                	addi	a0,a0,1
  d6:	87aa                	mv	a5,a0
  d8:	4685                	li	a3,1
  da:	9e89                	subw	a3,a3,a0
  dc:	00f6853b          	addw	a0,a3,a5
  e0:	0785                	addi	a5,a5,1
  e2:	fff7c703          	lbu	a4,-1(a5)
  e6:	fb7d                	bnez	a4,dc <strlen+0x14>
    ;
  return n;
}
  e8:	6422                	ld	s0,8(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret
  for(n = 0; s[n]; n++)
  ee:	4501                	li	a0,0
  f0:	bfe5                	j	e8 <strlen+0x20>

00000000000000f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f8:	ce09                	beqz	a2,112 <memset+0x20>
  fa:	87aa                	mv	a5,a0
  fc:	fff6071b          	addiw	a4,a2,-1
 100:	1702                	slli	a4,a4,0x20
 102:	9301                	srli	a4,a4,0x20
 104:	0705                	addi	a4,a4,1
 106:	972a                	add	a4,a4,a0
    cdst[i] = c;
 108:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x16>
  }
  return dst;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:

char*
strchr(const char *s, char c)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cf91                	beqz	a5,13e <strchr+0x26>
    if(*s == c)
 124:	00f58a63          	beq	a1,a5,138 <strchr+0x20>
  for(; *s; s++)
 128:	0505                	addi	a0,a0,1
 12a:	00054783          	lbu	a5,0(a0)
 12e:	c781                	beqz	a5,136 <strchr+0x1e>
    if(*s == c)
 130:	feb79ce3          	bne	a5,a1,128 <strchr+0x10>
 134:	a011                	j	138 <strchr+0x20>
      return (char*)s;
  return 0;
 136:	4501                	li	a0,0
}
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
  return 0;
 13e:	4501                	li	a0,0
 140:	bfe5                	j	138 <strchr+0x20>

0000000000000142 <gets>:

char*
gets(char *buf, int max)
{
 142:	711d                	addi	sp,sp,-96
 144:	ec86                	sd	ra,88(sp)
 146:	e8a2                	sd	s0,80(sp)
 148:	e4a6                	sd	s1,72(sp)
 14a:	e0ca                	sd	s2,64(sp)
 14c:	fc4e                	sd	s3,56(sp)
 14e:	f852                	sd	s4,48(sp)
 150:	f456                	sd	s5,40(sp)
 152:	f05a                	sd	s6,32(sp)
 154:	ec5e                	sd	s7,24(sp)
 156:	1080                	addi	s0,sp,96
 158:	8baa                	mv	s7,a0
 15a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15c:	892a                	mv	s2,a0
 15e:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 160:	4aa9                	li	s5,10
 162:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 164:	0019849b          	addiw	s1,s3,1
 168:	0344d863          	ble	s4,s1,198 <gets+0x56>
    cc = read(0, &c, 1);
 16c:	4605                	li	a2,1
 16e:	faf40593          	addi	a1,s0,-81
 172:	4501                	li	a0,0
 174:	00000097          	auipc	ra,0x0
 178:	1ac080e7          	jalr	428(ra) # 320 <read>
    if(cc < 1)
 17c:	00a05e63          	blez	a0,198 <gets+0x56>
    buf[i++] = c;
 180:	faf44783          	lbu	a5,-81(s0)
 184:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 188:	01578763          	beq	a5,s5,196 <gets+0x54>
 18c:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 18e:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 190:	fd679ae3          	bne	a5,s6,164 <gets+0x22>
 194:	a011                	j	198 <gets+0x56>
  for(i=0; i+1 < max; ){
 196:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 198:	99de                	add	s3,s3,s7
 19a:	00098023          	sb	zero,0(s3)
  return buf;
}
 19e:	855e                	mv	a0,s7
 1a0:	60e6                	ld	ra,88(sp)
 1a2:	6446                	ld	s0,80(sp)
 1a4:	64a6                	ld	s1,72(sp)
 1a6:	6906                	ld	s2,64(sp)
 1a8:	79e2                	ld	s3,56(sp)
 1aa:	7a42                	ld	s4,48(sp)
 1ac:	7aa2                	ld	s5,40(sp)
 1ae:	7b02                	ld	s6,32(sp)
 1b0:	6be2                	ld	s7,24(sp)
 1b2:	6125                	addi	sp,sp,96
 1b4:	8082                	ret

00000000000001b6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b6:	1101                	addi	sp,sp,-32
 1b8:	ec06                	sd	ra,24(sp)
 1ba:	e822                	sd	s0,16(sp)
 1bc:	e426                	sd	s1,8(sp)
 1be:	e04a                	sd	s2,0(sp)
 1c0:	1000                	addi	s0,sp,32
 1c2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c4:	4581                	li	a1,0
 1c6:	00000097          	auipc	ra,0x0
 1ca:	182080e7          	jalr	386(ra) # 348 <open>
  if(fd < 0)
 1ce:	02054563          	bltz	a0,1f8 <stat+0x42>
 1d2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d4:	85ca                	mv	a1,s2
 1d6:	00000097          	auipc	ra,0x0
 1da:	18a080e7          	jalr	394(ra) # 360 <fstat>
 1de:	892a                	mv	s2,a0
  close(fd);
 1e0:	8526                	mv	a0,s1
 1e2:	00000097          	auipc	ra,0x0
 1e6:	14e080e7          	jalr	334(ra) # 330 <close>
  return r;
}
 1ea:	854a                	mv	a0,s2
 1ec:	60e2                	ld	ra,24(sp)
 1ee:	6442                	ld	s0,16(sp)
 1f0:	64a2                	ld	s1,8(sp)
 1f2:	6902                	ld	s2,0(sp)
 1f4:	6105                	addi	sp,sp,32
 1f6:	8082                	ret
    return -1;
 1f8:	597d                	li	s2,-1
 1fa:	bfc5                	j	1ea <stat+0x34>

00000000000001fc <atoi>:

int
atoi(const char *s)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 202:	00054683          	lbu	a3,0(a0)
 206:	fd06879b          	addiw	a5,a3,-48
 20a:	0ff7f793          	andi	a5,a5,255
 20e:	4725                	li	a4,9
 210:	02f76963          	bltu	a4,a5,242 <atoi+0x46>
 214:	862a                	mv	a2,a0
  n = 0;
 216:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 218:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 21a:	0605                	addi	a2,a2,1
 21c:	0025179b          	slliw	a5,a0,0x2
 220:	9fa9                	addw	a5,a5,a0
 222:	0017979b          	slliw	a5,a5,0x1
 226:	9fb5                	addw	a5,a5,a3
 228:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22c:	00064683          	lbu	a3,0(a2)
 230:	fd06871b          	addiw	a4,a3,-48
 234:	0ff77713          	andi	a4,a4,255
 238:	fee5f1e3          	bleu	a4,a1,21a <atoi+0x1e>
  return n;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  n = 0;
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <atoi+0x40>

0000000000000246 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57663          	bleu	a1,a0,278 <memmove+0x32>
    while(n-- > 0)
 250:	02c05163          	blez	a2,272 <memmove+0x2c>
 254:	fff6079b          	addiw	a5,a2,-1
 258:	1782                	slli	a5,a5,0x20
 25a:	9381                	srli	a5,a5,0x20
 25c:	0785                	addi	a5,a5,1
 25e:	97aa                	add	a5,a5,a0
  dst = vdst;
 260:	872a                	mv	a4,a0
      *dst++ = *src++;
 262:	0585                	addi	a1,a1,1
 264:	0705                	addi	a4,a4,1
 266:	fff5c683          	lbu	a3,-1(a1)
 26a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26e:	fee79ae3          	bne	a5,a4,262 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret
    dst += n;
 278:	00c50733          	add	a4,a0,a2
    src += n;
 27c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27e:	fec05ae3          	blez	a2,272 <memmove+0x2c>
 282:	fff6079b          	addiw	a5,a2,-1
 286:	1782                	slli	a5,a5,0x20
 288:	9381                	srli	a5,a5,0x20
 28a:	fff7c793          	not	a5,a5
 28e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 290:	15fd                	addi	a1,a1,-1
 292:	177d                	addi	a4,a4,-1
 294:	0005c683          	lbu	a3,0(a1)
 298:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 29c:	fef71ae3          	bne	a4,a5,290 <memmove+0x4a>
 2a0:	bfc9                	j	272 <memmove+0x2c>

00000000000002a2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a8:	ce15                	beqz	a2,2e4 <memcmp+0x42>
 2aa:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	0005c703          	lbu	a4,0(a1)
 2b6:	02e79063          	bne	a5,a4,2d6 <memcmp+0x34>
 2ba:	1682                	slli	a3,a3,0x20
 2bc:	9281                	srli	a3,a3,0x20
 2be:	0685                	addi	a3,a3,1
 2c0:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 2c2:	0505                	addi	a0,a0,1
    p2++;
 2c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c6:	00d50d63          	beq	a0,a3,2e0 <memcmp+0x3e>
    if (*p1 != *p2) {
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	0005c703          	lbu	a4,0(a1)
 2d2:	fee788e3          	beq	a5,a4,2c2 <memcmp+0x20>
      return *p1 - *p2;
 2d6:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  return 0;
 2e0:	4501                	li	a0,0
 2e2:	bfe5                	j	2da <memcmp+0x38>
 2e4:	4501                	li	a0,0
 2e6:	bfd5                	j	2da <memcmp+0x38>

00000000000002e8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f0:	00000097          	auipc	ra,0x0
 2f4:	f56080e7          	jalr	-170(ra) # 246 <memmove>
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 300:	4885                	li	a7,1
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <exit>:
.global exit
exit:
 li a7, SYS_exit
 308:	4889                	li	a7,2
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <wait>:
.global wait
wait:
 li a7, SYS_wait
 310:	488d                	li	a7,3
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 318:	4891                	li	a7,4
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <read>:
.global read
read:
 li a7, SYS_read
 320:	4895                	li	a7,5
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <write>:
.global write
write:
 li a7, SYS_write
 328:	48c1                	li	a7,16
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <close>:
.global close
close:
 li a7, SYS_close
 330:	48d5                	li	a7,21
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <kill>:
.global kill
kill:
 li a7, SYS_kill
 338:	4899                	li	a7,6
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <exec>:
.global exec
exec:
 li a7, SYS_exec
 340:	489d                	li	a7,7
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <open>:
.global open
open:
 li a7, SYS_open
 348:	48bd                	li	a7,15
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 350:	48c5                	li	a7,17
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 358:	48c9                	li	a7,18
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 360:	48a1                	li	a7,8
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <link>:
.global link
link:
 li a7, SYS_link
 368:	48cd                	li	a7,19
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 370:	48d1                	li	a7,20
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 378:	48a5                	li	a7,9
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <dup>:
.global dup
dup:
 li a7, SYS_dup
 380:	48a9                	li	a7,10
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 388:	48ad                	li	a7,11
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 390:	48b1                	li	a7,12
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 398:	48b5                	li	a7,13
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a0:	48b9                	li	a7,14
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a8:	1101                	addi	sp,sp,-32
 3aa:	ec06                	sd	ra,24(sp)
 3ac:	e822                	sd	s0,16(sp)
 3ae:	1000                	addi	s0,sp,32
 3b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b4:	4605                	li	a2,1
 3b6:	fef40593          	addi	a1,s0,-17
 3ba:	00000097          	auipc	ra,0x0
 3be:	f6e080e7          	jalr	-146(ra) # 328 <write>
}
 3c2:	60e2                	ld	ra,24(sp)
 3c4:	6442                	ld	s0,16(sp)
 3c6:	6105                	addi	sp,sp,32
 3c8:	8082                	ret

00000000000003ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ca:	7139                	addi	sp,sp,-64
 3cc:	fc06                	sd	ra,56(sp)
 3ce:	f822                	sd	s0,48(sp)
 3d0:	f426                	sd	s1,40(sp)
 3d2:	f04a                	sd	s2,32(sp)
 3d4:	ec4e                	sd	s3,24(sp)
 3d6:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3d8:	c299                	beqz	a3,3de <printint+0x14>
 3da:	0005cd63          	bltz	a1,3f4 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3de:	2581                	sext.w	a1,a1
  neg = 0;
 3e0:	4301                	li	t1,0
 3e2:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 3e6:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 3e8:	2601                	sext.w	a2,a2
 3ea:	00000897          	auipc	a7,0x0
 3ee:	47688893          	addi	a7,a7,1142 # 860 <digits>
 3f2:	a801                	j	402 <printint+0x38>
    x = -xx;
 3f4:	40b005bb          	negw	a1,a1
 3f8:	2581                	sext.w	a1,a1
    neg = 1;
 3fa:	4305                	li	t1,1
    x = -xx;
 3fc:	b7dd                	j	3e2 <printint+0x18>
  }while((x /= base) != 0);
 3fe:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 400:	8836                	mv	a6,a3
 402:	0018069b          	addiw	a3,a6,1
 406:	02c5f7bb          	remuw	a5,a1,a2
 40a:	1782                	slli	a5,a5,0x20
 40c:	9381                	srli	a5,a5,0x20
 40e:	97c6                	add	a5,a5,a7
 410:	0007c783          	lbu	a5,0(a5)
 414:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 418:	0705                	addi	a4,a4,1
 41a:	02c5d7bb          	divuw	a5,a1,a2
 41e:	fec5f0e3          	bleu	a2,a1,3fe <printint+0x34>
  if(neg)
 422:	00030b63          	beqz	t1,438 <printint+0x6e>
    buf[i++] = '-';
 426:	fd040793          	addi	a5,s0,-48
 42a:	96be                	add	a3,a3,a5
 42c:	02d00793          	li	a5,45
 430:	fef68823          	sb	a5,-16(a3)
 434:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 438:	02d05963          	blez	a3,46a <printint+0xa0>
 43c:	89aa                	mv	s3,a0
 43e:	fc040793          	addi	a5,s0,-64
 442:	00d784b3          	add	s1,a5,a3
 446:	fff78913          	addi	s2,a5,-1
 44a:	9936                	add	s2,s2,a3
 44c:	36fd                	addiw	a3,a3,-1
 44e:	1682                	slli	a3,a3,0x20
 450:	9281                	srli	a3,a3,0x20
 452:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 456:	fff4c583          	lbu	a1,-1(s1)
 45a:	854e                	mv	a0,s3
 45c:	00000097          	auipc	ra,0x0
 460:	f4c080e7          	jalr	-180(ra) # 3a8 <putc>
  while(--i >= 0)
 464:	14fd                	addi	s1,s1,-1
 466:	ff2498e3          	bne	s1,s2,456 <printint+0x8c>
}
 46a:	70e2                	ld	ra,56(sp)
 46c:	7442                	ld	s0,48(sp)
 46e:	74a2                	ld	s1,40(sp)
 470:	7902                	ld	s2,32(sp)
 472:	69e2                	ld	s3,24(sp)
 474:	6121                	addi	sp,sp,64
 476:	8082                	ret

0000000000000478 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 478:	7119                	addi	sp,sp,-128
 47a:	fc86                	sd	ra,120(sp)
 47c:	f8a2                	sd	s0,112(sp)
 47e:	f4a6                	sd	s1,104(sp)
 480:	f0ca                	sd	s2,96(sp)
 482:	ecce                	sd	s3,88(sp)
 484:	e8d2                	sd	s4,80(sp)
 486:	e4d6                	sd	s5,72(sp)
 488:	e0da                	sd	s6,64(sp)
 48a:	fc5e                	sd	s7,56(sp)
 48c:	f862                	sd	s8,48(sp)
 48e:	f466                	sd	s9,40(sp)
 490:	f06a                	sd	s10,32(sp)
 492:	ec6e                	sd	s11,24(sp)
 494:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 496:	0005c483          	lbu	s1,0(a1)
 49a:	18048d63          	beqz	s1,634 <vprintf+0x1bc>
 49e:	8aaa                	mv	s5,a0
 4a0:	8b32                	mv	s6,a2
 4a2:	00158913          	addi	s2,a1,1
  state = 0;
 4a6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4a8:	02500a13          	li	s4,37
      if(c == 'd'){
 4ac:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4b0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4b4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4b8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4bc:	00000b97          	auipc	s7,0x0
 4c0:	3a4b8b93          	addi	s7,s7,932 # 860 <digits>
 4c4:	a839                	j	4e2 <vprintf+0x6a>
        putc(fd, c);
 4c6:	85a6                	mv	a1,s1
 4c8:	8556                	mv	a0,s5
 4ca:	00000097          	auipc	ra,0x0
 4ce:	ede080e7          	jalr	-290(ra) # 3a8 <putc>
 4d2:	a019                	j	4d8 <vprintf+0x60>
    } else if(state == '%'){
 4d4:	01498f63          	beq	s3,s4,4f2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4d8:	0905                	addi	s2,s2,1
 4da:	fff94483          	lbu	s1,-1(s2)
 4de:	14048b63          	beqz	s1,634 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 4e2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4e6:	fe0997e3          	bnez	s3,4d4 <vprintf+0x5c>
      if(c == '%'){
 4ea:	fd479ee3          	bne	a5,s4,4c6 <vprintf+0x4e>
        state = '%';
 4ee:	89be                	mv	s3,a5
 4f0:	b7e5                	j	4d8 <vprintf+0x60>
      if(c == 'd'){
 4f2:	05878063          	beq	a5,s8,532 <vprintf+0xba>
      } else if(c == 'l') {
 4f6:	05978c63          	beq	a5,s9,54e <vprintf+0xd6>
      } else if(c == 'x') {
 4fa:	07a78863          	beq	a5,s10,56a <vprintf+0xf2>
      } else if(c == 'p') {
 4fe:	09b78463          	beq	a5,s11,586 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 502:	07300713          	li	a4,115
 506:	0ce78563          	beq	a5,a4,5d0 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 50a:	06300713          	li	a4,99
 50e:	0ee78c63          	beq	a5,a4,606 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 512:	11478663          	beq	a5,s4,61e <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 516:	85d2                	mv	a1,s4
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	e8e080e7          	jalr	-370(ra) # 3a8 <putc>
        putc(fd, c);
 522:	85a6                	mv	a1,s1
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	e82080e7          	jalr	-382(ra) # 3a8 <putc>
      }
      state = 0;
 52e:	4981                	li	s3,0
 530:	b765                	j	4d8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 532:	008b0493          	addi	s1,s6,8
 536:	4685                	li	a3,1
 538:	4629                	li	a2,10
 53a:	000b2583          	lw	a1,0(s6)
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	e8a080e7          	jalr	-374(ra) # 3ca <printint>
 548:	8b26                	mv	s6,s1
      state = 0;
 54a:	4981                	li	s3,0
 54c:	b771                	j	4d8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 54e:	008b0493          	addi	s1,s6,8
 552:	4681                	li	a3,0
 554:	4629                	li	a2,10
 556:	000b2583          	lw	a1,0(s6)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	e6e080e7          	jalr	-402(ra) # 3ca <printint>
 564:	8b26                	mv	s6,s1
      state = 0;
 566:	4981                	li	s3,0
 568:	bf85                	j	4d8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 56a:	008b0493          	addi	s1,s6,8
 56e:	4681                	li	a3,0
 570:	4641                	li	a2,16
 572:	000b2583          	lw	a1,0(s6)
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	e52080e7          	jalr	-430(ra) # 3ca <printint>
 580:	8b26                	mv	s6,s1
      state = 0;
 582:	4981                	li	s3,0
 584:	bf91                	j	4d8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 586:	008b0793          	addi	a5,s6,8
 58a:	f8f43423          	sd	a5,-120(s0)
 58e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 592:	03000593          	li	a1,48
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e10080e7          	jalr	-496(ra) # 3a8 <putc>
  putc(fd, 'x');
 5a0:	85ea                	mv	a1,s10
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e04080e7          	jalr	-508(ra) # 3a8 <putc>
 5ac:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ae:	03c9d793          	srli	a5,s3,0x3c
 5b2:	97de                	add	a5,a5,s7
 5b4:	0007c583          	lbu	a1,0(a5)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	dee080e7          	jalr	-530(ra) # 3a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5c2:	0992                	slli	s3,s3,0x4
 5c4:	34fd                	addiw	s1,s1,-1
 5c6:	f4e5                	bnez	s1,5ae <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5c8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b729                	j	4d8 <vprintf+0x60>
        s = va_arg(ap, char*);
 5d0:	008b0993          	addi	s3,s6,8
 5d4:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 5d8:	c085                	beqz	s1,5f8 <vprintf+0x180>
        while(*s != 0){
 5da:	0004c583          	lbu	a1,0(s1)
 5de:	c9a1                	beqz	a1,62e <vprintf+0x1b6>
          putc(fd, *s);
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	dc6080e7          	jalr	-570(ra) # 3a8 <putc>
          s++;
 5ea:	0485                	addi	s1,s1,1
        while(*s != 0){
 5ec:	0004c583          	lbu	a1,0(s1)
 5f0:	f9e5                	bnez	a1,5e0 <vprintf+0x168>
        s = va_arg(ap, char*);
 5f2:	8b4e                	mv	s6,s3
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b5cd                	j	4d8 <vprintf+0x60>
          s = "(null)";
 5f8:	00000497          	auipc	s1,0x0
 5fc:	28048493          	addi	s1,s1,640 # 878 <digits+0x18>
        while(*s != 0){
 600:	02800593          	li	a1,40
 604:	bff1                	j	5e0 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 606:	008b0493          	addi	s1,s6,8
 60a:	000b4583          	lbu	a1,0(s6)
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	d98080e7          	jalr	-616(ra) # 3a8 <putc>
 618:	8b26                	mv	s6,s1
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bd75                	j	4d8 <vprintf+0x60>
        putc(fd, c);
 61e:	85d2                	mv	a1,s4
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	d86080e7          	jalr	-634(ra) # 3a8 <putc>
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b575                	j	4d8 <vprintf+0x60>
        s = va_arg(ap, char*);
 62e:	8b4e                	mv	s6,s3
      state = 0;
 630:	4981                	li	s3,0
 632:	b55d                	j	4d8 <vprintf+0x60>
    }
  }
}
 634:	70e6                	ld	ra,120(sp)
 636:	7446                	ld	s0,112(sp)
 638:	74a6                	ld	s1,104(sp)
 63a:	7906                	ld	s2,96(sp)
 63c:	69e6                	ld	s3,88(sp)
 63e:	6a46                	ld	s4,80(sp)
 640:	6aa6                	ld	s5,72(sp)
 642:	6b06                	ld	s6,64(sp)
 644:	7be2                	ld	s7,56(sp)
 646:	7c42                	ld	s8,48(sp)
 648:	7ca2                	ld	s9,40(sp)
 64a:	7d02                	ld	s10,32(sp)
 64c:	6de2                	ld	s11,24(sp)
 64e:	6109                	addi	sp,sp,128
 650:	8082                	ret

0000000000000652 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 652:	715d                	addi	sp,sp,-80
 654:	ec06                	sd	ra,24(sp)
 656:	e822                	sd	s0,16(sp)
 658:	1000                	addi	s0,sp,32
 65a:	e010                	sd	a2,0(s0)
 65c:	e414                	sd	a3,8(s0)
 65e:	e818                	sd	a4,16(s0)
 660:	ec1c                	sd	a5,24(s0)
 662:	03043023          	sd	a6,32(s0)
 666:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 66a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 66e:	8622                	mv	a2,s0
 670:	00000097          	auipc	ra,0x0
 674:	e08080e7          	jalr	-504(ra) # 478 <vprintf>
}
 678:	60e2                	ld	ra,24(sp)
 67a:	6442                	ld	s0,16(sp)
 67c:	6161                	addi	sp,sp,80
 67e:	8082                	ret

0000000000000680 <printf>:

void
printf(const char *fmt, ...)
{
 680:	711d                	addi	sp,sp,-96
 682:	ec06                	sd	ra,24(sp)
 684:	e822                	sd	s0,16(sp)
 686:	1000                	addi	s0,sp,32
 688:	e40c                	sd	a1,8(s0)
 68a:	e810                	sd	a2,16(s0)
 68c:	ec14                	sd	a3,24(s0)
 68e:	f018                	sd	a4,32(s0)
 690:	f41c                	sd	a5,40(s0)
 692:	03043823          	sd	a6,48(s0)
 696:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 69a:	00840613          	addi	a2,s0,8
 69e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6a2:	85aa                	mv	a1,a0
 6a4:	4505                	li	a0,1
 6a6:	00000097          	auipc	ra,0x0
 6aa:	dd2080e7          	jalr	-558(ra) # 478 <vprintf>
}
 6ae:	60e2                	ld	ra,24(sp)
 6b0:	6442                	ld	s0,16(sp)
 6b2:	6125                	addi	sp,sp,96
 6b4:	8082                	ret

00000000000006b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b6:	1141                	addi	sp,sp,-16
 6b8:	e422                	sd	s0,8(sp)
 6ba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6bc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c0:	00000797          	auipc	a5,0x0
 6c4:	1c078793          	addi	a5,a5,448 # 880 <__bss_start>
 6c8:	639c                	ld	a5,0(a5)
 6ca:	a805                	j	6fa <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6cc:	4618                	lw	a4,8(a2)
 6ce:	9db9                	addw	a1,a1,a4
 6d0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d4:	6398                	ld	a4,0(a5)
 6d6:	6318                	ld	a4,0(a4)
 6d8:	fee53823          	sd	a4,-16(a0)
 6dc:	a091                	j	720 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6de:	ff852703          	lw	a4,-8(a0)
 6e2:	9e39                	addw	a2,a2,a4
 6e4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6e6:	ff053703          	ld	a4,-16(a0)
 6ea:	e398                	sd	a4,0(a5)
 6ec:	a099                	j	732 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ee:	6398                	ld	a4,0(a5)
 6f0:	00e7e463          	bltu	a5,a4,6f8 <free+0x42>
 6f4:	00e6ea63          	bltu	a3,a4,708 <free+0x52>
{
 6f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	fed7fae3          	bleu	a3,a5,6ee <free+0x38>
 6fe:	6398                	ld	a4,0(a5)
 700:	00e6e463          	bltu	a3,a4,708 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 704:	fee7eae3          	bltu	a5,a4,6f8 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 708:	ff852583          	lw	a1,-8(a0)
 70c:	6390                	ld	a2,0(a5)
 70e:	02059713          	slli	a4,a1,0x20
 712:	9301                	srli	a4,a4,0x20
 714:	0712                	slli	a4,a4,0x4
 716:	9736                	add	a4,a4,a3
 718:	fae60ae3          	beq	a2,a4,6cc <free+0x16>
    bp->s.ptr = p->s.ptr;
 71c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 720:	4790                	lw	a2,8(a5)
 722:	02061713          	slli	a4,a2,0x20
 726:	9301                	srli	a4,a4,0x20
 728:	0712                	slli	a4,a4,0x4
 72a:	973e                	add	a4,a4,a5
 72c:	fae689e3          	beq	a3,a4,6de <free+0x28>
  } else
    p->s.ptr = bp;
 730:	e394                	sd	a3,0(a5)
  freep = p;
 732:	00000717          	auipc	a4,0x0
 736:	14f73723          	sd	a5,334(a4) # 880 <__bss_start>
}
 73a:	6422                	ld	s0,8(sp)
 73c:	0141                	addi	sp,sp,16
 73e:	8082                	ret

0000000000000740 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 740:	7139                	addi	sp,sp,-64
 742:	fc06                	sd	ra,56(sp)
 744:	f822                	sd	s0,48(sp)
 746:	f426                	sd	s1,40(sp)
 748:	f04a                	sd	s2,32(sp)
 74a:	ec4e                	sd	s3,24(sp)
 74c:	e852                	sd	s4,16(sp)
 74e:	e456                	sd	s5,8(sp)
 750:	e05a                	sd	s6,0(sp)
 752:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 754:	02051993          	slli	s3,a0,0x20
 758:	0209d993          	srli	s3,s3,0x20
 75c:	09bd                	addi	s3,s3,15
 75e:	0049d993          	srli	s3,s3,0x4
 762:	2985                	addiw	s3,s3,1
 764:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 768:	00000797          	auipc	a5,0x0
 76c:	11878793          	addi	a5,a5,280 # 880 <__bss_start>
 770:	6388                	ld	a0,0(a5)
 772:	c515                	beqz	a0,79e <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 774:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 776:	4798                	lw	a4,8(a5)
 778:	03277f63          	bleu	s2,a4,7b6 <malloc+0x76>
 77c:	8a4e                	mv	s4,s3
 77e:	0009871b          	sext.w	a4,s3
 782:	6685                	lui	a3,0x1
 784:	00d77363          	bleu	a3,a4,78a <malloc+0x4a>
 788:	6a05                	lui	s4,0x1
 78a:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 78e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 792:	00000497          	auipc	s1,0x0
 796:	0ee48493          	addi	s1,s1,238 # 880 <__bss_start>
  if(p == (char*)-1)
 79a:	5b7d                	li	s6,-1
 79c:	a885                	j	80c <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 79e:	00000797          	auipc	a5,0x0
 7a2:	0ea78793          	addi	a5,a5,234 # 888 <base>
 7a6:	00000717          	auipc	a4,0x0
 7aa:	0cf73d23          	sd	a5,218(a4) # 880 <__bss_start>
 7ae:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7b0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7b4:	b7e1                	j	77c <malloc+0x3c>
      if(p->s.size == nunits)
 7b6:	02e90b63          	beq	s2,a4,7ec <malloc+0xac>
        p->s.size -= nunits;
 7ba:	4137073b          	subw	a4,a4,s3
 7be:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7c0:	1702                	slli	a4,a4,0x20
 7c2:	9301                	srli	a4,a4,0x20
 7c4:	0712                	slli	a4,a4,0x4
 7c6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7c8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7cc:	00000717          	auipc	a4,0x0
 7d0:	0aa73a23          	sd	a0,180(a4) # 880 <__bss_start>
      return (void*)(p + 1);
 7d4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d8:	70e2                	ld	ra,56(sp)
 7da:	7442                	ld	s0,48(sp)
 7dc:	74a2                	ld	s1,40(sp)
 7de:	7902                	ld	s2,32(sp)
 7e0:	69e2                	ld	s3,24(sp)
 7e2:	6a42                	ld	s4,16(sp)
 7e4:	6aa2                	ld	s5,8(sp)
 7e6:	6b02                	ld	s6,0(sp)
 7e8:	6121                	addi	sp,sp,64
 7ea:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7ec:	6398                	ld	a4,0(a5)
 7ee:	e118                	sd	a4,0(a0)
 7f0:	bff1                	j	7cc <malloc+0x8c>
  hp->s.size = nu;
 7f2:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 7f6:	0541                	addi	a0,a0,16
 7f8:	00000097          	auipc	ra,0x0
 7fc:	ebe080e7          	jalr	-322(ra) # 6b6 <free>
  return freep;
 800:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 802:	d979                	beqz	a0,7d8 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 804:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 806:	4798                	lw	a4,8(a5)
 808:	fb2777e3          	bleu	s2,a4,7b6 <malloc+0x76>
    if(p == freep)
 80c:	6098                	ld	a4,0(s1)
 80e:	853e                	mv	a0,a5
 810:	fef71ae3          	bne	a4,a5,804 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 814:	8552                	mv	a0,s4
 816:	00000097          	auipc	ra,0x0
 81a:	b7a080e7          	jalr	-1158(ra) # 390 <sbrk>
  if(p == (char*)-1)
 81e:	fd651ae3          	bne	a0,s6,7f2 <malloc+0xb2>
        return 0;
 822:	4501                	li	a0,0
 824:	bf55                	j	7d8 <malloc+0x98>
