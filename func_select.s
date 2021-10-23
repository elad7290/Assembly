

           .section .rodata

# formats
int_format:		.string "%d"
chr_format:		.string " %c"
str_format:		.string " %s"

invalid_msg: 	.string "invalid option!\n"
length_msg:	.string "first pstring length: %d, second pstring length: %d\n"
newchar_msg: 	.string "old char: %c, new char: %c, first string: %s, second string: %s\n"
newstring_msg:	.string "length: %d, string: %s\n"
compare_msg:  	.string "compare result: %d\n"

# jump table
.align  8
.jump_table:
    .quad   .case5060
    .quad   .default
    .quad   .case52
    .quad   .case53
    .quad   .case54
    .quad   .case55
    .quad   .default
    .quad   .default
    .quad   .default
    .quad   .default
    .quad   .case5060

                .text

# declaration of run_func
.globl run_func
.type run_func, @function
# run_func
run_func:


    # push all callee saved
    pushq   %r12
    pushq   %r13
    pushq   %r14
    pushq   %rbp                        		# save old rbp
    movq    %rsp, %rbp                  		# rbp <- rsp

    # save arguments
    movq    %rdi, %r12                  		# first argument in r12
    movq    %rsi, %r13                  		# second argument in r13
    movq    %rdx, %r14                  		# third argument in r14

    leaq    -50(%rdi), %rsi
    cmpq    $10, %rsi
    ja      .default
    jmp     *.jump_table(,%rsi,8)
    # case input is 50 or 60
    .case5060:

		# first string length
		movq   	%r13, %rdi                    	# send first string
		call   	pstrlen
            	movq   	%rax, %r10                    	# save return value in r10
            	# second string length
            	movq    %r14, %rdi                  	# send second string
            	call   	pstrlen
            	movq   	%rax, %r11                    	# save return value in r11
            	# print
            	movq 	$length_msg, %rdi         	# rdi = "first pstring length: %d, second pstring length: %d\n"
            	movq    %r10, %rsi                	# n1 -> rsi
            	movq    %r11, %rdx                	# n2 -> rdx
            	xorq  	%rax, %rax
            	call	printf
            	# return
            	jmp     .return

    .case52:
		#first argument
		sub	$1,%rsp
		movq	$chr_format,%rdi
		leaq	(%rsp),%rsi
		xorq	%rax,%rax
		call 	scanf

		#second argument
		sub	$1,%rsp
		movq	$chr_format,%rdi
		leaq	(%rsp),%rsi
		xorq	%rax,%rax
		call	scanf

		#send first argument to function
		movq	%r13,%rdi
		movb	1(%rsp),%sil
		movb	(%rsp),%dl
		xorq	%rax,%rax
		call	replaceChar

                #send second argument to function
                movq    %r14,%rdi
                movb    1(%rsp),%sil
                movb    (%rsp),%dl
                xorq    %rax,%rax
                call    replaceChar

		#print the new string after change
		movq	$newchar_msg,%rdi
		movb	1(%rsp),%sil
		movb	(%rsp),%dl
		leaq	1(%r13),%rcx
		leaq	1(%r14),%r8
		xorq	%rax,%rax
		call 	printf 
            	jmp     .return

    .case53:
                #first argument   
                sub     $4,%rsp  
                movq    $int_format,%rdi
                leaq    (%rsp),%rsi
                xorq    %rax,%rax
                call    scanf

                #second argument  
                sub     $4,%rsp  
                movq    $int_format,%rdi
                leaq    (%rsp),%rsi
                xorq    %rax,%rax
                call    scanf

		#call function and send the arg
		movq	%r13,%rdi
		movq	%r14,%rsi
		movzbl	4(%rsp),%edx
		movzbl	(%rsp),%ecx
		xorq	%rax,%rax
		call	pstrijcpy

		#print dest string
		movq	$newstring_msg,%rdi
		xorq	%rsi,%rsi
		movb	(%r13),%sil
		leaq	1(%r13),%rdx
		xorq	%rax,%rax
		call 	printf
                #print src string

                movq    $newstring_msg,%rdi
                xorq    %rsi,%rsi
                movb    (%r14),%sil
                leaq    1(%r14),%rdx
                xorq    %rax,%rax  
                call 	printf
		jmp	.return
    .case54:
		#send the first string to swap case
		movq	%r13,%rdi
		xorq	%rax,%rax
		call	swapCase
		
		#print first string
                movq    $newstring_msg,%rdi
                xorq    %rsi,%rsi
                movb    (%r13),%sil
                leaq    1(%r13),%rdx
                xorq    %rax,%rax  
                call 	printf

		#send the second string to swap case
		movq	%r14,%rdi
		xorq	%rax,%rax
		call	swapCase

                #print src string
                movq    $newstring_msg,%rdi
                xorq    %rsi,%rsi
                movb    (%r14),%sil
                leaq    1(%r14),%rdx
                xorq    %rax,%rax  
                call 	printf
            	jmp     .return

    .case55:
		#first argument
                sub     $4,%rsp   
                movq    $int_format,%rdi
                leaq    (%rsp),%rsi
                xorq    %rax,%rax
                call    scanf

                #second argument
                sub     $4,%rsp   
                movq    $int_format,%rdi
                leaq    (%rsp),%rsi
                xorq    %rax,%rax 
                call    scanf

		#call function and send the arg
                movq    %r13,%rdi
                movq    %r14,%rsi
                movzbl  4(%rsp),%edx
                movzbl  (%rsp),%ecx
                xorq    %rax,%rax
                call    pstrijcmp
  
                #print string msg
                movq    $compare_msg,%rdi
		movq	%rax,%rsi
                xorq    %rax,%rax  
                call 	printf
            	jmp     .return

    .default:
		movq	$invalid_msg,%rdi
		xorq	%rax,%rax
		call	printf
		jmp	.return

    .return:
            	 # pop all callee saved
            	movq    %rbp, %rsp                  # rsp <- rbp
            	popq    %rbp
            	popq    %r14
            	popq    %r13
            	popq    %r12
            	# pop opposite of push

            	ret

