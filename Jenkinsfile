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
       stage('SCA - Synk') {
            steps {
               snykSecurity severity: 'high', snykInstallation: 'synk', snykTokenId: 'demo-synk-token', targetFile: 'package.json'
              }
            }
        
     
      stage('nodejsscan - SAST') {
           steps {
             sh "nodejsscan -d app" 
         }
       }
  
}
}