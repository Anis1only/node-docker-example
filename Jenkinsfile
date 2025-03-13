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
                    // Build Docker image from the Dockerfile in the repo
                    sh 'docker build -t anismullani/node-docker-example:${BRANCH_NAME}-${BUILD_ID} .'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests inside the Docker container
                    sh 'docker run --rm anismullani/node-docker-example:${BRANCH_NAME}-${BUILD_ID} npm test'
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
                    sh 'docker push anismullani/node-docker-example:${BRANCH_NAME}-${BUILD_ID}'
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    // Deploy Docker container to a staging environment
                    // Example: Running Docker container on the staging server
                    sh 'docker run -d --name node-docker-app -p 8080:8080 anismullani/node-docker-example:${BRANCH_NAME}-${BUILD_ID}'
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
