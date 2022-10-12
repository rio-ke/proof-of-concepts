## Python if...else Statement
**Python `if Statement` Flowchart**

![image](https://user-images.githubusercontent.com/57703276/195426333-e237ec19-5095-4973-b720-d1c7362804b5.png)

```py
#! /usr/bin/env python3
num = 3
if num > 0:
    print(num, "is a positive number.")
print("This is always printed.")

num = -1
if num > 0:
    print(num, "is a positive number.")
print("This is also always printed.")

Output:
# 3 is a positive number
# This is always printed
# This is also always printed.
```
**`If else Statement`**
```py
#!/usr/bin/env python3
num = 3

if num >= 0:
    print("Positive number")
else:
    print("Negative number")

Output:
# positive number
```
**`if...elif...else`**
```py
#!/usr/bin/env python3
num = 3.4
if num > 0:
    print("Positive number")
elif num == 0:
    print("Zero")
else:
    print("Negative number")
    
Output:
# Positive number
```

