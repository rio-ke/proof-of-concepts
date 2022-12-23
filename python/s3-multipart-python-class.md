_s3-multipart-python-class.md_

```py
import boto3

class multiuPart(object):
    def __init__(self, Bucket, Key):
        self.Bucket = Bucket
        self.Key = Key
        self.s3 = boto3.client('s3')

    def createMultipartUpload(self):
        response = self.s3.create_multipart_upload(
            Bucket=self.Bucket, Key=self.Key)
        return response['UploadId']

    def generatePresignedUrl(self, PartNumber):
        signedUrl = self.s3.generate_presigned_url(
            ClientMethod='upload_part',
            Params={
                'Bucket': self.Bucket,
                'Key': self.Key,
                'UploadId': self.createMultipartUpload(),
                'PartNumber': PartNumber
            }
        )
        return signedUrl


mpu = multiuPart("secret-jn", "demo.txt")
uploadId = mpu.createMultipartUpload()
print(mpu.generatePresignedUrl(5))
```
