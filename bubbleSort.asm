.data
	array: .word 3,2,1
	#new_array: .space 32
	.align 2
.text
	la $t0, array
	#la $t4, new_array
	li $s0 ,3 #s0 contains the size of the array
	sub $s1, $s0, 1 #s1 the condition at which i will stop [s1 = n - 1]
	li $s2, -1 #s2 = i
	li $s3, 0 #s3 = j
	
	
	first_loop:
		la $t0, array
		li $s3, 0
		add $s2, $s2, 1
		blt $s2, $s1, second_loop #(if i < n - 1) 
		b adjust_to_print
		second_loop:
			sub $s4 ,$s0, $s2
			sub $s4, $s4, 1 #s4 = n - i - j
			lw $t1, ($t0)
			lw $t2, 4($t0)
			bgt $t1, $t2, swap
			continue:
			add $s3, $s3, 1 #increment j
			add $t0, $t0, 4 #point to the next element
			blt $s3, $s4, second_loop #enter the second loop again
			b first_loop
	swap:
		sw $t1, 4($t0)
		sw $t2,  ($t0)
		b continue
	
	adjust_to_print:
		li $s5, 3
		la $t0, array	
		b print_array
		
	print_array:
		lw $t1, ($t0)
		add $t0, $t0, 4
		move $a0, $t1
		li $v0, 1
		syscall
		sub $s5, $s5, 1
		bnez $s5, print_array

	exit:
		li $v0, 10
		syscall
