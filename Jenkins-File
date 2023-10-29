pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your GitHub repository
                <SCRIPT-FROM-Pipeline Syntax>
            }
        }
        
        stage ('init') {
            steps {
                sh ('terraform init -reconfigure')
            }
        }
        
        stage ('plan') {
            steps {
                sh ('terraform plan')
            }
        }
        
        stage ("terraform Action") {
            steps {
                sh ('terraform ${action} --auto-approve') 
           }
        }
    }
}
