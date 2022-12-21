.data
A: .word 4,4,4,5
.text  
        la   x25, A         # x25 = A[0]
        addi x24, x24, 4    # x24 = k = 4             
while:  slli x23, x22, 2    # x10 = i * 4        
        add  x10, x23, x25  # x10 = address of A[i]
        lw   x9 , 0(x10)    # x9  = A[i]
        bne  x9 , x24, exit # go to Exit if A[i] != k
        addi x22, x22, 1    # i = i + 1        
        j while             # next iteration    
exit:   mv a1, x22          # exit while loop
        li a0, 1            #
        ecall               # print x22=i