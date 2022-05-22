// Devsecops pipeline ok check
pipeline {
  agent any

  stages {
      stage('Clone') {
            steps {
              git branch: 'main', url: 'https://github.com/tshepolepono/my-demo-interview.git'
            }
        }


  
  
      stage('SAST SonarQube') {
            steps {
              nodejs(nodeJSInstallationName: 'nodejs'){
                sh "pwd"
                sh "npm install"
              }
            }
        }
  
}
}