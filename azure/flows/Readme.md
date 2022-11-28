## end-to-end-automation

**_important notes_**

If the variables from the common template were added, It should be a common purpose. It should be available to the entire organisation rather than just the project.

The variable name should have the **`environment`** name as a prefix, like **`DEV`**, **`QA`**, **`UAT`**, and **`DEMO`**. Don't use any other special characters or other words.

All variables in the environment should be **`capitalized`**. so that we can easily identify the variable calling location.

- The cloud resource variables are required as part of the **`AZURE`** keyword.

  - **`DEV_AZURE_ACR_CONNECTION`**
  - **`QA_AZURE_ACR_CONNECTION`**
  - **`UAT_AZURE_ACR_CONNECTION`**
  - **`DEMO_AZURE_ACR_CONNECTION`**

- The development variables are required as part of the **`APPS`** keyword.

  - **`DEV_APPS_MONGO_CONNECTION_STRING`**
  - **`QA_APPS_MONGO_CONNECTION_STRING`**
  - **`UAT_APPS_MONGO_CONNECTION_STRING`**
  - **`DEMO_APPS_MONGO_CONNECTION_STRING`**

- All the projects should follow the release process and security approaches. While developing, do not skip any security procedures. We don't have the option to skip. If we were to provide the following features: It may collide with our process flows.


```yml

stages:
  - stage: stages
    pool:
      vmImage: ubuntu-latest
    jobs:
      - job: dev
        steps:
          - bash: |
              echo "$(DATA)"
      - job: qa
        steps:
          - bash: |
              echo "$(DATA)"

```