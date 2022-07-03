## word-finder.py

```py

def wordConstructor(text, note):
    expectedResults =  []
    _text = text.replace(" ", "")
    result = "".join(dict.fromkeys(_text))
    print(result)

    _notes = []
    for _words in note:
        _notes.append(_words)

    for _j in _notes:
        for _i in result:
            
            if ( _j == _i):
                expectedResults.append(True)
            else:
                expectedResults.append(False)
    
    data=expectedResults.count(True)

    if len(note) != data:
        return 0
    else:
        return 1
print(wordConstructor("siva", "visa")) ## success
print(wordConstructor("gino", "visa")) ## Failure
```
