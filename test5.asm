#EE466
#Spring 2023
#Instructor: Dr. Chen Liu
#Project 1 Fibonacci Numbers
#Name 1: Sean Stacy
#ID: 0861689
#Major: Software Engineering
#email: stacysp@clarkson.edu
#Name 2: David Vicaro
#ID: 0935614
#Major: Software Engineering
#email: vicarodm@clarkson.edu
#Date: March 3, 2023

.data					 #Location where data is stored in memory
prompt: .asciiz "Enter the number of Fibonacci numbers to generate: "
prompt2: .asciiz "\nWould you like to continue? 1 = Continue or 0 = Exit\n"
output: .asciiz "\nYour Fibonacci numbers are: "
exception: .asciiz "\nInvalid input, can not be less than 1. Try again!\n"
exception2: .asciiz"\nInvalid input: choose 1 = Continue or 0 = Exit\n"
exitmessage: .asciiz"\nProgram terminated."

.text					  #Section containing instructions and program logic 
.globl main				  #Making instructions accessable to other files 

# Function to print an integer to console
print_int:
  li $v0, 1               #loads print integer system call
  syscall                 #prints integer
  jr $ra                  #jump to return address

# Function to print an integer to console, followed by a comma
print_int_space:
  li $v0, 1              #loads print integer system call
  syscall                #prints integer
  li $a0, ' '            #loads a space character into a0
  li $v0, 11             #loads print character system call
  syscall                #prints character
  jr $ra                 #jump to return address

# Function to print a string to console
print_string:
  li $v0, 4              #load print string system call
  syscall                #print string
  jr $ra                 #jump to return address

main:					 #Our main funciton definition
  # Prompt user for n
  la $a0, prompt         #loads prompt string into a0
  li $v0, 4              #loads print string system call
  syscall                #prints prompt

  # Read n from user input
  li $v0, 5              #loads a read integer system call
  syscall                #reads an integer from the user input
  move $t0, $v0          #moves the user input from register v0 to t0
  li $t1, 1              #loads imediate integer 1 into t1
  
  sub $t4, $t0, $t1      #subtracts t1 from t0 and assigns to t4. This is used to test if n > 1.
  beq $t0, $t1, case1    #checks if t0 = t1 (essentialy is n = 1), redirects to case1 if true
  bgez $t4, case2        #checks if t4 is greater than or equal to zero, redirects to case2 if true
  
  
  
  case1: 
	#code for if n == 1
	la $a0, exception      #loads address of exception string into a0
	jal print_string       #calls print_string function to print exception
	jal main               #redirects user back to main to enter an n value greater than 1.
	#li $v0, 10
	#syscall
	
	

  case2: #Case to confirm n > 1    
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
  move $a0, $t2							#moving the value of $t2 into $a0
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
	la $a0, prompt2                     #load the memory address of the string 'prompt2' into the $a0 register
    jal print_string						 
	li $v0, 5                           #load immediate integer 5 into register $v0 to read int from user
    syscall							#read in integer from $v0
	move $t0, $v0						#moving the value to $v0 into $t0
	#check if 0 or 1 or other			#work in progress
	beqz $t0, terminate					#check if $t5 is equal to zero - if so then call terminate function and end the program 
	li $t6, 1							#load immediate integer 1 into register $t6 
	beq $t0, $t6, main 					#check if contents of registers $t5 and $t6 are equal - if so then go to loop function
							#(comment not complete) We might want to pickup where left off from last number grabbed after the user hits continue 
	
 terminate:								#Our terminate function
    la $a0, exitmessage					#load address of exitmessage into register $a0
    jal print_string					#jump and link to the print_string funtion
    li $v0, 10 # Exit program			#load immediate integer 10 into register $v0 for syscall to read 
    syscall								#This is system call 4 which is for terminating execution of the program 
