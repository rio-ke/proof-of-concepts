_Object Oriented Program (OOP)_


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

# dot notation attribute
demo.city = "Chennai"
print(demo.city)  # Chennai

#  module in dict method
print(demo.__dict__)

# delattr - delete the specified attribute
delattr(demo,"city")
print(demo.__dict__)

del (demo.age)
print(demo.__dict__)

```
**_class without argument_**
```py
#!/usr/bin/env python3
class student:
    name = "Ashli"
    age = 20

    def printStudentDetails():
        print("Name : ", student.name)
        print("Age  : ", student.age)

student.printStudentDetails()

# getattr - get the value using get attribute
getattr(student,"printStudentDetails")()
```
**_class with self instance attribute and object_**
```py
#!/usr/bin/env python3
class student:
    name = "Ashli"
    age = 20

    def printStudentDetails(self):
        print("Name : ", student.name)
        print("Age  : ", student.age)

# object
result = student()

# call the function
result.printStudentDetails()
```

**_class - init python method_**
```py
#!/usr/bin/env python3
class user:
    def __init__(self, name):
        print("Welcome to the python init method in python.")
        self.name = name

    def printAll(self):
        print(self.name)
    

obj1 = user("joe")
obj1.printAll()
```
