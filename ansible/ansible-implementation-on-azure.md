**_ansible-implementation-on-azure_**


Azure itself provides infrastructure as a service, platform as a service, and software as a service. now a days everyone wants to provison the resource and deployment the apps as  a automation.
 
Depending on your or everyone's expectations, it may be possible to provide all the resources using ansible.

Ansible we are called as a configuration management tool. moreover this is user based input basically allowing to easily passing those information compared to other tools.

Is it possible to provision infrastructure as a service via Ansible?

yes. It is possible. By default, Ansile provides those details as a module. We can accommodate all the stuffs as a YAML and run it.

[Reference yaml](https://docs.ansible.com/ansible/latest/collections/azure/azcollection/azure_rm_virtualmachine_module.html)

```yml
- name: Create VM with defaults
  azure_rm_virtualmachine:
    resource_group: myResourceGroup
    name: testvm10
    admin_username: "{{ username }}"
    admin_password: "{{ password }}"
    image:
      offer: CentOS
      publisher: OpenLogic
      sku: '7.1'
      version: latest
```
