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
            _reformedMessageList= json.dumps(_reformedBody[0])
            _reformedMessage    = json.loads(_reformedMessageList)
            _receiptHandle      = _reformedListRecord['receiptHandle']
            _s3Event            = _reformedMessage['s3']
            _zone               = _reformedMessage['zone']
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
        for _s3 in _s3ObjectIdentifier:
            s3Data = json.loads(_s3)
            fileName = urllib.parse.unquote_plus(s3Data['s3']['object']['key'])
            sourceBucketName = urllib.parse.unquote_plus(s3Data['s3']['bucket']['name'])
            fileZone = s3Data['zone']
            queueId = s3Data['receiptHandle']
            copyObject = { 'Bucket': sourceBucketName, 'Key': fileName }
            getObjectAvailable = getObjectDetails(sourceBucketName, fileName)

            if getObjectAvailable == True:
                # Tags the bucket object
                tagging = {'TagSet' : [{'Key': 'zone', 'Value': fileZone }]}
                s3Client.put_object_tagging(Bucket=sourceBucketName, Key=fileName, Tagging=tagging)
                print(f' <= {fileName} file has been tagged in {sourceBucketName} bucket')
                # Copy to second and third stage buckets
                s3Client.copy_object(CopySource=copyObject, Bucket=_metadataBucket, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1',)
                s3Client.copy_object(CopySource=copyObject, Bucket=_scanningBucket, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1')
                print(f' => {fileName} file has been copy to {_metadataBucket} and {_scanningBucket} buckets')
                # Delete the source bucket object 
                s3Client.delete_object(Bucket=sourceBucketName, Key=fileName)
                print(f' <= {fileName} file has been deleted from {sourceBucketName} bucket')
                # delete the sqs queue
                deleteQueueMessage(_sqsUrl, queueId)
                print(f' <= {fileName} queue has been deleted')
            else:
                # delete the sqs queue without object copy.
                deleteQueueMessage(_sqsUrl, queueId)
                print(f' <= {fileName} queue has been deleted')
