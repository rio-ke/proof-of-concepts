

```bash
#!/usr/bin/env bash

# kubectl-installation.sh
echo -e "\e[1;31mupdate the respository"
sudo apt update
echo "install the curl packages"
sudo apt install curl -y
echo "Downlaod the kubectl binary laterst version"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
echo "grant the executable privileges"
sudo chmod +x kubectl
echo "move the binary to gloabl location"
sudo mv kubectl /usr/local/bin/
echo "auto completion enable"
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo "If you have an alias for kubectl, you can extend shell completion to work with that alias"
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
echo -e "\e[1;31mkubectl installation has been installed"
```

execution

```bash
bash kubectl-installation.sh
```

[official documetation](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
