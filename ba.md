
```bash

VERSION=$(awk -F '<[^>]*>' '/<dependencies>/,/<\/dependencies>/{next} /version/{$1=$1;print$0}' pom.xml | xargs | awk -F - '{print $1}')
cat >data.json <<EOF
{
  "ref": "refs/heads/Release/${VERSION}",
  "sha": ${SHA}
}
EOF
cat data.json 

```
