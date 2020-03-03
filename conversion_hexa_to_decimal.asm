.data
	str: .space 32
	enter_msg: .asciiz "Enter the number: "
	let_X: .ascii "X"
	.align 2
.text
	la $s0, let_X
	lb $s1, ($s0) #$s1 contains the letter O
	
	li $v0, 8
	la $a0, str
	li $a1, 32
	syscall
	move $t0, $a0 #store str in $t0

	li $t3, 1 #counter to know the size of the str
	
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
	beq $t1, $s1, adjust_pointer #check the second byte [0X]
	b exit
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
		li $s4, 9
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	digit_10:
		li $s4, 10
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	digit_11:
		li $s4, 11
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	digit_12:
		li $s4, 12
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	digit_13:
		li $s4, 13
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	digit_14:
		li $s4, 14
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	digit_15:
		li $s4, 15
		mult $s2, $s4
		mflo $s5
		add $s3, $s3, $s5
	 	b continue
	adjust_pointer:
		li $s2, 1
		add $t0, $t0, $t3
		add $t0, $t0, 1 #I am at the end of the nunmber 
		b convert_hexa_to_decimal
	convert_hexa_to_decimal:
		lb $t1, ($t0)
		beq $t1, 48, continue
		beq $t1, 49, digit_1
		beq $t1, 50, digit_2
		beq $t1, 51, digit_3
		beq $t1, 52, digit_4
		beq $t1, 53, digit_5
		beq $t1, 54, digit_6
		beq $t1, 55, digit_7
		beq $t1, 56, digit_8
		beq $t1, 57, digit_9
		beq $t1, 65, digit_10
		beq $t1, 66, digit_11
		beq $t1, 67, digit_12
		beq $t1, 68, digit_13
		beq $t1, 69, digit_14
		beq $t1, 70, digit_15
		continue:
			sub $t0, $t0, 1 #devance the pointer to previous element
			sub $t3, $t3, 1
			sll $s2, $s2, 4 #shift sw to left as if multiply by 8
			bnez $t3, convert_hexa_to_decimal
	
		
	exit:
		li $v0, 1
		move $a0, $s3
		syscall
		li $v0, 10
		syscall
		
