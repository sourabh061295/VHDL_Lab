.data
arr: .word 10, 7, 8, 9, 1, 5

.text
main:   la   a0, arr             # x10 = &arr
        li   a1, 6               # x11 = n = 6
        jal  insort              # call function insertion sort
        jal  print               # call function print
        li   a0, 10              # ecall code: stops running   (ID=10)
        ecall

insort: li    x18, 1             # i(x18) = 1
for_i:  bge   x18, a1, exit_i    # if i(x18) >= 6(a1), exit for loop
        slli  x19, x18, 2        # i_index(x19) = i*4
        add   x19, a0, x19       # i_index(x19) = x19 + base address(a0)
        lw    x20, 0(x19)        # key(x20) = value at i_index(x19)
        addi  x21, x18, -1       # j(x21) = i(x18) - 1
while_j:slli  x22, x21, 2        # j_index(x22) = j*4
        add   x22, a0, x22       # j_index(x22) = x22 + base address(a0)
        lw    x23, 0(x22)        # arr(j)(x23) = value at j_index(x22)
	blt   x21, x0, exit_j    # if j(x21) < 0, exit while loop
        bge   x20, x23, exit_j   # if key >= arr(j)
        sw    x23, 4(x22)        # arr(j + 1)(x22 + 4) = arr(j)
        addi  x21, x21, -1       # j(x21) = j(x21) - 1
        j     while_j
exit_j: sw    x20, 4(x22)        # arr(j + 1)(x22 + 4) = key
        addi  x18, x18, 1
        j     for_i
exit_i: ret   

print:  lw t0, 0(a0)
        li a0, 1
        mv a1, t0
        ecall
        lw t0, 4(a0)
        li a0, 1
        mv a1, t0
        ecall
        lw t0, 8(a0)
        li a0, 1
        mv a1, t0
        ecall
        lw t0, 12(a0)
        li a0, 1
        mv a1, t0
        ecall
        lw t0, 16(a0)
        li a0, 1
        mv a1, t0
        ecall
        lw t0, 20(a0)
        li a0, 1
        mv a1, t0
        ecall
        ret


  
