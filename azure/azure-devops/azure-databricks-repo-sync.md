
```yml
steps:
  - bash: |
      databricksUrl="https://adb-xxxxx.x.azuredatabricks.net"
      databricksToken="xxxxxe7bbadf2-2"
      databricks configure --token <<EOF
      $databricksUrl
      $databricksToken
      EOF
    displayName: "AuthenticateDatabricksUseDataBricksCli"
  - bash: |
      set -xe
      dataBricksURL=$(databricks-url-xxx)
      bearerToken=$(databricks-token-xxx)
      echo "${dataBricksURL}"
      echo "${bearerToken}"
    displayName: "AuthenticateDatabricks"
  - bash: |
      dataBricksURL="https://adb-xxxxx.x.azuredatabricks.net"
      bearerToken="xxxxxxx-2"
      echo "${dataBricksURL}"
      echo "${bearerToken}"
      statusCode=$(curl -s -o /dev/null -w "%{http_code}" -XGET ${dataBricksURL}/api/2.0/repos -H "Authorization: Bearer ${bearerToken}")

      if [ $statusCode == 200 ]; then
          echo "SuccessCode: ${statusCode}"
      else
          echo "ErrorCode - ${statusCode} - Bearer token or URL Mismatch"
          exit 1
      fi
    displayName: "AuthenticateDatabricksValidation"
  - bash: |
      updatedPath="/Repos/cicd/${BUILD_REPOSITORY_NAME}"
      dataBricksURL=$(databricks-url-xxx)
      bearerToken=$(databricks-token-xxx)
      getUpdatedSyncStatus=$(curl -s -XGET ${dataBricksURL}/api/2.0/repos -H "Authorization: Bearer ${bearerToken}" | jq '.repos[]' | grep ${updatedPath} | wc -l)

      if [ $getUpdatedSyncStatus == 1 ]; then
          echo "SuccessCode: The repository has already been synced."
          getUpdatedSyncRepoId=$(curl -s -XGET ${dataBricksURL}/api/2.0/repos?path_prefix=${updatedPath} -H "Authorization: Bearer ${bearerToken}" | jq '.repos[].id')
          curl -s -XDELETE ${dataBricksURL}/api/2.0/repos/${getUpdatedSyncRepoId} -H "Authorization: Bearer ${bearerToken}" -H "Content-Type: application/json"
      else
          echo "MessageCode:  The repository has not yet been synced."
      fi
    displayName: "deleteSyncedRepo"
  - bash: |
      syncUrl="https://dev.azure.com/xxxx/xxxxxxxxx/_git/${BUILD_REPOSITORY_NAME}"
      dataBricksURL=$(databricks-url-xxx)
      bearerToken=$(databricks-token-xxx)
      updatedPath="/Repos/cicd/${BUILD_REPOSITORY_NAME}"
      cat > data.json <<EOF
      { 
        "url": "${syncUrl}", 
        "provider": "azureDevOpsServices", 
        "path": "${updatedPath}"
      }
      EOF
      repoInfo=$(curl -X POST https://${databricksUrl}/api/2.0/repos -d @data.json  -H "Content-Type: application/json" -H "Authorization: Bearer ${bearerToken}")
      echo $repoInfo
    displayName: "syncRepo"

```
