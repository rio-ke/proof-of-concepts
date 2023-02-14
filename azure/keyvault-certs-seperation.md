

```bash
openssl pkcs12 -in main.pfx -clcerts -nokeys -out main.crt

openssl pkcs12 -in main.pfx -nocerts -out en.key
# Enter Import Password: press enter
# Enter PEM pass phrase: Password@123
# Verifying - Enter PEM pass phrase: Password@123
openssl rsa -in en.key -out de.key
```
