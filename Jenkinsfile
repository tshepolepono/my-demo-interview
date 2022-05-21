// Devsecops pipeline ok check
pipeline {
  agent any
  
  stages {
      stage('SAST SonarQube') {
            steps {
              sh "sonar-scanner -Dsonar.projectKey=ceros-ski -Dsonar.sources=. -Dsonar.host.url=http://devsecops-tshepo.northeurope.cloudapp.azure.com:9000 -Dsonar.login=d2884120432f60be427beac1b6d7a4e0a1637950"
            }
        }

}
}