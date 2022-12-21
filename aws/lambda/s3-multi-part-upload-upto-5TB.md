
_code_

```py
import os
import boto3
import json

class muitiPartUpload(object):
    # AWS throws EntityTooSmall error for parts smaller than 5 MB
    PART_MINIMUM = int(5e6)
    def __init__(self,bucket,key,local_path,part_size=int(15e6),verbose=False):
        
        self.bucket = bucket
        self.key = key
        self.path = local_path
        self.total_bytes = os.stat(local_path).st_size
        self.part_bytes = part_size

        assert part_size > self.PART_MINIMUM
        assert (self.total_bytes % part_size == 0 or self.total_bytes % part_size > self.PART_MINIMUM)
        self.s3 = boto3.client("s3")
        if verbose:
            boto3.set_stream_logger(name="botocore")

    def abort_all(self):
        mpus = self.s3.list_multipart_uploads(Bucket=self.bucket)
        aborted = []
        print("Aborting", len(mpus), "uploads")
        if "Uploads" in mpus:
            for u in mpus["Uploads"]:
                print(u)
                upload_id = u["UploadId"]
                aborted.append(self.s3.abort_multipart_upload(Bucket=self.bucket, Key=self.key, UploadId=upload_id))
        return aborted

    def create(self):
        mpu = self.s3.create_multipart_upload(Bucket=self.bucket, Key=self.key)
        mpu_id = mpu["UploadId"]
        return mpu_id

    def upload(self, mpu_id):
        parts = []
        uploaded_bytes = 0
        with open(self.path, "rb") as f:
            i = 1
            while True:
                data = f.read(self.part_bytes)
                if not len(data):
                    break
                part = self.s3.upload_part(Body=data, Bucket=self.bucket, Key=self.key, UploadId=mpu_id, PartNumber=i)
                parts.append({"PartNumber": i, "ETag": part["ETag"]})
                uploaded_bytes += len(data)
                print("{0} of {1} uploaded ({2:.3f}%)".format(uploaded_bytes, self.total_bytes, as_percent(uploaded_bytes, self.total_bytes)))
                i += 1
        return parts

    def complete(self, mpu_id, parts):
        result = self.s3.complete_multipart_upload(Bucket=self.bucket,Key=self.key,UploadId=mpu_id,MultipartUpload={"Parts": parts})
        return result

# Helper
def as_percent(num, denom):
    return float(num) / float(denom) * 100.0

def main():
    mpu = muitiPartUpload("secret-jn", "mediacreationtool.exe", "/home/operation-unknown/Documents/demo/mediacreationtool.exe")
    # abort all multipart uploads for this bucket (optional, for starting over)
    mpu.abort_all()
    # create new multipart upload
    mpu_id = mpu.create()
    # upload parts
    parts = mpu.upload(mpu_id)
    print(parts)
    # complete multipart upload
    print(mpu.complete(mpu_id, parts))

if __name__ == "__main__":
    main()
```
