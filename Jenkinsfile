pipeline {
    
   agent {
       label 'ubuntucompose'}

tools {
  maven 'Maven3'}
  
environment {
  IMAGE = readMavenPom().getArtifactId()
  VERSION = readMavenPom().getVersion()
  KONTENER = "pandaapp"}
    
    stages {
        
        stage('Clear running apps'){
            steps{
                sh "docker rm -f ${KONTENER} || true"
            }
        }
    
        stage('Get Code'){
            steps{
                git branch: 'selenium_grid', url: 'https://github.com/mwocka/panda_application.git '
            }
        }
        
        stage('Build and Junit'){
            steps{
                sh 'mvn clean install'
            }
        }
        stage('Build Docker image'){
            steps{
                sh 'mvn package -Pdocker'
            }
        }
        stage('Run Docker app'){
            steps{
                sh "docker run -d -p 0.0.0.0:8080:8080 --name ${KONTENER} ${IMAGE}:${VERSION}"
            }
        }
        stage('Test Selenium'){
            steps{
                sh "mvn -Pselenium test"
            }
        }
        stage('Deploy jar to artifactory'){
            steps{
                configFileProvider([configFile(fileId: '73f1706b-c17d-4fa7-85f0-335f06c96d48', variable: 'mavensettings')])
                {  sh "mvn -s $mavensettings deploy"
            }
        }
        }
    }
post {
    always {
        sh "docker stop ${KONTENER}"
         }
    }
}
