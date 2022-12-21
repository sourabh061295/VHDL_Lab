.data
msg:   .asciiz "\nhello world\n"

.text
start: li a0, 1        # ecall code: print integer   (ID=1)  
       li a1, 100      # integer (100) to print   
       ecall
       li a0, 4        # ecall code: print string    (ID=4)
       la a1, msg      # null-terminated string address
       ecall
       li a0, 11       # ecall code: print character (ID=11) 
       li a1, 'a'      # character 'a' to print          
       ecall 
       li a0, 34       # ecall code: print character (ID=34) 
       li a1, 'a'      # character 'a' to print as hex value         
       ecall 
       li a0, 10       # ecall code: stops running   (ID=10)
       ecall