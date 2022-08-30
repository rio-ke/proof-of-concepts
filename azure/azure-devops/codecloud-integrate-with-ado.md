```yml
trigger:
  - none

variables:


parameters:
  - name: cc_branch
    displayName: "Code Cloud Branch (*mandatory for build/build_deploy phase)"
    type: string
    default: NA
    values:
      - NA
      - master

pool:
  name: 30973-

stages:
  - stage: checkout_build_push
    displayName: CheckoutBuildPush
    # variables:
    #   - template: /common-config/Environment/Variables.${{ parameters.aksinstance }}.yaml
    jobs:
      - job: build
        workspace:
          clean: all # what to clean up before the job runs
        steps:
          - checkout: self
            displayName: "Checkout ADO Repo Code"

          # - task: AzureKeyVault@2
          #   condition: and(eq('${{ parameters.environment }}', 'dev'),  contains( '${{ parameters.phase }}', 'build'))
          #   inputs:
          #     azureSubscription: "${{ variables.service_connection_app }}"
          #     KeyVaultName: "abseastus2${{ parameters.environment }}01kv01"
          #     SecretsFilter: "*"
          #     RunAsPreJob: true
          #   displayName: "Retrieve Azure Keyvault Secrets"

          - task: CmdLine@2
            displayName: "Checkout Cc Code"
            inputs:
              script: |
                # encoded_PAT_value=$(python3 -c "import urllib.parse; print(str(urllib.parse.quote_plus('$(cc-token)')))")
                git clone -b ${{ parameters.cc_branch }} https://$(cc-username):$(encoded_PAT_value)@cc.web.at.com/scm/st_iris/$(cc_app_name).git --depth=1
                cp -r ./$(cc_app_name)/* ./$(git_app_name)

          - task: Docker@2
            displayName: "Docker Build and Push"
            inputs:
              containerRegistry: $(AcrServiceConnection)
              repository: $(acr_repo_name)
              command: "buildAndPush"
              Dockerfile: $(System.DefaultWorkingDirectory)/$(git_app_name)/Dockerfile
              tags: $(tag)
```
