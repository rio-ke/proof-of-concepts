

```bash
#!/usr/bin/env bash

# kubectl-installation.sh

sudo apt update
sudo apt install curl -y
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version
```

execution

```bash
bash kubectl-installation.sh
```

[official documetation](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
