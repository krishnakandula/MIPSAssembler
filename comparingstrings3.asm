.data
		instruction: .asciiz "nor "
		array: .asciiz "add ", "addi", "jr  ", "sltu", "sub ", "subu", "srl ", "sll '", "slt ", "nor "
		size: .word 10
		
		equalStr: .asciiz "\nStrings are equal"
		unequalStr: .asciiz "\nStrings aren't equal."
		notFoundStr: .asciiz "\nInstruction not found."
.text

main:		la $s0, instruction			#load word1 address
		lw $s1, size				#$s1 holds 10
		la $s2, array				#holds array address
		li $s7, 0				#iterator, keeps track of where we are in array
		
loop:		la $s3, 0($s2)				#load word2 address in $s3
		li $t1, 0				#first char of token, $s0
		li $t2, 0
		li $t3, 0
		li $t4, 0
		li $v0, 0				# if ==
			
		jal compare
		beq $v0, $0, equalPrint
		slt $t0, $v0, $0
		j notEqual

compare:	add $t1, $s0, $t0 	#put token (instruction) address into $t1
		lb  $t2, 0($t1) 	#load first letter on first run
		
		add $t1, $s3, $t0 	#put array address into $t1
		lbu $t3, 0($t1)		#load first letter of array
						
		slt $t4, $t2, $t3
		bne $t4, $0, unequalneg
		slt $t4, $t3,$t2
		bne $t4, $0, unequalpos
		beq $v0, $zero, equalStrings
		addi $t0, $t0, 1 	# i = i + 1, shift to next letter
		j compare 		# next iteration of loop
		
unequalpos:	addi $v0, $0, 1
		jr $ra
unequalneg:	addi $v0, $0, -1
		jr $ra
		
equalStrings:	addi $v0, $0, 0
		jr $ra
		
equalPrint:	la $a0, equalStr 		# printing that strings are equal
		li $v0, 4
		syscall
		j End
		
notEqual:	la $a0, unequalStr 		# printing that strings aren't equal
		li $v0, 4
		syscall

		addi $s7, $s7, 1		#increment iterator
		addi $s2, $s2, 5		#incremement array address to access next element
		
		j loop
		
notFound:	la $a0, notFoundStr 		#printing that strings are equal
		li $v0, 4
		syscall		
End:		addi $v0, $0, 10 		#terminate the program
		syscall
