

```bash
#!/usr/bin/env bash

# kubectl-installation.sh
echo "update the respository"
sudo apt update
echo ""
echo "install the curl packages"
sudo apt install curl -y
echo ""
echo "Downlaod the kubectl binary laterst version"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
echo ""
echo "grant the executable privileges"
sudo chmod +x kubectl
echo ""
echo "move the binary to gloabl location"
sudo mv kubectl /usr/local/bin/
echo ""
echo "auto completion enable"
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo ""
echo "If you have an alias for kubectl, you can extend shell completion to work with that alias"
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
echo "kubectl installation has been installed"
```

execution

```bash
bash kubectl-installation.sh
```

[official documetation](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
