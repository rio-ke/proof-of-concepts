

```ps1
$url = "https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/AmazonCloudWatchAgent.zip"
$output = $env:TEMP + "\AmazonCloudWatchAgent.zip"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)
Expand-Archive -path $output -destinationpath $env:TEMP
cd $env:TEMP
./install.ps1
cd C:\Program Files\Amazon\AmazonCloudWatchAgent\
./amazon-cloudwatch-agent-ctl.ps1 -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-windows -s
```
