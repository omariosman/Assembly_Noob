.data
	array: .space 1000
	aspace: .asciiz " "
	enter_array_size: .asciiz "\nEnter the array size: "
	enter_nums: .asciiz "\nEnter the values of the array: "
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
	move $s0, $t3 #s0 contains the size of the array
	move $t5, $s0
	
	#cout enter array size
	li $v0, 4
	la $a0, enter_nums
	syscall
	
	#Loop to iterate and let the user enter the values of the array
	enter_array:
		li $v0, 5 
		syscall #cin num
		sw $v0, ($t0) #store in the memory
		add $t0, $t0, 4 #advance the pointer in the memory
		sub $t3, $t3, 1 #decrement counter
		bnez $t3, enter_array #check to see whether go again in loop or get out
	
	sub $s1, $s0, 1 #s1 the condition at which i will stop [s1 = n - 1]
	li $s2, -1 #s2 = i
	li $s3, 0 #s3 = j
	la $t0, array #make the pointer in the beg of the array
	
	jal bubbleSort #Call the bubbleSort function
	
	print_array: #Printing the sorted array after returning from the function
		lw $t1, ($t0)
		add $t0, $t0, 4
		move $a0, $t1
		li $v0, 1
		syscall
		li $v0, 4
		la $a0, aspace
		syscall
		sub $s5, $s5, 1
		bnez $s5, print_array

	#terminating the program
	exit:
		li $v0, 10
		syscall
		
		
bubbleSort:
	first_loop:
		la $t0, array
		li $s3, 0
		add $s2, $s2, 1
		blt $s2, $s1, second_loop #(if i < n - 1) 
		b adjust_to_print
		second_loop:
			sub $s4 ,$s0, $s2 #calculat condition value
			sub $s4, $s4, 1 #s4 = n - i - j
			lw $t1, ($t0) #load num val in a reg
			lw $t2, 4($t0) #load consecutive num val in a reg
			bgt $t1, $t2, swap #cmp two nums
			continue:
			add $s3, $s3, 1 #increment j
			add $t0, $t0, 4 #point to the next element
			blt $s3, $s4, second_loop #enter the second loop again
			b first_loop
	swap: #swap the two values in the memory
		sw $t1, 4($t0)
		sw $t2,  ($t0)
		b continue
	
	#make the pointer in the beg of array again to print it
	adjust_to_print:
		move $s5, $t5
		la $t0, array	
		jr $ra #return back to after jal
		

