

```py
import json
import os
import re
import boto3
event = {
    'resource': '/api/common/presignedurl/cp',
    'path': '/api/common/presignedurl/cp',
    'httpMethod': 'GET',
    'headers': None,
    'multiValueHeaders': None,
    'queryStringParameters': {
                'bucket': 'secret-jn',
                'expire': '20',
                'key': 'tmp/demo.txt'
    },
    'multiValueQueryStringParameters': {
        'bucket': ['secret-jn'],
        'expire': ['20'],
        'key': ['tmp/demo.txt']
    },
    'pathParameters': None,
    'stageVariables': None,
    'requestContext': {
        'resourceId': 'yx90ni',
        'resourcePath': '/api/common/presignedurl/cp',
        'httpMethod': 'GET',
        'extendedRequestId': 'dFSs6FfbSQ0Fjng=',
        'requestTime': '13/Dec/2022:11:40:40 +0000',
        'path': '/api/common/presignedurl/cp',
        'accountId': '676487226531',
        'protocol': 'HTTP/1.1',
        'stage': 'test-invoke-stage',
        'domainPrefix': 'testPrefix',
        'requestTimeEpoch': 1670931640808,
        'requestId': '904d08b7-16de-4621-8f93-b11920e277a5',
                'identity': {
                    'cognitoIdentityPoolId': None,
                    'cognitoIdentityId': None,
                        'apiKey': 'test-invoke-api-key',
                        'principalOrgId': None,
                        'cognitoAuthenticationType': None,
                        'userArn': 'arn:aws:iam::676487226531:root',
                        'apiKeyId': 'test-invoke-api-key-id',
                        'userAgent': 'aws-internal/3 aws-sdk-java/1.12.353 Linux/5.4.214-134.408.amzn2int.x86_64 OpenJDK_64-Bit_Server_VM/25.352-b09 java/1.8.0_352 vendor/Oracle_Corporation cfg/retry-mode/standard',
                        'accountId': '676487226531',
                        'caller': '676487226531',
                        'sourceIp': 'test-invoke-source-ip',
                        'accessKey': 'ASIAZ3AOH4SR7TSA3UFD',
                        'cognitoAuthenticationProvider': None,
                        'user': '676487226531'
                },
        'domainName': 'testPrefix.testDomainName',
        'apiId': 'i7swht3dt8'
    },
    'body': None,
    'isBase64Encoded': False
}

s3ClientInit = boto3.client('s3')  # sdk
s3Client = boto3.client(
    's3', config=boto3.session.Config(signature_version='s3v4',))


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
                getBucketObjectAvailablility = getObjectDetails(
                    bucketName, fileName)
                if getBucketObjectAvailablility == True:
                    return True
                else:
                    return False
    else:
        return False


def returnSuccessStatus(statusCode, message, data=None):
    return {'statusCode': statusCode, 'body': json.dumps({'statusCode': statusCode, "message": message, "data": data})}


def returnStatus(statusCode, message):
    return {'statusCode': statusCode, 'body': json.dumps({'statusCode': statusCode, "message": message})}


def preSignedURLPost(bucketName, filename, ExpiresIn):
    return s3Client.generate_presigned_url('get_object', Params={'Bucket': bucketName, 'Key': filename}, ExpiresIn=ExpiresIn)


def createMultipartUpload(bucketName, filename):
    return s3Client.create_multipart_upload(Bucket=bucketName, Key=filename, ChecksumAlgorithm='SHA256')['UploadId']


def generatePreSignedURL(bucketName, filename, PartNumber, ExpiresIn):
    Uploadid = createMultipartUpload(bucketName, filename)
    return s3Client.generate_presigned_url(ClientMethod='upload_part', Params={'Bucket': bucketName, 'Key': filename, 'UploadId': Uploadid, 'PartNumber': PartNumber}, ExpiresIn=ExpiresIn)


def scrapSpecficEvents(event):
    json.dumps(event, indent=3)
    return json.dumps({
        "path": event['path'],
        "httpMethod": event['httpMethod'],
        "queryStringParameters": event['queryStringParameters']
    })


def prepareConsumableEvents(event):
    events = json.loads(event)
    getAgentpath = events['path']
    getAgentName = os.path.basename(getAgentpath)
    getAgentCommonPath = os.path.dirname(getAgentpath)
    getHttpMethod = events['path']
    getQueryStringParameters = events['queryStringParameters']
    return json.dumps({"getAgentpath": getAgentpath, "getAgentName": getAgentName, "getAgentCommonPath": getAgentCommonPath, "getHttpMethod": getHttpMethod, "getQueryStringParameters": getQueryStringParameters})


def methodGetValidation(data):
    bucket = 'bucket' in data.keys()
    key = 'key' in data.keys()
    expire = 'expire' in data.keys()
    return True if (bucket == True and key == True and expire == True) else False


def methodPostValidation(data):
    bucket = 'bucket' in data.keys()
    key = 'key' in data.keys()
    expire = 'expire' in data.keys()
    partNumber = 'partNumber' in data.keys()
    return True if (bucket == True and key == True and expire == True and partNumber == True) else False


def agentNameValidationWithRequest(agent, key):
    return agent in key


def lambda_handler(event, context):
    getPrepareConsumableEvents = json.loads(prepareConsumableEvents(scrapSpecficEvents(event)))
    requestGetAgentpath = getPrepareConsumableEvents['getAgentpath']
    requestGetAgentCommonPath = getPrepareConsumableEvents['getAgentCommonPath']
    requestGetAgentName = getPrepareConsumableEvents['getAgentName']
    requestGetHttpMethod = getPrepareConsumableEvents['getHttpMethod']
    requestGetQueryStringParameters = getPrepareConsumableEvents['getQueryStringParameters']

    if (requestGetHttpMethod == "GET" and requestGetAgentpath == requestGetAgentCommonPath + requestGetAgentName):
        if methodGetValidation(requestGetQueryStringParameters):
            requestGetBucketName = requestGetQueryStringParameters['bucket']
            requestGetKeyName = requestGetQueryStringParameters['key']
            requestGetExpireTime = requestGetQueryStringParameters['expire']
            if (agentNameValidationWithRequest(requestGetAgentName, requestGetKeyName)):
                if (requestGetBucketName != "" and requestGetKeyName != "" and requestGetExpireTime != ""):
                    if findABucketObject(requestGetBucketName, requestGetKeyName):
                        preSignedUrl = preSignedURLPost(
                            requestGetBucketName, requestGetKeyName, requestGetExpireTime)
                        data = {"bucket": requestGetBucketName,
                                "key": requestGetKeyName, "url": preSignedUrl}
                        return returnSuccessStatus(200, "Success", data)
                    else:
                        return returnStatus(403, 'Requested bucket or file does not exist')
                else:
                    return returnStatus(403, "Forbidden")
            else:
                return returnStatus(400, "Bad Request")
        else:
            return returnStatus(400, "Bad Request")

    elif (requestGetHttpMethod == "POST" and requestGetAgentpath == requestGetAgentCommonPath + requestGetAgentName):
        if methodPostValidation(requestGetQueryStringParameters):
            requestGetBucketName = requestGetQueryStringParameters['bucket']
            requestGetKeyName = requestGetQueryStringParameters['key']
            requestGetExpireTime = requestGetQueryStringParameters['expire']
            requestGetPartNumber = requestGetQueryStringParameters['partNumber']
            if (agentNameValidationWithRequest(requestGetAgentName, requestGetKeyName)):
                if (requestGetBucketName != "" and requestGetKeyName != "" and requestGetExpireTime != "" and requestGetPartNumber != ""):
                    if findABucketObject(requestGetBucketName, requestGetKeyName):
                        preSignedUrl = generatePreSignedURL(requestGetBucketName, requestGetKeyName, requestGetPartNumber, requestGetExpireTime)
                        data = {"bucket": requestGetBucketName,"key": requestGetKeyName, "url": preSignedUrl}
                        return returnSuccessStatus(200, "Success", data)
                    else:
                        return returnStatus(403, 'Requested bucket or file does not exist')
                else:
                    return returnStatus(403, "Forbidden")
            else:
                return returnStatus(400, "Bad Request")
        else:
            return returnStatus(400, "Bad Request")
    else:
        message = requestGetHttpMethod + " method is not allowed"
        return returnStatus(400, message)

```
