

```bash
# Amazon2 Linux
# installation of docker
sudo amazon-linux-extras install docker

# Access information
sudo usermod -a -G docker ec2-user

# Start the services
sudo systemctl start docker
sudo systemctl enable docker

# validate the docker installation
docker --version

# create the docker container
sudo docker run -p 8080:80 -d --name nginx nginx

# docker container status
docker ps 

# remove the running docker container
docker stop nginx
docker rm -f nginx
docker ps
```
