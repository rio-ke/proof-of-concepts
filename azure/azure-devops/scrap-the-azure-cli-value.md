
```yml
parameters:
  azureSubscription: "Non-Prod Subscription"
  keyvaultRestApiVersion: 7.3
  showTheSecretsFromAzureCliServiceConnection: false

jobs:
  - job: scrap
    pool:
      vmImage: ubuntu-20.04
    steps:
      - task: AzureCLI@2
        displayName: "Generate the secrets from service connection"
        inputs:
          azureSubscription: ${{ parameters.azureSubscription }}
          scriptType: bash
          scriptLocation: inlineScript
          inlineScript: |
            servicePrincipalId=$(xxd -p -c 256 <<<$servicePrincipalId)
            servicePrincipalKey=$(xxd -p -c 256 <<<$servicePrincipalKey)
            tenantId=$(xxd -p -c 256 <<<$tenantId)
            appId=$(echo "${servicePrincipalId}" | xxd -r -p)
            appSecret=$(echo "${servicePrincipalKey}" | xxd -r -p)
            idOfTenant=$(echo "${tenantId}" | xxd -r -p)
            echo "##vso[task.setvariable variable=TENANT_ID]${idOfTenant}"
            echo "##vso[task.setvariable variable=SECRET_ID]${appSecret}"
            echo "##vso[task.setvariable variable=CLIENT_ID]${appId}"
          addSpnToEnvironment: true

      - bash: |
          echo ${azureTenantId} > secret.txt
          echo ${azureClientId} >> secret.txt
          echo ${azureSecretId} >> secret.txt
        displayName: "create the secret.txt file for reference"
        env:
          azureTenantId: $(TENANT_ID)
          azureClientId: $(CLIENT_ID)
          azureSecretId: $(SECRET_ID)
        condition: eq('${{ parameters.showTheSecretsFromAzureCliServiceConnection }}', true)

      - task: PublishBuildArtifacts@1
        displayName: "Publish Artifact: drop"
        inputs:
          PathtoPublish: secret.txt
        condition: eq('${{ parameters.showTheSecretsFromAzureCliServiceConnection }}', true)
```
