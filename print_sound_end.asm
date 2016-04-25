# print string array onto console and output file
# 1 string per line displayed
# play sound
# end message

.data
	outFile:	.asciiz "output.txt"
	size:		.word 10
	array:		.asciiz "1000100011", "0101010101", "1010101010", "1000000000", 
				"0111111111", "0000000000", "1111111111", "0001000100", 
				"1001100101", "0000111111"
	newLine:	.asciiz "\n"
	endMessage:	.asciiz "\nTeam SuperSwag just finished their project! Goodbye! @^v^@"
	
.text
	
fileopen:
	# set values for file output
	lw	$s7, size		# store size of array
	li	$s1, 0			# set loop counter to 0
	li	$s2, 0			# set index to 0
	
	# open output file
    	li 	$v0, 13			# load syscall 13(open file) into $v0
    	la 	$a0, outFile		# laod address of outFile into $a0
    	li 	$a1, 1			# set address of input buffer to 1
    	li 	$a2, 0			# set max num of chr to be read to 0
   	syscall  			# file descriptor gets returned in $v0
   	move 	$s6, $v0		# move $v0 into $s6
   	
printLoop:
	# determine if should loop again
	bge	$s1, $s7, fileClose	# will go to printLoopEnd if $s1 = $s7
	
	# print string onto console
	la	$a0, array($s2)		# current index stored in $a0
	li	$v0, 4			# load string into $v0
	syscall				# print string to console
	
	# print new line onto console
	la	$a0, newLine		# new line stored in $a0
	li	$v0, 4			# load string into $v0
	syscall				# print a new line to console
	
	# write string to output file
	li	$v0, 15			# load syscall 15(write to file) into $v0
	move	$a0, $s6		# syscall 15 requires file descriptor in $a0
	la	$a1, array($s2)		# address of output buffer
	li	$a2, 11			# number of characters to write
	syscall				# print string to output file
	
	# write new line to output file
	li	$v0, 15			# load syscall 15(write to file) into $v0
	move	$a0, $s6		# syscall 15 requires file descriptor in $a0
	la	$a1, newLine		# address of output buffer
	li	$a2, 1			# number of characters to write
	syscall				# print new line to output file
	
	# increment registers/values for output
	addi	$s1, $s1, 1		# increment loop counter by 1
	addi	$s2, $s2, 11		# increment to next index of array
	
	# jump to printLoop
	j	printLoop
	
fileClose:
   	li 	$v0, 16  		# load syscall 16(close file) into $v0
   	move 	$a0, $s6		# move syscall 13(open file) to $a0
    	syscall				# execute close file
    	
playSound:
	# set values used for sound
	li	$s1, 0			# loop counter
	li	$s2, 15			# number of loops to execute
	li	$s3, 66			# starting value for pitch
	li	$s4, 24
	
playSoundLoop:
	# determine if should loop again
	bge	$s1, $s2, endProgram	# go to endProgram if $s1 == $s2

	move	$a0, $s3		# move pitch into $a0
	li	$a1, 400		# load duration into $a1
	move	$a2, $s4		# move instrument into $a2
	li	$a3, 120		# load volume into $a3
	li	$v0, 31			# load syscall 31(MIDI out) into $v0
	syscall				# play sound
	
	# sleep
	li	$a0, 100		# $a1 = 100 milliseconds
	li	$v0, 32			# load syscall 32(sleep) into $v0
	syscall				# sleep for 100 milliseconds

	# increment values for sound
	addi	$s1, $s1, 1		# increment loop counter by 1
	addi	$s3, $s3, 4		# increment pitch by 4
	addi	$s4, $s4, 1		# increment intrument by 1
	
	# jump to playSoundLoop
	j playSoundLoop

endProgram:
	# output ending message to console
	la	$a0, endMessage		# load address of endMessage into $a0
	li	$v0, 4			# load syscall 4(print string) into $v0
	syscall 			# print ending message onto console
	
	# exit program
	li 	$v0, 10			# load syscall 10(exit) ino $v0
	syscall				# end program


