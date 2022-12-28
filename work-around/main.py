import json
import urllib
import boto3
import logging
import re

logger = logging.getLogger()
logger.setLevel(logging.INFO)
s3Client = boto3.client('s3')

def logPoster(eventBucket, fileName, state):
    return json.dumps({'Bucket': eventBucket, 'fileName': fileName, 'processState': state})

def getObjectDetails(bucketName, fileName):
    _results = s3Client.list_objects(Bucket=bucketName, Prefix=fileName)
    return 'Contents' in _results

def createNewTags(bucketName, fileName, tagName, tagValue):
    tagging = {'TagSet': [{'Key': tagName, 'Value': tagValue}]}
    return s3Client.put_object_tagging(Bucket=bucketName, Key=fileName, Tagging=tagging)

def copyS3Object(eventBucket, DestinationBucket, fileName):
    return s3Client.copy_object(CopySource={'Bucket': eventBucket, 'Key': fileName}, Bucket=DestinationBucket, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1',)

def deleteS3Object(bucketName, fileName):
    return s3Client.delete_object(Bucket=bucketName, Key=fileName)

def updateTags(bucketName, fileName, updationTags):
    return s3Client.put_object_tagging(Bucket=bucketName, Key=fileName, Tagging={'TagSet': updationTags})

def getTags(bucketName, fileName):
    tag = s3Client.get_object_tagging(Bucket=bucketName, Key=fileName)
    return tag['TagSet']

def getTagsDetails(eventBucket, fileName, TagKeyName):
    tags = s3Client.get_object_tagging(Bucket=eventBucket, Key=fileName)
    data = tags['TagSet']
    if data == []:
        return None
    else:
        outputResult = [x for x in data if x['Key'] == TagKeyName]
        return outputResult[0]['Value']

def reformKeyname(stringData):
    data = re.split(r'/', stringData)
    return ("/".join(data[1:]))
    
def copyS3ObjectWithNewName(eventBucket, DestinationBucket, fileName):
    return s3Client.copy_object(CopySource={'Bucket': eventBucket, 'Key': fileName}, Bucket=DestinationBucket, Key=reformKeyname(fileName), TaggingDirective='COPY', ChecksumAlgorithm='SHA1',)


def lambda_handler(event, context):
    # print(event)
    eventName = event['detail']['eventName']
    eventBucket = urllib.parse.unquote_plus(event['detail']['requestParameters']['bucketName'])
    fileName = urllib.parse.unquote_plus(event['detail']['requestParameters']['key'])
    # print(eventName, eventBucket, fileName)
    # print(getObjectDetails(eventBucket, fileName))
    if (getObjectDetails(eventBucket, fileName)):
        # A_B and default process
        if (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "cx-s3-uat.corenet.gov.sg"):
            metadataBucket = "sst-s3-bca-cnxcp-uat-fhq-safe-internet"
            scanningBucket = "sst-s3-bca-cnxcp-uat-fhq-scanning"
            createNewTags(eventBucket, fileName, "zone", "internet")
            copyS3Object(eventBucket, metadataBucket, fileName)
            copyS3Object(eventBucket, scanningBucket, fileName)
            deleteS3Object(eventBucket, fileName)
            logger.info(logPoster(eventBucket, fileName, "Success"))

        elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "sftp-a1-bucket"):
            metadataBucket = "a1-s3-bucket-jn"
            createNewTags(eventBucket, fileName, "zone", "sftp")
            copyS3ObjectWithNewName(eventBucket, metadataBucket, fileName)
            deleteS3Object(eventBucket, fileName)
            logger.info(logPoster(eventBucket, fileName, "Success"))
            
        elif (eventName == "PutObjectTagging" and eventBucket == "sst-s3-bca-cnxcp-uat-fhq-scanning"):
            zoneTag = getTagsDetails(eventBucket, fileName, "zone")
            if zoneTag == "Intranet" or zoneTag == "intranet":
                destinationBucket = "sst-s3-bca-cnxcp-uat-fhq-safe-intranet"
                updationTags = getTags(eventBucket, fileName)
                updateTags(destinationBucket, fileName, updationTags)
                deleteS3Object(eventBucket, fileName)
                logger.info(logPoster(eventBucket, fileName, "Success"))
            else:
                destinationBucket = "sst-s3-bca-cnxcp-uat-fhq-safe-internet"
                updationTags = getTags(eventBucket, fileName)
                updateTags(destinationBucket, fileName, updationTags)
                deleteS3Object(eventBucket, fileName)
                logger.info(logPoster(eventBucket, fileName, "Success"))

        elif (eventName == "PutObjectTagging" and eventBucket == "sst-s3-bca-cnxcp-uat-fhq-safe-internet"):
            successBucket = "sst-s3-bca-cnxcp-uat-fhq-safe-intranet"
            failureBucket = "sst-s3-bca-cnxcp-uat-fhq-quarantine-internet"

            if "A_C" in fileName:
                getTagValue = getTagsDetails(eventBucket, fileName, 'fss-scan-result')
                if 'no issues found' == getTagValue:
                    copyS3Object(eventBucket, successBucket, fileName)
                    deleteS3Object(eventBucket, fileName)
                    logger.info(logPoster(eventBucket, fileName, "Success"))
                else:
                    copyS3Object(eventBucket, failureBucket, fileName)
                    logger.info(logPoster(eventBucket, fileName, "scan tag Failure"))

            elif "A_B" in fileName:
                getTagValue = getTagsDetails(eventBucket, fileName, 'fss-scan-result')
                if 'no issues found' == getTagValue:
                    copyS3Object(eventBucket, successBucket, fileName)
                    logger.info(logPoster(eventBucket, fileName, "Success"))
                else:
                    copyS3Object(eventBucket, failureBucket, fileName)
                    logger.info(logPoster(eventBucket, fileName, "scan tag Failure"))
            else:
                getTagValue = getTagsDetails(eventBucket, fileName, 'fss-scan-result')
                if 'no issues found' == getTagValue:
                    copyS3Object(eventBucket, successBucket, fileName)
                    logger.info(logPoster(eventBucket, fileName, "Success"))
                else:
                    copyS3Object(eventBucket, failureBucket, fileName)
                    logger.info(logPoster(eventBucket, fileName, "scan tag Failure"))
        # B_C
        elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "sst-s3-bca-cnxcp-uat-fhq-safe-internet"):
            successBucket = "sst-s3-bca-cnxcp-uat-fhq-safe-intranet"
            copyS3Object(eventBucket, successBucket, fileName)
            updationTags = [{'Key': 'fss-scan-result','Value': 'no issues found'}, {'Key': 'zone', 'Value': 'internet'}]
            updateTags(successBucket, fileName, updationTags)
            logger.info(logPoster(eventBucket, fileName, "Success"))
        else:
            logger.error(logPoster(eventBucket, fileName, "condition mismatch for processing"))
    else:
        logger.error(logPoster(eventBucket, fileName, "unknown events"))