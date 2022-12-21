      addi s1, zero, 0     # s1 = sum = 0
      add  s0, zero, zero  # s0 = i
      addi t0, zero, 10    # upper limit (10)
for:  beq  s0, t0, done    # if i=10 go to done
      add  s1, s1, s0      # sum += i
      addi s0, s0, 1       # i += 1
      j    for             # jump back to for
done: li   a0, 1           # a0 = 1  
      mv   a1, s1          # a1 = sum      
      ecall                # print sum