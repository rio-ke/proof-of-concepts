```bash
#!/usr/bin/env bash

set -E -u -o pipefail -e

function findAndReplace() {
    KEYWORD=$1
    REPLACED_KEYWORD=$2
    FILE=$3
    SearchResults=$(grep -w ${KEYWORD} ${FILE} | wc -l)
    if [ "${SearchResults}" != 0 ]; then
        sed -i 's^'${KEYWORD}'^'${REPLACED_KEYWORD}^'' "${FILE}"
    else
        echo "${KEYWORD} no keywaords"
        exit 1
    fi
}

echo "Entrypoint.sh: Writing environment variables to files"

tomcat_protocol="HTTP/1.2"
echo $tomcat_protocol
findAndReplace "protocol=.*" "protocol="$tomcat_protocol"" "demo.txt"
```
