

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

curl -X POST https://reqbin.com/echo/post/json \ 
  -d @data.json \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${BearerToken}" 
rm -rf data.json
```
