pgpy-encryption-and-decryption.md

_installation_

```py
pip3 install pgpy
```

_script_

```py
# gpg --encrypt --recipient jinojoe sue.txt

import pgpy
import pathlib
import os


def removeGPGExtension(fileName):
    base = os.path.basename(fileName)
    os.path.splitext(base)
    return os.path.splitext(base)[0]

def decryptFile(fileName, keyPathLocation):
    emsg = pgpy.PGPMessage.from_file(fileName)
    key, _ = pgpy.PGPKey.from_file(keyPathLocation)
    parentPath = pathlib.PurePath(fileName).parent
    keyName = pathlib.PurePath(fileName).name
    destinationFileName = removeGPGExtension(keyName)

    print(destinationFileName, keyName, parentPath)
    with key.unlock("jinojoe"):
        data = key.decrypt(emsg).message.decode('utf-8')
        f = open(destinationFileName, "a")
        f.write(data)
        f.close()

decryptFile("sue.txt.gpg", "key.key")
```
