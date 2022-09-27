

```py
def checkSumIntegrity (sourceBucket, destinationBucket, filename):
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
