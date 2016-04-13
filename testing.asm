.data
	char:	.byte	' '
	input:	.space 	300
	str:	.asciiz "#superswag"
	out:	.asciiz "theyre equal"
	ending:	.asciiz "program ending"

.text
	main:		
			la $a0, str
			li $a1, 3
			li $v0, 8
			syscall
			
			move $a0, $v0
			li $v0, 4
			syscall
			
			
			
	end:		la $a0, ending
			li $v0, 4
			syscall
			
			li $v0, 10
			syscall
