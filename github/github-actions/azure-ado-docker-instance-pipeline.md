```yml
---
trigger: none
resources:
  - repo: self

pool:
  name: devops
  demands:
    - Agent.ComputerName -equals test-devops

variables:
  tag: $(Build.BuildNumber)
  repositoryName: kartidemoacr.azurecr.io
  imageName: node-api

stages:
  - stage: "buildDeployment"
    displayName: "buildDeployment"
    jobs:
      - job: "buildDeployment"
        displayName: BUILD
        steps:
          - task: Docker@2
            displayName: Build Docker Image
            inputs:
              command: build
              containerRegistry: docker-service # service connetion
              repository: $(imageName)
              Dockerfile: apps/Dockerfile
              tags: $(tag)
          # docker arc admin login credentials
          - task: Docker@0
            displayName: "Push an image"
            inputs:
              containerregistrytype: "Container Registry"
              dockerRegistryConnection: "docker-service"  # service connetion
              action: "Push an image"
              imageName: node-api:$(Build.BuildNumber)

          - bash: |
              cat > command.sh <<EOF
              #!/usr/bin/env bash
              docker rm -f node-api
              docker run -d -p 8080:9000 --name node-api kartidemoacr.azurecr.io/node-api:$(Build.BuildNumber)
              EOF

          - task: PublishPipelineArtifact@1
            inputs:
              targetPath: command.sh
              artifact: drop
            displayName: Publish Pipeline Artifact

          - task: SSH@0
            displayName: 'Run shell script on remote machine'
            inputs:
              sshEndpoint: 'ssh-connection'  # service connection
              runOptions: script
              scriptPath: 'command.sh'
```