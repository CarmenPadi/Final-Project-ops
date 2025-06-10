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

        stage('Build Docker Images with Compose') {
            steps {
                script {
                    echo "Building Docker images via docker-compose"
                    sh 'docker-compose build'
                    echo "Tagging image for deployment"
                    sh "docker tag my-devops-app:latest my-devops-app:${BUILD_NUMBER}"
                }
            }
        }

        stage('Start Containers') {
            steps {
                script {
                    echo "Starting containers with docker-compose"
                    sh 'docker-compose up -d'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests against app container"
                    sh 'curl -f http://localhost:3000 || exit 1'
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

        //stage('Force Failure for Rollback Test') {
          // steps {
            //    script {
              //      echo "🚨 Forcing failure to test rollback"
                //    error("Intentional failure to trigger rollback")
           //     }
          //  }
      //  }

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
