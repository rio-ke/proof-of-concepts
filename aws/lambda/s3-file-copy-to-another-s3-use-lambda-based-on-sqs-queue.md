
```json

```

```py
import boto3
import json
import time
import logging
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

    safe_destination_bucket_name = "destination_bucket_name"
    if source_bucket_name == "s3-bca-prdizgut-xxx":
        logging.info("Copy the source object to destination bucket")
        s3_client.copy_object(CopySource=copy_object, Bucket=destination_bucket_name, Key=file_name)
        time.sleep(2)
        logging.info("Delete the source object in source bucket")
        s3_client.delete_object(Bucket=source_bucket_name, Key=file_name)
    else:
        tags = s3_client.get_object_tagging(Bucket=source_bucket_name, Key=file_name)
        print(tags)
        data = tags['TagSet']
        output_dict = [x for x in data if x['Key'] == 'fss-scan-result']
        output_dict[0]['Value']
        if 'no issues found' == output_dict[0]['Value']:
            logging.info("Copy the source object to destination bucket")
            s3_client.copy_object(CopySource=copy_object, Bucket=safe_destination_bucket_name, Key=file_name)
            time.sleep(2)
            logging.info("Delete the source object in source bucket")
            s3_client.delete_object(Bucket=source_bucket_name, Key=file_name)
        else:
            # s3_client.copy_object(CopySource=copy_object, Bucket=failed_destination_bucket_name, Key=file_name)
            logging.info("Delete the source object in source bucket")
            s3_client.delete_object(Bucket=source_bucket_name, Key=file_name)

    return {
        "statusCode": 201,
        "body": {
            "source_bucket_name": source_bucket_name,
            "destination_bucket_name": destination_bucket_name,
            "file_name": file_name,
            "message": 'File processed successfully'
        }
    }

```
