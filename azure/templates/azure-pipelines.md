
```yml
---
name: $(Build.SourceBranchName) # Release Identifier
resources:
  repositories:
    - repository: templates
      name: ey-org/devops-build-templates
      endpoint: apps for Insurance (1)
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
  - group: azure-feed-artifacts-service-connections
  - group: apps-repository
  - group: release-params-actuaite
  - name: module
    value: nexusforinsurance
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
