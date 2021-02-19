pipeline {
    agent any
    triggers {
        pollSCM '* * * * *'
    }
    environment {
        APP_HOME = "$JENKINS_HOME/workspace/2020_03_DO_Boston_casestudy_part_1/2020_03_DO_Boston_casestudy_part_1/"
        DOCKER_HUB_REPO = "pouellette123/capstone"
        CONTAINER_NAME = "capstone"
    }
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Clean Up') {
            steps {
                sh 'rm -rf $APP_HOME'
            }
        }
        stage('Git Clone Repository') {
            steps {
                sh 'git clone https://github.com/pouellette123/2020_03_DO_Boston_casestudy_part_1'
            }
        }
        stage('Build the Docker Image') {
            steps {
                sh 'docker image build -t $DOCKER_HUB_REPO:latest $APP_HOME/'
                sh 'docker image tag $DOCKER_HUB_REPO:latest $DOCKER_HUB_REPO:$BUILD_NUMBER'
            }
        }
        stage('Run the Container') {
            steps {
                sh 'if (docker ps | grep $CONTAINER_NAME); then docker stop $CONTAINER_NAME;fi'
                sh 'if (docker image ls | grep $CONTAINER_NAME); then docker rm $CONTAINER_NAME;fi'
                sh 'docker run --name $CONTAINER_NAME -d -p 8079:8079 $DOCKER_HUB_REPO:$BUILD_NUMBER'
            }
        }
        stage('Test the Container') {
            steps {
                sh 'curl -s --head  --request GET  10.0.0.143:8079 | grep 200'
            }
        }
        stage('Push the Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER1', passwordVariable: 'PASS1')]) {
                    sh 'docker login -u "$USER1" -p "$PASS1"'
                }
                //  Pushing Image to Repository
                sh 'docker push $DOCKER_HUB_REPO:$BUILD_NUMBER'
                sh 'docker push $DOCKER_HUB_REPO:latest'
//                echo "Image built and pushed to repository"
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'key3', keyFileVariable: 'KEY', usernameVariable: 'USERSSH')]) {
                        sh 'ssh -i ${KEY} ${USERSSH}@10.0.0.143 -C \"kubectl set image deployment/capstone-deployment capstone-container=${DOCKER_HUB_REPO}:${BUILD_NUMBER}\"'
                }        
            }
        }
    }
}
