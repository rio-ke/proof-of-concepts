import requests
import json
import datetime
import urllib
import boto3

s3Client = boto3.client('s3')
sqsClient = boto3.client('sqs')

# Read as Environment variable
apiGatewayUrl="https://n37xuqka77.execute-api.ap-south-1.amazonaws.com/dev/"
sqsUrl="https://sqs.ap-south-1.amazonaws.com/653413855845/c4-sqs.fifo"
apiGatewayId="n37xuqka77"
originBucketName = "abc1-bucket-s3"
success_destination_bucket_name="c7-bucket-s3"
failed_destination_bucket_name="c7-bucket-s3"
alertSqsQueueURL="https://sqs.ap-south-1.amazonaws.com/653413855845/sqs-final-trigger-queue-to-application"



def pushResultsToQueue(queue_url, file_path, scan_result):
    scanner_status = 'Generated by the scan-to-final-bucket lambda.'
    queue_message = {
        "timestamp": datetime.datetime.now().isoformat(timespec='seconds'),
        "scanner_status": scanner_status,
        "file_path": file_path,
        "scan_result": scan_result
    }
    json_messsage = json.dumps(queue_message)
    return sqsClient.send_message(QueueUrl=queue_url, MessageBody=json_messsage)

def checkSumIntegrity(sourceBucket, destinationBucket, filename):
    s3Client = boto3.client('s3')
    source = s3Client.get_object(Bucket=sourceBucket, ChecksumMode='ENABLED', Key=filename)
    destination = s3Client.get_object(Bucket=destinationBucket, ChecksumMode='ENABLED', Key=filename)
    sourceCheckpoint = 'ChecksumSHA1' in source.keys()
    destinationCheckpoint = 'ChecksumSHA1' in destination.keys()
    if (sourceCheckpoint == True and destinationCheckpoint== True):
        if (source['ChecksumSHA1'] == destination['ChecksumSHA1']):
            return True
        else:
            return False
    else:
        return False


def deleteQueueMessage(sqsUrl, ReceiptHandle):
    return sqsClient.delete_message(QueueUrl=sqsUrl,ReceiptHandle=ReceiptHandle)

def getObjectDetails(buckeName, fileName):
    results = s3Client.list_objects(Bucket=buckeName, Prefix=fileName)
    return 'Contents' in results
    
def lambda_handler(event, context):
    while True:
        res = requests.get(apiGatewayUrl)
        if res.status_code == 200:
            stageOne = res.json()
            if stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'] == None:
                print(json.dumps({ "Message": False, "statusCode": 200  }))
                break
            else:
                stageTwo = stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'][0]['Body']
                stageThree = json.loads(stageTwo)
                checkEvent = 'Records' in stageThree.keys()
                if checkEvent == True:
                    s3Data=stageThree['Records'][0]['s3']
                    file_name = urllib.parse.unquote_plus(s3Data['object']['key'])
                    source_bucket_name = urllib.parse.unquote_plus(s3Data['bucket']['name'])
                    copy_object = {'Bucket': source_bucket_name, 'Key': file_name}

                    fileExistStatus = getObjectDetails(source_bucket_name, file_name)
                    
                    if fileExistStatus == True:
                        tags = s3Client.get_object_tagging(Bucket=source_bucket_name, Key=file_name)
                        data = tags['TagSet']
                        output_dict = [x for x in data if x['Key'] == 'fss-scan-result']
                        
                        if 'no issues found' == output_dict[0]['Value']:
                            s3ObjectChecksum = checkSumIntegrity(originBucketName, source_bucket_name, file_name)
                            if (s3ObjectChecksum ==  True):
                                s3Client.copy_object(CopySource=copy_object, Bucket=success_destination_bucket_name, Key=file_name)
                                s3Client.delete_object(Bucket=source_bucket_name, Key=file_name)
                                pushResultsToQueue(alertSqsQueueURL, file_name, "success")
                                print(json.dumps({
                                    "file": file_name,
                                    "fileMovement": True,
                                    "sourceBucket": source_bucket_name,
                                    "destinationBucket": success_destination_bucket_name,
                                    "queueMessageDeleteStatus": True,
                                    "checkSumValidaton": True,
                                    "scanStatus": True,
                                    "copyStatus": True,
                                    "malware": False,
                                    "deleteStatus": True
                                }))
                            else:
                                s3Client.copy_object(CopySource=copy_object, Bucket=failed_destination_bucket_name, Key=file_name)
                                s3Client.delete_object(Bucket=source_bucket_name, Key=file_name)
                                pushResultsToQueue(alertSqsQueueURL, file_name, "failure")
                                print(json.dumps({
                                    "file": file_name,
                                    "fileMovement": True,
                                    "sourceBucket": source_bucket_name,
                                    "destinationBucket": success_destination_bucket_name,
                                    "queueMessageDeleteStatus": True,
                                    "checkSumValidaton": False,
                                    "scanStatus": True,
                                    "copyStatus": True,
                                    "malware": False,
                                    "deleteStatus": True
                                }))
                        else:
                            s3Client.copy_object(CopySource=copy_object, Bucket=failed_destination_bucket_name, Key=file_name)
                            s3Client.delete_object(Bucket=source_bucket_name, Key=file_name)
                            pushResultsToQueue(alertSqsQueueURL, file_name, "failure")
                            print(json.dumps({
                                "file": file_name,
                                "fileMovement": False,
                                "quarantine": True,
                                "sourceBucket": source_bucket_name,
                                "destinationBucket": failed_destination_bucket_name,
                                "queueMessageDeleteStatus": True,
                                "checkSumValidaton": False,
                                "scanStatus": True,
                                "copyStatus": True,
                                "deleteStatus": True,
                                "malware": True
                            }))
                    else:
                        ReceiptHandle=stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'][0]['ReceiptHandle']
                        deleteQueueMessage(sqsUrl,ReceiptHandle)
                    ReceiptHandle=stageOne['ReceiveMessageResponse']['ReceiveMessageResult']['messages'][0]['ReceiptHandle']
                    deleteQueueMessage(sqsUrl,ReceiptHandle)                    
                else:
                    print(json.dumps({ "Message": False, "statusCode": 200  }))
        else:
            print(json.dumps({ "Message": "api issues", "statusCode": 500  }))
            break