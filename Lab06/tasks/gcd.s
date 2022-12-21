.data
vara: .word 3528
varb: .word 5040
msg1: .asciz "\ngcd( "
msg2: .asciz " ) = "

.text
main:   la a0, vara
        la a1, varb
        jal gcd
        mv a2, a0

print:  li a0, 4        
        la a1, msg1
        ecall
        li a0, 1        
        lw a1, vara     
        ecall
        li a0, 11       
        li a1, ','               
        ecall 
        li a0, 1        
        lw a1, varb   
        ecall
        li a0, 4       
        la a1, msg2               
        ecall 
        li a0, 1      
        lw a1, 0(a2)               
        ecall
        li a0, 10       
        ecall

gcd:    lw t0, 0(a0)
        lw t1, 0(a1)
while:  beq t0, t1, exit
        bge t0, t1, if
        sub t1, t1, t0
        j while
if:     sub t0, t0, t1
	    j while
exit:   add a0, x0, t0
        ret