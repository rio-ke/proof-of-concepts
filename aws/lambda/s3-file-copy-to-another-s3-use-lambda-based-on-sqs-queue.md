
```json

```

```py
import boto3
import json
s3_client = boto3.client('s3')

def lambda_handler(event, context):
    source_bucket_name = event['Records'][0]['body']['Message']['Records'][0]['s3']['bucket']['name']
    file_name = event['Records'][0]['body']['Message']['Records'][0]['s3']['object']['key']
    destination_bucket_name = 'production-bucket-dodo'
    copy_object = {'Bucket': source_bucket_name, 'Key': file_name}

    if source_bucket_name == "s3-bca-prdizgut-xxx":
        s3_client.copy_object(CopySource=copy_object, Bucket=destination_bucket_name, Key=file_name)
        s3_client.delete_object(Bucket=source_bucket_name, Key=file_name)
    else:
        print("after tag process..")
        # s3_client.copy_object(CopySource=copy_object, Bucket=destination_bucket_name, Key=file_name)
        # s3_client.delete_object(Bucket=source_bucket_name, Key=file_name)
    return {
        'statusCode': 201,
        'body': json.dumps({
            "source_bucket_name": source_bucket_name,
            "destination_bucket_name": destination_bucket_name,
            "file_name": file_name,
            "message": 'File has been Successfully Copied and deleted'
        })
    }
```
