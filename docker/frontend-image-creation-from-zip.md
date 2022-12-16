
_Reference_

![image](https://user-images.githubusercontent.com/57703276/208098994-9bdb5a78-b5f8-4a69-9e06-95873b3f0e0f.png)

_Dockerfile_

```Dockerfile
FROM nginx
COPY . /usr/share/nginx/html
```

_output_

```bash
curl -I http://localhost/spike/
```
