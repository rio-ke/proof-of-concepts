
```py
print(" default print")

# variable print
a = "demo"
print(a)

print(f'{a} is variable')
print('variable is:', a)
```
**_Convert the values string to integer_**
```py
a = '123'
b = int(a)
print(b) # 123
```
**_Convert the values list to dictionary_**
```py
one = ["orange","apple","kivi"]
data = {index: value for index, value in enumerate(one)}
print(d) # {0: 'orange', 1: 'apple', 2: 'kivi'}
```
**_Convert the values dictionary to list_**
```py
food = {'pizza': 324, 'sandwich': 78, 'hot dog': 90}
food_list = list(food.values())
print(food_list) #[324, 78, 90]
```
**_Combine to two functions_**
```py
#!/usr/bin/env python3
def addNumers(a, b):
    return a+b

def toFindNumEvenOrOdd(data):

    if data%2 == 0: return "Even"
    else: return "Odd"

print(toFindNumEvenOrOdd(addNumers(3,2)))
```
