// Devsecops pipeline ok check
pipeline {
  agent any

  stages {
      stage('Clone') {
            steps {
              git branch: 'main', url: 'https://github.com/tshepolepono/my-demo-interview.git'
            }
        }


  
  //check pwd
      stage('SAST SonarQube') {
            steps {
              nodejs(nodeJSInstallationName: 'nodejs'){
                sh "cd app"
                sh "npm install"
              }
            }
        }
  
}
}