**sftp-file-upload-process.md**

_key authentication_

```py

import logging
import paramiko

Hostname = "s-f4cfaf473f324a5e8.server.transfer.ap-southeast-1.amazonaws.com"
Username = "pgpsftp"
SshPrivateKey = "/home/dodo/.ssh/id_rsa"

logging.basicConfig(format='%(levelname)s : %(message)s', level=logging.INFO)


def SSHClientKeyFile(Hostname, Username, SshPrivateKey):
    sshClient = paramiko.SSHClient()
    sshClient.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    sshClient.connect(hostname=Hostname, username=Username,key_filename=SshPrivateKey)
    return sshClient


def UploadaFile(Hostname, Username, SshPrivateKey, file):
    sftpClient = SSHClientKeyFile(Hostname, Username, SshPrivateKey).open_sftp()
    sftpClient.put(file, file)
    sftpClient.close()
    return True

UploadaFile(Hostname, Username, SshPrivateKey, "decrypt.py")

```

_password authentication_

```py
import logging
import paramiko

Hostname = "s-f4cfaf473f324a5e8.server.transfer.ap-southeast-1.amazonaws.com"
Username = "pgpsftp"
Password = "password@123"

def SSHClientPassword(Hostname, Username, Password):
    sshClient = paramiko.SSHClient()
    sshClient.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    sshClient.connect(hostname=Hostname, username=Username,password=Password)
    return sshClient


def UploadaFileusePassword(Hostname, Username, Password, file):
    sftpClient = SSHClientPassword(Hostname, Username, Password).open_sftp()
    sftpClient.put(file, file)
    sftpClient.close()
    return True
```
