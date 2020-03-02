.data
	enter_num: .asciiz "Enter number in decimal: "
	binary_placeholder: .space 64
.text
	
	li $v0, 4
	la $a0, enter_num
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0 #store decimal number into $t0
	
	#store number 2 in a reg
	li $a1, 2
	la $t1, binary_placeholder #make $t1 point to the place where I will store binary number in memory
	li $t2, 0 #initializing the counter to zero
	
	convert_decimal_to_binary:
		add $t2, $t2, 1 #counter to keep track how many zeros and ones are stored in memory [To print them later]
		div $t0, $a1
		mfhi $s0 #remainder
		mflo $t0 #quotient
		sb $s0, ($t1)
		add $t1, $t1, 1
		bnez $t0, convert_decimal_to_binary

		
	la $t1, binary_placeholder
	print_num_in_binary:
		lb $a0, ($t1)
		li $v0, 1
		syscall
		add $t1, $t1, 1
		sub $t2, $t2, 1
		bnez $t2, print_num_in_binary
	
	