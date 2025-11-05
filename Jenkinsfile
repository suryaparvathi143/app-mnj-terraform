pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
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
            withCredentials([
                string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
            ]) {
                sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform plan -out=tfplan
                '''
            }
        }
    }
}

stage('Apply Infrastructure') {
    steps {
        input message: 'Apply Terraform changes? (Confirm manually)'
        echo 'Applying Terraform plan...'
        dir("${TF_DIR}") {
            withCredentials([
                string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
            ]) {
                sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                    terraform apply -auto-approve tfplan
                '''
            }
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
