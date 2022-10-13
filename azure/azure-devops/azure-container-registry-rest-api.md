
azure aad access token authentication

```bash

registry="contosoregistry.azurecr.io"
tenant="409520d4-8100-4d1d-ad47-72432ddcc120"
aad_access_token="eyJ...H-g"
curl -v -X POST -H "Content-Type: application/x-www-form-urlencoded" -d \
    "grant_type=access_token&service=$registry&tenant=$tenant&access_token=$aad_access_token" \
    https://$registry/oauth2/exchange
    
```

container acr rest api use username and password

```bash
export registry="use.azurecr.io"
export user="USE"
export password="k/vmxw2jmKmSQZKQZo"

export operation="/v2/_catalog"

export credentials=$(echo -n "$user:$password" | base64 -w 0)

export catalog=$(curl -s -H "Authorization: Basic $credentials" https://$registry$operation)
echo "Catalog"
echo $catalog | jq .
```


https://github.com/Azure/acr/blob/main/docs/AAD-OAuth.md
