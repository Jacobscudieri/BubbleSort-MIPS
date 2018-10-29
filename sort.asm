# Title: Project One				Filename: sort.asm
# Author: Jacob Scudieri			Date: 10-15-18
# Description: Take 10 integer inputs from user, sorts in descending order, prints them,
# reverses order of array, prints again.
# Input: 10 integers
# Output: Sorted integers
####################### Data Segment ############################
.data

input: .space 40				# Reserves space for 10 integers	
prompt: .asciiz "Enter ten integers: \n"
colon: .asciiz " : "
output: .asciiz "Your sorted input: "
output2: .asciiz "Your input in reverse order: "
newLine: .asciiz "\n"
space: .asciiz ", "

###################### Code Segment #############################
.text	

.globl main

#################################################################
# Main function.
#################################################################
main:

	li $t0, 40			# Size of ten int array
	li $t4, 90			# Loop counter max
	addi $t9, $t9, 1		# Input counter
	
	li $v0, 4
	la $a0, prompt
	syscall
	
#################################################################
# Gets user input of 10 integers.
#################################################################
userInput:
	
	beq $t1, $t0, reinitialize	# If ($t1 == $t0); branch to reinitialize registers
	
	move $a0, $t9			# Print the input counter to keep track of # of ints entered
	li $v0, 1
	syscall
	
	li $v0, 4			# Prints " : "
	la $a0, colon
	syscall
	
	li $v0, 5			# Gets user integer input, moves to $t2
	syscall
	move $t2, $v0
	
	sw $t2, input($t1)		# Stores user input in first space in array
	addi $t1, $t1, 4		# Moves 4 bytes
	
	addi $t9, $t9, 1		# Increases input counter
	
	j userInput

#################################################################
# Reinitializes registers for more usage.
#################################################################	
reinitialize:
	
	move $t1, $zero			# Hold pos of input[x]
	move $t2, $zero
	addi $t2, $t2, 4		# Hold pos of input[x + 1]
	move $s0, $zero
	addi $s0, $s0, 1		# Condition check: if($t7 == 1); branch to swap values

#################################################################
# Sorts the array.
#################################################################
sort:

	beq $t3, $t4, beforePrint 	# if(loopCounter == 90), branch to beforePrint
	beq $t2, $t0, reinitialize	# if ($t2 == end of array); branch to reinitialize registers
	
	lw $t5, input($t1)		# Load value in input array at addr $t1 into $t5
	lw $t6, input($t2)		# Load value in input array at addr one further ($t2) into $t6
	
	addi $t3, $t3, 1		# Increments loop counter
	
	slt $t7, $t5, $t6		# Set less than if $t5 is less than $t6, $t7 would get 1
	beq $t7, $s0, swap		# if($t7 == 1); swap the values of the two array pos
	
	# If the condition is false
	addi $t1, $t1, 4		# Moves to next 4 bytes (x)
	addi $t2, $t2, 4		# Moves to next 4 bytes (x + 1)
	
	j sort				# Go back to sort

#################################################################
# Swaps the values if the condition in sort is met.
#################################################################
swap:

	# Swaps values
	sw $t5, input($t2)		# Puts value in $t5 at next pos in array
	sw $t6, input($t1)		# Puts value in $t6 at prior pos in array
	
	addi $t1, $t1, 4		# Moves to next 4 bytes (x)
	addi $t2, $t2, 4		# Moves to next 4 bytes (x + 1)

	j sort				# Go back to sort
	
#################################################################
# Reinitializes registers for more usage before printing.
#################################################################
beforePrint:

	move $t1, $zero
	move $t2, $zero
	move $t4, $zero
	move $t5, $zero
	move $t6, $zero
	move $t7, $zero

#################################################################
# Displays message for descending order array.
#################################################################	
readyForPrint:
	
	li $v0, 4			# Displays our message for sorted input
	la $a0, output
	syscall
	
#################################################################
# Prints the sorted array.
#################################################################
print:

	beq $t4, $t0, readyForReverse	# if($t4 == end of array); branch to reverse the order
	lw $t5, input($t4)
	addi $t4, $t4, 4		# Increment 4 bytes
	
	move $a0, $t5			# Puts input[$t5] into $a0 and prints it
	li $v0, 1
	syscall
	
	beq $t4, $t0, print		# Check again after 4 byte increment if($t4 == end of array); go back to print
	
	li $v0, 4			# Prints a space separator
	la $a0, space
	syscall
	
	j print				# Go back to print
	
#################################################################
# Reinitializes registers for use.
#################################################################
readyForReverse:

	move $t4, $zero
	move $t5, $zero
	
#################################################################
# Reverses order of array.
#################################################################
reverse:
	
	beq $t4, $t0, readyToPrint	# if(startPos == endPos); branch to exit
	
	lw $t5, input($t0)		# Loads value at end of array in $t5
	lw $t6, input($t4)		# Loads value at beginning of array in $t6
	
	sw $t5, input($t4)		# Stores $t5 at beginning of array
	sw $t6, input($t0)		# Stores $t6 at end of array
	
	addi $t4, $t4, 4		# Increments beginning of array 4 bytes
	addi $t0, $t0, -4		# Decrements end of array 4 bytes
	
	j reverse			# Go back to reverse

#################################################################
# Displays message for ascending order display.
#################################################################
readyToPrint:
	
	move $t0, $zero
	addi $t0, $t0, 44		# Size of ten int array
	move $t4, $zero
	addi $t4, $t4, 4
	move $t5, $zero
	move $t6, $zero
	
	li $v0, 4			# Prints newLine character
	la $a0, newLine
	syscall
	
	li $v0, 4			# Prints message for reverse order output
	la $a0, output2
	syscall

#################################################################
# Prints reversed array.
#################################################################
printReverse:
	
	beq $t4, $t0, exit		# if($t4 == end of array); branch to exit
	lw $t5, input($t4)
	addi $t4, $t4, 4		# Increment 4 bytes
	
	move $a0, $t5			# Puts input[$t5] into $a0 and prints it
	li $v0, 1
	syscall
	
	beq $t4, $t0, printReverse	# Check again after 4 byte increment if($t4 == end of array); go back to printReverse
	
	li $v0, 4			# Prints a space separator
	la $a0, space
	syscall
	
	j printReverse			# Go back to printReverse
	
#################################################################
# Exits the program.
#################################################################	
exit:

	li $v0, 10			
	syscall
