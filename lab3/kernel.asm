
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 2e 10 80       	mov    $0x80102e10,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 20 6e 10 	movl   $0x80106e20,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 10 40 00 00       	call   80104070 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 27 6e 10 	movl   $0x80106e27,0x4(%esp)
8010009b:	80 
8010009c:	e8 bf 3e 00 00       	call   80103f60 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 75 40 00 00       	call   80104160 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
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
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 ea 40 00 00       	call   80104250 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 2f 3e 00 00       	call   80103fa0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 c2 1f 00 00       	call   80102140 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 2e 6e 10 80 	movl   $0x80106e2e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 8b 3e 00 00       	call   80104040 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 77 1f 00 00       	jmp    80102140 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 3f 6e 10 80 	movl   $0x80106e3f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 4a 3e 00 00       	call   80104040 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 fe 3d 00 00       	call   80104000 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 52 3f 00 00       	call   80104160 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 fb 3f 00 00       	jmp    80104250 <release>
    panic("brelse");
80100255:	c7 04 24 46 6e 10 80 	movl   $0x80106e46,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 29 15 00 00       	call   801017b0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 cd 3e 00 00       	call   80104160 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 13 34 00 00       	call   801036c0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 58 39 00 00       	call   80103c20 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 3a 3f 00 00       	call   80104250 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 b2 13 00 00       	call   801016d0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 1c 3f 00 00       	call   80104250 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 94 13 00 00       	call   801016d0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 05 24 00 00       	call   80102780 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 4d 6e 10 80 	movl   $0x80106e4d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 07 78 10 80 	movl   $0x80107807,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 dc 3c 00 00       	call   80104090 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 61 6e 10 80 	movl   $0x80106e61,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 f2 53 00 00       	call   80105800 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 42 53 00 00       	call   80105800 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 36 53 00 00       	call   80105800 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 2a 53 00 00       	call   80105800 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 3f 3e 00 00       	call   80104340 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 82 3d 00 00       	call   801042a0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 65 6e 10 80 	movl   $0x80106e65,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 90 6e 10 80 	movzbl -0x7fef9170(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 a9 11 00 00       	call   801017b0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 4d 3b 00 00       	call   80104160 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 15 3c 00 00       	call   80104250 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 8a 10 00 00       	call   801016d0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 58 3b 00 00       	call   80104250 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 78 6e 10 80       	mov    $0x80106e78,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 c4 39 00 00       	call   80104160 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 7f 6e 10 80 	movl   $0x80106e7f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 96 39 00 00       	call   80104160 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 24 3a 00 00       	call   80104250 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 f9 34 00 00       	call   80103db0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 64 35 00 00       	jmp    80103e90 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 88 6e 10 	movl   $0x80106e88,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 06 37 00 00       	call   80104070 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 34 19 00 00       	call   801022d0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 0f 2d 00 00       	call   801036c0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 74 21 00 00       	call   80102b30 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 59 15 00 00       	call   80101f20 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 bc 01 00 00    	je     80100b8d <exec+0x1ed>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 f7 0c 00 00       	call   801016d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 85 0f 00 00       	call   80101980 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 28 0f 00 00       	call   80101930 <iunlockput>
    end_op();
80100a08:	e8 93 21 00 00       	call   80102ba0 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 df 5f 00 00       	call   80106a10 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 ed 0e 00 00       	call   80101980 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 99 5d 00 00       	call   80106870 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 98 5c 00 00       	call   801067b0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 62 5e 00 00       	call   80106990 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 f5 0d 00 00       	call   80101930 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 5b 20 00 00       	call   80102ba0 <end_op>
  int t = PGROUNDUP(sz);		// Lab 3
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((t = allocuvm(pgdir, t, t + PGSIZE)) == 0)
80100b55:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 ff 5c 00 00       	call   80106870 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	75 33                	jne    80100ba8 <exec+0x208>
    freevm(pgdir);
80100b75:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b7b:	89 04 24             	mov    %eax,(%esp)
80100b7e:	e8 0d 5e 00 00       	call   80106990 <freevm>
  return -1;
80100b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b88:	e9 85 fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b8d:	e8 0e 20 00 00       	call   80102ba0 <end_op>
    cprintf("exec: fail\n");
80100b92:	c7 04 24 a1 6e 10 80 	movl   $0x80106ea1,(%esp)
80100b99:	e8 b2 fa ff ff       	call   80100650 <cprintf>
    return -1;
80100b9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba3:	e9 6a fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char*)(t - PGSIZE));
80100ba8:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100bae:	2d 00 10 00 00       	sub    $0x1000,%eax
80100bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bb7:	89 3c 24             	mov    %edi,(%esp)
80100bba:	e8 01 5f 00 00       	call   80106ac0 <clearpteu>
  if ((sp = allocuvm(pgdir, STACKBASE - PGSIZE, STACKBASE)) == 0)
80100bbf:	c7 44 24 08 fc ff ff 	movl   $0x7ffffffc,0x8(%esp)
80100bc6:	7f 
80100bc7:	c7 44 24 04 fc ef ff 	movl   $0x7fffeffc,0x4(%esp)
80100bce:	7f 
80100bcf:	89 3c 24             	mov    %edi,(%esp)
80100bd2:	e8 99 5c 00 00       	call   80106870 <allocuvm>
80100bd7:	85 c0                	test   %eax,%eax
80100bd9:	89 c3                	mov    %eax,%ebx
80100bdb:	74 98                	je     80100b75 <exec+0x1d5>
  for(argc = 0; argv[argc]; argc++) {
80100bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100be0:	8b 00                	mov    (%eax),%eax
80100be2:	85 c0                	test   %eax,%eax
80100be4:	0f 84 62 01 00 00    	je     80100d4c <exec+0x3ac>
80100bea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bed:	31 f6                	xor    %esi,%esi
80100bef:	8d 51 04             	lea    0x4(%ecx),%edx
80100bf2:	89 cf                	mov    %ecx,%edi
80100bf4:	89 d1                	mov    %edx,%ecx
80100bf6:	89 f2                	mov    %esi,%edx
80100bf8:	89 fe                	mov    %edi,%esi
80100bfa:	89 cf                	mov    %ecx,%edi
80100bfc:	eb 0c                	jmp    80100c0a <exec+0x26a>
80100bfe:	83 c7 04             	add    $0x4,%edi
    if(argc >= MAXARG)
80100c01:	83 fa 20             	cmp    $0x20,%edx
80100c04:	0f 84 6b ff ff ff    	je     80100b75 <exec+0x1d5>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0a:	89 04 24             	mov    %eax,(%esp)
80100c0d:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100c13:	e8 a8 38 00 00       	call   801044c0 <strlen>
80100c18:	f7 d0                	not    %eax
80100c1a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c1c:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c1e:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c21:	89 04 24             	mov    %eax,(%esp)
80100c24:	e8 97 38 00 00       	call   801044c0 <strlen>
80100c29:	83 c0 01             	add    $0x1,%eax
80100c2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c30:	8b 06                	mov    (%esi),%eax
80100c32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c36:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c3a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c40:	89 04 24             	mov    %eax,(%esp)
80100c43:	e8 b8 60 00 00       	call   80106d00 <copyout>
80100c48:	85 c0                	test   %eax,%eax
80100c4a:	0f 88 25 ff ff ff    	js     80100b75 <exec+0x1d5>
    ustack[3+argc] = sp;
80100c50:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
80100c56:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100c5c:	89 fe                	mov    %edi,%esi
80100c5e:	8b 07                	mov    (%edi),%eax
    ustack[3+argc] = sp;
80100c60:	89 9c 95 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100c67:	83 c2 01             	add    $0x1,%edx
80100c6a:	85 c0                	test   %eax,%eax
80100c6c:	75 90                	jne    80100bfe <exec+0x25e>
80100c6e:	89 d6                	mov    %edx,%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c70:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c77:	89 da                	mov    %ebx,%edx
80100c79:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c7b:	83 c0 0c             	add    $0xc,%eax
80100c7e:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c80:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c84:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c8a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[3+argc] = 0;
80100c92:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c99:	00 00 00 00 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9d:	89 04 24             	mov    %eax,(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100ca0:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca7:	ff ff ff 
  ustack[1] = argc;
80100caa:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb0:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb6:	e8 45 60 00 00       	call   80106d00 <copyout>
80100cbb:	85 c0                	test   %eax,%eax
80100cbd:	0f 88 b2 fe ff ff    	js     80100b75 <exec+0x1d5>
  for(last=s=path; *s; s++)
80100cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80100cc6:	0f b6 10             	movzbl (%eax),%edx
80100cc9:	84 d2                	test   %dl,%dl
80100ccb:	74 19                	je     80100ce6 <exec+0x346>
80100ccd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd0:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cd3:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cd6:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cd9:	0f 44 c8             	cmove  %eax,%ecx
80100cdc:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100cdf:	84 d2                	test   %dl,%dl
80100ce1:	75 f0                	jne    80100cd3 <exec+0x333>
80100ce3:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ce6:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cec:	8b 45 08             	mov    0x8(%ebp),%eax
80100cef:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cf6:	00 
80100cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cfb:	89 f8                	mov    %edi,%eax
80100cfd:	83 c0 6c             	add    $0x6c,%eax
80100d00:	89 04 24             	mov    %eax,(%esp)
80100d03:	e8 78 37 00 00       	call   80104480 <safestrcpy>
  curproc->pgdir = pgdir;
80100d08:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d0e:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100d11:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d14:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d17:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100d1d:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d1f:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d25:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d28:	8b 47 18             	mov    0x18(%edi),%eax
80100d2b:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->npages = 1;  // Lab3
80100d2e:	c7 47 7c 01 00 00 00 	movl   $0x1,0x7c(%edi)
  switchuvm(curproc);
80100d35:	89 3c 24             	mov    %edi,(%esp)
80100d38:	e8 d3 58 00 00       	call   80106610 <switchuvm>
  freevm(oldpgdir);
80100d3d:	89 34 24             	mov    %esi,(%esp)
80100d40:	e8 4b 5c 00 00       	call   80106990 <freevm>
  return 0;
80100d45:	31 c0                	xor    %eax,%eax
80100d47:	e9 c6 fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d4c:	31 f6                	xor    %esi,%esi
80100d4e:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d54:	e9 17 ff ff ff       	jmp    80100c70 <exec+0x2d0>
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	c7 44 24 04 ad 6e 10 	movl   $0x80106ead,0x4(%esp)
80100d6d:	80 
80100d6e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d75:	e8 f6 32 00 00       	call   80104070 <initlock>
}
80100d7a:	c9                   	leave  
80100d7b:	c3                   	ret    
80100d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d8c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d93:	e8 c8 33 00 00       	call   80104160 <acquire>
80100d98:	eb 11                	jmp    80100dab <filealloc+0x2b>
80100d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	74 25                	je     80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100db9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dc0:	e8 8b 34 00 00       	call   80104250 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc5:	83 c4 14             	add    $0x14,%esp
      return f;
80100dc8:	89 d8                	mov    %ebx,%eax
}
80100dca:	5b                   	pop    %ebx
80100dcb:	5d                   	pop    %ebp
80100dcc:	c3                   	ret    
80100dcd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100dd0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dd7:	e8 74 34 00 00       	call   80104250 <release>
}
80100ddc:	83 c4 14             	add    $0x14,%esp
  return 0;
80100ddf:	31 c0                	xor    %eax,%eax
}
80100de1:	5b                   	pop    %ebx
80100de2:	5d                   	pop    %ebp
80100de3:	c3                   	ret    
80100de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 14             	sub    $0x14,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e01:	e8 5a 33 00 00       	call   80104160 <acquire>
  if(f->ref < 1)
80100e06:	8b 43 04             	mov    0x4(%ebx),%eax
80100e09:	85 c0                	test   %eax,%eax
80100e0b:	7e 1a                	jle    80100e27 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e0d:	83 c0 01             	add    $0x1,%eax
80100e10:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e13:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e1a:	e8 31 34 00 00       	call   80104250 <release>
  return f;
}
80100e1f:	83 c4 14             	add    $0x14,%esp
80100e22:	89 d8                	mov    %ebx,%eax
80100e24:	5b                   	pop    %ebx
80100e25:	5d                   	pop    %ebp
80100e26:	c3                   	ret    
    panic("filedup");
80100e27:	c7 04 24 b4 6e 10 80 	movl   $0x80106eb4,(%esp)
80100e2e:	e8 2d f5 ff ff       	call   80100360 <panic>
80100e33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 1c             	sub    $0x1c,%esp
80100e49:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e53:	e8 08 33 00 00       	call   80104160 <acquire>
  if(f->ref < 1)
80100e58:	8b 57 04             	mov    0x4(%edi),%edx
80100e5b:	85 d2                	test   %edx,%edx
80100e5d:	0f 8e 89 00 00 00    	jle    80100eec <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e63:	83 ea 01             	sub    $0x1,%edx
80100e66:	85 d2                	test   %edx,%edx
80100e68:	89 57 04             	mov    %edx,0x4(%edi)
80100e6b:	74 13                	je     80100e80 <fileclose+0x40>
    release(&ftable.lock);
80100e6d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e74:	83 c4 1c             	add    $0x1c,%esp
80100e77:	5b                   	pop    %ebx
80100e78:	5e                   	pop    %esi
80100e79:	5f                   	pop    %edi
80100e7a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7b:	e9 d0 33 00 00       	jmp    80104250 <release>
  ff = *f;
80100e80:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e84:	8b 37                	mov    (%edi),%esi
80100e86:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e89:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e8f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e92:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e95:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e9f:	e8 ac 33 00 00       	call   80104250 <release>
  if(ff.type == FD_PIPE)
80100ea4:	83 fe 01             	cmp    $0x1,%esi
80100ea7:	74 0f                	je     80100eb8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100ea9:	83 fe 02             	cmp    $0x2,%esi
80100eac:	74 22                	je     80100ed0 <fileclose+0x90>
}
80100eae:	83 c4 1c             	add    $0x1c,%esp
80100eb1:	5b                   	pop    %ebx
80100eb2:	5e                   	pop    %esi
80100eb3:	5f                   	pop    %edi
80100eb4:	5d                   	pop    %ebp
80100eb5:	c3                   	ret    
80100eb6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100ebc:	89 1c 24             	mov    %ebx,(%esp)
80100ebf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ec3:	e8 b8 23 00 00       	call   80103280 <pipeclose>
80100ec8:	eb e4                	jmp    80100eae <fileclose+0x6e>
80100eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ed0:	e8 5b 1c 00 00       	call   80102b30 <begin_op>
    iput(ff.ip);
80100ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ed8:	89 04 24             	mov    %eax,(%esp)
80100edb:	e8 10 09 00 00       	call   801017f0 <iput>
}
80100ee0:	83 c4 1c             	add    $0x1c,%esp
80100ee3:	5b                   	pop    %ebx
80100ee4:	5e                   	pop    %esi
80100ee5:	5f                   	pop    %edi
80100ee6:	5d                   	pop    %ebp
    end_op();
80100ee7:	e9 b4 1c 00 00       	jmp    80102ba0 <end_op>
    panic("fileclose");
80100eec:	c7 04 24 bc 6e 10 80 	movl   $0x80106ebc,(%esp)
80100ef3:	e8 68 f4 ff ff       	call   80100360 <panic>
80100ef8:	90                   	nop
80100ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 14             	sub    $0x14,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f12:	89 04 24             	mov    %eax,(%esp)
80100f15:	e8 b6 07 00 00       	call   801016d0 <ilock>
    stati(f->ip, st);
80100f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f21:	8b 43 10             	mov    0x10(%ebx),%eax
80100f24:	89 04 24             	mov    %eax,(%esp)
80100f27:	e8 24 0a 00 00       	call   80101950 <stati>
    iunlock(f->ip);
80100f2c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f2f:	89 04 24             	mov    %eax,(%esp)
80100f32:	e8 79 08 00 00       	call   801017b0 <iunlock>
    return 0;
  }
  return -1;
}
80100f37:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f3a:	31 c0                	xor    %eax,%eax
}
80100f3c:	5b                   	pop    %ebx
80100f3d:	5d                   	pop    %ebp
80100f3e:	c3                   	ret    
80100f3f:	90                   	nop
80100f40:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f48:	5b                   	pop    %ebx
80100f49:	5d                   	pop    %ebp
80100f4a:	c3                   	ret    
80100f4b:	90                   	nop
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 1c             	sub    $0x1c,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 68                	je     80100fd0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 49                	je     80100fb8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 63                	jne    80100fd7 <fileread+0x87>
    ilock(f->ip);
80100f74:	8b 43 10             	mov    0x10(%ebx),%eax
80100f77:	89 04 24             	mov    %eax,(%esp)
80100f7a:	e8 51 07 00 00       	call   801016d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f83:	8b 43 14             	mov    0x14(%ebx),%eax
80100f86:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f8a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f8e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f91:	89 04 24             	mov    %eax,(%esp)
80100f94:	e8 e7 09 00 00       	call   80101980 <readi>
80100f99:	85 c0                	test   %eax,%eax
80100f9b:	89 c6                	mov    %eax,%esi
80100f9d:	7e 03                	jle    80100fa2 <fileread+0x52>
      f->off += r;
80100f9f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa5:	89 04 24             	mov    %eax,(%esp)
80100fa8:	e8 03 08 00 00       	call   801017b0 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fad:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100faf:	83 c4 1c             	add    $0x1c,%esp
80100fb2:	5b                   	pop    %ebx
80100fb3:	5e                   	pop    %esi
80100fb4:	5f                   	pop    %edi
80100fb5:	5d                   	pop    %ebp
80100fb6:	c3                   	ret    
80100fb7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fb8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fbb:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fbe:	83 c4 1c             	add    $0x1c,%esp
80100fc1:	5b                   	pop    %ebx
80100fc2:	5e                   	pop    %esi
80100fc3:	5f                   	pop    %edi
80100fc4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fc5:	e9 36 24 00 00       	jmp    80103400 <piperead>
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fd5:	eb d8                	jmp    80100faf <fileread+0x5f>
  panic("fileread");
80100fd7:	c7 04 24 c6 6e 10 80 	movl   $0x80106ec6,(%esp)
80100fde:	e8 7d f3 ff ff       	call   80100360 <panic>
80100fe3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 2c             	sub    $0x2c,%esp
80100ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ffc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101002:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101005:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 ae 00 00 00    	je     801010c0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 07                	mov    (%edi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c2 00 00 00    	je     801010df <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d7 00 00 00    	jne    801010fd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101029:	31 db                	xor    %ebx,%ebx
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 31                	jg     80101060 <filewrite+0x70>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101038:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010103b:	01 47 14             	add    %eax,0x14(%edi)
8010103e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101041:	89 0c 24             	mov    %ecx,(%esp)
80101044:	e8 67 07 00 00       	call   801017b0 <iunlock>
      end_op();
80101049:	e8 52 1b 00 00       	call   80102ba0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101051:	39 f0                	cmp    %esi,%eax
80101053:	0f 85 98 00 00 00    	jne    801010f1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101059:	01 c3                	add    %eax,%ebx
    while(i < n){
8010105b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010105e:	7e 70                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101060:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101063:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101068:	29 de                	sub    %ebx,%esi
8010106a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101070:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101073:	e8 b8 1a 00 00       	call   80102b30 <begin_op>
      ilock(f->ip);
80101078:	8b 47 10             	mov    0x10(%edi),%eax
8010107b:	89 04 24             	mov    %eax,(%esp)
8010107e:	e8 4d 06 00 00       	call   801016d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101083:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101087:	8b 47 14             	mov    0x14(%edi),%eax
8010108a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010108e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101091:	01 d8                	add    %ebx,%eax
80101093:	89 44 24 04          	mov    %eax,0x4(%esp)
80101097:	8b 47 10             	mov    0x10(%edi),%eax
8010109a:	89 04 24             	mov    %eax,(%esp)
8010109d:	e8 de 09 00 00       	call   80101a80 <writei>
801010a2:	85 c0                	test   %eax,%eax
801010a4:	7f 92                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
801010a6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010ac:	89 0c 24             	mov    %ecx,(%esp)
801010af:	e8 fc 06 00 00       	call   801017b0 <iunlock>
      end_op();
801010b4:	e8 e7 1a 00 00       	call   80102ba0 <end_op>
      if(r < 0)
801010b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010bc:	85 c0                	test   %eax,%eax
801010be:	74 91                	je     80101051 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
801010cc:	c3                   	ret    
801010cd:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010d0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010d3:	89 d8                	mov    %ebx,%eax
801010d5:	75 e9                	jne    801010c0 <filewrite+0xd0>
}
801010d7:	83 c4 2c             	add    $0x2c,%esp
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010df:	8b 47 0c             	mov    0xc(%edi),%eax
801010e2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e5:	83 c4 2c             	add    $0x2c,%esp
801010e8:	5b                   	pop    %ebx
801010e9:	5e                   	pop    %esi
801010ea:	5f                   	pop    %edi
801010eb:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ec:	e9 1f 22 00 00       	jmp    80103310 <pipewrite>
        panic("short filewrite");
801010f1:	c7 04 24 cf 6e 10 80 	movl   $0x80106ecf,(%esp)
801010f8:	e8 63 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010fd:	c7 04 24 d5 6e 10 80 	movl   $0x80106ed5,(%esp)
80101104:	e8 57 f2 ff ff       	call   80100360 <panic>
80101109:	66 90                	xchg   %ax,%ax
8010110b:	66 90                	xchg   %ax,%ax
8010110d:	66 90                	xchg   %ax,%ax
8010110f:	90                   	nop

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 2c             	sub    $0x2c,%esp
80101119:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010111c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101121:	85 c0                	test   %eax,%eax
80101123:	0f 84 8c 00 00 00    	je     801011b5 <balloc+0xa5>
80101129:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101130:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101133:	89 f0                	mov    %esi,%eax
80101135:	c1 f8 0c             	sar    $0xc,%eax
80101138:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010113e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101142:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101145:	89 04 24             	mov    %eax,(%esp)
80101148:	e8 83 ef ff ff       	call   801000d0 <bread>
8010114d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101150:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101155:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101158:	31 c0                	xor    %eax,%eax
8010115a:	eb 33                	jmp    8010118f <balloc+0x7f>
8010115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101160:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101163:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101165:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101167:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	bf 01 00 00 00       	mov    $0x1,%edi
80101172:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101174:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101179:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010117b:	0f b6 fb             	movzbl %bl,%edi
8010117e:	85 cf                	test   %ecx,%edi
80101180:	74 46                	je     801011c8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101182:	83 c0 01             	add    $0x1,%eax
80101185:	83 c6 01             	add    $0x1,%esi
80101188:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118d:	74 05                	je     80101194 <balloc+0x84>
8010118f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101192:	72 cc                	jb     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101194:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101197:	89 04 24             	mov    %eax,(%esp)
8010119a:	e8 41 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
801011af:	0f 82 7b ff ff ff    	jb     80101130 <balloc+0x20>
  }
  panic("balloc: out of blocks");
801011b5:	c7 04 24 df 6e 10 80 	movl   $0x80106edf,(%esp)
801011bc:	e8 9f f1 ff ff       	call   80100360 <panic>
801011c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801011c8:	09 d9                	or     %ebx,%ecx
801011ca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011cd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011d1:	89 1c 24             	mov    %ebx,(%esp)
801011d4:	e8 f7 1a 00 00       	call   80102cd0 <log_write>
        brelse(bp);
801011d9:	89 1c 24             	mov    %ebx,(%esp)
801011dc:	e8 ff ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011e4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011e8:	89 04 24             	mov    %eax,(%esp)
801011eb:	e8 e0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011f0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011f7:	00 
801011f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011ff:	00 
  bp = bread(dev, bno);
80101200:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101202:	8d 40 5c             	lea    0x5c(%eax),%eax
80101205:	89 04 24             	mov    %eax,(%esp)
80101208:	e8 93 30 00 00       	call   801042a0 <memset>
  log_write(bp);
8010120d:	89 1c 24             	mov    %ebx,(%esp)
80101210:	e8 bb 1a 00 00       	call   80102cd0 <log_write>
  brelse(bp);
80101215:	89 1c 24             	mov    %ebx,(%esp)
80101218:	e8 c3 ef ff ff       	call   801001e0 <brelse>
}
8010121d:	83 c4 2c             	add    $0x2c,%esp
80101220:	89 f0                	mov    %esi,%eax
80101222:	5b                   	pop    %ebx
80101223:	5e                   	pop    %esi
80101224:	5f                   	pop    %edi
80101225:	5d                   	pop    %ebp
80101226:	c3                   	ret    
80101227:	89 f6                	mov    %esi,%esi
80101229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101230 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	89 c7                	mov    %eax,%edi
80101236:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101237:	31 f6                	xor    %esi,%esi
{
80101239:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010123f:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101242:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101249:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010124c:	e8 0f 2f 00 00       	call   80104160 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101251:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101254:	eb 14                	jmp    8010126a <iget+0x3a>
80101256:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101258:	85 f6                	test   %esi,%esi
8010125a:	74 3c                	je     80101298 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101262:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101268:	74 46                	je     801012b0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010126a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	7e e7                	jle    80101258 <iget+0x28>
80101271:	39 3b                	cmp    %edi,(%ebx)
80101273:	75 e3                	jne    80101258 <iget+0x28>
80101275:	39 53 04             	cmp    %edx,0x4(%ebx)
80101278:	75 de                	jne    80101258 <iget+0x28>
      ip->ref++;
8010127a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010127d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010127f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101286:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101289:	e8 c2 2f 00 00       	call   80104250 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010128e:	83 c4 1c             	add    $0x1c,%esp
80101291:	89 f0                	mov    %esi,%eax
80101293:	5b                   	pop    %ebx
80101294:	5e                   	pop    %esi
80101295:	5f                   	pop    %edi
80101296:	5d                   	pop    %ebp
80101297:	c3                   	ret    
80101298:	85 c9                	test   %ecx,%ecx
8010129a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129d:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012a3:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012a9:	75 bf                	jne    8010126a <iget+0x3a>
801012ab:	90                   	nop
801012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 29                	je     801012dd <iget+0xad>
  ip->dev = dev;
801012b4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012b6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012b9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012c0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012c7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012ce:	e8 7d 2f 00 00       	call   80104250 <release>
}
801012d3:	83 c4 1c             	add    $0x1c,%esp
801012d6:	89 f0                	mov    %esi,%eax
801012d8:	5b                   	pop    %ebx
801012d9:	5e                   	pop    %esi
801012da:	5f                   	pop    %edi
801012db:	5d                   	pop    %ebp
801012dc:	c3                   	ret    
    panic("iget: no inodes");
801012dd:	c7 04 24 f5 6e 10 80 	movl   $0x80106ef5,(%esp)
801012e4:	e8 77 f0 ff ff       	call   80100360 <panic>
801012e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c3                	mov    %eax,%ebx
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 46 5c             	mov    0x5c(%esi),%eax
80101306:	85 c0                	test   %eax,%eax
80101308:	74 66                	je     80101370 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	83 c4 1c             	add    $0x1c,%esp
8010130d:	5b                   	pop    %ebx
8010130e:	5e                   	pop    %esi
8010130f:	5f                   	pop    %edi
80101310:	5d                   	pop    %ebp
80101311:	c3                   	ret    
80101312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101318:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010131b:	83 fe 7f             	cmp    $0x7f,%esi
8010131e:	77 77                	ja     80101397 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101320:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101326:	85 c0                	test   %eax,%eax
80101328:	74 5e                	je     80101388 <bmap+0x98>
    bp = bread(ip->dev, addr);
8010132a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010132e:	8b 03                	mov    (%ebx),%eax
80101330:	89 04 24             	mov    %eax,(%esp)
80101333:	e8 98 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
80101338:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
8010133c:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010133e:	8b 32                	mov    (%edx),%esi
80101340:	85 f6                	test   %esi,%esi
80101342:	75 19                	jne    8010135d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101344:	8b 03                	mov    (%ebx),%eax
80101346:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101349:	e8 c2 fd ff ff       	call   80101110 <balloc>
8010134e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101351:	89 02                	mov    %eax,(%edx)
80101353:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101355:	89 3c 24             	mov    %edi,(%esp)
80101358:	e8 73 19 00 00       	call   80102cd0 <log_write>
    brelse(bp);
8010135d:	89 3c 24             	mov    %edi,(%esp)
80101360:	e8 7b ee ff ff       	call   801001e0 <brelse>
}
80101365:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
80101368:	89 f0                	mov    %esi,%eax
}
8010136a:	5b                   	pop    %ebx
8010136b:	5e                   	pop    %esi
8010136c:	5f                   	pop    %edi
8010136d:	5d                   	pop    %ebp
8010136e:	c3                   	ret    
8010136f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 03                	mov    (%ebx),%eax
80101372:	e8 99 fd ff ff       	call   80101110 <balloc>
80101377:	89 46 5c             	mov    %eax,0x5c(%esi)
}
8010137a:	83 c4 1c             	add    $0x1c,%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101388:	8b 03                	mov    (%ebx),%eax
8010138a:	e8 81 fd ff ff       	call   80101110 <balloc>
8010138f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101395:	eb 93                	jmp    8010132a <bmap+0x3a>
  panic("bmap: out of range");
80101397:	c7 04 24 05 6f 10 80 	movl   $0x80106f05,(%esp)
8010139e:	e8 bd ef ff ff       	call   80100360 <panic>
801013a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013b0 <readsb>:
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
801013b8:	8b 45 08             	mov    0x8(%ebp),%eax
801013bb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013c2:	00 
{
801013c3:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013c6:	89 04 24             	mov    %eax,(%esp)
801013c9:	e8 02 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013ce:	89 34 24             	mov    %esi,(%esp)
801013d1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013d8:	00 
  bp = bread(dev, 1);
801013d9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013db:	8d 40 5c             	lea    0x5c(%eax),%eax
801013de:	89 44 24 04          	mov    %eax,0x4(%esp)
801013e2:	e8 59 2f 00 00       	call   80104340 <memmove>
  brelse(bp);
801013e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013ea:	83 c4 10             	add    $0x10,%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5d                   	pop    %ebp
  brelse(bp);
801013f0:	e9 eb ed ff ff       	jmp    801001e0 <brelse>
801013f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101400 <bfree>:
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	57                   	push   %edi
80101404:	89 d7                	mov    %edx,%edi
80101406:	56                   	push   %esi
80101407:	53                   	push   %ebx
80101408:	89 c3                	mov    %eax,%ebx
8010140a:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
8010140d:	89 04 24             	mov    %eax,(%esp)
80101410:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101417:	80 
80101418:	e8 93 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010141d:	89 fa                	mov    %edi,%edx
8010141f:	c1 ea 0c             	shr    $0xc,%edx
80101422:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101428:	89 1c 24             	mov    %ebx,(%esp)
  m = 1 << (bi % 8);
8010142b:	bb 01 00 00 00       	mov    $0x1,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101430:	89 54 24 04          	mov    %edx,0x4(%esp)
80101434:	e8 97 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101439:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
8010143b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101441:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101443:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101446:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101449:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
8010144b:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
8010144d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101452:	0f b6 c8             	movzbl %al,%ecx
80101455:	85 d9                	test   %ebx,%ecx
80101457:	74 20                	je     80101479 <bfree+0x79>
  bp->data[bi/8] &= ~m;
80101459:	f7 d3                	not    %ebx
8010145b:	21 c3                	and    %eax,%ebx
8010145d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101461:	89 34 24             	mov    %esi,(%esp)
80101464:	e8 67 18 00 00       	call   80102cd0 <log_write>
  brelse(bp);
80101469:	89 34 24             	mov    %esi,(%esp)
8010146c:	e8 6f ed ff ff       	call   801001e0 <brelse>
}
80101471:	83 c4 1c             	add    $0x1c,%esp
80101474:	5b                   	pop    %ebx
80101475:	5e                   	pop    %esi
80101476:	5f                   	pop    %edi
80101477:	5d                   	pop    %ebp
80101478:	c3                   	ret    
    panic("freeing free block");
80101479:	c7 04 24 18 6f 10 80 	movl   $0x80106f18,(%esp)
80101480:	e8 db ee ff ff       	call   80100360 <panic>
80101485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101499:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010149c:	c7 44 24 04 2b 6f 10 	movl   $0x80106f2b,0x4(%esp)
801014a3:	80 
801014a4:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801014ab:	e8 c0 2b 00 00       	call   80104070 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	89 1c 24             	mov    %ebx,(%esp)
801014b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014b9:	c7 44 24 04 32 6f 10 	movl   $0x80106f32,0x4(%esp)
801014c0:	80 
801014c1:	e8 9a 2a 00 00       	call   80103f60 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014cc:	75 e2                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014ce:	8b 45 08             	mov    0x8(%ebp),%eax
801014d1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014d8:	80 
801014d9:	89 04 24             	mov    %eax,(%esp)
801014dc:	e8 cf fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014e1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014e6:	c7 04 24 98 6f 10 80 	movl   $0x80106f98,(%esp)
801014ed:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014f1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014f6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014fa:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014ff:	89 44 24 14          	mov    %eax,0x14(%esp)
80101503:	a1 cc 09 11 80       	mov    0x801109cc,%eax
80101508:	89 44 24 10          	mov    %eax,0x10(%esp)
8010150c:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101511:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101515:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010151a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010151e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101523:	89 44 24 04          	mov    %eax,0x4(%esp)
80101527:	e8 24 f1 ff ff       	call   80100650 <cprintf>
}
8010152c:	83 c4 24             	add    $0x24,%esp
8010152f:	5b                   	pop    %ebx
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret    
80101532:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101540 <ialloc>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 2c             	sub    $0x2c,%esp
80101549:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010154c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101553:	8b 7d 08             	mov    0x8(%ebp),%edi
80101556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	0f 86 a2 00 00 00    	jbe    80101601 <ialloc+0xc1>
8010155f:	be 01 00 00 00       	mov    $0x1,%esi
80101564:	bb 01 00 00 00       	mov    $0x1,%ebx
80101569:	eb 1a                	jmp    80101585 <ialloc+0x45>
8010156b:	90                   	nop
8010156c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101570:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101573:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101576:	e8 65 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010157b:	89 de                	mov    %ebx,%esi
8010157d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101583:	73 7c                	jae    80101601 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101585:	89 f0                	mov    %esi,%eax
80101587:	c1 e8 03             	shr    $0x3,%eax
8010158a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101590:	89 3c 24             	mov    %edi,(%esp)
80101593:	89 44 24 04          	mov    %eax,0x4(%esp)
80101597:	e8 34 eb ff ff       	call   801000d0 <bread>
8010159c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010159e:	89 f0                	mov    %esi,%eax
801015a0:	83 e0 07             	and    $0x7,%eax
801015a3:	c1 e0 06             	shl    $0x6,%eax
801015a6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015aa:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015ae:	75 c0                	jne    80101570 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015b0:	89 0c 24             	mov    %ecx,(%esp)
801015b3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015ba:	00 
801015bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015c2:	00 
801015c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015c9:	e8 d2 2c 00 00       	call   801042a0 <memset>
      dip->type = type;
801015ce:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015d8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015db:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015de:	89 14 24             	mov    %edx,(%esp)
801015e1:	e8 ea 16 00 00       	call   80102cd0 <log_write>
      brelse(bp);
801015e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015e9:	89 14 24             	mov    %edx,(%esp)
801015ec:	e8 ef eb ff ff       	call   801001e0 <brelse>
}
801015f1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015f4:	89 f2                	mov    %esi,%edx
}
801015f6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015f7:	89 f8                	mov    %edi,%eax
}
801015f9:	5e                   	pop    %esi
801015fa:	5f                   	pop    %edi
801015fb:	5d                   	pop    %ebp
      return iget(dev, inum);
801015fc:	e9 2f fc ff ff       	jmp    80101230 <iget>
  panic("ialloc: no inodes");
80101601:	c7 04 24 38 6f 10 80 	movl   $0x80106f38,(%esp)
80101608:	e8 53 ed ff ff       	call   80100360 <panic>
8010160d:	8d 76 00             	lea    0x0(%esi),%esi

80101610 <iupdate>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	83 ec 10             	sub    $0x10,%esp
80101618:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010161b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101621:	c1 e8 03             	shr    $0x3,%eax
80101624:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010162a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010162e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101631:	89 04 24             	mov    %eax,(%esp)
80101634:	e8 97 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101639:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010163c:	83 e2 07             	and    $0x7,%edx
8010163f:	c1 e2 06             	shl    $0x6,%edx
80101642:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101646:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101648:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010164c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010164f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101653:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101657:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010165b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010165f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101663:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101667:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010166b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010166e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101671:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101675:	89 14 24             	mov    %edx,(%esp)
80101678:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010167f:	00 
80101680:	e8 bb 2c 00 00       	call   80104340 <memmove>
  log_write(bp);
80101685:	89 34 24             	mov    %esi,(%esp)
80101688:	e8 43 16 00 00       	call   80102cd0 <log_write>
  brelse(bp);
8010168d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101690:	83 c4 10             	add    $0x10,%esp
80101693:	5b                   	pop    %ebx
80101694:	5e                   	pop    %esi
80101695:	5d                   	pop    %ebp
  brelse(bp);
80101696:	e9 45 eb ff ff       	jmp    801001e0 <brelse>
8010169b:	90                   	nop
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016a0 <idup>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	53                   	push   %ebx
801016a4:	83 ec 14             	sub    $0x14,%esp
801016a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 aa 2a 00 00       	call   80104160 <acquire>
  ip->ref++;
801016b6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016ba:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016c1:	e8 8a 2b 00 00       	call   80104250 <release>
}
801016c6:	83 c4 14             	add    $0x14,%esp
801016c9:	89 d8                	mov    %ebx,%eax
801016cb:	5b                   	pop    %ebx
801016cc:	5d                   	pop    %ebp
801016cd:	c3                   	ret    
801016ce:	66 90                	xchg   %ax,%ax

801016d0 <ilock>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	83 ec 10             	sub    $0x10,%esp
801016d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016db:	85 db                	test   %ebx,%ebx
801016dd:	0f 84 b3 00 00 00    	je     80101796 <ilock+0xc6>
801016e3:	8b 53 08             	mov    0x8(%ebx),%edx
801016e6:	85 d2                	test   %edx,%edx
801016e8:	0f 8e a8 00 00 00    	jle    80101796 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801016f1:	89 04 24             	mov    %eax,(%esp)
801016f4:	e8 a7 28 00 00       	call   80103fa0 <acquiresleep>
  if(ip->valid == 0){
801016f9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016fc:	85 c0                	test   %eax,%eax
801016fe:	74 08                	je     80101708 <ilock+0x38>
}
80101700:	83 c4 10             	add    $0x10,%esp
80101703:	5b                   	pop    %ebx
80101704:	5e                   	pop    %esi
80101705:	5d                   	pop    %ebp
80101706:	c3                   	ret    
80101707:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101708:	8b 43 04             	mov    0x4(%ebx),%eax
8010170b:	c1 e8 03             	shr    $0x3,%eax
8010170e:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101714:	89 44 24 04          	mov    %eax,0x4(%esp)
80101718:	8b 03                	mov    (%ebx),%eax
8010171a:	89 04 24             	mov    %eax,(%esp)
8010171d:	e8 ae e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101722:	8b 53 04             	mov    0x4(%ebx),%edx
80101725:	83 e2 07             	and    $0x7,%edx
80101728:	c1 e2 06             	shl    $0x6,%edx
8010172b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010172f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101731:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101734:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101737:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010173b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010173f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101743:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101747:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010174b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010174f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101753:	8b 42 fc             	mov    -0x4(%edx),%eax
80101756:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101759:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010175c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101760:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101767:	00 
80101768:	89 04 24             	mov    %eax,(%esp)
8010176b:	e8 d0 2b 00 00       	call   80104340 <memmove>
    brelse(bp);
80101770:	89 34 24             	mov    %esi,(%esp)
80101773:	e8 68 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101778:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010177d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101784:	0f 85 76 ff ff ff    	jne    80101700 <ilock+0x30>
      panic("ilock: no type");
8010178a:	c7 04 24 50 6f 10 80 	movl   $0x80106f50,(%esp)
80101791:	e8 ca eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101796:	c7 04 24 4a 6f 10 80 	movl   $0x80106f4a,(%esp)
8010179d:	e8 be eb ff ff       	call   80100360 <panic>
801017a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017b0 <iunlock>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	56                   	push   %esi
801017b4:	53                   	push   %ebx
801017b5:	83 ec 10             	sub    $0x10,%esp
801017b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017bb:	85 db                	test   %ebx,%ebx
801017bd:	74 24                	je     801017e3 <iunlock+0x33>
801017bf:	8d 73 0c             	lea    0xc(%ebx),%esi
801017c2:	89 34 24             	mov    %esi,(%esp)
801017c5:	e8 76 28 00 00       	call   80104040 <holdingsleep>
801017ca:	85 c0                	test   %eax,%eax
801017cc:	74 15                	je     801017e3 <iunlock+0x33>
801017ce:	8b 43 08             	mov    0x8(%ebx),%eax
801017d1:	85 c0                	test   %eax,%eax
801017d3:	7e 0e                	jle    801017e3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017d5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	5b                   	pop    %ebx
801017dc:	5e                   	pop    %esi
801017dd:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017de:	e9 1d 28 00 00       	jmp    80104000 <releasesleep>
    panic("iunlock");
801017e3:	c7 04 24 5f 6f 10 80 	movl   $0x80106f5f,(%esp)
801017ea:	e8 71 eb ff ff       	call   80100360 <panic>
801017ef:	90                   	nop

801017f0 <iput>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 1c             	sub    $0x1c,%esp
801017f9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017fc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017ff:	89 3c 24             	mov    %edi,(%esp)
80101802:	e8 99 27 00 00       	call   80103fa0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101807:	8b 56 4c             	mov    0x4c(%esi),%edx
8010180a:	85 d2                	test   %edx,%edx
8010180c:	74 07                	je     80101815 <iput+0x25>
8010180e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101813:	74 2b                	je     80101840 <iput+0x50>
  releasesleep(&ip->lock);
80101815:	89 3c 24             	mov    %edi,(%esp)
80101818:	e8 e3 27 00 00       	call   80104000 <releasesleep>
  acquire(&icache.lock);
8010181d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101824:	e8 37 29 00 00       	call   80104160 <acquire>
  ip->ref--;
80101829:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010182d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101834:	83 c4 1c             	add    $0x1c,%esp
80101837:	5b                   	pop    %ebx
80101838:	5e                   	pop    %esi
80101839:	5f                   	pop    %edi
8010183a:	5d                   	pop    %ebp
  release(&icache.lock);
8010183b:	e9 10 2a 00 00       	jmp    80104250 <release>
    acquire(&icache.lock);
80101840:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101847:	e8 14 29 00 00       	call   80104160 <acquire>
    int r = ip->ref;
8010184c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010184f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101856:	e8 f5 29 00 00       	call   80104250 <release>
    if(r == 1){
8010185b:	83 fb 01             	cmp    $0x1,%ebx
8010185e:	75 b5                	jne    80101815 <iput+0x25>
80101860:	8d 4e 30             	lea    0x30(%esi),%ecx
80101863:	89 f3                	mov    %esi,%ebx
80101865:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101868:	89 cf                	mov    %ecx,%edi
8010186a:	eb 0b                	jmp    80101877 <iput+0x87>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101870:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101873:	39 fb                	cmp    %edi,%ebx
80101875:	74 19                	je     80101890 <iput+0xa0>
    if(ip->addrs[i]){
80101877:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010187a:	85 d2                	test   %edx,%edx
8010187c:	74 f2                	je     80101870 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010187e:	8b 06                	mov    (%esi),%eax
80101880:	e8 7b fb ff ff       	call   80101400 <bfree>
      ip->addrs[i] = 0;
80101885:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010188c:	eb e2                	jmp    80101870 <iput+0x80>
8010188e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101890:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101896:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101899:	85 c0                	test   %eax,%eax
8010189b:	75 2b                	jne    801018c8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010189d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018a4:	89 34 24             	mov    %esi,(%esp)
801018a7:	e8 64 fd ff ff       	call   80101610 <iupdate>
      ip->type = 0;
801018ac:	31 c0                	xor    %eax,%eax
801018ae:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018b2:	89 34 24             	mov    %esi,(%esp)
801018b5:	e8 56 fd ff ff       	call   80101610 <iupdate>
      ip->valid = 0;
801018ba:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018c1:	e9 4f ff ff ff       	jmp    80101815 <iput+0x25>
801018c6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018cc:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018ce:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d0:	89 04 24             	mov    %eax,(%esp)
801018d3:	e8 f8 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018d8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018db:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018e1:	89 cf                	mov    %ecx,%edi
801018e3:	31 c0                	xor    %eax,%eax
801018e5:	eb 0e                	jmp    801018f5 <iput+0x105>
801018e7:	90                   	nop
801018e8:	83 c3 01             	add    $0x1,%ebx
801018eb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018f1:	89 d8                	mov    %ebx,%eax
801018f3:	74 10                	je     80101905 <iput+0x115>
      if(a[j])
801018f5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018f8:	85 d2                	test   %edx,%edx
801018fa:	74 ec                	je     801018e8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018fc:	8b 06                	mov    (%esi),%eax
801018fe:	e8 fd fa ff ff       	call   80101400 <bfree>
80101903:	eb e3                	jmp    801018e8 <iput+0xf8>
    brelse(bp);
80101905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101908:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010190b:	89 04 24             	mov    %eax,(%esp)
8010190e:	e8 cd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101913:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101919:	8b 06                	mov    (%esi),%eax
8010191b:	e8 e0 fa ff ff       	call   80101400 <bfree>
    ip->addrs[NDIRECT] = 0;
80101920:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101927:	00 00 00 
8010192a:	e9 6e ff ff ff       	jmp    8010189d <iput+0xad>
8010192f:	90                   	nop

80101930 <iunlockput>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 14             	sub    $0x14,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010193a:	89 1c 24             	mov    %ebx,(%esp)
8010193d:	e8 6e fe ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101942:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101945:	83 c4 14             	add    $0x14,%esp
80101948:	5b                   	pop    %ebx
80101949:	5d                   	pop    %ebp
  iput(ip);
8010194a:	e9 a1 fe ff ff       	jmp    801017f0 <iput>
8010194f:	90                   	nop

80101950 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	8b 55 08             	mov    0x8(%ebp),%edx
80101956:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101959:	8b 0a                	mov    (%edx),%ecx
8010195b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010195e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101961:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101964:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101968:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010196b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010196f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101973:	8b 52 58             	mov    0x58(%edx),%edx
80101976:	89 50 10             	mov    %edx,0x10(%eax)
}
80101979:	5d                   	pop    %ebp
8010197a:	c3                   	ret    
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 2c             	sub    $0x2c,%esp
80101989:	8b 45 0c             	mov    0xc(%ebp),%eax
8010198c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010198f:	8b 75 10             	mov    0x10(%ebp),%esi
80101992:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101995:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101998:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010199d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019a0:	0f 84 aa 00 00 00    	je     80101a50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019a6:	8b 47 58             	mov    0x58(%edi),%eax
801019a9:	39 f0                	cmp    %esi,%eax
801019ab:	0f 82 c7 00 00 00    	jb     80101a78 <readi+0xf8>
801019b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019b4:	89 da                	mov    %ebx,%edx
801019b6:	01 f2                	add    %esi,%edx
801019b8:	0f 82 ba 00 00 00    	jb     80101a78 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019be:	89 c1                	mov    %eax,%ecx
801019c0:	29 f1                	sub    %esi,%ecx
801019c2:	39 d0                	cmp    %edx,%eax
801019c4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c7:	31 c0                	xor    %eax,%eax
801019c9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019cb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ce:	74 70                	je     80101a40 <readi+0xc0>
801019d0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019d3:	89 c7                	mov    %eax,%edi
801019d5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019db:	89 f2                	mov    %esi,%edx
801019dd:	c1 ea 09             	shr    $0x9,%edx
801019e0:	89 d8                	mov    %ebx,%eax
801019e2:	e8 09 f9 ff ff       	call   801012f0 <bmap>
801019e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019eb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ed:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019f2:	89 04 24             	mov    %eax,(%esp)
801019f5:	e8 d6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019fd:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ff:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a01:	89 f0                	mov    %esi,%eax
80101a03:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a08:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a10:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a17:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a1a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a1e:	01 df                	add    %ebx,%edi
80101a20:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a22:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a25:	89 04 24             	mov    %eax,(%esp)
80101a28:	e8 13 29 00 00       	call   80104340 <memmove>
    brelse(bp);
80101a2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a30:	89 14 24             	mov    %edx,(%esp)
80101a33:	e8 a8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a38:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a3b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a3e:	77 98                	ja     801019d8 <readi+0x58>
  }
  return n;
80101a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a43:	83 c4 2c             	add    $0x2c,%esp
80101a46:	5b                   	pop    %ebx
80101a47:	5e                   	pop    %esi
80101a48:	5f                   	pop    %edi
80101a49:	5d                   	pop    %ebp
80101a4a:	c3                   	ret    
80101a4b:	90                   	nop
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a50:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a54:	66 83 f8 09          	cmp    $0x9,%ax
80101a58:	77 1e                	ja     80101a78 <readi+0xf8>
80101a5a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	74 13                	je     80101a78 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a65:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a68:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a6b:	83 c4 2c             	add    $0x2c,%esp
80101a6e:	5b                   	pop    %ebx
80101a6f:	5e                   	pop    %esi
80101a70:	5f                   	pop    %edi
80101a71:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a72:	ff e0                	jmp    *%eax
80101a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a7d:	eb c4                	jmp    80101a43 <readi+0xc3>
80101a7f:	90                   	nop

80101a80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	57                   	push   %edi
80101a84:	56                   	push   %esi
80101a85:	53                   	push   %ebx
80101a86:	83 ec 2c             	sub    $0x2c,%esp
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a8f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a9a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a9d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aa0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101aa3:	0f 84 b7 00 00 00    	je     80101b60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101aa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aac:	39 70 58             	cmp    %esi,0x58(%eax)
80101aaf:	0f 82 e3 00 00 00    	jb     80101b98 <writei+0x118>
80101ab5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ab8:	89 c8                	mov    %ecx,%eax
80101aba:	01 f0                	add    %esi,%eax
80101abc:	0f 82 d6 00 00 00    	jb     80101b98 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ac2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ac7:	0f 87 cb 00 00 00    	ja     80101b98 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101acd:	85 c9                	test   %ecx,%ecx
80101acf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ad6:	74 77                	je     80101b4f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101adb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101add:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae2:	c1 ea 09             	shr    $0x9,%edx
80101ae5:	89 f8                	mov    %edi,%eax
80101ae7:	e8 04 f8 ff ff       	call   801012f0 <bmap>
80101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
80101af0:	8b 07                	mov    (%edi),%eax
80101af2:	89 04 24             	mov    %eax,(%esp)
80101af5:	e8 d6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101afa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101afd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b00:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b03:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b05:	89 f0                	mov    %esi,%eax
80101b07:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b0c:	29 c3                	sub    %eax,%ebx
80101b0e:	39 cb                	cmp    %ecx,%ebx
80101b10:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b17:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b19:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b1d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b21:	89 04 24             	mov    %eax,(%esp)
80101b24:	e8 17 28 00 00       	call   80104340 <memmove>
    log_write(bp);
80101b29:	89 3c 24             	mov    %edi,(%esp)
80101b2c:	e8 9f 11 00 00       	call   80102cd0 <log_write>
    brelse(bp);
80101b31:	89 3c 24             	mov    %edi,(%esp)
80101b34:	e8 a7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b39:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b3f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b42:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b45:	77 91                	ja     80101ad8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b47:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b4d:	72 39                	jb     80101b88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b52:	83 c4 2c             	add    $0x2c,%esp
80101b55:	5b                   	pop    %ebx
80101b56:	5e                   	pop    %esi
80101b57:	5f                   	pop    %edi
80101b58:	5d                   	pop    %ebp
80101b59:	c3                   	ret    
80101b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 2e                	ja     80101b98 <writei+0x118>
80101b6a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 23                	je     80101b98 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b75:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b78:	83 c4 2c             	add    $0x2c,%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b7f:	ff e0                	jmp    *%eax
80101b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b88:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b8b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b8e:	89 04 24             	mov    %eax,(%esp)
80101b91:	e8 7a fa ff ff       	call   80101610 <iupdate>
80101b96:	eb b7                	jmp    80101b4f <writei+0xcf>
}
80101b98:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101ba0:	5b                   	pop    %ebx
80101ba1:	5e                   	pop    %esi
80101ba2:	5f                   	pop    %edi
80101ba3:	5d                   	pop    %ebp
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bb9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bc0:	00 
80101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc8:	89 04 24             	mov    %eax,(%esp)
80101bcb:	e8 f0 27 00 00       	call   801043c0 <strncmp>
}
80101bd0:	c9                   	leave  
80101bd1:	c3                   	ret    
80101bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 2c             	sub    $0x2c,%esp
80101be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bf1:	0f 85 97 00 00 00    	jne    80101c8e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bfa:	31 ff                	xor    %edi,%edi
80101bfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bff:	85 d2                	test   %edx,%edx
80101c01:	75 0d                	jne    80101c10 <dirlookup+0x30>
80101c03:	eb 73                	jmp    80101c78 <dirlookup+0x98>
80101c05:	8d 76 00             	lea    0x0(%esi),%esi
80101c08:	83 c7 10             	add    $0x10,%edi
80101c0b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c0e:	76 68                	jbe    80101c78 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c10:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c17:	00 
80101c18:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c1c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c20:	89 1c 24             	mov    %ebx,(%esp)
80101c23:	e8 58 fd ff ff       	call   80101980 <readi>
80101c28:	83 f8 10             	cmp    $0x10,%eax
80101c2b:	75 55                	jne    80101c82 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c2d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c32:	74 d4                	je     80101c08 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c3e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c45:	00 
80101c46:	89 04 24             	mov    %eax,(%esp)
80101c49:	e8 72 27 00 00       	call   801043c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c4e:	85 c0                	test   %eax,%eax
80101c50:	75 b6                	jne    80101c08 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c52:	8b 45 10             	mov    0x10(%ebp),%eax
80101c55:	85 c0                	test   %eax,%eax
80101c57:	74 05                	je     80101c5e <dirlookup+0x7e>
        *poff = off;
80101c59:	8b 45 10             	mov    0x10(%ebp),%eax
80101c5c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c5e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c62:	8b 03                	mov    (%ebx),%eax
80101c64:	e8 c7 f5 ff ff       	call   80101230 <iget>
    }
  }

  return 0;
}
80101c69:	83 c4 2c             	add    $0x2c,%esp
80101c6c:	5b                   	pop    %ebx
80101c6d:	5e                   	pop    %esi
80101c6e:	5f                   	pop    %edi
80101c6f:	5d                   	pop    %ebp
80101c70:	c3                   	ret    
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c78:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c7b:	31 c0                	xor    %eax,%eax
}
80101c7d:	5b                   	pop    %ebx
80101c7e:	5e                   	pop    %esi
80101c7f:	5f                   	pop    %edi
80101c80:	5d                   	pop    %ebp
80101c81:	c3                   	ret    
      panic("dirlookup read");
80101c82:	c7 04 24 79 6f 10 80 	movl   $0x80106f79,(%esp)
80101c89:	e8 d2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c8e:	c7 04 24 67 6f 10 80 	movl   $0x80106f67,(%esp)
80101c95:	e8 c6 e6 ff ff       	call   80100360 <panic>
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	89 cf                	mov    %ecx,%edi
80101ca6:	56                   	push   %esi
80101ca7:	53                   	push   %ebx
80101ca8:	89 c3                	mov    %eax,%ebx
80101caa:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cad:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cb3:	0f 84 51 01 00 00    	je     80101e0a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cb9:	e8 02 1a 00 00       	call   801036c0 <myproc>
80101cbe:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 93 24 00 00       	call   80104160 <acquire>
  ip->ref++;
80101ccd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cd8:	e8 73 25 00 00       	call   80104250 <release>
80101cdd:	eb 04                	jmp    80101ce3 <namex+0x43>
80101cdf:	90                   	nop
    path++;
80101ce0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ce3:	0f b6 03             	movzbl (%ebx),%eax
80101ce6:	3c 2f                	cmp    $0x2f,%al
80101ce8:	74 f6                	je     80101ce0 <namex+0x40>
  if(*path == 0)
80101cea:	84 c0                	test   %al,%al
80101cec:	0f 84 ed 00 00 00    	je     80101ddf <namex+0x13f>
  while(*path != '/' && *path != 0)
80101cf2:	0f b6 03             	movzbl (%ebx),%eax
80101cf5:	89 da                	mov    %ebx,%edx
80101cf7:	84 c0                	test   %al,%al
80101cf9:	0f 84 b1 00 00 00    	je     80101db0 <namex+0x110>
80101cff:	3c 2f                	cmp    $0x2f,%al
80101d01:	75 0f                	jne    80101d12 <namex+0x72>
80101d03:	e9 a8 00 00 00       	jmp    80101db0 <namex+0x110>
80101d08:	3c 2f                	cmp    $0x2f,%al
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d10:	74 0a                	je     80101d1c <namex+0x7c>
    path++;
80101d12:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d15:	0f b6 02             	movzbl (%edx),%eax
80101d18:	84 c0                	test   %al,%al
80101d1a:	75 ec                	jne    80101d08 <namex+0x68>
80101d1c:	89 d1                	mov    %edx,%ecx
80101d1e:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d20:	83 f9 0d             	cmp    $0xd,%ecx
80101d23:	0f 8e 8f 00 00 00    	jle    80101db8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d29:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d2d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d34:	00 
80101d35:	89 3c 24             	mov    %edi,(%esp)
80101d38:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d3b:	e8 00 26 00 00       	call   80104340 <memmove>
    path++;
80101d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d43:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d45:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d48:	75 0e                	jne    80101d58 <namex+0xb8>
80101d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d56:	74 f8                	je     80101d50 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d58:	89 34 24             	mov    %esi,(%esp)
80101d5b:	e8 70 f9 ff ff       	call   801016d0 <ilock>
    if(ip->type != T_DIR){
80101d60:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d65:	0f 85 85 00 00 00    	jne    80101df0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d6e:	85 d2                	test   %edx,%edx
80101d70:	74 09                	je     80101d7b <namex+0xdb>
80101d72:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d75:	0f 84 a5 00 00 00    	je     80101e20 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d82:	00 
80101d83:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d87:	89 34 24             	mov    %esi,(%esp)
80101d8a:	e8 51 fe ff ff       	call   80101be0 <dirlookup>
80101d8f:	85 c0                	test   %eax,%eax
80101d91:	74 5d                	je     80101df0 <namex+0x150>
  iunlock(ip);
80101d93:	89 34 24             	mov    %esi,(%esp)
80101d96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d99:	e8 12 fa ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101d9e:	89 34 24             	mov    %esi,(%esp)
80101da1:	e8 4a fa ff ff       	call   801017f0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da9:	89 c6                	mov    %eax,%esi
80101dab:	e9 33 ff ff ff       	jmp    80101ce3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101db0:	31 c9                	xor    %ecx,%ecx
80101db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101db8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dbc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101dc0:	89 3c 24             	mov    %edi,(%esp)
80101dc3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc9:	e8 72 25 00 00       	call   80104340 <memmove>
    name[len] = 0;
80101dce:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dd4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dd8:	89 d3                	mov    %edx,%ebx
80101dda:	e9 66 ff ff ff       	jmp    80101d45 <namex+0xa5>
  }
  if(nameiparent){
80101ddf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101de2:	85 c0                	test   %eax,%eax
80101de4:	75 4c                	jne    80101e32 <namex+0x192>
80101de6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101de8:	83 c4 2c             	add    $0x2c,%esp
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
  iunlock(ip);
80101df0:	89 34 24             	mov    %esi,(%esp)
80101df3:	e8 b8 f9 ff ff       	call   801017b0 <iunlock>
  iput(ip);
80101df8:	89 34 24             	mov    %esi,(%esp)
80101dfb:	e8 f0 f9 ff ff       	call   801017f0 <iput>
}
80101e00:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101e03:	31 c0                	xor    %eax,%eax
}
80101e05:	5b                   	pop    %ebx
80101e06:	5e                   	pop    %esi
80101e07:	5f                   	pop    %edi
80101e08:	5d                   	pop    %ebp
80101e09:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e0a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e0f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e14:	e8 17 f4 ff ff       	call   80101230 <iget>
80101e19:	89 c6                	mov    %eax,%esi
80101e1b:	e9 c3 fe ff ff       	jmp    80101ce3 <namex+0x43>
      iunlock(ip);
80101e20:	89 34 24             	mov    %esi,(%esp)
80101e23:	e8 88 f9 ff ff       	call   801017b0 <iunlock>
}
80101e28:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e2b:	89 f0                	mov    %esi,%eax
}
80101e2d:	5b                   	pop    %ebx
80101e2e:	5e                   	pop    %esi
80101e2f:	5f                   	pop    %edi
80101e30:	5d                   	pop    %ebp
80101e31:	c3                   	ret    
    iput(ip);
80101e32:	89 34 24             	mov    %esi,(%esp)
80101e35:	e8 b6 f9 ff ff       	call   801017f0 <iput>
    return 0;
80101e3a:	31 c0                	xor    %eax,%eax
80101e3c:	eb aa                	jmp    80101de8 <namex+0x148>
80101e3e:	66 90                	xchg   %ax,%ax

80101e40 <dirlink>:
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	83 ec 2c             	sub    $0x2c,%esp
80101e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e56:	00 
80101e57:	89 1c 24             	mov    %ebx,(%esp)
80101e5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e5e:	e8 7d fd ff ff       	call   80101be0 <dirlookup>
80101e63:	85 c0                	test   %eax,%eax
80101e65:	0f 85 8b 00 00 00    	jne    80101ef6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e6b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e6e:	31 ff                	xor    %edi,%edi
80101e70:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e73:	85 c0                	test   %eax,%eax
80101e75:	75 13                	jne    80101e8a <dirlink+0x4a>
80101e77:	eb 35                	jmp    80101eae <dirlink+0x6e>
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e80:	8d 57 10             	lea    0x10(%edi),%edx
80101e83:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e86:	89 d7                	mov    %edx,%edi
80101e88:	76 24                	jbe    80101eae <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e91:	00 
80101e92:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e96:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e9a:	89 1c 24             	mov    %ebx,(%esp)
80101e9d:	e8 de fa ff ff       	call   80101980 <readi>
80101ea2:	83 f8 10             	cmp    $0x10,%eax
80101ea5:	75 5e                	jne    80101f05 <dirlink+0xc5>
    if(de.inum == 0)
80101ea7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eac:	75 d2                	jne    80101e80 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101eae:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101eb8:	00 
80101eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ebd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ec0:	89 04 24             	mov    %eax,(%esp)
80101ec3:	e8 68 25 00 00       	call   80104430 <strncpy>
  de.inum = inum;
80101ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ecb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ed2:	00 
80101ed3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ed7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101edb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101ede:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ee2:	e8 99 fb ff ff       	call   80101a80 <writei>
80101ee7:	83 f8 10             	cmp    $0x10,%eax
80101eea:	75 25                	jne    80101f11 <dirlink+0xd1>
  return 0;
80101eec:	31 c0                	xor    %eax,%eax
}
80101eee:	83 c4 2c             	add    $0x2c,%esp
80101ef1:	5b                   	pop    %ebx
80101ef2:	5e                   	pop    %esi
80101ef3:	5f                   	pop    %edi
80101ef4:	5d                   	pop    %ebp
80101ef5:	c3                   	ret    
    iput(ip);
80101ef6:	89 04 24             	mov    %eax,(%esp)
80101ef9:	e8 f2 f8 ff ff       	call   801017f0 <iput>
    return -1;
80101efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f03:	eb e9                	jmp    80101eee <dirlink+0xae>
      panic("dirlink read");
80101f05:	c7 04 24 88 6f 10 80 	movl   $0x80106f88,(%esp)
80101f0c:	e8 4f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101f11:	c7 04 24 86 75 10 80 	movl   $0x80107586,(%esp)
80101f18:	e8 43 e4 ff ff       	call   80100360 <panic>
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi

80101f20 <namei>:

struct inode*
namei(char *path)
{
80101f20:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f21:	31 d2                	xor    %edx,%edx
{
80101f23:	89 e5                	mov    %esp,%ebp
80101f25:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f2e:	e8 6d fd ff ff       	call   80101ca0 <namex>
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    
80101f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f40:	55                   	push   %ebp
  return namex(path, 1, name);
80101f41:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f46:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f4e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f4f:	e9 4c fd ff ff       	jmp    80101ca0 <namex>
80101f54:	66 90                	xchg   %ax,%ax
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	66 90                	xchg   %ax,%ax
80101f5a:	66 90                	xchg   %ax,%ax
80101f5c:	66 90                	xchg   %ax,%ax
80101f5e:	66 90                	xchg   %ax,%ax

80101f60 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	56                   	push   %esi
80101f64:	89 c6                	mov    %eax,%esi
80101f66:	53                   	push   %ebx
80101f67:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f6a:	85 c0                	test   %eax,%eax
80101f6c:	0f 84 99 00 00 00    	je     8010200b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f72:	8b 48 08             	mov    0x8(%eax),%ecx
80101f75:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f7b:	0f 87 7e 00 00 00    	ja     80101fff <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f81:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f86:	66 90                	xchg   %ax,%ax
80101f88:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f89:	83 e0 c0             	and    $0xffffffc0,%eax
80101f8c:	3c 40                	cmp    $0x40,%al
80101f8e:	75 f8                	jne    80101f88 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f90:	31 db                	xor    %ebx,%ebx
80101f92:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f97:	89 d8                	mov    %ebx,%eax
80101f99:	ee                   	out    %al,(%dx)
80101f9a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f9f:	b8 01 00 00 00       	mov    $0x1,%eax
80101fa4:	ee                   	out    %al,(%dx)
80101fa5:	0f b6 c1             	movzbl %cl,%eax
80101fa8:	b2 f3                	mov    $0xf3,%dl
80101faa:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fab:	89 c8                	mov    %ecx,%eax
80101fad:	b2 f4                	mov    $0xf4,%dl
80101faf:	c1 f8 08             	sar    $0x8,%eax
80101fb2:	ee                   	out    %al,(%dx)
80101fb3:	b2 f5                	mov    $0xf5,%dl
80101fb5:	89 d8                	mov    %ebx,%eax
80101fb7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fb8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fbc:	b2 f6                	mov    $0xf6,%dl
80101fbe:	83 e0 01             	and    $0x1,%eax
80101fc1:	c1 e0 04             	shl    $0x4,%eax
80101fc4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fc7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fc8:	f6 06 04             	testb  $0x4,(%esi)
80101fcb:	75 13                	jne    80101fe0 <idestart+0x80>
80101fcd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fd2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fd7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
80101fdf:	90                   	nop
80101fe0:	b2 f7                	mov    $0xf7,%dl
80101fe2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fe7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fe8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fed:	83 c6 5c             	add    $0x5c,%esi
80101ff0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ff5:	fc                   	cld    
80101ff6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101ff8:	83 c4 10             	add    $0x10,%esp
80101ffb:	5b                   	pop    %ebx
80101ffc:	5e                   	pop    %esi
80101ffd:	5d                   	pop    %ebp
80101ffe:	c3                   	ret    
    panic("incorrect blockno");
80101fff:	c7 04 24 f4 6f 10 80 	movl   $0x80106ff4,(%esp)
80102006:	e8 55 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
8010200b:	c7 04 24 eb 6f 10 80 	movl   $0x80106feb,(%esp)
80102012:	e8 49 e3 ff ff       	call   80100360 <panic>
80102017:	89 f6                	mov    %esi,%esi
80102019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102020 <ideinit>:
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102026:	c7 44 24 04 06 70 10 	movl   $0x80107006,0x4(%esp)
8010202d:	80 
8010202e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102035:	e8 36 20 00 00       	call   80104070 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010203a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010203f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102046:	83 e8 01             	sub    $0x1,%eax
80102049:	89 44 24 04          	mov    %eax,0x4(%esp)
8010204d:	e8 7e 02 00 00       	call   801022d0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102052:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102057:	90                   	nop
80102058:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102059:	83 e0 c0             	and    $0xffffffc0,%eax
8010205c:	3c 40                	cmp    $0x40,%al
8010205e:	75 f8                	jne    80102058 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102060:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102065:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010206a:	ee                   	out    %al,(%dx)
8010206b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102070:	b2 f7                	mov    $0xf7,%dl
80102072:	eb 09                	jmp    8010207d <ideinit+0x5d>
80102074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102078:	83 e9 01             	sub    $0x1,%ecx
8010207b:	74 0f                	je     8010208c <ideinit+0x6c>
8010207d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010207e:	84 c0                	test   %al,%al
80102080:	74 f6                	je     80102078 <ideinit+0x58>
      havedisk1 = 1;
80102082:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102089:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010208c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102091:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102096:	ee                   	out    %al,(%dx)
}
80102097:	c9                   	leave  
80102098:	c3                   	ret    
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020a9:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020b0:	e8 ab 20 00 00       	call   80104160 <acquire>

  if((b = idequeue) == 0){
801020b5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020bb:	85 db                	test   %ebx,%ebx
801020bd:	74 30                	je     801020ef <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020bf:	8b 43 58             	mov    0x58(%ebx),%eax
801020c2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020c7:	8b 33                	mov    (%ebx),%esi
801020c9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020cf:	74 37                	je     80102108 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020d1:	83 e6 fb             	and    $0xfffffffb,%esi
801020d4:	83 ce 02             	or     $0x2,%esi
801020d7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020d9:	89 1c 24             	mov    %ebx,(%esp)
801020dc:	e8 cf 1c 00 00       	call   80103db0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020e1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020e6:	85 c0                	test   %eax,%eax
801020e8:	74 05                	je     801020ef <ideintr+0x4f>
    idestart(idequeue);
801020ea:	e8 71 fe ff ff       	call   80101f60 <idestart>
    release(&idelock);
801020ef:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020f6:	e8 55 21 00 00       	call   80104250 <release>

  release(&idelock);
}
801020fb:	83 c4 1c             	add    $0x1c,%esp
801020fe:	5b                   	pop    %ebx
801020ff:	5e                   	pop    %esi
80102100:	5f                   	pop    %edi
80102101:	5d                   	pop    %ebp
80102102:	c3                   	ret    
80102103:	90                   	nop
80102104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102108:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010210d:	8d 76 00             	lea    0x0(%esi),%esi
80102110:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102111:	89 c1                	mov    %eax,%ecx
80102113:	83 e1 c0             	and    $0xffffffc0,%ecx
80102116:	80 f9 40             	cmp    $0x40,%cl
80102119:	75 f5                	jne    80102110 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010211b:	a8 21                	test   $0x21,%al
8010211d:	75 b2                	jne    801020d1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
8010211f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102122:	b9 80 00 00 00       	mov    $0x80,%ecx
80102127:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212c:	fc                   	cld    
8010212d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010212f:	8b 33                	mov    (%ebx),%esi
80102131:	eb 9e                	jmp    801020d1 <ideintr+0x31>
80102133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102140 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	53                   	push   %ebx
80102144:	83 ec 14             	sub    $0x14,%esp
80102147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010214a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010214d:	89 04 24             	mov    %eax,(%esp)
80102150:	e8 eb 1e 00 00       	call   80104040 <holdingsleep>
80102155:	85 c0                	test   %eax,%eax
80102157:	0f 84 9e 00 00 00    	je     801021fb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010215d:	8b 03                	mov    (%ebx),%eax
8010215f:	83 e0 06             	and    $0x6,%eax
80102162:	83 f8 02             	cmp    $0x2,%eax
80102165:	0f 84 a8 00 00 00    	je     80102213 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010216b:	8b 53 04             	mov    0x4(%ebx),%edx
8010216e:	85 d2                	test   %edx,%edx
80102170:	74 0d                	je     8010217f <iderw+0x3f>
80102172:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102177:	85 c0                	test   %eax,%eax
80102179:	0f 84 88 00 00 00    	je     80102207 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010217f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102186:	e8 d5 1f 00 00       	call   80104160 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102190:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102197:	85 c0                	test   %eax,%eax
80102199:	75 07                	jne    801021a2 <iderw+0x62>
8010219b:	eb 4e                	jmp    801021eb <iderw+0xab>
8010219d:	8d 76 00             	lea    0x0(%esi),%esi
801021a0:	89 d0                	mov    %edx,%eax
801021a2:	8b 50 58             	mov    0x58(%eax),%edx
801021a5:	85 d2                	test   %edx,%edx
801021a7:	75 f7                	jne    801021a0 <iderw+0x60>
801021a9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021ac:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021ae:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021b4:	74 3c                	je     801021f2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021b6:	8b 03                	mov    (%ebx),%eax
801021b8:	83 e0 06             	and    $0x6,%eax
801021bb:	83 f8 02             	cmp    $0x2,%eax
801021be:	74 1a                	je     801021da <iderw+0x9a>
    sleep(b, &idelock);
801021c0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021c7:	80 
801021c8:	89 1c 24             	mov    %ebx,(%esp)
801021cb:	e8 50 1a 00 00       	call   80103c20 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021d0:	8b 13                	mov    (%ebx),%edx
801021d2:	83 e2 06             	and    $0x6,%edx
801021d5:	83 fa 02             	cmp    $0x2,%edx
801021d8:	75 e6                	jne    801021c0 <iderw+0x80>
  }


  release(&idelock);
801021da:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021e1:	83 c4 14             	add    $0x14,%esp
801021e4:	5b                   	pop    %ebx
801021e5:	5d                   	pop    %ebp
  release(&idelock);
801021e6:	e9 65 20 00 00       	jmp    80104250 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021eb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021f0:	eb ba                	jmp    801021ac <iderw+0x6c>
    idestart(b);
801021f2:	89 d8                	mov    %ebx,%eax
801021f4:	e8 67 fd ff ff       	call   80101f60 <idestart>
801021f9:	eb bb                	jmp    801021b6 <iderw+0x76>
    panic("iderw: buf not locked");
801021fb:	c7 04 24 0a 70 10 80 	movl   $0x8010700a,(%esp)
80102202:	e8 59 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
80102207:	c7 04 24 35 70 10 80 	movl   $0x80107035,(%esp)
8010220e:	e8 4d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102213:	c7 04 24 20 70 10 80 	movl   $0x80107020,(%esp)
8010221a:	e8 41 e1 ff ff       	call   80100360 <panic>
8010221f:	90                   	nop

80102220 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	56                   	push   %esi
80102224:	53                   	push   %ebx
80102225:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102228:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010222f:	00 c0 fe 
  ioapic->reg = reg;
80102232:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102239:	00 00 00 
  return ioapic->data;
8010223c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102242:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102245:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010224b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102251:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102258:	c1 e8 10             	shr    $0x10,%eax
8010225b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010225e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102261:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102264:	39 c2                	cmp    %eax,%edx
80102266:	74 12                	je     8010227a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102268:	c7 04 24 54 70 10 80 	movl   $0x80107054,(%esp)
8010226f:	e8 dc e3 ff ff       	call   80100650 <cprintf>
80102274:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010227a:	ba 10 00 00 00       	mov    $0x10,%edx
8010227f:	31 c0                	xor    %eax,%eax
80102281:	eb 07                	jmp    8010228a <ioapicinit+0x6a>
80102283:	90                   	nop
80102284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102288:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010228a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010228c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102292:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102295:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010229b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010229e:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022a1:	8d 4a 01             	lea    0x1(%edx),%ecx
801022a4:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801022a7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022a9:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801022af:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
801022b1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022b8:	7d ce                	jge    80102288 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ba:	83 c4 10             	add    $0x10,%esp
801022bd:	5b                   	pop    %ebx
801022be:	5e                   	pop    %esi
801022bf:	5d                   	pop    %ebp
801022c0:	c3                   	ret    
801022c1:	eb 0d                	jmp    801022d0 <ioapicenable>
801022c3:	90                   	nop
801022c4:	90                   	nop
801022c5:	90                   	nop
801022c6:	90                   	nop
801022c7:	90                   	nop
801022c8:	90                   	nop
801022c9:	90                   	nop
801022ca:	90                   	nop
801022cb:	90                   	nop
801022cc:	90                   	nop
801022cd:	90                   	nop
801022ce:	90                   	nop
801022cf:	90                   	nop

801022d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	8b 55 08             	mov    0x8(%ebp),%edx
801022d6:	53                   	push   %ebx
801022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022da:	8d 5a 20             	lea    0x20(%edx),%ebx
801022dd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022e1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022ea:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ec:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022f5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022f8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022fa:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102300:	89 42 10             	mov    %eax,0x10(%edx)
}
80102303:	5b                   	pop    %ebx
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
80102306:	66 90                	xchg   %ax,%ax
80102308:	66 90                	xchg   %ax,%ax
8010230a:	66 90                	xchg   %ax,%ax
8010230c:	66 90                	xchg   %ax,%ax
8010230e:	66 90                	xchg   %ax,%ax

80102310 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 14             	sub    $0x14,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 7c                	jne    8010239e <kfree+0x8e>
80102322:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
80102328:	72 74                	jb     8010239e <kfree+0x8e>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 67                	ja     8010239e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102337:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010233e:	00 
8010233f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102346:	00 
80102347:	89 1c 24             	mov    %ebx,(%esp)
8010234a:	e8 51 1f 00 00       	call   801042a0 <memset>

  if(kmem.use_lock)
8010234f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102355:	85 d2                	test   %edx,%edx
80102357:	75 37                	jne    80102390 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102359:	a1 78 26 11 80       	mov    0x80112678,%eax
8010235e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102360:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102365:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010236b:	85 c0                	test   %eax,%eax
8010236d:	75 09                	jne    80102378 <kfree+0x68>
    release(&kmem.lock);
}
8010236f:	83 c4 14             	add    $0x14,%esp
80102372:	5b                   	pop    %ebx
80102373:	5d                   	pop    %ebp
80102374:	c3                   	ret    
80102375:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102378:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010237f:	83 c4 14             	add    $0x14,%esp
80102382:	5b                   	pop    %ebx
80102383:	5d                   	pop    %ebp
    release(&kmem.lock);
80102384:	e9 c7 1e 00 00       	jmp    80104250 <release>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102390:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102397:	e8 c4 1d 00 00       	call   80104160 <acquire>
8010239c:	eb bb                	jmp    80102359 <kfree+0x49>
    panic("kfree");
8010239e:	c7 04 24 86 70 10 80 	movl   $0x80107086,(%esp)
801023a5:	e8 b6 df ff ff       	call   80100360 <panic>
801023aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023b0 <freerange>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
801023b5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801023b8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023be:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023c4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ca:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023d0:	39 de                	cmp    %ebx,%esi
801023d2:	73 08                	jae    801023dc <freerange+0x2c>
801023d4:	eb 18                	jmp    801023ee <freerange+0x3e>
801023d6:	66 90                	xchg   %ax,%ax
801023d8:	89 da                	mov    %ebx,%edx
801023da:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023dc:	89 14 24             	mov    %edx,(%esp)
801023df:	e8 2c ff ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ea:	39 f0                	cmp    %esi,%eax
801023ec:	76 ea                	jbe    801023d8 <freerange+0x28>
}
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	5b                   	pop    %ebx
801023f2:	5e                   	pop    %esi
801023f3:	5d                   	pop    %ebp
801023f4:	c3                   	ret    
801023f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102400 <kinit1>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	83 ec 10             	sub    $0x10,%esp
80102408:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010240b:	c7 44 24 04 8c 70 10 	movl   $0x8010708c,0x4(%esp)
80102412:	80 
80102413:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010241a:	e8 51 1c 00 00       	call   80104070 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010241f:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102422:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102429:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010242c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102432:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102438:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010243e:	39 de                	cmp    %ebx,%esi
80102440:	73 0a                	jae    8010244c <kinit1+0x4c>
80102442:	eb 1a                	jmp    8010245e <kinit1+0x5e>
80102444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102448:	89 da                	mov    %ebx,%edx
8010244a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010244c:	89 14 24             	mov    %edx,(%esp)
8010244f:	e8 bc fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102454:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010245a:	39 c6                	cmp    %eax,%esi
8010245c:	73 ea                	jae    80102448 <kinit1+0x48>
}
8010245e:	83 c4 10             	add    $0x10,%esp
80102461:	5b                   	pop    %ebx
80102462:	5e                   	pop    %esi
80102463:	5d                   	pop    %ebp
80102464:	c3                   	ret    
80102465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
80102475:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102478:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010247b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010247e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102484:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010248a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102490:	39 de                	cmp    %ebx,%esi
80102492:	73 08                	jae    8010249c <kinit2+0x2c>
80102494:	eb 18                	jmp    801024ae <kinit2+0x3e>
80102496:	66 90                	xchg   %ax,%ax
80102498:	89 da                	mov    %ebx,%edx
8010249a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010249c:	89 14 24             	mov    %edx,(%esp)
8010249f:	e8 6c fe ff ff       	call   80102310 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024aa:	39 c6                	cmp    %eax,%esi
801024ac:	73 ea                	jae    80102498 <kinit2+0x28>
  kmem.use_lock = 1;
801024ae:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024b5:	00 00 00 
}
801024b8:	83 c4 10             	add    $0x10,%esp
801024bb:	5b                   	pop    %ebx
801024bc:	5e                   	pop    %esi
801024bd:	5d                   	pop    %ebp
801024be:	c3                   	ret    
801024bf:	90                   	nop

801024c0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024c7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024cc:	85 c0                	test   %eax,%eax
801024ce:	75 30                	jne    80102500 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024d0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024d6:	85 db                	test   %ebx,%ebx
801024d8:	74 08                	je     801024e2 <kalloc+0x22>
    kmem.freelist = r->next;
801024da:	8b 13                	mov    (%ebx),%edx
801024dc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024e2:	85 c0                	test   %eax,%eax
801024e4:	74 0c                	je     801024f2 <kalloc+0x32>
    release(&kmem.lock);
801024e6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024ed:	e8 5e 1d 00 00       	call   80104250 <release>
  return (char*)r;
}
801024f2:	83 c4 14             	add    $0x14,%esp
801024f5:	89 d8                	mov    %ebx,%eax
801024f7:	5b                   	pop    %ebx
801024f8:	5d                   	pop    %ebp
801024f9:	c3                   	ret    
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102500:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102507:	e8 54 1c 00 00       	call   80104160 <acquire>
8010250c:	a1 74 26 11 80       	mov    0x80112674,%eax
80102511:	eb bd                	jmp    801024d0 <kalloc+0x10>
80102513:	66 90                	xchg   %ax,%ax
80102515:	66 90                	xchg   %ax,%ax
80102517:	66 90                	xchg   %ax,%ax
80102519:	66 90                	xchg   %ax,%ax
8010251b:	66 90                	xchg   %ax,%ax
8010251d:	66 90                	xchg   %ax,%ax
8010251f:	90                   	nop

80102520 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102520:	ba 64 00 00 00       	mov    $0x64,%edx
80102525:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102526:	a8 01                	test   $0x1,%al
80102528:	0f 84 ba 00 00 00    	je     801025e8 <kbdgetc+0xc8>
8010252e:	b2 60                	mov    $0x60,%dl
80102530:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102531:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102534:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010253a:	0f 84 88 00 00 00    	je     801025c8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102540:	84 c0                	test   %al,%al
80102542:	79 2c                	jns    80102570 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102544:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010254a:	f6 c2 40             	test   $0x40,%dl
8010254d:	75 05                	jne    80102554 <kbdgetc+0x34>
8010254f:	89 c1                	mov    %eax,%ecx
80102551:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102554:	0f b6 81 c0 71 10 80 	movzbl -0x7fef8e40(%ecx),%eax
8010255b:	83 c8 40             	or     $0x40,%eax
8010255e:	0f b6 c0             	movzbl %al,%eax
80102561:	f7 d0                	not    %eax
80102563:	21 d0                	and    %edx,%eax
80102565:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010256a:	31 c0                	xor    %eax,%eax
8010256c:	c3                   	ret    
8010256d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	53                   	push   %ebx
80102574:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010257a:	f6 c3 40             	test   $0x40,%bl
8010257d:	74 09                	je     80102588 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010257f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102582:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102585:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102588:	0f b6 91 c0 71 10 80 	movzbl -0x7fef8e40(%ecx),%edx
  shift ^= togglecode[data];
8010258f:	0f b6 81 c0 70 10 80 	movzbl -0x7fef8f40(%ecx),%eax
  shift |= shiftcode[data];
80102596:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102598:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010259a:	89 d0                	mov    %edx,%eax
8010259c:	83 e0 03             	and    $0x3,%eax
8010259f:	8b 04 85 a0 70 10 80 	mov    -0x7fef8f60(,%eax,4),%eax
  shift ^= togglecode[data];
801025a6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
801025ac:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025af:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025b3:	74 0b                	je     801025c0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025b5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025b8:	83 fa 19             	cmp    $0x19,%edx
801025bb:	77 1b                	ja     801025d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025bd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025c0:	5b                   	pop    %ebx
801025c1:	5d                   	pop    %ebp
801025c2:	c3                   	ret    
801025c3:	90                   	nop
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025c8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025cf:	31 c0                	xor    %eax,%eax
801025d1:	c3                   	ret    
801025d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025db:	8d 50 20             	lea    0x20(%eax),%edx
801025de:	83 f9 19             	cmp    $0x19,%ecx
801025e1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025e4:	eb da                	jmp    801025c0 <kbdgetc+0xa0>
801025e6:	66 90                	xchg   %ax,%ax
    return -1;
801025e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025ed:	c3                   	ret    
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <kbdintr>:

void
kbdintr(void)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025f6:	c7 04 24 20 25 10 80 	movl   $0x80102520,(%esp)
801025fd:	e8 ae e1 ff ff       	call   801007b0 <consoleintr>
}
80102602:	c9                   	leave  
80102603:	c3                   	ret    
80102604:	66 90                	xchg   %ax,%ax
80102606:	66 90                	xchg   %ax,%ax
80102608:	66 90                	xchg   %ax,%ax
8010260a:	66 90                	xchg   %ax,%ax
8010260c:	66 90                	xchg   %ax,%ax
8010260e:	66 90                	xchg   %ax,%ax

80102610 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102610:	55                   	push   %ebp
80102611:	89 c1                	mov    %eax,%ecx
80102613:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102615:	ba 70 00 00 00       	mov    $0x70,%edx
8010261a:	53                   	push   %ebx
8010261b:	31 c0                	xor    %eax,%eax
8010261d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010261e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102623:	89 da                	mov    %ebx,%edx
80102625:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102626:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102629:	b2 70                	mov    $0x70,%dl
8010262b:	89 01                	mov    %eax,(%ecx)
8010262d:	b8 02 00 00 00       	mov    $0x2,%eax
80102632:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102633:	89 da                	mov    %ebx,%edx
80102635:	ec                   	in     (%dx),%al
80102636:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102639:	b2 70                	mov    $0x70,%dl
8010263b:	89 41 04             	mov    %eax,0x4(%ecx)
8010263e:	b8 04 00 00 00       	mov    $0x4,%eax
80102643:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102644:	89 da                	mov    %ebx,%edx
80102646:	ec                   	in     (%dx),%al
80102647:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264a:	b2 70                	mov    $0x70,%dl
8010264c:	89 41 08             	mov    %eax,0x8(%ecx)
8010264f:	b8 07 00 00 00       	mov    $0x7,%eax
80102654:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102655:	89 da                	mov    %ebx,%edx
80102657:	ec                   	in     (%dx),%al
80102658:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265b:	b2 70                	mov    $0x70,%dl
8010265d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102660:	b8 08 00 00 00       	mov    $0x8,%eax
80102665:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102666:	89 da                	mov    %ebx,%edx
80102668:	ec                   	in     (%dx),%al
80102669:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010266c:	b2 70                	mov    $0x70,%dl
8010266e:	89 41 10             	mov    %eax,0x10(%ecx)
80102671:	b8 09 00 00 00       	mov    $0x9,%eax
80102676:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102677:	89 da                	mov    %ebx,%edx
80102679:	ec                   	in     (%dx),%al
8010267a:	0f b6 d8             	movzbl %al,%ebx
8010267d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102680:	5b                   	pop    %ebx
80102681:	5d                   	pop    %ebp
80102682:	c3                   	ret    
80102683:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102690 <lapicinit>:
  if(!lapic)
80102690:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102695:	55                   	push   %ebp
80102696:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102698:	85 c0                	test   %eax,%eax
8010269a:	0f 84 c0 00 00 00    	je     80102760 <lapicinit+0xd0>
  lapic[index] = value;
801026a0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026a7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ad:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ba:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026c1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ce:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026db:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026eb:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ee:	8b 50 30             	mov    0x30(%eax),%edx
801026f1:	c1 ea 10             	shr    $0x10,%edx
801026f4:	80 fa 03             	cmp    $0x3,%dl
801026f7:	77 6f                	ja     80102768 <lapicinit+0xd8>
  lapic[index] = value;
801026f9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102700:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102703:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102706:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102710:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102713:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010271a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102720:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102727:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010272d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102734:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102737:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102741:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102744:	8b 50 20             	mov    0x20(%eax),%edx
80102747:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102748:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010274e:	80 e6 10             	and    $0x10,%dh
80102751:	75 f5                	jne    80102748 <lapicinit+0xb8>
  lapic[index] = value;
80102753:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010275a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010275d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102760:	5d                   	pop    %ebp
80102761:	c3                   	ret    
80102762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102768:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010276f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102772:	8b 50 20             	mov    0x20(%eax),%edx
80102775:	eb 82                	jmp    801026f9 <lapicinit+0x69>
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicid>:
  if (!lapic)
80102780:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0c                	je     80102798 <lapicid+0x18>
  return lapic[ID] >> 24;
8010278c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010278f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102790:	c1 e8 18             	shr    $0x18,%eax
}
80102793:	c3                   	ret    
80102794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102798:	31 c0                	xor    %eax,%eax
}
8010279a:	5d                   	pop    %ebp
8010279b:	c3                   	ret    
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <lapiceoi>:
  if(lapic)
801027a0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027a5:	55                   	push   %ebp
801027a6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027a8:	85 c0                	test   %eax,%eax
801027aa:	74 0d                	je     801027b9 <lapiceoi+0x19>
  lapic[index] = value;
801027ac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027b3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret    
801027bb:	90                   	nop
801027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027c0 <microdelay>:
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
}
801027c3:	5d                   	pop    %ebp
801027c4:	c3                   	ret    
801027c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <lapicstartap>:
{
801027d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d1:	ba 70 00 00 00       	mov    $0x70,%edx
801027d6:	89 e5                	mov    %esp,%ebp
801027d8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027dd:	53                   	push   %ebx
801027de:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027e4:	ee                   	out    %al,(%dx)
801027e5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ea:	b2 71                	mov    $0x71,%dl
801027ec:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027ed:	31 c0                	xor    %eax,%eax
801027ef:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027f5:	89 d8                	mov    %ebx,%eax
801027f7:	c1 e8 04             	shr    $0x4,%eax
801027fa:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102800:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
80102805:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102808:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
8010280b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102814:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010281b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102828:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102837:	89 da                	mov    %ebx,%edx
80102839:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010283c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102842:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102845:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010284e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102854:	8b 40 20             	mov    0x20(%eax),%eax
}
80102857:	5b                   	pop    %ebx
80102858:	5d                   	pop    %ebp
80102859:	c3                   	ret    
8010285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102860 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102860:	55                   	push   %ebp
80102861:	ba 70 00 00 00       	mov    $0x70,%edx
80102866:	89 e5                	mov    %esp,%ebp
80102868:	b8 0b 00 00 00       	mov    $0xb,%eax
8010286d:	57                   	push   %edi
8010286e:	56                   	push   %esi
8010286f:	53                   	push   %ebx
80102870:	83 ec 4c             	sub    $0x4c,%esp
80102873:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102874:	b2 71                	mov    $0x71,%dl
80102876:	ec                   	in     (%dx),%al
80102877:	88 45 b7             	mov    %al,-0x49(%ebp)
8010287a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010287d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102881:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102888:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010288d:	89 d8                	mov    %ebx,%eax
8010288f:	e8 7c fd ff ff       	call   80102610 <fill_rtcdate>
80102894:	b8 0a 00 00 00       	mov    $0xa,%eax
80102899:	89 f2                	mov    %esi,%edx
8010289b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289c:	ba 71 00 00 00       	mov    $0x71,%edx
801028a1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028a2:	84 c0                	test   %al,%al
801028a4:	78 e7                	js     8010288d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028a6:	89 f8                	mov    %edi,%eax
801028a8:	e8 63 fd ff ff       	call   80102610 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028ad:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028b4:	00 
801028b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028b9:	89 1c 24             	mov    %ebx,(%esp)
801028bc:	e8 2f 1a 00 00       	call   801042f0 <memcmp>
801028c1:	85 c0                	test   %eax,%eax
801028c3:	75 c3                	jne    80102888 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028c5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028c9:	75 78                	jne    80102943 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ce:	89 c2                	mov    %eax,%edx
801028d0:	83 e0 0f             	and    $0xf,%eax
801028d3:	c1 ea 04             	shr    $0x4,%edx
801028d6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028d9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028dc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028df:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028e2:	89 c2                	mov    %eax,%edx
801028e4:	83 e0 0f             	and    $0xf,%eax
801028e7:	c1 ea 04             	shr    $0x4,%edx
801028ea:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028ed:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028f3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028f6:	89 c2                	mov    %eax,%edx
801028f8:	83 e0 0f             	and    $0xf,%eax
801028fb:	c1 ea 04             	shr    $0x4,%edx
801028fe:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102901:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102904:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102907:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010290a:	89 c2                	mov    %eax,%edx
8010290c:	83 e0 0f             	and    $0xf,%eax
8010290f:	c1 ea 04             	shr    $0x4,%edx
80102912:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102915:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102918:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010291b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010291e:	89 c2                	mov    %eax,%edx
80102920:	83 e0 0f             	and    $0xf,%eax
80102923:	c1 ea 04             	shr    $0x4,%edx
80102926:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102929:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010292f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102932:	89 c2                	mov    %eax,%edx
80102934:	83 e0 0f             	and    $0xf,%eax
80102937:	c1 ea 04             	shr    $0x4,%edx
8010293a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010293d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102940:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102943:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102946:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102949:	89 01                	mov    %eax,(%ecx)
8010294b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010294e:	89 41 04             	mov    %eax,0x4(%ecx)
80102951:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102954:	89 41 08             	mov    %eax,0x8(%ecx)
80102957:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010295a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010295d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102960:	89 41 10             	mov    %eax,0x10(%ecx)
80102963:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102966:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102969:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102970:	83 c4 4c             	add    $0x4c,%esp
80102973:	5b                   	pop    %ebx
80102974:	5e                   	pop    %esi
80102975:	5f                   	pop    %edi
80102976:	5d                   	pop    %ebp
80102977:	c3                   	ret    
80102978:	66 90                	xchg   %ax,%ax
8010297a:	66 90                	xchg   %ax,%ax
8010297c:	66 90                	xchg   %ax,%ax
8010297e:	66 90                	xchg   %ax,%ax

80102980 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	57                   	push   %edi
80102984:	56                   	push   %esi
80102985:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102986:	31 db                	xor    %ebx,%ebx
{
80102988:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010298b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102990:	85 c0                	test   %eax,%eax
80102992:	7e 78                	jle    80102a0c <install_trans+0x8c>
80102994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102998:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010299d:	01 d8                	add    %ebx,%eax
8010299f:	83 c0 01             	add    $0x1,%eax
801029a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a6:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029ab:	89 04 24             	mov    %eax,(%esp)
801029ae:	e8 1d d7 ff ff       	call   801000d0 <bread>
801029b3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029b5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029bc:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029c8:	89 04 24             	mov    %eax,(%esp)
801029cb:	e8 00 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029d0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029d7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029d8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029da:	8d 47 5c             	lea    0x5c(%edi),%eax
801029dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029e4:	89 04 24             	mov    %eax,(%esp)
801029e7:	e8 54 19 00 00       	call   80104340 <memmove>
    bwrite(dbuf);  // write dst to disk
801029ec:	89 34 24             	mov    %esi,(%esp)
801029ef:	e8 ac d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029f4:	89 3c 24             	mov    %edi,(%esp)
801029f7:	e8 e4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029fc:	89 34 24             	mov    %esi,(%esp)
801029ff:	e8 dc d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a04:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a0a:	7f 8c                	jg     80102998 <install_trans+0x18>
  }
}
80102a0c:	83 c4 1c             	add    $0x1c,%esp
80102a0f:	5b                   	pop    %ebx
80102a10:	5e                   	pop    %esi
80102a11:	5f                   	pop    %edi
80102a12:	5d                   	pop    %ebp
80102a13:	c3                   	ret    
80102a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	57                   	push   %edi
80102a24:	56                   	push   %esi
80102a25:	53                   	push   %ebx
80102a26:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a29:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a32:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a37:	89 04 24             	mov    %eax,(%esp)
80102a3a:	e8 91 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a3f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a45:	31 d2                	xor    %edx,%edx
80102a47:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a49:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a4b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a4e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a51:	7e 17                	jle    80102a6a <write_head+0x4a>
80102a53:	90                   	nop
80102a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a58:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a5f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a63:	83 c2 01             	add    $0x1,%edx
80102a66:	39 da                	cmp    %ebx,%edx
80102a68:	75 ee                	jne    80102a58 <write_head+0x38>
  }
  bwrite(buf);
80102a6a:	89 3c 24             	mov    %edi,(%esp)
80102a6d:	e8 2e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a72:	89 3c 24             	mov    %edi,(%esp)
80102a75:	e8 66 d7 ff ff       	call   801001e0 <brelse>
}
80102a7a:	83 c4 1c             	add    $0x1c,%esp
80102a7d:	5b                   	pop    %ebx
80102a7e:	5e                   	pop    %esi
80102a7f:	5f                   	pop    %edi
80102a80:	5d                   	pop    %ebp
80102a81:	c3                   	ret    
80102a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a90 <initlog>:
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	56                   	push   %esi
80102a94:	53                   	push   %ebx
80102a95:	83 ec 30             	sub    $0x30,%esp
80102a98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a9b:	c7 44 24 04 c0 72 10 	movl   $0x801072c0,0x4(%esp)
80102aa2:	80 
80102aa3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102aaa:	e8 c1 15 00 00       	call   80104070 <initlock>
  readsb(dev, &sb);
80102aaf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ab6:	89 1c 24             	mov    %ebx,(%esp)
80102ab9:	e8 f2 e8 ff ff       	call   801013b0 <readsb>
  log.start = sb.logstart;
80102abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ac1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102ac4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102ac7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102ad1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ad7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102adc:	e8 ef d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ae1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102ae3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ae6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ae9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102aeb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102af1:	7e 17                	jle    80102b0a <initlog+0x7a>
80102af3:	90                   	nop
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102af8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102afc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102b03:	83 c2 01             	add    $0x1,%edx
80102b06:	39 da                	cmp    %ebx,%edx
80102b08:	75 ee                	jne    80102af8 <initlog+0x68>
  brelse(buf);
80102b0a:	89 04 24             	mov    %eax,(%esp)
80102b0d:	e8 ce d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b12:	e8 69 fe ff ff       	call   80102980 <install_trans>
  log.lh.n = 0;
80102b17:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b1e:	00 00 00 
  write_head(); // clear the log
80102b21:	e8 fa fe ff ff       	call   80102a20 <write_head>
}
80102b26:	83 c4 30             	add    $0x30,%esp
80102b29:	5b                   	pop    %ebx
80102b2a:	5e                   	pop    %esi
80102b2b:	5d                   	pop    %ebp
80102b2c:	c3                   	ret    
80102b2d:	8d 76 00             	lea    0x0(%esi),%esi

80102b30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b36:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b3d:	e8 1e 16 00 00       	call   80104160 <acquire>
80102b42:	eb 18                	jmp    80102b5c <begin_op+0x2c>
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b48:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b4f:	80 
80102b50:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b57:	e8 c4 10 00 00       	call   80103c20 <sleep>
    if(log.committing){
80102b5c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b61:	85 c0                	test   %eax,%eax
80102b63:	75 e3                	jne    80102b48 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b65:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b6a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b70:	83 c0 01             	add    $0x1,%eax
80102b73:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b76:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b79:	83 fa 1e             	cmp    $0x1e,%edx
80102b7c:	7f ca                	jg     80102b48 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b7e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b85:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b8a:	e8 c1 16 00 00       	call   80104250 <release>
      break;
    }
  }
}
80102b8f:	c9                   	leave  
80102b90:	c3                   	ret    
80102b91:	eb 0d                	jmp    80102ba0 <end_op>
80102b93:	90                   	nop
80102b94:	90                   	nop
80102b95:	90                   	nop
80102b96:	90                   	nop
80102b97:	90                   	nop
80102b98:	90                   	nop
80102b99:	90                   	nop
80102b9a:	90                   	nop
80102b9b:	90                   	nop
80102b9c:	90                   	nop
80102b9d:	90                   	nop
80102b9e:	90                   	nop
80102b9f:	90                   	nop

80102ba0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	57                   	push   %edi
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ba9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bb0:	e8 ab 15 00 00       	call   80104160 <acquire>
  log.outstanding -= 1;
80102bb5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bba:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102bc0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bc3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102bc5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bca:	0f 85 f3 00 00 00    	jne    80102cc3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bd0:	85 c0                	test   %eax,%eax
80102bd2:	0f 85 cb 00 00 00    	jne    80102ca3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bd8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bdf:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102be1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102be8:	00 00 00 
  release(&log.lock);
80102beb:	e8 60 16 00 00       	call   80104250 <release>
  if (log.lh.n > 0) {
80102bf0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bf5:	85 c0                	test   %eax,%eax
80102bf7:	0f 8e 90 00 00 00    	jle    80102c8d <end_op+0xed>
80102bfd:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c00:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c05:	01 d8                	add    %ebx,%eax
80102c07:	83 c0 01             	add    $0x1,%eax
80102c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c0e:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c13:	89 04 24             	mov    %eax,(%esp)
80102c16:	e8 b5 d4 ff ff       	call   801000d0 <bread>
80102c1b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c1d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c24:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c2b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c30:	89 04 24             	mov    %eax,(%esp)
80102c33:	e8 98 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c38:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c3f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c40:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c42:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c45:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c49:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c4c:	89 04 24             	mov    %eax,(%esp)
80102c4f:	e8 ec 16 00 00       	call   80104340 <memmove>
    bwrite(to);  // write the log
80102c54:	89 34 24             	mov    %esi,(%esp)
80102c57:	e8 44 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c5c:	89 3c 24             	mov    %edi,(%esp)
80102c5f:	e8 7c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c64:	89 34 24             	mov    %esi,(%esp)
80102c67:	e8 74 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c6c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c72:	7c 8c                	jl     80102c00 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c74:	e8 a7 fd ff ff       	call   80102a20 <write_head>
    install_trans(); // Now install writes to home locations
80102c79:	e8 02 fd ff ff       	call   80102980 <install_trans>
    log.lh.n = 0;
80102c7e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c85:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c88:	e8 93 fd ff ff       	call   80102a20 <write_head>
    acquire(&log.lock);
80102c8d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c94:	e8 c7 14 00 00       	call   80104160 <acquire>
    log.committing = 0;
80102c99:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102ca0:	00 00 00 
    wakeup(&log);
80102ca3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102caa:	e8 01 11 00 00       	call   80103db0 <wakeup>
    release(&log.lock);
80102caf:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cb6:	e8 95 15 00 00       	call   80104250 <release>
}
80102cbb:	83 c4 1c             	add    $0x1c,%esp
80102cbe:	5b                   	pop    %ebx
80102cbf:	5e                   	pop    %esi
80102cc0:	5f                   	pop    %edi
80102cc1:	5d                   	pop    %ebp
80102cc2:	c3                   	ret    
    panic("log.committing");
80102cc3:	c7 04 24 c4 72 10 80 	movl   $0x801072c4,(%esp)
80102cca:	e8 91 d6 ff ff       	call   80100360 <panic>
80102ccf:	90                   	nop

80102cd0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cd7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102cdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cdf:	83 f8 1d             	cmp    $0x1d,%eax
80102ce2:	0f 8f 98 00 00 00    	jg     80102d80 <log_write+0xb0>
80102ce8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cee:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cf1:	39 d0                	cmp    %edx,%eax
80102cf3:	0f 8d 87 00 00 00    	jge    80102d80 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cf9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cfe:	85 c0                	test   %eax,%eax
80102d00:	0f 8e 86 00 00 00    	jle    80102d8c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d06:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d0d:	e8 4e 14 00 00       	call   80104160 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d12:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d18:	83 fa 00             	cmp    $0x0,%edx
80102d1b:	7e 54                	jle    80102d71 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d1d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d20:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d22:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d28:	75 0f                	jne    80102d39 <log_write+0x69>
80102d2a:	eb 3c                	jmp    80102d68 <log_write+0x98>
80102d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d30:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d37:	74 2f                	je     80102d68 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d39:	83 c0 01             	add    $0x1,%eax
80102d3c:	39 d0                	cmp    %edx,%eax
80102d3e:	75 f0                	jne    80102d30 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d40:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d47:	83 c2 01             	add    $0x1,%edx
80102d4a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d50:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d53:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d5a:	83 c4 14             	add    $0x14,%esp
80102d5d:	5b                   	pop    %ebx
80102d5e:	5d                   	pop    %ebp
  release(&log.lock);
80102d5f:	e9 ec 14 00 00       	jmp    80104250 <release>
80102d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d68:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d6f:	eb df                	jmp    80102d50 <log_write+0x80>
80102d71:	8b 43 08             	mov    0x8(%ebx),%eax
80102d74:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d79:	75 d5                	jne    80102d50 <log_write+0x80>
80102d7b:	eb ca                	jmp    80102d47 <log_write+0x77>
80102d7d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d80:	c7 04 24 d3 72 10 80 	movl   $0x801072d3,(%esp)
80102d87:	e8 d4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d8c:	c7 04 24 e9 72 10 80 	movl   $0x801072e9,(%esp)
80102d93:	e8 c8 d5 ff ff       	call   80100360 <panic>
80102d98:	66 90                	xchg   %ax,%ax
80102d9a:	66 90                	xchg   %ax,%ax
80102d9c:	66 90                	xchg   %ax,%ax
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102da0:	55                   	push   %ebp
80102da1:	89 e5                	mov    %esp,%ebp
80102da3:	53                   	push   %ebx
80102da4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102da7:	e8 f4 08 00 00       	call   801036a0 <cpuid>
80102dac:	89 c3                	mov    %eax,%ebx
80102dae:	e8 ed 08 00 00       	call   801036a0 <cpuid>
80102db3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102db7:	c7 04 24 04 73 10 80 	movl   $0x80107304,(%esp)
80102dbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102dc2:	e8 89 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102dc7:	e8 f4 26 00 00       	call   801054c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dcc:	e8 4f 08 00 00       	call   80103620 <mycpu>
80102dd1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dd3:	b8 01 00 00 00       	mov    $0x1,%eax
80102dd8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102ddf:	e8 9c 0b 00 00       	call   80103980 <scheduler>
80102de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102df0 <mpenter>:
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102df6:	e8 f5 37 00 00       	call   801065f0 <switchkvm>
  seginit();
80102dfb:	e8 b0 36 00 00       	call   801064b0 <seginit>
  lapicinit();
80102e00:	e8 8b f8 ff ff       	call   80102690 <lapicinit>
  mpmain();
80102e05:	e8 96 ff ff ff       	call   80102da0 <mpmain>
80102e0a:	66 90                	xchg   %ax,%ax
80102e0c:	66 90                	xchg   %ax,%ax
80102e0e:	66 90                	xchg   %ax,%ax

80102e10 <main>:
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e14:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102e19:	83 e4 f0             	and    $0xfffffff0,%esp
80102e1c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e1f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e26:	80 
80102e27:	c7 04 24 f4 58 11 80 	movl   $0x801158f4,(%esp)
80102e2e:	e8 cd f5 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80102e33:	e8 68 3c 00 00       	call   80106aa0 <kvmalloc>
  mpinit();        // detect other processors
80102e38:	e8 73 01 00 00       	call   80102fb0 <mpinit>
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e40:	e8 4b f8 ff ff       	call   80102690 <lapicinit>
  seginit();       // segment descriptors
80102e45:	e8 66 36 00 00       	call   801064b0 <seginit>
  picinit();       // disable pic
80102e4a:	e8 21 03 00 00       	call   80103170 <picinit>
80102e4f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e50:	e8 cb f3 ff ff       	call   80102220 <ioapicinit>
  consoleinit();   // console hardware
80102e55:	e8 f6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e5a:	e8 f1 29 00 00       	call   80105850 <uartinit>
80102e5f:	90                   	nop
  pinit();         // process table
80102e60:	e8 9b 07 00 00       	call   80103600 <pinit>
  shminit();       // shared memory
80102e65:	e8 26 3f 00 00       	call   80106d90 <shminit>
  tvinit();        // trap vectors
80102e6a:	e8 b1 25 00 00       	call   80105420 <tvinit>
80102e6f:	90                   	nop
  binit();         // buffer cache
80102e70:	e8 cb d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e75:	e8 e6 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102e7a:	e8 a1 f1 ff ff       	call   80102020 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e7f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e86:	00 
80102e87:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e8e:	80 
80102e8f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e96:	e8 a5 14 00 00       	call   80104340 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e9b:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ea2:	00 00 00 
80102ea5:	05 80 27 11 80       	add    $0x80112780,%eax
80102eaa:	39 d8                	cmp    %ebx,%eax
80102eac:	76 65                	jbe    80102f13 <main+0x103>
80102eae:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102eb0:	e8 6b 07 00 00       	call   80103620 <mycpu>
80102eb5:	39 d8                	cmp    %ebx,%eax
80102eb7:	74 41                	je     80102efa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102eb9:	e8 02 f6 ff ff       	call   801024c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102ebe:	c7 05 f8 6f 00 80 f0 	movl   $0x80102df0,0x80006ff8
80102ec5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ec8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ecf:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ed2:	05 00 10 00 00       	add    $0x1000,%eax
80102ed7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102edc:	0f b6 03             	movzbl (%ebx),%eax
80102edf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ee6:	00 
80102ee7:	89 04 24             	mov    %eax,(%esp)
80102eea:	e8 e1 f8 ff ff       	call   801027d0 <lapicstartap>
80102eef:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ef0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ef6:	85 c0                	test   %eax,%eax
80102ef8:	74 f6                	je     80102ef0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102efa:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f01:	00 00 00 
80102f04:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f0a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f0f:	39 c3                	cmp    %eax,%ebx
80102f11:	72 9d                	jb     80102eb0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f13:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f1a:	8e 
80102f1b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f22:	e8 49 f5 ff ff       	call   80102470 <kinit2>
  userinit();      // first user process
80102f27:	e8 c4 07 00 00       	call   801036f0 <userinit>
  mpmain();        // finish this processor's setup
80102f2c:	e8 6f fe ff ff       	call   80102da0 <mpmain>
80102f31:	66 90                	xchg   %ax,%ax
80102f33:	66 90                	xchg   %ax,%ax
80102f35:	66 90                	xchg   %ax,%ax
80102f37:	66 90                	xchg   %ax,%ax
80102f39:	66 90                	xchg   %ax,%ax
80102f3b:	66 90                	xchg   %ax,%ax
80102f3d:	66 90                	xchg   %ax,%ax
80102f3f:	90                   	nop

80102f40 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f44:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f4a:	53                   	push   %ebx
  e = addr+len;
80102f4b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f4e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f51:	39 de                	cmp    %ebx,%esi
80102f53:	73 3c                	jae    80102f91 <mpsearch1+0x51>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f58:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f5f:	00 
80102f60:	c7 44 24 04 18 73 10 	movl   $0x80107318,0x4(%esp)
80102f67:	80 
80102f68:	89 34 24             	mov    %esi,(%esp)
80102f6b:	e8 80 13 00 00       	call   801042f0 <memcmp>
80102f70:	85 c0                	test   %eax,%eax
80102f72:	75 16                	jne    80102f8a <mpsearch1+0x4a>
80102f74:	31 c9                	xor    %ecx,%ecx
80102f76:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f78:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f7c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f7f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f81:	83 fa 10             	cmp    $0x10,%edx
80102f84:	75 f2                	jne    80102f78 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f86:	84 c9                	test   %cl,%cl
80102f88:	74 10                	je     80102f9a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f8a:	83 c6 10             	add    $0x10,%esi
80102f8d:	39 f3                	cmp    %esi,%ebx
80102f8f:	77 c7                	ja     80102f58 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f91:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f94:	31 c0                	xor    %eax,%eax
}
80102f96:	5b                   	pop    %ebx
80102f97:	5e                   	pop    %esi
80102f98:	5d                   	pop    %ebp
80102f99:	c3                   	ret    
80102f9a:	83 c4 10             	add    $0x10,%esp
80102f9d:	89 f0                	mov    %esi,%eax
80102f9f:	5b                   	pop    %ebx
80102fa0:	5e                   	pop    %esi
80102fa1:	5d                   	pop    %ebp
80102fa2:	c3                   	ret    
80102fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	57                   	push   %edi
80102fb4:	56                   	push   %esi
80102fb5:	53                   	push   %ebx
80102fb6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fb9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fc0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fc7:	c1 e0 08             	shl    $0x8,%eax
80102fca:	09 d0                	or     %edx,%eax
80102fcc:	c1 e0 04             	shl    $0x4,%eax
80102fcf:	85 c0                	test   %eax,%eax
80102fd1:	75 1b                	jne    80102fee <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fd3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fda:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fe1:	c1 e0 08             	shl    $0x8,%eax
80102fe4:	09 d0                	or     %edx,%eax
80102fe6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fe9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102fee:	ba 00 04 00 00       	mov    $0x400,%edx
80102ff3:	e8 48 ff ff ff       	call   80102f40 <mpsearch1>
80102ff8:	85 c0                	test   %eax,%eax
80102ffa:	89 c7                	mov    %eax,%edi
80102ffc:	0f 84 22 01 00 00    	je     80103124 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103002:	8b 77 04             	mov    0x4(%edi),%esi
80103005:	85 f6                	test   %esi,%esi
80103007:	0f 84 30 01 00 00    	je     8010313d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010300d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103013:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010301a:	00 
8010301b:	c7 44 24 04 1d 73 10 	movl   $0x8010731d,0x4(%esp)
80103022:	80 
80103023:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103026:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103029:	e8 c2 12 00 00       	call   801042f0 <memcmp>
8010302e:	85 c0                	test   %eax,%eax
80103030:	0f 85 07 01 00 00    	jne    8010313d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103036:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010303d:	3c 04                	cmp    $0x4,%al
8010303f:	0f 85 0b 01 00 00    	jne    80103150 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103045:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010304c:	85 c0                	test   %eax,%eax
8010304e:	74 21                	je     80103071 <mpinit+0xc1>
  sum = 0;
80103050:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103052:	31 d2                	xor    %edx,%edx
80103054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103058:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010305f:	80 
  for(i=0; i<len; i++)
80103060:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103063:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103065:	39 d0                	cmp    %edx,%eax
80103067:	7f ef                	jg     80103058 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103069:	84 c9                	test   %cl,%cl
8010306b:	0f 85 cc 00 00 00    	jne    8010313d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103074:	85 c0                	test   %eax,%eax
80103076:	0f 84 c1 00 00 00    	je     8010313d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010307c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103082:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103087:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010308c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103093:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103099:	03 55 e4             	add    -0x1c(%ebp),%edx
8010309c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030a0:	39 c2                	cmp    %eax,%edx
801030a2:	76 1b                	jbe    801030bf <mpinit+0x10f>
801030a4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030a7:	80 f9 04             	cmp    $0x4,%cl
801030aa:	77 74                	ja     80103120 <mpinit+0x170>
801030ac:	ff 24 8d 5c 73 10 80 	jmp    *-0x7fef8ca4(,%ecx,4)
801030b3:	90                   	nop
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030b8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030bb:	39 c2                	cmp    %eax,%edx
801030bd:	77 e5                	ja     801030a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030bf:	85 db                	test   %ebx,%ebx
801030c1:	0f 84 93 00 00 00    	je     8010315a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030c7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030cb:	74 12                	je     801030df <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030cd:	ba 22 00 00 00       	mov    $0x22,%edx
801030d2:	b8 70 00 00 00       	mov    $0x70,%eax
801030d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030d8:	b2 23                	mov    $0x23,%dl
801030da:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030db:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030de:	ee                   	out    %al,(%dx)
  }
}
801030df:	83 c4 1c             	add    $0x1c,%esp
801030e2:	5b                   	pop    %ebx
801030e3:	5e                   	pop    %esi
801030e4:	5f                   	pop    %edi
801030e5:	5d                   	pop    %ebp
801030e6:	c3                   	ret    
801030e7:	90                   	nop
      if(ncpu < NCPU) {
801030e8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030ee:	83 fe 07             	cmp    $0x7,%esi
801030f1:	7f 17                	jg     8010310a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030f3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030f7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030fd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103104:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
8010310a:	83 c0 14             	add    $0x14,%eax
      continue;
8010310d:	eb 91                	jmp    801030a0 <mpinit+0xf0>
8010310f:	90                   	nop
      ioapicid = ioapic->apicno;
80103110:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103114:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103117:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
8010311d:	eb 81                	jmp    801030a0 <mpinit+0xf0>
8010311f:	90                   	nop
      ismp = 0;
80103120:	31 db                	xor    %ebx,%ebx
80103122:	eb 83                	jmp    801030a7 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103124:	ba 00 00 01 00       	mov    $0x10000,%edx
80103129:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010312e:	e8 0d fe ff ff       	call   80102f40 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103133:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103135:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103137:	0f 85 c5 fe ff ff    	jne    80103002 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010313d:	c7 04 24 22 73 10 80 	movl   $0x80107322,(%esp)
80103144:	e8 17 d2 ff ff       	call   80100360 <panic>
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103150:	3c 01                	cmp    $0x1,%al
80103152:	0f 84 ed fe ff ff    	je     80103045 <mpinit+0x95>
80103158:	eb e3                	jmp    8010313d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010315a:	c7 04 24 3c 73 10 80 	movl   $0x8010733c,(%esp)
80103161:	e8 fa d1 ff ff       	call   80100360 <panic>
80103166:	66 90                	xchg   %ax,%ax
80103168:	66 90                	xchg   %ax,%ax
8010316a:	66 90                	xchg   %ax,%ax
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103170:	55                   	push   %ebp
80103171:	ba 21 00 00 00       	mov    $0x21,%edx
80103176:	89 e5                	mov    %esp,%ebp
80103178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010317d:	ee                   	out    %al,(%dx)
8010317e:	b2 a1                	mov    $0xa1,%dl
80103180:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103181:	5d                   	pop    %ebp
80103182:	c3                   	ret    
80103183:	66 90                	xchg   %ax,%ax
80103185:	66 90                	xchg   %ax,%ax
80103187:	66 90                	xchg   %ax,%ax
80103189:	66 90                	xchg   %ax,%ax
8010318b:	66 90                	xchg   %ax,%ax
8010318d:	66 90                	xchg   %ax,%ax
8010318f:	90                   	nop

80103190 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
80103195:	53                   	push   %ebx
80103196:	83 ec 1c             	sub    $0x1c,%esp
80103199:	8b 75 08             	mov    0x8(%ebp),%esi
8010319c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010319f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031a5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031ab:	e8 d0 db ff ff       	call   80100d80 <filealloc>
801031b0:	85 c0                	test   %eax,%eax
801031b2:	89 06                	mov    %eax,(%esi)
801031b4:	0f 84 a4 00 00 00    	je     8010325e <pipealloc+0xce>
801031ba:	e8 c1 db ff ff       	call   80100d80 <filealloc>
801031bf:	85 c0                	test   %eax,%eax
801031c1:	89 03                	mov    %eax,(%ebx)
801031c3:	0f 84 87 00 00 00    	je     80103250 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031c9:	e8 f2 f2 ff ff       	call   801024c0 <kalloc>
801031ce:	85 c0                	test   %eax,%eax
801031d0:	89 c7                	mov    %eax,%edi
801031d2:	74 7c                	je     80103250 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031d4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031db:	00 00 00 
  p->writeopen = 1;
801031de:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031e5:	00 00 00 
  p->nwrite = 0;
801031e8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031ef:	00 00 00 
  p->nread = 0;
801031f2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031f9:	00 00 00 
  initlock(&p->lock, "pipe");
801031fc:	89 04 24             	mov    %eax,(%esp)
801031ff:	c7 44 24 04 70 73 10 	movl   $0x80107370,0x4(%esp)
80103206:	80 
80103207:	e8 64 0e 00 00       	call   80104070 <initlock>
  (*f0)->type = FD_PIPE;
8010320c:	8b 06                	mov    (%esi),%eax
8010320e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103214:	8b 06                	mov    (%esi),%eax
80103216:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010321a:	8b 06                	mov    (%esi),%eax
8010321c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103220:	8b 06                	mov    (%esi),%eax
80103222:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103225:	8b 03                	mov    (%ebx),%eax
80103227:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010322d:	8b 03                	mov    (%ebx),%eax
8010322f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103233:	8b 03                	mov    (%ebx),%eax
80103235:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103239:	8b 03                	mov    (%ebx),%eax
  return 0;
8010323b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010323d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103240:	83 c4 1c             	add    $0x1c,%esp
80103243:	89 d8                	mov    %ebx,%eax
80103245:	5b                   	pop    %ebx
80103246:	5e                   	pop    %esi
80103247:	5f                   	pop    %edi
80103248:	5d                   	pop    %ebp
80103249:	c3                   	ret    
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103250:	8b 06                	mov    (%esi),%eax
80103252:	85 c0                	test   %eax,%eax
80103254:	74 08                	je     8010325e <pipealloc+0xce>
    fileclose(*f0);
80103256:	89 04 24             	mov    %eax,(%esp)
80103259:	e8 e2 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010325e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103260:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103265:	85 c0                	test   %eax,%eax
80103267:	74 d7                	je     80103240 <pipealloc+0xb0>
    fileclose(*f1);
80103269:	89 04 24             	mov    %eax,(%esp)
8010326c:	e8 cf db ff ff       	call   80100e40 <fileclose>
}
80103271:	83 c4 1c             	add    $0x1c,%esp
80103274:	89 d8                	mov    %ebx,%eax
80103276:	5b                   	pop    %ebx
80103277:	5e                   	pop    %esi
80103278:	5f                   	pop    %edi
80103279:	5d                   	pop    %ebp
8010327a:	c3                   	ret    
8010327b:	90                   	nop
8010327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103280 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	56                   	push   %esi
80103284:	53                   	push   %ebx
80103285:	83 ec 10             	sub    $0x10,%esp
80103288:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010328b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010328e:	89 1c 24             	mov    %ebx,(%esp)
80103291:	e8 ca 0e 00 00       	call   80104160 <acquire>
  if(writable){
80103296:	85 f6                	test   %esi,%esi
80103298:	74 3e                	je     801032d8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010329a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801032a0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032a7:	00 00 00 
    wakeup(&p->nread);
801032aa:	89 04 24             	mov    %eax,(%esp)
801032ad:	e8 fe 0a 00 00       	call   80103db0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032b2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032b8:	85 d2                	test   %edx,%edx
801032ba:	75 0a                	jne    801032c6 <pipeclose+0x46>
801032bc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 32                	je     801032f8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032c6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032c9:	83 c4 10             	add    $0x10,%esp
801032cc:	5b                   	pop    %ebx
801032cd:	5e                   	pop    %esi
801032ce:	5d                   	pop    %ebp
    release(&p->lock);
801032cf:	e9 7c 0f 00 00       	jmp    80104250 <release>
801032d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032d8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032de:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032e5:	00 00 00 
    wakeup(&p->nwrite);
801032e8:	89 04 24             	mov    %eax,(%esp)
801032eb:	e8 c0 0a 00 00       	call   80103db0 <wakeup>
801032f0:	eb c0                	jmp    801032b2 <pipeclose+0x32>
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032f8:	89 1c 24             	mov    %ebx,(%esp)
801032fb:	e8 50 0f 00 00       	call   80104250 <release>
    kfree((char*)p);
80103300:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103303:	83 c4 10             	add    $0x10,%esp
80103306:	5b                   	pop    %ebx
80103307:	5e                   	pop    %esi
80103308:	5d                   	pop    %ebp
    kfree((char*)p);
80103309:	e9 02 f0 ff ff       	jmp    80102310 <kfree>
8010330e:	66 90                	xchg   %ax,%ax

80103310 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	57                   	push   %edi
80103314:	56                   	push   %esi
80103315:	53                   	push   %ebx
80103316:	83 ec 1c             	sub    $0x1c,%esp
80103319:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010331c:	89 1c 24             	mov    %ebx,(%esp)
8010331f:	e8 3c 0e 00 00       	call   80104160 <acquire>
  for(i = 0; i < n; i++){
80103324:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103327:	85 c9                	test   %ecx,%ecx
80103329:	0f 8e b2 00 00 00    	jle    801033e1 <pipewrite+0xd1>
8010332f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103332:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103338:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010333e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103344:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103347:	03 4d 10             	add    0x10(%ebp),%ecx
8010334a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010334d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103353:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103359:	39 c8                	cmp    %ecx,%eax
8010335b:	74 38                	je     80103395 <pipewrite+0x85>
8010335d:	eb 55                	jmp    801033b4 <pipewrite+0xa4>
8010335f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103360:	e8 5b 03 00 00       	call   801036c0 <myproc>
80103365:	8b 40 24             	mov    0x24(%eax),%eax
80103368:	85 c0                	test   %eax,%eax
8010336a:	75 33                	jne    8010339f <pipewrite+0x8f>
      wakeup(&p->nread);
8010336c:	89 3c 24             	mov    %edi,(%esp)
8010336f:	e8 3c 0a 00 00       	call   80103db0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103374:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103378:	89 34 24             	mov    %esi,(%esp)
8010337b:	e8 a0 08 00 00       	call   80103c20 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103380:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103386:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010338c:	05 00 02 00 00       	add    $0x200,%eax
80103391:	39 c2                	cmp    %eax,%edx
80103393:	75 23                	jne    801033b8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103395:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010339b:	85 d2                	test   %edx,%edx
8010339d:	75 c1                	jne    80103360 <pipewrite+0x50>
        release(&p->lock);
8010339f:	89 1c 24             	mov    %ebx,(%esp)
801033a2:	e8 a9 0e 00 00       	call   80104250 <release>
        return -1;
801033a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033ac:	83 c4 1c             	add    $0x1c,%esp
801033af:	5b                   	pop    %ebx
801033b0:	5e                   	pop    %esi
801033b1:	5f                   	pop    %edi
801033b2:	5d                   	pop    %ebp
801033b3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033b4:	89 c2                	mov    %eax,%edx
801033b6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033b8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033bb:	8d 42 01             	lea    0x1(%edx),%eax
801033be:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033c4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033ca:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033ce:	0f b6 09             	movzbl (%ecx),%ecx
801033d1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033d5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033d8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033db:	0f 85 6c ff ff ff    	jne    8010334d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033e1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033e7:	89 04 24             	mov    %eax,(%esp)
801033ea:	e8 c1 09 00 00       	call   80103db0 <wakeup>
  release(&p->lock);
801033ef:	89 1c 24             	mov    %ebx,(%esp)
801033f2:	e8 59 0e 00 00       	call   80104250 <release>
  return n;
801033f7:	8b 45 10             	mov    0x10(%ebp),%eax
801033fa:	eb b0                	jmp    801033ac <pipewrite+0x9c>
801033fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103400 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 1c             	sub    $0x1c,%esp
80103409:	8b 75 08             	mov    0x8(%ebp),%esi
8010340c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010340f:	89 34 24             	mov    %esi,(%esp)
80103412:	e8 49 0d 00 00       	call   80104160 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103417:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010341d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103423:	75 5b                	jne    80103480 <piperead+0x80>
80103425:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010342b:	85 db                	test   %ebx,%ebx
8010342d:	74 51                	je     80103480 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010342f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103435:	eb 25                	jmp    8010345c <piperead+0x5c>
80103437:	90                   	nop
80103438:	89 74 24 04          	mov    %esi,0x4(%esp)
8010343c:	89 1c 24             	mov    %ebx,(%esp)
8010343f:	e8 dc 07 00 00       	call   80103c20 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103444:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010344a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103450:	75 2e                	jne    80103480 <piperead+0x80>
80103452:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103458:	85 d2                	test   %edx,%edx
8010345a:	74 24                	je     80103480 <piperead+0x80>
    if(myproc()->killed){
8010345c:	e8 5f 02 00 00       	call   801036c0 <myproc>
80103461:	8b 48 24             	mov    0x24(%eax),%ecx
80103464:	85 c9                	test   %ecx,%ecx
80103466:	74 d0                	je     80103438 <piperead+0x38>
      release(&p->lock);
80103468:	89 34 24             	mov    %esi,(%esp)
8010346b:	e8 e0 0d 00 00       	call   80104250 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103470:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103478:	5b                   	pop    %ebx
80103479:	5e                   	pop    %esi
8010347a:	5f                   	pop    %edi
8010347b:	5d                   	pop    %ebp
8010347c:	c3                   	ret    
8010347d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103480:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103483:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103485:	85 d2                	test   %edx,%edx
80103487:	7f 2b                	jg     801034b4 <piperead+0xb4>
80103489:	eb 31                	jmp    801034bc <piperead+0xbc>
8010348b:	90                   	nop
8010348c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103490:	8d 48 01             	lea    0x1(%eax),%ecx
80103493:	25 ff 01 00 00       	and    $0x1ff,%eax
80103498:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010349e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034a3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034a6:	83 c3 01             	add    $0x1,%ebx
801034a9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034ac:	74 0e                	je     801034bc <piperead+0xbc>
    if(p->nread == p->nwrite)
801034ae:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034b4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034ba:	75 d4                	jne    80103490 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034bc:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034c2:	89 04 24             	mov    %eax,(%esp)
801034c5:	e8 e6 08 00 00       	call   80103db0 <wakeup>
  release(&p->lock);
801034ca:	89 34 24             	mov    %esi,(%esp)
801034cd:	e8 7e 0d 00 00       	call   80104250 <release>
}
801034d2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034d5:	89 d8                	mov    %ebx,%eax
}
801034d7:	5b                   	pop    %ebx
801034d8:	5e                   	pop    %esi
801034d9:	5f                   	pop    %edi
801034da:	5d                   	pop    %ebp
801034db:	c3                   	ret    
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034e4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034e9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034ec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034f3:	e8 68 0c 00 00       	call   80104160 <acquire>
801034f8:	eb 11                	jmp    8010350b <allocproc+0x2b>
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103500:	83 eb 80             	sub    $0xffffff80,%ebx
80103503:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103509:	74 7d                	je     80103588 <allocproc+0xa8>
    if(p->state == UNUSED)
8010350b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010350e:	85 c0                	test   %eax,%eax
80103510:	75 ee                	jne    80103500 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103512:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103517:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
8010351e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103525:	8d 50 01             	lea    0x1(%eax),%edx
80103528:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010352e:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103531:	e8 1a 0d 00 00       	call   80104250 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103536:	e8 85 ef ff ff       	call   801024c0 <kalloc>
8010353b:	85 c0                	test   %eax,%eax
8010353d:	89 43 08             	mov    %eax,0x8(%ebx)
80103540:	74 5a                	je     8010359c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103542:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103548:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010354d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103550:	c7 40 14 15 54 10 80 	movl   $0x80105415,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103557:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010355e:	00 
8010355f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103566:	00 
80103567:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010356a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010356d:	e8 2e 0d 00 00       	call   801042a0 <memset>
  p->context->eip = (uint)forkret;
80103572:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103575:	c7 40 10 b0 35 10 80 	movl   $0x801035b0,0x10(%eax)

  return p;
8010357c:	89 d8                	mov    %ebx,%eax
}
8010357e:	83 c4 14             	add    $0x14,%esp
80103581:	5b                   	pop    %ebx
80103582:	5d                   	pop    %ebp
80103583:	c3                   	ret    
80103584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103588:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010358f:	e8 bc 0c 00 00       	call   80104250 <release>
}
80103594:	83 c4 14             	add    $0x14,%esp
  return 0;
80103597:	31 c0                	xor    %eax,%eax
}
80103599:	5b                   	pop    %ebx
8010359a:	5d                   	pop    %ebp
8010359b:	c3                   	ret    
    p->state = UNUSED;
8010359c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035a3:	eb d9                	jmp    8010357e <allocproc+0x9e>
801035a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035b6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035bd:	e8 8e 0c 00 00       	call   80104250 <release>

  if (first) {
801035c2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035c7:	85 c0                	test   %eax,%eax
801035c9:	75 05                	jne    801035d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035cb:	c9                   	leave  
801035cc:	c3                   	ret    
801035cd:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035d7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035de:	00 00 00 
    iinit(ROOTDEV);
801035e1:	e8 aa de ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
801035e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035ed:	e8 9e f4 ff ff       	call   80102a90 <initlog>
}
801035f2:	c9                   	leave  
801035f3:	c3                   	ret    
801035f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103600 <pinit>:
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103606:	c7 44 24 04 75 73 10 	movl   $0x80107375,0x4(%esp)
8010360d:	80 
8010360e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103615:	e8 56 0a 00 00       	call   80104070 <initlock>
}
8010361a:	c9                   	leave  
8010361b:	c3                   	ret    
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103620 <mycpu>:
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	56                   	push   %esi
80103624:	53                   	push   %ebx
80103625:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103628:	9c                   	pushf  
80103629:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010362a:	f6 c4 02             	test   $0x2,%ah
8010362d:	75 57                	jne    80103686 <mycpu+0x66>
  apicid = lapicid();
8010362f:	e8 4c f1 ff ff       	call   80102780 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103634:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010363a:	85 f6                	test   %esi,%esi
8010363c:	7e 3c                	jle    8010367a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010363e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103645:	39 c2                	cmp    %eax,%edx
80103647:	74 2d                	je     80103676 <mycpu+0x56>
80103649:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010364e:	31 d2                	xor    %edx,%edx
80103650:	83 c2 01             	add    $0x1,%edx
80103653:	39 f2                	cmp    %esi,%edx
80103655:	74 23                	je     8010367a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103657:	0f b6 19             	movzbl (%ecx),%ebx
8010365a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103660:	39 c3                	cmp    %eax,%ebx
80103662:	75 ec                	jne    80103650 <mycpu+0x30>
      return &cpus[i];
80103664:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010366a:	83 c4 10             	add    $0x10,%esp
8010366d:	5b                   	pop    %ebx
8010366e:	5e                   	pop    %esi
8010366f:	5d                   	pop    %ebp
      return &cpus[i];
80103670:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103675:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103676:	31 d2                	xor    %edx,%edx
80103678:	eb ea                	jmp    80103664 <mycpu+0x44>
  panic("unknown apicid\n");
8010367a:	c7 04 24 7c 73 10 80 	movl   $0x8010737c,(%esp)
80103681:	e8 da cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103686:	c7 04 24 58 74 10 80 	movl   $0x80107458,(%esp)
8010368d:	e8 ce cc ff ff       	call   80100360 <panic>
80103692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036a0 <cpuid>:
cpuid() {
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036a6:	e8 75 ff ff ff       	call   80103620 <mycpu>
}
801036ab:	c9                   	leave  
  return mycpu()-cpus;
801036ac:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036b1:	c1 f8 04             	sar    $0x4,%eax
801036b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ba:	c3                   	ret    
801036bb:	90                   	nop
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036c0 <myproc>:
myproc(void) {
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036c7:	e8 54 0a 00 00       	call   80104120 <pushcli>
  c = mycpu();
801036cc:	e8 4f ff ff ff       	call   80103620 <mycpu>
  p = c->proc;
801036d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036d7:	e8 04 0b 00 00       	call   801041e0 <popcli>
}
801036dc:	83 c4 04             	add    $0x4,%esp
801036df:	89 d8                	mov    %ebx,%eax
801036e1:	5b                   	pop    %ebx
801036e2:	5d                   	pop    %ebp
801036e3:	c3                   	ret    
801036e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036f0 <userinit>:
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
801036f7:	e8 e4 fd ff ff       	call   801034e0 <allocproc>
801036fc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801036fe:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103703:	e8 08 33 00 00       	call   80106a10 <setupkvm>
80103708:	85 c0                	test   %eax,%eax
8010370a:	89 43 04             	mov    %eax,0x4(%ebx)
8010370d:	0f 84 d4 00 00 00    	je     801037e7 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103713:	89 04 24             	mov    %eax,(%esp)
80103716:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010371d:	00 
8010371e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103725:	80 
80103726:	e8 f5 2f 00 00       	call   80106720 <inituvm>
  p->sz = PGSIZE;
8010372b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103731:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103738:	00 
80103739:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103740:	00 
80103741:	8b 43 18             	mov    0x18(%ebx),%eax
80103744:	89 04 24             	mov    %eax,(%esp)
80103747:	e8 54 0b 00 00       	call   801042a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010374c:	8b 43 18             	mov    0x18(%ebx),%eax
8010374f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103754:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103759:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010375d:	8b 43 18             	mov    0x18(%ebx),%eax
80103760:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103764:	8b 43 18             	mov    0x18(%ebx),%eax
80103767:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010376b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010376f:	8b 43 18             	mov    0x18(%ebx),%eax
80103772:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103776:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010377a:	8b 43 18             	mov    0x18(%ebx),%eax
8010377d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103784:	8b 43 18             	mov    0x18(%ebx),%eax
80103787:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010378e:	8b 43 18             	mov    0x18(%ebx),%eax
80103791:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103798:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010379b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037a2:	00 
801037a3:	c7 44 24 04 a5 73 10 	movl   $0x801073a5,0x4(%esp)
801037aa:	80 
801037ab:	89 04 24             	mov    %eax,(%esp)
801037ae:	e8 cd 0c 00 00       	call   80104480 <safestrcpy>
  p->cwd = namei("/");
801037b3:	c7 04 24 ae 73 10 80 	movl   $0x801073ae,(%esp)
801037ba:	e8 61 e7 ff ff       	call   80101f20 <namei>
801037bf:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037c2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037c9:	e8 92 09 00 00       	call   80104160 <acquire>
  p->state = RUNNABLE;
801037ce:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037d5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037dc:	e8 6f 0a 00 00       	call   80104250 <release>
}
801037e1:	83 c4 14             	add    $0x14,%esp
801037e4:	5b                   	pop    %ebx
801037e5:	5d                   	pop    %ebp
801037e6:	c3                   	ret    
    panic("userinit: out of memory?");
801037e7:	c7 04 24 8c 73 10 80 	movl   $0x8010738c,(%esp)
801037ee:	e8 6d cb ff ff       	call   80100360 <panic>
801037f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <growproc>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	83 ec 10             	sub    $0x10,%esp
80103808:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010380b:	e8 b0 fe ff ff       	call   801036c0 <myproc>
  if(n > 0){
80103810:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103813:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103815:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103817:	7e 2f                	jle    80103848 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103819:	01 c6                	add    %eax,%esi
8010381b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010381f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103823:	8b 43 04             	mov    0x4(%ebx),%eax
80103826:	89 04 24             	mov    %eax,(%esp)
80103829:	e8 42 30 00 00       	call   80106870 <allocuvm>
8010382e:	85 c0                	test   %eax,%eax
80103830:	74 36                	je     80103868 <growproc+0x68>
  curproc->sz = sz;
80103832:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103834:	89 1c 24             	mov    %ebx,(%esp)
80103837:	e8 d4 2d 00 00       	call   80106610 <switchuvm>
  return 0;
8010383c:	31 c0                	xor    %eax,%eax
}
8010383e:	83 c4 10             	add    $0x10,%esp
80103841:	5b                   	pop    %ebx
80103842:	5e                   	pop    %esi
80103843:	5d                   	pop    %ebp
80103844:	c3                   	ret    
80103845:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103848:	74 e8                	je     80103832 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010384a:	01 c6                	add    %eax,%esi
8010384c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103850:	89 44 24 04          	mov    %eax,0x4(%esp)
80103854:	8b 43 04             	mov    0x4(%ebx),%eax
80103857:	89 04 24             	mov    %eax,(%esp)
8010385a:	e8 11 31 00 00       	call   80106970 <deallocuvm>
8010385f:	85 c0                	test   %eax,%eax
80103861:	75 cf                	jne    80103832 <growproc+0x32>
80103863:	90                   	nop
80103864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010386d:	eb cf                	jmp    8010383e <growproc+0x3e>
8010386f:	90                   	nop

80103870 <fork>:
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	57                   	push   %edi
80103874:	56                   	push   %esi
80103875:	53                   	push   %ebx
80103876:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103879:	e8 42 fe ff ff       	call   801036c0 <myproc>
8010387e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103880:	e8 5b fc ff ff       	call   801034e0 <allocproc>
80103885:	85 c0                	test   %eax,%eax
80103887:	89 c7                	mov    %eax,%edi
80103889:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010388c:	0f 84 bc 00 00 00    	je     8010394e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103892:	8b 03                	mov    (%ebx),%eax
80103894:	89 44 24 04          	mov    %eax,0x4(%esp)
80103898:	8b 43 04             	mov    0x4(%ebx),%eax
8010389b:	89 04 24             	mov    %eax,(%esp)
8010389e:	e8 4d 32 00 00       	call   80106af0 <copyuvm>
801038a3:	85 c0                	test   %eax,%eax
801038a5:	89 47 04             	mov    %eax,0x4(%edi)
801038a8:	0f 84 a7 00 00 00    	je     80103955 <fork+0xe5>
  np->sz = curproc->sz;
801038ae:	8b 03                	mov    (%ebx),%eax
801038b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038b3:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801038b5:	8b 79 18             	mov    0x18(%ecx),%edi
801038b8:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
801038ba:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801038bd:	8b 73 18             	mov    0x18(%ebx),%esi
801038c0:	b9 13 00 00 00       	mov    $0x13,%ecx
801038c5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038c7:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801038c9:	8b 40 18             	mov    0x18(%eax),%eax
801038cc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038d3:	90                   	nop
801038d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801038d8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038dc:	85 c0                	test   %eax,%eax
801038de:	74 0f                	je     801038ef <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038e0:	89 04 24             	mov    %eax,(%esp)
801038e3:	e8 08 d5 ff ff       	call   80100df0 <filedup>
801038e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038eb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801038ef:	83 c6 01             	add    $0x1,%esi
801038f2:	83 fe 10             	cmp    $0x10,%esi
801038f5:	75 e1                	jne    801038d8 <fork+0x68>
  np->cwd = idup(curproc->cwd);
801038f7:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038fa:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801038fd:	89 04 24             	mov    %eax,(%esp)
80103900:	e8 9b dd ff ff       	call   801016a0 <idup>
80103905:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103908:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010390b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010390e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103912:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103919:	00 
8010391a:	89 04 24             	mov    %eax,(%esp)
8010391d:	e8 5e 0b 00 00       	call   80104480 <safestrcpy>
  pid = np->pid;
80103922:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103925:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010392c:	e8 2f 08 00 00       	call   80104160 <acquire>
  np->state = RUNNABLE;
80103931:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103938:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010393f:	e8 0c 09 00 00       	call   80104250 <release>
  return pid;
80103944:	89 d8                	mov    %ebx,%eax
}
80103946:	83 c4 1c             	add    $0x1c,%esp
80103949:	5b                   	pop    %ebx
8010394a:	5e                   	pop    %esi
8010394b:	5f                   	pop    %edi
8010394c:	5d                   	pop    %ebp
8010394d:	c3                   	ret    
    return -1;
8010394e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103953:	eb f1                	jmp    80103946 <fork+0xd6>
    kfree(np->kstack);
80103955:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103958:	8b 47 08             	mov    0x8(%edi),%eax
8010395b:	89 04 24             	mov    %eax,(%esp)
8010395e:	e8 ad e9 ff ff       	call   80102310 <kfree>
    return -1;
80103963:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103968:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010396f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103976:	eb ce                	jmp    80103946 <fork+0xd6>
80103978:	90                   	nop
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103980 <scheduler>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103989:	e8 92 fc ff ff       	call   80103620 <mycpu>
8010398e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103990:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103997:	00 00 00 
8010399a:	8d 78 04             	lea    0x4(%eax),%edi
8010399d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039a0:	fb                   	sti    
    acquire(&ptable.lock);
801039a1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
801039ad:	e8 ae 07 00 00       	call   80104160 <acquire>
801039b2:	eb 0f                	jmp    801039c3 <scheduler+0x43>
801039b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b8:	83 eb 80             	sub    $0xffffff80,%ebx
801039bb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801039c1:	74 45                	je     80103a08 <scheduler+0x88>
      if(p->state != RUNNABLE)
801039c3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039c7:	75 ef                	jne    801039b8 <scheduler+0x38>
      c->proc = p;
801039c9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039cf:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d2:	83 eb 80             	sub    $0xffffff80,%ebx
      switchuvm(p);
801039d5:	e8 36 2c 00 00       	call   80106610 <switchuvm>
      swtch(&(c->scheduler), p->context);
801039da:	8b 43 9c             	mov    -0x64(%ebx),%eax
      p->state = RUNNING;
801039dd:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)
      swtch(&(c->scheduler), p->context);
801039e4:	89 3c 24             	mov    %edi,(%esp)
801039e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801039eb:	e8 eb 0a 00 00       	call   801044db <swtch>
      switchkvm();
801039f0:	e8 fb 2b 00 00       	call   801065f0 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039f5:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      c->proc = 0;
801039fb:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a02:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a05:	75 bc                	jne    801039c3 <scheduler+0x43>
80103a07:	90                   	nop
    release(&ptable.lock);
80103a08:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a0f:	e8 3c 08 00 00       	call   80104250 <release>
  }
80103a14:	eb 8a                	jmp    801039a0 <scheduler+0x20>
80103a16:	8d 76 00             	lea    0x0(%esi),%esi
80103a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a20 <sched>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
80103a25:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103a28:	e8 93 fc ff ff       	call   801036c0 <myproc>
  if(!holding(&ptable.lock))
80103a2d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103a34:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a36:	e8 b5 06 00 00       	call   801040f0 <holding>
80103a3b:	85 c0                	test   %eax,%eax
80103a3d:	74 4f                	je     80103a8e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a3f:	e8 dc fb ff ff       	call   80103620 <mycpu>
80103a44:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a4b:	75 65                	jne    80103ab2 <sched+0x92>
  if(p->state == RUNNING)
80103a4d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a51:	74 53                	je     80103aa6 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a53:	9c                   	pushf  
80103a54:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a55:	f6 c4 02             	test   $0x2,%ah
80103a58:	75 40                	jne    80103a9a <sched+0x7a>
  intena = mycpu()->intena;
80103a5a:	e8 c1 fb ff ff       	call   80103620 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a5f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a62:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a68:	e8 b3 fb ff ff       	call   80103620 <mycpu>
80103a6d:	8b 40 04             	mov    0x4(%eax),%eax
80103a70:	89 1c 24             	mov    %ebx,(%esp)
80103a73:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a77:	e8 5f 0a 00 00       	call   801044db <swtch>
  mycpu()->intena = intena;
80103a7c:	e8 9f fb ff ff       	call   80103620 <mycpu>
80103a81:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a87:	83 c4 10             	add    $0x10,%esp
80103a8a:	5b                   	pop    %ebx
80103a8b:	5e                   	pop    %esi
80103a8c:	5d                   	pop    %ebp
80103a8d:	c3                   	ret    
    panic("sched ptable.lock");
80103a8e:	c7 04 24 b0 73 10 80 	movl   $0x801073b0,(%esp)
80103a95:	e8 c6 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103a9a:	c7 04 24 dc 73 10 80 	movl   $0x801073dc,(%esp)
80103aa1:	e8 ba c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103aa6:	c7 04 24 ce 73 10 80 	movl   $0x801073ce,(%esp)
80103aad:	e8 ae c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103ab2:	c7 04 24 c2 73 10 80 	movl   $0x801073c2,(%esp)
80103ab9:	e8 a2 c8 ff ff       	call   80100360 <panic>
80103abe:	66 90                	xchg   %ax,%ax

80103ac0 <exit>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
  if(curproc == initproc)
80103ac4:	31 f6                	xor    %esi,%esi
{
80103ac6:	53                   	push   %ebx
80103ac7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103aca:	e8 f1 fb ff ff       	call   801036c0 <myproc>
  if(curproc == initproc)
80103acf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103ad5:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103ad7:	0f 84 ea 00 00 00    	je     80103bc7 <exit+0x107>
80103add:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ae0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ae4:	85 c0                	test   %eax,%eax
80103ae6:	74 10                	je     80103af8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103ae8:	89 04 24             	mov    %eax,(%esp)
80103aeb:	e8 50 d3 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103af0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103af7:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103af8:	83 c6 01             	add    $0x1,%esi
80103afb:	83 fe 10             	cmp    $0x10,%esi
80103afe:	75 e0                	jne    80103ae0 <exit+0x20>
  begin_op();
80103b00:	e8 2b f0 ff ff       	call   80102b30 <begin_op>
  iput(curproc->cwd);
80103b05:	8b 43 68             	mov    0x68(%ebx),%eax
80103b08:	89 04 24             	mov    %eax,(%esp)
80103b0b:	e8 e0 dc ff ff       	call   801017f0 <iput>
  end_op();
80103b10:	e8 8b f0 ff ff       	call   80102ba0 <end_op>
  curproc->cwd = 0;
80103b15:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103b1c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b23:	e8 38 06 00 00       	call   80104160 <acquire>
  wakeup1(curproc->parent);
80103b28:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b2b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b30:	eb 11                	jmp    80103b43 <exit+0x83>
80103b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b38:	83 ea 80             	sub    $0xffffff80,%edx
80103b3b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b41:	74 1d                	je     80103b60 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b43:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b47:	75 ef                	jne    80103b38 <exit+0x78>
80103b49:	3b 42 20             	cmp    0x20(%edx),%eax
80103b4c:	75 ea                	jne    80103b38 <exit+0x78>
      p->state = RUNNABLE;
80103b4e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b55:	83 ea 80             	sub    $0xffffff80,%edx
80103b58:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b5e:	75 e3                	jne    80103b43 <exit+0x83>
      p->parent = initproc;
80103b60:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b65:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b6a:	eb 0f                	jmp    80103b7b <exit+0xbb>
80103b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b70:	83 e9 80             	sub    $0xffffff80,%ecx
80103b73:	81 f9 54 4d 11 80    	cmp    $0x80114d54,%ecx
80103b79:	74 34                	je     80103baf <exit+0xef>
    if(p->parent == curproc){
80103b7b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b7e:	75 f0                	jne    80103b70 <exit+0xb0>
      if(p->state == ZOMBIE)
80103b80:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103b84:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103b87:	75 e7                	jne    80103b70 <exit+0xb0>
80103b89:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b8e:	eb 0b                	jmp    80103b9b <exit+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b90:	83 ea 80             	sub    $0xffffff80,%edx
80103b93:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b99:	74 d5                	je     80103b70 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103b9b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b9f:	75 ef                	jne    80103b90 <exit+0xd0>
80103ba1:	3b 42 20             	cmp    0x20(%edx),%eax
80103ba4:	75 ea                	jne    80103b90 <exit+0xd0>
      p->state = RUNNABLE;
80103ba6:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103bad:	eb e1                	jmp    80103b90 <exit+0xd0>
  curproc->state = ZOMBIE;
80103baf:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103bb6:	e8 65 fe ff ff       	call   80103a20 <sched>
  panic("zombie exit");
80103bbb:	c7 04 24 fd 73 10 80 	movl   $0x801073fd,(%esp)
80103bc2:	e8 99 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103bc7:	c7 04 24 f0 73 10 80 	movl   $0x801073f0,(%esp)
80103bce:	e8 8d c7 ff ff       	call   80100360 <panic>
80103bd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103be0 <yield>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103be6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bed:	e8 6e 05 00 00       	call   80104160 <acquire>
  myproc()->state = RUNNABLE;
80103bf2:	e8 c9 fa ff ff       	call   801036c0 <myproc>
80103bf7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103bfe:	e8 1d fe ff ff       	call   80103a20 <sched>
  release(&ptable.lock);
80103c03:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c0a:	e8 41 06 00 00       	call   80104250 <release>
}
80103c0f:	c9                   	leave  
80103c10:	c3                   	ret    
80103c11:	eb 0d                	jmp    80103c20 <sleep>
80103c13:	90                   	nop
80103c14:	90                   	nop
80103c15:	90                   	nop
80103c16:	90                   	nop
80103c17:	90                   	nop
80103c18:	90                   	nop
80103c19:	90                   	nop
80103c1a:	90                   	nop
80103c1b:	90                   	nop
80103c1c:	90                   	nop
80103c1d:	90                   	nop
80103c1e:	90                   	nop
80103c1f:	90                   	nop

80103c20 <sleep>:
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 1c             	sub    $0x1c,%esp
80103c29:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c2f:	e8 8c fa ff ff       	call   801036c0 <myproc>
  if(p == 0)
80103c34:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103c36:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103c38:	0f 84 7c 00 00 00    	je     80103cba <sleep+0x9a>
  if(lk == 0)
80103c3e:	85 f6                	test   %esi,%esi
80103c40:	74 6c                	je     80103cae <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c42:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c48:	74 46                	je     80103c90 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c4a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c51:	e8 0a 05 00 00       	call   80104160 <acquire>
    release(lk);
80103c56:	89 34 24             	mov    %esi,(%esp)
80103c59:	e8 f2 05 00 00       	call   80104250 <release>
  p->chan = chan;
80103c5e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c61:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c68:	e8 b3 fd ff ff       	call   80103a20 <sched>
  p->chan = 0;
80103c6d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103c74:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c7b:	e8 d0 05 00 00       	call   80104250 <release>
    acquire(lk);
80103c80:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103c83:	83 c4 1c             	add    $0x1c,%esp
80103c86:	5b                   	pop    %ebx
80103c87:	5e                   	pop    %esi
80103c88:	5f                   	pop    %edi
80103c89:	5d                   	pop    %ebp
    acquire(lk);
80103c8a:	e9 d1 04 00 00       	jmp    80104160 <acquire>
80103c8f:	90                   	nop
  p->chan = chan;
80103c90:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103c93:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103c9a:	e8 81 fd ff ff       	call   80103a20 <sched>
  p->chan = 0;
80103c9f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103ca6:	83 c4 1c             	add    $0x1c,%esp
80103ca9:	5b                   	pop    %ebx
80103caa:	5e                   	pop    %esi
80103cab:	5f                   	pop    %edi
80103cac:	5d                   	pop    %ebp
80103cad:	c3                   	ret    
    panic("sleep without lk");
80103cae:	c7 04 24 0f 74 10 80 	movl   $0x8010740f,(%esp)
80103cb5:	e8 a6 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103cba:	c7 04 24 09 74 10 80 	movl   $0x80107409,(%esp)
80103cc1:	e8 9a c6 ff ff       	call   80100360 <panic>
80103cc6:	8d 76 00             	lea    0x0(%esi),%esi
80103cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cd0 <wait>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	56                   	push   %esi
80103cd4:	53                   	push   %ebx
80103cd5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103cd8:	e8 e3 f9 ff ff       	call   801036c0 <myproc>
  acquire(&ptable.lock);
80103cdd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103ce4:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103ce6:	e8 75 04 00 00       	call   80104160 <acquire>
    havekids = 0;
80103ceb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ced:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103cf2:	eb 0f                	jmp    80103d03 <wait+0x33>
80103cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf8:	83 eb 80             	sub    $0xffffff80,%ebx
80103cfb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d01:	74 1d                	je     80103d20 <wait+0x50>
      if(p->parent != curproc)
80103d03:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d06:	75 f0                	jne    80103cf8 <wait+0x28>
      if(p->state == ZOMBIE){
80103d08:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d0c:	74 2f                	je     80103d3d <wait+0x6d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d0e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103d11:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d16:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d1c:	75 e5                	jne    80103d03 <wait+0x33>
80103d1e:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103d20:	85 c0                	test   %eax,%eax
80103d22:	74 6e                	je     80103d92 <wait+0xc2>
80103d24:	8b 46 24             	mov    0x24(%esi),%eax
80103d27:	85 c0                	test   %eax,%eax
80103d29:	75 67                	jne    80103d92 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d2b:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d32:	80 
80103d33:	89 34 24             	mov    %esi,(%esp)
80103d36:	e8 e5 fe ff ff       	call   80103c20 <sleep>
  }
80103d3b:	eb ae                	jmp    80103ceb <wait+0x1b>
        kfree(p->kstack);
80103d3d:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103d40:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d43:	89 04 24             	mov    %eax,(%esp)
80103d46:	e8 c5 e5 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80103d4b:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103d4e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d55:	89 04 24             	mov    %eax,(%esp)
80103d58:	e8 33 2c 00 00       	call   80106990 <freevm>
        release(&ptable.lock);
80103d5d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103d64:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d6b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d72:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103d76:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103d7d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103d84:	e8 c7 04 00 00       	call   80104250 <release>
}
80103d89:	83 c4 10             	add    $0x10,%esp
        return pid;
80103d8c:	89 f0                	mov    %esi,%eax
}
80103d8e:	5b                   	pop    %ebx
80103d8f:	5e                   	pop    %esi
80103d90:	5d                   	pop    %ebp
80103d91:	c3                   	ret    
      release(&ptable.lock);
80103d92:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d99:	e8 b2 04 00 00       	call   80104250 <release>
}
80103d9e:	83 c4 10             	add    $0x10,%esp
      return -1;
80103da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103da6:	5b                   	pop    %ebx
80103da7:	5e                   	pop    %esi
80103da8:	5d                   	pop    %ebp
80103da9:	c3                   	ret    
80103daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103db0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	53                   	push   %ebx
80103db4:	83 ec 14             	sub    $0x14,%esp
80103db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dc1:	e8 9a 03 00 00       	call   80104160 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dcb:	eb 0d                	jmp    80103dda <wakeup+0x2a>
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi
80103dd0:	83 e8 80             	sub    $0xffffff80,%eax
80103dd3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103dd8:	74 1e                	je     80103df8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103dda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dde:	75 f0                	jne    80103dd0 <wakeup+0x20>
80103de0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103de3:	75 eb                	jne    80103dd0 <wakeup+0x20>
      p->state = RUNNABLE;
80103de5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dec:	83 e8 80             	sub    $0xffffff80,%eax
80103def:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103df4:	75 e4                	jne    80103dda <wakeup+0x2a>
80103df6:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103df8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103dff:	83 c4 14             	add    $0x14,%esp
80103e02:	5b                   	pop    %ebx
80103e03:	5d                   	pop    %ebp
  release(&ptable.lock);
80103e04:	e9 47 04 00 00       	jmp    80104250 <release>
80103e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e10 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	53                   	push   %ebx
80103e14:	83 ec 14             	sub    $0x14,%esp
80103e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e1a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e21:	e8 3a 03 00 00       	call   80104160 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e26:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e2b:	eb 0d                	jmp    80103e3a <kill+0x2a>
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
80103e30:	83 e8 80             	sub    $0xffffff80,%eax
80103e33:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e38:	74 36                	je     80103e70 <kill+0x60>
    if(p->pid == pid){
80103e3a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e3d:	75 f1                	jne    80103e30 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e3f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103e43:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103e4a:	74 14                	je     80103e60 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e4c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e53:	e8 f8 03 00 00       	call   80104250 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e58:	83 c4 14             	add    $0x14,%esp
      return 0;
80103e5b:	31 c0                	xor    %eax,%eax
}
80103e5d:	5b                   	pop    %ebx
80103e5e:	5d                   	pop    %ebp
80103e5f:	c3                   	ret    
        p->state = RUNNABLE;
80103e60:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e67:	eb e3                	jmp    80103e4c <kill+0x3c>
80103e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103e70:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e77:	e8 d4 03 00 00       	call   80104250 <release>
}
80103e7c:	83 c4 14             	add    $0x14,%esp
  return -1;
80103e7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e84:	5b                   	pop    %ebx
80103e85:	5d                   	pop    %ebp
80103e86:	c3                   	ret    
80103e87:	89 f6                	mov    %esi,%esi
80103e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103e9b:	83 ec 4c             	sub    $0x4c,%esp
80103e9e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ea1:	eb 20                	jmp    80103ec3 <procdump+0x33>
80103ea3:	90                   	nop
80103ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ea8:	c7 04 24 07 78 10 80 	movl   $0x80107807,(%esp)
80103eaf:	e8 9c c7 ff ff       	call   80100650 <cprintf>
80103eb4:	83 eb 80             	sub    $0xffffff80,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb7:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80103ebd:	0f 84 8d 00 00 00    	je     80103f50 <procdump+0xc0>
    if(p->state == UNUSED)
80103ec3:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103ec6:	85 c0                	test   %eax,%eax
80103ec8:	74 ea                	je     80103eb4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103eca:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103ecd:	ba 20 74 10 80       	mov    $0x80107420,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ed2:	77 11                	ja     80103ee5 <procdump+0x55>
80103ed4:	8b 14 85 80 74 10 80 	mov    -0x7fef8b80(,%eax,4),%edx
      state = "???";
80103edb:	b8 20 74 10 80       	mov    $0x80107420,%eax
80103ee0:	85 d2                	test   %edx,%edx
80103ee2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103ee5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103ee8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103eec:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ef0:	c7 04 24 24 74 10 80 	movl   $0x80107424,(%esp)
80103ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103efb:	e8 50 c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f00:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f04:	75 a2                	jne    80103ea8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f06:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f09:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f0d:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f10:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f13:	8b 40 0c             	mov    0xc(%eax),%eax
80103f16:	83 c0 08             	add    $0x8,%eax
80103f19:	89 04 24             	mov    %eax,(%esp)
80103f1c:	e8 6f 01 00 00       	call   80104090 <getcallerpcs>
80103f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f28:	8b 17                	mov    (%edi),%edx
80103f2a:	85 d2                	test   %edx,%edx
80103f2c:	0f 84 76 ff ff ff    	je     80103ea8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f32:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f36:	83 c7 04             	add    $0x4,%edi
80103f39:	c7 04 24 61 6e 10 80 	movl   $0x80106e61,(%esp)
80103f40:	e8 0b c7 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103f45:	39 f7                	cmp    %esi,%edi
80103f47:	75 df                	jne    80103f28 <procdump+0x98>
80103f49:	e9 5a ff ff ff       	jmp    80103ea8 <procdump+0x18>
80103f4e:	66 90                	xchg   %ax,%ax
  }
}
80103f50:	83 c4 4c             	add    $0x4c,%esp
80103f53:	5b                   	pop    %ebx
80103f54:	5e                   	pop    %esi
80103f55:	5f                   	pop    %edi
80103f56:	5d                   	pop    %ebp
80103f57:	c3                   	ret    
80103f58:	66 90                	xchg   %ax,%ax
80103f5a:	66 90                	xchg   %ax,%ax
80103f5c:	66 90                	xchg   %ax,%ax
80103f5e:	66 90                	xchg   %ax,%ax

80103f60 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	53                   	push   %ebx
80103f64:	83 ec 14             	sub    $0x14,%esp
80103f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f6a:	c7 44 24 04 98 74 10 	movl   $0x80107498,0x4(%esp)
80103f71:	80 
80103f72:	8d 43 04             	lea    0x4(%ebx),%eax
80103f75:	89 04 24             	mov    %eax,(%esp)
80103f78:	e8 f3 00 00 00       	call   80104070 <initlock>
  lk->name = name;
80103f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f80:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f86:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80103f8d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80103f90:	83 c4 14             	add    $0x14,%esp
80103f93:	5b                   	pop    %ebx
80103f94:	5d                   	pop    %ebp
80103f95:	c3                   	ret    
80103f96:	8d 76 00             	lea    0x0(%esi),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
80103fa5:	83 ec 10             	sub    $0x10,%esp
80103fa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fab:	8d 73 04             	lea    0x4(%ebx),%esi
80103fae:	89 34 24             	mov    %esi,(%esp)
80103fb1:	e8 aa 01 00 00       	call   80104160 <acquire>
  while (lk->locked) {
80103fb6:	8b 13                	mov    (%ebx),%edx
80103fb8:	85 d2                	test   %edx,%edx
80103fba:	74 16                	je     80103fd2 <acquiresleep+0x32>
80103fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103fc0:	89 74 24 04          	mov    %esi,0x4(%esp)
80103fc4:	89 1c 24             	mov    %ebx,(%esp)
80103fc7:	e8 54 fc ff ff       	call   80103c20 <sleep>
  while (lk->locked) {
80103fcc:	8b 03                	mov    (%ebx),%eax
80103fce:	85 c0                	test   %eax,%eax
80103fd0:	75 ee                	jne    80103fc0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103fd2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103fd8:	e8 e3 f6 ff ff       	call   801036c0 <myproc>
80103fdd:	8b 40 10             	mov    0x10(%eax),%eax
80103fe0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103fe3:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fe6:	83 c4 10             	add    $0x10,%esp
80103fe9:	5b                   	pop    %ebx
80103fea:	5e                   	pop    %esi
80103feb:	5d                   	pop    %ebp
  release(&lk->lk);
80103fec:	e9 5f 02 00 00       	jmp    80104250 <release>
80103ff1:	eb 0d                	jmp    80104000 <releasesleep>
80103ff3:	90                   	nop
80103ff4:	90                   	nop
80103ff5:	90                   	nop
80103ff6:	90                   	nop
80103ff7:	90                   	nop
80103ff8:	90                   	nop
80103ff9:	90                   	nop
80103ffa:	90                   	nop
80103ffb:	90                   	nop
80103ffc:	90                   	nop
80103ffd:	90                   	nop
80103ffe:	90                   	nop
80103fff:	90                   	nop

80104000 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
80104005:	83 ec 10             	sub    $0x10,%esp
80104008:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010400b:	8d 73 04             	lea    0x4(%ebx),%esi
8010400e:	89 34 24             	mov    %esi,(%esp)
80104011:	e8 4a 01 00 00       	call   80104160 <acquire>
  lk->locked = 0;
80104016:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010401c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104023:	89 1c 24             	mov    %ebx,(%esp)
80104026:	e8 85 fd ff ff       	call   80103db0 <wakeup>
  release(&lk->lk);
8010402b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010402e:	83 c4 10             	add    $0x10,%esp
80104031:	5b                   	pop    %ebx
80104032:	5e                   	pop    %esi
80104033:	5d                   	pop    %ebp
  release(&lk->lk);
80104034:	e9 17 02 00 00       	jmp    80104250 <release>
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104040 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
80104045:	83 ec 10             	sub    $0x10,%esp
80104048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010404b:	8d 73 04             	lea    0x4(%ebx),%esi
8010404e:	89 34 24             	mov    %esi,(%esp)
80104051:	e8 0a 01 00 00       	call   80104160 <acquire>
  r = lk->locked;
80104056:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104058:	89 34 24             	mov    %esi,(%esp)
8010405b:	e8 f0 01 00 00       	call   80104250 <release>
  return r;
}
80104060:	83 c4 10             	add    $0x10,%esp
80104063:	89 d8                	mov    %ebx,%eax
80104065:	5b                   	pop    %ebx
80104066:	5e                   	pop    %esi
80104067:	5d                   	pop    %ebp
80104068:	c3                   	ret    
80104069:	66 90                	xchg   %ax,%ax
8010406b:	66 90                	xchg   %ax,%ax
8010406d:	66 90                	xchg   %ax,%ax
8010406f:	90                   	nop

80104070 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104076:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104079:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010407f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104082:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104089:	5d                   	pop    %ebp
8010408a:	c3                   	ret    
8010408b:	90                   	nop
8010408c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104090 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104093:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104099:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010409a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010409d:	31 c0                	xor    %eax,%eax
8010409f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801040a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040ac:	77 1a                	ja     801040c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801040b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801040b4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801040b7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801040b9:	83 f8 0a             	cmp    $0xa,%eax
801040bc:	75 e2                	jne    801040a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040be:	5b                   	pop    %ebx
801040bf:	5d                   	pop    %ebp
801040c0:	c3                   	ret    
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801040c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040cf:	83 c0 01             	add    $0x1,%eax
801040d2:	83 f8 0a             	cmp    $0xa,%eax
801040d5:	74 e7                	je     801040be <getcallerpcs+0x2e>
    pcs[i] = 0;
801040d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801040de:	83 c0 01             	add    $0x1,%eax
801040e1:	83 f8 0a             	cmp    $0xa,%eax
801040e4:	75 e2                	jne    801040c8 <getcallerpcs+0x38>
801040e6:	eb d6                	jmp    801040be <getcallerpcs+0x2e>
801040e8:	90                   	nop
801040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040f0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801040f0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801040f1:	31 c0                	xor    %eax,%eax
{
801040f3:	89 e5                	mov    %esp,%ebp
801040f5:	53                   	push   %ebx
801040f6:	83 ec 04             	sub    $0x4,%esp
801040f9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801040fc:	8b 0a                	mov    (%edx),%ecx
801040fe:	85 c9                	test   %ecx,%ecx
80104100:	74 10                	je     80104112 <holding+0x22>
80104102:	8b 5a 08             	mov    0x8(%edx),%ebx
80104105:	e8 16 f5 ff ff       	call   80103620 <mycpu>
8010410a:	39 c3                	cmp    %eax,%ebx
8010410c:	0f 94 c0             	sete   %al
8010410f:	0f b6 c0             	movzbl %al,%eax
}
80104112:	83 c4 04             	add    $0x4,%esp
80104115:	5b                   	pop    %ebx
80104116:	5d                   	pop    %ebp
80104117:	c3                   	ret    
80104118:	90                   	nop
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 04             	sub    $0x4,%esp
80104127:	9c                   	pushf  
80104128:	5b                   	pop    %ebx
  asm volatile("cli");
80104129:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010412a:	e8 f1 f4 ff ff       	call   80103620 <mycpu>
8010412f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104135:	85 c0                	test   %eax,%eax
80104137:	75 11                	jne    8010414a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104139:	e8 e2 f4 ff ff       	call   80103620 <mycpu>
8010413e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104144:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010414a:	e8 d1 f4 ff ff       	call   80103620 <mycpu>
8010414f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104156:	83 c4 04             	add    $0x4,%esp
80104159:	5b                   	pop    %ebx
8010415a:	5d                   	pop    %ebp
8010415b:	c3                   	ret    
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104160 <acquire>:
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104167:	e8 b4 ff ff ff       	call   80104120 <pushcli>
  if(holding(lk))
8010416c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010416f:	8b 02                	mov    (%edx),%eax
80104171:	85 c0                	test   %eax,%eax
80104173:	75 43                	jne    801041b8 <acquire+0x58>
  asm volatile("lock; xchgl %0, %1" :
80104175:	b9 01 00 00 00       	mov    $0x1,%ecx
8010417a:	eb 07                	jmp    80104183 <acquire+0x23>
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104180:	8b 55 08             	mov    0x8(%ebp),%edx
80104183:	89 c8                	mov    %ecx,%eax
80104185:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
80104188:	85 c0                	test   %eax,%eax
8010418a:	75 f4                	jne    80104180 <acquire+0x20>
  __sync_synchronize();
8010418c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010418f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104192:	e8 89 f4 ff ff       	call   80103620 <mycpu>
80104197:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010419a:	8b 45 08             	mov    0x8(%ebp),%eax
8010419d:	83 c0 0c             	add    $0xc,%eax
801041a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801041a4:	8d 45 08             	lea    0x8(%ebp),%eax
801041a7:	89 04 24             	mov    %eax,(%esp)
801041aa:	e8 e1 fe ff ff       	call   80104090 <getcallerpcs>
}
801041af:	83 c4 14             	add    $0x14,%esp
801041b2:	5b                   	pop    %ebx
801041b3:	5d                   	pop    %ebp
801041b4:	c3                   	ret    
801041b5:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
801041b8:	8b 5a 08             	mov    0x8(%edx),%ebx
801041bb:	e8 60 f4 ff ff       	call   80103620 <mycpu>
  if(holding(lk))
801041c0:	39 c3                	cmp    %eax,%ebx
801041c2:	74 05                	je     801041c9 <acquire+0x69>
801041c4:	8b 55 08             	mov    0x8(%ebp),%edx
801041c7:	eb ac                	jmp    80104175 <acquire+0x15>
    panic("acquire");
801041c9:	c7 04 24 a3 74 10 80 	movl   $0x801074a3,(%esp)
801041d0:	e8 8b c1 ff ff       	call   80100360 <panic>
801041d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <popcli>:

void
popcli(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041e6:	9c                   	pushf  
801041e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041e8:	f6 c4 02             	test   $0x2,%ah
801041eb:	75 49                	jne    80104236 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801041ed:	e8 2e f4 ff ff       	call   80103620 <mycpu>
801041f2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801041f8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801041fb:	85 d2                	test   %edx,%edx
801041fd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104203:	78 25                	js     8010422a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104205:	e8 16 f4 ff ff       	call   80103620 <mycpu>
8010420a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104210:	85 d2                	test   %edx,%edx
80104212:	74 04                	je     80104218 <popcli+0x38>
    sti();
}
80104214:	c9                   	leave  
80104215:	c3                   	ret    
80104216:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104218:	e8 03 f4 ff ff       	call   80103620 <mycpu>
8010421d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104223:	85 c0                	test   %eax,%eax
80104225:	74 ed                	je     80104214 <popcli+0x34>
  asm volatile("sti");
80104227:	fb                   	sti    
}
80104228:	c9                   	leave  
80104229:	c3                   	ret    
    panic("popcli");
8010422a:	c7 04 24 c2 74 10 80 	movl   $0x801074c2,(%esp)
80104231:	e8 2a c1 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104236:	c7 04 24 ab 74 10 80 	movl   $0x801074ab,(%esp)
8010423d:	e8 1e c1 ff ff       	call   80100360 <panic>
80104242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <release>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
80104255:	83 ec 10             	sub    $0x10,%esp
80104258:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010425b:	8b 03                	mov    (%ebx),%eax
8010425d:	85 c0                	test   %eax,%eax
8010425f:	75 0f                	jne    80104270 <release+0x20>
    panic("release");
80104261:	c7 04 24 c9 74 10 80 	movl   $0x801074c9,(%esp)
80104268:	e8 f3 c0 ff ff       	call   80100360 <panic>
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104270:	8b 73 08             	mov    0x8(%ebx),%esi
80104273:	e8 a8 f3 ff ff       	call   80103620 <mycpu>
  if(!holding(lk))
80104278:	39 c6                	cmp    %eax,%esi
8010427a:	75 e5                	jne    80104261 <release+0x11>
  lk->pcs[0] = 0;
8010427c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104283:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010428a:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010428d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104293:	83 c4 10             	add    $0x10,%esp
80104296:	5b                   	pop    %ebx
80104297:	5e                   	pop    %esi
80104298:	5d                   	pop    %ebp
  popcli();
80104299:	e9 42 ff ff ff       	jmp    801041e0 <popcli>
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	8b 55 08             	mov    0x8(%ebp),%edx
801042a6:	57                   	push   %edi
801042a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801042aa:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801042ab:	f6 c2 03             	test   $0x3,%dl
801042ae:	75 05                	jne    801042b5 <memset+0x15>
801042b0:	f6 c1 03             	test   $0x3,%cl
801042b3:	74 13                	je     801042c8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801042b5:	89 d7                	mov    %edx,%edi
801042b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ba:	fc                   	cld    
801042bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801042bd:	5b                   	pop    %ebx
801042be:	89 d0                	mov    %edx,%eax
801042c0:	5f                   	pop    %edi
801042c1:	5d                   	pop    %ebp
801042c2:	c3                   	ret    
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801042c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801042cc:	c1 e9 02             	shr    $0x2,%ecx
801042cf:	89 f8                	mov    %edi,%eax
801042d1:	89 fb                	mov    %edi,%ebx
801042d3:	c1 e0 18             	shl    $0x18,%eax
801042d6:	c1 e3 10             	shl    $0x10,%ebx
801042d9:	09 d8                	or     %ebx,%eax
801042db:	09 f8                	or     %edi,%eax
801042dd:	c1 e7 08             	shl    $0x8,%edi
801042e0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801042e2:	89 d7                	mov    %edx,%edi
801042e4:	fc                   	cld    
801042e5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801042e7:	5b                   	pop    %ebx
801042e8:	89 d0                	mov    %edx,%eax
801042ea:	5f                   	pop    %edi
801042eb:	5d                   	pop    %ebp
801042ec:	c3                   	ret    
801042ed:	8d 76 00             	lea    0x0(%esi),%esi

801042f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	8b 45 10             	mov    0x10(%ebp),%eax
801042f6:	57                   	push   %edi
801042f7:	56                   	push   %esi
801042f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042fb:	53                   	push   %ebx
801042fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801042ff:	85 c0                	test   %eax,%eax
80104301:	8d 78 ff             	lea    -0x1(%eax),%edi
80104304:	74 26                	je     8010432c <memcmp+0x3c>
    if(*s1 != *s2)
80104306:	0f b6 03             	movzbl (%ebx),%eax
80104309:	31 d2                	xor    %edx,%edx
8010430b:	0f b6 0e             	movzbl (%esi),%ecx
8010430e:	38 c8                	cmp    %cl,%al
80104310:	74 16                	je     80104328 <memcmp+0x38>
80104312:	eb 24                	jmp    80104338 <memcmp+0x48>
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104318:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010431d:	83 c2 01             	add    $0x1,%edx
80104320:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104324:	38 c8                	cmp    %cl,%al
80104326:	75 10                	jne    80104338 <memcmp+0x48>
  while(n-- > 0){
80104328:	39 fa                	cmp    %edi,%edx
8010432a:	75 ec                	jne    80104318 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010432c:	5b                   	pop    %ebx
  return 0;
8010432d:	31 c0                	xor    %eax,%eax
}
8010432f:	5e                   	pop    %esi
80104330:	5f                   	pop    %edi
80104331:	5d                   	pop    %ebp
80104332:	c3                   	ret    
80104333:	90                   	nop
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104338:	5b                   	pop    %ebx
      return *s1 - *s2;
80104339:	29 c8                	sub    %ecx,%eax
}
8010433b:	5e                   	pop    %esi
8010433c:	5f                   	pop    %edi
8010433d:	5d                   	pop    %ebp
8010433e:	c3                   	ret    
8010433f:	90                   	nop

80104340 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	8b 45 08             	mov    0x8(%ebp),%eax
80104347:	56                   	push   %esi
80104348:	8b 75 0c             	mov    0xc(%ebp),%esi
8010434b:	53                   	push   %ebx
8010434c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010434f:	39 c6                	cmp    %eax,%esi
80104351:	73 35                	jae    80104388 <memmove+0x48>
80104353:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104356:	39 c8                	cmp    %ecx,%eax
80104358:	73 2e                	jae    80104388 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010435a:	85 db                	test   %ebx,%ebx
    d += n;
8010435c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010435f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104362:	74 1b                	je     8010437f <memmove+0x3f>
80104364:	f7 db                	neg    %ebx
80104366:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104369:	01 fb                	add    %edi,%ebx
8010436b:	90                   	nop
8010436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104370:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104374:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104377:	83 ea 01             	sub    $0x1,%edx
8010437a:	83 fa ff             	cmp    $0xffffffff,%edx
8010437d:	75 f1                	jne    80104370 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010437f:	5b                   	pop    %ebx
80104380:	5e                   	pop    %esi
80104381:	5f                   	pop    %edi
80104382:	5d                   	pop    %ebp
80104383:	c3                   	ret    
80104384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104388:	31 d2                	xor    %edx,%edx
8010438a:	85 db                	test   %ebx,%ebx
8010438c:	74 f1                	je     8010437f <memmove+0x3f>
8010438e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104390:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104394:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104397:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010439a:	39 da                	cmp    %ebx,%edx
8010439c:	75 f2                	jne    80104390 <memmove+0x50>
}
8010439e:	5b                   	pop    %ebx
8010439f:	5e                   	pop    %esi
801043a0:	5f                   	pop    %edi
801043a1:	5d                   	pop    %ebp
801043a2:	c3                   	ret    
801043a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801043b3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801043b4:	eb 8a                	jmp    80104340 <memmove>
801043b6:	8d 76 00             	lea    0x0(%esi),%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	56                   	push   %esi
801043c4:	8b 75 10             	mov    0x10(%ebp),%esi
801043c7:	53                   	push   %ebx
801043c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801043ce:	85 f6                	test   %esi,%esi
801043d0:	74 30                	je     80104402 <strncmp+0x42>
801043d2:	0f b6 01             	movzbl (%ecx),%eax
801043d5:	84 c0                	test   %al,%al
801043d7:	74 2f                	je     80104408 <strncmp+0x48>
801043d9:	0f b6 13             	movzbl (%ebx),%edx
801043dc:	38 d0                	cmp    %dl,%al
801043de:	75 46                	jne    80104426 <strncmp+0x66>
801043e0:	8d 51 01             	lea    0x1(%ecx),%edx
801043e3:	01 ce                	add    %ecx,%esi
801043e5:	eb 14                	jmp    801043fb <strncmp+0x3b>
801043e7:	90                   	nop
801043e8:	0f b6 02             	movzbl (%edx),%eax
801043eb:	84 c0                	test   %al,%al
801043ed:	74 31                	je     80104420 <strncmp+0x60>
801043ef:	0f b6 19             	movzbl (%ecx),%ebx
801043f2:	83 c2 01             	add    $0x1,%edx
801043f5:	38 d8                	cmp    %bl,%al
801043f7:	75 17                	jne    80104410 <strncmp+0x50>
    n--, p++, q++;
801043f9:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
801043fb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801043fd:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
80104400:	75 e6                	jne    801043e8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104402:	5b                   	pop    %ebx
    return 0;
80104403:	31 c0                	xor    %eax,%eax
}
80104405:	5e                   	pop    %esi
80104406:	5d                   	pop    %ebp
80104407:	c3                   	ret    
80104408:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
8010440b:	31 c0                	xor    %eax,%eax
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104410:	0f b6 d3             	movzbl %bl,%edx
80104413:	29 d0                	sub    %edx,%eax
}
80104415:	5b                   	pop    %ebx
80104416:	5e                   	pop    %esi
80104417:	5d                   	pop    %ebp
80104418:	c3                   	ret    
80104419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104420:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104424:	eb ea                	jmp    80104410 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104426:	89 d3                	mov    %edx,%ebx
80104428:	eb e6                	jmp    80104410 <strncmp+0x50>
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104430 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	8b 45 08             	mov    0x8(%ebp),%eax
80104436:	56                   	push   %esi
80104437:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010443a:	53                   	push   %ebx
8010443b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010443e:	89 c2                	mov    %eax,%edx
80104440:	eb 19                	jmp    8010445b <strncpy+0x2b>
80104442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104448:	83 c3 01             	add    $0x1,%ebx
8010444b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010444f:	83 c2 01             	add    $0x1,%edx
80104452:	84 c9                	test   %cl,%cl
80104454:	88 4a ff             	mov    %cl,-0x1(%edx)
80104457:	74 09                	je     80104462 <strncpy+0x32>
80104459:	89 f1                	mov    %esi,%ecx
8010445b:	85 c9                	test   %ecx,%ecx
8010445d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104460:	7f e6                	jg     80104448 <strncpy+0x18>
    ;
  while(n-- > 0)
80104462:	31 c9                	xor    %ecx,%ecx
80104464:	85 f6                	test   %esi,%esi
80104466:	7e 0f                	jle    80104477 <strncpy+0x47>
    *s++ = 0;
80104468:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010446c:	89 f3                	mov    %esi,%ebx
8010446e:	83 c1 01             	add    $0x1,%ecx
80104471:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104473:	85 db                	test   %ebx,%ebx
80104475:	7f f1                	jg     80104468 <strncpy+0x38>
  return os;
}
80104477:	5b                   	pop    %ebx
80104478:	5e                   	pop    %esi
80104479:	5d                   	pop    %ebp
8010447a:	c3                   	ret    
8010447b:	90                   	nop
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104486:	56                   	push   %esi
80104487:	8b 45 08             	mov    0x8(%ebp),%eax
8010448a:	53                   	push   %ebx
8010448b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010448e:	85 c9                	test   %ecx,%ecx
80104490:	7e 26                	jle    801044b8 <safestrcpy+0x38>
80104492:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104496:	89 c1                	mov    %eax,%ecx
80104498:	eb 17                	jmp    801044b1 <safestrcpy+0x31>
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044a0:	83 c2 01             	add    $0x1,%edx
801044a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801044a7:	83 c1 01             	add    $0x1,%ecx
801044aa:	84 db                	test   %bl,%bl
801044ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044af:	74 04                	je     801044b5 <safestrcpy+0x35>
801044b1:	39 f2                	cmp    %esi,%edx
801044b3:	75 eb                	jne    801044a0 <safestrcpy+0x20>
    ;
  *s = 0;
801044b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044b8:	5b                   	pop    %ebx
801044b9:	5e                   	pop    %esi
801044ba:	5d                   	pop    %ebp
801044bb:	c3                   	ret    
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <strlen>:

int
strlen(const char *s)
{
801044c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801044c1:	31 c0                	xor    %eax,%eax
{
801044c3:	89 e5                	mov    %esp,%ebp
801044c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801044c8:	80 3a 00             	cmpb   $0x0,(%edx)
801044cb:	74 0c                	je     801044d9 <strlen+0x19>
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
801044d0:	83 c0 01             	add    $0x1,%eax
801044d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044d7:	75 f7                	jne    801044d0 <strlen+0x10>
    ;
  return n;
}
801044d9:	5d                   	pop    %ebp
801044da:	c3                   	ret    

801044db <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801044e3:	55                   	push   %ebp
  pushl %ebx
801044e4:	53                   	push   %ebx
  pushl %esi
801044e5:	56                   	push   %esi
  pushl %edi
801044e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044e9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801044eb:	5f                   	pop    %edi
  popl %esi
801044ec:	5e                   	pop    %esi
  popl %ebx
801044ed:	5b                   	pop    %ebx
  popl %ebp
801044ee:	5d                   	pop    %ebp
  ret
801044ef:	c3                   	ret    

801044f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{/*
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;*/
  *ip = *(int*)(addr);
801044f3:	8b 45 08             	mov    0x8(%ebp),%eax
801044f6:	8b 10                	mov    (%eax),%edx
801044f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801044fb:	89 10                	mov    %edx,(%eax)
  return 0;
}
801044fd:	31 c0                	xor    %eax,%eax
801044ff:	5d                   	pop    %ebp
80104500:	c3                   	ret    
80104501:	eb 0d                	jmp    80104510 <fetchstr>
80104503:	90                   	nop
80104504:	90                   	nop
80104505:	90                   	nop
80104506:	90                   	nop
80104507:	90                   	nop
80104508:	90                   	nop
80104509:	90                   	nop
8010450a:	90                   	nop
8010450b:	90                   	nop
8010450c:	90                   	nop
8010450d:	90                   	nop
8010450e:	90                   	nop
8010450f:	90                   	nop

80104510 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;/*
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;*/
  *pp = (char*)addr;
80104516:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ep = (char*)STACKBASE;	// Lab3
  for(s = *pp; s < ep; s++){
80104519:	81 fa fb ff ff 7f    	cmp    $0x7ffffffb,%edx
  *pp = (char*)addr;
8010451f:	89 11                	mov    %edx,(%ecx)
  for(s = *pp; s < ep; s++){
80104521:	77 1c                	ja     8010453f <fetchstr+0x2f>
    if(*s == 0)
80104523:	80 3a 00             	cmpb   $0x0,(%edx)
80104526:	89 d0                	mov    %edx,%eax
80104528:	75 0b                	jne    80104535 <fetchstr+0x25>
8010452a:	eb 1c                	jmp    80104548 <fetchstr+0x38>
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104530:	80 38 00             	cmpb   $0x0,(%eax)
80104533:	74 13                	je     80104548 <fetchstr+0x38>
  for(s = *pp; s < ep; s++){
80104535:	83 c0 01             	add    $0x1,%eax
80104538:	3d fc ff ff 7f       	cmp    $0x7ffffffc,%eax
8010453d:	75 f1                	jne    80104530 <fetchstr+0x20>
      return s - *pp;
  }
  return -1;
8010453f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104544:	5d                   	pop    %ebp
80104545:	c3                   	ret    
80104546:	66 90                	xchg   %ax,%ax
      return s - *pp;
80104548:	29 d0                	sub    %edx,%eax
}
8010454a:	5d                   	pop    %ebp
8010454b:	c3                   	ret    
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104550 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104556:	e8 65 f1 ff ff       	call   801036c0 <myproc>
  *ip = *(int*)(addr);
8010455b:	8b 55 08             	mov    0x8(%ebp),%edx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010455e:	8b 40 18             	mov    0x18(%eax),%eax
  *ip = *(int*)(addr);
80104561:	8b 40 44             	mov    0x44(%eax),%eax
80104564:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
80104568:	8b 45 0c             	mov    0xc(%ebp),%eax
8010456b:	89 10                	mov    %edx,(%eax)
}
8010456d:	31 c0                	xor    %eax,%eax
8010456f:	c9                   	leave  
80104570:	c3                   	ret    
80104571:	eb 0d                	jmp    80104580 <argptr>
80104573:	90                   	nop
80104574:	90                   	nop
80104575:	90                   	nop
80104576:	90                   	nop
80104577:	90                   	nop
80104578:	90                   	nop
80104579:	90                   	nop
8010457a:	90                   	nop
8010457b:	90                   	nop
8010457c:	90                   	nop
8010457d:	90                   	nop
8010457e:	90                   	nop
8010457f:	90                   	nop

80104580 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104586:	e8 35 f1 ff ff       	call   801036c0 <myproc>
 
  if(argint(n, &i) < 0)
    return -1;/*
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;*/
  *pp = (char*)i;
8010458b:	8b 55 08             	mov    0x8(%ebp),%edx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010458e:	8b 40 18             	mov    0x18(%eax),%eax
  *ip = *(int*)(addr);
80104591:	8b 40 44             	mov    0x44(%eax),%eax
  *pp = (char*)i;
80104594:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
80104598:	8b 45 0c             	mov    0xc(%ebp),%eax
8010459b:	89 10                	mov    %edx,(%eax)
  return 0;
}
8010459d:	31 c0                	xor    %eax,%eax
8010459f:	c9                   	leave  
801045a0:	c3                   	ret    
801045a1:	eb 0d                	jmp    801045b0 <argstr>
801045a3:	90                   	nop
801045a4:	90                   	nop
801045a5:	90                   	nop
801045a6:	90                   	nop
801045a7:	90                   	nop
801045a8:	90                   	nop
801045a9:	90                   	nop
801045aa:	90                   	nop
801045ab:	90                   	nop
801045ac:	90                   	nop
801045ad:	90                   	nop
801045ae:	90                   	nop
801045af:	90                   	nop

801045b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045b6:	e8 05 f1 ff ff       	call   801036c0 <myproc>
  *ip = *(int*)(addr);
801045bb:	8b 55 08             	mov    0x8(%ebp),%edx
  *pp = (char*)addr;
801045be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045c1:	8b 40 18             	mov    0x18(%eax),%eax
  *ip = *(int*)(addr);
801045c4:	8b 40 44             	mov    0x44(%eax),%eax
801045c7:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
  for(s = *pp; s < ep; s++){
801045cb:	81 fa fb ff ff 7f    	cmp    $0x7ffffffb,%edx
  *pp = (char*)addr;
801045d1:	89 11                	mov    %edx,(%ecx)
  for(s = *pp; s < ep; s++){
801045d3:	77 1a                	ja     801045ef <argstr+0x3f>
    if(*s == 0)
801045d5:	80 3a 00             	cmpb   $0x0,(%edx)
801045d8:	89 d0                	mov    %edx,%eax
801045da:	75 09                	jne    801045e5 <argstr+0x35>
801045dc:	eb 1a                	jmp    801045f8 <argstr+0x48>
801045de:	66 90                	xchg   %ax,%ax
801045e0:	80 38 00             	cmpb   $0x0,(%eax)
801045e3:	74 13                	je     801045f8 <argstr+0x48>
  for(s = *pp; s < ep; s++){
801045e5:	83 c0 01             	add    $0x1,%eax
801045e8:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
801045ed:	76 f1                	jbe    801045e0 <argstr+0x30>
  return -1;
801045ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801045f4:	c9                   	leave  
801045f5:	c3                   	ret    
801045f6:	66 90                	xchg   %ax,%ax
      return s - *pp;
801045f8:	29 d0                	sub    %edx,%eax
}
801045fa:	c9                   	leave  
801045fb:	c3                   	ret    
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104600 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104608:	e8 b3 f0 ff ff       	call   801036c0 <myproc>

  num = curproc->tf->eax;
8010460d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104610:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104612:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104615:	8d 50 ff             	lea    -0x1(%eax),%edx
80104618:	83 fa 16             	cmp    $0x16,%edx
8010461b:	77 1b                	ja     80104638 <syscall+0x38>
8010461d:	8b 14 85 00 75 10 80 	mov    -0x7fef8b00(,%eax,4),%edx
80104624:	85 d2                	test   %edx,%edx
80104626:	74 10                	je     80104638 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104628:	ff d2                	call   *%edx
8010462a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010462d:	83 c4 10             	add    $0x10,%esp
80104630:	5b                   	pop    %ebx
80104631:	5e                   	pop    %esi
80104632:	5d                   	pop    %ebp
80104633:	c3                   	ret    
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104638:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010463c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010463f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104643:	8b 43 10             	mov    0x10(%ebx),%eax
80104646:	c7 04 24 d1 74 10 80 	movl   $0x801074d1,(%esp)
8010464d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104651:	e8 fa bf ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104656:	8b 43 18             	mov    0x18(%ebx),%eax
80104659:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104660:	83 c4 10             	add    $0x10,%esp
80104663:	5b                   	pop    %ebx
80104664:	5e                   	pop    %esi
80104665:	5d                   	pop    %ebp
80104666:	c3                   	ret    
80104667:	66 90                	xchg   %ax,%ax
80104669:	66 90                	xchg   %ax,%ax
8010466b:	66 90                	xchg   %ax,%ax
8010466d:	66 90                	xchg   %ax,%ax
8010466f:	90                   	nop

80104670 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	89 c3                	mov    %eax,%ebx
80104676:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104679:	e8 42 f0 ff ff       	call   801036c0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010467e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104680:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104684:	85 c9                	test   %ecx,%ecx
80104686:	74 18                	je     801046a0 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104688:	83 c2 01             	add    $0x1,%edx
8010468b:	83 fa 10             	cmp    $0x10,%edx
8010468e:	75 f0                	jne    80104680 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104690:	83 c4 04             	add    $0x4,%esp
  return -1;
80104693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104698:	5b                   	pop    %ebx
80104699:	5d                   	pop    %ebp
8010469a:	c3                   	ret    
8010469b:	90                   	nop
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801046a0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
801046a4:	83 c4 04             	add    $0x4,%esp
      return fd;
801046a7:	89 d0                	mov    %edx,%eax
}
801046a9:	5b                   	pop    %ebx
801046aa:	5d                   	pop    %ebp
801046ab:	c3                   	ret    
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	56                   	push   %esi
801046b5:	53                   	push   %ebx
801046b6:	83 ec 4c             	sub    $0x4c,%esp
801046b9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801046bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046bf:	8d 5d da             	lea    -0x26(%ebp),%ebx
801046c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801046c6:	89 04 24             	mov    %eax,(%esp)
{
801046c9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801046cc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801046cf:	e8 6c d8 ff ff       	call   80101f40 <nameiparent>
801046d4:	85 c0                	test   %eax,%eax
801046d6:	89 c7                	mov    %eax,%edi
801046d8:	0f 84 da 00 00 00    	je     801047b8 <create+0x108>
    return 0;
  ilock(dp);
801046de:	89 04 24             	mov    %eax,(%esp)
801046e1:	e8 ea cf ff ff       	call   801016d0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801046e6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801046e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801046ed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801046f1:	89 3c 24             	mov    %edi,(%esp)
801046f4:	e8 e7 d4 ff ff       	call   80101be0 <dirlookup>
801046f9:	85 c0                	test   %eax,%eax
801046fb:	89 c6                	mov    %eax,%esi
801046fd:	74 41                	je     80104740 <create+0x90>
    iunlockput(dp);
801046ff:	89 3c 24             	mov    %edi,(%esp)
80104702:	e8 29 d2 ff ff       	call   80101930 <iunlockput>
    ilock(ip);
80104707:	89 34 24             	mov    %esi,(%esp)
8010470a:	e8 c1 cf ff ff       	call   801016d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010470f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104714:	75 12                	jne    80104728 <create+0x78>
80104716:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010471b:	89 f0                	mov    %esi,%eax
8010471d:	75 09                	jne    80104728 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010471f:	83 c4 4c             	add    $0x4c,%esp
80104722:	5b                   	pop    %ebx
80104723:	5e                   	pop    %esi
80104724:	5f                   	pop    %edi
80104725:	5d                   	pop    %ebp
80104726:	c3                   	ret    
80104727:	90                   	nop
    iunlockput(ip);
80104728:	89 34 24             	mov    %esi,(%esp)
8010472b:	e8 00 d2 ff ff       	call   80101930 <iunlockput>
}
80104730:	83 c4 4c             	add    $0x4c,%esp
    return 0;
80104733:	31 c0                	xor    %eax,%eax
}
80104735:	5b                   	pop    %ebx
80104736:	5e                   	pop    %esi
80104737:	5f                   	pop    %edi
80104738:	5d                   	pop    %ebp
80104739:	c3                   	ret    
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104740:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104744:	89 44 24 04          	mov    %eax,0x4(%esp)
80104748:	8b 07                	mov    (%edi),%eax
8010474a:	89 04 24             	mov    %eax,(%esp)
8010474d:	e8 ee cd ff ff       	call   80101540 <ialloc>
80104752:	85 c0                	test   %eax,%eax
80104754:	89 c6                	mov    %eax,%esi
80104756:	0f 84 bf 00 00 00    	je     8010481b <create+0x16b>
  ilock(ip);
8010475c:	89 04 24             	mov    %eax,(%esp)
8010475f:	e8 6c cf ff ff       	call   801016d0 <ilock>
  ip->major = major;
80104764:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104768:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010476c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104770:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104774:	b8 01 00 00 00       	mov    $0x1,%eax
80104779:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010477d:	89 34 24             	mov    %esi,(%esp)
80104780:	e8 8b ce ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104785:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010478a:	74 34                	je     801047c0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
8010478c:	8b 46 04             	mov    0x4(%esi),%eax
8010478f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104793:	89 3c 24             	mov    %edi,(%esp)
80104796:	89 44 24 08          	mov    %eax,0x8(%esp)
8010479a:	e8 a1 d6 ff ff       	call   80101e40 <dirlink>
8010479f:	85 c0                	test   %eax,%eax
801047a1:	78 6c                	js     8010480f <create+0x15f>
  iunlockput(dp);
801047a3:	89 3c 24             	mov    %edi,(%esp)
801047a6:	e8 85 d1 ff ff       	call   80101930 <iunlockput>
}
801047ab:	83 c4 4c             	add    $0x4c,%esp
  return ip;
801047ae:	89 f0                	mov    %esi,%eax
}
801047b0:	5b                   	pop    %ebx
801047b1:	5e                   	pop    %esi
801047b2:	5f                   	pop    %edi
801047b3:	5d                   	pop    %ebp
801047b4:	c3                   	ret    
801047b5:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801047b8:	31 c0                	xor    %eax,%eax
801047ba:	e9 60 ff ff ff       	jmp    8010471f <create+0x6f>
801047bf:	90                   	nop
    dp->nlink++;  // for ".."
801047c0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801047c5:	89 3c 24             	mov    %edi,(%esp)
801047c8:	e8 43 ce ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801047cd:	8b 46 04             	mov    0x4(%esi),%eax
801047d0:	c7 44 24 04 7c 75 10 	movl   $0x8010757c,0x4(%esp)
801047d7:	80 
801047d8:	89 34 24             	mov    %esi,(%esp)
801047db:	89 44 24 08          	mov    %eax,0x8(%esp)
801047df:	e8 5c d6 ff ff       	call   80101e40 <dirlink>
801047e4:	85 c0                	test   %eax,%eax
801047e6:	78 1b                	js     80104803 <create+0x153>
801047e8:	8b 47 04             	mov    0x4(%edi),%eax
801047eb:	c7 44 24 04 7b 75 10 	movl   $0x8010757b,0x4(%esp)
801047f2:	80 
801047f3:	89 34 24             	mov    %esi,(%esp)
801047f6:	89 44 24 08          	mov    %eax,0x8(%esp)
801047fa:	e8 41 d6 ff ff       	call   80101e40 <dirlink>
801047ff:	85 c0                	test   %eax,%eax
80104801:	79 89                	jns    8010478c <create+0xdc>
      panic("create dots");
80104803:	c7 04 24 6f 75 10 80 	movl   $0x8010756f,(%esp)
8010480a:	e8 51 bb ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010480f:	c7 04 24 7e 75 10 80 	movl   $0x8010757e,(%esp)
80104816:	e8 45 bb ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010481b:	c7 04 24 60 75 10 80 	movl   $0x80107560,(%esp)
80104822:	e8 39 bb ff ff       	call   80100360 <panic>
80104827:	89 f6                	mov    %esi,%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	89 c6                	mov    %eax,%esi
80104836:	53                   	push   %ebx
80104837:	89 d3                	mov    %edx,%ebx
80104839:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
8010483c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010483f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104843:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010484a:	e8 01 fd ff ff       	call   80104550 <argint>
8010484f:	85 c0                	test   %eax,%eax
80104851:	78 2d                	js     80104880 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104853:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104857:	77 27                	ja     80104880 <argfd.constprop.0+0x50>
80104859:	e8 62 ee ff ff       	call   801036c0 <myproc>
8010485e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104861:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104865:	85 c0                	test   %eax,%eax
80104867:	74 17                	je     80104880 <argfd.constprop.0+0x50>
  if(pfd)
80104869:	85 f6                	test   %esi,%esi
8010486b:	74 02                	je     8010486f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010486d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010486f:	85 db                	test   %ebx,%ebx
80104871:	74 1d                	je     80104890 <argfd.constprop.0+0x60>
    *pf = f;
80104873:	89 03                	mov    %eax,(%ebx)
  return 0;
80104875:	31 c0                	xor    %eax,%eax
}
80104877:	83 c4 20             	add    $0x20,%esp
8010487a:	5b                   	pop    %ebx
8010487b:	5e                   	pop    %esi
8010487c:	5d                   	pop    %ebp
8010487d:	c3                   	ret    
8010487e:	66 90                	xchg   %ax,%ax
80104880:	83 c4 20             	add    $0x20,%esp
    return -1;
80104883:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104888:	5b                   	pop    %ebx
80104889:	5e                   	pop    %esi
8010488a:	5d                   	pop    %ebp
8010488b:	c3                   	ret    
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104890:	31 c0                	xor    %eax,%eax
80104892:	eb e3                	jmp    80104877 <argfd.constprop.0+0x47>
80104894:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010489a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048a0 <sys_dup>:
{
801048a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801048a1:	31 c0                	xor    %eax,%eax
{
801048a3:	89 e5                	mov    %esp,%ebp
801048a5:	53                   	push   %ebx
801048a6:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
801048a9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801048ac:	e8 7f ff ff ff       	call   80104830 <argfd.constprop.0>
801048b1:	85 c0                	test   %eax,%eax
801048b3:	78 23                	js     801048d8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801048b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b8:	e8 b3 fd ff ff       	call   80104670 <fdalloc>
801048bd:	85 c0                	test   %eax,%eax
801048bf:	89 c3                	mov    %eax,%ebx
801048c1:	78 15                	js     801048d8 <sys_dup+0x38>
  filedup(f);
801048c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c6:	89 04 24             	mov    %eax,(%esp)
801048c9:	e8 22 c5 ff ff       	call   80100df0 <filedup>
  return fd;
801048ce:	89 d8                	mov    %ebx,%eax
}
801048d0:	83 c4 24             	add    $0x24,%esp
801048d3:	5b                   	pop    %ebx
801048d4:	5d                   	pop    %ebp
801048d5:	c3                   	ret    
801048d6:	66 90                	xchg   %ax,%ax
    return -1;
801048d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048dd:	eb f1                	jmp    801048d0 <sys_dup+0x30>
801048df:	90                   	nop

801048e0 <sys_read>:
{
801048e0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048e1:	31 c0                	xor    %eax,%eax
{
801048e3:	89 e5                	mov    %esp,%ebp
801048e5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801048e8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801048eb:	e8 40 ff ff ff       	call   80104830 <argfd.constprop.0>
801048f0:	85 c0                	test   %eax,%eax
801048f2:	78 54                	js     80104948 <sys_read+0x68>
801048f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801048f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801048fb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104902:	e8 49 fc ff ff       	call   80104550 <argint>
80104907:	85 c0                	test   %eax,%eax
80104909:	78 3d                	js     80104948 <sys_read+0x68>
8010490b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010490e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104915:	89 44 24 08          	mov    %eax,0x8(%esp)
80104919:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010491c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104920:	e8 5b fc ff ff       	call   80104580 <argptr>
80104925:	85 c0                	test   %eax,%eax
80104927:	78 1f                	js     80104948 <sys_read+0x68>
  return fileread(f, p, n);
80104929:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010492c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104933:	89 44 24 04          	mov    %eax,0x4(%esp)
80104937:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010493a:	89 04 24             	mov    %eax,(%esp)
8010493d:	e8 0e c6 ff ff       	call   80100f50 <fileread>
}
80104942:	c9                   	leave  
80104943:	c3                   	ret    
80104944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010494d:	c9                   	leave  
8010494e:	c3                   	ret    
8010494f:	90                   	nop

80104950 <sys_write>:
{
80104950:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104951:	31 c0                	xor    %eax,%eax
{
80104953:	89 e5                	mov    %esp,%ebp
80104955:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104958:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010495b:	e8 d0 fe ff ff       	call   80104830 <argfd.constprop.0>
80104960:	85 c0                	test   %eax,%eax
80104962:	78 54                	js     801049b8 <sys_write+0x68>
80104964:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104967:	89 44 24 04          	mov    %eax,0x4(%esp)
8010496b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104972:	e8 d9 fb ff ff       	call   80104550 <argint>
80104977:	85 c0                	test   %eax,%eax
80104979:	78 3d                	js     801049b8 <sys_write+0x68>
8010497b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010497e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104985:	89 44 24 08          	mov    %eax,0x8(%esp)
80104989:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010498c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104990:	e8 eb fb ff ff       	call   80104580 <argptr>
80104995:	85 c0                	test   %eax,%eax
80104997:	78 1f                	js     801049b8 <sys_write+0x68>
  return filewrite(f, p, n);
80104999:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010499c:	89 44 24 08          	mov    %eax,0x8(%esp)
801049a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801049a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049aa:	89 04 24             	mov    %eax,(%esp)
801049ad:	e8 3e c6 ff ff       	call   80100ff0 <filewrite>
}
801049b2:	c9                   	leave  
801049b3:	c3                   	ret    
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049bd:	c9                   	leave  
801049be:	c3                   	ret    
801049bf:	90                   	nop

801049c0 <sys_close>:
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
801049c6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801049c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049cc:	e8 5f fe ff ff       	call   80104830 <argfd.constprop.0>
801049d1:	85 c0                	test   %eax,%eax
801049d3:	78 23                	js     801049f8 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
801049d5:	e8 e6 ec ff ff       	call   801036c0 <myproc>
801049da:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049dd:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801049e4:	00 
  fileclose(f);
801049e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e8:	89 04 24             	mov    %eax,(%esp)
801049eb:	e8 50 c4 ff ff       	call   80100e40 <fileclose>
  return 0;
801049f0:	31 c0                	xor    %eax,%eax
}
801049f2:	c9                   	leave  
801049f3:	c3                   	ret    
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049fd:	c9                   	leave  
801049fe:	c3                   	ret    
801049ff:	90                   	nop

80104a00 <sys_fstat>:
{
80104a00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a01:	31 c0                	xor    %eax,%eax
{
80104a03:	89 e5                	mov    %esp,%ebp
80104a05:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a08:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a0b:	e8 20 fe ff ff       	call   80104830 <argfd.constprop.0>
80104a10:	85 c0                	test   %eax,%eax
80104a12:	78 34                	js     80104a48 <sys_fstat+0x48>
80104a14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a17:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a1e:	00 
80104a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a2a:	e8 51 fb ff ff       	call   80104580 <argptr>
80104a2f:	85 c0                	test   %eax,%eax
80104a31:	78 15                	js     80104a48 <sys_fstat+0x48>
  return filestat(f, st);
80104a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a36:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a3d:	89 04 24             	mov    %eax,(%esp)
80104a40:	e8 bb c4 ff ff       	call   80100f00 <filestat>
}
80104a45:	c9                   	leave  
80104a46:	c3                   	ret    
80104a47:	90                   	nop
    return -1;
80104a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a4d:	c9                   	leave  
80104a4e:	c3                   	ret    
80104a4f:	90                   	nop

80104a50 <sys_link>:
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	57                   	push   %edi
80104a54:	56                   	push   %esi
80104a55:	53                   	push   %ebx
80104a56:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104a59:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a67:	e8 44 fb ff ff       	call   801045b0 <argstr>
80104a6c:	85 c0                	test   %eax,%eax
80104a6e:	0f 88 e6 00 00 00    	js     80104b5a <sys_link+0x10a>
80104a74:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104a77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a82:	e8 29 fb ff ff       	call   801045b0 <argstr>
80104a87:	85 c0                	test   %eax,%eax
80104a89:	0f 88 cb 00 00 00    	js     80104b5a <sys_link+0x10a>
  begin_op();
80104a8f:	e8 9c e0 ff ff       	call   80102b30 <begin_op>
  if((ip = namei(old)) == 0){
80104a94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104a97:	89 04 24             	mov    %eax,(%esp)
80104a9a:	e8 81 d4 ff ff       	call   80101f20 <namei>
80104a9f:	85 c0                	test   %eax,%eax
80104aa1:	89 c3                	mov    %eax,%ebx
80104aa3:	0f 84 ac 00 00 00    	je     80104b55 <sys_link+0x105>
  ilock(ip);
80104aa9:	89 04 24             	mov    %eax,(%esp)
80104aac:	e8 1f cc ff ff       	call   801016d0 <ilock>
  if(ip->type == T_DIR){
80104ab1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ab6:	0f 84 91 00 00 00    	je     80104b4d <sys_link+0xfd>
  ip->nlink++;
80104abc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104ac1:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ac4:	89 1c 24             	mov    %ebx,(%esp)
80104ac7:	e8 44 cb ff ff       	call   80101610 <iupdate>
  iunlock(ip);
80104acc:	89 1c 24             	mov    %ebx,(%esp)
80104acf:	e8 dc cc ff ff       	call   801017b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ad4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104ad7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104adb:	89 04 24             	mov    %eax,(%esp)
80104ade:	e8 5d d4 ff ff       	call   80101f40 <nameiparent>
80104ae3:	85 c0                	test   %eax,%eax
80104ae5:	89 c6                	mov    %eax,%esi
80104ae7:	74 4f                	je     80104b38 <sys_link+0xe8>
  ilock(dp);
80104ae9:	89 04 24             	mov    %eax,(%esp)
80104aec:	e8 df cb ff ff       	call   801016d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104af1:	8b 03                	mov    (%ebx),%eax
80104af3:	39 06                	cmp    %eax,(%esi)
80104af5:	75 39                	jne    80104b30 <sys_link+0xe0>
80104af7:	8b 43 04             	mov    0x4(%ebx),%eax
80104afa:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104afe:	89 34 24             	mov    %esi,(%esp)
80104b01:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b05:	e8 36 d3 ff ff       	call   80101e40 <dirlink>
80104b0a:	85 c0                	test   %eax,%eax
80104b0c:	78 22                	js     80104b30 <sys_link+0xe0>
  iunlockput(dp);
80104b0e:	89 34 24             	mov    %esi,(%esp)
80104b11:	e8 1a ce ff ff       	call   80101930 <iunlockput>
  iput(ip);
80104b16:	89 1c 24             	mov    %ebx,(%esp)
80104b19:	e8 d2 cc ff ff       	call   801017f0 <iput>
  end_op();
80104b1e:	e8 7d e0 ff ff       	call   80102ba0 <end_op>
}
80104b23:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104b26:	31 c0                	xor    %eax,%eax
}
80104b28:	5b                   	pop    %ebx
80104b29:	5e                   	pop    %esi
80104b2a:	5f                   	pop    %edi
80104b2b:	5d                   	pop    %ebp
80104b2c:	c3                   	ret    
80104b2d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104b30:	89 34 24             	mov    %esi,(%esp)
80104b33:	e8 f8 cd ff ff       	call   80101930 <iunlockput>
  ilock(ip);
80104b38:	89 1c 24             	mov    %ebx,(%esp)
80104b3b:	e8 90 cb ff ff       	call   801016d0 <ilock>
  ip->nlink--;
80104b40:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104b45:	89 1c 24             	mov    %ebx,(%esp)
80104b48:	e8 c3 ca ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
80104b4d:	89 1c 24             	mov    %ebx,(%esp)
80104b50:	e8 db cd ff ff       	call   80101930 <iunlockput>
  end_op();
80104b55:	e8 46 e0 ff ff       	call   80102ba0 <end_op>
}
80104b5a:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104b5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b62:	5b                   	pop    %ebx
80104b63:	5e                   	pop    %esi
80104b64:	5f                   	pop    %edi
80104b65:	5d                   	pop    %ebp
80104b66:	c3                   	ret    
80104b67:	89 f6                	mov    %esi,%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b70 <sys_unlink>:
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	53                   	push   %ebx
80104b76:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104b79:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b87:	e8 24 fa ff ff       	call   801045b0 <argstr>
80104b8c:	85 c0                	test   %eax,%eax
80104b8e:	0f 88 76 01 00 00    	js     80104d0a <sys_unlink+0x19a>
  begin_op();
80104b94:	e8 97 df ff ff       	call   80102b30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104b99:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104b9c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104b9f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104ba3:	89 04 24             	mov    %eax,(%esp)
80104ba6:	e8 95 d3 ff ff       	call   80101f40 <nameiparent>
80104bab:	85 c0                	test   %eax,%eax
80104bad:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104bb0:	0f 84 4f 01 00 00    	je     80104d05 <sys_unlink+0x195>
  ilock(dp);
80104bb6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104bb9:	89 34 24             	mov    %esi,(%esp)
80104bbc:	e8 0f cb ff ff       	call   801016d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104bc1:	c7 44 24 04 7c 75 10 	movl   $0x8010757c,0x4(%esp)
80104bc8:	80 
80104bc9:	89 1c 24             	mov    %ebx,(%esp)
80104bcc:	e8 df cf ff ff       	call   80101bb0 <namecmp>
80104bd1:	85 c0                	test   %eax,%eax
80104bd3:	0f 84 21 01 00 00    	je     80104cfa <sys_unlink+0x18a>
80104bd9:	c7 44 24 04 7b 75 10 	movl   $0x8010757b,0x4(%esp)
80104be0:	80 
80104be1:	89 1c 24             	mov    %ebx,(%esp)
80104be4:	e8 c7 cf ff ff       	call   80101bb0 <namecmp>
80104be9:	85 c0                	test   %eax,%eax
80104beb:	0f 84 09 01 00 00    	je     80104cfa <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104bf1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104bf4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104bf8:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bfc:	89 34 24             	mov    %esi,(%esp)
80104bff:	e8 dc cf ff ff       	call   80101be0 <dirlookup>
80104c04:	85 c0                	test   %eax,%eax
80104c06:	89 c3                	mov    %eax,%ebx
80104c08:	0f 84 ec 00 00 00    	je     80104cfa <sys_unlink+0x18a>
  ilock(ip);
80104c0e:	89 04 24             	mov    %eax,(%esp)
80104c11:	e8 ba ca ff ff       	call   801016d0 <ilock>
  if(ip->nlink < 1)
80104c16:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c1b:	0f 8e 24 01 00 00    	jle    80104d45 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c26:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c29:	74 7d                	je     80104ca8 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104c2b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104c32:	00 
80104c33:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c3a:	00 
80104c3b:	89 34 24             	mov    %esi,(%esp)
80104c3e:	e8 5d f6 ff ff       	call   801042a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104c43:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c46:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104c4d:	00 
80104c4e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104c52:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c56:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c59:	89 04 24             	mov    %eax,(%esp)
80104c5c:	e8 1f ce ff ff       	call   80101a80 <writei>
80104c61:	83 f8 10             	cmp    $0x10,%eax
80104c64:	0f 85 cf 00 00 00    	jne    80104d39 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104c6a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c6f:	0f 84 a3 00 00 00    	je     80104d18 <sys_unlink+0x1a8>
  iunlockput(dp);
80104c75:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c78:	89 04 24             	mov    %eax,(%esp)
80104c7b:	e8 b0 cc ff ff       	call   80101930 <iunlockput>
  ip->nlink--;
80104c80:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c85:	89 1c 24             	mov    %ebx,(%esp)
80104c88:	e8 83 c9 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
80104c8d:	89 1c 24             	mov    %ebx,(%esp)
80104c90:	e8 9b cc ff ff       	call   80101930 <iunlockput>
  end_op();
80104c95:	e8 06 df ff ff       	call   80102ba0 <end_op>
}
80104c9a:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104c9d:	31 c0                	xor    %eax,%eax
}
80104c9f:	5b                   	pop    %ebx
80104ca0:	5e                   	pop    %esi
80104ca1:	5f                   	pop    %edi
80104ca2:	5d                   	pop    %ebp
80104ca3:	c3                   	ret    
80104ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104ca8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104cac:	0f 86 79 ff ff ff    	jbe    80104c2b <sys_unlink+0xbb>
80104cb2:	bf 20 00 00 00       	mov    $0x20,%edi
80104cb7:	eb 15                	jmp    80104cce <sys_unlink+0x15e>
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cc0:	8d 57 10             	lea    0x10(%edi),%edx
80104cc3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104cc6:	0f 83 5f ff ff ff    	jae    80104c2b <sys_unlink+0xbb>
80104ccc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cce:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104cd5:	00 
80104cd6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104cda:	89 74 24 04          	mov    %esi,0x4(%esp)
80104cde:	89 1c 24             	mov    %ebx,(%esp)
80104ce1:	e8 9a cc ff ff       	call   80101980 <readi>
80104ce6:	83 f8 10             	cmp    $0x10,%eax
80104ce9:	75 42                	jne    80104d2d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104ceb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104cf0:	74 ce                	je     80104cc0 <sys_unlink+0x150>
    iunlockput(ip);
80104cf2:	89 1c 24             	mov    %ebx,(%esp)
80104cf5:	e8 36 cc ff ff       	call   80101930 <iunlockput>
  iunlockput(dp);
80104cfa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cfd:	89 04 24             	mov    %eax,(%esp)
80104d00:	e8 2b cc ff ff       	call   80101930 <iunlockput>
  end_op();
80104d05:	e8 96 de ff ff       	call   80102ba0 <end_op>
}
80104d0a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104d0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d12:	5b                   	pop    %ebx
80104d13:	5e                   	pop    %esi
80104d14:	5f                   	pop    %edi
80104d15:	5d                   	pop    %ebp
80104d16:	c3                   	ret    
80104d17:	90                   	nop
    dp->nlink--;
80104d18:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d1b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104d20:	89 04 24             	mov    %eax,(%esp)
80104d23:	e8 e8 c8 ff ff       	call   80101610 <iupdate>
80104d28:	e9 48 ff ff ff       	jmp    80104c75 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104d2d:	c7 04 24 a0 75 10 80 	movl   $0x801075a0,(%esp)
80104d34:	e8 27 b6 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104d39:	c7 04 24 b2 75 10 80 	movl   $0x801075b2,(%esp)
80104d40:	e8 1b b6 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104d45:	c7 04 24 8e 75 10 80 	movl   $0x8010758e,(%esp)
80104d4c:	e8 0f b6 ff ff       	call   80100360 <panic>
80104d51:	eb 0d                	jmp    80104d60 <sys_open>
80104d53:	90                   	nop
80104d54:	90                   	nop
80104d55:	90                   	nop
80104d56:	90                   	nop
80104d57:	90                   	nop
80104d58:	90                   	nop
80104d59:	90                   	nop
80104d5a:	90                   	nop
80104d5b:	90                   	nop
80104d5c:	90                   	nop
80104d5d:	90                   	nop
80104d5e:	90                   	nop
80104d5f:	90                   	nop

80104d60 <sys_open>:

int
sys_open(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	57                   	push   %edi
80104d64:	56                   	push   %esi
80104d65:	53                   	push   %ebx
80104d66:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104d69:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d77:	e8 34 f8 ff ff       	call   801045b0 <argstr>
80104d7c:	85 c0                	test   %eax,%eax
80104d7e:	0f 88 d1 00 00 00    	js     80104e55 <sys_open+0xf5>
80104d84:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104d87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104d92:	e8 b9 f7 ff ff       	call   80104550 <argint>
80104d97:	85 c0                	test   %eax,%eax
80104d99:	0f 88 b6 00 00 00    	js     80104e55 <sys_open+0xf5>
    return -1;

  begin_op();
80104d9f:	e8 8c dd ff ff       	call   80102b30 <begin_op>

  if(omode & O_CREATE){
80104da4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104da8:	0f 85 82 00 00 00    	jne    80104e30 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104dae:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104db1:	89 04 24             	mov    %eax,(%esp)
80104db4:	e8 67 d1 ff ff       	call   80101f20 <namei>
80104db9:	85 c0                	test   %eax,%eax
80104dbb:	89 c6                	mov    %eax,%esi
80104dbd:	0f 84 8d 00 00 00    	je     80104e50 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104dc3:	89 04 24             	mov    %eax,(%esp)
80104dc6:	e8 05 c9 ff ff       	call   801016d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104dcb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104dd0:	0f 84 92 00 00 00    	je     80104e68 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104dd6:	e8 a5 bf ff ff       	call   80100d80 <filealloc>
80104ddb:	85 c0                	test   %eax,%eax
80104ddd:	89 c3                	mov    %eax,%ebx
80104ddf:	0f 84 93 00 00 00    	je     80104e78 <sys_open+0x118>
80104de5:	e8 86 f8 ff ff       	call   80104670 <fdalloc>
80104dea:	85 c0                	test   %eax,%eax
80104dec:	89 c7                	mov    %eax,%edi
80104dee:	0f 88 94 00 00 00    	js     80104e88 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104df4:	89 34 24             	mov    %esi,(%esp)
80104df7:	e8 b4 c9 ff ff       	call   801017b0 <iunlock>
  end_op();
80104dfc:	e8 9f dd ff ff       	call   80102ba0 <end_op>

  f->type = FD_INODE;
80104e01:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104e0a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104e0d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e14:	89 c2                	mov    %eax,%edx
80104e16:	83 e2 01             	and    $0x1,%edx
80104e19:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e1c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104e1e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104e21:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e23:	0f 95 43 09          	setne  0x9(%ebx)
}
80104e27:	83 c4 2c             	add    $0x2c,%esp
80104e2a:	5b                   	pop    %ebx
80104e2b:	5e                   	pop    %esi
80104e2c:	5f                   	pop    %edi
80104e2d:	5d                   	pop    %ebp
80104e2e:	c3                   	ret    
80104e2f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e33:	31 c9                	xor    %ecx,%ecx
80104e35:	ba 02 00 00 00       	mov    $0x2,%edx
80104e3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e41:	e8 6a f8 ff ff       	call   801046b0 <create>
    if(ip == 0){
80104e46:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104e48:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104e4a:	75 8a                	jne    80104dd6 <sys_open+0x76>
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104e50:	e8 4b dd ff ff       	call   80102ba0 <end_op>
}
80104e55:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e5d:	5b                   	pop    %ebx
80104e5e:	5e                   	pop    %esi
80104e5f:	5f                   	pop    %edi
80104e60:	5d                   	pop    %ebp
80104e61:	c3                   	ret    
80104e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e6b:	85 c0                	test   %eax,%eax
80104e6d:	0f 84 63 ff ff ff    	je     80104dd6 <sys_open+0x76>
80104e73:	90                   	nop
80104e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104e78:	89 34 24             	mov    %esi,(%esp)
80104e7b:	e8 b0 ca ff ff       	call   80101930 <iunlockput>
80104e80:	eb ce                	jmp    80104e50 <sys_open+0xf0>
80104e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104e88:	89 1c 24             	mov    %ebx,(%esp)
80104e8b:	e8 b0 bf ff ff       	call   80100e40 <fileclose>
80104e90:	eb e6                	jmp    80104e78 <sys_open+0x118>
80104e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <sys_mkdir>:

int
sys_mkdir(void)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104ea6:	e8 85 dc ff ff       	call   80102b30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104eab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eae:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104eb9:	e8 f2 f6 ff ff       	call   801045b0 <argstr>
80104ebe:	85 c0                	test   %eax,%eax
80104ec0:	78 2e                	js     80104ef0 <sys_mkdir+0x50>
80104ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec5:	31 c9                	xor    %ecx,%ecx
80104ec7:	ba 01 00 00 00       	mov    $0x1,%edx
80104ecc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ed3:	e8 d8 f7 ff ff       	call   801046b0 <create>
80104ed8:	85 c0                	test   %eax,%eax
80104eda:	74 14                	je     80104ef0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104edc:	89 04 24             	mov    %eax,(%esp)
80104edf:	e8 4c ca ff ff       	call   80101930 <iunlockput>
  end_op();
80104ee4:	e8 b7 dc ff ff       	call   80102ba0 <end_op>
  return 0;
80104ee9:	31 c0                	xor    %eax,%eax
}
80104eeb:	c9                   	leave  
80104eec:	c3                   	ret    
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104ef0:	e8 ab dc ff ff       	call   80102ba0 <end_op>
    return -1;
80104ef5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104efa:	c9                   	leave  
80104efb:	c3                   	ret    
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f00 <sys_mknod>:

int
sys_mknod(void)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104f06:	e8 25 dc ff ff       	call   80102b30 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104f0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f19:	e8 92 f6 ff ff       	call   801045b0 <argstr>
80104f1e:	85 c0                	test   %eax,%eax
80104f20:	78 5e                	js     80104f80 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104f22:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f25:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f30:	e8 1b f6 ff ff       	call   80104550 <argint>
  if((argstr(0, &path)) < 0 ||
80104f35:	85 c0                	test   %eax,%eax
80104f37:	78 47                	js     80104f80 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104f39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f40:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104f47:	e8 04 f6 ff ff       	call   80104550 <argint>
     argint(1, &major) < 0 ||
80104f4c:	85 c0                	test   %eax,%eax
80104f4e:	78 30                	js     80104f80 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f50:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80104f54:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f59:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104f5d:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f63:	e8 48 f7 ff ff       	call   801046b0 <create>
80104f68:	85 c0                	test   %eax,%eax
80104f6a:	74 14                	je     80104f80 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f6c:	89 04 24             	mov    %eax,(%esp)
80104f6f:	e8 bc c9 ff ff       	call   80101930 <iunlockput>
  end_op();
80104f74:	e8 27 dc ff ff       	call   80102ba0 <end_op>
  return 0;
80104f79:	31 c0                	xor    %eax,%eax
}
80104f7b:	c9                   	leave  
80104f7c:	c3                   	ret    
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104f80:	e8 1b dc ff ff       	call   80102ba0 <end_op>
    return -1;
80104f85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f8a:	c9                   	leave  
80104f8b:	c3                   	ret    
80104f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f90 <sys_chdir>:

int
sys_chdir(void)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
80104f95:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104f98:	e8 23 e7 ff ff       	call   801036c0 <myproc>
80104f9d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104f9f:	e8 8c db ff ff       	call   80102b30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fb2:	e8 f9 f5 ff ff       	call   801045b0 <argstr>
80104fb7:	85 c0                	test   %eax,%eax
80104fb9:	78 4a                	js     80105005 <sys_chdir+0x75>
80104fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fbe:	89 04 24             	mov    %eax,(%esp)
80104fc1:	e8 5a cf ff ff       	call   80101f20 <namei>
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	89 c3                	mov    %eax,%ebx
80104fca:	74 39                	je     80105005 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
80104fcc:	89 04 24             	mov    %eax,(%esp)
80104fcf:	e8 fc c6 ff ff       	call   801016d0 <ilock>
  if(ip->type != T_DIR){
80104fd4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80104fd9:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
80104fdc:	75 22                	jne    80105000 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
80104fde:	e8 cd c7 ff ff       	call   801017b0 <iunlock>
  iput(curproc->cwd);
80104fe3:	8b 46 68             	mov    0x68(%esi),%eax
80104fe6:	89 04 24             	mov    %eax,(%esp)
80104fe9:	e8 02 c8 ff ff       	call   801017f0 <iput>
  end_op();
80104fee:	e8 ad db ff ff       	call   80102ba0 <end_op>
  curproc->cwd = ip;
  return 0;
80104ff3:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80104ff5:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80104ff8:	83 c4 20             	add    $0x20,%esp
80104ffb:	5b                   	pop    %ebx
80104ffc:	5e                   	pop    %esi
80104ffd:	5d                   	pop    %ebp
80104ffe:	c3                   	ret    
80104fff:	90                   	nop
    iunlockput(ip);
80105000:	e8 2b c9 ff ff       	call   80101930 <iunlockput>
    end_op();
80105005:	e8 96 db ff ff       	call   80102ba0 <end_op>
}
8010500a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010500d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105012:	5b                   	pop    %ebx
80105013:	5e                   	pop    %esi
80105014:	5d                   	pop    %ebp
80105015:	c3                   	ret    
80105016:	8d 76 00             	lea    0x0(%esi),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <sys_exec>:

int
sys_exec(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
80105025:	53                   	push   %ebx
80105026:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010502c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105032:	89 44 24 04          	mov    %eax,0x4(%esp)
80105036:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010503d:	e8 6e f5 ff ff       	call   801045b0 <argstr>
80105042:	85 c0                	test   %eax,%eax
80105044:	0f 88 84 00 00 00    	js     801050ce <sys_exec+0xae>
8010504a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105050:	89 44 24 04          	mov    %eax,0x4(%esp)
80105054:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010505b:	e8 f0 f4 ff ff       	call   80104550 <argint>
80105060:	85 c0                	test   %eax,%eax
80105062:	78 6a                	js     801050ce <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105064:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010506a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010506c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105073:	00 
80105074:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010507a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105081:	00 
80105082:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105088:	89 04 24             	mov    %eax,(%esp)
8010508b:	e8 10 f2 ff ff       	call   801042a0 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105090:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105096:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010509a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010509d:	89 04 24             	mov    %eax,(%esp)
801050a0:	e8 4b f4 ff ff       	call   801044f0 <fetchint>
801050a5:	85 c0                	test   %eax,%eax
801050a7:	78 25                	js     801050ce <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801050a9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801050af:	85 c0                	test   %eax,%eax
801050b1:	74 2d                	je     801050e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801050b3:	89 74 24 04          	mov    %esi,0x4(%esp)
801050b7:	89 04 24             	mov    %eax,(%esp)
801050ba:	e8 51 f4 ff ff       	call   80104510 <fetchstr>
801050bf:	85 c0                	test   %eax,%eax
801050c1:	78 0b                	js     801050ce <sys_exec+0xae>
  for(i=0;; i++){
801050c3:	83 c3 01             	add    $0x1,%ebx
801050c6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801050c9:	83 fb 20             	cmp    $0x20,%ebx
801050cc:	75 c2                	jne    80105090 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
801050ce:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
801050d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050d9:	5b                   	pop    %ebx
801050da:	5e                   	pop    %esi
801050db:	5f                   	pop    %edi
801050dc:	5d                   	pop    %ebp
801050dd:	c3                   	ret    
801050de:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
801050e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801050e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801050ea:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
801050f0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801050f7:	00 00 00 00 
  return exec(path, argv);
801050fb:	89 04 24             	mov    %eax,(%esp)
801050fe:	e8 9d b8 ff ff       	call   801009a0 <exec>
}
80105103:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105109:	5b                   	pop    %ebx
8010510a:	5e                   	pop    %esi
8010510b:	5f                   	pop    %edi
8010510c:	5d                   	pop    %ebp
8010510d:	c3                   	ret    
8010510e:	66 90                	xchg   %ax,%ax

80105110 <sys_pipe>:

int
sys_pipe(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	53                   	push   %ebx
80105114:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105117:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010511a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105121:	00 
80105122:	89 44 24 04          	mov    %eax,0x4(%esp)
80105126:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010512d:	e8 4e f4 ff ff       	call   80104580 <argptr>
80105132:	85 c0                	test   %eax,%eax
80105134:	78 6d                	js     801051a3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105136:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105139:	89 44 24 04          	mov    %eax,0x4(%esp)
8010513d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105140:	89 04 24             	mov    %eax,(%esp)
80105143:	e8 48 e0 ff ff       	call   80103190 <pipealloc>
80105148:	85 c0                	test   %eax,%eax
8010514a:	78 57                	js     801051a3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010514c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010514f:	e8 1c f5 ff ff       	call   80104670 <fdalloc>
80105154:	85 c0                	test   %eax,%eax
80105156:	89 c3                	mov    %eax,%ebx
80105158:	78 33                	js     8010518d <sys_pipe+0x7d>
8010515a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010515d:	e8 0e f5 ff ff       	call   80104670 <fdalloc>
80105162:	85 c0                	test   %eax,%eax
80105164:	78 1a                	js     80105180 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105166:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105169:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010516b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010516e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105171:	83 c4 24             	add    $0x24,%esp
  return 0;
80105174:	31 c0                	xor    %eax,%eax
}
80105176:	5b                   	pop    %ebx
80105177:	5d                   	pop    %ebp
80105178:	c3                   	ret    
80105179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105180:	e8 3b e5 ff ff       	call   801036c0 <myproc>
80105185:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010518c:	00 
    fileclose(rf);
8010518d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105190:	89 04 24             	mov    %eax,(%esp)
80105193:	e8 a8 bc ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519b:	89 04 24             	mov    %eax,(%esp)
8010519e:	e8 9d bc ff ff       	call   80100e40 <fileclose>
}
801051a3:	83 c4 24             	add    $0x24,%esp
    return -1;
801051a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051ab:	5b                   	pop    %ebx
801051ac:	5d                   	pop    %ebp
801051ad:	c3                   	ret    
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
801051b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051c4:	e8 87 f3 ff ff       	call   80104550 <argint>
801051c9:	85 c0                	test   %eax,%eax
801051cb:	78 33                	js     80105200 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
801051cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051d0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801051d7:	00 
801051d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801051dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051e3:	e8 98 f3 ff ff       	call   80104580 <argptr>
801051e8:	85 c0                	test   %eax,%eax
801051ea:	78 14                	js     80105200 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
801051ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801051f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051f6:	89 04 24             	mov    %eax,(%esp)
801051f9:	e8 f2 1b 00 00       	call   80106df0 <shm_open>
}
801051fe:	c9                   	leave  
801051ff:	c3                   	ret    
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105205:	c9                   	leave  
80105206:	c3                   	ret    
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105210 <sys_shm_close>:

int sys_shm_close(void) {
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105216:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105219:	89 44 24 04          	mov    %eax,0x4(%esp)
8010521d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105224:	e8 27 f3 ff ff       	call   80104550 <argint>
80105229:	85 c0                	test   %eax,%eax
8010522b:	78 13                	js     80105240 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
8010522d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105230:	89 04 24             	mov    %eax,(%esp)
80105233:	e8 c8 1b 00 00       	call   80106e00 <shm_close>
}
80105238:	c9                   	leave  
80105239:	c3                   	ret    
8010523a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sys_fork>:

int
sys_fork(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105253:	5d                   	pop    %ebp
  return fork();
80105254:	e9 17 e6 ff ff       	jmp    80103870 <fork>
80105259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105260 <sys_exit>:

int
sys_exit(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	83 ec 08             	sub    $0x8,%esp
  exit();
80105266:	e8 55 e8 ff ff       	call   80103ac0 <exit>
  return 0;  // not reached
}
8010526b:	31 c0                	xor    %eax,%eax
8010526d:	c9                   	leave  
8010526e:	c3                   	ret    
8010526f:	90                   	nop

80105270 <sys_wait>:

int
sys_wait(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105273:	5d                   	pop    %ebp
  return wait();
80105274:	e9 57 ea ff ff       	jmp    80103cd0 <wait>
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105280 <sys_kill>:

int
sys_kill(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105286:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105289:	89 44 24 04          	mov    %eax,0x4(%esp)
8010528d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105294:	e8 b7 f2 ff ff       	call   80104550 <argint>
80105299:	85 c0                	test   %eax,%eax
8010529b:	78 13                	js     801052b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010529d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a0:	89 04 24             	mov    %eax,(%esp)
801052a3:	e8 68 eb ff ff       	call   80103e10 <kill>
}
801052a8:	c9                   	leave  
801052a9:	c3                   	ret    
801052aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052b5:	c9                   	leave  
801052b6:	c3                   	ret    
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <sys_getpid>:

int
sys_getpid(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801052c6:	e8 f5 e3 ff ff       	call   801036c0 <myproc>
801052cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801052ce:	c9                   	leave  
801052cf:	c3                   	ret    

801052d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	53                   	push   %ebx
801052d4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801052d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052da:	89 44 24 04          	mov    %eax,0x4(%esp)
801052de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052e5:	e8 66 f2 ff ff       	call   80104550 <argint>
801052ea:	85 c0                	test   %eax,%eax
801052ec:	78 22                	js     80105310 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801052ee:	e8 cd e3 ff ff       	call   801036c0 <myproc>
  if(growproc(n) < 0)
801052f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
801052f6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801052f8:	89 14 24             	mov    %edx,(%esp)
801052fb:	e8 00 e5 ff ff       	call   80103800 <growproc>
80105300:	85 c0                	test   %eax,%eax
80105302:	78 0c                	js     80105310 <sys_sbrk+0x40>
    return -1;
  return addr;
80105304:	89 d8                	mov    %ebx,%eax
}
80105306:	83 c4 24             	add    $0x24,%esp
80105309:	5b                   	pop    %ebx
8010530a:	5d                   	pop    %ebp
8010530b:	c3                   	ret    
8010530c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105315:	eb ef                	jmp    80105306 <sys_sbrk+0x36>
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <sys_sleep>:

int
sys_sleep(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	53                   	push   %ebx
80105324:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105327:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010532a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010532e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105335:	e8 16 f2 ff ff       	call   80104550 <argint>
8010533a:	85 c0                	test   %eax,%eax
8010533c:	78 7e                	js     801053bc <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010533e:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105345:	e8 16 ee ff ff       	call   80104160 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010534a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010534d:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105353:	85 d2                	test   %edx,%edx
80105355:	75 29                	jne    80105380 <sys_sleep+0x60>
80105357:	eb 4f                	jmp    801053a8 <sys_sleep+0x88>
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105360:	c7 44 24 04 60 4d 11 	movl   $0x80114d60,0x4(%esp)
80105367:	80 
80105368:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
8010536f:	e8 ac e8 ff ff       	call   80103c20 <sleep>
  while(ticks - ticks0 < n){
80105374:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105379:	29 d8                	sub    %ebx,%eax
8010537b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010537e:	73 28                	jae    801053a8 <sys_sleep+0x88>
    if(myproc()->killed){
80105380:	e8 3b e3 ff ff       	call   801036c0 <myproc>
80105385:	8b 40 24             	mov    0x24(%eax),%eax
80105388:	85 c0                	test   %eax,%eax
8010538a:	74 d4                	je     80105360 <sys_sleep+0x40>
      release(&tickslock);
8010538c:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105393:	e8 b8 ee ff ff       	call   80104250 <release>
      return -1;
80105398:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010539d:	83 c4 24             	add    $0x24,%esp
801053a0:	5b                   	pop    %ebx
801053a1:	5d                   	pop    %ebp
801053a2:	c3                   	ret    
801053a3:	90                   	nop
801053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
801053a8:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053af:	e8 9c ee ff ff       	call   80104250 <release>
}
801053b4:	83 c4 24             	add    $0x24,%esp
  return 0;
801053b7:	31 c0                	xor    %eax,%eax
}
801053b9:	5b                   	pop    %ebx
801053ba:	5d                   	pop    %ebp
801053bb:	c3                   	ret    
    return -1;
801053bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c1:	eb da                	jmp    8010539d <sys_sleep+0x7d>
801053c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	53                   	push   %ebx
801053d4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801053d7:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053de:	e8 7d ed ff ff       	call   80104160 <acquire>
  xticks = ticks;
801053e3:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801053e9:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801053f0:	e8 5b ee ff ff       	call   80104250 <release>
  return xticks;
}
801053f5:	83 c4 14             	add    $0x14,%esp
801053f8:	89 d8                	mov    %ebx,%eax
801053fa:	5b                   	pop    %ebx
801053fb:	5d                   	pop    %ebp
801053fc:	c3                   	ret    

801053fd <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801053fd:	1e                   	push   %ds
  pushl %es
801053fe:	06                   	push   %es
  pushl %fs
801053ff:	0f a0                	push   %fs
  pushl %gs
80105401:	0f a8                	push   %gs
  pushal
80105403:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105404:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105408:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010540a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010540c:	54                   	push   %esp
  call trap
8010540d:	e8 de 00 00 00       	call   801054f0 <trap>
  addl $4, %esp
80105412:	83 c4 04             	add    $0x4,%esp

80105415 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105415:	61                   	popa   
  popl %gs
80105416:	0f a9                	pop    %gs
  popl %fs
80105418:	0f a1                	pop    %fs
  popl %es
8010541a:	07                   	pop    %es
  popl %ds
8010541b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010541c:	83 c4 08             	add    $0x8,%esp
  iret
8010541f:	cf                   	iret   

80105420 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105420:	31 c0                	xor    %eax,%eax
80105422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105428:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010542f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105434:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
8010543b:	80 
8010543c:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
80105443:	00 
80105444:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
8010544b:	8e 
8010544c:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105453:	80 
80105454:	c1 ea 10             	shr    $0x10,%edx
80105457:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
8010545e:	80 
  for(i = 0; i < 256; i++)
8010545f:	83 c0 01             	add    $0x1,%eax
80105462:	3d 00 01 00 00       	cmp    $0x100,%eax
80105467:	75 bf                	jne    80105428 <tvinit+0x8>
{
80105469:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010546a:	ba 08 00 00 00       	mov    $0x8,%edx
{
8010546f:	89 e5                	mov    %esp,%ebp
80105471:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105474:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105479:	c7 44 24 04 c1 75 10 	movl   $0x801075c1,0x4(%esp)
80105480:	80 
80105481:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105488:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
8010548f:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105495:	c1 e8 10             	shr    $0x10,%eax
80105498:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
8010549f:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
801054a6:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
801054ac:	e8 bf eb ff ff       	call   80104070 <initlock>
}
801054b1:	c9                   	leave  
801054b2:	c3                   	ret    
801054b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054c0 <idtinit>:

void
idtinit(void)
{
801054c0:	55                   	push   %ebp
  pd[0] = size-1;
801054c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801054c6:	89 e5                	mov    %esp,%ebp
801054c8:	83 ec 10             	sub    $0x10,%esp
801054cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801054cf:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
801054d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801054d8:	c1 e8 10             	shr    $0x10,%eax
801054db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801054df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801054e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801054e5:	c9                   	leave  
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
801054f5:	53                   	push   %ebx
801054f6:	83 ec 3c             	sub    $0x3c,%esp
801054f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801054fc:	8b 43 30             	mov    0x30(%ebx),%eax
801054ff:	83 f8 40             	cmp    $0x40,%eax
80105502:	0f 84 b0 01 00 00    	je     801056b8 <trap+0x1c8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105508:	83 e8 0e             	sub    $0xe,%eax
8010550b:	83 f8 31             	cmp    $0x31,%eax
8010550e:	77 16                	ja     80105526 <trap+0x36>
80105510:	ff 24 85 88 76 10 80 	jmp    *-0x7fef8978(,%eax,4)
80105517:	90                   	nop

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105518:	0f 20 d0             	mov    %cr2,%eax
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
    
  case T_PGFLT:
    if (rcr2() < STACKBASE) {
8010551b:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
80105520:	0f 86 0a 02 00 00    	jbe    80105730 <trap+0x240>
	  break;
	}

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105526:	e8 95 e1 ff ff       	call   801036c0 <myproc>
8010552b:	85 c0                	test   %eax,%eax
8010552d:	0f 84 61 02 00 00    	je     80105794 <trap+0x2a4>
80105533:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105537:	0f 84 57 02 00 00    	je     80105794 <trap+0x2a4>
8010553d:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105540:	8b 53 38             	mov    0x38(%ebx),%edx
80105543:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105546:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105549:	e8 52 e1 ff ff       	call   801036a0 <cpuid>
8010554e:	8b 73 30             	mov    0x30(%ebx),%esi
80105551:	89 c7                	mov    %eax,%edi
80105553:	8b 43 34             	mov    0x34(%ebx),%eax
80105556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105559:	e8 62 e1 ff ff       	call   801036c0 <myproc>
8010555e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105561:	e8 5a e1 ff ff       	call   801036c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105566:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105569:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
8010556d:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105570:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105573:	89 7c 24 14          	mov    %edi,0x14(%esp)
80105577:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010557a:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
8010557e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105581:	89 54 24 18          	mov    %edx,0x18(%esp)
80105585:	89 7c 24 10          	mov    %edi,0x10(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105589:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010558d:	8b 40 10             	mov    0x10(%eax),%eax
80105590:	c7 04 24 44 76 10 80 	movl   $0x80107644,(%esp)
80105597:	89 44 24 04          	mov    %eax,0x4(%esp)
8010559b:	e8 b0 b0 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801055a0:	e8 1b e1 ff ff       	call   801036c0 <myproc>
801055a5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055ac:	e8 0f e1 ff ff       	call   801036c0 <myproc>
801055b1:	85 c0                	test   %eax,%eax
801055b3:	74 0c                	je     801055c1 <trap+0xd1>
801055b5:	e8 06 e1 ff ff       	call   801036c0 <myproc>
801055ba:	8b 50 24             	mov    0x24(%eax),%edx
801055bd:	85 d2                	test   %edx,%edx
801055bf:	75 4f                	jne    80105610 <trap+0x120>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801055c1:	e8 fa e0 ff ff       	call   801036c0 <myproc>
801055c6:	85 c0                	test   %eax,%eax
801055c8:	74 11                	je     801055db <trap+0xeb>
801055ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055d0:	e8 eb e0 ff ff       	call   801036c0 <myproc>
801055d5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801055d9:	74 4d                	je     80105628 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055db:	e8 e0 e0 ff ff       	call   801036c0 <myproc>
801055e0:	85 c0                	test   %eax,%eax
801055e2:	74 1d                	je     80105601 <trap+0x111>
801055e4:	e8 d7 e0 ff ff       	call   801036c0 <myproc>
801055e9:	8b 40 24             	mov    0x24(%eax),%eax
801055ec:	85 c0                	test   %eax,%eax
801055ee:	74 11                	je     80105601 <trap+0x111>
801055f0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801055f4:	83 e0 03             	and    $0x3,%eax
801055f7:	66 83 f8 03          	cmp    $0x3,%ax
801055fb:	0f 84 e8 00 00 00    	je     801056e9 <trap+0x1f9>
    exit();
}
80105601:	83 c4 3c             	add    $0x3c,%esp
80105604:	5b                   	pop    %ebx
80105605:	5e                   	pop    %esi
80105606:	5f                   	pop    %edi
80105607:	5d                   	pop    %ebp
80105608:	c3                   	ret    
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105610:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105614:	83 e0 03             	and    $0x3,%eax
80105617:	66 83 f8 03          	cmp    $0x3,%ax
8010561b:	75 a4                	jne    801055c1 <trap+0xd1>
    exit();
8010561d:	e8 9e e4 ff ff       	call   80103ac0 <exit>
80105622:	eb 9d                	jmp    801055c1 <trap+0xd1>
80105624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105628:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105630:	75 a9                	jne    801055db <trap+0xeb>
    yield();
80105632:	e8 a9 e5 ff ff       	call   80103be0 <yield>
80105637:	eb a2                	jmp    801055db <trap+0xeb>
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105640:	e8 5b e0 ff ff       	call   801036a0 <cpuid>
80105645:	85 c0                	test   %eax,%eax
80105647:	0f 84 b3 00 00 00    	je     80105700 <trap+0x210>
8010564d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105650:	e8 4b d1 ff ff       	call   801027a0 <lapiceoi>
    break;
80105655:	e9 52 ff ff ff       	jmp    801055ac <trap+0xbc>
8010565a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105660:	e8 8b cf ff ff       	call   801025f0 <kbdintr>
    lapiceoi();
80105665:	e8 36 d1 ff ff       	call   801027a0 <lapiceoi>
    break;
8010566a:	e9 3d ff ff ff       	jmp    801055ac <trap+0xbc>
8010566f:	90                   	nop
    uartintr();
80105670:	e8 7b 02 00 00       	call   801058f0 <uartintr>
    lapiceoi();
80105675:	e8 26 d1 ff ff       	call   801027a0 <lapiceoi>
    break;
8010567a:	e9 2d ff ff ff       	jmp    801055ac <trap+0xbc>
8010567f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105680:	8b 7b 38             	mov    0x38(%ebx),%edi
80105683:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105687:	e8 14 e0 ff ff       	call   801036a0 <cpuid>
8010568c:	c7 04 24 cc 75 10 80 	movl   $0x801075cc,(%esp)
80105693:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105697:	89 74 24 08          	mov    %esi,0x8(%esp)
8010569b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010569f:	e8 ac af ff ff       	call   80100650 <cprintf>
    lapiceoi();
801056a4:	e8 f7 d0 ff ff       	call   801027a0 <lapiceoi>
    break;
801056a9:	e9 fe fe ff ff       	jmp    801055ac <trap+0xbc>
801056ae:	66 90                	xchg   %ax,%ax
    ideintr();
801056b0:	e8 eb c9 ff ff       	call   801020a0 <ideintr>
801056b5:	eb 96                	jmp    8010564d <trap+0x15d>
801056b7:	90                   	nop
801056b8:	90                   	nop
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801056c0:	e8 fb df ff ff       	call   801036c0 <myproc>
801056c5:	8b 70 24             	mov    0x24(%eax),%esi
801056c8:	85 f6                	test   %esi,%esi
801056ca:	75 2c                	jne    801056f8 <trap+0x208>
    myproc()->tf = tf;
801056cc:	e8 ef df ff ff       	call   801036c0 <myproc>
801056d1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801056d4:	e8 27 ef ff ff       	call   80104600 <syscall>
    if(myproc()->killed)
801056d9:	e8 e2 df ff ff       	call   801036c0 <myproc>
801056de:	8b 48 24             	mov    0x24(%eax),%ecx
801056e1:	85 c9                	test   %ecx,%ecx
801056e3:	0f 84 18 ff ff ff    	je     80105601 <trap+0x111>
}
801056e9:	83 c4 3c             	add    $0x3c,%esp
801056ec:	5b                   	pop    %ebx
801056ed:	5e                   	pop    %esi
801056ee:	5f                   	pop    %edi
801056ef:	5d                   	pop    %ebp
      exit();
801056f0:	e9 cb e3 ff ff       	jmp    80103ac0 <exit>
801056f5:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
801056f8:	e8 c3 e3 ff ff       	call   80103ac0 <exit>
801056fd:	eb cd                	jmp    801056cc <trap+0x1dc>
801056ff:	90                   	nop
      acquire(&tickslock);
80105700:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105707:	e8 54 ea ff ff       	call   80104160 <acquire>
      wakeup(&ticks);
8010570c:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105713:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
8010571a:	e8 91 e6 ff ff       	call   80103db0 <wakeup>
      release(&tickslock);
8010571f:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105726:	e8 25 eb ff ff       	call   80104250 <release>
8010572b:	e9 1d ff ff ff       	jmp    8010564d <trap+0x15d>
	  allocuvm(myproc()->pgdir, STACKBASE-((myproc()->npages+1)*PGSIZE), STACKBASE-((myproc()->npages)*PGSIZE));
80105730:	e8 8b df ff ff       	call   801036c0 <myproc>
80105735:	8b 40 7c             	mov    0x7c(%eax),%eax
80105738:	f7 d8                	neg    %eax
8010573a:	c1 e0 0c             	shl    $0xc,%eax
8010573d:	8d b0 fc ff ff 7f    	lea    0x7ffffffc(%eax),%esi
80105743:	e8 78 df ff ff       	call   801036c0 <myproc>
80105748:	8b 40 7c             	mov    0x7c(%eax),%eax
8010574b:	f7 d0                	not    %eax
8010574d:	c1 e0 0c             	shl    $0xc,%eax
80105750:	8d b8 fc ff ff 7f    	lea    0x7ffffffc(%eax),%edi
80105756:	e8 65 df ff ff       	call   801036c0 <myproc>
8010575b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010575f:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105763:	8b 40 04             	mov    0x4(%eax),%eax
80105766:	89 04 24             	mov    %eax,(%esp)
80105769:	e8 02 11 00 00       	call   80106870 <allocuvm>
	  myproc()->npages++;
8010576e:	e8 4d df ff ff       	call   801036c0 <myproc>
80105773:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
	  cprintf("Number of pages allocated: %d\n", myproc()->npages);
80105777:	e8 44 df ff ff       	call   801036c0 <myproc>
8010577c:	8b 40 7c             	mov    0x7c(%eax),%eax
8010577f:	c7 04 24 f0 75 10 80 	movl   $0x801075f0,(%esp)
80105786:	89 44 24 04          	mov    %eax,0x4(%esp)
8010578a:	e8 c1 ae ff ff       	call   80100650 <cprintf>
	  break;
8010578f:	e9 18 fe ff ff       	jmp    801055ac <trap+0xbc>
80105794:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105797:	8b 73 38             	mov    0x38(%ebx),%esi
8010579a:	e8 01 df ff ff       	call   801036a0 <cpuid>
8010579f:	89 7c 24 10          	mov    %edi,0x10(%esp)
801057a3:	89 74 24 0c          	mov    %esi,0xc(%esp)
801057a7:	89 44 24 08          	mov    %eax,0x8(%esp)
801057ab:	8b 43 30             	mov    0x30(%ebx),%eax
801057ae:	c7 04 24 10 76 10 80 	movl   $0x80107610,(%esp)
801057b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801057b9:	e8 92 ae ff ff       	call   80100650 <cprintf>
      panic("trap");
801057be:	c7 04 24 c6 75 10 80 	movl   $0x801075c6,(%esp)
801057c5:	e8 96 ab ff ff       	call   80100360 <panic>
801057ca:	66 90                	xchg   %ax,%ax
801057cc:	66 90                	xchg   %ax,%ax
801057ce:	66 90                	xchg   %ax,%ax

801057d0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801057d0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
801057d5:	55                   	push   %ebp
801057d6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801057d8:	85 c0                	test   %eax,%eax
801057da:	74 14                	je     801057f0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801057dc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801057e1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801057e2:	a8 01                	test   $0x1,%al
801057e4:	74 0a                	je     801057f0 <uartgetc+0x20>
801057e6:	b2 f8                	mov    $0xf8,%dl
801057e8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801057e9:	0f b6 c0             	movzbl %al,%eax
}
801057ec:	5d                   	pop    %ebp
801057ed:	c3                   	ret    
801057ee:	66 90                	xchg   %ax,%ax
    return -1;
801057f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f5:	5d                   	pop    %ebp
801057f6:	c3                   	ret    
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105800 <uartputc>:
  if(!uart)
80105800:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105805:	85 c0                	test   %eax,%eax
80105807:	74 3f                	je     80105848 <uartputc+0x48>
{
80105809:	55                   	push   %ebp
8010580a:	89 e5                	mov    %esp,%ebp
8010580c:	56                   	push   %esi
8010580d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105812:	53                   	push   %ebx
  if(!uart)
80105813:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105818:	83 ec 10             	sub    $0x10,%esp
8010581b:	eb 14                	jmp    80105831 <uartputc+0x31>
8010581d:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105820:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105827:	e8 94 cf ff ff       	call   801027c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010582c:	83 eb 01             	sub    $0x1,%ebx
8010582f:	74 07                	je     80105838 <uartputc+0x38>
80105831:	89 f2                	mov    %esi,%edx
80105833:	ec                   	in     (%dx),%al
80105834:	a8 20                	test   $0x20,%al
80105836:	74 e8                	je     80105820 <uartputc+0x20>
  outb(COM1+0, c);
80105838:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010583c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105841:	ee                   	out    %al,(%dx)
}
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	5b                   	pop    %ebx
80105846:	5e                   	pop    %esi
80105847:	5d                   	pop    %ebp
80105848:	f3 c3                	repz ret 
8010584a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105850 <uartinit>:
{
80105850:	55                   	push   %ebp
80105851:	31 c9                	xor    %ecx,%ecx
80105853:	89 e5                	mov    %esp,%ebp
80105855:	89 c8                	mov    %ecx,%eax
80105857:	57                   	push   %edi
80105858:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010585d:	56                   	push   %esi
8010585e:	89 fa                	mov    %edi,%edx
80105860:	53                   	push   %ebx
80105861:	83 ec 1c             	sub    $0x1c,%esp
80105864:	ee                   	out    %al,(%dx)
80105865:	be fb 03 00 00       	mov    $0x3fb,%esi
8010586a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010586f:	89 f2                	mov    %esi,%edx
80105871:	ee                   	out    %al,(%dx)
80105872:	b8 0c 00 00 00       	mov    $0xc,%eax
80105877:	b2 f8                	mov    $0xf8,%dl
80105879:	ee                   	out    %al,(%dx)
8010587a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010587f:	89 c8                	mov    %ecx,%eax
80105881:	89 da                	mov    %ebx,%edx
80105883:	ee                   	out    %al,(%dx)
80105884:	b8 03 00 00 00       	mov    $0x3,%eax
80105889:	89 f2                	mov    %esi,%edx
8010588b:	ee                   	out    %al,(%dx)
8010588c:	b2 fc                	mov    $0xfc,%dl
8010588e:	89 c8                	mov    %ecx,%eax
80105890:	ee                   	out    %al,(%dx)
80105891:	b8 01 00 00 00       	mov    $0x1,%eax
80105896:	89 da                	mov    %ebx,%edx
80105898:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105899:	b2 fd                	mov    $0xfd,%dl
8010589b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010589c:	3c ff                	cmp    $0xff,%al
8010589e:	74 42                	je     801058e2 <uartinit+0x92>
  uart = 1;
801058a0:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801058a7:	00 00 00 
801058aa:	89 fa                	mov    %edi,%edx
801058ac:	ec                   	in     (%dx),%al
801058ad:	b2 f8                	mov    $0xf8,%dl
801058af:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801058b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058b7:	00 
  for(p="xv6...\n"; *p; p++)
801058b8:	bb 50 77 10 80       	mov    $0x80107750,%ebx
  ioapicenable(IRQ_COM1, 0);
801058bd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801058c4:	e8 07 ca ff ff       	call   801022d0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801058c9:	b8 78 00 00 00       	mov    $0x78,%eax
801058ce:	66 90                	xchg   %ax,%ax
    uartputc(*p);
801058d0:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
801058d3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
801058d6:	e8 25 ff ff ff       	call   80105800 <uartputc>
  for(p="xv6...\n"; *p; p++)
801058db:	0f be 03             	movsbl (%ebx),%eax
801058de:	84 c0                	test   %al,%al
801058e0:	75 ee                	jne    801058d0 <uartinit+0x80>
}
801058e2:	83 c4 1c             	add    $0x1c,%esp
801058e5:	5b                   	pop    %ebx
801058e6:	5e                   	pop    %esi
801058e7:	5f                   	pop    %edi
801058e8:	5d                   	pop    %ebp
801058e9:	c3                   	ret    
801058ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058f0 <uartintr>:

void
uartintr(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801058f6:	c7 04 24 d0 57 10 80 	movl   $0x801057d0,(%esp)
801058fd:	e8 ae ae ff ff       	call   801007b0 <consoleintr>
}
80105902:	c9                   	leave  
80105903:	c3                   	ret    

80105904 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105904:	6a 00                	push   $0x0
  pushl $0
80105906:	6a 00                	push   $0x0
  jmp alltraps
80105908:	e9 f0 fa ff ff       	jmp    801053fd <alltraps>

8010590d <vector1>:
.globl vector1
vector1:
  pushl $0
8010590d:	6a 00                	push   $0x0
  pushl $1
8010590f:	6a 01                	push   $0x1
  jmp alltraps
80105911:	e9 e7 fa ff ff       	jmp    801053fd <alltraps>

80105916 <vector2>:
.globl vector2
vector2:
  pushl $0
80105916:	6a 00                	push   $0x0
  pushl $2
80105918:	6a 02                	push   $0x2
  jmp alltraps
8010591a:	e9 de fa ff ff       	jmp    801053fd <alltraps>

8010591f <vector3>:
.globl vector3
vector3:
  pushl $0
8010591f:	6a 00                	push   $0x0
  pushl $3
80105921:	6a 03                	push   $0x3
  jmp alltraps
80105923:	e9 d5 fa ff ff       	jmp    801053fd <alltraps>

80105928 <vector4>:
.globl vector4
vector4:
  pushl $0
80105928:	6a 00                	push   $0x0
  pushl $4
8010592a:	6a 04                	push   $0x4
  jmp alltraps
8010592c:	e9 cc fa ff ff       	jmp    801053fd <alltraps>

80105931 <vector5>:
.globl vector5
vector5:
  pushl $0
80105931:	6a 00                	push   $0x0
  pushl $5
80105933:	6a 05                	push   $0x5
  jmp alltraps
80105935:	e9 c3 fa ff ff       	jmp    801053fd <alltraps>

8010593a <vector6>:
.globl vector6
vector6:
  pushl $0
8010593a:	6a 00                	push   $0x0
  pushl $6
8010593c:	6a 06                	push   $0x6
  jmp alltraps
8010593e:	e9 ba fa ff ff       	jmp    801053fd <alltraps>

80105943 <vector7>:
.globl vector7
vector7:
  pushl $0
80105943:	6a 00                	push   $0x0
  pushl $7
80105945:	6a 07                	push   $0x7
  jmp alltraps
80105947:	e9 b1 fa ff ff       	jmp    801053fd <alltraps>

8010594c <vector8>:
.globl vector8
vector8:
  pushl $8
8010594c:	6a 08                	push   $0x8
  jmp alltraps
8010594e:	e9 aa fa ff ff       	jmp    801053fd <alltraps>

80105953 <vector9>:
.globl vector9
vector9:
  pushl $0
80105953:	6a 00                	push   $0x0
  pushl $9
80105955:	6a 09                	push   $0x9
  jmp alltraps
80105957:	e9 a1 fa ff ff       	jmp    801053fd <alltraps>

8010595c <vector10>:
.globl vector10
vector10:
  pushl $10
8010595c:	6a 0a                	push   $0xa
  jmp alltraps
8010595e:	e9 9a fa ff ff       	jmp    801053fd <alltraps>

80105963 <vector11>:
.globl vector11
vector11:
  pushl $11
80105963:	6a 0b                	push   $0xb
  jmp alltraps
80105965:	e9 93 fa ff ff       	jmp    801053fd <alltraps>

8010596a <vector12>:
.globl vector12
vector12:
  pushl $12
8010596a:	6a 0c                	push   $0xc
  jmp alltraps
8010596c:	e9 8c fa ff ff       	jmp    801053fd <alltraps>

80105971 <vector13>:
.globl vector13
vector13:
  pushl $13
80105971:	6a 0d                	push   $0xd
  jmp alltraps
80105973:	e9 85 fa ff ff       	jmp    801053fd <alltraps>

80105978 <vector14>:
.globl vector14
vector14:
  pushl $14
80105978:	6a 0e                	push   $0xe
  jmp alltraps
8010597a:	e9 7e fa ff ff       	jmp    801053fd <alltraps>

8010597f <vector15>:
.globl vector15
vector15:
  pushl $0
8010597f:	6a 00                	push   $0x0
  pushl $15
80105981:	6a 0f                	push   $0xf
  jmp alltraps
80105983:	e9 75 fa ff ff       	jmp    801053fd <alltraps>

80105988 <vector16>:
.globl vector16
vector16:
  pushl $0
80105988:	6a 00                	push   $0x0
  pushl $16
8010598a:	6a 10                	push   $0x10
  jmp alltraps
8010598c:	e9 6c fa ff ff       	jmp    801053fd <alltraps>

80105991 <vector17>:
.globl vector17
vector17:
  pushl $17
80105991:	6a 11                	push   $0x11
  jmp alltraps
80105993:	e9 65 fa ff ff       	jmp    801053fd <alltraps>

80105998 <vector18>:
.globl vector18
vector18:
  pushl $0
80105998:	6a 00                	push   $0x0
  pushl $18
8010599a:	6a 12                	push   $0x12
  jmp alltraps
8010599c:	e9 5c fa ff ff       	jmp    801053fd <alltraps>

801059a1 <vector19>:
.globl vector19
vector19:
  pushl $0
801059a1:	6a 00                	push   $0x0
  pushl $19
801059a3:	6a 13                	push   $0x13
  jmp alltraps
801059a5:	e9 53 fa ff ff       	jmp    801053fd <alltraps>

801059aa <vector20>:
.globl vector20
vector20:
  pushl $0
801059aa:	6a 00                	push   $0x0
  pushl $20
801059ac:	6a 14                	push   $0x14
  jmp alltraps
801059ae:	e9 4a fa ff ff       	jmp    801053fd <alltraps>

801059b3 <vector21>:
.globl vector21
vector21:
  pushl $0
801059b3:	6a 00                	push   $0x0
  pushl $21
801059b5:	6a 15                	push   $0x15
  jmp alltraps
801059b7:	e9 41 fa ff ff       	jmp    801053fd <alltraps>

801059bc <vector22>:
.globl vector22
vector22:
  pushl $0
801059bc:	6a 00                	push   $0x0
  pushl $22
801059be:	6a 16                	push   $0x16
  jmp alltraps
801059c0:	e9 38 fa ff ff       	jmp    801053fd <alltraps>

801059c5 <vector23>:
.globl vector23
vector23:
  pushl $0
801059c5:	6a 00                	push   $0x0
  pushl $23
801059c7:	6a 17                	push   $0x17
  jmp alltraps
801059c9:	e9 2f fa ff ff       	jmp    801053fd <alltraps>

801059ce <vector24>:
.globl vector24
vector24:
  pushl $0
801059ce:	6a 00                	push   $0x0
  pushl $24
801059d0:	6a 18                	push   $0x18
  jmp alltraps
801059d2:	e9 26 fa ff ff       	jmp    801053fd <alltraps>

801059d7 <vector25>:
.globl vector25
vector25:
  pushl $0
801059d7:	6a 00                	push   $0x0
  pushl $25
801059d9:	6a 19                	push   $0x19
  jmp alltraps
801059db:	e9 1d fa ff ff       	jmp    801053fd <alltraps>

801059e0 <vector26>:
.globl vector26
vector26:
  pushl $0
801059e0:	6a 00                	push   $0x0
  pushl $26
801059e2:	6a 1a                	push   $0x1a
  jmp alltraps
801059e4:	e9 14 fa ff ff       	jmp    801053fd <alltraps>

801059e9 <vector27>:
.globl vector27
vector27:
  pushl $0
801059e9:	6a 00                	push   $0x0
  pushl $27
801059eb:	6a 1b                	push   $0x1b
  jmp alltraps
801059ed:	e9 0b fa ff ff       	jmp    801053fd <alltraps>

801059f2 <vector28>:
.globl vector28
vector28:
  pushl $0
801059f2:	6a 00                	push   $0x0
  pushl $28
801059f4:	6a 1c                	push   $0x1c
  jmp alltraps
801059f6:	e9 02 fa ff ff       	jmp    801053fd <alltraps>

801059fb <vector29>:
.globl vector29
vector29:
  pushl $0
801059fb:	6a 00                	push   $0x0
  pushl $29
801059fd:	6a 1d                	push   $0x1d
  jmp alltraps
801059ff:	e9 f9 f9 ff ff       	jmp    801053fd <alltraps>

80105a04 <vector30>:
.globl vector30
vector30:
  pushl $0
80105a04:	6a 00                	push   $0x0
  pushl $30
80105a06:	6a 1e                	push   $0x1e
  jmp alltraps
80105a08:	e9 f0 f9 ff ff       	jmp    801053fd <alltraps>

80105a0d <vector31>:
.globl vector31
vector31:
  pushl $0
80105a0d:	6a 00                	push   $0x0
  pushl $31
80105a0f:	6a 1f                	push   $0x1f
  jmp alltraps
80105a11:	e9 e7 f9 ff ff       	jmp    801053fd <alltraps>

80105a16 <vector32>:
.globl vector32
vector32:
  pushl $0
80105a16:	6a 00                	push   $0x0
  pushl $32
80105a18:	6a 20                	push   $0x20
  jmp alltraps
80105a1a:	e9 de f9 ff ff       	jmp    801053fd <alltraps>

80105a1f <vector33>:
.globl vector33
vector33:
  pushl $0
80105a1f:	6a 00                	push   $0x0
  pushl $33
80105a21:	6a 21                	push   $0x21
  jmp alltraps
80105a23:	e9 d5 f9 ff ff       	jmp    801053fd <alltraps>

80105a28 <vector34>:
.globl vector34
vector34:
  pushl $0
80105a28:	6a 00                	push   $0x0
  pushl $34
80105a2a:	6a 22                	push   $0x22
  jmp alltraps
80105a2c:	e9 cc f9 ff ff       	jmp    801053fd <alltraps>

80105a31 <vector35>:
.globl vector35
vector35:
  pushl $0
80105a31:	6a 00                	push   $0x0
  pushl $35
80105a33:	6a 23                	push   $0x23
  jmp alltraps
80105a35:	e9 c3 f9 ff ff       	jmp    801053fd <alltraps>

80105a3a <vector36>:
.globl vector36
vector36:
  pushl $0
80105a3a:	6a 00                	push   $0x0
  pushl $36
80105a3c:	6a 24                	push   $0x24
  jmp alltraps
80105a3e:	e9 ba f9 ff ff       	jmp    801053fd <alltraps>

80105a43 <vector37>:
.globl vector37
vector37:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $37
80105a45:	6a 25                	push   $0x25
  jmp alltraps
80105a47:	e9 b1 f9 ff ff       	jmp    801053fd <alltraps>

80105a4c <vector38>:
.globl vector38
vector38:
  pushl $0
80105a4c:	6a 00                	push   $0x0
  pushl $38
80105a4e:	6a 26                	push   $0x26
  jmp alltraps
80105a50:	e9 a8 f9 ff ff       	jmp    801053fd <alltraps>

80105a55 <vector39>:
.globl vector39
vector39:
  pushl $0
80105a55:	6a 00                	push   $0x0
  pushl $39
80105a57:	6a 27                	push   $0x27
  jmp alltraps
80105a59:	e9 9f f9 ff ff       	jmp    801053fd <alltraps>

80105a5e <vector40>:
.globl vector40
vector40:
  pushl $0
80105a5e:	6a 00                	push   $0x0
  pushl $40
80105a60:	6a 28                	push   $0x28
  jmp alltraps
80105a62:	e9 96 f9 ff ff       	jmp    801053fd <alltraps>

80105a67 <vector41>:
.globl vector41
vector41:
  pushl $0
80105a67:	6a 00                	push   $0x0
  pushl $41
80105a69:	6a 29                	push   $0x29
  jmp alltraps
80105a6b:	e9 8d f9 ff ff       	jmp    801053fd <alltraps>

80105a70 <vector42>:
.globl vector42
vector42:
  pushl $0
80105a70:	6a 00                	push   $0x0
  pushl $42
80105a72:	6a 2a                	push   $0x2a
  jmp alltraps
80105a74:	e9 84 f9 ff ff       	jmp    801053fd <alltraps>

80105a79 <vector43>:
.globl vector43
vector43:
  pushl $0
80105a79:	6a 00                	push   $0x0
  pushl $43
80105a7b:	6a 2b                	push   $0x2b
  jmp alltraps
80105a7d:	e9 7b f9 ff ff       	jmp    801053fd <alltraps>

80105a82 <vector44>:
.globl vector44
vector44:
  pushl $0
80105a82:	6a 00                	push   $0x0
  pushl $44
80105a84:	6a 2c                	push   $0x2c
  jmp alltraps
80105a86:	e9 72 f9 ff ff       	jmp    801053fd <alltraps>

80105a8b <vector45>:
.globl vector45
vector45:
  pushl $0
80105a8b:	6a 00                	push   $0x0
  pushl $45
80105a8d:	6a 2d                	push   $0x2d
  jmp alltraps
80105a8f:	e9 69 f9 ff ff       	jmp    801053fd <alltraps>

80105a94 <vector46>:
.globl vector46
vector46:
  pushl $0
80105a94:	6a 00                	push   $0x0
  pushl $46
80105a96:	6a 2e                	push   $0x2e
  jmp alltraps
80105a98:	e9 60 f9 ff ff       	jmp    801053fd <alltraps>

80105a9d <vector47>:
.globl vector47
vector47:
  pushl $0
80105a9d:	6a 00                	push   $0x0
  pushl $47
80105a9f:	6a 2f                	push   $0x2f
  jmp alltraps
80105aa1:	e9 57 f9 ff ff       	jmp    801053fd <alltraps>

80105aa6 <vector48>:
.globl vector48
vector48:
  pushl $0
80105aa6:	6a 00                	push   $0x0
  pushl $48
80105aa8:	6a 30                	push   $0x30
  jmp alltraps
80105aaa:	e9 4e f9 ff ff       	jmp    801053fd <alltraps>

80105aaf <vector49>:
.globl vector49
vector49:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $49
80105ab1:	6a 31                	push   $0x31
  jmp alltraps
80105ab3:	e9 45 f9 ff ff       	jmp    801053fd <alltraps>

80105ab8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105ab8:	6a 00                	push   $0x0
  pushl $50
80105aba:	6a 32                	push   $0x32
  jmp alltraps
80105abc:	e9 3c f9 ff ff       	jmp    801053fd <alltraps>

80105ac1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105ac1:	6a 00                	push   $0x0
  pushl $51
80105ac3:	6a 33                	push   $0x33
  jmp alltraps
80105ac5:	e9 33 f9 ff ff       	jmp    801053fd <alltraps>

80105aca <vector52>:
.globl vector52
vector52:
  pushl $0
80105aca:	6a 00                	push   $0x0
  pushl $52
80105acc:	6a 34                	push   $0x34
  jmp alltraps
80105ace:	e9 2a f9 ff ff       	jmp    801053fd <alltraps>

80105ad3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $53
80105ad5:	6a 35                	push   $0x35
  jmp alltraps
80105ad7:	e9 21 f9 ff ff       	jmp    801053fd <alltraps>

80105adc <vector54>:
.globl vector54
vector54:
  pushl $0
80105adc:	6a 00                	push   $0x0
  pushl $54
80105ade:	6a 36                	push   $0x36
  jmp alltraps
80105ae0:	e9 18 f9 ff ff       	jmp    801053fd <alltraps>

80105ae5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105ae5:	6a 00                	push   $0x0
  pushl $55
80105ae7:	6a 37                	push   $0x37
  jmp alltraps
80105ae9:	e9 0f f9 ff ff       	jmp    801053fd <alltraps>

80105aee <vector56>:
.globl vector56
vector56:
  pushl $0
80105aee:	6a 00                	push   $0x0
  pushl $56
80105af0:	6a 38                	push   $0x38
  jmp alltraps
80105af2:	e9 06 f9 ff ff       	jmp    801053fd <alltraps>

80105af7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $57
80105af9:	6a 39                	push   $0x39
  jmp alltraps
80105afb:	e9 fd f8 ff ff       	jmp    801053fd <alltraps>

80105b00 <vector58>:
.globl vector58
vector58:
  pushl $0
80105b00:	6a 00                	push   $0x0
  pushl $58
80105b02:	6a 3a                	push   $0x3a
  jmp alltraps
80105b04:	e9 f4 f8 ff ff       	jmp    801053fd <alltraps>

80105b09 <vector59>:
.globl vector59
vector59:
  pushl $0
80105b09:	6a 00                	push   $0x0
  pushl $59
80105b0b:	6a 3b                	push   $0x3b
  jmp alltraps
80105b0d:	e9 eb f8 ff ff       	jmp    801053fd <alltraps>

80105b12 <vector60>:
.globl vector60
vector60:
  pushl $0
80105b12:	6a 00                	push   $0x0
  pushl $60
80105b14:	6a 3c                	push   $0x3c
  jmp alltraps
80105b16:	e9 e2 f8 ff ff       	jmp    801053fd <alltraps>

80105b1b <vector61>:
.globl vector61
vector61:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $61
80105b1d:	6a 3d                	push   $0x3d
  jmp alltraps
80105b1f:	e9 d9 f8 ff ff       	jmp    801053fd <alltraps>

80105b24 <vector62>:
.globl vector62
vector62:
  pushl $0
80105b24:	6a 00                	push   $0x0
  pushl $62
80105b26:	6a 3e                	push   $0x3e
  jmp alltraps
80105b28:	e9 d0 f8 ff ff       	jmp    801053fd <alltraps>

80105b2d <vector63>:
.globl vector63
vector63:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $63
80105b2f:	6a 3f                	push   $0x3f
  jmp alltraps
80105b31:	e9 c7 f8 ff ff       	jmp    801053fd <alltraps>

80105b36 <vector64>:
.globl vector64
vector64:
  pushl $0
80105b36:	6a 00                	push   $0x0
  pushl $64
80105b38:	6a 40                	push   $0x40
  jmp alltraps
80105b3a:	e9 be f8 ff ff       	jmp    801053fd <alltraps>

80105b3f <vector65>:
.globl vector65
vector65:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $65
80105b41:	6a 41                	push   $0x41
  jmp alltraps
80105b43:	e9 b5 f8 ff ff       	jmp    801053fd <alltraps>

80105b48 <vector66>:
.globl vector66
vector66:
  pushl $0
80105b48:	6a 00                	push   $0x0
  pushl $66
80105b4a:	6a 42                	push   $0x42
  jmp alltraps
80105b4c:	e9 ac f8 ff ff       	jmp    801053fd <alltraps>

80105b51 <vector67>:
.globl vector67
vector67:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $67
80105b53:	6a 43                	push   $0x43
  jmp alltraps
80105b55:	e9 a3 f8 ff ff       	jmp    801053fd <alltraps>

80105b5a <vector68>:
.globl vector68
vector68:
  pushl $0
80105b5a:	6a 00                	push   $0x0
  pushl $68
80105b5c:	6a 44                	push   $0x44
  jmp alltraps
80105b5e:	e9 9a f8 ff ff       	jmp    801053fd <alltraps>

80105b63 <vector69>:
.globl vector69
vector69:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $69
80105b65:	6a 45                	push   $0x45
  jmp alltraps
80105b67:	e9 91 f8 ff ff       	jmp    801053fd <alltraps>

80105b6c <vector70>:
.globl vector70
vector70:
  pushl $0
80105b6c:	6a 00                	push   $0x0
  pushl $70
80105b6e:	6a 46                	push   $0x46
  jmp alltraps
80105b70:	e9 88 f8 ff ff       	jmp    801053fd <alltraps>

80105b75 <vector71>:
.globl vector71
vector71:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $71
80105b77:	6a 47                	push   $0x47
  jmp alltraps
80105b79:	e9 7f f8 ff ff       	jmp    801053fd <alltraps>

80105b7e <vector72>:
.globl vector72
vector72:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $72
80105b80:	6a 48                	push   $0x48
  jmp alltraps
80105b82:	e9 76 f8 ff ff       	jmp    801053fd <alltraps>

80105b87 <vector73>:
.globl vector73
vector73:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $73
80105b89:	6a 49                	push   $0x49
  jmp alltraps
80105b8b:	e9 6d f8 ff ff       	jmp    801053fd <alltraps>

80105b90 <vector74>:
.globl vector74
vector74:
  pushl $0
80105b90:	6a 00                	push   $0x0
  pushl $74
80105b92:	6a 4a                	push   $0x4a
  jmp alltraps
80105b94:	e9 64 f8 ff ff       	jmp    801053fd <alltraps>

80105b99 <vector75>:
.globl vector75
vector75:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $75
80105b9b:	6a 4b                	push   $0x4b
  jmp alltraps
80105b9d:	e9 5b f8 ff ff       	jmp    801053fd <alltraps>

80105ba2 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $76
80105ba4:	6a 4c                	push   $0x4c
  jmp alltraps
80105ba6:	e9 52 f8 ff ff       	jmp    801053fd <alltraps>

80105bab <vector77>:
.globl vector77
vector77:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $77
80105bad:	6a 4d                	push   $0x4d
  jmp alltraps
80105baf:	e9 49 f8 ff ff       	jmp    801053fd <alltraps>

80105bb4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $78
80105bb6:	6a 4e                	push   $0x4e
  jmp alltraps
80105bb8:	e9 40 f8 ff ff       	jmp    801053fd <alltraps>

80105bbd <vector79>:
.globl vector79
vector79:
  pushl $0
80105bbd:	6a 00                	push   $0x0
  pushl $79
80105bbf:	6a 4f                	push   $0x4f
  jmp alltraps
80105bc1:	e9 37 f8 ff ff       	jmp    801053fd <alltraps>

80105bc6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105bc6:	6a 00                	push   $0x0
  pushl $80
80105bc8:	6a 50                	push   $0x50
  jmp alltraps
80105bca:	e9 2e f8 ff ff       	jmp    801053fd <alltraps>

80105bcf <vector81>:
.globl vector81
vector81:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $81
80105bd1:	6a 51                	push   $0x51
  jmp alltraps
80105bd3:	e9 25 f8 ff ff       	jmp    801053fd <alltraps>

80105bd8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105bd8:	6a 00                	push   $0x0
  pushl $82
80105bda:	6a 52                	push   $0x52
  jmp alltraps
80105bdc:	e9 1c f8 ff ff       	jmp    801053fd <alltraps>

80105be1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105be1:	6a 00                	push   $0x0
  pushl $83
80105be3:	6a 53                	push   $0x53
  jmp alltraps
80105be5:	e9 13 f8 ff ff       	jmp    801053fd <alltraps>

80105bea <vector84>:
.globl vector84
vector84:
  pushl $0
80105bea:	6a 00                	push   $0x0
  pushl $84
80105bec:	6a 54                	push   $0x54
  jmp alltraps
80105bee:	e9 0a f8 ff ff       	jmp    801053fd <alltraps>

80105bf3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $85
80105bf5:	6a 55                	push   $0x55
  jmp alltraps
80105bf7:	e9 01 f8 ff ff       	jmp    801053fd <alltraps>

80105bfc <vector86>:
.globl vector86
vector86:
  pushl $0
80105bfc:	6a 00                	push   $0x0
  pushl $86
80105bfe:	6a 56                	push   $0x56
  jmp alltraps
80105c00:	e9 f8 f7 ff ff       	jmp    801053fd <alltraps>

80105c05 <vector87>:
.globl vector87
vector87:
  pushl $0
80105c05:	6a 00                	push   $0x0
  pushl $87
80105c07:	6a 57                	push   $0x57
  jmp alltraps
80105c09:	e9 ef f7 ff ff       	jmp    801053fd <alltraps>

80105c0e <vector88>:
.globl vector88
vector88:
  pushl $0
80105c0e:	6a 00                	push   $0x0
  pushl $88
80105c10:	6a 58                	push   $0x58
  jmp alltraps
80105c12:	e9 e6 f7 ff ff       	jmp    801053fd <alltraps>

80105c17 <vector89>:
.globl vector89
vector89:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $89
80105c19:	6a 59                	push   $0x59
  jmp alltraps
80105c1b:	e9 dd f7 ff ff       	jmp    801053fd <alltraps>

80105c20 <vector90>:
.globl vector90
vector90:
  pushl $0
80105c20:	6a 00                	push   $0x0
  pushl $90
80105c22:	6a 5a                	push   $0x5a
  jmp alltraps
80105c24:	e9 d4 f7 ff ff       	jmp    801053fd <alltraps>

80105c29 <vector91>:
.globl vector91
vector91:
  pushl $0
80105c29:	6a 00                	push   $0x0
  pushl $91
80105c2b:	6a 5b                	push   $0x5b
  jmp alltraps
80105c2d:	e9 cb f7 ff ff       	jmp    801053fd <alltraps>

80105c32 <vector92>:
.globl vector92
vector92:
  pushl $0
80105c32:	6a 00                	push   $0x0
  pushl $92
80105c34:	6a 5c                	push   $0x5c
  jmp alltraps
80105c36:	e9 c2 f7 ff ff       	jmp    801053fd <alltraps>

80105c3b <vector93>:
.globl vector93
vector93:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $93
80105c3d:	6a 5d                	push   $0x5d
  jmp alltraps
80105c3f:	e9 b9 f7 ff ff       	jmp    801053fd <alltraps>

80105c44 <vector94>:
.globl vector94
vector94:
  pushl $0
80105c44:	6a 00                	push   $0x0
  pushl $94
80105c46:	6a 5e                	push   $0x5e
  jmp alltraps
80105c48:	e9 b0 f7 ff ff       	jmp    801053fd <alltraps>

80105c4d <vector95>:
.globl vector95
vector95:
  pushl $0
80105c4d:	6a 00                	push   $0x0
  pushl $95
80105c4f:	6a 5f                	push   $0x5f
  jmp alltraps
80105c51:	e9 a7 f7 ff ff       	jmp    801053fd <alltraps>

80105c56 <vector96>:
.globl vector96
vector96:
  pushl $0
80105c56:	6a 00                	push   $0x0
  pushl $96
80105c58:	6a 60                	push   $0x60
  jmp alltraps
80105c5a:	e9 9e f7 ff ff       	jmp    801053fd <alltraps>

80105c5f <vector97>:
.globl vector97
vector97:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $97
80105c61:	6a 61                	push   $0x61
  jmp alltraps
80105c63:	e9 95 f7 ff ff       	jmp    801053fd <alltraps>

80105c68 <vector98>:
.globl vector98
vector98:
  pushl $0
80105c68:	6a 00                	push   $0x0
  pushl $98
80105c6a:	6a 62                	push   $0x62
  jmp alltraps
80105c6c:	e9 8c f7 ff ff       	jmp    801053fd <alltraps>

80105c71 <vector99>:
.globl vector99
vector99:
  pushl $0
80105c71:	6a 00                	push   $0x0
  pushl $99
80105c73:	6a 63                	push   $0x63
  jmp alltraps
80105c75:	e9 83 f7 ff ff       	jmp    801053fd <alltraps>

80105c7a <vector100>:
.globl vector100
vector100:
  pushl $0
80105c7a:	6a 00                	push   $0x0
  pushl $100
80105c7c:	6a 64                	push   $0x64
  jmp alltraps
80105c7e:	e9 7a f7 ff ff       	jmp    801053fd <alltraps>

80105c83 <vector101>:
.globl vector101
vector101:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $101
80105c85:	6a 65                	push   $0x65
  jmp alltraps
80105c87:	e9 71 f7 ff ff       	jmp    801053fd <alltraps>

80105c8c <vector102>:
.globl vector102
vector102:
  pushl $0
80105c8c:	6a 00                	push   $0x0
  pushl $102
80105c8e:	6a 66                	push   $0x66
  jmp alltraps
80105c90:	e9 68 f7 ff ff       	jmp    801053fd <alltraps>

80105c95 <vector103>:
.globl vector103
vector103:
  pushl $0
80105c95:	6a 00                	push   $0x0
  pushl $103
80105c97:	6a 67                	push   $0x67
  jmp alltraps
80105c99:	e9 5f f7 ff ff       	jmp    801053fd <alltraps>

80105c9e <vector104>:
.globl vector104
vector104:
  pushl $0
80105c9e:	6a 00                	push   $0x0
  pushl $104
80105ca0:	6a 68                	push   $0x68
  jmp alltraps
80105ca2:	e9 56 f7 ff ff       	jmp    801053fd <alltraps>

80105ca7 <vector105>:
.globl vector105
vector105:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $105
80105ca9:	6a 69                	push   $0x69
  jmp alltraps
80105cab:	e9 4d f7 ff ff       	jmp    801053fd <alltraps>

80105cb0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105cb0:	6a 00                	push   $0x0
  pushl $106
80105cb2:	6a 6a                	push   $0x6a
  jmp alltraps
80105cb4:	e9 44 f7 ff ff       	jmp    801053fd <alltraps>

80105cb9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $107
80105cbb:	6a 6b                	push   $0x6b
  jmp alltraps
80105cbd:	e9 3b f7 ff ff       	jmp    801053fd <alltraps>

80105cc2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105cc2:	6a 00                	push   $0x0
  pushl $108
80105cc4:	6a 6c                	push   $0x6c
  jmp alltraps
80105cc6:	e9 32 f7 ff ff       	jmp    801053fd <alltraps>

80105ccb <vector109>:
.globl vector109
vector109:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $109
80105ccd:	6a 6d                	push   $0x6d
  jmp alltraps
80105ccf:	e9 29 f7 ff ff       	jmp    801053fd <alltraps>

80105cd4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105cd4:	6a 00                	push   $0x0
  pushl $110
80105cd6:	6a 6e                	push   $0x6e
  jmp alltraps
80105cd8:	e9 20 f7 ff ff       	jmp    801053fd <alltraps>

80105cdd <vector111>:
.globl vector111
vector111:
  pushl $0
80105cdd:	6a 00                	push   $0x0
  pushl $111
80105cdf:	6a 6f                	push   $0x6f
  jmp alltraps
80105ce1:	e9 17 f7 ff ff       	jmp    801053fd <alltraps>

80105ce6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105ce6:	6a 00                	push   $0x0
  pushl $112
80105ce8:	6a 70                	push   $0x70
  jmp alltraps
80105cea:	e9 0e f7 ff ff       	jmp    801053fd <alltraps>

80105cef <vector113>:
.globl vector113
vector113:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $113
80105cf1:	6a 71                	push   $0x71
  jmp alltraps
80105cf3:	e9 05 f7 ff ff       	jmp    801053fd <alltraps>

80105cf8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105cf8:	6a 00                	push   $0x0
  pushl $114
80105cfa:	6a 72                	push   $0x72
  jmp alltraps
80105cfc:	e9 fc f6 ff ff       	jmp    801053fd <alltraps>

80105d01 <vector115>:
.globl vector115
vector115:
  pushl $0
80105d01:	6a 00                	push   $0x0
  pushl $115
80105d03:	6a 73                	push   $0x73
  jmp alltraps
80105d05:	e9 f3 f6 ff ff       	jmp    801053fd <alltraps>

80105d0a <vector116>:
.globl vector116
vector116:
  pushl $0
80105d0a:	6a 00                	push   $0x0
  pushl $116
80105d0c:	6a 74                	push   $0x74
  jmp alltraps
80105d0e:	e9 ea f6 ff ff       	jmp    801053fd <alltraps>

80105d13 <vector117>:
.globl vector117
vector117:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $117
80105d15:	6a 75                	push   $0x75
  jmp alltraps
80105d17:	e9 e1 f6 ff ff       	jmp    801053fd <alltraps>

80105d1c <vector118>:
.globl vector118
vector118:
  pushl $0
80105d1c:	6a 00                	push   $0x0
  pushl $118
80105d1e:	6a 76                	push   $0x76
  jmp alltraps
80105d20:	e9 d8 f6 ff ff       	jmp    801053fd <alltraps>

80105d25 <vector119>:
.globl vector119
vector119:
  pushl $0
80105d25:	6a 00                	push   $0x0
  pushl $119
80105d27:	6a 77                	push   $0x77
  jmp alltraps
80105d29:	e9 cf f6 ff ff       	jmp    801053fd <alltraps>

80105d2e <vector120>:
.globl vector120
vector120:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $120
80105d30:	6a 78                	push   $0x78
  jmp alltraps
80105d32:	e9 c6 f6 ff ff       	jmp    801053fd <alltraps>

80105d37 <vector121>:
.globl vector121
vector121:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $121
80105d39:	6a 79                	push   $0x79
  jmp alltraps
80105d3b:	e9 bd f6 ff ff       	jmp    801053fd <alltraps>

80105d40 <vector122>:
.globl vector122
vector122:
  pushl $0
80105d40:	6a 00                	push   $0x0
  pushl $122
80105d42:	6a 7a                	push   $0x7a
  jmp alltraps
80105d44:	e9 b4 f6 ff ff       	jmp    801053fd <alltraps>

80105d49 <vector123>:
.globl vector123
vector123:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $123
80105d4b:	6a 7b                	push   $0x7b
  jmp alltraps
80105d4d:	e9 ab f6 ff ff       	jmp    801053fd <alltraps>

80105d52 <vector124>:
.globl vector124
vector124:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $124
80105d54:	6a 7c                	push   $0x7c
  jmp alltraps
80105d56:	e9 a2 f6 ff ff       	jmp    801053fd <alltraps>

80105d5b <vector125>:
.globl vector125
vector125:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $125
80105d5d:	6a 7d                	push   $0x7d
  jmp alltraps
80105d5f:	e9 99 f6 ff ff       	jmp    801053fd <alltraps>

80105d64 <vector126>:
.globl vector126
vector126:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $126
80105d66:	6a 7e                	push   $0x7e
  jmp alltraps
80105d68:	e9 90 f6 ff ff       	jmp    801053fd <alltraps>

80105d6d <vector127>:
.globl vector127
vector127:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $127
80105d6f:	6a 7f                	push   $0x7f
  jmp alltraps
80105d71:	e9 87 f6 ff ff       	jmp    801053fd <alltraps>

80105d76 <vector128>:
.globl vector128
vector128:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $128
80105d78:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105d7d:	e9 7b f6 ff ff       	jmp    801053fd <alltraps>

80105d82 <vector129>:
.globl vector129
vector129:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $129
80105d84:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105d89:	e9 6f f6 ff ff       	jmp    801053fd <alltraps>

80105d8e <vector130>:
.globl vector130
vector130:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $130
80105d90:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105d95:	e9 63 f6 ff ff       	jmp    801053fd <alltraps>

80105d9a <vector131>:
.globl vector131
vector131:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $131
80105d9c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105da1:	e9 57 f6 ff ff       	jmp    801053fd <alltraps>

80105da6 <vector132>:
.globl vector132
vector132:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $132
80105da8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105dad:	e9 4b f6 ff ff       	jmp    801053fd <alltraps>

80105db2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $133
80105db4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105db9:	e9 3f f6 ff ff       	jmp    801053fd <alltraps>

80105dbe <vector134>:
.globl vector134
vector134:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $134
80105dc0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105dc5:	e9 33 f6 ff ff       	jmp    801053fd <alltraps>

80105dca <vector135>:
.globl vector135
vector135:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $135
80105dcc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105dd1:	e9 27 f6 ff ff       	jmp    801053fd <alltraps>

80105dd6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $136
80105dd8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105ddd:	e9 1b f6 ff ff       	jmp    801053fd <alltraps>

80105de2 <vector137>:
.globl vector137
vector137:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $137
80105de4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105de9:	e9 0f f6 ff ff       	jmp    801053fd <alltraps>

80105dee <vector138>:
.globl vector138
vector138:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $138
80105df0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105df5:	e9 03 f6 ff ff       	jmp    801053fd <alltraps>

80105dfa <vector139>:
.globl vector139
vector139:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $139
80105dfc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105e01:	e9 f7 f5 ff ff       	jmp    801053fd <alltraps>

80105e06 <vector140>:
.globl vector140
vector140:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $140
80105e08:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105e0d:	e9 eb f5 ff ff       	jmp    801053fd <alltraps>

80105e12 <vector141>:
.globl vector141
vector141:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $141
80105e14:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105e19:	e9 df f5 ff ff       	jmp    801053fd <alltraps>

80105e1e <vector142>:
.globl vector142
vector142:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $142
80105e20:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105e25:	e9 d3 f5 ff ff       	jmp    801053fd <alltraps>

80105e2a <vector143>:
.globl vector143
vector143:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $143
80105e2c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105e31:	e9 c7 f5 ff ff       	jmp    801053fd <alltraps>

80105e36 <vector144>:
.globl vector144
vector144:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $144
80105e38:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105e3d:	e9 bb f5 ff ff       	jmp    801053fd <alltraps>

80105e42 <vector145>:
.globl vector145
vector145:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $145
80105e44:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105e49:	e9 af f5 ff ff       	jmp    801053fd <alltraps>

80105e4e <vector146>:
.globl vector146
vector146:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $146
80105e50:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105e55:	e9 a3 f5 ff ff       	jmp    801053fd <alltraps>

80105e5a <vector147>:
.globl vector147
vector147:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $147
80105e5c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105e61:	e9 97 f5 ff ff       	jmp    801053fd <alltraps>

80105e66 <vector148>:
.globl vector148
vector148:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $148
80105e68:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105e6d:	e9 8b f5 ff ff       	jmp    801053fd <alltraps>

80105e72 <vector149>:
.globl vector149
vector149:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $149
80105e74:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105e79:	e9 7f f5 ff ff       	jmp    801053fd <alltraps>

80105e7e <vector150>:
.globl vector150
vector150:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $150
80105e80:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105e85:	e9 73 f5 ff ff       	jmp    801053fd <alltraps>

80105e8a <vector151>:
.globl vector151
vector151:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $151
80105e8c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105e91:	e9 67 f5 ff ff       	jmp    801053fd <alltraps>

80105e96 <vector152>:
.globl vector152
vector152:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $152
80105e98:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105e9d:	e9 5b f5 ff ff       	jmp    801053fd <alltraps>

80105ea2 <vector153>:
.globl vector153
vector153:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $153
80105ea4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105ea9:	e9 4f f5 ff ff       	jmp    801053fd <alltraps>

80105eae <vector154>:
.globl vector154
vector154:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $154
80105eb0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105eb5:	e9 43 f5 ff ff       	jmp    801053fd <alltraps>

80105eba <vector155>:
.globl vector155
vector155:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $155
80105ebc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105ec1:	e9 37 f5 ff ff       	jmp    801053fd <alltraps>

80105ec6 <vector156>:
.globl vector156
vector156:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $156
80105ec8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105ecd:	e9 2b f5 ff ff       	jmp    801053fd <alltraps>

80105ed2 <vector157>:
.globl vector157
vector157:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $157
80105ed4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105ed9:	e9 1f f5 ff ff       	jmp    801053fd <alltraps>

80105ede <vector158>:
.globl vector158
vector158:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $158
80105ee0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105ee5:	e9 13 f5 ff ff       	jmp    801053fd <alltraps>

80105eea <vector159>:
.globl vector159
vector159:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $159
80105eec:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105ef1:	e9 07 f5 ff ff       	jmp    801053fd <alltraps>

80105ef6 <vector160>:
.globl vector160
vector160:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $160
80105ef8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105efd:	e9 fb f4 ff ff       	jmp    801053fd <alltraps>

80105f02 <vector161>:
.globl vector161
vector161:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $161
80105f04:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105f09:	e9 ef f4 ff ff       	jmp    801053fd <alltraps>

80105f0e <vector162>:
.globl vector162
vector162:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $162
80105f10:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105f15:	e9 e3 f4 ff ff       	jmp    801053fd <alltraps>

80105f1a <vector163>:
.globl vector163
vector163:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $163
80105f1c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105f21:	e9 d7 f4 ff ff       	jmp    801053fd <alltraps>

80105f26 <vector164>:
.globl vector164
vector164:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $164
80105f28:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105f2d:	e9 cb f4 ff ff       	jmp    801053fd <alltraps>

80105f32 <vector165>:
.globl vector165
vector165:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $165
80105f34:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105f39:	e9 bf f4 ff ff       	jmp    801053fd <alltraps>

80105f3e <vector166>:
.globl vector166
vector166:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $166
80105f40:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105f45:	e9 b3 f4 ff ff       	jmp    801053fd <alltraps>

80105f4a <vector167>:
.globl vector167
vector167:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $167
80105f4c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105f51:	e9 a7 f4 ff ff       	jmp    801053fd <alltraps>

80105f56 <vector168>:
.globl vector168
vector168:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $168
80105f58:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105f5d:	e9 9b f4 ff ff       	jmp    801053fd <alltraps>

80105f62 <vector169>:
.globl vector169
vector169:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $169
80105f64:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105f69:	e9 8f f4 ff ff       	jmp    801053fd <alltraps>

80105f6e <vector170>:
.globl vector170
vector170:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $170
80105f70:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105f75:	e9 83 f4 ff ff       	jmp    801053fd <alltraps>

80105f7a <vector171>:
.globl vector171
vector171:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $171
80105f7c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105f81:	e9 77 f4 ff ff       	jmp    801053fd <alltraps>

80105f86 <vector172>:
.globl vector172
vector172:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $172
80105f88:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105f8d:	e9 6b f4 ff ff       	jmp    801053fd <alltraps>

80105f92 <vector173>:
.globl vector173
vector173:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $173
80105f94:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105f99:	e9 5f f4 ff ff       	jmp    801053fd <alltraps>

80105f9e <vector174>:
.globl vector174
vector174:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $174
80105fa0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105fa5:	e9 53 f4 ff ff       	jmp    801053fd <alltraps>

80105faa <vector175>:
.globl vector175
vector175:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $175
80105fac:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105fb1:	e9 47 f4 ff ff       	jmp    801053fd <alltraps>

80105fb6 <vector176>:
.globl vector176
vector176:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $176
80105fb8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105fbd:	e9 3b f4 ff ff       	jmp    801053fd <alltraps>

80105fc2 <vector177>:
.globl vector177
vector177:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $177
80105fc4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105fc9:	e9 2f f4 ff ff       	jmp    801053fd <alltraps>

80105fce <vector178>:
.globl vector178
vector178:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $178
80105fd0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105fd5:	e9 23 f4 ff ff       	jmp    801053fd <alltraps>

80105fda <vector179>:
.globl vector179
vector179:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $179
80105fdc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105fe1:	e9 17 f4 ff ff       	jmp    801053fd <alltraps>

80105fe6 <vector180>:
.globl vector180
vector180:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $180
80105fe8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105fed:	e9 0b f4 ff ff       	jmp    801053fd <alltraps>

80105ff2 <vector181>:
.globl vector181
vector181:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $181
80105ff4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105ff9:	e9 ff f3 ff ff       	jmp    801053fd <alltraps>

80105ffe <vector182>:
.globl vector182
vector182:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $182
80106000:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106005:	e9 f3 f3 ff ff       	jmp    801053fd <alltraps>

8010600a <vector183>:
.globl vector183
vector183:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $183
8010600c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106011:	e9 e7 f3 ff ff       	jmp    801053fd <alltraps>

80106016 <vector184>:
.globl vector184
vector184:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $184
80106018:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010601d:	e9 db f3 ff ff       	jmp    801053fd <alltraps>

80106022 <vector185>:
.globl vector185
vector185:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $185
80106024:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106029:	e9 cf f3 ff ff       	jmp    801053fd <alltraps>

8010602e <vector186>:
.globl vector186
vector186:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $186
80106030:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106035:	e9 c3 f3 ff ff       	jmp    801053fd <alltraps>

8010603a <vector187>:
.globl vector187
vector187:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $187
8010603c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106041:	e9 b7 f3 ff ff       	jmp    801053fd <alltraps>

80106046 <vector188>:
.globl vector188
vector188:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $188
80106048:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010604d:	e9 ab f3 ff ff       	jmp    801053fd <alltraps>

80106052 <vector189>:
.globl vector189
vector189:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $189
80106054:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106059:	e9 9f f3 ff ff       	jmp    801053fd <alltraps>

8010605e <vector190>:
.globl vector190
vector190:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $190
80106060:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106065:	e9 93 f3 ff ff       	jmp    801053fd <alltraps>

8010606a <vector191>:
.globl vector191
vector191:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $191
8010606c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106071:	e9 87 f3 ff ff       	jmp    801053fd <alltraps>

80106076 <vector192>:
.globl vector192
vector192:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $192
80106078:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010607d:	e9 7b f3 ff ff       	jmp    801053fd <alltraps>

80106082 <vector193>:
.globl vector193
vector193:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $193
80106084:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106089:	e9 6f f3 ff ff       	jmp    801053fd <alltraps>

8010608e <vector194>:
.globl vector194
vector194:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $194
80106090:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106095:	e9 63 f3 ff ff       	jmp    801053fd <alltraps>

8010609a <vector195>:
.globl vector195
vector195:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $195
8010609c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801060a1:	e9 57 f3 ff ff       	jmp    801053fd <alltraps>

801060a6 <vector196>:
.globl vector196
vector196:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $196
801060a8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801060ad:	e9 4b f3 ff ff       	jmp    801053fd <alltraps>

801060b2 <vector197>:
.globl vector197
vector197:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $197
801060b4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801060b9:	e9 3f f3 ff ff       	jmp    801053fd <alltraps>

801060be <vector198>:
.globl vector198
vector198:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $198
801060c0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801060c5:	e9 33 f3 ff ff       	jmp    801053fd <alltraps>

801060ca <vector199>:
.globl vector199
vector199:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $199
801060cc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801060d1:	e9 27 f3 ff ff       	jmp    801053fd <alltraps>

801060d6 <vector200>:
.globl vector200
vector200:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $200
801060d8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801060dd:	e9 1b f3 ff ff       	jmp    801053fd <alltraps>

801060e2 <vector201>:
.globl vector201
vector201:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $201
801060e4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801060e9:	e9 0f f3 ff ff       	jmp    801053fd <alltraps>

801060ee <vector202>:
.globl vector202
vector202:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $202
801060f0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801060f5:	e9 03 f3 ff ff       	jmp    801053fd <alltraps>

801060fa <vector203>:
.globl vector203
vector203:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $203
801060fc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106101:	e9 f7 f2 ff ff       	jmp    801053fd <alltraps>

80106106 <vector204>:
.globl vector204
vector204:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $204
80106108:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010610d:	e9 eb f2 ff ff       	jmp    801053fd <alltraps>

80106112 <vector205>:
.globl vector205
vector205:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $205
80106114:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106119:	e9 df f2 ff ff       	jmp    801053fd <alltraps>

8010611e <vector206>:
.globl vector206
vector206:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $206
80106120:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106125:	e9 d3 f2 ff ff       	jmp    801053fd <alltraps>

8010612a <vector207>:
.globl vector207
vector207:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $207
8010612c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106131:	e9 c7 f2 ff ff       	jmp    801053fd <alltraps>

80106136 <vector208>:
.globl vector208
vector208:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $208
80106138:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010613d:	e9 bb f2 ff ff       	jmp    801053fd <alltraps>

80106142 <vector209>:
.globl vector209
vector209:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $209
80106144:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106149:	e9 af f2 ff ff       	jmp    801053fd <alltraps>

8010614e <vector210>:
.globl vector210
vector210:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $210
80106150:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106155:	e9 a3 f2 ff ff       	jmp    801053fd <alltraps>

8010615a <vector211>:
.globl vector211
vector211:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $211
8010615c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106161:	e9 97 f2 ff ff       	jmp    801053fd <alltraps>

80106166 <vector212>:
.globl vector212
vector212:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $212
80106168:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010616d:	e9 8b f2 ff ff       	jmp    801053fd <alltraps>

80106172 <vector213>:
.globl vector213
vector213:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $213
80106174:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106179:	e9 7f f2 ff ff       	jmp    801053fd <alltraps>

8010617e <vector214>:
.globl vector214
vector214:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $214
80106180:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106185:	e9 73 f2 ff ff       	jmp    801053fd <alltraps>

8010618a <vector215>:
.globl vector215
vector215:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $215
8010618c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106191:	e9 67 f2 ff ff       	jmp    801053fd <alltraps>

80106196 <vector216>:
.globl vector216
vector216:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $216
80106198:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010619d:	e9 5b f2 ff ff       	jmp    801053fd <alltraps>

801061a2 <vector217>:
.globl vector217
vector217:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $217
801061a4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801061a9:	e9 4f f2 ff ff       	jmp    801053fd <alltraps>

801061ae <vector218>:
.globl vector218
vector218:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $218
801061b0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801061b5:	e9 43 f2 ff ff       	jmp    801053fd <alltraps>

801061ba <vector219>:
.globl vector219
vector219:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $219
801061bc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801061c1:	e9 37 f2 ff ff       	jmp    801053fd <alltraps>

801061c6 <vector220>:
.globl vector220
vector220:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $220
801061c8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801061cd:	e9 2b f2 ff ff       	jmp    801053fd <alltraps>

801061d2 <vector221>:
.globl vector221
vector221:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $221
801061d4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801061d9:	e9 1f f2 ff ff       	jmp    801053fd <alltraps>

801061de <vector222>:
.globl vector222
vector222:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $222
801061e0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801061e5:	e9 13 f2 ff ff       	jmp    801053fd <alltraps>

801061ea <vector223>:
.globl vector223
vector223:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $223
801061ec:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801061f1:	e9 07 f2 ff ff       	jmp    801053fd <alltraps>

801061f6 <vector224>:
.globl vector224
vector224:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $224
801061f8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801061fd:	e9 fb f1 ff ff       	jmp    801053fd <alltraps>

80106202 <vector225>:
.globl vector225
vector225:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $225
80106204:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106209:	e9 ef f1 ff ff       	jmp    801053fd <alltraps>

8010620e <vector226>:
.globl vector226
vector226:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $226
80106210:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106215:	e9 e3 f1 ff ff       	jmp    801053fd <alltraps>

8010621a <vector227>:
.globl vector227
vector227:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $227
8010621c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106221:	e9 d7 f1 ff ff       	jmp    801053fd <alltraps>

80106226 <vector228>:
.globl vector228
vector228:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $228
80106228:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010622d:	e9 cb f1 ff ff       	jmp    801053fd <alltraps>

80106232 <vector229>:
.globl vector229
vector229:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $229
80106234:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106239:	e9 bf f1 ff ff       	jmp    801053fd <alltraps>

8010623e <vector230>:
.globl vector230
vector230:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $230
80106240:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106245:	e9 b3 f1 ff ff       	jmp    801053fd <alltraps>

8010624a <vector231>:
.globl vector231
vector231:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $231
8010624c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106251:	e9 a7 f1 ff ff       	jmp    801053fd <alltraps>

80106256 <vector232>:
.globl vector232
vector232:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $232
80106258:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010625d:	e9 9b f1 ff ff       	jmp    801053fd <alltraps>

80106262 <vector233>:
.globl vector233
vector233:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $233
80106264:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106269:	e9 8f f1 ff ff       	jmp    801053fd <alltraps>

8010626e <vector234>:
.globl vector234
vector234:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $234
80106270:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106275:	e9 83 f1 ff ff       	jmp    801053fd <alltraps>

8010627a <vector235>:
.globl vector235
vector235:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $235
8010627c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106281:	e9 77 f1 ff ff       	jmp    801053fd <alltraps>

80106286 <vector236>:
.globl vector236
vector236:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $236
80106288:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010628d:	e9 6b f1 ff ff       	jmp    801053fd <alltraps>

80106292 <vector237>:
.globl vector237
vector237:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $237
80106294:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106299:	e9 5f f1 ff ff       	jmp    801053fd <alltraps>

8010629e <vector238>:
.globl vector238
vector238:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $238
801062a0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801062a5:	e9 53 f1 ff ff       	jmp    801053fd <alltraps>

801062aa <vector239>:
.globl vector239
vector239:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $239
801062ac:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801062b1:	e9 47 f1 ff ff       	jmp    801053fd <alltraps>

801062b6 <vector240>:
.globl vector240
vector240:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $240
801062b8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801062bd:	e9 3b f1 ff ff       	jmp    801053fd <alltraps>

801062c2 <vector241>:
.globl vector241
vector241:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $241
801062c4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801062c9:	e9 2f f1 ff ff       	jmp    801053fd <alltraps>

801062ce <vector242>:
.globl vector242
vector242:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $242
801062d0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801062d5:	e9 23 f1 ff ff       	jmp    801053fd <alltraps>

801062da <vector243>:
.globl vector243
vector243:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $243
801062dc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801062e1:	e9 17 f1 ff ff       	jmp    801053fd <alltraps>

801062e6 <vector244>:
.globl vector244
vector244:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $244
801062e8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801062ed:	e9 0b f1 ff ff       	jmp    801053fd <alltraps>

801062f2 <vector245>:
.globl vector245
vector245:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $245
801062f4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801062f9:	e9 ff f0 ff ff       	jmp    801053fd <alltraps>

801062fe <vector246>:
.globl vector246
vector246:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $246
80106300:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106305:	e9 f3 f0 ff ff       	jmp    801053fd <alltraps>

8010630a <vector247>:
.globl vector247
vector247:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $247
8010630c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106311:	e9 e7 f0 ff ff       	jmp    801053fd <alltraps>

80106316 <vector248>:
.globl vector248
vector248:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $248
80106318:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010631d:	e9 db f0 ff ff       	jmp    801053fd <alltraps>

80106322 <vector249>:
.globl vector249
vector249:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $249
80106324:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106329:	e9 cf f0 ff ff       	jmp    801053fd <alltraps>

8010632e <vector250>:
.globl vector250
vector250:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $250
80106330:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106335:	e9 c3 f0 ff ff       	jmp    801053fd <alltraps>

8010633a <vector251>:
.globl vector251
vector251:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $251
8010633c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106341:	e9 b7 f0 ff ff       	jmp    801053fd <alltraps>

80106346 <vector252>:
.globl vector252
vector252:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $252
80106348:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010634d:	e9 ab f0 ff ff       	jmp    801053fd <alltraps>

80106352 <vector253>:
.globl vector253
vector253:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $253
80106354:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106359:	e9 9f f0 ff ff       	jmp    801053fd <alltraps>

8010635e <vector254>:
.globl vector254
vector254:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $254
80106360:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106365:	e9 93 f0 ff ff       	jmp    801053fd <alltraps>

8010636a <vector255>:
.globl vector255
vector255:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $255
8010636c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106371:	e9 87 f0 ff ff       	jmp    801053fd <alltraps>
80106376:	66 90                	xchg   %ax,%ax
80106378:	66 90                	xchg   %ax,%ax
8010637a:	66 90                	xchg   %ax,%ax
8010637c:	66 90                	xchg   %ax,%ax
8010637e:	66 90                	xchg   %ax,%ax

80106380 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	57                   	push   %edi
80106384:	56                   	push   %esi
80106385:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106387:	c1 ea 16             	shr    $0x16,%edx
{
8010638a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010638b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010638e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106391:	8b 1f                	mov    (%edi),%ebx
80106393:	f6 c3 01             	test   $0x1,%bl
80106396:	74 28                	je     801063c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106398:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010639e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801063a4:	c1 ee 0a             	shr    $0xa,%esi
}
801063a7:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
801063aa:	89 f2                	mov    %esi,%edx
801063ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801063b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801063b5:	5b                   	pop    %ebx
801063b6:	5e                   	pop    %esi
801063b7:	5f                   	pop    %edi
801063b8:	5d                   	pop    %ebp
801063b9:	c3                   	ret    
801063ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801063c0:	85 c9                	test   %ecx,%ecx
801063c2:	74 34                	je     801063f8 <walkpgdir+0x78>
801063c4:	e8 f7 c0 ff ff       	call   801024c0 <kalloc>
801063c9:	85 c0                	test   %eax,%eax
801063cb:	89 c3                	mov    %eax,%ebx
801063cd:	74 29                	je     801063f8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
801063cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801063d6:	00 
801063d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801063de:	00 
801063df:	89 04 24             	mov    %eax,(%esp)
801063e2:	e8 b9 de ff ff       	call   801042a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801063e7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801063ed:	83 c8 07             	or     $0x7,%eax
801063f0:	89 07                	mov    %eax,(%edi)
801063f2:	eb b0                	jmp    801063a4 <walkpgdir+0x24>
801063f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801063f8:	83 c4 1c             	add    $0x1c,%esp
      return 0;
801063fb:	31 c0                	xor    %eax,%eax
}
801063fd:	5b                   	pop    %ebx
801063fe:	5e                   	pop    %esi
801063ff:	5f                   	pop    %edi
80106400:	5d                   	pop    %ebp
80106401:	c3                   	ret    
80106402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106410 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	57                   	push   %edi
80106414:	89 c7                	mov    %eax,%edi
80106416:	56                   	push   %esi
80106417:	89 d6                	mov    %edx,%esi
80106419:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010641a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106420:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106423:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106429:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010642b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010642e:	72 3b                	jb     8010646b <deallocuvm.part.0+0x5b>
80106430:	eb 5e                	jmp    80106490 <deallocuvm.part.0+0x80>
80106432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106438:	8b 10                	mov    (%eax),%edx
8010643a:	f6 c2 01             	test   $0x1,%dl
8010643d:	74 22                	je     80106461 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010643f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106445:	74 54                	je     8010649b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106447:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010644d:	89 14 24             	mov    %edx,(%esp)
80106450:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106453:	e8 b8 be ff ff       	call   80102310 <kfree>
      *pte = 0;
80106458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010645b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106461:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106467:	39 f3                	cmp    %esi,%ebx
80106469:	73 25                	jae    80106490 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010646b:	31 c9                	xor    %ecx,%ecx
8010646d:	89 da                	mov    %ebx,%edx
8010646f:	89 f8                	mov    %edi,%eax
80106471:	e8 0a ff ff ff       	call   80106380 <walkpgdir>
    if(!pte)
80106476:	85 c0                	test   %eax,%eax
80106478:	75 be                	jne    80106438 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010647a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106480:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106486:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010648c:	39 f3                	cmp    %esi,%ebx
8010648e:	72 db                	jb     8010646b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106490:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106493:	83 c4 1c             	add    $0x1c,%esp
80106496:	5b                   	pop    %ebx
80106497:	5e                   	pop    %esi
80106498:	5f                   	pop    %edi
80106499:	5d                   	pop    %ebp
8010649a:	c3                   	ret    
        panic("kfree");
8010649b:	c7 04 24 86 70 10 80 	movl   $0x80107086,(%esp)
801064a2:	e8 b9 9e ff ff       	call   80100360 <panic>
801064a7:	89 f6                	mov    %esi,%esi
801064a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064b0 <seginit>:
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801064b6:	e8 e5 d1 ff ff       	call   801036a0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064bb:	31 c9                	xor    %ecx,%ecx
801064bd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
801064c2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801064c8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064cd:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064d1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
801064d6:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064d9:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064dd:	31 c9                	xor    %ecx,%ecx
801064df:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064e3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801064e8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064ec:	31 c9                	xor    %ecx,%ecx
801064ee:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064f2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801064f7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801064fb:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801064fd:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106501:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106505:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106509:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010650d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106511:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106515:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106519:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010651d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106521:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106526:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010652a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010652e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106532:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106536:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010653a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010653e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106542:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106546:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010654a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010654e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106552:	c1 e8 10             	shr    $0x10,%eax
80106555:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106559:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010655c:	0f 01 10             	lgdtl  (%eax)
}
8010655f:	c9                   	leave  
80106560:	c3                   	ret    
80106561:	eb 0d                	jmp    80106570 <mappages>
80106563:	90                   	nop
80106564:	90                   	nop
80106565:	90                   	nop
80106566:	90                   	nop
80106567:	90                   	nop
80106568:	90                   	nop
80106569:	90                   	nop
8010656a:	90                   	nop
8010656b:	90                   	nop
8010656c:	90                   	nop
8010656d:	90                   	nop
8010656e:	90                   	nop
8010656f:	90                   	nop

80106570 <mappages>:
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	57                   	push   %edi
80106574:	56                   	push   %esi
80106575:	53                   	push   %ebx
80106576:	83 ec 1c             	sub    $0x1c,%esp
80106579:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010657c:	8b 55 10             	mov    0x10(%ebp),%edx
{
8010657f:	8b 7d 14             	mov    0x14(%ebp),%edi
    *pte = pa | perm | PTE_P;
80106582:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
80106586:	89 c3                	mov    %eax,%ebx
80106588:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010658e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106592:	29 df                	sub    %ebx,%edi
80106594:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106597:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
8010659e:	eb 15                	jmp    801065b5 <mappages+0x45>
    if(*pte & PTE_P)
801065a0:	f6 00 01             	testb  $0x1,(%eax)
801065a3:	75 3d                	jne    801065e2 <mappages+0x72>
    *pte = pa | perm | PTE_P;
801065a5:	0b 75 18             	or     0x18(%ebp),%esi
    if(a == last)
801065a8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801065ab:	89 30                	mov    %esi,(%eax)
    if(a == last)
801065ad:	74 29                	je     801065d8 <mappages+0x68>
    a += PGSIZE;
801065af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801065b5:	8b 45 08             	mov    0x8(%ebp),%eax
801065b8:	b9 01 00 00 00       	mov    $0x1,%ecx
801065bd:	89 da                	mov    %ebx,%edx
801065bf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801065c2:	e8 b9 fd ff ff       	call   80106380 <walkpgdir>
801065c7:	85 c0                	test   %eax,%eax
801065c9:	75 d5                	jne    801065a0 <mappages+0x30>
}
801065cb:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801065ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065d3:	5b                   	pop    %ebx
801065d4:	5e                   	pop    %esi
801065d5:	5f                   	pop    %edi
801065d6:	5d                   	pop    %ebp
801065d7:	c3                   	ret    
801065d8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801065db:	31 c0                	xor    %eax,%eax
}
801065dd:	5b                   	pop    %ebx
801065de:	5e                   	pop    %esi
801065df:	5f                   	pop    %edi
801065e0:	5d                   	pop    %ebp
801065e1:	c3                   	ret    
      panic("remap");
801065e2:	c7 04 24 58 77 10 80 	movl   $0x80107758,(%esp)
801065e9:	e8 72 9d ff ff       	call   80100360 <panic>
801065ee:	66 90                	xchg   %ax,%ax

801065f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065f0:	a1 a4 55 11 80       	mov    0x801155a4,%eax
{
801065f5:	55                   	push   %ebp
801065f6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065f8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065fd:	0f 22 d8             	mov    %eax,%cr3
}
80106600:	5d                   	pop    %ebp
80106601:	c3                   	ret    
80106602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106610 <switchuvm>:
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	57                   	push   %edi
80106614:	56                   	push   %esi
80106615:	53                   	push   %ebx
80106616:	83 ec 1c             	sub    $0x1c,%esp
80106619:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010661c:	85 f6                	test   %esi,%esi
8010661e:	0f 84 cd 00 00 00    	je     801066f1 <switchuvm+0xe1>
  if(p->kstack == 0)
80106624:	8b 46 08             	mov    0x8(%esi),%eax
80106627:	85 c0                	test   %eax,%eax
80106629:	0f 84 da 00 00 00    	je     80106709 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010662f:	8b 7e 04             	mov    0x4(%esi),%edi
80106632:	85 ff                	test   %edi,%edi
80106634:	0f 84 c3 00 00 00    	je     801066fd <switchuvm+0xed>
  pushcli();
8010663a:	e8 e1 da ff ff       	call   80104120 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010663f:	e8 dc cf ff ff       	call   80103620 <mycpu>
80106644:	89 c3                	mov    %eax,%ebx
80106646:	e8 d5 cf ff ff       	call   80103620 <mycpu>
8010664b:	89 c7                	mov    %eax,%edi
8010664d:	e8 ce cf ff ff       	call   80103620 <mycpu>
80106652:	83 c7 08             	add    $0x8,%edi
80106655:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106658:	e8 c3 cf ff ff       	call   80103620 <mycpu>
8010665d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106660:	ba 67 00 00 00       	mov    $0x67,%edx
80106665:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010666c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106673:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010667a:	83 c1 08             	add    $0x8,%ecx
8010667d:	c1 e9 10             	shr    $0x10,%ecx
80106680:	83 c0 08             	add    $0x8,%eax
80106683:	c1 e8 18             	shr    $0x18,%eax
80106686:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010668c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106693:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106699:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010669e:	e8 7d cf ff ff       	call   80103620 <mycpu>
801066a3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801066aa:	e8 71 cf ff ff       	call   80103620 <mycpu>
801066af:	b9 10 00 00 00       	mov    $0x10,%ecx
801066b4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801066b8:	e8 63 cf ff ff       	call   80103620 <mycpu>
801066bd:	8b 56 08             	mov    0x8(%esi),%edx
801066c0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801066c6:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801066c9:	e8 52 cf ff ff       	call   80103620 <mycpu>
801066ce:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801066d2:	b8 28 00 00 00       	mov    $0x28,%eax
801066d7:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801066da:	8b 46 04             	mov    0x4(%esi),%eax
801066dd:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801066e2:	0f 22 d8             	mov    %eax,%cr3
}
801066e5:	83 c4 1c             	add    $0x1c,%esp
801066e8:	5b                   	pop    %ebx
801066e9:	5e                   	pop    %esi
801066ea:	5f                   	pop    %edi
801066eb:	5d                   	pop    %ebp
  popcli();
801066ec:	e9 ef da ff ff       	jmp    801041e0 <popcli>
    panic("switchuvm: no process");
801066f1:	c7 04 24 5e 77 10 80 	movl   $0x8010775e,(%esp)
801066f8:	e8 63 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
801066fd:	c7 04 24 89 77 10 80 	movl   $0x80107789,(%esp)
80106704:	e8 57 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106709:	c7 04 24 74 77 10 80 	movl   $0x80107774,(%esp)
80106710:	e8 4b 9c ff ff       	call   80100360 <panic>
80106715:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106720 <inituvm>:
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	57                   	push   %edi
80106724:	56                   	push   %esi
80106725:	53                   	push   %ebx
80106726:	83 ec 2c             	sub    $0x2c,%esp
80106729:	8b 75 10             	mov    0x10(%ebp),%esi
8010672c:	8b 55 08             	mov    0x8(%ebp),%edx
8010672f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106732:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106738:	77 64                	ja     8010679e <inituvm+0x7e>
8010673a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
8010673d:	e8 7e bd ff ff       	call   801024c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106742:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106749:	00 
8010674a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106751:	00 
80106752:	89 04 24             	mov    %eax,(%esp)
  mem = kalloc();
80106755:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106757:	e8 44 db ff ff       	call   801042a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010675c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010675f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106765:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010676c:	00 
8010676d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106771:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106778:	00 
80106779:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106780:	00 
80106781:	89 14 24             	mov    %edx,(%esp)
80106784:	e8 e7 fd ff ff       	call   80106570 <mappages>
  memmove(mem, init, sz);
80106789:	89 75 10             	mov    %esi,0x10(%ebp)
8010678c:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010678f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106792:	83 c4 2c             	add    $0x2c,%esp
80106795:	5b                   	pop    %ebx
80106796:	5e                   	pop    %esi
80106797:	5f                   	pop    %edi
80106798:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106799:	e9 a2 db ff ff       	jmp    80104340 <memmove>
    panic("inituvm: more than a page");
8010679e:	c7 04 24 9d 77 10 80 	movl   $0x8010779d,(%esp)
801067a5:	e8 b6 9b ff ff       	call   80100360 <panic>
801067aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067b0 <loaduvm>:
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	56                   	push   %esi
801067b5:	53                   	push   %ebx
801067b6:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
801067b9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801067c0:	0f 85 98 00 00 00    	jne    8010685e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
801067c6:	8b 75 18             	mov    0x18(%ebp),%esi
801067c9:	31 db                	xor    %ebx,%ebx
801067cb:	85 f6                	test   %esi,%esi
801067cd:	75 1a                	jne    801067e9 <loaduvm+0x39>
801067cf:	eb 77                	jmp    80106848 <loaduvm+0x98>
801067d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067de:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801067e4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801067e7:	76 5f                	jbe    80106848 <loaduvm+0x98>
801067e9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801067ec:	31 c9                	xor    %ecx,%ecx
801067ee:	8b 45 08             	mov    0x8(%ebp),%eax
801067f1:	01 da                	add    %ebx,%edx
801067f3:	e8 88 fb ff ff       	call   80106380 <walkpgdir>
801067f8:	85 c0                	test   %eax,%eax
801067fa:	74 56                	je     80106852 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
801067fc:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
801067fe:	bf 00 10 00 00       	mov    $0x1000,%edi
80106803:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106806:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
8010680b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106811:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106814:	05 00 00 00 80       	add    $0x80000000,%eax
80106819:	89 44 24 04          	mov    %eax,0x4(%esp)
8010681d:	8b 45 10             	mov    0x10(%ebp),%eax
80106820:	01 d9                	add    %ebx,%ecx
80106822:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106826:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010682a:	89 04 24             	mov    %eax,(%esp)
8010682d:	e8 4e b1 ff ff       	call   80101980 <readi>
80106832:	39 f8                	cmp    %edi,%eax
80106834:	74 a2                	je     801067d8 <loaduvm+0x28>
}
80106836:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010683e:	5b                   	pop    %ebx
8010683f:	5e                   	pop    %esi
80106840:	5f                   	pop    %edi
80106841:	5d                   	pop    %ebp
80106842:	c3                   	ret    
80106843:	90                   	nop
80106844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106848:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010684b:	31 c0                	xor    %eax,%eax
}
8010684d:	5b                   	pop    %ebx
8010684e:	5e                   	pop    %esi
8010684f:	5f                   	pop    %edi
80106850:	5d                   	pop    %ebp
80106851:	c3                   	ret    
      panic("loaduvm: address should exist");
80106852:	c7 04 24 b7 77 10 80 	movl   $0x801077b7,(%esp)
80106859:	e8 02 9b ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
8010685e:	c7 04 24 58 78 10 80 	movl   $0x80107858,(%esp)
80106865:	e8 f6 9a ff ff       	call   80100360 <panic>
8010686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106870 <allocuvm>:
{
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	57                   	push   %edi
80106874:	56                   	push   %esi
80106875:	53                   	push   %ebx
80106876:	83 ec 2c             	sub    $0x2c,%esp
80106879:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010687c:	85 ff                	test   %edi,%edi
8010687e:	0f 88 8f 00 00 00    	js     80106913 <allocuvm+0xa3>
  if(newsz < oldsz)
80106884:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106887:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
8010688a:	0f 82 85 00 00 00    	jb     80106915 <allocuvm+0xa5>
  a = PGROUNDUP(oldsz);
80106890:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106896:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010689c:	39 df                	cmp    %ebx,%edi
8010689e:	77 57                	ja     801068f7 <allocuvm+0x87>
801068a0:	eb 7e                	jmp    80106920 <allocuvm+0xb0>
801068a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801068a8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068af:	00 
801068b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068b7:	00 
801068b8:	89 04 24             	mov    %eax,(%esp)
801068bb:	e8 e0 d9 ff ff       	call   801042a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801068c0:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801068c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
801068ca:	8b 45 08             	mov    0x8(%ebp),%eax
801068cd:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801068d4:	00 
801068d5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068dc:	00 
801068dd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801068e1:	89 04 24             	mov    %eax,(%esp)
801068e4:	e8 87 fc ff ff       	call   80106570 <mappages>
801068e9:	85 c0                	test   %eax,%eax
801068eb:	78 43                	js     80106930 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801068ed:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068f3:	39 df                	cmp    %ebx,%edi
801068f5:	76 29                	jbe    80106920 <allocuvm+0xb0>
    mem = kalloc();
801068f7:	e8 c4 bb ff ff       	call   801024c0 <kalloc>
    if(mem == 0){
801068fc:	85 c0                	test   %eax,%eax
    mem = kalloc();
801068fe:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106900:	75 a6                	jne    801068a8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106902:	c7 04 24 d5 77 10 80 	movl   $0x801077d5,(%esp)
80106909:	e8 42 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010690e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106911:	77 47                	ja     8010695a <allocuvm+0xea>
      return 0;
80106913:	31 c0                	xor    %eax,%eax
}
80106915:	83 c4 2c             	add    $0x2c,%esp
80106918:	5b                   	pop    %ebx
80106919:	5e                   	pop    %esi
8010691a:	5f                   	pop    %edi
8010691b:	5d                   	pop    %ebp
8010691c:	c3                   	ret    
8010691d:	8d 76 00             	lea    0x0(%esi),%esi
80106920:	83 c4 2c             	add    $0x2c,%esp
80106923:	89 f8                	mov    %edi,%eax
80106925:	5b                   	pop    %ebx
80106926:	5e                   	pop    %esi
80106927:	5f                   	pop    %edi
80106928:	5d                   	pop    %ebp
80106929:	c3                   	ret    
8010692a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106930:	c7 04 24 ed 77 10 80 	movl   $0x801077ed,(%esp)
80106937:	e8 14 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010693c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010693f:	76 0d                	jbe    8010694e <allocuvm+0xde>
80106941:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106944:	89 fa                	mov    %edi,%edx
80106946:	8b 45 08             	mov    0x8(%ebp),%eax
80106949:	e8 c2 fa ff ff       	call   80106410 <deallocuvm.part.0>
      kfree(mem);
8010694e:	89 34 24             	mov    %esi,(%esp)
80106951:	e8 ba b9 ff ff       	call   80102310 <kfree>
      return 0;
80106956:	31 c0                	xor    %eax,%eax
80106958:	eb bb                	jmp    80106915 <allocuvm+0xa5>
8010695a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010695d:	89 fa                	mov    %edi,%edx
8010695f:	8b 45 08             	mov    0x8(%ebp),%eax
80106962:	e8 a9 fa ff ff       	call   80106410 <deallocuvm.part.0>
      return 0;
80106967:	31 c0                	xor    %eax,%eax
80106969:	eb aa                	jmp    80106915 <allocuvm+0xa5>
8010696b:	90                   	nop
8010696c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106970 <deallocuvm>:
{
80106970:	55                   	push   %ebp
80106971:	89 e5                	mov    %esp,%ebp
80106973:	8b 55 0c             	mov    0xc(%ebp),%edx
80106976:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106979:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010697c:	39 d1                	cmp    %edx,%ecx
8010697e:	73 08                	jae    80106988 <deallocuvm+0x18>
}
80106980:	5d                   	pop    %ebp
80106981:	e9 8a fa ff ff       	jmp    80106410 <deallocuvm.part.0>
80106986:	66 90                	xchg   %ax,%ax
80106988:	89 d0                	mov    %edx,%eax
8010698a:	5d                   	pop    %ebp
8010698b:	c3                   	ret    
8010698c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106990 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	56                   	push   %esi
80106994:	53                   	push   %ebx
80106995:	83 ec 10             	sub    $0x10,%esp
80106998:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010699b:	85 f6                	test   %esi,%esi
8010699d:	74 59                	je     801069f8 <freevm+0x68>
8010699f:	31 c9                	xor    %ecx,%ecx
801069a1:	ba 00 00 00 80       	mov    $0x80000000,%edx
801069a6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801069a8:	31 db                	xor    %ebx,%ebx
801069aa:	e8 61 fa ff ff       	call   80106410 <deallocuvm.part.0>
801069af:	eb 12                	jmp    801069c3 <freevm+0x33>
801069b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069b8:	83 c3 01             	add    $0x1,%ebx
801069bb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801069c1:	74 27                	je     801069ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801069c3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
801069c6:	f6 c2 01             	test   $0x1,%dl
801069c9:	74 ed                	je     801069b8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801069cb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
801069d1:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801069d4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801069da:	89 14 24             	mov    %edx,(%esp)
801069dd:	e8 2e b9 ff ff       	call   80102310 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
801069e2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801069e8:	75 d9                	jne    801069c3 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
801069ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801069ed:	83 c4 10             	add    $0x10,%esp
801069f0:	5b                   	pop    %ebx
801069f1:	5e                   	pop    %esi
801069f2:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801069f3:	e9 18 b9 ff ff       	jmp    80102310 <kfree>
    panic("freevm: no pgdir");
801069f8:	c7 04 24 09 78 10 80 	movl   $0x80107809,(%esp)
801069ff:	e8 5c 99 ff ff       	call   80100360 <panic>
80106a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a10 <setupkvm>:
{
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	56                   	push   %esi
80106a14:	53                   	push   %ebx
80106a15:	83 ec 20             	sub    $0x20,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106a18:	e8 a3 ba ff ff       	call   801024c0 <kalloc>
80106a1d:	85 c0                	test   %eax,%eax
80106a1f:	89 c6                	mov    %eax,%esi
80106a21:	74 75                	je     80106a98 <setupkvm+0x88>
  memset(pgdir, 0, PGSIZE);
80106a23:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a2a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a2b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106a30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a37:	00 
80106a38:	89 04 24             	mov    %eax,(%esp)
80106a3b:	e8 60 d8 ff ff       	call   801042a0 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106a40:	8b 53 0c             	mov    0xc(%ebx),%edx
80106a43:	8b 43 04             	mov    0x4(%ebx),%eax
80106a46:	89 34 24             	mov    %esi,(%esp)
80106a49:	89 54 24 10          	mov    %edx,0x10(%esp)
80106a4d:	8b 53 08             	mov    0x8(%ebx),%edx
80106a50:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106a54:	29 c2                	sub    %eax,%edx
80106a56:	8b 03                	mov    (%ebx),%eax
80106a58:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a60:	e8 0b fb ff ff       	call   80106570 <mappages>
80106a65:	85 c0                	test   %eax,%eax
80106a67:	78 17                	js     80106a80 <setupkvm+0x70>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a69:	83 c3 10             	add    $0x10,%ebx
80106a6c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106a72:	72 cc                	jb     80106a40 <setupkvm+0x30>
80106a74:	89 f0                	mov    %esi,%eax
}
80106a76:	83 c4 20             	add    $0x20,%esp
80106a79:	5b                   	pop    %ebx
80106a7a:	5e                   	pop    %esi
80106a7b:	5d                   	pop    %ebp
80106a7c:	c3                   	ret    
80106a7d:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
80106a80:	89 34 24             	mov    %esi,(%esp)
80106a83:	e8 08 ff ff ff       	call   80106990 <freevm>
}
80106a88:	83 c4 20             	add    $0x20,%esp
      return 0;
80106a8b:	31 c0                	xor    %eax,%eax
}
80106a8d:	5b                   	pop    %ebx
80106a8e:	5e                   	pop    %esi
80106a8f:	5d                   	pop    %ebp
80106a90:	c3                   	ret    
80106a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106a98:	31 c0                	xor    %eax,%eax
80106a9a:	eb da                	jmp    80106a76 <setupkvm+0x66>
80106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <kvmalloc>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106aa6:	e8 65 ff ff ff       	call   80106a10 <setupkvm>
80106aab:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ab0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ab5:	0f 22 d8             	mov    %eax,%cr3
}
80106ab8:	c9                   	leave  
80106ab9:	c3                   	ret    
80106aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ac0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ac0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ac1:	31 c9                	xor    %ecx,%ecx
{
80106ac3:	89 e5                	mov    %esp,%ebp
80106ac5:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106acb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ace:	e8 ad f8 ff ff       	call   80106380 <walkpgdir>
  if(pte == 0)
80106ad3:	85 c0                	test   %eax,%eax
80106ad5:	74 05                	je     80106adc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ad7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106ada:	c9                   	leave  
80106adb:	c3                   	ret    
    panic("clearpteu");
80106adc:	c7 04 24 1a 78 10 80 	movl   $0x8010781a,(%esp)
80106ae3:	e8 78 98 ff ff       	call   80100360 <panic>
80106ae8:	90                   	nop
80106ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106af0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
80106af6:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p = myproc(); // Lab3
80106af9:	e8 c2 cb ff ff       	call   801036c0 <myproc>
80106afe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106b01:	e8 0a ff ff ff       	call   80106a10 <setupkvm>
80106b06:	85 c0                	test   %eax,%eax
80106b08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b0b:	0f 84 85 01 00 00    	je     80106c96 <copyuvm+0x1a6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b11:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b14:	85 c0                	test   %eax,%eax
80106b16:	0f 84 bc 00 00 00    	je     80106bd8 <copyuvm+0xe8>
80106b1c:	31 db                	xor    %ebx,%ebx
80106b1e:	eb 51                	jmp    80106b71 <copyuvm+0x81>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106b20:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106b26:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b2d:	00 
80106b2e:	89 74 24 04          	mov    %esi,0x4(%esp)
80106b32:	89 04 24             	mov    %eax,(%esp)
80106b35:	e8 06 d8 ff ff       	call   80104340 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b3d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b44:	00 
80106b45:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106b49:	89 44 24 10          	mov    %eax,0x10(%esp)
80106b4d:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106b53:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106b57:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b5a:	89 04 24             	mov    %eax,(%esp)
80106b5d:	e8 0e fa ff ff       	call   80106570 <mappages>
80106b62:	85 c0                	test   %eax,%eax
80106b64:	78 62                	js     80106bc8 <copyuvm+0xd8>
  for(i = 0; i < sz; i += PGSIZE){
80106b66:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b6c:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106b6f:	76 67                	jbe    80106bd8 <copyuvm+0xe8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b71:	8b 45 08             	mov    0x8(%ebp),%eax
80106b74:	31 c9                	xor    %ecx,%ecx
80106b76:	89 da                	mov    %ebx,%edx
80106b78:	e8 03 f8 ff ff       	call   80106380 <walkpgdir>
80106b7d:	85 c0                	test   %eax,%eax
80106b7f:	0f 84 24 01 00 00    	je     80106ca9 <copyuvm+0x1b9>
    if(!(*pte & PTE_P))
80106b85:	8b 38                	mov    (%eax),%edi
80106b87:	f7 c7 01 00 00 00    	test   $0x1,%edi
80106b8d:	0f 84 0a 01 00 00    	je     80106c9d <copyuvm+0x1ad>
    pa = PTE_ADDR(*pte);
80106b93:	89 fe                	mov    %edi,%esi
    flags = PTE_FLAGS(*pte);
80106b95:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80106b9b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106b9e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80106ba4:	e8 17 b9 ff ff       	call   801024c0 <kalloc>
80106ba9:	85 c0                	test   %eax,%eax
80106bab:	89 c7                	mov    %eax,%edi
80106bad:	0f 85 6d ff ff ff    	jne    80106b20 <copyuvm+0x30>
    }
  }  
  return d;

bad:
  freevm(d);
80106bb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bb6:	89 04 24             	mov    %eax,(%esp)
80106bb9:	e8 d2 fd ff ff       	call   80106990 <freevm>
  return 0;
80106bbe:	31 c0                	xor    %eax,%eax
}
80106bc0:	83 c4 2c             	add    $0x2c,%esp
80106bc3:	5b                   	pop    %ebx
80106bc4:	5e                   	pop    %esi
80106bc5:	5f                   	pop    %edi
80106bc6:	5d                   	pop    %ebp
80106bc7:	c3                   	ret    
      kfree(mem);
80106bc8:	89 3c 24             	mov    %edi,(%esp)
80106bcb:	e8 40 b7 ff ff       	call   80102310 <kfree>
      goto bad;
80106bd0:	eb e1                	jmp    80106bb3 <copyuvm+0xc3>
80106bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = (STACKBASE - p->npages * PGSIZE + 4); i < STACKBASE; i += PGSIZE){
80106bd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106bdb:	8b 58 7c             	mov    0x7c(%eax),%ebx
80106bde:	f7 db                	neg    %ebx
80106be0:	c1 e3 0c             	shl    $0xc,%ebx
80106be3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106be9:	81 fb fb ff ff 7f    	cmp    $0x7ffffffb,%ebx
80106bef:	76 5b                	jbe    80106c4c <copyuvm+0x15c>
80106bf1:	e9 95 00 00 00       	jmp    80106c8b <copyuvm+0x19b>
80106bf6:	66 90                	xchg   %ax,%ax
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106bf8:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106bfe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c05:	00 
80106c06:	89 74 24 04          	mov    %esi,0x4(%esp)
80106c0a:	89 04 24             	mov    %eax,(%esp)
80106c0d:	e8 2e d7 ff ff       	call   80104340 <memmove>
    if(mappages(d, (void*) i, PGSIZE, V2P(mem), flags) < 0) {
80106c12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c15:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c1c:	00 
80106c1d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106c21:	89 44 24 10          	mov    %eax,0x10(%esp)
80106c25:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106c2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106c2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c32:	89 04 24             	mov    %eax,(%esp)
80106c35:	e8 36 f9 ff ff       	call   80106570 <mappages>
80106c3a:	85 c0                	test   %eax,%eax
80106c3c:	78 8a                	js     80106bc8 <copyuvm+0xd8>
  for(i = (STACKBASE - p->npages * PGSIZE + 4); i < STACKBASE; i += PGSIZE){
80106c3e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c44:	81 fb fb ff ff 7f    	cmp    $0x7ffffffb,%ebx
80106c4a:	77 3f                	ja     80106c8b <copyuvm+0x19b>
    if((pte = walkpgdir(pgdir, (void *)i, 0)) == 0)
80106c4c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c4f:	31 c9                	xor    %ecx,%ecx
80106c51:	89 da                	mov    %ebx,%edx
80106c53:	e8 28 f7 ff ff       	call   80106380 <walkpgdir>
80106c58:	85 c0                	test   %eax,%eax
80106c5a:	74 4d                	je     80106ca9 <copyuvm+0x1b9>
    if(!(*pte & PTE_P))
80106c5c:	8b 38                	mov    (%eax),%edi
80106c5e:	f7 c7 01 00 00 00    	test   $0x1,%edi
80106c64:	74 37                	je     80106c9d <copyuvm+0x1ad>
    pa = PTE_ADDR(*pte);
80106c66:	89 fe                	mov    %edi,%esi
    flags = PTE_FLAGS(*pte);
80106c68:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80106c6e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106c71:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80106c77:	e8 44 b8 ff ff       	call   801024c0 <kalloc>
80106c7c:	85 c0                	test   %eax,%eax
80106c7e:	89 c7                	mov    %eax,%edi
80106c80:	0f 85 72 ff ff ff    	jne    80106bf8 <copyuvm+0x108>
80106c86:	e9 28 ff ff ff       	jmp    80106bb3 <copyuvm+0xc3>
80106c8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80106c8e:	83 c4 2c             	add    $0x2c,%esp
80106c91:	5b                   	pop    %ebx
80106c92:	5e                   	pop    %esi
80106c93:	5f                   	pop    %edi
80106c94:	5d                   	pop    %ebp
80106c95:	c3                   	ret    
    return 0;
80106c96:	31 c0                	xor    %eax,%eax
80106c98:	e9 23 ff ff ff       	jmp    80106bc0 <copyuvm+0xd0>
      panic("copyuvm: page not present");
80106c9d:	c7 04 24 3e 78 10 80 	movl   $0x8010783e,(%esp)
80106ca4:	e8 b7 96 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106ca9:	c7 04 24 24 78 10 80 	movl   $0x80107824,(%esp)
80106cb0:	e8 ab 96 ff ff       	call   80100360 <panic>
80106cb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cc0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106cc0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106cc1:	31 c9                	xor    %ecx,%ecx
{
80106cc3:	89 e5                	mov    %esp,%ebp
80106cc5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80106cce:	e8 ad f6 ff ff       	call   80106380 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106cd3:	8b 00                	mov    (%eax),%eax
80106cd5:	89 c2                	mov    %eax,%edx
80106cd7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106cda:	83 fa 05             	cmp    $0x5,%edx
80106cdd:	75 11                	jne    80106cf0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106cdf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ce4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106ce9:	c9                   	leave  
80106cea:	c3                   	ret    
80106ceb:	90                   	nop
80106cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106cf0:	31 c0                	xor    %eax,%eax
}
80106cf2:	c9                   	leave  
80106cf3:	c3                   	ret    
80106cf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 1c             	sub    $0x1c,%esp
80106d09:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d12:	85 db                	test   %ebx,%ebx
80106d14:	75 3a                	jne    80106d50 <copyout+0x50>
80106d16:	eb 68                	jmp    80106d80 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d18:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d1b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d1d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106d21:	29 ca                	sub    %ecx,%edx
80106d23:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106d29:	39 da                	cmp    %ebx,%edx
80106d2b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106d2e:	29 f1                	sub    %esi,%ecx
80106d30:	01 c8                	add    %ecx,%eax
80106d32:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d36:	89 04 24             	mov    %eax,(%esp)
80106d39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106d3c:	e8 ff d5 ff ff       	call   80104340 <memmove>
    len -= n;
    buf += n;
80106d41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106d44:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106d4a:	01 d7                	add    %edx,%edi
  while(len > 0){
80106d4c:	29 d3                	sub    %edx,%ebx
80106d4e:	74 30                	je     80106d80 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106d50:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106d53:	89 ce                	mov    %ecx,%esi
80106d55:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106d5b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106d5f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106d62:	89 04 24             	mov    %eax,(%esp)
80106d65:	e8 56 ff ff ff       	call   80106cc0 <uva2ka>
    if(pa0 == 0)
80106d6a:	85 c0                	test   %eax,%eax
80106d6c:	75 aa                	jne    80106d18 <copyout+0x18>
  }
  return 0;
}
80106d6e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d76:	5b                   	pop    %ebx
80106d77:	5e                   	pop    %esi
80106d78:	5f                   	pop    %edi
80106d79:	5d                   	pop    %ebp
80106d7a:	c3                   	ret    
80106d7b:	90                   	nop
80106d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d80:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106d83:	31 c0                	xor    %eax,%eax
}
80106d85:	5b                   	pop    %ebx
80106d86:	5e                   	pop    %esi
80106d87:	5f                   	pop    %edi
80106d88:	5d                   	pop    %ebp
80106d89:	c3                   	ret    
80106d8a:	66 90                	xchg   %ax,%ax
80106d8c:	66 90                	xchg   %ax,%ax
80106d8e:	66 90                	xchg   %ax,%ax

80106d90 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106d96:	c7 44 24 04 7c 78 10 	movl   $0x8010787c,0x4(%esp)
80106d9d:	80 
80106d9e:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106da5:	e8 c6 d2 ff ff       	call   80104070 <initlock>
  acquire(&(shm_table.lock));
80106daa:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106db1:	e8 aa d3 ff ff       	call   80104160 <acquire>
80106db6:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80106dbb:	90                   	nop
80106dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106dc6:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80106dc9:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80106dd0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (i = 0; i< 64; i++) {
80106dd7:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
80106ddc:	75 e2                	jne    80106dc0 <shminit+0x30>
  }
  release(&(shm_table.lock));
80106dde:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106de5:	e8 66 d4 ff ff       	call   80104250 <release>
}
80106dea:	c9                   	leave  
80106deb:	c3                   	ret    
80106dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106df0 <shm_open>:

int shm_open(int id, char **pointer) {
80106df0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106df1:	31 c0                	xor    %eax,%eax
int shm_open(int id, char **pointer) {
80106df3:	89 e5                	mov    %esp,%ebp
}
80106df5:	5d                   	pop    %ebp
80106df6:	c3                   	ret    
80106df7:	89 f6                	mov    %esi,%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e00 <shm_close>:


int shm_close(int id) {
80106e00:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106e01:	31 c0                	xor    %eax,%eax
int shm_close(int id) {
80106e03:	89 e5                	mov    %esp,%ebp
}
80106e05:	5d                   	pop    %ebp
80106e06:	c3                   	ret    
