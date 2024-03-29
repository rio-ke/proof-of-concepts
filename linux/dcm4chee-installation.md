
_[dcm4chee docker installation](https://nroduit.github.io/en/getting-started/dcm4chee/)_

```yml
version: "3"
services:
  ldap:
    image: dcm4che/slapd-dcm4chee:2.6.3-29.1
    logging:
      driver: json-file
      options:
        max-size: "10m"
    ports:
      - "389:389"
    env_file: docker-compose.env
    volumes:
      - /var/local/dcm4chee-arc/ldap:/var/lib/openldap/openldap-data
      - /var/local/dcm4chee-arc/slapd.d:/etc/openldap/slapd.d
  db:
    image: dcm4che/postgres-dcm4chee:14.5-29
    logging:
      driver: json-file
      options:
        max-size: "10m"
    ports:
      - "5432:5432"
    env_file: docker-compose.env
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - /var/local/dcm4chee-arc/db:/var/lib/postgresql/data
  arc:
    image: dcm4che/dcm4chee-arc-psql:5.29.1
    logging:
      driver: json-file
      options:
        max-size: "10m"
    ports:
      - "8080:8080"
      - "8443:8443"
      - "9990:9990"
      - "9993:9993"
      - "11112:11112"
      - "2762:2762"
      - "2575:2575"
      - "12575:12575"
    env_file: docker-compose.env
    environment:
      WILDFLY_CHOWN: /opt/wildfly/standalone /storage
      WILDFLY_WAIT_FOR: ldap:389 db:5432
    depends_on:
      - ldap
      - db
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - /var/local/dcm4chee-arc/wildfly:/opt/wildfly/standalone
      - /var/local/dcm4chee-arc/storage:/storage

```

_environement_

```bash
# vim docker-compose.env
STORAGE_DIR=/storage/fs1
POSTGRES_DB=pacsdb
POSTGRES_USER=pacs
POSTGRES_PASSWORD=pacs
```

_run command_

```bash
docker-compose up -d
```

[docs](https://github.com/dcm4che/dcm4chee-arc-light/wiki)

`http://<docker-host>:8080/dcm4chee-arc/ui2` - if secured, login with `https://<docker-host>:8443/dcm4chee-arc/ui2`

  Name | Password | Role(s) |
  --- | --- | --- |
  root | changeit | user <br/> root<br/> auditlog <br/> administrator <br/> all roles specified by client realm-management |
  admin | changeit | user<br/> admin |
  user | changeit | user |


