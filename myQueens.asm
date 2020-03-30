.data
	enter_n: .asciiz "Enter N: "
	ans: .asciiz "Answers: "

.text
	
	#cout enter N
	li $v0, 4
	la $a0, enter_n
	syscall
	#take n as input
	li $v0, 5
	syscall
	move $t0, $v0 #$t0 = n
	move $t1, $t0 #$t1 = n
	#calculate done which is 2^n - 1
	li $t2, 2
	li $t3, 1
	calculate_done:
		mult $t3, $t2
		mflo $t3
		sub $t1, $t1, 1
		bne $t1, 0, calculate_done
		
	#$t3 = done = 2^n - 1	
	sub $t3, $3, 1
	
	#Now Initilaize ld, rd, col = 0
	li $s0, 0 #$s0 = ld
	li $s1, 0 #s1 = col
	li $s2, 0 #s2 = rd

	innerRecurse:
				li $v0, 1
			move $a0, $s6
			syscall
		beq $s1, $t3, increment_counter #if col = done
		#poss = $s3
		or $s3, $s0, $s2 
		or $s3, $s3, $s1
		xor $s3, $s3, 1
		
		and $s4, $s3, $t3 #poss & done
		beq $s4, 1, while
		while:
			#bit = s6
			#-poss = s5
			sub $s5, $s3, $zero
			and $s6, $s3, $s5 #var bit = poss $ -poss  
			sub $s3, $s3, $s6 
			#ld | bit >> 21
			or $s0, $s0, $s6
			srl $s0, $s0, 1
			#col | bit
			or $s1, $s1, $s6
			#rd | bit << 1
			or $s2, $s2, $s6
			sll $s2, $s2, 1
			jal innerRecurse

			and $s4, $s3, $t3 #poss & done
			beq $s4, 1, while		







	increment_counter:
		add $t4, $t4, 1 #$t4 = ans
		li $v0, 4
		la $a0, ans
		syscall
		li $v0, 1
		move $a0, $t4
		syscall
		j allocate_queens
		
	allocate_queens:
		j exit
		
	exit:
		li $v0, 10
		syscall
		
