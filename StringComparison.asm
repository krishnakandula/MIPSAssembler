.data
		instruction: .asciiz "add "
		array: .asciiz "add ", "addi", "jr  ", "sltu", "sub ", "subu", "srl ", "sll ", "slt ", "nor "
		size: .word 10
		
		equalStr: .asciiz "\nStrings are equal"
		unequalStr: .asciiz "\nStrings aren't equal."
		notFoundStr: .asciiz "\nInstruction not found."
.text

main:		la $s0, instruction			#load word1 address
		lw $s1, size				#$s1 holds 10
		la $s2, array				#holds array address
		li $s6, 4
		li $s7, 0				#iterator, keeps track of where we are in array
		
loop:		la $s3, 0($s2)				#load word2 address in $s3
		li $t0, 0				#reset $t0 for element being compared to
		li $t1, 0				#reset $t1 for element being compared to
		li $t2, 0				#reset $t2 for element being compared to
		li $t3, 0				#reset $t3 for element being compared to

compare:	beq $t0, $s6, equalPrint		#once the counter has reached 4, test to see if $v0 is 0 (strings are equal)
		
		add $t1, $s0, $t0 			#put token (instruction) address into $t1, address($s0) + offset($t0)
		lb  $t2, 0($t1) 			#load letter/byte at address $t1
		add $t1, $s3, $t0 			#put array address into $t1
		lbu $t3, 0($t1)				#load first letter of array element
						
		bne $t2, $t3, notEqual			#...jump to notEqual if letters aren't equal, otherwise check next letter
		addi $t0, $t0, 1 			# i = i + 1, shift to next letter
		j compare 				# next iteration of loop
		
equalPrint:	la $a0, equalStr 			# printing that strings are equal
		li $v0, 4
		syscall
		j End
		
notEqual:	la $a0, unequalStr 			# printing that strings aren't equal
		li $v0, 4
		syscall
		
		beq $s7, $s1, notFound
		addi $s7, $s7, 1			#increment iterator
		addi $s2, $s2, 5			#incremement array address to access next element
		j loop
		
notFound:	la $a0, notFoundStr 			#printing that strings are equal
		li $v0, 4
		syscall	
			
End:		addi $v0, $0, 10 			#terminate the program
		syscall
