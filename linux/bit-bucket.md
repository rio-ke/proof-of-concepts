```yaml
image: node
pipelines:
  branches:
    main:
      - step:
          script:
          - ENVIRONMENT="dev"
          - IMAGE_NAME="jjino/wdc:node-$ENVIRONMENT-$BITBUCKET_BUILD_NUMBER"
          - docker build -t $IMAGE_NAME .
          - echo $DOCKER_TOKEN | docker login --username $DOCKER_USERNAME --password-stdin
          - docker push $IMAGE_NAME
          services:
            - docker
```
