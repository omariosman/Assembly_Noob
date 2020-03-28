section .data
	array dq 2,3,1
	after_sorting_msg db "The sorted array: "
	len_1 equ $ - after_sorting_msg
	before_sorting_msg db "The original array: "
	len_2 equ $ - before_sorting_msg
	aspace db " "
	new_line dw 0xa
section .bss
	num resb 8

section .text

	global _start

_start:

	mov r8, 3 ;n
	mov r15, r8 ; n temp
	mov r9, 2 ; n - 1
	mov r10, -1 ;i
	mov r11, 0 ;j
	
	mov r12, array
	





       
        mov rax, 1
        mov rdi, 1
        mov rsi, before_sorting_msg
        mov rdx, len_2
        syscall
        mov r12, array
        mov r8, 3
        jmp first_print_num
	
	first_print_num:
                mov r13, [r12]
                add r13, '0'
                mov [r12], r13
                mov rax, 1
                mov rdi, 1
                mov rsi, r12
                mov rdx, 8
                syscall
                mov rax, 1
                mov rdi, 1
                mov rsi, aspace
                mov rdx, 1
                syscall
                add r12, 8
                sub r8, 1
                cmp r8, 0
                jnz first_print_num

	mov rax, 1
	mov rdi, 1
	mov rsi, new_line	
	mov rdx, 1
	syscall

	mov r12, array
	


	
	call bubbleSort

	adjust:
		mov rax, 1
		mov rdi, 1
		mov rsi, after_sorting_msg
		mov rdx, len_1
		syscall
		mov r12, array
		mov r8, 3
		jmp print_num
        
	print_num:
		;mov r13, [r12]
		;add r13, '0'
		;mov [r12], r13
                mov rax, 1
                mov rdi, 1
                mov rsi, r12
                mov rdx, 8
                syscall
		mov rax, 1
		mov rdi, 1
		mov rsi, aspace
		mov rdx, 1
		syscall
		add r12, 8
                sub r8, 1
		cmp r8, 0
        	jnz print_num
	

	exit:
		mov rax, 1
		int 0x80


	bubbleSort:
		first_loop:
			mov r12, array
			mov r11, 0 ;j
			inc r10 ;i
			cmp r10, r9
			jl second_loop
			jmp adjust
		second_loop:
			sub r15, r10 ;n - i
			sub r15, 1   ;n - i - 1
			mov r13, [r12]
			add r12, 8
			mov r14, [r12]
			sub r12, 8
			cmp r13, r14
			jg swap
			continue:
			inc r11 ;j
			add r12, 8
			cmp r11, r15 ;if (j < (n - i - 1)) 
			jl second_loop		
			jmp first_loop
		swap:
			mov [r12], r14
			add r12, 8
			mov [r12], r13
			sub r12, 8
			jmp continue
			









