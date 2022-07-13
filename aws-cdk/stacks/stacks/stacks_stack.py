from aws_cdk import (
    Stack,
)

from constructs import Construct
import aws_cdk as cdk
import aws_cdk.aws_s3 as s3
import aws_cdk.aws_s3_deployment as s3deploy


class StacksStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        bucket = s3.Bucket(self, "MyFirstBucket",
                           bucket_name="dodo-four", versioned=True)

        deployment = s3deploy.BucketDeployment(self, "MyFirstBucket",
                                               sources=["data"],
                                               destination_bucket="dodo-four"
                                               )
