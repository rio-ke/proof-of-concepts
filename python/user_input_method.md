User Input concept
---
**`user input using function`**
```py
#!/usr/bin/env python3
user_input = input("Enter the values: ")

def userInputDemo(demo_input):
    if type(demo_input) == int:
        return "It is integer"
    else:
        return "It is not integer"


print(userInputDemo(user_input))

# Output 1:
Enter something: ashli
It is not integer

# Output 2:
Enter something: 123
It is integer
```
**`user input using try`**
```py
#!/usr/bin/env python3
user_input = input("Enter the values: ")

try:
    val = int(user_input)
    print(val)
except ValueError:
    print("not a int")
```
