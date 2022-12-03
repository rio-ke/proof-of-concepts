
_Installtion process_

Open terminal and run the following command to install gnupg tool.

```bash
sudo apt update
sudo apt install gnupg -y
```

_Generate Key_

Finally, you will see a screen like the following.

```bash
sudo gpg --gen-key
```

![image](https://user-images.githubusercontent.com/57703276/205430216-9cdc5bda-b47c-44de-aa13-678bafa2b74c.png)

Please note your pub id 1024D/D8EC56D2 2005-09-08 above. You will need it to export PGP key.

export key

You need to upload your PGP public key to Ubuntu’s key server so that it can be downloaded by anyone. Run the following command for it. Replace 1024D/D8EC56D2 2005-09-08 with the pub id of your key pair.

```bash
gpg --keyserver keyserver.ubuntu.com --send-keys 1024D/D8EC56D2 2005-09-08
```

If you want to simply export the key to another person run the following command. Replace admin@example.com with the email address you have used in step 2. 

```bash
gpg --armor --export admin@example.com > public_key.asc
```

Now you may send public_key.asc file to others. If you want to export the key to a readable text file, you may also run the following command.

```bash
gpg --armor --output key.txt --export admin@example.com
```

Now you may send the key.txt to others.
