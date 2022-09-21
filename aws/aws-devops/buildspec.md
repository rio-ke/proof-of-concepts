

buildspec-dev.yml

```yml
version: 0.2
phases: 
  install:
    commands: 
      - aws --version
  pre_build: 
    commands: 
    - echo Build started on `date` 
    - aws s3 cp --recursive . s3://bucketname/ --exclude "*.md" --exclude ".git/*" --exclude ".gitignore"
  build: 
    commands: 
    - curl -s -XGET -o /dev/null -I -w "%{http_code}" https://wx7bcyhfq5.execute-api.ap-south-1.amazonaws.com/prod/lambda
  post_build: 
    commands: 
    - echo Build completed on `date` 
```

buildspec-prod.yml

```yml
version: 0.2
phases: 
  install:
    commands: 
      - aws --version
  pre_build: 
    commands: 
    - echo Build started on `date` 
    - aws s3 cp --recursive . s3://bucketname/
  build: 
    commands: 
    - curl -s -XGET https://wx7bcyhfq5.execute-api.ap-south-1.amazonaws.com/prod/lambda
  post_build: 
    commands: 
    - echo Build completed on `date` 
```

buildspec-qa.yml

```yml
version: 0.2
phases: 
  install:
    commands: 
      - aws --version
  pre_build: 
    commands: 
    - echo Build started on `date` 
    - aws s3 cp --recursive . s3://bucketname/
  build: 
    commands: 
    - curl -s -XGET https://wx7bcyhfq5.execute-api.ap-south-1.amazonaws.com/prod/lambda
  post_build: 
    commands: 
    - echo Build completed on `date` 
```

final yaml

```yml
version: 0.2
phases: 
  install:
    commands: 
      - aws --version
      - curl --version
  pre_build: 
    commands: 
    - echo Build started on `date` 
    - aws s3 cp --recursive . s3://bucketname/ --exclude "*.md" --exclude ".git/*" --exclude ".gitignore"
  build: 
    commands: 
    - |
      statusCode=$(curl -s -XGET -o /dev/null -I -w "%{http_code}" https://wx7bcyhfq5.execute-api.ap-south-1.amazonaws.com/prod/lambda)
      if [ "$statusCode" = 200 ] ; then
        echo "Deployment success"
      else:
        exit 1
      fi
  post_build: 
    commands: 
    - echo Build completed on `date` 
```
