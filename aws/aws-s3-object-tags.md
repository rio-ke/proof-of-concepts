

```py
import boto3
# https://docs.aws.amazon.com/lambda/latest/dg/with-s3-example.html
def getBucjetSpecificTag(bucketName, fileName, tagKeyName):
    s3Client = boto3.client('s3')
    tags = s3Client.get_object_tagging(Bucket=bucketName, Key=fileName)
    data = tags['TagSet']
    output_dict = [x for x in data if x['Key'] == tagKeyName ]
    # return the key value
    return output_dict[0]['Value']

tagKeyName = "zone"
fileName =
bucketName = 
print(getBucjetSpecificTag(bucketName, fileName, tagKeyName))
```


<!-- https://docs.aws.amazon.com/lambda/latest/dg/with-s3-example.html -->
