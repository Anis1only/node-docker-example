pipeline {
    agent any

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
                    // Fix for empty BRANCH_NAME, set default if not provided
                    def imageTag = "${BRANCH_NAME ?: 'default'}-${BUILD_ID}"
                    // Build Docker image with proper tag format
                    sh "docker build -t anismullani/node-docker-example:${imageTag} ."
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests inside the Docker container
                    sh "docker run --rm anismullani/node-docker-example:${BRANCH_NAME ?: 'default'}-${BUILD_ID} npm test"
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using Jenkins credentials
                    withCredentials([usernamePassword(credentialsId: 'docker-credentials-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        // Use the credentials in the Docker login command
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    sh "docker push anismullani/node-docker-example:${BRANCH_NAME ?: 'default'}-${BUILD_ID}"
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    // Deploy Docker container to a staging environment
                    sh "docker run -d --name node-docker-app -p 8080:8080 anismullani/node-docker-example:${BRANCH_NAME ?: 'default'}-${BUILD_ID}"
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
