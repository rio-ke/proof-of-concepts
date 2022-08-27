sqs-access-policy

```json
{
  "Version": "2012-10-17",
  "Id": "Policy1651140347168",
  "Statement": [
    {
      "Sid": "Stmt1651140341677",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "*"
    }
  ]
}
```

python script

```py
import requests
import json
import boto3

s3_client = boto3.client('s3')
sqs_client = boto3.client('sqs')

# Read as Environment variable
apiGatewayUrl="https://td6rfssqf2.execute-api.ap-southeast-1.amazonaws.com/dev"
sqsUrl="https://sqs.ap-southeast-1.amazonaws.com/653413855845/dodo"
apiGatewayId="td6rfssqf2"
destinationBucketName="staging-bucket-dodo"

def deleteQueueMessage(sqsUrl, ReceiptHandle):
    return sqs_client.delete_message(QueueUrl=sqsUrl,ReceiptHandle=ReceiptHandle)

def lambda_handler(event, context):
    while True:
        res = requests.get(apiGatewayUrl, headers={"x-apigw-api-id": apiGatewayId})
        if res.status_code == 200:
            stageOne = res.json()
            if stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'] == None:
                print("No messages received.")
                break
            else:
                stageTwo = stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'][0]['Body']
                stageThree = json.loads(stageTwo)
                stageFour = json.loads(stageThree['Message'])
                s3Data=stageFour['Records'][0]['s3']
                source_bucket_name = s3Data['bucket']['name']
                file_name = s3Data['object']['key']
                copy_object = {'Bucket': source_bucket_name, 'Key': file_name}
                print("Copy the source object to destination bucket")
                s3_client.copy_object(CopySource=copy_object, Bucket=destinationBucketName, Key=file_name)
                print("Delete the source object in source bucket")
                s3_client.delete_object(Bucket=source_bucket_name, Key=file_name)
                ReceiptHandle=stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'][0]['ReceiptHandle']
                deleteQueueMessage(sqsUrl,ReceiptHandle)
        else:
            print("something wrong in apiGateway endpoint.")
            break
```
