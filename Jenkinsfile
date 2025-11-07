pipeline {
    agent any

    environment {
        TF_DIR = './terraform'
        BUCKET_NAME = "app-s3-mnj"
        AWS_REGION = "us-east-1"
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
    }

    stages {
        // Stage 1: Checkout code
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/suryaparvathi143/app-mnj-terraform.git'
            }
        }

        // Stage 2: Terraform Init
        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init -upgrade'
                }
            }
        }

        // Stage 3: Terraform Plan
        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    dir("${TF_DIR}") {
                        sh '''
                            terraform plan \
                              -var "bucket_name=${BUCKET_NAME}" \
                              -var "aws_region=${AWS_REGION}" \
                              -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
                              -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY"
                        '''
                    }
                }
            }
        }

        // Stage 4: Manual Approval (Tollgate)
        stage('Approve S3 Bucket Creation') {
            steps {
                script {
                    def userInput = input(
                        message: "Do you want to proceed with creating the S3 bucket?",
                        parameters: [
                            [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Check YES to create bucket', name: 'PROCEED']
                        ]
                    )
                    if (!userInput) {
                        error("❌ Pipeline aborted by user.")
                    }
                }
            }
        }

        // Stage 5: Terraform Apply
        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    dir("${TF_DIR}") {
                        sh '''
                            terraform apply -auto-approve \
                              -var "bucket_name=${BUCKET_NAME}" \
                              -var "aws_region=${AWS_REGION}" \
                              -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
                              -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY"
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Terraform completed successfully!"
        }
        failure {
            echo "❌ Terraform pipeline failed!"
        }
    }
}
