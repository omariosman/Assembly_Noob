section .data
	array dq 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 2, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 2 ,0,0,0,0,0,0,0,0,0,0,0,0, 2, 0, 2, 0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2
	length equ $ - array
	testing db "test",0xa
	len equ $ - testing
	zeco dq 0
	one dq 1
	two dq 2
	three dq 3
	four dq 4
	eight dq 8
	sixty_four dq 64

section .bss
	buffer resb 8
	row resb 8
	col resb 8
section .text


global _start

_start:
	mov r12, [eight] ;r12 = $t1
	mov r13, [eight]  ;r13 = $s5 to terminate infinite loop
	mov r8, array ;r8 = $t2
	mov r9, r8 ;r9 = $t5
	catch_up:
		mov r10, [r9]
		;Compre the element to see whether it is 0, 2, 3
		cmp r10, [zeco]
		je zero_element
		cmp r10, [two]
		je two_element
		cmp r10, [three]
		je three_element

		zero_element:
	                           mov rax, 1
                                mov rdi,1
                                mov rsi, testing
mov rdx, 4
                                syscall

			mov r11, [one]
			mov [r9], r11 ;sw 1, ($t5)
		handler:
			call magic_calculator
			call up
			;return from up and go to down

			;Call the magic calculator to calculate the row and column index again
			call magic_calculator
			
			call down
			;Note that the row and column index changed
			call magic_calculator 
			call right
			call magic_calculator ;I need to reset the row and index of current element
			
			
			call left
			call magic_calculator ;This get ros in $a1 and column in $a2
			call diagonal_up_right
			call magic_calculator 
			call diagonal_up_left
			call magic_calculator 
			call diagonal_down_right 
			call magic_calculator
			call diagonal_down_left
			
			jmp push_step

			
			two_element:
				jmp push_step
			three_element:
				jmp push_step
	
			push_step:
                           mov rax, 1
                                mov rdi,1
                                mov rsi, testing
				mov rdx, 4
                                syscall

				mov r11, [sixty_four]
				add r9, r11
				dec r12
				cmp r12, [zeco]
				je hopping
				jmp catch_up
			hopping:
				mov r12, [eight]		
				add r8, 8
				mov r9, r8
				dec r13
				cmp r13, [zeco]
				je printing
				jmp catch_up

magic_calculator:
	mov r14, array ;magic number in r14
	mov r15, r9 ;move $t8, $t5
	sub r15, r14 ;r15 = $a1
	mov rax, r15
	mov rbx, [sixty_four]
	div rbx
	mov [row], rax
	
	mov r15, r9
	sub r15, r14
	
	mov rax, [row]
	mov rbx, [sixty_four]
	mul rbx
	mov [col], rax
	sub r15, [col]
	mov rax, r15
	mov rbx, [eight]
	div rbx
	ret
	
	
up:
	mov r15, r9 ;r15 = $t8
	mov r14, [row] ;a1 = r14
	dec r14 ;sub a1, a1, 1
	cmp r14, 0
	jge enter_borders_up
	jmp up_done
	enter_borders_up:
		sub r15, [sixty_four] ;sub $t8, $t6
		mov r11, [r15]
		cmp r11, [two]
		je up_done
		cmp r11, qword[one]
		je up_done
		mov r11, [three]
		mov [r15], r11
		jmp up
	up_done:
		ret


down:
        mov r15, r9 ;r15 = $t8
        mov r14, [row] ;a1 = r14
        inc r14 ;sub a1, a1, 1
        cmp r14, [eight]
        jl enter_borders_down
        jmp down_done
        enter_borders_down:
                add r15, [sixty_four] ;sub $t8, $t6
                mov r11, [r15]
                cmp r11, [two]
                je down_done
                cmp r11, [one]
                je down_done
                mov r11, [three]
                mov [r15], r11
                jmp down
        down_done:
                ret

right:
	mov r15, r9
	mov r14, [col]
	inc r14
	cmp r14, [eight]
	jl enter_borders_right
	jmp right_done
	enter_borders_right:
		add r15, 8
		mov r11, [r15]
		cmp r11, [two]
		je right_done
		cmp r11, [one]
		je right_done
		mov r11, [three]
		mov [r15], r11
		jmp right
	right_done:
		ret

left:
        mov r15, r9
        mov r14, [col]
        dec r14
        cmp r14, 0
        jge enter_borders_left
        jmp left_done
        enter_borders_left:
                sub r15, 8
                mov r11, [r15]
                cmp r11, [two]
                je left_done
                cmp r11, [one]
                je left_done
                mov r11, [three]
                mov [r15], r11
                jmp left
        left_done:
                ret


diagonal_up_right:
	mov r15, r9
	mov rax, [row]
	mov rbx, [col]
	dec rax
	inc rbx
	cmp rax, 0
	jl diagonal_up_right_done
	cmp rbx, [eight]
	jge diagonal_up_right_done
	enter_borders_diagonal_up_right:
		sub r15, [sixty_four]
		add r15, 8
		mov r11, [r15]
		cmp r11, [two]
                je diagonal_up_right_done
                cmp r11, [one]
                je diagonal_up_right_done
                mov r11, [three]
                mov [r15], r11
                jmp diagonal_up_right
        diagonal_up_right_done:
                ret



diagonal_up_left:
        mov r15, r9
        mov rax, [row]
        mov rbx, [col]
        dec rax
        dec rbx
        cmp rax, 0
        jl diagonal_up_left_done
        cmp rbx, 0
        jl diagonal_up_left_done
        enter_borders_diagonal_up_left:
                sub r15, [sixty_four]
                sub r15, 8
                mov r11, [r15]
                cmp r11, [two]
                je diagonal_up_left_done
                cmp r11, [one]
                je diagonal_up_left_done
                mov r11, [three]
                mov [r15], r11
                jmp diagonal_up_left
        diagonal_up_left_done:
                ret



diagonal_down_right:
        mov r15, r9
        mov rax, [row]
        mov rbx, [col]
        inc rax
        inc rbx
        cmp rax, [eight]
        jge diagonal_down_right_done
        cmp rbx, [eight]
        jge diagonal_down_right_done
        enter_borders_diagonal_down_right:
                add r15, [sixty_four]
                add r15, 8
                mov r11, [r15]
                cmp r11, [two]
                je diagonal_down_right_done
                cmp r11, [one]
                je diagonal_down_right_done
                mov r11, [three]
                mov [r15], r11
                jmp diagonal_down_right
        diagonal_down_right_done:
                ret









diagonal_down_left:
        mov r15, r9
        mov rax, [row]
        mov rbx, [col]
        inc rax
        dec rbx
        cmp rax, [eight]
        jge diagonal_down_left_done
        cmp rbx, 0
        jl diagonal_down_left_done
        enter_borders_diagonal_down_left:
                sub r15, [sixty_four]
                sub r15, 8
                mov r11, [r15]
                cmp r11, [two]
                je diagonal_down_left_done
                cmp r11, [one]
                je diagonal_down_left_done
                mov r11, [three]
                mov [r15], r11
                jmp diagonal_down_left
        diagonal_down_left_done:
                ret








printing:
	exit:
	mov rax, 1
	int 0x80

