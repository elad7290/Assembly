

.section	.rodata
int_format:	.string "%d"
string_format:	.string " %s"

.text
.globl run_main
.type run_main,@function
run_main:
	pushq	%r12			#allocate for opt
	pushq	%r13			#allocate for string one
	pushq	%r14			#allocate for string two
	pushq	%rbp
	movq	%rsp,%rbp		#init a new frame pointer
	
	#scan length
	sub	$4,%rsp
	movq	$int_format,%rdi
	leaq	(%rsp),%rsi
	xorq	%rax,%rax
	call	scanf
	movzbl	(%rsp),%r10d		#save the length in r10d
	sub	$2,%rsp			#allocate 2 byte for len and '\0'
	sub	%r10,%rsp		#allocate len byte to the sring
	movb	%r10b,(%rsp)		#save ln in memory
	movq    $string_format,%rdi
        leaq    1(%rsp),%rsi
        xorq    %rax,%rax
        call    scanf
	leaq	1(%rsp,%r10,1),%r10	#go to the end of the string plus 1
	movb 	$0,(%r10)		#add '\0' to the end of the string
	movq	%rsp,%r13		#now r13 pointer to pstring number one
	
	 #scan length
        sub     $4,%rsp
        movq    $int_format,%rdi
        leaq    (%rsp),%rsi
        xorq    %rax,%rax
        call    scanf
        movzbl  (%rsp),%r10d    	#save the length in r10d
        sub     $2,%rsp         	#allocate 2 byte for len and '\0'
        sub     %r10,%rsp       	#allocate len byte to the sring
        movb    %r10b,(%rsp)    	#save ln in memory
        movq    $string_format,%rdi
        leaq    1(%rsp),%rsi
        xorq    %rax,%rax
        call    scanf
        leaq    1(%rsp,%r10,1),%r10     #go to the end of the string plus 1
        movb    $0,(%r10)               #add '\0' to the end of the string
        movq    %rsp,%r14               #now r13 pointer to pstring number one

	#scan opt
        sub     $4,%rsp
        movq    $int_format,%rdi
        leaq    (%rsp),%rsi
        xorq    %rax,%rax
        call    scanf
	xorq	%r12,%r12
	movl	(%rsp),%r12d
	
	#call to run_func
	movq	%r12,%rdi
	movq	%r13,%rsi
	movq	%r14,%rdx
	xorq	%rax,%rax
	call	run_func
	

	#free all callee-saved
	movq	%rbp,%rsp
	popq	%rbp
	popq	%r14
	popq	%r13
	popq	%r12

	ret		#end of program
	
