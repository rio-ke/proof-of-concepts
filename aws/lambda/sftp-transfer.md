_sftp-transfer.md_


```py
import paramiko
import boto3
import logging
import json
import pathlib
import urllib
import re
import os
import socket
import stat

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
        self.s3.meta.client.download_file(
            self.bucket, self.key, downloadLocation)
        return downloadLocation

    def delete(self, destinationBucket=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        return self.s3Client.delete_object(Bucket=targetBucket, Key=self.key)

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
        tag = self.s3Client.get_object_tagging(
            Bucket=self.bucket, Key=self.key)
        return tag['TagSet']

    def getSpecificTagDetails(self, t_name):
        tags = self.s3Client.get_object_tagging(
            Bucket=self.bucket, Key=self.key)
        data = tags['TagSet']
        if data == []:
            return False
        else:
            for element in data:
                if element['Key'] == t_name:
                    return element['Value']
            return False

    def updateTags(self, destinationBucket=None, updationTags=None):
        targetBucket = destinationBucket if destinationBucket != None else self.bucket
        updationTagLists = updationTags if updationTags != None else self.getTags()
        return self.s3Client.put_object_tagging(Bucket=targetBucket, Key=self.key, Tagging={'TagSet': updationTagLists})

    def logPoster(self, state):
        return json.dumps({'Bucket': self.bucket, 'fileName': self.key, 'processState': state})

    def ignorePathPosition(self, pathPosition):
        data = re.split(r'/', self.key)
        return ("/".join(data[pathPosition:]))


class RemoteTransfer:
    """A wrapper for paramiko sftp client"""
    TIMEOUT = 5

    def __init__(self, host, username, port=22, key=None, key_passphrase=None, password=None, downloaded_files=None):
        self.host = host
        self.username = username
        self.port = port
        self.key = key
        self.key_passphrase = key_passphrase
        self.password = password
        self.downloaded_files = downloaded_files

    def connect(self):
        """Connect to the remote server"""
        try:
            self.client = paramiko.SSHClient()
            self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            if self.key is not None:
                self.key = paramiko.RSAKey.from_private_key_file(self.key)
            self.client.connect(hostname=self.host, username=self.username, port=self.port, password=self.password, pkey=self.key, passphrase=self.key_passphrase, timeout=self.TIMEOUT)
            self.sftp_client = self.client.open_sftp()
            print('Connected to remote', self.host)
        except Exception as e:
            if isinstance(e, paramiko.SSHException):
                print("Could not establish SSH connection: %s" % e)
            elif isinstance(e, socket.timeout):
                print("Connection timed out")
            else:
                print("Error connecting to remote: " + repr(e))
            self.disconnect()

    def list_remote_dir(self, remotepath, show_hidden=True):
        try:
            dir_contents = self.sftp_client.listdir(remotepath)
            if show_hidden is False:
                dir_contents = [i for i in dir_contents if not i.startswith('.')]
            return dir_contents
        except Exception as e:
            if isinstance(e, IOError):
                print('%s is an invalid directory path' % remotepath)
            else:
                print('Error listing remote directory contents: ' + repr(e))
            self.disconnect()

    def remote_download(self, remotepath, localpath, copy_hidden_files=True, copy_symlink_files=True, remove=False):
        self.downloaded_files = []
        try:
            if self.client is not None and self.sftp_client is not None:
                if not os.path.isdir(localpath):
                    self.disconnect()
                    print('local path must be a directory')
                if self.remote_isdir(remotepath):
                    file_counter = 0
                    dir_contents = self.list_remote_dir(remotepath)
                    if copy_hidden_files is False:
                        dir_contents = [i for i in dir_contents if not i.startswith('.')]
                    for indx, item in enumerate(dir_contents):
                        # determine remote file separator
                        if indx == 0:
                            linuxpath = '/'.join([remotepath, item])
                            try:
                                _lstat_out = self.sftp_client.lstat(linuxpath)
                                path_sep = '/'
                            except:
                                path_sep = '\\'
                        _remotepath = path_sep.join([remotepath, item])
                        _localpath = os.path.join(localpath, item)
                        # download
                        if copy_symlink_files is True:
                            download_bool = self.remote_isfile(_remotepath)
                            if download_bool is False and self.remote_islink(_remotepath):
                                try:
                                    download_bool = self.remote_isfile(self.sftp_client.normalize(_remotepath))
                                except:
                                    pass
                        else:
                            download_bool = self.remote_isfile(_remotepath)
                        if download_bool is True:
                            self.sftp_client.get(_remotepath, _localpath)
                            self.downloaded_files.append(_remotepath)
                            file_counter += 1
                        else:
                            print('skipped %s' % item)
                    print('Downloaded %s files from remote directory:\n' % file_counter, remotepath, '\n...to local directory:\n', localpath)
                else:
                    try:
                        _remotepath = self.sftp_client.normalize(remotepath)
                        if self.remote_isfile(_remotepath):
                            _localpath = os.path.join(localpath, os.path.split(remotepath)[-1])
                            self.sftp_client.get(remotepath, _localpath)
                            self.downloaded_files.append(remotepath)
                            print('Downloaded file from remote directory:\n', remotepath, '\n...to local directory:\n', localpath)
                        else:
                            print('Remote path must be a file')
                    except:
                        print('Remote path must be a valid filepath')
                if remove is True:
                    self.remove_downloaded()
                    print('Removed downloaded files from remote directory')
            else:
                self.disconnect()
                print('Could not establish SSH connection')
        except Exception as e:
            print('Error downloading from the remote server: %s' % e)
            self.disconnect()

    def remote_upload(self, remotepath, localpath, copy_hidden_files=True, copy_symlink_files=True, remove=False):
        self.uploaded_files = []
        try:
            if self.client is not None and self.sftp_client is not None:
                if not self.remote_isdir(remotepath):
                    self.disconnect()
                    print('remote path must be a directory')
                if os.path.isdir(localpath):
                    file_counter = 0
                    dir_contents = os.listdir(localpath)
                    if copy_hidden_files is False:
                        dir_contents = [i for i in dir_contents if not i.startswith('.')]
                    for indx, item in enumerate(dir_contents):
                        _remotepath_linux = '/'.join([remotepath, item])
                        _remotepath_windows = '\\'.join([remotepath, item])
                        _localpath = os.path.join(localpath, item)
                        if copy_symlink_files is False:
                            if os.path.islink(_localpath):
                                print('skipped %s' % item)
                                continue
                        # upload
                        try:
                            self.sftp_client.put(_localpath, _remotepath_linux)
                            self.uploaded_files.append(_localpath)
                            file_counter += 1
                        except:
                            self.sftp_client.put(_localpath, _remotepath_windows)
                            self.uploaded_files.append(_localpath)
                            file_counter += 1
                    print('Uploaded %s files from local directory:\n' % file_counter, localpath, '\n...to remote directory:\n', remotepath)
                else:
                    if os.path.isfile(localpath):
                        _localfile = os.path.split(localpath)[-1]
                        linuxpath = '/'.join([remotepath, _localfile])
                        try:
                            _lstat_out = self.sftp_client.lstat(linuxpath)
                            path_sep = '/'
                        except:
                            path_sep = '\\'
                        _remotepath = path_sep.join([remotepath, _localfile])
                        self.sftp_client.put(localpath, _remotepath)
                        self.uploaded_files.append(localpath)
                    else:
                        print('Local path must be a directory or a file')
                if remove is True:
                    self.remove_uploaded()
                    print('Removed uploaded files from local directory')

        except Exception as e:
            print('Error uploading to the remote server: %s' % e)
            self.disconnect()

    def remove_downloaded(self):
        """Remove downloaded files after downloading to local directory (filenames are recorded in self.downloaded_files)"""
        for item in self.downloaded_files:
            self.sftp_client.remove(item)
        self.downloaded_files = []

    def remove_uploaded(self):
        """Remove uploaded files after uploading to remote server (filenames are recorded in self.uploaded_files)"""
        for item in self.uploaded_files:
            os.remove(item)
        self.uploaded_files = []

    def remote_isdir(self, remotepath):
        fileattr = self.sftp_client.lstat(remotepath)
        if stat.S_ISDIR(fileattr.st_mode):
            return True
        else:
            return False

    def remote_isfile(self, remotepath):
        fileattr = self.sftp_client.lstat(remotepath)
        if stat.S_ISREG(fileattr.st_mode):
            return True
        else:
            return False

    def remote_islink(self, remotepath):
        fileattr = self.sftp_client.lstat(remotepath)
        if stat.S_ISLNK(fileattr.st_mode):
            return True
        else:
            return False

    def disconnect(self):
        """Disconnect from remote server"""
        if self.client is not None:
            self.client.close()
            self.client = None
        if self.sftp_client is not None:
            self.sftp_client.close()
            self.sftp_client = None
        print('Disconnected from remote', self.host)


def getSecret(secret, region):
    secret_name = secret
    client = boto3.client('secretsmanager', region_name=region)
    get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    secret = get_secret_value_response['SecretString']
    return secret

def lambda_handler(event, context):
    """ Event Capture process"""

    eventName = event['detail']['eventName']
    eventBucket = urllib.parse.unquote_plus(
        event['detail']['requestParameters']['bucketName'])
    key = urllib.parse.unquote_plus(
        event['detail']['requestParameters']['key'])

    """ Logger initiate process """

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    _s3 = s3Process(eventBucket, key)

    if (_s3.objectState()):
        local_path = _s3.download()
        remote_path = pathlib.PurePath(local_path).name
        sftpDetails = json.loads(
        getSecret("agenta-sftp-credentials", "ap-southeast-1"))
        Username = sftpDetails['username']
        Hostname = sftpDetails['hostname']
        private_key = getSecret("ssh-key", "ap-southeast-1")

        conn = RemoteTransfer(host=Hostname, username=Username, port=22, key=private_key)
        conn.connect()
        conn.remote_upload(remote_path, local_path, remove=True)
        conn.disconnect()
    else:
        logger.error(_s3.logPoster("unknown events"))


```
