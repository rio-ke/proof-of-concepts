
```bash

#!/bin/bash

ARGS=$(getopt -a --options f:r:t:v --long "KEYWORD:,REPLACED_KEYWORD:,FILE:,verbose" -- "$@")

eval set -- "$ARGS"

while true; do
    case "$1" in
    -f | --find)
        KEYWORD="$2"
        echo "Name: $KEYWORD"
        shift 2
        ;;
    -r | --replace)
        REPLACED_KEYWORD="$2"
        echo "ID: $REPLACED_KEYWORD"
        shift 2
        ;;
    -t | --target)
        FILE="$2"
        echo "ID: $FILE"
        shift 2
        ;;
    -v | --verbose)
        echo "Please use -r -t -f respectively"
        break
        ;;
    --)
        break
        ;;
    esac
done

function findAndReplace() {
    # BUILD_NUMBER="123"
    # KEYWORD="XXX"
    # REPLACED_KEYWORD="demo-${BUILD_NUMBER}"
    # FILE="demo.txt"
    # DO NOT CHANGE
    SearchResults=$(grep -w ${KEYWORD} ${FILE} | wc -l)
    if [ "${SearchResults}" != 0 ]; then
        sed -i 's^'${KEYWORD}'.*^'${KEYWORD}'='${REPLACED_KEYWORD}^'' "${FILE}"
    else
        exit 1
    fi
}

if [[ -z "${KEYWORD}" ]] && [[ -z "${REPLACED_KEYWORD}" ]] && [[ -z "${FILE}" ]]; then
    findAndReplace
else
    echo "Argument required."

fi

```
