```bash
#!/usr/bin/env bash

# DataBricks validation
dataBricksURL="https://adb-xxx.3.azuredatabricks.net"
bearerToken="xxxx-2"

statusCode=$(curl -s -o /dev/null -w "%{http_code}" -XGET ${dataBricksURL}/api/2.0/repos -H "Authorization: Bearer ${bearerToken}")

if [ $statusCode == 200 ]; then
    echo "SuccessCode: ${statusCode}"
else
    echo "ErrorCode - ${statusCode} - Bearer token or URL Mismatch"
    exit 1
fi

# to get synced repo detail information
updatedPath="/Repos/cicd/${BUILD_REPOSITORY_NAME}"
getUpdatedSyncStatus=$(curl -s -XGET ${dataBricksURL}/api/2.0/repos -H "Authorization: Bearer ${bearerToken}" | jq '.repos[]' | grep ${updatedPath} | wc -l)

if [ $getUpdatedSyncStatus == 1 ]; then
    echo "SuccessCode: The repository has already been synced."
    getUpdatedSyncRepoId=$(curl -s -XGET ${dataBricksURL}/api/2.0/repos?path_prefix=${updatedPath} -H "Authorization: Bearer ${bearerToken}" | jq '.repos[].id')
    curl -s -XDELETE ${dataBricksURL}/api/2.0/repos/${getUpdatedSyncRepoId} -H "Authorization: Bearer ${bearerToken}" -H "Content-Type: application/json"
else
    echo "MessageCode:  The repository has not yet been synced."
fi

# to create the sync repo
updatedPath="/Repos/cicd/${BUILD_REPOSITORY_NAME}"
syncUrl="https://dev.azure.com/fso-to/xx%xxx%xxx/_git/${BUILD_REPOSITORY_NAME}"

cat >data.json <<EOF
{ 
  "url": "${syncUrl}", 
  "provider": "azureDevOpsServices", 
  "path": "${updatedPath}"
}
EOF

curl -s -XGET ${dataBricksURL}/api/2.0/repos -H "Authorization: Bearer ${bearerToken}" -H "Content-Type: application/json" -d @data.json | jq
