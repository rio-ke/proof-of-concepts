api-gateway-mtls-creation.md

```bash
openssl genrsa -out RootCA.key 4096
openssl req -new -x509 -days 3650 -key RootCA.key -out RootCA.pem
openssl genrsa -out client.key 2048
openssl req -new -key client.key -out client.csr
openssl x509 -req -in client.csr -CA RootCA.pem -CAkey RootCA.key -set_serial 01 -out client.pem -days 3650 -sha256
```
