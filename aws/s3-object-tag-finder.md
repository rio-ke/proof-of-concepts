_s3-object-tag-finder_

```py
def getSpecificTagDetails(bucket, key, t_name):
    tags = boto3.client('s3').get_object_tagging(Bucket=bucket, Key=key)
    data = tags['TagSet']
    if data == []:
        return None
    else:
        for element in data:
            if element['Key'] == t_name:
                return element['Value']
        return None

```
