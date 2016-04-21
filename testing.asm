.data
animals:    
a0: .asciiz    "bear"
a1: .asciiz    "tiger"
a2: .asciiz    "gorilla"
a3: .asciiz    "horse"
a4: .asciiz    "dog"

# addrs is a list of the starting addresses for each of the strings
addrs: 
  .word a0
  .word a1
  .word a2
  .word a3
  .word a4
  .word 0
 
array:	.asciiz "test" 
	.asciiz "poop"
  
  .text 
  	la $a0, animals
  	addi $a0, $a0, 5
  	li $v0, 4
  	syscall
  	
  	li $v0, 10
  	syscall