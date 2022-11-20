_Create a aws Layer in Lambda for Paramiko library_

```py

import boto3
import paramiko
from io import BytesIO
from stat import S_ISDIR, S_ISREG

Hostname = "<your-public-hostIP>"
Username = "<your-username>"
Password = "<your-password>"

s3client = boto3.client('s3')
sshClient = paramiko.SSHClient()
sshClient.set_missing_host_key_policy(paramiko.AutoAddPolicy())
sshClient.connect(hostname=Hostname, username= Username, password=Password,port=22,allow_agent=False,look_for_keys=False)

#Using SSH protocol to SSH into SFTP Client via Port 22
sftpClient = sshClient.open_sftp()
# print(dir(sftpClient))


sftpClient.chdir('/<your-remotedirectory-full-path>/')
for entry in sftpClient.listdir_attr(""):
    mode = entry.st_mode
    # we have a regular file, not a folder
    if S_ISREG(mode):
        f = entry.filename
        with BytesIO() as data:
            print('Downloading file {0} from SFTP.. to S3'.format(f))

            sftpClient.getfo(f, data)
            data.seek(0)

            s3client.upload_fileobj(
                data,
                '<your-s3bucket-name>',
                '<your-s3bucketfolder-name>/{0}'.format(f)
            )

#Closing Connections
sftpClient.close()
sshClient.close()
```
