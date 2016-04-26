.data
# $s0, t1, t0, t3

	# important characters
	spaceChar: .byte ' '
	newLnChar: .byte '\n'
	poundChar: .byte '#'
	commaChar: .byte ','
	nullTerm: .byte '\0'
	colonChar: .byte ':'

			
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
	
	# Checking Prompts
	equalStr: .asciiz "\nStrings are equal "
	unequalStr: .asciiz "\nStrings aren't equal."
	notFoundStr: .asciiz "\nYou entered an immediate.\n"
	labelStr: .asciiz "\nthe label is : "
	
	# Storage
	rd: .asciiz ""
	rs: .asciiz ""
	rt: .asciiz ""
	label: .space 20
	labelPC:.word
	immediate: .asciiz ""

.text
	# Intializing program variables 
	addi $t7, $t7, 0 	# intialize counter
	la $a1, tokenBuffer 	# load address of token 

	#intialize arrays
	
	jal getChar
	
	###############################################
	# getChar - mimics Krishna's code
	getChar:
		li $v0, 12 		# Enter character
		syscall			# $v0 = input char
		move $t6, $v0		# move character to $v0

		# Terminate if '#'
		lb $t1, poundChar	# load program terminator
		beq $t1, $t6, end
		
	###############################################


	# Concatenate characters
	charCat:
		# if space ' '
		lb $s1, spaceChar	
		beq $t6, $s1, isSpace 
		
		#else if ','
		lb $s1, commaChar	
		beq $t6, $s1, back 	# Can't concantenate commas
		
		# else if ':'
		lb $s1, colonChar
		beq $t6, $s1, isLabel
		
		# else, concatenate
		addi $t7, $t7, 1	# increment char counter
		sb $t6, ($a1)		# concatenate char
		addi $a1, $a1, 1 	# update address

		back:
		move $s5, $zero		# Resets check - $s5 determines if the previous char was a colon: 
		jr $ra			# back to getChar
	
	# Make the token 5 characters long to compare with registerArr elements
	isSpace: 
		lb $s1, spaceChar
		addi $t7, $t7, 1	# increment char counter
		sb $s1, ($a1)		# add space char
		addi $a1, $a1, 1 	# update r/w address
		ble $t7, 5, isSpace	# add another space if the string isn't 5 characters
		
		lb $s1, nullTerm	# load the null terminator
		sb $s1, ($a1)		# concantenate the null terminator
		
		move $t7, $zero		# clear counter
		la $a1, tokenBuffer	# reset read/write location
		beq $s5, 0, compare
		
		j back
	
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
		
		j back

	compare:
		li $s1, 31				# Array Size ######### Pass
		la $s2, registerArr			# Holds array address #### Pass
		li $s5, 0				# iterator, keeps track of array index
		li $s6, 6				# number of char per index in the array
	
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
		
		j back
		
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
		
		j back
		
		#la $t1, tokenBuffer	# Load address of tokenBuffer
		#la $t9, immediate		# Load address of label   ############# Pass
		#li $t5, 5		##### Max number of chars ############# Pass
		#j copyContents
	
#copyContents:
		li $t3, 0		# char counter
		
	#copy:
		add $t1, $t3, $t1
		add $t9, $t3, $t9 
		lb  $t4, 0($t1) 	# load byte in $t4 from tokenBuffer
		sb  $t4, 0($t9)		# store byte into label
		addi $t3, $t3, 1	# increment counter
		
		move $a0, $t4
		li $v0, 11
		syscall 
		
		lb $a0, spaceChar
		li $v0, 11
		syscall 
		
		#bne $t3, 5, copy 	# stop loop if we get to 5 chars
	
	
		move $a0, $t3
		li $v0, 11
		syscall
		
		lb $a0, newLnChar
		li $v0, 11
		syscall 
		
		la $a0, rd
		li $v0, 4
		syscall 
		
		lb $a0, newLnChar
		li $v0, 11
		syscall 

		la $a0, tokenBuffer
		li $v0, 4
		syscall 

		jr $ra
	
	# End Program
	end:
		li $v0, 10
		syscall

