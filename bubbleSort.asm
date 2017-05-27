# Joshua Lambert
# CSCI 3202
# Architecture II
# 02/22/2017
# Bubble Sort

.data	
	list: 		.word 3, 0, 1, 2, 6, -2, 4, 7, 3, 7, 32, 56, 58, 74, 21, 10, 36, 2, 8, -5
	space:		.asciiz " "
	newLine:	.asciiz "\n"
	afterSort:	.asciiz "After Sort"
	beforeSort:	.asciiz "Before Sort"
	credit:		.asciiz "Joshua Lambert"
.text

main:		

		li $v0, 4
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
		
print:		
		addi $t0, $zero, 0		# Initialize counter to 0
		addi $t2, $zero, 0		# base address
		addi $sp, $sp, -12 		# Make room for $ra, $a1, $a0
		sw $a1, 8($sp)			# Save array size to stack		
		sw $a0, 4($sp)			# Save array address to stack		
		sw $ra, 0($sp)			# Save $ra onto the stack
		addi $s3, $a1, 0		# Store $a1 in a local temp register
		li $v0, 4
		la $a0, newLine			# Prints a new line to start
		syscall
		
		
	loop:	beq $t0, 20, exitPrint		# branch equal to array size
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
exitPrint:	
		
		lw $ra, 0($sp)		# Restore address return address from stack
		lw $a0, 4($sp)		# Restore argument values
		lw $a1, 8($sp)		# Restore argument value
		addi $sp, $sp, 12	# Restore Stack pointer
		jr $ra			# jump back
		
swap: 		sll  $t1, $a1, 2	# $t1 = k * 4
		add $t1, $a0, $t1	# $t1 = v+(k*4)
					# (address of v[k])
		lw $t0, 0($t1)		# $t0 (temp) = v[k]
		lw $t2, 4($t1)		# $t2 = v[k + 1]
		sw $t2, 0($t1)		# v[k] = $t2 (v[k+1])
		sw $t0, 4($t1)		# v[k+1] = $t0 (temp)
		jr $ra			# return to calling routine

sort:		addi $sp, $sp, -20	#make room on stack for 5 registers
		sw $ra, 16($sp)		#save $ra on stack
		sw $s3, 12($sp)		#save $s3 on stack
		sw $s2, 8($sp)		#save $s2 on stack
		sw $s1, 4($sp)		#save $s1 on the stack
		sw $s0, 0($sp)		#save $s0 on stack
		#----------------------------------------------------
		#Procedure Body
		#----------------------------------------------------
		move $s2, $a0		# save $a0   to $s0 
		move $s3, $a1		# save $a1 into $s3
		move $s0, $zero		# i = 0
for1tst: 	slt $t0, $s0, $s3	# $t0 = 0 if $s0 >= $s3
		beq $t0, $zero, exit1	# go to exit1 if $s0 >= $s3
		addi $s1, $s0, -1 	# j = i = 1
for2tst:	slti $t0, $s1, 0	# $t0 =1 if $s1 < 0 
		bne $t0, $zero, exit2	# got to exit2 if $s1 < 0
		sll $t1, $s1, 2		# $t1 = k
		add  $t2, $s2, $t1	# $t2 = v + (j * 4)
		lw  $t3, 0($t2)		# $t3 = v[j]
		lw  $t4, 4($t2)		# $t4 = v[j + 1]
		slt $t0, $t4, $t3	# $t0 = 0 if $t4 >= $t3
		beq $t0, $zero, exit2	# goto exit 2 if $t4 >= $t3
		move $a0, $s2		# 1st param of swap is v (old $a0)
		move $a1, $s1		# 2nd param of swap is j
		jal swap		# call swap procedure
		addi $s1, $s1, -1	# j -= 1
		j 	for2tst		# jump to test of inner loop
exit2:		addi $s0, $s0, 1	# i += 1
		j	for1tst		#jump to test of outer loop
		#----------------------------------------------------
exit1: 		lw $s0, 0($sp)		# restore $s0 from stack
		lw $s1, 4($sp)		# restore $s1 from stack
		lw $s2, 8($sp)		# restore $s2 from stack 	
		lw $ra, 16($sp)		# restore stack pointer
		addi $sp, $sp, 20	# restore stack pointer
		jr $ra			# return to calling routine
