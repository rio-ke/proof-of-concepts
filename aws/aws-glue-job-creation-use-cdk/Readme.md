
deploy commands

```bash
cdk deploy glueStackCreation --parameters bucketName=jinojoes3bucket --parameters environment=dev --parameters roleName=jinojoes3bucket  --parameters LambdaName="jinojoes3bucket"
```

destroy commands

```bash
cdk destroy glueStackCreation --parameters bucketName=jinojoes3bucket --parameters environment=dev --parameters roleName=jinojoes3bucket --parameters LambdaName="jinojoes3bucket"
```