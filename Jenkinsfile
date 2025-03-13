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
                    // Strip the 'origin/' prefix if it exists and get the branch name
                    def branchName = env.GIT_BRANCH.replaceFirst("origin/", "")
                    // Generate image tag using the branch name and build ID
                    def imageTag = "${branchName}-${env.BUILD_ID}"
                    // Build Docker image using the generated tag
                    sh "docker build -t anismullani/node-docker-example:${imageTag} ."
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Strip the 'origin/' prefix if it exists and get the branch name
                    def branchName = env.GIT_BRANCH.replaceFirst("origin/", "")
                    // Generate image tag using the branch name and build ID
                    def imageTag = "${branchName}-${env.BUILD_ID}"
                    // Run tests inside the Docker container
                    sh "docker run --rm anismullani/node-docker-example:${imageTag} npm test"
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
                    // Strip the 'origin/' prefix if it exists and get the branch name
                    def branchName = env.GIT_BRANCH.replaceFirst("origin/", "")
                    // Generate image tag using the branch name and build ID
                    def imageTag = "${branchName}-${env.BUILD_ID}"
                    // Push the Docker image to Docker Hub
                    sh "docker push anismullani/node-docker-example:${imageTag}"
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    // Strip the 'origin/' prefix if it exists and get the branch name
                    def branchName = env.GIT_BRANCH.replaceFirst("origin/", "")
                    // Generate image tag using the branch name and build ID
                    def imageTag = "${branchName}-${env.BUILD_ID}"
                    // Deploy Docker container to a staging environment
                    sh "docker run -d --name node-docker-app -p 8080:8080 anismullani/node-docker-example:${imageTag}"
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

