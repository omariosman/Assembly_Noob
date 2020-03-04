.data
	str: .space 32
	enter_num: .asciiz "Enter number in decimal: "
	binary_placeholder: .space 32
	octal_placeholder: .space 32
	hexa_placeholder: .space 32
	letter_A: .ascii "A"
	letter_B: .ascii "B"
	letter_C: .ascii "C"
	letter_D: .ascii "D"
	letter_E: .ascii "E"
	letter_F: .ascii "F"
	.align 2
.text
	
	la $s7, letter_B
	
	######################################
	#convert from decimal to binary [completed]
	
	li $v0, 4
	la $a0, enter_num
	syscall
	
	li $v0, 8
	la $a0, str
	li $a1, 32
	syscall
	move $t0, $a0 #store decimal number into $t0
	

	
	li $t3, 1 #counter to know the size of the str
	
	size_count:
		add $t0, $t0, 1
		lb $t1, ($t0)
		beq $t1, 10, finished_counting 
		add $t3, $t3, 1
		b size_count
		
	finished_counting:
		la $t0, str
		b adjust_pointer
	
	adjust_pointer:
		li $s2, 1
		add $t0, $t0, $t3
		sub $t0, $t0, 1 #I am at the end of the nunmber 
		b convert_decimal_to_ints
	
	digit_1:
		add $s3, $s3, $s2
	 	b continue
	digit_2:
		li $s4, 2
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue
	digit_3:
		li $s4, 3
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue
	digit_4:
		li $s4, 4
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue
	digit_5:
		li $s4, 5
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	digit_6:
		li $s4, 6
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	digit_7:
		li $s4, 7
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	digit_8:
		li $s4, 8
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	digit_9:
		li $s4, 8
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	convert_decimal_to_ints:
		lb $t1, ($t0)
		beq $t1, 48, continue#0
		beq $t1, 49, digit_1 #1
		beq $t1, 50, digit_2 #2
		beq $t1, 51, digit_3 #3
		beq $t1, 52, digit_4 #4
		beq $t1, 53, digit_5 #5
		beq $t1, 54, digit_6 #6 
		beq $t1, 55, digit_7 #7
		beq $t1, 56, digit_8 #8
		beq $t1, 57, digit_9 #9
		continue:
			sub $t0, $t0, 1 #devance the pointer to previous element
			sub $t3, $t3, 1
			li $s6, 10
			mult $s2, $s6  #shift sw to left as if multiply by 8
			mflo $s2
			bnez $t3, convert_decimal_to_ints
	
	
	#store number 2 in a reg
	li $a1, 2
	la $t1, binary_placeholder #make $t1 point to the place where I will store binary number in memory
	li $t2, 0 #initializing the counter to zero
	
	convert_decimal_to_binary:
		add $t2, $t2, 1 #counter to keep track how many zeros and ones are stored in memory [To print them later]
		div $s3, $a1
		mfhi $s0 #remainder
		mflo $s3 #quotient
		sb $s0, ($t1)
		add $t1, $t1, 1 #This increment make the pointer go beyond the last number by one bit [I restore this later]
		bnez $s3, convert_decimal_to_binary

		
	
	sub $t1, $t1, 1 #make the $t1 point to the last bit of the number in memory
	print_num_in_binary:
		lb $a0, ($t1)
		li $v0, 1	
		syscall
		sub $t1, $t1, 1
		sub $t2, $t2, 1
		bnez $t2, print_num_in_binary
	exit:
		li $v0, 10
		syscall
	###########################################################