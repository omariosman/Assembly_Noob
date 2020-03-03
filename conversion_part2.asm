.data
	str: .space 32
	enter_msg: .asciiz "Enter the number: "
	let_b: .ascii "b"
	fin: .asciiz "Finsinedh Coutning"
	
	.align 2
.text
	la $s0, let_b
	lb $s1, ($s0) #$s1 contains the letter b
	
	li $v0, 8
	la $a0, str
	li $a1, 32
	syscall
	move $t0, $a0 #store str in $t

	li $t3, 1 #countre to know the size of the str
	
	size_count:
		add $t0, $t0, 1
		lb $t1, ($t0)
		beq $t1, 10, finished_counting 
		add $t3, $t3, 1
		b size_count
		
	finished_counting:
		sub $t3, $t3, 2 #t3 contains the size of the integers entered
		
	la $t0, str
	add $t0, $t0, 1
	lb $t1, ($t0)
	la $t0, str #$t0 at the beginning of the string
	beq $t1, $s1, adjust_pointer #check the second byte [0b]
	b exit
	stop_then_continue:
		add $s3, $s3, $s2
	 	b continue
	adjust_pointer:
		li $s2, 1
		add $t0, $t0, $t3
		add $t0, $t0, 1 #I am at the end of the nunmber 
		b convert_binary_to_decimal
	convert_binary_to_decimal:
		lb $t1, ($t0)
		beq $t1, 48, continue
		beq $t1, 49, stop_then_continue
		continue:
			sub $t0, $t0, 1 #devance the pointer to previous element
			sub $t3, $t3, 1
			sll $s2, $s2, 1 #shift sw to left as if multiply by two
			bnez $t3, convert_binary_to_decimal
	
		
	exit:
		li $v0, 1
		move $a0, $s3
		syscall
		li $v0, 10
		syscall
		
