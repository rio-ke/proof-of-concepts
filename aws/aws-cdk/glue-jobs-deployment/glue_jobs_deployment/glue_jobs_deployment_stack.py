import aws_cdk as cdk
import aws_cdk.aws_s3 as s3
from aws_cdk import (
    Stack,
)
from constructs import Construct


class GlueJobsDeploymentStack(Stack):

    def __init__(self, scope: cdk.App, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        bucket = s3.Bucket(self, "MyFirstBucket", versioned=True)
