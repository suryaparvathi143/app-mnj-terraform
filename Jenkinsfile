pipeline {
    agent any

    environment {
        TF_DIR = './terraform'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/suryaparvathi143/app-mnj-terraform.git'
            }
        }

        stage('Terraform Apply') {
            steps {
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                    dir("${TF_DIR}") {
                        sh 'terraform init -upgrade'
                        sh 'terraform apply -auto-approve -var bucket_name=jenkins-bucket-25 -var aws_region=us-east-1'
                    }
                }
            }
        }
    }

    post {
        failure {
            echo "❌ Terraform apply failed!"
        }
    }
}
