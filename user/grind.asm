
user/_grind：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1d495>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <__global_pointer$+0x231f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd664>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00001517          	auipc	a0,0x1
      64:	62850513          	addi	a0,a0,1576 # 1688 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	e74080e7          	jalr	-396(ra) # f04 <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	30650513          	addi	a0,a0,774 # 13a0 <malloc+0xec>
      a2:	00001097          	auipc	ra,0x1
      a6:	e42080e7          	jalr	-446(ra) # ee4 <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	2f650513          	addi	a0,a0,758 # 13a0 <malloc+0xec>
      b2:	00001097          	auipc	ra,0x1
      b6:	e3a080e7          	jalr	-454(ra) # eec <chdir>
      ba:	cd11                	beqz	a0,d6 <go+0x5e>
    printf("chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	2ec50513          	addi	a0,a0,748 # 13a8 <malloc+0xf4>
      c4:	00001097          	auipc	ra,0x1
      c8:	130080e7          	jalr	304(ra) # 11f4 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	dae080e7          	jalr	-594(ra) # e7c <exit>
  }
  chdir("/");
      d6:	00001517          	auipc	a0,0x1
      da:	2ea50513          	addi	a0,a0,746 # 13c0 <malloc+0x10c>
      de:	00001097          	auipc	ra,0x1
      e2:	e0e080e7          	jalr	-498(ra) # eec <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      e6:	00001917          	auipc	s2,0x1
      ea:	2ea90913          	addi	s2,s2,746 # 13d0 <malloc+0x11c>
      ee:	c489                	beqz	s1,f8 <go+0x80>
      f0:	00001917          	auipc	s2,0x1
      f4:	2d890913          	addi	s2,s2,728 # 13c8 <malloc+0x114>
    iters++;
      f8:	4485                	li	s1,1
  int fd = -1;
      fa:	59fd                	li	s3,-1
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 15){
      sbrk(6011);
      fc:	6a05                	lui	s4,0x1
      fe:	77ba0a13          	addi	s4,s4,1915 # 177b <buf.1251+0xe3>
     102:	a825                	j	13a <go+0xc2>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     104:	20200593          	li	a1,514
     108:	00001517          	auipc	a0,0x1
     10c:	2d050513          	addi	a0,a0,720 # 13d8 <malloc+0x124>
     110:	00001097          	auipc	ra,0x1
     114:	dac080e7          	jalr	-596(ra) # ebc <open>
     118:	00001097          	auipc	ra,0x1
     11c:	d8c080e7          	jalr	-628(ra) # ea4 <close>
    iters++;
     120:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     122:	1f400793          	li	a5,500
     126:	02f4f7b3          	remu	a5,s1,a5
     12a:	eb81                	bnez	a5,13a <go+0xc2>
      write(1, which_child?"B":"A", 1);
     12c:	4605                	li	a2,1
     12e:	85ca                	mv	a1,s2
     130:	4505                	li	a0,1
     132:	00001097          	auipc	ra,0x1
     136:	d6a080e7          	jalr	-662(ra) # e9c <write>
    int what = rand() % 23;
     13a:	00000097          	auipc	ra,0x0
     13e:	f1e080e7          	jalr	-226(ra) # 58 <rand>
     142:	47dd                	li	a5,23
     144:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     148:	4785                	li	a5,1
     14a:	faf50de3          	beq	a0,a5,104 <go+0x8c>
    } else if(what == 2){
     14e:	4789                	li	a5,2
     150:	18f50063          	beq	a0,a5,2d0 <go+0x258>
    } else if(what == 3){
     154:	478d                	li	a5,3
     156:	18f50c63          	beq	a0,a5,2ee <go+0x276>
    } else if(what == 4){
     15a:	4791                	li	a5,4
     15c:	1af50263          	beq	a0,a5,300 <go+0x288>
    } else if(what == 5){
     160:	4795                	li	a5,5
     162:	1ef50663          	beq	a0,a5,34e <go+0x2d6>
    } else if(what == 6){
     166:	4799                	li	a5,6
     168:	20f50463          	beq	a0,a5,370 <go+0x2f8>
    } else if(what == 7){
     16c:	479d                	li	a5,7
     16e:	22f50263          	beq	a0,a5,392 <go+0x31a>
    } else if(what == 8){
     172:	47a1                	li	a5,8
     174:	22f50b63          	beq	a0,a5,3aa <go+0x332>
    } else if(what == 9){
     178:	47a5                	li	a5,9
     17a:	24f50463          	beq	a0,a5,3c2 <go+0x34a>
    } else if(what == 10){
     17e:	47a9                	li	a5,10
     180:	28f50063          	beq	a0,a5,400 <go+0x388>
    } else if(what == 11){
     184:	47ad                	li	a5,11
     186:	2af50c63          	beq	a0,a5,43e <go+0x3c6>
    } else if(what == 12){
     18a:	47b1                	li	a5,12
     18c:	2cf50e63          	beq	a0,a5,468 <go+0x3f0>
    } else if(what == 13){
     190:	47b5                	li	a5,13
     192:	30f50063          	beq	a0,a5,492 <go+0x41a>
    } else if(what == 14){
     196:	47b9                	li	a5,14
     198:	32f50b63          	beq	a0,a5,4ce <go+0x456>
    } else if(what == 15){
     19c:	47bd                	li	a5,15
     19e:	36f50f63          	beq	a0,a5,51c <go+0x4a4>
    } else if(what == 16){
     1a2:	47c1                	li	a5,16
     1a4:	38f50263          	beq	a0,a5,528 <go+0x4b0>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     1a8:	47c5                	li	a5,17
     1aa:	3af50263          	beq	a0,a5,54e <go+0x4d6>
        printf("chdir failed\n");
        exit(1);
      }
      kill(pid);
      wait(0);
    } else if(what == 18){
     1ae:	47c9                	li	a5,18
     1b0:	42f50863          	beq	a0,a5,5e0 <go+0x568>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 19){
     1b4:	47cd                	li	a5,19
     1b6:	46f50c63          	beq	a0,a5,62e <go+0x5b6>
        exit(1);
      }
      close(fds[0]);
      close(fds[1]);
      wait(0);
    } else if(what == 20){
     1ba:	47d1                	li	a5,20
     1bc:	54f50d63          	beq	a0,a5,716 <go+0x69e>
      } else if(pid < 0){
        printf("fork failed\n");
        exit(1);
      }
      wait(0);
    } else if(what == 21){
     1c0:	47d5                	li	a5,21
     1c2:	5ef50b63          	beq	a0,a5,7b8 <go+0x740>
        printf("fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     1c6:	47d9                	li	a5,22
     1c8:	f4f51ce3          	bne	a0,a5,120 <go+0xa8>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1cc:	f9840513          	addi	a0,s0,-104
     1d0:	00001097          	auipc	ra,0x1
     1d4:	cbc080e7          	jalr	-836(ra) # e8c <pipe>
     1d8:	6e054463          	bltz	a0,8c0 <go+0x848>
        fprintf(2, "pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     1dc:	fa040513          	addi	a0,s0,-96
     1e0:	00001097          	auipc	ra,0x1
     1e4:	cac080e7          	jalr	-852(ra) # e8c <pipe>
     1e8:	6e054a63          	bltz	a0,8dc <go+0x864>
        fprintf(2, "pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     1ec:	00001097          	auipc	ra,0x1
     1f0:	c88080e7          	jalr	-888(ra) # e74 <fork>
      if(pid1 == 0){
     1f4:	70050263          	beqz	a0,8f8 <go+0x880>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     1f8:	7a054a63          	bltz	a0,9ac <go+0x934>
        fprintf(2, "fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     1fc:	00001097          	auipc	ra,0x1
     200:	c78080e7          	jalr	-904(ra) # e74 <fork>
      if(pid2 == 0){
     204:	7c050263          	beqz	a0,9c8 <go+0x950>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     208:	08054ee3          	bltz	a0,aa4 <go+0xa2c>
        fprintf(2, "fork failed\n");
        exit(7);
      }
      close(aa[0]);
     20c:	f9842503          	lw	a0,-104(s0)
     210:	00001097          	auipc	ra,0x1
     214:	c94080e7          	jalr	-876(ra) # ea4 <close>
      close(aa[1]);
     218:	f9c42503          	lw	a0,-100(s0)
     21c:	00001097          	auipc	ra,0x1
     220:	c88080e7          	jalr	-888(ra) # ea4 <close>
      close(bb[1]);
     224:	fa442503          	lw	a0,-92(s0)
     228:	00001097          	auipc	ra,0x1
     22c:	c7c080e7          	jalr	-900(ra) # ea4 <close>
      char buf[3] = { 0, 0, 0 };
     230:	f8040823          	sb	zero,-112(s0)
     234:	f80408a3          	sb	zero,-111(s0)
     238:	f8040923          	sb	zero,-110(s0)
      read(bb[0], buf+0, 1);
     23c:	4605                	li	a2,1
     23e:	f9040593          	addi	a1,s0,-112
     242:	fa042503          	lw	a0,-96(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	c4e080e7          	jalr	-946(ra) # e94 <read>
      read(bb[0], buf+1, 1);
     24e:	4605                	li	a2,1
     250:	f9140593          	addi	a1,s0,-111
     254:	fa042503          	lw	a0,-96(s0)
     258:	00001097          	auipc	ra,0x1
     25c:	c3c080e7          	jalr	-964(ra) # e94 <read>
      close(bb[0]);
     260:	fa042503          	lw	a0,-96(s0)
     264:	00001097          	auipc	ra,0x1
     268:	c40080e7          	jalr	-960(ra) # ea4 <close>
      int st1, st2;
      wait(&st1);
     26c:	f9440513          	addi	a0,s0,-108
     270:	00001097          	auipc	ra,0x1
     274:	c14080e7          	jalr	-1004(ra) # e84 <wait>
      wait(&st2);
     278:	fa840513          	addi	a0,s0,-88
     27c:	00001097          	auipc	ra,0x1
     280:	c08080e7          	jalr	-1016(ra) # e84 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi") != 0){
     284:	f9442783          	lw	a5,-108(s0)
     288:	fa842703          	lw	a4,-88(s0)
     28c:	8fd9                	or	a5,a5,a4
     28e:	2781                	sext.w	a5,a5
     290:	ef89                	bnez	a5,2aa <go+0x232>
     292:	00001597          	auipc	a1,0x1
     296:	35e58593          	addi	a1,a1,862 # 15f0 <malloc+0x33c>
     29a:	f9040513          	addi	a0,s0,-112
     29e:	00001097          	auipc	ra,0x1
     2a2:	96a080e7          	jalr	-1686(ra) # c08 <strcmp>
     2a6:	e6050de3          	beqz	a0,120 <go+0xa8>
        printf("exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     2aa:	f9040693          	addi	a3,s0,-112
     2ae:	fa842603          	lw	a2,-88(s0)
     2b2:	f9442583          	lw	a1,-108(s0)
     2b6:	00001517          	auipc	a0,0x1
     2ba:	38a50513          	addi	a0,a0,906 # 1640 <malloc+0x38c>
     2be:	00001097          	auipc	ra,0x1
     2c2:	f36080e7          	jalr	-202(ra) # 11f4 <printf>
        exit(1);
     2c6:	4505                	li	a0,1
     2c8:	00001097          	auipc	ra,0x1
     2cc:	bb4080e7          	jalr	-1100(ra) # e7c <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     2d0:	20200593          	li	a1,514
     2d4:	00001517          	auipc	a0,0x1
     2d8:	11450513          	addi	a0,a0,276 # 13e8 <malloc+0x134>
     2dc:	00001097          	auipc	ra,0x1
     2e0:	be0080e7          	jalr	-1056(ra) # ebc <open>
     2e4:	00001097          	auipc	ra,0x1
     2e8:	bc0080e7          	jalr	-1088(ra) # ea4 <close>
     2ec:	bd15                	j	120 <go+0xa8>
      unlink("grindir/../a");
     2ee:	00001517          	auipc	a0,0x1
     2f2:	0ea50513          	addi	a0,a0,234 # 13d8 <malloc+0x124>
     2f6:	00001097          	auipc	ra,0x1
     2fa:	bd6080e7          	jalr	-1066(ra) # ecc <unlink>
     2fe:	b50d                	j	120 <go+0xa8>
      if(chdir("grindir") != 0){
     300:	00001517          	auipc	a0,0x1
     304:	0a050513          	addi	a0,a0,160 # 13a0 <malloc+0xec>
     308:	00001097          	auipc	ra,0x1
     30c:	be4080e7          	jalr	-1052(ra) # eec <chdir>
     310:	e115                	bnez	a0,334 <go+0x2bc>
      unlink("../b");
     312:	00001517          	auipc	a0,0x1
     316:	0ee50513          	addi	a0,a0,238 # 1400 <malloc+0x14c>
     31a:	00001097          	auipc	ra,0x1
     31e:	bb2080e7          	jalr	-1102(ra) # ecc <unlink>
      chdir("/");
     322:	00001517          	auipc	a0,0x1
     326:	09e50513          	addi	a0,a0,158 # 13c0 <malloc+0x10c>
     32a:	00001097          	auipc	ra,0x1
     32e:	bc2080e7          	jalr	-1086(ra) # eec <chdir>
     332:	b3fd                	j	120 <go+0xa8>
        printf("chdir grindir failed\n");
     334:	00001517          	auipc	a0,0x1
     338:	07450513          	addi	a0,a0,116 # 13a8 <malloc+0xf4>
     33c:	00001097          	auipc	ra,0x1
     340:	eb8080e7          	jalr	-328(ra) # 11f4 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00001097          	auipc	ra,0x1
     34a:	b36080e7          	jalr	-1226(ra) # e7c <exit>
      close(fd);
     34e:	854e                	mv	a0,s3
     350:	00001097          	auipc	ra,0x1
     354:	b54080e7          	jalr	-1196(ra) # ea4 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     358:	20200593          	li	a1,514
     35c:	00001517          	auipc	a0,0x1
     360:	0ac50513          	addi	a0,a0,172 # 1408 <malloc+0x154>
     364:	00001097          	auipc	ra,0x1
     368:	b58080e7          	jalr	-1192(ra) # ebc <open>
     36c:	89aa                	mv	s3,a0
     36e:	bb4d                	j	120 <go+0xa8>
      close(fd);
     370:	854e                	mv	a0,s3
     372:	00001097          	auipc	ra,0x1
     376:	b32080e7          	jalr	-1230(ra) # ea4 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     37a:	20200593          	li	a1,514
     37e:	00001517          	auipc	a0,0x1
     382:	09a50513          	addi	a0,a0,154 # 1418 <malloc+0x164>
     386:	00001097          	auipc	ra,0x1
     38a:	b36080e7          	jalr	-1226(ra) # ebc <open>
     38e:	89aa                	mv	s3,a0
     390:	bb41                	j	120 <go+0xa8>
      write(fd, buf, sizeof(buf));
     392:	3e700613          	li	a2,999
     396:	00001597          	auipc	a1,0x1
     39a:	30258593          	addi	a1,a1,770 # 1698 <buf.1251>
     39e:	854e                	mv	a0,s3
     3a0:	00001097          	auipc	ra,0x1
     3a4:	afc080e7          	jalr	-1284(ra) # e9c <write>
     3a8:	bba5                	j	120 <go+0xa8>
      read(fd, buf, sizeof(buf));
     3aa:	3e700613          	li	a2,999
     3ae:	00001597          	auipc	a1,0x1
     3b2:	2ea58593          	addi	a1,a1,746 # 1698 <buf.1251>
     3b6:	854e                	mv	a0,s3
     3b8:	00001097          	auipc	ra,0x1
     3bc:	adc080e7          	jalr	-1316(ra) # e94 <read>
     3c0:	b385                	j	120 <go+0xa8>
      mkdir("grindir/../a");
     3c2:	00001517          	auipc	a0,0x1
     3c6:	01650513          	addi	a0,a0,22 # 13d8 <malloc+0x124>
     3ca:	00001097          	auipc	ra,0x1
     3ce:	b1a080e7          	jalr	-1254(ra) # ee4 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     3d2:	20200593          	li	a1,514
     3d6:	00001517          	auipc	a0,0x1
     3da:	05a50513          	addi	a0,a0,90 # 1430 <malloc+0x17c>
     3de:	00001097          	auipc	ra,0x1
     3e2:	ade080e7          	jalr	-1314(ra) # ebc <open>
     3e6:	00001097          	auipc	ra,0x1
     3ea:	abe080e7          	jalr	-1346(ra) # ea4 <close>
      unlink("a/a");
     3ee:	00001517          	auipc	a0,0x1
     3f2:	05250513          	addi	a0,a0,82 # 1440 <malloc+0x18c>
     3f6:	00001097          	auipc	ra,0x1
     3fa:	ad6080e7          	jalr	-1322(ra) # ecc <unlink>
     3fe:	b30d                	j	120 <go+0xa8>
      mkdir("/../b");
     400:	00001517          	auipc	a0,0x1
     404:	04850513          	addi	a0,a0,72 # 1448 <malloc+0x194>
     408:	00001097          	auipc	ra,0x1
     40c:	adc080e7          	jalr	-1316(ra) # ee4 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     410:	20200593          	li	a1,514
     414:	00001517          	auipc	a0,0x1
     418:	03c50513          	addi	a0,a0,60 # 1450 <malloc+0x19c>
     41c:	00001097          	auipc	ra,0x1
     420:	aa0080e7          	jalr	-1376(ra) # ebc <open>
     424:	00001097          	auipc	ra,0x1
     428:	a80080e7          	jalr	-1408(ra) # ea4 <close>
      unlink("b/b");
     42c:	00001517          	auipc	a0,0x1
     430:	03450513          	addi	a0,a0,52 # 1460 <malloc+0x1ac>
     434:	00001097          	auipc	ra,0x1
     438:	a98080e7          	jalr	-1384(ra) # ecc <unlink>
     43c:	b1d5                	j	120 <go+0xa8>
      unlink("b");
     43e:	00001517          	auipc	a0,0x1
     442:	fea50513          	addi	a0,a0,-22 # 1428 <malloc+0x174>
     446:	00001097          	auipc	ra,0x1
     44a:	a86080e7          	jalr	-1402(ra) # ecc <unlink>
      link("../grindir/./../a", "../b");
     44e:	00001597          	auipc	a1,0x1
     452:	fb258593          	addi	a1,a1,-78 # 1400 <malloc+0x14c>
     456:	00001517          	auipc	a0,0x1
     45a:	01250513          	addi	a0,a0,18 # 1468 <malloc+0x1b4>
     45e:	00001097          	auipc	ra,0x1
     462:	a7e080e7          	jalr	-1410(ra) # edc <link>
     466:	b96d                	j	120 <go+0xa8>
      unlink("../grindir/../a");
     468:	00001517          	auipc	a0,0x1
     46c:	01850513          	addi	a0,a0,24 # 1480 <malloc+0x1cc>
     470:	00001097          	auipc	ra,0x1
     474:	a5c080e7          	jalr	-1444(ra) # ecc <unlink>
      link(".././b", "/grindir/../a");
     478:	00001597          	auipc	a1,0x1
     47c:	f9058593          	addi	a1,a1,-112 # 1408 <malloc+0x154>
     480:	00001517          	auipc	a0,0x1
     484:	01050513          	addi	a0,a0,16 # 1490 <malloc+0x1dc>
     488:	00001097          	auipc	ra,0x1
     48c:	a54080e7          	jalr	-1452(ra) # edc <link>
     490:	b941                	j	120 <go+0xa8>
      int pid = fork();
     492:	00001097          	auipc	ra,0x1
     496:	9e2080e7          	jalr	-1566(ra) # e74 <fork>
      if(pid == 0){
     49a:	c909                	beqz	a0,4ac <go+0x434>
      } else if(pid < 0){
     49c:	00054c63          	bltz	a0,4b4 <go+0x43c>
      wait(0);
     4a0:	4501                	li	a0,0
     4a2:	00001097          	auipc	ra,0x1
     4a6:	9e2080e7          	jalr	-1566(ra) # e84 <wait>
     4aa:	b99d                	j	120 <go+0xa8>
        exit(0);
     4ac:	00001097          	auipc	ra,0x1
     4b0:	9d0080e7          	jalr	-1584(ra) # e7c <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	fe450513          	addi	a0,a0,-28 # 1498 <malloc+0x1e4>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	d38080e7          	jalr	-712(ra) # 11f4 <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	9b6080e7          	jalr	-1610(ra) # e7c <exit>
      int pid = fork();
     4ce:	00001097          	auipc	ra,0x1
     4d2:	9a6080e7          	jalr	-1626(ra) # e74 <fork>
      if(pid == 0){
     4d6:	c909                	beqz	a0,4e8 <go+0x470>
      } else if(pid < 0){
     4d8:	02054563          	bltz	a0,502 <go+0x48a>
      wait(0);
     4dc:	4501                	li	a0,0
     4de:	00001097          	auipc	ra,0x1
     4e2:	9a6080e7          	jalr	-1626(ra) # e84 <wait>
     4e6:	b92d                	j	120 <go+0xa8>
        fork();
     4e8:	00001097          	auipc	ra,0x1
     4ec:	98c080e7          	jalr	-1652(ra) # e74 <fork>
        fork();
     4f0:	00001097          	auipc	ra,0x1
     4f4:	984080e7          	jalr	-1660(ra) # e74 <fork>
        exit(0);
     4f8:	4501                	li	a0,0
     4fa:	00001097          	auipc	ra,0x1
     4fe:	982080e7          	jalr	-1662(ra) # e7c <exit>
        printf("grind: fork failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	f9650513          	addi	a0,a0,-106 # 1498 <malloc+0x1e4>
     50a:	00001097          	auipc	ra,0x1
     50e:	cea080e7          	jalr	-790(ra) # 11f4 <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	968080e7          	jalr	-1688(ra) # e7c <exit>
      sbrk(6011);
     51c:	8552                	mv	a0,s4
     51e:	00001097          	auipc	ra,0x1
     522:	9e6080e7          	jalr	-1562(ra) # f04 <sbrk>
     526:	beed                	j	120 <go+0xa8>
      if(sbrk(0) > break0)
     528:	4501                	li	a0,0
     52a:	00001097          	auipc	ra,0x1
     52e:	9da080e7          	jalr	-1574(ra) # f04 <sbrk>
     532:	beaaf7e3          	bleu	a0,s5,120 <go+0xa8>
        sbrk(-(sbrk(0) - break0));
     536:	4501                	li	a0,0
     538:	00001097          	auipc	ra,0x1
     53c:	9cc080e7          	jalr	-1588(ra) # f04 <sbrk>
     540:	40aa853b          	subw	a0,s5,a0
     544:	00001097          	auipc	ra,0x1
     548:	9c0080e7          	jalr	-1600(ra) # f04 <sbrk>
     54c:	bed1                	j	120 <go+0xa8>
      int pid = fork();
     54e:	00001097          	auipc	ra,0x1
     552:	926080e7          	jalr	-1754(ra) # e74 <fork>
     556:	8b2a                	mv	s6,a0
      if(pid == 0){
     558:	c51d                	beqz	a0,586 <go+0x50e>
      } else if(pid < 0){
     55a:	04054963          	bltz	a0,5ac <go+0x534>
      if(chdir("../grindir/..") != 0){
     55e:	00001517          	auipc	a0,0x1
     562:	f5250513          	addi	a0,a0,-174 # 14b0 <malloc+0x1fc>
     566:	00001097          	auipc	ra,0x1
     56a:	986080e7          	jalr	-1658(ra) # eec <chdir>
     56e:	ed21                	bnez	a0,5c6 <go+0x54e>
      kill(pid);
     570:	855a                	mv	a0,s6
     572:	00001097          	auipc	ra,0x1
     576:	93a080e7          	jalr	-1734(ra) # eac <kill>
      wait(0);
     57a:	4501                	li	a0,0
     57c:	00001097          	auipc	ra,0x1
     580:	908080e7          	jalr	-1784(ra) # e84 <wait>
     584:	be71                	j	120 <go+0xa8>
        close(open("a", O_CREATE|O_RDWR));
     586:	20200593          	li	a1,514
     58a:	00001517          	auipc	a0,0x1
     58e:	eee50513          	addi	a0,a0,-274 # 1478 <malloc+0x1c4>
     592:	00001097          	auipc	ra,0x1
     596:	92a080e7          	jalr	-1750(ra) # ebc <open>
     59a:	00001097          	auipc	ra,0x1
     59e:	90a080e7          	jalr	-1782(ra) # ea4 <close>
        exit(0);
     5a2:	4501                	li	a0,0
     5a4:	00001097          	auipc	ra,0x1
     5a8:	8d8080e7          	jalr	-1832(ra) # e7c <exit>
        printf("grind: fork failed\n");
     5ac:	00001517          	auipc	a0,0x1
     5b0:	eec50513          	addi	a0,a0,-276 # 1498 <malloc+0x1e4>
     5b4:	00001097          	auipc	ra,0x1
     5b8:	c40080e7          	jalr	-960(ra) # 11f4 <printf>
        exit(1);
     5bc:	4505                	li	a0,1
     5be:	00001097          	auipc	ra,0x1
     5c2:	8be080e7          	jalr	-1858(ra) # e7c <exit>
        printf("chdir failed\n");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	efa50513          	addi	a0,a0,-262 # 14c0 <malloc+0x20c>
     5ce:	00001097          	auipc	ra,0x1
     5d2:	c26080e7          	jalr	-986(ra) # 11f4 <printf>
        exit(1);
     5d6:	4505                	li	a0,1
     5d8:	00001097          	auipc	ra,0x1
     5dc:	8a4080e7          	jalr	-1884(ra) # e7c <exit>
      int pid = fork();
     5e0:	00001097          	auipc	ra,0x1
     5e4:	894080e7          	jalr	-1900(ra) # e74 <fork>
      if(pid == 0){
     5e8:	c909                	beqz	a0,5fa <go+0x582>
      } else if(pid < 0){
     5ea:	02054563          	bltz	a0,614 <go+0x59c>
      wait(0);
     5ee:	4501                	li	a0,0
     5f0:	00001097          	auipc	ra,0x1
     5f4:	894080e7          	jalr	-1900(ra) # e84 <wait>
     5f8:	b625                	j	120 <go+0xa8>
        kill(getpid());
     5fa:	00001097          	auipc	ra,0x1
     5fe:	902080e7          	jalr	-1790(ra) # efc <getpid>
     602:	00001097          	auipc	ra,0x1
     606:	8aa080e7          	jalr	-1878(ra) # eac <kill>
        exit(0);
     60a:	4501                	li	a0,0
     60c:	00001097          	auipc	ra,0x1
     610:	870080e7          	jalr	-1936(ra) # e7c <exit>
        printf("grind: fork failed\n");
     614:	00001517          	auipc	a0,0x1
     618:	e8450513          	addi	a0,a0,-380 # 1498 <malloc+0x1e4>
     61c:	00001097          	auipc	ra,0x1
     620:	bd8080e7          	jalr	-1064(ra) # 11f4 <printf>
        exit(1);
     624:	4505                	li	a0,1
     626:	00001097          	auipc	ra,0x1
     62a:	856080e7          	jalr	-1962(ra) # e7c <exit>
      if(pipe(fds) < 0){
     62e:	fa840513          	addi	a0,s0,-88
     632:	00001097          	auipc	ra,0x1
     636:	85a080e7          	jalr	-1958(ra) # e8c <pipe>
     63a:	02054b63          	bltz	a0,670 <go+0x5f8>
      int pid = fork();
     63e:	00001097          	auipc	ra,0x1
     642:	836080e7          	jalr	-1994(ra) # e74 <fork>
      if(pid == 0){
     646:	c131                	beqz	a0,68a <go+0x612>
      } else if(pid < 0){
     648:	0a054a63          	bltz	a0,6fc <go+0x684>
      close(fds[0]);
     64c:	fa842503          	lw	a0,-88(s0)
     650:	00001097          	auipc	ra,0x1
     654:	854080e7          	jalr	-1964(ra) # ea4 <close>
      close(fds[1]);
     658:	fac42503          	lw	a0,-84(s0)
     65c:	00001097          	auipc	ra,0x1
     660:	848080e7          	jalr	-1976(ra) # ea4 <close>
      wait(0);
     664:	4501                	li	a0,0
     666:	00001097          	auipc	ra,0x1
     66a:	81e080e7          	jalr	-2018(ra) # e84 <wait>
     66e:	bc4d                	j	120 <go+0xa8>
        printf("grind: pipe failed\n");
     670:	00001517          	auipc	a0,0x1
     674:	e6050513          	addi	a0,a0,-416 # 14d0 <malloc+0x21c>
     678:	00001097          	auipc	ra,0x1
     67c:	b7c080e7          	jalr	-1156(ra) # 11f4 <printf>
        exit(1);
     680:	4505                	li	a0,1
     682:	00000097          	auipc	ra,0x0
     686:	7fa080e7          	jalr	2042(ra) # e7c <exit>
        fork();
     68a:	00000097          	auipc	ra,0x0
     68e:	7ea080e7          	jalr	2026(ra) # e74 <fork>
        fork();
     692:	00000097          	auipc	ra,0x0
     696:	7e2080e7          	jalr	2018(ra) # e74 <fork>
        if(write(fds[1], "x", 1) != 1)
     69a:	4605                	li	a2,1
     69c:	00001597          	auipc	a1,0x1
     6a0:	e4c58593          	addi	a1,a1,-436 # 14e8 <malloc+0x234>
     6a4:	fac42503          	lw	a0,-84(s0)
     6a8:	00000097          	auipc	ra,0x0
     6ac:	7f4080e7          	jalr	2036(ra) # e9c <write>
     6b0:	4785                	li	a5,1
     6b2:	02f51363          	bne	a0,a5,6d8 <go+0x660>
        if(read(fds[0], &c, 1) != 1)
     6b6:	4605                	li	a2,1
     6b8:	fa040593          	addi	a1,s0,-96
     6bc:	fa842503          	lw	a0,-88(s0)
     6c0:	00000097          	auipc	ra,0x0
     6c4:	7d4080e7          	jalr	2004(ra) # e94 <read>
     6c8:	4785                	li	a5,1
     6ca:	02f51063          	bne	a0,a5,6ea <go+0x672>
        exit(0);
     6ce:	4501                	li	a0,0
     6d0:	00000097          	auipc	ra,0x0
     6d4:	7ac080e7          	jalr	1964(ra) # e7c <exit>
          printf("grind: pipe write failed\n");
     6d8:	00001517          	auipc	a0,0x1
     6dc:	e1850513          	addi	a0,a0,-488 # 14f0 <malloc+0x23c>
     6e0:	00001097          	auipc	ra,0x1
     6e4:	b14080e7          	jalr	-1260(ra) # 11f4 <printf>
     6e8:	b7f9                	j	6b6 <go+0x63e>
          printf("grind: pipe read failed\n");
     6ea:	00001517          	auipc	a0,0x1
     6ee:	e2650513          	addi	a0,a0,-474 # 1510 <malloc+0x25c>
     6f2:	00001097          	auipc	ra,0x1
     6f6:	b02080e7          	jalr	-1278(ra) # 11f4 <printf>
     6fa:	bfd1                	j	6ce <go+0x656>
        printf("grind: fork failed\n");
     6fc:	00001517          	auipc	a0,0x1
     700:	d9c50513          	addi	a0,a0,-612 # 1498 <malloc+0x1e4>
     704:	00001097          	auipc	ra,0x1
     708:	af0080e7          	jalr	-1296(ra) # 11f4 <printf>
        exit(1);
     70c:	4505                	li	a0,1
     70e:	00000097          	auipc	ra,0x0
     712:	76e080e7          	jalr	1902(ra) # e7c <exit>
      int pid = fork();
     716:	00000097          	auipc	ra,0x0
     71a:	75e080e7          	jalr	1886(ra) # e74 <fork>
      if(pid == 0){
     71e:	c909                	beqz	a0,730 <go+0x6b8>
      } else if(pid < 0){
     720:	06054f63          	bltz	a0,79e <go+0x726>
      wait(0);
     724:	4501                	li	a0,0
     726:	00000097          	auipc	ra,0x0
     72a:	75e080e7          	jalr	1886(ra) # e84 <wait>
     72e:	bacd                	j	120 <go+0xa8>
        unlink("a");
     730:	00001517          	auipc	a0,0x1
     734:	d4850513          	addi	a0,a0,-696 # 1478 <malloc+0x1c4>
     738:	00000097          	auipc	ra,0x0
     73c:	794080e7          	jalr	1940(ra) # ecc <unlink>
        mkdir("a");
     740:	00001517          	auipc	a0,0x1
     744:	d3850513          	addi	a0,a0,-712 # 1478 <malloc+0x1c4>
     748:	00000097          	auipc	ra,0x0
     74c:	79c080e7          	jalr	1948(ra) # ee4 <mkdir>
        chdir("a");
     750:	00001517          	auipc	a0,0x1
     754:	d2850513          	addi	a0,a0,-728 # 1478 <malloc+0x1c4>
     758:	00000097          	auipc	ra,0x0
     75c:	794080e7          	jalr	1940(ra) # eec <chdir>
        unlink("../a");
     760:	00001517          	auipc	a0,0x1
     764:	c8050513          	addi	a0,a0,-896 # 13e0 <malloc+0x12c>
     768:	00000097          	auipc	ra,0x0
     76c:	764080e7          	jalr	1892(ra) # ecc <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     770:	20200593          	li	a1,514
     774:	00001517          	auipc	a0,0x1
     778:	d7450513          	addi	a0,a0,-652 # 14e8 <malloc+0x234>
     77c:	00000097          	auipc	ra,0x0
     780:	740080e7          	jalr	1856(ra) # ebc <open>
        unlink("x");
     784:	00001517          	auipc	a0,0x1
     788:	d6450513          	addi	a0,a0,-668 # 14e8 <malloc+0x234>
     78c:	00000097          	auipc	ra,0x0
     790:	740080e7          	jalr	1856(ra) # ecc <unlink>
        exit(0);
     794:	4501                	li	a0,0
     796:	00000097          	auipc	ra,0x0
     79a:	6e6080e7          	jalr	1766(ra) # e7c <exit>
        printf("fork failed\n");
     79e:	00001517          	auipc	a0,0x1
     7a2:	d9250513          	addi	a0,a0,-622 # 1530 <malloc+0x27c>
     7a6:	00001097          	auipc	ra,0x1
     7aa:	a4e080e7          	jalr	-1458(ra) # 11f4 <printf>
        exit(1);
     7ae:	4505                	li	a0,1
     7b0:	00000097          	auipc	ra,0x0
     7b4:	6cc080e7          	jalr	1740(ra) # e7c <exit>
      unlink("c");
     7b8:	00001517          	auipc	a0,0x1
     7bc:	d8850513          	addi	a0,a0,-632 # 1540 <malloc+0x28c>
     7c0:	00000097          	auipc	ra,0x0
     7c4:	70c080e7          	jalr	1804(ra) # ecc <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     7c8:	20200593          	li	a1,514
     7cc:	00001517          	auipc	a0,0x1
     7d0:	d7450513          	addi	a0,a0,-652 # 1540 <malloc+0x28c>
     7d4:	00000097          	auipc	ra,0x0
     7d8:	6e8080e7          	jalr	1768(ra) # ebc <open>
     7dc:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     7de:	04054f63          	bltz	a0,83c <go+0x7c4>
      if(write(fd1, "x", 1) != 1){
     7e2:	4605                	li	a2,1
     7e4:	00001597          	auipc	a1,0x1
     7e8:	d0458593          	addi	a1,a1,-764 # 14e8 <malloc+0x234>
     7ec:	00000097          	auipc	ra,0x0
     7f0:	6b0080e7          	jalr	1712(ra) # e9c <write>
     7f4:	4785                	li	a5,1
     7f6:	06f51063          	bne	a0,a5,856 <go+0x7de>
      if(fstat(fd1, &st) != 0){
     7fa:	fa840593          	addi	a1,s0,-88
     7fe:	855a                	mv	a0,s6
     800:	00000097          	auipc	ra,0x0
     804:	6d4080e7          	jalr	1748(ra) # ed4 <fstat>
     808:	e525                	bnez	a0,870 <go+0x7f8>
      if(st.size != 1){
     80a:	fb843583          	ld	a1,-72(s0)
     80e:	4785                	li	a5,1
     810:	06f59d63          	bne	a1,a5,88a <go+0x812>
      if(st.ino > 200){
     814:	fac42583          	lw	a1,-84(s0)
     818:	0c800793          	li	a5,200
     81c:	08b7e563          	bltu	a5,a1,8a6 <go+0x82e>
      close(fd1);
     820:	855a                	mv	a0,s6
     822:	00000097          	auipc	ra,0x0
     826:	682080e7          	jalr	1666(ra) # ea4 <close>
      unlink("c");
     82a:	00001517          	auipc	a0,0x1
     82e:	d1650513          	addi	a0,a0,-746 # 1540 <malloc+0x28c>
     832:	00000097          	auipc	ra,0x0
     836:	69a080e7          	jalr	1690(ra) # ecc <unlink>
     83a:	b0dd                	j	120 <go+0xa8>
        printf("create c failed\n");
     83c:	00001517          	auipc	a0,0x1
     840:	d0c50513          	addi	a0,a0,-756 # 1548 <malloc+0x294>
     844:	00001097          	auipc	ra,0x1
     848:	9b0080e7          	jalr	-1616(ra) # 11f4 <printf>
        exit(1);
     84c:	4505                	li	a0,1
     84e:	00000097          	auipc	ra,0x0
     852:	62e080e7          	jalr	1582(ra) # e7c <exit>
        printf("write c failed\n");
     856:	00001517          	auipc	a0,0x1
     85a:	d0a50513          	addi	a0,a0,-758 # 1560 <malloc+0x2ac>
     85e:	00001097          	auipc	ra,0x1
     862:	996080e7          	jalr	-1642(ra) # 11f4 <printf>
        exit(1);
     866:	4505                	li	a0,1
     868:	00000097          	auipc	ra,0x0
     86c:	614080e7          	jalr	1556(ra) # e7c <exit>
        printf("fstat failed\n");
     870:	00001517          	auipc	a0,0x1
     874:	d0050513          	addi	a0,a0,-768 # 1570 <malloc+0x2bc>
     878:	00001097          	auipc	ra,0x1
     87c:	97c080e7          	jalr	-1668(ra) # 11f4 <printf>
        exit(1);
     880:	4505                	li	a0,1
     882:	00000097          	auipc	ra,0x0
     886:	5fa080e7          	jalr	1530(ra) # e7c <exit>
        printf("fstat reports wrong size %d\n", (int)st.size);
     88a:	2581                	sext.w	a1,a1
     88c:	00001517          	auipc	a0,0x1
     890:	cf450513          	addi	a0,a0,-780 # 1580 <malloc+0x2cc>
     894:	00001097          	auipc	ra,0x1
     898:	960080e7          	jalr	-1696(ra) # 11f4 <printf>
        exit(1);
     89c:	4505                	li	a0,1
     89e:	00000097          	auipc	ra,0x0
     8a2:	5de080e7          	jalr	1502(ra) # e7c <exit>
        printf("fstat reports crazy i-number %d\n", st.ino);
     8a6:	00001517          	auipc	a0,0x1
     8aa:	cfa50513          	addi	a0,a0,-774 # 15a0 <malloc+0x2ec>
     8ae:	00001097          	auipc	ra,0x1
     8b2:	946080e7          	jalr	-1722(ra) # 11f4 <printf>
        exit(1);
     8b6:	4505                	li	a0,1
     8b8:	00000097          	auipc	ra,0x0
     8bc:	5c4080e7          	jalr	1476(ra) # e7c <exit>
        fprintf(2, "pipe failed\n");
     8c0:	00001597          	auipc	a1,0x1
     8c4:	d0858593          	addi	a1,a1,-760 # 15c8 <malloc+0x314>
     8c8:	4509                	li	a0,2
     8ca:	00001097          	auipc	ra,0x1
     8ce:	8fc080e7          	jalr	-1796(ra) # 11c6 <fprintf>
        exit(1);
     8d2:	4505                	li	a0,1
     8d4:	00000097          	auipc	ra,0x0
     8d8:	5a8080e7          	jalr	1448(ra) # e7c <exit>
        fprintf(2, "pipe failed\n");
     8dc:	00001597          	auipc	a1,0x1
     8e0:	cec58593          	addi	a1,a1,-788 # 15c8 <malloc+0x314>
     8e4:	4509                	li	a0,2
     8e6:	00001097          	auipc	ra,0x1
     8ea:	8e0080e7          	jalr	-1824(ra) # 11c6 <fprintf>
        exit(1);
     8ee:	4505                	li	a0,1
     8f0:	00000097          	auipc	ra,0x0
     8f4:	58c080e7          	jalr	1420(ra) # e7c <exit>
        close(bb[0]);
     8f8:	fa042503          	lw	a0,-96(s0)
     8fc:	00000097          	auipc	ra,0x0
     900:	5a8080e7          	jalr	1448(ra) # ea4 <close>
        close(bb[1]);
     904:	fa442503          	lw	a0,-92(s0)
     908:	00000097          	auipc	ra,0x0
     90c:	59c080e7          	jalr	1436(ra) # ea4 <close>
        close(aa[0]);
     910:	f9842503          	lw	a0,-104(s0)
     914:	00000097          	auipc	ra,0x0
     918:	590080e7          	jalr	1424(ra) # ea4 <close>
        close(1);
     91c:	4505                	li	a0,1
     91e:	00000097          	auipc	ra,0x0
     922:	586080e7          	jalr	1414(ra) # ea4 <close>
        if(dup(aa[1]) != 1){
     926:	f9c42503          	lw	a0,-100(s0)
     92a:	00000097          	auipc	ra,0x0
     92e:	5ca080e7          	jalr	1482(ra) # ef4 <dup>
     932:	4785                	li	a5,1
     934:	02f50063          	beq	a0,a5,954 <go+0x8dc>
          fprintf(2, "dup failed\n");
     938:	00001597          	auipc	a1,0x1
     93c:	ca058593          	addi	a1,a1,-864 # 15d8 <malloc+0x324>
     940:	4509                	li	a0,2
     942:	00001097          	auipc	ra,0x1
     946:	884080e7          	jalr	-1916(ra) # 11c6 <fprintf>
          exit(1);
     94a:	4505                	li	a0,1
     94c:	00000097          	auipc	ra,0x0
     950:	530080e7          	jalr	1328(ra) # e7c <exit>
        close(aa[1]);
     954:	f9c42503          	lw	a0,-100(s0)
     958:	00000097          	auipc	ra,0x0
     95c:	54c080e7          	jalr	1356(ra) # ea4 <close>
        char *args[3] = { "echo", "hi", 0 };
     960:	00001797          	auipc	a5,0x1
     964:	c8878793          	addi	a5,a5,-888 # 15e8 <malloc+0x334>
     968:	faf43423          	sd	a5,-88(s0)
     96c:	00001797          	auipc	a5,0x1
     970:	c8478793          	addi	a5,a5,-892 # 15f0 <malloc+0x33c>
     974:	faf43823          	sd	a5,-80(s0)
     978:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     97c:	fa840593          	addi	a1,s0,-88
     980:	00001517          	auipc	a0,0x1
     984:	c7850513          	addi	a0,a0,-904 # 15f8 <malloc+0x344>
     988:	00000097          	auipc	ra,0x0
     98c:	52c080e7          	jalr	1324(ra) # eb4 <exec>
        fprintf(2, "echo: not found\n");
     990:	00001597          	auipc	a1,0x1
     994:	c7858593          	addi	a1,a1,-904 # 1608 <malloc+0x354>
     998:	4509                	li	a0,2
     99a:	00001097          	auipc	ra,0x1
     99e:	82c080e7          	jalr	-2004(ra) # 11c6 <fprintf>
        exit(2);
     9a2:	4509                	li	a0,2
     9a4:	00000097          	auipc	ra,0x0
     9a8:	4d8080e7          	jalr	1240(ra) # e7c <exit>
        fprintf(2, "fork failed\n");
     9ac:	00001597          	auipc	a1,0x1
     9b0:	b8458593          	addi	a1,a1,-1148 # 1530 <malloc+0x27c>
     9b4:	4509                	li	a0,2
     9b6:	00001097          	auipc	ra,0x1
     9ba:	810080e7          	jalr	-2032(ra) # 11c6 <fprintf>
        exit(3);
     9be:	450d                	li	a0,3
     9c0:	00000097          	auipc	ra,0x0
     9c4:	4bc080e7          	jalr	1212(ra) # e7c <exit>
        close(aa[1]);
     9c8:	f9c42503          	lw	a0,-100(s0)
     9cc:	00000097          	auipc	ra,0x0
     9d0:	4d8080e7          	jalr	1240(ra) # ea4 <close>
        close(bb[0]);
     9d4:	fa042503          	lw	a0,-96(s0)
     9d8:	00000097          	auipc	ra,0x0
     9dc:	4cc080e7          	jalr	1228(ra) # ea4 <close>
        close(0);
     9e0:	4501                	li	a0,0
     9e2:	00000097          	auipc	ra,0x0
     9e6:	4c2080e7          	jalr	1218(ra) # ea4 <close>
        if(dup(aa[0]) != 0){
     9ea:	f9842503          	lw	a0,-104(s0)
     9ee:	00000097          	auipc	ra,0x0
     9f2:	506080e7          	jalr	1286(ra) # ef4 <dup>
     9f6:	cd19                	beqz	a0,a14 <go+0x99c>
          fprintf(2, "dup failed\n");
     9f8:	00001597          	auipc	a1,0x1
     9fc:	be058593          	addi	a1,a1,-1056 # 15d8 <malloc+0x324>
     a00:	4509                	li	a0,2
     a02:	00000097          	auipc	ra,0x0
     a06:	7c4080e7          	jalr	1988(ra) # 11c6 <fprintf>
          exit(4);
     a0a:	4511                	li	a0,4
     a0c:	00000097          	auipc	ra,0x0
     a10:	470080e7          	jalr	1136(ra) # e7c <exit>
        close(aa[0]);
     a14:	f9842503          	lw	a0,-104(s0)
     a18:	00000097          	auipc	ra,0x0
     a1c:	48c080e7          	jalr	1164(ra) # ea4 <close>
        close(1);
     a20:	4505                	li	a0,1
     a22:	00000097          	auipc	ra,0x0
     a26:	482080e7          	jalr	1154(ra) # ea4 <close>
        if(dup(bb[1]) != 1){
     a2a:	fa442503          	lw	a0,-92(s0)
     a2e:	00000097          	auipc	ra,0x0
     a32:	4c6080e7          	jalr	1222(ra) # ef4 <dup>
     a36:	4785                	li	a5,1
     a38:	02f50063          	beq	a0,a5,a58 <go+0x9e0>
          fprintf(2, "dup failed\n");
     a3c:	00001597          	auipc	a1,0x1
     a40:	b9c58593          	addi	a1,a1,-1124 # 15d8 <malloc+0x324>
     a44:	4509                	li	a0,2
     a46:	00000097          	auipc	ra,0x0
     a4a:	780080e7          	jalr	1920(ra) # 11c6 <fprintf>
          exit(5);
     a4e:	4515                	li	a0,5
     a50:	00000097          	auipc	ra,0x0
     a54:	42c080e7          	jalr	1068(ra) # e7c <exit>
        close(bb[1]);
     a58:	fa442503          	lw	a0,-92(s0)
     a5c:	00000097          	auipc	ra,0x0
     a60:	448080e7          	jalr	1096(ra) # ea4 <close>
        char *args[2] = { "cat", 0 };
     a64:	00001797          	auipc	a5,0x1
     a68:	bbc78793          	addi	a5,a5,-1092 # 1620 <malloc+0x36c>
     a6c:	faf43423          	sd	a5,-88(s0)
     a70:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a74:	fa840593          	addi	a1,s0,-88
     a78:	00001517          	auipc	a0,0x1
     a7c:	bb050513          	addi	a0,a0,-1104 # 1628 <malloc+0x374>
     a80:	00000097          	auipc	ra,0x0
     a84:	434080e7          	jalr	1076(ra) # eb4 <exec>
        fprintf(2, "cat: not found\n");
     a88:	00001597          	auipc	a1,0x1
     a8c:	ba858593          	addi	a1,a1,-1112 # 1630 <malloc+0x37c>
     a90:	4509                	li	a0,2
     a92:	00000097          	auipc	ra,0x0
     a96:	734080e7          	jalr	1844(ra) # 11c6 <fprintf>
        exit(6);
     a9a:	4519                	li	a0,6
     a9c:	00000097          	auipc	ra,0x0
     aa0:	3e0080e7          	jalr	992(ra) # e7c <exit>
        fprintf(2, "fork failed\n");
     aa4:	00001597          	auipc	a1,0x1
     aa8:	a8c58593          	addi	a1,a1,-1396 # 1530 <malloc+0x27c>
     aac:	4509                	li	a0,2
     aae:	00000097          	auipc	ra,0x0
     ab2:	718080e7          	jalr	1816(ra) # 11c6 <fprintf>
        exit(7);
     ab6:	451d                	li	a0,7
     ab8:	00000097          	auipc	ra,0x0
     abc:	3c4080e7          	jalr	964(ra) # e7c <exit>

0000000000000ac0 <iter>:
  }
}

void
iter()
{
     ac0:	7179                	addi	sp,sp,-48
     ac2:	f406                	sd	ra,40(sp)
     ac4:	f022                	sd	s0,32(sp)
     ac6:	ec26                	sd	s1,24(sp)
     ac8:	e84a                	sd	s2,16(sp)
     aca:	1800                	addi	s0,sp,48
  unlink("a");
     acc:	00001517          	auipc	a0,0x1
     ad0:	9ac50513          	addi	a0,a0,-1620 # 1478 <malloc+0x1c4>
     ad4:	00000097          	auipc	ra,0x0
     ad8:	3f8080e7          	jalr	1016(ra) # ecc <unlink>
  unlink("b");
     adc:	00001517          	auipc	a0,0x1
     ae0:	94c50513          	addi	a0,a0,-1716 # 1428 <malloc+0x174>
     ae4:	00000097          	auipc	ra,0x0
     ae8:	3e8080e7          	jalr	1000(ra) # ecc <unlink>
  
  int pid1 = fork();
     aec:	00000097          	auipc	ra,0x0
     af0:	388080e7          	jalr	904(ra) # e74 <fork>
  if(pid1 < 0){
     af4:	00054e63          	bltz	a0,b10 <iter+0x50>
     af8:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     afa:	e905                	bnez	a0,b2a <iter+0x6a>
    rand_next = 31;
     afc:	47fd                	li	a5,31
     afe:	00001717          	auipc	a4,0x1
     b02:	b8f73523          	sd	a5,-1142(a4) # 1688 <rand_next>
    go(0);
     b06:	4501                	li	a0,0
     b08:	fffff097          	auipc	ra,0xfffff
     b0c:	570080e7          	jalr	1392(ra) # 78 <go>
    printf("grind: fork failed\n");
     b10:	00001517          	auipc	a0,0x1
     b14:	98850513          	addi	a0,a0,-1656 # 1498 <malloc+0x1e4>
     b18:	00000097          	auipc	ra,0x0
     b1c:	6dc080e7          	jalr	1756(ra) # 11f4 <printf>
    exit(1);
     b20:	4505                	li	a0,1
     b22:	00000097          	auipc	ra,0x0
     b26:	35a080e7          	jalr	858(ra) # e7c <exit>
    exit(0);
  }

  int pid2 = fork();
     b2a:	00000097          	auipc	ra,0x0
     b2e:	34a080e7          	jalr	842(ra) # e74 <fork>
     b32:	892a                	mv	s2,a0
  if(pid2 < 0){
     b34:	00054f63          	bltz	a0,b52 <iter+0x92>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b38:	e915                	bnez	a0,b6c <iter+0xac>
    rand_next = 7177;
     b3a:	6789                	lui	a5,0x2
     b3c:	c0978793          	addi	a5,a5,-1015 # 1c09 <_end+0x179>
     b40:	00001717          	auipc	a4,0x1
     b44:	b4f73423          	sd	a5,-1208(a4) # 1688 <rand_next>
    go(1);
     b48:	4505                	li	a0,1
     b4a:	fffff097          	auipc	ra,0xfffff
     b4e:	52e080e7          	jalr	1326(ra) # 78 <go>
    printf("grind: fork failed\n");
     b52:	00001517          	auipc	a0,0x1
     b56:	94650513          	addi	a0,a0,-1722 # 1498 <malloc+0x1e4>
     b5a:	00000097          	auipc	ra,0x0
     b5e:	69a080e7          	jalr	1690(ra) # 11f4 <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00000097          	auipc	ra,0x0
     b68:	318080e7          	jalr	792(ra) # e7c <exit>
    exit(0);
  }

  int st1 = -1;
     b6c:	57fd                	li	a5,-1
     b6e:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b72:	fdc40513          	addi	a0,s0,-36
     b76:	00000097          	auipc	ra,0x0
     b7a:	30e080e7          	jalr	782(ra) # e84 <wait>
  if(st1 != 0){
     b7e:	fdc42783          	lw	a5,-36(s0)
     b82:	ef99                	bnez	a5,ba0 <iter+0xe0>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b84:	57fd                	li	a5,-1
     b86:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b8a:	fd840513          	addi	a0,s0,-40
     b8e:	00000097          	auipc	ra,0x0
     b92:	2f6080e7          	jalr	758(ra) # e84 <wait>

  exit(0);
     b96:	4501                	li	a0,0
     b98:	00000097          	auipc	ra,0x0
     b9c:	2e4080e7          	jalr	740(ra) # e7c <exit>
    kill(pid1);
     ba0:	8526                	mv	a0,s1
     ba2:	00000097          	auipc	ra,0x0
     ba6:	30a080e7          	jalr	778(ra) # eac <kill>
    kill(pid2);
     baa:	854a                	mv	a0,s2
     bac:	00000097          	auipc	ra,0x0
     bb0:	300080e7          	jalr	768(ra) # eac <kill>
     bb4:	bfc1                	j	b84 <iter+0xc4>

0000000000000bb6 <main>:
}

int
main()
{
     bb6:	1141                	addi	sp,sp,-16
     bb8:	e406                	sd	ra,8(sp)
     bba:	e022                	sd	s0,0(sp)
     bbc:	0800                	addi	s0,sp,16
     bbe:	a811                	j	bd2 <main+0x1c>
  while(1){
    int pid = fork();
    if(pid == 0){
      iter();
     bc0:	00000097          	auipc	ra,0x0
     bc4:	f00080e7          	jalr	-256(ra) # ac0 <iter>
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     bc8:	4551                	li	a0,20
     bca:	00000097          	auipc	ra,0x0
     bce:	342080e7          	jalr	834(ra) # f0c <sleep>
    int pid = fork();
     bd2:	00000097          	auipc	ra,0x0
     bd6:	2a2080e7          	jalr	674(ra) # e74 <fork>
    if(pid == 0){
     bda:	d17d                	beqz	a0,bc0 <main+0xa>
    if(pid > 0){
     bdc:	fea056e3          	blez	a0,bc8 <main+0x12>
      wait(0);
     be0:	4501                	li	a0,0
     be2:	00000097          	auipc	ra,0x0
     be6:	2a2080e7          	jalr	674(ra) # e84 <wait>
     bea:	bff9                	j	bc8 <main+0x12>

0000000000000bec <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     bec:	1141                	addi	sp,sp,-16
     bee:	e422                	sd	s0,8(sp)
     bf0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bf2:	87aa                	mv	a5,a0
     bf4:	0585                	addi	a1,a1,1
     bf6:	0785                	addi	a5,a5,1
     bf8:	fff5c703          	lbu	a4,-1(a1)
     bfc:	fee78fa3          	sb	a4,-1(a5)
     c00:	fb75                	bnez	a4,bf4 <strcpy+0x8>
    ;
  return os;
}
     c02:	6422                	ld	s0,8(sp)
     c04:	0141                	addi	sp,sp,16
     c06:	8082                	ret

0000000000000c08 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c08:	1141                	addi	sp,sp,-16
     c0a:	e422                	sd	s0,8(sp)
     c0c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c0e:	00054783          	lbu	a5,0(a0)
     c12:	cf91                	beqz	a5,c2e <strcmp+0x26>
     c14:	0005c703          	lbu	a4,0(a1)
     c18:	00f71b63          	bne	a4,a5,c2e <strcmp+0x26>
    p++, q++;
     c1c:	0505                	addi	a0,a0,1
     c1e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c20:	00054783          	lbu	a5,0(a0)
     c24:	c789                	beqz	a5,c2e <strcmp+0x26>
     c26:	0005c703          	lbu	a4,0(a1)
     c2a:	fef709e3          	beq	a4,a5,c1c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     c2e:	0005c503          	lbu	a0,0(a1)
}
     c32:	40a7853b          	subw	a0,a5,a0
     c36:	6422                	ld	s0,8(sp)
     c38:	0141                	addi	sp,sp,16
     c3a:	8082                	ret

0000000000000c3c <strlen>:

uint
strlen(const char *s)
{
     c3c:	1141                	addi	sp,sp,-16
     c3e:	e422                	sd	s0,8(sp)
     c40:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c42:	00054783          	lbu	a5,0(a0)
     c46:	cf91                	beqz	a5,c62 <strlen+0x26>
     c48:	0505                	addi	a0,a0,1
     c4a:	87aa                	mv	a5,a0
     c4c:	4685                	li	a3,1
     c4e:	9e89                	subw	a3,a3,a0
     c50:	00f6853b          	addw	a0,a3,a5
     c54:	0785                	addi	a5,a5,1
     c56:	fff7c703          	lbu	a4,-1(a5)
     c5a:	fb7d                	bnez	a4,c50 <strlen+0x14>
    ;
  return n;
}
     c5c:	6422                	ld	s0,8(sp)
     c5e:	0141                	addi	sp,sp,16
     c60:	8082                	ret
  for(n = 0; s[n]; n++)
     c62:	4501                	li	a0,0
     c64:	bfe5                	j	c5c <strlen+0x20>

0000000000000c66 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c66:	1141                	addi	sp,sp,-16
     c68:	e422                	sd	s0,8(sp)
     c6a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c6c:	ce09                	beqz	a2,c86 <memset+0x20>
     c6e:	87aa                	mv	a5,a0
     c70:	fff6071b          	addiw	a4,a2,-1
     c74:	1702                	slli	a4,a4,0x20
     c76:	9301                	srli	a4,a4,0x20
     c78:	0705                	addi	a4,a4,1
     c7a:	972a                	add	a4,a4,a0
    cdst[i] = c;
     c7c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c80:	0785                	addi	a5,a5,1
     c82:	fee79de3          	bne	a5,a4,c7c <memset+0x16>
  }
  return dst;
}
     c86:	6422                	ld	s0,8(sp)
     c88:	0141                	addi	sp,sp,16
     c8a:	8082                	ret

0000000000000c8c <strchr>:

char*
strchr(const char *s, char c)
{
     c8c:	1141                	addi	sp,sp,-16
     c8e:	e422                	sd	s0,8(sp)
     c90:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c92:	00054783          	lbu	a5,0(a0)
     c96:	cf91                	beqz	a5,cb2 <strchr+0x26>
    if(*s == c)
     c98:	00f58a63          	beq	a1,a5,cac <strchr+0x20>
  for(; *s; s++)
     c9c:	0505                	addi	a0,a0,1
     c9e:	00054783          	lbu	a5,0(a0)
     ca2:	c781                	beqz	a5,caa <strchr+0x1e>
    if(*s == c)
     ca4:	feb79ce3          	bne	a5,a1,c9c <strchr+0x10>
     ca8:	a011                	j	cac <strchr+0x20>
      return (char*)s;
  return 0;
     caa:	4501                	li	a0,0
}
     cac:	6422                	ld	s0,8(sp)
     cae:	0141                	addi	sp,sp,16
     cb0:	8082                	ret
  return 0;
     cb2:	4501                	li	a0,0
     cb4:	bfe5                	j	cac <strchr+0x20>

0000000000000cb6 <gets>:

char*
gets(char *buf, int max)
{
     cb6:	711d                	addi	sp,sp,-96
     cb8:	ec86                	sd	ra,88(sp)
     cba:	e8a2                	sd	s0,80(sp)
     cbc:	e4a6                	sd	s1,72(sp)
     cbe:	e0ca                	sd	s2,64(sp)
     cc0:	fc4e                	sd	s3,56(sp)
     cc2:	f852                	sd	s4,48(sp)
     cc4:	f456                	sd	s5,40(sp)
     cc6:	f05a                	sd	s6,32(sp)
     cc8:	ec5e                	sd	s7,24(sp)
     cca:	1080                	addi	s0,sp,96
     ccc:	8baa                	mv	s7,a0
     cce:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cd0:	892a                	mv	s2,a0
     cd2:	4981                	li	s3,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     cd4:	4aa9                	li	s5,10
     cd6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cd8:	0019849b          	addiw	s1,s3,1
     cdc:	0344d863          	ble	s4,s1,d0c <gets+0x56>
    cc = read(0, &c, 1);
     ce0:	4605                	li	a2,1
     ce2:	faf40593          	addi	a1,s0,-81
     ce6:	4501                	li	a0,0
     ce8:	00000097          	auipc	ra,0x0
     cec:	1ac080e7          	jalr	428(ra) # e94 <read>
    if(cc < 1)
     cf0:	00a05e63          	blez	a0,d0c <gets+0x56>
    buf[i++] = c;
     cf4:	faf44783          	lbu	a5,-81(s0)
     cf8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cfc:	01578763          	beq	a5,s5,d0a <gets+0x54>
     d00:	0905                	addi	s2,s2,1
  for(i=0; i+1 < max; ){
     d02:	89a6                	mv	s3,s1
    if(c == '\n' || c == '\r')
     d04:	fd679ae3          	bne	a5,s6,cd8 <gets+0x22>
     d08:	a011                	j	d0c <gets+0x56>
  for(i=0; i+1 < max; ){
     d0a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     d0c:	99de                	add	s3,s3,s7
     d0e:	00098023          	sb	zero,0(s3)
  return buf;
}
     d12:	855e                	mv	a0,s7
     d14:	60e6                	ld	ra,88(sp)
     d16:	6446                	ld	s0,80(sp)
     d18:	64a6                	ld	s1,72(sp)
     d1a:	6906                	ld	s2,64(sp)
     d1c:	79e2                	ld	s3,56(sp)
     d1e:	7a42                	ld	s4,48(sp)
     d20:	7aa2                	ld	s5,40(sp)
     d22:	7b02                	ld	s6,32(sp)
     d24:	6be2                	ld	s7,24(sp)
     d26:	6125                	addi	sp,sp,96
     d28:	8082                	ret

0000000000000d2a <stat>:

int
stat(const char *n, struct stat *st)
{
     d2a:	1101                	addi	sp,sp,-32
     d2c:	ec06                	sd	ra,24(sp)
     d2e:	e822                	sd	s0,16(sp)
     d30:	e426                	sd	s1,8(sp)
     d32:	e04a                	sd	s2,0(sp)
     d34:	1000                	addi	s0,sp,32
     d36:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d38:	4581                	li	a1,0
     d3a:	00000097          	auipc	ra,0x0
     d3e:	182080e7          	jalr	386(ra) # ebc <open>
  if(fd < 0)
     d42:	02054563          	bltz	a0,d6c <stat+0x42>
     d46:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d48:	85ca                	mv	a1,s2
     d4a:	00000097          	auipc	ra,0x0
     d4e:	18a080e7          	jalr	394(ra) # ed4 <fstat>
     d52:	892a                	mv	s2,a0
  close(fd);
     d54:	8526                	mv	a0,s1
     d56:	00000097          	auipc	ra,0x0
     d5a:	14e080e7          	jalr	334(ra) # ea4 <close>
  return r;
}
     d5e:	854a                	mv	a0,s2
     d60:	60e2                	ld	ra,24(sp)
     d62:	6442                	ld	s0,16(sp)
     d64:	64a2                	ld	s1,8(sp)
     d66:	6902                	ld	s2,0(sp)
     d68:	6105                	addi	sp,sp,32
     d6a:	8082                	ret
    return -1;
     d6c:	597d                	li	s2,-1
     d6e:	bfc5                	j	d5e <stat+0x34>

0000000000000d70 <atoi>:

int
atoi(const char *s)
{
     d70:	1141                	addi	sp,sp,-16
     d72:	e422                	sd	s0,8(sp)
     d74:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d76:	00054683          	lbu	a3,0(a0)
     d7a:	fd06879b          	addiw	a5,a3,-48
     d7e:	0ff7f793          	andi	a5,a5,255
     d82:	4725                	li	a4,9
     d84:	02f76963          	bltu	a4,a5,db6 <atoi+0x46>
     d88:	862a                	mv	a2,a0
  n = 0;
     d8a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     d8c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     d8e:	0605                	addi	a2,a2,1
     d90:	0025179b          	slliw	a5,a0,0x2
     d94:	9fa9                	addw	a5,a5,a0
     d96:	0017979b          	slliw	a5,a5,0x1
     d9a:	9fb5                	addw	a5,a5,a3
     d9c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     da0:	00064683          	lbu	a3,0(a2)
     da4:	fd06871b          	addiw	a4,a3,-48
     da8:	0ff77713          	andi	a4,a4,255
     dac:	fee5f1e3          	bleu	a4,a1,d8e <atoi+0x1e>
  return n;
}
     db0:	6422                	ld	s0,8(sp)
     db2:	0141                	addi	sp,sp,16
     db4:	8082                	ret
  n = 0;
     db6:	4501                	li	a0,0
     db8:	bfe5                	j	db0 <atoi+0x40>

0000000000000dba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     dba:	1141                	addi	sp,sp,-16
     dbc:	e422                	sd	s0,8(sp)
     dbe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     dc0:	02b57663          	bleu	a1,a0,dec <memmove+0x32>
    while(n-- > 0)
     dc4:	02c05163          	blez	a2,de6 <memmove+0x2c>
     dc8:	fff6079b          	addiw	a5,a2,-1
     dcc:	1782                	slli	a5,a5,0x20
     dce:	9381                	srli	a5,a5,0x20
     dd0:	0785                	addi	a5,a5,1
     dd2:	97aa                	add	a5,a5,a0
  dst = vdst;
     dd4:	872a                	mv	a4,a0
      *dst++ = *src++;
     dd6:	0585                	addi	a1,a1,1
     dd8:	0705                	addi	a4,a4,1
     dda:	fff5c683          	lbu	a3,-1(a1)
     dde:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     de2:	fee79ae3          	bne	a5,a4,dd6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     de6:	6422                	ld	s0,8(sp)
     de8:	0141                	addi	sp,sp,16
     dea:	8082                	ret
    dst += n;
     dec:	00c50733          	add	a4,a0,a2
    src += n;
     df0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     df2:	fec05ae3          	blez	a2,de6 <memmove+0x2c>
     df6:	fff6079b          	addiw	a5,a2,-1
     dfa:	1782                	slli	a5,a5,0x20
     dfc:	9381                	srli	a5,a5,0x20
     dfe:	fff7c793          	not	a5,a5
     e02:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e04:	15fd                	addi	a1,a1,-1
     e06:	177d                	addi	a4,a4,-1
     e08:	0005c683          	lbu	a3,0(a1)
     e0c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e10:	fef71ae3          	bne	a4,a5,e04 <memmove+0x4a>
     e14:	bfc9                	j	de6 <memmove+0x2c>

0000000000000e16 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e16:	1141                	addi	sp,sp,-16
     e18:	e422                	sd	s0,8(sp)
     e1a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e1c:	ce15                	beqz	a2,e58 <memcmp+0x42>
     e1e:	fff6069b          	addiw	a3,a2,-1
    if (*p1 != *p2) {
     e22:	00054783          	lbu	a5,0(a0)
     e26:	0005c703          	lbu	a4,0(a1)
     e2a:	02e79063          	bne	a5,a4,e4a <memcmp+0x34>
     e2e:	1682                	slli	a3,a3,0x20
     e30:	9281                	srli	a3,a3,0x20
     e32:	0685                	addi	a3,a3,1
     e34:	96aa                	add	a3,a3,a0
      return *p1 - *p2;
    }
    p1++;
     e36:	0505                	addi	a0,a0,1
    p2++;
     e38:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e3a:	00d50d63          	beq	a0,a3,e54 <memcmp+0x3e>
    if (*p1 != *p2) {
     e3e:	00054783          	lbu	a5,0(a0)
     e42:	0005c703          	lbu	a4,0(a1)
     e46:	fee788e3          	beq	a5,a4,e36 <memcmp+0x20>
      return *p1 - *p2;
     e4a:	40e7853b          	subw	a0,a5,a4
  }
  return 0;
}
     e4e:	6422                	ld	s0,8(sp)
     e50:	0141                	addi	sp,sp,16
     e52:	8082                	ret
  return 0;
     e54:	4501                	li	a0,0
     e56:	bfe5                	j	e4e <memcmp+0x38>
     e58:	4501                	li	a0,0
     e5a:	bfd5                	j	e4e <memcmp+0x38>

0000000000000e5c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e5c:	1141                	addi	sp,sp,-16
     e5e:	e406                	sd	ra,8(sp)
     e60:	e022                	sd	s0,0(sp)
     e62:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e64:	00000097          	auipc	ra,0x0
     e68:	f56080e7          	jalr	-170(ra) # dba <memmove>
}
     e6c:	60a2                	ld	ra,8(sp)
     e6e:	6402                	ld	s0,0(sp)
     e70:	0141                	addi	sp,sp,16
     e72:	8082                	ret

0000000000000e74 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e74:	4885                	li	a7,1
 ecall
     e76:	00000073          	ecall
 ret
     e7a:	8082                	ret

0000000000000e7c <exit>:
.global exit
exit:
 li a7, SYS_exit
     e7c:	4889                	li	a7,2
 ecall
     e7e:	00000073          	ecall
 ret
     e82:	8082                	ret

0000000000000e84 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e84:	488d                	li	a7,3
 ecall
     e86:	00000073          	ecall
 ret
     e8a:	8082                	ret

0000000000000e8c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e8c:	4891                	li	a7,4
 ecall
     e8e:	00000073          	ecall
 ret
     e92:	8082                	ret

0000000000000e94 <read>:
.global read
read:
 li a7, SYS_read
     e94:	4895                	li	a7,5
 ecall
     e96:	00000073          	ecall
 ret
     e9a:	8082                	ret

0000000000000e9c <write>:
.global write
write:
 li a7, SYS_write
     e9c:	48c1                	li	a7,16
 ecall
     e9e:	00000073          	ecall
 ret
     ea2:	8082                	ret

0000000000000ea4 <close>:
.global close
close:
 li a7, SYS_close
     ea4:	48d5                	li	a7,21
 ecall
     ea6:	00000073          	ecall
 ret
     eaa:	8082                	ret

0000000000000eac <kill>:
.global kill
kill:
 li a7, SYS_kill
     eac:	4899                	li	a7,6
 ecall
     eae:	00000073          	ecall
 ret
     eb2:	8082                	ret

0000000000000eb4 <exec>:
.global exec
exec:
 li a7, SYS_exec
     eb4:	489d                	li	a7,7
 ecall
     eb6:	00000073          	ecall
 ret
     eba:	8082                	ret

0000000000000ebc <open>:
.global open
open:
 li a7, SYS_open
     ebc:	48bd                	li	a7,15
 ecall
     ebe:	00000073          	ecall
 ret
     ec2:	8082                	ret

0000000000000ec4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ec4:	48c5                	li	a7,17
 ecall
     ec6:	00000073          	ecall
 ret
     eca:	8082                	ret

0000000000000ecc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ecc:	48c9                	li	a7,18
 ecall
     ece:	00000073          	ecall
 ret
     ed2:	8082                	ret

0000000000000ed4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ed4:	48a1                	li	a7,8
 ecall
     ed6:	00000073          	ecall
 ret
     eda:	8082                	ret

0000000000000edc <link>:
.global link
link:
 li a7, SYS_link
     edc:	48cd                	li	a7,19
 ecall
     ede:	00000073          	ecall
 ret
     ee2:	8082                	ret

0000000000000ee4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ee4:	48d1                	li	a7,20
 ecall
     ee6:	00000073          	ecall
 ret
     eea:	8082                	ret

0000000000000eec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     eec:	48a5                	li	a7,9
 ecall
     eee:	00000073          	ecall
 ret
     ef2:	8082                	ret

0000000000000ef4 <dup>:
.global dup
dup:
 li a7, SYS_dup
     ef4:	48a9                	li	a7,10
 ecall
     ef6:	00000073          	ecall
 ret
     efa:	8082                	ret

0000000000000efc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     efc:	48ad                	li	a7,11
 ecall
     efe:	00000073          	ecall
 ret
     f02:	8082                	ret

0000000000000f04 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f04:	48b1                	li	a7,12
 ecall
     f06:	00000073          	ecall
 ret
     f0a:	8082                	ret

0000000000000f0c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f0c:	48b5                	li	a7,13
 ecall
     f0e:	00000073          	ecall
 ret
     f12:	8082                	ret

0000000000000f14 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f14:	48b9                	li	a7,14
 ecall
     f16:	00000073          	ecall
 ret
     f1a:	8082                	ret

0000000000000f1c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f1c:	1101                	addi	sp,sp,-32
     f1e:	ec06                	sd	ra,24(sp)
     f20:	e822                	sd	s0,16(sp)
     f22:	1000                	addi	s0,sp,32
     f24:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f28:	4605                	li	a2,1
     f2a:	fef40593          	addi	a1,s0,-17
     f2e:	00000097          	auipc	ra,0x0
     f32:	f6e080e7          	jalr	-146(ra) # e9c <write>
}
     f36:	60e2                	ld	ra,24(sp)
     f38:	6442                	ld	s0,16(sp)
     f3a:	6105                	addi	sp,sp,32
     f3c:	8082                	ret

0000000000000f3e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f3e:	7139                	addi	sp,sp,-64
     f40:	fc06                	sd	ra,56(sp)
     f42:	f822                	sd	s0,48(sp)
     f44:	f426                	sd	s1,40(sp)
     f46:	f04a                	sd	s2,32(sp)
     f48:	ec4e                	sd	s3,24(sp)
     f4a:	0080                	addi	s0,sp,64
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f4c:	c299                	beqz	a3,f52 <printint+0x14>
     f4e:	0005cd63          	bltz	a1,f68 <printint+0x2a>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f52:	2581                	sext.w	a1,a1
  neg = 0;
     f54:	4301                	li	t1,0
     f56:	fc040713          	addi	a4,s0,-64
  }

  i = 0;
     f5a:	4801                	li	a6,0
  do{
    buf[i++] = digits[x % base];
     f5c:	2601                	sext.w	a2,a2
     f5e:	00000897          	auipc	a7,0x0
     f62:	70a88893          	addi	a7,a7,1802 # 1668 <digits>
     f66:	a801                	j	f76 <printint+0x38>
    x = -xx;
     f68:	40b005bb          	negw	a1,a1
     f6c:	2581                	sext.w	a1,a1
    neg = 1;
     f6e:	4305                	li	t1,1
    x = -xx;
     f70:	b7dd                	j	f56 <printint+0x18>
  }while((x /= base) != 0);
     f72:	85be                	mv	a1,a5
    buf[i++] = digits[x % base];
     f74:	8836                	mv	a6,a3
     f76:	0018069b          	addiw	a3,a6,1
     f7a:	02c5f7bb          	remuw	a5,a1,a2
     f7e:	1782                	slli	a5,a5,0x20
     f80:	9381                	srli	a5,a5,0x20
     f82:	97c6                	add	a5,a5,a7
     f84:	0007c783          	lbu	a5,0(a5)
     f88:	00f70023          	sb	a5,0(a4)
  }while((x /= base) != 0);
     f8c:	0705                	addi	a4,a4,1
     f8e:	02c5d7bb          	divuw	a5,a1,a2
     f92:	fec5f0e3          	bleu	a2,a1,f72 <printint+0x34>
  if(neg)
     f96:	00030b63          	beqz	t1,fac <printint+0x6e>
    buf[i++] = '-';
     f9a:	fd040793          	addi	a5,s0,-48
     f9e:	96be                	add	a3,a3,a5
     fa0:	02d00793          	li	a5,45
     fa4:	fef68823          	sb	a5,-16(a3)
     fa8:	0028069b          	addiw	a3,a6,2

  while(--i >= 0)
     fac:	02d05963          	blez	a3,fde <printint+0xa0>
     fb0:	89aa                	mv	s3,a0
     fb2:	fc040793          	addi	a5,s0,-64
     fb6:	00d784b3          	add	s1,a5,a3
     fba:	fff78913          	addi	s2,a5,-1
     fbe:	9936                	add	s2,s2,a3
     fc0:	36fd                	addiw	a3,a3,-1
     fc2:	1682                	slli	a3,a3,0x20
     fc4:	9281                	srli	a3,a3,0x20
     fc6:	40d90933          	sub	s2,s2,a3
    putc(fd, buf[i]);
     fca:	fff4c583          	lbu	a1,-1(s1)
     fce:	854e                	mv	a0,s3
     fd0:	00000097          	auipc	ra,0x0
     fd4:	f4c080e7          	jalr	-180(ra) # f1c <putc>
  while(--i >= 0)
     fd8:	14fd                	addi	s1,s1,-1
     fda:	ff2498e3          	bne	s1,s2,fca <printint+0x8c>
}
     fde:	70e2                	ld	ra,56(sp)
     fe0:	7442                	ld	s0,48(sp)
     fe2:	74a2                	ld	s1,40(sp)
     fe4:	7902                	ld	s2,32(sp)
     fe6:	69e2                	ld	s3,24(sp)
     fe8:	6121                	addi	sp,sp,64
     fea:	8082                	ret

0000000000000fec <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fec:	7119                	addi	sp,sp,-128
     fee:	fc86                	sd	ra,120(sp)
     ff0:	f8a2                	sd	s0,112(sp)
     ff2:	f4a6                	sd	s1,104(sp)
     ff4:	f0ca                	sd	s2,96(sp)
     ff6:	ecce                	sd	s3,88(sp)
     ff8:	e8d2                	sd	s4,80(sp)
     ffa:	e4d6                	sd	s5,72(sp)
     ffc:	e0da                	sd	s6,64(sp)
     ffe:	fc5e                	sd	s7,56(sp)
    1000:	f862                	sd	s8,48(sp)
    1002:	f466                	sd	s9,40(sp)
    1004:	f06a                	sd	s10,32(sp)
    1006:	ec6e                	sd	s11,24(sp)
    1008:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    100a:	0005c483          	lbu	s1,0(a1)
    100e:	18048d63          	beqz	s1,11a8 <vprintf+0x1bc>
    1012:	8aaa                	mv	s5,a0
    1014:	8b32                	mv	s6,a2
    1016:	00158913          	addi	s2,a1,1
  state = 0;
    101a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    101c:	02500a13          	li	s4,37
      if(c == 'd'){
    1020:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1024:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1028:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    102c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1030:	00000b97          	auipc	s7,0x0
    1034:	638b8b93          	addi	s7,s7,1592 # 1668 <digits>
    1038:	a839                	j	1056 <vprintf+0x6a>
        putc(fd, c);
    103a:	85a6                	mv	a1,s1
    103c:	8556                	mv	a0,s5
    103e:	00000097          	auipc	ra,0x0
    1042:	ede080e7          	jalr	-290(ra) # f1c <putc>
    1046:	a019                	j	104c <vprintf+0x60>
    } else if(state == '%'){
    1048:	01498f63          	beq	s3,s4,1066 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    104c:	0905                	addi	s2,s2,1
    104e:	fff94483          	lbu	s1,-1(s2)
    1052:	14048b63          	beqz	s1,11a8 <vprintf+0x1bc>
    c = fmt[i] & 0xff;
    1056:	0004879b          	sext.w	a5,s1
    if(state == 0){
    105a:	fe0997e3          	bnez	s3,1048 <vprintf+0x5c>
      if(c == '%'){
    105e:	fd479ee3          	bne	a5,s4,103a <vprintf+0x4e>
        state = '%';
    1062:	89be                	mv	s3,a5
    1064:	b7e5                	j	104c <vprintf+0x60>
      if(c == 'd'){
    1066:	05878063          	beq	a5,s8,10a6 <vprintf+0xba>
      } else if(c == 'l') {
    106a:	05978c63          	beq	a5,s9,10c2 <vprintf+0xd6>
      } else if(c == 'x') {
    106e:	07a78863          	beq	a5,s10,10de <vprintf+0xf2>
      } else if(c == 'p') {
    1072:	09b78463          	beq	a5,s11,10fa <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1076:	07300713          	li	a4,115
    107a:	0ce78563          	beq	a5,a4,1144 <vprintf+0x158>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    107e:	06300713          	li	a4,99
    1082:	0ee78c63          	beq	a5,a4,117a <vprintf+0x18e>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1086:	11478663          	beq	a5,s4,1192 <vprintf+0x1a6>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    108a:	85d2                	mv	a1,s4
    108c:	8556                	mv	a0,s5
    108e:	00000097          	auipc	ra,0x0
    1092:	e8e080e7          	jalr	-370(ra) # f1c <putc>
        putc(fd, c);
    1096:	85a6                	mv	a1,s1
    1098:	8556                	mv	a0,s5
    109a:	00000097          	auipc	ra,0x0
    109e:	e82080e7          	jalr	-382(ra) # f1c <putc>
      }
      state = 0;
    10a2:	4981                	li	s3,0
    10a4:	b765                	j	104c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    10a6:	008b0493          	addi	s1,s6,8
    10aa:	4685                	li	a3,1
    10ac:	4629                	li	a2,10
    10ae:	000b2583          	lw	a1,0(s6)
    10b2:	8556                	mv	a0,s5
    10b4:	00000097          	auipc	ra,0x0
    10b8:	e8a080e7          	jalr	-374(ra) # f3e <printint>
    10bc:	8b26                	mv	s6,s1
      state = 0;
    10be:	4981                	li	s3,0
    10c0:	b771                	j	104c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10c2:	008b0493          	addi	s1,s6,8
    10c6:	4681                	li	a3,0
    10c8:	4629                	li	a2,10
    10ca:	000b2583          	lw	a1,0(s6)
    10ce:	8556                	mv	a0,s5
    10d0:	00000097          	auipc	ra,0x0
    10d4:	e6e080e7          	jalr	-402(ra) # f3e <printint>
    10d8:	8b26                	mv	s6,s1
      state = 0;
    10da:	4981                	li	s3,0
    10dc:	bf85                	j	104c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    10de:	008b0493          	addi	s1,s6,8
    10e2:	4681                	li	a3,0
    10e4:	4641                	li	a2,16
    10e6:	000b2583          	lw	a1,0(s6)
    10ea:	8556                	mv	a0,s5
    10ec:	00000097          	auipc	ra,0x0
    10f0:	e52080e7          	jalr	-430(ra) # f3e <printint>
    10f4:	8b26                	mv	s6,s1
      state = 0;
    10f6:	4981                	li	s3,0
    10f8:	bf91                	j	104c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    10fa:	008b0793          	addi	a5,s6,8
    10fe:	f8f43423          	sd	a5,-120(s0)
    1102:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1106:	03000593          	li	a1,48
    110a:	8556                	mv	a0,s5
    110c:	00000097          	auipc	ra,0x0
    1110:	e10080e7          	jalr	-496(ra) # f1c <putc>
  putc(fd, 'x');
    1114:	85ea                	mv	a1,s10
    1116:	8556                	mv	a0,s5
    1118:	00000097          	auipc	ra,0x0
    111c:	e04080e7          	jalr	-508(ra) # f1c <putc>
    1120:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1122:	03c9d793          	srli	a5,s3,0x3c
    1126:	97de                	add	a5,a5,s7
    1128:	0007c583          	lbu	a1,0(a5)
    112c:	8556                	mv	a0,s5
    112e:	00000097          	auipc	ra,0x0
    1132:	dee080e7          	jalr	-530(ra) # f1c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1136:	0992                	slli	s3,s3,0x4
    1138:	34fd                	addiw	s1,s1,-1
    113a:	f4e5                	bnez	s1,1122 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    113c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1140:	4981                	li	s3,0
    1142:	b729                	j	104c <vprintf+0x60>
        s = va_arg(ap, char*);
    1144:	008b0993          	addi	s3,s6,8
    1148:	000b3483          	ld	s1,0(s6)
        if(s == 0)
    114c:	c085                	beqz	s1,116c <vprintf+0x180>
        while(*s != 0){
    114e:	0004c583          	lbu	a1,0(s1)
    1152:	c9a1                	beqz	a1,11a2 <vprintf+0x1b6>
          putc(fd, *s);
    1154:	8556                	mv	a0,s5
    1156:	00000097          	auipc	ra,0x0
    115a:	dc6080e7          	jalr	-570(ra) # f1c <putc>
          s++;
    115e:	0485                	addi	s1,s1,1
        while(*s != 0){
    1160:	0004c583          	lbu	a1,0(s1)
    1164:	f9e5                	bnez	a1,1154 <vprintf+0x168>
        s = va_arg(ap, char*);
    1166:	8b4e                	mv	s6,s3
      state = 0;
    1168:	4981                	li	s3,0
    116a:	b5cd                	j	104c <vprintf+0x60>
          s = "(null)";
    116c:	00000497          	auipc	s1,0x0
    1170:	51448493          	addi	s1,s1,1300 # 1680 <digits+0x18>
        while(*s != 0){
    1174:	02800593          	li	a1,40
    1178:	bff1                	j	1154 <vprintf+0x168>
        putc(fd, va_arg(ap, uint));
    117a:	008b0493          	addi	s1,s6,8
    117e:	000b4583          	lbu	a1,0(s6)
    1182:	8556                	mv	a0,s5
    1184:	00000097          	auipc	ra,0x0
    1188:	d98080e7          	jalr	-616(ra) # f1c <putc>
    118c:	8b26                	mv	s6,s1
      state = 0;
    118e:	4981                	li	s3,0
    1190:	bd75                	j	104c <vprintf+0x60>
        putc(fd, c);
    1192:	85d2                	mv	a1,s4
    1194:	8556                	mv	a0,s5
    1196:	00000097          	auipc	ra,0x0
    119a:	d86080e7          	jalr	-634(ra) # f1c <putc>
      state = 0;
    119e:	4981                	li	s3,0
    11a0:	b575                	j	104c <vprintf+0x60>
        s = va_arg(ap, char*);
    11a2:	8b4e                	mv	s6,s3
      state = 0;
    11a4:	4981                	li	s3,0
    11a6:	b55d                	j	104c <vprintf+0x60>
    }
  }
}
    11a8:	70e6                	ld	ra,120(sp)
    11aa:	7446                	ld	s0,112(sp)
    11ac:	74a6                	ld	s1,104(sp)
    11ae:	7906                	ld	s2,96(sp)
    11b0:	69e6                	ld	s3,88(sp)
    11b2:	6a46                	ld	s4,80(sp)
    11b4:	6aa6                	ld	s5,72(sp)
    11b6:	6b06                	ld	s6,64(sp)
    11b8:	7be2                	ld	s7,56(sp)
    11ba:	7c42                	ld	s8,48(sp)
    11bc:	7ca2                	ld	s9,40(sp)
    11be:	7d02                	ld	s10,32(sp)
    11c0:	6de2                	ld	s11,24(sp)
    11c2:	6109                	addi	sp,sp,128
    11c4:	8082                	ret

00000000000011c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11c6:	715d                	addi	sp,sp,-80
    11c8:	ec06                	sd	ra,24(sp)
    11ca:	e822                	sd	s0,16(sp)
    11cc:	1000                	addi	s0,sp,32
    11ce:	e010                	sd	a2,0(s0)
    11d0:	e414                	sd	a3,8(s0)
    11d2:	e818                	sd	a4,16(s0)
    11d4:	ec1c                	sd	a5,24(s0)
    11d6:	03043023          	sd	a6,32(s0)
    11da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11e2:	8622                	mv	a2,s0
    11e4:	00000097          	auipc	ra,0x0
    11e8:	e08080e7          	jalr	-504(ra) # fec <vprintf>
}
    11ec:	60e2                	ld	ra,24(sp)
    11ee:	6442                	ld	s0,16(sp)
    11f0:	6161                	addi	sp,sp,80
    11f2:	8082                	ret

00000000000011f4 <printf>:

void
printf(const char *fmt, ...)
{
    11f4:	711d                	addi	sp,sp,-96
    11f6:	ec06                	sd	ra,24(sp)
    11f8:	e822                	sd	s0,16(sp)
    11fa:	1000                	addi	s0,sp,32
    11fc:	e40c                	sd	a1,8(s0)
    11fe:	e810                	sd	a2,16(s0)
    1200:	ec14                	sd	a3,24(s0)
    1202:	f018                	sd	a4,32(s0)
    1204:	f41c                	sd	a5,40(s0)
    1206:	03043823          	sd	a6,48(s0)
    120a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    120e:	00840613          	addi	a2,s0,8
    1212:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1216:	85aa                	mv	a1,a0
    1218:	4505                	li	a0,1
    121a:	00000097          	auipc	ra,0x0
    121e:	dd2080e7          	jalr	-558(ra) # fec <vprintf>
}
    1222:	60e2                	ld	ra,24(sp)
    1224:	6442                	ld	s0,16(sp)
    1226:	6125                	addi	sp,sp,96
    1228:	8082                	ret

000000000000122a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    122a:	1141                	addi	sp,sp,-16
    122c:	e422                	sd	s0,8(sp)
    122e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1230:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1234:	00000797          	auipc	a5,0x0
    1238:	45c78793          	addi	a5,a5,1116 # 1690 <_edata>
    123c:	639c                	ld	a5,0(a5)
    123e:	a805                	j	126e <free+0x44>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1240:	4618                	lw	a4,8(a2)
    1242:	9db9                	addw	a1,a1,a4
    1244:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1248:	6398                	ld	a4,0(a5)
    124a:	6318                	ld	a4,0(a4)
    124c:	fee53823          	sd	a4,-16(a0)
    1250:	a091                	j	1294 <free+0x6a>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1252:	ff852703          	lw	a4,-8(a0)
    1256:	9e39                	addw	a2,a2,a4
    1258:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    125a:	ff053703          	ld	a4,-16(a0)
    125e:	e398                	sd	a4,0(a5)
    1260:	a099                	j	12a6 <free+0x7c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1262:	6398                	ld	a4,0(a5)
    1264:	00e7e463          	bltu	a5,a4,126c <free+0x42>
    1268:	00e6ea63          	bltu	a3,a4,127c <free+0x52>
{
    126c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    126e:	fed7fae3          	bleu	a3,a5,1262 <free+0x38>
    1272:	6398                	ld	a4,0(a5)
    1274:	00e6e463          	bltu	a3,a4,127c <free+0x52>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1278:	fee7eae3          	bltu	a5,a4,126c <free+0x42>
  if(bp + bp->s.size == p->s.ptr){
    127c:	ff852583          	lw	a1,-8(a0)
    1280:	6390                	ld	a2,0(a5)
    1282:	02059713          	slli	a4,a1,0x20
    1286:	9301                	srli	a4,a4,0x20
    1288:	0712                	slli	a4,a4,0x4
    128a:	9736                	add	a4,a4,a3
    128c:	fae60ae3          	beq	a2,a4,1240 <free+0x16>
    bp->s.ptr = p->s.ptr;
    1290:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1294:	4790                	lw	a2,8(a5)
    1296:	02061713          	slli	a4,a2,0x20
    129a:	9301                	srli	a4,a4,0x20
    129c:	0712                	slli	a4,a4,0x4
    129e:	973e                	add	a4,a4,a5
    12a0:	fae689e3          	beq	a3,a4,1252 <free+0x28>
  } else
    p->s.ptr = bp;
    12a4:	e394                	sd	a3,0(a5)
  freep = p;
    12a6:	00000717          	auipc	a4,0x0
    12aa:	3ef73523          	sd	a5,1002(a4) # 1690 <_edata>
}
    12ae:	6422                	ld	s0,8(sp)
    12b0:	0141                	addi	sp,sp,16
    12b2:	8082                	ret

00000000000012b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12b4:	7139                	addi	sp,sp,-64
    12b6:	fc06                	sd	ra,56(sp)
    12b8:	f822                	sd	s0,48(sp)
    12ba:	f426                	sd	s1,40(sp)
    12bc:	f04a                	sd	s2,32(sp)
    12be:	ec4e                	sd	s3,24(sp)
    12c0:	e852                	sd	s4,16(sp)
    12c2:	e456                	sd	s5,8(sp)
    12c4:	e05a                	sd	s6,0(sp)
    12c6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12c8:	02051993          	slli	s3,a0,0x20
    12cc:	0209d993          	srli	s3,s3,0x20
    12d0:	09bd                	addi	s3,s3,15
    12d2:	0049d993          	srli	s3,s3,0x4
    12d6:	2985                	addiw	s3,s3,1
    12d8:	0009891b          	sext.w	s2,s3
  if((prevp = freep) == 0){
    12dc:	00000797          	auipc	a5,0x0
    12e0:	3b478793          	addi	a5,a5,948 # 1690 <_edata>
    12e4:	6388                	ld	a0,0(a5)
    12e6:	c515                	beqz	a0,1312 <malloc+0x5e>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12e8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12ea:	4798                	lw	a4,8(a5)
    12ec:	03277f63          	bleu	s2,a4,132a <malloc+0x76>
    12f0:	8a4e                	mv	s4,s3
    12f2:	0009871b          	sext.w	a4,s3
    12f6:	6685                	lui	a3,0x1
    12f8:	00d77363          	bleu	a3,a4,12fe <malloc+0x4a>
    12fc:	6a05                	lui	s4,0x1
    12fe:	000a0a9b          	sext.w	s5,s4
  p = sbrk(nu * sizeof(Header));
    1302:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1306:	00000497          	auipc	s1,0x0
    130a:	38a48493          	addi	s1,s1,906 # 1690 <_edata>
  if(p == (char*)-1)
    130e:	5b7d                	li	s6,-1
    1310:	a885                	j	1380 <malloc+0xcc>
    base.s.ptr = freep = prevp = &base;
    1312:	00000797          	auipc	a5,0x0
    1316:	76e78793          	addi	a5,a5,1902 # 1a80 <base>
    131a:	00000717          	auipc	a4,0x0
    131e:	36f73b23          	sd	a5,886(a4) # 1690 <_edata>
    1322:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1324:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1328:	b7e1                	j	12f0 <malloc+0x3c>
      if(p->s.size == nunits)
    132a:	02e90b63          	beq	s2,a4,1360 <malloc+0xac>
        p->s.size -= nunits;
    132e:	4137073b          	subw	a4,a4,s3
    1332:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1334:	1702                	slli	a4,a4,0x20
    1336:	9301                	srli	a4,a4,0x20
    1338:	0712                	slli	a4,a4,0x4
    133a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    133c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1340:	00000717          	auipc	a4,0x0
    1344:	34a73823          	sd	a0,848(a4) # 1690 <_edata>
      return (void*)(p + 1);
    1348:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    134c:	70e2                	ld	ra,56(sp)
    134e:	7442                	ld	s0,48(sp)
    1350:	74a2                	ld	s1,40(sp)
    1352:	7902                	ld	s2,32(sp)
    1354:	69e2                	ld	s3,24(sp)
    1356:	6a42                	ld	s4,16(sp)
    1358:	6aa2                	ld	s5,8(sp)
    135a:	6b02                	ld	s6,0(sp)
    135c:	6121                	addi	sp,sp,64
    135e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1360:	6398                	ld	a4,0(a5)
    1362:	e118                	sd	a4,0(a0)
    1364:	bff1                	j	1340 <malloc+0x8c>
  hp->s.size = nu;
    1366:	01552423          	sw	s5,8(a0)
  free((void*)(hp + 1));
    136a:	0541                	addi	a0,a0,16
    136c:	00000097          	auipc	ra,0x0
    1370:	ebe080e7          	jalr	-322(ra) # 122a <free>
  return freep;
    1374:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1376:	d979                	beqz	a0,134c <malloc+0x98>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1378:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    137a:	4798                	lw	a4,8(a5)
    137c:	fb2777e3          	bleu	s2,a4,132a <malloc+0x76>
    if(p == freep)
    1380:	6098                	ld	a4,0(s1)
    1382:	853e                	mv	a0,a5
    1384:	fef71ae3          	bne	a4,a5,1378 <malloc+0xc4>
  p = sbrk(nu * sizeof(Header));
    1388:	8552                	mv	a0,s4
    138a:	00000097          	auipc	ra,0x0
    138e:	b7a080e7          	jalr	-1158(ra) # f04 <sbrk>
  if(p == (char*)-1)
    1392:	fd651ae3          	bne	a0,s6,1366 <malloc+0xb2>
        return 0;
    1396:	4501                	li	a0,0
    1398:	bf55                	j	134c <malloc+0x98>
