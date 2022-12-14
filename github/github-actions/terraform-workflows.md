```yml
name: provision the eks resources
on:
  workflow_dispatch:
    inputs:
      name:
        description: "target environment name"
        required: true
jobs:
  deploy_source:
    name: terraform deployment
    runs-on: ubuntu-latest
    env:
      bucket: terraform-backend-buckets-tfd
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
          aws-region: eu-central-1

      - name: terraform initial
        run: |
          terraform init \
            -backend-config="bucket=${{ env.bucket }}" \
            -backend-config="key=${{ github.event.inputs.name }}/tfstate.tfstate" \
            -backend-config="region=eu-central-1" \
            -backend=true
      - name: terraform plan
        run: terraform  plan -var-file=config.tfvars

      - name: terraform apply
        run: terraform  apply -var-file=config.tfvars -auto-approve
        
      - name: terraform destroy
        run: terraform  destroy -var-file=config.tfvars -auto-approve
```
