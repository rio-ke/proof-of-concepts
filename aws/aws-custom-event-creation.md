

```py
import boto3
import datetime
import json


class eventsCreation():
    def __init__(self, Source, EventBusName,  verbose=False):
        self.events = boto3.client('events')
        self.Source = Source
        self.EventBusName = EventBusName
        self.verbose = verbose
        if self.verbose:
            boto3.set_stream_logger(name="botocore")

    def postEvent(self, bucket, key, action, status):
        return self.events.put_events(
            Entries=[
                {
                    "Source": self.Source,
                    "EventBusName": self.EventBusName,
                    "DetailType": "transaction",
                    "Time": datetime.datetime.now(),
                    "Detail": json.dumps({
                        "bucket": bucket,
                        "key": key,
                        "action": action,
                        "status": status
                    })
                }
            ]
        )

```

_execution_

```py
print(eventsCreation("custom.myATMapp", "my-events").postEvent("secret", "demo.txt", "created", "success"))
```

_event rule_

```js
{
    "source": ["custom.myATMapp"],
    "detail-type": ["transaction"]
}
```
