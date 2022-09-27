creation of file

```py
import boto3
s3Client = boto3.client('s3')
copy_object = {'Bucket': "a1-bucket-s3", 'Key': "screenshot.docx"}
sumValues = s3Client.copy_object(CopySource=copy_object, Bucket="abc1-bucket-s3", Key="screenshot.docx", ChecksumAlgorithm='SHA256')
checkSum = s3Client.get_object(Bucket="abc1-bucket-s3", ChecksumMode='ENABLED', Key="screenshot.docx")
print(checkSum['ChecksumSHA256'])

```
validation of file

```py
def checkSumIntegrity (sourceBucket, destinationBucket, filename):
    s3Client = boto3.client('s3')
    source = s3Client.get_object(Bucket=sourceBucket,ChecksumMode='ENABLED', Key=filename)
    destination = s3Client.get_object(Bucket=destinationBucket, ChecksumMode='ENABLED', Key=filename)
    sourceCheckpoint = 'ChecksumSHA256' in source.keys()
    destinationCheckpoint = 'ChecksumSHA256' in destination.keys()

    if (sourceCheckpoint == True and destinationCheckpoint== True):
        if (source['ChecksumSHA256'] == destination['ChecksumSHA256']):
            return True
        else:
            return False
    else:
        return False

```
