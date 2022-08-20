```bash

sudo iptables -A DOCKER 1 -p tcp --dport 9000 -j REJECT
sudo iptables -L --line-numbers
sudo iptables -L -n

#Save the IPtables
sudo /sbin/iptables-save

# delete the rule
sudo iptables -D DOCKER 1

```
