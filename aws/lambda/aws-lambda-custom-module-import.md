


```bash
   79  mkdir my-sourcecode-function
   80  cd my-sourcecode-function
   82  vim  lambda_function.py
   85  pip install --target ./package requests
   86  apt install python3-pip
   87  pip install --target ./package requests
   91  ls -la package/
   92  cd package
   94  apt install zip
   95  zip -r ../my-deployment-package.zip .
   98  cd ..
  100  zip -g my-deployment-package.zip lambda_function.py
```
