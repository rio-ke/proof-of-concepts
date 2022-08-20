#### aws-eks-jenkins-pipeline.md

```Jenkinsfile

pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
        REGION = credentials('REGION')
        PROD_ECR_REPO = credentials('PROD_ECR_REPO')
        PROD_ECR_REPO_URL = credentials('PROD_ECR_REPO_URL')
        PROD_EKS_CLUTER_NAME = credentials('PROD_EKS_CLUTER_NAME')
        IMAGE_NAME = "api-${BUILD_ID}"
        PROD_NS = credentials('PROD_NSS')
        EMAIL_INFORM = 'xxxx.raj@xxxxx.co;'
    }
    stages {
        stage('api docker build') {
        steps {
            sh '''
                echo "Docker build api "
                export IMAGE_NAME=api-$(git rev-parse --short HEAD)
                docker build -t $PROD_ECR_REPO:${IMAGE_NAME} -f Dockerfile .
                echo $IMAGE_NAME
                '''
            }
        }
        stage('api docker image push') {
            steps {
                sh '''
                    aws configure set region $REGION
                    export IMAGE_NAME=api-$(git rev-parse --short HEAD)
                    $(aws ecr get-login --region $REGION --no-include-email)
                    docker push $PROD_ECR_REPO:$IMAGE_NAME
                    docker logout $PROD_ECR_REPO_URL
                    docker rmi $PROD_ECR_REPO:$IMAGE_NAME
                    echo "completed"
                    '''
            }
        }
        stage('api docker image deployment') {
            steps {
                sh '''
                    echo "Deploying to Production Environment...."
                    export IMAGE_NAME=api-$(git rev-parse --short HEAD)
                    export imageNameandversion=$PROD_ECR_REPO:$IMAGE_NAME
                    sed -i "s|containerImageName|$imageNameandversion|" kube-deploy/api-server.yml
                    sed -i "s|containerImageName|$imageNameandversion|" kube-deploy/worker.yml
                    rm -rf /root/.kube/
                    aws eks --region $REGION update-kubeconfig --name $PROD_EKS_CLUTER_NAME
                    /usr/local/bin/kubectl apply -f kube-deploy/ -n ${PROD_NS}
                    unset imageNameandversion
                    unset IMAGE_NAME
                '''
            }
        }
    }    
    post {
        success {  
            emailext body: 'Check console output at $BUILD_URL to view the results.', 
                    to: "${EMAIL_INFORM}", 
                    subject: 'SUCCESS KUBERNETES DEPLOYMENT - $PROJECT_NAME - #$BUILD_NUMBER'
        }
        failure {
            emailext body: 'Check console output at $BUILD_URL to view the results.', 
                    to: "${EMAIL_INFORM}", 
                    subject: 'FAILURE KUBERNETES DEPLOYMENT - $PROJECT_NAME - #$BUILD_NUMBER'
        }
    }
}

```
