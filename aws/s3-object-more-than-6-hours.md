

```py
from dateutil.tz import tzutc
from datetime import datetime, timedelta
import boto3
import json

BUCKET = 'op-terraform-state-file-1234'

def findObjectMoreThan6Hours(bucketName):
    s3_resource = boto3.resource('s3')
    listOfObjects = []
    for object in s3_resource.Bucket(bucketName).objects.all():
        if object.last_modified < datetime.now(tzutc()) - timedelta(hours=6):
            listOfObjects.append(object.key)
    if listOfObjects != []:
        return json.dumps({
            "Alert": True,
            "Bucket": bucketName,
            "objectLists": listOfObjects,
            "Action": True
        })
    else:
        return json.dumps({
            "Alert": False,
            "Bucket": bucketName,
            "objectLists": listOfObjects,
            "Action": False
        })

def lambda_handler(event, context):
    print(findObjectMoreThan6Hours(BUCKET))
```

_result_

![image](https://user-images.githubusercontent.com/57703276/199409282-3ebbb03f-1c89-45bb-9bfe-6a623859a894.png)


2nd senario

```py
from dateutil.tz import tzutc
from datetime import datetime, timedelta
import boto3
import json

s3Name = 'op-terraform-state-file-1234'


def findObjectMoreThan6HoursIsightFolder(bucketName, folderName):
    s3_resource = boto3.resource('s3')
    Bucket = s3_resource.Bucket(bucketName)

    listOfDirectoryObjects = []
    for object in Bucket.objects.filter(Prefix=folderName + "/"):
        SkipDirectory = folderName + "/"
        if object.key != SkipDirectory:
            if object.last_modified < datetime.now(tzutc()) - timedelta(hours=6):
                listOfDirectoryObjects.append(object.key)

    if listOfDirectoryObjects != []:
        return json.dumps({
            "Alert": True,
            "Bucket": bucketName,
            "objectLists": listOfDirectoryObjects,
            "Action": True
        })
    else:
        return json.dumps({
            "Alert": False,
            "Bucket": bucketName,
            "objectLists": listOfDirectoryObjects,
            "Action": False
        })


def findObjectMoreThan6Hours(bucketName):
    s3_resource = boto3.resource('s3')
    listOfObjects = []
    for object in s3_resource.Bucket(bucketName).objects.all():
        if object.last_modified < datetime.now(tzutc()) - timedelta(hours=6):
            listOfObjects.append(object.key)
    if listOfObjects != []:
        return json.dumps({
            "Alert": True,
            "Bucket": bucketName,
            "objectLists": listOfObjects,
            "Action": True
        })
    else:
        return json.dumps({
            "Alert": False,
            "Bucket": bucketName,
            "objectLists": listOfObjects,
            "Action": False
        })


def lambda_handler(event, context):
    print(findObjectMoreThan6Hours(s3Name))
    print(findObjectMoreThan6HoursIsightFolder(s3Name, "demo"))

```
