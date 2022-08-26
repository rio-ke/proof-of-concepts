

```py
import requests
import json
import boto3

s3_client = boto3.client('s3')
sqs_client = boto3.client('sqs')

apiGatewayUrl="https://td6rfssqf2.execute-api.ap-southeast-1.amazonaws.com/dev"
sqsUrl="https://sqs.ap-southeast-1.amazonaws.com/653413855845/dodo"
apiGatewayId="td6rfssqf2"
destinationBucketName="staging-bucket-dodo"

def deleteQueueMessage(sqsUrl, ReceiptHandle):
    return sqs_client.delete_message(QueueUrl=sqsUrl,ReceiptHandle=ReceiptHandle)

def readTheMessageFromQueue(apiGatewayUrl,apiGatewayId,destinationBucketName):
    res = requests.get(apiGatewayUrl, headers={"x-apigw-api-id": apiGatewayId})
    if res.status_code == 200:
        stageOne = res.json()
        if stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'] == None:
            print("No messages received.")
            return False
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
            return True
    else:
        print("something wrong in apiGateway endpoint.")
        return False
        

def lambda_handler(event, context):
    loop = readTheMessageFromQueue(apiGatewayUrl,apiGatewayId,destinationBucketName)
    while loop:
        if loop == True:
            readTheMessageFromQueue(apiGatewayUrl,apiGatewayId,destinationBucketName)
        else:
            print("loop Process exited code 1")
```

while-loop

```py
while True:
    import requests
    apiGatewayUrl = "https://td6rfssqf2.execute-api.ap-southeast-1.amazonaws.com/dev"
    res = requests.get(apiGatewayUrl)
    data = res.json()
    status = data['ReceiveMessageResponse']['ReceiveMessageResult']['messages']
    print(status)
    if status == None:
        break
```
