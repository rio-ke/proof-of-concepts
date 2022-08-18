

**Update the system**
```
sudo apt update
```
**Create a directory for ado agent && change the ado agent directory**
```
mkdir ado-agent-runner
cd ado-agent-runner
``` 
**Create the agent pool for azure devops**
```
- go to the dev.azure.com/origanisation name.
- go to the project settings.
- click on agent pools unde.r pipelines.
- Create a new agent (Please follow the instruction on the new agent)

# Download the agent file from devops portal
- wget https://vstsagentpackage.azureedge.net/agent/2.206.1/vsts-agent-linux-x64-2.206.1.tar.gz

# unzip the files
tar xvzf vsts-agent-linux-x64-2.206.1.tar.gz
```


**list the directory**
```
ls -la
```
**Enter the details about the agent pool**
```
bash config.sh 
ls -la
```

**Install the sevice packages**
```
sudo bash svc.sh  install
```

**start and stop the service**
```
sudo bash svc.sh start
sudo bash svc.sh stop
```
