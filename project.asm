.data
#filename: .asciiz "E:\Documents\\OneDrive\\Documents\\School\\Sophomore\\Spring\\CS 3340\\Semester_Project\\test.txt" #file name
filename: .asciiz "test.txt" #file name
textSpace: .space 1050     #space to store strings to be read
equalStr:	.asciiz "\nThe characters are equal\n"
loopStr:	.asciiz "\nThe loop is starting\n"
spaceChar: 	.byte 	' '
commaChar:	.byte 	','
poundChar:	.byte 	'#'
newLnChar:	.byte 	'\n'
newLn:	.asciiz 	"\n"


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