```yml
name: terraform
on: [push]
jobs:
  init:
    name: init
    runs-on: ubuntu-latest
    steps:
      - name: checkout
        uses: actions/checkout@v1      
      - name: setup terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: 0.14.6
      - name: configure aws credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.ACCESS_KEY }}
          aws-secret-access-key: ${{ secrets.SECRET_KEY }}
          aws-region: us-east-1
      - name: terraform initiation
        run: terraform init
      - uses: actions/upload-artifact@v2
        with:
          name: terraform-artifact
          path: .
  validation:
    name: validate
    needs:
    - init
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v2
        with:
          name: terraform-artifact
      - name: upload-artifact-verify
        run: ls -la
      - name: terraform
        run: terraform --version
      - name: terraform 
        run: terraform plan -var-file=config-prod.tfvars
```
