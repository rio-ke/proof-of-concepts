_lambdaCode_

```py
import json
import boto3

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

def preSignedURLPrepareToUpload(bucketName, filename, expires):
    return s3Client.generate_presigned_post(Bucket=bucketName, Key=filename, ExpiresIn=expires)
    
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
    requestPath = event['path']
    if (requestMethod == "POST" and requestPath == '/presignedpost'):
        data = json.loads(event['body'])
        validationRules = validationDict(data)
        if validationRules == True:
            bucketName = data['bucketName']
            keyfile = data['keyfile']
            expires = data['expires']

            if (bucketName != "" and keyfile != "" and expires != "" ):
                
                searchFileFromBucket = findABucketObject(bucketName, keyfile)

                if searchFileFromBucket == True:
                    preSignedUrl=preSignedURLPost(bucketName, keyfile, expires)
                    data = { "url": preSignedUrl }
                    return returnSuccessStatus(200, "Success", data)
                else: 
                    return returnStatus(403, 'Requested bucket or file does not exist')
            else:
                return returnStatus(403, "Forbidden")
        else:
            return returnStatus(400, "Bad Request")
            
    elif (requestMethod == "POST" and requestPath == '/presignedpreurl'):
        data = json.loads(event['body'])
        validationRules = validationDict(data)
        if validationRules == True:
            bucketName = data['bucketName']
            keyfile = data['keyfile']
            expires = data['expires']
            if (bucketName != "" and keyfile != "" and expires != "" ):
                searchBucket = findABucket(bucketName)
                if searchBucket == True:
                   preSignedUrl = preSignedURLPrepareToUpload(bucketName, keyfile, expires)
                   return returnSuccessStatus(200, "Success", preSignedUrl)
                else:
                    return returnStatus(403, 'Requested bucket or file does not exist')
            else:
                return returnStatus(403, "Forbidden")
        else:
            return returnStatus(400, "Bad Request")
    else:
        message = requestMethod + " method is not allowed"
        return returnStatus(400, message)
```

validation

```py
import requests
response = {"url": "https://a3-s3-bucket-success.s3.amazonaws.com/", "fields": {"key": "stext.txt", "x-amz-algorithm": "AWS4-HMAC-SHA256", "x-amz-credential": "ASIAZ3AOH4SR6AI2PBUD/20221119/ap-southeast-1/s3/aws4_request", "x-amz-date": "20221119T124907Z", "x-amz-security-token": "IQoJb3JpZ2luX2VjEFUaDmFwLXNvdXRoZWFzdC0xIkYwRAIgM3uF7GTqR6IlgF6ts4dh5MzlaimdrURH9LRsoQOxL7kCIA5LpKU+pAbVLKbxFB8Npxbv5Hm/3I3x+/7OD/djwzVRKusCCF4QABoMNjc2NDg3MjI2NTMxIgxCD55h6TMYF9JnWaQqyAKRYF35+2cFU1ooj+tnh2qNDZDJNYFjnRpHBRAPD4HNSNiX7SbY5CIb+BfwmTBcG7Q11BRCbNBOnPnyuhTcIe+vJ2tDKhaZWBN53y0KXtFQqkSmTVJyAdnPss8Lxu4e6vNVi08l1Te2wghvOG66kWIwoPgj3C5KzwPKgw1BG3PjWN4X5wccxu/31e81ZL6ke3xf0afcd0Orh7Ep8hvtWJ74stzwIyVl83zBaiCgLEBGXN/rR7DMvSelKWI0JlVz5nctfCiexm22kxzq2BNvlfckrDSqcWk1mhK+CpGHHgSFJaqdZkJL3En4PSwl4OHuHHYWVjCspRh2sZ/lzenfVIpepdS7POcL9dIph+2B7jud5GFvwx6xt0LKwRQnqPSKEjt9nMGTL9hP7RxEf4zlrLEkGdT5z97wUTNLXavBwelArQT/L1zzVyWXMLKe45sGOp8Blh0RbfXslv8hevtOkQ9Xt4Ser6Zj4U8587tCZ2coeKVafZzGJru55nYSFP6lEicOEqwf5p5WdO8yqZhLwrnWWkpwbrNkiNlJ94RRWgWZjJi0zRjpPa/L01Dsa3HSxJ0ueSMECuASd+iuvHXCCLOcPpQo0K7a6hT+MpcREHZ5x48dMLv5BtFXZoz9qUmE8qhZdTZAwa43c1DLc9ttK6H1", "policy": "eyJleHBpcmF0aW9uIjogIjIwMjItMTEtMTlUMTM6MDU6NDdaIiwgImNvbmRpdGlvbnMiOiBbeyJidWNrZXQiOiAiYTMtczMtYnVja2V0LXN1Y2Nlc3MifSwgeyJrZXkiOiAic3RleHQudHh0In0sIHsieC1hbXotYWxnb3JpdGhtIjogIkFXUzQtSE1BQy1TSEEyNTYifSwgeyJ4LWFtei1jcmVkZW50aWFsIjogIkFTSUFaM0FPSDRTUjZBSTJQQlVELzIwMjIxMTE5L2FwLXNvdXRoZWFzdC0xL3MzL2F3czRfcmVxdWVzdCJ9LCB7IngtYW16LWRhdGUiOiAiMjAyMjExMTlUMTI0OTA3WiJ9LCB7IngtYW16LXNlY3VyaXR5LXRva2VuIjogIklRb0piM0pwWjJsdVgyVmpFRlVhRG1Gd0xYTnZkWFJvWldGemRDMHhJa1l3UkFJZ00zdUY3R1RxUjZJbGdGNnRzNGRoNU16bGFpbWRyVVJIOUxSc29RT3hMN2tDSUE1THBLVStwQWJWTEtieEZCOE5weGJ2NUhtLzNJM3grLzdPRC9kand6VlJLdXNDQ0Y0UUFCb01OamMyTkRnM01qSTJOVE14SWd4Q0Q1NWg2VE1ZRjlKbldhUXF5QUtSWUYzNSsyY0ZVMW9vait0bmgycU5EWkRKTllGam5ScEhCUkFQRDRITlNOaVg3U2JZNUNJYitCZndtVEJjRzdRMTFCUkNiTkJPblBueXVoVGNJZSt2SjJ0REtoYVpXQk41M3kwS1h0RlFxa1NtVFZKeUFkblBzczhMeHU0ZTZ2TlZpMDhsMVRlMndnaHZPRzY2a1dJd29QZ2ozQzVLendQS2d3MUJHM1BqV040WDV3Y2N4dS8zMWU4MVpMNmtlM3hmMGFmY2QwT3JoN0VwOGh2dFdKNzRzdHp3SXlWbDgzekJhaUNnTEVCR1hOL3JSN0RNdlNlbEtXSTBKbFZ6NW5jdGZDaWV4bTIya3h6cTJCTnZsZmNrckRTcWNXazFtaEsrQ3BHSEhnU0ZKYXFkWmtKTDNFbjRQU3dsNE9IdUhIWVdWakNzcFJoMnNaL2x6ZW5mVklwZXBkUzdQT2NMOWRJcGgrMkI3anVkNUdGdnd4Nnh0MExLd1JRbnFQU0tFanQ5bk1HVEw5aFA3UnhFZjR6bHJMRWtHZFQ1ejk3d1VUTkxYYXZCd2VsQXJRVC9MMXp6VnlXWE1MS2U0NXNHT3A4QmxoMFJiZlhzbHY4aGV2dE9rUTlYdDRTZXI2Wmo0VTg1ODd0Q1oyY29lS1ZhZlp6R0pydTU1bllTRlA2bEVpY09FcXdmNXA1V2RPOHlxWmhMd3JuV1drcHdick5raU5sSjk0UlJXZ1daakppMHpSanBQYS9MMDFEc2EzSFN4SjB1ZVNNRUN1QVNkK2l1dkhYQ0NMT2NQcFFvMEs3YTZoVCtNcGNSRUhaNXg0OGRNTHY1QnRGWFpvejlxVW1FOHFoWmRUWkF3YTQzYzFETGM5dHRLNkgxIn1dfQ==", "x-amz-signature": "c7b78de67b715977793389677255793343ece3072801a01cf06e52001e4520bf"}}
print(response['url'])
files = { 'file': open('text.txt', 'rb')}
r = requests.post(response['url'], data=response['fields'], files=files)
print(r.status_code)
```
