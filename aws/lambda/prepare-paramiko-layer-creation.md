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

_lambda code_

```py
import paramiko
import io
import boto3
from botocore.exceptions import ClientError
import logging
import json
import base64
import pathlib
import urllib

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')
s3 = boto3.resource('s3')

def getSecret(secret, region):
    secret_name = secret
    client = boto3.client('secretsmanager', region_name=region)
    get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    secret = get_secret_value_response['SecretString']
    return secret

sqsUrl = "https://sqs.ap-southeast-1.amazonaws.com/676487226531/a1-s3-sqs.fifo"

def deleteQueueMessage(sqsUrl, receiptHandle):
    return sqsClient.delete_message(QueueUrl=sqsUrl,ReceiptHandle=receiptHandle)
    
def findS3EventObject(event):
    listOfObjetcts = []
    checkEvent = 'Records' in event.keys()
    if checkEvent == True:
        for record in event['Records']:
            reformedBody=record['body']
            reformedMessageList= json.loads(reformedBody)
            receiptHandle=record['receiptHandle']
            eventName = reformedMessageList['detail']['eventName']
            s3Event = reformedMessageList['detail']['requestParameters']
            object  = json.dumps({'eventName': eventName, 's3': s3Event, "receiptHandle": receiptHandle})
            listOfObjetcts.append(object)
    return listOfObjetcts
    
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

def decodeContent(string):
    return base64.b64decode(string)

def downloadfile(bucketname, key):
    parentPath = pathlib.PurePath(key).parent
    keyName = pathlib.PurePath(key).name
    tempPath = '/tmp/' + keyName
    s3.meta.client.download_file(bucketname, key, tempPath)
    
def getObjectDetails(buckeName, fileName):
    _results = s3Client.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in _results
    
def fileRemoveFromLambda(key):
    fileName = pathlib.PurePath(key).name
    tempPath = '/tmp/' + fileName
    if os.path.exists(tempPath):
        return os.remove(tempPath)
    else:
        return False
        
def lambda_handler(event, context):
    json.dumps(event, indent=3)
    s3ObjectIdentifier = findS3EventObject(event)
    if s3ObjectIdentifier != []:
        for s3 in s3ObjectIdentifier:
            s3Data = json.loads(s3)
            eventName = s3Data['eventName']
            sourceBucketName = urllib.parse.unquote_plus(s3Data['s3']['bucketName'])
            fileName = urllib.parse.unquote_plus(s3Data['s3']['key'])
            keyName = pathlib.PurePath(fileName).name
            tempPath = '/tmp/' + keyName
            receiptHandle = s3Data['receiptHandle']
 
            if getObjectDetails(sourceBucketName, fileName): # expect true value
                downloadfile(sourceBucketName, fileName)
                sftpDetails = json.loads(getSecret("agenta-sftp-credentials","ap-southeast-1"))
                Username = sftpDetails['username']
                Hostname = sftpDetails['hostname']
                private_key = getSecret("ssh-key", "ap-southeast-1")
                sftpCopyFile(private_key, Username, Hostname, tempPath, keyName)
                fileRemoveFromLambda(keyName)
                deleteQueueMessage(sqsUrl, receiptHandle)
            else:
                deleteQueueMessage(sqsUrl, receiptHandle)
                logger.error(printLogging(sourceBucketName, fileName, "Failure"))
```
