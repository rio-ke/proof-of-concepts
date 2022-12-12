

```py
import json
import urllib
import boto3
import logging
import re
logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3Client = boto3.client('s3')

def findAgentName(stringData):
    data = re.split(r'/', stringData)
    return json.loads(json.dumps({ "data": data, "agentName": data[1], "reformKeyname": ("/".join(data[3:]))}))

def sqsClientInit():
    return boto3.client("sqs")

def findSQSName(stringData):
    data = re.split(r':', stringData)
    return data[len(data)-1]
    
def queueURLFinder(QueueName):
    return sqsClientInit().get_queue_url(QueueName=QueueName)["QueueUrl"]

def deleteQueueMessage(QueueName, receiptHandle):
    sqsUrl = queueURLFinder(QueueName)
    return sqsClientInit().delete_message(QueueUrl=sqsUrl, ReceiptHandle=receiptHandle)

def postSqsMessage(QueueName, MessageGroupId, sourceBucketName, Event, Key, version, status):
    sqsUrl = queueURLFinder(QueueName)
    return sqsClientInit().send_message(
        QueueUrl=sqsUrl,
        MessageGroupId=MessageGroupId,
        MessageBody=json.dumps(
            {
                "Source": sourceBucketName,
                "Event": Event,
                "Object": { 
                    "Key": Key, 
                    "Version": version
                },
                "EventDetail": {
                    "status": status
                },
            }
        ),
    )

def combineSQSName(agentName):
    return "sqs-xxx-xxx-uatizcomm-pubsub-" + agentName +".fifo"

def findS3EventObject(event):
    listOfObjetcts = []
    checkEvent = 'Records' in event.keys()
    if checkEvent == True:
        for record in event['Records']:
            reformedBody=record['body']
            reformedMessageList= json.loads(reformedBody)
            receiptHandle=record['receiptHandle']
            eventSourceARN = record['eventSourceARN']
            eventName = reformedMessageList['detail']['eventName']
            s3Event = reformedMessageList['detail']['requestParameters']
            object  = json.dumps({'eventName': eventName, 's3': s3Event, "receiptHandle": receiptHandle, "eventSourceARN": eventSourceARN})
            listOfObjetcts.append(object)
    return listOfObjetcts

def printLogging(sourceBucketName, fileName, state):
    return json.dumps({ 'Bucket': sourceBucketName, 'fileName': fileName, 'procesxxxate': state })
    
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
    outputResult = [ x for x in data if x['Key'] == TagKeyName]
    return outputResult[0]['Value']     
    
def lambda_handler(event, context):
    print(event)
    json.dumps(event, indent=3)
    s3ObjectIdentifier = findS3EventObject(event)
    if s3ObjectIdentifier != []:
        for s3 in s3ObjectIdentifier:
            s3Data = json.loads(s3)
            version = s3Data['version']
            eventName = s3Data['eventName']
            sourceBucketName = urllib.parse.unquote_plus(s3Data['s3']['bucketName'])
            fileName = urllib.parse.unquote_plus(s3Data['s3']['key'])
            receiptHandle = s3Data['receiptHandle']
            eventSourceARN = s3Data['eventSourceARN']
            getSourceBucketObjectAvailablility = getObjectDetails(sourceBucketName, fileName)
            reformDetails  = findAgentName(fileName)
            agentName = reformDetails["agentName"]
            queueName = combineSQSName(agentName)
            eventSourceSqsName = findSQSName(eventSourceARN)

            if getSourceBucketObjectAvailablility == True:
                # C_B from success bucket
                if (eventName == "PutObject"  or eventName == "CompleteMultipartUpload") and (sourceBucketName == "xxx-s3-xxx-xxx-uat-fhq-safe"):
                    successBucket = "xxx-s3-xxx-xxx-uat-fhq-safe-internet"
                    createNewTags(sourceBucketName, fileName, "zone", "intranet")
                    copyS3Object(sourceBucketName, successBucket, fileName)
                    deleteQueueMessage(eventSourceSqsName, receiptHandle)
                    logger.info(printLogging(sourceBucketName, fileName, "Success"))
                    postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")

                # t2 from source bucket
                elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (sourceBucketName == "xxx-s3-xxx-xxx-uat-fhq-dropexternal"):
                    destinationBucket = "xxx-s3-xxx-xxx-uat-fhq-scanning"
                    successBucket = "xxx-s3-xxx-xxx-uat-fhq-safe"
                    createNewTags(sourceBucketName, fileName, "zone", "intranet")
                    copyS3Object(sourceBucketName, destinationBucket, fileName)
                    copyS3Object(sourceBucketName, successBucket, fileName)
                    deleteS3Object(sourceBucketName, fileName)
                    deleteQueueMessage(eventSourceSqsName, receiptHandle)
                    logger.info(printLogging(sourceBucketName, fileName, "Success"))
                    postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")
                # SFTP(D_C) from source bucket
                elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (sourceBucketName == "xxx-s3-xxx-xxx-uat-sftp-intranet"):
                    destinationBucket = "xxx-s3-xxx-xxx-uat-fhq-scanning"
                    successBucket = "xxx-s3-xxx-xxx-uat-fhq-safe"
                    createNewTags(sourceBucketName, fileName, "zone", "intranet")
                    copyS3Object(sourceBucketName, destinationBucket, fileName)
                    copyS3Object(sourceBucketName, successBucket, fileName)
                    deleteS3Object(sourceBucketName, fileName)
                    deleteQueueMessage(eventSourceSqsName, receiptHandle)
                    logger.info(printLogging(sourceBucketName, fileName, "Success"))
                    postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")
                elif (eventName == "PutObjectTagging" and sourceBucketName == "xxx-s3-xxx-xxx-uat-fhq-scanning"):
                    destinationBucket = "xxx-s3-xxx-xxx-uat-fhq-safe"
                    updationTags = getTags(sourceBucketName, fileName)
                    updateTags(destinationBucket, fileName, updationTags)
                    deleteS3Object(sourceBucketName, fileName)
                    deleteQueueMessage(eventSourceSqsName, receiptHandle)
                    logger.info(printLogging(sourceBucketName, fileName, "Success"))
                    postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")
                else:
                    deleteQueueMessage(eventSourceSqsName, receiptHandle)
                    logger.error(printLogging(sourceBucketName, fileName, "unknown event failure"))
            else:
                deleteQueueMessage(eventSourceSqsName, receiptHandle)
                logger.error(printLogging(sourceBucketName, fileName, "Failure"))
```

second

```py
import json
import urllib
import boto3
import logging
import re

logger = logging.getLogger()
logger.setLevel(logging.INFO)
s3Client = boto3.client('s3')
s3 = boto3.resource('s3')


def findAgentName(stringData):
    data = re.split(r'/', stringData)
    return json.loads(json.dumps({ "data": data, "agentName": data[1], "reformKeyname": ("/".join(data[3:]))}))

def sqsClientInit():
    return boto3.client("sqs")

def findSQSName(stringData):
    data = re.split(r':', stringData)
    return data[len(data)-1]
    
def queueURLFinder(QueueName):
    return sqsClientInit().get_queue_url(QueueName=QueueName)["QueueUrl"]

def deleteQueueMessage(QueueName, receiptHandle):
    sqsUrl = queueURLFinder(QueueName)
    return sqsClientInit().delete_message(QueueUrl=sqsUrl, ReceiptHandle=receiptHandle)

def postSqsMessage(QueueName, MessageGroupId, sourceBucketName, Event, Key, version, status):
    sqsUrl = queueURLFinder(QueueName)
    return sqsClientInit().send_message(
        QueueUrl=sqsUrl,
        MessageGroupId=MessageGroupId,
        MessageBody=json.loads(json.dumps(
            {
                "Source": sourceBucketName,
                "Event": Event,
                "Object": { 
                    "Key": Key, 
                    "Version": version
                },
                "EventDetail": {
                    "status": status
                },
            }
        ),
    ))

def combineSQSName(agentName):
    return "sqs-xxx-xxx-uatizcomm-pubsub-" + agentName +".fifo"

def findS3EventObject(event):
    listOfObjetcts = []
    checkEvent = 'Records' in event.keys()
    if checkEvent == True:
        for record in event['Records']:
            reformedBody=record['body']
            reformedMessageList= json.loads(reformedBody)
            receiptHandle=record['receiptHandle']
            eventSourceARN = record['eventSourceARN']
            eventName = reformedMessageList['detail']['eventName']
            version = reformedMessageList['detail']['eventVersion']
            s3Event = reformedMessageList['detail']['requestParameters']
            object  = json.dumps({'eventName': eventName, 's3': s3Event, "receiptHandle": receiptHandle, "version": version, "eventSourceARN": eventSourceARN })
            listOfObjetcts.append(object)
    return listOfObjetcts

def printLogging(sourceBucketName, fileName, state):
    return json.dumps({ 'Bucket': sourceBucketName, 'fileName': fileName, 'procesxxxate': state })
    
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
            version = s3Data['version']
            eventName = s3Data['eventName']
            sourceBucketName = urllib.parse.unquote_plus(s3Data['s3']['bucketName'])
            fileName = urllib.parse.unquote_plus(s3Data['s3']['key'])
            receiptHandle = s3Data['receiptHandle']
            eventSourceARN = s3Data['eventSourceARN']
            getSourceBucketObjectAvailablility = getObjectDetails(sourceBucketName, fileName)
            reformDetails  = findAgentName(fileName)
            agentName = reformDetails["agentName"]
            queueName = combineSQSName(agentName)
            print(queueName)
            eventSourceSqsName = findSQSName(eventSourceARN)
            print(eventSourceSqsName)

            if getSourceBucketObjectAvailablility == True:
                if (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (sourceBucketName == "cx-s3-uat.corenet.gov.sg"):
                    metadataBucket = "xxx-s3-xxx-xxx-uat-fhq-safe-internet"
                    scanningBucket = "xxx-s3-xxx-xxx-uat-fhq-scanning"
                    createNewTags(sourceBucketName, fileName, "zone", "internet")
                    copyS3Object(sourceBucketName, metadataBucket, fileName)
                    copyS3Object(sourceBucketName, scanningBucket, fileName)
                    deleteS3Object(sourceBucketName, fileName)
                    deleteQueueMessage(eventSourceSqsName, receiptHandle)
                    logger.info(printLogging(sourceBucketName, fileName, "Success"))
                    postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")
                elif (eventName == "PutObjectTagging" and sourceBucketName == "xxx-s3-xxx-xxx-uat-fhq-scanning"):
                    zoneTag = getTagsDetails(sourceBucketName, fileName, "zone")
                    if zoneTag == "Intranet" or zoneTag == "intranet":
                        destinationBucket = "xxx-s3-xxx-xxx-uat-fhq-safe"
                        updationTags = getTags(sourceBucketName, fileName)
                        getSourceBucketObjectAvailablility = getObjectDetails(destinationBucket, fileName)
                        updateTags(destinationBucket, fileName, updationTags)
                        deleteS3Object(sourceBucketName, fileName)
                        deleteQueueMessage(eventSourceSqsName, receiptHandle)
                        logger.info(printLogging(sourceBucketName, fileName, "Success"))
                        postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")
                    else :
                        destinationBucket = "xxx-s3-xxx-xxx-uat-fhq-safe-internet"
                        updationTags = getTags(sourceBucketName, fileName)
                        updateTags(destinationBucket, fileName, updationTags)
                        deleteS3Object(sourceBucketName, fileName)
                        deleteQueueMessage(eventSourceSqsName, receiptHandle)
                        logger.info(printLogging(sourceBucketName, fileName, "Success"))
                        postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")
                elif (eventName == "PutObjectTagging" and sourceBucketName == "xxx-s3-xxx-xxx-uat-fhq-safe-internet"):
                    successBucket = "xxx-s3-xxx-xxx-uat-fhq-safe"
                    failureBucket = "xxx-s3-xxx-xxx-uat-fhq-quarantine-internet"
                    if "A_C" in fileName:
                        getTagValue = getTagsDetails(sourceBucketName, fileName, 'fss-scan-result')
                        if 'no issues found' == getTagValue:
                            copyS3Object(sourceBucketName, successBucket, fileName)
                            deleteS3Object(sourceBucketName, fileName)
                            deleteQueueMessage(eventSourceSqsName, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "Success"))
                            postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "drop")
                        else:
                            copyS3Object(sourceBucketName, failureBucket, fileName)
                            deleteQueueMessage(eventSourceSqsName, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "scan tag Failure"))
                            postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "drop")
                    elif "A_B" in fileName:
                        getTagValue = getTagsDetails(sourceBucketName, fileName, 'fss-scan-result')
                        if 'no issues found' == getTagValue:
                            copyS3Object(sourceBucketName, successBucket, fileName)
                            deleteQueueMessage(eventSourceSqsName, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "Success"))
                            postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")
                        else:
                            copyS3Object(sourceBucketName, failureBucket, fileName)
                            deleteQueueMessage(eventSourceSqsName, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "scan tag Failure"))
                            postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")
                    else:
                        getTagValue = getTagsDetails(sourceBucketName, fileName, 'fss-scan-result')
                        if 'no issues found' == getTagValue:
                            copyS3Object(sourceBucketName, successBucket, fileName)
                            deleteQueueMessage(eventSourceSqsName, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "Success"))
                            postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")
                        else:
                            copyS3Object(sourceBucketName, failureBucket, fileName)
                            deleteQueueMessage(eventSourceSqsName, receiptHandle)
                            logger.info(printLogging(sourceBucketName, fileName, "scan tag Failure"))
                            postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "ok")
                # B_C
                elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (sourceBucketName == "xxx-s3-xxx-xxx-uat-fhq-safe-internet"):
                    successBucket = "xxx-s3-xxx-xxx-uat-fhq-safe"
                    copyS3Object(sourceBucketName, successBucket, fileName)
                    updationTags = [{'Key': 'fss-scan-result', 'Value': 'no issues found'}, {'Key': 'zone', 'Value': 'internet'}]
                    updateTags(successBucket, fileName, updationTags)
                    deleteQueueMessage(eventSourceSqsName, receiptHandle)
                    logger.info(printLogging(sourceBucketName, fileName, "Success"))
                    postSqsMessage(queueName, agentName.lower(), sourceBucketName, "decryption", fileName, version, "drop")
                else:
                    deleteQueueMessage(eventSourceSqsName, receiptHandle)
                    logger.error(printLogging(sourceBucketName, fileName, "unknown event failure"))
            else:
                deleteQueueMessage(eventSourceSqsName, receiptHandle)
                logger.error(printLogging(sourceBucketName, fileName, "Failure"))
```
