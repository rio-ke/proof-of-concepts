## kubernetes-configmap-and-secret-mount.md

in this documentation to store the .jks keys as a secret in kubernetes and atteched to container.

_create the secrets file_

```bash
base64 -w0 kafka.client.keystore.jks > keystore
base64 -w0 kafka.client.truststore.jks > truststore
cat keystore   # copy the value and paste the line number 22
cat truststore # copy the value and paste the line number 21
```

_create the secret from base64 encoded value_

```yml
apiVersion: v1
kind: Secret
metadata:
  name: kafka-tls-keystore-jks
type: Opaque
data:
  kafka.client.truststore.jks: amlubwo=   
  kafka.client.keystore.jks: amFudQo=
```

_create the configmap to consume the kafka tls authentication value_

```yml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: kafka-tls-authentication-key
data:
  client-ssl-auth.properties: |
    security.protocol=SSL
    ssl.truststore.location=/etc/boo/kafka.client.truststore.jks
    ssl.truststore.password=MyClientPassword123
    ssl.keystore.location=/etc/boo/kafka.client.keystore.jks
    ssl.keystore.password=MyClientPassword123
    ssl.key.password=MyClientPassword123
```

_the existing configmap and secret consumed here_

```yml
---
apiVersion: v1
kind: Pod
metadata:
  name: web-server
spec:
  containers:
    - name: web-server
      image: nginx
      volumeMounts:
        - name: "kafka-tls-authentication"
          mountPath: "/etc/foo"
          readOnly: true
        - name: "kafka-tls-keystore"
          mountPath: "/etc/boo"
          readOnly: true
  volumes:
    - name: kafka-tls-authentication
      configMap:
        name: "kafka-tls-authentication-key"
    - name: kafka-tls-keystore
      secret:
        secretName: "kafka-tls-keystore-jks"
```

_if you want to change the secret mounth path value you can refer this yml_

```yml
---
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: mypod
      image: nginx
      volumeMounts:
        - name: "kafka-tls-authentication"
          mountPath: "/etc/foo"
          readOnly: true
        - name: "kafka-tls-keystore"
          mountPath: "/etc/boo"
          readOnly: true
  volumes:
    - name: kafka-tls-authentication
      configMap:
        name: "kafka-tls-authentication-key"
    - name: kafka-tls-keystore
      secret:
        secretName: "kafka-tls-keystore-jks"
        items:
        - key: kafka.client.truststore.jks
          path: kafka.client.truststore.jks
        - key: kafka.client.keystore.jks
          path: kafka.client.keystore.jks
```

_After deployment you can validate the configmap and secret configuration_

```bash
kubectl exec -ti web-server bash
> cat /etc/foo/client-ssl-auth.properties
> cat /etc/boo/kafka.client.keystore.jks
> cat /etc/boo/kafka.client.truststore.jks
exit
```
