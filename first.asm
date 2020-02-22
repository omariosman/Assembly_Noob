.data
	intro_msg: .asciiz "Enter number of elements: "
	ask_msg: .asciiz "Enter the elements: "
	max_msg: .asciiz "The maximum number: "

	.align 2
	array: .space 36
	

.text

	li $v0, 4 #cout msg Enter number of elements
	la $a0, intro_msg
	syscall
	
	li $v0, 5 #cin num of elements
	syscall
	add $t0, $v0, 0 #t0 is the loop counter
	add $t7, $t0, 0 #cpy counetr
	
	
	li $v0, 4 #cout msg Enter the elements
	la $a0, ask_msg
	syscall
	
	la $a1, array


	
	
	read_nums:
		li $v0, 5 #cin num
		syscall
		sw $v0, ($a1)
		sub $t0, $t0, 1 #decrement counter
		add $a1, $a1, 4
		bnez $t0, read_nums
		

	la $a1, array #a1 points to the beginning of the array
	
	
	add $t1, $a1, 0

		
	#calculate max
	max_calc:
		sle $t2, $t1, $a1 #if t1 < a1 
		beq $t2, 1, store_max
		sub $t7, $t7, 1 #decrement counter
		addi $a1, $a1, 4 #move pointer one element forward
		bnez $t7, max_calc 
		beqz $t7, print_max
	store_max:
		add $t1, $a1, 0 #t1 ontains bigger num
		add $a0, $t1, 0
		sub $t7, $t7, 1 #decrement counter
		addi $a1, $a1, 4 #move pointer one element forward
		bnez $t7, max_calc 
		
	print_max:
		li $v0, 4 #cout msg
		la $a0, max_msg
		syscall
		li $v0, 1 #cout num
		lw $a0, ($t1)
		syscall
		
	li $v0, 10
	syscall
		
		
