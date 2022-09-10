
convert .p7b to .pfx

```
openssl pkcs7 -print_certs -in cert.p7b -out cert.cer
openssl pkcs12 -export -in cert.cer -inkey cert.key -out cert.pfx
```

convert .pfx to p12

```
openssl pkcs12 -in example.pfx -nocerts -out example.key  
openssl pkcs12 -in example.pfx -clcerts -nokeys -out example.crt  
openssl pkcs12 -export -in example.crt -inkey example.key -certfile example.crt -name "examplecert" -out keystore.p12

```
