
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

_output json_

```json
{
    "bucketName": "dsk-b1-bucket-s3",
    "file": "mlutils.py",
    "snsMessage": {
        "MessageId": "17aab225-fbe7-5b56-93fd-e9f8a4f8748a",
        "SequenceNumber": "10000000000000003000",
        "ResponseMetadata": {
            "RequestId": "553e2dde-7982-5709-b760-7603269d68d5",
            "HTTPStatusCode": 200,
            "HTTPHeaders": {
                "x-amzn-requestid": "553e2dde-7982-5709-b760-7603269d68d5",
                "x-amzn-trace-id": "Root=1-63635ca5-63629f38501336fc771dca5f;Parent=2f3d8ab217203164;Sampled=0",
                "content-type": "text/xml",
                "content-length": "352",
                "date": "Thu, 03 Nov 2022 06:17:02 GMT"
            },
            "RetryAttempts": 0
        }
    }
}
```

_search events in cloudwatch_

```conf
{ $.bucketName = "dsk-b1-bucket-s3" }
{ $.file = "mlutils.py" }
```

https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html
