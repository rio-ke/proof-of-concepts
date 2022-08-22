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

```bash
Note:
-----
Each piece of information must be accurate when registering an agent with an ado pool.

> Require Organization URL
    example for - https://dev.azure.com/organizationName
    
> PAT Token
    - Go to the User Settings on DevOps portal.
    - Click the Personal Access Token.
    - Create the New Token.
    
> Create Agent Pool name
    - go to the dev.azure.com/origanisation name.
    - go to the project settings.
    - click on agent pools under pipelines.
    - Create a new agent (Please follow the instruction on the new agent)

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


_Use the command shown below to **uninstall** the service_

```bash
sudo bash svc.sh stop
sudo bash svc.sh uninstall
bash config.sh remove
```
