


```yml
dev:
  variables:
    CLUSTER_NAME: damo.k8s.local
    STATE_STORE: s3://awsjinojino
    NODE_COUNT: 2
    NODE_SIZE: t2.large
    MASTER_SIZE: t2.medium
    ZONE_NAME: us-east-1a
  before_script:
    - echo $CLUSTER_NAME
  script:
    - echo $STATE_STORE
  after_script:
    - echo $NODE_COUNT
uat:
  variables:
    CLUSTER_NAME: damo.k8s.local
    STATE_STORE: s3://awsjinojino
    NODE_COUNT: 2
    NODE_SIZE: t2.large
    MASTER_SIZE: t2.medium
    ZONE_NAME: us-east-1a
  before_script:
    - echo $CLUSTER_NAME
  script:
    - echo $STATE_STORE
  after_script:
    - echo $NODE_COUNT
prod:
  variables:
    CLUSTER_NAME: damo.k8s.local
    STATE_STORE: s3://awsjinojino
    NODE_COUNT: 2
    NODE_SIZE: t2.large
    MASTER_SIZE: t2.medium
    ZONE_NAME: us-east-1a
  before_script:
    - echo $CLUSTER_NAME
  script:
    - echo $STATE_STORE
  after_script:
    - echo $NODE_COUNT
```



```yml
stages:
  - build
  - test
  - deploy

image: alpine

build_a:
  stage: build
  script:
    - echo "This job builds something."

build_b:
  stage: build
  script:
    - echo "This job builds something else."

test_a:
  stage: test
  script:
    - echo "This job tests something. It will only run when all jobs in the"
    - echo "build stage are complete."

test_b:
  stage: test
  script:
    - echo "This job tests something else. It will only run when all jobs in the"
    - echo "build stage are complete too. It will start at about the same time as test_a."

deploy_a:
  stage: deploy
  script:
    - echo "This job deploys something. It will only run when all jobs in the"
    - echo "test stage complete."
  environment: production

deploy_b:
  stage: deploy
  script:
    - echo "This job deploys something else. It will only run when all jobs in the"
    - echo "test stage complete. It will start at about the same time as deploy_a."
  environment: production
```
