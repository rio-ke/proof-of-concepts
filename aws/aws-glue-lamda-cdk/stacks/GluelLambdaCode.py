from aws_cdk import (
    Stack,
    aws_iam as iam,
    aws_s3 as s3,
    aws_lambda as lambda_,
    aws_s3_notifications as s3n
)
from constructs import Construct


class GluelLambdaCode(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        s3BucketDefine = s3.Bucket(
            self,
            id='s3BucketDefineId',
            bucket_name="dodo-glue-bucket",
        )

        lambdaGlueCloudWatchPolicy = iam.PolicyDocument(
            statements=[
                iam.PolicyStatement(
                    actions=['cloudwatch:*'],
                    effect=iam.Effect.ALLOW,
                    resources=['*']
                ),
                iam.PolicyStatement(
                    actions=['logs:*'],
                    effect=iam.Effect.ALLOW,
                    resources=['*']
                )
            ],
        )

        lambdaS3BucketAccess = iam.PolicyDocument(
            statements=[
                iam.PolicyStatement(
                    actions=['s3:*'],
                    effect=iam.Effect.ALLOW,
                    resources=['*']
                )
            ],
        )

        glueRoleDefine = iam.Role(
            self,
            id='glueRoleDefineId',
            role_name="dodo_lambda_gule_role",
            assumed_by=iam.ServicePrincipal('glue.amazonaws.com'),
            inline_policies={
                'CloudWatch': lambdaGlueCloudWatchPolicy
            }
        )

        GlueJobS3ReadPolicy = iam.PolicyStatement(
            actions=[
                "s3:GetObject*",
                "s3:GetBucket*",
                "s3:List*",
                "s3:DeleteObject*",
                "s3:PutObject*",
                "s3:Abort*"
            ],
            effect=iam.Effect.ALLOW,
            resources=['*']
        )

        glueRoleDefine.add_to_policy(statement=GlueJobS3ReadPolicy)

        lambdaRoleDefine = iam.Role(
            self,
            id='lambdaRoleDefineId',
            role_name="dodo_lambda_role",
            assumed_by=iam.ServicePrincipal("lambda.amazonaws.com"),
            inline_policies={
                'lambdaGlueCloudWatchPolicy': lambdaGlueCloudWatchPolicy,
                'lambdaS3BucketAccess': lambdaS3BucketAccess,
                'lambdaGlueCreationStartRole': iam.PolicyDocument(
                    statements=[
                        iam.PolicyStatement(
                            actions=[
                                'glue:CreateJob',
                                'glue:StartJobRun'
                            ],
                            effect=iam.Effect.ALLOW,
                            resources=['*']
                        ),
                        iam.PolicyStatement(
                            actions=['iam:PassRole'],
                            effect=iam.Effect.ALLOW,
                            resources=[glueRoleDefine.role_arn]
                        )
                    ]
                )
            }
        )

        lambdaFunctionDefine = lambda_.Function(
            self,
            id='lambdaFunctionDefineId',
            function_name="dodo_lambda",
            code=lambda_.Code.from_asset('lambdaCode'),
            handler='lambdaCode.lambda_handler',
            runtime=lambda_.Runtime.PYTHON_3_9,
            role=lambdaRoleDefine,
            retry_attempts=0,
            environment={
                'ROLE_NAME': glueRoleDefine.role_name
            }
        )

        s3BucketDefine.add_event_notification(
            s3.EventType.OBJECT_CREATED, s3n.LambdaDestination(lambdaFunctionDefine))


# https://docs.aws.amazon.com/cdk/api/v2/python/index.html
