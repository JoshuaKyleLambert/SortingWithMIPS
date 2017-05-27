 # Joshua Lambert
# CSCI 3202
# Architecture II
# 03/14/2017
# Bubble Sort

.data	
	list: 		.word 3, 0, 1, 2, 6, -2, 4, -7, 3, 7, 32, 108, 58, -74, 21, 10, 360, 2, 8, -5
	space:		.asciiz " "
	newLine:	.asciiz "\n"
	afterSort:	.asciiz "After Sort"
	beforeSort:	.asciiz "Before Sort"
	credit:		.asciiz "Joshua Lambert"
.text

main:		li $v0, 4
		la $a0, beforeSort		# Prints before sort
		syscall
		
		addi $a1, $zero, 20		# array size    argument
		la $a0, list			# array address argument for sort and print
		
		jal print			# print array before sort
		jal sort			# jump and link to sort procedure
		jal print			# jump and link to print loop
		
		li $v0, 4
		la $a0, newLine			# Prints newLine
		syscall
		la $a0, afterSort		# Prints After Sort
		syscall
		la $a0, newLine			# Prints two new lines
		syscall				
		syscall
		la $a0, credit			# Prints Credits
		syscall
		 
		li $v0, 10			# Exit nicely
		syscall
		
print:		addi $t0, $zero, 0		# Initialize counter to 0
		addi $t2, $zero, 0		# base address
		addi $sp, $sp, -12 		# Make room for $ra, $a1, $a0
		sw $a1, 8($sp)			# Save array size to stack		
		sw $a0, 4($sp)			# Save array address to stack		
		sw $ra, 0($sp)			# Save $ra onto the stack
		addi $s3, $a1, 0		# Store $a1 in a local temp register
		li $v0, 4
		la $a0, newLine			# Prints a new line to start
		syscall
loop:	        beq $t0, 20, exitPrint		# branch equal to array size
		lw  $t1, list($t2)		# Load the $t2 element into $t1
		li $v0, 1
		move $a0, $t1		# Prints the current number.
		syscall	
		li $v0, 4		# Instruction to print out whats at $a0
		la $a0, space		# prints a space between entries
		syscall			# Execute
		addi $t0, $t0, 1	# increase the counter
		addi $t2, $t2, 4	# next array element
		jal loop		# go through the loop again
exitPrint:	lw $ra, 0($sp)		# Restore address return address from stack
		lw $a0, 4($sp)		# Restore argument values
		lw $a1, 8($sp)		# Restore argument value
		addi $sp, $sp, 12	# Restore Stack pointer
		jr $ra			# jump back
		# End Print procedure -------------------------------------------
		# Begin Sort Procedure-------------------------------------------
sort:		addi $sp, $sp, -20	#make room on stack for 5 registers
		sw $ra, 16($sp)		#save $ra on stack
		sw $s3, 12($sp)		#save $s3 on stack
		sw $s2, 8($sp)		#save $s2 on stack
		sw $s1, 4($sp)		#save $s1 on the stack
		sw $s0, 0($sp)		#save $s0 on stack
		#----------------------------------------------------
		#Procedure Body
		#----------------------------------------------------
 		move $s0, $a0		# j = &array[0] -  Pointer
		sll  $s1, $a1, 2        # size * 4
		add  $s3, $s0, $s1	# &array[size]   i.e. (size * 4) + j
		addi $s3, $s3, -4	# array[size] - 1  i.e  $s3 = array.length - 1  
		addi $t0, $zero, 1	# SwapOccurred set to True
while: 		beq  $t0, $zero, exitWh	# While ( swapOccurred != 0 ) i.e. true = 1
		move $t0, $zero		# SwapOccurred set to False
for:		slt  $t1, $s0, $s3	# if j < &array[size] is true $t1 = true = 1
		beq  $t1, $zero exitFor	# if j >= &array[size] exit loop i.e. $t1 = false = 0
		lw   $t3, 0($s0)	# Load array[j] into $t3
		lw   $t4, 4($s0)	# Load array[j + 1] into $t4
		slt  $t2, $t3, $t4	# $t2 = ( array[j] < array[j + 1])  true = 1
		beq  $t2, $zero exitIf	# if false skip to end of the loop
		sw   $t3, 4($s0)	# swap
		sw   $t4, 0($s0)	# swap
		addi $t0, $zero, 1	# SwapOccurred = 1 = true 
		addi $s0, $s0, 4	# j = j + 1 increase the pointer by one word						
		j    for		# jump to test of inner loop
exitIf:		addi $s0, $s0, 4	# increase pointer by one word before jump
		j    for		#jump to test of inner
exitFor:	add  $s0, $a0, $zero	# reset for loop i.e   j = &array[0]
		j    while		# jump to while when condition fails.
		#----------------------------------------------------
exitWh: 	lw $s0, 0($sp)		# restore $s0 from stack
		lw $s1, 4($sp)		# restore $s1 from stack
		lw $s2, 8($sp)		# restore $s2 from stack 	
		lw $ra, 16($sp)		# restore stack pointer
		addi $sp, $sp, 20	# restore stack pointer
		jr $ra			# return to calling routine
