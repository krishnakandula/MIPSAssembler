# print string array onto console and output file
# 1 string per line displayed

.data
	outFile:	.asciiz "output.txt"
	size:		.word 10
	array:		.asciiz "1000100011", "0101010101", "1010101010", "1000000000", 
				"0111111111", "0000000000", "1111111111", "0001000100", 
				"1001100101", "0000111111"
	newLine:	.asciiz "\n"
	
.text

main:
	lw	$s7, size		# store size of array
	li	$s1, 0			# set loop counter to 0
	li	$s2, 0			# set index to 0
	la	$t6, array		# load address array into $t6
	
file_open:
	# open file
    	li 	$v0, 13			# load syscall 13(open file) into $v0
    	la 	$a0, outFile		# laod address of outFile into $a0
    	li 	$a1, 1			# set address of input buffer to 1
    	li 	$a2, 0			# set max num of chr to be read to 0
   	syscall  			# file descriptor gets returned in $v0
   	move 	$s6, $v0		# move $v0 into $s6
   	
printLoop:
	bge	$s1, $s7, printLoopEnd	# will go to printLoopEnd if $s1 = $s7
	
	# print string onto console
	la	$a0, array($s2)		# current index stored in $a0
	li	$v0, 4			# load string into $v0
	syscall				# print string to console
	
	# print new line onto console
	la	$a0, newLine		# new line stored in $a0
	li	$v0, 4			# load string into $v0
	syscall				# print a new line to console
	
	# write string to output file
	li	$v0, 15			# load syscall 15(write to file) ino $v0
	move	$a0, $s6		# syscall 15 requires file descriptor in $a0
	la	$a1, array($s2)		# address of output buffer
	li	$a2, 11			# number of characters to write
	syscall				# print string to output file
	
	# write new line to output file
	li	$v0, 15			# load syscall 15(write to file) into $v0
	move	$a0, $s6		# syscall 15 requires file descriptor in $a0
	la	$a1, newLine		# address of output buffer
	li	$a2, 1			# number of characters to write
	syscall
	
	addi	$s1, $s1, 1		# increment loop counter by 1
	addi	$s2, $s2, 11		# increment to next index of array
	j	printLoop		# jump back to printLoop
	
printLoopEnd:


file_close:
   	li 	$v0, 16  		# load syscall 16(close file) into $v0
   	move 	$a0, $s6		# move syscall 13(open file) to $a0
    	syscall				# execute close file
    
exit:
	li $v0, 10			# load syscall 10(exit) into $v0
	syscall				# end program


