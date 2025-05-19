pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-devops-app' // Name of the Docker image
        DOCKER_TAG = 'latest' // Docker tag
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Clone the repository and check out the main branch explicitly
                    echo "Cloning repository and checking out the main branch"
                    sh 'git fetch --all'
                    sh 'git checkout main' // Ensure we're on the main branch
                    sh 'git pull origin main' // Ensure the latest from the main branch
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image with tag ${DOCKER_TAG}"
                    sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
                    sh 'docker tag $DOCKER_IMAGE:$DOCKER_TAG $DOCKER_IMAGE:latest'
	        }
	    }
         }
        stage('Run Tests') {
            steps {
		script {
		    // Run the app or your tests here
                    echo "Running tests in Docker container"
                    sh 'docker run -d -p 3000:3000 $DOCKER_IMAGE:$DOCKER_TAG'
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    // Deploy the app
                    echo 'Deploying to production...'
            }
        }
    }
}

    post {
        always {
            // Cleanup: stop and remove containers after the build is finished
            echo 'Cleaning up Docker containers'
            sh 'docker ps -q --filter "ancestor=$DOCKER_IMAGE" | xargs docker stop || true'
            sh 'docker ps -a -q --filter "ancestor=$DOCKER_IMAGE" | xargs docker rm || true'
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
    }
}
