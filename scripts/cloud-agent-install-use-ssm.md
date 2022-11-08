
conditional installation

```bash
version=$(lsb_release --id --short)
if [ "${version}" == "Ubuntu" ]; then
    echo "This is ${version} version"
else if [ "${version}" == "RedHat" ]; then
    echo "This is ${version} version"
else if [ "${version}" == "CentOS" ]; then
    echo "This is ${version} version"
fi
```

Ubuntu cloud-agent-installation

```bash
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
sudo mkdir -p /usr/share/collectd/
sudo touch /usr/share/collectd/types.db
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:ubuntu
```

Centos and Amazon cloud-agent-installation

```bash
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
# sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
sudo mkdir -p /usr/share/collectd/
sudo touch /usr/share/collectd/types.db
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:Amazoncloudwatch-linux
```
