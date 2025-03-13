pipeline {
    agent any

    environment {
        // Fallback if BRANCH_NAME is not available, using 'master' or 'default'
        IMAGE_TAG = "${env.GIT_BRANCH ?: 'master'}-${env.BUILD_ID}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clone the repository from GitHub
                git 'https://github.com/Anis1only/node-docker-example.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using the IMAGE_TAG variable
                    sh "docker build -t anismullani/node-docker-example:${env.IMAGE_TAG} ."
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests inside the Docker container
                    sh "docker run --rm anismullani/node-docker-example:${env.IMAGE_TAG} npm test"
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using Jenkins credentials
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    sh "docker push anismullani/node-docker-example:${env.IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    // Deploy Docker container to a staging environment
                    sh "docker run -d --name node-docker-app -p 8080:8080 anismullani/node-docker-example:${env.IMAGE_TAG}"
                }
            }
        }
    }

    post {
        success {
            echo "Build, test, and deployment were successful."
        }
        failure {
            echo "There was a failure in the pipeline."
        }
        always {
            // Clean up Docker resources after the build
            sh 'docker system prune -f'
        }
    }
}
