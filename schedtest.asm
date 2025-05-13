
_schedtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
}



int main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	bb 90 01 00 00       	mov    $0x190,%ebx
  15:	51                   	push   %ecx
  16:	83 ec 18             	sub    $0x18,%esp
  19:	eb 22                	jmp    3d <main+0x3d>
        }

        if (pid % 3 == 0)
            set_deadline_for_process(pid, 400 + i*10 );

        if (pid % 4 == 0 && pid % 3 != 0)
  1b:	a8 03                	test   $0x3,%al
  1d:	75 0e                	jne    2d <main+0x2d>
            change_sched_level(pid, 1);
  1f:	83 ec 08             	sub    $0x8,%esp
  22:	6a 01                	push   $0x1
  24:	50                   	push   %eax
  25:	e8 c1 07 00 00       	call   7eb <change_sched_level>
  2a:	83 c4 10             	add    $0x10,%esp

        print_sched_info();
  2d:	e8 c1 07 00 00       	call   7f3 <print_sched_info>
    for (int i = 0; i < NPROC; i++)
  32:	83 c3 0a             	add    $0xa,%ebx
  35:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
  3b:	74 44                	je     81 <main+0x81>
        pid = fork();
  3d:	e8 f9 06 00 00       	call   73b <fork>
        if (pid < 0)
  42:	85 c0                	test   %eax,%eax
  44:	0f 88 d7 00 00 00    	js     121 <main+0x121>
        if (pid == 0)
  4a:	0f 84 e4 00 00 00    	je     134 <main+0x134>
            exit();
  50:	69 d0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%edx
  56:	81 c2 aa aa aa 2a    	add    $0x2aaaaaaa,%edx
        if (pid % 3 == 0)
  5c:	81 fa 54 55 55 55    	cmp    $0x55555554,%edx
  62:	77 b7                	ja     1b <main+0x1b>
            set_deadline_for_process(pid, 400 + i*10 );
  64:	83 ec 08             	sub    $0x8,%esp
  67:	53                   	push   %ebx
    for (int i = 0; i < NPROC; i++)
  68:	83 c3 0a             	add    $0xa,%ebx
            set_deadline_for_process(pid, 400 + i*10 );
  6b:	50                   	push   %eax
  6c:	e8 9a 07 00 00       	call   80b <set_deadline_for_process>
  71:	83 c4 10             	add    $0x10,%esp
        print_sched_info();
  74:	e8 7a 07 00 00       	call   7f3 <print_sched_info>
    for (int i = 0; i < NPROC; i++)
  79:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
  7f:	75 bc                	jne    3d <main+0x3d>
  81:	bb 32 00 00 00       	mov    $0x32,%ebx
    volatile int x = 0;
  86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8d:	ba 00 e1 f5 05       	mov    $0x5f5e100,%edx
  92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            x++;
  98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  9b:	83 c0 01             	add    $0x1,%eax
  9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            x--;
  a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  a4:	83 e8 01             	sub    $0x1,%eax
  a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (int i = 0; i < LOOP_ITER; i++)
  aa:	83 ea 01             	sub    $0x1,%edx
  ad:	75 e9                	jne    98 <main+0x98>
  af:	be 1d 00 00 00       	mov    $0x1d,%esi
  b4:	31 ff                	xor    %edi,%edi
    return fibonacci(n - 1) + fibonacci(n - 2);
  b6:	83 ec 0c             	sub    $0xc,%esp
  b9:	56                   	push   %esi
    if (n <= 1)
  ba:	83 ee 02             	sub    $0x2,%esi
    return fibonacci(n - 1) + fibonacci(n - 2);
  bd:	e8 9e 00 00 00       	call   160 <fibonacci>
  c2:	83 c4 10             	add    $0x10,%esp
  c5:	01 c7                	add    %eax,%edi
    if (n <= 1)
  c7:	83 fe ff             	cmp    $0xffffffff,%esi
  ca:	75 ea                	jne    b6 <main+0xb6>
    printf(1,"fib: %d - " ,fibonacci(30));
  cc:	83 ec 04             	sub    $0x4,%esp
  cf:	57                   	push   %edi
  d0:	68 c8 0b 00 00       	push   $0xbc8
  d5:	6a 01                	push   $0x1
  d7:	e8 e4 07 00 00       	call   8c0 <printf>
    printf(1, "  busyjob %d finished. \n", n);
  dc:	83 c4 0c             	add    $0xc,%esp
  df:	6a 55                	push   $0x55
  e1:	68 d3 0b 00 00       	push   $0xbd3
  e6:	6a 01                	push   $0x1
  e8:	e8 d3 07 00 00       	call   8c0 <printf>
    }
    for (int j = 0; j < 50; j++)
  ed:	83 c4 10             	add    $0x10,%esp
  f0:	83 eb 01             	sub    $0x1,%ebx
  f3:	75 91                	jne    86 <main+0x86>
  f5:	bb 0a 00 00 00       	mov    $0xa,%ebx
        busywork(1, 85);

    for (int i = 0; i < NPROC; i++)
    {
        printf(1, "scheduletest: ending process %d\n", wait());
  fa:	e8 4c 06 00 00       	call   74b <wait>
  ff:	83 ec 04             	sub    $0x4,%esp
 102:	50                   	push   %eax
 103:	68 34 0c 00 00       	push   $0xc34
 108:	6a 01                	push   $0x1
 10a:	e8 b1 07 00 00       	call   8c0 <printf>
        print_sched_info();
 10f:	e8 df 06 00 00       	call   7f3 <print_sched_info>
    for (int i = 0; i < NPROC; i++)
 114:	83 c4 10             	add    $0x10,%esp
 117:	83 eb 01             	sub    $0x1,%ebx
 11a:	75 de                	jne    fa <main+0xfa>
    }

    exit();
 11c:	e8 22 06 00 00       	call   743 <exit>
            printf(1, "scheduletest: fork failed\n");
 121:	56                   	push   %esi
 122:	56                   	push   %esi
 123:	68 ec 0b 00 00       	push   $0xbec
 128:	6a 01                	push   $0x1
 12a:	e8 91 07 00 00       	call   8c0 <printf>
            exit();
 12f:	e8 0f 06 00 00       	call   743 <exit>
            printf(1, "scheduletest: starting process %d\n", getpid());
 134:	e8 8a 06 00 00       	call   7c3 <getpid>
 139:	52                   	push   %edx
 13a:	50                   	push   %eax
 13b:	68 10 0c 00 00       	push   $0xc10
 140:	6a 01                	push   $0x1
 142:	e8 79 07 00 00       	call   8c0 <printf>
            busywork(5, getpid());
 147:	e8 77 06 00 00       	call   7c3 <getpid>
 14c:	59                   	pop    %ecx
 14d:	5b                   	pop    %ebx
 14e:	50                   	push   %eax
 14f:	6a 05                	push   $0x5
 151:	e8 1a 03 00 00       	call   470 <busywork>
            print_sched_info(); // Custom syscall
 156:	e8 98 06 00 00       	call   7f3 <print_sched_info>
            exit();
 15b:	e8 e3 05 00 00       	call   743 <exit>

00000160 <fibonacci>:
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	56                   	push   %esi
 165:	53                   	push   %ebx
 166:	83 ec 7c             	sub    $0x7c,%esp
 169:	8b 75 08             	mov    0x8(%ebp),%esi
    if (n <= 1)
 16c:	83 fe 01             	cmp    $0x1,%esi
 16f:	0f 8e ed 02 00 00    	jle    462 <fibonacci+0x302>
 175:	8d 56 ff             	lea    -0x1(%esi),%edx
 178:	89 f3                	mov    %esi,%ebx
 17a:	31 ff                	xor    %edi,%edi
 17c:	89 d0                	mov    %edx,%eax
 17e:	83 e0 fe             	and    $0xfffffffe,%eax
 181:	29 c3                	sub    %eax,%ebx
    return fibonacci(n - 1) + fibonacci(n - 2);
 183:	89 d0                	mov    %edx,%eax
 185:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
    if (n <= 1)
 188:	89 f3                	mov    %esi,%ebx
 18a:	8b 75 8c             	mov    -0x74(%ebp),%esi
 18d:	39 f3                	cmp    %esi,%ebx
 18f:	0f 84 ca 02 00 00    	je     45f <fibonacci+0x2ff>
 195:	83 eb 02             	sub    $0x2,%ebx
 198:	89 c6                	mov    %eax,%esi
 19a:	89 7d b8             	mov    %edi,-0x48(%ebp)
 19d:	89 da                	mov    %ebx,%edx
 19f:	89 5d b4             	mov    %ebx,-0x4c(%ebp)
 1a2:	83 e2 fe             	and    $0xfffffffe,%edx
 1a5:	29 d6                	sub    %edx,%esi
 1a7:	89 75 90             	mov    %esi,-0x70(%ebp)
 1aa:	31 f6                	xor    %esi,%esi
 1ac:	8b 5d 90             	mov    -0x70(%ebp),%ebx
 1af:	8d 50 ff             	lea    -0x1(%eax),%edx
    return fibonacci(n - 1) + fibonacci(n - 2);
 1b2:	89 d1                	mov    %edx,%ecx
    if (n <= 1)
 1b4:	39 d8                	cmp    %ebx,%eax
 1b6:	0f 84 80 02 00 00    	je     43c <fibonacci+0x2dc>
 1bc:	8d 58 fe             	lea    -0x2(%eax),%ebx
 1bf:	89 d7                	mov    %edx,%edi
 1c1:	89 75 b0             	mov    %esi,-0x50(%ebp)
 1c4:	89 d8                	mov    %ebx,%eax
 1c6:	89 5d ac             	mov    %ebx,-0x54(%ebp)
 1c9:	83 e0 fe             	and    $0xfffffffe,%eax
 1cc:	29 c7                	sub    %eax,%edi
 1ce:	89 7d 98             	mov    %edi,-0x68(%ebp)
 1d1:	31 ff                	xor    %edi,%edi
    return fibonacci(n - 1) + fibonacci(n - 2);
 1d3:	8d 51 ff             	lea    -0x1(%ecx),%edx
    if (n <= 1)
 1d6:	39 4d 98             	cmp    %ecx,-0x68(%ebp)
 1d9:	0f 84 38 02 00 00    	je     417 <fibonacci+0x2b7>
 1df:	8d 59 fe             	lea    -0x2(%ecx),%ebx
 1e2:	89 d1                	mov    %edx,%ecx
 1e4:	89 7d a8             	mov    %edi,-0x58(%ebp)
 1e7:	89 d8                	mov    %ebx,%eax
 1e9:	89 5d a4             	mov    %ebx,-0x5c(%ebp)
 1ec:	83 e0 fe             	and    $0xfffffffe,%eax
 1ef:	29 c1                	sub    %eax,%ecx
 1f1:	31 c0                	xor    %eax,%eax
 1f3:	89 4d 94             	mov    %ecx,-0x6c(%ebp)
 1f6:	89 c3                	mov    %eax,%ebx
 1f8:	89 d0                	mov    %edx,%eax
    return fibonacci(n - 1) + fibonacci(n - 2);
 1fa:	8d 50 ff             	lea    -0x1(%eax),%edx
 1fd:	89 d1                	mov    %edx,%ecx
    if (n <= 1)
 1ff:	39 45 94             	cmp    %eax,-0x6c(%ebp)
 202:	0f 84 ea 01 00 00    	je     3f2 <fibonacci+0x292>
 208:	8d 70 fe             	lea    -0x2(%eax),%esi
 20b:	89 d7                	mov    %edx,%edi
 20d:	89 5d a0             	mov    %ebx,-0x60(%ebp)
 210:	89 f0                	mov    %esi,%eax
 212:	89 75 9c             	mov    %esi,-0x64(%ebp)
 215:	83 e0 fe             	and    $0xfffffffe,%eax
 218:	29 c7                	sub    %eax,%edi
 21a:	89 7d cc             	mov    %edi,-0x34(%ebp)
 21d:	31 ff                	xor    %edi,%edi
    return fibonacci(n - 1) + fibonacci(n - 2);
 21f:	8d 51 ff             	lea    -0x1(%ecx),%edx
 222:	89 d0                	mov    %edx,%eax
    if (n <= 1)
 224:	39 4d cc             	cmp    %ecx,-0x34(%ebp)
 227:	0f 84 93 01 00 00    	je     3c0 <fibonacci+0x260>
 22d:	8d 59 fe             	lea    -0x2(%ecx),%ebx
 230:	89 c6                	mov    %eax,%esi
 232:	89 7d d8             	mov    %edi,-0x28(%ebp)
 235:	89 da                	mov    %ebx,%edx
 237:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 23a:	83 e2 fe             	and    $0xfffffffe,%edx
 23d:	29 d6                	sub    %edx,%esi
 23f:	31 d2                	xor    %edx,%edx
 241:	89 75 c8             	mov    %esi,-0x38(%ebp)
 244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 248:	8b 5d c8             	mov    -0x38(%ebp),%ebx
 24b:	8d 78 ff             	lea    -0x1(%eax),%edi
    return fibonacci(n - 1) + fibonacci(n - 2);
 24e:	89 f9                	mov    %edi,%ecx
    if (n <= 1)
 250:	39 d8                	cmp    %ebx,%eax
 252:	0f 84 48 01 00 00    	je     3a0 <fibonacci+0x240>
 258:	8d 58 fe             	lea    -0x2(%eax),%ebx
 25b:	8d 70 fd             	lea    -0x3(%eax),%esi
 25e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 261:	89 d8                	mov    %ebx,%eax
 263:	89 75 dc             	mov    %esi,-0x24(%ebp)
 266:	89 fe                	mov    %edi,%esi
 268:	31 ff                	xor    %edi,%edi
 26a:	83 e0 fe             	and    $0xfffffffe,%eax
 26d:	29 c6                	sub    %eax,%esi
 26f:	89 75 c0             	mov    %esi,-0x40(%ebp)
 272:	8b 45 c0             	mov    -0x40(%ebp),%eax
 275:	39 c1                	cmp    %eax,%ecx
 277:	0f 84 53 01 00 00    	je     3d0 <fibonacci+0x270>
 27d:	8b 45 dc             	mov    -0x24(%ebp),%eax
 280:	8d 71 fc             	lea    -0x4(%ecx),%esi
 283:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 28a:	89 f2                	mov    %esi,%edx
 28c:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
    return fibonacci(n - 1) + fibonacci(n - 2);
 28f:	83 e0 fe             	and    $0xfffffffe,%eax
 292:	29 c2                	sub    %eax,%edx
 294:	8d 41 fd             	lea    -0x3(%ecx),%eax
 297:	89 55 d0             	mov    %edx,-0x30(%ebp)
 29a:	83 e0 fe             	and    $0xfffffffe,%eax
 29d:	8d 51 fa             	lea    -0x6(%ecx),%edx
 2a0:	29 c2                	sub    %eax,%edx
 2a2:	89 55 bc             	mov    %edx,-0x44(%ebp)
 2a5:	8d 56 02             	lea    0x2(%esi),%edx
    if (n <= 1)
 2a8:	39 75 d0             	cmp    %esi,-0x30(%ebp)
 2ab:	74 47                	je     2f4 <fibonacci+0x194>
 2ad:	31 c9                	xor    %ecx,%ecx
    return fibonacci(n - 1) + fibonacci(n - 2);
 2af:	83 ec 0c             	sub    $0xc,%esp
 2b2:	8d 42 ff             	lea    -0x1(%edx),%eax
 2b5:	89 4d 84             	mov    %ecx,-0x7c(%ebp)
 2b8:	89 55 88             	mov    %edx,-0x78(%ebp)
 2bb:	50                   	push   %eax
 2bc:	e8 9f fe ff ff       	call   160 <fibonacci>
 2c1:	8b 55 88             	mov    -0x78(%ebp),%edx
 2c4:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
 2c7:	83 c4 10             	add    $0x10,%esp
 2ca:	83 ea 02             	sub    $0x2,%edx
 2cd:	01 c1                	add    %eax,%ecx
    if (n <= 1)
 2cf:	83 fa 01             	cmp    $0x1,%edx
 2d2:	7f db                	jg     2af <fibonacci+0x14f>
 2d4:	89 f0                	mov    %esi,%eax
 2d6:	83 e0 01             	and    $0x1,%eax
 2d9:	01 c8                	add    %ecx,%eax
 2db:	01 45 e0             	add    %eax,-0x20(%ebp)
 2de:	8d 46 fe             	lea    -0x2(%esi),%eax
 2e1:	39 45 bc             	cmp    %eax,-0x44(%ebp)
 2e4:	0f 84 1e 01 00 00    	je     408 <fibonacci+0x2a8>
 2ea:	89 c6                	mov    %eax,%esi
    return fibonacci(n - 1) + fibonacci(n - 2);
 2ec:	8d 56 02             	lea    0x2(%esi),%edx
    if (n <= 1)
 2ef:	39 75 d0             	cmp    %esi,-0x30(%ebp)
 2f2:	75 b9                	jne    2ad <fibonacci+0x14d>
 2f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
 2f7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
        return n;
 2fa:	01 d0                	add    %edx,%eax
    return fibonacci(n - 1) + fibonacci(n - 2);
 2fc:	83 e9 02             	sub    $0x2,%ecx
    if (n <= 1)
 2ff:	83 6d dc 02          	subl   $0x2,-0x24(%ebp)
 303:	01 c7                	add    %eax,%edi
 305:	83 f9 01             	cmp    $0x1,%ecx
 308:	0f 85 64 ff ff ff    	jne    272 <fibonacci+0x112>
 30e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 311:	8d 4f 01             	lea    0x1(%edi),%ecx
    return fibonacci(n - 1) + fibonacci(n - 2);
 314:	89 d8                	mov    %ebx,%eax
 316:	01 ca                	add    %ecx,%edx
    if (n <= 1)
 318:	83 fb 01             	cmp    $0x1,%ebx
 31b:	0f 85 27 ff ff ff    	jne    248 <fibonacci+0xe8>
 321:	8b 7d d8             	mov    -0x28(%ebp),%edi
 324:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 327:	8d 42 01             	lea    0x1(%edx),%eax
    return fibonacci(n - 1) + fibonacci(n - 2);
 32a:	89 d9                	mov    %ebx,%ecx
 32c:	01 c7                	add    %eax,%edi
    if (n <= 1)
 32e:	83 fb 01             	cmp    $0x1,%ebx
 331:	0f 85 e8 fe ff ff    	jne    21f <fibonacci+0xbf>
 337:	8b 5d a0             	mov    -0x60(%ebp),%ebx
 33a:	8b 75 9c             	mov    -0x64(%ebp),%esi
 33d:	8d 57 01             	lea    0x1(%edi),%edx
    return fibonacci(n - 1) + fibonacci(n - 2);
 340:	89 f0                	mov    %esi,%eax
 342:	01 d3                	add    %edx,%ebx
    if (n <= 1)
 344:	83 fe 01             	cmp    $0x1,%esi
 347:	0f 85 ad fe ff ff    	jne    1fa <fibonacci+0x9a>
 34d:	89 d8                	mov    %ebx,%eax
 34f:	8b 7d a8             	mov    -0x58(%ebp),%edi
 352:	8b 5d a4             	mov    -0x5c(%ebp),%ebx
 355:	8d 50 01             	lea    0x1(%eax),%edx
    return fibonacci(n - 1) + fibonacci(n - 2);
 358:	89 d9                	mov    %ebx,%ecx
 35a:	01 d7                	add    %edx,%edi
    if (n <= 1)
 35c:	83 fb 01             	cmp    $0x1,%ebx
 35f:	0f 85 6e fe ff ff    	jne    1d3 <fibonacci+0x73>
 365:	8b 75 b0             	mov    -0x50(%ebp),%esi
 368:	8b 5d ac             	mov    -0x54(%ebp),%ebx
 36b:	8d 57 01             	lea    0x1(%edi),%edx
    return fibonacci(n - 1) + fibonacci(n - 2);
 36e:	89 d8                	mov    %ebx,%eax
 370:	01 d6                	add    %edx,%esi
    if (n <= 1)
 372:	83 fb 01             	cmp    $0x1,%ebx
 375:	0f 85 31 fe ff ff    	jne    1ac <fibonacci+0x4c>
 37b:	8b 7d b8             	mov    -0x48(%ebp),%edi
 37e:	8b 5d b4             	mov    -0x4c(%ebp),%ebx
 381:	8d 56 01             	lea    0x1(%esi),%edx
        return n;
 384:	01 d7                	add    %edx,%edi
    if (n <= 1)
 386:	83 fb 01             	cmp    $0x1,%ebx
 389:	0f 85 c0 00 00 00    	jne    44f <fibonacci+0x2ef>
}
 38f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 392:	8d 77 01             	lea    0x1(%edi),%esi
 395:	5b                   	pop    %ebx
 396:	89 f0                	mov    %esi,%eax
 398:	5e                   	pop    %esi
 399:	5f                   	pop    %edi
 39a:	5d                   	pop    %ebp
 39b:	c3                   	ret
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3a0:	8b 7d d8             	mov    -0x28(%ebp),%edi
 3a3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
        return n;
 3a6:	8d 04 11             	lea    (%ecx,%edx,1),%eax
 3a9:	01 c7                	add    %eax,%edi
    return fibonacci(n - 1) + fibonacci(n - 2);
 3ab:	89 d9                	mov    %ebx,%ecx
    if (n <= 1)
 3ad:	83 fb 01             	cmp    $0x1,%ebx
 3b0:	74 85                	je     337 <fibonacci+0x1d7>
    return fibonacci(n - 1) + fibonacci(n - 2);
 3b2:	8d 51 ff             	lea    -0x1(%ecx),%edx
 3b5:	89 d0                	mov    %edx,%eax
    if (n <= 1)
 3b7:	39 4d cc             	cmp    %ecx,-0x34(%ebp)
 3ba:	0f 85 6d fe ff ff    	jne    22d <fibonacci+0xcd>
 3c0:	8b 5d a0             	mov    -0x60(%ebp),%ebx
 3c3:	8b 75 9c             	mov    -0x64(%ebp),%esi
        return n;
 3c6:	01 fa                	add    %edi,%edx
    if (n <= 1)
 3c8:	e9 73 ff ff ff       	jmp    340 <fibonacci+0x1e0>
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
 3d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        return n;
 3d3:	8d 4c 39 ff          	lea    -0x1(%ecx,%edi,1),%ecx
    return fibonacci(n - 1) + fibonacci(n - 2);
 3d7:	89 d8                	mov    %ebx,%eax
 3d9:	01 ca                	add    %ecx,%edx
    if (n <= 1)
 3db:	83 fb 01             	cmp    $0x1,%ebx
 3de:	0f 85 64 fe ff ff    	jne    248 <fibonacci+0xe8>
 3e4:	8b 7d d8             	mov    -0x28(%ebp),%edi
 3e7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 3ea:	8d 42 01             	lea    0x1(%edx),%eax
 3ed:	e9 38 ff ff ff       	jmp    32a <fibonacci+0x1ca>
 3f2:	89 d8                	mov    %ebx,%eax
 3f4:	8b 7d a8             	mov    -0x58(%ebp),%edi
 3f7:	8b 5d a4             	mov    -0x5c(%ebp),%ebx
        return n;
 3fa:	01 c2                	add    %eax,%edx
    if (n <= 1)
 3fc:	e9 57 ff ff ff       	jmp    358 <fibonacci+0x1f8>
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 408:	8b 45 e0             	mov    -0x20(%ebp),%eax
 40b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
 40e:	8d 44 30 01          	lea    0x1(%eax,%esi,1),%eax
 412:	e9 e5 fe ff ff       	jmp    2fc <fibonacci+0x19c>
 417:	8b 75 b0             	mov    -0x50(%ebp),%esi
 41a:	8b 5d ac             	mov    -0x54(%ebp),%ebx
        return n;
 41d:	01 fa                	add    %edi,%edx
    return fibonacci(n - 1) + fibonacci(n - 2);
 41f:	89 d8                	mov    %ebx,%eax
 421:	01 d6                	add    %edx,%esi
    if (n <= 1)
 423:	83 fb 01             	cmp    $0x1,%ebx
 426:	0f 84 4f ff ff ff    	je     37b <fibonacci+0x21b>
 42c:	8b 5d 90             	mov    -0x70(%ebp),%ebx
 42f:	8d 50 ff             	lea    -0x1(%eax),%edx
    return fibonacci(n - 1) + fibonacci(n - 2);
 432:	89 d1                	mov    %edx,%ecx
    if (n <= 1)
 434:	39 d8                	cmp    %ebx,%eax
 436:	0f 85 80 fd ff ff    	jne    1bc <fibonacci+0x5c>
 43c:	8b 7d b8             	mov    -0x48(%ebp),%edi
 43f:	8b 5d b4             	mov    -0x4c(%ebp),%ebx
        return n;
 442:	01 f2                	add    %esi,%edx
 444:	01 d7                	add    %edx,%edi
    if (n <= 1)
 446:	83 fb 01             	cmp    $0x1,%ebx
 449:	0f 84 40 ff ff ff    	je     38f <fibonacci+0x22f>
 44f:	8b 75 8c             	mov    -0x74(%ebp),%esi
 452:	8d 53 ff             	lea    -0x1(%ebx),%edx
    return fibonacci(n - 1) + fibonacci(n - 2);
 455:	89 d0                	mov    %edx,%eax
    if (n <= 1)
 457:	39 f3                	cmp    %esi,%ebx
 459:	0f 85 36 fd ff ff    	jne    195 <fibonacci+0x35>
        return n;
 45f:	8d 34 3a             	lea    (%edx,%edi,1),%esi
}
 462:	8d 65 f4             	lea    -0xc(%ebp),%esp
 465:	89 f0                	mov    %esi,%eax
 467:	5b                   	pop    %ebx
 468:	5e                   	pop    %esi
 469:	5f                   	pop    %edi
 46a:	5d                   	pop    %ebp
 46b:	c3                   	ret
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000470 <busywork>:
{
 470:	55                   	push   %ebp
 471:	31 c9                	xor    %ecx,%ecx
 473:	89 e5                	mov    %esp,%ebp
 475:	56                   	push   %esi
 476:	53                   	push   %ebx
 477:	83 ec 10             	sub    $0x10,%esp
 47a:	8b 5d 08             	mov    0x8(%ebp),%ebx
    volatile int x = 0;
 47d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (int k = 0; k < ticks; k++)
 484:	85 db                	test   %ebx,%ebx
 486:	7e 26                	jle    4ae <busywork+0x3e>
{
 488:	ba 00 e1 f5 05       	mov    $0x5f5e100,%edx
 48d:	8d 76 00             	lea    0x0(%esi),%esi
            x++;
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	83 c0 01             	add    $0x1,%eax
 496:	89 45 f4             	mov    %eax,-0xc(%ebp)
            x--;
 499:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49c:	83 e8 01             	sub    $0x1,%eax
 49f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        for (int i = 0; i < LOOP_ITER; i++)
 4a2:	83 ea 01             	sub    $0x1,%edx
 4a5:	75 e9                	jne    490 <busywork+0x20>
    for (int k = 0; k < ticks; k++)
 4a7:	83 c1 01             	add    $0x1,%ecx
 4aa:	39 cb                	cmp    %ecx,%ebx
 4ac:	75 da                	jne    488 <busywork+0x18>
 4ae:	bb 1d 00 00 00       	mov    $0x1d,%ebx
 4b3:	31 f6                	xor    %esi,%esi
    return fibonacci(n - 1) + fibonacci(n - 2);
 4b5:	83 ec 0c             	sub    $0xc,%esp
 4b8:	53                   	push   %ebx
    if (n <= 1)
 4b9:	83 eb 02             	sub    $0x2,%ebx
    return fibonacci(n - 1) + fibonacci(n - 2);
 4bc:	e8 9f fc ff ff       	call   160 <fibonacci>
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	01 c6                	add    %eax,%esi
    if (n <= 1)
 4c6:	83 fb ff             	cmp    $0xffffffff,%ebx
 4c9:	75 ea                	jne    4b5 <busywork+0x45>
    printf(1,"fib: %d - " ,fibonacci(30));
 4cb:	83 ec 04             	sub    $0x4,%esp
 4ce:	56                   	push   %esi
 4cf:	68 c8 0b 00 00       	push   $0xbc8
 4d4:	6a 01                	push   $0x1
 4d6:	e8 e5 03 00 00       	call   8c0 <printf>
    printf(1, "  busyjob %d finished. \n", n);
 4db:	83 c4 0c             	add    $0xc,%esp
 4de:	ff 75 0c             	push   0xc(%ebp)
 4e1:	68 d3 0b 00 00       	push   $0xbd3
 4e6:	6a 01                	push   $0x1
 4e8:	e8 d3 03 00 00       	call   8c0 <printf>
}
 4ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4f0:	5b                   	pop    %ebx
 4f1:	5e                   	pop    %esi
 4f2:	5d                   	pop    %ebp
 4f3:	c3                   	ret
 4f4:	66 90                	xchg   %ax,%ax
 4f6:	66 90                	xchg   %ax,%ax
 4f8:	66 90                	xchg   %ax,%ax
 4fa:	66 90                	xchg   %ax,%ax
 4fc:	66 90                	xchg   %ax,%ax
 4fe:	66 90                	xchg   %ax,%ax

00000500 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 500:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 501:	31 c0                	xor    %eax,%eax
{
 503:	89 e5                	mov    %esp,%ebp
 505:	53                   	push   %ebx
 506:	8b 4d 08             	mov    0x8(%ebp),%ecx
 509:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 50c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 510:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 514:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 517:	83 c0 01             	add    $0x1,%eax
 51a:	84 d2                	test   %dl,%dl
 51c:	75 f2                	jne    510 <strcpy+0x10>
    ;
  return os;
}
 51e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 521:	89 c8                	mov    %ecx,%eax
 523:	c9                   	leave
 524:	c3                   	ret
 525:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 52c:	00 
 52d:	8d 76 00             	lea    0x0(%esi),%esi

00000530 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	53                   	push   %ebx
 534:	8b 55 08             	mov    0x8(%ebp),%edx
 537:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 53a:	0f b6 02             	movzbl (%edx),%eax
 53d:	84 c0                	test   %al,%al
 53f:	75 17                	jne    558 <strcmp+0x28>
 541:	eb 3a                	jmp    57d <strcmp+0x4d>
 543:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 548:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 54c:	83 c2 01             	add    $0x1,%edx
 54f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 552:	84 c0                	test   %al,%al
 554:	74 1a                	je     570 <strcmp+0x40>
 556:	89 d9                	mov    %ebx,%ecx
 558:	0f b6 19             	movzbl (%ecx),%ebx
 55b:	38 c3                	cmp    %al,%bl
 55d:	74 e9                	je     548 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 55f:	29 d8                	sub    %ebx,%eax
}
 561:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 564:	c9                   	leave
 565:	c3                   	ret
 566:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 56d:	00 
 56e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 570:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 574:	31 c0                	xor    %eax,%eax
 576:	29 d8                	sub    %ebx,%eax
}
 578:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 57b:	c9                   	leave
 57c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 57d:	0f b6 19             	movzbl (%ecx),%ebx
 580:	31 c0                	xor    %eax,%eax
 582:	eb db                	jmp    55f <strcmp+0x2f>
 584:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 58b:	00 
 58c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000590 <strlen>:

uint
strlen(const char *s)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 596:	80 3a 00             	cmpb   $0x0,(%edx)
 599:	74 15                	je     5b0 <strlen+0x20>
 59b:	31 c0                	xor    %eax,%eax
 59d:	8d 76 00             	lea    0x0(%esi),%esi
 5a0:	83 c0 01             	add    $0x1,%eax
 5a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 5a7:	89 c1                	mov    %eax,%ecx
 5a9:	75 f5                	jne    5a0 <strlen+0x10>
    ;
  return n;
}
 5ab:	89 c8                	mov    %ecx,%eax
 5ad:	5d                   	pop    %ebp
 5ae:	c3                   	ret
 5af:	90                   	nop
  for(n = 0; s[n]; n++)
 5b0:	31 c9                	xor    %ecx,%ecx
}
 5b2:	5d                   	pop    %ebp
 5b3:	89 c8                	mov    %ecx,%eax
 5b5:	c3                   	ret
 5b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 5bd:	00 
 5be:	66 90                	xchg   %ax,%ax

000005c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 5cd:	89 d7                	mov    %edx,%edi
 5cf:	fc                   	cld
 5d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5d2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 5d5:	89 d0                	mov    %edx,%eax
 5d7:	c9                   	leave
 5d8:	c3                   	ret
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005e0 <strchr>:

char*
strchr(const char *s, char c)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 5ea:	0f b6 10             	movzbl (%eax),%edx
 5ed:	84 d2                	test   %dl,%dl
 5ef:	75 12                	jne    603 <strchr+0x23>
 5f1:	eb 1d                	jmp    610 <strchr+0x30>
 5f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 5f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 5fc:	83 c0 01             	add    $0x1,%eax
 5ff:	84 d2                	test   %dl,%dl
 601:	74 0d                	je     610 <strchr+0x30>
    if(*s == c)
 603:	38 d1                	cmp    %dl,%cl
 605:	75 f1                	jne    5f8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 607:	5d                   	pop    %ebp
 608:	c3                   	ret
 609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 610:	31 c0                	xor    %eax,%eax
}
 612:	5d                   	pop    %ebp
 613:	c3                   	ret
 614:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 61b:	00 
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000620 <gets>:

char*
gets(char *buf, int max)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 625:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 628:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 629:	31 db                	xor    %ebx,%ebx
{
 62b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 62e:	eb 27                	jmp    657 <gets+0x37>
    cc = read(0, &c, 1);
 630:	83 ec 04             	sub    $0x4,%esp
 633:	6a 01                	push   $0x1
 635:	56                   	push   %esi
 636:	6a 00                	push   $0x0
 638:	e8 1e 01 00 00       	call   75b <read>
    if(cc < 1)
 63d:	83 c4 10             	add    $0x10,%esp
 640:	85 c0                	test   %eax,%eax
 642:	7e 1d                	jle    661 <gets+0x41>
      break;
    buf[i++] = c;
 644:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 648:	8b 55 08             	mov    0x8(%ebp),%edx
 64b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 64f:	3c 0a                	cmp    $0xa,%al
 651:	74 10                	je     663 <gets+0x43>
 653:	3c 0d                	cmp    $0xd,%al
 655:	74 0c                	je     663 <gets+0x43>
  for(i=0; i+1 < max; ){
 657:	89 df                	mov    %ebx,%edi
 659:	83 c3 01             	add    $0x1,%ebx
 65c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 65f:	7c cf                	jl     630 <gets+0x10>
 661:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 663:	8b 45 08             	mov    0x8(%ebp),%eax
 666:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 66a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66d:	5b                   	pop    %ebx
 66e:	5e                   	pop    %esi
 66f:	5f                   	pop    %edi
 670:	5d                   	pop    %ebp
 671:	c3                   	ret
 672:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 679:	00 
 67a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000680 <stat>:

int
stat(const char *n, struct stat *st)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	56                   	push   %esi
 684:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 685:	83 ec 08             	sub    $0x8,%esp
 688:	6a 00                	push   $0x0
 68a:	ff 75 08             	push   0x8(%ebp)
 68d:	e8 f1 00 00 00       	call   783 <open>
  if(fd < 0)
 692:	83 c4 10             	add    $0x10,%esp
 695:	85 c0                	test   %eax,%eax
 697:	78 27                	js     6c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 699:	83 ec 08             	sub    $0x8,%esp
 69c:	ff 75 0c             	push   0xc(%ebp)
 69f:	89 c3                	mov    %eax,%ebx
 6a1:	50                   	push   %eax
 6a2:	e8 f4 00 00 00       	call   79b <fstat>
  close(fd);
 6a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6aa:	89 c6                	mov    %eax,%esi
  close(fd);
 6ac:	e8 ba 00 00 00       	call   76b <close>
  return r;
 6b1:	83 c4 10             	add    $0x10,%esp
}
 6b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6b7:	89 f0                	mov    %esi,%eax
 6b9:	5b                   	pop    %ebx
 6ba:	5e                   	pop    %esi
 6bb:	5d                   	pop    %ebp
 6bc:	c3                   	ret
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 6c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6c5:	eb ed                	jmp    6b4 <stat+0x34>
 6c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ce:	00 
 6cf:	90                   	nop

000006d0 <atoi>:

int
atoi(const char *s)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	53                   	push   %ebx
 6d4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6d7:	0f be 02             	movsbl (%edx),%eax
 6da:	8d 48 d0             	lea    -0x30(%eax),%ecx
 6dd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 6e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 6e5:	77 1e                	ja     705 <atoi+0x35>
 6e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ee:	00 
 6ef:	90                   	nop
    n = n*10 + *s++ - '0';
 6f0:	83 c2 01             	add    $0x1,%edx
 6f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 6f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 6fa:	0f be 02             	movsbl (%edx),%eax
 6fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 700:	80 fb 09             	cmp    $0x9,%bl
 703:	76 eb                	jbe    6f0 <atoi+0x20>
  return n;
}
 705:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 708:	89 c8                	mov    %ecx,%eax
 70a:	c9                   	leave
 70b:	c3                   	ret
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000710 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	8b 45 10             	mov    0x10(%ebp),%eax
 717:	8b 55 08             	mov    0x8(%ebp),%edx
 71a:	56                   	push   %esi
 71b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 71e:	85 c0                	test   %eax,%eax
 720:	7e 13                	jle    735 <memmove+0x25>
 722:	01 d0                	add    %edx,%eax
  dst = vdst;
 724:	89 d7                	mov    %edx,%edi
 726:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 72d:	00 
 72e:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 730:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 731:	39 f8                	cmp    %edi,%eax
 733:	75 fb                	jne    730 <memmove+0x20>
  return vdst;
}
 735:	5e                   	pop    %esi
 736:	89 d0                	mov    %edx,%eax
 738:	5f                   	pop    %edi
 739:	5d                   	pop    %ebp
 73a:	c3                   	ret

0000073b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 73b:	b8 01 00 00 00       	mov    $0x1,%eax
 740:	cd 40                	int    $0x40
 742:	c3                   	ret

00000743 <exit>:
SYSCALL(exit)
 743:	b8 02 00 00 00       	mov    $0x2,%eax
 748:	cd 40                	int    $0x40
 74a:	c3                   	ret

0000074b <wait>:
SYSCALL(wait)
 74b:	b8 03 00 00 00       	mov    $0x3,%eax
 750:	cd 40                	int    $0x40
 752:	c3                   	ret

00000753 <pipe>:
SYSCALL(pipe)
 753:	b8 04 00 00 00       	mov    $0x4,%eax
 758:	cd 40                	int    $0x40
 75a:	c3                   	ret

0000075b <read>:
SYSCALL(read)
 75b:	b8 05 00 00 00       	mov    $0x5,%eax
 760:	cd 40                	int    $0x40
 762:	c3                   	ret

00000763 <write>:
SYSCALL(write)
 763:	b8 10 00 00 00       	mov    $0x10,%eax
 768:	cd 40                	int    $0x40
 76a:	c3                   	ret

0000076b <close>:
SYSCALL(close)
 76b:	b8 15 00 00 00       	mov    $0x15,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret

00000773 <kill>:
SYSCALL(kill)
 773:	b8 06 00 00 00       	mov    $0x6,%eax
 778:	cd 40                	int    $0x40
 77a:	c3                   	ret

0000077b <exec>:
SYSCALL(exec)
 77b:	b8 07 00 00 00       	mov    $0x7,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret

00000783 <open>:
SYSCALL(open)
 783:	b8 0f 00 00 00       	mov    $0xf,%eax
 788:	cd 40                	int    $0x40
 78a:	c3                   	ret

0000078b <mknod>:
SYSCALL(mknod)
 78b:	b8 11 00 00 00       	mov    $0x11,%eax
 790:	cd 40                	int    $0x40
 792:	c3                   	ret

00000793 <unlink>:
SYSCALL(unlink)
 793:	b8 12 00 00 00       	mov    $0x12,%eax
 798:	cd 40                	int    $0x40
 79a:	c3                   	ret

0000079b <fstat>:
SYSCALL(fstat)
 79b:	b8 08 00 00 00       	mov    $0x8,%eax
 7a0:	cd 40                	int    $0x40
 7a2:	c3                   	ret

000007a3 <link>:
SYSCALL(link)
 7a3:	b8 13 00 00 00       	mov    $0x13,%eax
 7a8:	cd 40                	int    $0x40
 7aa:	c3                   	ret

000007ab <mkdir>:
SYSCALL(mkdir)
 7ab:	b8 14 00 00 00       	mov    $0x14,%eax
 7b0:	cd 40                	int    $0x40
 7b2:	c3                   	ret

000007b3 <chdir>:
SYSCALL(chdir)
 7b3:	b8 09 00 00 00       	mov    $0x9,%eax
 7b8:	cd 40                	int    $0x40
 7ba:	c3                   	ret

000007bb <dup>:
SYSCALL(dup)
 7bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret

000007c3 <getpid>:
SYSCALL(getpid)
 7c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 7c8:	cd 40                	int    $0x40
 7ca:	c3                   	ret

000007cb <sbrk>:
SYSCALL(sbrk)
 7cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret

000007d3 <sleep>:
SYSCALL(sleep)
 7d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret

000007db <uptime>:
SYSCALL(uptime)
 7db:	b8 0e 00 00 00       	mov    $0xe,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret

000007e3 <set_process_deadline>:
SYSCALL(set_process_deadline)
 7e3:	b8 16 00 00 00       	mov    $0x16,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret

000007eb <change_sched_level>:
SYSCALL(change_sched_level)
 7eb:	b8 17 00 00 00       	mov    $0x17,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret

000007f3 <print_sched_info>:
SYSCALL(print_sched_info)
 7f3:	b8 19 00 00 00       	mov    $0x19,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret

000007fb <update_wait_time>:
SYSCALL(update_wait_time)
 7fb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 800:	cd 40                	int    $0x40
 802:	c3                   	ret

00000803 <is_higher_waiting>:
SYSCALL(is_higher_waiting)
 803:	b8 1b 00 00 00       	mov    $0x1b,%eax
 808:	cd 40                	int    $0x40
 80a:	c3                   	ret

0000080b <set_deadline_for_process>:
SYSCALL(set_deadline_for_process)
 80b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 810:	cd 40                	int    $0x40
 812:	c3                   	ret
 813:	66 90                	xchg   %ax,%ax
 815:	66 90                	xchg   %ax,%ax
 817:	66 90                	xchg   %ax,%ax
 819:	66 90                	xchg   %ax,%ax
 81b:	66 90                	xchg   %ax,%ax
 81d:	66 90                	xchg   %ax,%ax
 81f:	90                   	nop

00000820 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	57                   	push   %edi
 824:	56                   	push   %esi
 825:	53                   	push   %ebx
 826:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 828:	89 d1                	mov    %edx,%ecx
{
 82a:	83 ec 3c             	sub    $0x3c,%esp
 82d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 830:	85 d2                	test   %edx,%edx
 832:	0f 89 80 00 00 00    	jns    8b8 <printint+0x98>
 838:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 83c:	74 7a                	je     8b8 <printint+0x98>
    x = -xx;
 83e:	f7 d9                	neg    %ecx
    neg = 1;
 840:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 845:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 848:	31 f6                	xor    %esi,%esi
 84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 850:	89 c8                	mov    %ecx,%eax
 852:	31 d2                	xor    %edx,%edx
 854:	89 f7                	mov    %esi,%edi
 856:	f7 f3                	div    %ebx
 858:	8d 76 01             	lea    0x1(%esi),%esi
 85b:	0f b6 92 b0 0c 00 00 	movzbl 0xcb0(%edx),%edx
 862:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 866:	89 ca                	mov    %ecx,%edx
 868:	89 c1                	mov    %eax,%ecx
 86a:	39 da                	cmp    %ebx,%edx
 86c:	73 e2                	jae    850 <printint+0x30>
  if(neg)
 86e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 871:	85 c0                	test   %eax,%eax
 873:	74 07                	je     87c <printint+0x5c>
    buf[i++] = '-';
 875:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 87a:	89 f7                	mov    %esi,%edi
 87c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 87f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 882:	01 df                	add    %ebx,%edi
 884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 888:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 88b:	83 ec 04             	sub    $0x4,%esp
 88e:	88 45 d7             	mov    %al,-0x29(%ebp)
 891:	8d 45 d7             	lea    -0x29(%ebp),%eax
 894:	6a 01                	push   $0x1
 896:	50                   	push   %eax
 897:	56                   	push   %esi
 898:	e8 c6 fe ff ff       	call   763 <write>
  while(--i >= 0)
 89d:	89 f8                	mov    %edi,%eax
 89f:	83 c4 10             	add    $0x10,%esp
 8a2:	83 ef 01             	sub    $0x1,%edi
 8a5:	39 c3                	cmp    %eax,%ebx
 8a7:	75 df                	jne    888 <printint+0x68>
}
 8a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8ac:	5b                   	pop    %ebx
 8ad:	5e                   	pop    %esi
 8ae:	5f                   	pop    %edi
 8af:	5d                   	pop    %ebp
 8b0:	c3                   	ret
 8b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 8b8:	31 c0                	xor    %eax,%eax
 8ba:	eb 89                	jmp    845 <printint+0x25>
 8bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	57                   	push   %edi
 8c4:	56                   	push   %esi
 8c5:	53                   	push   %ebx
 8c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8c9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 8cc:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 8cf:	0f b6 1e             	movzbl (%esi),%ebx
 8d2:	83 c6 01             	add    $0x1,%esi
 8d5:	84 db                	test   %bl,%bl
 8d7:	74 67                	je     940 <printf+0x80>
 8d9:	8d 4d 10             	lea    0x10(%ebp),%ecx
 8dc:	31 d2                	xor    %edx,%edx
 8de:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 8e1:	eb 34                	jmp    917 <printf+0x57>
 8e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 8e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 8eb:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 8f0:	83 f8 25             	cmp    $0x25,%eax
 8f3:	74 18                	je     90d <printf+0x4d>
  write(fd, &c, 1);
 8f5:	83 ec 04             	sub    $0x4,%esp
 8f8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 8fb:	88 5d e7             	mov    %bl,-0x19(%ebp)
 8fe:	6a 01                	push   $0x1
 900:	50                   	push   %eax
 901:	57                   	push   %edi
 902:	e8 5c fe ff ff       	call   763 <write>
 907:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 90a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 90d:	0f b6 1e             	movzbl (%esi),%ebx
 910:	83 c6 01             	add    $0x1,%esi
 913:	84 db                	test   %bl,%bl
 915:	74 29                	je     940 <printf+0x80>
    c = fmt[i] & 0xff;
 917:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 91a:	85 d2                	test   %edx,%edx
 91c:	74 ca                	je     8e8 <printf+0x28>
      }
    } else if(state == '%'){
 91e:	83 fa 25             	cmp    $0x25,%edx
 921:	75 ea                	jne    90d <printf+0x4d>
      if(c == 'd'){
 923:	83 f8 25             	cmp    $0x25,%eax
 926:	0f 84 04 01 00 00    	je     a30 <printf+0x170>
 92c:	83 e8 63             	sub    $0x63,%eax
 92f:	83 f8 15             	cmp    $0x15,%eax
 932:	77 1c                	ja     950 <printf+0x90>
 934:	ff 24 85 58 0c 00 00 	jmp    *0xc58(,%eax,4)
 93b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 940:	8d 65 f4             	lea    -0xc(%ebp),%esp
 943:	5b                   	pop    %ebx
 944:	5e                   	pop    %esi
 945:	5f                   	pop    %edi
 946:	5d                   	pop    %ebp
 947:	c3                   	ret
 948:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 94f:	00 
  write(fd, &c, 1);
 950:	83 ec 04             	sub    $0x4,%esp
 953:	8d 55 e7             	lea    -0x19(%ebp),%edx
 956:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 95a:	6a 01                	push   $0x1
 95c:	52                   	push   %edx
 95d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 960:	57                   	push   %edi
 961:	e8 fd fd ff ff       	call   763 <write>
 966:	83 c4 0c             	add    $0xc,%esp
 969:	88 5d e7             	mov    %bl,-0x19(%ebp)
 96c:	6a 01                	push   $0x1
 96e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 971:	52                   	push   %edx
 972:	57                   	push   %edi
 973:	e8 eb fd ff ff       	call   763 <write>
        putc(fd, c);
 978:	83 c4 10             	add    $0x10,%esp
      state = 0;
 97b:	31 d2                	xor    %edx,%edx
 97d:	eb 8e                	jmp    90d <printf+0x4d>
 97f:	90                   	nop
        printint(fd, *ap, 16, 0);
 980:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 983:	83 ec 0c             	sub    $0xc,%esp
 986:	b9 10 00 00 00       	mov    $0x10,%ecx
 98b:	8b 13                	mov    (%ebx),%edx
 98d:	6a 00                	push   $0x0
 98f:	89 f8                	mov    %edi,%eax
        ap++;
 991:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 994:	e8 87 fe ff ff       	call   820 <printint>
        ap++;
 999:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 99c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 99f:	31 d2                	xor    %edx,%edx
 9a1:	e9 67 ff ff ff       	jmp    90d <printf+0x4d>
        s = (char*)*ap;
 9a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
 9a9:	8b 18                	mov    (%eax),%ebx
        ap++;
 9ab:	83 c0 04             	add    $0x4,%eax
 9ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 9b1:	85 db                	test   %ebx,%ebx
 9b3:	0f 84 87 00 00 00    	je     a40 <printf+0x180>
        while(*s != 0){
 9b9:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 9bc:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 9be:	84 c0                	test   %al,%al
 9c0:	0f 84 47 ff ff ff    	je     90d <printf+0x4d>
 9c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 9c9:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 9cc:	89 de                	mov    %ebx,%esi
 9ce:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 9d0:	83 ec 04             	sub    $0x4,%esp
 9d3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 9d6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 9d9:	6a 01                	push   $0x1
 9db:	53                   	push   %ebx
 9dc:	57                   	push   %edi
 9dd:	e8 81 fd ff ff       	call   763 <write>
        while(*s != 0){
 9e2:	0f b6 06             	movzbl (%esi),%eax
 9e5:	83 c4 10             	add    $0x10,%esp
 9e8:	84 c0                	test   %al,%al
 9ea:	75 e4                	jne    9d0 <printf+0x110>
      state = 0;
 9ec:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 9ef:	31 d2                	xor    %edx,%edx
 9f1:	e9 17 ff ff ff       	jmp    90d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 9f6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 9f9:	83 ec 0c             	sub    $0xc,%esp
 9fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a01:	8b 13                	mov    (%ebx),%edx
 a03:	6a 01                	push   $0x1
 a05:	eb 88                	jmp    98f <printf+0xcf>
        putc(fd, *ap);
 a07:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 a0a:	83 ec 04             	sub    $0x4,%esp
 a0d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 a10:	8b 03                	mov    (%ebx),%eax
        ap++;
 a12:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 a15:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a18:	6a 01                	push   $0x1
 a1a:	52                   	push   %edx
 a1b:	57                   	push   %edi
 a1c:	e8 42 fd ff ff       	call   763 <write>
        ap++;
 a21:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 a24:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a27:	31 d2                	xor    %edx,%edx
 a29:	e9 df fe ff ff       	jmp    90d <printf+0x4d>
 a2e:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 a30:	83 ec 04             	sub    $0x4,%esp
 a33:	88 5d e7             	mov    %bl,-0x19(%ebp)
 a36:	8d 55 e7             	lea    -0x19(%ebp),%edx
 a39:	6a 01                	push   $0x1
 a3b:	e9 31 ff ff ff       	jmp    971 <printf+0xb1>
 a40:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 a45:	bb 07 0c 00 00       	mov    $0xc07,%ebx
 a4a:	e9 77 ff ff ff       	jmp    9c6 <printf+0x106>
 a4f:	90                   	nop

00000a50 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a50:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a51:	a1 c0 0f 00 00       	mov    0xfc0,%eax
{
 a56:	89 e5                	mov    %esp,%ebp
 a58:	57                   	push   %edi
 a59:	56                   	push   %esi
 a5a:	53                   	push   %ebx
 a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 a5e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a68:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6a:	39 c8                	cmp    %ecx,%eax
 a6c:	73 32                	jae    aa0 <free+0x50>
 a6e:	39 d1                	cmp    %edx,%ecx
 a70:	72 04                	jb     a76 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a72:	39 d0                	cmp    %edx,%eax
 a74:	72 32                	jb     aa8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a76:	8b 73 fc             	mov    -0x4(%ebx),%esi
 a79:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a7c:	39 fa                	cmp    %edi,%edx
 a7e:	74 30                	je     ab0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a80:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a83:	8b 50 04             	mov    0x4(%eax),%edx
 a86:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 a89:	39 f1                	cmp    %esi,%ecx
 a8b:	74 3a                	je     ac7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a8d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 a8f:	5b                   	pop    %ebx
  freep = p;
 a90:	a3 c0 0f 00 00       	mov    %eax,0xfc0
}
 a95:	5e                   	pop    %esi
 a96:	5f                   	pop    %edi
 a97:	5d                   	pop    %ebp
 a98:	c3                   	ret
 a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa0:	39 d0                	cmp    %edx,%eax
 aa2:	72 04                	jb     aa8 <free+0x58>
 aa4:	39 d1                	cmp    %edx,%ecx
 aa6:	72 ce                	jb     a76 <free+0x26>
{
 aa8:	89 d0                	mov    %edx,%eax
 aaa:	eb bc                	jmp    a68 <free+0x18>
 aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 ab0:	03 72 04             	add    0x4(%edx),%esi
 ab3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 ab6:	8b 10                	mov    (%eax),%edx
 ab8:	8b 12                	mov    (%edx),%edx
 aba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 abd:	8b 50 04             	mov    0x4(%eax),%edx
 ac0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ac3:	39 f1                	cmp    %esi,%ecx
 ac5:	75 c6                	jne    a8d <free+0x3d>
    p->s.size += bp->s.size;
 ac7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 aca:	a3 c0 0f 00 00       	mov    %eax,0xfc0
    p->s.size += bp->s.size;
 acf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ad2:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 ad5:	89 08                	mov    %ecx,(%eax)
}
 ad7:	5b                   	pop    %ebx
 ad8:	5e                   	pop    %esi
 ad9:	5f                   	pop    %edi
 ada:	5d                   	pop    %ebp
 adb:	c3                   	ret
 adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ae0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ae0:	55                   	push   %ebp
 ae1:	89 e5                	mov    %esp,%ebp
 ae3:	57                   	push   %edi
 ae4:	56                   	push   %esi
 ae5:	53                   	push   %ebx
 ae6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 aec:	8b 15 c0 0f 00 00    	mov    0xfc0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 af2:	8d 78 07             	lea    0x7(%eax),%edi
 af5:	c1 ef 03             	shr    $0x3,%edi
 af8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 afb:	85 d2                	test   %edx,%edx
 afd:	0f 84 8d 00 00 00    	je     b90 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b03:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b05:	8b 48 04             	mov    0x4(%eax),%ecx
 b08:	39 f9                	cmp    %edi,%ecx
 b0a:	73 64                	jae    b70 <malloc+0x90>
  if(nu < 4096)
 b0c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b11:	39 df                	cmp    %ebx,%edi
 b13:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 b16:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 b1d:	eb 0a                	jmp    b29 <malloc+0x49>
 b1f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b20:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b22:	8b 48 04             	mov    0x4(%eax),%ecx
 b25:	39 f9                	cmp    %edi,%ecx
 b27:	73 47                	jae    b70 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b29:	89 c2                	mov    %eax,%edx
 b2b:	3b 05 c0 0f 00 00    	cmp    0xfc0,%eax
 b31:	75 ed                	jne    b20 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 b33:	83 ec 0c             	sub    $0xc,%esp
 b36:	56                   	push   %esi
 b37:	e8 8f fc ff ff       	call   7cb <sbrk>
  if(p == (char*)-1)
 b3c:	83 c4 10             	add    $0x10,%esp
 b3f:	83 f8 ff             	cmp    $0xffffffff,%eax
 b42:	74 1c                	je     b60 <malloc+0x80>
  hp->s.size = nu;
 b44:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 b47:	83 ec 0c             	sub    $0xc,%esp
 b4a:	83 c0 08             	add    $0x8,%eax
 b4d:	50                   	push   %eax
 b4e:	e8 fd fe ff ff       	call   a50 <free>
  return freep;
 b53:	8b 15 c0 0f 00 00    	mov    0xfc0,%edx
      if((p = morecore(nunits)) == 0)
 b59:	83 c4 10             	add    $0x10,%esp
 b5c:	85 d2                	test   %edx,%edx
 b5e:	75 c0                	jne    b20 <malloc+0x40>
        return 0;
  }
}
 b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 b63:	31 c0                	xor    %eax,%eax
}
 b65:	5b                   	pop    %ebx
 b66:	5e                   	pop    %esi
 b67:	5f                   	pop    %edi
 b68:	5d                   	pop    %ebp
 b69:	c3                   	ret
 b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 b70:	39 cf                	cmp    %ecx,%edi
 b72:	74 4c                	je     bc0 <malloc+0xe0>
        p->s.size -= nunits;
 b74:	29 f9                	sub    %edi,%ecx
 b76:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 b79:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 b7c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 b7f:	89 15 c0 0f 00 00    	mov    %edx,0xfc0
}
 b85:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 b88:	83 c0 08             	add    $0x8,%eax
}
 b8b:	5b                   	pop    %ebx
 b8c:	5e                   	pop    %esi
 b8d:	5f                   	pop    %edi
 b8e:	5d                   	pop    %ebp
 b8f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 b90:	c7 05 c0 0f 00 00 c4 	movl   $0xfc4,0xfc0
 b97:	0f 00 00 
    base.s.size = 0;
 b9a:	b8 c4 0f 00 00       	mov    $0xfc4,%eax
    base.s.ptr = freep = prevp = &base;
 b9f:	c7 05 c4 0f 00 00 c4 	movl   $0xfc4,0xfc4
 ba6:	0f 00 00 
    base.s.size = 0;
 ba9:	c7 05 c8 0f 00 00 00 	movl   $0x0,0xfc8
 bb0:	00 00 00 
    if(p->s.size >= nunits){
 bb3:	e9 54 ff ff ff       	jmp    b0c <malloc+0x2c>
 bb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 bbf:	00 
        prevp->s.ptr = p->s.ptr;
 bc0:	8b 08                	mov    (%eax),%ecx
 bc2:	89 0a                	mov    %ecx,(%edx)
 bc4:	eb b9                	jmp    b7f <malloc+0x9f>
