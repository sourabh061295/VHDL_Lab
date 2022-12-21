# Test the RISC-V processorinstructions: add, sub, and, or, slt, addi, lw, sw, beq, jal
# If successful, it should write the value 71 to address 108 = 96+12
.data
dummy: 0

.text
#       RISC-V Assembly         Description                Address     
main:   addi a2, x0, 5          # initialize a2 = 5        0x00     
        addi a3, x0, 12         # initialize a3 = 12       0x04     
        addi a7, x0, 3          # initialize a7 = 3        0x08     
        or   a4, a7, a2         # a4 = (3 OR 5) = 7        0x0C     
        and  a5, a3, a4         # a5 = (12 AND 7) = 4      0x10     
        add  a5, a5, a4         # a5 = 4 + 7 = 11          0x14     
        beq  a5, a7, end        # shouldn't be taken       0x18     
        slt  a4, a3, a4         # a4 = (12 < 7) = 0        0x1C     
        beq  a4, x0, around     # should be taken          0x20     
        addi a5, x0, 0          # shouldn't happen         0x24     
around: slt  a4, a7, a2         # a4 = (3 < 5) = 1         0x28     
        add  a7, a4, a5         # a7 = 1 + 11 = 12         0x2C     
        sub  a7, a7, a2         # a7 = 12 - 5 = 7          0x30     
        sw   a7, 0x60(a3)       # mem[0x60+12] = 7         0x34     
        lw   a2, 96(a3)         # a2 = mem[96+12] = 7      0x38     
        jal  a3, end            # jump to end, a3 = pc+4   0x3C     
        addi a2, x0, 1          # shouldn't happen         0x40     
end:    add  a2, a2, a3         # a2 = 7 + 0x40 = 0x47     0x44     
        sw   a2, 0x64(x0)       # write mem[0x64] = 0x47   0x48     
        li   a7, 34             # print hex                0x4C
        mv   a0, a2             # move result to a0        0x50 
        ecall                   # print a2 = (0x47 = 71)   0x54
        li   a7, 10             # ecall code: exit         0x58
        ecall                   # exit                     0x5C
