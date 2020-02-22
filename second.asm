.data
	input_msg: .asciiz "Enter a number: "
	odd_msg: .asciiz "The number is odd"
	even_msg: .asciiz "The number is even"

.text
	#get the num and put it in $s0
	li $v0, 4
	la $a0, input_msg
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	#ending 1st num

	andi $t0, $s0, 1 #will get the least significant bit of $s0 and put it in $t0.
	beq $t0, 1, odd	
	beqz $t0, even
	
	odd:
		li $v0, 4
		la $a0, odd_msg
		syscall
		b check_prime
		
	even:
		li $v0, 4
		la $a0, even_msg
		syscall
		b exit
		
	check_prime:
		b exit
		
	exit:
		li $v0, 10
		syscall #terminating the program
