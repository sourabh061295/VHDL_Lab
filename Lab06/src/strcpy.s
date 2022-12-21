.data
.globl str1
.globl str2
str1: .asciiz  "Hello World"
str2: .asciiz  "           " 

.text
    la   a0, str1              # load address of str1
    la   a1, str2              # load address of str2
    jal  strcpy                # strcpy(&str1, &str2)
    j    exit
strcpy:                        
    addi sp , sp   , -4        # adjust stack for 1 word
    sw   x19, 0(sp)            # push x19
    add  x19, x0   , x0        # i=0
L1: add  x5 , x19  , a0        # x5 = addr of x[i]
    lbu  x6 , 0(x5)            # x6 = y[i]
    add  x7 , x19  , a1        # x7 = addr of y[i]
    sb   x6 , 0(x7)            # y[i] = x[i]
    beq  x6 , x0   , L2        # if x[i] == 0 then exit
    addi x19, x19  , 1         # i = i + 1
    jal  x0 , L1               # next iteration of loop
L2: lw   x19, 0(sp)            # restore saved x19
    addi sp , sp   , 4         # pop 1 word from stack
    ret                        # and return 

exit: