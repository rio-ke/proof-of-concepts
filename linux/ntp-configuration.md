## NTP server configuration

**Network Time Protocol** (NTP) is an internet protocol used to synchronize with computer clock time sources in a network. It belongs to and is one of the 
oldest parts of the TCP/IP suite.  The term NTP applies to both the protocol and the client-server programs that run on computers.


_**Requirements**_

|OS |ipaddress | act as |
|---|---|---|
|Ubuntu |192.168.1.3| server |
|Ubuntu |192.168.1.4| client |


_configuration of NTP server_
---

If the package is not found, use the following commands to install NTP.

```bash
sudo apt update
sudo apt install ntp -y
```
**Find Version**

```bash
sntp --version
```
_**Edit server Config file**_

```bash
vim/etc/ntp.conf

# In this section line no 21 to 24 and 27 and 51 lines are customise for ur needs get backup then edit
# to get pool file plz visit for more info => https://www.pool.ntp.org/zone/asia
```


_Next restart the service _

```bash
systemctl restart ntp 
```
_and check status_
```bash
systemctl status ntp
```

_configuration of NTP client_
---

first check the running status  using this command
```bash
systemctl status systemd-timesyncd 
```
_edit conf file_

```bash 
 vi /etc/systemd/timesyncd.conf 
 
 # add ur domain name in last line
 NTP=192.168.1.3
 ```

 
 then restart
 ```bash
 systemctl restart systemd-timesyncd 
 ```
 and check status using this command
 ```bash
 timedatectl timesync-status 
 ```
 
