## redis server installtion


```
#!/usr/bin/env bash

# redis-installtion-script.sh
sudo apt update
sudo apt install redis-server -y
sudo systemctl start redis
sudo systemctl status redis
```


execute

```bash
bash redis-installtion-script.sh
```
