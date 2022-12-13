

```py
import json
import boto3
import pathlib

s3ClientInit = boto3.client('s3') # sdk
s3Client = boto3.client('s3', config=boto3.session.Config(signature_version='s3v4',))

def getObjectDetails(buckeName, fileName):
    _results = s3ClientInit.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in _results

def findABucket(bucketName):
    response = s3ClientInit.list_buckets()['Buckets']
    if response != []:
        for bucket in response:
            if bucket['Name'] == bucketName:
                return True
    else: 
        return False
        
def findABucketObject(bucketName, fileName):
    response = s3ClientInit.list_buckets()['Buckets']
    if response != []:
        for bucket in response:
            if bucket['Name'] == bucketName:
                getBucketObjectAvailablility = getObjectDetails(bucketName, fileName)
                if getBucketObjectAvailablility == True:
                    return True
                else:
                    return False
    else: 
        return False

def returnSuccessStatus(statusCode, message, data=None):
    return {'statusCode': statusCode,'body': json.dumps({ 'statusCode': statusCode, "message": message, "data": data })}

def returnStatus(statusCode, message):
    return {'statusCode': statusCode,'body': json.dumps({ 'statusCode': statusCode, "message": message })}

def preSignedURLPost(bucketName, filename, ExpiresIn):
    return s3Client.generate_presigned_url('get_object', Params={'Bucket': bucketName, 'Key': filename}, ExpiresIn=ExpiresIn)

def createMultipartUpload(bucketName, filename):
    return s3Client.create_multipart_upload(Bucket=bucketName, Key=filename, ChecksumAlgorithm='SHA256')['UploadId']

def generatePreSignedURL(bucketName, filename, PartNumber, ExpiresIn):
    Uploadid=createMultipartUpload(bucketName, filename)
    return s3Client.generate_presigned_url(ClientMethod='upload_part',Params={ 'Bucket': bucketName, 'Key': filename, 'UploadId': Uploadid, 'PartNumber': PartNumber}, ExpiresIn=ExpiresIn)
    
def validationDict(data):
    bucketName = 'bucketName' in data.keys()
    keyfile = 'keyfile' in data.keys()
    expires = 'expires' in data.keys()
    if (bucketName == True and keyfile == True and expires == True):
        return True
    else:
        return False
        
def validationDicts(data):
    bucketName = 'bucketName' in data.keys()
    keyfile = 'keyfile' in data.keys()
    expires = 'expires' in data.keys()
    PartNumber = 'PartNumber' in data.keys()
    if (bucketName == True and keyfile == True and expires == True and PartNumber == True):
        return True
    else:
        return False

def filaName(agentId, keyfile):
    return agentId in keyfile

def lambda_handler(event, context):
    agentName = pathlib.PurePath(event['path']).name
    requestMethod = event['httpMethod']
    requestPath = event['path']
    if (requestMethod == "POST" and requestPath == '/presignedpost/'+ agentName):
        data = json.loads(event['body'])
        if validationDict(data):
            bucketName = data['bucketName']
            keyfile = data['keyfile']
            expires = data['expires']
            if (filaName(agentName, keyfile)):
                if (bucketName != "" and keyfile != "" and expires != "" ):
                    if findABucketObject(bucketName, keyfile):
                        preSignedUrl=preSignedURLPost(bucketName, keyfile, expires)
                        data = { "bucketName": bucketName, "fileName": keyfile, "url": preSignedUrl }
                        return returnSuccessStatus(200, "Success", data)
                    else: 
                        return returnStatus(403, 'Requested bucket or file does not exist')
                else:
                    return returnStatus(403, "Forbidden")
            else:
                return returnStatus(400, "Bad Request")
        else:
            return returnStatus(400, "Bad Request")
            
    elif (requestMethod == "POST" and requestPath == '/presignedpreurl/'+ agentName):
        data = json.loads(event['body'])
        if validationDicts(data):
            bucketName = data['bucketName']
            keyfile = data['keyfile']
            expires = data['expires']
            PartNumber = data['PartNumber']
            if (filaName(agentName, keyfile)):
                if (bucketName != "" and keyfile != "" and expires != "" and PartNumber != "" ):
                    if findABucket(bucketName):
                      preSignedUrl = generatePreSignedURL(bucketName, keyfile, PartNumber, expires)
                      return returnSuccessStatus(200, "Success", preSignedUrl)
                    else:
                        return returnStatus(403, 'Requested bucket or file does not exist')
                else:
                    return returnStatus(403, "Forbidden")
            else:
                return returnStatus(400, "Bad Request")
        else:
            return returnStatus(400, "Bad Request")
    else:
        message = requestMethod + " method is not allowed"
        return returnStatus(400, message)
        
        
"""
upload Name: POST https://<api-endpoint>/api/common/PresignedUrl/<app-id
download Name: GET: https://<api-endpoint>/api/common/PresignedUrl/<app-id>?expire=<expire in secs>&key=<full path of the file>
"""
```
