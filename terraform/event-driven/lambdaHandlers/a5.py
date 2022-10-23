import json
import urllib
import boto3
import os

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')

_metadataBucket = os.environ['metadataBucket']
_scanningBucket = os.environ['scanningBucket']
_sqsUrl         = os.environ['sqsUrl']

def deleteQueueMessage(sqsUrl, ReceiptHandle):
    return sqsClient.delete_message(QueueUrl=sqsUrl,ReceiptHandle=ReceiptHandle)

def findS3EventObject(event):
    _listOfObjetcts = []
    _checkEvent = 'Records' in event.keys()
    if _checkEvent == True:
        for _source in range(len(event['Records'])):
            _reformedListRecord = event['Records'][_source]
            _reformedBody       = json.loads(_reformedListRecord["body"])
            _reformedMessage    = json.loads(_reformedBody["Message"])
            _receiptHandle      = _reformedListRecord['receiptHandle']
            _s3Event            = _reformedMessage[0]['s3']
            _zone               = _reformedMessage[0]['zone']
            _object             = json.dumps({'s3': _s3Event, 'zone': _zone, "receiptHandle": _receiptHandle})
            _listOfObjetcts.append(_object)

    return _listOfObjetcts

def getObjectDetails(buckeName, fileName):
    _results = s3Client.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in _results
    
def lambda_handler(event, context):
    json.dumps(event, indent=3)
    _s3ObjectIdentifier = findS3EventObject(event)
    if _s3ObjectIdentifier != []:
        for s3 in _s3ObjectIdentifier:
            fileName = urllib.parse.unquote_plus(s3['s3']['object']['key'])
            sourceBucketName = urllib.parse.unquote_plus(s3['s3']['bucket']['name'])
            fileZone = s3['zone']
            queueId = s3['receiptHandle']
            copyObject = json.dumps({ 'Bucket': sourceBucketName, 'Key': fileName })
            getObjectAvailable = getObjectDetails(sourceBucketName, fileName)
            
            if getObjectAvailable == True:
                tagging = {'TagSet' : [{'Key': 'zone', 'Value': fileZone }]}
                s3Client.put_object_tagging(Bucket=sourceBucketName, Key=fileName, Tagging=tagging)
                print(f' <= {fileName} file has been tagged in {sourceBucketName} bucket')
                s3Client.copy_object(CopySource=copyObject, Bucket=_metadataBucket, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1',)
                s3Client.copy_object(CopySource=copyObject, Bucket=_scanningBucket, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1')
                print(f' => {fileName} file has been copy to {_metadataBucket} and {_scanningBucket} buckets')
                s3Client.delete_object(Bucket=sourceBucketName, Key=fileName)
                print(f' <= {fileName} file has been deleted from {sourceBucketName} bucket')
                deleteQueueMessage(_sqsUrl, queueId)
                print(f' <= {fileName} queue has been deleted')
            else:
                deleteQueueMessage(_sqsUrl, queueId)
                print(f' <= {fileName} queue has been deleted')
