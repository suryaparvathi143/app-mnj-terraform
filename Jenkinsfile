pipeline {
    agent any

    environment {
        TF_DIR = './terraform'
        BUCKET_NAME = "app-s3-mnj-bucket"
        SQS_QUEUE_NAME = "app-sqs-mnj"
        AWS_REGION = "us-east-1"
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
    }

    stages {

        // Stage 1: Checkout Code
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

        // Stage 3: Check if S3 Bucket Exists
        stage('Check S3 Bucket') {
            steps {
                script {
                    echo "🔍 Checking if S3 bucket '${BUCKET_NAME}' already exists..."
                    def bucketExists = sh(
                        script: "aws s3api head-bucket --bucket ${BUCKET_NAME} --region ${AWS_REGION} 2>/dev/null || echo 'notfound'",
                        returnStdout: true
                    ).trim()

                    if (bucketExists == 'notfound') {
                        echo "🪣 Bucket does not exist. It will be created by Terraform."
                        env.CREATE_S3 = "true"
                    } else {
                        echo "✅ Bucket '${BUCKET_NAME}' already exists. Skipping creation."
                        env.CREATE_S3 = "false"
                    }
                }
            }
        }

        // Stage 4: Terraform Plan
        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    dir("${TF_DIR}") {
                        script {
                            def planCommand = """
                                terraform plan \
                                  -var "bucket_name=${BUCKET_NAME}" \
                                  -var "sqs_queue_name=${SQS_QUEUE_NAME}" \
                                  -var "aws_region=${AWS_REGION}" \
                                  -var "create_s3=${CREATE_S3}" \
                                  -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
                                  -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY"
                            """
                            sh planCommand
                        }
                    }
                }
            }
        }

        // Stage 5: Manual Approval
        stage('Approval for Apply') {
            steps {
                script {
                    def userInput = input(
                        message: "Do you want to proceed with applying Terraform changes?",
                        parameters: [
                            [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Check YES to proceed', name: 'PROCEED']
                        ]
                    )
                    if (!userInput) {
                        error("❌ Pipeline aborted by user.")
                    }
                }
            }
        }

        // Stage 6: Terraform Apply
        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    dir("${TF_DIR}") {
                        script {
                            def applyCommand = """
                                terraform apply -auto-approve \
                                  -var "bucket_name=${BUCKET_NAME}" \
                                  -var "sqs_queue_name=${SQS_QUEUE_NAME}" \
                                  -var "aws_region=${AWS_REGION}" \
                                  -var "create_s3=${CREATE_S3}" \
                                  -var "aws_access_key=$AWS_ACCESS_KEY_ID" \
                                  -var "aws_secret_key=$AWS_SECRET_ACCESS_KEY"
                            """
                            sh applyCommand
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Terraform apply completed successfully! S3 and SQS are configured."
        }
        failure {
            echo "❌ Terraform pipeline failed."
        }
    }
}
