from aws_cdk import (
    Stack,
    aws_iam as iam,
    aws_s3 as s3,
    aws_lambda as lambda_,
    aws_s3_notifications as s3n
)
import aws_cdk
from constructs import Construct


class glueStackCreation(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        sourceEnvironment = aws_cdk.CfnParameter(self, "environment", type="String")
        sourceBucketName = aws_cdk.CfnParameter(self, "bucketName", type="String")
        sourceRoleName = aws_cdk.CfnParameter(self, "roleName", type="String")
        sourceLambdaName = aws_cdk.CfnParameter(self, "LambdaName", type="String")

        bucketName = sourceBucketName.value_as_string + "-" + sourceEnvironment.value_as_string + "-s3"
        roleName = sourceRoleName.value_as_string + "-" + sourceEnvironment.value_as_string + "-role"
        lambdaName = sourceLambdaName.value_as_string + "-" + sourceEnvironment.value_as_string + "-lambda"
        glueRolePolicy = sourceRoleName.value_as_string + "-" + sourceEnvironment.value_as_string + "-role-policy"

        s3BucketDefine = s3.Bucket(
            self,
            id='s3BucketDefineId',
            bucket_name=bucketName
        )

        gluejobPolicyDefine = iam.PolicyDocument(
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
                ),
                iam.PolicyStatement(
                    actions=['s3:*'],
                    effect=iam.Effect.ALLOW,
                    resources=['*']
                ),
                iam.PolicyStatement(
                    actions=['glue:*'],
                    effect=iam.Effect.ALLOW,
                    resources=['*']
                )
            ],
        )

        glueRoleDefine = iam.Role(
            self,
            id='glueRoleDefineId',
            role_name=roleName,
            assumed_by=iam.ServicePrincipal('glue.amazonaws.com'),
            inline_policies={
                glueRolePolicy: gluejobPolicyDefine
            }
        )

        lambdaRoleDefine = iam.Role(
            self,
            id='lambdaRoleDefineId',
            role_name=lambdaName + "-role",
            assumed_by=iam.ServicePrincipal("lambda.amazonaws.com"),
            inline_policies={
                'lambdaGlueS3AndCloudWatchPolicy': gluejobPolicyDefine,
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
                        ),
                        iam.PolicyStatement(
                            actions=['lambda:InvokeFunction'],
                            effect=iam.Effect.ALLOW,
                            resources=['*']
                        )
                    ]
                )
            }
        )

        lambdaFunctionDefine = lambda_.Function(
            self,
            id='lambdaFunctionDefineId',
            function_name=lambdaName,
            code=lambda_.Code.from_asset('lambdaCode'),
            handler='lambdaCode.lambda_handler',
            runtime=lambda_.Runtime.PYTHON_3_9,
            role=lambdaRoleDefine,
            retry_attempts=0,
            environment={
                'ROLE_NAME': glueRoleDefine.role_name,
                'ENVIRONMENT_NAME': sourceEnvironment.value_as_string
            }
        )

        s3BucketDefine.add_event_notification(
            s3.EventType.OBJECT_CREATED,
            s3n.LambdaDestination(lambdaFunctionDefine),
            s3.NotificationKeyFilter(
                prefix="source/",
                suffix="*.py",
            ),
        )

        aws_cdk.CfnOutput(scope=self, id='lambda-name',value=lambdaFunctionDefine.function_name)
        aws_cdk.CfnOutput(scope=self, id='s3-bucket-name',value=s3BucketDefine.bucket_name)
