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
**`insert()`** - The insert() method inserts an element to the list at the specified index.
```py
#!/usr/bin/env python3
prime_numbers = [2, 3, 5, 7]

# insert 11 at index 4
prime_numbers.insert(4, 11)
print('List:', prime_numbers) # List: [2, 3, 5, 7, 11]
```
**`remove()`** - The remove() method removes the first matching element (which is passed as an argument) from the list.
```py
#!/usr/bin/env python3

animals = ['cat', 'dog', 'rabbit', 'guinea pig']

# 'rabbit' is removed
animals.remove('rabbit')

# Updated animals List
print('Updated animals list: ', animals) # Updated animals list:  ['cat', 'dog', 'guinea pig']
```
**`count()`** - The count() method returns the number of times the specified element appears in the list.
```py
#!/usr/bin/env python3
random = ['a', ('a', 'b'), ('a', 'b'), [3, 4]]

# count element ('a', 'b')
count = random.count(('a', 'b'))
print("The count of ('a', 'b') is:", count) # The count of ('a', 'b') is: 2

# count element [3, 4]
count = random.count([3, 4])
print("The count of [3, 4] is:", count) # The count of [3, 4] is: 1
```
**`pop()`** - The pop() method removes the item at the given index from the list and returns the removed item.
```py
#!/usr/bin/env python3
languages = ['Python', 'Java', 'C++', 'French', 'C']

# remove and return the 4th item
return_value = languages.pop(3)

print('Return Value:', return_value) # Return Value: French

# Updated List
print('Updated List:', languages) # Updated List: ['Python', 'Java', 'C++', 'C']
```
**`reverse()`** - The reverse() method reverses the elements of the list.
```py
#!/usr/bin/env python3
prime_numbers = [2, 3, 5, 7]

# reverse the order of list elements
prime_numbers.reverse()

print('Reversed List:', prime_numbers) # Reversed List: [7, 5, 3, 2]
```
**`sort()`** - The sort() method sorts the items of a list in ascending or descending order.
```py
#!/usr/bin/env python3
prime_numbers = [11, 3, 7, 5, 2]

# sorting the list in ascending order
prime_numbers.sort()

print(prime_numbers) # [2, 3, 5, 7, 11]
```
**`copy()`** - The copy() method returns a shallow copy of the list.
```py
#!/usr/bin/env python3
prime_numbers = [2, 3, 5]

# copying a list
numbers = prime_numbers.copy()

print('Copied List:', numbers) # Copied List: [2, 3, 5]
```


