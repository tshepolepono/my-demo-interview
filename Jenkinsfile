// Devsecops pipeline ok check
pipeline {
  agent any

  stages {
      // stage('Clone') {
      //       steps {
      //         git branch: 'main', url: 'https://github.com/tshepolepono/my-demo-interview.git'
      //       }
      //   }


  
  //check pwd
      stage('Download packages') {
            steps {
              nodejs(nodeJSInstallationName: 'nodejs'){
            
                sh "npm install app"
                //sh "npm audit fix app"
              }
            }
        }
      stage('SAST SonarQube') {
            steps {
              nodejs(nodeJSInstallationName: 'nodejs'){
               sh "sonar-scanner -Dsonar.projectKey=ceros-ski -Dsonar.sources=app -Dsonar.host.url=http://devsecops-tshepo.northeurope.cloudapp.azure.com:9000  -Dsonar.login=d2884120432f60be427beac1b6d7a4e0a1637950"
              }
            }
        }
  
}
}