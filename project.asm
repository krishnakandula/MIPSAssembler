.data
#filename: .asciiz "C:\\Users\\krish\\OneDrive\\Documents\\School\\Sophomore\\Spring\\CS 3340\\MIPS Programs\\test.txt" #file name
filename: .asciiz "E:\\Documents\\OneDrive\\Documents\\School\\Sophomore\\Spring\\CS 3340\\Semester_Project\\test.txt" #file name
textSpace: .space 1050     #space to store strings to be read
spaceChar: .asciiz " "

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
		
		li $t1, 0		#holds counter
		
	loop:	beq $t1, 1050, end	#read til end of the file
		la $a0, textSpace	#load address of the string to be printed
		add $a0, $a0, $t1	#increment address
		lb $a0, ($a0)		#load character
		li $v0, 11		#syscall 11 - print character
		syscall
		
		addi $t1, $t1, 1	#increment counter
		j loop			#loop 	:-)
		
	end:	move $a0, $t0		#load file descriptor into a0
		li $v0, 16		#syscall 16 - close file
		syscall
		
		li $v0, 10		#syscall 10 - end program
		syscall
