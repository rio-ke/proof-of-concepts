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
