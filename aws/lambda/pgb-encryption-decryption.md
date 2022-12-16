_pgb-encryption-decryption.md_


```py
import gnupg
import json
import re
import os
import pathlib


def determineNameOfEmail(nameOfEmail):
    result = re.split(r'@', nameOfEmail)
    return result[0]

def removeGpgExtension(nameOfFile):
    return os.path.splitext(nameOfFile)[0]

def generteGpgkey(nameOfEmail, password):
    gpg = gnupg.GPG()

    # generate key
    input_data = gpg.gen_key_input(name_email=nameOfEmail, passphrase=password)
    key = gpg.gen_key(input_data)

    # create ascii-readable versions of pub / private keys
    ascii_armored_public_keys = gpg.export_keys(key.fingerprint)
    ascii_armored_private_keys = gpg.export_keys(keyids=key.fingerprint, secret=True, passphrase=password)
    nameOfExportFile = determineNameOfEmail(nameOfEmail) + ".asc"

    # export the keys into files
    with open(nameOfExportFile, 'w') as f:
        f.write(ascii_armored_public_keys)
        f.write(ascii_armored_private_keys)

    return json.dumps({
        "keyname": nameOfExportFile,
        "state": "created"
    })


def gpgEncryption(combineOfKeyFile, nameOfEncryoptionFile, recipients):
    gpg = gnupg.GPG()
    with open(combineOfKeyFile) as f:
        keyLoader = f.read()
    gpg.import_keys(keyLoader)
    status = gpg.encrypt_file(nameOfEncryoptionFile, recipients=[recipients], output=nameOfEncryoptionFile + ".gpg")
    return json.dumps({
        "encrytionState": status.ok,
        "status": status.status
    })


def gpgDecryption(combineOfKeyFile, passphrase, nameOfDecryoptionFile):
    gpg = gnupg.GPG()
    with open(combineOfKeyFile) as f:
        keyLoader = f.read()
    gpg.import_keys(keyLoader)
    status = gpg.decrypt_file(nameOfDecryoptionFile, passphrase=passphrase,output=removeGpgExtension(nameOfDecryoptionFile))
    return json.dumps({
        "decrytionState": status.ok,
        "status": status.status
    })


def checkDecryptionStatus(nameOfFile):
    extensionOfFile = pathlib.Path(nameOfFile).suffix
    if (extensionOfFile == '.asc' or extensionOfFile == '.gpg' or extensionOfFile == '.pgp'):
        return True
    else:
        return False
```

_execution_

```py
print(generteGpgkey("jinojoe@gmail.com", "jinojoe"))
print(gpgEncryption("jinojoe.asc", "demo.txt", "jinojoe@gmail.com"))
print(removeGpgExtension("demo.txt.gpg"))
print(checkDecryptionStatus("demo.txt.gpg"))
print(gpgDecryption("jinojoe.asc", "jinojoe", "demo.txt.gpg"))
```
