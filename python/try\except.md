
```py
#!/usr/bin/env python3

try:
    a =20*0
    print(a)
except Exception as e:
    print(e)# show the errors only

# Output
0
```
```py
try:
    a = 20/0
except Exception as e:
    print(e)  # show the errors only
else:
    print(a)

# Output
division by zero
```
