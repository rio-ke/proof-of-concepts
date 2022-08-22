

```sh

#!/usr/bin/env bash

SSH_PASSWORD="Cyber@123"
headNode0="hn0-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net"
headNode1="hn1-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net"
worerNode0="wn0-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net"
worerNode1="wn1-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net"
worerNode2="wn2-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net"

10.42.60.204 hn0-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net
10.42.60.205 hn1-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net
10.42.60.199 wn0-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net
10.42.60.203 wn1-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net
10.42.60.200 wn2-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net

sudo apt install sshpass -y

mkdir ssl
cd ssl

sshpass -p "${SSH_PASSWORD}" ssh -o StrictHostKeyChecking=no sshuser@"${headNode0}" "mkdir ssl"
sshpass -p "${SSH_PASSWORD}" ssh -o StrictHostKeyChecking=no sshuser@"${headNode1}" "mkdir ssl"
sshpass -p "${SSH_PASSWORD}" ssh -o StrictHostKeyChecking=no sshuser@wn0-apsdsf "mkdir ssl"
sshpass -p "${SSH_PASSWORD}" ssh -o StrictHostKeyChecking=no sshuser@wn1-apsdsf "mkdir ssl"
sshpass -p "${SSH_PASSWORD}" ssh -o StrictHostKeyChecking=no sshuser@wn2-apsdsf "mkdir ssl"

# worerNode0
keytool -genkey -keystore kafka.server.keystore.jks -validity 365 -storepass "MyServerPassword123" -keypass "MyServerPassword123" -dname "CN=wn0-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net" -storetype pkcs12
keytool -keystore kafka.server.keystore.jks -certreq -file cert-file -storepass "MyServerPassword123" -keypass "MyServerPassword123"
scp cert-file sshuser@hn0-apsdsf:~/ssl/wn0-cert-sign-request

# workernode1
keytool -genkey -keystore kafka.server.keystore.jks -validity 365 -storepass "MyServerPassword123" -keypass "MyServerPassword123" -dname "CN=wn1-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net" -storetype pkcs12
keytool -keystore kafka.server.keystore.jks -certreq -file cert-file -storepass "MyServerPassword123" -keypass "MyServerPassword123"
scp cert-file sshuser@hn0-apsdsf:~/ssl/wn1-cert-sign-request

# worerNode2
keytool -genkey -keystore kafka.server.keystore.jks -validity 365 -storepass "MyServerPassword123" -keypass "MyServerPassword123" -dname "CN=wn2-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net" -storetype pkcs12
keytool -keystore kafka.server.keystore.jks -certreq -file cert-file -storepass "MyServerPassword123" -keypass "MyServerPassword123"
scp cert-file sshuser@hn0-apsdsf:~/ssl/wn2-cert-sign-request

# hn0
openssl req -new -newkey rsa:4096 -days 365 -x509 -subj "/CN=Kafka-Security-CA" -keyout ca-key -out ca-cert -nodes
openssl x509 -req -CA ca-cert -CAkey ca-key -in wn0-cert-sign-request -out wn0-cert-signed -days 365 -CAcreateserial -passin pass:"MyServerPassword123"
openssl x509 -req -CA ca-cert -CAkey ca-key -in wn1-cert-sign-request -out wn1-cert-signed -days 365 -CAcreateserial -passin pass:"MyServerPassword123"
openssl x509 -req -CA ca-cert -CAkey ca-key -in wn2-cert-sign-request -out wn2-cert-signed -days 365 -CAcreateserial -passin pass:"MyServerPassword123"

scp wn0-cert-signed sshuser@wn0-apsdsf:~/ssl/cert-signed
scp wn1-cert-signed sshuser@wn1-apsdsf:~/ssl/cert-signed
scp wn2-cert-signed sshuser@wn2-apsdsf:~/ssl/cert-signed

scp ca-cert sshuser@wn0-apsdsf:~/ssl/ca-cert
scp ca-cert sshuser@wn1-apsdsf:~/ssl/ca-cert
scp ca-cert sshuser@wn2-apsdsf:~/ssl/ca-cert

# worerNode0
keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -import -file cert-signed -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt

# worerNode1
keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -import -file cert-signed -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt

# worerNode2
keytool -keystore kafka.server.truststore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -alias CARoot -import -file ca-cert -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt
keytool -keystore kafka.server.keystore.jks -import -file cert-signed -storepass "MyServerPassword123" -keypass "MyServerPassword123" -noprompt

# hn1
mkdir ssl 
cd ssl

keytool -genkey -keystore kafka.client.keystore.jks -validity 365 -storepass "MyClientPassword123" -keypass "MyClientPassword123" -dname "CN=hn1-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net" -storetype pkcs12
keytool -keystore kafka.client.keystore.jks -certreq -file client-cert-sign-request -storepass "MyClientPassword123" -keypass "MyClientPassword123"
scp client-cert-sign-request sshuser@hn0-apsdsf:~/ssl/client-cert-sign-request


#hn0
cd ssl
openssl x509 -req -CA ca-cert -CAkey ca-key -in ~/ssl/client-cert-sign-request -out ~/ssl/client-cert-signed -days 365 -CAcreateserial -passin pass:MyClientPassword123
scp client-cert-signed sshuser@hn1-apsdsf:~/ssl/client-signed-cert
scp ca-cert sshuser@hn1-apsdsf:~/ssl/ca-cert


#hn1
keytool -keystore kafka.client.truststore.jks -alias CARoot -import -file ca-cert -storepass "MyClientPassword123" -keypass "MyClientPassword123" -noprompt
keytool -keystore kafka.client.keystore.jks -alias CARoot -import -file ca-cert -storepass "MyClientPassword123" -keypass "MyClientPassword123" -noprompt
keytool -keystore kafka.client.keystore.jks -import -file client-signed-cert -storepass "MyClientPassword123" -keypass "MyClientPassword123" -noprompt


# client-ssl-auth.properties
security.protocol=SSL
ssl.truststore.location=/home/sshuser/ssl/kafka.client.truststore.jks
ssl.truststore.password=MyClientPassword123
ssl.keystore.location=/home/sshuser/ssl/kafka.client.keystore.jks
ssl.keystore.password=MyClientPassword123
ssl.key.password=MyClientPassword123

# validation
KAFKABROKERS='wn0-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net:9093,wn1-apsdsf.in0vd1nkfuvevp0celnst1uytf.ix.internal.cloudapp.net:9093'
/usr/hdp/current/kafka-broker/bin/kafka-console-consumer.sh   --bootstrap-server $KAFKABROKERS --topic ISOConvertor_Response --from-beginning --consumer.config ~/ssl/client-ssl-auth.properties


```
