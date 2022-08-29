


```bash
  mkdir my-sourcecode-function
  cd my-sourcecode-function
  vim  lambda_function.py
  sudo apt install python3-pip
  pip install --target ./package requests
  ls -la package/
  cd package
  sudo apt install zip
  zip -r ../my-deployment-package.zip .
  cd ..
  zip -g my-deployment-package.zip lambda_function.py
```


final packages reference

https://github.com/operation-unknown/proof-of-concepts/blob/main/aws/lambda/lambda-requests.zip
