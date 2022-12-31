_common bucket_

dodo-secret-common

_internet bucket_

`upload - dodo-upload-internet`

```json
{
    "path": "A-B",
    "event": "putObject",
    "eventRule": "dodo-upload-internet-a2b-direction-rule",
    "actioner": "lambda",
    "process": "copy to scan and safe internet buckets"
}
```

`scan - dodo-scan-internet`
    
```json
{
    "path": "*",
    "event": "tagging",
    "eventRule": "dodo-scan-internet-tagging-direction-rule",
    "actioner": "lambda",
    "process": "find as internet or internet tag forward to appropriate location"
}
```

`safe - dodo-safe-internet`

```json
[
    {
        "path": "*",
        "event": "tagging",
        "eventRule": "dodo-scan-internet-tagging-direction-rule",
        "actioner": "lambda",
        "process": "find as internet or internet tag forward to appropriate location"
    },
    {
        "path": "*",
        "event": "putObject",
        "eventRule": "dodo-safe-internet-b2c-direction-rule",
        "actioner": "lambda",
        "process": "find as internet or internet tag forward to appropriate location"
    }
]
```

sftp - dodo-sftp-internet

_dodo-sftp-internet-in-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-sftp-internet"],
      "key": [{
        "prefix": "SFTP/IN"
      }]
    }
  }
}
```
quarantined - dodo-quarantined-internet

`lambda - dodo-lambda-internet`


```py
import json
import re
import os
import pathlib
import boto3
import urllib
import logging
import datetime

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

class eventsCreation():
    def __init__(self, Source, EventBusName,  verbose=False):
        self.events = boto3.client('events')
        self.Source = Source
        self.EventBusName = EventBusName
        self.verbose = verbose
        if self.verbose:
            boto3.set_stream_logger(name="botocore")

    def postEvent(self, bucket, key, action, status):
        return self.events.put_events(
            Entries=[
                {
                    "Source": self.Source,
                    "EventBusName": self.EventBusName,
                    "DetailType": "notification",
                    "Time": datetime.datetime.now(),
                    "Detail": json.dumps({"bucket": bucket,"key": key,"action": action,"status": status})
                }
            ]
        )

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
    _event = eventsCreation("custom.consumer","dodo-pub-sub-event-bus")

    """ If an object exists in the event bucket, it will execute based on conditions."""
    if (_s3.objectState()):

        """ A_B and default process validated"""

        if (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "dodo-upload-internet"):
            safeBucket = "dodo-safe-internet"
            scanBucket = "dodo-scan-internet"
            _s3.createNewTag("zone", "internet")
            _s3.bucketToBucket(safeBucket)
            _event.postEvent(safeBucket, key, "copied", "OK")
            _s3.bucketToBucket(scanBucket)
            _event.postEvent(scanBucket, key, "copied", "OK")
            _s3.delete()
            _event.postEvent(eventBucket, key, "deleted", "OK")

        # elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "sftp-a1-bucket"):
        #     metadataBucket = "a1-s3-bucket-jn"
        #     _s3.createNewTag("zone", "sftp")
        #     _s3.bucketToBucket(metadataBucket, _s3.ignorePathPosition(1))
        #     _s3.delete()

        elif (eventName == "PutObjectTagging" and eventBucket == "dodo-scan-internet"):
            zoneTag = _s3.getSpecificTagDetails("zone")
            if (zoneTag == "Intranet" or zoneTag == "intranet"):
                taggingSafeIntranetBucket = "dodo-safe-intranet"
                _s3.updateTags(taggingSafeIntranetBucket, _s3.getTags())
                _event.postEvent(taggingSafeIntranetBucket, key, "tagging", "OK")
                _s3.delete()
                _event.postEvent(eventBucket, key, "deleted", "OK")
            else:
                taggingSafeInternetBucket = "dodo-safe-internet"
                _s3.updateTags(taggingSafeInternetBucket, _s3.getTags())
                _event.postEvent(taggingSafeInternetBucket, key, "tagging", "OK")
                _s3.delete()
                _event.postEvent(eventBucket, key, "deleted", "OK")

        elif (eventName == "PutObjectTagging" and eventBucket == "dodo-safe-internet"): 
            safeIntranetBucket = "dodo-safe-intranet"
            quarantineInternetBucket = "dodo-quarantined-internet"
            get_tag_value = _s3.getSpecificTagDetails("fss-scan-result")

            if "A_C" in key:
                if 'no issues found' == get_tag_value:
                    _s3.bucketToBucket(safeIntranetBucket)
                    _event.postEvent(safeIntranetBucket, key, "copied", "OK")
                    _s3.delete()
                    _event.postEvent(eventBucket, key, "deleted", "OK")
                else:
                    _s3.bucketToBucket(quarantineInternetBucket)
                    _event.postEvent(quarantineInternetBucket, key, "copied", "OK")

            elif "A_B" in key:
                if 'no issues found' == get_tag_value:
                    _s3.bucketToBucket(safeIntranetBucket)
                    _event.postEvent(safeIntranetBucket, key, "copied", "OK")
                else:
                    _s3.bucketToBucket(quarantineInternetBucket)
                    _event.postEvent(quarantineInternetBucket, key, "copied", "OK")

            else:
                if 'no issues found' == get_tag_value:
                    _s3.bucketToBucket(safeIntranetBucket)
                    _event.postEvent(safeIntranetBucket, key, "copied", "OK")
                else:
                    _s3.bucketToBucket(quarantineInternetBucket)
                    _event.postEvent(quarantineInternetBucket, key, "copied", "OK")

            """ B_C and default process """
        elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "dodo-safe-internet"):
            safeIntranetBucket = "dodo-safe-intranet"
            _s3.bucketToBucket(safeIntranetBucket)
            _event.postEvent(safeIntranetBucket, key, "copied", "OK")
            updationTags = [{'Key': 'fss-scan-result',
                             'Value': 'no issues found'}, {'Key': 'zone', 'Value': 'internet'}]
            _s3.updateTags(safeIntranetBucket, updationTags)
            _event.postEvent(safeIntranetBucket, key, "tagging", "OK")
        else:
            logger.error(_s3.logPoster("condition mismatch for processing"))
    else:
        logger.error(_s3.logPoster("unknown events"))
```

_event rule_

_dodo-upload-internet-a2b-direction-rule_
```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-upload-internet"],
      "key": [{
        "prefix": "A_B"
      }]
    }
  }
}
```
_dodo-scan-internet-tagging-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObjectTagging"],
    "requestParameters": {
      "bucketName": ["dodo-scan-internet"]
    }
  }
}
```

_dodo-safe-internet-tagging-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObjectTagging"],
    "requestParameters": {
      "bucketName": ["dodo-safe-internet"]
    }
  }
}
```

_dodo-safe-internet-b2c-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-safe-internet"],
      "key": [{
        "prefix": "B_C"
      }]
    }
  }
}

```

_intranet_


`upload - dodo-upload-intranet`

```json
{
    "path": "t2",
    "event": "putObject",
    "eventRule": "dodo-upload-intranet-t2-direction-rule",
    "actioner": "lambda",
    "process": "dodo-safe-intranet, dodo-scan-internet, deletion"
}
```

`safe - dodo-safe-intranet`

```json
{
    "path": "C_BA",
    "event": "putObject",
    "eventRule": "dodo-safe-intranet-c2ba-direction-rule",
    "actioner": "lambda",
    "process": "dodo-safe-internet, dodo-upload-internet, no deletion process"
}
```


`sftp - dodo-sftp-intranet` 

```json
{
    "path": "D_C",
    "event": "putObject",
    "eventRule": "dodo-sftp-intranet-d2c-direction-rule",
    "actioner": "lambda",
    "process": "dodo-safe-intranet, dodo-scan-internet, deletion"
}
```

final - dodo-final-intranet
quarantined - dodo-quarantined-intranet


`lambda - dodo-lambda-intranet`

```py
import json
import re
import pathlib
import boto3
import urllib
import logging
import datetime


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
        self.s3.meta.client.download_file(self.bucket, self.key, downloadLocation)
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
        tag = self.s3Client.get_object_tagging(Bucket=self.bucket, Key=self.key)
        return tag['TagSet']

    def getSpecificTagDetails(self, t_name):
        tags = self.s3Client.get_object_tagging(Bucket=self.bucket, Key=self.key)
        data = tags['TagSet']
        print(data)
        if data == []:
            return False
        else:
            for element in data:
                if element['Key'] == t_name:
                    return element['Value']
            return False

    def updateTags(self, destinationBucket=None,updationTags=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        updationTagLists = updationTags if updationTags != None else self.getTags()
        return self.s3Client.put_object_tagging(Bucket=targetBucket, Key=self.key, Tagging={'TagSet': updationTagLists})

    def logPoster(self, state):
        return json.dumps({'Bucket': self.bucket, 'fileName': self.key, 'processState': state})

    def ignorePathPosition(self, pathPosition):
        data = re.split(r'/', self.key)
        return ("/".join(data[pathPosition:]))

class eventsCreation():
    def __init__(self, Source, EventBusName,  verbose=False):
        self.events = boto3.client('events')
        self.Source = Source
        self.EventBusName = EventBusName
        self.verbose = verbose
        if self.verbose:
            boto3.set_stream_logger(name="botocore")

    def postEvent(self, bucket, key, action, status):
        return self.events.put_events(
            Entries=[
                {
                    "Source": self.Source,
                    "EventBusName": self.EventBusName,
                    "DetailType": "notification",
                    "Time": datetime.datetime.now(),
                    "Detail": json.dumps({"bucket": bucket,"key": key,"action": action,"status": status})
                }
            ]
        )
        
def lambda_handler(event, context):
    
    """ Event Capture process"""
    
    eventName = event['detail']['eventName']
    eventBucket = urllib.parse.unquote_plus(event['detail']['requestParameters']['bucketName'])
    key = urllib.parse.unquote_plus(event['detail']['requestParameters']['key'])

    """ Logger initiate process"""
    
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    """ Class initiate process"""
    _s3 = s3Process(eventBucket, key)
    _event = eventsCreation("custom.consumer","dodo-pub-sub-event-bus")
    
    """ If an object exists in the event bucket, it will execute based on conditions."""
    if (_s3.objectState()):

        """ C_BA process validated"""
        if (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "dodo-safe-intranet"):
            safeBucket = "dodo-safe-internet"
            uploadBucket = "dodo-upload-internet"
            _s3.createNewTag("zone", "intranet")
            _s3.bucketToBucket(safeBucket)
            _event.postEvent(safeBucket, key, "copied", "OK")
            _s3.bucketToBucket(uploadBucket)
            _event.postEvent(uploadBucket, key, "copied", "OK")


            """ t2 process validated"""
        elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "dodo-upload-intranet"):
            scanBucket = "dodo-scan-internet"
            safeBucket = "dodo-safe-intranet"
            _s3.createNewTag("zone", "intranet")
            _s3.bucketToBucket(scanBucket)
            _event.postEvent(scanBucket, key, "copied", "OK")
            _s3.bucketToBucket(safeBucket)
            _event.postEvent(safeBucket, key, "copied", "OK")
            _s3.delete()
            _event.postEvent(eventBucket, key, "deleted", "OK")

            """ SFTP(D_C) process validated"""
        elif (eventName == "PutObject" or eventName == "CompleteMultipartUpload") and (eventBucket == "dodo-sftp-intranet"):
            scanBucket = "dodo-scan-internet"
            safeBucket = "dodo-safe-intranet"
            _s3.createNewTag("zone", "intranet")
            _s3.bucketToBucket(scanBucket)
            _event.postEvent(scanBucket, key, "copied", "OK")
            _s3.bucketToBucket(safeBucket)
            _event.postEvent(safeBucket, key, "copied", "OK")
            _s3.delete()
            _event.postEvent(eventBucket, key, "deleted", "OK")

        # elif (eventName == "PutObjectTagging" and eventBucket == "dodo-safe-intranet"):
        #     destinationBucket = "a3-s3-bucket-success"
        #     _s3.updateTags(destinationBucket, _s3.getTags())
        #     _s3.delete()

        else:
            logger.error(_s3.logPoster("condition mismatch for processing"))
    else:
        logger.error(_s3.logPoster("unknown events"))
```

_intranet event rule_

_dodo-upload-intranet-t2-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-upload-intranet"],
      "key": [{
        "prefix": "t2"
      }]
    }
  }
}

```

_dodo-safe-intranet-c2ba-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-safe-intranet"],
      "key": [{
        "prefix": "C_BA"
      }]
    }
  }
}
```

_dodo-sftp-intranet-d2c-direction-rule_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["dodo-sftp-intranet"],
      "key": [{
        "prefix": "D_C"
      }]
    }
  }
}
```



_pub-sub flows_

event bus - dodo-pub-sub-event-bus
event-rule - dodo-pub-sub-event-rule

_dodo-pub-sub-event-rule_

```json
{
   "source": ["custom.consumer"],
   "detail-type": ["notification"]
}
```
sns - dodo-sns-publisher-subriber
sqs - dodo-sns-publisher-subriber
lambda - dodo-lambda-publisher-subriber


_sftp process lambda_

```py
import json
import gnupg
import re
import os
import pathlib
import boto3
import urllib
import logging
import datetime

class pgpEnDecrypt():
    # gnuhome temporary location
    tempdir = "/tmp/"

    def __init__(self, nameOfEmail, password=None):
        self.nameOfEmail = nameOfEmail
        self.password = password
        self.gpg = gnupg.GPG(gnupghome=self.tempdir, gpgbinary='/opt/python/gpg', verbose=True )

    def generteGpgKey(self):
        input_data = self.gpg.gen_key_input(name_email=self.nameOfEmail, passphrase=self.password)
        key = self.gpg.gen_key(input_data)
        ascii_armored_public_keys = self.gpg.export_keys(key.fingerprint)
        ascii_armored_private_keys = self.gpg.export_keys(keyids=key.fingerprint, secret=True, passphrase=self.password)
        nameOfExportFile = self.tempdir + re.split(r'@', self.nameOfEmail)[0] + ".asc"

        with open(nameOfExportFile, 'w') as f:
            f.write(ascii_armored_public_keys)
            f.write(ascii_armored_private_keys)

        return nameOfExportFile

    def gpgEncrypt(self, keyFile, encryptFile):
        if self.validationOfSource(encryptFile):
            return {
                "encrytionState": False,
                "status": "Filetype is invalid"
            }
        else:
            keyloads = open(keyFile).read()
            self.gpg.import_keys(keyloads)
            e_output = encryptFile + ".gpg"
            status = self.gpg.encrypt_file(encryptFile, recipients=[self.nameOfEmail], output=e_output)
            return {
                "encrytionState": status.ok,
                "status": status.status,
                "fileStatus": e_output
            }

    def gpgDecrypt(self, keyFile, decryptFile):
        if self.validationOfSource(decryptFile):
            keyloads = open(keyFile).read()
            self.gpg.import_keys(keyloads)
            d_output = os.path.splitext(decryptFile)[0]
            status = self.gpg.decrypt_file(decryptFile, passphrase=self.password, output=d_output)
            return {
                "decrytionState": status.ok,
                "status": status.status,
                "fileStatus": d_output
            }
        else:
            return {
                "decrytionState": False,
                "status": "Filetype is invalid"
            }

    def validationOfSource(self, nameOfFile):
        extensionOfFile = pathlib.Path(nameOfFile).suffix
        if (extensionOfFile == '.asc' or extensionOfFile == '.gpg' or extensionOfFile == '.pgp'):
            return True
        else:
            return False


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
        self.s3.meta.client.download_file(self.bucket, self.key, downloadLocation)
        return downloadLocation
        
    def delete(self, destinationBucket=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        return self.s3Client.delete_object(Bucket=targetBucket, Key=self.key)

    def upload(self, u_key, destinationBucket=None, t_key=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        t_key = t_key if t_key != None else u_key
        return self.s3.meta.client.upload_file(u_key, targetBucket, t_key)

    def bucketToBucket(self, destinationBucket, customLocation=None):
        targetPath = customLocation if customLocation != None else self.key
        source = {'Bucket': self.bucket, 'Key': self.key}
        return self.s3Client.copy_object(CopySource=source, Bucket=destinationBucket, Key=targetPath, TaggingDirective='COPY', ChecksumAlgorithm=self.ChecksumAlgorithm)

    def createNewTag(self, t_name, t_value, t_key=None):
        tagging = {'TagSet': [{'Key': t_name, 'Value': t_value}]}
        t_key = t_key if t_key != None else self.key
        return self.s3Client.put_object_tagging(Bucket=self.bucket, Key=t_key, Tagging=tagging)

    def objectState(self):
        return 'Contents' in self.s3Client.list_objects(Bucket=self.bucket, Prefix=self.key)

    def getTags(self):
        tag = self.s3Client.get_object_tagging(Bucket=self.bucket, Key=self.key)
        return tag['TagSet']

    def getSpecificTagDetails(self, t_name):
        tags = self.s3Client.get_object_tagging(Bucket=self.bucket, Key=self.key)
        data = tags['TagSet']
        if data == []:
            return False
        else:
            for element in data:
                if element['Key'] == t_name:
                    return element['Value']
            return False

    def updateTags(self, destinationBucket=None,updationTags=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        updationTagLists = updationTags if updationTags != None else self.getTags()
        return self.s3Client.put_object_tagging(Bucket=targetBucket, Key=self.key, Tagging={'TagSet': updationTagLists})

    def logPoster(self, state):
        return json.dumps({'Bucket': self.bucket, 'fileName': self.key, 'processState': state})

    def ignorePathPosition(self, pathPosition):
        data = re.split(r'/', self.key)
        return ("/".join(data[pathPosition:]))

class eventsCreation():
    def __init__(self, Source, EventBusName,  verbose=False):
        self.events = boto3.client('events')
        self.Source = Source
        self.EventBusName = EventBusName
        self.verbose = verbose
        if self.verbose:
            boto3.set_stream_logger(name="botocore")

    def postEvent(self, bucket, key, action, status):
        return self.events.put_events(
            Entries=[
                {
                    "Source": self.Source,
                    "EventBusName": self.EventBusName,
                    "DetailType": "notification",
                    "Time": datetime.datetime.now(),
                    "Detail": json.dumps({"bucket": bucket,"key": key,"action": action,"status": status})
                }
            ]
        )
        
        
def lambda_handler(event, context):
    eventName = event['detail']['eventName']
    eventBucket = urllib.parse.unquote_plus(event['detail']['requestParameters']['bucketName'])
    key = urllib.parse.unquote_plus(event['detail']['requestParameters']['key'])

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    _s3 = s3Process(eventBucket, key)
    _event = eventsCreation("custom.consumer","dodo-pub-sub-event-bus")
    
    pgpEmailReceipt = "gino@gmail.com"
    pgpPasswordReceipt = "password"
    _pgp = pgpEnDecrypt(pgpEmailReceipt, pgpPasswordReceipt)

    KEY_BUKCET = "dodo-secret-common"
    agentName = re.split(r'/', key)[2]
    reformationFileName = _s3.ignorePathPosition(3)

    gpgProcessStateLocation = 'SFTP/PROC/' + reformationFileName
    gpgFailedStateLocation = 'SFTP/FAILED/' + reformationFileName

    if (_s3.objectState()):
        
        if (_pgp.validationOfSource(key)):
            keyLocation = s3Process("dodo-secret-common", agentName +".asc").download()
            sourceDownload = _s3.download()
            status = _pgp.gpgDecrypt(keyLocation, sourceDownload)

            if (status['decrytionState']):
                decryptFileName = os.path.splitext(sourceDownload)[0]
                _s3.upload(decryptFileName, eventBucket, gpgProcessStateLocation)
                _event.postEvent(eventBucket, key, "Decryption success and uploaded", "OK")
                _s3.createNewTag("status", "Decrypted", gpgProcessStateLocation)
                _s3.delete()
                _event.postEvent(eventBucket, key, "deleted", "OK")
                os.remove(keyLocation)
                os.remove(sourceDownload)
                os.remove(decryptFileName) 
            else:
                _s3.upload(sourceDownload, eventBucket, gpgFailedStateLocation)
                _s3.createNewTag("status", "Decryption failed", gpgFailedStateLocation)
                _event.postEvent(eventBucket, key, "Decryption Failed and uploaded", "Failed")
                _s3.delete()
                _event.postEvent(eventBucket, key, "deleted", "OK")
                os.remove(keyLocation)
                os.remove(sourceDownload)
        else:
            _s3.createNewTag("status", "Non Encrypted File")
            _s3.bucketToBucket(eventBucket, gpgProcessStateLocation)
            _event.postEvent(eventBucket, key, "copied", "ok")
            _s3.delete()
            _event.postEvent(eventBucket, key, "deleted", "OK")
    else:
        logger.error(_s3.logPoster("unknown events"))
```
