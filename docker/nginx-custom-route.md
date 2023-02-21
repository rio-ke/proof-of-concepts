_nginx custom route_


```Dockerfile
FROM nginx:alpine
WORKDIR /app/apps
COPY . .
COPY nginx.conf /etc/nginx/conf.d/default.conf
```

_nginx.conf_

```service
server {
    listen       80;
    server_name  localhost;
    location / {
        root   /app/apps/angular;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    location /engine/ {
    
    }

    location /builder/ {
    
    }

    location /viewer/engine/ {
        alias /app/apps/engine/;
    }

    location /viewer/builder/ {
        alias /app/apps/builder/;
    }
    
    location /viewer/ {
    
    }
}
```
