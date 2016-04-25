.data
# File
filename: .asciiz "test.txt" #file name
textSpace: .space 1050     #space to store strings to be read

#Important Chars
spaceChar: 	.byte 	' '
commaChar:	.byte 	','
poundChar:	.byte 	'#'
newLnChar:	.byte 	'\n'
newLn:		.asciiz "\n"
nullTerm: 	.byte '\0'
colonChar: 	.byte ':'


# Tokenizing Opcode
instrucArr: 	.asciiz	"add  ", "addu ", "and  ", "jr   ", "nor  ", "or   ", "slt  ", "sltu ",
		 	"sll  ", "srl  ", "sub  ", "subu ", "addi ", "addiu", "andi ", "beq  ",
		 	"bne  ", "lbu  ", "lhu  ", "ll   ", "lui  ", "lw   ", "slti ", "sltiu",
		 	"sb   ", "sh   ", "sw   ", "j    ", "jal  "

		 	#add-subu are R-format--all opcodes are 000000
		 	#addi-sw are I-format--opcodes range
		 	#j and jal are J-format--opcodes are 000010 and 000011 respectively

opcodeArray: 	.asciiz "000000", "000000", "000000", "000000", "000000", "000000", "000000", "000000",
			"000000", "000000", "000000", "000000", "001000", "001001", "001100", "000100",
	 		"000101", "100100", "100101", "110000", "001111", "100011", "001010", "001011",
			"101000", "101001", "101011", "000010", "000011"
opcode: 	.asciiz " \n"
opcode2:	.asciiz " "
opcode3:	.asciiz " "

# Tokenizing operands
tokenBuffer:.space 20
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
	
# Checking Prompts
equalStr: .asciiz "\nStrings are equal "
unequalStr: .asciiz "\nStrings aren't equal."
notFoundStr: .asciiz "\n You entered an immediate.\n"
labelStr: .asciiz "\nThe label is : "
	
# Binary Storage
rd: .asciiz ""
rs: .asciiz ""
rt: .asciiz ""
label: .space 20
labelPC:.word

smile:.asciiz ":)"

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
 		
 		add $a0, $a0, $t1	#add displacement to addr
 		lb $a0, ($a0)		#load character
 		li $v0, 11		#syscall 11 - print character
 		syscall
 		
 		move $s6, $a0		# move the char to $s6 for paramter
 		jal charCat		# concatenate chars and check if end of token
 		
 		move $a0, $s6
 		move $s6, $t1		#move iteration # to $s6 for parameter
 		addi $t1, $t1, 1	#increment counter
 		
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
		
		move $t1, $s0
		
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
		
				
	# Concatenate characters
	#@PARAM - $s6 - contains the char to concatenate
	charCat: 
		# if space ' '
		lb $s1, spaceChar	
		beq $s6, $s1, isSpace 
		
		#else if ','
		lb $s1, commaChar	
		beq $s6, $s1, back 	# if comma, don't add ir into buffer
		
		# else if ':'
		lb $s1, colonChar	#
		beq $s6, $s1, isLabel
		
		# else, concatenate
		addi $t7, $t7, 1	# increment char counter
		sb $s6, ($a1)		# concatenate char
		addi $a1, $a1, 1 	# update address

		back:
		move $s5, $zero		# Resets check - $s5 determines if the previous char was a colon: 
		
		move $a0, $s6
		li $v0, 11
		syscall
		
		jr $ra			# back to getChar
	
	# Make the token 5 characters long to compare with registerArr elements
	isSpace: 
		la $a1, tokenBuffer	# load the address
		add $a1, $a1, $t7	# update r/w address
		lb $s1, spaceChar
		sb $s1, ($a1)		# add space char
		addi $t7, $t7, 1	# increment char counter
		ble $t7, 5, isSpace	# add another space if the string isn't 5 characters
		
		lb $s1, nullTerm	# load the null terminator
		sb $s1, ($a1)		# concantenate the null terminator
		
		move $t7, $zero		# clear counter
		la $a1, tokenBuffer	# reset read/write location
		#beq $s5, 0, compare
		
		la $a0, smile
		li $v0, 4
		syscall
		
		
		la $a0, tokenBuffer
		li $v0, 4
		syscall
		
		jr $ra
		
	
	# Load address
	isLabel:
		li $s5, 1		# sets the isColon flag to 1
	
		addi $sp, $sp, -4	# create stack
		sw $ra, 0($sp)		# store in original $ra
		
		jal isSpace		# add spaces to align
		
		la $t1, tokenBuffer	# Load address of tokenBuffer
		li $t3, 0		# char counter
		la $t2, label		# Load address of label   ############# Pass
		li $t5, 5		##### Max number of chars ############# Pass
	
	copLabel:
		lb  $t4, 0($t1) 	# load byte in $t4 from tokenBuffer
		sb $t4, 0($t2)		# store byte into label
		addi $t3, $t3, 1	# increment counter
		addi $t1, $t1, 1	# increment read address of tokenBuffer
		addi $t2, $t2, 1	# increment writee address of label
		bne $t3, $t5, copLabel 	# stop loop if we get to 5 chars
		
		la $a0, labelStr
		li $v0, 4
		syscall
		
		la $a0, label		#print
		li $v0, 4
		syscall
		
		lb $a0, newLnChar	# add newline character
		li $v0, 11
		syscall
		
		lw $ra, 0($sp)		# reload original address
		addi $sp, $sp, 4	# diffuse the stack
		
		jr $ra

	compare:
		li $s1, 29				# Array Size ######### Pass
		la $s2, opcodeArray			# Holds array address #### Pass
		li $s5, 0				# iterator, keeps track of array index
		li $s6, 5				# number of char per index in the array
	
	comLoopA1:		
		la $s3, 0($s2)				#load word2 address in $s3
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
		la $a0, equalStr 			# printing that strings are equal
		li $v0, 4
		syscall
		
		move $a0, $s5				# print which register
		li $v0, 1
		syscall 
		
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
		
		jr $ra
		
		#la $t9, rd		# Load address of label   ############# Pass
		#li $t5, 5		##### Max number of chars ############# Pass
		#j copyContents
		
	notEqual:	
		beq $s5, $s1, notFound
		addi $s5, $s5, 1			#increment iterator
		addi $s2, $s2, 6			#incremement array address to access next element
		j comLoopA1
	
	#not found will find immediate values	
	notFound:	
		la $a0, notFoundStr 			#printing that strings are equal
		li $v0, 4
		syscall
		
		jr $ra
							
