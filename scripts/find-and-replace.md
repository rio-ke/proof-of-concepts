

create the file in the name `demo.txt`

```txt
AAA=commercial-73
XXX=
YYY=commercial-12696
ZZZ=commercial-11674

```

create the file in the name `script.sh`

```bash
#!/usr/bin/env bash

# declare the variable

TRIGGERING_BUILD_NUMBER="123"
KEYWORD="XXX"
REPLACED_KEYWORD="demo-${TRIGGERING_BUILD_NUMBER}"
FILE="demo.txt"

# Do not change this section
SearchResults=$(grep -w ${KEYWORD} ${FILE} | wc -l)
echo "Resuls are ${searchResults}"
if [ "$SearchResults" != 0 ]; then
    sed -i 's^'${KEYWORD}'.^'${KEYWORD}'='${REPLACED_KEYWORD}^'' "${FILE}"
else
    exit 1
fi

```

execution

```bash
bash script.sh
echo $?
```
