

```bash
# Amazon2 Linux
# installation of docker
sudo amazon-linux-extras install docker

# above the command not working you can use below command or else leave it 
yum install docker

# user access provide 
sudo usermod -a -G docker ec2-user
sudo reboot

# Start the services
sudo systemctl start docker
sudo systemctl enable docker

# validate the docker installation
sudo docker --version

# create the docker container
sudo docker run -p 8080:80 -d --name nginx nginx

# docker container status
sudo docker ps 

# remove the running docker container
sudo docker stop nginx
sudo docker rm -f nginx
sudo docker ps
```
