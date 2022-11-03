_Dictionary_

   `Python dictionary is an ordered collection of items. Each item of a dictionary has a key/value pair.`

_Examples_

```py
my_dict = {1: 'apple', 2: 'ball'}
print(my_dict[1]) # {1: 'apple', 2: 'ball'}

my_dict = {'name': 'Jack', 'age': 26}
print(my_dict['name']) # Jack

print(my_dict.get('age')) # 26

# update value
my_dict['age'] = 27

print(my_dict) # {'age': 27, 'name': 'Jack'}
```
**_keys()_** - Fiter the keys.
```py
my_dict = {'name': 'Jack', 'age': 26}
print(my_dict.keys()) # dict_keys(['name', 'age'])
```
```py
squares = {}
for x in range(6):
    squares[x] = x*x
print(squares)

# Output:
{0: 0, 1: 1, 2: 4, 3: 9, 4: 16, 5: 25}
```
### Python Dictionary Methods

![image](https://user-images.githubusercontent.com/57703276/196503616-c9bb3e40-29bd-4348-9061-0b239d15f16e.png)
