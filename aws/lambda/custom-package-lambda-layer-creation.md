

```bash
mkdir packaging
cd packaging
mkdir python
cd python/
pip3 install requests -t .
cd ..
zip -r lambda_layer.zip python
```
