
```json

```

```py
import boto3
import json
s3_client = boto3.client('s3')

def lambda_handler(event, context):
    metaData=json.dumps(event['Records'][0]['body'])
    messageData = json.loads(metaData)
    messageDataStringConvertor = json.loads(messageData)
    eventData=json.loads(messageDataStringConvertor['Message'])
    s3Data=eventData['Records'][0]['s3']
    source_bucket_name = s3Data['bucket']['name']
    file_name = s3Data['object']['key']
    destination_bucket_name = 'production-bucket-dodo'
    copy_object = {'Bucket': source_bucket_name, 'Key': file_name}

    if source_bucket_name == "s3-bca-prdizgut-staging":
        s3_client.copy_object(CopySource=copy_object, Bucket=destination_bucket_name, Key=file_name)
        s3_client.delete_object(Bucket=source_bucket_name, Key=file_name)
    else:
        print("after tag process..")
        # s3_client.copy_object(CopySource=copy_object, Bucket=destination_bucket_name, Key=file_name)
        # s3_client.delete_object(Bucket=source_bucket_name, Key=file_name)
    return {
        "statusCode": 201,
        "body": {
            "source_bucket_name": source_bucket_name,
            "destination_bucket_name": destination_bucket_name,
            "file_name": file_name,
            "message": 'File has been Successfully Copied and deleted'
        }
    }
```
