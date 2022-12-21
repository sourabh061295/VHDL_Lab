def gcd(a, b):
    while (a != b):
      if (a < b): b -= a
      else      : a -= b
    return a

a = 3528
b = 5040    

print (f"gcd({a},{b}) = {gcd(a,b)}")