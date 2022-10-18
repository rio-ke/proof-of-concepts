

```yml
parameters:
  dockerRegistryURL: ''
  imageName: ''
  dockerUsername: ''
  dockerPassword: ''
  customImageTag: ''
  devDockerRegistryServiceConnectionEndpoint: ''
  qaDockerRegistryServiceConnectionEndpoint: ''
  qaDockerRegistryServerName: ''
jobs:
- job: ${{ parameters.name }}
  pool: 
    vmImage: ubuntu-20.04
  steps:
    - script: |
        OPERATION="/v2/${DOCKER_IMAGE_NAME_AS_VARIABLE}/tags/list"
        CREDENTIALS=$(echo -n "${DOCKER_USERNAME}:${DOCKER_PASSWORD}" | base64 -w 0)
        RETURN_DOCKER_IMAGE_NAME=$(curl -s -H "Authorization: Basic ${CREDENTIALS}" https://${DOCKER_REGISTRY_URL}${OPERATION} | jq '.name' | sed -e 's/^"//' -e 's/"$//')
        RETURN_DOCKER_IMAGE_TAG_NAME=$(curl -s -H "Authorization: Basic ${CREDENTIALS}" https://${DOCKER_REGISTRY_URL}${OPERATION} | jq '.tags[-1]' | sed -e 's/^"//' -e 's/"$//')
        IMAGE_NAME="${RETURN_DOCKER_IMAGE_NAME}:${RETURN_DOCKER_IMAGE_TAG_NAME}"
        echo "##vso[task.setvariable variable=DOCKER_IMAGE_NAME_WITH_TAG]${DOCKER_REGISTRY_URL}/${IMAGE_NAME}"
        echo "##vso[task.setvariable variable=DOCKER_IMAGE_NAME]${DOCKER_REGISTRY_URL}/${RETURN_DOCKER_IMAGE_NAME}"
        echo "##vso[task.setvariable variable=DOCKER_IMAGE_ONLY]${RETURN_DOCKER_IMAGE_NAME}"
        echo "##vso[task.setvariable variable=DOCKER_IMAGE_TAG]${RETURN_DOCKER_IMAGE_TAG_NAME}"
      env:
        DOCKER_REGISTRY_URL: ${{ parameters.dockerRegistryURL }}   # DOCKER_REGISTRY_URL="xxx.azurecr.io"
        DOCKER_USERNAME: ${{ parameters.dockerUsername }}          # DOCKER_USERNAME="xxx"
        DOCKER_PASSWORD: ${{ parameters.dockerPassword }}          # DOCKER_PASSWORD="xxx"
        DOCKER_IMAGE_NAME_AS_VARIABLE: ${{ parameters.imageName }} # DOCKER_IMAGE_NAME_AS_VARIABLE="nexuscore-nc-address-parsing-app/dev"
      displayName: 'Get latest docker image name for higher environments'
      condition: eq('${{ parameters.customImageTag }}', '')

    - script: |
        OPERATION="/v2/${DOCKER_IMAGE_NAME_AS_VARIABLE}/tags/list"
        CREDENTIALS=$(echo -n "${DOCKER_USERNAME}:${DOCKER_PASSWORD}" | base64 -w 0)
        RETURN_DOCKER_IMAGE_NAME=$(curl -s -H "Authorization: Basic ${CREDENTIALS}" https://${DOCKER_REGISTRY_URL}${OPERATION} | jq '.name' | sed -e 's/^"//' -e 's/"$//')
        RETURN_DOCKER_IMAGE_TAG_NAME=$(curl -s -H "Authorization: Basic ${CREDENTIALS}" https://${DOCKER_REGISTRY_URL}${OPERATION} | jq '.tags[]' | grep "${CUSTOM_TAG}" | sed -e 's/^"//' -e 's/"$//')
        IMAGE_NAME="${RETURN_DOCKER_IMAGE_NAME}:${RETURN_DOCKER_IMAGE_TAG_NAME}"
        echo "##vso[task.setvariable variable=DOCKER_IMAGE_NAME_WITH_TAG]${DOCKER_REGISTRY_URL}/${IMAGE_NAME}"
        echo "##vso[task.setvariable variable=DOCKER_IMAGE_NAME]${DOCKER_REGISTRY_URL}/${RETURN_DOCKER_IMAGE_NAME}"
        echo "##vso[task.setvariable variable=DOCKER_IMAGE_ONLY]${RETURN_DOCKER_IMAGE_NAME}"
        echo "##vso[task.setvariable variable=DOCKER_IMAGE_TAG]${RETURN_DOCKER_IMAGE_TAG_NAME}"
      env:
        DOCKER_REGISTRY_URL: ${{ parameters.dockerRegistryURL }}
        DOCKER_USERNAME: ${{ parameters.dockerUsername }}
        DOCKER_PASSWORD: ${{ parameters.dockerPassword }}
        DOCKER_IMAGE_NAME_AS_VARIABLE: ${{ parameters.imageName }}
        CUSTOM_TAG: ${{ parameters.customImageTag }}
      displayName: 'Get specific docker image name for higher environments'
      condition: ne('${{ parameters.customImageTag }}', '')
      
    - script: |
        echo "Docker image name and tag         => ${dockerImageNameWithTag}"
        echo "Docker image name                 => ${dockerImageName}"
        echo "Docker image tag                  => ${dockerImageTag}"
        echo "Docker image without registry URL => ${dockerImageWithOutRegName}"
      env:
        dockerImageNameWithTag: $(DOCKER_IMAGE_NAME_WITH_TAG)
        dockerImageName: $(DOCKER_IMAGE_NAME)
        dockerImageTag: $(DOCKER_IMAGE_TAG)
        dockerImageWithOutRegName: $(DOCKER_IMAGE_ONLY)
      displayName: 'print the docker image name and tag'

    - script: |
        echo "##vso[task.setvariable variable=CERTIFY_DOCKER_IMAGE]${CERTIFY_DOCKER_REGISTRY_URL}/${DOCKER_IMAGE_ONLY}:qa-${DOCKER_IMAGE_TAG}"
      env: 
        CERTIFY_DOCKER_REGISTRY_URL: '${{ parameters.certifyDockerRegistryServerName }}'
        DOCKER_IMAGE_ONLY: $(DOCKER_IMAGE_ONLY)
        DOCKER_IMAGE_TAG: $(DOCKER_IMAGE_TAG)
      displayName: 'prepare certify docker image'

    - script: |
        echo "${CERTIFY_DOCKER_IMAGE}"
      env:
        CERTIFY_DOCKER_IMAGE: $(CERTIFY_DOCKER_IMAGE)
      displayName: 'print certify docker image'

    - task: Docker@1
      displayName: Container registry login
      inputs:
        command: login
        containerregistrytype: Container Registry
        dockerRegistryEndpoint: ${{ parameters.devDockerRegistryServiceConnectionEndpoint }}

    - script: |
        docker pull "${DOCKER_IMAGE}"
      env:
        DOCKER_IMAGE: $(DOCKER_IMAGE_NAME_WITH_TAG)
      displayName: 'pull docker image'

    - script: |
        docker tag "${DOCKER_IMAGE_NAME_WITH_TAG}" "${CERTIFY_DOCKER_IMAGE}"
      env:
        CERTIFY_DOCKER_IMAGE: $(CERTIFY_DOCKER_IMAGE)
      displayName: 'tag certify docker image'

    - task: Docker@1
      displayName: Container registry logout
      inputs:
        command: logout
        containerregistrytype: Container Registry
        dockerRegistryEndpoint: ${{ parameters.devDockerRegistryServiceConnectionEndpoint }}

    - task: Docker@1
      displayName: certify container registry login
      inputs:
        command: login
        containerregistrytype: Container Registry
        dockerRegistryEndpoint: ${{ parameters.qaDockerRegistryServiceConnectionEndpoint }}

    - task: Docker@1
      inputs:
        command: push
        imageName: $(CERTIFY_DOCKER_IMAGE)
      displayName: 'Certify Push docker image'

    - task: Docker@1
      displayName: certify container registry logout
      inputs:
        command: logout
        containerregistrytype: Container Registry
        dockerRegistryEndpoint: ${{ parameters.qaDockerRegistryServiceConnectionEndpoint }}

    - script: |
        docker rmi -f "${DOCKER_IMAGE_NAME_WITH_TAG}" "${CERTIFY_DOCKER_IMAGE}"
      env:
        CERTIFY_DOCKER_IMAGE: $(CERTIFY_DOCKER_IMAGE)
      displayName: 'remove certify docker image'
```
