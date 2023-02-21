
_databricks-raw-notebook-deployment_

```bash
#!/usr/bin/env bash
DATA_BRICKS_URL="adb-xxxxxxxx.12.azuredatabricks.net"
BEARER_TOKEN="<databricks token>"
for pythonFile in $(ls); do
    echo "${pythonFile}"
    fileExtension=$(ls ${pythonFile} | awk -F . '{print $2}')
    if [ "${fileExtension}" == "py" ]; then
        # databricks workspace import --language=PYTHON --format=SOURCE --overwrite $(System.ArtifactsDirectory)/${pythonFile} /Shared/${pythonFile}
    curl -n -X POST "https://${DATA_BRICKS_URL}/api/2.0/workspace/import"  -F path="/Shared/${pythonFile}" -F format=SOURCE -F language=PYTHON -F overwrite=true -F content=@"${pythonFile}"  --header "Content-Type: multipart/form-data" --header "Authorization: Bearer ${BEARER_TOKEN}"
    fi
done
```
