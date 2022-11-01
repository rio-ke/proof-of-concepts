

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
            "objectLists": listOfObjects,
            "Action": True
        })
    else:
        return json.dumps({
            "Alert": False,
            "objectLists": listOfObjects,
            "Action": False
        })

def lambda_handler(event, context):
    print(findObjectMoreThan6Hours(BUCKET))

```
