.data
	input_string: .space 100
	new_string: .space 100
	input_string_msg: .asciiz "Enter the string: "
	enter_size_msg: .asciiz "Enter the string size: "
	fin: .asciiz "Finisehd"

.text

#macro inst for exit
.macro exit
	li $v0, 10
	syscall
.end_macro



	li $v0, 4
	la $a0, input_string_msg
	syscall
	
	#Enter the input_string
	li $v0, 8
	la $a0, input_string
	li $a1, 20
	move $t0 ,$a0 #moved the input_string into $t0
	syscall
	
	
	li $v0, 4
	la $a0, enter_size_msg
	syscall
	
	
	#Enter the size
	li $v0, 5
	syscall
	move $t1, $v0 #t1 = size of the input_string
	

	

	#Dictionary:
	#$t0 = string
	#t1 size
	#$s0 old string
	#s1 new string placeholder
	
	sub $t1, $t1, 1
	la $s0, input_string
	addu $s0, $s0, $t1 #make pointer to the last char in old string
	
	la $s1, new_string
	
	#reverse string function
	reverse_string:
		lb $t2, ($s0) #load last byte into $t2
		sb $t2, ($s1) #store last byte into new place in memory
		subu $s0, $s0, 1 #decrement counter of original string 
		addu $s1, $s1, 1 #increment counter of new string place 
		sub $t1, $t1, 1 #decrement size counter
		blt $t1,0, finished #it finished when $t1 less than 0
		bgt $t1,-1, reverse_string #go to loop again it $t1 > -1
		
	#print the new reversed string
	finished:
		li $v0, 4
		la $a0, new_string
		syscall
		
	#terminating the program by executing the macro exit		
	exit
	
	