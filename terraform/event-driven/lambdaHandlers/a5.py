import json
import urllib
import boto3
import os

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')

# VARIABLE SECTION
destination_bucket_name = os.environ['destination_bucket_name']                         # 'abc1-bucket-s3'
replication_destination_bucket_name= os.environ['replication_destination_bucket_name']  # "b1-bucket-s3"
sqsUrl = os.environ['sqsUrl']                                                           # "https://sqs.ap-south-1.amazonaws.com/653413855845/a4-sqs.fifo"

def deleteQueueMessage(sqsUrl, ReceiptHandle):
    return sqsClient.delete_message(QueueUrl=sqsUrl,ReceiptHandle=ReceiptHandle)

def findS3EventObjectFromS3(event):
    s3EventObjectFromS3List = []
    checkEvent = 'Records' in event.keys()
    if checkEvent == True:
        for source in range(len(event['Records'])):
            actualData = json.loads(event['Records'][source]['body'])
            receiptHandle = event['Records'][source]['receiptHandle']
            s3Event = actualData[0]['s3']
            zone = actualData[0]['zone']
            data = {'s3': s3Event, 'zone': zone, "receiptHandle": receiptHandle}
            s3EventObjectFromS3List.append(data)
    return s3EventObjectFromS3List    

def getObjectDetails(buckeName, fileName):
    results = s3Client.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in results
    
def lambda_handler(event, context):
    s3ObjectIdentifier = findS3EventObjectFromS3(event)
    if s3ObjectIdentifier != []:
        for s3 in s3ObjectIdentifier:
            fileName = urllib.parse.unquote_plus(s3['s3']['object']['key'])
            sourceBucketName = urllib.parse.unquote_plus(s3['s3']['bucket']['name'])
            fileZone = s3['zone']
            queueId = s3['receiptHandle']
            copyObject = { 'Bucket': sourceBucketName, 'Key': fileName }
            
            getObjectAvailable = getObjectDetails(sourceBucketName, fileName)
            if getObjectAvailable == True:
                tagging = {'TagSet' : [{'Key': 'zone', 'Value': fileZone }]}
                s3Client.put_object_tagging(Bucket=sourceBucketName,Key=fileName, Tagging=tagging)
                print(f' <= {fileName} file has been tagged in {sourceBucketName} bucket')
                s3Client.copy_object(CopySource=copyObject, Bucket=destination_bucket_name, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1',)
                s3Client.copy_object(CopySource=copyObject, Bucket=replication_destination_bucket_name, Key=fileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA1')
                print(f' => {fileName} file has been copy to {destination_bucket_name} and {replication_destination_bucket_name} buckets')
                s3Client.delete_object(Bucket=sourceBucketName, Key=fileName)
                print(f' <= {fileName} file has been deleted from {sourceBucketName} bucket')
                deleteQueueMessage(sqsUrl, queueId)
                print(f' <= {fileName} queue has been deleted')
            else:
                deleteQueueMessage(sqsUrl, queueId)
                print(f' <= {fileName} queue has been deleted')
                
