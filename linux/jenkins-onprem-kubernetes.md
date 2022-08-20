#### Jenkins onprem kubernetes deployment

---

```jenkinsfile
pipeline {
    agent any 
    environment {
        REPOSITORY_NAME="fra.ocir.io"
        OCR_NAME="xxxxx-staging"
        IMAGE_NAME="xxx-api"
        NAMESPACE=credentials('ocr-xxxxx-staging-namespace')
        USERNAME=credentials('ocr-xxxxx-staging-username')
        PASSWORD=credentials('ocr-xxxxx-staging-password')
    }
    stages {
      stage('docker build') {   
        steps {
            sh'''
              docker build -t ${REPOSITORY_NAME}/${NAMESPACE}/${OCR_NAME}:${IMAGE_NAME}-${BUILD_ID} .
            '''
        }
      }
      stage('Docker image push') {   
        steps {
            sh'''
              RUNTIME_PASSWORD=${NAMESPACE}/${USERNAME}
              echo ${PASSWORD} | docker login ${REPOSITORY_NAME} --username  $RUNTIME_PASSWORD --password-stdin
              docker push ${REPOSITORY_NAME}/${NAMESPACE}/${OCR_NAME}:${IMAGE_NAME}-${BUILD_ID}
              docker logout ${REPOSITORY_NAME}
            '''
        }
      }
      stage('Delete last build docker image') {   
        steps {
            sh'''
              docker rmi ${REPOSITORY_NAME}/${NAMESPACE}/${OCR_NAME}:${IMAGE_NAME}-${BUILD_ID}
            '''
        }
      }
      stage('Deploy to GKE staging cluster') {
        steps {
            script {
                kubernetesDeploy(configs: "hellodocker.yml", kubeconfigId: "TISCOUT-STAGING")
            }
         }
      }   
   }
}


```
