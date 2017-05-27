# Joshua Lambert
# CSCI 3202
# Architecture II
# 04/18/2017
# Quick Sort

.data	
	list: 		.word -3, 68, 10, 2, 6, 68, 50, -568, 25, 574, -12, 5, 65
	space:		.asciiz " "
	newLine:	.asciiz "\n"
	afterSort:	.asciiz "After Sort"
	beforeSort:	.asciiz "Before Sort"
	credit:		.asciiz "Joshua Lambert"
.text

main:		li $v0, 4
		la $a0, beforeSort	# Prints before sort label
		syscall
		# Print the list before sorting--------------------------
		addi $a1, $zero, 13	# array size in $a1
		la $a0, list		# array address in $a0	
		jal print		# print array before sort
		# Sort the list-------------------------------------------
		addi $a1, $zero, 0	# left   index 0  first element
		addi $a2, $zero, 12	# right  index 12 last element (length - 1)
		la $a0, list
		jal sort		# jump and link to sort procedure
		# Reload args for print and print sorted list------------
		addi $a1, $zero, 13	# array size in $a1
		la $a0, list		# array address in $a0					
		jal print		# jump and link to print loop
		# Finish printing name and spaces and exit---------------
		li $v0, 4
		la $a0, newLine		# Prints newLine
		syscall
		la $a0, afterSort	# Prints After Sort
		syscall
		la $a0, newLine		# Prints two new lines
		syscall				
		syscall
		la $a0, credit		# Prints Credits
		syscall
		li $v0, 10		# Exit nicely
		syscall
		#Print Procedure --------------------------------------------------
print:		addi $t0, $zero, 0	# Initialize counter to 0
		addi $t2, $zero, 0	# base address
		addi $sp, $sp, -16 	# Make room for $ra, $a1, $a0
		sw $s1, 12($sp)
		sw $a1, 8($sp)		# Save array size to stack		
		sw $a0, 4($sp)		# Save array address to stack		
		sw $ra, 0($sp)		# Save $ra onto the stack
		addi $s3, $a1, 0	# Store $a1 in a local temp register
		move $s1, $a0
		li $v0, 4
		la $a0, newLine		# Prints a new line to start
		syscall
loop:	        beq $t0, $a1, exitPrint	# branch equal to array size
		lw  $t1, list($t2)	# Load the $t2 element into $t1
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
		lw $s1, 12($sp)
		addi $sp, $sp, 16	# Restore Stack pointer
		jr $ra			# jump back
		# End Print procedure -------------------------------------------
		# Begin Sort Procedure -------------------------------------------
sort:		addi $sp, $sp, -32	# make room on stack for 7 regs
		sw $s3, 28($sp)
		sw $ra, 24($sp)		# save $ra return address on stack
		sw $a2, 20($sp)		# save arg 2 on stack
		sw $a1, 16($sp)		# save arg 1 on stack
		sw $a0, 12($sp)		# save arg 0 on stack
		sw $s2, 8($sp)		# save $s2 on stack
		sw $s1, 4($sp)		# save $s1 on the stack
		sw $s0, 0($sp)		# save $s0 on stack
		#End Stack stuff ------------------------------------------------
		#setup variables and calculate addresses load pivot
 		add  $s0, $zero, $a0	# arr = arr[0]
		add  $s1, $zero, $a1    # i = left
		add  $s2, $zero, $a2    # j = right
		add  $t0, $a2, $a1	# left + right
		srl  $t0, $t0, 1	# (left + right) / 2
		sll  $t0, $t0, 2	# calculate the address for the pivot element
		add  $t0, $a0, $t0	# adds the array address to array element index
		lw   $t1, 0($t0)	# $t1 = pivot load the pivot element value
		#begin the partitioning section
while1:         sle $t0 , $s1, $s2	# (i <= j) if true $t0 = 1
		beqz $t0, recurse	# skip to the recursive calls if false
		sll $t3, $s1, 2		# index * 4 word addressing
		add $t3, $s0, $t3	# $t3 element address   ie  pointer
		lw $t2, 0($t3)		# $t2 holds contents of $t3
		sll $t4, $s2, 2		# index * 4 word addressing
		add $t4, $s0, $t4	# $t3 element address   ie  pointer
		lw $t5, 0($t4)		# $t5 holds contents of $t3
		
while2:		slt $t0, $t2,$t1		
		beqz $t0, while3	# (arr[i] < pivot)
		addi $t3, $t3, 4	# increment pointer
		addi $s1, $s1, 1	# increment index
		lw $t2, 0($t3)		# load the next element
		j while2		# loop
while3:		sgt $t0, $t5,$t1	# (arr[j] < pivot)	
		beqz $t0, if1		# skip to if this not true
		addi $t4, $t4, -4	# increment pointer
		addi $s2, $s2, -1	# increment index
		lw $t5, 0($t4)		# load the next element
		j while3		# loop
		
if1:		sle $t0, $s1, $s2       # ( i <= j )	
		beqz $t0, while1	# jump to beginning of outter loop		 
		sw $t2 0($t4)		# swap the values
		sw $t5 0($t3)		# swap values
		addi $t3, $t3, 4	# increment pointer for i
		addi $s1, $s1, 1	# increment index
		addi $t4, $t4, -4	# decrement pointer for j
		addi $s2, $s2, -1	# decrement index		
		j while1		# back to the top of the outter loop

recurse:	slt $t0, $a1, $s2	# ( left < j )
		beqz $t0, if2		# skip first call branch to second if
		add $s3, $zero, $a2	# save right argument for next call
		add $a2, $zero, $s2	# right = j		
		bnez $t0, jalsort1	# branch to jump and link
jalsort1:	jal sort		# quickSort call
		add $a2, $s3, $zero	# put back the $a2 argument
if2:		slt $t0, $s1, $a2  	# ( i < right)
		beqz $t0, exitWh	# skip to the end of procedure
		add $s5, $zero, $a1	# place proper arguments for sort
		add $a1, $zero, $s1	# restore argument i  
		bnez $t0, jalsort2	# branch to jump and link 
jalsort2:	jal sort		# jump and link last cal
		add  $a1, $s5, $zero	# restore the left argument
		#----------------------------------------------------
exitWh: 	lw $s0, 0($sp)		# restore $s0 from stack
		lw $s1, 4($sp)		# restore $s1 from stack
		lw $s2, 8($sp)		# restore $s2 from stack 
		lw $a0, 12($sp)		# restore
		lw $a1, 16($sp) 	# restore
		lw $a2, 20($sp)
		lw $ra, 24($sp)		# restore stack pointer
		lw $s3, 28($sp)
		addi $sp, $sp, 32	# restore stack pointer
		jr $ra			# return to calling routine