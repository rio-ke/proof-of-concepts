
deploy commands

```bash
cdk deploy glueStackCreation-dev --parameters bucketName=jinojoes3bucket --parameters environment=dev --parameters roleName=jinojoes3bucket  --parameters LambdaName="jinojoes3bucket"
cdk deploy glueStackCreation-qa --parameters bucketName=jinojoes3bucket --parameters environment=dev --parameters roleName=jinojoes3bucket  --parameters LambdaName="jinojoes3bucket"
cdk deploy glueStackCreation-prod --parameters bucketName=jinojoes3bucket --parameters environment=dev --parameters roleName=jinojoes3bucket  --parameters LambdaName="jinojoes3bucket"
```

destroy commands

```bash
cdk destroy glueStackCreation-dev --parameters bucketName=jinojoes3bucket --parameters environment=dev --parameters roleName=jinojoes3bucket  --parameters LambdaName="jinojoes3bucket"
cdk destroy glueStackCreation-qa --parameters bucketName=jinojoes3bucket --parameters environment=dev --parameters roleName=jinojoes3bucket  --parameters LambdaName="jinojoes3bucket"
cdk destroy glueStackCreation-prod --parameters bucketName=jinojoes3bucket --parameters environment=dev --parameters roleName=jinojoes3bucket  --parameters LambdaName="jinojoes3bucket"
```
