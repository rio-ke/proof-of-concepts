

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

b2 lambda


```py
import json
import boto3

snsClient = boto3.client('sns')

snsArn="arn:aws:sns:ap-south-1:653413855845:b3-sns.fifo"

def lambda_handler(event, context):
    response = snsClient.publish(MessageGroupId="stageTwo",TargetArn=snsArn, Message=json.dumps({'default': json.dumps(event)}), MessageStructure='json')
    print(response)
    return response
```

b5 lambda

```py
import boto3
import json
import urllib

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')

destination_bucket_name = "abc1-bucket-s3"
sqsUrl="https://sqs.ap-south-1.amazonaws.com/653413855845/b4-sqs.fifo"

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

def getTags(buckeName, fileName):
    tag = s3Client.get_object_tagging(Bucket=buckeName, Key=fileName)
    return tag['TagSet']

def getObjectDetails(buckeName, fileName):
    results = s3Client.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in results

def lambda_handler(event, context):
    s3ObjectIdentifier = findS3EventObjectFromS3(event)
    if s3ObjectIdentifier != []:
        for s3 in s3ObjectIdentifier:
            fileName = urllib.parse.unquote_plus(s3['object']['key'])
            sourceBucketName = urllib.parse.unquote_plus(s3['bucket']['name'])
            getObjectAvailable = getObjectDetails(sourceBucketName, fileName)
            if getObjectAvailable == True:
                updationTags = getTags(sourceBucketName, fileName)
                s3Client.put_object_tagging(Bucket=destination_bucket_name,Key=fileName,Tagging={ 'TagSet': updationTags })
                print(f' => {fileName} tag has been updated to {destination_bucket_name} bucket')
                # s3Client.delete_object(Bucket=sourceBucketName, Key=fileName)
                # print(f' <= {fileName} has been deleted from {sourceBucketName} bucket')
                
    queueIdentifier = findReceiptHandle(event)
    if queueIdentifier != []:
        for queue in queueIdentifier:
            deleteQueueMessage(sqsUrl, queue)
```

c2 lambda

```
import json
import boto3

snsClient = boto3.client('sns')

snsArn="arn:aws:sns:ap-south-1:653413855845:c3-sns.fifo"

def lambda_handler(event, context):
    response = snsClient.publish(MessageGroupId="stagethree",TargetArn=snsArn, Message=json.dumps({'default': json.dumps(event)}), MessageStructure='json')
    return response
```

c6 lambda

```py
import requests
import json
import boto3
import datetime
import urllib

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')

# Read as Environment variable
apiGatewayUrl="https://n37xuqka77.execute-api.ap-south-1.amazonaws.com/dev/"
sqsUrl="https://sqs.ap-south-1.amazonaws.com/653413855845/c4-sqs.fifo"

apiGatewayId="td6rfssqf2"
success_destination_bucket_name="c7-bucket-s3"
failed_destination_bucket_name="c7-bucket-s3"

# alertSqsQueueURL=""

# def pushResultsToQueue(queue_url, file_path, scan_result):
#     scanner_status = 'Generated by the scan-to-final-bucket lambda.'
#     queue_message = {
#         "timestamp": datetime.now().isoformat(timespec='seconds'),
#         "scanner_status": scanner_status,
#         "file_path": file_path,
#         "scan_result": scan_result
#     }
#     json_messsage = json.dumps(queue_message)
#     return sqsClient.send_message(QueueUrl=queue_url, MessageBody=json_messsage)


# def checkSumIntegrity (sourceBucket, destinationBucket, filename):
#     s3Client = boto3.client('s3')
#     source = s3Client.get_object(Bucket=sourceBucket,ChecksumMode='ENABLED', Key=filename)
#     destination = s3Client.get_object(Bucket=destinationBucket, ChecksumMode='ENABLED', Key=filename)
#     sourceCheckpoint = 'ChecksumSHA256' in source.keys()
#     destinationCheckpoint = 'ChecksumSHA256' in destination.keys()

#     if (sourceCheckpoint == True and destinationCheckpoint== True):
#         if (source['ChecksumSHA256'] == destination['ChecksumSHA256']):
#             return True
#         else:
#             return False
#     else:
#         return False


def deleteQueueMessage(sqsUrl, ReceiptHandle):
    return sqsClient.delete_message(QueueUrl=sqsUrl,ReceiptHandle=ReceiptHandle)

def lambda_handler(event, context):
    while True:
        res = requests.get(apiGatewayUrl)
        if res.status_code == 200:
            stageOne = res.json()
            if stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'] == None:
                print(f' <=> No messages received')
                break
            else:
                stageTwo = stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'][0]['Body']
                stageThree = json.loads(stageTwo)
                checkEvent = 'Records' in stageThree.keys()
                if checkEvent == True:
                    s3Data=stageThree['Records'][0]['s3']
                    file_name = urllib.parse.unquote_plus(s3Data['object']['key'])
                    source_bucket_name = urllib.parse.unquote_plus(s3Data['bucket']['name'])
                    copy_object = {'Bucket': source_bucket_name, 'Key': file_name}
                    try:
                        tags = s3Client.get_object_tagging(Bucket=source_bucket_name, Key=file_name)
                        data = tags['TagSet']
                        output_dict = [x for x in data if x['Key'] == 'fss-scan-result']
                        if 'no issues found' == output_dict[0]['Value']:
                            s3Client.copy_object(CopySource=copy_object, Bucket=success_destination_bucket_name, Key=file_name)
                            print(f' => {file_name} object has been copied to { success_destination_bucket_name } bucket')
                            s3Client.delete_object(Bucket=source_bucket_name, Key=file_name)
                            print(f' <= {file_name} object has been deleted from { source_bucket_name } bucket')
                            # pushResultsToQueue(alertSqsQueueURL,file_name, "Scan Success")
                        else:
                            s3Client.copy_object(CopySource=copy_object, Bucket=failed_destination_bucket_name, Key=file_name)
                            print(f' => {file_name} object has been copied to { failed_destination_bucket_name } bucket')
                            s3Client.delete_object(Bucket=source_bucket_name, Key=file_name)
                            print(f' <= {file_name} object has been deleted from { source_bucket_name } bucket')
                    except:
                        print(f' <=> {file_name} Queue is available but s3 object has been moved previous run')

                    ReceiptHandle=stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'][0]['ReceiptHandle']
                    deleteQueueMessage(sqsUrl,ReceiptHandle)
                    print(f' <= {file_name} queue has been deleted from sqs')
                else:
                    print(f' <=> No records received')
        else:
            print(f' <=> Something wrong in apiGateway endpoint')
            break
```
