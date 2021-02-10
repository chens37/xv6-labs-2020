
user/_cat：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	92890913          	addi	s2,s2,-1752 # 938 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	3a2080e7          	jalr	930(ra) # 3c2 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	396080e7          	jalr	918(ra) # 3ca <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	88858593          	addi	a1,a1,-1912 # 8c8 <malloc+0xe6>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	6aa080e7          	jalr	1706(ra) # 6f4 <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	356080e7          	jalr	854(ra) # 3aa <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	87258593          	addi	a1,a1,-1934 # 8e0 <malloc+0xfe>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	67c080e7          	jalr	1660(ra) # 6f4 <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	328080e7          	jalr	808(ra) # 3aa <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	e052                	sd	s4,0(sp)
  98:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9a:	4785                	li	a5,1
  9c:	04a7d663          	ble	a0,a5,e8 <main+0x5e>
  a0:	00858493          	addi	s1,a1,8
  a4:	ffe5099b          	addiw	s3,a0,-2
  a8:	1982                	slli	s3,s3,0x20
  aa:	0209d993          	srli	s3,s3,0x20
  ae:	098e                	slli	s3,s3,0x3
  b0:	05c1                	addi	a1,a1,16
  b2:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b4:	4581                	li	a1,0
  b6:	6088                	ld	a0,0(s1)
  b8:	00000097          	auipc	ra,0x0
  bc:	332080e7          	jalr	818(ra) # 3ea <open>
  c0:	892a                	mv	s2,a0
  c2:	02054d63          	bltz	a0,fc <main+0x72>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	854a                	mv	a0,s2
  d0:	00000097          	auipc	ra,0x0
  d4:	302080e7          	jalr	770(ra) # 3d2 <close>
  for(i = 1; i < argc; i++){
  d8:	04a1                	addi	s1,s1,8
  da:	fd349de3          	bne	s1,s3,b4 <main+0x2a>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2ca080e7          	jalr	714(ra) # 3aa <exit>
    cat(0);
  e8:	4501                	li	a0,0
  ea:	00000097          	auipc	ra,0x0
  ee:	f16080e7          	jalr	-234(ra) # 0 <cat>
    exit(0);
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	2b6080e7          	jalr	694(ra) # 3aa <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fc:	6090                	ld	a2,0(s1)
  fe:	00000597          	auipc	a1,0x0
 102:	7fa58593          	addi	a1,a1,2042 # 8f8 <malloc+0x116>
 106:	4509                	li	a0,2
 108:	00000097          	auipc	ra,0x0
 10c:	5ec080e7          	jalr	1516(ra) # 6f4 <fprintf>
      exit(1);
 110:	4505                	li	a0,1
 112:	00000097          	auipc	ra,0x0
 116:	298080e7          	jalr	664(ra) # 3aa <exit>

000000000000011a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 120:	87aa                	mv	a5,a0
 122:	0585                	addi	a1,a1,1
 124:	0785                	addi	a5,a5,1
 126:	fff5c703          	lbu	a4,-1(a1)
 12a:	fee78fa3          	sb	a4,-1(a5)
 12e:	fb75                	bnez	a4,122 <strcpy+0x8>
    ;
  return os;
}
 130:	6422                	ld	s0,8(sp)
 132:	0141                	addi	sp,sp,16
 134:	8082                	ret

0000000000000136 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 136:	1141                	addi	sp,sp,-16
 138:	e422                	sd	s0,8(sp)
 13a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13c:	00054783          	lbu	a5,0(a0)
 140:	cf91                	beqz	a5,15c <strcmp+0x26>
 142:	0005c703          	lbu	a4,0(a1)
 146:	00f71b63          	bne	a4,a5,15c <strcmp+0x26>
    p++, q++;
 14a:	0505                	addi	a0,a0,1
 14c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14e:	00054783          	lbu	a5,0(a0)
 152:	c789                	beqz	a5,15c <strcmp+0x26>
 154:	0005c703          	lbu	a4,0(a1)
 158:	fef709e3          	beq	a4,a5,14a <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 15c:	0005c503          	lbu	a0,0(a1)
}
 160:	40a7853b          	subw	a0,a5,a0
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret

000000000000016a <strlen>:

uint
strlen(const char *s)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 170:	00054783          	lbu	a5,0(a0)
 174:	cf91                	beqz	a5,190 <strlen+0x26>
 176:	0505                	addi	a0,a0,1
 178:	87aa                	mv	a5,a0
 17a:	4685                	li	a3,1
 17c:	9e89                	subw	a3,a3,a0
 17e:	00f6853b          	addw	a0,a3,a5
 182:	0785                	addi	a5,a5,1
 184:	fff7c703          	lbu	a4,-1(a5)
 188:	fb7d                	bnez	a4,17e <strlen+0x14>
    ;
  return n;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret
  for(n = 0; s[n]; n++)
 190:	4501                	li	a0,0
 192:	bfe5                	j	18a <strlen+0x20>

0000000000000194 <memset>:

void*
memset(void *dst, int c, uint n)
{
 194:	1141                	addi	sp,sp,-16
 196:	e422                	sd	s0,8(sp)
 198:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19a:	ce09                	beqz	a2,1b4 <memset+0x20>
 19c:	87aa                	mv	a5,a0
 19e:	fff6071b          	addiw	a4,a2,-1
 1a2:	1702                	slli	a4,a4,0x20
 1a4:	9301                	srli	a4,a4,0x20
 1a6:	0705                	addi	a4,a4,1
 1a8:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ae:	0785                	addi	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x16>
  }
  return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char*
strchr(const char *s, char c)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cf91                	beqz	a5,1e0 <strchr+0x26>
    if(*s == c)
 1c6:	00f58a63          	beq	a1,a5,1da <strchr+0x20>
  for(; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	c781                	beqz	a5,1d8 <strchr+0x1e>
    if(*s == c)
 1d2:	feb79ce3          	bne	a5,a1,1ca <strchr+0x10>
 1d6:	a011                	j	1da <strchr+0x20>
      return (char*)s;
  return 0;
 1d8:	4501                	li	a0,0
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret
  return 0;
 1e0:	4501                	li	a0,0
 1e2:	bfe5                	j	1da <strchr+0x20>

00000000000001e4 <gets>:

char*
gets(char *buf, int max)
{
 1e4:	711d                	addi	sp,sp,-96
 1e6:	ec86                	sd	ra,88(sp)
 1e8:	e8a2                	sd	s0,80(sp)
 1ea:	e4a6                	sd	s1,72(sp)
 1ec:	e0ca                	sd	s2,64(sp)
 1ee:	fc4e                	sd	s3,56(sp)
 1f0:	f852                	sd	s4,48(sp)
 1f2:	f456                	sd	s5,40(sp)
 1f4:	f05a                	sd	s6,32(sp)
 1f6:	ec5e                	sd	s7,24(sp)
 1f8:	1080                	addi	s0,sp,96
 1fa:	8baa                	mv	s7,a0
 1fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fe:	892a                	mv	s2,a0
 200:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 202:	4aa9                	li	s5,10
 204:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 206:	0019849b          	addiw	s1,s3,1
 20a:	0344d863          	ble	s4,s1,23a <gets+0x56>
    cc = read(0, &c, 1);
 20e:	4605                	li	a2,1
 210:	faf40593          	addi	a1,s0,-81
 214:	4501                	li	a0,0
 216:	00000097          	auipc	ra,0x0
 21a:	1ac080e7          	jalr	428(ra) # 3c2 <read>
    if(cc < 1)
 21e:	00a05e63          	blez	a0,23a <gets+0x56>
    buf[i++] = c;
 222:	faf44783          	lbu	a5,-81(s0)
 226:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 22a:	01578763          	beq	a5,s5,238 <gets+0x54>
 22e:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 230:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 232:	fd679ae3          	bne	a5,s6,206 <gets+0x22>
 236:	a011                	j	23a <gets+0x56>
  for(i=0; i+1 < max; ){
 238:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 23a:	99de                	add	s3,s3,s7
 23c:	00098023          	sb	zero,0(s3)
  return buf;
}
 240:	855e                	mv	a0,s7
 242:	60e6                	ld	ra,88(sp)
 244:	6446                	ld	s0,80(sp)
 246:	64a6                	ld	s1,72(sp)
 248:	6906                	ld	s2,64(sp)
 24a:	79e2                	ld	s3,56(sp)
 24c:	7a42                	ld	s4,48(sp)
 24e:	7aa2                	ld	s5,40(sp)
 250:	7b02                	ld	s6,32(sp)
 252:	6be2                	ld	s7,24(sp)
 254:	6125                	addi	sp,sp,96
 256:	8082                	ret

0000000000000258 <stat>:

int
stat(const char *n, struct stat *st)
{
 258:	1101                	addi	sp,sp,-32
 25a:	ec06                	sd	ra,24(sp)
 25c:	e822                	sd	s0,16(sp)
 25e:	e426                	sd	s1,8(sp)
 260:	e04a                	sd	s2,0(sp)
 262:	1000                	addi	s0,sp,32
 264:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 266:	4581                	li	a1,0
 268:	00000097          	auipc	ra,0x0
 26c:	182080e7          	jalr	386(ra) # 3ea <open>
  if(fd < 0)
 270:	02054563          	bltz	a0,29a <stat+0x42>
 274:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 276:	85ca                	mv	a1,s2
 278:	00000097          	auipc	ra,0x0
 27c:	18a080e7          	jalr	394(ra) # 402 <fstat>
 280:	892a                	mv	s2,a0
  close(fd);
 282:	8526                	mv	a0,s1
 284:	00000097          	auipc	ra,0x0
 288:	14e080e7          	jalr	334(ra) # 3d2 <close>
  return r;
}
 28c:	854a                	mv	a0,s2
 28e:	60e2                	ld	ra,24(sp)
 290:	6442                	ld	s0,16(sp)
 292:	64a2                	ld	s1,8(sp)
 294:	6902                	ld	s2,0(sp)
 296:	6105                	addi	sp,sp,32
 298:	8082                	ret
    return -1;
 29a:	597d                	li	s2,-1
 29c:	bfc5                	j	28c <stat+0x34>

000000000000029e <atoi>:

int
atoi(const char *s)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a4:	00054683          	lbu	a3,0(a0)
 2a8:	fd06879b          	addiw	a5,a3,-48
 2ac:	0ff7f793          	andi	a5,a5,255
 2b0:	4725                	li	a4,9
 2b2:	02f76963          	bltu	a4,a5,2e4 <atoi+0x46>
 2b6:	862a                	mv	a2,a0
  n = 0;
 2b8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2ba:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2bc:	0605                	addi	a2,a2,1
 2be:	0025179b          	slliw	a5,a0,0x2
 2c2:	9fa9                	addw	a5,a5,a0
 2c4:	0017979b          	slliw	a5,a5,0x1
 2c8:	9fb5                	addw	a5,a5,a3
 2ca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ce:	00064683          	lbu	a3,0(a2)
 2d2:	fd06871b          	addiw	a4,a3,-48
 2d6:	0ff77713          	andi	a4,a4,255
 2da:	fee5f1e3          	bleu	a4,a1,2bc <atoi+0x1e>
  return n;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  n = 0;
 2e4:	4501                	li	a0,0
 2e6:	bfe5                	j	2de <atoi+0x40>

00000000000002e8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ee:	02b57663          	bleu	a1,a0,31a <memmove+0x32>
    while(n-- > 0)
 2f2:	02c05163          	blez	a2,314 <memmove+0x2c>
 2f6:	fff6079b          	addiw	a5,a2,-1
 2fa:	1782                	slli	a5,a5,0x20
 2fc:	9381                	srli	a5,a5,0x20
 2fe:	0785                	addi	a5,a5,1
 300:	97aa                	add	a5,a5,a0
  dst = vdst;
 302:	872a                	mv	a4,a0
      *dst++ = *src++;
 304:	0585                	addi	a1,a1,1
 306:	0705                	addi	a4,a4,1
 308:	fff5c683          	lbu	a3,-1(a1)
 30c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 310:	fee79ae3          	bne	a5,a4,304 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 314:	6422                	ld	s0,8(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret
    dst += n;
 31a:	00c50733          	add	a4,a0,a2
    src += n;
 31e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 320:	fec05ae3          	blez	a2,314 <memmove+0x2c>
 324:	fff6079b          	addiw	a5,a2,-1
 328:	1782                	slli	a5,a5,0x20
 32a:	9381                	srli	a5,a5,0x20
 32c:	fff7c793          	not	a5,a5
 330:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 332:	15fd                	addi	a1,a1,-1
 334:	177d                	addi	a4,a4,-1
 336:	0005c683          	lbu	a3,0(a1)
 33a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 33e:	fef71ae3          	bne	a4,a5,332 <memmove+0x4a>
 342:	bfc9                	j	314 <memmove+0x2c>

0000000000000344 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e422                	sd	s0,8(sp)
 348:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 34a:	ce15                	beqz	a2,386 <memcmp+0x42>
 34c:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 350:	00054783          	lbu	a5,0(a0)
 354:	0005c703          	lbu	a4,0(a1)
 358:	02e79063          	bne	a5,a4,378 <memcmp+0x34>
 35c:	1682                	slli	a3,a3,0x20
 35e:	9281                	srli	a3,a3,0x20
 360:	0685                	addi	a3,a3,1
 362:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 364:	0505                	addi	a0,a0,1
    p2++;
 366:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 368:	00d50d63          	beq	a0,a3,382 <memcmp+0x3e>
    if (*p1 != *p2) {
 36c:	00054783          	lbu	a5,0(a0)
 370:	0005c703          	lbu	a4,0(a1)
 374:	fee788e3          	beq	a5,a4,364 <memcmp+0x20>
      return *p1 - *p2;
 378:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret
  return 0;
 382:	4501                	li	a0,0
 384:	bfe5                	j	37c <memcmp+0x38>
 386:	4501                	li	a0,0
 388:	bfd5                	j	37c <memcmp+0x38>

000000000000038a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 392:	00000097          	auipc	ra,0x0
 396:	f56080e7          	jalr	-170(ra) # 2e8 <memmove>
}
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a2:	4885                	li	a7,1
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3aa:	4889                	li	a7,2
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b2:	488d                	li	a7,3
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ba:	4891                	li	a7,4
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <read>:
.global read
read:
 li a7, SYS_read
 3c2:	4895                	li	a7,5
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <write>:
.global write
write:
 li a7, SYS_write
 3ca:	48c1                	li	a7,16
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <close>:
.global close
close:
 li a7, SYS_close
 3d2:	48d5                	li	a7,21
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <kill>:
.global kill
kill:
 li a7, SYS_kill
 3da:	4899                	li	a7,6
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e2:	489d                	li	a7,7
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <open>:
.global open
open:
 li a7, SYS_open
 3ea:	48bd                	li	a7,15
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f2:	48c5                	li	a7,17
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fa:	48c9                	li	a7,18
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 402:	48a1                	li	a7,8
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <link>:
.global link
link:
 li a7, SYS_link
 40a:	48cd                	li	a7,19
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 412:	48d1                	li	a7,20
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41a:	48a5                	li	a7,9
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <dup>:
.global dup
dup:
 li a7, SYS_dup
 422:	48a9                	li	a7,10
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42a:	48ad                	li	a7,11
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 432:	48b1                	li	a7,12
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43a:	48b5                	li	a7,13
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 442:	48b9                	li	a7,14
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44a:	1101                	addi	sp,sp,-32
 44c:	ec06                	sd	ra,24(sp)
 44e:	e822                	sd	s0,16(sp)
 450:	1000                	addi	s0,sp,32
 452:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 456:	4605                	li	a2,1
 458:	fef40593          	addi	a1,s0,-17
 45c:	00000097          	auipc	ra,0x0
 460:	f6e080e7          	jalr	-146(ra) # 3ca <write>
}
 464:	60e2                	ld	ra,24(sp)
 466:	6442                	ld	s0,16(sp)
 468:	6105                	addi	sp,sp,32
 46a:	8082                	ret

000000000000046c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46c:	7139                	addi	sp,sp,-64
 46e:	fc06                	sd	ra,56(sp)
 470:	f822                	sd	s0,48(sp)
 472:	f426                	sd	s1,40(sp)
 474:	f04a                	sd	s2,32(sp)
 476:	ec4e                	sd	s3,24(sp)
 478:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47a:	c299                	beqz	a3,480 <printint+0x14>
 47c:	0005cd63          	bltz	a1,496 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 480:	2581                	sext.w	a1,a1
  neg = 0;
 482:	4301                	li	t1,0
 484:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 488:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 48a:	2601                	sext.w	a2,a2
 48c:	00000897          	auipc	a7,0x0
 490:	48488893          	addi	a7,a7,1156 # 910 <digits>
 494:	a801                	j	4a4 <printint+0x38>
    x = -xx;
 496:	40b005bb          	negw	a1,a1
 49a:	2581                	sext.w	a1,a1
    neg = 1;
 49c:	4305                	li	t1,1
    x = -xx;
 49e:	b7dd                	j	484 <printint+0x18>
  }while((x /= base) != 0);
 4a0:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 4a2:	8836                	mv	a6,a3
 4a4:	0018069b          	addiw	a3,a6,1
 4a8:	02c5f7bb          	remuw	a5,a1,a2
 4ac:	1782                	slli	a5,a5,0x20
 4ae:	9381                	srli	a5,a5,0x20
 4b0:	97c6                	add	a5,a5,a7
 4b2:	0007c783          	lbu	a5,0(a5)
 4b6:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 4ba:	0705                	addi	a4,a4,1
 4bc:	02c5d7bb          	divuw	a5,a1,a2
 4c0:	fec5f0e3          	bleu	a2,a1,4a0 <printint+0x34>
  if(neg)
 4c4:	00030b63          	beqz	t1,4da <printint+0x6e>
    buf[i++] = '-';
 4c8:	fd040793          	addi	a5,s0,-48
 4cc:	96be                	add	a3,a3,a5
 4ce:	02d00793          	li	a5,45
 4d2:	fef68823          	sb	a5,-16(a3)
 4d6:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 4da:	02d05963          	blez	a3,50c <printint+0xa0>
 4de:	89aa                	mv	s3,a0
 4e0:	fc040793          	addi	a5,s0,-64
 4e4:	00d784b3          	add	s1,a5,a3
 4e8:	fff78913          	addi	s2,a5,-1
 4ec:	9936                	add	s2,s2,a3
 4ee:	36fd                	addiw	a3,a3,-1
 4f0:	1682                	slli	a3,a3,0x20
 4f2:	9281                	srli	a3,a3,0x20
 4f4:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 4f8:	fff4c583          	lbu	a1,-1(s1)
 4fc:	854e                	mv	a0,s3
 4fe:	00000097          	auipc	ra,0x0
 502:	f4c080e7          	jalr	-180(ra) # 44a <putc>
  while(--i >= 0)
 506:	14fd                	addi	s1,s1,-1
 508:	ff2498e3          	bne	s1,s2,4f8 <printint+0x8c>
}
 50c:	70e2                	ld	ra,56(sp)
 50e:	7442                	ld	s0,48(sp)
 510:	74a2                	ld	s1,40(sp)
 512:	7902                	ld	s2,32(sp)
 514:	69e2                	ld	s3,24(sp)
 516:	6121                	addi	sp,sp,64
 518:	8082                	ret

000000000000051a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51a:	7119                	addi	sp,sp,-128
 51c:	fc86                	sd	ra,120(sp)
 51e:	f8a2                	sd	s0,112(sp)
 520:	f4a6                	sd	s1,104(sp)
 522:	f0ca                	sd	s2,96(sp)
 524:	ecce                	sd	s3,88(sp)
 526:	e8d2                	sd	s4,80(sp)
 528:	e4d6                	sd	s5,72(sp)
 52a:	e0da                	sd	s6,64(sp)
 52c:	fc5e                	sd	s7,56(sp)
 52e:	f862                	sd	s8,48(sp)
 530:	f466                	sd	s9,40(sp)
 532:	f06a                	sd	s10,32(sp)
 534:	ec6e                	sd	s11,24(sp)
 536:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 538:	0005c483          	lbu	s1,0(a1)
 53c:	18048d63          	beqz	s1,6d6 <vprintf+0x1bc>
 540:	8aaa                	mv	s5,a0
 542:	8b32                	mv	s6,a2
 544:	00158913          	addi	s2,a1,1
  state = 0;
 548:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 54a:	02500a13          	li	s4,37
      if(c == 'd'){
 54e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 552:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 556:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 55a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55e:	00000b97          	auipc	s7,0x0
 562:	3b2b8b93          	addi	s7,s7,946 # 910 <digits>
 566:	a839                	j	584 <vprintf+0x6a>
        putc(fd, c);
 568:	85a6                	mv	a1,s1
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	ede080e7          	jalr	-290(ra) # 44a <putc>
 574:	a019                	j	57a <vprintf+0x60>
    } else if(state == '%'){
 576:	01498f63          	beq	s3,s4,594 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 57a:	0905                	addi	s2,s2,1
 57c:	fff94483          	lbu	s1,-1(s2)
 580:	14048b63          	beqz	s1,6d6 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 584:	0004879b          	sext.w	a5,s1
    if(state == 0){
 588:	fe0997e3          	bnez	s3,576 <vprintf+0x5c>
      if(c == '%'){
 58c:	fd479ee3          	bne	a5,s4,568 <vprintf+0x4e>
        state = '%';
 590:	89be                	mv	s3,a5
 592:	b7e5                	j	57a <vprintf+0x60>
      if(c == 'd'){
 594:	05878063          	beq	a5,s8,5d4 <vprintf+0xba>
      } else if(c == 'l') {
 598:	05978c63          	beq	a5,s9,5f0 <vprintf+0xd6>
      } else if(c == 'x') {
 59c:	07a78863          	beq	a5,s10,60c <vprintf+0xf2>
      } else if(c == 'p') {
 5a0:	09b78463          	beq	a5,s11,628 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5a4:	07300713          	li	a4,115
 5a8:	0ce78563          	beq	a5,a4,672 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ac:	06300713          	li	a4,99
 5b0:	0ee78c63          	beq	a5,a4,6a8 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5b4:	11478663          	beq	a5,s4,6c0 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b8:	85d2                	mv	a1,s4
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	e8e080e7          	jalr	-370(ra) # 44a <putc>
        putc(fd, c);
 5c4:	85a6                	mv	a1,s1
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e82080e7          	jalr	-382(ra) # 44a <putc>
      }
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b765                	j	57a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5d4:	008b0493          	addi	s1,s6,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000b2583          	lw	a1,0(s6)
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e8a080e7          	jalr	-374(ra) # 46c <printint>
 5ea:	8b26                	mv	s6,s1
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b771                	j	57a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f0:	008b0493          	addi	s1,s6,8
 5f4:	4681                	li	a3,0
 5f6:	4629                	li	a2,10
 5f8:	000b2583          	lw	a1,0(s6)
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	e6e080e7          	jalr	-402(ra) # 46c <printint>
 606:	8b26                	mv	s6,s1
      state = 0;
 608:	4981                	li	s3,0
 60a:	bf85                	j	57a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 60c:	008b0493          	addi	s1,s6,8
 610:	4681                	li	a3,0
 612:	4641                	li	a2,16
 614:	000b2583          	lw	a1,0(s6)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e52080e7          	jalr	-430(ra) # 46c <printint>
 622:	8b26                	mv	s6,s1
      state = 0;
 624:	4981                	li	s3,0
 626:	bf91                	j	57a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 628:	008b0793          	addi	a5,s6,8
 62c:	f8f43423          	sd	a5,-120(s0)
 630:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 634:	03000593          	li	a1,48
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e10080e7          	jalr	-496(ra) # 44a <putc>
  putc(fd, 'x');
 642:	85ea                	mv	a1,s10
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e04080e7          	jalr	-508(ra) # 44a <putc>
 64e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 650:	03c9d793          	srli	a5,s3,0x3c
 654:	97de                	add	a5,a5,s7
 656:	0007c583          	lbu	a1,0(a5)
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	dee080e7          	jalr	-530(ra) # 44a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 664:	0992                	slli	s3,s3,0x4
 666:	34fd                	addiw	s1,s1,-1
 668:	f4e5                	bnez	s1,650 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 66a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 66e:	4981                	li	s3,0
 670:	b729                	j	57a <vprintf+0x60>
        s = va_arg(ap, char*);
 672:	008b0993          	addi	s3,s6,8
 676:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 67a:	c085                	beqz	s1,69a <vprintf+0x180>
        while(*s != 0){
 67c:	0004c583          	lbu	a1,0(s1)
 680:	c9a1                	beqz	a1,6d0 <vprintf+0x1b6>
          putc(fd, *s);
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	dc6080e7          	jalr	-570(ra) # 44a <putc>
          s++;
 68c:	0485                	addi	s1,s1,1
        while(*s != 0){
 68e:	0004c583          	lbu	a1,0(s1)
 692:	f9e5                	bnez	a1,682 <vprintf+0x168>
        s = va_arg(ap, char*);
 694:	8b4e                	mv	s6,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	b5cd                	j	57a <vprintf+0x60>
          s = "(null)";
 69a:	00000497          	auipc	s1,0x0
 69e:	28e48493          	addi	s1,s1,654 # 928 <digits+0x18>
        while(*s != 0){
 6a2:	02800593          	li	a1,40
 6a6:	bff1                	j	682 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 6a8:	008b0493          	addi	s1,s6,8
 6ac:	000b4583          	lbu	a1,0(s6)
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	d98080e7          	jalr	-616(ra) # 44a <putc>
 6ba:	8b26                	mv	s6,s1
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bd75                	j	57a <vprintf+0x60>
        putc(fd, c);
 6c0:	85d2                	mv	a1,s4
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	d86080e7          	jalr	-634(ra) # 44a <putc>
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b575                	j	57a <vprintf+0x60>
        s = va_arg(ap, char*);
 6d0:	8b4e                	mv	s6,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b55d                	j	57a <vprintf+0x60>
    }
  }
}
 6d6:	70e6                	ld	ra,120(sp)
 6d8:	7446                	ld	s0,112(sp)
 6da:	74a6                	ld	s1,104(sp)
 6dc:	7906                	ld	s2,96(sp)
 6de:	69e6                	ld	s3,88(sp)
 6e0:	6a46                	ld	s4,80(sp)
 6e2:	6aa6                	ld	s5,72(sp)
 6e4:	6b06                	ld	s6,64(sp)
 6e6:	7be2                	ld	s7,56(sp)
 6e8:	7c42                	ld	s8,48(sp)
 6ea:	7ca2                	ld	s9,40(sp)
 6ec:	7d02                	ld	s10,32(sp)
 6ee:	6de2                	ld	s11,24(sp)
 6f0:	6109                	addi	sp,sp,128
 6f2:	8082                	ret

00000000000006f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f4:	715d                	addi	sp,sp,-80
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	addi	s0,sp,32
 6fc:	e010                	sd	a2,0(s0)
 6fe:	e414                	sd	a3,8(s0)
 700:	e818                	sd	a4,16(s0)
 702:	ec1c                	sd	a5,24(s0)
 704:	03043023          	sd	a6,32(s0)
 708:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 70c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 710:	8622                	mv	a2,s0
 712:	00000097          	auipc	ra,0x0
 716:	e08080e7          	jalr	-504(ra) # 51a <vprintf>
}
 71a:	60e2                	ld	ra,24(sp)
 71c:	6442                	ld	s0,16(sp)
 71e:	6161                	addi	sp,sp,80
 720:	8082                	ret

0000000000000722 <printf>:

void
printf(const char *fmt, ...)
{
 722:	711d                	addi	sp,sp,-96
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	1000                	addi	s0,sp,32
 72a:	e40c                	sd	a1,8(s0)
 72c:	e810                	sd	a2,16(s0)
 72e:	ec14                	sd	a3,24(s0)
 730:	f018                	sd	a4,32(s0)
 732:	f41c                	sd	a5,40(s0)
 734:	03043823          	sd	a6,48(s0)
 738:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 73c:	00840613          	addi	a2,s0,8
 740:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 744:	85aa                	mv	a1,a0
 746:	4505                	li	a0,1
 748:	00000097          	auipc	ra,0x0
 74c:	dd2080e7          	jalr	-558(ra) # 51a <vprintf>
}
 750:	60e2                	ld	ra,24(sp)
 752:	6442                	ld	s0,16(sp)
 754:	6125                	addi	sp,sp,96
 756:	8082                	ret

0000000000000758 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 758:	1141                	addi	sp,sp,-16
 75a:	e422                	sd	s0,8(sp)
 75c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 762:	00000797          	auipc	a5,0x0
 766:	1ce78793          	addi	a5,a5,462 # 930 <__bss_start>
 76a:	639c                	ld	a5,0(a5)
 76c:	a805                	j	79c <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 76e:	4618                	lw	a4,8(a2)
 770:	9db9                	addw	a1,a1,a4
 772:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 776:	6398                	ld	a4,0(a5)
 778:	6318                	ld	a4,0(a4)
 77a:	fee53823          	sd	a4,-16(a0)
 77e:	a091                	j	7c2 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 780:	ff852703          	lw	a4,-8(a0)
 784:	9e39                	addw	a2,a2,a4
 786:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 788:	ff053703          	ld	a4,-16(a0)
 78c:	e398                	sd	a4,0(a5)
 78e:	a099                	j	7d4 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	6398                	ld	a4,0(a5)
 792:	00e7e463          	bltu	a5,a4,79a <free+0x42>
 796:	00e6ea63          	bltu	a3,a4,7aa <free+0x52>
{
 79a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79c:	fed7fae3          	bleu	a3,a5,790 <free+0x38>
 7a0:	6398                	ld	a4,0(a5)
 7a2:	00e6e463          	bltu	a3,a4,7aa <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a6:	fee7eae3          	bltu	a5,a4,79a <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 7aa:	ff852583          	lw	a1,-8(a0)
 7ae:	6390                	ld	a2,0(a5)
 7b0:	02059713          	slli	a4,a1,0x20
 7b4:	9301                	srli	a4,a4,0x20
 7b6:	0712                	slli	a4,a4,0x4
 7b8:	9736                	add	a4,a4,a3
 7ba:	fae60ae3          	beq	a2,a4,76e <free+0x16>
    bp->s.ptr = p->s.ptr;
 7be:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c2:	4790                	lw	a2,8(a5)
 7c4:	02061713          	slli	a4,a2,0x20
 7c8:	9301                	srli	a4,a4,0x20
 7ca:	0712                	slli	a4,a4,0x4
 7cc:	973e                	add	a4,a4,a5
 7ce:	fae689e3          	beq	a3,a4,780 <free+0x28>
  } else
    p->s.ptr = bp;
 7d2:	e394                	sd	a3,0(a5)
  freep = p;
 7d4:	00000717          	auipc	a4,0x0
 7d8:	14f73e23          	sd	a5,348(a4) # 930 <__bss_start>
}
 7dc:	6422                	ld	s0,8(sp)
 7de:	0141                	addi	sp,sp,16
 7e0:	8082                	ret

00000000000007e2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e2:	7139                	addi	sp,sp,-64
 7e4:	fc06                	sd	ra,56(sp)
 7e6:	f822                	sd	s0,48(sp)
 7e8:	f426                	sd	s1,40(sp)
 7ea:	f04a                	sd	s2,32(sp)
 7ec:	ec4e                	sd	s3,24(sp)
 7ee:	e852                	sd	s4,16(sp)
 7f0:	e456                	sd	s5,8(sp)
 7f2:	e05a                	sd	s6,0(sp)
 7f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f6:	02051993          	slli	s3,a0,0x20
 7fa:	0209d993          	srli	s3,s3,0x20
 7fe:	09bd                	addi	s3,s3,15
 800:	0049d993          	srli	s3,s3,0x4
 804:	2985                	addiw	s3,s3,1
 806:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 80a:	00000797          	auipc	a5,0x0
 80e:	12678793          	addi	a5,a5,294 # 930 <__bss_start>
 812:	6388                	ld	a0,0(a5)
 814:	c515                	beqz	a0,840 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 816:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 818:	4798                	lw	a4,8(a5)
 81a:	03277f63          	bleu	s2,a4,858 <malloc+0x76>
 81e:	8a4e                	mv	s4,s3
 820:	0009871b          	sext.w	a4,s3
 824:	6685                	lui	a3,0x1
 826:	00d77363          	bleu	a3,a4,82c <malloc+0x4a>
 82a:	6a05                	lui	s4,0x1
 82c:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 830:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 834:	00000497          	auipc	s1,0x0
 838:	0fc48493          	addi	s1,s1,252 # 930 <__bss_start>
  if(p == (char*)-1)
 83c:	5b7d                	li	s6,-1
 83e:	a885                	j	8ae <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 840:	00000797          	auipc	a5,0x0
 844:	2f878793          	addi	a5,a5,760 # b38 <base>
 848:	00000717          	auipc	a4,0x0
 84c:	0ef73423          	sd	a5,232(a4) # 930 <__bss_start>
 850:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 852:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 856:	b7e1                	j	81e <malloc+0x3c>
      if(p->s.size == nunits)
 858:	02e90b63          	beq	s2,a4,88e <malloc+0xac>
        p->s.size -= nunits;
 85c:	4137073b          	subw	a4,a4,s3
 860:	c798                	sw	a4,8(a5)
        p += p->s.size;
 862:	1702                	slli	a4,a4,0x20
 864:	9301                	srli	a4,a4,0x20
 866:	0712                	slli	a4,a4,0x4
 868:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 86e:	00000717          	auipc	a4,0x0
 872:	0ca73123          	sd	a0,194(a4) # 930 <__bss_start>
      return (void*)(p + 1);
 876:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 87a:	70e2                	ld	ra,56(sp)
 87c:	7442                	ld	s0,48(sp)
 87e:	74a2                	ld	s1,40(sp)
 880:	7902                	ld	s2,32(sp)
 882:	69e2                	ld	s3,24(sp)
 884:	6a42                	ld	s4,16(sp)
 886:	6aa2                	ld	s5,8(sp)
 888:	6b02                	ld	s6,0(sp)
 88a:	6121                	addi	sp,sp,64
 88c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 88e:	6398                	ld	a4,0(a5)
 890:	e118                	sd	a4,0(a0)
 892:	bff1                	j	86e <malloc+0x8c>
  hp->s.size = nu;
 894:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 898:	0541                	addi	a0,a0,16
 89a:	00000097          	auipc	ra,0x0
 89e:	ebe080e7          	jalr	-322(ra) # 758 <free>
  return freep;
 8a2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8a4:	d979                	beqz	a0,87a <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a8:	4798                	lw	a4,8(a5)
 8aa:	fb2777e3          	bleu	s2,a4,858 <malloc+0x76>
    if(p == freep)
 8ae:	6098                	ld	a4,0(s1)
 8b0:	853e                	mv	a0,a5
 8b2:	fef71ae3          	bne	a4,a5,8a6 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 8b6:	8552                	mv	a0,s4
 8b8:	00000097          	auipc	ra,0x0
 8bc:	b7a080e7          	jalr	-1158(ra) # 432 <sbrk>
  if(p == (char*)-1)
 8c0:	fd651ae3          	bne	a0,s6,894 <malloc+0xb2>
        return 0;
 8c4:	4501                	li	a0,0
 8c6:	bf55                	j	87a <malloc+0x98>
