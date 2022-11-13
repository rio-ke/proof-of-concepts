
_event object_

```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["jn-logs-s3"]
    }
  }
}
```
_lambda code_

```py
import json

def findBuckeAndfileName(event):
    s3Events = event['detail']['requestParameters']
    bucketName=s3Events['bucketName']
    fileName=s3Events['key']
    return json.dumps({'bucketName': bucketName, 'fileName': fileName})
    
def lambda_handler(event, context):
    print(findBuckeAndfileName(event))
```
