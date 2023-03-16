
main.py

```py
import sys
import json


def get_updated_task_defn(task_defn_file_name, updated_image):
    with open(task_defn_file_name, 'r') as f:
        data = json.load(f)
        print(data)
        data["containerDefinitions"][0]["image"] = updated_image
        del data["status"]
        #del data["registeredAt"]
        #del data["registeredBy"]
        del data["requiresAttributes"]
        del data["compatibilities"]
        del data["taskDefinitionArn"]
        del data["revision"]
    return data


def update_task_defn(task_defn_file_name, data):
    with open(task_defn_file_name, 'w') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)


args = sys.argv[1:]
task_defn_file_name = args[0]
updated_image = args[1]

updated_task_defn = get_updated_task_defn(task_defn_file_name, updated_image)
update_task_defn(task_defn_file_name, updated_task_defn)

```

```bash
REPOSITORY_URL="nginx"
IMAGE_TAG="latest"
AWS_DEFAULT_REGION="ap-southeast-1"
TASK_DEFINITION_NAME="worker"
AWS_ECS_SERVICE="worker"
CLUSTER_NAME="gino-cluster"
aws ecs describe-task-definition --task-definition $TASK_DEFINITION_NAME --output json --query taskDefinition > task-definition.json

aws ecs deregister-task-definition --task-definition $TASK_DEFINITION_NAME 

python3 main.py task-definition.json $REPOSITORY_URL:$IMAGE_TAG
aws ecs register-task-definition --cli-input-json file://task-definition.json

aws ecs update-service  --region $AWS_DEFAULT_REGION --cluster $CLUSTER_NAME --service $AWS_ECS_SERVICE --task-definition $TASK_DEFINITION_NAME --force-new-deployment

```
