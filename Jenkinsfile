pipeline {
    
   agent {
       label 'ubuntucompose'}

tools {
  terraform 'Terraform'
  maven 'Maven3'}
  
environment {
  IMAGE = readMavenPom().getArtifactId()
  VERSION = readMavenPom().getVersion()
  KONTENER = "pandaapp"
  ANSIBLE = tool name: 'Ansible', type:
            'com.cloudbees.jenkins.plugins.customtools.CustomTool'}
    
    stages {
        
        stage('Clear running apps'){
            steps{
                sh "docker rm -f ${KONTENER} || true"
            }
        }
    
        stage('Get Code'){
            steps{
                git branch: 'main', url: 'https://github.com/gregwpr/pandaenv.git '
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
        //stage('Test Selenium'){
        //    steps{
        //        sh "mvn -Pselenium test"
        //    }
        //}
        stage('Deploy jar to artifactory'){
            steps{
                configFileProvider([configFile(fileId: '73f1706b-c17d-4fa7-85f0-335f06c96d48', variable: 'mavensettings')])
                {  sh "mvn -s $mavensettings deploy"
            }
        }
        }
        stage('Test installation') {
                steps { sh 'terraform --version' 
                sh 'ansible --version'
                } 
            }
            
       //  stage('Check AWS Env') {
       //         steps {
       //             script {
       //                  def test
       //                  withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
       //                 test="${AWS_ACCESS_KEY_ID}"
       //         
       //                   }
       //                  sh "echo $test"
       //                }
       //	}
       //}
	    stage('Run terraform') {
            steps {
                dir('infrastructure/terraform') { 
			withCredentials([file(credentialsId: 'panda_kurs', variable: 'terraformpanda')]) {
			sh "cp \$terraformpanda ../panda_kurs.pem"
			sh "pwd"
                	} 
			withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
			sh 'terraform init && terraform apply -auto-approve -var-file panda.tfvars'
            		}
        	}
	    }
    	}
        stage('Copy Ansible role') {
            steps {
                // sh 'sleep '
                sh 'cp -r infrastructure/ansible/panda/ /etc/ansible/roles/'
		sh 'ls /etc/ansible/roles/'
            }
        }
        stage('Run Ansible') {
            steps {
                dir('infrastructure/ansible') { 
                    sh 'chmod 600 ../panda_kurs.pem'
                    sh 'ansible-playbook - iybook.yml ./inventory --extra-vars ansible_python_interpreter=/usr/bin/python3'
//                  sh 'ansible-playbook -i ./inventory playbook.yml'
                	} 
            	}	
        }	
	}
//post {
//    always {
//        sh "docker stop ${KONTENER}"
//        }
//    }
}
