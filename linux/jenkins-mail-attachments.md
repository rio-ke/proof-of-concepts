#### Jenkins-mail-attachments.md
---

```Jenkinsfile
pipeline {
agent {label 'slave3'}
    stages {
        stage('environment details') {
            steps {
                echo bat(returnStdout: true, script: 'set')
            }
        }
        stage('test cases') {
            steps {
                echo bat(returnStdout: true, script: 'mvn test')
            }
        }
    }
    post {
        success {  
            emailext body: 'Check console output at $BUILD_URL to view the results.', 
                     to: 'krishna.raj@xxx.co,vignesh.muthiyapillai@xxxx.co,noor.mohammed@xxxx.co', 
                     subject: 'SUCCESS KUBERNETES DEPLOYMENT - $PROJECT_NAME - #$BUILD_NUMBER',
                     attachmentsPattern: 'target/surefire-reports/emailable-report.html'
        }
        failure {
            emailext body: 'Check console output at $BUILD_URL to view the results.', 
                     to: 'krishna.raj@xxx.co,vignesh.muthiyapillai@xxxx.co,noor.mohammed@xxxx.co', 
                     subject: 'SUCCESS KUBERNETES DEPLOYMENT - $PROJECT_NAME - #$BUILD_NUMBER',
                     attachmentsPattern: 'target/surefire-reports/emailable-report.html'
        }
    }
}

```
