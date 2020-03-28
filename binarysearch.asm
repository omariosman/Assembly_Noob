section .data
	array dq 5, 6, 7, 8, 9
	not_found_msg db "The number is not found", 0xa
	len_1 equ $ - not_found_msg
	found_msg db "The index: "
	found_len equ $ - found_msg
	no db 0x2d
	one db "1"
	newline dw 0xa
section .bss
	index resb 8


section .text
	global _start
_start:
	mov r8, array ;pointer to the beginning of the array
	mov r9, r8
	add r9, 32 ;pointer to the last element in the array
	
	mov r10, 2

	call binarySearch
	

	not_found:
		mov rax, 1
		mov rdi, 1
		mov rsi, no
		mov rdx, 1
		syscall
		mov rax, 1
		mov rdi, 1
		mov rsi, one
		mov rdx, 1
		syscall
		mov rax, 1
		mov rdi, 1
		mov rsi, newline
		mov rdx, 1
		syscall
		mov rax, 4
		mov rbx, 1
		mov rcx, not_found_msg
		mov rdx, len_1
		int 0x80
		jmp exit

	adjust_to_print:
		mov r12, array
		mov r8, 5
		mov r9, 0
		jmp find_index

	find_index:
		mov r13, [r12]
		;add r13, '0'
		cmp r10, r13
		je print_index
		inc r9
		add r12, 8
		sub r8, 1
		cmp r8, 0
		jnz find_index
	jmp exit
	print_index:
		mov rax, 1
		mov rdi, 1
		mov rsi, found_msg
		mov rdx, found_len
		syscall
		add r9, '0'
		mov [index], r9 ;r9 = counter
		mov rax, 1
		mov rdi, 1
		mov rsi, index
		mov rdx, 8
		syscall       
	        mov rax, 1
                mov rdi, 1
                mov rsi, newline
                mov rdx, 1
                syscall

	exit:
		mov rax, 1
		int 0x80

	binarySearch:
			 ;push ra
		push r8	 ;push left
		push r9	 ;push right
		push r10 ;push searchVal
		cmp r8, r9 ;if pointers cross over each other then num not fouund
		jg not_found
		
		;calculate the middle address

		mov r14, r8
		
		add r14, r9
		mov rax, r14
		mov rbx, 2
		div rbx ;rem = rdx
		mov r11, rax ;r11 = middle address
		mov rbx, 8
		div rbx		
		cmp rdx, 0 ;check if rem = 0
		jz skip
		jnz adjust_address
		adjust_address:
			sub r11, 4
		skip:
			;load the number of the middle and compare it to the searchVal
			mov r12, [r11]
			cmp r12, r10
			je return 
			jl go_right
			jg go_left
		go_right:
			mov r8, r11 ;make left pointer with the middle
			add r8, 8
			call binarySearch
		go_left:	
			mov r9, r11
			sub r9, 8
			call binarySearch
		return:
			jmp adjust_to_print









