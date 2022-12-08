
```py
import re
stringData = 'one,two-three,four'
result = re.split(r',|-', stringData) 
print(result)  
# ['one', 'two', 'three', 'four']

stringData = 'one,two-three:four'
result = re.split(r',|-|:', stringData) 
print(result)  
# ['one', 'two', 'three', 'four']
```
