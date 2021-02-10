
user/_usertests：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	3f4080e7          	jalr	1012(ra) # 5404 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	3e2080e7          	jalr	994(ra) # 5404 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	c4a50513          	addi	a0,a0,-950 # 5c88 <malloc+0x48c>
      46:	00005097          	auipc	ra,0x5
      4a:	6f6080e7          	jalr	1782(ra) # 573c <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	374080e7          	jalr	884(ra) # 53c4 <exit>

0000000000000058 <bsstest>:
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
      58:	00009797          	auipc	a5,0x9
      5c:	0207c783          	lbu	a5,32(a5) # 9078 <uninit>
      60:	e385                	bnez	a5,80 <bsstest+0x28>
      62:	00009797          	auipc	a5,0x9
      66:	01778793          	addi	a5,a5,23 # 9079 <uninit+0x1>
      6a:	0000b697          	auipc	a3,0xb
      6e:	71e68693          	addi	a3,a3,1822 # b788 <buf>
      72:	0007c703          	lbu	a4,0(a5)
      76:	e709                	bnez	a4,80 <bsstest+0x28>
  for(i = 0; i < sizeof(uninit); i++){
      78:	0785                	addi	a5,a5,1
      7a:	fed79ce3          	bne	a5,a3,72 <bsstest+0x1a>
      7e:	8082                	ret
{
      80:	1141                	addi	sp,sp,-16
      82:	e406                	sd	ra,8(sp)
      84:	e022                	sd	s0,0(sp)
      86:	0800                	addi	s0,sp,16
      88:	85aa                	mv	a1,a0
      printf("%s: bss test failed\n", s);
      8a:	00006517          	auipc	a0,0x6
      8e:	c1e50513          	addi	a0,a0,-994 # 5ca8 <malloc+0x4ac>
      92:	00005097          	auipc	ra,0x5
      96:	6aa080e7          	jalr	1706(ra) # 573c <printf>
      exit(1);
      9a:	4505                	li	a0,1
      9c:	00005097          	auipc	ra,0x5
      a0:	328080e7          	jalr	808(ra) # 53c4 <exit>

00000000000000a4 <opentest>:
{
      a4:	1101                	addi	sp,sp,-32
      a6:	ec06                	sd	ra,24(sp)
      a8:	e822                	sd	s0,16(sp)
      aa:	e426                	sd	s1,8(sp)
      ac:	1000                	addi	s0,sp,32
      ae:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      b0:	4581                	li	a1,0
      b2:	00006517          	auipc	a0,0x6
      b6:	c0e50513          	addi	a0,a0,-1010 # 5cc0 <malloc+0x4c4>
      ba:	00005097          	auipc	ra,0x5
      be:	34a080e7          	jalr	842(ra) # 5404 <open>
  if(fd < 0){
      c2:	02054663          	bltz	a0,ee <opentest+0x4a>
  close(fd);
      c6:	00005097          	auipc	ra,0x5
      ca:	326080e7          	jalr	806(ra) # 53ec <close>
  fd = open("doesnotexist", 0);
      ce:	4581                	li	a1,0
      d0:	00006517          	auipc	a0,0x6
      d4:	c1050513          	addi	a0,a0,-1008 # 5ce0 <malloc+0x4e4>
      d8:	00005097          	auipc	ra,0x5
      dc:	32c080e7          	jalr	812(ra) # 5404 <open>
  if(fd >= 0){
      e0:	02055563          	bgez	a0,10a <opentest+0x66>
}
      e4:	60e2                	ld	ra,24(sp)
      e6:	6442                	ld	s0,16(sp)
      e8:	64a2                	ld	s1,8(sp)
      ea:	6105                	addi	sp,sp,32
      ec:	8082                	ret
    printf("%s: open echo failed!\n", s);
      ee:	85a6                	mv	a1,s1
      f0:	00006517          	auipc	a0,0x6
      f4:	bd850513          	addi	a0,a0,-1064 # 5cc8 <malloc+0x4cc>
      f8:	00005097          	auipc	ra,0x5
      fc:	644080e7          	jalr	1604(ra) # 573c <printf>
    exit(1);
     100:	4505                	li	a0,1
     102:	00005097          	auipc	ra,0x5
     106:	2c2080e7          	jalr	706(ra) # 53c4 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00006517          	auipc	a0,0x6
     110:	be450513          	addi	a0,a0,-1052 # 5cf0 <malloc+0x4f4>
     114:	00005097          	auipc	ra,0x5
     118:	628080e7          	jalr	1576(ra) # 573c <printf>
    exit(1);
     11c:	4505                	li	a0,1
     11e:	00005097          	auipc	ra,0x5
     122:	2a6080e7          	jalr	678(ra) # 53c4 <exit>

0000000000000126 <truncate2>:
{
     126:	7179                	addi	sp,sp,-48
     128:	f406                	sd	ra,40(sp)
     12a:	f022                	sd	s0,32(sp)
     12c:	ec26                	sd	s1,24(sp)
     12e:	e84a                	sd	s2,16(sp)
     130:	e44e                	sd	s3,8(sp)
     132:	1800                	addi	s0,sp,48
     134:	89aa                	mv	s3,a0
  unlink("truncfile");
     136:	00006517          	auipc	a0,0x6
     13a:	be250513          	addi	a0,a0,-1054 # 5d18 <malloc+0x51c>
     13e:	00005097          	auipc	ra,0x5
     142:	2d6080e7          	jalr	726(ra) # 5414 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     146:	60100593          	li	a1,1537
     14a:	00006517          	auipc	a0,0x6
     14e:	bce50513          	addi	a0,a0,-1074 # 5d18 <malloc+0x51c>
     152:	00005097          	auipc	ra,0x5
     156:	2b2080e7          	jalr	690(ra) # 5404 <open>
     15a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     15c:	4611                	li	a2,4
     15e:	00006597          	auipc	a1,0x6
     162:	bca58593          	addi	a1,a1,-1078 # 5d28 <malloc+0x52c>
     166:	00005097          	auipc	ra,0x5
     16a:	27e080e7          	jalr	638(ra) # 53e4 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     16e:	40100593          	li	a1,1025
     172:	00006517          	auipc	a0,0x6
     176:	ba650513          	addi	a0,a0,-1114 # 5d18 <malloc+0x51c>
     17a:	00005097          	auipc	ra,0x5
     17e:	28a080e7          	jalr	650(ra) # 5404 <open>
     182:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     184:	4605                	li	a2,1
     186:	00006597          	auipc	a1,0x6
     18a:	baa58593          	addi	a1,a1,-1110 # 5d30 <malloc+0x534>
     18e:	8526                	mv	a0,s1
     190:	00005097          	auipc	ra,0x5
     194:	254080e7          	jalr	596(ra) # 53e4 <write>
  if(n != -1){
     198:	57fd                	li	a5,-1
     19a:	02f51b63          	bne	a0,a5,1d0 <truncate2+0xaa>
  unlink("truncfile");
     19e:	00006517          	auipc	a0,0x6
     1a2:	b7a50513          	addi	a0,a0,-1158 # 5d18 <malloc+0x51c>
     1a6:	00005097          	auipc	ra,0x5
     1aa:	26e080e7          	jalr	622(ra) # 5414 <unlink>
  close(fd1);
     1ae:	8526                	mv	a0,s1
     1b0:	00005097          	auipc	ra,0x5
     1b4:	23c080e7          	jalr	572(ra) # 53ec <close>
  close(fd2);
     1b8:	854a                	mv	a0,s2
     1ba:	00005097          	auipc	ra,0x5
     1be:	232080e7          	jalr	562(ra) # 53ec <close>
}
     1c2:	70a2                	ld	ra,40(sp)
     1c4:	7402                	ld	s0,32(sp)
     1c6:	64e2                	ld	s1,24(sp)
     1c8:	6942                	ld	s2,16(sp)
     1ca:	69a2                	ld	s3,8(sp)
     1cc:	6145                	addi	sp,sp,48
     1ce:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1d0:	862a                	mv	a2,a0
     1d2:	85ce                	mv	a1,s3
     1d4:	00006517          	auipc	a0,0x6
     1d8:	b6450513          	addi	a0,a0,-1180 # 5d38 <malloc+0x53c>
     1dc:	00005097          	auipc	ra,0x5
     1e0:	560080e7          	jalr	1376(ra) # 573c <printf>
    exit(1);
     1e4:	4505                	li	a0,1
     1e6:	00005097          	auipc	ra,0x5
     1ea:	1de080e7          	jalr	478(ra) # 53c4 <exit>

00000000000001ee <createtest>:
{
     1ee:	7179                	addi	sp,sp,-48
     1f0:	f406                	sd	ra,40(sp)
     1f2:	f022                	sd	s0,32(sp)
     1f4:	ec26                	sd	s1,24(sp)
     1f6:	e84a                	sd	s2,16(sp)
     1f8:	e44e                	sd	s3,8(sp)
     1fa:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1fc:	00008797          	auipc	a5,0x8
     200:	d6478793          	addi	a5,a5,-668 # 7f60 <_edata>
     204:	06100713          	li	a4,97
     208:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     20c:	00078123          	sb	zero,2(a5)
     210:	03000493          	li	s1,48
    name[1] = '0' + i;
     214:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     216:	06400993          	li	s3,100
    name[1] = '0' + i;
     21a:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     21e:	20200593          	li	a1,514
     222:	854a                	mv	a0,s2
     224:	00005097          	auipc	ra,0x5
     228:	1e0080e7          	jalr	480(ra) # 5404 <open>
    close(fd);
     22c:	00005097          	auipc	ra,0x5
     230:	1c0080e7          	jalr	448(ra) # 53ec <close>
  for(i = 0; i < N; i++){
     234:	2485                	addiw	s1,s1,1
     236:	0ff4f493          	andi	s1,s1,255
     23a:	ff3490e3          	bne	s1,s3,21a <createtest+0x2c>
  name[0] = 'a';
     23e:	00008797          	auipc	a5,0x8
     242:	d2278793          	addi	a5,a5,-734 # 7f60 <_edata>
     246:	06100713          	li	a4,97
     24a:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     24e:	00078123          	sb	zero,2(a5)
     252:	03000493          	li	s1,48
    name[1] = '0' + i;
     256:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     258:	06400993          	li	s3,100
    name[1] = '0' + i;
     25c:	009900a3          	sb	s1,1(s2)
    unlink(name);
     260:	854a                	mv	a0,s2
     262:	00005097          	auipc	ra,0x5
     266:	1b2080e7          	jalr	434(ra) # 5414 <unlink>
  for(i = 0; i < N; i++){
     26a:	2485                	addiw	s1,s1,1
     26c:	0ff4f493          	andi	s1,s1,255
     270:	ff3496e3          	bne	s1,s3,25c <createtest+0x6e>
}
     274:	70a2                	ld	ra,40(sp)
     276:	7402                	ld	s0,32(sp)
     278:	64e2                	ld	s1,24(sp)
     27a:	6942                	ld	s2,16(sp)
     27c:	69a2                	ld	s3,8(sp)
     27e:	6145                	addi	sp,sp,48
     280:	8082                	ret

0000000000000282 <bigwrite>:
{
     282:	715d                	addi	sp,sp,-80
     284:	e486                	sd	ra,72(sp)
     286:	e0a2                	sd	s0,64(sp)
     288:	fc26                	sd	s1,56(sp)
     28a:	f84a                	sd	s2,48(sp)
     28c:	f44e                	sd	s3,40(sp)
     28e:	f052                	sd	s4,32(sp)
     290:	ec56                	sd	s5,24(sp)
     292:	e85a                	sd	s6,16(sp)
     294:	e45e                	sd	s7,8(sp)
     296:	0880                	addi	s0,sp,80
     298:	8baa                	mv	s7,a0
  unlink("bigwrite");
     29a:	00006517          	auipc	a0,0x6
     29e:	ac650513          	addi	a0,a0,-1338 # 5d60 <malloc+0x564>
     2a2:	00005097          	auipc	ra,0x5
     2a6:	172080e7          	jalr	370(ra) # 5414 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2aa:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ae:	00006a17          	auipc	s4,0x6
     2b2:	ab2a0a13          	addi	s4,s4,-1358 # 5d60 <malloc+0x564>
      int cc = write(fd, buf, sz);
     2b6:	0000b997          	auipc	s3,0xb
     2ba:	4d298993          	addi	s3,s3,1234 # b788 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2be:	6b0d                	lui	s6,0x3
     2c0:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x4c1>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2c4:	20200593          	li	a1,514
     2c8:	8552                	mv	a0,s4
     2ca:	00005097          	auipc	ra,0x5
     2ce:	13a080e7          	jalr	314(ra) # 5404 <open>
     2d2:	892a                	mv	s2,a0
    if(fd < 0){
     2d4:	04054d63          	bltz	a0,32e <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2d8:	8626                	mv	a2,s1
     2da:	85ce                	mv	a1,s3
     2dc:	00005097          	auipc	ra,0x5
     2e0:	108080e7          	jalr	264(ra) # 53e4 <write>
     2e4:	8aaa                	mv	s5,a0
      if(cc != sz){
     2e6:	06a49463          	bne	s1,a0,34e <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2ea:	8626                	mv	a2,s1
     2ec:	85ce                	mv	a1,s3
     2ee:	854a                	mv	a0,s2
     2f0:	00005097          	auipc	ra,0x5
     2f4:	0f4080e7          	jalr	244(ra) # 53e4 <write>
      if(cc != sz){
     2f8:	04951963          	bne	a0,s1,34a <bigwrite+0xc8>
    close(fd);
     2fc:	854a                	mv	a0,s2
     2fe:	00005097          	auipc	ra,0x5
     302:	0ee080e7          	jalr	238(ra) # 53ec <close>
    unlink("bigwrite");
     306:	8552                	mv	a0,s4
     308:	00005097          	auipc	ra,0x5
     30c:	10c080e7          	jalr	268(ra) # 5414 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     310:	1d74849b          	addiw	s1,s1,471
     314:	fb6498e3          	bne	s1,s6,2c4 <bigwrite+0x42>
}
     318:	60a6                	ld	ra,72(sp)
     31a:	6406                	ld	s0,64(sp)
     31c:	74e2                	ld	s1,56(sp)
     31e:	7942                	ld	s2,48(sp)
     320:	79a2                	ld	s3,40(sp)
     322:	7a02                	ld	s4,32(sp)
     324:	6ae2                	ld	s5,24(sp)
     326:	6b42                	ld	s6,16(sp)
     328:	6ba2                	ld	s7,8(sp)
     32a:	6161                	addi	sp,sp,80
     32c:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     32e:	85de                	mv	a1,s7
     330:	00006517          	auipc	a0,0x6
     334:	a4050513          	addi	a0,a0,-1472 # 5d70 <malloc+0x574>
     338:	00005097          	auipc	ra,0x5
     33c:	404080e7          	jalr	1028(ra) # 573c <printf>
      exit(1);
     340:	4505                	li	a0,1
     342:	00005097          	auipc	ra,0x5
     346:	082080e7          	jalr	130(ra) # 53c4 <exit>
     34a:	84d6                	mv	s1,s5
      int cc = write(fd, buf, sz);
     34c:	8aaa                	mv	s5,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     34e:	86d6                	mv	a3,s5
     350:	8626                	mv	a2,s1
     352:	85de                	mv	a1,s7
     354:	00006517          	auipc	a0,0x6
     358:	a3c50513          	addi	a0,a0,-1476 # 5d90 <malloc+0x594>
     35c:	00005097          	auipc	ra,0x5
     360:	3e0080e7          	jalr	992(ra) # 573c <printf>
        exit(1);
     364:	4505                	li	a0,1
     366:	00005097          	auipc	ra,0x5
     36a:	05e080e7          	jalr	94(ra) # 53c4 <exit>

000000000000036e <copyin>:
{
     36e:	711d                	addi	sp,sp,-96
     370:	ec86                	sd	ra,88(sp)
     372:	e8a2                	sd	s0,80(sp)
     374:	e4a6                	sd	s1,72(sp)
     376:	e0ca                	sd	s2,64(sp)
     378:	fc4e                	sd	s3,56(sp)
     37a:	f852                	sd	s4,48(sp)
     37c:	f456                	sd	s5,40(sp)
     37e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     380:	4785                	li	a5,1
     382:	07fe                	slli	a5,a5,0x1f
     384:	faf43823          	sd	a5,-80(s0)
     388:	57fd                	li	a5,-1
     38a:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     38e:	fb040493          	addi	s1,s0,-80
     392:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     396:	00006a17          	auipc	s4,0x6
     39a:	a12a0a13          	addi	s4,s4,-1518 # 5da8 <malloc+0x5ac>
    uint64 addr = addrs[ai];
     39e:	0004b903          	ld	s2,0(s1)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     3a2:	20100593          	li	a1,513
     3a6:	8552                	mv	a0,s4
     3a8:	00005097          	auipc	ra,0x5
     3ac:	05c080e7          	jalr	92(ra) # 5404 <open>
     3b0:	89aa                	mv	s3,a0
    if(fd < 0){
     3b2:	08054763          	bltz	a0,440 <copyin+0xd2>
    int n = write(fd, (void*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ca                	mv	a1,s2
     3ba:	00005097          	auipc	ra,0x5
     3be:	02a080e7          	jalr	42(ra) # 53e4 <write>
    if(n >= 0){
     3c2:	08055c63          	bgez	a0,45a <copyin+0xec>
    close(fd);
     3c6:	854e                	mv	a0,s3
     3c8:	00005097          	auipc	ra,0x5
     3cc:	024080e7          	jalr	36(ra) # 53ec <close>
    unlink("copyin1");
     3d0:	8552                	mv	a0,s4
     3d2:	00005097          	auipc	ra,0x5
     3d6:	042080e7          	jalr	66(ra) # 5414 <unlink>
    n = write(1, (char*)addr, 8192);
     3da:	6609                	lui	a2,0x2
     3dc:	85ca                	mv	a1,s2
     3de:	4505                	li	a0,1
     3e0:	00005097          	auipc	ra,0x5
     3e4:	004080e7          	jalr	4(ra) # 53e4 <write>
    if(n > 0){
     3e8:	08a04863          	bgtz	a0,478 <copyin+0x10a>
    if(pipe(fds) < 0){
     3ec:	fa840513          	addi	a0,s0,-88
     3f0:	00005097          	auipc	ra,0x5
     3f4:	fe4080e7          	jalr	-28(ra) # 53d4 <pipe>
     3f8:	08054f63          	bltz	a0,496 <copyin+0x128>
    n = write(fds[1], (char*)addr, 8192);
     3fc:	6609                	lui	a2,0x2
     3fe:	85ca                	mv	a1,s2
     400:	fac42503          	lw	a0,-84(s0)
     404:	00005097          	auipc	ra,0x5
     408:	fe0080e7          	jalr	-32(ra) # 53e4 <write>
    if(n > 0){
     40c:	0aa04263          	bgtz	a0,4b0 <copyin+0x142>
    close(fds[0]);
     410:	fa842503          	lw	a0,-88(s0)
     414:	00005097          	auipc	ra,0x5
     418:	fd8080e7          	jalr	-40(ra) # 53ec <close>
    close(fds[1]);
     41c:	fac42503          	lw	a0,-84(s0)
     420:	00005097          	auipc	ra,0x5
     424:	fcc080e7          	jalr	-52(ra) # 53ec <close>
  for(int ai = 0; ai < 2; ai++){
     428:	04a1                	addi	s1,s1,8
     42a:	f7549ae3          	bne	s1,s5,39e <copyin+0x30>
}
     42e:	60e6                	ld	ra,88(sp)
     430:	6446                	ld	s0,80(sp)
     432:	64a6                	ld	s1,72(sp)
     434:	6906                	ld	s2,64(sp)
     436:	79e2                	ld	s3,56(sp)
     438:	7a42                	ld	s4,48(sp)
     43a:	7aa2                	ld	s5,40(sp)
     43c:	6125                	addi	sp,sp,96
     43e:	8082                	ret
      printf("open(copyin1) failed\n");
     440:	00006517          	auipc	a0,0x6
     444:	97050513          	addi	a0,a0,-1680 # 5db0 <malloc+0x5b4>
     448:	00005097          	auipc	ra,0x5
     44c:	2f4080e7          	jalr	756(ra) # 573c <printf>
      exit(1);
     450:	4505                	li	a0,1
     452:	00005097          	auipc	ra,0x5
     456:	f72080e7          	jalr	-142(ra) # 53c4 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     45a:	862a                	mv	a2,a0
     45c:	85ca                	mv	a1,s2
     45e:	00006517          	auipc	a0,0x6
     462:	96a50513          	addi	a0,a0,-1686 # 5dc8 <malloc+0x5cc>
     466:	00005097          	auipc	ra,0x5
     46a:	2d6080e7          	jalr	726(ra) # 573c <printf>
      exit(1);
     46e:	4505                	li	a0,1
     470:	00005097          	auipc	ra,0x5
     474:	f54080e7          	jalr	-172(ra) # 53c4 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     478:	862a                	mv	a2,a0
     47a:	85ca                	mv	a1,s2
     47c:	00006517          	auipc	a0,0x6
     480:	97c50513          	addi	a0,a0,-1668 # 5df8 <malloc+0x5fc>
     484:	00005097          	auipc	ra,0x5
     488:	2b8080e7          	jalr	696(ra) # 573c <printf>
      exit(1);
     48c:	4505                	li	a0,1
     48e:	00005097          	auipc	ra,0x5
     492:	f36080e7          	jalr	-202(ra) # 53c4 <exit>
      printf("pipe() failed\n");
     496:	00006517          	auipc	a0,0x6
     49a:	99250513          	addi	a0,a0,-1646 # 5e28 <malloc+0x62c>
     49e:	00005097          	auipc	ra,0x5
     4a2:	29e080e7          	jalr	670(ra) # 573c <printf>
      exit(1);
     4a6:	4505                	li	a0,1
     4a8:	00005097          	auipc	ra,0x5
     4ac:	f1c080e7          	jalr	-228(ra) # 53c4 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4b0:	862a                	mv	a2,a0
     4b2:	85ca                	mv	a1,s2
     4b4:	00006517          	auipc	a0,0x6
     4b8:	98450513          	addi	a0,a0,-1660 # 5e38 <malloc+0x63c>
     4bc:	00005097          	auipc	ra,0x5
     4c0:	280080e7          	jalr	640(ra) # 573c <printf>
      exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00005097          	auipc	ra,0x5
     4ca:	efe080e7          	jalr	-258(ra) # 53c4 <exit>

00000000000004ce <copyout>:
{
     4ce:	711d                	addi	sp,sp,-96
     4d0:	ec86                	sd	ra,88(sp)
     4d2:	e8a2                	sd	s0,80(sp)
     4d4:	e4a6                	sd	s1,72(sp)
     4d6:	e0ca                	sd	s2,64(sp)
     4d8:	fc4e                	sd	s3,56(sp)
     4da:	f852                	sd	s4,48(sp)
     4dc:	f456                	sd	s5,40(sp)
     4de:	f05a                	sd	s6,32(sp)
     4e0:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4e2:	4785                	li	a5,1
     4e4:	07fe                	slli	a5,a5,0x1f
     4e6:	faf43823          	sd	a5,-80(s0)
     4ea:	57fd                	li	a5,-1
     4ec:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4f0:	fb040493          	addi	s1,s0,-80
     4f4:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     4f8:	00006a17          	auipc	s4,0x6
     4fc:	970a0a13          	addi	s4,s4,-1680 # 5e68 <malloc+0x66c>
    n = write(fds[1], "x", 1);
     500:	00006a97          	auipc	s5,0x6
     504:	830a8a93          	addi	s5,s5,-2000 # 5d30 <malloc+0x534>
    uint64 addr = addrs[ai];
     508:	0004b983          	ld	s3,0(s1)
    int fd = open("README", 0);
     50c:	4581                	li	a1,0
     50e:	8552                	mv	a0,s4
     510:	00005097          	auipc	ra,0x5
     514:	ef4080e7          	jalr	-268(ra) # 5404 <open>
     518:	892a                	mv	s2,a0
    if(fd < 0){
     51a:	08054563          	bltz	a0,5a4 <copyout+0xd6>
    int n = read(fd, (void*)addr, 8192);
     51e:	6609                	lui	a2,0x2
     520:	85ce                	mv	a1,s3
     522:	00005097          	auipc	ra,0x5
     526:	eba080e7          	jalr	-326(ra) # 53dc <read>
    if(n > 0){
     52a:	08a04a63          	bgtz	a0,5be <copyout+0xf0>
    close(fd);
     52e:	854a                	mv	a0,s2
     530:	00005097          	auipc	ra,0x5
     534:	ebc080e7          	jalr	-324(ra) # 53ec <close>
    if(pipe(fds) < 0){
     538:	fa840513          	addi	a0,s0,-88
     53c:	00005097          	auipc	ra,0x5
     540:	e98080e7          	jalr	-360(ra) # 53d4 <pipe>
     544:	08054c63          	bltz	a0,5dc <copyout+0x10e>
    n = write(fds[1], "x", 1);
     548:	4605                	li	a2,1
     54a:	85d6                	mv	a1,s5
     54c:	fac42503          	lw	a0,-84(s0)
     550:	00005097          	auipc	ra,0x5
     554:	e94080e7          	jalr	-364(ra) # 53e4 <write>
    if(n != 1){
     558:	4785                	li	a5,1
     55a:	08f51e63          	bne	a0,a5,5f6 <copyout+0x128>
    n = read(fds[0], (void*)addr, 8192);
     55e:	6609                	lui	a2,0x2
     560:	85ce                	mv	a1,s3
     562:	fa842503          	lw	a0,-88(s0)
     566:	00005097          	auipc	ra,0x5
     56a:	e76080e7          	jalr	-394(ra) # 53dc <read>
    if(n > 0){
     56e:	0aa04163          	bgtz	a0,610 <copyout+0x142>
    close(fds[0]);
     572:	fa842503          	lw	a0,-88(s0)
     576:	00005097          	auipc	ra,0x5
     57a:	e76080e7          	jalr	-394(ra) # 53ec <close>
    close(fds[1]);
     57e:	fac42503          	lw	a0,-84(s0)
     582:	00005097          	auipc	ra,0x5
     586:	e6a080e7          	jalr	-406(ra) # 53ec <close>
  for(int ai = 0; ai < 2; ai++){
     58a:	04a1                	addi	s1,s1,8
     58c:	f7649ee3          	bne	s1,s6,508 <copyout+0x3a>
}
     590:	60e6                	ld	ra,88(sp)
     592:	6446                	ld	s0,80(sp)
     594:	64a6                	ld	s1,72(sp)
     596:	6906                	ld	s2,64(sp)
     598:	79e2                	ld	s3,56(sp)
     59a:	7a42                	ld	s4,48(sp)
     59c:	7aa2                	ld	s5,40(sp)
     59e:	7b02                	ld	s6,32(sp)
     5a0:	6125                	addi	sp,sp,96
     5a2:	8082                	ret
      printf("open(README) failed\n");
     5a4:	00006517          	auipc	a0,0x6
     5a8:	8cc50513          	addi	a0,a0,-1844 # 5e70 <malloc+0x674>
     5ac:	00005097          	auipc	ra,0x5
     5b0:	190080e7          	jalr	400(ra) # 573c <printf>
      exit(1);
     5b4:	4505                	li	a0,1
     5b6:	00005097          	auipc	ra,0x5
     5ba:	e0e080e7          	jalr	-498(ra) # 53c4 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5be:	862a                	mv	a2,a0
     5c0:	85ce                	mv	a1,s3
     5c2:	00006517          	auipc	a0,0x6
     5c6:	8c650513          	addi	a0,a0,-1850 # 5e88 <malloc+0x68c>
     5ca:	00005097          	auipc	ra,0x5
     5ce:	172080e7          	jalr	370(ra) # 573c <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	00005097          	auipc	ra,0x5
     5d8:	df0080e7          	jalr	-528(ra) # 53c4 <exit>
      printf("pipe() failed\n");
     5dc:	00006517          	auipc	a0,0x6
     5e0:	84c50513          	addi	a0,a0,-1972 # 5e28 <malloc+0x62c>
     5e4:	00005097          	auipc	ra,0x5
     5e8:	158080e7          	jalr	344(ra) # 573c <printf>
      exit(1);
     5ec:	4505                	li	a0,1
     5ee:	00005097          	auipc	ra,0x5
     5f2:	dd6080e7          	jalr	-554(ra) # 53c4 <exit>
      printf("pipe write failed\n");
     5f6:	00006517          	auipc	a0,0x6
     5fa:	8c250513          	addi	a0,a0,-1854 # 5eb8 <malloc+0x6bc>
     5fe:	00005097          	auipc	ra,0x5
     602:	13e080e7          	jalr	318(ra) # 573c <printf>
      exit(1);
     606:	4505                	li	a0,1
     608:	00005097          	auipc	ra,0x5
     60c:	dbc080e7          	jalr	-580(ra) # 53c4 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     610:	862a                	mv	a2,a0
     612:	85ce                	mv	a1,s3
     614:	00006517          	auipc	a0,0x6
     618:	8bc50513          	addi	a0,a0,-1860 # 5ed0 <malloc+0x6d4>
     61c:	00005097          	auipc	ra,0x5
     620:	120080e7          	jalr	288(ra) # 573c <printf>
      exit(1);
     624:	4505                	li	a0,1
     626:	00005097          	auipc	ra,0x5
     62a:	d9e080e7          	jalr	-610(ra) # 53c4 <exit>

000000000000062e <truncate1>:
{
     62e:	711d                	addi	sp,sp,-96
     630:	ec86                	sd	ra,88(sp)
     632:	e8a2                	sd	s0,80(sp)
     634:	e4a6                	sd	s1,72(sp)
     636:	e0ca                	sd	s2,64(sp)
     638:	fc4e                	sd	s3,56(sp)
     63a:	f852                	sd	s4,48(sp)
     63c:	f456                	sd	s5,40(sp)
     63e:	1080                	addi	s0,sp,96
     640:	8aaa                	mv	s5,a0
  unlink("truncfile");
     642:	00005517          	auipc	a0,0x5
     646:	6d650513          	addi	a0,a0,1750 # 5d18 <malloc+0x51c>
     64a:	00005097          	auipc	ra,0x5
     64e:	dca080e7          	jalr	-566(ra) # 5414 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     652:	60100593          	li	a1,1537
     656:	00005517          	auipc	a0,0x5
     65a:	6c250513          	addi	a0,a0,1730 # 5d18 <malloc+0x51c>
     65e:	00005097          	auipc	ra,0x5
     662:	da6080e7          	jalr	-602(ra) # 5404 <open>
     666:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     668:	4611                	li	a2,4
     66a:	00005597          	auipc	a1,0x5
     66e:	6be58593          	addi	a1,a1,1726 # 5d28 <malloc+0x52c>
     672:	00005097          	auipc	ra,0x5
     676:	d72080e7          	jalr	-654(ra) # 53e4 <write>
  close(fd1);
     67a:	8526                	mv	a0,s1
     67c:	00005097          	auipc	ra,0x5
     680:	d70080e7          	jalr	-656(ra) # 53ec <close>
  int fd2 = open("truncfile", O_RDONLY);
     684:	4581                	li	a1,0
     686:	00005517          	auipc	a0,0x5
     68a:	69250513          	addi	a0,a0,1682 # 5d18 <malloc+0x51c>
     68e:	00005097          	auipc	ra,0x5
     692:	d76080e7          	jalr	-650(ra) # 5404 <open>
     696:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     698:	02000613          	li	a2,32
     69c:	fa040593          	addi	a1,s0,-96
     6a0:	00005097          	auipc	ra,0x5
     6a4:	d3c080e7          	jalr	-708(ra) # 53dc <read>
  if(n != 4){
     6a8:	4791                	li	a5,4
     6aa:	0cf51e63          	bne	a0,a5,786 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     6ae:	40100593          	li	a1,1025
     6b2:	00005517          	auipc	a0,0x5
     6b6:	66650513          	addi	a0,a0,1638 # 5d18 <malloc+0x51c>
     6ba:	00005097          	auipc	ra,0x5
     6be:	d4a080e7          	jalr	-694(ra) # 5404 <open>
     6c2:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6c4:	4581                	li	a1,0
     6c6:	00005517          	auipc	a0,0x5
     6ca:	65250513          	addi	a0,a0,1618 # 5d18 <malloc+0x51c>
     6ce:	00005097          	auipc	ra,0x5
     6d2:	d36080e7          	jalr	-714(ra) # 5404 <open>
     6d6:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6d8:	02000613          	li	a2,32
     6dc:	fa040593          	addi	a1,s0,-96
     6e0:	00005097          	auipc	ra,0x5
     6e4:	cfc080e7          	jalr	-772(ra) # 53dc <read>
     6e8:	8a2a                	mv	s4,a0
  if(n != 0){
     6ea:	ed4d                	bnez	a0,7a4 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6ec:	02000613          	li	a2,32
     6f0:	fa040593          	addi	a1,s0,-96
     6f4:	8526                	mv	a0,s1
     6f6:	00005097          	auipc	ra,0x5
     6fa:	ce6080e7          	jalr	-794(ra) # 53dc <read>
     6fe:	8a2a                	mv	s4,a0
  if(n != 0){
     700:	e971                	bnez	a0,7d4 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     702:	4619                	li	a2,6
     704:	00006597          	auipc	a1,0x6
     708:	85c58593          	addi	a1,a1,-1956 # 5f60 <malloc+0x764>
     70c:	854e                	mv	a0,s3
     70e:	00005097          	auipc	ra,0x5
     712:	cd6080e7          	jalr	-810(ra) # 53e4 <write>
  n = read(fd3, buf, sizeof(buf));
     716:	02000613          	li	a2,32
     71a:	fa040593          	addi	a1,s0,-96
     71e:	854a                	mv	a0,s2
     720:	00005097          	auipc	ra,0x5
     724:	cbc080e7          	jalr	-836(ra) # 53dc <read>
  if(n != 6){
     728:	4799                	li	a5,6
     72a:	0cf51d63          	bne	a0,a5,804 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     72e:	02000613          	li	a2,32
     732:	fa040593          	addi	a1,s0,-96
     736:	8526                	mv	a0,s1
     738:	00005097          	auipc	ra,0x5
     73c:	ca4080e7          	jalr	-860(ra) # 53dc <read>
  if(n != 2){
     740:	4789                	li	a5,2
     742:	0ef51063          	bne	a0,a5,822 <truncate1+0x1f4>
  unlink("truncfile");
     746:	00005517          	auipc	a0,0x5
     74a:	5d250513          	addi	a0,a0,1490 # 5d18 <malloc+0x51c>
     74e:	00005097          	auipc	ra,0x5
     752:	cc6080e7          	jalr	-826(ra) # 5414 <unlink>
  close(fd1);
     756:	854e                	mv	a0,s3
     758:	00005097          	auipc	ra,0x5
     75c:	c94080e7          	jalr	-876(ra) # 53ec <close>
  close(fd2);
     760:	8526                	mv	a0,s1
     762:	00005097          	auipc	ra,0x5
     766:	c8a080e7          	jalr	-886(ra) # 53ec <close>
  close(fd3);
     76a:	854a                	mv	a0,s2
     76c:	00005097          	auipc	ra,0x5
     770:	c80080e7          	jalr	-896(ra) # 53ec <close>
}
     774:	60e6                	ld	ra,88(sp)
     776:	6446                	ld	s0,80(sp)
     778:	64a6                	ld	s1,72(sp)
     77a:	6906                	ld	s2,64(sp)
     77c:	79e2                	ld	s3,56(sp)
     77e:	7a42                	ld	s4,48(sp)
     780:	7aa2                	ld	s5,40(sp)
     782:	6125                	addi	sp,sp,96
     784:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     786:	862a                	mv	a2,a0
     788:	85d6                	mv	a1,s5
     78a:	00005517          	auipc	a0,0x5
     78e:	77650513          	addi	a0,a0,1910 # 5f00 <malloc+0x704>
     792:	00005097          	auipc	ra,0x5
     796:	faa080e7          	jalr	-86(ra) # 573c <printf>
    exit(1);
     79a:	4505                	li	a0,1
     79c:	00005097          	auipc	ra,0x5
     7a0:	c28080e7          	jalr	-984(ra) # 53c4 <exit>
    printf("aaa fd3=%d\n", fd3);
     7a4:	85ca                	mv	a1,s2
     7a6:	00005517          	auipc	a0,0x5
     7aa:	77a50513          	addi	a0,a0,1914 # 5f20 <malloc+0x724>
     7ae:	00005097          	auipc	ra,0x5
     7b2:	f8e080e7          	jalr	-114(ra) # 573c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7b6:	8652                	mv	a2,s4
     7b8:	85d6                	mv	a1,s5
     7ba:	00005517          	auipc	a0,0x5
     7be:	77650513          	addi	a0,a0,1910 # 5f30 <malloc+0x734>
     7c2:	00005097          	auipc	ra,0x5
     7c6:	f7a080e7          	jalr	-134(ra) # 573c <printf>
    exit(1);
     7ca:	4505                	li	a0,1
     7cc:	00005097          	auipc	ra,0x5
     7d0:	bf8080e7          	jalr	-1032(ra) # 53c4 <exit>
    printf("bbb fd2=%d\n", fd2);
     7d4:	85a6                	mv	a1,s1
     7d6:	00005517          	auipc	a0,0x5
     7da:	77a50513          	addi	a0,a0,1914 # 5f50 <malloc+0x754>
     7de:	00005097          	auipc	ra,0x5
     7e2:	f5e080e7          	jalr	-162(ra) # 573c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7e6:	8652                	mv	a2,s4
     7e8:	85d6                	mv	a1,s5
     7ea:	00005517          	auipc	a0,0x5
     7ee:	74650513          	addi	a0,a0,1862 # 5f30 <malloc+0x734>
     7f2:	00005097          	auipc	ra,0x5
     7f6:	f4a080e7          	jalr	-182(ra) # 573c <printf>
    exit(1);
     7fa:	4505                	li	a0,1
     7fc:	00005097          	auipc	ra,0x5
     800:	bc8080e7          	jalr	-1080(ra) # 53c4 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     804:	862a                	mv	a2,a0
     806:	85d6                	mv	a1,s5
     808:	00005517          	auipc	a0,0x5
     80c:	76050513          	addi	a0,a0,1888 # 5f68 <malloc+0x76c>
     810:	00005097          	auipc	ra,0x5
     814:	f2c080e7          	jalr	-212(ra) # 573c <printf>
    exit(1);
     818:	4505                	li	a0,1
     81a:	00005097          	auipc	ra,0x5
     81e:	baa080e7          	jalr	-1110(ra) # 53c4 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     822:	862a                	mv	a2,a0
     824:	85d6                	mv	a1,s5
     826:	00005517          	auipc	a0,0x5
     82a:	76250513          	addi	a0,a0,1890 # 5f88 <malloc+0x78c>
     82e:	00005097          	auipc	ra,0x5
     832:	f0e080e7          	jalr	-242(ra) # 573c <printf>
    exit(1);
     836:	4505                	li	a0,1
     838:	00005097          	auipc	ra,0x5
     83c:	b8c080e7          	jalr	-1140(ra) # 53c4 <exit>

0000000000000840 <writetest>:
{
     840:	7139                	addi	sp,sp,-64
     842:	fc06                	sd	ra,56(sp)
     844:	f822                	sd	s0,48(sp)
     846:	f426                	sd	s1,40(sp)
     848:	f04a                	sd	s2,32(sp)
     84a:	ec4e                	sd	s3,24(sp)
     84c:	e852                	sd	s4,16(sp)
     84e:	e456                	sd	s5,8(sp)
     850:	e05a                	sd	s6,0(sp)
     852:	0080                	addi	s0,sp,64
     854:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     856:	20200593          	li	a1,514
     85a:	00005517          	auipc	a0,0x5
     85e:	74e50513          	addi	a0,a0,1870 # 5fa8 <malloc+0x7ac>
     862:	00005097          	auipc	ra,0x5
     866:	ba2080e7          	jalr	-1118(ra) # 5404 <open>
  if(fd < 0){
     86a:	0a054d63          	bltz	a0,924 <writetest+0xe4>
     86e:	892a                	mv	s2,a0
     870:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     872:	00005997          	auipc	s3,0x5
     876:	75e98993          	addi	s3,s3,1886 # 5fd0 <malloc+0x7d4>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     87a:	00005a97          	auipc	s5,0x5
     87e:	78ea8a93          	addi	s5,s5,1934 # 6008 <malloc+0x80c>
  for(i = 0; i < N; i++){
     882:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     886:	4629                	li	a2,10
     888:	85ce                	mv	a1,s3
     88a:	854a                	mv	a0,s2
     88c:	00005097          	auipc	ra,0x5
     890:	b58080e7          	jalr	-1192(ra) # 53e4 <write>
     894:	47a9                	li	a5,10
     896:	0af51563          	bne	a0,a5,940 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     89a:	4629                	li	a2,10
     89c:	85d6                	mv	a1,s5
     89e:	854a                	mv	a0,s2
     8a0:	00005097          	auipc	ra,0x5
     8a4:	b44080e7          	jalr	-1212(ra) # 53e4 <write>
     8a8:	47a9                	li	a5,10
     8aa:	0af51963          	bne	a0,a5,95c <writetest+0x11c>
  for(i = 0; i < N; i++){
     8ae:	2485                	addiw	s1,s1,1
     8b0:	fd449be3          	bne	s1,s4,886 <writetest+0x46>
  close(fd);
     8b4:	854a                	mv	a0,s2
     8b6:	00005097          	auipc	ra,0x5
     8ba:	b36080e7          	jalr	-1226(ra) # 53ec <close>
  fd = open("small", O_RDONLY);
     8be:	4581                	li	a1,0
     8c0:	00005517          	auipc	a0,0x5
     8c4:	6e850513          	addi	a0,a0,1768 # 5fa8 <malloc+0x7ac>
     8c8:	00005097          	auipc	ra,0x5
     8cc:	b3c080e7          	jalr	-1220(ra) # 5404 <open>
     8d0:	84aa                	mv	s1,a0
  if(fd < 0){
     8d2:	0a054363          	bltz	a0,978 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     8d6:	7d000613          	li	a2,2000
     8da:	0000b597          	auipc	a1,0xb
     8de:	eae58593          	addi	a1,a1,-338 # b788 <buf>
     8e2:	00005097          	auipc	ra,0x5
     8e6:	afa080e7          	jalr	-1286(ra) # 53dc <read>
  if(i != N*SZ*2){
     8ea:	7d000793          	li	a5,2000
     8ee:	0af51363          	bne	a0,a5,994 <writetest+0x154>
  close(fd);
     8f2:	8526                	mv	a0,s1
     8f4:	00005097          	auipc	ra,0x5
     8f8:	af8080e7          	jalr	-1288(ra) # 53ec <close>
  if(unlink("small") < 0){
     8fc:	00005517          	auipc	a0,0x5
     900:	6ac50513          	addi	a0,a0,1708 # 5fa8 <malloc+0x7ac>
     904:	00005097          	auipc	ra,0x5
     908:	b10080e7          	jalr	-1264(ra) # 5414 <unlink>
     90c:	0a054263          	bltz	a0,9b0 <writetest+0x170>
}
     910:	70e2                	ld	ra,56(sp)
     912:	7442                	ld	s0,48(sp)
     914:	74a2                	ld	s1,40(sp)
     916:	7902                	ld	s2,32(sp)
     918:	69e2                	ld	s3,24(sp)
     91a:	6a42                	ld	s4,16(sp)
     91c:	6aa2                	ld	s5,8(sp)
     91e:	6b02                	ld	s6,0(sp)
     920:	6121                	addi	sp,sp,64
     922:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     924:	85da                	mv	a1,s6
     926:	00005517          	auipc	a0,0x5
     92a:	68a50513          	addi	a0,a0,1674 # 5fb0 <malloc+0x7b4>
     92e:	00005097          	auipc	ra,0x5
     932:	e0e080e7          	jalr	-498(ra) # 573c <printf>
    exit(1);
     936:	4505                	li	a0,1
     938:	00005097          	auipc	ra,0x5
     93c:	a8c080e7          	jalr	-1396(ra) # 53c4 <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     940:	85a6                	mv	a1,s1
     942:	00005517          	auipc	a0,0x5
     946:	69e50513          	addi	a0,a0,1694 # 5fe0 <malloc+0x7e4>
     94a:	00005097          	auipc	ra,0x5
     94e:	df2080e7          	jalr	-526(ra) # 573c <printf>
      exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	a70080e7          	jalr	-1424(ra) # 53c4 <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     95c:	85a6                	mv	a1,s1
     95e:	00005517          	auipc	a0,0x5
     962:	6ba50513          	addi	a0,a0,1722 # 6018 <malloc+0x81c>
     966:	00005097          	auipc	ra,0x5
     96a:	dd6080e7          	jalr	-554(ra) # 573c <printf>
      exit(1);
     96e:	4505                	li	a0,1
     970:	00005097          	auipc	ra,0x5
     974:	a54080e7          	jalr	-1452(ra) # 53c4 <exit>
    printf("%s: error: open small failed!\n", s);
     978:	85da                	mv	a1,s6
     97a:	00005517          	auipc	a0,0x5
     97e:	6c650513          	addi	a0,a0,1734 # 6040 <malloc+0x844>
     982:	00005097          	auipc	ra,0x5
     986:	dba080e7          	jalr	-582(ra) # 573c <printf>
    exit(1);
     98a:	4505                	li	a0,1
     98c:	00005097          	auipc	ra,0x5
     990:	a38080e7          	jalr	-1480(ra) # 53c4 <exit>
    printf("%s: read failed\n", s);
     994:	85da                	mv	a1,s6
     996:	00005517          	auipc	a0,0x5
     99a:	6ca50513          	addi	a0,a0,1738 # 6060 <malloc+0x864>
     99e:	00005097          	auipc	ra,0x5
     9a2:	d9e080e7          	jalr	-610(ra) # 573c <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	00005097          	auipc	ra,0x5
     9ac:	a1c080e7          	jalr	-1508(ra) # 53c4 <exit>
    printf("%s: unlink small failed\n", s);
     9b0:	85da                	mv	a1,s6
     9b2:	00005517          	auipc	a0,0x5
     9b6:	6c650513          	addi	a0,a0,1734 # 6078 <malloc+0x87c>
     9ba:	00005097          	auipc	ra,0x5
     9be:	d82080e7          	jalr	-638(ra) # 573c <printf>
    exit(1);
     9c2:	4505                	li	a0,1
     9c4:	00005097          	auipc	ra,0x5
     9c8:	a00080e7          	jalr	-1536(ra) # 53c4 <exit>

00000000000009cc <writebig>:
{
     9cc:	7139                	addi	sp,sp,-64
     9ce:	fc06                	sd	ra,56(sp)
     9d0:	f822                	sd	s0,48(sp)
     9d2:	f426                	sd	s1,40(sp)
     9d4:	f04a                	sd	s2,32(sp)
     9d6:	ec4e                	sd	s3,24(sp)
     9d8:	e852                	sd	s4,16(sp)
     9da:	e456                	sd	s5,8(sp)
     9dc:	0080                	addi	s0,sp,64
     9de:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9e0:	20200593          	li	a1,514
     9e4:	00005517          	auipc	a0,0x5
     9e8:	6b450513          	addi	a0,a0,1716 # 6098 <malloc+0x89c>
     9ec:	00005097          	auipc	ra,0x5
     9f0:	a18080e7          	jalr	-1512(ra) # 5404 <open>
     9f4:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9f6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9f8:	0000b917          	auipc	s2,0xb
     9fc:	d9090913          	addi	s2,s2,-624 # b788 <buf>
  for(i = 0; i < MAXFILE; i++){
     a00:	10c00a13          	li	s4,268
  if(fd < 0){
     a04:	06054c63          	bltz	a0,a7c <writebig+0xb0>
    ((int*)buf)[0] = i;
     a08:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     a0c:	40000613          	li	a2,1024
     a10:	85ca                	mv	a1,s2
     a12:	854e                	mv	a0,s3
     a14:	00005097          	auipc	ra,0x5
     a18:	9d0080e7          	jalr	-1584(ra) # 53e4 <write>
     a1c:	40000793          	li	a5,1024
     a20:	06f51c63          	bne	a0,a5,a98 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a24:	2485                	addiw	s1,s1,1
     a26:	ff4491e3          	bne	s1,s4,a08 <writebig+0x3c>
  close(fd);
     a2a:	854e                	mv	a0,s3
     a2c:	00005097          	auipc	ra,0x5
     a30:	9c0080e7          	jalr	-1600(ra) # 53ec <close>
  fd = open("big", O_RDONLY);
     a34:	4581                	li	a1,0
     a36:	00005517          	auipc	a0,0x5
     a3a:	66250513          	addi	a0,a0,1634 # 6098 <malloc+0x89c>
     a3e:	00005097          	auipc	ra,0x5
     a42:	9c6080e7          	jalr	-1594(ra) # 5404 <open>
     a46:	89aa                	mv	s3,a0
  n = 0;
     a48:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a4a:	0000b917          	auipc	s2,0xb
     a4e:	d3e90913          	addi	s2,s2,-706 # b788 <buf>
  if(fd < 0){
     a52:	06054163          	bltz	a0,ab4 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     a56:	40000613          	li	a2,1024
     a5a:	85ca                	mv	a1,s2
     a5c:	854e                	mv	a0,s3
     a5e:	00005097          	auipc	ra,0x5
     a62:	97e080e7          	jalr	-1666(ra) # 53dc <read>
    if(i == 0){
     a66:	c52d                	beqz	a0,ad0 <writebig+0x104>
    } else if(i != BSIZE){
     a68:	40000793          	li	a5,1024
     a6c:	0af51d63          	bne	a0,a5,b26 <writebig+0x15a>
    if(((int*)buf)[0] != n){
     a70:	00092603          	lw	a2,0(s2)
     a74:	0c961763          	bne	a2,s1,b42 <writebig+0x176>
    n++;
     a78:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a7a:	bff1                	j	a56 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a7c:	85d6                	mv	a1,s5
     a7e:	00005517          	auipc	a0,0x5
     a82:	62250513          	addi	a0,a0,1570 # 60a0 <malloc+0x8a4>
     a86:	00005097          	auipc	ra,0x5
     a8a:	cb6080e7          	jalr	-842(ra) # 573c <printf>
    exit(1);
     a8e:	4505                	li	a0,1
     a90:	00005097          	auipc	ra,0x5
     a94:	934080e7          	jalr	-1740(ra) # 53c4 <exit>
      printf("%s: error: write big file failed\n", i);
     a98:	85a6                	mv	a1,s1
     a9a:	00005517          	auipc	a0,0x5
     a9e:	62650513          	addi	a0,a0,1574 # 60c0 <malloc+0x8c4>
     aa2:	00005097          	auipc	ra,0x5
     aa6:	c9a080e7          	jalr	-870(ra) # 573c <printf>
      exit(1);
     aaa:	4505                	li	a0,1
     aac:	00005097          	auipc	ra,0x5
     ab0:	918080e7          	jalr	-1768(ra) # 53c4 <exit>
    printf("%s: error: open big failed!\n", s);
     ab4:	85d6                	mv	a1,s5
     ab6:	00005517          	auipc	a0,0x5
     aba:	63250513          	addi	a0,a0,1586 # 60e8 <malloc+0x8ec>
     abe:	00005097          	auipc	ra,0x5
     ac2:	c7e080e7          	jalr	-898(ra) # 573c <printf>
    exit(1);
     ac6:	4505                	li	a0,1
     ac8:	00005097          	auipc	ra,0x5
     acc:	8fc080e7          	jalr	-1796(ra) # 53c4 <exit>
      if(n == MAXFILE - 1){
     ad0:	10b00793          	li	a5,267
     ad4:	02f48a63          	beq	s1,a5,b08 <writebig+0x13c>
  close(fd);
     ad8:	854e                	mv	a0,s3
     ada:	00005097          	auipc	ra,0x5
     ade:	912080e7          	jalr	-1774(ra) # 53ec <close>
  if(unlink("big") < 0){
     ae2:	00005517          	auipc	a0,0x5
     ae6:	5b650513          	addi	a0,a0,1462 # 6098 <malloc+0x89c>
     aea:	00005097          	auipc	ra,0x5
     aee:	92a080e7          	jalr	-1750(ra) # 5414 <unlink>
     af2:	06054663          	bltz	a0,b5e <writebig+0x192>
}
     af6:	70e2                	ld	ra,56(sp)
     af8:	7442                	ld	s0,48(sp)
     afa:	74a2                	ld	s1,40(sp)
     afc:	7902                	ld	s2,32(sp)
     afe:	69e2                	ld	s3,24(sp)
     b00:	6a42                	ld	s4,16(sp)
     b02:	6aa2                	ld	s5,8(sp)
     b04:	6121                	addi	sp,sp,64
     b06:	8082                	ret
        printf("%s: read only %d blocks from big", n);
     b08:	10b00593          	li	a1,267
     b0c:	00005517          	auipc	a0,0x5
     b10:	5fc50513          	addi	a0,a0,1532 # 6108 <malloc+0x90c>
     b14:	00005097          	auipc	ra,0x5
     b18:	c28080e7          	jalr	-984(ra) # 573c <printf>
        exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00005097          	auipc	ra,0x5
     b22:	8a6080e7          	jalr	-1882(ra) # 53c4 <exit>
      printf("%s: read failed %d\n", i);
     b26:	85aa                	mv	a1,a0
     b28:	00005517          	auipc	a0,0x5
     b2c:	60850513          	addi	a0,a0,1544 # 6130 <malloc+0x934>
     b30:	00005097          	auipc	ra,0x5
     b34:	c0c080e7          	jalr	-1012(ra) # 573c <printf>
      exit(1);
     b38:	4505                	li	a0,1
     b3a:	00005097          	auipc	ra,0x5
     b3e:	88a080e7          	jalr	-1910(ra) # 53c4 <exit>
      printf("%s: read content of block %d is %d\n",
     b42:	85a6                	mv	a1,s1
     b44:	00005517          	auipc	a0,0x5
     b48:	60450513          	addi	a0,a0,1540 # 6148 <malloc+0x94c>
     b4c:	00005097          	auipc	ra,0x5
     b50:	bf0080e7          	jalr	-1040(ra) # 573c <printf>
      exit(1);
     b54:	4505                	li	a0,1
     b56:	00005097          	auipc	ra,0x5
     b5a:	86e080e7          	jalr	-1938(ra) # 53c4 <exit>
    printf("%s: unlink big failed\n", s);
     b5e:	85d6                	mv	a1,s5
     b60:	00005517          	auipc	a0,0x5
     b64:	61050513          	addi	a0,a0,1552 # 6170 <malloc+0x974>
     b68:	00005097          	auipc	ra,0x5
     b6c:	bd4080e7          	jalr	-1068(ra) # 573c <printf>
    exit(1);
     b70:	4505                	li	a0,1
     b72:	00005097          	auipc	ra,0x5
     b76:	852080e7          	jalr	-1966(ra) # 53c4 <exit>

0000000000000b7a <unlinkread>:
{
     b7a:	7179                	addi	sp,sp,-48
     b7c:	f406                	sd	ra,40(sp)
     b7e:	f022                	sd	s0,32(sp)
     b80:	ec26                	sd	s1,24(sp)
     b82:	e84a                	sd	s2,16(sp)
     b84:	e44e                	sd	s3,8(sp)
     b86:	1800                	addi	s0,sp,48
     b88:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b8a:	20200593          	li	a1,514
     b8e:	00005517          	auipc	a0,0x5
     b92:	5fa50513          	addi	a0,a0,1530 # 6188 <malloc+0x98c>
     b96:	00005097          	auipc	ra,0x5
     b9a:	86e080e7          	jalr	-1938(ra) # 5404 <open>
  if(fd < 0){
     b9e:	0e054563          	bltz	a0,c88 <unlinkread+0x10e>
     ba2:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     ba4:	4615                	li	a2,5
     ba6:	00005597          	auipc	a1,0x5
     baa:	61258593          	addi	a1,a1,1554 # 61b8 <malloc+0x9bc>
     bae:	00005097          	auipc	ra,0x5
     bb2:	836080e7          	jalr	-1994(ra) # 53e4 <write>
  close(fd);
     bb6:	8526                	mv	a0,s1
     bb8:	00005097          	auipc	ra,0x5
     bbc:	834080e7          	jalr	-1996(ra) # 53ec <close>
  fd = open("unlinkread", O_RDWR);
     bc0:	4589                	li	a1,2
     bc2:	00005517          	auipc	a0,0x5
     bc6:	5c650513          	addi	a0,a0,1478 # 6188 <malloc+0x98c>
     bca:	00005097          	auipc	ra,0x5
     bce:	83a080e7          	jalr	-1990(ra) # 5404 <open>
     bd2:	84aa                	mv	s1,a0
  if(fd < 0){
     bd4:	0c054863          	bltz	a0,ca4 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bd8:	00005517          	auipc	a0,0x5
     bdc:	5b050513          	addi	a0,a0,1456 # 6188 <malloc+0x98c>
     be0:	00005097          	auipc	ra,0x5
     be4:	834080e7          	jalr	-1996(ra) # 5414 <unlink>
     be8:	ed61                	bnez	a0,cc0 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bea:	20200593          	li	a1,514
     bee:	00005517          	auipc	a0,0x5
     bf2:	59a50513          	addi	a0,a0,1434 # 6188 <malloc+0x98c>
     bf6:	00005097          	auipc	ra,0x5
     bfa:	80e080e7          	jalr	-2034(ra) # 5404 <open>
     bfe:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     c00:	460d                	li	a2,3
     c02:	00005597          	auipc	a1,0x5
     c06:	5fe58593          	addi	a1,a1,1534 # 6200 <malloc+0xa04>
     c0a:	00004097          	auipc	ra,0x4
     c0e:	7da080e7          	jalr	2010(ra) # 53e4 <write>
  close(fd1);
     c12:	854a                	mv	a0,s2
     c14:	00004097          	auipc	ra,0x4
     c18:	7d8080e7          	jalr	2008(ra) # 53ec <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c1c:	660d                	lui	a2,0x3
     c1e:	0000b597          	auipc	a1,0xb
     c22:	b6a58593          	addi	a1,a1,-1174 # b788 <buf>
     c26:	8526                	mv	a0,s1
     c28:	00004097          	auipc	ra,0x4
     c2c:	7b4080e7          	jalr	1972(ra) # 53dc <read>
     c30:	4795                	li	a5,5
     c32:	0af51563          	bne	a0,a5,cdc <unlinkread+0x162>
  if(buf[0] != 'h'){
     c36:	0000b717          	auipc	a4,0xb
     c3a:	b5274703          	lbu	a4,-1198(a4) # b788 <buf>
     c3e:	06800793          	li	a5,104
     c42:	0af71b63          	bne	a4,a5,cf8 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c46:	4629                	li	a2,10
     c48:	0000b597          	auipc	a1,0xb
     c4c:	b4058593          	addi	a1,a1,-1216 # b788 <buf>
     c50:	8526                	mv	a0,s1
     c52:	00004097          	auipc	ra,0x4
     c56:	792080e7          	jalr	1938(ra) # 53e4 <write>
     c5a:	47a9                	li	a5,10
     c5c:	0af51c63          	bne	a0,a5,d14 <unlinkread+0x19a>
  close(fd);
     c60:	8526                	mv	a0,s1
     c62:	00004097          	auipc	ra,0x4
     c66:	78a080e7          	jalr	1930(ra) # 53ec <close>
  unlink("unlinkread");
     c6a:	00005517          	auipc	a0,0x5
     c6e:	51e50513          	addi	a0,a0,1310 # 6188 <malloc+0x98c>
     c72:	00004097          	auipc	ra,0x4
     c76:	7a2080e7          	jalr	1954(ra) # 5414 <unlink>
}
     c7a:	70a2                	ld	ra,40(sp)
     c7c:	7402                	ld	s0,32(sp)
     c7e:	64e2                	ld	s1,24(sp)
     c80:	6942                	ld	s2,16(sp)
     c82:	69a2                	ld	s3,8(sp)
     c84:	6145                	addi	sp,sp,48
     c86:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c88:	85ce                	mv	a1,s3
     c8a:	00005517          	auipc	a0,0x5
     c8e:	50e50513          	addi	a0,a0,1294 # 6198 <malloc+0x99c>
     c92:	00005097          	auipc	ra,0x5
     c96:	aaa080e7          	jalr	-1366(ra) # 573c <printf>
    exit(1);
     c9a:	4505                	li	a0,1
     c9c:	00004097          	auipc	ra,0x4
     ca0:	728080e7          	jalr	1832(ra) # 53c4 <exit>
    printf("%s: open unlinkread failed\n", s);
     ca4:	85ce                	mv	a1,s3
     ca6:	00005517          	auipc	a0,0x5
     caa:	51a50513          	addi	a0,a0,1306 # 61c0 <malloc+0x9c4>
     cae:	00005097          	auipc	ra,0x5
     cb2:	a8e080e7          	jalr	-1394(ra) # 573c <printf>
    exit(1);
     cb6:	4505                	li	a0,1
     cb8:	00004097          	auipc	ra,0x4
     cbc:	70c080e7          	jalr	1804(ra) # 53c4 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cc0:	85ce                	mv	a1,s3
     cc2:	00005517          	auipc	a0,0x5
     cc6:	51e50513          	addi	a0,a0,1310 # 61e0 <malloc+0x9e4>
     cca:	00005097          	auipc	ra,0x5
     cce:	a72080e7          	jalr	-1422(ra) # 573c <printf>
    exit(1);
     cd2:	4505                	li	a0,1
     cd4:	00004097          	auipc	ra,0x4
     cd8:	6f0080e7          	jalr	1776(ra) # 53c4 <exit>
    printf("%s: unlinkread read failed", s);
     cdc:	85ce                	mv	a1,s3
     cde:	00005517          	auipc	a0,0x5
     ce2:	52a50513          	addi	a0,a0,1322 # 6208 <malloc+0xa0c>
     ce6:	00005097          	auipc	ra,0x5
     cea:	a56080e7          	jalr	-1450(ra) # 573c <printf>
    exit(1);
     cee:	4505                	li	a0,1
     cf0:	00004097          	auipc	ra,0x4
     cf4:	6d4080e7          	jalr	1748(ra) # 53c4 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cf8:	85ce                	mv	a1,s3
     cfa:	00005517          	auipc	a0,0x5
     cfe:	52e50513          	addi	a0,a0,1326 # 6228 <malloc+0xa2c>
     d02:	00005097          	auipc	ra,0x5
     d06:	a3a080e7          	jalr	-1478(ra) # 573c <printf>
    exit(1);
     d0a:	4505                	li	a0,1
     d0c:	00004097          	auipc	ra,0x4
     d10:	6b8080e7          	jalr	1720(ra) # 53c4 <exit>
    printf("%s: unlinkread write failed\n", s);
     d14:	85ce                	mv	a1,s3
     d16:	00005517          	auipc	a0,0x5
     d1a:	53250513          	addi	a0,a0,1330 # 6248 <malloc+0xa4c>
     d1e:	00005097          	auipc	ra,0x5
     d22:	a1e080e7          	jalr	-1506(ra) # 573c <printf>
    exit(1);
     d26:	4505                	li	a0,1
     d28:	00004097          	auipc	ra,0x4
     d2c:	69c080e7          	jalr	1692(ra) # 53c4 <exit>

0000000000000d30 <linktest>:
{
     d30:	1101                	addi	sp,sp,-32
     d32:	ec06                	sd	ra,24(sp)
     d34:	e822                	sd	s0,16(sp)
     d36:	e426                	sd	s1,8(sp)
     d38:	e04a                	sd	s2,0(sp)
     d3a:	1000                	addi	s0,sp,32
     d3c:	892a                	mv	s2,a0
  unlink("lf1");
     d3e:	00005517          	auipc	a0,0x5
     d42:	52a50513          	addi	a0,a0,1322 # 6268 <malloc+0xa6c>
     d46:	00004097          	auipc	ra,0x4
     d4a:	6ce080e7          	jalr	1742(ra) # 5414 <unlink>
  unlink("lf2");
     d4e:	00005517          	auipc	a0,0x5
     d52:	52250513          	addi	a0,a0,1314 # 6270 <malloc+0xa74>
     d56:	00004097          	auipc	ra,0x4
     d5a:	6be080e7          	jalr	1726(ra) # 5414 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d5e:	20200593          	li	a1,514
     d62:	00005517          	auipc	a0,0x5
     d66:	50650513          	addi	a0,a0,1286 # 6268 <malloc+0xa6c>
     d6a:	00004097          	auipc	ra,0x4
     d6e:	69a080e7          	jalr	1690(ra) # 5404 <open>
  if(fd < 0){
     d72:	10054763          	bltz	a0,e80 <linktest+0x150>
     d76:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d78:	4615                	li	a2,5
     d7a:	00005597          	auipc	a1,0x5
     d7e:	43e58593          	addi	a1,a1,1086 # 61b8 <malloc+0x9bc>
     d82:	00004097          	auipc	ra,0x4
     d86:	662080e7          	jalr	1634(ra) # 53e4 <write>
     d8a:	4795                	li	a5,5
     d8c:	10f51863          	bne	a0,a5,e9c <linktest+0x16c>
  close(fd);
     d90:	8526                	mv	a0,s1
     d92:	00004097          	auipc	ra,0x4
     d96:	65a080e7          	jalr	1626(ra) # 53ec <close>
  if(link("lf1", "lf2") < 0){
     d9a:	00005597          	auipc	a1,0x5
     d9e:	4d658593          	addi	a1,a1,1238 # 6270 <malloc+0xa74>
     da2:	00005517          	auipc	a0,0x5
     da6:	4c650513          	addi	a0,a0,1222 # 6268 <malloc+0xa6c>
     daa:	00004097          	auipc	ra,0x4
     dae:	67a080e7          	jalr	1658(ra) # 5424 <link>
     db2:	10054363          	bltz	a0,eb8 <linktest+0x188>
  unlink("lf1");
     db6:	00005517          	auipc	a0,0x5
     dba:	4b250513          	addi	a0,a0,1202 # 6268 <malloc+0xa6c>
     dbe:	00004097          	auipc	ra,0x4
     dc2:	656080e7          	jalr	1622(ra) # 5414 <unlink>
  if(open("lf1", 0) >= 0){
     dc6:	4581                	li	a1,0
     dc8:	00005517          	auipc	a0,0x5
     dcc:	4a050513          	addi	a0,a0,1184 # 6268 <malloc+0xa6c>
     dd0:	00004097          	auipc	ra,0x4
     dd4:	634080e7          	jalr	1588(ra) # 5404 <open>
     dd8:	0e055e63          	bgez	a0,ed4 <linktest+0x1a4>
  fd = open("lf2", 0);
     ddc:	4581                	li	a1,0
     dde:	00005517          	auipc	a0,0x5
     de2:	49250513          	addi	a0,a0,1170 # 6270 <malloc+0xa74>
     de6:	00004097          	auipc	ra,0x4
     dea:	61e080e7          	jalr	1566(ra) # 5404 <open>
     dee:	84aa                	mv	s1,a0
  if(fd < 0){
     df0:	10054063          	bltz	a0,ef0 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     df4:	660d                	lui	a2,0x3
     df6:	0000b597          	auipc	a1,0xb
     dfa:	99258593          	addi	a1,a1,-1646 # b788 <buf>
     dfe:	00004097          	auipc	ra,0x4
     e02:	5de080e7          	jalr	1502(ra) # 53dc <read>
     e06:	4795                	li	a5,5
     e08:	10f51263          	bne	a0,a5,f0c <linktest+0x1dc>
  close(fd);
     e0c:	8526                	mv	a0,s1
     e0e:	00004097          	auipc	ra,0x4
     e12:	5de080e7          	jalr	1502(ra) # 53ec <close>
  if(link("lf2", "lf2") >= 0){
     e16:	00005597          	auipc	a1,0x5
     e1a:	45a58593          	addi	a1,a1,1114 # 6270 <malloc+0xa74>
     e1e:	852e                	mv	a0,a1
     e20:	00004097          	auipc	ra,0x4
     e24:	604080e7          	jalr	1540(ra) # 5424 <link>
     e28:	10055063          	bgez	a0,f28 <linktest+0x1f8>
  unlink("lf2");
     e2c:	00005517          	auipc	a0,0x5
     e30:	44450513          	addi	a0,a0,1092 # 6270 <malloc+0xa74>
     e34:	00004097          	auipc	ra,0x4
     e38:	5e0080e7          	jalr	1504(ra) # 5414 <unlink>
  if(link("lf2", "lf1") >= 0){
     e3c:	00005597          	auipc	a1,0x5
     e40:	42c58593          	addi	a1,a1,1068 # 6268 <malloc+0xa6c>
     e44:	00005517          	auipc	a0,0x5
     e48:	42c50513          	addi	a0,a0,1068 # 6270 <malloc+0xa74>
     e4c:	00004097          	auipc	ra,0x4
     e50:	5d8080e7          	jalr	1496(ra) # 5424 <link>
     e54:	0e055863          	bgez	a0,f44 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e58:	00005597          	auipc	a1,0x5
     e5c:	41058593          	addi	a1,a1,1040 # 6268 <malloc+0xa6c>
     e60:	00005517          	auipc	a0,0x5
     e64:	51850513          	addi	a0,a0,1304 # 6378 <malloc+0xb7c>
     e68:	00004097          	auipc	ra,0x4
     e6c:	5bc080e7          	jalr	1468(ra) # 5424 <link>
     e70:	0e055863          	bgez	a0,f60 <linktest+0x230>
}
     e74:	60e2                	ld	ra,24(sp)
     e76:	6442                	ld	s0,16(sp)
     e78:	64a2                	ld	s1,8(sp)
     e7a:	6902                	ld	s2,0(sp)
     e7c:	6105                	addi	sp,sp,32
     e7e:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e80:	85ca                	mv	a1,s2
     e82:	00005517          	auipc	a0,0x5
     e86:	3f650513          	addi	a0,a0,1014 # 6278 <malloc+0xa7c>
     e8a:	00005097          	auipc	ra,0x5
     e8e:	8b2080e7          	jalr	-1870(ra) # 573c <printf>
    exit(1);
     e92:	4505                	li	a0,1
     e94:	00004097          	auipc	ra,0x4
     e98:	530080e7          	jalr	1328(ra) # 53c4 <exit>
    printf("%s: write lf1 failed\n", s);
     e9c:	85ca                	mv	a1,s2
     e9e:	00005517          	auipc	a0,0x5
     ea2:	3f250513          	addi	a0,a0,1010 # 6290 <malloc+0xa94>
     ea6:	00005097          	auipc	ra,0x5
     eaa:	896080e7          	jalr	-1898(ra) # 573c <printf>
    exit(1);
     eae:	4505                	li	a0,1
     eb0:	00004097          	auipc	ra,0x4
     eb4:	514080e7          	jalr	1300(ra) # 53c4 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     eb8:	85ca                	mv	a1,s2
     eba:	00005517          	auipc	a0,0x5
     ebe:	3ee50513          	addi	a0,a0,1006 # 62a8 <malloc+0xaac>
     ec2:	00005097          	auipc	ra,0x5
     ec6:	87a080e7          	jalr	-1926(ra) # 573c <printf>
    exit(1);
     eca:	4505                	li	a0,1
     ecc:	00004097          	auipc	ra,0x4
     ed0:	4f8080e7          	jalr	1272(ra) # 53c4 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ed4:	85ca                	mv	a1,s2
     ed6:	00005517          	auipc	a0,0x5
     eda:	3f250513          	addi	a0,a0,1010 # 62c8 <malloc+0xacc>
     ede:	00005097          	auipc	ra,0x5
     ee2:	85e080e7          	jalr	-1954(ra) # 573c <printf>
    exit(1);
     ee6:	4505                	li	a0,1
     ee8:	00004097          	auipc	ra,0x4
     eec:	4dc080e7          	jalr	1244(ra) # 53c4 <exit>
    printf("%s: open lf2 failed\n", s);
     ef0:	85ca                	mv	a1,s2
     ef2:	00005517          	auipc	a0,0x5
     ef6:	40650513          	addi	a0,a0,1030 # 62f8 <malloc+0xafc>
     efa:	00005097          	auipc	ra,0x5
     efe:	842080e7          	jalr	-1982(ra) # 573c <printf>
    exit(1);
     f02:	4505                	li	a0,1
     f04:	00004097          	auipc	ra,0x4
     f08:	4c0080e7          	jalr	1216(ra) # 53c4 <exit>
    printf("%s: read lf2 failed\n", s);
     f0c:	85ca                	mv	a1,s2
     f0e:	00005517          	auipc	a0,0x5
     f12:	40250513          	addi	a0,a0,1026 # 6310 <malloc+0xb14>
     f16:	00005097          	auipc	ra,0x5
     f1a:	826080e7          	jalr	-2010(ra) # 573c <printf>
    exit(1);
     f1e:	4505                	li	a0,1
     f20:	00004097          	auipc	ra,0x4
     f24:	4a4080e7          	jalr	1188(ra) # 53c4 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f28:	85ca                	mv	a1,s2
     f2a:	00005517          	auipc	a0,0x5
     f2e:	3fe50513          	addi	a0,a0,1022 # 6328 <malloc+0xb2c>
     f32:	00005097          	auipc	ra,0x5
     f36:	80a080e7          	jalr	-2038(ra) # 573c <printf>
    exit(1);
     f3a:	4505                	li	a0,1
     f3c:	00004097          	auipc	ra,0x4
     f40:	488080e7          	jalr	1160(ra) # 53c4 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f44:	85ca                	mv	a1,s2
     f46:	00005517          	auipc	a0,0x5
     f4a:	40a50513          	addi	a0,a0,1034 # 6350 <malloc+0xb54>
     f4e:	00004097          	auipc	ra,0x4
     f52:	7ee080e7          	jalr	2030(ra) # 573c <printf>
    exit(1);
     f56:	4505                	li	a0,1
     f58:	00004097          	auipc	ra,0x4
     f5c:	46c080e7          	jalr	1132(ra) # 53c4 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f60:	85ca                	mv	a1,s2
     f62:	00005517          	auipc	a0,0x5
     f66:	41e50513          	addi	a0,a0,1054 # 6380 <malloc+0xb84>
     f6a:	00004097          	auipc	ra,0x4
     f6e:	7d2080e7          	jalr	2002(ra) # 573c <printf>
    exit(1);
     f72:	4505                	li	a0,1
     f74:	00004097          	auipc	ra,0x4
     f78:	450080e7          	jalr	1104(ra) # 53c4 <exit>

0000000000000f7c <bigdir>:
{
     f7c:	715d                	addi	sp,sp,-80
     f7e:	e486                	sd	ra,72(sp)
     f80:	e0a2                	sd	s0,64(sp)
     f82:	fc26                	sd	s1,56(sp)
     f84:	f84a                	sd	s2,48(sp)
     f86:	f44e                	sd	s3,40(sp)
     f88:	f052                	sd	s4,32(sp)
     f8a:	ec56                	sd	s5,24(sp)
     f8c:	e85a                	sd	s6,16(sp)
     f8e:	0880                	addi	s0,sp,80
     f90:	89aa                	mv	s3,a0
  unlink("bd");
     f92:	00005517          	auipc	a0,0x5
     f96:	40e50513          	addi	a0,a0,1038 # 63a0 <malloc+0xba4>
     f9a:	00004097          	auipc	ra,0x4
     f9e:	47a080e7          	jalr	1146(ra) # 5414 <unlink>
  fd = open("bd", O_CREATE);
     fa2:	20000593          	li	a1,512
     fa6:	00005517          	auipc	a0,0x5
     faa:	3fa50513          	addi	a0,a0,1018 # 63a0 <malloc+0xba4>
     fae:	00004097          	auipc	ra,0x4
     fb2:	456080e7          	jalr	1110(ra) # 5404 <open>
  if(fd < 0){
     fb6:	0c054963          	bltz	a0,1088 <bigdir+0x10c>
  close(fd);
     fba:	00004097          	auipc	ra,0x4
     fbe:	432080e7          	jalr	1074(ra) # 53ec <close>
  for(i = 0; i < N; i++){
     fc2:	4901                	li	s2,0
    name[0] = 'x';
     fc4:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fc8:	00005a17          	auipc	s4,0x5
     fcc:	3d8a0a13          	addi	s4,s4,984 # 63a0 <malloc+0xba4>
  for(i = 0; i < N; i++){
     fd0:	1f400b13          	li	s6,500
    name[0] = 'x';
     fd4:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fd8:	41f9579b          	sraiw	a5,s2,0x1f
     fdc:	01a7d71b          	srliw	a4,a5,0x1a
     fe0:	012707bb          	addw	a5,a4,s2
     fe4:	4067d69b          	sraiw	a3,a5,0x6
     fe8:	0306869b          	addiw	a3,a3,48
     fec:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     ff0:	03f7f793          	andi	a5,a5,63
     ff4:	9f99                	subw	a5,a5,a4
     ff6:	0307879b          	addiw	a5,a5,48
     ffa:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     ffe:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1002:	fb040593          	addi	a1,s0,-80
    1006:	8552                	mv	a0,s4
    1008:	00004097          	auipc	ra,0x4
    100c:	41c080e7          	jalr	1052(ra) # 5424 <link>
    1010:	84aa                	mv	s1,a0
    1012:	e949                	bnez	a0,10a4 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1014:	2905                	addiw	s2,s2,1
    1016:	fb691fe3          	bne	s2,s6,fd4 <bigdir+0x58>
  unlink("bd");
    101a:	00005517          	auipc	a0,0x5
    101e:	38650513          	addi	a0,a0,902 # 63a0 <malloc+0xba4>
    1022:	00004097          	auipc	ra,0x4
    1026:	3f2080e7          	jalr	1010(ra) # 5414 <unlink>
    name[0] = 'x';
    102a:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    102e:	1f400a13          	li	s4,500
    name[0] = 'x';
    1032:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1036:	41f4d79b          	sraiw	a5,s1,0x1f
    103a:	01a7d71b          	srliw	a4,a5,0x1a
    103e:	009707bb          	addw	a5,a4,s1
    1042:	4067d69b          	sraiw	a3,a5,0x6
    1046:	0306869b          	addiw	a3,a3,48
    104a:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    104e:	03f7f793          	andi	a5,a5,63
    1052:	9f99                	subw	a5,a5,a4
    1054:	0307879b          	addiw	a5,a5,48
    1058:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    105c:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1060:	fb040513          	addi	a0,s0,-80
    1064:	00004097          	auipc	ra,0x4
    1068:	3b0080e7          	jalr	944(ra) # 5414 <unlink>
    106c:	ed21                	bnez	a0,10c4 <bigdir+0x148>
  for(i = 0; i < N; i++){
    106e:	2485                	addiw	s1,s1,1
    1070:	fd4491e3          	bne	s1,s4,1032 <bigdir+0xb6>
}
    1074:	60a6                	ld	ra,72(sp)
    1076:	6406                	ld	s0,64(sp)
    1078:	74e2                	ld	s1,56(sp)
    107a:	7942                	ld	s2,48(sp)
    107c:	79a2                	ld	s3,40(sp)
    107e:	7a02                	ld	s4,32(sp)
    1080:	6ae2                	ld	s5,24(sp)
    1082:	6b42                	ld	s6,16(sp)
    1084:	6161                	addi	sp,sp,80
    1086:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1088:	85ce                	mv	a1,s3
    108a:	00005517          	auipc	a0,0x5
    108e:	31e50513          	addi	a0,a0,798 # 63a8 <malloc+0xbac>
    1092:	00004097          	auipc	ra,0x4
    1096:	6aa080e7          	jalr	1706(ra) # 573c <printf>
    exit(1);
    109a:	4505                	li	a0,1
    109c:	00004097          	auipc	ra,0x4
    10a0:	328080e7          	jalr	808(ra) # 53c4 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    10a4:	fb040613          	addi	a2,s0,-80
    10a8:	85ce                	mv	a1,s3
    10aa:	00005517          	auipc	a0,0x5
    10ae:	31e50513          	addi	a0,a0,798 # 63c8 <malloc+0xbcc>
    10b2:	00004097          	auipc	ra,0x4
    10b6:	68a080e7          	jalr	1674(ra) # 573c <printf>
      exit(1);
    10ba:	4505                	li	a0,1
    10bc:	00004097          	auipc	ra,0x4
    10c0:	308080e7          	jalr	776(ra) # 53c4 <exit>
      printf("%s: bigdir unlink failed", s);
    10c4:	85ce                	mv	a1,s3
    10c6:	00005517          	auipc	a0,0x5
    10ca:	32250513          	addi	a0,a0,802 # 63e8 <malloc+0xbec>
    10ce:	00004097          	auipc	ra,0x4
    10d2:	66e080e7          	jalr	1646(ra) # 573c <printf>
      exit(1);
    10d6:	4505                	li	a0,1
    10d8:	00004097          	auipc	ra,0x4
    10dc:	2ec080e7          	jalr	748(ra) # 53c4 <exit>

00000000000010e0 <validatetest>:
{
    10e0:	7139                	addi	sp,sp,-64
    10e2:	fc06                	sd	ra,56(sp)
    10e4:	f822                	sd	s0,48(sp)
    10e6:	f426                	sd	s1,40(sp)
    10e8:	f04a                	sd	s2,32(sp)
    10ea:	ec4e                	sd	s3,24(sp)
    10ec:	e852                	sd	s4,16(sp)
    10ee:	e456                	sd	s5,8(sp)
    10f0:	e05a                	sd	s6,0(sp)
    10f2:	0080                	addi	s0,sp,64
    10f4:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10f6:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10f8:	00005997          	auipc	s3,0x5
    10fc:	31098993          	addi	s3,s3,784 # 6408 <malloc+0xc0c>
    1100:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1102:	6a85                	lui	s5,0x1
    1104:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1108:	85a6                	mv	a1,s1
    110a:	854e                	mv	a0,s3
    110c:	00004097          	auipc	ra,0x4
    1110:	318080e7          	jalr	792(ra) # 5424 <link>
    1114:	01251f63          	bne	a0,s2,1132 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1118:	94d6                	add	s1,s1,s5
    111a:	ff4497e3          	bne	s1,s4,1108 <validatetest+0x28>
}
    111e:	70e2                	ld	ra,56(sp)
    1120:	7442                	ld	s0,48(sp)
    1122:	74a2                	ld	s1,40(sp)
    1124:	7902                	ld	s2,32(sp)
    1126:	69e2                	ld	s3,24(sp)
    1128:	6a42                	ld	s4,16(sp)
    112a:	6aa2                	ld	s5,8(sp)
    112c:	6b02                	ld	s6,0(sp)
    112e:	6121                	addi	sp,sp,64
    1130:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1132:	85da                	mv	a1,s6
    1134:	00005517          	auipc	a0,0x5
    1138:	2e450513          	addi	a0,a0,740 # 6418 <malloc+0xc1c>
    113c:	00004097          	auipc	ra,0x4
    1140:	600080e7          	jalr	1536(ra) # 573c <printf>
      exit(1);
    1144:	4505                	li	a0,1
    1146:	00004097          	auipc	ra,0x4
    114a:	27e080e7          	jalr	638(ra) # 53c4 <exit>

000000000000114e <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    114e:	7179                	addi	sp,sp,-48
    1150:	f406                	sd	ra,40(sp)
    1152:	f022                	sd	s0,32(sp)
    1154:	ec26                	sd	s1,24(sp)
    1156:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1158:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    115c:	00007797          	auipc	a5,0x7
    1160:	df478793          	addi	a5,a5,-524 # 7f50 <digits+0x20>
    1164:	6384                	ld	s1,0(a5)
    1166:	fd840593          	addi	a1,s0,-40
    116a:	8526                	mv	a0,s1
    116c:	00004097          	auipc	ra,0x4
    1170:	290080e7          	jalr	656(ra) # 53fc <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1174:	8526                	mv	a0,s1
    1176:	00004097          	auipc	ra,0x4
    117a:	25e080e7          	jalr	606(ra) # 53d4 <pipe>

  exit(0);
    117e:	4501                	li	a0,0
    1180:	00004097          	auipc	ra,0x4
    1184:	244080e7          	jalr	580(ra) # 53c4 <exit>

0000000000001188 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1188:	7139                	addi	sp,sp,-64
    118a:	fc06                	sd	ra,56(sp)
    118c:	f822                	sd	s0,48(sp)
    118e:	f426                	sd	s1,40(sp)
    1190:	f04a                	sd	s2,32(sp)
    1192:	ec4e                	sd	s3,24(sp)
    1194:	0080                	addi	s0,sp,64
    1196:	64b1                	lui	s1,0xc
    1198:	35048493          	addi	s1,s1,848 # c350 <buf+0xbc8>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    119c:	597d                	li	s2,-1
    119e:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    11a2:	00005997          	auipc	s3,0x5
    11a6:	b1e98993          	addi	s3,s3,-1250 # 5cc0 <malloc+0x4c4>
    argv[0] = (char*)0xffffffff;
    11aa:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    11ae:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    11b2:	fc040593          	addi	a1,s0,-64
    11b6:	854e                	mv	a0,s3
    11b8:	00004097          	auipc	ra,0x4
    11bc:	244080e7          	jalr	580(ra) # 53fc <exec>
  for(int i = 0; i < 50000; i++){
    11c0:	34fd                	addiw	s1,s1,-1
    11c2:	f4e5                	bnez	s1,11aa <badarg+0x22>
  }
  
  exit(0);
    11c4:	4501                	li	a0,0
    11c6:	00004097          	auipc	ra,0x4
    11ca:	1fe080e7          	jalr	510(ra) # 53c4 <exit>

00000000000011ce <copyinstr2>:
{
    11ce:	7155                	addi	sp,sp,-208
    11d0:	e586                	sd	ra,200(sp)
    11d2:	e1a2                	sd	s0,192(sp)
    11d4:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11d6:	f6840793          	addi	a5,s0,-152
    11da:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11de:	07800713          	li	a4,120
    11e2:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11e6:	0785                	addi	a5,a5,1
    11e8:	fed79de3          	bne	a5,a3,11e2 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11ec:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11f0:	f6840513          	addi	a0,s0,-152
    11f4:	00004097          	auipc	ra,0x4
    11f8:	220080e7          	jalr	544(ra) # 5414 <unlink>
  if(ret != -1){
    11fc:	57fd                	li	a5,-1
    11fe:	0ef51063          	bne	a0,a5,12de <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    1202:	20100593          	li	a1,513
    1206:	f6840513          	addi	a0,s0,-152
    120a:	00004097          	auipc	ra,0x4
    120e:	1fa080e7          	jalr	506(ra) # 5404 <open>
  if(fd != -1){
    1212:	57fd                	li	a5,-1
    1214:	0ef51563          	bne	a0,a5,12fe <copyinstr2+0x130>
  ret = link(b, b);
    1218:	f6840593          	addi	a1,s0,-152
    121c:	852e                	mv	a0,a1
    121e:	00004097          	auipc	ra,0x4
    1222:	206080e7          	jalr	518(ra) # 5424 <link>
  if(ret != -1){
    1226:	57fd                	li	a5,-1
    1228:	0ef51b63          	bne	a0,a5,131e <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    122c:	00006797          	auipc	a5,0x6
    1230:	2b478793          	addi	a5,a5,692 # 74e0 <malloc+0x1ce4>
    1234:	f4f43c23          	sd	a5,-168(s0)
    1238:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    123c:	f5840593          	addi	a1,s0,-168
    1240:	f6840513          	addi	a0,s0,-152
    1244:	00004097          	auipc	ra,0x4
    1248:	1b8080e7          	jalr	440(ra) # 53fc <exec>
  if(ret != -1){
    124c:	57fd                	li	a5,-1
    124e:	0ef51963          	bne	a0,a5,1340 <copyinstr2+0x172>
  int pid = fork();
    1252:	00004097          	auipc	ra,0x4
    1256:	16a080e7          	jalr	362(ra) # 53bc <fork>
  if(pid < 0){
    125a:	10054363          	bltz	a0,1360 <copyinstr2+0x192>
  if(pid == 0){
    125e:	12051463          	bnez	a0,1386 <copyinstr2+0x1b8>
    1262:	00007797          	auipc	a5,0x7
    1266:	e0e78793          	addi	a5,a5,-498 # 8070 <big.1285>
    126a:	00008697          	auipc	a3,0x8
    126e:	e0668693          	addi	a3,a3,-506 # 9070 <__global_pointer$+0x920>
      big[i] = 'x';
    1272:	07800713          	li	a4,120
    1276:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    127a:	0785                	addi	a5,a5,1
    127c:	fed79de3          	bne	a5,a3,1276 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1280:	00008797          	auipc	a5,0x8
    1284:	de078823          	sb	zero,-528(a5) # 9070 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    1288:	00004797          	auipc	a5,0x4
    128c:	66078793          	addi	a5,a5,1632 # 58e8 <malloc+0xec>
    1290:	6390                	ld	a2,0(a5)
    1292:	6794                	ld	a3,8(a5)
    1294:	6b98                	ld	a4,16(a5)
    1296:	6f9c                	ld	a5,24(a5)
    1298:	f2c43823          	sd	a2,-208(s0)
    129c:	f2d43c23          	sd	a3,-200(s0)
    12a0:	f4e43023          	sd	a4,-192(s0)
    12a4:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    12a8:	f3040593          	addi	a1,s0,-208
    12ac:	00005517          	auipc	a0,0x5
    12b0:	a1450513          	addi	a0,a0,-1516 # 5cc0 <malloc+0x4c4>
    12b4:	00004097          	auipc	ra,0x4
    12b8:	148080e7          	jalr	328(ra) # 53fc <exec>
    if(ret != -1){
    12bc:	57fd                	li	a5,-1
    12be:	0af50e63          	beq	a0,a5,137a <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12c2:	55fd                	li	a1,-1
    12c4:	00005517          	auipc	a0,0x5
    12c8:	1fc50513          	addi	a0,a0,508 # 64c0 <malloc+0xcc4>
    12cc:	00004097          	auipc	ra,0x4
    12d0:	470080e7          	jalr	1136(ra) # 573c <printf>
      exit(1);
    12d4:	4505                	li	a0,1
    12d6:	00004097          	auipc	ra,0x4
    12da:	0ee080e7          	jalr	238(ra) # 53c4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12de:	862a                	mv	a2,a0
    12e0:	f6840593          	addi	a1,s0,-152
    12e4:	00005517          	auipc	a0,0x5
    12e8:	15450513          	addi	a0,a0,340 # 6438 <malloc+0xc3c>
    12ec:	00004097          	auipc	ra,0x4
    12f0:	450080e7          	jalr	1104(ra) # 573c <printf>
    exit(1);
    12f4:	4505                	li	a0,1
    12f6:	00004097          	auipc	ra,0x4
    12fa:	0ce080e7          	jalr	206(ra) # 53c4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12fe:	862a                	mv	a2,a0
    1300:	f6840593          	addi	a1,s0,-152
    1304:	00005517          	auipc	a0,0x5
    1308:	15450513          	addi	a0,a0,340 # 6458 <malloc+0xc5c>
    130c:	00004097          	auipc	ra,0x4
    1310:	430080e7          	jalr	1072(ra) # 573c <printf>
    exit(1);
    1314:	4505                	li	a0,1
    1316:	00004097          	auipc	ra,0x4
    131a:	0ae080e7          	jalr	174(ra) # 53c4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    131e:	86aa                	mv	a3,a0
    1320:	f6840613          	addi	a2,s0,-152
    1324:	85b2                	mv	a1,a2
    1326:	00005517          	auipc	a0,0x5
    132a:	15250513          	addi	a0,a0,338 # 6478 <malloc+0xc7c>
    132e:	00004097          	auipc	ra,0x4
    1332:	40e080e7          	jalr	1038(ra) # 573c <printf>
    exit(1);
    1336:	4505                	li	a0,1
    1338:	00004097          	auipc	ra,0x4
    133c:	08c080e7          	jalr	140(ra) # 53c4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1340:	567d                	li	a2,-1
    1342:	f6840593          	addi	a1,s0,-152
    1346:	00005517          	auipc	a0,0x5
    134a:	15a50513          	addi	a0,a0,346 # 64a0 <malloc+0xca4>
    134e:	00004097          	auipc	ra,0x4
    1352:	3ee080e7          	jalr	1006(ra) # 573c <printf>
    exit(1);
    1356:	4505                	li	a0,1
    1358:	00004097          	auipc	ra,0x4
    135c:	06c080e7          	jalr	108(ra) # 53c4 <exit>
    printf("fork failed\n");
    1360:	00005517          	auipc	a0,0x5
    1364:	5a850513          	addi	a0,a0,1448 # 6908 <malloc+0x110c>
    1368:	00004097          	auipc	ra,0x4
    136c:	3d4080e7          	jalr	980(ra) # 573c <printf>
    exit(1);
    1370:	4505                	li	a0,1
    1372:	00004097          	auipc	ra,0x4
    1376:	052080e7          	jalr	82(ra) # 53c4 <exit>
    exit(747); // OK
    137a:	2eb00513          	li	a0,747
    137e:	00004097          	auipc	ra,0x4
    1382:	046080e7          	jalr	70(ra) # 53c4 <exit>
  int st = 0;
    1386:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    138a:	f5440513          	addi	a0,s0,-172
    138e:	00004097          	auipc	ra,0x4
    1392:	03e080e7          	jalr	62(ra) # 53cc <wait>
  if(st != 747){
    1396:	f5442703          	lw	a4,-172(s0)
    139a:	2eb00793          	li	a5,747
    139e:	00f71663          	bne	a4,a5,13aa <copyinstr2+0x1dc>
}
    13a2:	60ae                	ld	ra,200(sp)
    13a4:	640e                	ld	s0,192(sp)
    13a6:	6169                	addi	sp,sp,208
    13a8:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    13aa:	00005517          	auipc	a0,0x5
    13ae:	13e50513          	addi	a0,a0,318 # 64e8 <malloc+0xcec>
    13b2:	00004097          	auipc	ra,0x4
    13b6:	38a080e7          	jalr	906(ra) # 573c <printf>
    exit(1);
    13ba:	4505                	li	a0,1
    13bc:	00004097          	auipc	ra,0x4
    13c0:	008080e7          	jalr	8(ra) # 53c4 <exit>

00000000000013c4 <truncate3>:
{
    13c4:	7159                	addi	sp,sp,-112
    13c6:	f486                	sd	ra,104(sp)
    13c8:	f0a2                	sd	s0,96(sp)
    13ca:	eca6                	sd	s1,88(sp)
    13cc:	e8ca                	sd	s2,80(sp)
    13ce:	e4ce                	sd	s3,72(sp)
    13d0:	e0d2                	sd	s4,64(sp)
    13d2:	fc56                	sd	s5,56(sp)
    13d4:	1880                	addi	s0,sp,112
    13d6:	8a2a                	mv	s4,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13d8:	60100593          	li	a1,1537
    13dc:	00005517          	auipc	a0,0x5
    13e0:	93c50513          	addi	a0,a0,-1732 # 5d18 <malloc+0x51c>
    13e4:	00004097          	auipc	ra,0x4
    13e8:	020080e7          	jalr	32(ra) # 5404 <open>
    13ec:	00004097          	auipc	ra,0x4
    13f0:	000080e7          	jalr	ra # 53ec <close>
  pid = fork();
    13f4:	00004097          	auipc	ra,0x4
    13f8:	fc8080e7          	jalr	-56(ra) # 53bc <fork>
  if(pid < 0){
    13fc:	08054063          	bltz	a0,147c <truncate3+0xb8>
  if(pid == 0){
    1400:	e969                	bnez	a0,14d2 <truncate3+0x10e>
    1402:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    1406:	00005997          	auipc	s3,0x5
    140a:	91298993          	addi	s3,s3,-1774 # 5d18 <malloc+0x51c>
      int n = write(fd, "1234567890", 10);
    140e:	00005a97          	auipc	s5,0x5
    1412:	13aa8a93          	addi	s5,s5,314 # 6548 <malloc+0xd4c>
      int fd = open("truncfile", O_WRONLY);
    1416:	4585                	li	a1,1
    1418:	854e                	mv	a0,s3
    141a:	00004097          	auipc	ra,0x4
    141e:	fea080e7          	jalr	-22(ra) # 5404 <open>
    1422:	84aa                	mv	s1,a0
      if(fd < 0){
    1424:	06054a63          	bltz	a0,1498 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1428:	4629                	li	a2,10
    142a:	85d6                	mv	a1,s5
    142c:	00004097          	auipc	ra,0x4
    1430:	fb8080e7          	jalr	-72(ra) # 53e4 <write>
      if(n != 10){
    1434:	47a9                	li	a5,10
    1436:	06f51f63          	bne	a0,a5,14b4 <truncate3+0xf0>
      close(fd);
    143a:	8526                	mv	a0,s1
    143c:	00004097          	auipc	ra,0x4
    1440:	fb0080e7          	jalr	-80(ra) # 53ec <close>
      fd = open("truncfile", O_RDONLY);
    1444:	4581                	li	a1,0
    1446:	854e                	mv	a0,s3
    1448:	00004097          	auipc	ra,0x4
    144c:	fbc080e7          	jalr	-68(ra) # 5404 <open>
    1450:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1452:	02000613          	li	a2,32
    1456:	f9840593          	addi	a1,s0,-104
    145a:	00004097          	auipc	ra,0x4
    145e:	f82080e7          	jalr	-126(ra) # 53dc <read>
      close(fd);
    1462:	8526                	mv	a0,s1
    1464:	00004097          	auipc	ra,0x4
    1468:	f88080e7          	jalr	-120(ra) # 53ec <close>
    for(int i = 0; i < 100; i++){
    146c:	397d                	addiw	s2,s2,-1
    146e:	fa0914e3          	bnez	s2,1416 <truncate3+0x52>
    exit(0);
    1472:	4501                	li	a0,0
    1474:	00004097          	auipc	ra,0x4
    1478:	f50080e7          	jalr	-176(ra) # 53c4 <exit>
    printf("%s: fork failed\n", s);
    147c:	85d2                	mv	a1,s4
    147e:	00005517          	auipc	a0,0x5
    1482:	09a50513          	addi	a0,a0,154 # 6518 <malloc+0xd1c>
    1486:	00004097          	auipc	ra,0x4
    148a:	2b6080e7          	jalr	694(ra) # 573c <printf>
    exit(1);
    148e:	4505                	li	a0,1
    1490:	00004097          	auipc	ra,0x4
    1494:	f34080e7          	jalr	-204(ra) # 53c4 <exit>
        printf("%s: open failed\n", s);
    1498:	85d2                	mv	a1,s4
    149a:	00005517          	auipc	a0,0x5
    149e:	09650513          	addi	a0,a0,150 # 6530 <malloc+0xd34>
    14a2:	00004097          	auipc	ra,0x4
    14a6:	29a080e7          	jalr	666(ra) # 573c <printf>
        exit(1);
    14aa:	4505                	li	a0,1
    14ac:	00004097          	auipc	ra,0x4
    14b0:	f18080e7          	jalr	-232(ra) # 53c4 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14b4:	862a                	mv	a2,a0
    14b6:	85d2                	mv	a1,s4
    14b8:	00005517          	auipc	a0,0x5
    14bc:	0a050513          	addi	a0,a0,160 # 6558 <malloc+0xd5c>
    14c0:	00004097          	auipc	ra,0x4
    14c4:	27c080e7          	jalr	636(ra) # 573c <printf>
        exit(1);
    14c8:	4505                	li	a0,1
    14ca:	00004097          	auipc	ra,0x4
    14ce:	efa080e7          	jalr	-262(ra) # 53c4 <exit>
    14d2:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d6:	00005997          	auipc	s3,0x5
    14da:	84298993          	addi	s3,s3,-1982 # 5d18 <malloc+0x51c>
    int n = write(fd, "xxx", 3);
    14de:	00005a97          	auipc	s5,0x5
    14e2:	09aa8a93          	addi	s5,s5,154 # 6578 <malloc+0xd7c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14e6:	60100593          	li	a1,1537
    14ea:	854e                	mv	a0,s3
    14ec:	00004097          	auipc	ra,0x4
    14f0:	f18080e7          	jalr	-232(ra) # 5404 <open>
    14f4:	84aa                	mv	s1,a0
    if(fd < 0){
    14f6:	04054763          	bltz	a0,1544 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14fa:	460d                	li	a2,3
    14fc:	85d6                	mv	a1,s5
    14fe:	00004097          	auipc	ra,0x4
    1502:	ee6080e7          	jalr	-282(ra) # 53e4 <write>
    if(n != 3){
    1506:	478d                	li	a5,3
    1508:	04f51c63          	bne	a0,a5,1560 <truncate3+0x19c>
    close(fd);
    150c:	8526                	mv	a0,s1
    150e:	00004097          	auipc	ra,0x4
    1512:	ede080e7          	jalr	-290(ra) # 53ec <close>
  for(int i = 0; i < 150; i++){
    1516:	397d                	addiw	s2,s2,-1
    1518:	fc0917e3          	bnez	s2,14e6 <truncate3+0x122>
  wait(&xstatus);
    151c:	fbc40513          	addi	a0,s0,-68
    1520:	00004097          	auipc	ra,0x4
    1524:	eac080e7          	jalr	-340(ra) # 53cc <wait>
  unlink("truncfile");
    1528:	00004517          	auipc	a0,0x4
    152c:	7f050513          	addi	a0,a0,2032 # 5d18 <malloc+0x51c>
    1530:	00004097          	auipc	ra,0x4
    1534:	ee4080e7          	jalr	-284(ra) # 5414 <unlink>
  exit(xstatus);
    1538:	fbc42503          	lw	a0,-68(s0)
    153c:	00004097          	auipc	ra,0x4
    1540:	e88080e7          	jalr	-376(ra) # 53c4 <exit>
      printf("%s: open failed\n", s);
    1544:	85d2                	mv	a1,s4
    1546:	00005517          	auipc	a0,0x5
    154a:	fea50513          	addi	a0,a0,-22 # 6530 <malloc+0xd34>
    154e:	00004097          	auipc	ra,0x4
    1552:	1ee080e7          	jalr	494(ra) # 573c <printf>
      exit(1);
    1556:	4505                	li	a0,1
    1558:	00004097          	auipc	ra,0x4
    155c:	e6c080e7          	jalr	-404(ra) # 53c4 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1560:	862a                	mv	a2,a0
    1562:	85d2                	mv	a1,s4
    1564:	00005517          	auipc	a0,0x5
    1568:	01c50513          	addi	a0,a0,28 # 6580 <malloc+0xd84>
    156c:	00004097          	auipc	ra,0x4
    1570:	1d0080e7          	jalr	464(ra) # 573c <printf>
      exit(1);
    1574:	4505                	li	a0,1
    1576:	00004097          	auipc	ra,0x4
    157a:	e4e080e7          	jalr	-434(ra) # 53c4 <exit>

000000000000157e <exectest>:
{
    157e:	715d                	addi	sp,sp,-80
    1580:	e486                	sd	ra,72(sp)
    1582:	e0a2                	sd	s0,64(sp)
    1584:	fc26                	sd	s1,56(sp)
    1586:	f84a                	sd	s2,48(sp)
    1588:	0880                	addi	s0,sp,80
    158a:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    158c:	00004797          	auipc	a5,0x4
    1590:	73478793          	addi	a5,a5,1844 # 5cc0 <malloc+0x4c4>
    1594:	fcf43023          	sd	a5,-64(s0)
    1598:	00005797          	auipc	a5,0x5
    159c:	00878793          	addi	a5,a5,8 # 65a0 <malloc+0xda4>
    15a0:	fcf43423          	sd	a5,-56(s0)
    15a4:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    15a8:	00005517          	auipc	a0,0x5
    15ac:	00050513          	mv	a0,a0
    15b0:	00004097          	auipc	ra,0x4
    15b4:	e64080e7          	jalr	-412(ra) # 5414 <unlink>
  pid = fork();
    15b8:	00004097          	auipc	ra,0x4
    15bc:	e04080e7          	jalr	-508(ra) # 53bc <fork>
  if(pid < 0) {
    15c0:	04054663          	bltz	a0,160c <exectest+0x8e>
    15c4:	84aa                	mv	s1,a0
  if(pid == 0) {
    15c6:	e959                	bnez	a0,165c <exectest+0xde>
    close(1);
    15c8:	4505                	li	a0,1
    15ca:	00004097          	auipc	ra,0x4
    15ce:	e22080e7          	jalr	-478(ra) # 53ec <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15d2:	20100593          	li	a1,513
    15d6:	00005517          	auipc	a0,0x5
    15da:	fd250513          	addi	a0,a0,-46 # 65a8 <malloc+0xdac>
    15de:	00004097          	auipc	ra,0x4
    15e2:	e26080e7          	jalr	-474(ra) # 5404 <open>
    if(fd < 0) {
    15e6:	04054163          	bltz	a0,1628 <exectest+0xaa>
    if(fd != 1) {
    15ea:	4785                	li	a5,1
    15ec:	04f50c63          	beq	a0,a5,1644 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15f0:	85ca                	mv	a1,s2
    15f2:	00005517          	auipc	a0,0x5
    15f6:	fd650513          	addi	a0,a0,-42 # 65c8 <malloc+0xdcc>
    15fa:	00004097          	auipc	ra,0x4
    15fe:	142080e7          	jalr	322(ra) # 573c <printf>
      exit(1);
    1602:	4505                	li	a0,1
    1604:	00004097          	auipc	ra,0x4
    1608:	dc0080e7          	jalr	-576(ra) # 53c4 <exit>
     printf("%s: fork failed\n", s);
    160c:	85ca                	mv	a1,s2
    160e:	00005517          	auipc	a0,0x5
    1612:	f0a50513          	addi	a0,a0,-246 # 6518 <malloc+0xd1c>
    1616:	00004097          	auipc	ra,0x4
    161a:	126080e7          	jalr	294(ra) # 573c <printf>
     exit(1);
    161e:	4505                	li	a0,1
    1620:	00004097          	auipc	ra,0x4
    1624:	da4080e7          	jalr	-604(ra) # 53c4 <exit>
      printf("%s: create failed\n", s);
    1628:	85ca                	mv	a1,s2
    162a:	00005517          	auipc	a0,0x5
    162e:	f8650513          	addi	a0,a0,-122 # 65b0 <malloc+0xdb4>
    1632:	00004097          	auipc	ra,0x4
    1636:	10a080e7          	jalr	266(ra) # 573c <printf>
      exit(1);
    163a:	4505                	li	a0,1
    163c:	00004097          	auipc	ra,0x4
    1640:	d88080e7          	jalr	-632(ra) # 53c4 <exit>
    if(exec("echo", echoargv) < 0){
    1644:	fc040593          	addi	a1,s0,-64
    1648:	00004517          	auipc	a0,0x4
    164c:	67850513          	addi	a0,a0,1656 # 5cc0 <malloc+0x4c4>
    1650:	00004097          	auipc	ra,0x4
    1654:	dac080e7          	jalr	-596(ra) # 53fc <exec>
    1658:	02054163          	bltz	a0,167a <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    165c:	fdc40513          	addi	a0,s0,-36
    1660:	00004097          	auipc	ra,0x4
    1664:	d6c080e7          	jalr	-660(ra) # 53cc <wait>
    1668:	02951763          	bne	a0,s1,1696 <exectest+0x118>
  if(xstatus != 0)
    166c:	fdc42503          	lw	a0,-36(s0)
    1670:	cd0d                	beqz	a0,16aa <exectest+0x12c>
    exit(xstatus);
    1672:	00004097          	auipc	ra,0x4
    1676:	d52080e7          	jalr	-686(ra) # 53c4 <exit>
      printf("%s: exec echo failed\n", s);
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	f5c50513          	addi	a0,a0,-164 # 65d8 <malloc+0xddc>
    1684:	00004097          	auipc	ra,0x4
    1688:	0b8080e7          	jalr	184(ra) # 573c <printf>
      exit(1);
    168c:	4505                	li	a0,1
    168e:	00004097          	auipc	ra,0x4
    1692:	d36080e7          	jalr	-714(ra) # 53c4 <exit>
    printf("%s: wait failed!\n", s);
    1696:	85ca                	mv	a1,s2
    1698:	00005517          	auipc	a0,0x5
    169c:	f5850513          	addi	a0,a0,-168 # 65f0 <malloc+0xdf4>
    16a0:	00004097          	auipc	ra,0x4
    16a4:	09c080e7          	jalr	156(ra) # 573c <printf>
    16a8:	b7d1                	j	166c <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    16aa:	4581                	li	a1,0
    16ac:	00005517          	auipc	a0,0x5
    16b0:	efc50513          	addi	a0,a0,-260 # 65a8 <malloc+0xdac>
    16b4:	00004097          	auipc	ra,0x4
    16b8:	d50080e7          	jalr	-688(ra) # 5404 <open>
  if(fd < 0) {
    16bc:	02054a63          	bltz	a0,16f0 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16c0:	4609                	li	a2,2
    16c2:	fb840593          	addi	a1,s0,-72
    16c6:	00004097          	auipc	ra,0x4
    16ca:	d16080e7          	jalr	-746(ra) # 53dc <read>
    16ce:	4789                	li	a5,2
    16d0:	02f50e63          	beq	a0,a5,170c <exectest+0x18e>
    printf("%s: read failed\n", s);
    16d4:	85ca                	mv	a1,s2
    16d6:	00005517          	auipc	a0,0x5
    16da:	98a50513          	addi	a0,a0,-1654 # 6060 <malloc+0x864>
    16de:	00004097          	auipc	ra,0x4
    16e2:	05e080e7          	jalr	94(ra) # 573c <printf>
    exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00004097          	auipc	ra,0x4
    16ec:	cdc080e7          	jalr	-804(ra) # 53c4 <exit>
    printf("%s: open failed\n", s);
    16f0:	85ca                	mv	a1,s2
    16f2:	00005517          	auipc	a0,0x5
    16f6:	e3e50513          	addi	a0,a0,-450 # 6530 <malloc+0xd34>
    16fa:	00004097          	auipc	ra,0x4
    16fe:	042080e7          	jalr	66(ra) # 573c <printf>
    exit(1);
    1702:	4505                	li	a0,1
    1704:	00004097          	auipc	ra,0x4
    1708:	cc0080e7          	jalr	-832(ra) # 53c4 <exit>
  unlink("echo-ok");
    170c:	00005517          	auipc	a0,0x5
    1710:	e9c50513          	addi	a0,a0,-356 # 65a8 <malloc+0xdac>
    1714:	00004097          	auipc	ra,0x4
    1718:	d00080e7          	jalr	-768(ra) # 5414 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    171c:	fb844703          	lbu	a4,-72(s0)
    1720:	04f00793          	li	a5,79
    1724:	00f71863          	bne	a4,a5,1734 <exectest+0x1b6>
    1728:	fb944703          	lbu	a4,-71(s0)
    172c:	04b00793          	li	a5,75
    1730:	02f70063          	beq	a4,a5,1750 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1734:	85ca                	mv	a1,s2
    1736:	00005517          	auipc	a0,0x5
    173a:	ed250513          	addi	a0,a0,-302 # 6608 <malloc+0xe0c>
    173e:	00004097          	auipc	ra,0x4
    1742:	ffe080e7          	jalr	-2(ra) # 573c <printf>
    exit(1);
    1746:	4505                	li	a0,1
    1748:	00004097          	auipc	ra,0x4
    174c:	c7c080e7          	jalr	-900(ra) # 53c4 <exit>
    exit(0);
    1750:	4501                	li	a0,0
    1752:	00004097          	auipc	ra,0x4
    1756:	c72080e7          	jalr	-910(ra) # 53c4 <exit>

000000000000175a <pipe1>:
{
    175a:	715d                	addi	sp,sp,-80
    175c:	e486                	sd	ra,72(sp)
    175e:	e0a2                	sd	s0,64(sp)
    1760:	fc26                	sd	s1,56(sp)
    1762:	f84a                	sd	s2,48(sp)
    1764:	f44e                	sd	s3,40(sp)
    1766:	f052                	sd	s4,32(sp)
    1768:	ec56                	sd	s5,24(sp)
    176a:	e85a                	sd	s6,16(sp)
    176c:	0880                	addi	s0,sp,80
    176e:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    1770:	fb840513          	addi	a0,s0,-72
    1774:	00004097          	auipc	ra,0x4
    1778:	c60080e7          	jalr	-928(ra) # 53d4 <pipe>
    177c:	e935                	bnez	a0,17f0 <pipe1+0x96>
    177e:	84aa                	mv	s1,a0
  pid = fork();
    1780:	00004097          	auipc	ra,0x4
    1784:	c3c080e7          	jalr	-964(ra) # 53bc <fork>
  if(pid == 0){
    1788:	c151                	beqz	a0,180c <pipe1+0xb2>
  } else if(pid > 0){
    178a:	18a05963          	blez	a0,191c <pipe1+0x1c2>
    close(fds[1]);
    178e:	fbc42503          	lw	a0,-68(s0)
    1792:	00004097          	auipc	ra,0x4
    1796:	c5a080e7          	jalr	-934(ra) # 53ec <close>
    total = 0;
    179a:	8aa6                	mv	s5,s1
    cc = 1;
    179c:	4a05                	li	s4,1
    while((n = read(fds[0], buf, cc)) > 0){
    179e:	0000a917          	auipc	s2,0xa
    17a2:	fea90913          	addi	s2,s2,-22 # b788 <buf>
      if(cc > sizeof(buf))
    17a6:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    17a8:	8652                	mv	a2,s4
    17aa:	85ca                	mv	a1,s2
    17ac:	fb842503          	lw	a0,-72(s0)
    17b0:	00004097          	auipc	ra,0x4
    17b4:	c2c080e7          	jalr	-980(ra) # 53dc <read>
    17b8:	10a05d63          	blez	a0,18d2 <pipe1+0x178>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17bc:	0014879b          	addiw	a5,s1,1
    17c0:	00094683          	lbu	a3,0(s2)
    17c4:	0ff4f713          	andi	a4,s1,255
    17c8:	0ce69863          	bne	a3,a4,1898 <pipe1+0x13e>
    17cc:	0000a717          	auipc	a4,0xa
    17d0:	fbd70713          	addi	a4,a4,-67 # b789 <buf+0x1>
    17d4:	9ca9                	addw	s1,s1,a0
      for(i = 0; i < n; i++){
    17d6:	0e978463          	beq	a5,s1,18be <pipe1+0x164>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17da:	00074683          	lbu	a3,0(a4)
    17de:	0017861b          	addiw	a2,a5,1
    17e2:	0705                	addi	a4,a4,1
    17e4:	0ff7f793          	andi	a5,a5,255
    17e8:	0af69863          	bne	a3,a5,1898 <pipe1+0x13e>
    17ec:	87b2                	mv	a5,a2
    17ee:	b7e5                	j	17d6 <pipe1+0x7c>
    printf("%s: pipe() failed\n", s);
    17f0:	85ce                	mv	a1,s3
    17f2:	00005517          	auipc	a0,0x5
    17f6:	e2e50513          	addi	a0,a0,-466 # 6620 <malloc+0xe24>
    17fa:	00004097          	auipc	ra,0x4
    17fe:	f42080e7          	jalr	-190(ra) # 573c <printf>
    exit(1);
    1802:	4505                	li	a0,1
    1804:	00004097          	auipc	ra,0x4
    1808:	bc0080e7          	jalr	-1088(ra) # 53c4 <exit>
    close(fds[0]);
    180c:	fb842503          	lw	a0,-72(s0)
    1810:	00004097          	auipc	ra,0x4
    1814:	bdc080e7          	jalr	-1060(ra) # 53ec <close>
    for(n = 0; n < N; n++){
    1818:	0000aa97          	auipc	s5,0xa
    181c:	f70a8a93          	addi	s5,s5,-144 # b788 <buf>
    1820:	0ffaf793          	andi	a5,s5,255
    1824:	40f004b3          	neg	s1,a5
    1828:	0ff4f493          	andi	s1,s1,255
    182c:	02d00a13          	li	s4,45
    1830:	40fa0a3b          	subw	s4,s4,a5
    1834:	0ffa7a13          	andi	s4,s4,255
    1838:	409a8913          	addi	s2,s5,1033
      if(write(fds[1], buf, SZ) != SZ){
    183c:	8b56                	mv	s6,s5
{
    183e:	87d6                	mv	a5,s5
        buf[i] = seq++;
    1840:	0097873b          	addw	a4,a5,s1
    1844:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1848:	0785                	addi	a5,a5,1
    184a:	fef91be3          	bne	s2,a5,1840 <pipe1+0xe6>
      if(write(fds[1], buf, SZ) != SZ){
    184e:	40900613          	li	a2,1033
    1852:	85da                	mv	a1,s6
    1854:	fbc42503          	lw	a0,-68(s0)
    1858:	00004097          	auipc	ra,0x4
    185c:	b8c080e7          	jalr	-1140(ra) # 53e4 <write>
    1860:	40900793          	li	a5,1033
    1864:	00f51c63          	bne	a0,a5,187c <pipe1+0x122>
    for(n = 0; n < N; n++){
    1868:	24a5                	addiw	s1,s1,9
    186a:	0ff4f493          	andi	s1,s1,255
    186e:	fd4498e3          	bne	s1,s4,183e <pipe1+0xe4>
    exit(0);
    1872:	4501                	li	a0,0
    1874:	00004097          	auipc	ra,0x4
    1878:	b50080e7          	jalr	-1200(ra) # 53c4 <exit>
        printf("%s: pipe1 oops 1\n", s);
    187c:	85ce                	mv	a1,s3
    187e:	00005517          	auipc	a0,0x5
    1882:	dba50513          	addi	a0,a0,-582 # 6638 <malloc+0xe3c>
    1886:	00004097          	auipc	ra,0x4
    188a:	eb6080e7          	jalr	-330(ra) # 573c <printf>
        exit(1);
    188e:	4505                	li	a0,1
    1890:	00004097          	auipc	ra,0x4
    1894:	b34080e7          	jalr	-1228(ra) # 53c4 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1898:	85ce                	mv	a1,s3
    189a:	00005517          	auipc	a0,0x5
    189e:	db650513          	addi	a0,a0,-586 # 6650 <malloc+0xe54>
    18a2:	00004097          	auipc	ra,0x4
    18a6:	e9a080e7          	jalr	-358(ra) # 573c <printf>
}
    18aa:	60a6                	ld	ra,72(sp)
    18ac:	6406                	ld	s0,64(sp)
    18ae:	74e2                	ld	s1,56(sp)
    18b0:	7942                	ld	s2,48(sp)
    18b2:	79a2                	ld	s3,40(sp)
    18b4:	7a02                	ld	s4,32(sp)
    18b6:	6ae2                	ld	s5,24(sp)
    18b8:	6b42                	ld	s6,16(sp)
    18ba:	6161                	addi	sp,sp,80
    18bc:	8082                	ret
      total += n;
    18be:	00aa8abb          	addw	s5,s5,a0
      cc = cc * 2;
    18c2:	001a179b          	slliw	a5,s4,0x1
    18c6:	00078a1b          	sext.w	s4,a5
      if(cc > sizeof(buf))
    18ca:	ed4b7fe3          	bleu	s4,s6,17a8 <pipe1+0x4e>
        cc = sizeof(buf);
    18ce:	8a5a                	mv	s4,s6
    18d0:	bde1                	j	17a8 <pipe1+0x4e>
    if(total != N * SZ){
    18d2:	6785                	lui	a5,0x1
    18d4:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x69>
    18d8:	02fa8063          	beq	s5,a5,18f8 <pipe1+0x19e>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18dc:	85d6                	mv	a1,s5
    18de:	00005517          	auipc	a0,0x5
    18e2:	d8a50513          	addi	a0,a0,-630 # 6668 <malloc+0xe6c>
    18e6:	00004097          	auipc	ra,0x4
    18ea:	e56080e7          	jalr	-426(ra) # 573c <printf>
      exit(1);
    18ee:	4505                	li	a0,1
    18f0:	00004097          	auipc	ra,0x4
    18f4:	ad4080e7          	jalr	-1324(ra) # 53c4 <exit>
    close(fds[0]);
    18f8:	fb842503          	lw	a0,-72(s0)
    18fc:	00004097          	auipc	ra,0x4
    1900:	af0080e7          	jalr	-1296(ra) # 53ec <close>
    wait(&xstatus);
    1904:	fb440513          	addi	a0,s0,-76
    1908:	00004097          	auipc	ra,0x4
    190c:	ac4080e7          	jalr	-1340(ra) # 53cc <wait>
    exit(xstatus);
    1910:	fb442503          	lw	a0,-76(s0)
    1914:	00004097          	auipc	ra,0x4
    1918:	ab0080e7          	jalr	-1360(ra) # 53c4 <exit>
    printf("%s: fork() failed\n", s);
    191c:	85ce                	mv	a1,s3
    191e:	00005517          	auipc	a0,0x5
    1922:	d6a50513          	addi	a0,a0,-662 # 6688 <malloc+0xe8c>
    1926:	00004097          	auipc	ra,0x4
    192a:	e16080e7          	jalr	-490(ra) # 573c <printf>
    exit(1);
    192e:	4505                	li	a0,1
    1930:	00004097          	auipc	ra,0x4
    1934:	a94080e7          	jalr	-1388(ra) # 53c4 <exit>

0000000000001938 <exitwait>:
{
    1938:	7139                	addi	sp,sp,-64
    193a:	fc06                	sd	ra,56(sp)
    193c:	f822                	sd	s0,48(sp)
    193e:	f426                	sd	s1,40(sp)
    1940:	f04a                	sd	s2,32(sp)
    1942:	ec4e                	sd	s3,24(sp)
    1944:	e852                	sd	s4,16(sp)
    1946:	0080                	addi	s0,sp,64
    1948:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    194a:	4481                	li	s1,0
    194c:	06400993          	li	s3,100
    pid = fork();
    1950:	00004097          	auipc	ra,0x4
    1954:	a6c080e7          	jalr	-1428(ra) # 53bc <fork>
    1958:	892a                	mv	s2,a0
    if(pid < 0){
    195a:	02054a63          	bltz	a0,198e <exitwait+0x56>
    if(pid){
    195e:	c151                	beqz	a0,19e2 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1960:	fcc40513          	addi	a0,s0,-52
    1964:	00004097          	auipc	ra,0x4
    1968:	a68080e7          	jalr	-1432(ra) # 53cc <wait>
    196c:	03251f63          	bne	a0,s2,19aa <exitwait+0x72>
      if(i != xstate) {
    1970:	fcc42783          	lw	a5,-52(s0)
    1974:	04979963          	bne	a5,s1,19c6 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1978:	2485                	addiw	s1,s1,1
    197a:	fd349be3          	bne	s1,s3,1950 <exitwait+0x18>
}
    197e:	70e2                	ld	ra,56(sp)
    1980:	7442                	ld	s0,48(sp)
    1982:	74a2                	ld	s1,40(sp)
    1984:	7902                	ld	s2,32(sp)
    1986:	69e2                	ld	s3,24(sp)
    1988:	6a42                	ld	s4,16(sp)
    198a:	6121                	addi	sp,sp,64
    198c:	8082                	ret
      printf("%s: fork failed\n", s);
    198e:	85d2                	mv	a1,s4
    1990:	00005517          	auipc	a0,0x5
    1994:	b8850513          	addi	a0,a0,-1144 # 6518 <malloc+0xd1c>
    1998:	00004097          	auipc	ra,0x4
    199c:	da4080e7          	jalr	-604(ra) # 573c <printf>
      exit(1);
    19a0:	4505                	li	a0,1
    19a2:	00004097          	auipc	ra,0x4
    19a6:	a22080e7          	jalr	-1502(ra) # 53c4 <exit>
        printf("%s: wait wrong pid\n", s);
    19aa:	85d2                	mv	a1,s4
    19ac:	00005517          	auipc	a0,0x5
    19b0:	cf450513          	addi	a0,a0,-780 # 66a0 <malloc+0xea4>
    19b4:	00004097          	auipc	ra,0x4
    19b8:	d88080e7          	jalr	-632(ra) # 573c <printf>
        exit(1);
    19bc:	4505                	li	a0,1
    19be:	00004097          	auipc	ra,0x4
    19c2:	a06080e7          	jalr	-1530(ra) # 53c4 <exit>
        printf("%s: wait wrong exit status\n", s);
    19c6:	85d2                	mv	a1,s4
    19c8:	00005517          	auipc	a0,0x5
    19cc:	cf050513          	addi	a0,a0,-784 # 66b8 <malloc+0xebc>
    19d0:	00004097          	auipc	ra,0x4
    19d4:	d6c080e7          	jalr	-660(ra) # 573c <printf>
        exit(1);
    19d8:	4505                	li	a0,1
    19da:	00004097          	auipc	ra,0x4
    19de:	9ea080e7          	jalr	-1558(ra) # 53c4 <exit>
      exit(i);
    19e2:	8526                	mv	a0,s1
    19e4:	00004097          	auipc	ra,0x4
    19e8:	9e0080e7          	jalr	-1568(ra) # 53c4 <exit>

00000000000019ec <twochildren>:
{
    19ec:	1101                	addi	sp,sp,-32
    19ee:	ec06                	sd	ra,24(sp)
    19f0:	e822                	sd	s0,16(sp)
    19f2:	e426                	sd	s1,8(sp)
    19f4:	e04a                	sd	s2,0(sp)
    19f6:	1000                	addi	s0,sp,32
    19f8:	892a                	mv	s2,a0
    19fa:	3e800493          	li	s1,1000
    int pid1 = fork();
    19fe:	00004097          	auipc	ra,0x4
    1a02:	9be080e7          	jalr	-1602(ra) # 53bc <fork>
    if(pid1 < 0){
    1a06:	02054c63          	bltz	a0,1a3e <twochildren+0x52>
    if(pid1 == 0){
    1a0a:	c921                	beqz	a0,1a5a <twochildren+0x6e>
      int pid2 = fork();
    1a0c:	00004097          	auipc	ra,0x4
    1a10:	9b0080e7          	jalr	-1616(ra) # 53bc <fork>
      if(pid2 < 0){
    1a14:	04054763          	bltz	a0,1a62 <twochildren+0x76>
      if(pid2 == 0){
    1a18:	c13d                	beqz	a0,1a7e <twochildren+0x92>
        wait(0);
    1a1a:	4501                	li	a0,0
    1a1c:	00004097          	auipc	ra,0x4
    1a20:	9b0080e7          	jalr	-1616(ra) # 53cc <wait>
        wait(0);
    1a24:	4501                	li	a0,0
    1a26:	00004097          	auipc	ra,0x4
    1a2a:	9a6080e7          	jalr	-1626(ra) # 53cc <wait>
  for(int i = 0; i < 1000; i++){
    1a2e:	34fd                	addiw	s1,s1,-1
    1a30:	f4f9                	bnez	s1,19fe <twochildren+0x12>
}
    1a32:	60e2                	ld	ra,24(sp)
    1a34:	6442                	ld	s0,16(sp)
    1a36:	64a2                	ld	s1,8(sp)
    1a38:	6902                	ld	s2,0(sp)
    1a3a:	6105                	addi	sp,sp,32
    1a3c:	8082                	ret
      printf("%s: fork failed\n", s);
    1a3e:	85ca                	mv	a1,s2
    1a40:	00005517          	auipc	a0,0x5
    1a44:	ad850513          	addi	a0,a0,-1320 # 6518 <malloc+0xd1c>
    1a48:	00004097          	auipc	ra,0x4
    1a4c:	cf4080e7          	jalr	-780(ra) # 573c <printf>
      exit(1);
    1a50:	4505                	li	a0,1
    1a52:	00004097          	auipc	ra,0x4
    1a56:	972080e7          	jalr	-1678(ra) # 53c4 <exit>
      exit(0);
    1a5a:	00004097          	auipc	ra,0x4
    1a5e:	96a080e7          	jalr	-1686(ra) # 53c4 <exit>
        printf("%s: fork failed\n", s);
    1a62:	85ca                	mv	a1,s2
    1a64:	00005517          	auipc	a0,0x5
    1a68:	ab450513          	addi	a0,a0,-1356 # 6518 <malloc+0xd1c>
    1a6c:	00004097          	auipc	ra,0x4
    1a70:	cd0080e7          	jalr	-816(ra) # 573c <printf>
        exit(1);
    1a74:	4505                	li	a0,1
    1a76:	00004097          	auipc	ra,0x4
    1a7a:	94e080e7          	jalr	-1714(ra) # 53c4 <exit>
        exit(0);
    1a7e:	00004097          	auipc	ra,0x4
    1a82:	946080e7          	jalr	-1722(ra) # 53c4 <exit>

0000000000001a86 <forkfork>:
{
    1a86:	7179                	addi	sp,sp,-48
    1a88:	f406                	sd	ra,40(sp)
    1a8a:	f022                	sd	s0,32(sp)
    1a8c:	ec26                	sd	s1,24(sp)
    1a8e:	1800                	addi	s0,sp,48
    1a90:	84aa                	mv	s1,a0
    int pid = fork();
    1a92:	00004097          	auipc	ra,0x4
    1a96:	92a080e7          	jalr	-1750(ra) # 53bc <fork>
    if(pid < 0){
    1a9a:	04054163          	bltz	a0,1adc <forkfork+0x56>
    if(pid == 0){
    1a9e:	cd29                	beqz	a0,1af8 <forkfork+0x72>
    int pid = fork();
    1aa0:	00004097          	auipc	ra,0x4
    1aa4:	91c080e7          	jalr	-1764(ra) # 53bc <fork>
    if(pid < 0){
    1aa8:	02054a63          	bltz	a0,1adc <forkfork+0x56>
    if(pid == 0){
    1aac:	c531                	beqz	a0,1af8 <forkfork+0x72>
    wait(&xstatus);
    1aae:	fdc40513          	addi	a0,s0,-36
    1ab2:	00004097          	auipc	ra,0x4
    1ab6:	91a080e7          	jalr	-1766(ra) # 53cc <wait>
    if(xstatus != 0) {
    1aba:	fdc42783          	lw	a5,-36(s0)
    1abe:	ebbd                	bnez	a5,1b34 <forkfork+0xae>
    wait(&xstatus);
    1ac0:	fdc40513          	addi	a0,s0,-36
    1ac4:	00004097          	auipc	ra,0x4
    1ac8:	908080e7          	jalr	-1784(ra) # 53cc <wait>
    if(xstatus != 0) {
    1acc:	fdc42783          	lw	a5,-36(s0)
    1ad0:	e3b5                	bnez	a5,1b34 <forkfork+0xae>
}
    1ad2:	70a2                	ld	ra,40(sp)
    1ad4:	7402                	ld	s0,32(sp)
    1ad6:	64e2                	ld	s1,24(sp)
    1ad8:	6145                	addi	sp,sp,48
    1ada:	8082                	ret
      printf("%s: fork failed", s);
    1adc:	85a6                	mv	a1,s1
    1ade:	00005517          	auipc	a0,0x5
    1ae2:	bfa50513          	addi	a0,a0,-1030 # 66d8 <malloc+0xedc>
    1ae6:	00004097          	auipc	ra,0x4
    1aea:	c56080e7          	jalr	-938(ra) # 573c <printf>
      exit(1);
    1aee:	4505                	li	a0,1
    1af0:	00004097          	auipc	ra,0x4
    1af4:	8d4080e7          	jalr	-1836(ra) # 53c4 <exit>
{
    1af8:	0c800493          	li	s1,200
        int pid1 = fork();
    1afc:	00004097          	auipc	ra,0x4
    1b00:	8c0080e7          	jalr	-1856(ra) # 53bc <fork>
        if(pid1 < 0){
    1b04:	00054f63          	bltz	a0,1b22 <forkfork+0x9c>
        if(pid1 == 0){
    1b08:	c115                	beqz	a0,1b2c <forkfork+0xa6>
        wait(0);
    1b0a:	4501                	li	a0,0
    1b0c:	00004097          	auipc	ra,0x4
    1b10:	8c0080e7          	jalr	-1856(ra) # 53cc <wait>
      for(int j = 0; j < 200; j++){
    1b14:	34fd                	addiw	s1,s1,-1
    1b16:	f0fd                	bnez	s1,1afc <forkfork+0x76>
      exit(0);
    1b18:	4501                	li	a0,0
    1b1a:	00004097          	auipc	ra,0x4
    1b1e:	8aa080e7          	jalr	-1878(ra) # 53c4 <exit>
          exit(1);
    1b22:	4505                	li	a0,1
    1b24:	00004097          	auipc	ra,0x4
    1b28:	8a0080e7          	jalr	-1888(ra) # 53c4 <exit>
          exit(0);
    1b2c:	00004097          	auipc	ra,0x4
    1b30:	898080e7          	jalr	-1896(ra) # 53c4 <exit>
      printf("%s: fork in child failed", s);
    1b34:	85a6                	mv	a1,s1
    1b36:	00005517          	auipc	a0,0x5
    1b3a:	bb250513          	addi	a0,a0,-1102 # 66e8 <malloc+0xeec>
    1b3e:	00004097          	auipc	ra,0x4
    1b42:	bfe080e7          	jalr	-1026(ra) # 573c <printf>
      exit(1);
    1b46:	4505                	li	a0,1
    1b48:	00004097          	auipc	ra,0x4
    1b4c:	87c080e7          	jalr	-1924(ra) # 53c4 <exit>

0000000000001b50 <reparent2>:
{
    1b50:	1101                	addi	sp,sp,-32
    1b52:	ec06                	sd	ra,24(sp)
    1b54:	e822                	sd	s0,16(sp)
    1b56:	e426                	sd	s1,8(sp)
    1b58:	1000                	addi	s0,sp,32
    1b5a:	32000493          	li	s1,800
    int pid1 = fork();
    1b5e:	00004097          	auipc	ra,0x4
    1b62:	85e080e7          	jalr	-1954(ra) # 53bc <fork>
    if(pid1 < 0){
    1b66:	00054f63          	bltz	a0,1b84 <reparent2+0x34>
    if(pid1 == 0){
    1b6a:	c915                	beqz	a0,1b9e <reparent2+0x4e>
    wait(0);
    1b6c:	4501                	li	a0,0
    1b6e:	00004097          	auipc	ra,0x4
    1b72:	85e080e7          	jalr	-1954(ra) # 53cc <wait>
  for(int i = 0; i < 800; i++){
    1b76:	34fd                	addiw	s1,s1,-1
    1b78:	f0fd                	bnez	s1,1b5e <reparent2+0xe>
  exit(0);
    1b7a:	4501                	li	a0,0
    1b7c:	00004097          	auipc	ra,0x4
    1b80:	848080e7          	jalr	-1976(ra) # 53c4 <exit>
      printf("fork failed\n");
    1b84:	00005517          	auipc	a0,0x5
    1b88:	d8450513          	addi	a0,a0,-636 # 6908 <malloc+0x110c>
    1b8c:	00004097          	auipc	ra,0x4
    1b90:	bb0080e7          	jalr	-1104(ra) # 573c <printf>
      exit(1);
    1b94:	4505                	li	a0,1
    1b96:	00004097          	auipc	ra,0x4
    1b9a:	82e080e7          	jalr	-2002(ra) # 53c4 <exit>
      fork();
    1b9e:	00004097          	auipc	ra,0x4
    1ba2:	81e080e7          	jalr	-2018(ra) # 53bc <fork>
      fork();
    1ba6:	00004097          	auipc	ra,0x4
    1baa:	816080e7          	jalr	-2026(ra) # 53bc <fork>
      exit(0);
    1bae:	4501                	li	a0,0
    1bb0:	00004097          	auipc	ra,0x4
    1bb4:	814080e7          	jalr	-2028(ra) # 53c4 <exit>

0000000000001bb8 <createdelete>:
{
    1bb8:	7175                	addi	sp,sp,-144
    1bba:	e506                	sd	ra,136(sp)
    1bbc:	e122                	sd	s0,128(sp)
    1bbe:	fca6                	sd	s1,120(sp)
    1bc0:	f8ca                	sd	s2,112(sp)
    1bc2:	f4ce                	sd	s3,104(sp)
    1bc4:	f0d2                	sd	s4,96(sp)
    1bc6:	ecd6                	sd	s5,88(sp)
    1bc8:	e8da                	sd	s6,80(sp)
    1bca:	e4de                	sd	s7,72(sp)
    1bcc:	e0e2                	sd	s8,64(sp)
    1bce:	fc66                	sd	s9,56(sp)
    1bd0:	0900                	addi	s0,sp,144
    1bd2:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bd4:	4901                	li	s2,0
    1bd6:	4991                	li	s3,4
    pid = fork();
    1bd8:	00003097          	auipc	ra,0x3
    1bdc:	7e4080e7          	jalr	2020(ra) # 53bc <fork>
    1be0:	84aa                	mv	s1,a0
    if(pid < 0){
    1be2:	02054f63          	bltz	a0,1c20 <createdelete+0x68>
    if(pid == 0){
    1be6:	c939                	beqz	a0,1c3c <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1be8:	2905                	addiw	s2,s2,1
    1bea:	ff3917e3          	bne	s2,s3,1bd8 <createdelete+0x20>
    1bee:	4491                	li	s1,4
    wait(&xstatus);
    1bf0:	f7c40513          	addi	a0,s0,-132
    1bf4:	00003097          	auipc	ra,0x3
    1bf8:	7d8080e7          	jalr	2008(ra) # 53cc <wait>
    if(xstatus != 0)
    1bfc:	f7c42903          	lw	s2,-132(s0)
    1c00:	0e091263          	bnez	s2,1ce4 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1c04:	34fd                	addiw	s1,s1,-1
    1c06:	f4ed                	bnez	s1,1bf0 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1c08:	f8040123          	sb	zero,-126(s0)
    1c0c:	03000993          	li	s3,48
    1c10:	5a7d                	li	s4,-1
    1c12:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c16:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1c18:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1c1a:	07400a93          	li	s5,116
    1c1e:	a29d                	j	1d84 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1c20:	85e6                	mv	a1,s9
    1c22:	00005517          	auipc	a0,0x5
    1c26:	ce650513          	addi	a0,a0,-794 # 6908 <malloc+0x110c>
    1c2a:	00004097          	auipc	ra,0x4
    1c2e:	b12080e7          	jalr	-1262(ra) # 573c <printf>
      exit(1);
    1c32:	4505                	li	a0,1
    1c34:	00003097          	auipc	ra,0x3
    1c38:	790080e7          	jalr	1936(ra) # 53c4 <exit>
      name[0] = 'p' + pi;
    1c3c:	0709091b          	addiw	s2,s2,112
    1c40:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c44:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c48:	4951                	li	s2,20
    1c4a:	a015                	j	1c6e <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c4c:	85e6                	mv	a1,s9
    1c4e:	00005517          	auipc	a0,0x5
    1c52:	96250513          	addi	a0,a0,-1694 # 65b0 <malloc+0xdb4>
    1c56:	00004097          	auipc	ra,0x4
    1c5a:	ae6080e7          	jalr	-1306(ra) # 573c <printf>
          exit(1);
    1c5e:	4505                	li	a0,1
    1c60:	00003097          	auipc	ra,0x3
    1c64:	764080e7          	jalr	1892(ra) # 53c4 <exit>
      for(i = 0; i < N; i++){
    1c68:	2485                	addiw	s1,s1,1
    1c6a:	07248863          	beq	s1,s2,1cda <createdelete+0x122>
        name[1] = '0' + i;
    1c6e:	0304879b          	addiw	a5,s1,48
    1c72:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c76:	20200593          	li	a1,514
    1c7a:	f8040513          	addi	a0,s0,-128
    1c7e:	00003097          	auipc	ra,0x3
    1c82:	786080e7          	jalr	1926(ra) # 5404 <open>
        if(fd < 0){
    1c86:	fc0543e3          	bltz	a0,1c4c <createdelete+0x94>
        close(fd);
    1c8a:	00003097          	auipc	ra,0x3
    1c8e:	762080e7          	jalr	1890(ra) # 53ec <close>
        if(i > 0 && (i % 2 ) == 0){
    1c92:	fc905be3          	blez	s1,1c68 <createdelete+0xb0>
    1c96:	0014f793          	andi	a5,s1,1
    1c9a:	f7f9                	bnez	a5,1c68 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c9c:	01f4d79b          	srliw	a5,s1,0x1f
    1ca0:	9fa5                	addw	a5,a5,s1
    1ca2:	4017d79b          	sraiw	a5,a5,0x1
    1ca6:	0307879b          	addiw	a5,a5,48
    1caa:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1cae:	f8040513          	addi	a0,s0,-128
    1cb2:	00003097          	auipc	ra,0x3
    1cb6:	762080e7          	jalr	1890(ra) # 5414 <unlink>
    1cba:	fa0557e3          	bgez	a0,1c68 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1cbe:	85e6                	mv	a1,s9
    1cc0:	00005517          	auipc	a0,0x5
    1cc4:	a4850513          	addi	a0,a0,-1464 # 6708 <malloc+0xf0c>
    1cc8:	00004097          	auipc	ra,0x4
    1ccc:	a74080e7          	jalr	-1420(ra) # 573c <printf>
            exit(1);
    1cd0:	4505                	li	a0,1
    1cd2:	00003097          	auipc	ra,0x3
    1cd6:	6f2080e7          	jalr	1778(ra) # 53c4 <exit>
      exit(0);
    1cda:	4501                	li	a0,0
    1cdc:	00003097          	auipc	ra,0x3
    1ce0:	6e8080e7          	jalr	1768(ra) # 53c4 <exit>
      exit(1);
    1ce4:	4505                	li	a0,1
    1ce6:	00003097          	auipc	ra,0x3
    1cea:	6de080e7          	jalr	1758(ra) # 53c4 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cee:	f8040613          	addi	a2,s0,-128
    1cf2:	85e6                	mv	a1,s9
    1cf4:	00005517          	auipc	a0,0x5
    1cf8:	a2c50513          	addi	a0,a0,-1492 # 6720 <malloc+0xf24>
    1cfc:	00004097          	auipc	ra,0x4
    1d00:	a40080e7          	jalr	-1472(ra) # 573c <printf>
        exit(1);
    1d04:	4505                	li	a0,1
    1d06:	00003097          	auipc	ra,0x3
    1d0a:	6be080e7          	jalr	1726(ra) # 53c4 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d0e:	054b7163          	bleu	s4,s6,1d50 <createdelete+0x198>
      if(fd >= 0)
    1d12:	02055a63          	bgez	a0,1d46 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1d16:	2485                	addiw	s1,s1,1
    1d18:	0ff4f493          	andi	s1,s1,255
    1d1c:	05548c63          	beq	s1,s5,1d74 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1d20:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1d24:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d28:	4581                	li	a1,0
    1d2a:	f8040513          	addi	a0,s0,-128
    1d2e:	00003097          	auipc	ra,0x3
    1d32:	6d6080e7          	jalr	1750(ra) # 5404 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d36:	00090463          	beqz	s2,1d3e <createdelete+0x186>
    1d3a:	fd2bdae3          	ble	s2,s7,1d0e <createdelete+0x156>
    1d3e:	fa0548e3          	bltz	a0,1cee <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d42:	014b7963          	bleu	s4,s6,1d54 <createdelete+0x19c>
        close(fd);
    1d46:	00003097          	auipc	ra,0x3
    1d4a:	6a6080e7          	jalr	1702(ra) # 53ec <close>
    1d4e:	b7e1                	j	1d16 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d50:	fc0543e3          	bltz	a0,1d16 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d54:	f8040613          	addi	a2,s0,-128
    1d58:	85e6                	mv	a1,s9
    1d5a:	00005517          	auipc	a0,0x5
    1d5e:	9ee50513          	addi	a0,a0,-1554 # 6748 <malloc+0xf4c>
    1d62:	00004097          	auipc	ra,0x4
    1d66:	9da080e7          	jalr	-1574(ra) # 573c <printf>
        exit(1);
    1d6a:	4505                	li	a0,1
    1d6c:	00003097          	auipc	ra,0x3
    1d70:	658080e7          	jalr	1624(ra) # 53c4 <exit>
  for(i = 0; i < N; i++){
    1d74:	2905                	addiw	s2,s2,1
    1d76:	2a05                	addiw	s4,s4,1
    1d78:	2985                	addiw	s3,s3,1
    1d7a:	0ff9f993          	andi	s3,s3,255
    1d7e:	47d1                	li	a5,20
    1d80:	02f90a63          	beq	s2,a5,1db4 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d84:	84e2                	mv	s1,s8
    1d86:	bf69                	j	1d20 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d88:	2905                	addiw	s2,s2,1
    1d8a:	0ff97913          	andi	s2,s2,255
    1d8e:	2985                	addiw	s3,s3,1
    1d90:	0ff9f993          	andi	s3,s3,255
    1d94:	03490863          	beq	s2,s4,1dc4 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d98:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d9a:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d9e:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1da2:	f8040513          	addi	a0,s0,-128
    1da6:	00003097          	auipc	ra,0x3
    1daa:	66e080e7          	jalr	1646(ra) # 5414 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1dae:	34fd                	addiw	s1,s1,-1
    1db0:	f4ed                	bnez	s1,1d9a <createdelete+0x1e2>
    1db2:	bfd9                	j	1d88 <createdelete+0x1d0>
    1db4:	03000993          	li	s3,48
    1db8:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1dbc:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1dbe:	08400a13          	li	s4,132
    1dc2:	bfd9                	j	1d98 <createdelete+0x1e0>
}
    1dc4:	60aa                	ld	ra,136(sp)
    1dc6:	640a                	ld	s0,128(sp)
    1dc8:	74e6                	ld	s1,120(sp)
    1dca:	7946                	ld	s2,112(sp)
    1dcc:	79a6                	ld	s3,104(sp)
    1dce:	7a06                	ld	s4,96(sp)
    1dd0:	6ae6                	ld	s5,88(sp)
    1dd2:	6b46                	ld	s6,80(sp)
    1dd4:	6ba6                	ld	s7,72(sp)
    1dd6:	6c06                	ld	s8,64(sp)
    1dd8:	7ce2                	ld	s9,56(sp)
    1dda:	6149                	addi	sp,sp,144
    1ddc:	8082                	ret

0000000000001dde <linkunlink>:
{
    1dde:	711d                	addi	sp,sp,-96
    1de0:	ec86                	sd	ra,88(sp)
    1de2:	e8a2                	sd	s0,80(sp)
    1de4:	e4a6                	sd	s1,72(sp)
    1de6:	e0ca                	sd	s2,64(sp)
    1de8:	fc4e                	sd	s3,56(sp)
    1dea:	f852                	sd	s4,48(sp)
    1dec:	f456                	sd	s5,40(sp)
    1dee:	f05a                	sd	s6,32(sp)
    1df0:	ec5e                	sd	s7,24(sp)
    1df2:	e862                	sd	s8,16(sp)
    1df4:	e466                	sd	s9,8(sp)
    1df6:	1080                	addi	s0,sp,96
    1df8:	84aa                	mv	s1,a0
  unlink("x");
    1dfa:	00004517          	auipc	a0,0x4
    1dfe:	f3650513          	addi	a0,a0,-202 # 5d30 <malloc+0x534>
    1e02:	00003097          	auipc	ra,0x3
    1e06:	612080e7          	jalr	1554(ra) # 5414 <unlink>
  pid = fork();
    1e0a:	00003097          	auipc	ra,0x3
    1e0e:	5b2080e7          	jalr	1458(ra) # 53bc <fork>
  if(pid < 0){
    1e12:	02054b63          	bltz	a0,1e48 <linkunlink+0x6a>
    1e16:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1e18:	4c85                	li	s9,1
    1e1a:	e119                	bnez	a0,1e20 <linkunlink+0x42>
    1e1c:	06100c93          	li	s9,97
    1e20:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1e24:	41c659b7          	lui	s3,0x41c65
    1e28:	e6d9899b          	addiw	s3,s3,-403
    1e2c:	690d                	lui	s2,0x3
    1e2e:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e32:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e34:	4b05                	li	s6,1
      unlink("x");
    1e36:	00004a97          	auipc	s5,0x4
    1e3a:	efaa8a93          	addi	s5,s5,-262 # 5d30 <malloc+0x534>
      link("cat", "x");
    1e3e:	00005b97          	auipc	s7,0x5
    1e42:	932b8b93          	addi	s7,s7,-1742 # 6770 <malloc+0xf74>
    1e46:	a091                	j	1e8a <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e48:	85a6                	mv	a1,s1
    1e4a:	00004517          	auipc	a0,0x4
    1e4e:	6ce50513          	addi	a0,a0,1742 # 6518 <malloc+0xd1c>
    1e52:	00004097          	auipc	ra,0x4
    1e56:	8ea080e7          	jalr	-1814(ra) # 573c <printf>
    exit(1);
    1e5a:	4505                	li	a0,1
    1e5c:	00003097          	auipc	ra,0x3
    1e60:	568080e7          	jalr	1384(ra) # 53c4 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e64:	20200593          	li	a1,514
    1e68:	8556                	mv	a0,s5
    1e6a:	00003097          	auipc	ra,0x3
    1e6e:	59a080e7          	jalr	1434(ra) # 5404 <open>
    1e72:	00003097          	auipc	ra,0x3
    1e76:	57a080e7          	jalr	1402(ra) # 53ec <close>
    1e7a:	a031                	j	1e86 <linkunlink+0xa8>
      unlink("x");
    1e7c:	8556                	mv	a0,s5
    1e7e:	00003097          	auipc	ra,0x3
    1e82:	596080e7          	jalr	1430(ra) # 5414 <unlink>
  for(i = 0; i < 100; i++){
    1e86:	34fd                	addiw	s1,s1,-1
    1e88:	c09d                	beqz	s1,1eae <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e8a:	033c87bb          	mulw	a5,s9,s3
    1e8e:	012787bb          	addw	a5,a5,s2
    1e92:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e96:	0347f7bb          	remuw	a5,a5,s4
    1e9a:	d7e9                	beqz	a5,1e64 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e9c:	ff6790e3          	bne	a5,s6,1e7c <linkunlink+0x9e>
      link("cat", "x");
    1ea0:	85d6                	mv	a1,s5
    1ea2:	855e                	mv	a0,s7
    1ea4:	00003097          	auipc	ra,0x3
    1ea8:	580080e7          	jalr	1408(ra) # 5424 <link>
    1eac:	bfe9                	j	1e86 <linkunlink+0xa8>
  if(pid)
    1eae:	020c0463          	beqz	s8,1ed6 <linkunlink+0xf8>
    wait(0);
    1eb2:	4501                	li	a0,0
    1eb4:	00003097          	auipc	ra,0x3
    1eb8:	518080e7          	jalr	1304(ra) # 53cc <wait>
}
    1ebc:	60e6                	ld	ra,88(sp)
    1ebe:	6446                	ld	s0,80(sp)
    1ec0:	64a6                	ld	s1,72(sp)
    1ec2:	6906                	ld	s2,64(sp)
    1ec4:	79e2                	ld	s3,56(sp)
    1ec6:	7a42                	ld	s4,48(sp)
    1ec8:	7aa2                	ld	s5,40(sp)
    1eca:	7b02                	ld	s6,32(sp)
    1ecc:	6be2                	ld	s7,24(sp)
    1ece:	6c42                	ld	s8,16(sp)
    1ed0:	6ca2                	ld	s9,8(sp)
    1ed2:	6125                	addi	sp,sp,96
    1ed4:	8082                	ret
    exit(0);
    1ed6:	4501                	li	a0,0
    1ed8:	00003097          	auipc	ra,0x3
    1edc:	4ec080e7          	jalr	1260(ra) # 53c4 <exit>

0000000000001ee0 <forktest>:
{
    1ee0:	7179                	addi	sp,sp,-48
    1ee2:	f406                	sd	ra,40(sp)
    1ee4:	f022                	sd	s0,32(sp)
    1ee6:	ec26                	sd	s1,24(sp)
    1ee8:	e84a                	sd	s2,16(sp)
    1eea:	e44e                	sd	s3,8(sp)
    1eec:	1800                	addi	s0,sp,48
    1eee:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ef0:	4481                	li	s1,0
    1ef2:	3e800913          	li	s2,1000
    pid = fork();
    1ef6:	00003097          	auipc	ra,0x3
    1efa:	4c6080e7          	jalr	1222(ra) # 53bc <fork>
    if(pid < 0)
    1efe:	02054863          	bltz	a0,1f2e <forktest+0x4e>
    if(pid == 0)
    1f02:	c115                	beqz	a0,1f26 <forktest+0x46>
  for(n=0; n<N; n++){
    1f04:	2485                	addiw	s1,s1,1
    1f06:	ff2498e3          	bne	s1,s2,1ef6 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1f0a:	85ce                	mv	a1,s3
    1f0c:	00005517          	auipc	a0,0x5
    1f10:	88450513          	addi	a0,a0,-1916 # 6790 <malloc+0xf94>
    1f14:	00004097          	auipc	ra,0x4
    1f18:	828080e7          	jalr	-2008(ra) # 573c <printf>
    exit(1);
    1f1c:	4505                	li	a0,1
    1f1e:	00003097          	auipc	ra,0x3
    1f22:	4a6080e7          	jalr	1190(ra) # 53c4 <exit>
      exit(0);
    1f26:	00003097          	auipc	ra,0x3
    1f2a:	49e080e7          	jalr	1182(ra) # 53c4 <exit>
  if (n == 0) {
    1f2e:	cc9d                	beqz	s1,1f6c <forktest+0x8c>
  if(n == N){
    1f30:	3e800793          	li	a5,1000
    1f34:	fcf48be3          	beq	s1,a5,1f0a <forktest+0x2a>
  for(; n > 0; n--){
    1f38:	00905b63          	blez	s1,1f4e <forktest+0x6e>
    if(wait(0) < 0){
    1f3c:	4501                	li	a0,0
    1f3e:	00003097          	auipc	ra,0x3
    1f42:	48e080e7          	jalr	1166(ra) # 53cc <wait>
    1f46:	04054163          	bltz	a0,1f88 <forktest+0xa8>
  for(; n > 0; n--){
    1f4a:	34fd                	addiw	s1,s1,-1
    1f4c:	f8e5                	bnez	s1,1f3c <forktest+0x5c>
  if(wait(0) != -1){
    1f4e:	4501                	li	a0,0
    1f50:	00003097          	auipc	ra,0x3
    1f54:	47c080e7          	jalr	1148(ra) # 53cc <wait>
    1f58:	57fd                	li	a5,-1
    1f5a:	04f51563          	bne	a0,a5,1fa4 <forktest+0xc4>
}
    1f5e:	70a2                	ld	ra,40(sp)
    1f60:	7402                	ld	s0,32(sp)
    1f62:	64e2                	ld	s1,24(sp)
    1f64:	6942                	ld	s2,16(sp)
    1f66:	69a2                	ld	s3,8(sp)
    1f68:	6145                	addi	sp,sp,48
    1f6a:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1f6c:	85ce                	mv	a1,s3
    1f6e:	00005517          	auipc	a0,0x5
    1f72:	80a50513          	addi	a0,a0,-2038 # 6778 <malloc+0xf7c>
    1f76:	00003097          	auipc	ra,0x3
    1f7a:	7c6080e7          	jalr	1990(ra) # 573c <printf>
    exit(1);
    1f7e:	4505                	li	a0,1
    1f80:	00003097          	auipc	ra,0x3
    1f84:	444080e7          	jalr	1092(ra) # 53c4 <exit>
      printf("%s: wait stopped early\n", s);
    1f88:	85ce                	mv	a1,s3
    1f8a:	00005517          	auipc	a0,0x5
    1f8e:	82e50513          	addi	a0,a0,-2002 # 67b8 <malloc+0xfbc>
    1f92:	00003097          	auipc	ra,0x3
    1f96:	7aa080e7          	jalr	1962(ra) # 573c <printf>
      exit(1);
    1f9a:	4505                	li	a0,1
    1f9c:	00003097          	auipc	ra,0x3
    1fa0:	428080e7          	jalr	1064(ra) # 53c4 <exit>
    printf("%s: wait got too many\n", s);
    1fa4:	85ce                	mv	a1,s3
    1fa6:	00005517          	auipc	a0,0x5
    1faa:	82a50513          	addi	a0,a0,-2006 # 67d0 <malloc+0xfd4>
    1fae:	00003097          	auipc	ra,0x3
    1fb2:	78e080e7          	jalr	1934(ra) # 573c <printf>
    exit(1);
    1fb6:	4505                	li	a0,1
    1fb8:	00003097          	auipc	ra,0x3
    1fbc:	40c080e7          	jalr	1036(ra) # 53c4 <exit>

0000000000001fc0 <kernmem>:
{
    1fc0:	715d                	addi	sp,sp,-80
    1fc2:	e486                	sd	ra,72(sp)
    1fc4:	e0a2                	sd	s0,64(sp)
    1fc6:	fc26                	sd	s1,56(sp)
    1fc8:	f84a                	sd	s2,48(sp)
    1fca:	f44e                	sd	s3,40(sp)
    1fcc:	f052                	sd	s4,32(sp)
    1fce:	ec56                	sd	s5,24(sp)
    1fd0:	0880                	addi	s0,sp,80
    1fd2:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fd4:	4485                	li	s1,1
    1fd6:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1fd8:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fda:	69b1                	lui	s3,0xc
    1fdc:	35098993          	addi	s3,s3,848 # c350 <buf+0xbc8>
    1fe0:	1003d937          	lui	s2,0x1003d
    1fe4:	090e                	slli	s2,s2,0x3
    1fe6:	48090913          	addi	s2,s2,1152 # 1003d480 <_end+0x1002ece8>
    pid = fork();
    1fea:	00003097          	auipc	ra,0x3
    1fee:	3d2080e7          	jalr	978(ra) # 53bc <fork>
    if(pid < 0){
    1ff2:	02054963          	bltz	a0,2024 <kernmem+0x64>
    if(pid == 0){
    1ff6:	c529                	beqz	a0,2040 <kernmem+0x80>
    wait(&xstatus);
    1ff8:	fbc40513          	addi	a0,s0,-68
    1ffc:	00003097          	auipc	ra,0x3
    2000:	3d0080e7          	jalr	976(ra) # 53cc <wait>
    if(xstatus != -1)  // did kernel kill child?
    2004:	fbc42783          	lw	a5,-68(s0)
    2008:	05479c63          	bne	a5,s4,2060 <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    200c:	94ce                	add	s1,s1,s3
    200e:	fd249ee3          	bne	s1,s2,1fea <kernmem+0x2a>
}
    2012:	60a6                	ld	ra,72(sp)
    2014:	6406                	ld	s0,64(sp)
    2016:	74e2                	ld	s1,56(sp)
    2018:	7942                	ld	s2,48(sp)
    201a:	79a2                	ld	s3,40(sp)
    201c:	7a02                	ld	s4,32(sp)
    201e:	6ae2                	ld	s5,24(sp)
    2020:	6161                	addi	sp,sp,80
    2022:	8082                	ret
      printf("%s: fork failed\n", s);
    2024:	85d6                	mv	a1,s5
    2026:	00004517          	auipc	a0,0x4
    202a:	4f250513          	addi	a0,a0,1266 # 6518 <malloc+0xd1c>
    202e:	00003097          	auipc	ra,0x3
    2032:	70e080e7          	jalr	1806(ra) # 573c <printf>
      exit(1);
    2036:	4505                	li	a0,1
    2038:	00003097          	auipc	ra,0x3
    203c:	38c080e7          	jalr	908(ra) # 53c4 <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    2040:	0004c603          	lbu	a2,0(s1)
    2044:	85a6                	mv	a1,s1
    2046:	00004517          	auipc	a0,0x4
    204a:	7a250513          	addi	a0,a0,1954 # 67e8 <malloc+0xfec>
    204e:	00003097          	auipc	ra,0x3
    2052:	6ee080e7          	jalr	1774(ra) # 573c <printf>
      exit(1);
    2056:	4505                	li	a0,1
    2058:	00003097          	auipc	ra,0x3
    205c:	36c080e7          	jalr	876(ra) # 53c4 <exit>
      exit(1);
    2060:	4505                	li	a0,1
    2062:	00003097          	auipc	ra,0x3
    2066:	362080e7          	jalr	866(ra) # 53c4 <exit>

000000000000206a <bigargtest>:
{
    206a:	7179                	addi	sp,sp,-48
    206c:	f406                	sd	ra,40(sp)
    206e:	f022                	sd	s0,32(sp)
    2070:	ec26                	sd	s1,24(sp)
    2072:	1800                	addi	s0,sp,48
    2074:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2076:	00004517          	auipc	a0,0x4
    207a:	79250513          	addi	a0,a0,1938 # 6808 <malloc+0x100c>
    207e:	00003097          	auipc	ra,0x3
    2082:	396080e7          	jalr	918(ra) # 5414 <unlink>
  pid = fork();
    2086:	00003097          	auipc	ra,0x3
    208a:	336080e7          	jalr	822(ra) # 53bc <fork>
  if(pid == 0){
    208e:	c121                	beqz	a0,20ce <bigargtest+0x64>
  } else if(pid < 0){
    2090:	0a054063          	bltz	a0,2130 <bigargtest+0xc6>
  wait(&xstatus);
    2094:	fdc40513          	addi	a0,s0,-36
    2098:	00003097          	auipc	ra,0x3
    209c:	334080e7          	jalr	820(ra) # 53cc <wait>
  if(xstatus != 0)
    20a0:	fdc42503          	lw	a0,-36(s0)
    20a4:	e545                	bnez	a0,214c <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    20a6:	4581                	li	a1,0
    20a8:	00004517          	auipc	a0,0x4
    20ac:	76050513          	addi	a0,a0,1888 # 6808 <malloc+0x100c>
    20b0:	00003097          	auipc	ra,0x3
    20b4:	354080e7          	jalr	852(ra) # 5404 <open>
  if(fd < 0){
    20b8:	08054e63          	bltz	a0,2154 <bigargtest+0xea>
  close(fd);
    20bc:	00003097          	auipc	ra,0x3
    20c0:	330080e7          	jalr	816(ra) # 53ec <close>
}
    20c4:	70a2                	ld	ra,40(sp)
    20c6:	7402                	ld	s0,32(sp)
    20c8:	64e2                	ld	s1,24(sp)
    20ca:	6145                	addi	sp,sp,48
    20cc:	8082                	ret
    20ce:	00006797          	auipc	a5,0x6
    20d2:	ea278793          	addi	a5,a5,-350 # 7f70 <args.1822>
    20d6:	00006697          	auipc	a3,0x6
    20da:	f9268693          	addi	a3,a3,-110 # 8068 <args.1822+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    20de:	00004717          	auipc	a4,0x4
    20e2:	73a70713          	addi	a4,a4,1850 # 6818 <malloc+0x101c>
    20e6:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    20e8:	07a1                	addi	a5,a5,8
    20ea:	fed79ee3          	bne	a5,a3,20e6 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    20ee:	00006597          	auipc	a1,0x6
    20f2:	e8258593          	addi	a1,a1,-382 # 7f70 <args.1822>
    20f6:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    20fa:	00004517          	auipc	a0,0x4
    20fe:	bc650513          	addi	a0,a0,-1082 # 5cc0 <malloc+0x4c4>
    2102:	00003097          	auipc	ra,0x3
    2106:	2fa080e7          	jalr	762(ra) # 53fc <exec>
    fd = open("bigarg-ok", O_CREATE);
    210a:	20000593          	li	a1,512
    210e:	00004517          	auipc	a0,0x4
    2112:	6fa50513          	addi	a0,a0,1786 # 6808 <malloc+0x100c>
    2116:	00003097          	auipc	ra,0x3
    211a:	2ee080e7          	jalr	750(ra) # 5404 <open>
    close(fd);
    211e:	00003097          	auipc	ra,0x3
    2122:	2ce080e7          	jalr	718(ra) # 53ec <close>
    exit(0);
    2126:	4501                	li	a0,0
    2128:	00003097          	auipc	ra,0x3
    212c:	29c080e7          	jalr	668(ra) # 53c4 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2130:	85a6                	mv	a1,s1
    2132:	00004517          	auipc	a0,0x4
    2136:	7c650513          	addi	a0,a0,1990 # 68f8 <malloc+0x10fc>
    213a:	00003097          	auipc	ra,0x3
    213e:	602080e7          	jalr	1538(ra) # 573c <printf>
    exit(1);
    2142:	4505                	li	a0,1
    2144:	00003097          	auipc	ra,0x3
    2148:	280080e7          	jalr	640(ra) # 53c4 <exit>
    exit(xstatus);
    214c:	00003097          	auipc	ra,0x3
    2150:	278080e7          	jalr	632(ra) # 53c4 <exit>
    printf("%s: bigarg test failed!\n", s);
    2154:	85a6                	mv	a1,s1
    2156:	00004517          	auipc	a0,0x4
    215a:	7c250513          	addi	a0,a0,1986 # 6918 <malloc+0x111c>
    215e:	00003097          	auipc	ra,0x3
    2162:	5de080e7          	jalr	1502(ra) # 573c <printf>
    exit(1);
    2166:	4505                	li	a0,1
    2168:	00003097          	auipc	ra,0x3
    216c:	25c080e7          	jalr	604(ra) # 53c4 <exit>

0000000000002170 <stacktest>:
{
    2170:	7179                	addi	sp,sp,-48
    2172:	f406                	sd	ra,40(sp)
    2174:	f022                	sd	s0,32(sp)
    2176:	ec26                	sd	s1,24(sp)
    2178:	1800                	addi	s0,sp,48
    217a:	84aa                	mv	s1,a0
  pid = fork();
    217c:	00003097          	auipc	ra,0x3
    2180:	240080e7          	jalr	576(ra) # 53bc <fork>
  if(pid == 0) {
    2184:	c115                	beqz	a0,21a8 <stacktest+0x38>
  } else if(pid < 0){
    2186:	04054363          	bltz	a0,21cc <stacktest+0x5c>
  wait(&xstatus);
    218a:	fdc40513          	addi	a0,s0,-36
    218e:	00003097          	auipc	ra,0x3
    2192:	23e080e7          	jalr	574(ra) # 53cc <wait>
  if(xstatus == -1)  // kernel killed child?
    2196:	fdc42503          	lw	a0,-36(s0)
    219a:	57fd                	li	a5,-1
    219c:	04f50663          	beq	a0,a5,21e8 <stacktest+0x78>
    exit(xstatus);
    21a0:	00003097          	auipc	ra,0x3
    21a4:	224080e7          	jalr	548(ra) # 53c4 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    21a8:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    21aa:	77fd                	lui	a5,0xfffff
    21ac:	97ba                	add	a5,a5,a4
    21ae:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <_end+0xffffffffffff0868>
    21b2:	00004517          	auipc	a0,0x4
    21b6:	78650513          	addi	a0,a0,1926 # 6938 <malloc+0x113c>
    21ba:	00003097          	auipc	ra,0x3
    21be:	582080e7          	jalr	1410(ra) # 573c <printf>
    exit(1);
    21c2:	4505                	li	a0,1
    21c4:	00003097          	auipc	ra,0x3
    21c8:	200080e7          	jalr	512(ra) # 53c4 <exit>
    printf("%s: fork failed\n", s);
    21cc:	85a6                	mv	a1,s1
    21ce:	00004517          	auipc	a0,0x4
    21d2:	34a50513          	addi	a0,a0,842 # 6518 <malloc+0xd1c>
    21d6:	00003097          	auipc	ra,0x3
    21da:	566080e7          	jalr	1382(ra) # 573c <printf>
    exit(1);
    21de:	4505                	li	a0,1
    21e0:	00003097          	auipc	ra,0x3
    21e4:	1e4080e7          	jalr	484(ra) # 53c4 <exit>
    exit(0);
    21e8:	4501                	li	a0,0
    21ea:	00003097          	auipc	ra,0x3
    21ee:	1da080e7          	jalr	474(ra) # 53c4 <exit>

00000000000021f2 <copyinstr3>:
{
    21f2:	7179                	addi	sp,sp,-48
    21f4:	f406                	sd	ra,40(sp)
    21f6:	f022                	sd	s0,32(sp)
    21f8:	ec26                	sd	s1,24(sp)
    21fa:	1800                	addi	s0,sp,48
  sbrk(8192);
    21fc:	6509                	lui	a0,0x2
    21fe:	00003097          	auipc	ra,0x3
    2202:	24e080e7          	jalr	590(ra) # 544c <sbrk>
  uint64 top = (uint64) sbrk(0);
    2206:	4501                	li	a0,0
    2208:	00003097          	auipc	ra,0x3
    220c:	244080e7          	jalr	580(ra) # 544c <sbrk>
  if((top % PGSIZE) != 0){
    2210:	6785                	lui	a5,0x1
    2212:	17fd                	addi	a5,a5,-1
    2214:	8fe9                	and	a5,a5,a0
    2216:	e3d1                	bnez	a5,229a <copyinstr3+0xa8>
  top = (uint64) sbrk(0);
    2218:	4501                	li	a0,0
    221a:	00003097          	auipc	ra,0x3
    221e:	232080e7          	jalr	562(ra) # 544c <sbrk>
  if(top % PGSIZE){
    2222:	6785                	lui	a5,0x1
    2224:	17fd                	addi	a5,a5,-1
    2226:	8fe9                	and	a5,a5,a0
    2228:	e7c1                	bnez	a5,22b0 <copyinstr3+0xbe>
  char *b = (char *) (top - 1);
    222a:	fff50493          	addi	s1,a0,-1 # 1fff <kernmem+0x3f>
  *b = 'x';
    222e:	07800793          	li	a5,120
    2232:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2236:	8526                	mv	a0,s1
    2238:	00003097          	auipc	ra,0x3
    223c:	1dc080e7          	jalr	476(ra) # 5414 <unlink>
  if(ret != -1){
    2240:	57fd                	li	a5,-1
    2242:	08f51463          	bne	a0,a5,22ca <copyinstr3+0xd8>
  int fd = open(b, O_CREATE | O_WRONLY);
    2246:	20100593          	li	a1,513
    224a:	8526                	mv	a0,s1
    224c:	00003097          	auipc	ra,0x3
    2250:	1b8080e7          	jalr	440(ra) # 5404 <open>
  if(fd != -1){
    2254:	57fd                	li	a5,-1
    2256:	08f51963          	bne	a0,a5,22e8 <copyinstr3+0xf6>
  ret = link(b, b);
    225a:	85a6                	mv	a1,s1
    225c:	8526                	mv	a0,s1
    225e:	00003097          	auipc	ra,0x3
    2262:	1c6080e7          	jalr	454(ra) # 5424 <link>
  if(ret != -1){
    2266:	57fd                	li	a5,-1
    2268:	08f51f63          	bne	a0,a5,2306 <copyinstr3+0x114>
  char *args[] = { "xx", 0 };
    226c:	00005797          	auipc	a5,0x5
    2270:	27478793          	addi	a5,a5,628 # 74e0 <malloc+0x1ce4>
    2274:	fcf43823          	sd	a5,-48(s0)
    2278:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    227c:	fd040593          	addi	a1,s0,-48
    2280:	8526                	mv	a0,s1
    2282:	00003097          	auipc	ra,0x3
    2286:	17a080e7          	jalr	378(ra) # 53fc <exec>
  if(ret != -1){
    228a:	57fd                	li	a5,-1
    228c:	08f51d63          	bne	a0,a5,2326 <copyinstr3+0x134>
}
    2290:	70a2                	ld	ra,40(sp)
    2292:	7402                	ld	s0,32(sp)
    2294:	64e2                	ld	s1,24(sp)
    2296:	6145                	addi	sp,sp,48
    2298:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    229a:	6785                	lui	a5,0x1
    229c:	17fd                	addi	a5,a5,-1
    229e:	8d7d                	and	a0,a0,a5
    22a0:	6785                	lui	a5,0x1
    22a2:	40a7853b          	subw	a0,a5,a0
    22a6:	00003097          	auipc	ra,0x3
    22aa:	1a6080e7          	jalr	422(ra) # 544c <sbrk>
    22ae:	b7ad                	j	2218 <copyinstr3+0x26>
    printf("oops\n");
    22b0:	00004517          	auipc	a0,0x4
    22b4:	6b050513          	addi	a0,a0,1712 # 6960 <malloc+0x1164>
    22b8:	00003097          	auipc	ra,0x3
    22bc:	484080e7          	jalr	1156(ra) # 573c <printf>
    exit(1);
    22c0:	4505                	li	a0,1
    22c2:	00003097          	auipc	ra,0x3
    22c6:	102080e7          	jalr	258(ra) # 53c4 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    22ca:	862a                	mv	a2,a0
    22cc:	85a6                	mv	a1,s1
    22ce:	00004517          	auipc	a0,0x4
    22d2:	16a50513          	addi	a0,a0,362 # 6438 <malloc+0xc3c>
    22d6:	00003097          	auipc	ra,0x3
    22da:	466080e7          	jalr	1126(ra) # 573c <printf>
    exit(1);
    22de:	4505                	li	a0,1
    22e0:	00003097          	auipc	ra,0x3
    22e4:	0e4080e7          	jalr	228(ra) # 53c4 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    22e8:	862a                	mv	a2,a0
    22ea:	85a6                	mv	a1,s1
    22ec:	00004517          	auipc	a0,0x4
    22f0:	16c50513          	addi	a0,a0,364 # 6458 <malloc+0xc5c>
    22f4:	00003097          	auipc	ra,0x3
    22f8:	448080e7          	jalr	1096(ra) # 573c <printf>
    exit(1);
    22fc:	4505                	li	a0,1
    22fe:	00003097          	auipc	ra,0x3
    2302:	0c6080e7          	jalr	198(ra) # 53c4 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2306:	86aa                	mv	a3,a0
    2308:	8626                	mv	a2,s1
    230a:	85a6                	mv	a1,s1
    230c:	00004517          	auipc	a0,0x4
    2310:	16c50513          	addi	a0,a0,364 # 6478 <malloc+0xc7c>
    2314:	00003097          	auipc	ra,0x3
    2318:	428080e7          	jalr	1064(ra) # 573c <printf>
    exit(1);
    231c:	4505                	li	a0,1
    231e:	00003097          	auipc	ra,0x3
    2322:	0a6080e7          	jalr	166(ra) # 53c4 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2326:	567d                	li	a2,-1
    2328:	85a6                	mv	a1,s1
    232a:	00004517          	auipc	a0,0x4
    232e:	17650513          	addi	a0,a0,374 # 64a0 <malloc+0xca4>
    2332:	00003097          	auipc	ra,0x3
    2336:	40a080e7          	jalr	1034(ra) # 573c <printf>
    exit(1);
    233a:	4505                	li	a0,1
    233c:	00003097          	auipc	ra,0x3
    2340:	088080e7          	jalr	136(ra) # 53c4 <exit>

0000000000002344 <sbrkbasic>:
{
    2344:	715d                	addi	sp,sp,-80
    2346:	e486                	sd	ra,72(sp)
    2348:	e0a2                	sd	s0,64(sp)
    234a:	fc26                	sd	s1,56(sp)
    234c:	f84a                	sd	s2,48(sp)
    234e:	f44e                	sd	s3,40(sp)
    2350:	f052                	sd	s4,32(sp)
    2352:	ec56                	sd	s5,24(sp)
    2354:	0880                	addi	s0,sp,80
    2356:	8aaa                	mv	s5,a0
  pid = fork();
    2358:	00003097          	auipc	ra,0x3
    235c:	064080e7          	jalr	100(ra) # 53bc <fork>
  if(pid < 0){
    2360:	02054c63          	bltz	a0,2398 <sbrkbasic+0x54>
  if(pid == 0){
    2364:	ed21                	bnez	a0,23bc <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    2366:	40000537          	lui	a0,0x40000
    236a:	00003097          	auipc	ra,0x3
    236e:	0e2080e7          	jalr	226(ra) # 544c <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2372:	57fd                	li	a5,-1
    2374:	02f50f63          	beq	a0,a5,23b2 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2378:	400007b7          	lui	a5,0x40000
    237c:	97aa                	add	a5,a5,a0
      *b = 99;
    237e:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2382:	6705                	lui	a4,0x1
      *b = 99;
    2384:	00d50023          	sb	a3,0(a0) # 40000000 <_end+0x3fff1868>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2388:	953a                	add	a0,a0,a4
    238a:	fef51de3          	bne	a0,a5,2384 <sbrkbasic+0x40>
    exit(1);
    238e:	4505                	li	a0,1
    2390:	00003097          	auipc	ra,0x3
    2394:	034080e7          	jalr	52(ra) # 53c4 <exit>
    printf("fork failed in sbrkbasic\n");
    2398:	00004517          	auipc	a0,0x4
    239c:	5d050513          	addi	a0,a0,1488 # 6968 <malloc+0x116c>
    23a0:	00003097          	auipc	ra,0x3
    23a4:	39c080e7          	jalr	924(ra) # 573c <printf>
    exit(1);
    23a8:	4505                	li	a0,1
    23aa:	00003097          	auipc	ra,0x3
    23ae:	01a080e7          	jalr	26(ra) # 53c4 <exit>
      exit(0);
    23b2:	4501                	li	a0,0
    23b4:	00003097          	auipc	ra,0x3
    23b8:	010080e7          	jalr	16(ra) # 53c4 <exit>
  wait(&xstatus);
    23bc:	fbc40513          	addi	a0,s0,-68
    23c0:	00003097          	auipc	ra,0x3
    23c4:	00c080e7          	jalr	12(ra) # 53cc <wait>
  if(xstatus == 1){
    23c8:	fbc42703          	lw	a4,-68(s0)
    23cc:	4785                	li	a5,1
    23ce:	00f70e63          	beq	a4,a5,23ea <sbrkbasic+0xa6>
  a = sbrk(0);
    23d2:	4501                	li	a0,0
    23d4:	00003097          	auipc	ra,0x3
    23d8:	078080e7          	jalr	120(ra) # 544c <sbrk>
    23dc:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    23de:	4901                	li	s2,0
    *b = 1;
    23e0:	4a05                	li	s4,1
  for(i = 0; i < 5000; i++){
    23e2:	6985                	lui	s3,0x1
    23e4:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1ba>
    23e8:	a005                	j	2408 <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    23ea:	85d6                	mv	a1,s5
    23ec:	00004517          	auipc	a0,0x4
    23f0:	59c50513          	addi	a0,a0,1436 # 6988 <malloc+0x118c>
    23f4:	00003097          	auipc	ra,0x3
    23f8:	348080e7          	jalr	840(ra) # 573c <printf>
    exit(1);
    23fc:	4505                	li	a0,1
    23fe:	00003097          	auipc	ra,0x3
    2402:	fc6080e7          	jalr	-58(ra) # 53c4 <exit>
    a = b + 1;
    2406:	84be                	mv	s1,a5
    b = sbrk(1);
    2408:	4505                	li	a0,1
    240a:	00003097          	auipc	ra,0x3
    240e:	042080e7          	jalr	66(ra) # 544c <sbrk>
    if(b != a){
    2412:	04951b63          	bne	a0,s1,2468 <sbrkbasic+0x124>
    *b = 1;
    2416:	01448023          	sb	s4,0(s1)
    a = b + 1;
    241a:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    241e:	2905                	addiw	s2,s2,1
    2420:	ff3913e3          	bne	s2,s3,2406 <sbrkbasic+0xc2>
  pid = fork();
    2424:	00003097          	auipc	ra,0x3
    2428:	f98080e7          	jalr	-104(ra) # 53bc <fork>
    242c:	892a                	mv	s2,a0
  if(pid < 0){
    242e:	04054d63          	bltz	a0,2488 <sbrkbasic+0x144>
  c = sbrk(1);
    2432:	4505                	li	a0,1
    2434:	00003097          	auipc	ra,0x3
    2438:	018080e7          	jalr	24(ra) # 544c <sbrk>
  c = sbrk(1);
    243c:	4505                	li	a0,1
    243e:	00003097          	auipc	ra,0x3
    2442:	00e080e7          	jalr	14(ra) # 544c <sbrk>
  if(c != a + 1){
    2446:	0489                	addi	s1,s1,2
    2448:	04a48e63          	beq	s1,a0,24a4 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    244c:	85d6                	mv	a1,s5
    244e:	00004517          	auipc	a0,0x4
    2452:	59a50513          	addi	a0,a0,1434 # 69e8 <malloc+0x11ec>
    2456:	00003097          	auipc	ra,0x3
    245a:	2e6080e7          	jalr	742(ra) # 573c <printf>
    exit(1);
    245e:	4505                	li	a0,1
    2460:	00003097          	auipc	ra,0x3
    2464:	f64080e7          	jalr	-156(ra) # 53c4 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    2468:	86aa                	mv	a3,a0
    246a:	8626                	mv	a2,s1
    246c:	85ca                	mv	a1,s2
    246e:	00004517          	auipc	a0,0x4
    2472:	53a50513          	addi	a0,a0,1338 # 69a8 <malloc+0x11ac>
    2476:	00003097          	auipc	ra,0x3
    247a:	2c6080e7          	jalr	710(ra) # 573c <printf>
      exit(1);
    247e:	4505                	li	a0,1
    2480:	00003097          	auipc	ra,0x3
    2484:	f44080e7          	jalr	-188(ra) # 53c4 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2488:	85d6                	mv	a1,s5
    248a:	00004517          	auipc	a0,0x4
    248e:	53e50513          	addi	a0,a0,1342 # 69c8 <malloc+0x11cc>
    2492:	00003097          	auipc	ra,0x3
    2496:	2aa080e7          	jalr	682(ra) # 573c <printf>
    exit(1);
    249a:	4505                	li	a0,1
    249c:	00003097          	auipc	ra,0x3
    24a0:	f28080e7          	jalr	-216(ra) # 53c4 <exit>
  if(pid == 0)
    24a4:	00091763          	bnez	s2,24b2 <sbrkbasic+0x16e>
    exit(0);
    24a8:	4501                	li	a0,0
    24aa:	00003097          	auipc	ra,0x3
    24ae:	f1a080e7          	jalr	-230(ra) # 53c4 <exit>
  wait(&xstatus);
    24b2:	fbc40513          	addi	a0,s0,-68
    24b6:	00003097          	auipc	ra,0x3
    24ba:	f16080e7          	jalr	-234(ra) # 53cc <wait>
  exit(xstatus);
    24be:	fbc42503          	lw	a0,-68(s0)
    24c2:	00003097          	auipc	ra,0x3
    24c6:	f02080e7          	jalr	-254(ra) # 53c4 <exit>

00000000000024ca <sbrkmuch>:
{
    24ca:	7179                	addi	sp,sp,-48
    24cc:	f406                	sd	ra,40(sp)
    24ce:	f022                	sd	s0,32(sp)
    24d0:	ec26                	sd	s1,24(sp)
    24d2:	e84a                	sd	s2,16(sp)
    24d4:	e44e                	sd	s3,8(sp)
    24d6:	e052                	sd	s4,0(sp)
    24d8:	1800                	addi	s0,sp,48
    24da:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    24dc:	4501                	li	a0,0
    24de:	00003097          	auipc	ra,0x3
    24e2:	f6e080e7          	jalr	-146(ra) # 544c <sbrk>
    24e6:	892a                	mv	s2,a0
  a = sbrk(0);
    24e8:	4501                	li	a0,0
    24ea:	00003097          	auipc	ra,0x3
    24ee:	f62080e7          	jalr	-158(ra) # 544c <sbrk>
    24f2:	84aa                	mv	s1,a0
  p = sbrk(amt);
    24f4:	06400537          	lui	a0,0x6400
    24f8:	9d05                	subw	a0,a0,s1
    24fa:	00003097          	auipc	ra,0x3
    24fe:	f52080e7          	jalr	-174(ra) # 544c <sbrk>
  if (p != a) {
    2502:	0ca49763          	bne	s1,a0,25d0 <sbrkmuch+0x106>
  char *eee = sbrk(0);
    2506:	4501                	li	a0,0
    2508:	00003097          	auipc	ra,0x3
    250c:	f44080e7          	jalr	-188(ra) # 544c <sbrk>
  for(char *pp = a; pp < eee; pp += 4096)
    2510:	00a4f963          	bleu	a0,s1,2522 <sbrkmuch+0x58>
    *pp = 1;
    2514:	4705                	li	a4,1
  for(char *pp = a; pp < eee; pp += 4096)
    2516:	6785                	lui	a5,0x1
    *pp = 1;
    2518:	00e48023          	sb	a4,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    251c:	94be                	add	s1,s1,a5
    251e:	fea4ede3          	bltu	s1,a0,2518 <sbrkmuch+0x4e>
  *lastaddr = 99;
    2522:	064007b7          	lui	a5,0x6400
    2526:	06300713          	li	a4,99
    252a:	fee78fa3          	sb	a4,-1(a5) # 63fffff <_end+0x63f1867>
  a = sbrk(0);
    252e:	4501                	li	a0,0
    2530:	00003097          	auipc	ra,0x3
    2534:	f1c080e7          	jalr	-228(ra) # 544c <sbrk>
    2538:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    253a:	757d                	lui	a0,0xfffff
    253c:	00003097          	auipc	ra,0x3
    2540:	f10080e7          	jalr	-240(ra) # 544c <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2544:	57fd                	li	a5,-1
    2546:	0af50363          	beq	a0,a5,25ec <sbrkmuch+0x122>
  c = sbrk(0);
    254a:	4501                	li	a0,0
    254c:	00003097          	auipc	ra,0x3
    2550:	f00080e7          	jalr	-256(ra) # 544c <sbrk>
  if(c != a - PGSIZE){
    2554:	77fd                	lui	a5,0xfffff
    2556:	97a6                	add	a5,a5,s1
    2558:	0af51863          	bne	a0,a5,2608 <sbrkmuch+0x13e>
  a = sbrk(0);
    255c:	4501                	li	a0,0
    255e:	00003097          	auipc	ra,0x3
    2562:	eee080e7          	jalr	-274(ra) # 544c <sbrk>
    2566:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2568:	6505                	lui	a0,0x1
    256a:	00003097          	auipc	ra,0x3
    256e:	ee2080e7          	jalr	-286(ra) # 544c <sbrk>
    2572:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2574:	0aa49963          	bne	s1,a0,2626 <sbrkmuch+0x15c>
    2578:	4501                	li	a0,0
    257a:	00003097          	auipc	ra,0x3
    257e:	ed2080e7          	jalr	-302(ra) # 544c <sbrk>
    2582:	6785                	lui	a5,0x1
    2584:	97a6                	add	a5,a5,s1
    2586:	0af51063          	bne	a0,a5,2626 <sbrkmuch+0x15c>
  if(*lastaddr == 99){
    258a:	064007b7          	lui	a5,0x6400
    258e:	fff7c703          	lbu	a4,-1(a5) # 63fffff <_end+0x63f1867>
    2592:	06300793          	li	a5,99
    2596:	0af70763          	beq	a4,a5,2644 <sbrkmuch+0x17a>
  a = sbrk(0);
    259a:	4501                	li	a0,0
    259c:	00003097          	auipc	ra,0x3
    25a0:	eb0080e7          	jalr	-336(ra) # 544c <sbrk>
    25a4:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    25a6:	4501                	li	a0,0
    25a8:	00003097          	auipc	ra,0x3
    25ac:	ea4080e7          	jalr	-348(ra) # 544c <sbrk>
    25b0:	40a9053b          	subw	a0,s2,a0
    25b4:	00003097          	auipc	ra,0x3
    25b8:	e98080e7          	jalr	-360(ra) # 544c <sbrk>
  if(c != a){
    25bc:	0aa49263          	bne	s1,a0,2660 <sbrkmuch+0x196>
}
    25c0:	70a2                	ld	ra,40(sp)
    25c2:	7402                	ld	s0,32(sp)
    25c4:	64e2                	ld	s1,24(sp)
    25c6:	6942                	ld	s2,16(sp)
    25c8:	69a2                	ld	s3,8(sp)
    25ca:	6a02                	ld	s4,0(sp)
    25cc:	6145                	addi	sp,sp,48
    25ce:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    25d0:	85ce                	mv	a1,s3
    25d2:	00004517          	auipc	a0,0x4
    25d6:	43650513          	addi	a0,a0,1078 # 6a08 <malloc+0x120c>
    25da:	00003097          	auipc	ra,0x3
    25de:	162080e7          	jalr	354(ra) # 573c <printf>
    exit(1);
    25e2:	4505                	li	a0,1
    25e4:	00003097          	auipc	ra,0x3
    25e8:	de0080e7          	jalr	-544(ra) # 53c4 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    25ec:	85ce                	mv	a1,s3
    25ee:	00004517          	auipc	a0,0x4
    25f2:	46250513          	addi	a0,a0,1122 # 6a50 <malloc+0x1254>
    25f6:	00003097          	auipc	ra,0x3
    25fa:	146080e7          	jalr	326(ra) # 573c <printf>
    exit(1);
    25fe:	4505                	li	a0,1
    2600:	00003097          	auipc	ra,0x3
    2604:	dc4080e7          	jalr	-572(ra) # 53c4 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2608:	862a                	mv	a2,a0
    260a:	85a6                	mv	a1,s1
    260c:	00004517          	auipc	a0,0x4
    2610:	46450513          	addi	a0,a0,1124 # 6a70 <malloc+0x1274>
    2614:	00003097          	auipc	ra,0x3
    2618:	128080e7          	jalr	296(ra) # 573c <printf>
    exit(1);
    261c:	4505                	li	a0,1
    261e:	00003097          	auipc	ra,0x3
    2622:	da6080e7          	jalr	-602(ra) # 53c4 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    2626:	8652                	mv	a2,s4
    2628:	85a6                	mv	a1,s1
    262a:	00004517          	auipc	a0,0x4
    262e:	48650513          	addi	a0,a0,1158 # 6ab0 <malloc+0x12b4>
    2632:	00003097          	auipc	ra,0x3
    2636:	10a080e7          	jalr	266(ra) # 573c <printf>
    exit(1);
    263a:	4505                	li	a0,1
    263c:	00003097          	auipc	ra,0x3
    2640:	d88080e7          	jalr	-632(ra) # 53c4 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2644:	85ce                	mv	a1,s3
    2646:	00004517          	auipc	a0,0x4
    264a:	49a50513          	addi	a0,a0,1178 # 6ae0 <malloc+0x12e4>
    264e:	00003097          	auipc	ra,0x3
    2652:	0ee080e7          	jalr	238(ra) # 573c <printf>
    exit(1);
    2656:	4505                	li	a0,1
    2658:	00003097          	auipc	ra,0x3
    265c:	d6c080e7          	jalr	-660(ra) # 53c4 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    2660:	862a                	mv	a2,a0
    2662:	85a6                	mv	a1,s1
    2664:	00004517          	auipc	a0,0x4
    2668:	4b450513          	addi	a0,a0,1204 # 6b18 <malloc+0x131c>
    266c:	00003097          	auipc	ra,0x3
    2670:	0d0080e7          	jalr	208(ra) # 573c <printf>
    exit(1);
    2674:	4505                	li	a0,1
    2676:	00003097          	auipc	ra,0x3
    267a:	d4e080e7          	jalr	-690(ra) # 53c4 <exit>

000000000000267e <sbrkarg>:
{
    267e:	7179                	addi	sp,sp,-48
    2680:	f406                	sd	ra,40(sp)
    2682:	f022                	sd	s0,32(sp)
    2684:	ec26                	sd	s1,24(sp)
    2686:	e84a                	sd	s2,16(sp)
    2688:	e44e                	sd	s3,8(sp)
    268a:	1800                	addi	s0,sp,48
    268c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    268e:	6505                	lui	a0,0x1
    2690:	00003097          	auipc	ra,0x3
    2694:	dbc080e7          	jalr	-580(ra) # 544c <sbrk>
    2698:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    269a:	20100593          	li	a1,513
    269e:	00004517          	auipc	a0,0x4
    26a2:	4a250513          	addi	a0,a0,1186 # 6b40 <malloc+0x1344>
    26a6:	00003097          	auipc	ra,0x3
    26aa:	d5e080e7          	jalr	-674(ra) # 5404 <open>
    26ae:	84aa                	mv	s1,a0
  unlink("sbrk");
    26b0:	00004517          	auipc	a0,0x4
    26b4:	49050513          	addi	a0,a0,1168 # 6b40 <malloc+0x1344>
    26b8:	00003097          	auipc	ra,0x3
    26bc:	d5c080e7          	jalr	-676(ra) # 5414 <unlink>
  if(fd < 0)  {
    26c0:	0404c163          	bltz	s1,2702 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    26c4:	6605                	lui	a2,0x1
    26c6:	85ca                	mv	a1,s2
    26c8:	8526                	mv	a0,s1
    26ca:	00003097          	auipc	ra,0x3
    26ce:	d1a080e7          	jalr	-742(ra) # 53e4 <write>
    26d2:	04054663          	bltz	a0,271e <sbrkarg+0xa0>
  close(fd);
    26d6:	8526                	mv	a0,s1
    26d8:	00003097          	auipc	ra,0x3
    26dc:	d14080e7          	jalr	-748(ra) # 53ec <close>
  a = sbrk(PGSIZE);
    26e0:	6505                	lui	a0,0x1
    26e2:	00003097          	auipc	ra,0x3
    26e6:	d6a080e7          	jalr	-662(ra) # 544c <sbrk>
  if(pipe((int *) a) != 0){
    26ea:	00003097          	auipc	ra,0x3
    26ee:	cea080e7          	jalr	-790(ra) # 53d4 <pipe>
    26f2:	e521                	bnez	a0,273a <sbrkarg+0xbc>
}
    26f4:	70a2                	ld	ra,40(sp)
    26f6:	7402                	ld	s0,32(sp)
    26f8:	64e2                	ld	s1,24(sp)
    26fa:	6942                	ld	s2,16(sp)
    26fc:	69a2                	ld	s3,8(sp)
    26fe:	6145                	addi	sp,sp,48
    2700:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2702:	85ce                	mv	a1,s3
    2704:	00004517          	auipc	a0,0x4
    2708:	44450513          	addi	a0,a0,1092 # 6b48 <malloc+0x134c>
    270c:	00003097          	auipc	ra,0x3
    2710:	030080e7          	jalr	48(ra) # 573c <printf>
    exit(1);
    2714:	4505                	li	a0,1
    2716:	00003097          	auipc	ra,0x3
    271a:	cae080e7          	jalr	-850(ra) # 53c4 <exit>
    printf("%s: write sbrk failed\n", s);
    271e:	85ce                	mv	a1,s3
    2720:	00004517          	auipc	a0,0x4
    2724:	44050513          	addi	a0,a0,1088 # 6b60 <malloc+0x1364>
    2728:	00003097          	auipc	ra,0x3
    272c:	014080e7          	jalr	20(ra) # 573c <printf>
    exit(1);
    2730:	4505                	li	a0,1
    2732:	00003097          	auipc	ra,0x3
    2736:	c92080e7          	jalr	-878(ra) # 53c4 <exit>
    printf("%s: pipe() failed\n", s);
    273a:	85ce                	mv	a1,s3
    273c:	00004517          	auipc	a0,0x4
    2740:	ee450513          	addi	a0,a0,-284 # 6620 <malloc+0xe24>
    2744:	00003097          	auipc	ra,0x3
    2748:	ff8080e7          	jalr	-8(ra) # 573c <printf>
    exit(1);
    274c:	4505                	li	a0,1
    274e:	00003097          	auipc	ra,0x3
    2752:	c76080e7          	jalr	-906(ra) # 53c4 <exit>

0000000000002756 <argptest>:
{
    2756:	1101                	addi	sp,sp,-32
    2758:	ec06                	sd	ra,24(sp)
    275a:	e822                	sd	s0,16(sp)
    275c:	e426                	sd	s1,8(sp)
    275e:	e04a                	sd	s2,0(sp)
    2760:	1000                	addi	s0,sp,32
    2762:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2764:	4581                	li	a1,0
    2766:	00004517          	auipc	a0,0x4
    276a:	41250513          	addi	a0,a0,1042 # 6b78 <malloc+0x137c>
    276e:	00003097          	auipc	ra,0x3
    2772:	c96080e7          	jalr	-874(ra) # 5404 <open>
  if (fd < 0) {
    2776:	02054b63          	bltz	a0,27ac <argptest+0x56>
    277a:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    277c:	4501                	li	a0,0
    277e:	00003097          	auipc	ra,0x3
    2782:	cce080e7          	jalr	-818(ra) # 544c <sbrk>
    2786:	567d                	li	a2,-1
    2788:	fff50593          	addi	a1,a0,-1
    278c:	8526                	mv	a0,s1
    278e:	00003097          	auipc	ra,0x3
    2792:	c4e080e7          	jalr	-946(ra) # 53dc <read>
  close(fd);
    2796:	8526                	mv	a0,s1
    2798:	00003097          	auipc	ra,0x3
    279c:	c54080e7          	jalr	-940(ra) # 53ec <close>
}
    27a0:	60e2                	ld	ra,24(sp)
    27a2:	6442                	ld	s0,16(sp)
    27a4:	64a2                	ld	s1,8(sp)
    27a6:	6902                	ld	s2,0(sp)
    27a8:	6105                	addi	sp,sp,32
    27aa:	8082                	ret
    printf("%s: open failed\n", s);
    27ac:	85ca                	mv	a1,s2
    27ae:	00004517          	auipc	a0,0x4
    27b2:	d8250513          	addi	a0,a0,-638 # 6530 <malloc+0xd34>
    27b6:	00003097          	auipc	ra,0x3
    27ba:	f86080e7          	jalr	-122(ra) # 573c <printf>
    exit(1);
    27be:	4505                	li	a0,1
    27c0:	00003097          	auipc	ra,0x3
    27c4:	c04080e7          	jalr	-1020(ra) # 53c4 <exit>

00000000000027c8 <sbrkbugs>:
{
    27c8:	1141                	addi	sp,sp,-16
    27ca:	e406                	sd	ra,8(sp)
    27cc:	e022                	sd	s0,0(sp)
    27ce:	0800                	addi	s0,sp,16
  int pid = fork();
    27d0:	00003097          	auipc	ra,0x3
    27d4:	bec080e7          	jalr	-1044(ra) # 53bc <fork>
  if(pid < 0){
    27d8:	02054363          	bltz	a0,27fe <sbrkbugs+0x36>
  if(pid == 0){
    27dc:	ed15                	bnez	a0,2818 <sbrkbugs+0x50>
    int sz = (uint64) sbrk(0);
    27de:	00003097          	auipc	ra,0x3
    27e2:	c6e080e7          	jalr	-914(ra) # 544c <sbrk>
    sbrk(-sz);
    27e6:	40a0053b          	negw	a0,a0
    27ea:	2501                	sext.w	a0,a0
    27ec:	00003097          	auipc	ra,0x3
    27f0:	c60080e7          	jalr	-928(ra) # 544c <sbrk>
    exit(0);
    27f4:	4501                	li	a0,0
    27f6:	00003097          	auipc	ra,0x3
    27fa:	bce080e7          	jalr	-1074(ra) # 53c4 <exit>
    printf("fork failed\n");
    27fe:	00004517          	auipc	a0,0x4
    2802:	10a50513          	addi	a0,a0,266 # 6908 <malloc+0x110c>
    2806:	00003097          	auipc	ra,0x3
    280a:	f36080e7          	jalr	-202(ra) # 573c <printf>
    exit(1);
    280e:	4505                	li	a0,1
    2810:	00003097          	auipc	ra,0x3
    2814:	bb4080e7          	jalr	-1100(ra) # 53c4 <exit>
  wait(0);
    2818:	4501                	li	a0,0
    281a:	00003097          	auipc	ra,0x3
    281e:	bb2080e7          	jalr	-1102(ra) # 53cc <wait>
  pid = fork();
    2822:	00003097          	auipc	ra,0x3
    2826:	b9a080e7          	jalr	-1126(ra) # 53bc <fork>
  if(pid < 0){
    282a:	02054563          	bltz	a0,2854 <sbrkbugs+0x8c>
  if(pid == 0){
    282e:	e121                	bnez	a0,286e <sbrkbugs+0xa6>
    int sz = (uint64) sbrk(0);
    2830:	00003097          	auipc	ra,0x3
    2834:	c1c080e7          	jalr	-996(ra) # 544c <sbrk>
    sbrk(-(sz - 3500));
    2838:	6785                	lui	a5,0x1
    283a:	dac7879b          	addiw	a5,a5,-596
    283e:	40a7853b          	subw	a0,a5,a0
    2842:	00003097          	auipc	ra,0x3
    2846:	c0a080e7          	jalr	-1014(ra) # 544c <sbrk>
    exit(0);
    284a:	4501                	li	a0,0
    284c:	00003097          	auipc	ra,0x3
    2850:	b78080e7          	jalr	-1160(ra) # 53c4 <exit>
    printf("fork failed\n");
    2854:	00004517          	auipc	a0,0x4
    2858:	0b450513          	addi	a0,a0,180 # 6908 <malloc+0x110c>
    285c:	00003097          	auipc	ra,0x3
    2860:	ee0080e7          	jalr	-288(ra) # 573c <printf>
    exit(1);
    2864:	4505                	li	a0,1
    2866:	00003097          	auipc	ra,0x3
    286a:	b5e080e7          	jalr	-1186(ra) # 53c4 <exit>
  wait(0);
    286e:	4501                	li	a0,0
    2870:	00003097          	auipc	ra,0x3
    2874:	b5c080e7          	jalr	-1188(ra) # 53cc <wait>
  pid = fork();
    2878:	00003097          	auipc	ra,0x3
    287c:	b44080e7          	jalr	-1212(ra) # 53bc <fork>
  if(pid < 0){
    2880:	02054a63          	bltz	a0,28b4 <sbrkbugs+0xec>
  if(pid == 0){
    2884:	e529                	bnez	a0,28ce <sbrkbugs+0x106>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2886:	00003097          	auipc	ra,0x3
    288a:	bc6080e7          	jalr	-1082(ra) # 544c <sbrk>
    288e:	67ad                	lui	a5,0xb
    2890:	8007879b          	addiw	a5,a5,-2048
    2894:	40a7853b          	subw	a0,a5,a0
    2898:	00003097          	auipc	ra,0x3
    289c:	bb4080e7          	jalr	-1100(ra) # 544c <sbrk>
    sbrk(-10);
    28a0:	5559                	li	a0,-10
    28a2:	00003097          	auipc	ra,0x3
    28a6:	baa080e7          	jalr	-1110(ra) # 544c <sbrk>
    exit(0);
    28aa:	4501                	li	a0,0
    28ac:	00003097          	auipc	ra,0x3
    28b0:	b18080e7          	jalr	-1256(ra) # 53c4 <exit>
    printf("fork failed\n");
    28b4:	00004517          	auipc	a0,0x4
    28b8:	05450513          	addi	a0,a0,84 # 6908 <malloc+0x110c>
    28bc:	00003097          	auipc	ra,0x3
    28c0:	e80080e7          	jalr	-384(ra) # 573c <printf>
    exit(1);
    28c4:	4505                	li	a0,1
    28c6:	00003097          	auipc	ra,0x3
    28ca:	afe080e7          	jalr	-1282(ra) # 53c4 <exit>
  wait(0);
    28ce:	4501                	li	a0,0
    28d0:	00003097          	auipc	ra,0x3
    28d4:	afc080e7          	jalr	-1284(ra) # 53cc <wait>
  exit(0);
    28d8:	4501                	li	a0,0
    28da:	00003097          	auipc	ra,0x3
    28de:	aea080e7          	jalr	-1302(ra) # 53c4 <exit>

00000000000028e2 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    28e2:	715d                	addi	sp,sp,-80
    28e4:	e486                	sd	ra,72(sp)
    28e6:	e0a2                	sd	s0,64(sp)
    28e8:	fc26                	sd	s1,56(sp)
    28ea:	f84a                	sd	s2,48(sp)
    28ec:	f44e                	sd	s3,40(sp)
    28ee:	f052                	sd	s4,32(sp)
    28f0:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    28f2:	4901                	li	s2,0
    28f4:	49bd                	li	s3,15
    int pid = fork();
    28f6:	00003097          	auipc	ra,0x3
    28fa:	ac6080e7          	jalr	-1338(ra) # 53bc <fork>
    28fe:	84aa                	mv	s1,a0
    if(pid < 0){
    2900:	02054063          	bltz	a0,2920 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2904:	c91d                	beqz	a0,293a <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2906:	4501                	li	a0,0
    2908:	00003097          	auipc	ra,0x3
    290c:	ac4080e7          	jalr	-1340(ra) # 53cc <wait>
  for(int avail = 0; avail < 15; avail++){
    2910:	2905                	addiw	s2,s2,1
    2912:	ff3912e3          	bne	s2,s3,28f6 <execout+0x14>
    }
  }

  exit(0);
    2916:	4501                	li	a0,0
    2918:	00003097          	auipc	ra,0x3
    291c:	aac080e7          	jalr	-1364(ra) # 53c4 <exit>
      printf("fork failed\n");
    2920:	00004517          	auipc	a0,0x4
    2924:	fe850513          	addi	a0,a0,-24 # 6908 <malloc+0x110c>
    2928:	00003097          	auipc	ra,0x3
    292c:	e14080e7          	jalr	-492(ra) # 573c <printf>
      exit(1);
    2930:	4505                	li	a0,1
    2932:	00003097          	auipc	ra,0x3
    2936:	a92080e7          	jalr	-1390(ra) # 53c4 <exit>
        if(a == 0xffffffffffffffffLL)
    293a:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    293c:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    293e:	6505                	lui	a0,0x1
    2940:	00003097          	auipc	ra,0x3
    2944:	b0c080e7          	jalr	-1268(ra) # 544c <sbrk>
        if(a == 0xffffffffffffffffLL)
    2948:	01350763          	beq	a0,s3,2956 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    294c:	6785                	lui	a5,0x1
    294e:	97aa                	add	a5,a5,a0
    2950:	ff478fa3          	sb	s4,-1(a5) # fff <bigdir+0x83>
      while(1){
    2954:	b7ed                	j	293e <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2956:	01205a63          	blez	s2,296a <execout+0x88>
        sbrk(-4096);
    295a:	757d                	lui	a0,0xfffff
    295c:	00003097          	auipc	ra,0x3
    2960:	af0080e7          	jalr	-1296(ra) # 544c <sbrk>
      for(int i = 0; i < avail; i++)
    2964:	2485                	addiw	s1,s1,1
    2966:	ff249ae3          	bne	s1,s2,295a <execout+0x78>
      close(1);
    296a:	4505                	li	a0,1
    296c:	00003097          	auipc	ra,0x3
    2970:	a80080e7          	jalr	-1408(ra) # 53ec <close>
      char *args[] = { "echo", "x", 0 };
    2974:	00003517          	auipc	a0,0x3
    2978:	34c50513          	addi	a0,a0,844 # 5cc0 <malloc+0x4c4>
    297c:	faa43c23          	sd	a0,-72(s0)
    2980:	00003797          	auipc	a5,0x3
    2984:	3b078793          	addi	a5,a5,944 # 5d30 <malloc+0x534>
    2988:	fcf43023          	sd	a5,-64(s0)
    298c:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2990:	fb840593          	addi	a1,s0,-72
    2994:	00003097          	auipc	ra,0x3
    2998:	a68080e7          	jalr	-1432(ra) # 53fc <exec>
      exit(0);
    299c:	4501                	li	a0,0
    299e:	00003097          	auipc	ra,0x3
    29a2:	a26080e7          	jalr	-1498(ra) # 53c4 <exit>

00000000000029a6 <fourteen>:
{
    29a6:	1101                	addi	sp,sp,-32
    29a8:	ec06                	sd	ra,24(sp)
    29aa:	e822                	sd	s0,16(sp)
    29ac:	e426                	sd	s1,8(sp)
    29ae:	1000                	addi	s0,sp,32
    29b0:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    29b2:	00004517          	auipc	a0,0x4
    29b6:	39e50513          	addi	a0,a0,926 # 6d50 <malloc+0x1554>
    29ba:	00003097          	auipc	ra,0x3
    29be:	a72080e7          	jalr	-1422(ra) # 542c <mkdir>
    29c2:	e165                	bnez	a0,2aa2 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    29c4:	00004517          	auipc	a0,0x4
    29c8:	1e450513          	addi	a0,a0,484 # 6ba8 <malloc+0x13ac>
    29cc:	00003097          	auipc	ra,0x3
    29d0:	a60080e7          	jalr	-1440(ra) # 542c <mkdir>
    29d4:	e56d                	bnez	a0,2abe <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    29d6:	20000593          	li	a1,512
    29da:	00004517          	auipc	a0,0x4
    29de:	22650513          	addi	a0,a0,550 # 6c00 <malloc+0x1404>
    29e2:	00003097          	auipc	ra,0x3
    29e6:	a22080e7          	jalr	-1502(ra) # 5404 <open>
  if(fd < 0){
    29ea:	0e054863          	bltz	a0,2ada <fourteen+0x134>
  close(fd);
    29ee:	00003097          	auipc	ra,0x3
    29f2:	9fe080e7          	jalr	-1538(ra) # 53ec <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    29f6:	4581                	li	a1,0
    29f8:	00004517          	auipc	a0,0x4
    29fc:	28050513          	addi	a0,a0,640 # 6c78 <malloc+0x147c>
    2a00:	00003097          	auipc	ra,0x3
    2a04:	a04080e7          	jalr	-1532(ra) # 5404 <open>
  if(fd < 0){
    2a08:	0e054763          	bltz	a0,2af6 <fourteen+0x150>
  close(fd);
    2a0c:	00003097          	auipc	ra,0x3
    2a10:	9e0080e7          	jalr	-1568(ra) # 53ec <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2a14:	00004517          	auipc	a0,0x4
    2a18:	2d450513          	addi	a0,a0,724 # 6ce8 <malloc+0x14ec>
    2a1c:	00003097          	auipc	ra,0x3
    2a20:	a10080e7          	jalr	-1520(ra) # 542c <mkdir>
    2a24:	c57d                	beqz	a0,2b12 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2a26:	00004517          	auipc	a0,0x4
    2a2a:	31a50513          	addi	a0,a0,794 # 6d40 <malloc+0x1544>
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	9fe080e7          	jalr	-1538(ra) # 542c <mkdir>
    2a36:	cd65                	beqz	a0,2b2e <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2a38:	00004517          	auipc	a0,0x4
    2a3c:	30850513          	addi	a0,a0,776 # 6d40 <malloc+0x1544>
    2a40:	00003097          	auipc	ra,0x3
    2a44:	9d4080e7          	jalr	-1580(ra) # 5414 <unlink>
  unlink("12345678901234/12345678901234");
    2a48:	00004517          	auipc	a0,0x4
    2a4c:	2a050513          	addi	a0,a0,672 # 6ce8 <malloc+0x14ec>
    2a50:	00003097          	auipc	ra,0x3
    2a54:	9c4080e7          	jalr	-1596(ra) # 5414 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2a58:	00004517          	auipc	a0,0x4
    2a5c:	22050513          	addi	a0,a0,544 # 6c78 <malloc+0x147c>
    2a60:	00003097          	auipc	ra,0x3
    2a64:	9b4080e7          	jalr	-1612(ra) # 5414 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2a68:	00004517          	auipc	a0,0x4
    2a6c:	19850513          	addi	a0,a0,408 # 6c00 <malloc+0x1404>
    2a70:	00003097          	auipc	ra,0x3
    2a74:	9a4080e7          	jalr	-1628(ra) # 5414 <unlink>
  unlink("12345678901234/123456789012345");
    2a78:	00004517          	auipc	a0,0x4
    2a7c:	13050513          	addi	a0,a0,304 # 6ba8 <malloc+0x13ac>
    2a80:	00003097          	auipc	ra,0x3
    2a84:	994080e7          	jalr	-1644(ra) # 5414 <unlink>
  unlink("12345678901234");
    2a88:	00004517          	auipc	a0,0x4
    2a8c:	2c850513          	addi	a0,a0,712 # 6d50 <malloc+0x1554>
    2a90:	00003097          	auipc	ra,0x3
    2a94:	984080e7          	jalr	-1660(ra) # 5414 <unlink>
}
    2a98:	60e2                	ld	ra,24(sp)
    2a9a:	6442                	ld	s0,16(sp)
    2a9c:	64a2                	ld	s1,8(sp)
    2a9e:	6105                	addi	sp,sp,32
    2aa0:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2aa2:	85a6                	mv	a1,s1
    2aa4:	00004517          	auipc	a0,0x4
    2aa8:	0dc50513          	addi	a0,a0,220 # 6b80 <malloc+0x1384>
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	c90080e7          	jalr	-880(ra) # 573c <printf>
    exit(1);
    2ab4:	4505                	li	a0,1
    2ab6:	00003097          	auipc	ra,0x3
    2aba:	90e080e7          	jalr	-1778(ra) # 53c4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2abe:	85a6                	mv	a1,s1
    2ac0:	00004517          	auipc	a0,0x4
    2ac4:	10850513          	addi	a0,a0,264 # 6bc8 <malloc+0x13cc>
    2ac8:	00003097          	auipc	ra,0x3
    2acc:	c74080e7          	jalr	-908(ra) # 573c <printf>
    exit(1);
    2ad0:	4505                	li	a0,1
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	8f2080e7          	jalr	-1806(ra) # 53c4 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2ada:	85a6                	mv	a1,s1
    2adc:	00004517          	auipc	a0,0x4
    2ae0:	15450513          	addi	a0,a0,340 # 6c30 <malloc+0x1434>
    2ae4:	00003097          	auipc	ra,0x3
    2ae8:	c58080e7          	jalr	-936(ra) # 573c <printf>
    exit(1);
    2aec:	4505                	li	a0,1
    2aee:	00003097          	auipc	ra,0x3
    2af2:	8d6080e7          	jalr	-1834(ra) # 53c4 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2af6:	85a6                	mv	a1,s1
    2af8:	00004517          	auipc	a0,0x4
    2afc:	1b050513          	addi	a0,a0,432 # 6ca8 <malloc+0x14ac>
    2b00:	00003097          	auipc	ra,0x3
    2b04:	c3c080e7          	jalr	-964(ra) # 573c <printf>
    exit(1);
    2b08:	4505                	li	a0,1
    2b0a:	00003097          	auipc	ra,0x3
    2b0e:	8ba080e7          	jalr	-1862(ra) # 53c4 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2b12:	85a6                	mv	a1,s1
    2b14:	00004517          	auipc	a0,0x4
    2b18:	1f450513          	addi	a0,a0,500 # 6d08 <malloc+0x150c>
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	c20080e7          	jalr	-992(ra) # 573c <printf>
    exit(1);
    2b24:	4505                	li	a0,1
    2b26:	00003097          	auipc	ra,0x3
    2b2a:	89e080e7          	jalr	-1890(ra) # 53c4 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2b2e:	85a6                	mv	a1,s1
    2b30:	00004517          	auipc	a0,0x4
    2b34:	23050513          	addi	a0,a0,560 # 6d60 <malloc+0x1564>
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	c04080e7          	jalr	-1020(ra) # 573c <printf>
    exit(1);
    2b40:	4505                	li	a0,1
    2b42:	00003097          	auipc	ra,0x3
    2b46:	882080e7          	jalr	-1918(ra) # 53c4 <exit>

0000000000002b4a <iputtest>:
{
    2b4a:	1101                	addi	sp,sp,-32
    2b4c:	ec06                	sd	ra,24(sp)
    2b4e:	e822                	sd	s0,16(sp)
    2b50:	e426                	sd	s1,8(sp)
    2b52:	1000                	addi	s0,sp,32
    2b54:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b56:	00004517          	auipc	a0,0x4
    2b5a:	24250513          	addi	a0,a0,578 # 6d98 <malloc+0x159c>
    2b5e:	00003097          	auipc	ra,0x3
    2b62:	8ce080e7          	jalr	-1842(ra) # 542c <mkdir>
    2b66:	04054563          	bltz	a0,2bb0 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2b6a:	00004517          	auipc	a0,0x4
    2b6e:	22e50513          	addi	a0,a0,558 # 6d98 <malloc+0x159c>
    2b72:	00003097          	auipc	ra,0x3
    2b76:	8c2080e7          	jalr	-1854(ra) # 5434 <chdir>
    2b7a:	04054963          	bltz	a0,2bcc <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2b7e:	00004517          	auipc	a0,0x4
    2b82:	25a50513          	addi	a0,a0,602 # 6dd8 <malloc+0x15dc>
    2b86:	00003097          	auipc	ra,0x3
    2b8a:	88e080e7          	jalr	-1906(ra) # 5414 <unlink>
    2b8e:	04054d63          	bltz	a0,2be8 <iputtest+0x9e>
  if(chdir("/") < 0){
    2b92:	00004517          	auipc	a0,0x4
    2b96:	27650513          	addi	a0,a0,630 # 6e08 <malloc+0x160c>
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	89a080e7          	jalr	-1894(ra) # 5434 <chdir>
    2ba2:	06054163          	bltz	a0,2c04 <iputtest+0xba>
}
    2ba6:	60e2                	ld	ra,24(sp)
    2ba8:	6442                	ld	s0,16(sp)
    2baa:	64a2                	ld	s1,8(sp)
    2bac:	6105                	addi	sp,sp,32
    2bae:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2bb0:	85a6                	mv	a1,s1
    2bb2:	00004517          	auipc	a0,0x4
    2bb6:	1ee50513          	addi	a0,a0,494 # 6da0 <malloc+0x15a4>
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	b82080e7          	jalr	-1150(ra) # 573c <printf>
    exit(1);
    2bc2:	4505                	li	a0,1
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	800080e7          	jalr	-2048(ra) # 53c4 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2bcc:	85a6                	mv	a1,s1
    2bce:	00004517          	auipc	a0,0x4
    2bd2:	1ea50513          	addi	a0,a0,490 # 6db8 <malloc+0x15bc>
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	b66080e7          	jalr	-1178(ra) # 573c <printf>
    exit(1);
    2bde:	4505                	li	a0,1
    2be0:	00002097          	auipc	ra,0x2
    2be4:	7e4080e7          	jalr	2020(ra) # 53c4 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2be8:	85a6                	mv	a1,s1
    2bea:	00004517          	auipc	a0,0x4
    2bee:	1fe50513          	addi	a0,a0,510 # 6de8 <malloc+0x15ec>
    2bf2:	00003097          	auipc	ra,0x3
    2bf6:	b4a080e7          	jalr	-1206(ra) # 573c <printf>
    exit(1);
    2bfa:	4505                	li	a0,1
    2bfc:	00002097          	auipc	ra,0x2
    2c00:	7c8080e7          	jalr	1992(ra) # 53c4 <exit>
    printf("%s: chdir / failed\n", s);
    2c04:	85a6                	mv	a1,s1
    2c06:	00004517          	auipc	a0,0x4
    2c0a:	20a50513          	addi	a0,a0,522 # 6e10 <malloc+0x1614>
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	b2e080e7          	jalr	-1234(ra) # 573c <printf>
    exit(1);
    2c16:	4505                	li	a0,1
    2c18:	00002097          	auipc	ra,0x2
    2c1c:	7ac080e7          	jalr	1964(ra) # 53c4 <exit>

0000000000002c20 <exitiputtest>:
{
    2c20:	7179                	addi	sp,sp,-48
    2c22:	f406                	sd	ra,40(sp)
    2c24:	f022                	sd	s0,32(sp)
    2c26:	ec26                	sd	s1,24(sp)
    2c28:	1800                	addi	s0,sp,48
    2c2a:	84aa                	mv	s1,a0
  pid = fork();
    2c2c:	00002097          	auipc	ra,0x2
    2c30:	790080e7          	jalr	1936(ra) # 53bc <fork>
  if(pid < 0){
    2c34:	04054663          	bltz	a0,2c80 <exitiputtest+0x60>
  if(pid == 0){
    2c38:	ed45                	bnez	a0,2cf0 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2c3a:	00004517          	auipc	a0,0x4
    2c3e:	15e50513          	addi	a0,a0,350 # 6d98 <malloc+0x159c>
    2c42:	00002097          	auipc	ra,0x2
    2c46:	7ea080e7          	jalr	2026(ra) # 542c <mkdir>
    2c4a:	04054963          	bltz	a0,2c9c <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2c4e:	00004517          	auipc	a0,0x4
    2c52:	14a50513          	addi	a0,a0,330 # 6d98 <malloc+0x159c>
    2c56:	00002097          	auipc	ra,0x2
    2c5a:	7de080e7          	jalr	2014(ra) # 5434 <chdir>
    2c5e:	04054d63          	bltz	a0,2cb8 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2c62:	00004517          	auipc	a0,0x4
    2c66:	17650513          	addi	a0,a0,374 # 6dd8 <malloc+0x15dc>
    2c6a:	00002097          	auipc	ra,0x2
    2c6e:	7aa080e7          	jalr	1962(ra) # 5414 <unlink>
    2c72:	06054163          	bltz	a0,2cd4 <exitiputtest+0xb4>
    exit(0);
    2c76:	4501                	li	a0,0
    2c78:	00002097          	auipc	ra,0x2
    2c7c:	74c080e7          	jalr	1868(ra) # 53c4 <exit>
    printf("%s: fork failed\n", s);
    2c80:	85a6                	mv	a1,s1
    2c82:	00004517          	auipc	a0,0x4
    2c86:	89650513          	addi	a0,a0,-1898 # 6518 <malloc+0xd1c>
    2c8a:	00003097          	auipc	ra,0x3
    2c8e:	ab2080e7          	jalr	-1358(ra) # 573c <printf>
    exit(1);
    2c92:	4505                	li	a0,1
    2c94:	00002097          	auipc	ra,0x2
    2c98:	730080e7          	jalr	1840(ra) # 53c4 <exit>
      printf("%s: mkdir failed\n", s);
    2c9c:	85a6                	mv	a1,s1
    2c9e:	00004517          	auipc	a0,0x4
    2ca2:	10250513          	addi	a0,a0,258 # 6da0 <malloc+0x15a4>
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	a96080e7          	jalr	-1386(ra) # 573c <printf>
      exit(1);
    2cae:	4505                	li	a0,1
    2cb0:	00002097          	auipc	ra,0x2
    2cb4:	714080e7          	jalr	1812(ra) # 53c4 <exit>
      printf("%s: child chdir failed\n", s);
    2cb8:	85a6                	mv	a1,s1
    2cba:	00004517          	auipc	a0,0x4
    2cbe:	16e50513          	addi	a0,a0,366 # 6e28 <malloc+0x162c>
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	a7a080e7          	jalr	-1414(ra) # 573c <printf>
      exit(1);
    2cca:	4505                	li	a0,1
    2ccc:	00002097          	auipc	ra,0x2
    2cd0:	6f8080e7          	jalr	1784(ra) # 53c4 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2cd4:	85a6                	mv	a1,s1
    2cd6:	00004517          	auipc	a0,0x4
    2cda:	11250513          	addi	a0,a0,274 # 6de8 <malloc+0x15ec>
    2cde:	00003097          	auipc	ra,0x3
    2ce2:	a5e080e7          	jalr	-1442(ra) # 573c <printf>
      exit(1);
    2ce6:	4505                	li	a0,1
    2ce8:	00002097          	auipc	ra,0x2
    2cec:	6dc080e7          	jalr	1756(ra) # 53c4 <exit>
  wait(&xstatus);
    2cf0:	fdc40513          	addi	a0,s0,-36
    2cf4:	00002097          	auipc	ra,0x2
    2cf8:	6d8080e7          	jalr	1752(ra) # 53cc <wait>
  exit(xstatus);
    2cfc:	fdc42503          	lw	a0,-36(s0)
    2d00:	00002097          	auipc	ra,0x2
    2d04:	6c4080e7          	jalr	1732(ra) # 53c4 <exit>

0000000000002d08 <subdir>:
{
    2d08:	1101                	addi	sp,sp,-32
    2d0a:	ec06                	sd	ra,24(sp)
    2d0c:	e822                	sd	s0,16(sp)
    2d0e:	e426                	sd	s1,8(sp)
    2d10:	e04a                	sd	s2,0(sp)
    2d12:	1000                	addi	s0,sp,32
    2d14:	892a                	mv	s2,a0
  unlink("ff");
    2d16:	00004517          	auipc	a0,0x4
    2d1a:	25a50513          	addi	a0,a0,602 # 6f70 <malloc+0x1774>
    2d1e:	00002097          	auipc	ra,0x2
    2d22:	6f6080e7          	jalr	1782(ra) # 5414 <unlink>
  if(mkdir("dd") != 0){
    2d26:	00004517          	auipc	a0,0x4
    2d2a:	11a50513          	addi	a0,a0,282 # 6e40 <malloc+0x1644>
    2d2e:	00002097          	auipc	ra,0x2
    2d32:	6fe080e7          	jalr	1790(ra) # 542c <mkdir>
    2d36:	38051663          	bnez	a0,30c2 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d3a:	20200593          	li	a1,514
    2d3e:	00004517          	auipc	a0,0x4
    2d42:	12250513          	addi	a0,a0,290 # 6e60 <malloc+0x1664>
    2d46:	00002097          	auipc	ra,0x2
    2d4a:	6be080e7          	jalr	1726(ra) # 5404 <open>
    2d4e:	84aa                	mv	s1,a0
  if(fd < 0){
    2d50:	38054763          	bltz	a0,30de <subdir+0x3d6>
  write(fd, "ff", 2);
    2d54:	4609                	li	a2,2
    2d56:	00004597          	auipc	a1,0x4
    2d5a:	21a58593          	addi	a1,a1,538 # 6f70 <malloc+0x1774>
    2d5e:	00002097          	auipc	ra,0x2
    2d62:	686080e7          	jalr	1670(ra) # 53e4 <write>
  close(fd);
    2d66:	8526                	mv	a0,s1
    2d68:	00002097          	auipc	ra,0x2
    2d6c:	684080e7          	jalr	1668(ra) # 53ec <close>
  if(unlink("dd") >= 0){
    2d70:	00004517          	auipc	a0,0x4
    2d74:	0d050513          	addi	a0,a0,208 # 6e40 <malloc+0x1644>
    2d78:	00002097          	auipc	ra,0x2
    2d7c:	69c080e7          	jalr	1692(ra) # 5414 <unlink>
    2d80:	36055d63          	bgez	a0,30fa <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2d84:	00004517          	auipc	a0,0x4
    2d88:	13450513          	addi	a0,a0,308 # 6eb8 <malloc+0x16bc>
    2d8c:	00002097          	auipc	ra,0x2
    2d90:	6a0080e7          	jalr	1696(ra) # 542c <mkdir>
    2d94:	38051163          	bnez	a0,3116 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d98:	20200593          	li	a1,514
    2d9c:	00004517          	auipc	a0,0x4
    2da0:	14450513          	addi	a0,a0,324 # 6ee0 <malloc+0x16e4>
    2da4:	00002097          	auipc	ra,0x2
    2da8:	660080e7          	jalr	1632(ra) # 5404 <open>
    2dac:	84aa                	mv	s1,a0
  if(fd < 0){
    2dae:	38054263          	bltz	a0,3132 <subdir+0x42a>
  write(fd, "FF", 2);
    2db2:	4609                	li	a2,2
    2db4:	00004597          	auipc	a1,0x4
    2db8:	15c58593          	addi	a1,a1,348 # 6f10 <malloc+0x1714>
    2dbc:	00002097          	auipc	ra,0x2
    2dc0:	628080e7          	jalr	1576(ra) # 53e4 <write>
  close(fd);
    2dc4:	8526                	mv	a0,s1
    2dc6:	00002097          	auipc	ra,0x2
    2dca:	626080e7          	jalr	1574(ra) # 53ec <close>
  fd = open("dd/dd/../ff", 0);
    2dce:	4581                	li	a1,0
    2dd0:	00004517          	auipc	a0,0x4
    2dd4:	14850513          	addi	a0,a0,328 # 6f18 <malloc+0x171c>
    2dd8:	00002097          	auipc	ra,0x2
    2ddc:	62c080e7          	jalr	1580(ra) # 5404 <open>
    2de0:	84aa                	mv	s1,a0
  if(fd < 0){
    2de2:	36054663          	bltz	a0,314e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2de6:	660d                	lui	a2,0x3
    2de8:	00009597          	auipc	a1,0x9
    2dec:	9a058593          	addi	a1,a1,-1632 # b788 <buf>
    2df0:	00002097          	auipc	ra,0x2
    2df4:	5ec080e7          	jalr	1516(ra) # 53dc <read>
  if(cc != 2 || buf[0] != 'f'){
    2df8:	4789                	li	a5,2
    2dfa:	36f51863          	bne	a0,a5,316a <subdir+0x462>
    2dfe:	00009717          	auipc	a4,0x9
    2e02:	98a74703          	lbu	a4,-1654(a4) # b788 <buf>
    2e06:	06600793          	li	a5,102
    2e0a:	36f71063          	bne	a4,a5,316a <subdir+0x462>
  close(fd);
    2e0e:	8526                	mv	a0,s1
    2e10:	00002097          	auipc	ra,0x2
    2e14:	5dc080e7          	jalr	1500(ra) # 53ec <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2e18:	00004597          	auipc	a1,0x4
    2e1c:	15058593          	addi	a1,a1,336 # 6f68 <malloc+0x176c>
    2e20:	00004517          	auipc	a0,0x4
    2e24:	0c050513          	addi	a0,a0,192 # 6ee0 <malloc+0x16e4>
    2e28:	00002097          	auipc	ra,0x2
    2e2c:	5fc080e7          	jalr	1532(ra) # 5424 <link>
    2e30:	34051b63          	bnez	a0,3186 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2e34:	00004517          	auipc	a0,0x4
    2e38:	0ac50513          	addi	a0,a0,172 # 6ee0 <malloc+0x16e4>
    2e3c:	00002097          	auipc	ra,0x2
    2e40:	5d8080e7          	jalr	1496(ra) # 5414 <unlink>
    2e44:	34051f63          	bnez	a0,31a2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e48:	4581                	li	a1,0
    2e4a:	00004517          	auipc	a0,0x4
    2e4e:	09650513          	addi	a0,a0,150 # 6ee0 <malloc+0x16e4>
    2e52:	00002097          	auipc	ra,0x2
    2e56:	5b2080e7          	jalr	1458(ra) # 5404 <open>
    2e5a:	36055263          	bgez	a0,31be <subdir+0x4b6>
  if(chdir("dd") != 0){
    2e5e:	00004517          	auipc	a0,0x4
    2e62:	fe250513          	addi	a0,a0,-30 # 6e40 <malloc+0x1644>
    2e66:	00002097          	auipc	ra,0x2
    2e6a:	5ce080e7          	jalr	1486(ra) # 5434 <chdir>
    2e6e:	36051663          	bnez	a0,31da <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2e72:	00004517          	auipc	a0,0x4
    2e76:	18e50513          	addi	a0,a0,398 # 7000 <malloc+0x1804>
    2e7a:	00002097          	auipc	ra,0x2
    2e7e:	5ba080e7          	jalr	1466(ra) # 5434 <chdir>
    2e82:	36051a63          	bnez	a0,31f6 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2e86:	00004517          	auipc	a0,0x4
    2e8a:	1aa50513          	addi	a0,a0,426 # 7030 <malloc+0x1834>
    2e8e:	00002097          	auipc	ra,0x2
    2e92:	5a6080e7          	jalr	1446(ra) # 5434 <chdir>
    2e96:	36051e63          	bnez	a0,3212 <subdir+0x50a>
  if(chdir("./..") != 0){
    2e9a:	00004517          	auipc	a0,0x4
    2e9e:	1c650513          	addi	a0,a0,454 # 7060 <malloc+0x1864>
    2ea2:	00002097          	auipc	ra,0x2
    2ea6:	592080e7          	jalr	1426(ra) # 5434 <chdir>
    2eaa:	38051263          	bnez	a0,322e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2eae:	4581                	li	a1,0
    2eb0:	00004517          	auipc	a0,0x4
    2eb4:	0b850513          	addi	a0,a0,184 # 6f68 <malloc+0x176c>
    2eb8:	00002097          	auipc	ra,0x2
    2ebc:	54c080e7          	jalr	1356(ra) # 5404 <open>
    2ec0:	84aa                	mv	s1,a0
  if(fd < 0){
    2ec2:	38054463          	bltz	a0,324a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2ec6:	660d                	lui	a2,0x3
    2ec8:	00009597          	auipc	a1,0x9
    2ecc:	8c058593          	addi	a1,a1,-1856 # b788 <buf>
    2ed0:	00002097          	auipc	ra,0x2
    2ed4:	50c080e7          	jalr	1292(ra) # 53dc <read>
    2ed8:	4789                	li	a5,2
    2eda:	38f51663          	bne	a0,a5,3266 <subdir+0x55e>
  close(fd);
    2ede:	8526                	mv	a0,s1
    2ee0:	00002097          	auipc	ra,0x2
    2ee4:	50c080e7          	jalr	1292(ra) # 53ec <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2ee8:	4581                	li	a1,0
    2eea:	00004517          	auipc	a0,0x4
    2eee:	ff650513          	addi	a0,a0,-10 # 6ee0 <malloc+0x16e4>
    2ef2:	00002097          	auipc	ra,0x2
    2ef6:	512080e7          	jalr	1298(ra) # 5404 <open>
    2efa:	38055463          	bgez	a0,3282 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2efe:	20200593          	li	a1,514
    2f02:	00004517          	auipc	a0,0x4
    2f06:	1ee50513          	addi	a0,a0,494 # 70f0 <malloc+0x18f4>
    2f0a:	00002097          	auipc	ra,0x2
    2f0e:	4fa080e7          	jalr	1274(ra) # 5404 <open>
    2f12:	38055663          	bgez	a0,329e <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2f16:	20200593          	li	a1,514
    2f1a:	00004517          	auipc	a0,0x4
    2f1e:	20650513          	addi	a0,a0,518 # 7120 <malloc+0x1924>
    2f22:	00002097          	auipc	ra,0x2
    2f26:	4e2080e7          	jalr	1250(ra) # 5404 <open>
    2f2a:	38055863          	bgez	a0,32ba <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2f2e:	20000593          	li	a1,512
    2f32:	00004517          	auipc	a0,0x4
    2f36:	f0e50513          	addi	a0,a0,-242 # 6e40 <malloc+0x1644>
    2f3a:	00002097          	auipc	ra,0x2
    2f3e:	4ca080e7          	jalr	1226(ra) # 5404 <open>
    2f42:	38055a63          	bgez	a0,32d6 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2f46:	4589                	li	a1,2
    2f48:	00004517          	auipc	a0,0x4
    2f4c:	ef850513          	addi	a0,a0,-264 # 6e40 <malloc+0x1644>
    2f50:	00002097          	auipc	ra,0x2
    2f54:	4b4080e7          	jalr	1204(ra) # 5404 <open>
    2f58:	38055d63          	bgez	a0,32f2 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2f5c:	4585                	li	a1,1
    2f5e:	00004517          	auipc	a0,0x4
    2f62:	ee250513          	addi	a0,a0,-286 # 6e40 <malloc+0x1644>
    2f66:	00002097          	auipc	ra,0x2
    2f6a:	49e080e7          	jalr	1182(ra) # 5404 <open>
    2f6e:	3a055063          	bgez	a0,330e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2f72:	00004597          	auipc	a1,0x4
    2f76:	23e58593          	addi	a1,a1,574 # 71b0 <malloc+0x19b4>
    2f7a:	00004517          	auipc	a0,0x4
    2f7e:	17650513          	addi	a0,a0,374 # 70f0 <malloc+0x18f4>
    2f82:	00002097          	auipc	ra,0x2
    2f86:	4a2080e7          	jalr	1186(ra) # 5424 <link>
    2f8a:	3a050063          	beqz	a0,332a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f8e:	00004597          	auipc	a1,0x4
    2f92:	22258593          	addi	a1,a1,546 # 71b0 <malloc+0x19b4>
    2f96:	00004517          	auipc	a0,0x4
    2f9a:	18a50513          	addi	a0,a0,394 # 7120 <malloc+0x1924>
    2f9e:	00002097          	auipc	ra,0x2
    2fa2:	486080e7          	jalr	1158(ra) # 5424 <link>
    2fa6:	3a050063          	beqz	a0,3346 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2faa:	00004597          	auipc	a1,0x4
    2fae:	fbe58593          	addi	a1,a1,-66 # 6f68 <malloc+0x176c>
    2fb2:	00004517          	auipc	a0,0x4
    2fb6:	eae50513          	addi	a0,a0,-338 # 6e60 <malloc+0x1664>
    2fba:	00002097          	auipc	ra,0x2
    2fbe:	46a080e7          	jalr	1130(ra) # 5424 <link>
    2fc2:	3a050063          	beqz	a0,3362 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2fc6:	00004517          	auipc	a0,0x4
    2fca:	12a50513          	addi	a0,a0,298 # 70f0 <malloc+0x18f4>
    2fce:	00002097          	auipc	ra,0x2
    2fd2:	45e080e7          	jalr	1118(ra) # 542c <mkdir>
    2fd6:	3a050463          	beqz	a0,337e <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2fda:	00004517          	auipc	a0,0x4
    2fde:	14650513          	addi	a0,a0,326 # 7120 <malloc+0x1924>
    2fe2:	00002097          	auipc	ra,0x2
    2fe6:	44a080e7          	jalr	1098(ra) # 542c <mkdir>
    2fea:	3a050863          	beqz	a0,339a <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2fee:	00004517          	auipc	a0,0x4
    2ff2:	f7a50513          	addi	a0,a0,-134 # 6f68 <malloc+0x176c>
    2ff6:	00002097          	auipc	ra,0x2
    2ffa:	436080e7          	jalr	1078(ra) # 542c <mkdir>
    2ffe:	3a050c63          	beqz	a0,33b6 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3002:	00004517          	auipc	a0,0x4
    3006:	11e50513          	addi	a0,a0,286 # 7120 <malloc+0x1924>
    300a:	00002097          	auipc	ra,0x2
    300e:	40a080e7          	jalr	1034(ra) # 5414 <unlink>
    3012:	3c050063          	beqz	a0,33d2 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3016:	00004517          	auipc	a0,0x4
    301a:	0da50513          	addi	a0,a0,218 # 70f0 <malloc+0x18f4>
    301e:	00002097          	auipc	ra,0x2
    3022:	3f6080e7          	jalr	1014(ra) # 5414 <unlink>
    3026:	3c050463          	beqz	a0,33ee <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    302a:	00004517          	auipc	a0,0x4
    302e:	e3650513          	addi	a0,a0,-458 # 6e60 <malloc+0x1664>
    3032:	00002097          	auipc	ra,0x2
    3036:	402080e7          	jalr	1026(ra) # 5434 <chdir>
    303a:	3c050863          	beqz	a0,340a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    303e:	00004517          	auipc	a0,0x4
    3042:	2c250513          	addi	a0,a0,706 # 7300 <malloc+0x1b04>
    3046:	00002097          	auipc	ra,0x2
    304a:	3ee080e7          	jalr	1006(ra) # 5434 <chdir>
    304e:	3c050c63          	beqz	a0,3426 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3052:	00004517          	auipc	a0,0x4
    3056:	f1650513          	addi	a0,a0,-234 # 6f68 <malloc+0x176c>
    305a:	00002097          	auipc	ra,0x2
    305e:	3ba080e7          	jalr	954(ra) # 5414 <unlink>
    3062:	3e051063          	bnez	a0,3442 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3066:	00004517          	auipc	a0,0x4
    306a:	dfa50513          	addi	a0,a0,-518 # 6e60 <malloc+0x1664>
    306e:	00002097          	auipc	ra,0x2
    3072:	3a6080e7          	jalr	934(ra) # 5414 <unlink>
    3076:	3e051463          	bnez	a0,345e <subdir+0x756>
  if(unlink("dd") == 0){
    307a:	00004517          	auipc	a0,0x4
    307e:	dc650513          	addi	a0,a0,-570 # 6e40 <malloc+0x1644>
    3082:	00002097          	auipc	ra,0x2
    3086:	392080e7          	jalr	914(ra) # 5414 <unlink>
    308a:	3e050863          	beqz	a0,347a <subdir+0x772>
  if(unlink("dd/dd") < 0){
    308e:	00004517          	auipc	a0,0x4
    3092:	2e250513          	addi	a0,a0,738 # 7370 <malloc+0x1b74>
    3096:	00002097          	auipc	ra,0x2
    309a:	37e080e7          	jalr	894(ra) # 5414 <unlink>
    309e:	3e054c63          	bltz	a0,3496 <subdir+0x78e>
  if(unlink("dd") < 0){
    30a2:	00004517          	auipc	a0,0x4
    30a6:	d9e50513          	addi	a0,a0,-610 # 6e40 <malloc+0x1644>
    30aa:	00002097          	auipc	ra,0x2
    30ae:	36a080e7          	jalr	874(ra) # 5414 <unlink>
    30b2:	40054063          	bltz	a0,34b2 <subdir+0x7aa>
}
    30b6:	60e2                	ld	ra,24(sp)
    30b8:	6442                	ld	s0,16(sp)
    30ba:	64a2                	ld	s1,8(sp)
    30bc:	6902                	ld	s2,0(sp)
    30be:	6105                	addi	sp,sp,32
    30c0:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    30c2:	85ca                	mv	a1,s2
    30c4:	00004517          	auipc	a0,0x4
    30c8:	d8450513          	addi	a0,a0,-636 # 6e48 <malloc+0x164c>
    30cc:	00002097          	auipc	ra,0x2
    30d0:	670080e7          	jalr	1648(ra) # 573c <printf>
    exit(1);
    30d4:	4505                	li	a0,1
    30d6:	00002097          	auipc	ra,0x2
    30da:	2ee080e7          	jalr	750(ra) # 53c4 <exit>
    printf("%s: create dd/ff failed\n", s);
    30de:	85ca                	mv	a1,s2
    30e0:	00004517          	auipc	a0,0x4
    30e4:	d8850513          	addi	a0,a0,-632 # 6e68 <malloc+0x166c>
    30e8:	00002097          	auipc	ra,0x2
    30ec:	654080e7          	jalr	1620(ra) # 573c <printf>
    exit(1);
    30f0:	4505                	li	a0,1
    30f2:	00002097          	auipc	ra,0x2
    30f6:	2d2080e7          	jalr	722(ra) # 53c4 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    30fa:	85ca                	mv	a1,s2
    30fc:	00004517          	auipc	a0,0x4
    3100:	d8c50513          	addi	a0,a0,-628 # 6e88 <malloc+0x168c>
    3104:	00002097          	auipc	ra,0x2
    3108:	638080e7          	jalr	1592(ra) # 573c <printf>
    exit(1);
    310c:	4505                	li	a0,1
    310e:	00002097          	auipc	ra,0x2
    3112:	2b6080e7          	jalr	694(ra) # 53c4 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3116:	85ca                	mv	a1,s2
    3118:	00004517          	auipc	a0,0x4
    311c:	da850513          	addi	a0,a0,-600 # 6ec0 <malloc+0x16c4>
    3120:	00002097          	auipc	ra,0x2
    3124:	61c080e7          	jalr	1564(ra) # 573c <printf>
    exit(1);
    3128:	4505                	li	a0,1
    312a:	00002097          	auipc	ra,0x2
    312e:	29a080e7          	jalr	666(ra) # 53c4 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3132:	85ca                	mv	a1,s2
    3134:	00004517          	auipc	a0,0x4
    3138:	dbc50513          	addi	a0,a0,-580 # 6ef0 <malloc+0x16f4>
    313c:	00002097          	auipc	ra,0x2
    3140:	600080e7          	jalr	1536(ra) # 573c <printf>
    exit(1);
    3144:	4505                	li	a0,1
    3146:	00002097          	auipc	ra,0x2
    314a:	27e080e7          	jalr	638(ra) # 53c4 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    314e:	85ca                	mv	a1,s2
    3150:	00004517          	auipc	a0,0x4
    3154:	dd850513          	addi	a0,a0,-552 # 6f28 <malloc+0x172c>
    3158:	00002097          	auipc	ra,0x2
    315c:	5e4080e7          	jalr	1508(ra) # 573c <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	00002097          	auipc	ra,0x2
    3166:	262080e7          	jalr	610(ra) # 53c4 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    316a:	85ca                	mv	a1,s2
    316c:	00004517          	auipc	a0,0x4
    3170:	ddc50513          	addi	a0,a0,-548 # 6f48 <malloc+0x174c>
    3174:	00002097          	auipc	ra,0x2
    3178:	5c8080e7          	jalr	1480(ra) # 573c <printf>
    exit(1);
    317c:	4505                	li	a0,1
    317e:	00002097          	auipc	ra,0x2
    3182:	246080e7          	jalr	582(ra) # 53c4 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3186:	85ca                	mv	a1,s2
    3188:	00004517          	auipc	a0,0x4
    318c:	df050513          	addi	a0,a0,-528 # 6f78 <malloc+0x177c>
    3190:	00002097          	auipc	ra,0x2
    3194:	5ac080e7          	jalr	1452(ra) # 573c <printf>
    exit(1);
    3198:	4505                	li	a0,1
    319a:	00002097          	auipc	ra,0x2
    319e:	22a080e7          	jalr	554(ra) # 53c4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    31a2:	85ca                	mv	a1,s2
    31a4:	00004517          	auipc	a0,0x4
    31a8:	dfc50513          	addi	a0,a0,-516 # 6fa0 <malloc+0x17a4>
    31ac:	00002097          	auipc	ra,0x2
    31b0:	590080e7          	jalr	1424(ra) # 573c <printf>
    exit(1);
    31b4:	4505                	li	a0,1
    31b6:	00002097          	auipc	ra,0x2
    31ba:	20e080e7          	jalr	526(ra) # 53c4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    31be:	85ca                	mv	a1,s2
    31c0:	00004517          	auipc	a0,0x4
    31c4:	e0050513          	addi	a0,a0,-512 # 6fc0 <malloc+0x17c4>
    31c8:	00002097          	auipc	ra,0x2
    31cc:	574080e7          	jalr	1396(ra) # 573c <printf>
    exit(1);
    31d0:	4505                	li	a0,1
    31d2:	00002097          	auipc	ra,0x2
    31d6:	1f2080e7          	jalr	498(ra) # 53c4 <exit>
    printf("%s: chdir dd failed\n", s);
    31da:	85ca                	mv	a1,s2
    31dc:	00004517          	auipc	a0,0x4
    31e0:	e0c50513          	addi	a0,a0,-500 # 6fe8 <malloc+0x17ec>
    31e4:	00002097          	auipc	ra,0x2
    31e8:	558080e7          	jalr	1368(ra) # 573c <printf>
    exit(1);
    31ec:	4505                	li	a0,1
    31ee:	00002097          	auipc	ra,0x2
    31f2:	1d6080e7          	jalr	470(ra) # 53c4 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    31f6:	85ca                	mv	a1,s2
    31f8:	00004517          	auipc	a0,0x4
    31fc:	e1850513          	addi	a0,a0,-488 # 7010 <malloc+0x1814>
    3200:	00002097          	auipc	ra,0x2
    3204:	53c080e7          	jalr	1340(ra) # 573c <printf>
    exit(1);
    3208:	4505                	li	a0,1
    320a:	00002097          	auipc	ra,0x2
    320e:	1ba080e7          	jalr	442(ra) # 53c4 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3212:	85ca                	mv	a1,s2
    3214:	00004517          	auipc	a0,0x4
    3218:	e2c50513          	addi	a0,a0,-468 # 7040 <malloc+0x1844>
    321c:	00002097          	auipc	ra,0x2
    3220:	520080e7          	jalr	1312(ra) # 573c <printf>
    exit(1);
    3224:	4505                	li	a0,1
    3226:	00002097          	auipc	ra,0x2
    322a:	19e080e7          	jalr	414(ra) # 53c4 <exit>
    printf("%s: chdir ./.. failed\n", s);
    322e:	85ca                	mv	a1,s2
    3230:	00004517          	auipc	a0,0x4
    3234:	e3850513          	addi	a0,a0,-456 # 7068 <malloc+0x186c>
    3238:	00002097          	auipc	ra,0x2
    323c:	504080e7          	jalr	1284(ra) # 573c <printf>
    exit(1);
    3240:	4505                	li	a0,1
    3242:	00002097          	auipc	ra,0x2
    3246:	182080e7          	jalr	386(ra) # 53c4 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    324a:	85ca                	mv	a1,s2
    324c:	00004517          	auipc	a0,0x4
    3250:	e3450513          	addi	a0,a0,-460 # 7080 <malloc+0x1884>
    3254:	00002097          	auipc	ra,0x2
    3258:	4e8080e7          	jalr	1256(ra) # 573c <printf>
    exit(1);
    325c:	4505                	li	a0,1
    325e:	00002097          	auipc	ra,0x2
    3262:	166080e7          	jalr	358(ra) # 53c4 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3266:	85ca                	mv	a1,s2
    3268:	00004517          	auipc	a0,0x4
    326c:	e3850513          	addi	a0,a0,-456 # 70a0 <malloc+0x18a4>
    3270:	00002097          	auipc	ra,0x2
    3274:	4cc080e7          	jalr	1228(ra) # 573c <printf>
    exit(1);
    3278:	4505                	li	a0,1
    327a:	00002097          	auipc	ra,0x2
    327e:	14a080e7          	jalr	330(ra) # 53c4 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3282:	85ca                	mv	a1,s2
    3284:	00004517          	auipc	a0,0x4
    3288:	e3c50513          	addi	a0,a0,-452 # 70c0 <malloc+0x18c4>
    328c:	00002097          	auipc	ra,0x2
    3290:	4b0080e7          	jalr	1200(ra) # 573c <printf>
    exit(1);
    3294:	4505                	li	a0,1
    3296:	00002097          	auipc	ra,0x2
    329a:	12e080e7          	jalr	302(ra) # 53c4 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    329e:	85ca                	mv	a1,s2
    32a0:	00004517          	auipc	a0,0x4
    32a4:	e6050513          	addi	a0,a0,-416 # 7100 <malloc+0x1904>
    32a8:	00002097          	auipc	ra,0x2
    32ac:	494080e7          	jalr	1172(ra) # 573c <printf>
    exit(1);
    32b0:	4505                	li	a0,1
    32b2:	00002097          	auipc	ra,0x2
    32b6:	112080e7          	jalr	274(ra) # 53c4 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    32ba:	85ca                	mv	a1,s2
    32bc:	00004517          	auipc	a0,0x4
    32c0:	e7450513          	addi	a0,a0,-396 # 7130 <malloc+0x1934>
    32c4:	00002097          	auipc	ra,0x2
    32c8:	478080e7          	jalr	1144(ra) # 573c <printf>
    exit(1);
    32cc:	4505                	li	a0,1
    32ce:	00002097          	auipc	ra,0x2
    32d2:	0f6080e7          	jalr	246(ra) # 53c4 <exit>
    printf("%s: create dd succeeded!\n", s);
    32d6:	85ca                	mv	a1,s2
    32d8:	00004517          	auipc	a0,0x4
    32dc:	e7850513          	addi	a0,a0,-392 # 7150 <malloc+0x1954>
    32e0:	00002097          	auipc	ra,0x2
    32e4:	45c080e7          	jalr	1116(ra) # 573c <printf>
    exit(1);
    32e8:	4505                	li	a0,1
    32ea:	00002097          	auipc	ra,0x2
    32ee:	0da080e7          	jalr	218(ra) # 53c4 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    32f2:	85ca                	mv	a1,s2
    32f4:	00004517          	auipc	a0,0x4
    32f8:	e7c50513          	addi	a0,a0,-388 # 7170 <malloc+0x1974>
    32fc:	00002097          	auipc	ra,0x2
    3300:	440080e7          	jalr	1088(ra) # 573c <printf>
    exit(1);
    3304:	4505                	li	a0,1
    3306:	00002097          	auipc	ra,0x2
    330a:	0be080e7          	jalr	190(ra) # 53c4 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    330e:	85ca                	mv	a1,s2
    3310:	00004517          	auipc	a0,0x4
    3314:	e8050513          	addi	a0,a0,-384 # 7190 <malloc+0x1994>
    3318:	00002097          	auipc	ra,0x2
    331c:	424080e7          	jalr	1060(ra) # 573c <printf>
    exit(1);
    3320:	4505                	li	a0,1
    3322:	00002097          	auipc	ra,0x2
    3326:	0a2080e7          	jalr	162(ra) # 53c4 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    332a:	85ca                	mv	a1,s2
    332c:	00004517          	auipc	a0,0x4
    3330:	e9450513          	addi	a0,a0,-364 # 71c0 <malloc+0x19c4>
    3334:	00002097          	auipc	ra,0x2
    3338:	408080e7          	jalr	1032(ra) # 573c <printf>
    exit(1);
    333c:	4505                	li	a0,1
    333e:	00002097          	auipc	ra,0x2
    3342:	086080e7          	jalr	134(ra) # 53c4 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3346:	85ca                	mv	a1,s2
    3348:	00004517          	auipc	a0,0x4
    334c:	ea050513          	addi	a0,a0,-352 # 71e8 <malloc+0x19ec>
    3350:	00002097          	auipc	ra,0x2
    3354:	3ec080e7          	jalr	1004(ra) # 573c <printf>
    exit(1);
    3358:	4505                	li	a0,1
    335a:	00002097          	auipc	ra,0x2
    335e:	06a080e7          	jalr	106(ra) # 53c4 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3362:	85ca                	mv	a1,s2
    3364:	00004517          	auipc	a0,0x4
    3368:	eac50513          	addi	a0,a0,-340 # 7210 <malloc+0x1a14>
    336c:	00002097          	auipc	ra,0x2
    3370:	3d0080e7          	jalr	976(ra) # 573c <printf>
    exit(1);
    3374:	4505                	li	a0,1
    3376:	00002097          	auipc	ra,0x2
    337a:	04e080e7          	jalr	78(ra) # 53c4 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    337e:	85ca                	mv	a1,s2
    3380:	00004517          	auipc	a0,0x4
    3384:	eb850513          	addi	a0,a0,-328 # 7238 <malloc+0x1a3c>
    3388:	00002097          	auipc	ra,0x2
    338c:	3b4080e7          	jalr	948(ra) # 573c <printf>
    exit(1);
    3390:	4505                	li	a0,1
    3392:	00002097          	auipc	ra,0x2
    3396:	032080e7          	jalr	50(ra) # 53c4 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    339a:	85ca                	mv	a1,s2
    339c:	00004517          	auipc	a0,0x4
    33a0:	ebc50513          	addi	a0,a0,-324 # 7258 <malloc+0x1a5c>
    33a4:	00002097          	auipc	ra,0x2
    33a8:	398080e7          	jalr	920(ra) # 573c <printf>
    exit(1);
    33ac:	4505                	li	a0,1
    33ae:	00002097          	auipc	ra,0x2
    33b2:	016080e7          	jalr	22(ra) # 53c4 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    33b6:	85ca                	mv	a1,s2
    33b8:	00004517          	auipc	a0,0x4
    33bc:	ec050513          	addi	a0,a0,-320 # 7278 <malloc+0x1a7c>
    33c0:	00002097          	auipc	ra,0x2
    33c4:	37c080e7          	jalr	892(ra) # 573c <printf>
    exit(1);
    33c8:	4505                	li	a0,1
    33ca:	00002097          	auipc	ra,0x2
    33ce:	ffa080e7          	jalr	-6(ra) # 53c4 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    33d2:	85ca                	mv	a1,s2
    33d4:	00004517          	auipc	a0,0x4
    33d8:	ecc50513          	addi	a0,a0,-308 # 72a0 <malloc+0x1aa4>
    33dc:	00002097          	auipc	ra,0x2
    33e0:	360080e7          	jalr	864(ra) # 573c <printf>
    exit(1);
    33e4:	4505                	li	a0,1
    33e6:	00002097          	auipc	ra,0x2
    33ea:	fde080e7          	jalr	-34(ra) # 53c4 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    33ee:	85ca                	mv	a1,s2
    33f0:	00004517          	auipc	a0,0x4
    33f4:	ed050513          	addi	a0,a0,-304 # 72c0 <malloc+0x1ac4>
    33f8:	00002097          	auipc	ra,0x2
    33fc:	344080e7          	jalr	836(ra) # 573c <printf>
    exit(1);
    3400:	4505                	li	a0,1
    3402:	00002097          	auipc	ra,0x2
    3406:	fc2080e7          	jalr	-62(ra) # 53c4 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    340a:	85ca                	mv	a1,s2
    340c:	00004517          	auipc	a0,0x4
    3410:	ed450513          	addi	a0,a0,-300 # 72e0 <malloc+0x1ae4>
    3414:	00002097          	auipc	ra,0x2
    3418:	328080e7          	jalr	808(ra) # 573c <printf>
    exit(1);
    341c:	4505                	li	a0,1
    341e:	00002097          	auipc	ra,0x2
    3422:	fa6080e7          	jalr	-90(ra) # 53c4 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3426:	85ca                	mv	a1,s2
    3428:	00004517          	auipc	a0,0x4
    342c:	ee050513          	addi	a0,a0,-288 # 7308 <malloc+0x1b0c>
    3430:	00002097          	auipc	ra,0x2
    3434:	30c080e7          	jalr	780(ra) # 573c <printf>
    exit(1);
    3438:	4505                	li	a0,1
    343a:	00002097          	auipc	ra,0x2
    343e:	f8a080e7          	jalr	-118(ra) # 53c4 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3442:	85ca                	mv	a1,s2
    3444:	00004517          	auipc	a0,0x4
    3448:	b5c50513          	addi	a0,a0,-1188 # 6fa0 <malloc+0x17a4>
    344c:	00002097          	auipc	ra,0x2
    3450:	2f0080e7          	jalr	752(ra) # 573c <printf>
    exit(1);
    3454:	4505                	li	a0,1
    3456:	00002097          	auipc	ra,0x2
    345a:	f6e080e7          	jalr	-146(ra) # 53c4 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    345e:	85ca                	mv	a1,s2
    3460:	00004517          	auipc	a0,0x4
    3464:	ec850513          	addi	a0,a0,-312 # 7328 <malloc+0x1b2c>
    3468:	00002097          	auipc	ra,0x2
    346c:	2d4080e7          	jalr	724(ra) # 573c <printf>
    exit(1);
    3470:	4505                	li	a0,1
    3472:	00002097          	auipc	ra,0x2
    3476:	f52080e7          	jalr	-174(ra) # 53c4 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    347a:	85ca                	mv	a1,s2
    347c:	00004517          	auipc	a0,0x4
    3480:	ecc50513          	addi	a0,a0,-308 # 7348 <malloc+0x1b4c>
    3484:	00002097          	auipc	ra,0x2
    3488:	2b8080e7          	jalr	696(ra) # 573c <printf>
    exit(1);
    348c:	4505                	li	a0,1
    348e:	00002097          	auipc	ra,0x2
    3492:	f36080e7          	jalr	-202(ra) # 53c4 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3496:	85ca                	mv	a1,s2
    3498:	00004517          	auipc	a0,0x4
    349c:	ee050513          	addi	a0,a0,-288 # 7378 <malloc+0x1b7c>
    34a0:	00002097          	auipc	ra,0x2
    34a4:	29c080e7          	jalr	668(ra) # 573c <printf>
    exit(1);
    34a8:	4505                	li	a0,1
    34aa:	00002097          	auipc	ra,0x2
    34ae:	f1a080e7          	jalr	-230(ra) # 53c4 <exit>
    printf("%s: unlink dd failed\n", s);
    34b2:	85ca                	mv	a1,s2
    34b4:	00004517          	auipc	a0,0x4
    34b8:	ee450513          	addi	a0,a0,-284 # 7398 <malloc+0x1b9c>
    34bc:	00002097          	auipc	ra,0x2
    34c0:	280080e7          	jalr	640(ra) # 573c <printf>
    exit(1);
    34c4:	4505                	li	a0,1
    34c6:	00002097          	auipc	ra,0x2
    34ca:	efe080e7          	jalr	-258(ra) # 53c4 <exit>

00000000000034ce <rmdot>:
{
    34ce:	1101                	addi	sp,sp,-32
    34d0:	ec06                	sd	ra,24(sp)
    34d2:	e822                	sd	s0,16(sp)
    34d4:	e426                	sd	s1,8(sp)
    34d6:	1000                	addi	s0,sp,32
    34d8:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    34da:	00004517          	auipc	a0,0x4
    34de:	ed650513          	addi	a0,a0,-298 # 73b0 <malloc+0x1bb4>
    34e2:	00002097          	auipc	ra,0x2
    34e6:	f4a080e7          	jalr	-182(ra) # 542c <mkdir>
    34ea:	e549                	bnez	a0,3574 <rmdot+0xa6>
  if(chdir("dots") != 0){
    34ec:	00004517          	auipc	a0,0x4
    34f0:	ec450513          	addi	a0,a0,-316 # 73b0 <malloc+0x1bb4>
    34f4:	00002097          	auipc	ra,0x2
    34f8:	f40080e7          	jalr	-192(ra) # 5434 <chdir>
    34fc:	e951                	bnez	a0,3590 <rmdot+0xc2>
  if(unlink(".") == 0){
    34fe:	00003517          	auipc	a0,0x3
    3502:	e7a50513          	addi	a0,a0,-390 # 6378 <malloc+0xb7c>
    3506:	00002097          	auipc	ra,0x2
    350a:	f0e080e7          	jalr	-242(ra) # 5414 <unlink>
    350e:	cd59                	beqz	a0,35ac <rmdot+0xde>
  if(unlink("..") == 0){
    3510:	00004517          	auipc	a0,0x4
    3514:	ef050513          	addi	a0,a0,-272 # 7400 <malloc+0x1c04>
    3518:	00002097          	auipc	ra,0x2
    351c:	efc080e7          	jalr	-260(ra) # 5414 <unlink>
    3520:	c545                	beqz	a0,35c8 <rmdot+0xfa>
  if(chdir("/") != 0){
    3522:	00004517          	auipc	a0,0x4
    3526:	8e650513          	addi	a0,a0,-1818 # 6e08 <malloc+0x160c>
    352a:	00002097          	auipc	ra,0x2
    352e:	f0a080e7          	jalr	-246(ra) # 5434 <chdir>
    3532:	e94d                	bnez	a0,35e4 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3534:	00004517          	auipc	a0,0x4
    3538:	eec50513          	addi	a0,a0,-276 # 7420 <malloc+0x1c24>
    353c:	00002097          	auipc	ra,0x2
    3540:	ed8080e7          	jalr	-296(ra) # 5414 <unlink>
    3544:	cd55                	beqz	a0,3600 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3546:	00004517          	auipc	a0,0x4
    354a:	f0250513          	addi	a0,a0,-254 # 7448 <malloc+0x1c4c>
    354e:	00002097          	auipc	ra,0x2
    3552:	ec6080e7          	jalr	-314(ra) # 5414 <unlink>
    3556:	c179                	beqz	a0,361c <rmdot+0x14e>
  if(unlink("dots") != 0){
    3558:	00004517          	auipc	a0,0x4
    355c:	e5850513          	addi	a0,a0,-424 # 73b0 <malloc+0x1bb4>
    3560:	00002097          	auipc	ra,0x2
    3564:	eb4080e7          	jalr	-332(ra) # 5414 <unlink>
    3568:	e961                	bnez	a0,3638 <rmdot+0x16a>
}
    356a:	60e2                	ld	ra,24(sp)
    356c:	6442                	ld	s0,16(sp)
    356e:	64a2                	ld	s1,8(sp)
    3570:	6105                	addi	sp,sp,32
    3572:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3574:	85a6                	mv	a1,s1
    3576:	00004517          	auipc	a0,0x4
    357a:	e4250513          	addi	a0,a0,-446 # 73b8 <malloc+0x1bbc>
    357e:	00002097          	auipc	ra,0x2
    3582:	1be080e7          	jalr	446(ra) # 573c <printf>
    exit(1);
    3586:	4505                	li	a0,1
    3588:	00002097          	auipc	ra,0x2
    358c:	e3c080e7          	jalr	-452(ra) # 53c4 <exit>
    printf("%s: chdir dots failed\n", s);
    3590:	85a6                	mv	a1,s1
    3592:	00004517          	auipc	a0,0x4
    3596:	e3e50513          	addi	a0,a0,-450 # 73d0 <malloc+0x1bd4>
    359a:	00002097          	auipc	ra,0x2
    359e:	1a2080e7          	jalr	418(ra) # 573c <printf>
    exit(1);
    35a2:	4505                	li	a0,1
    35a4:	00002097          	auipc	ra,0x2
    35a8:	e20080e7          	jalr	-480(ra) # 53c4 <exit>
    printf("%s: rm . worked!\n", s);
    35ac:	85a6                	mv	a1,s1
    35ae:	00004517          	auipc	a0,0x4
    35b2:	e3a50513          	addi	a0,a0,-454 # 73e8 <malloc+0x1bec>
    35b6:	00002097          	auipc	ra,0x2
    35ba:	186080e7          	jalr	390(ra) # 573c <printf>
    exit(1);
    35be:	4505                	li	a0,1
    35c0:	00002097          	auipc	ra,0x2
    35c4:	e04080e7          	jalr	-508(ra) # 53c4 <exit>
    printf("%s: rm .. worked!\n", s);
    35c8:	85a6                	mv	a1,s1
    35ca:	00004517          	auipc	a0,0x4
    35ce:	e3e50513          	addi	a0,a0,-450 # 7408 <malloc+0x1c0c>
    35d2:	00002097          	auipc	ra,0x2
    35d6:	16a080e7          	jalr	362(ra) # 573c <printf>
    exit(1);
    35da:	4505                	li	a0,1
    35dc:	00002097          	auipc	ra,0x2
    35e0:	de8080e7          	jalr	-536(ra) # 53c4 <exit>
    printf("%s: chdir / failed\n", s);
    35e4:	85a6                	mv	a1,s1
    35e6:	00004517          	auipc	a0,0x4
    35ea:	82a50513          	addi	a0,a0,-2006 # 6e10 <malloc+0x1614>
    35ee:	00002097          	auipc	ra,0x2
    35f2:	14e080e7          	jalr	334(ra) # 573c <printf>
    exit(1);
    35f6:	4505                	li	a0,1
    35f8:	00002097          	auipc	ra,0x2
    35fc:	dcc080e7          	jalr	-564(ra) # 53c4 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3600:	85a6                	mv	a1,s1
    3602:	00004517          	auipc	a0,0x4
    3606:	e2650513          	addi	a0,a0,-474 # 7428 <malloc+0x1c2c>
    360a:	00002097          	auipc	ra,0x2
    360e:	132080e7          	jalr	306(ra) # 573c <printf>
    exit(1);
    3612:	4505                	li	a0,1
    3614:	00002097          	auipc	ra,0x2
    3618:	db0080e7          	jalr	-592(ra) # 53c4 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    361c:	85a6                	mv	a1,s1
    361e:	00004517          	auipc	a0,0x4
    3622:	e3250513          	addi	a0,a0,-462 # 7450 <malloc+0x1c54>
    3626:	00002097          	auipc	ra,0x2
    362a:	116080e7          	jalr	278(ra) # 573c <printf>
    exit(1);
    362e:	4505                	li	a0,1
    3630:	00002097          	auipc	ra,0x2
    3634:	d94080e7          	jalr	-620(ra) # 53c4 <exit>
    printf("%s: unlink dots failed!\n", s);
    3638:	85a6                	mv	a1,s1
    363a:	00004517          	auipc	a0,0x4
    363e:	e3650513          	addi	a0,a0,-458 # 7470 <malloc+0x1c74>
    3642:	00002097          	auipc	ra,0x2
    3646:	0fa080e7          	jalr	250(ra) # 573c <printf>
    exit(1);
    364a:	4505                	li	a0,1
    364c:	00002097          	auipc	ra,0x2
    3650:	d78080e7          	jalr	-648(ra) # 53c4 <exit>

0000000000003654 <dirfile>:
{
    3654:	1101                	addi	sp,sp,-32
    3656:	ec06                	sd	ra,24(sp)
    3658:	e822                	sd	s0,16(sp)
    365a:	e426                	sd	s1,8(sp)
    365c:	e04a                	sd	s2,0(sp)
    365e:	1000                	addi	s0,sp,32
    3660:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3662:	20000593          	li	a1,512
    3666:	00004517          	auipc	a0,0x4
    366a:	e2a50513          	addi	a0,a0,-470 # 7490 <malloc+0x1c94>
    366e:	00002097          	auipc	ra,0x2
    3672:	d96080e7          	jalr	-618(ra) # 5404 <open>
  if(fd < 0){
    3676:	0e054d63          	bltz	a0,3770 <dirfile+0x11c>
  close(fd);
    367a:	00002097          	auipc	ra,0x2
    367e:	d72080e7          	jalr	-654(ra) # 53ec <close>
  if(chdir("dirfile") == 0){
    3682:	00004517          	auipc	a0,0x4
    3686:	e0e50513          	addi	a0,a0,-498 # 7490 <malloc+0x1c94>
    368a:	00002097          	auipc	ra,0x2
    368e:	daa080e7          	jalr	-598(ra) # 5434 <chdir>
    3692:	cd6d                	beqz	a0,378c <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3694:	4581                	li	a1,0
    3696:	00004517          	auipc	a0,0x4
    369a:	e4250513          	addi	a0,a0,-446 # 74d8 <malloc+0x1cdc>
    369e:	00002097          	auipc	ra,0x2
    36a2:	d66080e7          	jalr	-666(ra) # 5404 <open>
  if(fd >= 0){
    36a6:	10055163          	bgez	a0,37a8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    36aa:	20000593          	li	a1,512
    36ae:	00004517          	auipc	a0,0x4
    36b2:	e2a50513          	addi	a0,a0,-470 # 74d8 <malloc+0x1cdc>
    36b6:	00002097          	auipc	ra,0x2
    36ba:	d4e080e7          	jalr	-690(ra) # 5404 <open>
  if(fd >= 0){
    36be:	10055363          	bgez	a0,37c4 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    36c2:	00004517          	auipc	a0,0x4
    36c6:	e1650513          	addi	a0,a0,-490 # 74d8 <malloc+0x1cdc>
    36ca:	00002097          	auipc	ra,0x2
    36ce:	d62080e7          	jalr	-670(ra) # 542c <mkdir>
    36d2:	10050763          	beqz	a0,37e0 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    36d6:	00004517          	auipc	a0,0x4
    36da:	e0250513          	addi	a0,a0,-510 # 74d8 <malloc+0x1cdc>
    36de:	00002097          	auipc	ra,0x2
    36e2:	d36080e7          	jalr	-714(ra) # 5414 <unlink>
    36e6:	10050b63          	beqz	a0,37fc <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    36ea:	00004597          	auipc	a1,0x4
    36ee:	dee58593          	addi	a1,a1,-530 # 74d8 <malloc+0x1cdc>
    36f2:	00002517          	auipc	a0,0x2
    36f6:	77650513          	addi	a0,a0,1910 # 5e68 <malloc+0x66c>
    36fa:	00002097          	auipc	ra,0x2
    36fe:	d2a080e7          	jalr	-726(ra) # 5424 <link>
    3702:	10050b63          	beqz	a0,3818 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3706:	00004517          	auipc	a0,0x4
    370a:	d8a50513          	addi	a0,a0,-630 # 7490 <malloc+0x1c94>
    370e:	00002097          	auipc	ra,0x2
    3712:	d06080e7          	jalr	-762(ra) # 5414 <unlink>
    3716:	10051f63          	bnez	a0,3834 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    371a:	4589                	li	a1,2
    371c:	00003517          	auipc	a0,0x3
    3720:	c5c50513          	addi	a0,a0,-932 # 6378 <malloc+0xb7c>
    3724:	00002097          	auipc	ra,0x2
    3728:	ce0080e7          	jalr	-800(ra) # 5404 <open>
  if(fd >= 0){
    372c:	12055263          	bgez	a0,3850 <dirfile+0x1fc>
  fd = open(".", 0);
    3730:	4581                	li	a1,0
    3732:	00003517          	auipc	a0,0x3
    3736:	c4650513          	addi	a0,a0,-954 # 6378 <malloc+0xb7c>
    373a:	00002097          	auipc	ra,0x2
    373e:	cca080e7          	jalr	-822(ra) # 5404 <open>
    3742:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3744:	4605                	li	a2,1
    3746:	00002597          	auipc	a1,0x2
    374a:	5ea58593          	addi	a1,a1,1514 # 5d30 <malloc+0x534>
    374e:	00002097          	auipc	ra,0x2
    3752:	c96080e7          	jalr	-874(ra) # 53e4 <write>
    3756:	10a04b63          	bgtz	a0,386c <dirfile+0x218>
  close(fd);
    375a:	8526                	mv	a0,s1
    375c:	00002097          	auipc	ra,0x2
    3760:	c90080e7          	jalr	-880(ra) # 53ec <close>
}
    3764:	60e2                	ld	ra,24(sp)
    3766:	6442                	ld	s0,16(sp)
    3768:	64a2                	ld	s1,8(sp)
    376a:	6902                	ld	s2,0(sp)
    376c:	6105                	addi	sp,sp,32
    376e:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3770:	85ca                	mv	a1,s2
    3772:	00004517          	auipc	a0,0x4
    3776:	d2650513          	addi	a0,a0,-730 # 7498 <malloc+0x1c9c>
    377a:	00002097          	auipc	ra,0x2
    377e:	fc2080e7          	jalr	-62(ra) # 573c <printf>
    exit(1);
    3782:	4505                	li	a0,1
    3784:	00002097          	auipc	ra,0x2
    3788:	c40080e7          	jalr	-960(ra) # 53c4 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    378c:	85ca                	mv	a1,s2
    378e:	00004517          	auipc	a0,0x4
    3792:	d2a50513          	addi	a0,a0,-726 # 74b8 <malloc+0x1cbc>
    3796:	00002097          	auipc	ra,0x2
    379a:	fa6080e7          	jalr	-90(ra) # 573c <printf>
    exit(1);
    379e:	4505                	li	a0,1
    37a0:	00002097          	auipc	ra,0x2
    37a4:	c24080e7          	jalr	-988(ra) # 53c4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    37a8:	85ca                	mv	a1,s2
    37aa:	00004517          	auipc	a0,0x4
    37ae:	d3e50513          	addi	a0,a0,-706 # 74e8 <malloc+0x1cec>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	f8a080e7          	jalr	-118(ra) # 573c <printf>
    exit(1);
    37ba:	4505                	li	a0,1
    37bc:	00002097          	auipc	ra,0x2
    37c0:	c08080e7          	jalr	-1016(ra) # 53c4 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    37c4:	85ca                	mv	a1,s2
    37c6:	00004517          	auipc	a0,0x4
    37ca:	d2250513          	addi	a0,a0,-734 # 74e8 <malloc+0x1cec>
    37ce:	00002097          	auipc	ra,0x2
    37d2:	f6e080e7          	jalr	-146(ra) # 573c <printf>
    exit(1);
    37d6:	4505                	li	a0,1
    37d8:	00002097          	auipc	ra,0x2
    37dc:	bec080e7          	jalr	-1044(ra) # 53c4 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    37e0:	85ca                	mv	a1,s2
    37e2:	00004517          	auipc	a0,0x4
    37e6:	d2e50513          	addi	a0,a0,-722 # 7510 <malloc+0x1d14>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	f52080e7          	jalr	-174(ra) # 573c <printf>
    exit(1);
    37f2:	4505                	li	a0,1
    37f4:	00002097          	auipc	ra,0x2
    37f8:	bd0080e7          	jalr	-1072(ra) # 53c4 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    37fc:	85ca                	mv	a1,s2
    37fe:	00004517          	auipc	a0,0x4
    3802:	d3a50513          	addi	a0,a0,-710 # 7538 <malloc+0x1d3c>
    3806:	00002097          	auipc	ra,0x2
    380a:	f36080e7          	jalr	-202(ra) # 573c <printf>
    exit(1);
    380e:	4505                	li	a0,1
    3810:	00002097          	auipc	ra,0x2
    3814:	bb4080e7          	jalr	-1100(ra) # 53c4 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3818:	85ca                	mv	a1,s2
    381a:	00004517          	auipc	a0,0x4
    381e:	d4650513          	addi	a0,a0,-698 # 7560 <malloc+0x1d64>
    3822:	00002097          	auipc	ra,0x2
    3826:	f1a080e7          	jalr	-230(ra) # 573c <printf>
    exit(1);
    382a:	4505                	li	a0,1
    382c:	00002097          	auipc	ra,0x2
    3830:	b98080e7          	jalr	-1128(ra) # 53c4 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3834:	85ca                	mv	a1,s2
    3836:	00004517          	auipc	a0,0x4
    383a:	d5250513          	addi	a0,a0,-686 # 7588 <malloc+0x1d8c>
    383e:	00002097          	auipc	ra,0x2
    3842:	efe080e7          	jalr	-258(ra) # 573c <printf>
    exit(1);
    3846:	4505                	li	a0,1
    3848:	00002097          	auipc	ra,0x2
    384c:	b7c080e7          	jalr	-1156(ra) # 53c4 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3850:	85ca                	mv	a1,s2
    3852:	00004517          	auipc	a0,0x4
    3856:	d5650513          	addi	a0,a0,-682 # 75a8 <malloc+0x1dac>
    385a:	00002097          	auipc	ra,0x2
    385e:	ee2080e7          	jalr	-286(ra) # 573c <printf>
    exit(1);
    3862:	4505                	li	a0,1
    3864:	00002097          	auipc	ra,0x2
    3868:	b60080e7          	jalr	-1184(ra) # 53c4 <exit>
    printf("%s: write . succeeded!\n", s);
    386c:	85ca                	mv	a1,s2
    386e:	00004517          	auipc	a0,0x4
    3872:	d6250513          	addi	a0,a0,-670 # 75d0 <malloc+0x1dd4>
    3876:	00002097          	auipc	ra,0x2
    387a:	ec6080e7          	jalr	-314(ra) # 573c <printf>
    exit(1);
    387e:	4505                	li	a0,1
    3880:	00002097          	auipc	ra,0x2
    3884:	b44080e7          	jalr	-1212(ra) # 53c4 <exit>

0000000000003888 <iref>:
{
    3888:	7139                	addi	sp,sp,-64
    388a:	fc06                	sd	ra,56(sp)
    388c:	f822                	sd	s0,48(sp)
    388e:	f426                	sd	s1,40(sp)
    3890:	f04a                	sd	s2,32(sp)
    3892:	ec4e                	sd	s3,24(sp)
    3894:	e852                	sd	s4,16(sp)
    3896:	e456                	sd	s5,8(sp)
    3898:	e05a                	sd	s6,0(sp)
    389a:	0080                	addi	s0,sp,64
    389c:	8b2a                	mv	s6,a0
    389e:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    38a2:	00004a17          	auipc	s4,0x4
    38a6:	d46a0a13          	addi	s4,s4,-698 # 75e8 <malloc+0x1dec>
    mkdir("");
    38aa:	00004497          	auipc	s1,0x4
    38ae:	83e48493          	addi	s1,s1,-1986 # 70e8 <malloc+0x18ec>
    link("README", "");
    38b2:	00002a97          	auipc	s5,0x2
    38b6:	5b6a8a93          	addi	s5,s5,1462 # 5e68 <malloc+0x66c>
    fd = open("xx", O_CREATE);
    38ba:	00004997          	auipc	s3,0x4
    38be:	c2698993          	addi	s3,s3,-986 # 74e0 <malloc+0x1ce4>
    38c2:	a891                	j	3916 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    38c4:	85da                	mv	a1,s6
    38c6:	00004517          	auipc	a0,0x4
    38ca:	d2a50513          	addi	a0,a0,-726 # 75f0 <malloc+0x1df4>
    38ce:	00002097          	auipc	ra,0x2
    38d2:	e6e080e7          	jalr	-402(ra) # 573c <printf>
      exit(1);
    38d6:	4505                	li	a0,1
    38d8:	00002097          	auipc	ra,0x2
    38dc:	aec080e7          	jalr	-1300(ra) # 53c4 <exit>
      printf("%s: chdir irefd failed\n", s);
    38e0:	85da                	mv	a1,s6
    38e2:	00004517          	auipc	a0,0x4
    38e6:	d2650513          	addi	a0,a0,-730 # 7608 <malloc+0x1e0c>
    38ea:	00002097          	auipc	ra,0x2
    38ee:	e52080e7          	jalr	-430(ra) # 573c <printf>
      exit(1);
    38f2:	4505                	li	a0,1
    38f4:	00002097          	auipc	ra,0x2
    38f8:	ad0080e7          	jalr	-1328(ra) # 53c4 <exit>
      close(fd);
    38fc:	00002097          	auipc	ra,0x2
    3900:	af0080e7          	jalr	-1296(ra) # 53ec <close>
    3904:	a889                	j	3956 <iref+0xce>
    unlink("xx");
    3906:	854e                	mv	a0,s3
    3908:	00002097          	auipc	ra,0x2
    390c:	b0c080e7          	jalr	-1268(ra) # 5414 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3910:	397d                	addiw	s2,s2,-1
    3912:	06090063          	beqz	s2,3972 <iref+0xea>
    if(mkdir("irefd") != 0){
    3916:	8552                	mv	a0,s4
    3918:	00002097          	auipc	ra,0x2
    391c:	b14080e7          	jalr	-1260(ra) # 542c <mkdir>
    3920:	f155                	bnez	a0,38c4 <iref+0x3c>
    if(chdir("irefd") != 0){
    3922:	8552                	mv	a0,s4
    3924:	00002097          	auipc	ra,0x2
    3928:	b10080e7          	jalr	-1264(ra) # 5434 <chdir>
    392c:	f955                	bnez	a0,38e0 <iref+0x58>
    mkdir("");
    392e:	8526                	mv	a0,s1
    3930:	00002097          	auipc	ra,0x2
    3934:	afc080e7          	jalr	-1284(ra) # 542c <mkdir>
    link("README", "");
    3938:	85a6                	mv	a1,s1
    393a:	8556                	mv	a0,s5
    393c:	00002097          	auipc	ra,0x2
    3940:	ae8080e7          	jalr	-1304(ra) # 5424 <link>
    fd = open("", O_CREATE);
    3944:	20000593          	li	a1,512
    3948:	8526                	mv	a0,s1
    394a:	00002097          	auipc	ra,0x2
    394e:	aba080e7          	jalr	-1350(ra) # 5404 <open>
    if(fd >= 0)
    3952:	fa0555e3          	bgez	a0,38fc <iref+0x74>
    fd = open("xx", O_CREATE);
    3956:	20000593          	li	a1,512
    395a:	854e                	mv	a0,s3
    395c:	00002097          	auipc	ra,0x2
    3960:	aa8080e7          	jalr	-1368(ra) # 5404 <open>
    if(fd >= 0)
    3964:	fa0541e3          	bltz	a0,3906 <iref+0x7e>
      close(fd);
    3968:	00002097          	auipc	ra,0x2
    396c:	a84080e7          	jalr	-1404(ra) # 53ec <close>
    3970:	bf59                	j	3906 <iref+0x7e>
    3972:	03300493          	li	s1,51
    chdir("..");
    3976:	00004997          	auipc	s3,0x4
    397a:	a8a98993          	addi	s3,s3,-1398 # 7400 <malloc+0x1c04>
    unlink("irefd");
    397e:	00004917          	auipc	s2,0x4
    3982:	c6a90913          	addi	s2,s2,-918 # 75e8 <malloc+0x1dec>
    chdir("..");
    3986:	854e                	mv	a0,s3
    3988:	00002097          	auipc	ra,0x2
    398c:	aac080e7          	jalr	-1364(ra) # 5434 <chdir>
    unlink("irefd");
    3990:	854a                	mv	a0,s2
    3992:	00002097          	auipc	ra,0x2
    3996:	a82080e7          	jalr	-1406(ra) # 5414 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    399a:	34fd                	addiw	s1,s1,-1
    399c:	f4ed                	bnez	s1,3986 <iref+0xfe>
  chdir("/");
    399e:	00003517          	auipc	a0,0x3
    39a2:	46a50513          	addi	a0,a0,1130 # 6e08 <malloc+0x160c>
    39a6:	00002097          	auipc	ra,0x2
    39aa:	a8e080e7          	jalr	-1394(ra) # 5434 <chdir>
}
    39ae:	70e2                	ld	ra,56(sp)
    39b0:	7442                	ld	s0,48(sp)
    39b2:	74a2                	ld	s1,40(sp)
    39b4:	7902                	ld	s2,32(sp)
    39b6:	69e2                	ld	s3,24(sp)
    39b8:	6a42                	ld	s4,16(sp)
    39ba:	6aa2                	ld	s5,8(sp)
    39bc:	6b02                	ld	s6,0(sp)
    39be:	6121                	addi	sp,sp,64
    39c0:	8082                	ret

00000000000039c2 <openiputtest>:
{
    39c2:	7179                	addi	sp,sp,-48
    39c4:	f406                	sd	ra,40(sp)
    39c6:	f022                	sd	s0,32(sp)
    39c8:	ec26                	sd	s1,24(sp)
    39ca:	1800                	addi	s0,sp,48
    39cc:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    39ce:	00004517          	auipc	a0,0x4
    39d2:	c5250513          	addi	a0,a0,-942 # 7620 <malloc+0x1e24>
    39d6:	00002097          	auipc	ra,0x2
    39da:	a56080e7          	jalr	-1450(ra) # 542c <mkdir>
    39de:	04054263          	bltz	a0,3a22 <openiputtest+0x60>
  pid = fork();
    39e2:	00002097          	auipc	ra,0x2
    39e6:	9da080e7          	jalr	-1574(ra) # 53bc <fork>
  if(pid < 0){
    39ea:	04054a63          	bltz	a0,3a3e <openiputtest+0x7c>
  if(pid == 0){
    39ee:	e93d                	bnez	a0,3a64 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    39f0:	4589                	li	a1,2
    39f2:	00004517          	auipc	a0,0x4
    39f6:	c2e50513          	addi	a0,a0,-978 # 7620 <malloc+0x1e24>
    39fa:	00002097          	auipc	ra,0x2
    39fe:	a0a080e7          	jalr	-1526(ra) # 5404 <open>
    if(fd >= 0){
    3a02:	04054c63          	bltz	a0,3a5a <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3a06:	85a6                	mv	a1,s1
    3a08:	00004517          	auipc	a0,0x4
    3a0c:	c3850513          	addi	a0,a0,-968 # 7640 <malloc+0x1e44>
    3a10:	00002097          	auipc	ra,0x2
    3a14:	d2c080e7          	jalr	-724(ra) # 573c <printf>
      exit(1);
    3a18:	4505                	li	a0,1
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	9aa080e7          	jalr	-1622(ra) # 53c4 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3a22:	85a6                	mv	a1,s1
    3a24:	00004517          	auipc	a0,0x4
    3a28:	c0450513          	addi	a0,a0,-1020 # 7628 <malloc+0x1e2c>
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	d10080e7          	jalr	-752(ra) # 573c <printf>
    exit(1);
    3a34:	4505                	li	a0,1
    3a36:	00002097          	auipc	ra,0x2
    3a3a:	98e080e7          	jalr	-1650(ra) # 53c4 <exit>
    printf("%s: fork failed\n", s);
    3a3e:	85a6                	mv	a1,s1
    3a40:	00003517          	auipc	a0,0x3
    3a44:	ad850513          	addi	a0,a0,-1320 # 6518 <malloc+0xd1c>
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	cf4080e7          	jalr	-780(ra) # 573c <printf>
    exit(1);
    3a50:	4505                	li	a0,1
    3a52:	00002097          	auipc	ra,0x2
    3a56:	972080e7          	jalr	-1678(ra) # 53c4 <exit>
    exit(0);
    3a5a:	4501                	li	a0,0
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	968080e7          	jalr	-1688(ra) # 53c4 <exit>
  sleep(1);
    3a64:	4505                	li	a0,1
    3a66:	00002097          	auipc	ra,0x2
    3a6a:	9ee080e7          	jalr	-1554(ra) # 5454 <sleep>
  if(unlink("oidir") != 0){
    3a6e:	00004517          	auipc	a0,0x4
    3a72:	bb250513          	addi	a0,a0,-1102 # 7620 <malloc+0x1e24>
    3a76:	00002097          	auipc	ra,0x2
    3a7a:	99e080e7          	jalr	-1634(ra) # 5414 <unlink>
    3a7e:	cd19                	beqz	a0,3a9c <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3a80:	85a6                	mv	a1,s1
    3a82:	00003517          	auipc	a0,0x3
    3a86:	c8650513          	addi	a0,a0,-890 # 6708 <malloc+0xf0c>
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	cb2080e7          	jalr	-846(ra) # 573c <printf>
    exit(1);
    3a92:	4505                	li	a0,1
    3a94:	00002097          	auipc	ra,0x2
    3a98:	930080e7          	jalr	-1744(ra) # 53c4 <exit>
  wait(&xstatus);
    3a9c:	fdc40513          	addi	a0,s0,-36
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	92c080e7          	jalr	-1748(ra) # 53cc <wait>
  exit(xstatus);
    3aa8:	fdc42503          	lw	a0,-36(s0)
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	918080e7          	jalr	-1768(ra) # 53c4 <exit>

0000000000003ab4 <forkforkfork>:
{
    3ab4:	1101                	addi	sp,sp,-32
    3ab6:	ec06                	sd	ra,24(sp)
    3ab8:	e822                	sd	s0,16(sp)
    3aba:	e426                	sd	s1,8(sp)
    3abc:	1000                	addi	s0,sp,32
    3abe:	84aa                	mv	s1,a0
  unlink("stopforking");
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	ba850513          	addi	a0,a0,-1112 # 7668 <malloc+0x1e6c>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	94c080e7          	jalr	-1716(ra) # 5414 <unlink>
  int pid = fork();
    3ad0:	00002097          	auipc	ra,0x2
    3ad4:	8ec080e7          	jalr	-1812(ra) # 53bc <fork>
  if(pid < 0){
    3ad8:	04054563          	bltz	a0,3b22 <forkforkfork+0x6e>
  if(pid == 0){
    3adc:	c12d                	beqz	a0,3b3e <forkforkfork+0x8a>
  sleep(20); // two seconds
    3ade:	4551                	li	a0,20
    3ae0:	00002097          	auipc	ra,0x2
    3ae4:	974080e7          	jalr	-1676(ra) # 5454 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3ae8:	20200593          	li	a1,514
    3aec:	00004517          	auipc	a0,0x4
    3af0:	b7c50513          	addi	a0,a0,-1156 # 7668 <malloc+0x1e6c>
    3af4:	00002097          	auipc	ra,0x2
    3af8:	910080e7          	jalr	-1776(ra) # 5404 <open>
    3afc:	00002097          	auipc	ra,0x2
    3b00:	8f0080e7          	jalr	-1808(ra) # 53ec <close>
  wait(0);
    3b04:	4501                	li	a0,0
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	8c6080e7          	jalr	-1850(ra) # 53cc <wait>
  sleep(10); // one second
    3b0e:	4529                	li	a0,10
    3b10:	00002097          	auipc	ra,0x2
    3b14:	944080e7          	jalr	-1724(ra) # 5454 <sleep>
}
    3b18:	60e2                	ld	ra,24(sp)
    3b1a:	6442                	ld	s0,16(sp)
    3b1c:	64a2                	ld	s1,8(sp)
    3b1e:	6105                	addi	sp,sp,32
    3b20:	8082                	ret
    printf("%s: fork failed", s);
    3b22:	85a6                	mv	a1,s1
    3b24:	00003517          	auipc	a0,0x3
    3b28:	bb450513          	addi	a0,a0,-1100 # 66d8 <malloc+0xedc>
    3b2c:	00002097          	auipc	ra,0x2
    3b30:	c10080e7          	jalr	-1008(ra) # 573c <printf>
    exit(1);
    3b34:	4505                	li	a0,1
    3b36:	00002097          	auipc	ra,0x2
    3b3a:	88e080e7          	jalr	-1906(ra) # 53c4 <exit>
      int fd = open("stopforking", 0);
    3b3e:	00004497          	auipc	s1,0x4
    3b42:	b2a48493          	addi	s1,s1,-1238 # 7668 <malloc+0x1e6c>
    3b46:	4581                	li	a1,0
    3b48:	8526                	mv	a0,s1
    3b4a:	00002097          	auipc	ra,0x2
    3b4e:	8ba080e7          	jalr	-1862(ra) # 5404 <open>
      if(fd >= 0){
    3b52:	02055463          	bgez	a0,3b7a <forkforkfork+0xc6>
      if(fork() < 0){
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	866080e7          	jalr	-1946(ra) # 53bc <fork>
    3b5e:	fe0554e3          	bgez	a0,3b46 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3b62:	20200593          	li	a1,514
    3b66:	8526                	mv	a0,s1
    3b68:	00002097          	auipc	ra,0x2
    3b6c:	89c080e7          	jalr	-1892(ra) # 5404 <open>
    3b70:	00002097          	auipc	ra,0x2
    3b74:	87c080e7          	jalr	-1924(ra) # 53ec <close>
    3b78:	b7f9                	j	3b46 <forkforkfork+0x92>
        exit(0);
    3b7a:	4501                	li	a0,0
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	848080e7          	jalr	-1976(ra) # 53c4 <exit>

0000000000003b84 <preempt>:
{
    3b84:	7139                	addi	sp,sp,-64
    3b86:	fc06                	sd	ra,56(sp)
    3b88:	f822                	sd	s0,48(sp)
    3b8a:	f426                	sd	s1,40(sp)
    3b8c:	f04a                	sd	s2,32(sp)
    3b8e:	ec4e                	sd	s3,24(sp)
    3b90:	e852                	sd	s4,16(sp)
    3b92:	0080                	addi	s0,sp,64
    3b94:	8a2a                	mv	s4,a0
  pid1 = fork();
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	826080e7          	jalr	-2010(ra) # 53bc <fork>
  if(pid1 < 0) {
    3b9e:	00054563          	bltz	a0,3ba8 <preempt+0x24>
    3ba2:	89aa                	mv	s3,a0
  if(pid1 == 0)
    3ba4:	ed19                	bnez	a0,3bc2 <preempt+0x3e>
    for(;;)
    3ba6:	a001                	j	3ba6 <preempt+0x22>
    printf("%s: fork failed");
    3ba8:	00003517          	auipc	a0,0x3
    3bac:	b3050513          	addi	a0,a0,-1232 # 66d8 <malloc+0xedc>
    3bb0:	00002097          	auipc	ra,0x2
    3bb4:	b8c080e7          	jalr	-1140(ra) # 573c <printf>
    exit(1);
    3bb8:	4505                	li	a0,1
    3bba:	00002097          	auipc	ra,0x2
    3bbe:	80a080e7          	jalr	-2038(ra) # 53c4 <exit>
  pid2 = fork();
    3bc2:	00001097          	auipc	ra,0x1
    3bc6:	7fa080e7          	jalr	2042(ra) # 53bc <fork>
    3bca:	892a                	mv	s2,a0
  if(pid2 < 0) {
    3bcc:	00054463          	bltz	a0,3bd4 <preempt+0x50>
  if(pid2 == 0)
    3bd0:	e105                	bnez	a0,3bf0 <preempt+0x6c>
    for(;;)
    3bd2:	a001                	j	3bd2 <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3bd4:	85d2                	mv	a1,s4
    3bd6:	00003517          	auipc	a0,0x3
    3bda:	94250513          	addi	a0,a0,-1726 # 6518 <malloc+0xd1c>
    3bde:	00002097          	auipc	ra,0x2
    3be2:	b5e080e7          	jalr	-1186(ra) # 573c <printf>
    exit(1);
    3be6:	4505                	li	a0,1
    3be8:	00001097          	auipc	ra,0x1
    3bec:	7dc080e7          	jalr	2012(ra) # 53c4 <exit>
  pipe(pfds);
    3bf0:	fc840513          	addi	a0,s0,-56
    3bf4:	00001097          	auipc	ra,0x1
    3bf8:	7e0080e7          	jalr	2016(ra) # 53d4 <pipe>
  pid3 = fork();
    3bfc:	00001097          	auipc	ra,0x1
    3c00:	7c0080e7          	jalr	1984(ra) # 53bc <fork>
    3c04:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    3c06:	02054e63          	bltz	a0,3c42 <preempt+0xbe>
  if(pid3 == 0){
    3c0a:	e13d                	bnez	a0,3c70 <preempt+0xec>
    close(pfds[0]);
    3c0c:	fc842503          	lw	a0,-56(s0)
    3c10:	00001097          	auipc	ra,0x1
    3c14:	7dc080e7          	jalr	2012(ra) # 53ec <close>
    if(write(pfds[1], "x", 1) != 1)
    3c18:	4605                	li	a2,1
    3c1a:	00002597          	auipc	a1,0x2
    3c1e:	11658593          	addi	a1,a1,278 # 5d30 <malloc+0x534>
    3c22:	fcc42503          	lw	a0,-52(s0)
    3c26:	00001097          	auipc	ra,0x1
    3c2a:	7be080e7          	jalr	1982(ra) # 53e4 <write>
    3c2e:	4785                	li	a5,1
    3c30:	02f51763          	bne	a0,a5,3c5e <preempt+0xda>
    close(pfds[1]);
    3c34:	fcc42503          	lw	a0,-52(s0)
    3c38:	00001097          	auipc	ra,0x1
    3c3c:	7b4080e7          	jalr	1972(ra) # 53ec <close>
    for(;;)
    3c40:	a001                	j	3c40 <preempt+0xbc>
     printf("%s: fork failed\n", s);
    3c42:	85d2                	mv	a1,s4
    3c44:	00003517          	auipc	a0,0x3
    3c48:	8d450513          	addi	a0,a0,-1836 # 6518 <malloc+0xd1c>
    3c4c:	00002097          	auipc	ra,0x2
    3c50:	af0080e7          	jalr	-1296(ra) # 573c <printf>
     exit(1);
    3c54:	4505                	li	a0,1
    3c56:	00001097          	auipc	ra,0x1
    3c5a:	76e080e7          	jalr	1902(ra) # 53c4 <exit>
      printf("%s: preempt write error");
    3c5e:	00004517          	auipc	a0,0x4
    3c62:	a1a50513          	addi	a0,a0,-1510 # 7678 <malloc+0x1e7c>
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	ad6080e7          	jalr	-1322(ra) # 573c <printf>
    3c6e:	b7d9                	j	3c34 <preempt+0xb0>
  close(pfds[1]);
    3c70:	fcc42503          	lw	a0,-52(s0)
    3c74:	00001097          	auipc	ra,0x1
    3c78:	778080e7          	jalr	1912(ra) # 53ec <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3c7c:	660d                	lui	a2,0x3
    3c7e:	00008597          	auipc	a1,0x8
    3c82:	b0a58593          	addi	a1,a1,-1270 # b788 <buf>
    3c86:	fc842503          	lw	a0,-56(s0)
    3c8a:	00001097          	auipc	ra,0x1
    3c8e:	752080e7          	jalr	1874(ra) # 53dc <read>
    3c92:	4785                	li	a5,1
    3c94:	02f50263          	beq	a0,a5,3cb8 <preempt+0x134>
    printf("%s: preempt read error");
    3c98:	00004517          	auipc	a0,0x4
    3c9c:	9f850513          	addi	a0,a0,-1544 # 7690 <malloc+0x1e94>
    3ca0:	00002097          	auipc	ra,0x2
    3ca4:	a9c080e7          	jalr	-1380(ra) # 573c <printf>
}
    3ca8:	70e2                	ld	ra,56(sp)
    3caa:	7442                	ld	s0,48(sp)
    3cac:	74a2                	ld	s1,40(sp)
    3cae:	7902                	ld	s2,32(sp)
    3cb0:	69e2                	ld	s3,24(sp)
    3cb2:	6a42                	ld	s4,16(sp)
    3cb4:	6121                	addi	sp,sp,64
    3cb6:	8082                	ret
  close(pfds[0]);
    3cb8:	fc842503          	lw	a0,-56(s0)
    3cbc:	00001097          	auipc	ra,0x1
    3cc0:	730080e7          	jalr	1840(ra) # 53ec <close>
  printf("kill... ");
    3cc4:	00004517          	auipc	a0,0x4
    3cc8:	9e450513          	addi	a0,a0,-1564 # 76a8 <malloc+0x1eac>
    3ccc:	00002097          	auipc	ra,0x2
    3cd0:	a70080e7          	jalr	-1424(ra) # 573c <printf>
  kill(pid1);
    3cd4:	854e                	mv	a0,s3
    3cd6:	00001097          	auipc	ra,0x1
    3cda:	71e080e7          	jalr	1822(ra) # 53f4 <kill>
  kill(pid2);
    3cde:	854a                	mv	a0,s2
    3ce0:	00001097          	auipc	ra,0x1
    3ce4:	714080e7          	jalr	1812(ra) # 53f4 <kill>
  kill(pid3);
    3ce8:	8526                	mv	a0,s1
    3cea:	00001097          	auipc	ra,0x1
    3cee:	70a080e7          	jalr	1802(ra) # 53f4 <kill>
  printf("wait... ");
    3cf2:	00004517          	auipc	a0,0x4
    3cf6:	9c650513          	addi	a0,a0,-1594 # 76b8 <malloc+0x1ebc>
    3cfa:	00002097          	auipc	ra,0x2
    3cfe:	a42080e7          	jalr	-1470(ra) # 573c <printf>
  wait(0);
    3d02:	4501                	li	a0,0
    3d04:	00001097          	auipc	ra,0x1
    3d08:	6c8080e7          	jalr	1736(ra) # 53cc <wait>
  wait(0);
    3d0c:	4501                	li	a0,0
    3d0e:	00001097          	auipc	ra,0x1
    3d12:	6be080e7          	jalr	1726(ra) # 53cc <wait>
  wait(0);
    3d16:	4501                	li	a0,0
    3d18:	00001097          	auipc	ra,0x1
    3d1c:	6b4080e7          	jalr	1716(ra) # 53cc <wait>
    3d20:	b761                	j	3ca8 <preempt+0x124>

0000000000003d22 <sbrkfail>:
{
    3d22:	7119                	addi	sp,sp,-128
    3d24:	fc86                	sd	ra,120(sp)
    3d26:	f8a2                	sd	s0,112(sp)
    3d28:	f4a6                	sd	s1,104(sp)
    3d2a:	f0ca                	sd	s2,96(sp)
    3d2c:	ecce                	sd	s3,88(sp)
    3d2e:	e8d2                	sd	s4,80(sp)
    3d30:	e4d6                	sd	s5,72(sp)
    3d32:	0100                	addi	s0,sp,128
    3d34:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    3d36:	fb040513          	addi	a0,s0,-80
    3d3a:	00001097          	auipc	ra,0x1
    3d3e:	69a080e7          	jalr	1690(ra) # 53d4 <pipe>
    3d42:	e901                	bnez	a0,3d52 <sbrkfail+0x30>
    3d44:	f8040493          	addi	s1,s0,-128
    3d48:	fa840993          	addi	s3,s0,-88
    3d4c:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3d4e:	5a7d                	li	s4,-1
    3d50:	a085                	j	3db0 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    3d52:	85d6                	mv	a1,s5
    3d54:	00003517          	auipc	a0,0x3
    3d58:	8cc50513          	addi	a0,a0,-1844 # 6620 <malloc+0xe24>
    3d5c:	00002097          	auipc	ra,0x2
    3d60:	9e0080e7          	jalr	-1568(ra) # 573c <printf>
    exit(1);
    3d64:	4505                	li	a0,1
    3d66:	00001097          	auipc	ra,0x1
    3d6a:	65e080e7          	jalr	1630(ra) # 53c4 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3d6e:	00001097          	auipc	ra,0x1
    3d72:	6de080e7          	jalr	1758(ra) # 544c <sbrk>
    3d76:	064007b7          	lui	a5,0x6400
    3d7a:	40a7853b          	subw	a0,a5,a0
    3d7e:	00001097          	auipc	ra,0x1
    3d82:	6ce080e7          	jalr	1742(ra) # 544c <sbrk>
      write(fds[1], "x", 1);
    3d86:	4605                	li	a2,1
    3d88:	00002597          	auipc	a1,0x2
    3d8c:	fa858593          	addi	a1,a1,-88 # 5d30 <malloc+0x534>
    3d90:	fb442503          	lw	a0,-76(s0)
    3d94:	00001097          	auipc	ra,0x1
    3d98:	650080e7          	jalr	1616(ra) # 53e4 <write>
      for(;;) sleep(1000);
    3d9c:	3e800513          	li	a0,1000
    3da0:	00001097          	auipc	ra,0x1
    3da4:	6b4080e7          	jalr	1716(ra) # 5454 <sleep>
    3da8:	bfd5                	j	3d9c <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3daa:	0911                	addi	s2,s2,4
    3dac:	03390563          	beq	s2,s3,3dd6 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    3db0:	00001097          	auipc	ra,0x1
    3db4:	60c080e7          	jalr	1548(ra) # 53bc <fork>
    3db8:	00a92023          	sw	a0,0(s2)
    3dbc:	d94d                	beqz	a0,3d6e <sbrkfail+0x4c>
    if(pids[i] != -1)
    3dbe:	ff4506e3          	beq	a0,s4,3daa <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    3dc2:	4605                	li	a2,1
    3dc4:	faf40593          	addi	a1,s0,-81
    3dc8:	fb042503          	lw	a0,-80(s0)
    3dcc:	00001097          	auipc	ra,0x1
    3dd0:	610080e7          	jalr	1552(ra) # 53dc <read>
    3dd4:	bfd9                	j	3daa <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    3dd6:	6505                	lui	a0,0x1
    3dd8:	00001097          	auipc	ra,0x1
    3ddc:	674080e7          	jalr	1652(ra) # 544c <sbrk>
    3de0:	892a                	mv	s2,a0
    if(pids[i] == -1)
    3de2:	5a7d                	li	s4,-1
    3de4:	a021                	j	3dec <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3de6:	0491                	addi	s1,s1,4
    3de8:	01348f63          	beq	s1,s3,3e06 <sbrkfail+0xe4>
    if(pids[i] == -1)
    3dec:	4088                	lw	a0,0(s1)
    3dee:	ff450ce3          	beq	a0,s4,3de6 <sbrkfail+0xc4>
    kill(pids[i]);
    3df2:	00001097          	auipc	ra,0x1
    3df6:	602080e7          	jalr	1538(ra) # 53f4 <kill>
    wait(0);
    3dfa:	4501                	li	a0,0
    3dfc:	00001097          	auipc	ra,0x1
    3e00:	5d0080e7          	jalr	1488(ra) # 53cc <wait>
    3e04:	b7cd                	j	3de6 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    3e06:	57fd                	li	a5,-1
    3e08:	04f90163          	beq	s2,a5,3e4a <sbrkfail+0x128>
  pid = fork();
    3e0c:	00001097          	auipc	ra,0x1
    3e10:	5b0080e7          	jalr	1456(ra) # 53bc <fork>
    3e14:	84aa                	mv	s1,a0
  if(pid < 0){
    3e16:	04054863          	bltz	a0,3e66 <sbrkfail+0x144>
  if(pid == 0){
    3e1a:	c525                	beqz	a0,3e82 <sbrkfail+0x160>
  wait(&xstatus);
    3e1c:	fbc40513          	addi	a0,s0,-68
    3e20:	00001097          	auipc	ra,0x1
    3e24:	5ac080e7          	jalr	1452(ra) # 53cc <wait>
  if(xstatus != -1 && xstatus != 2)
    3e28:	fbc42783          	lw	a5,-68(s0)
    3e2c:	577d                	li	a4,-1
    3e2e:	00e78563          	beq	a5,a4,3e38 <sbrkfail+0x116>
    3e32:	4709                	li	a4,2
    3e34:	08e79c63          	bne	a5,a4,3ecc <sbrkfail+0x1aa>
}
    3e38:	70e6                	ld	ra,120(sp)
    3e3a:	7446                	ld	s0,112(sp)
    3e3c:	74a6                	ld	s1,104(sp)
    3e3e:	7906                	ld	s2,96(sp)
    3e40:	69e6                	ld	s3,88(sp)
    3e42:	6a46                	ld	s4,80(sp)
    3e44:	6aa6                	ld	s5,72(sp)
    3e46:	6109                	addi	sp,sp,128
    3e48:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3e4a:	85d6                	mv	a1,s5
    3e4c:	00004517          	auipc	a0,0x4
    3e50:	87c50513          	addi	a0,a0,-1924 # 76c8 <malloc+0x1ecc>
    3e54:	00002097          	auipc	ra,0x2
    3e58:	8e8080e7          	jalr	-1816(ra) # 573c <printf>
    exit(1);
    3e5c:	4505                	li	a0,1
    3e5e:	00001097          	auipc	ra,0x1
    3e62:	566080e7          	jalr	1382(ra) # 53c4 <exit>
    printf("%s: fork failed\n", s);
    3e66:	85d6                	mv	a1,s5
    3e68:	00002517          	auipc	a0,0x2
    3e6c:	6b050513          	addi	a0,a0,1712 # 6518 <malloc+0xd1c>
    3e70:	00002097          	auipc	ra,0x2
    3e74:	8cc080e7          	jalr	-1844(ra) # 573c <printf>
    exit(1);
    3e78:	4505                	li	a0,1
    3e7a:	00001097          	auipc	ra,0x1
    3e7e:	54a080e7          	jalr	1354(ra) # 53c4 <exit>
    a = sbrk(0);
    3e82:	4501                	li	a0,0
    3e84:	00001097          	auipc	ra,0x1
    3e88:	5c8080e7          	jalr	1480(ra) # 544c <sbrk>
    3e8c:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3e8e:	3e800537          	lui	a0,0x3e800
    3e92:	00001097          	auipc	ra,0x1
    3e96:	5ba080e7          	jalr	1466(ra) # 544c <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e9a:	874a                	mv	a4,s2
    3e9c:	3e8007b7          	lui	a5,0x3e800
    3ea0:	97ca                	add	a5,a5,s2
    3ea2:	6685                	lui	a3,0x1
      n += *(a+i);
    3ea4:	00074603          	lbu	a2,0(a4)
    3ea8:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3eaa:	9736                	add	a4,a4,a3
    3eac:	fee79ce3          	bne	a5,a4,3ea4 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    3eb0:	85a6                	mv	a1,s1
    3eb2:	00004517          	auipc	a0,0x4
    3eb6:	83650513          	addi	a0,a0,-1994 # 76e8 <malloc+0x1eec>
    3eba:	00002097          	auipc	ra,0x2
    3ebe:	882080e7          	jalr	-1918(ra) # 573c <printf>
    exit(1);
    3ec2:	4505                	li	a0,1
    3ec4:	00001097          	auipc	ra,0x1
    3ec8:	500080e7          	jalr	1280(ra) # 53c4 <exit>
    exit(1);
    3ecc:	4505                	li	a0,1
    3ece:	00001097          	auipc	ra,0x1
    3ed2:	4f6080e7          	jalr	1270(ra) # 53c4 <exit>

0000000000003ed6 <reparent>:
{
    3ed6:	7179                	addi	sp,sp,-48
    3ed8:	f406                	sd	ra,40(sp)
    3eda:	f022                	sd	s0,32(sp)
    3edc:	ec26                	sd	s1,24(sp)
    3ede:	e84a                	sd	s2,16(sp)
    3ee0:	e44e                	sd	s3,8(sp)
    3ee2:	e052                	sd	s4,0(sp)
    3ee4:	1800                	addi	s0,sp,48
    3ee6:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3ee8:	00001097          	auipc	ra,0x1
    3eec:	55c080e7          	jalr	1372(ra) # 5444 <getpid>
    3ef0:	8a2a                	mv	s4,a0
    3ef2:	0c800913          	li	s2,200
    int pid = fork();
    3ef6:	00001097          	auipc	ra,0x1
    3efa:	4c6080e7          	jalr	1222(ra) # 53bc <fork>
    3efe:	84aa                	mv	s1,a0
    if(pid < 0){
    3f00:	02054263          	bltz	a0,3f24 <reparent+0x4e>
    if(pid){
    3f04:	cd21                	beqz	a0,3f5c <reparent+0x86>
      if(wait(0) != pid){
    3f06:	4501                	li	a0,0
    3f08:	00001097          	auipc	ra,0x1
    3f0c:	4c4080e7          	jalr	1220(ra) # 53cc <wait>
    3f10:	02951863          	bne	a0,s1,3f40 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    3f14:	397d                	addiw	s2,s2,-1
    3f16:	fe0910e3          	bnez	s2,3ef6 <reparent+0x20>
  exit(0);
    3f1a:	4501                	li	a0,0
    3f1c:	00001097          	auipc	ra,0x1
    3f20:	4a8080e7          	jalr	1192(ra) # 53c4 <exit>
      printf("%s: fork failed\n", s);
    3f24:	85ce                	mv	a1,s3
    3f26:	00002517          	auipc	a0,0x2
    3f2a:	5f250513          	addi	a0,a0,1522 # 6518 <malloc+0xd1c>
    3f2e:	00002097          	auipc	ra,0x2
    3f32:	80e080e7          	jalr	-2034(ra) # 573c <printf>
      exit(1);
    3f36:	4505                	li	a0,1
    3f38:	00001097          	auipc	ra,0x1
    3f3c:	48c080e7          	jalr	1164(ra) # 53c4 <exit>
        printf("%s: wait wrong pid\n", s);
    3f40:	85ce                	mv	a1,s3
    3f42:	00002517          	auipc	a0,0x2
    3f46:	75e50513          	addi	a0,a0,1886 # 66a0 <malloc+0xea4>
    3f4a:	00001097          	auipc	ra,0x1
    3f4e:	7f2080e7          	jalr	2034(ra) # 573c <printf>
        exit(1);
    3f52:	4505                	li	a0,1
    3f54:	00001097          	auipc	ra,0x1
    3f58:	470080e7          	jalr	1136(ra) # 53c4 <exit>
      int pid2 = fork();
    3f5c:	00001097          	auipc	ra,0x1
    3f60:	460080e7          	jalr	1120(ra) # 53bc <fork>
      if(pid2 < 0){
    3f64:	00054763          	bltz	a0,3f72 <reparent+0x9c>
      exit(0);
    3f68:	4501                	li	a0,0
    3f6a:	00001097          	auipc	ra,0x1
    3f6e:	45a080e7          	jalr	1114(ra) # 53c4 <exit>
        kill(master_pid);
    3f72:	8552                	mv	a0,s4
    3f74:	00001097          	auipc	ra,0x1
    3f78:	480080e7          	jalr	1152(ra) # 53f4 <kill>
        exit(1);
    3f7c:	4505                	li	a0,1
    3f7e:	00001097          	auipc	ra,0x1
    3f82:	446080e7          	jalr	1094(ra) # 53c4 <exit>

0000000000003f86 <mem>:
{
    3f86:	7139                	addi	sp,sp,-64
    3f88:	fc06                	sd	ra,56(sp)
    3f8a:	f822                	sd	s0,48(sp)
    3f8c:	f426                	sd	s1,40(sp)
    3f8e:	f04a                	sd	s2,32(sp)
    3f90:	ec4e                	sd	s3,24(sp)
    3f92:	0080                	addi	s0,sp,64
    3f94:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3f96:	00001097          	auipc	ra,0x1
    3f9a:	426080e7          	jalr	1062(ra) # 53bc <fork>
    m1 = 0;
    3f9e:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3fa0:	6909                	lui	s2,0x2
    3fa2:	71190913          	addi	s2,s2,1809 # 2711 <sbrkarg+0x93>
  if((pid = fork()) == 0){
    3fa6:	e135                	bnez	a0,400a <mem+0x84>
    while((m2 = malloc(10001)) != 0){
    3fa8:	854a                	mv	a0,s2
    3faa:	00002097          	auipc	ra,0x2
    3fae:	852080e7          	jalr	-1966(ra) # 57fc <malloc>
    3fb2:	c501                	beqz	a0,3fba <mem+0x34>
      *(char**)m2 = m1;
    3fb4:	e104                	sd	s1,0(a0)
      m1 = m2;
    3fb6:	84aa                	mv	s1,a0
    3fb8:	bfc5                	j	3fa8 <mem+0x22>
    while(m1){
    3fba:	c899                	beqz	s1,3fd0 <mem+0x4a>
      m2 = *(char**)m1;
    3fbc:	0004b903          	ld	s2,0(s1)
      free(m1);
    3fc0:	8526                	mv	a0,s1
    3fc2:	00001097          	auipc	ra,0x1
    3fc6:	7b0080e7          	jalr	1968(ra) # 5772 <free>
      m1 = m2;
    3fca:	84ca                	mv	s1,s2
    while(m1){
    3fcc:	fe0918e3          	bnez	s2,3fbc <mem+0x36>
    m1 = malloc(1024*20);
    3fd0:	6515                	lui	a0,0x5
    3fd2:	00002097          	auipc	ra,0x2
    3fd6:	82a080e7          	jalr	-2006(ra) # 57fc <malloc>
    if(m1 == 0){
    3fda:	c911                	beqz	a0,3fee <mem+0x68>
    free(m1);
    3fdc:	00001097          	auipc	ra,0x1
    3fe0:	796080e7          	jalr	1942(ra) # 5772 <free>
    exit(0);
    3fe4:	4501                	li	a0,0
    3fe6:	00001097          	auipc	ra,0x1
    3fea:	3de080e7          	jalr	990(ra) # 53c4 <exit>
      printf("couldn't allocate mem?!!\n", s);
    3fee:	85ce                	mv	a1,s3
    3ff0:	00003517          	auipc	a0,0x3
    3ff4:	72850513          	addi	a0,a0,1832 # 7718 <malloc+0x1f1c>
    3ff8:	00001097          	auipc	ra,0x1
    3ffc:	744080e7          	jalr	1860(ra) # 573c <printf>
      exit(1);
    4000:	4505                	li	a0,1
    4002:	00001097          	auipc	ra,0x1
    4006:	3c2080e7          	jalr	962(ra) # 53c4 <exit>
    wait(&xstatus);
    400a:	fcc40513          	addi	a0,s0,-52
    400e:	00001097          	auipc	ra,0x1
    4012:	3be080e7          	jalr	958(ra) # 53cc <wait>
    if(xstatus == -1){
    4016:	fcc42503          	lw	a0,-52(s0)
    401a:	57fd                	li	a5,-1
    401c:	00f50663          	beq	a0,a5,4028 <mem+0xa2>
    exit(xstatus);
    4020:	00001097          	auipc	ra,0x1
    4024:	3a4080e7          	jalr	932(ra) # 53c4 <exit>
      exit(0);
    4028:	4501                	li	a0,0
    402a:	00001097          	auipc	ra,0x1
    402e:	39a080e7          	jalr	922(ra) # 53c4 <exit>

0000000000004032 <sharedfd>:
{
    4032:	7159                	addi	sp,sp,-112
    4034:	f486                	sd	ra,104(sp)
    4036:	f0a2                	sd	s0,96(sp)
    4038:	eca6                	sd	s1,88(sp)
    403a:	e8ca                	sd	s2,80(sp)
    403c:	e4ce                	sd	s3,72(sp)
    403e:	e0d2                	sd	s4,64(sp)
    4040:	fc56                	sd	s5,56(sp)
    4042:	f85a                	sd	s6,48(sp)
    4044:	f45e                	sd	s7,40(sp)
    4046:	1880                	addi	s0,sp,112
    4048:	89aa                	mv	s3,a0
  unlink("sharedfd");
    404a:	00003517          	auipc	a0,0x3
    404e:	6ee50513          	addi	a0,a0,1774 # 7738 <malloc+0x1f3c>
    4052:	00001097          	auipc	ra,0x1
    4056:	3c2080e7          	jalr	962(ra) # 5414 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    405a:	20200593          	li	a1,514
    405e:	00003517          	auipc	a0,0x3
    4062:	6da50513          	addi	a0,a0,1754 # 7738 <malloc+0x1f3c>
    4066:	00001097          	auipc	ra,0x1
    406a:	39e080e7          	jalr	926(ra) # 5404 <open>
  if(fd < 0){
    406e:	04054a63          	bltz	a0,40c2 <sharedfd+0x90>
    4072:	892a                	mv	s2,a0
  pid = fork();
    4074:	00001097          	auipc	ra,0x1
    4078:	348080e7          	jalr	840(ra) # 53bc <fork>
    407c:	8a2a                	mv	s4,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    407e:	06300593          	li	a1,99
    4082:	c119                	beqz	a0,4088 <sharedfd+0x56>
    4084:	07000593          	li	a1,112
    4088:	4629                	li	a2,10
    408a:	fa040513          	addi	a0,s0,-96
    408e:	00001097          	auipc	ra,0x1
    4092:	120080e7          	jalr	288(ra) # 51ae <memset>
    4096:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    409a:	4629                	li	a2,10
    409c:	fa040593          	addi	a1,s0,-96
    40a0:	854a                	mv	a0,s2
    40a2:	00001097          	auipc	ra,0x1
    40a6:	342080e7          	jalr	834(ra) # 53e4 <write>
    40aa:	47a9                	li	a5,10
    40ac:	02f51963          	bne	a0,a5,40de <sharedfd+0xac>
  for(i = 0; i < N; i++){
    40b0:	34fd                	addiw	s1,s1,-1
    40b2:	f4e5                	bnez	s1,409a <sharedfd+0x68>
  if(pid == 0) {
    40b4:	040a1363          	bnez	s4,40fa <sharedfd+0xc8>
    exit(0);
    40b8:	4501                	li	a0,0
    40ba:	00001097          	auipc	ra,0x1
    40be:	30a080e7          	jalr	778(ra) # 53c4 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    40c2:	85ce                	mv	a1,s3
    40c4:	00003517          	auipc	a0,0x3
    40c8:	68450513          	addi	a0,a0,1668 # 7748 <malloc+0x1f4c>
    40cc:	00001097          	auipc	ra,0x1
    40d0:	670080e7          	jalr	1648(ra) # 573c <printf>
    exit(1);
    40d4:	4505                	li	a0,1
    40d6:	00001097          	auipc	ra,0x1
    40da:	2ee080e7          	jalr	750(ra) # 53c4 <exit>
      printf("%s: write sharedfd failed\n", s);
    40de:	85ce                	mv	a1,s3
    40e0:	00003517          	auipc	a0,0x3
    40e4:	69050513          	addi	a0,a0,1680 # 7770 <malloc+0x1f74>
    40e8:	00001097          	auipc	ra,0x1
    40ec:	654080e7          	jalr	1620(ra) # 573c <printf>
      exit(1);
    40f0:	4505                	li	a0,1
    40f2:	00001097          	auipc	ra,0x1
    40f6:	2d2080e7          	jalr	722(ra) # 53c4 <exit>
    wait(&xstatus);
    40fa:	f9c40513          	addi	a0,s0,-100
    40fe:	00001097          	auipc	ra,0x1
    4102:	2ce080e7          	jalr	718(ra) # 53cc <wait>
    if(xstatus != 0)
    4106:	f9c42a03          	lw	s4,-100(s0)
    410a:	000a0763          	beqz	s4,4118 <sharedfd+0xe6>
      exit(xstatus);
    410e:	8552                	mv	a0,s4
    4110:	00001097          	auipc	ra,0x1
    4114:	2b4080e7          	jalr	692(ra) # 53c4 <exit>
  close(fd);
    4118:	854a                	mv	a0,s2
    411a:	00001097          	auipc	ra,0x1
    411e:	2d2080e7          	jalr	722(ra) # 53ec <close>
  fd = open("sharedfd", 0);
    4122:	4581                	li	a1,0
    4124:	00003517          	auipc	a0,0x3
    4128:	61450513          	addi	a0,a0,1556 # 7738 <malloc+0x1f3c>
    412c:	00001097          	auipc	ra,0x1
    4130:	2d8080e7          	jalr	728(ra) # 5404 <open>
    4134:	8baa                	mv	s7,a0
  nc = np = 0;
    4136:	8ad2                	mv	s5,s4
  if(fd < 0){
    4138:	02054563          	bltz	a0,4162 <sharedfd+0x130>
    413c:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4140:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4144:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4148:	4629                	li	a2,10
    414a:	fa040593          	addi	a1,s0,-96
    414e:	855e                	mv	a0,s7
    4150:	00001097          	auipc	ra,0x1
    4154:	28c080e7          	jalr	652(ra) # 53dc <read>
    4158:	02a05f63          	blez	a0,4196 <sharedfd+0x164>
    415c:	fa040793          	addi	a5,s0,-96
    4160:	a01d                	j	4186 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4162:	85ce                	mv	a1,s3
    4164:	00003517          	auipc	a0,0x3
    4168:	62c50513          	addi	a0,a0,1580 # 7790 <malloc+0x1f94>
    416c:	00001097          	auipc	ra,0x1
    4170:	5d0080e7          	jalr	1488(ra) # 573c <printf>
    exit(1);
    4174:	4505                	li	a0,1
    4176:	00001097          	auipc	ra,0x1
    417a:	24e080e7          	jalr	590(ra) # 53c4 <exit>
        nc++;
    417e:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    4180:	0785                	addi	a5,a5,1
    4182:	fd2783e3          	beq	a5,s2,4148 <sharedfd+0x116>
      if(buf[i] == 'c')
    4186:	0007c703          	lbu	a4,0(a5) # 3e800000 <_end+0x3e7f1868>
    418a:	fe970ae3          	beq	a4,s1,417e <sharedfd+0x14c>
      if(buf[i] == 'p')
    418e:	ff6719e3          	bne	a4,s6,4180 <sharedfd+0x14e>
        np++;
    4192:	2a85                	addiw	s5,s5,1
    4194:	b7f5                	j	4180 <sharedfd+0x14e>
  close(fd);
    4196:	855e                	mv	a0,s7
    4198:	00001097          	auipc	ra,0x1
    419c:	254080e7          	jalr	596(ra) # 53ec <close>
  unlink("sharedfd");
    41a0:	00003517          	auipc	a0,0x3
    41a4:	59850513          	addi	a0,a0,1432 # 7738 <malloc+0x1f3c>
    41a8:	00001097          	auipc	ra,0x1
    41ac:	26c080e7          	jalr	620(ra) # 5414 <unlink>
  if(nc == N*SZ && np == N*SZ){
    41b0:	6789                	lui	a5,0x2
    41b2:	71078793          	addi	a5,a5,1808 # 2710 <sbrkarg+0x92>
    41b6:	00fa1763          	bne	s4,a5,41c4 <sharedfd+0x192>
    41ba:	6789                	lui	a5,0x2
    41bc:	71078793          	addi	a5,a5,1808 # 2710 <sbrkarg+0x92>
    41c0:	02fa8063          	beq	s5,a5,41e0 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    41c4:	85ce                	mv	a1,s3
    41c6:	00003517          	auipc	a0,0x3
    41ca:	5f250513          	addi	a0,a0,1522 # 77b8 <malloc+0x1fbc>
    41ce:	00001097          	auipc	ra,0x1
    41d2:	56e080e7          	jalr	1390(ra) # 573c <printf>
    exit(1);
    41d6:	4505                	li	a0,1
    41d8:	00001097          	auipc	ra,0x1
    41dc:	1ec080e7          	jalr	492(ra) # 53c4 <exit>
    exit(0);
    41e0:	4501                	li	a0,0
    41e2:	00001097          	auipc	ra,0x1
    41e6:	1e2080e7          	jalr	482(ra) # 53c4 <exit>

00000000000041ea <fourfiles>:
{
    41ea:	7135                	addi	sp,sp,-160
    41ec:	ed06                	sd	ra,152(sp)
    41ee:	e922                	sd	s0,144(sp)
    41f0:	e526                	sd	s1,136(sp)
    41f2:	e14a                	sd	s2,128(sp)
    41f4:	fcce                	sd	s3,120(sp)
    41f6:	f8d2                	sd	s4,112(sp)
    41f8:	f4d6                	sd	s5,104(sp)
    41fa:	f0da                	sd	s6,96(sp)
    41fc:	ecde                	sd	s7,88(sp)
    41fe:	e8e2                	sd	s8,80(sp)
    4200:	e4e6                	sd	s9,72(sp)
    4202:	e0ea                	sd	s10,64(sp)
    4204:	fc6e                	sd	s11,56(sp)
    4206:	1100                	addi	s0,sp,160
    4208:	8d2a                	mv	s10,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    420a:	00003797          	auipc	a5,0x3
    420e:	5c678793          	addi	a5,a5,1478 # 77d0 <malloc+0x1fd4>
    4212:	f6f43823          	sd	a5,-144(s0)
    4216:	00003797          	auipc	a5,0x3
    421a:	5c278793          	addi	a5,a5,1474 # 77d8 <malloc+0x1fdc>
    421e:	f6f43c23          	sd	a5,-136(s0)
    4222:	00003797          	auipc	a5,0x3
    4226:	5be78793          	addi	a5,a5,1470 # 77e0 <malloc+0x1fe4>
    422a:	f8f43023          	sd	a5,-128(s0)
    422e:	00003797          	auipc	a5,0x3
    4232:	5ba78793          	addi	a5,a5,1466 # 77e8 <malloc+0x1fec>
    4236:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    423a:	f7040b13          	addi	s6,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    423e:	895a                	mv	s2,s6
  for(pi = 0; pi < NCHILD; pi++){
    4240:	4481                	li	s1,0
    4242:	4a11                	li	s4,4
    fname = names[pi];
    4244:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4248:	854e                	mv	a0,s3
    424a:	00001097          	auipc	ra,0x1
    424e:	1ca080e7          	jalr	458(ra) # 5414 <unlink>
    pid = fork();
    4252:	00001097          	auipc	ra,0x1
    4256:	16a080e7          	jalr	362(ra) # 53bc <fork>
    if(pid < 0){
    425a:	04054063          	bltz	a0,429a <fourfiles+0xb0>
    if(pid == 0){
    425e:	cd21                	beqz	a0,42b6 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4260:	2485                	addiw	s1,s1,1
    4262:	0921                	addi	s2,s2,8
    4264:	ff4490e3          	bne	s1,s4,4244 <fourfiles+0x5a>
    4268:	4491                	li	s1,4
    wait(&xstatus);
    426a:	f6c40513          	addi	a0,s0,-148
    426e:	00001097          	auipc	ra,0x1
    4272:	15e080e7          	jalr	350(ra) # 53cc <wait>
    if(xstatus != 0)
    4276:	f6c42503          	lw	a0,-148(s0)
    427a:	e961                	bnez	a0,434a <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    427c:	34fd                	addiw	s1,s1,-1
    427e:	f4f5                	bnez	s1,426a <fourfiles+0x80>
    4280:	03000a93          	li	s5,48
    total = 0;
    4284:	8daa                	mv	s11,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4286:	00007997          	auipc	s3,0x7
    428a:	50298993          	addi	s3,s3,1282 # b788 <buf>
    if(total != N*SZ){
    428e:	6c05                	lui	s8,0x1
    4290:	770c0c13          	addi	s8,s8,1904 # 1770 <pipe1+0x16>
  for(i = 0; i < NCHILD; i++){
    4294:	03400c93          	li	s9,52
    4298:	aa15                	j	43cc <fourfiles+0x1e2>
      printf("fork failed\n", s);
    429a:	85ea                	mv	a1,s10
    429c:	00002517          	auipc	a0,0x2
    42a0:	66c50513          	addi	a0,a0,1644 # 6908 <malloc+0x110c>
    42a4:	00001097          	auipc	ra,0x1
    42a8:	498080e7          	jalr	1176(ra) # 573c <printf>
      exit(1);
    42ac:	4505                	li	a0,1
    42ae:	00001097          	auipc	ra,0x1
    42b2:	116080e7          	jalr	278(ra) # 53c4 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    42b6:	20200593          	li	a1,514
    42ba:	854e                	mv	a0,s3
    42bc:	00001097          	auipc	ra,0x1
    42c0:	148080e7          	jalr	328(ra) # 5404 <open>
    42c4:	892a                	mv	s2,a0
      if(fd < 0){
    42c6:	04054663          	bltz	a0,4312 <fourfiles+0x128>
      memset(buf, '0'+pi, SZ);
    42ca:	1f400613          	li	a2,500
    42ce:	0304859b          	addiw	a1,s1,48
    42d2:	00007517          	auipc	a0,0x7
    42d6:	4b650513          	addi	a0,a0,1206 # b788 <buf>
    42da:	00001097          	auipc	ra,0x1
    42de:	ed4080e7          	jalr	-300(ra) # 51ae <memset>
    42e2:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    42e4:	00007997          	auipc	s3,0x7
    42e8:	4a498993          	addi	s3,s3,1188 # b788 <buf>
    42ec:	1f400613          	li	a2,500
    42f0:	85ce                	mv	a1,s3
    42f2:	854a                	mv	a0,s2
    42f4:	00001097          	auipc	ra,0x1
    42f8:	0f0080e7          	jalr	240(ra) # 53e4 <write>
    42fc:	1f400793          	li	a5,500
    4300:	02f51763          	bne	a0,a5,432e <fourfiles+0x144>
      for(i = 0; i < N; i++){
    4304:	34fd                	addiw	s1,s1,-1
    4306:	f0fd                	bnez	s1,42ec <fourfiles+0x102>
      exit(0);
    4308:	4501                	li	a0,0
    430a:	00001097          	auipc	ra,0x1
    430e:	0ba080e7          	jalr	186(ra) # 53c4 <exit>
        printf("create failed\n", s);
    4312:	85ea                	mv	a1,s10
    4314:	00003517          	auipc	a0,0x3
    4318:	4dc50513          	addi	a0,a0,1244 # 77f0 <malloc+0x1ff4>
    431c:	00001097          	auipc	ra,0x1
    4320:	420080e7          	jalr	1056(ra) # 573c <printf>
        exit(1);
    4324:	4505                	li	a0,1
    4326:	00001097          	auipc	ra,0x1
    432a:	09e080e7          	jalr	158(ra) # 53c4 <exit>
          printf("write failed %d\n", n);
    432e:	85aa                	mv	a1,a0
    4330:	00003517          	auipc	a0,0x3
    4334:	4d050513          	addi	a0,a0,1232 # 7800 <malloc+0x2004>
    4338:	00001097          	auipc	ra,0x1
    433c:	404080e7          	jalr	1028(ra) # 573c <printf>
          exit(1);
    4340:	4505                	li	a0,1
    4342:	00001097          	auipc	ra,0x1
    4346:	082080e7          	jalr	130(ra) # 53c4 <exit>
      exit(xstatus);
    434a:	00001097          	auipc	ra,0x1
    434e:	07a080e7          	jalr	122(ra) # 53c4 <exit>
      total += n;
    4352:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4356:	660d                	lui	a2,0x3
    4358:	85ce                	mv	a1,s3
    435a:	8552                	mv	a0,s4
    435c:	00001097          	auipc	ra,0x1
    4360:	080080e7          	jalr	128(ra) # 53dc <read>
    4364:	04a05463          	blez	a0,43ac <fourfiles+0x1c2>
        if(buf[j] != '0'+i){
    4368:	0009c783          	lbu	a5,0(s3)
    436c:	02979263          	bne	a5,s1,4390 <fourfiles+0x1a6>
    4370:	00007797          	auipc	a5,0x7
    4374:	41978793          	addi	a5,a5,1049 # b789 <buf+0x1>
    4378:	fff5069b          	addiw	a3,a0,-1
    437c:	1682                	slli	a3,a3,0x20
    437e:	9281                	srli	a3,a3,0x20
    4380:	96be                	add	a3,a3,a5
      for(j = 0; j < n; j++){
    4382:	fcd788e3          	beq	a5,a3,4352 <fourfiles+0x168>
        if(buf[j] != '0'+i){
    4386:	0007c703          	lbu	a4,0(a5)
    438a:	0785                	addi	a5,a5,1
    438c:	fe970be3          	beq	a4,s1,4382 <fourfiles+0x198>
          printf("wrong char\n", s);
    4390:	85ea                	mv	a1,s10
    4392:	00003517          	auipc	a0,0x3
    4396:	48650513          	addi	a0,a0,1158 # 7818 <malloc+0x201c>
    439a:	00001097          	auipc	ra,0x1
    439e:	3a2080e7          	jalr	930(ra) # 573c <printf>
          exit(1);
    43a2:	4505                	li	a0,1
    43a4:	00001097          	auipc	ra,0x1
    43a8:	020080e7          	jalr	32(ra) # 53c4 <exit>
    close(fd);
    43ac:	8552                	mv	a0,s4
    43ae:	00001097          	auipc	ra,0x1
    43b2:	03e080e7          	jalr	62(ra) # 53ec <close>
    if(total != N*SZ){
    43b6:	03891863          	bne	s2,s8,43e6 <fourfiles+0x1fc>
    unlink(fname);
    43ba:	855e                	mv	a0,s7
    43bc:	00001097          	auipc	ra,0x1
    43c0:	058080e7          	jalr	88(ra) # 5414 <unlink>
  for(i = 0; i < NCHILD; i++){
    43c4:	0b21                	addi	s6,s6,8
    43c6:	2a85                	addiw	s5,s5,1
    43c8:	039a8d63          	beq	s5,s9,4402 <fourfiles+0x218>
    fname = names[i];
    43cc:	000b3b83          	ld	s7,0(s6) # 3000 <subdir+0x2f8>
    fd = open(fname, 0);
    43d0:	4581                	li	a1,0
    43d2:	855e                	mv	a0,s7
    43d4:	00001097          	auipc	ra,0x1
    43d8:	030080e7          	jalr	48(ra) # 5404 <open>
    43dc:	8a2a                	mv	s4,a0
    total = 0;
    43de:	896e                	mv	s2,s11
    43e0:	000a849b          	sext.w	s1,s5
    while((n = read(fd, buf, sizeof(buf))) > 0){
    43e4:	bf8d                	j	4356 <fourfiles+0x16c>
      printf("wrong length %d\n", total);
    43e6:	85ca                	mv	a1,s2
    43e8:	00003517          	auipc	a0,0x3
    43ec:	44050513          	addi	a0,a0,1088 # 7828 <malloc+0x202c>
    43f0:	00001097          	auipc	ra,0x1
    43f4:	34c080e7          	jalr	844(ra) # 573c <printf>
      exit(1);
    43f8:	4505                	li	a0,1
    43fa:	00001097          	auipc	ra,0x1
    43fe:	fca080e7          	jalr	-54(ra) # 53c4 <exit>
}
    4402:	60ea                	ld	ra,152(sp)
    4404:	644a                	ld	s0,144(sp)
    4406:	64aa                	ld	s1,136(sp)
    4408:	690a                	ld	s2,128(sp)
    440a:	79e6                	ld	s3,120(sp)
    440c:	7a46                	ld	s4,112(sp)
    440e:	7aa6                	ld	s5,104(sp)
    4410:	7b06                	ld	s6,96(sp)
    4412:	6be6                	ld	s7,88(sp)
    4414:	6c46                	ld	s8,80(sp)
    4416:	6ca6                	ld	s9,72(sp)
    4418:	6d06                	ld	s10,64(sp)
    441a:	7de2                	ld	s11,56(sp)
    441c:	610d                	addi	sp,sp,160
    441e:	8082                	ret

0000000000004420 <concreate>:
{
    4420:	7135                	addi	sp,sp,-160
    4422:	ed06                	sd	ra,152(sp)
    4424:	e922                	sd	s0,144(sp)
    4426:	e526                	sd	s1,136(sp)
    4428:	e14a                	sd	s2,128(sp)
    442a:	fcce                	sd	s3,120(sp)
    442c:	f8d2                	sd	s4,112(sp)
    442e:	f4d6                	sd	s5,104(sp)
    4430:	f0da                	sd	s6,96(sp)
    4432:	ecde                	sd	s7,88(sp)
    4434:	1100                	addi	s0,sp,160
    4436:	89aa                	mv	s3,a0
  file[0] = 'C';
    4438:	04300793          	li	a5,67
    443c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4440:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4444:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4446:	4b0d                	li	s6,3
    4448:	4a85                	li	s5,1
      link("C0", file);
    444a:	00003b97          	auipc	s7,0x3
    444e:	3f6b8b93          	addi	s7,s7,1014 # 7840 <malloc+0x2044>
  for(i = 0; i < N; i++){
    4452:	02800a13          	li	s4,40
    4456:	acc1                	j	4726 <concreate+0x306>
      link("C0", file);
    4458:	fa840593          	addi	a1,s0,-88
    445c:	855e                	mv	a0,s7
    445e:	00001097          	auipc	ra,0x1
    4462:	fc6080e7          	jalr	-58(ra) # 5424 <link>
    if(pid == 0) {
    4466:	a45d                	j	470c <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4468:	4795                	li	a5,5
    446a:	02f9693b          	remw	s2,s2,a5
    446e:	4785                	li	a5,1
    4470:	02f90b63          	beq	s2,a5,44a6 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4474:	20200593          	li	a1,514
    4478:	fa840513          	addi	a0,s0,-88
    447c:	00001097          	auipc	ra,0x1
    4480:	f88080e7          	jalr	-120(ra) # 5404 <open>
      if(fd < 0){
    4484:	26055b63          	bgez	a0,46fa <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4488:	fa840593          	addi	a1,s0,-88
    448c:	00003517          	auipc	a0,0x3
    4490:	3bc50513          	addi	a0,a0,956 # 7848 <malloc+0x204c>
    4494:	00001097          	auipc	ra,0x1
    4498:	2a8080e7          	jalr	680(ra) # 573c <printf>
        exit(1);
    449c:	4505                	li	a0,1
    449e:	00001097          	auipc	ra,0x1
    44a2:	f26080e7          	jalr	-218(ra) # 53c4 <exit>
      link("C0", file);
    44a6:	fa840593          	addi	a1,s0,-88
    44aa:	00003517          	auipc	a0,0x3
    44ae:	39650513          	addi	a0,a0,918 # 7840 <malloc+0x2044>
    44b2:	00001097          	auipc	ra,0x1
    44b6:	f72080e7          	jalr	-142(ra) # 5424 <link>
      exit(0);
    44ba:	4501                	li	a0,0
    44bc:	00001097          	auipc	ra,0x1
    44c0:	f08080e7          	jalr	-248(ra) # 53c4 <exit>
        exit(1);
    44c4:	4505                	li	a0,1
    44c6:	00001097          	auipc	ra,0x1
    44ca:	efe080e7          	jalr	-258(ra) # 53c4 <exit>
  memset(fa, 0, sizeof(fa));
    44ce:	02800613          	li	a2,40
    44d2:	4581                	li	a1,0
    44d4:	f8040513          	addi	a0,s0,-128
    44d8:	00001097          	auipc	ra,0x1
    44dc:	cd6080e7          	jalr	-810(ra) # 51ae <memset>
  fd = open(".", 0);
    44e0:	4581                	li	a1,0
    44e2:	00002517          	auipc	a0,0x2
    44e6:	e9650513          	addi	a0,a0,-362 # 6378 <malloc+0xb7c>
    44ea:	00001097          	auipc	ra,0x1
    44ee:	f1a080e7          	jalr	-230(ra) # 5404 <open>
    44f2:	892a                	mv	s2,a0
  n = 0;
    44f4:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    44f6:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    44fa:	02700b13          	li	s6,39
      fa[i] = 1;
    44fe:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4500:	4641                	li	a2,16
    4502:	f7040593          	addi	a1,s0,-144
    4506:	854a                	mv	a0,s2
    4508:	00001097          	auipc	ra,0x1
    450c:	ed4080e7          	jalr	-300(ra) # 53dc <read>
    4510:	08a05163          	blez	a0,4592 <concreate+0x172>
    if(de.inum == 0)
    4514:	f7045783          	lhu	a5,-144(s0)
    4518:	d7e5                	beqz	a5,4500 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    451a:	f7244783          	lbu	a5,-142(s0)
    451e:	ff4791e3          	bne	a5,s4,4500 <concreate+0xe0>
    4522:	f7444783          	lbu	a5,-140(s0)
    4526:	ffe9                	bnez	a5,4500 <concreate+0xe0>
      i = de.name[1] - '0';
    4528:	f7344783          	lbu	a5,-141(s0)
    452c:	fd07879b          	addiw	a5,a5,-48
    4530:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4534:	00eb6f63          	bltu	s6,a4,4552 <concreate+0x132>
      if(fa[i]){
    4538:	fb040793          	addi	a5,s0,-80
    453c:	97ba                	add	a5,a5,a4
    453e:	fd07c783          	lbu	a5,-48(a5)
    4542:	eb85                	bnez	a5,4572 <concreate+0x152>
      fa[i] = 1;
    4544:	fb040793          	addi	a5,s0,-80
    4548:	973e                	add	a4,a4,a5
    454a:	fd770823          	sb	s7,-48(a4)
      n++;
    454e:	2a85                	addiw	s5,s5,1
    4550:	bf45                	j	4500 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4552:	f7240613          	addi	a2,s0,-142
    4556:	85ce                	mv	a1,s3
    4558:	00003517          	auipc	a0,0x3
    455c:	31050513          	addi	a0,a0,784 # 7868 <malloc+0x206c>
    4560:	00001097          	auipc	ra,0x1
    4564:	1dc080e7          	jalr	476(ra) # 573c <printf>
        exit(1);
    4568:	4505                	li	a0,1
    456a:	00001097          	auipc	ra,0x1
    456e:	e5a080e7          	jalr	-422(ra) # 53c4 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4572:	f7240613          	addi	a2,s0,-142
    4576:	85ce                	mv	a1,s3
    4578:	00003517          	auipc	a0,0x3
    457c:	31050513          	addi	a0,a0,784 # 7888 <malloc+0x208c>
    4580:	00001097          	auipc	ra,0x1
    4584:	1bc080e7          	jalr	444(ra) # 573c <printf>
        exit(1);
    4588:	4505                	li	a0,1
    458a:	00001097          	auipc	ra,0x1
    458e:	e3a080e7          	jalr	-454(ra) # 53c4 <exit>
  close(fd);
    4592:	854a                	mv	a0,s2
    4594:	00001097          	auipc	ra,0x1
    4598:	e58080e7          	jalr	-424(ra) # 53ec <close>
  if(n != N){
    459c:	02800793          	li	a5,40
    45a0:	00fa9763          	bne	s5,a5,45ae <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    45a4:	4a8d                	li	s5,3
    45a6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    45a8:	02800a13          	li	s4,40
    45ac:	a8c9                	j	467e <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    45ae:	85ce                	mv	a1,s3
    45b0:	00003517          	auipc	a0,0x3
    45b4:	30050513          	addi	a0,a0,768 # 78b0 <malloc+0x20b4>
    45b8:	00001097          	auipc	ra,0x1
    45bc:	184080e7          	jalr	388(ra) # 573c <printf>
    exit(1);
    45c0:	4505                	li	a0,1
    45c2:	00001097          	auipc	ra,0x1
    45c6:	e02080e7          	jalr	-510(ra) # 53c4 <exit>
      printf("%s: fork failed\n", s);
    45ca:	85ce                	mv	a1,s3
    45cc:	00002517          	auipc	a0,0x2
    45d0:	f4c50513          	addi	a0,a0,-180 # 6518 <malloc+0xd1c>
    45d4:	00001097          	auipc	ra,0x1
    45d8:	168080e7          	jalr	360(ra) # 573c <printf>
      exit(1);
    45dc:	4505                	li	a0,1
    45de:	00001097          	auipc	ra,0x1
    45e2:	de6080e7          	jalr	-538(ra) # 53c4 <exit>
      close(open(file, 0));
    45e6:	4581                	li	a1,0
    45e8:	fa840513          	addi	a0,s0,-88
    45ec:	00001097          	auipc	ra,0x1
    45f0:	e18080e7          	jalr	-488(ra) # 5404 <open>
    45f4:	00001097          	auipc	ra,0x1
    45f8:	df8080e7          	jalr	-520(ra) # 53ec <close>
      close(open(file, 0));
    45fc:	4581                	li	a1,0
    45fe:	fa840513          	addi	a0,s0,-88
    4602:	00001097          	auipc	ra,0x1
    4606:	e02080e7          	jalr	-510(ra) # 5404 <open>
    460a:	00001097          	auipc	ra,0x1
    460e:	de2080e7          	jalr	-542(ra) # 53ec <close>
      close(open(file, 0));
    4612:	4581                	li	a1,0
    4614:	fa840513          	addi	a0,s0,-88
    4618:	00001097          	auipc	ra,0x1
    461c:	dec080e7          	jalr	-532(ra) # 5404 <open>
    4620:	00001097          	auipc	ra,0x1
    4624:	dcc080e7          	jalr	-564(ra) # 53ec <close>
      close(open(file, 0));
    4628:	4581                	li	a1,0
    462a:	fa840513          	addi	a0,s0,-88
    462e:	00001097          	auipc	ra,0x1
    4632:	dd6080e7          	jalr	-554(ra) # 5404 <open>
    4636:	00001097          	auipc	ra,0x1
    463a:	db6080e7          	jalr	-586(ra) # 53ec <close>
      close(open(file, 0));
    463e:	4581                	li	a1,0
    4640:	fa840513          	addi	a0,s0,-88
    4644:	00001097          	auipc	ra,0x1
    4648:	dc0080e7          	jalr	-576(ra) # 5404 <open>
    464c:	00001097          	auipc	ra,0x1
    4650:	da0080e7          	jalr	-608(ra) # 53ec <close>
      close(open(file, 0));
    4654:	4581                	li	a1,0
    4656:	fa840513          	addi	a0,s0,-88
    465a:	00001097          	auipc	ra,0x1
    465e:	daa080e7          	jalr	-598(ra) # 5404 <open>
    4662:	00001097          	auipc	ra,0x1
    4666:	d8a080e7          	jalr	-630(ra) # 53ec <close>
    if(pid == 0)
    466a:	08090363          	beqz	s2,46f0 <concreate+0x2d0>
      wait(0);
    466e:	4501                	li	a0,0
    4670:	00001097          	auipc	ra,0x1
    4674:	d5c080e7          	jalr	-676(ra) # 53cc <wait>
  for(i = 0; i < N; i++){
    4678:	2485                	addiw	s1,s1,1
    467a:	0f448563          	beq	s1,s4,4764 <concreate+0x344>
    file[1] = '0' + i;
    467e:	0304879b          	addiw	a5,s1,48
    4682:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4686:	00001097          	auipc	ra,0x1
    468a:	d36080e7          	jalr	-714(ra) # 53bc <fork>
    468e:	892a                	mv	s2,a0
    if(pid < 0){
    4690:	f2054de3          	bltz	a0,45ca <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4694:	0354e73b          	remw	a4,s1,s5
    4698:	00a767b3          	or	a5,a4,a0
    469c:	2781                	sext.w	a5,a5
    469e:	d7a1                	beqz	a5,45e6 <concreate+0x1c6>
    46a0:	01671363          	bne	a4,s6,46a6 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    46a4:	f129                	bnez	a0,45e6 <concreate+0x1c6>
      unlink(file);
    46a6:	fa840513          	addi	a0,s0,-88
    46aa:	00001097          	auipc	ra,0x1
    46ae:	d6a080e7          	jalr	-662(ra) # 5414 <unlink>
      unlink(file);
    46b2:	fa840513          	addi	a0,s0,-88
    46b6:	00001097          	auipc	ra,0x1
    46ba:	d5e080e7          	jalr	-674(ra) # 5414 <unlink>
      unlink(file);
    46be:	fa840513          	addi	a0,s0,-88
    46c2:	00001097          	auipc	ra,0x1
    46c6:	d52080e7          	jalr	-686(ra) # 5414 <unlink>
      unlink(file);
    46ca:	fa840513          	addi	a0,s0,-88
    46ce:	00001097          	auipc	ra,0x1
    46d2:	d46080e7          	jalr	-698(ra) # 5414 <unlink>
      unlink(file);
    46d6:	fa840513          	addi	a0,s0,-88
    46da:	00001097          	auipc	ra,0x1
    46de:	d3a080e7          	jalr	-710(ra) # 5414 <unlink>
      unlink(file);
    46e2:	fa840513          	addi	a0,s0,-88
    46e6:	00001097          	auipc	ra,0x1
    46ea:	d2e080e7          	jalr	-722(ra) # 5414 <unlink>
    46ee:	bfb5                	j	466a <concreate+0x24a>
      exit(0);
    46f0:	4501                	li	a0,0
    46f2:	00001097          	auipc	ra,0x1
    46f6:	cd2080e7          	jalr	-814(ra) # 53c4 <exit>
      close(fd);
    46fa:	00001097          	auipc	ra,0x1
    46fe:	cf2080e7          	jalr	-782(ra) # 53ec <close>
    if(pid == 0) {
    4702:	bb65                	j	44ba <concreate+0x9a>
      close(fd);
    4704:	00001097          	auipc	ra,0x1
    4708:	ce8080e7          	jalr	-792(ra) # 53ec <close>
      wait(&xstatus);
    470c:	f6c40513          	addi	a0,s0,-148
    4710:	00001097          	auipc	ra,0x1
    4714:	cbc080e7          	jalr	-836(ra) # 53cc <wait>
      if(xstatus != 0)
    4718:	f6c42483          	lw	s1,-148(s0)
    471c:	da0494e3          	bnez	s1,44c4 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4720:	2905                	addiw	s2,s2,1
    4722:	db4906e3          	beq	s2,s4,44ce <concreate+0xae>
    file[1] = '0' + i;
    4726:	0309079b          	addiw	a5,s2,48
    472a:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    472e:	fa840513          	addi	a0,s0,-88
    4732:	00001097          	auipc	ra,0x1
    4736:	ce2080e7          	jalr	-798(ra) # 5414 <unlink>
    pid = fork();
    473a:	00001097          	auipc	ra,0x1
    473e:	c82080e7          	jalr	-894(ra) # 53bc <fork>
    if(pid && (i % 3) == 1){
    4742:	d20503e3          	beqz	a0,4468 <concreate+0x48>
    4746:	036967bb          	remw	a5,s2,s6
    474a:	d15787e3          	beq	a5,s5,4458 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    474e:	20200593          	li	a1,514
    4752:	fa840513          	addi	a0,s0,-88
    4756:	00001097          	auipc	ra,0x1
    475a:	cae080e7          	jalr	-850(ra) # 5404 <open>
      if(fd < 0){
    475e:	fa0553e3          	bgez	a0,4704 <concreate+0x2e4>
    4762:	b31d                	j	4488 <concreate+0x68>
}
    4764:	60ea                	ld	ra,152(sp)
    4766:	644a                	ld	s0,144(sp)
    4768:	64aa                	ld	s1,136(sp)
    476a:	690a                	ld	s2,128(sp)
    476c:	79e6                	ld	s3,120(sp)
    476e:	7a46                	ld	s4,112(sp)
    4770:	7aa6                	ld	s5,104(sp)
    4772:	7b06                	ld	s6,96(sp)
    4774:	6be6                	ld	s7,88(sp)
    4776:	610d                	addi	sp,sp,160
    4778:	8082                	ret

000000000000477a <bigfile>:
{
    477a:	7139                	addi	sp,sp,-64
    477c:	fc06                	sd	ra,56(sp)
    477e:	f822                	sd	s0,48(sp)
    4780:	f426                	sd	s1,40(sp)
    4782:	f04a                	sd	s2,32(sp)
    4784:	ec4e                	sd	s3,24(sp)
    4786:	e852                	sd	s4,16(sp)
    4788:	e456                	sd	s5,8(sp)
    478a:	0080                	addi	s0,sp,64
    478c:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    478e:	00003517          	auipc	a0,0x3
    4792:	15a50513          	addi	a0,a0,346 # 78e8 <malloc+0x20ec>
    4796:	00001097          	auipc	ra,0x1
    479a:	c7e080e7          	jalr	-898(ra) # 5414 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    479e:	20200593          	li	a1,514
    47a2:	00003517          	auipc	a0,0x3
    47a6:	14650513          	addi	a0,a0,326 # 78e8 <malloc+0x20ec>
    47aa:	00001097          	auipc	ra,0x1
    47ae:	c5a080e7          	jalr	-934(ra) # 5404 <open>
    47b2:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    47b4:	4481                	li	s1,0
    memset(buf, i, SZ);
    47b6:	00007917          	auipc	s2,0x7
    47ba:	fd290913          	addi	s2,s2,-46 # b788 <buf>
  for(i = 0; i < N; i++){
    47be:	4a51                	li	s4,20
  if(fd < 0){
    47c0:	0a054063          	bltz	a0,4860 <bigfile+0xe6>
    memset(buf, i, SZ);
    47c4:	25800613          	li	a2,600
    47c8:	85a6                	mv	a1,s1
    47ca:	854a                	mv	a0,s2
    47cc:	00001097          	auipc	ra,0x1
    47d0:	9e2080e7          	jalr	-1566(ra) # 51ae <memset>
    if(write(fd, buf, SZ) != SZ){
    47d4:	25800613          	li	a2,600
    47d8:	85ca                	mv	a1,s2
    47da:	854e                	mv	a0,s3
    47dc:	00001097          	auipc	ra,0x1
    47e0:	c08080e7          	jalr	-1016(ra) # 53e4 <write>
    47e4:	25800793          	li	a5,600
    47e8:	08f51a63          	bne	a0,a5,487c <bigfile+0x102>
  for(i = 0; i < N; i++){
    47ec:	2485                	addiw	s1,s1,1
    47ee:	fd449be3          	bne	s1,s4,47c4 <bigfile+0x4a>
  close(fd);
    47f2:	854e                	mv	a0,s3
    47f4:	00001097          	auipc	ra,0x1
    47f8:	bf8080e7          	jalr	-1032(ra) # 53ec <close>
  fd = open("bigfile.dat", 0);
    47fc:	4581                	li	a1,0
    47fe:	00003517          	auipc	a0,0x3
    4802:	0ea50513          	addi	a0,a0,234 # 78e8 <malloc+0x20ec>
    4806:	00001097          	auipc	ra,0x1
    480a:	bfe080e7          	jalr	-1026(ra) # 5404 <open>
    480e:	8a2a                	mv	s4,a0
  total = 0;
    4810:	4981                	li	s3,0
  for(i = 0; ; i++){
    4812:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4814:	00007917          	auipc	s2,0x7
    4818:	f7490913          	addi	s2,s2,-140 # b788 <buf>
  if(fd < 0){
    481c:	06054e63          	bltz	a0,4898 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4820:	12c00613          	li	a2,300
    4824:	85ca                	mv	a1,s2
    4826:	8552                	mv	a0,s4
    4828:	00001097          	auipc	ra,0x1
    482c:	bb4080e7          	jalr	-1100(ra) # 53dc <read>
    if(cc < 0){
    4830:	08054263          	bltz	a0,48b4 <bigfile+0x13a>
    if(cc == 0)
    4834:	c971                	beqz	a0,4908 <bigfile+0x18e>
    if(cc != SZ/2){
    4836:	12c00793          	li	a5,300
    483a:	08f51b63          	bne	a0,a5,48d0 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    483e:	01f4d79b          	srliw	a5,s1,0x1f
    4842:	9fa5                	addw	a5,a5,s1
    4844:	4017d79b          	sraiw	a5,a5,0x1
    4848:	00094703          	lbu	a4,0(s2)
    484c:	0af71063          	bne	a4,a5,48ec <bigfile+0x172>
    4850:	12b94703          	lbu	a4,299(s2)
    4854:	08f71c63          	bne	a4,a5,48ec <bigfile+0x172>
    total += cc;
    4858:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    485c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    485e:	b7c9                	j	4820 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4860:	85d6                	mv	a1,s5
    4862:	00003517          	auipc	a0,0x3
    4866:	09650513          	addi	a0,a0,150 # 78f8 <malloc+0x20fc>
    486a:	00001097          	auipc	ra,0x1
    486e:	ed2080e7          	jalr	-302(ra) # 573c <printf>
    exit(1);
    4872:	4505                	li	a0,1
    4874:	00001097          	auipc	ra,0x1
    4878:	b50080e7          	jalr	-1200(ra) # 53c4 <exit>
      printf("%s: write bigfile failed\n", s);
    487c:	85d6                	mv	a1,s5
    487e:	00003517          	auipc	a0,0x3
    4882:	09a50513          	addi	a0,a0,154 # 7918 <malloc+0x211c>
    4886:	00001097          	auipc	ra,0x1
    488a:	eb6080e7          	jalr	-330(ra) # 573c <printf>
      exit(1);
    488e:	4505                	li	a0,1
    4890:	00001097          	auipc	ra,0x1
    4894:	b34080e7          	jalr	-1228(ra) # 53c4 <exit>
    printf("%s: cannot open bigfile\n", s);
    4898:	85d6                	mv	a1,s5
    489a:	00003517          	auipc	a0,0x3
    489e:	09e50513          	addi	a0,a0,158 # 7938 <malloc+0x213c>
    48a2:	00001097          	auipc	ra,0x1
    48a6:	e9a080e7          	jalr	-358(ra) # 573c <printf>
    exit(1);
    48aa:	4505                	li	a0,1
    48ac:	00001097          	auipc	ra,0x1
    48b0:	b18080e7          	jalr	-1256(ra) # 53c4 <exit>
      printf("%s: read bigfile failed\n", s);
    48b4:	85d6                	mv	a1,s5
    48b6:	00003517          	auipc	a0,0x3
    48ba:	0a250513          	addi	a0,a0,162 # 7958 <malloc+0x215c>
    48be:	00001097          	auipc	ra,0x1
    48c2:	e7e080e7          	jalr	-386(ra) # 573c <printf>
      exit(1);
    48c6:	4505                	li	a0,1
    48c8:	00001097          	auipc	ra,0x1
    48cc:	afc080e7          	jalr	-1284(ra) # 53c4 <exit>
      printf("%s: short read bigfile\n", s);
    48d0:	85d6                	mv	a1,s5
    48d2:	00003517          	auipc	a0,0x3
    48d6:	0a650513          	addi	a0,a0,166 # 7978 <malloc+0x217c>
    48da:	00001097          	auipc	ra,0x1
    48de:	e62080e7          	jalr	-414(ra) # 573c <printf>
      exit(1);
    48e2:	4505                	li	a0,1
    48e4:	00001097          	auipc	ra,0x1
    48e8:	ae0080e7          	jalr	-1312(ra) # 53c4 <exit>
      printf("%s: read bigfile wrong data\n", s);
    48ec:	85d6                	mv	a1,s5
    48ee:	00003517          	auipc	a0,0x3
    48f2:	0a250513          	addi	a0,a0,162 # 7990 <malloc+0x2194>
    48f6:	00001097          	auipc	ra,0x1
    48fa:	e46080e7          	jalr	-442(ra) # 573c <printf>
      exit(1);
    48fe:	4505                	li	a0,1
    4900:	00001097          	auipc	ra,0x1
    4904:	ac4080e7          	jalr	-1340(ra) # 53c4 <exit>
  close(fd);
    4908:	8552                	mv	a0,s4
    490a:	00001097          	auipc	ra,0x1
    490e:	ae2080e7          	jalr	-1310(ra) # 53ec <close>
  if(total != N*SZ){
    4912:	678d                	lui	a5,0x3
    4914:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x1d8>
    4918:	02f99363          	bne	s3,a5,493e <bigfile+0x1c4>
  unlink("bigfile.dat");
    491c:	00003517          	auipc	a0,0x3
    4920:	fcc50513          	addi	a0,a0,-52 # 78e8 <malloc+0x20ec>
    4924:	00001097          	auipc	ra,0x1
    4928:	af0080e7          	jalr	-1296(ra) # 5414 <unlink>
}
    492c:	70e2                	ld	ra,56(sp)
    492e:	7442                	ld	s0,48(sp)
    4930:	74a2                	ld	s1,40(sp)
    4932:	7902                	ld	s2,32(sp)
    4934:	69e2                	ld	s3,24(sp)
    4936:	6a42                	ld	s4,16(sp)
    4938:	6aa2                	ld	s5,8(sp)
    493a:	6121                	addi	sp,sp,64
    493c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    493e:	85d6                	mv	a1,s5
    4940:	00003517          	auipc	a0,0x3
    4944:	07050513          	addi	a0,a0,112 # 79b0 <malloc+0x21b4>
    4948:	00001097          	auipc	ra,0x1
    494c:	df4080e7          	jalr	-524(ra) # 573c <printf>
    exit(1);
    4950:	4505                	li	a0,1
    4952:	00001097          	auipc	ra,0x1
    4956:	a72080e7          	jalr	-1422(ra) # 53c4 <exit>

000000000000495a <dirtest>:
{
    495a:	1101                	addi	sp,sp,-32
    495c:	ec06                	sd	ra,24(sp)
    495e:	e822                	sd	s0,16(sp)
    4960:	e426                	sd	s1,8(sp)
    4962:	1000                	addi	s0,sp,32
    4964:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    4966:	00003517          	auipc	a0,0x3
    496a:	06a50513          	addi	a0,a0,106 # 79d0 <malloc+0x21d4>
    496e:	00001097          	auipc	ra,0x1
    4972:	dce080e7          	jalr	-562(ra) # 573c <printf>
  if(mkdir("dir0") < 0){
    4976:	00003517          	auipc	a0,0x3
    497a:	06a50513          	addi	a0,a0,106 # 79e0 <malloc+0x21e4>
    497e:	00001097          	auipc	ra,0x1
    4982:	aae080e7          	jalr	-1362(ra) # 542c <mkdir>
    4986:	04054d63          	bltz	a0,49e0 <dirtest+0x86>
  if(chdir("dir0") < 0){
    498a:	00003517          	auipc	a0,0x3
    498e:	05650513          	addi	a0,a0,86 # 79e0 <malloc+0x21e4>
    4992:	00001097          	auipc	ra,0x1
    4996:	aa2080e7          	jalr	-1374(ra) # 5434 <chdir>
    499a:	06054163          	bltz	a0,49fc <dirtest+0xa2>
  if(chdir("..") < 0){
    499e:	00003517          	auipc	a0,0x3
    49a2:	a6250513          	addi	a0,a0,-1438 # 7400 <malloc+0x1c04>
    49a6:	00001097          	auipc	ra,0x1
    49aa:	a8e080e7          	jalr	-1394(ra) # 5434 <chdir>
    49ae:	06054563          	bltz	a0,4a18 <dirtest+0xbe>
  if(unlink("dir0") < 0){
    49b2:	00003517          	auipc	a0,0x3
    49b6:	02e50513          	addi	a0,a0,46 # 79e0 <malloc+0x21e4>
    49ba:	00001097          	auipc	ra,0x1
    49be:	a5a080e7          	jalr	-1446(ra) # 5414 <unlink>
    49c2:	06054963          	bltz	a0,4a34 <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    49c6:	00003517          	auipc	a0,0x3
    49ca:	06a50513          	addi	a0,a0,106 # 7a30 <malloc+0x2234>
    49ce:	00001097          	auipc	ra,0x1
    49d2:	d6e080e7          	jalr	-658(ra) # 573c <printf>
}
    49d6:	60e2                	ld	ra,24(sp)
    49d8:	6442                	ld	s0,16(sp)
    49da:	64a2                	ld	s1,8(sp)
    49dc:	6105                	addi	sp,sp,32
    49de:	8082                	ret
    printf("%s: mkdir failed\n", s);
    49e0:	85a6                	mv	a1,s1
    49e2:	00002517          	auipc	a0,0x2
    49e6:	3be50513          	addi	a0,a0,958 # 6da0 <malloc+0x15a4>
    49ea:	00001097          	auipc	ra,0x1
    49ee:	d52080e7          	jalr	-686(ra) # 573c <printf>
    exit(1);
    49f2:	4505                	li	a0,1
    49f4:	00001097          	auipc	ra,0x1
    49f8:	9d0080e7          	jalr	-1584(ra) # 53c4 <exit>
    printf("%s: chdir dir0 failed\n", s);
    49fc:	85a6                	mv	a1,s1
    49fe:	00003517          	auipc	a0,0x3
    4a02:	fea50513          	addi	a0,a0,-22 # 79e8 <malloc+0x21ec>
    4a06:	00001097          	auipc	ra,0x1
    4a0a:	d36080e7          	jalr	-714(ra) # 573c <printf>
    exit(1);
    4a0e:	4505                	li	a0,1
    4a10:	00001097          	auipc	ra,0x1
    4a14:	9b4080e7          	jalr	-1612(ra) # 53c4 <exit>
    printf("%s: chdir .. failed\n", s);
    4a18:	85a6                	mv	a1,s1
    4a1a:	00003517          	auipc	a0,0x3
    4a1e:	fe650513          	addi	a0,a0,-26 # 7a00 <malloc+0x2204>
    4a22:	00001097          	auipc	ra,0x1
    4a26:	d1a080e7          	jalr	-742(ra) # 573c <printf>
    exit(1);
    4a2a:	4505                	li	a0,1
    4a2c:	00001097          	auipc	ra,0x1
    4a30:	998080e7          	jalr	-1640(ra) # 53c4 <exit>
    printf("%s: unlink dir0 failed\n", s);
    4a34:	85a6                	mv	a1,s1
    4a36:	00003517          	auipc	a0,0x3
    4a3a:	fe250513          	addi	a0,a0,-30 # 7a18 <malloc+0x221c>
    4a3e:	00001097          	auipc	ra,0x1
    4a42:	cfe080e7          	jalr	-770(ra) # 573c <printf>
    exit(1);
    4a46:	4505                	li	a0,1
    4a48:	00001097          	auipc	ra,0x1
    4a4c:	97c080e7          	jalr	-1668(ra) # 53c4 <exit>

0000000000004a50 <fsfull>:
{
    4a50:	7171                	addi	sp,sp,-176
    4a52:	f506                	sd	ra,168(sp)
    4a54:	f122                	sd	s0,160(sp)
    4a56:	ed26                	sd	s1,152(sp)
    4a58:	e94a                	sd	s2,144(sp)
    4a5a:	e54e                	sd	s3,136(sp)
    4a5c:	e152                	sd	s4,128(sp)
    4a5e:	fcd6                	sd	s5,120(sp)
    4a60:	f8da                	sd	s6,112(sp)
    4a62:	f4de                	sd	s7,104(sp)
    4a64:	f0e2                	sd	s8,96(sp)
    4a66:	ece6                	sd	s9,88(sp)
    4a68:	e8ea                	sd	s10,80(sp)
    4a6a:	e4ee                	sd	s11,72(sp)
    4a6c:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4a6e:	00003517          	auipc	a0,0x3
    4a72:	fda50513          	addi	a0,a0,-38 # 7a48 <malloc+0x224c>
    4a76:	00001097          	auipc	ra,0x1
    4a7a:	cc6080e7          	jalr	-826(ra) # 573c <printf>
  for(nfiles = 0; ; nfiles++){
    4a7e:	4481                	li	s1,0
    name[0] = 'f';
    4a80:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4a84:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4a88:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4a8c:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4a8e:	00003c97          	auipc	s9,0x3
    4a92:	fcac8c93          	addi	s9,s9,-54 # 7a58 <malloc+0x225c>
    int total = 0;
    4a96:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4a98:	00007a17          	auipc	s4,0x7
    4a9c:	cf0a0a13          	addi	s4,s4,-784 # b788 <buf>
    name[0] = 'f';
    4aa0:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4aa4:	0384c7bb          	divw	a5,s1,s8
    4aa8:	0307879b          	addiw	a5,a5,48
    4aac:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4ab0:	0384e7bb          	remw	a5,s1,s8
    4ab4:	0377c7bb          	divw	a5,a5,s7
    4ab8:	0307879b          	addiw	a5,a5,48
    4abc:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4ac0:	0374e7bb          	remw	a5,s1,s7
    4ac4:	0367c7bb          	divw	a5,a5,s6
    4ac8:	0307879b          	addiw	a5,a5,48
    4acc:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4ad0:	0364e7bb          	remw	a5,s1,s6
    4ad4:	0307879b          	addiw	a5,a5,48
    4ad8:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4adc:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    4ae0:	f5040593          	addi	a1,s0,-176
    4ae4:	8566                	mv	a0,s9
    4ae6:	00001097          	auipc	ra,0x1
    4aea:	c56080e7          	jalr	-938(ra) # 573c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4aee:	20200593          	li	a1,514
    4af2:	f5040513          	addi	a0,s0,-176
    4af6:	00001097          	auipc	ra,0x1
    4afa:	90e080e7          	jalr	-1778(ra) # 5404 <open>
    4afe:	89aa                	mv	s3,a0
    if(fd < 0){
    4b00:	0a055663          	bgez	a0,4bac <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    4b04:	f5040593          	addi	a1,s0,-176
    4b08:	00003517          	auipc	a0,0x3
    4b0c:	f6050513          	addi	a0,a0,-160 # 7a68 <malloc+0x226c>
    4b10:	00001097          	auipc	ra,0x1
    4b14:	c2c080e7          	jalr	-980(ra) # 573c <printf>
  while(nfiles >= 0){
    4b18:	0604c363          	bltz	s1,4b7e <fsfull+0x12e>
    name[0] = 'f';
    4b1c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4b20:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4b24:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4b28:	4929                	li	s2,10
  while(nfiles >= 0){
    4b2a:	5afd                	li	s5,-1
    name[0] = 'f';
    4b2c:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4b30:	0344c7bb          	divw	a5,s1,s4
    4b34:	0307879b          	addiw	a5,a5,48
    4b38:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4b3c:	0344e7bb          	remw	a5,s1,s4
    4b40:	0337c7bb          	divw	a5,a5,s3
    4b44:	0307879b          	addiw	a5,a5,48
    4b48:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4b4c:	0334e7bb          	remw	a5,s1,s3
    4b50:	0327c7bb          	divw	a5,a5,s2
    4b54:	0307879b          	addiw	a5,a5,48
    4b58:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4b5c:	0324e7bb          	remw	a5,s1,s2
    4b60:	0307879b          	addiw	a5,a5,48
    4b64:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4b68:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4b6c:	f5040513          	addi	a0,s0,-176
    4b70:	00001097          	auipc	ra,0x1
    4b74:	8a4080e7          	jalr	-1884(ra) # 5414 <unlink>
    nfiles--;
    4b78:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4b7a:	fb5499e3          	bne	s1,s5,4b2c <fsfull+0xdc>
  printf("fsfull test finished\n");
    4b7e:	00003517          	auipc	a0,0x3
    4b82:	f1a50513          	addi	a0,a0,-230 # 7a98 <malloc+0x229c>
    4b86:	00001097          	auipc	ra,0x1
    4b8a:	bb6080e7          	jalr	-1098(ra) # 573c <printf>
}
    4b8e:	70aa                	ld	ra,168(sp)
    4b90:	740a                	ld	s0,160(sp)
    4b92:	64ea                	ld	s1,152(sp)
    4b94:	694a                	ld	s2,144(sp)
    4b96:	69aa                	ld	s3,136(sp)
    4b98:	6a0a                	ld	s4,128(sp)
    4b9a:	7ae6                	ld	s5,120(sp)
    4b9c:	7b46                	ld	s6,112(sp)
    4b9e:	7ba6                	ld	s7,104(sp)
    4ba0:	7c06                	ld	s8,96(sp)
    4ba2:	6ce6                	ld	s9,88(sp)
    4ba4:	6d46                	ld	s10,80(sp)
    4ba6:	6da6                	ld	s11,72(sp)
    4ba8:	614d                	addi	sp,sp,176
    4baa:	8082                	ret
    int total = 0;
    4bac:	896e                	mv	s2,s11
      if(cc < BSIZE)
    4bae:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4bb2:	40000613          	li	a2,1024
    4bb6:	85d2                	mv	a1,s4
    4bb8:	854e                	mv	a0,s3
    4bba:	00001097          	auipc	ra,0x1
    4bbe:	82a080e7          	jalr	-2006(ra) # 53e4 <write>
      if(cc < BSIZE)
    4bc2:	00aad563          	ble	a0,s5,4bcc <fsfull+0x17c>
      total += cc;
    4bc6:	00a9093b          	addw	s2,s2,a0
    while(1){
    4bca:	b7e5                	j	4bb2 <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    4bcc:	85ca                	mv	a1,s2
    4bce:	00003517          	auipc	a0,0x3
    4bd2:	eb250513          	addi	a0,a0,-334 # 7a80 <malloc+0x2284>
    4bd6:	00001097          	auipc	ra,0x1
    4bda:	b66080e7          	jalr	-1178(ra) # 573c <printf>
    close(fd);
    4bde:	854e                	mv	a0,s3
    4be0:	00001097          	auipc	ra,0x1
    4be4:	80c080e7          	jalr	-2036(ra) # 53ec <close>
    if(total == 0)
    4be8:	f20908e3          	beqz	s2,4b18 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4bec:	2485                	addiw	s1,s1,1
    4bee:	bd4d                	j	4aa0 <fsfull+0x50>

0000000000004bf0 <rand>:
{
    4bf0:	1141                	addi	sp,sp,-16
    4bf2:	e422                	sd	s0,8(sp)
    4bf4:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4bf6:	00003717          	auipc	a4,0x3
    4bfa:	36270713          	addi	a4,a4,866 # 7f58 <randstate>
    4bfe:	6308                	ld	a0,0(a4)
    4c00:	001967b7          	lui	a5,0x196
    4c04:	60d78793          	addi	a5,a5,1549 # 19660d <_end+0x187e75>
    4c08:	02f50533          	mul	a0,a0,a5
    4c0c:	3c6ef7b7          	lui	a5,0x3c6ef
    4c10:	35f78793          	addi	a5,a5,863 # 3c6ef35f <_end+0x3c6e0bc7>
    4c14:	953e                	add	a0,a0,a5
    4c16:	e308                	sd	a0,0(a4)
}
    4c18:	2501                	sext.w	a0,a0
    4c1a:	6422                	ld	s0,8(sp)
    4c1c:	0141                	addi	sp,sp,16
    4c1e:	8082                	ret

0000000000004c20 <badwrite>:
{
    4c20:	7179                	addi	sp,sp,-48
    4c22:	f406                	sd	ra,40(sp)
    4c24:	f022                	sd	s0,32(sp)
    4c26:	ec26                	sd	s1,24(sp)
    4c28:	e84a                	sd	s2,16(sp)
    4c2a:	e44e                	sd	s3,8(sp)
    4c2c:	e052                	sd	s4,0(sp)
    4c2e:	1800                	addi	s0,sp,48
  unlink("junk");
    4c30:	00003517          	auipc	a0,0x3
    4c34:	e8050513          	addi	a0,a0,-384 # 7ab0 <malloc+0x22b4>
    4c38:	00000097          	auipc	ra,0x0
    4c3c:	7dc080e7          	jalr	2012(ra) # 5414 <unlink>
    4c40:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c44:	00003997          	auipc	s3,0x3
    4c48:	e6c98993          	addi	s3,s3,-404 # 7ab0 <malloc+0x22b4>
    write(fd, (char*)0xffffffffffL, 1);
    4c4c:	5a7d                	li	s4,-1
    4c4e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c52:	20100593          	li	a1,513
    4c56:	854e                	mv	a0,s3
    4c58:	00000097          	auipc	ra,0x0
    4c5c:	7ac080e7          	jalr	1964(ra) # 5404 <open>
    4c60:	84aa                	mv	s1,a0
    if(fd < 0){
    4c62:	06054b63          	bltz	a0,4cd8 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4c66:	4605                	li	a2,1
    4c68:	85d2                	mv	a1,s4
    4c6a:	00000097          	auipc	ra,0x0
    4c6e:	77a080e7          	jalr	1914(ra) # 53e4 <write>
    close(fd);
    4c72:	8526                	mv	a0,s1
    4c74:	00000097          	auipc	ra,0x0
    4c78:	778080e7          	jalr	1912(ra) # 53ec <close>
    unlink("junk");
    4c7c:	854e                	mv	a0,s3
    4c7e:	00000097          	auipc	ra,0x0
    4c82:	796080e7          	jalr	1942(ra) # 5414 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4c86:	397d                	addiw	s2,s2,-1
    4c88:	fc0915e3          	bnez	s2,4c52 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4c8c:	20100593          	li	a1,513
    4c90:	00003517          	auipc	a0,0x3
    4c94:	e2050513          	addi	a0,a0,-480 # 7ab0 <malloc+0x22b4>
    4c98:	00000097          	auipc	ra,0x0
    4c9c:	76c080e7          	jalr	1900(ra) # 5404 <open>
    4ca0:	84aa                	mv	s1,a0
  if(fd < 0){
    4ca2:	04054863          	bltz	a0,4cf2 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4ca6:	4605                	li	a2,1
    4ca8:	00001597          	auipc	a1,0x1
    4cac:	08858593          	addi	a1,a1,136 # 5d30 <malloc+0x534>
    4cb0:	00000097          	auipc	ra,0x0
    4cb4:	734080e7          	jalr	1844(ra) # 53e4 <write>
    4cb8:	4785                	li	a5,1
    4cba:	04f50963          	beq	a0,a5,4d0c <badwrite+0xec>
    printf("write failed\n");
    4cbe:	00003517          	auipc	a0,0x3
    4cc2:	e1250513          	addi	a0,a0,-494 # 7ad0 <malloc+0x22d4>
    4cc6:	00001097          	auipc	ra,0x1
    4cca:	a76080e7          	jalr	-1418(ra) # 573c <printf>
    exit(1);
    4cce:	4505                	li	a0,1
    4cd0:	00000097          	auipc	ra,0x0
    4cd4:	6f4080e7          	jalr	1780(ra) # 53c4 <exit>
      printf("open junk failed\n");
    4cd8:	00003517          	auipc	a0,0x3
    4cdc:	de050513          	addi	a0,a0,-544 # 7ab8 <malloc+0x22bc>
    4ce0:	00001097          	auipc	ra,0x1
    4ce4:	a5c080e7          	jalr	-1444(ra) # 573c <printf>
      exit(1);
    4ce8:	4505                	li	a0,1
    4cea:	00000097          	auipc	ra,0x0
    4cee:	6da080e7          	jalr	1754(ra) # 53c4 <exit>
    printf("open junk failed\n");
    4cf2:	00003517          	auipc	a0,0x3
    4cf6:	dc650513          	addi	a0,a0,-570 # 7ab8 <malloc+0x22bc>
    4cfa:	00001097          	auipc	ra,0x1
    4cfe:	a42080e7          	jalr	-1470(ra) # 573c <printf>
    exit(1);
    4d02:	4505                	li	a0,1
    4d04:	00000097          	auipc	ra,0x0
    4d08:	6c0080e7          	jalr	1728(ra) # 53c4 <exit>
  close(fd);
    4d0c:	8526                	mv	a0,s1
    4d0e:	00000097          	auipc	ra,0x0
    4d12:	6de080e7          	jalr	1758(ra) # 53ec <close>
  unlink("junk");
    4d16:	00003517          	auipc	a0,0x3
    4d1a:	d9a50513          	addi	a0,a0,-614 # 7ab0 <malloc+0x22b4>
    4d1e:	00000097          	auipc	ra,0x0
    4d22:	6f6080e7          	jalr	1782(ra) # 5414 <unlink>
  exit(0);
    4d26:	4501                	li	a0,0
    4d28:	00000097          	auipc	ra,0x0
    4d2c:	69c080e7          	jalr	1692(ra) # 53c4 <exit>

0000000000004d30 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4d30:	7139                	addi	sp,sp,-64
    4d32:	fc06                	sd	ra,56(sp)
    4d34:	f822                	sd	s0,48(sp)
    4d36:	f426                	sd	s1,40(sp)
    4d38:	f04a                	sd	s2,32(sp)
    4d3a:	ec4e                	sd	s3,24(sp)
    4d3c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4d3e:	fc840513          	addi	a0,s0,-56
    4d42:	00000097          	auipc	ra,0x0
    4d46:	692080e7          	jalr	1682(ra) # 53d4 <pipe>
    4d4a:	06054863          	bltz	a0,4dba <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4d4e:	00000097          	auipc	ra,0x0
    4d52:	66e080e7          	jalr	1646(ra) # 53bc <fork>

  if(pid < 0){
    4d56:	06054f63          	bltz	a0,4dd4 <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4d5a:	ed59                	bnez	a0,4df8 <countfree+0xc8>
    close(fds[0]);
    4d5c:	fc842503          	lw	a0,-56(s0)
    4d60:	00000097          	auipc	ra,0x0
    4d64:	68c080e7          	jalr	1676(ra) # 53ec <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4d68:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4d6a:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4d6c:	00001917          	auipc	s2,0x1
    4d70:	fc490913          	addi	s2,s2,-60 # 5d30 <malloc+0x534>
      uint64 a = (uint64) sbrk(4096);
    4d74:	6505                	lui	a0,0x1
    4d76:	00000097          	auipc	ra,0x0
    4d7a:	6d6080e7          	jalr	1750(ra) # 544c <sbrk>
      if(a == 0xffffffffffffffff){
    4d7e:	06950863          	beq	a0,s1,4dee <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    4d82:	6785                	lui	a5,0x1
    4d84:	97aa                	add	a5,a5,a0
    4d86:	ff378fa3          	sb	s3,-1(a5) # fff <bigdir+0x83>
      if(write(fds[1], "x", 1) != 1){
    4d8a:	4605                	li	a2,1
    4d8c:	85ca                	mv	a1,s2
    4d8e:	fcc42503          	lw	a0,-52(s0)
    4d92:	00000097          	auipc	ra,0x0
    4d96:	652080e7          	jalr	1618(ra) # 53e4 <write>
    4d9a:	4785                	li	a5,1
    4d9c:	fcf50ce3          	beq	a0,a5,4d74 <countfree+0x44>
        printf("write() failed in countfree()\n");
    4da0:	00003517          	auipc	a0,0x3
    4da4:	d8050513          	addi	a0,a0,-640 # 7b20 <malloc+0x2324>
    4da8:	00001097          	auipc	ra,0x1
    4dac:	994080e7          	jalr	-1644(ra) # 573c <printf>
        exit(1);
    4db0:	4505                	li	a0,1
    4db2:	00000097          	auipc	ra,0x0
    4db6:	612080e7          	jalr	1554(ra) # 53c4 <exit>
    printf("pipe() failed in countfree()\n");
    4dba:	00003517          	auipc	a0,0x3
    4dbe:	d2650513          	addi	a0,a0,-730 # 7ae0 <malloc+0x22e4>
    4dc2:	00001097          	auipc	ra,0x1
    4dc6:	97a080e7          	jalr	-1670(ra) # 573c <printf>
    exit(1);
    4dca:	4505                	li	a0,1
    4dcc:	00000097          	auipc	ra,0x0
    4dd0:	5f8080e7          	jalr	1528(ra) # 53c4 <exit>
    printf("fork failed in countfree()\n");
    4dd4:	00003517          	auipc	a0,0x3
    4dd8:	d2c50513          	addi	a0,a0,-724 # 7b00 <malloc+0x2304>
    4ddc:	00001097          	auipc	ra,0x1
    4de0:	960080e7          	jalr	-1696(ra) # 573c <printf>
    exit(1);
    4de4:	4505                	li	a0,1
    4de6:	00000097          	auipc	ra,0x0
    4dea:	5de080e7          	jalr	1502(ra) # 53c4 <exit>
      }
    }

    exit(0);
    4dee:	4501                	li	a0,0
    4df0:	00000097          	auipc	ra,0x0
    4df4:	5d4080e7          	jalr	1492(ra) # 53c4 <exit>
  }

  close(fds[1]);
    4df8:	fcc42503          	lw	a0,-52(s0)
    4dfc:	00000097          	auipc	ra,0x0
    4e00:	5f0080e7          	jalr	1520(ra) # 53ec <close>

  int n = 0;
    4e04:	4481                	li	s1,0
    4e06:	a839                	j	4e24 <countfree+0xf4>
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    if(cc < 0){
      printf("read() failed in countfree()\n");
    4e08:	00003517          	auipc	a0,0x3
    4e0c:	d3850513          	addi	a0,a0,-712 # 7b40 <malloc+0x2344>
    4e10:	00001097          	auipc	ra,0x1
    4e14:	92c080e7          	jalr	-1748(ra) # 573c <printf>
      exit(1);
    4e18:	4505                	li	a0,1
    4e1a:	00000097          	auipc	ra,0x0
    4e1e:	5aa080e7          	jalr	1450(ra) # 53c4 <exit>
    }
    if(cc == 0)
      break;
    n += 1;
    4e22:	2485                	addiw	s1,s1,1
    int cc = read(fds[0], &c, 1);
    4e24:	4605                	li	a2,1
    4e26:	fc740593          	addi	a1,s0,-57
    4e2a:	fc842503          	lw	a0,-56(s0)
    4e2e:	00000097          	auipc	ra,0x0
    4e32:	5ae080e7          	jalr	1454(ra) # 53dc <read>
    if(cc < 0){
    4e36:	fc0549e3          	bltz	a0,4e08 <countfree+0xd8>
    if(cc == 0)
    4e3a:	f565                	bnez	a0,4e22 <countfree+0xf2>
  }

  close(fds[0]);
    4e3c:	fc842503          	lw	a0,-56(s0)
    4e40:	00000097          	auipc	ra,0x0
    4e44:	5ac080e7          	jalr	1452(ra) # 53ec <close>
  wait((int*)0);
    4e48:	4501                	li	a0,0
    4e4a:	00000097          	auipc	ra,0x0
    4e4e:	582080e7          	jalr	1410(ra) # 53cc <wait>
  
  return n;
}
    4e52:	8526                	mv	a0,s1
    4e54:	70e2                	ld	ra,56(sp)
    4e56:	7442                	ld	s0,48(sp)
    4e58:	74a2                	ld	s1,40(sp)
    4e5a:	7902                	ld	s2,32(sp)
    4e5c:	69e2                	ld	s3,24(sp)
    4e5e:	6121                	addi	sp,sp,64
    4e60:	8082                	ret

0000000000004e62 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4e62:	7179                	addi	sp,sp,-48
    4e64:	f406                	sd	ra,40(sp)
    4e66:	f022                	sd	s0,32(sp)
    4e68:	ec26                	sd	s1,24(sp)
    4e6a:	e84a                	sd	s2,16(sp)
    4e6c:	1800                	addi	s0,sp,48
    4e6e:	84aa                	mv	s1,a0
    4e70:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4e72:	00003517          	auipc	a0,0x3
    4e76:	cee50513          	addi	a0,a0,-786 # 7b60 <malloc+0x2364>
    4e7a:	00001097          	auipc	ra,0x1
    4e7e:	8c2080e7          	jalr	-1854(ra) # 573c <printf>
  if((pid = fork()) < 0) {
    4e82:	00000097          	auipc	ra,0x0
    4e86:	53a080e7          	jalr	1338(ra) # 53bc <fork>
    4e8a:	02054e63          	bltz	a0,4ec6 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4e8e:	c929                	beqz	a0,4ee0 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4e90:	fdc40513          	addi	a0,s0,-36
    4e94:	00000097          	auipc	ra,0x0
    4e98:	538080e7          	jalr	1336(ra) # 53cc <wait>
    if(xstatus != 0) 
    4e9c:	fdc42783          	lw	a5,-36(s0)
    4ea0:	c7b9                	beqz	a5,4eee <run+0x8c>
      printf("FAILED\n");
    4ea2:	00003517          	auipc	a0,0x3
    4ea6:	ce650513          	addi	a0,a0,-794 # 7b88 <malloc+0x238c>
    4eaa:	00001097          	auipc	ra,0x1
    4eae:	892080e7          	jalr	-1902(ra) # 573c <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4eb2:	fdc42503          	lw	a0,-36(s0)
  }
}
    4eb6:	00153513          	seqz	a0,a0
    4eba:	70a2                	ld	ra,40(sp)
    4ebc:	7402                	ld	s0,32(sp)
    4ebe:	64e2                	ld	s1,24(sp)
    4ec0:	6942                	ld	s2,16(sp)
    4ec2:	6145                	addi	sp,sp,48
    4ec4:	8082                	ret
    printf("runtest: fork error\n");
    4ec6:	00003517          	auipc	a0,0x3
    4eca:	caa50513          	addi	a0,a0,-854 # 7b70 <malloc+0x2374>
    4ece:	00001097          	auipc	ra,0x1
    4ed2:	86e080e7          	jalr	-1938(ra) # 573c <printf>
    exit(1);
    4ed6:	4505                	li	a0,1
    4ed8:	00000097          	auipc	ra,0x0
    4edc:	4ec080e7          	jalr	1260(ra) # 53c4 <exit>
    f(s);
    4ee0:	854a                	mv	a0,s2
    4ee2:	9482                	jalr	s1
    exit(0);
    4ee4:	4501                	li	a0,0
    4ee6:	00000097          	auipc	ra,0x0
    4eea:	4de080e7          	jalr	1246(ra) # 53c4 <exit>
      printf("OK\n");
    4eee:	00003517          	auipc	a0,0x3
    4ef2:	ca250513          	addi	a0,a0,-862 # 7b90 <malloc+0x2394>
    4ef6:	00001097          	auipc	ra,0x1
    4efa:	846080e7          	jalr	-1978(ra) # 573c <printf>
    4efe:	bf55                	j	4eb2 <run+0x50>

0000000000004f00 <main>:

int
main(int argc, char *argv[])
{
    4f00:	c4010113          	addi	sp,sp,-960
    4f04:	3a113c23          	sd	ra,952(sp)
    4f08:	3a813823          	sd	s0,944(sp)
    4f0c:	3a913423          	sd	s1,936(sp)
    4f10:	3b213023          	sd	s2,928(sp)
    4f14:	39313c23          	sd	s3,920(sp)
    4f18:	39413823          	sd	s4,912(sp)
    4f1c:	39513423          	sd	s5,904(sp)
    4f20:	39613023          	sd	s6,896(sp)
    4f24:	0780                	addi	s0,sp,960
    4f26:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4f28:	4789                	li	a5,2
    4f2a:	08f50863          	beq	a0,a5,4fba <main+0xba>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4f2e:	4785                	li	a5,1
    4f30:	0ca7c363          	blt	a5,a0,4ff6 <main+0xf6>
  char *justone = 0;
    4f34:	4981                	li	s3,0
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    4f36:	00001797          	auipc	a5,0x1
    4f3a:	9d278793          	addi	a5,a5,-1582 # 5908 <malloc+0x10c>
    4f3e:	c4040713          	addi	a4,s0,-960
    4f42:	00001817          	auipc	a6,0x1
    4f46:	d4680813          	addi	a6,a6,-698 # 5c88 <malloc+0x48c>
    4f4a:	6388                	ld	a0,0(a5)
    4f4c:	678c                	ld	a1,8(a5)
    4f4e:	6b90                	ld	a2,16(a5)
    4f50:	6f94                	ld	a3,24(a5)
    4f52:	e308                	sd	a0,0(a4)
    4f54:	e70c                	sd	a1,8(a4)
    4f56:	eb10                	sd	a2,16(a4)
    4f58:	ef14                	sd	a3,24(a4)
    4f5a:	02078793          	addi	a5,a5,32
    4f5e:	02070713          	addi	a4,a4,32
    4f62:	ff0794e3          	bne	a5,a6,4f4a <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    4f66:	00003517          	auipc	a0,0x3
    4f6a:	ce250513          	addi	a0,a0,-798 # 7c48 <malloc+0x244c>
    4f6e:	00000097          	auipc	ra,0x0
    4f72:	7ce080e7          	jalr	1998(ra) # 573c <printf>
  int free0 = countfree();
    4f76:	00000097          	auipc	ra,0x0
    4f7a:	dba080e7          	jalr	-582(ra) # 4d30 <countfree>
    4f7e:	8b2a                	mv	s6,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4f80:	c4843903          	ld	s2,-952(s0)
    4f84:	c4040493          	addi	s1,s0,-960
  int fail = 0;
    4f88:	4a01                	li	s4,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    4f8a:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    4f8c:	0a091a63          	bnez	s2,5040 <main+0x140>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    4f90:	00000097          	auipc	ra,0x0
    4f94:	da0080e7          	jalr	-608(ra) # 4d30 <countfree>
    4f98:	85aa                	mv	a1,a0
    4f9a:	0f655463          	ble	s6,a0,5082 <main+0x182>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4f9e:	865a                	mv	a2,s6
    4fa0:	00003517          	auipc	a0,0x3
    4fa4:	c6050513          	addi	a0,a0,-928 # 7c00 <malloc+0x2404>
    4fa8:	00000097          	auipc	ra,0x0
    4fac:	794080e7          	jalr	1940(ra) # 573c <printf>
    exit(1);
    4fb0:	4505                	li	a0,1
    4fb2:	00000097          	auipc	ra,0x0
    4fb6:	412080e7          	jalr	1042(ra) # 53c4 <exit>
    4fba:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4fbc:	00003597          	auipc	a1,0x3
    4fc0:	bdc58593          	addi	a1,a1,-1060 # 7b98 <malloc+0x239c>
    4fc4:	6488                	ld	a0,8(s1)
    4fc6:	00000097          	auipc	ra,0x0
    4fca:	18a080e7          	jalr	394(ra) # 5150 <strcmp>
    4fce:	10050863          	beqz	a0,50de <main+0x1de>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4fd2:	00003597          	auipc	a1,0x3
    4fd6:	cae58593          	addi	a1,a1,-850 # 7c80 <malloc+0x2484>
    4fda:	6488                	ld	a0,8(s1)
    4fdc:	00000097          	auipc	ra,0x0
    4fe0:	174080e7          	jalr	372(ra) # 5150 <strcmp>
    4fe4:	cd75                	beqz	a0,50e0 <main+0x1e0>
  } else if(argc == 2 && argv[1][0] != '-'){
    4fe6:	0084b983          	ld	s3,8(s1)
    4fea:	0009c703          	lbu	a4,0(s3)
    4fee:	02d00793          	li	a5,45
    4ff2:	f4f712e3          	bne	a4,a5,4f36 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    4ff6:	00003517          	auipc	a0,0x3
    4ffa:	baa50513          	addi	a0,a0,-1110 # 7ba0 <malloc+0x23a4>
    4ffe:	00000097          	auipc	ra,0x0
    5002:	73e080e7          	jalr	1854(ra) # 573c <printf>
    exit(1);
    5006:	4505                	li	a0,1
    5008:	00000097          	auipc	ra,0x0
    500c:	3bc080e7          	jalr	956(ra) # 53c4 <exit>
          exit(1);
    5010:	4505                	li	a0,1
    5012:	00000097          	auipc	ra,0x0
    5016:	3b2080e7          	jalr	946(ra) # 53c4 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    501a:	40a905bb          	subw	a1,s2,a0
    501e:	855a                	mv	a0,s6
    5020:	00000097          	auipc	ra,0x0
    5024:	71c080e7          	jalr	1820(ra) # 573c <printf>
        if(continuous != 2)
    5028:	09498763          	beq	s3,s4,50b6 <main+0x1b6>
          exit(1);
    502c:	4505                	li	a0,1
    502e:	00000097          	auipc	ra,0x0
    5032:	396080e7          	jalr	918(ra) # 53c4 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5036:	04c1                	addi	s1,s1,16
    5038:	0084b903          	ld	s2,8(s1)
    503c:	02090463          	beqz	s2,5064 <main+0x164>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5040:	00098963          	beqz	s3,5052 <main+0x152>
    5044:	85ce                	mv	a1,s3
    5046:	854a                	mv	a0,s2
    5048:	00000097          	auipc	ra,0x0
    504c:	108080e7          	jalr	264(ra) # 5150 <strcmp>
    5050:	f17d                	bnez	a0,5036 <main+0x136>
      if(!run(t->f, t->s))
    5052:	85ca                	mv	a1,s2
    5054:	6088                	ld	a0,0(s1)
    5056:	00000097          	auipc	ra,0x0
    505a:	e0c080e7          	jalr	-500(ra) # 4e62 <run>
    505e:	fd61                	bnez	a0,5036 <main+0x136>
        fail = 1;
    5060:	8a56                	mv	s4,s5
    5062:	bfd1                	j	5036 <main+0x136>
  if(fail){
    5064:	f20a06e3          	beqz	s4,4f90 <main+0x90>
    printf("SOME TESTS FAILED\n");
    5068:	00003517          	auipc	a0,0x3
    506c:	b8050513          	addi	a0,a0,-1152 # 7be8 <malloc+0x23ec>
    5070:	00000097          	auipc	ra,0x0
    5074:	6cc080e7          	jalr	1740(ra) # 573c <printf>
    exit(1);
    5078:	4505                	li	a0,1
    507a:	00000097          	auipc	ra,0x0
    507e:	34a080e7          	jalr	842(ra) # 53c4 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5082:	00003517          	auipc	a0,0x3
    5086:	bae50513          	addi	a0,a0,-1106 # 7c30 <malloc+0x2434>
    508a:	00000097          	auipc	ra,0x0
    508e:	6b2080e7          	jalr	1714(ra) # 573c <printf>
    exit(0);
    5092:	4501                	li	a0,0
    5094:	00000097          	auipc	ra,0x0
    5098:	330080e7          	jalr	816(ra) # 53c4 <exit>
        printf("SOME TESTS FAILED\n");
    509c:	8556                	mv	a0,s5
    509e:	00000097          	auipc	ra,0x0
    50a2:	69e080e7          	jalr	1694(ra) # 573c <printf>
        if(continuous != 2)
    50a6:	f74995e3          	bne	s3,s4,5010 <main+0x110>
      int free1 = countfree();
    50aa:	00000097          	auipc	ra,0x0
    50ae:	c86080e7          	jalr	-890(ra) # 4d30 <countfree>
      if(free1 < free0){
    50b2:	f72544e3          	blt	a0,s2,501a <main+0x11a>
      int free0 = countfree();
    50b6:	00000097          	auipc	ra,0x0
    50ba:	c7a080e7          	jalr	-902(ra) # 4d30 <countfree>
    50be:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    50c0:	c4843583          	ld	a1,-952(s0)
    50c4:	d1fd                	beqz	a1,50aa <main+0x1aa>
    50c6:	c4040493          	addi	s1,s0,-960
        if(!run(t->f, t->s)){
    50ca:	6088                	ld	a0,0(s1)
    50cc:	00000097          	auipc	ra,0x0
    50d0:	d96080e7          	jalr	-618(ra) # 4e62 <run>
    50d4:	d561                	beqz	a0,509c <main+0x19c>
      for (struct test *t = tests; t->s != 0; t++) {
    50d6:	04c1                	addi	s1,s1,16
    50d8:	648c                	ld	a1,8(s1)
    50da:	f9e5                	bnez	a1,50ca <main+0x1ca>
    50dc:	b7f9                	j	50aa <main+0x1aa>
    continuous = 1;
    50de:	4985                	li	s3,1
  } tests[] = {
    50e0:	00001797          	auipc	a5,0x1
    50e4:	82878793          	addi	a5,a5,-2008 # 5908 <malloc+0x10c>
    50e8:	c4040713          	addi	a4,s0,-960
    50ec:	00001817          	auipc	a6,0x1
    50f0:	b9c80813          	addi	a6,a6,-1124 # 5c88 <malloc+0x48c>
    50f4:	6388                	ld	a0,0(a5)
    50f6:	678c                	ld	a1,8(a5)
    50f8:	6b90                	ld	a2,16(a5)
    50fa:	6f94                	ld	a3,24(a5)
    50fc:	e308                	sd	a0,0(a4)
    50fe:	e70c                	sd	a1,8(a4)
    5100:	eb10                	sd	a2,16(a4)
    5102:	ef14                	sd	a3,24(a4)
    5104:	02078793          	addi	a5,a5,32
    5108:	02070713          	addi	a4,a4,32
    510c:	ff0794e3          	bne	a5,a6,50f4 <main+0x1f4>
    printf("continuous usertests starting\n");
    5110:	00003517          	auipc	a0,0x3
    5114:	b5050513          	addi	a0,a0,-1200 # 7c60 <malloc+0x2464>
    5118:	00000097          	auipc	ra,0x0
    511c:	624080e7          	jalr	1572(ra) # 573c <printf>
        printf("SOME TESTS FAILED\n");
    5120:	00003a97          	auipc	s5,0x3
    5124:	ac8a8a93          	addi	s5,s5,-1336 # 7be8 <malloc+0x23ec>
        if(continuous != 2)
    5128:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    512a:	00003b17          	auipc	s6,0x3
    512e:	a9eb0b13          	addi	s6,s6,-1378 # 7bc8 <malloc+0x23cc>
    5132:	b751                	j	50b6 <main+0x1b6>

0000000000005134 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5134:	1141                	addi	sp,sp,-16
    5136:	e422                	sd	s0,8(sp)
    5138:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    513a:	87aa                	mv	a5,a0
    513c:	0585                	addi	a1,a1,1
    513e:	0785                	addi	a5,a5,1
    5140:	fff5c703          	lbu	a4,-1(a1)
    5144:	fee78fa3          	sb	a4,-1(a5)
    5148:	fb75                	bnez	a4,513c <strcpy+0x8>
    ;
  return os;
}
    514a:	6422                	ld	s0,8(sp)
    514c:	0141                	addi	sp,sp,16
    514e:	8082                	ret

0000000000005150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5150:	1141                	addi	sp,sp,-16
    5152:	e422                	sd	s0,8(sp)
    5154:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5156:	00054783          	lbu	a5,0(a0)
    515a:	cf91                	beqz	a5,5176 <strcmp+0x26>
    515c:	0005c703          	lbu	a4,0(a1)
    5160:	00f71b63          	bne	a4,a5,5176 <strcmp+0x26>
    p++, q++;
    5164:	0505                	addi	a0,a0,1
    5166:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5168:	00054783          	lbu	a5,0(a0)
    516c:	c789                	beqz	a5,5176 <strcmp+0x26>
    516e:	0005c703          	lbu	a4,0(a1)
    5172:	fef709e3          	beq	a4,a5,5164 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
    5176:	0005c503          	lbu	a0,0(a1)
}
    517a:	40a7853b          	subw	a0,a5,a0
    517e:	6422                	ld	s0,8(sp)
    5180:	0141                	addi	sp,sp,16
    5182:	8082                	ret

0000000000005184 <strlen>:

uint
strlen(const char *s)
{
    5184:	1141                	addi	sp,sp,-16
    5186:	e422                	sd	s0,8(sp)
    5188:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    518a:	00054783          	lbu	a5,0(a0)
    518e:	cf91                	beqz	a5,51aa <strlen+0x26>
    5190:	0505                	addi	a0,a0,1
    5192:	87aa                	mv	a5,a0
    5194:	4685                	li	a3,1
    5196:	9e89                	subw	a3,a3,a0
    5198:	00f6853b          	addw	a0,a3,a5
    519c:	0785                	addi	a5,a5,1
    519e:	fff7c703          	lbu	a4,-1(a5)
    51a2:	fb7d                	bnez	a4,5198 <strlen+0x14>
    ;
  return n;
}
    51a4:	6422                	ld	s0,8(sp)
    51a6:	0141                	addi	sp,sp,16
    51a8:	8082                	ret
  for(n = 0; s[n]; n++)
    51aa:	4501                	li	a0,0
    51ac:	bfe5                	j	51a4 <strlen+0x20>

00000000000051ae <memset>:

void*
memset(void *dst, int c, uint n)
{
    51ae:	1141                	addi	sp,sp,-16
    51b0:	e422                	sd	s0,8(sp)
    51b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    51b4:	ce09                	beqz	a2,51ce <memset+0x20>
    51b6:	87aa                	mv	a5,a0
    51b8:	fff6071b          	addiw	a4,a2,-1
    51bc:	1702                	slli	a4,a4,0x20
    51be:	9301                	srli	a4,a4,0x20
    51c0:	0705                	addi	a4,a4,1
    51c2:	972a                	add	a4,a4,a0
    cdst[i] = c;
    51c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    51c8:	0785                	addi	a5,a5,1
    51ca:	fee79de3          	bne	a5,a4,51c4 <memset+0x16>
  }
  return dst;
}
    51ce:	6422                	ld	s0,8(sp)
    51d0:	0141                	addi	sp,sp,16
    51d2:	8082                	ret

00000000000051d4 <strchr>:

char*
strchr(const char *s, char c)
{
    51d4:	1141                	addi	sp,sp,-16
    51d6:	e422                	sd	s0,8(sp)
    51d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
    51da:	00054783          	lbu	a5,0(a0)
    51de:	cf91                	beqz	a5,51fa <strchr+0x26>
    if(*s == c)
    51e0:	00f58a63          	beq	a1,a5,51f4 <strchr+0x20>
  for(; *s; s++)
    51e4:	0505                	addi	a0,a0,1
    51e6:	00054783          	lbu	a5,0(a0)
    51ea:	c781                	beqz	a5,51f2 <strchr+0x1e>
    if(*s == c)
    51ec:	feb79ce3          	bne	a5,a1,51e4 <strchr+0x10>
    51f0:	a011                	j	51f4 <strchr+0x20>
      return (char*)s;
  return 0;
    51f2:	4501                	li	a0,0
}
    51f4:	6422                	ld	s0,8(sp)
    51f6:	0141                	addi	sp,sp,16
    51f8:	8082                	ret
  return 0;
    51fa:	4501                	li	a0,0
    51fc:	bfe5                	j	51f4 <strchr+0x20>

00000000000051fe <gets>:

char*
gets(char *buf, int max)
{
    51fe:	711d                	addi	sp,sp,-96
    5200:	ec86                	sd	ra,88(sp)
    5202:	e8a2                	sd	s0,80(sp)
    5204:	e4a6                	sd	s1,72(sp)
    5206:	e0ca                	sd	s2,64(sp)
    5208:	fc4e                	sd	s3,56(sp)
    520a:	f852                	sd	s4,48(sp)
    520c:	f456                	sd	s5,40(sp)
    520e:	f05a                	sd	s6,32(sp)
    5210:	ec5e                	sd	s7,24(sp)
    5212:	1080                	addi	s0,sp,96
    5214:	8baa                	mv	s7,a0
    5216:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5218:	892a                	mv	s2,a0
    521a:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    521c:	4aa9                	li	s5,10
    521e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5220:	0019849b          	addiw	s1,s3,1
    5224:	0344d863          	ble	s4,s1,5254 <gets+0x56>
    cc = read(0, &c, 1);
    5228:	4605                	li	a2,1
    522a:	faf40593          	addi	a1,s0,-81
    522e:	4501                	li	a0,0
    5230:	00000097          	auipc	ra,0x0
    5234:	1ac080e7          	jalr	428(ra) # 53dc <read>
    if(cc < 1)
    5238:	00a05e63          	blez	a0,5254 <gets+0x56>
    buf[i++] = c;
    523c:	faf44783          	lbu	a5,-81(s0)
    5240:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5244:	01578763          	beq	a5,s5,5252 <gets+0x54>
    5248:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
    524a:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
    524c:	fd679ae3          	bne	a5,s6,5220 <gets+0x22>
    5250:	a011                	j	5254 <gets+0x56>
  for(i=0; i+1 < max; ){
    5252:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5254:	99de                	add	s3,s3,s7
    5256:	00098023          	sb	zero,0(s3)
  return buf;
}
    525a:	855e                	mv	a0,s7
    525c:	60e6                	ld	ra,88(sp)
    525e:	6446                	ld	s0,80(sp)
    5260:	64a6                	ld	s1,72(sp)
    5262:	6906                	ld	s2,64(sp)
    5264:	79e2                	ld	s3,56(sp)
    5266:	7a42                	ld	s4,48(sp)
    5268:	7aa2                	ld	s5,40(sp)
    526a:	7b02                	ld	s6,32(sp)
    526c:	6be2                	ld	s7,24(sp)
    526e:	6125                	addi	sp,sp,96
    5270:	8082                	ret

0000000000005272 <stat>:

int
stat(const char *n, struct stat *st)
{
    5272:	1101                	addi	sp,sp,-32
    5274:	ec06                	sd	ra,24(sp)
    5276:	e822                	sd	s0,16(sp)
    5278:	e426                	sd	s1,8(sp)
    527a:	e04a                	sd	s2,0(sp)
    527c:	1000                	addi	s0,sp,32
    527e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5280:	4581                	li	a1,0
    5282:	00000097          	auipc	ra,0x0
    5286:	182080e7          	jalr	386(ra) # 5404 <open>
  if(fd < 0)
    528a:	02054563          	bltz	a0,52b4 <stat+0x42>
    528e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5290:	85ca                	mv	a1,s2
    5292:	00000097          	auipc	ra,0x0
    5296:	18a080e7          	jalr	394(ra) # 541c <fstat>
    529a:	892a                	mv	s2,a0
  close(fd);
    529c:	8526                	mv	a0,s1
    529e:	00000097          	auipc	ra,0x0
    52a2:	14e080e7          	jalr	334(ra) # 53ec <close>
  return r;
}
    52a6:	854a                	mv	a0,s2
    52a8:	60e2                	ld	ra,24(sp)
    52aa:	6442                	ld	s0,16(sp)
    52ac:	64a2                	ld	s1,8(sp)
    52ae:	6902                	ld	s2,0(sp)
    52b0:	6105                	addi	sp,sp,32
    52b2:	8082                	ret
    return -1;
    52b4:	597d                	li	s2,-1
    52b6:	bfc5                	j	52a6 <stat+0x34>

00000000000052b8 <atoi>:

int
atoi(const char *s)
{
    52b8:	1141                	addi	sp,sp,-16
    52ba:	e422                	sd	s0,8(sp)
    52bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    52be:	00054683          	lbu	a3,0(a0)
    52c2:	fd06879b          	addiw	a5,a3,-48
    52c6:	0ff7f793          	andi	a5,a5,255
    52ca:	4725                	li	a4,9
    52cc:	02f76963          	bltu	a4,a5,52fe <atoi+0x46>
    52d0:	862a                	mv	a2,a0
  n = 0;
    52d2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    52d4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    52d6:	0605                	addi	a2,a2,1
    52d8:	0025179b          	slliw	a5,a0,0x2
    52dc:	9fa9                	addw	a5,a5,a0
    52de:	0017979b          	slliw	a5,a5,0x1
    52e2:	9fb5                	addw	a5,a5,a3
    52e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    52e8:	00064683          	lbu	a3,0(a2) # 3000 <subdir+0x2f8>
    52ec:	fd06871b          	addiw	a4,a3,-48
    52f0:	0ff77713          	andi	a4,a4,255
    52f4:	fee5f1e3          	bleu	a4,a1,52d6 <atoi+0x1e>
  return n;
}
    52f8:	6422                	ld	s0,8(sp)
    52fa:	0141                	addi	sp,sp,16
    52fc:	8082                	ret
  n = 0;
    52fe:	4501                	li	a0,0
    5300:	bfe5                	j	52f8 <atoi+0x40>

0000000000005302 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5302:	1141                	addi	sp,sp,-16
    5304:	e422                	sd	s0,8(sp)
    5306:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5308:	02b57663          	bleu	a1,a0,5334 <memmove+0x32>
    while(n-- > 0)
    530c:	02c05163          	blez	a2,532e <memmove+0x2c>
    5310:	fff6079b          	addiw	a5,a2,-1
    5314:	1782                	slli	a5,a5,0x20
    5316:	9381                	srli	a5,a5,0x20
    5318:	0785                	addi	a5,a5,1
    531a:	97aa                	add	a5,a5,a0
  dst = vdst;
    531c:	872a                	mv	a4,a0
      *dst++ = *src++;
    531e:	0585                	addi	a1,a1,1
    5320:	0705                	addi	a4,a4,1
    5322:	fff5c683          	lbu	a3,-1(a1)
    5326:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    532a:	fee79ae3          	bne	a5,a4,531e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    532e:	6422                	ld	s0,8(sp)
    5330:	0141                	addi	sp,sp,16
    5332:	8082                	ret
    dst += n;
    5334:	00c50733          	add	a4,a0,a2
    src += n;
    5338:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    533a:	fec05ae3          	blez	a2,532e <memmove+0x2c>
    533e:	fff6079b          	addiw	a5,a2,-1
    5342:	1782                	slli	a5,a5,0x20
    5344:	9381                	srli	a5,a5,0x20
    5346:	fff7c793          	not	a5,a5
    534a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    534c:	15fd                	addi	a1,a1,-1
    534e:	177d                	addi	a4,a4,-1
    5350:	0005c683          	lbu	a3,0(a1)
    5354:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5358:	fef71ae3          	bne	a4,a5,534c <memmove+0x4a>
    535c:	bfc9                	j	532e <memmove+0x2c>

000000000000535e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    535e:	1141                	addi	sp,sp,-16
    5360:	e422                	sd	s0,8(sp)
    5362:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5364:	ce15                	beqz	a2,53a0 <memcmp+0x42>
    5366:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
    536a:	00054783          	lbu	a5,0(a0)
    536e:	0005c703          	lbu	a4,0(a1)
    5372:	02e79063          	bne	a5,a4,5392 <memcmp+0x34>
    5376:	1682                	slli	a3,a3,0x20
    5378:	9281                	srli	a3,a3,0x20
    537a:	0685                	addi	a3,a3,1
    537c:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
    537e:	0505                	addi	a0,a0,1
    p2++;
    5380:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5382:	00d50d63          	beq	a0,a3,539c <memcmp+0x3e>
    if (*p1 != *p2) {
    5386:	00054783          	lbu	a5,0(a0)
    538a:	0005c703          	lbu	a4,0(a1)
    538e:	fee788e3          	beq	a5,a4,537e <memcmp+0x20>
      return *p1 - *p2;
    5392:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
    5396:	6422                	ld	s0,8(sp)
    5398:	0141                	addi	sp,sp,16
    539a:	8082                	ret
  return 0;
    539c:	4501                	li	a0,0
    539e:	bfe5                	j	5396 <memcmp+0x38>
    53a0:	4501                	li	a0,0
    53a2:	bfd5                	j	5396 <memcmp+0x38>

00000000000053a4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    53a4:	1141                	addi	sp,sp,-16
    53a6:	e406                	sd	ra,8(sp)
    53a8:	e022                	sd	s0,0(sp)
    53aa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    53ac:	00000097          	auipc	ra,0x0
    53b0:	f56080e7          	jalr	-170(ra) # 5302 <memmove>
}
    53b4:	60a2                	ld	ra,8(sp)
    53b6:	6402                	ld	s0,0(sp)
    53b8:	0141                	addi	sp,sp,16
    53ba:	8082                	ret

00000000000053bc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    53bc:	4885                	li	a7,1
 ecall
    53be:	00000073          	ecall
 ret
    53c2:	8082                	ret

00000000000053c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
    53c4:	4889                	li	a7,2
 ecall
    53c6:	00000073          	ecall
 ret
    53ca:	8082                	ret

00000000000053cc <wait>:
.global wait
wait:
 li a7, SYS_wait
    53cc:	488d                	li	a7,3
 ecall
    53ce:	00000073          	ecall
 ret
    53d2:	8082                	ret

00000000000053d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    53d4:	4891                	li	a7,4
 ecall
    53d6:	00000073          	ecall
 ret
    53da:	8082                	ret

00000000000053dc <read>:
.global read
read:
 li a7, SYS_read
    53dc:	4895                	li	a7,5
 ecall
    53de:	00000073          	ecall
 ret
    53e2:	8082                	ret

00000000000053e4 <write>:
.global write
write:
 li a7, SYS_write
    53e4:	48c1                	li	a7,16
 ecall
    53e6:	00000073          	ecall
 ret
    53ea:	8082                	ret

00000000000053ec <close>:
.global close
close:
 li a7, SYS_close
    53ec:	48d5                	li	a7,21
 ecall
    53ee:	00000073          	ecall
 ret
    53f2:	8082                	ret

00000000000053f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
    53f4:	4899                	li	a7,6
 ecall
    53f6:	00000073          	ecall
 ret
    53fa:	8082                	ret

00000000000053fc <exec>:
.global exec
exec:
 li a7, SYS_exec
    53fc:	489d                	li	a7,7
 ecall
    53fe:	00000073          	ecall
 ret
    5402:	8082                	ret

0000000000005404 <open>:
.global open
open:
 li a7, SYS_open
    5404:	48bd                	li	a7,15
 ecall
    5406:	00000073          	ecall
 ret
    540a:	8082                	ret

000000000000540c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    540c:	48c5                	li	a7,17
 ecall
    540e:	00000073          	ecall
 ret
    5412:	8082                	ret

0000000000005414 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5414:	48c9                	li	a7,18
 ecall
    5416:	00000073          	ecall
 ret
    541a:	8082                	ret

000000000000541c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    541c:	48a1                	li	a7,8
 ecall
    541e:	00000073          	ecall
 ret
    5422:	8082                	ret

0000000000005424 <link>:
.global link
link:
 li a7, SYS_link
    5424:	48cd                	li	a7,19
 ecall
    5426:	00000073          	ecall
 ret
    542a:	8082                	ret

000000000000542c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    542c:	48d1                	li	a7,20
 ecall
    542e:	00000073          	ecall
 ret
    5432:	8082                	ret

0000000000005434 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5434:	48a5                	li	a7,9
 ecall
    5436:	00000073          	ecall
 ret
    543a:	8082                	ret

000000000000543c <dup>:
.global dup
dup:
 li a7, SYS_dup
    543c:	48a9                	li	a7,10
 ecall
    543e:	00000073          	ecall
 ret
    5442:	8082                	ret

0000000000005444 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5444:	48ad                	li	a7,11
 ecall
    5446:	00000073          	ecall
 ret
    544a:	8082                	ret

000000000000544c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    544c:	48b1                	li	a7,12
 ecall
    544e:	00000073          	ecall
 ret
    5452:	8082                	ret

0000000000005454 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5454:	48b5                	li	a7,13
 ecall
    5456:	00000073          	ecall
 ret
    545a:	8082                	ret

000000000000545c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    545c:	48b9                	li	a7,14
 ecall
    545e:	00000073          	ecall
 ret
    5462:	8082                	ret

0000000000005464 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5464:	1101                	addi	sp,sp,-32
    5466:	ec06                	sd	ra,24(sp)
    5468:	e822                	sd	s0,16(sp)
    546a:	1000                	addi	s0,sp,32
    546c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5470:	4605                	li	a2,1
    5472:	fef40593          	addi	a1,s0,-17
    5476:	00000097          	auipc	ra,0x0
    547a:	f6e080e7          	jalr	-146(ra) # 53e4 <write>
}
    547e:	60e2                	ld	ra,24(sp)
    5480:	6442                	ld	s0,16(sp)
    5482:	6105                	addi	sp,sp,32
    5484:	8082                	ret

0000000000005486 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5486:	7139                	addi	sp,sp,-64
    5488:	fc06                	sd	ra,56(sp)
    548a:	f822                	sd	s0,48(sp)
    548c:	f426                	sd	s1,40(sp)
    548e:	f04a                	sd	s2,32(sp)
    5490:	ec4e                	sd	s3,24(sp)
    5492:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5494:	c299                	beqz	a3,549a <printint+0x14>
    5496:	0005cd63          	bltz	a1,54b0 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    549a:	2581                	sext.w	a1,a1
  neg = 0;
    549c:	4301                	li	t1,0
    549e:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
    54a2:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
    54a4:	2601                	sext.w	a2,a2
    54a6:	00003897          	auipc	a7,0x3
    54aa:	a8a88893          	addi	a7,a7,-1398 # 7f30 <digits>
    54ae:	a801                	j	54be <printint+0x38>
    x = -xx;
    54b0:	40b005bb          	negw	a1,a1
    54b4:	2581                	sext.w	a1,a1
    neg = 1;
    54b6:	4305                	li	t1,1
    x = -xx;
    54b8:	b7dd                	j	549e <printint+0x18>
  }while((x /= base) != 0);
    54ba:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
    54bc:	8836                	mv	a6,a3
    54be:	0018069b          	addiw	a3,a6,1
    54c2:	02c5f7bb          	remuw	a5,a1,a2
    54c6:	1782                	slli	a5,a5,0x20
    54c8:	9381                	srli	a5,a5,0x20
    54ca:	97c6                	add	a5,a5,a7
    54cc:	0007c783          	lbu	a5,0(a5)
    54d0:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
    54d4:	0705                	addi	a4,a4,1
    54d6:	02c5d7bb          	divuw	a5,a1,a2
    54da:	fec5f0e3          	bleu	a2,a1,54ba <printint+0x34>
  if(neg)
    54de:	00030b63          	beqz	t1,54f4 <printint+0x6e>
    buf[i++] = '-';
    54e2:	fd040793          	addi	a5,s0,-48
    54e6:	96be                	add	a3,a3,a5
    54e8:	02d00793          	li	a5,45
    54ec:	fef68823          	sb	a5,-16(a3) # ff0 <bigdir+0x74>
    54f0:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
    54f4:	02d05963          	blez	a3,5526 <printint+0xa0>
    54f8:	89aa                	mv	s3,a0
    54fa:	fc040793          	addi	a5,s0,-64
    54fe:	00d784b3          	add	s1,a5,a3
    5502:	fff78913          	addi	s2,a5,-1
    5506:	9936                	add	s2,s2,a3
    5508:	36fd                	addiw	a3,a3,-1
    550a:	1682                	slli	a3,a3,0x20
    550c:	9281                	srli	a3,a3,0x20
    550e:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
    5512:	fff4c583          	lbu	a1,-1(s1)
    5516:	854e                	mv	a0,s3
    5518:	00000097          	auipc	ra,0x0
    551c:	f4c080e7          	jalr	-180(ra) # 5464 <putc>
  while(--i >= 0)
    5520:	14fd                	addi	s1,s1,-1
    5522:	ff2498e3          	bne	s1,s2,5512 <printint+0x8c>
}
    5526:	70e2                	ld	ra,56(sp)
    5528:	7442                	ld	s0,48(sp)
    552a:	74a2                	ld	s1,40(sp)
    552c:	7902                	ld	s2,32(sp)
    552e:	69e2                	ld	s3,24(sp)
    5530:	6121                	addi	sp,sp,64
    5532:	8082                	ret

0000000000005534 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5534:	7119                	addi	sp,sp,-128
    5536:	fc86                	sd	ra,120(sp)
    5538:	f8a2                	sd	s0,112(sp)
    553a:	f4a6                	sd	s1,104(sp)
    553c:	f0ca                	sd	s2,96(sp)
    553e:	ecce                	sd	s3,88(sp)
    5540:	e8d2                	sd	s4,80(sp)
    5542:	e4d6                	sd	s5,72(sp)
    5544:	e0da                	sd	s6,64(sp)
    5546:	fc5e                	sd	s7,56(sp)
    5548:	f862                	sd	s8,48(sp)
    554a:	f466                	sd	s9,40(sp)
    554c:	f06a                	sd	s10,32(sp)
    554e:	ec6e                	sd	s11,24(sp)
    5550:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5552:	0005c483          	lbu	s1,0(a1)
    5556:	18048d63          	beqz	s1,56f0 <vprintf+0x1bc>
    555a:	8aaa                	mv	s5,a0
    555c:	8b32                	mv	s6,a2
    555e:	00158913          	addi	s2,a1,1
  state = 0;
    5562:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5564:	02500a13          	li	s4,37
      if(c == 'd'){
    5568:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    556c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5570:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5574:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5578:	00003b97          	auipc	s7,0x3
    557c:	9b8b8b93          	addi	s7,s7,-1608 # 7f30 <digits>
    5580:	a839                	j	559e <vprintf+0x6a>
        putc(fd, c);
    5582:	85a6                	mv	a1,s1
    5584:	8556                	mv	a0,s5
    5586:	00000097          	auipc	ra,0x0
    558a:	ede080e7          	jalr	-290(ra) # 5464 <putc>
    558e:	a019                	j	5594 <vprintf+0x60>
    } else if(state == '%'){
    5590:	01498f63          	beq	s3,s4,55ae <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5594:	0905                	addi	s2,s2,1
    5596:	fff94483          	lbu	s1,-1(s2)
    559a:	14048b63          	beqz	s1,56f0 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
    559e:	0004879b          	sext.w	a5,s1
    if(state == 0){
    55a2:	fe0997e3          	bnez	s3,5590 <vprintf+0x5c>
      if(c == '%'){
    55a6:	fd479ee3          	bne	a5,s4,5582 <vprintf+0x4e>
        state = '%';
    55aa:	89be                	mv	s3,a5
    55ac:	b7e5                	j	5594 <vprintf+0x60>
      if(c == 'd'){
    55ae:	05878063          	beq	a5,s8,55ee <vprintf+0xba>
      } else if(c == 'l') {
    55b2:	05978c63          	beq	a5,s9,560a <vprintf+0xd6>
      } else if(c == 'x') {
    55b6:	07a78863          	beq	a5,s10,5626 <vprintf+0xf2>
      } else if(c == 'p') {
    55ba:	09b78463          	beq	a5,s11,5642 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    55be:	07300713          	li	a4,115
    55c2:	0ce78563          	beq	a5,a4,568c <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    55c6:	06300713          	li	a4,99
    55ca:	0ee78c63          	beq	a5,a4,56c2 <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    55ce:	11478663          	beq	a5,s4,56da <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    55d2:	85d2                	mv	a1,s4
    55d4:	8556                	mv	a0,s5
    55d6:	00000097          	auipc	ra,0x0
    55da:	e8e080e7          	jalr	-370(ra) # 5464 <putc>
        putc(fd, c);
    55de:	85a6                	mv	a1,s1
    55e0:	8556                	mv	a0,s5
    55e2:	00000097          	auipc	ra,0x0
    55e6:	e82080e7          	jalr	-382(ra) # 5464 <putc>
      }
      state = 0;
    55ea:	4981                	li	s3,0
    55ec:	b765                	j	5594 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    55ee:	008b0493          	addi	s1,s6,8
    55f2:	4685                	li	a3,1
    55f4:	4629                	li	a2,10
    55f6:	000b2583          	lw	a1,0(s6)
    55fa:	8556                	mv	a0,s5
    55fc:	00000097          	auipc	ra,0x0
    5600:	e8a080e7          	jalr	-374(ra) # 5486 <printint>
    5604:	8b26                	mv	s6,s1
      state = 0;
    5606:	4981                	li	s3,0
    5608:	b771                	j	5594 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    560a:	008b0493          	addi	s1,s6,8
    560e:	4681                	li	a3,0
    5610:	4629                	li	a2,10
    5612:	000b2583          	lw	a1,0(s6)
    5616:	8556                	mv	a0,s5
    5618:	00000097          	auipc	ra,0x0
    561c:	e6e080e7          	jalr	-402(ra) # 5486 <printint>
    5620:	8b26                	mv	s6,s1
      state = 0;
    5622:	4981                	li	s3,0
    5624:	bf85                	j	5594 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5626:	008b0493          	addi	s1,s6,8
    562a:	4681                	li	a3,0
    562c:	4641                	li	a2,16
    562e:	000b2583          	lw	a1,0(s6)
    5632:	8556                	mv	a0,s5
    5634:	00000097          	auipc	ra,0x0
    5638:	e52080e7          	jalr	-430(ra) # 5486 <printint>
    563c:	8b26                	mv	s6,s1
      state = 0;
    563e:	4981                	li	s3,0
    5640:	bf91                	j	5594 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5642:	008b0793          	addi	a5,s6,8
    5646:	f8f43423          	sd	a5,-120(s0)
    564a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    564e:	03000593          	li	a1,48
    5652:	8556                	mv	a0,s5
    5654:	00000097          	auipc	ra,0x0
    5658:	e10080e7          	jalr	-496(ra) # 5464 <putc>
  putc(fd, 'x');
    565c:	85ea                	mv	a1,s10
    565e:	8556                	mv	a0,s5
    5660:	00000097          	auipc	ra,0x0
    5664:	e04080e7          	jalr	-508(ra) # 5464 <putc>
    5668:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    566a:	03c9d793          	srli	a5,s3,0x3c
    566e:	97de                	add	a5,a5,s7
    5670:	0007c583          	lbu	a1,0(a5)
    5674:	8556                	mv	a0,s5
    5676:	00000097          	auipc	ra,0x0
    567a:	dee080e7          	jalr	-530(ra) # 5464 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    567e:	0992                	slli	s3,s3,0x4
    5680:	34fd                	addiw	s1,s1,-1
    5682:	f4e5                	bnez	s1,566a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5684:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5688:	4981                	li	s3,0
    568a:	b729                	j	5594 <vprintf+0x60>
        s = va_arg(ap, char*);
    568c:	008b0993          	addi	s3,s6,8
    5690:	000b3483          	ld	s1,0(s6)
        if(s == 0)
    5694:	c085                	beqz	s1,56b4 <vprintf+0x180>
        while(*s != 0){
    5696:	0004c583          	lbu	a1,0(s1)
    569a:	c9a1                	beqz	a1,56ea <vprintf+0x1b6>
          putc(fd, *s);
    569c:	8556                	mv	a0,s5
    569e:	00000097          	auipc	ra,0x0
    56a2:	dc6080e7          	jalr	-570(ra) # 5464 <putc>
          s++;
    56a6:	0485                	addi	s1,s1,1
        while(*s != 0){
    56a8:	0004c583          	lbu	a1,0(s1)
    56ac:	f9e5                	bnez	a1,569c <vprintf+0x168>
        s = va_arg(ap, char*);
    56ae:	8b4e                	mv	s6,s3
      state = 0;
    56b0:	4981                	li	s3,0
    56b2:	b5cd                	j	5594 <vprintf+0x60>
          s = "(null)";
    56b4:	00003497          	auipc	s1,0x3
    56b8:	89448493          	addi	s1,s1,-1900 # 7f48 <digits+0x18>
        while(*s != 0){
    56bc:	02800593          	li	a1,40
    56c0:	bff1                	j	569c <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
    56c2:	008b0493          	addi	s1,s6,8
    56c6:	000b4583          	lbu	a1,0(s6)
    56ca:	8556                	mv	a0,s5
    56cc:	00000097          	auipc	ra,0x0
    56d0:	d98080e7          	jalr	-616(ra) # 5464 <putc>
    56d4:	8b26                	mv	s6,s1
      state = 0;
    56d6:	4981                	li	s3,0
    56d8:	bd75                	j	5594 <vprintf+0x60>
        putc(fd, c);
    56da:	85d2                	mv	a1,s4
    56dc:	8556                	mv	a0,s5
    56de:	00000097          	auipc	ra,0x0
    56e2:	d86080e7          	jalr	-634(ra) # 5464 <putc>
      state = 0;
    56e6:	4981                	li	s3,0
    56e8:	b575                	j	5594 <vprintf+0x60>
        s = va_arg(ap, char*);
    56ea:	8b4e                	mv	s6,s3
      state = 0;
    56ec:	4981                	li	s3,0
    56ee:	b55d                	j	5594 <vprintf+0x60>
    }
  }
}
    56f0:	70e6                	ld	ra,120(sp)
    56f2:	7446                	ld	s0,112(sp)
    56f4:	74a6                	ld	s1,104(sp)
    56f6:	7906                	ld	s2,96(sp)
    56f8:	69e6                	ld	s3,88(sp)
    56fa:	6a46                	ld	s4,80(sp)
    56fc:	6aa6                	ld	s5,72(sp)
    56fe:	6b06                	ld	s6,64(sp)
    5700:	7be2                	ld	s7,56(sp)
    5702:	7c42                	ld	s8,48(sp)
    5704:	7ca2                	ld	s9,40(sp)
    5706:	7d02                	ld	s10,32(sp)
    5708:	6de2                	ld	s11,24(sp)
    570a:	6109                	addi	sp,sp,128
    570c:	8082                	ret

000000000000570e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    570e:	715d                	addi	sp,sp,-80
    5710:	ec06                	sd	ra,24(sp)
    5712:	e822                	sd	s0,16(sp)
    5714:	1000                	addi	s0,sp,32
    5716:	e010                	sd	a2,0(s0)
    5718:	e414                	sd	a3,8(s0)
    571a:	e818                	sd	a4,16(s0)
    571c:	ec1c                	sd	a5,24(s0)
    571e:	03043023          	sd	a6,32(s0)
    5722:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5726:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    572a:	8622                	mv	a2,s0
    572c:	00000097          	auipc	ra,0x0
    5730:	e08080e7          	jalr	-504(ra) # 5534 <vprintf>
}
    5734:	60e2                	ld	ra,24(sp)
    5736:	6442                	ld	s0,16(sp)
    5738:	6161                	addi	sp,sp,80
    573a:	8082                	ret

000000000000573c <printf>:

void
printf(const char *fmt, ...)
{
    573c:	711d                	addi	sp,sp,-96
    573e:	ec06                	sd	ra,24(sp)
    5740:	e822                	sd	s0,16(sp)
    5742:	1000                	addi	s0,sp,32
    5744:	e40c                	sd	a1,8(s0)
    5746:	e810                	sd	a2,16(s0)
    5748:	ec14                	sd	a3,24(s0)
    574a:	f018                	sd	a4,32(s0)
    574c:	f41c                	sd	a5,40(s0)
    574e:	03043823          	sd	a6,48(s0)
    5752:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5756:	00840613          	addi	a2,s0,8
    575a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    575e:	85aa                	mv	a1,a0
    5760:	4505                	li	a0,1
    5762:	00000097          	auipc	ra,0x0
    5766:	dd2080e7          	jalr	-558(ra) # 5534 <vprintf>
}
    576a:	60e2                	ld	ra,24(sp)
    576c:	6442                	ld	s0,16(sp)
    576e:	6125                	addi	sp,sp,96
    5770:	8082                	ret

0000000000005772 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5772:	1141                	addi	sp,sp,-16
    5774:	e422                	sd	s0,8(sp)
    5776:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5778:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    577c:	00002797          	auipc	a5,0x2
    5780:	7ec78793          	addi	a5,a5,2028 # 7f68 <freep>
    5784:	639c                	ld	a5,0(a5)
    5786:	a805                	j	57b6 <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5788:	4618                	lw	a4,8(a2)
    578a:	9db9                	addw	a1,a1,a4
    578c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5790:	6398                	ld	a4,0(a5)
    5792:	6318                	ld	a4,0(a4)
    5794:	fee53823          	sd	a4,-16(a0)
    5798:	a091                	j	57dc <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    579a:	ff852703          	lw	a4,-8(a0)
    579e:	9e39                	addw	a2,a2,a4
    57a0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    57a2:	ff053703          	ld	a4,-16(a0)
    57a6:	e398                	sd	a4,0(a5)
    57a8:	a099                	j	57ee <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    57aa:	6398                	ld	a4,0(a5)
    57ac:	00e7e463          	bltu	a5,a4,57b4 <free+0x42>
    57b0:	00e6ea63          	bltu	a3,a4,57c4 <free+0x52>
{
    57b4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    57b6:	fed7fae3          	bleu	a3,a5,57aa <free+0x38>
    57ba:	6398                	ld	a4,0(a5)
    57bc:	00e6e463          	bltu	a3,a4,57c4 <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    57c0:	fee7eae3          	bltu	a5,a4,57b4 <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
    57c4:	ff852583          	lw	a1,-8(a0)
    57c8:	6390                	ld	a2,0(a5)
    57ca:	02059713          	slli	a4,a1,0x20
    57ce:	9301                	srli	a4,a4,0x20
    57d0:	0712                	slli	a4,a4,0x4
    57d2:	9736                	add	a4,a4,a3
    57d4:	fae60ae3          	beq	a2,a4,5788 <free+0x16>
    bp->s.ptr = p->s.ptr;
    57d8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    57dc:	4790                	lw	a2,8(a5)
    57de:	02061713          	slli	a4,a2,0x20
    57e2:	9301                	srli	a4,a4,0x20
    57e4:	0712                	slli	a4,a4,0x4
    57e6:	973e                	add	a4,a4,a5
    57e8:	fae689e3          	beq	a3,a4,579a <free+0x28>
  } else
    p->s.ptr = bp;
    57ec:	e394                	sd	a3,0(a5)
  freep = p;
    57ee:	00002717          	auipc	a4,0x2
    57f2:	76f73d23          	sd	a5,1914(a4) # 7f68 <freep>
}
    57f6:	6422                	ld	s0,8(sp)
    57f8:	0141                	addi	sp,sp,16
    57fa:	8082                	ret

00000000000057fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    57fc:	7139                	addi	sp,sp,-64
    57fe:	fc06                	sd	ra,56(sp)
    5800:	f822                	sd	s0,48(sp)
    5802:	f426                	sd	s1,40(sp)
    5804:	f04a                	sd	s2,32(sp)
    5806:	ec4e                	sd	s3,24(sp)
    5808:	e852                	sd	s4,16(sp)
    580a:	e456                	sd	s5,8(sp)
    580c:	e05a                	sd	s6,0(sp)
    580e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5810:	02051993          	slli	s3,a0,0x20
    5814:	0209d993          	srli	s3,s3,0x20
    5818:	09bd                	addi	s3,s3,15
    581a:	0049d993          	srli	s3,s3,0x4
    581e:	2985                	addiw	s3,s3,1
    5820:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
    5824:	00002797          	auipc	a5,0x2
    5828:	74478793          	addi	a5,a5,1860 # 7f68 <freep>
    582c:	6388                	ld	a0,0(a5)
    582e:	c515                	beqz	a0,585a <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5830:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5832:	4798                	lw	a4,8(a5)
    5834:	03277f63          	bleu	s2,a4,5872 <malloc+0x76>
    5838:	8a4e                	mv	s4,s3
    583a:	0009871b          	sext.w	a4,s3
    583e:	6685                	lui	a3,0x1
    5840:	00d77363          	bleu	a3,a4,5846 <malloc+0x4a>
    5844:	6a05                	lui	s4,0x1
    5846:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
    584a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    584e:	00002497          	auipc	s1,0x2
    5852:	71a48493          	addi	s1,s1,1818 # 7f68 <freep>
  if(p == (char*)-1)
    5856:	5b7d                	li	s6,-1
    5858:	a885                	j	58c8 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
    585a:	00009797          	auipc	a5,0x9
    585e:	f2e78793          	addi	a5,a5,-210 # e788 <base>
    5862:	00002717          	auipc	a4,0x2
    5866:	70f73323          	sd	a5,1798(a4) # 7f68 <freep>
    586a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    586c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5870:	b7e1                	j	5838 <malloc+0x3c>
      if(p->s.size == nunits)
    5872:	02e90b63          	beq	s2,a4,58a8 <malloc+0xac>
        p->s.size -= nunits;
    5876:	4137073b          	subw	a4,a4,s3
    587a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    587c:	1702                	slli	a4,a4,0x20
    587e:	9301                	srli	a4,a4,0x20
    5880:	0712                	slli	a4,a4,0x4
    5882:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5884:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5888:	00002717          	auipc	a4,0x2
    588c:	6ea73023          	sd	a0,1760(a4) # 7f68 <freep>
      return (void*)(p + 1);
    5890:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5894:	70e2                	ld	ra,56(sp)
    5896:	7442                	ld	s0,48(sp)
    5898:	74a2                	ld	s1,40(sp)
    589a:	7902                	ld	s2,32(sp)
    589c:	69e2                	ld	s3,24(sp)
    589e:	6a42                	ld	s4,16(sp)
    58a0:	6aa2                	ld	s5,8(sp)
    58a2:	6b02                	ld	s6,0(sp)
    58a4:	6121                	addi	sp,sp,64
    58a6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    58a8:	6398                	ld	a4,0(a5)
    58aa:	e118                	sd	a4,0(a0)
    58ac:	bff1                	j	5888 <malloc+0x8c>
  hp->s.size = nu;
    58ae:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
    58b2:	0541                	addi	a0,a0,16
    58b4:	00000097          	auipc	ra,0x0
    58b8:	ebe080e7          	jalr	-322(ra) # 5772 <free>
  return freep;
    58bc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    58be:	d979                	beqz	a0,5894 <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    58c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    58c2:	4798                	lw	a4,8(a5)
    58c4:	fb2777e3          	bleu	s2,a4,5872 <malloc+0x76>
    if(p == freep)
    58c8:	6098                	ld	a4,0(s1)
    58ca:	853e                	mv	a0,a5
    58cc:	fef71ae3          	bne	a4,a5,58c0 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
    58d0:	8552                	mv	a0,s4
    58d2:	00000097          	auipc	ra,0x0
    58d6:	b7a080e7          	jalr	-1158(ra) # 544c <sbrk>
  if(p == (char*)-1)
    58da:	fd651ae3          	bne	a0,s6,58ae <malloc+0xb2>
        return 0;
    58de:	4501                	li	a0,0
    58e0:	bf55                	j	5894 <malloc+0x98>
