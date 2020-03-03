.data
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
		add $t1, $t1, 1 #This increment make the pointer go beyond the last number by one bit [I restore this later]
		bnez $t0, convert_decimal_to_binary

		
	
	sub $t1, $t1, 1 #make the $t1 point to the last bit of the number in memory
	print_num_in_binary:
		lb $a0, ($t1)
		li $v0, 1	
		syscall
		sub $t1, $t1, 1
		sub $t2, $t2, 1
		bnez $t2, print_num_in_binary
	
	###########################################################
	
	
	
	######################################
	#convert from decimal to octal [completed]
	
	li $v0, 4
	la $a0, enter_num
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0 #store decimal number into $t0
	
	#store number 8 in a reg [Octal Base]
	li $a1, 8
	la $t1, octal_placeholder #make $t1 point to the place where I will store binary number in memory
	li $t2, 0 #initializing the counter to zero
	
	convert_decimal_to_octal:
		add $t2, $t2, 1 #counter to keep track how many zeros and ones are stored in memory [To print them later]
		div $t0, $a1
		mfhi $s0 #remainder
		mflo $t0 #quotient
		sb $s0, ($t1)
		add $t1, $t1, 1 #This increment make the pointer go beyond the last number by one bit [I restore this later]
		bnez $t0, convert_decimal_to_octal

		
	
	sub $t1, $t1, 1 #make the $t1 point to the last bit of the number in memory
	print_num_in_octal:
		lb $a0, ($t1)
		li $v0, 1
		syscall
		sub $t1, $t1, 1
		sub $t2, $t2, 1
		bnez $t2, print_num_in_octal
	
	###########################################################
	
	
		
	######################################
	#convert from decimal to Hexa [completed]
	
	la $s1, letter_A
	la $s2, letter_B
	la $s3, letter_C
	la $s4, letter_D
	la $s5, letter_E
	la $s6, letter_F
	
	li $v0, 4
	la $a0, enter_num
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0 #store decimal number into $t0
	
	#store number 16 in a reg [Octal Base]
	li $a1, 16
	la $t1, octal_placeholder #make $t1 point to the place where I will store binary number in memory
	li $t2, 0 #initializing the counter to zero
	
	convert_decimal_to_hexa:
		add $t2, $t2, 1 #counter to keep track how many zeros and ones are stored in memory [To print them later]
		div $t0, $a1
		mfhi $s0 #remainder
		#[I should check here if the remainder is >= 10 then I should replace the number with letters]
		mflo $t0 #quotient	
		sb $s0, ($t1)
		add $t1, $t1, 1 #This increment make the pointer go beyond the last number by one bit [I restore this later]	
		bnez $t0, convert_decimal_to_hexa


	
	sub $t1, $t1, 1 #make the $t1 point to the last bit of the number in memory
	print_num_in_hexa:
		lb $a0, ($t1)
		beq $a0, 10, make_it_A
		beq $a0, 11, make_it_B
		beq $a0, 12, make_it_C
		beq $a0, 13, make_it_D
		beq $a0, 14, make_it_E
		beq $a0, 15, make_it_F
		li $v0, 1
		skip:
		syscall
		sub $t1, $t1, 1
		sub $t2, $t2, 1
		bnez $t2, print_num_in_hexa
	
	b exit
			
	make_it_A:
		lb $a0, ($s1)
		li $v0, 11
		b skip
	make_it_B:
		lb $a0, ($s2)
		li $v0, 11
		b skip
	make_it_C:
		lb $a0, ($s3)
		li $v0, 11
		b skip
	make_it_D:
		lb $a0, ($s4)
		li $v0, 11
		b skip
	make_it_E:
		lb $a0, ($s5)
		li $v0, 11
		b skip
	make_it_F:
		lb $a0, ($s6)
		li $v0, 11
		b skip	
	
	
	exit:
		li $v0, 10
		syscall
	###########################################################
