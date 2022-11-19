
```yml
---
name: $(Build.SourceBranchName) # Release Identifier
resources:
  repositories:
    - repository: templates
      name: operation-unknown/proof-of-concepts
      endpoint: apps for dataset
      type: github
      ref: refs/heads/end-to-end-automation

trigger:
  batch: true
  branches:
    include:
      - end-to-end-automation

parameters:
  - name: build
    default: true
    type: boolean
    displayName: build
  - name: devDeploy
    default: true
    type: boolean
    displayName: devDeploy
  - name: qaDeploy
    default: true
    type: boolean
    displayName: qaDeploy
  - name: uatDeploy
    default: true
    type: boolean
    displayName: uatDeploy
  - name: demoDeploy
    default: true
    type: boolean
    displayName: demoDeploy

variables:
  - template: variables.yaml
  - ${{ if eq(parameters['devDeploy'], 'true' ) }}:
      - template: dev-variables.yaml
  - ${{ if eq(parameters['demoDeploy'], 'true' ) }}:
      - template: demo-variables.yaml
  - ${{ if eq(parameters['qaDeploy'], 'true' ) }}:
      - template: qa-variables.yaml
  - ${{ if eq(parameters['uatDeploy'], 'true' ) }}:
      - template: ua-variables.yaml
  - name: imageTagName
    ${{ if eq(variables['Build.SourceBranchName'], 'development') }}:
      value: $(Build.BuildNumber)
    ${{ else }}:
      value: $(Build.SourceBranchName)-$(Build.BuildNumber)
      #value: $(Build.SourceBranchName)
  - group: service-connections-actuaite
  - group: azure-feed-artifacts
  - group: apps-repository
  - group: release-params-actuaite
  - name: module
    value: apps-dataset
  - name: component
    value: dataset-app
  - name: projectName
    value: "$(module)-$(component)"
  - name: buildEnvironment
    value: dev
  - name: imageName
    value: "$(projectName)/$(buildEnvironment)"
  - name: versionNumber
    value: $(Rev:r)
  - name: registryServerName
    value: "$(registryName).azurecr.io"

extends:
  template: main.yml@templates
  parameters:
    build: ${{ parameters.build }}
    devDeploy: ${{ parameters.devDeploy }}
    qaDeploy: ${{ parameters.qaDeploy }}
    uatDeploy: ${{ parameters.uatDeploy }}
    demoDeploy: ${{ parameters.demoDeploy }}
```
_main template_

It comes from another repository in the name of 
```yml
---
parameters:
  - name: build
    type: boolean
    default: false
  - name: devDeploy
    type: boolean
    default: false
  - name: qaDeploy
    type: boolean
    default: false
  - name: uatDeploy
    type: boolean
    default: false
  - name: demoDeploy
    type: boolean
    default: false

stages:
  - ${{ if eq(parameters['build'], 'true' ) }}:
      - stage: build
        pool:
          vmImage: ubuntu-latest
        variables:
          environmet: build
        jobs:
          - job: build
            steps:
              - bash: |
                  echo "demo deployment process" 
                  echo $(environmet)
                  echo $(imageName)
                  echo $(DEMO_DATA)

  - ${{ if eq(parameters['devDeploy'], 'true' ) }}:
      - stage: development
        pool:
          vmImage: ubuntu-latest
        variables:
          environmet: dev
        jobs:
          - job: development
            steps:
              - bash: |
                  echo "development deployment process" 
                  echo $(imageName)
                  echo $(DEV_DATA) 
                  echo $(environmet)

  - ${{ if eq(parameters['qaDeploy'], 'true' ) }}:
      - stage: qa
        pool:
          vmImage: ubuntu-latest
        variables:
          environmet: qa
        jobs:
          - deployment: qa
            displayName: qa
            environment: "demo"
            strategy:
              runOnce:
                deploy:
                  steps:
                    - bash: |
                        echo "qa deployment process" 
                        echo $(imageName)
                        echo $(QA_DATA) 
                        echo $(environmet)

  - ${{ if eq(parameters['uatDeploy'], 'true' ) }}:
      - stage: uat
        pool:
          vmImage: ubuntu-latest
        variables:
          environmet: uat
        jobs:
          - deployment: uat
            displayName: uat
            environment: "demo"
            strategy:
              runOnce:
                deploy:
                  steps:
                    - bash: |
                        echo "uat deployment process" 
                        echo $(imageName)
                        echo $(UAT_DATA) 
                        echo $(environmet)

  - ${{ if eq(parameters['demoDeploy'], 'true' ) }}:
      - stage: demo
        pool:
          vmImage: ubuntu-latest
        variables:
          environmet: uat
        jobs:
          - deployment: demo
            displayName: demo
            environment: "demo"
            strategy:
              runOnce:
                deploy:
                  steps:
                    - bash: |
                        echo $(imageName)
                        echo $(DEMO_DATA)
```
