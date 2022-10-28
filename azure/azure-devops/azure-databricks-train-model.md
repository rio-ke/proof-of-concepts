

```yml
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
      runIdName=$(projectName)-$(Build.BuildNumber)
      nodeBookPath=$(nodeBookPath)
      clusterId="$(clusterId)"
      cat > run.json <<EOF
      {
        "run_name": "${runIdName}",
        "existing_cluster_id": "${clusterId}",
        "libraries": [],
        "notebook_task": {
          "notebook_path": "${nodeBookPath}"
        },
        "timeout_seconds": 1800
      }
      EOF
    displayName: "create run.json file"
  - bash: |
      cat run.json 
      dataBricksURL=$(databricks-url)
      bearerToken=$(databricks-token)
      runID=$(curl -s -XPOST ${dataBricksURL}/api/2.0/jobs/runs/submit -d @run.json  -H "Content-Type: application/json" -H "Authorization: Bearer ${bearerToken}" | jq .run_id )
      echo "##vso[task.setvariable variable=RunId; isOutput=true;]$runID"
      echo $runID
    displayName: "submit job"
  - bash: |
      runId=$(RunId) 
      dataBricksURL=$(databricks-url)
      bearerToken=$(databricks-token)
      while true
      do
        runIdStatus=$(curl -s -XGET ${dataBricksURL}/api/2.0/jobs/runs/get?run_id=${runId}  -H "Content-Type: application/json" -H "Authorization: Bearer ${bearerToken}" | jq -r '.state.life_cycle_state')
        echo "Run id status is: ${runIdStatus}"
        if [ $runIdStatus == "TERMINATED" ] || [ $runIdStatus == "INTERNAL_ERROR" ]; then
          getJobResult=$(curl -s -XGET ${dataBricksURL}/api/2.0/jobs/runs/get?run_id=${runId}  -H "Content-Type: application/json" -H "Authorization: Bearer ${bearerToken}" | jq -r '.state.result_state')
          echo "job status is: ${getJobResult}"
          if [ $getJobResult == "FAILED" ]; then
            echo "SuccessCode: model registration failed"
            exit 1
          else
            echo "SuccessCode: model registration success"
            break
          fi
        fi
      sleep 10
      done
    displayName: "to get model registration status"
```
