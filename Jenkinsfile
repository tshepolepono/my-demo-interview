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
  stage('Download packages') {
            steps {
              nodejs(nodeJSInstallationName: 'nodejs'){
            
                sh "npm install app"
                //sh "npm audit fix app"
              }
            }
        }
      
      stage('nodejsscan - SAST') {
           steps {
          //   // script{ 
          //    //def scannerHome = tool name: 'sonar_scanner';
          //   // withSonarQubeEnv('SonarQube') {
          //       //nodejs(nodeJSInstallationName: 'nodejs'){
          //         //sh "/home/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/sonar-scanner/bin/sonar-scanner -Dsonar.projectKey=ceros-ski -Dsonar.sources=app -Dsonar.host.url=http://devsecops-tshepo.northeurope.cloudapp.azure.com:9000"
          //     }
          //  }
          //   // }
          //   timeout(time: 2, unit: 'MINUTES') {
          //  script {
          //    waitForQualityGate abortPipeline: true
          //   }
          //  }
             sh "nodejsscan -d app --output /{JENKINS HOME DIRECTORY}/reports/nodejsscan-report"
         }
       }
  
}
}