.data
	board: .space 100
	col: .space 100
	d1: .space 100 #right diagonal
	d2: .space 100 #left diagonal
	enter_n: .asciiz "Enter N: "
	first_row_msg: .asciiz "First Row: "
	new_row_msg: .asciiz "New Row: "
	newline: .asciiz "\n"
	space: .asciiz " "
	board_msg: .asciiz "Board:\n"
	go: .asciiz "Go"


.text
	
	#cout enter N
	li $v0, 4
	la $a0, enter_n
	syscall
	
	#cin N
	li $v0, 5
	syscall
	move $t0, $v0 #$t0 = N
	#move $t3, $t0 #$t3 copy from N
	sub $s0, $t0, 1 #$s0 = n - 1
	
	
	li $t1, 0 #$t1 = ans
	li $t2, 0 #$t2 = row
	jal fill_board
	
	fill_board:
		
		beq $t2, $t0, adjust_solve # if (r == N) go to solve
		beqz $t2, cout_first_row
		j cout_new_row
		cout_first_row:
			li $v0, 4
			la $a0, first_row_msg
			syscall	
			j enter_before_k	
		cout_new_row:
			li $v0, 4
			la $a0, new_row_msg
			syscall			
			#f loop 
			enter_before_k:
				li $s1, 0 #$s1 = f
				li $t5, 4
			enter_k: 
				#add $s1, $s1, 1 #$s1 = f
				li $v0, 5
				syscall #cin num
				move $t7, $v0 #$t7 = num
				
				#col[r] = d1[r-f+n-1] = d2[r+f] = k;
				#col[r] = k
				mult $s1, $t5 # $s2 = f * 4
				mflo $s2
				sw $t7, col($s2)
				
				#d1[r-f+n-1]
				li $t4, 0
				sub $t4, $t2, $s1 #$t4 = r - f
				add $t4, $t4, $s0 #$t4 = r - f + n - 1  
				mult $t4, $t5
				mflo $t4
				sw  $t7, d1($t4)
				
				#d2[r+f]
				li $t6, 0
				add $t6, $t2, $s1  #$t5 = r + f
				mult $t6, $t5
				mflo $t6
				sw $t7, d2($t6)
				
				#f = f + 1
				add $s1, $s1, 1
				blt $s1, $t0, enter_k #if (f < n)
				
				 
			
		#call the function again (recursion)
		add $t2, $t2, 1
		jal fill_board
		
			
		
	adjust_solve:
		li $t2, 0 #$t2 = r = 0
		j solve
	

	solve:
		beq $t2, $t0, inc_ans_then_print #if (r == n) go to print
		j solve_before_loop
		inc_ans_then_print:
			add $t1, $t1, 1
			j print_board_adjust
		solve_before_loop:
			li $s1, 0 #$s1 = c
			li $t5, 4
		solve_loop:
			#if condition
			
				#col [c]
				mult $s1, $t5 # $s2 = c * 4
				mflo $s2

				
				#d1[r-f+n-1]
				li $t4, 0
				sub $t4, $t2, $s1 #$t4 = r - f
				add $t4, $t4, $s0 #$t4 = r - f + n - 1  
				mult $t4, $t5
				mflo $t4

				
				#d2[r+f]
				li $t6, 0
				add $t6, $t2, $s1  #$t5 = r + f
				mult $t6, $t5
				mflo $t6

			
				#check the condition
				#load the elements from the index
				#load col[c]
				
				lw $s3, col($s2)

	
				lw $s4, d1($t4)
				
				lw $s5, d2($t6)
			
				xor $s3, $s3, 1
	
				xor $s4, $s4, 1

				xor $s5, $s5, 1

				and $s6, $s3, $s4

				and $s7, $s6, $s5
					li $v0, 4
					la $a0, go
					syscall
					li $v0, 1
					move $a0, $s7
					syscall
					#test by printing GO

				beq $s7, 1, go_ahead
				j loop_again
				go_ahead:
					li $v0, 4
					la $a0, go
					syscall
					li $t3, 1
					sw $t3, col($s2)
					sw $t3, d1($t4)
					sw $t3, d2($t6)
					#j + (i * cols) #2D Array using 1D Array
					mult $t2, $t0 #i * cols
					mflo $t4
					add $t4, $t4, $s1 #$t4 = (i*cols) + j
					mult $t4, $t5
					mflo $t4
					sw $t3, board($t4)
					#call solve recursively 
					#increment r then call solve
					add $t2, $t2, 1
					jal solve
				loop_again:
					add $s1, $s1, 1
					blt $s1, $t0, solve_loop
					
				  
		
	
	print_board_adjust:
		li $v0, 4
		la $a0, board_msg
		syscall
		mult $t0, $t0
		mflo $t3 #$t4 = n * n (counter)
		la $t5, board
		li $t4, 0
		move $t6, $t0
		j print_board
	print_board:
		li $v0, 1
		lw $a0, ($t5)
		syscall
		li $v0, 4
		la $a0, space
		syscall		
		add $t4, $t4, 1
		beq $t4, $t6, new_line
		j continue
		new_line:
			li $v0, 4
			la $a0, newline
			syscall
			li $t4, 0
		continue:
		add $t5, $t5, 4
		sub $t3, $t3, 1 
		bnez $t3, print_board
	
	exit:
		li $v0, 10
		syscall