
```py
import json
import gnupg
import re
import os
import pathlib
import boto3
import urllib
import logging
import datetime

class pgpEnDecrypt():
    # gnuhome temporary location
    tempdir = "/tmp/"

    def __init__(self, nameOfEmail, password=None):
        self.nameOfEmail = nameOfEmail
        self.password = password
        self.gpg = gnupg.GPG(gnupghome=self.tempdir, gpgbinary='/opt/python/gpg', verbose=True)

    def generteGpgKey(self):
        input_data = self.gpg.gen_key_input(name_email=self.nameOfEmail, passphrase=self.password)
        key = self.gpg.gen_key(input_data)
        ascii_armored_public_keys = self.gpg.export_keys(key.fingerprint)
        ascii_armored_private_keys = self.gpg.export_keys(keyids=key.fingerprint, secret=True, passphrase=self.password)
        nameOfExportFile = self.tempdir + re.split(r'@', self.nameOfEmail)[0] + ".asc"

        with open(nameOfExportFile, 'w') as f:
            f.write(ascii_armored_public_keys)
            f.write(ascii_armored_private_keys)

        return nameOfExportFile

    def gpgEncrypt(self, keyFile, encryptFile):
        if self.validationOfSource(encryptFile):
            return {
                "encrytionState": False,
                "status": "Filetype is invalid"
            }
        else:
            keyloads = open(keyFile).read()
            self.gpg.import_keys(keyloads)
            e_output = encryptFile + ".gpg"
            status = self.gpg.encrypt_file(encryptFile, recipients=[self.nameOfEmail], output=e_output)
            return {
                "encrytionState": status.ok,
                "status": status.status,
                "fileStatus": e_output
            }

    def gpgDecrypt(self, keyFile, decryptFile):
        if self.validationOfSource(decryptFile):
            keyloads = open(keyFile).read()
            self.gpg.import_keys(keyloads)
            d_output = os.path.splitext(decryptFile)[0]
            status = self.gpg.decrypt_file(decryptFile, passphrase=self.password, output=d_output)
            return {
                "decrytionState": status.ok,
                "status": status.status,
                "fileStatus": d_output
            }
        else:
            return {
                "decrytionState": False,
                "status": "Filetype is invalid"
            }

    def validationOfSource(self, nameOfFile):
        extensionOfFile = pathlib.Path(nameOfFile).suffix
        if (extensionOfFile == '.asc' or extensionOfFile == '.gpg' or extensionOfFile == '.pgp'):
            return True
        else:
            return False


class s3Process():
    tempdir = "/tmp/"
    ChecksumAlgorithm = 'SHA256'

    def __init__(self, bucket, key):
        self.bucket = bucket
        self.key = key
        self.s3 = boto3.resource('s3')
        self.s3Client = boto3.client('s3')
        self.parentPath = pathlib.PurePath(self.key).parent
        self.childName = pathlib.PurePath(self.key).name

    def download(self):
        downloadLocation = self.tempdir + self.childName
        self.s3.meta.client.download_file(self.bucket, self.key, downloadLocation)
        return downloadLocation
        
    def delete(self, destinationBucket=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        return self.s3Client.delete_object(Bucket=targetBucket, Key=self.key)

    def upload(self, u_key, destinationBucket=None, t_key=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        t_key = t_key if t_key != None else u_key
        return self.s3.meta.client.upload_file(u_key, targetBucket, t_key)

    def copy(self, destinationBucket, customLocation=None):
        targetPath = customLocation if customLocation != None else self.key
        source = {'Bucket': self.bucket, 'Key': self.key}
        return self.s3Client.copy_object(CopySource=source, Bucket=destinationBucket, Key=targetPath, TaggingDirective='COPY', ChecksumAlgorithm=self.ChecksumAlgorithm)

    def createNewTag(self, t_name, t_value, t_key=None):
        tagging = {'TagSet': [{'Key': t_name, 'Value': t_value}]}
        t_key = t_key if t_key != None else self.key
        return self.s3Client.put_object_tagging(Bucket=self.bucket, Key=t_key, Tagging=tagging)

    def objectState(self):
        return 'Contents' in self.s3Client.list_objects(Bucket=self.bucket, Prefix=self.key)

    def getTags(self):
        tag = self.s3Client.get_object_tagging(Bucket=self.bucket, Key=self.key)
        return tag['TagSet']

    def getSpecificTagDetails(self, t_name):
        tags = self.s3Client.get_object_tagging(Bucket=self.bucket, Key=self.key)
        data = tags['TagSet']
        if data == []:
            return False
        else:
            for element in data:
                if element['Key'] == t_name:
                    return element['Value']
            return False

    def updateTags(self, destinationBucket=None,updationTags=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        updationTagLists = updationTags if updationTags != None else self.getTags()
        return self.s3Client.put_object_tagging(Bucket=targetBucket, Key=self.key, Tagging={'TagSet': updationTagLists})

    def logPoster(self, event, state):
        return json.dumps({'event': event, 'bucket': self.bucket, 'fileName': self.key, 'processState': state})

    def ignorePathPosition(self, pathPosition):
        data = re.split(r'/', self.key)
        return ("/".join(data[pathPosition:]))


def lambda_handler(event, context):
    eventName = event['detail']['eventName']
    eventBucket = urllib.parse.unquote_plus(event['detail']['requestParameters']['bucketName'])
    key = urllib.parse.unquote_plus(event['detail']['requestParameters']['key'])

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    _s3 = s3Process(eventBucket, key)
    # encrypt and decrypt file, email, password
    pgpEmailReceipt = "gino@gmail.com"
    pgpPasswordReceipt = "password"
    _pgp = pgpEnDecrypt(pgpEmailReceipt, pgpPasswordReceipt)

    KEY_BUKCET = "dodo-secret-common"
    agentName = re.split(r'/', key)[2]
    reformationFileName = _s3.ignorePathPosition(3)


    if (_s3.objectState()):
        
        if (_pgp.validationOfSource(key)):
            keyLocation = s3Process("dodo-secret-common", agentName +".asc").download()
            sourceDownload = _s3.download()
            status = _pgp.gpgDecrypt(keyLocation, sourceDownload)

            if (status['decrytionState']):
                decryptFileName = os.path.splitext(sourceDownload)[0]
                gpgProcessStateLocation = 'SFTP/PROC/' + reformationFileName
                uploadedFileName = os.path.splitext(gpgProcessStateLocation)[0]
                _s3.upload(decryptFileName, eventBucket, uploadedFileName)
                _s3.createNewTag("status", "Decrypted", uploadedFileName)
                _s3.delete()
                os.remove(keyLocation)
                os.remove(sourceDownload)
                os.remove(decryptFileName) 
            else:
                gpgFailedStateLocation = 'SFTP/FAILED/' + reformationFileName
                _s3.upload(sourceDownload, eventBucket, gpgFailedStateLocation)
                _s3.createNewTag("status", "Decryption failed", gpgFailedStateLocation)
                _s3.delete()
                os.remove(keyLocation)
                os.remove(sourceDownload)
        else:
            gpgProcessStateLocation = 'SFTP/PROC/' + reformationFileName
            _s3.createNewTag("status", "Non Encrypted File")
            _s3.copy(eventBucket, gpgProcessStateLocation)
            _s3.delete()
    else:
        logger.error(_s3.logPoster(eventName, "unknown events"))
```
