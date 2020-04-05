.data
Board : .space 256
enter_size_msg: .asciz "Enter Board Size: "
trees_number: .asciz "The number of trees: "
row_index: .asciz "Tree Row: "
col_index: .asciz "Tree Column: "
newline: .asciz "\n"
space: .asciz " "

.text
	#My Constants
	
	li s11, 0	
	#Saving one val in s1



	mul a6, t0, s4 

	li a7, 4 
	la a0, enter_size_msg
	ecall
	li s1, 1 
	#Saving two val in s1
	li s2, 2
	li a7,5 
	ecall
	add t0, a0, zero

	mul t4, t0, t0
	li a7, 4 
	la a0, trees_number
	ecall

	li a7,5 
	ecall
	add t3, a0, zero 

	li t1, 1
	la t2, Board   

	enter_numbers:
	li a7, 4 
	la a0, row_index
	ecall
	li a7,5 
	ecall
	add t5, a0, zero 
	li a7, 4
	la a0, col_index
	ecall
	li a7,5 
	ecall
	add a6, a0, zero

	#Convert 2D to 1D Array
	#Saving three val in s1
	li s3, 3
	#Saving four val in s1
	li s4, 4
	mul t5, t5, t0 
	
	add t5, t5, a6
	mul t5, t5, s4

	add t2, t2, t5


	sw s2, (t2)  	
	add t1,t1,s1
	la t2, Board

	ble t1, t3, enter_numbers  

	#Main Program

	mul a6, t0, s4 #a6 = n * 4
	#Loop throught the Board element by element coloumnly
	la t2, Board
	add t5, t2, zero
	add t1, t0, zero #t1 = size
	add s5, t0, zero
	catch_up:
		lw a7, (t5)

		#element = 0 [safe]
		beq a7, zero, zero_element
		beq a7, s2, two_element
		beq a7, s3, third_element
		zero_element:
			sw s1, (t5) #put lizard here
		
		handler:
			jal magic_calculator
			#We got back here with row = a1 and col = a2
			
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
			jal magic_calculator #This get ros in a1 and column in a2
			jal diagonal_up_right
			jal magic_calculator #Same idea
			jal diagonal_up_left
			jal magic_calculator #row = a1, col = a2
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
		add t5, t5, a6 #a6 = n * 4
		sub t1, t1, s1
		beq t1, zero, hopping
		b catch_up
	
	hopping:
		add t1, t0, zero #t1 = t0 = n
		add t2, t2, s4 
		add t5, t2, zero
		sub s5, s5, s1
		beqz s5, printing
		b catch_up

#calculate index
magic_calculator:
	add s8, t5, zero #address of unit
	li s9, 0x10010000
	sub a1, s8, s9
	div a1, a1, a6
	
	sub a3, s8, s9
	mul a2, a1, a6
	sub a2, a3, a2
	div a2, a2, s4
	jr ra
#We have index a1 = row a2 = col
up:
	#column constant and row decrease
	sub a1, a1, s1
	bge a1, zero, enter_borders_up
	b up_done
	enter_borders_up:
		sub s8, s8, a6    #go to upper element
		lw s6, (s8)
		beq s6, s2, up_done #check if it is tree or not
		beq s6, s1, up_done

		sw s3, (s8)
		b up
	up_done:
		jr ra
	
down:
	#column constant and row decrease
	add a1, a1, s1
	blt a1, t0, enter_borders_down
	b down_done
	enter_borders_down:
		add s8, s8, a6    #go to lower element
		lw s6, (s8)
		beq s6, s2, down_done #check if it is tree or not
		sw s3, (s8)
		b down
	down_done:
		jr ra
	
right:
	add a2, a2, s1
	blt a2, t0, enter_borders_right
	b right_done
	enter_borders_right:
		add s8, s8, s4
		lw s6, (s8)
		beq s6, s2, right_done
		sw s3, (s8)
		b right
	right_done:
		jr ra
left:
	sub a2, a2, s1
	bge a2, zero, enter_borders_left
	b left_done
	enter_borders_left:
		sub s8, s8, s4
		lw s6, (s8)
		beq s6, s2, left_done
		sw s3, (s8)
		b left
	left_done:
		jr ra

diagonal_up_right:
	sub a1, a1, s1
	add a2, a2, s1
	blt a1, zero, diagonal_up_right_done
	bge a2, t0, diagonal_up_right_done
	enter_borders_diagonal_up_right:
		sub s8, s8, a6
		add s8, s8, s4
		lw s6, (s8)
		beq s6, s2, diagonal_up_right_done
		sw s3, (s8)
		b diagonal_up_right
	diagonal_up_right_done:
		jr ra
diagonal_up_left:
	sub a1, a1, s1
	sub a2, a2, s1
	blt a1, zero, diagonal_up_left_done
	blt a2, zero, diagonal_up_left_done
	enter_borders_diagonal_up_left:
		sub s8, s8, a6
		sub s8, s8, s4
		lw s6, (s8)
		beq s6, s2, diagonal_up_left_done
		sw s3, (s8)
		b diagonal_up_left
	diagonal_up_left_done:
		jr ra

diagonal_down_right:
	add a1, a1, s1
	add a2, a2, s1
	bge a1, t0, diagonal_down_right_done
	bge a2, t0, diagonal_down_right_done
	enter_borders_diagonal_down_right:
		add s8, s8, a6
		add s8, s8, s4
		lw s6, (s8)
		beq s6, s2, diagonal_down_right_done
		sw s3, (s8)
		b diagonal_down_right
	diagonal_down_right_done:
		jr ra
	
diagonal_down_left:
	add a1, a1, s1
	sub a2, a2, s1
	bge a1, t0, diagonal_down_left_done
	blt a2, zero, diagonal_down_left_done
	enter_borders_diagonal_down_left:
		sub s8, s8, a6
		sub s8, s8, s4
		lw s6, (s8)
		beq s6, s2, diagonal_down_left_done
		sw s3, (s8)
		b diagonal_down_left
	diagonal_down_left_done:
		jr ra

printing:
li s8, 3
la t2, Board  
add t1,s1,zero
dump:
add a7, s1,zero
lw s6, (t2)
beq s6, s8, convert_to_zero
b skip
convert_to_zero:
	add s6, s11, zero
skip:
add a0, zero, s6 
ecall

li a7, 4 
la a0, space
ecall
add t2,t2, s4
rem a6, t1, t0 

bnez a6, continue
li a7, 4 
la a0, newline
ecall
continue:
add t1, t1, s1
ble t1, t4, dump
li a7, 10
ecall
exit:
	li a7, 10
	ecall
