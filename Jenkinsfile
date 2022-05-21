// Devsecops pipeline ok check
pipeline {
  agent any

  stages {
      stage('Clone') {
            steps {
              git branch: 'main', url: 'https://github.com/tshepolepono/my-demo-interview.git'
            }
        }


  
  stages {
      stage('SAST SonarQube') {
            steps {
              nodejs(nodeJSInstallation: 'nodejs'){
                sh "nmp install"
              }
            }
        }
  }
}
}