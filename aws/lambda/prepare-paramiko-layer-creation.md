prepare-paramiko-layer-creation.md

_Dockerfile_

```Dockerfile
FROM lambci/lambda:build-python3.8
RUN pip install -t /opt/python/ paramiko
WORKDIR /var/task
```

_commands_

```bash
docker build -t paramiko .
docker run -ti paramiko paramiko
docker cp paramiko:/opt .
zip -r python3.8-paramiko opt/python
```

```py
import paramiko
import io
import boto3
from botocore.exceptions import ClientError
import logging

logging.basicConfig(format='%(asctime)s %(levelname)-8s %(message)s',level=logging.INFO, datefmt='%Y-%m-%d %H:%M:%S')

def getPrivateKey(secret, region):
    secret_name = secret
    client = boto3.client('secretsmanager', region_name=region)
    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    except ClientError as e:
        raise e
    else:
        secret = get_secret_value_response['SecretString']
        return secret

def sftpCopyFile(private_key, user, hostname, local_path, remote_path):
    private_key_str = io.StringIO()
    private_key_str.write(private_key)
    private_key_str.seek(0)
    key = paramiko.RSAKey.from_private_key(private_key_str)
    private_key_str.close()
    del private_key_str
    trans = paramiko.Transport(hostname, 22)
    trans.start_client()
    trans.auth_publickey(user, key)
    del key
    trans.open_session()
    sftp = paramiko.SFTPClient.from_transport(trans)
    sftp.put(local_path, remote_path)
    sftp.close()
    trans.close()


Hostname = "s-f4cfaf473f324a5e8.server.transfer.ap-southeast-1.amazonaws.com"
Username = "pgpsftp"
private_key = getPrivateKey("ssh-key", "ap-southeast-1")
sftpCopyFile(private_key, Username, Hostname,'run.sh', 'run.sh')
```
