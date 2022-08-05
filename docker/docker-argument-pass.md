
_docker file_

```Dockerfile
# Dockerfile
FROM nginx
ARG DB_PASSWORD
ENV DB_PASSWORD=${DB_PASSWORD}
```

_docker build with args_

```bash
docker build --build-arg DB_PASSWORD="1234" -t jjino/docker:v1.0 .
```
