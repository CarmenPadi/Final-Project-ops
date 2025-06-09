pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-devops-app'
        DOCKER_TAG = 'latest'
        VERSION = "${BUILD_NUMBER}"
        TEST_CONTAINER_NAME = "test_container_${BUILD_NUMBER}"
        STAGING_CONTAINER_NAME = "staging_container_${BUILD_NUMBER}"
        PROD_CONTAINER_NAME = "prod_container_${BUILD_NUMBER}"
    }

    stages {

        stage('Initial Cleanup (Test Containers Only)') {
            steps {
                script {
                    echo 'Cleaning up old test containers (non-critical)'
                    sh "docker rm -f $TEST_CONTAINER_NAME || true"
                }
            }
        }

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
                    echo "Building Docker image with version tag ${VERSION}"
                    sh "docker build -t $DOCKER_IMAGE:$VERSION ."
                    sh "docker tag $DOCKER_IMAGE:$VERSION $DOCKER_IMAGE:$DOCKER_TAG"
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests using container: $TEST_CONTAINER_NAME"
                    sh "docker run -d --name $TEST_CONTAINER_NAME -p 3000:3000 $DOCKER_IMAGE:$DOCKER_TAG"
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    echo "Deploying to staging with container: $STAGING_CONTAINER_NAME"
                    sh "docker run -d --name $STAGING_CONTAINER_NAME -p 4000:3000 $DOCKER_IMAGE:$VERSION"
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    echo "Deploying to production with container: $PROD_CONTAINER_NAME"
                    sh "docker run -d --name $PROD_CONTAINER_NAME -p 5000:3000 $DOCKER_IMAGE:$VERSION"

                    sh "echo ${VERSION} > last_successful_version.txt"
                    archiveArtifacts artifacts: 'last_successful_version.txt', onlyIfSuccessful: true
                }
            }
        }
    }

    post {
        always {
            echo 'Build completed.'
            sh "docker rm -f $TEST_CONTAINER_NAME || true"
        }

        success {
            emailext (
                to: 'm.padillatrevino.558@studms.ug.edu.pl',
                from: 'mc.padillat@gmail.com',
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "The Jenkins job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' completed successfully.",
                mimeType: 'text/plain'
            )
        }

        failure {
            emailext (
                to: 'm.padillatrevino.558@studms.ug.edu.pl',
                from: 'mc.padillat@gmail.com',
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: "The Jenkins job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' failed. Rollback triggered.",
                mimeType: 'text/plain'
            )
            echo 'Deployment failed. Triggering rollback...'
            sh './rollback.sh'
        }
    }
}
