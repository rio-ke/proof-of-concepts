
[azure-databricks-repo-sync](https://docs.databricks.com/dev-tools/api/latest/repos.html#operation/create-repo)

```yml
steps:
  - bash: |
      statusCode=$(curl -s -o /dev/null -w "%{http_code}" -XGET ${AZURE_DATA_BRICKS_URL}/api/2.0/repos -H "Authorization: Bearer ${AZURE_DATA_BRICKS_BEARER_TOKEN}")
      if [ $statusCode == 200 ]; then
          echo "SuccessCode: ${statusCode}"
      else
          echo "ErrorCode - ${statusCode} - Bearer token or URL Mismatch"
          exit 1
      fi
    displayName: "AuthenticateDatabricksValidation"
    env:
      AZURE_DATA_BRICKS_URL: "https://adb-xxxxx.x.azuredatabricks.net"
      AZURE_DATA_BRICKS_BEARER_TOKEN: "xxxxxxx-2"
  - bash: |
      getUpdatedSyncStatus=$(curl -s -XGET ${AZURE_DATA_BRICKS_URL}/api/2.0/repos -H "Authorization: Bearer ${AZURE_DATA_BRICKS_BEARER_TOKEN}" | jq '.repos[]' | grep ${AZURE_DATA_BRICKS_SYNC_PATH} | wc -l)
      if [ $getUpdatedSyncStatus == 1 ]; then
          echo "SuccessCode: The repository has already been synced."
          getUpdatedSyncRepoId=$(curl -s -XGET ${AZURE_DATA_BRICKS_URL}/api/2.0/repos?path_prefix=${AZURE_DATA_BRICKS_SYNC_PATH} -H "Authorization: Bearer ${AZURE_DATA_BRICKS_BEARER_TOKEN}" | jq '.repos[].id')
          curl -s -XDELETE ${AZURE_DATA_BRICKS_URL}/api/2.0/repos/${getUpdatedSyncRepoId} -H "Authorization: Bearer ${AZURE_DATA_BRICKS_BEARER_TOKEN}" -H "Content-Type: application/json"
      else
          echo "MessageCode:  The repository has not yet been synced."
      fi
    displayName: "deleteSyncedRepo"
    env:
      AZURE_DATA_BRICKS_URL: "https://adb-xxxxx.x.azuredatabricks.net"
      AZURE_DATA_BRICKS_BEARER_TOKEN: "xxxxxxx-2"
      AZURE_DATA_BRICKS_SYNC_PATH: "/Repos/cicd/${BUILD_REPOSITORY_NAME}"
  - bash: |
      AZURE_ADO_REPO_SOURCE_URL="https://dev.azure.com/xxxx/xxxxxxxxx/_git/${BUILD_REPOSITORY_NAME}"
      cat > data.json <<EOF
      { 
        "url": "${AZURE_ADO_REPO_SOURCE_URL}", 
        "provider": "azureDevOpsServices", 
        "path": "${AZURE_DATA_BRICKS_SYNC_PATH}"
      }
      EOF
      repoInfo=$(curl -X POST ${AZURE_DATA_BRICKS_URL}/api/2.0/repos -d @data.json  -H "Content-Type: application/json" -H "Authorization: Bearer ${AZURE_DATA_BRICKS_BEARER_TOKEN}")
      echo $repoInfo
    displayName: "syncRepo"
    env:
      AZURE_DATA_BRICKS_URL: "https://adb-xxxxx.x.azuredatabricks.net"
      AZURE_DATA_BRICKS_BEARER_TOKEN: "xxxxxxx-2"
      AZURE_DATA_BRICKS_SYNC_PATH: "/Repos/cicd/${BUILD_REPOSITORY_NAME}"
      AZURE_ADO_REPO_SOURCE_URL: "https://dev.azure.com/xxxx/xxxxxxxxx/_git/${BUILD_REPOSITORY_NAME}"
```
