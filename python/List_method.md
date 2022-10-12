## Python List Method
**`index()`** - The index() method returns the index of the specified element in the list.
```py
#!/usr/bin/env python3

vowels = ['a', 'e', 'i', 'o', 'i', 'u']

index = vowels.index('e')
print('The index of e:', index) #The index of e: 1

index = vowels.index('i')
print('The index of i:', index) #The index of i: 2
```
**`append()`** - The append() method adds an item to the end of the list.
```py
#!/usr/bin/env python3
currencies = ['Dollar', 'Euro', 'Pound']
currencies.append('Yen')
print(currencies) # ['Dollar', 'Euro', 'Pound', 'Yen']
```
**`extend()`** - The extend() method adds all the elements of an iterable (list, tuple, string etc.) to the end of the list.
```py
#!/usr/bin/env python3
prime_numbers = [2, 3, 5]
numbers = [1, 4]
numbers.extend(prime_numbers)
print(numbers) # [1, 4, 2, 3, 5]
```
**`insert()`**
```py
#!/usr/bin/env python3
prime_numbers = [2, 3, 5, 7]

# insert 11 at index 4
prime_numbers.insert(4, 11)
print('List:', prime_numbers) # List: [2, 3, 5, 7, 11]
```
