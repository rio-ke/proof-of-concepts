## pre-signed-url-create-lambda-function.md

```py
import boto3
from botocore.exceptions import ClientError
import logging


def lambda_handler(event, context):
    s3 = event['Records'][0]['s3']
    bucketDetails = s3['bucket']
    specificBucketObjectDetails = s3['object']
    bucketName = bucketDetails['name']
    uploadFileName = specificBucketObjectDetails['key']
    sourceS3ScriptLocationURL = f's3://{bucketName}/{uploadFileName}'
    splitFileLocation = uploadFileName.split("/")
    originCount = splitFileLocation.__len__() - 1
    exactObjectName = splitFileLocation[originCount]
    s3Client = boto3.client(
        's3', config=boto3.session.Config(signature_version='s3v4',))

    try:
        params = {'Bucket': bucketName, 'Key': exactObjectName}
        response = s3Client.generate_presigned_url('get_object', Params=params,ExpiresIn=600)
    except Exception as e:
        print(e)
        logging.error(e)
        return "Error"

    print(response)
    return response
```
