## based-on-s3-object-tags-movement-lambda.md

s3 trigger json events for lamda. This json object tags based movement one bucket to another bucket

```json
{
  "Records": [
    {
      "eventVersion": "2.1",
      "eventSource": "aws:s3",
      "awsRegion": "ap-southeast-1",
      "eventTime": "2022-07-31T06:54:20.293Z",
      "eventName": "ObjectCreated:Put",
      "userIdentity": { "principalId": "A3H9EVE2DDNAB9" },
      "requestParameters": { "sourceIPAddress": "49.204.113.169" },
      "responseElements": {
        "x-amz-request-id": "19M5DNJ0952B8HJY",
        "x-amz-id-2": "b93R+PNOtzjViMz5mxq8W1ejFIKcjjRmlBDpvRfHhzxE6NJJm1jOV36cJUkI7fcLNARrPiSsofkQ7xHIR2Q4hSGb6JO9IcBH"
      },
      "s3": {
        "s3SchemaVersion": "1.0",
        "configurationId": "pre-sign-url",
        "bucket": {
          "name": "pre-signed-url-local",
          "ownerIdentity": { "principalId": "A3H9EVE2DDNAB9" },
          "arn": "arn:aws:s3:::pre-signed-url-local"
        },
        "object": {
          "key": "job-one.py",
          "size": 205,
          "eTag": "b5cfdce177d589dd39243adf1cec46e7",
          "sequencer": "0062E6271C43DE0B18"
        }
      }
    }
  ]
}
```

object tag json

```json
{
  "ResponseMetadata": {
    "RequestId": "EQQBG5AS02C03C18",
    "HostId": "rc2asZ+3ecZrmv/f0nxGHDOZ4grPC8PjjLMbXS9PwifC+2hnsQcRlNWFWwaQ4S+CxQi+6jFQMjU=",
    "HTTPStatusCode": 200,
    "HTTPHeaders": {
      "x-amz-id-2": "rc2asZ+3ecZrmv/f0nxGHDOZ4grPC8PjjLMbXS9PwifC+2hnsQcRlNWFWwaQ4S+CxQi+6jFQMjU=",
      "x-amz-request-id": "EQQBG5AS02C03C18",
      "date": "Sun, 31 Jul 2022 19:38:49 GMT",
      "transfer-encoding": "chunked",
      "server": "AmazonS3"
    },
    "RetryAttempts": 0
  },
  "TagSet": [
    { "Key": "fss-scan-detail-code", "Value": "0" },
    { "Key": "fss-scan-date", "Value": "2022/07/31 19:38:44" },
    { "Key": "fss-scan-result", "Value": "no issues found" },
    { "Key": "fss-scan-detail-message", "Value": "" },
    { "Key": "fss-scanned", "Value": "true" }
  ]
}
```

based on the event messages I wrote the python lambda function

```py
import boto3
import json
s3_client = boto3.client('s3')

# lambda function to copy file from 1 s3 to another s3

def lambda_handler(event, context):
    # specify source bucket
    source_bucket_name = event['Records'][0]['s3']['bucket']['name']
    # get object that has been uploaded
    file_name = event['Records'][0]['s3']['object']['key']
    # specify destination bucket
    success_destination_bucket_name = 'production-bucket-dodo'
    failed_destination_bucket_name = 'failed-bucket-dodo'
    # specify from where file needs to be copied
    copy_object = {'Bucket': source_bucket_name, 'Key': file_name}
    # write copy statement
    tags = s3_client.get_object_tagging(Bucket=source_bucket_name, Key=file_name)
    print(tags)
    data = tags['TagSet']
    output_dict = [x for x in data if x['Key'] == 'fss-scan-result']
    output_dict[0]['Value']
    if 'no issues found' == output_dict[0]['Value']:
        s3_client.copy_object(CopySource=copy_object, Bucket=success_destination_bucket_name, Key=file_name)
        s3_client.delete_object(Bucket=source_bucket_name, Key=file_name)
    else:
        s3_client.copy_object(CopySource=copy_object, Bucket=failed_destination_bucket_name, Key=file_name)
        s3_client.delete_object(Bucket=source_bucket_name, Key=file_name)
    return {
        'statusCode': 3000,
        'body': json.dumps('File has been Successfully Copied and deleted')
    }
```
