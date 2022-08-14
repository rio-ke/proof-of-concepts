

```yml

- task: AzureCLI@2
  displayName: "Azure CLI login cred get from ado service connection"
  inputs:
    azureSubscription: "Development" # Azure Service Connection name based on project configuration
    scriptType: bash
    scriptLocation: inlineScript
    inlineScript: |
      servicePrincipalId=$(xxd -p -c 256 <<<$servicePrincipalId)
      servicePrincipalKey=$(xxd -p -c 256 <<<$servicePrincipalKey)
      tenantId=$(xxd -p -c 256 <<<$tenantId)
      appId=$(echo "${servicePrincipalId}" | xxd -r -p)
      appSecret=$(echo "${servicePrincipalKey}" | xxd -r -p)
      tId=$(echo "${tenantId}" | xxd -r -p)
      echo "##vso[task.setvariable variable=TENANT_ID]${tId}"
      echo "##vso[task.setvariable variable=SECRET_ID]${appSecret}"
      echo "##vso[task.setvariable variable=CLIENT_ID]${appId}"
      # az login --service-principal --username "${appId}" --password "${appSecret}" --tenant "${tId}"
      # If we want to pass the appSecret and appId as global env value for ansible.
      # we can pass those value from here to ansible.
    addSpnToEnvironment: true
- bash: |
    ansible-playbook ${{ parameters.action }}.yml --extra-vars "fileName=${{ parameters.fileName }} TENANT_ID=$(TENANT_ID) CLIENT_ID=$(CLIENT_ID)  SECRET_ID=$(SECRET_ID)"
```
