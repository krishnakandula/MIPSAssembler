.data
#filename: .asciiz "E:\Documents\\OneDrive\\Documents\\School\\Sophomore\\Spring\\CS 3340\\Semester_Project\\test.txt" #file name
filename: .asciiz "test.txt" #file name
textSpace: .space 1050     #space to store strings to be read
spaceChar: 	.byte 	' '
commaChar:	.byte 	','
poundChar:	.byte 	'#'
newLnChar:	.byte 	'\n'
newLn:	.asciiz 	"\n"
nullTerm: .byte '\0'
colonChar: .byte ':'

smile: .asciiz ":)\n"

#opcodePrinter .data
instruction: .asciiz "bne  "
		instrucArr: .asciiz
				"addu  ", "add   ", "and   ", "jr    ", "nor   ", "or    ", "slt   ", "sltu  ",
		 		"sll   ", "srl   ", "sub   ", "subu  ", "addi  ", "addiu ", "andi  ", "beq   ",
		 		"bne   ", "lbu   ", "lhu   ", "ll    ", "lui   ", "lw    ", "slti  ", "sltiu ",
		 		"sb    ", "sh    ", "sw    ", "j     ", "jal   ", "mul   "

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

#TOKEN TRANSLATER .data
# Token Comparision
	tokenBuffer:.space 200

	registerArr: .asciiz "$zero", "$at  ", "$v0  ", "$v1  ", "$a0  ", "$a1  ", "$a2  ",
			     "$a3  ", "$t0  ", "$t1  ", "$t2  ", "$t3  ", "$t4  ", "$t5  ",
			     "$t6  ", "$t7  ", "$s0  ", "$s1  ", "$s2  ", "$s3  ", "$s4  ",
			     "$s5  ", "$s6  ", "$s7  ", "$t8  ", "$t9  ", "$k0  ", "$k1  ",
			     "$gp  ", "$sp  ", "$fp  ", "$ra  "
	registerBin: .asciiz "00000", "00001", "00010", "00011", "00100", "00101", "00110",
			     "00111", "01000", "01001", "01010", "01011", "01100", "01101",
			     "01110", "01111", "10000", "10001", "10010", "10011", "10100",
			     "10101", "10110", "10111", "11000", "11001", "11010", "11011",
			     "11100", "11101", "11110", "11111"
	str: .asciiz "\n Token Array: \n"

	labelStr: .asciiz "\nthe label is : "

	# Storage
	rd: .asciiz ""
	rs: .asciiz ""
	rt: .asciiz ""
	label: .space 20
	labelPC:.word
	immediate: .asciiz ""
	tokenNotFoundStr:	.asciiz "\nYou entered an immediate.\n"
	fd:.word
###############################################################################

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

		move $t0, $v0
		move $a0, $t0

		la $a1, textSpace	#load address of the space
		li $a2, 1050		#read 40 characters
		li $v0, 14		#syscall 14 - read from file
		syscall

		#lb $s1, spaceChar	#contains the "space" character

		li $s0, 0		#number of characters read
		li $s7, 0		#number of lines read

		li $t7, 0		#counter for mandy
		li $t4, 0		#counter for index of the array for opcodeLoop
		li $t6, 0		#counter for index of the string for opcdeLoop
		li $t9, 0

		#Get the first space
	loop:	la $a0, textSpace	#load address of the string to be printed
		add $a0, $a0, $s0	#add displacement to addr
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		move $s6, $a0		#parameter
		move $s2, $a0
		lb $s1, poundChar		#contains the "#" character
		beq $a0, $s1, chkComment	#if the character is a comment, branch
		jal getOpCode
		move $a0, $s2
		move $s6, $s0		#move iteration # to $s6 for parameter
		addi $s0, $s0, 1	#increment counter

		jal chkChar		#print number of iterations
		move $s0, $s6		#STORE iterations for opcode


		jal rLoopA		#REGISTER INSTRUCTION FORMAT
		#jal jLoopA		#JUMP INSTRUCTION FORMAT
		move $t9, $s0
		addi $t9, $t9, 1

		la $a0, newLn		#print line break
		li $v0, 4
		syscall

		addi $s7, $s7, 1	#increment the number of lines read
		beq $s7, 4, end		#Number of lines to read

		#addi $s0, $s0, 1	#Fixing the space address
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

		move $t6, $a0		#testing mandy's code
		jal tokenTranslator

		addi $t3, $t3, 1	#increment counter
		lb $s1, spaceChar
		bne $a0, $s1, rLoopA1	#if character isn't a space, then repeat

		add $s0, $s0, $t3	#add to total number of iterations
		move $s6, $s0

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

		move $t6, $a0		#testing mandy's code
		jal tokenTranslator

		addi $t3, $t3, 1	#increment counter
		lb $s1, spaceChar
		bne $a0, $s1, rLoopB1	#if character isn't a space, then repeat

		add $s0, $s0, $t3	#add to total number of iterations
		move $s6, $s0		#move number of iterations to parameter register

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

		move $t6, $a0		#testing mandy's code
		jal tokenTranslator

		addi $t3, $t3, 1	#increment counter
		lb $s1, spaceChar
		bne $a0, $s1, rLoopC1	#if character isn't a space, then repeat



		add $s0, $s0, $t3	#add to total number of iterations
		move $s6, $s0		#move number of iterations to parameter register


		lw $ra, 0($sp)		#restore return address
		addi $sp, $sp, 4	#close stack
		li $t4, 0
		li $t6, 0
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
		#jal prInt		#print number of iterations

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
			#lb $s1, poundChar		#contains the "#" character
			#beq $a0, $s1, chkComment	#if the character is a comment, branch
			lb $s1, spaceChar		#contains the "space" character
			bne $a0, $s1, loop		#if the character isn't a space, then repeat
			#jal prInt			#print iteration number
			lw $ra, 0($sp)			#restore return addr
			addi $sp, $sp, 4		#restore stack

			jr $ra				#jump back

	#CHECKS if the next character is a '#' to end the program
	#DATA - holds byte for # in $t6
	chkEnd:		lb $t6, spaceChar
			beq $a0, $t6, end
			jr $ra
	#CHECKS if character is a # and skips the next twenty characters
	chkComment:	addi $s0, $s0, 8		#add 20 to number of characters read
			addi $s7, $s7, 1		#increment number of lines read
			j loop

	#DETERMINES what instruction format to branch to
	chkFormat:

############## - GET - OP - CODE - ##########################################

	getOpCode:	addi $sp, $sp, -4
			sw $ra, ($sp)


	opcodeLoop:	
			la $t5, instrucArr		#load address of the array
			add $t5, $t5, $t4		#add offset of the array
			add $t5, $t5, $t6		#add offset of the string

			lb $a0, ($t5)			#get byte of the index

			beq $a0, $s6, incrementStrIndex	#if characters are equal, increment strindex
			addi $t4, $t4, 7		#else increment index of array
			li $t6, 0
			bge $t4, 203, end
			move $s0, $t9
			la $s6, textSpace		#get address of text buffer
			add $s6, $s6, $s0		#add offset
			lb $s6, ($s6)			#get character from textbuffer
			j opcodeLoop
incrementStrIndex:	addi $t6, $t6, 1		#increment str index
			lb $s1, spaceChar
			beq $s1, $s6, return
			addi $sp, $sp, 4
			addi $s0, $s0, 1
			j loop

		return:	la $a0, opcodeArray
			add $a0, $a0, $t4
			li $v0, 4
			syscall

			lw $ra, ($sp)
			addi $sp, $sp, 4
			li $t4, 0
			li $t6, 0

			lb $a0, newLnChar
			li $v0, 11
			syscall

			jr $ra

############ - MANDY - TOKEN_TRANSLATOR - ###################################

 # Intializing program variables
 	tokenTranslator:
 	addi $sp, $sp, -4	#store return address
 	sw $ra, ($sp)

	#addi $t7, $t7, 0 	# intialize counter
	la $a1, tokenBuffer 	# load address of token

	# Concatenate characters
	charCat:
		add $a1, $a1, $t7	#update address
		# if space ' '
		lb $s1, spaceChar
		beq $t6, $s1, isSpace

		#else if ','
		lb $s1, commaChar
		beq $t6, $s1, back 	# Can't concantenate commas

		# else, concatenate
		addi $t7, $t7, 1	# increment char counter
		sb $t6, ($a1)		# concatenate char
		 
		back:
		move $s5, $zero		# Resets check - $s5 determines if the previous char was a colon:

		lw $ra, ($sp)		#get return address
		addi $sp, $sp, 4
		jr $ra

	# Make the token 5 characters long to compare with registerArr elements
	isSpace:
		lb $s1, spaceChar
		addi $t7, $t7, 1	# increment char counter
		sb $s1, ($a1)		# add space char
		addi $a1, $a1, 1 	# update r/w address
		ble $t7, 4, isSpace	# add another space if the string isn't 5 characters

		lb $s1, nullTerm	# load the null terminator
		sb $s1, ($a1)		# concantenate the null terminator

		move $t7, $zero		# clear counter
		la $a1, tokenBuffer	# reset read/write location
		beq $s5, 0, compare

		#jr $ra
		j back

	compare:
		li $t0, 31 #t0				# Array Size ######### Pass
		la $s2, registerArr			# Holds array address #### Pass
		li $s5, 0				# iterator, keeps track of array index
		li $s6, 6				# number of char per index in the array ##### pass *****

	comLoopA1:
		la $s3, 0($s2)				#holds the comparision array - opcode or register a
		li $t4, 0				#reset $t4 for element being compared to
		li $t1, 0				#reset $t1 for element being compared to
		li $t2, 0				#reset $t2 for element being compared to
		li $t8, 0				#reset $t8 for element being compared to

	comLoopA2:
		beq $t4, 5, equalPrint			#once the counter has reached 4, test to see if $v0 is 0 (strings are equal)
		add $t1, $a1, $t4 			# update read address
		lb  $t2, 0($t1) 			#load letter/byte at address $t1
		add $t1, $s3, $t4 			#put array address into $t1
		lbu $t8, 0($t1)				#load first letter of array element

		bne $t2, $t8, notEqual			#...jump to notEqual if letters aren't equal, otherwise check next letter
		addi $t4, $t4, 1 			# i = i + 1, shift to next letter
		j comLoopA2				# next iteration of loop

	equalPrint:

		lb $a0, newLnChar				# add newline character
		li $v0, 11
		syscall

		la $a0, registerBin
		mul $t5 $s5, $s6
		add $a0, $a0, $t5

		move $t1, $a0
		li $v0, 4
		syscall

		lb $a0, newLnChar
		li $v0, 11
		syscall

		lb $a0, spaceChar

		j back

	notEqual:
		beq $s5, $t0, notFound			# checks if we're at the last index element
		addi $s5, $s5, 1			#increment iterator
		addi $s2, $s2, 6			#incremement array address to access next element  #####
		j comLoopA1

	#not found will find immediate values
	notFound:
		la $a0, tokenNotFoundStr 			#printing that strings are equal
		li $v0, 4
		syscall

		lb $a0, spaceChar
		j back