_POST Methods_

```bash
URL="https://github.com/jsmith/test"
updatedPath="/Repos/Production/testrepo"
BearerToken="${varibleGroup}"
cat > data.json <<EOF
{
  "url": "${URL}",
  "provider": "azureDevOpsServices",
  "path": "${updatedPath}"
}
EOF

curl -XPOST https://reqbin.com/echo/post/json \
  -d @data.json \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${BearerToken}"
```

```bash
BearerToken="${varibleGroup}"
curl -XPOST https://reqbin.com/echo/post/json \
  -d '{ "url": "https://github.com/jsmith/test", "provider": "azureDevOpsServices",  "path": "/Repos/Production/testrepo" }' \
  -H "Content-Type: application/json"  -H "Authorization: Bearer ${BearerToken}"
```

_GET Methods_

```bash
curl -XGET https://reqbin.com/echo/post/json \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${BearerToken}"
```


```bash
#!/usr/bin/env bash

# DataBricks validation
dataBricksURL="https://adb-xxxx.3.azuredatabricks.net"
bearerToken="xxxx-2"
statusCode=$(curl -s -o /dev/null -w "%{http_code}" -XGET ${dataBricksURL}/api/2.0/repos -H "Authorization: Bearer ${bearerToken}")

if [ $statusCode == 200 ]; then
    echo "SuccessCode: ${statusCode}"
else
    echo "ErrorCode - ${statusCode} - Bearer token or URL Mismatch"
    exit 1
fi

# to get synced repo detail information
updatedPath="/Repos/xxxx.xxx.xxx@xxx.xx.com/dg-ds-di-data-generation"
getUpdatedSyncStatus=$(curl -s -XGET ${dataBricksURL}/api/2.0/repos -H "Authorization: Bearer ${bearerToken}" | jq '.repos[]' | grep ${updatedPath} | wc -l)

if [ $getUpdatedSyncStatus == 1 ]; then
    echo "SuccessCode: The repository has already been synced."
    getUpdatedSyncRepoId=$(curl -s -XGET ${dataBricksURL}/api/2.0/repos -H "Authorization: Bearer ${bearerToken}" | jq '.repos[]' | grep ${updatedPath})
    echo ${getUpdatedSyncRepoId}
else
    echo "ErrorCode:  The repository has not yet been synced."
fi

# to create the sync repo
syncUrl="https://github.com/jsmith/test"
updatedPath="/Repos/Production/testrepo"
cat >data.json <<EOF
{ 
  "url": "${syncUrl}", 
  "provider": "azureDevOpsServices", 
  "path": "${updatedPath}"
}
EOF

curl -s -XGET ${dataBricksURL}/api/2.0/repos -H "Authorization: Bearer ${bearerToken}" -H "Content-Type: application/json" -d @data.json | jq
```
