
user/_stressfs：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	8da78793          	addi	a5,a5,-1830 # 8f0 <malloc+0x11c>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	89450513          	addi	a0,a0,-1900 # 8c0 <malloc+0xec>
  34:	00000097          	auipc	ra,0x0
  38:	6e0080e7          	jalr	1760(ra) # 714 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	13e080e7          	jalr	318(ra) # 186 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	340080e7          	jalr	832(ra) # 394 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	87050513          	addi	a0,a0,-1936 # 8d8 <malloc+0x104>
  70:	00000097          	auipc	ra,0x0
  74:	6a4080e7          	jalr	1700(ra) # 714 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9cbd                	addw	s1,s1,a5
  7e:	fc940c23          	sb	s1,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	352080e7          	jalr	850(ra) # 3dc <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	31c080e7          	jalr	796(ra) # 3bc <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	316080e7          	jalr	790(ra) # 3c4 <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	83250513          	addi	a0,a0,-1998 # 8e8 <malloc+0x114>
  be:	00000097          	auipc	ra,0x0
  c2:	656080e7          	jalr	1622(ra) # 714 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	310080e7          	jalr	784(ra) # 3dc <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2d2080e7          	jalr	722(ra) # 3b4 <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2d4080e7          	jalr	724(ra) # 3c4 <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2aa080e7          	jalr	682(ra) # 3a4 <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	298080e7          	jalr	664(ra) # 39c <exit>

000000000000010c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 112:	87aa                	mv	a5,a0
 114:	0585                	addi	a1,a1,1
 116:	0785                	addi	a5,a5,1
 118:	fff5c703          	lbu	a4,-1(a1)
 11c:	fee78fa3          	sb	a4,-1(a5)
 120:	fb75                	bnez	a4,114 <strcpy+0x8>
    ;
  return os;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cf91                	beqz	a5,14e <strcmp+0x26>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71b63          	bne	a4,a5,14e <strcmp+0x26>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	c789                	beqz	a5,14e <strcmp+0x26>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	fef709e3          	beq	a4,a5,13c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 14e:	0005c503          	lbu	a0,0(a1)
}
 152:	40a7853b          	subw	a0,a5,a0
 156:	6422                	ld	s0,8(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret

000000000000015c <strlen>:

uint
strlen(const char *s)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 162:	00054783          	lbu	a5,0(a0)
 166:	cf91                	beqz	a5,182 <strlen+0x26>
 168:	0505                	addi	a0,a0,1
 16a:	87aa                	mv	a5,a0
 16c:	4685                	li	a3,1
 16e:	9e89                	subw	a3,a3,a0
 170:	00f6853b          	addw	a0,a3,a5
 174:	0785                	addi	a5,a5,1
 176:	fff7c703          	lbu	a4,-1(a5)
 17a:	fb7d                	bnez	a4,170 <strlen+0x14>
    ;
  return n;
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret
  for(n = 0; s[n]; n++)
 182:	4501                	li	a0,0
 184:	bfe5                	j	17c <strlen+0x20>

0000000000000186 <memset>:

void*
memset(void *dst, int c, uint n)
{
 186:	1141                	addi	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18c:	ce09                	beqz	a2,1a6 <memset+0x20>
 18e:	87aa                	mv	a5,a0
 190:	fff6071b          	addiw	a4,a2,-1
 194:	1702                	slli	a4,a4,0x20
 196:	9301                	srli	a4,a4,0x20
 198:	0705                	addi	a4,a4,1
 19a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 19c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a0:	0785                	addi	a5,a5,1
 1a2:	fee79de3          	bne	a5,a4,19c <memset+0x16>
  }
  return dst;
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret

00000000000001ac <strchr>:

char*
strchr(const char *s, char c)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e422                	sd	s0,8(sp)
 1b0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	cf91                	beqz	a5,1d2 <strchr+0x26>
    if(*s == c)
 1b8:	00f58a63          	beq	a1,a5,1cc <strchr+0x20>
  for(; *s; s++)
 1bc:	0505                	addi	a0,a0,1
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	c781                	beqz	a5,1ca <strchr+0x1e>
    if(*s == c)
 1c4:	feb79ce3          	bne	a5,a1,1bc <strchr+0x10>
 1c8:	a011                	j	1cc <strchr+0x20>
      return (char*)s;
  return 0;
 1ca:	4501                	li	a0,0
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <strchr+0x20>

00000000000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	1080                	addi	s0,sp,96
 1ec:	8baa                	mv	s7,a0
 1ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f0:	892a                	mv	s2,a0
 1f2:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f4:	4aa9                	li	s5,10
 1f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f8:	0019849b          	addiw	s1,s3,1
 1fc:	0344d863          	ble	s4,s1,22c <gets+0x56>
    cc = read(0, &c, 1);
 200:	4605                	li	a2,1
 202:	faf40593          	addi	a1,s0,-81
 206:	4501                	li	a0,0
 208:	00000097          	auipc	ra,0x0
 20c:	1ac080e7          	jalr	428(ra) # 3b4 <read>
    if(cc < 1)
 210:	00a05e63          	blez	a0,22c <gets+0x56>
    buf[i++] = c;
 214:	faf44783          	lbu	a5,-81(s0)
 218:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21c:	01578763          	beq	a5,s5,22a <gets+0x54>
 220:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 222:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 224:	fd679ae3          	bne	a5,s6,1f8 <gets+0x22>
 228:	a011                	j	22c <gets+0x56>
  for(i=0; i+1 < max; ){
 22a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22c:	99de                	add	s3,s3,s7
 22e:	00098023          	sb	zero,0(s3)
  return buf;
}
 232:	855e                	mv	a0,s7
 234:	60e6                	ld	ra,88(sp)
 236:	6446                	ld	s0,80(sp)
 238:	64a6                	ld	s1,72(sp)
 23a:	6906                	ld	s2,64(sp)
 23c:	79e2                	ld	s3,56(sp)
 23e:	7a42                	ld	s4,48(sp)
 240:	7aa2                	ld	s5,40(sp)
 242:	7b02                	ld	s6,32(sp)
 244:	6be2                	ld	s7,24(sp)
 246:	6125                	addi	sp,sp,96
 248:	8082                	ret

000000000000024a <stat>:

int
stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e426                	sd	s1,8(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	00000097          	auipc	ra,0x0
 25e:	182080e7          	jalr	386(ra) # 3dc <open>
  if(fd < 0)
 262:	02054563          	bltz	a0,28c <stat+0x42>
 266:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 268:	85ca                	mv	a1,s2
 26a:	00000097          	auipc	ra,0x0
 26e:	18a080e7          	jalr	394(ra) # 3f4 <fstat>
 272:	892a                	mv	s2,a0
  close(fd);
 274:	8526                	mv	a0,s1
 276:	00000097          	auipc	ra,0x0
 27a:	14e080e7          	jalr	334(ra) # 3c4 <close>
  return r;
}
 27e:	854a                	mv	a0,s2
 280:	60e2                	ld	ra,24(sp)
 282:	6442                	ld	s0,16(sp)
 284:	64a2                	ld	s1,8(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
    return -1;
 28c:	597d                	li	s2,-1
 28e:	bfc5                	j	27e <stat+0x34>

0000000000000290 <atoi>:

int
atoi(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 296:	00054683          	lbu	a3,0(a0)
 29a:	fd06879b          	addiw	a5,a3,-48
 29e:	0ff7f793          	andi	a5,a5,255
 2a2:	4725                	li	a4,9
 2a4:	02f76963          	bltu	a4,a5,2d6 <atoi+0x46>
 2a8:	862a                	mv	a2,a0
  n = 0;
 2aa:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2ac:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2ae:	0605                	addi	a2,a2,1
 2b0:	0025179b          	slliw	a5,a0,0x2
 2b4:	9fa9                	addw	a5,a5,a0
 2b6:	0017979b          	slliw	a5,a5,0x1
 2ba:	9fb5                	addw	a5,a5,a3
 2bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c0:	00064683          	lbu	a3,0(a2)
 2c4:	fd06871b          	addiw	a4,a3,-48
 2c8:	0ff77713          	andi	a4,a4,255
 2cc:	fee5f1e3          	bleu	a4,a1,2ae <atoi+0x1e>
  return n;
}
 2d0:	6422                	ld	s0,8(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
  n = 0;
 2d6:	4501                	li	a0,0
 2d8:	bfe5                	j	2d0 <atoi+0x40>

00000000000002da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e0:	02b57663          	bleu	a1,a0,30c <memmove+0x32>
    while(n-- > 0)
 2e4:	02c05163          	blez	a2,306 <memmove+0x2c>
 2e8:	fff6079b          	addiw	a5,a2,-1
 2ec:	1782                	slli	a5,a5,0x20
 2ee:	9381                	srli	a5,a5,0x20
 2f0:	0785                	addi	a5,a5,1
 2f2:	97aa                	add	a5,a5,a0
  dst = vdst;
 2f4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f6:	0585                	addi	a1,a1,1
 2f8:	0705                	addi	a4,a4,1
 2fa:	fff5c683          	lbu	a3,-1(a1)
 2fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 302:	fee79ae3          	bne	a5,a4,2f6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
    dst += n;
 30c:	00c50733          	add	a4,a0,a2
    src += n;
 310:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 312:	fec05ae3          	blez	a2,306 <memmove+0x2c>
 316:	fff6079b          	addiw	a5,a2,-1
 31a:	1782                	slli	a5,a5,0x20
 31c:	9381                	srli	a5,a5,0x20
 31e:	fff7c793          	not	a5,a5
 322:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 324:	15fd                	addi	a1,a1,-1
 326:	177d                	addi	a4,a4,-1
 328:	0005c683          	lbu	a3,0(a1)
 32c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 330:	fef71ae3          	bne	a4,a5,324 <memmove+0x4a>
 334:	bfc9                	j	306 <memmove+0x2c>

0000000000000336 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33c:	ce15                	beqz	a2,378 <memcmp+0x42>
 33e:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 342:	00054783          	lbu	a5,0(a0)
 346:	0005c703          	lbu	a4,0(a1)
 34a:	02e79063          	bne	a5,a4,36a <memcmp+0x34>
 34e:	1682                	slli	a3,a3,0x20
 350:	9281                	srli	a3,a3,0x20
 352:	0685                	addi	a3,a3,1
 354:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 356:	0505                	addi	a0,a0,1
    p2++;
 358:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35a:	00d50d63          	beq	a0,a3,374 <memcmp+0x3e>
    if (*p1 != *p2) {
 35e:	00054783          	lbu	a5,0(a0)
 362:	0005c703          	lbu	a4,0(a1)
 366:	fee788e3          	beq	a5,a4,356 <memcmp+0x20>
      return *p1 - *p2;
 36a:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 36e:	6422                	ld	s0,8(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret
  return 0;
 374:	4501                	li	a0,0
 376:	bfe5                	j	36e <memcmp+0x38>
 378:	4501                	li	a0,0
 37a:	bfd5                	j	36e <memcmp+0x38>

000000000000037c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 384:	00000097          	auipc	ra,0x0
 388:	f56080e7          	jalr	-170(ra) # 2da <memmove>
}
 38c:	60a2                	ld	ra,8(sp)
 38e:	6402                	ld	s0,0(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret

0000000000000394 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 394:	4885                	li	a7,1
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <exit>:
.global exit
exit:
 li a7, SYS_exit
 39c:	4889                	li	a7,2
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a4:	488d                	li	a7,3
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ac:	4891                	li	a7,4
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <read>:
.global read
read:
 li a7, SYS_read
 3b4:	4895                	li	a7,5
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <write>:
.global write
write:
 li a7, SYS_write
 3bc:	48c1                	li	a7,16
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <close>:
.global close
close:
 li a7, SYS_close
 3c4:	48d5                	li	a7,21
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3cc:	4899                	li	a7,6
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d4:	489d                	li	a7,7
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <open>:
.global open
open:
 li a7, SYS_open
 3dc:	48bd                	li	a7,15
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e4:	48c5                	li	a7,17
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ec:	48c9                	li	a7,18
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f4:	48a1                	li	a7,8
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <link>:
.global link
link:
 li a7, SYS_link
 3fc:	48cd                	li	a7,19
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 404:	48d1                	li	a7,20
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40c:	48a5                	li	a7,9
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <dup>:
.global dup
dup:
 li a7, SYS_dup
 414:	48a9                	li	a7,10
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41c:	48ad                	li	a7,11
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 424:	48b1                	li	a7,12
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 42c:	48b5                	li	a7,13
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 434:	48b9                	li	a7,14
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43c:	1101                	addi	sp,sp,-32
 43e:	ec06                	sd	ra,24(sp)
 440:	e822                	sd	s0,16(sp)
 442:	1000                	addi	s0,sp,32
 444:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 448:	4605                	li	a2,1
 44a:	fef40593          	addi	a1,s0,-17
 44e:	00000097          	auipc	ra,0x0
 452:	f6e080e7          	jalr	-146(ra) # 3bc <write>
}
 456:	60e2                	ld	ra,24(sp)
 458:	6442                	ld	s0,16(sp)
 45a:	6105                	addi	sp,sp,32
 45c:	8082                	ret

000000000000045e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45e:	7139                	addi	sp,sp,-64
 460:	fc06                	sd	ra,56(sp)
 462:	f822                	sd	s0,48(sp)
 464:	f426                	sd	s1,40(sp)
 466:	f04a                	sd	s2,32(sp)
 468:	ec4e                	sd	s3,24(sp)
 46a:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46c:	c299                	beqz	a3,472 <printint+0x14>
 46e:	0005cd63          	bltz	a1,488 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 472:	2581                	sext.w	a1,a1
  neg = 0;
 474:	4301                	li	t1,0
 476:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 47a:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 47c:	2601                	sext.w	a2,a2
 47e:	00000897          	auipc	a7,0x0
 482:	48288893          	addi	a7,a7,1154 # 900 <digits>
 486:	a801                	j	496 <printint+0x38>
    x = -xx;
 488:	40b005bb          	negw	a1,a1
 48c:	2581                	sext.w	a1,a1
    neg = 1;
 48e:	4305                	li	t1,1
    x = -xx;
 490:	b7dd                	j	476 <printint+0x18>
  }while((x /= base) != 0);
 492:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 494:	8836                	mv	a6,a3
 496:	0018069b          	addiw	a3,a6,1
 49a:	02c5f7bb          	remuw	a5,a1,a2
 49e:	1782                	slli	a5,a5,0x20
 4a0:	9381                	srli	a5,a5,0x20
 4a2:	97c6                	add	a5,a5,a7
 4a4:	0007c783          	lbu	a5,0(a5)
 4a8:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 4ac:	0705                	addi	a4,a4,1
 4ae:	02c5d7bb          	divuw	a5,a1,a2
 4b2:	fec5f0e3          	bleu	a2,a1,492 <printint+0x34>
  if(neg)
 4b6:	00030b63          	beqz	t1,4cc <printint+0x6e>
    buf[i++] = '-';
 4ba:	fd040793          	addi	a5,s0,-48
 4be:	96be                	add	a3,a3,a5
 4c0:	02d00793          	li	a5,45
 4c4:	fef68823          	sb	a5,-16(a3)
 4c8:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 4cc:	02d05963          	blez	a3,4fe <printint+0xa0>
 4d0:	89aa                	mv	s3,a0
 4d2:	fc040793          	addi	a5,s0,-64
 4d6:	00d784b3          	add	s1,a5,a3
 4da:	fff78913          	addi	s2,a5,-1
 4de:	9936                	add	s2,s2,a3
 4e0:	36fd                	addiw	a3,a3,-1
 4e2:	1682                	slli	a3,a3,0x20
 4e4:	9281                	srli	a3,a3,0x20
 4e6:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 4ea:	fff4c583          	lbu	a1,-1(s1)
 4ee:	854e                	mv	a0,s3
 4f0:	00000097          	auipc	ra,0x0
 4f4:	f4c080e7          	jalr	-180(ra) # 43c <putc>
  while(--i >= 0)
 4f8:	14fd                	addi	s1,s1,-1
 4fa:	ff2498e3          	bne	s1,s2,4ea <printint+0x8c>
}
 4fe:	70e2                	ld	ra,56(sp)
 500:	7442                	ld	s0,48(sp)
 502:	74a2                	ld	s1,40(sp)
 504:	7902                	ld	s2,32(sp)
 506:	69e2                	ld	s3,24(sp)
 508:	6121                	addi	sp,sp,64
 50a:	8082                	ret

000000000000050c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50c:	7119                	addi	sp,sp,-128
 50e:	fc86                	sd	ra,120(sp)
 510:	f8a2                	sd	s0,112(sp)
 512:	f4a6                	sd	s1,104(sp)
 514:	f0ca                	sd	s2,96(sp)
 516:	ecce                	sd	s3,88(sp)
 518:	e8d2                	sd	s4,80(sp)
 51a:	e4d6                	sd	s5,72(sp)
 51c:	e0da                	sd	s6,64(sp)
 51e:	fc5e                	sd	s7,56(sp)
 520:	f862                	sd	s8,48(sp)
 522:	f466                	sd	s9,40(sp)
 524:	f06a                	sd	s10,32(sp)
 526:	ec6e                	sd	s11,24(sp)
 528:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52a:	0005c483          	lbu	s1,0(a1)
 52e:	18048d63          	beqz	s1,6c8 <vprintf+0x1bc>
 532:	8aaa                	mv	s5,a0
 534:	8b32                	mv	s6,a2
 536:	00158913          	addi	s2,a1,1
  state = 0;
 53a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 53c:	02500a13          	li	s4,37
      if(c == 'd'){
 540:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 544:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 548:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 54c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 550:	00000b97          	auipc	s7,0x0
 554:	3b0b8b93          	addi	s7,s7,944 # 900 <digits>
 558:	a839                	j	576 <vprintf+0x6a>
        putc(fd, c);
 55a:	85a6                	mv	a1,s1
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	ede080e7          	jalr	-290(ra) # 43c <putc>
 566:	a019                	j	56c <vprintf+0x60>
    } else if(state == '%'){
 568:	01498f63          	beq	s3,s4,586 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 56c:	0905                	addi	s2,s2,1
 56e:	fff94483          	lbu	s1,-1(s2)
 572:	14048b63          	beqz	s1,6c8 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 576:	0004879b          	sext.w	a5,s1
    if(state == 0){
 57a:	fe0997e3          	bnez	s3,568 <vprintf+0x5c>
      if(c == '%'){
 57e:	fd479ee3          	bne	a5,s4,55a <vprintf+0x4e>
        state = '%';
 582:	89be                	mv	s3,a5
 584:	b7e5                	j	56c <vprintf+0x60>
      if(c == 'd'){
 586:	05878063          	beq	a5,s8,5c6 <vprintf+0xba>
      } else if(c == 'l') {
 58a:	05978c63          	beq	a5,s9,5e2 <vprintf+0xd6>
      } else if(c == 'x') {
 58e:	07a78863          	beq	a5,s10,5fe <vprintf+0xf2>
      } else if(c == 'p') {
 592:	09b78463          	beq	a5,s11,61a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 596:	07300713          	li	a4,115
 59a:	0ce78563          	beq	a5,a4,664 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59e:	06300713          	li	a4,99
 5a2:	0ee78c63          	beq	a5,a4,69a <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5a6:	11478663          	beq	a5,s4,6b2 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5aa:	85d2                	mv	a1,s4
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	e8e080e7          	jalr	-370(ra) # 43c <putc>
        putc(fd, c);
 5b6:	85a6                	mv	a1,s1
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	e82080e7          	jalr	-382(ra) # 43c <putc>
      }
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b765                	j	56c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5c6:	008b0493          	addi	s1,s6,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000b2583          	lw	a1,0(s6)
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e8a080e7          	jalr	-374(ra) # 45e <printint>
 5dc:	8b26                	mv	s6,s1
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b771                	j	56c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e2:	008b0493          	addi	s1,s6,8
 5e6:	4681                	li	a3,0
 5e8:	4629                	li	a2,10
 5ea:	000b2583          	lw	a1,0(s6)
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e6e080e7          	jalr	-402(ra) # 45e <printint>
 5f8:	8b26                	mv	s6,s1
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bf85                	j	56c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5fe:	008b0493          	addi	s1,s6,8
 602:	4681                	li	a3,0
 604:	4641                	li	a2,16
 606:	000b2583          	lw	a1,0(s6)
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e52080e7          	jalr	-430(ra) # 45e <printint>
 614:	8b26                	mv	s6,s1
      state = 0;
 616:	4981                	li	s3,0
 618:	bf91                	j	56c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 61a:	008b0793          	addi	a5,s6,8
 61e:	f8f43423          	sd	a5,-120(s0)
 622:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 626:	03000593          	li	a1,48
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	e10080e7          	jalr	-496(ra) # 43c <putc>
  putc(fd, 'x');
 634:	85ea                	mv	a1,s10
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e04080e7          	jalr	-508(ra) # 43c <putc>
 640:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 642:	03c9d793          	srli	a5,s3,0x3c
 646:	97de                	add	a5,a5,s7
 648:	0007c583          	lbu	a1,0(a5)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	dee080e7          	jalr	-530(ra) # 43c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 656:	0992                	slli	s3,s3,0x4
 658:	34fd                	addiw	s1,s1,-1
 65a:	f4e5                	bnez	s1,642 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 65c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 660:	4981                	li	s3,0
 662:	b729                	j	56c <vprintf+0x60>
        s = va_arg(ap, char*);
 664:	008b0993          	addi	s3,s6,8
 668:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 66c:	c085                	beqz	s1,68c <vprintf+0x180>
        while(*s != 0){
 66e:	0004c583          	lbu	a1,0(s1)
 672:	c9a1                	beqz	a1,6c2 <vprintf+0x1b6>
          putc(fd, *s);
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	dc6080e7          	jalr	-570(ra) # 43c <putc>
          s++;
 67e:	0485                	addi	s1,s1,1
        while(*s != 0){
 680:	0004c583          	lbu	a1,0(s1)
 684:	f9e5                	bnez	a1,674 <vprintf+0x168>
        s = va_arg(ap, char*);
 686:	8b4e                	mv	s6,s3
      state = 0;
 688:	4981                	li	s3,0
 68a:	b5cd                	j	56c <vprintf+0x60>
          s = "(null)";
 68c:	00000497          	auipc	s1,0x0
 690:	28c48493          	addi	s1,s1,652 # 918 <digits+0x18>
        while(*s != 0){
 694:	02800593          	li	a1,40
 698:	bff1                	j	674 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 69a:	008b0493          	addi	s1,s6,8
 69e:	000b4583          	lbu	a1,0(s6)
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	d98080e7          	jalr	-616(ra) # 43c <putc>
 6ac:	8b26                	mv	s6,s1
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	bd75                	j	56c <vprintf+0x60>
        putc(fd, c);
 6b2:	85d2                	mv	a1,s4
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	d86080e7          	jalr	-634(ra) # 43c <putc>
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b575                	j	56c <vprintf+0x60>
        s = va_arg(ap, char*);
 6c2:	8b4e                	mv	s6,s3
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b55d                	j	56c <vprintf+0x60>
    }
  }
}
 6c8:	70e6                	ld	ra,120(sp)
 6ca:	7446                	ld	s0,112(sp)
 6cc:	74a6                	ld	s1,104(sp)
 6ce:	7906                	ld	s2,96(sp)
 6d0:	69e6                	ld	s3,88(sp)
 6d2:	6a46                	ld	s4,80(sp)
 6d4:	6aa6                	ld	s5,72(sp)
 6d6:	6b06                	ld	s6,64(sp)
 6d8:	7be2                	ld	s7,56(sp)
 6da:	7c42                	ld	s8,48(sp)
 6dc:	7ca2                	ld	s9,40(sp)
 6de:	7d02                	ld	s10,32(sp)
 6e0:	6de2                	ld	s11,24(sp)
 6e2:	6109                	addi	sp,sp,128
 6e4:	8082                	ret

00000000000006e6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e6:	715d                	addi	sp,sp,-80
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	e010                	sd	a2,0(s0)
 6f0:	e414                	sd	a3,8(s0)
 6f2:	e818                	sd	a4,16(s0)
 6f4:	ec1c                	sd	a5,24(s0)
 6f6:	03043023          	sd	a6,32(s0)
 6fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6fe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 702:	8622                	mv	a2,s0
 704:	00000097          	auipc	ra,0x0
 708:	e08080e7          	jalr	-504(ra) # 50c <vprintf>
}
 70c:	60e2                	ld	ra,24(sp)
 70e:	6442                	ld	s0,16(sp)
 710:	6161                	addi	sp,sp,80
 712:	8082                	ret

0000000000000714 <printf>:

void
printf(const char *fmt, ...)
{
 714:	711d                	addi	sp,sp,-96
 716:	ec06                	sd	ra,24(sp)
 718:	e822                	sd	s0,16(sp)
 71a:	1000                	addi	s0,sp,32
 71c:	e40c                	sd	a1,8(s0)
 71e:	e810                	sd	a2,16(s0)
 720:	ec14                	sd	a3,24(s0)
 722:	f018                	sd	a4,32(s0)
 724:	f41c                	sd	a5,40(s0)
 726:	03043823          	sd	a6,48(s0)
 72a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 72e:	00840613          	addi	a2,s0,8
 732:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 736:	85aa                	mv	a1,a0
 738:	4505                	li	a0,1
 73a:	00000097          	auipc	ra,0x0
 73e:	dd2080e7          	jalr	-558(ra) # 50c <vprintf>
}
 742:	60e2                	ld	ra,24(sp)
 744:	6442                	ld	s0,16(sp)
 746:	6125                	addi	sp,sp,96
 748:	8082                	ret

000000000000074a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74a:	1141                	addi	sp,sp,-16
 74c:	e422                	sd	s0,8(sp)
 74e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 750:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 754:	00000797          	auipc	a5,0x0
 758:	1cc78793          	addi	a5,a5,460 # 920 <__bss_start>
 75c:	639c                	ld	a5,0(a5)
 75e:	a805                	j	78e <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 760:	4618                	lw	a4,8(a2)
 762:	9db9                	addw	a1,a1,a4
 764:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 768:	6398                	ld	a4,0(a5)
 76a:	6318                	ld	a4,0(a4)
 76c:	fee53823          	sd	a4,-16(a0)
 770:	a091                	j	7b4 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 772:	ff852703          	lw	a4,-8(a0)
 776:	9e39                	addw	a2,a2,a4
 778:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 77a:	ff053703          	ld	a4,-16(a0)
 77e:	e398                	sd	a4,0(a5)
 780:	a099                	j	7c6 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 782:	6398                	ld	a4,0(a5)
 784:	00e7e463          	bltu	a5,a4,78c <free+0x42>
 788:	00e6ea63          	bltu	a3,a4,79c <free+0x52>
{
 78c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	fed7fae3          	bleu	a3,a5,782 <free+0x38>
 792:	6398                	ld	a4,0(a5)
 794:	00e6e463          	bltu	a3,a4,79c <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	fee7eae3          	bltu	a5,a4,78c <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 79c:	ff852583          	lw	a1,-8(a0)
 7a0:	6390                	ld	a2,0(a5)
 7a2:	02059713          	slli	a4,a1,0x20
 7a6:	9301                	srli	a4,a4,0x20
 7a8:	0712                	slli	a4,a4,0x4
 7aa:	9736                	add	a4,a4,a3
 7ac:	fae60ae3          	beq	a2,a4,760 <free+0x16>
    bp->s.ptr = p->s.ptr;
 7b0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b4:	4790                	lw	a2,8(a5)
 7b6:	02061713          	slli	a4,a2,0x20
 7ba:	9301                	srli	a4,a4,0x20
 7bc:	0712                	slli	a4,a4,0x4
 7be:	973e                	add	a4,a4,a5
 7c0:	fae689e3          	beq	a3,a4,772 <free+0x28>
  } else
    p->s.ptr = bp;
 7c4:	e394                	sd	a3,0(a5)
  freep = p;
 7c6:	00000717          	auipc	a4,0x0
 7ca:	14f73d23          	sd	a5,346(a4) # 920 <__bss_start>
}
 7ce:	6422                	ld	s0,8(sp)
 7d0:	0141                	addi	sp,sp,16
 7d2:	8082                	ret

00000000000007d4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d4:	7139                	addi	sp,sp,-64
 7d6:	fc06                	sd	ra,56(sp)
 7d8:	f822                	sd	s0,48(sp)
 7da:	f426                	sd	s1,40(sp)
 7dc:	f04a                	sd	s2,32(sp)
 7de:	ec4e                	sd	s3,24(sp)
 7e0:	e852                	sd	s4,16(sp)
 7e2:	e456                	sd	s5,8(sp)
 7e4:	e05a                	sd	s6,0(sp)
 7e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e8:	02051993          	slli	s3,a0,0x20
 7ec:	0209d993          	srli	s3,s3,0x20
 7f0:	09bd                	addi	s3,s3,15
 7f2:	0049d993          	srli	s3,s3,0x4
 7f6:	2985                	addiw	s3,s3,1
 7f8:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 7fc:	00000797          	auipc	a5,0x0
 800:	12478793          	addi	a5,a5,292 # 920 <__bss_start>
 804:	6388                	ld	a0,0(a5)
 806:	c515                	beqz	a0,832 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80a:	4798                	lw	a4,8(a5)
 80c:	03277f63          	bleu	s2,a4,84a <malloc+0x76>
 810:	8a4e                	mv	s4,s3
 812:	0009871b          	sext.w	a4,s3
 816:	6685                	lui	a3,0x1
 818:	00d77363          	bleu	a3,a4,81e <malloc+0x4a>
 81c:	6a05                	lui	s4,0x1
 81e:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 822:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 826:	00000497          	auipc	s1,0x0
 82a:	0fa48493          	addi	s1,s1,250 # 920 <__bss_start>
  if(p == (char*)-1)
 82e:	5b7d                	li	s6,-1
 830:	a885                	j	8a0 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 832:	00000797          	auipc	a5,0x0
 836:	0f678793          	addi	a5,a5,246 # 928 <base>
 83a:	00000717          	auipc	a4,0x0
 83e:	0ef73323          	sd	a5,230(a4) # 920 <__bss_start>
 842:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 844:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 848:	b7e1                	j	810 <malloc+0x3c>
      if(p->s.size == nunits)
 84a:	02e90b63          	beq	s2,a4,880 <malloc+0xac>
        p->s.size -= nunits;
 84e:	4137073b          	subw	a4,a4,s3
 852:	c798                	sw	a4,8(a5)
        p += p->s.size;
 854:	1702                	slli	a4,a4,0x20
 856:	9301                	srli	a4,a4,0x20
 858:	0712                	slli	a4,a4,0x4
 85a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 85c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 860:	00000717          	auipc	a4,0x0
 864:	0ca73023          	sd	a0,192(a4) # 920 <__bss_start>
      return (void*)(p + 1);
 868:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 86c:	70e2                	ld	ra,56(sp)
 86e:	7442                	ld	s0,48(sp)
 870:	74a2                	ld	s1,40(sp)
 872:	7902                	ld	s2,32(sp)
 874:	69e2                	ld	s3,24(sp)
 876:	6a42                	ld	s4,16(sp)
 878:	6aa2                	ld	s5,8(sp)
 87a:	6b02                	ld	s6,0(sp)
 87c:	6121                	addi	sp,sp,64
 87e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 880:	6398                	ld	a4,0(a5)
 882:	e118                	sd	a4,0(a0)
 884:	bff1                	j	860 <malloc+0x8c>
  hp->s.size = nu;
 886:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 88a:	0541                	addi	a0,a0,16
 88c:	00000097          	auipc	ra,0x0
 890:	ebe080e7          	jalr	-322(ra) # 74a <free>
  return freep;
 894:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 896:	d979                	beqz	a0,86c <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89a:	4798                	lw	a4,8(a5)
 89c:	fb2777e3          	bleu	s2,a4,84a <malloc+0x76>
    if(p == freep)
 8a0:	6098                	ld	a4,0(s1)
 8a2:	853e                	mv	a0,a5
 8a4:	fef71ae3          	bne	a4,a5,898 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 8a8:	8552                	mv	a0,s4
 8aa:	00000097          	auipc	ra,0x0
 8ae:	b7a080e7          	jalr	-1158(ra) # 424 <sbrk>
  if(p == (char*)-1)
 8b2:	fd651ae3          	bne	a0,s6,886 <malloc+0xb2>
        return 0;
 8b6:	4501                	li	a0,0
 8b8:	bf55                	j	86c <malloc+0x98>
