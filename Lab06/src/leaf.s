       addi a0, a0, 7     # g = 7
       addi a1, a1, 6     # h = 6
       addi a2, a2, 5     # i = 5
       addi a3, a3, 4     # g = 4
       jal  leaf          # call procedure leaf
       j    print          

leaf:  addi sp, sp, -8    # adjust stack for 2 items 
       sw   s1, 4 ( sp )  # save s1 for use afterwards 
       sw   s0, 0 ( sp )  # save s0 for use afterwards 
       add  s0, a0, a1    # s0 = g + h 
       add  s1, a2, a3    # s1 = i + j 
       sub  s0, s0, s1    # f = (g + h) - (i + j) 
       addi a0, s0, 0     # copy f to return register
       lw   s0, 0 ( sp )  # restore register s0 for caller  
       lw   s1, 4 ( sp )  # restore register s1 for caller 
       addi sp, sp, 8     # adjust stack to delete 2 items 
       ret                # jump back to calling routine
print: mv   a1, a0        # move result to a1
       li   a0, 1         # ecall code: print integer 
       ecall