**Creating nested-if-condition for bash shell**



```bash
#!/bin/bash

day=$(date +"%u")
time=$(date +"%p")

if [ $day -le 5 ]; then


echo "today is a weekday"
if [ $time == "AM" ]; then
echo "it is morning"
else
echo "it is night"
fi
else
    echo "today is the weekend!"
fi
```

**_bash Execute run command_**

```bash
bash nested-if-condition.sh
```

