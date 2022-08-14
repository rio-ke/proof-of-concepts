
based on json file create the secrets use azure rest api integrate with ansible.

```json
{
  "secrets": [
    {
      "name": "demo",
      "value": "123"
    },
    {
      "name": "test",
      "value": "456"
    }
  ]
}

```

Create the ansible file

```yml
---
- name: all
  hosts: localhost
  vars:
    TENANT_ID: "xxxxx"
    CLIENT_ID: "xxxxx"
    SECRET_ID: "zxxxx"
    SECRET_NAME: "crpsecret"
    SECRET_VALUE: "123"
    KEYVAULT_NAME: "oom5akv01"
    BEARER_TOKEN_SCOPE: "https://vault.azure.net"
    SECRET_CREATION: false
  tasks:
    - name: load Json files from file.
      set_fact:
        jsondata: "{{lookup('file','json.json')}}"
    - name: debug
      debug:
        msg: "{{ item.name }} {{ item.value }}"
      loop: "{{ jsondata.secrets }}"
    - name: Generate bearer token
      uri:
        url: "https://login.microsoftonline.com/{{ TENANT_ID }}/oauth2/token"
        return_content: yes
        method: GET
        headers:
          Content-Type: application/x-www-form-urlencoded
        body: "grant_type=client_credentials&client_id={{CLIENT_ID}}&resource={{ BEARER_TOKEN_SCOPE }}&client_secret={{SECRET_ID}}"
      register: _TOKEN
    - name: debug
      debug:
        msg: "{{ _TOKEN.json.access_token }}"
    - name: "SECRET CREATE IN {{ KEYVAULT_NAME }}"
      uri:
        url: "https://{{ KEYVAULT_NAME }}.vault.azure.net//secrets/{{ item.name }}?api-version=7.3"
        method: PUT
        headers:
          Authorization: "Bearer {{ _TOKEN.json.access_token }}"
          Content-Type: application/json
        return_content: yes
        body_format: json
        body: |
          {
            "value": "{{ item.value }}"
          }
      register: _SECRET_RESULTS
      loop: "{{ jsondata.secrets }}"
```
