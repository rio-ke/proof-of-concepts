
_1st example_

```py
import json
import boto3
import os
import urllib

snsClient = boto3.client('sns')
_infraZone = os.environ['infraZone']
snsArn = os.environ['snsArn']

def lambda_handler(event, context):
    modifiedEvents = event['Records']
    s3Data = modifiedEvents[0]
    fileName = urllib.parse.unquote_plus(s3Data['s3']['object']['key'])
    sourceBucketName = urllib.parse.unquote_plus(s3Data['s3']['bucket']['name'])
    extraAttribute = {"zone": _infraZone}
    [rearrange.update(extraAttribute) for rearrange in modifiedEvents]
    returnResponse = snsClient.publish(MessageGroupId="stageone", TargetArn=snsArn, Message=json.dumps(
        {'default': json.dumps(modifiedEvents)}), MessageStructure='json')
    print(json.dumps({ "bucketName" : sourceBucketName, "file": fileName, "snsMessage" : returnResponse}))
```

_2nd example_

```py
import json
import boto3
import os
import urllib

snsClient = boto3.client('sns')
snsArn = os.environ['snsArn']

def lambda_handler(event, context):
    modifiedEvents = event['Records']
    s3Data = modifiedEvents[0]
    fileName = urllib.parse.unquote_plus(s3Data['s3']['object']['key'])
    sourceBucketName = urllib.parse.unquote_plus(s3Data['s3']['bucket']['name'])
    
    returnResponse = snsClient.publish(MessageGroupId="stageTwo", TargetArn=snsArn, Message=json.dumps({
        'default': json.dumps(event)}), MessageStructure='json')
    print(json.dumps({ "bucketName" : sourceBucketName, "file": fileName, "snsMessage" : returnResponse}))
```

_3rd example_

```py
import json
import boto3
import os
import urllib

snsClient = boto3.client('sns')

snsArn = os.environ['snsArn']

def lambda_handler(event, context):
    modifiedEvents = event['Records']
    s3Data = modifiedEvents[0]
    fileName = urllib.parse.unquote_plus(s3Data['s3']['object']['key'])
    sourceBucketName = urllib.parse.unquote_plus(s3Data['s3']['bucket']['name'])
    returnResponse = snsClient.publish(MessageGroupId="stagethree", TargetArn=snsArn, Message=json.dumps({
        'default': json.dumps(event)}), MessageStructure='json')
    print(json.dumps({ "bucketName" : sourceBucketName, "file": fileName, "snsMessage" : returnResponse}))

```

_search events in cloudwatch_

```conf
{ $.bucketName = "dsk-b1-bucket-s3" }
```
