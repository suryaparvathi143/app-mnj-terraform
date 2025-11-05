pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
        AWS_CREDENTIALS = credentials('aws-credentials')
        TF_DIR = './terraform'
    }

    stages {
        stage('Check Terraform') {
            steps {
                sh 'echo Current PATH: $PATH'
                sh 'terraform -version'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Apply Terraform changes?'
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
            echo '✅ Terraform pipeline completed successfully!'
        }
        failure {
            echo '❌ Terraform pipeline failed!'
        }
    }
}
