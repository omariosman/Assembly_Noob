.data
	str: .space 32
	binary_placeholder: .space 32
	octal_placeholder: .space 32
	hexa_placeholder: .space 32
	letter_A: .ascii "A"
	letter_B: .ascii "B"
	letter_C: .ascii "C"
	letter_D: .ascii "D"
	letter_E: .ascii "E"
	letter_F: .ascii "F"
	enter_msg: .asciiz "Enter the number: "
	asking_msg: .asciiz "Convert to: "
	
	.align 2
.text

	li $v0, 8
	la $a0, str
	li $a1, 32
	syscall
	move $t0, $a0 #store str in $t


	 add $t0, $t0, 1
	 lb $t1, ($t0)
	 beq $t1, 98, convert_from_binary_to_decimal_universe #[98 = b]
	 beq $t1, 79, convert_from_octal_to_decimal_universe #[79 = O]
	 beq $t1, 88, convert_from_hexa_to_decimal_universe #88 = X[]
	 beq $t1, 48, convert_decimal_string_to_decimal_universe #[48 = 0]
	 beq $t1, 49, convert_decimal_string_to_decimal_universe
	 beq $t1, 50, convert_decimal_string_to_decimal_universe
	 beq $t1, 51, convert_decimal_string_to_decimal_universe
	 beq $t1, 52, convert_decimal_string_to_decimal_universe
	 beq $t1, 53, convert_decimal_string_to_decimal_universe
	 beq $t1, 54, convert_decimal_string_to_decimal_universe
	 beq $t1, 55, convert_decimal_string_to_decimal_universe
	 beq $t1, 56, convert_decimal_string_to_decimal_universe
	 beq $t1, 57, convert_decimal_string_to_decimal_universe
	 #I need to convert deciaml string to decimal number
	convert_decimal_string_to_decimal_universe:
	
	la $t0, str
	li $t3, 1 #counter to know the size of the str
	
	size_count_for_me:
		add $t0, $t0, 1
		lb $t1, ($t0)
		beq $t1, 10, finished_counting_for_me 
		add $t3, $t3, 1
		b size_count_for_me
		
	finished_counting_for_me:
		la $t0, str
		b adjust_pointer_for_me
	
	adjust_pointer_for_me:
		li $s2, 1
		add $t0, $t0, $t3
		sub $t0, $t0, 1 #I am at the end of the nunmber 
		b convert_decimal_to_ints
	
	digit_1_for_me:
		add $s3, $s3, $s2
	 	b continue_for_me
	digit_2_for_me:
		li $s4, 2
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue_for_me
	digit_3_for_me:
		li $s4, 3
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue_for_me
	digit_4_for_me:
		li $s4, 4
		mult $s2, $s4
		mflo $s5
		add $s3, $s5, $s3
	 	b continue_for_me
	digit_5_for_me:
		li $s4, 5
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_me
	digit_6_for_me:
		li $s4, 6
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_me
	digit_7_for_me:
		li $s4, 7
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_me
	digit_8_for_me:
		li $s4, 8
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_me
	digit_9_for_me:
		li $s4, 8
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue_for_me
	convert_decimal_to_ints:
		lb $t1, ($t0)
		beq $t1, 48, continue_for_me#0
		beq $t1, 49, digit_1_for_me #1
		beq $t1, 50, digit_2_for_me #2
		beq $t1, 51, digit_3_for_me #3
		beq $t1, 52, digit_4_for_me #4
		beq $t1, 53, digit_5_for_me #5
		beq $t1, 54, digit_6_for_me #6 
		beq $t1, 55, digit_7_for_me #7
		beq $t1, 56, digit_8_for_me #8
		beq $t1, 57, digit_9_for_me #9
		continue_for_me:
			sub $t0, $t0, 1 #devance the pointer to previous element
			sub $t3, $t3, 1
			li $s6, 10
			mult $s2, $s6  #shift sw to left as if multiply by 8
			mflo $s2
			bnez $t3, convert_decimal_to_ints
	
	
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ #	
	#ask msg which sys to go to?
	li $v0, 4
	la $a0, asking_msg
	syscall
	#read character [system to go to]
	li $v0, 8
	syscall
	move $t4, $a0
	lb $a2, ($t4)

	beq $a2, 98, final_decimal_to_binary #[98 = b]
	beq $a2, 79, final_decimal_to_octal #[79 = O]
	beq $a2, 104, final_decimal_to_hexa     #hexa [104 = h]
	
	b exit	  


	
####################################
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
		# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ #	
	#ask msg which sys to go to?
	li $v0, 4
	la $a0, asking_msg
	syscall
	#read character [system to go to]
	li $v0, 8
	syscall
	move $t4, $a0
	lb $a2, ($t4)
	beq $a2, 100, print_output # 100 =d] I knew that I want to go to decimal but now i want to know the system the user enetered
	beq $a2, 79, final_decimal_to_octal #[79 = O]
	beq $a2, 104, final_decimal_to_hexa     #hexa [104 = h]
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
		
	# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ #	
	#ask msg which sys to go to?
	li $v0, 4
	la $a0, asking_msg
	syscall
	#read character [system to go to]
	li $v0, 8
	syscall
	move $t4, $a0
	lb $a2, ($t4)
	beq $a2, 100, print_output # 100 =d] I knew that I want to go to decimal but now i want to know the system the user enetered
	beq $a2, 98, final_decimal_to_binary #[98 = b]
	beq $a2, 104, final_decimal_to_hexa     #hexa [104 = h]
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
	
			# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ #	
	#ask msg which sys to go to?
	li $v0, 4
	la $a0, asking_msg
	syscall
	#read character [system to go to]
	li $v0, 8
	syscall
	move $t4, $a0
	lb $a2, ($t4)
	beq $a2, 100, print_output # 100 =d] I knew that I want to go to decimal but now i want to know the system the user enetered
	beq $a2, 98, final_decimal_to_binary #[98 = b]
	beq $a2, 79, final_decimal_to_octal #[79 = O]
	b exit
	
	
	######################################
	#convert from decimal to octal [completed]
	
	final_decimal_to_octal:
	#store number 8 in a reg [Octal Base]
	li $a1, 8
	la $t1, octal_placeholder #make $t1 point to the place where I will store binary number in memory
	li $t2, 0 #initializing the counter to zero
	
	convert_decimal_to_octal:
		add $t2, $t2, 1 #counter to keep track how many zeros and ones are stored in memory [To print them later]
		div $s3, $a1
		mfhi $s0 #remainder
		mflo $s3 #quotient
		sb $s0, ($t1)
		add $t1, $t1, 1 #This increment make the pointer go beyond the last number by one bit [I restore this later]
		bnez $s3, convert_decimal_to_octal

		
	
	sub $t1, $t1, 1 #make the $t1 point to the last bit of the number in memory
	print_num_in_octal:
		lb $a0, ($t1)
		li $v0, 1
		syscall
		sub $t1, $t1, 1
		sub $t2, $t2, 1
		bnez $t2, print_num_in_octal
	
	b exit
	#######################################
	
	
#convert from decimal to Hexa [completed]
	final_decimal_to_hexa:
	la $s1, letter_A
	la $s2, letter_B
	la $s7, letter_C
	la $s4, letter_D
	la $s5, letter_E
	la $s6, letter_F
	

	
	#store number 16 in a reg [Octal Base]
	li $a1, 16
	la $t1, hexa_placeholder #make $t1 point to the place where I will store binary number in memory
	li $t2, 0 #initializing the counter to zero
	
	convert_decimal_to_hexa:
		add $t2, $t2, 1 #counter to keep track how many zeros and ones are stored in memory [To print them later]
		div $s3, $a1
		mfhi $s0 #remainder
		#[I should check here if the remainder is >= 10 then I should replace the number with letters]
		mflo $s3 #quotient	
		sb $s0, ($t1)
		add $t1, $t1, 1 #This increment make the pointer go beyond the last number by one bit [I restore this later]	
		bnez $s3, convert_decimal_to_hexa


	
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
		lb $a0, ($s7)
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
				
	b exit
	
	
#convert from decimal to binary [completed]
	
	final_decimal_to_binary:
	
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
		
	b exit
	###########################################################
	
	
	###########################################################
	print_output:
		li $v0, 1
		move $a0, $s3
		syscall
		b exit
	exit:
		#li $v0, 1
		#move $a0, $s3
		#syscall
		li $v0, 10
		syscall
		
