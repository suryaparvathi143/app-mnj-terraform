pipeline {
    agent any

    environment {
        TF_DIR = './terraform'
        BUCKET_NAME = "jenkins-bucket-${BUILD_NUMBER}"
        AWS_REGION = "us-east-1"
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
    }

stage('Terraform Apply') {
    steps {
        withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-creds'
        ]]) {
            dir("${TF_DIR}") {
                sh """
                    terraform init -upgrade
                    terraform apply -auto-approve \
                      -var "bucket_name=${BUCKET_NAME}" \
                      -var "aws_region=${AWS_REGION}" \
                      -var "aws_access_key=${AWS_ACCESS_KEY_ID}" \
                      -var "aws_secret_key=${AWS_SECRET_ACCESS_KEY}"
                """
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
