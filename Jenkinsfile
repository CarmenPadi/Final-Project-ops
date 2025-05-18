pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-devops-app' // Name of the Docker image
        DOCKER_TAG = 'latest' // Docker tag
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Cloning the GitHub repository
                git 'https://github.com/CarmenPadi/Final-Project-ops.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // If you have tests, run them here (for now we just run the app)
                    sh 'docker run -d -p 3000:3000 $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    // Deploy the app (for simplicity, here we just print a message)
                    echo 'Deploying to production...'
                    // Add your deployment logic here (e.g., pushing to a production environment)
                }
            }
        }
    }

    post {
        always {
            // Cleanup: stop and remove containers after the build is finished
            sh 'docker ps -q --filter "ancestor=$DOCKER_IMAGE" | xargs docker stop || true'
            sh 'docker ps -a -q --filter "ancestor=$DOCKER_IMAGE" | xargs docker rm || true'
        }
    }
}
