import json
import gnupg
import re
import os
import pathlib
import boto3
import urllib
import logging

class pgpEnDecrypt():
    # gnuhome temporary location
    tempdir = "/tmp/"

    def __init__(self, nameOfEmail, password=None):
        self.nameOfEmail = nameOfEmail
        self.password = password
        self.gpg = gnupg.GPG(gnupghome=self.tempdir, gpgbinary='/opt/python/gpg')

    def generteGpgKey(self):
        input_data = self.gpg.gen_key_input(name_email=self.nameOfEmail, passphrase=self.password)
        key = self.gpg.gen_key(input_data)
        ascii_armored_public_keys = self.gpg.export_keys(key.fingerprint)
        secret = True if self.password != None else False
        ascii_armored_private_keys = self.gpg.export_keys(keyids=key.fingerprint, secret=secret, passphrase=self.password)
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

    def download(self, destinationBucket=None, keyfile=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        targetFile = keyfile if keyfile != None else self.childName
        downloadLocation = self.tempdir + targetFile
        self.s3.meta.client.download_file(targetBucket, self.key, downloadLocation)
        return downloadLocation

    def delete(self, destinationBucket=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        return self.s3Client.delete_object(Bucket=targetBucket, Key=self.key)

    def upload(self, u_key, destinationBucket=None, t_key=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        t_key = t_key if t_key != None else u_key
        return self.s3.meta.client.upload_file(u_key, targetBucket, t_key)

    def bucketToBucket(self, destinationBucket, customLocation=None):
        targetPath = customLocation + self.childName if customLocation != None else self.key
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

    def logPoster(self, state):
        return json.dumps({'Bucket': self.bucket, 'fileName': self.key, 'processState': state})

    def ignorePathPosition(self, pathPosition):
        data = re.split(r'/', self.key)
        return ("/".join(data[pathPosition:]))

def lambda_handler(event, context):
    
    """ Event Capture process"""
    
    eventName = event['detail']['eventName']
    eventBucket = urllib.parse.unquote_plus(event['detail']['requestParameters']['bucketName'])
    key = urllib.parse.unquote_plus(event['detail']['requestParameters']['key'])

    """ Logger initiate process """
    
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    """ Class initiate process """

    _s3 = s3Process(eventBucket, key)
    
    pgpEmailReceipt = "jinojoe@gmail.com"
    pgpPassword = "jinojoe"
    _pgp = pgpEnDecrypt(pgpEmailReceipt, pgpPassword)

    KEY_BUKCET = "secret-jn"
    agentName = re.split(r'/', key)[2]
    reformationFileName = _s3.ignorePathPosition(3)
    gpgProcessStateLocation = 'SFTP-PROCESS/'
    gpgFailedStateLocation = 'SFTP-FAILED/'

    """ If an object exists in the event bucket, it will execute based on conditions."""

    if (_s3.objectState()):

        """ Validate the source extension """

        if (_pgp.validationOfSource(key)):
            status = _pgp.gpgDecrypt(_s3.download(KEY_BUKCET, agentName + ".asc"), _s3.download())

            if (status['decrytionState']):
                _s3.upload(gpgProcessStateLocation, eventBucket, reformationFileName)
                _s3.createNewTag("status", "Decrypted", reformationFileName)
                _s3.delete()
            else:
                _s3.upload(gpgFailedStateLocation, eventBucket, reformationFileName)
                _s3.createNewTag("status", "Decryption failed", reformationFileName)
                _s3.delete()
        else:
            _s3.bucketToBucket(eventBucket, gpgProcessStateLocation)
            _s3.createNewTag("status", "Non Encrypted File")
            _s3.delete()
    else:
        logger.error(_s3.logPoster("unknown events"))
