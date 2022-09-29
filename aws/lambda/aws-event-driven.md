

s3 event publish to sns
```py
import json
import boto3

snsClient = boto3.client('sns')
snsArn="arn:aws:sns:ap-south-1:653413855845:a3-sns.fifo"
def lambda_handler(event, context):
    response = snsClient.publish(MessageGroupId="stageone", TargetArn=snsArn, Message=json.dumps({'default': json.dumps(event)}), MessageStructure='json')
    print(f' <= event published to sns')
```

sns.fifo publish to sqs.fifo

![image](https://user-images.githubusercontent.com/57703276/193088995-840eff86-820a-4552-9094-45245a935098.png)

sns queue to lambda trigger

Require params

* Content-based deduplication
* Deduplication scope 
  * Message group
  * per queue
  
_access policy_
```json
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "SQS:SendMessage",
      "Resource": "arn:aws:sqs:ap-south-1:653413855845:*",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:sns:ap-south-1:653413855845:*"
        }
      }
    }
  ]
}
```

![image](https://user-images.githubusercontent.com/57703276/193089188-eafed6f8-6a4f-42b1-bb41-3ccfbc06b8ff.png)

lambda copy the s3 object from source to another

```py
import boto3
import json
import urllib

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')

#  variable section

destination_bucket_name = 'abc1-bucket-s3'
replication_destination_bucket_name= "b1-bucket-s3"
sqsUrl="https://sqs.ap-south-1.amazonaws.com/653413855845/a4-sqs.fifo"

def deleteQueueMessage(sqsUrl, ReceiptHandle):
    return sqsClient.delete_message(QueueUrl=sqsUrl,ReceiptHandle=ReceiptHandle)

def findReceiptHandle(event):
    receiptHandleList = []
    for i in range(len(event['Records'])):
        receiptHandleList.append(event['Records'][i]['receiptHandle'])
    return receiptHandleList


def findS3EventObjectFromS3(event):
    s3EventObjectFromS3List = []
    for source in range(len(event['Records'])):
        events = json.loads(event['Records'][source]['body'])
        checkEvent = 'Records' in events.keys()
        if checkEvent == True:
            eventsData = json.loads(event['Records'][source]['body'])
            s3CheckPoint = 's3' in eventsData['Records'][0].keys()
            if s3CheckPoint == True:
                s3EventObjectFromS3List.append(events['Records'][0]['s3'])
                
    return s3EventObjectFromS3List

def getObjectDetails(buckeName, fileName):
    results = s3Client.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in results
    
def lambda_handler(event, context):
    s3ObjectIdentifier = findS3EventObjectFromS3(event)
    if s3ObjectIdentifier != []:
        for s3 in s3ObjectIdentifier:
            fileName = urllib.parse.unquote_plus(s3['object']['key'])
            sourceBucketName = urllib.parse.unquote_plus(s3['bucket']['name'])
            copyObject = { 'Bucket': sourceBucketName, 'Key': fileName }
            getObjectAvailable = getObjectDetails(sourceBucketName, fileName)
            if getObjectAvailable == True:
                s3Client.copy_object(CopySource=copyObject, Bucket=destination_bucket_name, Key=fileName)
                s3Client.copy_object(CopySource=copyObject, Bucket=replication_destination_bucket_name, Key=fileName)
                print(f' => {fileName} has been copy to {destination_bucket_name} and {replication_destination_bucket_name} buckets')
                s3Client.delete_object(Bucket=sourceBucketName, Key=fileName)
                print(f' <= {fileName} has been deleted from {sourceBucketName} bucket')
            
    queueIdentifier = findReceiptHandle(event)
    if queueIdentifier != []:
        for queue in queueIdentifier:
            deleteQueueMessage(sqsUrl, queue) 
```
