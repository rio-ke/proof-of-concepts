import json
import gnupg
import re
import os
import pathlib
import boto3
import urllib


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

    def download(self):
        downloadLocation = self.tempdir + self.childName
        self.s3.meta.client.download_file(self.bucket, self.key, downloadLocation)
        return downloadLocation

    def delete(self, destinationBucket=None):
        targetBucket = destinationBucket if destinationBucket != None else self.key
        return self.s3Client.delete_object(Bucket=self.bucket, Key=targetBucket)

    def upload(self, uploadKey):
        return self.s3.meta.client.upload_file(uploadKey, self.bucket, uploadKey)

    def bucketToBucket(self, destinationBucket, customLocation=None):
        targetPath = customLocation + self.childName if customLocation != None else self.key
        source = {'Bucket': self.bucket, 'Key': self.key}
        return self.s3Client.copy_object(CopySource=source, Bucket=destinationBucket, Key=targetPath, TaggingDirective='COPY', ChecksumAlgorithm=self.ChecksumAlgorithm)

    def createNewTag(self, t_name, t_value):
        tagging = {'TagSet': [{'Key': t_name, 'Value': t_value}]}
        return self.s3Client.put_object_tagging(Bucket=self.bucket, Key=self.key, Tagging=tagging)

    def objectState(self):
        return 'Contents' in self.s3Client.list_objects(Bucket=self.bucket, Prefix=self.key)

    def getTags(self):
        tag = self.s3Client.get_object_tagging(Bucket=self.bucket, Key=self.key)
        return tag['TagSet']

    def getSpecificTagDetails(self, t_name):
        tags = self.s3Client.get_object_tagging(Bucket=self.bucket, Key=self.key)
        data = tags['TagSet']
        print(data)
        if data == []:
            return False
        else:
            for element in data:
                if element['Key'] == t_name:
                    return element['Value']
            return False

    def updateTags(self, updationTags=None):
        updationTagLists = updationTags if updationTags != None else self.getTags()
        return self.s3Client.put_object_tagging(Bucket=self.bucket, Key=self.key, Tagging={'TagSet': updationTagLists})

_s3 = s3Process("secret-jn", "main.txt")

