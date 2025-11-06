pipeline {
    agent any

    environment {
        TF_DIR = './terraform'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: 'https://github.com/suryaparvathi143/app-mnj-terraform.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                    dir("${TF_DIR}") {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve -var bucket_name=jenkins-bucket-20 -var aws_region=us-east-1'
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ S3 bucket created successfully!'
        }
        failure {
            echo '❌ Terraform apply failed!'
        }
    }
}
