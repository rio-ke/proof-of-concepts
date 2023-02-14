


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
