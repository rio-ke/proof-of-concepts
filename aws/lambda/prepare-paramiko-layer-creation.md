prepare-paramiko-layer-creation.md

_Dockerfile_

```Dockerfile
FROM lambci/lambda:build-python3.8
RUN pip install -t /opt/python/ paramiko
WORKDIR /var/task
```

_commands_

```bash
docker build -t paramiko .
docker run -ti paramiko paramiko
docker cp paramiko:/opt .
zip -r python3.8-paramiko opt/python
```
