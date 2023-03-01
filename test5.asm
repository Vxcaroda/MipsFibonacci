.data
prompt: .asciiz "Enter the number of Fibonacci numbers to generate: "
prompt2: .asciiz "\nWould you like to coninue? 1 = Continue or 0 = Exit\n"
output: .asciiz "\nYour Fibonacci numbers are: "
exception: .asciiz "\nInvalid input, can not be less than 1. Try again!\n"
exception2: .asciiz"\nInvalid input: choose 1 = Continue or 0 = Exit\n"

.text
.globl main

# Function to print an integer to console
print_int:
  li $v0, 1
  syscall
  jr $ra

# Function to print an integer to console, followed by a comma
print_int_comma:
  li $v0, 1
  syscall
  li $a0, ' '
  li $v0, 11
  syscall
  jr $ra

# Function to print a string to console
print_string:
  li $v0, 4
  syscall
  jr $ra

main:
  # Prompt user for n
  la $a0, prompt
  li $v0, 4
  syscall

  # Read n from user input
  li $v0, 5
  syscall
  move $t0, $v0
  li $t1, 1
  
  sub $t4, $t0, $t1
  beq $t0, $t1, case1
  bgez $t4, case2
  
  
  
  case1: 
	#code for if n == 1
	la $a0, exception
	jal print_string
	jal main
	#li $v0, 10
	#syscall
	
	

  case2: #Case for if n > 1    
	blez $t0, exception 			#check if $t0 is less than or equal to zero - if so print exception
	li $t1, 1						#load integer 1 into register t1
	bgt $t0, $t1, continue 			#check if $t0 is geater than t1 (1) - if so go to continue:

continue:								#Continue function  
  li $t1, 1 # First Fibonacci number	#Initialize Fibonacci sequence first two numbers loading immediate integer 1 into $t1 register 
  li $t2, 1 # Second Fibonacci number	#loading immediate integer 1 into $t2 register 
  la $a0, output						#load the memory address of the string 'output' into the $a0 register
  jal print_string						#jump and link to the print_string function 

  # Output first two Fibonacci numbers
  move $a0, $t1					#moving the value fo $t1 to $a0
  jal print_int_comma			#jump and link to the print_int_comma function 
  move $a0, $t2					#moving the value fo $t2 to $a0
  jal print_int_comma			#jump and link to the print_int_comma function 

  # Generate and output remaining Fibonacci numbers
  sub $t0, $t0, 2 				# Subtract 2 from the value at register $t0 and store result in $t0 
								# decrement the value of n by 2 because we already outputted first two Fib numbers outside the loop
  loop:
    beqz $t0, exit 				# Exit loop when n reaches 0
	bltz $t0, exit 				# Exit loop for when n < 0

    # Calculate next Fibonacci number
    add $t3, $t1, $t2
    move $t1, $t2
    move $t2, $t3

    # Output next Fibonacci number, without comma if it's the last number
    move $a0, $t3
    addi $t0, $t0, -1
    beqz $t0, print_int
    jal print_int_comma

    # Decrement n and repeat loop
    j loop

  exit:
	la $a0, prompt2
	li $v0, 4
	syscall 
	li $v0, 5
	move $t0, $v0
	#check if 0 or 1 or other
	beqz $t5,terminate
	li $t6, 1
	beq $t5, $t6, loop #Pickup where left off from last number grabbed 
	
 terminate:
    li $v0, 10 # Exit program
    syscall