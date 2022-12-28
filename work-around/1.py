import json
import re
import pathlib
import boto3
import urllib
import logging


class s3Process():
    tempdir = "/tmp/"
    ChecksumAlgorithm = 'SHA256'

    def __init__(self, bucket, key):
        self.bucket = bucket
        self.key = key
        self.s3 = boto3.resource('s3')
        self.s3Client = boto3.client('s3')
        self.parentPath = pathlib.PurePath(self.key).parent
        self.childName = pathlib.PurePath(self.key).name

    def download(self):
        downloadLocation = self.tempdir + self.childName
        self.s3.meta.client.download_file(
            self.bucket, self.key, downloadLocation)
        return downloadLocation

    def delete(self, destinationBucket=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        return self.s3Client.delete_object(Bucket=targetBucket, Key=self.key)

    def upload(self, uploadKey):
        return self.s3.meta.client.upload_file(uploadKey, self.bucket, uploadKey)

    def bucketToBucket(self, destinationBucket, customLocation=None):
        targetPath = customLocation + self.childName if customLocation != None else self.key
        source = {'Bucket': self.bucket, 'Key': self.key}
        return self.s3Client.copy_object(CopySource=source, Bucket=destinationBucket, Key=targetPath, TaggingDirective='COPY', ChecksumAlgorithm=self.ChecksumAlgorithm)

    def createNewTag(self, t_name, t_value):
        tagging = {'TagSet': [{'Key': t_name, 'Value': t_value}]}
        return self.s3Client.put_object_tagging(Bucket=self.bucket, Key=self.key, Tagging=tagging)

    def objectState(self):
        return 'Contents' in self.s3Client.list_objects(Bucket=self.bucket, Prefix=self.key)

    def getTags(self):
        tag = self.s3Client.get_object_tagging(
            Bucket=self.bucket, Key=self.key)
        return tag['TagSet']

    def getSpecificTagDetails(self, t_name):
        tags = self.s3Client.get_object_tagging(
            Bucket=self.bucket, Key=self.key)
        data = tags['TagSet']
        print(data)
        if data == []:
            return False
        else:
            for element in data:
                if element['Key'] == t_name:
                    return element['Value']
            return False

    def updateTags(self, destinationBucket=None, updationTags=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        updationTagLists = updationTags if updationTags != None else self.getTags()
        return self.s3Client.put_object_tagging(Bucket=targetBucket, Key=self.key, Tagging={'TagSet': updationTagLists})

    def logPoster(self, state):
        return json.dumps({'Bucket': self.bucket, 'fileName': self.key, 'processState': state})

    def ignorePathPosition(self, pathPosition):
        data = re.split(r'/', self.key)
        return ("/".join(data[pathPosition:]))


def lambda_handler(event, context):
    """ Event Capture process"""

    eventName = event['detail']['eventName']
    eventBucket = urllib.parse.unquote_plus(
        event['detail']['requestParameters']['bucketName'])
    key = urllib.parse.unquote_plus(
        event['detail']['requestParameters']['key'])

    """ Logger initiate process"""

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    """ Class initiate process"""
    _s3 = s3Process(eventBucket, key)

    """ If an object exists in the event bucket, it will execute based on conditions."""
    if (_s3.objectState()):

        """ C_B process"""
        if (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "sst-s3-bca-cnxcp-uat-fhq-safe"):
            successBucket = "sst-s3-bca-cnxcp-uat-fhq-safe-internet"
            _s3.createNewTag("zone", "intranet")
            _s3.bucketToBucket(successBucket)

            """ t2 process"""
        elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "cp-s3-uat.intranet.corenet.gov.sg"):
            destinationBucket = "sst-s3-bca-cnxcp-uat-fhq-scanning"
            successBucket = "sst-s3-bca-cnxcp-uat-fhq-safe"
            _s3.createNewTag("zone", "intranet")
            _s3.bucketToBucket(destinationBucket)
            _s3.bucketToBucket(successBucket)
            _s3.delete()

            """ SFTP(D_C) process"""
        elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "sst-s3-bca-cnxcp-uat-sftp-intranet"):
            destinationBucket = "sst-s3-bca-cnxcp-uat-fhq-scanning"
            successBucket = "sst-s3-bca-cnxcp-uat-fhq-safe"
            _s3.createNewTag("zone", "intranet")
            _s3.bucketToBucket(destinationBucket)
            _s3.bucketToBucket(successBucket)
            _s3.delete()

        elif (eventName == "PutObjectTagging" and eventBucket == "sst-s3-bca-cnxcp-uat-fhq-scanning"):
            destinationBucket = "sst-s3-bca-cnxcp-uat-fhq-safe"
            _s3.updateTags(destinationBucket, _s3.getTags())
            _s3.delete()

        else:
            logger.error(_s3.logPoster("condition mismatch for processing"))
    else:
        logger.error(_s3.logPoster("unknown events"))
