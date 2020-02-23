.data
	str: .space 100
	intro_msg: .asciiz "Enter the word: "
	word_count: .asciiz "The word characters count: "
	size_msg: .asciiz "Enter the size of the string: "
	make_it_palindrome: .asciiz "We wil make it palindrome"
	is_palindrome: .asciiz "This word is Plaindrome"
	equal: .asciiz "We are equal"
	not_equal: .asciiz "We are not equal"
	new_line: .asciiz "\n"
	num: .space 4

.text

	li $v0, 4 #cout msg
	la $a0, intro_msg
	syscall
	
	li $v0, 8 #cin word
	la $a0, str
	li $a1, 20
	move $t0, $a0 #Now I have string in $t0 
	syscall
	
	#cin size
	li $v0, 4
	la $a0, size_msg
	syscall
	li $v0, 5
	syscall
	move $t1, $v0 #size in $t1
	
	#First Counter: s1
	#Second Counter: s2 
	
	li $s1, 0 #Set First Counter
	sub $t1, $t1, 1
	move $s2, $t1 #Set Second Counter
	
	la $a1,str
	la $a2,str

	addu $a1,$a1,$s1   # $a1 = &str[x].  assumes x is in $s0
	addu $a2,$a2,$s2   # $a1 = &str[x].  assumes x is in $s0
	
	#lb $t6, ($a1)
	#lb $t7, ($a2) 
	#beq $t6, $t7, we_are_equal
	#bne $a1, $a2, we_are_not_equal
			
	#we_are_not_equal:
	#	li $v0, 4
	#	la $a0, not_equal
	#	syscall
	#we_are_equal:
	#	li $v0, 4
	#	la $a0, equal
	#	syscall

	
	
	loop_count:	
		sle $t3, $a2, $a1 #Check if the first pointer skipped the last one then the word must be palindrome
		beq $t3, 1, palindrome
		lb $t6, ($a1) #load the bytes that are referred to by $a1 and $a2 and compare them
		lb $t7, ($a2)
		bne $t6, $t7, make_palindrome #if the two bytes are different then this word is not palindrome
		beq $t6, $t7, loop_count_cont #if the two bytes are equal then we should check the following letters
	
	loop_count_cont:
		addu $a1, $a1, 1
		subu $a2, $a2, 1
		b loop_count		 
		
	palindrome:
		li $v0, 4
		la $a0, is_palindrome
		syscall	
		b exit
		
		
	make_palindrome:
		li $v0, 4
		la $a0, make_it_palindrome
		syscall
		li $v0, 4
		la $a0, new_line
		syscall
		
		la $a1, str
		la $a2, str
		addu $a1, $a1, $s1
		addu $a2, $a2, $s2
		
		making_palindrome_loop:
		sle $t3, $a2, $a1 #Check if the first pointer skipped the last one then the word must be palindrome
		beq $t3, 1, new_word
		lb $t6, ($a1)
		lb $t7, ($a2)
		beq $t6, $t7, making_palindrome_loop_cont 
		bne $t6, $t7, checking_chars
		
		making_palindrome_loop_cont:
			addu $a1, $a1, 1
			subu $a2, $a2, 1
			b making_palindrome_loop
		
	checking_chars:
		sle $t5, $t6, $t7 #if $t6 < $t7 then set $t5 = 1
		beq $t5, 1, replacing_chars 
		beq $t5, 0, replacing_chars_too
		replacing_chars:
			move $t4, $t6
			move $t7, $t4
			sb $t7, ($a2)
			b making_palindrome_loop
		replacing_chars_too:
			move $t4, $t7
			move $t6, $t4
			sb $t6, ($a1)
			b making_palindrome_loop	
		
	new_word:
		li $v0, 4
		la $a0, str
		syscall
		b exit
		
	#make #s1 points to the first char in the str
	#la $s1, str
	#li $s2, 0 #$s2 is the counter
	
	#char_counter:
		#beq $s1, $zero, finished_counter 
	#	add $s1, $s1, 1 #move pointer to the next char
	#	add $s2, $s2, 1 #increment counter
	#	beq $s1, 0, finished_counter
	#	bnez $s1, char_counter
		
		
	#finished_counter:
	#	li $v0, 4
	#	la $a0, word_count
	#	syscall
	#	li $v0, 1
	#	lw $a0, ($s2)
	#	syscall
	
	
	

	
	#How to Read String
	#la $a1,str
	#addu $a1,$a1,1   # $a1 = &str[x].  assumes x is in $s0
	#lbu $a0,($a1)      # read the character
	#move $t2, $a0
	
	#How to fetch string
	#la $a1,str
	#addu $a1,$a1,0   # $a1 = &str[x].  assumes x is in $s0
	#lbu $a0,($a1)      # read the character
	#move $t3, $a0
	exit:
		li $v0, 10
		syscall
	
	

	
