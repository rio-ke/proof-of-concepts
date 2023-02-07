**_azure-datafactory-rest-api.md_**

_PreRequsties_

1. Generate the azure bearer token using the SPN (Service Pricipal)
2. Collect the subscription Id, Resource Group name and Azure Datafactory Name.
3. Agent servicer should be installed the Jq packages as a prerequesties.


_Create the bearer token_

```bash
curl -X POST -d 'grant_type=client_credentials&client_id=[APP_ID]&client_secret=[PASSWORD]&resource=https%3A%2F%2Fmanagement.azure.com%2F' https://login.microsoftonline.com/[TENANT_ID]/oauth2/token
```

_Create linked service_

```bash
curl -X PUT -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" --data "@azurestoragelinkedservice.json" "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.DataFactory/datafactories/$AZURE_DATA_FACOTRY_NAME/linkedservices/$NAME?api-version=2015-10-01"
```

_Create input dataset_


```bash
curl -X PUT -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" --data "@inputdataset.json" "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.DataFactory/datafactories/$AZURE_DATA_FACOTRY_NAME/datasets/$NAME?api-version=2015-10-01"

```


_Create the pipelines_

```bash
curl -X PUT -H "Authorization: Bearer $ACCESS_TOKEN" -H "Content-Type: application/json" --data "@pipeline.json" "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourcegroups/$RESOURCE_GROUP/providers/Microsoft.DataFactory/datafactories/$AZURE_DATA_FACOTRY_NAME/datapipelines/$NAME?api-version=2015-10-01"

```

```bash
for directory in $(ls -d */); do
    checkFileCountStatus=$(ls ${directory%%/} | wc -l)
    if [ "$checkFileCountStatus" != 0 ]; then
        for JsonFile in $(ls ${directory%%/} | grep .json); do
            removeExtensionFromFile=$(echo "${JsonFile}" | cut -f1 -d'.')
            if [ "${directory%%/}" == "dataflows" ]; then
                absolutePath="${directory%%/}/${JsonFile}"
                echo "${absolutePath}"
                echo "${removeExtensionFromFile}"
                # status=$(curl -X PUT -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" --data "@${absolutePath}" "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/resourcegroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/datafactories/${AZURE_DATA_FACOTRY_NAME}/dataflows/${removeExtensionFromFile}?api-version=2018-06-01")
            fi
            if [ "${directory%%/}" == "datasets" ]; then
                absolutePath="${directory%%/}/${JsonFile}"
                echo "${absolutePath}"
                echo "${removeExtensionFromFile}"
                # status=$(curl -X PUT -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" --data "@${absolutePath}" "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/resourcegroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/datafactories/${AZURE_DATA_FACOTRY_NAME}/datasets/${removeExtensionFromFile}?api-version=2018-06-01")
            fi
            if [ "${directory%%/}" == "triggers" ]; then
                absolutePath="${directory%%/}/${JsonFile}"
                echo "${absolutePath}"
                echo "${removeExtensionFromFile}"
                # status=$(curl -X PUT -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" --data "@${absolutePath}" "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/resourcegroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/datafactories/${AZURE_DATA_FACOTRY_NAME}/triggers/${removeExtensionFromFile}?api-version=2018-06-01")
            fi
            if [ "${directory%%/}" == "pipelines" ]; then
                absolutePath="${directory%%/}/${JsonFile}"
                echo "${absolutePath}"
                echo "${removeExtensionFromFile}"
                # status=$(curl -X PUT -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" --data "@${absolutePath}" "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/resourcegroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/datafactories/${AZURE_DATA_FACOTRY_NAME}/pipelines/${removeExtensionFromFile}?api-version=2018-06-01")
            fi
            if [ "${directory%%/}" == "linkedservices" ]; then
                absolutePath="${directory%%/}/${JsonFile}"
                echo "${absolutePath}"
                echo "${removeExtensionFromFile}"
                # status=$(curl -X PUT -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" --data "@${absolutePath}" "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/resourcegroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/datafactories/${AZURE_DATA_FACOTRY_NAME}/linkedservices/${NAME}?api-version=2018-06-01")
            fi
        done
    else
        echo "${directory%%/} <= files are does not exist"
    fi
done


```


[A Reference](https://learn.microsoft.com/en-us/azure/data-factory/v1/data-factory-build-your-first-pipeline-using-rest-api)

[B Reference](https://learn.microsoft.com/en-us/rest/api/datafactory/linked-services/create-or-update?tabs=HTTP)



_azure-pipelines.yaml_

```yml
steps:
  - script: |
      [[ ! -z "$(APP_ID)" ]]     && echo "$(APP_ID) variable is valid"     || exit 1
      [[ ! -z "$(APP_SECRET)" ]] && echo "$(APP_SECRET) variable is valid" || exit 1
      [[ ! -z "$(TENANT_ID)" ]]  && echo "$(TENANT_ID) variable is valid"  || exit 1
    displayName: variable validation
  - bash: |
      token=$(curl -X POST -d 'grant_type=client_credentials&client_id=${APP_ID}&client_secret=${APP_SECRET}&resource=https%3A%2F%2Fmanagement.azure.com%2F' https://login.microsoftonline.com/${TENANT_ID}/oauth2/token | jq '.access_token')
      echo "##vso[task.setvariable variable=ACCESS_TOKEN]$token"
    displayName: "create the bearer token"
  - bash: |
      for directory in $(ls -d */); do
          checkFileCountStatus=$(ls ${directory%%/} | wc -l)
          if [ "$checkFileCountStatus" != 0 ]; then
              for JsonFile in $(ls ${directory%%/} | grep .json); do
                  removeExtensionFromFile=$(echo "${JsonFile}" | cut -f1 -d'.')
                  if [ "${directory%%/}" == "dataflows" ]; then
                      absolutePath="${directory%%/}/${JsonFile}"
                      echo "##vso[task.setprogress value=$absolutePath;]Dataflows deployment going on!!!"
    # status=$(curl -X PUT -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" --data "@${absolutePath}" "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/resourcegroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/datafactories/${AZURE_DATA_FACOTRY_NAME}/dataflows/${removeExtensionFromFile}?api-version=2018-06-01")
                  fi
                  if [ "${directory%%/}" == "datasets" ]; then
                      echo "##[debug]Debug datasets enabled"
                      absolutePath="${directory%%/}/${JsonFile}"
                      echo "##vso[task.setprogress value=$absolutePath;]Datasets deployment going on!!!"
    # status=$(curl -X PUT -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" --data "@${absolutePath}" "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/resourcegroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/datafactories/${AZURE_DATA_FACOTRY_NAME}/datasets/${removeExtensionFromFile}?api-version=2018-06-01")
                  fi
                  if [ "${directory%%/}" == "triggers" ]; then
                      echo "##[debug]Debug triggers enabled"
                      absolutePath="${directory%%/}/${JsonFile}"
                      echo "##vso[task.setprogress value=$absolutePath;]Triggers deployment going on!!!"
    # status=$(curl -X PUT -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" --data "@${absolutePath}" "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/resourcegroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/datafactories/${AZURE_DATA_FACOTRY_NAME}/triggers/${removeExtensionFromFile}?api-version=2018-06-01")
                  fi
                  if [ "${directory%%/}" == "pipelines" ]; then
                      absolutePath="${directory%%/}/${JsonFile}"
                      echo "##vso[task.setprogress value=$absolutePath;]Pipelines deployment going on!!!"
    # status=$(curl -X PUT -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" --data "@${absolutePath}" "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/resourcegroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/datafactories/${AZURE_DATA_FACOTRY_NAME}/pipelines/${removeExtensionFromFile}?api-version=2018-06-01")
                  fi
                  if [ "${directory%%/}" == "linkedservices" ]; then
                      absolutePath="${directory%%/}/${JsonFile}"
                      echo "##vso[task.setprogress value=$absolutePath;]Linkedservices deployment going on!!!"
    # status=$(curl -X PUT -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Content-Type: application/json" --data "@${absolutePath}" "https://management.azure.com/subscriptions/${SUBSCRIPTION_ID}/resourcegroups/${RESOURCE_GROUP}/providers/Microsoft.DataFactory/datafactories/${AZURE_DATA_FACOTRY_NAME}/linkedservices/${removeExtensionFromFile}?api-version=2018-06-01")
                  fi
              done
          else
              echo "${directory%%/} <= files are does not exist"
          fi
      done
    displayName: "adf deployment configuration"
    env:
      SUBSCRIPTION_ID: $(SUBSCRIPTION_ID)
      RESOURCE_GROUP: $(RESOURCE_GROUP)
      AZURE_DATA_FACOTRY_NAME: $(AZURE_DATA_FACOTRY_NAME)

```
