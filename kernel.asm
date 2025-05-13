
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 6e 11 80       	mov    $0x80116ef0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 80 10 80       	push   $0x80108020
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 35 4f 00 00       	call   80104f90 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 80 10 80       	push   $0x80108027
80100097:	50                   	push   %eax
80100098:	e8 c3 4d 00 00       	call   80104e60 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 97 50 00 00       	call   80105180 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 b9 4f 00 00       	call   80105120 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 4d 00 00       	call   80104ea0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 6f 21 00 00       	call   80102300 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 2e 80 10 80       	push   $0x8010802e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 7d 4d 00 00       	call   80104f40 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 27 21 00 00       	jmp    80102300 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 3f 80 10 80       	push   $0x8010803f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 4d 00 00       	call   80104f40 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ec 4c 00 00       	call   80104f00 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 60 4f 00 00       	call   80105180 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 b2 4e 00 00       	jmp    80105120 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 46 80 10 80       	push   $0x80108046
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 17 16 00 00       	call   801018b0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 db 4e 00 00       	call   80105180 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 1e 41 00 00       	call   801043f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 37 00 00       	call   80103ab0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 25 4e 00 00       	call   80105120 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 cc 14 00 00       	call   801017d0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 cf 4d 00 00       	call   80105120 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 76 14 00 00       	call   801017d0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 25 00 00       	call   80102900 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 4d 80 10 80       	push   $0x8010804d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 57 83 10 80 	movl   $0x80108357,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 e3 4b 00 00       	call   80104fb0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 80 10 80       	push   $0x80108061
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 ac 66 00 00       	call   80106ad0 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 e1 65 00 00       	call   80106ad0 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 d5 65 00 00       	call   80106ad0 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 c9 65 00 00       	call   80106ad0 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 aa 4d 00 00       	call   80105310 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 05 4d 00 00       	call   80105280 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 65 80 10 80       	push   $0x80108065
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 ec 12 00 00       	call   801018b0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005cb:	e8 b0 4b 00 00       	call   80105180 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ff 10 80       	push   $0x8010ff20
80100604:	e8 17 4b 00 00       	call   80105120 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 be 11 00 00       	call   801017d0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 cc 85 10 80 	movzbl -0x7fef7a34(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ff 10 80       	push   $0x8010ff20
801007d8:	e8 a3 49 00 00       	call   80105180 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ff 10 80       	push   $0x8010ff20
801007fb:	e8 20 49 00 00       	call   80105120 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 78 80 10 80       	mov    $0x80108078,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 7f 80 10 80       	push   $0x8010807f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ff 10 80       	push   $0x8010ff20
801008b3:	e8 c8 48 00 00       	call   80105180 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ff 10 80       	push   $0x8010ff20
801008ed:	e8 2e 48 00 00       	call   80105120 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100914:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100933:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010094a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
8010095e:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100998:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a05:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a27:	68 00 ff 10 80       	push   $0x8010ff00
80100a2c:	e8 2f 3c 00 00       	call   80104660 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 4c 3d 00 00       	jmp    801047a0 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 88 80 10 80       	push   $0x80108088
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 1b 45 00 00       	call   80104f90 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 b0 	movl   $0x801005b0,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 f2 19 00 00       	call   80102490 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "defs.h"
#include "x86.h"
#include "elf.h"
int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 ef 2f 00 00       	call   80103ab0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 a4 22 00 00       	call   80102d70 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 d9 15 00 00       	call   801020b0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 5c 03 00 00    	je     80100e3e <exec+0x38e>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 e3 0c 00 00       	call   801017d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 e2 0f 00 00       	call   80101ae0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 c1 71 00 00       	call   80107ce0 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 cd 02 00 00    	je     80100e0e <exec+0x35e>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 80 6f 00 00       	call   80107b10 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 7a 6e 00 00       	call   80107a40 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 f2 0e 00 00       	call   80101ae0 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 58 70 00 00       	call   80107c60 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 4c 0e 00 00       	call   80101a60 <iunlockput>
    end_op();
80100c14:	e8 c7 21 00 00       	call   80102de0 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 0f 0e 00 00       	call   80101a60 <iunlockput>
  end_op();
80100c51:	e8 8a 21 00 00       	call   80102de0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 a9 6e 00 00       	call   80107b10 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 f8 70 00 00       	call   80107d80 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 82 01 00 00    	je     80100e1a <exec+0x36a>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 a1 47 00 00       	call   80105470 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 90 47 00 00       	call   80105470 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 5d 72 00 00       	call   80107f50 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 58 6f 00 00       	call   80107c60 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 ec 71 00 00       	call   80107f50 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 8c 46 00 00       	call   80105430 <safestrcpy>
if(curproc->pid == 1 ||  curproc->pid == 2){
80100da4:	8b 46 10             	mov    0x10(%esi),%eax
80100da7:	83 c4 10             	add    $0x10,%esp
80100daa:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100db0:	83 e8 01             	sub    $0x1,%eax
80100db3:	83 f8 01             	cmp    $0x1,%eax
80100db6:	76 43                	jbe    80100dfb <exec+0x34b>
  oldpgdir = curproc->pgdir;
80100db8:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  curproc->pgdir = pgdir;
80100dbe:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  switchuvm(curproc);
80100dc4:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80100dc7:	89 38                	mov    %edi,(%eax)
  oldpgdir = curproc->pgdir;
80100dc9:	8b 70 04             	mov    0x4(%eax),%esi
  curproc->pgdir = pgdir;
80100dcc:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dcf:	89 c1                	mov    %eax,%ecx
80100dd1:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dd7:	8b 40 18             	mov    0x18(%eax),%eax
80100dda:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ddd:	8b 41 18             	mov    0x18(%ecx),%eax
80100de0:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100de3:	51                   	push   %ecx
80100de4:	e8 c7 6a 00 00       	call   801078b0 <switchuvm>
  freevm(oldpgdir);
80100de9:	89 34 24             	mov    %esi,(%esp)
80100dec:	e8 6f 6e 00 00       	call   80107c60 <freevm>
  return 0;
80100df1:	83 c4 10             	add    $0x10,%esp
80100df4:	31 c0                	xor    %eax,%eax
80100df6:	e9 26 fe ff ff       	jmp    80100c21 <exec+0x171>
    curproc->sched_class = 2;
80100dfb:	c7 46 7c 02 00 00 00 	movl   $0x2,0x7c(%esi)
    curproc->sched_level = 1;
80100e02:	c7 86 80 00 00 00 01 	movl   $0x1,0x80(%esi)
80100e09:	00 00 00 
80100e0c:	eb aa                	jmp    80100db8 <exec+0x308>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e0e:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e13:	31 f6                	xor    %esi,%esi
80100e15:	e9 2e fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e1a:	be 10 00 00 00       	mov    $0x10,%esi
80100e1f:	ba 04 00 00 00       	mov    $0x4,%edx
80100e24:	b8 03 00 00 00       	mov    $0x3,%eax
80100e29:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e30:	00 00 00 
80100e33:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e39:	e9 eb fe ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e3e:	e8 9d 1f 00 00       	call   80102de0 <end_op>
    cprintf("exec: fail\n");
80100e43:	83 ec 0c             	sub    $0xc,%esp
80100e46:	68 90 80 10 80       	push   $0x80108090
80100e4b:	e8 60 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e50:	83 c4 10             	add    $0x10,%esp
80100e53:	e9 c4 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e58:	66 90                	xchg   %ax,%ax
80100e5a:	66 90                	xchg   %ax,%ax
80100e5c:	66 90                	xchg   %ax,%ax
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e66:	68 9c 80 10 80       	push   $0x8010809c
80100e6b:	68 60 ff 10 80       	push   $0x8010ff60
80100e70:	e8 1b 41 00 00       	call   80104f90 <initlock>
}
80100e75:	83 c4 10             	add    $0x10,%esp
80100e78:	c9                   	leave
80100e79:	c3                   	ret
80100e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e84:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e8c:	68 60 ff 10 80       	push   $0x8010ff60
80100e91:	e8 ea 42 00 00       	call   80105180 <acquire>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb 10                	jmp    80100eab <filealloc+0x2b>
80100e9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea0:	83 c3 18             	add    $0x18,%ebx
80100ea3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100ea9:	74 25                	je     80100ed0 <filealloc+0x50>
    if(f->ref == 0){
80100eab:	8b 43 04             	mov    0x4(%ebx),%eax
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	75 ee                	jne    80100ea0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100eb2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100eb5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ebc:	68 60 ff 10 80       	push   $0x8010ff60
80100ec1:	e8 5a 42 00 00       	call   80105120 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ec6:	89 d8                	mov    %ebx,%eax
      return f;
80100ec8:	83 c4 10             	add    $0x10,%esp
}
80100ecb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ece:	c9                   	leave
80100ecf:	c3                   	ret
  release(&ftable.lock);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ed3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ed5:	68 60 ff 10 80       	push   $0x8010ff60
80100eda:	e8 41 42 00 00       	call   80105120 <release>
}
80100edf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ee1:	83 c4 10             	add    $0x10,%esp
}
80100ee4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee7:	c9                   	leave
80100ee8:	c3                   	ret
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 10             	sub    $0x10,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100efa:	68 60 ff 10 80       	push   $0x8010ff60
80100eff:	e8 7c 42 00 00       	call   80105180 <acquire>
  if(f->ref < 1)
80100f04:	8b 43 04             	mov    0x4(%ebx),%eax
80100f07:	83 c4 10             	add    $0x10,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 1a                	jle    80100f28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f17:	68 60 ff 10 80       	push   $0x8010ff60
80100f1c:	e8 ff 41 00 00       	call   80105120 <release>
  return f;
}
80100f21:	89 d8                	mov    %ebx,%eax
80100f23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f26:	c9                   	leave
80100f27:	c3                   	ret
    panic("filedup");
80100f28:	83 ec 0c             	sub    $0xc,%esp
80100f2b:	68 a3 80 10 80       	push   $0x801080a3
80100f30:	e8 4b f4 ff ff       	call   80100380 <panic>
80100f35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f3c:	00 
80100f3d:	8d 76 00             	lea    0x0(%esi),%esi

80100f40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 28             	sub    $0x28,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f4c:	68 60 ff 10 80       	push   $0x8010ff60
80100f51:	e8 2a 42 00 00       	call   80105180 <acquire>
  if(f->ref < 1)
80100f56:	8b 53 04             	mov    0x4(%ebx),%edx
80100f59:	83 c4 10             	add    $0x10,%esp
80100f5c:	85 d2                	test   %edx,%edx
80100f5e:	0f 8e a5 00 00 00    	jle    80101009 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f64:	83 ea 01             	sub    $0x1,%edx
80100f67:	89 53 04             	mov    %edx,0x4(%ebx)
80100f6a:	75 44                	jne    80100fb0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f73:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f7b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f7e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f81:	8b 43 10             	mov    0x10(%ebx),%eax
80100f84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f87:	68 60 ff 10 80       	push   $0x8010ff60
80100f8c:	e8 8f 41 00 00       	call   80105120 <release>

  if(ff.type == FD_PIPE)
80100f91:	83 c4 10             	add    $0x10,%esp
80100f94:	83 ff 01             	cmp    $0x1,%edi
80100f97:	74 57                	je     80100ff0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f99:	83 ff 02             	cmp    $0x2,%edi
80100f9c:	74 2a                	je     80100fc8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
80100fa5:	c3                   	ret
80100fa6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fad:	00 
80100fae:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100fb0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fba:	5b                   	pop    %ebx
80100fbb:	5e                   	pop    %esi
80100fbc:	5f                   	pop    %edi
80100fbd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fbe:	e9 5d 41 00 00       	jmp    80105120 <release>
80100fc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100fc8:	e8 a3 1d 00 00       	call   80102d70 <begin_op>
    iput(ff.ip);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	ff 75 e0             	push   -0x20(%ebp)
80100fd3:	e8 28 09 00 00       	call   80101900 <iput>
    end_op();
80100fd8:	83 c4 10             	add    $0x10,%esp
}
80100fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fde:	5b                   	pop    %ebx
80100fdf:	5e                   	pop    %esi
80100fe0:	5f                   	pop    %edi
80100fe1:	5d                   	pop    %ebp
    end_op();
80100fe2:	e9 f9 1d 00 00       	jmp    80102de0 <end_op>
80100fe7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fee:	00 
80100fef:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100ff0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ff4:	83 ec 08             	sub    $0x8,%esp
80100ff7:	53                   	push   %ebx
80100ff8:	56                   	push   %esi
80100ff9:	e8 32 25 00 00       	call   80103530 <pipeclose>
80100ffe:	83 c4 10             	add    $0x10,%esp
}
80101001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101004:	5b                   	pop    %ebx
80101005:	5e                   	pop    %esi
80101006:	5f                   	pop    %edi
80101007:	5d                   	pop    %ebp
80101008:	c3                   	ret
    panic("fileclose");
80101009:	83 ec 0c             	sub    $0xc,%esp
8010100c:	68 ab 80 10 80       	push   $0x801080ab
80101011:	e8 6a f3 ff ff       	call   80100380 <panic>
80101016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010101d:	00 
8010101e:	66 90                	xchg   %ax,%ax

80101020 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
80101024:	83 ec 04             	sub    $0x4,%esp
80101027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010102a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010102d:	75 31                	jne    80101060 <filestat+0x40>
    ilock(f->ip);
8010102f:	83 ec 0c             	sub    $0xc,%esp
80101032:	ff 73 10             	push   0x10(%ebx)
80101035:	e8 96 07 00 00       	call   801017d0 <ilock>
    stati(f->ip, st);
8010103a:	58                   	pop    %eax
8010103b:	5a                   	pop    %edx
8010103c:	ff 75 0c             	push   0xc(%ebp)
8010103f:	ff 73 10             	push   0x10(%ebx)
80101042:	e8 69 0a 00 00       	call   80101ab0 <stati>
    iunlock(f->ip);
80101047:	59                   	pop    %ecx
80101048:	ff 73 10             	push   0x10(%ebx)
8010104b:	e8 60 08 00 00       	call   801018b0 <iunlock>
    return 0;
  }
  return -1;
}
80101050:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101053:	83 c4 10             	add    $0x10,%esp
80101056:	31 c0                	xor    %eax,%eax
}
80101058:	c9                   	leave
80101059:	c3                   	ret
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101068:	c9                   	leave
80101069:	c3                   	ret
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101070 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 0c             	sub    $0xc,%esp
80101079:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010107c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010107f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101082:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101086:	74 60                	je     801010e8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101088:	8b 03                	mov    (%ebx),%eax
8010108a:	83 f8 01             	cmp    $0x1,%eax
8010108d:	74 41                	je     801010d0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108f:	83 f8 02             	cmp    $0x2,%eax
80101092:	75 5b                	jne    801010ef <fileread+0x7f>
    ilock(f->ip);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 73 10             	push   0x10(%ebx)
8010109a:	e8 31 07 00 00       	call   801017d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010109f:	57                   	push   %edi
801010a0:	ff 73 14             	push   0x14(%ebx)
801010a3:	56                   	push   %esi
801010a4:	ff 73 10             	push   0x10(%ebx)
801010a7:	e8 34 0a 00 00       	call   80101ae0 <readi>
801010ac:	83 c4 20             	add    $0x20,%esp
801010af:	89 c6                	mov    %eax,%esi
801010b1:	85 c0                	test   %eax,%eax
801010b3:	7e 03                	jle    801010b8 <fileread+0x48>
      f->off += r;
801010b5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010b8:	83 ec 0c             	sub    $0xc,%esp
801010bb:	ff 73 10             	push   0x10(%ebx)
801010be:	e8 ed 07 00 00       	call   801018b0 <iunlock>
    return r;
801010c3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c9:	89 f0                	mov    %esi,%eax
801010cb:	5b                   	pop    %ebx
801010cc:	5e                   	pop    %esi
801010cd:	5f                   	pop    %edi
801010ce:	5d                   	pop    %ebp
801010cf:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010d3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010dd:	e9 0e 26 00 00       	jmp    801036f0 <piperead>
801010e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010ed:	eb d7                	jmp    801010c6 <fileread+0x56>
  panic("fileread");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 b5 80 10 80       	push   $0x801080b5
801010f7:	e8 84 f2 ff ff       	call   80100380 <panic>
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101100 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
80101109:	8b 45 0c             	mov    0xc(%ebp),%eax
8010110c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010110f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101112:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101115:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010111c:	0f 84 bb 00 00 00    	je     801011dd <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101122:	8b 03                	mov    (%ebx),%eax
80101124:	83 f8 01             	cmp    $0x1,%eax
80101127:	0f 84 bf 00 00 00    	je     801011ec <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010112d:	83 f8 02             	cmp    $0x2,%eax
80101130:	0f 85 c8 00 00 00    	jne    801011fe <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101139:	31 f6                	xor    %esi,%esi
    while(i < n){
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 30                	jg     8010116f <filewrite+0x6f>
8010113f:	e9 94 00 00 00       	jmp    801011d8 <filewrite+0xd8>
80101144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101148:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010114e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101151:	ff 73 10             	push   0x10(%ebx)
80101154:	e8 57 07 00 00       	call   801018b0 <iunlock>
      end_op();
80101159:	e8 82 1c 00 00       	call   80102de0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010115e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	39 c7                	cmp    %eax,%edi
80101166:	75 5c                	jne    801011c4 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101168:	01 fe                	add    %edi,%esi
    while(i < n){
8010116a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010116d:	7e 69                	jle    801011d8 <filewrite+0xd8>
      int n1 = n - i;
8010116f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101172:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101177:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101179:	39 c7                	cmp    %eax,%edi
8010117b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010117e:	e8 ed 1b 00 00       	call   80102d70 <begin_op>
      ilock(f->ip);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	ff 73 10             	push   0x10(%ebx)
80101189:	e8 42 06 00 00       	call   801017d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118e:	57                   	push   %edi
8010118f:	ff 73 14             	push   0x14(%ebx)
80101192:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101195:	01 f0                	add    %esi,%eax
80101197:	50                   	push   %eax
80101198:	ff 73 10             	push   0x10(%ebx)
8010119b:	e8 40 0a 00 00       	call   80101be0 <writei>
801011a0:	83 c4 20             	add    $0x20,%esp
801011a3:	85 c0                	test   %eax,%eax
801011a5:	7f a1                	jg     80101148 <filewrite+0x48>
801011a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011aa:	83 ec 0c             	sub    $0xc,%esp
801011ad:	ff 73 10             	push   0x10(%ebx)
801011b0:	e8 fb 06 00 00       	call   801018b0 <iunlock>
      end_op();
801011b5:	e8 26 1c 00 00       	call   80102de0 <end_op>
      if(r < 0)
801011ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bd:	83 c4 10             	add    $0x10,%esp
801011c0:	85 c0                	test   %eax,%eax
801011c2:	75 14                	jne    801011d8 <filewrite+0xd8>
        panic("short filewrite");
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	68 be 80 10 80       	push   $0x801080be
801011cc:	e8 af f1 ff ff       	call   80100380 <panic>
801011d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011d8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011db:	74 05                	je     801011e2 <filewrite+0xe2>
801011dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	5b                   	pop    %ebx
801011e8:	5e                   	pop    %esi
801011e9:	5f                   	pop    %edi
801011ea:	5d                   	pop    %ebp
801011eb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011ec:	8b 43 0c             	mov    0xc(%ebx),%eax
801011ef:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f5:	5b                   	pop    %ebx
801011f6:	5e                   	pop    %esi
801011f7:	5f                   	pop    %edi
801011f8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f9:	e9 d2 23 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011fe:	83 ec 0c             	sub    $0xc,%esp
80101201:	68 c4 80 10 80       	push   $0x801080c4
80101206:	e8 75 f1 ff ff       	call   80100380 <panic>
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101219:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010121f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101222:	85 c9                	test   %ecx,%ecx
80101224:	0f 84 8c 00 00 00    	je     801012b6 <balloc+0xa6>
8010122a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010122c:	89 f8                	mov    %edi,%eax
8010122e:	83 ec 08             	sub    $0x8,%esp
80101231:	89 fe                	mov    %edi,%esi
80101233:	c1 f8 0c             	sar    $0xc,%eax
80101236:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010123c:	50                   	push   %eax
8010123d:	ff 75 dc             	push   -0x24(%ebp)
80101240:	e8 8b ee ff ff       	call   801000d0 <bread>
80101245:	83 c4 10             	add    $0x10,%esp
80101248:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010124b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124e:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101253:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101256:	31 c0                	xor    %eax,%eax
80101258:	eb 32                	jmp    8010128c <balloc+0x7c>
8010125a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101260:	89 c1                	mov    %eax,%ecx
80101262:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010126a:	83 e1 07             	and    $0x7,%ecx
8010126d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010126f:	89 c1                	mov    %eax,%ecx
80101271:	c1 f9 03             	sar    $0x3,%ecx
80101274:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101279:	89 fa                	mov    %edi,%edx
8010127b:	85 df                	test   %ebx,%edi
8010127d:	74 49                	je     801012c8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010127f:	83 c0 01             	add    $0x1,%eax
80101282:	83 c6 01             	add    $0x1,%esi
80101285:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010128a:	74 07                	je     80101293 <balloc+0x83>
8010128c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010128f:	39 d6                	cmp    %edx,%esi
80101291:	72 cd                	jb     80101260 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101293:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101296:	83 ec 0c             	sub    $0xc,%esp
80101299:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010129c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012a2:	e8 49 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012a7:	83 c4 10             	add    $0x10,%esp
801012aa:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
801012b0:	0f 82 76 ff ff ff    	jb     8010122c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	68 ce 80 10 80       	push   $0x801080ce
801012be:	e8 bd f0 ff ff       	call   80100380 <panic>
801012c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801012c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012cb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ce:	09 da                	or     %ebx,%edx
801012d0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012d4:	57                   	push   %edi
801012d5:	e8 76 1c 00 00       	call   80102f50 <log_write>
        brelse(bp);
801012da:	89 3c 24             	mov    %edi,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012e2:	58                   	pop    %eax
801012e3:	5a                   	pop    %edx
801012e4:	56                   	push   %esi
801012e5:	ff 75 dc             	push   -0x24(%ebp)
801012e8:	e8 e3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012ed:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f5:	68 00 02 00 00       	push   $0x200
801012fa:	6a 00                	push   $0x0
801012fc:	50                   	push   %eax
801012fd:	e8 7e 3f 00 00       	call   80105280 <memset>
  log_write(bp);
80101302:	89 1c 24             	mov    %ebx,(%esp)
80101305:	e8 46 1c 00 00       	call   80102f50 <log_write>
  brelse(bp);
8010130a:	89 1c 24             	mov    %ebx,(%esp)
8010130d:	e8 de ee ff ff       	call   801001f0 <brelse>
}
80101312:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101315:	89 f0                	mov    %esi,%eax
80101317:	5b                   	pop    %ebx
80101318:	5e                   	pop    %esi
80101319:	5f                   	pop    %edi
8010131a:	5d                   	pop    %ebp
8010131b:	c3                   	ret
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101324:	31 ff                	xor    %edi,%edi
{
80101326:	56                   	push   %esi
80101327:	89 c6                	mov    %eax,%esi
80101329:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010132a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010132f:	83 ec 28             	sub    $0x28,%esp
80101332:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101335:	68 60 09 11 80       	push   $0x80110960
8010133a:	e8 41 3e 00 00       	call   80105180 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	eb 1b                	jmp    80101362 <iget+0x42>
80101347:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010134e:	00 
8010134f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 33                	cmp    %esi,(%ebx)
80101352:	74 6c                	je     801013c0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101354:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010135a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101360:	74 26                	je     80101388 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101362:	8b 43 08             	mov    0x8(%ebx),%eax
80101365:	85 c0                	test   %eax,%eax
80101367:	7f e7                	jg     80101350 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101369:	85 ff                	test   %edi,%edi
8010136b:	75 e7                	jne    80101354 <iget+0x34>
8010136d:	85 c0                	test   %eax,%eax
8010136f:	75 76                	jne    801013e7 <iget+0xc7>
      empty = ip;
80101371:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101373:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101379:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010137f:	75 e1                	jne    80101362 <iget+0x42>
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101388:	85 ff                	test   %edi,%edi
8010138a:	74 79                	je     80101405 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010138c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010138f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101391:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101394:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010139b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013a2:	68 60 09 11 80       	push   $0x80110960
801013a7:	e8 74 3d 00 00       	call   80105120 <release>

  return ip;
801013ac:	83 c4 10             	add    $0x10,%esp
}
801013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b2:	89 f8                	mov    %edi,%eax
801013b4:	5b                   	pop    %ebx
801013b5:	5e                   	pop    %esi
801013b6:	5f                   	pop    %edi
801013b7:	5d                   	pop    %ebp
801013b8:	c3                   	ret
801013b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013c3:	75 8f                	jne    80101354 <iget+0x34>
      ip->ref++;
801013c5:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013c8:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013cb:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013cd:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013d0:	68 60 09 11 80       	push   $0x80110960
801013d5:	e8 46 3d 00 00       	call   80105120 <release>
      return ip;
801013da:	83 c4 10             	add    $0x10,%esp
}
801013dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e0:	89 f8                	mov    %edi,%eax
801013e2:	5b                   	pop    %ebx
801013e3:	5e                   	pop    %esi
801013e4:	5f                   	pop    %edi
801013e5:	5d                   	pop    %ebp
801013e6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013e7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013ed:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013f3:	74 10                	je     80101405 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f5:	8b 43 08             	mov    0x8(%ebx),%eax
801013f8:	85 c0                	test   %eax,%eax
801013fa:	0f 8f 50 ff ff ff    	jg     80101350 <iget+0x30>
80101400:	e9 68 ff ff ff       	jmp    8010136d <iget+0x4d>
    panic("iget: no inodes");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 e4 80 10 80       	push   $0x801080e4
8010140d:	e8 6e ef ff ff       	call   80100380 <panic>
80101412:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101419:	00 
8010141a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101420 <bfree>:
{
80101420:	55                   	push   %ebp
80101421:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101423:	89 d0                	mov    %edx,%eax
80101425:	c1 e8 0c             	shr    $0xc,%eax
{
80101428:	89 e5                	mov    %esp,%ebp
8010142a:	56                   	push   %esi
8010142b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010142c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
80101432:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101434:	83 ec 08             	sub    $0x8,%esp
80101437:	50                   	push   %eax
80101438:	51                   	push   %ecx
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101440:	c1 fb 03             	sar    $0x3,%ebx
80101443:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101446:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101448:	83 e1 07             	and    $0x7,%ecx
8010144b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101450:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101456:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101458:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010145d:	85 c1                	test   %eax,%ecx
8010145f:	74 23                	je     80101484 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101461:	f7 d0                	not    %eax
  log_write(bp);
80101463:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101466:	21 c8                	and    %ecx,%eax
80101468:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010146c:	56                   	push   %esi
8010146d:	e8 de 1a 00 00       	call   80102f50 <log_write>
  brelse(bp);
80101472:	89 34 24             	mov    %esi,(%esp)
80101475:	e8 76 ed ff ff       	call   801001f0 <brelse>
}
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101480:	5b                   	pop    %ebx
80101481:	5e                   	pop    %esi
80101482:	5d                   	pop    %ebp
80101483:	c3                   	ret
    panic("freeing free block");
80101484:	83 ec 0c             	sub    $0xc,%esp
80101487:	68 f4 80 10 80       	push   $0x801080f4
8010148c:	e8 ef ee ff ff       	call   80100380 <panic>
80101491:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101498:	00 
80101499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	56                   	push   %esi
801014a5:	89 c6                	mov    %eax,%esi
801014a7:	53                   	push   %ebx
801014a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014ab:	83 fa 0b             	cmp    $0xb,%edx
801014ae:	0f 86 8c 00 00 00    	jbe    80101540 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014b7:	83 fb 7f             	cmp    $0x7f,%ebx
801014ba:	0f 87 a2 00 00 00    	ja     80101562 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014c6:	85 c0                	test   %eax,%eax
801014c8:	74 5e                	je     80101528 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ca:	83 ec 08             	sub    $0x8,%esp
801014cd:	50                   	push   %eax
801014ce:	ff 36                	push   (%esi)
801014d0:	e8 fb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014d5:	83 c4 10             	add    $0x10,%esp
801014d8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014dc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014de:	8b 3b                	mov    (%ebx),%edi
801014e0:	85 ff                	test   %edi,%edi
801014e2:	74 1c                	je     80101500 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014e4:	83 ec 0c             	sub    $0xc,%esp
801014e7:	52                   	push   %edx
801014e8:	e8 03 ed ff ff       	call   801001f0 <brelse>
801014ed:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f3:	89 f8                	mov    %edi,%eax
801014f5:	5b                   	pop    %ebx
801014f6:	5e                   	pop    %esi
801014f7:	5f                   	pop    %edi
801014f8:	5d                   	pop    %ebp
801014f9:	c3                   	ret
801014fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101503:	8b 06                	mov    (%esi),%eax
80101505:	e8 06 fd ff ff       	call   80101210 <balloc>
      log_write(bp);
8010150a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010150d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101510:	89 03                	mov    %eax,(%ebx)
80101512:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101514:	52                   	push   %edx
80101515:	e8 36 1a 00 00       	call   80102f50 <log_write>
8010151a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010151d:	83 c4 10             	add    $0x10,%esp
80101520:	eb c2                	jmp    801014e4 <bmap+0x44>
80101522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101528:	8b 06                	mov    (%esi),%eax
8010152a:	e8 e1 fc ff ff       	call   80101210 <balloc>
8010152f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101535:	eb 93                	jmp    801014ca <bmap+0x2a>
80101537:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010153e:	00 
8010153f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101540:	8d 5a 14             	lea    0x14(%edx),%ebx
80101543:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101547:	85 ff                	test   %edi,%edi
80101549:	75 a5                	jne    801014f0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010154b:	8b 00                	mov    (%eax),%eax
8010154d:	e8 be fc ff ff       	call   80101210 <balloc>
80101552:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101556:	89 c7                	mov    %eax,%edi
}
80101558:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010155b:	5b                   	pop    %ebx
8010155c:	89 f8                	mov    %edi,%eax
8010155e:	5e                   	pop    %esi
8010155f:	5f                   	pop    %edi
80101560:	5d                   	pop    %ebp
80101561:	c3                   	ret
  panic("bmap: out of range");
80101562:	83 ec 0c             	sub    $0xc,%esp
80101565:	68 07 81 10 80       	push   $0x80108107
8010156a:	e8 11 ee ff ff       	call   80100380 <panic>
8010156f:	90                   	nop

80101570 <readsb>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	6a 01                	push   $0x1
8010157d:	ff 75 08             	push   0x8(%ebp)
80101580:	e8 4b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101585:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101588:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010158a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010158d:	6a 1c                	push   $0x1c
8010158f:	50                   	push   %eax
80101590:	56                   	push   %esi
80101591:	e8 7a 3d 00 00       	call   80105310 <memmove>
  brelse(bp);
80101596:	83 c4 10             	add    $0x10,%esp
80101599:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010159c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010159f:	5b                   	pop    %ebx
801015a0:	5e                   	pop    %esi
801015a1:	5d                   	pop    %ebp
  brelse(bp);
801015a2:	e9 49 ec ff ff       	jmp    801001f0 <brelse>
801015a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ae:	00 
801015af:	90                   	nop

801015b0 <iinit>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	53                   	push   %ebx
801015b4:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801015b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015bc:	68 1a 81 10 80       	push   $0x8010811a
801015c1:	68 60 09 11 80       	push   $0x80110960
801015c6:	e8 c5 39 00 00       	call   80104f90 <initlock>
  for(i = 0; i < NINODE; i++) {
801015cb:	83 c4 10             	add    $0x10,%esp
801015ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015d0:	83 ec 08             	sub    $0x8,%esp
801015d3:	68 21 81 10 80       	push   $0x80108121
801015d8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015df:	e8 7c 38 00 00       	call   80104e60 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015e4:	83 c4 10             	add    $0x10,%esp
801015e7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015ed:	75 e1                	jne    801015d0 <iinit+0x20>
  bp = bread(dev, 1);
801015ef:	83 ec 08             	sub    $0x8,%esp
801015f2:	6a 01                	push   $0x1
801015f4:	ff 75 08             	push   0x8(%ebp)
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015fc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015ff:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101601:	8d 40 5c             	lea    0x5c(%eax),%eax
80101604:	6a 1c                	push   $0x1c
80101606:	50                   	push   %eax
80101607:	68 b4 25 11 80       	push   $0x801125b4
8010160c:	e8 ff 3c 00 00       	call   80105310 <memmove>
  brelse(bp);
80101611:	89 1c 24             	mov    %ebx,(%esp)
80101614:	e8 d7 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101619:	ff 35 cc 25 11 80    	push   0x801125cc
8010161f:	ff 35 c8 25 11 80    	push   0x801125c8
80101625:	ff 35 c4 25 11 80    	push   0x801125c4
8010162b:	ff 35 c0 25 11 80    	push   0x801125c0
80101631:	ff 35 bc 25 11 80    	push   0x801125bc
80101637:	ff 35 b8 25 11 80    	push   0x801125b8
8010163d:	ff 35 b4 25 11 80    	push   0x801125b4
80101643:	68 e0 85 10 80       	push   $0x801085e0
80101648:	e8 63 f0 ff ff       	call   801006b0 <cprintf>
}
8010164d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101650:	83 c4 30             	add    $0x30,%esp
80101653:	c9                   	leave
80101654:	c3                   	ret
80101655:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165c:	00 
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <ialloc>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	57                   	push   %edi
80101664:	56                   	push   %esi
80101665:	53                   	push   %ebx
80101666:	83 ec 1c             	sub    $0x1c,%esp
80101669:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101673:	8b 75 08             	mov    0x8(%ebp),%esi
80101676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101679:	0f 86 91 00 00 00    	jbe    80101710 <ialloc+0xb0>
8010167f:	bf 01 00 00 00       	mov    $0x1,%edi
80101684:	eb 21                	jmp    801016a7 <ialloc+0x47>
80101686:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010168d:	00 
8010168e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101690:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101693:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101696:	53                   	push   %ebx
80101697:	e8 54 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010169c:	83 c4 10             	add    $0x10,%esp
8010169f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
801016a5:	73 69                	jae    80101710 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016a7:	89 f8                	mov    %edi,%eax
801016a9:	83 ec 08             	sub    $0x8,%esp
801016ac:	c1 e8 03             	shr    $0x3,%eax
801016af:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016b5:	50                   	push   %eax
801016b6:	56                   	push   %esi
801016b7:	e8 14 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016bc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016bf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016c1:	89 f8                	mov    %edi,%eax
801016c3:	83 e0 07             	and    $0x7,%eax
801016c6:	c1 e0 06             	shl    $0x6,%eax
801016c9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016cd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016d1:	75 bd                	jne    80101690 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016d3:	83 ec 04             	sub    $0x4,%esp
801016d6:	6a 40                	push   $0x40
801016d8:	6a 00                	push   $0x0
801016da:	51                   	push   %ecx
801016db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016de:	e8 9d 3b 00 00       	call   80105280 <memset>
      dip->type = type;
801016e3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016ed:	89 1c 24             	mov    %ebx,(%esp)
801016f0:	e8 5b 18 00 00       	call   80102f50 <log_write>
      brelse(bp);
801016f5:	89 1c 24             	mov    %ebx,(%esp)
801016f8:	e8 f3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016fd:	83 c4 10             	add    $0x10,%esp
}
80101700:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101703:	89 fa                	mov    %edi,%edx
}
80101705:	5b                   	pop    %ebx
      return iget(dev, inum);
80101706:	89 f0                	mov    %esi,%eax
}
80101708:	5e                   	pop    %esi
80101709:	5f                   	pop    %edi
8010170a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010170b:	e9 10 fc ff ff       	jmp    80101320 <iget>
  panic("ialloc: no inodes");
80101710:	83 ec 0c             	sub    $0xc,%esp
80101713:	68 27 81 10 80       	push   $0x80108127
80101718:	e8 63 ec ff ff       	call   80100380 <panic>
8010171d:	8d 76 00             	lea    0x0(%esi),%esi

80101720 <iupdate>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101728:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010172e:	83 ec 08             	sub    $0x8,%esp
80101731:	c1 e8 03             	shr    $0x3,%eax
80101734:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010173a:	50                   	push   %eax
8010173b:	ff 73 a4             	push   -0x5c(%ebx)
8010173e:	e8 8d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101743:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101747:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010174c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010174f:	83 e0 07             	and    $0x7,%eax
80101752:	c1 e0 06             	shl    $0x6,%eax
80101755:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101759:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010175c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101760:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101763:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101767:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010176b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010176f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101773:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101777:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010177a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177d:	6a 34                	push   $0x34
8010177f:	53                   	push   %ebx
80101780:	50                   	push   %eax
80101781:	e8 8a 3b 00 00       	call   80105310 <memmove>
  log_write(bp);
80101786:	89 34 24             	mov    %esi,(%esp)
80101789:	e8 c2 17 00 00       	call   80102f50 <log_write>
  brelse(bp);
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101794:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101797:	5b                   	pop    %ebx
80101798:	5e                   	pop    %esi
80101799:	5d                   	pop    %ebp
  brelse(bp);
8010179a:	e9 51 ea ff ff       	jmp    801001f0 <brelse>
8010179f:	90                   	nop

801017a0 <idup>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	53                   	push   %ebx
801017a4:	83 ec 10             	sub    $0x10,%esp
801017a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017aa:	68 60 09 11 80       	push   $0x80110960
801017af:	e8 cc 39 00 00       	call   80105180 <acquire>
  ip->ref++;
801017b4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017b8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801017bf:	e8 5c 39 00 00       	call   80105120 <release>
}
801017c4:	89 d8                	mov    %ebx,%eax
801017c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017c9:	c9                   	leave
801017ca:	c3                   	ret
801017cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017d0 <ilock>:
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017d8:	85 db                	test   %ebx,%ebx
801017da:	0f 84 b7 00 00 00    	je     80101897 <ilock+0xc7>
801017e0:	8b 53 08             	mov    0x8(%ebx),%edx
801017e3:	85 d2                	test   %edx,%edx
801017e5:	0f 8e ac 00 00 00    	jle    80101897 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017eb:	83 ec 0c             	sub    $0xc,%esp
801017ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801017f1:	50                   	push   %eax
801017f2:	e8 a9 36 00 00       	call   80104ea0 <acquiresleep>
  if(ip->valid == 0){
801017f7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017fa:	83 c4 10             	add    $0x10,%esp
801017fd:	85 c0                	test   %eax,%eax
801017ff:	74 0f                	je     80101810 <ilock+0x40>
}
80101801:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101804:	5b                   	pop    %ebx
80101805:	5e                   	pop    %esi
80101806:	5d                   	pop    %ebp
80101807:	c3                   	ret
80101808:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010180f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101810:	8b 43 04             	mov    0x4(%ebx),%eax
80101813:	83 ec 08             	sub    $0x8,%esp
80101816:	c1 e8 03             	shr    $0x3,%eax
80101819:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010181f:	50                   	push   %eax
80101820:	ff 33                	push   (%ebx)
80101822:	e8 a9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101827:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010182c:	8b 43 04             	mov    0x4(%ebx),%eax
8010182f:	83 e0 07             	and    $0x7,%eax
80101832:	c1 e0 06             	shl    $0x6,%eax
80101835:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101839:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010183c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010183f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101843:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101847:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010184b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010184f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101853:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101857:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010185b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010185e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101861:	6a 34                	push   $0x34
80101863:	50                   	push   %eax
80101864:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101867:	50                   	push   %eax
80101868:	e8 a3 3a 00 00       	call   80105310 <memmove>
    brelse(bp);
8010186d:	89 34 24             	mov    %esi,(%esp)
80101870:	e8 7b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101875:	83 c4 10             	add    $0x10,%esp
80101878:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010187d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101884:	0f 85 77 ff ff ff    	jne    80101801 <ilock+0x31>
      panic("ilock: no type");
8010188a:	83 ec 0c             	sub    $0xc,%esp
8010188d:	68 3f 81 10 80       	push   $0x8010813f
80101892:	e8 e9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101897:	83 ec 0c             	sub    $0xc,%esp
8010189a:	68 39 81 10 80       	push   $0x80108139
8010189f:	e8 dc ea ff ff       	call   80100380 <panic>
801018a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018ab:	00 
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <iunlock>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018b8:	85 db                	test   %ebx,%ebx
801018ba:	74 28                	je     801018e4 <iunlock+0x34>
801018bc:	83 ec 0c             	sub    $0xc,%esp
801018bf:	8d 73 0c             	lea    0xc(%ebx),%esi
801018c2:	56                   	push   %esi
801018c3:	e8 78 36 00 00       	call   80104f40 <holdingsleep>
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 c0                	test   %eax,%eax
801018cd:	74 15                	je     801018e4 <iunlock+0x34>
801018cf:	8b 43 08             	mov    0x8(%ebx),%eax
801018d2:	85 c0                	test   %eax,%eax
801018d4:	7e 0e                	jle    801018e4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018d6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018dc:	5b                   	pop    %ebx
801018dd:	5e                   	pop    %esi
801018de:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018df:	e9 1c 36 00 00       	jmp    80104f00 <releasesleep>
    panic("iunlock");
801018e4:	83 ec 0c             	sub    $0xc,%esp
801018e7:	68 4e 81 10 80       	push   $0x8010814e
801018ec:	e8 8f ea ff ff       	call   80100380 <panic>
801018f1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018f8:	00 
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101900 <iput>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	57                   	push   %edi
80101904:	56                   	push   %esi
80101905:	53                   	push   %ebx
80101906:	83 ec 28             	sub    $0x28,%esp
80101909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010190c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010190f:	57                   	push   %edi
80101910:	e8 8b 35 00 00       	call   80104ea0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101915:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101918:	83 c4 10             	add    $0x10,%esp
8010191b:	85 d2                	test   %edx,%edx
8010191d:	74 07                	je     80101926 <iput+0x26>
8010191f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101924:	74 32                	je     80101958 <iput+0x58>
  releasesleep(&ip->lock);
80101926:	83 ec 0c             	sub    $0xc,%esp
80101929:	57                   	push   %edi
8010192a:	e8 d1 35 00 00       	call   80104f00 <releasesleep>
  acquire(&icache.lock);
8010192f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101936:	e8 45 38 00 00       	call   80105180 <acquire>
  ip->ref--;
8010193b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010193f:	83 c4 10             	add    $0x10,%esp
80101942:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010194c:	5b                   	pop    %ebx
8010194d:	5e                   	pop    %esi
8010194e:	5f                   	pop    %edi
8010194f:	5d                   	pop    %ebp
  release(&icache.lock);
80101950:	e9 cb 37 00 00       	jmp    80105120 <release>
80101955:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101958:	83 ec 0c             	sub    $0xc,%esp
8010195b:	68 60 09 11 80       	push   $0x80110960
80101960:	e8 1b 38 00 00       	call   80105180 <acquire>
    int r = ip->ref;
80101965:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101968:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010196f:	e8 ac 37 00 00       	call   80105120 <release>
    if(r == 1){
80101974:	83 c4 10             	add    $0x10,%esp
80101977:	83 fe 01             	cmp    $0x1,%esi
8010197a:	75 aa                	jne    80101926 <iput+0x26>
8010197c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101982:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101985:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101988:	89 df                	mov    %ebx,%edi
8010198a:	89 cb                	mov    %ecx,%ebx
8010198c:	eb 09                	jmp    80101997 <iput+0x97>
8010198e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101990:	83 c6 04             	add    $0x4,%esi
80101993:	39 de                	cmp    %ebx,%esi
80101995:	74 19                	je     801019b0 <iput+0xb0>
    if(ip->addrs[i]){
80101997:	8b 16                	mov    (%esi),%edx
80101999:	85 d2                	test   %edx,%edx
8010199b:	74 f3                	je     80101990 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010199d:	8b 07                	mov    (%edi),%eax
8010199f:	e8 7c fa ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
801019a4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019aa:	eb e4                	jmp    80101990 <iput+0x90>
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019b0:	89 fb                	mov    %edi,%ebx
801019b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019b5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019bb:	85 c0                	test   %eax,%eax
801019bd:	75 2d                	jne    801019ec <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019bf:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019c2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019c9:	53                   	push   %ebx
801019ca:	e8 51 fd ff ff       	call   80101720 <iupdate>
      ip->type = 0;
801019cf:	31 c0                	xor    %eax,%eax
801019d1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019d5:	89 1c 24             	mov    %ebx,(%esp)
801019d8:	e8 43 fd ff ff       	call   80101720 <iupdate>
      ip->valid = 0;
801019dd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019e4:	83 c4 10             	add    $0x10,%esp
801019e7:	e9 3a ff ff ff       	jmp    80101926 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019ec:	83 ec 08             	sub    $0x8,%esp
801019ef:	50                   	push   %eax
801019f0:	ff 33                	push   (%ebx)
801019f2:	e8 d9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019f7:	83 c4 10             	add    $0x10,%esp
801019fa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019fd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a03:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a06:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a09:	89 cf                	mov    %ecx,%edi
80101a0b:	eb 0a                	jmp    80101a17 <iput+0x117>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi
80101a10:	83 c6 04             	add    $0x4,%esi
80101a13:	39 fe                	cmp    %edi,%esi
80101a15:	74 0f                	je     80101a26 <iput+0x126>
      if(a[j])
80101a17:	8b 16                	mov    (%esi),%edx
80101a19:	85 d2                	test   %edx,%edx
80101a1b:	74 f3                	je     80101a10 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a1d:	8b 03                	mov    (%ebx),%eax
80101a1f:	e8 fc f9 ff ff       	call   80101420 <bfree>
80101a24:	eb ea                	jmp    80101a10 <iput+0x110>
    brelse(bp);
80101a26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a29:	83 ec 0c             	sub    $0xc,%esp
80101a2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a2f:	50                   	push   %eax
80101a30:	e8 bb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a35:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a3b:	8b 03                	mov    (%ebx),%eax
80101a3d:	e8 de f9 ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a42:	83 c4 10             	add    $0x10,%esp
80101a45:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a4c:	00 00 00 
80101a4f:	e9 6b ff ff ff       	jmp    801019bf <iput+0xbf>
80101a54:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a5b:	00 
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a60 <iunlockput>:
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	56                   	push   %esi
80101a64:	53                   	push   %ebx
80101a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a68:	85 db                	test   %ebx,%ebx
80101a6a:	74 34                	je     80101aa0 <iunlockput+0x40>
80101a6c:	83 ec 0c             	sub    $0xc,%esp
80101a6f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a72:	56                   	push   %esi
80101a73:	e8 c8 34 00 00       	call   80104f40 <holdingsleep>
80101a78:	83 c4 10             	add    $0x10,%esp
80101a7b:	85 c0                	test   %eax,%eax
80101a7d:	74 21                	je     80101aa0 <iunlockput+0x40>
80101a7f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a82:	85 c0                	test   %eax,%eax
80101a84:	7e 1a                	jle    80101aa0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	56                   	push   %esi
80101a8a:	e8 71 34 00 00       	call   80104f00 <releasesleep>
  iput(ip);
80101a8f:	83 c4 10             	add    $0x10,%esp
80101a92:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101a95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a98:	5b                   	pop    %ebx
80101a99:	5e                   	pop    %esi
80101a9a:	5d                   	pop    %ebp
  iput(ip);
80101a9b:	e9 60 fe ff ff       	jmp    80101900 <iput>
    panic("iunlock");
80101aa0:	83 ec 0c             	sub    $0xc,%esp
80101aa3:	68 4e 81 10 80       	push   $0x8010814e
80101aa8:	e8 d3 e8 ff ff       	call   80100380 <panic>
80101aad:	8d 76 00             	lea    0x0(%esi),%esi

80101ab0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ab9:	8b 0a                	mov    (%edx),%ecx
80101abb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101abe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ac1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ac4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ac8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101acb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101acf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ad3:	8b 52 58             	mov    0x58(%edx),%edx
80101ad6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101ad9:	5d                   	pop    %ebp
80101ada:	c3                   	ret
80101adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ae0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
80101ae9:	8b 75 08             	mov    0x8(%ebp),%esi
80101aec:	8b 45 0c             	mov    0xc(%ebp),%eax
80101aef:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101af7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101afa:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101afd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b00:	0f 84 aa 00 00 00    	je     80101bb0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b06:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b09:	8b 56 58             	mov    0x58(%esi),%edx
80101b0c:	39 fa                	cmp    %edi,%edx
80101b0e:	0f 82 bd 00 00 00    	jb     80101bd1 <readi+0xf1>
80101b14:	89 f9                	mov    %edi,%ecx
80101b16:	31 db                	xor    %ebx,%ebx
80101b18:	01 c1                	add    %eax,%ecx
80101b1a:	0f 92 c3             	setb   %bl
80101b1d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b20:	0f 82 ab 00 00 00    	jb     80101bd1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b26:	89 d3                	mov    %edx,%ebx
80101b28:	29 fb                	sub    %edi,%ebx
80101b2a:	39 ca                	cmp    %ecx,%edx
80101b2c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	85 c0                	test   %eax,%eax
80101b31:	74 73                	je     80101ba6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b33:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b43:	89 fa                	mov    %edi,%edx
80101b45:	c1 ea 09             	shr    $0x9,%edx
80101b48:	89 d8                	mov    %ebx,%eax
80101b4a:	e8 51 f9 ff ff       	call   801014a0 <bmap>
80101b4f:	83 ec 08             	sub    $0x8,%esp
80101b52:	50                   	push   %eax
80101b53:	ff 33                	push   (%ebx)
80101b55:	e8 76 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b5d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b62:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b64:	89 f8                	mov    %edi,%eax
80101b66:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b6b:	29 f3                	sub    %esi,%ebx
80101b6d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b6f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b73:	39 d9                	cmp    %ebx,%ecx
80101b75:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b78:	83 c4 0c             	add    $0xc,%esp
80101b7b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b7c:	01 de                	add    %ebx,%esi
80101b7e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b80:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b83:	50                   	push   %eax
80101b84:	ff 75 e0             	push   -0x20(%ebp)
80101b87:	e8 84 37 00 00       	call   80105310 <memmove>
    brelse(bp);
80101b8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b8f:	89 14 24             	mov    %edx,(%esp)
80101b92:	e8 59 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b97:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b9d:	83 c4 10             	add    $0x10,%esp
80101ba0:	39 de                	cmp    %ebx,%esi
80101ba2:	72 9c                	jb     80101b40 <readi+0x60>
80101ba4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101ba6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba9:	5b                   	pop    %ebx
80101baa:	5e                   	pop    %esi
80101bab:	5f                   	pop    %edi
80101bac:	5d                   	pop    %ebp
80101bad:	c3                   	ret
80101bae:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bb0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bb4:	66 83 fa 09          	cmp    $0x9,%dx
80101bb8:	77 17                	ja     80101bd1 <readi+0xf1>
80101bba:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101bc1:	85 d2                	test   %edx,%edx
80101bc3:	74 0c                	je     80101bd1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bc5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bcb:	5b                   	pop    %ebx
80101bcc:	5e                   	pop    %esi
80101bcd:	5f                   	pop    %edi
80101bce:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bcf:	ff e2                	jmp    *%edx
      return -1;
80101bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bd6:	eb ce                	jmp    80101ba6 <readi+0xc6>
80101bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101bdf:	00 

80101be0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bec:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bef:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bf2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bf7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bfa:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bfd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c00:	0f 84 ba 00 00 00    	je     80101cc0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c06:	39 78 58             	cmp    %edi,0x58(%eax)
80101c09:	0f 82 ea 00 00 00    	jb     80101cf9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c0f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c12:	89 f2                	mov    %esi,%edx
80101c14:	01 fa                	add    %edi,%edx
80101c16:	0f 82 dd 00 00 00    	jb     80101cf9 <writei+0x119>
80101c1c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c22:	0f 87 d1 00 00 00    	ja     80101cf9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	85 f6                	test   %esi,%esi
80101c2a:	0f 84 85 00 00 00    	je     80101cb5 <writei+0xd5>
80101c30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c40:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c43:	89 fa                	mov    %edi,%edx
80101c45:	c1 ea 09             	shr    $0x9,%edx
80101c48:	89 f0                	mov    %esi,%eax
80101c4a:	e8 51 f8 ff ff       	call   801014a0 <bmap>
80101c4f:	83 ec 08             	sub    $0x8,%esp
80101c52:	50                   	push   %eax
80101c53:	ff 36                	push   (%esi)
80101c55:	e8 76 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c5d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c60:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c65:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c67:	89 f8                	mov    %edi,%eax
80101c69:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c6e:	29 d3                	sub    %edx,%ebx
80101c70:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c72:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c76:	39 d9                	cmp    %ebx,%ecx
80101c78:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c7b:	83 c4 0c             	add    $0xc,%esp
80101c7e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c7f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c81:	ff 75 dc             	push   -0x24(%ebp)
80101c84:	50                   	push   %eax
80101c85:	e8 86 36 00 00       	call   80105310 <memmove>
    log_write(bp);
80101c8a:	89 34 24             	mov    %esi,(%esp)
80101c8d:	e8 be 12 00 00       	call   80102f50 <log_write>
    brelse(bp);
80101c92:	89 34 24             	mov    %esi,(%esp)
80101c95:	e8 56 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c9a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ca0:	83 c4 10             	add    $0x10,%esp
80101ca3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ca6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ca9:	39 d8                	cmp    %ebx,%eax
80101cab:	72 93                	jb     80101c40 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cb0:	39 78 58             	cmp    %edi,0x58(%eax)
80101cb3:	72 33                	jb     80101ce8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cbb:	5b                   	pop    %ebx
80101cbc:	5e                   	pop    %esi
80101cbd:	5f                   	pop    %edi
80101cbe:	5d                   	pop    %ebp
80101cbf:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cc4:	66 83 f8 09          	cmp    $0x9,%ax
80101cc8:	77 2f                	ja     80101cf9 <writei+0x119>
80101cca:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101cd1:	85 c0                	test   %eax,%eax
80101cd3:	74 24                	je     80101cf9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101cd5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cdb:	5b                   	pop    %ebx
80101cdc:	5e                   	pop    %esi
80101cdd:	5f                   	pop    %edi
80101cde:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cdf:	ff e0                	jmp    *%eax
80101ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101ce8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101ceb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cee:	50                   	push   %eax
80101cef:	e8 2c fa ff ff       	call   80101720 <iupdate>
80101cf4:	83 c4 10             	add    $0x10,%esp
80101cf7:	eb bc                	jmp    80101cb5 <writei+0xd5>
      return -1;
80101cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cfe:	eb b8                	jmp    80101cb8 <writei+0xd8>

80101d00 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d06:	6a 0e                	push   $0xe
80101d08:	ff 75 0c             	push   0xc(%ebp)
80101d0b:	ff 75 08             	push   0x8(%ebp)
80101d0e:	e8 6d 36 00 00       	call   80105380 <strncmp>
}
80101d13:	c9                   	leave
80101d14:	c3                   	ret
80101d15:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d1c:	00 
80101d1d:	8d 76 00             	lea    0x0(%esi),%esi

80101d20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	57                   	push   %edi
80101d24:	56                   	push   %esi
80101d25:	53                   	push   %ebx
80101d26:	83 ec 1c             	sub    $0x1c,%esp
80101d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d31:	0f 85 85 00 00 00    	jne    80101dbc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d37:	8b 53 58             	mov    0x58(%ebx),%edx
80101d3a:	31 ff                	xor    %edi,%edi
80101d3c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d3f:	85 d2                	test   %edx,%edx
80101d41:	74 3e                	je     80101d81 <dirlookup+0x61>
80101d43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d48:	6a 10                	push   $0x10
80101d4a:	57                   	push   %edi
80101d4b:	56                   	push   %esi
80101d4c:	53                   	push   %ebx
80101d4d:	e8 8e fd ff ff       	call   80101ae0 <readi>
80101d52:	83 c4 10             	add    $0x10,%esp
80101d55:	83 f8 10             	cmp    $0x10,%eax
80101d58:	75 55                	jne    80101daf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d5f:	74 18                	je     80101d79 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d61:	83 ec 04             	sub    $0x4,%esp
80101d64:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d67:	6a 0e                	push   $0xe
80101d69:	50                   	push   %eax
80101d6a:	ff 75 0c             	push   0xc(%ebp)
80101d6d:	e8 0e 36 00 00       	call   80105380 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d72:	83 c4 10             	add    $0x10,%esp
80101d75:	85 c0                	test   %eax,%eax
80101d77:	74 17                	je     80101d90 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d79:	83 c7 10             	add    $0x10,%edi
80101d7c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d7f:	72 c7                	jb     80101d48 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d84:	31 c0                	xor    %eax,%eax
}
80101d86:	5b                   	pop    %ebx
80101d87:	5e                   	pop    %esi
80101d88:	5f                   	pop    %edi
80101d89:	5d                   	pop    %ebp
80101d8a:	c3                   	ret
80101d8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d90:	8b 45 10             	mov    0x10(%ebp),%eax
80101d93:	85 c0                	test   %eax,%eax
80101d95:	74 05                	je     80101d9c <dirlookup+0x7c>
        *poff = off;
80101d97:	8b 45 10             	mov    0x10(%ebp),%eax
80101d9a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d9c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101da0:	8b 03                	mov    (%ebx),%eax
80101da2:	e8 79 f5 ff ff       	call   80101320 <iget>
}
80101da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101daa:	5b                   	pop    %ebx
80101dab:	5e                   	pop    %esi
80101dac:	5f                   	pop    %edi
80101dad:	5d                   	pop    %ebp
80101dae:	c3                   	ret
      panic("dirlookup read");
80101daf:	83 ec 0c             	sub    $0xc,%esp
80101db2:	68 68 81 10 80       	push   $0x80108168
80101db7:	e8 c4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dbc:	83 ec 0c             	sub    $0xc,%esp
80101dbf:	68 56 81 10 80       	push   $0x80108156
80101dc4:	e8 b7 e5 ff ff       	call   80100380 <panic>
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	89 c3                	mov    %eax,%ebx
80101dd8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ddb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dde:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101de1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101de4:	0f 84 9e 01 00 00    	je     80101f88 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dea:	e8 c1 1c 00 00       	call   80103ab0 <myproc>
  acquire(&icache.lock);
80101def:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101df2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101df5:	68 60 09 11 80       	push   $0x80110960
80101dfa:	e8 81 33 00 00       	call   80105180 <acquire>
  ip->ref++;
80101dff:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e03:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e0a:	e8 11 33 00 00       	call   80105120 <release>
80101e0f:	83 c4 10             	add    $0x10,%esp
80101e12:	eb 07                	jmp    80101e1b <namex+0x4b>
80101e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e18:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e1b:	0f b6 03             	movzbl (%ebx),%eax
80101e1e:	3c 2f                	cmp    $0x2f,%al
80101e20:	74 f6                	je     80101e18 <namex+0x48>
  if(*path == 0)
80101e22:	84 c0                	test   %al,%al
80101e24:	0f 84 06 01 00 00    	je     80101f30 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e2a:	0f b6 03             	movzbl (%ebx),%eax
80101e2d:	84 c0                	test   %al,%al
80101e2f:	0f 84 10 01 00 00    	je     80101f45 <namex+0x175>
80101e35:	89 df                	mov    %ebx,%edi
80101e37:	3c 2f                	cmp    $0x2f,%al
80101e39:	0f 84 06 01 00 00    	je     80101f45 <namex+0x175>
80101e3f:	90                   	nop
80101e40:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e44:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e47:	3c 2f                	cmp    $0x2f,%al
80101e49:	74 04                	je     80101e4f <namex+0x7f>
80101e4b:	84 c0                	test   %al,%al
80101e4d:	75 f1                	jne    80101e40 <namex+0x70>
  len = path - s;
80101e4f:	89 f8                	mov    %edi,%eax
80101e51:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e53:	83 f8 0d             	cmp    $0xd,%eax
80101e56:	0f 8e ac 00 00 00    	jle    80101f08 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e5c:	83 ec 04             	sub    $0x4,%esp
80101e5f:	6a 0e                	push   $0xe
80101e61:	53                   	push   %ebx
80101e62:	89 fb                	mov    %edi,%ebx
80101e64:	ff 75 e4             	push   -0x1c(%ebp)
80101e67:	e8 a4 34 00 00       	call   80105310 <memmove>
80101e6c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e6f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e72:	75 0c                	jne    80101e80 <namex+0xb0>
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e78:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e7b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e7e:	74 f8                	je     80101e78 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e80:	83 ec 0c             	sub    $0xc,%esp
80101e83:	56                   	push   %esi
80101e84:	e8 47 f9 ff ff       	call   801017d0 <ilock>
    if(ip->type != T_DIR){
80101e89:	83 c4 10             	add    $0x10,%esp
80101e8c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e91:	0f 85 b7 00 00 00    	jne    80101f4e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e97:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e9a:	85 c0                	test   %eax,%eax
80101e9c:	74 09                	je     80101ea7 <namex+0xd7>
80101e9e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ea1:	0f 84 f7 00 00 00    	je     80101f9e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ea7:	83 ec 04             	sub    $0x4,%esp
80101eaa:	6a 00                	push   $0x0
80101eac:	ff 75 e4             	push   -0x1c(%ebp)
80101eaf:	56                   	push   %esi
80101eb0:	e8 6b fe ff ff       	call   80101d20 <dirlookup>
80101eb5:	83 c4 10             	add    $0x10,%esp
80101eb8:	89 c7                	mov    %eax,%edi
80101eba:	85 c0                	test   %eax,%eax
80101ebc:	0f 84 8c 00 00 00    	je     80101f4e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ec2:	83 ec 0c             	sub    $0xc,%esp
80101ec5:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101ec8:	51                   	push   %ecx
80101ec9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ecc:	e8 6f 30 00 00       	call   80104f40 <holdingsleep>
80101ed1:	83 c4 10             	add    $0x10,%esp
80101ed4:	85 c0                	test   %eax,%eax
80101ed6:	0f 84 02 01 00 00    	je     80101fde <namex+0x20e>
80101edc:	8b 56 08             	mov    0x8(%esi),%edx
80101edf:	85 d2                	test   %edx,%edx
80101ee1:	0f 8e f7 00 00 00    	jle    80101fde <namex+0x20e>
  releasesleep(&ip->lock);
80101ee7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eea:	83 ec 0c             	sub    $0xc,%esp
80101eed:	51                   	push   %ecx
80101eee:	e8 0d 30 00 00       	call   80104f00 <releasesleep>
  iput(ip);
80101ef3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ef6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ef8:	e8 03 fa ff ff       	call   80101900 <iput>
80101efd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f00:	e9 16 ff ff ff       	jmp    80101e1b <namex+0x4b>
80101f05:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f0b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101f0e:	83 ec 04             	sub    $0x4,%esp
80101f11:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f14:	50                   	push   %eax
80101f15:	53                   	push   %ebx
    name[len] = 0;
80101f16:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f18:	ff 75 e4             	push   -0x1c(%ebp)
80101f1b:	e8 f0 33 00 00       	call   80105310 <memmove>
    name[len] = 0;
80101f20:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f23:	83 c4 10             	add    $0x10,%esp
80101f26:	c6 01 00             	movb   $0x0,(%ecx)
80101f29:	e9 41 ff ff ff       	jmp    80101e6f <namex+0x9f>
80101f2e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f30:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 85 93 00 00 00    	jne    80101fce <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3e:	89 f0                	mov    %esi,%eax
80101f40:	5b                   	pop    %ebx
80101f41:	5e                   	pop    %esi
80101f42:	5f                   	pop    %edi
80101f43:	5d                   	pop    %ebp
80101f44:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f45:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f48:	89 df                	mov    %ebx,%edi
80101f4a:	31 c0                	xor    %eax,%eax
80101f4c:	eb c0                	jmp    80101f0e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f4e:	83 ec 0c             	sub    $0xc,%esp
80101f51:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f54:	53                   	push   %ebx
80101f55:	e8 e6 2f 00 00       	call   80104f40 <holdingsleep>
80101f5a:	83 c4 10             	add    $0x10,%esp
80101f5d:	85 c0                	test   %eax,%eax
80101f5f:	74 7d                	je     80101fde <namex+0x20e>
80101f61:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f64:	85 c9                	test   %ecx,%ecx
80101f66:	7e 76                	jle    80101fde <namex+0x20e>
  releasesleep(&ip->lock);
80101f68:	83 ec 0c             	sub    $0xc,%esp
80101f6b:	53                   	push   %ebx
80101f6c:	e8 8f 2f 00 00       	call   80104f00 <releasesleep>
  iput(ip);
80101f71:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f74:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f76:	e8 85 f9 ff ff       	call   80101900 <iput>
      return 0;
80101f7b:	83 c4 10             	add    $0x10,%esp
}
80101f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f81:	89 f0                	mov    %esi,%eax
80101f83:	5b                   	pop    %ebx
80101f84:	5e                   	pop    %esi
80101f85:	5f                   	pop    %edi
80101f86:	5d                   	pop    %ebp
80101f87:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f88:	ba 01 00 00 00       	mov    $0x1,%edx
80101f8d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f92:	e8 89 f3 ff ff       	call   80101320 <iget>
80101f97:	89 c6                	mov    %eax,%esi
80101f99:	e9 7d fe ff ff       	jmp    80101e1b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fa4:	53                   	push   %ebx
80101fa5:	e8 96 2f 00 00       	call   80104f40 <holdingsleep>
80101faa:	83 c4 10             	add    $0x10,%esp
80101fad:	85 c0                	test   %eax,%eax
80101faf:	74 2d                	je     80101fde <namex+0x20e>
80101fb1:	8b 7e 08             	mov    0x8(%esi),%edi
80101fb4:	85 ff                	test   %edi,%edi
80101fb6:	7e 26                	jle    80101fde <namex+0x20e>
  releasesleep(&ip->lock);
80101fb8:	83 ec 0c             	sub    $0xc,%esp
80101fbb:	53                   	push   %ebx
80101fbc:	e8 3f 2f 00 00       	call   80104f00 <releasesleep>
}
80101fc1:	83 c4 10             	add    $0x10,%esp
}
80101fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc7:	89 f0                	mov    %esi,%eax
80101fc9:	5b                   	pop    %ebx
80101fca:	5e                   	pop    %esi
80101fcb:	5f                   	pop    %edi
80101fcc:	5d                   	pop    %ebp
80101fcd:	c3                   	ret
    iput(ip);
80101fce:	83 ec 0c             	sub    $0xc,%esp
80101fd1:	56                   	push   %esi
      return 0;
80101fd2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fd4:	e8 27 f9 ff ff       	call   80101900 <iput>
    return 0;
80101fd9:	83 c4 10             	add    $0x10,%esp
80101fdc:	eb a0                	jmp    80101f7e <namex+0x1ae>
    panic("iunlock");
80101fde:	83 ec 0c             	sub    $0xc,%esp
80101fe1:	68 4e 81 10 80       	push   $0x8010814e
80101fe6:	e8 95 e3 ff ff       	call   80100380 <panic>
80101feb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ff0 <dirlink>:
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 20             	sub    $0x20,%esp
80101ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ffc:	6a 00                	push   $0x0
80101ffe:	ff 75 0c             	push   0xc(%ebp)
80102001:	53                   	push   %ebx
80102002:	e8 19 fd ff ff       	call   80101d20 <dirlookup>
80102007:	83 c4 10             	add    $0x10,%esp
8010200a:	85 c0                	test   %eax,%eax
8010200c:	75 67                	jne    80102075 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010200e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102011:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102014:	85 ff                	test   %edi,%edi
80102016:	74 29                	je     80102041 <dirlink+0x51>
80102018:	31 ff                	xor    %edi,%edi
8010201a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010201d:	eb 09                	jmp    80102028 <dirlink+0x38>
8010201f:	90                   	nop
80102020:	83 c7 10             	add    $0x10,%edi
80102023:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102026:	73 19                	jae    80102041 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102028:	6a 10                	push   $0x10
8010202a:	57                   	push   %edi
8010202b:	56                   	push   %esi
8010202c:	53                   	push   %ebx
8010202d:	e8 ae fa ff ff       	call   80101ae0 <readi>
80102032:	83 c4 10             	add    $0x10,%esp
80102035:	83 f8 10             	cmp    $0x10,%eax
80102038:	75 4e                	jne    80102088 <dirlink+0x98>
    if(de.inum == 0)
8010203a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010203f:	75 df                	jne    80102020 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102041:	83 ec 04             	sub    $0x4,%esp
80102044:	8d 45 da             	lea    -0x26(%ebp),%eax
80102047:	6a 0e                	push   $0xe
80102049:	ff 75 0c             	push   0xc(%ebp)
8010204c:	50                   	push   %eax
8010204d:	e8 7e 33 00 00       	call   801053d0 <strncpy>
  de.inum = inum;
80102052:	8b 45 10             	mov    0x10(%ebp),%eax
80102055:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102059:	6a 10                	push   $0x10
8010205b:	57                   	push   %edi
8010205c:	56                   	push   %esi
8010205d:	53                   	push   %ebx
8010205e:	e8 7d fb ff ff       	call   80101be0 <writei>
80102063:	83 c4 20             	add    $0x20,%esp
80102066:	83 f8 10             	cmp    $0x10,%eax
80102069:	75 2a                	jne    80102095 <dirlink+0xa5>
  return 0;
8010206b:	31 c0                	xor    %eax,%eax
}
8010206d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102070:	5b                   	pop    %ebx
80102071:	5e                   	pop    %esi
80102072:	5f                   	pop    %edi
80102073:	5d                   	pop    %ebp
80102074:	c3                   	ret
    iput(ip);
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	50                   	push   %eax
80102079:	e8 82 f8 ff ff       	call   80101900 <iput>
    return -1;
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102086:	eb e5                	jmp    8010206d <dirlink+0x7d>
      panic("dirlink read");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 77 81 10 80       	push   $0x80108177
80102090:	e8 eb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 7c 84 10 80       	push   $0x8010847c
8010209d:	e8 de e2 ff ff       	call   80100380 <panic>
801020a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020a9:	00 
801020aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020b0 <namei>:

struct inode*
namei(char *path)
{
801020b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020b1:	31 d2                	xor    %edx,%edx
{
801020b3:	89 e5                	mov    %esp,%ebp
801020b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020be:	e8 0d fd ff ff       	call   80101dd0 <namex>
}
801020c3:	c9                   	leave
801020c4:	c3                   	ret
801020c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020cc:	00 
801020cd:	8d 76 00             	lea    0x0(%esi),%esi

801020d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020d0:	55                   	push   %ebp
  return namex(path, 1, name);
801020d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020df:	e9 ec fc ff ff       	jmp    80101dd0 <namex>
801020e4:	66 90                	xchg   %ax,%ax
801020e6:	66 90                	xchg   %ax,%ax
801020e8:	66 90                	xchg   %ax,%ax
801020ea:	66 90                	xchg   %ax,%ax
801020ec:	66 90                	xchg   %ax,%ax
801020ee:	66 90                	xchg   %ax,%ax

801020f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020f9:	85 c0                	test   %eax,%eax
801020fb:	0f 84 b4 00 00 00    	je     801021b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102101:	8b 70 08             	mov    0x8(%eax),%esi
80102104:	89 c3                	mov    %eax,%ebx
80102106:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010210c:	0f 87 96 00 00 00    	ja     801021a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102117:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010211e:	00 
8010211f:	90                   	nop
80102120:	89 ca                	mov    %ecx,%edx
80102122:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102123:	83 e0 c0             	and    $0xffffffc0,%eax
80102126:	3c 40                	cmp    $0x40,%al
80102128:	75 f6                	jne    80102120 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212a:	31 ff                	xor    %edi,%edi
8010212c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102131:	89 f8                	mov    %edi,%eax
80102133:	ee                   	out    %al,(%dx)
80102134:	b8 01 00 00 00       	mov    $0x1,%eax
80102139:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010213e:	ee                   	out    %al,(%dx)
8010213f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102144:	89 f0                	mov    %esi,%eax
80102146:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102147:	89 f0                	mov    %esi,%eax
80102149:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010214e:	c1 f8 08             	sar    $0x8,%eax
80102151:	ee                   	out    %al,(%dx)
80102152:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102157:	89 f8                	mov    %edi,%eax
80102159:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010215a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010215e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102163:	c1 e0 04             	shl    $0x4,%eax
80102166:	83 e0 10             	and    $0x10,%eax
80102169:	83 c8 e0             	or     $0xffffffe0,%eax
8010216c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010216d:	f6 03 04             	testb  $0x4,(%ebx)
80102170:	75 16                	jne    80102188 <idestart+0x98>
80102172:	b8 20 00 00 00       	mov    $0x20,%eax
80102177:	89 ca                	mov    %ecx,%edx
80102179:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217d:	5b                   	pop    %ebx
8010217e:	5e                   	pop    %esi
8010217f:	5f                   	pop    %edi
80102180:	5d                   	pop    %ebp
80102181:	c3                   	ret
80102182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102188:	b8 30 00 00 00       	mov    $0x30,%eax
8010218d:	89 ca                	mov    %ecx,%edx
8010218f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102190:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102195:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102198:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010219d:	fc                   	cld
8010219e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret
    panic("incorrect blockno");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 8d 81 10 80       	push   $0x8010818d
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 84 81 10 80       	push   $0x80108184
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021c9:	00 
801021ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 9f 81 10 80       	push   $0x8010819f
801021db:	68 00 26 11 80       	push   $0x80112600
801021e0:	e8 ab 2d 00 00       	call   80104f90 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 99 02 00 00       	call   80102490 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021ff:	90                   	nop
80102200:	89 ca                	mov    %ecx,%edx
80102202:	ec                   	in     (%dx),%al
80102203:	83 e0 c0             	and    $0xffffffc0,%eax
80102206:	3c 40                	cmp    $0x40,%al
80102208:	75 f6                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010220a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102214:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102215:	89 ca                	mov    %ecx,%edx
80102217:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102218:	84 c0                	test   %al,%al
8010221a:	75 1e                	jne    8010223a <ideinit+0x6a>
8010221c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102221:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102226:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010222d:	00 
8010222e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102230:	83 e9 01             	sub    $0x1,%ecx
80102233:	74 0f                	je     80102244 <ideinit+0x74>
80102235:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102236:	84 c0                	test   %al,%al
80102238:	74 f6                	je     80102230 <ideinit+0x60>
      havedisk1 = 1;
8010223a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102241:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102244:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102249:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010224e:	ee                   	out    %al,(%dx)
}
8010224f:	c9                   	leave
80102250:	c3                   	ret
80102251:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102258:	00 
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102260 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	57                   	push   %edi
80102264:	56                   	push   %esi
80102265:	53                   	push   %ebx
80102266:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102269:	68 00 26 11 80       	push   $0x80112600
8010226e:	e8 0d 2f 00 00       	call   80105180 <acquire>

  if((b = idequeue) == 0){
80102273:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102279:	83 c4 10             	add    $0x10,%esp
8010227c:	85 db                	test   %ebx,%ebx
8010227e:	74 63                	je     801022e3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102280:	8b 43 58             	mov    0x58(%ebx),%eax
80102283:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102288:	8b 33                	mov    (%ebx),%esi
8010228a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102290:	75 2f                	jne    801022c1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102292:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102297:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010229e:	00 
8010229f:	90                   	nop
801022a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022a1:	89 c1                	mov    %eax,%ecx
801022a3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022a6:	80 f9 40             	cmp    $0x40,%cl
801022a9:	75 f5                	jne    801022a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022ab:	a8 21                	test   $0x21,%al
801022ad:	75 12                	jne    801022c1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022af:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022b2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022b7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022bc:	fc                   	cld
801022bd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022bf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022c1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022c4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022c7:	83 ce 02             	or     $0x2,%esi
801022ca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022cc:	53                   	push   %ebx
801022cd:	e8 8e 23 00 00       	call   80104660 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022d2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022d7:	83 c4 10             	add    $0x10,%esp
801022da:	85 c0                	test   %eax,%eax
801022dc:	74 05                	je     801022e3 <ideintr+0x83>
    idestart(idequeue);
801022de:	e8 0d fe ff ff       	call   801020f0 <idestart>
    release(&idelock);
801022e3:	83 ec 0c             	sub    $0xc,%esp
801022e6:	68 00 26 11 80       	push   $0x80112600
801022eb:	e8 30 2e 00 00       	call   80105120 <release>

  release(&idelock);
}
801022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f3:	5b                   	pop    %ebx
801022f4:	5e                   	pop    %esi
801022f5:	5f                   	pop    %edi
801022f6:	5d                   	pop    %ebp
801022f7:	c3                   	ret
801022f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022ff:	00 

80102300 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 10             	sub    $0x10,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010230a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010230d:	50                   	push   %eax
8010230e:	e8 2d 2c 00 00       	call   80104f40 <holdingsleep>
80102313:	83 c4 10             	add    $0x10,%esp
80102316:	85 c0                	test   %eax,%eax
80102318:	0f 84 c3 00 00 00    	je     801023e1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 e0 06             	and    $0x6,%eax
80102323:	83 f8 02             	cmp    $0x2,%eax
80102326:	0f 84 a8 00 00 00    	je     801023d4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010232c:	8b 53 04             	mov    0x4(%ebx),%edx
8010232f:	85 d2                	test   %edx,%edx
80102331:	74 0d                	je     80102340 <iderw+0x40>
80102333:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102338:	85 c0                	test   %eax,%eax
8010233a:	0f 84 87 00 00 00    	je     801023c7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102340:	83 ec 0c             	sub    $0xc,%esp
80102343:	68 00 26 11 80       	push   $0x80112600
80102348:	e8 33 2e 00 00       	call   80105180 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010234d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102352:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102359:	83 c4 10             	add    $0x10,%esp
8010235c:	85 c0                	test   %eax,%eax
8010235e:	74 60                	je     801023c0 <iderw+0xc0>
80102360:	89 c2                	mov    %eax,%edx
80102362:	8b 40 58             	mov    0x58(%eax),%eax
80102365:	85 c0                	test   %eax,%eax
80102367:	75 f7                	jne    80102360 <iderw+0x60>
80102369:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010236c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010236e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102374:	74 3a                	je     801023b0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102376:	8b 03                	mov    (%ebx),%eax
80102378:	83 e0 06             	and    $0x6,%eax
8010237b:	83 f8 02             	cmp    $0x2,%eax
8010237e:	74 1b                	je     8010239b <iderw+0x9b>
    sleep(b, &idelock);
80102380:	83 ec 08             	sub    $0x8,%esp
80102383:	68 00 26 11 80       	push   $0x80112600
80102388:	53                   	push   %ebx
80102389:	e8 62 20 00 00       	call   801043f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 c4 10             	add    $0x10,%esp
80102393:	83 e0 06             	and    $0x6,%eax
80102396:	83 f8 02             	cmp    $0x2,%eax
80102399:	75 e5                	jne    80102380 <iderw+0x80>
  }


  release(&idelock);
8010239b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
801023a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023a5:	c9                   	leave
  release(&idelock);
801023a6:	e9 75 2d 00 00       	jmp    80105120 <release>
801023ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801023b0:	89 d8                	mov    %ebx,%eax
801023b2:	e8 39 fd ff ff       	call   801020f0 <idestart>
801023b7:	eb bd                	jmp    80102376 <iderw+0x76>
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023c5:	eb a5                	jmp    8010236c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 ce 81 10 80       	push   $0x801081ce
801023cf:	e8 ac df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 b9 81 10 80       	push   $0x801081b9
801023dc:	e8 9f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 a3 81 10 80       	push   $0x801081a3
801023e9:	e8 92 df ff ff       	call   80100380 <panic>
801023ee:	66 90                	xchg   %ax,%ax

801023f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023f5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023fc:	00 c0 fe 
  ioapic->reg = reg;
801023ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102406:	00 00 00 
  return ioapic->data;
80102409:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010240f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102412:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102418:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010241e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102425:	c1 ee 10             	shr    $0x10,%esi
80102428:	89 f0                	mov    %esi,%eax
8010242a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010242d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102430:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102433:	39 c2                	cmp    %eax,%edx
80102435:	74 16                	je     8010244d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102437:	83 ec 0c             	sub    $0xc,%esp
8010243a:	68 34 86 10 80       	push   $0x80108634
8010243f:	e8 6c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102444:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010244a:	83 c4 10             	add    $0x10,%esp
{
8010244d:	ba 10 00 00 00       	mov    $0x10,%edx
80102452:	31 c0                	xor    %eax,%eax
80102454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102458:	89 13                	mov    %edx,(%ebx)
8010245a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010245d:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102463:	83 c0 01             	add    $0x1,%eax
80102466:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010246c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010246f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102472:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102475:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102477:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010247d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102484:	39 c6                	cmp    %eax,%esi
80102486:	7d d0                	jge    80102458 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102488:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5d                   	pop    %ebp
8010248e:	c3                   	ret
8010248f:	90                   	nop

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	55                   	push   %ebp
  ioapic->reg = reg;
80102491:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102497:	89 e5                	mov    %esp,%ebp
80102499:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010249c:	8d 50 20             	lea    0x20(%eax),%edx
8010249f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024be:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 04             	sub    $0x4,%esp
801024d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e0:	75 76                	jne    80102558 <kfree+0x88>
801024e2:	81 fb f0 6e 11 80    	cmp    $0x80116ef0,%ebx
801024e8:	72 6e                	jb     80102558 <kfree+0x88>
801024ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f5:	77 61                	ja     80102558 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024f7:	83 ec 04             	sub    $0x4,%esp
801024fa:	68 00 10 00 00       	push   $0x1000
801024ff:	6a 01                	push   $0x1
80102501:	53                   	push   %ebx
80102502:	e8 79 2d 00 00       	call   80105280 <memset>

  if(kmem.use_lock)
80102507:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	85 d2                	test   %edx,%edx
80102512:	75 1c                	jne    80102530 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102514:	a1 78 26 11 80       	mov    0x80112678,%eax
80102519:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010251b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102520:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102526:	85 c0                	test   %eax,%eax
80102528:	75 1e                	jne    80102548 <kfree+0x78>
    release(&kmem.lock);
}
8010252a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252d:	c9                   	leave
8010252e:	c3                   	ret
8010252f:	90                   	nop
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 40 26 11 80       	push   $0x80112640
80102538:	e8 43 2c 00 00       	call   80105180 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb d2                	jmp    80102514 <kfree+0x44>
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102548:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010254f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102552:	c9                   	leave
    release(&kmem.lock);
80102553:	e9 c8 2b 00 00       	jmp    80105120 <release>
    panic("kfree");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 ec 81 10 80       	push   $0x801081ec
80102560:	e8 1b de ff ff       	call   80100380 <panic>
80102565:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010256c:	00 
8010256d:	8d 76 00             	lea    0x0(%esi),%esi

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
80102574:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102575:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102578:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 23 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	73 e4                	jae    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret
801025bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <kinit2+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 d3 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102604:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010260b:	00 00 00 
}
8010260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102611:	5b                   	pop    %ebx
80102612:	5e                   	pop    %esi
80102613:	5d                   	pop    %ebp
80102614:	c3                   	ret
80102615:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010261c:	00 
8010261d:	8d 76 00             	lea    0x0(%esi),%esi

80102620 <kinit1>:
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	56                   	push   %esi
80102624:	53                   	push   %ebx
80102625:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102628:	83 ec 08             	sub    $0x8,%esp
8010262b:	68 f2 81 10 80       	push   $0x801081f2
80102630:	68 40 26 11 80       	push   $0x80112640
80102635:	e8 56 29 00 00       	call   80104f90 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102640:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102647:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102650:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102656:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265c:	39 de                	cmp    %ebx,%esi
8010265e:	72 1c                	jb     8010267c <kinit1+0x5c>
    kfree(p);
80102660:	83 ec 0c             	sub    $0xc,%esp
80102663:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102669:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010266f:	50                   	push   %eax
80102670:	e8 5b fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102675:	83 c4 10             	add    $0x10,%esp
80102678:	39 de                	cmp    %ebx,%esi
8010267a:	73 e4                	jae    80102660 <kinit1+0x40>
}
8010267c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010267f:	5b                   	pop    %ebx
80102680:	5e                   	pop    %esi
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret
80102683:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268a:	00 
8010268b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102690 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	53                   	push   %ebx
80102694:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102697:	a1 74 26 11 80       	mov    0x80112674,%eax
8010269c:	85 c0                	test   %eax,%eax
8010269e:	75 20                	jne    801026c0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026a0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801026a6:	85 db                	test   %ebx,%ebx
801026a8:	74 07                	je     801026b1 <kalloc+0x21>
    kmem.freelist = r->next;
801026aa:	8b 03                	mov    (%ebx),%eax
801026ac:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026b1:	89 d8                	mov    %ebx,%eax
801026b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026b6:	c9                   	leave
801026b7:	c3                   	ret
801026b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026bf:	00 
    acquire(&kmem.lock);
801026c0:	83 ec 0c             	sub    $0xc,%esp
801026c3:	68 40 26 11 80       	push   $0x80112640
801026c8:	e8 b3 2a 00 00       	call   80105180 <acquire>
  r = kmem.freelist;
801026cd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
801026d3:	a1 74 26 11 80       	mov    0x80112674,%eax
  if(r)
801026d8:	83 c4 10             	add    $0x10,%esp
801026db:	85 db                	test   %ebx,%ebx
801026dd:	74 08                	je     801026e7 <kalloc+0x57>
    kmem.freelist = r->next;
801026df:	8b 13                	mov    (%ebx),%edx
801026e1:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801026e7:	85 c0                	test   %eax,%eax
801026e9:	74 c6                	je     801026b1 <kalloc+0x21>
    release(&kmem.lock);
801026eb:	83 ec 0c             	sub    $0xc,%esp
801026ee:	68 40 26 11 80       	push   $0x80112640
801026f3:	e8 28 2a 00 00       	call   80105120 <release>
}
801026f8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801026fa:	83 c4 10             	add    $0x10,%esp
}
801026fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102700:	c9                   	leave
80102701:	c3                   	ret
80102702:	66 90                	xchg   %ax,%ax
80102704:	66 90                	xchg   %ax,%ax
80102706:	66 90                	xchg   %ax,%ax
80102708:	66 90                	xchg   %ax,%ax
8010270a:	66 90                	xchg   %ax,%ax
8010270c:	66 90                	xchg   %ax,%ax
8010270e:	66 90                	xchg   %ax,%ax

80102710 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102710:	ba 64 00 00 00       	mov    $0x64,%edx
80102715:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102716:	a8 01                	test   $0x1,%al
80102718:	0f 84 c2 00 00 00    	je     801027e0 <kbdgetc+0xd0>
{
8010271e:	55                   	push   %ebp
8010271f:	ba 60 00 00 00       	mov    $0x60,%edx
80102724:	89 e5                	mov    %esp,%ebp
80102726:	53                   	push   %ebx
80102727:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102728:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010272e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102731:	3c e0                	cmp    $0xe0,%al
80102733:	74 5b                	je     80102790 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102735:	89 da                	mov    %ebx,%edx
80102737:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010273a:	84 c0                	test   %al,%al
8010273c:	78 62                	js     801027a0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010273e:	85 d2                	test   %edx,%edx
80102740:	74 09                	je     8010274b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102742:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102745:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102748:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010274b:	0f b6 91 20 8a 10 80 	movzbl -0x7fef75e0(%ecx),%edx
  shift ^= togglecode[data];
80102752:	0f b6 81 20 89 10 80 	movzbl -0x7fef76e0(%ecx),%eax
  shift |= shiftcode[data];
80102759:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010275b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010275f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102765:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102768:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010276b:	8b 04 85 00 89 10 80 	mov    -0x7fef7700(,%eax,4),%eax
80102772:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102776:	74 0b                	je     80102783 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102778:	8d 50 9f             	lea    -0x61(%eax),%edx
8010277b:	83 fa 19             	cmp    $0x19,%edx
8010277e:	77 48                	ja     801027c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102780:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102783:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102786:	c9                   	leave
80102787:	c3                   	ret
80102788:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010278f:	00 
    shift |= E0ESC;
80102790:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102793:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102795:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010279b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279e:	c9                   	leave
8010279f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
801027a0:	83 e0 7f             	and    $0x7f,%eax
801027a3:	85 d2                	test   %edx,%edx
801027a5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027a8:	0f b6 81 20 8a 10 80 	movzbl -0x7fef75e0(%ecx),%eax
801027af:	83 c8 40             	or     $0x40,%eax
801027b2:	0f b6 c0             	movzbl %al,%eax
801027b5:	f7 d0                	not    %eax
801027b7:	21 d8                	and    %ebx,%eax
801027b9:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027be:	31 c0                	xor    %eax,%eax
801027c0:	eb d9                	jmp    8010279b <kbdgetc+0x8b>
801027c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027cb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d1:	c9                   	leave
      c += 'a' - 'A';
801027d2:	83 f9 1a             	cmp    $0x1a,%ecx
801027d5:	0f 42 c2             	cmovb  %edx,%eax
}
801027d8:	c3                   	ret
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027e5:	c3                   	ret
801027e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027ed:	00 
801027ee:	66 90                	xchg   %ax,%ax

801027f0 <kbdintr>:

void
kbdintr(void)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027f6:	68 10 27 10 80       	push   $0x80102710
801027fb:	e8 a0 e0 ff ff       	call   801008a0 <consoleintr>
}
80102800:	83 c4 10             	add    $0x10,%esp
80102803:	c9                   	leave
80102804:	c3                   	ret
80102805:	66 90                	xchg   %ax,%ax
80102807:	66 90                	xchg   %ax,%ax
80102809:	66 90                	xchg   %ax,%ax
8010280b:	66 90                	xchg   %ax,%ax
8010280d:	66 90                	xchg   %ax,%ax
8010280f:	90                   	nop

80102810 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102810:	a1 80 26 11 80       	mov    0x80112680,%eax
80102815:	85 c0                	test   %eax,%eax
80102817:	0f 84 c3 00 00 00    	je     801028e0 <lapicinit+0xd0>
  lapic[index] = value;
8010281d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102824:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010283e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010284b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102858:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102865:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010286b:	8b 50 30             	mov    0x30(%eax),%edx
8010286e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102874:	75 72                	jne    801028e8 <lapicinit+0xd8>
  lapic[index] = value;
80102876:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010287d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102880:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102883:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102890:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102897:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028b1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028be:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028c8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028ce:	80 e6 10             	and    $0x10,%dh
801028d1:	75 f5                	jne    801028c8 <lapicinit+0xb8>
  lapic[index] = value;
801028d3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028dd:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028e0:	c3                   	ret
801028e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028e8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028ef:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028f2:	8b 50 20             	mov    0x20(%eax),%edx
}
801028f5:	e9 7c ff ff ff       	jmp    80102876 <lapicinit+0x66>
801028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102900 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102900:	a1 80 26 11 80       	mov    0x80112680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	74 07                	je     80102910 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102909:	8b 40 20             	mov    0x20(%eax),%eax
8010290c:	c1 e8 18             	shr    $0x18,%eax
8010290f:	c3                   	ret
    return 0;
80102910:	31 c0                	xor    %eax,%eax
}
80102912:	c3                   	ret
80102913:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010291a:	00 
8010291b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102920:	a1 80 26 11 80       	mov    0x80112680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	74 0d                	je     80102936 <lapiceoi+0x16>
  lapic[index] = value;
80102929:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102930:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102933:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102936:	c3                   	ret
80102937:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010293e:	00 
8010293f:	90                   	nop

80102940 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102940:	c3                   	ret
80102941:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102948:	00 
80102949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102951:	b8 0f 00 00 00       	mov    $0xf,%eax
80102956:	ba 70 00 00 00       	mov    $0x70,%edx
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	53                   	push   %ebx
8010295e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102961:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102964:	ee                   	out    %al,(%dx)
80102965:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296a:	ba 71 00 00 00       	mov    $0x71,%edx
8010296f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102970:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102972:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102975:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010297d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102980:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102982:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102985:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102988:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010298e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102993:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102999:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029dd:	c9                   	leave
801029de:	c3                   	ret
801029df:	90                   	nop

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	55                   	push   %ebp
801029e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	57                   	push   %edi
801029ee:	56                   	push   %esi
801029ef:	53                   	push   %ebx
801029f0:	83 ec 4c             	sub    $0x4c,%esp
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	ba 71 00 00 00       	mov    $0x71,%edx
801029f9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029fa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fd:	bf 70 00 00 00       	mov    $0x70,%edi
80102a02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a05:	8d 76 00             	lea    0x0(%esi),%esi
80102a08:	31 c0                	xor    %eax,%eax
80102a0a:	89 fa                	mov    %edi,%edx
80102a0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a18:	89 fa                	mov    %edi,%edx
80102a1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
80102a23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a26:	89 fa                	mov    %edi,%edx
80102a28:	b8 04 00 00 00       	mov    $0x4,%eax
80102a2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2e:	89 ca                	mov    %ecx,%edx
80102a30:	ec                   	in     (%dx),%al
80102a31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 fa                	mov    %edi,%edx
80102a36:	b8 07 00 00 00       	mov    $0x7,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al
80102a3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a42:	89 fa                	mov    %edi,%edx
80102a44:	b8 08 00 00 00       	mov    $0x8,%eax
80102a49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4a:	89 ca                	mov    %ecx,%edx
80102a4c:	ec                   	in     (%dx),%al
80102a4d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4f:	89 fa                	mov    %edi,%edx
80102a51:	b8 09 00 00 00       	mov    $0x9,%eax
80102a56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a57:	89 ca                	mov    %ecx,%edx
80102a59:	ec                   	in     (%dx),%al
80102a5a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5d:	89 fa                	mov    %edi,%edx
80102a5f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a65:	89 ca                	mov    %ecx,%edx
80102a67:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a68:	84 c0                	test   %al,%al
80102a6a:	78 9c                	js     80102a08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a6c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a70:	89 f2                	mov    %esi,%edx
80102a72:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102a75:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a78:	89 fa                	mov    %edi,%edx
80102a7a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a7d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a81:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102a84:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a87:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a8b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a8e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a92:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a95:	31 c0                	xor    %eax,%eax
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 ca                	mov    %ecx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 fa                	mov    %edi,%edx
80102aa0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aa3:	b8 02 00 00 00       	mov    $0x2,%eax
80102aa8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa9:	89 ca                	mov    %ecx,%edx
80102aab:	ec                   	in     (%dx),%al
80102aac:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aaf:	89 fa                	mov    %edi,%edx
80102ab1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ab4:	b8 04 00 00 00       	mov    $0x4,%eax
80102ab9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aba:	89 ca                	mov    %ecx,%edx
80102abc:	ec                   	in     (%dx),%al
80102abd:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac0:	89 fa                	mov    %edi,%edx
80102ac2:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ac5:	b8 07 00 00 00       	mov    $0x7,%eax
80102aca:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acb:	89 ca                	mov    %ecx,%edx
80102acd:	ec                   	in     (%dx),%al
80102ace:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad1:	89 fa                	mov    %edi,%edx
80102ad3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ad6:	b8 08 00 00 00       	mov    $0x8,%eax
80102adb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102adc:	89 ca                	mov    %ecx,%edx
80102ade:	ec                   	in     (%dx),%al
80102adf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae2:	89 fa                	mov    %edi,%edx
80102ae4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ae7:	b8 09 00 00 00       	mov    $0x9,%eax
80102aec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aed:	89 ca                	mov    %ecx,%edx
80102aef:	ec                   	in     (%dx),%al
80102af0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102af6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102af9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102afc:	6a 18                	push   $0x18
80102afe:	50                   	push   %eax
80102aff:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b02:	50                   	push   %eax
80102b03:	e8 b8 27 00 00       	call   801052c0 <memcmp>
80102b08:	83 c4 10             	add    $0x10,%esp
80102b0b:	85 c0                	test   %eax,%eax
80102b0d:	0f 85 f5 fe ff ff    	jne    80102a08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b13:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b1a:	89 f0                	mov    %esi,%eax
80102b1c:	84 c0                	test   %al,%al
80102b1e:	75 78                	jne    80102b98 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b20:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b23:	89 c2                	mov    %eax,%edx
80102b25:	83 e0 0f             	and    $0xf,%eax
80102b28:	c1 ea 04             	shr    $0x4,%edx
80102b2b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b31:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b34:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b37:	89 c2                	mov    %eax,%edx
80102b39:	83 e0 0f             	and    $0xf,%eax
80102b3c:	c1 ea 04             	shr    $0x4,%edx
80102b3f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b42:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b45:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b48:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b4b:	89 c2                	mov    %eax,%edx
80102b4d:	83 e0 0f             	and    $0xf,%eax
80102b50:	c1 ea 04             	shr    $0x4,%edx
80102b53:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b56:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b59:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b5c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b5f:	89 c2                	mov    %eax,%edx
80102b61:	83 e0 0f             	and    $0xf,%eax
80102b64:	c1 ea 04             	shr    $0x4,%edx
80102b67:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b70:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b73:	89 c2                	mov    %eax,%edx
80102b75:	83 e0 0f             	and    $0xf,%eax
80102b78:	c1 ea 04             	shr    $0x4,%edx
80102b7b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b81:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b84:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b87:	89 c2                	mov    %eax,%edx
80102b89:	83 e0 0f             	and    $0xf,%eax
80102b8c:	c1 ea 04             	shr    $0x4,%edx
80102b8f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b92:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b95:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b9b:	89 03                	mov    %eax,(%ebx)
80102b9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba0:	89 43 04             	mov    %eax,0x4(%ebx)
80102ba3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ba6:	89 43 08             	mov    %eax,0x8(%ebx)
80102ba9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bac:	89 43 0c             	mov    %eax,0xc(%ebx)
80102baf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb2:	89 43 10             	mov    %eax,0x10(%ebx)
80102bb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bb8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102bbb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc5:	5b                   	pop    %ebx
80102bc6:	5e                   	pop    %esi
80102bc7:	5f                   	pop    %edi
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret
80102bca:	66 90                	xchg   %ax,%ax
80102bcc:	66 90                	xchg   %ax,%ax
80102bce:	66 90                	xchg   %ax,%ax

80102bd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bd0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102bd6:	85 c9                	test   %ecx,%ecx
80102bd8:	0f 8e 8a 00 00 00    	jle    80102c68 <install_trans+0x98>
{
80102bde:	55                   	push   %ebp
80102bdf:	89 e5                	mov    %esp,%ebp
80102be1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102be2:	31 ff                	xor    %edi,%edi
{
80102be4:	56                   	push   %esi
80102be5:	53                   	push   %ebx
80102be6:	83 ec 0c             	sub    $0xc,%esp
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bf0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102bf5:	83 ec 08             	sub    $0x8,%esp
80102bf8:	01 f8                	add    %edi,%eax
80102bfa:	83 c0 01             	add    $0x1,%eax
80102bfd:	50                   	push   %eax
80102bfe:	ff 35 e4 26 11 80    	push   0x801126e4
80102c04:	e8 c7 d4 ff ff       	call   801000d0 <bread>
80102c09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0b:	58                   	pop    %eax
80102c0c:	5a                   	pop    %edx
80102c0d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102c14:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1d:	e8 ae d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2a:	68 00 02 00 00       	push   $0x200
80102c2f:	50                   	push   %eax
80102c30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c33:	50                   	push   %eax
80102c34:	e8 d7 26 00 00       	call   80105310 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 6f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 a7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 9f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c5a:	7f 94                	jg     80102bf0 <install_trans+0x20>
  }
}
80102c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5f:	5b                   	pop    %ebx
80102c60:	5e                   	pop    %esi
80102c61:	5f                   	pop    %edi
80102c62:	5d                   	pop    %ebp
80102c63:	c3                   	ret
80102c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c68:	c3                   	ret
80102c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	53                   	push   %ebx
80102c74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c77:	ff 35 d4 26 11 80    	push   0x801126d4
80102c7d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c88:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c8b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c8d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c92:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c95:	85 c0                	test   %eax,%eax
80102c97:	7e 19                	jle    80102cb2 <write_head+0x42>
80102c99:	31 d2                	xor    %edx,%edx
80102c9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ca0:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102ca7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cab:	83 c2 01             	add    $0x1,%edx
80102cae:	39 d0                	cmp    %edx,%eax
80102cb0:	75 ee                	jne    80102ca0 <write_head+0x30>
  }
  bwrite(buf);
80102cb2:	83 ec 0c             	sub    $0xc,%esp
80102cb5:	53                   	push   %ebx
80102cb6:	e8 f5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cbb:	89 1c 24             	mov    %ebx,(%esp)
80102cbe:	e8 2d d5 ff ff       	call   801001f0 <brelse>
}
80102cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cc6:	83 c4 10             	add    $0x10,%esp
80102cc9:	c9                   	leave
80102cca:	c3                   	ret
80102ccb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102cd0 <initlog>:
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 2c             	sub    $0x2c,%esp
80102cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cda:	68 f7 81 10 80       	push   $0x801081f7
80102cdf:	68 a0 26 11 80       	push   $0x801126a0
80102ce4:	e8 a7 22 00 00       	call   80104f90 <initlock>
  readsb(dev, &sb);
80102ce9:	58                   	pop    %eax
80102cea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ced:	5a                   	pop    %edx
80102cee:	50                   	push   %eax
80102cef:	53                   	push   %ebx
80102cf0:	e8 7b e8 ff ff       	call   80101570 <readsb>
  log.start = sb.logstart;
80102cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cf8:	59                   	pop    %ecx
  log.dev = dev;
80102cf9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102cff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d02:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102d07:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102d0d:	5a                   	pop    %edx
80102d0e:	50                   	push   %eax
80102d0f:	53                   	push   %ebx
80102d10:	e8 bb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d18:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d1b:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102d21:	85 db                	test   %ebx,%ebx
80102d23:	7e 1d                	jle    80102d42 <initlog+0x72>
80102d25:	31 d2                	xor    %edx,%edx
80102d27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d2e:	00 
80102d2f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d30:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d34:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d3b:	83 c2 01             	add    $0x1,%edx
80102d3e:	39 d3                	cmp    %edx,%ebx
80102d40:	75 ee                	jne    80102d30 <initlog+0x60>
  brelse(buf);
80102d42:	83 ec 0c             	sub    $0xc,%esp
80102d45:	50                   	push   %eax
80102d46:	e8 a5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d4b:	e8 80 fe ff ff       	call   80102bd0 <install_trans>
  log.lh.n = 0;
80102d50:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d57:	00 00 00 
  write_head(); // clear the log
80102d5a:	e8 11 ff ff ff       	call   80102c70 <write_head>
}
80102d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d62:	83 c4 10             	add    $0x10,%esp
80102d65:	c9                   	leave
80102d66:	c3                   	ret
80102d67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d6e:	00 
80102d6f:	90                   	nop

80102d70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d76:	68 a0 26 11 80       	push   $0x801126a0
80102d7b:	e8 00 24 00 00       	call   80105180 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
80102d83:	eb 18                	jmp    80102d9d <begin_op+0x2d>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d88:	83 ec 08             	sub    $0x8,%esp
80102d8b:	68 a0 26 11 80       	push   $0x801126a0
80102d90:	68 a0 26 11 80       	push   $0x801126a0
80102d95:	e8 56 16 00 00       	call   801043f0 <sleep>
80102d9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d9d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102da2:	85 c0                	test   %eax,%eax
80102da4:	75 e2                	jne    80102d88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102da6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dab:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102db1:	83 c0 01             	add    $0x1,%eax
80102db4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102db7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dba:	83 fa 1e             	cmp    $0x1e,%edx
80102dbd:	7f c9                	jg     80102d88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dc2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102dc7:	68 a0 26 11 80       	push   $0x801126a0
80102dcc:	e8 4f 23 00 00       	call   80105120 <release>
      break;
    }
  }
}
80102dd1:	83 c4 10             	add    $0x10,%esp
80102dd4:	c9                   	leave
80102dd5:	c3                   	ret
80102dd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ddd:	00 
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	57                   	push   %edi
80102de4:	56                   	push   %esi
80102de5:	53                   	push   %ebx
80102de6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102de9:	68 a0 26 11 80       	push   $0x801126a0
80102dee:	e8 8d 23 00 00       	call   80105180 <acquire>
  log.outstanding -= 1;
80102df3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102df8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dfe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e04:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102e0a:	85 f6                	test   %esi,%esi
80102e0c:	0f 85 22 01 00 00    	jne    80102f34 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e12:	85 db                	test   %ebx,%ebx
80102e14:	0f 85 f6 00 00 00    	jne    80102f10 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e1a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102e21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	68 a0 26 11 80       	push   $0x801126a0
80102e2c:	e8 ef 22 00 00       	call   80105120 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e31:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e37:	83 c4 10             	add    $0x10,%esp
80102e3a:	85 c9                	test   %ecx,%ecx
80102e3c:	7f 42                	jg     80102e80 <end_op+0xa0>
    acquire(&log.lock);
80102e3e:	83 ec 0c             	sub    $0xc,%esp
80102e41:	68 a0 26 11 80       	push   $0x801126a0
80102e46:	e8 35 23 00 00       	call   80105180 <acquire>
    log.committing = 0;
80102e4b:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e52:	00 00 00 
    wakeup(&log);
80102e55:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e5c:	e8 ff 17 00 00       	call   80104660 <wakeup>
    release(&log.lock);
80102e61:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e68:	e8 b3 22 00 00       	call   80105120 <release>
80102e6d:	83 c4 10             	add    $0x10,%esp
}
80102e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e73:	5b                   	pop    %ebx
80102e74:	5e                   	pop    %esi
80102e75:	5f                   	pop    %edi
80102e76:	5d                   	pop    %ebp
80102e77:	c3                   	ret
80102e78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e7f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e80:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 d8                	add    %ebx,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102ea4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102eb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102eb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 47 24 00 00       	call   80105310 <memmove>
    bwrite(to);  // write the log
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 df d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ed1:	89 3c 24             	mov    %edi,(%esp)
80102ed4:	e8 17 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 0f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eea:	7c 94                	jl     80102e80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eec:	e8 7f fd ff ff       	call   80102c70 <write_head>
    install_trans(); // Now install writes to home locations
80102ef1:	e8 da fc ff ff       	call   80102bd0 <install_trans>
    log.lh.n = 0;
80102ef6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102efd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f00:	e8 6b fd ff ff       	call   80102c70 <write_head>
80102f05:	e9 34 ff ff ff       	jmp    80102e3e <end_op+0x5e>
80102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f10:	83 ec 0c             	sub    $0xc,%esp
80102f13:	68 a0 26 11 80       	push   $0x801126a0
80102f18:	e8 43 17 00 00       	call   80104660 <wakeup>
  release(&log.lock);
80102f1d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f24:	e8 f7 21 00 00       	call   80105120 <release>
80102f29:	83 c4 10             	add    $0x10,%esp
}
80102f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f2f:	5b                   	pop    %ebx
80102f30:	5e                   	pop    %esi
80102f31:	5f                   	pop    %edi
80102f32:	5d                   	pop    %ebp
80102f33:	c3                   	ret
    panic("log.committing");
80102f34:	83 ec 0c             	sub    $0xc,%esp
80102f37:	68 fb 81 10 80       	push   $0x801081fb
80102f3c:	e8 3f d4 ff ff       	call   80100380 <panic>
80102f41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f48:	00 
80102f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f50 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f57:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80102f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f60:	83 fa 1d             	cmp    $0x1d,%edx
80102f63:	7f 7d                	jg     80102fe2 <log_write+0x92>
80102f65:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f6a:	83 e8 01             	sub    $0x1,%eax
80102f6d:	39 c2                	cmp    %eax,%edx
80102f6f:	7d 71                	jge    80102fe2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f71:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f76:	85 c0                	test   %eax,%eax
80102f78:	7e 75                	jle    80102fef <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f7a:	83 ec 0c             	sub    $0xc,%esp
80102f7d:	68 a0 26 11 80       	push   $0x801126a0
80102f82:	e8 f9 21 00 00       	call   80105180 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f87:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8a:	83 c4 10             	add    $0x10,%esp
80102f8d:	31 c0                	xor    %eax,%eax
80102f8f:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f95:	85 d2                	test   %edx,%edx
80102f97:	7f 0e                	jg     80102fa7 <log_write+0x57>
80102f99:	eb 15                	jmp    80102fb0 <log_write+0x60>
80102f9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fa0:	83 c0 01             	add    $0x1,%eax
80102fa3:	39 c2                	cmp    %eax,%edx
80102fa5:	74 29                	je     80102fd0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102fae:	75 f0                	jne    80102fa0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
80102fb7:	39 c2                	cmp    %eax,%edx
80102fb9:	74 1c                	je     80102fd7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fbb:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fc1:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102fc8:	c9                   	leave
  release(&log.lock);
80102fc9:	e9 52 21 00 00       	jmp    80105120 <release>
80102fce:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80102fd7:	83 c2 01             	add    $0x1,%edx
80102fda:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fe0:	eb d9                	jmp    80102fbb <log_write+0x6b>
    panic("too big a transaction");
80102fe2:	83 ec 0c             	sub    $0xc,%esp
80102fe5:	68 0a 82 10 80       	push   $0x8010820a
80102fea:	e8 91 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102fef:	83 ec 0c             	sub    $0xc,%esp
80102ff2:	68 20 82 10 80       	push   $0x80108220
80102ff7:	e8 84 d3 ff ff       	call   80100380 <panic>
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 84 0a 00 00       	call   80103a90 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 7d 0a 00 00       	call   80103a90 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 3b 82 10 80       	push   $0x8010823b
8010301d:	e8 8e d6 ff ff       	call   801006b0 <cprintf>

  idtinit();       // load idt register
80103022:	e8 d9 35 00 00       	call   80106600 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 04 0a 00 00       	call   80103a30 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 31 0e 00 00       	call   80103e70 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 55 48 00 00       	call   801078a0 <switchkvm>
  seginit();
8010304b:	e8 c0 47 00 00       	call   80107810 <seginit>
  lapicinit();
80103050:	e8 bb f7 ff ff       	call   80102810 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 f0 6e 11 80       	push   $0x80116ef0
8010307c:	e8 9f f5 ff ff       	call   80102620 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 da 4c 00 00       	call   80107d60 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 80 f7 ff ff       	call   80102810 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 7b 47 00 00       	call   80107810 <seginit>
  picinit();       // disable pic
80103095:	e8 86 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 51 f3 ff ff       	call   801023f0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 37 39 00 00       	call   801069e0 <uartinit>
  pinit();         // process table
801030a9:	e8 62 09 00 00       	call   80103a10 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 cd 34 00 00       	call   80106580 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 a3 dd ff ff       	call   80100e60 <fileinit>
  ideinit();       // disk 
801030bd:	e8 0e f1 ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c b4 10 80       	push   $0x8010b48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 37 22 00 00       	call   80105310 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030eb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 12 09 00 00       	call   80103a30 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 69 f5 ff ff       	call   80102690 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 fa f7 ff ff       	call   80102950 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 3e f4 ff ff       	call   801025c0 <kinit2>
  userinit();      // first user process
80103182:	e8 59 09 00 00       	call   80103ae0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031af:	00 
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 df                	cmp    %ebx,%edi
801031b4:	73 42                	jae    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 4f 82 10 80       	push   $0x8010824f
801031c3:	56                   	push   %esi
801031c4:	e8 f7 20 00 00       	call   801052c0 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret
80103204:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010320b:	00 
8010320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 58 01 00 00    	je     801033b8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 3d 01 00 00    	je     801033a8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103274:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103277:	6a 04                	push   $0x4
80103279:	68 54 82 10 80       	push   $0x80108254
8010327e:	50                   	push   %eax
8010327f:	e8 3c 20 00 00       	call   801052c0 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 19 01 00 00    	jne    801033a8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 06 01 00 00    	jne    801033a8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 f8                	cmp    %edi,%eax
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 d8 00 00 00    	jne    801033a8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801032d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801032dc:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801032ee:	01 d7                	add    %edx,%edi
801032f0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801032f2:	bf 01 00 00 00       	mov    $0x1,%edi
801032f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032fe:	00 
801032ff:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103300:	39 d0                	cmp    %edx,%eax
80103302:	73 19                	jae    8010331d <mpinit+0x10d>
    switch(*p){
80103304:	0f b6 08             	movzbl (%eax),%ecx
80103307:	80 f9 02             	cmp    $0x2,%cl
8010330a:	0f 84 80 00 00 00    	je     80103390 <mpinit+0x180>
80103310:	77 6e                	ja     80103380 <mpinit+0x170>
80103312:	84 c9                	test   %cl,%cl
80103314:	74 3a                	je     80103350 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103316:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103319:	39 d0                	cmp    %edx,%eax
8010331b:	72 e7                	jb     80103304 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010331d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103320:	85 ff                	test   %edi,%edi
80103322:	0f 84 dd 00 00 00    	je     80103405 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103328:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010332c:	74 15                	je     80103343 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	b8 70 00 00 00       	mov    $0x70,%eax
80103333:	ba 22 00 00 00       	mov    $0x22,%edx
80103338:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103339:	ba 23 00 00 00       	mov    $0x23,%edx
8010333e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010333f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103342:	ee                   	out    %al,(%dx)
  }
}
80103343:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103346:	5b                   	pop    %ebx
80103347:	5e                   	pop    %esi
80103348:	5f                   	pop    %edi
80103349:	5d                   	pop    %ebp
8010334a:	c3                   	ret
8010334b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103350:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103356:	83 f9 07             	cmp    $0x7,%ecx
80103359:	7f 19                	jg     80103374 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010335b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103361:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103365:	83 c1 01             	add    $0x1,%ecx
80103368:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336e:	88 9e a0 27 11 80    	mov    %bl,-0x7feed860(%esi)
      p += sizeof(struct mpproc);
80103374:	83 c0 14             	add    $0x14,%eax
      continue;
80103377:	eb 87                	jmp    80103300 <mpinit+0xf0>
80103379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103380:	83 e9 03             	sub    $0x3,%ecx
80103383:	80 f9 01             	cmp    $0x1,%cl
80103386:	76 8e                	jbe    80103316 <mpinit+0x106>
80103388:	31 ff                	xor    %edi,%edi
8010338a:	e9 71 ff ff ff       	jmp    80103300 <mpinit+0xf0>
8010338f:	90                   	nop
      ioapicid = ioapic->apicno;
80103390:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103394:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103397:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010339d:	e9 5e ff ff ff       	jmp    80103300 <mpinit+0xf0>
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033a8:	83 ec 0c             	sub    $0xc,%esp
801033ab:	68 59 82 10 80       	push   $0x80108259
801033b0:	e8 cb cf ff ff       	call   80100380 <panic>
801033b5:	8d 76 00             	lea    0x0(%esi),%esi
{
801033b8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033bd:	eb 0b                	jmp    801033ca <mpinit+0x1ba>
801033bf:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
801033c0:	89 f3                	mov    %esi,%ebx
801033c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033c8:	74 de                	je     801033a8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ca:	83 ec 04             	sub    $0x4,%esp
801033cd:	8d 73 10             	lea    0x10(%ebx),%esi
801033d0:	6a 04                	push   $0x4
801033d2:	68 4f 82 10 80       	push   $0x8010824f
801033d7:	53                   	push   %ebx
801033d8:	e8 e3 1e 00 00       	call   801052c0 <memcmp>
801033dd:	83 c4 10             	add    $0x10,%esp
801033e0:	85 c0                	test   %eax,%eax
801033e2:	75 dc                	jne    801033c0 <mpinit+0x1b0>
801033e4:	89 da                	mov    %ebx,%edx
801033e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033ed:	00 
801033ee:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801033f0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033f3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033f6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033f8:	39 d6                	cmp    %edx,%esi
801033fa:	75 f4                	jne    801033f0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033fc:	84 c0                	test   %al,%al
801033fe:	75 c0                	jne    801033c0 <mpinit+0x1b0>
80103400:	e9 5b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103405:	83 ec 0c             	sub    $0xc,%esp
80103408:	68 68 86 10 80       	push   $0x80108668
8010340d:	e8 6e cf ff ff       	call   80100380 <panic>
80103412:	66 90                	xchg   %ax,%ax
80103414:	66 90                	xchg   %ax,%ax
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
80103420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103425:	ba 21 00 00 00       	mov    $0x21,%edx
8010342a:	ee                   	out    %al,(%dx)
8010342b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103430:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103431:	c3                   	ret
80103432:	66 90                	xchg   %ax,%ax
80103434:	66 90                	xchg   %ax,%ax
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 0c             	sub    $0xc,%esp
80103449:	8b 75 08             	mov    0x8(%ebp),%esi
8010344c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010344f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103455:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345b:	e8 20 da ff ff       	call   80100e80 <filealloc>
80103460:	89 06                	mov    %eax,(%esi)
80103462:	85 c0                	test   %eax,%eax
80103464:	0f 84 a5 00 00 00    	je     8010350f <pipealloc+0xcf>
8010346a:	e8 11 da ff ff       	call   80100e80 <filealloc>
8010346f:	89 07                	mov    %eax,(%edi)
80103471:	85 c0                	test   %eax,%eax
80103473:	0f 84 84 00 00 00    	je     801034fd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103479:	e8 12 f2 ff ff       	call   80102690 <kalloc>
8010347e:	89 c3                	mov    %eax,%ebx
80103480:	85 c0                	test   %eax,%eax
80103482:	0f 84 a0 00 00 00    	je     80103528 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103488:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010348f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103492:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103495:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010349c:	00 00 00 
  p->nwrite = 0;
8010349f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034a6:	00 00 00 
  p->nread = 0;
801034a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b0:	00 00 00 
  initlock(&p->lock, "pipe");
801034b3:	68 71 82 10 80       	push   $0x80108271
801034b8:	50                   	push   %eax
801034b9:	e8 d2 1a 00 00       	call   80104f90 <initlock>
  (*f0)->type = FD_PIPE;
801034be:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c9:	8b 06                	mov    (%esi),%eax
801034cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034cf:	8b 06                	mov    (%esi),%eax
801034d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d5:	8b 06                	mov    (%esi),%eax
801034d7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034da:	8b 07                	mov    (%edi),%eax
801034dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e2:	8b 07                	mov    (%edi),%eax
801034e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e8:	8b 07                	mov    (%edi),%eax
801034ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ee:	8b 07                	mov    (%edi),%eax
801034f0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801034f3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034f8:	5b                   	pop    %ebx
801034f9:	5e                   	pop    %esi
801034fa:	5f                   	pop    %edi
801034fb:	5d                   	pop    %ebp
801034fc:	c3                   	ret
  if(*f0)
801034fd:	8b 06                	mov    (%esi),%eax
801034ff:	85 c0                	test   %eax,%eax
80103501:	74 1e                	je     80103521 <pipealloc+0xe1>
    fileclose(*f0);
80103503:	83 ec 0c             	sub    $0xc,%esp
80103506:	50                   	push   %eax
80103507:	e8 34 da ff ff       	call   80100f40 <fileclose>
8010350c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010350f:	8b 07                	mov    (%edi),%eax
80103511:	85 c0                	test   %eax,%eax
80103513:	74 0c                	je     80103521 <pipealloc+0xe1>
    fileclose(*f1);
80103515:	83 ec 0c             	sub    $0xc,%esp
80103518:	50                   	push   %eax
80103519:	e8 22 da ff ff       	call   80100f40 <fileclose>
8010351e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103526:	eb cd                	jmp    801034f5 <pipealloc+0xb5>
  if(*f0)
80103528:	8b 06                	mov    (%esi),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 d5                	jne    80103503 <pipealloc+0xc3>
8010352e:	eb df                	jmp    8010350f <pipealloc+0xcf>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 3c 1c 00 00       	call   80105180 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 fc 10 00 00       	call   80104660 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 97 1b 00 00       	jmp    80105120 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 87 1b 00 00       	call   80105120 <release>
    kfree((char*)p);
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 26 ef ff ff       	jmp    801024d0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 97 10 00 00       	call   80104660 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035dc:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801035df:	53                   	push   %ebx
801035e0:	e8 9b 1b 00 00       	call   80105180 <acquire>
  for(i = 0; i < n; i++){
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 ff                	test   %edi,%edi
801035ea:	0f 8e ce 00 00 00    	jle    801036be <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801035f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035f9:	89 7d 10             	mov    %edi,0x10(%ebp)
801035fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035ff:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103602:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103605:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010360b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103611:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103617:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010361d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103620:	0f 85 b6 00 00 00    	jne    801036dc <pipewrite+0x10c>
80103626:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103629:	eb 3b                	jmp    80103666 <pipewrite+0x96>
8010362b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103630:	e8 7b 04 00 00       	call   80103ab0 <myproc>
80103635:	8b 48 24             	mov    0x24(%eax),%ecx
80103638:	85 c9                	test   %ecx,%ecx
8010363a:	75 34                	jne    80103670 <pipewrite+0xa0>
      wakeup(&p->nread);
8010363c:	83 ec 0c             	sub    $0xc,%esp
8010363f:	56                   	push   %esi
80103640:	e8 1b 10 00 00       	call   80104660 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103645:	58                   	pop    %eax
80103646:	5a                   	pop    %edx
80103647:	53                   	push   %ebx
80103648:	57                   	push   %edi
80103649:	e8 a2 0d 00 00       	call   801043f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010364e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103654:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010365a:	83 c4 10             	add    $0x10,%esp
8010365d:	05 00 02 00 00       	add    $0x200,%eax
80103662:	39 c2                	cmp    %eax,%edx
80103664:	75 2a                	jne    80103690 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103666:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010366c:	85 c0                	test   %eax,%eax
8010366e:	75 c0                	jne    80103630 <pipewrite+0x60>
        release(&p->lock);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	53                   	push   %ebx
80103674:	e8 a7 1a 00 00       	call   80105120 <release>
        return -1;
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103681:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103684:	5b                   	pop    %ebx
80103685:	5e                   	pop    %esi
80103686:	5f                   	pop    %edi
80103687:	5d                   	pop    %ebp
80103688:	c3                   	ret
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103690:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103693:	8d 42 01             	lea    0x1(%edx),%eax
80103696:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010369c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010369f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036a8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801036ac:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801036b3:	39 c1                	cmp    %eax,%ecx
801036b5:	0f 85 50 ff ff ff    	jne    8010360b <pipewrite+0x3b>
801036bb:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036be:	83 ec 0c             	sub    $0xc,%esp
801036c1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036c7:	50                   	push   %eax
801036c8:	e8 93 0f 00 00       	call   80104660 <wakeup>
  release(&p->lock);
801036cd:	89 1c 24             	mov    %ebx,(%esp)
801036d0:	e8 4b 1a 00 00       	call   80105120 <release>
  return n;
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	89 f8                	mov    %edi,%eax
801036da:	eb a5                	jmp    80103681 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036df:	eb b2                	jmp    80103693 <pipewrite+0xc3>
801036e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801036e8:	00 
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 18             	sub    $0x18,%esp
801036f9:	8b 75 08             	mov    0x8(%ebp),%esi
801036fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036ff:	56                   	push   %esi
80103700:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103706:	e8 75 1a 00 00       	call   80105180 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103711:	83 c4 10             	add    $0x10,%esp
80103714:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010371a:	74 2f                	je     8010374b <piperead+0x5b>
8010371c:	eb 37                	jmp    80103755 <piperead+0x65>
8010371e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103720:	e8 8b 03 00 00       	call   80103ab0 <myproc>
80103725:	8b 40 24             	mov    0x24(%eax),%eax
80103728:	85 c0                	test   %eax,%eax
8010372a:	0f 85 80 00 00 00    	jne    801037b0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103730:	83 ec 08             	sub    $0x8,%esp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	e8 b6 0c 00 00       	call   801043f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010373a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103740:	83 c4 10             	add    $0x10,%esp
80103743:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103749:	75 0a                	jne    80103755 <piperead+0x65>
8010374b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103751:	85 d2                	test   %edx,%edx
80103753:	75 cb                	jne    80103720 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103755:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103758:	31 db                	xor    %ebx,%ebx
8010375a:	85 c9                	test   %ecx,%ecx
8010375c:	7f 26                	jg     80103784 <piperead+0x94>
8010375e:	eb 2c                	jmp    8010378c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103760:	8d 48 01             	lea    0x1(%eax),%ecx
80103763:	25 ff 01 00 00       	and    $0x1ff,%eax
80103768:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010376e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103773:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103776:	83 c3 01             	add    $0x1,%ebx
80103779:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010377c:	74 0e                	je     8010378c <piperead+0x9c>
8010377e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103784:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010378a:	75 d4                	jne    80103760 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103795:	50                   	push   %eax
80103796:	e8 c5 0e 00 00       	call   80104660 <wakeup>
  release(&p->lock);
8010379b:	89 34 24             	mov    %esi,(%esp)
8010379e:	e8 7d 19 00 00       	call   80105120 <release>
  return i;
801037a3:	83 c4 10             	add    $0x10,%esp
}
801037a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a9:	89 d8                	mov    %ebx,%eax
801037ab:	5b                   	pop    %ebx
801037ac:	5e                   	pop    %esi
801037ad:	5f                   	pop    %edi
801037ae:	5d                   	pop    %ebp
801037af:	c3                   	ret
      release(&p->lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037b8:	56                   	push   %esi
801037b9:	e8 62 19 00 00       	call   80105120 <release>
      return -1;
801037be:	83 c4 10             	add    $0x10,%esp
}
801037c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c4:	89 d8                	mov    %ebx,%eax
801037c6:	5b                   	pop    %ebx
801037c7:	5e                   	pop    %esi
801037c8:	5f                   	pop    %edi
801037c9:	5d                   	pop    %ebp
801037ca:	c3                   	ret
801037cb:	66 90                	xchg   %ax,%ax
801037cd:	66 90                	xchg   %ax,%ax
801037cf:	90                   	nop

801037d0 <wakeup1>:
// PAGEBREAK!
//  Wake up all processes sleeping on chan.
//  The ptable lock must be held.
static void
wakeup1(void *chan)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	56                   	push   %esi
801037d4:	89 c6                	mov    %eax,%esi
801037d6:	53                   	push   %ebx
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d7:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801037dc:	eb 10                	jmp    801037ee <wakeup1+0x1e>
801037de:	66 90                	xchg   %ax,%ax
801037e0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801037e6:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
801037ec:	74 75                	je     80103863 <wakeup1+0x93>
  {
    if (p->state == SLEEPING && p->chan == chan)
801037ee:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801037f2:	75 ec                	jne    801037e0 <wakeup1+0x10>
801037f4:	39 73 20             	cmp    %esi,0x20(%ebx)
801037f7:	75 e7                	jne    801037e0 <wakeup1+0x10>
    {
      p->state = RUNNABLE;
      acquire(&tickslock);
801037f9:	83 ec 0c             	sub    $0xc,%esp
      p->state = RUNNABLE;
801037fc:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      acquire(&tickslock);
80103803:	68 a0 56 11 80       	push   $0x801156a0
80103808:	e8 73 19 00 00       	call   80105180 <acquire>
      p->arrival_time = ticks;
8010380d:	a1 80 56 11 80       	mov    0x80115680,%eax
      p->waited_ticks = 0;
80103812:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103819:	00 00 00 
      p->arrival_time = ticks;
8010381c:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
      release(&tickslock);
80103822:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
80103829:	e8 f2 18 00 00       	call   80105120 <release>
      if (p->sched_class == 1)
8010382e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103831:	83 c4 10             	add    $0x10,%esp
80103834:	83 f8 01             	cmp    $0x1,%eax
80103837:	74 37                	je     80103870 <wakeup1+0xa0>
      {
        count_edf++;
        // cprintf("edf++ wakeup1\n");
      }
      else if (p->sched_class == 2 && p->sched_level == 1)
80103839:	83 f8 02             	cmp    $0x2,%eax
8010383c:	75 a2                	jne    801037e0 <wakeup1+0x10>
8010383e:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103844:	83 f8 01             	cmp    $0x1,%eax
80103847:	74 33                	je     8010387c <wakeup1+0xac>
        count_rr++;
      else if (p->sched_class == 2 && p->sched_level == 2)
80103849:	83 f8 02             	cmp    $0x2,%eax
8010384c:	75 92                	jne    801037e0 <wakeup1+0x10>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010384e:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
        count_fcfs++;
80103854:	83 05 54 56 11 80 01 	addl   $0x1,0x80115654
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010385b:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
80103861:	75 8b                	jne    801037ee <wakeup1+0x1e>
    }
  }
}
80103863:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103866:	5b                   	pop    %ebx
80103867:	5e                   	pop    %esi
80103868:	5d                   	pop    %ebp
80103869:	c3                   	ret
8010386a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        count_edf++;
80103870:	83 05 5c 56 11 80 01 	addl   $0x1,0x8011565c
80103877:	e9 64 ff ff ff       	jmp    801037e0 <wakeup1+0x10>
        count_rr++;
8010387c:	83 05 58 56 11 80 01 	addl   $0x1,0x80115658
80103883:	e9 58 ff ff ff       	jmp    801037e0 <wakeup1+0x10>
80103888:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010388f:	00 

80103890 <allocproc>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103894:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103899:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010389c:	68 20 2d 11 80       	push   $0x80112d20
801038a1:	e8 da 18 00 00       	call   80105180 <acquire>
801038a6:	83 c4 10             	add    $0x10,%esp
801038a9:	eb 17                	jmp    801038c2 <allocproc+0x32>
801038ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038b0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801038b6:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
801038bc:	0f 84 ce 00 00 00    	je     80103990 <allocproc+0x100>
    if (p->state == UNUSED)
801038c2:	8b 43 0c             	mov    0xc(%ebx),%eax
801038c5:	85 c0                	test   %eax,%eax
801038c7:	75 e7                	jne    801038b0 <allocproc+0x20>
  p->pid = nextpid++;
801038c9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  release(&ptable.lock);
801038ce:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038d1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->sched_class = 2; // Normal class by default
801038d8:	c7 43 7c 02 00 00 00 	movl   $0x2,0x7c(%ebx)
  p->pid = nextpid++;
801038df:	89 43 10             	mov    %eax,0x10(%ebx)
801038e2:	8d 50 01             	lea    0x1(%eax),%edx
  p->sched_level = 2; // FCFS (non-interactive) default
801038e5:	c7 83 80 00 00 00 02 	movl   $0x2,0x80(%ebx)
801038ec:	00 00 00 
  p->deadline = 1e9;  // Very large deadline (not used)
801038ef:	c7 83 84 00 00 00 00 	movl   $0x3b9aca00,0x84(%ebx)
801038f6:	ca 9a 3b 
  p->arrival_time = 0;
801038f9:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103900:	00 00 00 
  p->waited_ticks = 0;
80103903:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
8010390a:	00 00 00 
  p->consecutive_run = 0;
8010390d:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103914:	00 00 00 
  p->max_consecutive_run = 0;
80103917:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
8010391e:	00 00 00 
  p->rr_ticks = 0;
80103921:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103928:	00 00 00 
  p->runnig_time = 0;
8010392b:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103932:	00 00 00 
  release(&ptable.lock);
80103935:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010393a:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103940:	e8 db 17 00 00       	call   80105120 <release>
  if ((p->kstack = kalloc()) == 0)
80103945:	e8 46 ed ff ff       	call   80102690 <kalloc>
8010394a:	83 c4 10             	add    $0x10,%esp
8010394d:	89 43 08             	mov    %eax,0x8(%ebx)
80103950:	85 c0                	test   %eax,%eax
80103952:	74 55                	je     801039a9 <allocproc+0x119>
  sp -= sizeof *p->tf;
80103954:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
8010395a:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010395d:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103962:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103965:	c7 40 14 6d 65 10 80 	movl   $0x8010656d,0x14(%eax)
  p->context = (struct context *)sp;
8010396c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010396f:	6a 14                	push   $0x14
80103971:	6a 00                	push   $0x0
80103973:	50                   	push   %eax
80103974:	e8 07 19 00 00       	call   80105280 <memset>
  p->context->eip = (uint)forkret;
80103979:	8b 43 1c             	mov    0x1c(%ebx),%eax
  return p;
8010397c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010397f:	c7 40 10 c0 39 10 80 	movl   $0x801039c0,0x10(%eax)
}
80103986:	89 d8                	mov    %ebx,%eax
80103988:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010398b:	c9                   	leave
8010398c:	c3                   	ret
8010398d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103990:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103993:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103995:	68 20 2d 11 80       	push   $0x80112d20
8010399a:	e8 81 17 00 00       	call   80105120 <release>
  return 0;
8010399f:	83 c4 10             	add    $0x10,%esp
}
801039a2:	89 d8                	mov    %ebx,%eax
801039a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a7:	c9                   	leave
801039a8:	c3                   	ret
    p->state = UNUSED;
801039a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801039b0:	31 db                	xor    %ebx,%ebx
801039b2:	eb ee                	jmp    801039a2 <allocproc+0x112>
801039b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039bb:	00 
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039c0 <forkret>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801039c6:	68 20 2d 11 80       	push   $0x80112d20
801039cb:	e8 50 17 00 00       	call   80105120 <release>
  if (first)
801039d0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	85 c0                	test   %eax,%eax
801039da:	75 04                	jne    801039e0 <forkret+0x20>
}
801039dc:	c9                   	leave
801039dd:	c3                   	ret
801039de:	66 90                	xchg   %ax,%ax
    first = 0;
801039e0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801039e7:	00 00 00 
    iinit(ROOTDEV);
801039ea:	83 ec 0c             	sub    $0xc,%esp
801039ed:	6a 01                	push   $0x1
801039ef:	e8 bc db ff ff       	call   801015b0 <iinit>
    initlog(ROOTDEV);
801039f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039fb:	e8 d0 f2 ff ff       	call   80102cd0 <initlog>
}
80103a00:	83 c4 10             	add    $0x10,%esp
80103a03:	c9                   	leave
80103a04:	c3                   	ret
80103a05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a0c:	00 
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi

80103a10 <pinit>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a16:	68 76 82 10 80       	push   $0x80108276
80103a1b:	68 20 2d 11 80       	push   $0x80112d20
80103a20:	e8 6b 15 00 00       	call   80104f90 <initlock>
}
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	c9                   	leave
80103a29:	c3                   	ret
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a30 <mycpu>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a35:	9c                   	pushf
80103a36:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103a37:	f6 c4 02             	test   $0x2,%ah
80103a3a:	75 46                	jne    80103a82 <mycpu+0x52>
  apicid = lapicid();
80103a3c:	e8 bf ee ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103a41:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103a47:	85 f6                	test   %esi,%esi
80103a49:	7e 2a                	jle    80103a75 <mycpu+0x45>
80103a4b:	31 d2                	xor    %edx,%edx
80103a4d:	eb 08                	jmp    80103a57 <mycpu+0x27>
80103a4f:	90                   	nop
80103a50:	83 c2 01             	add    $0x1,%edx
80103a53:	39 f2                	cmp    %esi,%edx
80103a55:	74 1e                	je     80103a75 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a57:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a5d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103a64:	39 c3                	cmp    %eax,%ebx
80103a66:	75 e8                	jne    80103a50 <mycpu+0x20>
}
80103a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a6b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103a71:	5b                   	pop    %ebx
80103a72:	5e                   	pop    %esi
80103a73:	5d                   	pop    %ebp
80103a74:	c3                   	ret
  panic("unknown apicid\n");
80103a75:	83 ec 0c             	sub    $0xc,%esp
80103a78:	68 7d 82 10 80       	push   $0x8010827d
80103a7d:	e8 fe c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a82:	83 ec 0c             	sub    $0xc,%esp
80103a85:	68 88 86 10 80       	push   $0x80108688
80103a8a:	e8 f1 c8 ff ff       	call   80100380 <panic>
80103a8f:	90                   	nop

80103a90 <cpuid>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103a96:	e8 95 ff ff ff       	call   80103a30 <mycpu>
}
80103a9b:	c9                   	leave
  return mycpu() - cpus;
80103a9c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103aa1:	c1 f8 04             	sar    $0x4,%eax
80103aa4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aaa:	c3                   	ret
80103aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ab0 <myproc>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
80103ab4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ab7:	e8 74 15 00 00       	call   80105030 <pushcli>
  c = mycpu();
80103abc:	e8 6f ff ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103ac1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac7:	e8 b4 15 00 00       	call   80105080 <popcli>
}
80103acc:	89 d8                	mov    %ebx,%eax
80103ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ad1:	c9                   	leave
80103ad2:	c3                   	ret
80103ad3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ada:	00 
80103adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ae0 <userinit>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ae7:	e8 a4 fd ff ff       	call   80103890 <allocproc>
  p->sched_class = 2; // Normal class
80103aec:	c7 40 7c 02 00 00 00 	movl   $0x2,0x7c(%eax)
  p = allocproc();
80103af3:	89 c3                	mov    %eax,%ebx
  p->sched_level = 1; // Interactive (RR)
80103af5:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
80103afc:	00 00 00 
  initproc = p;
80103aff:	a3 60 56 11 80       	mov    %eax,0x80115660
  if ((p->pgdir = setupkvm()) == 0)
80103b04:	e8 d7 41 00 00       	call   80107ce0 <setupkvm>
80103b09:	89 43 04             	mov    %eax,0x4(%ebx)
80103b0c:	85 c0                	test   %eax,%eax
80103b0e:	0f 84 35 01 00 00    	je     80103c49 <userinit+0x169>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b14:	83 ec 04             	sub    $0x4,%esp
80103b17:	68 2c 00 00 00       	push   $0x2c
80103b1c:	68 60 b4 10 80       	push   $0x8010b460
80103b21:	50                   	push   %eax
80103b22:	e8 99 3e 00 00       	call   801079c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b27:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b2a:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b30:	6a 4c                	push   $0x4c
80103b32:	6a 00                	push   $0x0
80103b34:	ff 73 18             	push   0x18(%ebx)
80103b37:	e8 44 17 00 00       	call   80105280 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b3f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b44:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b47:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b4c:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b50:	8b 43 18             	mov    0x18(%ebx),%eax
80103b53:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b57:	8b 43 18             	mov    0x18(%ebx),%eax
80103b5a:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b5e:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b62:	8b 43 18             	mov    0x18(%ebx),%eax
80103b65:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b69:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b6d:	8b 43 18             	mov    0x18(%ebx),%eax
80103b70:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b77:	8b 43 18             	mov    0x18(%ebx),%eax
80103b7a:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103b81:	8b 43 18             	mov    0x18(%ebx),%eax
80103b84:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b8b:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b8e:	6a 10                	push   $0x10
80103b90:	68 a6 82 10 80       	push   $0x801082a6
80103b95:	50                   	push   %eax
80103b96:	e8 95 18 00 00       	call   80105430 <safestrcpy>
  p->cwd = namei("/");
80103b9b:	c7 04 24 af 82 10 80 	movl   $0x801082af,(%esp)
80103ba2:	e8 09 e5 ff ff       	call   801020b0 <namei>
80103ba7:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103baa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bb1:	e8 ca 15 00 00       	call   80105180 <acquire>
  p->state = RUNNABLE;
80103bb6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  acquire(&tickslock);
80103bbd:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
80103bc4:	e8 b7 15 00 00       	call   80105180 <acquire>
  p->arrival_time = ticks;
80103bc9:	a1 80 56 11 80       	mov    0x80115680,%eax
  p->waited_ticks = 0;
80103bce:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103bd5:	00 00 00 
  p->arrival_time = ticks;
80103bd8:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  release(&tickslock);
80103bde:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
80103be5:	e8 36 15 00 00       	call   80105120 <release>
  if (p->sched_class == 1)
80103bea:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103bed:	83 c4 10             	add    $0x10,%esp
80103bf0:	83 f8 01             	cmp    $0x1,%eax
80103bf3:	74 3b                	je     80103c30 <userinit+0x150>
  else if (p->sched_class == 2 && p->sched_level == 1)
80103bf5:	83 f8 02             	cmp    $0x2,%eax
80103bf8:	74 16                	je     80103c10 <userinit+0x130>
  release(&ptable.lock);
80103bfa:	83 ec 0c             	sub    $0xc,%esp
80103bfd:	68 20 2d 11 80       	push   $0x80112d20
80103c02:	e8 19 15 00 00       	call   80105120 <release>
}
80103c07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c0a:	83 c4 10             	add    $0x10,%esp
80103c0d:	c9                   	leave
80103c0e:	c3                   	ret
80103c0f:	90                   	nop
  else if (p->sched_class == 2 && p->sched_level == 1)
80103c10:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103c16:	83 f8 01             	cmp    $0x1,%eax
80103c19:	74 25                	je     80103c40 <userinit+0x160>
  else if (p->sched_class == 2 && p->sched_level == 2)
80103c1b:	83 f8 02             	cmp    $0x2,%eax
80103c1e:	75 da                	jne    80103bfa <userinit+0x11a>
    count_fcfs++;
80103c20:	83 05 54 56 11 80 01 	addl   $0x1,0x80115654
80103c27:	eb d1                	jmp    80103bfa <userinit+0x11a>
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    count_edf++;
80103c30:	83 05 5c 56 11 80 01 	addl   $0x1,0x8011565c
80103c37:	eb c1                	jmp    80103bfa <userinit+0x11a>
80103c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    count_rr++;
80103c40:	83 05 58 56 11 80 01 	addl   $0x1,0x80115658
80103c47:	eb b1                	jmp    80103bfa <userinit+0x11a>
    panic("userinit: out of memory?");
80103c49:	83 ec 0c             	sub    $0xc,%esp
80103c4c:	68 8d 82 10 80       	push   $0x8010828d
80103c51:	e8 2a c7 ff ff       	call   80100380 <panic>
80103c56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c5d:	00 
80103c5e:	66 90                	xchg   %ax,%ax

80103c60 <growproc>:
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	56                   	push   %esi
80103c64:	53                   	push   %ebx
80103c65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c68:	e8 c3 13 00 00       	call   80105030 <pushcli>
  c = mycpu();
80103c6d:	e8 be fd ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103c72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c78:	e8 03 14 00 00       	call   80105080 <popcli>
  sz = curproc->sz;
80103c7d:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103c7f:	85 f6                	test   %esi,%esi
80103c81:	7f 1d                	jg     80103ca0 <growproc+0x40>
  else if (n < 0)
80103c83:	75 3b                	jne    80103cc0 <growproc+0x60>
  switchuvm(curproc);
80103c85:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c88:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c8a:	53                   	push   %ebx
80103c8b:	e8 20 3c 00 00       	call   801078b0 <switchuvm>
  return 0;
80103c90:	83 c4 10             	add    $0x10,%esp
80103c93:	31 c0                	xor    %eax,%eax
}
80103c95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c98:	5b                   	pop    %ebx
80103c99:	5e                   	pop    %esi
80103c9a:	5d                   	pop    %ebp
80103c9b:	c3                   	ret
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ca0:	83 ec 04             	sub    $0x4,%esp
80103ca3:	01 c6                	add    %eax,%esi
80103ca5:	56                   	push   %esi
80103ca6:	50                   	push   %eax
80103ca7:	ff 73 04             	push   0x4(%ebx)
80103caa:	e8 61 3e 00 00       	call   80107b10 <allocuvm>
80103caf:	83 c4 10             	add    $0x10,%esp
80103cb2:	85 c0                	test   %eax,%eax
80103cb4:	75 cf                	jne    80103c85 <growproc+0x25>
      return -1;
80103cb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cbb:	eb d8                	jmp    80103c95 <growproc+0x35>
80103cbd:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cc0:	83 ec 04             	sub    $0x4,%esp
80103cc3:	01 c6                	add    %eax,%esi
80103cc5:	56                   	push   %esi
80103cc6:	50                   	push   %eax
80103cc7:	ff 73 04             	push   0x4(%ebx)
80103cca:	e8 61 3f 00 00       	call   80107c30 <deallocuvm>
80103ccf:	83 c4 10             	add    $0x10,%esp
80103cd2:	85 c0                	test   %eax,%eax
80103cd4:	75 af                	jne    80103c85 <growproc+0x25>
80103cd6:	eb de                	jmp    80103cb6 <growproc+0x56>
80103cd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103cdf:	00 

80103ce0 <fork>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	57                   	push   %edi
80103ce4:	56                   	push   %esi
80103ce5:	53                   	push   %ebx
80103ce6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103ce9:	e8 42 13 00 00       	call   80105030 <pushcli>
  c = mycpu();
80103cee:	e8 3d fd ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103cf3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf9:	e8 82 13 00 00       	call   80105080 <popcli>
  if ((np = allocproc()) == 0)
80103cfe:	e8 8d fb ff ff       	call   80103890 <allocproc>
80103d03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d06:	85 c0                	test   %eax,%eax
80103d08:	0f 84 53 01 00 00    	je     80103e61 <fork+0x181>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103d0e:	83 ec 08             	sub    $0x8,%esp
80103d11:	ff 33                	push   (%ebx)
80103d13:	89 c7                	mov    %eax,%edi
80103d15:	ff 73 04             	push   0x4(%ebx)
80103d18:	e8 b3 40 00 00       	call   80107dd0 <copyuvm>
80103d1d:	83 c4 10             	add    $0x10,%esp
80103d20:	89 47 04             	mov    %eax,0x4(%edi)
80103d23:	85 c0                	test   %eax,%eax
80103d25:	0f 84 17 01 00 00    	je     80103e42 <fork+0x162>
  np->sz = curproc->sz;
80103d2b:	8b 03                	mov    (%ebx),%eax
80103d2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d30:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d32:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d35:	89 c8                	mov    %ecx,%eax
80103d37:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d3a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d3f:	8b 73 18             	mov    0x18(%ebx),%esi
80103d42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80103d44:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d46:	8b 40 18             	mov    0x18(%eax),%eax
80103d49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if (curproc->ofile[i])
80103d50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d54:	85 c0                	test   %eax,%eax
80103d56:	74 13                	je     80103d6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d58:	83 ec 0c             	sub    $0xc,%esp
80103d5b:	50                   	push   %eax
80103d5c:	e8 8f d1 ff ff       	call   80100ef0 <filedup>
80103d61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d64:	83 c4 10             	add    $0x10,%esp
80103d67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80103d6b:	83 c6 01             	add    $0x1,%esi
80103d6e:	83 fe 10             	cmp    $0x10,%esi
80103d71:	75 dd                	jne    80103d50 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d73:	83 ec 0c             	sub    $0xc,%esp
80103d76:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d79:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d7c:	e8 1f da ff ff       	call   801017a0 <idup>
80103d81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d84:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d87:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d8d:	6a 10                	push   $0x10
80103d8f:	53                   	push   %ebx
80103d90:	50                   	push   %eax
80103d91:	e8 9a 16 00 00       	call   80105430 <safestrcpy>
  pid = np->pid;
80103d96:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d99:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103da0:	e8 db 13 00 00       	call   80105180 <acquire>
  np->state = RUNNABLE;
80103da5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  acquire(&tickslock);
80103dac:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
80103db3:	e8 c8 13 00 00       	call   80105180 <acquire>
  np->arrival_time = ticks;
80103db8:	a1 80 56 11 80       	mov    0x80115680,%eax
  np->waited_ticks = 0;
80103dbd:	c7 87 94 00 00 00 00 	movl   $0x0,0x94(%edi)
80103dc4:	00 00 00 
  np->arrival_time = ticks;
80103dc7:	89 87 90 00 00 00    	mov    %eax,0x90(%edi)
  np->last_run = ticks;
80103dcd:	89 87 a0 00 00 00    	mov    %eax,0xa0(%edi)
  release(&tickslock);
80103dd3:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
80103dda:	e8 41 13 00 00       	call   80105120 <release>
  if (np->sched_class == 1)
80103ddf:	8b 47 7c             	mov    0x7c(%edi),%eax
80103de2:	83 c4 10             	add    $0x10,%esp
80103de5:	83 f8 01             	cmp    $0x1,%eax
80103de8:	74 46                	je     80103e30 <fork+0x150>
  else if (np->sched_class == 2 && np->sched_level == 1)
80103dea:	83 f8 02             	cmp    $0x2,%eax
80103ded:	74 21                	je     80103e10 <fork+0x130>
  release(&ptable.lock);
80103def:	83 ec 0c             	sub    $0xc,%esp
80103df2:	68 20 2d 11 80       	push   $0x80112d20
80103df7:	e8 24 13 00 00       	call   80105120 <release>
  return pid;
80103dfc:	83 c4 10             	add    $0x10,%esp
}
80103dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e02:	89 d8                	mov    %ebx,%eax
80103e04:	5b                   	pop    %ebx
80103e05:	5e                   	pop    %esi
80103e06:	5f                   	pop    %edi
80103e07:	5d                   	pop    %ebp
80103e08:	c3                   	ret
80103e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  else if (np->sched_class == 2 && np->sched_level == 1)
80103e10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e13:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80103e19:	83 f8 01             	cmp    $0x1,%eax
80103e1c:	74 1b                	je     80103e39 <fork+0x159>
  else if (np->sched_class == 2 && np->sched_level == 2)
80103e1e:	83 f8 02             	cmp    $0x2,%eax
80103e21:	75 cc                	jne    80103def <fork+0x10f>
    count_fcfs++;
80103e23:	83 05 54 56 11 80 01 	addl   $0x1,0x80115654
80103e2a:	eb c3                	jmp    80103def <fork+0x10f>
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    count_edf++;
80103e30:	83 05 5c 56 11 80 01 	addl   $0x1,0x8011565c
80103e37:	eb b6                	jmp    80103def <fork+0x10f>
    count_rr++;
80103e39:	83 05 58 56 11 80 01 	addl   $0x1,0x80115658
80103e40:	eb ad                	jmp    80103def <fork+0x10f>
    kfree(np->kstack);
80103e42:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e45:	83 ec 0c             	sub    $0xc,%esp
80103e48:	ff 73 08             	push   0x8(%ebx)
80103e4b:	e8 80 e6 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103e50:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e57:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e5a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e61:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e66:	eb 97                	jmp    80103dff <fork+0x11f>
80103e68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e6f:	00 

80103e70 <scheduler>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	57                   	push   %edi
80103e74:	56                   	push   %esi
80103e75:	53                   	push   %ebx
  struct proc *p , *nextrrp = ptable.proc, *chosen ;
80103e76:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103e7b:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103e7e:	e8 ad fb ff ff       	call   80103a30 <mycpu>
  c->proc = 0;
80103e83:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e8a:	00 00 00 
  struct cpu *c = mycpu();
80103e8d:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e8f:	8d 40 04             	lea    0x4(%eax),%eax
80103e92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e95:	eb 35                	jmp    80103ecc <scheduler+0x5c>
80103e97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e9e:	00 
80103e9f:	90                   	nop
    else if (count_rr > 0)
80103ea0:	8b 3d 58 56 11 80    	mov    0x80115658,%edi
80103ea6:	85 ff                	test   %edi,%edi
80103ea8:	0f 8f 32 01 00 00    	jg     80103fe0 <scheduler+0x170>
    else if (count_fcfs > 0)
80103eae:	8b 0d 54 56 11 80    	mov    0x80115654,%ecx
80103eb4:	85 c9                	test   %ecx,%ecx
80103eb6:	0f 8f 71 01 00 00    	jg     8010402d <scheduler+0x1bd>
    release(&ptable.lock);
80103ebc:	83 ec 0c             	sub    $0xc,%esp
80103ebf:	68 20 2d 11 80       	push   $0x80112d20
80103ec4:	e8 57 12 00 00       	call   80105120 <release>
    sti();
80103ec9:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103ecc:	fb                   	sti
    acquire(&ptable.lock);
80103ecd:	83 ec 0c             	sub    $0xc,%esp
80103ed0:	68 20 2d 11 80       	push   $0x80112d20
80103ed5:	e8 a6 12 00 00       	call   80105180 <acquire>
    if (count_edf > 0)
80103eda:	a1 5c 56 11 80       	mov    0x8011565c,%eax
80103edf:	83 c4 10             	add    $0x10,%esp
80103ee2:	85 c0                	test   %eax,%eax
80103ee4:	7e ba                	jle    80103ea0 <scheduler+0x30>
    chosen = 0;
80103ee6:	31 ff                	xor    %edi,%edi
      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ee8:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103eed:	eb 0d                	jmp    80103efc <scheduler+0x8c>
80103eef:	90                   	nop
80103ef0:	05 a4 00 00 00       	add    $0xa4,%eax
80103ef5:	3d 54 56 11 80       	cmp    $0x80115654,%eax
80103efa:	74 34                	je     80103f30 <scheduler+0xc0>
        if (p->state == RUNNABLE && p->sched_class == 1)
80103efc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103f00:	75 ee                	jne    80103ef0 <scheduler+0x80>
80103f02:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
80103f06:	75 e8                	jne    80103ef0 <scheduler+0x80>
          if (chosen == 0 || p->deadline < chosen->deadline)
80103f08:	85 ff                	test   %edi,%edi
80103f0a:	0f 84 c0 00 00 00    	je     80103fd0 <scheduler+0x160>
            chosen = p;
80103f10:	8b 97 84 00 00 00    	mov    0x84(%edi),%edx
80103f16:	39 90 84 00 00 00    	cmp    %edx,0x84(%eax)
80103f1c:	0f 4c f8             	cmovl  %eax,%edi
      for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f1f:	05 a4 00 00 00       	add    $0xa4,%eax
80103f24:	3d 54 56 11 80       	cmp    $0x80115654,%eax
80103f29:	75 d1                	jne    80103efc <scheduler+0x8c>
80103f2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (chosen)
80103f30:	85 ff                	test   %edi,%edi
80103f32:	74 88                	je     80103ebc <scheduler+0x4c>
      switchuvm(chosen);
80103f34:	83 ec 0c             	sub    $0xc,%esp
      c->proc = chosen;
80103f37:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
      switchuvm(chosen);
80103f3d:	57                   	push   %edi
80103f3e:	e8 6d 39 00 00       	call   801078b0 <switchuvm>
      if (chosen->sched_class == 1)
80103f43:	8b 47 7c             	mov    0x7c(%edi),%eax
      chosen->state = RUNNING;
80103f46:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      if (chosen->sched_class == 1)
80103f4d:	83 c4 10             	add    $0x10,%esp
80103f50:	83 f8 01             	cmp    $0x1,%eax
80103f53:	0f 84 28 01 00 00    	je     80104081 <scheduler+0x211>
      else if (chosen->sched_class == 2 && chosen->sched_level == 1)
80103f59:	83 f8 02             	cmp    $0x2,%eax
80103f5c:	0f 84 2f 01 00 00    	je     80104091 <scheduler+0x221>
      chosen->consecutive_run = 0; // reset before a fresh run
80103f62:	c7 87 98 00 00 00 00 	movl   $0x0,0x98(%edi)
80103f69:	00 00 00 
      acquire(&tickslock);
80103f6c:	83 ec 0c             	sub    $0xc,%esp
      chosen->rr_ticks = 0;
80103f6f:	c7 87 88 00 00 00 00 	movl   $0x0,0x88(%edi)
80103f76:	00 00 00 
      chosen->waited_ticks = 0;
80103f79:	c7 87 94 00 00 00 00 	movl   $0x0,0x94(%edi)
80103f80:	00 00 00 
      acquire(&tickslock);
80103f83:	68 a0 56 11 80       	push   $0x801156a0
80103f88:	e8 f3 11 00 00       	call   80105180 <acquire>
      chosen->last_run = ticks;
80103f8d:	a1 80 56 11 80       	mov    0x80115680,%eax
80103f92:	89 87 a0 00 00 00    	mov    %eax,0xa0(%edi)
      release(&tickslock);
80103f98:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
80103f9f:	e8 7c 11 00 00       	call   80105120 <release>
      swtch(&(c->scheduler), chosen->context);
80103fa4:	58                   	pop    %eax
80103fa5:	5a                   	pop    %edx
80103fa6:	ff 77 1c             	push   0x1c(%edi)
80103fa9:	ff 75 e4             	push   -0x1c(%ebp)
80103fac:	e8 da 14 00 00       	call   8010548b <swtch>
      switchkvm();
80103fb1:	e8 ea 38 00 00       	call   801078a0 <switchkvm>
      c->proc = 0;
80103fb6:	83 c4 10             	add    $0x10,%esp
80103fb9:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103fc0:	00 00 00 
80103fc3:	e9 f4 fe ff ff       	jmp    80103ebc <scheduler+0x4c>
80103fc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fcf:	00 
            chosen = p;
80103fd0:	89 c7                	mov    %eax,%edi
80103fd2:	e9 19 ff ff ff       	jmp    80103ef0 <scheduler+0x80>
80103fd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fde:	00 
80103fdf:	90                   	nop
      p = nextrrp;
80103fe0:	89 df                	mov    %ebx,%edi
        if (p->state != RUNNABLE || p->sched_level != 1)
80103fe2:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103fe6:	75 28                	jne    80104010 <scheduler+0x1a0>
80103fe8:	83 bf 80 00 00 00 01 	cmpl   $0x1,0x80(%edi)
80103fef:	75 1f                	jne    80104010 <scheduler+0x1a0>
        if (++p == &ptable.proc[NPROC])
80103ff1:	8d 9f a4 00 00 00    	lea    0xa4(%edi),%ebx
          p = ptable.proc;
80103ff7:	81 ff b0 55 11 80    	cmp    $0x801155b0,%edi
80103ffd:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104002:	0f 44 d8             	cmove  %eax,%ebx
80104005:	e9 2a ff ff ff       	jmp    80103f34 <scheduler+0xc4>
8010400a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          if (++p == &ptable.proc[NPROC])
80104010:	81 c7 a4 00 00 00    	add    $0xa4,%edi
            p = ptable.proc;
80104016:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010401b:	81 ff 54 56 11 80    	cmp    $0x80115654,%edi
80104021:	0f 44 f8             	cmove  %eax,%edi
      } while (p != nextrrp);
80104024:	39 df                	cmp    %ebx,%edi
80104026:	75 ba                	jne    80103fe2 <scheduler+0x172>
80104028:	e9 8f fe ff ff       	jmp    80103ebc <scheduler+0x4c>
    chosen = 0;
8010402d:	31 ff                	xor    %edi,%edi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010402f:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104034:	eb 1a                	jmp    80104050 <scheduler+0x1e0>
80104036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010403d:	00 
8010403e:	66 90                	xchg   %ax,%ax
80104040:	05 a4 00 00 00       	add    $0xa4,%eax
80104045:	3d 54 56 11 80       	cmp    $0x80115654,%eax
8010404a:	0f 84 e0 fe ff ff    	je     80103f30 <scheduler+0xc0>
          if (p->state == RUNNABLE && p->sched_class == 2 && p->sched_level == 2)
80104050:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104054:	75 ea                	jne    80104040 <scheduler+0x1d0>
80104056:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
8010405a:	75 e4                	jne    80104040 <scheduler+0x1d0>
8010405c:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
80104063:	75 db                	jne    80104040 <scheduler+0x1d0>
            p->waited_ticks++;
80104065:	83 80 94 00 00 00 01 	addl   $0x1,0x94(%eax)
            if (chosen == 0 || p->arrival_time < chosen->arrival_time)
8010406c:	85 ff                	test   %edi,%edi
8010406e:	74 1d                	je     8010408d <scheduler+0x21d>
              chosen = p;
80104070:	8b 8f 90 00 00 00    	mov    0x90(%edi),%ecx
80104076:	39 88 90 00 00 00    	cmp    %ecx,0x90(%eax)
8010407c:	0f 4c f8             	cmovl  %eax,%edi
8010407f:	eb bf                	jmp    80104040 <scheduler+0x1d0>
        count_edf--;
80104081:	83 2d 5c 56 11 80 01 	subl   $0x1,0x8011565c
80104088:	e9 d5 fe ff ff       	jmp    80103f62 <scheduler+0xf2>
              chosen = p;
8010408d:	89 c7                	mov    %eax,%edi
8010408f:	eb af                	jmp    80104040 <scheduler+0x1d0>
      else if (chosen->sched_class == 2 && chosen->sched_level == 1)
80104091:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80104097:	83 f8 01             	cmp    $0x1,%eax
8010409a:	74 15                	je     801040b1 <scheduler+0x241>
      else if (chosen->sched_class == 2 && chosen->sched_level == 2)
8010409c:	83 f8 02             	cmp    $0x2,%eax
8010409f:	0f 85 bd fe ff ff    	jne    80103f62 <scheduler+0xf2>
        count_fcfs--;
801040a5:	83 2d 54 56 11 80 01 	subl   $0x1,0x80115654
801040ac:	e9 b1 fe ff ff       	jmp    80103f62 <scheduler+0xf2>
        count_rr--;
801040b1:	83 2d 58 56 11 80 01 	subl   $0x1,0x80115658
801040b8:	e9 a5 fe ff ff       	jmp    80103f62 <scheduler+0xf2>
801040bd:	8d 76 00             	lea    0x0(%esi),%esi

801040c0 <sched>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	56                   	push   %esi
801040c4:	53                   	push   %ebx
  pushcli();
801040c5:	e8 66 0f 00 00       	call   80105030 <pushcli>
  c = mycpu();
801040ca:	e8 61 f9 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
801040cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040d5:	e8 a6 0f 00 00       	call   80105080 <popcli>
  if (!holding(&ptable.lock))
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 20 2d 11 80       	push   $0x80112d20
801040e2:	e8 f9 0f 00 00       	call   801050e0 <holding>
801040e7:	83 c4 10             	add    $0x10,%esp
801040ea:	85 c0                	test   %eax,%eax
801040ec:	74 4f                	je     8010413d <sched+0x7d>
  if (mycpu()->ncli != 1)
801040ee:	e8 3d f9 ff ff       	call   80103a30 <mycpu>
801040f3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801040fa:	75 68                	jne    80104164 <sched+0xa4>
  if (p->state == RUNNING)
801040fc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104100:	74 55                	je     80104157 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104102:	9c                   	pushf
80104103:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80104104:	f6 c4 02             	test   $0x2,%ah
80104107:	75 41                	jne    8010414a <sched+0x8a>
  intena = mycpu()->intena;
80104109:	e8 22 f9 ff ff       	call   80103a30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010410e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104111:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104117:	e8 14 f9 ff ff       	call   80103a30 <mycpu>
8010411c:	83 ec 08             	sub    $0x8,%esp
8010411f:	ff 70 04             	push   0x4(%eax)
80104122:	53                   	push   %ebx
80104123:	e8 63 13 00 00       	call   8010548b <swtch>
  mycpu()->intena = intena;
80104128:	e8 03 f9 ff ff       	call   80103a30 <mycpu>
}
8010412d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104130:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104136:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104139:	5b                   	pop    %ebx
8010413a:	5e                   	pop    %esi
8010413b:	5d                   	pop    %ebp
8010413c:	c3                   	ret
    panic("sched ptable.lock");
8010413d:	83 ec 0c             	sub    $0xc,%esp
80104140:	68 b1 82 10 80       	push   $0x801082b1
80104145:	e8 36 c2 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010414a:	83 ec 0c             	sub    $0xc,%esp
8010414d:	68 dd 82 10 80       	push   $0x801082dd
80104152:	e8 29 c2 ff ff       	call   80100380 <panic>
    panic("sched running");
80104157:	83 ec 0c             	sub    $0xc,%esp
8010415a:	68 cf 82 10 80       	push   $0x801082cf
8010415f:	e8 1c c2 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	68 c3 82 10 80       	push   $0x801082c3
8010416c:	e8 0f c2 ff ff       	call   80100380 <panic>
80104171:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104178:	00 
80104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104180 <exit>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104189:	e8 22 f9 ff ff       	call   80103ab0 <myproc>
  if (curproc == initproc)
8010418e:	39 05 60 56 11 80    	cmp    %eax,0x80115660
80104194:	0f 84 bf 00 00 00    	je     80104259 <exit+0xd9>
8010419a:	89 c6                	mov    %eax,%esi
8010419c:	8d 58 28             	lea    0x28(%eax),%ebx
8010419f:	8d 78 68             	lea    0x68(%eax),%edi
801041a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
801041a8:	8b 03                	mov    (%ebx),%eax
801041aa:	85 c0                	test   %eax,%eax
801041ac:	74 12                	je     801041c0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801041ae:	83 ec 0c             	sub    $0xc,%esp
801041b1:	50                   	push   %eax
801041b2:	e8 89 cd ff ff       	call   80100f40 <fileclose>
      curproc->ofile[fd] = 0;
801041b7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801041bd:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
801041c0:	83 c3 04             	add    $0x4,%ebx
801041c3:	39 fb                	cmp    %edi,%ebx
801041c5:	75 e1                	jne    801041a8 <exit+0x28>
  begin_op();
801041c7:	e8 a4 eb ff ff       	call   80102d70 <begin_op>
  iput(curproc->cwd);
801041cc:	83 ec 0c             	sub    $0xc,%esp
801041cf:	ff 76 68             	push   0x68(%esi)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d2:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  iput(curproc->cwd);
801041d7:	e8 24 d7 ff ff       	call   80101900 <iput>
  end_op();
801041dc:	e8 ff eb ff ff       	call   80102de0 <end_op>
  curproc->cwd = 0;
801041e1:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801041e8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801041ef:	e8 8c 0f 00 00       	call   80105180 <acquire>
  wakeup1(curproc->parent);
801041f4:	8b 46 14             	mov    0x14(%esi),%eax
801041f7:	e8 d4 f5 ff ff       	call   801037d0 <wakeup1>
801041fc:	83 c4 10             	add    $0x10,%esp
801041ff:	eb 15                	jmp    80104216 <exit+0x96>
80104201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104208:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
8010420e:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
80104214:	74 2a                	je     80104240 <exit+0xc0>
    if (p->parent == curproc)
80104216:	39 73 14             	cmp    %esi,0x14(%ebx)
80104219:	75 ed                	jne    80104208 <exit+0x88>
      p->parent = initproc;
8010421b:	a1 60 56 11 80       	mov    0x80115660,%eax
      if (p->state == ZOMBIE)
80104220:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
80104224:	89 43 14             	mov    %eax,0x14(%ebx)
      if (p->state == ZOMBIE)
80104227:	75 df                	jne    80104208 <exit+0x88>
        wakeup1(initproc);
80104229:	e8 a2 f5 ff ff       	call   801037d0 <wakeup1>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010422e:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80104234:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
8010423a:	75 da                	jne    80104216 <exit+0x96>
8010423c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80104240:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104247:	e8 74 fe ff ff       	call   801040c0 <sched>
  panic("zombie exit");
8010424c:	83 ec 0c             	sub    $0xc,%esp
8010424f:	68 fe 82 10 80       	push   $0x801082fe
80104254:	e8 27 c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104259:	83 ec 0c             	sub    $0xc,%esp
8010425c:	68 f1 82 10 80       	push   $0x801082f1
80104261:	e8 1a c1 ff ff       	call   80100380 <panic>
80104266:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010426d:	00 
8010426e:	66 90                	xchg   %ax,%ax

80104270 <yield>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	56                   	push   %esi
80104274:	53                   	push   %ebx
  acquire(&ptable.lock); // DOC: yieldlock
80104275:	83 ec 0c             	sub    $0xc,%esp
80104278:	68 20 2d 11 80       	push   $0x80112d20
8010427d:	e8 fe 0e 00 00       	call   80105180 <acquire>
  pushcli();
80104282:	e8 a9 0d 00 00       	call   80105030 <pushcli>
  c = mycpu();
80104287:	e8 a4 f7 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010428c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104292:	e8 e9 0d 00 00       	call   80105080 <popcli>
  myproc()->state = RUNNABLE;
80104297:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  acquire(&tickslock);
8010429e:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
801042a5:	e8 d6 0e 00 00       	call   80105180 <acquire>
  myproc()->arrival_time = ticks;
801042aa:	8b 35 80 56 11 80    	mov    0x80115680,%esi
  pushcli();
801042b0:	e8 7b 0d 00 00       	call   80105030 <pushcli>
  c = mycpu();
801042b5:	e8 76 f7 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
801042ba:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c0:	e8 bb 0d 00 00       	call   80105080 <popcli>
  myproc()->arrival_time = ticks;
801042c5:	89 b3 90 00 00 00    	mov    %esi,0x90(%ebx)
  pushcli();
801042cb:	e8 60 0d 00 00       	call   80105030 <pushcli>
  c = mycpu();
801042d0:	e8 5b f7 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
801042d5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042db:	e8 a0 0d 00 00       	call   80105080 <popcli>
  myproc()->waited_ticks = 0;
801042e0:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801042e7:	00 00 00 
  pushcli();
801042ea:	e8 41 0d 00 00       	call   80105030 <pushcli>
  c = mycpu();
801042ef:	e8 3c f7 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
801042f4:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042fa:	e8 81 0d 00 00       	call   80105080 <popcli>
  myproc()->consecutive_run = 0;
801042ff:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80104306:	00 00 00 
  release(&tickslock);
80104309:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
80104310:	e8 0b 0e 00 00       	call   80105120 <release>
  pushcli();
80104315:	e8 16 0d 00 00       	call   80105030 <pushcli>
  c = mycpu();
8010431a:	e8 11 f7 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010431f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104325:	e8 56 0d 00 00       	call   80105080 <popcli>
  if (myproc()->sched_class == 1)
8010432a:	83 c4 10             	add    $0x10,%esp
8010432d:	83 7b 7c 01          	cmpl   $0x1,0x7c(%ebx)
80104331:	75 2d                	jne    80104360 <yield+0xf0>
    count_edf++;
80104333:	83 05 5c 56 11 80 01 	addl   $0x1,0x8011565c
  sched();
8010433a:	e8 81 fd ff ff       	call   801040c0 <sched>
  release(&ptable.lock);
8010433f:	83 ec 0c             	sub    $0xc,%esp
80104342:	68 20 2d 11 80       	push   $0x80112d20
80104347:	e8 d4 0d 00 00       	call   80105120 <release>
}
8010434c:	83 c4 10             	add    $0x10,%esp
8010434f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104352:	5b                   	pop    %ebx
80104353:	5e                   	pop    %esi
80104354:	5d                   	pop    %ebp
80104355:	c3                   	ret
80104356:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010435d:	00 
8010435e:	66 90                	xchg   %ax,%ax
  pushcli();
80104360:	e8 cb 0c 00 00       	call   80105030 <pushcli>
  c = mycpu();
80104365:	e8 c6 f6 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010436a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104370:	e8 0b 0d 00 00       	call   80105080 <popcli>
  else if (myproc()->sched_class == 2 && myproc()->sched_level == 1)
80104375:	83 7b 7c 02          	cmpl   $0x2,0x7c(%ebx)
80104379:	74 45                	je     801043c0 <yield+0x150>
  pushcli();
8010437b:	e8 b0 0c 00 00       	call   80105030 <pushcli>
  c = mycpu();
80104380:	e8 ab f6 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80104385:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010438b:	e8 f0 0c 00 00       	call   80105080 <popcli>
  else if (myproc()->sched_class == 2 && myproc()->sched_level == 2)
80104390:	83 7b 7c 02          	cmpl   $0x2,0x7c(%ebx)
80104394:	75 a4                	jne    8010433a <yield+0xca>
  pushcli();
80104396:	e8 95 0c 00 00       	call   80105030 <pushcli>
  c = mycpu();
8010439b:	e8 90 f6 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
801043a0:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043a6:	e8 d5 0c 00 00       	call   80105080 <popcli>
  else if (myproc()->sched_class == 2 && myproc()->sched_level == 2)
801043ab:	83 bb 80 00 00 00 02 	cmpl   $0x2,0x80(%ebx)
801043b2:	75 86                	jne    8010433a <yield+0xca>
    count_fcfs++;
801043b4:	83 05 54 56 11 80 01 	addl   $0x1,0x80115654
801043bb:	e9 7a ff ff ff       	jmp    8010433a <yield+0xca>
  pushcli();
801043c0:	e8 6b 0c 00 00       	call   80105030 <pushcli>
  c = mycpu();
801043c5:	e8 66 f6 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
801043ca:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043d0:	e8 ab 0c 00 00       	call   80105080 <popcli>
  else if (myproc()->sched_class == 2 && myproc()->sched_level == 1)
801043d5:	83 bb 80 00 00 00 01 	cmpl   $0x1,0x80(%ebx)
801043dc:	75 9d                	jne    8010437b <yield+0x10b>
    count_rr++;
801043de:	83 05 58 56 11 80 01 	addl   $0x1,0x80115658
801043e5:	e9 50 ff ff ff       	jmp    8010433a <yield+0xca>
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <sleep>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	56                   	push   %esi
801043f5:	53                   	push   %ebx
801043f6:	83 ec 0c             	sub    $0xc,%esp
801043f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801043ff:	e8 2c 0c 00 00       	call   80105030 <pushcli>
  c = mycpu();
80104404:	e8 27 f6 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80104409:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010440f:	e8 6c 0c 00 00       	call   80105080 <popcli>
  if (p == 0)
80104414:	85 db                	test   %ebx,%ebx
80104416:	0f 84 2d 01 00 00    	je     80104549 <sleep+0x159>
  if (lk == 0)
8010441c:	85 f6                	test   %esi,%esi
8010441e:	0f 84 18 01 00 00    	je     8010453c <sleep+0x14c>
  if (lk != &ptable.lock)
80104424:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010442a:	0f 84 a0 00 00 00    	je     801044d0 <sleep+0xe0>
    acquire(&ptable.lock); // DOC: sleeplock1
80104430:	83 ec 0c             	sub    $0xc,%esp
80104433:	68 20 2d 11 80       	push   $0x80112d20
80104438:	e8 43 0d 00 00       	call   80105180 <acquire>
    release(lk);
8010443d:	89 34 24             	mov    %esi,(%esp)
80104440:	e8 db 0c 00 00       	call   80105120 <release>
  if (p->state == RUNNABLE)
80104445:	83 c4 10             	add    $0x10,%esp
80104448:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
  p->chan = chan;
8010444c:	89 7b 20             	mov    %edi,0x20(%ebx)
  if (p->state == RUNNABLE)
8010444f:	74 3f                	je     80104490 <sleep+0xa0>
  p->consecutive_run = 0;
80104451:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80104458:	00 00 00 
  p->state = SLEEPING;
8010445b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104462:	e8 59 fc ff ff       	call   801040c0 <sched>
  p->chan = 0;
80104467:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
8010446e:	83 ec 0c             	sub    $0xc,%esp
80104471:	68 20 2d 11 80       	push   $0x80112d20
80104476:	e8 a5 0c 00 00       	call   80105120 <release>
    acquire(lk);
8010447b:	83 c4 10             	add    $0x10,%esp
8010447e:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104484:	5b                   	pop    %ebx
80104485:	5e                   	pop    %esi
80104486:	5f                   	pop    %edi
80104487:	5d                   	pop    %ebp
    acquire(lk);
80104488:	e9 f3 0c 00 00       	jmp    80105180 <acquire>
8010448d:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->sched_class == 1)
80104490:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104493:	83 f8 01             	cmp    $0x1,%eax
80104496:	0f 84 84 00 00 00    	je     80104520 <sleep+0x130>
    else if (p->sched_class == 2 && p->sched_level == 1)
8010449c:	83 f8 02             	cmp    $0x2,%eax
8010449f:	74 5f                	je     80104500 <sleep+0x110>
  p->consecutive_run = 0;
801044a1:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801044a8:	00 00 00 
  p->state = SLEEPING;
801044ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044b2:	e8 09 fc ff ff       	call   801040c0 <sched>
  p->chan = 0;
801044b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if (lk != &ptable.lock)
801044be:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801044c4:	75 a8                	jne    8010446e <sleep+0x7e>
}
801044c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044c9:	5b                   	pop    %ebx
801044ca:	5e                   	pop    %esi
801044cb:	5f                   	pop    %edi
801044cc:	5d                   	pop    %ebp
801044cd:	c3                   	ret
801044ce:	66 90                	xchg   %ax,%ax
  if (p->state == RUNNABLE)
801044d0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
  p->chan = chan;
801044d4:	89 7b 20             	mov    %edi,0x20(%ebx)
  if (p->state == RUNNABLE)
801044d7:	74 b7                	je     80104490 <sleep+0xa0>
  p->consecutive_run = 0;
801044d9:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801044e0:	00 00 00 
  p->state = SLEEPING;
801044e3:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044ea:	e8 d1 fb ff ff       	call   801040c0 <sched>
  p->chan = 0;
801044ef:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801044f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044f9:	5b                   	pop    %ebx
801044fa:	5e                   	pop    %esi
801044fb:	5f                   	pop    %edi
801044fc:	5d                   	pop    %ebp
801044fd:	c3                   	ret
801044fe:	66 90                	xchg   %ax,%ax
    else if (p->sched_class == 2 && p->sched_level == 1)
80104500:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104506:	83 f8 01             	cmp    $0x1,%eax
80104509:	74 25                	je     80104530 <sleep+0x140>
    else if (p->sched_class == 2 && p->sched_level == 2)
8010450b:	83 f8 02             	cmp    $0x2,%eax
8010450e:	75 91                	jne    801044a1 <sleep+0xb1>
      count_fcfs--;
80104510:	83 2d 54 56 11 80 01 	subl   $0x1,0x80115654
80104517:	eb 88                	jmp    801044a1 <sleep+0xb1>
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      count_edf--;
80104520:	83 2d 5c 56 11 80 01 	subl   $0x1,0x8011565c
80104527:	e9 75 ff ff ff       	jmp    801044a1 <sleep+0xb1>
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      count_rr--;
80104530:	83 2d 58 56 11 80 01 	subl   $0x1,0x80115658
80104537:	e9 65 ff ff ff       	jmp    801044a1 <sleep+0xb1>
    panic("sleep without lk");
8010453c:	83 ec 0c             	sub    $0xc,%esp
8010453f:	68 10 83 10 80       	push   $0x80108310
80104544:	e8 37 be ff ff       	call   80100380 <panic>
    panic("sleep");
80104549:	83 ec 0c             	sub    $0xc,%esp
8010454c:	68 0a 83 10 80       	push   $0x8010830a
80104551:	e8 2a be ff ff       	call   80100380 <panic>
80104556:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010455d:	00 
8010455e:	66 90                	xchg   %ax,%ax

80104560 <wait>:
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
  pushcli();
80104565:	e8 c6 0a 00 00       	call   80105030 <pushcli>
  c = mycpu();
8010456a:	e8 c1 f4 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010456f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104575:	e8 06 0b 00 00       	call   80105080 <popcli>
  acquire(&ptable.lock);
8010457a:	83 ec 0c             	sub    $0xc,%esp
8010457d:	68 20 2d 11 80       	push   $0x80112d20
80104582:	e8 f9 0b 00 00       	call   80105180 <acquire>
80104587:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010458a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010458c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104591:	eb 13                	jmp    801045a6 <wait+0x46>
80104593:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104598:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
8010459e:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
801045a4:	74 1e                	je     801045c4 <wait+0x64>
      if (p->parent != curproc)
801045a6:	39 73 14             	cmp    %esi,0x14(%ebx)
801045a9:	75 ed                	jne    80104598 <wait+0x38>
      if (p->state == ZOMBIE)
801045ab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801045af:	74 37                	je     801045e8 <wait+0x88>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045b1:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
      havekids = 1;
801045b7:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045bc:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
801045c2:	75 e2                	jne    801045a6 <wait+0x46>
    if (!havekids || curproc->killed)
801045c4:	85 c0                	test   %eax,%eax
801045c6:	74 76                	je     8010463e <wait+0xde>
801045c8:	8b 46 24             	mov    0x24(%esi),%eax
801045cb:	85 c0                	test   %eax,%eax
801045cd:	75 6f                	jne    8010463e <wait+0xde>
    sleep(curproc, &ptable.lock); // DOC: wait-sleep
801045cf:	83 ec 08             	sub    $0x8,%esp
801045d2:	68 20 2d 11 80       	push   $0x80112d20
801045d7:	56                   	push   %esi
801045d8:	e8 13 fe ff ff       	call   801043f0 <sleep>
    havekids = 0;
801045dd:	83 c4 10             	add    $0x10,%esp
801045e0:	eb a8                	jmp    8010458a <wait+0x2a>
801045e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801045e8:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801045eb:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801045ee:	ff 73 08             	push   0x8(%ebx)
801045f1:	e8 da de ff ff       	call   801024d0 <kfree>
        p->kstack = 0;
801045f6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045fd:	5a                   	pop    %edx
801045fe:	ff 73 04             	push   0x4(%ebx)
80104601:	e8 5a 36 00 00       	call   80107c60 <freevm>
        p->pid = 0;
80104606:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010460d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104614:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104618:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010461f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104626:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010462d:	e8 ee 0a 00 00       	call   80105120 <release>
        return pid;
80104632:	83 c4 10             	add    $0x10,%esp
}
80104635:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104638:	89 f0                	mov    %esi,%eax
8010463a:	5b                   	pop    %ebx
8010463b:	5e                   	pop    %esi
8010463c:	5d                   	pop    %ebp
8010463d:	c3                   	ret
      release(&ptable.lock);
8010463e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104641:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104646:	68 20 2d 11 80       	push   $0x80112d20
8010464b:	e8 d0 0a 00 00       	call   80105120 <release>
      return -1;
80104650:	83 c4 10             	add    $0x10,%esp
80104653:	eb e0                	jmp    80104635 <wait+0xd5>
80104655:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010465c:	00 
8010465d:	8d 76 00             	lea    0x0(%esi),%esi

80104660 <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 10             	sub    $0x10,%esp
80104667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010466a:	68 20 2d 11 80       	push   $0x80112d20
8010466f:	e8 0c 0b 00 00       	call   80105180 <acquire>
  wakeup1(chan);
80104674:	89 d8                	mov    %ebx,%eax
80104676:	e8 55 f1 ff ff       	call   801037d0 <wakeup1>
  release(&ptable.lock);
8010467b:	83 c4 10             	add    $0x10,%esp
}
8010467e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
80104681:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104688:	c9                   	leave
  release(&ptable.lock);
80104689:	e9 92 0a 00 00       	jmp    80105120 <release>
8010468e:	66 90                	xchg   %ax,%ax

80104690 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;

  acquire(&ptable.lock);
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104698:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
8010469d:	83 ec 0c             	sub    $0xc,%esp
801046a0:	68 20 2d 11 80       	push   $0x80112d20
801046a5:	e8 d6 0a 00 00       	call   80105180 <acquire>
801046aa:	83 c4 10             	add    $0x10,%esp
801046ad:	eb 0f                	jmp    801046be <kill+0x2e>
801046af:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046b0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801046b6:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
801046bc:	74 32                	je     801046f0 <kill+0x60>
  {
    if (p->pid == pid)
801046be:	39 73 10             	cmp    %esi,0x10(%ebx)
801046c1:	75 ed                	jne    801046b0 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
801046c3:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
      p->killed = 1;
801046c7:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      if (p->state == SLEEPING)
801046ce:	74 40                	je     80104710 <kill+0x80>
        else if (p->sched_class == 2 && p->sched_level == 1)
          count_rr++;
        else if (p->sched_class == 2 && p->sched_level == 2)
          count_fcfs++;
      }
      release(&ptable.lock);
801046d0:	83 ec 0c             	sub    $0xc,%esp
801046d3:	68 20 2d 11 80       	push   $0x80112d20
801046d8:	e8 43 0a 00 00       	call   80105120 <release>
      return 0;
801046dd:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
801046e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 0;
801046e3:	31 c0                	xor    %eax,%eax
}
801046e5:	5b                   	pop    %ebx
801046e6:	5e                   	pop    %esi
801046e7:	5d                   	pop    %ebp
801046e8:	c3                   	ret
801046e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801046f0:	83 ec 0c             	sub    $0xc,%esp
801046f3:	68 20 2d 11 80       	push   $0x80112d20
801046f8:	e8 23 0a 00 00       	call   80105120 <release>
  return -1;
801046fd:	83 c4 10             	add    $0x10,%esp
}
80104700:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
80104703:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104708:	5b                   	pop    %ebx
80104709:	5e                   	pop    %esi
8010470a:	5d                   	pop    %ebp
8010470b:	c3                   	ret
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        acquire(&tickslock);
80104710:	83 ec 0c             	sub    $0xc,%esp
        p->state = RUNNABLE;
80104713:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
        acquire(&tickslock);
8010471a:	68 a0 56 11 80       	push   $0x801156a0
8010471f:	e8 5c 0a 00 00       	call   80105180 <acquire>
        p->arrival_time = ticks;
80104724:	a1 80 56 11 80       	mov    0x80115680,%eax
        p->waited_ticks = 0;
80104729:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80104730:	00 00 00 
        p->arrival_time = ticks;
80104733:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
        release(&tickslock);
80104739:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
80104740:	e8 db 09 00 00       	call   80105120 <release>
        if (p->sched_class == 1)
80104745:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104748:	83 c4 10             	add    $0x10,%esp
8010474b:	83 f8 01             	cmp    $0x1,%eax
8010474e:	74 29                	je     80104779 <kill+0xe9>
        else if (p->sched_class == 2 && p->sched_level == 1)
80104750:	83 f8 02             	cmp    $0x2,%eax
80104753:	0f 85 77 ff ff ff    	jne    801046d0 <kill+0x40>
80104759:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010475f:	83 f8 01             	cmp    $0x1,%eax
80104762:	74 21                	je     80104785 <kill+0xf5>
        else if (p->sched_class == 2 && p->sched_level == 2)
80104764:	83 f8 02             	cmp    $0x2,%eax
80104767:	0f 85 63 ff ff ff    	jne    801046d0 <kill+0x40>
          count_fcfs++;
8010476d:	83 05 54 56 11 80 01 	addl   $0x1,0x80115654
80104774:	e9 57 ff ff ff       	jmp    801046d0 <kill+0x40>
          count_edf++;
80104779:	83 05 5c 56 11 80 01 	addl   $0x1,0x8011565c
80104780:	e9 4b ff ff ff       	jmp    801046d0 <kill+0x40>
          count_rr++;
80104785:	83 05 58 56 11 80 01 	addl   $0x1,0x80115658
8010478c:	e9 3f ff ff ff       	jmp    801046d0 <kill+0x40>
80104791:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104798:	00 
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047a0 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	56                   	push   %esi
801047a5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801047a8:	53                   	push   %ebx
801047a9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801047ae:	83 ec 3c             	sub    $0x3c,%esp
801047b1:	eb 27                	jmp    801047da <procdump+0x3a>
801047b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801047b8:	83 ec 0c             	sub    $0xc,%esp
801047bb:	68 57 83 10 80       	push   $0x80108357
801047c0:	e8 eb be ff ff       	call   801006b0 <cprintf>
801047c5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047c8:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801047ce:	81 fb c0 56 11 80    	cmp    $0x801156c0,%ebx
801047d4:	0f 84 7e 00 00 00    	je     80104858 <procdump+0xb8>
    if (p->state == UNUSED)
801047da:	8b 43 a0             	mov    -0x60(%ebx),%eax
801047dd:	85 c0                	test   %eax,%eax
801047df:	74 e7                	je     801047c8 <procdump+0x28>
      state = "???";
801047e1:	ba 21 83 10 80       	mov    $0x80108321,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047e6:	83 f8 05             	cmp    $0x5,%eax
801047e9:	77 11                	ja     801047fc <procdump+0x5c>
801047eb:	8b 14 85 38 8b 10 80 	mov    -0x7fef74c8(,%eax,4),%edx
      state = "???";
801047f2:	b8 21 83 10 80       	mov    $0x80108321,%eax
801047f7:	85 d2                	test   %edx,%edx
801047f9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801047fc:	53                   	push   %ebx
801047fd:	52                   	push   %edx
801047fe:	ff 73 a4             	push   -0x5c(%ebx)
80104801:	68 25 83 10 80       	push   $0x80108325
80104806:	e8 a5 be ff ff       	call   801006b0 <cprintf>
    if (p->state == SLEEPING)
8010480b:	83 c4 10             	add    $0x10,%esp
8010480e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104812:	75 a4                	jne    801047b8 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104814:	83 ec 08             	sub    $0x8,%esp
80104817:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010481a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010481d:	50                   	push   %eax
8010481e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104821:	8b 40 0c             	mov    0xc(%eax),%eax
80104824:	83 c0 08             	add    $0x8,%eax
80104827:	50                   	push   %eax
80104828:	e8 83 07 00 00       	call   80104fb0 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
8010482d:	83 c4 10             	add    $0x10,%esp
80104830:	8b 17                	mov    (%edi),%edx
80104832:	85 d2                	test   %edx,%edx
80104834:	74 82                	je     801047b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104836:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104839:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010483c:	52                   	push   %edx
8010483d:	68 61 80 10 80       	push   $0x80108061
80104842:	e8 69 be ff ff       	call   801006b0 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104847:	83 c4 10             	add    $0x10,%esp
8010484a:	39 f7                	cmp    %esi,%edi
8010484c:	75 e2                	jne    80104830 <procdump+0x90>
8010484e:	e9 65 ff ff ff       	jmp    801047b8 <procdump+0x18>
80104853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104858:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010485b:	5b                   	pop    %ebx
8010485c:	5e                   	pop    %esi
8010485d:	5f                   	pop    %edi
8010485e:	5d                   	pop    %ebp
8010485f:	c3                   	ret

80104860 <set_process_deadline>:
//////////////////////////////////my process

int set_process_deadline(int deadline)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	8b 75 08             	mov    0x8(%ebp),%esi
80104867:	53                   	push   %ebx
  if (deadline <= 0)
80104868:	85 f6                	test   %esi,%esi
8010486a:	7e 34                	jle    801048a0 <set_process_deadline+0x40>
  pushcli();
8010486c:	e8 bf 07 00 00       	call   80105030 <pushcli>
  c = mycpu();
80104871:	e8 ba f1 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80104876:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010487c:	e8 ff 07 00 00       	call   80105080 <popcli>
  struct proc *curproc = myproc();
  curproc->sched_class = 1; // EDF
  curproc->sched_level = 0; // Unused for EDF
  curproc->deadline = deadline;

  return 0;
80104881:	31 c0                	xor    %eax,%eax
  curproc->sched_class = 1; // EDF
80104883:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  curproc->sched_level = 0; // Unused for EDF
8010488a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104891:	00 00 00 
  curproc->deadline = deadline;
80104894:	89 b3 84 00 00 00    	mov    %esi,0x84(%ebx)
}
8010489a:	5b                   	pop    %ebx
8010489b:	5e                   	pop    %esi
8010489c:	5d                   	pop    %ebp
8010489d:	c3                   	ret
8010489e:	66 90                	xchg   %ax,%ax
    return -1;
801048a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048a5:	eb f3                	jmp    8010489a <set_process_deadline+0x3a>
801048a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ae:	00 
801048af:	90                   	nop

801048b0 <set_deadline_for_process>:

int set_deadline_for_process(int pid, int deadline)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 75 0c             	mov    0xc(%ebp),%esi
801048b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (deadline < 0)
801048bb:	85 f6                	test   %esi,%esi
801048bd:	0f 88 cc 00 00 00    	js     8010498f <set_deadline_for_process+0xdf>
  {
    cprintf("Invalid deadline!");
    return -1;
  }

  acquire(&ptable.lock);
801048c3:	83 ec 0c             	sub    $0xc,%esp
801048c6:	68 20 2d 11 80       	push   $0x80112d20
801048cb:	e8 b0 08 00 00       	call   80105180 <acquire>
801048d0:	83 c4 10             	add    $0x10,%esp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048d3:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801048d8:	eb 12                	jmp    801048ec <set_deadline_for_process+0x3c>
801048da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048e0:	05 a4 00 00 00       	add    $0xa4,%eax
801048e5:	3d 54 56 11 80       	cmp    $0x80115654,%eax
801048ea:	74 74                	je     80104960 <set_deadline_for_process+0xb0>
  {
    if (p->pid == pid)
801048ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801048ef:	75 ef                	jne    801048e0 <set_deadline_for_process+0x30>
    {
      if (p->state == RUNNABLE)
801048f1:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801048f5:	74 41                	je     80104938 <set_deadline_for_process+0x88>
        }
      }
      p->sched_level = 0;
      p->sched_class = 1;
      p->deadline = deadline;
      cprintf("PID %d : Deadline = %d \n", pid, p->deadline);
801048f7:	83 ec 04             	sub    $0x4,%esp
      p->deadline = deadline;
801048fa:	89 b0 84 00 00 00    	mov    %esi,0x84(%eax)
      p->sched_level = 0;
80104900:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104907:	00 00 00 
      p->sched_class = 1;
8010490a:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
      cprintf("PID %d : Deadline = %d \n", pid, p->deadline);
80104911:	56                   	push   %esi
80104912:	53                   	push   %ebx
80104913:	68 40 83 10 80       	push   $0x80108340
80104918:	e8 93 bd ff ff       	call   801006b0 <cprintf>

      release(&ptable.lock);
8010491d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104924:	e8 f7 07 00 00       	call   80105120 <release>
      return 0;
80104929:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return -1;
}
8010492c:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 0;
8010492f:	31 c0                	xor    %eax,%eax
}
80104931:	5b                   	pop    %ebx
80104932:	5e                   	pop    %esi
80104933:	5d                   	pop    %ebp
80104934:	c3                   	ret
80104935:	8d 76 00             	lea    0x0(%esi),%esi
        if (p->sched_level == 1)
80104938:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010493e:	83 fa 01             	cmp    $0x1,%edx
80104941:	74 39                	je     8010497c <set_deadline_for_process+0xcc>
        else if (p->sched_level == 2)
80104943:	83 fa 02             	cmp    $0x2,%edx
80104946:	75 af                	jne    801048f7 <set_deadline_for_process+0x47>
          count_fcfs--;
80104948:	83 2d 54 56 11 80 01 	subl   $0x1,0x80115654
          count_edf++;
8010494f:	83 05 5c 56 11 80 01 	addl   $0x1,0x8011565c
80104956:	eb 9f                	jmp    801048f7 <set_deadline_for_process+0x47>
80104958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010495f:	00 
  release(&ptable.lock);
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	68 20 2d 11 80       	push   $0x80112d20
80104968:	e8 b3 07 00 00       	call   80105120 <release>
  return -1;
8010496d:	83 c4 10             	add    $0x10,%esp
}
80104970:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104978:	5b                   	pop    %ebx
80104979:	5e                   	pop    %esi
8010497a:	5d                   	pop    %ebp
8010497b:	c3                   	ret
          count_rr--;
8010497c:	83 2d 58 56 11 80 01 	subl   $0x1,0x80115658
          count_edf++;
80104983:	83 05 5c 56 11 80 01 	addl   $0x1,0x8011565c
8010498a:	e9 68 ff ff ff       	jmp    801048f7 <set_deadline_for_process+0x47>
    cprintf("Invalid deadline!");
8010498f:	83 ec 0c             	sub    $0xc,%esp
80104992:	68 2e 83 10 80       	push   $0x8010832e
80104997:	e8 14 bd ff ff       	call   801006b0 <cprintf>
    return -1;
8010499c:	83 c4 10             	add    $0x10,%esp
8010499f:	eb cf                	jmp    80104970 <set_deadline_for_process+0xc0>
801049a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049a8:	00 
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049b0 <change_sched_level>:

int change_sched_level(int pid, int target_level)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	56                   	push   %esi
801049b5:	53                   	push   %ebx
801049b6:	83 ec 0c             	sub    $0xc,%esp
801049b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049bc:	8b 75 08             	mov    0x8(%ebp),%esi
  if (target_level != 1 && target_level != 2)
801049bf:	8d 47 ff             	lea    -0x1(%edi),%eax
801049c2:	83 f8 01             	cmp    $0x1,%eax
801049c5:	0f 87 dc 00 00 00    	ja     80104aa7 <change_sched_level+0xf7>
  {
    cprintf("Invalid target level!");
    return -1;
  }

  acquire(&ptable.lock);
801049cb:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049ce:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
801049d3:	68 20 2d 11 80       	push   $0x80112d20
801049d8:	e8 a3 07 00 00       	call   80105180 <acquire>
801049dd:	83 c4 10             	add    $0x10,%esp
801049e0:	eb 18                	jmp    801049fa <change_sched_level+0x4a>
801049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049e8:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801049ee:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
801049f4:	0f 84 7e 00 00 00    	je     80104a78 <change_sched_level+0xc8>
  {
    if (p->pid == pid)
801049fa:	39 73 10             	cmp    %esi,0x10(%ebx)
801049fd:	75 e9                	jne    801049e8 <change_sched_level+0x38>
    {
      if (p->sched_level == target_level)
801049ff:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104a05:	39 f8                	cmp    %edi,%eax
80104a07:	0f 84 ac 00 00 00    	je     80104ab9 <change_sched_level+0x109>
      {
        cprintf("Process is already in target level!");
        return -1;
      }
      if (p->state == RUNNABLE)
80104a0d:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104a11:	74 3d                	je     80104a50 <change_sched_level+0xa0>
        {
          count_fcfs--;
          count_rr++;
        }
      }
      cprintf("PID %d : Level %d to %d\n", pid, p->sched_level, target_level);
80104a13:	57                   	push   %edi
80104a14:	50                   	push   %eax
80104a15:	56                   	push   %esi
80104a16:	68 6f 83 10 80       	push   $0x8010836f
80104a1b:	e8 90 bc ff ff       	call   801006b0 <cprintf>
      p->sched_level = (target_level == 2) ? 2 : 1;
80104a20:	31 c0                	xor    %eax,%eax
80104a22:	83 ff 02             	cmp    $0x2,%edi
80104a25:	0f 94 c0             	sete   %al
80104a28:	89 c7                	mov    %eax,%edi
80104a2a:	83 c7 01             	add    $0x1,%edi
80104a2d:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
      release(&ptable.lock);
80104a33:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104a3a:	e8 e1 06 00 00       	call   80105120 <release>
      return 0;
80104a3f:	83 c4 10             	add    $0x10,%esp
80104a42:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104a44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a47:	5b                   	pop    %ebx
80104a48:	5e                   	pop    %esi
80104a49:	5f                   	pop    %edi
80104a4a:	5d                   	pop    %ebp
80104a4b:	c3                   	ret
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          count_fcfs++;
80104a50:	8b 0d 54 56 11 80    	mov    0x80115654,%ecx
          count_rr--;
80104a56:	8b 15 58 56 11 80    	mov    0x80115658,%edx
        if (p->sched_level == 1)
80104a5c:	83 f8 01             	cmp    $0x1,%eax
80104a5f:	74 2f                	je     80104a90 <change_sched_level+0xe0>
          count_fcfs--;
80104a61:	83 e9 01             	sub    $0x1,%ecx
          count_rr++;
80104a64:	83 c2 01             	add    $0x1,%edx
          count_fcfs--;
80104a67:	89 0d 54 56 11 80    	mov    %ecx,0x80115654
          count_rr++;
80104a6d:	89 15 58 56 11 80    	mov    %edx,0x80115658
80104a73:	eb 9e                	jmp    80104a13 <change_sched_level+0x63>
80104a75:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104a78:	83 ec 0c             	sub    $0xc,%esp
80104a7b:	68 20 2d 11 80       	push   $0x80112d20
80104a80:	e8 9b 06 00 00       	call   80105120 <release>
  return -1;
80104a85:	83 c4 10             	add    $0x10,%esp
    return -1;
80104a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a8d:	eb b5                	jmp    80104a44 <change_sched_level+0x94>
80104a8f:	90                   	nop
          count_rr--;
80104a90:	83 ea 01             	sub    $0x1,%edx
          count_fcfs++;
80104a93:	83 c1 01             	add    $0x1,%ecx
          count_rr--;
80104a96:	89 15 58 56 11 80    	mov    %edx,0x80115658
          count_fcfs++;
80104a9c:	89 0d 54 56 11 80    	mov    %ecx,0x80115654
80104aa2:	e9 6c ff ff ff       	jmp    80104a13 <change_sched_level+0x63>
    cprintf("Invalid target level!");
80104aa7:	83 ec 0c             	sub    $0xc,%esp
80104aaa:	68 59 83 10 80       	push   $0x80108359
80104aaf:	e8 fc bb ff ff       	call   801006b0 <cprintf>
    return -1;
80104ab4:	83 c4 10             	add    $0x10,%esp
80104ab7:	eb cf                	jmp    80104a88 <change_sched_level+0xd8>
        cprintf("Process is already in target level!");
80104ab9:	83 ec 0c             	sub    $0xc,%esp
80104abc:	68 b0 86 10 80       	push   $0x801086b0
80104ac1:	e8 ea bb ff ff       	call   801006b0 <cprintf>
        return -1;
80104ac6:	83 c4 10             	add    $0x10,%esp
80104ac9:	eb bd                	jmp    80104a88 <change_sched_level+0xd8>
80104acb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104ad0 <update_wait_time>:

int update_wait_time(int osTicks)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&ptable.lock);
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ad8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
80104add:	83 ec 0c             	sub    $0xc,%esp
80104ae0:	68 20 2d 11 80       	push   $0x80112d20
80104ae5:	e8 96 06 00 00       	call   80105180 <acquire>
80104aea:	83 c4 10             	add    $0x10,%esp
80104aed:	eb 0f                	jmp    80104afe <update_wait_time+0x2e>
80104aef:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104af0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80104af6:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
80104afc:	74 66                	je     80104b64 <update_wait_time+0x94>
  {
    if (p->state == RUNNABLE)
80104afe:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104b02:	75 ec                	jne    80104af0 <update_wait_time+0x20>
    {
      p->waited_ticks = osTicks - p->arrival_time;
80104b04:	89 f0                	mov    %esi,%eax
80104b06:	2b 83 90 00 00 00    	sub    0x90(%ebx),%eax
      if (p->sched_class == 2 && p->sched_level == 2)
80104b0c:	83 7b 7c 02          	cmpl   $0x2,0x7c(%ebx)
      p->waited_ticks = osTicks - p->arrival_time;
80104b10:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
      if (p->sched_class == 2 && p->sched_level == 2)
80104b16:	75 d8                	jne    80104af0 <update_wait_time+0x20>
      {
        if (p->waited_ticks >= AGING_THRESHOLD)
80104b18:	83 bb 80 00 00 00 02 	cmpl   $0x2,0x80(%ebx)
80104b1f:	75 cf                	jne    80104af0 <update_wait_time+0x20>
80104b21:	3d 1f 03 00 00       	cmp    $0x31f,%eax
80104b26:	7e c8                	jle    80104af0 <update_wait_time+0x20>
        {
          release(&ptable.lock);
80104b28:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b2b:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
          release(&ptable.lock);
80104b31:	68 20 2d 11 80       	push   $0x80112d20
80104b36:	e8 e5 05 00 00       	call   80105120 <release>
          change_sched_level(p->pid, 1);
80104b3b:	58                   	pop    %eax
80104b3c:	5a                   	pop    %edx
80104b3d:	6a 01                	push   $0x1
80104b3f:	ff b3 6c ff ff ff    	push   -0x94(%ebx)
80104b45:	e8 66 fe ff ff       	call   801049b0 <change_sched_level>
          acquire(&ptable.lock);
80104b4a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104b51:	e8 2a 06 00 00       	call   80105180 <acquire>
          p->arrival_time = osTicks;
80104b56:	89 73 ec             	mov    %esi,-0x14(%ebx)
80104b59:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b5c:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
80104b62:	75 9a                	jne    80104afe <update_wait_time+0x2e>
      }
    }//else if(p->state == RUNNING){

    // }
  }
  release(&ptable.lock);
80104b64:	83 ec 0c             	sub    $0xc,%esp
80104b67:	68 20 2d 11 80       	push   $0x80112d20
80104b6c:	e8 af 05 00 00       	call   80105120 <release>
  return 0;
}
80104b71:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b74:	31 c0                	xor    %eax,%eax
80104b76:	5b                   	pop    %ebx
80104b77:	5e                   	pop    %esi
80104b78:	5d                   	pop    %ebp
80104b79:	c3                   	ret
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b80 <is_higher_waiting>:
//   release(&ptable.lock);
//   return 0;
// }
int is_higher_waiting(void)
{
  if (count_edf > 0 || count_rr > 0)
80104b80:	8b 0d 5c 56 11 80    	mov    0x8011565c,%ecx
80104b86:	85 c9                	test   %ecx,%ecx
80104b88:	7f 16                	jg     80104ba0 <is_higher_waiting+0x20>
80104b8a:	8b 15 58 56 11 80    	mov    0x80115658,%edx
  {
    yield();
    return 1;
  }
  return 0;
80104b90:	31 c0                	xor    %eax,%eax
  if (count_edf > 0 || count_rr > 0)
80104b92:	85 d2                	test   %edx,%edx
80104b94:	7f 0a                	jg     80104ba0 <is_higher_waiting+0x20>
}
80104b96:	c3                   	ret
80104b97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b9e:	00 
80104b9f:	90                   	nop
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	83 ec 08             	sub    $0x8,%esp
    yield();
80104ba6:	e8 c5 f6 ff ff       	call   80104270 <yield>
    return 1;
80104bab:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104bb0:	c9                   	leave
80104bb1:	c3                   	ret
80104bb2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bb9:	00 
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bc0 <print_sched_info>:

//   release(&ptable.lock);
// }

int print_sched_info(void)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	bf c0 2d 11 80       	mov    $0x80112dc0,%edi
80104bc9:	56                   	push   %esi
80104bca:	53                   	push   %ebx
80104bcb:	83 ec 28             	sub    $0x28,%esp
      [EMBRYO] "EMBRYO",
      [SLEEPING] "SLEEPING",
      [RUNNABLE] "RUNNABLE",
      [RUNNING] "RUNNING",
      [ZOMBIE] "ZOMBIE"};
  acquire(&tickslock);
80104bce:	68 a0 56 11 80       	push   $0x801156a0
80104bd3:	e8 a8 05 00 00       	call   80105180 <acquire>
  cprintf("-----------------------\n"
80104bd8:	5b                   	pop    %ebx
80104bd9:	5e                   	pop    %esi
80104bda:	ff 35 80 56 11 80    	push   0x80115680
80104be0:	68 d4 86 10 80       	push   $0x801086d4
80104be5:	e8 c6 ba ff ff       	call   801006b0 <cprintf>
          "Tick: %d \n" , ticks);
  release(&tickslock);
80104bea:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
80104bf1:	e8 2a 05 00 00       	call   80105120 <release>
  static int columns[] = {16, 8, 12, 12, 12, 12, 12, 17, 9, 10, 13};
  cprintf("-------------------------------------------------------------------------------------------------------------------------------------\n"
80104bf6:	c7 04 24 f8 86 10 80 	movl   $0x801086f8,(%esp)
80104bfd:	e8 ae ba ff ff       	call   801006b0 <cprintf>
          "Process_Name    PID     State       Class       Algorithm   Wait_time   Deadline    Consecutive_run  Arrival  RR_time   Running_Time \n");

  struct proc *p;
  acquire(&ptable.lock);
80104c02:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104c09:	e8 72 05 00 00       	call   80105180 <acquire>

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c0e:	83 c4 10             	add    $0x10,%esp
80104c11:	e9 ed 01 00 00       	jmp    80104e03 <print_sched_info+0x243>
80104c16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c1d:	00 
80104c1e:	66 90                	xchg   %ax,%ax

    char *algorithm = "FCFS";
    if (p->sched_class == 1)
      algorithm = "EDF";
    else if (p->sched_level == 1)
      algorithm = "RR";
80104c20:	83 7f 14 01          	cmpl   $0x1,0x14(%edi)
80104c24:	ba 88 83 10 80       	mov    $0x80108388,%edx
80104c29:	b8 a2 83 10 80       	mov    $0x801083a2,%eax
80104c2e:	be 8d 83 10 80       	mov    $0x8010838d,%esi
80104c33:	0f 45 c2             	cmovne %edx,%eax
80104c36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    char *class = "Normal";
    if (p->sched_class == 1)
      class = "Real-Time";

    // Print Name
    cprintf("%s", p->name);
80104c39:	83 ec 08             	sub    $0x8,%esp
80104c3c:	57                   	push   %edi
80104c3d:	68 2b 83 10 80       	push   $0x8010832b
80104c42:	e8 69 ba ff ff       	call   801006b0 <cprintf>
    printspaces(columns[0] - strlen(p->name));
80104c47:	89 3c 24             	mov    %edi,(%esp)
80104c4a:	e8 21 08 00 00       	call   80105470 <strlen>
80104c4f:	89 c2                	mov    %eax,%edx
80104c51:	b8 10 00 00 00       	mov    $0x10,%eax
80104c56:	29 d0                	sub    %edx,%eax
80104c58:	89 04 24             	mov    %eax,(%esp)
80104c5b:	e8 60 1f 00 00       	call   80106bc0 <printspaces>
    // Print PID
    cprintf("%d", p->pid);
80104c60:	58                   	pop    %eax
80104c61:	5a                   	pop    %edx
80104c62:	ff 77 a4             	push   -0x5c(%edi)
80104c65:	68 a5 83 10 80       	push   $0x801083a5
80104c6a:	e8 41 ba ff ff       	call   801006b0 <cprintf>
    printspaces(columns[1] - digitcount(p->pid));
80104c6f:	59                   	pop    %ecx
80104c70:	ff 77 a4             	push   -0x5c(%edi)
80104c73:	e8 08 1f 00 00       	call   80106b80 <digitcount>
80104c78:	89 c2                	mov    %eax,%edx
80104c7a:	b8 08 00 00 00       	mov    $0x8,%eax
80104c7f:	29 d0                	sub    %edx,%eax
80104c81:	89 04 24             	mov    %eax,(%esp)
80104c84:	e8 37 1f 00 00       	call   80106bc0 <printspaces>
    // Print State
    cprintf("%s", state);
80104c89:	58                   	pop    %eax
80104c8a:	5a                   	pop    %edx
80104c8b:	53                   	push   %ebx
80104c8c:	68 2b 83 10 80       	push   $0x8010832b
80104c91:	e8 1a ba ff ff       	call   801006b0 <cprintf>
    printspaces(columns[2] - strlen(state));
80104c96:	89 1c 24             	mov    %ebx,(%esp)
80104c99:	bb 0c 00 00 00       	mov    $0xc,%ebx
80104c9e:	e8 cd 07 00 00       	call   80105470 <strlen>
80104ca3:	89 c2                	mov    %eax,%edx
80104ca5:	89 d8                	mov    %ebx,%eax
80104ca7:	29 d0                	sub    %edx,%eax
80104ca9:	89 04 24             	mov    %eax,(%esp)
80104cac:	e8 0f 1f 00 00       	call   80106bc0 <printspaces>
    // Print Class
    cprintf("%s", class);
80104cb1:	59                   	pop    %ecx
80104cb2:	58                   	pop    %eax
80104cb3:	56                   	push   %esi
80104cb4:	68 2b 83 10 80       	push   $0x8010832b
80104cb9:	e8 f2 b9 ff ff       	call   801006b0 <cprintf>
    printspaces(columns[3] - strlen(class));
80104cbe:	89 34 24             	mov    %esi,(%esp)
80104cc1:	e8 aa 07 00 00       	call   80105470 <strlen>
80104cc6:	89 c2                	mov    %eax,%edx
80104cc8:	89 d8                	mov    %ebx,%eax
80104cca:	29 d0                	sub    %edx,%eax
80104ccc:	89 04 24             	mov    %eax,(%esp)
80104ccf:	e8 ec 1e 00 00       	call   80106bc0 <printspaces>
    // Print Algorithm
    cprintf("%s", algorithm);
80104cd4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104cd7:	58                   	pop    %eax
80104cd8:	5a                   	pop    %edx
80104cd9:	56                   	push   %esi
80104cda:	68 2b 83 10 80       	push   $0x8010832b
80104cdf:	e8 cc b9 ff ff       	call   801006b0 <cprintf>
    printspaces(columns[4] - strlen(algorithm));
80104ce4:	89 34 24             	mov    %esi,(%esp)
80104ce7:	e8 84 07 00 00       	call   80105470 <strlen>
80104cec:	89 c2                	mov    %eax,%edx
80104cee:	89 d8                	mov    %ebx,%eax
80104cf0:	29 d0                	sub    %edx,%eax
80104cf2:	89 04 24             	mov    %eax,(%esp)
80104cf5:	e8 c6 1e 00 00       	call   80106bc0 <printspaces>
    // Print Wait time
    cprintf("%d", p->waited_ticks);
80104cfa:	59                   	pop    %ecx
80104cfb:	5e                   	pop    %esi
80104cfc:	ff 77 28             	push   0x28(%edi)
80104cff:	68 a5 83 10 80       	push   $0x801083a5
80104d04:	e8 a7 b9 ff ff       	call   801006b0 <cprintf>
    printspaces(columns[5] - digitcount(p->waited_ticks));
80104d09:	58                   	pop    %eax
80104d0a:	ff 77 28             	push   0x28(%edi)
80104d0d:	e8 6e 1e 00 00       	call   80106b80 <digitcount>
80104d12:	89 c2                	mov    %eax,%edx
80104d14:	89 d8                	mov    %ebx,%eax
80104d16:	29 d0                	sub    %edx,%eax
80104d18:	89 04 24             	mov    %eax,(%esp)
80104d1b:	e8 a0 1e 00 00       	call   80106bc0 <printspaces>
    // Print Deadline
    cprintf("%d", p->deadline);
80104d20:	58                   	pop    %eax
80104d21:	5a                   	pop    %edx
80104d22:	ff 77 18             	push   0x18(%edi)
80104d25:	68 a5 83 10 80       	push   $0x801083a5
80104d2a:	e8 81 b9 ff ff       	call   801006b0 <cprintf>
    printspaces(columns[6] - digitcount(p->deadline));
80104d2f:	59                   	pop    %ecx
80104d30:	ff 77 18             	push   0x18(%edi)
80104d33:	e8 48 1e 00 00       	call   80106b80 <digitcount>
80104d38:	29 c3                	sub    %eax,%ebx
80104d3a:	89 1c 24             	mov    %ebx,(%esp)
80104d3d:	e8 7e 1e 00 00       	call   80106bc0 <printspaces>
    // Print Consecutive run
    cprintf("%d", p->max_consecutive_run);
80104d42:	5b                   	pop    %ebx
80104d43:	5e                   	pop    %esi
80104d44:	ff 77 30             	push   0x30(%edi)
80104d47:	68 a5 83 10 80       	push   $0x801083a5
80104d4c:	e8 5f b9 ff ff       	call   801006b0 <cprintf>
    printspaces(columns[7] - digitcount(p->max_consecutive_run));
80104d51:	58                   	pop    %eax
80104d52:	ff 77 30             	push   0x30(%edi)
80104d55:	e8 26 1e 00 00       	call   80106b80 <digitcount>
80104d5a:	89 c2                	mov    %eax,%edx
80104d5c:	b8 11 00 00 00       	mov    $0x11,%eax
80104d61:	29 d0                	sub    %edx,%eax
80104d63:	89 04 24             	mov    %eax,(%esp)
80104d66:	e8 55 1e 00 00       	call   80106bc0 <printspaces>
    // Print Arrival
    cprintf("%d", p->arrival_time);
80104d6b:	58                   	pop    %eax
80104d6c:	5a                   	pop    %edx
80104d6d:	ff 77 24             	push   0x24(%edi)
80104d70:	68 a5 83 10 80       	push   $0x801083a5
80104d75:	e8 36 b9 ff ff       	call   801006b0 <cprintf>
    printspaces(columns[8] - digitcount(p->arrival_time));
80104d7a:	59                   	pop    %ecx
80104d7b:	ff 77 24             	push   0x24(%edi)
80104d7e:	e8 fd 1d 00 00       	call   80106b80 <digitcount>
80104d83:	89 c2                	mov    %eax,%edx
80104d85:	b8 09 00 00 00       	mov    $0x9,%eax
80104d8a:	29 d0                	sub    %edx,%eax
80104d8c:	89 04 24             	mov    %eax,(%esp)
80104d8f:	e8 2c 1e 00 00       	call   80106bc0 <printspaces>
    // Print spent time in RR
    cprintf("%d", p->rr_ticks);
80104d94:	5b                   	pop    %ebx
80104d95:	5e                   	pop    %esi
80104d96:	ff 77 1c             	push   0x1c(%edi)
80104d99:	68 a5 83 10 80       	push   $0x801083a5
80104d9e:	e8 0d b9 ff ff       	call   801006b0 <cprintf>
    printspaces(columns[9] - digitcount(p->rr_ticks));
80104da3:	58                   	pop    %eax
80104da4:	ff 77 1c             	push   0x1c(%edi)
80104da7:	e8 d4 1d 00 00       	call   80106b80 <digitcount>
80104dac:	89 c2                	mov    %eax,%edx
80104dae:	b8 0a 00 00 00       	mov    $0xa,%eax
80104db3:	29 d0                	sub    %edx,%eax
80104db5:	89 04 24             	mov    %eax,(%esp)
80104db8:	e8 03 1e 00 00       	call   80106bc0 <printspaces>
    // Print whole running time
    cprintf("%d", p->runnig_time);
80104dbd:	58                   	pop    %eax
80104dbe:	5a                   	pop    %edx
80104dbf:	ff 77 20             	push   0x20(%edi)
80104dc2:	68 a5 83 10 80       	push   $0x801083a5
80104dc7:	e8 e4 b8 ff ff       	call   801006b0 <cprintf>
    printspaces(columns[10] - digitcount(p->runnig_time));
80104dcc:	59                   	pop    %ecx
80104dcd:	ff 77 20             	push   0x20(%edi)
80104dd0:	e8 ab 1d 00 00       	call   80106b80 <digitcount>
80104dd5:	89 c2                	mov    %eax,%edx
80104dd7:	b8 0d 00 00 00       	mov    $0xd,%eax
80104ddc:	29 d0                	sub    %edx,%eax
80104dde:	89 04 24             	mov    %eax,(%esp)
80104de1:	e8 da 1d 00 00       	call   80106bc0 <printspaces>

    cprintf("\n");
80104de6:	c7 04 24 57 83 10 80 	movl   $0x80108357,(%esp)
80104ded:	e8 be b8 ff ff       	call   801006b0 <cprintf>
80104df2:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104df5:	81 c7 a4 00 00 00    	add    $0xa4,%edi
80104dfb:	81 ff c0 56 11 80    	cmp    $0x801156c0,%edi
80104e01:	74 3d                	je     80104e40 <print_sched_info+0x280>
    if (p->state == UNUSED)
80104e03:	8b 47 a0             	mov    -0x60(%edi),%eax
80104e06:	85 c0                	test   %eax,%eax
80104e08:	74 eb                	je     80104df5 <print_sched_info+0x235>
      state = "???";
80104e0a:	bb 21 83 10 80       	mov    $0x80108321,%ebx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e0f:	83 f8 05             	cmp    $0x5,%eax
80104e12:	77 11                	ja     80104e25 <print_sched_info+0x265>
80104e14:	8b 1c 85 20 8b 10 80 	mov    -0x7fef74e0(,%eax,4),%ebx
      state = "???";
80104e1b:	b8 21 83 10 80       	mov    $0x80108321,%eax
80104e20:	85 db                	test   %ebx,%ebx
80104e22:	0f 44 d8             	cmove  %eax,%ebx
    if (p->sched_class == 1)
80104e25:	83 7f 10 01          	cmpl   $0x1,0x10(%edi)
80104e29:	0f 85 f1 fd ff ff    	jne    80104c20 <print_sched_info+0x60>
      algorithm = "EDF";
80104e2f:	c7 45 e4 94 83 10 80 	movl   $0x80108394,-0x1c(%ebp)
      class = "Real-Time";
80104e36:	be 98 83 10 80       	mov    $0x80108398,%esi
80104e3b:	e9 f9 fd ff ff       	jmp    80104c39 <print_sched_info+0x79>
  }
  release(&ptable.lock);
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	68 20 2d 11 80       	push   $0x80112d20
80104e48:	e8 d3 02 00 00       	call   80105120 <release>
  return 0;
}
80104e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e50:	31 c0                	xor    %eax,%eax
80104e52:	5b                   	pop    %ebx
80104e53:	5e                   	pop    %esi
80104e54:	5f                   	pop    %edi
80104e55:	5d                   	pop    %ebp
80104e56:	c3                   	ret
80104e57:	66 90                	xchg   %ax,%ax
80104e59:	66 90                	xchg   %ax,%ax
80104e5b:	66 90                	xchg   %ax,%ax
80104e5d:	66 90                	xchg   %ax,%ax
80104e5f:	90                   	nop

80104e60 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	53                   	push   %ebx
80104e64:	83 ec 0c             	sub    $0xc,%esp
80104e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104e6a:	68 01 84 10 80       	push   $0x80108401
80104e6f:	8d 43 04             	lea    0x4(%ebx),%eax
80104e72:	50                   	push   %eax
80104e73:	e8 18 01 00 00       	call   80104f90 <initlock>
  lk->name = name;
80104e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104e7b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104e81:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104e84:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104e8b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104e8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e91:	c9                   	leave
80104e92:	c3                   	ret
80104e93:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e9a:	00 
80104e9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104ea0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ea8:	8d 73 04             	lea    0x4(%ebx),%esi
80104eab:	83 ec 0c             	sub    $0xc,%esp
80104eae:	56                   	push   %esi
80104eaf:	e8 cc 02 00 00       	call   80105180 <acquire>
  while (lk->locked) {
80104eb4:	8b 13                	mov    (%ebx),%edx
80104eb6:	83 c4 10             	add    $0x10,%esp
80104eb9:	85 d2                	test   %edx,%edx
80104ebb:	74 16                	je     80104ed3 <acquiresleep+0x33>
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ec0:	83 ec 08             	sub    $0x8,%esp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
80104ec5:	e8 26 f5 ff ff       	call   801043f0 <sleep>
  while (lk->locked) {
80104eca:	8b 03                	mov    (%ebx),%eax
80104ecc:	83 c4 10             	add    $0x10,%esp
80104ecf:	85 c0                	test   %eax,%eax
80104ed1:	75 ed                	jne    80104ec0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104ed3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ed9:	e8 d2 eb ff ff       	call   80103ab0 <myproc>
80104ede:	8b 40 10             	mov    0x10(%eax),%eax
80104ee1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ee4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ee7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eea:	5b                   	pop    %ebx
80104eeb:	5e                   	pop    %esi
80104eec:	5d                   	pop    %ebp
  release(&lk->lk);
80104eed:	e9 2e 02 00 00       	jmp    80105120 <release>
80104ef2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ef9:	00 
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f00 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
80104f05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f08:	8d 73 04             	lea    0x4(%ebx),%esi
80104f0b:	83 ec 0c             	sub    $0xc,%esp
80104f0e:	56                   	push   %esi
80104f0f:	e8 6c 02 00 00       	call   80105180 <acquire>
  lk->locked = 0;
80104f14:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104f1a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104f21:	89 1c 24             	mov    %ebx,(%esp)
80104f24:	e8 37 f7 ff ff       	call   80104660 <wakeup>
  release(&lk->lk);
80104f29:	83 c4 10             	add    $0x10,%esp
80104f2c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104f2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f32:	5b                   	pop    %ebx
80104f33:	5e                   	pop    %esi
80104f34:	5d                   	pop    %ebp
  release(&lk->lk);
80104f35:	e9 e6 01 00 00       	jmp    80105120 <release>
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f40 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	31 ff                	xor    %edi,%edi
80104f46:	56                   	push   %esi
80104f47:	53                   	push   %ebx
80104f48:	83 ec 18             	sub    $0x18,%esp
80104f4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104f4e:	8d 73 04             	lea    0x4(%ebx),%esi
80104f51:	56                   	push   %esi
80104f52:	e8 29 02 00 00       	call   80105180 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104f57:	8b 03                	mov    (%ebx),%eax
80104f59:	83 c4 10             	add    $0x10,%esp
80104f5c:	85 c0                	test   %eax,%eax
80104f5e:	75 18                	jne    80104f78 <holdingsleep+0x38>
  release(&lk->lk);
80104f60:	83 ec 0c             	sub    $0xc,%esp
80104f63:	56                   	push   %esi
80104f64:	e8 b7 01 00 00       	call   80105120 <release>
  return r;
}
80104f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f6c:	89 f8                	mov    %edi,%eax
80104f6e:	5b                   	pop    %ebx
80104f6f:	5e                   	pop    %esi
80104f70:	5f                   	pop    %edi
80104f71:	5d                   	pop    %ebp
80104f72:	c3                   	ret
80104f73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104f78:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104f7b:	e8 30 eb ff ff       	call   80103ab0 <myproc>
80104f80:	39 58 10             	cmp    %ebx,0x10(%eax)
80104f83:	0f 94 c0             	sete   %al
80104f86:	0f b6 c0             	movzbl %al,%eax
80104f89:	89 c7                	mov    %eax,%edi
80104f8b:	eb d3                	jmp    80104f60 <holdingsleep+0x20>
80104f8d:	66 90                	xchg   %ax,%ax
80104f8f:	90                   	nop

80104f90 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104f9f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104fa2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104fa9:	5d                   	pop    %ebp
80104faa:	c3                   	ret
80104fab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104fb0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	53                   	push   %ebx
80104fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104fba:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fbd:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104fc2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104fc7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fcc:	76 10                	jbe    80104fde <getcallerpcs+0x2e>
80104fce:	eb 28                	jmp    80104ff8 <getcallerpcs+0x48>
80104fd0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104fd6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104fdc:	77 1a                	ja     80104ff8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104fde:	8b 5a 04             	mov    0x4(%edx),%ebx
80104fe1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104fe4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104fe7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104fe9:	83 f8 0a             	cmp    $0xa,%eax
80104fec:	75 e2                	jne    80104fd0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ff1:	c9                   	leave
80104ff2:	c3                   	ret
80104ff3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ff8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80104ffb:	83 c1 28             	add    $0x28,%ecx
80104ffe:	89 ca                	mov    %ecx,%edx
80105000:	29 c2                	sub    %eax,%edx
80105002:	83 e2 04             	and    $0x4,%edx
80105005:	74 11                	je     80105018 <getcallerpcs+0x68>
    pcs[i] = 0;
80105007:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010500d:	83 c0 04             	add    $0x4,%eax
80105010:	39 c1                	cmp    %eax,%ecx
80105012:	74 da                	je     80104fee <getcallerpcs+0x3e>
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80105018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010501e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80105021:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80105028:	39 c1                	cmp    %eax,%ecx
8010502a:	75 ec                	jne    80105018 <getcallerpcs+0x68>
8010502c:	eb c0                	jmp    80104fee <getcallerpcs+0x3e>
8010502e:	66 90                	xchg   %ax,%ax

80105030 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	53                   	push   %ebx
80105034:	83 ec 04             	sub    $0x4,%esp
80105037:	9c                   	pushf
80105038:	5b                   	pop    %ebx
  asm volatile("cli");
80105039:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010503a:	e8 f1 e9 ff ff       	call   80103a30 <mycpu>
8010503f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105045:	85 c0                	test   %eax,%eax
80105047:	74 17                	je     80105060 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105049:	e8 e2 e9 ff ff       	call   80103a30 <mycpu>
8010504e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105058:	c9                   	leave
80105059:	c3                   	ret
8010505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105060:	e8 cb e9 ff ff       	call   80103a30 <mycpu>
80105065:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010506b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105071:	eb d6                	jmp    80105049 <pushcli+0x19>
80105073:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010507a:	00 
8010507b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105080 <popcli>:

void
popcli(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105086:	9c                   	pushf
80105087:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105088:	f6 c4 02             	test   $0x2,%ah
8010508b:	75 35                	jne    801050c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010508d:	e8 9e e9 ff ff       	call   80103a30 <mycpu>
80105092:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105099:	78 34                	js     801050cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010509b:	e8 90 e9 ff ff       	call   80103a30 <mycpu>
801050a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801050a6:	85 d2                	test   %edx,%edx
801050a8:	74 06                	je     801050b0 <popcli+0x30>
    sti();
}
801050aa:	c9                   	leave
801050ab:	c3                   	ret
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801050b0:	e8 7b e9 ff ff       	call   80103a30 <mycpu>
801050b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801050bb:	85 c0                	test   %eax,%eax
801050bd:	74 eb                	je     801050aa <popcli+0x2a>
  asm volatile("sti");
801050bf:	fb                   	sti
}
801050c0:	c9                   	leave
801050c1:	c3                   	ret
    panic("popcli - interruptible");
801050c2:	83 ec 0c             	sub    $0xc,%esp
801050c5:	68 0c 84 10 80       	push   $0x8010840c
801050ca:	e8 b1 b2 ff ff       	call   80100380 <panic>
    panic("popcli");
801050cf:	83 ec 0c             	sub    $0xc,%esp
801050d2:	68 23 84 10 80       	push   $0x80108423
801050d7:	e8 a4 b2 ff ff       	call   80100380 <panic>
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050e0 <holding>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
801050e5:	8b 75 08             	mov    0x8(%ebp),%esi
801050e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801050ea:	e8 41 ff ff ff       	call   80105030 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801050ef:	8b 06                	mov    (%esi),%eax
801050f1:	85 c0                	test   %eax,%eax
801050f3:	75 0b                	jne    80105100 <holding+0x20>
  popcli();
801050f5:	e8 86 ff ff ff       	call   80105080 <popcli>
}
801050fa:	89 d8                	mov    %ebx,%eax
801050fc:	5b                   	pop    %ebx
801050fd:	5e                   	pop    %esi
801050fe:	5d                   	pop    %ebp
801050ff:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80105100:	8b 5e 08             	mov    0x8(%esi),%ebx
80105103:	e8 28 e9 ff ff       	call   80103a30 <mycpu>
80105108:	39 c3                	cmp    %eax,%ebx
8010510a:	0f 94 c3             	sete   %bl
  popcli();
8010510d:	e8 6e ff ff ff       	call   80105080 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105112:	0f b6 db             	movzbl %bl,%ebx
}
80105115:	89 d8                	mov    %ebx,%eax
80105117:	5b                   	pop    %ebx
80105118:	5e                   	pop    %esi
80105119:	5d                   	pop    %ebp
8010511a:	c3                   	ret
8010511b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105120 <release>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105128:	e8 03 ff ff ff       	call   80105030 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010512d:	8b 03                	mov    (%ebx),%eax
8010512f:	85 c0                	test   %eax,%eax
80105131:	75 15                	jne    80105148 <release+0x28>
  popcli();
80105133:	e8 48 ff ff ff       	call   80105080 <popcli>
    panic("release");
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	68 2a 84 10 80       	push   $0x8010842a
80105140:	e8 3b b2 ff ff       	call   80100380 <panic>
80105145:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105148:	8b 73 08             	mov    0x8(%ebx),%esi
8010514b:	e8 e0 e8 ff ff       	call   80103a30 <mycpu>
80105150:	39 c6                	cmp    %eax,%esi
80105152:	75 df                	jne    80105133 <release+0x13>
  popcli();
80105154:	e8 27 ff ff ff       	call   80105080 <popcli>
  lk->pcs[0] = 0;
80105159:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105160:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105167:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010516c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105172:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105175:	5b                   	pop    %ebx
80105176:	5e                   	pop    %esi
80105177:	5d                   	pop    %ebp
  popcli();
80105178:	e9 03 ff ff ff       	jmp    80105080 <popcli>
8010517d:	8d 76 00             	lea    0x0(%esi),%esi

80105180 <acquire>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	53                   	push   %ebx
80105184:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105187:	e8 a4 fe ff ff       	call   80105030 <pushcli>
  if(holding(lk))
8010518c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010518f:	e8 9c fe ff ff       	call   80105030 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105194:	8b 03                	mov    (%ebx),%eax
80105196:	85 c0                	test   %eax,%eax
80105198:	0f 85 b2 00 00 00    	jne    80105250 <acquire+0xd0>
  popcli();
8010519e:	e8 dd fe ff ff       	call   80105080 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801051a3:	b9 01 00 00 00       	mov    $0x1,%ecx
801051a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051af:	00 
  while(xchg(&lk->locked, 1) != 0)
801051b0:	8b 55 08             	mov    0x8(%ebp),%edx
801051b3:	89 c8                	mov    %ecx,%eax
801051b5:	f0 87 02             	lock xchg %eax,(%edx)
801051b8:	85 c0                	test   %eax,%eax
801051ba:	75 f4                	jne    801051b0 <acquire+0x30>
  __sync_synchronize();
801051bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801051c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051c4:	e8 67 e8 ff ff       	call   80103a30 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801051c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801051cc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801051ce:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051d1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801051d7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801051dc:	77 32                	ja     80105210 <acquire+0x90>
  ebp = (uint*)v - 2;
801051de:	89 e8                	mov    %ebp,%eax
801051e0:	eb 14                	jmp    801051f6 <acquire+0x76>
801051e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801051ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801051f4:	77 1a                	ja     80105210 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801051f6:	8b 58 04             	mov    0x4(%eax),%ebx
801051f9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801051fd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105200:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105202:	83 fa 0a             	cmp    $0xa,%edx
80105205:	75 e1                	jne    801051e8 <acquire+0x68>
}
80105207:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010520a:	c9                   	leave
8010520b:	c3                   	ret
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105210:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80105214:	83 c1 34             	add    $0x34,%ecx
80105217:	89 ca                	mov    %ecx,%edx
80105219:	29 c2                	sub    %eax,%edx
8010521b:	83 e2 04             	and    $0x4,%edx
8010521e:	74 10                	je     80105230 <acquire+0xb0>
    pcs[i] = 0;
80105220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105226:	83 c0 04             	add    $0x4,%eax
80105229:	39 c1                	cmp    %eax,%ecx
8010522b:	74 da                	je     80105207 <acquire+0x87>
8010522d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105230:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105236:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80105239:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80105240:	39 c1                	cmp    %eax,%ecx
80105242:	75 ec                	jne    80105230 <acquire+0xb0>
80105244:	eb c1                	jmp    80105207 <acquire+0x87>
80105246:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010524d:	00 
8010524e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80105250:	8b 5b 08             	mov    0x8(%ebx),%ebx
80105253:	e8 d8 e7 ff ff       	call   80103a30 <mycpu>
80105258:	39 c3                	cmp    %eax,%ebx
8010525a:	0f 85 3e ff ff ff    	jne    8010519e <acquire+0x1e>
  popcli();
80105260:	e8 1b fe ff ff       	call   80105080 <popcli>
    panic("acquire");
80105265:	83 ec 0c             	sub    $0xc,%esp
80105268:	68 32 84 10 80       	push   $0x80108432
8010526d:	e8 0e b1 ff ff       	call   80100380 <panic>
80105272:	66 90                	xchg   %ax,%ax
80105274:	66 90                	xchg   %ax,%ax
80105276:	66 90                	xchg   %ax,%ax
80105278:	66 90                	xchg   %ax,%ax
8010527a:	66 90                	xchg   %ax,%ax
8010527c:	66 90                	xchg   %ax,%ax
8010527e:	66 90                	xchg   %ax,%ax

80105280 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	8b 55 08             	mov    0x8(%ebp),%edx
80105287:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010528a:	89 d0                	mov    %edx,%eax
8010528c:	09 c8                	or     %ecx,%eax
8010528e:	a8 03                	test   $0x3,%al
80105290:	75 1e                	jne    801052b0 <memset+0x30>
    c &= 0xFF;
80105292:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105296:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80105299:	89 d7                	mov    %edx,%edi
8010529b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801052a1:	fc                   	cld
801052a2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801052a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801052a7:	89 d0                	mov    %edx,%eax
801052a9:	c9                   	leave
801052aa:	c3                   	ret
801052ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801052b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801052b3:	89 d7                	mov    %edx,%edi
801052b5:	fc                   	cld
801052b6:	f3 aa                	rep stos %al,%es:(%edi)
801052b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801052bb:	89 d0                	mov    %edx,%eax
801052bd:	c9                   	leave
801052be:	c3                   	ret
801052bf:	90                   	nop

801052c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	56                   	push   %esi
801052c4:	8b 75 10             	mov    0x10(%ebp),%esi
801052c7:	8b 45 08             	mov    0x8(%ebp),%eax
801052ca:	53                   	push   %ebx
801052cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052ce:	85 f6                	test   %esi,%esi
801052d0:	74 2e                	je     80105300 <memcmp+0x40>
801052d2:	01 c6                	add    %eax,%esi
801052d4:	eb 14                	jmp    801052ea <memcmp+0x2a>
801052d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801052dd:	00 
801052de:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801052e0:	83 c0 01             	add    $0x1,%eax
801052e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801052e6:	39 f0                	cmp    %esi,%eax
801052e8:	74 16                	je     80105300 <memcmp+0x40>
    if(*s1 != *s2)
801052ea:	0f b6 08             	movzbl (%eax),%ecx
801052ed:	0f b6 1a             	movzbl (%edx),%ebx
801052f0:	38 d9                	cmp    %bl,%cl
801052f2:	74 ec                	je     801052e0 <memcmp+0x20>
      return *s1 - *s2;
801052f4:	0f b6 c1             	movzbl %cl,%eax
801052f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801052f9:	5b                   	pop    %ebx
801052fa:	5e                   	pop    %esi
801052fb:	5d                   	pop    %ebp
801052fc:	c3                   	ret
801052fd:	8d 76 00             	lea    0x0(%esi),%esi
80105300:	5b                   	pop    %ebx
  return 0;
80105301:	31 c0                	xor    %eax,%eax
}
80105303:	5e                   	pop    %esi
80105304:	5d                   	pop    %ebp
80105305:	c3                   	ret
80105306:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010530d:	00 
8010530e:	66 90                	xchg   %ax,%ax

80105310 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	8b 55 08             	mov    0x8(%ebp),%edx
80105317:	8b 45 10             	mov    0x10(%ebp),%eax
8010531a:	56                   	push   %esi
8010531b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010531e:	39 d6                	cmp    %edx,%esi
80105320:	73 26                	jae    80105348 <memmove+0x38>
80105322:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80105325:	39 ca                	cmp    %ecx,%edx
80105327:	73 1f                	jae    80105348 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105329:	85 c0                	test   %eax,%eax
8010532b:	74 0f                	je     8010533c <memmove+0x2c>
8010532d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80105330:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105334:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105337:	83 e8 01             	sub    $0x1,%eax
8010533a:	73 f4                	jae    80105330 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010533c:	5e                   	pop    %esi
8010533d:	89 d0                	mov    %edx,%eax
8010533f:	5f                   	pop    %edi
80105340:	5d                   	pop    %ebp
80105341:	c3                   	ret
80105342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105348:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010534b:	89 d7                	mov    %edx,%edi
8010534d:	85 c0                	test   %eax,%eax
8010534f:	74 eb                	je     8010533c <memmove+0x2c>
80105351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105358:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105359:	39 ce                	cmp    %ecx,%esi
8010535b:	75 fb                	jne    80105358 <memmove+0x48>
}
8010535d:	5e                   	pop    %esi
8010535e:	89 d0                	mov    %edx,%eax
80105360:	5f                   	pop    %edi
80105361:	5d                   	pop    %ebp
80105362:	c3                   	ret
80105363:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010536a:	00 
8010536b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105370 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105370:	eb 9e                	jmp    80105310 <memmove>
80105372:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105379:	00 
8010537a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105380 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	53                   	push   %ebx
80105384:	8b 55 10             	mov    0x10(%ebp),%edx
80105387:	8b 45 08             	mov    0x8(%ebp),%eax
8010538a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010538d:	85 d2                	test   %edx,%edx
8010538f:	75 16                	jne    801053a7 <strncmp+0x27>
80105391:	eb 2d                	jmp    801053c0 <strncmp+0x40>
80105393:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105398:	3a 19                	cmp    (%ecx),%bl
8010539a:	75 12                	jne    801053ae <strncmp+0x2e>
    n--, p++, q++;
8010539c:	83 c0 01             	add    $0x1,%eax
8010539f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801053a2:	83 ea 01             	sub    $0x1,%edx
801053a5:	74 19                	je     801053c0 <strncmp+0x40>
801053a7:	0f b6 18             	movzbl (%eax),%ebx
801053aa:	84 db                	test   %bl,%bl
801053ac:	75 ea                	jne    80105398 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801053ae:	0f b6 00             	movzbl (%eax),%eax
801053b1:	0f b6 11             	movzbl (%ecx),%edx
}
801053b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053b7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801053b8:	29 d0                	sub    %edx,%eax
}
801053ba:	c3                   	ret
801053bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801053c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801053c3:	31 c0                	xor    %eax,%eax
}
801053c5:	c9                   	leave
801053c6:	c3                   	ret
801053c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053ce:	00 
801053cf:	90                   	nop

801053d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	57                   	push   %edi
801053d4:	56                   	push   %esi
801053d5:	8b 75 08             	mov    0x8(%ebp),%esi
801053d8:	53                   	push   %ebx
801053d9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801053dc:	89 f0                	mov    %esi,%eax
801053de:	eb 15                	jmp    801053f5 <strncpy+0x25>
801053e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801053e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801053e7:	83 c0 01             	add    $0x1,%eax
801053ea:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
801053ee:	88 48 ff             	mov    %cl,-0x1(%eax)
801053f1:	84 c9                	test   %cl,%cl
801053f3:	74 13                	je     80105408 <strncpy+0x38>
801053f5:	89 d3                	mov    %edx,%ebx
801053f7:	83 ea 01             	sub    $0x1,%edx
801053fa:	85 db                	test   %ebx,%ebx
801053fc:	7f e2                	jg     801053e0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801053fe:	5b                   	pop    %ebx
801053ff:	89 f0                	mov    %esi,%eax
80105401:	5e                   	pop    %esi
80105402:	5f                   	pop    %edi
80105403:	5d                   	pop    %ebp
80105404:	c3                   	ret
80105405:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80105408:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010540b:	83 e9 01             	sub    $0x1,%ecx
8010540e:	85 d2                	test   %edx,%edx
80105410:	74 ec                	je     801053fe <strncpy+0x2e>
80105412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80105418:	83 c0 01             	add    $0x1,%eax
8010541b:	89 ca                	mov    %ecx,%edx
8010541d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80105421:	29 c2                	sub    %eax,%edx
80105423:	85 d2                	test   %edx,%edx
80105425:	7f f1                	jg     80105418 <strncpy+0x48>
}
80105427:	5b                   	pop    %ebx
80105428:	89 f0                	mov    %esi,%eax
8010542a:	5e                   	pop    %esi
8010542b:	5f                   	pop    %edi
8010542c:	5d                   	pop    %ebp
8010542d:	c3                   	ret
8010542e:	66 90                	xchg   %ax,%ax

80105430 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	56                   	push   %esi
80105434:	8b 55 10             	mov    0x10(%ebp),%edx
80105437:	8b 75 08             	mov    0x8(%ebp),%esi
8010543a:	53                   	push   %ebx
8010543b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010543e:	85 d2                	test   %edx,%edx
80105440:	7e 25                	jle    80105467 <safestrcpy+0x37>
80105442:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105446:	89 f2                	mov    %esi,%edx
80105448:	eb 16                	jmp    80105460 <safestrcpy+0x30>
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105450:	0f b6 08             	movzbl (%eax),%ecx
80105453:	83 c0 01             	add    $0x1,%eax
80105456:	83 c2 01             	add    $0x1,%edx
80105459:	88 4a ff             	mov    %cl,-0x1(%edx)
8010545c:	84 c9                	test   %cl,%cl
8010545e:	74 04                	je     80105464 <safestrcpy+0x34>
80105460:	39 d8                	cmp    %ebx,%eax
80105462:	75 ec                	jne    80105450 <safestrcpy+0x20>
    ;
  *s = 0;
80105464:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105467:	89 f0                	mov    %esi,%eax
80105469:	5b                   	pop    %ebx
8010546a:	5e                   	pop    %esi
8010546b:	5d                   	pop    %ebp
8010546c:	c3                   	ret
8010546d:	8d 76 00             	lea    0x0(%esi),%esi

80105470 <strlen>:

int
strlen(const char *s)
{
80105470:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105471:	31 c0                	xor    %eax,%eax
{
80105473:	89 e5                	mov    %esp,%ebp
80105475:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105478:	80 3a 00             	cmpb   $0x0,(%edx)
8010547b:	74 0c                	je     80105489 <strlen+0x19>
8010547d:	8d 76 00             	lea    0x0(%esi),%esi
80105480:	83 c0 01             	add    $0x1,%eax
80105483:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105487:	75 f7                	jne    80105480 <strlen+0x10>
    ;
  return n;
}
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret

8010548b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010548b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010548f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105493:	55                   	push   %ebp
  pushl %ebx
80105494:	53                   	push   %ebx
  pushl %esi
80105495:	56                   	push   %esi
  pushl %edi
80105496:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105497:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105499:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010549b:	5f                   	pop    %edi
  popl %esi
8010549c:	5e                   	pop    %esi
  popl %ebx
8010549d:	5b                   	pop    %ebx
  popl %ebp
8010549e:	5d                   	pop    %ebp
  ret
8010549f:	c3                   	ret

801054a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	53                   	push   %ebx
801054a4:	83 ec 04             	sub    $0x4,%esp
801054a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801054aa:	e8 01 e6 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054af:	8b 00                	mov    (%eax),%eax
801054b1:	39 c3                	cmp    %eax,%ebx
801054b3:	73 1b                	jae    801054d0 <fetchint+0x30>
801054b5:	8d 53 04             	lea    0x4(%ebx),%edx
801054b8:	39 d0                	cmp    %edx,%eax
801054ba:	72 14                	jb     801054d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801054bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801054bf:	8b 13                	mov    (%ebx),%edx
801054c1:	89 10                	mov    %edx,(%eax)
  return 0;
801054c3:	31 c0                	xor    %eax,%eax
}
801054c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054c8:	c9                   	leave
801054c9:	c3                   	ret
801054ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d5:	eb ee                	jmp    801054c5 <fetchint+0x25>
801054d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054de:	00 
801054df:	90                   	nop

801054e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	53                   	push   %ebx
801054e4:	83 ec 04             	sub    $0x4,%esp
801054e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801054ea:	e8 c1 e5 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz)
801054ef:	3b 18                	cmp    (%eax),%ebx
801054f1:	73 2d                	jae    80105520 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801054f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801054f6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801054f8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801054fa:	39 d3                	cmp    %edx,%ebx
801054fc:	73 22                	jae    80105520 <fetchstr+0x40>
801054fe:	89 d8                	mov    %ebx,%eax
80105500:	eb 0d                	jmp    8010550f <fetchstr+0x2f>
80105502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105508:	83 c0 01             	add    $0x1,%eax
8010550b:	39 d0                	cmp    %edx,%eax
8010550d:	73 11                	jae    80105520 <fetchstr+0x40>
    if(*s == 0)
8010550f:	80 38 00             	cmpb   $0x0,(%eax)
80105512:	75 f4                	jne    80105508 <fetchstr+0x28>
      return s - *pp;
80105514:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105519:	c9                   	leave
8010551a:	c3                   	ret
8010551b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80105520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105528:	c9                   	leave
80105529:	c3                   	ret
8010552a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105530 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	56                   	push   %esi
80105534:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105535:	e8 76 e5 ff ff       	call   80103ab0 <myproc>
8010553a:	8b 55 08             	mov    0x8(%ebp),%edx
8010553d:	8b 40 18             	mov    0x18(%eax),%eax
80105540:	8b 40 44             	mov    0x44(%eax),%eax
80105543:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105546:	e8 65 e5 ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010554b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010554e:	8b 00                	mov    (%eax),%eax
80105550:	39 c6                	cmp    %eax,%esi
80105552:	73 1c                	jae    80105570 <argint+0x40>
80105554:	8d 53 08             	lea    0x8(%ebx),%edx
80105557:	39 d0                	cmp    %edx,%eax
80105559:	72 15                	jb     80105570 <argint+0x40>
  *ip = *(int*)(addr);
8010555b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010555e:	8b 53 04             	mov    0x4(%ebx),%edx
80105561:	89 10                	mov    %edx,(%eax)
  return 0;
80105563:	31 c0                	xor    %eax,%eax
}
80105565:	5b                   	pop    %ebx
80105566:	5e                   	pop    %esi
80105567:	5d                   	pop    %ebp
80105568:	c3                   	ret
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105575:	eb ee                	jmp    80105565 <argint+0x35>
80105577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010557e:	00 
8010557f:	90                   	nop

80105580 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
80105585:	53                   	push   %ebx
80105586:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105589:	e8 22 e5 ff ff       	call   80103ab0 <myproc>
8010558e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105590:	e8 1b e5 ff ff       	call   80103ab0 <myproc>
80105595:	8b 55 08             	mov    0x8(%ebp),%edx
80105598:	8b 40 18             	mov    0x18(%eax),%eax
8010559b:	8b 40 44             	mov    0x44(%eax),%eax
8010559e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801055a1:	e8 0a e5 ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055a6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055a9:	8b 00                	mov    (%eax),%eax
801055ab:	39 c7                	cmp    %eax,%edi
801055ad:	73 31                	jae    801055e0 <argptr+0x60>
801055af:	8d 4b 08             	lea    0x8(%ebx),%ecx
801055b2:	39 c8                	cmp    %ecx,%eax
801055b4:	72 2a                	jb     801055e0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801055b6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801055b9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801055bc:	85 d2                	test   %edx,%edx
801055be:	78 20                	js     801055e0 <argptr+0x60>
801055c0:	8b 16                	mov    (%esi),%edx
801055c2:	39 d0                	cmp    %edx,%eax
801055c4:	73 1a                	jae    801055e0 <argptr+0x60>
801055c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801055c9:	01 c3                	add    %eax,%ebx
801055cb:	39 da                	cmp    %ebx,%edx
801055cd:	72 11                	jb     801055e0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801055cf:	8b 55 0c             	mov    0xc(%ebp),%edx
801055d2:	89 02                	mov    %eax,(%edx)
  return 0;
801055d4:	31 c0                	xor    %eax,%eax
}
801055d6:	83 c4 0c             	add    $0xc,%esp
801055d9:	5b                   	pop    %ebx
801055da:	5e                   	pop    %esi
801055db:	5f                   	pop    %edi
801055dc:	5d                   	pop    %ebp
801055dd:	c3                   	ret
801055de:	66 90                	xchg   %ax,%ax
    return -1;
801055e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e5:	eb ef                	jmp    801055d6 <argptr+0x56>
801055e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055ee:	00 
801055ef:	90                   	nop

801055f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	56                   	push   %esi
801055f4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055f5:	e8 b6 e4 ff ff       	call   80103ab0 <myproc>
801055fa:	8b 55 08             	mov    0x8(%ebp),%edx
801055fd:	8b 40 18             	mov    0x18(%eax),%eax
80105600:	8b 40 44             	mov    0x44(%eax),%eax
80105603:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105606:	e8 a5 e4 ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010560b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010560e:	8b 00                	mov    (%eax),%eax
80105610:	39 c6                	cmp    %eax,%esi
80105612:	73 44                	jae    80105658 <argstr+0x68>
80105614:	8d 53 08             	lea    0x8(%ebx),%edx
80105617:	39 d0                	cmp    %edx,%eax
80105619:	72 3d                	jb     80105658 <argstr+0x68>
  *ip = *(int*)(addr);
8010561b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010561e:	e8 8d e4 ff ff       	call   80103ab0 <myproc>
  if(addr >= curproc->sz)
80105623:	3b 18                	cmp    (%eax),%ebx
80105625:	73 31                	jae    80105658 <argstr+0x68>
  *pp = (char*)addr;
80105627:	8b 55 0c             	mov    0xc(%ebp),%edx
8010562a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010562c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010562e:	39 d3                	cmp    %edx,%ebx
80105630:	73 26                	jae    80105658 <argstr+0x68>
80105632:	89 d8                	mov    %ebx,%eax
80105634:	eb 11                	jmp    80105647 <argstr+0x57>
80105636:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010563d:	00 
8010563e:	66 90                	xchg   %ax,%ax
80105640:	83 c0 01             	add    $0x1,%eax
80105643:	39 d0                	cmp    %edx,%eax
80105645:	73 11                	jae    80105658 <argstr+0x68>
    if(*s == 0)
80105647:	80 38 00             	cmpb   $0x0,(%eax)
8010564a:	75 f4                	jne    80105640 <argstr+0x50>
      return s - *pp;
8010564c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010564e:	5b                   	pop    %ebx
8010564f:	5e                   	pop    %esi
80105650:	5d                   	pop    %ebp
80105651:	c3                   	ret
80105652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105658:	5b                   	pop    %ebx
    return -1;
80105659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010565e:	5e                   	pop    %esi
8010565f:	5d                   	pop    %ebp
80105660:	c3                   	ret
80105661:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105668:	00 
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105670 <syscall>:

};

void
syscall(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	53                   	push   %ebx
80105674:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105677:	e8 34 e4 ff ff       	call   80103ab0 <myproc>
8010567c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010567e:	8b 40 18             	mov    0x18(%eax),%eax
80105681:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105684:	8d 50 ff             	lea    -0x1(%eax),%edx
80105687:	83 fa 1b             	cmp    $0x1b,%edx
8010568a:	77 24                	ja     801056b0 <syscall+0x40>
8010568c:	8b 14 85 60 8b 10 80 	mov    -0x7fef74a0(,%eax,4),%edx
80105693:	85 d2                	test   %edx,%edx
80105695:	74 19                	je     801056b0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105697:	ff d2                	call   *%edx
80105699:	89 c2                	mov    %eax,%edx
8010569b:	8b 43 18             	mov    0x18(%ebx),%eax
8010569e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
801056a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056a4:	c9                   	leave
801056a5:	c3                   	ret
801056a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056ad:	00 
801056ae:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
801056b0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801056b1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801056b4:	50                   	push   %eax
801056b5:	ff 73 10             	push   0x10(%ebx)
801056b8:	68 3a 84 10 80       	push   $0x8010843a
801056bd:	e8 ee af ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801056c2:	8b 43 18             	mov    0x18(%ebx),%eax
801056c5:	83 c4 10             	add    $0x10,%esp
801056c8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801056cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056d2:	c9                   	leave
801056d3:	c3                   	ret
801056d4:	66 90                	xchg   %ax,%ax
801056d6:	66 90                	xchg   %ax,%ax
801056d8:	66 90                	xchg   %ax,%ax
801056da:	66 90                	xchg   %ax,%ax
801056dc:	66 90                	xchg   %ax,%ax
801056de:	66 90                	xchg   %ax,%ax

801056e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056e5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801056e8:	53                   	push   %ebx
801056e9:	83 ec 34             	sub    $0x34,%esp
801056ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801056ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
801056f2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801056f5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801056f8:	57                   	push   %edi
801056f9:	50                   	push   %eax
801056fa:	e8 d1 c9 ff ff       	call   801020d0 <nameiparent>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	85 c0                	test   %eax,%eax
80105704:	74 5e                	je     80105764 <create+0x84>
    return 0;
  ilock(dp);
80105706:	83 ec 0c             	sub    $0xc,%esp
80105709:	89 c3                	mov    %eax,%ebx
8010570b:	50                   	push   %eax
8010570c:	e8 bf c0 ff ff       	call   801017d0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105711:	83 c4 0c             	add    $0xc,%esp
80105714:	6a 00                	push   $0x0
80105716:	57                   	push   %edi
80105717:	53                   	push   %ebx
80105718:	e8 03 c6 ff ff       	call   80101d20 <dirlookup>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	89 c6                	mov    %eax,%esi
80105722:	85 c0                	test   %eax,%eax
80105724:	74 4a                	je     80105770 <create+0x90>
    iunlockput(dp);
80105726:	83 ec 0c             	sub    $0xc,%esp
80105729:	53                   	push   %ebx
8010572a:	e8 31 c3 ff ff       	call   80101a60 <iunlockput>
    ilock(ip);
8010572f:	89 34 24             	mov    %esi,(%esp)
80105732:	e8 99 c0 ff ff       	call   801017d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105737:	83 c4 10             	add    $0x10,%esp
8010573a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010573f:	75 17                	jne    80105758 <create+0x78>
80105741:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105746:	75 10                	jne    80105758 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105748:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010574b:	89 f0                	mov    %esi,%eax
8010574d:	5b                   	pop    %ebx
8010574e:	5e                   	pop    %esi
8010574f:	5f                   	pop    %edi
80105750:	5d                   	pop    %ebp
80105751:	c3                   	ret
80105752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	56                   	push   %esi
8010575c:	e8 ff c2 ff ff       	call   80101a60 <iunlockput>
    return 0;
80105761:	83 c4 10             	add    $0x10,%esp
}
80105764:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105767:	31 f6                	xor    %esi,%esi
}
80105769:	5b                   	pop    %ebx
8010576a:	89 f0                	mov    %esi,%eax
8010576c:	5e                   	pop    %esi
8010576d:	5f                   	pop    %edi
8010576e:	5d                   	pop    %ebp
8010576f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80105770:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105774:	83 ec 08             	sub    $0x8,%esp
80105777:	50                   	push   %eax
80105778:	ff 33                	push   (%ebx)
8010577a:	e8 e1 be ff ff       	call   80101660 <ialloc>
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	89 c6                	mov    %eax,%esi
80105784:	85 c0                	test   %eax,%eax
80105786:	0f 84 bc 00 00 00    	je     80105848 <create+0x168>
  ilock(ip);
8010578c:	83 ec 0c             	sub    $0xc,%esp
8010578f:	50                   	push   %eax
80105790:	e8 3b c0 ff ff       	call   801017d0 <ilock>
  ip->major = major;
80105795:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105799:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010579d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801057a1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801057a5:	b8 01 00 00 00       	mov    $0x1,%eax
801057aa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801057ae:	89 34 24             	mov    %esi,(%esp)
801057b1:	e8 6a bf ff ff       	call   80101720 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801057b6:	83 c4 10             	add    $0x10,%esp
801057b9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801057be:	74 30                	je     801057f0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801057c0:	83 ec 04             	sub    $0x4,%esp
801057c3:	ff 76 04             	push   0x4(%esi)
801057c6:	57                   	push   %edi
801057c7:	53                   	push   %ebx
801057c8:	e8 23 c8 ff ff       	call   80101ff0 <dirlink>
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	78 67                	js     8010583b <create+0x15b>
  iunlockput(dp);
801057d4:	83 ec 0c             	sub    $0xc,%esp
801057d7:	53                   	push   %ebx
801057d8:	e8 83 c2 ff ff       	call   80101a60 <iunlockput>
  return ip;
801057dd:	83 c4 10             	add    $0x10,%esp
}
801057e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057e3:	89 f0                	mov    %esi,%eax
801057e5:	5b                   	pop    %ebx
801057e6:	5e                   	pop    %esi
801057e7:	5f                   	pop    %edi
801057e8:	5d                   	pop    %ebp
801057e9:	c3                   	ret
801057ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801057f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801057f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801057f8:	53                   	push   %ebx
801057f9:	e8 22 bf ff ff       	call   80101720 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057fe:	83 c4 0c             	add    $0xc,%esp
80105801:	ff 76 04             	push   0x4(%esi)
80105804:	68 72 84 10 80       	push   $0x80108472
80105809:	56                   	push   %esi
8010580a:	e8 e1 c7 ff ff       	call   80101ff0 <dirlink>
8010580f:	83 c4 10             	add    $0x10,%esp
80105812:	85 c0                	test   %eax,%eax
80105814:	78 18                	js     8010582e <create+0x14e>
80105816:	83 ec 04             	sub    $0x4,%esp
80105819:	ff 73 04             	push   0x4(%ebx)
8010581c:	68 71 84 10 80       	push   $0x80108471
80105821:	56                   	push   %esi
80105822:	e8 c9 c7 ff ff       	call   80101ff0 <dirlink>
80105827:	83 c4 10             	add    $0x10,%esp
8010582a:	85 c0                	test   %eax,%eax
8010582c:	79 92                	jns    801057c0 <create+0xe0>
      panic("create dots");
8010582e:	83 ec 0c             	sub    $0xc,%esp
80105831:	68 65 84 10 80       	push   $0x80108465
80105836:	e8 45 ab ff ff       	call   80100380 <panic>
    panic("create: dirlink");
8010583b:	83 ec 0c             	sub    $0xc,%esp
8010583e:	68 74 84 10 80       	push   $0x80108474
80105843:	e8 38 ab ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105848:	83 ec 0c             	sub    $0xc,%esp
8010584b:	68 56 84 10 80       	push   $0x80108456
80105850:	e8 2b ab ff ff       	call   80100380 <panic>
80105855:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010585c:	00 
8010585d:	8d 76 00             	lea    0x0(%esi),%esi

80105860 <sys_dup>:
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	56                   	push   %esi
80105864:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105865:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105868:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010586b:	50                   	push   %eax
8010586c:	6a 00                	push   $0x0
8010586e:	e8 bd fc ff ff       	call   80105530 <argint>
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	85 c0                	test   %eax,%eax
80105878:	78 36                	js     801058b0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010587a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010587e:	77 30                	ja     801058b0 <sys_dup+0x50>
80105880:	e8 2b e2 ff ff       	call   80103ab0 <myproc>
80105885:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105888:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010588c:	85 f6                	test   %esi,%esi
8010588e:	74 20                	je     801058b0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105890:	e8 1b e2 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105895:	31 db                	xor    %ebx,%ebx
80105897:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010589e:	00 
8010589f:	90                   	nop
    if(curproc->ofile[fd] == 0){
801058a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058a4:	85 d2                	test   %edx,%edx
801058a6:	74 18                	je     801058c0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801058a8:	83 c3 01             	add    $0x1,%ebx
801058ab:	83 fb 10             	cmp    $0x10,%ebx
801058ae:	75 f0                	jne    801058a0 <sys_dup+0x40>
}
801058b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801058b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801058b8:	89 d8                	mov    %ebx,%eax
801058ba:	5b                   	pop    %ebx
801058bb:	5e                   	pop    %esi
801058bc:	5d                   	pop    %ebp
801058bd:	c3                   	ret
801058be:	66 90                	xchg   %ax,%ax
  filedup(f);
801058c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801058c3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801058c7:	56                   	push   %esi
801058c8:	e8 23 b6 ff ff       	call   80100ef0 <filedup>
  return fd;
801058cd:	83 c4 10             	add    $0x10,%esp
}
801058d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058d3:	89 d8                	mov    %ebx,%eax
801058d5:	5b                   	pop    %ebx
801058d6:	5e                   	pop    %esi
801058d7:	5d                   	pop    %ebp
801058d8:	c3                   	ret
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_read>:
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	56                   	push   %esi
801058e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801058e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801058e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801058eb:	53                   	push   %ebx
801058ec:	6a 00                	push   $0x0
801058ee:	e8 3d fc ff ff       	call   80105530 <argint>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	78 5e                	js     80105958 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801058fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801058fe:	77 58                	ja     80105958 <sys_read+0x78>
80105900:	e8 ab e1 ff ff       	call   80103ab0 <myproc>
80105905:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105908:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010590c:	85 f6                	test   %esi,%esi
8010590e:	74 48                	je     80105958 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105910:	83 ec 08             	sub    $0x8,%esp
80105913:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105916:	50                   	push   %eax
80105917:	6a 02                	push   $0x2
80105919:	e8 12 fc ff ff       	call   80105530 <argint>
8010591e:	83 c4 10             	add    $0x10,%esp
80105921:	85 c0                	test   %eax,%eax
80105923:	78 33                	js     80105958 <sys_read+0x78>
80105925:	83 ec 04             	sub    $0x4,%esp
80105928:	ff 75 f0             	push   -0x10(%ebp)
8010592b:	53                   	push   %ebx
8010592c:	6a 01                	push   $0x1
8010592e:	e8 4d fc ff ff       	call   80105580 <argptr>
80105933:	83 c4 10             	add    $0x10,%esp
80105936:	85 c0                	test   %eax,%eax
80105938:	78 1e                	js     80105958 <sys_read+0x78>
  return fileread(f, p, n);
8010593a:	83 ec 04             	sub    $0x4,%esp
8010593d:	ff 75 f0             	push   -0x10(%ebp)
80105940:	ff 75 f4             	push   -0xc(%ebp)
80105943:	56                   	push   %esi
80105944:	e8 27 b7 ff ff       	call   80101070 <fileread>
80105949:	83 c4 10             	add    $0x10,%esp
}
8010594c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010594f:	5b                   	pop    %ebx
80105950:	5e                   	pop    %esi
80105951:	5d                   	pop    %ebp
80105952:	c3                   	ret
80105953:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010595d:	eb ed                	jmp    8010594c <sys_read+0x6c>
8010595f:	90                   	nop

80105960 <sys_write>:
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	56                   	push   %esi
80105964:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105965:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105968:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010596b:	53                   	push   %ebx
8010596c:	6a 00                	push   $0x0
8010596e:	e8 bd fb ff ff       	call   80105530 <argint>
80105973:	83 c4 10             	add    $0x10,%esp
80105976:	85 c0                	test   %eax,%eax
80105978:	78 5e                	js     801059d8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010597a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010597e:	77 58                	ja     801059d8 <sys_write+0x78>
80105980:	e8 2b e1 ff ff       	call   80103ab0 <myproc>
80105985:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105988:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010598c:	85 f6                	test   %esi,%esi
8010598e:	74 48                	je     801059d8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105990:	83 ec 08             	sub    $0x8,%esp
80105993:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105996:	50                   	push   %eax
80105997:	6a 02                	push   $0x2
80105999:	e8 92 fb ff ff       	call   80105530 <argint>
8010599e:	83 c4 10             	add    $0x10,%esp
801059a1:	85 c0                	test   %eax,%eax
801059a3:	78 33                	js     801059d8 <sys_write+0x78>
801059a5:	83 ec 04             	sub    $0x4,%esp
801059a8:	ff 75 f0             	push   -0x10(%ebp)
801059ab:	53                   	push   %ebx
801059ac:	6a 01                	push   $0x1
801059ae:	e8 cd fb ff ff       	call   80105580 <argptr>
801059b3:	83 c4 10             	add    $0x10,%esp
801059b6:	85 c0                	test   %eax,%eax
801059b8:	78 1e                	js     801059d8 <sys_write+0x78>
  return filewrite(f, p, n);
801059ba:	83 ec 04             	sub    $0x4,%esp
801059bd:	ff 75 f0             	push   -0x10(%ebp)
801059c0:	ff 75 f4             	push   -0xc(%ebp)
801059c3:	56                   	push   %esi
801059c4:	e8 37 b7 ff ff       	call   80101100 <filewrite>
801059c9:	83 c4 10             	add    $0x10,%esp
}
801059cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059cf:	5b                   	pop    %ebx
801059d0:	5e                   	pop    %esi
801059d1:	5d                   	pop    %ebp
801059d2:	c3                   	ret
801059d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
801059d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059dd:	eb ed                	jmp    801059cc <sys_write+0x6c>
801059df:	90                   	nop

801059e0 <sys_close>:
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	56                   	push   %esi
801059e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801059e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801059eb:	50                   	push   %eax
801059ec:	6a 00                	push   $0x0
801059ee:	e8 3d fb ff ff       	call   80105530 <argint>
801059f3:	83 c4 10             	add    $0x10,%esp
801059f6:	85 c0                	test   %eax,%eax
801059f8:	78 3e                	js     80105a38 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801059fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801059fe:	77 38                	ja     80105a38 <sys_close+0x58>
80105a00:	e8 ab e0 ff ff       	call   80103ab0 <myproc>
80105a05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a08:	8d 5a 08             	lea    0x8(%edx),%ebx
80105a0b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80105a0f:	85 f6                	test   %esi,%esi
80105a11:	74 25                	je     80105a38 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105a13:	e8 98 e0 ff ff       	call   80103ab0 <myproc>
  fileclose(f);
80105a18:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105a1b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105a22:	00 
  fileclose(f);
80105a23:	56                   	push   %esi
80105a24:	e8 17 b5 ff ff       	call   80100f40 <fileclose>
  return 0;
80105a29:	83 c4 10             	add    $0x10,%esp
80105a2c:	31 c0                	xor    %eax,%eax
}
80105a2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a31:	5b                   	pop    %ebx
80105a32:	5e                   	pop    %esi
80105a33:	5d                   	pop    %ebp
80105a34:	c3                   	ret
80105a35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3d:	eb ef                	jmp    80105a2e <sys_close+0x4e>
80105a3f:	90                   	nop

80105a40 <sys_fstat>:
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	56                   	push   %esi
80105a44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105a45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105a48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105a4b:	53                   	push   %ebx
80105a4c:	6a 00                	push   $0x0
80105a4e:	e8 dd fa ff ff       	call   80105530 <argint>
80105a53:	83 c4 10             	add    $0x10,%esp
80105a56:	85 c0                	test   %eax,%eax
80105a58:	78 46                	js     80105aa0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105a5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105a5e:	77 40                	ja     80105aa0 <sys_fstat+0x60>
80105a60:	e8 4b e0 ff ff       	call   80103ab0 <myproc>
80105a65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105a6c:	85 f6                	test   %esi,%esi
80105a6e:	74 30                	je     80105aa0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105a70:	83 ec 04             	sub    $0x4,%esp
80105a73:	6a 14                	push   $0x14
80105a75:	53                   	push   %ebx
80105a76:	6a 01                	push   $0x1
80105a78:	e8 03 fb ff ff       	call   80105580 <argptr>
80105a7d:	83 c4 10             	add    $0x10,%esp
80105a80:	85 c0                	test   %eax,%eax
80105a82:	78 1c                	js     80105aa0 <sys_fstat+0x60>
  return filestat(f, st);
80105a84:	83 ec 08             	sub    $0x8,%esp
80105a87:	ff 75 f4             	push   -0xc(%ebp)
80105a8a:	56                   	push   %esi
80105a8b:	e8 90 b5 ff ff       	call   80101020 <filestat>
80105a90:	83 c4 10             	add    $0x10,%esp
}
80105a93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a96:	5b                   	pop    %ebx
80105a97:	5e                   	pop    %esi
80105a98:	5d                   	pop    %ebp
80105a99:	c3                   	ret
80105a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa5:	eb ec                	jmp    80105a93 <sys_fstat+0x53>
80105aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aae:	00 
80105aaf:	90                   	nop

80105ab0 <sys_link>:
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	57                   	push   %edi
80105ab4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ab5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105ab8:	53                   	push   %ebx
80105ab9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105abc:	50                   	push   %eax
80105abd:	6a 00                	push   $0x0
80105abf:	e8 2c fb ff ff       	call   801055f0 <argstr>
80105ac4:	83 c4 10             	add    $0x10,%esp
80105ac7:	85 c0                	test   %eax,%eax
80105ac9:	0f 88 fb 00 00 00    	js     80105bca <sys_link+0x11a>
80105acf:	83 ec 08             	sub    $0x8,%esp
80105ad2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105ad5:	50                   	push   %eax
80105ad6:	6a 01                	push   $0x1
80105ad8:	e8 13 fb ff ff       	call   801055f0 <argstr>
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	85 c0                	test   %eax,%eax
80105ae2:	0f 88 e2 00 00 00    	js     80105bca <sys_link+0x11a>
  begin_op();
80105ae8:	e8 83 d2 ff ff       	call   80102d70 <begin_op>
  if((ip = namei(old)) == 0){
80105aed:	83 ec 0c             	sub    $0xc,%esp
80105af0:	ff 75 d4             	push   -0x2c(%ebp)
80105af3:	e8 b8 c5 ff ff       	call   801020b0 <namei>
80105af8:	83 c4 10             	add    $0x10,%esp
80105afb:	89 c3                	mov    %eax,%ebx
80105afd:	85 c0                	test   %eax,%eax
80105aff:	0f 84 df 00 00 00    	je     80105be4 <sys_link+0x134>
  ilock(ip);
80105b05:	83 ec 0c             	sub    $0xc,%esp
80105b08:	50                   	push   %eax
80105b09:	e8 c2 bc ff ff       	call   801017d0 <ilock>
  if(ip->type == T_DIR){
80105b0e:	83 c4 10             	add    $0x10,%esp
80105b11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b16:	0f 84 b5 00 00 00    	je     80105bd1 <sys_link+0x121>
  iupdate(ip);
80105b1c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105b1f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105b24:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105b27:	53                   	push   %ebx
80105b28:	e8 f3 bb ff ff       	call   80101720 <iupdate>
  iunlock(ip);
80105b2d:	89 1c 24             	mov    %ebx,(%esp)
80105b30:	e8 7b bd ff ff       	call   801018b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105b35:	58                   	pop    %eax
80105b36:	5a                   	pop    %edx
80105b37:	57                   	push   %edi
80105b38:	ff 75 d0             	push   -0x30(%ebp)
80105b3b:	e8 90 c5 ff ff       	call   801020d0 <nameiparent>
80105b40:	83 c4 10             	add    $0x10,%esp
80105b43:	89 c6                	mov    %eax,%esi
80105b45:	85 c0                	test   %eax,%eax
80105b47:	74 5b                	je     80105ba4 <sys_link+0xf4>
  ilock(dp);
80105b49:	83 ec 0c             	sub    $0xc,%esp
80105b4c:	50                   	push   %eax
80105b4d:	e8 7e bc ff ff       	call   801017d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b52:	8b 03                	mov    (%ebx),%eax
80105b54:	83 c4 10             	add    $0x10,%esp
80105b57:	39 06                	cmp    %eax,(%esi)
80105b59:	75 3d                	jne    80105b98 <sys_link+0xe8>
80105b5b:	83 ec 04             	sub    $0x4,%esp
80105b5e:	ff 73 04             	push   0x4(%ebx)
80105b61:	57                   	push   %edi
80105b62:	56                   	push   %esi
80105b63:	e8 88 c4 ff ff       	call   80101ff0 <dirlink>
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	85 c0                	test   %eax,%eax
80105b6d:	78 29                	js     80105b98 <sys_link+0xe8>
  iunlockput(dp);
80105b6f:	83 ec 0c             	sub    $0xc,%esp
80105b72:	56                   	push   %esi
80105b73:	e8 e8 be ff ff       	call   80101a60 <iunlockput>
  iput(ip);
80105b78:	89 1c 24             	mov    %ebx,(%esp)
80105b7b:	e8 80 bd ff ff       	call   80101900 <iput>
  end_op();
80105b80:	e8 5b d2 ff ff       	call   80102de0 <end_op>
  return 0;
80105b85:	83 c4 10             	add    $0x10,%esp
80105b88:	31 c0                	xor    %eax,%eax
}
80105b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b8d:	5b                   	pop    %ebx
80105b8e:	5e                   	pop    %esi
80105b8f:	5f                   	pop    %edi
80105b90:	5d                   	pop    %ebp
80105b91:	c3                   	ret
80105b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105b98:	83 ec 0c             	sub    $0xc,%esp
80105b9b:	56                   	push   %esi
80105b9c:	e8 bf be ff ff       	call   80101a60 <iunlockput>
    goto bad;
80105ba1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105ba4:	83 ec 0c             	sub    $0xc,%esp
80105ba7:	53                   	push   %ebx
80105ba8:	e8 23 bc ff ff       	call   801017d0 <ilock>
  ip->nlink--;
80105bad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105bb2:	89 1c 24             	mov    %ebx,(%esp)
80105bb5:	e8 66 bb ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
80105bba:	89 1c 24             	mov    %ebx,(%esp)
80105bbd:	e8 9e be ff ff       	call   80101a60 <iunlockput>
  end_op();
80105bc2:	e8 19 d2 ff ff       	call   80102de0 <end_op>
  return -1;
80105bc7:	83 c4 10             	add    $0x10,%esp
    return -1;
80105bca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bcf:	eb b9                	jmp    80105b8a <sys_link+0xda>
    iunlockput(ip);
80105bd1:	83 ec 0c             	sub    $0xc,%esp
80105bd4:	53                   	push   %ebx
80105bd5:	e8 86 be ff ff       	call   80101a60 <iunlockput>
    end_op();
80105bda:	e8 01 d2 ff ff       	call   80102de0 <end_op>
    return -1;
80105bdf:	83 c4 10             	add    $0x10,%esp
80105be2:	eb e6                	jmp    80105bca <sys_link+0x11a>
    end_op();
80105be4:	e8 f7 d1 ff ff       	call   80102de0 <end_op>
    return -1;
80105be9:	eb df                	jmp    80105bca <sys_link+0x11a>
80105beb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105bf0 <sys_unlink>:
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105bf5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105bf8:	53                   	push   %ebx
80105bf9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105bfc:	50                   	push   %eax
80105bfd:	6a 00                	push   $0x0
80105bff:	e8 ec f9 ff ff       	call   801055f0 <argstr>
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	85 c0                	test   %eax,%eax
80105c09:	0f 88 54 01 00 00    	js     80105d63 <sys_unlink+0x173>
  begin_op();
80105c0f:	e8 5c d1 ff ff       	call   80102d70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c14:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105c17:	83 ec 08             	sub    $0x8,%esp
80105c1a:	53                   	push   %ebx
80105c1b:	ff 75 c0             	push   -0x40(%ebp)
80105c1e:	e8 ad c4 ff ff       	call   801020d0 <nameiparent>
80105c23:	83 c4 10             	add    $0x10,%esp
80105c26:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105c29:	85 c0                	test   %eax,%eax
80105c2b:	0f 84 58 01 00 00    	je     80105d89 <sys_unlink+0x199>
  ilock(dp);
80105c31:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105c34:	83 ec 0c             	sub    $0xc,%esp
80105c37:	57                   	push   %edi
80105c38:	e8 93 bb ff ff       	call   801017d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c3d:	58                   	pop    %eax
80105c3e:	5a                   	pop    %edx
80105c3f:	68 72 84 10 80       	push   $0x80108472
80105c44:	53                   	push   %ebx
80105c45:	e8 b6 c0 ff ff       	call   80101d00 <namecmp>
80105c4a:	83 c4 10             	add    $0x10,%esp
80105c4d:	85 c0                	test   %eax,%eax
80105c4f:	0f 84 fb 00 00 00    	je     80105d50 <sys_unlink+0x160>
80105c55:	83 ec 08             	sub    $0x8,%esp
80105c58:	68 71 84 10 80       	push   $0x80108471
80105c5d:	53                   	push   %ebx
80105c5e:	e8 9d c0 ff ff       	call   80101d00 <namecmp>
80105c63:	83 c4 10             	add    $0x10,%esp
80105c66:	85 c0                	test   %eax,%eax
80105c68:	0f 84 e2 00 00 00    	je     80105d50 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105c6e:	83 ec 04             	sub    $0x4,%esp
80105c71:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c74:	50                   	push   %eax
80105c75:	53                   	push   %ebx
80105c76:	57                   	push   %edi
80105c77:	e8 a4 c0 ff ff       	call   80101d20 <dirlookup>
80105c7c:	83 c4 10             	add    $0x10,%esp
80105c7f:	89 c3                	mov    %eax,%ebx
80105c81:	85 c0                	test   %eax,%eax
80105c83:	0f 84 c7 00 00 00    	je     80105d50 <sys_unlink+0x160>
  ilock(ip);
80105c89:	83 ec 0c             	sub    $0xc,%esp
80105c8c:	50                   	push   %eax
80105c8d:	e8 3e bb ff ff       	call   801017d0 <ilock>
  if(ip->nlink < 1)
80105c92:	83 c4 10             	add    $0x10,%esp
80105c95:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c9a:	0f 8e 0a 01 00 00    	jle    80105daa <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ca0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ca5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105ca8:	74 66                	je     80105d10 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105caa:	83 ec 04             	sub    $0x4,%esp
80105cad:	6a 10                	push   $0x10
80105caf:	6a 00                	push   $0x0
80105cb1:	57                   	push   %edi
80105cb2:	e8 c9 f5 ff ff       	call   80105280 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105cb7:	6a 10                	push   $0x10
80105cb9:	ff 75 c4             	push   -0x3c(%ebp)
80105cbc:	57                   	push   %edi
80105cbd:	ff 75 b4             	push   -0x4c(%ebp)
80105cc0:	e8 1b bf ff ff       	call   80101be0 <writei>
80105cc5:	83 c4 20             	add    $0x20,%esp
80105cc8:	83 f8 10             	cmp    $0x10,%eax
80105ccb:	0f 85 cc 00 00 00    	jne    80105d9d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105cd1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cd6:	0f 84 94 00 00 00    	je     80105d70 <sys_unlink+0x180>
  iunlockput(dp);
80105cdc:	83 ec 0c             	sub    $0xc,%esp
80105cdf:	ff 75 b4             	push   -0x4c(%ebp)
80105ce2:	e8 79 bd ff ff       	call   80101a60 <iunlockput>
  ip->nlink--;
80105ce7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105cec:	89 1c 24             	mov    %ebx,(%esp)
80105cef:	e8 2c ba ff ff       	call   80101720 <iupdate>
  iunlockput(ip);
80105cf4:	89 1c 24             	mov    %ebx,(%esp)
80105cf7:	e8 64 bd ff ff       	call   80101a60 <iunlockput>
  end_op();
80105cfc:	e8 df d0 ff ff       	call   80102de0 <end_op>
  return 0;
80105d01:	83 c4 10             	add    $0x10,%esp
80105d04:	31 c0                	xor    %eax,%eax
}
80105d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d09:	5b                   	pop    %ebx
80105d0a:	5e                   	pop    %esi
80105d0b:	5f                   	pop    %edi
80105d0c:	5d                   	pop    %ebp
80105d0d:	c3                   	ret
80105d0e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105d10:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105d14:	76 94                	jbe    80105caa <sys_unlink+0xba>
80105d16:	be 20 00 00 00       	mov    $0x20,%esi
80105d1b:	eb 0b                	jmp    80105d28 <sys_unlink+0x138>
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi
80105d20:	83 c6 10             	add    $0x10,%esi
80105d23:	3b 73 58             	cmp    0x58(%ebx),%esi
80105d26:	73 82                	jae    80105caa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d28:	6a 10                	push   $0x10
80105d2a:	56                   	push   %esi
80105d2b:	57                   	push   %edi
80105d2c:	53                   	push   %ebx
80105d2d:	e8 ae bd ff ff       	call   80101ae0 <readi>
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	83 f8 10             	cmp    $0x10,%eax
80105d38:	75 56                	jne    80105d90 <sys_unlink+0x1a0>
    if(de.inum != 0)
80105d3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105d3f:	74 df                	je     80105d20 <sys_unlink+0x130>
    iunlockput(ip);
80105d41:	83 ec 0c             	sub    $0xc,%esp
80105d44:	53                   	push   %ebx
80105d45:	e8 16 bd ff ff       	call   80101a60 <iunlockput>
    goto bad;
80105d4a:	83 c4 10             	add    $0x10,%esp
80105d4d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105d50:	83 ec 0c             	sub    $0xc,%esp
80105d53:	ff 75 b4             	push   -0x4c(%ebp)
80105d56:	e8 05 bd ff ff       	call   80101a60 <iunlockput>
  end_op();
80105d5b:	e8 80 d0 ff ff       	call   80102de0 <end_op>
  return -1;
80105d60:	83 c4 10             	add    $0x10,%esp
    return -1;
80105d63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d68:	eb 9c                	jmp    80105d06 <sys_unlink+0x116>
80105d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105d70:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105d73:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105d76:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105d7b:	50                   	push   %eax
80105d7c:	e8 9f b9 ff ff       	call   80101720 <iupdate>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	e9 53 ff ff ff       	jmp    80105cdc <sys_unlink+0xec>
    end_op();
80105d89:	e8 52 d0 ff ff       	call   80102de0 <end_op>
    return -1;
80105d8e:	eb d3                	jmp    80105d63 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105d90:	83 ec 0c             	sub    $0xc,%esp
80105d93:	68 96 84 10 80       	push   $0x80108496
80105d98:	e8 e3 a5 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105d9d:	83 ec 0c             	sub    $0xc,%esp
80105da0:	68 a8 84 10 80       	push   $0x801084a8
80105da5:	e8 d6 a5 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105daa:	83 ec 0c             	sub    $0xc,%esp
80105dad:	68 84 84 10 80       	push   $0x80108484
80105db2:	e8 c9 a5 ff ff       	call   80100380 <panic>
80105db7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dbe:	00 
80105dbf:	90                   	nop

80105dc0 <sys_open>:

int
sys_open(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	57                   	push   %edi
80105dc4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105dc5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105dc8:	53                   	push   %ebx
80105dc9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105dcc:	50                   	push   %eax
80105dcd:	6a 00                	push   $0x0
80105dcf:	e8 1c f8 ff ff       	call   801055f0 <argstr>
80105dd4:	83 c4 10             	add    $0x10,%esp
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	0f 88 8e 00 00 00    	js     80105e6d <sys_open+0xad>
80105ddf:	83 ec 08             	sub    $0x8,%esp
80105de2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105de5:	50                   	push   %eax
80105de6:	6a 01                	push   $0x1
80105de8:	e8 43 f7 ff ff       	call   80105530 <argint>
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	85 c0                	test   %eax,%eax
80105df2:	78 79                	js     80105e6d <sys_open+0xad>
    return -1;

  begin_op();
80105df4:	e8 77 cf ff ff       	call   80102d70 <begin_op>

  if(omode & O_CREATE){
80105df9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105dfd:	75 79                	jne    80105e78 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105dff:	83 ec 0c             	sub    $0xc,%esp
80105e02:	ff 75 e0             	push   -0x20(%ebp)
80105e05:	e8 a6 c2 ff ff       	call   801020b0 <namei>
80105e0a:	83 c4 10             	add    $0x10,%esp
80105e0d:	89 c6                	mov    %eax,%esi
80105e0f:	85 c0                	test   %eax,%eax
80105e11:	0f 84 7e 00 00 00    	je     80105e95 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105e17:	83 ec 0c             	sub    $0xc,%esp
80105e1a:	50                   	push   %eax
80105e1b:	e8 b0 b9 ff ff       	call   801017d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e20:	83 c4 10             	add    $0x10,%esp
80105e23:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105e28:	0f 84 ba 00 00 00    	je     80105ee8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e2e:	e8 4d b0 ff ff       	call   80100e80 <filealloc>
80105e33:	89 c7                	mov    %eax,%edi
80105e35:	85 c0                	test   %eax,%eax
80105e37:	74 23                	je     80105e5c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105e39:	e8 72 dc ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e3e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105e40:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105e44:	85 d2                	test   %edx,%edx
80105e46:	74 58                	je     80105ea0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105e48:	83 c3 01             	add    $0x1,%ebx
80105e4b:	83 fb 10             	cmp    $0x10,%ebx
80105e4e:	75 f0                	jne    80105e40 <sys_open+0x80>
    if(f)
      fileclose(f);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	57                   	push   %edi
80105e54:	e8 e7 b0 ff ff       	call   80100f40 <fileclose>
80105e59:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105e5c:	83 ec 0c             	sub    $0xc,%esp
80105e5f:	56                   	push   %esi
80105e60:	e8 fb bb ff ff       	call   80101a60 <iunlockput>
    end_op();
80105e65:	e8 76 cf ff ff       	call   80102de0 <end_op>
    return -1;
80105e6a:	83 c4 10             	add    $0x10,%esp
    return -1;
80105e6d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e72:	eb 65                	jmp    80105ed9 <sys_open+0x119>
80105e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105e78:	83 ec 0c             	sub    $0xc,%esp
80105e7b:	31 c9                	xor    %ecx,%ecx
80105e7d:	ba 02 00 00 00       	mov    $0x2,%edx
80105e82:	6a 00                	push   $0x0
80105e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105e87:	e8 54 f8 ff ff       	call   801056e0 <create>
    if(ip == 0){
80105e8c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105e8f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105e91:	85 c0                	test   %eax,%eax
80105e93:	75 99                	jne    80105e2e <sys_open+0x6e>
      end_op();
80105e95:	e8 46 cf ff ff       	call   80102de0 <end_op>
      return -1;
80105e9a:	eb d1                	jmp    80105e6d <sys_open+0xad>
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105ea3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105ea7:	56                   	push   %esi
80105ea8:	e8 03 ba ff ff       	call   801018b0 <iunlock>
  end_op();
80105ead:	e8 2e cf ff ff       	call   80102de0 <end_op>

  f->type = FD_INODE;
80105eb2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105eb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ebb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ebe:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105ec1:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105ec3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105eca:	f7 d0                	not    %eax
80105ecc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ecf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105ed2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ed5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105ed9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105edc:	89 d8                	mov    %ebx,%eax
80105ede:	5b                   	pop    %ebx
80105edf:	5e                   	pop    %esi
80105ee0:	5f                   	pop    %edi
80105ee1:	5d                   	pop    %ebp
80105ee2:	c3                   	ret
80105ee3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ee8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105eeb:	85 c9                	test   %ecx,%ecx
80105eed:	0f 84 3b ff ff ff    	je     80105e2e <sys_open+0x6e>
80105ef3:	e9 64 ff ff ff       	jmp    80105e5c <sys_open+0x9c>
80105ef8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105eff:	00 

80105f00 <sys_mkdir>:

int
sys_mkdir(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105f06:	e8 65 ce ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f0b:	83 ec 08             	sub    $0x8,%esp
80105f0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f11:	50                   	push   %eax
80105f12:	6a 00                	push   $0x0
80105f14:	e8 d7 f6 ff ff       	call   801055f0 <argstr>
80105f19:	83 c4 10             	add    $0x10,%esp
80105f1c:	85 c0                	test   %eax,%eax
80105f1e:	78 30                	js     80105f50 <sys_mkdir+0x50>
80105f20:	83 ec 0c             	sub    $0xc,%esp
80105f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f26:	31 c9                	xor    %ecx,%ecx
80105f28:	ba 01 00 00 00       	mov    $0x1,%edx
80105f2d:	6a 00                	push   $0x0
80105f2f:	e8 ac f7 ff ff       	call   801056e0 <create>
80105f34:	83 c4 10             	add    $0x10,%esp
80105f37:	85 c0                	test   %eax,%eax
80105f39:	74 15                	je     80105f50 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f3b:	83 ec 0c             	sub    $0xc,%esp
80105f3e:	50                   	push   %eax
80105f3f:	e8 1c bb ff ff       	call   80101a60 <iunlockput>
  end_op();
80105f44:	e8 97 ce ff ff       	call   80102de0 <end_op>
  return 0;
80105f49:	83 c4 10             	add    $0x10,%esp
80105f4c:	31 c0                	xor    %eax,%eax
}
80105f4e:	c9                   	leave
80105f4f:	c3                   	ret
    end_op();
80105f50:	e8 8b ce ff ff       	call   80102de0 <end_op>
    return -1;
80105f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f5a:	c9                   	leave
80105f5b:	c3                   	ret
80105f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_mknod>:

int
sys_mknod(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f66:	e8 05 ce ff ff       	call   80102d70 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f6b:	83 ec 08             	sub    $0x8,%esp
80105f6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f71:	50                   	push   %eax
80105f72:	6a 00                	push   $0x0
80105f74:	e8 77 f6 ff ff       	call   801055f0 <argstr>
80105f79:	83 c4 10             	add    $0x10,%esp
80105f7c:	85 c0                	test   %eax,%eax
80105f7e:	78 60                	js     80105fe0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105f80:	83 ec 08             	sub    $0x8,%esp
80105f83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f86:	50                   	push   %eax
80105f87:	6a 01                	push   $0x1
80105f89:	e8 a2 f5 ff ff       	call   80105530 <argint>
  if((argstr(0, &path)) < 0 ||
80105f8e:	83 c4 10             	add    $0x10,%esp
80105f91:	85 c0                	test   %eax,%eax
80105f93:	78 4b                	js     80105fe0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105f95:	83 ec 08             	sub    $0x8,%esp
80105f98:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f9b:	50                   	push   %eax
80105f9c:	6a 02                	push   $0x2
80105f9e:	e8 8d f5 ff ff       	call   80105530 <argint>
     argint(1, &major) < 0 ||
80105fa3:	83 c4 10             	add    $0x10,%esp
80105fa6:	85 c0                	test   %eax,%eax
80105fa8:	78 36                	js     80105fe0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105faa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105fae:	83 ec 0c             	sub    $0xc,%esp
80105fb1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105fb5:	ba 03 00 00 00       	mov    $0x3,%edx
80105fba:	50                   	push   %eax
80105fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105fbe:	e8 1d f7 ff ff       	call   801056e0 <create>
     argint(2, &minor) < 0 ||
80105fc3:	83 c4 10             	add    $0x10,%esp
80105fc6:	85 c0                	test   %eax,%eax
80105fc8:	74 16                	je     80105fe0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105fca:	83 ec 0c             	sub    $0xc,%esp
80105fcd:	50                   	push   %eax
80105fce:	e8 8d ba ff ff       	call   80101a60 <iunlockput>
  end_op();
80105fd3:	e8 08 ce ff ff       	call   80102de0 <end_op>
  return 0;
80105fd8:	83 c4 10             	add    $0x10,%esp
80105fdb:	31 c0                	xor    %eax,%eax
}
80105fdd:	c9                   	leave
80105fde:	c3                   	ret
80105fdf:	90                   	nop
    end_op();
80105fe0:	e8 fb cd ff ff       	call   80102de0 <end_op>
    return -1;
80105fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fea:	c9                   	leave
80105feb:	c3                   	ret
80105fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ff0 <sys_chdir>:

int
sys_chdir(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	56                   	push   %esi
80105ff4:	53                   	push   %ebx
80105ff5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ff8:	e8 b3 da ff ff       	call   80103ab0 <myproc>
80105ffd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105fff:	e8 6c cd ff ff       	call   80102d70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106004:	83 ec 08             	sub    $0x8,%esp
80106007:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010600a:	50                   	push   %eax
8010600b:	6a 00                	push   $0x0
8010600d:	e8 de f5 ff ff       	call   801055f0 <argstr>
80106012:	83 c4 10             	add    $0x10,%esp
80106015:	85 c0                	test   %eax,%eax
80106017:	78 77                	js     80106090 <sys_chdir+0xa0>
80106019:	83 ec 0c             	sub    $0xc,%esp
8010601c:	ff 75 f4             	push   -0xc(%ebp)
8010601f:	e8 8c c0 ff ff       	call   801020b0 <namei>
80106024:	83 c4 10             	add    $0x10,%esp
80106027:	89 c3                	mov    %eax,%ebx
80106029:	85 c0                	test   %eax,%eax
8010602b:	74 63                	je     80106090 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010602d:	83 ec 0c             	sub    $0xc,%esp
80106030:	50                   	push   %eax
80106031:	e8 9a b7 ff ff       	call   801017d0 <ilock>
  if(ip->type != T_DIR){
80106036:	83 c4 10             	add    $0x10,%esp
80106039:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010603e:	75 30                	jne    80106070 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106040:	83 ec 0c             	sub    $0xc,%esp
80106043:	53                   	push   %ebx
80106044:	e8 67 b8 ff ff       	call   801018b0 <iunlock>
  iput(curproc->cwd);
80106049:	58                   	pop    %eax
8010604a:	ff 76 68             	push   0x68(%esi)
8010604d:	e8 ae b8 ff ff       	call   80101900 <iput>
  end_op();
80106052:	e8 89 cd ff ff       	call   80102de0 <end_op>
  curproc->cwd = ip;
80106057:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010605a:	83 c4 10             	add    $0x10,%esp
8010605d:	31 c0                	xor    %eax,%eax
}
8010605f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106062:	5b                   	pop    %ebx
80106063:	5e                   	pop    %esi
80106064:	5d                   	pop    %ebp
80106065:	c3                   	ret
80106066:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010606d:	00 
8010606e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	53                   	push   %ebx
80106074:	e8 e7 b9 ff ff       	call   80101a60 <iunlockput>
    end_op();
80106079:	e8 62 cd ff ff       	call   80102de0 <end_op>
    return -1;
8010607e:	83 c4 10             	add    $0x10,%esp
    return -1;
80106081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106086:	eb d7                	jmp    8010605f <sys_chdir+0x6f>
80106088:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010608f:	00 
    end_op();
80106090:	e8 4b cd ff ff       	call   80102de0 <end_op>
    return -1;
80106095:	eb ea                	jmp    80106081 <sys_chdir+0x91>
80106097:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010609e:	00 
8010609f:	90                   	nop

801060a0 <sys_exec>:

int
sys_exec(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	57                   	push   %edi
801060a4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060a5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801060ab:	53                   	push   %ebx
801060ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060b2:	50                   	push   %eax
801060b3:	6a 00                	push   $0x0
801060b5:	e8 36 f5 ff ff       	call   801055f0 <argstr>
801060ba:	83 c4 10             	add    $0x10,%esp
801060bd:	85 c0                	test   %eax,%eax
801060bf:	0f 88 87 00 00 00    	js     8010614c <sys_exec+0xac>
801060c5:	83 ec 08             	sub    $0x8,%esp
801060c8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801060ce:	50                   	push   %eax
801060cf:	6a 01                	push   $0x1
801060d1:	e8 5a f4 ff ff       	call   80105530 <argint>
801060d6:	83 c4 10             	add    $0x10,%esp
801060d9:	85 c0                	test   %eax,%eax
801060db:	78 6f                	js     8010614c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801060dd:	83 ec 04             	sub    $0x4,%esp
801060e0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801060e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801060e8:	68 80 00 00 00       	push   $0x80
801060ed:	6a 00                	push   $0x0
801060ef:	56                   	push   %esi
801060f0:	e8 8b f1 ff ff       	call   80105280 <memset>
801060f5:	83 c4 10             	add    $0x10,%esp
801060f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801060ff:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106100:	83 ec 08             	sub    $0x8,%esp
80106103:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106109:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106110:	50                   	push   %eax
80106111:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106117:	01 f8                	add    %edi,%eax
80106119:	50                   	push   %eax
8010611a:	e8 81 f3 ff ff       	call   801054a0 <fetchint>
8010611f:	83 c4 10             	add    $0x10,%esp
80106122:	85 c0                	test   %eax,%eax
80106124:	78 26                	js     8010614c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106126:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010612c:	85 c0                	test   %eax,%eax
8010612e:	74 30                	je     80106160 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106130:	83 ec 08             	sub    $0x8,%esp
80106133:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106136:	52                   	push   %edx
80106137:	50                   	push   %eax
80106138:	e8 a3 f3 ff ff       	call   801054e0 <fetchstr>
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	85 c0                	test   %eax,%eax
80106142:	78 08                	js     8010614c <sys_exec+0xac>
  for(i=0;; i++){
80106144:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106147:	83 fb 20             	cmp    $0x20,%ebx
8010614a:	75 b4                	jne    80106100 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010614c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010614f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106154:	5b                   	pop    %ebx
80106155:	5e                   	pop    %esi
80106156:	5f                   	pop    %edi
80106157:	5d                   	pop    %ebp
80106158:	c3                   	ret
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106160:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106167:	00 00 00 00 
  return exec(path, argv);
8010616b:	83 ec 08             	sub    $0x8,%esp
8010616e:	56                   	push   %esi
8010616f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106175:	e8 36 a9 ff ff       	call   80100ab0 <exec>
8010617a:	83 c4 10             	add    $0x10,%esp
}
8010617d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106180:	5b                   	pop    %ebx
80106181:	5e                   	pop    %esi
80106182:	5f                   	pop    %edi
80106183:	5d                   	pop    %ebp
80106184:	c3                   	ret
80106185:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010618c:	00 
8010618d:	8d 76 00             	lea    0x0(%esi),%esi

80106190 <sys_pipe>:

int
sys_pipe(void)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	57                   	push   %edi
80106194:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106195:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106198:	53                   	push   %ebx
80106199:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010619c:	6a 08                	push   $0x8
8010619e:	50                   	push   %eax
8010619f:	6a 00                	push   $0x0
801061a1:	e8 da f3 ff ff       	call   80105580 <argptr>
801061a6:	83 c4 10             	add    $0x10,%esp
801061a9:	85 c0                	test   %eax,%eax
801061ab:	0f 88 8b 00 00 00    	js     8010623c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801061b1:	83 ec 08             	sub    $0x8,%esp
801061b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061b7:	50                   	push   %eax
801061b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061bb:	50                   	push   %eax
801061bc:	e8 7f d2 ff ff       	call   80103440 <pipealloc>
801061c1:	83 c4 10             	add    $0x10,%esp
801061c4:	85 c0                	test   %eax,%eax
801061c6:	78 74                	js     8010623c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801061cb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801061cd:	e8 de d8 ff ff       	call   80103ab0 <myproc>
    if(curproc->ofile[fd] == 0){
801061d2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801061d6:	85 f6                	test   %esi,%esi
801061d8:	74 16                	je     801061f0 <sys_pipe+0x60>
801061da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801061e0:	83 c3 01             	add    $0x1,%ebx
801061e3:	83 fb 10             	cmp    $0x10,%ebx
801061e6:	74 3d                	je     80106225 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801061e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801061ec:	85 f6                	test   %esi,%esi
801061ee:	75 f0                	jne    801061e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801061f0:	8d 73 08             	lea    0x8(%ebx),%esi
801061f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801061fa:	e8 b1 d8 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801061ff:	31 d2                	xor    %edx,%edx
80106201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106208:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010620c:	85 c9                	test   %ecx,%ecx
8010620e:	74 38                	je     80106248 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80106210:	83 c2 01             	add    $0x1,%edx
80106213:	83 fa 10             	cmp    $0x10,%edx
80106216:	75 f0                	jne    80106208 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80106218:	e8 93 d8 ff ff       	call   80103ab0 <myproc>
8010621d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106224:	00 
    fileclose(rf);
80106225:	83 ec 0c             	sub    $0xc,%esp
80106228:	ff 75 e0             	push   -0x20(%ebp)
8010622b:	e8 10 ad ff ff       	call   80100f40 <fileclose>
    fileclose(wf);
80106230:	58                   	pop    %eax
80106231:	ff 75 e4             	push   -0x1c(%ebp)
80106234:	e8 07 ad ff ff       	call   80100f40 <fileclose>
    return -1;
80106239:	83 c4 10             	add    $0x10,%esp
    return -1;
8010623c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106241:	eb 16                	jmp    80106259 <sys_pipe+0xc9>
80106243:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80106248:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010624c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010624f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106251:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106254:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106257:	31 c0                	xor    %eax,%eax
}
80106259:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010625c:	5b                   	pop    %ebx
8010625d:	5e                   	pop    %esi
8010625e:	5f                   	pop    %edi
8010625f:	5d                   	pop    %ebp
80106260:	c3                   	ret
80106261:	66 90                	xchg   %ax,%ax
80106263:	66 90                	xchg   %ax,%ax
80106265:	66 90                	xchg   %ax,%ax
80106267:	66 90                	xchg   %ax,%ax
80106269:	66 90                	xchg   %ax,%ax
8010626b:	66 90                	xchg   %ax,%ax
8010626d:	66 90                	xchg   %ax,%ax
8010626f:	90                   	nop

80106270 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106270:	e9 6b da ff ff       	jmp    80103ce0 <fork>
80106275:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010627c:	00 
8010627d:	8d 76 00             	lea    0x0(%esi),%esi

80106280 <sys_exit>:
}

int
sys_exit(void)
{
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	83 ec 08             	sub    $0x8,%esp
  exit();
80106286:	e8 f5 de ff ff       	call   80104180 <exit>
  return 0;  // not reached
}
8010628b:	31 c0                	xor    %eax,%eax
8010628d:	c9                   	leave
8010628e:	c3                   	ret
8010628f:	90                   	nop

80106290 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106290:	e9 cb e2 ff ff       	jmp    80104560 <wait>
80106295:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010629c:	00 
8010629d:	8d 76 00             	lea    0x0(%esi),%esi

801062a0 <sys_kill>:
}

int
sys_kill(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801062a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062a9:	50                   	push   %eax
801062aa:	6a 00                	push   $0x0
801062ac:	e8 7f f2 ff ff       	call   80105530 <argint>
801062b1:	83 c4 10             	add    $0x10,%esp
801062b4:	85 c0                	test   %eax,%eax
801062b6:	78 18                	js     801062d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801062b8:	83 ec 0c             	sub    $0xc,%esp
801062bb:	ff 75 f4             	push   -0xc(%ebp)
801062be:	e8 cd e3 ff ff       	call   80104690 <kill>
801062c3:	83 c4 10             	add    $0x10,%esp
}
801062c6:	c9                   	leave
801062c7:	c3                   	ret
801062c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801062cf:	00 
801062d0:	c9                   	leave
    return -1;
801062d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062d6:	c3                   	ret
801062d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801062de:	00 
801062df:	90                   	nop

801062e0 <sys_getpid>:

int
sys_getpid(void)
{
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801062e6:	e8 c5 d7 ff ff       	call   80103ab0 <myproc>
801062eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801062ee:	c9                   	leave
801062ef:	c3                   	ret

801062f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801062f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801062f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801062fa:	50                   	push   %eax
801062fb:	6a 00                	push   $0x0
801062fd:	e8 2e f2 ff ff       	call   80105530 <argint>
80106302:	83 c4 10             	add    $0x10,%esp
80106305:	85 c0                	test   %eax,%eax
80106307:	78 27                	js     80106330 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106309:	e8 a2 d7 ff ff       	call   80103ab0 <myproc>
  if(growproc(n) < 0)
8010630e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106311:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106313:	ff 75 f4             	push   -0xc(%ebp)
80106316:	e8 45 d9 ff ff       	call   80103c60 <growproc>
8010631b:	83 c4 10             	add    $0x10,%esp
8010631e:	85 c0                	test   %eax,%eax
80106320:	78 0e                	js     80106330 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106322:	89 d8                	mov    %ebx,%eax
80106324:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106327:	c9                   	leave
80106328:	c3                   	ret
80106329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106330:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106335:	eb eb                	jmp    80106322 <sys_sbrk+0x32>
80106337:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010633e:	00 
8010633f:	90                   	nop

80106340 <sys_sleep>:

int
sys_sleep(void)
{
80106340:	55                   	push   %ebp
80106341:	89 e5                	mov    %esp,%ebp
80106343:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106344:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106347:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010634a:	50                   	push   %eax
8010634b:	6a 00                	push   $0x0
8010634d:	e8 de f1 ff ff       	call   80105530 <argint>
80106352:	83 c4 10             	add    $0x10,%esp
80106355:	85 c0                	test   %eax,%eax
80106357:	78 64                	js     801063bd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80106359:	83 ec 0c             	sub    $0xc,%esp
8010635c:	68 a0 56 11 80       	push   $0x801156a0
80106361:	e8 1a ee ff ff       	call   80105180 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106366:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106369:	8b 1d 80 56 11 80    	mov    0x80115680,%ebx
  while(ticks - ticks0 < n){
8010636f:	83 c4 10             	add    $0x10,%esp
80106372:	85 d2                	test   %edx,%edx
80106374:	75 2b                	jne    801063a1 <sys_sleep+0x61>
80106376:	eb 58                	jmp    801063d0 <sys_sleep+0x90>
80106378:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010637f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106380:	83 ec 08             	sub    $0x8,%esp
80106383:	68 a0 56 11 80       	push   $0x801156a0
80106388:	68 80 56 11 80       	push   $0x80115680
8010638d:	e8 5e e0 ff ff       	call   801043f0 <sleep>
  while(ticks - ticks0 < n){
80106392:	a1 80 56 11 80       	mov    0x80115680,%eax
80106397:	83 c4 10             	add    $0x10,%esp
8010639a:	29 d8                	sub    %ebx,%eax
8010639c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010639f:	73 2f                	jae    801063d0 <sys_sleep+0x90>
    if(myproc()->killed){
801063a1:	e8 0a d7 ff ff       	call   80103ab0 <myproc>
801063a6:	8b 40 24             	mov    0x24(%eax),%eax
801063a9:	85 c0                	test   %eax,%eax
801063ab:	74 d3                	je     80106380 <sys_sleep+0x40>
      release(&tickslock);
801063ad:	83 ec 0c             	sub    $0xc,%esp
801063b0:	68 a0 56 11 80       	push   $0x801156a0
801063b5:	e8 66 ed ff ff       	call   80105120 <release>
      return -1;
801063ba:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801063bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801063c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063c5:	c9                   	leave
801063c6:	c3                   	ret
801063c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063ce:	00 
801063cf:	90                   	nop
  release(&tickslock);
801063d0:	83 ec 0c             	sub    $0xc,%esp
801063d3:	68 a0 56 11 80       	push   $0x801156a0
801063d8:	e8 43 ed ff ff       	call   80105120 <release>
}
801063dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
801063e0:	83 c4 10             	add    $0x10,%esp
801063e3:	31 c0                	xor    %eax,%eax
}
801063e5:	c9                   	leave
801063e6:	c3                   	ret
801063e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801063ee:	00 
801063ef:	90                   	nop

801063f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
801063f3:	53                   	push   %ebx
801063f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801063f7:	68 a0 56 11 80       	push   $0x801156a0
801063fc:	e8 7f ed ff ff       	call   80105180 <acquire>
  xticks = ticks;
80106401:	8b 1d 80 56 11 80    	mov    0x80115680,%ebx
  release(&tickslock);
80106407:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
8010640e:	e8 0d ed ff ff       	call   80105120 <release>
  return xticks;
}
80106413:	89 d8                	mov    %ebx,%eax
80106415:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106418:	c9                   	leave
80106419:	c3                   	ret
8010641a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106420 <sys_set_process_deadline>:
extern int is_higher_waiting(void);
extern int set_deadline_for_process(int pid, int deadline);

int
sys_set_process_deadline(void)
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	83 ec 20             	sub    $0x20,%esp
  int deadline;
  if (argint(0, &deadline) < 0)
80106426:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106429:	50                   	push   %eax
8010642a:	6a 00                	push   $0x0
8010642c:	e8 ff f0 ff ff       	call   80105530 <argint>
80106431:	83 c4 10             	add    $0x10,%esp
80106434:	85 c0                	test   %eax,%eax
80106436:	78 18                	js     80106450 <sys_set_process_deadline+0x30>
    return -1;
  return set_process_deadline(deadline);
80106438:	83 ec 0c             	sub    $0xc,%esp
8010643b:	ff 75 f4             	push   -0xc(%ebp)
8010643e:	e8 1d e4 ff ff       	call   80104860 <set_process_deadline>
80106443:	83 c4 10             	add    $0x10,%esp
}
80106446:	c9                   	leave
80106447:	c3                   	ret
80106448:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010644f:	00 
80106450:	c9                   	leave
    return -1;
80106451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106456:	c3                   	ret
80106457:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010645e:	00 
8010645f:	90                   	nop

80106460 <sys_set_deadline_for_process>:

int
sys_set_deadline_for_process(void)
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	83 ec 20             	sub    $0x20,%esp
  int pid, deadline;
  if (argint(0, &pid) < 0 || argint(1, &deadline) < 0)
80106466:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106469:	50                   	push   %eax
8010646a:	6a 00                	push   $0x0
8010646c:	e8 bf f0 ff ff       	call   80105530 <argint>
80106471:	83 c4 10             	add    $0x10,%esp
80106474:	85 c0                	test   %eax,%eax
80106476:	78 28                	js     801064a0 <sys_set_deadline_for_process+0x40>
80106478:	83 ec 08             	sub    $0x8,%esp
8010647b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010647e:	50                   	push   %eax
8010647f:	6a 01                	push   $0x1
80106481:	e8 aa f0 ff ff       	call   80105530 <argint>
80106486:	83 c4 10             	add    $0x10,%esp
80106489:	85 c0                	test   %eax,%eax
8010648b:	78 13                	js     801064a0 <sys_set_deadline_for_process+0x40>
    return -1;
  return set_deadline_for_process(pid, deadline);
8010648d:	83 ec 08             	sub    $0x8,%esp
80106490:	ff 75 f4             	push   -0xc(%ebp)
80106493:	ff 75 f0             	push   -0x10(%ebp)
80106496:	e8 15 e4 ff ff       	call   801048b0 <set_deadline_for_process>
8010649b:	83 c4 10             	add    $0x10,%esp
}
8010649e:	c9                   	leave
8010649f:	c3                   	ret
801064a0:	c9                   	leave
    return -1;
801064a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064a6:	c3                   	ret
801064a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801064ae:	00 
801064af:	90                   	nop

801064b0 <sys_change_sched_level>:

int sys_change_sched_level(void) {
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	83 ec 20             	sub    $0x20,%esp
  int pid, target;
  if (argint(0, &pid) < 0 || argint(1, &target) < 0)
801064b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064b9:	50                   	push   %eax
801064ba:	6a 00                	push   $0x0
801064bc:	e8 6f f0 ff ff       	call   80105530 <argint>
801064c1:	83 c4 10             	add    $0x10,%esp
801064c4:	85 c0                	test   %eax,%eax
801064c6:	78 28                	js     801064f0 <sys_change_sched_level+0x40>
801064c8:	83 ec 08             	sub    $0x8,%esp
801064cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064ce:	50                   	push   %eax
801064cf:	6a 01                	push   $0x1
801064d1:	e8 5a f0 ff ff       	call   80105530 <argint>
801064d6:	83 c4 10             	add    $0x10,%esp
801064d9:	85 c0                	test   %eax,%eax
801064db:	78 13                	js     801064f0 <sys_change_sched_level+0x40>
    return -1;
  return change_sched_level(pid, target);
801064dd:	83 ec 08             	sub    $0x8,%esp
801064e0:	ff 75 f4             	push   -0xc(%ebp)
801064e3:	ff 75 f0             	push   -0x10(%ebp)
801064e6:	e8 c5 e4 ff ff       	call   801049b0 <change_sched_level>
801064eb:	83 c4 10             	add    $0x10,%esp
}
801064ee:	c9                   	leave
801064ef:	c3                   	ret
801064f0:	c9                   	leave
    return -1;
801064f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064f6:	c3                   	ret
801064f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801064fe:	00 
801064ff:	90                   	nop

80106500 <sys_print_sched_info>:

int
sys_print_sched_info(void)
{
  return print_sched_info();
80106500:	e9 bb e6 ff ff       	jmp    80104bc0 <print_sched_info>
80106505:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010650c:	00 
8010650d:	8d 76 00             	lea    0x0(%esi),%esi

80106510 <sys_update_wait_time>:
}

int
sys_update_wait_time(void){
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	83 ec 20             	sub    $0x20,%esp
  int osTicks;
  if (argint(0, &osTicks) < 0)
80106516:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106519:	50                   	push   %eax
8010651a:	6a 00                	push   $0x0
8010651c:	e8 0f f0 ff ff       	call   80105530 <argint>
80106521:	83 c4 10             	add    $0x10,%esp
80106524:	85 c0                	test   %eax,%eax
80106526:	78 18                	js     80106540 <sys_update_wait_time+0x30>
    return -1;
  return update_wait_time(osTicks);
80106528:	83 ec 0c             	sub    $0xc,%esp
8010652b:	ff 75 f4             	push   -0xc(%ebp)
8010652e:	e8 9d e5 ff ff       	call   80104ad0 <update_wait_time>
80106533:	83 c4 10             	add    $0x10,%esp
}
80106536:	c9                   	leave
80106537:	c3                   	ret
80106538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010653f:	00 
80106540:	c9                   	leave
    return -1;
80106541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106546:	c3                   	ret
80106547:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010654e:	00 
8010654f:	90                   	nop

80106550 <sys_is_higher_waiting>:

int
sys_is_higher_waiting(void){
  return  is_higher_waiting();
80106550:	e9 2b e6 ff ff       	jmp    80104b80 <is_higher_waiting>

80106555 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106555:	1e                   	push   %ds
  pushl %es
80106556:	06                   	push   %es
  pushl %fs
80106557:	0f a0                	push   %fs
  pushl %gs
80106559:	0f a8                	push   %gs
  pushal
8010655b:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010655c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106560:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106562:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106564:	54                   	push   %esp
  call trap
80106565:	e8 c6 00 00 00       	call   80106630 <trap>
  addl $4, %esp
8010656a:	83 c4 04             	add    $0x4,%esp

8010656d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010656d:	61                   	popa
  popl %gs
8010656e:	0f a9                	pop    %gs
  popl %fs
80106570:	0f a1                	pop    %fs
  popl %es
80106572:	07                   	pop    %es
  popl %ds
80106573:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106574:	83 c4 08             	add    $0x8,%esp
  iret
80106577:	cf                   	iret
80106578:	66 90                	xchg   %ax,%ax
8010657a:	66 90                	xchg   %ax,%ax
8010657c:	66 90                	xchg   %ax,%ax
8010657e:	66 90                	xchg   %ax,%ax

80106580 <tvinit>:
extern uint vectors[]; // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void)
{
80106580:	55                   	push   %ebp
  int i;

  for (i = 0; i < 256; i++)
80106581:	31 c0                	xor    %eax,%eax
{
80106583:	89 e5                	mov    %esp,%ebp
80106585:	83 ec 08             	sub    $0x8,%esp
80106588:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010658f:	00 
    SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106590:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80106597:	c7 04 c5 e2 56 11 80 	movl   $0x8e000008,-0x7feea91e(,%eax,8)
8010659e:	08 00 00 8e 
801065a2:	66 89 14 c5 e0 56 11 	mov    %dx,-0x7feea920(,%eax,8)
801065a9:	80 
801065aa:	c1 ea 10             	shr    $0x10,%edx
801065ad:	66 89 14 c5 e6 56 11 	mov    %dx,-0x7feea91a(,%eax,8)
801065b4:	80 
  for (i = 0; i < 256; i++)
801065b5:	83 c0 01             	add    $0x1,%eax
801065b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801065bd:	75 d1                	jne    80106590 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801065bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801065c2:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
801065c7:	c7 05 e2 58 11 80 08 	movl   $0xef000008,0x801158e2
801065ce:	00 00 ef 
  initlock(&tickslock, "time");
801065d1:	68 b7 84 10 80       	push   $0x801084b7
801065d6:	68 a0 56 11 80       	push   $0x801156a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801065db:	66 a3 e0 58 11 80    	mov    %ax,0x801158e0
801065e1:	c1 e8 10             	shr    $0x10,%eax
801065e4:	66 a3 e6 58 11 80    	mov    %ax,0x801158e6
  initlock(&tickslock, "time");
801065ea:	e8 a1 e9 ff ff       	call   80104f90 <initlock>
}
801065ef:	83 c4 10             	add    $0x10,%esp
801065f2:	c9                   	leave
801065f3:	c3                   	ret
801065f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801065fb:	00 
801065fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106600 <idtinit>:

void idtinit(void)
{
80106600:	55                   	push   %ebp
  pd[0] = size-1;
80106601:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106606:	89 e5                	mov    %esp,%ebp
80106608:	83 ec 10             	sub    $0x10,%esp
8010660b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010660f:	b8 e0 56 11 80       	mov    $0x801156e0,%eax
80106614:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106618:	c1 e8 10             	shr    $0x10,%eax
8010661b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010661f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106622:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106625:	c9                   	leave
80106626:	c3                   	ret
80106627:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010662e:	00 
8010662f:	90                   	nop

80106630 <trap>:

// PAGEBREAK: 41
void trap(struct trapframe *tf)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	57                   	push   %edi
80106634:	56                   	push   %esi
80106635:	53                   	push   %ebx
80106636:	83 ec 1c             	sub    $0x1c,%esp
80106639:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (tf->trapno == T_SYSCALL)
8010663c:	8b 43 30             	mov    0x30(%ebx),%eax
8010663f:	83 f8 40             	cmp    $0x40,%eax
80106642:	0f 84 c8 01 00 00    	je     80106810 <trap+0x1e0>
    syscall();
    if (myproc()->killed)
      exit();
    return;
  }
  switch (tf->trapno)
80106648:	83 e8 20             	sub    $0x20,%eax
8010664b:	83 f8 1f             	cmp    $0x1f,%eax
8010664e:	0f 87 7c 00 00 00    	ja     801066d0 <trap+0xa0>
80106654:	ff 24 85 d4 8b 10 80 	jmp    *-0x7fef742c(,%eax,4)
8010665b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    }
    // cprintf("\n current proc: %s" , myproc()->name);
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106660:	e8 fb bb ff ff       	call   80102260 <ideintr>
    lapiceoi();
80106665:	e8 b6 c2 ff ff       	call   80102920 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010666a:	e8 41 d4 ff ff       	call   80103ab0 <myproc>
8010666f:	85 c0                	test   %eax,%eax
80106671:	74 1a                	je     8010668d <trap+0x5d>
80106673:	e8 38 d4 ff ff       	call   80103ab0 <myproc>
80106678:	8b 48 24             	mov    0x24(%eax),%ecx
8010667b:	85 c9                	test   %ecx,%ecx
8010667d:	74 0e                	je     8010668d <trap+0x5d>
8010667f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106683:	f7 d0                	not    %eax
80106685:	a8 03                	test   $0x3,%al
80106687:	0f 84 53 02 00 00    	je     801068e0 <trap+0x2b0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.

  if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER)
8010668d:	e8 1e d4 ff ff       	call   80103ab0 <myproc>
80106692:	85 c0                	test   %eax,%eax
80106694:	74 0f                	je     801066a5 <trap+0x75>
80106696:	e8 15 d4 ff ff       	call   80103ab0 <myproc>
8010669b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010669f:	0f 84 ab 00 00 00    	je     80106750 <trap+0x120>

    //yield();
  }

  // Check if the process has been killed since we yielded
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801066a5:	e8 06 d4 ff ff       	call   80103ab0 <myproc>
801066aa:	85 c0                	test   %eax,%eax
801066ac:	74 1a                	je     801066c8 <trap+0x98>
801066ae:	e8 fd d3 ff ff       	call   80103ab0 <myproc>
801066b3:	8b 40 24             	mov    0x24(%eax),%eax
801066b6:	85 c0                	test   %eax,%eax
801066b8:	74 0e                	je     801066c8 <trap+0x98>
801066ba:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801066be:	f7 d0                	not    %eax
801066c0:	a8 03                	test   $0x3,%al
801066c2:	0f 84 75 01 00 00    	je     8010683d <trap+0x20d>
    exit();
}
801066c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066cb:	5b                   	pop    %ebx
801066cc:	5e                   	pop    %esi
801066cd:	5f                   	pop    %edi
801066ce:	5d                   	pop    %ebp
801066cf:	c3                   	ret
    if (myproc() == 0 || (tf->cs & 3) == 0)
801066d0:	e8 db d3 ff ff       	call   80103ab0 <myproc>
801066d5:	8b 7b 38             	mov    0x38(%ebx),%edi
801066d8:	85 c0                	test   %eax,%eax
801066da:	0f 84 9d 02 00 00    	je     8010697d <trap+0x34d>
801066e0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801066e4:	0f 84 93 02 00 00    	je     8010697d <trap+0x34d>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801066ea:	0f 20 d1             	mov    %cr2,%ecx
801066ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066f0:	e8 9b d3 ff ff       	call   80103a90 <cpuid>
801066f5:	8b 73 30             	mov    0x30(%ebx),%esi
801066f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801066fb:	8b 43 34             	mov    0x34(%ebx),%eax
801066fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106701:	e8 aa d3 ff ff       	call   80103ab0 <myproc>
80106706:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106709:	e8 a2 d3 ff ff       	call   80103ab0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010670e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106711:	51                   	push   %ecx
80106712:	57                   	push   %edi
80106713:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106716:	52                   	push   %edx
80106717:	ff 75 e4             	push   -0x1c(%ebp)
8010671a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010671b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010671e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106721:	56                   	push   %esi
80106722:	ff 70 10             	push   0x10(%eax)
80106725:	68 60 88 10 80       	push   $0x80108860
8010672a:	e8 81 9f ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
8010672f:	83 c4 20             	add    $0x20,%esp
80106732:	e8 79 d3 ff ff       	call   80103ab0 <myproc>
80106737:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010673e:	e8 6d d3 ff ff       	call   80103ab0 <myproc>
80106743:	85 c0                	test   %eax,%eax
80106745:	0f 85 28 ff ff ff    	jne    80106673 <trap+0x43>
8010674b:	e9 3d ff ff ff       	jmp    8010668d <trap+0x5d>
  if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER)
80106750:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106754:	0f 85 4b ff ff ff    	jne    801066a5 <trap+0x75>
    myproc()->consecutive_run++;
8010675a:	e8 51 d3 ff ff       	call   80103ab0 <myproc>
8010675f:	83 80 98 00 00 00 01 	addl   $0x1,0x98(%eax)
    myproc()->runnig_time++;
80106766:	e8 45 d3 ff ff       	call   80103ab0 <myproc>
8010676b:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)
    if (myproc()->consecutive_run > myproc()->max_consecutive_run)
80106772:	e8 39 d3 ff ff       	call   80103ab0 <myproc>
80106777:	8b b0 98 00 00 00    	mov    0x98(%eax),%esi
8010677d:	e8 2e d3 ff ff       	call   80103ab0 <myproc>
80106782:	3b b0 9c 00 00 00    	cmp    0x9c(%eax),%esi
80106788:	0f 8f d2 01 00 00    	jg     80106960 <trap+0x330>
    if (myproc()->sched_class == 2 && myproc()->sched_level == 1)
8010678e:	e8 1d d3 ff ff       	call   80103ab0 <myproc>
80106793:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
80106797:	0f 84 63 01 00 00    	je     80106900 <trap+0x2d0>
    else if (myproc()->sched_class == 2 && myproc()->sched_level == 2)
8010679d:	e8 0e d3 ff ff       	call   80103ab0 <myproc>
801067a2:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
801067a6:	0f 85 f9 fe ff ff    	jne    801066a5 <trap+0x75>
801067ac:	e8 ff d2 ff ff       	call   80103ab0 <myproc>
801067b1:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
801067b8:	0f 85 e7 fe ff ff    	jne    801066a5 <trap+0x75>
      if (is_higher_waiting())
801067be:	e8 bd e3 ff ff       	call   80104b80 <is_higher_waiting>
801067c3:	85 c0                	test   %eax,%eax
801067c5:	0f 84 da fe ff ff    	je     801066a5 <trap+0x75>
        yield();
801067cb:	e8 a0 da ff ff       	call   80104270 <yield>
801067d0:	e9 d0 fe ff ff       	jmp    801066a5 <trap+0x75>
801067d5:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067d8:	8b 7b 38             	mov    0x38(%ebx),%edi
801067db:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801067df:	e8 ac d2 ff ff       	call   80103a90 <cpuid>
801067e4:	57                   	push   %edi
801067e5:	56                   	push   %esi
801067e6:	50                   	push   %eax
801067e7:	68 08 88 10 80       	push   $0x80108808
801067ec:	e8 bf 9e ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801067f1:	e8 2a c1 ff ff       	call   80102920 <lapiceoi>
    break;
801067f6:	83 c4 10             	add    $0x10,%esp
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801067f9:	e8 b2 d2 ff ff       	call   80103ab0 <myproc>
801067fe:	85 c0                	test   %eax,%eax
80106800:	0f 85 6d fe ff ff    	jne    80106673 <trap+0x43>
80106806:	e9 82 fe ff ff       	jmp    8010668d <trap+0x5d>
8010680b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
80106810:	e8 9b d2 ff ff       	call   80103ab0 <myproc>
80106815:	8b 70 24             	mov    0x24(%eax),%esi
80106818:	85 f6                	test   %esi,%esi
8010681a:	0f 85 d0 00 00 00    	jne    801068f0 <trap+0x2c0>
    myproc()->tf = tf;
80106820:	e8 8b d2 ff ff       	call   80103ab0 <myproc>
80106825:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106828:	e8 43 ee ff ff       	call   80105670 <syscall>
    if (myproc()->killed)
8010682d:	e8 7e d2 ff ff       	call   80103ab0 <myproc>
80106832:	8b 58 24             	mov    0x24(%eax),%ebx
80106835:	85 db                	test   %ebx,%ebx
80106837:	0f 84 8b fe ff ff    	je     801066c8 <trap+0x98>
}
8010683d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106840:	5b                   	pop    %ebx
80106841:	5e                   	pop    %esi
80106842:	5f                   	pop    %edi
80106843:	5d                   	pop    %ebp
      exit();
80106844:	e9 37 d9 ff ff       	jmp    80104180 <exit>
80106849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106850:	e8 db 02 00 00       	call   80106b30 <uartintr>
    lapiceoi();
80106855:	e8 c6 c0 ff ff       	call   80102920 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010685a:	e8 51 d2 ff ff       	call   80103ab0 <myproc>
8010685f:	85 c0                	test   %eax,%eax
80106861:	0f 85 0c fe ff ff    	jne    80106673 <trap+0x43>
80106867:	e9 21 fe ff ff       	jmp    8010668d <trap+0x5d>
8010686c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106870:	e8 7b bf ff ff       	call   801027f0 <kbdintr>
    lapiceoi();
80106875:	e8 a6 c0 ff ff       	call   80102920 <lapiceoi>
  if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010687a:	e8 31 d2 ff ff       	call   80103ab0 <myproc>
8010687f:	85 c0                	test   %eax,%eax
80106881:	0f 85 ec fd ff ff    	jne    80106673 <trap+0x43>
80106887:	e9 01 fe ff ff       	jmp    8010668d <trap+0x5d>
8010688c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (cpuid() == 0)
80106890:	e8 fb d1 ff ff       	call   80103a90 <cpuid>
80106895:	85 c0                	test   %eax,%eax
80106897:	0f 85 c8 fd ff ff    	jne    80106665 <trap+0x35>
      acquire(&tickslock);
8010689d:	83 ec 0c             	sub    $0xc,%esp
801068a0:	68 a0 56 11 80       	push   $0x801156a0
801068a5:	e8 d6 e8 ff ff       	call   80105180 <acquire>
      ticks++;
801068aa:	a1 80 56 11 80       	mov    0x80115680,%eax
801068af:	8d 70 01             	lea    0x1(%eax),%esi
801068b2:	89 35 80 56 11 80    	mov    %esi,0x80115680
      wakeup(&ticks);
801068b8:	c7 04 24 80 56 11 80 	movl   $0x80115680,(%esp)
801068bf:	e8 9c dd ff ff       	call   80104660 <wakeup>
      release(&tickslock);
801068c4:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
801068cb:	e8 50 e8 ff ff       	call   80105120 <release>
      update_wait_time(osTicks); // Accumulate waited_ticks for all RUNNABLE processes
801068d0:	89 34 24             	mov    %esi,(%esp)
801068d3:	e8 f8 e1 ff ff       	call   80104ad0 <update_wait_time>
801068d8:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801068db:	e9 85 fd ff ff       	jmp    80106665 <trap+0x35>
    exit();
801068e0:	e8 9b d8 ff ff       	call   80104180 <exit>
801068e5:	e9 a3 fd ff ff       	jmp    8010668d <trap+0x5d>
801068ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801068f0:	e8 8b d8 ff ff       	call   80104180 <exit>
801068f5:	e9 26 ff ff ff       	jmp    80106820 <trap+0x1f0>
801068fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (myproc()->sched_class == 2 && myproc()->sched_level == 1)
80106900:	e8 ab d1 ff ff       	call   80103ab0 <myproc>
80106905:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
8010690c:	0f 85 8b fe ff ff    	jne    8010679d <trap+0x16d>
      myproc()->rr_ticks++;
80106912:	e8 99 d1 ff ff       	call   80103ab0 <myproc>
80106917:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
      if (myproc()->rr_ticks >= Time_Quantum / Unit_Quantum_length_ms)
8010691e:	e8 8d d1 ff ff       	call   80103ab0 <myproc>
80106923:	83 b8 88 00 00 00 02 	cmpl   $0x2,0x88(%eax)
8010692a:	0f 8e 75 fd ff ff    	jle    801066a5 <trap+0x75>
        cprintf("RR proc %d  yielded, RR ticks: %d \n", myproc()->pid, myproc()->rr_ticks);
80106930:	e8 7b d1 ff ff       	call   80103ab0 <myproc>
80106935:	8b b0 88 00 00 00    	mov    0x88(%eax),%esi
8010693b:	e8 70 d1 ff ff       	call   80103ab0 <myproc>
80106940:	52                   	push   %edx
80106941:	56                   	push   %esi
80106942:	ff 70 10             	push   0x10(%eax)
80106945:	68 a4 88 10 80       	push   $0x801088a4
8010694a:	e8 61 9d ff ff       	call   801006b0 <cprintf>
        yield(); // Time quantum finished
8010694f:	e8 1c d9 ff ff       	call   80104270 <yield>
80106954:	83 c4 10             	add    $0x10,%esp
80106957:	e9 49 fd ff ff       	jmp    801066a5 <trap+0x75>
8010695c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      myproc()->max_consecutive_run = myproc()->consecutive_run;
80106960:	e8 4b d1 ff ff       	call   80103ab0 <myproc>
80106965:	89 c6                	mov    %eax,%esi
80106967:	e8 44 d1 ff ff       	call   80103ab0 <myproc>
8010696c:	8b 96 98 00 00 00    	mov    0x98(%esi),%edx
80106972:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
80106978:	e9 11 fe ff ff       	jmp    8010678e <trap+0x15e>
8010697d:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106980:	e8 0b d1 ff ff       	call   80103a90 <cpuid>
80106985:	83 ec 0c             	sub    $0xc,%esp
80106988:	56                   	push   %esi
80106989:	57                   	push   %edi
8010698a:	50                   	push   %eax
8010698b:	ff 73 30             	push   0x30(%ebx)
8010698e:	68 2c 88 10 80       	push   $0x8010882c
80106993:	e8 18 9d ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106998:	83 c4 14             	add    $0x14,%esp
8010699b:	68 bc 84 10 80       	push   $0x801084bc
801069a0:	e8 db 99 ff ff       	call   80100380 <panic>
801069a5:	66 90                	xchg   %ax,%ax
801069a7:	66 90                	xchg   %ax,%ax
801069a9:	66 90                	xchg   %ax,%ax
801069ab:	66 90                	xchg   %ax,%ax
801069ad:	66 90                	xchg   %ax,%ax
801069af:	90                   	nop

801069b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801069b0:	a1 e0 5e 11 80       	mov    0x80115ee0,%eax
801069b5:	85 c0                	test   %eax,%eax
801069b7:	74 17                	je     801069d0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801069b9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801069be:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801069bf:	a8 01                	test   $0x1,%al
801069c1:	74 0d                	je     801069d0 <uartgetc+0x20>
801069c3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069c8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801069c9:	0f b6 c0             	movzbl %al,%eax
801069cc:	c3                   	ret
801069cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801069d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069d5:	c3                   	ret
801069d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801069dd:	00 
801069de:	66 90                	xchg   %ax,%ax

801069e0 <uartinit>:
{
801069e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801069e1:	31 c9                	xor    %ecx,%ecx
801069e3:	89 c8                	mov    %ecx,%eax
801069e5:	89 e5                	mov    %esp,%ebp
801069e7:	57                   	push   %edi
801069e8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801069ed:	56                   	push   %esi
801069ee:	89 fa                	mov    %edi,%edx
801069f0:	53                   	push   %ebx
801069f1:	83 ec 1c             	sub    $0x1c,%esp
801069f4:	ee                   	out    %al,(%dx)
801069f5:	be fb 03 00 00       	mov    $0x3fb,%esi
801069fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801069ff:	89 f2                	mov    %esi,%edx
80106a01:	ee                   	out    %al,(%dx)
80106a02:	b8 0c 00 00 00       	mov    $0xc,%eax
80106a07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a0c:	ee                   	out    %al,(%dx)
80106a0d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106a12:	89 c8                	mov    %ecx,%eax
80106a14:	89 da                	mov    %ebx,%edx
80106a16:	ee                   	out    %al,(%dx)
80106a17:	b8 03 00 00 00       	mov    $0x3,%eax
80106a1c:	89 f2                	mov    %esi,%edx
80106a1e:	ee                   	out    %al,(%dx)
80106a1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106a24:	89 c8                	mov    %ecx,%eax
80106a26:	ee                   	out    %al,(%dx)
80106a27:	b8 01 00 00 00       	mov    $0x1,%eax
80106a2c:	89 da                	mov    %ebx,%edx
80106a2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a34:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106a35:	3c ff                	cmp    $0xff,%al
80106a37:	0f 84 7c 00 00 00    	je     80106ab9 <uartinit+0xd9>
  uart = 1;
80106a3d:	c7 05 e0 5e 11 80 01 	movl   $0x1,0x80115ee0
80106a44:	00 00 00 
80106a47:	89 fa                	mov    %edi,%edx
80106a49:	ec                   	in     (%dx),%al
80106a4a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a4f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106a50:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106a53:	bf c1 84 10 80       	mov    $0x801084c1,%edi
80106a58:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106a5d:	6a 00                	push   $0x0
80106a5f:	6a 04                	push   $0x4
80106a61:	e8 2a ba ff ff       	call   80102490 <ioapicenable>
80106a66:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106a69:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80106a6d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106a70:	a1 e0 5e 11 80       	mov    0x80115ee0,%eax
80106a75:	85 c0                	test   %eax,%eax
80106a77:	74 32                	je     80106aab <uartinit+0xcb>
80106a79:	89 f2                	mov    %esi,%edx
80106a7b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a7c:	a8 20                	test   $0x20,%al
80106a7e:	75 21                	jne    80106aa1 <uartinit+0xc1>
80106a80:	bb 80 00 00 00       	mov    $0x80,%ebx
80106a85:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80106a88:	83 ec 0c             	sub    $0xc,%esp
80106a8b:	6a 0a                	push   $0xa
80106a8d:	e8 ae be ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106a92:	83 c4 10             	add    $0x10,%esp
80106a95:	83 eb 01             	sub    $0x1,%ebx
80106a98:	74 07                	je     80106aa1 <uartinit+0xc1>
80106a9a:	89 f2                	mov    %esi,%edx
80106a9c:	ec                   	in     (%dx),%al
80106a9d:	a8 20                	test   $0x20,%al
80106a9f:	74 e7                	je     80106a88 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106aa1:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106aa6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106aaa:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106aab:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106aaf:	83 c7 01             	add    $0x1,%edi
80106ab2:	88 45 e7             	mov    %al,-0x19(%ebp)
80106ab5:	84 c0                	test   %al,%al
80106ab7:	75 b7                	jne    80106a70 <uartinit+0x90>
}
80106ab9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106abc:	5b                   	pop    %ebx
80106abd:	5e                   	pop    %esi
80106abe:	5f                   	pop    %edi
80106abf:	5d                   	pop    %ebp
80106ac0:	c3                   	ret
80106ac1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ac8:	00 
80106ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ad0 <uartputc>:
  if(!uart)
80106ad0:	a1 e0 5e 11 80       	mov    0x80115ee0,%eax
80106ad5:	85 c0                	test   %eax,%eax
80106ad7:	74 4f                	je     80106b28 <uartputc+0x58>
{
80106ad9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ada:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106adf:	89 e5                	mov    %esp,%ebp
80106ae1:	56                   	push   %esi
80106ae2:	53                   	push   %ebx
80106ae3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ae4:	a8 20                	test   $0x20,%al
80106ae6:	75 29                	jne    80106b11 <uartputc+0x41>
80106ae8:	bb 80 00 00 00       	mov    $0x80,%ebx
80106aed:	be fd 03 00 00       	mov    $0x3fd,%esi
80106af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106af8:	83 ec 0c             	sub    $0xc,%esp
80106afb:	6a 0a                	push   $0xa
80106afd:	e8 3e be ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b02:	83 c4 10             	add    $0x10,%esp
80106b05:	83 eb 01             	sub    $0x1,%ebx
80106b08:	74 07                	je     80106b11 <uartputc+0x41>
80106b0a:	89 f2                	mov    %esi,%edx
80106b0c:	ec                   	in     (%dx),%al
80106b0d:	a8 20                	test   $0x20,%al
80106b0f:	74 e7                	je     80106af8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b11:	8b 45 08             	mov    0x8(%ebp),%eax
80106b14:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b19:	ee                   	out    %al,(%dx)
}
80106b1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106b1d:	5b                   	pop    %ebx
80106b1e:	5e                   	pop    %esi
80106b1f:	5d                   	pop    %ebp
80106b20:	c3                   	ret
80106b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b28:	c3                   	ret
80106b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b30 <uartintr>:

void
uartintr(void)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106b36:	68 b0 69 10 80       	push   $0x801069b0
80106b3b:	e8 60 9d ff ff       	call   801008a0 <consoleintr>
}
80106b40:	83 c4 10             	add    $0x10,%esp
80106b43:	c9                   	leave
80106b44:	c3                   	ret
80106b45:	66 90                	xchg   %ax,%ax
80106b47:	66 90                	xchg   %ax,%ax
80106b49:	66 90                	xchg   %ax,%ax
80106b4b:	66 90                	xchg   %ax,%ax
80106b4d:	66 90                	xchg   %ax,%ax
80106b4f:	90                   	nop

80106b50 <srand>:

static uint seed = 1;

void
srand(uint s)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
  seed = s;
80106b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106b56:	5d                   	pop    %ebp
  seed = s;
80106b57:	a3 08 b0 10 80       	mov    %eax,0x8010b008
}
80106b5c:	c3                   	ret
80106b5d:	8d 76 00             	lea    0x0(%esi),%esi

80106b60 <rand>:

uint
rand(void)
{
  seed = seed
    * 1103515245
80106b60:	69 05 08 b0 10 80 6d 	imul   $0x41c64e6d,0x8010b008,%eax
80106b67:	4e c6 41 
    + 12345
80106b6a:	05 39 30 00 00       	add    $0x3039,%eax
  seed = seed
80106b6f:	a3 08 b0 10 80       	mov    %eax,0x8010b008
    % (1 << 31);
  return seed;
}
80106b74:	c3                   	ret
80106b75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b7c:	00 
80106b7d:	8d 76 00             	lea    0x0(%esi),%esi

80106b80 <digitcount>:

int
digitcount(int num)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	56                   	push   %esi
80106b84:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106b87:	53                   	push   %ebx
80106b88:	bb 01 00 00 00       	mov    $0x1,%ebx
  if(num == 0) return 1;
80106b8d:	85 c9                	test   %ecx,%ecx
80106b8f:	74 24                	je     80106bb5 <digitcount+0x35>
  int count = 0;
80106b91:	31 db                	xor    %ebx,%ebx
  while(num){
    num /= 10;
80106b93:	be 67 66 66 66       	mov    $0x66666667,%esi
80106b98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b9f:	00 
80106ba0:	89 c8                	mov    %ecx,%eax
    ++count;
80106ba2:	83 c3 01             	add    $0x1,%ebx
    num /= 10;
80106ba5:	f7 ee                	imul   %esi
80106ba7:	89 c8                	mov    %ecx,%eax
80106ba9:	c1 f8 1f             	sar    $0x1f,%eax
80106bac:	c1 fa 02             	sar    $0x2,%edx
  while(num){
80106baf:	89 d1                	mov    %edx,%ecx
80106bb1:	29 c1                	sub    %eax,%ecx
80106bb3:	75 eb                	jne    80106ba0 <digitcount+0x20>
  }
  return count;
}
80106bb5:	89 d8                	mov    %ebx,%eax
80106bb7:	5b                   	pop    %ebx
80106bb8:	5e                   	pop    %esi
80106bb9:	5d                   	pop    %ebp
80106bba:	c3                   	ret
80106bbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106bc0 <printspaces>:

void
printspaces(int count)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	56                   	push   %esi
80106bc4:	53                   	push   %ebx
80106bc5:	8b 75 08             	mov    0x8(%ebp),%esi
  for(int i = 0; i < count; ++i)
80106bc8:	85 f6                	test   %esi,%esi
80106bca:	7e 1b                	jle    80106be7 <printspaces+0x27>
80106bcc:	31 db                	xor    %ebx,%ebx
80106bce:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80106bd0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80106bd3:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80106bd6:	68 f8 83 10 80       	push   $0x801083f8
80106bdb:	e8 d0 9a ff ff       	call   801006b0 <cprintf>
  for(int i = 0; i < count; ++i)
80106be0:	83 c4 10             	add    $0x10,%esp
80106be3:	39 de                	cmp    %ebx,%esi
80106be5:	75 e9                	jne    80106bd0 <printspaces+0x10>
}
80106be7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106bea:	5b                   	pop    %ebx
80106beb:	5e                   	pop    %esi
80106bec:	5d                   	pop    %ebp
80106bed:	c3                   	ret

80106bee <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106bee:	6a 00                	push   $0x0
  pushl $0
80106bf0:	6a 00                	push   $0x0
  jmp alltraps
80106bf2:	e9 5e f9 ff ff       	jmp    80106555 <alltraps>

80106bf7 <vector1>:
.globl vector1
vector1:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $1
80106bf9:	6a 01                	push   $0x1
  jmp alltraps
80106bfb:	e9 55 f9 ff ff       	jmp    80106555 <alltraps>

80106c00 <vector2>:
.globl vector2
vector2:
  pushl $0
80106c00:	6a 00                	push   $0x0
  pushl $2
80106c02:	6a 02                	push   $0x2
  jmp alltraps
80106c04:	e9 4c f9 ff ff       	jmp    80106555 <alltraps>

80106c09 <vector3>:
.globl vector3
vector3:
  pushl $0
80106c09:	6a 00                	push   $0x0
  pushl $3
80106c0b:	6a 03                	push   $0x3
  jmp alltraps
80106c0d:	e9 43 f9 ff ff       	jmp    80106555 <alltraps>

80106c12 <vector4>:
.globl vector4
vector4:
  pushl $0
80106c12:	6a 00                	push   $0x0
  pushl $4
80106c14:	6a 04                	push   $0x4
  jmp alltraps
80106c16:	e9 3a f9 ff ff       	jmp    80106555 <alltraps>

80106c1b <vector5>:
.globl vector5
vector5:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $5
80106c1d:	6a 05                	push   $0x5
  jmp alltraps
80106c1f:	e9 31 f9 ff ff       	jmp    80106555 <alltraps>

80106c24 <vector6>:
.globl vector6
vector6:
  pushl $0
80106c24:	6a 00                	push   $0x0
  pushl $6
80106c26:	6a 06                	push   $0x6
  jmp alltraps
80106c28:	e9 28 f9 ff ff       	jmp    80106555 <alltraps>

80106c2d <vector7>:
.globl vector7
vector7:
  pushl $0
80106c2d:	6a 00                	push   $0x0
  pushl $7
80106c2f:	6a 07                	push   $0x7
  jmp alltraps
80106c31:	e9 1f f9 ff ff       	jmp    80106555 <alltraps>

80106c36 <vector8>:
.globl vector8
vector8:
  pushl $8
80106c36:	6a 08                	push   $0x8
  jmp alltraps
80106c38:	e9 18 f9 ff ff       	jmp    80106555 <alltraps>

80106c3d <vector9>:
.globl vector9
vector9:
  pushl $0
80106c3d:	6a 00                	push   $0x0
  pushl $9
80106c3f:	6a 09                	push   $0x9
  jmp alltraps
80106c41:	e9 0f f9 ff ff       	jmp    80106555 <alltraps>

80106c46 <vector10>:
.globl vector10
vector10:
  pushl $10
80106c46:	6a 0a                	push   $0xa
  jmp alltraps
80106c48:	e9 08 f9 ff ff       	jmp    80106555 <alltraps>

80106c4d <vector11>:
.globl vector11
vector11:
  pushl $11
80106c4d:	6a 0b                	push   $0xb
  jmp alltraps
80106c4f:	e9 01 f9 ff ff       	jmp    80106555 <alltraps>

80106c54 <vector12>:
.globl vector12
vector12:
  pushl $12
80106c54:	6a 0c                	push   $0xc
  jmp alltraps
80106c56:	e9 fa f8 ff ff       	jmp    80106555 <alltraps>

80106c5b <vector13>:
.globl vector13
vector13:
  pushl $13
80106c5b:	6a 0d                	push   $0xd
  jmp alltraps
80106c5d:	e9 f3 f8 ff ff       	jmp    80106555 <alltraps>

80106c62 <vector14>:
.globl vector14
vector14:
  pushl $14
80106c62:	6a 0e                	push   $0xe
  jmp alltraps
80106c64:	e9 ec f8 ff ff       	jmp    80106555 <alltraps>

80106c69 <vector15>:
.globl vector15
vector15:
  pushl $0
80106c69:	6a 00                	push   $0x0
  pushl $15
80106c6b:	6a 0f                	push   $0xf
  jmp alltraps
80106c6d:	e9 e3 f8 ff ff       	jmp    80106555 <alltraps>

80106c72 <vector16>:
.globl vector16
vector16:
  pushl $0
80106c72:	6a 00                	push   $0x0
  pushl $16
80106c74:	6a 10                	push   $0x10
  jmp alltraps
80106c76:	e9 da f8 ff ff       	jmp    80106555 <alltraps>

80106c7b <vector17>:
.globl vector17
vector17:
  pushl $17
80106c7b:	6a 11                	push   $0x11
  jmp alltraps
80106c7d:	e9 d3 f8 ff ff       	jmp    80106555 <alltraps>

80106c82 <vector18>:
.globl vector18
vector18:
  pushl $0
80106c82:	6a 00                	push   $0x0
  pushl $18
80106c84:	6a 12                	push   $0x12
  jmp alltraps
80106c86:	e9 ca f8 ff ff       	jmp    80106555 <alltraps>

80106c8b <vector19>:
.globl vector19
vector19:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $19
80106c8d:	6a 13                	push   $0x13
  jmp alltraps
80106c8f:	e9 c1 f8 ff ff       	jmp    80106555 <alltraps>

80106c94 <vector20>:
.globl vector20
vector20:
  pushl $0
80106c94:	6a 00                	push   $0x0
  pushl $20
80106c96:	6a 14                	push   $0x14
  jmp alltraps
80106c98:	e9 b8 f8 ff ff       	jmp    80106555 <alltraps>

80106c9d <vector21>:
.globl vector21
vector21:
  pushl $0
80106c9d:	6a 00                	push   $0x0
  pushl $21
80106c9f:	6a 15                	push   $0x15
  jmp alltraps
80106ca1:	e9 af f8 ff ff       	jmp    80106555 <alltraps>

80106ca6 <vector22>:
.globl vector22
vector22:
  pushl $0
80106ca6:	6a 00                	push   $0x0
  pushl $22
80106ca8:	6a 16                	push   $0x16
  jmp alltraps
80106caa:	e9 a6 f8 ff ff       	jmp    80106555 <alltraps>

80106caf <vector23>:
.globl vector23
vector23:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $23
80106cb1:	6a 17                	push   $0x17
  jmp alltraps
80106cb3:	e9 9d f8 ff ff       	jmp    80106555 <alltraps>

80106cb8 <vector24>:
.globl vector24
vector24:
  pushl $0
80106cb8:	6a 00                	push   $0x0
  pushl $24
80106cba:	6a 18                	push   $0x18
  jmp alltraps
80106cbc:	e9 94 f8 ff ff       	jmp    80106555 <alltraps>

80106cc1 <vector25>:
.globl vector25
vector25:
  pushl $0
80106cc1:	6a 00                	push   $0x0
  pushl $25
80106cc3:	6a 19                	push   $0x19
  jmp alltraps
80106cc5:	e9 8b f8 ff ff       	jmp    80106555 <alltraps>

80106cca <vector26>:
.globl vector26
vector26:
  pushl $0
80106cca:	6a 00                	push   $0x0
  pushl $26
80106ccc:	6a 1a                	push   $0x1a
  jmp alltraps
80106cce:	e9 82 f8 ff ff       	jmp    80106555 <alltraps>

80106cd3 <vector27>:
.globl vector27
vector27:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $27
80106cd5:	6a 1b                	push   $0x1b
  jmp alltraps
80106cd7:	e9 79 f8 ff ff       	jmp    80106555 <alltraps>

80106cdc <vector28>:
.globl vector28
vector28:
  pushl $0
80106cdc:	6a 00                	push   $0x0
  pushl $28
80106cde:	6a 1c                	push   $0x1c
  jmp alltraps
80106ce0:	e9 70 f8 ff ff       	jmp    80106555 <alltraps>

80106ce5 <vector29>:
.globl vector29
vector29:
  pushl $0
80106ce5:	6a 00                	push   $0x0
  pushl $29
80106ce7:	6a 1d                	push   $0x1d
  jmp alltraps
80106ce9:	e9 67 f8 ff ff       	jmp    80106555 <alltraps>

80106cee <vector30>:
.globl vector30
vector30:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $30
80106cf0:	6a 1e                	push   $0x1e
  jmp alltraps
80106cf2:	e9 5e f8 ff ff       	jmp    80106555 <alltraps>

80106cf7 <vector31>:
.globl vector31
vector31:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $31
80106cf9:	6a 1f                	push   $0x1f
  jmp alltraps
80106cfb:	e9 55 f8 ff ff       	jmp    80106555 <alltraps>

80106d00 <vector32>:
.globl vector32
vector32:
  pushl $0
80106d00:	6a 00                	push   $0x0
  pushl $32
80106d02:	6a 20                	push   $0x20
  jmp alltraps
80106d04:	e9 4c f8 ff ff       	jmp    80106555 <alltraps>

80106d09 <vector33>:
.globl vector33
vector33:
  pushl $0
80106d09:	6a 00                	push   $0x0
  pushl $33
80106d0b:	6a 21                	push   $0x21
  jmp alltraps
80106d0d:	e9 43 f8 ff ff       	jmp    80106555 <alltraps>

80106d12 <vector34>:
.globl vector34
vector34:
  pushl $0
80106d12:	6a 00                	push   $0x0
  pushl $34
80106d14:	6a 22                	push   $0x22
  jmp alltraps
80106d16:	e9 3a f8 ff ff       	jmp    80106555 <alltraps>

80106d1b <vector35>:
.globl vector35
vector35:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $35
80106d1d:	6a 23                	push   $0x23
  jmp alltraps
80106d1f:	e9 31 f8 ff ff       	jmp    80106555 <alltraps>

80106d24 <vector36>:
.globl vector36
vector36:
  pushl $0
80106d24:	6a 00                	push   $0x0
  pushl $36
80106d26:	6a 24                	push   $0x24
  jmp alltraps
80106d28:	e9 28 f8 ff ff       	jmp    80106555 <alltraps>

80106d2d <vector37>:
.globl vector37
vector37:
  pushl $0
80106d2d:	6a 00                	push   $0x0
  pushl $37
80106d2f:	6a 25                	push   $0x25
  jmp alltraps
80106d31:	e9 1f f8 ff ff       	jmp    80106555 <alltraps>

80106d36 <vector38>:
.globl vector38
vector38:
  pushl $0
80106d36:	6a 00                	push   $0x0
  pushl $38
80106d38:	6a 26                	push   $0x26
  jmp alltraps
80106d3a:	e9 16 f8 ff ff       	jmp    80106555 <alltraps>

80106d3f <vector39>:
.globl vector39
vector39:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $39
80106d41:	6a 27                	push   $0x27
  jmp alltraps
80106d43:	e9 0d f8 ff ff       	jmp    80106555 <alltraps>

80106d48 <vector40>:
.globl vector40
vector40:
  pushl $0
80106d48:	6a 00                	push   $0x0
  pushl $40
80106d4a:	6a 28                	push   $0x28
  jmp alltraps
80106d4c:	e9 04 f8 ff ff       	jmp    80106555 <alltraps>

80106d51 <vector41>:
.globl vector41
vector41:
  pushl $0
80106d51:	6a 00                	push   $0x0
  pushl $41
80106d53:	6a 29                	push   $0x29
  jmp alltraps
80106d55:	e9 fb f7 ff ff       	jmp    80106555 <alltraps>

80106d5a <vector42>:
.globl vector42
vector42:
  pushl $0
80106d5a:	6a 00                	push   $0x0
  pushl $42
80106d5c:	6a 2a                	push   $0x2a
  jmp alltraps
80106d5e:	e9 f2 f7 ff ff       	jmp    80106555 <alltraps>

80106d63 <vector43>:
.globl vector43
vector43:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $43
80106d65:	6a 2b                	push   $0x2b
  jmp alltraps
80106d67:	e9 e9 f7 ff ff       	jmp    80106555 <alltraps>

80106d6c <vector44>:
.globl vector44
vector44:
  pushl $0
80106d6c:	6a 00                	push   $0x0
  pushl $44
80106d6e:	6a 2c                	push   $0x2c
  jmp alltraps
80106d70:	e9 e0 f7 ff ff       	jmp    80106555 <alltraps>

80106d75 <vector45>:
.globl vector45
vector45:
  pushl $0
80106d75:	6a 00                	push   $0x0
  pushl $45
80106d77:	6a 2d                	push   $0x2d
  jmp alltraps
80106d79:	e9 d7 f7 ff ff       	jmp    80106555 <alltraps>

80106d7e <vector46>:
.globl vector46
vector46:
  pushl $0
80106d7e:	6a 00                	push   $0x0
  pushl $46
80106d80:	6a 2e                	push   $0x2e
  jmp alltraps
80106d82:	e9 ce f7 ff ff       	jmp    80106555 <alltraps>

80106d87 <vector47>:
.globl vector47
vector47:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $47
80106d89:	6a 2f                	push   $0x2f
  jmp alltraps
80106d8b:	e9 c5 f7 ff ff       	jmp    80106555 <alltraps>

80106d90 <vector48>:
.globl vector48
vector48:
  pushl $0
80106d90:	6a 00                	push   $0x0
  pushl $48
80106d92:	6a 30                	push   $0x30
  jmp alltraps
80106d94:	e9 bc f7 ff ff       	jmp    80106555 <alltraps>

80106d99 <vector49>:
.globl vector49
vector49:
  pushl $0
80106d99:	6a 00                	push   $0x0
  pushl $49
80106d9b:	6a 31                	push   $0x31
  jmp alltraps
80106d9d:	e9 b3 f7 ff ff       	jmp    80106555 <alltraps>

80106da2 <vector50>:
.globl vector50
vector50:
  pushl $0
80106da2:	6a 00                	push   $0x0
  pushl $50
80106da4:	6a 32                	push   $0x32
  jmp alltraps
80106da6:	e9 aa f7 ff ff       	jmp    80106555 <alltraps>

80106dab <vector51>:
.globl vector51
vector51:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $51
80106dad:	6a 33                	push   $0x33
  jmp alltraps
80106daf:	e9 a1 f7 ff ff       	jmp    80106555 <alltraps>

80106db4 <vector52>:
.globl vector52
vector52:
  pushl $0
80106db4:	6a 00                	push   $0x0
  pushl $52
80106db6:	6a 34                	push   $0x34
  jmp alltraps
80106db8:	e9 98 f7 ff ff       	jmp    80106555 <alltraps>

80106dbd <vector53>:
.globl vector53
vector53:
  pushl $0
80106dbd:	6a 00                	push   $0x0
  pushl $53
80106dbf:	6a 35                	push   $0x35
  jmp alltraps
80106dc1:	e9 8f f7 ff ff       	jmp    80106555 <alltraps>

80106dc6 <vector54>:
.globl vector54
vector54:
  pushl $0
80106dc6:	6a 00                	push   $0x0
  pushl $54
80106dc8:	6a 36                	push   $0x36
  jmp alltraps
80106dca:	e9 86 f7 ff ff       	jmp    80106555 <alltraps>

80106dcf <vector55>:
.globl vector55
vector55:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $55
80106dd1:	6a 37                	push   $0x37
  jmp alltraps
80106dd3:	e9 7d f7 ff ff       	jmp    80106555 <alltraps>

80106dd8 <vector56>:
.globl vector56
vector56:
  pushl $0
80106dd8:	6a 00                	push   $0x0
  pushl $56
80106dda:	6a 38                	push   $0x38
  jmp alltraps
80106ddc:	e9 74 f7 ff ff       	jmp    80106555 <alltraps>

80106de1 <vector57>:
.globl vector57
vector57:
  pushl $0
80106de1:	6a 00                	push   $0x0
  pushl $57
80106de3:	6a 39                	push   $0x39
  jmp alltraps
80106de5:	e9 6b f7 ff ff       	jmp    80106555 <alltraps>

80106dea <vector58>:
.globl vector58
vector58:
  pushl $0
80106dea:	6a 00                	push   $0x0
  pushl $58
80106dec:	6a 3a                	push   $0x3a
  jmp alltraps
80106dee:	e9 62 f7 ff ff       	jmp    80106555 <alltraps>

80106df3 <vector59>:
.globl vector59
vector59:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $59
80106df5:	6a 3b                	push   $0x3b
  jmp alltraps
80106df7:	e9 59 f7 ff ff       	jmp    80106555 <alltraps>

80106dfc <vector60>:
.globl vector60
vector60:
  pushl $0
80106dfc:	6a 00                	push   $0x0
  pushl $60
80106dfe:	6a 3c                	push   $0x3c
  jmp alltraps
80106e00:	e9 50 f7 ff ff       	jmp    80106555 <alltraps>

80106e05 <vector61>:
.globl vector61
vector61:
  pushl $0
80106e05:	6a 00                	push   $0x0
  pushl $61
80106e07:	6a 3d                	push   $0x3d
  jmp alltraps
80106e09:	e9 47 f7 ff ff       	jmp    80106555 <alltraps>

80106e0e <vector62>:
.globl vector62
vector62:
  pushl $0
80106e0e:	6a 00                	push   $0x0
  pushl $62
80106e10:	6a 3e                	push   $0x3e
  jmp alltraps
80106e12:	e9 3e f7 ff ff       	jmp    80106555 <alltraps>

80106e17 <vector63>:
.globl vector63
vector63:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $63
80106e19:	6a 3f                	push   $0x3f
  jmp alltraps
80106e1b:	e9 35 f7 ff ff       	jmp    80106555 <alltraps>

80106e20 <vector64>:
.globl vector64
vector64:
  pushl $0
80106e20:	6a 00                	push   $0x0
  pushl $64
80106e22:	6a 40                	push   $0x40
  jmp alltraps
80106e24:	e9 2c f7 ff ff       	jmp    80106555 <alltraps>

80106e29 <vector65>:
.globl vector65
vector65:
  pushl $0
80106e29:	6a 00                	push   $0x0
  pushl $65
80106e2b:	6a 41                	push   $0x41
  jmp alltraps
80106e2d:	e9 23 f7 ff ff       	jmp    80106555 <alltraps>

80106e32 <vector66>:
.globl vector66
vector66:
  pushl $0
80106e32:	6a 00                	push   $0x0
  pushl $66
80106e34:	6a 42                	push   $0x42
  jmp alltraps
80106e36:	e9 1a f7 ff ff       	jmp    80106555 <alltraps>

80106e3b <vector67>:
.globl vector67
vector67:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $67
80106e3d:	6a 43                	push   $0x43
  jmp alltraps
80106e3f:	e9 11 f7 ff ff       	jmp    80106555 <alltraps>

80106e44 <vector68>:
.globl vector68
vector68:
  pushl $0
80106e44:	6a 00                	push   $0x0
  pushl $68
80106e46:	6a 44                	push   $0x44
  jmp alltraps
80106e48:	e9 08 f7 ff ff       	jmp    80106555 <alltraps>

80106e4d <vector69>:
.globl vector69
vector69:
  pushl $0
80106e4d:	6a 00                	push   $0x0
  pushl $69
80106e4f:	6a 45                	push   $0x45
  jmp alltraps
80106e51:	e9 ff f6 ff ff       	jmp    80106555 <alltraps>

80106e56 <vector70>:
.globl vector70
vector70:
  pushl $0
80106e56:	6a 00                	push   $0x0
  pushl $70
80106e58:	6a 46                	push   $0x46
  jmp alltraps
80106e5a:	e9 f6 f6 ff ff       	jmp    80106555 <alltraps>

80106e5f <vector71>:
.globl vector71
vector71:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $71
80106e61:	6a 47                	push   $0x47
  jmp alltraps
80106e63:	e9 ed f6 ff ff       	jmp    80106555 <alltraps>

80106e68 <vector72>:
.globl vector72
vector72:
  pushl $0
80106e68:	6a 00                	push   $0x0
  pushl $72
80106e6a:	6a 48                	push   $0x48
  jmp alltraps
80106e6c:	e9 e4 f6 ff ff       	jmp    80106555 <alltraps>

80106e71 <vector73>:
.globl vector73
vector73:
  pushl $0
80106e71:	6a 00                	push   $0x0
  pushl $73
80106e73:	6a 49                	push   $0x49
  jmp alltraps
80106e75:	e9 db f6 ff ff       	jmp    80106555 <alltraps>

80106e7a <vector74>:
.globl vector74
vector74:
  pushl $0
80106e7a:	6a 00                	push   $0x0
  pushl $74
80106e7c:	6a 4a                	push   $0x4a
  jmp alltraps
80106e7e:	e9 d2 f6 ff ff       	jmp    80106555 <alltraps>

80106e83 <vector75>:
.globl vector75
vector75:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $75
80106e85:	6a 4b                	push   $0x4b
  jmp alltraps
80106e87:	e9 c9 f6 ff ff       	jmp    80106555 <alltraps>

80106e8c <vector76>:
.globl vector76
vector76:
  pushl $0
80106e8c:	6a 00                	push   $0x0
  pushl $76
80106e8e:	6a 4c                	push   $0x4c
  jmp alltraps
80106e90:	e9 c0 f6 ff ff       	jmp    80106555 <alltraps>

80106e95 <vector77>:
.globl vector77
vector77:
  pushl $0
80106e95:	6a 00                	push   $0x0
  pushl $77
80106e97:	6a 4d                	push   $0x4d
  jmp alltraps
80106e99:	e9 b7 f6 ff ff       	jmp    80106555 <alltraps>

80106e9e <vector78>:
.globl vector78
vector78:
  pushl $0
80106e9e:	6a 00                	push   $0x0
  pushl $78
80106ea0:	6a 4e                	push   $0x4e
  jmp alltraps
80106ea2:	e9 ae f6 ff ff       	jmp    80106555 <alltraps>

80106ea7 <vector79>:
.globl vector79
vector79:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $79
80106ea9:	6a 4f                	push   $0x4f
  jmp alltraps
80106eab:	e9 a5 f6 ff ff       	jmp    80106555 <alltraps>

80106eb0 <vector80>:
.globl vector80
vector80:
  pushl $0
80106eb0:	6a 00                	push   $0x0
  pushl $80
80106eb2:	6a 50                	push   $0x50
  jmp alltraps
80106eb4:	e9 9c f6 ff ff       	jmp    80106555 <alltraps>

80106eb9 <vector81>:
.globl vector81
vector81:
  pushl $0
80106eb9:	6a 00                	push   $0x0
  pushl $81
80106ebb:	6a 51                	push   $0x51
  jmp alltraps
80106ebd:	e9 93 f6 ff ff       	jmp    80106555 <alltraps>

80106ec2 <vector82>:
.globl vector82
vector82:
  pushl $0
80106ec2:	6a 00                	push   $0x0
  pushl $82
80106ec4:	6a 52                	push   $0x52
  jmp alltraps
80106ec6:	e9 8a f6 ff ff       	jmp    80106555 <alltraps>

80106ecb <vector83>:
.globl vector83
vector83:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $83
80106ecd:	6a 53                	push   $0x53
  jmp alltraps
80106ecf:	e9 81 f6 ff ff       	jmp    80106555 <alltraps>

80106ed4 <vector84>:
.globl vector84
vector84:
  pushl $0
80106ed4:	6a 00                	push   $0x0
  pushl $84
80106ed6:	6a 54                	push   $0x54
  jmp alltraps
80106ed8:	e9 78 f6 ff ff       	jmp    80106555 <alltraps>

80106edd <vector85>:
.globl vector85
vector85:
  pushl $0
80106edd:	6a 00                	push   $0x0
  pushl $85
80106edf:	6a 55                	push   $0x55
  jmp alltraps
80106ee1:	e9 6f f6 ff ff       	jmp    80106555 <alltraps>

80106ee6 <vector86>:
.globl vector86
vector86:
  pushl $0
80106ee6:	6a 00                	push   $0x0
  pushl $86
80106ee8:	6a 56                	push   $0x56
  jmp alltraps
80106eea:	e9 66 f6 ff ff       	jmp    80106555 <alltraps>

80106eef <vector87>:
.globl vector87
vector87:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $87
80106ef1:	6a 57                	push   $0x57
  jmp alltraps
80106ef3:	e9 5d f6 ff ff       	jmp    80106555 <alltraps>

80106ef8 <vector88>:
.globl vector88
vector88:
  pushl $0
80106ef8:	6a 00                	push   $0x0
  pushl $88
80106efa:	6a 58                	push   $0x58
  jmp alltraps
80106efc:	e9 54 f6 ff ff       	jmp    80106555 <alltraps>

80106f01 <vector89>:
.globl vector89
vector89:
  pushl $0
80106f01:	6a 00                	push   $0x0
  pushl $89
80106f03:	6a 59                	push   $0x59
  jmp alltraps
80106f05:	e9 4b f6 ff ff       	jmp    80106555 <alltraps>

80106f0a <vector90>:
.globl vector90
vector90:
  pushl $0
80106f0a:	6a 00                	push   $0x0
  pushl $90
80106f0c:	6a 5a                	push   $0x5a
  jmp alltraps
80106f0e:	e9 42 f6 ff ff       	jmp    80106555 <alltraps>

80106f13 <vector91>:
.globl vector91
vector91:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $91
80106f15:	6a 5b                	push   $0x5b
  jmp alltraps
80106f17:	e9 39 f6 ff ff       	jmp    80106555 <alltraps>

80106f1c <vector92>:
.globl vector92
vector92:
  pushl $0
80106f1c:	6a 00                	push   $0x0
  pushl $92
80106f1e:	6a 5c                	push   $0x5c
  jmp alltraps
80106f20:	e9 30 f6 ff ff       	jmp    80106555 <alltraps>

80106f25 <vector93>:
.globl vector93
vector93:
  pushl $0
80106f25:	6a 00                	push   $0x0
  pushl $93
80106f27:	6a 5d                	push   $0x5d
  jmp alltraps
80106f29:	e9 27 f6 ff ff       	jmp    80106555 <alltraps>

80106f2e <vector94>:
.globl vector94
vector94:
  pushl $0
80106f2e:	6a 00                	push   $0x0
  pushl $94
80106f30:	6a 5e                	push   $0x5e
  jmp alltraps
80106f32:	e9 1e f6 ff ff       	jmp    80106555 <alltraps>

80106f37 <vector95>:
.globl vector95
vector95:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $95
80106f39:	6a 5f                	push   $0x5f
  jmp alltraps
80106f3b:	e9 15 f6 ff ff       	jmp    80106555 <alltraps>

80106f40 <vector96>:
.globl vector96
vector96:
  pushl $0
80106f40:	6a 00                	push   $0x0
  pushl $96
80106f42:	6a 60                	push   $0x60
  jmp alltraps
80106f44:	e9 0c f6 ff ff       	jmp    80106555 <alltraps>

80106f49 <vector97>:
.globl vector97
vector97:
  pushl $0
80106f49:	6a 00                	push   $0x0
  pushl $97
80106f4b:	6a 61                	push   $0x61
  jmp alltraps
80106f4d:	e9 03 f6 ff ff       	jmp    80106555 <alltraps>

80106f52 <vector98>:
.globl vector98
vector98:
  pushl $0
80106f52:	6a 00                	push   $0x0
  pushl $98
80106f54:	6a 62                	push   $0x62
  jmp alltraps
80106f56:	e9 fa f5 ff ff       	jmp    80106555 <alltraps>

80106f5b <vector99>:
.globl vector99
vector99:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $99
80106f5d:	6a 63                	push   $0x63
  jmp alltraps
80106f5f:	e9 f1 f5 ff ff       	jmp    80106555 <alltraps>

80106f64 <vector100>:
.globl vector100
vector100:
  pushl $0
80106f64:	6a 00                	push   $0x0
  pushl $100
80106f66:	6a 64                	push   $0x64
  jmp alltraps
80106f68:	e9 e8 f5 ff ff       	jmp    80106555 <alltraps>

80106f6d <vector101>:
.globl vector101
vector101:
  pushl $0
80106f6d:	6a 00                	push   $0x0
  pushl $101
80106f6f:	6a 65                	push   $0x65
  jmp alltraps
80106f71:	e9 df f5 ff ff       	jmp    80106555 <alltraps>

80106f76 <vector102>:
.globl vector102
vector102:
  pushl $0
80106f76:	6a 00                	push   $0x0
  pushl $102
80106f78:	6a 66                	push   $0x66
  jmp alltraps
80106f7a:	e9 d6 f5 ff ff       	jmp    80106555 <alltraps>

80106f7f <vector103>:
.globl vector103
vector103:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $103
80106f81:	6a 67                	push   $0x67
  jmp alltraps
80106f83:	e9 cd f5 ff ff       	jmp    80106555 <alltraps>

80106f88 <vector104>:
.globl vector104
vector104:
  pushl $0
80106f88:	6a 00                	push   $0x0
  pushl $104
80106f8a:	6a 68                	push   $0x68
  jmp alltraps
80106f8c:	e9 c4 f5 ff ff       	jmp    80106555 <alltraps>

80106f91 <vector105>:
.globl vector105
vector105:
  pushl $0
80106f91:	6a 00                	push   $0x0
  pushl $105
80106f93:	6a 69                	push   $0x69
  jmp alltraps
80106f95:	e9 bb f5 ff ff       	jmp    80106555 <alltraps>

80106f9a <vector106>:
.globl vector106
vector106:
  pushl $0
80106f9a:	6a 00                	push   $0x0
  pushl $106
80106f9c:	6a 6a                	push   $0x6a
  jmp alltraps
80106f9e:	e9 b2 f5 ff ff       	jmp    80106555 <alltraps>

80106fa3 <vector107>:
.globl vector107
vector107:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $107
80106fa5:	6a 6b                	push   $0x6b
  jmp alltraps
80106fa7:	e9 a9 f5 ff ff       	jmp    80106555 <alltraps>

80106fac <vector108>:
.globl vector108
vector108:
  pushl $0
80106fac:	6a 00                	push   $0x0
  pushl $108
80106fae:	6a 6c                	push   $0x6c
  jmp alltraps
80106fb0:	e9 a0 f5 ff ff       	jmp    80106555 <alltraps>

80106fb5 <vector109>:
.globl vector109
vector109:
  pushl $0
80106fb5:	6a 00                	push   $0x0
  pushl $109
80106fb7:	6a 6d                	push   $0x6d
  jmp alltraps
80106fb9:	e9 97 f5 ff ff       	jmp    80106555 <alltraps>

80106fbe <vector110>:
.globl vector110
vector110:
  pushl $0
80106fbe:	6a 00                	push   $0x0
  pushl $110
80106fc0:	6a 6e                	push   $0x6e
  jmp alltraps
80106fc2:	e9 8e f5 ff ff       	jmp    80106555 <alltraps>

80106fc7 <vector111>:
.globl vector111
vector111:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $111
80106fc9:	6a 6f                	push   $0x6f
  jmp alltraps
80106fcb:	e9 85 f5 ff ff       	jmp    80106555 <alltraps>

80106fd0 <vector112>:
.globl vector112
vector112:
  pushl $0
80106fd0:	6a 00                	push   $0x0
  pushl $112
80106fd2:	6a 70                	push   $0x70
  jmp alltraps
80106fd4:	e9 7c f5 ff ff       	jmp    80106555 <alltraps>

80106fd9 <vector113>:
.globl vector113
vector113:
  pushl $0
80106fd9:	6a 00                	push   $0x0
  pushl $113
80106fdb:	6a 71                	push   $0x71
  jmp alltraps
80106fdd:	e9 73 f5 ff ff       	jmp    80106555 <alltraps>

80106fe2 <vector114>:
.globl vector114
vector114:
  pushl $0
80106fe2:	6a 00                	push   $0x0
  pushl $114
80106fe4:	6a 72                	push   $0x72
  jmp alltraps
80106fe6:	e9 6a f5 ff ff       	jmp    80106555 <alltraps>

80106feb <vector115>:
.globl vector115
vector115:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $115
80106fed:	6a 73                	push   $0x73
  jmp alltraps
80106fef:	e9 61 f5 ff ff       	jmp    80106555 <alltraps>

80106ff4 <vector116>:
.globl vector116
vector116:
  pushl $0
80106ff4:	6a 00                	push   $0x0
  pushl $116
80106ff6:	6a 74                	push   $0x74
  jmp alltraps
80106ff8:	e9 58 f5 ff ff       	jmp    80106555 <alltraps>

80106ffd <vector117>:
.globl vector117
vector117:
  pushl $0
80106ffd:	6a 00                	push   $0x0
  pushl $117
80106fff:	6a 75                	push   $0x75
  jmp alltraps
80107001:	e9 4f f5 ff ff       	jmp    80106555 <alltraps>

80107006 <vector118>:
.globl vector118
vector118:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $118
80107008:	6a 76                	push   $0x76
  jmp alltraps
8010700a:	e9 46 f5 ff ff       	jmp    80106555 <alltraps>

8010700f <vector119>:
.globl vector119
vector119:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $119
80107011:	6a 77                	push   $0x77
  jmp alltraps
80107013:	e9 3d f5 ff ff       	jmp    80106555 <alltraps>

80107018 <vector120>:
.globl vector120
vector120:
  pushl $0
80107018:	6a 00                	push   $0x0
  pushl $120
8010701a:	6a 78                	push   $0x78
  jmp alltraps
8010701c:	e9 34 f5 ff ff       	jmp    80106555 <alltraps>

80107021 <vector121>:
.globl vector121
vector121:
  pushl $0
80107021:	6a 00                	push   $0x0
  pushl $121
80107023:	6a 79                	push   $0x79
  jmp alltraps
80107025:	e9 2b f5 ff ff       	jmp    80106555 <alltraps>

8010702a <vector122>:
.globl vector122
vector122:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $122
8010702c:	6a 7a                	push   $0x7a
  jmp alltraps
8010702e:	e9 22 f5 ff ff       	jmp    80106555 <alltraps>

80107033 <vector123>:
.globl vector123
vector123:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $123
80107035:	6a 7b                	push   $0x7b
  jmp alltraps
80107037:	e9 19 f5 ff ff       	jmp    80106555 <alltraps>

8010703c <vector124>:
.globl vector124
vector124:
  pushl $0
8010703c:	6a 00                	push   $0x0
  pushl $124
8010703e:	6a 7c                	push   $0x7c
  jmp alltraps
80107040:	e9 10 f5 ff ff       	jmp    80106555 <alltraps>

80107045 <vector125>:
.globl vector125
vector125:
  pushl $0
80107045:	6a 00                	push   $0x0
  pushl $125
80107047:	6a 7d                	push   $0x7d
  jmp alltraps
80107049:	e9 07 f5 ff ff       	jmp    80106555 <alltraps>

8010704e <vector126>:
.globl vector126
vector126:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $126
80107050:	6a 7e                	push   $0x7e
  jmp alltraps
80107052:	e9 fe f4 ff ff       	jmp    80106555 <alltraps>

80107057 <vector127>:
.globl vector127
vector127:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $127
80107059:	6a 7f                	push   $0x7f
  jmp alltraps
8010705b:	e9 f5 f4 ff ff       	jmp    80106555 <alltraps>

80107060 <vector128>:
.globl vector128
vector128:
  pushl $0
80107060:	6a 00                	push   $0x0
  pushl $128
80107062:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107067:	e9 e9 f4 ff ff       	jmp    80106555 <alltraps>

8010706c <vector129>:
.globl vector129
vector129:
  pushl $0
8010706c:	6a 00                	push   $0x0
  pushl $129
8010706e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107073:	e9 dd f4 ff ff       	jmp    80106555 <alltraps>

80107078 <vector130>:
.globl vector130
vector130:
  pushl $0
80107078:	6a 00                	push   $0x0
  pushl $130
8010707a:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010707f:	e9 d1 f4 ff ff       	jmp    80106555 <alltraps>

80107084 <vector131>:
.globl vector131
vector131:
  pushl $0
80107084:	6a 00                	push   $0x0
  pushl $131
80107086:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010708b:	e9 c5 f4 ff ff       	jmp    80106555 <alltraps>

80107090 <vector132>:
.globl vector132
vector132:
  pushl $0
80107090:	6a 00                	push   $0x0
  pushl $132
80107092:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107097:	e9 b9 f4 ff ff       	jmp    80106555 <alltraps>

8010709c <vector133>:
.globl vector133
vector133:
  pushl $0
8010709c:	6a 00                	push   $0x0
  pushl $133
8010709e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801070a3:	e9 ad f4 ff ff       	jmp    80106555 <alltraps>

801070a8 <vector134>:
.globl vector134
vector134:
  pushl $0
801070a8:	6a 00                	push   $0x0
  pushl $134
801070aa:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801070af:	e9 a1 f4 ff ff       	jmp    80106555 <alltraps>

801070b4 <vector135>:
.globl vector135
vector135:
  pushl $0
801070b4:	6a 00                	push   $0x0
  pushl $135
801070b6:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801070bb:	e9 95 f4 ff ff       	jmp    80106555 <alltraps>

801070c0 <vector136>:
.globl vector136
vector136:
  pushl $0
801070c0:	6a 00                	push   $0x0
  pushl $136
801070c2:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801070c7:	e9 89 f4 ff ff       	jmp    80106555 <alltraps>

801070cc <vector137>:
.globl vector137
vector137:
  pushl $0
801070cc:	6a 00                	push   $0x0
  pushl $137
801070ce:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801070d3:	e9 7d f4 ff ff       	jmp    80106555 <alltraps>

801070d8 <vector138>:
.globl vector138
vector138:
  pushl $0
801070d8:	6a 00                	push   $0x0
  pushl $138
801070da:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801070df:	e9 71 f4 ff ff       	jmp    80106555 <alltraps>

801070e4 <vector139>:
.globl vector139
vector139:
  pushl $0
801070e4:	6a 00                	push   $0x0
  pushl $139
801070e6:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801070eb:	e9 65 f4 ff ff       	jmp    80106555 <alltraps>

801070f0 <vector140>:
.globl vector140
vector140:
  pushl $0
801070f0:	6a 00                	push   $0x0
  pushl $140
801070f2:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801070f7:	e9 59 f4 ff ff       	jmp    80106555 <alltraps>

801070fc <vector141>:
.globl vector141
vector141:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $141
801070fe:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107103:	e9 4d f4 ff ff       	jmp    80106555 <alltraps>

80107108 <vector142>:
.globl vector142
vector142:
  pushl $0
80107108:	6a 00                	push   $0x0
  pushl $142
8010710a:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010710f:	e9 41 f4 ff ff       	jmp    80106555 <alltraps>

80107114 <vector143>:
.globl vector143
vector143:
  pushl $0
80107114:	6a 00                	push   $0x0
  pushl $143
80107116:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010711b:	e9 35 f4 ff ff       	jmp    80106555 <alltraps>

80107120 <vector144>:
.globl vector144
vector144:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $144
80107122:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107127:	e9 29 f4 ff ff       	jmp    80106555 <alltraps>

8010712c <vector145>:
.globl vector145
vector145:
  pushl $0
8010712c:	6a 00                	push   $0x0
  pushl $145
8010712e:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107133:	e9 1d f4 ff ff       	jmp    80106555 <alltraps>

80107138 <vector146>:
.globl vector146
vector146:
  pushl $0
80107138:	6a 00                	push   $0x0
  pushl $146
8010713a:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010713f:	e9 11 f4 ff ff       	jmp    80106555 <alltraps>

80107144 <vector147>:
.globl vector147
vector147:
  pushl $0
80107144:	6a 00                	push   $0x0
  pushl $147
80107146:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010714b:	e9 05 f4 ff ff       	jmp    80106555 <alltraps>

80107150 <vector148>:
.globl vector148
vector148:
  pushl $0
80107150:	6a 00                	push   $0x0
  pushl $148
80107152:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107157:	e9 f9 f3 ff ff       	jmp    80106555 <alltraps>

8010715c <vector149>:
.globl vector149
vector149:
  pushl $0
8010715c:	6a 00                	push   $0x0
  pushl $149
8010715e:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107163:	e9 ed f3 ff ff       	jmp    80106555 <alltraps>

80107168 <vector150>:
.globl vector150
vector150:
  pushl $0
80107168:	6a 00                	push   $0x0
  pushl $150
8010716a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010716f:	e9 e1 f3 ff ff       	jmp    80106555 <alltraps>

80107174 <vector151>:
.globl vector151
vector151:
  pushl $0
80107174:	6a 00                	push   $0x0
  pushl $151
80107176:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010717b:	e9 d5 f3 ff ff       	jmp    80106555 <alltraps>

80107180 <vector152>:
.globl vector152
vector152:
  pushl $0
80107180:	6a 00                	push   $0x0
  pushl $152
80107182:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107187:	e9 c9 f3 ff ff       	jmp    80106555 <alltraps>

8010718c <vector153>:
.globl vector153
vector153:
  pushl $0
8010718c:	6a 00                	push   $0x0
  pushl $153
8010718e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107193:	e9 bd f3 ff ff       	jmp    80106555 <alltraps>

80107198 <vector154>:
.globl vector154
vector154:
  pushl $0
80107198:	6a 00                	push   $0x0
  pushl $154
8010719a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010719f:	e9 b1 f3 ff ff       	jmp    80106555 <alltraps>

801071a4 <vector155>:
.globl vector155
vector155:
  pushl $0
801071a4:	6a 00                	push   $0x0
  pushl $155
801071a6:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801071ab:	e9 a5 f3 ff ff       	jmp    80106555 <alltraps>

801071b0 <vector156>:
.globl vector156
vector156:
  pushl $0
801071b0:	6a 00                	push   $0x0
  pushl $156
801071b2:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801071b7:	e9 99 f3 ff ff       	jmp    80106555 <alltraps>

801071bc <vector157>:
.globl vector157
vector157:
  pushl $0
801071bc:	6a 00                	push   $0x0
  pushl $157
801071be:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801071c3:	e9 8d f3 ff ff       	jmp    80106555 <alltraps>

801071c8 <vector158>:
.globl vector158
vector158:
  pushl $0
801071c8:	6a 00                	push   $0x0
  pushl $158
801071ca:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801071cf:	e9 81 f3 ff ff       	jmp    80106555 <alltraps>

801071d4 <vector159>:
.globl vector159
vector159:
  pushl $0
801071d4:	6a 00                	push   $0x0
  pushl $159
801071d6:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801071db:	e9 75 f3 ff ff       	jmp    80106555 <alltraps>

801071e0 <vector160>:
.globl vector160
vector160:
  pushl $0
801071e0:	6a 00                	push   $0x0
  pushl $160
801071e2:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801071e7:	e9 69 f3 ff ff       	jmp    80106555 <alltraps>

801071ec <vector161>:
.globl vector161
vector161:
  pushl $0
801071ec:	6a 00                	push   $0x0
  pushl $161
801071ee:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801071f3:	e9 5d f3 ff ff       	jmp    80106555 <alltraps>

801071f8 <vector162>:
.globl vector162
vector162:
  pushl $0
801071f8:	6a 00                	push   $0x0
  pushl $162
801071fa:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801071ff:	e9 51 f3 ff ff       	jmp    80106555 <alltraps>

80107204 <vector163>:
.globl vector163
vector163:
  pushl $0
80107204:	6a 00                	push   $0x0
  pushl $163
80107206:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010720b:	e9 45 f3 ff ff       	jmp    80106555 <alltraps>

80107210 <vector164>:
.globl vector164
vector164:
  pushl $0
80107210:	6a 00                	push   $0x0
  pushl $164
80107212:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107217:	e9 39 f3 ff ff       	jmp    80106555 <alltraps>

8010721c <vector165>:
.globl vector165
vector165:
  pushl $0
8010721c:	6a 00                	push   $0x0
  pushl $165
8010721e:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107223:	e9 2d f3 ff ff       	jmp    80106555 <alltraps>

80107228 <vector166>:
.globl vector166
vector166:
  pushl $0
80107228:	6a 00                	push   $0x0
  pushl $166
8010722a:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010722f:	e9 21 f3 ff ff       	jmp    80106555 <alltraps>

80107234 <vector167>:
.globl vector167
vector167:
  pushl $0
80107234:	6a 00                	push   $0x0
  pushl $167
80107236:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010723b:	e9 15 f3 ff ff       	jmp    80106555 <alltraps>

80107240 <vector168>:
.globl vector168
vector168:
  pushl $0
80107240:	6a 00                	push   $0x0
  pushl $168
80107242:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107247:	e9 09 f3 ff ff       	jmp    80106555 <alltraps>

8010724c <vector169>:
.globl vector169
vector169:
  pushl $0
8010724c:	6a 00                	push   $0x0
  pushl $169
8010724e:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107253:	e9 fd f2 ff ff       	jmp    80106555 <alltraps>

80107258 <vector170>:
.globl vector170
vector170:
  pushl $0
80107258:	6a 00                	push   $0x0
  pushl $170
8010725a:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010725f:	e9 f1 f2 ff ff       	jmp    80106555 <alltraps>

80107264 <vector171>:
.globl vector171
vector171:
  pushl $0
80107264:	6a 00                	push   $0x0
  pushl $171
80107266:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010726b:	e9 e5 f2 ff ff       	jmp    80106555 <alltraps>

80107270 <vector172>:
.globl vector172
vector172:
  pushl $0
80107270:	6a 00                	push   $0x0
  pushl $172
80107272:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107277:	e9 d9 f2 ff ff       	jmp    80106555 <alltraps>

8010727c <vector173>:
.globl vector173
vector173:
  pushl $0
8010727c:	6a 00                	push   $0x0
  pushl $173
8010727e:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107283:	e9 cd f2 ff ff       	jmp    80106555 <alltraps>

80107288 <vector174>:
.globl vector174
vector174:
  pushl $0
80107288:	6a 00                	push   $0x0
  pushl $174
8010728a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010728f:	e9 c1 f2 ff ff       	jmp    80106555 <alltraps>

80107294 <vector175>:
.globl vector175
vector175:
  pushl $0
80107294:	6a 00                	push   $0x0
  pushl $175
80107296:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010729b:	e9 b5 f2 ff ff       	jmp    80106555 <alltraps>

801072a0 <vector176>:
.globl vector176
vector176:
  pushl $0
801072a0:	6a 00                	push   $0x0
  pushl $176
801072a2:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801072a7:	e9 a9 f2 ff ff       	jmp    80106555 <alltraps>

801072ac <vector177>:
.globl vector177
vector177:
  pushl $0
801072ac:	6a 00                	push   $0x0
  pushl $177
801072ae:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801072b3:	e9 9d f2 ff ff       	jmp    80106555 <alltraps>

801072b8 <vector178>:
.globl vector178
vector178:
  pushl $0
801072b8:	6a 00                	push   $0x0
  pushl $178
801072ba:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801072bf:	e9 91 f2 ff ff       	jmp    80106555 <alltraps>

801072c4 <vector179>:
.globl vector179
vector179:
  pushl $0
801072c4:	6a 00                	push   $0x0
  pushl $179
801072c6:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801072cb:	e9 85 f2 ff ff       	jmp    80106555 <alltraps>

801072d0 <vector180>:
.globl vector180
vector180:
  pushl $0
801072d0:	6a 00                	push   $0x0
  pushl $180
801072d2:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801072d7:	e9 79 f2 ff ff       	jmp    80106555 <alltraps>

801072dc <vector181>:
.globl vector181
vector181:
  pushl $0
801072dc:	6a 00                	push   $0x0
  pushl $181
801072de:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801072e3:	e9 6d f2 ff ff       	jmp    80106555 <alltraps>

801072e8 <vector182>:
.globl vector182
vector182:
  pushl $0
801072e8:	6a 00                	push   $0x0
  pushl $182
801072ea:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801072ef:	e9 61 f2 ff ff       	jmp    80106555 <alltraps>

801072f4 <vector183>:
.globl vector183
vector183:
  pushl $0
801072f4:	6a 00                	push   $0x0
  pushl $183
801072f6:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801072fb:	e9 55 f2 ff ff       	jmp    80106555 <alltraps>

80107300 <vector184>:
.globl vector184
vector184:
  pushl $0
80107300:	6a 00                	push   $0x0
  pushl $184
80107302:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107307:	e9 49 f2 ff ff       	jmp    80106555 <alltraps>

8010730c <vector185>:
.globl vector185
vector185:
  pushl $0
8010730c:	6a 00                	push   $0x0
  pushl $185
8010730e:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107313:	e9 3d f2 ff ff       	jmp    80106555 <alltraps>

80107318 <vector186>:
.globl vector186
vector186:
  pushl $0
80107318:	6a 00                	push   $0x0
  pushl $186
8010731a:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010731f:	e9 31 f2 ff ff       	jmp    80106555 <alltraps>

80107324 <vector187>:
.globl vector187
vector187:
  pushl $0
80107324:	6a 00                	push   $0x0
  pushl $187
80107326:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010732b:	e9 25 f2 ff ff       	jmp    80106555 <alltraps>

80107330 <vector188>:
.globl vector188
vector188:
  pushl $0
80107330:	6a 00                	push   $0x0
  pushl $188
80107332:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107337:	e9 19 f2 ff ff       	jmp    80106555 <alltraps>

8010733c <vector189>:
.globl vector189
vector189:
  pushl $0
8010733c:	6a 00                	push   $0x0
  pushl $189
8010733e:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107343:	e9 0d f2 ff ff       	jmp    80106555 <alltraps>

80107348 <vector190>:
.globl vector190
vector190:
  pushl $0
80107348:	6a 00                	push   $0x0
  pushl $190
8010734a:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010734f:	e9 01 f2 ff ff       	jmp    80106555 <alltraps>

80107354 <vector191>:
.globl vector191
vector191:
  pushl $0
80107354:	6a 00                	push   $0x0
  pushl $191
80107356:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010735b:	e9 f5 f1 ff ff       	jmp    80106555 <alltraps>

80107360 <vector192>:
.globl vector192
vector192:
  pushl $0
80107360:	6a 00                	push   $0x0
  pushl $192
80107362:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107367:	e9 e9 f1 ff ff       	jmp    80106555 <alltraps>

8010736c <vector193>:
.globl vector193
vector193:
  pushl $0
8010736c:	6a 00                	push   $0x0
  pushl $193
8010736e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107373:	e9 dd f1 ff ff       	jmp    80106555 <alltraps>

80107378 <vector194>:
.globl vector194
vector194:
  pushl $0
80107378:	6a 00                	push   $0x0
  pushl $194
8010737a:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010737f:	e9 d1 f1 ff ff       	jmp    80106555 <alltraps>

80107384 <vector195>:
.globl vector195
vector195:
  pushl $0
80107384:	6a 00                	push   $0x0
  pushl $195
80107386:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010738b:	e9 c5 f1 ff ff       	jmp    80106555 <alltraps>

80107390 <vector196>:
.globl vector196
vector196:
  pushl $0
80107390:	6a 00                	push   $0x0
  pushl $196
80107392:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107397:	e9 b9 f1 ff ff       	jmp    80106555 <alltraps>

8010739c <vector197>:
.globl vector197
vector197:
  pushl $0
8010739c:	6a 00                	push   $0x0
  pushl $197
8010739e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801073a3:	e9 ad f1 ff ff       	jmp    80106555 <alltraps>

801073a8 <vector198>:
.globl vector198
vector198:
  pushl $0
801073a8:	6a 00                	push   $0x0
  pushl $198
801073aa:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801073af:	e9 a1 f1 ff ff       	jmp    80106555 <alltraps>

801073b4 <vector199>:
.globl vector199
vector199:
  pushl $0
801073b4:	6a 00                	push   $0x0
  pushl $199
801073b6:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801073bb:	e9 95 f1 ff ff       	jmp    80106555 <alltraps>

801073c0 <vector200>:
.globl vector200
vector200:
  pushl $0
801073c0:	6a 00                	push   $0x0
  pushl $200
801073c2:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801073c7:	e9 89 f1 ff ff       	jmp    80106555 <alltraps>

801073cc <vector201>:
.globl vector201
vector201:
  pushl $0
801073cc:	6a 00                	push   $0x0
  pushl $201
801073ce:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801073d3:	e9 7d f1 ff ff       	jmp    80106555 <alltraps>

801073d8 <vector202>:
.globl vector202
vector202:
  pushl $0
801073d8:	6a 00                	push   $0x0
  pushl $202
801073da:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801073df:	e9 71 f1 ff ff       	jmp    80106555 <alltraps>

801073e4 <vector203>:
.globl vector203
vector203:
  pushl $0
801073e4:	6a 00                	push   $0x0
  pushl $203
801073e6:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801073eb:	e9 65 f1 ff ff       	jmp    80106555 <alltraps>

801073f0 <vector204>:
.globl vector204
vector204:
  pushl $0
801073f0:	6a 00                	push   $0x0
  pushl $204
801073f2:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801073f7:	e9 59 f1 ff ff       	jmp    80106555 <alltraps>

801073fc <vector205>:
.globl vector205
vector205:
  pushl $0
801073fc:	6a 00                	push   $0x0
  pushl $205
801073fe:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107403:	e9 4d f1 ff ff       	jmp    80106555 <alltraps>

80107408 <vector206>:
.globl vector206
vector206:
  pushl $0
80107408:	6a 00                	push   $0x0
  pushl $206
8010740a:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010740f:	e9 41 f1 ff ff       	jmp    80106555 <alltraps>

80107414 <vector207>:
.globl vector207
vector207:
  pushl $0
80107414:	6a 00                	push   $0x0
  pushl $207
80107416:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010741b:	e9 35 f1 ff ff       	jmp    80106555 <alltraps>

80107420 <vector208>:
.globl vector208
vector208:
  pushl $0
80107420:	6a 00                	push   $0x0
  pushl $208
80107422:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107427:	e9 29 f1 ff ff       	jmp    80106555 <alltraps>

8010742c <vector209>:
.globl vector209
vector209:
  pushl $0
8010742c:	6a 00                	push   $0x0
  pushl $209
8010742e:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107433:	e9 1d f1 ff ff       	jmp    80106555 <alltraps>

80107438 <vector210>:
.globl vector210
vector210:
  pushl $0
80107438:	6a 00                	push   $0x0
  pushl $210
8010743a:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010743f:	e9 11 f1 ff ff       	jmp    80106555 <alltraps>

80107444 <vector211>:
.globl vector211
vector211:
  pushl $0
80107444:	6a 00                	push   $0x0
  pushl $211
80107446:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010744b:	e9 05 f1 ff ff       	jmp    80106555 <alltraps>

80107450 <vector212>:
.globl vector212
vector212:
  pushl $0
80107450:	6a 00                	push   $0x0
  pushl $212
80107452:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107457:	e9 f9 f0 ff ff       	jmp    80106555 <alltraps>

8010745c <vector213>:
.globl vector213
vector213:
  pushl $0
8010745c:	6a 00                	push   $0x0
  pushl $213
8010745e:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107463:	e9 ed f0 ff ff       	jmp    80106555 <alltraps>

80107468 <vector214>:
.globl vector214
vector214:
  pushl $0
80107468:	6a 00                	push   $0x0
  pushl $214
8010746a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010746f:	e9 e1 f0 ff ff       	jmp    80106555 <alltraps>

80107474 <vector215>:
.globl vector215
vector215:
  pushl $0
80107474:	6a 00                	push   $0x0
  pushl $215
80107476:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010747b:	e9 d5 f0 ff ff       	jmp    80106555 <alltraps>

80107480 <vector216>:
.globl vector216
vector216:
  pushl $0
80107480:	6a 00                	push   $0x0
  pushl $216
80107482:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107487:	e9 c9 f0 ff ff       	jmp    80106555 <alltraps>

8010748c <vector217>:
.globl vector217
vector217:
  pushl $0
8010748c:	6a 00                	push   $0x0
  pushl $217
8010748e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107493:	e9 bd f0 ff ff       	jmp    80106555 <alltraps>

80107498 <vector218>:
.globl vector218
vector218:
  pushl $0
80107498:	6a 00                	push   $0x0
  pushl $218
8010749a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010749f:	e9 b1 f0 ff ff       	jmp    80106555 <alltraps>

801074a4 <vector219>:
.globl vector219
vector219:
  pushl $0
801074a4:	6a 00                	push   $0x0
  pushl $219
801074a6:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801074ab:	e9 a5 f0 ff ff       	jmp    80106555 <alltraps>

801074b0 <vector220>:
.globl vector220
vector220:
  pushl $0
801074b0:	6a 00                	push   $0x0
  pushl $220
801074b2:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801074b7:	e9 99 f0 ff ff       	jmp    80106555 <alltraps>

801074bc <vector221>:
.globl vector221
vector221:
  pushl $0
801074bc:	6a 00                	push   $0x0
  pushl $221
801074be:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801074c3:	e9 8d f0 ff ff       	jmp    80106555 <alltraps>

801074c8 <vector222>:
.globl vector222
vector222:
  pushl $0
801074c8:	6a 00                	push   $0x0
  pushl $222
801074ca:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801074cf:	e9 81 f0 ff ff       	jmp    80106555 <alltraps>

801074d4 <vector223>:
.globl vector223
vector223:
  pushl $0
801074d4:	6a 00                	push   $0x0
  pushl $223
801074d6:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801074db:	e9 75 f0 ff ff       	jmp    80106555 <alltraps>

801074e0 <vector224>:
.globl vector224
vector224:
  pushl $0
801074e0:	6a 00                	push   $0x0
  pushl $224
801074e2:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801074e7:	e9 69 f0 ff ff       	jmp    80106555 <alltraps>

801074ec <vector225>:
.globl vector225
vector225:
  pushl $0
801074ec:	6a 00                	push   $0x0
  pushl $225
801074ee:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801074f3:	e9 5d f0 ff ff       	jmp    80106555 <alltraps>

801074f8 <vector226>:
.globl vector226
vector226:
  pushl $0
801074f8:	6a 00                	push   $0x0
  pushl $226
801074fa:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801074ff:	e9 51 f0 ff ff       	jmp    80106555 <alltraps>

80107504 <vector227>:
.globl vector227
vector227:
  pushl $0
80107504:	6a 00                	push   $0x0
  pushl $227
80107506:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010750b:	e9 45 f0 ff ff       	jmp    80106555 <alltraps>

80107510 <vector228>:
.globl vector228
vector228:
  pushl $0
80107510:	6a 00                	push   $0x0
  pushl $228
80107512:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107517:	e9 39 f0 ff ff       	jmp    80106555 <alltraps>

8010751c <vector229>:
.globl vector229
vector229:
  pushl $0
8010751c:	6a 00                	push   $0x0
  pushl $229
8010751e:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107523:	e9 2d f0 ff ff       	jmp    80106555 <alltraps>

80107528 <vector230>:
.globl vector230
vector230:
  pushl $0
80107528:	6a 00                	push   $0x0
  pushl $230
8010752a:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010752f:	e9 21 f0 ff ff       	jmp    80106555 <alltraps>

80107534 <vector231>:
.globl vector231
vector231:
  pushl $0
80107534:	6a 00                	push   $0x0
  pushl $231
80107536:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010753b:	e9 15 f0 ff ff       	jmp    80106555 <alltraps>

80107540 <vector232>:
.globl vector232
vector232:
  pushl $0
80107540:	6a 00                	push   $0x0
  pushl $232
80107542:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107547:	e9 09 f0 ff ff       	jmp    80106555 <alltraps>

8010754c <vector233>:
.globl vector233
vector233:
  pushl $0
8010754c:	6a 00                	push   $0x0
  pushl $233
8010754e:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107553:	e9 fd ef ff ff       	jmp    80106555 <alltraps>

80107558 <vector234>:
.globl vector234
vector234:
  pushl $0
80107558:	6a 00                	push   $0x0
  pushl $234
8010755a:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010755f:	e9 f1 ef ff ff       	jmp    80106555 <alltraps>

80107564 <vector235>:
.globl vector235
vector235:
  pushl $0
80107564:	6a 00                	push   $0x0
  pushl $235
80107566:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010756b:	e9 e5 ef ff ff       	jmp    80106555 <alltraps>

80107570 <vector236>:
.globl vector236
vector236:
  pushl $0
80107570:	6a 00                	push   $0x0
  pushl $236
80107572:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107577:	e9 d9 ef ff ff       	jmp    80106555 <alltraps>

8010757c <vector237>:
.globl vector237
vector237:
  pushl $0
8010757c:	6a 00                	push   $0x0
  pushl $237
8010757e:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107583:	e9 cd ef ff ff       	jmp    80106555 <alltraps>

80107588 <vector238>:
.globl vector238
vector238:
  pushl $0
80107588:	6a 00                	push   $0x0
  pushl $238
8010758a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010758f:	e9 c1 ef ff ff       	jmp    80106555 <alltraps>

80107594 <vector239>:
.globl vector239
vector239:
  pushl $0
80107594:	6a 00                	push   $0x0
  pushl $239
80107596:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010759b:	e9 b5 ef ff ff       	jmp    80106555 <alltraps>

801075a0 <vector240>:
.globl vector240
vector240:
  pushl $0
801075a0:	6a 00                	push   $0x0
  pushl $240
801075a2:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801075a7:	e9 a9 ef ff ff       	jmp    80106555 <alltraps>

801075ac <vector241>:
.globl vector241
vector241:
  pushl $0
801075ac:	6a 00                	push   $0x0
  pushl $241
801075ae:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801075b3:	e9 9d ef ff ff       	jmp    80106555 <alltraps>

801075b8 <vector242>:
.globl vector242
vector242:
  pushl $0
801075b8:	6a 00                	push   $0x0
  pushl $242
801075ba:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801075bf:	e9 91 ef ff ff       	jmp    80106555 <alltraps>

801075c4 <vector243>:
.globl vector243
vector243:
  pushl $0
801075c4:	6a 00                	push   $0x0
  pushl $243
801075c6:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801075cb:	e9 85 ef ff ff       	jmp    80106555 <alltraps>

801075d0 <vector244>:
.globl vector244
vector244:
  pushl $0
801075d0:	6a 00                	push   $0x0
  pushl $244
801075d2:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801075d7:	e9 79 ef ff ff       	jmp    80106555 <alltraps>

801075dc <vector245>:
.globl vector245
vector245:
  pushl $0
801075dc:	6a 00                	push   $0x0
  pushl $245
801075de:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801075e3:	e9 6d ef ff ff       	jmp    80106555 <alltraps>

801075e8 <vector246>:
.globl vector246
vector246:
  pushl $0
801075e8:	6a 00                	push   $0x0
  pushl $246
801075ea:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801075ef:	e9 61 ef ff ff       	jmp    80106555 <alltraps>

801075f4 <vector247>:
.globl vector247
vector247:
  pushl $0
801075f4:	6a 00                	push   $0x0
  pushl $247
801075f6:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801075fb:	e9 55 ef ff ff       	jmp    80106555 <alltraps>

80107600 <vector248>:
.globl vector248
vector248:
  pushl $0
80107600:	6a 00                	push   $0x0
  pushl $248
80107602:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107607:	e9 49 ef ff ff       	jmp    80106555 <alltraps>

8010760c <vector249>:
.globl vector249
vector249:
  pushl $0
8010760c:	6a 00                	push   $0x0
  pushl $249
8010760e:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107613:	e9 3d ef ff ff       	jmp    80106555 <alltraps>

80107618 <vector250>:
.globl vector250
vector250:
  pushl $0
80107618:	6a 00                	push   $0x0
  pushl $250
8010761a:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010761f:	e9 31 ef ff ff       	jmp    80106555 <alltraps>

80107624 <vector251>:
.globl vector251
vector251:
  pushl $0
80107624:	6a 00                	push   $0x0
  pushl $251
80107626:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010762b:	e9 25 ef ff ff       	jmp    80106555 <alltraps>

80107630 <vector252>:
.globl vector252
vector252:
  pushl $0
80107630:	6a 00                	push   $0x0
  pushl $252
80107632:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107637:	e9 19 ef ff ff       	jmp    80106555 <alltraps>

8010763c <vector253>:
.globl vector253
vector253:
  pushl $0
8010763c:	6a 00                	push   $0x0
  pushl $253
8010763e:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107643:	e9 0d ef ff ff       	jmp    80106555 <alltraps>

80107648 <vector254>:
.globl vector254
vector254:
  pushl $0
80107648:	6a 00                	push   $0x0
  pushl $254
8010764a:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010764f:	e9 01 ef ff ff       	jmp    80106555 <alltraps>

80107654 <vector255>:
.globl vector255
vector255:
  pushl $0
80107654:	6a 00                	push   $0x0
  pushl $255
80107656:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010765b:	e9 f5 ee ff ff       	jmp    80106555 <alltraps>

80107660 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107666:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010766c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107672:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80107675:	39 d3                	cmp    %edx,%ebx
80107677:	73 56                	jae    801076cf <deallocuvm.part.0+0x6f>
80107679:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010767c:	89 c6                	mov    %eax,%esi
8010767e:	89 d7                	mov    %edx,%edi
80107680:	eb 12                	jmp    80107694 <deallocuvm.part.0+0x34>
80107682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107688:	83 c2 01             	add    $0x1,%edx
8010768b:	89 d3                	mov    %edx,%ebx
8010768d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107690:	39 fb                	cmp    %edi,%ebx
80107692:	73 38                	jae    801076cc <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80107694:	89 da                	mov    %ebx,%edx
80107696:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107699:	8b 04 96             	mov    (%esi,%edx,4),%eax
8010769c:	a8 01                	test   $0x1,%al
8010769e:	74 e8                	je     80107688 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
801076a0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801076a7:	c1 e9 0a             	shr    $0xa,%ecx
801076aa:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801076b0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801076b7:	85 c0                	test   %eax,%eax
801076b9:	74 cd                	je     80107688 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
801076bb:	8b 10                	mov    (%eax),%edx
801076bd:	f6 c2 01             	test   $0x1,%dl
801076c0:	75 1e                	jne    801076e0 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
801076c2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076c8:	39 fb                	cmp    %edi,%ebx
801076ca:	72 c8                	jb     80107694 <deallocuvm.part.0+0x34>
801076cc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801076cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d2:	89 c8                	mov    %ecx,%eax
801076d4:	5b                   	pop    %ebx
801076d5:	5e                   	pop    %esi
801076d6:	5f                   	pop    %edi
801076d7:	5d                   	pop    %ebp
801076d8:	c3                   	ret
801076d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
801076e0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801076e6:	74 26                	je     8010770e <deallocuvm.part.0+0xae>
      kfree(v);
801076e8:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801076eb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801076f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801076f4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801076fa:	52                   	push   %edx
801076fb:	e8 d0 ad ff ff       	call   801024d0 <kfree>
      *pte = 0;
80107700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80107703:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010770c:	eb 82                	jmp    80107690 <deallocuvm.part.0+0x30>
        panic("kfree");
8010770e:	83 ec 0c             	sub    $0xc,%esp
80107711:	68 ec 81 10 80       	push   $0x801081ec
80107716:	e8 65 8c ff ff       	call   80100380 <panic>
8010771b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107720 <mappages>:
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	57                   	push   %edi
80107724:	56                   	push   %esi
80107725:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107726:	89 d3                	mov    %edx,%ebx
80107728:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010772e:	83 ec 1c             	sub    $0x1c,%esp
80107731:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107734:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107738:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010773d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107740:	8b 45 08             	mov    0x8(%ebp),%eax
80107743:	29 d8                	sub    %ebx,%eax
80107745:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107748:	eb 3f                	jmp    80107789 <mappages+0x69>
8010774a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107750:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107752:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107757:	c1 ea 0a             	shr    $0xa,%edx
8010775a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107760:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107767:	85 c0                	test   %eax,%eax
80107769:	74 75                	je     801077e0 <mappages+0xc0>
    if(*pte & PTE_P)
8010776b:	f6 00 01             	testb  $0x1,(%eax)
8010776e:	0f 85 86 00 00 00    	jne    801077fa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107774:	0b 75 0c             	or     0xc(%ebp),%esi
80107777:	83 ce 01             	or     $0x1,%esi
8010777a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010777c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010777f:	39 c3                	cmp    %eax,%ebx
80107781:	74 6d                	je     801077f0 <mappages+0xd0>
    a += PGSIZE;
80107783:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010778c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010778f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80107792:	89 d8                	mov    %ebx,%eax
80107794:	c1 e8 16             	shr    $0x16,%eax
80107797:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
8010779a:	8b 07                	mov    (%edi),%eax
8010779c:	a8 01                	test   $0x1,%al
8010779e:	75 b0                	jne    80107750 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801077a0:	e8 eb ae ff ff       	call   80102690 <kalloc>
801077a5:	85 c0                	test   %eax,%eax
801077a7:	74 37                	je     801077e0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801077a9:	83 ec 04             	sub    $0x4,%esp
801077ac:	68 00 10 00 00       	push   $0x1000
801077b1:	6a 00                	push   $0x0
801077b3:	50                   	push   %eax
801077b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
801077b7:	e8 c4 da ff ff       	call   80105280 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801077bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801077bf:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801077c2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801077c8:	83 c8 07             	or     $0x7,%eax
801077cb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801077cd:	89 d8                	mov    %ebx,%eax
801077cf:	c1 e8 0a             	shr    $0xa,%eax
801077d2:	25 fc 0f 00 00       	and    $0xffc,%eax
801077d7:	01 d0                	add    %edx,%eax
801077d9:	eb 90                	jmp    8010776b <mappages+0x4b>
801077db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
801077e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077e8:	5b                   	pop    %ebx
801077e9:	5e                   	pop    %esi
801077ea:	5f                   	pop    %edi
801077eb:	5d                   	pop    %ebp
801077ec:	c3                   	ret
801077ed:	8d 76 00             	lea    0x0(%esi),%esi
801077f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077f3:	31 c0                	xor    %eax,%eax
}
801077f5:	5b                   	pop    %ebx
801077f6:	5e                   	pop    %esi
801077f7:	5f                   	pop    %edi
801077f8:	5d                   	pop    %ebp
801077f9:	c3                   	ret
      panic("remap");
801077fa:	83 ec 0c             	sub    $0xc,%esp
801077fd:	68 c9 84 10 80       	push   $0x801084c9
80107802:	e8 79 8b ff ff       	call   80100380 <panic>
80107807:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010780e:	00 
8010780f:	90                   	nop

80107810 <seginit>:
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107816:	e8 75 c2 ff ff       	call   80103a90 <cpuid>
  pd[0] = size-1;
8010781b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107820:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107826:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
8010782a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107831:	ff 00 00 
80107834:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010783b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010783e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107845:	ff 00 00 
80107848:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010784f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107852:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107859:	ff 00 00 
8010785c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107863:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107866:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
8010786d:	ff 00 00 
80107870:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107877:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010787a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
8010787f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107883:	c1 e8 10             	shr    $0x10,%eax
80107886:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010788a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010788d:	0f 01 10             	lgdtl  (%eax)
}
80107890:	c9                   	leave
80107891:	c3                   	ret
80107892:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107899:	00 
8010789a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078a0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801078a0:	a1 e4 5e 11 80       	mov    0x80115ee4,%eax
801078a5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801078aa:	0f 22 d8             	mov    %eax,%cr3
}
801078ad:	c3                   	ret
801078ae:	66 90                	xchg   %ax,%ax

801078b0 <switchuvm>:
{
801078b0:	55                   	push   %ebp
801078b1:	89 e5                	mov    %esp,%ebp
801078b3:	57                   	push   %edi
801078b4:	56                   	push   %esi
801078b5:	53                   	push   %ebx
801078b6:	83 ec 1c             	sub    $0x1c,%esp
801078b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801078bc:	85 f6                	test   %esi,%esi
801078be:	0f 84 cb 00 00 00    	je     8010798f <switchuvm+0xdf>
  if(p->kstack == 0)
801078c4:	8b 46 08             	mov    0x8(%esi),%eax
801078c7:	85 c0                	test   %eax,%eax
801078c9:	0f 84 da 00 00 00    	je     801079a9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801078cf:	8b 46 04             	mov    0x4(%esi),%eax
801078d2:	85 c0                	test   %eax,%eax
801078d4:	0f 84 c2 00 00 00    	je     8010799c <switchuvm+0xec>
  pushcli();
801078da:	e8 51 d7 ff ff       	call   80105030 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078df:	e8 4c c1 ff ff       	call   80103a30 <mycpu>
801078e4:	89 c3                	mov    %eax,%ebx
801078e6:	e8 45 c1 ff ff       	call   80103a30 <mycpu>
801078eb:	89 c7                	mov    %eax,%edi
801078ed:	e8 3e c1 ff ff       	call   80103a30 <mycpu>
801078f2:	83 c7 08             	add    $0x8,%edi
801078f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801078f8:	e8 33 c1 ff ff       	call   80103a30 <mycpu>
801078fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107900:	ba 67 00 00 00       	mov    $0x67,%edx
80107905:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010790c:	83 c0 08             	add    $0x8,%eax
8010790f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107916:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010791b:	83 c1 08             	add    $0x8,%ecx
8010791e:	c1 e8 18             	shr    $0x18,%eax
80107921:	c1 e9 10             	shr    $0x10,%ecx
80107924:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010792a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107930:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107935:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010793c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107941:	e8 ea c0 ff ff       	call   80103a30 <mycpu>
80107946:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010794d:	e8 de c0 ff ff       	call   80103a30 <mycpu>
80107952:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107956:	8b 5e 08             	mov    0x8(%esi),%ebx
80107959:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010795f:	e8 cc c0 ff ff       	call   80103a30 <mycpu>
80107964:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107967:	e8 c4 c0 ff ff       	call   80103a30 <mycpu>
8010796c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107970:	b8 28 00 00 00       	mov    $0x28,%eax
80107975:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107978:	8b 46 04             	mov    0x4(%esi),%eax
8010797b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107980:	0f 22 d8             	mov    %eax,%cr3
}
80107983:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107986:	5b                   	pop    %ebx
80107987:	5e                   	pop    %esi
80107988:	5f                   	pop    %edi
80107989:	5d                   	pop    %ebp
  popcli();
8010798a:	e9 f1 d6 ff ff       	jmp    80105080 <popcli>
    panic("switchuvm: no process");
8010798f:	83 ec 0c             	sub    $0xc,%esp
80107992:	68 cf 84 10 80       	push   $0x801084cf
80107997:	e8 e4 89 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010799c:	83 ec 0c             	sub    $0xc,%esp
8010799f:	68 fa 84 10 80       	push   $0x801084fa
801079a4:	e8 d7 89 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801079a9:	83 ec 0c             	sub    $0xc,%esp
801079ac:	68 e5 84 10 80       	push   $0x801084e5
801079b1:	e8 ca 89 ff ff       	call   80100380 <panic>
801079b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801079bd:	00 
801079be:	66 90                	xchg   %ax,%ax

801079c0 <inituvm>:
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	57                   	push   %edi
801079c4:	56                   	push   %esi
801079c5:	53                   	push   %ebx
801079c6:	83 ec 1c             	sub    $0x1c,%esp
801079c9:	8b 45 08             	mov    0x8(%ebp),%eax
801079cc:	8b 75 10             	mov    0x10(%ebp),%esi
801079cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
801079d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801079d5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801079db:	77 49                	ja     80107a26 <inituvm+0x66>
  mem = kalloc();
801079dd:	e8 ae ac ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
801079e2:	83 ec 04             	sub    $0x4,%esp
801079e5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801079ea:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801079ec:	6a 00                	push   $0x0
801079ee:	50                   	push   %eax
801079ef:	e8 8c d8 ff ff       	call   80105280 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801079f4:	58                   	pop    %eax
801079f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079fb:	5a                   	pop    %edx
801079fc:	6a 06                	push   $0x6
801079fe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a03:	31 d2                	xor    %edx,%edx
80107a05:	50                   	push   %eax
80107a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a09:	e8 12 fd ff ff       	call   80107720 <mappages>
  memmove(mem, init, sz);
80107a0e:	83 c4 10             	add    $0x10,%esp
80107a11:	89 75 10             	mov    %esi,0x10(%ebp)
80107a14:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107a17:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107a1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a1d:	5b                   	pop    %ebx
80107a1e:	5e                   	pop    %esi
80107a1f:	5f                   	pop    %edi
80107a20:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107a21:	e9 ea d8 ff ff       	jmp    80105310 <memmove>
    panic("inituvm: more than a page");
80107a26:	83 ec 0c             	sub    $0xc,%esp
80107a29:	68 0e 85 10 80       	push   $0x8010850e
80107a2e:	e8 4d 89 ff ff       	call   80100380 <panic>
80107a33:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107a3a:	00 
80107a3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80107a40 <loaduvm>:
{
80107a40:	55                   	push   %ebp
80107a41:	89 e5                	mov    %esp,%ebp
80107a43:	57                   	push   %edi
80107a44:	56                   	push   %esi
80107a45:	53                   	push   %ebx
80107a46:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107a49:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80107a4c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80107a4f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80107a55:	0f 85 a2 00 00 00    	jne    80107afd <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80107a5b:	85 ff                	test   %edi,%edi
80107a5d:	74 7d                	je     80107adc <loaduvm+0x9c>
80107a5f:	90                   	nop
  pde = &pgdir[PDX(va)];
80107a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107a63:	8b 55 08             	mov    0x8(%ebp),%edx
80107a66:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80107a68:	89 c1                	mov    %eax,%ecx
80107a6a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107a6d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80107a70:	f6 c1 01             	test   $0x1,%cl
80107a73:	75 13                	jne    80107a88 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80107a75:	83 ec 0c             	sub    $0xc,%esp
80107a78:	68 28 85 10 80       	push   $0x80108528
80107a7d:	e8 fe 88 ff ff       	call   80100380 <panic>
80107a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107a88:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a8b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a91:	25 fc 0f 00 00       	and    $0xffc,%eax
80107a96:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a9d:	85 c9                	test   %ecx,%ecx
80107a9f:	74 d4                	je     80107a75 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80107aa1:	89 fb                	mov    %edi,%ebx
80107aa3:	b8 00 10 00 00       	mov    $0x1000,%eax
80107aa8:	29 f3                	sub    %esi,%ebx
80107aaa:	39 c3                	cmp    %eax,%ebx
80107aac:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107aaf:	53                   	push   %ebx
80107ab0:	8b 45 14             	mov    0x14(%ebp),%eax
80107ab3:	01 f0                	add    %esi,%eax
80107ab5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80107ab6:	8b 01                	mov    (%ecx),%eax
80107ab8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107abd:	05 00 00 00 80       	add    $0x80000000,%eax
80107ac2:	50                   	push   %eax
80107ac3:	ff 75 10             	push   0x10(%ebp)
80107ac6:	e8 15 a0 ff ff       	call   80101ae0 <readi>
80107acb:	83 c4 10             	add    $0x10,%esp
80107ace:	39 d8                	cmp    %ebx,%eax
80107ad0:	75 1e                	jne    80107af0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80107ad2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107ad8:	39 fe                	cmp    %edi,%esi
80107ada:	72 84                	jb     80107a60 <loaduvm+0x20>
}
80107adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107adf:	31 c0                	xor    %eax,%eax
}
80107ae1:	5b                   	pop    %ebx
80107ae2:	5e                   	pop    %esi
80107ae3:	5f                   	pop    %edi
80107ae4:	5d                   	pop    %ebp
80107ae5:	c3                   	ret
80107ae6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107aed:	00 
80107aee:	66 90                	xchg   %ax,%ax
80107af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107af8:	5b                   	pop    %ebx
80107af9:	5e                   	pop    %esi
80107afa:	5f                   	pop    %edi
80107afb:	5d                   	pop    %ebp
80107afc:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80107afd:	83 ec 0c             	sub    $0xc,%esp
80107b00:	68 c8 88 10 80       	push   $0x801088c8
80107b05:	e8 76 88 ff ff       	call   80100380 <panic>
80107b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b10 <allocuvm>:
{
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	57                   	push   %edi
80107b14:	56                   	push   %esi
80107b15:	53                   	push   %ebx
80107b16:	83 ec 1c             	sub    $0x1c,%esp
80107b19:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80107b1c:	85 f6                	test   %esi,%esi
80107b1e:	0f 88 98 00 00 00    	js     80107bbc <allocuvm+0xac>
80107b24:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107b26:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107b29:	0f 82 a1 00 00 00    	jb     80107bd0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b32:	05 ff 0f 00 00       	add    $0xfff,%eax
80107b37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b3c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80107b3e:	39 f0                	cmp    %esi,%eax
80107b40:	0f 83 8d 00 00 00    	jae    80107bd3 <allocuvm+0xc3>
80107b46:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107b49:	eb 44                	jmp    80107b8f <allocuvm+0x7f>
80107b4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107b50:	83 ec 04             	sub    $0x4,%esp
80107b53:	68 00 10 00 00       	push   $0x1000
80107b58:	6a 00                	push   $0x0
80107b5a:	50                   	push   %eax
80107b5b:	e8 20 d7 ff ff       	call   80105280 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107b60:	58                   	pop    %eax
80107b61:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b67:	5a                   	pop    %edx
80107b68:	6a 06                	push   $0x6
80107b6a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b6f:	89 fa                	mov    %edi,%edx
80107b71:	50                   	push   %eax
80107b72:	8b 45 08             	mov    0x8(%ebp),%eax
80107b75:	e8 a6 fb ff ff       	call   80107720 <mappages>
80107b7a:	83 c4 10             	add    $0x10,%esp
80107b7d:	85 c0                	test   %eax,%eax
80107b7f:	78 5f                	js     80107be0 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80107b81:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107b87:	39 f7                	cmp    %esi,%edi
80107b89:	0f 83 89 00 00 00    	jae    80107c18 <allocuvm+0x108>
    mem = kalloc();
80107b8f:	e8 fc aa ff ff       	call   80102690 <kalloc>
80107b94:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107b96:	85 c0                	test   %eax,%eax
80107b98:	75 b6                	jne    80107b50 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107b9a:	83 ec 0c             	sub    $0xc,%esp
80107b9d:	68 46 85 10 80       	push   $0x80108546
80107ba2:	e8 09 8b ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107ba7:	83 c4 10             	add    $0x10,%esp
80107baa:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107bad:	74 0d                	je     80107bbc <allocuvm+0xac>
80107baf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80107bb5:	89 f2                	mov    %esi,%edx
80107bb7:	e8 a4 fa ff ff       	call   80107660 <deallocuvm.part.0>
    return 0;
80107bbc:	31 d2                	xor    %edx,%edx
}
80107bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bc1:	89 d0                	mov    %edx,%eax
80107bc3:	5b                   	pop    %ebx
80107bc4:	5e                   	pop    %esi
80107bc5:	5f                   	pop    %edi
80107bc6:	5d                   	pop    %ebp
80107bc7:	c3                   	ret
80107bc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107bcf:	00 
    return oldsz;
80107bd0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80107bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bd6:	89 d0                	mov    %edx,%eax
80107bd8:	5b                   	pop    %ebx
80107bd9:	5e                   	pop    %esi
80107bda:	5f                   	pop    %edi
80107bdb:	5d                   	pop    %ebp
80107bdc:	c3                   	ret
80107bdd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107be0:	83 ec 0c             	sub    $0xc,%esp
80107be3:	68 5e 85 10 80       	push   $0x8010855e
80107be8:	e8 c3 8a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107bed:	83 c4 10             	add    $0x10,%esp
80107bf0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107bf3:	74 0d                	je     80107c02 <allocuvm+0xf2>
80107bf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80107bfb:	89 f2                	mov    %esi,%edx
80107bfd:	e8 5e fa ff ff       	call   80107660 <deallocuvm.part.0>
      kfree(mem);
80107c02:	83 ec 0c             	sub    $0xc,%esp
80107c05:	53                   	push   %ebx
80107c06:	e8 c5 a8 ff ff       	call   801024d0 <kfree>
      return 0;
80107c0b:	83 c4 10             	add    $0x10,%esp
    return 0;
80107c0e:	31 d2                	xor    %edx,%edx
80107c10:	eb ac                	jmp    80107bbe <allocuvm+0xae>
80107c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c18:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80107c1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c1e:	5b                   	pop    %ebx
80107c1f:	5e                   	pop    %esi
80107c20:	89 d0                	mov    %edx,%eax
80107c22:	5f                   	pop    %edi
80107c23:	5d                   	pop    %ebp
80107c24:	c3                   	ret
80107c25:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c2c:	00 
80107c2d:	8d 76 00             	lea    0x0(%esi),%esi

80107c30 <deallocuvm>:
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c36:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107c39:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107c3c:	39 d1                	cmp    %edx,%ecx
80107c3e:	73 10                	jae    80107c50 <deallocuvm+0x20>
}
80107c40:	5d                   	pop    %ebp
80107c41:	e9 1a fa ff ff       	jmp    80107660 <deallocuvm.part.0>
80107c46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c4d:	00 
80107c4e:	66 90                	xchg   %ax,%ax
80107c50:	89 d0                	mov    %edx,%eax
80107c52:	5d                   	pop    %ebp
80107c53:	c3                   	ret
80107c54:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c5b:	00 
80107c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107c60 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	57                   	push   %edi
80107c64:	56                   	push   %esi
80107c65:	53                   	push   %ebx
80107c66:	83 ec 0c             	sub    $0xc,%esp
80107c69:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107c6c:	85 f6                	test   %esi,%esi
80107c6e:	74 59                	je     80107cc9 <freevm+0x69>
  if(newsz >= oldsz)
80107c70:	31 c9                	xor    %ecx,%ecx
80107c72:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107c77:	89 f0                	mov    %esi,%eax
80107c79:	89 f3                	mov    %esi,%ebx
80107c7b:	e8 e0 f9 ff ff       	call   80107660 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107c80:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107c86:	eb 0f                	jmp    80107c97 <freevm+0x37>
80107c88:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107c8f:	00 
80107c90:	83 c3 04             	add    $0x4,%ebx
80107c93:	39 fb                	cmp    %edi,%ebx
80107c95:	74 23                	je     80107cba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107c97:	8b 03                	mov    (%ebx),%eax
80107c99:	a8 01                	test   $0x1,%al
80107c9b:	74 f3                	je     80107c90 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107ca2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107ca5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ca8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107cad:	50                   	push   %eax
80107cae:	e8 1d a8 ff ff       	call   801024d0 <kfree>
80107cb3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107cb6:	39 fb                	cmp    %edi,%ebx
80107cb8:	75 dd                	jne    80107c97 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107cba:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cc0:	5b                   	pop    %ebx
80107cc1:	5e                   	pop    %esi
80107cc2:	5f                   	pop    %edi
80107cc3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107cc4:	e9 07 a8 ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
80107cc9:	83 ec 0c             	sub    $0xc,%esp
80107ccc:	68 7a 85 10 80       	push   $0x8010857a
80107cd1:	e8 aa 86 ff ff       	call   80100380 <panic>
80107cd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107cdd:	00 
80107cde:	66 90                	xchg   %ax,%ax

80107ce0 <setupkvm>:
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	56                   	push   %esi
80107ce4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107ce5:	e8 a6 a9 ff ff       	call   80102690 <kalloc>
80107cea:	85 c0                	test   %eax,%eax
80107cec:	74 5e                	je     80107d4c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80107cee:	83 ec 04             	sub    $0x4,%esp
80107cf1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cf3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107cf8:	68 00 10 00 00       	push   $0x1000
80107cfd:	6a 00                	push   $0x0
80107cff:	50                   	push   %eax
80107d00:	e8 7b d5 ff ff       	call   80105280 <memset>
80107d05:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107d08:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d0b:	83 ec 08             	sub    $0x8,%esp
80107d0e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d11:	8b 13                	mov    (%ebx),%edx
80107d13:	ff 73 0c             	push   0xc(%ebx)
80107d16:	50                   	push   %eax
80107d17:	29 c1                	sub    %eax,%ecx
80107d19:	89 f0                	mov    %esi,%eax
80107d1b:	e8 00 fa ff ff       	call   80107720 <mappages>
80107d20:	83 c4 10             	add    $0x10,%esp
80107d23:	85 c0                	test   %eax,%eax
80107d25:	78 19                	js     80107d40 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d27:	83 c3 10             	add    $0x10,%ebx
80107d2a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107d30:	75 d6                	jne    80107d08 <setupkvm+0x28>
}
80107d32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d35:	89 f0                	mov    %esi,%eax
80107d37:	5b                   	pop    %ebx
80107d38:	5e                   	pop    %esi
80107d39:	5d                   	pop    %ebp
80107d3a:	c3                   	ret
80107d3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107d40:	83 ec 0c             	sub    $0xc,%esp
80107d43:	56                   	push   %esi
80107d44:	e8 17 ff ff ff       	call   80107c60 <freevm>
      return 0;
80107d49:	83 c4 10             	add    $0x10,%esp
}
80107d4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80107d4f:	31 f6                	xor    %esi,%esi
}
80107d51:	89 f0                	mov    %esi,%eax
80107d53:	5b                   	pop    %ebx
80107d54:	5e                   	pop    %esi
80107d55:	5d                   	pop    %ebp
80107d56:	c3                   	ret
80107d57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107d5e:	00 
80107d5f:	90                   	nop

80107d60 <kvmalloc>:
{
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d66:	e8 75 ff ff ff       	call   80107ce0 <setupkvm>
80107d6b:	a3 e4 5e 11 80       	mov    %eax,0x80115ee4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107d70:	05 00 00 00 80       	add    $0x80000000,%eax
80107d75:	0f 22 d8             	mov    %eax,%cr3
}
80107d78:	c9                   	leave
80107d79:	c3                   	ret
80107d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d80 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d80:	55                   	push   %ebp
80107d81:	89 e5                	mov    %esp,%ebp
80107d83:	83 ec 08             	sub    $0x8,%esp
80107d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107d89:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107d8c:	89 c1                	mov    %eax,%ecx
80107d8e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107d91:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107d94:	f6 c2 01             	test   $0x1,%dl
80107d97:	75 17                	jne    80107db0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107d99:	83 ec 0c             	sub    $0xc,%esp
80107d9c:	68 8b 85 10 80       	push   $0x8010858b
80107da1:	e8 da 85 ff ff       	call   80100380 <panic>
80107da6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107dad:	00 
80107dae:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107db0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107db3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107db9:	25 fc 0f 00 00       	and    $0xffc,%eax
80107dbe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107dc5:	85 c0                	test   %eax,%eax
80107dc7:	74 d0                	je     80107d99 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107dc9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107dcc:	c9                   	leave
80107dcd:	c3                   	ret
80107dce:	66 90                	xchg   %ax,%ax

80107dd0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107dd0:	55                   	push   %ebp
80107dd1:	89 e5                	mov    %esp,%ebp
80107dd3:	57                   	push   %edi
80107dd4:	56                   	push   %esi
80107dd5:	53                   	push   %ebx
80107dd6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107dd9:	e8 02 ff ff ff       	call   80107ce0 <setupkvm>
80107dde:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107de1:	85 c0                	test   %eax,%eax
80107de3:	0f 84 e9 00 00 00    	je     80107ed2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107dec:	85 c9                	test   %ecx,%ecx
80107dee:	0f 84 b2 00 00 00    	je     80107ea6 <copyuvm+0xd6>
80107df4:	31 f6                	xor    %esi,%esi
80107df6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107dfd:	00 
80107dfe:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107e00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107e03:	89 f0                	mov    %esi,%eax
80107e05:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107e08:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107e0b:	a8 01                	test   $0x1,%al
80107e0d:	75 11                	jne    80107e20 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107e0f:	83 ec 0c             	sub    $0xc,%esp
80107e12:	68 95 85 10 80       	push   $0x80108595
80107e17:	e8 64 85 ff ff       	call   80100380 <panic>
80107e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107e20:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107e22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107e27:	c1 ea 0a             	shr    $0xa,%edx
80107e2a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107e30:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e37:	85 c0                	test   %eax,%eax
80107e39:	74 d4                	je     80107e0f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107e3b:	8b 00                	mov    (%eax),%eax
80107e3d:	a8 01                	test   $0x1,%al
80107e3f:	0f 84 9f 00 00 00    	je     80107ee4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107e45:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107e47:	25 ff 0f 00 00       	and    $0xfff,%eax
80107e4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107e4f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107e55:	e8 36 a8 ff ff       	call   80102690 <kalloc>
80107e5a:	89 c3                	mov    %eax,%ebx
80107e5c:	85 c0                	test   %eax,%eax
80107e5e:	74 64                	je     80107ec4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107e60:	83 ec 04             	sub    $0x4,%esp
80107e63:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107e69:	68 00 10 00 00       	push   $0x1000
80107e6e:	57                   	push   %edi
80107e6f:	50                   	push   %eax
80107e70:	e8 9b d4 ff ff       	call   80105310 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107e75:	58                   	pop    %eax
80107e76:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107e7c:	5a                   	pop    %edx
80107e7d:	ff 75 e4             	push   -0x1c(%ebp)
80107e80:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e85:	89 f2                	mov    %esi,%edx
80107e87:	50                   	push   %eax
80107e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e8b:	e8 90 f8 ff ff       	call   80107720 <mappages>
80107e90:	83 c4 10             	add    $0x10,%esp
80107e93:	85 c0                	test   %eax,%eax
80107e95:	78 21                	js     80107eb8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107e97:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107e9d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107ea0:	0f 82 5a ff ff ff    	jb     80107e00 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107ea6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eac:	5b                   	pop    %ebx
80107ead:	5e                   	pop    %esi
80107eae:	5f                   	pop    %edi
80107eaf:	5d                   	pop    %ebp
80107eb0:	c3                   	ret
80107eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107eb8:	83 ec 0c             	sub    $0xc,%esp
80107ebb:	53                   	push   %ebx
80107ebc:	e8 0f a6 ff ff       	call   801024d0 <kfree>
      goto bad;
80107ec1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107ec4:	83 ec 0c             	sub    $0xc,%esp
80107ec7:	ff 75 e0             	push   -0x20(%ebp)
80107eca:	e8 91 fd ff ff       	call   80107c60 <freevm>
  return 0;
80107ecf:	83 c4 10             	add    $0x10,%esp
    return 0;
80107ed2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107edf:	5b                   	pop    %ebx
80107ee0:	5e                   	pop    %esi
80107ee1:	5f                   	pop    %edi
80107ee2:	5d                   	pop    %ebp
80107ee3:	c3                   	ret
      panic("copyuvm: page not present");
80107ee4:	83 ec 0c             	sub    $0xc,%esp
80107ee7:	68 af 85 10 80       	push   $0x801085af
80107eec:	e8 8f 84 ff ff       	call   80100380 <panic>
80107ef1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107ef8:	00 
80107ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107f00 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f00:	55                   	push   %ebp
80107f01:	89 e5                	mov    %esp,%ebp
80107f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107f06:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107f09:	89 c1                	mov    %eax,%ecx
80107f0b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107f0e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107f11:	f6 c2 01             	test   $0x1,%dl
80107f14:	0f 84 f8 00 00 00    	je     80108012 <uva2ka.cold>
  return &pgtab[PTX(va)];
80107f1a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107f1d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107f23:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107f24:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107f29:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f30:	89 d0                	mov    %edx,%eax
80107f32:	f7 d2                	not    %edx
80107f34:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f39:	05 00 00 00 80       	add    $0x80000000,%eax
80107f3e:	83 e2 05             	and    $0x5,%edx
80107f41:	ba 00 00 00 00       	mov    $0x0,%edx
80107f46:	0f 45 c2             	cmovne %edx,%eax
}
80107f49:	c3                   	ret
80107f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107f50 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107f50:	55                   	push   %ebp
80107f51:	89 e5                	mov    %esp,%ebp
80107f53:	57                   	push   %edi
80107f54:	56                   	push   %esi
80107f55:	53                   	push   %ebx
80107f56:	83 ec 0c             	sub    $0xc,%esp
80107f59:	8b 75 14             	mov    0x14(%ebp),%esi
80107f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f5f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107f62:	85 f6                	test   %esi,%esi
80107f64:	75 51                	jne    80107fb7 <copyout+0x67>
80107f66:	e9 9d 00 00 00       	jmp    80108008 <copyout+0xb8>
80107f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107f70:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107f76:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107f7c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107f82:	74 74                	je     80107ff8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107f84:	89 fb                	mov    %edi,%ebx
80107f86:	29 c3                	sub    %eax,%ebx
80107f88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107f8e:	39 f3                	cmp    %esi,%ebx
80107f90:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107f93:	29 f8                	sub    %edi,%eax
80107f95:	83 ec 04             	sub    $0x4,%esp
80107f98:	01 c1                	add    %eax,%ecx
80107f9a:	53                   	push   %ebx
80107f9b:	52                   	push   %edx
80107f9c:	89 55 10             	mov    %edx,0x10(%ebp)
80107f9f:	51                   	push   %ecx
80107fa0:	e8 6b d3 ff ff       	call   80105310 <memmove>
    len -= n;
    buf += n;
80107fa5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107fa8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107fae:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107fb1:	01 da                	add    %ebx,%edx
  while(len > 0){
80107fb3:	29 de                	sub    %ebx,%esi
80107fb5:	74 51                	je     80108008 <copyout+0xb8>
  if(*pde & PTE_P){
80107fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107fba:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107fbc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107fbe:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107fc1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107fc7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107fca:	f6 c1 01             	test   $0x1,%cl
80107fcd:	0f 84 46 00 00 00    	je     80108019 <copyout.cold>
  return &pgtab[PTX(va)];
80107fd3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107fd5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107fdb:	c1 eb 0c             	shr    $0xc,%ebx
80107fde:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107fe4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107feb:	89 d9                	mov    %ebx,%ecx
80107fed:	f7 d1                	not    %ecx
80107fef:	83 e1 05             	and    $0x5,%ecx
80107ff2:	0f 84 78 ff ff ff    	je     80107f70 <copyout+0x20>
  }
  return 0;
}
80107ff8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ffb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108000:	5b                   	pop    %ebx
80108001:	5e                   	pop    %esi
80108002:	5f                   	pop    %edi
80108003:	5d                   	pop    %ebp
80108004:	c3                   	ret
80108005:	8d 76 00             	lea    0x0(%esi),%esi
80108008:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010800b:	31 c0                	xor    %eax,%eax
}
8010800d:	5b                   	pop    %ebx
8010800e:	5e                   	pop    %esi
8010800f:	5f                   	pop    %edi
80108010:	5d                   	pop    %ebp
80108011:	c3                   	ret

80108012 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80108012:	a1 00 00 00 00       	mov    0x0,%eax
80108017:	0f 0b                	ud2

80108019 <copyout.cold>:
80108019:	a1 00 00 00 00       	mov    0x0,%eax
8010801e:	0f 0b                	ud2
