.data
arr: .word 240, 100, 243, 40

.text

main:   la   x10, arr         # x10 = &arr
        li   x11, 4           # x11 = n = 4
        jal  x1,  sort
        li a0, 10             # ecall code: stops running   (ID=10)
        ecall
                              # Check the data memory to see if the array is sorted
        
swap:   slli x6 , x11, 2      # reg x6 = k*4
        add  x6 , x10, x6     # reg x6 = v+(k*4)
        lw   x5 , 0(x6)       # reg x5 (temp) = v[k]
        lw   x7 , 4(x6)       # reg x7 = v[k+1]
        sw   x7 , 0(x6)       # v[k]   = reg x7
        sw   x5 , 4(x6)       # v[k+1] = reg x5 (temp)
        ret                   # return to calling routine

sort:   addi sp , sp -20      # make room on stack for 5 registers
        sw   x1 , 16(sp)      # save return address on stack
        sw   x22, 12(sp)      # save x22 on stack
        sw   x21,  8(sp)      # save x21 on stack
        sw   x20,  4(sp)      # save x20 on stack
        sw   x19,  0(sp)      # save x19 on stack
        mv   x21, x10         # copy x10 into x21
        mv   x22, x11         # copy x11 into x22
        li   x19, 0           # i = 0
for_i:  bge  x19, x22, exit_i # go to exit_i if i>=n  
        addi x20, x19, -1     # j = i-1
for_j:  blt  x20, x0 , exit_j # go to exit_j if j<0
        slli x5 , x20, 2      # x5 = j*4
        add  x5 , x21, x5     # x5 = v+j*4
        lw   x6 ,  0(x5)      # x6 = v[j]
        lw   x7 ,  4(x5)      # x7 = v[j+1]
        ble  x6 , x7 , exit_j # go to exit_j if x6<x7
        mv   x10, x21         # first swap parameter is v
        mv   x11, x20         # second swap parameter is j
        jal  x1 , swap        # call swap
        addi x20, x20, -1     # j for inner loop forj
        j    for_j            # go to for_j
exit_j: addi x19, x19, 1      # i += 1
        j    for_i            # go to for_i
exit_i: lw   x19,  0(sp)      # restore x19 from stack
        lw   x20,  4(sp)      # restore x20 from stack
        lw   x21,  8(sp)      # restore x21 from stack
        lw   x22, 12(sp)      # restore x22 from stack
        lw   x1 , 16(sp)      # restore return address from stack
        addi sp , sp , 20     # restore stack pointer
        jr   x1               # return to calling routine        