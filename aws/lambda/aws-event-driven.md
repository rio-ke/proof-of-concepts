
```bash
mkdir python
cd python/
mkdir python
pip3 install --target ./python boto3
zip -r boto3.zip python
rm -rf python/
mkdir python
pip3 install --target ./python requests
zip -r requests.zip python
```

s3 event publish to sns
```py
import json
import boto3

snsClient = boto3.client('sns')

snsArn="arn:aws:sns:ap-south-1:653413855845:a3-sns.fifo"

def lambda_handler(event, context):
    modifiedEvents = event['Records']
    extraAttribute = { "zone": "internet" }
    [rearrange.update(extraAttribute) for rearrange in modifiedEvents]
    response = snsClient.publish(MessageGroupId="stageone", TargetArn=snsArn, Message=json.dumps({'default': json.dumps(modifiedEvents)}), MessageStructure='json')
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
import json
import urllib
import sys

from pip._internal import main
main(['install', '-I', '-q', 'boto3', '--target', '/tmp/', '--no-cache-dir', '--disable-pip-version-check'])
sys.path.insert(0,'/tmp/')

import boto3

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')

# VARIABLE SECTION
destination_bucket_name = 'abc1-bucket-s3'
replication_destination_bucket_name= "b1-bucket-s3"
sqsUrl="https://sqs.ap-south-1.amazonaws.com/653413855845/a4-sqs.fifo"

def deleteQueueMessage(sqsUrl, ReceiptHandle):
    return sqsClient.delete_message(QueueUrl=sqsUrl,ReceiptHandle=ReceiptHandle)

def findS3EventObjectFromS3(event):
    s3EventObjectFromS3List = []
    checkEvent = 'Records' in event.keys()
    if checkEvent == True:
        for source in range(len(event['Records'])):
            actualData = json.loads(event['Records'][source]['body'])
            receiptHandle = event['Records'][source]['receiptHandle']
            s3Event = actualData[0]['s3']
            zone = actualData[0]['zone']
            data = {'s3': s3Event, 'zone': zone, "receiptHandle": receiptHandle}
            s3EventObjectFromS3List.append(data)
    return s3EventObjectFromS3List    

def getObjectDetails(buckeName, fileName):
    results = s3Client.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in results
    
def lambda_handler(event, context):
    s3ObjectIdentifier = findS3EventObjectFromS3(event)
    if s3ObjectIdentifier != []:
        for s3 in s3ObjectIdentifier:
            fileName = urllib.parse.unquote_plus(s3['s3']['object']['key'])
            sourceBucketName = urllib.parse.unquote_plus(s3['s3']['bucket']['name'])
            fileZone = s3['zone']
            queueId = s3['receiptHandle']
            copyObject = { 'Bucket': sourceBucketName, 'Key': fileName }
            
            getObjectAvailable = getObjectDetails(sourceBucketName, fileName)
            if getObjectAvailable == True:
                tagging = {'TagSet' : [{'Key': 'zone', 'Value': fileZone }]}
                s3Client.put_object_tagging(Bucket=sourceBucketName,Key=fileName, Tagging=tagging)
                print(f' <= {fileName} file has been tagged in {sourceBucketName} bucket')
                s3Client.copy_object(CopySource=copyObject, Bucket=destination_bucket_name, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1',)
                s3Client.copy_object(CopySource=copyObject, Bucket=replication_destination_bucket_name, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1')
                print(f' => {fileName} file has been copy to {destination_bucket_name} and {replication_destination_bucket_name} buckets')
                s3Client.delete_object(Bucket=sourceBucketName, Key=fileName)
                print(f' <= {fileName} file has been deleted from {sourceBucketName} bucket')
                deleteQueueMessage(sqsUrl, queueId)
                print(f' <= {fileName} queue has been deleted')
            else:
                deleteQueueMessage(sqsUrl, queueId)
                print(f' <= {fileName} queue has been deleted')
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
sqsUrl = "https://sqs.ap-south-1.amazonaws.com/653413855845/b4-sqs.fifo"


def deleteQueueMessage(sqsUrl, ReceiptHandle):
    return sqsClient.delete_message(QueueUrl=sqsUrl, ReceiptHandle=ReceiptHandle)

def findS3EventObjectFromS3(event):
    s3EventObjectFromS3List = []
    checkEvent = 'Records' in event.keys()
    if checkEvent == True:
        for source in (event['Records']):
            receiptHandle = source['receiptHandle']
            actualData = json.loads(source['body'])
            s3Event = actualData['Records'][0]['s3']
            data = {'s3': s3Event, "receiptHandle": receiptHandle}
            s3EventObjectFromS3List.append(data)

    return s3EventObjectFromS3List


def getObjectDetails(buckeName, fileName):
    results = s3Client.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in results


def getTags(buckeName, fileName):
    tag = s3Client.get_object_tagging(Bucket=buckeName, Key=fileName)
    return tag['TagSet']


def lambda_handler(event, context):
    s3ObjectIdentifier = findS3EventObjectFromS3(event)
    if s3ObjectIdentifier != []:
        for s3 in s3ObjectIdentifier:
            fileName = urllib.parse.unquote_plus(s3['s3']['object']['key'])
            sourceBucketName = urllib.parse.unquote_plus(s3['s3']['bucket']['name'])
            queueId = s3['receiptHandle']
            sourceGetObjectAvailable = getObjectDetails(sourceBucketName, fileName)
            targetGetObjectAvailable = getObjectDetails(sourceBucketName, fileName)

            if sourceGetObjectAvailable == True or targetGetObjectAvailable == True:
                updationTags = getTags(sourceBucketName, fileName)
                s3Client.put_object_tagging(Bucket=destination_bucket_name, Key=fileName, Tagging={'TagSet': updationTags})
                s3Client.delete_object(Bucket=sourceBucketName, Key=fileName)
                deleteQueueMessage(sqsUrl, queueId)
                print(json.dumps({
                    "file": file_name,
                    "sourceBucket": sourceBucketName,
                    "destinationBucket": destination_bucket_name,
                    "queueMessageDeleteStatus": True,
                    "tagUpdate": True,
                    "copyStatus": True,
                    "deleteQueueMessageStatus": True
                }))
            else:
                deleteQueueMessage(sqsUrl, queueId)
                print(f' <= {fileName} queue has been deleted')
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

option 2

```py
import requests
import json
import datetime
import urllib
import sys
from pip._internal import main

main(['install', '-I', '-q', 'boto3', '--target', '/tmp/', '--no-cache-dir', '--disable-pip-version-check'])
sys.path.insert(0,'/tmp/')

import boto3

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')

# Read as Environment variable
apiGatewayUrl="https://n37xuqka77.execute-api.ap-south-1.amazonaws.com/dev/"
sqsUrl="https://sqs.ap-south-1.amazonaws.com/653413855845/c4-sqs.fifo"

apiGatewayId="td6rfssqf2"
originBucketName = "a1-bucket-s3"
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


def checkSumIntegrity(sourceBucket, destinationBucket, filename):
    s3Client = boto3.client('s3')
    source = s3Client.get_object(Bucket=sourceBucket, ChecksumMode='ENABLED', Key=filename)
    destination = s3Client.get_object(Bucket=destinationBucket, ChecksumMode='ENABLED', Key=filename)
    sourceCheckpoint = 'ChecksumSHA1' in source.keys()
    destinationCheckpoint = 'ChecksumSHA1' in destination.keys()
    if (sourceCheckpoint == True and destinationCheckpoint== True):
        if (source['ChecksumSHA1'] == destination['ChecksumSHA1']):
            return True
        else:
            return False
    else:
        return False


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
                            s3ObjectChecksum = checkSumIntegrity(originBucketName, source_bucket_name, file_name)
                            if (s3ObjectChecksum ==  True):
                                s3Client.copy_object(CopySource=copy_object, Bucket=success_destination_bucket_name, Key=file_name, ChecksumMode='ENABLED')
                                print(f' => {file_name} object has been copied to { success_destination_bucket_name } bucket')
                                s3Client.delete_object(Bucket=source_bucket_name, Key=file_name)
                                print(f' <= {file_name} object has been deleted from { source_bucket_name } bucket')
                            else:
                                s3Client.copy_object(CopySource=copy_object, Bucket=failed_destination_bucket_name, Key=file_name, ChecksumMode='ENABLED')
                                print(f' => {file_name} object has been copied to { failed_destination_bucket_name } bucket')
                                s3Client.delete_object(Bucket=source_bucket_name, Key=file_name)
                                print(f' <= {file_name} object has been deleted from { source_bucket_name } bucket')
                        else:
                            s3Client.copy_object(CopySource=copy_object, Bucket=failed_destination_bucket_name, Key=file_name, ChecksumMode='ENABLED')
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
