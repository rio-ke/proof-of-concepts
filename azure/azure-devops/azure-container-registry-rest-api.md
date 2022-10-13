

container acr rest api use username and password

```bash
DOCKER_REGISTRY="xxx.azurecr.io"
DOCKER_USERNAME="xxx"
DOCKER_PASSWORD="xxx"
DOCKER_IMAGE_NAME_AS_VARIABLE="dodo-app/dev"
OPERATION="/v2/${DOCKER_IMAGE_NAME_AS_VARIABLE}/tags/list"
CREDENTIALS=$(echo -n "${DOCKER_USERNAME}:${DOCKER_PASSWORD}" | base64 -w 0)
RETURN_DOCKER_IMAGE_NAME=$(curl -s -H "Authorization: Basic ${CREDENTIALS}" https://${DOCKER_REGISTRY}${OPERATION} | jq '.name' | sed -e 's/^"//' -e 's/"$//')
RETURN_DOCKER_IMAGE_TAG_NAME=$(curl -s -H "Authorization: Basic ${CREDENTIALS}" https://${DOCKER_REGISTRY}${OPERATION} | jq '.tags[-1]' | sed -e 's/^"//' -e 's/"$//')
echo "${RETURN_DOCKER_IMAGE_NAME}/${RETURN_DOCKER_IMAGE_TAG_NAME}"
```
azure devOps tasks

```yml
parameters:
  dockerRegistryURL: ''
  imageName: ''
  dockerUsername: ''
  dockerPassword: ''
steps:
- script: |
    # DOCKER_REGISTRY_URL="xxx.azurecr.io"
    # DOCKER_USERNAME="xxx"
    # DOCKER_PASSWORD="xxx"
    # DOCKER_IMAGE_NAME_AS_VARIABLE="nexuscore-nc-address-parsing-app/dev"
    OPERATION="/v2/${DOCKER_IMAGE_NAME_AS_VARIABLE}/tags/list"
    CREDENTIALS=$(echo -n "${DOCKER_USERNAME}:${DOCKER_PASSWORD}" | base64 -w 0)
    RETURN_DOCKER_IMAGE_NAME=$(curl -s -H "Authorization: Basic ${CREDENTIALS}" https://${DOCKER_REGISTRY_URL}${OPERATION} | jq '.name' | sed -e 's/^"//' -e 's/"$//')
    RETURN_DOCKER_IMAGE_TAG_NAME=$(curl -s -H "Authorization: Basic ${CREDENTIALS}" https://${DOCKER_REGISTRY_URL}${OPERATION} | jq '.tags[-1]' | sed -e 's/^"//' -e 's/"$//')
    IMAGE_NAME="${RETURN_DOCKER_IMAGE_NAME}/${RETURN_DOCKER_IMAGE_TAG_NAME}"
    echo "##vso[task.setvariable variable=DOCKER_IMAGE_NAME]${IMAGE_NAME}"
  env:
    DOCKER_REGISTRY_URL: ${{ parameters.dockerRegistryURL }}
    DOCKER_USERNAME: ${{ parameters.dockerUsername }}
    DOCKER_PASSWORD: ${{ parameters.dockerPassword }}
    DOCKER_IMAGE_NAME_AS_VARIABLE: ${{ parameters.imageName }}
  displayName: 'Get docker image name for higher environments'
```

https://github.com/Azure/acr/blob/main/docs/AAD-OAuth.md
