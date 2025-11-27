pipeline {
    agent any

    tools {
        jdk 'JAVA_HOME'
        maven 'M2_HOME'
    }

    environment {
        DOCKER_CREDENTIALS_ID = 'sar123'
        IMAGE_NAME = 'sarracherif/student-management'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('GIT') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/saracher/Cherif_Sarra_4SLEAM3.git'
            }
        }

        stage('Compile Stage') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Package Stage') {
            steps {
                sh 'mvn package -DskipTests'
                sh 'ls -la target'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", 
                                                 usernameVariable: 'DOCKER_USER', 
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    // Note l'utilisation de quotes simples pour sécuriser le secret
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        failure {
            echo 'Erreur dans le pipeline.'
        }
    }
}
