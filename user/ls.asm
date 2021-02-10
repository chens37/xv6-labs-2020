
user/_ls：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	31c080e7          	jalr	796(ra) # 32c <strlen>
  18:	1502                	slli	a0,a0,0x20
  1a:	9101                	srli	a0,a0,0x20
  1c:	9526                	add	a0,a0,s1
  1e:	02956163          	bltu	a0,s1,40 <fmtname+0x40>
  22:	00054703          	lbu	a4,0(a0)
  26:	02f00793          	li	a5,47
  2a:	00f70b63          	beq	a4,a5,40 <fmtname+0x40>
  2e:	02f00713          	li	a4,47
  32:	157d                	addi	a0,a0,-1
  34:	00956663          	bltu	a0,s1,40 <fmtname+0x40>
  38:	00054783          	lbu	a5,0(a0)
  3c:	fee79be3          	bne	a5,a4,32 <fmtname+0x32>
    ;
  p++;
  40:	00150493          	addi	s1,a0,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  44:	8526                	mv	a0,s1
  46:	00000097          	auipc	ra,0x0
  4a:	2e6080e7          	jalr	742(ra) # 32c <strlen>
  4e:	2501                	sext.w	a0,a0
  50:	47b5                	li	a5,13
  52:	00a7fa63          	bleu	a0,a5,66 <fmtname+0x66>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  56:	8526                	mv	a0,s1
  58:	70a2                	ld	ra,40(sp)
  5a:	7402                	ld	s0,32(sp)
  5c:	64e2                	ld	s1,24(sp)
  5e:	6942                	ld	s2,16(sp)
  60:	69a2                	ld	s3,8(sp)
  62:	6145                	addi	sp,sp,48
  64:	8082                	ret
  memmove(buf, p, strlen(p));
  66:	8526                	mv	a0,s1
  68:	00000097          	auipc	ra,0x0
  6c:	2c4080e7          	jalr	708(ra) # 32c <strlen>
  70:	00001917          	auipc	s2,0x1
  74:	ab890913          	addi	s2,s2,-1352 # b28 <buf.1127>
  78:	0005061b          	sext.w	a2,a0
  7c:	85a6                	mv	a1,s1
  7e:	854a                	mv	a0,s2
  80:	00000097          	auipc	ra,0x0
  84:	42a080e7          	jalr	1066(ra) # 4aa <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	2a2080e7          	jalr	674(ra) # 32c <strlen>
  92:	0005099b          	sext.w	s3,a0
  96:	8526                	mv	a0,s1
  98:	00000097          	auipc	ra,0x0
  9c:	294080e7          	jalr	660(ra) # 32c <strlen>
  a0:	1982                	slli	s3,s3,0x20
  a2:	0209d993          	srli	s3,s3,0x20
  a6:	4639                	li	a2,14
  a8:	9e09                	subw	a2,a2,a0
  aa:	02000593          	li	a1,32
  ae:	01390533          	add	a0,s2,s3
  b2:	00000097          	auipc	ra,0x0
  b6:	2a4080e7          	jalr	676(ra) # 356 <memset>
  return buf;
  ba:	84ca                	mv	s1,s2
  bc:	bf69                	j	56 <fmtname+0x56>

00000000000000be <ls>:

void
ls(char *path)
{
  be:	d9010113          	addi	sp,sp,-624
  c2:	26113423          	sd	ra,616(sp)
  c6:	26813023          	sd	s0,608(sp)
  ca:	24913c23          	sd	s1,600(sp)
  ce:	25213823          	sd	s2,592(sp)
  d2:	25313423          	sd	s3,584(sp)
  d6:	25413023          	sd	s4,576(sp)
  da:	23513c23          	sd	s5,568(sp)
  de:	1c80                	addi	s0,sp,624
  e0:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  e2:	4581                	li	a1,0
  e4:	00000097          	auipc	ra,0x0
  e8:	4c8080e7          	jalr	1224(ra) # 5ac <open>
  ec:	06054f63          	bltz	a0,16a <ls+0xac>
  f0:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  f2:	d9840593          	addi	a1,s0,-616
  f6:	00000097          	auipc	ra,0x0
  fa:	4ce080e7          	jalr	1230(ra) # 5c4 <fstat>
  fe:	08054163          	bltz	a0,180 <ls+0xc2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 102:	da041783          	lh	a5,-608(s0)
 106:	0007869b          	sext.w	a3,a5
 10a:	4705                	li	a4,1
 10c:	08e68a63          	beq	a3,a4,1a0 <ls+0xe2>
 110:	4709                	li	a4,2
 112:	02e69663          	bne	a3,a4,13e <ls+0x80>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 116:	854a                	mv	a0,s2
 118:	00000097          	auipc	ra,0x0
 11c:	ee8080e7          	jalr	-280(ra) # 0 <fmtname>
 120:	da843703          	ld	a4,-600(s0)
 124:	d9c42683          	lw	a3,-612(s0)
 128:	da041603          	lh	a2,-608(s0)
 12c:	85aa                	mv	a1,a0
 12e:	00001517          	auipc	a0,0x1
 132:	99250513          	addi	a0,a0,-1646 # ac0 <malloc+0x11c>
 136:	00000097          	auipc	ra,0x0
 13a:	7ae080e7          	jalr	1966(ra) # 8e4 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 13e:	8526                	mv	a0,s1
 140:	00000097          	auipc	ra,0x0
 144:	454080e7          	jalr	1108(ra) # 594 <close>
}
 148:	26813083          	ld	ra,616(sp)
 14c:	26013403          	ld	s0,608(sp)
 150:	25813483          	ld	s1,600(sp)
 154:	25013903          	ld	s2,592(sp)
 158:	24813983          	ld	s3,584(sp)
 15c:	24013a03          	ld	s4,576(sp)
 160:	23813a83          	ld	s5,568(sp)
 164:	27010113          	addi	sp,sp,624
 168:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 16a:	864a                	mv	a2,s2
 16c:	00001597          	auipc	a1,0x1
 170:	92458593          	addi	a1,a1,-1756 # a90 <malloc+0xec>
 174:	4509                	li	a0,2
 176:	00000097          	auipc	ra,0x0
 17a:	740080e7          	jalr	1856(ra) # 8b6 <fprintf>
    return;
 17e:	b7e9                	j	148 <ls+0x8a>
    fprintf(2, "ls: cannot stat %s\n", path);
 180:	864a                	mv	a2,s2
 182:	00001597          	auipc	a1,0x1
 186:	92658593          	addi	a1,a1,-1754 # aa8 <malloc+0x104>
 18a:	4509                	li	a0,2
 18c:	00000097          	auipc	ra,0x0
 190:	72a080e7          	jalr	1834(ra) # 8b6 <fprintf>
    close(fd);
 194:	8526                	mv	a0,s1
 196:	00000097          	auipc	ra,0x0
 19a:	3fe080e7          	jalr	1022(ra) # 594 <close>
    return;
 19e:	b76d                	j	148 <ls+0x8a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1a0:	854a                	mv	a0,s2
 1a2:	00000097          	auipc	ra,0x0
 1a6:	18a080e7          	jalr	394(ra) # 32c <strlen>
 1aa:	2541                	addiw	a0,a0,16
 1ac:	20000793          	li	a5,512
 1b0:	00a7fb63          	bleu	a0,a5,1c6 <ls+0x108>
      printf("ls: path too long\n");
 1b4:	00001517          	auipc	a0,0x1
 1b8:	91c50513          	addi	a0,a0,-1764 # ad0 <malloc+0x12c>
 1bc:	00000097          	auipc	ra,0x0
 1c0:	728080e7          	jalr	1832(ra) # 8e4 <printf>
      break;
 1c4:	bfad                	j	13e <ls+0x80>
    strcpy(buf, path);
 1c6:	85ca                	mv	a1,s2
 1c8:	dc040513          	addi	a0,s0,-576
 1cc:	00000097          	auipc	ra,0x0
 1d0:	110080e7          	jalr	272(ra) # 2dc <strcpy>
    p = buf+strlen(buf);
 1d4:	dc040513          	addi	a0,s0,-576
 1d8:	00000097          	auipc	ra,0x0
 1dc:	154080e7          	jalr	340(ra) # 32c <strlen>
 1e0:	1502                	slli	a0,a0,0x20
 1e2:	9101                	srli	a0,a0,0x20
 1e4:	dc040793          	addi	a5,s0,-576
 1e8:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1ec:	00190993          	addi	s3,s2,1
 1f0:	02f00793          	li	a5,47
 1f4:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f8:	00001a17          	auipc	s4,0x1
 1fc:	8f0a0a13          	addi	s4,s4,-1808 # ae8 <malloc+0x144>
        printf("ls: cannot stat %s\n", buf);
 200:	00001a97          	auipc	s5,0x1
 204:	8a8a8a93          	addi	s5,s5,-1880 # aa8 <malloc+0x104>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 208:	a01d                	j	22e <ls+0x170>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 20a:	dc040513          	addi	a0,s0,-576
 20e:	00000097          	auipc	ra,0x0
 212:	df2080e7          	jalr	-526(ra) # 0 <fmtname>
 216:	da843703          	ld	a4,-600(s0)
 21a:	d9c42683          	lw	a3,-612(s0)
 21e:	da041603          	lh	a2,-608(s0)
 222:	85aa                	mv	a1,a0
 224:	8552                	mv	a0,s4
 226:	00000097          	auipc	ra,0x0
 22a:	6be080e7          	jalr	1726(ra) # 8e4 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 22e:	4641                	li	a2,16
 230:	db040593          	addi	a1,s0,-592
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	34e080e7          	jalr	846(ra) # 584 <read>
 23e:	47c1                	li	a5,16
 240:	eef51fe3          	bne	a0,a5,13e <ls+0x80>
      if(de.inum == 0)
 244:	db045783          	lhu	a5,-592(s0)
 248:	d3fd                	beqz	a5,22e <ls+0x170>
      memmove(p, de.name, DIRSIZ);
 24a:	4639                	li	a2,14
 24c:	db240593          	addi	a1,s0,-590
 250:	854e                	mv	a0,s3
 252:	00000097          	auipc	ra,0x0
 256:	258080e7          	jalr	600(ra) # 4aa <memmove>
      p[DIRSIZ] = 0;
 25a:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 25e:	d9840593          	addi	a1,s0,-616
 262:	dc040513          	addi	a0,s0,-576
 266:	00000097          	auipc	ra,0x0
 26a:	1b4080e7          	jalr	436(ra) # 41a <stat>
 26e:	f8055ee3          	bgez	a0,20a <ls+0x14c>
        printf("ls: cannot stat %s\n", buf);
 272:	dc040593          	addi	a1,s0,-576
 276:	8556                	mv	a0,s5
 278:	00000097          	auipc	ra,0x0
 27c:	66c080e7          	jalr	1644(ra) # 8e4 <printf>
        continue;
 280:	b77d                	j	22e <ls+0x170>

0000000000000282 <main>:

int
main(int argc, char *argv[])
{
 282:	1101                	addi	sp,sp,-32
 284:	ec06                	sd	ra,24(sp)
 286:	e822                	sd	s0,16(sp)
 288:	e426                	sd	s1,8(sp)
 28a:	e04a                	sd	s2,0(sp)
 28c:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 28e:	4785                	li	a5,1
 290:	02a7d963          	ble	a0,a5,2c2 <main+0x40>
 294:	00858493          	addi	s1,a1,8
 298:	ffe5091b          	addiw	s2,a0,-2
 29c:	1902                	slli	s2,s2,0x20
 29e:	02095913          	srli	s2,s2,0x20
 2a2:	090e                	slli	s2,s2,0x3
 2a4:	05c1                	addi	a1,a1,16
 2a6:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a8:	6088                	ld	a0,0(s1)
 2aa:	00000097          	auipc	ra,0x0
 2ae:	e14080e7          	jalr	-492(ra) # be <ls>
  for(i=1; i<argc; i++)
 2b2:	04a1                	addi	s1,s1,8
 2b4:	ff249ae3          	bne	s1,s2,2a8 <main+0x26>
  exit(0);
 2b8:	4501                	li	a0,0
 2ba:	00000097          	auipc	ra,0x0
 2be:	2b2080e7          	jalr	690(ra) # 56c <exit>
    ls(".");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	83650513          	addi	a0,a0,-1994 # af8 <malloc+0x154>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	df4080e7          	jalr	-524(ra) # be <ls>
    exit(0);
 2d2:	4501                	li	a0,0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	298080e7          	jalr	664(ra) # 56c <exit>

00000000000002dc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e2:	87aa                	mv	a5,a0
 2e4:	0585                	addi	a1,a1,1
 2e6:	0785                	addi	a5,a5,1
 2e8:	fff5c703          	lbu	a4,-1(a1)
 2ec:	fee78fa3          	sb	a4,-1(a5)
 2f0:	fb75                	bnez	a4,2e4 <strcpy+0x8>
    ;
  return os;
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2fe:	00054783          	lbu	a5,0(a0)
 302:	cf91                	beqz	a5,31e <strcmp+0x26>
 304:	0005c703          	lbu	a4,0(a1)
 308:	00f71b63          	bne	a4,a5,31e <strcmp+0x26>
    p++, q++;
 30c:	0505                	addi	a0,a0,1
 30e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 310:	00054783          	lbu	a5,0(a0)
 314:	c789                	beqz	a5,31e <strcmp+0x26>
 316:	0005c703          	lbu	a4,0(a1)
 31a:	fef709e3          	beq	a4,a5,30c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 31e:	0005c503          	lbu	a0,0(a1)
}
 322:	40a7853b          	subw	a0,a5,a0
 326:	6422                	ld	s0,8(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret

000000000000032c <strlen>:

uint
strlen(const char *s)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e422                	sd	s0,8(sp)
 330:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 332:	00054783          	lbu	a5,0(a0)
 336:	cf91                	beqz	a5,352 <strlen+0x26>
 338:	0505                	addi	a0,a0,1
 33a:	87aa                	mv	a5,a0
 33c:	4685                	li	a3,1
 33e:	9e89                	subw	a3,a3,a0
 340:	00f6853b          	addw	a0,a3,a5
 344:	0785                	addi	a5,a5,1
 346:	fff7c703          	lbu	a4,-1(a5)
 34a:	fb7d                	bnez	a4,340 <strlen+0x14>
    ;
  return n;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  for(n = 0; s[n]; n++)
 352:	4501                	li	a0,0
 354:	bfe5                	j	34c <strlen+0x20>

0000000000000356 <memset>:

void*
memset(void *dst, int c, uint n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 35c:	ce09                	beqz	a2,376 <memset+0x20>
 35e:	87aa                	mv	a5,a0
 360:	fff6071b          	addiw	a4,a2,-1
 364:	1702                	slli	a4,a4,0x20
 366:	9301                	srli	a4,a4,0x20
 368:	0705                	addi	a4,a4,1
 36a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 36c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 370:	0785                	addi	a5,a5,1
 372:	fee79de3          	bne	a5,a4,36c <memset+0x16>
  }
  return dst;
}
 376:	6422                	ld	s0,8(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <strchr>:

char*
strchr(const char *s, char c)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e422                	sd	s0,8(sp)
 380:	0800                	addi	s0,sp,16
  for(; *s; s++)
 382:	00054783          	lbu	a5,0(a0)
 386:	cf91                	beqz	a5,3a2 <strchr+0x26>
    if(*s == c)
 388:	00f58a63          	beq	a1,a5,39c <strchr+0x20>
  for(; *s; s++)
 38c:	0505                	addi	a0,a0,1
 38e:	00054783          	lbu	a5,0(a0)
 392:	c781                	beqz	a5,39a <strchr+0x1e>
    if(*s == c)
 394:	feb79ce3          	bne	a5,a1,38c <strchr+0x10>
 398:	a011                	j	39c <strchr+0x20>
      return (char*)s;
  return 0;
 39a:	4501                	li	a0,0
}
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
  return 0;
 3a2:	4501                	li	a0,0
 3a4:	bfe5                	j	39c <strchr+0x20>

00000000000003a6 <gets>:

char*
gets(char *buf, int max)
{
 3a6:	711d                	addi	sp,sp,-96
 3a8:	ec86                	sd	ra,88(sp)
 3aa:	e8a2                	sd	s0,80(sp)
 3ac:	e4a6                	sd	s1,72(sp)
 3ae:	e0ca                	sd	s2,64(sp)
 3b0:	fc4e                	sd	s3,56(sp)
 3b2:	f852                	sd	s4,48(sp)
 3b4:	f456                	sd	s5,40(sp)
 3b6:	f05a                	sd	s6,32(sp)
 3b8:	ec5e                	sd	s7,24(sp)
 3ba:	1080                	addi	s0,sp,96
 3bc:	8baa                	mv	s7,a0
 3be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c0:	892a                	mv	s2,a0
 3c2:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3c4:	4aa9                	li	s5,10
 3c6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3c8:	0019849b          	addiw	s1,s3,1
 3cc:	0344d863          	ble	s4,s1,3fc <gets+0x56>
    cc = read(0, &c, 1);
 3d0:	4605                	li	a2,1
 3d2:	faf40593          	addi	a1,s0,-81
 3d6:	4501                	li	a0,0
 3d8:	00000097          	auipc	ra,0x0
 3dc:	1ac080e7          	jalr	428(ra) # 584 <read>
    if(cc < 1)
 3e0:	00a05e63          	blez	a0,3fc <gets+0x56>
    buf[i++] = c;
 3e4:	faf44783          	lbu	a5,-81(s0)
 3e8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3ec:	01578763          	beq	a5,s5,3fa <gets+0x54>
 3f0:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
 3f2:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
 3f4:	fd679ae3          	bne	a5,s6,3c8 <gets+0x22>
 3f8:	a011                	j	3fc <gets+0x56>
  for(i=0; i+1 < max; ){
 3fa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3fc:	99de                	add	s3,s3,s7
 3fe:	00098023          	sb	zero,0(s3)
  return buf;
}
 402:	855e                	mv	a0,s7
 404:	60e6                	ld	ra,88(sp)
 406:	6446                	ld	s0,80(sp)
 408:	64a6                	ld	s1,72(sp)
 40a:	6906                	ld	s2,64(sp)
 40c:	79e2                	ld	s3,56(sp)
 40e:	7a42                	ld	s4,48(sp)
 410:	7aa2                	ld	s5,40(sp)
 412:	7b02                	ld	s6,32(sp)
 414:	6be2                	ld	s7,24(sp)
 416:	6125                	addi	sp,sp,96
 418:	8082                	ret

000000000000041a <stat>:

int
stat(const char *n, struct stat *st)
{
 41a:	1101                	addi	sp,sp,-32
 41c:	ec06                	sd	ra,24(sp)
 41e:	e822                	sd	s0,16(sp)
 420:	e426                	sd	s1,8(sp)
 422:	e04a                	sd	s2,0(sp)
 424:	1000                	addi	s0,sp,32
 426:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 428:	4581                	li	a1,0
 42a:	00000097          	auipc	ra,0x0
 42e:	182080e7          	jalr	386(ra) # 5ac <open>
  if(fd < 0)
 432:	02054563          	bltz	a0,45c <stat+0x42>
 436:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 438:	85ca                	mv	a1,s2
 43a:	00000097          	auipc	ra,0x0
 43e:	18a080e7          	jalr	394(ra) # 5c4 <fstat>
 442:	892a                	mv	s2,a0
  close(fd);
 444:	8526                	mv	a0,s1
 446:	00000097          	auipc	ra,0x0
 44a:	14e080e7          	jalr	334(ra) # 594 <close>
  return r;
}
 44e:	854a                	mv	a0,s2
 450:	60e2                	ld	ra,24(sp)
 452:	6442                	ld	s0,16(sp)
 454:	64a2                	ld	s1,8(sp)
 456:	6902                	ld	s2,0(sp)
 458:	6105                	addi	sp,sp,32
 45a:	8082                	ret
    return -1;
 45c:	597d                	li	s2,-1
 45e:	bfc5                	j	44e <stat+0x34>

0000000000000460 <atoi>:

int
atoi(const char *s)
{
 460:	1141                	addi	sp,sp,-16
 462:	e422                	sd	s0,8(sp)
 464:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 466:	00054683          	lbu	a3,0(a0)
 46a:	fd06879b          	addiw	a5,a3,-48
 46e:	0ff7f793          	andi	a5,a5,255
 472:	4725                	li	a4,9
 474:	02f76963          	bltu	a4,a5,4a6 <atoi+0x46>
 478:	862a                	mv	a2,a0
  n = 0;
 47a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 47c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 47e:	0605                	addi	a2,a2,1
 480:	0025179b          	slliw	a5,a0,0x2
 484:	9fa9                	addw	a5,a5,a0
 486:	0017979b          	slliw	a5,a5,0x1
 48a:	9fb5                	addw	a5,a5,a3
 48c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 490:	00064683          	lbu	a3,0(a2)
 494:	fd06871b          	addiw	a4,a3,-48
 498:	0ff77713          	andi	a4,a4,255
 49c:	fee5f1e3          	bleu	a4,a1,47e <atoi+0x1e>
  return n;
}
 4a0:	6422                	ld	s0,8(sp)
 4a2:	0141                	addi	sp,sp,16
 4a4:	8082                	ret
  n = 0;
 4a6:	4501                	li	a0,0
 4a8:	bfe5                	j	4a0 <atoi+0x40>

00000000000004aa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4aa:	1141                	addi	sp,sp,-16
 4ac:	e422                	sd	s0,8(sp)
 4ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4b0:	02b57663          	bleu	a1,a0,4dc <memmove+0x32>
    while(n-- > 0)
 4b4:	02c05163          	blez	a2,4d6 <memmove+0x2c>
 4b8:	fff6079b          	addiw	a5,a2,-1
 4bc:	1782                	slli	a5,a5,0x20
 4be:	9381                	srli	a5,a5,0x20
 4c0:	0785                	addi	a5,a5,1
 4c2:	97aa                	add	a5,a5,a0
  dst = vdst;
 4c4:	872a                	mv	a4,a0
      *dst++ = *src++;
 4c6:	0585                	addi	a1,a1,1
 4c8:	0705                	addi	a4,a4,1
 4ca:	fff5c683          	lbu	a3,-1(a1)
 4ce:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4d2:	fee79ae3          	bne	a5,a4,4c6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4d6:	6422                	ld	s0,8(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret
    dst += n;
 4dc:	00c50733          	add	a4,a0,a2
    src += n;
 4e0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4e2:	fec05ae3          	blez	a2,4d6 <memmove+0x2c>
 4e6:	fff6079b          	addiw	a5,a2,-1
 4ea:	1782                	slli	a5,a5,0x20
 4ec:	9381                	srli	a5,a5,0x20
 4ee:	fff7c793          	not	a5,a5
 4f2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4f4:	15fd                	addi	a1,a1,-1
 4f6:	177d                	addi	a4,a4,-1
 4f8:	0005c683          	lbu	a3,0(a1)
 4fc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 500:	fef71ae3          	bne	a4,a5,4f4 <memmove+0x4a>
 504:	bfc9                	j	4d6 <memmove+0x2c>

0000000000000506 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 506:	1141                	addi	sp,sp,-16
 508:	e422                	sd	s0,8(sp)
 50a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 50c:	ce15                	beqz	a2,548 <memcmp+0x42>
 50e:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
 512:	00054783          	lbu	a5,0(a0)
 516:	0005c703          	lbu	a4,0(a1)
 51a:	02e79063          	bne	a5,a4,53a <memcmp+0x34>
 51e:	1682                	slli	a3,a3,0x20
 520:	9281                	srli	a3,a3,0x20
 522:	0685                	addi	a3,a3,1
 524:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
 526:	0505                	addi	a0,a0,1
    p2++;
 528:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 52a:	00d50d63          	beq	a0,a3,544 <memcmp+0x3e>
    if (*p1 != *p2) {
 52e:	00054783          	lbu	a5,0(a0)
 532:	0005c703          	lbu	a4,0(a1)
 536:	fee788e3          	beq	a5,a4,526 <memcmp+0x20>
      return *p1 - *p2;
 53a:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
 53e:	6422                	ld	s0,8(sp)
 540:	0141                	addi	sp,sp,16
 542:	8082                	ret
  return 0;
 544:	4501                	li	a0,0
 546:	bfe5                	j	53e <memcmp+0x38>
 548:	4501                	li	a0,0
 54a:	bfd5                	j	53e <memcmp+0x38>

000000000000054c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 54c:	1141                	addi	sp,sp,-16
 54e:	e406                	sd	ra,8(sp)
 550:	e022                	sd	s0,0(sp)
 552:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 554:	00000097          	auipc	ra,0x0
 558:	f56080e7          	jalr	-170(ra) # 4aa <memmove>
}
 55c:	60a2                	ld	ra,8(sp)
 55e:	6402                	ld	s0,0(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret

0000000000000564 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 564:	4885                	li	a7,1
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <exit>:
.global exit
exit:
 li a7, SYS_exit
 56c:	4889                	li	a7,2
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <wait>:
.global wait
wait:
 li a7, SYS_wait
 574:	488d                	li	a7,3
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57c:	4891                	li	a7,4
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <read>:
.global read
read:
 li a7, SYS_read
 584:	4895                	li	a7,5
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <write>:
.global write
write:
 li a7, SYS_write
 58c:	48c1                	li	a7,16
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <close>:
.global close
close:
 li a7, SYS_close
 594:	48d5                	li	a7,21
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <kill>:
.global kill
kill:
 li a7, SYS_kill
 59c:	4899                	li	a7,6
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a4:	489d                	li	a7,7
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <open>:
.global open
open:
 li a7, SYS_open
 5ac:	48bd                	li	a7,15
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b4:	48c5                	li	a7,17
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5bc:	48c9                	li	a7,18
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c4:	48a1                	li	a7,8
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <link>:
.global link
link:
 li a7, SYS_link
 5cc:	48cd                	li	a7,19
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d4:	48d1                	li	a7,20
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5dc:	48a5                	li	a7,9
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e4:	48a9                	li	a7,10
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ec:	48ad                	li	a7,11
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5f4:	48b1                	li	a7,12
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5fc:	48b5                	li	a7,13
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 604:	48b9                	li	a7,14
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 60c:	1101                	addi	sp,sp,-32
 60e:	ec06                	sd	ra,24(sp)
 610:	e822                	sd	s0,16(sp)
 612:	1000                	addi	s0,sp,32
 614:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 618:	4605                	li	a2,1
 61a:	fef40593          	addi	a1,s0,-17
 61e:	00000097          	auipc	ra,0x0
 622:	f6e080e7          	jalr	-146(ra) # 58c <write>
}
 626:	60e2                	ld	ra,24(sp)
 628:	6442                	ld	s0,16(sp)
 62a:	6105                	addi	sp,sp,32
 62c:	8082                	ret

000000000000062e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62e:	7139                	addi	sp,sp,-64
 630:	fc06                	sd	ra,56(sp)
 632:	f822                	sd	s0,48(sp)
 634:	f426                	sd	s1,40(sp)
 636:	f04a                	sd	s2,32(sp)
 638:	ec4e                	sd	s3,24(sp)
 63a:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 63c:	c299                	beqz	a3,642 <printint+0x14>
 63e:	0005cd63          	bltz	a1,658 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 642:	2581                	sext.w	a1,a1
  neg = 0;
 644:	4301                	li	t1,0
 646:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
 64a:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
 64c:	2601                	sext.w	a2,a2
 64e:	00000897          	auipc	a7,0x0
 652:	4b288893          	addi	a7,a7,1202 # b00 <digits>
 656:	a801                	j	666 <printint+0x38>
    x = -xx;
 658:	40b005bb          	negw	a1,a1
 65c:	2581                	sext.w	a1,a1
    neg = 1;
 65e:	4305                	li	t1,1
    x = -xx;
 660:	b7dd                	j	646 <printint+0x18>
  }while((x /= base) != 0);
 662:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
 664:	8836                	mv	a6,a3
 666:	0018069b          	addiw	a3,a6,1
 66a:	02c5f7bb          	remuw	a5,a1,a2
 66e:	1782                	slli	a5,a5,0x20
 670:	9381                	srli	a5,a5,0x20
 672:	97c6                	add	a5,a5,a7
 674:	0007c783          	lbu	a5,0(a5)
 678:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
 67c:	0705                	addi	a4,a4,1
 67e:	02c5d7bb          	divuw	a5,a1,a2
 682:	fec5f0e3          	bleu	a2,a1,662 <printint+0x34>
  if(neg)
 686:	00030b63          	beqz	t1,69c <printint+0x6e>
    buf[i++] = '-';
 68a:	fd040793          	addi	a5,s0,-48
 68e:	96be                	add	a3,a3,a5
 690:	02d00793          	li	a5,45
 694:	fef68823          	sb	a5,-16(a3)
 698:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
 69c:	02d05963          	blez	a3,6ce <printint+0xa0>
 6a0:	89aa                	mv	s3,a0
 6a2:	fc040793          	addi	a5,s0,-64
 6a6:	00d784b3          	add	s1,a5,a3
 6aa:	fff78913          	addi	s2,a5,-1
 6ae:	9936                	add	s2,s2,a3
 6b0:	36fd                	addiw	a3,a3,-1
 6b2:	1682                	slli	a3,a3,0x20
 6b4:	9281                	srli	a3,a3,0x20
 6b6:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
 6ba:	fff4c583          	lbu	a1,-1(s1)
 6be:	854e                	mv	a0,s3
 6c0:	00000097          	auipc	ra,0x0
 6c4:	f4c080e7          	jalr	-180(ra) # 60c <putc>
  while(--i >= 0)
 6c8:	14fd                	addi	s1,s1,-1
 6ca:	ff2498e3          	bne	s1,s2,6ba <printint+0x8c>
}
 6ce:	70e2                	ld	ra,56(sp)
 6d0:	7442                	ld	s0,48(sp)
 6d2:	74a2                	ld	s1,40(sp)
 6d4:	7902                	ld	s2,32(sp)
 6d6:	69e2                	ld	s3,24(sp)
 6d8:	6121                	addi	sp,sp,64
 6da:	8082                	ret

00000000000006dc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6dc:	7119                	addi	sp,sp,-128
 6de:	fc86                	sd	ra,120(sp)
 6e0:	f8a2                	sd	s0,112(sp)
 6e2:	f4a6                	sd	s1,104(sp)
 6e4:	f0ca                	sd	s2,96(sp)
 6e6:	ecce                	sd	s3,88(sp)
 6e8:	e8d2                	sd	s4,80(sp)
 6ea:	e4d6                	sd	s5,72(sp)
 6ec:	e0da                	sd	s6,64(sp)
 6ee:	fc5e                	sd	s7,56(sp)
 6f0:	f862                	sd	s8,48(sp)
 6f2:	f466                	sd	s9,40(sp)
 6f4:	f06a                	sd	s10,32(sp)
 6f6:	ec6e                	sd	s11,24(sp)
 6f8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6fa:	0005c483          	lbu	s1,0(a1)
 6fe:	18048d63          	beqz	s1,898 <vprintf+0x1bc>
 702:	8aaa                	mv	s5,a0
 704:	8b32                	mv	s6,a2
 706:	00158913          	addi	s2,a1,1
  state = 0;
 70a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 70c:	02500a13          	li	s4,37
      if(c == 'd'){
 710:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 714:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 718:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 71c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 720:	00000b97          	auipc	s7,0x0
 724:	3e0b8b93          	addi	s7,s7,992 # b00 <digits>
 728:	a839                	j	746 <vprintf+0x6a>
        putc(fd, c);
 72a:	85a6                	mv	a1,s1
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	ede080e7          	jalr	-290(ra) # 60c <putc>
 736:	a019                	j	73c <vprintf+0x60>
    } else if(state == '%'){
 738:	01498f63          	beq	s3,s4,756 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 73c:	0905                	addi	s2,s2,1
 73e:	fff94483          	lbu	s1,-1(s2)
 742:	14048b63          	beqz	s1,898 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
 746:	0004879b          	sext.w	a5,s1
    if(state == 0){
 74a:	fe0997e3          	bnez	s3,738 <vprintf+0x5c>
      if(c == '%'){
 74e:	fd479ee3          	bne	a5,s4,72a <vprintf+0x4e>
        state = '%';
 752:	89be                	mv	s3,a5
 754:	b7e5                	j	73c <vprintf+0x60>
      if(c == 'd'){
 756:	05878063          	beq	a5,s8,796 <vprintf+0xba>
      } else if(c == 'l') {
 75a:	05978c63          	beq	a5,s9,7b2 <vprintf+0xd6>
      } else if(c == 'x') {
 75e:	07a78863          	beq	a5,s10,7ce <vprintf+0xf2>
      } else if(c == 'p') {
 762:	09b78463          	beq	a5,s11,7ea <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 766:	07300713          	li	a4,115
 76a:	0ce78563          	beq	a5,a4,834 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 76e:	06300713          	li	a4,99
 772:	0ee78c63          	beq	a5,a4,86a <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 776:	11478663          	beq	a5,s4,882 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 77a:	85d2                	mv	a1,s4
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	e8e080e7          	jalr	-370(ra) # 60c <putc>
        putc(fd, c);
 786:	85a6                	mv	a1,s1
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	e82080e7          	jalr	-382(ra) # 60c <putc>
      }
      state = 0;
 792:	4981                	li	s3,0
 794:	b765                	j	73c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 796:	008b0493          	addi	s1,s6,8
 79a:	4685                	li	a3,1
 79c:	4629                	li	a2,10
 79e:	000b2583          	lw	a1,0(s6)
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	e8a080e7          	jalr	-374(ra) # 62e <printint>
 7ac:	8b26                	mv	s6,s1
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b771                	j	73c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b2:	008b0493          	addi	s1,s6,8
 7b6:	4681                	li	a3,0
 7b8:	4629                	li	a2,10
 7ba:	000b2583          	lw	a1,0(s6)
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	e6e080e7          	jalr	-402(ra) # 62e <printint>
 7c8:	8b26                	mv	s6,s1
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	bf85                	j	73c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7ce:	008b0493          	addi	s1,s6,8
 7d2:	4681                	li	a3,0
 7d4:	4641                	li	a2,16
 7d6:	000b2583          	lw	a1,0(s6)
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	e52080e7          	jalr	-430(ra) # 62e <printint>
 7e4:	8b26                	mv	s6,s1
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	bf91                	j	73c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 7ea:	008b0793          	addi	a5,s6,8
 7ee:	f8f43423          	sd	a5,-120(s0)
 7f2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7f6:	03000593          	li	a1,48
 7fa:	8556                	mv	a0,s5
 7fc:	00000097          	auipc	ra,0x0
 800:	e10080e7          	jalr	-496(ra) # 60c <putc>
  putc(fd, 'x');
 804:	85ea                	mv	a1,s10
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	e04080e7          	jalr	-508(ra) # 60c <putc>
 810:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 812:	03c9d793          	srli	a5,s3,0x3c
 816:	97de                	add	a5,a5,s7
 818:	0007c583          	lbu	a1,0(a5)
 81c:	8556                	mv	a0,s5
 81e:	00000097          	auipc	ra,0x0
 822:	dee080e7          	jalr	-530(ra) # 60c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 826:	0992                	slli	s3,s3,0x4
 828:	34fd                	addiw	s1,s1,-1
 82a:	f4e5                	bnez	s1,812 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 82c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 830:	4981                	li	s3,0
 832:	b729                	j	73c <vprintf+0x60>
        s = va_arg(ap, char*);
 834:	008b0993          	addi	s3,s6,8
 838:	000b3483          	ld	s1,0(s6)
        if(s == 0)
 83c:	c085                	beqz	s1,85c <vprintf+0x180>
        while(*s != 0){
 83e:	0004c583          	lbu	a1,0(s1)
 842:	c9a1                	beqz	a1,892 <vprintf+0x1b6>
          putc(fd, *s);
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	dc6080e7          	jalr	-570(ra) # 60c <putc>
          s++;
 84e:	0485                	addi	s1,s1,1
        while(*s != 0){
 850:	0004c583          	lbu	a1,0(s1)
 854:	f9e5                	bnez	a1,844 <vprintf+0x168>
        s = va_arg(ap, char*);
 856:	8b4e                	mv	s6,s3
      state = 0;
 858:	4981                	li	s3,0
 85a:	b5cd                	j	73c <vprintf+0x60>
          s = "(null)";
 85c:	00000497          	auipc	s1,0x0
 860:	2bc48493          	addi	s1,s1,700 # b18 <digits+0x18>
        while(*s != 0){
 864:	02800593          	li	a1,40
 868:	bff1                	j	844 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
 86a:	008b0493          	addi	s1,s6,8
 86e:	000b4583          	lbu	a1,0(s6)
 872:	8556                	mv	a0,s5
 874:	00000097          	auipc	ra,0x0
 878:	d98080e7          	jalr	-616(ra) # 60c <putc>
 87c:	8b26                	mv	s6,s1
      state = 0;
 87e:	4981                	li	s3,0
 880:	bd75                	j	73c <vprintf+0x60>
        putc(fd, c);
 882:	85d2                	mv	a1,s4
 884:	8556                	mv	a0,s5
 886:	00000097          	auipc	ra,0x0
 88a:	d86080e7          	jalr	-634(ra) # 60c <putc>
      state = 0;
 88e:	4981                	li	s3,0
 890:	b575                	j	73c <vprintf+0x60>
        s = va_arg(ap, char*);
 892:	8b4e                	mv	s6,s3
      state = 0;
 894:	4981                	li	s3,0
 896:	b55d                	j	73c <vprintf+0x60>
    }
  }
}
 898:	70e6                	ld	ra,120(sp)
 89a:	7446                	ld	s0,112(sp)
 89c:	74a6                	ld	s1,104(sp)
 89e:	7906                	ld	s2,96(sp)
 8a0:	69e6                	ld	s3,88(sp)
 8a2:	6a46                	ld	s4,80(sp)
 8a4:	6aa6                	ld	s5,72(sp)
 8a6:	6b06                	ld	s6,64(sp)
 8a8:	7be2                	ld	s7,56(sp)
 8aa:	7c42                	ld	s8,48(sp)
 8ac:	7ca2                	ld	s9,40(sp)
 8ae:	7d02                	ld	s10,32(sp)
 8b0:	6de2                	ld	s11,24(sp)
 8b2:	6109                	addi	sp,sp,128
 8b4:	8082                	ret

00000000000008b6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b6:	715d                	addi	sp,sp,-80
 8b8:	ec06                	sd	ra,24(sp)
 8ba:	e822                	sd	s0,16(sp)
 8bc:	1000                	addi	s0,sp,32
 8be:	e010                	sd	a2,0(s0)
 8c0:	e414                	sd	a3,8(s0)
 8c2:	e818                	sd	a4,16(s0)
 8c4:	ec1c                	sd	a5,24(s0)
 8c6:	03043023          	sd	a6,32(s0)
 8ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ce:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8d2:	8622                	mv	a2,s0
 8d4:	00000097          	auipc	ra,0x0
 8d8:	e08080e7          	jalr	-504(ra) # 6dc <vprintf>
}
 8dc:	60e2                	ld	ra,24(sp)
 8de:	6442                	ld	s0,16(sp)
 8e0:	6161                	addi	sp,sp,80
 8e2:	8082                	ret

00000000000008e4 <printf>:

void
printf(const char *fmt, ...)
{
 8e4:	711d                	addi	sp,sp,-96
 8e6:	ec06                	sd	ra,24(sp)
 8e8:	e822                	sd	s0,16(sp)
 8ea:	1000                	addi	s0,sp,32
 8ec:	e40c                	sd	a1,8(s0)
 8ee:	e810                	sd	a2,16(s0)
 8f0:	ec14                	sd	a3,24(s0)
 8f2:	f018                	sd	a4,32(s0)
 8f4:	f41c                	sd	a5,40(s0)
 8f6:	03043823          	sd	a6,48(s0)
 8fa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8fe:	00840613          	addi	a2,s0,8
 902:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 906:	85aa                	mv	a1,a0
 908:	4505                	li	a0,1
 90a:	00000097          	auipc	ra,0x0
 90e:	dd2080e7          	jalr	-558(ra) # 6dc <vprintf>
}
 912:	60e2                	ld	ra,24(sp)
 914:	6442                	ld	s0,16(sp)
 916:	6125                	addi	sp,sp,96
 918:	8082                	ret

000000000000091a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 91a:	1141                	addi	sp,sp,-16
 91c:	e422                	sd	s0,8(sp)
 91e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 920:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 924:	00000797          	auipc	a5,0x0
 928:	1fc78793          	addi	a5,a5,508 # b20 <__bss_start>
 92c:	639c                	ld	a5,0(a5)
 92e:	a805                	j	95e <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 930:	4618                	lw	a4,8(a2)
 932:	9db9                	addw	a1,a1,a4
 934:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 938:	6398                	ld	a4,0(a5)
 93a:	6318                	ld	a4,0(a4)
 93c:	fee53823          	sd	a4,-16(a0)
 940:	a091                	j	984 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 942:	ff852703          	lw	a4,-8(a0)
 946:	9e39                	addw	a2,a2,a4
 948:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 94a:	ff053703          	ld	a4,-16(a0)
 94e:	e398                	sd	a4,0(a5)
 950:	a099                	j	996 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	6398                	ld	a4,0(a5)
 954:	00e7e463          	bltu	a5,a4,95c <free+0x42>
 958:	00e6ea63          	bltu	a3,a4,96c <free+0x52>
{
 95c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95e:	fed7fae3          	bleu	a3,a5,952 <free+0x38>
 962:	6398                	ld	a4,0(a5)
 964:	00e6e463          	bltu	a3,a4,96c <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 968:	fee7eae3          	bltu	a5,a4,95c <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
 96c:	ff852583          	lw	a1,-8(a0)
 970:	6390                	ld	a2,0(a5)
 972:	02059713          	slli	a4,a1,0x20
 976:	9301                	srli	a4,a4,0x20
 978:	0712                	slli	a4,a4,0x4
 97a:	9736                	add	a4,a4,a3
 97c:	fae60ae3          	beq	a2,a4,930 <free+0x16>
    bp->s.ptr = p->s.ptr;
 980:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 984:	4790                	lw	a2,8(a5)
 986:	02061713          	slli	a4,a2,0x20
 98a:	9301                	srli	a4,a4,0x20
 98c:	0712                	slli	a4,a4,0x4
 98e:	973e                	add	a4,a4,a5
 990:	fae689e3          	beq	a3,a4,942 <free+0x28>
  } else
    p->s.ptr = bp;
 994:	e394                	sd	a3,0(a5)
  freep = p;
 996:	00000717          	auipc	a4,0x0
 99a:	18f73523          	sd	a5,394(a4) # b20 <__bss_start>
}
 99e:	6422                	ld	s0,8(sp)
 9a0:	0141                	addi	sp,sp,16
 9a2:	8082                	ret

00000000000009a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9a4:	7139                	addi	sp,sp,-64
 9a6:	fc06                	sd	ra,56(sp)
 9a8:	f822                	sd	s0,48(sp)
 9aa:	f426                	sd	s1,40(sp)
 9ac:	f04a                	sd	s2,32(sp)
 9ae:	ec4e                	sd	s3,24(sp)
 9b0:	e852                	sd	s4,16(sp)
 9b2:	e456                	sd	s5,8(sp)
 9b4:	e05a                	sd	s6,0(sp)
 9b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b8:	02051993          	slli	s3,a0,0x20
 9bc:	0209d993          	srli	s3,s3,0x20
 9c0:	09bd                	addi	s3,s3,15
 9c2:	0049d993          	srli	s3,s3,0x4
 9c6:	2985                	addiw	s3,s3,1
 9c8:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
 9cc:	00000797          	auipc	a5,0x0
 9d0:	15478793          	addi	a5,a5,340 # b20 <__bss_start>
 9d4:	6388                	ld	a0,0(a5)
 9d6:	c515                	beqz	a0,a02 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9da:	4798                	lw	a4,8(a5)
 9dc:	03277f63          	bleu	s2,a4,a1a <malloc+0x76>
 9e0:	8a4e                	mv	s4,s3
 9e2:	0009871b          	sext.w	a4,s3
 9e6:	6685                	lui	a3,0x1
 9e8:	00d77363          	bleu	a3,a4,9ee <malloc+0x4a>
 9ec:	6a05                	lui	s4,0x1
 9ee:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
 9f2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f6:	00000497          	auipc	s1,0x0
 9fa:	12a48493          	addi	s1,s1,298 # b20 <__bss_start>
  if(p == (char*)-1)
 9fe:	5b7d                	li	s6,-1
 a00:	a885                	j	a70 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
 a02:	00000797          	auipc	a5,0x0
 a06:	13678793          	addi	a5,a5,310 # b38 <base>
 a0a:	00000717          	auipc	a4,0x0
 a0e:	10f73b23          	sd	a5,278(a4) # b20 <__bss_start>
 a12:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a14:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a18:	b7e1                	j	9e0 <malloc+0x3c>
      if(p->s.size == nunits)
 a1a:	02e90b63          	beq	s2,a4,a50 <malloc+0xac>
        p->s.size -= nunits;
 a1e:	4137073b          	subw	a4,a4,s3
 a22:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a24:	1702                	slli	a4,a4,0x20
 a26:	9301                	srli	a4,a4,0x20
 a28:	0712                	slli	a4,a4,0x4
 a2a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a2c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a30:	00000717          	auipc	a4,0x0
 a34:	0ea73823          	sd	a0,240(a4) # b20 <__bss_start>
      return (void*)(p + 1);
 a38:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a3c:	70e2                	ld	ra,56(sp)
 a3e:	7442                	ld	s0,48(sp)
 a40:	74a2                	ld	s1,40(sp)
 a42:	7902                	ld	s2,32(sp)
 a44:	69e2                	ld	s3,24(sp)
 a46:	6a42                	ld	s4,16(sp)
 a48:	6aa2                	ld	s5,8(sp)
 a4a:	6b02                	ld	s6,0(sp)
 a4c:	6121                	addi	sp,sp,64
 a4e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a50:	6398                	ld	a4,0(a5)
 a52:	e118                	sd	a4,0(a0)
 a54:	bff1                	j	a30 <malloc+0x8c>
  hp->s.size = nu;
 a56:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
 a5a:	0541                	addi	a0,a0,16
 a5c:	00000097          	auipc	ra,0x0
 a60:	ebe080e7          	jalr	-322(ra) # 91a <free>
  return freep;
 a64:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a66:	d979                	beqz	a0,a3c <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a68:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a6a:	4798                	lw	a4,8(a5)
 a6c:	fb2777e3          	bleu	s2,a4,a1a <malloc+0x76>
    if(p == freep)
 a70:	6098                	ld	a4,0(s1)
 a72:	853e                	mv	a0,a5
 a74:	fef71ae3          	bne	a4,a5,a68 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
 a78:	8552                	mv	a0,s4
 a7a:	00000097          	auipc	ra,0x0
 a7e:	b7a080e7          	jalr	-1158(ra) # 5f4 <sbrk>
  if(p == (char*)-1)
 a82:	fd651ae3          	bne	a0,s6,a56 <malloc+0xb2>
        return 0;
 a86:	4501                	li	a0,0
 a88:	bf55                	j	a3c <malloc+0x98>
