.data
#filename: .asciiz "E:\Documents\\OneDrive\\Documents\\School\\Sophomore\\Spring\\CS 3340\\Semester_Project\\test.txt" #file name
filename: .asciiz "test.txt" #file name
textSpace: .space 1050     #space to store strings to be read
spaceChar: 	.byte 	' '
commaChar:	.byte 	','
poundChar:	.byte 	'#'
newLnChar:	.byte 	'\n'
newLn:	.asciiz 	"\n"

#opcodePrinter .data
instruction: .asciiz "bne  "
		instrucArr: .asciiz
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


#REGISTERS :)
#$s0 - Total iterations		$t0 - file descriptor		$t3 - iterations for loops	$s6 - holds method params
#$s7 - Number of lines read
.text
	main:	
		li $v0, 13		#open the file
		li $a1, 0		#open to read
		la $a0, filename	#load name
		add $a2, $zero, $zero	#file mode
		syscall
		
		move $t0, $v0		#load file descriptor
		move $a0, $t0
		la $a1, textSpace	#load address of the space
		li $a2, 1050		#read 40 characters
		li $v0, 14		#syscall 14 - read from file
		syscall
		
		#lb $s1, spaceChar	#contains the "space" character
		
		li $s0, 0		#number of characters read
		li $s7, 0		#number of lines read
		
		#Get the first space
	loop:	
		la $a0, textSpace	#load address of the string to be printed
		
		add $a0, $a0, $s0	#add displacement to addr
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		
		move $s6, $s0		#move iteration # to $s6 for parameter
		addi $s0, $s0, 1	#increment counter
		
		jal chkChar		#print number of iterations
		move $s0, $s6		#STORE iterations for opcode
		
		la $a0, newLn
		li $v0, 4
		syscall
	
		jal rLoopA		#REGISTER INSTRUCTION FORMAT
		#jal jLoopA		#JUMP INSTRUCTION FORMAT
		
		la $a0, newLn		#print line break
		li $v0, 4	
		syscall	
		
		addi $s7, $s7, 1	#increment the number of lines read
		beq $s7, 3, end		#Number of lines to read
		
		j loop
	
		#REGISTER INSTRUCTION FORMAT and also BRANCH INSTRUCTION FORMAT
		#Get operands of R instruction
	rLoopA:	addi $sp, $sp, -4	#make space to store $ra
		sw $ra, 0($sp)		#store return address
		li $t3, 0		#store number of iterations for first operand
		addi $s0, $s0, 1	#used for formatting
	rLoopA1:	
		la $a0, textSpace	#load address of string	
		add $a0, $a0, $s0 	#start at the space
		add $a0, $a0, $t3	#add displacement for iterations
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		
		addi $t3, $t3, 1	#increment counter
		bne $a0, $s1, rLoopA1	#if character isn't a space, then repeat
		
		add $s0, $s0, $t3	#add to total number of iterations
		move $s6, $s0
		jal prInt		#print number of iterations
		
		la $s6, newLn		#print a blank line
		jal prStr

	rLoopB:	li $t3, 0		#store number of iterations for third operand
	rLoopB1:	
		la $a0, textSpace	#load address of string	
		add $a0, $a0, $s0 	#start at the space
		add $a0, $a0, $t3	#add displacement for iterations
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		addi $t3, $t3, 1	#increment counter
		bne $a0, $s1, rLoopB1	#if character isn't a space, then repeat
		

		add $s0, $s0, $t3	#add to total number of iterations
		move $s6, $s0		#move number of iterations to parameter register
		jal prInt		#print number of iterations
		
		la $s6, newLn		#print a blank line
		jal prStr
		
	rLoopC:	li $t3, 0		#store number of iterations for second operand
	rLoopC1:	
		la $a0, textSpace	#load address of string	
		add $a0, $a0, $s0 	#start at the space
		add $a0, $a0, $t3	#add displacement for iterations
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		addi $t3, $t3, 1	#increment counter
		bne $a0, $s1, rLoopC1	#if character isn't a space, then repeat
		

		add $s0, $s0, $t3	#add to total number of iterations
		move $s6, $s0		#move number of iterations to parameter register
		jal prInt		#print number of iterations
		
		lw $ra, 0($sp)		#restore return address
		addi $sp, $sp, 4	#close stack
		jr $ra
		
	#JUMP INSTRUCTION FORMAT
	#Gets the label name
	jLoopA:	addi $sp, $sp, -4	#open stack
		sw $ra,($sp)		#store return address
		li $t3, 0		#store number of iterations for label
		addi $s0, $s0, 1	#used for formatting
	jLoopA1:
		la $a0, textSpace	#load address of string
		add $a0, $a0, $s0 	#start at the space
		add $a0, $a0, $t3	#add displacement for iterations
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		addi $t3, $t3, 1	#increment counter
		bne $a0, $s1, jLoopA1	#if character isn't a space, then repeat
		

		add $s0, $s0, $t3	#add to total number of iterations
		move $s6, $s0		#move number of iterations to parameter register
		jal prInt		#print number of iterations
		
		lw $ra, 0($sp)		#restore return address
		addi $sp, $sp, 4	#close stack
		jr $ra
	
	end:	move $a0, $t0		#load file descriptor into a0
		li $v0, 16		#syscall 16 - close file
		syscall
		
		li $v0, 10		#syscall 10 - end program
		syscall
	
		
	
	#PRINTS out an integer
	#@PARAM - $s6 - stores the integer that needs to be printed
	prInt:	addi $sp, $sp, -4
		sw $ra, ($sp)
		move $a0, $s6		#move int to $a0
		
		li $v0, 1		#syscall 1 - print integer
		syscall
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra			#return
	
	#PRINTS out a string
	#@PARAM - $s6 - contains starting addr of string
	prStr:	addi $sp, $sp, -4
		sw $ra, ($sp)
		move $a0, $s6		#move start address to $a0
		
		li $v0, 4		#syscall 4 - print string
		syscall
		
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra
		
	#COMPARES char to space and finds the iteration
	#@PARAM - $s6 - contains the iteration number
	chkChar:	addi $sp, $sp, -4		#make space for one register
			sw $ra, 0($sp)			#store return addr
			lb $s1, poundChar		#contains the "#" character
			beq $a0, $s1, chkComment	#if the character is a comment, branch
			lb $s1, spaceChar		#contains the "space" character
			bne $a0, $s1, loop		#if the character isn't a space, then repeat
			jal prInt			#print iteration number
			lw $ra, 0($sp)			#restore return addr
			addi $sp, $sp, 4		#restore stack
			
			jr $ra				#jump back
	
	#CHECKS if the next character is a '#' to end the program
	#DATA - holds byte for # in $t6		
	chkEnd:		lb $t6, spaceChar
			beq $a0, $t6, end
			jr $ra
	#CHECKS if character is a # and skips the next twenty characters
	chkComment:	addi $s0, $s0, 20		#add 20 to number of characters read
			addi $s7, $s7, 1		#increment number of lines read
			j loop
	
	#DETERMINES what instruction format to branch to
	chkFormat:	

############# - SHANE - OPCODE PRINTER - ##########################################################

opcodePrinter:	
		addi $sp, $sp, -4			#store return address in stack
		sw $ra, ($sp)
		la $s0, instruction			#load word1 address
		li $s1, 29				#$s1 holds 10
		la $s2, instrucArr				#holds array address
		li $s5, 0				#iterator, keeps track of where we are in array

opcodePrinterloop:	
		la $s3, 0($s2)				#load word2 address in $s3
		li $t0, 0				#reset $t0 for element being compared to
		li $t1, 0				#reset $t1 for element being compared to
		li $t2, 0				#reset $t2 for element being compared to
		li $t3, 0				#reset $t3 for element being compared to

opcodePrinterCompare:	
		beq $t0, 5, opcodePrinterEqualPrint			#once the counter has reached 4, test to see if $v0 is 0 (strings are equal)

		add $t1, $s0, $t0 			#put token (instruction) address into $t1, address($s0) + offset($t0)
		lb  $t2, 0($t1) 			#load letter/byte at address $t1
		add $t1, $s3, $t0 			#put array address into $t1
		lbu $t3, 0($t1)				#load first letter of array element

		bne $t2, $t3, opcodePrinterNotEqual			#...jump to notEqual if letters aren't equal, otherwise check next letter
		addi $t0, $t0, 1 			# i = i + 1, shift to next letter
		j opcodePrinterCompare 				# next iteration of loop

opcodePrinterEqualPrint:	
		la $a0, equalStr 			# printing that strings are equal
		li $v0, 4
		syscall

		move $a0, $s5
		li $v0 1
		syscall

		j opcodePrinterGetBinary

opcodePrinterNotEqual:	
		la $a0, unequalStr 			# printing that strings aren't equal
		li $v0, 4
		syscall

		beq $s5, $s1, opcodePrinterNotFound			#if the counter has been updated to 29 that means the instruction wasn't fuound
		addi $s5, $s5, 1			#increment iterator
		addi $s2, $s2, 6			#incremement array address to access next element
		j opcodePrinterloop

opcodePrinterNotFound:	
		la $a0, notFoundStr 			#printing that strings are equal
		li $v0, 4
		syscall
		j opcodePrinterEnd

#will use $s5 to find needed opcode
opcodePrinterGetBinary:	
		la $a0, binaryPrompt
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

		lb $a0, newLnChar
		li $v0, 11
		syscall

		li $t3, 0		#counter

opcodePrinterloop2:	
		la $t2, opcode
		move $t1, $t5
		add $t1, $t1, $t3	#add offset to array
		add $t2, $t2, $t3	#add offset to opcode

		lb $t4, ($t1)
		sb $t4, ($t2)

		addi $t3, $t3, 1	#increment counter
		beq $t3, 6, opcodePrinterEnd		
		j opcodePrinterloop2


opcodePrinterEnd:		
		la $a0, opcode
		li $v0, 4
		syscall

		lw $ra, ($sp)		#jump back
		addi $sp, $sp, 4
		jr $ra
