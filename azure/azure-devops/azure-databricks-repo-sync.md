steps:
  - bash: |
      dataBricksURL=$(databricks-url)
      bearerToken=$(databricks-token)
      statusCode=$(curl -s -o /dev/null -w "%{http_code}" -XGET ${dataBricksURL}/api/2.0/repos -H "Authorization: Bearer ${bearerToken}")
      if [ $statusCode == 200 ]; then
          echo "SuccessCode: ${statusCode}"
      else
          echo "ErrorCode - ${statusCode} - Bearer token or URL Mismatch"
          exit 1
      fi
    displayName: "databricksAuthenticateValidation"
  - bash: |
      repoName=$(Build.Repository.Name)
      updatedPath="/Repos/cicd/${repoName}"
      dataBricksURL=$(databricks-url)
      bearerToken=$(databricks-token)
      getUpdatedSyncStatus=$(curl -s -XGET ${dataBricksURL}/api/2.0/repos?path_prefix=${updatedPath} -H "Authorization: Bearer ${bearerToken}" | jq -r '. | length')
      echo "Get updated synced repo count is: ${getUpdatedSyncStatus}"
      if [ $getUpdatedSyncStatus == 1 ]; then
          echo "SuccessCode: The repository has already been synced."
          getUpdatedSyncRepoId=$(curl -s -XGET ${dataBricksURL}/api/2.0/repos?path_prefix=${updatedPath} -H "Authorization: Bearer ${bearerToken}" | jq '.repos[].id')
          echo "Synced repo id is: ${getUpdatedSyncRepoId}"
          curl -s -XDELETE ${dataBricksURL}/api/2.0/repos/${getUpdatedSyncRepoId} -H "Authorization: Bearer ${bearerToken}" -H "Content-Type: application/json" | jq .
      else
          echo "MessageCode:  The repository has not yet been synced."
      fi
    displayName: "databricksDeleteSyncedRepo"
  - bash: |
      dataBricksURL=$(databricks-url)
      bearerToken=$(databricks-token)
      repoName=$(Build.Repository.Name)
      updatedPath="/Repos/cicd/${repoName}"
      syncUrl="https://dev.azure.com/xxxx/ModOps/_git/${repoName}"
      gitBranchName=$(Build.SourceBranchName)
      cat > data.json <<EOF
      { 
        "url": "${syncUrl}", 
        "provider": "azureDevOpsServices", 
        "path": "${updatedPath}",
        "branch": "${gitBranchName}"
      }
      EOF
      cat data.json
      repoInfo=$(curl -s -XPOST ${dataBricksURL}/api/2.0/repos -d @data.json  -H "Content-Type: application/json" -H "Authorization: Bearer ${bearerToken}" | jq .)
      echo "Synced repo update is: ${repoInfo}"
    displayName: "databricksSyncRepo"
