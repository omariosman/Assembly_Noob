.data
	str: .space 32
	enter_msg: .asciiz "Enter the number: "
	let_b: .ascii "b"
	let_O: .ascii "O"
	asking_msg: .asciiz "Which system do you want to convert to? "
	
	.align 2
.text
	la $s0, let_b
	lb $s1, ($s0) #$s1 contains the letter b
	
	
	la $s7, let_O
	lb $s6, ($s7) #$s1 contains the letter O
	
	li $v0, 8
	la $a0, str
	li $a1, 32
	syscall
	move $t0, $a0 #store str in $t

	#ask msg which sys to go to?
	li $v0, 4
	la $a0, asking_msg
	syscall
	#read character [system to go to]
	li $v0, 8
	syscall
	move $t4, $a0
	lb $a2, ($t4)
	beq $a2, 100, dispatcher #I knew that I want to go to decimal but now i want to know the system the user enetered
	
	 dispatcher: 
	 	add $t0, $t0, 1
	 	lb $t1, ($t0)
	 	beq $t1, 98, convert_from_binary_to_decimal_universe
	 	beq $t1, 79, convert_from_octal_to_decimal_universe
	 	beq $t1, 88, convert_from_hexa_to_decimal_universe
	 	 

	b exit
	
	
	convert_from_binary_to_decimal_universe:
	la $t0, str
	li $t3, 1 #countre to know the size of the str
	
	size_count:
		add $t0, $t0, 1
		lb $t1, ($t0)
		beq $t1, 10, finished_counting 
		add $t3, $t3, 1
		b size_count
		
	finished_counting:
		sub $t3, $t3, 2 #t3 contains the size of the integers entered
		

	la $t0, str #$t0 at the beginning of the string
	b adjust_pointer #check the second byte [0b]
	
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
	b exit	
	####################
	convert_from_octal_to_decimal_universe:
	la $t0, str
	li $t3, 1 #counter to know the size of the str
	
	size_count_for_octal:
		add $t0, $t0, 1
		lb $t1, ($t0)
		beq $t1, 10, finished_counting_for_octal
		add $t3, $t3, 1
		b size_count_for_octal
		
	finished_counting_for_octal:
		sub $t3, $t3, 2 #t3 contains the size of the integers entered
		
	la $t0, str
	b adjust_pointer_for_octal
	
	digit_1:
		add $s3, $s3, $s2
	 	b continue_for_octal
	digit_2:
		li $s4, 2
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue_for_octal
	digit_3:
		li $s4, 3
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue_for_octal
	digit_4:
		li $s4, 4
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue_for_octal
	digit_5:
		li $s4, 5
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_octal
	digit_6:
		li $s4, 6
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_octal
	digit_7:
		li $s4, 7
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_octal
	digit_8:
		li $s4, 8
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_octal
	adjust_pointer_for_octal:
		li $s2, 1
		add $t0, $t0, $t3
		add $t0, $t0, 1 #I am at the end of the nunmber 
		b convert_octal_to_decimal
	convert_octal_to_decimal:
		lb $t1, ($t0)
		beq $t1, 48, continue_for_octal
		beq $t1, 49, digit_1
		beq $t1, 50, digit_2
		beq $t1, 51, digit_3
		beq $t1, 52, digit_4
		beq $t1, 53, digit_5
		beq $t1, 54, digit_6
		beq $t1, 55, digit_7
		beq $t1, 56, digit_8
		continue_for_octal:
			sub $t0, $t0, 1 #devance the pointer to previous element
			sub $t3, $t3, 1
			sll $s2, $s2, 3 #shift sw to left as if multiply by 8
			bnez $t3, convert_octal_to_decimal
		
	b exit
	
	
	####################
	convert_from_hexa_to_decimal_universe:
	la $t0, str

	li $t3, 1 #counter to know the size of the str
	
	size_count_for_hexa:
		add $t0, $t0, 1
		lb $t1, ($t0)
		beq $t1, 10, finished_counting_for_hexa
		add $t3, $t3, 1
		b size_count_for_hexa
		
	finished_counting_for_hexa:
		sub $t3, $t3, 2 #t3 contains the size of the integers entered
		

	la $t0, str #$t0 at the beginning of the string
	b adjust_pointer_for_hexa #check the second byte [0X]

	digit_1_for_hexa:
		add $s3, $s3, $s2
	 	b continue_for_hexa
	digit_2_for_hexa:
		li $s4, 2
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue_for_hexa
	digit_3_for_hexa:
		li $s4, 3
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue_for_hexa
	digit_4_for_hexa:
		li $s4, 4
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue_for_hexa
	digit_5_for_hexa:
		li $s4, 5
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	digit_6_for_hexa:
		li $s4, 6
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	digit_7_for_hexa:
		li $s4, 7
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	digit_8_for_hexa:
		li $s4, 8
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	digit_9_for_hexa:
		li $s4, 9
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	digit_10_for_hexa:
		li $s4, 10
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	digit_11_for_hexa:
		li $s4, 11
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	digit_12_for_hexa:
		li $s4, 12
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	digit_13_for_hexa:
		li $s4, 13
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	digit_14_for_hexa:
		li $s4, 14
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	digit_15_for_hexa:
		li $s4, 15
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_hexa
	adjust_pointer_for_hexa:
		li $s2, 1
		add $t0, $t0, $t3
		add $t0, $t0, 1 #I am at the end of the nunmber 
		b convert_hexa_to_decimal
	convert_hexa_to_decimal:
		lb $t1, ($t0)
		beq $t1, 48, continue_for_hexa
		beq $t1, 49, digit_1_for_hexa
		beq $t1, 50, digit_2_for_hexa
		beq $t1, 51, digit_3_for_hexa
		beq $t1, 52, digit_4_for_hexa
		beq $t1, 53, digit_5_for_hexa
		beq $t1, 54, digit_6_for_hexa
		beq $t1, 55, digit_7_for_hexa
		beq $t1, 56, digit_8_for_hexa
		beq $t1, 57, digit_9_for_hexa
		beq $t1, 65, digit_10_for_hexa
		beq $t1, 66, digit_11_for_hexa
		beq $t1, 67, digit_12_for_hexa
		beq $t1, 68, digit_13_for_hexa
		beq $t1, 69, digit_14_for_hexa
		beq $t1, 70, digit_15_for_hexa
		continue_for_hexa:
			sub $t0, $t0, 1 #devance the pointer to previous element
			sub $t3, $t3, 1
			sll $s2, $s2, 4 #shift sw to left as if multiply by 8
			bnez $t3, convert_hexa_to_decimal
	
	####################
	exit:
		li $v0, 1
		move $a0, $s3
		syscall
		li $v0, 10
		syscall
		
