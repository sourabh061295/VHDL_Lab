def insertionsort(arr): 
  for i in range(1, len(arr)): # Traverse through 1 to len(arr) 
    key = arr[i] 
    # Move elements of arr[0..i-1], that are 
    # greater than key, to one position ahead 
    # of their current position 
    j = i-1
    while j >=0 and key < arr[j] : 
      arr[j+1] = arr[j] 
      j -= 1
    arr[j+1] = key 

arr = [10, 7, 8, 9, 1, 5]
insertionsort(arr)
print(arr)    