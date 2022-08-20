
```yml
---
name: provision the terraform resources
on: [push]
jobs:
  terraform:
    name: terraform
    strategy:
      matrix:
        folder: [aws-vpc-datasource]
    runs-on: ubuntu-latest
    defaults:
      run:
        shell: bash
        working-directory: ${{ matrix.folder }}
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

      - name: INIT
        run: terraform init

      - name: VALIDATION
        run: terraform validate

      - name: FORMAT
        run: terraform fmt

      - name: PLAN
        run: terraform  plan -var-file=config-prod.tfvars

      - name: APPLY
        run: terraform  apply -auto-approve -var-file=config-prod.tfvars

      - name: SHOW THE DETAILS
        run: terraform show

      # - name: DESTROY
      #   run: terraform  destroy -auto-approve -var-file=config-prod.tfvars
```
