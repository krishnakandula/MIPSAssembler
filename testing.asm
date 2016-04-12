.data
	char:	.byte	' '
	input:	.space 	300
	str:	.asciiz "#superswag"
	out:	.asciiz "theyre equal"
	ending:	.asciiz "program ending"

.text
	main:		
			lb $t1, char
			li $v0, 12
			syscall
			move $t2, $v0
			bne $t1, $t2, end
			
			li $v0, 4
			la $a0, out
			syscall
			
	end:		la $a0, ending
			li $v0, 4
			syscall
			
			li $v0, 10
			syscall
