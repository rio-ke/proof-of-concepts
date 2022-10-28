```py
#!/usr/bin/env python3

class demo():
    name = "kumar"
    age = 13
    
# normal print method
print(demo.name) # kumar

# get attribute - get the specified attribute
print(getattr(demo, 'age')) # 13

# set attribute - to add a new attribute 
setattr(demo, "name", "joe")
print(demo.name) # joe
setattr(demo, "gender", "female")
print(demo.gender) # female
```
