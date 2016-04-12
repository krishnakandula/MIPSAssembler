.data
#filename: .asciiz "C:\\Users\\krish\\OneDrive\\Documents\\School\\Sophomore\\Spring\\CS 3340\\MIPS Programs\\test.txt" #file name
filename: .asciiz "test.txt" #file name
textSpace: .space 1050     #space to store strings to be read
equalStr:	.asciiz "\nThe characters are equal\n"
spaceChar: .byte ' '

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
		
		lb $t2, spaceChar	#contains the "space" character
		
		li $t1, 0		#holds counter
		
	loop:	beq $t1, 30, end	#read til end of the file
		la $a0, textSpace	#load address of the string to be printed
		add $a0, $a0, $t1	#increment address
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		
		move $s6, $t1		#move iteration # to $s6
		beq $a0, $t2, chkChar	#if the character is a space, branch
		
		
		addi $t1, $t1, 1	#increment counter
		j loop			#loop 	:-)
		
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
	chkChar:	jal prInt	#print iteration number
			j end
			
	