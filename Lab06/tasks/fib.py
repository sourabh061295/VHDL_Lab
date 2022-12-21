def fib (i):  
    if i>1:
        x = fib(i-1) + fib(i-2)
    else 
        x = i   
    return x

n = 9
print(f"fib({n})={fib(n)}")