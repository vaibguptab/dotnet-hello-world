pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')  // Set this in Jenkins Credentials
        AWS_EC2_IP = "${params.ENVIRONMENT == 'UAT' ? 'UAT-EC2-IP' : 'PROD-EC2-IP'}"
        DOCKER_IMAGE = 'vaibguptab/dotnet-hello-world'
        APP_NAME = 'dotnet-hello-world'
    }
    
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['UAT', 'PROD'], description: 'Select deployment environment')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/dotnet-hello-world.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_HUB_CREDENTIALS) {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push('latest')
                    }
                }
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {  // Set this in Jenkins Credentials
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${AWS_EC2_IP} '
                    docker pull ${DOCKER_IMAGE}:latest &&
                    docker stop ${APP_NAME} || true &&
                    docker rm ${APP_NAME} || true &&
                    docker run -d --name ${APP_NAME} -p 80:80 ${DOCKER_IMAGE}:latest
                    '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Deployment to ${params.ENVIRONMENT} environment was successful!"
        }
        failure {
            echo "Deployment failed. Check the logs for details."
        }
    }
}

