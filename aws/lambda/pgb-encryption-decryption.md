**main.py**
```py
# main.py

import os
import gnupg

gpg = gnupg.GPG('/usr/bin/gpg')

gpg.encoding = 'utf-8'

key_input_data = gpg.gen_key_input(
    name_email="jinojoe@gmail.com",
    passpharse="jinojoe",
    key_type="RSA",
    key_length=4096
)
key = gpg.gen_key(key_input_data)
print(key)
# https://www.digitalocean.com/community/tutorials/how-to-verify-code-and-encrypt-data-with-python-gnupg-and-python-3#step-3-encrypting-files
```
**ecrypt.py**
```py
#!/usr/bin/env python3

import os
import fs
from fs import open_fs
import gnupg

gpg = gnupg.GPG(gnupghome="/home/dodo/.gnupg")
home_fs = open_fs(".")

if os.path.exists("encrypted/"):
    print("Encrypt directory exists")
else:
    home_fs.makedir(u"encrypted")
    print("Created encrypted directory")

files_dir = []

files = [f for f in os.listdir(".") if os.path.isfile(f)]
for f in files:
    files_dir.append(f)

for x in files_dir:
    with open(x, "rb") as f:
        status = gpg.encrypt_file(f,recipients=["jinojoe@gmail.com"],output= files_dir[files_dir.index(x)]+".gpg")
        print("ok: ", status.ok)
        print("status: ", status.status)
        print("stderr: ", status.stderr)
        os.rename(files_dir[files_dir.index(x)] + ".gpg", "encrypted/" +files_dir[files_dir.index(x)] + ".gpg")
```
**decrypt.py**
```py
#!/usr/bin/env python3

import gnupg
from fs import open_fs
import fs
import os


gpg = gnupg.GPG(gnupghome="/home/dodo/.gnupg")
home_fs = open_fs(".")

files_dir = []
files_dir_clean = []

if os.path.exists("decrypted/"):
    print("Decrypted directory already exists")
else:
    home_fs.makedir(u"decrypted/")
    print("Created decrypted directory")

files = [f for f in os.listdir(".") if os.path.isfile(f)]
for f in files:
    files_dir.append(f)

for x in files_dir:
    length = len(x)
    endLoc = length - 4
    clean_file = x[0:endLoc]
    files_dir_clean.append(clean_file)

for x in files_dir:
    print(x)
    with open(x, "rb") as f:
        status = gpg.decrypt_file(
            f, passphrase="jinojoe", output=files_dir_clean[files_dir.index(x)])
    print(status)
    print("ok: ", status.ok)
    print("status: ", status.status)
    print("stderr: ", status.stderr)
    os.rename(files_dir_clean[files_dir.index(x)],
              "decrypted/" + files_dir_clean[files_dir.index(x)])
```



_base function_

```py
import gnupg

Efile = "/home/dodo/Desktop/pgpg/sue.txt"
Dfile = "/home/dodo/Desktop/pgpg/sue.txt.gpg"

gpg = gnupg.GPG(gnupghome='/tmp', gpgbinary='/usr/bin/gpg',
                options=['--trust-model', 'always'])
priv_key = gpg.import_keys("/home/dodo/Desktop/pgpg/private.key")
with open(Dfile, 'rb') as a_file:
    status = gpg.decrypt_file(a_file, passphrase=None,
                              output=Efile, always_trust=True)

    print(status.ok)
    print(status.status)
    print(status.stderr)

gpg = gnupg.GPG(gnupghome='')
priv_key = gpg.import_keys("/home/dodo/Desktop/pgpg/private.key")
with open('Efile', 'rb') as f:
    status = gpg.encrypt_file(
        f, recipients=['jinojoe@gmail.com'],
        output='Dfile'
    )
    print(status.ok)
    print(status.status)
    print(status.stderr)

# gpg --list-secret-keys user@some.com
# gpg --export-secret-keys YOUR_ID_HERE > private.key
# aws s3 mv private.key s3://your_s3_bucket/

```
