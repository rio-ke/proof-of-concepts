```yml
parameters:
  azureSubscription: "Non-Prod Subscription"
  keyvaultName: ""
  keyvaultRestApiVersion: 7.3
  showTheSecretsFromAzureCliServiceConnection: false
  secretName: ""
  secretValue: ""

jobs:
  - job: ${{ parameters.name }}
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
      - script: |
          # token=$(curl -s -XGET -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=client_credentials&client_id=${azureClientId}&resource=https://vault.azure.net&client_secret=${azureSecretId}" "https://login.microsoftonline.com/${azureTenantId}/oauth2/token"  | jq .access_token)
          token=$(curl -s -XGET -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=client_credentials&client_id=${azureClientId}&resource=${azureBeareTokenscope}&client_secret=${azureSecretId}" "https://login.microsoftonline.com/${azureTenantId}/oauth2/token"  | jq .access_token)
          echo "##vso[task.setvariable variable=azureBearerToken]${token}"
        displayName: "Generate bearer token"
        env:
          azureBeareTokenscope: "https://vault.azure.net"
          azureTenantId: $(TENANT_ID)
          azureClientId: $(CLIENT_ID)
          azureSecretId: $(SECRET_ID)
      - script: |
          token=$(azureBearerToken)
          cat > data.json <<EOF
          { 
            "value": "${azureSecretValue}"
          }
          EOF
          data=$(curl -s -XPUT https://${azureKeyvaultName}.vault.azure.net/secrets/${azureSecretName}?api-version=${azureKeyvaultRestApiVersion} -d @data.json -H "Content-Type: application/json" -H "Authorization: Bearer ${token}")
          echo ${data} | jq .
          rm -rf data.json
        displayName: "create keyvault secret"
        env:
          azureKeyvaultBearerToken: $(azureBearerToken)
          azureKeyvaultName: ${{ parameters.keyvaultName }}
          azureKeyvaultRestApiVersion: ${{ parameters.keyvaultRestApiVersion }}
          azureSecretName: ${{ parameters.secretName }}
          azureSecretValue: ${{ parameters.secretValue }}

      # # Bulk secret creation
      # - script: |
      #     token=$(azureBearerToken)
      #     jq -c '.[]' ${fileFullPath} | while read secret; do
      #       name=$(echo ${secret} | jq '.secretName')
      #       value=$(echo ${secret} | jq '.secretValue')
      #       cat > data.json <<EOF
      #       { 
      #         "value": "${value}"
      #       }
      #       EOF
      #       curl -s -XPUT https://${azureKeyvaultName}.vault.azure.net/secrets/${name}?api-version=${azureKeyvaultRestApiVersion} -d @data.json -H "Content-Type: application/json" -H "Authorization: Bearer ${token}"
      #     done
      #   displayName: "create keyvault secret"
      #   env: # secrets.json file content should be look like this => [{ "secretName": "jino", "secretValue": "gino" }]
      #     azureKeyvaultBearerToken: $(azureBearerToken)
      #     azureKeyvaultName: ${{ parameters.keyvaultName }}
      #     azureKeyvaultRestApiVersion: ${{ parameters.keyvaultRestApiVersion }}
      #     fileFullPath: secrets.json

```
