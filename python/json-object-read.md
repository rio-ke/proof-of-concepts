## JSON DATA

`jobs.json`

```json
{
	"jobname": [{
		"job1": {
            "demo": "jino"
		},
		"job2": {
            "demo": "jino"
		}
	}]
}


```
```py
import json
import os

JOBNAME="job1"
data = json.load(open(os.path.join("jobs.json")))

print(data['jobname'][0][JOBNAME])
```

```py
# import urllib library
from urllib.request import urlopen
  
# import json
import json
# store the URL in url as 
# parameter for urlopen
url = "https://api.github.com"
  
response = urlopen(url)
data_json = json.loads(response.read())
print(data_json)
```

```py
import boto3
import json

s3 = boto3.resource('s3')

content_object = s3.Object('test', 'sample_json.txt')
file_content = content_object.get()['Body'].read().decode('utf-8')
json_content = json.loads(file_content)
print(json_content['Details'])
# >> Something

```
