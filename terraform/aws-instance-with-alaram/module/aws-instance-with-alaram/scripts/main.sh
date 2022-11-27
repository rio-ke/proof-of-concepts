#!/usr/bin/env bash
echo "ssm parameter name is => ${ssmParameterName}"
sudo mkdir -p /usr/share/collectd/
sudo touch /usr/share/collectd/types.db
sudo yum update -y
sudo yum install wget -y
echo "amazon-ssm-agent and amazon-cloudwatch-agent package instalation started..."
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo yum install -y https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
echo "Service amazon-ssm-agent start process..."
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sleep 180
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c "ssm:${ssmParameterName}"
echo "Service amazon-cloudwatch-agent start process..."
sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent
sudo systemctl status amazon-ssm-agent -l
sudo systemctl status amazon-cloudwatch-agent -l