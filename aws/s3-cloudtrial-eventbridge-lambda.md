
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
_lambda direct call from eventbridge_

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


_event bridge message sent to sqs and trigger the lambda_

```py
import json
import urllib
        
def findS3EventObject(event):
    listOfObjetcts = []
    checkEvent = 'Records' in event.keys()
    if checkEvent == True:
        for source in range(len(event['Records'])):
            reformedListRecord = event['Records'][source]
            reformedBody       = json.loads(reformedListRecord["body"])
            reformedMessageList= json.dumps(reformedBody)
            reformedMessage    = json.loads(reformedMessageList)
            receiptHandle      = reformedListRecord['receiptHandle']
            s3Event            = reformedMessage['detail']['requestParameters']
            object             = json.dumps({'s3': s3Event, "receiptHandle": receiptHandle})
            listOfObjetcts.append(object)
    return listOfObjetcts


def lambda_handler(event, context):
    json.dumps(event, indent=3)
    s3ObjectIdentifier = findS3EventObject(event)
    if s3ObjectIdentifier != []:
        for s3 in s3ObjectIdentifier:
            s3Data = json.loads(s3)
            sourceBucketName = urllib.parse.unquote_plus(s3Data['s3']['bucketName'])
            fileName = urllib.parse.unquote_plus(s3Data['s3']['key'])
            receiptHandle = s3Data['receiptHandle']
            print(json.dumps({ 'Bucket': sourceBucketName, 'fileName': fileName, 'receiptHandle': receiptHandle }))
```
