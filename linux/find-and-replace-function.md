
_configuration file_

```txt
# demo.txt
AAA=demo-73
XXX=
YYY=
ZZZ=demo-11674
```

_script_

```bash
#!/usr/bin/env bash

function findAndReplace() {
    KEYWORD=$1
    REPLACED_KEYWORD=$2
    FILE=$3
    SearchResults=$(grep -w ${KEYWORD} ${FILE} | wc -l)
    if [ "${SearchResults}" != 0 ]; then
        sed -i 's^'${KEYWORD}'.*^'${KEYWORD}'='${REPLACED_KEYWORD}^'' "${FILE}"
    else
        exit 1
    fi
}

## EXECUTE METHOD
BUILD_NUMBER="123"
# EXCUTION FORMAT FIRST SEARCH KEYWORD, REPLACED_KEYWORD AND TRAGET FILE NAME
findAndReplace "XXX" "demo-${BUILD_NUMBER}" "demo.txt"
findAndReplace "YYY" "yyy-${BUILD_NUMBER}" "demo.txt"
```

_expected result_

```txt
AAA=demo-73
XXX=demo-123
YYY=yyy-123
ZZZ=demo-11674
```
