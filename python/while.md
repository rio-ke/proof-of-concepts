**While statement**
```py
#!/usr/bin/env python3

number = int(input("Enter the Number: "))

count = 5
while count >= 1:
    data = number * count
    print(count, "x", number, "=", data)
    count = count - 1
 
# Output:
5 x 8 = 40
4 x 8 = 32
3 x 8 = 24
2 x 8 = 16
1 x 8 = 8
```
**While loop with else**
```py
#!/usr/bin/env python3

counter = 0

while counter < 3: print("Inside loop"); counter = counter + 1
else: print("Inside else")

# Output:
Inside loop
Inside loop
Inside loop
Inside else
```
