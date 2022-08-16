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

findAndReplace "acceptorThreadCount=.*" "acceptorThreadCount=$tomcat_acceptorThreadCount" "${CATALINA_HOME}/conf/server.xml"
findAndReplace "maxConnections=.*" "maxConnections=$tomcat_maxConnections" "${CATALINA_HOME}/conf/server.xml"
# findAndReplace "Connector port="8080" protocol="HTTP/1.1".*" "Connector port="8080" protocol="$tomcat_protocol"" "${CATALINA_HOME}/conf/server.xml"
findAndReplace "maxPostSize=.*" "maxPostSize=$tomcat_maxPostSize" "${CATALINA_HOME}/conf/server.xml"
findAndReplace "maxThreads=.*" "maxThreads=$tomcat_maxThreads" "${CATALINA_HOME}/conf/server.xml"
findAndReplace "processorCache=.*" "processorCache=$tomcat_processorCache" "${CATALINA_HOME}/conf/server.xml"
findAndReplace "minSpareThreads=.*" "minSpareThreads=$tomcat_minSpareThreads" "${CATALINA_HOME}/conf/server.xml"

```
