## User Input

```py
#!/usr/bin/env python3


user_input = input("Enter the values: ")

def userInputDemo(demo_input):
    if type(demo_input) == int:
        return "It is integer"
    else:
        return "It is not a integer"


print(userInputDemo(user_input))
```
