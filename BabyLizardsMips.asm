.data
Board : .space 256
enter_size_msg: .asciiz "Enter Board Size: "
trees_number: .asciiz "The number of trees: "
row_index: .asciiz "Tree Row: "
col_index: .asciiz "Tree Column: "
newline: .asciiz "\n"
space: .asciiz " "

.text
	#My Constants
	li $t9, 0	
	
	mul $t6, $t0, $s4 

	li $v0, 4 
	la $a0, enter_size_msg
	syscall

	li $v0,5 
	syscall
	move $t0, $v0 

	mul $t4, $t0, $t0
	li $v0, 4 
	la $a0, trees_number
	syscall

	li $v0,5 
	syscall
	move $t3, $v0 
	
	li $s2, 2

	li $t1, 1
	la $t2, Board   

	enter_numbers:
	li $v0, 4 
	la $a0, row_index
	syscall
	li $v0,5 
	syscall
	move $t5, $v0 
	li $v0, 4
	la $a0, col_index
	syscall
	li $v0,5 
	syscall
	move $t6, $v0
	li $s1, 1 
	li $s3, 3
	
	#Convert 2D to 1D Array

	mult $t5, $t0 
	mflo $t5
	add $t5, $t5, $t6
	mulu $t5, $t5, 4

	add $t2, $t2, $t5


	sw $s2, ($t2)  	
	add $t1,$t1,1 	
	la $t2, Board

	ble $t1, $t3, enter_numbers  
	li $s4, 4
	#Main Program

	mul $t6, $t0, $s4 #$t6 = n * 4
	#Loop throught the Board element by element coloumnly
	la $t2, Board
	move $t5, $t2
	move $t1, $t0 #$t1 = size
	move $s5, $t0
	catch_up:
		lw $t7, ($t5)

		#element = 0 [safe]
		beq $t7, $zero, zero_element
		beq $t7, $s2, two_element
		beq $t7, $s3, third_element
		zero_element:
			sw $s1, ($t5) #put lizard here
		
		handler:
			jal magic_calculator
			#We got back here with row = $a1 and col = $a2
			
			#call up ,down, right, left, diagonal_up_left, diagonal_up_right, diagonal_down_left, diagonal_down_right
			jal up
			#return from up and go to down
			#b push_step
			
			#Call the magic calculator to calculate the row and column index again
			jal magic_calculator
			
			jal down
			#Note that the row and column index changed
			jal magic_calculator 
			jal right
			jal magic_calculator #I need to reset the row and index of current element
			
			
			jal left
			jal magic_calculator #This get ros in $a1 and column in $a2
			jal diagonal_up_right
			jal magic_calculator #Same idea
			jal diagonal_up_left
			jal magic_calculator #row = $a1, col = $a2
			jal diagonal_down_right 
			jal magic_calculator #I need to reset the row and index of current element
			jal diagonal_down_left
			
			
			b push_step #Getting next element
			
	#call the function that add unlimited threes	
	#element = 2
	two_element:
		b push_step
	# element = 3
	third_element:
		b push_step

	push_step:
		add $t5, $t5, $t6 #$t6 = n * 4
		sub $t1, $t1, 1
		beq $t1, 0, hopping
		b catch_up
	
	hopping:
		move $t1, $t0 #$t1 = $t0 = n
		add $t2, $t2, 4 
		move $t5, $t2
		sub $s5, $s5, 1
		beqz $s5, printing
		b catch_up

#calculate index
magic_calculator:
	move $t8, $t5 #address of unit

	sub $a1, $t8, 0x10010000
	div $a1, $a1, $t6
	
	sub $a3, $t8, 0x10010000
	mul $a2, $a1, $t6
	sub $a2, $a3, $a2
	div $a2, $a2, 4
	jr $ra
#We have index $a1 = row $a2 = col
up:
	#column constant and row decrease
	sub $a1, $a1, 1
	bge $a1, 0, enter_borders_up
	b up_done
	enter_borders_up:
		sub $t8, $t8, $t6    #go to upper element
		lw $s6, ($t8)
		beq $s6, $s2, up_done #check if it is tree or not
		beq $s6, $s1, up_done

		sw $s3, ($t8)
		b up
	up_done:
		jr $ra
	
down:
	#column constant and row decrease
	add $a1, $a1, 1
	blt $a1, $t0, enter_borders_down
	b down_done
	enter_borders_down:
		add $t8, $t8, $t6    #go to lower element
		lw $s6, ($t8)
		beq $s6, $s2, down_done #check if it is tree or not
		beq $s6, $s1, down_done
		sw $s3, ($t8)
		b down
	down_done:
		jr $ra
	
right:
	add $a2, $a2, 1
	blt $a2, $t0, enter_borders_right
	b right_done
	enter_borders_right:
		add $t8, $t8, 4
		lw $s6, ($t8)
		beq $s6, $s2, right_done
		beq $s6, $s1, right_done
		sw $s3, ($t8)
		b right
	right_done:
		jr $ra
left:
	sub $a2, $a2, 1
	bge $a2, 0, enter_borders_left
	b left_done
	enter_borders_left:
		sub $t8, $t8, 4
		lw $s6, ($t8)
		beq $s6, $s2, left_done
		beq $s6, $s1, left_done
		sw $s3, ($t8)
		b left
	left_done:
		jr $ra

diagonal_up_right:
	sub $a1, $a1, 1
	add $a2, $a2, 1
	blt $a1, 0, diagonal_up_right_done
	bge $a2, $t0, diagonal_up_right_done
	enter_borders_diagonal_up_right:
		sub $t8, $t8, $t6
		add $t8, $t8, 4
		lw $s6, ($t8)
		beq $s6, $s2, diagonal_up_right_done
		beq $s6, $s1, diagonal_up_right_done
		sw $s3, ($t8)
		b diagonal_up_right
	diagonal_up_right_done:
		jr $ra
diagonal_up_left:
	sub $a1, $a1, 1
	sub $a2, $a2, 1
	blt $a1, 0, diagonal_up_left_done
	blt $a2, 0, diagonal_up_left_done
	enter_borders_diagonal_up_left:
		sub $t8, $t8, $t6
		sub $t8, $t8, 4
		lw $s6, ($t8)
		beq $s6, $s2, diagonal_up_left_done
		beq $s6, $s1, diagonal_up_left_done
		sw $s3, ($t8)
		b diagonal_up_left
	diagonal_up_left_done:
		jr $ra

diagonal_down_right:
	add $a1, $a1, 1
	add $a2, $a2, 1
	bge $a1, $t0, diagonal_down_right_done
	bge $a2, $t0, diagonal_down_right_done
	enter_borders_diagonal_down_right:
		add $t8, $t8, $t6
		add $t8, $t8, 4
		lw $s6, ($t8)
		beq $s6, $s2, diagonal_down_right_done
		beq $s6, $s1, diagonal_down_right_done
		sw $s3, ($t8)
		b diagonal_down_right
	diagonal_down_right_done:
		jr $ra
	
diagonal_down_left:
	add $a1, $a1, 1
	sub $a2, $a2, 1
	bge $a1, $t0, diagonal_down_left_done
	blt $a2, 0, diagonal_down_left_done
	enter_borders_diagonal_down_left:
		sub $t8, $t8, $t6
		sub $t8, $t8, 4
		lw $s6, ($t8)
		beq $s6, $s2, diagonal_down_left_done
		beq $s6, $s1, diagonal_down_right_done
		sw $s3, ($t8)
		b diagonal_down_left
	diagonal_down_left_done:
		jr $ra

printing:
li $t8, 3
la $t2, Board  
li $t1,1
dump:
li $v0, 1 
lw $s6, ($t2)
beq $s6, $t8, convert_to_zero
b skip
convert_to_zero:
	move $s6, $t9
skip:
add $a0, $zero, $s6 
syscall

li $v0, 4 
la $a0, space
syscall
add $t2,$t2, 4
div $t1, $t0 
mfhi $t6
bnez $t6, continue
li $v0, 4 
la $a0, newline
syscall
continue:
add $t1, $t1, 1
ble $t1, $t4, dump
li $v0, 10
syscall
exit:
	li $v0, 10
	syscall
