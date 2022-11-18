**get-s3-pre-signed-url-lambda-with-apigateway.md**

```py
import json
import boto3

s3Client = boto3.client('s3', config=boto3.session.Config(signature_version='s3v4',))

def preSignedURL(bucketName, filename, ExpiresIn):
    return s3Client.generate_presigned_url('get_object', Params={'Bucket': bucketName, 'Key': filename}, ExpiresIn=ExpiresIn)
    
def validationDict(data):
    bucketName = 'bucketName' in data.keys()
    keyfile = 'keyfile' in data.keys()
    expires = 'expires' in data.keys()
    if (bucketName == True and keyfile == True and expires == True):
        return True
    else:
        return False
        
def lambda_handler(event, context):
    requestMethod = event['httpMethod']

    if requestMethod == "POST":
        data = json.loads(event['body'])
        bucketName = data['bucketName']
        keyfile = data['keyfile']
        expires = data['expires']

        if (bucketName != "" and keyfile != "" and expires != "" ):
            preSignedUrl=preSignedURL(bucketName, keyfile, expires)
            return {'statusCode': 200,'body': json.dumps({ 'statusCode': 200, 'message': 'Success', 'url': preSignedUrl})}
        else:
            return {'statusCode': 403,'body': json.dumps({ 'statusCode': 403, 'message': 'Forbidden' })}
    else:
        return {'statusCode': 400,'body': json.dumps({ 'statusCode': 400, "message": "Bad Request"})}
```
