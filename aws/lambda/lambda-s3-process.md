_lambda-s3-process.md_

```py
import json
import urllib
import boto3

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')

metadataBucket = "a2-s3-bucket-jn"
scanningBucket = "a2-s3-bucket-scan"
sqsUrl         = "https://sqs.ap-southeast-1.amazonaws.com/676487226531/a1-s3-sqs.fifo"

def deleteQueueMessage(sqsUrl, receiptHandle):
    return sqsClient.delete_message(QueueUrl=sqsUrl,ReceiptHandle=receiptHandle)
    
def findS3EventObject(event):
    listOfObjetcts = []
    checkEvent = 'Records' in event.keys()
    if checkEvent == True:
        for source in range(len(event['Records'])):
            reformedListRecord = event['Records'][source]
            reformedBody       = json.loads(reformedListRecord["body"])
            reformedMessageList= json.dumps(reformedBody)
            reformedMessage    = json.loads(reformedMessageList)
            receiptHandle      = reformedListRecord['receiptHandle']
            s3Event            = reformedMessage['detail']['requestParameters']
            object             = json.dumps({'s3': s3Event, "receiptHandle": receiptHandle})
            listOfObjetcts.append(object)
            
    return listOfObjetcts

def printLogging(sourceBucketName, fileName):
    return json.dumps({ 'Bucket': sourceBucketName, 'fileName': fileName })
    
def getObjectDetails(buckeName, fileName):
    _results = s3Client.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in _results
    
def createNewTags(buckeName, fileName, tagName, tagValue):
    tagging = {'TagSet' : [{'Key': tagName, 'Value': tagValue }]}
    return s3Client.put_object_tagging(Bucket=buckeName, Key=fileName, Tagging=tagging)

def copyS3Object(sourceBucketName, DestinationBucketName, fileName):
    return s3Client.copy_object(CopySource={ 'Bucket': sourceBucketName, 'Key': fileName }, Bucket=DestinationBucketName, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1',)

def deleteS3Object(bucketName, fileName):
    return s3Client.delete_object(Bucket=bucketName, Key=fileName)

def lambda_handler(event, context):
    json.dumps(event, indent=3)
    s3ObjectIdentifier = findS3EventObject(event)
    if s3ObjectIdentifier != []:
        for s3 in s3ObjectIdentifier:
            s3Data = json.loads(s3)
            sourceBucketName = urllib.parse.unquote_plus(s3Data['s3']['bucketName'])
            fileName = urllib.parse.unquote_plus(s3Data['s3']['key'])
            receiptHandle = s3Data['receiptHandle']
            eventObject = { 'Bucket': sourceBucketName, 'fileName': fileName }
            print(printLogging(sourceBucketName, fileName))
            
            getSourceBucketObjectAvailablility = getObjectDetails(sourceBucketName, fileName)
            if getSourceBucketObjectAvailablility == True:
                createNewTags(sourceBucketName, fileName, "zone", "internet")
                copyS3Object(sourceBucketName, metadataBucket, fileName)
                deleteS3Object(sourceBucketName, fileName)
                deleteQueueMessage(sqsUrl, receiptHandle)
            else:
                deleteQueueMessage(sqsUrl, receiptHandle)
```
