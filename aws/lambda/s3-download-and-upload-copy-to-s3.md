


```py
import boto3
import os
import botocore
import pathlib
import json
import urllib


import logging

logging.basicConfig(format='%(asctime)s %(levelname)-8s %(message)s',level=logging.INFO, datefmt='%Y-%m-%d %H:%M:%S')

# logger = logging.getLogger()
# logger.setLevel(logging.INFO)

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')
s3 = boto3.resource('s3')

sqsUrl = "https://sqs.ap-southeast-1.amazonaws.com/676487226531/a1-s3-sqs.fifo"
postSqsURL="https://sqs.ap-southeast-1.amazonaws.com/676487226531/lambda.fifo"

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

def getObjectDetails(buckeName, fileName):
    _results = s3Client.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in _results

# Download the copy s3 to local

def downloadfile(bucketname, key):
    parentPath = pathlib.PurePath(key).parent
    keyName = pathlib.PurePath(key).name
    tempPath = '/tmp/' + keyName
    s3.meta.client.download_file(bucketname, key, tempPath)
    
# Download the local to s3

def uploadfile(bucketname, key):
    parentPath = pathlib.PurePath(key).parent
    fileName = pathlib.PurePath(key).name
    s3Path = 'SFTP-PROCESS/' + key
    tempPath = '/tmp/' + fileName
    s3.meta.client.upload_file(tempPath, bucketname, s3Path)
    fileRemove(tempPath)

def remove_file_extension(filename):
    base = os.path.basename(filename)
    os.path.splitext(base)
    return os.path.splitext(base)[0]

def fileRemove(key):
    fileName = pathlib.PurePath(key).name
    tempPath = '/tmp/' + fileName
    if os.path.exists(tempPath):
        os.remove(tempPath)
    else:
        print(f"The {tempPath} file does not exist")


# direct copy s3 to s3
def copyS3Object(sourceBucketName, DestinationBucketName, fileName):
    return s3Client.copy_object(CopySource={'Bucket': sourceBucketName, 'Key': fileName}, Bucket=DestinationBucketName, Key="SFTP/"+ fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1',)

    
def lambda_handler(event, context):
    json.dumps(event, indent=3)
    s3ObjectIdentifier = findS3EventObject(event)
    if s3ObjectIdentifier != []:
        for s3 in s3ObjectIdentifier:
            s3Data = json.loads(s3)
            eventName = s3Data['eventName']
            sourceBucketName = urllib.parse.unquote_plus(s3Data['s3']['bucketName'])
            fileName = urllib.parse.unquote_plus(s3Data['s3']['key'])
            receiptHandle = s3Data['receiptHandle']
            getSourceBucketObjectAvailablility = getObjectDetails(sourceBucketName, fileName)
            if getSourceBucketObjectAvailablility == True:
                downloadfile(sourceBucketName, fileName)
                uploadfile(sourceBucketName, fileName)
            else:
                deleteQueueMessage(sqsUrl, receiptHandle)
                logger.error(printLogging(sourceBucketName, fileName, "Failure"))

```
