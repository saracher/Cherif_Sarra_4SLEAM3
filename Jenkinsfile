pipeline {
    agent any

    tools { 
        jdk 'JAVA_HOME' 
        maven 'M2_HOME'
    }

    environment {
        DOCKERHUB_REPO = 'sarracherif/student-management'
        DOCKER_CREDENTIALS_ID = 'jenkinsDocker'
        IMAGE_TAG = "${BUILD_NUMBER}"
        KUBE_NAMESPACE = 'tpkuber'
        DEPLOYMENT_NAME = 'spring-app'
    }

    stages {
        stage('GIT') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token',
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

        stage('MVN SonarQube') {
            steps {
               withSonarQubeEnv('sonarqubeServer') {
                   withCredentials([string(credentialsId: 'sonartoken', variable: 'SONAR_TOKEN')]) {
                       sh "mvn sonar:sonar -Dsonar.projectKey=student-management -Dsonar.login=$SONAR_TOKEN"
                   }
               }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKERHUB_REPO:$IMAGE_TAG ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'jenkinsDocker',
                                usernameVariable: 'DOCKER_USER',
                                passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push $DOCKERHUB_REPO:$IMAGE_TAG"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
               
                sh "kubectl set image deployment/$DEPLOYMENT_NAME $DEPLOYMENT_NAME=$DOCKERHUB_REPO:$IMAGE_TAG -n $KUBE_NAMESPACE"
            }
        }
    }

    post {
        success {
            echo "Image Docker poussée et déployée avec succès sur $DOCKERHUB_REPO:$IMAGE_TAG"
        }
        failure {
            echo "Erreur dans le pipeline."
        }
    }
}
