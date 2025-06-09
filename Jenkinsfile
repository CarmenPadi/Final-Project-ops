pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-devops-app'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Cloning repository and checking out the main branch"
                    sh 'git fetch --all'
                    sh 'git checkout main'
                    sh 'git pull origin main'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image with tag ${DOCKER_TAG}"
                    def version = "${BUILD_NUMBER}"
                    sh "docker build -t $DOCKER_IMAGE:$version ."
                    sh "docker tag $DOCKER_IMAGE:$version $DOCKER_IMAGE:latest"
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests in Docker container"
                    sh "docker run -d -p 3000:3000 $DOCKER_IMAGE:$DOCKER_TAG"
                }
            }
        }

        stage('Cleanup Old Containers') {
            steps {
                script {
                    echo 'Cleaning up stopped Docker containers (not affecting currently running ones)'
                    sh 'docker container prune -f || true'
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    echo 'Deploying to staging...'
                    sh "docker run -d -p 4000:3000 $DOCKER_IMAGE:$BUILD_NUMBER"
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    echo 'Deploying to production...'
                    sh "echo ${BUILD_NUMBER} > last_successful_version.txt"
                    archiveArtifacts artifacts: 'last_successful_version.txt', onlyIfSuccessful: true
                }
            }
        }
    }

    post {
        always {
            echo 'Build completed'
        }
        success {
            emailext (
                to: 'm.padillatrevino.558@studms.ug.edu.pl',
                from: 'mc.padillat@gmail.com',
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' succeeded.",
                mimeType: 'text/plain',
            )
        }
        failure {
            emailext (
                to: 'm.padillatrevino.558@studms.ug.edu.pl',
                from: 'mc.padillat@gmail.com',
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' failed.",
                mimeType: 'text/plain',
            )
            echo 'Deployment failed. Triggering rollback...'
            sh './rollback.sh'
        }
    }
}
