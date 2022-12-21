.data
msg1: .ascii "fib( "
msg2: .ascii " ) = "

.text
main:  li a0, 4
       addi s0, x0, 1            # s0 = 1
       add  s1, x0, a0           # s1 = a0
       jal  ra, fib
       mv a2, a0
       jal print
       li   a0, 10               # ecall code: stops running   (ID=10)
       ecall

fib:   ble  a0, s0, else         # If n<=1, goto else part
       addi sp, sp, -8           # Adjust stack pointer for 2 items
       sw   ra, 4(sp)            # Store the return address
       sw   a0, 0(sp)            # Store the argument
       addi a0, a0, -1           # a1 = n(a0) - 1
       jal  ra, fib              # call to calculate fib(n-1)
       
       mv   a0, s1               # Load the argument n frmo s1
       addi a0, a0, -2           # a1 = n(a0) - 2
       jal  ra, fib              # call to calculate fib(n-2)
       add  a0, t0, a0           # fib(n-1) + fib(n-2)
else:  ret


print:  li a0, 4        
        la a1, msg1
        ecall
        li a0, 1        
        li a1, 9     
        ecall
        li a0, 4       
        la a1, msg2               
        ecall 
        li a0, 1      
        lw a1, 0(a2)               
        ecall
        ret

