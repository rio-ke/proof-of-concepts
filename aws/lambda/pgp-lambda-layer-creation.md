

```bash
#!/usr/bin/env bash

# Installing necessary python packages
echo Installing required packages...
sudo amazon-linux-extras enable python3.8
sudo yum install python3.8 gcc make glibc-static bzip2 pip -y
echo Required packages installed. 
pip3.8 install virtualenv
python3.8 -m venv python
cd python
. bin/activate
pip3.8 install python-gnupg
deactivate
rm -rf ./bin
mkdir ./python
mv lib ./python/

# Downloading and building GPG binary from source gnupg-2.2.0.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.23.tar.bz2
tar xjf gnupg-1.4.23.tar.bz2
cd gnupg-1.4.23
/bin/bash /home/cloudshell-user/python/gnupg-1.4.23/configure
make CLFAGS='-static'
cp g10/gpg /home/cloudshell-user/python/python
cd /home/cloudshell-user/python/python
chmod o+x gpg
cd ..
zip -r lambdaLayer.zip python/
aws lambda publish-layer-version --layer-name gnupg-python-1-4-23-1 --description "Python-GNUPG Module and GPG Binary" --zip-file fileb://gnupg-python-1-4-23v1.zip --compatible-runtimes python3.9
echo Lambda layer created successfully.
```

_docs_

https://www.gnupg.org/ftp/gcrypt/gnupg/
