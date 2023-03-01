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
print_int_space:
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
	blez $t0, exception 				#check if $t0 is less than or equal to zero - if so print exception
	li $t1, 1							#load integer 1 into register t1
	bgt $t0, $t1, continue 				#check if $t0 is geater than t1 (1) - if so go to continue:

continue:								#Continue function definition
  li $t1, 1 # First Fibonacci number	#Initialize Fibonacci sequence first two numbers loading immediate integer 1 into $t1 register 
  li $t2, 1 # Second Fibonacci number	#loading immediate integer 1 into $t2 register 
  la $a0, output						#load the memory address of the string 'output' into the $a0 register
  jal print_string						#jump and link to the print_string function 

  # Output first two Fibonacci numbers
  move $a0, $t1							#moving the value of $t1 into $a0
  jal print_int_space					#jump and link to the print_int_space function 
  move $a0, $t2							#moving the value of $a0 into $t2
  jal print_int_space					#jump and link to the print_int_space function 

  # Generate and output remaining Fibonacci numbers
  sub $t0, $t0, 2 						# Subtract 2 from the value at register $t0 and store result in $t0 
										# decrement the value of n by 2 because we already outputted first two Fib numbers outside the loop
  loop:									# Our loop function definition 
    beqz $t0, exit 						# check if register $t0 is equal to zero - if so then Exit loop
	bltz $t0, exit 						# check if register $t0 is less than zero - if so then Exit loop

    # Calculate next Fibonacci number
    add $t3, $t1, $t2					#add the numbers at registers $t1 and $t2 and set register $t3 equal to the sum
    move $t1, $t2						#moving the value of $t2 into $t1
    move $t2, $t3						#moving the value of $t3 into $t2

    # Output next Fibonacci number, without comma if it's the last number
    move $a0, $t3						#moving the value to $t3 into $a0	
	sub $t0, $t0, 1						#subtracting 1 from the value stored at $t0, and setting $t0 equal to the difference
    beqz $t0, print_int					#check if $t0 is equal to zero - if so then call print_int_space function 
    jal print_int_space					#jump and link to the print_int_space function 
    j loop								#jump to the loop function to repeat the loop 

  exit:									#Exit function definition 
	la $a0, prompt2						#load the memory address of the string 'prompt2' into the $a0 register 
	li $v0, 4							#load immediate integer 4 into register $v0 for syscall to read 
	syscall 							#This is system call 4 which is for printing strings 
	li $v0, 5							#load immediate integer 5 into register $v0
	move $t0, $v0						#moving the value to $v0 into $t0
	#check if 0 or 1 or other			#work in progress
	beqz $t5,terminate					#check if $t5 is equal to zero - if so then call terminatefunction and end the program 
	li $t6, 1							#load immediate integer 1 into register $t6 
	beq $t5, $t6, loop 					#check if contents of registers $t5 and $t6 are equal - if so then go to loop function
							#(comment not complete) We might want to pickup where left off from last number grabbed after the user hits continue 
	
 terminate:								#Our terminate function
    li $v0, 10 # Exit program			#load immediate integer 10 into register $v0 for syscall to read 
    syscall								#This is system call 4 which is for terminating execution of the program 