
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


```py


import pathlib

data = "sftp/IN/001/111/AG1/demo.txt"

filename = pathlib.PurePath(data).parent
agentName = pathlib.PurePath(filename).name
print(agentName)

```


```py
key = '/one/two/three/four/jino.py'
import re
def filerTheAgentName(keyName):
    return re.split(r'/|:', keyName)

print(filerTheAgentName(key))
# ['one', 'two', 'three', 'four']
```
