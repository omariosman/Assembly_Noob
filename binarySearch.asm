.data
	array: .space 1000
	enter_num_msg: .asciiz "Enter a number to search for: "
	not_found_msg: .asciiz "\nThe number is not found"
	enter_array_size: .asciiz "\nEnter the array size: "
	enter_nums: .asciiz "\nEnter the numbers of the array: "
	index_msg: .asciiz "\nThe index of the number: "
	.align 2
.text
		
	la $t0, array
	#cout enter array size
	li $v0, 4
	la $a0, enter_array_size
	syscall
	
	#cin size
	li $v0, 5
	syscall
	move $t3, $v0 #t3 contains size
	move $t6, $t3
	
	#cout enter array size
	li $v0, 4
	la $a0, enter_nums
	syscall
	
	enter_array:
		li $v0, 5
		syscall
		sw $v0, ($t0)
		add $t0, $t0, 4
		sub $t3, $t3, 1
		bnez $t3, enter_array
		

	la $t0, array #$t0 points to the beginning of the array
	li $t1, 0
	move $t1, $t0 #t1 points to the last element
	li $t4, 4
	mult $t6, $t4
	mflo $t5
	sub $t5, $t5, 4 
	add $t1, $t1, $t5
	#Ask the use to enter a number
	li $v0, 4
	la $a0, enter_num_msg
	syscall
	#cin
	li $v0, 5
	syscall
	move $t2, $v0 #contains the search Val




	jal binarySearch
	move $a0, $s2

	
	
#Get the index of the number after finding it
la $t0, array	
li $a2, 0
index_search:
		lb $t7, ($t0)
		beq $t7, $a0, get_out
		add $t0, $t0, 4
		add $a2, $a2, 1
		b index_search 
		
#Print th eindex of the number
get_out:
	li $v0, 4
	la $a0, index_msg
	syscall
	move $a0, $a2
	li $v0, 1
	syscall
	b exit

#print -1 if the number is not found in the array
	not_found:
		li $v0, 1
		li $a0, -1
		syscall
		li $v0, 4
		la $a0, not_found_msg
		syscall
#terminating the program	
exit:
	li $v0, 10
	syscall


#binary search function implementation recurseively
binarySearch:
	addiu $sp, $sp, -16 #reserve stack for 4 words
	sw $ra, 12($sp) #store ra on stack
	sw $t0, 8($sp) #left 
	sw $t1, 4($sp) #right
	sw $t2, 0($sp) #search Val
	
	bgt $t0, $t1, not_found #check if the pointers cross over then no. is not found
	
	#Calculate the middle address
	add $s0,$t0,$t1
	sra $s0, $s0, 1 #shift right = div by 2
	li $s3, 4
	div $s0, $s3
	mfhi $s1 #remainder	
	bnez $s1, adjust_address #-2 from the address to be at the beg of the word
	beqz $s1, skip 
	adjust_address:
		sub $s0, $s0, 2
	skip:	
	lw $s2, ($s0) #load middle element
	beq $s2, $t2, return #found element [base case]
	blt $s2, $t2, go_right #update left pointer to get the right part of the array
	bgt $s2, $t2, go_left #update right pointer to get the left part of the array
	
	
	go_right:
		move $t0, $s0 #make the left pointer with the middle
		add $t0, $t0, 4 #advance it by one word
		jal binarySearch #call itself again
		j return
	go_left:
		move $t1, $s0 #make the right pointer with the middle
		sub $t1, $t1, 4 #devance it by one word
		jal binarySearch #call itself again		
		j return
	return:
		lw $ra, 12($sp) #restore ra from stack
		addiu $sp ,$sp, 16 #restore all the reserved stack frame
		jr $ra #jump to return address
