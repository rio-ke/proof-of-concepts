## ansible docs

_installation_

```bash
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

**configuration**

```cfg
[defaults]
inventory=hosts
```

**hosts**

```hosts
[redHat]
35.90.160.156 ansible_user=ec2-user 
34.219.23.38 ansible_user=ec2-user
34.220.194.127 ansible_user=ec2-user
192.168.1.13 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant

[all:vars]
ansible_connection=ssh
ansible_ssh_user=ec2-user 
ansible_ssh_private_key_file=~/.ssh/prom.pem
ansible_ssh_pass=vagrant
```
_adhoc command_

```bash
ansible all -m shell -a "hostname"
```

`palybooks/package.yaml`

```yml
---
- hosts: all
  tasks:
  - name: install the packages
    ansible.builtin.yum:
      name: httpd
      state: latest
  - name: install the packages
    ansible.builtin.yum:
      name: wget
      state: latest
  - name: install the packages
    ansible.builtin.yum:
      name: curl
      state: latest
```
