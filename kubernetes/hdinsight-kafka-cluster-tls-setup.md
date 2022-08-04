|IP ADDRESS|HOST NAME | DOMAIN NAME|
|---|---|---|
|10.42.60.7 |wn0-apsdfs | wn0-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net|
|10.42.60.5 |wn1-apsdfs | wn1-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net|
|10.42.60.6 |wn2-apsdfs | wn2-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net|
|10.42.60.17|hn0-apsdfs |hn0-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net|
|10.42.60.16|hn1-apsdfs |hn1-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net|

Perform initial setup on head node 0, which for HDInsight will fill the role of the Certificate Authority (CA).

```bash
ssh sshuser@hn0-apsdfs
mkdir ssl
exit
```


Perform the same initial setup on each of the brokers (worker nodes 0, 1 and 2).

```bash
ssh sshuser@wn0-apsdfs
mkdir ssl
cd ssl
keytool -genkey -keystore kafka.server.keystore.jks -validity 365 -storepass "MyServerPassword123" -keypass "MyServerPassword123" -dname "CN=wn0-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net" -storetype pkcs12
keytool -keystore kafka.server.keystore.jks -certreq -file cert-file -storepass "MyServerPassword123" -keypass "MyServerPassword123"
scp cert-file sshuser@hn0-apsdfs:~/ssl/wn0-cert-sign-request
```

```bash
ssh sshuser@wn1-apsdfs
mkdir ssl
cd ssl
keytool -genkey -keystore kafka.server.keystore.jks -validity 365 -storepass "MyServerPassword123" -keypass "MyServerPassword123" -dname "CN=wn1-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net" -storetype pkcs12
keytool -keystore kafka.server.keystore.jks -certreq -file cert-file -storepass "MyServerPassword123" -keypass "MyServerPassword123"
scp cert-file sshuser@hn0-apsdfs:~/ssl/wn1-cert-sign-request
```

```bash
ssh sshuser@wn2-apsdfs
mkdir ssl
cd ssl
keytool -genkey -keystore kafka.server.keystore.jks -validity 365 -storepass "MyServerPassword123" -keypass "MyServerPassword123" -dname "CN=wn2-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net" -storetype pkcs12
keytool -keystore kafka.server.keystore.jks -certreq -file cert-file -storepass "MyServerPassword123" -keypass "MyServerPassword123"
scp cert-file sshuser@hn0-apsdfs:~/ssl/wn2-cert-sign-request
```

_CA machine_

```bash
ssh sshuser@hn0-apsdfs
mkdir ssl
cd ssl
openssl req -new -newkey rsa:4096 -days 365 -x509 -subj "/CN=Kafka-Security-CA" -keyout ca-key -out ca-cert -nodes
openssl x509 -req -CA ca-cert -CAkey ca-key -in wn0-cert-sign-request -out wn0-cert-signed -days 365 -CAcreateserial -passin pass:"MyServerPassword123"
openssl x509 -req -CA ca-cert -CAkey ca-key -in wn1-cert-sign-request -out wn1-cert-signed -days 365 -CAcreateserial -passin pass:"MyServerPassword123"
openssl x509 -req -CA ca-cert -CAkey ca-key -in wn2-cert-sign-request -out wn2-cert-signed -days 365 -CAcreateserial -passin pass:"MyServerPassword123"

# Send the signed certificates back to the worker nodes from the CA (headnode0).

scp wn0-cert-signed sshuser@wn0-apsdfs:~/ssl/cert-signed
scp wn1-cert-signed sshuser@wn1-apsdfs:~/ssl/cert-signed
scp wn2-cert-signed sshuser@wn2-apsdfs:~/ssl/cert-signed

# Send the public certificate of the CA to each worker node.

scp ca-cert sshuser@wn0-apsdfs:~/ssl/ca-cert
scp ca-cert sshuser@wn1-apsdfs:~/ssl/ca-cert
scp ca-cert sshuser@wn2-apsdfs:~/ssl/ca-cert
```
# worker nodes wn0,wn1,wn2 =>

```bash
ssh sshuser@wn0-apsdfs
cd ssl
keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -import -file cert-signed -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
```

```bash
ssh sshuser@wn1-apsdfs
cd ssl
keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -import -file cert-signed -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
```

```bash
ssh sshuser@wn2-apsdfs
cd ssl
keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -import -file cert-signed -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
```


openssl x509 -req -CA ca-cert -CAkey ca-key -in ~/ssl/client-cert-sign-request -out ~/ssl/client-cert-signed -days 365 -CAcreateserial -passin pass:MyClientPassword123


```bash

/usr/hdp/current/kafka-broker/bin/kafka-console-consumer.sh --bootstrap-server  $KAFKABROKERS:9093 --topic MT_Response_Builder_Ingress --consumer.config ~/ssl/client-ssl-auth.properties --from-beginning

scp client-cert-sign-request sshuser@hn0-apsdfs:~/ssl/client-cert-sign-request
scp client-cert-signed sshuser@hn1-apsdfs:~/ssl/client-signed-cert
scp ca-cert sshuser@hn1-apsdfs:~/ssl/ca-cert


keytool -genkey -keystore kafka.client.keystore.jks -validity 365 -storepass "MyClientPassword123" -keypass "MyClientPassword123" -dname "CN=hn1-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net" -storetype pkcs12
keytool -keystore kafka.client.keystore.jks -certreq -file client-cert-sign-request -storepass "MyClientPassword123" -keypass "MyClientPassword123"


keytool -keystore kafka.client.truststore.jks -alias CARoot -import -file ca-cert -storepass "MyClientPassword123" -keypass "MyClientPassword123" -noprompt
keytool -keystore kafka.client.keystore.jks -alias CARoot -import -file ca-cert -storepass "MyClientPassword123" -keypass "MyClientPassword123" -noprompt
keytool -keystore kafka.client.keystore.jks -import -file client-signed-cert -storepass "MyClientPassword123" -keypass "MyClientPassword123" -noprompt


export KAFKABROKERS=wn0-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net:9093,wn1-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net:9093,wn2-apsdfs.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net:9093


/usr/hdp/current/kafka-broker/bin/kafka-console-consumer.sh --bootstrap-server  $KAFKABROKERS:9093 --topic MT_Response_Builder_Ingress --consumer.config ~/client/client-ssl-auth.properties --from-beginning
