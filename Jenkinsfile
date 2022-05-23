/*******************************************************************************
*  devsecops  pipeline
*
* The below docker images uses different security tools to scan for known issues in 
*code
* Software Composition Analysis using Synk tool
* Static Application Security Analysis using nodejsscan
* Container Security: Scan base image for known vulnerabilities
* IaC Dockefile scan: using OPA Confest
* IaC terraform: Using tfsec tool
* *****************************************************************************/

pipeline {
  agent any
  
  stages {
     
        stage('Download packages') {
            steps {
              nodejs(nodeJSInstallationName: 'nodejs'){
            
                sh "npm install app"
              }
            }
        }
       stage('SCA - Synk') {
            steps {
               snykSecurity severity: 'high', snykInstallation: 'synk', snykTokenId: 'demo-synk-token', targetFile: 'package.json'
              }
            }
        
      stage('SAST - nodejsscan') {
           steps {
             sh "nodejsscan -d app" 
         }
       }
      
      stage('Vulnerability Image Scan - Docker') {
           steps {
             sh "bash docker-image-scan.sh"
      
         }
       }
    stage('IaaC - Dockerfile') {
           steps {
              sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego ./app/Dockerfile'
              
         }
       }
    stage('DAST -OWASP ZAP') {
      steps {
       
          sh 'docker run -t owasp/zap2docker-stable zap-api-scan.py -t http://ceros-ski-production-ecs-1051832142.us-east-1.elb.amazonaws.com/ -f openapi -c zap_rules'
        
      }
    }
    stage('IaaC- Terraform Scan') {
      agent {
        docker { 
          image 'tfsec/tfsec-ci:v0.57.1' 
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
