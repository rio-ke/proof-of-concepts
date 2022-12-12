

```py
import re


def is_allowed(string):
    characherRegex = re.compile(r'[^a-zA-Z0-9.]')
    string = characherRegex.search(string)
    return not bool(string)


print(is_allowed("abyzABYZ0099"))
print(is_allowed("#*@#$%^"))
```
