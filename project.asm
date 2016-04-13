.data
#filename: .asciiz "C:\\Users\\krish\\OneDrive\\Documents\\School\\Sophomore\\Spring\\CS 3340\\MIPS Programs\\test.txt" #file name
filename: .asciiz "test.txt" #file name
textSpace: .space 1050     #space to store strings to be read
equalStr:	.asciiz "\nThe characters are equal\n"
spaceChar: .byte ' '
commaChar:	.byte ','
poundChar:	.byte '#'
newLn:	.asciiz "\n"

#REGISTERS :)
#$s0 - Total iterations		$s1 - space character	$s2 - comma char	$s6 - holds method params
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
		
		lb $s1, spaceChar	#contains the "space" character
		
		li $t1, 0		#holds counter
		
		#Get the first space
	loop:	la $a0, textSpace	#load address of the string to be printed
		
		add $a0, $a0, $t1	#add displacement to addr
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		
		#CHECK to end the program
		#jal chkEnd 
		
		move $s6, $t1		#move iteration # to $s6
		addi $t1, $t1, 1	#increment counter
		
		jal chkChar		#print number of iterations
		move $s0, $s6		#STORE iterations for opcode
		
		la $a0, newLn
		li $v0, 4
		syscall

		jal rLoopA
		j end
	
		#Get operands of R instruction
	rLoopA:	addi $sp, $sp, -4	#make space to store $ra
		sw $ra, 0($sp)		#store return address
		li $t3, 0		#store number of iterations for first operand
		addi $s0, $s0, 2
	rLoopA1:	la $a0, textSpace	#load address of string	
		add $a0, $a0, $s0 	#start at the space
		add $a0, $a0, $t3	#add displacement for iterations
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		
		addi $t3, $t3, 1	#increment counter
		bne $a0, $s1, rLoopA1	#if character isn't a space, then repeat
		
		add $s0, $s0, $t3	#add to total number of iterations
		move $s6, $s0
		jal chkChar		#print number of iterations
		
		la $s6, newLn		#print a blank line
		jal prStr

	rLoopB:	li $t3, 0		#store number of iterations for third operand
		addi $s0, $s0, 1
	rLoopB1:	la $a0, textSpace	#load address of string	
		add $a0, $a0, $s0 	#start at the space
		add $a0, $a0, $t3	#add displacement for iterations
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		addi $t3, $t3, 1	#increment counter
		bne $a0, $s1, rLoopB1	#if character isn't a space, then repeat
		

		add $s0, $s0, $t3	#add to total number of iterations
		move $s6, $s0		#move number of iterations to parameter register
		jal chkChar		#print number of iterations
		
		la $s6, newLn		#print a blank line
		jal prStr
		
	rLoopC:	li $t3, 0		#store number of iterations for second operand
		addi $s0, $s0, 1
	rLoopC1:	la $a0, textSpace	#load address of string	
		add $a0, $a0, $s0 	#start at the space
		add $a0, $a0, $t3	#add displacement for iterations
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		addi $t3, $t3, 1	#increment counter
		bne $a0, $s1, rLoopC1	#if character isn't a space, then repeat
		

		add $s0, $s0, $t3	#add to total number of iterations
		move $s6, $s0		#move number of iterations to parameter register
		jal chkChar		#print number of iterations
		
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
	prInt:	move $a0, $s6		#move int to $a0
		
		li $v0, 1		#syscall 1 - print integer
		syscall
		
		jr $ra			#return
	
	#PRINTS out a string
	#@PARAM - $s6 - contains starting addr of string
	prStr:	move $a0, $s6		#move start address to $a0
		
		li $v0, 4		#syscall 4 - print string
		syscall
		
		jr $ra
		
	#COMPARES char to space and finds the iteration
	#@PARAM - $s6 - contains the iteration number
	chkChar:	addi $sp, $sp, -4	#make space for one register
			sw $ra, 0($sp)	#store return addr
			bne $a0, $s1, loop	#if the character isn't a space, then repeat
			jal prInt	#print iteration number
			lw $ra, 0($sp)	#restore return addr
			addi $sp, $sp, 4	#restore stack
			
			jr $ra		#jump back
	
	#CHECKS if the next character is a '#' to end the program
	#DATA - holds byte for # in $t6		
	chkEnd:		lb $t6, poundChar
			beq $a0, $t6, end
			jr $ra
			
	#CHECKS the OPCode and branches to proper loop
	#chkInstruc:	

	
