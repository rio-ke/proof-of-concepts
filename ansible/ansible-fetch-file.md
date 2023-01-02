# Fetch files from remote nodes

```yml
---

- name: fetch files from remote nodes
  hosts: v
  become: yes
  # ignore_errors: true

  tasks:
    - name: cpoy file to remote host to ansible local host machine
      fetch:
        src: /home/server/ftp/index.yml
        dest: /home/rcms-lap-173/Public/
        validate_checksum: yes
        flat: yes
```

_excecution_

```yml
ansible-playbook fetch.yml
```
