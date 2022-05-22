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
                withSonarQubeEnv('SonarQube') {
                nodejs(nodeJSInstallationName: 'nodejs'){
                  sh "npm install sonar-scanner"
                  sh "npm run sonar-scanner app"
                  //sh "${scannerHome}/bin/sonar-scanne -Dsonar.projectKey=ceros-ski -Dsonar.sources=app -Dsonar.host.url=http://devsecops-tshepo.northeurope.cloudapp.azure.com:9000"
              }
           }
                //sh "npm audit fix app"
              }
            }
        }
      
      // stage('SonarQube SAST') {
      //      steps {
      //        withSonarQubeEnv('SonarQube') {
      //           nodejs(nodeJSInstallationName: 'nodejs'){
      //             sh "npm install sonar-scanner"
      //             sh "npm run sonar-scanner app"
      //             //sh "${scannerHome}/bin/sonar-scanne -Dsonar.projectKey=ceros-ski -Dsonar.sources=app -Dsonar.host.url=http://devsecops-tshepo.northeurope.cloudapp.azure.com:9000"
      //         }
      //      }
      //       timeout(time: 2, unit: 'MINUTES') {
      //      script {
      //        waitForQualityGate abortPipeline: true
      //       }
      //      }
      //    }
      //  }
  
}
}