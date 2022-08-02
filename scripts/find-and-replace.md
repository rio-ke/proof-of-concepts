

create the file in the name `demo.txt`

```txt
AB9_TAG=commercial-73
AB_TAG=
AP_TAG=commercial-12696
BC_TAG=commercial-11674
CC_TAG=commercial-89
COMPOSE_HTTP_TIMEOUT=120
FILEBEAT_TAG=master-30
HOME_TAG=20220531_1656-1.33.0-glibc
HTTPFILESERVER_TAG=20220531_1656-1.17.2
HTTPSOFFLOADING_TAG=20220531_1605-2.4.17-alpine
PC_TAG=commercial-28101
```

create the file in the name `script.sh`

```bash
#!/usr/bin/env bash

# variable declaration
TRIGGERING_BUILD_NUMBER="123"
KEYWORD="AB_TAG"
FILE="demo.txt"

SearchResults=$(grep -w ${KEYWORD} ${FILE} | wc -l)
echo "Resuls are ${searchResults}"
if [ "$SearchResults" != 0 ]; then
    # echo "${SearchResults} not empty"
    sed -i 's^'${KEYWORD}'.^'${KEYWORD}'=csro-'${TRIGGERING_BUILD_NUMBER}^'' "${FILE}"
else
    exit 1
fi
```

execution

```bash
bash script.sh
echo $?
```
