
```bash
# Update the system
sudo apt update

# Create a directory for ado agent
mkdir ado-agent-runner

# change the ado agent directory
cd ado-agent-runner

# Download the agent file from devops portal
wget https://vstsagentpackage.azureedge.net/agent/2.206.1/vsts-agent-linux-x64-2.206.1.tar.gz

# unzip the files
tar xvzf vsts-agent-linux-x64-2.206.1.tar.gz

# list the directory
ls -la

# Enter the details about the agent pool 
bash config.sh 
ls -la

# install the sevice packages
sudo bash svc.sh  install

# start and stop the service
sudo bash svc.sh start
sudo bash svc.sh stop
```
