
convert .p7b to .pfx

```
openssl pkcs7 -print_certs -in cert.p7b -out cert.cer
openssl pkcs12 -export -in cert.cer -inkey cert.key -out cert.pfx
```
