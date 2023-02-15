_azure key vault certificate download and seperation of the crt and key_

```bash
openssl pkcs12 -in main.pfx -nokeys -clcerts -chain -out clcert.crt
openssl pkcs12 -in main.pfx -nokeys -cacerts -chain -out cacert.crt
openssl pkcs12 -in main.pfx -nocerts -out cert.key
# Enter Import Password: press enter
# Enter PEM pass phrase: Password@123
# Verifying - Enter PEM pass phrase: Password@123
cat clcert.crt cacert.crt >> final.crt
openssl rsa -in cert.key -out unencrypted.key
```
kubernetes tls secret creation

```bash
kubectl create secret tls tls-secret -n default --cert=final.crt --key=unencrypted.key
```

_In case you need to convert the certificate to password Protected cert (for a web app for example)_

```
openssl pkcs12 -in main.pfx -out main.pem -nodes
openssl pkcs12 -export -out main.pfx -in  main.pem
# Enter the password
# Password: Password@123
```
