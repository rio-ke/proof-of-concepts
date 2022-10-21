### Sets
`A set is an unordered collection of items. Every set element is unique (no duplicates) and must be immutable (cannot be changed).`

```py
#!/usr/bin/env python3
vowels = {'a', 'e', 'i', 'u'}
# adding an element
vowels.add('o')
print('Vowels are:', vowels)  # Vowels are: {'a', 'i', 'e', 'o', 'u'}

# Add tuple to a set
vowels = {'a', 'e', 'u'}
tup = ('i', 'o')
vowels.add(tup)
print('Vowels are:', vowels)  # Vowels are: {('i', 'o'), 'e', 'a', 'u'}
```
**copy()**
```py
# Copy the values
numbers = {1, 2, 3, 4}
new_numbers = numbers.copy()
print(new_numbers) # Output:  {1, 2, 3, 4}
```
**clear()**
```py
# clear the values
primeNumbers = {2, 3, 5, 7}
primeNumbers.clear()
print(primeNumbers) # set()
```
For more details about Python Set Methods - https://www.programiz.com/python-programming/methods/set/remove
