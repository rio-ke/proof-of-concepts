

```yml
---
trigger:
  - common

pool: 
  vmImage: 'ubuntu-latest'

variables:
  - ${{ if eq(variables['Build.SourceBranchName'], 'common') }}:
      - group: dodo-dev
  - ${{ if eq(variables['Build.SourceBranchName'], 'master') }}:
      - group: dodo-prod
  - name: environment
    ${{ if eq(variables['Build.SourceBranchName'], 'release') }}:
      value: qa
    ${{ elseif eq(variables['Build.SourceBranchName'], 'master') }}:
      value: prod
    ${{ else }}:
      value: dev
  - template: variable-${{ variables.environment }}.yml@self

resources:
  repositories:
    - repository: common
      name:  devops-build-templates
      type: git
      ref: refs/heads/common

stages:
  - stage: buildDevelopment
    # variables:
    #   - ${{ if eq(variables['Build.SourceBranchName'], 'common') }}:
    #       - group: dodo-dev
    #   - ${{ if eq(variables['Build.SourceBranchName'], 'master') }}:
    #       - group: dodo-prod
    jobs:
      - job: buildApps
        # variables:
        #   - template: variable-${{ variables.environment }}.yml@self
      steps:
        - checkout: self
          displayName: $(Build.Repository.Name) => $(Build.SourceBranchName)
        - download: current
          artifact: drop

        - task: CopyFiles@2
          displayName: 'Copy Files docker file to: $(build.DefaultWorkingDirectory)'
          inputs:
            SourceFolder: '$(Agent.BuildDirectory)/drop/apps'
            Contents: |
              **
            TargetFolder: '$(System.DefaultWorkingDirectory)/apps/'
            
        - template: ui-build-deployment-templates/main.yml@common
          parameters:
            npmBuild: true
            sonarScan: false
            testCase: false
            dockerBuildAndPush: true
            aquaSec: false
            kubernetesValuesPreparation: true
            helmDeployment: true
```
