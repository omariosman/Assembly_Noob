.data
	input_msg: .asciiz "Enter a number: "
	odd_msg: .asciiz "The number is odd"
	even_msg: .asciiz "The number is even"
	new_line: .asciiz "\n"
	not_prime_num: .asciiz "This is not prime number"
	is_prime_num: .asciiz "This is a prime number"

.text
	#get the num and put it in $s0
	li $v0, 4
	la $a0, input_msg
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0 #I have the number entered in $s0 
	#ending 1st num

	andi $t0, $s0, 1 #will get the least significant bit of $s0 and put it in $t0.
	beq $t0, 1, odd	
	beqz $t0, even
	
	odd:
		li $v0, 4
		la $a0, odd_msg
		syscall
		li $v0, 4
		la $a0, new_line
		syscall
		b check_prime
		
	even:
		li $v0, 4
		la $a0, even_msg
		syscall
		li $v0, 4
		la $a0, new_line
		syscall
		b exit
		
	check_prime:
		move $s1, $s0
		sub $s1, $s1, 1
		sub_check_prime:
			div $s0, $s1
			mflo $v0 #quotient
			mfhi $v1 #Remainder
			bnez $v1, adjust_nums
			beq $v1, 0, not_prime
	adjust_nums:
		sub $s1, $s1, 1
		beq $s1, 1, affirm_prime
		b sub_check_prime
		
	not_prime:
		li $v0, 4
		la $a0, not_prime_num
		syscall
		b exit
		
	affirm_prime:
		li $v0, 4
		la $a0, is_prime_num	
		syscall
		b exit
		
	exit:
		li $v0, 10
		syscall #terminating the program
