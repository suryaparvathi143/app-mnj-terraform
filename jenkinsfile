pipeline {
    agent any

    environment {
        // AWS credentials ID configured in Jenkins
        AWS_CREDENTIALS = credentials('aws-credentials')
        // Your Terraform directory path in project
        TF_DIR = './terraform'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: 'https://github.com/suryaparvathi143/app-mnj-terraform.git'
            }
        }

        stage('Setup Terraform') {
            steps {
                echo 'Initializing Terraform...'
                dir("${TF_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Validate Terraform') {
            steps {
                echo 'Validating Terraform code...'
                dir("${TF_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Plan Infrastructure') {
            steps {
                echo 'Planning Terraform infrastructure changes...'
                dir("${TF_DIR}") {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Apply Infrastructure') {
            steps {
                input message: 'Apply Terraform changes? (Confirm manually)'
                echo 'Applying Terraform plan...'
                dir("${TF_DIR}") {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Terraform infrastructure applied successfully!'
        }
        failure {
            echo '❌ Terraform pipeline failed!'
        }
    }
}
