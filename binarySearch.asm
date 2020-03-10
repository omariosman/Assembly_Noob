.data
	array: .word 10, 20, 30, 40, 50
	enter_num_msg: .asciiz "Enter a number to search for: "
	not_found_msg: .asciiz "\nThe number is not found"
	.align 2
.text

la $t0, array #$t0 points to the beginning of the array
li $t1, 0
add $t1, $t1, $t0 #t1 points to the last element
add $t1, $t1, 16
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
li $v0, 1
syscall

not_found:
	li $v0, 1
	li $a0, -1
	syscall
	li $v0, 4
	la $a0, not_found_msg
	syscall	

li $v0, 10
syscall



binarySearch:
	addiu $sp, $sp, -16
	sw $ra, 12($sp)
	sw $t0, 8($sp) #left
	sw $t1, 4($sp) #right
	sw $t2, 0($sp) #search Val
	
	bgt $t0, $t1, not_found
	
	#Calculate the middle address
	add $s0,$t0,$t1
	sra $s0, $s0, 1 #shift right = div by 2
	li $s3, 4
	div $s0, $s3
	mfhi $s1 #remainder	
	bnez $s1, adjust_address
	beqz $s1, skip
	adjust_address:
		sub $s0, $s0, 2
	skip:	
	lw $s2, ($s0)
	beq $s2, $t2, return
	blt $s2, $t2, go_right
	bgt $s2, $t2, go_left
	
	go_right:
		move $t0, $s0
		add $t0, $t0, 4
		jal binarySearch
		j return
	go_left:
		move $t1, $s0
		sub $t1, $t1, 4
		jal binarySearch		
		j return
	return:
		lw $ra, 12($sp)
		addiu $sp ,$sp, 16
		jr $ra