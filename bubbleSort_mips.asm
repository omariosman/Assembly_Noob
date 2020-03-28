
.text
	la $t6, array
	
	li $v0, 4
	la $a0, s
	syscall
	
	
	li $v0, 5
	syscall
	move $t3, $v0 
	move $s0, $t3 
	move $t5, $s0
	

	li $v0, 4
	la $a0, enterthem
	syscall
	

	arrayNums:
		li $v0, 5 
		syscall 
		sw $v0, ($t6) 
		add $t6, $t6, 4 
		sub $t3, $t3, 1
		bnez $t3, arrayNums 
	
	sub $s2, $s0, 1 
	li $s7, 0
	sub $s7, $s7, 1 
	li $s3, 0 
	
	jal bubsort 
	
	li $v0, 4
	la $a0, msg_1
	syscall
	
	printing: 
		lw $t1, ($t6)
		add $t6, $t6, 4
		move $a0, $t1
		li $v0, 1
		syscall
		li $v0, 4
		la $a0, msafa
		syscall
		sub $s7, $s7, 1
		bnez $s7, printing


	exit:
		li $v0, 10
		syscall
		
		
bubsort:
	i_loop:
		la $t6, array
		li $s3, 0  
		add $s7, $s7, 1 
		blt $s7, $s2, j_loop 
		b edit 
		j_loop:
		sub $s4 ,$s0, $s7 
		sub $s4, $s4, 1
		lw $t1, ($t6)
		lw $t2, 4($t6) 
		bgt $t1, $t2, change_number 
		go_on:
		add $s3, $s3, 1 
		add $t6, $t6, 4 
		blt $s3, $s4, j_loop 
		b i_loop
	change_number: 
		sw $t1, 4($t6)
		sw $t2,  ($t6)
		b go_on
	

	edit:
		move $s7, $t5
		la $t6, array	
		jr $ra 
		
.data
	array: .space 1000
	msafa: .asciiz " "
	s: .asciiz "size:\n"
	enterthem: .asciiz "numbers:\n"
	msg_1: .asciiz "sorted array\n"
