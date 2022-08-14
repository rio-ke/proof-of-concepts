```yml
---
trigger: none
resources:
  - repo: self

pool: 
  name: miga
  demands:  
  - Agent.ComputerName -equals access-server

variables:
  tag: $(Build.BuildNumber)
  repositoryName: acriodemoslockdev.azurecr.io
  imageName: api-one

stages:
  - stage: "build and deployment"
    displayName: "build and deployment"
    jobs:
      - job: "buildDeployment"
        displayName: BUILD
        steps:
          - task: Docker@2
            displayName: Build Docker Image
            inputs:
              command: build
              containerRegistry: docker-service
              repository: $(imageName)
              Dockerfile: Dockerfile
              tags: $(tag)

          - script: |
              docker run -d --name $(imageName)  $(repositoryName)/$(imageName):$(Build.BuildNumber)
              CID=$(docker ps -q -f status=running -f name=$(imageName))
              if [ ! "${CID}" ]; then
                echo "Container doesn't exist"
                exit 1
              else
                echo "Container Running"
              fi
              unset CID
            displayName: Verify Docker Image Running State

          - script: |
              docker rm $(docker ps -aq --filter name=$(imageName))  -f
            displayName: Delete Running State Container

          - task: Docker@2
            displayName: Push Docker Image to ACR
            inputs:
              command: push
              containerRegistry: $(containerRegistry)
              repository: $(repositoryName)
              tags: $(Build.BuildNumber)

          - script: |
              Size=$(docker image inspect $(repositoryName)/$(imageName):$(Build.BuildNumber) --format='{{.Size}}')
              DockerSize=$((($Size/1024)/1024))
              echo "$(repositoryName)/$(imageName):$(Build.BuildNumber) image size: $DockerSize Mb"
              unset Size
              docker rmi $(repositoryName)/$(imageName):$(Build.BuildNumber)
            displayName: Remove Last Build Image

          - script: |
              tag=$(Build.BuildNumber)
              imageNameandversion=$(imageName):$tag
              repositoryName=$(repositoryName)
              sed -i 's/containerImageName/'"$repositoryName\/$imageNameandversion"'/g' main.yml
            displayName: Preparing the k8s deployment file

          - task: PublishPipelineArtifact@1
            inputs:
              targetPath: main.yml
              artifact: drop
            displayName: Publish Pipeline Artifact

          - task: KubernetesManifest@0
            displayName: kubernetes-deploy
            inputs:
              kubernetesServiceConnection: kubernetesServiceConnection
              namespace: default
              manifests: main.yml
```
