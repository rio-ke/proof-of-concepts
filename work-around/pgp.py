import json
import gnupg
import aws_lambda_logging
import re
import os
import pathlib
import urllib
import boto3

s3 = boto3.resource('s3')
s3Client = boto3.client('s3')

def determineNameOfEmail(nameOfEmail):
    result = re.split(r'@', nameOfEmail)
    return result[0]

def findAgentName(stringData):
    data = re.split(r'/', stringData)[2]
    return data[2]
    
def reformKeyname(stringData):
    data = re.split(r'/', stringData)
    return ("/".join(data[3:]))
    
def determineOfKeyname(nameOfFile):
    return os.path.basename(nameOfFile)

def removeGpgExtension(nameOfFile):
    return os.path.splitext(nameOfFile)[0]

def generteGpgkey(nameOfEmail):
    gpg = gnupg.GPG(gnupghome="/tmp", gpgbinary='/opt/python/gpg')

    # generate key
    input_data = gpg.gen_key_input(name_email=nameOfEmail, passphrase=None)
    key = gpg.gen_key(input_data)

    # create ascii-readable versions of pub / private keys
    ascii_armored_public_keys = gpg.export_keys(key.fingerprint)
    ascii_armored_private_keys = gpg.export_keys(
        keyids=key.fingerprint, secret=False, passphrase=None)
    nameOfExportFile = "/tmp/" + determineNameOfEmail(nameOfEmail) + ".asc"

    # export the keys into files
    with open(nameOfExportFile, 'w') as f:
        f.write(ascii_armored_public_keys)
        f.write(ascii_armored_private_keys)

    return json.dumps({
        "keyname": nameOfExportFile,
        "state": "created"
    })


def gpgEncryption(combineOfKeyFile, nameOfEncryoptionFile, recipients):
    gpg = gnupg.GPG(gnupghome="/tmp",gpgbinary='/opt/python/gpg')
    keyLoader = open(combineOfKeyFile).read()
    gpg.import_keys(keyLoader)
    status = gpg.encrypt_file(nameOfEncryoptionFile, recipients=[
                              recipients], output=nameOfEncryoptionFile + ".gpg")
    return json.dumps({
        "encrytionState": status.ok,
        "status": status.status
    })


def gpgDecryption(combineOfKeyFile, nameOfDecryoptionFile, passphrase=None ):
    gpg = gnupg.GPG(gnupghome="/tmp", gpgbinary='/opt/python/gpg')
    keyLoader = open(combineOfKeyFile).read()
    gpg.import_keys(keyLoader)
    output = removeGpgExtension(nameOfDecryoptionFile)
    print(output)
    status = gpg.decrypt_file(nameOfDecryoptionFile, passphrase=passphrase, output=output)
    return json.dumps({
        "decrytionState": status.ok,
        "status": status.status
    })

def checkDecryptionStatus(nameOfFile):
    extensionOfFile = pathlib.Path(nameOfFile).suffix
    if (extensionOfFile == '.asc' or extensionOfFile == '.gpg' or extensionOfFile == '.pgp'):
        return True
    else:
        return False

def downloadSecretKeyFromS3(bucketname, key):
    agentName = key + ".asc"
    tempPath = '/tmp/' + agentName
    s3.meta.client.download_file(bucketname, agentName, tempPath)
    return tempPath    

def downloadfile(bucketname, key):
    parentPath = pathlib.PurePath(key).parent
    keyName = pathlib.PurePath(key).name
    tempPath = '/tmp/' + keyName
    s3.meta.client.download_file(bucketname, key, tempPath)
    return tempPath
    
def deleteS3Object(bucketName, fileName):
    return s3Client.delete_object(Bucket=bucketName, Key=fileName)

def fileRemove(tempPath):
    if os.path.exists(tempPath):
        print("file deleted...")
        return os.remove(tempPath)

def uploadfile(bucketname, staticDir, key, tagname, tagValue):
    parentPath = pathlib.PurePath(key).parent
    keyName = pathlib.PurePath(key).name
    s3Path = staticDir + removeGpgExtension(key)
    tempPath = '/tmp/'+ removeGpgExtension(keyName)
    deletePath = '/tmp/'+ keyName
    print(s3Path, tempPath, deletePath)
    tags = {tagname: tagValue}
    s3.meta.client.upload_file(tempPath, bucketname, s3Path, ExtraArgs={"Tagging": urllib.parse.urlencode(tags)},)
    fileRemove(tempPath)
    fileRemove(deletePath)
    return True

def failedUploadFile(bucketname, staticDir, key, tagname, tagValue):
    parentPath = pathlib.PurePath(key).parent
    keyName = pathlib.PurePath(key).name
    s3Path = staticDir + removeGpgExtension(key)
    tempPath = '/tmp/'+ keyName
    tags = {tagname: tagValue}
    s3.meta.client.upload_file(tempPath, bucketname, s3Path, ExtraArgs={"Tagging": urllib.parse.urlencode(tags)},)
    fileRemove(tempPath)
    return True
    
def copyS3ObjectToS3(sourceBucketName, DestinationBucketName, key):
    parentPath = pathlib.PurePath(key).parent
    targetFileName = pathlib.PurePath(key).name
    return s3Client.copy_object(CopySource={'Bucket': sourceBucketName, 'Key': key}, Bucket=DestinationBucketName, Key='SFTP-PROCESS/'+targetFileName, TaggingDirective='COPY', ChecksumAlgorithm='SHA256',)

def createNewTags(buckeName, fileName, tagName, tagValue):
    tagging = {'TagSet' : [{'Key': tagName, 'Value': tagValue }]}
    parentPath = pathlib.PurePath(fileName).parent
    targetFileName = pathlib.PurePath(fileName).name
    return s3Client.put_object_tagging(Bucket=buckeName, Key='SFTP-PROCESS/'+targetFileName, Tagging=tagging)
    
def lambda_handler(event, context):
    aws_lambda_logging.setup(level='INFO')

    eventName = event['detail']['eventName']
    eventBucket = urllib.parse.unquote_plus(event['detail']['requestParameters']['bucketName'])
    fileName = urllib.parse.unquote_plus(event['detail']['requestParameters']['key'])
    agentName = findAgentName(fileName)
    reformationFileName = reformKeyname(fileName)
    # agencyPassword = agentName  # "jinojoe"
    gpgProcessStateLocation = 'SFTP-PROCESS/'
    gpgFailedStateLocation = 'SFTP-FAILED/'
    
    KEY_BUKCET = "secret-jn"
    
    if (checkDecryptionStatus(fileName)):
        status = gpgDecryption(downloadSecretKeyFromS3(KEY_BUKCET, agentName), downloadfile(eventBucket, fileName))
        # status = gpgDecryption(downloadSecretKeyFromS3("secret-jn", agentName), agencyPassword, downloadfile(eventBucket, fileName))

        descryptionState = json.loads(status)
        if (descryptionState['decrytionState']):
            uploadfile(eventBucket, gpgProcessStateLocation, reformationFileName, "status", "Decrypted")
            deleteS3Object(eventBucket, fileName)
        else:
            failedUploadFile(eventBucket, gpgFailedStateLocation, reformationFileName, "status", "Decryption failed")
            deleteS3Object(eventBucket, fileName)
    else:
        copyS3ObjectToS3(eventBucket, eventBucket, fileName)
        createNewTags(eventBucket, fileName, "status", "Non Encrypted File")
        deleteS3Object(eventBucket, fileName)

"""
Agent Name is part of file directory structure. while creating the sftp folder for specific agency you must kept in place. if its missing we will get an issue.
"""