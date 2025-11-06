pipeline {
    agent any

    environment {
        TF_DIR = './terraform'
        BUCKET_NAME = "jenkins-bucket-${BUILD_NUMBER}"
        AWS_REGION = "us-east-1"
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
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
        success {
            echo "✅ Bucket created successfully in AWS!"
        }
        failure {
            echo "❌ Terraform apply failed!"
        }
    }
}
