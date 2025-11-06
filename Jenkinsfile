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
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    dir("${TF_DIR}") {
                        sh '''
                            terraform init
                            terraform apply -auto-approve \
                            -var "bucket_name=${BUCKET_NAME}" \
                            -var "aws_region=${AWS_REGION}"
                        '''
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
