## ansible docs

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
