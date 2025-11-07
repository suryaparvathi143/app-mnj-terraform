pipeline {
    agent any

    environment {
        TF_DIR = './terraform'
        BUCKET_NAME = "app-s3-mnj-bucket"
        SQS_QUEUE_NAME = "app-sqs-mnj-sqs"
        AWS_REGION = "us-east-1"
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
    }

    stages {

        // --- Stage 1: Checkout Code ---
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/suryaparvathi143/app-mnj-terraform.git'
            }
        }

        // --- Stage 2: Terraform Init ---
        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init -upgrade'
                }
            }
        }

        // --- Stage 3: Check if S3 Bucket Exists ---
        stage('Check S3 Bucket') {
            steps {
                script {
                    echo "🔍 Checking if S3 bucket '${BUCKET_NAME}' exists..."
                    def bucketExists = sh(
                        script: "aws s3api head-bucket --bucket ${BUCKET_NAME} --region ${AWS_REGION} 2>/dev/null || echo 'notfound'",
                        returnStdout: true
                    ).trim()

                    if (bucketExists == 'notfound') {
                        echo "🪣 Bucket does not exist. It will be created."
                        env.CREATE_S3 = "true"
                    } else {
                        echo "✅ Bucket '${BUCKET_NAME}' already exists."
                        env.CREATE_S3 = "false"
                    }
                }
            }
        }

        // --- Stage 4: Terraform Plan & Apply for S3 ---
        stage('Terraform Apply - S3') {
            when { expression { env.CREATE_S3 == "true" } }
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    dir("${TF_DIR}") {

                        // Terraform Plan
                        sh """
                        terraform plan \
                          -var bucket_name=${BUCKET_NAME} \
                          -var create_s3=true \
                          -var aws_region=${AWS_REGION} \
                          -var aws_access_key=\$AWS_ACCESS_KEY_ID \
                          -var aws_secret_key=\$AWS_SECRET_ACCESS_KEY
                        """

                        // Approval
                        script {
                            def proceed = input(
                                message: "Do you want to proceed with creating the S3 bucket?",
                                parameters: [[
                                    $class: 'BooleanParameterDefinition',
                                    defaultValue: false,
                                    description: 'Check YES to create S3 bucket',
                                    name: 'PROCEED'
                                ]]
                            )
                            if (!proceed) {
                                error("❌ Pipeline aborted by user.")
                            }
                        }

                        // Terraform Apply
                        sh """
                        terraform apply -auto-approve \
                          -var bucket_name=${BUCKET_NAME} \
                          -var create_s3=true \
                          -var aws_region=${AWS_REGION} \
                          -var aws_access_key=\$AWS_ACCESS_KEY_ID \
                          -var aws_secret_key=\$AWS_SECRET_ACCESS_KEY
                        """
                    }
                }
            }
        }

        // --- Stage 5: Terraform Plan & Apply for SQS ---
        stage('Terraform Apply - SQS') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    dir("${TF_DIR}") {

                        // Terraform Plan
                        sh """
                        terraform plan \
                          -var sqs_queue_name=${SQS_QUEUE_NAME} \
                          -var create_sqs=true \
                          -var aws_region=${AWS_REGION} \
                          -var aws_access_key=\$AWS_ACCESS_KEY_ID \
                          -var aws_secret_key=\$AWS_SECRET_ACCESS_KEY
                        """

                        // Approval
                        script {
                            def proceed = input(
                                message: "Do you want to proceed with creating the SQS queue?",
                                parameters: [[
                                    $class: 'BooleanParameterDefinition',
                                    defaultValue: false,
                                    description: 'Check YES to create SQS queue',
                                    name: 'PROCEED'
                                ]]
                            )
                            if (!proceed) {
                                error("❌ Pipeline aborted by user.")
                            }
                        }

                        // Terraform Apply
                        sh """
                        terraform apply -auto-approve \
                          -var sqs_queue_name=${SQS_QUEUE_NAME} \
                          -var create_sqs=true \
                          -var aws_region=${AWS_REGION} \
                          -var aws_access_key=\$AWS_ACCESS_KEY_ID \
                          -var aws_secret_key=\$AWS_SECRET_ACCESS_KEY
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Terraform pipeline completed successfully! S3 and SQS setup finished."
        }
        failure {
            echo "❌ Terraform pipeline failed!"
        }
    }
}
