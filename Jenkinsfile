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
      
    stage('Vulnerability Image Scan - Docker') {
      steps {
         parallel(
        //   "Dependency Scan": {
        //     sh "mvn dependency-check:check"
        //   },
          "Trivy Scan": {
            sh "bash docker-image-scan.sh"
          },
          "OPA Conftest - Dockerfile": {
          sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego ./app/Dockerfile'
         }
         )
      }
    }
    stage('Scan Terraform Code') {
      agent {
        docker { 
          image 'tfsec/tfsec-ci:v1.20.0' 
          reuseNode true
        }
      }
      steps {
        sh '''
          tfsec . --no-color
        '''
      }
    }
}

}
