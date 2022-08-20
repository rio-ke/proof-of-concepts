## ssh-connect.md
SSH login

```bash
ssh ubuntu@13.215.251.129
```
face error ` (permission denied public key)

download `etcd.pem` key

change the ownership 

```bash
chown 400 etcd.pem
```
and use the command to enter the instance

```bash
ssh -i etcd.pem ubuntu@13.215.251.129
```

### ssh-remote-server-connect
`ECDSA host key Warning Error`

*_To connect remote server_*

```bash
ssh username@ip_add
```

`@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:UX/eJ3HZT9q6lzAN8mxf+KKAo2wmCVWblzXwY8qxqZY.
Please contact your system administrator.
Add correct host key in /home/sk/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /home/sk/.ssh/known_hosts:4
ECDSA host key for 192.168.1.102 has changed and you have requested strict checking.
Host key verification failed.`

To work around this issue, first we need to update the cached ECDSA host key of your remote system in your local system's known_hosts file. As you might know, usually, the host keys will be stored in the /home/yourusername/.ssh/known_hosts file.

To remove the cached key, use the following command:

```bash
ssh-keygen -R <remote-system-ip-address>
```

`Sample output:
Host 192.168.1.102 found: line 4
/home/sk/.ssh/known_hosts updated.
Original contents retained as /home/sk/.ssh/known_hosts.old`

Done

Now, try again to ssh to the remote system with command:

```bash
ssh dodo@192.168.1.100
```

Type 'Yes' and hit ENTER to update the host key of your remote system in your local system's known_hosts file.
