_changes required_

```txt
# demo.txt
<param name="MaxRatingThreadPoolSize" value="GRID_MAXPRODUCTMODELSYNCTHREADPOOLSIZE"/>
<param name="MaxRatingThreadPoolSize" value="GRID_MAXPRODUCTMODELSYNCTHREADPOOLSIZE"/>
<param name="MaxRatingThreadPoolSize" value="GRID_MAXRATINGTHREADPOOLSIZE"/>
<param name="MaxRatingThreadPoolSize" value="GRID_WORKQUEUETHREADPOOLMAXSIZE"/>
<param name="MaxRatingThreadPoolSize" value="GRID_WORKQUEUETHREADSKEEPALIVETIME"/>
<param name="MaxRatingThreadPoolSize" value="GRID_MAXRATINGTHREADPOOLSIZE"/>
<param name="MaxRatingThreadPoolSize" value="GRID_WORKQUEUETHREADPOOLMAXSIZE"/>
<param name="MaxRatingThreadPoolSize" value="GRID_WORKQUEUETHREADSKEEPALIVETIME"/>
```

_script_

```bash
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

GRID_MAXPRODUCTMODELSYNCTHREADPOOLSIZE="1"
GRID_MAXRATINGTHREADPOOLSIZE="2"
GRID_WORKQUEUETHREADPOOLMAXSIZE="3"
GRID_WORKQUEUETHREADSKEEPALIVETIME="4"
findAndReplace "GRID_MAXPRODUCTMODELSYNCTHREADPOOLSIZE" "$GRID_MAXPRODUCTMODELSYNCTHREADPOOLSIZE" "demo.txt"
findAndReplace "GRID_MAXRATINGTHREADPOOLSIZE" "$GRID_MAXRATINGTHREADPOOLSIZE" "demo.txt"
findAndReplace "GRID_WORKQUEUETHREADPOOLMAXSIZE" "$GRID_WORKQUEUETHREADPOOLMAXSIZE" "demo.txt"
findAndReplace "GRID_WORKQUEUETHREADSKEEPALIVETIME" "$GRID_WORKQUEUETHREADSKEEPALIVETIME" "demo.txt"
```

_expected Results_

```txt
<param name="MaxRatingThreadPoolSize" value="1"/>
<param name="MaxRatingThreadPoolSize" value="1"/>
<param name="MaxRatingThreadPoolSize" value="2"/>
<param name="MaxRatingThreadPoolSize" value="3"/>
<param name="MaxRatingThreadPoolSize" value="4"/>
<param name="MaxRatingThreadPoolSize" value="2"/>
<param name="MaxRatingThreadPoolSize" value="3"/>
<param name="MaxRatingThreadPoolSize" value="4"/>
```
