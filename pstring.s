

.section .rodata
invalid_msg:	.string "invalid input!\n"


.text

# declaration of pstrlen
.globl pstrlen
.type pstrlen, @function
# pstrlen
pstrlen:
        xorq    %rax, %rax          		# rax = 0
        movb 	(%rdi), %al         		# in smallest byte of %rdi is the length
        ret

# declaration of replaceChar
.globl replaceChar
.type replaceChar, @function
# replaceChar
replaceChar:
	movq   %rdi, %r10                           # string -> r10
        # while loop
        .condition:
                   leaq    1(%r10), %r10            # r10 ++
       	           cmpb     $0, (%r10)              # compare *r10 & '\0'
                   je       .finish                 # if equals so we go to finish
        .while:
                    movb    (%r10), %r11b           # *r10 -> r11b
                    cmpb    %r11b, %sil             # compare r11b & old char
                    je      .true                   # if equals jump to true
                    jne     .condition              # if not equals continue
        .true:
                    movb    %dl, (%r10)             # replace char
                    jmp     .condition              # continue
        .finish:
		    movq    %rdi,%rax
               	    ret
#declaration of pstrijcpy
.globl pstrijcpy 
.type pstrijcpy, @function
pstrijcpy:
	#save the length of the strings in r10 
	movq	%rdi,%r10

	#check if j are not valid
	addq	$1,%rcx
	cmpb	%dl,%cl					#if(i>j)
	jb	.invalid_case
	cmpb	%cl,(%rdi)				#if(j>dst.len)
	jb	.invalid_case
	cmpb	%cl,(%rsi)				#if(j>src.len)
	jb	.invalid_case

	#this section is for valid input
	leaq	(%rdi,%rdx,1),%rdi			#rdi moved i steps
	leaq	(%rsi,%rdx,1),%rsi			#rsi moved i steps
	.while_loop:
		leaq	1(%rdi),%rdi
		leaq	1(%rsi),%rsi
		xorq	%rbx,%rbx
		movb	(%rsi),%bl			#copy one char to tmep string
		movb	%bl,(%rdi) 			#copy temp char into dest
		addq	$1,%rdx				#we add 1 to i
		cmpq	%rdx,%rcx			#check if i==j
		je	.done
		jmp	.while_loop
		
	#this section is when we finish copy all the chars to dest
	.done:
		xorq	%rax,%rax
		movq	%r10,%rax
		ret	

	#this section is for the case thet j is out of range
	.invalid_case:
		movq	$invalid_msg,%rdi
		xorq	%rax,%rax
		call	printf
		movq	%r10,%rax
		ret

#declaration of swapCase 
.globl swapCase
.type swapCase, @function
swapCase:
	.swap_while:
		movq	%rdi,%r10
		jmp	.next_char
		.check_char:				#let c be the char thet we check
			cmpb	$65,(%r10)		#if(c<65)
			jb	.next_char		#so continue to the next char
			cmpb	$91,(%r10)		#if(c<91)&&(c>=65)
			jb	.big_to_littel_case
			cmpb	$97,(%r10)		#if(c<97) and also not a big letter
			jb	.next_char
			cmpb	$123,(%r10)		#if(c>=97)&&(c<123)
			jb	.littel_to_big_case	#if true so we in littel to big case
			jmp	.next_char		#if not
		.big_to_littel_case:
			addb	$32,(%r10)
			jmp	.next_char
		.littel_to_big_case:
			subb	$32,(%r10)
			jmp	.next_char
		.next_char:
			leaq	1(%r10),%r10
			cmpb    $0, (%r10)              # compare *r10 & '\0'
                   	je      .doneSwap		#if we went through the whole string
			jmp	.check_char		#if not we go to check_char
		.doneSwap:
			xorq	%rax,%rax
			movq	%rdi,%rax
			ret

#declaration of pstrijcmp
.globl pstrijcmp
.type pstrijcmp, @function
pstrijcmp:        
        movq    %rdi,%r10
        #check if j are not valid
	addq	$1,%rcx
	cmpb	%dl,%cl					#if(i>j)
	jb	.invalid				
        cmpb    %cl,(%rdi)				#if(j>pstr1.len)
        jb      .invalid
        cmpb    %cl,(%rsi)   				#if(j>pstr2.len)
        jb      .invalid
	leaq    (%rdi,%rdx,1),%rdi      		#rdi moved i steps
        leaq    (%rsi,%rdx,1),%rsi      		#rsi moved i steps
	.loop:						#let c1 and c2 be the chars that we check
		leaq	1(%rdi),%rdi			#rdi move 1 step
		leaq	1(%rsi),%rsi			#rsi move 1 step
		movb	(%rdi),%r11b
		movb	(%rsi),%bl
		cmpb	%r11b,%bl			#if(c1>c2)
		jb	.s1_is_bigger
		ja	.s2_is_bigger
		addq	$1,%rdx				#add 1 to i
		cmpq	%rdx,%rcx			#compare beetwin i and j
                je	.equals				#i==j if we got to this point so the strings are equals
                jmp     .loop
		
		.equals:				#return 0
			xorq	%rax,%rax
			movq	$0,%rax
			ret

		.s1_is_bigger:				#return 1
			xorq	%rax,%rax
			movq	$1,%rax
			ret
		.s2_is_bigger:				#return -1
			xorq	%rax,%rax
			movq	$-1,%rax
			ret
		
		.invalid:				#invalid input
	 		movq    $invalid_msg,%rdi
                	xorq    %rax,%rax
                	call    printf
               		movq 	$-2,%rax
                	ret



		

