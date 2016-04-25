.data
		instruction: .asciiz "bne  "
		array: .asciiz  
				"add  ", "addu ", "and  ", "jr   ", "nor  ", "or   ", "slt  ", "sltu ",
		 		"sll  ", "srl  ", "sub  ", "subu ", "addi ", "addiu", "andi ", "beq  ",
		 		"bne  ", "lbu  ", "lhu  ", "ll   ", "lui  ", "lw   ", "slti ", "sltiu",
		 		"sb   ", "sh   ", "sw   ", "j    ", "jal  "
		 		
		 		#add-subu are R-format--all opcodes are 000000
		 		#addi-sw are I-format--opcodes range
		 		#j and jal are J-format--opcodes are 000010 and 000011 respectively
		 		
		opcodeArray: .asciiz 
				"000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000", 
				"000000", "000000", "000000", "000000", "001000", "001001", "001100", "000100",
				"000101", "100100", "100101", "110000", "001111", "100011", "001010", "001011", 
				"101000", "101001", "101011", "000010", "000011"
				
		opcode: .asciiz " \n"
		opcode2:	.asciiz " "
		opcode3:	.asciiz " "
		binaryPrompt: .asciiz "\nThe opcode is: "
		equalStr: .asciiz "\nString found. Instruction equals instruction in array index: "
		unequalStr: .asciiz "\nUnequal strings."
		notFoundStr: .asciiz "\nInstruction not found."
		newLn: .byte '\n'
.text

main:		la $s0, instruction			#load word1 address
		li $s1, 29				#$s1 holds 10
		la $s2, array				#holds array address
		li $s5, 0				#iterator, keeps track of where we are in array
		
loop:		la $s3, 0($s2)				#load word2 address in $s3
		li $t0, 0				#reset $t0 for element being compared to
		li $t1, 0				#reset $t1 for element being compared to
		li $t2, 0				#reset $t2 for element being compared to
		li $t3, 0				#reset $t3 for element being compared to

compare:	beq $t0, 5, equalPrint			#once the counter has reached 4, test to see if $v0 is 0 (strings are equal)
		
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
		
		move $a0, $s5
		li $v0 1
		syscall 
		
		j getBinary
		
notEqual:	la $a0, unequalStr 			# printing that strings aren't equal
		li $v0, 4
		syscall
		
		beq $s5, $s1, notFound			#if the counter has been updated to 29 that means the instruction wasn't fuound
		addi $s5, $s5, 1			#increment iterator
		addi $s2, $s2, 6			#incremement array address to access next element
		j loop

notFound:	la $a0, notFoundStr 			#printing that strings are equal
		li $v0, 4
		syscall
		j End

#will use $s5 to find needed opcode
getBinary:	la $a0, binaryPrompt
		li $v0, 4
		syscall
		
		li $a0, 0		#clear $a0
		la $t7, opcodeArray	#get base address of the opcode array
		li $t6, 7		#load 6 into $t6
		mul $t6, $s5, $t6	#multiply this by the amount of index number of the instruction locaiton
		add $a0, $t7, $t6 	#add the offset to the base address to get address of required opcode
					#a0 holds address of instruction opcode
		move $t1, $a0		#move opcode
		move $t5, $t1
		li $v0, 4
		syscall
		
		
		#now save the Opcode into the opcode variable
		#save .asciiz in $a0 into opcode
		
		lb $a0, newLn
		li $v0, 11
		syscall
		
		li $t3, 0		#counter

	loop2:	la $t2, opcode
		move $t1, $t5
		add $t1, $t1, $t3	#add offset to array
		add $t2, $t2, $t3	#add offset to opcode
		
		lb $t4, ($t1)
		sb $t4, ($t2)
		
		addi $t3, $t3, 1	#increment counter
		beq $t3, 6, End
		#j End
		j loop2
		
	
End:		la $a0, opcode
		li $v0, 4
		syscall
		
		addi $v0, $0, 10 			#terminate the program
		syscall
