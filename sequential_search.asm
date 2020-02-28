.data
	array: .word 10, 20, 30
	enter_num_msg: .asciiz "Enter the number to search for: "
	found_msg: .asciiz "The index of the number: "
	not_found_msg: .asciiz "The number is not found"
	new_line: .asciiz "\n"
.text
	li $v0, 4 #enter the number msg
	la $a0, enter_num_msg
	syscall
	
	li $v0, 5 #take the number itself
	syscall 
	move $s0, $v0 #the number now is saved in $a0
	
	li $a1, 3 #load the size of the array in $a1
	
	la $t0, array #make $t0 point to the first element
	lw $t7, ($t0) #take the value of the first element in $f0
	#call the search function

	#index of the number in $a2
	li $a2, 0
	
	sequential_search:
		beq $t7 $s0, found
		add $t0, $t0, 4
		add $a2, $a2, 1
		sub $a1, $a1, 1
		beqz $a1, not_found 
		lb $t7, ($t0)
		b sequential_search
		
		
	found:
		li $v0, 4
		la $a0, found_msg
		syscall
		li $v0, 1
		move $a0, $a2 
		syscall
		b exit
	not_found:
		li $v0, 4
		la $a0, not_found_msg
		syscall
		li $v0, 4
		la $a0, new_line
		syscall		
		li $v0, 1
		li $a0, -1
		syscall	
		b exit
	
	exit:
		li $v0, 10
		syscall
	
	
	#terminating the program
	li $v0, 10
	syscall	
	
	
	
	




#Algorithm
# 1- Make an array in the memory
# 2- Make a function that takes a number in $s0 to search for and the size of the array in $s1
# 3- The function counter should increase until it hits end
# 4- every step the function checks if the number in the array equals to the number in $s0
# 5- If the number equal equla , return the counter (index)
# 6- If the number not equal and the counter becomes zero then return -1