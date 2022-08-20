## azure-ado-agent-creation.md

_Update the system_

```bash
sudo apt update
```
_Create a directory for ado agent && change the ado agent directory_

```bash
mkdir ado-agent-runner
cd ado-agent-runner
``` 
_Create the agent pool for azure devops_

```
> Require Organization URL
> PAT Token
> Create Agent Pool name

Each piece of information must be accurate when registering an agent with an ado pool.```

```bash
# Download the agent file from devops portal
- wget https://vstsagentpackage.azureedge.net/agent/2.206.1/vsts-agent-linux-x64-2.206.1.tar.gz
# unzip the files
tar xvzf vsts-agent-linux-x64-2.206.1.tar.gz
```

_Enter the details about the agent pool_

```bash
bash config.sh 
```

_Install the sevice packages_
```
sudo bash svc.sh  install
```

_start and stop the service_
```
sudo bash svc.sh start
sudo bash svc.sh stop
```


uninstall the service

```bash
sudo bash svc.sh stop
sudo bash svc.sh uninstall
bash config.sh remove
```
