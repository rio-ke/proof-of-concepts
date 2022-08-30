```yml
trigger:
- none

variables:
  acr_repo_name: common-api
  cc_app_name: common-api
  git_app_name: absweb-common-api

parameters:
- name: aksinstance
  displayName: "Aks Instance"
  type: string
  default: NPRD-Dev
  values:
  - PROD
  - NPRD-Test
  - NPRD-Dev
- name: environment
  displayName: "Environment"
  type: string
  default: dev
  values:
  - dev
  - prod
  - test
- name: phase
  displayName: Phase
  type: string
  default: refresh_cc_branch
  values:
  - build
  - deploy
  - build_deploy
  - refresh_cc_branch
  - veracode-scan
  - sonar-scan

- name: deploy_tag
  displayName: "Image Name (*mandatory for deploy phase)"
  type: string
  default: NA
  values: 
  - NA
# - StartTag
  - 20220829.10.56-main
  - 20220825.13.24-main
  - 20220817.14.00-main
  - 20220817.11.49-main
  - 20220809.15.04-main
  - 20220712.16.07-main
  - 20220706.14.40-main
  - 20220622.15.43-main
  - 20220621.17.37-main
  - 20220614.16.48-main
  - 20220609.10.33-main
  - 20220525.14.52-main
  - 20220525.14.31-main
  - 20220517.13.58-main
  - 20220516.18.08-main
 
# - EndTag

- name: cc_branch
  displayName: "Code Cloud Branch (*mandatory for build/build_deploy phase)"
  type: string
  default: NA
  values: 
  - NA
# - StartBranch
  - feature/PID402643_Common-Api
  - master
  - release/phase1
 
# - EndBranch



pool: 
  name: 32068-ABS_AZURE-DevOps-eastus2-AgentPool


stages:
  
  - ${{ if and(contains(parameters.phase, 'deploy'), not(eq(parameters.environment, 'prod'))) }} :
    - stage: deploymentvalidation 
      displayName: "InstanceValidation"
      jobs:
      - job: InstanceValidation
        steps:
        - checkout: self 
          condition: eq('1', '2')
        - script: | 
            if [ `echo ${{ parameters.aksinstance }} | cut -d "-" -f1` == "PROD" ]; then
              echo "Non Production Configs Cannot deploy into Prodction AKS Instance"
              exit 3
            fi
          displayName: "Validate Deployment Instance"
  
  - ${{ if and(contains(parameters.phase, 'build'),  eq(parameters.cc_branch, 'NA')) }} :
    - stage: validation_ccbranch 
      displayName: "CC Branch Validation"
      jobs:
      - job: Image_Tag
        steps:
        - script: | 
            echo "Code Cloud Branch cannot be NA with build phase"
            exit 3
          displayName: "Validate CC_Branch"   

  - ${{ if and(eq(parameters.phase, 'deploy'),  eq(parameters.deploy_tag, 'NA')) }} :
    - stage: validation_imgtag
      displayName: "ImageTag Validation"
      dependsOn: deploymentvalidation
      jobs:
      - job: Image_Tag
        steps:
        - script: | 
            echo "Image-Tag cannot be NA with build phase"
            exit 1
          displayName: "Validate Image-Tag"   
  
  - stage: checkout_build_push
      
    displayName: CheckoutBuildPush
    variables: 
        - template: /common-config/Environment/Variables.${{ parameters.aksinstance }}.yaml
  
    jobs: 
        - job: build 
          workspace: 
            clean:  all # what to clean up before the job runs 
          steps: 
            - checkout: self 
              condition: and(eq('${{ parameters.environment }}', 'dev'),  contains( '${{ parameters.phase }}', 'build'))
              displayName: "Checkout ADO Repo Code"
            - script: | 
                BUILD_DATE=`date '+%Y%m%d.%H.%M'`
                BRANCH=`echo $(Build.SourceBranch) | rev | cut -d "/" -f1 | rev`
                IMAGE_TAG="$BUILD_DATE-$BRANCH"
                echo "##vso[task.setvariable variable=IMAGE_TAG]$IMAGE_TAG"
                echo "##vso[task.setvariable variable=img_tg;isOutput=true]${IMAGE_TAG}"

              displayName: "buildvariable - ImageTag"
              condition: and(eq('${{ parameters.environment }}', 'dev'),  contains( '${{ parameters.phase }}', 'build'))
              name: "buildvariables"

            - task: AzureKeyVault@2
              condition: and(eq('${{ parameters.environment }}', 'dev'),  contains( '${{ parameters.phase }}', 'build'))
              inputs:
                azureSubscription: '${{ variables.service_connection_app }}'
                KeyVaultName: 'abseastus2${{ parameters.environment }}01kv01'
                SecretsFilter: '*'
                RunAsPreJob: true
              displayName: 'Retrieve Azure Keyvault Secrets'
            - task: CmdLine@2
              displayName: 'Checkout CC Code'
              condition: and(eq('${{ parameters.environment }}', 'dev'),  contains( '${{ parameters.phase }}', 'build'))
              inputs:
                script: |
                  encoded_PAT_value=$(python3 -c "import urllib.parse; print(str(urllib.parse.quote_plus('$(codecloud-token)')))")
                  git clone -b ${{ parameters.cc_branch }} https://$(codecloud-username):$encoded_PAT_value@codecloud.web.xxx.com/scm/st_absweb/${{ variables.cc_app_name }}.git --depth=1
                  cp -r ./${{ variables.cc_app_name }}/* ./${{ variables.git_app_name }}
            - task: Docker@2 
              displayName: "Docker Build and Push" 
              condition: and(eq('${{ parameters.environment }}', 'dev'),  contains( '${{ parameters.phase }}', 'build'))
              inputs: 
                containerRegistry: '${{ variables.AcrConnection }}' 
                repository: '${{ variables.acr_repo_name }}' 
                command: 'buildAndPush' 
                Dockerfile: '$(System.DefaultWorkingDirectory)/${{ variables.git_app_name }}/Dockerfile'
                tags: '$(IMAGE_TAG)'

  - ${{ if eq(parameters.phase, 'refresh_cc_branch') }} :
    - stage: refresh_ccbranch_list
      displayName: RefreshCCBranches 
      variables: 
          - template: /common-config/Environment/Variables.${{ parameters.aksinstance }}.yaml
      
      jobs:
        - template: /common-config/Deploy/RefreshCCBranches.yaml
          parameters:
            service_connection_app: ${{ variables.service_connection_app }}
            cc_app_name: ${{ variables.cc_app_name }}
            environment: ${{ parameters.environment }}
            git_app_name: ${{ variables.git_app_name }} 

  - stage: Veracode_Scan
    displayName: "Veracode scan"
    dependsOn: checkout_build_push
    condition: and (succeeded(), contains('${{ parameters.phase }}', 'veracode-scan'))
    variables: 
      - template: /common-config/Environment/Variables.${{ parameters.aksinstance }}.yaml
    jobs:
      - template: /common-config/Deploy/VeracodeScan.yaml
        parameters:
          service_connection_app: ${{ variables.service_connection_app }}
          cc_app_name: ${{ variables.cc_app_name }}
          environment: ${{ parameters.environment }}
          git_app_name: ${{ variables.git_app_name }}
          phase : ${{ parameters.phase }}
          acr_repo_name: ${{ variables.acr_repo_name }}
          cc_branch: ${{ parameters.cc_branch }} 
          AcrConnection: 32068-ABS-AZURE-ACR-ServiceConnection
          AcrFqdn: 32068devopsacr.azurecr.io   

  - stage: Sonar_Scan
    displayName: "Sonar scan"
    dependsOn: checkout_build_push
    condition: and (succeeded(), contains('${{ parameters.phase }}', 'sonar-scan'))
    variables: 
      - template: /common-config/Environment/Variables.${{ parameters.aksinstance }}.yaml
    jobs:
      - template: /common-config/Deploy/SonarScan.yaml
        parameters:
          service_connection_app: ${{ variables.service_connection_app }}
          cc_app_name: ${{ variables.cc_app_name }}
          environment: ${{ parameters.environment }}
          git_app_name: ${{ variables.git_app_name }}
          phase : ${{ parameters.phase }}
          acr_repo_name: ${{ variables.acr_repo_name }}
          cc_branch: ${{ parameters.cc_branch }} 
          AcrConnection: 32068-ABS-AZURE-ACR-ServiceConnection
          AcrFqdn: 32068devopsacr.azurecr.io 
  
  - stage: buildvariables
    displayName: BuildVariables
    dependsOn: checkout_build_push
    condition: and (succeeded(), contains('${{ parameters.phase }}', 'deploy'))
    variables:
      build_img_tg: $[ stageDependencies.checkout_build_push.build.outputs['buildvariables.img_tg']]
      deploy_img_tg: ${{ parameters.deploy_tag }}
    jobs:
    - job: BuildVariables
      steps:
      - checkout: self 
        condition: eq('1', '2')
      - script: |
          if [[ ( ! -z "$(build_img_tg)" ) ]]; then
            image_tg=$(build_img_tg)
          elif [[ ( -z "$(build_img_tg)"  && "$(deploy_img_tg)" != "NA" ) ]]; then
            image_tg=$(deploy_img_tg)
          elif [[ ( -z "$(build_img_tg)"  && "$(deploy_img_tg)" == "NA" ) ]]; then
            echo "Invalid Image-Tag"
            exit 2
          else
            echo "Error"
            exit 3
          fi
          echo "##vso[task.setvariable variable=deploy_img_tg;isOutput=true]${image_tg}"
        displayName: "BuildVariables"
        name: "buildvariables"
  - stage: deploy
    displayName: Deploy
    dependsOn: BuildVariables
    condition: and (succeeded(), contains('${{ parameters.phase }}', 'deploy'))
    variables:
      - template: /common-config/Environment/Variables.${{ parameters.aksinstance }}.yaml
      - name: deploy_img_tg
        value: $[ stageDependencies.BuildVariables.BuildVariables.outputs['buildvariables.deploy_img_tg']]
    jobs:
      - template: /common-config/Deploy/HelmDeployment.yaml
        parameters:
          service_connection_app: ${{ variables.service_connection_app }}
          environment: ${{ parameters.environment }}
          aks_resource_group: ${{ variables.aks_resource_group }}
          aks_name: ${{ variables.aks_name }}
          client: com-xxx-absweb-${{ parameters.environment }}
          image_tag: $(deploy_img_tg)
          acr_repo_name: ${{ variables.acr_repo_name }}
          git_app_name: ${{ variables.git_app_name }}

  - stage: refresh_acrimage_list
    dependsOn: deploy
    condition: contains('${{ parameters.phase }}', 'build')
    displayName: RefreshACRImageTags 
    variables: 
        - template: /common-config/Environment/Variables.${{ parameters.aksinstance }}.yaml
    
    jobs:
      - template: /common-config/Deploy/RefreshACRRepoList.yaml
        parameters:
          service_connection_app: ${{ variables.service_connection_app }}
          acr_repo_name: ${{ variables.acr_repo_name }}
          git_app_name: ${{ variables.git_app_name }}
```
