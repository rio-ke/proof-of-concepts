```py
#!/usr/bin/env python3


class demo():
    name = "ashli"
    age = 13
    
# normal print method
print(demo.name) # ashli

# get attribute 
print(getattr(demo, 'age')) # 13

# set attribute
setattr(demo, "name", "joe")
print(demo.name) # joe
setattr(demo, "gender", "female")
print(demo.gender) # female

```
