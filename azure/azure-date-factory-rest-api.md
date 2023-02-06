**_azure-date-factory-rest-api.md_**

_PreRequsties_

1. Generate the azure bearer token using the SPN (Service Pricipal)
2. Collect the subscription Id, Resource Group name and Azure Datafactory Name.
3. Agent servicer should be installed the Jq packages as a prerequesties.

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


[A Reference](https://learn.microsoft.com/en-us/azure/data-factory/v1/data-factory-build-your-first-pipeline-using-rest-api)

[B Reference](https://learn.microsoft.com/en-us/rest/api/datafactory/linked-services/create-or-update?tabs=HTTP)
