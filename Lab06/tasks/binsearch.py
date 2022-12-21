def binsearch (arr, l, r, x):              # Returns index of x in arr if present, else -1 
  if r >= l:                               # Check base case 
    mid = (l + r) >> 1 
    if arr[mid] == x:                      # If element is present at the middle itself 
      return mid 
    elif arr[mid] > x:                     # If element is smaller than mid, then
      return binsearch(arr, l, mid-1, x)   # it can only be present in left subarray 
    else:                                  # Else the element can only be present  
      return binsearch(arr, mid + 1, r, x) # in right subarray 
  else:                                    # Element is not present in the array
    return -1

arr = [ 2, 3, 4, 10, 40, 50 ] 
x = 10
  
result = binsearch(arr, 0, len(arr)-1, x) 
if result != -1: 
    print (f"Element is present at index {result}") 
else: 
    print ("Element is not present in array") 