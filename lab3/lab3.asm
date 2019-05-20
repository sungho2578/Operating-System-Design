
_lab3:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
}
#pragma GCC pop_options

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	83 ec 10             	sub    $0x10,%esp
    100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  int n, m;

  if(argc != 2){
    100d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
    1011:	74 1f                	je     1032 <main+0x32>
    printf(1, "Usage: %s levels\n", argv[0]);
    1013:	8b 00                	mov    (%eax),%eax
    1015:	c7 44 24 04 d1 17 00 	movl   $0x17d1,0x4(%esp)
    101c:	00 
    101d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1024:	89 44 24 08          	mov    %eax,0x8(%esp)
    1028:	e8 03 04 00 00       	call   1430 <printf>
    exit();
    102d:	e8 a0 02 00 00       	call   12d2 <exit>
  }

  n = atoi(argv[1]);
    1032:	8b 40 04             	mov    0x4(%eax),%eax
    1035:	89 04 24             	mov    %eax,(%esp)
    1038:	e8 33 02 00 00       	call   1270 <atoi>
  printf(1, "Lab 3: Recursing %d levels\n", n);
    103d:	c7 44 24 04 e3 17 00 	movl   $0x17e3,0x4(%esp)
    1044:	00 
    1045:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  n = atoi(argv[1]);
    104c:	89 c3                	mov    %eax,%ebx
  printf(1, "Lab 3: Recursing %d levels\n", n);
    104e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1052:	e8 d9 03 00 00       	call   1430 <printf>
  m = recurse(n);
    1057:	89 1c 24             	mov    %ebx,(%esp)
    105a:	e8 21 00 00 00       	call   1080 <recurse>
  printf(1, "Lab 3: Yielded a value of %d\n", m);
    105f:	c7 44 24 04 ff 17 00 	movl   $0x17ff,0x4(%esp)
    1066:	00 
    1067:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    106e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1072:	e8 b9 03 00 00       	call   1430 <printf>
  exit();
    1077:	e8 56 02 00 00       	call   12d2 <exit>
    107c:	66 90                	xchg   %ax,%ax
    107e:	66 90                	xchg   %ax,%ax

00001080 <recurse>:
{
    1080:	55                   	push   %ebp
    1081:	89 e5                	mov    %esp,%ebp
    1083:	83 ec 18             	sub    $0x18,%esp
  if(n == 0)
    1086:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    108a:	75 07                	jne    1093 <recurse+0x13>
    return 0;
    108c:	b8 00 00 00 00       	mov    $0x0,%eax
    1091:	eb 13                	jmp    10a6 <recurse+0x26>
  return n + recurse(n - 1);
    1093:	8b 45 08             	mov    0x8(%ebp),%eax
    1096:	83 e8 01             	sub    $0x1,%eax
    1099:	89 04 24             	mov    %eax,(%esp)
    109c:	e8 df ff ff ff       	call   1080 <recurse>
    10a1:	8b 55 08             	mov    0x8(%ebp),%edx
    10a4:	01 d0                	add    %edx,%eax
}
    10a6:	c9                   	leave  
    10a7:	c3                   	ret    
    10a8:	66 90                	xchg   %ax,%ax
    10aa:	66 90                	xchg   %ax,%ax
    10ac:	66 90                	xchg   %ax,%ax
    10ae:	66 90                	xchg   %ax,%ax

000010b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10b0:	55                   	push   %ebp
    10b1:	89 e5                	mov    %esp,%ebp
    10b3:	8b 45 08             	mov    0x8(%ebp),%eax
    10b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    10b9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10ba:	89 c2                	mov    %eax,%edx
    10bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10c0:	83 c1 01             	add    $0x1,%ecx
    10c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    10c7:	83 c2 01             	add    $0x1,%edx
    10ca:	84 db                	test   %bl,%bl
    10cc:	88 5a ff             	mov    %bl,-0x1(%edx)
    10cf:	75 ef                	jne    10c0 <strcpy+0x10>
    ;
  return os;
}
    10d1:	5b                   	pop    %ebx
    10d2:	5d                   	pop    %ebp
    10d3:	c3                   	ret    
    10d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    10da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000010e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10e0:	55                   	push   %ebp
    10e1:	89 e5                	mov    %esp,%ebp
    10e3:	8b 55 08             	mov    0x8(%ebp),%edx
    10e6:	53                   	push   %ebx
    10e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    10ea:	0f b6 02             	movzbl (%edx),%eax
    10ed:	84 c0                	test   %al,%al
    10ef:	74 2d                	je     111e <strcmp+0x3e>
    10f1:	0f b6 19             	movzbl (%ecx),%ebx
    10f4:	38 d8                	cmp    %bl,%al
    10f6:	74 0e                	je     1106 <strcmp+0x26>
    10f8:	eb 2b                	jmp    1125 <strcmp+0x45>
    10fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1100:	38 c8                	cmp    %cl,%al
    1102:	75 15                	jne    1119 <strcmp+0x39>
    p++, q++;
    1104:	89 d9                	mov    %ebx,%ecx
    1106:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1109:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    110c:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
    110f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
    1113:	84 c0                	test   %al,%al
    1115:	75 e9                	jne    1100 <strcmp+0x20>
    1117:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    1119:	29 c8                	sub    %ecx,%eax
}
    111b:	5b                   	pop    %ebx
    111c:	5d                   	pop    %ebp
    111d:	c3                   	ret    
    111e:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
    1121:	31 c0                	xor    %eax,%eax
    1123:	eb f4                	jmp    1119 <strcmp+0x39>
    1125:	0f b6 cb             	movzbl %bl,%ecx
    1128:	eb ef                	jmp    1119 <strcmp+0x39>
    112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001130 <strlen>:

uint
strlen(char *s)
{
    1130:	55                   	push   %ebp
    1131:	89 e5                	mov    %esp,%ebp
    1133:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1136:	80 39 00             	cmpb   $0x0,(%ecx)
    1139:	74 12                	je     114d <strlen+0x1d>
    113b:	31 d2                	xor    %edx,%edx
    113d:	8d 76 00             	lea    0x0(%esi),%esi
    1140:	83 c2 01             	add    $0x1,%edx
    1143:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1147:	89 d0                	mov    %edx,%eax
    1149:	75 f5                	jne    1140 <strlen+0x10>
    ;
  return n;
}
    114b:	5d                   	pop    %ebp
    114c:	c3                   	ret    
  for(n = 0; s[n]; n++)
    114d:	31 c0                	xor    %eax,%eax
}
    114f:	5d                   	pop    %ebp
    1150:	c3                   	ret    
    1151:	eb 0d                	jmp    1160 <memset>
    1153:	90                   	nop
    1154:	90                   	nop
    1155:	90                   	nop
    1156:	90                   	nop
    1157:	90                   	nop
    1158:	90                   	nop
    1159:	90                   	nop
    115a:	90                   	nop
    115b:	90                   	nop
    115c:	90                   	nop
    115d:	90                   	nop
    115e:	90                   	nop
    115f:	90                   	nop

00001160 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1160:	55                   	push   %ebp
    1161:	89 e5                	mov    %esp,%ebp
    1163:	8b 55 08             	mov    0x8(%ebp),%edx
    1166:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1167:	8b 4d 10             	mov    0x10(%ebp),%ecx
    116a:	8b 45 0c             	mov    0xc(%ebp),%eax
    116d:	89 d7                	mov    %edx,%edi
    116f:	fc                   	cld    
    1170:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1172:	89 d0                	mov    %edx,%eax
    1174:	5f                   	pop    %edi
    1175:	5d                   	pop    %ebp
    1176:	c3                   	ret    
    1177:	89 f6                	mov    %esi,%esi
    1179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001180 <strchr>:

char*
strchr(const char *s, char c)
{
    1180:	55                   	push   %ebp
    1181:	89 e5                	mov    %esp,%ebp
    1183:	8b 45 08             	mov    0x8(%ebp),%eax
    1186:	53                   	push   %ebx
    1187:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
    118a:	0f b6 18             	movzbl (%eax),%ebx
    118d:	84 db                	test   %bl,%bl
    118f:	74 1d                	je     11ae <strchr+0x2e>
    if(*s == c)
    1191:	38 d3                	cmp    %dl,%bl
    1193:	89 d1                	mov    %edx,%ecx
    1195:	75 0d                	jne    11a4 <strchr+0x24>
    1197:	eb 17                	jmp    11b0 <strchr+0x30>
    1199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11a0:	38 ca                	cmp    %cl,%dl
    11a2:	74 0c                	je     11b0 <strchr+0x30>
  for(; *s; s++)
    11a4:	83 c0 01             	add    $0x1,%eax
    11a7:	0f b6 10             	movzbl (%eax),%edx
    11aa:	84 d2                	test   %dl,%dl
    11ac:	75 f2                	jne    11a0 <strchr+0x20>
      return (char*)s;
  return 0;
    11ae:	31 c0                	xor    %eax,%eax
}
    11b0:	5b                   	pop    %ebx
    11b1:	5d                   	pop    %ebp
    11b2:	c3                   	ret    
    11b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    11b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000011c0 <gets>:

char*
gets(char *buf, int max)
{
    11c0:	55                   	push   %ebp
    11c1:	89 e5                	mov    %esp,%ebp
    11c3:	57                   	push   %edi
    11c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11c5:	31 f6                	xor    %esi,%esi
{
    11c7:	53                   	push   %ebx
    11c8:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
    11cb:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    11ce:	eb 31                	jmp    1201 <gets+0x41>
    cc = read(0, &c, 1);
    11d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11d7:	00 
    11d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
    11dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11e3:	e8 02 01 00 00       	call   12ea <read>
    if(cc < 1)
    11e8:	85 c0                	test   %eax,%eax
    11ea:	7e 1d                	jle    1209 <gets+0x49>
      break;
    buf[i++] = c;
    11ec:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
    11f0:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
    11f2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
    11f5:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
    11f7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    11fb:	74 0c                	je     1209 <gets+0x49>
    11fd:	3c 0a                	cmp    $0xa,%al
    11ff:	74 08                	je     1209 <gets+0x49>
  for(i=0; i+1 < max; ){
    1201:	8d 5e 01             	lea    0x1(%esi),%ebx
    1204:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1207:	7c c7                	jl     11d0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    1209:	8b 45 08             	mov    0x8(%ebp),%eax
    120c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1210:	83 c4 2c             	add    $0x2c,%esp
    1213:	5b                   	pop    %ebx
    1214:	5e                   	pop    %esi
    1215:	5f                   	pop    %edi
    1216:	5d                   	pop    %ebp
    1217:	c3                   	ret    
    1218:	90                   	nop
    1219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001220 <stat>:

int
stat(char *n, struct stat *st)
{
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	56                   	push   %esi
    1224:	53                   	push   %ebx
    1225:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1228:	8b 45 08             	mov    0x8(%ebp),%eax
    122b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1232:	00 
    1233:	89 04 24             	mov    %eax,(%esp)
    1236:	e8 d7 00 00 00       	call   1312 <open>
  if(fd < 0)
    123b:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
    123d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    123f:	78 27                	js     1268 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    1241:	8b 45 0c             	mov    0xc(%ebp),%eax
    1244:	89 1c 24             	mov    %ebx,(%esp)
    1247:	89 44 24 04          	mov    %eax,0x4(%esp)
    124b:	e8 da 00 00 00       	call   132a <fstat>
  close(fd);
    1250:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    1253:	89 c6                	mov    %eax,%esi
  close(fd);
    1255:	e8 a0 00 00 00       	call   12fa <close>
  return r;
    125a:	89 f0                	mov    %esi,%eax
}
    125c:	83 c4 10             	add    $0x10,%esp
    125f:	5b                   	pop    %ebx
    1260:	5e                   	pop    %esi
    1261:	5d                   	pop    %ebp
    1262:	c3                   	ret    
    1263:	90                   	nop
    1264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    126d:	eb ed                	jmp    125c <stat+0x3c>
    126f:	90                   	nop

00001270 <atoi>:

int
atoi(const char *s)
{
    1270:	55                   	push   %ebp
    1271:	89 e5                	mov    %esp,%ebp
    1273:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1276:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1277:	0f be 11             	movsbl (%ecx),%edx
    127a:	8d 42 d0             	lea    -0x30(%edx),%eax
    127d:	3c 09                	cmp    $0x9,%al
  n = 0;
    127f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1284:	77 17                	ja     129d <atoi+0x2d>
    1286:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1288:	83 c1 01             	add    $0x1,%ecx
    128b:	8d 04 80             	lea    (%eax,%eax,4),%eax
    128e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    1292:	0f be 11             	movsbl (%ecx),%edx
    1295:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1298:	80 fb 09             	cmp    $0x9,%bl
    129b:	76 eb                	jbe    1288 <atoi+0x18>
  return n;
}
    129d:	5b                   	pop    %ebx
    129e:	5d                   	pop    %ebp
    129f:	c3                   	ret    

000012a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12a0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12a1:	31 d2                	xor    %edx,%edx
{
    12a3:	89 e5                	mov    %esp,%ebp
    12a5:	56                   	push   %esi
    12a6:	8b 45 08             	mov    0x8(%ebp),%eax
    12a9:	53                   	push   %ebx
    12aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
    12ad:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
    12b0:	85 db                	test   %ebx,%ebx
    12b2:	7e 12                	jle    12c6 <memmove+0x26>
    12b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    12b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    12bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    12bf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    12c2:	39 da                	cmp    %ebx,%edx
    12c4:	75 f2                	jne    12b8 <memmove+0x18>
  return vdst;
}
    12c6:	5b                   	pop    %ebx
    12c7:	5e                   	pop    %esi
    12c8:	5d                   	pop    %ebp
    12c9:	c3                   	ret    

000012ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12ca:	b8 01 00 00 00       	mov    $0x1,%eax
    12cf:	cd 40                	int    $0x40
    12d1:	c3                   	ret    

000012d2 <exit>:
SYSCALL(exit)
    12d2:	b8 02 00 00 00       	mov    $0x2,%eax
    12d7:	cd 40                	int    $0x40
    12d9:	c3                   	ret    

000012da <wait>:
SYSCALL(wait)
    12da:	b8 03 00 00 00       	mov    $0x3,%eax
    12df:	cd 40                	int    $0x40
    12e1:	c3                   	ret    

000012e2 <pipe>:
SYSCALL(pipe)
    12e2:	b8 04 00 00 00       	mov    $0x4,%eax
    12e7:	cd 40                	int    $0x40
    12e9:	c3                   	ret    

000012ea <read>:
SYSCALL(read)
    12ea:	b8 05 00 00 00       	mov    $0x5,%eax
    12ef:	cd 40                	int    $0x40
    12f1:	c3                   	ret    

000012f2 <write>:
SYSCALL(write)
    12f2:	b8 10 00 00 00       	mov    $0x10,%eax
    12f7:	cd 40                	int    $0x40
    12f9:	c3                   	ret    

000012fa <close>:
SYSCALL(close)
    12fa:	b8 15 00 00 00       	mov    $0x15,%eax
    12ff:	cd 40                	int    $0x40
    1301:	c3                   	ret    

00001302 <kill>:
SYSCALL(kill)
    1302:	b8 06 00 00 00       	mov    $0x6,%eax
    1307:	cd 40                	int    $0x40
    1309:	c3                   	ret    

0000130a <exec>:
SYSCALL(exec)
    130a:	b8 07 00 00 00       	mov    $0x7,%eax
    130f:	cd 40                	int    $0x40
    1311:	c3                   	ret    

00001312 <open>:
SYSCALL(open)
    1312:	b8 0f 00 00 00       	mov    $0xf,%eax
    1317:	cd 40                	int    $0x40
    1319:	c3                   	ret    

0000131a <mknod>:
SYSCALL(mknod)
    131a:	b8 11 00 00 00       	mov    $0x11,%eax
    131f:	cd 40                	int    $0x40
    1321:	c3                   	ret    

00001322 <unlink>:
SYSCALL(unlink)
    1322:	b8 12 00 00 00       	mov    $0x12,%eax
    1327:	cd 40                	int    $0x40
    1329:	c3                   	ret    

0000132a <fstat>:
SYSCALL(fstat)
    132a:	b8 08 00 00 00       	mov    $0x8,%eax
    132f:	cd 40                	int    $0x40
    1331:	c3                   	ret    

00001332 <link>:
SYSCALL(link)
    1332:	b8 13 00 00 00       	mov    $0x13,%eax
    1337:	cd 40                	int    $0x40
    1339:	c3                   	ret    

0000133a <mkdir>:
SYSCALL(mkdir)
    133a:	b8 14 00 00 00       	mov    $0x14,%eax
    133f:	cd 40                	int    $0x40
    1341:	c3                   	ret    

00001342 <chdir>:
SYSCALL(chdir)
    1342:	b8 09 00 00 00       	mov    $0x9,%eax
    1347:	cd 40                	int    $0x40
    1349:	c3                   	ret    

0000134a <dup>:
SYSCALL(dup)
    134a:	b8 0a 00 00 00       	mov    $0xa,%eax
    134f:	cd 40                	int    $0x40
    1351:	c3                   	ret    

00001352 <getpid>:
SYSCALL(getpid)
    1352:	b8 0b 00 00 00       	mov    $0xb,%eax
    1357:	cd 40                	int    $0x40
    1359:	c3                   	ret    

0000135a <sbrk>:
SYSCALL(sbrk)
    135a:	b8 0c 00 00 00       	mov    $0xc,%eax
    135f:	cd 40                	int    $0x40
    1361:	c3                   	ret    

00001362 <sleep>:
SYSCALL(sleep)
    1362:	b8 0d 00 00 00       	mov    $0xd,%eax
    1367:	cd 40                	int    $0x40
    1369:	c3                   	ret    

0000136a <uptime>:
SYSCALL(uptime)
    136a:	b8 0e 00 00 00       	mov    $0xe,%eax
    136f:	cd 40                	int    $0x40
    1371:	c3                   	ret    

00001372 <shm_open>:
SYSCALL(shm_open)
    1372:	b8 16 00 00 00       	mov    $0x16,%eax
    1377:	cd 40                	int    $0x40
    1379:	c3                   	ret    

0000137a <shm_close>:
SYSCALL(shm_close)	
    137a:	b8 17 00 00 00       	mov    $0x17,%eax
    137f:	cd 40                	int    $0x40
    1381:	c3                   	ret    
    1382:	66 90                	xchg   %ax,%ax
    1384:	66 90                	xchg   %ax,%ax
    1386:	66 90                	xchg   %ax,%ax
    1388:	66 90                	xchg   %ax,%ax
    138a:	66 90                	xchg   %ax,%ax
    138c:	66 90                	xchg   %ax,%ax
    138e:	66 90                	xchg   %ax,%ax

00001390 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1390:	55                   	push   %ebp
    1391:	89 e5                	mov    %esp,%ebp
    1393:	57                   	push   %edi
    1394:	56                   	push   %esi
    1395:	89 c6                	mov    %eax,%esi
    1397:	53                   	push   %ebx
    1398:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    139b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    139e:	85 db                	test   %ebx,%ebx
    13a0:	74 09                	je     13ab <printint+0x1b>
    13a2:	89 d0                	mov    %edx,%eax
    13a4:	c1 e8 1f             	shr    $0x1f,%eax
    13a7:	84 c0                	test   %al,%al
    13a9:	75 75                	jne    1420 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13ab:	89 d0                	mov    %edx,%eax
  neg = 0;
    13ad:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    13b4:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
    13b7:	31 ff                	xor    %edi,%edi
    13b9:	89 ce                	mov    %ecx,%esi
    13bb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    13be:	eb 02                	jmp    13c2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
    13c0:	89 cf                	mov    %ecx,%edi
    13c2:	31 d2                	xor    %edx,%edx
    13c4:	f7 f6                	div    %esi
    13c6:	8d 4f 01             	lea    0x1(%edi),%ecx
    13c9:	0f b6 92 24 18 00 00 	movzbl 0x1824(%edx),%edx
  }while((x /= base) != 0);
    13d0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    13d2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
    13d5:	75 e9                	jne    13c0 <printint+0x30>
  if(neg)
    13d7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
    13da:	89 c8                	mov    %ecx,%eax
    13dc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
    13df:	85 d2                	test   %edx,%edx
    13e1:	74 08                	je     13eb <printint+0x5b>
    buf[i++] = '-';
    13e3:	8d 4f 02             	lea    0x2(%edi),%ecx
    13e6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
    13eb:	8d 79 ff             	lea    -0x1(%ecx),%edi
    13ee:	66 90                	xchg   %ax,%ax
    13f0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
    13f5:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
    13f8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13ff:	00 
    1400:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    1404:	89 34 24             	mov    %esi,(%esp)
    1407:	88 45 d7             	mov    %al,-0x29(%ebp)
    140a:	e8 e3 fe ff ff       	call   12f2 <write>
  while(--i >= 0)
    140f:	83 ff ff             	cmp    $0xffffffff,%edi
    1412:	75 dc                	jne    13f0 <printint+0x60>
    putc(fd, buf[i]);
}
    1414:	83 c4 4c             	add    $0x4c,%esp
    1417:	5b                   	pop    %ebx
    1418:	5e                   	pop    %esi
    1419:	5f                   	pop    %edi
    141a:	5d                   	pop    %ebp
    141b:	c3                   	ret    
    141c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
    1420:	89 d0                	mov    %edx,%eax
    1422:	f7 d8                	neg    %eax
    neg = 1;
    1424:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    142b:	eb 87                	jmp    13b4 <printint+0x24>
    142d:	8d 76 00             	lea    0x0(%esi),%esi

00001430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1430:	55                   	push   %ebp
    1431:	89 e5                	mov    %esp,%ebp
    1433:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1434:	31 ff                	xor    %edi,%edi
{
    1436:	56                   	push   %esi
    1437:	53                   	push   %ebx
    1438:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    143b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
    143e:	8d 45 10             	lea    0x10(%ebp),%eax
{
    1441:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
    1444:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
    1447:	0f b6 13             	movzbl (%ebx),%edx
    144a:	83 c3 01             	add    $0x1,%ebx
    144d:	84 d2                	test   %dl,%dl
    144f:	75 39                	jne    148a <printf+0x5a>
    1451:	e9 c2 00 00 00       	jmp    1518 <printf+0xe8>
    1456:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1458:	83 fa 25             	cmp    $0x25,%edx
    145b:	0f 84 bf 00 00 00    	je     1520 <printf+0xf0>
  write(fd, &c, 1);
    1461:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1464:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    146b:	00 
    146c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1470:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
    1473:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
    1476:	e8 77 fe ff ff       	call   12f2 <write>
    147b:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
    147e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    1482:	84 d2                	test   %dl,%dl
    1484:	0f 84 8e 00 00 00    	je     1518 <printf+0xe8>
    if(state == 0){
    148a:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
    148c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
    148f:	74 c7                	je     1458 <printf+0x28>
      }
    } else if(state == '%'){
    1491:	83 ff 25             	cmp    $0x25,%edi
    1494:	75 e5                	jne    147b <printf+0x4b>
      if(c == 'd'){
    1496:	83 fa 64             	cmp    $0x64,%edx
    1499:	0f 84 31 01 00 00    	je     15d0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    149f:	25 f7 00 00 00       	and    $0xf7,%eax
    14a4:	83 f8 70             	cmp    $0x70,%eax
    14a7:	0f 84 83 00 00 00    	je     1530 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    14ad:	83 fa 73             	cmp    $0x73,%edx
    14b0:	0f 84 a2 00 00 00    	je     1558 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14b6:	83 fa 63             	cmp    $0x63,%edx
    14b9:	0f 84 35 01 00 00    	je     15f4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    14bf:	83 fa 25             	cmp    $0x25,%edx
    14c2:	0f 84 e0 00 00 00    	je     15a8 <printf+0x178>
  write(fd, &c, 1);
    14c8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    14cb:	83 c3 01             	add    $0x1,%ebx
    14ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14d5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    14d6:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    14d8:	89 44 24 04          	mov    %eax,0x4(%esp)
    14dc:	89 34 24             	mov    %esi,(%esp)
    14df:	89 55 d0             	mov    %edx,-0x30(%ebp)
    14e2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
    14e6:	e8 07 fe ff ff       	call   12f2 <write>
        putc(fd, c);
    14eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
    14ee:	8d 45 e7             	lea    -0x19(%ebp),%eax
    14f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14f8:	00 
    14f9:	89 44 24 04          	mov    %eax,0x4(%esp)
    14fd:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
    1500:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    1503:	e8 ea fd ff ff       	call   12f2 <write>
  for(i = 0; fmt[i]; i++){
    1508:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    150c:	84 d2                	test   %dl,%dl
    150e:	0f 85 76 ff ff ff    	jne    148a <printf+0x5a>
    1514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
    1518:	83 c4 3c             	add    $0x3c,%esp
    151b:	5b                   	pop    %ebx
    151c:	5e                   	pop    %esi
    151d:	5f                   	pop    %edi
    151e:	5d                   	pop    %ebp
    151f:	c3                   	ret    
        state = '%';
    1520:	bf 25 00 00 00       	mov    $0x25,%edi
    1525:	e9 51 ff ff ff       	jmp    147b <printf+0x4b>
    152a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1533:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
    1538:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
    153a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1541:	8b 10                	mov    (%eax),%edx
    1543:	89 f0                	mov    %esi,%eax
    1545:	e8 46 fe ff ff       	call   1390 <printint>
        ap++;
    154a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    154e:	e9 28 ff ff ff       	jmp    147b <printf+0x4b>
    1553:	90                   	nop
    1554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1558:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
    155b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
    155f:	8b 38                	mov    (%eax),%edi
          s = "(null)";
    1561:	b8 1d 18 00 00       	mov    $0x181d,%eax
    1566:	85 ff                	test   %edi,%edi
    1568:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
    156b:	0f b6 07             	movzbl (%edi),%eax
    156e:	84 c0                	test   %al,%al
    1570:	74 2a                	je     159c <printf+0x16c>
    1572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1578:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    157b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
    157e:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
    1581:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1588:	00 
    1589:	89 44 24 04          	mov    %eax,0x4(%esp)
    158d:	89 34 24             	mov    %esi,(%esp)
    1590:	e8 5d fd ff ff       	call   12f2 <write>
        while(*s != 0){
    1595:	0f b6 07             	movzbl (%edi),%eax
    1598:	84 c0                	test   %al,%al
    159a:	75 dc                	jne    1578 <printf+0x148>
      state = 0;
    159c:	31 ff                	xor    %edi,%edi
    159e:	e9 d8 fe ff ff       	jmp    147b <printf+0x4b>
    15a3:	90                   	nop
    15a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
    15a8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
    15ab:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    15ad:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    15b4:	00 
    15b5:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b9:	89 34 24             	mov    %esi,(%esp)
    15bc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
    15c0:	e8 2d fd ff ff       	call   12f2 <write>
    15c5:	e9 b1 fe ff ff       	jmp    147b <printf+0x4b>
    15ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    15d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    15d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
    15d8:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
    15db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15e2:	8b 10                	mov    (%eax),%edx
    15e4:	89 f0                	mov    %esi,%eax
    15e6:	e8 a5 fd ff ff       	call   1390 <printint>
        ap++;
    15eb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    15ef:	e9 87 fe ff ff       	jmp    147b <printf+0x4b>
        putc(fd, *ap);
    15f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
    15f7:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
    15f9:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    15fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1602:	00 
    1603:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
    1606:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    1609:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    160c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1610:	e8 dd fc ff ff       	call   12f2 <write>
        ap++;
    1615:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1619:	e9 5d fe ff ff       	jmp    147b <printf+0x4b>
    161e:	66 90                	xchg   %ax,%ax

00001620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1620:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1621:	a1 fc 1a 00 00       	mov    0x1afc,%eax
{
    1626:	89 e5                	mov    %esp,%ebp
    1628:	57                   	push   %edi
    1629:	56                   	push   %esi
    162a:	53                   	push   %ebx
    162b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    162e:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
    1630:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1633:	39 d0                	cmp    %edx,%eax
    1635:	72 11                	jb     1648 <free+0x28>
    1637:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1638:	39 c8                	cmp    %ecx,%eax
    163a:	72 04                	jb     1640 <free+0x20>
    163c:	39 ca                	cmp    %ecx,%edx
    163e:	72 10                	jb     1650 <free+0x30>
    1640:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1642:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1644:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1646:	73 f0                	jae    1638 <free+0x18>
    1648:	39 ca                	cmp    %ecx,%edx
    164a:	72 04                	jb     1650 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    164c:	39 c8                	cmp    %ecx,%eax
    164e:	72 f0                	jb     1640 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1650:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1653:	8d 3c f2             	lea    (%edx,%esi,8),%edi
    1656:	39 cf                	cmp    %ecx,%edi
    1658:	74 1e                	je     1678 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    165a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    165d:	8b 48 04             	mov    0x4(%eax),%ecx
    1660:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    1663:	39 f2                	cmp    %esi,%edx
    1665:	74 28                	je     168f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1667:	89 10                	mov    %edx,(%eax)
  freep = p;
    1669:	a3 fc 1a 00 00       	mov    %eax,0x1afc
}
    166e:	5b                   	pop    %ebx
    166f:	5e                   	pop    %esi
    1670:	5f                   	pop    %edi
    1671:	5d                   	pop    %ebp
    1672:	c3                   	ret    
    1673:	90                   	nop
    1674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1678:	03 71 04             	add    0x4(%ecx),%esi
    167b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    167e:	8b 08                	mov    (%eax),%ecx
    1680:	8b 09                	mov    (%ecx),%ecx
    1682:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1685:	8b 48 04             	mov    0x4(%eax),%ecx
    1688:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    168b:	39 f2                	cmp    %esi,%edx
    168d:	75 d8                	jne    1667 <free+0x47>
    p->s.size += bp->s.size;
    168f:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
    1692:	a3 fc 1a 00 00       	mov    %eax,0x1afc
    p->s.size += bp->s.size;
    1697:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    169a:	8b 53 f8             	mov    -0x8(%ebx),%edx
    169d:	89 10                	mov    %edx,(%eax)
}
    169f:	5b                   	pop    %ebx
    16a0:	5e                   	pop    %esi
    16a1:	5f                   	pop    %edi
    16a2:	5d                   	pop    %ebp
    16a3:	c3                   	ret    
    16a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    16aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000016b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    16b0:	55                   	push   %ebp
    16b1:	89 e5                	mov    %esp,%ebp
    16b3:	57                   	push   %edi
    16b4:	56                   	push   %esi
    16b5:	53                   	push   %ebx
    16b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    16bc:	8b 1d fc 1a 00 00    	mov    0x1afc,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16c2:	8d 48 07             	lea    0x7(%eax),%ecx
    16c5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
    16c8:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16ca:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
    16cd:	0f 84 9b 00 00 00    	je     176e <malloc+0xbe>
    16d3:	8b 13                	mov    (%ebx),%edx
    16d5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    16d8:	39 fe                	cmp    %edi,%esi
    16da:	76 64                	jbe    1740 <malloc+0x90>
    16dc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
    16e3:	bb 00 80 00 00       	mov    $0x8000,%ebx
    16e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    16eb:	eb 0e                	jmp    16fb <malloc+0x4b>
    16ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16f0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    16f2:	8b 78 04             	mov    0x4(%eax),%edi
    16f5:	39 fe                	cmp    %edi,%esi
    16f7:	76 4f                	jbe    1748 <malloc+0x98>
    16f9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    16fb:	3b 15 fc 1a 00 00    	cmp    0x1afc,%edx
    1701:	75 ed                	jne    16f0 <malloc+0x40>
  if(nu < 4096)
    1703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1706:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    170c:	bf 00 10 00 00       	mov    $0x1000,%edi
    1711:	0f 43 fe             	cmovae %esi,%edi
    1714:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
    1717:	89 04 24             	mov    %eax,(%esp)
    171a:	e8 3b fc ff ff       	call   135a <sbrk>
  if(p == (char*)-1)
    171f:	83 f8 ff             	cmp    $0xffffffff,%eax
    1722:	74 18                	je     173c <malloc+0x8c>
  hp->s.size = nu;
    1724:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    1727:	83 c0 08             	add    $0x8,%eax
    172a:	89 04 24             	mov    %eax,(%esp)
    172d:	e8 ee fe ff ff       	call   1620 <free>
  return freep;
    1732:	8b 15 fc 1a 00 00    	mov    0x1afc,%edx
      if((p = morecore(nunits)) == 0)
    1738:	85 d2                	test   %edx,%edx
    173a:	75 b4                	jne    16f0 <malloc+0x40>
        return 0;
    173c:	31 c0                	xor    %eax,%eax
    173e:	eb 20                	jmp    1760 <malloc+0xb0>
    if(p->s.size >= nunits){
    1740:	89 d0                	mov    %edx,%eax
    1742:	89 da                	mov    %ebx,%edx
    1744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1748:	39 fe                	cmp    %edi,%esi
    174a:	74 1c                	je     1768 <malloc+0xb8>
        p->s.size -= nunits;
    174c:	29 f7                	sub    %esi,%edi
    174e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
    1751:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
    1754:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    1757:	89 15 fc 1a 00 00    	mov    %edx,0x1afc
      return (void*)(p + 1);
    175d:	83 c0 08             	add    $0x8,%eax
  }
}
    1760:	83 c4 1c             	add    $0x1c,%esp
    1763:	5b                   	pop    %ebx
    1764:	5e                   	pop    %esi
    1765:	5f                   	pop    %edi
    1766:	5d                   	pop    %ebp
    1767:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1768:	8b 08                	mov    (%eax),%ecx
    176a:	89 0a                	mov    %ecx,(%edx)
    176c:	eb e9                	jmp    1757 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
    176e:	c7 05 fc 1a 00 00 00 	movl   $0x1b00,0x1afc
    1775:	1b 00 00 
    base.s.size = 0;
    1778:	ba 00 1b 00 00       	mov    $0x1b00,%edx
    base.s.ptr = freep = prevp = &base;
    177d:	c7 05 00 1b 00 00 00 	movl   $0x1b00,0x1b00
    1784:	1b 00 00 
    base.s.size = 0;
    1787:	c7 05 04 1b 00 00 00 	movl   $0x0,0x1b04
    178e:	00 00 00 
    1791:	e9 46 ff ff ff       	jmp    16dc <malloc+0x2c>
    1796:	66 90                	xchg   %ax,%ax
    1798:	66 90                	xchg   %ax,%ax
    179a:	66 90                	xchg   %ax,%ax
    179c:	66 90                	xchg   %ax,%ax
    179e:	66 90                	xchg   %ax,%ax

000017a0 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    17a0:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    17a1:	b9 01 00 00 00       	mov    $0x1,%ecx
    17a6:	89 e5                	mov    %esp,%ebp
    17a8:	8b 55 08             	mov    0x8(%ebp),%edx
    17ab:	90                   	nop
    17ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    17b0:	89 c8                	mov    %ecx,%eax
    17b2:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    17b5:	85 c0                	test   %eax,%eax
    17b7:	75 f7                	jne    17b0 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    17b9:	0f ae f0             	mfence 
}
    17bc:	5d                   	pop    %ebp
    17bd:	c3                   	ret    
    17be:	66 90                	xchg   %ax,%ax

000017c0 <urelease>:

void urelease (struct uspinlock *lk) {
    17c0:	55                   	push   %ebp
    17c1:	89 e5                	mov    %esp,%ebp
    17c3:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    17c6:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    17c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    17cf:	5d                   	pop    %ebp
    17d0:	c3                   	ret    
