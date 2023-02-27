.data
prompt: .asciiz "Enter the number of Fibonacci numbers to generate: "
output: .asciiz "\nThe first %d Fibonacci numbers are: "

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
  li $a0, ','
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

  # Initialize Fibonacci sequence
  li $t1, 0 # First Fibonacci number
  li $t2, 1 # Second Fibonacci number
  la $a0, output
  jal print_string

  # Output first two Fibonacci numbers
  move $a0, $t1
  jal print_int
  li $a0, ','
  li $v0, 11
  syscall
  move $a0, $t2
  jal print_int

  # Generate and output remaining Fibonacci numbers
  sub $t0, $t0, 2 # Decrement n by 2 (already outputted first two numbers)
  loop:
    beqz $t0, exit # Exit loop when n reaches 0

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
    li $v0, 10 # Exit program
    syscall
