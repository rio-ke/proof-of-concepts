

```py
import json
import urllib
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')

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

def printLogging(sourceBucketName, fileName, state):
    return json.dumps({ 'Bucket': sourceBucketName, 'fileName': fileName, 'processState': state })
    
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

def updateTags(buckeName, fileName, updationTags):
    return s3Client.put_object_tagging(Bucket=buckeName, Key=fileName, Tagging={'TagSet': updationTags})

def getTags(buckeName, fileName):
    tag = s3Client.get_object_tagging(Bucket=buckeName, Key=fileName)
    return tag['TagSet']

def getTagsDetails(sourceBucketName, fileName, TagKeyName):
    tags = s3Client.get_object_tagging(Bucket=sourceBucketName, Key=fileName)
    data = tags['TagSet']
    if data == []:
        return None
    else:
        outputResult = [ x for x in data if x['Key'] == TagKeyName]
        return outputResult[0]['Value']
    
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

                # A_B and default process
                if (eventName == "PutObject" and sourceBucketName == "a1-s3-bucket-jn"):
                    metadataBucket = "a2-s3-bucket-jn"
                    scanningBucket = "a2-s3-bucket-scan"
                    createNewTags(sourceBucketName, fileName, "zone", "internet")
                    copyS3Object(sourceBucketName, metadataBucket, fileName)
                    copyS3Object(sourceBucketName, scanningBucket, fileName)
                    deleteS3Object(sourceBucketName, fileName)
                    deleteQueueMessage(sqsUrl, receiptHandle)
                    logger.info(printLogging(sourceBucketName, fileName, "Success"))
                    
                elif (eventName == "PutObjectTagging" and sourceBucketName == "a2-s3-bucket-scan"):
                    destinationBucket = "a2-s3-bucket-jn"
                    updationTags = getTags(sourceBucketName, fileName)
                    updateTags(destinationBucket, fileName, updationTags)
                    deleteS3Object(sourceBucketName, fileName)
                    deleteQueueMessage(sqsUrl, receiptHandle)
                    logger.info(printLogging(sourceBucketName, fileName, "Success"))
                    
                
                elif (eventName == "PutObjectTagging" and sourceBucketName == "a2-s3-bucket-jn"):
                    successBucket = "a3-s3-bucket-success"
                    failureBucket = "a3-s3-bucket-failure"
                    
                    if "A_C" in fileName:
                        getTagValue = getTagsDetails(sourceBucketName, fileName, 'fss-scan-result')
                        if 'no issues found' == getTagValue:
                            copyS3Object(sourceBucketName, successBucket, fileName)
                            deleteS3Object(sourceBucketName, fileName)
                            deleteQueueMessage(sqsUrl, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "Success"))
                        else:
                            copyS3Object(sourceBucketName, failureBucket, fileName)
                            deleteQueueMessage(sqsUrl, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "scan tag Failure"))
                            
                    elif "A_B" in fileName::
                        getTagValue = getTagsDetails(sourceBucketName, fileName, 'fss-scan-result')
                        if 'no issues found' == getTagValue:
                            copyS3Object(sourceBucketName, successBucket, fileName)
                            deleteQueueMessage(sqsUrl, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "Success"))
                        else:
                            copyS3Object(sourceBucketName, failureBucket, fileName)
                            deleteQueueMessage(sqsUrl, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "scan tag Failure"))
                            
                    else:
                        getTagValue = getTagsDetails(sourceBucketName, fileName, 'fss-scan-result')
                        if 'no issues found' == getTagValue:
                            copyS3Object(sourceBucketName, successBucket, fileName)
                            deleteQueueMessage(sqsUrl, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "Success"))
                        else:
                            copyS3Object(sourceBucketName, failureBucket, fileName)
                            deleteQueueMessage(sqsUrl, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "scan tag Failure"))

                # B_C
                elif (eventName == "PutObject" and sourceBucketName == "a2-s3-bucket-jn"):
                    successBucket = "a3-s3-bucket-success"
                    copyS3Object(sourceBucketName, successBucket, fileName)
                    createNewTags(successBucket, fileName, "zone", "internet")
                    deleteQueueMessage(sqsUrl, receiptHandle)
                    logger.info(printLogging(sourceBucketName, fileName, "Success"))
                    
                # C_B from success bucket
                elif (eventName == "PutObject" and sourceBucketName == "a3-s3-bucket-success"):
                    successBucket = "a2-s3-bucket-jn"
                    createNewTags(sourceBucketName, fileName, "zone", "intranet")
                    copyS3Object(sourceBucketName, successBucket, fileName)
                    deleteQueueMessage(sqsUrl, receiptHandle)
                    logger.info(printLogging(sourceBucketName, fileName, "Success"))
                    
                else:
                    deleteQueueMessage(sqsUrl, receiptHandle)
                    logger.error(printLogging(sourceBucketName, fileName, "unknown event failure"))
            else:
                deleteQueueMessage(sqsUrl, receiptHandle)
                logger.error(printLogging(sourceBucketName, fileName, "Failure"))
```
