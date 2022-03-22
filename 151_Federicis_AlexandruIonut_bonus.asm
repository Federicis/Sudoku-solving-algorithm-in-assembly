.data
	nume: .asciz "input.txt"
	nume2: .asciz "output.txt"
	rt: .asciz "rt"
	wt: .asciz "wt"
	formatFscanf: .asciz "%d\n"
	formatFprintf: .asciz "%d "
	debugprintf: .asciz "%d\n"
	backslashn: .asciz "\n"	
	in: .space 1000
	out: .space 1000
	sol: .space 1000
	x: .space 10
	stack: .space 1000
	line: .space 10
	column: .space 10
.text
afisare:
	movl stack, %esp
	mov $1, %ecx
	movl $sol, %edi
et_forafisare:
	pushl %ecx
	pushl (%edi, %ecx, 4)
	pushl $formatFprintf
	pushl out
	call fprintf
	popl %ebx
	popl %ebx
	popl %ebx
	popl %ecx
	incl %ecx
	xorl %edx, %edx
	movl %ecx, %eax
	movl $9, %ebx
	div %ebx
	cmp $1, %edx
	jne et_cont1
	pushl %ecx
	pushl $backslashn
	pushl out
	call fprintf
	popl %ebx
	popl %ebx
	popl %ecx
et_cont1:
	cmp $81, %ecx
	jle et_forafisare
	pushl $0
	call fflush
	popl %ebx
	pushl out
	call fclose
	popl %ebx
	jmp et_exit

checkline:
	pushl %ebp
	movl %esp, %ebp
	movl $sol, %edi
	movl 8(%ebp), %eax
	decl %eax
	xorl %edx, %edx
	movl $9, %ebx
	div %ebx
	incl %eax
	movl %eax, line
	movl $1, %ecx
et_forline:
	movl line, %eax
	decl %eax
	xorl %edx, %edx
	movl $9, %ebx
	mul %ebx
	add %ecx, %eax
	movl 12(%ebp), %ebx
	cmp (%edi, %eax, 4), %ebx
	je et_checkret
	incl %ecx
	cmp $9, %ecx
	jle et_forline
	movl $1, %eax
	popl %ebp
	ret
et_checkret: 
	movl $0, %eax
	popl %ebp
	ret
	
checkcolumn:
	pushl %ebp
	movl %esp, %ebp
	movl $sol, %edi
	movl 8(%ebp), %eax
	xorl %edx, %edx
	movl $9, %ebx
	div %ebx
	cmp $0, %edx
	jne et_continuecolumn
	movl $9, %edx
et_continuecolumn:
	movl %edx, column
	movl $1, %ecx
et_forcolumn:
	movl %ecx, %eax
	decl %eax
	xorl %edx, %edx
	movl $9, %ebx
	mul %ebx
	add column, %eax
	movl 12(%ebp), %ebx
	cmp (%edi, %eax, 4), %ebx
	je et_checkretcolumn
	incl %ecx
	cmp $9, %ecx
	jle et_forcolumn
	movl $1, %eax
	popl %ebp
	ret
et_checkretcolumn:
	movl $0, %eax
	popl %ebp
	ret

checkbox:
	pushl %ebp
	movl %esp, %ebp
	movl $sol, %edi
	movl 8(%ebp), %eax
	decl %eax
	xorl %edx, %edx
	movl $9, %ebx
	div %ebx
	xorl %edx, %edx
	movl $3, %ebx
	div %ebx
	incl %eax
	movl %eax, line
	movl 8(%ebp), %eax
	xorl %edx, %edx
	movl $9, %ebx
	div %ebx
	cmp $0, %edx
	jne et_continuebox
	movl $9, %edx
et_continuebox:
	decl %edx
	movl %edx, %eax
	xorl %edx, %edx
	movl $3, %ebx
	div %ebx
	incl %eax
	movl %eax, column
	//ecx = i
	//eax = j
	movl $1, %ecx
et_fori:
	movl $1, %eax
et_forj:
	//!
		pushl %eax 
		movl line, %eax
		decl %eax
		xorl %edx, %edx
		movl $3, %ebx
		mul %ebx
		add %ecx, %eax
		decl %eax
		xorl %edx, %edx
		movl $9, %ebx
		mul %ebx
	//!
		pushl %ecx
		movl %eax, %ecx
		movl column, %eax
		decl %eax
		xorl %edx, %edx
		movl $3, %ebx
		mul %ebx
		add %eax, %ecx
		movl %ecx, %ebx
		popl %ecx
		popl %eax
		add %eax, %ebx
		movl 12(%ebp), %edx
		cmp (%edi, %ebx, 4), %edx
		je et_retbox
		incl %eax
		cmp $3, %eax
		jle et_forj
		incl %ecx
		cmp $3, %ecx
		jle et_fori
		movl $1, %eax
		popl %ebp
		ret
et_retbox:
	movl $0, %eax
	popl %ebp
	ret
		
		
	
bkt:
	pushl %ebp
	movl %esp, %ebp
	movl 8(%ebp), %eax
	cmp $81, %eax
	jg et_afisare
	movl $sol, %edi
	movl (%edi, %eax, 4), %ebx
	cmp $0, %ebx
	je et_continue
	incl %eax
	pushl %eax
	call bkt
	popl %eax
	decl %eax
	jmp et_return
	// ecx = i
et_continue:
	movl $1, %ecx
et_forbkt:
	pushl %ecx
	pushl 8(%ebp)
	call checkline
	popl %ebx
	popl %ecx
	cmp $1, %eax
	jne et_backtoforbkt
	pushl %ecx
	pushl 8(%ebp)
	call checkcolumn
	popl %ebx
	popl %ecx
	cmp $1, %eax
	jne et_backtoforbkt
	pushl %ecx
	pushl 8(%ebp)
	call checkbox
	popl %ebx
	popl %ecx
	cmp $1, %eax
	jne et_backtoforbkt
	movl $sol, %edi
	movl 8(%ebp), %eax
	movl %ecx, (%edi, %eax, 4)
/*
	pushl %ecx
	pushl %eax
	pushl (%edi, %eax, 4)
	pushl $debugprintf
	call printf
	popl %ecx
	popl %ecx
	popl %eax
	popl %ecx
*/
	pushl %ecx
	incl %eax
	pushl %eax
	call bkt
	popl %eax
	decl %eax
	popl %ecx
/*
	pushl %ecx
	pushl %eax
	pushl (%edi, %eax, 4)
	pushl $debugprintf
	call printf
	popl %ecx
	popl %ecx
	popl %eax
	popl %ecx
*/
	movl $0, %ebx
	movl %ebx, (%edi, %eax, 4)
et_backtoforbkt:
	incl %ecx
	cmp $9, %ecx
	jle et_forbkt
et_return:
	popl %ebp
	ret
et_afisare:
	call afisare
	
.global main

main: 
	movl %esp, stack
	push $rt
	push $nume
	call fopen	
	popl %ebx
	popl %ebx
	movl %eax, in
	mov $1, %ecx
	movl $sol, %edi
et_forcitire:
	pushl %ecx
	pushl $x
	pushl $formatFscanf
	pushl in
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx
	popl %ecx
	movl x, %eax
	movl %eax, (%edi, %ecx, 4)
	incl %ecx
	cmp $81, %ecx
	jle et_forcitire
	pushl in
	call fclose
	popl %ebx
/*debug
	movl $1, %ecx
et_for:
	pushl %ecx
	call checkcolumn
	popl %ecx
	incl %ecx
	cmp $81, %ecx
	jle et_for
	jmp et_exit
*/
	pushl $wt
	pushl $nume2
	call fopen
	popl %ebx
	popl %ebx	
	movl %eax, out
	pushl $1
	call bkt
	popl %ebx
	movl $1, %eax
	neg %eax
	pushl %eax
	pushl $formatFprintf
	pushl out
	call fprintf
	popl %ebx
	popl %ebx
	popl %ebx
	pushl $0
	call fflush
	popl %ebx
	pushl out
	call fclose
	popl %ebx
et_exit:
	mov $1, %eax
	xorl %ebx, %ebx
	int $0x80
	///Problema cu cnt maybe?? we shall see tomorrow
