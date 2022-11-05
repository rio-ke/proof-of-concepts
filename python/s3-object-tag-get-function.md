
```py
import boto3

def getBucjetSpecificTag(bucketName, fileName, tagKeyName):
    s3Client = boto3.client('s3')
    tags = s3Client.get_object_tagging(Bucket=bucketName, Key=fileName)
    data = tags['TagSet']
    output_dict = [x for x in data if x['Key'] == tagKeyName]
    if output_dict != []:
        return output_dict[0]['Value']
    else:
        return None


tagKeyName = "zones"
fileName = "azure-pipelines.yml"
bucketName = "dsk-abc1-bucket-s3"

data = getBucjetSpecificTag(bucketName, fileName, tagKeyName)
print(data)

```
