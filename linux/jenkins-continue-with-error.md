#### Jenkins-continue-with-error.md
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
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE')
                {
                    echo bat(returnStdout: true, script: 'mvn test')
                }
            }
        }
    }
    post {

        success {  
            emailext body: 'Check console output at $BUILD_URL to view the results.', 
                     to: 'krishna.raj@tisteps.co,vignesh.muthiyapillai@tisteps.co,noor.mohammed@tisteps.co', 
                     subject: 'SUCCESS KUBERNETES DEPLOYMENT - $PROJECT_NAME - #$BUILD_NUMBER',
                     attachmentsPattern: 'target/surefire-reports/emailable-report.html'
        }
        failure {
            emailext body: 'Check console output at $BUILD_URL to view the results.', 
                     to: 'krishna.raj@tisteps.co,vignesh.muthiyapillai@tisteps.co,noor.mohammed@tisteps.co', 
                     subject: 'SUCCESS KUBERNETES DEPLOYMENT - $PROJECT_NAME - #$BUILD_NUMBER',
                     attachmentsPattern: 'target/surefire-reports/emailable-report.html'
        }
        always {
            cleanWs()
        }
    }
}

```
