### Docker-custom-images
---
**Docker image details**
|purpose|details|
|---|---|
|operating system| centos:7 |
|Document Root|/var/www/html/index.html|
|Port| 80 |

**_httpd custom image build_**

```bash
FROM centos:7
RUN yum install httpd -y
COPY index.html /var/www/html/index.html
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
```
**_Build the httpd custom image_**
```bash
docker build -t (tagname) .
```

**_docker run commands_**

```bash
docker run -d -p (localhost_port):(container_port) --name (containername) (imagename)
ex:
docker run -d -p 9990:80 --name httpd-container-v1.1 httpd:v1.1
```


**Output**
![image](https://user-images.githubusercontent.com/91359308/169489103-86482fc6-4e30-41c8-b2f3-ca1e9a89740f.png)


**Docker image details**
|purpose|details|
|---|---|
|operating system| ubuntu 22 |
|Document Root|usr/sbin/vsftpd /etc/vsftpd.conf|
|Port| 22 |


**_vsftp custom image build_**

```bash
FROM ubuntu:latest
RUN apt update && apt install vsftpd -y
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
```

**_docker run commands_**

```bash
sudo docker build -t vsftp-custom:v1.0 .

sudo docker run -d -p 22:21 --name vsftp_container1 dd1fdfcdf8aa
```
**_output**

![Screenshot from 2022-05-20 12-51-38](https://user-images.githubusercontent.com/102893121/169492990-505aa71a-a5d3-4017-9f79-9b4bbfc150c6.png)

```bash
docker images
curl localhost:22
```
output
![Screenshot from 2022-05-20 14-31-15](https://user-images.githubusercontent.com/102893121/169493951-ed7d4395-bab4-461d-85e1-6ec9a391bb59.png)

