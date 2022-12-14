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
