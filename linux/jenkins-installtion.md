## Jenkins installtion

Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.

* Jenkins can be installed through native system packages, Docker, or even run standalone by any machine with a Java Runtime Environment (JRE) installed.

**dependencies**

```bash
sudo apt install default-jre -y
```


**Jenkins installtion on ubuntu**

```bash
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
  
sudo apt-get update

sudo apt-get install jenkins  -y

```

**Service jenkins**

```bash

sudo systemctl start jenkins
sudo systemctl enable jenkins

```

**Iptables issues**

if iptables are enables you should execute this command or 

```bash
# Allow all traffic from outside

sudo iptables -I INPUT -j ACCEPT
```

**IPTABLES rules maintain after reboot**

```bash
sudo mkdir /etc/iptable-rules
sudo iptables-save > /etc/iptable-rules/rules.txt
sudo iptables-restore < /etc/iptable-rules/rules.txt
```


