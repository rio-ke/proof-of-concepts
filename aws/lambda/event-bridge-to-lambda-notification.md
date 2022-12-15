

```py
import json
import urllib
import boto3
import logging

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


def copyS3Object(eventBucket, destinationBucket, fileName):
    return s3Client.copy_object(CopySource={'Bucket': eventBucket, 'Key': fileName}, Bucket=destinationBucket, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1',)


def deleteS3Object(bucketName, fileName):
    return s3Client.delete_object(Bucket=bucketName, Key=fileName)


def updateTags(bucketName, fileName, updationTags):
    return s3Client.put_object_tagging(Bucket=bucketName, Key=fileName, Tagging={'TagSet': updationTags})


def getTags(bucketName, fileName):
    tag = s3Client.get_object_tagging(Bucket=bucketName, Key=fileName)
    return tag['TagSet']


def lambda_handler(event, context):
    eventName = event['detail']['eventName']
    eventBucket = urllib.parse.unquote_plus(event['detail']['requestParameters']['bucketName'])
    fileName = urllib.parse.unquote_plus(event['detail']['requestParameters']['key'])

    if (getObjectDetails(eventBucket, fileName)):
        # C_B from success bucket
        if (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "dodo-s3-op-un-cnxcp-uat-fhq-safe"):
            successBucket = "dodo-s3-op-un-cnxcp-uat-fhq-safe-internet"
            createNewTags(eventBucket, fileName, "zone", "intranet")
            copyS3Object(eventBucket, successBucket, fileName)
            logger.info(logPoster(eventBucket, fileName, "Success"))

        # t2 from source bucket
        elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "cp-s3-uat.intranet.corenet.gov.sg"):
            destinationBucket = "dodo-s3-op-un-cnxcp-uat-fhq-scanning"
            successBucket = "dodo-s3-op-un-cnxcp-uat-fhq-safe"
            createNewTags(eventBucket, fileName, "zone", "intranet")
            copyS3Object(eventBucket, destinationBucket, fileName)
            copyS3Object(eventBucket, successBucket, fileName)
            deleteS3Object(eventBucket, fileName)
            logger.info(logPoster(eventBucket, fileName, "Success"))

        # SFTP(D_C) from source bucket
        elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "dodo-s3-op-un-cnxcp-uat-sftp-intranet"):
            destinationBucket = "dodo-s3-op-un-cnxcp-uat-fhq-scanning"
            successBucket = "dodo-s3-op-un-cnxcp-uat-fhq-safe"
            createNewTags(eventBucket, fileName, "zone", "intranet")
            copyS3Object(eventBucket, destinationBucket, fileName)
            copyS3Object(eventBucket, successBucket, fileName)
            deleteS3Object(eventBucket, fileName)
            logger.info(logPoster(eventBucket, fileName, "Success"))

        elif (eventName == "PutObjectTagging" and eventBucket == "dodo-s3-op-un-cnxcp-uat-fhq-scanning"):
            destinationBucket = "dodo-s3-op-un-cnxcp-uat-fhq-safe"

            updationTags = getTags(eventBucket, fileName)
            updateTags(destinationBucket, fileName, updationTags)
            deleteS3Object(eventBucket, fileName)
            logger.info(logPoster(eventBucket, fileName, "Success"))

        else:
            logger.error(logPoster(eventBucket, fileName,
                         "condition mismatch for processing"))
    else:
        logger.error(logPoster(eventBucket, fileName, "unknown event failure"))

```
